(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(* PlotPeaksTable *)

(* PlotPeaksTable Options *)

DefineOptions[PlotPeaksTable,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "analysis objects",
      {
        OptionName -> Columns,
        Default -> Automatic,
        Description -> "Determines what information is displayed in the peaks table initially.",
        ResolutionDescription -> "The information displayed will be selected based on the type of data the peak analysis is representing.",
        AllowNull -> False,
        Category -> "Peaks",
        Widget -> Alternatives[
          Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[
              Alternatives[Sequence@@$NMRPeaksFields],
              Alternatives[Sequence@@$NonNMRPeaksFields],
              Automatic
            ]
          ],
          Adder[
            Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[
                Alternatives[Sequence@@$NMRPeaksFields],
                Alternatives[Sequence@@$NonNMRPeaksFields]
              ]
            ]
          ]
        ]
      },
      {
        OptionName -> MaxHeight,
        Default -> Automatic,
        Description -> "The maximum height of the table to display at once. The rest of the table can be accessed via a scrollbar to the side of the table. If set to Null, then the entire table is displayed at once.",
        ResolutionDescription -> "If Automatic and the analysis has fewer than six peaks, then the entire table will be displayed. Otherwise, the MaxHeight is automatically set to 200.",
        AllowNull -> True,
        Category -> "Peaks",
        Widget -> Alternatives[
          Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic]],
          Widget[Type -> Number, Pattern :> GreaterEqualP[100]]
        ]
      }
    ],
    {
      OptionName -> Dynamic,
      Default -> True,
      Description -> "Determines if the peaks table if labels and column can be changed in the table (True) or if the table is not able to be changed and is only displayed (False).",
      AllowNull -> False,
      Category -> "Peaks",
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
    },
    {
      OptionName -> NMR,
      Default -> True,
      Description -> "Determines if NMR peak splitting information is displayed (True) or if traditional peak analysis is displayed (False) for peak analyses of NMR data.",
      AllowNull -> False,
      Category -> "Peaks",
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
    },
    {
      OptionName -> ConvertTableHeadings,
      Default -> True,
      Description -> "Indicates if SLL field names are converted to common protocol-specific terms (such as \"Retention Time\" and \"Absorbance Intensity\") in table headings rather than used directly (such as \"Position\" and \"Height\").",
      AllowNull -> False,
      Category -> "Peaks",
      Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
    }
  },
  SharedOptions :> {
    OutputOption,
    CacheOption,
    SimulationOption,
    DebugOption
  }
];


(* PlotPeaksTable Errors *)

Warning::NoPeaksInAnalysis = "The analysis objects, `1`, at indices, `2`, do not have any identified peaks and thus will be excluded from the generated peak tables.";
Warning::InvalidColumns = "The analysis objects, `1`, at indices, `2`, have columns/fields specified that are invalid, `3`, because NMR-specific fields were specified for non-NMR analysis objects or vice versa based on the NMR option, `4`. Invalid fields will not be displayed in the peaks table.";
Warning::NoNMRAnalysisToDisplay = "The analysis objects, `1`, at indices, `2`, do not have NMR peak splitting information, so they will display a traditional peak information table.";


(* PlotPeaksTable Constants *)
$NMRPeaksFields = {
  NMRChemicalShift, NMRNuclearIntegral, NMRMultiplicity,
  NMRJCoupling, NMRAssignment, NMRFunctionalGroup
};

$NonNMRPeaksFields = {
  Area, AsymmetryFactor, BaselineIntercept, BaselineSlope, HalfHeightNumberOfPlates,
  HalfHeightResolution, HalfHeightWidth, Height, PeakLabel, PeakRangeEnd, PeakRangeStart,
  Position, RelativeArea, RelativePosition, TailingFactor, TangentNumberOfPlates, TangentResolution,
  TangentWidth, TangentWidthLineRanges, TangentWidthLines, WidthRangeEnd, WidthRangeStart
};

(* PlotPeaksTable Source *)

(* Overload for no analysis objects. *)
PlotPeaksTable[emptyInput: (Null|{}), myOptions: OptionsPattern[PlotPeaksTable]] := Null;

