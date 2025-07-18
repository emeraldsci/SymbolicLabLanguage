(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*GenerateExperimentReview*)


(* ::Section:: *)
(*Source*)


(* ::Subsection:: *)
(* GenerateExperimentReview Constants *)

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
    Autoclave -> "autoclave.png"
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
supportedCellStyles = {"Chapter", "Section", "Subsection", "Subsubsection", "Subsubsubsection", "Text", "Code"};
supportedHeaderStyles = {"Chapter", "Section", "Subsection", "Subsubsection", "Subsubsubsection"};
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
unitFormDistribution[distribution:NullP]:="N/A";

unitFormDistribution[distribution:(_QuantityDistribution|_DataDistribution)]:=Module[
    (* local variables *)
    {scaledDistribution, mean, stdev, unitString, roundedUnitlessMean, roundedUnitlessSTDEV},

    (* Scale the value so that it's in a reasonable unit level *)
    scaledDistribution = UnitScale[distribution];

    (* Let's get the Mean and standard Deviation *)
    mean = Mean[scaledDistribution];
    stdev = StandardDeviation[scaledDistribution];

    (* Get the units as a string *)
    unitString = If[MatchQ[QuantityUnit[mean], Except["DimensionlessUnit"]],
        ToString[QuantityForm[QuantityUnit[mean], "Abbreviation"]],
        Nothing
    ];

    (* Round the values *)
    roundedUnitlessMean = SafeRound[Unitless[mean], 0.01];
    roundedUnitlessSTDEV = SafeRound[Unitless[stdev], 0.001];

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

            (* Assemble the instrument value table *)
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
        instrumentDL, qualToNotebook, partsCache, instrumentPackets, instrumentSummaryTables, createInstrumentSummary},


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
                QualificationLog[[All, 2]][{Object, QualificationNotebook}]
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



    (** Helper to take a packet and convert it into an Instrument summary table **)
    createInstrumentSummary[packet:PacketP[], qualNotebookRules_List, startDate_?DateObjectQ, endDate_?DateObjectQ] := Module[
        (* local variables *)
        {instrumentBasics, softwareVersion, softwareVersionTable, serialNumbers, serialNumberTable, recentQualification,
            outputData, instrumentQualificationTable, instrumentMaintenanceTable, maintenanceTypes,
            calibrationTypes, cleaningTypes, otherMaintenanceTypes, currentMaintenanceLog, allCleanings, recentCleanings,
            allCalibrations, recentCalibrations, allOtherMaintenances, recentOtherMaintenances, instrumentCleaningTable,
            instrumentCalibrationTable, initialOutputData, possibleOutputHeaders, outputHeaders, plotMaintenanceTable,
            qualificationGridRules, instrumentGridRules, qualLogWResult},


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
            from the result log with the qual log*)
        qualLogWResult = Module[
            (* local variables*)
            {qualLogOnly, resultLogOnly},

            (* get the logs related to quals *)
            {qualLogOnly, resultLogOnly} = Lookup[packet, {QualificationLog, QualificationResultsLog}];

            (* associate the result with the qual log entry; default to Null.
                For cases where a qual is re-evaluated, another entry is appended to the result log, so we want to reverse it before finding a match *)
            Map[
                Function[currentQualEntry,
                    Join[
                        currentQualEntry,
                        Lookup[
                            FirstCase[Reverse[resultLogOnly], KeyValuePattern[Qualification -> LinkP[Download[currentQualEntry[[2]], Object]]], <||>],
                            {Date, Result},
                            Null (* default when nothing is found *)
                        ]
                    ]
                ],
                qualLogOnly
            ]
        ];

        (* find the most recent completed qualification from the log *)
        recentQualification = FirstCase[
            Reverse[qualLogWResult],
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


        (** Output **)
        (* Put together all the information *)
        initialOutputData = Join[
            instrumentBasics,
            softwareVersionTable,
            serialNumberTable,
            instrumentQualificationTable,
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
        createInstrumentSummary[#1, qualToNotebook, protocolStartDate, protocolEndDate]&,
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
        nonObjectSubprotocolRequiredResources, formatImage, localNamedObject, formatSampleInformation,
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


    (** Helpers **)
    (* Helper function to resize sample image and add an action to OpenCloudFile when clicked - agnostic to container type *)
    formatImage[importedImage_, imageCloudFile: ObjectP[Object[EmeraldCloudFile]]] := Tooltip[
        Button[
            Pane[ImageResize[importedImage, $ReviewImageSize]],
            OpenCloudFile[imageCloudFile],
            Appearance -> Frameless,
            Method -> "Queued"
        ],
        "Open Image"
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
        Object[Protocol, NMR2D] -> nmrPrimaryData
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
        imageDataObjectFields, imageDataPackets, imageCloudFileObjects,
        importedImages, assembleImageTable
    },

    (* Determine what information needs to be downloaded. *)
    imageDataObjectFields = {
        Object, Instrument, SamplesIn, ContainersIn, ImagingDirection, IlluminationDirection,
        FieldOfView, ExposureTime, UncroppedImageFile, Scale
    };

    (* Download all information. *)
    imageDataPackets = Download[
        protocol,
        Evaluate[Packet[Data[imageDataObjectFields]]]
    ];

    (* Import image cloud files. *)
    imageCloudFileObjects = Lookup[imageDataPackets, UncroppedImageFile, Null];
    importedImages = ImportCloudFile[imageCloudFileObjects];

    (* Set up a helper to make a table of image information including represented samples.  *)
    assembleImageTable[appearanceDataPacket: PacketP[]] := Module[
        {
            appearanceObject, instrument, imagedSamples, imagedContainers,
            fieldOfView, imagingDirection, illuminationDirection, exposureTime,
            uncroppedImageFile, instrumentObject, uncroppedImageFileObject,
            dataHeaderTuples, allData, allHeaders
        },

        {
            appearanceObject, instrument, imagedSamples, imagedContainers, fieldOfView, imagingDirection,
            illuminationDirection, exposureTime, uncroppedImageFile
        } = Lookup[
            appearanceDataPacket,
            {
                Object, Instrument, SamplesIn, ContainersIn, FieldOfView, ImagingDirection,
                IlluminationDirection, ExposureTime, UncroppedImageFile
            }
        ];

        {instrumentObject, uncroppedImageFileObject} = Download[
            {instrument, uncroppedImageFile},
            Object
        ];

        dataHeaderTuples = {
            {appearanceObject, "Data Object"},
            {instrumentObject, "Imaging Instrument"},
            {imagedSamples, "Imaged Samples"},
            {imagedContainers, "Imaged Containers"},
            {fieldOfView, "Field Of View"},
            {imagingDirection, "Imaging Direction"},
            {Column[illuminationDirection], "Illumination Direction"},
            {exposureTime, "Exposure Time"}
        };

        {allData, allHeaders} = Transpose[
            Map[
                If[MatchQ[#[[1]], Except[Null|{}]],
                    {#[[1]], #[[2]]},
                    Nothing
                ]&,
                dataHeaderTuples
            ]
        ];

        PlotTable[
            Partition[allData, 1],
            TableHeadings -> {
                allHeaders,
                None
            },
            ItemSize -> {{All, 25}}
        ]
    ];

    (* Assemble a SlideView of formatted images and image information tables for each image (if there is data). *)
    If[MatchQ[imageDataPackets, Except[{}]],
        {
            assembleSlideView[
                MapThread[
                    Function[{importedImage, imageCloudFileObject, imageDataPacket},
                        Module[{resizedImage, openImageButton},

                            resizedImage = ImageResize[importedImage, $ReviewImageSize];

                            openImageButton =  Button[
                                "Open Image",
                                OpenCloudFile[imageCloudFileObject],
                                Method -> "Queued",
                                ImageSize -> All
                            ];

                            Grid[
                                {
                                    {
                                        Pane[resizedImage],
                                        assembleImageTable[imageDataPacket]
                                    },
                                    {
                                        openImageButton,
                                        SpanFromAbove
                                    }
                                },
                                Spacings -> {$ReviewGridSpacings, $ReviewGridSpacings}
                            ]
                        ]
                    ],
                    {importedImages, imageCloudFileObjects, imageDataPackets}
                ]
            ]
        },
        {
            Inspect[protocol, Abstract -> True, Developer -> False]
        }
    ]
];

(* measureWeightPrimaryData *)

Authors[measureWeightPrimaryData]:={"melanie.reschke"};


(* This function outputs one table or a table and a list of slides *)
measureWeightPrimaryData[protocol: ObjectP[Object[Protocol, MeasureWeight]]] := Module[
    {
        gridFormat, dataPacketsFields, dataPackets, dataObjects, dataDates, sampleModels, samples, weights, tareWeights,
        headings, sampleTables, balanceModelPackets, weightAppearanceObjects, weightAppearances
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
        weightAppearanceObjects
    } = Download[
        protocol,
        {
            Data[dataPacketsFields],
            Packet[Data][Instrument][Model][Name],
            Data[WeightAppearance][UncroppedImageFile][Object]
        }
    ];

    (* Import images and shrink them to display in tooltips *)
    weightAppearances = Map[
        If[NullQ[#], #, ImageResize[#, $ReviewImageSize]]&,
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
                formattedWeightDist = customButton[unitFormDistribution[weightDist],
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
                {summaryContent, summaryHeadings, weightDiplayIndex = 1},

                (* if there were no SamplesIn, don't show that column *)
                summaryContent = MapThread[
                    Replace[{
                        #1,
                        With[{explicitValue = #1}, RadioButton[Dynamic[weightDiplayIndex, TrackedSymbols :> {weightDiplayIndex}], explicitValue]],
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
                            Dynamic[explicitSampleTables[[weightDiplayIndex]], TrackedSymbols :> {weightDiplayIndex}],
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
        If[NullQ[#], #, ImageResize[#, $ReviewImageSize]]&,
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


(*hplcPrimaryData*)

Authors[hplcPrimaryData]:={"malav.desai"};

hplcPrimaryData[protocol: ObjectP[Object[Protocol, HPLC]]] := Module[
    {
        injectionAssociationInitial, separationMode, scale, dataDetails, injectionAssociation, injectionData,
        sampleFields, sampleMeta, chromatograms, filterableLCData, dynamicChromatogramTable, tableFontSize,
        uniqueInjectionTypes, protocolStatus, detectors, includedTypes, gradientBuffers, gradientPlotRules,
        protocolBufferA, protocolBufferB, protocolBufferC, protocolBufferD, protocolBufferAModel,
        protocolBufferBModel, protocolBufferCModel, protocolBufferDModel, protocolBufferObjects,
        protocolBufferModelNames, protocolBufferModels, cleanLegendEntries, zoomableChromatograms
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

    (* get the injection table *)
    injectionAssociation = MapThread[
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
    dynamicChromatogramTable = With[
        {
            manipulationData = filterableLCData,
            uniqueInjTypes = uniqueInjectionTypes
        },
        Manipulate[
            Pane[
                Grid[
                    Drop[Cases[
                        manipulationData,
                        {Alternatives@@includedTypes, ___},
                        {1}
                    ], None, 1],
                    Background -> tableBackground[2, IncludeHeader -> False],
                    Alignment -> {Right, Left},
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
                    ImageSize -> $ReviewPlotSize,
                    Zoomable -> $ZoomableBoolean
                ],
                (* In Manifold, we will make it so the user can apply zoomable to the plot *)
                zoomableButton@PlotChromatography[systemPrimeData,
                    PrimaryData -> Absorbance,
                    PlotLabel -> Null,
                    SecondaryData -> {Pressure, GradientA, GradientB, GradientC, GradientD},
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
                    ImageSize -> $ReviewPlotSize,
                    Zoomable -> $ZoomableBoolean
                ],
                (* In Manifold, we will make it so the user can apply zoomable to the plot *)
                zoomableButton@PlotChromatography[systemFlushData,
                    PrimaryData -> Absorbance,
                    PlotLabel -> Null,
                    SecondaryData -> {Pressure, GradientA, GradientB, GradientC, GradientD},
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
        formatImage, bufferType, allBufferLetters, bufferLetters, imageCloudFiles, bufferImages, imageButtonRules,
        downloadFields, downloadData, volumeConsumed, tableData, bufferTables, bufferIndices, bufferData
    },

    (* this helper should be moved outside since it's also used elsewhere *)
    formatImage[importedImage_, imageCloudFile: ObjectP[Object[EmeraldCloudFile]]] := Tooltip[
        Button[
            Pane[ImageResize[importedImage, 200]],
            OpenCloudFile[imageCloudFile],
            Appearance -> Frameless,
            Method -> "Queued"
        ],
        "Open Image"
    ];

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

(*mspPrimaryData*)

Authors[mspPrimaryData]:={"melanie.reschke"};

mspPrimaryData[protocol:ObjectP[Object[Protocol, ManualSamplePreparation]]] := spPrimaryData[protocol];

(*spPrimaryData*)

Authors[spPrimaryData]:={"melanie.reschke"};

spPrimaryData[protocol:ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]] := Module[
    (* local variable *)
    {
        mspPacketFields, subprotocolPacketFields, mspPacket,
        optimizedUnitOpPackets, outputUnitOpPackets, unitOpSubprotocolPackets,
        containerLinkInputsPackets, containerLinkModelInputsPackets, instrumentPackets,
        instrumentModelPackets, unitOpSubprotocolPacketsAssocs, infoTables,
        dataPlots, outputUnitOpTypeList, unitOpIconsList, panelContentRules
    },

    (* Set fields to download from the MSP protocol and from the subprotocols in packets. *)
    mspPacketFields = Packet[UnresolvedUnitOperationInputs, UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions, OutputUnitOperations];
    subprotocolPacketFields = Packet[
        SamplesIn,
        UnresolvedOptions,
        ResolvedOptions,
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
        Streams
    ];

    (* Download what we need from the MSP input protocol *)
    (* Quiet any FieldDoesntExist messages since not all subprotocol types have all of the fields we want. *)
    {
        mspPacket,
        optimizedUnitOpPackets,
        outputUnitOpPackets,
        unitOpSubprotocolPackets,
        containerLinkInputsPackets,
        containerLinkModelInputsPackets,
        instrumentPackets,
        instrumentModelPackets
    } = Quiet[Download[protocol,
        {
            mspPacketFields,
            OptimizedUnitOperations[Packet[All]],
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

    (* Some unit ops don't correspond to a Subprotocol, so will be Null in the downloaded list of packets. Replace the Nulls at level spec 1 with an empty packet. *)
    unitOpSubprotocolPacketsAssocs = Replace[unitOpSubprotocolPackets, Null -> <||>, {1}];

    (* Get list of all unit operation types for use in making info tables and in labeling the tabs in the final TabView. *)
    outputUnitOpTypeList = Lookup[mspPacket, OutputUnitOperations][Type][[All, -1]];

    (* make tables of relevent information from each unit operation type *)
    infoTables = MapThread[Function[
        {
            optimizedUnitOpPacket,
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

            (* Map through each unit operation and create the figure that will go in the slide view, depending on the type of unit operation *)
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

                Filter,
                    filterUnitOperationPrimaryData[optimizedUnitOpPacket, outputUnitOpPacket, optimizedUserOptions, ToList[instrumentPackets], ToList[instrumentModelPackets]],

                FillToVolume,
                    fillToVolumeUnitOperationPrimaryData[outputUnitOpPacket],

                FluorescenceKinetics,
                    plateReaderUnitOperationPrimaryData[outputUnitOpPacket, optimizedUserOptions, ToList[instrumentPackets], ToList[instrumentModelPackets]],

                _,
                    Null(*generalUnitOperationPrimaryData[optimizedUserOptions]*)
            ];

            mainInfoTable
        ]
    ],
        {
            optimizedUnitOpPackets,
            outputUnitOpPackets,
            unitOpSubprotocolPacketsAssocs,
            containerLinkInputsPackets,
            containerLinkModelInputsPackets,
            instrumentPackets,
            instrumentModelPackets
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

    (* make a list of unit operations and their labels for the tab icons *)
    unitOpIconsList = outputUnitOpTypeList /. $UnitOperationIconFilePaths;

    (* put together the tables/data/other info to be shown in each unit op's slide *)
    panelContentRules = MapThread[Function[{icon, iconLabel, infoTable, dataPlot, subprotocolObject, unitOperationObject, index},
        Module[{slideTitle, dataSection, infoTableSection, unitOpDisplayPanel},

            slideTitle = Which[
                MatchQ[subprotocolObject, ObjectP[Object[Protocol]]] && MatchQ[unitOperationObject, ObjectP[Object[UnitOperation]]],
                Style["Information for Unit Operation at Index " <> ToString[index] <> "\n" <> ToString[unitOperationObject[Object]] <> "\n" <> ToString[subprotocolObject[Object]], TextAlignment -> Center, Bold],
                MatchQ[unitOperationObject, ObjectP[Object[UnitOperation]]],
                Style["Information for Unit Operation at Index " <> ToString[index] <> "\n" <> ToString[unitOperationObject[Object]], TextAlignment -> Center, Bold],
                True,
                Style["Information for Unit Operation at Index " <> ToString[index], TextAlignment -> Center, Bold]
            ];


            infoTableSection = If[!MatchQ[infoTable, ({} | Null)],
                infoTable,
                Nothing
            ];

            dataSection = If[!MatchQ[dataPlot, ({} | Null)],
                Labeled[dataPlot, "Primary Data", Top],
                Nothing
            ];

            unitOpDisplayPanel = Column[
                {
                    slideTitle,
                    dataSection,
                    infoTableSection
                },
                Frame -> All,
                Dividers->{False, {False, True, True}},
                Spacings -> $ReviewGridSpacings,
                Alignment -> Center
            ];

            Tooltip[Row[{Style[ToString[index]<>" ", 22, Bold, LCHColor[0.4, 0, 0], "Helvetica"], icon}], iconLabel] -> unitOpDisplayPanel
        ]
    ],
        {unitOpIconsList, outputUnitOpTypeList, infoTables, dataPlots, Lookup[unitOpSubprotocolPacketsAssocs, Object], Lookup[outputUnitOpPackets, Object], Range[Length[outputUnitOpPackets]]}
    ];

    (* set up the tab view panel which we will put each unit operation information into *)
    {
        Labeled[
            TabView[panelContentRules,
                ControlPlacement -> Left,
                Alignment -> {Center, Top},
                Appearance -> {"Limited", 7}
            ],
            Style[ToString[protocol[Object]], TextAlignment -> Center, Bold],
            Top
        ]
    }
];

(* Helper to merge adjacent cells in Grid *)

(* Input for this needs to be a list of lists, where each list represents one column of the grid. Also make sure any object inputs are just objects without links*)
(* Output of this should be transposed in the Grid *)
mergeGridCellsVertical[myGridContents_List] := Map[
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
    myGridContents
];

(* Unit Operation primary data display helper functions *)

generalUnitOperationPrimaryData[
    optimizedUserOptions_Association
] := Module[{defaultTableData, headings},

    (* start with the optimizedUserOptions that is set above the Switch *)
    (* get the field values lists and format it so the cells of any repeated values above/below will be merged. *)
    defaultTableData = mergeGridCellsVertical[NamedObject[Values[optimizedUserOptions]]];

    (* Make a list of headings for the table using the field names *)
    headings = Module[{excludedSymbolSuffixes},

        (* define list of split field suffixes so we can drop those for the purposes of table headers *)
        excludedSymbolSuffixes = ToString /@ {Link, Expression, String, VariableUnit, Integer};

        (* Get the SymbolName (string format) for each of the keys, then replace the excluded suffixes with empty string *)
        ToExpression[StringReplace[SymbolName /@ Keys[optimizedUserOptions], Alternatives[Sequence @@ excludedSymbolSuffixes] -> ""]]
    ];

    Pane[
        Grid[
            Prepend[
                Transpose[defaultTableData],
                headings
            ],
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
    ]
];

labelContainerUnitOperationPrimaryData[
    optimizedUnitOpPacket_Association,
    outputUnitOpPacket_Association,
    containerPackets_List,
    containerModelPackets_List
] := Module[
    {
        labels, containersInputs, containersOutputs, containerModels, modelImages, clickableContainersOut,
        splitModelsList, splitImagesList, splitContainersOutList, splitLabelsList, tables
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
                If[MatchQ[FirstCase[images, ObjectP[]], ObjectP[Object[EmeraldCloudFile]]],
                    Framed[Pane@ImageResize[ImportCloudFile[FirstCase[images, ObjectP[]]], $ReviewImageSize], FrameStyle -> LightGray],
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

transferUnitOperationPrimaryData[
    outputUnitOpPacket_Association
] := Module[{sourceContainerLabels, destinationContainerLabels, sourceContainers, destinationContainers,
    sourceWells, destinationWells, sourceLocations, destinationLocations, clickableSourceLocations, clickableSourceContainerLabels,
    clickableDestinationLocations, clickableDestinationContainerLabels, transferGraphRules, transferLabelRules, treeGraphs, transferAmounts,
    actualTransferAmount, tableSetup, headings, subheadings,
    splitSources, splitSourceWells, mergedSourceWells, splitDestinations, mergedDestinations, splitDestinationWells,
    tableSources, tableSourceWells, tableDestinations, tableDestinationWells},

    (* Get the source and destination containers, labels, and wells *)
    {
        sourceContainerLabels,
        destinationContainerLabels,
        sourceContainers,
        destinationContainers,
        sourceWells,
        destinationWells
    } = Lookup[outputUnitOpPacket,
        {
            SourceContainerLabel,
            DestinationContainerLabel,
            SourceContainer,
            DestinationContainer,
            SourceWell,
            DestinationWell
        }
    ];

    (* split the transfers by source container *)
    (* convert the sources and destinations into well, container format so we can make sure we're looking at unique sources *)
    sourceLocations = MapThread[{#1, #2}&, {ToList[sourceWells], ToList[sourceContainerLabels]}];
    destinationLocations = MapThread[{#1, #2}&, {ToList[destinationWells], ToList[destinationContainerLabels]}];

    (* Make the locations and labels clickable to copy the container object when clicked *)
    {
        clickableSourceLocations,
        clickableSourceContainerLabels
    } = Map[Function[{locationsList},
        MapThread[
            customButton[#1, CopyContent -> #2, Tooltip -> #2]&,
            {locationsList, sourceContainers[Object]}
        ]
    ],
        {sourceLocations, sourceContainerLabels}
    ];

    (* Make the locations and labels clickable to copy the container object when clicked *)
    {
        clickableDestinationLocations,
        clickableDestinationContainerLabels
    } = Map[Function[{locationsList},
        MapThread[
            customButton[#1, CopyContent -> #2, Tooltip -> #2]&,
            {locationsList, destinationContainers[Object]}
        ]
    ],
        {destinationLocations, destinationContainerLabels}
    ];

    (* Set up rules with the source -> destination for use in tree graph *)
    (* split the transfers by source container *)
    transferGraphRules = SplitBy[MapThread[#1 -> #2 &, {clickableSourceLocations, clickableDestinationLocations}], Keys[#]&];
    (* Split up the non-button version of the list in the same way, to use as the vertex labels. *)
    transferLabelRules = Unflatten[MapThread[#1 -> #2 &, {sourceLocations, destinationLocations}], transferGraphRules];

    treeGraphs = MapThread[Function[{transfersClickable, transfers},
        Module[{vertexList, graphLabel, tooltipLabels, tooltipRules, vertexShapes, vertexRules, vertexSize, imageSizeX, imageSizeY, layerSizeFunction, edgeShapeFunction},

            vertexList = VertexList[transfersClickable];

            (* Make labels for each tree using the source container label (first in the vertex list) and only using the label string, not the Well *)
            graphLabel = First[VertexList[transfers]][[2]];

            {tooltipLabels, vertexShapes} = Transpose[Map[
                {
                    Placed[#, Tooltip],
                    ClickToCopy[
                        Graphics[{RGBColor["#22B893"], RegularPolygon[6]}, Background -> None],
                        #
                    ]
                }&,
                vertexList
            ]];

            tooltipRules = Rule @@@ Transpose[{vertexList, tooltipLabels}];

            vertexRules = Rule @@@ Transpose[{vertexList, vertexShapes}];

            {vertexSize, imageSizeX, imageSizeY, layerSizeFunction, edgeShapeFunction} = If[Length[DeleteDuplicates[transfersClickable]] < 10,
                {Medium, Automatic, 100, Automatic, Automatic},
                {ExtraLarge, UpTo[700], UpTo[100], (Length[DeleteDuplicates[transfersClickable]] / 20 &), "Line"}
            ];

            Column[{
                (* Label the tree graph, use line breaks every 20 characters and center text alignment *)
                Style[InsertLinebreaks[graphLabel, 20], TextAlignment -> Center],

                (* Make the tree graph of the transfers from each source *)
                Graph[DeleteDuplicates[transfersClickable],
                    GraphLayout -> {"LayeredEmbedding", LayerSizeFunction -> layerSizeFunction},
                    ImageSize -> {imageSizeX, imageSizeY},
                    VertexSize -> vertexSize,
                    VertexShapeFunction -> "Hexagon",
                    VertexLabels -> tooltipRules,
                    VertexStyle -> RGBColor["#22B893"],
                    EdgeShapeFunction -> edgeShapeFunction
                ]
            },
                Alignment -> Center
            ]
        ]],
        {transferGraphRules, transferLabelRules}
    ];

    transferAmounts = Module[{allAmountFormats},
        allAmountFormats = Lookup[outputUnitOpPacket, {AmountExpression, AmountInteger, AmountVariableUnit}];
        FirstCase[allAmountFormats, Except[{Null..}]]
    ];

    actualTransferAmount = If[MatchQ[Lookup[outputUnitOpPacket, Preparation], Robotic],

        (* if it is robotic, there is no actual transfer amount measured so skip this *)
        ConstantArray[Null, Length[transferAmounts]],

        (* If it is not robotic, we can get either the percent transferred (liquid) or the measured weight of the transferred material (solid) *)
        Module[{percentTransferred, balances, measuredTransferWeights, residueWeights, weightMeans, weightTransferPositions, weightPositionMap, measuredWeightsExpanded},

            {percentTransferred, balances, measuredTransferWeights, residueWeights} = Lookup[outputUnitOpPacket, {PercentTransferred, Balance, MeasuredTransferWeights, ResidueWeights}];

            (* If the measured transfer weights are distributions, just use the mean *)
            weightMeans = If[MatchQ[Length[residueWeights], Length[measuredTransferWeights]],
                (* If there are residue weights, take those into consideration too *)
                MapThread[
                    (* if we measured something, take residue weight into consideration *)
                    If[MatchQ[#1, _DataDistribution],
                        (Mean[#1] - If[MatchQ[#2, _DataDistribution], Mean[#2], 0 Gram]),
                        (* otherwise this means there is no measured weight, just put Null *)
                        Null
                    ]&,
                    {measuredTransferWeights, residueWeights}
                ],
                (* Otherwise if there are no residue weights then only use the measured weight *)
                Map[
                    If[MatchQ[#, _DataDistribution],
                        Mean[#],
                        #
                    ]&,
                    measuredTransferWeights
                ]
            ];

            (* Set up rules so that for any transfer that used a balance, the rounded mean of the weight is shown *)
            (* First get the positions in the list of transfers that have balances (non weight transfers will be Null) *)
            weightTransferPositions = Position[balances, ObjectP[{Object[Instrument], Model[Instrument]}], 1];

            (* Map the positions to the measured weights *)
            weightPositionMap = Thread[weightTransferPositions -> weightMeans];

            (* use the balances list to expand the list of weights to include Nulls where the transfer was not solid *)
            measuredWeightsExpanded = ReplacePart[balances, weightPositionMap];

            (* Make the list of Actual transfer amounts for liquid and solid transfers *)
            MapThread[Function[{percent, weight},
                Which[
                    MatchQ[weight, Except[Null]],
                        weight,
                    MatchQ[percent, PercentP],
                        percent,
                    True,
                        Null
                ]],
                {percentTransferred, measuredWeightsExpanded}
            ]
        ]
    ];

    mergeSplitList[myList_List] := Module[{},
        (* Map through each of the grouped lists, and output a flattened list *)
        Flatten[
            Map[
                {
                    First[#],
                    ConstantArray[SpanFromAbove, Length[Rest[#]]]
                }&,
                myList
            ]
        ]
    ];

    (* Split the list of source container labels by unique label *)
    splitSources = Split[clickableSourceContainerLabels];
    tableSources = mergeSplitList[splitSources];

    (* Split the source container wells based on the unique labels, to get a list of wells that match to the unique source containers *)
    splitSourceWells = Split /@ Unflatten[sourceWells, splitSources];
    mergedSourceWells = mergeSplitList /@ splitSourceWells;
    tableSourceWells = Flatten[mergedSourceWells];

    (* Split the destination container labels based on the uniqur source labels, to get the destinations grouped by source *)
    splitDestinations = Split /@ Unflatten[clickableDestinationContainerLabels, mergedSourceWells];
    mergedDestinations = mergeSplitList /@ splitDestinations;
    tableDestinations = Flatten[mergedDestinations];

    splitDestinationWells = Split /@ Unflatten[destinationWells, mergedDestinations];
    tableDestinationWells = Flatten[mergeSplitList /@ splitDestinationWells];

    {headings, subheadings, tableSetup} = If[MemberQ[actualTransferAmount, Alternatives[PercentP, _Quantity]],
        (* If we have an actual transfer amount, show that, otherwise don't have a column for that *)
        {
            Flatten[{{Style["Source", 16, Bold], ConstantArray[SpanFromLeft, 1]}, {Style["Destination", 16, Bold], ConstantArray[SpanFromLeft, 1]}, {Style["Amount", 16, Bold], ConstantArray[SpanFromLeft, 1]}}],
            Style[#, Bold]&/@{
                "Container Label", "Well",
                "Container Label", "Well",
                "Requested", "Actual"
            },
            Transpose[Join[{tableSources, tableSourceWells, tableDestinations, tableDestinationWells}, {transferAmounts, actualTransferAmount}]]
        },
        {
            Flatten[{{Style["Source", 16, Bold], ConstantArray[SpanFromLeft, 1]}, {Style["Destination", 16, Bold], ConstantArray[SpanFromLeft, 1]}, Style["Amount", 16, Bold]}],
            Style[#, Bold]&/@{
                "Container Label", "Well",
                "Container Label", "Well",
                "Transferred"
            },
            Transpose[Join[{tableSources, tableSourceWells, tableDestinations, tableDestinationWells}, {transferAmounts}]]
        }
    ];

    Column[{
        Pane[
            Grid[
                Partition[treeGraphs, UpTo[3], 3, 1, SpanFromLeft],
                Spacings -> {5, 5},
                Alignment -> Center
            ],
            ImageSize -> {UpTo[800], UpTo[500]},
            Scrollbars -> Automatic,
            AppearanceElements -> None
        ],
        Pane[
            Grid[
                Prepend[
                    Prepend[
                        tableSetup,
                        subheadings
                    ],
                    headings
                ],
                Frame -> All,
                Spacings -> {2,1},
                ItemStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica"],
                FrameStyle -> Lighter[Gray,0.4],
                Alignment -> {Center, Center},
                Dividers -> {
                    {3 -> Directive[Thick, Darker[Gray]], 5 -> Directive[Thick, Darker[Gray]]},
                    # -> Directive[Thick, Darker[Gray]]& /@ Prepend[FoldList[Plus, 3, Length /@ splitSources], 2]
                },
                Background -> White
            ],
            ImageSize -> {UpTo[700], UpTo[600]},
            Scrollbars -> Automatic,
            AppearanceElements -> None
        ]
    },
        Alignment -> {Center, Center},
        Spacings -> {Automatic, 4}
    ]
];



filterUnitOperationPrimaryData[
    optimizedUnitOpPacket_Association,
    outputUnitOpPacket_Association,
    optimizedUserOptions_Association,
    instrumentPackets_List,
    instrumentModelPackets_List
] := Module[
    {
        filtrationTypes, targets, collectRetentateBools, collectOccludingRetentateBools, targetSampleLabelFields,
        targetContainerLabelFields,
        targetSamplesOutFields,
        targetContainersOutFields,
        targetDestinationWellsFields, samplesOutLabels, samplesOut, containersOutLabels, containersOut, destinationWells, samplesInLabels, samplesInOptimizedPacket, samplesInOutputPacket,
        containersInLabels, filterLabel, sourcesContainerLabelsClickable, sourcesSampleObjects, sourcesContainerObjects, destinationsContainersLabelsClickable, filterModelsTooltips, transfersGrid,
        filtersOptimizedPacket, filtersOutputPacket, filterObjects, filterModels, filtersClickable, filterPropertyFields, filtrationTypeFields, allTableFields, tableFieldValuePairs, fieldValuesPairs, tableDataRules,
        instruments, instrumentModels, modelImages, splitInstrumentModelsList, splitImages,
        splitSourcesContainerLabels,
        splitFilters,
        splitDestinationsContainersLabels,
        splitSampleInfo,
        splitTableData, display
    },

    (* Lookup the Target and FiltrationType from the output unit operations packet *)
    {filtrationTypes, targets} = Lookup[outputUnitOpPacket, {FiltrationType, Target}];

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

    (* Display a grid for each instrument model that has an image of the model on top, the name of the model below that, then a table with the unit op info. *)
    (* Split the input lists by container model *)
    splitInstrumentModelsList = Split[Flatten[instrumentModels]];

    {
        splitImages,
        splitSourcesContainerLabels,
        splitFilters,
        splitDestinationsContainersLabels,
        splitTableData
    } = Unflatten[#, splitInstrumentModelsList]& /@ {modelImages, sourcesContainerLabelsClickable, filtersClickable, destinationsContainersLabelsClickable, Transpose[Values[tableDataRules]]};

    display =
        MapThread[Function[{models, images, sourceContainerLabel, filterLabel, destinationContainerLabel, tableData},
            Module[{headings, combinedTableInfo, mergedTableInfo},

                headings = ToString /@ Prepend[Keys[tableDataRules], Sample];

                combinedTableInfo = Prepend[Transpose[tableData], sourceContainerLabel];

                mergedTableInfo = mergeGridCellsVertical[combinedTableInfo];

                Column[
                    {
                        (* If there is an image, show it. *)
                        If[MatchQ[FirstCase[images, ObjectP[]], ObjectP[Object[EmeraldCloudFile]]],
                            Framed[Pane@ImageResize[ImportCloudFile[FirstCase[images, ObjectP[]]], Experiment`Private`$ReviewImageSize], FrameStyle -> LightGray],
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
                                    Style[#, 12, Bold, FontFamily->"Helvetica"]& /@ headings,
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
        SlideView[display],
        First[display]
    ]
];

mixIncubateUnitOperationPrimaryData[
    optimizedUnitOpPacket_Association,
    outputUnitOpPacket_Association,
    optimizedUserOptions_Association,
    instrumentPackets_List,
    instrumentModelPackets_List,
    subprotocolPacket: (_Association | Null)
] := Module[{excludedMixKeys, specifiedKeys, tableDataRules, tableDataFormatted, sampleInput, sampleInputLabels, incubatedSamples, clickableSamples,
    instruments, instrumentObjectRules, instrumentModels, modelImages, instrumentObjects, splitInstrumentModelsList, splitImages,
    splitInstruments, splitInstrumentObjects, splitSampleInfo, splitTableData, tables, streams, streamButtons, tableDataFormattedWithStreams},

    (* Keys that we don't need to show, they would be covered by other specified options *)
    excludedMixKeys = {Mix, TipMaterial, TipType, Instrument};

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

    (* Get the Streams associated with this unit operation, if any. *)
    streams = If[MatchQ[subprotocolPacket, PacketP[]], Download[Lookup[subprotocolPacket, Streams, {}], Object], {}];

    (* If an overhead stirrer was used and there are Stream objects, we want to add a button for the user to quickly access each stream. *)
    (* There may be extraneous streams due to troubleshooting, and multiple streams may use the same overhead stirrer, so we need to do *)
    (* a small Download and dig into the procedure events to find which stream corresponds to which sample and when to start the videos. *)
    streamButtons = If[MemberQ[instrumentModels, ObjectP[Model[Instrument, OverheadStirrer]]] && MemberQ[streams, ObjectP[Object[Stream]]],
        Module[
            {
                streamTuples, procedureEventPackets, stirrerInstruments, samplesIn, mixTypes, instrumentResources, overheadStirIndices,
                protocolPacketStirTuples, sampleToStirrerLookup, stirrerToPossibleStreamsLookup, possibleStreamsIndexMatchedToSample,
                possibleStartTimesIndexMatchedToSamples, streamToStartTimeLookup, stirPDUEventPackets,
                truncatedProcedureEventTimes, finalStreamsIndexMatchedToSample, startTimesIndexMatchedToSamples, unitlessTimeArgs, playButton
            },

            (* Download info from the streams as well as the procedure log from the incubate subprotocol. *)
            {streamTuples, procedureEventPackets} = Quiet[
                Download[
                    {
                        streams,
                        {Lookup[subprotocolPacket, Object]}
                    },
                    {
                        {Object, StartTime, VideoCaptureComputer[Instruments][Object]},
                        {Packet[ProcedureLog[{Object, Procedure, DateCreated}]]}
                    }
                ],
                {Download::FieldDoesntExist, Download::NotLinkField}
            ];

            (* Get the stirrer instruments from the stream tuples. *)
            stirrerInstruments = Flatten[Cases[#, ObjectP[Object[Instrument, OverheadStirrer]]]& /@ streamTuples[[All, 3]]];

            (* Get the SamplesIn, MixTypes, and InstrumentResources from the protocol packet. *)
            {samplesIn, mixTypes, instrumentResources} = Lookup[subprotocolPacket, {SamplesIn, MixTypes, InstrumentResources}];

            (* Get the indices at which overhead stirring is used. *)
            overheadStirIndices = Flatten @ Position[mixTypes, Stir, {1}];

            (* Generate flat tuples containing all of the stirring information from the protocol packet. *)
            protocolPacketStirTuples = Flatten /@ Transpose[{
                samplesIn[[overheadStirIndices]],
                mixTypes[[overheadStirIndices]],
                Cases[instrumentResources, {Stir, _Integer, ObjectP[Object[Instrument, OverheadStirrer]]}]
            }];

            (* From these tuples, generate a lookup from samples to stirrer instruments. *)
            sampleToStirrerLookup = Map[
                If[MatchQ[#, {ObjectP[], Stir, Stir, ___, ObjectP[Object[Instrument, OverheadStirrer]]}],
                    First[#][Object] -> Last[#][Object],
                    Nothing
                ]&,
                protocolPacketStirTuples
            ];

            (* Generate a lookup from the stirrer to the possible streams. *)
            stirrerToPossibleStreamsLookup = GroupBy[
                Transpose[{stirrerInstruments, streams}],
                First -> Last
            ];

            (* Thread the lookups together to make a new one from sample to possible streams. *)
            possibleStreamsIndexMatchedToSample = incubatedSamples /. sampleToStirrerLookup /. stirrerToPossibleStreamsLookup;

            (* Make a lookup from stream objects to their start times. *)
            streamToStartTimeLookup = Map[
                #[[1]] -> #[[2]]&,
                streamTuples
            ];

            (* Get the stream start times index matched to the samples. *)
            possibleStartTimesIndexMatchedToSamples = possibleStreamsIndexMatchedToSample /. streamToStartTimeLookup;

            (* Pull out the procedure event packets which correspond to the procedure "Incubate Stir PDU". We need these procedure *)
            (* events for the time points, and downloading and filtering them is MUCH faster than downloading the CommandLog of a PDU. *)
            stirPDUEventPackets = PickList[
                Flatten[procedureEventPackets],
                Lookup[Flatten[procedureEventPackets], Procedure],
                "Incubate Stir PDU"
            ];

            (* Find the procedure events which correspond to the beginning of a stirring stream. *)
            truncatedProcedureEventTimes = Module[
                {procedureEventTimes, eventTimeDifferences, firstEventInGroupIndices},

                (* Get the times at which each relevant PDU event occurred. There will be several events per *)
                (* stream, but events related to the same stream occur within a few seconds of each other. *)
                procedureEventTimes = Lookup[stirPDUEventPackets, DateCreated];

                (* Get the times elapsed between consecutive procedure events. *)
                eventTimeDifferences = Differences[procedureEventTimes];

                (* Get the indices at which more than 10 seconds elapsed between events. *)
                (* Add 1 to these to account for the index we lost by using Differences[...] *)
                (* Also prepend 1 since the first procedure event is always the first of a group. *)
                firstEventInGroupIndices = Prepend[
                    Flatten[Position[eventTimeDifferences, GreaterP[10 Second], {1}]] + 1,
                    1
                ];

                (* Return the procedure event times at the relevant indices. *)
                procedureEventTimes[[firstEventInGroupIndices]]
            ];

            (* Map over the possible streams and resolve to the correct one at each relevant sample index. *)
            finalStreamsIndexMatchedToSample = MapThread[
                Function[
                    {streamCandidates, startTimesPerCandidate},
                    Which[
                        (* If there is only possible stream, we've found the correct one already. *)
                        EqualQ[Length[streamCandidates], 1],
                            First[streamCandidates],

                        (* If there are multiple possible streams, use the one that was started most immediately *)
                        (* after the creation of procedure events in the subprocedure "Incubate Stir PDU" *)
                        GreaterQ[Length[streamCandidates], 1],
                            Module[
                                {timeDiscrepancyPerStreamCandidate},

                                (* Find the minimal time difference between the start times of the possible *)
                                (* streams and the earliest of each group of procedure event times. *)
                                timeDiscrepancyPerStreamCandidate = Map[
                                    Min @ Abs[truncatedProcedureEventTimes - #]&,
                                    startTimesPerCandidate
                                ];

                                (* If the smallest time discrepancy is less than 3 minutes, use the corresponding stream. *)
                                (* Otherwise, return Null here so we don't incorrectly assign a stream. *)
                                If[MemberQ[timeDiscrepancyPerStreamCandidate, LessP[3 Minute]],
                                    Module[
                                        {minPosition},
                                        (* Get the index of the minimum time discrepancy. *)
                                        minPosition = First @ Flatten[
                                            Position[
                                                timeDiscrepancyPerStreamCandidate,
                                                EqualP[Min[timeDiscrepancyPerStreamCandidate]],
                                                {1}
                                            ]
                                        ];
                                        (* Get the stream at this index. *)
                                        streamCandidates[[minPosition]]
                                    ],
                                    Null
                                ]
                            ],

                        (* If we have made it this far, there is no Stream for this sample. Set this to Null. *)
                        True,
                            Null
                    ]
                ],
                {possibleStreamsIndexMatchedToSample, possibleStartTimesIndexMatchedToSamples}
            ];

            (* Get the final stream start times index matched to the samples. *)
            startTimesIndexMatchedToSamples = finalStreamsIndexMatchedToSample /. streamToStartTimeLookup;

            (* Find the time at which the actual stirring begins for each stream to use as the time input for WatchProtocol. *)
            (* Start by filtering out any procedure event times that are not related to the correct streams. *)
            unitlessTimeArgs = Module[
                {minTimeDiscrepanciesPerStream},

                (* Get the minimum time discrepancies (between stream start time and procedure event creation) per stream start time. *)
                minTimeDiscrepanciesPerStream = MapThread[
                    Function[
                        {streamObject, streamStartTime},
                        If[NullQ[streamObject],
                            Null,
                            Min @ Abs[truncatedProcedureEventTimes - streamStartTime]
                        ]
                    ],
                    {finalStreamsIndexMatchedToSample, startTimesIndexMatchedToSamples}
                ];

                (* Replace any event time with a minimum discrepancy greater than 3 minutes with Null, since this is *)
                (* an indication that something went wrong and we can't reliably assign the stream with this info. *)
                (* All other times should be fine, so convert to a whole number of seconds, strip the units, and *)
                (* subtract 20 (empirically determined value) to ensure that we catch the beginning of the stream. *)
                (* Also use Max to ensure that we never go below 0 - i.e., the beginning of the stream. *)
                Map[
                    If[NullQ[#] || GreaterQ[#, 3 Minute],
                        Null,
                        Max[Round[Unitless[#, Second]] - 20, 0]
                    ]&,
                    minTimeDiscrepanciesPerStream
                ]
            ];

            (* If we have streams, create a play button graphic *)
            playButton = If[MemberQ[finalStreamsIndexMatchedToSample, ObjectP[Object[Stream]]],
                Graphics[
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
                ],
                Null
            ];

            (* Return the buttons or "N/A" placeholder. *)
            MapThread[
                Function[
                    {streamObject, timeArg},
                    If[NullQ[streamObject],
                        "N/A",
                        With[
                            {
                                playButtonGraphic = playButton,
                                explicitStreamObject = streamObject,
                                explicitTimeArg = timeArg
                            },
                            Button[
                                Tooltip[playButtonGraphic, "Play"],
                                WatchProtocol[explicitStreamObject, explicitTimeArg],
                                Method -> "Queued",
                                Appearance -> "Frameless"
                            ]
                        ]
                    ]
                ],
                {finalStreamsIndexMatchedToSample, unitlessTimeArgs}
            ]
        ],
        (* If there are no streams showing overhead stirring, just move on. *)
        {}
    ];

    (* If we generated any stream buttons, append them to the formatted table data. *)
    tableDataFormattedWithStreams = If[MemberQ[streamButtons, _Button],
        Append[tableDataFormatted, Stream -> streamButtons],
        tableDataFormatted
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
        Module[{headings, combinedTableInfo, mergedTableInfo},

            headings = ToString /@ Prepend[Keys[tableDataFormattedWithStreams], Sample];

            combinedTableInfo = Prepend[Transpose[tableData], samples];

            mergedTableInfo = mergeGridCellsVertical[combinedTableInfo];

            Column[
                {
                    (* If there is an image, show it. *)
                    If[MatchQ[FirstCase[images, ObjectP[]], ObjectP[Object[EmeraldCloudFile]]],
                        Framed[Pane@ImageResize[ImportCloudFile[FirstCase[images, ObjectP[]]], Experiment`Private`$ReviewImageSize], FrameStyle -> LightGray],
                        Nothing
                    ],

                    (* Show the instrument model if there is one. *)
                    If[MatchQ[First[models], ObjectP[Model[Instrument]]],
                        Tooltip[
                            ClickToCopy[NamedObject[First[models]]],
                            First[models]
                        ],
                        Nothing
                    ],

                    (* If we were able to get the instrument object from the subprotocol, show that as well *)
                    If[MatchQ[instrumentObjects, ListableP[ObjectP[Object[Instrument]]]],
                        Tooltip[
                            ClickToCopy[NamedObject[First[instrumentObjects]]],
                            First[instrumentObjects][Object]
                        ],
                        Nothing
                    ],

                    (* Create a table of the model, labels, and containers *)
                    Labeled[
                        Pane[
                            Grid[
                                {
                                    Style[#, 12, Bold, FontFamily->"Helvetica"]& /@ headings,
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

fillToVolumeUnitOperationPrimaryData[outputUnitOpPacket_Association] := Module[
    {
        totalVolumes, containerLabels, containerLinks, sampleLinks, solventLinks, methods, imageSampleQ,
        downloadResult, solventModels, ftvImages, ftvImageCloudFiles, imageQs, imageButtons, stylizeHeader,
        safeContainerLabels, safeContainerLinks, safeSolventLinks, safeSolventModels, tables
    },

    (* Get the relevant information we need from the protocol packet. *)
    {
        totalVolumes,
        containerLabels,
        containerLinks,
        sampleLinks,
        solventLinks,
        methods,
        imageSampleQ
    } = Lookup[outputUnitOpPacket,
        {
            TotalVolume,
            SampleContainerLabel,
            SampleContainerLink,
            SampleLink,
            SolventLink,
            Method,
            ImageSample
        }
    ];

    (* If ImageSample is True, Download the image of the container when it is filled to the stated volume. *)
    (* Regardless of whether ImageSamples is True, download the solvent models. *)
    downloadResult = If[TrueQ[imageSampleQ] && MatchQ[sampleLinks, {ObjectP[Object[Sample]]..}],
        Quiet @ Download[
            {
                sampleLinks,
                solventLinks
            },
            {
                {AppearanceLog[[1, 2]][{Image, UncroppedImageFile}]},
                {Model[Object]}
            }
        ],
        Download[solventLinks, Model]
    ];

    (* Get the solvent Models from the download. *)
    solventModels = Flatten[downloadResult[[-1]]];

    (* If we got images from the Download, assign these and the cloud files to the appropriate variables. *)
    (* Otherwise, just set these variables to flat lists of Nulls of the correct length so this doesn't trainwreck. *)
    {ftvImages, ftvImageCloudFiles} = If[MatchQ[Transpose @ Flatten[downloadResult[[1]], 1], {{_Image..}, _List}],
        Transpose @ Flatten[downloadResult[[1]], 1],
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
        {ftvImages, ftvImageCloudFiles}
    ];

    (* Make an image button if the image exists. *)
    imageButtons = MapThread[
        Function[
            {imageQ, image, imageCloudFile},
            If[TrueQ[imageQ],
                With[{explicitImage = image, explicitCloudFile = imageCloudFile},
                    Tooltip[
                        Button[
                            Framed[Pane@ImageResize[explicitImage, 250], FrameStyle -> LightGray],
                            OpenCloudFile[explicitCloudFile],
                            Appearance -> None,
                            Method -> "Queued"
                        ],
                        "Open Image"
                    ]
                ],
                Null
            ]
        ],
        {imageQs, ftvImages, ftvImageCloudFiles}
    ];

    (* Helper to format the header. *)
    stylizeHeader[header_String] := Style[header, Bold, 11, FontFamily -> "Helvetica", RGBColor["#4A4A4A"]];

    (* Ensure that we don't break the MapThread if one of the Link or Label fields is empty. *)
    {safeContainerLabels, safeContainerLinks, safeSolventLinks, safeSolventModels} = MapThread[
        Function[
            {list, string},
            If[MatchQ[list, {}],
                ConstantArray[string<>" not found", Length[totalVolumes]],
                list
            ]
        ],
        {
            {containerLabels, containerLinks, solventLinks, solventModels},
            {"ContainerLabel", "ContainerLink", "SolventLink", "Solvent Model"}
        }
    ];

    (* Generate the data tables. *)
    tables = MapThread[
        Function[{containerLabel, container, fillVolume, method, solvent, solventModel, imageQ, imageButton},
            Column[
                {
                    (* Show the image if we have it. *)
                    If[TrueQ[imageQ], imageButton, Nothing],

                    (* Container object as a "click to copy" button. *)
                    Style[customButton[NamedObject[container]], Bold, FontFamily -> "Helvetica"],

                    (* Information table for all instances. *)
                    Pane[
                        Grid[
                            {
                                {stylizeHeader["Container Label"], customButton[containerLabel]},
                                {stylizeHeader["Method"], customButton[method]},
                                {stylizeHeader["Solvent"], customButton[solvent]},
                                If[MatchQ[solventModel, ObjectP[Model[Sample]]],
                                    {stylizeHeader["Solvent Model"], customButton[solventModel]},
                                    Nothing
                                ],
                                {stylizeHeader["Total Volume"], customButton[fillVolume]}
                            },
                            Frame -> All,
                            Alignment -> {Center, Center},
                            Spacings -> {2, 1},
                            ItemStyle -> Directive[FontSize -> 12, FontFamily -> "Helvetica"],
                            FrameStyle -> Lighter[Gray, 0.4],
                            Alignment -> {Center, Center},
                            Background -> White,
                            ItemSize -> {{13, 20}}
                        ],
                        ImageSize -> {UpTo[700], UpTo[600]},
                        Scrollbars -> Automatic,
                        AppearanceElements -> None
                    ]
                },
                Alignment -> Center,
                Spacings -> 2
            ]
        ],
        {safeContainerLabels, safeContainerLinks, totalVolumes, methods, safeSolventLinks, safeSolventModels, imageQs, imageButtons}
    ];

    (* Return in SlideView if there is more than one table to show. Otherwise just return the one table. *)
    If[GreaterQ[Length[tables], 1],
        SlideView[tables, AppearanceElements -> {"FirstSlide", "PreviousSlide", "NextSlide", "LastSlide", "SlideNumber", "SlideTotal"}],
        tables[[1]]
    ]
];