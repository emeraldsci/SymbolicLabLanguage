(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*GenerateExperimentReview*)


(* ::Section:: *)
(*Source*)


(* ::Subsection:: *)
(* GenerateExperimentReview Constants *)

$ReviewImageResolution = 400;

$ReviewImageSize = 200;

$ReviewPlotSize = 450;

$ReviewGridSpacings = 2;

$ZoomableBoolean := !TrueQ[ECL`$ManifoldRuntime];

$UnitOperationIconFileNames = {
    LabelContainer -> "DefineIcon.png",
    LabelSample -> "DefineIcon.png",
    Transfer -> "TransferIcon.png",
    Mix -> "MixIcon.png",
    Incubate -> "IncubateIcon.png",
    Aliquot -> "AliquotIcon.png",
    FillToVolume -> "FillToVolumeIcon.png",
    Wait -> "WaitIcon.png",
    Consolidate -> "ConsolidateIcon.png",
    Filter -> "FilterIcon.png",
    MagneticBeadSeparation -> "MoveToMagnetIcon.png",
    Centrifuge -> "CentrifugeIcon.png",
    Pellet -> "CentrifugeIcon.png",
    Cover -> "CoverIcon.png",
    Uncover -> "CoverIcon.png",
    AdjustpH -> "AdjustpHIcon.png",
    AbsorbanceSpectroscopy -> "PlateReader-Absorbance.png",
    AbsorbanceIntensity -> "PlateReader-Absorbance.png",
    AbsorbanceKinetics -> "PlateReader-Absorbance.png",
    LuminescenceSpectroscopy -> "PlateReader-Luminescence.png",
    LuminescenceIntensity -> "PlateReader-Luminescence.png",
    LuminescenceKinetics -> "PlateReader-Luminescence.png",
    FluorescenceSpectroscopy -> "PlateReader-Luminescence.png",
    FluorescenceIntensity -> "PlateReader-Luminescence.png",
    FluorescenceKinetics -> "PlateReader-Luminescence.png",
    FluorescencePolarization -> "PlateReader-Combined.png",
    FluorescencePolarizationKinetics -> "PlateReader-Combined.png",
    AlphaScreen -> "PlateReader-Luminescence.png",
    Nephelometry -> "PlateReader-Combined.png",
    NephelometryKinetics -> "PlateReader-Combined.png",
    Grind -> "Grind.png",
    Autoclave -> "autoclave.png",
    ImageSample -> "ImageSample.png",
    MeasureVolume -> "MeasureVolume.png",
    MeasureWeight -> "MeasureWeight.png",
    KarlFischerTitration -> "KarlFischerIcon.png"
};

$UnitOperationIconFilePaths := Keys[#] -> Import[FileNameJoin[{PackageDirectory["Experiment`"], "resources", "images", Values[#]}]]& /@ $UnitOperationIconFileNames;

$PlotTableGridOptions = {
    Alignment -> {{Center, Left}},
    AllowedDimensions -> Automatic,
    AllowScriptLevelChange -> True,
    AutoDelete -> False,
    Background -> {None, {{RGBColor[0.8862745098039215`, 0.8862745098039215`, 0.8862745098039215`], None}}},
    BaselinePosition -> Automatic,
    BaseStyle -> {},
    DefaultBaseStyle -> "Grid",
    DefaultElement -> "\[Placeholder]",
    Dividers -> {
        {
            Directive[RGBColor[0.796078431372549`, 0.796078431372549`, 0.796078431372549`], Thickness[1]],
            {
                1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                -1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                2 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]]
            }
        },
        {
            Directive[RGBColor[0.796078431372549`, 0.796078431372549`, 0.796078431372549`], Thickness[1]],
            {
                1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                -1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                2 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]]
            }
        }
    },
    Frame -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`], Thickness[1]],
    FrameStyle -> Automatic,
    ItemSize -> {{All,All}},
    ItemStyle -> None,
    Spacings -> {Automatic, 1},
    StripOnInput -> False
};

$PlayButtonGraphic = Graphics[
    {
        (* Set some transparency so the image can be seen through the graphic *)
        Opacity[0.7],
        (* Ccreate the circle using ECL approved gray *)
        LCHColor[0.8, 0, 0], Disk[{1, 3.5}, 6],
        (* Next we put a white triangle on top *)
        LCHColor[1, 0, 0], Triangle[{{-0.5, 0}, {-0.5, 7}, {3.5, 3.5}}]
    },
    (* Scale the graphic to be 0.5x of the smaller image dimension *)
    ImageSize -> 15
];

(* Set the colors we use in plots/charts so that they are consistent. *)
$ExperimentalResultColor = RGBColor["#3B719F"];
$TheoreticalResultColor = RGBColor["#FF0000"];
$AcceptableRangeColor = RGBColor["#98FB98"];

(* ::Subsection:: *)
(* GenerateExperimentReview Options *)


DefineOptions[GenerateExperimentReview,
    Options:>{
        {
            PrimaryData -> Automatic,
            ListableP[Alternatives[{_String, Alternatives["Subsection", "Subsubsection", "Text"]}, Sequence@@supportedInputTypes]],
            "Set of information the represents the core experimental results that is used instead of the default display in the form of {{\"HPLC Sample Data\", \"Subsection\"}, {\"Chromatograms from input sample injections.\", \"Text\"}, PlotObject[Object[Protocol, HPLC, \"My Protocol\"]]}. This will be included in the report under the \"Primary Data\" section."
        },
        {
            SecondaryData -> Automatic,
            ListableP[Alternatives[{_String, Alternatives["Subsection", "Subsubsection", "Text"]}, Sequence@@supportedInputTypes]],
            "Set of peripheral information collected during experiment execution that is used instead of the default display in the form of {{\"HPLC Blank Data\", \"Subsection\"}, {\"Chromatograms from blank sample injections.\", \"Text\"}, PlotObject[Object[Protocol, HPLC, \"My Protocol\"][BlankData]]}. This will be included in the report under the \"Secondary Data\" section."
        },
        {
            Preview -> False,
            BooleanP,
            "Indicates if a copy of the formatted review notebook should be opened as a scratch page in your Command Center Desktop session. A local copy of the file can be found in the $TemporaryDirectory."
        },
        UploadOption
    }
];


(* ::Subsection:: *)
(* GenerateExperimentReview Messages *)
GenerateExperimentReview::ProtocolNotStarted = "The input protocol, `1`, has the Status -> `2`. A review notebook can only be generated for actively running or completed protocols. Please check the Experiments dashboard for an update on the protocol.";
GenerateExperimentReview::CanceledProtocol = "The input protocol, `1`, has the Status -> `2`. No information is available to generate a review notebook. Please select an actively running or completed protocol from the Experiments dashboard.";
Warning::IncompleteProtocol = "The input protocol, `1`, has the Status -> `2`. Please note that the review notebook will contain only partial information, reflecting the details available up to the point of its creation for the incomplete protocol.";

(* ::Subsection:: *)
(* GenerateExperimentReview core function *)


(* core function that is used to generate a report for the input protocol *)
GenerateExperimentReview[protocol:ObjectP[Object[Protocol]], myOptions:OptionsPattern[GenerateExperimentReview]] := Module[
    {
        safeOps, customPrimaryDataOption, customSecondaryDataOption, previewOption, uploadOption, protocolTiming,
        cache, protocolPacket, unformattedPrimaryData, initialLinkButtons, initialCloudFileBlobs, hiddenOptions,
        allContentList, formattedNotebookContent, notebookPageContent, fileNamePath, protocolNotebook, createdNB,
        cloudFilePacket, cloudFileObject, protocolUpdatePacket, unformattedSecondaryData, experimentFunction,
        unformattedEnvironmentalData, unformattedSampleData, unformattedInstrumentData, unformattedPricingData,
        protocolInspection, unformattedProtocolInformation, sllDistro, unresolvedProtocolOptions, unresolvedOptionsTable,
        resolvedProtocolOptions, resolvedOptionsTable, progressFraction, progressStatus, temporaryCell, reviewNotebookName
    },

    (* Check that we are not working with an imaginary input *)
    If[!DatabaseMemberQ[protocol],
        Message[Error::ObjectDoesNotExist, ToString[protocol]];
        Return[$Failed]
    ];

    (* before we start generating things, let's save values of global symbols so we can reset at the end *)
    initialLinkButtons = $LinkButtons;
    initialCloudFileBlobs = $CloudFileBlobs;

    (* now lets set the above two to True so we get the interactive buttons *)
    $LinkButtons = True;
    $CloudFileBlobs = True;

    (* lookup safe options *)
    safeOps = SafeOptions[GenerateExperimentReview, ToList[myOptions]];

    (* assign the option values *)
    {
        customPrimaryDataOption,
        customSecondaryDataOption,
        previewOption,
        uploadOption
    } = Lookup[safeOps,
        {
            PrimaryData,
            SecondaryData,
            Preview,
            Upload
        }
    ];

    (* Download to cache *)
    {
        {protocolPacket},
        {sllDistro}
    } = Download[
        {
            protocol,
            $Distro
        },
        {
            {Packet[Status, DateStarted, DateEnqueued, DateCompleted, ResolvedOptions, UnresolvedOptions, Notebook]},
            {Commit}
        }
    ];

    (* Return early with an error if there protocol has not even started yet *)
    Switch[Lookup[protocolPacket, Status],
        Alternatives[InCart, Backlogged],
            (
                Message[GenerateExperimentReview::ProtocolNotStarted, ObjectToString[Download[protocol, Object]], Lookup[protocolPacket, Status]];
                Return[$Failed]
            ),
        Canceled,
            (
                Message[GenerateExperimentReview::CanceledProtocol, ObjectToString[Download[protocol, Object]], Lookup[protocolPacket, Status]];
                Return[$Failed]
            ),
        Alternatives[ShippingMaterials, Processing, Aborted, RepairingInstrumentation],
            Message[Warning::IncompleteProtocol, ObjectToString[Download[protocol, Object]], Lookup[protocolPacket, Status]];,
        _,
            Null
    ];

    (**** Protocol timing ****)
    protocolTiming = Grid[
        {
            {Style["Date Enqueued: ", Italic, "Helvetica"], Lookup[protocolPacket, DateEnqueued]},
            {Style["Date Started: ", Italic, "Helvetica"], If[NullQ[Lookup[protocolPacket, DateStarted]], "N/A", Lookup[protocolPacket, DateStarted]]},
            {Style["Date Completed: ", Italic, "Helvetica"], If[NullQ[Lookup[protocolPacket, DateCompleted]], "N/A", Lookup[protocolPacket, DateCompleted]]}
        },
        Alignment -> {{Right, Left}},
        Spacings -> {1, 1},
        Dividers -> {
            {{Directive[Opacity[0]]}},
            {
                Directive[LCHColor[0.8,0,0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4,0,0], Thickness[1]],
                    -1 -> Directive[LCHColor[0.4,0,0], Thickness[1]]
                }
            }
        }
    ];

    (* Progress bar *)
    progressFraction = 0; progressStatus = "";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Primary Data ****)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "plotting primary data";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (* When the user gives us a value, we just need to plug it in, otherwise we generate it *)
    unformattedPrimaryData = If[MatchQ[customPrimaryDataOption, Alternatives[Automatic, NullP]],
        getPrimaryData[protocol],
        customPrimaryDataOption
    ];
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressFraction = 0.1;
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Secondary Data ****)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "plotting secondary data";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (* When the user gives us a value, we just need to plug it in, otherwise we generate it *)
    unformattedSecondaryData = If[MatchQ[customSecondaryDataOption, Alternatives[Automatic, NullP]],
        getSecondaryData[protocol],
        getSecondaryData[protocol, CustomData -> customSecondaryDataOption]
    ];
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress bar *)
    progressFraction = 0.3;
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Environmental Data ****)
    (* update progress status *)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "plotting environmental data";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
    (* env data *)
    unformattedEnvironmentalData = getEnvironmentalData[protocol];
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress bar *)
    progressFraction = 0.4;
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Input/Output Sample Data ****)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "assembling sample tables";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
    (* sample data *)
    unformattedSampleData = getSampleData[protocol];
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress bar *)
    progressFraction = 0.5;
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Instrument Data ****)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "assembling instrument tables";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
    (* instrument data *)
    unformattedInstrumentData = getInstrumentData[protocol];
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress bar *)
    progressFraction = 0.6;
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Pricing Data ****)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "generating cost tables";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
    (* pricing *)
    unformattedPricingData = getPricingData[protocol];
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress bar *)
    progressFraction = 0.7;
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Protocol and Command ****)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "assembling options tables";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (* Output of Inspect *)
    protocolInspection = ECL`Inspect[protocol, Developer -> False];

    (* before we put together the options tables, let's get the options that are hidden so we can skip them from resolved *)
    (*Get our experiment function we're being called from.*)
    experimentFunction = FirstCase[
        Normal@Experiment`Private`experimentFunctionTypeLookup,
        (Verbatim[Rule][function_, Lookup[protocolPacket, Type] | {___, Lookup[protocolPacket, Type], ___}] :> function),
        Null (* default if nothing is found *)
    ];

    (*Get the options for the experiment Function.*)
    hiddenOptions = ToExpression@Flatten@Lookup[
        Cases[OptionDefinition[experimentFunction], KeyValuePattern["Category" -> "Hidden"]],
        "OptionName",
        {}
    ];

    (* Unresolved options value from protocol packet - remove Nulls and Automatics *)
    unresolvedProtocolOptions = Normal@KeyDrop[
        DeleteCases[ToList@Lookup[protocolPacket, UnresolvedOptions], Alternatives[_ -> (NullP | ListableP[Automatic]), NullP]],
        hiddenOptions
    ];

    (* Unresolved options table *)
    unresolvedOptionsTable = If[Length[unresolvedProtocolOptions] > 1,
            PlotTable[Transpose[{Keys[unresolvedProtocolOptions], Values[unresolvedProtocolOptions]}],
                TableHeadings -> {Range[Length[unresolvedProtocolOptions]], {"Option Name", "Value"}},
                Background -> tableBackground[unresolvedProtocolOptions]
        ]
    ];

    (* Unresolved options value from protocol packet - remove Nulls and Automatics *)
    resolvedProtocolOptions = Normal@KeyDrop[
        DeleteCases[ToList@Lookup[protocolPacket, ResolvedOptions], Alternatives[_ -> (NullP | ListableP[Automatic]), NullP]],
        hiddenOptions
    ];

    (* Unresolved options table *)
    resolvedOptionsTable = If[Length[resolvedProtocolOptions] > 1,
        PlotTable[Transpose[{Keys[resolvedProtocolOptions], Values[resolvedProtocolOptions]}],
            TableHeadings -> {Range[Length[resolvedProtocolOptions]], {"Option Name", "Value"}},
            Background -> tableBackground[resolvedProtocolOptions]
        ]
    ];

    (* Put the command and the inspection table together *)
    unformattedProtocolInformation = Join[
        (*{"Command", "Subsection", Open},
        recreatedCommand,*)

        (* header for options table should be skipped if we don't have either table *)
        If[Or[!NullQ[unresolvedOptionsTable], !NullQ[resolvedOptionsTable]],
            {
                {"Options Tables", "Subsection", Close}
            },
            {}
        ],
        (* unresolved options table and header*)
        If[!NullQ[unresolvedOptionsTable],
            {
                {"User-Specified Options", "Subsubsection", Open},
                {"The non-default option values included in the experiment command.", "Text"},
                unresolvedOptionsTable
            },
            {}
        ],
        (* resolved options table and header *)
        If[!NullQ[resolvedOptionsTable],
            {
                {"Calculated Options", "Subsubsection", Open},
                {"All option values (user-specified and default calculations).", "Text"},
                resolvedOptionsTable
            },
            {}
        ],
        {
            {"Protocol Object", "Subsection", Close},
            protocolInspection
        }
    ];
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress bar *)
    progressFraction = 0.8;
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Notebook content assembly ****)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "assembling notebook";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
    (* Combine all the lists into a mega list that we can format into cell data *)
    allContentList = Join[
        {{"Report for "<>ObjectToString[Download[protocol, Object]], "Chapter", Open}},

        {protocolTiming},

        If[Length[unformattedPrimaryData]>0,
            {{"Primary Data", "Section", Open}},
            {}
        ],
        unformattedPrimaryData,


        If[Length[unformattedSecondaryData]>0,
            {{"Secondary Data", "Section", Open}},
            {}
        ],
        unformattedSecondaryData,

        If[Length[unformattedEnvironmentalData]>0,
            {{"Environmental Data", "Section", Open}},
            {}
        ],
        unformattedEnvironmentalData,

        If[Length[unformattedSampleData]>0,
            {{"Sample Data", "Section", Open}},
            {}
        ],
        unformattedSampleData,

        If[Length[unformattedInstrumentData]>0,
            {{"Instrument Data", "Section", Open}},
            {}
        ],
        unformattedInstrumentData,

        If[Length[unformattedPricingData]>0,
            {{"Pricing Data", "Section", Open}},
            {}
        ],
        unformattedPricingData,

        {{"Protocol Data", "Section", Open}},
        unformattedProtocolInformation,

        {
            {"Software Version", "Section", Close},
            {{StyleBox["Machine Name: ", FontWeight -> "Bold"], $MachineName}, "Text"},
            {{StyleBox["Application: ", FontWeight -> "Bold"], ToString[$ECLApplication]}, "Text"},
            {{StyleBox["SLL Version: ", FontWeight -> "Bold"], $SLLVersion}, "Text"},
            If[!MatchQ[sllDistro, $Failed],
                {{StyleBox["SLL Commit: ", FontWeight -> "Bold"], sllDistro}, "Text"},
                Nothing
            ],
            {{StyleBox["Mathematica Version: ", FontWeight -> "Bold"], $Version}, "Text"}
        }
    ];

    (* Do the formatting using our helper *)
    formattedNotebookContent = formatForNotebook[allContentList];

    (* Put together the notebook page *)
    notebookPageContent = Notebook[formattedNotebookContent,
        CellGrouping -> Manual,
        WindowSize -> {1024, 800},
        WindowMargins -> {{0, Automatic}, {Automatic, 0}},
        StyleDefinitions -> "CommandCenter.nb"
    ];

    (* Create a name for the local and cloud file *)
    reviewNotebookName = "Protocol_ID_"<>StringTrim[Download[protocol, ID], "id:"];

    (* Create a path so that we can export the notebook *)
    fileNamePath = FileNameJoin[{$TemporaryDirectory, reviewNotebookName<>".nb"}];

    (* Save the page locally so we can upload and/or preview it
        Note: this also overwrites if the fileNamePath already exists *)
    createdNB = UsingFrontEnd[NotebookPut[notebookPageContent]];
    UsingFrontEnd[NotebookSave[createdNB, fileNamePath]];

    (**** Upload Preparation ****)
    (* get the protocol's notebook*)
    protocolNotebook = Download[Lookup[protocolPacket, Notebook], Object];

    (* Create the packet for cloud file upload and append FileName to the packet since there is no option for that *)
    cloudFilePacket = If[uploadOption,
        Append[
            UploadCloudFile[fileNamePath,
                Notebook -> protocolNotebook,
                Upload -> False (* Don't upload yet *)
            ],
            FileName -> StringReplace[reviewNotebookName, "_ID_" -> " id:"]
        ],
        <||>
    ];

    cloudFileObject = Lookup[cloudFilePacket, Object, Null];

    (* Create another packet to link the cloudfile to the ExperimentReviewNotebook field *)
    protocolUpdatePacket = If[uploadOption,
        <|
            Object -> Download[protocol, Object],
            ExperimentReviewNotebook -> Link[cloudFileObject]
        |>
    ];
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress bar *)
    progressFraction = 0.9;
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];

    (**** Output ****)
    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "uploading";
    temporaryCell = PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
    If[uploadOption,
        Block[{$Notebook = protocolNotebook},
            Upload[{cloudFilePacket, protocolUpdatePacket}]
        ]
    ];
    (* update progress bar *)
    progressFraction = 0.95;

    (* now that the notebook is generated, we can reset the global symbols to their original values *)
    $LinkButtons = initialLinkButtons;
    $CloudFileBlobs = initialCloudFileBlobs;

    (* delete the previous progress bar *)
    NotebookDelete[temporaryCell];
    (* update progress status *)
    progressStatus = "finalizing";

    Which[
        (* If both are True, open up the cloud file and output the cloud file object *)
        And[previewOption, uploadOption],
            progressFraction = 1;
            PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
            OpenCloudFile[cloudFileObject];
            cloudFileObject,
        (* If only preview is True, open up the local file as a scratch page and output the file path*)
        previewOption,
            progressFraction = 1;
            PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
            NotebookOpen[fileNamePath];
            fileNamePath,
        (* If only upload is True, just output the cloud file *)
        uploadOption,
            progressFraction = 1;
            PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
            cloudFileObject,
        (* If both options are False, then we just output the path to the local file *)
        True,
            progressFraction = 1;
            PrintTemporary[Labeled[ProgressIndicator[progressFraction], progressStatus]];
            fileNamePath
    ]
];


(* ::Subsection:: *)
(* helpers *)


(*formatForNotebook*)
(* This function should take a singleton or list of arbitrary header strings, graphics and tables and outputs a formatted version with the appropriate headers that allow it be directly plugged into notebook writing functions*)
(* Input style for the second input (single or an arbitrary combination of):
    _Graphics are good to go
    _Pane are good to go
    _String must be in the format {"your string goes here", "Subsection"|"Subsubsection"|"Text"} - higher section levels are constant
 *)
supportedCellStyles = {"Chapter", "Section", "Subsection", "Subsubsection", "Subsubsubsection", "Text", "Code", "Title"};
supportedHeaderStyles = {"Chapter", "Section", "Subsection", "Subsubsection", "Subsubsubsection", "Title"};
supportedBoxStyles = {
    _StyleBox,
    _SuperscriptBox,
    _SubsuperscriptBox,
    _OverscriptBox,
    _UnderscriptBox,
    _UnderoverscriptBox,
    _FractionBox,
    _SqrtBox,
    _RadicalBox,
    _Cell
};
supportedInputTypes = {
    _Graphics,  (* Plot functions *)
    _Pane,      (* PlotTable *)
    _Grid,      (* MM Grid *)
    _Row,
    _Column,
    _SlideView,
    _MenuView,
    _OpenerView,
    _Image,
    _Overlay,
    _Dynamic,
    _DynamicModule,
    _Button,
    _Magnify,
    _Labeled,
    _Legended,
    _Manipulate
};

formatForNotebook[
    unformattedInput:ListableP[Alternatives[
        {Alternatives[_String, {Alternatives[_String, Sequence@@supportedBoxStyles]..}], Alternatives@@supportedCellStyles},
        {Alternatives[_String, {Alternatives[_String, Sequence@@supportedBoxStyles]..}], Alternatives@@supportedHeaderStyles, Alternatives[Open, Close]},
        Sequence@@supportedInputTypes
    ]]
] := Module[
    (* local variables *)
    {listedUnformattedInput, possibleHeaders, nestByHeader, nestedInputList, nestedCellsBoxes},

    (* if the input is a singleton, we should convert it to a list, otherwise we already have a list *)
    listedUnformattedInput = If[Or[MatchQ[unformattedInput, {_String|_List, _String, ___}], Length[unformattedInput]<2],
        List[unformattedInput],
        unformattedInput
    ];

    (* Create a nested list by nesting each lower header level in a list
    Each level of nesting can then be converted into CellGroupData so that they can be opened or closed in the final notebook

        example input:
        {
            {"header 1", "Chapter"},
            {"header 2", "Section"},
            {"text", "Text"},
            {"header 3", "Subsection"},
        }
        expected output:
        {
            {"header 1", "Chapter"},
            {
                {"header 2", "Section"},
                {"text", "Text"},
                {
                    {"header 3", "Subsection"}
                }
            }
        }

    *)

    (* We need to do the nesting in reverse order where "Subsubsubsection" gets wrapped in a list on the first round,
        and then we move up to "Subsubsection" etc
        So, we will reverse the list of possible headers *)
    possibleHeaders = Reverse[supportedHeaderStyles];

    (* Function below can be used to recursively nest the list based on "possibleHeaders" *)
    nestByHeader[unnestedList_List, headerIndex_Integer] := Module[
        (* local variables *)
        {matchingIndices, allIndices, groupStartEnds},

        (* Find the indexes where the header matches
            output can be flattened because we only expect matches to be at the lowest level *)
        matchingIndices = Flatten[Position[unnestedList, {_, possibleHeaders[[headerIndex]], ___}]];

        (* Find indexes off all the other headers that are higher than the current header
            output can be flattened because we only expect matches to be at the lowest level *)
        allIndices = Sort[Flatten[Position[unnestedList, {_, Alternatives@@possibleHeaders[[headerIndex;;]], ___}]]];

        (* Create pairs of indexes that indicate the start and end of each header group *)
        groupStartEnds = Map[
            {#, SelectFirst[allIndices-1, Function[value, # <= value], -1]}&,
            matchingIndices
        ];

        (* Nest the list - we need to do this recursively from the end of the list so that the index of the things before it remain the same *)
        Fold[
            Function[{currentList, currentGroup},
                Insert[Sequence@@Reverse[TakeDrop[currentList, currentGroup]], currentGroup[[1]]]
            ],
            unnestedList,
            Reverse[groupStartEnds]
        ]
    ];

    (* Recursively apply nestByHeader on our flat list for each possible header type *)
    nestedInputList = Fold[
        nestByHeader[#1, #2]&,
        listedUnformattedInput,
        Range[Length[possibleHeaders]]
    ];

    (* Convert _Graphics and _Pane to BoxData and strings into appropriate cells *)
    nestedCellsBoxes = ReplaceAll[
        nestedInputList,
        {
            value:{_String, _String} :> Cell[value[[1]], value[[2]]], (* header, text or code cell *)
            value:{_List, _String} :> Cell[TextData[value[[1]]], value[[2]]], (* header, text or code cell - handling for formatted text with special box types *)
            value:{_String, _String, Alternatives[Open, Close]} :> {Cell[value[[1]], value[[2]]], value[[3]]}, (* header cell with Open/Close indication for cell group *)
            value:{_List, _String, Alternatives[Open, Close]} :> {Cell[TextData[value[[1]]], value[[2]]], value[[3]]}, (* header, text or code cell - handling for formatted text with special box types *)
            value:(Alternatives@@supportedInputTypes) :> Cell[BoxData[ToBoxes[value]], "Output"] (* all non-string-like data types need to be boxed *)
        }
    ];

    (* Final formatting step: Convert lists into Cell[CellGroupData[{list here}, Open/Close] *)
    Map[
        Which[
            (* figured out this case that we need to ignore from trial and error because of the way Map
                works across levels without this, some {Cell["string", "header"], Open/Close} will be converted
                to Cell[CellGroupData[{Cell["string", "header"], Open/Close}]] and that is incorrect *)
            MatchQ[#, {_Cell, Alternatives[Open, Close]}], #,
            (* If we have a list where the first header cell is a list, we need to make sure we pass Open/Close to the CellGroupData *)
            MatchQ[#, _List]&&Length[#]>1&&MatchQ[First[#], {_, Alternatives[Open, Close]}], Cell[CellGroupData[Prepend[Rest[#], First[First[#]]], Last[First[#]]]],
            (* If we just have a regular old list, convert it to CellGroupData *)
            MatchQ[#, _List]&&Length[#]>1, Cell[CellGroupData[#]],
            (* If we have a list with only 1 item, just take that item *)
            MatchQ[#, _List]&&Length[#]==1, #[[1]],
            (* Do nothing by default *)
            True, #
        ]&,
        nestedCellsBoxes,
        4 (* this should capture all the levels that we need to hit *)
    ]
];


(*tableBackground*)
(* Simple function to take either the input matrix or a number of rows and outputs a value that can be plugged into Background option of PlotTable for consistent coloring *)
DefineOptions[tableBackground,
    Options:>{
        {IncludeHeader -> True, BooleanP, "Indicate whether a darker background should be included for the column title row."}
    }
];

tableBackground[list_List, myOptions:OptionsPattern[tableBackground]] := tableBackground[Length[list], myOptions];
tableBackground[rowCount_Integer, myOptions:OptionsPattern[tableBackground]] := Module[{safeOps, includeHeaderOption},

    (* get our option values *)
    safeOps = SafeOptions[tableBackground, ToList[myOptions]];

    (* get the value of the header option *)
    includeHeaderOption = Lookup[safeOps, IncludeHeader];

    (* generate shading for rows and skip darker shading for the header depending on the option *)
    {
        None,
        {
            (* Header row will be darker than the rest *)
            If[includeHeaderOption, LCHColor[0.9, 0, 0], Nothing],
            (* Alternate between shaded and no background for the rest of the table *)
            {White, LCHColor[0.97, 0, 0]}
       }
    }
];

(*customButton*)
DefineOptions[customButton,
    Options:>{
        {Tooltip -> Automatic, _, "Value to display when the cursor is over the displayed item."},
        {CopyContent -> Automatic, _, "Value to store in the clipboard when the displayed item is clicked."},
        {FontSize -> 12, _Integer, "The non-default size to use for font that appears in the custom buttons."}
    }
];

customButton[inputValue_, myOptions:OptionsPattern[customButton]] := Module[
    (* local variables *)
    {safeOps, displayedInput, tooltipValue, resolvedTooltipValue, copyContentValue, resolvedCopyContent, fontSize},

    (* get our option values *)
    safeOps = SafeOptions[customButton, ToList[myOptions]];

    (* process our input into the display value string *)
    displayedInput = Switch[inputValue,
        ObjectP[], ObjectToString[inputValue],
        _Quantity, UnitForm[inputValue, Brackets -> False, Round -> 0.01],
        (_QuantityDistribution|_DataDistribution), unitFormDistribution[inputValue],
        _, inputValue
    ];

    (* get the tooltip value from options *)
    tooltipValue = Lookup[safeOps, Tooltip];
    (* set it to default or show the non-default value as is *)
    resolvedTooltipValue = If[MatchQ[tooltipValue, Automatic], "Click to copy", tooltipValue];

    (* get the copy content value from options *)
    copyContentValue = Lookup[safeOps, CopyContent];
    (* by default the input value will be copied to clipboard or just pass through the specified option *)
    resolvedCopyContent = If[MatchQ[copyContentValue, Automatic], inputValue, copyContentValue];

    (* get the font size *)
    fontSize = Lookup[safeOps, FontSize];

    With[
        {
            explicitDisplayedValue = displayedInput,
            explicitTooltipValue = resolvedTooltipValue,
            explicitCopyContentValue = resolvedCopyContent
        },
        Tooltip[
            Button[
                Style[explicitDisplayedValue, fontSize, "Helvetica"],
                CopyToClipboard[explicitCopyContentValue],
                Appearance -> None,
                Method -> "Queued"
            ],
            explicitTooltipValue
        ]
    ]
];


(* zoomableButton *)
zoomableButton[inputPlot_] := DynamicModule[{plotButton},
    (* Generate a button that will replace itself with the same plot wrapped in Zoomable when clicked *)
    plotButton = With[{explicitPlot = inputPlot},
        Tooltip[
            Button[
                explicitPlot,
                plotButton = Zoomable[explicitPlot],
                Appearance -> None,
                Method -> "Queued"
            ],
            "Click to enable zoom"
        ]
    ];
    (* Output the dynamic to perform the replacement *)
    Dynamic[plotButton, TrackedSymbols :> {plotButton}]
];


(*unitFormDistribution*)

DefineOptions[unitFormDistribution,
    Options :> {
        {Resolution -> 0.01, GreaterP[0] | GreaterP[0 Gram], "The resolution to which to round the distribution values."},
        {PercentForm -> False, BooleanP, "Indicates whether to express the output distribution in terms of percentages."}
    }
];

unitFormDistribution[distribution:NullP]:="N/A";

unitFormDistribution[distribution:(_QuantityDistribution|_DataDistribution|_NormalDistribution), myOptions:OptionsPattern[unitFormDistribution]]:=Module[
    (* local variables *)
    {safeOps, resolution, percentFormQ, scalar, scaledDistribution, mean, stdev, quantityUnit, unitString, roundedUnitlessMean, roundedUnitlessSTDEV},

    (* Get the Resolution and PercentForm options. *)
    safeOps = SafeOptions[unitFormDistribution, ToList[myOptions]];
    resolution = Lookup[safeOps, Resolution, 0.01];
    percentFormQ = TrueQ[Lookup[safeOps, PercentForm]];
    scalar = If[percentFormQ, 100, 1];

    (* Scale the value so that it's in a reasonable unit level *)
    scaledDistribution = UnitScale[distribution];

    (* Let's get the Mean and standard Deviation *)
    mean = scalar * Mean[scaledDistribution];
    stdev = scalar * StandardDeviation[scaledDistribution];
    quantityUnit = QuantityUnit[mean];

    (* Get the units as a string *)
    unitString = Which[
        (* If the PercentForm option is True, use %. *)
        percentFormQ, "%",
        (* If there's a quantity *)
        MatchQ[quantityUnit, Except["DimensionlessUnit"]], ToString[QuantityForm[quantityUnit, "Abbreviation"]],
        (* Otherwise, Nothing. *)
        True, Nothing
    ];

    (* Round the values. If the resolution option is set as a mass, we round *)
    (* differently such that we can reflect a balance's resolution in the outputs. *)
    {roundedUnitlessMean, roundedUnitlessSTDEV} = If[MassQ[resolution],
        {
            Unitless[SafeRound[mean, resolution]],
            N @ SignificantFigures[Unitless[stdev], 1]
        },
        {
            SafeRound[Unitless[mean], resolution],
            N @ SignificantFigures[Unitless[stdev], 1]
        }
    ];

    (* Put the string together *)
    StringRiffle[{
        ToString[roundedUnitlessMean],
        "\[PlusMinus]",
        ToString[roundedUnitlessSTDEV],
        unitString
    }]
];


(*formatTitle*)
(* Font and color are from PlotTable *)
formatTitle[title_String] := Style[title, 22, FontFamily -> "Helvetica", RGBColor["#4A4A4A"]];

(* assembleSlideView *)
(* Set up a helper to assemble a slide view of information with a slider if over 10 elements.  *)
assembleSlideView[itemList_List] := SlideView[
    itemList,
    AppearanceElements -> {
        "FirstSlide", "PreviousSlide",
        "NextSlide", "LastSlide",
        If[Length[itemList] > 10,
            "SliderControl",
            Nothing
        ],
        "SlideNumber", "SlideTotal"
    },
    ControlPlacement -> {Top, Center},
    FrameMargins -> 10
];

(*getEnvironmentalData*)

Authors[getEnvironmentalData]:={"malav.desai"};

getEnvironmentalData[protocol:ObjectP[Object[Protocol]]] := Module[
    (* local variables *)
    {environmentalDataPackets, cleanEnvDataPackets},

    (* Get the data objects *)
    environmentalDataPackets = Quiet[
        Download[
            protocol,
            Packet[EnvironmentalData[{FirstDataPoint, LastDataPoint, Sensor, TemperatureLog, RelativeHumidityLog}]]
        ],
        {Download::FieldDoesntExist}
    ];

    (* Filter out any data packets with Null log values just in case *)
    cleanEnvDataPackets = Map[
        Which[
            (* Temperature data MUST have a log *)
            And[MatchQ[#, PacketP[Object[Data, Temperature]]], !NullQ[Lookup[#, TemperatureLog]]], #,
            (* RH data MUST have a log *)
            And[MatchQ[#, PacketP[Object[Data, RelativeHumidity]]], !NullQ[Lookup[#, RelativeHumidityLog]]], #,
            (* Get rid of data objects without data *)
            True, Nothing
        ]&,
        environmentalDataPackets
    ];

    (* If there is no data, we can skip everything *)
    If[Length[cleanEnvDataPackets] > 0,
        Module[
            (* local variables*)
            {updatedEnvironmentalPackets, sortedEnvironmentalDataPackets, envTablePlot, temperatureDataPackets,
                rhDataPackets, temperatureDataGrid, rhDataGrid},

            (* plot the data and append plot to the packet*)
            updatedEnvironmentalPackets = Map[
                Append[#,
                    "Plot" -> If[$ZoomableBoolean,
                        (* We are good to use Zoomable when not in Manifold *)
                        PlotObject[Lookup[#, Object], ImageSize -> $ReviewPlotSize, Zoomable -> $ZoomableBoolean],
                        (* When in Manifold, we will create a button to apply zoomable on demand *)
                        zoomableButton[PlotObject[Lookup[#, Object], ImageSize -> $ReviewPlotSize, Zoomable -> $ZoomableBoolean]]
                    ]
                ]&,
                cleanEnvDataPackets
            ];

            (* Sort the data packets by their first and last data points, so that they are ordered before we plot *)
            sortedEnvironmentalDataPackets = SortBy[updatedEnvironmentalPackets,
                {Lookup[#, FirstDataPoint]&, Lookup[#, LastDataPoint]&}
            ];

            (* Helper to spit out a pair of table and plot from a data packet *)
            envTablePlot[packet:PacketP[]] := Module[{envPacketKeys, envTableValues},

                (* These are the keys that we will display *)
                envPacketKeys = {Object, Sensor, FirstDataPoint, LastDataPoint};

                (* Get the values from our input packet and nest the list so each item shows up in a row *)
                envTableValues = List/@Lookup[packet, envPacketKeys];

                (* Output a table and a plot *)
                {
                    PlotTable[envTableValues,
                        TableHeadings -> {{"Data Object", "Sensor", "Starting Time", "Ending Time"}, None},
                        Background -> tableBackground[envTableValues, IncludeHeader -> False]
                    ],
                    Lookup[packet, "Plot"]
                }
            ];

            (* Find the temperature packets *)
            temperatureDataPackets = Cases[sortedEnvironmentalDataPackets, PacketP[Object[Data, Temperature]]];

            (* Create a grid of temperature data *)
            temperatureDataGrid = If[Length[temperatureDataPackets]>0,
                Grid[
                    {
                        {formatTitle["Temperature"], SpanFromLeft},
                        Sequence@@Map[
                            envTablePlot,
                            temperatureDataPackets
                        ]
                    },
                    Spacings -> $ReviewGridSpacings,
                    Dividers -> {{False, True, False}, {False, {True}}},
                    FrameStyle -> Lighter[Gray, 0.4]
                ],
                {}
            ];

            (* Find the RH packets *)
            rhDataPackets = Cases[sortedEnvironmentalDataPackets, PacketP[Object[Data, RelativeHumidity]]];

            (* Create a grid of RH data *)
            rhDataGrid = If[Length[rhDataPackets]>0,
                Grid[
                    {
                        {formatTitle["Relative Humidity"], SpanFromLeft},
                        Sequence@@Map[
                            envTablePlot,
                            rhDataPackets
                        ]
                    },
                    Spacings -> $ReviewGridSpacings,
                    Dividers -> {{False, True, False}, {False, {True}}},
                    FrameStyle -> Lighter[Gray, 0.4]
                ],
                {}
            ];

            (* Prepare the output with an explanation of the data in the section *)
            Prepend[Flatten[{temperatureDataGrid, rhDataGrid}],
                {"The temperature and/or relative humidity data collected during the execution of "<>ObjectToString[Download[protocol, Object]]<>".", "Text"}
            ]
        ],
        {}
    ]
];


(*getPricingData*)

Authors[getPricingData]:={"malav.desai"};

getPricingData[protocol:ObjectP[Object[Protocol]]] := Module[
    (* local variables *)
    {materialsPricingAssociation, materialsPricingTable, instrumentPriceAssociation, instrumentValueMessage,
        instrumentValueTable, instrumentResourceData, uniqueInstrumentCosts, totalInstrumentCosts, instrumentValueNumber},

    (** Materials pricing table **)
    (* Run PriceMaterials on our protocol *)
    materialsPricingAssociation = Quiet[PriceMaterials[protocol, OutputFormat -> Association]];

    (* If the run was successful and has values, generate a table with our custom background coloring, otherwise the output will be Null and we skip *)
    materialsPricingTable = If[!MatchQ[materialsPricingAssociation, Alternatives[NullP, {}, $Failed]],
        Module[
            (* local variables *)
            {listPriceData, listPriceTotal, combinedMaterialsPricing},

            (* Gather table related data from the associations *)
            listPriceData = Lookup[materialsPricingAssociation, {MaterialName, ValueRate, Amount, Value}];

            (* Total the prices *)
            listPriceTotal = Total[listPriceData[[All, -1]]];

            (* combine price data with subtotal, tax and total *)
            combinedMaterialsPricing = Join[
                listPriceData,
                {
                    {
                        "",
                        "",
                        Style["Total:", Bold],
                        Style["$"<>ToString[NumberForm[Unitless[SafeRound[listPriceTotal, 0.01 USD], USD], DigitBlock -> 3]], Bold]
                    }
                }
            ];

            (* Create the materials pricing table *)
            PlotTable[combinedMaterialsPricing,
                TableHeadings -> {
                    PadRight[Range[Length[listPriceData]], Length[combinedMaterialsPricing], ""],
                    {"Material", "Value Rate", "Amount", "Value"}
                },
                Dividers -> {{True, True}, {True, True, Sequence@@ConstantArray[False, Length[listPriceData]-1], True}},
                Background -> tableBackground[1],
                Round -> 0.01,
                Title -> "Materials Pricing for protocol: "<>ToString[protocol[Object]],
                ItemSize -> {{Automatic, UpTo[35]}}
            ]
        ]
    ];

    (** Instrument time pricing table **)
    (* Start by getting all the instrument pricing details from the existing function *)
    instrumentPriceAssociation = Quiet[PriceInstrumentTime[protocol, OutputFormat -> Association]];

    (* We only run this if PriceInstrumentTime gave us something useful *)
    instrumentValueTable = If[!MatchQ[instrumentPriceAssociation, Alternatives[NullP, {}, $Failed]],
        Module[
            {initialListInstrumentUtilization, listInstrumentUtilization, listValueTotal, combinedInstrumentValues},

            (* Gather table related data from the associations *)
            initialListInstrumentUtilization = Lookup[instrumentPriceAssociation, {Model, ModelName, ValueRate, Time, Value}];

            (* Substitute ID with Name where the Name is not Null *)
            listInstrumentUtilization = Map[
                Prepend[
                    #[[3;;]],
                    If[NullQ[#[[2]]], #[[1]], ReplacePart[#[[1]], -1 -> #[[2]]]]
                ]&,
                initialListInstrumentUtilization
            ];

            (* Total the value *)
            listValueTotal = Total[listInstrumentUtilization[[All, -1]]];

            (* combine price data with subtotal, tax and total *)
            combinedInstrumentValues = Join[
                listInstrumentUtilization,
                {
                    {
                        "",
                        "",
                        Style["Total:", Bold],
                        Style["$"<>ToString[NumberForm[SafeRound[Unitless[listValueTotal, USD], 0.01], DigitBlock -> 3]], Bold]
                    }
                }
            ];

            (* Original table - we are going to omit the hourly rate and value columns until the information is correctly configured in the near-future. It is currently inaccurate.
            PlotTable[combinedInstrumentValues,
                TableHeadings -> {
                    PadRight[Range[Length[listInstrumentUtilization]], Length[combinedInstrumentValues], ""],
                    {"Instrument Model", "Hourly Rate", "Utilization", "Value"}
                },
                Dividers -> {{True, True}, {True, True, Sequence@@ConstantArray[False, Length[listInstrumentUtilization]-1], True}},
                Background -> tableBackground[1],
                Round -> 0.01,
                Title -> "Instrument Pricing for protocol: " <> ToString[protocol[Object]],
                ItemSize -> {{Automatic, UpTo[35]}}
            ]*)

            (* Assemble the instrument value table *)
            PlotTable[combinedInstrumentValues[[;;-2, {1, 3}]],
                TableHeadings -> {
                    Range[Length[listInstrumentUtilization]],
                    {"Instrument Model", "Utilization"}
                },
                Dividers -> {{True, True}, {True, True, Sequence@@ConstantArray[False, Length[listInstrumentUtilization]-1], True}},
                Background -> tableBackground[1],
                Round -> 0.01,
                Title -> "Instrument Pricing for protocol: " <> ToString[protocol[Object]],
                ItemSize -> {{Automatic, UpTo[35]}}
            ]
        ],
        Null
    ];

    (** Instrument value message **)
    (* We will need to get these from the SubprotocolRequiredResources *)
    (* Download the resource data that we will need *)
    instrumentResourceData = Quiet[
        Download[protocol,
            SubprotocolRequiredResources[{Instrument[Object], Status, Instrument[Cost]}]
        ],
        {Download::FieldDoesntExist}
    ];

    (* Filter out the instrument resources that were fulfilled and where Instrument is not Null *)
    uniqueInstrumentCosts = DeleteDuplicatesBy[Cases[instrumentResourceData, {ObjectP[], Fulfilled, _}, {1}], First];

    (* Total the instrument costs *)
    totalInstrumentCosts = Total[uniqueInstrumentCosts[[All, -1]]];

    (* Format the cost value with commas to include in the message *)
    instrumentValueNumber = If[MatchQ[totalInstrumentCosts, UnitsP[USD]],
        NumberForm[
            Unitless[totalInstrumentCosts, USD],
            DigitBlock -> 3
        ]
    ];

    (* the message *)
    instrumentValueMessage = If[!NullQ[instrumentValueNumber],
        {
            "A cumulative estimated value of over ",
            StyleBox["$" <> StringTrim[ToString[instrumentValueNumber], "."], FontWeight -> "Bold"],
            " in state-of-the-art instrumentation utilized during this experiment, reflecting the investment required to own similar equipment outright. Below is a breakdown of the instrumentation used in this experiment."
        }
    ];

    (* Final output of a flat list to feed into the core function *)
    Join[
         If[!NullQ[materialsPricingTable],
             {
                 {"Materials Cost", "Subsection", Open},
                 {"Cost breakdown of all consumables purchased and items rented during this experiment.", "Text"},
                 materialsPricingTable
             },
             {}
        ],
        If[Or[!NullQ[instrumentValueTable], !NullQ[instrumentValueMessage]],
            {
                {"Capital Equipment Value", "Subsection", Open}
            },
            {}
        ],
        If[!NullQ[instrumentValueMessage],
            {
                {instrumentValueMessage, "Text"}
            },
            {}
        ],
        If[!NullQ[instrumentValueTable],
            {
                instrumentValueTable
            },
            {}
        ]
    ]
];


(*getInstrumentData*)

Authors[getInstrumentData]:={"malav.desai"};

(* This function will create summary table for each instrument used during the protocol and include recent maintenances, and quals *)
getInstrumentData[protocol:ObjectP[Object[Protocol]]] := Module[
    (* local variables *)
    {initialDownload, protocolStartDate, protocolEndDate, mainInstruments, otherInstruments, instrumentImageImports,
        instrumentDL, qualToNotebook, partsCache, instrumentPackets, instrumentSummaryTables, createInstrumentSummary,
        verificationsOnly},


    (** find instruments that were touched by the protocol
        We need special treatment of the main instrument, so find those through the resources
        Get all the other instruments from the InstrumentLog
    **)
    initialDownload = Quiet[
        Download[
            protocol,
            {
                RequiredResources[[All, 1]][Instrument][Object],
                InstrumentLog[[All, 2]][Object],
                DateStarted,
                DateCompleted
            }
        ],
        {Download::FieldDoesntExist}
    ];

    (* set the start and end dates. we will use these to find relevant quals, maintenances *)
    protocolStartDate = initialDownload[[3]];
    protocolEndDate = If[NullQ[initialDownload[[4]]], Now, initialDownload[[4]]];

    (* Find one or more main instrument(s) from allInstruments *)
    mainInstruments = DeleteDuplicates[
        Cases[initialDownload[[1]], ObjectP[Object[Instrument]]]
    ];

    (* Find all of the other instruments that were used by the parent protocol *)
    otherInstruments = Complement[
        DeleteDuplicates[
            Cases[initialDownload[[2]], ObjectP[Object[Instrument]]]
        ],
        mainInstruments
    ];

    (* If there are no instruments, we should return an empty list output immediately *)
    If[Length[Join[mainInstruments, otherInstruments]] == 0,
        Return[{}]
    ];


    (** Download and organize the data for processing **)
    (* Download information for all of our instruments *)
    instrumentDL = Transpose[Quiet[
        Download[
            Join[mainInstruments, otherInstruments],
            {
                Packet[
                    Model,
                    DateInstalled,
                    QualificationLog,
                    QualificationResultsLog,
                    MaintenanceLog,
                    SerialNumbers,
                    InstrumentSoftware
                ],
                Model[ImageFile],
                QualificationLog[[All, 2]][{Object, QualificationNotebook, Verification}]
            }
        ],
        {Download::FieldDoesntExist}
    ]];

    (* import the instrument model images from cloud files *)
    instrumentImageImports = ImportCloudFile[instrumentDL[[2]]];

    (* Get the cloud file and append it to the instrument packet *)
    instrumentPackets = MapThread[
        Append[#1, "Image" -> #2]&,
        {
            instrumentDL[[1]],
            instrumentImageImports
        }
    ];

    (* create replacement rules to convert from qual object to its notebook. We will use this later when we need to
        include the qual notebook of passing quals in the instrument summary table *)
    qualToNotebook = Map[
        If[!MatchQ[#, NullP], ObjectP[#[[1]]] -> #[[2]], Nothing]&,
        Flatten[instrumentDL[[3]], 1]
    ];

    (* figure out which of the quals are actually just verfications that happen daily and have a narrow scope *)
    verificationsOnly = Cases[Flatten[instrumentDL[[3]], 1], {target_, _, _?TrueQ} :> target];


    (** Helper to take a packet and convert it into an Instrument summary table **)
    createInstrumentSummary[packet:PacketP[], qualNotebookRules_List, verificationList_List, startDate_?DateObjectQ, endDate_?DateObjectQ] := Module[
        (* local variables *)
        {instrumentBasics, softwareVersion, softwareVersionTable, serialNumbers, serialNumberTable, recentQualification,
            outputData, instrumentQualificationTable, instrumentMaintenanceTable, maintenanceTypes, recentVerification,
            calibrationTypes, cleaningTypes, otherMaintenanceTypes, currentMaintenanceLog, allCleanings, recentCleanings,
            allCalibrations, recentCalibrations, allOtherMaintenances, recentOtherMaintenances, instrumentCleaningTable,
            instrumentCalibrationTable, initialOutputData, possibleOutputHeaders, outputHeaders, plotMaintenanceTable,
            qualificationGridRules, instrumentGridRules, qualLogWResult, veriLogWResult, instrumentVerificationTable},


        (** Instrument image, model and install date **)
        instrumentBasics = NamedObject[{
            Panel[Lookup[packet, "Image"],
                FrameMargins -> {{50, 50}, {0, 0}},
                ImageSize -> 300,
                Appearance -> None
            ],
            customButton[Lookup[packet, Object]],
            customButton[Download[Lookup[packet, Model], Object]],
            Lookup[packet, DateInstalled]
        }];


        (** Software Version **)
        (* get the software version *)
        softwareVersion = Lookup[packet, InstrumentSoftware, {}];

        (* Create a table if we can *)
        softwareVersionTable = If[Length[softwareVersion] > 0,
            {
                Replace[
                    PlotTable[softwareVersion,
                        TableHeadings -> {None, {"Software Name", "Version Number"}},
                        Background -> tableBackground[softwareVersion]
                    ],
                    {
                        (Scrollbars -> _) -> (Scrollbars -> {False, Automatic}),
                        (ImageSize -> _) -> (ImageSize -> {Automatic, UpTo[250]})
                    },
                    {1}
                ]
            },
            {Null}
        ];


        (** Serial Number **)
        (* get the instrument serial numbers *)
        serialNumbers = Lookup[packet, SerialNumbers, {}];

        (* Create a table if we can *)
        serialNumberTable = If[Length[serialNumbers]>0,
            {
                Replace[
                    PlotTable[serialNumbers,
                        TableHeadings -> {None, {"Component Name", "Serial Number"}},
                        Background -> tableBackground[serialNumbers]
                    ],
                    {
                        (Scrollbars -> _) -> (Scrollbars -> {False, Automatic}),
                        (ImageSize -> _) -> (ImageSize -> {Automatic, UpTo[250]})
                    },
                    {1}
                ]
            },
            {Null}
        ];


        (** Recent Maintenance **)
        (* get all the possible types of maintenances *)
        maintenanceTypes = Types[Object[Maintenance]];

        (* get the maintenance log from our packet and do a couple of things:
            1. Remove any entries after the end date of our protocol
            2. Reverse it so the newest maintenances are first
        *)
        currentMaintenanceLog = Reverse[
            DeleteCases[Lookup[packet, MaintenanceLog], {GreaterP[endDate], ___}]
        ];

        (* plotMaintenanceTable helper *)
        plotMaintenanceTable[inputList_List] := Module[
            {fullTable},

            (* generate our normal maintenance table *)
            fullTable = PlotTable[
                inputList,
                TableHeadings -> {PadRight[{"Model", "Object", "Completion Date"}, Length[inputList], "Periodic"], None},
                SecondaryTableHeadings -> {If[Length[inputList] > 3, Range[Length[inputList]/3], None], None},
                Background -> tableBackground[inputList, IncludeHeader -> False],
                ItemSize -> If[Length[inputList] > 3, {{Automatic, Automatic, 25}}, {{Automatic, 25}}]
            ];

            (* Modify the table to add vertical scrollbars *)
            Replace[
                fullTable,
                {
                    (Scrollbars -> _) -> (Scrollbars -> {False, Automatic}),
                    (ImageSize -> _) -> (ImageSize -> {Automatic, UpTo[250]})
                },
                {1}
            ]
        ];


        (* Sanitization maintenances *)
        (* Gather the possible types of cleaning maintenances *)
        cleaningTypes = Types[Object[Maintenance, Clean]];

        (* From the maintenance log, get the cleaning maintenances that have been completed in the last 2 months before our protocol's start date*)
        allCleanings = Cases[
            currentMaintenanceLog,
            {dateValue:GreaterP[startDate - 2 Month], maintObject:ObjectP[cleaningTypes], maintModel_} :> {Download[maintModel, Object], Download[maintObject, Object], dateValue}
        ];

        (* Find the newest unique cleaning maintenances *)
        recentCleanings = List/@Flatten[DeleteDuplicatesBy[allCleanings, First]];

        (* Create a table if we can *)
        instrumentCleaningTable = If[Length[recentCleanings] > 0,
            {
                plotMaintenanceTable[recentCleanings]
            },
            {Null}
        ];


        (* Calibration maintenances *)
        (* Gather the possible types of calibration maintenances - since there is no calibration subtype, we will use this weird way to get the types *)
        calibrationTypes = Map[
            If[StringContainsQ[ToString[#], "calibrate", IgnoreCase -> True], #, Nothing] &,
            maintenanceTypes
        ];

        (* From the maintenance log, get all the possible calibration maintenances since these likely happen less frequently than cleanings *)
        allCalibrations = Cases[
            currentMaintenanceLog,
            {dateValue_, maintObject:ObjectP[calibrationTypes], maintModel_} :> {Download[maintModel, Object], Download[maintObject, Object], dateValue}
        ];

        (* Find the newest unique calibration maintenances *)
        recentCalibrations = List/@Flatten[DeleteDuplicatesBy[allCalibrations, First]];

        (* Create a table if we can *)
        instrumentCalibrationTable = If[Length[recentCalibrations] > 0,
            {
                plotMaintenanceTable[recentCalibrations]
            },
            {Null}
        ];

        (* Preventative maintenances *)
        (* All maintenances that are not cleaning or calibration should be considered here *)
        otherMaintenanceTypes = Complement[maintenanceTypes, Join[cleaningTypes, calibrationTypes, {Object[Maintenance]}]];

        (* From the maintenance log, get all other maintenances performed in the last 2 months *)
        allOtherMaintenances = Cases[
            currentMaintenanceLog,
            {dateValue:GreaterP[startDate - 2 Month], maintObject:ObjectP[otherMaintenanceTypes], maintModel_} :> {Download[maintModel, Object], Download[maintObject, Object], dateValue}
        ];

        (* Find the newest unique calibration maintenances *)
        recentOtherMaintenances = List/@Flatten[DeleteDuplicatesBy[allOtherMaintenances, First]];

        (* Create a table if we can *)
        instrumentMaintenanceTable = If[Length[recentOtherMaintenances] > 0,
            {
                plotMaintenanceTable[recentOtherMaintenances]
            },
            {Null}
        ];

        (** Recent Qualification **)
        (* Since qual evaluation order could sometimes not be in the correct order, we will put together the result
            from the result log with the qual log. We will also filter out any verifications that are not full
            instruments *)
        {qualLogWResult, veriLogWResult} = Module[
            (* local variables*)
            {qualVeriLogOnly, qualLogOnly, resultLogOnly, qualOutput, verificationOutput},

            (* get the logs related to quals *)
            {qualVeriLogOnly, resultLogOnly} = Lookup[packet, {QualificationLog, QualificationResultsLog}];

            (* let's filter out any verifications *)
            qualLogOnly = DeleteCases[qualVeriLogOnly, {_, LinkP[verificationList], _}];

            (* now let's get only the verifications *)
            veriLogOnly = Cases[qualVeriLogOnly, {_, LinkP[verificationList], _}];

            (* associate the result with the qual log entry; default to Null.
                For cases where a qual is re-evaluated, another entry is appended to the result log, so we want to reverse it before finding a match *)
            qualOutput = Map[
                Function[currentQualEntry,
                    Join[
                        currentQualEntry,
                        Lookup[
                            FirstCase[
                                Reverse[resultLogOnly],
                                KeyValuePattern[Qualification -> LinkP[Download[currentQualEntry[[2]], Object]]],
                                <||>
                            ],
                            {Date, Result},
                            Null (* default when nothing is found *)
                        ]
                    ]
                ],
                qualLogOnly
            ];

            (* associate the result with the verification log entry; default to Null.
                For cases where the verification is re-evaluated, another entry is appended to the result log, so we want to reverse it before finding a match *)
            verificationOutput = Map[
                Function[currentVerificationEntry,
                    Join[
                        currentVerificationEntry,
                        Lookup[
                            FirstCase[
                                Reverse[resultLogOnly],
                                KeyValuePattern[Qualification -> LinkP[Download[currentVerificationEntry[[2]], Object]]],
                                <||>
                            ],
                            {Date, Result},
                            Null (* default when nothing is found *)
                        ]
                    ]
                ],
                veriLogOnly
            ];

            {qualOutput, verificationOutput}
        ];

        (* find the most recent completed qualification from the log *)
        recentQualification = FirstCase[
            Reverse[qualLogWResult],
            {qualDate:LessP[startDate], qualLink_, _, evalDate:LessP[startDate], evalResult_} :> {Download[qualLink, Object], qualDate, evalDate, evalResult},
            {}
        ];

        (* find the most recent completed verification from the log *)
        recentVerification = FirstCase[
            Reverse[veriLogWResult],
            {qualDate:LessP[startDate], qualLink_, _, evalDate:LessP[startDate], evalResult_} :> {Download[qualLink, Object], qualDate, evalDate, evalResult},
            {}
        ];

        (* grid formatting rules *)
        qualificationGridRules = {
            Background -> tableBackground[2, IncludeHeader -> False],
            ItemSize -> {{Automatic, 28}},
            Alignment -> {{Center, Left}},
            Spacings -> {1.5, 1},
            ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
            Dividers -> {
                {
                    Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                    {
                        1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                        -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                    }
                },
                {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
            }
        };

        (* if we found an evaluated qual pass OR fail, let's gather up our entries and output, otherwise output {Null} so that we can replace it out *)
        instrumentQualificationTable = If[Length[recentQualification] > 0,
            {
                Grid[
                    {
                        {"Qualification", customButton[Download[recentQualification[[1]], Object]]},
                        {"Completion Date", recentQualification[[2]]},
                        {"Evaluation Date", recentQualification[[3]]},
                        {"Result", recentQualification[[4]]},
                        {"Result Notebook", recentQualification[[1]]}/.qualNotebookRules
                    },
                    Sequence@@qualificationGridRules
                ]
            },
            {Null}
        ];

        (* if we found an evaluated verification pass OR fail, let's gather up our entries and output, otherwise output {Null} so that we can replace it out *)
        instrumentVerificationTable = If[Length[recentVerification] > 0,
                {
                    Grid[
                        {
                            {"Verification", customButton[Download[recentVerification[[1]], Object]]},
                            {"Completion Date", recentVerification[[2]]},
                            {"Evaluation Date", recentVerification[[3]]},
                            {"Result", recentVerification[[4]]},
                            {"Result Notebook", recentVerification[[1]]}/.qualNotebookRules
                        },
                        Sequence@@qualificationGridRules
                    ]
                },
                {Null}
            ];


        (** Output **)
        (* Put together all the information *)
        initialOutputData = Join[
            instrumentBasics,
            softwareVersionTable,
            serialNumberTable,
            instrumentQualificationTable,
            instrumentVerificationTable,
            instrumentCalibrationTable,
            instrumentMaintenanceTable,
            instrumentCleaningTable
        ];

        (* Clean up the initial output by removing {Null}s *)
        outputData = Replace[initialOutputData, NullP -> Nothing, {1}];

        (* define all the possible row headers *)
        possibleOutputHeaders = {
            "",
            "Instrument",
            "Model",
            Column[{"Installation", "Date"}, Alignment -> Center],
            Column[{"Software", "Version"}, Alignment -> Center],
            Column[{"Serial", "Number"}, Alignment -> Center],
            "Qualification",
            "Verification",
            "Calibration",
            Column[{"Preventative", "Maintenance"}, Alignment -> Center],
            "Cleaning"
        };

        (* remove any headers that should not be shown if the corresponding data value is NullP *)
        outputHeaders = PickList[possibleOutputHeaders, initialOutputData, Except[NullP]];

        (* setup the formatting options for the final table *)
        instrumentGridRules = {
            Background -> tableBackground[2, IncludeHeader -> False],
            ItemSize -> {{Automatic, 32}},
            Alignment -> {{Center, Left}},
            Spacings -> {1.5, 1},
            ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
            Dividers -> {
                {
                    {Directive[Opacity[0]]},
                    {
                        1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1], Opacity[1]],
                        -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1], Opacity[1]]
                    }
                },
                {
                    Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                    {
                        1 -> Directive[LCHColor[0.4, 0, 0], Thickness[2]],
                        -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[2]]
                    }
                }
            }
        };

        (* assemble the final table *)
        Grid[
            Transpose[{outputHeaders, outputData}],
            Sequence@@instrumentGridRules
        ]
    ];


    (** Generate a summary table for each of our instruments **)
    instrumentSummaryTables = Map[
        createInstrumentSummary[#1, qualToNotebook, verificationsOnly, protocolStartDate, protocolEndDate]&,
        instrumentPackets
    ];

    Join[
        If[Length[mainInstruments] > 0,
            {
                {"Primary Instruments", "Subsection", Open},
                Sequence@@instrumentSummaryTables[[;;Length[mainInstruments]]]
            },
            {}
        ],
        Which[
            (* When we have primary instruments, we should call this secondary instruments *)
            And[Length[otherInstruments] > 0, Length[mainInstruments] > 0],
                {
                    {"Secondary Instruments", "Subsection", Close},
                    assembleSlideView[instrumentSummaryTables[[(Length[mainInstruments]+1);;]]]
                },
            (* When we don't have primary instruments, we should call this preparatory instruments *)
            Length[otherInstruments] > 0,
                {
                    {"Preparatory Instruments", "Subsection", Open},
                    assembleSlideView[instrumentSummaryTables[[(Length[mainInstruments]+1);;]]]
                },
            (* When we don't have other instruments, we don't have any output *)
            True,
                {}
        ]
    ]
];


(*getSampleData*)

Authors[getSampleData]:={"taylor.hochuli"};

(* Create a display of critical information about the input and output samples *)
getSampleData[protocol:ObjectP[Object[Protocol]]] := Module[
    (* Local variables. *)
    {
        protocolFields, protocolDataFields, currentSampleDownloadFields, currentSampleModelDownloadFields,
        allCurrentSampleFields, currentSampleContainerDownloadFields, currentSampleContainerModelDownloadFields,
        currentDataDownloadFields, comparisonSampleDownloadFields, comparisonSampleContainerDownloadFields, resourceFields,
        protocolPacket, protocolDataPacket, currentSamplesInPackets, currentSamplesOutPackets,
        currentSamplesInContainerPackets, currentSamplesOutContainerPackets, currentSamplesInContainerModelPackets,
        currentSamplesOutContainerModelPackets, currentSamplesInDataPackets, currentSamplesOutDataPackets,
        currentRequiredResourcePackets, currentSubprotocolRequiredResourcePackets, currentRequiredResourceSamplePackets,
        currentSubprotocolRequiredResourceSamplePackets, currentRequiredResourceModelPackets,
        currentSubprotocolRequiredResourceModelPackets, currentRequiredResourceContainerPackets,
        currentSubprotocolRequiredResourceContainerPackets, currentRequiredResourceContainerModelPackets,
        currentSubprotocolRequiredResourceContainerModelPackets, currentRequiredResourceSampleDataPackets,
        currentSubprotocolRequiredResourceSampleDataPackets, allCurrentSampleData, protocolDateStart,
        protocolDateComplete, protocolCompleteQ, samplesInObjects, samplesOutObjects,
        requiredResourceToSampleAssociation, subprotocolRequiredResourceToSampleAssociation,
        requiredResourceSampleObjects, allSubprotocolRequiredResourceSampleObjects,
        subprotocolRequiredResourceSampleObjects, allRequiredResourceSamplePackets, requiredResourceSamplePackets,
        subprotocolRequiredResourceSamplePackets, resourceToFieldAssociation, allCurrentSamplePackets,
        allAppearanceObjects, allCurrentDataPackets, allImageCloudFiles, allImages,  sampleImageCloudFileAssociation,
        currentCacheBall, protStartSamplesInPackets, protStartSamplesOutPackets, protStartSamplesInContainerPackets,
        protStartSamplesOutContainerPackets, protStartRequiredResourcesPackets, protStartRequiredResourcesContainerPackets,
        protStartSubprotocolRequiredResourcesPackets, protStartSubprotocolRequiredResourcesContainerPackets,
        allProtocolStartSampleData, protCompleteSamplesInPackets, protCompleteSamplesOutPackets,
        protCompleteSamplesInContainerPackets, protCompleteSamplesOutContainerPackets, protCompleteRequiredResourcesPackets,
        protCompleteRequiredResourcesContainerPackets, protCompleteSubprotocolRequiredResourcesPackets,
        protCompleteSubprotocolRequiredResourcesContainerPackets, allProtocolCompleteSampleData, objectIDNameAssociation,
        flattenedCurrentContainerPackets, flattenedProtCompleteContainerPackets,
        sampleContainerAssociation, allCurrentContainerPackets, plateSamplesInObjects, nonPlateSamplesInObjects,
        nonObjectSamplesIn, plateSamplesOutObjects, nonPlateSamplesOutObjects, nonObjectSamplesOut,
        plateRequiredResourceSampleObjects, nonPlateRequiredResourceSampleObjects, nonObjectRequiredResourceSamples,
        plateSubprotocolRequiredResourceSampleObjects, nonPlateSubprotocolRequiredResourceObjects,
        nonObjectSubprotocolRequiredResources, localNamedObject, formatSampleInformation,
        stylizeHeader, stylizeComment, timeDisclaimerComment, formatHeader, formatCompositionTable, pickNearestLogEntry,
        buildLogTooltip, dataBuildDataAssociation, protocolBuildDataAssociation, sampleDataHeader,
        sampleDataAssociation, generateSampleInfoTable, plateLegend, plotPlate,
        nonPlateSamplesInTables, nonPlateSamplesOutTables, nonPlateRequiredResourceTables,
        nonPlateSubprotocolRequiredResourceTables, nonPlateSamplesInSlides, nonPlateSamplesOutSlides,
        nonPlateRequiredResourceSlides, nonPlateSubprotocolRequiredResourceSlides,
        plateSampleTableAssociation, plateSamplesInSlides, plateSamplesOutSlides,
        plateRequiredResourceSlides, plateSubprotocolRequiredResourceSlides, nonObjectSamplesInTables,
        nonObjectSamplesOutTables, nonObjectRequiredResourceTables, nonObjectSubprotocolRequiredResourceTables,
        nonObjectSamplesInSlides, nonObjectSamplesOutSlides, nonObjectRequiredResourceSlides,
        nonObjectSubprotocolRequiredResourceSlides, samplesInSectionList,
        samplesOutSectionList, requiredResourcesSectionList, subprotocolRequiredResourcesSectionList
    },

    (* Determine all the things we want in sample download packets. *)
    protocolFields = {
        Object, ID, Name, SamplesIn, SamplesOut, DateStarted, DateCompleted, Status, Data, NumberOfCycles,
        RequiredResources, SubprotocolRequiredResources, Subprotocols
    };
    protocolDataFields = {
        Object, ID, Name, SamplesIn, InjectionIndex, Osmolality
    };

    (* "Current" fields will be downloaded from objects as they exist in the database when the function is run, aka "Now". *)
    currentSampleDownloadFields = {
        Object, ID, Name, Model, Container, Composition, AppearanceLog, LocationLog, VolumeLog, MassLog, State,
        ExpirationDate, pHLog, RefractiveIndexLog, DensityLog, ConductivityLog, StatusLog
    };
    currentSampleModelDownloadFields = {
        Object, ID, Name, State, Sterile, DefaultStorageCondition, ShelfLife, UnsealedShelfLife, SampleHandling,
        TransferTemperature, Composition, Products, KitProducts, MSDSFile, IncompatibleMaterials
    };
    allCurrentSampleFields = DeleteDuplicates[Flatten[{currentSampleDownloadFields, currentSampleModelDownloadFields}]];

    currentSampleContainerDownloadFields = {Object, ID, Name, Model, CoverLog};
    currentSampleContainerModelDownloadFields = {
        Object, ID, Name, Dimensions, Positions, PositionPlotting, WellDiameter, WellDimensions, NumberOfWells
    };

    currentDataDownloadFields = {Object, ID, Name, UncroppedImageFile};

    (* "Comparison" fields are fields without logs, so they must be downloaded from the start date or end date of the protocol. *)
    comparisonSampleDownloadFields = {Object, ID, Name, Model, State, Composition};
    comparisonSampleContainerDownloadFields = {Object, ID, Name, Model, Contents, CoverLog};

    resourceFields = {
        Object, ID, Name, Object, Status, Models, Sample, Amount, Purchase, RootProtocol, Requestor, StatusLog
    };

    (* Download "current" packets, information as it exists currently in the database. *)
    {
        (*1*)protocolPacket,
        (*2*)protocolDataPacket,
        (*3*)currentSamplesInPackets,
        (*4*)currentSamplesOutPackets,
        (*5*)currentSamplesInContainerPackets,
        (*6*)currentSamplesOutContainerPackets,
        (*7*)currentSamplesInContainerModelPackets,
        (*8*)currentSamplesOutContainerModelPackets,
        (*9*)currentSamplesInDataPackets,
        (*10*)currentSamplesOutDataPackets,
        (*11*)currentRequiredResourcePackets,
        (*12*)currentSubprotocolRequiredResourcePackets,
        (*13*)currentRequiredResourceSamplePackets,
        (*14*)currentSubprotocolRequiredResourceSamplePackets,
        (*15*)currentRequiredResourceModelPackets,
        (*16*)currentSubprotocolRequiredResourceModelPackets,
        (*17*)currentRequiredResourceContainerPackets,
        (*18*)currentSubprotocolRequiredResourceContainerPackets,
        (*19*)currentRequiredResourceContainerModelPackets,
        (*20*)currentSubprotocolRequiredResourceContainerModelPackets,
        (*21*)currentRequiredResourceSampleDataPackets,
        (*22*)currentSubprotocolRequiredResourceSampleDataPackets
    } = Quiet[
        Download[
            protocol,
            {
                (* 1 *)
                Evaluate[Packet[Sequence @@ protocolFields]],
                (* 2 *)
                Packet[Data[protocolDataFields]],
                (* 3 *)
                Packet[SamplesIn[allCurrentSampleFields]],
                (* 4 *)
                Packet[SamplesOut[allCurrentSampleFields]],
                (* 5 *)
                Packet[SamplesIn[Container[currentSampleContainerDownloadFields]]],
                (* 6 *)
                Packet[SamplesOut[Container[currentSampleContainerDownloadFields]]],
                (* 7 *)
                Packet[SamplesIn[Container[Model[currentSampleContainerModelDownloadFields]]]],
                (* 8 *)
                Packet[SamplesOut[Container[Model[currentSampleContainerModelDownloadFields]]]],
                (* 9 *)
                Packet[SamplesIn[Data[currentDataDownloadFields]]],
                (* 10 *)
                Packet[SamplesOut[Data[currentDataDownloadFields]]],
                (* 11 *)
                Packet[RequiredResources[[All, 1]][resourceFields]],
                (* 12 *)
                Packet[SubprotocolRequiredResources[[All, 1]][resourceFields]],
                (* 13 *)
                Packet[RequiredResources[[All, 1]][Sample][allCurrentSampleFields]],
                (* 14 *)
                Packet[SubprotocolRequiredResources[[All, 1]][Sample][allCurrentSampleFields]],
                (* 15 *)
                Packet[RequiredResources[[All, 1]][Models][allCurrentSampleFields]],
                (* 16 *)
                Packet[SubprotocolRequiredResources[[All, 1]][Models][allCurrentSampleFields]],
                (* 17 *)
                Packet[RequiredResources[[All, 1]][Sample][Container][currentSampleContainerDownloadFields]],
                (* 18 *)
                Packet[SubprotocolRequiredResources[[All, 1]][Container][currentSampleContainerDownloadFields]],
                (* 19 *)
                Packet[RequiredResources[[All, 1]][Sample][Container][Model][currentSampleContainerModelDownloadFields]],
                (* 20 *)
                Packet[SubprotocolRequiredResources[[All, 1]][Container][Model][currentSampleContainerModelDownloadFields]],
                (* 21 *)
                Packet[RequiredResources[[All, 1]][Sample][Data][currentDataDownloadFields]],
                (* 22 *)
                Packet[SubprotocolRequiredResources[[All, 1]][Sample][Data][currentDataDownloadFields]]
            }
        ],
        {Download::ObjectDoesNotExist, Download::FieldDoesntExist}
    ];

    (* Combine and flatten packets related to SamplesIn and SamplesOut. *)
    allCurrentSampleData = Flatten[
        {
            protocolPacket, currentSamplesInPackets, currentSamplesOutPackets, currentSamplesInContainerPackets,
            currentSamplesOutContainerPackets, currentSamplesInContainerModelPackets,
            currentSamplesOutContainerModelPackets, currentSamplesInDataPackets, currentSamplesOutDataPackets
        }
    ];

    (* Pull out protocol start and complete date. If protocol is not complete yet, the current date is used. *)
    protocolDateStart = If[!NullQ[Lookup[protocolPacket, DateStarted]],
        Lookup[protocolPacket, DateStarted],
        Now
    ];

    {protocolDateComplete, protocolCompleteQ} = Module[{completionDate, protStatus},
        {completionDate, protStatus} = Lookup[protocolPacket, {DateCompleted, Status}];

        If[MatchQ[completionDate, Except[Null]],
            {completionDate, MatchQ[protStatus, Completed]},
            {Now, MatchQ[protStatus, Completed]}
        ]
    ];

    (* Pull out and categorize sample objects from packets. *)
    (* Pull out the list of SamplesIn objects and SamplesOut objects. *)
    {samplesInObjects, samplesOutObjects} = Map[
        Lookup[Cases[#, PacketP[]], Object, {}]&,
        {currentSamplesInPackets, currentSamplesOutPackets}
    ];

    (* Determine which required resource objects and subprotocol required resource objects correspond to each sample. *)
    (* This is put into an association to use later when making sample tables. *)
    {requiredResourceToSampleAssociation, subprotocolRequiredResourceToSampleAssociation} = Map[
        DeleteDuplicates,
        Map[
            Module[{resourceObject, sampleObject, models, status},
                {resourceObject, sampleObject, models, status} = Lookup[#, {Object, Sample, Models, Status}];

                Which[
                    MatchQ[status, Canceled],
                        Nothing,
                    MatchQ[sampleObject, ObjectP[Object[Sample]]],
                        Download[sampleObject, Object] -> Download[resourceObject, Object],
                    MemberQ[models, ObjectP[Model[Sample]]],
                        Download[FirstCase[models, ObjectP[Model[Sample]]], Object] -> Download[resourceObject, Object],
                    True,
                        Nothing
                ]
            ]&,
            {currentRequiredResourcePackets, currentSubprotocolRequiredResourcePackets},
            {2}
        ]
    ];

    (* Get lists of required resources and subprotocol required resources. *)
    {requiredResourceSampleObjects, allSubprotocolRequiredResourceSampleObjects} = Map[
        Complement[Keys[#], Flatten[{samplesInObjects, samplesOutObjects}]]&,
        {requiredResourceToSampleAssociation, subprotocolRequiredResourceToSampleAssociation}
    ];

    (* Filter required resources out of subprotocol required resources. *)
    subprotocolRequiredResourceSampleObjects = Complement[
        allSubprotocolRequiredResourceSampleObjects, requiredResourceSampleObjects
    ];

    (* Combine and flatten required resource sample packets. *)
    allRequiredResourceSamplePackets = Flatten[{
        currentRequiredResourceSamplePackets, currentSubprotocolRequiredResourceSamplePackets,
        currentRequiredResourceModelPackets, currentSubprotocolRequiredResourceModelPackets
    }];

    (* Pull packets for the required resources and subprotocol required resources that pertain to protocol samples. *)
    {requiredResourceSamplePackets, subprotocolRequiredResourceSamplePackets} = Map[
        FirstCase[allRequiredResourceSamplePackets, KeyValuePattern[Object -> ObjectP[#]]]&,
        {requiredResourceSampleObjects, subprotocolRequiredResourceSampleObjects},
        {2}
    ];

    (* Make an association of protocol resources to the field that they are populating (ex. Object[Resource, "BLAH"] -> BufferB). *)
    resourceToFieldAssociation = Map[
        Download[#[[1]], Object] -> #[[2]]&,
        Lookup[protocolPacket, RequiredResources]
    ];

    (* Download image file objects and import all images. *)
    allCurrentSamplePackets = Cases[
        Flatten[{
            currentSamplesInPackets, currentSamplesOutPackets,
            requiredResourceSamplePackets, subprotocolRequiredResourceSamplePackets
        }],
        PacketP[]
    ];

    (* Use the appearance log to get the most recent appearance for the sample and use Null if there is not an appearance for the sample. *)
    allAppearanceObjects = Map[
        Function[{samplePacket},
            Module[{appearanceLog, appearanceTimeDataAssoc},
                appearanceLog = Lookup[samplePacket, AppearanceLog, {}];

                (* AppearanceLog for Models will be $Failed. *)
                appearanceTimeDataAssoc = If[MatchQ[appearanceLog, Except[{}|$Failed]],
                    Map[
                        #[[1]] -> #[[2]]&,
                        appearanceLog
                    ],
                    {Now -> Null}
                ];

                Last[Nearest[appearanceTimeDataAssoc, protocolDateComplete]]
            ]
        ],
        allCurrentSamplePackets
    ];

    (* Assign more of our data packets and import the images. *)
    allCurrentDataPackets = Cases[
        Flatten[{
            currentSamplesInDataPackets, currentSamplesOutDataPackets,
            currentRequiredResourceSampleDataPackets, currentSubprotocolRequiredResourceSampleDataPackets
        }],
        PacketP[]
    ];
    allImageCloudFiles = Download[allAppearanceObjects, UncroppedImageFile, Cache -> allCurrentDataPackets];
    allImages = If[MatchQ[allImageCloudFiles, Except[{}]], ImportCloudFile[allImageCloudFiles], {}];

    (* Make an association of the sample objects to their imported images and cloud file objects. *)
    (* Both the imported image and cloud files are used to make an appearance button later on. *)
    sampleImageCloudFileAssociation = MapThread[
        Function[{samplePacket, importedImage, cloudFileObject},
            Lookup[samplePacket, Object] -> {importedImage, cloudFileObject}
        ],
        {allCurrentSamplePackets, allImages, allImageCloudFiles}
    ];

    (* Create a cache from the downloaded information. *)
    currentCacheBall = Cases[Flatten[allCurrentSampleData], PacketP[]];

    (* Download information from the start of the protocol. *)
    {
        protStartSamplesInPackets,
        protStartSamplesOutPackets,
        protStartSamplesInContainerPackets,
        protStartSamplesOutContainerPackets,
        protStartRequiredResourcesPackets,
        protStartRequiredResourcesContainerPackets,
        protStartSubprotocolRequiredResourcesPackets,
        protStartSubprotocolRequiredResourcesContainerPackets
    } = Quiet[
        Download[
            protocol,
            {
                Packet[SamplesIn[comparisonSampleDownloadFields]],
                Packet[SamplesOut[comparisonSampleDownloadFields]],
                Packet[SamplesIn[Container[comparisonSampleContainerDownloadFields]]],
                Packet[SamplesOut[Container[comparisonSampleContainerDownloadFields]]],
                Packet[RequiredResources[[All, 1]][Sample][comparisonSampleDownloadFields]],
                Packet[RequiredResources[[All, 1]][Sample][Container][comparisonSampleContainerDownloadFields]],
                Packet[SubprotocolRequiredResources[[All, 1]][Sample][comparisonSampleDownloadFields]],
                Packet[SubprotocolRequiredResources[[All, 1]][Sample][Container][comparisonSampleContainerDownloadFields]]
            },
            Date -> protocolDateStart
        ],
        {Download::ObjectDoesNotExist, Download::FieldDoesntExist}
    ];

    allProtocolStartSampleData = Flatten[
        {
            protStartSamplesInPackets, protStartSamplesOutPackets, protStartSamplesInContainerPackets,
            protStartSamplesOutContainerPackets, protStartRequiredResourcesPackets,
            protStartRequiredResourcesContainerPackets, protStartSubprotocolRequiredResourcesPackets,
            protStartSubprotocolRequiredResourcesContainerPackets
        }
    ];

    (* Download information from the end of the protocol. *)
    {
        protCompleteSamplesInPackets,
        protCompleteSamplesOutPackets,
        protCompleteSamplesInContainerPackets,
        protCompleteSamplesOutContainerPackets,
        protCompleteRequiredResourcesPackets,
        protCompleteRequiredResourcesContainerPackets,
        protCompleteSubprotocolRequiredResourcesPackets,
        protCompleteSubprotocolRequiredResourcesContainerPackets
    } = Quiet[
        Download[
            protocol,
            {
                Packet[SamplesIn[comparisonSampleDownloadFields]],
                Packet[SamplesOut[comparisonSampleDownloadFields]],
                Packet[SamplesIn[Container[comparisonSampleContainerDownloadFields]]],
                Packet[SamplesOut[Container[comparisonSampleContainerDownloadFields]]],
                Packet[RequiredResources[[All, 1]][Sample][comparisonSampleDownloadFields]],
                Packet[RequiredResources[[All, 1]][Sample][Container][comparisonSampleContainerDownloadFields]],
                Packet[SubprotocolRequiredResources[[All, 1]][Sample][comparisonSampleDownloadFields]],
                Packet[SubprotocolRequiredResources[[All, 1]][Sample][Container][comparisonSampleContainerDownloadFields]]
            },
            Date -> protocolDateComplete
        ],
        {Download::ObjectDoesNotExist, Download::FieldDoesntExist}
    ];

    allProtocolCompleteSampleData = Flatten[
        {
            protCompleteSamplesInPackets, protCompleteSamplesOutPackets, protCompleteSamplesInContainerPackets,
            protCompleteSamplesOutContainerPackets, protCompleteRequiredResourcesPackets,
            protCompleteRequiredResourcesContainerPackets, protCompleteSubprotocolRequiredResourcesPackets,
            protCompleteSubprotocolRequiredResourcesContainerPackets
        }
    ];

    (** Organize the data **)
    (* Create an association between objects and their IDs and Names. This will be used for a faster, local version *)
    (* of the NamedObject function. *)
    objectIDNameAssociation = DeleteDuplicates[
        Map[
            Lookup[#, Object] -> Lookup[#, {ID, Name}]&,
            Cases[
                Flatten[{
                    protocolPacket, protocolDataPacket, currentSamplesInPackets, currentSamplesOutPackets,
                    currentSamplesInContainerPackets, currentSamplesOutContainerPackets, currentSamplesInContainerModelPackets,
                    currentSamplesOutContainerModelPackets, currentSamplesInDataPackets, currentSamplesOutDataPackets,
                    currentRequiredResourcePackets, currentSubprotocolRequiredResourcePackets,
                    currentRequiredResourceSamplePackets, currentSubprotocolRequiredResourceSamplePackets,
                    currentRequiredResourceModelPackets, currentSubprotocolRequiredResourceModelPackets,
                    currentRequiredResourceContainerPackets, currentSubprotocolRequiredResourceContainerPackets,
                    currentRequiredResourceContainerModelPackets, currentSubprotocolRequiredResourceContainerModelPackets,
                    currentRequiredResourceSampleDataPackets, currentSubprotocolRequiredResourceSampleDataPackets,
                    protStartSamplesInPackets,
                    protStartSamplesOutPackets,
                    protStartSamplesInContainerPackets,
                    protStartSamplesOutContainerPackets,
                    protStartRequiredResourcesPackets,
                    protStartRequiredResourcesContainerPackets,
                    protStartSubprotocolRequiredResourcesPackets,
                    protStartSubprotocolRequiredResourcesContainerPackets,
                    protCompleteSamplesInPackets,
                    protCompleteSamplesOutPackets,
                    protCompleteSamplesInContainerPackets,
                    protCompleteSamplesOutContainerPackets,
                    protCompleteRequiredResourcesPackets,
                    protCompleteRequiredResourcesContainerPackets,
                    protCompleteSubprotocolRequiredResourcesPackets,
                    protCompleteSubprotocolRequiredResourcesContainerPackets
                }],
                PacketP[]
            ]
        ]
    ];

    (* Flatten container packets. *)
    flattenedCurrentContainerPackets = Cases[
        Flatten[
            {
                currentSamplesInContainerPackets, currentSamplesOutContainerPackets,
                currentSamplesInContainerModelPackets, currentSamplesOutContainerModelPackets,
                currentRequiredResourceContainerPackets, currentSubprotocolRequiredResourceContainerPackets,
                currentRequiredResourceContainerModelPackets, currentSubprotocolRequiredResourceContainerModelPackets
            }
        ],
        PacketP[]
    ];

    flattenedProtCompleteContainerPackets = Cases[
        Flatten[{
            protCompleteSamplesInContainerPackets, protCompleteSamplesOutContainerPackets,
            protCompleteRequiredResourcesContainerPackets, protCompleteSubprotocolRequiredResourcesContainerPackets
        }],
        PacketP[]
    ];

    (* Make an association of samples to the containers that they were in at the end of the protocol. *)
    sampleContainerAssociation = Map[
        Function[{sampleObject},
            Module[{sampleObjectPacket, sampleLocationLog, containerTimeDataAssoc, sampleContainer},
                sampleObjectPacket = FirstCase[
                    allCurrentSamplePackets,
                    KeyValuePattern[Object -> ObjectP[sampleObject]],
                    <||>
                ];

                sampleLocationLog = Lookup[sampleObjectPacket, LocationLog, {}];

                (* AppearanceLog for Models will be $Failed. *)
                containerTimeDataAssoc = If[MatchQ[sampleLocationLog, Except[{}|$Failed]],
                    Map[
                        If[
                            !NullQ[#[[3]]],
                            #[[1]] -> #[[3]],
                            Nothing
                        ]&,
                        sampleLocationLog
                    ],
                    {Now -> Null}
                ];

                sampleContainer = Download[Last[Nearest[containerTimeDataAssoc, protocolDateComplete]], Object];

                sampleObject -> sampleContainer
            ]
        ],
        Flatten[{
            samplesInObjects, samplesOutObjects,
            requiredResourceSampleObjects, subprotocolRequiredResourceSampleObjects
        }]
    ];

    (* If containers and their models have not been downloaded, then download their up-to-date information. *)
    allCurrentContainerPackets = Module[{allSampleContainers},
        allSampleContainers = Cases[
            DeleteDuplicates[Flatten[Values[sampleContainerAssociation]]],
            ObjectP[]
        ];

        Flatten[
            Quiet[
                Download[
                    {
                        allSampleContainers,
                        allSampleContainers
                    },
                    {
                        Evaluate[Packet[Sequence@@currentSampleContainerDownloadFields]],
                        Packet[Model[currentSampleContainerModelDownloadFields]]
                    },
                    Cache -> flattenedCurrentContainerPackets
                ],
                {Download::ObjectDoesNotExist, Download::FieldDoesntExist}
            ]
        ]
    ];

    (* Determine which samples are in plates, which are in vessels, and which are not fulfilled (still models). *)
    {
        {plateSamplesInObjects, nonPlateSamplesInObjects, nonObjectSamplesIn},
        {plateSamplesOutObjects, nonPlateSamplesOutObjects, nonObjectSamplesOut},
        {plateRequiredResourceSampleObjects, nonPlateRequiredResourceSampleObjects, nonObjectRequiredResourceSamples},
        {plateSubprotocolRequiredResourceSampleObjects, nonPlateSubprotocolRequiredResourceObjects, nonObjectSubprotocolRequiredResources}
    } = Map[
        Function[{sampleInputs},
            Module[{sampleObjects, sampleContainers, plateSamples},
                (* Incomplete protocols can have Null as input, so filtering that out. *)
                sampleObjects = Cases[sampleInputs, ObjectP[Object[Sample]]];

                sampleContainers = Lookup[sampleContainerAssociation, sampleObjects];

                plateSamples = DeleteDuplicates[
                    PickList[
                        sampleObjects,
                        sampleContainers,
                        ObjectP[Object[Container, Plate]]
                    ]
                ];

                {
                    plateSamples,
                    DeleteDuplicates[Complement[sampleObjects, plateSamples]],
                    DeleteDuplicates[Cases[sampleInputs, (ObjectP[Model[Sample]]|_String)]]
                }
            ]
        ],
        {
            samplesInObjects, samplesOutObjects, requiredResourceSampleObjects,
            subprotocolRequiredResourceSampleObjects
        }
    ];

    (** Set up helpers to format information and headers. **)
    (* Make a local version of the NamedObject function. This speeds up the function by condensing to one download for names. *)
    localNamedObject[object: ObjectP[]] := Module[{formattedObject, objectIDName, objectID, objectName},
        formattedObject = If[MatchQ[object, ObjectReferenceP[]],
            object,
            Download[object, Object]
        ];

        {objectID, objectName} = Lookup[objectIDNameAssociation, formattedObject, {Null, Null}];

        If[NullQ[objectName],
            formattedObject,
            ReplaceAll[formattedObject, objectID -> objectName]
        ]
    ];

    (* Format sample information akin to PlotTable, but with additional functionality. *)
    (* If a custom tooltip is not provided, then pass along Null which uses the regular CopyToClipboard tooltip. *)
    formatSampleInformation[info_] := formatSampleInformation[info, Null];

    formatSampleInformation[info_, tooltip_] := If[MatchQ[info, Except[Null|{}]],
        Module[{processItem, processedInfo, displayedInfo, tooltipLabel},
            (* Make units, distributions, and objects more presentable for the table by formatting them. *)
            processItem[item_] := Replace[item,
                {
                    x: UnitsP[] :> UnitForm[x, Round -> 0.01, Brackets -> False],
                    y: (_QuantityDistribution|_DataDistribution) :> unitFormDistribution[y],
                    z: ObjectP[] :> localNamedObject[z]
                }
            ];

            (* If the input is a list of elements, then format each element. Otherwise format the single element. *)
            processedInfo = If[
                And[
                    MatchQ[info, _List],
                    !MatchQ[info, ({_?NumericQ..}|ObjectP[])]
                ],
                Map[processItem, info],
                processItem[info]
            ];

            (* Format the input to be displayed. *)
            displayedInfo = Which[
                (*A list of integers, such as SamplesIn Indexes, have the list brackets removed from them. *)
                MatchQ[processedInfo, {_Integer..}],
                    StringReplace[
                        ToString[processedInfo],
                        {"{" -> "", "}" -> ""}
                    ],
                (* Objects are turned into strings in their input form to retain the quotes around IDs and Names. *)
                MatchQ[processedInfo, ObjectP[]],
                    Replace[processedInfo, z: ObjectP[] :> ToString[InputForm[z]]],
                (* Anything in a list is put into a column for easier reading. *)
                MatchQ[processedInfo, {ObjectP[]..}],
                    Column[Map[Replace[#, z: ObjectP[] :> ToString[InputForm[z]]]&, processedInfo]],
                MatchQ[processedInfo, _List],
                    Column[processedInfo],
                (* Otherwise, the input is displayed as-is. *)
                True,
                    processedInfo
            ];

            (* If a custom tooltip is supplied, then use that. Otherwise, use the default "Copy" message from PlotTable. *)
            tooltipLabel = If[NullQ[tooltip],
                "Copy value to clipboard",
                tooltip
            ];

            (* Assemble the table item. *)
            customButton[displayedInfo,
                Tooltip -> If[NullQ[tooltip], Automatic, tooltip],
                CopyContent -> processedInfo
            ]
        ],
        Null
    ];

    (* Stylize headers and comments akin to PlotTable. *)
    stylizeHeader[header_String] := Style[header, Bold, 11, FontFamily -> "Helvetica", RGBColor["#4A4A4A"]];
    stylizeComment[comment_String] := Style[comment, 11, FontFamily -> "Helvetica", RGBColor["#4A4A4A"]];

    (* Create a standardized comment to be used for any slides/tables reflecting information at the end of the protocol. *)
    timeDisclaimerComment = stylizeComment[
        InsertLinebreaks[
            If[protocolCompleteQ,
                StringJoin[
                    "The display above reflects the conditions at the end of ",
                    ToString[InputForm[protocol]],
                    " (",
                    DateString[protocolDateComplete],
                    ") unless otherwise specified."
                ],
                StringJoin[
                    "The display above reflects the conditions at ",
                    DateString[protocolDateComplete],
                    " unless otherwise specified."
                ]
            ],
            100
        ]
    ];

    (* Give headers similar functionality to PlotTable (copies content, not the header itself). *)
    formatHeader[header_String, content_] := If[MatchQ[content, Except[Null|{}]],
        customButton[
            stylizeHeader[header],
            CopyContent -> content
        ],
        Null
    ];

    (* Make a composition table to be used in the sample table. *)
    formatCompositionTable[rawComposition_] := Module[{compositionTuples, compositionTable, formattedCompositionTable},
        (* Only use composition elements that are not Null (15 MassPercent of Null is not informative). *)
        compositionTuples = If[MatchQ[rawComposition, Except[{}]],
            Cases[
                rawComposition[[All, 1;;2]],
                {_, Except[Null]}
            ],
            {}
        ];

        compositionTable = If[MatchQ[compositionTuples, Except[{}]],
            PlotTable[
                compositionTuples,
                TableHeadings -> {
                    None,
                    {"Amount", "Identity Model"}
                },
                ItemSize -> {{8, 15}},
                Background -> {
                    None,
                    {{
                        RGBColor[0.8862745098039215`, 0.8862745098039215`, 0.8862745098039215`],
                        RGBColor[1, 1, 1]
                    }}
                }
            ],
            Null
        ];

        (* If the composition has over ten elements, then add a scrollbar to condense the table visually. *)
        formattedCompositionTable = If[
            And[
                Length[compositionTuples] > 10,
                !NullQ[compositionTable]
            ],
            Replace[compositionTable,
                {
                    (Scrollbars -> _) -> (Scrollbars -> {False, Automatic}),
                    (ImageSize -> _) -> (ImageSize -> {Automatic, UpTo[250]}),
                    (AppearanceElements -> _) -> (AppearanceElements -> None)
                },
                {1}
            ],
            compositionTable
        ];

        {compositionTable, formattedCompositionTable}
    ];

    (* When provided a log (such as LocationLog or StatusLog), pulls out the element closest to the end of the protocol. *)
    (* If there are no elements in the log, then returns Null. *)
    pickNearestLogEntry[log_List, measurementIndex: ListableP[_Integer]] := Module[{timeDataAssoc},

        timeDataAssoc = If[MatchQ[log, Except[{}]],
            Map[
                #[[1]] -> Part[#, measurementIndex]&,
                log
            ],
            {Now -> Null}
        ];

        Last[Nearest[timeDataAssoc, protocolDateComplete]]
    ];

    (* Uses the log for a field to create a table in the tooltip of the field with the most recent changes to the *)
    (* field before the end of the protocol. *)
    buildLogTooltip[log_List, measurementType_String, dateCompleted: _?DateObjectQ] := Module[
        {
            firstLogEntry, firstDateObject, dateObjectPosition, allDates, nearestDate, logEntryLength,
            nearestDatePattern, nearestLogEntry, nearestLogEntryPosition, maxDisplayedEntries, nearestLogEntries,
            logTableHeadings, nearestLogTable
        },

        (* Figure out where the date is in each log entry. *)
        firstLogEntry = First[log];
        firstDateObject = FirstCase[firstLogEntry, _?DateObjectQ];
        dateObjectPosition = First[Flatten[Position[firstLogEntry, firstDateObject]]];

        (* Determine which log entry is the nearest to the completion date. *)
        allDates = log[[All, dateObjectPosition]];
        nearestDate = Last[Nearest[allDates, dateCompleted]];
        logEntryLength = Length[firstLogEntry];
        nearestDatePattern = Insert[ConstantArray[___, (logEntryLength - 1)], nearestDate, dateObjectPosition];
        nearestLogEntry = FirstCase[log, nearestDatePattern];

        (* Pull out the ten or fewer log entries that is closest to the completion date. *)
        maxDisplayedEntries = 5;
        nearestLogEntryPosition = First[Flatten[Position[log, nearestLogEntry]]];
        nearestLogEntries = If[nearestLogEntryPosition > maxDisplayedEntries,
            log[[(nearestLogEntryPosition - maxDisplayedEntries) ;; nearestLogEntryPosition]],
            log[[;; nearestLogEntryPosition]]
        ];

        (* Build the tooltip. *)
        logTableHeadings = Switch[measurementType,
            ("Mass"|"Volume"),
                {None, {"Date", measurementType, "Responsible Party", "Measurement Type"}},
            ("pH"|"Conductivity"|"Density"|"Status"),
                {None, {"Date", measurementType, "Responsible Party"}},
            ("Refractive Index"),
                {None, {"Date", "Temperature", measurementType, "Responsible Party"}},
            _,
                Automatic
        ];

        nearestLogTable = PlotTable[
            nearestLogEntries,
            TableHeadings -> logTableHeadings,
            Background -> {
                None,
                {{
                    RGBColor[0.8862745098039215`, 0.8862745098039215`, 0.8862745098039215`],
                    RGBColor[1, 1, 1]
                }}
            }
        ];

        Column[
            {
                nearestLogTable,
                "Copy value to clipboard"
            }
        ]
    ];

    (** Set up helpers or associations to format and prepare protocol-specific sample fields. **)
    (* Build an association between SamplesIn and values for an index-matched field found in a data object. *)
    dataBuildDataAssociation[field_] := Module[{fieldValues, injectionSamplesIn, uniqueSamples},
        {fieldValues, injectionSamplesIn} = Transpose[
            Lookup[protocolDataPacket, {field, SamplesIn}]
        ];

        uniqueSamples = DeleteDuplicates[Download[Flatten[injectionSamplesIn], Object]];

        Map[
            # -> DeleteDuplicates[Flatten[PickList[fieldValues, injectionSamplesIn, {___, ObjectP[#], ___}]]]&,
            uniqueSamples
        ]
    ];

    (* Build an association between SamplesIn and values for an index-matched field found in the protocol object. *)
    protocolBuildDataAssociation[field_] := Module[{fieldValue, samplesIn, uniqueSamplesIn},
        {fieldValue, samplesIn} = Lookup[protocolPacket, {field, SamplesIn}];

        uniqueSamplesIn = DeleteDuplicates[Download[Flatten[samplesIn], Object]];

        Map[
            # -> DeleteDuplicates[Flatten[PickList[fieldValue, samplesIn, ObjectP[#]]]]&,
            uniqueSamplesIn
        ]
    ];

    (* Based on the protocol type, build an association between index-matched field values and the samples that they pertain to. *)
    {sampleDataHeader, sampleDataAssociation} = Switch[protocol,
        ObjectP[{Object[Protocol, HPLC], Object[Protocol, GasChromatography]}],
            {"Injection Indexes", dataBuildDataAssociation[InjectionIndex]},
        ObjectP[Object[Protocol, Degas]],
            {"Freeze-Pump-Thaw Cycles", protocolBuildDataAssociation[NumberOfCycles]},
        ObjectP[Object[Protocol, MeasureOsmolality]],
            {"Osmolality", dataBuildDataAssociation[Osmolality]},
        _,
            {"", <||>}
    ];

    (** Helper functions to create a table for each sample - agnostic to container type, but dependent on the object type **)

    (* If the sample is a string, then it is a label from the preparatory unit operations. A message about the sample is returned *)
    (* since there is no information uploaded about the sample yet. *)
    generateSampleInfoTable[
        sampleLabel: _String,
        indexes: ({_Integer..}|Null),
        indexHeader_String
    ] := stylizeHeader[
        InsertLinebreaks[
            StringJoin[
                "A sample object with the label ",
                sampleLabel,
                " will be generated using preparatory unit operations. It will be used for ",
                indexHeader,
                " indexes ",
                ToString[indexes],
                " for ",
                ToString[InputForm[protocol]]
            ],
            100
        ]
    ];

    (* If the sample is a model, then provide information about the model that will be used in a table. *)
    generateSampleInfoTable[
        sampleModel: ObjectP[Model[Sample]],
        indexes: ({_Integer..}|Null),
        indexHeader_String
    ] := Module[
        {
            currentSampleModelPacket, resourcePacket, sampleHeaderInfoTuples, sampleModelHeaders, sampleModelInfo,
            resourceObject, amountRequested, purchased, preparationProtocol, requestor, resourceField,
            stringResourceField, resourceHeaderInfoTuples, resourceInfo, resourceHeaders, compositionTable,
            formattedCompositionTable, allModelInformation, allModelInformationHeaders, sampleModelTable,
            modelPreamble
        },

        currentSampleModelPacket = FirstCase[
            allCurrentSamplePackets,
            KeyValuePattern[Object -> ObjectP[sampleModel]]
        ];

        (* Find the packet pertaining to the resource for this specific model (if it's not a SamplesIn or SamplesOut). *)
        resourcePacket = Which[
            MemberQ[Keys[requiredResourceToSampleAssociation], sampleModel],
                FirstCase[
                    currentRequiredResourcePackets,
                    KeyValuePattern[
                        Object -> ObjectP[Lookup[requiredResourceToSampleAssociation, sampleModel]]
                    ]
                ],
            MemberQ[Keys[subprotocolRequiredResourceToSampleAssociation], sampleModel],
                FirstCase[
                    currentSubprotocolRequiredResourcePackets,
                    KeyValuePattern[
                        Object -> ObjectP[Lookup[subprotocolRequiredResourceToSampleAssociation, sampleModel]]
                    ]
                ],
            True,
                <||>
        ];

        (* A list of information that we are pulling out and displaying for a model and the field that it corresponds to. *)
        sampleHeaderInfoTuples = {
            {"Model Object", Object},
            {"State", State},
            {"Sterile", Sterile},
            {"Default Storage Condition", DefaultStorageCondition},
            {"Shelf Life", ShelfLife},
            {"Unsealed Shelf Life", UnsealedShelfLife},
            {"Sample Handling", SampleHandling},
            {"Transfer Temperature",  TransferTemperature},
            {"Products", Products},
            {"Kit Products", KitProducts},
            {"MSDS File",  MSDSFile}
        };

        (* Create a list of formatted headers and sample information to be put into the table. *)
        {sampleModelHeaders, sampleModelInfo} = Transpose[
            Map[
                Module[{sampleInfo},
                    sampleInfo = Lookup[currentSampleModelPacket, #[[2]], Null];

                    If[MatchQ[sampleInfo, Except[Null]],
                        {
                            formatHeader[#[[1]], sampleInfo],
                            formatSampleInformation[sampleInfo]
                        },
                        Nothing
                    ]
                ]&,
                sampleHeaderInfoTuples
            ]
        ];

        (* Assemble resource information if pertinent. *)
        {resourceObject, amountRequested, purchased, preparationProtocol} = Lookup[
            resourcePacket,
            {Object, Amount, Purchase, Preparation},
            Null
        ];

        requestor = Cases[
            Cases[Lookup[resourcePacket, Requestor, {}], ObjectP[Object[Protocol]]],
            Except[ObjectP[protocol]]
        ];

        resourceField = Lookup[resourceToFieldAssociation, resourceObject, Null];

        stringResourceField = If[MatchQ[resourceField, Except[Null]],
            StringJoin[
                ToString[InputForm[protocol]],
                "[",
                ToString[resourceField],
                "]"
            ],
            Null
        ];

        resourceHeaderInfoTuples = {
            {"Resource", resourceObject},
            {"Resource Field", stringResourceField},
            {"Amount Requested", amountRequested},
            {"Purchased", purchased},
            {"Preparation", preparationProtocol},
            {"Subprotocols", requestor}
        };

        {resourceHeaders, resourceInfo} = Transpose[
            Map[
                If[MatchQ[#[[2]], Except[Null]],
                    {
                        formatHeader[Sequence @@ #],
                        formatSampleInformation[#[[2]]]
                    },
                    Nothing
                ]&,
                resourceHeaderInfoTuples
            ]
        ];

        (* Create a composition table for the model (one that can be copied and pasted, the other to be displayed in the table. *)
        (* The displayed table may have a scrollbar, so needs to be separate from the full table that can be copied. *)
        {compositionTable, formattedCompositionTable} = formatCompositionTable[
            Lookup[currentSampleModelPacket, Composition, Null]
        ];

        (* Format all information and headers. *)
        allModelInformation = Cases[
            Join[
                {sampleModelInfo[[1]]},
                resourceInfo,
                sampleModelInfo[[2;;]],
                {formattedCompositionTable}
            ],
            Except[Null]
        ];

        (* If it's the image header, give it the same functionality as the appearance button. *)
        allModelInformationHeaders = Cases[
            Join[
                {sampleModelHeaders[[1]]},
                resourceHeaders,
                sampleModelHeaders[[2;;]],
                {
                    If[!NullQ[compositionTable],
                        formatHeader[
                            "Composition",
                            compositionTable
                        ],
                        Null
                    ]
                }
            ],
            Except[Null]
        ];

        (* Can't use PlotTable because functionality of the composition table is lost. *)
        (* So using a grid with the settings that PlotTable uses.*)
        sampleModelTable = Grid[
            Transpose[{allModelInformationHeaders, allModelInformation}],
            ReplaceRule[
                $PlotTableGridOptions,
                {
                    ItemSize -> {{All, 25}},
                    Dividers -> {
                        {
                            Directive[RGBColor[0.796078431372549`, 0.796078431372549`, 0.796078431372549`], Thickness[1]],
                            {
                                1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                                -1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                                2 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]]
                            }
                        },
                        {
                            Directive[RGBColor[0.796078431372549`, 0.796078431372549`, 0.796078431372549`], Thickness[1]],
                            {
                                1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                                -1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]]
                            }
                        }
                    }
                }
            ]
        ];

        (* Create a preamble to go above the information table about how the model will be used in the protocol. *)
        modelPreamble = If[MatchQ[indexes, Null],
            stylizeHeader[
                InsertLinebreaks[
                    StringJoin[
                        "An object of ",
                        ToString[InputForm[sampleModel]],
                        " will be used ",
                        If[!NullQ[resourceField],
                            "as " <> ToString[resourceField] <> " ",
                            Nothing
                        ],
                        "for ",
                        ToString[InputForm[protocol]]
                    ],
                    100
                ]
            ],
            stylizeHeader[
                InsertLinebreaks[
                    StringJoin[
                        "An object of ",
                        ToString[InputForm[sampleModel]],
                        " will be used for ",
                        indexHeader,
                        " indexes ",
                        ToString[indexes],
                        " for ",
                        ToString[InputForm[protocol]]
                    ],
                    100
                ]
            ]
        ];

        Column[
            {
                modelPreamble,
                sampleModelTable
            }
        ]
    ];

    (* If the sample is a sample object, then pull information from the object and display in a table. *)
    generateSampleInfoTable[
        sampleObject: ObjectP[Object[Sample]],
        indexes: ({_Integer..}|Null),
        indexHeader_String
    ] := Module[
        {
            currentSamplePacket, protStartSamplePacket, protCompleteSamplePacket, resourcePacket, sampleID, sampleExpirationDate,
            sampleVolumeLog, sampleMassLog, sampleStatusLog, measurementField, measurementString, measurementLog,
            sampleProtCompleteModel, sampleProtCompleteState, sampleProtStartState, sampleProtStartComposition,
            sampleProtCompleteComposition, compositionTable, formattedCompositionTable, protCompleteVolume,
            protCompleteMass, protCompleteMeasurement, protCompleteStatus, protCompleteContainer, protCompleteContainerModel,
            timeUntilExpiration, coverOffDuration, stateChange, image, cloudFile, protCompleteSampleImage,
            volumeLogTooltip, massLogTooltip, measurementLogToolTip, sampleStatusTooltip, resourceObject,
            amountUsed, purchased, preparationProtocol, requestor, resourceField, stringResourceField,
            defaultInformationHeaders, defaultSampleInformation, defaultTooltips, protocolInformationHeaders,
            protocolSampleInformation, protocolTooltips, allSampleInformation, allInformationHeaders,
            transfersInGraphButton, transfersInDate, transfersInLevelsDown, transfersInString
        },

        (* Get all packets associated with the input sample object. *)
        {currentSamplePacket, protStartSamplePacket, protCompleteSamplePacket} = Map[
            Module[{sampleObjectPacket},
                sampleObjectPacket = Cases[#, KeyValuePattern[Object -> ObjectP[sampleObject]]];

                If[MatchQ[sampleObjectPacket, Except[{}]],
                    First[sampleObjectPacket],
                    <||>
                ]
            ]&,
            {
                allCurrentSamplePackets,
                allProtocolStartSampleData,
                allProtocolCompleteSampleData
            }
        ];

        (* If the sample is associated with a resource and is not a SamplesIn nor SamplesOut, then get the *)
        (* resource packet associated with the sample.*)
        resourcePacket = Which[
            MemberQ[Keys[requiredResourceToSampleAssociation], sampleObject],
                FirstCase[
                    currentRequiredResourcePackets,
                    KeyValuePattern[
                        Object -> ObjectP[Lookup[requiredResourceToSampleAssociation, sampleObject]]
                    ]
                ],
            MemberQ[Keys[subprotocolRequiredResourceToSampleAssociation], sampleObject],
                FirstCase[
                    currentSubprotocolRequiredResourcePackets,
                    KeyValuePattern[
                        Object -> ObjectP[Lookup[subprotocolRequiredResourceToSampleAssociation, sampleObject]]
                    ]
                ],
            True,
                <||>
        ];

        (* Get needed info from downloaded packets. *)
        {sampleID, sampleExpirationDate} = Lookup[currentSamplePacket, {ID, ExpirationDate}, Null];

        {sampleVolumeLog, sampleMassLog, sampleStatusLog} = Lookup[
            currentSamplePacket,
            {VolumeLog, MassLog, StatusLog},
            {}
        ];

        (* Based on the type of protocol, get the log of the measurement that was made during the protocol. *)
        {measurementField, measurementString} = Switch[protocol,
            ObjectP[Object[Protocol, MeasurepH]],
                {pHLog, "pH"},
            ObjectP[Object[Protocol, MeasureConductivity]],
                {ConductivityLog, "Conductivity"},
            ObjectP[Object[Protocol, MeasureDensity]],
                {DensityLog, "Density"},
            _,
                {Null, ""}
        ];

        measurementLog = Lookup[currentSamplePacket, measurementField, {}];

        (* There is not a log for model, state, or composition, so just pull from the sample packet at the end of the protocol. *)
        {sampleProtCompleteModel, sampleProtCompleteState} = Lookup[protCompleteSamplePacket, {Model, State}, Null];

        sampleProtStartState = Lookup[protStartSamplePacket, State, Null];

        sampleProtStartComposition = Lookup[protStartSamplePacket, Composition, {}];
        sampleProtCompleteComposition = Lookup[protCompleteSamplePacket, Composition, {}];

        (* Make a composition table. *)
        {compositionTable, formattedCompositionTable} = formatCompositionTable[sampleProtCompleteComposition];

        (* Pull info from information logs based on the protocol completion date. *)
        {protCompleteVolume, protCompleteMass, protCompleteMeasurement, protCompleteStatus} = Map[
            pickNearestLogEntry[#, 2]&,
            {sampleVolumeLog, sampleMassLog, measurementLog, sampleStatusLog}
        ];

        protCompleteContainer = Lookup[sampleContainerAssociation, sampleObject, Null];

        protCompleteContainerModel = If[MatchQ[protCompleteContainer, Except[Null]],
            Lookup[
                FirstCase[allCurrentContainerPackets, KeyValuePattern[Object -> ObjectP[protCompleteContainer]]],
                Model
            ],
            Null
        ];

        (* Calculate the time until expiration and time that containers didn't have a cover. *)
        timeUntilExpiration = If[MatchQ[sampleExpirationDate, Except[Null]],
            sampleExpirationDate - protocolDateComplete,
            Null
        ];

        coverOffDuration = If[MatchQ[protCompleteContainer, ObjectP[Object[Container]]],
            Module[
                {
                    containerObjectPacket, containerCoverLog, protocolCoverEntries
                },

                (* Fetch the cover log. *)
                containerObjectPacket = FirstCase[
                    allCurrentContainerPackets,
                    KeyValuePattern[Object -> ObjectP[protCompleteContainer]]
                ];
                containerCoverLog = Lookup[containerObjectPacket, CoverLog];

                (* Pull out on/off entry pairs made during the protocol. *)
                protocolCoverEntries = Select[
                    containerCoverLog,
                    And[
                        #[[1]] > protocolDateStart,
                        #[[1]] < protocolDateComplete
                    ]&
                ];

                (* Determine the time that the cover was off during the protocol using the entries made during the protocol. *)
                (* Walk through the cover entries, and if an Off-On pair is found, calculate the time that the cover was off. *)
                If[Length[protocolCoverEntries] > 0,
                    Total[
                        Map[
                            Module[{earlierCoverEntry, laterCoverEntry, coverTypes, earlierTime, laterTime},
                                {earlierCoverEntry, laterCoverEntry} = protocolCoverEntries[[# ;; (# + 1)]];
                                coverTypes = {earlierCoverEntry, laterCoverEntry}[[All, 2]];
                                {earlierTime, laterTime} = Map[First, {earlierCoverEntry, laterCoverEntry}];

                                If[MatchQ[coverTypes, {Off, On}],
                                    laterTime - earlierTime,
                                    Nothing
                                ]
                            ]&,
                            Range[Length[protocolCoverEntries] - 1]
                        ]
                    ],
                    0 Second
                ]
            ],
            Null
        ];

        (* Determine if there was a state change during the protocol. *)
        stateChange = If[
            And[
                MatchQ[{sampleProtStartState, sampleProtCompleteState}, {ModelStateP, ModelStateP}],
                !MatchQ[sampleProtStartState, sampleProtCompleteState],
                MatchQ[sampleProtStartComposition, sampleProtCompleteComposition]
            ],
            Switch[{sampleProtStartState, sampleProtCompleteState},
                {Liquid, Gas},
                    "Evaporation",
                {Liquid, Solid},
                    "Freezing",
                {Solid, Liquid},
                    "Melting",
                {Solid, Gas},
                    "Sublimation",
                {Gas, Liquid},
                    "Condensation",
                {Gas, Solid},
                    "Deposition"
            ],
            Null
        ];

        (* Format a picture of the sample. *)
        {image, cloudFile} = Lookup[sampleImageCloudFileAssociation, sampleObject];
        protCompleteSampleImage = If[MatchQ[{image, cloudFile}, Except[{Null, Null}]],
            formatImage[image, cloudFile],
            Null
        ];

        (* Set up tooltips for pertinent sample information. *)
        {volumeLogTooltip, massLogTooltip, measurementLogToolTip, sampleStatusTooltip} = MapThread[
            If[MatchQ[#1, Except[{}]],
                buildLogTooltip[#1, #2, protocolDateComplete],
                Null
            ]&,
            {
                {sampleVolumeLog, sampleMassLog, measurementLog, sampleStatusLog},
                {"Volume", "Mass", measurementString, "Status"}
            }
        ];

        (* Assemble resource information if pertinent. *)
        {resourceObject, amountUsed, purchased, preparationProtocol} = Lookup[
            resourcePacket,
            {Object, Amount, Purchase, Preparation},
            Null
        ];

        requestor = Cases[
            Cases[Lookup[resourcePacket, Requestor, {}], ObjectP[Object[Protocol]]],
            Except[ObjectP[protocol]]
        ];

        resourceField = Lookup[resourceToFieldAssociation, resourceObject, Null];

        stringResourceField = If[MatchQ[resourceField, Except[Null]],
            StringJoin[
                ToString[InputForm[protocol]],
                "[",
                ToString[resourceField],
                "]"
            ],
            Null
        ];

        (* Resolve the Date option for TransfersInGraph for this sample. *)
        transfersInDate = Which[
            (* If the protocol is completed and this sample is NOT one of the SamplesIn, use the protocol's completion date. *)
            protocolCompleteQ && MemberQ[Flatten[{samplesOutObjects, requiredResourceSampleObjects, subprotocolRequiredResourceSampleObjects}], ObjectP[sampleObject]], protocolDateComplete,
            (* If the protocol is ongoing and this sample is NOT one of the SamplesIn, use Now. *)
            !protocolCompleteQ && MemberQ[Flatten[{samplesOutObjects, requiredResourceSampleObjects, subprotocolRequiredResourceSampleObjects}], ObjectP[sampleObject]], Now,
            (* Otherwise, use the protocol's start date. Note that this variable is defined as Now if no start date can be found. *)
            True, protocolDateStart
        ];

        (* If there are more than 20 samples in this protocol, show no more than 3 levels down in all of the TransfersInGraphs *)
        {transfersInLevelsDown, transfersInString} = If[GreaterQ[Length[Flatten @ {samplesInObjects, samplesOutObjects, requiredResourceSampleObjects, subprotocolRequiredResourceSampleObjects}], 20],
            {3, "Plot 3 most recent TransfersIn prior to "},
            {All, "Plot all TransfersIn prior to "}
        ];

        (* Generate the transfers in graph and incorporate into the table. *)
        transfersInGraphButton = With[
            {
                graph = Quiet[
                    TransfersInGraph[sampleObject, Date -> transfersInDate, LevelsDown -> transfersInLevelsDown, ProgressIndicator -> False],
                    {Warning::NoTransfersIntoSample, Warning::DateInFuture, Warning::DateBeforeCreation}
                ],
                explicitTransferString = transfersInString,
                explicitDate = transfersInDate
            },
            Tooltip[
                Button[
                    Style["Examine Transfer Graph", 14, "Helvetica"],
                    CreateDocument[graph],
                    Appearance -> None,
                    Method -> "Queued"
                ],
                explicitTransferString<>DateString[explicitDate]
            ]
        ];

        (* Assemble default information and plot headers (used regardless of protocol type). *)
        {defaultInformationHeaders, defaultSampleInformation, defaultTooltips} = Transpose[
            Join[
                {
                    {"Object", sampleObject, Null},
                    If[
                        MatchQ[protCompleteStatus, Discarded],
                        {"Status", protCompleteStatus, sampleStatusTooltip},
                        Nothing
                    ],
                    {"Resource", resourceObject, Null},
                    {"Resource Field", stringResourceField, Null},
                    {"Amount Requested", amountUsed, Null},
                    {"Purchased", purchased, Null},
                    {"Preparation", preparationProtocol, Null},
                    {"Subprotocols", requestor, Null},
                    {indexHeader <> " Indexes", indexes, Null},
                    {"Model", sampleProtCompleteModel, Null},
                    {"State", sampleProtCompleteState, Null},
                    {"State Change", stateChange, Null},
                    If[MatchQ[sampleProtCompleteState, Liquid],
                        {"Volume", protCompleteVolume, volumeLogTooltip},
                        {"Mass", protCompleteMass, massLogTooltip}
                    ],
                    {"Container", protCompleteContainer, Null},
                    {"Container Model", protCompleteContainerModel, Null},
                    {"Cover Off Duration", coverOffDuration, Null}
                },
                Which[
                    MatchQ[protCompleteStatus, Discarded],
                        {},
                    MatchQ[timeUntilExpiration, GreaterP[0 Second]],
                        {
                            {"Expiration Date", sampleExpirationDate, Null},
                            {"Time Until Expiration", timeUntilExpiration, Null}
                        },
                    MatchQ[timeUntilExpiration, LessP[0 Second]],
                        {
                            {"Expiration Date", sampleExpirationDate, Null},
                            {"Time Since Expiration", (-1 * timeUntilExpiration), Null}
                        },
                    True,
                        {}
                ]
            ]
        ];

        (* Assemble protocol-dependent information and plot headers. *)
        {protocolInformationHeaders, protocolSampleInformation, protocolTooltips} = Transpose[
            If[MatchQ[indexHeader, Except[""]],
                Switch[protocol,
                    ObjectP[
                        {
                            Object[Protocol, HPLC], Object[Protocol, GasChromatography],
                            Object[Protocol, Degas], Object[Protocol, MeasureOsmolality]
                        }
                    ],
                        {
                            {sampleDataHeader, Lookup[sampleDataAssociation, sampleObject, Null], Null}
                        },
                    ObjectP[
                        {
                            Object[Protocol, MeasurepH], Object[Protocol, MeasureConductivity],
                            Object[Protocol, MeasureDensity]
                        }
                    ],
                        {
                            {measurementString, protCompleteMeasurement, measurementLogToolTip}
                        },
                    ObjectP[Object[Protocol, MeasureRefractiveIndex]],
                        Module[{refractiveIndexLog, refractiveIndex, temperature, refractiveIndexLogTooltip},
                            refractiveIndexLog = Lookup[currentSamplePacket, RefractiveIndexLog];

                            {temperature, refractiveIndex} = If[MatchQ[Lookup[currentSamplePacket, RefractiveIndexLog], Except[{}]],
                                pickNearestLogEntry[refractiveIndexLog, {2, 3}],
                                {Null, Null}
                            ];

                            refractiveIndexLogTooltip = buildLogTooltip[
                                refractiveIndexLog,
                                "Refractive Index",
                                protocolDateComplete
                            ];

                            {
                                {"Refractive Index", refractiveIndex, refractiveIndexLogTooltip},
                                {"Refractive Index Temperature", temperature, refractiveIndexLogTooltip}
                            }
                        ],
                    _,
                        {
                            {"", Null, Null}
                        }
                ],
                {
                    {"", Null, Null}
                }
            ]
        ];

        (* Format all information and headers. *)
        (* Use NamedObject similar to PlotTable to format non-appearance-button items. *)
        allSampleInformation = Cases[
            Join[
                {
                    protCompleteSampleImage
                },
                MapThread[
                    formatSampleInformation[#1, #2]&,
                    {
                        Join[defaultSampleInformation[[;;2]], protocolSampleInformation, defaultSampleInformation[[3;;]]],
                        Join[defaultTooltips[[;;2]], protocolTooltips, defaultTooltips[[3;;]]]
                    }
                ],
                {
                    formattedCompositionTable,
                    transfersInGraphButton
                }
            ],
            Except[Null]
        ];

        (* If it's the image header, give it the same functionality as the appearance button. *)
        allInformationHeaders = Cases[
            Join[
                {
                    If[!NullQ[protCompleteSampleImage],
                        With[{explicitCloudFile = cloudFile},
                            Tooltip[
                                Button[
                                    stylizeHeader["Appearance"],
                                    OpenCloudFile[explicitCloudFile],
                                    Appearance -> None,
                                    Method -> "Queued"
                                ],
                                "Open Image"
                            ]
                        ],
                        Null
                    ]
                },
                MapThread[
                    formatHeader[#, #2]&,
                    {
                        Join[defaultInformationHeaders[[;;2]], protocolInformationHeaders, defaultInformationHeaders[[3;;]]],
                        Join[defaultSampleInformation[[;;2]], protocolSampleInformation, defaultSampleInformation[[3;;]]]
                    }
                ],
                {
                    If[!NullQ[compositionTable],
                        formatHeader[
                            "Composition",
                            compositionTable
                        ],
                        Null
                    ]
                },
                {
                    stylizeHeader["TransfersInGraph"]
                }
            ],
            Except[Null]
        ];

        (* Can't use PlotTable because functionality of the picture/appearance "button" and expandable composition table are lost. *)
        (* So using a grid with the settings that PlotTable uses. If appearance is included, then adjust those *)
        (* settings to keep functionality of appearance button and match PlotTable formatting. *)
        Grid[
            Transpose[{allInformationHeaders, allSampleInformation}],
            ReplaceRule[
                $PlotTableGridOptions,
                Join[
                    If[!NullQ[protCompleteSampleImage],
                        {
                            Background -> {
                                None,
                                {{
                                    None,
                                    RGBColor[0.8862745098039215`, 0.8862745098039215`, 0.8862745098039215`]
                                }}
                            },
                            Alignment -> {
                                Left, Center,
                                Append[
                                    Map[{#, 1} -> {Center, Center}&, Range[Length[allInformationHeaders]]],
                                    {1, 2} -> {Center, Center}
                                ]
                            }
                        },
                        {}
                    ],
                    {
                        ItemSize -> {{All, 25}},
                        Dividers -> {
                            {
                                Directive[RGBColor[0.796078431372549`, 0.796078431372549`, 0.796078431372549`], Thickness[1]],
                                {
                                    1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                                    -1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                                    2 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]]
                                }
                            },
                            {
                                Directive[RGBColor[0.796078431372549`, 0.796078431372549`, 0.796078431372549`], Thickness[1]],
                                {
                                    1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]],
                                    -1 -> Directive[RGBColor[0.5568627450980392`, 0.5568627450980392`, 0.5568627450980392`],Thickness[1]]
                                }
                            }
                        }
                    }
                ]
            ]
        ]
    ];


    (* Helper function to plot a plate object with a valid model. *)
    plateLegend = SwatchLegend[
        {RGBColor["#22B893"], RGBColor["#595C5B"], Lighter[Gray, 0.9]},
        {"Protocol Sample", "Occupied Well", "Empty Well"},
        LegendLayout -> "Row"
    ];

    (* Create a dynamic plot of a plate with information that pertains to the state of the plot at the end of the protocol. *)
    plotPlate[
        plateObject: ObjectP[Object[Container, Plate]],
        sampleObjects: {ObjectP[Object[Sample]]..},
        sampleTables: {_Grid..}
    ] := DynamicModule[
        {
            currentPlateObjectPacket, plateModel, plateModelPacket, protCompletePlateObjectPacket,
            protCompletePlateContents, protCompleteOccupiedWells, sampleToTableAssociation,
            wellToSampleTableAssociation, plateDimensions, positions, positionPlotting, wellDiameter, wellDimensions,
            formatQuantity, formattedPlateDimensions, formattedWellDiameter, formattedWellDimensions,
            formatted2DPlateDimensions, formattedAdjustedWellDiameter, formattedAdjustedWellDimensions, activeWells,
            inactiveWells, emptyWells, activeWellPositionPlotting, inactiveWellPositionPlotting, emptyWellPositionPlotting,
            activeWellPositions, inactiveWellPositions, emptyWellPositions, createWellGraphic, activeWellGraphics,
            displayedTable = First[sampleTables], wellSelectedQs = Prepend[ConstantArray[0.5, Length[sampleObjects]-1], 0],
            inactiveWellGraphics, emptyWellGraphics, wellNames, wellColumnLetters, wellRowDigits, traditionalWellPattern,
            wellLabels
        },

        (* Get packets for the plate object and model. *)
        currentPlateObjectPacket = FirstCase[allCurrentContainerPackets, KeyValuePattern[Object -> ObjectP[plateObject]]];
        plateModel = Lookup[currentPlateObjectPacket, Model];
        plateModelPacket = FirstCase[allCurrentContainerPackets, KeyValuePattern[Object -> ObjectP[plateModel]]];

        (* Get packets for the plate object from the end of the protocol (for fields without logs). *)
        protCompletePlateObjectPacket = FirstCase[
            flattenedProtCompleteContainerPackets,
            KeyValuePattern[Object -> ObjectP[plateObject]]
        ];
        protCompletePlateContents = Lookup[protCompletePlateObjectPacket, Contents];
        protCompleteOccupiedWells = protCompletePlateContents[[All, 1]];

        (* Associate sample objects to the tables with sample information that will be displayed when the sample/well is selected. *)
        sampleToTableAssociation = MapThread[
            #1 -> #2&,
            {sampleObjects, sampleTables}
        ];

        (* Create an assocation between the well of the plate and the sample (with it's associated table) that *)
        (* occupied the well at the end of the protocol. *)
        wellToSampleTableAssociation = Map[
            Module[{well, sample, sampleTable},
                {well, sample} = {#[[1]], Download[#[[2]], Object]};
                sampleTable = Lookup[sampleToTableAssociation, sample, Null];

                well -> {sample, sampleTable}
            ]&,
            protCompletePlateContents
        ];

        (* Lookup physical dimension information about the plate and well. *)
        {
            plateDimensions, positions, positionPlotting, wellDiameter, wellDimensions
        } = Lookup[
            plateModelPacket,
            {
                Dimensions, Positions, PositionPlotting, WellDiameter, WellDimensions
            }
        ];

        (* Helper function to standardize quantities. This makes sure that a plate that is 1 x 1 meter has a similar *)
        (* display to a plate that is 1 x 1 centimeter. *)
        formatQuantity[quantity: (_Quantity|Null)] := If[MatchQ[quantity, _Quantity],
            (Unitless[quantity, Meter]) / (Unitless[First[plateDimensions]]),
            Null
        ];
        formatQuantity[quantities: {(_Quantity|Null)..}] := Map[formatQuantity, quantities];

        (* Format all plate and well dimensions. *)
        {formattedPlateDimensions, formattedWellDiameter, formattedWellDimensions} = Map[
            formatQuantity,
            {plateDimensions, wellDiameter, wellDimensions}
        ];

        formatted2DPlateDimensions = formattedPlateDimensions[[1;;2]];

        (* If there is not a well diameter, make an estimate based on other plate information. *)
        formattedAdjustedWellDiameter = Which[
            (* If the well shape is a circle and well dimensions are informed, use the mean of the well dimensions. *)
            And[
                MemberQ[Lookup[positionPlotting, CrossSectionalShape], Circle],
                NullQ[formattedWellDiameter],
                !NullQ[formattedWellDimensions]
            ],
                Mean[formattedWellDimensions],
            (* If the well shape is a circle and well dimensions are not informed, use the well coordinates and *)
            (* plate dimensions to estimate the diameter. *)
            And[
                MemberQ[Lookup[positionPlotting, CrossSectionalShape], Circle],
                NullQ[formattedWellDiameter],
                NullQ[formattedWellDimensions]
            ],
                Module[{minXSpacing, minYSpacing},
                    {minXSpacing, minYSpacing} = Map[
                        Module[{coordinatePositions},
                            coordinatePositions = Sort[DeleteDuplicates[Lookup[positionPlotting, #]]];

                            Min[
                                Map[
                                    coordinatePositions[[# + 1]] - coordinatePositions[[#]]&,
                                    Range[Length[coordinatePositions]][[;;-2]]
                                ]
                            ]
                        ]&,
                        {XOffset, YOffset}
                    ];

                    formatQuantity[Min[{minXSpacing, minYSpacing}] * 0.75]
                ],
            True,
                formattedWellDiameter
        ];

        (* If there are not well dimensions, make an estimate based on other plate information. *)
        formattedAdjustedWellDimensions = Which[
            (* If the well is square or rectangluar and has a well diameter, use the well diameter as the well dimensions. *)
            And[
                MemberQ[Lookup[positionPlotting, CrossSectionalShape], Except[Circle]],
                NullQ[wellDimensions],
                !NullQ[formattedWellDiameter]
            ],
                {formattedWellDiameter, formattedWellDiameter},
            (* If the well is square or rectangular and does not have a well diameter, use the well coordinates and *)
            (* plate dimensions to estimate the well dimensions. *)
            And[
                MemberQ[Lookup[positionPlotting, CrossSectionalShape], Except[Circle]],
                NullQ[wellDimensions],
                NullQ[formattedWellDiameter]
            ],
                Map[
                    Module[{coordinatePositions, minValue},
                        coordinatePositions = Sort[DeleteDuplicates[Lookup[positionPlotting, #]]];

                        minValue = Min[
                            Map[
                                coordinatePositions[[# + 1]] - coordinatePositions[[#]]&,
                                Range[Length[coordinatePositions]][[;;-2]]
                            ]
                        ];

                        formatQuantity[minValue] * 0.75
                    ]&,
                    {XOffset, YOffset}
                ],
            True,
            formattedWellDimensions
        ];

        (* Active wells are samples in the SamplesIn/SamplesOut, inactive are occupied wells but the samples aren't *)
        (* in SamplesIn/SamplesOut of the protocol, and empty wells are unoccupied wells. *)
        activeWells = Cases[protCompletePlateContents, {_, ObjectP[sampleObjects]}][[All, 1]];
        inactiveWells = Complement[protCompleteOccupiedWells, activeWells];
        emptyWells = Complement[Lookup[positionPlotting, Name] , {activeWells, inactiveWells}];

        (* Pull the positions and position plotting of each well, sorted by whether the well was occupied and *)
        (* of interest to the protocol or not. *)
        {activeWellPositionPlotting, inactiveWellPositionPlotting, emptyWellPositionPlotting} = Map[
            Cases[positionPlotting, KeyValuePattern[Name -> Alternatives[Sequence@@#]]]&,
            {activeWells, inactiveWells, emptyWells}
        ];

        {activeWellPositions, inactiveWellPositions, emptyWellPositions} = Map[
            Cases[positions, KeyValuePattern[Name -> Alternatives[Sequence@@#]]]&,
            {activeWells, inactiveWells, emptyWells}
        ];

        (* Helper to create a graphic for each well using the well information. *)
        createWellGraphic[
            wellPosition_Association,
            wellPositionPlotting_Association
        ] := Module[
            {
                xCoordinate, yCoordinate, wellShape, wellName, rotation, formattedCoordinates,
                wellWidth, wellDepth, formattedSpecificWellDimensions, rawGraphic
            },

            (* Pull out and organize the well information. *)
            {xCoordinate, yCoordinate, wellShape, wellName, rotation} = Lookup[
                wellPositionPlotting,
                {XOffset, YOffset, CrossSectionalShape, Name, Rotation}
            ];

            {wellWidth, wellDepth} = Lookup[
                wellPosition,
                {MaxWidth, MaxDepth}
            ];

            (* Formate well coordinates. *)
            formattedCoordinates = Map[formatQuantity, {xCoordinate, yCoordinate}];
            formattedSpecificWellDimensions = Map[formatQuantity, {wellWidth, wellDepth}];

            (* Assemble the graphic based on the well shape. *)
            rawGraphic = Switch[wellShape,
                Circle,
                    Disk[
                        formattedCoordinates,
                        First[formattedSpecificWellDimensions]/2
                    ],
                Oval,
                    Disk[
                        formattedCoordinates,
                        formattedSpecificWellDimensions/2
                    ],
                _,
                    Rectangle[
                        formattedCoordinates - (formattedSpecificWellDimensions/2),
                        formattedCoordinates + (formattedSpecificWellDimensions/2)
                    ]
            ];

            Rotate[rawGraphic, rotation * Degree]
        ];

        (* Assemble graphics for wells that contained samples that were used in the protocol. *)
        activeWellGraphics = MapThread[
            Function[{wellPosition, wellPositionPlotting, index},
                Module[{wellName, sampleObject, wellTable, wellGraphic},
                    wellName = Lookup[wellPosition, Name];
                    {sampleObject, wellTable} = Lookup[wellToSampleTableAssociation, wellName];
                    wellGraphic = createWellGraphic[wellPosition, wellPositionPlotting];

                    (* Create a tooltip with the well and sample object and attach to the well graphic. *)
                    With[{savedWellTable = wellTable, savedIndex = index},
                        Tooltip[
                            Button[
                                wellGraphic,
                                (
                                    displayedTable = savedWellTable;
                                    wellSelectedQs = Insert[
                                        ConstantArray[0.5, Length[sampleObjects]-1],
                                        0,
                                        savedIndex
                                    ];
                                ),
                                Method -> "Queued"
                            ],
                            ToString[wellName] <> ", " <> ToString[InputForm[sampleObject]]
                        ]
                    ]
                ]
            ],
            {activeWellPositions, activeWellPositionPlotting, Range[Length[activeWellPositions]]}
        ];

        (* Assemble graphics for wells that contained samples that were NOT used in the protocol. *)
        inactiveWellGraphics = MapThread[
            Function[{wellPosition, wellPositionPlotting},
                Module[{wellName, wellGraphic, sampleObject},
                    wellName = Lookup[wellPosition, Name];
                    wellGraphic = createWellGraphic[wellPosition, wellPositionPlotting];
                    sampleObject = First[Lookup[wellToSampleTableAssociation, wellName]];

                    (* Create a tooltip with the well and sample object and attach to the well graphic. *)
                    Tooltip[
                        wellGraphic,
                        ToString[wellName] <> ", " <> ToString[InputForm[sampleObject]]
                    ]
                ]
            ],
            {inactiveWellPositions, inactiveWellPositionPlotting}
        ];

        (* Assemble graphics for wells that did not contain samples at the end of the protocol. *)
        emptyWellGraphics = MapThread[
            Function[{wellPosition, wellPositionPlotting},
                Module[{wellName, wellGraphic},
                    wellName = Lookup[wellPosition, Name];
                    wellGraphic = createWellGraphic[wellPosition, wellPositionPlotting];

                    Tooltip[
                        wellGraphic,
                        ToString[wellName]
                    ]
                ]
            ],
            {emptyWellPositions, emptyWellPositionPlotting}
        ];

        (** Create labels for well rows and columns that will be added along the edges of the plate graphic. **)
        (* Get all well names (aka A1, B2, C13) and determine which letters and numbers are used. *)
        wellNames = Lookup[positionPlotting, Name, {}];
        wellColumnLetters = DeleteDuplicates[
            Map[
                StringSplit[#, LetterCharacter..]&,
                wellNames
            ]
        ];
        wellRowDigits = DeleteDuplicates[
            Map[
                StringSplit[#, DigitCharacter..]&,
                wellNames
            ]
        ];

        (* A pattern for traditional well names such as A1, B1, C3 instead of "WellAThin" or "A12AA". *)
        traditionalWellPattern = _String?(StringMatchQ[#1,CharacterRange["A","Z"]..~~(DigitCharacter..)]&);

        (* Assemble the well labels to be used in the plate graphic (if they are traditional labels and the plate has a normal grid of wells). *)
        wellLabels = If[
            And[
                (* If no wells, then don't use labels. *)
                MatchQ[positionPlotting, Except[{}]],
                (* Only use labels if they match the traditional well pattern. *)
                MatchQ[wellNames, {traditionalWellPattern..}],
                (* Only use labels if letters go along vertical axis and numbers along horizontal axis (for now). *)
                Length[
                    DeleteDuplicates[
                        Lookup[
                            Cases[positionPlotting, KeyValuePattern[Name ->  _String?(StringMatchQ[#1,CharacterRange["A","Z"]..~~"1"]&)]],
                            XOffset
                        ]
                    ]
                ] == 1,
                (* Only use labels if it is a grid with uniform length and height. *)
                EqualQ[(Length[wellColumnLetters] * Length[wellRowDigits]), Length[positionPlotting]]
            ],
            Map[
                Function[{wellCharacter},
                    Module[{digitQ, adjacentWellPositionInfo, formattedAdjacentWell2DCoordinates, nearSideQ, wellHalfWidth, labelOffset, formattedLabelCoordinates},
                        (* Pull out the digit of the well (ex for "A1" it would be "1"). *)
                        digitQ = StringMatchQ[wellCharacter, (DigitCharacter|DigitCharacter..)];

                        (* Find the well that should be adjacent to the label on the plate graphic. *)
                        adjacentWellPositionInfo = If[digitQ,
                            FirstCase[positionPlotting, KeyValuePattern[Name -> StringJoin["A", wellCharacter]]],
                            FirstCase[positionPlotting, KeyValuePattern[Name -> StringJoin[wellCharacter, "1"]]]
                        ];

                        formattedAdjacentWell2DCoordinates = formatQuantity[Lookup[adjacentWellPositionInfo, {XOffset, YOffset}]];

                        (* Determine which side of the plate is closest to where the label should be. *)
                        nearSideQ = If[digitQ,
                            MatchQ[Nearest[{0, formatted2DPlateDimensions[[2]]}, formattedAdjacentWell2DCoordinates[[2]]], Except[{0}]],
                            MatchQ[Nearest[{0, formatted2DPlateDimensions[[1]]}, formattedAdjacentWell2DCoordinates[[1]]], Except[{0}]]
                        ];

                        (* Calcluate half of the well width along the axis of the label. *)
                        wellHalfWidth = Which[
                            MatchQ[Lookup[adjacentWellPositionInfo, CrossSectionalShape], Circle],
                                formattedAdjustedWellDiameter/2,
                            digitQ,
                                Last[formattedAdjustedWellDimensions]/2,
                            True,
                                First[formattedAdjustedWellDimensions]/2
                        ];

                        (* Determine how far the label should be from the edge of the plate graphic so that it is *)
                        (* nestled between the edge of the well and the edge of the plate. *)
                        labelOffset = Which[
                            And[digitQ, nearSideQ],
                                (Last[formatted2DPlateDimensions] - Last[formattedAdjacentWell2DCoordinates] + wellHalfWidth)/2,
                            digitQ,
                                (Last[formattedAdjacentWell2DCoordinates] + wellHalfWidth)/2,
                            nearSideQ,
                                (First[formatted2DPlateDimensions] - First[formattedAdjacentWell2DCoordinates] + wellHalfWidth)/2,
                            True,
                                (First[formattedAdjacentWell2DCoordinates] + wellHalfWidth)/2
                        ];

                        (* Based on where the label should be, calculate the coordinates of the label. *)
                        formattedLabelCoordinates = Which[
                            And[digitQ, nearSideQ],
                                formattedAdjacentWell2DCoordinates + {0, labelOffset},
                            digitQ,
                                formattedAdjacentWell2DCoordinates - {0, labelOffset},
                            nearSideQ,
                                formattedAdjacentWell2DCoordinates + {labelOffset, 0},
                            True,
                                formattedAdjacentWell2DCoordinates - {labelOffset, 0}
                        ];

                        (* Assemble the label *)
                        Text[
                            wellCharacter,
                            formattedLabelCoordinates
                        ]
                    ]
                ],
                Flatten[{wellColumnLetters, wellRowDigits}]
            ],
            {}
        ];

        (* Assemble components into a dynamic column. *)
        Column[
            {
                (* Container Object Header *)
                stylizeHeader[ToString[InputForm[plateObject]]],
                (* Plate Graphic *)
                (* NOTE: Graphic has to be in the column to dynamically update correctly. *)
                (* Can't assign to a separate variable and use it here. *)
                Graphics[
                    {
                        (* Plate Background *)
                        EdgeForm[Thickness[Large]], Lighter[Gray, 0.9], Rectangle[{0, 0}, formatted2DPlateDimensions],
                        (* Empty Wells *)
                        EdgeForm[Gray], Sequence@@emptyWellGraphics,
                        (* Inactive Wells *)
                        RGBColor["#595C5B"], Sequence@@inactiveWellGraphics,
                        (* Active Wells *)
                        Sequence@@Flatten[MapIndexed[
                            {
                                RGBColor["#22B893"],
                                (* NOTE: Graphics is picky about it's input, so have to change RGB numbers. *)
                                (* Can't pivot off of color expressions (ex. Gray) or color codes (ex. "#000000"). *)
                                EdgeForm[RGBColor[Dynamic[wellSelectedQs[[First[#2]]]], Dynamic[wellSelectedQs[[First[#2]]]], Dynamic[wellSelectedQs[[First[#2]]]]]],
                                #1
                            }&,
                            activeWellGraphics
                        ]],
                        (* Well Labels *)
                        Black, Sequence@@wellLabels
                    },
                    ImageSize -> 350
                ],
                plateLegend,
                Dynamic[displayedTable]
            },
            Spacings -> {
                {Automatic},
                {0, 0, 0.5, 2}
            },
            Alignment -> Center
        ]
    ];

    (** Generate content for samples in vessels/non-plates **)
    (* Create tables for samples in vessels *)
    {nonPlateSamplesInTables, nonPlateSamplesOutTables} = MapThread[
        Function[{sampleObjects, orderedSampleObjects, indexLabel},
            If[MatchQ[sampleObjects, Except[{}]],
                Module[{sortedSampleObjectsAndIndices},

                    (* Sort samples by their index in SamplesIn or SamplesOut. *)
                    sortedSampleObjectsAndIndices = SortBy[
                        Map[
                            {#, Flatten[Position[orderedSampleObjects, #]]}&,
                            sampleObjects
                        ],
                        #[[2, 1]]&
                    ];

                    Map[
                        (* Need to pass index and index label to determine the index of the sample in SamplesIn or SamplesOut *)
                        generateSampleInfoTable[#[[1]], #[[2]], indexLabel]&,
                        sortedSampleObjectsAndIndices
                    ]
                ],
                {}
            ]
        ],
        {
            {nonPlateSamplesInObjects,nonPlateSamplesOutObjects},
            {samplesInObjects, samplesOutObjects},
            {"SamplesIn", "SamplesOut"}
        }
    ];

    {nonPlateRequiredResourceTables, nonPlateSubprotocolRequiredResourceTables} = Map[
        generateSampleInfoTable[#, Null, ""]&,
        {nonPlateRequiredResourceSampleObjects, nonPlateSubprotocolRequiredResourceObjects},
        {2}
    ];

    (* Assemble SlideView of all samples in vessels *)
    {
        nonPlateSamplesInSlides, nonPlateSamplesOutSlides,
        nonPlateRequiredResourceSlides, nonPlateSubprotocolRequiredResourceSlides
    } = Map[
        If[MatchQ[#, Except[{}]],
            assembleSlideView[#],
            Null
        ]&,
        {
            nonPlateSamplesInTables, nonPlateSamplesOutTables,
            nonPlateRequiredResourceTables, nonPlateSubprotocolRequiredResourceTables
        }
    ];

    (** Generate dynamic content for samples in plates **)
    (* Create tables for samples in plates associated to their sample object. *)
    plateSampleTableAssociation = Flatten[
        MapThread[
            Function[{sampleObjects, orderedSampleObjects, indexLabel},
                If[MatchQ[sampleObjects, Except[{}]],
                    Module[{sortedSampleObjectsAndIndices},

                        (* Sort samples by their index in SamplesIn or SamplesOut. *)
                        sortedSampleObjectsAndIndices = If[MatchQ[orderedSampleObjects, {}],
                            Map[{#[[1]], Null}&, sampleObjects],
                            SortBy[
                                Map[
                                    {#, Flatten[Position[orderedSampleObjects, #]]}&,
                                    sampleObjects
                                ],
                                #[[2, 1]]&
                            ]
                        ];

                        Map[
                            (* Need to pass index and index label to determine the index of the sample in SamplesIn or SamplesOut *)
                            (* We are associating the generated table to the object that the table belongs to to use with the *)
                            (* dynamic plate plot. *)
                            #[[1]] -> generateSampleInfoTable[#[[1]], #[[2]], indexLabel]&,
                            sortedSampleObjectsAndIndices
                        ]
                    ],
                    {}
                ]
            ],
            {
                {
                    plateSamplesInObjects, plateSamplesOutObjects,
                    plateRequiredResourceSampleObjects, plateSubprotocolRequiredResourceSampleObjects
                },
                {samplesInObjects, samplesOutObjects, {}, {}},
                {"SamplesIn", "SamplesOut", "", ""}
            }
        ]
    ];

    (* Group samples by plate and dynamically plot each plate. *)
    {
        plateSamplesInSlides, plateSamplesOutSlides,
        plateRequiredResourceSlides, plateSubprotocolRequiredResourceSlides
    } = Map[
        Function[{sampleObjectList},
            If[MatchQ[sampleObjectList, Except[{}]],
                Module[
                    {
                        allSampleContainerObjects, uniqueSampleContainerObjects, containerToSampleAssociation,
                        uniqueSampleContainerModels, validContainerModelQs
                    },

                    (* Pull out unique containers used. There is one slide/graphic per plate, not per sample. *)
                    allSampleContainerObjects = Download[Lookup[sampleContainerAssociation, sampleObjectList], Object];
                    uniqueSampleContainerObjects = DeleteDuplicates[allSampleContainerObjects];

                    (* Associate each unique container to all of the samples that were in it at the end of the protocol. *)
                    (* Also determine the models of each unique plate. *)
                    {containerToSampleAssociation, uniqueSampleContainerModels} = Transpose[
                        Map[
                            {
                                # -> PickList[sampleObjectList, allSampleContainerObjects, ObjectP[#]],
                                Download[
                                    Lookup[
                                        FirstCase[allCurrentContainerPackets, KeyValuePattern[Object -> ObjectP[#]]],
                                        Model
                                    ],
                                    Object
                                ]
                            }&,
                            uniqueSampleContainerObjects
                        ]
                    ];

                    (* Determine if the plate model (for each unique plate) has all of the information needed to plot it. *)
                    validContainerModelQs = Map[
                        Module[{containerModelPacket},
                            containerModelPacket = FirstCase[
                                allCurrentContainerPackets,
                                KeyValuePattern[Object -> ObjectP[#]]
                            ];

                            MatchQ[
                                Lookup[containerModelPacket, {Dimensions, PositionPlotting}],
                                {{GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]}, Except[{}]}
                            ]
                        ]&,
                        uniqueSampleContainerModels
                    ];

                    (* Assemble the graphics for each plate used in the protocol. *)
                    assembleSlideView[
                        MapThread[
                            Function[{sampleContainerObject, validModelQ},
                                Module[{containerSamples, sampleTables},

                                    containerSamples = Lookup[containerToSampleAssociation, sampleContainerObject];
                                    sampleTables = Lookup[plateSampleTableAssociation, containerSamples];

                                    (* If the plate has a valid continer model, then plot it. *)
                                    (* Otherwise, just display slides of the sample information. *)
                                    If[validModelQ,
                                        plotPlate[
                                            sampleContainerObject,
                                            containerSamples,
                                            sampleTables
                                        ],
                                        Column[
                                            {
                                                stylizeHeader[ToString[sampleContainerObject]],
                                                assembleSlideView[sampleTables]
                                            },
                                            Spacings -> $ReviewGridSpacings,
                                            Alignment -> Center
                                        ]
                                    ]
                                ]
                            ],
                            {uniqueSampleContainerObjects, validContainerModelQs}
                        ]
                    ]
                ],
                Null
            ]
        ],
        {
            plateSamplesInObjects, plateSamplesOutObjects,
            plateRequiredResourceSampleObjects, plateSubprotocolRequiredResourceSampleObjects
        }
    ];


    (** Generate content for samples in vessels/non-plates **)
    (* Create tables for samples in vessels *)
    {nonObjectSamplesInTables, nonObjectSamplesOutTables} = MapThread[
        Function[{sampleInputs, orderedSampleObjects, indexLabel},
            If[MatchQ[sampleInputs, Except[{}]],
                Module[{sortedSampleInputsAndIndices},

                    (* Sort samples by their index in SamplesIn or SamplesOut. *)
                    sortedSampleInputsAndIndices = SortBy[
                        Map[
                            {#, Flatten[Position[orderedSampleObjects, #]]}&,
                            sampleInputs
                        ],
                        #[[2, 1]]&
                    ];

                    Map[
                        (* Need to pass index and index label to determine the index of the sample in SamplesIn or SamplesOut *)
                        generateSampleInfoTable[#[[1]], #[[2]], indexLabel]&,
                        sortedSampleInputsAndIndices
                    ]
                ],
                {}
            ]
        ],
        {
            {nonObjectSamplesIn,nonObjectSamplesOut},
            {samplesInObjects, samplesOutObjects},
            {"SamplesIn", "SamplesOut"}
        }
    ];

    {nonObjectRequiredResourceTables, nonObjectSubprotocolRequiredResourceTables} = Map[
        generateSampleInfoTable[#, Null, ""]&,
        {nonObjectRequiredResourceSamples, nonObjectSubprotocolRequiredResources},
        {2}
    ];

    (* Assemble SlideView of all samples in vessels *)
    {
        nonObjectSamplesInSlides, nonObjectSamplesOutSlides,
        nonObjectRequiredResourceSlides, nonObjectSubprotocolRequiredResourceSlides
    } = Map[
        If[MatchQ[#, Except[{}]],
            assembleSlideView[#],
            Null
        ]&,
        {
            nonObjectSamplesInTables, nonObjectSamplesOutTables,
            nonObjectRequiredResourceTables, nonObjectSubprotocolRequiredResourceTables
        }
    ];


    (* Final output assembly *)
    (* Assemble slides for the SamplesIn section. *)
    samplesInSectionList = Join[
        If[!NullQ[nonPlateSamplesInSlides],
            {
                {"Input Samples in Vessels", "Subsubsection", Open},
                Column[
                    {
                        nonPlateSamplesInSlides,
                        timeDisclaimerComment
                    }
                ]
            },
            {}
        ],
        If[!NullQ[plateSamplesInSlides],
            {
                {"Input Samples in Plates", "Subsubsection", Open},
                Column[
                    {
                        plateSamplesInSlides,
                        timeDisclaimerComment
                    }
                ]
            },
            {}
        ],
        If[!NullQ[nonObjectSamplesInSlides],
            {
                {"Pending Input Samples", "Subsubsection", Open},
                nonObjectSamplesInSlides
            },
            {}
        ]
    ];

    (* Assemble slides for the SamplesOut section. *)
    samplesOutSectionList = Join[
        If[!NullQ[nonPlateSamplesOutSlides],
            {
                {"Output Samples in Vessels", "Subsubsection", Open},
                Column[
                    {
                        nonPlateSamplesOutSlides,
                        timeDisclaimerComment
                    }
                ]
            },
            {}
        ],
        If[!NullQ[plateSamplesOutSlides],
            {
                {"Output Samples in Plates", "Subsubsection", Open},
                Column[
                    {
                        plateSamplesOutSlides,
                        timeDisclaimerComment
                    }
                ]
            },
            {}
        ],
        If[!NullQ[nonObjectSamplesOutSlides],
            {
                {"Pending Output Samples", "Subsubsection", Open},
                nonObjectSamplesOutSlides
            },
            {}
        ]
    ];

    (* Assemble slides for the required resources section. *)
    requiredResourcesSectionList = Join[
        If[!NullQ[nonPlateRequiredResourceSlides],
            {
                {"Protocol Samples in Vessels", "Subsubsection", Open},
                Column[
                    {
                        nonPlateRequiredResourceSlides,
                        timeDisclaimerComment
                    }
                ]
            },
            {}
        ],
        If[!NullQ[plateRequiredResourceSlides],
            {
                {"Protocol Samples in Plates", "Subsubsection", Open},
                Column[
                    {
                        plateRequiredResourceSlides,
                        timeDisclaimerComment
                    }
                ]
            },
            {}
        ],
        If[!NullQ[nonObjectRequiredResourceSlides],
            {
                {"Pending Protocol Samples", "Subsubsection", Open},
                nonObjectRequiredResourceSlides
            },
            {}
        ]
    ];

    (* Assemble slides for the subprotocol required resources section. *)
    subprotocolRequiredResourcesSectionList = Join[
        If[!NullQ[nonPlateSubprotocolRequiredResourceSlides],
            {
                {"Subprotocol Samples in Vessels", "Subsubsection", Open},
                Column[
                    {
                        nonPlateSubprotocolRequiredResourceSlides,
                        timeDisclaimerComment
                    }
                ]
            },
            {}
        ],
        If[!NullQ[plateSubprotocolRequiredResourceSlides],
            {
                {"Subprotocol Samples in Plates", "Subsubsection", Open},
                Column[
                    {
                        plateSubprotocolRequiredResourceSlides,
                        timeDisclaimerComment
                    }
                ]
            },
            {}
        ],
        If[!NullQ[nonObjectSubprotocolRequiredResourceSlides],
            {
                {"Pending Subprotocol Samples", "Subsubsection", Open},
                nonObjectSubprotocolRequiredResourceSlides
            },
            {}
        ]
    ];

    (* Put all of the sample sections together. *)
    Join[
        If[Length[samplesInSectionList] > 0,
            Join[
                {{"Input Samples", "Subsection", Open}},
                samplesInSectionList
            ],
            {}
        ],
        If[Length[samplesOutSectionList] > 0,
            Join[
                {{"Output Samples", "Subsection", Open}},
                samplesOutSectionList
            ],
            {}
        ],
        If[Length[requiredResourcesSectionList] > 0,
            Join[
                {{"Protocol Samples", "Subsection", Open}},
                requiredResourcesSectionList
            ],
            {}
        ],
        If[Length[subprotocolRequiredResourcesSectionList] > 0,
            Join[
                {{"Subprotocol Samples", "Subsection", Open}},
                subprotocolRequiredResourcesSectionList
            ],
            {}
        ]
    ]
];


(*$PrimaryDataPlotter*)
DefineConstant[
    $PrimaryDataPlotter,
    <|
        Object[Protocol, RoboticSamplePreparation] -> rspPrimaryData,
        Object[Protocol, ManualSamplePreparation] -> mspPrimaryData,
        Object[Protocol, GasChromatography] -> gasChromatographyPrimaryData,
        Object[Protocol, IonChromatography] -> ionChromatographyPrimaryData,
        Object[Protocol, ThermalShift] -> thermalShiftPrimaryData,
        Object[Protocol, ImageSample] -> imageSamplePrimaryData,
        Object[Protocol, MeasureWeight] -> measureWeightPrimaryData,
        Object[Protocol, MeasureVolume] -> measureVolumePrimaryData,
        Object[Protocol, StockSolution] -> stockSolutionPrimaryData,
        Object[Protocol, HPLC] -> hplcPrimaryData,
        Object[Protocol, NMR] -> nmrPrimaryData,
        Object[Protocol, NMR2D] -> nmrPrimaryData,
        Object[Protocol, MeasurepH] -> measurepHPrimaryData,
        Object[Protocol, KarlFischerTitration] -> karlFischerTitrationPrimaryData
    |>
];


(*getPrimaryData*)

Authors[getPrimaryData]:={"malav.desai"};

getPrimaryData[protocol:ObjectP[Object[Protocol]]] := Module[
    (* local variables *)
    {protocolType, dataObjects, primaryDataFunction, primaryDataPlots},

    (* download *)
    {
        protocolType,
        dataObjects
    } = Download[
        protocol,
        {
            Type,
            Data
        }
    ];

    (* Find our primary data plotting function; defaults to PlotObject if $PrimaryDataPlotter doesn't have any matches *)
    primaryDataFunction = Lookup[$PrimaryDataPlotter, protocolType, PlotObject];

    (* We are either using PlotObject or one of the custom functions to get our output.
        If there is no data, then we won't do anything by default *)
    primaryDataPlots = Which[
        (* If we are using PlotObject and have data objects, map PlotObject over the data *)
        And[MatchQ[primaryDataFunction, PlotObject], Length[dataObjects]>0],
            List@SlideView@Replace[
                If[$ZoomableBoolean,
                    (* We are good to use Zoomable when not in Manifold *)
                    ToList[PlotObject[#, ImageSize -> $ReviewPlotSize, Zoomable -> $ZoomableBoolean]&/@dataObjects],
                    (* When in Manifold, we will create a button to apply zoomable on demand *)
                    ToList[zoomableButton[PlotObject[#, ImageSize -> $ReviewPlotSize, Zoomable -> $ZoomableBoolean]]&/@dataObjects]
                ],
                NullP -> Nothing,
                {1}
            ],
        (* If we are using a custom function, plug the protocol in and get the output *)
        !MatchQ[primaryDataFunction, PlotObject],
            primaryDataFunction[protocol],
        (* If we don't have data for PlotObject or a custom function, we have nothing to present *)
        True,
            {}
    ];

    (* final output *)
    primaryDataPlots
];


(*$SecondaryDataPlotter*)
DefineConstant[
    $SecondaryDataPlotter,
    <|
        Object[Protocol, HPLC] -> hplcSecondaryData
    |>
];


(*getSecondaryData*)

Authors[getSecondaryData]:={"malav.desai"};

DefineOptions[getSecondaryData,
    Options:>{
        {
            CustomData -> Null,
            ListableP[Alternatives[
                {Alternatives[_String, {Alternatives[_String, Sequence@@supportedBoxStyles]..}], Alternatives@@supportedCellStyles},
                {Alternatives[_String, {Alternatives[_String, Sequence@@supportedBoxStyles]..}], Alternatives@@supportedHeaderStyles, Alternatives[Open, Close]},
                Sequence@@supportedInputTypes
            ]],
            "Set of peripheral information collected during experiment execution that is used instead of the default display in the form of <example here>. This will be included in the report under the \"Secondary Data\" section."
        }
    }
];

getSecondaryData[protocol:ObjectP[Object[Protocol]], myOptions:OptionsPattern[getSecondaryData]] := Module[
    (* local variables *)
    {
        safeOps, protocolType, checkpoints, checkpointProgress, subprotocolPackets, customData, nonDefaultSecondaryData,
        subscriptProtocolPackets, cleanSubprotocolPackets, checkpointCells, subprotocolPlotterLookup,
        subprotocolPacketsWData, outputUOSubprotocols, excludedSubprotocols, samplePrepProtocols, postProcessProtocolPackets
    },


    (* Download *)
    {
        protocolType,
        checkpoints,
        checkpointProgress,
        subprotocolPackets,
        subscriptProtocolPackets,
        outputUOSubprotocols,
        samplePrepProtocols,
        postProcessProtocolPackets
    } = Quiet[
        Download[
            protocol,
            {
                Type,
                Checkpoints,
                CheckpointProgress,
                Packet[Subprotocols][DateStarted, DateCompleted, Status],
                Packet[Subprotocols][Protocols][DateStarted, DateCompleted, Status],
                OutputUnitOperations[Subprotocol][Object],
                SamplePreparationProtocols[Object],
                Packet[PostProcessingProtocols][SamplesIn]
            }
        ],
        {Download::FieldDoesntExist}
    ];

    (** Custom or user-defined secondary data **)
    (* lookup safe options *)
    safeOps = SafeOptions[getSecondaryData, ToList[myOptions]];

    (* assign the option values *)
    {
        customData
    } = Lookup[safeOps,
        {
            CustomData
        }
    ];

    (* If we have user-supplied data, skip the custom generator function *)
    nonDefaultSecondaryData = If[NullQ[customData],
        (* If the user didn't give us data to display, we can try to generate our own display *)
        Module[{secondaryDataFunction},

            (* Find our secondary data plotting function *)
            secondaryDataFunction = Lookup[$SecondaryDataPlotter, protocolType, Null];

            (* If we have a function, run it, otherwise we have no non-default display to generate *)
            If[!NullQ[secondaryDataFunction],
                secondaryDataFunction[protocol],
                {}
            ]
        ],
        customData
    ];


    (** Default Secondary Data **)
    (* Exclude any subprotocols direclty associated with OutputUnitOperations since those will already have been represented earlier *)
    excludedSubprotocols = DeleteDuplicates[DeleteCases[Flatten[{outputUOSubprotocols}], NullP|$Failed]];

    (* Only keep the completed protocols from the subprotocol list and remove Cover/Uncover *)
    cleanSubprotocolPackets = DeleteCases[
        subprotocolPackets,
        Alternatives[
            KeyValuePattern[Type -> TypeP[{Object[Protocol, Cover], Object[Protocol, Uncover]}]],
            KeyValuePattern[Status -> Except[Completed]],
            KeyValuePattern[Object -> ObjectP[excludedSubprotocols]]
        ]
    ];


    (*- Create display for each subprotocol based on protocol type -*)
    (* set up a lookup table to redirect protocol types to the primary data since we will mostly be dealing with prep or post-processing protocols within Subprotocols *)
    subprotocolPlotterLookup = <|
        Object[Protocol, ManualSamplePreparation] -> mspPrimaryData,
        Object[Protocol, RoboticSamplePreparation] -> rspPrimaryData,
        Object[Protocol, ImageSample] -> imageSamplePrimaryData,
        Object[Protocol, MeasureWeight] -> measureWeightPrimaryData,
        Object[Protocol, MeasureVolume] -> measureVolumePrimaryData
        (*Object[Protocol, StockSolution] -> stockSolutionPrimaryData*)
    |>;

    (* Notes:
        Need primary data generators for:
            MSP
            RSP
            StockSolution - MVP would show key information for each step like SP
            ImageSample - MVP would show image of sample, model, container and container model
            MeasureVolume - MVP would show some data details as a slide show - including how it was measured
            MeasureWeight - MVP would show some data details as a slide show
        Fall back is to show an inspect table of the protocol that remains collapsed
    *)
    subprotocolPacketsWData = Map[
        With[{plotFunction = Lookup[subprotocolPlotterLookup, Lookup[#, Type], Null]},
            Append[#, "Subprotocol Data" -> If[!NullQ[plotFunction],
                (* when we have a function, use it *)
                plotFunction[Lookup[#, Object]],
                (* by default use Inspect to show Abstract fields only *)
                {ECL`Inspect[Lookup[#, Object], Abstract -> True, Developer -> False]}
            ]]
        ]&,
        cleanSubprotocolPackets
    ];

    (* Create checkpoint title and description cells, and add data that if we have any *)
    checkpointCells = MapThread[
        {
            (* Checkpoint title *)
            {"Checkpoint "<>ToString[#3]<>": "<>#1[[1]], "Subsubsection"},
            (* Checkpoint start time *)
            {
                {
                    StyleBox["Start Time: ", FontSlant -> "Italic"],
                    If[!NullQ[#2[[2]]], Cell[BoxData[ToBoxes[#2[[2]]]], "Output"], "Pending"]
                },
                "Text"
            },
            (* Checkpoint description from protocol object *)
            {#1[[3]], "Text"},
            (* For each subprotocol in the checkpoint, a description and secondary data *)
            Sequence@@Module[{currentTime, checkpointStart, checkpointEnd, dataInRange},
                (* handling in progress protocols that may not have the start and end dates *)
                currentTime = Now;
                checkpointStart = If[!NullQ[#2[[2]]], #2[[2]], currentTime];
                checkpointEnd = If[!NullQ[#2[[3]]], #2[[3]], currentTime];

                (* find any subprotocol packets that falls within the range of the checkpoint *)
                dataInRange = If[checkpointStart < checkpointEnd,
                    Select[subprotocolPacketsWData, Function[packet, #2[[2]] <= Lookup[packet, DateStarted] < #2[[3]]]],
                    {}
                ];

                If[Length[dataInRange] > 0,
                    (* If we found something, create a text box with the protocol object and add the generate data display *)
                    Map[
                        Function[packet,
                            OpenerView[{
                                Switch[packet,
                                    (* Descriptor for when our protocol is a part of the initial sample prep *)
                                    ObjectP[samplePrepProtocols],
                                    Row[
                                        {
                                            Style[ObjectToString[Lookup[packet, Object]], Bold, Italic, FontFamily -> "Helvetica"],
                                            " - ",
                                            Style["listed in ", FontFamily -> "Helvetica"],
                                            Style["SamplePreparationProtocols", Italic, FontFamily -> "Helvetica"]
                                        }
                                    ],
                                    (* Descriptor for when our protocol is a part of the post processing protocols *)
                                    ObjectP[Lookup[postProcessProtocolPackets, Object, {}]],
                                    Row[
                                        {
                                            Style[ObjectToString[Lookup[packet, Object]], Bold, Italic, FontFamily -> "Helvetica"],
                                            " - ",
                                            Style["listed in ", FontFamily -> "Helvetica"],
                                            Style["PostProcessingProtocols", Italic, FontFamily -> "Helvetica"]
                                        }
                                    ],
                                    (* Default descriptor that just shows the protocol object *)
                                    _,
                                    Style[ObjectToString[Lookup[packet, Object]], Bold, Italic, FontFamily -> "Helvetica"]
                                ],
                                Column[
                                    ReplaceAll[Replace[Lookup[packet, "Subprotocol Data"], {value : {_, "Text"} :> Row[value[[1]]]}, {1}], {StyleBox -> Style}],
                                    Dividers -> {
                                        LCHColor[0.4, 0, 0],
                                        {
                                            LCHColor[0.4, 0, 0],
                                            {LCHColor[0.9, 0, 0]},
                                            LCHColor[0.4, 0, 0]
                                        }
                                    },
                                    Spacings -> 2,
                                    ItemStyle -> Directive[FontFamily -> "Helvetica", FontSize -> 12]
                                ]
                            }]
                        ],
                        dataInRange
                    ],
                    (* Default output is an empty list *)
                    {}
                ]
            ],
            {
                {
                    StyleBox["End Time: ", FontSlant -> "Italic"],
                    If[!NullQ[#2[[3]]], Cell[BoxData[ToBoxes[#2[[3]]]], "Output"], "Pending"],
                    "           ",
                    If[!NullQ[#2[[3]]], StyleBox["Checkpoint Duration: "<>UnitForm[#2[[3]]-#2[[2]], Brackets -> False, Round -> 0.1], FontSlant -> "Italic"], Nothing]
                }, "Text"},
            {"", "Text"}
        }&,
        {checkpoints, PadRight[checkpointProgress, Length[checkpoints], {{Null, Null, Null}}], Range[Length[checkpoints]]}
    ];

    (* Add specific description for preparatory and post-processing protocols? *)


    Join[
        If[Length[nonDefaultSecondaryData] > 0,
            nonDefaultSecondaryData,
            {}
        ],

        If[Length[checkpointCells] > 0,
            Prepend[Flatten[checkpointCells, 1], {"Checkpoints & Supporting Protocols", "Subsection"}],
            {}
        ]
    ]
];

(*rspPrimaryData*)

Authors[rspPrimaryData]:={"malav.desai"};

rspPrimaryData[protocol:ObjectP[Object[Protocol, RoboticSamplePreparation]]] := Module[
    (* local variables *)
    {
        liquidHandlerObject, liquidHandlerModel, imageFile, streamFile, rspVideoButton, rspVideoMessage, tadmMessage,
        tadmPlots, unitOperationSlides
    },

    (* Download *)
    {
        liquidHandlerObject,
        liquidHandlerModel,
        imageFile,
        streamFile
    } = Quiet[Download[
        protocol,
        {
            LiquidHandler[Object],
            LiquidHandler[Model][Object],
            LiquidHandler[Model][ImageFile],
            Streams[VideoFile]
        }
    ], {Download::FieldDoesntExist}];

    (** Liquid handling video button **)
    (* Do this only if we have a video, otherwise output Null *)
    rspVideoButton = If[MatchQ[streamFile, ListableP[ObjectP[Object[EmeraldCloudFile]]]],
        Module[
            (* local variables *)
            {liquidHandlerImage, imageDimensions, playGraphic, buttonImage},

            (* Get the image file *)
            liquidHandlerImage = ImportCloudFile[imageFile];

            (* Get the pixel size of the image or default to 200.
                This is to make sure we scale the button graphic according to the image size *)
            imageDimensions = If[!NullQ[liquidHandlerImage], ImageDimensions[liquidHandlerImage], 200];

            (* Create the button graphic *)
            playGraphic = Graphics[
                {
                    (* Set some transparency so the image can be seen through the graphic *)
                    Opacity[0.7],
                    (* Ccreate the circle using ECL approved gray *)
                    LCHColor[0.8, 0, 0], Disk[{1, 3.5}, 6],
                    (* Next we put a white triangle on top *)
                    White, Triangle[{{0, 0}, {0, 7}, {4, 3.5}}]
                },
                (* Scale the graphic to be 0.5x of the smaller image dimension *)
                ImageSize -> SafeRound[Min[imageDimensions]/2, 1]
            ];

            (* Put the liquid handler image and the graphic together *)
            buttonImage = If[!NullQ[liquidHandlerImage],
                ImageCompose[liquidHandlerImage, playGraphic],
                playGraphic
            ];

            (* Output the button *)
            With[{buttonImageValue = buttonImage, protocolValue = protocol},
                Button[
                    buttonImageValue,
                    WatchProtocol[protocolValue],
                    Method -> "Queued"
                ]
            ]
        ]
    ];

    (* Message to show above the video IF we have a video button *)
    rspVideoMessage = If[!NullQ[rspVideoButton],
        {
            {
                StyleBox["Liquid Handling Video", FontWeight -> "Bold"],
                StringJoin[
                    "\nVideo recording of liquid handling performed on ",
                    ObjectToString[liquidHandlerObject],
                    " during the execution of ",
                    ObjectToString[Download[protocol, Object]],
                    ". Click on the button below to review the recording:"
                ]
            },
            "Text"
        }
    ];

    (** PlotTADM **)
    (* Safely create the TADM plots and skip if there is no data to present *)
    tadmPlots = Quiet[Check[
        UsingFrontEnd[
            Magnify[PlotTADM[protocol], 0.7]
        ],
        Null
    ]];

    (* If we have TADM plots, we should add a description *)
    tadmMessage = If[!NullQ[tadmPlots],
        {
            {
                StyleBox["Transfer Audit", FontWeight -> "Bold"],
                "\nDisplay of the Total Aspiration and Dispense Monitoring (TADM) data recorded by the liquid handler. The TADM data comes from the pressure sensors, which are constantly recorded during aspiration and dispensing, inside each individual pipetting channel. The TADM data can be used to verify that a sample was successfully transferred. The pressure data for each of the sample transfers in this robotic sample preparation protocol are plotted below:"
            },
            "Text"
        }
    ];

    (** Unit Operation Data **)
    (* Create a tab view displaying information about each unit operation and any data associated with it *)
    (* Using First on the spPrimaryData output because it doesn't need to be output in a list in this case. *)
    unitOperationSlides = Quiet[Check[
        Magnify[First[spPrimaryData[protocol]], 0.9],
        Null
    ]];

    (** Primary data when Data field has contents **)

    (* final output *)
    Replace[
        {
            rspVideoMessage,
            rspVideoButton,
            tadmMessage,
            tadmPlots,
            unitOperationSlides
        },
        NullP-> Nothing,
        {1}
    ]
];

(*imageSamplePrimaryData*)

Authors[imageSamplePrimaryData]:={"taylor.hochuli"};

imageSamplePrimaryData[protocol:ObjectP[Object[Protocol, ImageSample]]] := Module[
    {
        dataPacketFields, imageDataPackets, colorReferencePackets, equalOrMoreIntenseColorReferencePackets,
        imageCloudFileObjects, importedImages, gridFormat, truncateReferenceStrings, dataObjectTabs
    },

    (* Determine what information needs to be downloaded. *)
    dataPacketFields = {
        Object,
        Instrument,
        SamplesIn,
        ContainersIn,
        ImagingDirection,
        IlluminationDirection,
        FieldOfView,
        ExposureTime,
        UncroppedImageFile,
        ColorReferences
    };

    (* Download all information. *)
    {
        imageDataPackets,
        colorReferencePackets,
        equalOrMoreIntenseColorReferencePackets
    } = Download[
        protocol,
        {
            Packet[Data[dataPacketFields]],
            Packet[Data[ColorReferenceSamples[ExpirationDate, ModelName]]],
            Packet[Data[MoreIntenseColorReferences[ModelName]]]
        }
    ];

    (* Import image cloud files. *)
    imageCloudFileObjects = Lookup[Replace[imageDataPackets, Null -> <||>, {1}], UncroppedImageFile, Null];
    importedImages = Replace[ImportCloudFile[imageCloudFileObjects], Null -> {}];

    (* Setup grid formatting options *)
    gridFormat = {
        Background -> Experiment`Private`tableBackground[2, Experiment`Private`IncludeHeader -> False],
        Alignment -> {{Right, {Left}}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
        Dividers -> {
            {{Directive[Opacity[0]]}},
            {
                Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]]
                }
            }
        }
    };

    (* Helper to truncate the names of the color standards and sample. *)
    (* Also shorten the name of the HCl standard to simply 1% HCl. *)
    truncateReferenceStrings[myModelNames:ListableP[_String]] := Map[
        Which[
            MatchQ[#, "Sample"], #,
            MemberQ[StringSplit[#], "HCl"], "HCl",
            True, StringSplit[#][[-2]]
        ]&,
        myModelNames
    ];

    (* Generate the individual tabs for each data object. *)
    dataObjectTabs = MapThread[
        Function[
            {dataPacket, colorRefPackets, equalOrMoreIntensePackets, image},
            If[MatchQ[image, NullP | {}],
                Nothing,
                Module[
                    {
                        appearanceObject, instrument, imagedSamples, imagedContainers, fieldOfView, imagingDirection, illuminationDirection,
                        exposureTime, uncroppedImageFile, colorReferencesSymbol, colorComparisonQ, referenceAndSampleArrangementGrid,
                        onsiteColorDetermination, colorReferenceFinalString, finalImage, imageButton, dataHeaderTuples, tableContent, grid, columnContents
                    },

                    (* Lookup from the data object packet. *)
                    {
                        appearanceObject,
                        instrument,
                        imagedSamples,
                        imagedContainers,
                        fieldOfView,
                        imagingDirection,
                        illuminationDirection,
                        exposureTime,
                        uncroppedImageFile,
                        colorReferencesSymbol
                    } = Lookup[dataPacket,
                        {
                            Object,
                            Instrument,
                            SamplesIn,
                            ContainersIn,
                            FieldOfView,
                            ImagingDirection,
                            IlluminationDirection,
                            ExposureTime,
                            UncroppedImageFile,
                            ColorReferences
                        }
                    ];

                    (* Boolean to indicate whether this is a color comparison. *)
                    colorComparisonQ = MatchQ[colorReferencesSymbol, ColorReferencesP];

                    (* If this is a color comparison, assemble a grid that shows the references and their samples, and reformat *)
                    (* the operator's scanning choices into the industry standard "Not more intense than..." format. Also *)
                    (* tack on "(E.P. 2.2.2)" to the color reference symbol since we are only supporting these references. *)
                    (* We don't need any of these if this isn't color comparison, so just return Null for each in that case. *)
                    {referenceAndSampleArrangementGrid, onsiteColorDetermination, colorReferenceFinalString} = If[!TrueQ[colorComparisonQ],
                        {Null, Null, Null},
                        Module[
                            {
                                colorReferenceObjects, colorReferenceModelNames, colorReferenceExpirationDates, equalOrMoreIntenseReferenceModelNames,
                                sampleAndStandardsList, equalOrMoreIntenseReferences, arrangementGrid, onsiteDetermination, colorRefString
                            },

                            (* Lookup the color reference objects, model names, and expiration dates. *)
                            {
                                colorReferenceObjects,
                                colorReferenceModelNames,
                                colorReferenceExpirationDates
                            } = Transpose[Lookup[colorRefPackets, {Object, ModelName, ExpirationDate}]];

                            (* Also get the model names of the references the operator scanned. *)
                            equalOrMoreIntenseReferenceModelNames = Lookup[equalOrMoreIntensePackets, ModelName];

                            (* Make truncated names for the references and sample. Do the same for the list of more intense references. *)
                            sampleAndStandardsList = Append[truncateReferenceStrings[colorReferenceModelNames], "S"];
                            equalOrMoreIntenseReferences = Cases[truncateReferenceStrings[equalOrMoreIntenseReferenceModelNames], Except["HCl"]];

                            (* Build a grid containing each reference/sample with informative tooltips. *)
                            arrangementGrid = Grid[
                                {
                                    MapThread[
                                        Function[
                                            {sampleName, sampleObject, expirationDate},

                                            customButton[sampleName,
                                                CopyContent -> Download[sampleObject, Object],
                                                Tooltip -> Column[
                                                    {
                                                        sampleName /. "S" -> NamedObject[First[imagedSamples]],
                                                        If[!NullQ[expirationDate], "Expires: "<>DateString[expirationDate], Nothing],
                                                        "Click to copy Object[Sample]"
                                                    },
                                                    Alignment -> {Center, Baseline}
                                                ]
                                            ]
                                        ],
                                        {
                                            sampleAndStandardsList,
                                            Join[colorReferenceObjects, imagedSamples],
                                            Append[colorReferenceExpirationDates, Null]
                                        }
                                    ]
                                },
                                Frame -> All,
                                Spacings -> 2.35,
                                FrameStyle -> Directive[GrayLevel[0.6]]
                            ];

                            (* Format the operator's choice appropriately. Cover it with a mouseover in the table so the viewer is not biased. *)
                            onsiteDetermination = Module[
                                {operatorDetermination},

                                (* Store the operator's choice as a variable. *)
                                operatorDetermination = If[MatchQ[equalOrMoreIntenseReferences, {}],
                                    "More Intense Than "<>sampleAndStandardsList[[1]]<>".",
                                    "Not More Intense Than "<>Sort[equalOrMoreIntenseReferences][[-1]]<>"."
                                ];

                                (* Generate a mouseover and hide the operator's determination under it. *)
                                With[{explicitDetermination = operatorDetermination},
                                    Mouseover[
                                        Style["Mouseover to Reveal Onsite Operator Determination", Italic, FontFamily -> "Helvetica"],
                                        Style[explicitDetermination,  FontFamily -> "Helvetica"]
                                    ]
                                ]
                            ];

                            (* Add E.P. 2.2.2 to the color reference string. Our reference are prepared according to this chapter. *)
                            colorRefString = Style[ToString[colorReferencesSymbol]<>" (E.P. 2.2.2)", FontFamily -> "Helvetica"];

                            (* Return the grid and the onsite determination mouseover. *)
                            {arrangementGrid, onsiteDetermination, colorRefString}
                        ]
                    ];

                    (* Color comparison images are always in the same rack and of the same size. *)
                    (* Crop these and make them a bit larger than normal images. *)
                    finalImage = If[TrueQ[colorComparisonQ],
                        Show[ImageTake[image, {1200, 3800}], ImageSize -> 400],
                        Image[ImageResize[image, $ReviewImageResolution], ImageSize -> $ReviewImageSize]
                    ];

                    (* Generate an image button which opens to the full uncropped image. *)
                    imageButton = With[
                        {
                            explicitFinalImage = finalImage,
                            explicitUncroppedImageFile = uncroppedImageFile
                        },

                        Tooltip[
                            Button[
                                Show[explicitFinalImage],
                                OpenCloudFile[explicitUncroppedImageFile],
                                Appearance -> "Frameless",
                                Method -> "Queued"
                            ],
                            "Click to Open Full Image"
                        ]
                    ];

                    (* Define the data headers and their values. *)
                    dataHeaderTuples = {
                        {"Data Object", appearanceObject},
                        {"Imaging Instrument", instrument},
                        {"Imaged Samples", Download[imagedSamples, Object]},
                        {"Imaged Containers", Download[imagedContainers, Object]},
                        {"Field Of View", fieldOfView},
                        {"Imaging Direction", imagingDirection},
                        {"Illumination Direction", illuminationDirection},
                        {"Exposure Time", exposureTime},
                        {"Color References", colorReferenceFinalString},
                        {"Onsite Determination", onsiteColorDetermination}
                    };

                    (* Build a table out of all of the non-Null info we have. *)
                    tableContent = Map[
                        Which[
                            (* If an item is NullP or {}, omit it entirely. *)
                            MatchQ[Last[#], NullP | {}],
                            Nothing,
                            (* If an item is a list of length == 1, take the first item. *)
                            SameQ[Length[Last[#]], 1],
                            {First[#], First[Last[#]]},
                            (* If an item is a list, wrap it with Column. *)
                            ListQ[Last[#]],
                            {First[#], Column[Last[#]]},
                            (* Otherwise, output the tuple exactly as is. *)
                            True,
                            #
                        ]&,
                        dataHeaderTuples
                    ];

                    (* Set up the grid and label it. *)
                    grid = Grid[Replace[tableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                        Sequence @@ gridFormat,
                        ItemSize -> {{All, UpTo[20]}}
                    ];

                    (* If this is a color comparison, we place the reference and sample grid right beneath the image. *)
                    columnContents = If[TrueQ[colorComparisonQ],
                        {
                            imageButton,
                            Style["Arrangement of References and Sample (S) in Image:", Italic, 11, FontFamily -> "Helvetica"],
                            referenceAndSampleArrangementGrid,
                            grid
                        },
                        {imageButton, grid}
                    ];

                    (* Set up the grid and label it *)
                    Labeled[
                        Column[columnContents, Alignment -> Center],
                        If[TrueQ[colorComparisonQ], "Color Comparison Data", "Imaging Data"],
                        Top,
                        LabelStyle -> Directive[Bold, FontFamily -> "Helvetica"]
                    ]
                ]

            ]
        ],
        {imageDataPackets, colorReferencePackets, equalOrMoreIntenseColorReferencePackets, importedImages}
    ];

    (* Return according to the number of data slides we ended up with. *)
    Switch[Length[dataObjectTabs],
        (* If we have just one image to show, return it as a list of length 1. *)
        1, dataObjectTabs,
        (* If we have multiple images to show, put them in SlideView. *)
        GreaterP[1], {assembleSlideView[dataObjectTabs]},
        (* Otherwise, we came up empty and the best we can do is run Inspect on the protocol. *)
        _, {Inspect[protocol, Abstract -> True, Developer -> False]}
    ]
];

(* measureWeightPrimaryData *)

Authors[measureWeightPrimaryData]:={"melanie.reschke"};


(* This function outputs one table or a table and a list of slides *)
measureWeightPrimaryData[protocol: ObjectP[Object[Protocol, MeasureWeight]]] := Module[
    {
        gridFormat, dataPacketsFields, dataPackets, dataObjects, dataDates, sampleModels, samples, weights, tareWeights,
        headings, sampleTables, balanceModelPackets, balanceResolutions, weightAppearanceObjects, weightAppearances
    },

    (** Initial setup: Setup grid formatting options **)
    gridFormat = {
        Background -> tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, {Left}}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
        Dividers -> {
            {{Directive[Opacity[0]]}},
            {
                Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]]
                }
            }
        }
    };

    (** Downloads **)
    (* Set fields to download from the data objects in the protocol. *)
    dataPacketsFields = Packet[
        DateCreated,
        Instrument,
        Sensor,
        SamplesIn,
        BalanceType,
        SampleContainer,
        ContainerModel,
        Weight,
        WeightStandardDeviation,
        WeightDistribution,
        DataType,
        TareWeight,
        GrossWeight
    ];

    (* Download packets for each data object. *)
    {
        dataPackets,
        balanceModelPackets,
        balanceResolutions,
        weightAppearanceObjects
    } = Download[
        protocol,
        {
            Data[dataPacketsFields],
            Packet[Data][Instrument][Model][Name],
            Data[Instrument][Resolution],
            Data[WeightAppearance][UncroppedImageFile][Object]
        }
    ];

    (* Import images and shrink them to display in tooltips *)
    weightAppearances = Map[
        If[NullQ[#], #, Image[ImageResize[#, $ReviewImageResolution], ImageSize -> $ReviewImageSize]]&,
        ImportCloudFile[weightAppearanceObjects]
    ];

    (** Data assembly **)
    (* Get the data objects and the dates created to use for downloading the sample models at the time of measurement *)
    {dataObjects, dataDates} = Transpose[Lookup[dataPackets, {Object, DateCreated}]];

    (* Get the samples from each data object. *)
    samples = MapThread[
        Function[{samplesIn, dataType, container},
            If[MatchQ[dataType, Tare],
                (* if this measurement is a Tare measurement, there is no sample, so instead we show the container object as the sample *)
                Which[
                    Length[container] == 1,
                        First[container],
                    Length[container] > 1,
                        container,
                    True,
                        Null
                ],
                (* otherwise if its not a Tare measurement, get the sample(s) from the data object. They are in list form, and some data objects have more than one sample for a single weight data, *)
                (* so need to replace any single-value lists with just the value itself. Set any empty lists (length==0) as Null and remove that column from the table later if all are Null *)
                Which[
                    Length[samplesIn] == 1,
                        First[samplesIn],
                    Length[samplesIn] > 1,
                        samplesIn,
                    True,
                        Null
                ]
            ]
        ],
        {Lookup[dataPackets, SamplesIn], Lookup[dataPackets, DataType], Lookup[dataPackets, SampleContainer]}
    ];

    (* For any samples that are Object[Sample], download the model at the date/time of the measurement. For samples that are containers (tare measurements) we don't need to download the model. *)
    sampleModels = Download[
        (samples /. ObjectP[Object[Container]] -> Null),
        Model[Object],
        Date -> dataDates
    ];

    (* Get the weights and tare weights, and round to the nearest 0.1 mg *)
    (* Don't round the weights if they are Null *)
    {weights, tareWeights} = Map[
        Function[{weightsList},
            Map[
                If[!MatchQ[#, Null],
                    UnitForm[#, Brackets -> False, Round -> 0.01],
                    #
                ]&,
                weightsList
            ]
        ],
        Transpose[Lookup[dataPackets, {Weight, TareWeight}]]
    ];


    (** Detailed tables **)
    (* Make headings for the sample measurement info tables *)
    headings = Style[#, Bold]& /@ {"Appearance", "Measured Weight", "Sample Model", "Data Object", "Balance Type", "Instrument", "Sensor", "TareWeight", "Sample Container", "Container Model"};

    (* Make a table with more detailed info on each sample *)
    sampleTables = MapThread[
        Function[
            {
                sample,
                sampleModel,
                dataObj,
                tareWeight,
                balanceResolution,
                weightDist,
                balanceType,
                instrument,
                sensor,
                container,
                containerModel,
                weightAppearance,
                weightAppearanceObject
            },
            Module[{formattedWeightDist, allTableContent, finalTableContent, title},

                (* format the weight distribution for display and set up a button to copy the quantity dist value *)
                formattedWeightDist = customButton[unitFormDistribution[weightDist, Resolution -> balanceResolution],
                    CopyContent -> weightDist
                ];

                (* Set up the image button if we have an image. Null will be omitted *)
                balanceImage = If[MatchQ[weightAppearanceObject, ObjectP[]],
                    With[
                        {explicitAppearance = weightAppearance, explicitObject = weightAppearanceObject},
                        Tooltip[
                            Button[explicitAppearance, OpenCloudFile[explicitObject],
                                Appearance -> "Frameless",
                                Method -> "Queued"
                            ],
                            "Open Image"
                        ]
                    ]
                ];

                (* put together the data and the row headings *)
                allTableContent = Transpose[{
                    headings,
                    {
                        balanceImage,
                        formattedWeightDist,
                        sampleModel,
                        dataObj,
                        balanceType,
                        instrument,
                        sensor,
                        tareWeight,
                        container,
                        containerModel
                    }
                }];

                (* remove rows with Null values *)
                finalTableContent = Select[allTableContent, MatchQ[#[[2]], Except[Null]]&];

                (* prepare the title *)
                title = If[MatchQ[sample, ObjectP[Object[Sample]]],
                    sample[Object],
                    ToString[sample[Object]] <> " (Tare Measurement)"
                ];

                (* Set up the grid and label it using the title *)
                Labeled[
                    Grid[Replace[finalTableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                        Sequence@@gridFormat,
                        ItemSize -> {{All, 25}}
                    ],
                    title,
                    Top,
                    LabelStyle -> Directive[Bold, FontFamily -> "Helvetica"]
                ]
            ]
        ],
        {
            samples,
            sampleModels,
            dataObjects,
            tareWeights,
            balanceResolutions,
            Sequence@@Transpose[Lookup[dataPackets, {WeightDistribution, BalanceType, Instrument, Sensor, SampleContainer, ContainerModel}]],
            weightAppearances,
            weightAppearanceObjects
        }
    ];

    (** Final output **)
    (*
        If we only have 1 sample, we will take the first table and output it.
        If we have more than one sample, we will create a dynamic output that includes a summary table with radio
            buttons and a display below that shows the table relevant to the selected sample
    *)
    If[Length[samples] == 1,
        (* just need to output this if we only have a single sample *)
        {Labeled[
            First[sampleTables],
            "Sample Weight Measurement Data",
            Top,
            LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
        ]},
        (* generate our dynamic output *)
        {With[{explicitSampleTables = sampleTables},
            DynamicModule[
                (* localized variables *)
                {summaryContent, summaryHeadings, weightDisplayIndex = 1},

                (* if there were no SamplesIn, don't show that column *)
                summaryContent = MapThread[
                    Replace[{
                        #1,
                        With[{explicitValue = #1}, RadioButton[Dynamic[weightDisplayIndex, TrackedSymbols :> {weightDisplayIndex}], explicitValue]],
                        #2,
                        #3,
                        #4
                    }, NullP -> Nothing, {1}]&,
                    {Range[Length[samples]], samples, weights, dataObjects}
                ];
                summaryHeadings = If[MatchQ[samples, ListableP[Null]],
                    {"", Tooltip["Display", "Click radio button to show detailed sample data below"], "Measured Weight", "Data Object"},
                    {"", Tooltip["Display", "Click radio button to show detailed sample data below"], "Sample", "Measured Weights", "Data Object"}
                ];

                (* put together the data for summary table *)
                summaryTableData = NamedObject[
                    Prepend[
                        summaryContent,
                        summaryHeadings
                    ]
                ];

                Column[{
                    Labeled[
                        Pane[
                            Grid[
                                Replace[summaryTableData, {objectValue : ObjectP[] :> customButton[objectValue]}, {2}],
                                Sequence @@ ReplaceRule[gridFormat,
                                    {
                                        Background -> Experiment`Private`tableBackground[Length[samples]],
                                        ItemStyle -> {
                                            {Directive[Bold, FontFamily -> "Helvetica"]},
                                            {Directive[Bold, FontFamily -> "Helvetica"], {Directive[FontFamily -> "Helvetica"]}}
                                        }
                                    }
                                ]
                            ],
                            ImageSize -> {Automatic, UpTo[250]},
                            Scrollbars -> Automatic,
                            AppearanceElements -> None
                        ],
                        "Weight Measurement Summary Table",
                        Top,
                        LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
                    ],
                    Labeled[
                        Framed[
                            Dynamic[explicitSampleTables[[weightDisplayIndex]], TrackedSymbols :> {weightDisplayIndex}],
                            FrameStyle -> Lighter[Gray, 0.4]
                        ],
                        "Sample Weight Measurement Data",
                        Top,
                        LabelStyle -> Directive[Bold, 15, FontFamily -> "Helvetica"]
                    ]
                },
                    Dividers -> {False, {False, True, True}},
                    FrameStyle -> Lighter[Gray, 0.4],
                    Alignment -> Center,
                    Spacings -> 2
                ]
            ]
        ]}
    ]
];


(*measureVolumePrimaryData*)

Authors[measureVolumePrimaryData]:={"malav.desai"};

measureVolumePrimaryData[protocol: ObjectP[Object[Protocol, MeasureVolume]]] := Module[
    {
        protocolPacket, volumeDataPackets, weightDataPackets, sampleDensities, weightAppearances,
        samples, volumes, dataObjects, gridFormat, cleanAppearanceObjects,
        headings, sampleTables, tareDistancesPackets, weightAppearanceObjects
    },


    (* Setup grid formatting options *)
    gridFormat = {
        Background -> tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, {Left}}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
        Dividers -> {
            {{Directive[Opacity[0]]}},
            {
                Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]]
                }
            }
        }
    };

    (* Download packets for each data object. *)
    {
        protocolPacket,
        volumeDataPackets,
        weightDataPackets,
        weightAppearanceObjects,
        tareDistancesPackets
    } = Download[
        protocol,
        {
            Packet[SamplesIn, Densities, TareDistances],
            Packet[Data][Instrument, Sensor, NumberOfReadings, MeasurementMethod, SamplesIn, SampleContainer, ContainerModel,
                LiquidLevelDistribution, Volume, VolumeDistribution, VolumeCalibration, WeightDistribution, WeightData],
            Packet[Data][WeightData][TareWeight, GrossWeight, Sensor],
            Data[WeightData][WeightAppearance][UncroppedImageFile][Object],
            Packet[TareDistances][Instrument]
        }
    ];

    (* clean up weightAppearanceObjects since we will have {} *)
    cleanAppearanceObjects = Flatten[Replace[weightAppearanceObjects, {} -> Null, {1}]];

    (* Import images if we have any to show from weighings *)
    weightAppearances = Map[
        If[NullQ[#], #, Image[ImageResize[#, $ReviewImageResolution], ImageSize -> $ReviewImageSize]]&,
        ImportCloudFile[cleanAppearanceObjects]
    ];

    (* create an association between samples and densities so we can substitute at the end for gravimetric volume measurements *)
    sampleDensities = AssociationThread[Download[Lookup[protocolPacket, SamplesIn], Object], Lookup[protocolPacket, Densities]];

    (* Get the volume *)
    volumes = UnitForm[Lookup[volumeDataPackets, Volume], Brackets -> False, Round -> 0.01];

    (* Get the data objects for the summary table *)
    dataObjects = Lookup[volumeDataPackets, Object];

    (* Get the sample objects for the summary table *)
    samples = Download[Flatten[Lookup[volumeDataPackets, SamplesIn]], Object];

    (* Make headings for the sample measurement info tables *)
    headings = Style[#, Bold]& /@ {
        "Appearance",
        "Measured Volume",
        "Method",
        "Volume Data",
        "Weight Data",
        "Instrument",
        "Sensor",
        "Sample Container",
        "Container Model",
        "Volume Calibration",
        "Tare Distances"
    };

    (* Make a table with more detailed info on each sample *)
    sampleTables = MapThread[
        Function[{singleVolumePacket, singleWeightPacket, singleWeightAppearanceObject, singleWeightAppearance},
            Module[
                (* local variables *)
                {currentMeasurementMethod, actualWeightPacket, volumeValue, volumeDetails, volumeCalibrationObject,
                    sensor, tableValues, instrumentObject, tareDistanceData, appearanceButton},

                (* create an appearance button if we have anything to display from weight data *)
                appearanceButton = If[MatchQ[singleWeightAppearanceObject, ObjectP[]],
                    With[
                        {explicitAppearance = singleWeightAppearance, explicitObject = singleWeightAppearanceObject},
                        Tooltip[
                            Button[explicitAppearance, OpenCloudFile[explicitObject],
                                Appearance -> "Frameless",
                                Method -> "Queued"
                            ],
                            "Open Image"
                        ]
                    ]
                ];

                (* since we will use the measurement method to make a bunch of decisions, let's save that to a variable first *)
                currentMeasurementMethod = Lookup[singleVolumePacket, MeasurementMethod];

                (* Weight data field is multiple and should only have 1 value, so lets make that a singleton for convenience *)
                actualWeightPacket = If[MatchQ[currentMeasurementMethod, Gravimetric], First[singleWeightPacket], <||>];

                (* Put together another table that we can show in a tooltip to add more information directly related to the volume *)
                volumeDetails = If[MatchQ[currentMeasurementMethod, Ultrasonic],
                    Grid[
                        {
                            {"Liquid Level", unitFormDistribution[Lookup[singleVolumePacket, LiquidLevelDistribution]]},
                            {"Number Of Readings", Lookup[singleVolumePacket, NumberOfReadings]}
                        },
                        Sequence@@gridFormat
                    ],
                    Grid[
                        {
                            {"Weight Distribution", unitFormDistribution[Lookup[singleVolumePacket, WeightDistribution]]},
                            {"Density", Download[First[Lookup[singleVolumePacket, SamplesIn]], Object]/.sampleDensities},
                            {"Tare Weight", Lookup[actualWeightPacket, TareWeight]},
                            {"GrossWeight", Lookup[actualWeightPacket, GrossWeight]}
                        }/.{value:UnitsP[] :> UnitForm[value, Brackets -> False, Round -> 0.001]},
                        Sequence@@gridFormat
                    ]
                ];

                (* rounded volume *)
                volumeValue = Tooltip[
                    Which[
                        !NullQ[Lookup[singleVolumePacket, VolumeDistribution]],
                            unitFormDistribution[Lookup[singleVolumePacket, VolumeDistribution]],
                        !NullQ[Lookup[singleVolumePacket, Volume]],
                            UnitForm[Lookup[singleVolumePacket, Volume], Brackets -> False, Round -> 0.01],
                        True,
                            "N/A"
                    ],
                    volumeDetails,
                    TootipStyle -> {Background -> LCHColor[1,0,0]}
                ];

                (* sensor will either be in the data if ultrasonic, or we need to go to the weight data to find it *)
                sensor = If[MatchQ[currentMeasurementMethod, Ultrasonic],
                    Download[Lookup[singleVolumePacket, Sensor], Object],
                    Download[Lookup[actualWeightPacket, Sensor], Object]
                ];

                (* volume calibration is only for ultrasonic measurements *)
                volumeCalibrationObject = Download[Lookup[singleVolumePacket, VolumeCalibration], Object];

                (* we need to get the instrument object to get the possible TareDistance if we have one *)
                instrumentObject = Download[Lookup[singleVolumePacket, Instrument], Object];

                (* tare distances only make sense for ultrasonic measurments *)
                tareDistanceData = Lookup[FirstCase[tareDistancesPackets, KeyValuePattern[Instrument -> LinkP[instrumentObject]], <|Object -> Null|>], Object];

                (* Delete any rows where we have a Null value *)
                tableValues = NamedObject[DeleteCases[Transpose[{
                    headings,
                    {
                        appearanceButton,
                        volumeValue,
                        currentMeasurementMethod,
                        Lookup[singleVolumePacket, Object],
                        Lookup[actualWeightPacket, Object, Null],
                        instrumentObject,
                        sensor,
                        Download[Lookup[singleVolumePacket, SampleContainer], Object],
                        Download[Lookup[singleVolumePacket, ContainerModel], Object],
                        volumeCalibrationObject,
                        tareDistanceData
                    }
                }], {_, NullP}, {1}]];

                Labeled[
                    Grid[
                        Replace[tableValues, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                        Sequence@@gridFormat
                    ],
                    NamedObject[First[Lookup[singleVolumePacket, SamplesIn]]],
                    Top,
                    LabelStyle -> Directive[Bold, FontFamily -> "Helvetica"]
                ]
            ]
        ],
        {volumeDataPackets, weightDataPackets, cleanAppearanceObjects, weightAppearances}
    ];

    (** Final output **)
    (*
        If we only have a single sample, we will display the detailed table ONLY
        If we have more than one sample, we will create a dynamic display with a radiobutton selector
    *)
    If[Length[sampleTables]==1,
        (* only display the single table that exists *)
        {Labeled[
            First[sampleTables],
            "Sample Volume Measurement Data",
            Top,
            LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
        ]},
        (* summary table with radiobuttons that control which sample's details are displayed below the summary table *)
        {With[{explicitSampleTables = sampleTables},
            DynamicModule[
                (* localized variables *)
                {summaryTableData, sampleIndexRange, volumeDisplayIndex = 1},

                (* create a range *)
                sampleIndexRange = Range[Length[samples]];

                (* put together the data for summary table *)
                summaryTableData = NamedObject[
                    Prepend[
                        Transpose[{
                            sampleIndexRange,
                            With[{explicitValue = #}, RadioButton[Dynamic[volumeDisplayIndex, TrackedSymbols :> {volumeDisplayIndex}], explicitValue]]&/@sampleIndexRange,
                            samples,
                            volumes,
                            dataObjects
                        }],
                        {"", Tooltip["Display", "Click radio button to show detailed sample data below"], "Sample", "Measured Volumes", "Data Object"}
                    ]
                ];

                Column[{
                    Labeled[
                        Pane[
                            Grid[
                                summaryTableData/.{objectValue:ObjectP[] :> customButton[objectValue]},
                                Sequence@@ReplaceRule[gridFormat,
                                    {
                                        Background -> tableBackground[Length[samples]],
                                        ItemStyle -> {{Directive[Bold, FontFamily -> "Helvetica"]}, {Directive[Bold, FontFamily -> "Helvetica"], {Directive[FontFamily -> "Helvetica"]}}}
                                    }
                                ]
                            ],
                            ImageSize -> {Automatic, UpTo[250]},
                            Scrollbars -> Automatic,
                            AppearanceElements -> None
                        ],
                        "Volume Measurement Summary Table",
                        Top,
                        LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
                    ],
                    Labeled[
                        Framed[
                            Dynamic[explicitSampleTables[[volumeDisplayIndex]], TrackedSymbols :> {volumeDisplayIndex}],
                            FrameStyle -> Lighter[Gray, 0.4]
                        ],
                        "Sample Volume Measurement Data",
                        Top,
                        LabelStyle -> Directive[Bold, 15, FontFamily -> "Helvetica"]
                    ]
                },
                    Dividers -> {False, {False, True, True}},
                    FrameStyle -> Lighter[Gray, 0.4],
                    Alignment -> Center,
                    Spacings -> 2
                ]
            ]
        ]}
    ]
];



(*stockSolutionPrimaryData*)

Authors[stockSolutionPrimaryData]:={"malav.desai"};

stockSolutionPrimaryData[protocol:ObjectP[Object[Protocol, StockSolution]]] := {Inspect[protocol, Abstract -> True]};

(*Module[
    (* local variables *)
    {possibleOperations, representativeUOs, representativeIcons, operationsIconRules, initialOrderOperations, ssCache,
        ssProtocolPacket, ssResolvedOptions, ssModels, orderOperations, ssMenuViewOutput, genericLabels, ssFastAssoc,
        autoclaveResolution, autoclaveProgramResolution, ssSubprotocolLVLOnePackets, dosingStartTime, ssSubprotocolShortlist,
        ssFixedAdditionsSub, ssAdjustpHSub, ssIncubateSub, ssFilterSub, ssAutoclaveSubs, ssFtVSubs, ssSampleTrace,
        ssSubsOfInterest, remainingSubprotocolPackets, extraTransferSub, inputUnitOperationPackets},

    (** Lets do some setup first - create a rule replacement to convert a StockSolution operation into a unit op icon **)
    (* Create our list of possible operations *)
    possibleOperations = {FixedReagentAddition, FillToVolume, pHTitration, Incubation, Filtration, Autoclave};

    (* Create a list of unit operations that represent the above operations *)
    representativeUOs = {Transfer, FillToVolume, AdjustpH, Incubate, Filter, Autoclave};

    (* Convert the UOs to a list icons *)
    representativeIcons = representativeUOs/.$UnitOperationIconFilePaths;

    (* Map the order of operations to unit operation names so that we can then convert them to icon files *)
    operationsIconRules = AssociationThread[possibleOperations, representativeIcons];


    (** Download **)
    {
        ssProtocolPacket,
        ssSubprotocolLVLOnePackets,
        inputUnitOperationPackets
    } = Quiet[Download[
        protocol,
        {
            Packet[
                (* general *)
                ResolvedOptions, StockSolutionModels, RequestedVolumes, NumberOfReplicates, SpecifiedSamples, Subprotocols,
                CheckpointProgress,

                (* fixed additions *)
                PreparatorySamples, PreparatoryContainers, PreparatoryVolumes, Primitives, PreparatoryImaging,
                UnitOperations,

                (* FtV *)
                FillToVolumePrimitives, FillToVolumeDefinePrimitives, FillToVolumeSamples, FillToVolumeSolvents,
                FillToVolumeMethods, PreFiltrationImage,

                (* AdjustpH *)
                pHingSamples, pHingSampleContainersOut, NominalpHs, MaxpHs, MinpHs, pHingAcids, pHingBases, pHingSampleModels,
                pHAdjustment,

                (* Mix/Incubate *)
                MixedSolutions, MixProtocols, MixParameters,

                (* Filter *)
                FiltrationSamples, FiltrationParameters, FilterContainers, FilterProtocols,

                (* Autoclave *)
                Autoclave, AutoclaveProgram, AutoclaveProtocols,

                (* Final Transfer *)
                ContainerPrimitives, FinalImaging
            ],
            Packet[Subprotocols][
                DateStarted, DateCompleted, Status, InputUnitOperations, OutputUnitOperations, Subprotocols, SamplesIn,
                AliquotSamples, SamplesOut, Data
            ],
            Packet[Subprotocols][InputUnitOperations][SourceLink, DestinationLink, AmountVariableUnit]
        }
    ], {Download::FieldDoesntExist}];


    (* put together all the packets so we can look up items later *)
    ssCache = Cases[
        Flatten[{
            ssProtocolPacket,
            ssSubprotocolLVLOnePackets,
            inputUnitOperationPackets
        }],
        PacketP[]
    ];
    ssFastAssoc = makeFastAssocFromCache[ssCache];


    (** Start with determining the core items that we will use to group data **)
    (* resolved options *)
    ssResolvedOptions = Lookup[ssProtocolPacket, ResolvedOptions];

    (* Stock solution models *)
    ssModels = Lookup[ssProtocolPacket, StockSolutionModels];

    (* Order of operations - this really should be from the SS model, but many models dont have any value
        we are better off taking it from the resolved options instead *)
    (* Since we are doing it this way, we need to be more careful about the listability of the option *)
    initialOrderOperations = With[{oooValue = Lookup[ssResolvedOptions, OrderOfOperations]},
        If[MatchQ[oooValue, {_Symbol..}],
            ConstantArray[oooValue, Length[ssModels]],
            oooValue
        ]
    ];

    (* Autoclave is not a part of OrderOfOperations, so we need to add it ourselves - in the future these should be taken from the field *)
    autoclaveResolution = With[{autoclaveValue = Lookup[ssResolvedOptions, Autoclave]},
        If[!MatchQ[autoclaveValue, _List],
            ConstantArray[autoclaveValue, Length[ssModels]],
            autoclaveValue
        ]
    ];
    autoclaveProgramResolution = With[{autoclaveProgramValue = Lookup[ssResolvedOptions, AutoclaveProgram]},
        If[!MatchQ[autoclaveProgramValue, _List],
            ConstantArray[autoclaveProgramValue, Length[ssModels]],
            autoclaveProgramValue
        ]
    ];

    (* Lets get our final order of operations *)
    orderOperations = MapThread[
        Append[#1, If[TrueQ[#2], Autoclave, Nothing]]&,
        {initialOrderOperations, autoclaveResolution}
    ];

    (** For each sample model, gather information about its operations **)
    (* Generic label references - these should work as long as the labeling doesn't change in SS resolver *)
    genericLabels = Table["Stock Solution "<>ToString[index], {index, Length[ssModels]}];

    (* Figure out which subprotocol belongs to which operation type
        First get the ones linked in fields. Once we know that, we can remove those from Subprotocols and figure out the rest
        - FixedReagentAdditions is always first once we get to Dosing, so make sure to also remove thawing protocols
        - AdjustpH - pHAdjustment
        - Incubate/Mix - MixProtocols
        - Filter - FilterProtocols
        - Autoclave - AutoclaveProtocols

        Once we have the above lined up, then we figure out which ones are FtV by looking for FtV UO in outputuos
        Also need to figure out which protocol in case we have ContainerPrimitives by looking for transfer UO in outputuos
    *)
    (* Get the start time of the dosing checkpoint *)
    dosingStartTime = FirstCase[
        Lookup[ssProtocolPacket, CheckpointProgress, {{"Dosing", Null}}],
        {"Dosing", targetStartTime_, ___} :> targetStartTime,
        {1}
    ];

    (* Quick detour here: If dosing has not started for processing protocol, we have nothing to show yet and we should exit.
        Maybe we can show resource thawing in the future. It may also make sense to have a warning for developers. *)
    If[NullQ[dosingStartTime], Return[{}]];

    (* All subprotocols that started after dosing checkpoint *)
    ssSubprotocolShortlist = Select[ssSubprotocolLVLOnePackets, GreaterQ[Lookup[#, DateStarted], dosingStartTime]&];

    (* FixedReagentAdditions - we need to get this from the subprotocols directly because it does not get referenced elsewhere
    this is not smart enough to catch the case of repeated subs - Add logic and throw a warning in the future for developers *)
    ssFixedAdditionsSub = Lookup[First[ssSubprotocolShortlist], Object, Null];

    (* pH adjustment *)
    ssAdjustpHSub = Download[Lookup[ssProtocolPacket, pHAdjustment], Object];

    (* Incubation *)
    ssIncubateSub = Download[Lookup[ssProtocolPacket, MixProtocols], Object];

    (* Filter *)
    ssFilterSub = Download[Lookup[ssProtocolPacket, FilterProtocols], Object];

    (* Autoclave *)
    ssAutoclaveSubs = Download[Lookup[ssProtocolPacket, AutoclaveProtocols], Object];

    (* FtV - These are also not referenced in the protocol and must be found from the OutputUnitOperations*)
    ssFtVSubs = Lookup[
        Select[
            ssSubprotocolShortlist,
            MemberQ[Download[Lookup[#, OutputUnitOperations, Null], Type], Object[UnitOperation, FillToVolume]]&
        ],
        Object,
        Null
    ];

    (* Now let's gather up all the categorized subprotocols and eliminate them so we have all the remaining ones that are left *)
    ssSubsOfInterest = DeleteCases[
        Flatten[{
            ssFixedAdditionsSub,
            ssAdjustpHSub,
            ssIncubateSub,
            ssFilterSub,
            ssAutoclaveSubs,
            ssFtVSubs
        }],
        NullP
    ];
    remainingSubprotocolPackets = DeleteCases[ssSubprotocolShortlist, PacketP[ssSubsOfInterest]];

    (* Figure out if we have a transfer subprotocol by comparing the input UOs to the the ContainerPrimitives *)
    extraTransferSub = With[{containerPrimitivesValue = Lookup[ssProtocolPacket, ContainerPrimitives]},
        If[MemberQ[containerPrimitivesValue, _Transfer],
            Module[
                {primitiveInputValues, findSrcDestAmt},

                (* From the primitives, get the Source, Destination and Amount keys since those should exist *)
                primitiveInputValues = Transpose[Lookup[First/@containerPrimitivesValue, {Source, Destination, Amount}]]/.{linkValue:LinkP[] :> Download[linkValue, Object]};

                (* helper to find source, destination and amount from the InputUnitOperations of an MSP *)
                findSrcDestAmt[mspPacket_]:=Module[{inputUOs, transferInputUOs},

                    (* get the input UOs *)
                    inputUOs = Download[Lookup[mspPacket, InputUnitOperations], Object];

                    (* get just the transfer UOs *)
                    transferInputUOs = Cases[inputUOs, ObjectP[Object[UnitOperation, Transfer]]];

                    (* get packets for the transfer uos and lookup the source, destination and amount *)
                    Transpose[Lookup[
                        fetchPacketFromFastAssoc[#, ssFastAssoc]&/@transferInputUOs,
                        {SourceLink, DestinationLink, AmountVariableUnit}]
                    ]/.{linkValue:LinkP[] :> Download[linkValue, Object]}
                ];

                (* using the above function, find a subprotocol if it matches *)
                SelectFirst[
                    remainingSubprotocolPackets,
                    Function[{currentPacket},
                        If[MatchQ[currentPacket, PacketP[Object[Protocol, ManualSamplePreparation]]],
                            AllTrue@@MapThread[
                                ContainsExactly[#1, #2]&,
                                {primitiveInputValues, findSrcDestAmt[currentPacket]}
                            ],
                            False
                        ]
                    ],
                    (* just in case we dont find anything, we should output Null *)
                    Null
                ]
            ],
            Null
        ]
    ];

    (* Now that the relevant subprotocols are known:
        1. we will assign the subprotocols to each model
        2. track any sample object changes within each protocol
        3. Note down the index of the sample so that we can extract the data for it
    *)
    ssSampleTrace = MapThread[
        Function[{currentSSModel, currentSSOoO, currentSSLabel},
            Module[
                (* local variables *)
                {},

                (* fixed reagent additions - get the sample object from LabeledObjects based on our generic label *)
                (* i *)
                (* adjustpH - get the sample object from LabeledObjects based on our generic label *)
                {}
            ]
        ],
        {Download[ssModels, Object], orderOperations, genericLabels}
    ];

    (* Strategy:
        Process one stage at a time:
        - FixedReagentAddition will always happen in 1 subprotocol with the implementation of Primitives on PreparatorySamples and PreparatoryContainers to prepare PreparatoryVolume
        - FillToVolume will happen in a loop of a protocol per FtV primitive
        - AdjustpH will happen in a single subprotocol
        - Mix/Incubate will happen in a single subprotocol
        - Filtration will happen in a single subprotocol
        - Final transfer will happen in a single subprotocol
        - Autoclave will happen as a loop - unclear if there is a grouping of AutoclaveProgram or not


        How can we keep track of the sample? FixedReagentAddition and FillToVolume use labels, but none of the other steps use that.
        The sample can also change in the protocol if it gets aliquoted...

        For each sample, we have Stock Solution 1-n label and we look at each subprotocol's SamplesIn, AliquotSamples and SamplesOut
        to see if that sample object remained the same or not. If it changed, we add that to the list of objects that represents the label.

        We can also create a list of subprotocols relevant to each sample that we can then use to draw more information
    *)


    (** Create a MenuView with a list of ss models **)
    ssMenuViewOutput = MenuView[
        MapIndexed[
            Function[{currentSSModel, currentIndex},
                (* Output a rule, where the key is listed in the menu and the value is the displayed stock solution data *)
                currentSSModel -> TabView[
                    MapIndexed[
                        Function[{currentOperation, currentOperationIndex},
                            Module[
                                (* local variables *)
                                {tabKey},

                                (* Key will be the icon *)
                                tabKey = Tooltip[Row[
                                    {
                                        Style[ToString[First[currentOperationIndex]]<>" ", 22, Bold, LCHColor[0.4, 0, 0], "Helvetica"],
                                        currentOperation/.operationsIconRules
                                    },
                                    Alignment -> Bottom
                                ], currentOperation];

                                (* Put together the rule to output *)
                                tabKey -> Pane["", ImageSize -> {300, 300}]
                            ]
                        ],
                        orderOperations[[First[currentIndex]]]
                    ],
                    ControlPlacement -> {Left, Center}
                ]
            ],
            NamedObject[ssModels]
        ],
        ControlPlacement -> {Top, Center},
        LabelStyle -> Directive["Helvetica", 12]
    ];

    (* Output *)
    {ssMenuViewOutput}
];*)

(*pressureScaler*)

Authors[pressureScaler]:={"catherine"};

pressureScaler[data:{ObjectP[Object[Data,Chromatography]]...}]:=Module[
    {pressureFullTraces,pressureTraces,mins,maxs,ranges,means},

    (* pull out the pressure traces, grabbing just the pressure (y) values of the points, and leaving {Null} if there is no pressure trace *)
    pressureFullTraces = data[Pressure];
    pressureTraces = If[NullQ[#],
        #,
        #[[All,2]]
    ]&/@pressureFullTraces;

    (* get the min and max pressures and then calculate the difference to determine the range of pressures for each data object *)
    {means, mins, maxs, ranges} = Transpose[Map[
        Module[
            {mean, min, max},

            If[NullQ[#],
                {Null,Null,Null,Null},
                {mean, min, max} = {Mean[#], Min[#], Max[#]};
                {mean, min, max, max - min}
            ]
        ]&,
        pressureTraces
    ]];


    (* now we use this information to determine how to scale the y-axis values displayed in the plot *)

    MapThread[
        Which[
            (* if there's no pressure, use the automatic plot range resolution in PlotChromatography *)
            NullQ[#1],Automatic,
            (* if the range is greater than 500 PSI, use the automatic plot range resolution in PlotChromatography *)
            #1>500 PSI, Automatic,
            (* if the range is less than 500 PSI and the max is greater than 250 PSI, pad the mean value by 250 in either direction *)
            #2>250 PSI, {#3-250 PSI,#3+250 PSI},
            (* if the range is less than 500 PSI and max is less than 250 PSI, set the range from 0-500 PSI *)
            #2<=250, {0 PSI, 500 PSI},
            (* if some other case comes up, use the automatic plot range resolution and we can adjust later *)
            _, Automatic
        ]&,
        {ranges,maxs,means}
    ]

]

(*hplcPrimaryData*)

DefineOptions[hplcPrimaryData,
    Options:>{{

        OptionName -> InjectionType,
        Default -> All,
        Description -> "Specifies which injection types should be included in the output. If no injections of the given type are present, all other injections are displayed",
        AllowNull -> False,
        Widget -> Widget[
            Type -> Enumeration,
            Pattern :> (All| Standard | Blank | Sample | ColumnFlush | ColumnPrime | {(Standard | Blank | Sample | ColumnFlush | ColumnPrime) ..})]
    }}
];

Warning::NoInjectionsOfGivenTypes =
    "No injections of the Type(s) `1` are present. Instead, all other types present are displayed.";

Warning::SomeInjectionsMissing =
    "Only injections of Type(s) `1` are present and will be plotted. Requested types `2` are not present.";

Authors[hplcPrimaryData]:={"malav.desai"};

(*Main function*)
hplcPrimaryData[protocol: ObjectP[Object[Protocol, HPLC]],ops:OptionsPattern[]] := Module[
    {
        injectionAssociationInitial, separationMode, scale, dataDetails, fullInjectionAssociation, injectionAssociation, presentTypes, missingTypes, injectionData,
        sampleFields, sampleMeta, chromatograms, filterableLCData, dynamicChromatogramTable, tableFontSize,
        uniqueInjectionTypes, protocolStatus, detectors, typeStrings, includedTypes, gradientBuffers, gradientPlotRules,
        protocolBufferA, protocolBufferB, protocolBufferC, protocolBufferD, protocolBufferAModel,
        protocolBufferBModel, protocolBufferCModel, protocolBufferDModel,
        listedOptions, safeOps, injectionTypeInput, injectionTypes,
        protocolBufferObjects, protocolBufferModelNames, protocolBufferModels, cleanLegendEntries, zoomableChromatograms
    },

    (* download *)
    {
        injectionAssociationInitial,
        dataDetails,
        separationMode,
        scale,
        protocolStatus,
        detectors,
        gradientBuffers,
        protocolBufferA,
        protocolBufferB,
        protocolBufferC,
        protocolBufferD,
        protocolBufferAModel,
        protocolBufferBModel,
        protocolBufferCModel,
        protocolBufferDModel
    } = Download[
        protocol,
        {
            InjectionTable,
            InjectionTable[[Data]][{AbsorbanceWavelength, AirBubbleLikelihood, DateInjected}],
            SeparationMode,
            Scale,
            Status,
            Detectors,
            InjectionTable[[Gradient]][{
                Object,
                BufferA[Object], BufferB[Object], BufferC[Object], BufferD[Object],
                Gradient
            }],
            Packet[BufferA][Name],
            Packet[BufferB][Name],
            Packet[BufferC][Name],
            Packet[BufferD][Name],
            Packet[BufferA][Model][Name],
            Packet[BufferB][Model][Name],
            Packet[BufferC][Model][Name],
            Packet[BufferD][Model][Name]
        }
    ];

    (* Create a list for the options *)
    listedOptions = ToList[ops];

    (* Call SafeOptions to make sure all options match pattern *)
    safeOps = SafeOptions[hplcPrimaryData,listedOptions];

    (* Get the specified injection types to be displayed *)
    injectionTypeInput = Lookup[safeOps,InjectionType];

    injectionTypes = ToList[If[MatchQ[injectionTypeInput,All],
        {Standard, Blank,Sample,ColumnFlush,ColumnPrime},
        injectionTypeInput
    ]
    ];

    (*In order to match the format of the injection table, the types need to be converted into strings*)
    typeStrings = ToString[#]&/@injectionTypes;

    (* Return a message to include if there is no data available *)
    If[NullQ[Lookup[injectionAssociationInitial, Data]],
        If[MatchQ[protocolStatus, Aborted],
            Return[{"This protocol was aborted and does not have chromatograms to display.", "Text"}],
            Return[{"Chromatograms are not yet available. Please generate a review notebook again once the data is parsed.", "Text"}]
        ]
    ];

    (* font size to use in the meta data tables *)
    tableFontSize = 10;

    (* organize the protocol buffer information for the next step *)
    (* buffer objects - get named objects if we have a name, otherwise we will roll with the object *)
    protocolBufferObjects = Map[
        If[!NullQ[Lookup[#, Name, Null]], Append[Lookup[#, Type], Lookup[#, Name]], Lookup[#, Object, Null]]&,
        Replace[{protocolBufferA, protocolBufferB, protocolBufferC, protocolBufferD}, NullP -> <||>, {1}]
    ];
    (* buffer models *)
    {protocolBufferModelNames, protocolBufferModels} = Transpose@Lookup[
        Replace[{protocolBufferAModel, protocolBufferBModel, protocolBufferCModel, protocolBufferDModel}, NullP -> <||>, {1}],
        {Name, Object},
        Null
    ];


    (* plot the gradients so that we can use the as tooltips for the gradient method buttons *)
    gradientPlotRules = Module[
        (* local variables *)
        {uniqueGradientInfo, uniqueLegendEntries, nonNullLegends, uniqueGradientPlots},

        (* get unique gradients *)
        uniqueGradientInfo = DeleteDuplicatesBy[gradientBuffers, First];

        (* We need buffer information to create a legend. Since the protocol options can override the buffer
            fields in the gradient method, we will prioritize the ones in the protocol. Since the gradient might not
            even have a value for all buffer fields, we will still use the gradient model's fields to figure out
            which A/B/C/D we need to show in the legend. We need to map the logic over each of the 4 possible buffers
            Step 1: Check if the buffer field value is non-Null in the gradient method
            Step 2: If the buffer field has a value, pick the first entry from the protocol fields that has a non-Null value from the following order:
                Model name, Model object, Buffer object
         *)
        (* For case where we don't have a buffer model name, we should use the object instead and we should prioritize
            the models/objects in the protocol fields over the gradient method *)
        uniqueLegendEntries = Map[
            Function[gradientBufferModels,
                Map[
                    If[!NullQ[#],
                        SelectFirst[#, Function[value, !NullQ[value]], Null],
                        Null
                    ]&,
                    Transpose[{
                        protocolBufferModelNames,
                        protocolBufferModels,
                        protocolBufferObjects,
                        gradientBufferModels
                    }]
                ]
            ],
            uniqueGradientInfo[[All, 2 ;; 5]]
        ];

        (* One more clean up we need to do is to Null any buffer that is 0% in the gradient *)
        cleanLegendEntries = MapThread[
            Function[{singleLegendList, singleGradient},
                MapThread[
                    If[MemberQ[#2, GreaterP[0 Percent]], #1, Null]&,
                    {singleLegendList, Transpose[singleGradient][[2;;5]]}
                ]
            ],
            {uniqueLegendEntries, uniqueGradientInfo[[All, -1]]}
        ];

        (* remove Nulls *)
        nonNullLegends = DeleteCases[cleanLegendEntries, NullP, {2}];

        (* create plots for the unique methods *)
        uniqueGradientPlots = MapThread[
            PlotGradient[#1,
                Legend -> #2,
                LegendPlacement -> Right,
                ImageSize -> 250,
                LabelStyle -> {11, FontFamily -> "Helvetica"}
            ]&,
            {
                uniqueGradientInfo[[All, 1]],
                nonNullLegends
            }
        ];

        (* create rules and output *)
        MapThread[
            #1 -> #2&,
            {uniqueGradientInfo[[All, 1]], uniqueGradientPlots}
        ]
    ];

    (* get the full injection table *)
    fullInjectionAssociation = MapThread[
        Join[
            #2,
            <|
                "Injection Index" -> #1,
                "Absorbance Wavelength" -> #3[[1]],
                "Air Bubble Likelihood" -> #3[[2]],
                "Date Injected" -> #3[[3]],
                Type -> ToString[Lookup[#2, Type]], (* replace this value with string to avoid Manipulation problems *)
                Gradient -> customButton[Download[Lookup[#2, Gradient], Object],
                    Tooltip -> Column[{
                        Replace[Download[Lookup[#2, Gradient], Object], gradientPlotRules],
                        Style["(Click to copy object)", tableFontSize, "Helvetica"]
                    }, Alignment -> Center],
                    FontSize -> tableFontSize
                ]
            |>
        ]&,
        {
            Range[Length[injectionAssociationInitial]],
            injectionAssociationInitial,
            dataDetails
        }
    ];

    (* get the associations that match the inputTypes *)
    presentTypes = Intersection[typeStrings, Lookup[fullInjectionAssociation, Type]];
    missingTypes = Complement[typeStrings, presentTypes];

    If[presentTypes === {},
        Message[Warning::NoInjectionsOfGivenTypes, typeStrings];
        injectionAssociation = fullInjectionAssociation,

        If[missingTypes =!= {}&&!MatchQ[injectionTypeInput,All],
            Message[Warning::SomeInjectionsMissing, presentTypes, missingTypes]
        ];

        injectionAssociation =
            Select[
                fullInjectionAssociation,
                MatchQ[Lookup[#, Type], Alternatives @@ presentTypes] &
            ];
    ];

    (** create sample meta data tables **)
    (* list our fields of interest *)
    sampleFields = {
        (*1*)"Injection Index",
        (*2*)Type,
        (*3*)Sample,
        (*4*)"Date Injected",
        (*5*)InjectionVolume,
        (*6*)"Absorbance Wavelength",
        (*7*)Data,
        (*8*)Gradient,
        (*9*)ColumnTemperature
    };

    (* Get the values of our fields from the injection association *)
    injectionData = Replace[
        NamedObject[Lookup[injectionAssociation, sampleFields]],
        {
            objectValue:ObjectReferenceP[]:>customButton[objectValue, FontSize -> tableFontSize],
            quantValue_?QuantityQ :> UnitForm[quantValue, Brackets -> False, Round -> 0.01]
        },
        {2}
    ];

    sampleMeta = Grid[
        Cases[
            Transpose[{
                {
                    (*1*)"Injection Index",
                    (*2*)"Type",
                    (*3*)"Sample",
                    (*4*)"Date Injected",
                    (*5*)"Injection Volume",
                    (*6*)"Absorbance Wavelength",
                    (*7*)"Data",
                    (*8*)"Gradient",
                    (*9*)"Column Temperature"
                },
                #
            }],
            {_, Except[NullP]},
            {1}
        ],
        Background -> tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, Left}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> tableFontSize, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> tableFontSize]}},
        Dividers -> {
            {
                Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                }
            },
            {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
        }
    ]&/@injectionData;

    (** Plot chromatograms **)
    (* chromatograms *)
    chromatograms = Which[
        (* When we have scattering data from ELSD, we should plot that specifically *)
        MemberQ[detectors, EvaporativeLightScattering],
            PlotChromatography[Lookup[injectionAssociation, Data],
                PrimaryData -> Scattering,
                PlotLabel -> Null,
                SecondaryData -> {Pressure, GradientA, GradientB},
                ImageSize -> $ReviewPlotSize,
                Map -> True,
                Zoomable -> $ZoomableBoolean
            ],
        (* When we have absorbance, we should plot that specifically *)
        MemberQ[detectors, UVVis | PhotoDiodeArray],
            PlotChromatography[Lookup[injectionAssociation, Data],
                PrimaryData -> Absorbance,
                PlotLabel -> Null,
                SecondaryData -> {Pressure, GradientA, GradientB},
                ImageSize -> $ReviewPlotSize,
                Map -> True,
                Zoomable -> $ZoomableBoolean
            ],
        (* Default *)
        True,
            (* When we don't have absorbance, we will use the default data fields *)
            PlotChromatography[Lookup[injectionAssociation, Data],
                PlotLabel -> Null,
                ImageSize -> $ReviewPlotSize,
                Map -> True,
                Zoomable -> $ZoomableBoolean
            ]
    ];

    (* When we are in Manifold with non-zoomable plots, we should convert them into buttons *)
    zoomableChromatograms = If[$ZoomableBoolean,
        (* when we are not in manifold, we don't need to do anything special *)
        chromatograms,
        (* use the workaround in manifold *)
        zoomableButton/@chromatograms
    ];

    (* get all the data together along with Type so we can filter it using Cases *)
    filterableLCData = Transpose[{Lookup[injectionAssociation, Type], zoomableChromatograms, sampleMeta}];

    (* figure out which unique types exist - we will use this to skip any filtering controls that are irrelevant *)
    uniqueInjectionTypes = DeleteDuplicates[Lookup[injectionAssociation, Type]];

    (* create a Manipulate to be able to filter the type of data being presented *)
    (*Only have the ability to Manipulate if more than one injectionType is used*)
    dynamicChromatogramTable = With[
        {
            manipulationData = filterableLCData,
            uniqueInjTypes = uniqueInjectionTypes
        },

        If[Length[uniqueInjTypes] == 1,

            Pane[
                Grid[
                    Drop[
                        Cases[
                            manipulationData,
                            {uniqueInjTypes[[1]], ___},
                            {1}
                        ],
                        None,
                        1
                    ],
                    Background -> tableBackground[2, IncludeHeader -> False],
                    Alignment -> {Right, Left},
                    Spacings -> {1.5, 1},
                    ItemStyle -> {{
                        Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"],
                        Directive[FontFamily -> "Helvetica", FontSize -> 12]
                    }},
                    Dividers -> {
                        {
                            Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                            {
                                1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                                -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                            }
                        },
                        {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
                    }
                ],
                Scrollbars -> Automatic,
                ImageSize -> {Automatic, UpTo[1200]}
            ],

            Manipulate[
                Pane[
                    Grid[
                        Drop[
                            Cases[
                                manipulationData,
                                {Alternatives @@ includedTypes, ___},
                                {1}
                            ],
                            None,
                            1
                        ],
                        Background -> tableBackground[2, IncludeHeader -> False],
                        Alignment -> {Right, Left},
                        Spacings -> {1.5, 1},
                        ItemStyle -> {{
                            Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"],
                            Directive[FontFamily -> "Helvetica", FontSize -> 12]
                        }},
                        Dividers -> {
                            {
                                Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                                {
                                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                                }
                            },
                            {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
                        }
                    ],
                    Scrollbars -> Automatic,
                    ImageSize -> {Automatic, UpTo[1200]}
                ],
                {{includedTypes, uniqueInjTypes, Style["Include:", Bold]}, uniqueInjTypes},
                ControlType -> CheckboxBar,
                ControlPlacement -> {Top},
                LabelStyle -> {14, "Helvetica"},
                TrackedSymbols :> {includedTypes}
            ]
        ]
    ];

    (* assemble the final output *)
    {
        {
            {
                StyleBox["Chromatography Type: ", FontWeight -> "Bold", FontSize -> 16],
                StyleBox[ToString[separationMode], FontSize -> 16]
            },
            "Text"
        },
        {
            {
                StyleBox["Scale: ", FontWeight -> "Bold", FontSize -> 16],
                StyleBox[ToString[scale], FontSize -> 16]
            },
            "Text"
        },
        dynamicChromatogramTable
    }
];

(*hplcSecondaryData*)

Authors[hplcSecondaryData]:={"malav.desai"};

hplcSecondaryData[protocol: ObjectP[Object[Protocol, HPLC]]] := Module[
    {
        columnTable, guardColumnTable, mobilePhaseTable, systemPrimePlot, systemPrimeTable, systemFlushPlot,
        systemFlushTable, systemPrimeData, systemFlushData, systemPrimeBufferD, systemFlushBufferD, secondaryColumnTable,
        tertiaryColumnTable
    },

    (* download column information *)
    {
        systemPrimeData,
        systemPrimeBufferD,
        systemFlushData,
        systemFlushBufferD
    } = Download[protocol,
        {
            SystemPrimeData,
            SystemPrimeData[BufferD],
            SystemFlushData,
            SystemFlushData[BufferD]
        }
    ];

    (* generate a table for the column - if there is no column or if it's still a model, we will get Null *)
    columnTable = lcColumnTable[protocol, Column];

    (* generate a table for the guard column - if there is no column or if it's still a model, we will get Null *)
    guardColumnTable = lcColumnTable[protocol, GuardColumn];

    (* generate a table for the secondary column - if there is no column or if it's still a model, we will get Null *)
    secondaryColumnTable = lcColumnTable[protocol, SecondaryColumn];

    (* generate a table for the tertiary column - if there is no column or if it's still a model, we will get Null *)
    tertiaryColumnTable = lcColumnTable[protocol, TertiaryColumn];

    (* generate a table for the mobile phases *)
    mobilePhaseTable = lcBufferTable[protocol, Sample];

    (* plot system prime data *)
    systemPrimePlot = If[Length[systemPrimeData] > 0,
        Grid[{{
            If[$ZoomableBoolean,
                (* When not in Mainfold, we create a zoomable plot *)
                PlotChromatography[systemPrimeData,
                    PrimaryData -> Absorbance,
                    PlotLabel -> Null,
                    SecondaryData -> {Pressure, GradientA, GradientB, GradientC, GradientD},
                    SecondYRange -> pressureScaler[systemPrimeData],
                    ImageSize -> $ReviewPlotSize,
                    Zoomable -> $ZoomableBoolean
                ],
                (* In Manifold, we will make it so the user can apply zoomable to the plot *)
                zoomableButton@PlotChromatography[systemPrimeData,
                    PrimaryData -> Absorbance,
                    PlotLabel -> Null,
                    SecondaryData -> {Pressure, GradientA, GradientB, GradientC, GradientD},
                    SecondYRange -> pressureScaler[systemPrimeData],
                    ImageSize -> $ReviewPlotSize,
                    Zoomable -> $ZoomableBoolean
                ]
            ],
            LineLegend[
                {
                    RGBColor[0.368417, 0.506779, 0.709798],
                    RGBColor[0.65, 0., 0.],
                    RGBColor[0.0504678, 0.526626, 0.627561],
                    RGBColor[0.752461, 0.362306, 0.125339],
                    RGBColor[0.435888, 0.259065, 0.71028],
                    If[!NullQ[systemPrimeBufferD], RGBColor[0.461492, 0.563303, 0.0104797], Nothing]
                },
                {
                    "Absorbance",
                    "Pressure",
                    "Gradient A",
                    "Gradient B",
                    "Gradient C",
                    If[!NullQ[systemPrimeBufferD], "Gradient D", Nothing]
                },
                LabelStyle -> {Directive[12, FontFamily -> "Helvetica"]}
            ]
        }}, Spacings -> 2]
    ];

    (* generate a table for the system prime buffers *)
    systemPrimeTable = lcBufferTable[protocol, SystemPrime];

    (* plot system flush data *)
    systemFlushPlot = If[Length[systemFlushData] > 0,
        Grid[{{
            If[$ZoomableBoolean,
                (* When not in Mainfold, we create a zoomable plot *)
                PlotChromatography[systemFlushData,
                    PrimaryData -> Absorbance,
                    PlotLabel -> Null,
                    SecondaryData -> {Pressure, GradientA, GradientB, GradientC, GradientD},
                    SecondYRange -> pressureScaler[systemFlushData],
                    ImageSize -> $ReviewPlotSize,
                    Zoomable -> $ZoomableBoolean
                ],
                (* In Manifold, we will make it so the user can apply zoomable to the plot *)
                zoomableButton@PlotChromatography[systemFlushData,
                    PrimaryData -> Absorbance,
                    PlotLabel -> Null,
                    SecondaryData -> {Pressure, GradientA, GradientB, GradientC, GradientD},
                    SecondYRange -> pressureScaler[systemFlushData],
                    ImageSize -> $ReviewPlotSize,
                    Zoomable -> $ZoomableBoolean
                ]
            ],
            LineLegend[
                {
                    RGBColor[0.368417, 0.506779, 0.709798],
                    RGBColor[0.65, 0., 0.],
                    RGBColor[0.0504678, 0.526626, 0.627561],
                    RGBColor[0.752461, 0.362306, 0.125339],
                    RGBColor[0.435888, 0.259065, 0.71028],
                    If[!NullQ[systemFlushBufferD], RGBColor[0.461492, 0.563303, 0.0104797], Nothing]
                },
                {
                    "Absorbance",
                    "Pressure",
                    "Gradient A",
                    "Gradient B",
                    "Gradient C",
                    If[!NullQ[systemFlushBufferD], "Gradient D", Nothing]
                },
                LabelStyle -> {Directive[12, FontFamily -> "Helvetica"]}
            ]
        }}, Spacings -> 2]

    ];

    (* generate a table for the system flush buffers *)
    systemFlushTable = lcBufferTable[protocol, SystemFlush];

    (* NEED TO ACCOUNT FOR CASES WHERE THERE IS NO DATA *)

    (* assemble the final output *)
    Join[
        If[Or[!NullQ[columnTable], !NullQ[secondaryColumnTable], !NullQ[tertiaryColumnTable]],
            {{"Column Information", "Subsection"}},
            {}
        ],
        If[!NullQ[columnTable],
            {columnTable},
            {}
        ],
        If[!NullQ[secondaryColumnTable],
            {secondaryColumnTable},
            {}
        ],
        If[!NullQ[tertiaryColumnTable],
            {tertiaryColumnTable},
            {}
        ],
        If[!NullQ[guardColumnTable],
            {
                {"Guard Column Information", "Subsection"},
                guardColumnTable
            },
            {}
        ],

        If[!NullQ[mobilePhaseTable],
            {
                {"Mobile Phases", "Subsection"},
                mobilePhaseTable
            },
            {}
        ],

        If[(!NullQ[systemPrimePlot]) || (!NullQ[systemPrimeTable]),
            {{"System Prime", "Subsection", Close}},
            {}
        ],
        If[!NullQ[systemPrimePlot],
            {
                {"Chromatograms collected during the system prime", "Text"},
                systemPrimePlot
            },
            {}
        ],
        If[!NullQ[systemPrimeTable],
            {
                {"Buffers used during the system prime", "Text"},
                systemPrimeTable
            },
            {}
        ],

        If[(!NullQ[systemFlushPlot]) || (!NullQ[systemFlushTable]),
            {{"System Flush", "Subsection", Close}},
            {}
        ],
        If[!NullQ[systemFlushPlot],
            {
                {"Chromatogram collected during the system flush", "Text"},
                systemFlushPlot
            },
            {}
        ],
        If[!NullQ[systemFlushTable],
            {
                {"Buffers used during the system flush", "Text"},
                systemFlushTable
            },
            {}
        ]
    ]
];

(*lcColumnTable*)
Authors[lcColumnTable]:={"malav.desai"};

lcColumnTable[
    protocol: ObjectP[{Object[Protocol, HPLC]}],
    type:Alternatives[Column, GuardColumn, SecondaryColumn, TertiaryColumn]
] := Module[
    {
        columnPacket, columnProductPacket, columnModelPacket, columnOperatingLimits, columnProductInformation, column,
        dataDownload, initialCompletionDate, completionDate, fullInjectionLog,
        protocolMaxPressure, protocolMaxTemperature, protocolMaxFlowRate, storageBufferLog, lastStorageComposition,
        allPressures, protocolMeanPressure, allTemperatures, protocolMeanTemperature,
        allFlowRates, protocolMeanFlowRate, timeDisclaimerComment, stylizeComment, protocolStatus, reorderedData,
        injectionTallyTable
    },

    (* download column information *)
    {
        column,
        columnPacket,
        columnProductPacket,
        columnModelPacket,
        dataDownload,
        initialCompletionDate,
        protocolStatus
    } = Quiet[
        Download[protocol,
            {
                type,
                Packet[type][InjectionLog, BatchNumber, DateStocked, ExpirationDate, StorageBufferLog],
                Packet[type][Product][ProductURL, Supplier, CatalogNumber],
                Packet[type][Model][Name, SeparationMode, MaxNumberOfUses, MaxPressure, MaxFlowRate, MaxTemperature, ColumnType],
                InjectionTable[[Data]][{Pressure, Temperature, FlowRates}],
                DateCompleted,
                Status
            }
        ],
        {Download::FieldDoesntExist}
    ];

    (* return Null if we don't have a column object *)
    If[MatchQ[column, Except[ObjectP[Object[Item, Column]]]],
        Return[Null]
    ];

    (* make sure we have an actual completion date in case the protocol is not done yet *)
    completionDate = If[NullQ[initialCompletionDate], Now, initialCompletionDate];

    (* operating limits and protocol maximums *)
    (*- Injections -*)
    fullInjectionLog = Lookup[columnPacket, InjectionLog];


    (* create a mini table for column injections and max injections *)
    injectionTallyTable = If[Length[fullInjectionLog] > 0,
        Module[
            (* local variables *)
            {relevantLogIndex, columnInjectionCount},

            (* We'll parse the InjectionLog to find the number so that since NumberOfUses changes and we would always want
                the number at the end of the protocol *)
            relevantLogIndex = First@FirstPosition[
                Reverse[Lookup[fullInjectionLog, DateInjected]],
                LessP[completionDate]
            ];

            (* we only count the indices where there is non-zero injection volume *)
            columnInjectionCount = Count[Drop[Lookup[fullInjectionLog, InjectionVolume], -relevantLogIndex], Except[NullP]];

            Grid[
                {
                    {"Tally", "Maximum Uses"},
                    {columnInjectionCount, Lookup[columnModelPacket, MaxNumberOfUses]}
                },
                Background -> tableBackground[2, IncludeHeader -> False],
                Alignment -> Center,
                Spacings -> 1,
                ItemStyle -> {
                    Directive[FontFamily -> "Helvetica", FontSize -> 12],
                    1 -> Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"]
                },
                Dividers -> {
                    {
                        Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                        {
                            1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                            -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                        }
                    },
                    {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
                }
            ]
        ],
        (* default *)
        Grid[
            {
                {"Tally", "Maximum Uses"},
                {0, Lookup[columnModelPacket, MaxNumberOfUses]}
            },
            Background -> tableBackground[2, IncludeHeader -> False],
            Alignment -> Center,
            Spacings -> 1,
            ItemStyle -> {
                Directive[FontFamily -> "Helvetica", FontSize -> 12],
                1 -> Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"]
            },
            Dividers -> {
                {
                    Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                    {
                        1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                        -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                    }
                },
                {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
            }
        ]
    ];

    (* reshape the data to have all the pressures, temperatures and flow rates together, so it's easier for the next steps *)
    reorderedData = Transpose[dataDownload];

    (*- Pressure -*)
    (* gather all the pressure values *)
    allPressures = Last[Transpose[
        Join@@reorderedData[[1]]
    ]];

    (* isolate the max pressure *)
    protocolMaxPressure = Max[allPressures];
    (* calculate the mean pressure *)
    protocolMeanPressure = If[!NullQ[allPressures], Mean[allPressures], Null];

    (*- Temperature -*)
    (* gather all the temperature values *)
    allTemperatures = Last[
        Transpose[
            Join@@reorderedData[[2]]
        ]
    ];

    (* isolate the max temperature *)
    protocolMaxTemperature = Max[allTemperatures];
    (* calculate the mean temperature *)
    protocolMeanTemperature = If[!NullQ[allTemperatures], Mean[allTemperatures], Null];

    (*- Flow Rate -*)
    (* gather all the flow rate values *)
    allFlowRates = Last[
        Transpose[
            Join@@reorderedData[[3]]
        ]
    ];

    (* isolate the max flow rate *)
    protocolMaxFlowRate = Max[allFlowRates];
    (* calculate the mean flow rate *)
    protocolMeanFlowRate = If[!NullQ[allFlowRates], Mean[allFlowRates], Null];

    (* put together the op limits table *)
    columnOperatingLimits = Grid[
        Replace[{
            {"", "Average", "Maximum", "Limit"},
            {"Pressure", protocolMeanPressure, protocolMaxPressure, Lookup[columnModelPacket, MaxPressure]},
            {"Temperature", protocolMeanTemperature, protocolMaxTemperature, Lookup[columnModelPacket, MaxTemperature]},
            {"Flow Rate", protocolMeanFlowRate, protocolMaxFlowRate, Lookup[columnModelPacket, MaxFlowRate]}
        }, {quantValue_?QuantityQ :> UnitForm[quantValue, Brackets -> False, Round -> 0.01], NullP -> "N/A"}, {2}],
        Background -> tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, Center, Center}},
        Spacings -> {1.5, 1},
        ItemStyle -> {
            {Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"]},
            {Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}
        },
        Dividers -> {
            {
                Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                }
            },
            {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
        }
    ];

    (* Product information sub table *)
    columnProductInformation = Grid[
        DeleteCases[{
            {"Supplier", customButton[NamedObject[Lookup[columnProductPacket, Supplier]]]},
            {"Catalog #", Lookup[columnProductPacket, CatalogNumber]},
            {"Batch #", Lookup[columnPacket, BatchNumber]},
            {"Date Stocked", Lookup[columnPacket, DateStocked]},
            {"Expiration", Lookup[columnPacket, ExpirationDate]},
            If[MatchQ[Lookup[columnProductPacket, ProductURL], _String],
                {
                    "Webpage",
                    With[
                        {
                            explicitValue = Lookup[columnProductPacket, ProductURL]
                        },
                        Button[
                            Style["Click to open", 12, "Helvetica"],
                            SystemOpen[explicitValue],
                            Appearance -> None,
                            Method -> "Queued"
                        ]
                    ]
                },
                Nothing
            ]
        }, {_, NullP}, {1}],
        Background -> tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, Left}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
        Dividers -> {
            {
                Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                }
            },
            {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
        }
    ];

    (* Storage buffer composition *)
    storageBufferLog = Lookup[columnPacket, StorageBufferLog];

    (* Assemble the composition table if we have a storage buffer log *)
    lastStorageComposition = If[Length[storageBufferLog] > 0,
        Module[
            (* local variables *)
            {relevantBufferLogIndex, compositionData},

            (* get the last relevant entry from the StorageBufferLog *)
            relevantBufferLogIndex = First@FirstPosition[Reverse[Lookup[storageBufferLog, DateStored]], LessP[completionDate]];

            (* Get the composition *)
            compositionData = If[!MatchQ[relevantBufferLogIndex, "NotFound"], NamedObject[Lookup[storageBufferLog[[-relevantBufferLogIndex]], Composition]]];

            If[!MatchQ[relevantBufferLogIndex, "NotFound"],
                Grid[
                    Replace[
                        Prepend[
                            MapIndexed[Prepend[#1, First[#2]]&, compositionData],
                            {"", "Amount", "Component"}
                        ],
                        {
                            quantValue_?QuantityQ :> UnitForm[quantValue, Brackets -> False, Round -> 0.01],
                            NullP -> "N/A",
                            objectValue:ObjectP[] :> customButton[objectValue]
                        },
                        {2}
                    ],
                    Background -> tableBackground[2, IncludeHeader -> False],
                    Alignment -> {{Right, Center, Center}},
                    Spacings -> {1.5, 1},
                    ItemStyle -> {
                        {Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"]},
                        {Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}
                    },
                    Dividers -> {
                        {
                            Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                            {
                                1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                                -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                            }
                        },
                        {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
                    }
                ]
            ]
        ],
        (* default *)
        Null
    ];

    (* Stylize headers and comments akin to PlotTable. *)
    stylizeComment[comment_String] := Style[comment, 11, FontFamily -> "Helvetica", RGBColor["#4A4A4A"]];

    (* Create a standardized comment to be used for any slides/tables reflecting information at the end of the protocol. *)
    timeDisclaimerComment = stylizeComment[
        InsertLinebreaks[
            If[MatchQ[protocolStatus, Completed],
                StringJoin[
                    "The display above reflects the conditions at the end of ",
                    ToString[InputForm[protocol]],
                    " (",
                    DateString[completionDate],
                    ") unless otherwise specified."
                ],
                StringJoin[
                    "The display above reflects the conditions at ",
                    DateString[completionDate],
                    " unless otherwise specified."
                ]
            ],
            100
        ]
    ];

    (* generate a table for the column *)
    Column[{
        Grid[
            DeleteCases[
                {
                    {"Model", customButton[Model[Item, Column, Lookup[columnModelPacket, Name]]]},
                    {"Column", customButton[Lookup[columnPacket, Object]]},
                    {"Protocol Field", customButton[type]},
                    {"Separation Mode", Lookup[columnModelPacket, SeparationMode]},
                    {"Injections", injectionTallyTable},
                    {Column[{"Operational", "Information"}, Alignment -> Center], columnOperatingLimits},
                    {"Inventory", columnProductInformation},
                    {"Storage Buffer", lastStorageComposition}
                },
                {_, NullP}
            ],
            Background -> tableBackground[2, IncludeHeader -> False],
            ItemSize -> {{Automatic, 30}},
            Alignment -> {{Right, Left}},
            Spacings -> {1.5, 1},
            ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
            Dividers -> {
                {
                    {Directive[Opacity[0]]},
                    {
                        1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1], Opacity[1]],
                        -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1], Opacity[1]]
                    }
                },
                {
                    Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                    {
                        1 -> Directive[LCHColor[0.4, 0, 0], Thickness[2]],
                        -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[2]]
                    }
                }
            }
        ],
        timeDisclaimerComment
    }]
];


(*lcBufferTable*)
Authors[lcBufferTable]:={"malav.desai"};

lcBufferTable[protocol: ObjectP[{Object[Protocol, HPLC], Object[Protocol, FPLC]}], type:Alternatives[Sample, SystemPrime, SystemFlush]] := Module[
    {
        bufferType, allBufferLetters, bufferLetters, imageCloudFiles, bufferImages, imageButtonRules,
        downloadFields, downloadData, volumeConsumed, tableData, bufferTables, bufferIndices, bufferData
    },

    (* buffer type *)
    bufferType = If[MatchQ[type, Sample], "Buffer", ToString[type]<>"Buffer"];

    (* possible buffer letter designations *)
    allBufferLetters = {"A", "B", "C", "D", "E", "F", "G", "H"};

    (* create a list of all the fields to download *)
    downloadFields = ToExpression@Join[
        Table[bufferType<>index2<>index1,
            {index1, {"", "[Model]", "[pH]", "[Conductivity]"}},
            {index2, allBufferLetters}
        ],
        Flatten[
            Table[index1<>bufferType<>index3<>index2,
                {index1, {"Initial", "Final"}},
                {index2, {"Volume", "Appearance"}},
                {index3, allBufferLetters}
            ],
            1
        ]
    ];

    (* download the fields *)
    downloadData = NamedObject[Quiet[Download[protocol, downloadFields], {Download::FieldDoesntExist}]];

    (* identify indices with buffer sample *)
    bufferIndices = Position[First[downloadData], ObjectReferenceP[], {1}, Heads -> False];

    (* select only the buffer letters that are relevant *)
    bufferLetters = Extract[allBufferLetters, bufferIndices];

    (* reorganize data by only taking the indices we determined to have a sample *)
    bufferData = Extract[#, bufferIndices]&/@downloadData;

    (* If any of our buffers are still models, we need to return Null *)
    If[MemberQ[First[bufferData], ObjectP[Model[Sample]]], Return[Null]];

    (* gather the image cloud files *)
    imageCloudFiles = Flatten[bufferData[[{6, 8}]]];

    (* import buffer images *)
    bufferImages = ImportCloudFile[imageCloudFiles];

    (* Create buttons from buffer images *)
    imageButtonRules = MapThread[(#2 -> If[MatchQ[#2, ObjectP[]], formatImage[#1, #2] , "N/A"])&, {bufferImages, Download[imageCloudFiles, Object]}];

    (* calculate the volume consumed *)
    volumeConsumed = Map[
        If[QuantityQ[#], customButton[#], Null]&,
        Join[bufferData[[{5, 7}]], Differences[bufferData[[{7, 5}]]]],
        {2}
    ];

    (* assemble data for tables *)
    tableData = Transpose[Join[bufferData[[;;4]], volumeConsumed]];

    (* put together tables*)
    bufferTables = MapThread[
        Module[{nonNullValues, nonNullHeaders},
            (* remove nulls *)
            nonNullValues = Replace[DeleteCases[#1, NullP], objectValue:ObjectReferenceP[] :> customButton[objectValue], {1}];

            (* remove corresponding row headers *)
            nonNullHeaders = PickList[
                {
                    "Sample",
                    "Model",
                    "pH",
                    "Conductivity",
                    Column[{"Initial", "Volume"}, Alignment -> Right],
                    Column[{"Final", "Volume"}, Alignment -> Right],
                    Column[{"Amount", "Consumed"}, Alignment -> Right]
                },
                #1,
                Except[NullP]
            ];

            (* Create the table *)
            Labeled[Grid[
                Transpose[{nonNullHeaders, nonNullValues}],
                Background -> tableBackground[2, IncludeHeader -> False],
                ItemSize -> {{Automatic, 30}},
                Alignment -> {{Right, Left}},
                Spacings -> {1.5, 1},
                ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
                Dividers -> {
                    {
                        Directive[LCHColor[0.6, 0, 0], Thickness[0.5]],
                        {
                            1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]],
                            -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]
                        }
                    },
                    {{Directive[LCHColor[0.4, 0, 0], Thickness[0.75]]}}
                }
            ], #2, Top]
        ]&,
        {tableData, Table["Buffer "<>idx, {idx, bufferLetters}]}
    ];

    (* plot appearances *)
    Grid[
        Prepend[
            Transpose[{
                bufferTables,
                Replace[Download[bufferData[[6]], Object], imageButtonRules, {1}],
                Replace[Download[bufferData[[8]], Object], imageButtonRules, {1}]
            }],
            Style[#, Bold, 18]&/@{"", "Initial Appearance", "Final Appearance"}
        ],
        Background -> tableBackground[2, IncludeHeader -> True],
        Alignment -> Center,
        Spacings -> {1.5, 1, 1},
        ItemStyle -> {FontSize-> 14, FontFamily -> "Helvetica"},
        Dividers -> {
            {
                {Directive[Opacity[0]]},
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1], Opacity[1]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1], Opacity[1]]
                }
            },
            {
                Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[2]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[2]]
                }
            }
        }
    ]
];



(*gasChromatographyPrimaryData*)

Authors[gasChromatographyPrimaryData]:={"dirk.schild"};

gasChromatographyPrimaryData[protocol:ObjectP[Object[Protocol, GasChromatography]]] := Module[
    {
        injectionTable, detector,
        injectionTableAssoc,
        type, sample,samplingMethod, data, separationMethod,samplePreparationOptions,
        injectionVolume, agitate,
        outputCondensedInjectionTable,
        sampleData, blankData, standardData
    },

    (*Download required information*)
    {injectionTable, detector} = Download[protocol, {InjectionTable,Detector}];

    (*Append the injection index to the table*)
    injectionTableAssoc = MapIndexed[Append[#1, "Injection Index" -> First[#2]]&, injectionTable];

    (*Lookup the basic information to incoorporate in the condensed injection table*)
    {type, sample,samplingMethod, data, separationMethod,samplePreparationOptions} = Transpose[Lookup[injectionTableAssoc, {Type, Sample,SamplingMethod, Data, SeparationMethod, SamplePreparationOptions}]];

    (*SamplePreparationOptions is an association an another lookup is performed to get additional information to incoorporate in the condensed injection table*)
    {injectionVolume, agitate} = Transpose[Lookup[samplePreparationOptions, {InjectionVolume, Agitate}]];

    (*Create Injection Table*)
    outputCondensedInjectionTable = PlotTable[Transpose[{type, sample, injectionVolume, samplingMethod, agitate, data, separationMethod}],
        TableHeadings -> {
            Lookup[injectionTableAssoc, "Injection Index"], {Type, Sample,InjectionVolume, SamplingMethod, Agitate, Data, SeparationMethod}
        },
        Title -> "Condensed Injection Table",
        Alignment -> Center,
        Caption -> "The complete injection table can be found in the InjectionTable field of " <> ToString[protocol],
        Background -> tableBackground[Transpose[{type, sample, injectionVolume, samplingMethod, agitate, data, separationMethod}]]
    ];

    (*Helper function to create the grids for the SlideView function*)
    plotGasChromatographyData[injecttbl_, detector_, type_]:= Module[
        {sampleInjections, sampleFields, samplePreparationFields, sampleMeta, samplePlots, dataPlots, finalSampleData, gridTitle, gridSubHeadings,gcDataObjects,gcMethods, gcMethodsWithoutDuplicates, gcMethodPlotAssoc, msMeta, slideViewGrids, sectionHeader},

        gridTitle = Switch[type,
            Blank, "Blank",
            Sample, "Sample",
            Standard, "Standard"
        ];

        sectionHeader = {StringJoin[gridTitle, " Data"], "Subsection"};
        (* isolate blanks from the injection table *)
        sampleInjections = Cases[injecttbl, KeyValuePattern[Type -> type]];

        (* return if there are no injections! *)
        If[Length[sampleInjections] < 1,
            Return[{}]];

        (* create labels for plots *)
        sampleFields = {"Injection Index", Type, Sample,SamplingMethod, Data, SeparationMethod};
        samplePreparationFields = {InjectionVolume,SampleInjectionRate, Agitate, AgitationTime, HeadspaceSyringeFlushing,HeadspaceSyringeTemperature};

        sampleMeta = sampleMeta = Module[{
            missingKeyQ,tableHeadings,tableData},
            missingKeyQ = Map[!MatchQ[#,Missing["KeyAbsent",___]]&,#];
            tableHeadings = PickList[Join[sampleFields,samplePreparationFields],missingKeyQ];
            tableData = PickList[#,missingKeyQ];
            PlotTable[
                Transpose[{tableData}],
                TableHeadings -> {tableHeadings,None},
                Background -> tableBackground[tableData, IncludeHeader  -> False]
            ]
        ]&/@MapThread[Join[#1,#2]&,{Lookup[sampleInjections, sampleFields],Lookup[Lookup[sampleInjections,SamplePreparationOptions],samplePreparationFields]}];

        gcDataObjects = Lookup[sampleInjections,Data];
        msMeta = If[MatchQ[detector,MassSpectrometer],
            Map[
                PlotTable[
                    Transpose[{#}],
                    TableHeadings -> {{IonMode,SourceTemperature,QuadrupoleTemperature,MinMass,MaxMass,MassDetectionGain},None},
                    Background -> tableBackground[#, IncludeHeader  -> False]

                ]&,Download[gcDataObjects, {IonMode,SourceTemperature,QuadrupoleTemperature,MinMass,MaxMass,MassDetectionGain}]]
        ];

        (* create plots*)
        dataPlots = Switch[detector,
            FlameIonizationDetector,
                Map[
                    ("FID" -> #)&,
                    PlotChromatography[gcDataObjects,
                        PrimaryData -> FIDResponse,
                        PlotLabel -> Null,
                        SecondaryData -> {},
                        ImageSize -> $ReviewPlotSize,
                        PlotStyle -> Directive[Blue, Thickness[0.001]],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ]
                ],
            MassSpectrometer,
                (*Create WaterFall Plot*)
                {
                    {
                    Map[("WaterFall" -> #)&,
                        Quiet[
                            Check[
                                PlotChromatographyMassSpectra[#, Zoomable -> $ZoomableBoolean, ImageSize -> $ReviewPlotSize],
                                ToString[#] <> " has no linked downsampled data in field DownsamplingAnalyses. Please run AnalyzeDownsampling on " <> ToString[#] <> "Data Object. Downsampled data is required for plotting.",
                                Error::DownsampledDataNotFound],
                            {Error::DownsampledDataNotFound, Error::InvalidInput}
                        ] & /@ ToList[gcDataObjects[Object]]
                    ],
                    Map[("MassSpectrum" -> #)&,
                        Quiet[
                            Check[
                                PlotChromatographyMassSpectra[#, Zoomable -> $ZoomableBoolean, ImageSize -> $ReviewPlotSize, PlotType -> MassSpectrum],
                                ToString[#] <> " has no linked downsampled data in field DownsamplingAnalyses. Please run AnalyzeDownsampling on " <> ToString[#] <> "Data Object. Downsampled data is required for plotting.",
                                Error::DownsampledDataNotFound],
                            {Error::DownsampledDataNotFound, Error::InvalidInput}
                        ] & /@ ToList[gcDataObjects[Object]]
                    ],
                    Map[("TotalIonCurrent" -> #)&,
                        Quiet[
                            Check[
                                PlotChromatographyMassSpectra[#, Zoomable -> $ZoomableBoolean, ImageSize -> $ReviewPlotSize, PlotType -> TotalIonCurrent],
                                ToString[#] <> " has no linked downsampled data in field DownsamplingAnalyses. Please run AnalyzeDownsampling on " <> ToString[#] <> "Data Object. Downsampled data is required for plotting.",
                                Error::DownsampledDataNotFound],
                            {Error::DownsampledDataNotFound, Error::InvalidInput}
                        ] & /@ ToList[gcDataObjects[Object]]
                    ],
                    (*Create plot for Total Ion Abundance*)
                    ("Total Ion Abundance (Not down sampled)" -> EmeraldListLinePlot[#, Zoomable -> $ZoomableBoolean, ImageSize -> $ReviewPlotSize])& /@ Download[gcDataObjects, TotalIonAbundance]
                    }
                }
        ];

        (*Lookup the unique GC methods*)
        gcMethods = Lookup[sampleInjections, SeparationMethod][Object];
        gcMethodsWithoutDuplicates = gcMethods//DeleteDuplicates;

        (*In many cases, the same GC method will be used. To speed up the process, PlotGasChromatographyMethod is only ran on a list without duplicates*)
        (*The output association is used later to find the plots that go with each dataPlot*)
        gcMethodPlotAssoc = Association[{# -> PlotGasChromatographyMethod[#, ImageSize -> $ReviewPlotSize]}&/@gcMethodsWithoutDuplicates];

        (*TODO: I think we need a transpose here if there's more than one sample object*)
        samplePlots = MapThread[
            MenuView[Flatten[{#1, "Separation Method" -> #2}]]&,
            {
                dataPlots,
                Lookup[gcMethodPlotAssoc, gcMethods]
            }
        ];

        {finalSampleData,gridSubHeadings} = If[MatchQ[detector,MassSpectrometer],
            {Transpose[{samplePlots, sampleMeta, msMeta}],{{Style["Data", Bold, 20],Style["Injection Information", Bold, 20],Style["MS Settings Table", Bold, 20]}}},
            {Transpose[{samplePlots, sampleMeta}],{{Style["Data", Bold, 16],Style["Injection Information", Bold, 16]}}}
        ];

        (* Create grids of data with headings *)
        slideViewGrids = Grid[
            Join[gridSubHeadings,{#}],
            Frame -> All,
            Spacings -> $ReviewGridSpacings,
            FrameStyle -> Lighter[Gray, 0.4]
        ]&/@finalSampleData;

        (* Output of sub-function *)
        {
            sectionHeader,
            SlideView[slideViewGrids,
                AppearanceElements -> {"FirstSlide", "SlideTotal","PreviousSlide", "NextSlide", "LastSlide"}
            ]
        }

    ];

    (*Create the sections with data using the plotGasChromatographyData function*)
    sampleData = plotGasChromatographyData[injectionTableAssoc, detector, Sample];
    blankData = plotGasChromatographyData[injectionTableAssoc, detector, Blank];
    standardData = plotGasChromatographyData[injectionTableAssoc, detector, Standard];

   Join[{{"Condensed Injection Table", "Subsection"}, outputCondensedInjectionTable}, sampleData, blankData,standardData]
];


(*ionChromatographyPrimaryData*)

Authors[ionChromatographyPrimaryData]:={"dirk.schild"};

ionChromatographyPrimaryData[protocol:ObjectP[Object[Protocol,IonChromatography]]] := Module[
    {
        analysisChannel, electrochemicalInjectionTable, anionInjectionTable, cationInjectionTable, injectionTables, injectionTableSection,
        sampleData, blankData,standardData,primeData,flushData,
        sampleInjections
    },


    {analysisChannel,electrochemicalInjectionTable,anionInjectionTable,cationInjectionTable} = Download[protocol, {ChannelSelection, ElectrochemicalInjectionTable, AnionInjectionTable, CationInjectionTable}];

    (*Create the injection tables with injection index added*)
    injectionTables = Map[
        MapIndexed[
            Append[#1, "Injection Index" -> First[#2]]&, #]&,
       {electrochemicalInjectionTable,anionInjectionTable,cationInjectionTable}
    ];

    (*Some protocols can use both the anion and cation channels, which would result in two separate injection tables.*)
    injectionTableSection =  MapThread[
        Function[{injectionTable, title},
            If[MatchQ[injectionTable,{}],
                {},
                {{"Condensed " <>  title <> " Injection Table","Subsection"},
                    PlotTable[Lookup[injectionTable, {Type, Sample, InjectionVolume, Data, Gradient}],
                        TableHeadings -> {
                            Lookup[injectionTable, "Injection Index"],
                            {Type, Sample, InjectionVolume, Data, Gradient}
                        },
                        Title -> "Condensed " <>  title <> " Injection Table"
                    ]}
            ]
        ], {injectionTables, {"Electrochemical", "Anion", "Cation"}
        }
    ];

(*Create IC plots. Depending on the detector used the output might vary*)
    (*TODO: Discuss where we should locate the ColumnFlush and ColumnPrime data*)
    plotIonChromatographyData[injecttbl_, type_, detector_] := Module[
        {
            gridTitle,sectionHeader,
            icDetectors, icGradientMethods, icDetectorsWithoutDuplicates, icGradientMethodsWithoutDuplicates,
            sampleFields, sampleMeta, icDataObjects, icDataPlots, icGradientMethodPlotAssoc, icMethodPlots,
            samplePlots, finalSampleData, gridSubHeadings, slideViewGrids
        },

        sampleInjections = Cases[injecttbl, KeyValuePattern[Type -> type]];

        (* return if there are no injections! *)
        If[Length[sampleInjections] < 1,
            Return[{}]];

        gridTitle = Switch[type,
            Blank, "Blank",
            Sample, "Sample",
            Standard, "Standard",
            ColumnPrime, "Column Prime",
            ColumnFlush, "Column Flush"
        ];

        sectionHeader = {StringJoin[detector, " Detector ", gridTitle, " Data"], "Subsection"};



        (* create tables with meta data *)
        (*TODO: maybe add suppressor currents for the relevant samples*)
        sampleFields = {"Injection Index", Sample, AnalysisChannel, InjectionVolume, Data, Gradient, ColumnTemperature};
        sampleMeta = PlotTable[Transpose[{sampleFields, #}]]&/@Lookup[sampleInjections, sampleFields];

        (*Lookup the data objectes*)
        icDataObjects = Lookup[sampleInjections,Data];
        {icDetectors, icGradientMethods} = Transpose[Download[icDataObjects, {Detectors, GradientMethod[Object]}]];
        {icDetectorsWithoutDuplicates, icGradientMethodsWithoutDuplicates} = Flatten/@DeleteDuplicates/@{icDetectors, icGradientMethods};
        (*create the various plots*)

        icDataPlots = Module[{conductancePlots,absorbancePlots,chargePlots,intersectionalPlots},
            conductancePlots = If[MemberQ[icDetectorsWithoutDuplicates, Conductance],
                {
                    ("Conductance" -> #)&/@PlotChromatography[icDataObjects,
                        PrimaryData -> Conductance,
                        PlotLabel -> Null,
                        SecondaryData -> {},
                        ImageSize -> 500,
                        PlotStyle -> Directive[Orange, Thickness[0.001]],
                        Filling -> Opacity[0],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ],
                    ("Conductance & Gradient" -> #)&/@PlotChromatography[icDataObjects,
                        PrimaryData -> Conductance,
                        PlotLabel -> Null,
                        SecondaryData -> {GradientA, GradientB, GradientC, GradientD},
                        ImageSize -> 500,
                        PlotStyle -> Directive[Orange, Thickness[0.001]],
                        Filling -> Opacity[0],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ],
                    ("Conductance & Pressure" -> #)&/@PlotChromatography[icDataObjects,
                        PrimaryData -> Conductance,
                        PlotLabel -> Null,
                        SecondaryData -> Pressure,
                        ImageSize -> 500,
                        PlotStyle -> Directive[Blue, Thickness[0.001]],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ]
                },
                {}
            ];
            absorbancePlots = If[MemberQ[icDetectorsWithoutDuplicates, UVVis],
                {
                    ("Absorbance" -> #)& /@ PlotChromatography[icDataObjects,
                        PrimaryData -> Absorbance,
                        PlotLabel -> Null,
                        SecondaryData -> {},
                        ImageSize -> 500,
                        PlotStyle -> Directive[Blue, Thickness[0.001]],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ],
                    ("Absorbance & Gradient" -> #)& /@ PlotChromatography[icDataObjects,
                        PrimaryData -> Absorbance,
                        PlotLabel -> Null,
                        SecondaryData -> {GradientA, GradientB, GradientC, GradientD},
                        ImageSize -> 500,
                        PlotStyle -> Directive[Blue, Thickness[0.001]],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ],
                    ("Absorbance & Pressure" -> #)& /@ PlotChromatography[icDataObjects,
                        PrimaryData -> Absorbance,
                        PlotLabel -> Null,
                        SecondaryData -> Pressure,
                        ImageSize -> 500,
                        PlotStyle -> Directive[Blue, Thickness[0.001]],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ]
                },
                {}
            ];
            chargePlots = If[MemberQ[icDetectorsWithoutDuplicates, ElectrochemicalDetector],
                {
                    ("Charge" -> #)&/@PlotChromatography[icDataObjects,
                        PrimaryData -> Charge,
                        PlotLabel -> Null,
                        SecondaryData -> {},
                        ImageSize -> 500,
                        PlotStyle -> Directive[Blue, Thickness[0.001]],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ],
                    ("Charge & Gradient" -> #)&/@PlotChromatography[icDataObjects,
                        PrimaryData -> Charge,
                        PlotLabel -> Null,
                        SecondaryData -> {GradientA, GradientB, GradientC, GradientD},
                        ImageSize -> 500,
                        PlotStyle -> Directive[Blue, Thickness[0.001]],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ],
                    ("Charge & Pressure" -> #)&/@PlotChromatography[icDataObjects,
                        PrimaryData -> Charge,
                        PlotLabel -> Null,
                        SecondaryData -> Pressure,
                        ImageSize -> 500,
                        PlotStyle -> Directive[Blue, Thickness[0.001]],
                        Zoomable -> $ZoomableBoolean,
                        Map -> True
                    ]
                },
                {}
            ];
            intersectionalPlots = If[MemberQ[icDetectorsWithoutDuplicates, UVVis] && MemberQ[icDetectorsWithoutDuplicates, ElectrochemicalDetector],
                {"Absorbance & Charge" -> PlotChromatography[icDataObjects,
                    PrimaryData -> Absorbance,
                    PlotLabel -> Null,
                    SecondaryData -> Charge,
                    ImageSize -> 500,
                    PlotStyle -> Directive[Blue, Thickness[0.001]],
                    Zoomable -> $ZoomableBoolean
                ]
                },
                {}
            ];
            Transpose[Join[conductancePlots,absorbancePlots,chargePlots,intersectionalPlots]]
        ];

        (*In many cases, the same gradient method will be used. To speed up the process, PlotGradient is only ran on a list without duplicates*)
        (*The output association is used later to find the plots that go with each dataPlot*)
        icGradientMethodPlotAssoc = Association[{# -> PlotGradient[#, ImageSize -> $ReviewPlotSize]}&/@icGradientMethodsWithoutDuplicates];
        icMethodPlots = Lookup[icGradientMethodPlotAssoc, icGradientMethods];
        (*create the final output with MenuView*)

        samplePlots =
            MapThread[MenuView[Flatten[{#1,"Separation Method" -> #2}]]&, {icDataPlots,icMethodPlots}];

        {finalSampleData,gridSubHeadings} = {Transpose[{samplePlots, sampleMeta}],{{Style["Data", Bold, 16],Style["Injection Information", Bold, 16]}}};

        slideViewGrids = Grid[
            Join[gridSubHeadings,{#}],
            Frame -> All,
            Spacings -> $ReviewGridSpacings,
            FrameStyle -> Lighter[Gray, 0.4]
        ]&/@finalSampleData;
        {sectionHeader,SlideView[slideViewGrids,AppearanceElements -> {"FirstSlide", "SlideTotal","PreviousSlide", "NextSlide", "LastSlide"}]}

    ];

    (*Create the sections with data using the plotIonChromatographyData function*)
    (*This could be combined into one big MapThread*)

    sampleData = MapThread[plotIonChromatographyData[#1, Sample,#2]&,{injectionTables,{"Electrochemical", "Anion", "Cation"}}];
    blankData = MapThread[plotIonChromatographyData[#1, Blank,#2]&,{injectionTables,{"Electrochemical", "Anion", "Cation"}}];
    standardData = MapThread[plotIonChromatographyData[#1, Standard,#2]&,{injectionTables,{"Electrochemical", "Anion", "Cation"}}];
    primeData = MapThread[plotIonChromatographyData[#1, ColumnPrime,#2]&,{injectionTables,{"Electrochemical", "Anion", "Cation"}}];
    flushData = MapThread[plotIonChromatographyData[#1, ColumnFlush,#2]&,{injectionTables,{"Electrochemical", "Anion", "Cation"}}];

    Join[Join@@injectionTableSection,
        Flatten[Flatten[#, 1] & /@
            Transpose[{sampleData, blankData, standardData, primeData,
                flushData}], 1]]
];

(*thermalShiftPrimaryData*)

Authors[thermalShiftPrimaryData]:={"melanie.reschke"};

thermalShiftPrimaryData[protocol:ObjectP[Object[Protocol, ThermalShift]]] := Module[
    {dataObjects, meltingCurve3D, plot3DQ, primaryDataPlots},

    (* download *)
    {
        dataObjects,
        meltingCurve3D
    } = Quiet[Download[
        protocol,
        {
            Data,
            Data[MeltingCurve3D]
        }
    ], Download::FieldDoesntExist];

    (* Determine if PlotObject will default to a 3D plot or not *)
    plot3DQ = Switch[meltingCurve3D,
        (* No 3D data *)
        ListableP[Null], False,
        _, True
    ];

    (* If PlotObject will plot 3D data, call PlotObject without the ImageSize and Zoomable options specified. Otherwise include those options *)
    primaryDataPlots = If[plot3DQ,
        List@SlideView@Replace[
            ToList[
                PlotObject /@ dataObjects
            ],
            NullP -> Nothing,
            {1}
        ],
        List@SlideView@Replace[
            If[$ZoomableBoolean,
                (* We are good to use Zoomable when not in Manifold *)
                ToList[PlotObject[#, ImageSize -> $ReviewPlotSize, Zoomable -> $ZoomableBoolean]&/@dataObjects],
                (* When in Manifold, we will create a button to apply zoomable on demand *)
                ToList[zoomableButton[PlotObject[#, ImageSize -> $ReviewPlotSize, Zoomable -> $ZoomableBoolean]]&/@dataObjects]
            ],
            NullP -> Nothing,
            {1}
        ]
    ];

    primaryDataPlots
];

(*nmrPrimaryData*)

Authors[nmrPrimaryData] := {"tyler.pabst"};

nmrPrimaryData[protocol:ObjectP[{Object[Protocol, NMR], Object[Protocol, NMR2D]}]] := Module[
    {
        nmr2DQ, dataFields, dataFieldStrings, protocolDateStarted, protocolDateCompleted, dataObjectPackets, nmrTubeAppearanceLogs, nmrTubeAppearanceImages,
        plotFunction, tubeImageSize, plotOptions, samplePlotsWithoutPeaks, sampleMeta, relevantNMRTubeAppearances, nmrTubeImages, finalSampleData
    },

    (* Set a flag indicating whether this is an NMR2D protocol. *)
    nmr2DQ = MatchQ[protocol, ObjectP[Object[Protocol, NMR2D]]];

    (* Get the fields we need from the data objects as expressions (for Download) and strings (for table headings). *)
    {dataFields, dataFieldStrings} = If[nmr2DQ,
        {
            {SamplesIn, Object, Frequency, Temperature, ExperimentType, SolventModel, NumberOfScans, NumberOfDummyScans, DirectNucleus, IndirectNucleus, DirectAcquisitionTime, DirectSpectralDomain, IndirectSpectralDomain},
            {"Sample", "Data", "Frequency", "Temperature", "Experiment Type", "Deuterated Solvent", "Number of Scans", "Number of Dummy Scans", "Direct Nucleus", "Indirect Nucleus", "Direct Aquisition Time", "Direct Spectral Domain", "Indirect Spectral Domain"}
        },
        {
            {SamplesIn, Object, Frequency, Temperature, Nucleus, SolventModel, NumberOfScans, NumberOfDummyScans, AcquisitionTime, RelaxationDelay, SpectralDomain},
            {"Sample", "Data", "Frequency", "Temperature", "Nucleus", "Deuterated Solvent", "Number of Scans", "Number of Dummy Scans", "Aquisition Time", "Relaxation Delay", "Spectral Domain"}
        }
    ];

    (* Download *)
    {
        protocolDateStarted,
        protocolDateCompleted,
        dataObjectPackets,
        nmrTubeAppearanceLogs,
        nmrTubeAppearanceImages
    } = Download[protocol,
        {
            DateStarted,
            DateCompleted,
            Packet[Data[dataFields]],
            NMRTubes[Contents][[All, 2]][AppearanceLog],
            NMRTubes[Contents][[All, 2]][AppearanceLog][[All, 2]][Image]
        }
    ];

    (* Determine whether to use PlotNMR or PlotNMR2D and adjust the ImageSize and Display options accordingly. Also set the size for the NMR tube images. *)
    {plotFunction, tubeImageSize, plotOptions} = If[nmr2DQ,
        {
            PlotNMR2D,
            250,
            {ImageSize -> 480}
        },
        {
            PlotNMR,
            215,
            {ImageSize -> 450, Display -> {}}
        }
    ];

    (* Get spectra plots without peaks. Account for whether we are on manifold and handle Zoomable appropriately. *)
    samplePlotsWithoutPeaks = If[$ZoomableBoolean,
        (* We are good to use Zoomable when not in Manifold *)
        MapThread[
            Function[
                {object, nucleusOrExperimentType},
                plotFunction[object,
                    PlotLabel -> Pane[Style[ToString[nucleusOrExperimentType] <> " NMR Spectrum of \n" <> ToString[object], 14, Bold, FontFamily -> "Arial"], {500, All}, Alignment -> Center],
                    Sequence @@ plotOptions,
                    Zoomable -> $ZoomableBoolean
                ]
            ],
            {
                Lookup[dataObjectPackets, Object],
                If[nmr2DQ, Lookup[dataObjectPackets, ExperimentType], Lookup[dataObjectPackets, Nucleus]]
            }
        ],
        (* When in Manifold, we will create a button to apply zoomable on demand *)
        MapThread[
            Function[
                {object, nucleusOrExperimentType},
                zoomableButton[
                    plotFunction[object,
                        PlotLabel -> Pane[Style[ToString[nucleusOrExperimentType] <> " NMR Spectrum of \n" <> ToString[object], 14, Bold, FontFamily -> "Arial"], {500, All}, Alignment -> Center],
                        Sequence @@ plotOptions,
                        Zoomable -> $ZoomableBoolean
                    ]
                ]
            ],
            {
                Lookup[dataObjectPackets, Object],
                If[nmr2DQ, Lookup[dataObjectPackets, ExperimentType], Lookup[dataObjectPackets, Nucleus]]
            }
        ]
    ];

    (* Gather the relevant information for each sample. Lookup the SamplesIn separately so it can be un-listed. *)
    sampleMeta = Map[
        PlotTable[
            Transpose[{
                Join[
                    {Lookup[#, SamplesIn][[1]]},
                    Lookup[#, dataFields[[2;;]]]
                ]
            }],
            Alignment -> Center,
            Background -> tableBackground[1, IncludeHeader -> False],
            TableHeadings -> {dataFieldStrings, None}
        ]&,
        dataObjectPackets
    ];

    (* Get the latest appearance of the sample between the protocol's start and completion. *)
    relevantNMRTubeAppearances = MapThread[
        Function[{appearanceLog, imagesPerSample},
            Module[{imageTimes, appearanceObjects, timeAppearanceTuples, relevantAppearanceTuples},

                (* Get the times and images from the appearance log and transpose them to get time-image tuples. *)
                imageTimes = Flatten[appearanceLog[[All, All, 1]]];
                appearanceObjects = Flatten[appearanceLog[[All, All, 2]]];
                timeAppearanceTuples = Transpose[{imageTimes, appearanceObjects}];

                (* Filter out any images that were taken prior to the protocol's start date. *)
                relevantAppearanceTuples = Cases[timeAppearanceTuples,
                    {GreaterP[protocolDateStarted], ObjectP[Object[Data, Appearance]]}
                ];

                (* If we get an empty list, keep it. Otherwise take the final item. *)
                If[MatchQ[relevantAppearanceTuples, {}],
                    {},
                    Module[
                        {appearanceObjectToShow},
                        (* Get the appearance object associated with the latest relevant image. *)
                        appearanceObjectToShow = relevantAppearanceTuples[[-1, -1]];
                        (* Pick the image at the relevant position in the list of images. *)
                        PickList[
                            Cases[Flatten[imagesPerSample], _Image],
                            appearanceObjects,
                            ObjectP[appearanceObjectToShow]
                        ]
                    ]
                ]
            ]
        ],
        {nmrTubeAppearanceLogs, nmrTubeAppearanceImages}
    ];

    (* Get the image of the tube, if it exists. *)
    nmrTubeImages = Map[
        If[MatchQ[#, {}],
            "No image found",
            Pane[ImageResize[First[#], tubeImageSize], tubeImageSize]
        ]&,
        relevantNMRTubeAppearances
    ];

    (* Transpose these to make a row for each data object. *)
    finalSampleData = Transpose[{samplePlotsWithoutPeaks, sampleMeta, nmrTubeImages}];

    (* Output as a grid. *)
    List @ Grid[finalSampleData, Frame -> All, FrameStyle -> Lighter[Gray, 0.4]]

];


(*measurepHPrimaryData*)

Authors[measurepHPrimaryData] := {"tyler.pabst"};

measurepHPrimaryData[protocol:ObjectP[Object[Protocol, MeasurepH]]] := Module[
    {
        gridFormat, protocolFields, samplesIn, samplesInModels, containersIn, containersInModels,
        pHValues, resolvedOptions, temperatureCorrections, probeRecoupSampleBools, incubateSamplePrep, aliquotSamplePrep,
        verificationStandard, verificationStandardModel, verificationStandardWashSolution, verificationStandardWashSolutionModel,
        minVerificationStandardpH, maxVerificationStandardpH, verificationStandardpH, verificationStandardData, verificationDataReferenceTemperature,
        washSolutions, washSolutionModels, secondaryWashSolutions, secondaryWashSolutionModels, minSlope, maxSlope, minOffset, maxOffset,
        lowCalBufferModel, medCalBufferModel, highCalBufferModel,
        calibrationFields, calibrationDataPackets, calibrationsIndexMatched, probesIndexMatched, instrumentsIndexMatched,
        probeModelsIndexMatched, instrumentModelsIndexMatched, data, measurementReferenceTemperatures, splitSamples,
        incubationTemperatures, incubationTimes, mixTypes, incubationInstruments, aliquotAmounts, aliquotContainerModels,
        splitpHValues, splitCalibrations, splitProbes, splitInstruments, splitCorrections, splitRecoupSampleBools, splitSamplesInModels,
        splitIncubationTemperatures, splitIncubationTimes, splitMixTypes, splitIncubationInstruments, splitAliquotAmounts, splitAliquotContainerModels,
        splitProbeModels, splitInstrumentModels, splitData, splitWashSolutions, splitWashSolutionModels, splitSecondaryWashSolutions,
        splitSecondaryWashSolutionModels, splitMeasurementTemperatures, numbersOfReplicates, meanpHValues, stdDevpHValues, sampleIndices,
        instrumentsFromResolvedOptions, sampleButtons, containerButtons, probeButtons, instrumentButtons,
        washSolutionButtons, secondaryWashSolutionButtons, sampleBoxWhiskerCharts, measurementDataTables, sampleMeasurementTablesWithPlots,
        sampleSlides, calibrationObjects, lowCalTargetpH, medCalTargetpH, highCalTargetpH,
        lowCalTemp, medCalTemp, highCalTemp, absoluteSlope, pHOffsetValue, lowCalBuffer, medCalBuffer, highCalBuffer,
        lowCalBufferObjects, medCalBufferObjects, highCalBufferObjects, numberOfCalibrations,
        lowCalBufferButtons, medCalBufferButtons, highCalBufferButtons, makeCalibrationPlot, calibrationPlots, calibrationDataTables, calibrationProbeRules,
        calibrationTablesWithPlots, calibrationDataSlides, verificationPlotAndTable, standardObjectNamed, standardModelNamed, washSolutionObjectNamed,
        washSolutionModelNamed, verificationStandardButton, dataSummary
    },

    (* Setup grid formatting options *)
    gridFormat = {
        Background -> Experiment`Private`tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, {Left}}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
        Dividers -> {
            {{Directive[Opacity[0]]}},
            {
                Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]]
                }
            }
        }
    };

    (* Get the fields we want from the protocol object. *)
    protocolFields = {
        SamplesIn[Object],
        SamplesIn[Model],
        ContainersIn[Object],
        ContainersIn[Model],
        pH,
        ResolvedOptions,
        TemperatureCorrection,
        ProbeRecoupSample,
        IncubateSamplePreparation,
        AliquotSamplePreparation,
        VerificationStandard,
        VerificationStandard[Model],
        VerificationStandardWashSolution,
        VerificationStandardWashSolution[Model],
        MinVerificationStandardpH,
        MaxVerificationStandardpH,
        VerificationStandardpH,
        VerificationStandardData[Object],
        VerificationStandardData[ReferenceTemperature],
        WashSolutions,
        WashSolutions[Model],
        SecondaryWashSolutions,
        SecondaryWashSolutions[Model],
        MinpHSlope,
        MaxpHSlope,
        MinpHOffset,
        MaxpHOffset
    };

    (* Get the fields we want from the calibration object(s). *)
    calibrationFields = {
        LowCalibrationTargetpH,
        MediumCalibrationTargetpH,
        HighCalibrationTargetpH,
        LowCalibrationTemperature,
        MediumCalibrationTemperature,
        HighCalibrationTemperature,
        AbsolutepHSlope,
        pHOffset,
        LowCalibrationBuffer,
        MediumCalibrationBuffer,
        HighCalibrationBuffer
    };

    (* Download *)
    {
        {
            samplesIn,
            samplesInModels,
            containersIn,
            containersInModels,
            pHValues,
            resolvedOptions,
            temperatureCorrections,
            probeRecoupSampleBools,
            incubateSamplePrep,
            aliquotSamplePrep,
            verificationStandard,
            verificationStandardModel,
            verificationStandardWashSolution,
            verificationStandardWashSolutionModel,
            minVerificationStandardpH,
            maxVerificationStandardpH,
            verificationStandardpH,
            verificationStandardData,
            verificationDataReferenceTemperature,
            washSolutions,
            washSolutionModels,
            secondaryWashSolutions,
            secondaryWashSolutionModels,
            minSlope,
            maxSlope,
            minOffset,
            maxOffset
        },
        calibrationDataPackets,
        lowCalBufferModel,
        medCalBufferModel,
        highCalBufferModel,
        calibrationsIndexMatched,
        probesIndexMatched,
        instrumentsIndexMatched,
        probeModelsIndexMatched,
        instrumentModelsIndexMatched,
        data,
        measurementReferenceTemperatures
    } = Flatten[#, 1]& /@ Download[protocol,
        {
            {protocolFields},
            {Packet[CalibrationData[calibrationFields]]},
            {CalibrationData[LowCalibrationBuffer][Model][Object]},
            {CalibrationData[MediumCalibrationBuffer][Model][Object]},
            {CalibrationData[HighCalibrationBuffer][Model][Object]},
            {Data[CalibrationData][Object]},
            {Data[Probe][Object]},
            {Data[Instrument][Object]},
            {Data[Probe][Model][Object]},
            {Data[Instrument][Model][Object]},
            {Data[Object]},
            {Data[ReferenceTemperature]}
        }
    ];

    (* Split the samples in such that consecutive identical samples are grouped. *)
    splitSamples = Split[samplesIn];

    (* Get info from incubate sample preparation, if applicable. *)
    {incubationTemperatures, incubationTimes, mixTypes, incubationInstruments} = If[MatchQ[incubateSamplePrep, {}],
        {
            ConstantArray[Null, Length[splitSamples]],
            ConstantArray[Null, Length[splitSamples]],
            ConstantArray[Null, Length[splitSamples]],
            ConstantArray[Null, Length[splitSamples]]
        },
        Transpose @ Lookup[incubateSamplePrep, {IncubationTemperature, IncubationTime, MixType, IncubationInstrument}]
    ];

    (* Get info from aliquot sample preparation, if applicable. *)
    {aliquotAmounts, aliquotContainerModels} = If[MatchQ[aliquotSamplePrep, {}],
        {
            ConstantArray[Null, Length[splitSamples]],
            ConstantArray[Null, Length[splitSamples]]
        },
        Module[
            {amounts, rawContainers, containersWithoutIndices},

            (* Get the amounts and containers (which may contain indices) from the AliquotSamplePreparation *)
            {amounts, rawContainers} = Transpose @ Lookup[aliquotSamplePrep, {AliquotAmount, AliquotContainer}];

            (* Strip out any container indices. *)
            containersWithoutIndices = Map[
                If[MatchQ[#, {_Integer, ObjectP[]}],
                    #[[2]],
                    #
                ]&,
                rawContainers
            ];

            (* Return *)
            {amounts, containersWithoutIndices}
        ]
    ];

    (* Reshape some variable lists such that they have the same list structure as splitSamples. *)
    {
        splitpHValues,
        splitCalibrations,
        splitProbes,
        splitInstruments,
        splitCorrections,
        splitRecoupSampleBools,
        splitSamplesInModels,
        splitIncubationTemperatures,
        splitIncubationTimes,
        splitMixTypes,
        splitIncubationInstruments,
        splitAliquotAmounts,
        splitAliquotContainerModels,
        splitProbeModels,
        splitInstrumentModels,
        splitData,
        splitWashSolutions,
        splitWashSolutionModels,
        splitSecondaryWashSolutions,
        splitSecondaryWashSolutionModels,
        splitMeasurementTemperatures
    } = Unflatten[#, splitSamples]& /@ {
        Round[pHValues, 0.001],
        calibrationsIndexMatched,
        probesIndexMatched,
        instrumentsIndexMatched,
        temperatureCorrections,
        probeRecoupSampleBools,
        samplesInModels,
        incubationTemperatures,
        incubationTimes,
        mixTypes,
        incubationInstruments,
        aliquotAmounts,
        aliquotContainerModels,
        probeModelsIndexMatched,
        instrumentModelsIndexMatched,
        data,
        washSolutions,
        washSolutionModels,
        secondaryWashSolutions,
        secondaryWashSolutionModels,
        measurementReferenceTemperatures
    };

    (* Take the average and standard deviation of each sample's measured values. *)
    {numbersOfReplicates, meanpHValues, stdDevpHValues} = Transpose @ Map[
        Function[{pHlist},
            If[EqualQ[Length[pHlist], 1],
                {1, pHlist[[1]], 0},
                {Length[pHlist], Round[Mean[pHlist], 0.001], Round[StandardDeviation[pHlist], 0.001]}
            ]
        ],
        splitpHValues
    ];

    (* Make a sample index list that accounts for the number of replicate measurements of each unique sample. *)
    sampleIndices = Flatten @ MapThread[
        Function[
            {uniqueSampleIndex, replicatesPerSample},
            ConstantArray[uniqueSampleIndex, replicatesPerSample]
        ],
        {Range[Length[DeleteDuplicates[samplesIn]]], numbersOfReplicates}
    ];

    (* Get the instruments from the ResolvedOptions in case this is missing from the data objects for some reason. *)
    instrumentsFromResolvedOptions = Module[
        {instrumentFromOptions},

        instrumentFromOptions = Lookup[resolvedOptions, Instrument];

        Which[
            (* If instrumentsIndexMatched is a list of instruments, we won't be using this and it can just be a flat list of Nulls. *)
            MatchQ[instrumentsIndexMatched, {ObjectP[{Object[Instrument], Model[Instrument]}]..}],
                ConstantArray[Null, Length[splitSamples]],
            (* If the instrument option is singleton, just make an array of the value with the length of splitSamples. *)
            MatchQ[instrumentFromOptions, ObjectP[{Object[Instrument], Model[Instrument]}]],
                ConstantArray[instrumentFromOptions, Length[splitSamples]],
            (* If the instrument option is a list with just one unique value, pad it out to the length of splitSamples. *)
            MatchQ[DeleteDuplicates@instrumentFromOptions, {ObjectP[{Object[Instrument], Model[Instrument]}]}],
                ConstantArray[instrumentFromOptions[[1]], Length[splitSamples]],
            (* If there are multiple instruments, work out the expanded list from the options. *)
            True,
                Flatten[ConstantArray[#, Length[splitSamples]/Length[instrumentFromOptions]]& /@ instrumentFromOptions]
        ]
    ];

    (* Make clickable sample, container, instrument, and probe buttons which display the model in the tooltip. *)
    sampleButtons = MapThread[
        Function[
            {sample, sampleModel},
            If[MatchQ[sampleModel, ObjectP[Model[Sample]]],
                customButton[sample, CopyContent -> sample, Tooltip -> Column[{ToString[sampleModel], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]],
                sample
            ]
        ],
        {splitSamples[[All, 1]], NamedObject[splitSamplesInModels[[All, 1]]]}
    ];
    containerButtons = MapThread[
        Function[
            {container, containerModel},
            If[MatchQ[containerModel, ObjectP[Model[Container]]],
                customButton[container, CopyContent -> container, Tooltip -> Column[{ToString[containerModel], "Click to copy Object[Container]"}, Alignment -> {Center, Baseline}]],
                container
            ]
        ],
        {containersIn, NamedObject[containersInModels]}
    ];
    probeButtons = MapThread[
        Function[
            {probe, probeModel},
            Which[
                MatchQ[probeModel, ObjectP[Model[Part]]],
                    customButton[probe, CopyContent -> probe, Tooltip -> Column[{ToString[probeModel], "Click to copy Object[Part]"}, Alignment -> {Center, Baseline}]],
                MatchQ[probe, ObjectP[Object[Part]]],
                    probe,
                True,
                    Null
            ]
        ],
        {splitProbes[[All, 1]], NamedObject[splitProbeModels[[All, 1]]]}
    ];
    instrumentButtons = MapThread[
        Function[
            {instrument, instrumentModel},
            Which[
                MatchQ[instrumentModel, ObjectP[Model[Instrument]]],
                    customButton[instrument, CopyContent -> instrument, Tooltip -> Column[{ToString[instrumentModel], "Click to copy Object[Instrument]"}, Alignment -> {Center, Baseline}]],
                MatchQ[instrument, ObjectP[Object[Instrument]]],
                    instrument,
                True,
                    Null
            ]
        ],
        {splitInstruments[[All, 1]], If[NullQ[instrumentsFromResolvedOptions], NamedObject[splitInstrumentModels[[All, 1]]], instrumentsFromResolvedOptions]}
    ];
    washSolutionButtons = MapThread[
        Function[
            {sample, sampleModel},
            Which[
                MatchQ[sampleModel, ObjectP[Model[Sample]]],
                    customButton[sample, CopyContent -> sample, Tooltip -> Column[{ToString[sampleModel], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]],
                MatchQ[sample, ObjectP[Object[Sample]]],
                    sample,
                True,
                    Null
            ]
        ],
        {splitWashSolutions[[All, 1]], NamedObject[splitWashSolutionModels[[All, 1]]]}
    ];
    secondaryWashSolutionButtons = MapThread[
        Function[
            {sample, sampleModel},
            Which[
                MatchQ[sampleModel, ObjectP[Model[Sample]]],
                    customButton[sample, CopyContent -> sample, Tooltip -> Column[{ToString[sampleModel], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]],
                MatchQ[sample, ObjectP[Object[Sample]]],
                    sample,
                True,
                    Null
            ]
        ],
        {splitSecondaryWashSolutions[[All, 1]], NamedObject[splitSecondaryWashSolutionModels[[All, 1]]]}
    ];

    (* Make a box and whisker chart for samples with replicate pH measurements. *)
    sampleBoxWhiskerCharts = Map[
        If[LessQ[Length[#], 2],
            Null,
            Column[
                {
                    EmeraldBoxWhiskerChart[
                        #,
                        BarOrigin -> Left,
                        AspectRatio -> 9/40,
                        FrameTicksStyle -> Directive[Black, FontFamily -> "Helvetica", 13, FontWeight -> Plain],
                        Frame -> True,
                        ImagePadding -> 22,
                        ChartStyle -> $ExperimentalResultColor,
                        ImageSize -> 525
                    ],
                    Style["pH", FontWeight -> Plain, FontFamily->"Helvetica"]
                },
                Alignment -> Center,
                Spacings -> 0
            ]
        ]&,
        splitpHValues
    ];

    (* Set up the pH measurement data tables. *)
    measurementDataTables = MapThread[
        Function[
            {
                sampleIndex,
                sampleButton,
                containerButton,
                pHMeasurements,
                pHMean,
                pHStdDeviation,
                dataObject,
                instrumentButton,
                probeButton,
                washSolutionButton,
                secondaryWashSolutionButton,
                temps,
                calibrationObject,
                mixTemp,
                mixTime,
                mixType,
                mixInstrument,
                aliquotAmount,
                aliquotContainerModel,
                probeRecoupSampleBool
            },

            Module[
                {tableContent},

                (* Generate the table for each sample according to the available information. *)
                tableContent = {

                    (* Use the sample and container buttons generated above. *)
                    {"Sample", sampleButton},
                    {"Container", containerButton},

                    (* Display the instrument and probe buttons, if available. *)
                    If[!NullQ[instrumentButton],
                        {"Instrument", instrumentButton},
                        Nothing
                    ],
                    If[!NullQ[probeButton],
                        {"Probe", probeButton},
                        Nothing
                    ],
                    If[!NullQ[calibrationObject], {"Calibration", calibrationObject}, Nothing],

                    (* Display the buttons for wash and secondary wash solutions, if applicable. *)
                    If[!NullQ[washSolutionButton],
                        {"Wash Solution", washSolutionButton},
                        Nothing
                    ],
                    If[!NullQ[secondaryWashSolutionButton],
                        {"Secondary Wash Solution", secondaryWashSolutionButton},
                        Nothing
                    ],

                    If[SameQ[Length[pHMeasurements], 1],
                        Sequence @@ {
                            {"Measured pH", pHMeasurements[[1]]},
                            {"Data", dataObject[[1]]},
                            {"Temperature", temps[[1]]}
                        },
                        Sequence @@ {
                            {"Measured pH", StringJoin[ToString[pHMean], " \[PlusMinus] ", ToString[pHStdDeviation]]},
                            {
                                "Measurement Data",
                                Module[
                                    {miniTableContent},

                                    miniTableContent = Prepend[
                                        Transpose @ {Range[Length[pHMeasurements]], pHMeasurements, dataObject, temps},
                                        Style[#, Bold, FontFamily -> "Helvetica"]& /@ {"Rep.", "pH", "Data", "Temp."}
                                    ];
                                    Grid[Replace[miniTableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                                        Sequence @@ gridFormat,
                                        ItemSize -> {{All, UpTo[25]}}
                                    ]
                                ]
                            }
                        }
                    ],

                    (* Provide incubate/mix information, if relevant. *)
                    Which[
                        (* If there is no incubation/mixing, include none of this. *)
                        MatchQ[incubateSamplePrep, {}],
                            Nothing,
                        (* If there is mixing, provide all the available info and call it mixing, not incubation. *)
                        MatchQ[mixType, MixTypeP],
                            Sequence @@ {
                                {"Mix Type", mixType},
                                If[!NullQ[mixTime], {"Mix Time", UnitForm[mixTime, Brackets -> False]}, Nothing],
                                If[!NullQ[mixTemp], {"Mix Temperature", UnitForm[mixTemp, Brackets -> False]}, Nothing],
                                If[!NullQ[mixInstrument], {"Mix Instrument", mixInstrument}, Nothing]
                            },
                        (* Otherwise, provide the incubation info and refer to it as incubation. *)
                        True,
                            Sequence @@ {
                                If[!NullQ[mixTime], {"Incubation Time", UnitForm[mixTime, Brackets -> False]}, Nothing],
                                If[!NullQ[mixTemp], {"Incubation Temperature", UnitForm[mixTemp, Brackets -> False]}, Nothing],
                                If[!NullQ[mixInstrument], {"Incubation Instrument", mixInstrument}, Nothing]
                            }
                    ],

                    (* Show aliquot information, if relevant. *)
                    If[VolumeQ[aliquotAmount], {"Aliquot Amount", UnitForm[aliquotAmount, Brackets -> False]}, Nothing],
                    If[MatchQ[aliquotContainerModel, ObjectP[]], {"Aliquot Container", aliquotContainerModel}, Nothing],

                    (* Only show ProbeRecoupSample if it is True, since it is likely to be uncommon. *)
                    If[TrueQ[probeRecoupSampleBool], {"Recoup Sample", True}, Nothing]
                };

                (* Set up the grid and label it *)
                Labeled[
                    Grid[Replace[tableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                        Sequence@@gridFormat,
                        ItemSize -> {{All, 28}}
                    ],
                    If[
                        GreaterQ[Length[splitSamples], 1],
                        "pH Measurements, Sample "<>ToString[sampleIndex],
                        "pH Measurements"
                    ],
                    Top,
                    LabelStyle -> Directive[Bold, FontFamily -> "Helvetica"]
                ]
            ]

        ],
        {
            Range[Length[splitSamples]],
            sampleButtons,
            containerButtons,
            splitpHValues,
            meanpHValues,
            stdDevpHValues,
            splitData,
            instrumentButtons,
            probeButtons,
            washSolutionButtons,
            secondaryWashSolutionButtons,
            splitMeasurementTemperatures,
            splitCalibrations[[All, 1]],
            splitIncubationTemperatures[[All, 1]],
            splitIncubationTimes[[All, 1]],
            splitMixTypes[[All, 1]],
            splitIncubationInstruments[[All, 1]],
            splitAliquotAmounts[[All, 1]],
            splitAliquotContainerModels[[All, 1]],
            splitRecoupSampleBools[[All, 1]]
        }
    ];

    (* Combine the box whisker plots (if any) and the data tables for the sample measurement. *)
    sampleMeasurementTablesWithPlots = MapThread[
        Function[
            {boxAndWhisker, dataTable},
            Labeled[
                Framed[
                    Column[
                        {
                            If[NullQ[boxAndWhisker],
                                Nothing,
                                boxAndWhisker
                            ],
                            dataTable
                        },
                        Alignment -> Center
                    ],
                    FrameStyle -> Lighter[Gray, 0.4]
                ],
                "Sample Data",
                Top,
                LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
            ]
        ],
        {sampleBoxWhiskerCharts, measurementDataTables}
    ];

    (* If we have more than one table to show, convert to slideview. Otherwise just use the one table. *)
    sampleSlides = If[SameQ[Length[sampleMeasurementTablesWithPlots], 1],
        sampleMeasurementTablesWithPlots[[1]],
        SlideView[
            sampleMeasurementTablesWithPlots,
            AppearanceElements -> {"FirstSlide", "PreviousSlide", "NextSlide", "LastSlide", "SlideNumber", "SlideTotal"},
            ControlPlacement -> {Top, Center},
            FrameMargins -> 10
        ]
    ];

    (* Lookup data from the calibration data packets. *)
    {
        calibrationObjects,
        lowCalTargetpH,
        medCalTargetpH,
        highCalTargetpH,
        lowCalTemp,
        medCalTemp,
        highCalTemp,
        absoluteSlope,
        pHOffsetValue,
        lowCalBuffer,
        medCalBuffer,
        highCalBuffer
    } = If[MemberQ[calibrationDataPackets, PacketP[]],
        Transpose @ Lookup[calibrationDataPackets, Prepend[calibrationFields, Object]],
        ConstantArray[{}, 12]
    ];

    (* Strip the links off the buffer objects. *)
    {lowCalBufferObjects, medCalBufferObjects, highCalBufferObjects} = Download[{lowCalBuffer, medCalBuffer, highCalBuffer}, Object];

    (* Get the number of calibration objects associated with this protocol. *)
    numberOfCalibrations = Length[calibrationObjects];

    (* Make clickable calibration buffer buttons which display the model in the tooltip. *)
    lowCalBufferButtons = Map[
        If[MatchQ[lowCalBufferModel[[1]], ObjectP[Model[Sample]]],
            customButton[#, CopyContent -> #, Tooltip -> Column[{ToString[NamedObject[lowCalBufferModel[[1]]]], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]],
            #
        ]&,
        lowCalBufferObjects
    ];
    medCalBufferButtons = Map[
        If[MatchQ[medCalBufferModel[[1]], ObjectP[Model[Sample]]],
            customButton[#, CopyContent -> #, Tooltip -> Column[{ToString[NamedObject[medCalBufferModel[[1]]]], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]],
            #
        ]&,
        medCalBufferObjects
    ];
    highCalBufferButtons = Map[
        If[MatchQ[highCalBufferModel[[1]], ObjectP[Model[Sample]]],
            customButton[#, CopyContent -> #, Tooltip -> Column[{ToString[NamedObject[highCalBufferModel[[1]]]], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]],
            #
        ]&,
        highCalBufferObjects
    ];

    (* Helper to build plots visualizing the calibration data. *)
    makeCalibrationPlot[calibrationPacket:PacketP[Object[Calibration, pH]]] := Module[
        {theoreticalSlope, lineThickness, calibrationSlope, calibrationOffset, slopeAsDecimal},

        (* Set some values here and use the variables throughout. *)
        theoreticalSlope = -59.16 Millivolt;
        lineThickness = 0.004;

        (* Get the necessary information from the calibration packet. *)
        {calibrationSlope, calibrationOffset} = Lookup[calibrationPacket, {AbsolutepHSlope, pHOffset}];

        (* Convert the slope to a decimal. *)
        slopeAsDecimal = Unitless[calibrationSlope] / 100;

        (* Generate the plot if we have values for the slope and offset. If not, return Null. *)
        If[NullQ[calibrationSlope] || NullQ[calibrationOffset],
            Null,
            Column[
                {
                    zoomableButton @ Plot[
                        {
                            theoreticalSlope * (x - 7),
                            If[NumberQ[slopeAsDecimal],
                                slopeAsDecimal * theoreticalSlope * (x - 7) + calibrationOffset,
                                Nothing
                            ]
                        },
                        {x, 0, 14},
                        PlotStyle -> {Directive[$TheoreticalResultColor, Thickness[lineThickness]], Directive[$ExperimentalResultColor, Thickness[lineThickness]]},
                        AxesLabel -> {pH, "mV"},
                        AxesStyle -> Black,
                        AspectRatio -> 1/2,
                        ImageSize -> 500
                    ],
                    LineLegend[
                        {$TheoreticalResultColor, $ExperimentalResultColor},
                        Style[#, FontFamily -> "Helvetica", 12]& /@ {"Theoretical","Experimental"},
                        LegendLayout -> "Row"
                    ]
                },
                Alignment -> Center,
                Spacings -> 0
            ]
        ]
    ];

    (* Generate the calibration plots. *)
    calibrationPlots = Map[
        If[NullQ[#],
            Null,
            makeCalibrationPlot[#]
        ]&,
        calibrationDataPackets
    ];

    (* Generate replace rules to get the correct probe button from each calibration object. *)
    calibrationProbeRules = DeleteDuplicates @ MapThread[
        (Alternatives @@ #1) -> #2 &,
        {splitCalibrations, probeButtons}
    ];

    (* Set up the pH calibration data tables. *)
    calibrationDataTables = MapThread[
        Function[
            {
                calibrationIndex,
                calibrationObject,
                slope,
                pHOffsetForMapThread,
                probeButton,
                lowStandardButton,
                mediumStandardButton,
                highStandardButton,
                lowTargetpH,
                medTargetpH,
                highTargetpH,
                lowTemp,
                medTemp,
                highTemp
            },

            Module[
                {tableContent, grid},

                (* Generate the table for each pH calibration according to the available information. *)
                (* We will usually have ALL of these values, but we wrap If[] around everything *)
                (* just in case, and for backwards compatibility. *)
                tableContent = {
                    {"Calibration Object", calibrationObject},
                    If[!NullQ[probeButton], {"Probe", probeButton}, Nothing],
                    If[!NullQ[slope], {"Calibration Fit Slope", UnitForm[slope, Brackets -> False]}, Nothing],
                    If[!NullQ[pHOffsetForMapThread], {"Calibration Fit Offset", UnitForm[pHOffsetForMapThread, Brackets -> False]}, Nothing],

                    Switch[{lowStandardButton, lowTargetpH},
                        {Except[Null], _Real}, {"Low pH ("<>ToString[lowTargetpH]<>") Standard", lowStandardButton},
                        {_, _Real}, {"Low pH Value", lowTargetpH},
                        NullP, Nothing,
                        _, {"Low pH Standard", lowStandardButton}
                    ],

                    Switch[{mediumStandardButton, medTargetpH},
                        {Except[Null], _Real}, {"Medium pH ("<>ToString[medTargetpH]<>") Standard", mediumStandardButton},
                        {_, _Real}, {"Medium pH Value", medTargetpH},
                        NullP, Nothing,
                        _, {"Medium pH Standard", mediumStandardButton}
                    ],

                    Switch[{highStandardButton, highTargetpH},
                        {Except[Null], _Real}, {"High pH ("<>ToString[highTargetpH]<>") Standard", highStandardButton},
                        {_, _Real}, {"High pH Value", highTargetpH},
                        NullP, Nothing,
                        _, {"High pH Standard", highStandardButton}
                    ],

                    Which[
                        (* If all calibration temperatures are the same, display them in one row. *)
                        EqualQ[
                            Length[DeleteDuplicates @ Cases[{lowTemp, medTemp, highTemp}, TemperatureP]],
                            1
                        ],
                            {"Calibration Temperature", UnitForm[FirstCase[{lowTemp, medTemp, highTemp}, TemperatureP], Brackets -> False]},

                        (* If we for some reason don't have these temperatures, don't display anything temperature related. *)
                        MatchQ[{lowTemp, medTemp, highTemp}, NullP],
                            Nothing,

                        (* Else, display the ones we have in individual rows. *)
                        True,
                            Sequence @@ {
                                If[!NullQ[lowTemp], {"Temperature (Low pH)", UnitForm[lowTemp, Brackets -> False]}, Nothing],
                                If[!NullQ[medTemp], {"Temperature (Medium pH)", UnitForm[medTemp, Brackets -> False]}, Nothing],
                                If[!NullQ[highTemp], {"Temperature (High pH)", UnitForm[highTemp, Brackets -> False]}, Nothing]
                            }
                    ]
                };

                (* Set up the grid and label it. *)
                grid = Grid[Replace[tableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                    Sequence@@gridFormat,
                    ItemSize -> {{All, 28}}
                ];

                (* We only need to add the subtitles e.g. "pH Calibration 1" if there are multiple calibrations. *)
                If[GreaterQ[numberOfCalibrations, 1],
                    Labeled[
                        grid,
                        "pH Calibration "<>ToString[calibrationIndex],
                        Top,
                        LabelStyle -> Directive[Bold, FontFamily -> "Helvetica"]
                    ],
                    grid
                ]
            ]

        ],
        {
            Range[numberOfCalibrations],
            calibrationObjects,
            absoluteSlope,
            pHOffsetValue,
            calibrationObjects /. calibrationProbeRules,
            lowCalBufferButtons,
            medCalBufferButtons,
            highCalBufferButtons,
            lowCalTargetpH,
            medCalTargetpH,
            highCalTargetpH,
            lowCalTemp,
            medCalTemp,
            highCalTemp
        }
    ];

    (* Combine the calibration plots and tables. *)
    calibrationTablesWithPlots = MapThread[
        Function[
            {plot, dataTable},
            Labeled[
                Framed[
                    Column[{If[NullQ[plot], Nothing, plot], dataTable}, Alignment -> Center],
                    FrameStyle -> Lighter[Gray, 0.4]
                ],
                "Calibration Data",
                Top,
                LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
            ]
        ],
        {calibrationPlots, calibrationDataTables}
    ];

    (* Use SlideView if there is more than one calibration to show. *)
    calibrationDataSlides = Which[
        (* If there's exactly one calibration, show it as one table without SlideView. *)
        SameQ[Length[calibrationTablesWithPlots], 1],
            calibrationTablesWithPlots[[1]],
        (* If there are multiple calibrations, use SlideView. *)
        GreaterQ[Length[calibrationTablesWithPlots], 1],
            SlideView[
                calibrationTablesWithPlots,
                AppearanceElements -> {"FirstSlide", "PreviousSlide", "NextSlide", "LastSlide", "SlideNumber", "SlideTotal"},
                ControlPlacement -> {Top, Center},
                FrameMargins -> 10
            ],
        (* Failsafe in case there are no calibrations for some reason. *)
        True,
            {}
    ];

    (* Make some buttons for the verification standaard which we will use in verification and overall summary tables. *)
    (* Run NamedObject on the relevant objects. *)
    {
        standardObjectNamed,
        standardModelNamed,
        washSolutionObjectNamed,
        washSolutionModelNamed
    } = NamedObject[{
        verificationStandard,
        verificationStandardModel,
        verificationStandardWashSolution,
        verificationStandardWashSolutionModel
    }];

    (* Make a button for the verification standard and the wash solution, displaying the Model in the ToolTip if available. *)
    verificationStandardButton = If[MatchQ[standardModelNamed, ObjectP[Model[Sample]]],
        customButton[standardObjectNamed,
            CopyContent -> standardObjectNamed,
            Tooltip -> Column[{ToString[standardModelNamed], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]
        ],
        standardObjectNamed
    ];
    
    (* There should only be one set of data for the verification standard. Generate a plot and table for this if verification was performed. *)
    verificationPlotAndTable = If[!MatchQ[verificationStandard, ObjectP[{Object[Sample], Model[Sample]}]],
        Null,
        Module[
            {acceptedVerificationRange, verificationPlot, verificationStandardWashSolutionButton, tableContent, formattedVerificationTable},

            (* Get the difference between the min and max verification pH allowed. *)
            acceptedVerificationRange = maxVerificationStandardpH - minVerificationStandardpH;

            (* Generate the plot. The input is {Null} because the type of chart we're making here isn't really a bar chart *)
            (* and there doesn't seem to be a better alternative function to use. Use Prolog and Epilog to plot the data. *)
            verificationPlot = Column[
                {
                    EmeraldBarChart[
                        {Null},
                        BarOrigin -> Left,
                        PlotRange -> {{minVerificationStandardpH - acceptedVerificationRange, maxVerificationStandardpH + acceptedVerificationRange}, {-1.0, 1.0}},
                        AspectRatio -> 9/40,
                        Prolog -> {
                            {$AcceptableRangeColor, Opacity[0.4], Rectangle[{minVerificationStandardpH, -100}, {maxVerificationStandardpH, 100}]},
                            Style[Text[UnitForm[4. Millivolt, Brackets -> False]<>" Offset", {7.0, 7}], Black]
                        },
                        Epilog -> {
                            {$ExperimentalResultColor, Thickness[0.0125], Line[{{verificationStandardpH[[1]], -1.0}, {verificationStandardpH[[1]], 1.0}}]}
                        },
                        FrameTicksStyle -> Directive[Black, FontFamily -> "Helvetica", 13, FontWeight -> Plain],
                        Frame -> True,
                        ImagePadding -> 22,
                        ChartStyle -> $ExperimentalResultColor,
                        ImageSize -> 525
                    ],
                    Style["pH", FontWeight -> Plain, FontFamily -> "Helvetica"],
                    " ",
                    SwatchLegend[{$ExperimentalResultColor, $AcceptableRangeColor, Opacity[0.4]}, {"Measured pH", "Acceptable pH"}, LegendLayout -> "Row"]
                },
                Alignment -> Center,
                Spacings -> 0
            ];

            (* Make a button for the verification standard, displaying the Model in the ToolTip if available. *)
            verificationStandardWashSolutionButton = Which[
                (* If there isn't a VerificationWashSolution specified, return Null and omit this from the table below. *)
                !MatchQ[washSolutionObjectNamed, ObjectP[]],
                    Null,
                (* If we know the Model, make the fancy button which displays the Model in the ToolTip but copies the object. *)
                MatchQ[washSolutionModelNamed, ObjectP[Model[Sample]]],
                    customButton[washSolutionObjectNamed,
                        CopyContent -> washSolutionObjectNamed,
                        Tooltip -> Column[{ToString[washSolutionModelNamed], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]
                    ],
                (* Otherwise, use the object or model stored in the VerificationStandardWashSolution field. *)
                True,
                    washSolutionObjectNamed
            ];

            (* Generate the table for the pH verification according to the available information. *)
            tableContent = {
                {"Verification Standard", verificationStandardButton},
                If[!NullQ[verificationStandardWashSolutionButton], {"Verification Wash Solution", verificationStandardWashSolutionButton}, Nothing],
                If[NumericQ[minVerificationStandardpH], {"Minimum Verification pH", minVerificationStandardpH}, Nothing],
                If[NumericQ[maxVerificationStandardpH], {"Maximum Verification pH", maxVerificationStandardpH}, Nothing],
                If[MemberQ[verificationStandardpH, _Real], {"Measured Verification pH", Column[verificationStandardpH]}, Nothing],
                If[MatchQ[verificationDataReferenceTemperature[[1]], TemperatureP], {"Temperature", UnitForm[verificationDataReferenceTemperature[[1]], Brackets -> False]}, Nothing],
                If[MemberQ[verificationStandardData, ObjectP[Object[Data, pH]]], {"Data Object", verificationStandardData[[1]]}, Nothing]
            };

            (* Set up the grid and label it *)
            formattedVerificationTable = Grid[Replace[tableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                Sequence@@gridFormat,
                ItemSize -> {{All, 28}}
            ];

            (* Return the completed plot and table with appropriate labels. *)
            Labeled[
                Framed[
                    Column[{verificationPlot, formattedVerificationTable}, Alignment -> Center],
                    FrameStyle -> Lighter[Gray,0.4]
                ],
                "Verification Data",
                Top,
                LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
            ]
        ]
    ];

    (* Add a data summary tab and show this first. *)
    dataSummary = Module[
        {
            calibrationPassFail, calibrationTableContents, verificationTableContents, sampleDataTableContents,
            calSummary, verSummary, sampleSummary, systemSuitSummaryTables
        },

        (* Add a list for whether the calibration(s) passed system suitability. The most recent one must have or we wouldn't have continued. *)
        calibrationPassFail = MapThread[
            Function[
                {measuredSlope, measuredOffset},
                If[And[
                    MatchQ[measuredSlope, RangeP[minSlope, maxSlope]],
                    MatchQ[measuredOffset, RangeP[minOffset, maxOffset]]
                ],
                    Pass,
                    Fail
                ]
            ],
            {absoluteSlope, pHOffsetValue}
        ];

        (* Build a summary table for the calibration(s). For old protocols we didn't check the slope and offset in the same way, and we can just omit this table. *)
        calibrationTableContents = If[MemberQ[{minSlope, maxSlope, minOffset, maxOffset}, Null],
            Null,
            Prepend[
                Transpose[{
                    If[SameQ[numberOfCalibrations, 1], Nothing, Range[numberOfCalibrations]],
                    ConstantArray[UnitForm[minSlope, Brackets -> False]<>" - "<>UnitForm[maxSlope, Brackets -> False], numberOfCalibrations],
                    ConstantArray[UnitForm[minOffset, Brackets -> False]<>" - "<>UnitForm[maxOffset, Brackets -> False], numberOfCalibrations],
                    UnitForm[absoluteSlope, Brackets -> False],
                    UnitForm[pHOffsetValue, Brackets -> False],
                    calibrationPassFail
                }],
                {If[SameQ[numberOfCalibrations, 1], Nothing, "No."], "Acceptable Slope", "Acceptable Offset", "Slope", "Offset", "Result"}
            ]
        ];

        (* Build a summary table for the verification, including pass/fail, which must have passed for us to move forward. *)
        verificationTableContents = If[MemberQ[verificationStandardData, ObjectP[Object[Data, pH]]],
            {
                {"Standard", "Acceptable pH", "pH", "Result"},
                {
                    verificationStandardButton,
                    ToString[minVerificationStandardpH]<>" - "<>ToString[maxVerificationStandardpH],
                    verificationStandardpH[[1]],
                    If[MatchQ[verificationStandardpH[[1]], RangeP[minVerificationStandardpH, maxVerificationStandardpH]],
                        Pass,
                        Fail
                    ]
                }
            },
            Null
        ];

        (* Build a very basic summary of the sample data. *)
        sampleDataTableContents = Prepend[
            MapThread[
                Function[
                    {index, sample, replicates, pHMean, pHsd},
                    {
                        If[SameQ[Length[splitSamples], 1], Nothing, index],
                        sample,
                        replicates,
                        If[SameQ[replicates, 1],
                            pHMean,
                            ToString[pHMean]<>" \[PlusMinus] "<>ToString[pHsd]
                        ]
                    }
                ],
                {
                    Range[Length[splitSamples]],
                    sampleButtons,
                    numbersOfReplicates,
                    meanpHValues,
                    stdDevpHValues
                }
            ],
            {If[SameQ[Length[splitSamples], 1], Nothing, "No."], "Sample", "Measurements", "pH"}
        ];

        (* Return the summary tables with the desired formatting. *)
        {calSummary, verSummary, sampleSummary} = MapThread[
            Function[
                {contents, title, labelSize},
                If[NullQ[contents],
                    Null,
                    Labeled[
                        Pane[
                            Grid[
                                Replace[contents, {objectValue : ObjectP[] :> customButton[objectValue]}, {2}],
                                Sequence @@ ReplaceRule[gridFormat,
                                    {
                                        Background -> Experiment`Private`tableBackground[Length[contents]],
                                        ItemStyle -> {
                                            {Directive[FontFamily -> "Helvetica"]},
                                            {Directive[Bold, FontFamily -> "Helvetica"], {Directive[FontFamily -> "Helvetica"]}}
                                        },
                                        Alignment -> Left
                                    }
                                ]
                            ],
                            ImageSize -> {Automatic, UpTo[250]},
                            Scrollbars -> Automatic,
                            AppearanceElements -> None
                        ],
                        title,
                        Top,
                        LabelStyle -> Directive[Bold, labelSize, FontFamily -> "Helvetica"]
                    ]
                ]
            ],
            {
                {calibrationTableContents, verificationTableContents, sampleDataTableContents},
                {"Calibration", "Verification", "Sample Data"},
                {Automatic, Automatic, 16}
            }
        ];

        (* Remove any Nulls from the system suit summary. *)
        systemSuitSummaryTables = Cases[{calSummary, verSummary}, Except[Null]];

        (* Separate into system suitability (including calibration and verification) and sample data, then return. *)
        Column[
            {
                If[MatchQ[systemSuitSummaryTables, {}],
                    Nothing,
                    Labeled[
                        Framed[
                            Column[systemSuitSummaryTables, Alignment -> Center, Spacings -> 2],
                            FrameStyle -> Lighter[Gray, 0.4]
                        ],
                        "System Suitability",
                        Top,
                        LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
                    ]
                ],
                sampleSummary
            },
            Spacings -> 3,
            Alignment -> Center
        ]
    ];

    (* Output in TabView form, with separate tabs for the overall Summary, Calibration, Verification, and Samples as applicable. *)
    {
        Column[{
            TabView[
                MapThread[
                    Function[
                        {heading, slides},
                        If[NullQ[slides],
                            Nothing,
                            With[
                                {explicitSlides = slides},
                                heading -> explicitSlides
                            ]
                        ]
                    ],
                    {
                        {"Summary", "Calibration", "Verification", "Samples"},
                        {dataSummary, calibrationDataSlides, verificationPlotAndTable, sampleSlides}
                    }
                ],
                Alignment -> {Center, Top}
            ]
        }]
    }

];

(*karlFischerTitrationPrimaryData*)

Authors[karlFischerTitrationPrimaryData] := {"tyler.pabst"};

karlFischerTitrationPrimaryData[protocol:ObjectP[Object[Protocol, KarlFischerTitration]]] := Module[
    {
        gridFormat, standardPacket, standardDataPackets, standardCoAWaterContents, blankDataPackets, sampleDataPackets,
        samplesInPackets, sampleCoAWaterContents, protocolPacket, streamPackets, procedureEventPackets, technique, temperatures, samplingMethod,
        uniqueTaskIDEventPackets, taskIDs, procedureEventDatesCreated, standardsTable, sampleMeasurementTables, blanksTable, sampleMeasurementSlides
    },

    (* Setup grid formatting options *)
    gridFormat = {
        Background -> Experiment`Private`tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, {Left}}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
        Dividers -> {
            {{Directive[Opacity[0]]}},
            {
                Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]]
                }
            }
        }
    };

    (* Download from the protocol object. *)
    {
        standardPacket,
        standardDataPackets,
        standardCoAWaterContents,
        blankDataPackets,
        sampleDataPackets,
        samplesInPackets,
        sampleCoAWaterContents,
        protocolPacket,
        streamPackets,
        procedureEventPackets
    } = Quiet @ Download[protocol,
        {
            Packet[Standard[Model]],
            Packet[StandardData[{SampleWeight, Titer, WaterContent, SampleAdditionTime}]],
            Standard[Certificates][WaterContent],
            Packet[BlankData[BlankWaterMass, HeadspaceVial]],
            Packet[Data[{SamplesIn, WaterContent, Titer, SamplesIn, Replicates, SampleWeight, SampleAdditionTime}]],
            Packet[SamplesIn[Model]],
            SamplesIn[Certificates][WaterContent],
            Packet[Technique, Temperatures, SamplingMethod],
            Packet[Streams[{Object, StartTime}]],
            Packet[ProcedureLog[{Object, TaskID, DateCreated, EventType}]]
        }
    ];

    (* Get some field values from the protocol packet. *)
    {technique, temperatures, samplingMethod} = Lookup[protocolPacket, {Technique, Temperatures, SamplingMethod}];

    (* Delete duplicate packets by event type; these will be used to generate stream buttons later. *)
    uniqueTaskIDEventPackets = PickList[
        procedureEventPackets,
        Lookup[procedureEventPackets, EventType, Null],
        TaskStart
    ];

    (* Get the task IDs and dates created for the procedure events. *)
    {taskIDs, procedureEventDatesCreated} = Transpose @ Lookup[uniqueTaskIDEventPackets, {TaskID, DateCreated}];

    (* I. Standards *)
    standardsTable = Module[
        {
            weights, titerOrWaterContentValues, meanTiterOrWaterContent, stdDevTiterOrWaterContent, titerOrWaterContentRSD, standardObject,
            standardModel, coaValueRaw, coaValueToUse, percentOfCoAValue, multipleStandardsQ, standardSampleButton, stringReplaceRules,
            standardDataObjects, standardSampleAdditionTime, titerOrWCString, titerOrWCDistribution, standardRedButtonTaskIDP, standardStartTaskPositions,
            standardTaskStartTimes, standardStreamPacketsToUse, standardStreamTuples, standardStreamButtons, standardTableContents
        },

        (* Get the weights and average them. *)
        weights = Round[Lookup[standardDataPackets, SampleWeight], 0.01 Milligram];

        (* Get the titer (Volumetric) or water content (Coulometric) for the standard measurements. *)
        titerOrWaterContentValues = If[MatchQ[technique, Volumetric],
            Round[Mean /@ Lookup[standardDataPackets, Titer], 0.001 Milligram / Milliliter],
            Round[Percent * Unitless[Mean /@ Lookup[standardDataPackets, WaterContent]], 0.001 Percent]
        ];

        (* Get the mean and RSD for these values. *)
        meanTiterOrWaterContent = Mean[titerOrWaterContentValues];
        stdDevTiterOrWaterContent = N @ SignificantFigures[StandardDeviation[titerOrWaterContentValues], 1];
        titerOrWaterContentRSD = Round[100 Percent * (stdDevTiterOrWaterContent / meanTiterOrWaterContent), 0.01 Percent];

        (* Lookup the standard object and model. *)
        {standardObject, standardModel} = Lookup[standardPacket, {Object, Model}];

        (* pull out the certificate of analysis value and compare the water content with the coa value *)
        coaValueRaw = FirstCase[standardCoAWaterContents, MassPercentP, "N/A"];
        coaValueToUse = If[MassPercentQ[coaValueRaw], Percent * Unitless[coaValueRaw], "N/A"];
        percentOfCoAValue = If[PercentQ[coaValueToUse] && MatchQ[technique, Coulometric],
            Round[100 Percent * meanTiterOrWaterContent / coaValueToUse, 0.1 Percent],
            "N/A"
        ];

        (* Set a flag for whether there are mutliple standard measurements. *)
        multipleStandardsQ = GreaterQ[Length[standardDataPackets], 1];

        (* Make clickable buttons for the standard sample, standard data, masses, and water contents/titers. *)
        standardSampleButton = If[MatchQ[standardModel, ObjectP[Model[Sample]]],
            customButton[
                standardObject,
                CopyContent -> standardObject,
                Tooltip -> Column[{ToString[NamedObject[standardModel]], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]
            ],
            standardObject
        ];

        (* UnitForm likes to use the unit g/L which is the same as mg/mL but the latter is preferred for reporting the KF results. *)
        (* Set up StringReplace rules that corrects this. Note the use of [InvisibleSpace] in some but not all unit strings. *)
        stringReplaceRules = {"g\[InvisibleSpace]/\[InvisibleSpace]L" -> "mg/mL", "g/L" -> "mg/mL"};

        (* Get the Data Objects and SampleAdditionTime from the standard data packets. *)
        {standardDataObjects, standardSampleAdditionTime} = Transpose @ Lookup[standardDataPackets, {Object, SampleAdditionTime}, Null];

        (* Use the "Titer" label for Volumetric and "Water Content" for Coulometric. *)
        titerOrWCString = technique /. {Volumetric -> "Titer", Coulometric -> "Water Content"};

        (* Format the titer/water content distribution appropriately according to the units. *)
        titerOrWCDistribution = Module[
            {percentFormBool},

            (* If this is a percentage value, feed PercentForm -> True into unitFormDistribution. *)
            percentFormBool = PercentQ[meanTiterOrWaterContent];

            If[!multipleStandardsQ,
                Null,
                Module[
                    {distributionString},
                    distributionString = unitFormDistribution[NormalDistribution[meanTiterOrWaterContent, stdDevTiterOrWaterContent], PercentForm -> percentFormBool, Resolution -> 0.001];
                    StringReplace[distributionString, stringReplaceRules]
                ]
            ]
        ];

        (* Make a pattern for the start task IDs for the "Big Red Button" tasks related to the standards. *)
        standardRedButtonTaskIDP = Alternatives @@ {
            "7f5ad306-64a1-4898-abff-f05696272c54", (* "KarlFischerTitration Add Liquid Standard to Reaction Vessel" *)
            "6b35d3f4-baab-4fec-93f3-4f3091f238ca", (* "KarlFischerTitration Transfer Liquid Standard Into Volumetric Reaction Vessel" *)
            "76de2be5-b4a0-44c8-94be-66ce36003f0c", (* "KarlFischerTitration Transfer Solid Standard Into Volumetric Reaction Vessel" *)
            "b7215b11-f0ab-47b7-b7a9-8620b0774134" (* "KarlFischerTitration Measure and Add Solid Standard to Reaction Vessel" *)
        };

        (* Get the positions of the start and end tasks in the procedure event list. *)
        standardStartTaskPositions = Flatten[Position[taskIDs, standardRedButtonTaskIDP]];

        (* Use these values to find the start and end dates for the QS step. *)
        standardTaskStartTimes = procedureEventDatesCreated[[standardStartTaskPositions - 1]];

        (* Find out which stream to use for WatchProtocol. *)
        standardStreamPacketsToUse = Flatten @ Module[
            {startTimesOfCorrectStream},
            startTimesOfCorrectStream = Map[Max @ Cases[Lookup[streamPackets, StartTime], LessP[#]]&, standardTaskStartTimes];
            Map[
                Function[
                    {startTimeOfCorrectStream},
                    PickList[
                        streamPackets,
                        Lookup[streamPackets, StartTime, Null],
                        startTimeOfCorrectStream
                    ]
                ],
                startTimesOfCorrectStream
            ]
        ];

        (* Get the start time of the quant wash step in terms of unitless seconds from the start of the appropriate stream. *)
        standardStreamTuples = If[MatchQ[standardStreamPacketsToUse, {}],
            ConstantArray[{Null, Null}, Length[standardDataObjects]],
            MapThread[
                Function[
                    {taskStartTime, streamPacket},
                    {
                        Lookup[streamPacket /. Null -> <||>, Object, Null],
                        Round[Unitless[Convert[taskStartTime - Lookup[streamPacket, StartTime], 1 Second]]]
                    }
                ],
                {standardTaskStartTimes, standardStreamPacketsToUse}
            ]
        ];

        (* Make the stream buttons for the big red button events. *)
        standardStreamButtons = MapThread[
            Function[
                {streamObject, timeArg},
                If[NullQ[streamObject],
                    Null,
                    With[
                        {
                            playButtonGraphic = Show[$PlayButtonGraphic, ImageSize -> 12],
                            explicitStreamObject = streamObject,
                            explicitTimeArg = timeArg
                        },
                        Button[
                            Tooltip[playButtonGraphic, "Play Stream"],
                            WatchProtocol[explicitStreamObject, explicitTimeArg],
                            Method -> "Queued",
                            Appearance -> "Frameless"
                        ]
                    ]
                ]
            ],
            Transpose[standardStreamTuples]
        ];

        (* Assemble the contents of the standard tables. *)
        standardTableContents = {
            If[multipleStandardsQ,
                Module[
                    {axisLabelString},

                    axisLabelString = StringJoin[
                        titerOrWCString,
                        " (",
                        StringSplit[UnitForm[titerOrWaterContentValues[[1]], Metric -> False, Brackets -> False]][[-1]],
                        ")"
                    ];

                    {
                        Column[
                            {
                                EmeraldBoxWhiskerChart[
                                    titerOrWaterContentValues,
                                    BarOrigin -> Left,
                                    AspectRatio -> 9/40,
                                    FrameTicksStyle -> Directive[Black, FontFamily -> "Helvetica", 12, FontWeight -> Plain],
                                    Frame -> True,
                                    FrameUnits -> None,
                                    ImagePadding -> 22,
                                    ChartStyle -> $ExperimentalResultColor,
                                    ImageSize -> 525
                                ],
                                Style[axisLabelString, FontWeight -> Bold, FontFamily -> "Helvetica"]
                            },
                            Alignment -> Center,
                            Spacings -> 0
                        ],
                        SpanFromLeft
                    }
                ],
                Nothing
            ],

            {"Standard", standardSampleButton},

            (* Temperature is always Ambient for Volumetric, so no need to show it. *)
            Which[
                MatchQ[technique, Volumetric],
                    Nothing,
                TemperatureQ[First[temperatures]],
                    {"Temperature", UnitForm[First[temperatures], Brackets -> False]},
                True,
                    {"Temperature", First[temperatures]}
            ],

            If[multipleStandardsQ,
                Sequence @@ {
                    {titerOrWCString, titerOrWCDistribution},
                    {titerOrWCString<>" RSD", UnitForm[titerOrWaterContentRSD, Brackets -> False]}
                },
                Sequence @@ {
                    {"Data Object", standardDataObjects},
                    {"Mass", weights[[1]]},
                    If[NullQ[standardSampleAdditionTime],
                        Nothing,
                        {"Sample Addition Time", UnitForm[Round[standardSampleAdditionTime[[1]], 1 Second], Metric -> False, Brackets -> False]}
                    ],
                    {titerOrWCString, meanTiterOrWaterContent}
                }
            ],

            If[PercentQ[coaValueToUse] && MatchQ[technique, Coulometric],
                Sequence @@ {
                    {"Water Content, CoA", UnitForm[Percent * Unitless[coaValueToUse], Brackets -> False]},
                    {"Percent of CoA Value", UnitForm[percentOfCoAValue, Brackets -> False]}
                },
                Nothing
            ],

            (* If there is just one stream, it gets its own line in the main table. *)
            If[MatchQ[standardStreamButtons, {_Button}],
                {"Stream", standardStreamButtons[[1]]},
                Nothing
            ],

            (* Make a smaller table with data from replicate measurements. *)
            If[multipleStandardsQ,
                {
                    "Measurement Data",
                    Module[
                        {additionTimesQ, streamsQ, miniTableContent},

                        (* Determine whether we have any addition times or streams to show in the table. *)
                        additionTimesQ = MemberQ[standardSampleAdditionTime, TimeP];
                        streamsQ = MemberQ[standardStreamButtons, _Button];

                        miniTableContent = Prepend[
                            MapThread[
                                Function[
                                    {index, dataObject, waterContent, mass, additionTime, streamButton},

                                    {
                                        customButton[
                                            Style[index, Bold, FontFamily -> "Helvetica"],
                                            CopyContent -> dataObject,
                                            Tooltip -> "Click to Copy "<>ObjectToString[dataObject]
                                        ],
                                        UnitForm[waterContent, Brackets -> False, Metric -> False],
                                        UnitForm[mass, Brackets -> False],
                                        Which[
                                            !additionTimesQ, Nothing,
                                            NullQ[additionTime], "N/A",
                                            True, UnitForm[Round[additionTime, 1 Second], Metric -> False, Brackets -> False]
                                        ],
                                        Which[
                                            !streamsQ, Nothing,
                                            NullQ[streamButton], "N/A",
                                            True, streamButton
                                        ]
                                    }
                                ],
                                {
                                    Range[Length[standardDataObjects]],
                                    standardDataObjects,
                                    titerOrWaterContentValues,
                                    weights,
                                    standardSampleAdditionTime,
                                    standardStreamButtons
                                }
                            ],
                            Style[#, Bold, FontFamily -> "Helvetica"]& /@ {
                                "Replicate",
                                titerOrWCString,
                                "Mass",
                                If[additionTimesQ, "Addition Time", Nothing],
                                If[streamsQ, "Stream", Nothing]
                            }
                        ];

                        Grid[Replace[miniTableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                            Sequence @@ ReplaceRule[gridFormat, Alignment -> Center],
                            ItemSize -> {{All, UpTo[25]}}
                        ]
                    ]
                },
                Nothing
            ]

        };

        Labeled[
            Grid[Replace[standardTableContents, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                Sequence @@ gridFormat,
                ItemSize -> {{All, UpTo[28]}}
            ],
            "Standard Data",
            Top,
            LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
        ]

    ];

    (* II. Samples *)
    sampleMeasurementTables = Module[
        {
            sampleToCertificateRules, sampleDataPacketsWithTemps, dataWithReplicates, replicateGroups, coaForReplicates, meansForReplicates,
            stdevsForReplicates, rsdsForReplicates, percentOfCoAValues, massAndWaterContentPerReplicateGroup, samplesInPacketsPerGroup,
            numbersOfReplicates, replicatesQs, sampleButtons, dataObjects, sampleMasses, waterContentses, waterContentsDistributionsOrSingleValues,
            sampleAdditionTimeses, sampleRedButtonTaskIDP, sampleStartTaskPositions, sampleTaskStartTimes, sampleStreamPacketsToUse,
            sampleStreamTuples, sampleStreamButtons, sampleStreamButtonsUnflattened
        },

        (* make rules between the samples and their CoA values *)
        sampleToCertificateRules = MapThread[
            #1 -> FirstOrDefault[#2]&,
            {Lookup[samplesInPackets, Object], sampleCoAWaterContents}
        ];

        (* Append the Temperature from the protocol packets to the data packets. *)
        sampleDataPacketsWithTemps = MapThread[
            Append[#1, <|Temperature -> #2|>]&,
            {sampleDataPackets, temperatures}
        ];

        (* group the data packets by replicates; going to have redundancies though so get them together *)
        dataWithReplicates = Map[
            With[
                {objs = Flatten[{Lookup[#, Object], Download[Lookup[#, Replicates], Object]}]},
                Cases[sampleDataPacketsWithTemps, ObjectP[objs]]
            ]&,
            sampleDataPacketsWithTemps
        ];
        replicateGroups = DeleteDuplicatesBy[dataWithReplicates, Sort];

        (* pull out the replicate CoA values, if they exist *)
        coaForReplicates = Map[
            Download[Lookup[#, SamplesIn][[1]], Object] /. sampleToCertificateRules &,
            replicateGroups[[All, 1]]
        ];

        (* get the means and RSDs for all the replicates *)
        {meansForReplicates, stdevsForReplicates} = Transpose@Map[
            With[{noDistributionValues = Mean /@ Lookup[#, WaterContent]},
                {
                    Percent * Unitless[Mean[noDistributionValues]],
                    Percent * SignificantFigures[Unitless[StandardDeviation[noDistributionValues]], 1]
                }
            ]&,
            replicateGroups
        ];

        rsdsForReplicates = MapThread[
            Round[100 Percent * #2 / #1, 0.001 Percent]&,
            {meansForReplicates, stdevsForReplicates}
        ];

        (* Express the ratio of the mean to the CoA value as a percent. *)
        percentOfCoAValues = MapThread[
            If[MassPercentQ[#1],
                Round[100 Percent * (Unitless[#2] / Unitless[#1]), 0.1 Percent],
                Null
            ]&,
            {coaForReplicates, meansForReplicates}
        ];

        (* Get the mass and water content per replicate group. *)
        massAndWaterContentPerReplicateGroup = Map[
            Function[
                {dataPacketsPerRep},
                Transpose[{
                    Round[Lookup[dataPacketsPerRep, SampleWeight], 10 Microgram],
                    (Percent * Unitless[NumberForm[Mean[#], {Infinity, 3}]]) & /@ Lookup[dataPacketsPerRep, WaterContent]
                }]
            ],
            replicateGroups
        ];

        (* get the samples in packet per replicate group *)
        samplesInPacketsPerGroup = Map[
            FirstCase[samplesInPackets, ObjectP[Lookup[#, SamplesIn][[1]]]]&,
            replicateGroups
        ];

        (* Get the number of replicate measurements per sample and set a list of Booleans for whether there are replicates. *)
        numbersOfReplicates = Length /@ replicateGroups;
        replicatesQs = Map[GreaterQ[#, 1]&, numbersOfReplicates];

        (* Generate a button for the sample which shows the model in the tooltip, if applicable. *)
        (* Make clickable sample, container, instrument, and probe buttons which display the model in the tooltip. *)
        sampleButtons = Map[
            Function[
                {samplesInPacket},
                If[MatchQ[Lookup[samplesInPacket, Model], ObjectP[Model[Sample]]],
                    customButton[
                        Lookup[samplesInPacket, Object],
                        CopyContent -> Lookup[samplesInPacket, Object],
                        Tooltip -> Column[{ToString[NamedObject[Lookup[samplesInPacket, Model]]], "Click to copy Object[Sample]"}, Alignment -> {Center, Baseline}]
                    ],
                    Lookup[samplesInPacket, Object]
                ]
            ],
            samplesInPacketsPerGroup
        ];

        (* Store all of the water contents values. Also store a unitless version to make box and whisker plots with. *)
        waterContentses = massAndWaterContentPerReplicateGroup[[All, All, -1]];

        (* Make a list of formatted waters contents distributions (if there are multiple measurements for the sample) or just the lone water contents value. *)
        waterContentsDistributionsOrSingleValues = MapThread[
            Function[
                {replicatesQ, meanWaterContentByGroup, stdDevWaterContentByGroup, waterContentsValueByGroup},
                If[replicatesQ,
                    unitFormDistribution[NormalDistribution[meanWaterContentByGroup, stdDevWaterContentByGroup], PercentForm -> True, Resolution -> 0.001],
                    waterContentsValueByGroup
                ]
            ],
            {replicatesQs, meansForReplicates, stdevsForReplicates, waterContentses}
        ];

        (* Get the SampleAdditionTime from the sample data packets. This will be a flat list so we have to unflatten. *)
        sampleAdditionTimeses = Unflatten[Lookup[sampleDataPackets, SampleAdditionTime, Null], waterContentses];

        (* Get the data objects and the sample masses. *)
        dataObjects = Lookup[#, Object]& /@ replicateGroups;
        sampleMasses = massAndWaterContentPerReplicateGroup[[All, All, 1]];

        (* Make a pattern for the start task IDs for the "Big Red Button" tasks related to the samples. *)
        sampleRedButtonTaskIDP = Alternatives @@ {
            "6d36224f-84ce-4fff-a675-0d79b9dfc409", (* "KarlFischerTitration Add Liquid Sample to Reaction Vessel" *)
            "8fe68bf6-a470-41e2-98d2-cb72c792e918", (* "KarlFischerTitration Transfer Liquid Sample into Volumetric Reaction Vessel" *)
            "fe99187f-0431-49b9-8096-383b572c1d2b", (* "KarlFischerTitration Transfer Solid into Volumetric Reaction Vessel" *)
            "3ce33837-0649-40cd-9cee-0b659613a12e"  (* "KarlFischerTitration Measure and Add Solid Sample to Reaction Vessel" *)
        };

        (* Get the positions of the start and end tasks in the procedure event list. *)
        sampleStartTaskPositions = Flatten[Position[taskIDs, sampleRedButtonTaskIDP]];

        (* Use these values to find the start and end dates for the QS step. *)
        sampleTaskStartTimes = procedureEventDatesCreated[[sampleStartTaskPositions - 1]];

        (* Find out which stream to use for WatchProtocol. *)
        sampleStreamPacketsToUse = Flatten @ Module[
            {startTimesOfCorrectStream},
            startTimesOfCorrectStream = Map[Max @ Cases[Lookup[streamPackets, StartTime], LessP[#]]&, sampleTaskStartTimes];
            Map[
                Function[
                    {startTimeOfCorrectStream},
                    PickList[
                        streamPackets,
                        Lookup[streamPackets, StartTime, Null],
                        startTimeOfCorrectStream
                    ]
                ],
                startTimesOfCorrectStream
            ]
        ];

        (* Get the start time of the quant wash step in terms of unitless seconds from the start of the appropriate stream. *)
        sampleStreamTuples = If[MatchQ[sampleStreamPacketsToUse, {}],
            {{}, {}},
            MapThread[
                Function[
                    {taskStartTime, streamPacket},
                    {
                        Lookup[streamPacket /. Null -> <||>, Object, Null],
                        Round[Unitless[Convert[taskStartTime - Lookup[streamPacket, StartTime], 1 Second]]]
                    }
                ],
                {sampleTaskStartTimes, sampleStreamPacketsToUse}
            ]
        ];

        (* Make the stream buttons for the big red button events. *)
        sampleStreamButtons = MapThread[
            Function[
                {streamObject, timeArg},
                If[NullQ[streamObject],
                    Null,
                    With[
                        {
                            playButtonGraphic = Show[$PlayButtonGraphic, ImageSize -> 12],
                            explicitStreamObject = streamObject,
                            explicitTimeArg = timeArg
                        },
                        Button[
                            Tooltip[playButtonGraphic, "Play Stream"],
                            WatchProtocol[explicitStreamObject, explicitTimeArg],
                            Method -> "Queued",
                            Appearance -> "Frameless"
                        ]
                    ]
                ]
            ],
            Transpose[sampleStreamTuples]
        ];

        (* Unflatten the sample stream buttons so that we can place them on the appropriate sample slides. *)
        sampleStreamButtonsUnflattened = If[NullQ[sampleStreamButtons],
            ConstantArray[Null, Length[waterContentses]],
            Unflatten[sampleStreamButtons, waterContentses]
        ];

        (* Generate the tables for the sample measurements according to the available information. *)
        MapThread[
            Function[
                {
                    replicatesQ,
                    unitlessWaterContents,
                    sampleButton,
                    dataObject,
                    mass,
                    sampleAdditionTimes,
                    replicateGroupPackets,
                    waterContentDistribution,
                    rsdWaterContentByGroup,
                    coAValue,
                    percentOfCoA,
                    streamButtonsBySample
                },

                Module[
                    {sampleTableContents},

                    sampleTableContents = {
                        If[replicatesQ,
                            {
                                Column[
                                    {
                                        EmeraldBoxWhiskerChart[
                                            ToExpression[ToString[#]]& /@ unitlessWaterContents,
                                            BarOrigin -> Left,
                                            AspectRatio -> 9/40,
                                            FrameTicksStyle -> Directive[Black, FontFamily -> "Helvetica", 12, FontWeight -> Plain],
                                            Frame -> True,
                                            FrameUnits -> None,
                                            ImagePadding -> 22,
                                            ChartStyle -> $ExperimentalResultColor,
                                            ImageSize -> 525
                                        ],
                                        Style["Water Content (%)", FontWeight -> Bold, FontFamily -> "Helvetica"]
                                    },
                                    Alignment -> Center,
                                    Spacings -> 0
                                ],
                                SpanFromLeft
                            },
                            Nothing
                        ],

                        {"Sample", sampleButton},
                        {"Technique", technique},
                        {"Sampling Method", samplingMethod},

                        (* Temperature is always ambient for Volumetric, so no need to show it. *)
                        Which[
                            MatchQ[technique, Volumetric],
                                Nothing,
                            TemperatureQ[First @ Lookup[replicateGroupPackets, Temperature]],
                                {"Temperature", UnitForm[First @ Lookup[replicateGroupPackets, Temperature], Brackets -> False]},
                            True,
                                {"Temperature", First @ Lookup[replicateGroupPackets, Temperature]}
                        ],

                        If[replicatesQ,
                            Sequence @@ {
                                {"Water Content", waterContentDistribution},
                                {"Water Content RSD", UnitForm[rsdWaterContentByGroup, Brackets -> False]}
                            },
                            Sequence @@ {
                                {"Data Object", dataObject[[1]]},
                                {"Mass", mass[[1]]},
                                If[NullQ[sampleAdditionTimes],
                                    Nothing,
                                    {"Sample Addition Time", sampleAdditionTimes[[1]]}
                                ],
                                {"Water Content", ToString[unitlessWaterContents[[1]]]<>" %"}
                            }
                        ],

                        If[QuantityQ[coAValue],
                            Sequence @@ {
                                {"Water Content, CoA", UnitForm[Percent * Unitless[coAValue], Brackets -> False]},
                                {"Percent of CoA Value", UnitForm[percentOfCoA, Brackets -> False]}
                            },
                            Nothing
                        ],

                        (* If there is just one stream, it gets its own line in the main table. *)
                        If[MatchQ[streamButtonsBySample, {_Button}],
                            {"Stream", streamButtonsBySample[[1]]},
                            Nothing
                        ],

                        (* Make a smaller table with data from replicate measurements. *)
                        If[replicatesQ,
                            {
                                "Measurement Data",
                                Module[
                                    {additionTimesQ, streamsQ, miniTableContent},

                                    (* Determine whether we have any addition times or streams to show in the table. *)
                                    additionTimesQ = MemberQ[sampleAdditionTimes, TimeP];
                                    streamsQ = MemberQ[streamButtonsBySample, _Button];

                                    miniTableContent = Prepend[
                                        MapThread[
                                            Function[
                                                {index, data, wc, massForMiniTable, additionTime, streamButton},

                                                {
                                                    customButton[
                                                        Style[index, Bold, FontFamily -> "Helvetica"],
                                                        CopyContent -> data,
                                                        Tooltip -> "Click to Copy "<>ObjectToString[data]
                                                    ],
                                                    ToString[wc]<>" %",
                                                    UnitForm[massForMiniTable, Brackets -> False],
                                                    Which[
                                                        !additionTimesQ, Nothing,
                                                        NullQ[additionTime], "N/A",
                                                        True, UnitForm[Round[additionTime, 1 Second], Metric -> False, Brackets -> False]
                                                    ],
                                                    Which[
                                                        !streamsQ, Nothing,
                                                        NullQ[streamButton], "N/A",
                                                        True, streamButton
                                                    ]
                                                }
                                            ],
                                            {
                                                Range[Length[dataObject]],
                                                dataObject,
                                                unitlessWaterContents,
                                                mass,
                                                sampleAdditionTimes,
                                                streamButtonsBySample
                                            }
                                        ],
                                        Style[#, Bold, FontFamily -> "Helvetica"]& /@ {
                                            "Replicate",
                                            "Water Content",
                                            "Mass",
                                            If[additionTimesQ, "Addition Time", Nothing],
                                            If[streamsQ, "Stream", Nothing]
                                        }
                                    ];

                                    Grid[Replace[miniTableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                                        Sequence @@ ReplaceRule[gridFormat, Alignment -> Center],
                                        ItemSize -> {{All, UpTo[25]}}
                                    ]
                                ]
                            },
                            Nothing
                        ]


                    };

                    (* Set up the grid and label it *)
                    Labeled[
                        Grid[Replace[sampleTableContents, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                            Sequence @@ gridFormat,
                            ItemSize -> {{All, UpTo[28]}}
                        ],
                        "Sample Data",
                        Top,
                        LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
                    ]
                ]
            ],
            {
                replicatesQs,
                Unitless /@ waterContentses,
                sampleButtons,
                dataObjects,
                sampleMasses,
                sampleAdditionTimeses,
                replicateGroups,
                waterContentsDistributionsOrSingleValues,
                rsdsForReplicates,
                coaForReplicates,
                percentOfCoAValues,
                sampleStreamButtonsUnflattened
            }
        ]
    ];

    (* III. Blanks *)
    blanksTable = If[MatchQ[blankDataPackets, {}],
        Null,
        Module[
            {
                blankWaterMassDistribution, blankVials, blankDataObjects,
                blankWaterMass, multipleBlanksQ, averageWaterMass, stdDevWaterMass,
                waterMassRSD, blanksBoxWhiskerChart, miniTableContent, blanksTableContents
            },

            (* Get the blank info from the blank data packets. *)
            {blankWaterMassDistribution, blankVials, blankDataObjects} = Transpose @ Lookup[blankDataPackets, {BlankWaterMass, HeadspaceVial, Object}];

            (* remove the distributions from the water mass *)
            blankWaterMass = Round[Mean /@ blankWaterMassDistribution, 0.001 Microgram];

            (* set a flag indicating whether we have multiple blanks. *)
            multipleBlanksQ = GreaterQ[Length[blankWaterMass], 1];

            (* get the average and RSD of the empty containers *)
            averageWaterMass = Round[Mean[blankWaterMass], 0.01 Microgram];
            stdDevWaterMass = Round[StandardDeviation[blankWaterMass], 0.001 Microgram];
            waterMassRSD = Round[100 Percent * StandardDeviation[blankWaterMass]/averageWaterMass, 0.01 Percent];

            (* If we have multiple blanks, make a box and whisker chart. *)
            blanksBoxWhiskerChart = If[multipleBlanksQ,
                {
                    Column[
                        {
                            EmeraldBoxWhiskerChart[
                                blankWaterMass,
                                BarOrigin -> Left,
                                AspectRatio -> 9/40,
                                FrameTicksStyle -> Directive[Black, FontFamily -> "Helvetica", 12, FontWeight -> Plain],
                                Frame -> True,
                                FrameUnits -> None,
                                ImagePadding -> 22,
                                ChartStyle -> $ExperimentalResultColor,
                                ImageSize -> 525
                            ],
                            Style["Mass of Water in Empty Vial "<>Last[StringSplit[UnitForm[averageWaterMass]]], FontWeight -> Bold, FontFamily -> "Helvetica"]
                        },
                        Alignment -> Center,
                        Spacings -> 0
                    ],
                    SpanFromLeft
                },
                Nothing
            ];

            (* If there are multiple blanks, generate a table with index-matched data. *)
            miniTableContent = If[multipleBlanksQ,
                Prepend[
                    MapThread[
                        Function[
                            {index, data, vial, waterMass},

                            {
                                customButton[
                                    Style[index, Bold, FontFamily -> "Helvetica"],
                                    CopyContent -> data,
                                    Tooltip -> "Click to Copy "<>ObjectToString[data]
                                ],
                                vial,
                                UnitForm[waterMass, Brackets -> False]
                            }
                        ],
                        {
                            Range[Length[blankDataObjects]],
                            blankDataObjects,
                            Download[blankVials, Object],
                            blankWaterMass
                        }
                    ],
                    Style[#, Bold, FontFamily -> "Helvetica"]& /@ {"Replicate", "Blank Vial", "Mass of Water"}
                ],
                Null
            ];

            (* Assemble all the info for the blanks table. If we have exactly one blank, we'll use a sub-table generated above for most of the info. *)
            blanksTableContents = If[NullQ[miniTableContent],
                Sequence @@ {
                    {"Blank Vial", blankVials[[1]]},
                    {"Data", blankDataObjects[[1]][Object]},
                    {"Mass of Water", averageWaterMass}
                },
                {
                    {"Mass of Water", unitFormDistribution[NormalDistribution[averageWaterMass, stdDevWaterMass], Resolution -> 0.001 Microgram]},
                    {"Mass of Water RSD", UnitForm[waterMassRSD, Brackets -> False]},
                    {
                        "Measurement Data",
                        Grid[Replace[miniTableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                            Sequence @@ ReplaceRule[gridFormat, Alignment -> Center],
                            ItemSize -> {{All, UpTo[25]}}
                        ]
                    }
                }
            ];

            (* Set up the grid and label it *)
            Labeled[
                Grid[Replace[Join[{blanksBoxWhiskerChart}, blanksTableContents], {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                    Sequence @@ gridFormat,
                    ItemSize -> {{All, UpTo[28]}}
                ],
                "Blank Data",
                Top,
                LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
            ]
        ]
    ];

    (* Get the sample tables into slideview form. *)
    sampleMeasurementSlides = With[
        {explicitSampleTables = sampleMeasurementTables},
        If[GreaterQ[Length[explicitSampleTables], 1],
            SlideView[explicitSampleTables, AppearanceElements -> {"FirstSlide", "PreviousSlide", "NextSlide", "LastSlide", "SlideNumber", "SlideTotal"}],
            explicitSampleTables[[1]]
        ]
    ];

    (* Generate our dynamic output in the order Standards - Samples - Blanks. *)
    With[
        {
            explicitStandardTable = standardsTable,
            explicitSampleSlides = sampleMeasurementSlides,
            explicitBlanksTable = blanksTable
        },
        List[
            Column[{
                TabView[
                    MapThread[
                        Function[
                            {heading, content},
                            If[NullQ[content],
                                Nothing,
                                heading -> content
                            ]
                        ],
                        {
                            {"Standards", "Samples", "Blanks"},
                            {explicitStandardTable, explicitSampleSlides, explicitBlanksTable}
                        }
                    ],
                    Alignment -> {Center, Top}
                ]
            }]
        ]
    ]

];

(*mspPrimaryData*)

Authors[mspPrimaryData]:={"melanie.reschke"};

mspPrimaryData[protocol:ObjectP[Object[Protocol, ManualSamplePreparation]]] := spPrimaryData[protocol];

(*spPrimaryData*)

Authors[spPrimaryData]:={"melanie.reschke"};

spPrimaryData[protocol:ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]] := Module[
    (* local variable *)
    {
        mspPacketFields, subprotocolPacketFields, mspPacket,
        optimizedUnitOpPackets, calculatedUnitOpPackets, outputUnitOpPackets, unitOpSubprotocolPackets,
        deepUnitOpSubprotocolPackets, containerLinkInputsPackets, containerLinkModelInputsPackets,
        instrumentPackets, instrumentModelPackets, ftvSubprotocolRemakeIndices,
        remakeCorrectedOptimizedUOPackets, remakeCorrectedCalculatedUOPackets, remakeCorrectedOutputUOPackets, remakeCorrectedUOSubprotocolPackets,
        remakeCorrectedContainerLinkInputsPackets, remakeCorrectedContainerLinkModelInputsPackets, remakeCorrectedInstrumentPackets, remakeCorrectedInstrumentModelPackets,
        unitOpSubprotocolPacketsAssocs, infoTables, dataPlots, unitOperationLaterRedoneMessages, splittingCriteriaFunction, splitOutputUnitOperations,
        splitInfoTables, splitDataPlots, splitSubprotocols, splitUnitOperationLaterRedoneMessages, outputUnitOpTypeList, unitOpIconsList, panelContentRules
    },

    (* Set fields to download from the MSP protocol and from the subprotocols in packets. *)
    mspPacketFields = Packet[UnresolvedUnitOperationInputs, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions, OutputUnitOperations];
    subprotocolPacketFields = Packet[
        SamplesIn,
        UnresolvedOptions,
        ResolvedOptions,
        OutputUnitOperations,
        ParentProtocol,
        Status,
        (* Transfer, aliquot, etc fields *)
        PercentTransferred,
        Amounts,
        Destinations,
        (* Filter fields *)
        Filter,
        (*Mix, centrifuge, evaporate, incubate, etc fields *)
        Temperatures,
        Instrument,
        Instruments,
        InstrumentResources,
        MixVolumes,
        NumberOfMixes,
        MixTypes,
        MixInstrument,
        Streams,
        ContainersIn,
        TargetVolumeToleranceAchieved
    ];

    (* Download what we need from the MSP input protocol *)
    (* Quiet any FieldDoesntExist messages since not all subprotocol types have all of the fields we want. *)
    {
        mspPacket,
        optimizedUnitOpPackets,
        calculatedUnitOpPackets,
        outputUnitOpPackets,
        unitOpSubprotocolPackets,
        deepUnitOpSubprotocolPackets,
        containerLinkInputsPackets,
        containerLinkModelInputsPackets,
        instrumentPackets,
        instrumentModelPackets
    } = Quiet[Download[protocol,
        {
            mspPacketFields,
            OptimizedUnitOperations[Packet[All]],
            CalculatedUnitOperations[Packet[All]],
            OutputUnitOperations[Packet[All]],(* maybe switch from All to unitOperationPacketFields*)
            OutputUnitOperations[Subprotocol][subprotocolPacketFields],
            OutputUnitOperations[Subprotocol][Subprotocols..][subprotocolPacketFields],
            OptimizedUnitOperations[ContainerLink][Packet[Model, ImageFile]],
            OptimizedUnitOperations[ContainerLink][Model][Packet[ImageFile]],
            OutputUnitOperations[Instrument][Packet[Model, ImageFile]],
            OutputUnitOperations[Instrument][Model][Packet[ImageFile]]
        }
    ],
        Download::FieldDoesntExist
    ];

    (* Get a list of indices at which samples were re-prepared because a FTV unit operation ended with an overfill. *)
    (* This list may contain multiple instances of the same index if a sample was re-prepped multiple times. e.g., if *)
    (* two different remake protocols ran for the original FTV protocol at index 4, this should be {4, 4} instead of just {4}. *)
    (* NOTE these are the indices in the list of downloaded packets - these are NOT the sample indices of the remakes. *)
    ftvSubprotocolRemakeIndices = Flatten[
        MapThread[
            Function[
                {subprotocolTree, index},

                (* Skip an index entirely if its value is Null. *)
                If[NullQ[subprotocolTree],
                    Nothing,
                    Module[
                        {flatSubprotocolPackets, flatProtocolStatuses, completedSubprotocols, completedFTVProtocols, ftvRemakeProtocols},

                        (* Get a flat list of the deep (ignoring the level immediately beneath the parent MSP) *)
                        (* subprotocol objects at this index and then find any completed FTV protocols where TargetVolumeToleranceAchieved is not all True. *)
                        flatSubprotocolPackets = Flatten[subprotocolTree];
                        flatProtocolStatuses = Lookup[Flatten[subprotocolTree], Status];
                        completedSubprotocols = PickList[flatSubprotocolPackets, flatProtocolStatuses, Completed];
                        completedFTVProtocols = Cases[completedSubprotocols, ObjectP[Object[Protocol, FillToVolume]]];
                        ftvRemakeProtocols = Select[completedFTVProtocols, MemberQ[Lookup[#, TargetVolumeToleranceAchieved], False]&];

                        (* If there are no FTV protocols here, return Nothing. If there are FTV protocols, *)
                        (* return a list of the index repeated however many FTV protocols we find. *)
                        If[MatchQ[ftvRemakeProtocols, {}],
                            Nothing,
                            ConstantArray[index, Length[ftvRemakeProtocols]]
                        ]
                    ]
                ]
            ],
            {deepUnitOpSubprotocolPackets, Range[Length[deepUnitOpSubprotocolPackets]]}
        ]
    ];

    (* If there are any FTV sample remakes, we have to get the "extra" unit operation packets that we will later convert to *)
    (* a slideview, displaying the initial unit operations first. We must do this for any FTV unit operation with remakes as well as *)
    (* the unit operations involved in re-preparing the sample to feed into FTV - typically some combination of transfers and mixes. *)
    {
        remakeCorrectedOptimizedUOPackets,
        remakeCorrectedCalculatedUOPackets,
        remakeCorrectedOutputUOPackets,
        remakeCorrectedUOSubprotocolPackets,
        remakeCorrectedContainerLinkInputsPackets,
        remakeCorrectedContainerLinkModelInputsPackets,
        remakeCorrectedInstrumentPackets,
        remakeCorrectedInstrumentModelPackets
    } = If[MatchQ[ftvSubprotocolRemakeIndices, {}],
        (* We don't need to do anything to the downloaded packets if there are no FTV remakes. *)
        {
            optimizedUnitOpPackets,
            calculatedUnitOpPackets,
            outputUnitOpPackets,
            unitOpSubprotocolPackets,
            containerLinkInputsPackets,
            containerLinkModelInputsPackets,
            instrumentPackets,
            instrumentModelPackets
        },

        (* Otherwise, we have some work to do to incorporate the remakes. *)
        Module[
            {
                affectedSubprotocolTrees, ftvRemakeProtocolPackets, remakeVFLists, remakeProtocolPacketsGrouped,
                remakeParentMSPs, optimizedUnitOpPacketsFromRemakes, calculatedUnitOpPacketsFromRemakes,
                outputUnitOpPacketsFromRemakes, unitOpSubprotocolPacketsFromRemakes, containerLinkInputsPacketsFromRemakes,
                containerLinkModelInputsPacketsFromRemakes, instrumentPacketsFromRemakes, instrumentModelPacketsFromRemakes,
                relevantIndexLists, filterRemakePackets, filteredRemakeOptimizedUOPackets, filteredRemakeCalculatedUOPackets,
                filteredRemakeOutputUOPackets, filteredRemakeUOSubprotocolPackets, filteredRemakeContainerPackets,
                filteredRemakeContainerModelPackets, filteredRemakeInstrumentPackets, filteredRemakeInstrumentModelPackets, insertSampleRemakePackets,
                combinedOptimizedUOPackets, combinedCalculatedUOPackets, combinedOutputUOPackets, combinedUOSubprotocolPackets,
                remakePacketPositions, insertPackets, combinedContainerPackets, combinedContainerModelPackets, combinedInstrumentPackets, combinedInstrumentModelPackets,
                finalCombinedOutputUOPackets
            },

            (* Find the subprotocol trees which contain sample repreparation protocols. *)
            affectedSubprotocolTrees = deepUnitOpSubprotocolPackets[[DeleteDuplicates[ftvSubprotocolRemakeIndices]]];

            (* Find all of the FTV protocols corresponding to sample repreparations. *)
            ftvRemakeProtocolPackets = Cases[Flatten @ affectedSubprotocolTrees, ObjectP[Object[Protocol, FillToVolume]]];

            (* Get the containers in for the FTV protocols - these should all be of Type Object[Container, Vessel, VolumetricFlask] *)
            remakeVFLists = Lookup[ftvRemakeProtocolPackets, ContainersIn];

            (* Find the protocol packets corresponding to the reprepared samples. *)
            remakeProtocolPacketsGrouped = Map[
                Function[
                    {remakeFlasks},

                    Module[
                        {unfilteredSubprotocolList, ftvPosition},

                        (* Find any protocols in the affected subprotocol trees which uses the "remake" volumetric *)
                        (* flask(s) as either a ContainersIn or one of the transfer Destinations. *)
                        unfilteredSubprotocolList = PickList[
                            Flatten[affectedSubprotocolTrees],
                            Flatten /@ Lookup[Flatten[affectedSubprotocolTrees], {ContainersIn, Destinations}],
                            {___, ObjectP[remakeFlasks], ___}
                        ];

                        (* Get the position of the FTV protocol in this list. Use Max to convert from list to singleton, *)
                        (* taking the last position in case a subprotocol had to be regenerated (by sci ops). *)
                        ftvPosition = Max @ Position[unfilteredSubprotocolList, ObjectP[Object[Protocol, FillToVolume]], {1}];

                        (* Take only the packets up to and including the FillToVolume protocol. *)
                        unfilteredSubprotocolList[[Range[ftvPosition]]]
                    ]

                ],
                remakeVFLists
            ];

            (* Get the parent MSPs of each group of relevant remake protocols. *)
            remakeParentMSPs = Lookup[remakeProtocolPacketsGrouped[[All, 1]], ParentProtocol];

            (* Do a second download to get the relevant info for the remake MSPs. *)
            {
                optimizedUnitOpPacketsFromRemakes,
                calculatedUnitOpPacketsFromRemakes,
                outputUnitOpPacketsFromRemakes,
                unitOpSubprotocolPacketsFromRemakes,
                containerLinkInputsPacketsFromRemakes,
                containerLinkModelInputsPacketsFromRemakes,
                instrumentPacketsFromRemakes,
                instrumentModelPacketsFromRemakes
            } = Transpose @ Quiet[Download[remakeParentMSPs,
                {
                    OptimizedUnitOperations[Packet[All]],
                    CalculatedUnitOperations[Packet[All]],
                    OutputUnitOperations[Packet[All]],(* maybe switch from All to unitOperationPacketFields*)
                    OutputUnitOperations[Subprotocol][subprotocolPacketFields],
                    OptimizedUnitOperations[ContainerLink][Packet[Model, ImageFile]],
                    OptimizedUnitOperations[ContainerLink][Model][Packet[ImageFile]],
                    OutputUnitOperations[Instrument][Packet[Model, ImageFile]],
                    OutputUnitOperations[Instrument][Model][Packet[ImageFile]]
                }
            ],
                Download::FieldDoesntExist
            ];

            (* Map over the outputUnitOpPacketsFromRemakes and find the indices of the relevant packets - ie those that we need to parse below. *)
            relevantIndexLists = MapThread[
                Function[
                    {outputUOPacketList, remakeProtocolPacketGroups},
                    Flatten @ Position[
                        Lookup[outputUOPacketList, Subprotocol],
                        ObjectP[Lookup[remakeProtocolPacketGroups, Object]],
                        {1}
                    ]
                ],
                {outputUnitOpPacketsFromRemakes, remakeProtocolPacketsGrouped}
            ];

            (* Filter out any packets that we DO NOT need to feed into the unitOperationPrimaryData functions. *)
            (* Use a simple helper function to do this. *)
            filterRemakePackets[myListedPackets_, myRelevantIndices:{{_Integer..}..}] := MapThread[
                #1[[#2]]&,
                {myListedPackets, myRelevantIndices}
            ];

            (* Filter all the unit operation packet lists above. *)
            {
                filteredRemakeOptimizedUOPackets,
                filteredRemakeCalculatedUOPackets,
                filteredRemakeOutputUOPackets,
                filteredRemakeUOSubprotocolPackets,
                filteredRemakeContainerPackets,
                filteredRemakeContainerModelPackets,
                filteredRemakeInstrumentPackets,
                filteredRemakeInstrumentModelPackets
            } = Map[
                filterRemakePackets[#, relevantIndexLists]&,
                {
                    optimizedUnitOpPacketsFromRemakes,
                    calculatedUnitOpPacketsFromRemakes,
                    outputUnitOpPacketsFromRemakes,
                    unitOpSubprotocolPacketsFromRemakes,
                    containerLinkInputsPacketsFromRemakes,
                    containerLinkModelInputsPacketsFromRemakes,
                    instrumentPacketsFromRemakes,
                    instrumentModelPacketsFromRemakes
                }
            ];

            (* Helper to rebuild a list of download packets, accounting for the sample remakes. *)
            insertSampleRemakePackets[myInitialDownloadPackets_, myFilteredRemakePackets_, myRemakePacketIndices:{_Integer..}] := Module[
                {alreadyAddressedPacketIndices, availableRemakePackets},

                (* Initialize a list of indices we've already handled. *)
                alreadyAddressedPacketIndices = {};

                (* Initialize a list of lists of remake packets that are not yet assigned. *)
                availableRemakePackets = myFilteredRemakePackets;

                Flatten[
                    Map[
                        Function[
                            {packetIndex},

                            (* Check if this index is in the list of indices we've already dealt with. *)
                            (* It is easier to just address any repeated indices all at once, so do so and *)
                            (* ignore any indices that we've already addressed. *)
                            If[MemberQ[alreadyAddressedPacketIndices, packetIndex],
                                Nothing,
                                Module[
                                    {numberOfRemakes, initialPackets, allRemakePacketsAtThisIndex, replacementPacketGrouping, finalReplacementPackets},

                                    (* Add this index to alreadyAddressedPacketIndices *)
                                    AppendTo[alreadyAddressedPacketIndices, packetIndex];

                                    (* Get the number of repreparation FTV protocols corresponding to this index. *)
                                    numberOfRemakes = Lookup[Counts[myRemakePacketIndices], packetIndex];

                                    (* Get the original run of UOs before the remakes. *)
                                    initialPackets = Module[
                                        {truncatedInitialDownloadPackets, reversedInitialPacketCandidates, reversedAvailableRemakeUOTypes, reversedInitialPackets},

                                        (* Get the run of initial download packets up until this packet index, then reverse their order. *)
                                        truncatedInitialDownloadPackets = Take[myInitialDownloadPackets, packetIndex];
                                        reversedInitialPacketCandidates = Reverse[truncatedInitialDownloadPackets];

                                        (* Get the Types from the first set of availableRemakePackets and reverse those, too. *)
                                        reversedAvailableRemakeUOTypes = Reverse @ Lookup[First[availableRemakePackets], Type];

                                        (* We want the first UO of each expected type. *)
                                        reversedInitialPackets = Map[
                                            Function[
                                                {expectedType},
                                                FirstCase[reversedInitialPacketCandidates, ObjectP[expectedType]]
                                            ],
                                            reversedAvailableRemakeUOTypes
                                        ];

                                        (* Reverse this to return the initial run of packets. *)
                                        Reverse[reversedInitialPackets]
                                    ];

                                    (* Get the packets corresponding to the remakes at this packet index. *)
                                    allRemakePacketsAtThisIndex = Take[availableRemakePackets, numberOfRemakes];

                                    (* Drop whatever we just took from the availableRemakePackets. *)
                                    availableRemakePackets = Drop[availableRemakePackets, numberOfRemakes];

                                    (* Prepend the initial unit ops to the remake unit ops and transpose them - this *)
                                    (* will group the unit operations of the same type. e.g., if the remake involves *)
                                    (* transfer -> mix -> FTV, we will get a sequence like the following: *)
                                    (* initial transfer -> remake transfer -> initial mix -> remake mix -> initial FTV -> remake FTV *)
                                    replacementPacketGrouping = Flatten[Transpose[Prepend[allRemakePacketsAtThisIndex, initialPackets]]];

                                    (* Add a key to these packets to indicate that they belong to a remake sequence and the initial packet index *)
                                    (* with which they are associated. This will help us distinguish different remake sequences later if needed. *)
                                    (* For example, FillToVolumeOverfillingRepreparation -> "4-2/3" designates that a protocol is part of the second *)
                                    (* sequence out of a total of 3 sequences, which originated with the 4th unit operation in the MSP. In other words, *)
                                    (* this protocol corresponds to the first re-prep sequence of the initial attempt at the FTV in unit operation 4, but *)
                                    (* another reprep sequence follows it. This is kind of hairy but we do need to pass all of this info into the UOPrimaryData functions. *)
                                    finalReplacementPackets = MapThread[
                                        Function[
                                            {packet, remakeSubIndex},
                                            Append[
                                                packet,
                                                <|FillToVolumeOverfillingRepreparation -> ToString[packetIndex]<>"-"<>ToString[remakeSubIndex]<>"/"<>ToString[numberOfRemakes + 1]|>
                                            ]
                                        ],
                                        {replacementPacketGrouping, Flatten[ConstantArray[Range[numberOfRemakes + 1], Length[initialPackets]]]}
                                    ];

                                    (* Make the replacements and return. *)
                                    SequenceReplace[myInitialDownloadPackets, initialPackets -> finalReplacementPackets]
                                ]
                            ]

                        ],
                        myRemakePacketIndices
                    ]
                ]
            ];

            (* Make all of the combined packets, inserting any remakes into the initial list as needed. *)
            combinedOptimizedUOPackets = insertSampleRemakePackets[optimizedUnitOpPackets, filteredRemakeOptimizedUOPackets, ftvSubprotocolRemakeIndices];
            combinedCalculatedUOPackets = insertSampleRemakePackets[calculatedUnitOpPackets, filteredRemakeCalculatedUOPackets, ftvSubprotocolRemakeIndices];
            combinedOutputUOPackets = insertSampleRemakePackets[outputUnitOpPackets, filteredRemakeOutputUOPackets, ftvSubprotocolRemakeIndices];
            combinedUOSubprotocolPackets = insertSampleRemakePackets[unitOpSubprotocolPackets, filteredRemakeUOSubprotocolPackets, ftvSubprotocolRemakeIndices];

            (* The download packets for containers, instruments, and their models are of less predictable structure but we still need them. *)
            (* Instead of applying the above logic, find the indices where we added replacement packets above and do so for the remaining download packets. *)

            (* Get the positions where we inserted remake packets into the optimized UO packets. *)
            remakePacketPositions = Flatten @ Position[
                Map[
                    If[FreeQ[Lookup[optimizedUnitOpPackets, Object], ObjectP[#]], Null, #]&,
                    Lookup[combinedOptimizedUOPackets, Object]
                ],
                Null,
                {1}
            ];

            (* Helper to splice in the missing values wherever they are needed. *)
            insertPackets[myInitialPackets_List, myInsertionPackets_List, myInsertionIndices:{_Integer..}] := Module[
                {remainingInitialPackets, remainingInsertionPackets},

                (* Initialize lists of remaining packets - both for the initial packets and the insertion packets. *)
                remainingInitialPackets = myInitialPackets;
                remainingInsertionPackets = myInsertionPackets;

                Map[
                    Function[
                        {index},
                        If[MemberQ[myInsertionIndices, index],
                            Module[{insertionItem},
                                insertionItem = First[remainingInsertionPackets];
                                remainingInsertionPackets = Rest[remainingInsertionPackets];
                                insertionItem
                            ],
                            Module[{returnItem},
                                returnItem = First[remainingInitialPackets];
                                remainingInitialPackets = Rest[remainingInitialPackets];
                                returnItem
                            ]
                        ]
                    ],
                    Range[Length[combinedOptimizedUOPackets]]
                ]

            ];

            (* Use the above helper to pad out these lists to the appropriate length. *)
            combinedContainerPackets = insertPackets[containerLinkInputsPackets, Flatten @ Transpose[filteredRemakeContainerPackets], remakePacketPositions];
            combinedContainerModelPackets = insertPackets[containerLinkModelInputsPackets, Flatten @ Transpose[filteredRemakeContainerModelPackets], remakePacketPositions];
            combinedInstrumentPackets = insertPackets[instrumentPackets, Flatten @ Transpose[filteredRemakeInstrumentPackets], remakePacketPositions];
            combinedInstrumentModelPackets = insertPackets[instrumentModelPackets, Flatten @ Transpose[filteredRemakeInstrumentModelPackets], remakePacketPositions];

            (* Identify the sample indices within the protocols which were later superseded by sample remakes. Then add this info to *)
            (* the output UO packets since this is the only set of packets that is used for every unitOperationPrimaryData function. *)
            finalCombinedOutputUOPackets = Module[
                {combinedUOSubprotocolPacketsAssoc, remakeTuples, filteredRemakeTuples, sampleRemakeIndices, remakeStringToSampleRemakeIndicesLookup},

                (* Replace any Nulls with <||> so as to not break any lookups. *)
                combinedUOSubprotocolPacketsAssoc = Replace[combinedUOSubprotocolPackets, Null -> <||>, {1}];

                (* Generate tuples including the protocol object, FTV reprep strings we generated above, and the TargetVolumeToleranceAchieved *)
                remakeTuples = Lookup[#, {Object, FillToVolumeOverfillingRepreparation, TargetVolumeToleranceAchieved}, Null] & /@ combinedUOSubprotocolPacketsAssoc;

                (* Get the remake tuples corresponding to FTV protocol objects belonging to a remake sequence. *)
                filteredRemakeTuples = Cases[remakeTuples, {ObjectP[Object[Protocol, FillToVolume]], _String, {BooleanP..}}];

                (* Get the sample remake indices for each FTV protocol - ie the positions where TargetVolumeToleranceAchieved is False. *)
                sampleRemakeIndices = Map[
                    Flatten[Position[#, False, {1}]]&,
                    filteredRemakeTuples[[All, -1]]
                ];

                (* Generate a lookup from the FTV reprep string to the corresponding sample remake indices. *)
                remakeStringToSampleRemakeIndicesLookup = MapThread[
                    #1 -> #2&,
                    {filteredRemakeTuples[[All, 2]], sampleRemakeIndices}
                ];

                (* Find the samples indices at which remakes occurred for each FTV protocol and append them to the output UO packets. *)
                Map[
                    Function[
                        {combinedOutputUOPacketList},
                        Module[
                            {ftvReprepString},

                            (* Get the FTV reprep string from the packet. *)
                            ftvReprepString = Lookup[combinedOutputUOPacketList, FillToVolumeOverfillingRepreparation, Null];

                            (* If this packet has a FTV reprep string, append the sample remake indices that correspond to the string. *)
                            If[MatchQ[ftvReprepString, _String],
                                Append[combinedOutputUOPacketList, <|RetryIndex -> ftvReprepString /. remakeStringToSampleRemakeIndicesLookup|>],
                                combinedOutputUOPacketList
                            ]
                        ]
                    ],
                    combinedOutputUOPackets
                ]
            ];

            (* Return, replacing $Failed with <||> to avoid breaking any Lookup calls. *)
            {
                combinedOptimizedUOPackets,
                combinedCalculatedUOPackets,
                finalCombinedOutputUOPackets,
                combinedUOSubprotocolPackets,
                combinedContainerPackets,
                combinedContainerModelPackets,
                combinedInstrumentPackets,
                combinedInstrumentModelPackets
            } /. {$Failed -> <||>}

        ]
    ];

    (* Some unit ops don't correspond to a Subprotocol, so will be Null in the downloaded list of packets. Replace the Nulls at level spec 1 with an empty packet. *)
    unitOpSubprotocolPacketsAssocs = Replace[remakeCorrectedUOSubprotocolPackets, Null -> <||>, {1}];

    (* make tables of relevent information from each unit operation type *)
    infoTables = MapThread[Function[
        {
            optimizedUnitOpPacket,
            calculatedUnitOpPacket,
            outputUnitOpPacket,
            unitOpSubprotocolPacket,
            containerPackets,
            containerModelPackets,
            instrumentPackets,
            instrumentModelPackets
        },
        Module[{excludedKeys, unitOpType, optimizedUserOptions, mainInfoTable},

            (* Determine the unit operation subtype, for use in the table generating Switch[] *)
            unitOpType = Lookup[outputUnitOpPacket, Type, Null][[-1]];

            (* Get a list so that if we're just defaulting to show all of the unresolved options, we can remove the keys that we never want to show *)
            excludedKeys = {ImageSample, MeasureVolume, MeasureWeight, Preparation, CreatedBy, DateCreated, ID, Notebook, Protocol, Type, UnitOperationType, Object, Restricted};

            (* Get only the fields that are not Null or {} from the otimized unit operation packets, this will mostly correspond to inputs and options that the user set*)
            optimizedUserOptions = KeyDrop[
                KeySelect[
                    Association[optimizedUnitOpPacket],
                    !MatchQ[Association[optimizedUnitOpPacket][#], ({} | ListableP[Null] | ListableP[False])]&
                ],
                (* Remove the keys that we never want to show *)
                excludedKeys
            ];

            (* Map through each unit operation and create the figure that will go in the tab view, depending on the type of unit operation *)
            mainInfoTable = Switch[unitOpType,
                (* LabelContainer Unit Ops *)
                LabelContainer,
                    labelContainerUnitOperationPrimaryData[optimizedUnitOpPacket, outputUnitOpPacket, containerPackets, containerModelPackets],

                (* LabelSample Unit Ops *)
                LabelSample,
                    labelSampleUnitOperationPrimaryData[outputUnitOpPacket],

                Transfer,
                    transferUnitOperationPrimaryData[outputUnitOpPacket],

                Alternatives[Mix, Incubate],
                    mixIncubateUnitOperationPrimaryData[optimizedUnitOpPacket, outputUnitOpPacket, optimizedUserOptions, ToList[instrumentPackets], ToList[instrumentModelPackets], unitOpSubprotocolPacket],

                Centrifuge,
                    centrifugeUnitOperationPrimaryData[optimizedUnitOpPacket, calculatedUnitOpPacket, outputUnitOpPacket, optimizedUserOptions, ToList[instrumentPackets], ToList[instrumentModelPackets], unitOpSubprotocolPacket],

                Filter,
                    filterUnitOperationPrimaryData[optimizedUnitOpPacket, outputUnitOpPacket, ToList[instrumentPackets], ToList[instrumentModelPackets]],

                FillToVolume,
                    fillToVolumeUnitOperationPrimaryData[outputUnitOpPacket],

                FluorescenceKinetics,
                    plateReaderUnitOperationPrimaryData[outputUnitOpPacket, optimizedUserOptions, ToList[instrumentPackets], ToList[instrumentModelPackets]],

                _,
                    generalUnitOperationPrimaryData[outputUnitOpPacket]
            ];

            mainInfoTable
        ]
    ],
        {
            remakeCorrectedOptimizedUOPackets,
            remakeCorrectedCalculatedUOPackets,
            remakeCorrectedOutputUOPackets,
            unitOpSubprotocolPacketsAssocs,
            remakeCorrectedContainerLinkInputsPackets,
            remakeCorrectedContainerLinkModelInputsPackets,
            remakeCorrectedInstrumentPackets,
            remakeCorrectedInstrumentModelPackets
        }
    ];

    (* use PlotObject to get plots of any data present in subprotocols *)
    dataPlots = Map[
        If[MatchQ[#, ObjectP[Object[Protocol]]],
            If[$ZoomableBoolean,
                (* We are good to use Zoomable when not in Manifold *)
                PlotObject[#, Zoomable -> $ZoomableBoolean],
                (* When in Manifold, we will create a button to apply zoomable on demand *)
                zoomableButton[PlotObject[#, Zoomable -> $ZoomableBoolean]]
            ],
            Null
        ]
            &,
        Lookup[unitOpSubprotocolPacketsAssocs, Object]
    ];

    (* For each unit operation, generate a message that communicates any relevance of the current unit operation to FTV sample repreparations. *)
    unitOperationLaterRedoneMessages = Map[
        Function[
            {outputUOPacket},
            Module[
                {unitOperationObject, ftvReprepString, ftvReprepIndices, unitOperationLaterRedoneQ, originalUnitOpIndexString, associatedFTVUnitOperation},

                (* Get the unit operation object. *)
                unitOperationObject = Lookup[outputUOPacket, Object, Null];

                (* Get the reprep string and indices from the output unit operation packet. *)
                {ftvReprepString, ftvReprepIndices} = Lookup[outputUOPacket, {FillToVolumeOverfillingRepreparation, RetryIndex}];

                (* Determine whether this unit operation corresponds to a sample remake protocol. *)
                {unitOperationLaterRedoneQ, originalUnitOpIndexString} = If[!StringQ[ftvReprepString],
                    {False, Null},
                    (* If this is a string, this is only a remake protocol if this isn't the last round of the sequence. *)
                    (* i.e., return False if and only if the numbers on either side of the "/" in ftvReprepString are the same. *)
                    Module[
                        {initialUOIndex, remakeSequenceNumber, totalRemakeSequences},
                        {initialUOIndex, remakeSequenceNumber, totalRemakeSequences} = StringSplit[ftvReprepString, {"-", "/"}];
                        {!SameQ[remakeSequenceNumber, totalRemakeSequences], initialUOIndex}
                    ]
                ];

                (* If this is a remake protocol, find the subsequent FTV unit operation that was overfilled so we can tell the user what was remade. *)
                associatedFTVUnitOperation = If[unitOperationLaterRedoneQ,
                    FirstCase[
                        Flatten @ Cases[
                            Lookup[#, {FillToVolumeOverfillingRepreparation, Object}, Null] & /@ remakeCorrectedOutputUOPackets,
                            {ftvReprepString, ObjectP[Object[UnitOperation, FillToVolume]]}
                        ],
                        ObjectP[Object[UnitOperation, FillToVolume]],
                        Null
                    ],
                    Null
                ];

                (* If we later redid part or all of this unit operation due to FTV overfills and subsequent repreparations, generate a message *)
                (* to tell the user that this happened and which FTV unit operation required the sample repreps. Use Null if this is not needed. *)
                If[TrueQ[unitOperationLaterRedoneQ],
                    Module[
                        {messageString1, messageString2, messageString3, styleSettings},

                        (* Set up the message strings. Put a slightly different message on a tab for the FTV sub vs other preparatory steps. *)
                        {messageString1, messageString2, messageString3} = If[MatchQ[associatedFTVUnitOperation, ObjectP[unitOperationObject]],
                            {
                                "The sample(s) at indices "<>ToString[ftvReprepIndices]<>" in "<>ObjectToString[associatedFTVUnitOperation]<>" at unit operation index "<>originalUnitOpIndexString,
                                "were reprepared due to an overfill of the volumetric flask on the initial attempt. Navigate to the subsequent Repreparation tab(s) above",
                                "to view repreparation details. Navigate to prior unit operation tabs to view how and if they were affected by repreparations."
                            },
                            {
                                "The sample(s) at indices "<>ToString[ftvReprepIndices]<>" in "<>ObjectToString[associatedFTVUnitOperation]<>" at unit operation index "<>originalUnitOpIndexString,
                                "were reprepared due to an overfill of the volumetric flask on the initial attempt. Some or all of "<>ObjectToString[unitOperationObject],
                                "was repeated to reprepare the sample(s). Navigate to the subsequent Repreparation tab(s) in this tab to view repreparation details."
                            }
                        ];

                        (* Store the Style settings and generate a centered column of the strings. *)
                        styleSettings = {12, $ExperimentalResultColor, FontFamily -> "Helvetica"};
                        Column[
                            Prepend[
                                Style[#, Sequence @@ styleSettings]& /@ {messageString1, messageString2, messageString3},
                                Style["Sample Repreparation Details", Bold, 14, $ExperimentalResultColor, FontFamily -> "Helvetica"]
                            ],
                            Alignment -> Center
                        ]
                    ],
                    Null
                ]
            ]
        ],
        remakeCorrectedOutputUOPackets
    ];

    (* Group together the remake sequences so that we can present them in SlideView within the tabs. *)
    (* Start by writing a function to provide the SplitBy criteria. *)
    splittingCriteriaFunction[myPacket_] := Module[
        {ftvRemakeString, uoType, groupingNumber},

        {ftvRemakeString, uoType} = Lookup[myPacket, {FillToVolumeOverfillingRepreparation, Type}, Null];

        (* Get the grouping number - i.e. the first number from ftvRemakeString. If a given UO does not have a string, *)
        (* it should be in its own list when split. Guarantee this by running CreateUUID[] in the Lookup default argument. *)
        groupingNumber = If[StringQ[ftvRemakeString],
            First[StringSplit[ftvRemakeString, "-"]],
            CreateUUID[]
        ];

        {groupingNumber, uoType}
    ];

    (* Generate the split list of output unit operation objects. *)
    splitOutputUnitOperations = Map[Lookup[#, Object]&, SplitBy[remakeCorrectedOutputUOPackets, splittingCriteriaFunction]];

    (* Split the infoTables, dataPlots, and subprotocol objects using the same splitting pattern. *)
    {
        splitInfoTables,
        splitDataPlots,
        splitSubprotocols,
        splitUnitOperationLaterRedoneMessages
    } = Unflatten[#, splitOutputUnitOperations]& /@ {infoTables, dataPlots, Lookup[unitOpSubprotocolPacketsAssocs, Object], unitOperationLaterRedoneMessages};

    (* Get list of all unit operation types for use in making info tables and in labeling the tabs in the final TabView. *)
    outputUnitOpTypeList = Lookup[outputUnitOpPackets, Type][[All, -1]];

    (* make a list of unit operations and their labels for the tab icons *)
    unitOpIconsList = outputUnitOpTypeList /. $UnitOperationIconFilePaths;

    (* put together the tables/data/other info to be shown in each unit op's slide *)
    panelContentRules = MapThread[Function[{icon, iconLabel, infoTableList, dataPlotList, subprotocolObjectList, unitOperationObjectList, laterRedoneMessageList, index},
        Module[{initialUnitOperationTitles, initialInfoTables, initialDataPlots, unitOpDisplayPanel},

            {initialUnitOperationTitles, initialInfoTables, initialDataPlots} = Transpose @ MapThread[
                Function[
                    {subprotocolObject, infoTable, dataPlot, unitOperationObject},

                    {
                        (* Slide Titles *)
                        Which[
                            MatchQ[subprotocolObject, ObjectP[Object[Protocol]]] && MatchQ[unitOperationObject, ObjectP[Object[UnitOperation]]],
                            customButton[
                                Column[{
                                    Style["Information for Unit Operation at Index " <> ToString[index], Bold],
                                    ToString[unitOperationObject[Object]],
                                    "(Subprotocol " <> ToString[subprotocolObject[Object]] <> ")"
                                },
                                    Alignment -> Center
                                ],
                                Tooltip -> ObjectToString[unitOperationObject[Object]],
                                CopyContent -> unitOperationObject[Object],
                                FontSize -> 16
                            ],
                            MatchQ[unitOperationObject, ObjectP[Object[UnitOperation]]],
                            customButton[
                                Column[{
                                    Style["Information for Unit Operation at Index " <> ToString[index], Bold],
                                    ToString[unitOperationObject[Object]]
                                },
                                    Alignment -> Center
                                ],
                                Tooltip -> ObjectToString[unitOperationObject[Object]],
                                CopyContent -> unitOperationObject[Object],
                                FontSize -> 16
                            ],
                            True,
                            Style["Information for Unit Operation at Index " <> ToString[index], 16, TextAlignment -> Center, Bold, FontFamily -> "Helvetica"]
                        ],

                        (* Info Tables *)
                        If[!MatchQ[infoTable, ({} | Null)],
                            infoTable,
                            Null
                        ],

                        (* Data Plots *)
                        If[!MatchQ[dataPlot, ({} | Null)],
                            Labeled[dataPlot, Style["Primary Data", 16, TextAlignment -> Center, Bold, FontFamily -> "Helvetica"], Top],
                            Null
                        ]

                    }
                ],
                {subprotocolObjectList, infoTableList, dataPlotList, unitOperationObjectList}
            ];

            unitOpDisplayPanel = If[SameQ[Length[initialUnitOperationTitles], 1],
                Column[
                    (* Remove any Nulls, then take the first element of each list because length must be 1 for all of these lists. *)
                    Cases[
                        {
                            initialUnitOperationTitles,
                            initialDataPlots,
                            initialInfoTables
                        },
                        Except[NullP]
                    ][[All, 1]],
                    Frame -> All,
                    Dividers->{False, {False, True, True}},
                    Spacings -> $ReviewGridSpacings,
                    Alignment -> {Center, Top}
                ],
                Module[
                    {tabTitles},

                    (* Title the first tab "Initial Preparation" and the subsequent tabs "Repreparation 1" and so on. *)
                    tabTitles = Prepend[
                        Map["Repreparation "<>ToString[#]&, Range[Length[initialUnitOperationTitles] - 1]],
                        "Initial Preparation"
                    ];

                    TabView[
                        MapThread[
                            Function[
                                {tabTitle, initialUOTitle, individualDataPlot, individualInfoTable, individualLaterRedoneMessage},
                                tabTitle -> Column[
                                    Cases[
                                        {
                                            initialUOTitle,
                                            individualLaterRedoneMessage,
                                            individualDataPlot,
                                            individualInfoTable
                                        },
                                        Except[NullP]
                                    ],
                                    Frame -> All,
                                    Dividers->{False, {False, True, True}},
                                    Spacings -> $ReviewGridSpacings,
                                    Alignment -> {Center, Top}
                                ]
                            ],
                            {tabTitles, initialUnitOperationTitles, initialInfoTables, initialDataPlots, laterRedoneMessageList}
                        ],
                        Alignment -> {Center, Top}
                    ]

                ]

            ];

            Tooltip[Row[{Style[ToString[index]<>" ", 22, Bold, LCHColor[0.4, 0, 0], "Helvetica"], icon}], iconLabel] -> unitOpDisplayPanel
        ]
    ],
        {unitOpIconsList, outputUnitOpTypeList, splitInfoTables, splitDataPlots, splitSubprotocols, splitOutputUnitOperations, splitUnitOperationLaterRedoneMessages, Range[Length[unitOpIconsList]]}
    ];

    (* set up the tab view panel which we will put each unit operation information into *)
    {
        Labeled[
            TabView[panelContentRules,
                ControlPlacement -> Left,
                Alignment -> {Center, Top},
                Appearance -> {"Limited", 7}
            ],
            customButton[
              Style[ObjectToString[protocol[Object]] <> "\n", TextAlignment -> Center, Bold, 18, FontFamily -> "Helvetica"],
              Tooltip -> ObjectToString[protocol[Object]],
              CopyContent -> protocol[Object],
              FontSize -> 16
            ],
            Top
        ]
    }
];

(* Helper to merge adjacent cells in Grid *)

(* Input for the second argument needs to be a list of lists, where each list represents one column of the grid. Also make sure any object inputs are just objects without links*)
(* Output of this should be transposed in the Grid *)
mergeGridCellsVertical[myHeadings_List, myGridContents_List] := Module[
    {nullPositions, positionsToKeep, filteredHeadings, filteredGridContents},

    (* No need to display any columns for which all the values are Null. *)
    nullPositions = Flatten @ Position[myGridContents, NullP, {1}];
    positionsToKeep = UnsortedComplement[Range[Length[myGridContents]], nullPositions];

    (* Filter out the Null columns and remove the associated headings. *)
    filteredHeadings = myHeadings[[positionsToKeep]];
    filteredGridContents = myGridContents[[positionsToKeep]];

    {
        filteredHeadings,
        Map[
            (* Mapping through the list of column lists *)
            Module[{splitList, repeatsReplaced},
                (* Split the list of items in this column so that adjacent identical values are grouped *)
                splitList = Split[#];

                (* Map through each of the grouped lists, and output a flattened list of *)
                repeatsReplaced = Flatten[
                    Map[
                        {
                            First[#],
                            ConstantArray[SpanFromAbove, Length[Rest[#]]]
                        }&,
                        splitList
                    ]
                ]
            ]&,
            filteredGridContents
        ]
    }
];

(* Unit Operation primary data display helper functions *)

labelContainerUnitOperationPrimaryData[
    optimizedUnitOpPacket_Association,
    outputUnitOpPacket_Association,
    containerPackets_List,
    containerModelPackets_List
] := Module[
    {
        labels, containersInputs, containersOutputs, containerModels, modelImages, clickableContainersOut,
        splitModelsList, splitImagesList, splitContainersOutList, splitLabelsList, tables, foundImage
    },

    (* Get the container label inputs *)
    labels = Lookup[optimizedUnitOpPacket, Label];

    (* Get the containers from the inputs *)
    containersInputs = FirstCase[
        Lookup[optimizedUnitOpPacket, {ContainerLink, ContainerString}, {}],
        (ListableP[ObjectP[]] | ListableP[_String])
    ];

    (* Get the containers from the outputs *)
    containersOutputs = FirstCase[
        Lookup[outputUnitOpPacket, {ContainerLink, ContainerString}, {}],
        (ListableP[ObjectP[]] | ListableP[_String])
    ][Object];

    (* Get an image for each unique container model *)
    {containerModels, modelImages} = Which[

        (* Most likely the containers in the optimized unit operations were input as Model[Container]'s, so first check that *)
        MatchQ[ToList[containersInputs], {ObjectP[Model[Container]]..}],
            {ToList[containersInputs][Object], Lookup[containerPackets, ImageFile, Null]},

        (* Otherwise if there are any Object[Container] or Model[Container] inputs, map through the input containers and lookup the ImageFile from either the container model packet or the container packet. *)
        MemberQ[ToList[containersInputs], ObjectP[{Object[Container], Model[Container]}]],
            Transpose[MapThread[
                Function[{containerInput, index},
                    Which[
                        MatchQ[containerInput, ObjectP[Object[Container]]],
                            {Lookup[containerPackets[[index]], Model, Null], Lookup[containerModelPackets[[index]], ImageFile, Null]},
                        MatchQ[containerInput, ObjectP[Model[Container]]],
                            {containerInput, Lookup[containerPackets[[index]], ImageFile, Null]},
                        True,
                            {containerInput, Null}
                    ]
                ],
                {ToList[containersInputs], Range[Length[ToList[containersInputs]]]}
            ]],

        (* Otherwise, if the containers input contains no models or objects, just return the container inputs and Null for the images *)
        True,
        {ToList[containersInputs], ConstantArray[Null, Length[ToList[containersInputs]]]}
    ];

    (* Make the container objects click to copy *)
    clickableContainersOut = customButton /@ containersOutputs;

    (* Display a grid for each container model that has an image of the model on top, the name of the model below that, then a table with the headings 'Labels' and 'Labeled Containers'. *)
    (* Split the input lists by container model *)
    splitModelsList = Split[containerModels];

    {
        splitImagesList,
        splitContainersOutList,
        splitLabelsList
    } = Unflatten[#, splitModelsList]& /@ {modelImages, clickableContainersOut, labels};

    tables = MapThread[Function[{models, images, labels, containersOut},
        Column[
            {
                (* If there is an image, show it. *)
                foundImage = FirstCase[images, ObjectP[]];
                If[MatchQ[foundImage, ObjectP[Object[EmeraldCloudFile]]],
                    Framed[Pane@formatImage[foundImage], FrameStyle -> LightGray],
                    Nothing
                ],

                (* Create a table of the model, labels, and containers *)
                Labeled[
                    Pane[
                        Grid[
                            {
                                {Style["Label", 12, Bold, FontFamily->"Helvetica"], Style["Labeled Container", 12, Bold, FontFamily->"Helvetica"]},
                                Sequence @@ Transpose[{labels, containersOut}]
                            },
                            Frame -> All,
                            Alignment -> {Center, Center},
                            Spacings -> {2, 1},
                            ItemStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica"],
                            FrameStyle -> Lighter[Gray, 0.4],
                            Alignment -> {Center, Center},
                            Dividers -> {
                                {},
                                {2 -> Directive[Thick, Darker[Gray]]}
                            },
                            Background -> White,
                            ItemSize->{{13, 20}}
                        ],
                        ImageSize -> {UpTo[700], UpTo[600]},
                        Scrollbars -> Automatic,
                        AppearanceElements -> None
                    ],
                    Style[NamedObject[First[models]], Bold, FontFamily -> "Helvetica"],
                    Top
                ]
            },
            Alignment -> Center,
            Spacings -> 2
        ]
    ],
        {splitModelsList, splitImagesList, splitLabelsList, splitContainersOutList}
    ];

    (* Return in SlideView if there is more than one table to show. Otherwise just return the one table. *)
    If[GreaterQ[Length[tables], 1],
        SlideView[tables, AppearanceElements -> {"FirstSlide", "PreviousSlide", "NextSlide", "LastSlide", "SlideNumber", "SlideTotal"}],
        tables[[1]]
    ]
];

labelSampleUnitOperationPrimaryData[
    outputUnitOpPacket_Association
] := Module[{headings, samples, containers, sampleModels, labels, containerLabels, allTableData, headingsValuesPairs, tableHeadingsValuesPairs},

    (* List of headings for fields we want to show in the table. *)
    headings = {
        "Sample",
        "Sample Model",
        "Label",
        "Container",
        "Container Model"
    };

    {sampleModels, labels, containerLabels} = NamedObject[Lookup[outputUnitOpPacket, {SampleModel, Label, ContainerLabel}, Null]];

    samples = NamedObject[Module[{outUOSampleValues, lengthSampleValues, links, expressions, strings},
        outUOSampleValues = Lookup[outputUnitOpPacket, {SampleLink, SampleExpression, SampleString}, Null];

        (* get the length of the longest of the fields of interest *)
        lengthSampleValues = Max[Length/@outUOSampleValues];

        (* if any of the fields is not the same length, we need to populate it with Nulls *)
        {links, expressions, strings} = PadRight[#, lengthSampleValues, Null]&/@outUOSampleValues;

        (* Map through each sample, and pull out whichever of the sample fields is populated *)
        Map[
            FirstCase[#, Except[NullP], Null]&,
            Transpose[{links, expressions, strings}]
        ]
    ]];

    containers = NamedObject[Module[{outUOContainerValues, lengthContainerValues, links, strings},
        outUOContainerValues = Lookup[outputUnitOpPacket, {ContainerLink, SampleString}, Null];

        (* get the length of the longest of the fields of interest *)
        lengthContainerValues = Max[Length/@outUOContainerValues];

        (* if any of the fields is not the same length, we need to populate it with Nulls *)
        {links, strings} = PadRight[#, lengthContainerValues, Null]&/@outUOContainerValues;

        (* Map through each sample, and pull out whichever of the container fields is populated *)
        Map[
            FirstCase[#, Except[NullP], Null]&,
            Transpose[{links, strings}]
        ]
    ]];

    {sampleModels, labels, containerLabels} = NamedObject[Lookup[outputUnitOpPacket, {SampleModel, Label, ContainerLabel}, Null]];

    allTableData = {
        samples,
        sampleModels,
        labels,
        containers,
        containerLabels
    };

    headingsValuesPairs = Transpose[{headings, allTableData}];

    tableHeadingsValuesPairs = Select[headingsValuesPairs, !MatchQ[#[[2]], (ListableP[Null] | ListableP[{}])]&];

    (* If there are more than one sample being labeled, show the table with headings on the top. *)
    (* If there is only one sample being labeled, show the table with the headings on the side *)
    If[Length[labels] > 1,
        PlotTable[
            Transpose[tableHeadingsValuesPairs[[All, 2]]],
            TableHeadings -> {None, tableHeadingsValuesPairs[[All, 1]]},
            Background -> Experiment`Private`tableBackground[labels, IncludeHeader -> True],
            ItemSize -> 20,
            Alignment -> Center
        ],
        PlotTable[
            tableHeadingsValuesPairs[[All, 2]],
            TableHeadings -> {tableHeadingsValuesPairs[[All, 1]], None},
            Background -> Experiment`Private`tableBackground[labels, IncludeHeader -> False],
            ItemSize -> {{All, 30}},
            Alignment -> Center
        ]
    ]
];

(* transferUnitOperationPrimaryData *)

Authors[transferUnitOperationPrimaryData]:={"tyler.pabst"};

transferUnitOperationPrimaryData[
    outputUnitOpPacket_Association
] := Module[
    {
        (* Initial lookup from unit operation object *)
        gridFormat, protocol, preparation, sourceLinks, sourceLabels, destinationLinks, destinationLabels, sourceContainerLabels, destinationContainerLabels, sourceContainers,
        destinationContainers, sourceWells, destinationWells, transferEnvironments, multichannelTransferBools, balances, weighingContainers, tareWeights, tareData,
        tareWeightAppearances, emptyContainerWeights, emptyContainerWeightData, emptyContainerWeightAppearances, measuredTransferWeights, measuredTransferWeightData,
        measuredTransferWeightAppearances, residueWeights, residueWeightData, residueWeightAppearances, materialLossWeights, materialLossWeightData, materialLossWeightAppearances,
        maxWeightVariations, maxTareWeightVariations, tolerances, uncorrectedPercentTransferred, quantitativeTransferBools, quantitativeTransferWashSolutions,
        quantitativeTransferWashVolumes, numbersOfQuantitativeTransferWashes, funnels, instruments, uncorrectedTips, intermediateContainers, intermediateFunnels,
        backfillGases, backfillNeedles, needles,

        (* Big download and subsequent parsing *)
        streamPackets, uncorrectedBatchedUnitOperationPackets, uncorrectedPipetteDialPicturePackets, procedureEventPackets, tareWeightAppearancePackets,
        emptyContainerWeightAppearancePackets, measuredTransferWeightAppearancePackets, residueWeightAppearancePackets, materialLossWeightAppearancePackets, balancePackets,
        tareDataPackets, emptyContainerWeightDataPackets, measuredTransferWeightDataPackets, residueWeightDataPackets, materialLossWeightDataPackets, sourceContainerModels,
        sourceModels, destinationContainerModels, destinationModels, transferEnvironmentModels, weighingContainerModels, funnelModels, instrumentModels, uncorrectedTipModels,
        intermediateContainerModels, intermediateFunnelModels, quantitativeTransferWashSolutionModels, backfillNeedleModels, needleModels,

        (* Corrected values for multichannel transfers *)
        roboticQ, percentTransferred, tips, tipModels, pipetteDialImagePackets, pipetteDialPicturePackets, multichannelTransferGroupings,

        (* Click-to-copy buttons for objects *)
        balanceModels, balanceResolutions, buildObjectButtons, sourceContainerButtons, sourceSampleButtons, destinationContainerButtons, destinationSampleButtons,
        transferEnvironmentButtons, funnelButtons, instrumentButtons, tipButtons, intermediateContainerButtons, intermediateFunnelButtons, quantitativeTransferWashSolutionButtons,
        balanceButtons, weighingContainerButtons, backfillNeedleButtons, needleButtons,

        (* Image objects *)
        pipetteDialImageObjects, pipetteDialPictureObjects, tareWeightAppearanceObjects, emptyContainerWeightAppearanceObjects, measuredTransferWeightAppearanceObjects,
        residueWeightAppearanceObjects, materialLossWeightAppearanceObjects,

        (* Variable length padding, transfer amount resolution, and weight appearances *)
        requestedTransferAmounts, massTransferIndices, padIndexMatchedList, paddedPipetteDialImageObjects, paddedPipetteDialPictureObjects,
        paddedTareWeightAppearanceObjects, paddedContainerWeightAppearanceObjects, paddedTransferWeightAppearanceObjects, paddedResidueWeightAppearanceObjects,
        paddedMaterialLossAppearanceObjects, paddedTareData, paddedEmptyContainerWeightData, paddedMeasuredTransferWeightData, paddedResidueWeightData,
        paddedMaterialLossWeightData, paddedQuantitativeTransferWashSolutionButtons, paddedTareDataPackets, paddedEmptyContainerWeightDataPackets,
        paddedMeasuredTransferWeightDataPackets, paddedResidueWeightDataPackets, paddedMaterialLossWeightDataPackets, paddedTareWeights, paddedTransferWeights,
        paddedContainerWeights, paddedResidueWeights, paddedMaterialLossWeights, paddedMaxWeightVariations, paddedMaxTareWeightVariations, paddedTolerances,
        paddedPercentTransferred, paddedSourceContainers, paddedDestinationContainers, paddedSourceContainerButtons, paddedDestinationContainerButtons,
        paddedSourceContainerLabels, paddedDestinationContainerLabels, actualTransferAmounts, actualTransferAmountsFormatted, getWeightAppearance,
        pipetteDialImageImages, pipetteDialPictureImages, tareWeightImages, emptyContainerImages, measuredTransferWeightImages, residueWeightImages, materialLossImages,

        (* Streans *)
        dateRangeToStreamLookup, streamToStartTimeLookup, buildStreamTuples, tareWeightStreamTuples, containerWeightStreamTuples, measuredTransferWeightStreamTuples,
        residueWeightStreamTuples, materialLossWeightStreamTuples, procedureTaskStartPackets, transferManipulationsBranchingDates, expectedBranchingQ, pipetteOnlyQ,
        transferTaskIDP, summaryStreamButtonTuplesWithDates, summaryStreamTuples, summaryStreamButtons,

        (* Output *)
        autogeneratedSampleLabelP, autogeneratedContainerLabelP, transferDataTables, clickableSourcesForSummary, clickableDestinationsForSummary
    },

    (* Initial setup: Setup grid formatting options *)
    gridFormat = {
        Background -> Experiment`Private`tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, {Left}}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
        Dividers -> {
            {{Directive[Opacity[0]]}},
            {
                Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]]
                }
            }
        }
    };

    (* Get the relevant info from the transfer output unit op packet. *)
    {
        (* Basic info *)
        protocol,
        preparation,
        sourceLinks,
        sourceLabels,
        destinationLinks,
        destinationLabels,
        sourceContainerLabels,
        destinationContainerLabels,
        sourceContainers,
        destinationContainers,
        sourceWells,
        destinationWells,
        transferEnvironments,
        multichannelTransferBools,
        (* Weighing *)
        balances,
        weighingContainers,
        tareWeights,
        tareData,
        tareWeightAppearances,
        emptyContainerWeights,
        emptyContainerWeightData,
        emptyContainerWeightAppearances,
        measuredTransferWeights,
        measuredTransferWeightData,
        measuredTransferWeightAppearances,
        residueWeights,
        residueWeightData,
        residueWeightAppearances,
        materialLossWeights,
        materialLossWeightData,
        materialLossWeightAppearances,
        maxWeightVariations,
        maxTareWeightVariations,
        tolerances,
        (* Liquid percent transferred *)
        uncorrectedPercentTransferred,
        (* Quantitative Transfer *)
        quantitativeTransferBools,
        quantitativeTransferWashSolutions,
        quantitativeTransferWashVolumes,
        numbersOfQuantitativeTransferWashes,
        (* Transfer aids *)
        funnels,
        instruments,
        uncorrectedTips,
        intermediateContainers,
        intermediateFunnels,
        (* Hermetic *)
        backfillGases,
        backfillNeedles,
        needles
    } = Lookup[outputUnitOpPacket,
        {
            (* Basic info *)
            Subprotocol,
            Preparation,
            SourceLink,
            SourceLabel,
            DestinationLink,
            DestinationLabel,
            SourceContainerLabel,
            DestinationContainerLabel,
            SourceContainer,
            DestinationContainer,
            SourceWell,
            DestinationWell,
            TransferEnvironment,
            MultichannelTransfer,
            (* Weighing *)
            Balance,
            WeighingContainerLink,
            TareWeights,
            TareData,
            TareWeightAppearances,
            EmptyContainerWeights,
            EmptyContainerWeightData,
            EmptyContainerWeightAppearances,
            MeasuredTransferWeights,
            MeasuredTransferWeightData,
            MeasuredTransferWeightAppearances,
            ResidueWeights,
            ResidueWeightData,
            ResidueWeightAppearances,
            MaterialLossWeights,
            MaterialLossWeightData,
            MaterialLossWeightAppearances,
            MaxWeightVariation,
            MaxTareWeightVariation,
            Tolerance,
            (* Liquid percent transferred *)
            PercentTransferred,
            (* Quantitative Transfer *)
            QuantitativeTransfer,
            QuantitativeTransferWashSolutionLink,
            QuantitativeTransferWashVolume,
            NumberOfQuantitativeTransferWashes,
            (* Transfer aids *)
            Funnel,
            InstrumentLink,
            Tips,
            IntermediateContainerLink,
            IntermediateFunnel,
            (* Hermetic *)
            BackfillGas,
            BackfillNeedle,
            Needle
        }
    ];

    (* Download info from the weight data and download Models for various fields that we want to display. *)
    {
        streamPackets,
        uncorrectedBatchedUnitOperationPackets,
        uncorrectedPipetteDialPicturePackets,
        procedureEventPackets,
        tareWeightAppearancePackets,
        emptyContainerWeightAppearancePackets,
        measuredTransferWeightAppearancePackets,
        residueWeightAppearancePackets,
        materialLossWeightAppearancePackets,
        balancePackets,
        tareDataPackets,
        emptyContainerWeightDataPackets,
        measuredTransferWeightDataPackets,
        residueWeightDataPackets,
        materialLossWeightDataPackets,
        sourceContainerModels,
        sourceModels,
        destinationContainerModels,
        destinationModels,
        transferEnvironmentModels,
        weighingContainerModels,
        funnelModels,
        instrumentModels,
        uncorrectedTipModels,
        intermediateContainerModels,
        intermediateFunnelModels,
        quantitativeTransferWashSolutionModels,
        backfillNeedleModels,
        needleModels
    } = Flatten /@ Quiet[
        Download[
            {
                {protocol},
                {protocol},
                {protocol},
                {protocol},
                tareWeightAppearances,
                emptyContainerWeightAppearances,
                measuredTransferWeightAppearances,
                residueWeightAppearances,
                materialLossWeightAppearances,
                balances,
                tareData,
                emptyContainerWeightData,
                measuredTransferWeightData,
                residueWeightData,
                materialLossWeightData,
                sourceContainers,
                sourceLinks,
                destinationContainers,
                destinationLinks,
                transferEnvironments,
                weighingContainers,
                funnels,
                instruments,
                uncorrectedTips,
                intermediateContainers,
                intermediateFunnels,
                quantitativeTransferWashSolutions,
                backfillNeedles,
                needles
            },
            {
                {Packet[Streams[StartTime, EndTime]]},
                {Packet[BatchedUnitOperations[PipetteDialImage, PercentTransferred, DestinationLink, Tips]]},
                {Packet[BatchedUnitOperations[PipetteDialPicture][UncroppedImageFile, DateCreated]]},
                {Packet[ProcedureLog[{Object, TaskID, DateCreated, EventType}]]},
                {Packet[UncroppedImageFile, DateCreated]},
                {Packet[UncroppedImageFile, DateCreated]},
                {Packet[UncroppedImageFile, DateCreated]},
                {Packet[UncroppedImageFile, DateCreated]},
                {Packet[UncroppedImageFile, DateCreated]},
                {Packet[Model, Resolution]},
                {Packet[WeightLog, WeightStability]},
                {Packet[WeightLog, WeightStability, BalanceTareWeight]},
                {Packet[WeightLog, WeightStability, BalanceTareWeight]},
                {Packet[WeightLog, WeightStability, BalanceTareWeight]},
                {Packet[WeightLog, WeightStability]},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model},
                {Model}
            }
        ],
        {Download::FieldDoesntExist}
    ];

    (* Set a flag for whether this is a robotic transfer. *)
    roboticQ = MatchQ[preparation, Robotic];

    (* Check whether any manual multichannel transfers occurred. If so, certain variables will be of unexpected lengths and need to be corrected. *)
    {
        tips,
        tipModels,
        percentTransferred,
        pipetteDialImagePackets,
        pipetteDialPicturePackets,
        multichannelTransferGroupings
    } = If[roboticQ || FreeQ[multichannelTransferBools, True],
        (* If there are no manual multichannel transfers, no corrections are necessary. *)
        {
            uncorrectedTips,
            uncorrectedTipModels,
            uncorrectedPercentTransferred,
            uncorrectedBatchedUnitOperationPackets,
            uncorrectedPipetteDialPicturePackets,
            ConstantArray[Null, Length[uncorrectedTips]]
        },
        (* If there are multichannel transfers, map over the resulting packets and correct the length of each field. *)
        Module[
            {
                correctedTipObjects, tipObjectsToModelsLookup, correctedTipModels, channelsPerTransfer, expandForMultichannel,
                correctedPercentTransferred, correctedPipetteDialImagePackets, correctedPipetteDialPicturePackets, transferGroupings
            },

            (* For the tip objects, just lookup from the batched UO packets *)
            correctedTipObjects = Download[Flatten[Lookup[uncorrectedBatchedUnitOperationPackets, Tips]], Object];

            (* Make a lookup from the tip objects to models. *)
            tipObjectsToModelsLookup = DeleteDuplicates[
                MapThread[
                    #1 -> #2&,
                    Download[{uncorrectedTips, uncorrectedTipModels}, Object]
                ]
            ];

            (* Use the lookup to get the corrected tip models. *)
            correctedTipModels = correctedTipObjects /. tipObjectsToModelsLookup;

            (* Get the number of channels per batched unit operation. *)
            channelsPerTransfer = Map[Length[Lookup[#, DestinationLink]]&, uncorrectedBatchedUnitOperationPackets];

            (* Write a helper to pad out the lists according to the number of channels used in the transfer. *)
            expandForMultichannel[myVariableList_List, myChannelCounts:{_Integer..}] := Flatten[
                MapThread[
                    Function[
                        {value, channels},
                        If[SameQ[channels, 1], value, ConstantArray[value, channels]]
                    ],
                    {myVariableList, myChannelCounts}
                ]
            ];

            (* Map the helper over the remaining variables. *)
            {
                correctedPercentTransferred,
                correctedPipetteDialImagePackets,
                correctedPipetteDialPicturePackets
            } = Map[expandForMultichannel[#, channelsPerTransfer]&,
                {
                    uncorrectedPercentTransferred,
                    uncorrectedBatchedUnitOperationPackets,
                    uncorrectedPipetteDialPicturePackets
                }
            ];

            (* We should tell the user which transfers were grouped together for multichannel transfers. Resolve that here *)
            transferGroupings = MapThread[
                Function[
                    {channels, index},
                    Sequence @@ If[SameQ[index, 1],
                        ConstantArray[Range[channels], channels],
                        ConstantArray[Range[channels] + Total[Take[channelsPerTransfer, index - 1]],
                            channels]
                    ]
                ],
                {channelsPerTransfer, Range[Length[channelsPerTransfer]]}
            ];

            (* Return the new lists. *)
            {
                correctedTipObjects,
                correctedTipModels,
                correctedPercentTransferred,
                correctedPipetteDialImagePackets,
                correctedPipetteDialPicturePackets,
                transferGroupings
            }
        ]
    ];

    (* Get the models and resolutions for the balances, if any. *)
    {balanceModels, balanceResolutions} = Transpose[Lookup[# /. Null -> <||>, {Model, Resolution}, Null]& /@ balancePackets];

    (* In the lower table that provides details on the transfer, we want to make clickable buttons for each Object that *)
    (* copy the specific Object upon clicking but also display the Object's Model in the tooltip. If we don't have the *)
    (* Model, just keep this as the object and we'll run customButton on it later. Start by defining a helper to do this. *)
    buildObjectButtons[myObjects:Alternatives[{(ObjectP[Object]|Null)..}, {}], myModels:{(ObjectP[Model]|Null)..}] := If[
        (* If there are no objects in this field or if the length of the Models field doesn't match, just output the objects. *)
        !SameLengthQ[myObjects, myModels] || FreeQ[myObjects, ObjectP[Object]],
            myObjects,
            (* Otherwise, build the buttons. *)
            MapThread[
                Function[
                    {object, model},
                    If[MatchQ[model, ObjectP[Model]],
                        customButton[object, CopyContent -> object, Tooltip -> Column[{ToString[model], "Click to copy Object"}, Alignment -> {Center, Baseline}]],
                        object
                    ]
                ],
                {Download[myObjects, Object], NamedObject[myModels]}
            ]
    ];

    (* Map the above helper over the paired object and model lists to generate the buttons. *)
    {
        sourceContainerButtons,
        sourceSampleButtons,
        destinationContainerButtons,
        destinationSampleButtons,
        transferEnvironmentButtons,
        funnelButtons,
        instrumentButtons,
        tipButtons,
        intermediateContainerButtons,
        intermediateFunnelButtons,
        quantitativeTransferWashSolutionButtons,
        balanceButtons,
        weighingContainerButtons,
        backfillNeedleButtons,
        needleButtons
    } = Map[buildObjectButtons[Apply[Sequence, #]]&,
        {
            {sourceContainers, sourceContainerModels},
            {sourceLinks, sourceModels},
            {destinationContainers, destinationContainerModels},
            {destinationLinks, destinationModels},
            {transferEnvironments, transferEnvironmentModels},
            {funnels, funnelModels},
            {instruments, instrumentModels},
            {tips, tipModels},
            {intermediateContainers, intermediateContainerModels},
            {intermediateFunnels, intermediateFunnelModels},
            {quantitativeTransferWashSolutions, quantitativeTransferWashSolutionModels},
            {balances, balanceModels},
            {weighingContainers, weighingContainerModels},
            {backfillNeedles, backfillNeedleModels},
            {needles, needleModels}
        }
    ];

    (* Get the pipette dial images - these are the cartoons shown in instructions. PipetteDialPicture contains the photos of the real thing. *)
    pipetteDialImageObjects = Lookup[# /. Null -> <||>, PipetteDialImage, Null]& /@ pipetteDialImagePackets;

    (* Get the objects from the image-containing packets *)
    {
        pipetteDialPictureObjects,
        tareWeightAppearanceObjects,
        emptyContainerWeightAppearanceObjects,
        measuredTransferWeightAppearanceObjects,
        residueWeightAppearanceObjects,
        materialLossWeightAppearanceObjects
    } = Lookup[# /. Null -> <||>, UncroppedImageFile, Null]& /@ {
        pipetteDialPicturePackets,
        tareWeightAppearancePackets,
        emptyContainerWeightAppearancePackets,
        measuredTransferWeightAppearancePackets,
        residueWeightAppearancePackets,
        materialLossWeightAppearancePackets
    };

    (* Get the requested transfer amounts, accounting for split fields. *)
    requestedTransferAmounts = Module[{allAmountFormats},
        allAmountFormats = Lookup[outputUnitOpPacket, {AmountExpression, AmountInteger, AmountVariableUnit}];
        Map[FirstCase[#, Except[Null]]&, Transpose[allAmountFormats]]
    ];

    (* Get the indices at which mass is being transferred. *)
    massTransferIndices = MapThread[
        Function[
            {requestedTransferAmount, balance, index},
            (* If the requested amount is a mass, or if there is a balance object or model at this index, return the index. *)
            If[MassQ[requestedTransferAmount] || !NullQ[balance],
                index,
                Nothing
            ]
        ],
        {requestedTransferAmounts, balances, Range[Length[requestedTransferAmounts]]}
    ];

    (* If any of the weight variables are not the correct length, pad them appropriately so that we can map over them as needed. *)
    padIndexMatchedList[myList_List, myReferenceList_List] := If[EqualQ[Length[myList], Length[myReferenceList]],
        myList,
        Module[
            {notNullElements},

            (* Find any non-Null items in the list, which we expect to be either weights or images. *)
            notNullElements = Cases[myList, Except[Null]];

            (* Make a flat list of Nulls and then insert the weights or images at the mass transfer indices. *)
            ReplacePart[
                ConstantArray[Null, Length[myReferenceList]],
                massTransferIndices -> notNullElements
            ] /. {{} -> Null}
        ]
    ];

    (* Pad out any variables that might not already have the correct length. *)
    {
        paddedPipetteDialImageObjects,
        paddedPipetteDialPictureObjects,
        paddedTareWeightAppearanceObjects,
        paddedContainerWeightAppearanceObjects,
        paddedTransferWeightAppearanceObjects,
        paddedResidueWeightAppearanceObjects,
        paddedMaterialLossAppearanceObjects,
        paddedTareData,
        paddedEmptyContainerWeightData,
        paddedMeasuredTransferWeightData,
        paddedResidueWeightData,
        paddedMaterialLossWeightData,
        paddedQuantitativeTransferWashSolutionButtons,
        paddedTareDataPackets,
        paddedEmptyContainerWeightDataPackets,
        paddedMeasuredTransferWeightDataPackets,
        paddedResidueWeightDataPackets,
        paddedMaterialLossWeightDataPackets,
        paddedTareWeights,
        paddedTransferWeights,
        paddedContainerWeights,
        paddedResidueWeights,
        paddedMaterialLossWeights,
        paddedMaxWeightVariations,
        paddedMaxTareWeightVariations,
        paddedTolerances,
        paddedPercentTransferred,
        paddedSourceContainers,
        paddedDestinationContainers,
        paddedSourceContainerButtons,
        paddedDestinationContainerButtons,
        paddedSourceContainerLabels,
        paddedDestinationContainerLabels
    } = Map[
        padIndexMatchedList[ToList[#], quantitativeTransferBools]&,
        {
            pipetteDialImageObjects,
            pipetteDialPictureObjects,
            tareWeightAppearanceObjects,
            emptyContainerWeightAppearanceObjects,
            measuredTransferWeightAppearanceObjects,
            residueWeightAppearanceObjects,
            materialLossWeightAppearanceObjects,
            tareData,
            emptyContainerWeightData,
            measuredTransferWeightData,
            residueWeightData,
            materialLossWeightData,
            quantitativeTransferWashSolutionButtons,
            tareDataPackets,
            emptyContainerWeightDataPackets,
            measuredTransferWeightDataPackets,
            residueWeightDataPackets,
            materialLossWeightDataPackets,
            tareWeights,
            measuredTransferWeights,
            emptyContainerWeights,
            residueWeights,
            materialLossWeights,
            maxWeightVariations,
            maxTareWeightVariations,
            tolerances,
            percentTransferred,
            sourceContainers,
            destinationContainers,
            sourceContainerButtons,
            destinationContainerButtons,
            sourceContainerLabels,
            destinationContainerLabels
        }
    ];

    (* Determine the actual transfer amounts for solid and liquid transfers. *)
    actualTransferAmounts = If[roboticQ,

        (* if it is robotic, there is no actual transfer amount measured so skip this *)
        ConstantArray[Null, Length[requestedTransferAmounts]],

        (* If it is not robotic, we can get either the percent transferred (liquid) or the measured weight of the transferred material (solid) *)
        Module[
            {emptyContainerRetareWeights, measuredTransferRetareWeights, residueRetareWeights, destinationTransfersIn, filteredTransfersIn, transfersAccountedFor},

            (* Get any relevant retare values. Replace any Nulls with 0 Gram. *)
            (* We'll only use these values if we can't get what we need from the TransfersIn. *)
            {emptyContainerRetareWeights, measuredTransferRetareWeights, residueRetareWeights} = Map[
                If[MemberQ[#, PacketP[]],
                    Module[{modifiedPackets, massValues},
                        modifiedPackets = #[[massTransferIndices]] /. Null -> <||>;
                        massValues = Lookup[modifiedPackets, BalanceTareWeight, 0 Gram];
                        ReplacePart[
                            ConstantArray[0 Gram, Length[quantitativeTransferBools]],
                            MapThread[#1 -> #2 &, {massTransferIndices, massValues}]
                        ]
                    ],
                    ConstantArray[0 Gram, Length[quantitativeTransferBools]]
                ]&,
                {paddedEmptyContainerWeightDataPackets, paddedMeasuredTransferWeightDataPackets, paddedResidueWeightDataPackets}
            ];

            (* Download the TransfersIn from the destinationLinks. *)
            destinationTransfersIn = Download[destinationLinks, TransfersIn];

            (* Filter the TransfersIn such that they only include transfers performed in the present transfer unit operation. *)
            filteredTransfersIn = Map[
                Cases[#, {_, _, _, ObjectP[protocol], _}]&,
                destinationTransfersIn
            ];

            (* Initialize a list of transfers that we've already accounted for. *)
            transfersAccountedFor = {};

            (* Map over the relevant variables and identify the correct transfer amount in each case. *)
            MapThread[
                Function[
                    {
                        requestedAmount,
                        tolerance,
                        quantWashQ,
                        quantWashNumber,
                        quantWashVolume,
                        transfersInPerDestination,
                        measuredTransferWeight,
                        measuredTransferWeightRetareWeight,
                        emptyContainerWeight,
                        emptyContainerWeightRetareWeight,
                        residueWeight,
                        residueWeightRetareWeight,
                        balanceResolution,
                        percent
                    },
                    Module[
                        {toleranceRange, toleranceDefinedQ, totalQuantWashVolume, transferToUse, possibleTransfers, amount},

                        (* Define the tolerance range for each *)
                        toleranceRange = If[NullQ[tolerance], Null, RangeP[requestedAmount - tolerance, requestedAmount + tolerance]];
                        toleranceDefinedQ = !NullQ[toleranceRange];

                        (* Define the expected quantitative transfer wash volume. *)
                        totalQuantWashVolume = If[TrueQ[quantWashQ], EqualP[quantWashNumber * quantWashVolume], Null];

                        (* Exclude any transfer events we have already used to assign a transferred amount. *)
                        possibleTransfers = UnsortedComplement[ToList[transfersInPerDestination], transfersAccountedFor];

                        (* Find the transfer which corresponds to the present amount. *)
                        transferToUse = Which[
                            (* If All is requested, use the first All (instead of Partial) transfer. *)
                            MatchQ[requestedAmount, All],
                                FirstCase[possibleTransfers, {_, _, _, _, All}, {}],
                            (* TransfersIn doesn't record masses for itemized (e.g., tablets) so return an empty list and resolve this later. *)
                            MatchQ[requestedAmount, _Integer],
                                {},
                            (* If a tolerance range is defined, get the first possible transfer of a quantity within that range. *)
                            toleranceDefinedQ,
                                FirstCase[possibleTransfers, {_, toleranceRange, _, _, _}, {}],
                            (* If there is no quant wash at this index, take the first transfer with a value that matches the requested amount. *)
                            !quantWashQ,
                                FirstCase[possibleTransfers, {_, EqualP[requestedAmount], _, _, _}, {}],
                            (* If there is quant wash at this index and the quant wash volume and requested amount *)
                            (* are different, take the first transfer which transfers the requested amount. *)
                            !EqualQ[requestedAmount, totalQuantWashVolume],
                                FirstCase[possibleTransfers, {_, EqualP[requestedAmount], _, _, _}, {}],
                            (* If the requested amount and the quant wash volume happen to be equal, check whether one of these transfers *)
                            (* was uploaded at the same time as a previous transfer, and exclude this because it is a quant wash. *)
                            True,
                                Module[
                                    {requestedAmountTransfers, possibleTransferTimes, previousTransferTimes, quantWashTransfersToExclude},
                                    (* Get all transfers which transfer the requested amount. *)
                                    requestedAmountTransfers = Cases[possibleTransfers, {_, EqualP[requestedAmount], _, _, _}];
                                    (* The times are in the first index. Get these for the possible transfers as well as the previous transfers. *)
                                    possibleTransferTimes = requestedAmountTransfers[[All, 1]];
                                    previousTransferTimes = If[!MatchQ[transfersAccountedFor, {}], transfersAccountedFor[[All, 1]], {}];
                                    (* Find any transfer parsed at the same time and exclude these. *)
                                    quantWashTransfersToExclude = PickList[requestedAmountTransfers, possibleTransferTimes, Alternatives @@ previousTransferTimes];
                                    (* If we found any transfers to exclude (likely just one transfer) exclude these from the possibilities. *)
                                    If[MatchQ[quantWashTransfersToExclude, {}],
                                        {},
                                        (
                                            AppendTo[transfersAccountedFor, #]& /@ quantWashTransfersToExclude;
                                            FirstCase[possibleTransfers, {_, EqualP[requestedAmount], _, _, _}, {}]
                                        )
                                    ]
                                ]
                        ];

                        (* If we found a transfer to use, pull the value out and append the transfer to transfersAccountedFor so we don't use it again. *)
                        amount = If[!MatchQ[transferToUse, {}],
                            (
                                AppendTo[transfersAccountedFor, transferToUse];
                                transferToUse[[2]]
                            ),

                            (* Otherwise, calculate the amount transferred using the available data. *)
                            Which[
                                (* If QuantitativeTransfer is True, subtract the container weight from the weight of container and sample together. *)
                                TrueQ[quantWashQ],
                                    (measuredTransferWeight - measuredTransferWeightRetareWeight) - (emptyContainerWeight - emptyContainerWeightRetareWeight),
                                (* If there is no measured transfer weight, this is either Amount -> All or it's not a mass transfer. Return Null. *)
                                NullQ[measuredTransferWeight],
                                    Null,
                                (* If there is no empty container weight or residue weight, this is an old protocol that didn't use those fields. *)
                                (* For backwards compatibility, just use the MeasuredTransferWeight, which previously used to provide the actual weight. *)
                                NullQ[emptyContainerWeight] && NullQ[residueWeight],
                                    (measuredTransferWeight - measuredTransferWeightRetareWeight),
                                (* If there is a transfer weight but no residue weight, we're weighing directly into the destination without a weigh boat/funnel. *)
                                NullQ[residueWeight],
                                    (measuredTransferWeight - measuredTransferWeightRetareWeight) - (emptyContainerWeight - emptyContainerWeightRetareWeight),
                                (* Otherwise, this is a mass transfer with QuantitativeTransfer turned off. Subtract residue weight from the transfer weight. *)
                                True,
                                    (measuredTransferWeight - measuredTransferWeightRetareWeight) - (residueWeight - residueWeightRetareWeight)
                            ]
                        ];

                        (* Reformat this value as needed. *)
                        Which[
                            (* If the user requested All for a mass transfer and weight data is known, use the calculated weight with appropriate units. *)
                            MassQ[amount] && MatchQ[requestedAmount, All] && MassQ[balanceResolution],
                                UnitScale @ Round[amount, balanceResolution],
                            (* If the user requested All and a mass isn't available, return All. *)
                            MatchQ[requestedAmount, All],
                                All,
                            (* If there is a requested quantity for a mass transfer, express the actual mass in the desired units. *)
                            MassQ[amount] && MassQ[balanceResolution],
                                Convert[Round[amount, balanceResolution], Units[requestedAmount]],
                            (* If we have a percent for a liquid transfer, use that. *)
                            MatchQ[percent, PercentP] && MatchQ[requestedAmount, VolumeP],
                                percent,
                            (* If there is an amount but it does not have a Mass pattern (e.g. if it is a distribution) use that value. *)
                            !NullQ[amount],
                                amount,
                            (* We shouldn't end up here, but just in case. *)
                            True,
                                Null
                        ]
                    ]
                ],
                {
                    requestedTransferAmounts,
                    paddedTolerances,
                    quantitativeTransferBools,
                    numbersOfQuantitativeTransferWashes,
                    quantitativeTransferWashVolumes,
                    filteredTransfersIn,
                    paddedTransferWeights,
                    measuredTransferRetareWeights,
                    paddedContainerWeights,
                    emptyContainerRetareWeights,
                    paddedResidueWeights,
                    residueRetareWeights,
                    balanceResolutions,
                    paddedPercentTransferred
                }
            ]
        ]
    ];

    (* Get the actual amounts in the correct format using UnitForm or unitFormDistribution. *)
    actualTransferAmountsFormatted = MapThread[
        Function[
            {recordedAmount, balanceResolution},
            Which[
                (* If this is a quantity rather than a distribution, use UnitForm. *)
                QuantityQ[recordedAmount], UnitForm[recordedAmount, Brackets -> False],
                (* If the balance resolution is known, this is a solid transfer; use unitFormDistribution and consider the balance resolution. *)
                !MatchQ[recordedAmount, Null|All] && !NullQ[balanceResolution], Experiment`Private`unitFormDistribution[recordedAmount, Resolution -> balanceResolution],
                (* Otherwise, just use the amount however it is currently formatted. *)
                True, recordedAmount
            ]
        ],
        {actualTransferAmounts, balanceResolutions}
    ];

    (* Quick helper to import images and shrink them to display in tooltips *)
    getWeightAppearance[imageList_List] := If[MemberQ[imageList, ObjectP[Object[EmeraldCloudFile]]],
        Module[
            {safeImageList},
            safeImageList = Map[If[MatchQ[#, EmeraldCloudFileP], #, Null]&, imageList];
            Map[
                If[NullQ[#], #, Image[ImageResize[#, $ReviewImageResolution], ImageSize -> $ReviewImageSize]]&,
                ImportCloudFile[safeImageList]
            ]
        ],
        ConstantArray[Null, Length[imageList]]
    ];

    (* Map the helpers over the various types of weight appearances. *)
    {
        pipetteDialImageImages,
        pipetteDialPictureImages,
        tareWeightImages,
        emptyContainerImages,
        measuredTransferWeightImages,
        residueWeightImages,
        materialLossImages
    } = Map[
        getWeightAppearance,
        {
            paddedPipetteDialImageObjects,
            paddedPipetteDialPictureObjects,
            paddedTareWeightAppearanceObjects,
            paddedContainerWeightAppearanceObjects,
            paddedTransferWeightAppearanceObjects,
            paddedResidueWeightAppearanceObjects,
            paddedMaterialLossAppearanceObjects
        }
    ];

    (* Establish threads between (1) the date range of each stream object and the object itself and (2) the stream object to its start date. *)
    dateRangeToStreamLookup = If[MatchQ[streamPackets, {Null...}],
        {},
        MapThread[
            (RangeP[#1, #2 + 5 Minute] -> #3)&,
            Transpose @ Lookup[streamPackets, {StartTime, EndTime, Object}]
        ]
    ];
    streamToStartTimeLookup = If[MatchQ[streamPackets, {Null...}],
        {},
        MapThread[
            (#1 -> #2)&,
            Transpose @ Lookup[streamPackets, {Object, StartTime}]
        ]
    ];

    (* Quick helper to generate tuples of stream objects and time stamps which open the relevant stream *)
    (* while a weighing event occurs. We only do this if we have streams AND weight appearance objects. *)
    buildStreamTuples[myWeightAppearancePackets:{(PacketP[Object[Data, Appearance]]|Null)...}] := If[FreeQ[myWeightAppearancePackets, PacketP[]] || MatchQ[streamPackets, {}],
        ConstantArray[{Null, Null}, Length[actualTransferAmountsFormatted]],
        Module[
            {weightAppearanceDatesCreated, streamsByIndex, streamVideoTimes},

            (* Get the DateCreated for each weight appearance object and the start times for each stream. *)
            weightAppearanceDatesCreated = Lookup[myWeightAppearancePackets /. Null -> <||>, DateCreated, Null];

            (* Use the date range to stream object thread to get the relevant streams at each index. *)
            (* If we don't find a stream, we'll have a date object instead. Replace that with Null. *)
            streamsByIndex = Map[
                If[DateObjectQ[#], Null, #]&,
                weightAppearanceDatesCreated /. dateRangeToStreamLookup
            ];

            (* Get the time elapsed from the start of the stream in seconds for each weighing event. *)
            streamVideoTimes = MapThread[
                Function[
                    {stream, weightDateCreated},
                    (* If we didn't find a stream for this weighing event, leave this as Null. *)
                    If[NullQ[stream],
                        Null,
                        Module[
                            {streamStartTimeByIndex, watchProtocolTime},

                            (* Find the time at which the relevant stream started. *)
                            streamStartTimeByIndex = stream /. streamToStartTimeLookup;

                            (* Subtract the date created from the weight appearance object from the stream start date and convert *)
                            (* this value to seconds before stripping the units off. This is for the time argument to WatchProtocol. *)
                            (* Finally subtract 5 seconds, since the weight appearance object is created shortly after weighing. *)
                            watchProtocolTime = Floor[Unitless[Convert[weightDateCreated - streamStartTimeByIndex, Second]]] - 5
                        ]
                    ]
                ],
                {streamsByIndex, weightAppearanceDatesCreated}
            ];

            (* Return the {object, time} tuples. *)
            Transpose[{streamsByIndex, streamVideoTimes}]
        ]
    ];

    (* Build all the stream tuples, which we'll feed into WatchProtocol. *)
    {
        tareWeightStreamTuples,
        containerWeightStreamTuples,
        measuredTransferWeightStreamTuples,
        residueWeightStreamTuples,
        materialLossWeightStreamTuples
    } = Map[
        buildStreamTuples,
        {
            tareWeightAppearancePackets,
            emptyContainerWeightAppearancePackets,
            measuredTransferWeightAppearancePackets,
            residueWeightAppearancePackets,
            materialLossWeightAppearancePackets
        }
    ];

    (* Drop all the procedure events that do not have EventType -> TaskStart. We only need to do this for Manual. *)
    procedureTaskStartPackets = If[roboticQ,
        {},
        PickList[procedureEventPackets, Lookup[procedureEventPackets, EventType], TaskStart]
    ];

    (* "Transfer Manipulations Loop" branches 13 different ways depending on the Instrument and Tips fields in the batched UO. *)
    (* To help sort out the timing of events, get the procedure event packet corresponding to this task for each batched UO. *)
    (* Also set a boolean to quickly indicate that we ended up with the expected number of branching tasks. *)
    {transferManipulationsBranchingDates, expectedBranchingQ} = Module[
        {transferManipulationBranchPackets, adjustedPackets},

        (* Start by just finding all the procedure events with the desired task ID. *)
        transferManipulationBranchPackets = PickList[procedureTaskStartPackets, Lookup[procedureTaskStartPackets, TaskID], "1b4ec2e0-3c83-422d-8970-fe1d0a8ded02"];

        (* If there are any multichannel transfers we have to correct for this since we'll have fewer procedure events of *)
        (* the TaskID above than expected. If there are no multichannel transfers, no adjustments should be needed here. *)
        adjustedPackets = If[roboticQ || FreeQ[multichannelTransferBools, True],
            transferManipulationBranchPackets,
            Flatten @ MapThread[
                Function[
                    {eventPacket, batchedUOPacket},
                    (* If there are multiple destinations, multiple channels were used and we have to pad out the event packet accordingly. *)
                    Module[
                        {numberOfChannels},
                        numberOfChannels = Length[Lookup[batchedUOPacket, DestinationLink]];
                        If[SameQ[numberOfChannels, 1],
                            eventPacket,
                            ConstantArray[eventPacket, numberOfChannels]
                        ]
                    ]
                ],
                {transferManipulationBranchPackets, uncorrectedBatchedUnitOperationPackets}
            ]
        ];

        (* Check that this is the correct length. If it's not, we can't reliably use it to find the time stamps. *)
        If[SameLengthQ[adjustedPackets, actualTransferAmountsFormatted],
            {Lookup[adjustedPackets, DateCreated], True},
            {ConstantArray[Null, Length[actualTransferAmountsFormatted]], False}
        ]
    ];

    (* Set a boolean indicating whether all of our transfers are pipette transfers with images populated. *)
    pipetteOnlyQ = MatchQ[pipetteDialPicturePackets, {ObjectP[]..}];

    (* Get the ID which corresponds to a task immediately before the actual transfer. We need to include a lot of different IDs because of all the manipulation branches. *)
    transferTaskIDP = Alternatives @@ {

        (* "Transfer GraduatedCylinder Manipulation" *)
        "584301a3-bfcf-46d1-916f-dc0045467dfb",

        (* "Transfer Syringe No Balance Manipulation" *)
        "b4f31aea-6ecb-4f4d-b423-5f73a49a655a",

        (* "Transfer Syringe Balance Manipulation" *)
        "222979e9-f1c6-46a8-ad29-0e69722b74b6",

        (* "Transfer Pipette No Balance Manipulation" *)
        "72f98b05-1992-4253-9307-48c4806f4c7a",

        (* "Transfer Pipette Balance Slurry Transfer" *)
        "23c4b5ad-902e-4f6e-8171-2cc685bdf115",

        (* "Transfer Pipette Balance" *)
        "5aa4339b-aa5e-4707-95d8-afdf526ca5d6",

        (* "Transfer BarrelMediaDispenser Manipulation" *)
        "730ed382-af4c-4687-9059-2b410118f219",

        (* "Transfer to VolumetricFlask Small Volume Manipulation" *)
        "50aa9730-baa6-4df3-ae56-ee6abca34561",

        (* "Transfer Aspirator Manipulation" *)
        "e0e2450a-78a2-4b01-9dda-e72341602dcd",

        (* "Transfer Beaker Manipulation" *)
        "8e507bb4-f5db-404b-9c2f-629ee2303c7f",

        (* "Transfer Pour Manipulation" *)
        "efcf29d7-ac52-4b68-a77b-5f2e989f27c2",

        (* "Transfer PreRinsing Destination" *)
        "b1cc6aa4-53ef-417f-9faf-b33cd5160b7e",

        (* "Transfer Transfer From WorkingDestination to Destination" *)
        "96cb38c2-7741-4c86-ac3b-81cb7a53cbad"
    };

    (* Generate stream button tuples to show the transfers. The buttons will go in the transfer summary table. *)
    (* Include the date object (not just the time in unitless seconds) so that we can check our work before making the buttons. *)
    summaryStreamButtonTuplesWithDates = If[roboticQ || MatchQ[streamPackets, {}],
        ConstantArray[{Null, Null, Null}, Length[actualTransferAmountsFormatted]],
        MapThread[
            Function[
                {pipetteDialPicturePacket, transferManipulationsBranchingDate},
                Which[

                    (* If we took a photo of the pipette dial at this index, use it's DateCreated to find the correct stream and time point. *)
                    MatchQ[pipetteDialPicturePacket, ObjectP[]],
                        Module[
                            {imageDataDateCreated, relevantStreamPacket},

                            (* Get the image data object's date created. *)
                            imageDataDateCreated = Lookup[pipetteDialPicturePacket, DateCreated, Null];

                            (* Find the stream that was active when the image was created. *)
                            relevantStreamPacket = SelectFirst[streamPackets, MatchQ[imageDataDateCreated, RangeP[Sequence @@ Lookup[#, {StartTime, EndTime}]]]&, Null];

                            (* Build the stream tuple. *)
                            If[NullQ[imageDataDateCreated] || NullQ[relevantStreamPacket],
                                {Null, Null, Null},
                                {
                                    Lookup[relevantStreamPacket, Object],
                                    Unitless[Round[Convert[imageDataDateCreated - Lookup[relevantStreamPacket, StartTime], Second]]],
                                    imageDataDateCreated
                                }
                            ]
                        ],

                    (* If we know the date at which the procedure entered its transfer manipulations branch for this UO, try to build a stream tuple. *)
                    !NullQ[transferManipulationsBranchingDate],
                        Module[
                            {eventPacketCandidates, selectedEventPacket, selectedEventDateCreated, relevantStreamPacket},

                            (* Get every procedure event packet with a task ID that we are interested in. *)
                            eventPacketCandidates = PickList[procedureTaskStartPackets, Lookup[procedureTaskStartPackets, TaskID], transferTaskIDP];

                            (* Get the first event packet that occurred after the branching date. *)
                            selectedEventPacket = SelectFirst[eventPacketCandidates, GreaterQ[Lookup[#, DateCreated], transferManipulationsBranchingDate]&, {}];

                            (* Get the DateCreated for the selcted event. *)
                            selectedEventDateCreated = Lookup[selectedEventPacket, DateCreated, Null];

                            (* Find the stream that was active when the above event was created. *)
                            relevantStreamPacket = SelectFirst[streamPackets, MatchQ[selectedEventDateCreated, RangeP[Sequence @@ Lookup[#, {StartTime, EndTime}]]]&, Null];

                            (* Build the stream tuple. *)
                            If[NullQ[selectedEventDateCreated] || NullQ[relevantStreamPacket],
                                {Null, Null, Null},
                                {
                                    Lookup[relevantStreamPacket, Object],
                                    Unitless[Round[Convert[selectedEventDateCreated - Lookup[relevantStreamPacket, StartTime], Second]]],
                                    selectedEventDateCreated
                                }
                            ]
                        ],

                    (* If we get this far, we don't have enough info to generate a button at this index. *)
                    True,
                        {Null, Null, Null}
                ]
            ],
            {pipetteDialPicturePackets, transferManipulationsBranchingDates}
        ]
    ];

    (* Check that we don't mis-assign a button to a later transfer. Strip off the date (last index) along the way. *)
    summaryStreamTuples = MapThread[
        Function[
            {streamTuple, index},
            Which[
                (* If we only have pipette transfers with images populated, we should have correct time stamps. *)
                pipetteOnlyQ,
                    streamTuple[[1;;2]],
                (* If we're at the final index, there is no risk of misassigning this button to a later batched UO. *)
                MatchQ[index, Length[summaryStreamButtonTuplesWithDates]],
                    streamTuple[[1;;2]],
                (* If the stream tuple is all Nulls, there's nothing we need to do here. *)
                NullQ[streamTuple],
                    {Null, Null},
                (* If transferManipulationsBranchingDates are all date objects, use them to verify that the *)
                (* stream tuple at this index occurs prior to the manipulation branching at the following index. *)
                expectedBranchingQ,
                    If[LessQ[streamTuple[[3]], transferManipulationsBranchingDates[[index + 1]]],
                        streamTuple[[1;;2]],
                        {Null, Null}
                    ],
                (* If we get this far, return Null so there's no chance of us misassigning a button. *)
                True,
                    {Null, Null}
            ]
        ],
        {summaryStreamButtonTuplesWithDates, Range[Length[summaryStreamButtonTuplesWithDates]]}
    ];

    (* Generate the buttons for any index at which we can confidently do so. *)
    summaryStreamButtons = Map[
        Function[
            {streamTuple},
            If[NullQ[streamTuple],
                Null,
                With[
                    {playButtonGraphic = $PlayButtonGraphic, explicitStreamObject = streamTuple[[1]], explicitTimeArg = streamTuple[[2]]},
                    Tooltip[
                        Button[
                            Tooltip[playButtonGraphic, "Play Stream"],
                            WatchProtocol[explicitStreamObject, explicitTimeArg],
                            Method -> "Queued",
                            Appearance -> "Frameless"
                        ],
                        "Play Stream"
                    ]
                ]
            ]
        ],
        summaryStreamTuples
    ];

    (* Generate patterns for automatically generated labels so that we can filter these out of the tables. *)
    autogeneratedSampleLabelP = Alternatives @@ {"transfer source sample ", "transfer destination sample "};
    autogeneratedContainerLabelP = Alternatives @@ {"transfer source container ", "transfer destination container "};

    (* Build the tables with details on each transfer. These are displayed one at a time, and contain different info for solid vs liquid transfers. *)
    transferDataTables = MapThread[
        Function[
            {
                (* Basic info *)
                index,
                sourceContainerLabel,
                destinationContainerLabel,
                sourceLink,
                destinationLink,
                sourceContainer,
                destinationContainer,
                sourceContainerButton,
                destinationContainerButton,
                sourceLabel,
                destinationLabel,
                sourceWell,
                destinationWell,
                sourceSampleButton,
                destinationSampleButton,
                requestedTransferAmount,
                actualTransferAmount,
                transferEnvironmentButton,
                streamButton,

                (* Weighing *)
                balanceButton,
                weighingContainerButton,
                tareWeight,
                tareWeightAppearanceObject,
                tareWeightImage,
                tareWeightDataObject,
                tareWeightStreamTuple,
                emptyContainerWeight,
                emptyContainerWeightAppearanceObject,
                emptyContainerWeightImage,
                emptyContainerWeightDataObject,
                emptyContainerStreamTuple,
                measuredTransferWeight,
                measuredTransferWeightAppearanceObject,
                measuredTransferWeightImage,
                measuredTransferWeightDataObject,
                measuredTransferWeightStreamTuple,
                residueWeight,
                residueWeightAppearanceObject,
                residueWeightImage,
                residueWeightDataObject,
                residueWeightStreamTuple,
                materialLossWeight,
                materialLossWeightAppearanceObject,
                materialLossWeightImage,
                materialLossWeightDataObject,
                materialLossStreamTuple,
                balanceResolution,
                tareDataPacketsPerWeightData,
                emptyContainerWeightDataPacketsPerWeightData,
                measuredTransferWeightDataPacketsPerWeightData,
                residueWeightDataPacketsPerWeightData,
                materialLossWeightDataPacketsPerWeightData,
                maxWeightVariation,
                maxTareWeightVariation,

                (* Transfer aids *)
                funnelButton,
                instrumentButton,
                tipsButton,
                intermediateContainerButton,
                intermediateFunnelButton,
                pipetteDialImageImage,
                pipetteDialPictureImage,
                pipetteDialPictureObject,
                multichannelTransferGrouping,

                (* Quantitative Transfer *)
                quantitativeTransferWashSolutionButton,
                quantitativeTransferWashVolume,
                numberOfQuantitativeTransferWashes,

                (* Hermetic *)
                backfillGas,
                backfillNeedleButton,
                needleButton
            },

            Module[
                {balanceStabilityPlots, tableContent},

                (* Generate balance stability plots if this is a mass transfer index. *)
                balanceStabilityPlots = If[And[
                    MemberQ[massTransferIndices, index],
                    MemberQ[{tareDataPacketsPerWeightData, emptyContainerWeightDataPacketsPerWeightData, measuredTransferWeightDataPacketsPerWeightData, materialLossWeightDataPacketsPerWeightData, residueWeightDataPacketsPerWeightData}, Except[Null]]
                ],
                    With[
                        {
                            weightDataPacketses = {
                                tareDataPacketsPerWeightData,
                                emptyContainerWeightDataPacketsPerWeightData,
                                measuredTransferWeightDataPacketsPerWeightData,
                                materialLossWeightDataPacketsPerWeightData,
                                residueWeightDataPacketsPerWeightData
                            } /. {Null -> <||>}
                        },

                        Module[
                            {weighingEvents, allowedWeightVariations},

                            (* Define the weighing events. *)
                            weighingEvents = {"Zero", "Container Tare", "Sample", "Material Loss", "Residue"};

                            (* Use the relevant allowed stability variation for each weighing event. MaxTareWeightVariation is for Tare and Empty Container. *)
                            (* The MaxTareWeightVariation is used for the sample measurement, material loss, and residue events. *)
                            allowedWeightVariations = {
                                maxTareWeightVariation, (* Zero / TareWeight *)
                                maxTareWeightVariation, (* Container Tare / EmptyContainerWeight *)
                                maxWeightVariation, (* Sample / MeasuredTransferWeight *)
                                maxWeightVariation, (* Material Loss / MaterialLossWeight *)
                                maxWeightVariation (* Residue / ResidueWeight *)
                            };

                            (* Generate the plots for each weighing event. *)
                            MapThread[
                                Function[
                                    {weightDataPackets, allowedWeightVariation},
                                    If[And[
                                        MatchQ[Lookup[weightDataPackets, WeightLog, Null], _?QuantityArrayQ],
                                        MemberQ[Lookup[weightDataPackets, WeightStability, Null], {_?DateObjectQ, MassP}]
                                    ],
                                        Module[
                                            {
                                                weightLogTimes, weightLogMasses, unitForScaling, adjustedWeightLogMasses,
                                                adjustedWeightLog, middleWeight, minAllowedWeight, maxAllowedWeight, variabilityLines
                                            },

                                            (* Separate the WeightLog into times and masses. *)
                                            {weightLogTimes, weightLogMasses} = Transpose @ Lookup[weightDataPackets, WeightLog, {{}, {}}];

                                            (* Get the appropriate unit considering the allowed weight deviation. *)
                                            unitForScaling = Units @ UnitScale[allowedWeightVariation];

                                            (* Subtract the average mass value from the list of masses and recreate the weight log using the adjusted masses. *)
                                            adjustedWeightLogMasses = Convert[weightLogMasses - Mean[weightLogMasses], unitForScaling];
                                            adjustedWeightLog = Transpose[{weightLogTimes, adjustedWeightLogMasses}];

                                            (* Also find the middle of the adjusted weight log by taking the average of the Min and Max weights. *)
                                            middleWeight = Mean[MinMax[adjustedWeightLogMasses]];

                                            (* Get the minimum and maximum allowed weights. *)
                                            minAllowedWeight = middleWeight - (allowedWeightVariation / 2);
                                            maxAllowedWeight = middleWeight + (allowedWeightVariation / 2);

                                            (* Define the lines to plot for the allowed weight variability. *)
                                            variabilityLines = {
                                                {{adjustedWeightLog[[1,1]], minAllowedWeight}, {adjustedWeightLog[[-1,1]], minAllowedWeight}},
                                                {{adjustedWeightLog[[1,1]], maxAllowedWeight}, {adjustedWeightLog[[-1,1]], maxAllowedWeight}}
                                            };

                                            (* Always use the click-to-zoom functionality to keep the notebooks light. *)
                                            zoomableButton[
                                                EmeraldDateListPlot[
                                                    Join[{adjustedWeightLog}, variabilityLines, {adjustedWeightLog}],
                                                    PlotStyle -> {
                                                        Directive[RGBColor["#800020"], PointSize[0.008]],
                                                        Directive[RGBColor["#98FB98"], Opacity[0.9]],
                                                        Directive[RGBColor["#98FB98"], Opacity[0.9]],
                                                        Directive[Gray, Opacity[0.25]]
                                                    },
                                                    Joined -> {False, True},
                                                    FrameLabel -> {"Time ", "Weight Variation"},
                                                    Zoomable -> False,
                                                    Legend -> {"Recorded Weight Data", "Allowed Variation"},
                                                    LegendPlacement -> Bottom,
                                                    PlotRange -> {Automatic, 1.25 * {minAllowedWeight, maxAllowedWeight}},
                                                    Filling -> {2 -> {3}},
                                                    FillingStyle -> Directive[RGBColor["#98FB98"], Opacity[0.1]],
                                                    ImageSize -> 350,
                                                    LabelStyle -> Directive[Black, 12, FontFamily -> "Helvetica"],
                                                    DateTicksFormat -> {"Hour24", ":", "Minute",":","Second"}
                                                ]
                                            ]
                                        ],
                                        Null
                                    ]
                                ],
                                {weightDataPacketses, allowedWeightVariations}
                            ]
                        ]
                    ],
                    Null
                ];

                (* Set up the image tabs if this is a mass transfer index. *)
                balanceImageTabs = If[And[
                    MemberQ[massTransferIndices, index],
                    MemberQ[{tareWeightImage, emptyContainerWeightImage, measuredTransferWeightImage, residueWeightImage, materialLossWeightImage}, Except[Null]]
                ],
                    With[
                        {
                            weights = {tareWeight, emptyContainerWeight, measuredTransferWeight, materialLossWeight, residueWeight},
                            appearanceObjects = {tareWeightAppearanceObject, emptyContainerWeightAppearanceObject, measuredTransferWeightAppearanceObject, materialLossWeightAppearanceObject, residueWeightAppearanceObject},
                            images = {tareWeightImage, emptyContainerWeightImage, measuredTransferWeightImage, materialLossWeightImage, residueWeightImage},
                            weightData = {tareWeightDataObject, emptyContainerWeightDataObject, measuredTransferWeightDataObject, materialLossWeightDataObject, residueWeightDataObject},
                            streamObjects = {tareWeightStreamTuple, emptyContainerStreamTuple, measuredTransferWeightStreamTuple, materialLossStreamTuple, residueWeightStreamTuple}[[All, 1]],
                            streamTimes = {tareWeightStreamTuple, emptyContainerStreamTuple, measuredTransferWeightStreamTuple, materialLossStreamTuple, residueWeightStreamTuple}[[All, 2]],
                            explicitStabilityPlots = balanceStabilityPlots
                        },

                        Module[
                            {headings, tabs},

                            (* Define the headings. *)
                            headings = {"Zero", "Container Tare", "Sample", "Material Loss", "Residue"};

                            (* Generate the tabs *)
                            tabs = MapThread[
                                Function[
                                    {heading, weight, appearanceObject, image, weightDataObject, streamObject, streamTime, stabilityPlot},
                                    If[!NullQ[image] && !NullQ[appearanceObject],
                                            heading -> Grid[List @ {
                                                Column[
                                                    {
                                                        ActionMenu[
                                                            Show[image, ImageSize -> 150],
                                                            {
                                                                "Open Image" :> OpenCloudFile[appearanceObject],
                                                                If[!NullQ[weightDataObject],
                                                                    "Copy Weight Data Object" :> CopyToClipboard[weightDataObject[Object]],
                                                                    Nothing
                                                                ],
                                                                If[!NullQ[streamObject],
                                                                    "Play Stream" :> WatchProtocol[streamObject, streamTime],
                                                                    Nothing
                                                                ]
                                                            },
                                                            Appearance -> None,
                                                            Method -> "Queued"
                                                        ],
                                                        Row[{
                                                            Style["Weight: ", Bold, 12, FontFamily -> "Helvetica"],
                                                            If[!NullQ[weight],
                                                                Experiment`Private`unitFormDistribution[weight, Resolution -> balanceResolution],
                                                                Style["Not Measured", 12, FontFamily -> "Helvetica"]
                                                            ]
                                                        }]
                                                    },
                                                    Alignment -> Center
                                                ],
                                                "   ",
                                                If[NullQ[stabilityPlot],
                                                    Nothing,
                                                    Column[
                                                        {" ",Style["Balance Stability Data", Bold, 13, FontFamily -> "Helvetica"], stabilityPlot},
                                                        Alignment -> Center,
                                                        Spacings -> 0
                                                    ]
                                                ]
                                            }],
                                        Nothing
                                    ]
                                ],
                                {headings, weights, appearanceObjects, images, weightData, streamObjects, streamTimes, explicitStabilityPlots}
                            ];

                            TabView[tabs, ControlPlacement -> {Left, Center}, ContinuousAction -> False]
                        ]
                    ],
                    Null
                ];

                (* Generate the table for each transfer according to the available information. *)
                tableContent = {

                    (* === Basic info === *)

                    If[!NullQ[sourceContainerButton], {"Source Container", sourceContainerButton}, Nothing],

                    (* Don't show the user an autogenerated label. *)
                    If[
                        !StringContainsQ[sourceContainerLabel, autogeneratedContainerLabelP],
                        {"Source Container Label", sourceContainerLabel},
                        Nothing
                    ],

                    (* Don't show the user an autogenerated label. *)
                    If[
                        !StringContainsQ[sourceLabel, autogeneratedSampleLabelP],
                        {"Source Sample Label", sourceLabel},
                        Nothing
                    ],

                    (* Don't show the user the well if this a vessel. *)
                    If[
                        !MatchQ[sourceContainer, ObjectP[Object[Container, Vessel]]],
                        {"Source Well", sourceWell},
                        Nothing
                    ],

                    If[
                        MatchQ[sourceLink, ObjectP[Object[Sample]]],
                        {"Source Sample", sourceSampleButton},
                        Nothing
                    ],

                    If[!NullQ[destinationContainer], {"Destination Container", destinationContainerButton}, Nothing],

                    (* Don't show the user an autogenerated label. *)
                    If[
                        !StringContainsQ[destinationContainerLabel, autogeneratedContainerLabelP],
                        {"Destination Container Label", destinationContainerLabel},
                        Nothing
                    ],

                    (* Don't show the user an autogenerated label. *)
                    If[
                        !StringContainsQ[destinationLabel, autogeneratedSampleLabelP],
                        {"Destination Sample Label", destinationLabel},
                        Nothing
                    ],

                    (* Don't show the user the well if this a vessel. *)
                    If[
                        !MatchQ[destinationContainer, ObjectP[Object[Container, Vessel]]],
                        {"Destination Well", destinationWell},
                        Nothing
                    ],

                    If[
                        MatchQ[destinationLink, ObjectP[Object[Sample]]],
                        {"Destination Sample", destinationSampleButton},
                        Nothing
                    ],

                    If[!NullQ[requestedTransferAmount],
                    {"Requested Amount", If[MatchQ[requestedTransferAmount, All], All, UnitForm[requestedTransferAmount, Brackets -> False]]},
                        Nothing
                    ],

                    If[!NullQ[actualTransferAmount], {"Actual Amount", actualTransferAmount}, Nothing],

                    If[!NullQ[transferEnvironmentButton], {"Transfer Environment", transferEnvironmentButton}, Nothing],

                    (* === Transfer aids === *)

                    If[!NullQ[funnelButton], {"Funnel", funnelButton}, Nothing],

                    If[!NullQ[instrumentButton], {"Instrument", instrumentButton}, Nothing],

                    If[!NullQ[tipsButton], {"Tips", tipsButton}, Nothing],

                    If[!NullQ[intermediateContainerButton], {"Intermediate Container", intermediateContainerButton}, Nothing],

                    If[!NullQ[intermediateFunnelButton], {"Intermediate Funnel", intermediateFunnelButton}, Nothing],

                    (* === Quantitative transfer === *)

                    If[!NullQ[quantitativeTransferWashSolutionButton], {"Quantitative Transfer Wash Solution", quantitativeTransferWashSolutionButton}, Nothing],

                    If[!NullQ[quantitativeTransferWashVolume], {"Quantitative Transfer Wash Volume", UnitForm[quantitativeTransferWashVolume, Brackets -> False]}, Nothing],

                    If[!NullQ[numberOfQuantitativeTransferWashes], {"Quantitative Transfer Washes", numberOfQuantitativeTransferWashes}, Nothing],

                    (* === Hermetic === *)

                    If[!NullQ[backfillGas], {"Backfill Gas", backfillGas}, Nothing],

                    If[!NullQ[backfillNeedleButton], {"Backfill Needle", backfillNeedleButton}, Nothing],

                    If[!NullQ[needleButton], {"Needle", needleButton}, Nothing],

                    (* If this is part of a multichannel transfer, tell the user which other transfers occurred simultaneously. *)
                    Which[
                        (* If this isn't a multichannel transfer, don't put anything here. *)
                        NullQ[multichannelTransferGrouping],
                            Nothing,
                        (* If this is part of a 2-channel transfer, show the other index (singular). *)
                        SameQ[Length[multichannelTransferGrouping], 2],
                            {"Multichannel Transfer", "True (with transfer index "<>ToString[FirstCase[multichannelTransferGrouping, Except[index]]]<>")"},
                        (* Otherwise, there are multiple other transfers and we should give the whole list. *)
                        True,
                            {"Multichannel Transfer", "True (with transfer indices "<>ToString[Cases[multichannelTransferGrouping, Except[index]]]<>")"}
                    ],

                    (* === Weighing === *)

                    If[!NullQ[balanceButton], {"Balance", balanceButton}, Nothing],

                    If[!NullQ[weighingContainerButton], {"Weighing Container", weighingContainerButton}, Nothing],

                    If[!NullQ[balanceImageTabs], {"Balance Images", balanceImageTabs}, Nothing],

                    (* If there are carton and real images for the pipette dial, show them. *)
                    If[MemberQ[{pipetteDialImageImage, pipetteDialPictureImage, pipetteDialPictureObject}, Null],
                        Nothing,
                        Module[
                            {pipetteDialPictureButton},

                            pipetteDialPictureButton = With[
                                {explicitImage = pipetteDialPictureImage, explicitObject = pipetteDialPictureObject},
                                Tooltip[
                                    Button[
                                        Show[explicitImage, ImageSize -> 180],
                                        OpenCloudFile[explicitObject],
                                        Appearance -> "Frameless",
                                        Method -> "Queued"
                                    ],
                                    "Open Image"
                                ]
                            ];

                            {
                                "Pipette Dial",
                                Grid[{
                                    {
                                        Column[{Show[pipetteDialImageImage, ImageSize -> 150], Style["Instruction", 12, Italic, FontFamily -> "Helvetica"]}, Alignment -> Center, Spacings -> 0.5],
                                        "                ",
                                        Column[{pipetteDialPictureButton, Style["Actual", 12, Italic, FontFamily -> "Helvetica"]}, Alignment -> Center, Spacings -> 0.5]
                                    }
                                }, Alignment -> Bottom]
                            }
                        ]
                    ],

                    (* If there are multiple samples, we place the summaryStreamButtons in the summary table. *)
                    (* But if we have exactly 1 transfer, we don't generate a summary. In this case, put *)
                    (* the stream button (if any) for the lone transfer UO here in the details table. *)
                    If[SameQ[Length[paddedSourceContainers], 1] && !NullQ[streamButton],
                        {"Stream", streamButton},
                        Nothing
                    ]
                };

                (* Set up the grid and label it *)
                Labeled[
                    Grid[Replace[tableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                        Sequence@@gridFormat,
                        ItemSize -> {{All, UpTo[50]}}
                    ],
                    "Transfer Index "<>ToString[index],
                    Top,
                    LabelStyle -> Directive[Bold, FontFamily -> "Helvetica"]
                ]


            ]

        ],
        {
            (* Basic info *)
            Range[Length[sourceContainerLabels]],
            paddedSourceContainerLabels,
            paddedDestinationContainerLabels,
            sourceLinks,
            destinationLinks,
            paddedSourceContainers,
            paddedDestinationContainers,
            paddedSourceContainerButtons,
            paddedDestinationContainerButtons,
            sourceLabels,
            destinationLabels,
            sourceWells,
            destinationWells,
            sourceSampleButtons,
            destinationSampleButtons,
            requestedTransferAmounts,
            actualTransferAmountsFormatted,
            transferEnvironmentButtons,
            summaryStreamButtons,

            (* Weighing *)
            balanceButtons,
            weighingContainerButtons,
            paddedTareWeights,
            paddedTareWeightAppearanceObjects,
            tareWeightImages,
            paddedTareData,
            tareWeightStreamTuples,
            paddedContainerWeights,
            paddedContainerWeightAppearanceObjects,
            emptyContainerImages,
            paddedEmptyContainerWeightData,
            containerWeightStreamTuples,
            paddedTransferWeights,
            paddedTransferWeightAppearanceObjects,
            measuredTransferWeightImages,
            paddedMeasuredTransferWeightData,
            measuredTransferWeightStreamTuples,
            paddedResidueWeights,
            paddedResidueWeightAppearanceObjects,
            residueWeightImages,
            paddedResidueWeightData,
            residueWeightStreamTuples,
            paddedMaterialLossWeights,
            paddedMaterialLossAppearanceObjects,
            materialLossImages,
            paddedMaterialLossWeightData,
            materialLossWeightStreamTuples,
            balanceResolutions,
            paddedTareDataPackets,
            paddedEmptyContainerWeightDataPackets,
            paddedMeasuredTransferWeightDataPackets,
            paddedResidueWeightDataPackets,
            paddedMaterialLossWeightDataPackets,
            paddedMaxWeightVariations,
            paddedMaxTareWeightVariations,

            (* Transfer aids *)
            funnelButtons,
            instrumentButtons,
            tipButtons,
            intermediateContainerButtons,
            intermediateFunnelButtons,
            pipetteDialImageImages,
            pipetteDialPictureImages,
            paddedPipetteDialPictureObjects,
            multichannelTransferGroupings,

            (* Quantitative Transfer *)
            paddedQuantitativeTransferWashSolutionButtons,
            quantitativeTransferWashVolumes,
            numbersOfQuantitativeTransferWashes,

            (* Hermetic *)
            backfillGases,
            backfillNeedleButtons,
            needleButtons
        } /. {$Failed -> Null}
    ];

    (* We want to show the most relevant information for source and destination in the summary table. *)
    (* Map over the source objects, labels, containers, container labels, and wells to do so. *)
    clickableSourcesForSummary = MapThread[
        Function[
            {
                sourceContainerLabel,
                sourceContainer,
                sourceWell,
                sourceLabel,
                source
            },
            Which[
                (* If the source container is a plate and the container label is not auto-generated, display the well and container label. *)
                !StringContainsQ[sourceContainerLabel, autogeneratedContainerLabelP] && MatchQ[sourceContainer, ObjectP[Object[Container, Plate]]],
                    customButton[{sourceWell, sourceContainerLabel}, CopyContent -> {sourceWell, sourceContainer}, Tooltip -> {sourceWell, sourceContainer}],

                (* If the source container is NOT a plate and the container label is not auto-generated, display the container label. *)
                !StringContainsQ[sourceContainerLabel, autogeneratedContainerLabelP],
                    customButton[sourceContainerLabel, CopyContent -> sourceContainer, Tooltip -> sourceContainer],

                (* If the sample label is not auto-generated, display the sample label. *)
                !StringContainsQ[sourceLabel, autogeneratedSampleLabelP],
                    customButton[sourceLabel, CopyContent -> source, Tooltip -> source],

                (* If the source container is a plate and the label is auto-generated, display the well and container object. *)
                MatchQ[sourceContainer, ObjectP[Object[Container, Plate]]],
                    customButton[{sourceWell, sourceContainer}, CopyContent -> {sourceWell, sourceContainer}, Tooltip -> {sourceWell, sourceContainer}],

                (* In any other case, display the sample object. *)
                True,
                    customButton[source, CopyContent -> source, Tooltip -> source]
            ]
        ],
        {
            paddedSourceContainerLabels,
            paddedSourceContainers,
            sourceWells,
            sourceLabels,
            sourceLinks
        }
    ];

    (* Map over the destination objects, labels, containers, container labels, and wells to do so. *)
    clickableDestinationsForSummary = MapThread[
        Function[
            {
                destinationContainerLabel,
                destinationContainer,
                destinationWell,
                destinationLabel,
                destination
            },
            Which[
                (* If the destination container is a plate and the container label is not auto-generated, display the well and container label. *)
                !StringContainsQ[destinationContainerLabel, autogeneratedContainerLabelP] && MatchQ[destinationContainer, ObjectP[Object[Container, Plate]]],
                    customButton[{destinationWell, destinationContainerLabel}, CopyContent -> {destinationWell, destinationContainer}, Tooltip -> {destinationWell, destinationContainer}],

                (* If the destination container is NOT a plate and the container label is not auto-generated, display the container label. *)
                !StringContainsQ[destinationContainerLabel, autogeneratedContainerLabelP],
                    customButton[destinationContainerLabel, CopyContent -> destinationContainer, Tooltip -> destinationContainer],

                (* If the sample label is not auto-generated, display the sample label. *)
                !StringContainsQ[destinationLabel, autogeneratedSampleLabelP],
                    customButton[destinationLabel, CopyContent -> destination, Tooltip -> destination],

                (* If the destination container is a plate and the label is auto-generated, display the well and container object. *)
                MatchQ[destinationContainer, ObjectP[Object[Container, Plate]]],
                    customButton[{destinationWell, destinationContainer}, CopyContent -> {destinationWell, destinationContainer}, Tooltip -> {destinationWell, destinationContainer}],

                (* In any other case, display the sample object. *)
                True,
                    customButton[destination, CopyContent -> destination, Tooltip -> destination]
            ]
        ],
        {
            paddedDestinationContainerLabels,
            paddedDestinationContainers,
            destinationWells,
            destinationLabels,
            destinationLinks
        }
    ];

    (** Final output **)
    (*
        If we only have 1 sample, we will take the first table and output it.
        If we have more than one sample, we will create a dynamic output that includes a summary table with radio
            buttons and a display below that shows the table relevant to the selected sample
    *)
    If[SameQ[Length[paddedSourceContainers], 1],
        (* just need to output this if we only have a single transfer *)
        Labeled[
            First[transferDataTables],
            "Transfer Data",
            Top,
            LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
        ],
        (* generate our dynamic output *)
        With[{explicitSampleTables = transferDataTables},
            DynamicModule[
                (* localized variables *)
                {summaryContent, summaryHeadings, transferDisplayIndex = 1},

                (* if there were no SamplesIn, don't show that column *)
                summaryContent = MapThread[
                    Replace[{
                        With[{explicitValue = #1}, Row[{explicitValue, "   ", RadioButton[Dynamic[transferDisplayIndex, TrackedSymbols :> {transferDisplayIndex}], explicitValue]}]],
                        #2,
                        #3,
                        If[MatchQ[#4, All], All, UnitForm[#4, Brackets -> False]],
                        If[roboticQ, Nothing, #5],
                        If[roboticQ, Nothing, #6 /. Null -> " "]
                    }, NullP -> Nothing, {1}]&,
                    {Range[Length[paddedSourceContainers]], clickableSourcesForSummary, clickableDestinationsForSummary, requestedTransferAmounts, actualTransferAmountsFormatted, summaryStreamButtons}
                ];
                summaryHeadings = {
                    Tooltip["Index", "Click radio button to show detailed transfer data below"],
                    "Source",
                    "Destination",
                    "Requested Amount",
                    If[roboticQ, Nothing, "Actual Amount"],
                    If[roboticQ, Nothing, "Stream"]
                };

                (* put together the data for summary table *)
                summaryTableData = NamedObject[
                    Prepend[
                        summaryContent,
                        summaryHeadings
                    ]
                ];

                Column[{
                    Labeled[
                        Pane[
                            Grid[
                                Replace[summaryTableData, {objectValue : ObjectP[] :> customButton[objectValue]}, {2}],
                                Sequence @@ ReplaceRule[gridFormat,
                                    {
                                        Background -> Experiment`Private`tableBackground[Length[paddedSourceContainers]],
                                        ItemStyle -> {
                                            {Directive[Bold, FontFamily -> "Helvetica"]},
                                            {Directive[Bold, FontFamily -> "Helvetica"], {Directive[FontFamily -> "Helvetica"]}}
                                        }
                                    }
                                ]
                            ],
                            ImageSize -> {Automatic, UpTo[250]},
                            Scrollbars -> Automatic,
                            AppearanceElements -> None
                        ],
                        "Transfer Summary Table",
                        Top,
                        LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
                    ],
                    Labeled[
                        Framed[
                            Dynamic[explicitSampleTables[[transferDisplayIndex]], TrackedSymbols :> {transferDisplayIndex}],
                            FrameStyle -> Lighter[Gray, 0.4]
                        ],
                        "Transfer Data",
                        Top,
                        LabelStyle -> Directive[Bold, 15, FontFamily -> "Helvetica"]
                    ]
                },
                    Dividers -> {False, {False, True, True}},
                    FrameStyle -> Lighter[Gray, 0.4],
                    Alignment -> Center,
                    Spacings -> 2
                ]
            ]
        ]
    ]

];

(* filterUnitOperationPrimaryData *)

Authors[filterUnitOperationPrimaryData]:={"tyler.pabst"};

filterUnitOperationPrimaryData[
    optimizedUnitOpPacket_Association,
    outputUnitOpPacket_Association,
    instrumentPackets_List,
    instrumentModelPackets_List
] := Module[
    {
        filtrationTypes, targets, protocol, collectRetentateBools, collectOccludingRetentateBools, targetSampleLabelFields,
        targetContainerLabelFields,
        targetSamplesOutFields,
        targetContainersOutFields,
        targetDestinationWellsFields, samplesOutLabels, samplesOut, containersOutLabels, containersOut, destinationWells, samplesInLabels, samplesInOptimizedPacket, samplesInOutputPacket,
        containersInLabels, filterLabel, sourcesContainerLabelsClickable, sourcesSampleObjects, sourcesContainerObjects, destinationsContainersLabelsClickable, filterModelsTooltips,
        filtersOptimizedPacket, filtersOutputPacket, filterObjects, filterModels, filtersClickable, filtrationTypeFields, allTableFields, tableFieldValuePairs, fieldValuesPairs, tableDataRules,
        instruments, instrumentModels, modelImages, syringeIndices, streamButtons, splitInstrumentModelsList, tableDataRulesWithStreams, splitImages,
        splitSourcesContainerLabels,
        splitFilters,
        splitDestinationsContainersLabels,
        splitTableData, display
    },

    (* Lookup the Target and FiltrationType from the output unit operations packet *)
    {filtrationTypes, targets, protocol} = Lookup[outputUnitOpPacket, {FiltrationType, Target, Subprotocol}];

    (* Lookup bools for which components are collected *)
    {collectRetentateBools, collectOccludingRetentateBools} = Lookup[outputUnitOpPacket, {CollectRetentate, CollectOccludingRetentate}];

    (* Get all of the transfer sources and destinations. *)
    (* Are we targeting the Filtrate or Retentate? *)
    {
        targetSampleLabelFields,
        targetContainerLabelFields,
        targetSamplesOutFields,
        targetContainersOutFields,
        targetDestinationWellsFields
    } = Transpose[MapThread[Function[{target, collectRetentateBool, collectOccludingRetentateBool},
        Module[{targetSampleLabelField, targetContainerLabelField, targetSamplesOutField, targetContainersOutField, targetSamplesOutWellFields, retentateSampleLabelField,
            retentateContainerLabelField,
            retentateSamplesOutFields,
            retentateContainersOutFields,
            retentateSamplesOutWellFields,occludingRetentateContainerLabelField,
            occludingRetentateContainersOutFields,
            occludingRetentateSamplesOutWellFields
        },

            {targetSampleLabelField, targetContainerLabelField} = If[MatchQ[target, Filtrate],
                (* If the target is the filtrate *)
                {FiltrateLabel, FiltrateContainerLabel},
                (* Otherwise, target is retentate *)
                {RetentateLabel, RetentateContainerLabel}
            ];

            {targetSamplesOutField, targetContainersOutField} = If[MatchQ[target, Filtrate],
                (* If the target is the filtrate *)
                {FiltrateSample, {FiltrateContainerOutLink, FiltrateContainerOutExpression, FiltrateContainerOutString}},
                (* Otherwise, target is retentate *)
                {RetentateSample, {RetentateContainerOutLink, RetentateContainerOutExpression, RetentateContainerOutString}}
            ];

            {targetSamplesOutWellFields} = If[MatchQ[target, Filtrate],
                (* If the target is the filtrate *)
                {FiltrateDestinationWell},
                (* Otherwise, target is retentate *)
                {RetentateDestinationWell}
            ];

            (* Are we collecting the Retentate? *)
            {
                retentateSampleLabelField,
                retentateContainerLabelField,
                retentateSamplesOutFields,
                retentateContainersOutFields,
                retentateSamplesOutWellFields
            } = If[MatchQ[target, Retentate],
                (* if the target is the Retentate, then we already have the right fields from the target. Set them to the same and we will delete duplicates when we lookup the fields *)
                {targetSampleLabelField, targetContainerLabelField, targetSamplesOutFields, targetContainersOutFields, targetSamplesOutWellFields},

                (* Otherwise, if the target is the Filtrate but we also have CollectRetentate -> True, then set the relevent fields to look up retentate sample/label info *)
                If[MatchQ[collectRetentateBool, True],
                    {RetentateLabel, RetentateContainerLabel, RetentateSample, {RetentateContainerOutLink, RetentateContainerOutExpression, RetentateContainerOutString}, RetentateDestinationWell},
                    (* If CollectRetentate is False, set everything to Null *)
                    {Null, Null, Null, {Null, Null, Null}, Null}
                ]
            ];

            (* Are we collecting the OccludingRetentate? There is no SampleLabel or Sample field for occluding retentate. *)
            {
                occludingRetentateContainerLabelField,
                occludingRetentateContainersOutFields,
                occludingRetentateSamplesOutWellFields
            } = If[MatchQ[collectOccludingRetentateBool, True],
                {OccludingRetentateContainerLabel, {OccludingRetentateContainerLink, OccludingRetentateContainerString}, OccludingRetentateDestinationWell},
                (* If CollectOccludingRetentate is False, set everything to Null *)
                {Null, {Null, Null}, Null}
            ];

            {targetSampleLabelField, targetContainerLabelField, targetSamplesOutField, targetContainersOutField, targetSamplesOutWellFields}
        ]
    ],
        {targets, collectRetentateBools, collectOccludingRetentateBools}
    ]];

    (* Get the containers out labels. If specified in the optimized unit op packets, use those, otheruse use the labels in the output unit op packets *)
    samplesOutLabels = If[MatchQ[Lookup[optimizedUnitOpPacket, targetSampleLabelFields[[1]]], {_String..}],
        Lookup[optimizedUnitOpPacket, targetSampleLabelFields[[1]]],
        Lookup[outputUnitOpPacket, targetSampleLabelFields[[1]]]
    ];

    samplesOut = NamedObject[Lookup[outputUnitOpPacket, targetSamplesOutFields[[1]]]];

    containersOutLabels = If[MatchQ[Lookup[optimizedUnitOpPacket, targetContainerLabelFields[[1]]], {_String..}],
        Lookup[optimizedUnitOpPacket, targetContainerLabelFields[[1]]],
        Lookup[outputUnitOpPacket, targetContainerLabelFields[[1]]]
    ];

    containersOut = NamedObject[Module[{links, expressions, strings},
        {links, expressions, strings} = Lookup[outputUnitOpPacket, targetContainersOutFields[[1]]];
        (* Map through each sample, and pull out whichever of the sample fields is populated *)
        Map[
            FirstCase[#, Except[Null]]&,
            Transpose[{links, expressions, strings}]
        ]
    ]];

    destinationWells = If[MatchQ[Lookup[optimizedUnitOpPacket, targetDestinationWellsFields[[1]]], {_String..}],
        Lookup[optimizedUnitOpPacket, targetDestinationWellsFields[[1]]],
        Lookup[outputUnitOpPacket, targetDestinationWellsFields[[1]]]
    ];

    (* Get the samples in labels. If specified in the optimized unit op packets, use those, otheruse use the labels in the output unit op packets *)
    samplesInLabels = If[MatchQ[Lookup[optimizedUnitOpPacket, SampleLabel], {_String..}],
        Lookup[optimizedUnitOpPacket, SampleLabel],
        Lookup[outputUnitOpPacket, SampleLabel]
    ];

    samplesInOptimizedPacket = NamedObject[Module[{links, expressions, strings},
        {links, expressions, strings} = Lookup[optimizedUnitOpPacket, {SampleLink, SampleExpression, SampleString}];
        (* Map through each sample, and pull out whichever of the sample fields is populated *)
        Map[
            FirstCase[#, Except[Null]]&,
            Transpose[{links, expressions, strings}]
        ]
    ]];

    samplesInOutputPacket = NamedObject[Module[{links, expressions, strings},
        {links, expressions, strings} = Lookup[outputUnitOpPacket, {SampleLink, SampleExpression, SampleString}];
        (* Map through each sample, and pull out whichever of the sample fields is populated *)
        Map[
            FirstCase[#, Except[Null]]&,
            Transpose[{links, expressions, strings}]
        ]
    ]];

    containersInLabels = If[MatchQ[Lookup[optimizedUnitOpPacket, SampleContainerLabel], {_String..}],
        Lookup[optimizedUnitOpPacket, SampleContainerLabel],
        Lookup[outputUnitOpPacket, SampleContainerLabel]
    ];

    filterLabel = If[MatchQ[Lookup[optimizedUnitOpPacket, FilterLabel], {_String..}],
        Lookup[optimizedUnitOpPacket, FilterLabel],
        Lookup[outputUnitOpPacket, FilterLabel]
    ];

    filtersOptimizedPacket = NamedObject[Module[{links, expressions, strings},
        {links, expressions, strings} = Lookup[optimizedUnitOpPacket, {FilterLink, FilterExpression, FilterString}];
        (* Map through each sample, and pull out whichever of the sample fields is populated *)
        Map[
            FirstCase[#, Except[Null]]&,
            Transpose[{links, expressions, strings}]
        ]
    ]];

    filtersOutputPacket = NamedObject[Module[{links, expressions, strings},
        {links, expressions, strings} = Lookup[outputUnitOpPacket, {FilterLink, FilterExpression, FilterString}];
        (* Map through each sample, and pull out whichever of the sample fields is populated *)
        Map[
            FirstCase[#, Except[Null]]&,
            Transpose[{links, expressions, strings}]
        ]
    ]];

    {filterObjects, filterModels} = Module[
        {optimizedValuesPadded, outputValuesPadded, filterObjectsPreliminary, filterModelsPreliminary},

        (* Ensure that the info from the optimized and output UOs can be transposed even if something is missing. *)
        optimizedValuesPadded = If[MatchQ[filtersOptimizedPacket, {}] && !MatchQ[filtersOutputPacket, {}],
            ConstantArray[{}, Length[filtersOutputPacket]],
            filtersOptimizedPacket
        ];
        outputValuesPadded = If[MatchQ[filtersOutputPacket, {}] && !MatchQ[filtersOptimizedPacket, {}],
            ConstantArray[{}, Length[filtersOptimizedPacket]],
            filtersOutputPacket
        ];

        (* Get the relevant objects and Models. *)
        {filterObjectsPreliminary, filterModelsPreliminary} = Transpose[Map[
            {
                FirstCase[#, ObjectP[Object[Item]], Null],
                FirstCase[#, ObjectP[Model[Item]], Null]
            }&
            ,
            Transpose[{optimizedValuesPadded, outputValuesPadded}]
        ]];

        (* Ideally we already have what we need, but the population of FilterLink/Expression/String in optimized filter unit *)
        (* operations seems to be inconsistent, so check if we actually got models here and download them if needed and if possible. *)
        If[MatchQ[filterObjectsPreliminary, {ObjectP[]..}] && !MemberQ[filterModelsPreliminary, ObjectP[]],
            {filterObjectsPreliminary, Download[filterObjectsPreliminary, Model[Object]]},
            {filterObjectsPreliminary, filterModelsPreliminary}
        ]
    ];

    filtersClickable = MapThread[Function[{label, object, model},
        customButton[label,
            CopyContent -> object,
            Tooltip -> Column[{object, model}]
        ]
    ],
    {filterLabel, filterObjects, filterModels}
    ];

    {sourcesContainerLabelsClickable, sourcesSampleObjects, sourcesContainerObjects} = Transpose[MapThread[Function[{sampleLabel, containerLabel, sampleFromOptimized, sampleFromOutput},
        Module[{sampleObject, containerObject, gridHeadings, gridContents, tooltipGrid},

            sampleObject = FirstCase[{sampleFromOptimized, sampleFromOutput}, ObjectP[Object[Sample]], Null];

            containerObject = FirstCase[{sampleFromOptimized, sampleFromOutput}, ObjectP[Object[Container]], Null];

            {gridHeadings, gridContents}  = If[MatchQ[{sampleObject, containerObject}, {Null, Null}],
                {
                    {"Label"},
                    Flatten[#/. Null -> {}]&/@ {{sampleLabel, sampleObject}, {containerLabel, containerObject}}
                },
                {
                    {"Label", "Object"},
                    {{sampleLabel, sampleObject}, {containerLabel, containerObject}}
                }
            ];

            tooltipGrid = Grid[
                Prepend[
                    gridContents,
                    Style[#, Bold]& /@ gridHeadings
                ],
                Frame -> All,
                Background -> {Automatic, {LightGray, White, White}}
            ];

            {
                customButton[containerLabel,
                    CopyContent -> sampleObject,
                    Tooltip -> tooltipGrid
                ],
                sampleObject,
                containerObject
            }
        ]
    ],
        {samplesInLabels, containersInLabels, samplesInOptimizedPacket,samplesInOutputPacket}
    ]
    ];

    destinationsContainersLabelsClickable = MapThread[Function[{sampleLabel, containerLabel, sample, container, well},
        Module[{sampleObject, containerObject, tooltipGrid},

            tooltipGrid = Grid[
                Prepend[
                    {{sampleLabel, sample}, {containerLabel, {well, container}}},
                    Style[#, Bold]& /@ {"Label", "Object"}
                ],
                Frame -> All,
                Background -> {Automatic, {LightGray, White, White}}
            ];

            customButton[containerLabel,
                CopyContent -> sample,
                Tooltip -> tooltipGrid
            ]
        ]
    ],
        {samplesOutLabels, containersOutLabels, samplesOut, containersOut, destinationWells}
    ];

    filterModelsTooltips = Module[{filterPoreSizes, filterMembraneMaterials},

        (* Define fields that describe filter properties. These will be tooltips over the filter models *)
        {filterPoreSizes, filterMembraneMaterials} = Lookup[outputUnitOpPacket, {PoreSize, MembraneMaterial}];

        MapThread[Function[{model, object, label, poreSize, membraneMaterial},
            customButton[model,
                CopyContent -> object,
                Tooltip -> Grid[{
                        {Style["Model", Bold], model},
                        {Style["Object", Bold], object},
                        {Style["Object Label", Bold], label},
                        {Style["Pore Size", Bold], poreSize},
                        {Style["Membrane Material", Bold], membraneMaterial}
                    },
                    Background -> White,
                    Frame -> All,
                    Alignment -> {{Right, Left}},
                    ItemSize -> {{Automatic, 25}}
                ]
            ]
        ],
            {filterModels, filterObjects, filterLabel, filterPoreSizes, filterMembraneMaterials}
        ]
    ];

    (* Get the relevant list of sample identity fields based on the filtration type for each sample.*)
    filtrationTypeFields = Map[Function[{type},

        Switch[type,
            Syringe,
            {Instrument, Syringe, Time, FlowRate, Temperature},
            Centrifuge,
            {Instrument, Time, Intensity, Temperature},
            Vacuum,
            {Instrument, Time, Temperature},
            AirPressure,
            {Instrument, Pressure, Temperature},
            PeristalticPump,
            {Instrument, Time, Temperature},
            _,
            {}
        ]
    ],
        filtrationTypes
    ];

    (* Flatten and delete any duplicates so we just download each field one time *)
    allTableFields = DeleteDuplicates[Flatten[filtrationTypeFields]];

    (* pair the field name with its looked up values, so we can eliminate fields that are all Null or empty *)
    fieldValuesPairs = Transpose[{allTableFields, NamedObject[Lookup[outputUnitOpPacket, allTableFields]]}];

    (* Select for only fields that are not all Null or empty *)
    tableFieldValuePairs = Select[fieldValuesPairs, !MatchQ[#[[2]], (ListableP[Null] | ListableP[{}])]&];

    (* Add the filter models for each sample to the table and convert the pairs to rules *)
    tableDataRules = Rule @@@ Prepend[tableFieldValuePairs, {Filter, filterModelsTooltips}];

    instruments = Lookup[tableDataRules, Instrument, {}];

    (* Get an image for each unique instrument model *)
    {instrumentModels, modelImages} = Which[

        (* Most likely the instruments in the output unit operations were input as Model[Instruments]'s, so first check that *)
        MatchQ[instruments, {ObjectP[Model[Instrument]]..}],
        {instruments, Lookup[instrumentPackets, ImageFile, Null]},

        (* Otherwise if there are any Object[Instrument] or Model[Instrument] inputs, map through the instruments and lookup the ImageFile from either the instrument model packet or the instrument packet. *)
        MemberQ[instruments, ObjectP[{Object[Instrument], Model[Instrument]}]],
        Transpose[MapIndexed[
            Which[
                MatchQ[#1, ObjectP[Object[Instrument]]],
                {Lookup[instrumentPackets[[#2]], Model, Null], Lookup[instrumentModelPackets[[#2]], ImageFile, Null]},
                MatchQ[#1, ObjectP[Model[Instrument]]],
                {#1, Lookup[instrumentPackets[[#2]], ImageFile, Null]},
                True,
                {#1, Null}
            ]&,
            instruments
        ]],

        (* Otherwise, if the containers input was not a list of models or a list of models and objects, just return the container inputs and Null for the images *)
        True,
        {instruments, ConstantArray[Null, Length[instruments]]}
    ];

    (* Find the positions at which we do syringe filtration; we will generate buttons to play the streams if available. *)
    syringeIndices = Flatten @ Position[filtrationTypes, Syringe, {1}];

    (* Generate stream buttons as needed. *)
    streamButtons = If[FreeQ[syringeIndices, _Integer],
        (* If there is no chance that we have mix types with streaming, don't bother with this. *)
        {},
        (* Otherwise, get any available streams and find the appropriate starting point. *)
        Module[
            {
                numberOfRelevantSamples, startTaskIDP, streamPackets, procedureEventPackets, uniqueTaskIDEventPackets, taskIDs, datesCreated,
                startTaskPositions, syringeFilterStartTimes, allFilterStartTimes, streamPacketsToUse, startTimesInSeconds, preliminaryButtons
            },

            (* Get the number of syringe filtration samples. *)
            numberOfRelevantSamples = Length[syringeIndices];

            (* The following task is in "Filter Syringe Loop". This is the beginning of the syringe filtration *)
            (* and will include discarding the initial filtrate if that is part of this particular protocol. *)
            startTaskIDP = Alternatives @@ {
                "eb4da152-a7c3-4575-9eba-5433c1111bf8",
                (* previous tasks for backwards compatibility: *)
                "d3613792-0f53-4ba7-9b12-c6f1ecd7cfa2",
                "ec130f02-cf1f-40ff-9dec-ebfcf11e32e3"
            };

            (* Download what we need from the protocol object. *)
            {streamPackets, procedureEventPackets} = Quiet[
                Download[protocol,
                    {
                        Packet[Streams[{Object, StartTime, EndTime}]],
                        Packet[ProcedureLog[{Object, TaskID, DateCreated, EventType}]]
                    }
                ]
            ];

            (* Delete duplicate packets by event type. *)
            uniqueTaskIDEventPackets = PickList[
                procedureEventPackets,
                Lookup[procedureEventPackets, EventType, Null],
                TaskStart
            ];

            (* Get the task IDs and dates created for the procedure events. *)
            {taskIDs, datesCreated} = Transpose @ Lookup[uniqueTaskIDEventPackets, {TaskID, DateCreated}];

            (* Get the positions of the start task for each syringe filtration. *)
            startTaskPositions = Flatten[Position[taskIDs, startTaskIDP] + 1];

            (* Use these values to find the start and end dates for the filtration step. *)
            syringeFilterStartTimes = datesCreated[[startTaskPositions - 1]];

            (* Insert these start times appropriately into a list with length equal to the number of samples. *)
            allFilterStartTimes = If[MatchQ[syringeFilterStartTimes, {}] || MatchQ[startTaskPositions, {}],
                ConstantArray[Null, Length[filtrationTypes]],
                ReplacePart[
                    ConstantArray[Null, Length[filtrationTypes]],
                    MapThread[
                        #1 -> #2&,
                        {syringeIndices, syringeFilterStartTimes}
                    ]
                ]
            ];

            (* Find out which stream to use for WatchProtocol. If there's just one, this is easy. *)
            streamPacketsToUse = If[SameQ[Length[streamPackets], 1],
                ConstantArray[streamPackets[[1]], numberOfRelevantSamples],
                (* If there are multiple streams for this transfer protocol, find the latest stream that started before the QS step. *)
                Flatten @ Module[
                    {startTimesOfCorrectStream},

                    startTimesOfCorrectStream = Map[Max @ Cases[Lookup[streamPackets, StartTime], LessP[#]]&, allFilterStartTimes];

                    Map[
                        Function[
                            {startTimeOfCorrectStream},
                            PickList[
                                streamPackets,
                                Lookup[streamPackets, StartTime, Null],
                                startTimeOfCorrectStream
                            ]
                        ],
                        startTimesOfCorrectStream
                    ]
                ]
            ];

            (* Get the start time of the mixing step in terms of unitless seconds from the start of the appropriate stream. *)
            startTimesInSeconds = MapThread[
                Function[
                    {startTime, streamPacket},
                    If[NullQ[startTime] || NullQ[streamPacket],
                        Null,
                        Max[Round[Unitless[Convert[startTime - Lookup[streamPacket, StartTime], 1 Second]]], 0]
                    ]
                ],
                {Cases[allFilterStartTimes, _?DateObjectQ], streamPacketsToUse}
            ];

            (* Return the buttons if there is sufficient information. *)
            preliminaryButtons = MapThread[
                Function[
                    {streamObject, timeArg},
                    If[NullQ[streamObject] || NullQ[timeArg],
                        Nothing,
                        With[
                            {
                                playButtonGraphic = $PlayButtonGraphic,
                                explicitStreamObject = streamObject,
                                explicitTimeArg = timeArg
                            },
                            Button[
                                Tooltip[playButtonGraphic, "Play Stream"],
                                WatchProtocol[explicitStreamObject, explicitTimeArg],
                                Method -> "Queued",
                                Appearance -> "Frameless"
                            ]
                        ]
                    ]
                ],
                {Lookup[streamPacketsToUse /. Null -> <||>, Object, Null], startTimesInSeconds}
            ];

            (* If the number of buttons is equal to the number of syringe indices, insert the buttons at the appropriate indices. *)
            If[SameLengthQ[preliminaryButtons, syringeIndices],
                ReplacePart[
                    ConstantArray[Null, Length[filtrationTypes]],
                    MapThread[
                        #1 -> #2&,
                        {syringeIndices, preliminaryButtons}
                    ]
                ],
                (* If there is a mismatch, play it safe and return no buttons. *)
                ConstantArray[Null, Length[filtrationTypes]]
            ]
        ]
    ];

    (* Display a grid for each instrument model that has an image of the model on top, the name of the model below that, then a table with the unit op info. *)
    (* Split the input lists by container model *)
    splitInstrumentModelsList = Split[Flatten[instrumentModels]];

    (* Append any stream buttons to the tableDataRules if we have them. *)
    tableDataRulesWithStreams = If[FreeQ[streamButtons, _Button],
        tableDataRules,
        Append[tableDataRules, Stream -> streamButtons]
    ];

    {
        splitImages,
        splitSourcesContainerLabels,
        splitFilters,
        splitDestinationsContainersLabels,
        splitTableData
    } = Unflatten[#, splitInstrumentModelsList]& /@ {modelImages, sourcesContainerLabelsClickable, filtersClickable, destinationsContainersLabelsClickable, Transpose[Values[tableDataRulesWithStreams]]};

    display =
        MapThread[Function[{models, images, sourceContainerLabel, filterLabel, destinationContainerLabel, tableData},
            Module[{headings, combinedTableInfo, finalHeadings, mergedTableInfo},

                headings = ToString /@ Prepend[Keys[tableDataRulesWithStreams], Sample];

                combinedTableInfo = Prepend[Transpose[tableData], sourceContainerLabel];

                {finalHeadings, mergedTableInfo} = mergeGridCellsVertical[headings, combinedTableInfo];

                Column[
                    {
                        (* If there is an image, show it. *)
                        If[MatchQ[FirstCase[Flatten[images], ObjectP[]], ObjectP[Object[EmeraldCloudFile]]],
                            Framed[Pane@Image[ImageResize[ImportCloudFile[FirstCase[Flatten[images], ObjectP[]]], $ReviewImageResolution], ImageSize -> $ReviewImageSize], FrameStyle -> LightGray],
                            Nothing
                        ],

                        (* show the instrument model and the object *)
                        customButton[First[models]],

                        Pane[
                            Grid[
                                Prepend[
                                    Transpose[{sourceContainerLabel, filterLabel, destinationContainerLabel}],
                                    Style[#, 12, Bold, FontFamily->"Helvetica"]& /@ {"Source", "Filter", "Destination"}
                                ],
                                ItemSize -> {{12, 10, 12}},
                                Frame -> All,
                                Alignment -> {Center, Center},
                                Spacings -> {2, 1},
                                ItemStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica"],
                                FrameStyle -> Lighter[Gray,0.4],
                                Alignment -> {Center, Center},
                                Dividers -> {
                                    {},
                                    {2 -> Directive[Thick, Darker[Gray]]}
                                },
                                Background -> White
                            ],
                            ImageSize -> {UpTo[700], UpTo[600]},
                            Scrollbars -> Automatic,
                            AppearanceElements -> None
                        ],

                        Pane[
                            Grid[
                                {
                                    Style[#, 12, Bold, FontFamily->"Helvetica"]& /@ finalHeadings,
                                    Sequence @@ Transpose[mergedTableInfo]
                                },
                                Frame -> All,
                                Alignment -> {Center, Center},
                                ItemSize -> {{12, 25, 18, 18, Automatic, Automatic}},
                                ItemStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica"],
                                FrameStyle -> Lighter[Gray,0.4],
                                Alignment -> {Center, Center},
                                Dividers -> {
                                    {2 -> Directive[Thick, Darker[Gray]]},
                                    {2 -> Directive[Thick, Darker[Gray]]}
                                },
                                Background -> White
                            ],
                            ImageSize -> {UpTo[700], UpTo[600]},
                            Scrollbars -> Automatic,
                            AppearanceElements -> None
                        ]
                    },
                    Alignment -> Center,
                    Spacings -> 2
                ]
            ]
        ],
            {splitInstrumentModelsList, splitImages, splitSourcesContainerLabels, splitFilters, splitDestinationsContainersLabels, splitTableData}
        ];

    If[Length[display] > 1,
        assembleSlideView[display],
        First[display]
    ]
];

(* mixIncubateUnitOperationPrimaryData *)

Authors[mixIncubateUnitOperationPrimaryData]:={"tyler.pabst"};

mixIncubateUnitOperationPrimaryData[
    optimizedUnitOpPacket_Association,
    outputUnitOpPacket_Association,
    optimizedUserOptions_Association,
    instrumentPackets_List,
    instrumentModelPackets_List,
    subprotocolPacket: (_Association | Null)
] := Module[{excludedMixKeys, specifiedKeys, tableDataRules, tableDataFormatted, sampleInput, sampleInputLabels, incubatedSamples, clickableSamples,
    instruments, instrumentObjectRules, instrumentModels, modelImages, instrumentObjects, splitInstrumentModelsList, splitImages,
    splitInstruments, splitInstrumentObjects, splitSampleInfo, splitTableData, tables, mixTypes, streamableIndices,
    streamButtons, tableDataFormattedWithStreams},

    (* Keys that we don't need to show, they would be covered by other specified options *)
    excludedMixKeys = {Mix, TipMaterial, TipType, Instrument, FillToVolumeOverfillingRepreparation};

    (* Get the Keys for the options that are in the optimized unit operation, that were not Null or {} *)
    specifiedKeys = Keys[optimizedUserOptions];

    (* Get the values of those keys from the output unit operation. Remove the mix options we aren't interested, and remove any sample options since we will get those inputs elsewhere *)
    tableDataRules = KeyDrop[KeyTake[outputUnitOpPacket, specifiedKeys], Join[excludedMixKeys, {SampleExpression, SampleLink, SampleString}]];

    (* For fields such as TemperatureProfile, plot the data in a small plot rather than showing a whole list of data points. *)
    (*This also puts the field value into a single list instead of list of coordinates *)
    tableDataFormatted = ReplaceRule[
        Normal[tableDataRules, Association],
        {
            (* Plot time and temperature for temp profile field *)
            TemperatureProfile -> (
                Map[
                    Tooltip[ClickToCopy[
                        EmeraldListLinePlot[
                            #,
                            TargetUnits -> {Minute, Celsius},
                            ImageSize -> Small
                        ],
                        #
                    ],
                        "Click to copy list of times and temperatures."
                    ]&,
                    Lookup[tableDataRules, TemperatureProfile]
                ]
            )
        },
        Append -> False
    ];

    (* Get the input samples *)
    {sampleInput, incubatedSamples} = Map[Function[{packetsList},
        Module[{allSampleFormats, sampleList},
            allSampleFormats = Lookup[packetsList, {SampleLink, SampleString, SampleExpression}];
            sampleList = FirstCase[allSampleFormats, Except[ListableP[Null] | {}]];
            Map[
                If[MatchQ[#, ObjectP[{Object[Sample], Model[Sample]}]],
                    #[Object],
                    #
                ]&
                ,
                sampleList
            ]
        ]
        ],
        {optimizedUnitOpPacket, outputUnitOpPacket}
    ];

    sampleInputLabels = Which[
        MatchQ[sampleInput, {_String}],
            First[sampleInput],
        MatchQ[sampleInput, {_String..}],
            sampleInput,
        True,
            Null
    ];

    (* Make samples click to copy *)
    clickableSamples = Tooltip[ClickToCopy[#], #]& /@ incubatedSamples;

    (* Get the instrument from the output unit op packet. *)
    instruments = NamedObject[Lookup[outputUnitOpPacket, Instrument, {}]];

    (* Get the instrument object from the subprotocol - only for MSP, RSP's dont have subprotocols for unit operations *)
    instrumentObjectRules = If[!MatchQ[ToList[instruments], (ListableP[NullP] | {})] && MatchQ[subprotocolPacket, _Association],
        (* Look up the instrument resources field, and take the 1st and 3rd part, which is the mix type and the corresponding instrument that was used for that mix type. *)
        Module[{resources, instruments},
            resources = Lookup[subprotocolPacket, InstrumentResources, Null];
            instruments = If[MatchQ[resources, {{_, _, _}..}],
                resources[[All,{1,3}]],
                Null
            ];
            (* make that a list of rules with MixType -> Instrument *)
            Rule @@@ instruments
        ],
        Null
    ];

    (* Get an image for each unique instrument model *)
    {instrumentModels, modelImages} = Which[

        (* If the instrument is Null (eg MixType could be Invert which doesn't require an instrument), set both of these to a flat list of Nulls with the same Length as instruments. *)
        MatchQ[ToList[instruments], (ListableP[NullP] | {})],
            ConstantArray[ConstantArray[Null, Length[instruments]], 2],

        (* Most likely the instruments in the output unit operations were input as Model[Instruments]'s, so first check that *)
        MatchQ[ToList[instruments], {ObjectP[Model[Instrument]]..}],
            {ToList[instruments][Object], Lookup[instrumentPackets, ImageFile, Null]},

        (* Otherwise if there are any Object[Instrument] or Model[Instrument] inputs, map through the instruments and lookup the ImageFile from either the instrument model packet or the instrument packet. *)
        MemberQ[ToList[instruments], ObjectP[{Object[Instrument], Model[Instrument]}]],
            Transpose[MapThread[
                Function[{instrumentInput, index},
                    Which[
                        MatchQ[instrumentInput, ObjectP[Object[Instrument]]],
                            {Lookup[instrumentPackets[[index]], Model, Null], Lookup[instrumentModelPackets[[index]], ImageFile, Null]},
                        MatchQ[instrumentInput, ObjectP[Model[Instrument]]],
                            {instrumentInput, Lookup[instrumentPackets[[index]], ImageFile, Null]},
                        True,
                            {instrumentInput, Null}
                    ]
                ],
                {ToList[instruments], Range[Length[ToList[instruments]]]}
            ]],

        (* Otherwise, if the instrument input does not contain any models or objects, just return the instrument inputs and Null for the images *)
        True,
            {ToList[instruments], ConstantArray[Null, Length[ToList[instruments]]]}
    ];

    (* Get the instrument objects. If we have no instrumentObjectRules, this is just a flat list of Nulls. *)
    instrumentObjects = If[!MatchQ[instrumentObjectRules, ListableP[_Rule]],
        ConstantArray[Null, Length[instrumentModels]],
        (* Otherwise, map over all of the items and get the subtype. Then make replacements as needed. *)
        Map[
            If[NullQ[#], Null, #[[2]]]&,
            instrumentModels
        ] /. instrumentObjectRules
    ];

    (* Find the positions at which we mix by Stir, Invert, or Swirl; we record video for these mix types and should show it. *)
    mixTypes = Lookup[outputUnitOpPacket, MixType, {}];
    streamableIndices = Flatten @ Position[mixTypes, Alternatives[Stir, Invert, Swirl], {1}];

    (* Generate stream buttons as needed. *)
    streamButtons = If[FreeQ[streamableIndices, _Integer],
        (* If there is no chance that we have mix types with streaming, don't bother with this. *)
        {},
        (* Otherwise, get any available streams and find the appropriate starting point. *)
        Module[
            {
                startTaskIDP, streamPackets, procedureEventPackets, overheadStirrerTuples, samplesIn, instrumentResources, overheadStirIndices,
                overheadStirrerToStreamRules, sampleInToOverheadStirrerRules, overheadingStirringStreamsBySample, uniqueTaskIDEventPackets,
                taskIDs, datesCreated, startTaskPositions, streamableMixTypeStartTimes, allMixStartTimes, streamPacketsToUse, startTimesInSeconds
            },

            startTaskIDP = Alternatives @@ {
                (* Stir *)
                "ab891342-3d22-443b-bde5-d2d533c3b628", (* "Incubate Stir PDU" *)
                (* Invert *)
                "a7307303-bcac-43c0-b1f6-29acee9f8321", (* "Incubate Invert in Mixing Zone Slot" *)
                "4973a462-474b-47c4-8afe-fb4205e83f70", (* "Incubate Invert (no Mixing Zone Slot)" *)
                "7db4b99c-4a2e-47d3-83b3-51396d915779", (* "Incubate Invert Mix Until Dissolved in Mixing Zone Slot" *)
                "5211a2bb-c284-4019-be57-5331e304736a", (* "Incubate Invert Mix Until Dissolved (no Mixing Zone Slot)" *)
                (* Swirl *)
                "edc2e3c6-c5a8-41da-baec-4354c4643815", (* "Incubate Swirl in Mixing Zone Slot" *)
                "866ebcaf-fb5d-4f47-8cd2-6fe83319c245"  (* "Incubate Swirl (no Mixing Zone Slot)" *)
            };

            (* Download what we need from the protocol object. *)
            {streamPackets, procedureEventPackets, overheadStirrerTuples} = Quiet[
                Download[Lookup[subprotocolPacket, Object],
                    {
                        Packet[Streams[{Object, StartTime, EndTime, Protocol}]],
                        Packet[ProcedureLog[{Object, TaskID, DateCreated, EventType}]],
                        Streams[{Object, VideoCaptureComputer[Instruments]}]
                    }
                ]
            ];

            (* Get the SamplesIn and InstrumentResources from the protocol packet. *)
            {samplesIn, instrumentResources} = Lookup[subprotocolPacket, {SamplesIn, InstrumentResources}];

            (* Get the indices at which overhead stirring is used. *)
            overheadStirIndices = Flatten @ Position[mixTypes, Stir, {1}];

            (* Convert the overhead stirrer tuples to rules. *)
            overheadStirrerToStreamRules = If[FreeQ[overheadStirrerTuples, {ObjectP[Object[Stream]], {ObjectP[Object[Instrument, OverheadStirrer]]..}}],
                {},
                Map[
                    Download[FirstCase[#[[2]], ObjectP[Object[Instrument, OverheadStirrer]], {}], Object] -> #[[1]] &,
                    overheadStirrerTuples
                ]
            ];

            (* Make rules from samples in to overhead stirrer. *)
            sampleInToOverheadStirrerRules = If[FreeQ[overheadStirrerTuples, {ObjectP[Object[Stream]], {ObjectP[Object[Instrument, OverheadStirrer]]..}}],
                {},
                MapThread[
                    #1 -> #2&,
                    {samplesIn[[overheadStirIndices]][Object], Cases[instrumentResources, {Stir, _Integer, ObjectP[Object[Instrument, OverheadStirrer]]}][[All, -1]][Object]}
                ]
            ];

            (* Thread these rules together to generate a list of overhead stirrer streams for each sample if we used overhead stirring. *)
            overheadingStirringStreamsBySample = samplesIn /. sampleInToOverheadStirrerRules /. overheadStirrerToStreamRules;

            (* Delete duplicate packets by event type. *)
            uniqueTaskIDEventPackets = PickList[
                procedureEventPackets,
                Lookup[procedureEventPackets, EventType, Null],
                TaskStart
            ];

            (* Get the task IDs and dates created for the procedure events. *)
            {taskIDs, datesCreated} = Transpose @ Lookup[uniqueTaskIDEventPackets, {TaskID, DateCreated}];

            (* Get the positions of the start task for each streamable mix type. Use these to get the times. *)
            startTaskPositions = Flatten[Position[taskIDs, startTaskIDP] + 1];

            streamableMixTypeStartTimes = Module[
                {startTimesIfAny},
                startTimesIfAny = datesCreated[[startTaskPositions]];
                If[SameQ[startTimesIfAny, {}],
                    ConstantArray[Null, Length[streamableIndices]],
                    startTimesIfAny
                ]
            ];

            (* Insert these start times appropriately into a list with length equal to the number of samples. *)
            allMixStartTimes = ReplacePart[
                ConstantArray[Null, Length[mixTypes]],
                MapThread[
                    #1 -> #2&,
                    {streamableIndices, streamableMixTypeStartTimes}
                ]
            ];

            (* Find which stream packet corresponds to each mixing event. *)
            streamPacketsToUse = Flatten @ MapThread[
                Function[
                    {startTime, stirStream},
                    If[NullQ[startTime],
                        Null,
                        Module[
                            {possiblePacket},

                            (* If there is an already identified overhead stirring stream at this index, we can *)
                            (* easily find which packet to use with the rules above. If not, use the start and *)
                            (* end time of the stream relative to the procedure event time to find the correct packet. *)
                            possiblePacket = If[MemberQ[Lookup[streamPackets, Object], ObjectP[stirStream]],
                                FirstCase[streamPackets, ObjectP[stirStream]],
                                Select[
                                    streamPackets,
                                    MatchQ[startTime, RangeP[Lookup[#, StartTime] - 60 Second, Lookup[#, EndTime]]]&
                                ]
                            ];

                            If[MatchQ[possiblePacket, {}], Null, possiblePacket]
                        ]
                    ]
                ],
                {allMixStartTimes, overheadingStirringStreamsBySample}
            ];

            (* Get the start time of the mixing step in terms of unitless seconds from the start of the appropriate stream. *)
            startTimesInSeconds = MapThread[
                Function[
                    {startTime, streamPacket},
                    If[NullQ[streamPacket],
                        Null,
                        Max[Round[Unitless[Convert[startTime - Lookup[streamPacket, StartTime], 1 Second]]], 0]
                    ]
                ],
                {allMixStartTimes, streamPacketsToUse}
            ];

            (* Return the buttons or "N/A" placeholder. *)
            MapThread[
                Function[
                    {streamObject, timeArg},
                    If[NullQ[streamObject] || NullQ[timeArg],
                        Null,
                        With[
                            {
                                playButtonGraphic = $PlayButtonGraphic,
                                explicitStreamObject = streamObject,
                                explicitTimeArg = timeArg
                            },
                            Button[
                                Tooltip[playButtonGraphic, "Play Stream"],
                                WatchProtocol[explicitStreamObject, explicitTimeArg],
                                Method -> "Queued",
                                Appearance -> "Frameless"
                            ]
                        ]
                    ]
                ],
                {Lookup[streamPacketsToUse /. Null -> <||>, Object, Null], startTimesInSeconds}
            ]
        ]
    ];

    (* If we generated any stream buttons, append them to the formatted table data. *)
    tableDataFormattedWithStreams = If[FreeQ[streamButtons, _Button],
        tableDataFormatted,
        Append[tableDataFormatted, Stream -> streamButtons]
    ];

    (* Display a grid for each instrument model that has an image of the model on top, the name of the model below that, then a table with the unit op info. *)
    (* Split the input lists by instrument model *)
    splitInstrumentModelsList = Split[instrumentModels];

    {
        splitImages,
        splitInstruments,
        splitInstrumentObjects,
        splitSampleInfo,
        splitTableData
    } = Unflatten[#, splitInstrumentModelsList]& /@ {modelImages, instruments, instrumentObjects, clickableSamples, Transpose[Values[tableDataFormattedWithStreams]]};

    tables = MapThread[Function[{models, instrumentObjects, images, samples, tableData},
        Module[{headings, combinedTableInfo, finalHeadings, mergedTableInfo},

            headings = ToString /@ Prepend[Keys[tableDataFormattedWithStreams], Sample];

            combinedTableInfo = Prepend[Transpose[tableData], samples];

            {finalHeadings, mergedTableInfo} = mergeGridCellsVertical[headings, combinedTableInfo];

            Column[
                {
                    (* If there is an image, show it. *)
                    If[MatchQ[FirstCase[images, ObjectP[]], ObjectP[Object[EmeraldCloudFile]]],
                        Framed[Pane@Image[ImageResize[ImportCloudFile[FirstCase[images, ObjectP[]]], $ReviewImageResolution], ImageSize -> $ReviewImageSize], FrameStyle -> LightGray],
                        Nothing
                    ],

                    (* Show the instrument model if there is one. *)
                    If[MatchQ[First[models], ObjectP[Model[Instrument]]],
                        customButton[First[models]],
                        Nothing
                    ],

                    (* If we were able to get the instrument object from the subprotocol, show that as well *)
                    If[MatchQ[instrumentObjects, ListableP[ObjectP[Object[Instrument]]]],
                        customButton[First[models]],
                        Nothing
                    ],

                    (* Create a table of the model, labels, and containers *)
                    Labeled[
                        Pane[
                            Grid[
                                {
                                    Style[#, 12, Bold, FontFamily->"Helvetica"]& /@ finalHeadings,
                                    Sequence @@ Transpose[mergedTableInfo]
                                },
                                Frame -> All,
                                Alignment -> {Center, Center},
                                Spacings -> {2, 1},
                                ItemStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica"],
                                FrameStyle -> Lighter[Gray,0.4],
                                Alignment -> {Center, Center},
                                Dividers -> {
                                    {2 -> Directive[Thick, Darker[Gray]]},
                                    {2 -> Directive[Thick, Darker[Gray]]}
                                },
                                Background -> White,
                                ItemSize -> UpTo[20]
                            ],
                            ImageSize -> {UpTo[700], UpTo[600]},
                            Scrollbars -> Automatic,
                            AppearanceElements -> None,
                            ImageSizeAction -> "Scrollable"
                        ],
                        If[MatchQ[sampleInputLabels, Except[ListableP[Null]]],
                            Style["Sample Input: " <> ToString[sampleInputLabels], Bold, FontFamily->"Helvetica"],
                            ""
                        ],
                        Top
                    ]
                },
                Alignment -> Center,
                Spacings -> 2
            ]
        ]
    ],
        {splitInstrumentModelsList, splitInstrumentObjects, splitImages, splitSampleInfo, splitTableData}
    ];

    Column[tables,
        Alignment -> Center,
        Spacings -> {1, 6}
    ]
];

centrifugeUnitOperationPrimaryData[
  optimizedUnitOpPacket_Association,
  calculatedUnitOpPacket_Association,
  outputUnitOpPacket_Association,
  optimizedUserOptions_Association,
  instrumentPackets_List,
  instrumentModelPackets_List,
  subprotocolPacket: (_Association | Null)
] := Module[{excludedKeys, specifiedKeys, tableDataRules, tableDataFormatted, sampleFormatAdjustedTableRules,
  centrifugedSamples, clickableSamples,
  instruments, instrumentObjectRules, instrumentModels, modelImages, instrumentObjects, splitInstrumentModelsList, splitImages,
  splitInstruments, splitInstrumentObjects, splitSampleInfo, splitTableData, tables, streams, streamButtons, tableDataFormattedWithStreams},

  (* Keys that we don't need to show, they would be covered by other specified options *)
  excludedKeys = {WeightStabilityDuration, MaxWeightVariation, Instrument, Rotor};

  (* Get the Keys for the options that are in the optimized unit operation, that were not Null or {} *)
  specifiedKeys = Keys[optimizedUserOptions];

  (* Get the values of those keys from the output unit operation. Remove any sample options since we will get those inputs elsewhere *)
  tableDataRules = KeyDrop[KeyTake[outputUnitOpPacket, specifiedKeys], Join[excludedKeys, {SampleExpression, SampleLink, SampleString, SampleLabel, SampleContainerLabel}]];

  centrifugedSamples = Module[
    {allSampleFormats, sampleList},

    allSampleFormats = Lookup[calculatedUnitOpPacket, {SampleLink, SampleString, SampleExpression}];
    sampleList = FirstCase[allSampleFormats, Except[ListableP[Null] | {}]];

    Map[
      If[MatchQ[#, ObjectP[{Object[Sample], Model[Sample], Object[Container]}]],
        #[Object],
        #
      ]&
      ,
      sampleList
    ]
  ];

  sampleFormatAdjustedTableRules = If[MatchQ[centrifugedSamples, ListableP[ObjectP[Object[Container, Plate]]]],
    Module[{uniqueTableEntries},
      uniqueTableEntries = DeleteDuplicates[Transpose[Values[tableDataRules]]];
      Rule @@@ Transpose[{Keys[tableDataRules], Transpose[uniqueTableEntries]}]
    ],
    tableDataRules
  ];

  (* Make samples click to copy *)
  clickableSamples = Tooltip[ClickToCopy[#], #]& /@ centrifugedSamples;

  (* Get the instrument from the output unit op packet. *)
  instruments = NamedObject[Lookup[calculatedUnitOpPacket, Instrument, {}]];

  (* Get the instrument object from the subprotocol - only for MSP, RSP's dont have subprotocols for unit operations *)
  instrumentObjectRules = If[!MatchQ[ToList[instruments], (ListableP[NullP] | {})] && MatchQ[subprotocolPacket, _Association],
    (* Look up the instrument resources field, and take the 1st and 3rd part, which is the mix type and the corresponding instrument that was used for that mix type. *)
    Module[{resources, instruments},
      resources = Lookup[subprotocolPacket, InstrumentResources, Null];
      instruments = If[MatchQ[resources, {{_, _, _}..}],
        resources[[All,{1,3}]],
        Null
      ];
      (* make that a list of rules with MixType -> Instrument *)
      Rule @@@ instruments
    ],
    Null
  ];

  (* Get an image for each unique instrument model *)
  {instrumentModels, modelImages} = Which[

    (* If the instrument is Null (eg MixType could be Invert which doesn't require an instrument), set both of these to a flat list of Nulls with the same Length as instruments. *)
    MatchQ[ToList[instruments], (ListableP[NullP] | {})],
    ConstantArray[ConstantArray[Null, Length[instruments]], 2],

    (* Most likely the instruments in the output unit operations were input as Model[Instruments]'s, so first check that *)
    MatchQ[ToList[instruments], {ObjectP[Model[Instrument]]..}],
    {ToList[instruments][Object], Lookup[instrumentPackets, ImageFile, Null]},

    (* Otherwise if there are any Object[Instrument] or Model[Instrument] inputs, map through the instruments and lookup the ImageFile from either the instrument model packet or the instrument packet. *)
    MemberQ[ToList[instruments], ObjectP[{Object[Instrument], Model[Instrument]}]],
    Transpose[MapThread[
      Function[{instrumentInput, index},
        Which[
          MatchQ[instrumentInput, ObjectP[Object[Instrument]]],
          {Lookup[instrumentPackets[[index]], Model, Null], Lookup[instrumentModelPackets[[index]], ImageFile, Null]},
          MatchQ[instrumentInput, ObjectP[Model[Instrument]]],
          {instrumentInput, Lookup[instrumentPackets[[index]], ImageFile, Null]},
          True,
          {instrumentInput, Null}
        ]
      ],
      {ToList[instruments], Range[Length[ToList[instruments]]]}
    ]],

    (* Otherwise, if the instrument input does not contain any models or objects, just return the instrument inputs and Null for the images *)
    True,
    {ToList[instruments], ConstantArray[Null, Length[ToList[instruments]]]}
  ];

  (* Get the instrument objects. If we have no instrumentObjectRules, this is just a flat list of Nulls. *)
  instrumentObjects = If[!MatchQ[instrumentObjectRules, ListableP[_Rule]],
    ConstantArray[Null, Length[instrumentModels]],
    (* Otherwise, map over all of the items and get the subtype. Then make replacements as needed. *)
    Map[
      If[NullQ[#], Null, #[[2]]]&,
      instrumentModels
    ] /. instrumentObjectRules
  ];

  (* Get the Streams associated with this unit operation, if any. (We don't have streams for centrifuge at this time but could in the future.) *)
  streams = If[MatchQ[subprotocolPacket, PacketP[]], Download[Lookup[subprotocolPacket, Streams, {}], Object], {}];

  (* If we generated any stream buttons, append them to the formatted table data. *)
  tableDataFormattedWithStreams = If[MemberQ[streamButtons, _Button],
    Append[tableDataRules, Stream -> streamButtons],
    sampleFormatAdjustedTableRules
  ];

  (* Display a grid for each instrument model that has an image of the model on top, the name of the model below that, then a table with the unit op info. *)
  (* Split the input lists by instrument model *)
  splitInstrumentModelsList = Split[instrumentModels];

  {
    splitImages,
    splitInstruments,
    splitInstrumentObjects,
    splitSampleInfo,
    splitTableData
  } = Unflatten[#, splitInstrumentModelsList]& /@ {modelImages, instruments, instrumentObjects, clickableSamples, Transpose[Values[tableDataFormattedWithStreams]]};

  tables = MapThread[Function[{models, instrumentObjects, images, samples, tableData},
    Module[{headings, combinedTableInfo, finalHeadings, mergedTableInfo},

      headings = ToString /@ Prepend[Keys[tableDataFormattedWithStreams], Sample];

      combinedTableInfo = Prepend[Transpose[tableData], samples];

      {finalHeadings, mergedTableInfo} = mergeGridCellsVertical[headings, combinedTableInfo];

      Column[
        {
          (* If there is an image, show it. *)
          If[MatchQ[FirstCase[images, ObjectP[]], ObjectP[Object[EmeraldCloudFile]]],
            Framed[Pane@Image[ImageResize[ImportCloudFile[FirstCase[images, ObjectP[]]], $ReviewImageResolution], ImageSize -> $ReviewImageSize], FrameStyle -> LightGray],
            Nothing
          ],

          (* Show the instrument model if there is one. *)
          If[MatchQ[First[models], ObjectP[Model[Instrument]]],
            customButton[First[models]],
            Nothing
          ],

          (* If we were able to get the instrument object from the subprotocol, show that as well *)
          If[MatchQ[instrumentObjects, ListableP[ObjectP[Object[Instrument]]]],
              customButton[First[instrumentObjects]],
            Nothing
          ],

          (* Create a table of the model, labels, and containers *)
          Labeled[
            Pane[
              Grid[
                {
                  Style[#, 12, Bold, FontFamily->"Helvetica"]& /@ finalHeadings,
                  Sequence @@ Transpose[NamedObject[mergedTableInfo]]
                },
                Frame -> All,
                Alignment -> {Center, Center},
                Spacings -> {2, 1},
                ItemStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica"],
                FrameStyle -> Lighter[Gray,0.4],
                Alignment -> {Center, Center},
                Dividers -> {
                  {2 -> Directive[Thick, Darker[Gray]]},
                  {2 -> Directive[Thick, Darker[Gray]]}
                },
                Background -> White,
                ItemSize -> UpTo[20]
              ],
              ImageSize -> {UpTo[700], UpTo[600]},
              Scrollbars -> Automatic,
              AppearanceElements -> None,
              ImageSizeAction -> "Scrollable"
            ],
            Style["Centrifuged Samples", Bold, FontFamily->"Helvetica"],
            Top
          ]
        },
        Alignment -> Center,
        Spacings -> 2
      ]
    ]
  ],
    {splitInstrumentModelsList, splitInstrumentObjects, splitImages, splitSampleInfo, splitTableData}
  ];

  Column[tables,
    Alignment -> Center,
    Spacings -> {1, 6}
  ]
];

plateReaderUnitOperationPrimaryData[
    outputUnitOpPacket_Association,
    optimizedUserOptions_Association,
    instrumentPackets_List,
    instrumentModelPackets_List
] := Module[{fkUnitOpInfo, fkSampleInfo, instruments, instrumentModels, modelImages, tableSetup, subheadings},

    fkUnitOpInfo = Lookup[optimizedUserOptions, {ExcitationWavelength, EmissionWavelength, Gain, Temperature, NumberOfReadings}, Nothing];

    fkSampleInfo = NamedObject[Module[{links, expressions, strings},
        {links, expressions, strings} = Lookup[outputUnitOpPacket, {SampleLink, SampleExpression, SampleString}, Null];
        (* Map through each sample, and pull out whichever of the sample fields is populated *)
        Map[
            FirstCase[#, Except[ListableP[Null]], Null]&,
            Transpose[{links, expressions, strings}]
        ]
    ]];

    (* Get the instrument from the output unit op packet. It will be in the Instrument field *)
    instruments = Lookup[outputUnitOpPacket, Instrument, {}][Object];

    (* Get an image for each unique container model *)
    {instrumentModels, modelImages} = Which[

        (* Most likely the instruments in the output unit operations were input as Model[Instruments]'s, so first check that *)
        MatchQ[ToList[instruments], {ObjectP[Model[Instrument]]..}],
            {ToList[instruments][Object], ToList[Lookup[instrumentPackets, ImageFile, Null]]},

        (* Otherwise if there are any Object[Instrument] or Model[Instrument] inputs, map through the instruments and lookup the ImageFile from either the instrument model packet or the instrument packet. *)
        MemberQ[ToList[instruments], ObjectP[{Object[Instrument], Model[Instrument]}]],
            Transpose[MapThread[
                Function[{containerInput, index},
                    Which[
                        MatchQ[containerInput, ObjectP[Object[Container]]],
                            {Lookup[instruments[[index]], Model, Null], Lookup[instrumentModelPackets[[index]], ImageFile, Null]},
                        MatchQ[containerInput, ObjectP[Model[Container]]],
                            {containerInput, Lookup[instrumentPackets[[index]], ImageFile, Null]},
                        True,
                            {containerInput, Null}
                    ]
                ],
                {ToList[instruments], Range[Length[ToList[instruments]]]}
            ]],

        (* Otherwise, if the instrument input does not contain any models or objects, just return the instrument inputs and Null for the images *)
        True,
            {ToList[instruments], ConstantArray[Null, Length[ToList[instruments]]]}
    ];

    tableSetup = Map[
        If[!SameQ[Length[#], Length[fkSampleInfo]],
            PadRight[ToList[#], Length[fkSampleInfo], SpanFromAbove],
            #
        ]&
        ,
        Join[
            {fkSampleInfo},
            fkUnitOpInfo
        ]
    ];

    subheadings = Style[#, Bold]&/@{
        "Sample", "Excitation Wavelength",
        "Emission Wavelength", "Gain"
    };

    Column[
        {
            Labeled[
                First[ImportCloudFile /@ modelImages],
                NamedObject[First[instrumentModels]]
            ],

            Pane[
                Grid[
                    Prepend[
                        Transpose[tableSetup],
                        subheadings
                    ],
                    Frame -> All,
                    Spacings -> {2,1},
                    ItemStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica"],
                    FrameStyle -> Lighter[Gray,0.4],
                    Alignment -> {Center, Center},
                    Dividers -> {
                        {2 -> Directive[Thick, Darker[Gray]], 3 -> Directive[Thick, Darker[Gray]], 6 -> Directive[Thick, Darker[Gray]]},
                        {2 -> Directive[Thick, Darker[Gray]]}
                    },
                    Background -> White
                ],
                ImageSize -> {UpTo[700], UpTo[600]},
                Scrollbars -> Automatic,
                AppearanceElements -> None
            ]
        },
        Alignment->Center,
        Spacings -> 5
    ]
];

(* fillToVolumeUnitOperationPrimaryData *)

Authors[fillToVolumeUnitOperationPrimaryData]:={"tyler.pabst"};

fillToVolumeUnitOperationPrimaryData[outputUnitOpPacket_Association] := Module[
    {
        totalVolumes, containerLabels, containerLinks, sampleLinks, solventLinks, methods, imageSampleQ,
        dateCompleted, ftvProtocol, qsPacket, streamPackets, streamParentProtocolPackets, procedureEventPackets, solventModels, containerModels, meniscusCloudFiles,
        targetsAchievedQ, overfillingRepreparations, safeStreamPackets, safeProcedureEventPackets, flatSolventModels, flatContainerModels, streamProtocolToParentLookup,
        safeMeniscusImages, safeMeniscusCloudFiles, imageQs, qsStartTaskP, streamTuples, imageButtons, streamButtons,
        safeContainerLabels, safeContainerLinks, safeSolventLinks, safeSolventModels, safeContainerModels, safeStreamButtons,
        gridFormat, tables
    },

    (* Get the relevant information we need from the protocol packet. *)
    {
        totalVolumes,
        containerLabels,
        containerLinks,
        sampleLinks,
        solventLinks,
        methods,
        imageSampleQ,
        dateCompleted,
        ftvProtocol
    } = Lookup[outputUnitOpPacket,
        {
            TotalVolume,
            SampleContainerLabel,
            SampleContainerLink,
            SampleLink,
            SolventLink,
            Method,
            ImageSample,
            DateCompleted,
            Subprotocol
        }
    ];

    (* Download *)
    {qsPacket, {{streamPackets}}, {{streamParentProtocolPackets}}, {{procedureEventPackets}}, solventModels, containerModels} = Quiet[
        Download[
            {
                {ftvProtocol},
                {ftvProtocol},
                {ftvProtocol},
                {ftvProtocol},
                solventLinks,
                containerLinks
            },
            {
                {Packet[MeniscusImages, TargetVolumeToleranceAchieved, OverfillingRepreparations]},
                {Packet[Subprotocols[Subprotocols][Streams][Object, StartTime, Protocol]]},
                {Packet[Subprotocols[Subprotocols][Streams][Protocol][ParentProtocol]]},
                {Packet[Subprotocols[Subprotocols][ProcedureLog][Object, TaskID, DateCreated]]},
                {Model[Object]},
                {Model[Object]}
            },
            Date -> dateCompleted
        ]
    ];

    (* Parse some info from the download. *)
    meniscusCloudFiles = Lookup[Flatten[qsPacket][[1]], MeniscusImages, Null];
    targetsAchievedQ = Lookup[Flatten[qsPacket][[1]], TargetVolumeToleranceAchieved, Null];
    overfillingRepreparations = Lookup[Flatten[qsPacket][[1]], OverfillingRepreparations, {}];
    safeStreamPackets = Flatten[streamPackets, 1];
    safeProcedureEventPackets = Flatten[procedureEventPackets, 1];
    {flatSolventModels, flatContainerModels} = Flatten /@ {solventModels, containerModels};

    (* Generate a lookup from the stream-linked protocols to the parent protocols thereof. *)
    streamProtocolToParentLookup = If[FreeQ[Flatten[streamParentProtocolPackets], ObjectP[Object[Stream]]],
        {},
        MapThread[
            Function[{streamLinkedProtocol, parentProtocol},
                streamLinkedProtocol -> Download[parentProtocol, Object]
            ],
            Transpose[Lookup[Flatten[streamParentProtocolPackets], {Object, ParentProtocol}]]
        ]
    ];

    (* If we got images from the Download, assign these and the cloud files to the appropriate variables. *)
    (* Otherwise, just set these variables to flat lists of Nulls of the correct length so this doesn't trainwreck. *)
    {safeMeniscusImages, safeMeniscusCloudFiles} = If[MatchQ[meniscusCloudFiles, {ObjectP[Object[EmeraldCloudFile]]..}],
        {ImportCloudFile /@ meniscusCloudFiles, meniscusCloudFiles},
        ConstantArray[
            ConstantArray[Null, Length[totalVolumes]],
            2
        ]
    ];

    (* Indicate whether there is an image for each index. *)
    imageQs = MapThread[
        Function[
            {image, imageCloudFile},
            MatchQ[imageCloudFile, ObjectP[Object[EmeraldCloudFile]]] && ImageQ[image]
        ],
        {safeMeniscusImages, safeMeniscusCloudFiles}
    ];

    (* Generate a pattern to identify the starting time for the QS steps. There are a few different procedure  *)
    (* branches that might be relevant, so we need to check for several task IDs. *)
    qsStartTaskP = Alternatives @@ {
        "41a276b9-c461-4f73-a31b-0b5c8f7233dd",
        "81dad16d-726d-4c6a-b76c-ed6dbff60679",
        "12544256-42fb-4e9b-858e-c73e497cac48",
        "6fad2043-0093-4bab-8fee-795cd8779aa0",
        "9df4e458-e862-4bfa-9283-81d3ccfa7756",
        "e6bb77da-73ab-4828-ae50-3013f6978175",
        "59fe5fe3-ff06-4728-a3ec-e6b5edae3001" (* This task no longer exists but is here for backwards compatibility *)
    };

    (* Build stream tuples in the format {stream object, timepoint in unitless seconds} to view the QS steps. *)
    streamTuples = MapThread[
        Function[
            {streamPacketsPerSub, procedureEventPacketsPerSub},

            If[Or[
                !MatchQ[Lookup[streamPacketsPerSub, StartTime, Null], {_?DateObjectQ..}],
                FreeQ[Lookup[procedureEventPacketsPerSub, TaskID], qsStartTaskP],
                MatchQ[
                    Download[FirstCase[Lookup[streamPacketsPerSub, Protocol, {}], ObjectP[]], Object] /. streamProtocolToParentLookup,
                    ObjectP[overfillingRepreparations]
                ]
            ],
                Nothing,
                Module[
                    {taskIDs, datesCreated, startTaskPosition, qsStartTime, streamPacketToUse, startTimeInSeconds},

                    (* Get the task IDs and dates created for each procedure event in this transfer subprotocol. *)
                    {taskIDs, datesCreated} = Transpose @ Lookup[procedureEventPacketsPerSub, {TaskID, DateCreated}];

                    (* Find the position in the procedure event log of the earliest procedure event involving *)
                    (* the "start task" in this protocol. Do the same for the position of the latest "end task". *)
                    startTaskPosition = Min @ Flatten[Position[taskIDs, qsStartTaskP]];

                    (* Use these values to find the start and end dates for the QS step. *)
                    qsStartTime = datesCreated[[startTaskPosition]];

                    (* Find out which stream to use for WatchProtocol. If there's just one, this is easy. *)
                    streamPacketToUse = If[SameQ[Length[streamPacketsPerSub], 1],
                        streamPacketsPerSub[[1]],
                        (* If there are multiple streams for this sub, find the latest stream that started before the QS step. *)
                        Module[
                            {startTimeOfCorrectStream},
                            startTimeOfCorrectStream = Max @ Cases[Lookup[streamPacketsPerSub, StartTime], LessP[qsStartTime]];
                            First @ PickList[
                                streamPacketsPerSub,
                                Lookup[streamPacketsPerSub, StartTime, Null],
                                startTimeOfCorrectStream
                            ]
                        ]
                    ];

                    (* Get the time stamp in unitless seconds relative to the start of the stream. *)
                    startTimeInSeconds = Round[Unitless[Convert[qsStartTime - Lookup[streamPacketToUse, StartTime], 1 Second]]];

                    (* Return the tuples for this stream. *)
                    {Lookup[streamPacketToUse, Object], startTimeInSeconds}
                ]
            ]
        ],
        {safeStreamPackets, safeProcedureEventPackets}
    ];

    (* Set up the image buttons. *)
    imageButtons = If[MemberQ[imageQs, True],
        With[
            {
                explicitImages = safeMeniscusImages,
                explicitImageCloudFiles = safeMeniscusCloudFiles
            },

            MapThread[
                Function[
                    {imageQ, image, imageCloudFile},
                    If[imageQ,
                        Tooltip[
                            Button[Show[image, ImageSize -> $ReviewImageSize], OpenCloudFile[imageCloudFile],
                                Appearance -> "Frameless",
                                Method -> "Queued"
                            ],
                            "Open Image"
                        ],
                        Null
                    ]
                ],
                {imageQs, explicitImages, explicitImageCloudFiles}
            ]
        ],
        ConstantArray[Null, Length[totalVolumes]]
    ];

    (* Set up the stream buttons. *)
    streamButtons = If[!MatchQ[streamTuples, {}],
        With[
            {
                playButtonGraphic = Show[$PlayButtonGraphic, ImageSize -> 25],
                explicitStreamObjects = streamTuples[[All, 1]],
                explicitStreamTimes = streamTuples[[All, 2]]
            },
            MapThread[
                Function[
                    {streamObject, timeArg},
                    If[NullQ[streamObject],
                        Null,
                        Button[
                            Tooltip[playButtonGraphic, "Play Stream"],
                            WatchProtocol[streamObject, timeArg],
                            Method -> "Queued",
                            Appearance -> "Frameless"
                        ]
                    ]
                ],
                {explicitStreamObjects, explicitStreamTimes}
            ]
        ],
        ConstantArray[Null, Length[totalVolumes]]
    ];

    (* Ensure that we don't break the MapThread if one of the Link or Label fields is not the correct length. *)
    {safeContainerLabels, safeContainerLinks, safeSolventLinks, safeSolventModels, safeContainerModels, safeStreamButtons} = Map[
        Function[{list},
            If[SameLengthQ[list, totalVolumes],
                list,
                ConstantArray[Null, Length[totalVolumes]]
            ]
        ],
        {containerLabels, containerLinks, solventLinks, flatSolventModels, flatContainerModels, streamButtons}
    ];

    (* Setup grid formatting options *)
    gridFormat = {
        Background -> tableBackground[2, IncludeHeader -> False],
        Alignment -> {{Right, {Left}}},
        Spacings -> {1.5, 1},
        ItemStyle -> {{Directive[Bold, FontSize -> 12, FontFamily -> "Helvetica"], Directive[FontFamily -> "Helvetica", FontSize -> 12]}},
        Dividers -> {
            {{Directive[Opacity[0]]}},
            {
                Directive[LCHColor[0.4, 0, 0], Thickness[0.5]],
                {
                    1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]],
                    -1 -> Directive[LCHColor[0.4, 0, 0], Thickness[1]]
                }
            }
        }
    };

    (* Make a summary table for each of the FTV samples. *)
    tables = MapThread[
        Function[
            {
                imageButton,
                streamButton,
                containerLabel,
                containerObject,
                containerModel,
                sampleObject,
                solventObject,
                solventModel,
                method,
                totalVolume,
                targetAchievedQ
            },

            Module[
                {tableContent, grid},

                (* Generate the table for each FTV sample according to the available information. *)
                tableContent = {
                    {"Container Label", containerLabel},
                    {"Container Model", containerModel},
                    {"Sample", sampleObject},
                    {"Method", method},
                    {"Target Volume", UnitForm[totalVolume, Brackets -> False]},
                    If[BooleanQ[targetAchievedQ], {"Target Achieved", targetAchievedQ}, Nothing],
                    {"Solvent", solventObject},
                    If[MatchQ[solventModel, ObjectP[Model[Sample]]], {"Solvent Model", solventModel}, Nothing]
                };

                (* Set up the grid and label it. *)
                grid = Grid[Replace[tableContent, {objectValue:ObjectP[] :> customButton[objectValue]}, {2}],
                    Sequence@@gridFormat,
                    ItemSize -> {{All, 25}}
                ];
                Column[
                    {
                        If[NullQ[imageButton], Null, imageButton],
                        If[NullQ[streamButton], Null, streamButton],
                        Labeled[
                            grid,
                            customButton[containerObject],
                            Top,
                            LabelStyle -> Directive[Bold, 16, FontFamily -> "Helvetica"]
                        ]
                    },
                    Alignment -> Center
                ]
            ]

        ],
        {
            imageButtons,
            safeStreamButtons,
            safeContainerLabels,
            safeContainerLinks,
            safeContainerModels,
            sampleLinks[Object],
            safeSolventLinks[Object],
            safeSolventModels,
            methods,
            totalVolumes,
            targetsAchievedQ
        }
    ];

    (* Return in SlideView if there is more than one table to show. Otherwise just return the one table. *)
    If[GreaterQ[Length[tables], 1],
        SlideView[tables, AppearanceElements -> {"FirstSlide", "PreviousSlide", "NextSlide", "LastSlide", "SlideNumber", "SlideTotal"}],
        tables[[1]]
    ]
];

generalUnitOperationPrimaryData[outputUnitOpPacket_Association] := Module[
    {protocol, type},

    (* Get the protocol that corresponds to this unit operation. *)
    protocol = Lookup[outputUnitOpPacket, Subprotocol, {}];

    (* Get the unit operation type. *)
    type = Download[protocol, Type];

    (* If $PrimaryDataPlotter does not include this type, return Null. Else, run the appropriate primaryData function. *)
    If[FreeQ[Keys[$PrimaryDataPlotter], type],
        Null,
        Module[
            {function, output},

            (* Get the primaryData function associated with this Type. *)
            function = type /. $PrimaryDataPlotter;

            (* Run the appropriate function with the protocol as input. *)
            output = function[protocol];

            (* Return, ensuring that any extraneous list wrapper is removed. *)
            If[ListQ[output], Column[output], output]
        ]
    ]
];

(* formatImage *)
(* Helper function to resize sample image and add an action to OpenCloudFile when clicked - agnostic to container type *)
formatImage[importedImage_, imageCloudFile: ObjectP[Object[EmeraldCloudFile]]] := Tooltip[
    Button[
        Pane[Image[ImageResize[importedImage, $ReviewImageResolution], ImageSize -> $ReviewImageSize]],
        OpenCloudFile[imageCloudFile],
        Appearance -> Frameless,
        Method -> "Queued"
    ],
    "Open Image"
];

(* formatImage overload with cloud file as single input *)
formatImage[imageCloudFile: ObjectP[Object[EmeraldCloudFile]]] := formatImage[ImportCloudFile[imageCloudFile], imageCloudFile];
