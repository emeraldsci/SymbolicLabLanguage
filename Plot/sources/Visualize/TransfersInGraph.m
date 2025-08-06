(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)

DefineOptions[TransfersInGraph,
  Options:>{
    IndexMatching[
      IndexMatchingInput -> "samples",
      {
        OptionName -> Date,
        Default -> Now,
        Description -> "Specifies a cutoff date, displaying only sample transfers occurring into the input sample before that time.  For transfers below the first level, the date of transfers from the source to the destination sample determines which transfers into source samples are included. Transfers into source samples that occurred after transfers to the destination samples are excluded. When hovering over the vertices, the storage conditions and composition of the source are shown as they were at the time of the transfer. In contrast, expiration dates and sample names are displayed as they are currently, since these details are often updated by users.",
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Date,
            Pattern :> _?DateObjectQ,
            TimeSelector -> True
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[Now]]
        ]
      },
      {
        OptionName -> LevelsDown,
        Default -> 6,
        Description -> "Specifies the total number of transfer levels to graph, starting with a minimum level of 1, which includes only the direct transfers from source samples into the input sample. Each additional level captures further layers of transfers, where each level represents transfers made into the source samples of the previous level. It is important to note that the function only considers transfers that occurred before the specified date.",
        AllowNull -> False,
        Widget -> Alternatives[
          Widget[
            Type -> Number,
            Pattern :> GreaterP[0, 1]
          ],
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[All]
          ]
        ]
      },
      {
        OptionName -> ProgressIndicator,
        Default -> True,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Description -> "Indicates whether to print text containing information on the progress of the function during evaluation."
      },
      (*,
      {
        OptionName -> CollapseIdenticalSources,
        Default -> True,
        Description -> "Specifies whether transfers from the same source sample should be merged into a single vertex. Since sample compositions can change over time, source samples are considered identical only if their compositions match at the time of transfer. Note that untracked composition changes that occur in the time between these transfers, such as evaporation, filtration, or precipitation, are not considered when collapsing sources.",
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
      }*)

      {
        OptionName -> GraphLayout,
        Default -> Automatic,
        AllowNull -> False,

        Description -> "Specifies what format to use for the transfer tree. Any of Mathematica's layouts and special embeddings can be used.",
        Widget -> Widget[Type -> Enumeration, Pattern :>
            (Automatic | "LayeredEmbedding" | "LayeredDigraphEmbedding" |
                "RadialEmbedding" | "BalloonEmbedding" | "CircularEmbedding" |
                "GridEmbedding" | "SpectralEmbedding" | "SpringEmbedding" |
                "TutteEmbedding" | "StarEmbedding" | "TutteEmbedding" |
                "SpringElectricalEmbedding" | "GravityEmbedding" |
                "MultipartiteEmbedding" | "LinearEmbedding" |
                "CircularMultipartiteEmbedding" |
                "DiscreteSpiralEmbedding") | {(Automatic | "LayeredEmbedding" |
                "LayeredDigraphEmbedding" | "RadialEmbedding" |
                "BalloonEmbedding" | "CircularEmbedding" | "GridEmbedding" |
                "SpectralEmbedding" | "SpringEmbedding" | "TutteEmbedding" |
                "StarEmbedding" | "TutteEmbedding" |
                "SpringElectricalEmbedding" | "GravityEmbedding" |
                "MultipartiteEmbedding" | "LinearEmbedding" |
                "CircularMultipartiteEmbedding" | "DiscreteSpiralEmbedding") ..}]
        (*(Automatic | "LayeredEmbedding" | "LayeredDigraphEmbedding" |
              "RadialEmbedding" | "BalloonEmbedding" | "CircularEmbedding" |
              "GridEmbedding" | "SpectralEmbedding" | "SpringEmbedding" |
              "TutteEmbedding" | "StarEmbedding" | "TutteEmbedding" |
              "SpringElectricalEmbedding" | "GravityEmbedding" |
              "MultipartiteEmbedding" | "LinearEmbedding" |
              "CircularMultipartiteEmbedding" | "DiscreteSpiralEmbedding" |
              {"LayeredEmbedding", ___Rule} | {"LayeredDigraphEmbedding", ___Rule}
              | {"RadialEmbedding", ___Rule} | {"BalloonEmbedding", ___Rule} |
              {"CircularEmbedding", ___Rule} | {"GridEmbedding", ___Rule} |
              {"SpectralEmbedding", ___Rule} | {"SpringEmbedding", ___Rule} |
              {"TutteEmbedding", ___Rule} | {"StarEmbedding", ___Rule} |
              {"TutteEmbedding", ___Rule} | {"SpringElectricalEmbedding", ___Rule}
              | {"GravityEmbedding", ___Rule} | {"MultipartiteEmbedding", ___Rule}
              | {"LinearEmbedding", ___Rule} | {"CircularMultipartiteEmbedding",
            ___Rule} | {"DiscreteSpiralEmbedding", ___Rule})]*)
      }
    ]
  }
];