(* Main Function *)
PlotPeaksTable[myAnalysisObjects: ListableP[ObjectP[Object[Analysis, Peaks]]], myOptions: OptionsPattern[PlotPeaksTable]] := Module[
  {
    outputSpecification, output, gatherTests, messages, listedOptions, safeOptions, safeOptionTests, cache, simulation,
    inputColumnFields, dynamicQ, debugQ, inputMaxHeights, nmrInformationQ, convertHeadingsQ, peakAnalysisFields, listedAnalysisObjects,
    peakAnalysisPackets, findDefaultFields, expandedColumnFields, expandedMaxHeights, resolvedColumnFields,
    resolvedMaxHeights, stylizeText, formatFieldHeaders, buildPeaksTable, peakAnalysisTables,
    analysisObjectsWithoutPeaks, analysisObjectPeakTest, analysesWithInvalidColumns, invalidColumns,
    invalidColumnTest, missingNMRPeakAnalysisObjects, missingNMRPeakTest, resolvedOptions, collapsedResolvedOptions,
    previewRule, optionsRule, testsRule, resultRule
  },

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests (Output contains Test). *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Make sure that options are in a list. *)
  listedOptions = ToList[myOptions];

  (* Call SafeOptions to make sure all options match the option patterns. *)
  {safeOptions, safeOptionTests} = If[gatherTests,
    SafeOptions[PlotPeaksTable, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[PlotPeaksTable, listedOptions, AutoCorrect -> False], {}}
  ];

  (* Fetch the cache & simulation from listedOptions. *)
  cache = ToList[Lookup[listedOptions, Cache, {}]];
  simulation = Lookup[listedOptions, Simulation, Null];

  (* Fetch pertinent options to be used later when assembling the peak tables. *)
  {
    inputColumnFields, dynamicQ, debugQ, inputMaxHeights, nmrInformationQ, convertHeadingsQ
  } = Lookup[
    safeOptions, {
      Columns, Dynamic, Debug, MaxHeight, NMR, ConvertTableHeadings
    }
  ];

  (* Determine what information needs to be downloaded and which objects that it needs to be downloaded from. *)
  peakAnalysisFields = Join[PeaksFields, {Reference, ReferenceField, PeakUnits}];
  listedAnalysisObjects = ToList[myAnalysisObjects];

  (* Main Download *)
  peakAnalysisPackets = Download[
    listedAnalysisObjects,
    Evaluate[Packet[Sequence @@ peakAnalysisFields]],
    Cache -> cache,
    Simulation -> simulation
  ];

  (* Determine what columns/peak fields will be used for the table *)
  (* Helper function to return default fields based on the type of data object that the analysis object is linked to. *)
  findDefaultFields[
    analysisPacket: PacketP[Object[Analysis, Peaks]],
    nmrInformationQ: BooleanP
  ] := Module[{referenceObject},
    referenceObject = Lookup[analysisPacket, Reference];

    Which[
      MatchQ[referenceObject, {ObjectP[Object[Data, Chromatography]]..}],
        {Position, RelativePosition, Height, Area, RelativeArea},
      MatchQ[referenceObject, {ObjectP[Object[Data, NMR]]..}] && nmrInformationQ,
        {NMRChemicalShift, NMRNuclearIntegral, NMRMultiplicity, NMRJCoupling},
      True,
        {Position, Height, Area}
    ]
  ];

  (* Expand index-matched options before resolving them. *)
  (* NOTE: ExpandIndexMatchedInputs not working for these cases, so doing it manually. *)
  expandedColumnFields = If[
    (* If already index-matched list, then just format each component correctly. *)
    Length[inputColumnFields] == Length[listedAnalysisObjects],
    Map[
      If[MatchQ[#, Except[Automatic]], ToList[#], #]&,
      inputColumnFields
    ],
    (* Otherwise, expand input to be index-matched. *)
    ConstantArray[inputColumnFields, Length[listedAnalysisObjects]]
  ];

  expandedMaxHeights = If[
      (* If index-matched already, then use as-is. *)
      Length[inputMaxHeights] == Length[listedAnalysisObjects],
      inputMaxHeights,
      (* Otherwise, expand to be index-matched to analysis objects. *)
      ConstantArray[inputMaxHeights, Length[listedAnalysisObjects]]
  ];

  (* If column input is automatic, then choose columns based on data object type. Otherwise, use what was specified. *)
  resolvedColumnFields = MapThread[
    Function[{inputColumns, peakAnalysisPacket},
      If[MatchQ[inputColumns, Automatic],
        findDefaultFields[peakAnalysisPacket, nmrInformationQ],
        inputColumns
      ]
    ],
    {expandedColumnFields, peakAnalysisPackets}
  ];

  (* Resolve the max heights based on how many peaks there are in each analysis. *)
  resolvedMaxHeights = MapThread[
    Function[{inputMaxHeight, peakAnalysisPacket},
      Module[{nmrPeaksQ},
        (* Determine if we're looking at NMR peaks or normal analysis peaks. *)
        nmrPeaksQ = And[
          MatchQ[Lookup[peakAnalysisPacket, Reference], {ObjectP[Object[Data, NMR]]..}],
          nmrInformationQ
        ];

        Which[
          (* Set to 200 if there are over 6 peaks (NMRChemical shift if NMR -> True & NMR data and Position for the rest). *)
          And[
              MatchQ[inputMaxHeight, Automatic],
              Or[
                And[
                  !nmrPeaksQ,
                  Length[Lookup[peakAnalysisPacket, Position]] > 6
                ],
                And[
                  nmrPeaksQ,
                  Length[Lookup[peakAnalysisPacket, NMRChemicalShift]] > 6
                ]
              ]
          ],
            200,
          (* Set to Null if there are under 6 peaks. *)
          MatchQ[inputMaxHeight, Automatic],
            Null,
          (* Otherwise, use what was specified. *)
          True,
            inputMaxHeight
        ]
      ]
    ],
    {expandedMaxHeights, peakAnalysisPackets}
  ];

  (* Helper to stylize text similar to PlotTable. *)
  stylizeText[text_String] := Style[text, 12, FontFamily -> "Helvetica", RGBColor["#4A4A4A"]];

  (* Helper to format field headers. Namely, spaces are put after capital letters in the field name and fields *)
  (* with more pertinent names for the data type (ex. Position -> Retention Time for HPLC) are replaced if requested. *)
  formatFieldHeaders[
    fields: {(_Symbol|_String)..}|{},
    analysisPacket: PacketP[Object[Analysis, Peaks]],
    convertTableHeadingsQ: BooleanP
  ] := Module[{fieldStrings, fieldsWithCommonNames},

    (* Make sure all of our fields are strings if not already. *)
    fieldStrings = Map[ToString, fields];

    (* Replace fields with common names where necessary based on reference data type and what type of data it is. *)
    fieldsWithCommonNames = If[convertTableHeadingsQ,
      Module[{referenceObject, referenceField, referenceReplacements, dataSubtypeReplacements},
        {referenceObject, referenceField} = Lookup[analysisPacket, {Reference, ReferenceField}];

        (* Make an association of peak analysis fields to their common name based on the data object type. *)
        referenceReplacements = Switch[referenceObject,
          {ObjectP[Object[Data, Chromatography]]..},
            {
              "Position" -> "Retention Time",
              "RelativePosition" -> "Relative Retention Time"
            },
          {ObjectP[Object[Data, NMR]]..},
            {"NMRJCoupling" -> "J-Coupling"},
          {ObjectP[Object[Data, MassSpectrometry]]..},
            {
              "Position" -> "Mass-to-charge Ratio (m/z)",
              "RelativePosition" -> "Relative Mass-to-charge Ratio",
              "Height" -> "Intensity"
            },
          {ObjectP[{Object[Data, TLC], Object[Data, PAGE]}]..},
            {
              "Position" -> "Distance",
              "RelativePosition" -> "Relative Distance",
              "Height" -> "Summed Pixel Intensity"
            },
          {ObjectP[Object[Data, AbsorbanceSpectroscopy]]..},
            {
              "Position" -> "Wavelength",
              "RelativePosition" -> "RelativeWavelength"
            },
          {ObjectP[Object[Data, FluorescenceSpectroscopy]]..},
            {
              "Position" -> "Distance",
              "RelativePosition" -> "Relative Distance",
              "Height" -> "Fluorescence"
            },
          {ObjectP[Object[Data, AgaroseGelElectrophoresis]]..},
            {
              "Position" -> "Strand Length",
              "RelativePosition" -> "Relative Strand Length",
              "Height" -> "Fluorescence"
            },
          {ObjectP[Object[Data, XRayDiffraction]]..},
            {
              "Position" -> "Diffraction Angle (2\[Theta])",
              "RelativePosition" -> "Relative Diffraction Angle",
              "Height" -> "Intensity"
            },
          {ObjectP[Object[Data, DifferentialScanningCalorimetry]]..},
            {
              "Position" -> "Temperature",
              "RelativePosition" -> "Relative Temperature",
              "Height" -> "Differential Enthalpy"
            },
          {ObjectP[Object[Data, CapillaryGelElectrophoresisSDS]]..},
            {
              "Height" -> "Absorbance Intensity"
            },
          {ObjectP[Object[Data, CoulterCount]]..},
            {
              "Position" -> "Particle Diameter",
              "RelativePosition" -> "Relative Particle Diameter",
              "Height" -> "Particle Count"
            },
          _,
           {}
        ];

        (* Make an association of peak analysis fields to their common name based on the type of data (reference field). *)
        dataSubtypeReplacements = Switch[
          referenceField,
          Chromatogram,
            {
              "Position" -> "Retention Time",
              "RelativePosition" -> "Relative Retention Time"
            },
          Alternatives[Absorbance, UnblankedAbsorbanceSpectrum, AbsorbanceSpectrum],
            {"Height" -> "Absorbance Intensity"},
          Conductance,
            {"Height" -> "Conductance"},
          FIDResponse,
            {"Height" -> "Current"},
          Fluorescence,
            {"Height" -> "Fluorescence"},
          Absorbance3D,
            {
              "Position" -> "Retention Time",
              "RelativePosition" -> "Relative Retention Time",
              "Height" -> "Absorbance Intensity"
            },
          Scattering,
            {
              "Height" -> "Scattering Intensity"
            },
          ProcessedUVAbsorbanceData,
            {
              "Position" -> "Migration Time",
              "RelativePosition" -> "Relative Migration Time",
              "Height" -> "Absorbance Intensity"
            },
          RelativeMigrationData,
            {
              "Position" -> "Relative Migration Time",
              "RelativePosition" -> "Relative Change in Relative Migration Time"
            },
          Absorbance3D,
            {
              "Position" -> "Retention Time",
              "RelativePosition" -> "Relative Retention Time",
              "Height" -> "Absorbance Intensity"
            },
          IonAbundance3D,
            {
              "Position" -> "Mass-to-charge Ratio (m/z)",
              "RelativePosition" -> "Relative Mass-to-charge Ratio",
              "Height" -> "Intensity"
            },
          TotalIonAbundance,
            {
              "Position" -> "Retention Time",
              "RelativePosition" -> "Relative Retention Time",
              "Height" -> "Abundance"
            },
          _,
            {}
        ];

        (* Replace field names with common names. *)
        ReplaceAll[
          fieldStrings,
          Join[referenceReplacements, dataSubtypeReplacements]
        ]
      ],
      fieldStrings
    ];

    (* For remaining fields, separate their CamelCase into separate words. *)
    Map[
      Module[{condensedString, nmrRemovedString, capitalPositions},
        condensedString = ToString[#];

        (* Remove NMR prefix from associated fields. *)
        nmrRemovedString = StringReplace[condensedString, "NMR" -> ""];

        (* Determine where lower case letters followed by upper case letters are. *)
        capitalPositions = StringPosition[nmrRemovedString, _?LowerCaseQ ~~ _?UpperCaseQ][[All, 2]];

        (* Add spaces between lowercase and upper case letters (ex. RelativeHeight -> Relative Height). *)
        StringInsert[nmrRemovedString, " ", capitalPositions]
      ]&,
      fieldsWithCommonNames
    ]
  ];

  (* Helper that sets up the table given one peak analysis object and the initial table fields. *)
  buildPeaksTable[
    analysisObjectPacket: ObjectP[Object[Analysis, Peaks]],
    initialColumnFields: {Alternatives[Sequence @@ PeaksFields]..},
    maxHeight: (GreaterEqualP[100] | Null)
  ] := Module[{peakLabels, peakUnits, peakReferenceDataObjects, nmrTableQ, allPeakFieldOptions, filteredInitialColumnFields},
    (* Look up the peak labels which are automatically displayed. *)
    (* NOTE: If peak labels are not found, then put in placeholders. *)
    peakLabels = If[MatchQ[Lookup[analysisObjectPacket, PeakLabel], {}],
      ConstantArray["", Length[Lookup[analysisObjectPacket, Position]]],
      Lookup[analysisObjectPacket, PeakLabel]
    ];

    (* Determine the units for each analysis field data. *)
    (* NOTE: Some peak units are specified as None, so remove them. Otherwise it causes values like "3.2 None" in the table. *)
    peakUnits = ReplaceAll[
      Lookup[analysisObjectPacket, PeakUnits],
      (_ -> None) -> Nothing
    ];

    (* Determine the peak reference data and if we're using the NMR table or traditional peaks table. *)
    peakReferenceDataObjects = Lookup[analysisObjectPacket, Reference];
    nmrTableQ = And[
      MatchQ[peakReferenceDataObjects, {ObjectP[Object[Data, NMR]]..}],
      nmrInformationQ
    ];

    (* Determine which fields can be represented in the table. *)
    allPeakFieldOptions = If[nmrTableQ,
      $NMRPeaksFields,
      $NonNMRPeaksFields
    ];

    (* Filter out invalid, specified column fields. A warning will be thrown about this later if there are discrepancies. *)
    filteredInitialColumnFields = UnsortedIntersection[initialColumnFields, allPeakFieldOptions];

    Which[
      (* If there are no peaks are in the analysis, then return no table. *)
      MatchQ[Lookup[analysisObjectPacket, Position], {}],
        Null,
      (* If a dynamic table is requested, then set up the dynamic table. *)
      dynamicQ,
        DynamicModule[
          {
            maxTableHeight, currentlyDisplayedColumns, possiblePeakFields,
            columnSetter, cachedPeakLabels, currentPeakLabels, uploadFunction,
            resetLabel, resetAllLabels, debugSection, columnSetterSection,
            peakTable, uploadButton
          },

          (* Store the MaxTableHeight option in the Dynamic Module *)
          maxTableHeight = maxHeight;

          (* Start with the default columns in view *)
          currentlyDisplayedColumns = filteredInitialColumnFields;

          (* Determine which fields have information (not Null nor {}) to dislay as options for the selection menu. *)
          (* NOTE: PeakLabel is already represented in the first column, so don't need to have it as a data field here. *)
          (* NOTE: BaselineFunction is the same across the board and not index-matched, so we don't display it. *)
          possiblePeakFields = ReplaceAll[
            PickList[allPeakFieldOptions, Lookup[analysisObjectPacket, allPeakFieldOptions], Except[Null|{}]],
            {PeakLabel -> Nothing, BaselineFunction -> Nothing}
          ];

          (* Create a setter bar for the columns *)
          columnSetter = TogglerBar[
            Dynamic[currentlyDisplayedColumns],
            MapThread[
              #1 -> #2&,
              {
                possiblePeakFields,
                Map[
                  stylizeText,
                  formatFieldHeaders[possiblePeakFields, analysisObjectPacket, convertHeadingsQ]
                ]
              }
            ],
            (* Make the peak fields list out horizontally in three columns. *)
            (* ex. {Field 1, Field 2, Field 3, Field 4, Field 5} becomes: *)
            (* Field 1  Field 2  Field 3 *)
            (* Field 4  Field 5          *)
            Appearance -> "Horizontal" -> {Automatic, 3}
          ];

          (* Cache the database value for the peak labels - only update by download *)
          cachedPeakLabels = peakLabels;

          (* And create a locally modifiable variable to be modified by dynamic *)
          currentPeakLabels = peakLabels;

          (* Define a little helper to actually do the upload *)
          uploadFunction[] := With[{object = Lookup[analysisObjectPacket, Object]},
            (
              (* Perform the upload *)
              Upload[<|Object->object, Replace[PeakLabel]->currentPeakLabels|>];

              (* Refresh the cached values so we can tell if they're modified again *)
              (* Update the local values too because why not *)
              cachedPeakLabels = currentPeakLabels = Download[object, PeakLabel];
            )
          ];

          (* Helper to reset the local value of the label *)
          resetLabel[index_Integer] := Set[
            currentPeakLabels,
            ReplacePart[
              currentPeakLabels,
              index -> cachedPeakLabels[[index]]
            ]
          ];

          (* Helper to return all labels to their unaltered state (representing the current state of the analysis obejct). *)
          resetAllLabels[] := Set[currentPeakLabels, cachedPeakLabels];

          (* Set up a debugging section in case it is needed. *)
          debugSection = If[debugQ,
            Dynamic[
              Grid[
                {
                  {Style["currentlyDisplayedColumns", Bold],currentlyDisplayedColumns},
                  {Style["cachedPeakLabels", Bold], cachedPeakLabels},
                  {Style["currentPeakLabels", Bold], currentPeakLabels}
                }
              ]
            ],
            Nothing
          ];

          (* Set up a drop-down table with the column setter. *)
          columnSetterSection = OpenerView[{stylizeText["Choose peak information to display"], columnSetter}];

          (* Plot the actual table *)
          peakTable = Dynamic[
            (* Plot the table normally if there's data *)
            Module[{rawData, rawDataWithRowNames, displayedColumnHeaders},
              (* Contents of the table - make sure table displays ok with no data *)
              rawData = Which[
                !MatchQ[currentlyDisplayedColumns, {}] && nmrTableQ,
                  Transpose[
                    (* NMR fields already have units integrated into them, so don't need to add here. *)
                    Lookup[analysisObjectPacket, currentlyDisplayedColumns]
                  ],
                !MatchQ[currentlyDisplayedColumns, {}],
                  Transpose[
                    (* Units are not in the raw data, so need to multiply it in here. *)
                    Lookup[analysisObjectPacket, currentlyDisplayedColumns] * Lookup[peakUnits, currentlyDisplayedColumns, 1]
                  ],
                True,
                  (* Can't use length of peak labels here because it may not match number of NMR peaks. *)
                  (* This acts as a buffer in case no columns are selected. *)
                  ConstantArray[{}, Length[Lookup[analysisObjectPacket, First[possiblePeakFields]]]]
              ];

              (* Prepend the row names to each row *)
              rawDataWithRowNames = MapIndexed[
                Function[{rowData, rawIndex},
                  Module[{rowIndex, dynamicPeakLabel},
                    (* Remove the listiness from MapIndexed index *)
                    rowIndex = First[rawIndex];

                    (* Make the dynamic peak labels to be put into the plot. *)
                    (* If it's NMR, we don't have peak labels, we use NMR assignments. *)
                    dynamicPeakLabel = If[nmrTableQ,
                      Nothing,
                      With[{index = rowIndex},
                        Row[
                          {
                            InputField[
                              (* currentPeakLabels is our source of truth for our local changes *)
                              (* In each row, display the appropriate member of that list *)
                              (* And replace that member in the list when modified locally *)
                              Dynamic[currentPeakLabels[[index]],
                                Set[currentPeakLabels, ReplacePart[currentPeakLabels, index -> #1]]&
                              ],
                              String,
                              FieldHint -> "Type a label for this peak.",
                              ContinuousAction -> False,
                              FieldSize -> {{10, 20}, {1, \[Infinity]}},
                              (* Change the style when the name is changed locally *)
                              BaseStyle -> Dynamic[
                                If[
                                  MatchQ[currentPeakLabels[[index]], cachedPeakLabels[[index]]],
                                  {},
                                  Italic
                                ],
                                TrackedSymbols :> {currentPeakLabels}
                              ],
                              FrameMargins -> 3
                            ],
                            (* Dynamically show a button to reset the local label change if there is a local change *)
                            Dynamic[
                              If[
                                MatchQ[currentPeakLabels[[index]], cachedPeakLabels[[index]]],
                                Invisible[Button["\[LeftGuillemet]", FrameMargins -> 3, Alignment -> Center]],
                                Button["\[LeftGuillemet]", resetLabel[index], FrameMargins -> 3, Alignment -> Center]
                              ],
                              TrackedSymbols :> {currentPeakLabels, cachedPeakLabels}
                            ]
                          },
                          Alignment -> Center
                        ]
                      ]
                    ];

                    Join[
                      {
                        rowIndex,
                        dynamicPeakLabel
                      },
                      rowData
                    ]
                  ]
                ],
                rawData
              ];

              (* Make headers for the selected fields to display. *)
              (* If it's an NMR table, we don't have peak labels, so don't have that in the headers. *)
              displayedColumnHeaders = If[nmrTableQ,
                Prepend[
                  formatFieldHeaders[currentlyDisplayedColumns, analysisObjectPacket, convertHeadingsQ],
                  "Peak Number"
                ],
                Join[
                  {"Peak Number", "Peak Label"},
                  formatFieldHeaders[currentlyDisplayedColumns, analysisObjectPacket, convertHeadingsQ]
                ]
              ];

              (* Plot the table *)
              If[MatchQ[maxTableHeight, Null],
                (* Plot as normal *)
                PlotTable[
                  rawDataWithRowNames,
                  Alignment -> {Left, Automatic},
                  TableHeadings -> {Automatic, displayedColumnHeaders},
                  Tooltips -> False,
                  HorizontalScrollBar -> False,
                  UnitForm -> False
                ],

                (* Make the headers fixed but the table scrollable *)
                scrollableTable[rawDataWithRowNames, displayedColumnHeaders, maxTableHeight]
              ]
            ],
            TrackedSymbols :> {currentlyDisplayedColumns}
          ];

          (* Create button for uploading the new names *)
          uploadButton = If[nmrTableQ,
            Nothing,
            Row[
              {
                Button[
                  (* Change what's on the button depending on if there are local changes *)
                  Dynamic[
                    If[
                      MatchQ[currentPeakLabels, cachedPeakLabels],
                      "No Changes",
                      "Upload Peak Labels"
                    ],
                    TrackedSymbols :> {currentPeakLabels, cachedPeakLabels}
                  ],

                  uploadFunction[],

                  (* Button is only active if there are local changes *)
                  Enabled->Dynamic[!MatchQ[currentPeakLabels, cachedPeakLabels],TrackedSymbols:>{currentPeakLabels, cachedPeakLabels}],

                  Method -> "Queued"
                ],
                (* Dynamically show a button to reset all local label changes if there are local changes *)
                Dynamic[
                  If[MatchQ[currentPeakLabels, cachedPeakLabels],
                    Invisible[Button["\[LeftGuillemet]"]],
                    Button["\[LeftGuillemet]",resetAllLabels[]]
                  ],
                  TrackedSymbols:>{currentPeakLabels}
                ]
              }
            ]
          ];

          (* Final assembly of information. *)
          Column[
            {
              debugSection,
              columnSetterSection,
              peakTable,
              uploadButton
            },
            Left
          ]
        ],
      (* Otherwise, set up a normal static table. *)
      True,
        Module[{peakNumbers, allData, columnHeaders, allDataWithPeakInfo, allColumnHeaders},
          (* Determine the number of peaks from the analysis. *)
          peakNumbers = If[nmrTableQ,
            Range[Length[Lookup[analysisObjectPacket, NMRChemicalShift]]],
            Range[Length[peakLabels]]
          ];

          (* If no columns, use {} placeholders. *)
          allData = Which[
            !MatchQ[filteredInitialColumnFields, {}] && nmrTableQ,
              Transpose[
                (* NMR fields already have units integrated into them, so don't need to add here. *)
                Lookup[analysisObjectPacket, filteredInitialColumnFields]
              ],
            !MatchQ[filteredInitialColumnFields, {}],
              Transpose[
                (* Units are not in the raw data, so need to multiply it in here. *)
                Lookup[analysisObjectPacket, filteredInitialColumnFields] * Lookup[peakUnits, filteredInitialColumnFields, 1]
              ],
            True,
              ConstantArray[{}, Length[peakLabels]]
          ];

          (* Make headers for the selected fields to display. *)
          columnHeaders = formatFieldHeaders[initialColumnFields, analysisObjectPacket, convertHeadingsQ];

          (* Combine pre-column peak info with column peak data. *)
          {allDataWithPeakInfo, allColumnHeaders} = If[
            Or[
              nmrTableQ,
              MatchQ[peakLabels, {""..}]
            ],
            {
              MapThread[Prepend[#2, #1]&, {peakNumbers, allData}],
              Prepend[columnHeaders, "Peak Number"]
            },
            {
              MapThread[Join[{#1, #2}, #3]&, {peakNumbers, peakLabels, allData}],
              Join[{"Peak Number", "Peak Label"}, columnHeaders]
            }
          ];

          (* Generate the static table. *)
          PlotTable[
            allDataWithPeakInfo,
            Alignment -> {Left, Automatic},
            TableHeadings -> {Automatic, allColumnHeaders},
            Tooltips -> False,
            HorizontalScrollBar -> False,
            UnitForm -> False
          ]
        ]
    ]
  ];

  (* Tables are assembled for each peak analysis object with the resolved table labels. *)
  peakAnalysisTables = MapThread[
    Function[{analysisPacket, columnFields, maxHeight},
      buildPeaksTable[analysisPacket, columnFields, maxHeight]
    ],
    {peakAnalysisPackets, resolvedColumnFields, resolvedMaxHeights}
  ];

  (* Error-checking *)

  (* If input analysis objects do not have peaks, then warn the user. *)
  analysisObjectsWithoutPeaks = PickList[
    listedAnalysisObjects,
    Map[Length, Lookup[peakAnalysisPackets, Position]],
    EqualP[0]
  ];

  If[Length[analysisObjectsWithoutPeaks] > 0,
    Module[{noPeakIndices},
      (* Need to pick out input indices for warning. *)
      noPeakIndices = PickList[Range[Length[listedAnalysisObjects]], listedAnalysisObjects, ObjectP[analysisObjectsWithoutPeaks]];

      Message[Warning::NoPeaksInAnalysis, analysisObjectsWithoutPeaks, noPeakIndices]
    ]
  ];

  analysisObjectPeakTest = If[gatherTests,
    Module[{affectedObjects, failingTest, passingTest},
      affectedObjects = analysisObjectsWithoutPeaks;

      failingTest = If[Length[affectedObjects] == 0,
        Nothing,
        Test["The peak analysis object(s) " <> ObjectToString[affectedObjects, Cache -> cache] <> " has one or more peaks to be analyzed:", True, False]
      ];

      passingTest = If[Length[affectedObjects] == Length[myAnalysisObjects],
        Nothing,
        Test["The peak analysis object(s) " <> ObjectToString[Complement[myAnalysisObjects, affectedObjects], Cache -> cache] <> " has one or more peaks to be analyzed:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* If input analysis objects have invalid columns specified, then warn the user. *)
  {analysesWithInvalidColumns, invalidColumns} = Map[Flatten, Transpose[
    MapThread[
      Function[{analysisObjectPacket, columnFields},
        Module[{nmrReferenceQ, nmrColumns, nonNMRColumns},
          nmrReferenceQ = MatchQ[Lookup[analysisObjectPacket, Reference], {ObjectP[Object[Data, NMR]]..}];
          nmrColumns = Complement[columnFields, $NonNMRPeaksFields];
          nonNMRColumns = Complement[columnFields, $NMRPeaksFields];

          Which[
            Or[
              nmrReferenceQ && !nmrInformationQ && Length[nmrColumns] > 0,
              !nmrReferenceQ && Length[nmrColumns] > 0
            ],
              {Lookup[analysisObjectPacket, Object], nmrColumns},
            nmrReferenceQ && nmrInformationQ && Length[nonNMRColumns] > 0,
              {Lookup[analysisObjectPacket, Object], nonNMRColumns},
            True,
              {{}, {}}
          ]
        ]
      ],
      {peakAnalysisPackets, resolvedColumnFields}
    ]
  ]];

  If[Length[analysesWithInvalidColumns] > 0,
    Module[{invalidColumnIndices},
      (* Need to pick out input indices for warning. *)
      invalidColumnIndices = PickList[
        Range[Length[listedAnalysisObjects]],
        listedAnalysisObjects,
        ObjectP[analysesWithInvalidColumns]
      ];

      Message[
        Warning::InvalidColumns,
        analysesWithInvalidColumns,
        invalidColumnIndices,
        invalidColumns,
        nmrInformationQ
      ]
    ]
  ];

  invalidColumnTest = If[gatherTests,
    Module[{affectedObjects, failingTest, passingTest},
      affectedObjects = analysesWithInvalidColumns;

      failingTest = If[Length[affectedObjects] == 0,
        Nothing,
        Test["The peak analysis object(s) " <> ObjectToString[affectedObjects, Cache -> cache] <> " have valid columns specified:", True, False]
      ];

      passingTest = If[Length[affectedObjects] == Length[myAnalysisObjects],
        Nothing,
        Test["The peak analysis object(s) " <> ObjectToString[Complement[myAnalysisObjects, affectedObjects], Cache -> cache] <> " have valid columns specified:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* If NMR peak fields are specified, but only traditional peak fields exist for the object, then warn the user. *)
  missingNMRPeakAnalysisObjects = Map[
    Module[{nmrReferenceQ, nmrEmptyFieldContentsQ},
      nmrReferenceQ = MatchQ[Lookup[#, Reference], {ObjectP[Object[Data, NMR]]..}];
      nmrEmptyFieldContentsQ = And[
        MatchQ[Lookup[#, $NMRPeaksFields], {{}..}],
        (* Check that there were "traditional" peaks to display. If not, will be caught by Warning::NoPeaksInAnalysis instead. *)
        Length[Lookup[#, Position]] > 0
      ];

      If[And[nmrReferenceQ, nmrEmptyFieldContentsQ, nmrInformationQ],
        Lookup[#, Object],
        Nothing
      ]
    ]&,
    peakAnalysisPackets
  ];

  If[Length[missingNMRPeakAnalysisObjects] > 0,
    Module[{missingNMRPeakIndices},
      (* Need to pick out input indices for warning. *)
      missingNMRPeakIndices = PickList[
        Range[Length[listedAnalysisObjects]],
        listedAnalysisObjects,
        ObjectP[missingNMRPeakAnalysisObjects]
      ];

      Message[Warning::NoNMRAnalysisToDisplay, missingNMRPeakAnalysisObjects, missingNMRPeakIndices]
    ]
  ];

  missingNMRPeakTest = If[gatherTests,
    Module[{affectedObjects, failingTest, passingTest},
      affectedObjects = missingNMRPeakAnalysisObjects;

      failingTest = If[Length[affectedObjects] == 0,
        Nothing,
        Test["The peak analysis object(s) " <> ObjectToString[affectedObjects, Cache -> cache] <> " have NMR splitting peaks to display:", True, False]
      ];

      passingTest = If[Length[affectedObjects] == Length[myAnalysisObjects],
        Nothing,
        Test["The peak analysis object(s) " <> ObjectToString[Complement[myAnalysisObjects, affectedObjects], Cache -> cache] <> " have NMR splitting peaks to display:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Null
  ];

  (* Assemble resolved options. *)
  resolvedOptions = ReplaceRule[
    safeOptions,
    {
      Columns -> resolvedColumnFields,
      MaxHeight -> resolvedMaxHeights
    }
  ];

  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    PlotPeaksTable,
    RemoveHiddenOptions[PlotPeaksTable, resolvedOptions],
    Messages -> False
  ];

  (* Prepare the Options result if we were asked to do so *)
  (* Result output is a list, but for a preview, SlideView is used to align better with other similar functions. *)
  (* If a singular input, then show the single table. *)
  previewRule = Preview -> If[
    MatchQ[myAnalysisObjects, _List],
    SlideView[
      peakAnalysisTables,
      AppearanceElements -> {
        "FirstSlide", "PreviousSlide",
        "NextSlide", "LastSlide",
        If[Length[peakAnalysisTables] > 10,
          "SliderControl",
          Nothing
        ],
        "SlideNumber", "SlideTotal"
      },
      ControlPlacement -> {Top, Center},
      FrameMargins -> 10
    ],
    First[peakAnalysisTables]
  ];

  (* Prepare the Options result if we were asked to do so *)
  optionsRule = Options -> If[MemberQ[output,Options],
    collapsedResolvedOptions,
    Null
  ];

  (* Prepare the Test result if we were asked to do so *)
  testsRule = Tests -> If[MemberQ[output,Tests],
    (* Join all existing tests generated by helper functions with any additional tests *)
    Join[
      safeOptionTests,
      Flatten[
        {
          analysisObjectPeakTest,
          invalidColumnTest,
          missingNMRPeakTest
        }
      ]
    ],
    Null
  ];

  (* Prepare the standard result if we were asked for it and we can safely do so *)
  resultRule = Result -> If[MemberQ[output,Result],
    (* Return list of peak tables. If singular input, then return singular table. *)
    If[
      MatchQ[myAnalysisObjects, _List],
      peakAnalysisTables,
      First[peakAnalysisTables]
    ],
    Null
  ];

  outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];


(* Helper to plot a table that scrolls but the headers are frozen *)
(*
  !!!!Important!!!!!
  Keeping the headers fixed but scrolling the table means we have to construct them separately
  The main challenge then becomes ensuring they have the same column widths, but also making sure those widths are automatic and sensible
  We can't take any easy shortcuts, such as comparing string length, because that doesn't work for more complex MM expressions such as input boxes
  So here we use a little trick with Invisible and Overlay to plot everything in both tables so that Grid gives both tables the same column widths
  However, this means we have restrictions - we must perform the same changes to the data in both tables, including styling
*)
scrollableTable[data : {___}, headings : {___}, maxTableHeight : GreaterP[0]] := Module[
  {headerHorizontalAlignment, tableHorizontalAlignment, styledHeadings, allColumnData, formattedHeaders, formattedData},

  (* Table alignments - put in a variable here to make sure overlay is correctly adjusted *)
  {headerHorizontalAlignment, tableHorizontalAlignment} = {Left, Left};

  (* Style the headings here - we need to do this first so that the column widths are consistent between tables *)
  styledHeadings = styleTableHeaders[headings, headerHorizontalAlignment];

  (* Transpose the data to get a list of what's in each colum *)
  allColumnData = Transpose[data];

  (* For the headers, hide the data behind it to make sure we get the correct width *)
  formattedHeaders = MapThread[
    Overlay[Prepend[Invisible /@ #2, #1], Alignment -> {headerHorizontalAlignment, Center}]&,
    {styledHeadings, allColumnData}
  ];

  (* For the data, append a hidden row to the bottom of the table to keep the rows the same size as the headings *)
  formattedData = Append[data, Invisible /@ styledHeadings];

  (* Assemble the combined table *)
  (* Deploy prevents copying of the invisible expressions *)
  Deploy@Column[
    {
      (* Fixed headers are a table *)
      Pane[
        PlotTable[
          {formattedHeaders},
          Alignment -> headerHorizontalAlignment,
          Tooltips -> False,
          HorizontalScrollBar -> False,
          (* Must be plotted with UnitForm -> False as PlotTable doesn't convert the form of the Invisible expressions in the header *)
          UnitForm -> False
        ]
      ],

      (* With the contents of the table being a scrollable pane underneath *)
      Pane[
        PlotTable[
          formattedData,
          Alignment -> tableHorizontalAlignment,
          Tooltips -> False,
          HorizontalScrollBar -> False,
          (* Must be plotted with UnitForm -> False as PlotTable doesn't convert the form of the Invisible expressions in the header *)
          UnitForm -> False
        ],
        {Automatic, maxTableHeight},
        Scrollbars -> {False, True}
      ]
    },
    Spacings -> 0
  ]
];