(* ::Subsubsection::Closed:: *)
(*Unique Messages*)

Warning::NoTransfersIntoSample = "The TransfersIn field for `1` is empty. Instead of TransfersIn the product is linked.";
Warning::DateInFuture = "The date specified in the Date option `1` for `2` is in the future. As future transfers into the sample are unknown, Now (`3`) is used to graph the transfers in.";
Warning::DateBeforeCreation = "The date specified in the Date option  `1` for `2` is before its creation (`3`). Instead Now (`4`) is used to graph the transfers in.";

(* ::Subsubsection::Closed:: *)
(*Code*)

(* Main Function *)
TransfersInGraph[samplesIn:ListableP[ObjectP[Object[Sample]]],ops:OptionsPattern[]]:= Module[
  {sampleList, listedOptions,
    safeOps, validLengths, expandedSafeOps,
    creationDatesWithNull, creationDates, firstUseDate, expirationDates, futureDateQ, downloadDateBeforeCreationDateQ, specifiedDates, downloadDates,
    levels, printProgressQ,
    tempOutput,
    sampleModels, sampleCompositions,transfersIn,containers,containerModels,containerModelsType,containerModelsName,
    edges, combinedTransferInAssociations,samplesVertexLabels, samplesVertexShapes,
    allSources, allSourcesModelTypes, allSourcesContainerTypes, allSourceContainerModelNames,
    sourceVertexLabels, vertexLabels, vertexShapes,sourceVertexShapes,
    legends,plotLabels,
    uniqueModels, green, orange, blue, purple},

  (*Create the colors for the vertices and legends. These are taking from the colors used by Design*)
  (* green = #22b893, orange = #ff6a2d, blue = #358ef2, purple = #b570b3*)
  {green, orange, blue, purple} = {XYZColor[{0.23065, 0.36735, 0.33475}], XYZColor[{0.4687, 0.31762, 0.06145}], XYZColor[{0.27165, 0.26511, 0.87685}], XYZColor[{0.32986, 0.24668, 0.45669}]};

  (* Create a list for the inputs *)
  sampleList= Download[ToList[samplesIn],Object];

  (* Create a list for the options *)
  listedOptions = ToList[ops];

  (* Call SafeOptions to make sure all options match pattern *)
  safeOps = SafeOptions[TransfersInGraph,listedOptions];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  validLengths = ValidInputLengthsQ[TransfersInGraph, {sampleList}, safeOps];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[$Failed]
  ];

  (* Expand index matched options*)
  expandedSafeOps= Last[ExpandIndexMatchedInputs[TransfersInGraph,{sampleList},safeOps]];

  (* Create the list of dates *)
  specifiedDates = Lookup[expandedSafeOps,Date];

  (*Download the sample creation and expiration dates. These dates will be used to check if the given download date is before or after the creation date.*)
  (*While most information in the rest of the function is downloaded on a given date, this downloaded uses Now as users might have updated the expiration date and we want to reflect the new one.*)
  {creationDatesWithNull,expirationDates, firstUseDate} = Transpose[Download[sampleList,{DateCreated,ExpirationDate,StatusLog[[1, 1]]}]];

  (*If the creation date is Null, the first entry in the StatusLog is used*)
  creationDates = MapThread[Replace[#1, Null -> #2] &, {creationDatesWithNull, firstUseDate}];

  (* Check if the dates given are in the future*)
  futureDateQ = #>Now&/@specifiedDates;

  (*Check if the dates given are before the creation date of the object*)
  downloadDateBeforeCreationDateQ = MapThread[#1<#2&,{specifiedDates,creationDates}];

  (* Use Now if dates are in the future. Otherwise, use the given date. *)
  downloadDates = MapThread[If[Or[#1,#2],
    Now,
    #3
  ]&,{futureDateQ,downloadDateBeforeCreationDateQ,specifiedDates}];

  (*Give a warning if download date is in the future and indicate that Now will be used*)
  If[And@@futureDateQ,
    Message[Warning::DateInFuture,PickList[specifiedDates,futureDateQ,True], PickList[sampleList,futureDateQ,True]//NamedObject,Now]
  ];

  (*Give a warning if download date is before the object creation date and indicate that Now will be used*)
  If[And@@downloadDateBeforeCreationDateQ,
    Message[Warning::DateBeforeCreation,PickList[specifiedDates,downloadDateBeforeCreationDateQ,True], PickList[sampleList,downloadDateBeforeCreationDateQ,True]//NamedObject,PickList[creationDates,downloadDateBeforeCreationDateQ,True],Now]
  ];

  levels = Lookup[expandedSafeOps,LevelsDown];

  (* Set a boolean to indicate whether progress updates should be printed. *)
  printProgressQ = MemberQ[Lookup[expandedSafeOps, ProgressIndicator, {True}], True];
  
  (*Download the transfers into the samples at the given date. This list will contain the date the transfer occurred, the amount transfered, the source, and the protocol. Additionally it contains whether the transfer was full or partial (this won't be used)*)
  {sampleModels, sampleCompositions,transfersIn,containers,containerModels,containerModelsType,containerModelsName} = Transpose[ToList[Download[sampleList, {Model[Object],Composition,TransfersIn,Container,Container[Model],Container[Model][Type],Container[Model][Name]},Date -> downloadDates]]];

  (*The iterativeDownloadTransfer is used to create an association of transfers into sources on each level*)
  combinedTransferInAssociations =MapThread[
    If[Length[#2]!=0,
      DeleteDuplicates[Flatten[iterativeDownloadFunction[#1, #2, #3, printProgressQ]]],
      (*Warning if there are no transfers into the input sample. This does not happen for source samples*)
      Message[Warning::NoTransfersIntoSample,#1//NamedObject];
      (*Display the product if there are no transfers into the input sample.*)
      {Association[
        Sample -> #1,
        Date ->Null,
        Amount -> Null,
        Source -> Download[#1, Model[Products][Object]],
        Protocol -> #1[Source],
        SourceComposition -> #1[Composition],
        SourceContainer -> #1[Container],
        SourceContainerModel -> If[MatchQ[#1[Container],Null],
          Null,
          #1[Container][Model]
          ],
        SourceContainerModelType -> If[MatchQ[#1[Container],Null],
          Null,
          #1[Container][Model][Type]
        ],
        SourceModel -> #1[Model],
        SourceModelType -> If[MatchQ[#1[Model],Null],
          Null,
          #1[Model][Type]
        ],
        DateCreated -> #1[DateCreated],
        ExpirationDate -> #1[ExpirationDate]
      ]}]&,
    {sampleList,transfersIn,levels}
  ];

  (* If we have no transfers in associations, return early. *)
  If[MatchQ[combinedTransferInAssociations, {{}}],
    Return["No TransfersInGraphs were generated for "<>ECL`InternalUpload`ObjectToString[sampleList]<>"."]
  ];

  (*Create the tooltip that is displayed when hovering of the edges*)
  edges = Map[
    Map[Labeled[DirectedEdge[Lookup[#,Source],Lookup[#,Sample]],
      Tooltip[
        Button[
          (*TextString has to be used as ToString in combination with units and tooltip does not work well*)
          TextString[Lookup[#,Amount]],
          CopyToClipboard[Lookup[#,Protocol][Object]],
          Appearance -> None],
        Column[{"Click to Copy the Protocol Object to Clipboard",
          (*Create the table containing the transfer protocol information*)
          Grid[Prepend[{{Lookup[#,Amount],Lookup[#,Protocol][Object],Lookup[#,Date]}},(Style[#, Bold]&/@{"Amount","Protocol", "Time"})],
            Alignment->Center,Frame->All,Background->{None,{{LightGray,White}}},Spacings->{1,1}]
        },
          Alignment->Center]]]&,#]&,combinedTransferInAssociations];

  (*Update regarding the status*)
  tempOutput = If[printProgressQ, PrintTemporary["Creating Vertices"]];

  (*Link the samples on the vertices to their icons/shapes*)
  samplesVertexShapes = MapThread[#1 -> getContainerIcon[#2,#3,"Green", green]&,{sampleList,containerModelsType,containerModelsName}];

  (*Create Sample Vertex Label. This contains the Table that shows up when hovering over the vertex*)
  samplesVertexLabels = 	MapThread[
    Function[{sample,sampleModel,sampleComposition,container,containerModel,dateCreated,expirationDate},
      sample -> NamedObject[Placed[
        Tooltip[
          Button[
            "    ",
            CopyToClipboard[sample[Object]],
            Appearance -> None],
          Column[{"Click the Node/Vertex to Copy the Object to Clipboard",
            (*Table containing sample information*)
            Grid[Transpose[Prepend[{{
              sample,
              (*TODO: Determine what to do if Model is Null. Keep it empty to show it's Null, or remove it from the table? Just empty will most likely be confusing. The same for Container and Container Model (these can be null if the sample has been discarded)*)
              If[MatchQ[sampleModel,Null],
                "Null",
                sampleModel
              ],
              (*Table of the Composition*)
              NamedObject[Grid[Prepend[
                Select[
                  # /. {first_, rest___} :> If[first =!= Null, {UnitScale[first], rest}, {first, rest}] & /@
                      ReverseSortBy[sampleComposition[[All, {1, 2}]], First[#] &],
                  # =!= {Null, Null} &
                ],
                Style[#, Bold]&/@{"Concentration","Molecule"}],
                Alignment -> Center,
                Frame -> All,
                Background ->{None,{{LightGray,White}}},
                Spacings -> {1,1}]],
              container,
              containerModel,
              dateCreated,
              If[MatchQ[expirationDate,Null],
                "No Expiration Date Set",
                expirationDate]
            }
            },
              Style[#, Bold]&/@{"Sample","Model", "Composition", "Container", "Container Model", "Date Created", "Expiration Date"}
            ]],
              Alignment -> Center,
              Frame -> All,
              Background ->{None,{{LightGray,White}}},
              Spacings -> {1,1}
            ]},
            Alignment-> Center],
          TooltipStyle -> {Background -> LightYellow}
        ],
        Center]]],
    {sampleList, sampleModels, sampleCompositions,containers, containerModels,creationDates,expirationDates}
  ];


  (*Get all the sources and source sources*)
  allSources = Lookup[#, Source]&/@combinedTransferInAssociations;
  allSourcesModelTypes = Lookup[#, SourceModelType, ""]&/@combinedTransferInAssociations;
  allSourcesContainerTypes = Lookup[#, SourceContainerModelType, ""]&/@combinedTransferInAssociations;
  allSourceContainerModelNames = Lookup[#, SourceContainerModelName, ""]&/@combinedTransferInAssociations;

  (*The icon used for the vertex represents the type of container and the type of sample. First the sample type is checked and the the container type. The container name is used to determine the icon if multiple icons are used for the same Type.*)
  (*If no match can be found, this can happen when a sample is discarded, a hexagon is used for the output.*)
  sourceVertexShapes = MapThread[
    Function[{sources, models, containerType, containerName},
      MapThread[
        Function[{source, model, type, name},
          source ->
              (*Pick the right colors to use based on the Sample Model*)
              With[{color =
                  Which[
                    MatchQ[model, Model[Sample, StockSolution]],
                    "Blue",
                    MatchQ[model, Model[Sample]],
                    "Orange",
                    True,
                    "Purple"
                  ],
                shapeColor =
                    Which[
                      MatchQ[model, Model[Sample, StockSolution]],
                      blue,
                      MatchQ[model, Model[Sample]],
                      orange,
                      True,
                      purple
                    ]
              },
                getContainerIcon[type, name, color, shapeColor]
              ]
        ],
        {sources, models, containerType, containerName}
      ]
    ],
    {allSources, allSourcesModelTypes, allSourcesContainerTypes, allSourceContainerModelNames}
  ];

  (*Combine the vertex shapes*)
  vertexShapes = MapThread[Prepend[#1,#2]&,{sourceVertexShapes,samplesVertexShapes}];

  (*Find the unique models styles to determine the legend. Only the sources are used because a sample is always present*)
  uniqueModels = DeleteDuplicates/@allSourcesModelTypes;

  (*Create the legend, pick only the colors that are required based on the sample models present*)
  legends = Map[
    Append[
      Transpose[
        Prepend[
          PickList[
            {
              (*Without using Grid, the Linebreak would create misaligned text. The marker ends up at the height of the first line instead of at the center*)
              {blue, Grid[{{"Preparable sample\nStockSolution, Media, or Matrix)"}},ItemSize -> {Automatic,3},Alignment -> {Automatic,Center}]},
              {purple, Grid[{{"Intermediate sample without a Model\n(prepared through explicit operations such as Transfer or Mix)"}},ItemSize -> {Automatic,3},Alignment -> {Automatic,Center}]},
              {orange, Grid[{{"Non-preparable sample\n(sourced sample, e.g. commercial or user supplied sample)"}},ItemSize -> {Automatic,3},Alignment -> {Automatic,Center}]}
            },
            #
          ],
          {green, Grid[{{"Input Sample"}},ItemSize -> {Automatic,1.75},Alignment -> {Automatic,Center}]}
        ]],
      LegendLabel -> "Sample Type"
    ]&,
    Table[MemberQ[sublist, x], {sublist,uniqueModels}, {x, {Model[Sample, StockSolution], Null, Model[Sample]}}
    ]
  ];

  (*Create the vertex labels for the Graph*)
  sourceVertexLabels = MapThread[
    Function[{transfersInAssociation},
      MapThread[
        Lookup[#1,Source] -> NamedObject[Placed[
          Tooltip[
            Button[
              "    ",
              CopyToClipboard[Lookup[#1,Source][Object]],
              Appearance -> None],
            Column[{"Click the Node to Copy the Object to Clipboard",
              (*Table containing sample information*)
              Grid[Transpose[Prepend[{{
                Lookup[#1,Source],
                Lookup[#1,SourceModel],
                (*Composition table*)
                NamedObject[Grid[Prepend[
                  Select[
                    # /. {first_, rest___} :> If[first =!= Null, {UnitScale[first], rest}, {first, rest}] & /@
                        ReverseSortBy[Lookup[#1, SourceComposition][[All, {1, 2}]], First[#] &],
                    # =!= {Null, Null} &
                  ],
                  Style[#, Bold]&/@{"Concentration","Molecule"}],
                  Alignment -> Center,
                  Frame -> All,
                  Background ->{None,{{LightGray,White}}},
                  Spacings -> {1,1}]],
                Lookup[#1,SourceContainer],
                Lookup[#1,SourceContainerModel],
                Lookup[#1,DateCreated],
                If[MatchQ[Lookup[#1,ExpirationDate],Null],
                  "No Expiration Date Set",
                  Lookup[#1,ExpirationDate]
                ]
              }
              },
                Style[#, Bold]&/@{"Sample","Model", "Composition", "Container", "Container Model","Date Created","Expiration Date"}
              ]],
                Alignment -> Center,
                Frame -> All,
                Background ->{None,{{LightGray,White}}},
                Spacings -> {1,1}
              ]},
              Alignment-> Center],
            TooltipStyle -> {Background -> LightYellow}
          ],
          Center]]&,
        {transfersInAssociation}
      ]][#1]&,
    {combinedTransferInAssociations}
  ];

  (*Create the vertex lables of the sources and samples*)
  vertexLabels = MapThread[Append[#1,#2]&,{sourceVertexLabels,samplesVertexLabels}];

  (*Create the title of the plot*)
  plotLabels = MapThread[
      InsertLinebreaks[
      "Transfers into " <> ToString[#1//NamedObject] <> " before " <> DateString[#2,{"ISODate", " at ", "Time", " ", "TimeZoneNameShort"}],
        90]&, {sampleList,downloadDates}];

  (*Delete the temporarily printed progress*)
  NotebookDelete[tempOutput];

  (*Plot the Graph displaying transfers into the inputs*)
  Column[MapThread[Legended[
    Graph[#1,
      PlotLabel -> #2,
      ImageSize -> Large,
      VertexLabels -> #3,
      VertexSize -> Medium,
      VertexShape -> #4,
      EdgeStyle -> {RGBColor[0.6, 0.6, 0.6]},
      GraphLayout -> #5
    ],
    SwatchLegend@@#6]&,
    {edges, plotLabels, vertexLabels,vertexShapes, ToList[Lookup[expandedSafeOps,GraphLayout]],legends}]
  ]
];

(* Container Overload *)
TransfersInGraph[containersIn:ListableP[ObjectP[Object[Container]]], ops:OptionsPattern[]] := Module[
  {samples, containerList, listedOptions,safeOps,date, expandedSafeOps, containerSampleListLength, expandRule,expandedAssoc, emptyContainerQ,emptyContainers},
  (*Get the samples from the containers*)
  containerList = ToList[containersIn];
  listedOptions = ToList[ops];
  safeOps = SafeOptions[TransfersInGraph,listedOptions];
  date = Lookup[safeOps,Date];
  (*containerToSampleOptions does not take into account the date when converting the container list to a list of samples, which means we can't use it to expand the options*)
  (*Instead we download the samples here at the given date and then expand the options after*)
  expandedSafeOps= Last[ExpandIndexMatchedInputs[TransfersInGraph,{containerList},safeOps]];

  samples = Download[containersIn,Contents[[All,2]][Object],Date -> date];

  containerSampleListLength = Length/@(ToList/@samples);
  emptyContainerQ = # == 0 &/@containerSampleListLength;

  emptyContainers=PickList[containerList,emptyContainerQ];

  Which[
    Length[emptyContainers]>0&&Length[Flatten[samples]]==0,
    Message[Error::EmptyContainers, emptyContainers//NamedObject];
    Return[$Failed],
    Length[emptyContainers]>0,
    Message[Error::EmptyContainers, emptyContainers]
  ];


  (*Function to expand the rules based on the number of samples in the given container*)
  expandRule[key_Symbol, values_List,expansion_] :=
      key -> Flatten[MapThread[ConstantArray, {values, expansion}]];

  expandedAssoc = MapThread[expandRule[#1,#2,containerSampleListLength]&,{Keys[expandedSafeOps],Values[expandedSafeOps]}];

  TransfersInGraph[Flatten[samples], Sequence@@expandedAssoc]
];


(*Creates the transfer associations source -> sample for each level through iterative downloads using the dates for each relevant transfers.*)
(*This process uses iterative downloads instead of a direct download because each sample requires downloads on a different date*)
iterativeDownloadFunction[destinations_,transfersIn_,levels:(ListableP[_?IntegerQ|All]),progressIndicator:BooleanP] := Module[
  {
    tempOutput, currentLevel, maxLevels, timeBuffer, transfersIntoSourcesAssociations, associationList, sourceCreationDateDiscrepancies, stopForDiscrepanciesQ,
    sourceTransferDates,sourceAmounts,sourceSources,sourceProtocol,
    sourcesSourceCompositions, sourceSourceContainers, sourceSourceContainerModels, sourceSourceContainerModelTypes,
    sourceSourceContainerModelNames, sourceSourceSampleModels, sourceSourceSampleModelsTypes,transfersIntoSourceSources,sourceSourceExpirationDates,sourceSourcesCreationDates,
    sourcesWithTransfers,transfersIntoSourcesWithTransfers
  },

  (*Print an update regarding the sample for which the history is downloaded*)
  tempOutput = If[progressIndicator, PrintTemporary["Downloading " <> ToString[destinations//NamedObject] <> " History"]];

  (*The list that will be used to generate the next levels*)
  associationList = {};

  (*If no MaxLevels are specified, run until all transfers are mapped*)
  maxLevels = If[MatchQ[levels,All],
    Infinity,
    levels];
  currentLevel = 0;

  (* Pad the download date by a couple of minutes to handle small discrepancies in DateCreated vs. Transfer dates. *)
  timeBuffer = 120 Second;

  (*Create the list of sources that have transfers into them*)
  (*We don't have to worry about sources that don't contain have samples going into them*)
  sourcesWithTransfers = {destinations};
  (*The list of the transfers into sourcesWithTransfers*)
  transfersIntoSourcesWithTransfers = {transfersIn};

  While[
    And[
      GreaterQ[Length[transfersIntoSourcesWithTransfers], 0],
      GreaterQ[maxLevels, currentLevel],
      !TrueQ[stopForDiscrepanciesQ]
    ],

    (*Update Current Level*)
    currentLevel = currentLevel + 1;

    (*Get the sources and transfer dates from TransfersIn. The dates and sources will be used to download information required for the vertices*)
    {sourceTransferDates,sourceAmounts,sourceSources,sourceProtocol}=Transpose[Transpose/@transfersIntoSourcesWithTransfers[[All,All,{1,2,3,4}]]];

    (* This information is downloaded on the current date as users might have updated the expiration date and we want to reflect the new one. *)
    (* We also need to download the DateCreated for the sources to determine whether to stop iteration to account for time discrepancies. *)
    {sourceSourceExpirationDates, sourceSourcesCreationDates} = Transpose[
      Map[
        Transpose,
        Quiet[
          Download[sourceSources,
            {ExpirationDate, DateCreated},
            Date -> Now
          ],
          {Download::SomeMetaDataUnavailable}
        ]
      ]
    ];

    (* Find the time elapsed between sample object creation and sourceTransferDates. *)
    sourceCreationDateDiscrepancies = Flatten[sourceSourcesCreationDates] - Flatten[sourceTransferDates];

    (* If there are any discrepancies greater than the time buffer, throw a flag. *)
    stopForDiscrepanciesQ = MemberQ[sourceCreationDateDiscrepancies, GreaterP[timeBuffer]];

    (* If we have a discrepancy that will crash the evaluation, stop iterating here. *)
    If[stopForDiscrepanciesQ,
      Nothing,
      (* If there are no bad discrepancies, download and parse the required information at the current level. *)
      Module[
        {},

        {
          sourcesSourceCompositions,
          sourceSourceContainers,
          sourceSourceContainerModels,
          sourceSourceContainerModelTypes,
          sourceSourceContainerModelNames,
          sourceSourceSampleModels,
          sourceSourceSampleModelsTypes,
          transfersIntoSourceSources
        } = Transpose[
          Map[
            Transpose,
            Quiet[
              Download[
                sourceSources,
                {
                  Composition,
                  Container,
                  Container[Model],
                  Container[Model][Type],
                  Container[Model][Name],
                  Model,
                  Model[Type],
                  TransfersIn
                },
                Date -> Flatten[sourceTransferDates] + timeBuffer
              ],
              {Download::SomeMetaDataUnavailable}
            ]
          ]
        ];

        transfersIntoSourcesAssociations = MapThread[
          Function[{sample, dates, amounts, sources, protocol, compositions, containers, containerModels, containerModelTypes, containerModelNames, sampleModels, sampleModelTypes, creationDates, expirationDates},
            Map[
              AssociationThread[
                {
                  Sample,
                  Date,
                  Amount,
                  Source,
                  Protocol,
                  SourceComposition,
                  SourceContainer,
                  SourceContainerModel,
                  SourceContainerModelType,
                  SourceContainerModelName,
                  SourceModel,
                  SourceModelType,
                  DateCreated,
                  ExpirationDate
                } ->
                    {sample, #[[1]], UnitScale[#[[2]]], #[[3]], #[[4]], #[[5]], #[[6]], #[[7]], #[[8]], #[[9]], #[[10]], #[[11]], #[[12]], #[[13]]}
              ] &,
              Transpose[{dates, amounts, sources, protocol, compositions, containers, containerModels, containerModelTypes, containerModelNames, sampleModels, sampleModelTypes, creationDates, expirationDates}]
            ]
          ],
          {
            sourcesWithTransfers,
            sourceTransferDates,
            UnitScale[sourceAmounts],
            sourceSources,
            sourceProtocol,
            sourcesSourceCompositions,
            sourceSourceContainers,
            sourceSourceContainerModels,
            sourceSourceContainerModelTypes,
            sourceSourceContainerModelNames,
            sourceSourceSampleModels,
            sourceSourceSampleModelsTypes,
            sourceSourcesCreationDates,
            sourceSourceExpirationDates
          }
        ];

        (* Append the result to resultList *)
        associationList = Append[associationList, transfersIntoSourcesAssociations];
        sourcesWithTransfers =  PickList[Flatten[sourceSources,1],!MatchQ[#,{}]&/@Flatten[transfersIntoSourceSources,1]];
        transfersIntoSourcesWithTransfers = DeleteCases[Flatten[transfersIntoSourceSources,1],{}];

      ]
    ]

  ];
  NotebookDelete[tempOutput];
  associationList
];

(*The icon used for the vertex represents the container the sample is in. First the type is checked. The container name is used to determine the icon if multiple icons are used for the same Type.*)
(*If no match can be found, this can happen when a sample is discarded, a hexagon is used for the output.*)
getContainerIcon[type_, name_, color_, shapeColor_] :=  Module[{hexagon},
  hexagon = Graphics[{
    Directive[
      EdgeForm[Directive[Thickness[Large],shapeColor]],
      FaceForm[Lighter[shapeColor, 0.4]]
    ],
    (*This function creates a hexagon*)
    Polygon[Table[{Cos[theta], Sin[theta]}, {theta, 0, 2 Pi, 2 Pi/6}]]
  }];
  Which[
  (*1 Volumetric Flask*)
  MatchQ[type, Model[Container, Vessel, VolumetricFlask]],
  Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "Volumetric flask " <> color <> ".png"}]],

  (*2 Plate*)
  MatchQ[type, Model[Container, Plate]],
  Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "plate " <> color <> ".png"}]],

  (*3 Filter*)
  MatchQ[type, Model[Container, Vessel, Filter]],
  Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "filter " <> color <> ".png"}]],

  (* All other vessels*)
  MatchQ[{type,name}, {Model[Container, Vessel],_String}],
  Which[
    (*4 Tube*)
    StringContainsQ[name, "Tube", IgnoreCase -> True],
    Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "Tube " <> color <> ".png"}]],

    (*5 Bottle*)
    StringContainsQ[name, "Bottle", IgnoreCase -> True],
    Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "Bottle " <> color <> ".png"}]],

    (*6 Carboy*)
    StringContainsQ[name, "Carboy", IgnoreCase -> True],
    Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "Carboy " <> color <> ".png"}]],

    (*7 Beaker*)
    StringContainsQ[name, "Beaker", IgnoreCase -> True],
    Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "beaker " <> color <> ".png"}]],

    (*8 Round Bottom Flask*)
    StringContainsQ[name, "Round Bottom Flask", IgnoreCase -> True],
    Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "flask Round bottom " <> color <> ".png"}]],

    (*9 Vial*)
    StringContainsQ[name, "Vial", IgnoreCase -> True],
    Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "Vial " <> color <> ".png"}]],

    (*10 Erlenmeyer Flask*)
    StringContainsQ[name, "Flask", IgnoreCase -> True],
    Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "Flask " <> color <> ".png"}]],

    (*11 Ampoule*)
    StringContainsQ[name, "Ampoule", IgnoreCase -> True],
    Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "Ampoule " <> color <> ".png"}]],

    (* Output a hexagon if name does not match any of the previous names*)
    True,
    hexagon
  ],

  (*11 Cuvette*)
  MatchQ[type, Model[Container, Cuvette]],
  Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "cuvette " <> color <> ".png"}]],

  (*12 Syringe*)
  MatchQ[type, Model[Container, Syringe]],
  Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "syringe " <> color <> ".png"}]],

  (*13 Graduated Cylinder (edge case)*)
  MatchQ[type, Model[Container, GraduatedCylinder]],
  Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "TransfersInGraph Icons", "Graduated Cylinder " <> color <> ".png"}]],

  (* 14 Default case: Hexagon with specified color *)
  True,
  Graphics[{
    Directive[
      EdgeForm[Directive[Thickness[Large],shapeColor]],
      FaceForm[Lighter[shapeColor, 0.4]]
    ],
    (*This function creates a hexagon*)
    Polygon[Table[{Cos[theta], Sin[theta]}, {theta, 0, 2 Pi, 2 Pi/6}]]
  }]
]];