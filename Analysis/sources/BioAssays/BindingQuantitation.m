(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeBindingQuantitation*)


(* ::Subsubsection:: *)
(*AnalyzeBindingQuantitation*)


DefineOptions[AnalyzeBindingQuantitation,
  Options :> {

    (* ----------------------------- *)
    (* -- SAMPLE/STANDARD FITTING -- *)
    (* ----------------------------- *)

    {
      OptionName -> FittedParameter,
      Default -> FullRate,
      AllowNull -> False,
      Description -> "Specifies the type of parameter that should be used for generating the standard curve. AverageEquilibriumResponse: Calculates the average response value of a user-specified region deemed to be representative of equilibrium response. This is best suited for data where a secondary solution was used for analyte detection, and the Quantitation step is of sufficient length to reach equilibrium. FitEquilibriumResponse: Calculates the equilibrium response based on the fitting of the association curve. This is best suited for data where a secondary solution was used for analyte detection, but the Quantitation step time is not long enough to reach equilibrium. InitialRate: Calculates the binding rate in a user specified region, and may be more accurate than FullRate in cases where the analyte concentration is high enough that it quickly saturates the available binding sites. FullRate: Calculates the observed rate by fitting the user specified domain of data. If StandardData is included, the calculated response is plotted against the concentration to generate a standard curve.",
      Widget->Widget[Type -> Enumeration, Pattern:>Alternatives[AverageEquilibriumResponse, InitialRate, FullRate]],
      Category -> "Data Processing"
    },

    (* ----------------------- *)
    (* -- SAMPLE PROCESSING -- *)
    (* ----------------------- *)

    {
      OptionName -> Baselines,
      Default -> Automatic,
      Description -> "Specifies a baseline that should be subtracted from the analyte detection data. A single value specifies a baseline to be used for all elements of the input, while multiple values specifies a baseline for the corresponding element of the input data.",
      ResolutionDescription -> "When using data objects or protocols as input, the relevant baseline(s) will be extracted from the QuantitationAnalyteDetectionBaseline field.",
      AllowNull -> True,
      Category -> "Data Processing",
      Widget->
          Alternatives[
            "Matched Baselines" -> Adder[
              Alternatives[
                "Baseline Data" -> Adder[
                  {
                    "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                    "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
                  }
                ],
                "No Baseline" -> Widget[Type -> Enumeration, Pattern:>Alternatives[Null]],
                "Constant"->Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]],
                "Function" -> Widget[Type -> Expression, Pattern:>_Function, Size ->Line],
                "Data Object" -> Widget[Type -> Expression, Pattern:> ObjectP[{Object[Data, BioLayerInterferometry]}], Size -> Line]
              ]
            ],
            "Single Baseline Data" -> Adder[
              {
                "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
              }
            ],
            "Single Constant" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]],
            "Single Expression" -> Widget[Type -> Expression, Pattern:>_Function, Size ->Line],
            "Single Data Object" -> Widget[Type -> Expression, Pattern:> ObjectP[{Object[Data, BioLayerInterferometry]}], Size -> Line]
          ]
    },
    {
      OptionName -> InitialFitDomain,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "Specify the region of data to be fit from the first point of each sample or standard measurement. A value of 10 Second will indicate that only the first 10 Seconds of data are to be fit to determine the FittedParameter. Null indicates that fitting should not be restricted to an initial domain.",
      ResolutionDescription -> "If the FittedParameter is InitialRate, the InitialFitDomain will be set to 40 Second, an all other cases it will be set to Null.",
      Widget -> Widget[Type -> Quantity, Pattern:>GreaterP[0 Second], Units -> Second],
      Category -> "Data Processing"
    },
    {
      OptionName -> FinalFitDomain,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "Specify the region of data to be fit from the last point of each sample or standard measurement. A value of 10 Second will indicate that only the last 10 Seconds of data are to be fit to determine the FittedParameter. Null indicates that fitting should not be restricted to a final domain.",
      ResolutionDescription -> "If the FittedParameter is AverageEquilibriumResponse, the FinalFitDomain will be set to 40 Second, an all other cases it will be set to Null.",
      Widget -> Widget[Type -> Quantity, Pattern:>GreaterP[0 Second], Units -> Second],
      Category -> "Data Processing"
    },

    (* there are some more procesing options related to smoothing *)
    {
      OptionName -> FilterType,
      Default -> GaussianFilter,
      AllowNull -> False,
      Description -> "Specifies the type of filter used to smooth data. Data filtering is performed after fitting analysis for cleaner data visualization.",
      Widget->Widget[Type -> Enumeration, Pattern:>Alternatives[MeanFilter, GaussianFilter]],
      Category -> "Data Processing"
    },
    {
      OptionName -> FilterWidth,
      Default -> Automatic,
      AllowNull -> False,
      Description -> "Specifies the radius of the filter region for averaging techniques. In general, averaging over 1 Second will be sufficient to reduce noise without distorting the data. This value will not impact the fitting of the data, only the appearance of the output plots.",
      ResolutionDescription -> "If FilterType requires a FilterWidth, this value will be set to 1 Second.",
      Widget->Widget[Type -> Quantity, Pattern:>GreaterP[0 Second], Units -> Second],
      Category -> "Data Processing"
    },

    (* ---------------------- *)
    (* -- STANDARD OPTIONS -- *)
    (* ---------------------- *)

    {
      OptionName -> StandardData,
      Default -> Automatic,
      Description -> "Specifies a set of data to be used as a standard curve.",
      ResolutionDescription -> "When using data objects or protocols as input, the data will be extracted from the QuantitationStandardDetection field of the data object.",
      AllowNull -> True,
      Widget->
          Alternatives[
            Adder[
            Adder[
              {
                "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
              }
            ]
          ],
            Widget[Type -> Expression, Pattern:>ObjectP[{Object[Data, BioLayerInterferometry]}], Size -> Line]
          ],
      Category -> "Data Processing"
    },
    {
      OptionName -> StandardConcentrations,
      Default -> Automatic,
      Description -> "Specifies the concentration of the analyte in each solution used to generate StandardData.",
      ResolutionDescription -> "When using Data objects or protocol input, this field will be automatically populated if the concentrations are available in QuantitationStandardDilutionConcentrations field of the object.",
      AllowNull -> True,
      Widget->
          Alternatives[
            Adder[
              Widget[Type -> Quantity, Pattern:>Alternatives[GreaterP[0 Nano Molar],GreaterP[0 Milligram/Milliliter]], Units -> Alternatives[Nano Molar, Milligram/Milliliter]]
            ],
            Widget[Type -> Expression, Pattern:>ObjectP[{Object[Data, BioLayerInterferometry]}], Size -> Line]
          ],
      Category -> "Data Processing"
    },
    {
      OptionName -> StandardBaselines,
      Default -> Automatic,
      Description -> "Specifies a baseline that should be subtracted from the standard detection data. Single input specifies a baseline to be used for all elements of StandardData, while multiple inputs specifies a baseline for the corresponding element of StandardData.",
      ResolutionDescription -> "When using data objects or protocols as input, the relevant baseline(s) will be extracted from the StandardDetectionBaseline field.",
      AllowNull -> True,
      Widget->
          Alternatives[
            "Matched Baselines" -> Adder[
              Alternatives[
                "Baseline Data" -> Adder[
                  {
                    "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                    "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
                  }
                ],
                "No Baseline" -> Widget[Type -> Enumeration, Pattern:>Alternatives[Null]],
                "Constant"->Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]],
                "Function" -> Widget[Type -> Expression, Pattern:>_Function, Size ->Line],
                "Data Object" -> Widget[Type -> Expression, Pattern:> ObjectP[{Object[Data, BioLayerInterferometry]}], Size -> Line]
              ]
            ],
            "Single Baseline Data" -> Adder[
              {
                "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
              }
            ],
            "Single Constant" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]],
            "Single Expression" -> Widget[Type -> Expression, Pattern:>_Function, Size ->Line],
            "Single Data Object" -> Widget[Type -> Expression, Pattern:> ObjectP[{Object[Data, BioLayerInterferometry]}], Size -> Line]
          ],
      Category -> "Data Processing"
    },


    (* -- STANDARD CURVE FITTING -- *)
    {
      OptionName -> StandardCurveFit,
      Default -> Automatic,
      Description -> "Specifies the type of function used as a standard curve. Commonly used fits are Sigmoid and Linear, PolynomialOrder2 and PolynomialOrder3 give second and third order terms in the polynomial fit.",
      ResolutionDescription -> "The fit choice will default to Linear when StandardData is specified.",
      AllowNull -> True,
      Category -> "Data Processing",
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[FitTypeP, (*Analysis`Private`fitTypeSymbolP,*) LogisticFourParameter, LogisticFiveParameter, PolynomialOrder2, PolynomialOrder3]]
    },

    (*TODO: when analyze fit has weighting uncomment this and pass through to analyze fit.*)
    (*
    {
      OptionName -> StandardCurveWeight,
      Default -> None,
      Description -> "Specify a weighting expression for the standard curve as a pure function. To weight with respect to response use #2, for weight by time #. An example is to weight as (1/#2^2)&.",
      AllowNull -> True,
      Widget -> Widget[Type->Expression, Pattern:>_Function, Size->Line]
    },*)

    {
      OptionName -> ReferenceObjects,
      Default -> Automatic,
      Description -> "Data objects which were used in this analysis.",
      ResolutionDescription -> "When the inputs are Data objects, this field will store the objects from which the data was generated.",
      AllowNull -> True,
      Widget -> Adder[Widget[Type -> Expression, Pattern:>ObjectP[Object[Data]], Size -> Line]],
      Category -> "Hidden"
    },
    {
      OptionName -> SamplesIn,
      Default -> Automatic,
      Description -> "The samples to be analyzed.",
      ResolutionDescription -> "When inputs are Data or Protocol objects, this field will store the samples from which the data was generated.",
      AllowNull -> True,
      Widget -> Adder[Widget[Type -> Expression, Pattern:>ObjectP[Object[Sample]], Size -> Line]],
      Category -> "Hidden"
    },

    OutputOption,
    UploadOption,
    CacheOption,
    AnalysisTemplateOption
  }
];

(* data processing errors*)
Error::BadBLIBaselineUnits = "The following baseline units, `1`, do not match the units of the provided data.";
Error::BadBLIDataUnits = "The input data contains different units `1`. Objects with different units cannot be analyzed together in this function.";
Error::InsufficientBLIBaseline = "The specified baseline does not cover the full domain of the data it is a baseline for.";
Error::ConflictingBindingQuantitationFitDomainOptions = "One of the following options must be Null if the other is specified: `1`. Set one of these options to Null or Automatic.";
Warning::BindingQuantitationConflictingDomainAndParameter = "The domain specified by `1` is inconsistent with the selected FittedParameter. When fitting InitialRate, use InitialFitDomain, and when fitting AverageEquilibriumResponse, use FinalFitDomain.";

Error::BindingQuantitationInvalidStandardBaselineRange = "The baseline domain does not match the sample data that it is a baseline for.";
Error::BindingQuantitationInvalidBaselineRange = "The baseline domain does not match the standard data that it is a baseline for.";
Error::BindingQuantitationAmbiguousStandardBaseline = "The number of baselines is not equal to one or the number of standard data sets and could not be used.";
Error::BindingQuantitationAmbiguousBaseline = "The number of baselines is not equal to one or the number of input data objects.";

(* fit failure errors *)
Error::BindingQuantitationFittingFailed = "The selected fit model was unable to accurately fit the provided data. Adjust the Domain or the FittedParameter.";
Error::BindingQuantitationStandardFitFailed = "The selected fit model was unable to accurately fit the provided standard data. Adjust the StandardDomains or the FittedParameter.";


(* input errors *)
Error::NoBindingQuantitationDataObjects = "The input Protocol object does not contain any data.";
Error::MixedBindingQuantitationDataTypes = "The provided Data objects are not of the same type.";
Error::InvalidBindingQuantitationDataType = "The input objects have DataType `1`. The DataType must be Quantitation.";

(*random errors*)
Error::UnusedABQFilterWidth = "The FilterWidth `1` will not be used unless the FilterType option has been set.";
Error::UnusedABQStandardOptions = "The following options were specified but not used because there is no StandardData: `1`.";
Error::BindingQuantitationMultipleStandardDataSets = "There are multiple standard curve data sets specified. All data objects must use a single standard curve.";
Error::BindingQuantitationMissingStandardDataSets = "No StandardData was input or could be extracted form the input Data object or Protocol. Change the value of this option to a standard data set or an object which contains standard data.";





(* ------------------------------------ *)
(* -- BINDING QUANTITATION OVERLOADS -- *)
(* ------------------------------------ *)

(* -- overload for protocol object -- *)
AnalyzeBindingQuantitation[
  protocol:ObjectP[{Object[Protocol, BioLayerInterferometry]}],
  ops:OptionsPattern[AnalyzeBindingQuantitation]
]:=Module[{dataObjs},

  (* extract the data objects, if there are non, return failed *)
  dataObjs = Download[protocol, Data];

  (* return failed and NoDataBindingKinetics error *)
  If[MatchQ[dataObjs, ({}|Null)],
    Message[Error::NoBindingQuantitationDataObjects];
    Return[$Failed]
  ];

  (* strip the link and send it to the next overload *)
  AnalyzeBindingQuantitation[
    ToList[Download[dataObjs, Object]],
    ops
  ]
];


(* -- single data object overload - convert to a listed single data object -- *)

AnalyzeBindingQuantitation[
  dataObject:ObjectP[{Object[Data, BioLayerInterferometry]}],
  ops:OptionsPattern[AnalyzeBindingQuantitation]
]:=AnalyzeBindingQuantitation[
  {dataObject},
  ops
];

(* -------------------------- *)
(* -- MULTIPLE DATA OBJECT -- *)
(* -------------------------- *)

(*TODO: when SPR is developed if you can either use this error or create an overload for SPR data. *)
Error::MixedBindingQuantitationDataTypes = "Data objects from multiple types were provided as input.";
Error::InvalidBindingQuantitationDataType = "The given data objects are not of the correct experiment type to be analyzed using this function.";


(* this is the key overload to convert to raw data and to check that it is usable *)
(* each data will only contain one set of measurement data for BLI, and a standard curve if one was generated. *)
(* each data object will come with a baseline if one exists. If they want to baseline using a well in teh same column or something silly they are on their own *)
AnalyzeBindingQuantitation[
  dataObjects:{ObjectP[{Object[Data, BioLayerInterferometry]}]..},
  ops:OptionsPattern[]
]:=Module[
  {
    dataTypes,safeDataType,dataPackets,notInEngine,gatherTests, outputSpecification, output,
    (* the baselines etc we extracted form data objects *)
    sampleData, sampleBaselines, standardData, standardBaselines, standardConcentrations,samplesIn, dataObjectCache,
    badDataTypeBool,
    (* the original option values *)
    originalBaselines, originalStandardData, originalStandardBaselines, originalStandardConcentrations,
    (* the new option values *)
    newOps, listOps, safeOptions, safeOptionTests
  },

  (* Determine if we are in Engine or not, in Engine we silence warnings *)
  notInEngine=Not[MatchQ[$ECLApplication,Engine]];

  listOps = ToList[ops];
  (* Determine the requested return value from the function *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOptions, safeOptionTests} = If[gatherTests,
    SafeOptions[AnalyzeBindingQuantitation, listOps, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[AnalyzeBindingQuantitation, listOps, AutoCorrect -> False], Null}
  ];

  (* If the specified options don't match their patterns return $Failed *)
  If[MatchQ[safeOptions, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* determine which type of data objects we are looking at - plan for SPR incorporation here *)
  dataTypes = Map[
    Which[
      (*BioLayerInterferometryData*)
      MatchQ[#, ObjectP[Object[Data, BioLayerInterferometry]]],
      BLI,

      (*TODO: add SPR pattern here*)
      True,
      Null
    ]&,
    dataObjects];

  (* if the data type input is ok, these are all the same so we can just take the first element *)
  safeDataType = First[DeleteDuplicates[dataTypes]];

  (* if the data types are mixed, throw and error and exit *)
  If[MatchQ[Length[DeleteDuplicates[dataTypes]], GreaterP[1]],
    If[!gatherTests,
      Message[{Error::MixedBindingQuantitationDataTypes, dataTypes}];
      Message[Error::InvalidInput, dataObjects],
      Nothing
    ];
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Append[
        safeOptionTests,
          Test["If data input all data objects are of the same type:",
            MatchQ[Length[DeleteDuplicates[dataTypes]], GreaterP[1]],
            False
          ]
      ],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* ------------------------------------------------ *)
  (* --  EXTRACT THE BASELINES/DATA/CONCENTRATIONS -- *)
  (* ------------------------------------------------ *)

  (* since we know that the data type is ok, we can proceed to extract the quantitation data *)
  {
    sampleData,
    samplesIn,
    dataObjectCache,
    badDataTypeBool
  } = Which[

    (* experiment type BLI *)
    MatchQ[safeDataType, BLI],
    Module[
      {
        dataPackets, bliAssayType, bliAnalyteData, bliSamplesIn, badDataBool
      },

      (* make a cache to pass to the next overload *)
      (* these are all the relevant fields  *)
      dataPackets = Quiet[
        Download[
        dataObjects,
        Packet[
          DataType,
          SamplesIn,
          QuantitationAnalyteDetection,
          QuantitationAnalyteDetectionBaseline,
          QuantitationStandardDetection,
          QuantitationStandardDetectionBaselines,
          QuantitationStandardDilutionConcentrations
        ]
      ]
      ];

      (* pull out the input samples *)
      bliSamplesIn = Lookup[dataPackets, SamplesIn];

      (* look up what type of experiment it was so we can find the right keys - right now only quantitation can be processed here. *)
      bliAssayType = Lookup[dataPackets, DataType];

      (* if the data is not quantitation data, then we can just exit later on *)
      badDataBool = If[!MatchQ[Cases[bliAssayType, Except[Quantitation]], {}],
        True,
        False
        ];

      (* since this is restricted to quantitation, just grab the field we know to look for *)
      bliAnalyteData = Lookup[dataPackets, QuantitationAnalyteDetection];

      (* pass all of the data, conc, baselines out *)
      {bliAnalyteData, bliSamplesIn, dataPackets, badDataBool}
    ],


    (*TODO: add SPR download here*)
    True,
    {Null, Null, Null, True}
  ];

  (* if the data is not quantitation data, then we can just exit *)
  If[MatchQ[badDataTypeBool, True],
    If[!gatherTests,
      Message[Error::InvalidBindingQuantitationDataType],
      Nothing
    ];
    If[!gatherTests,
      Message[Error::InvalidInput, dataObjects],
      Nothing
    ];
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Append[
        ToList[safeOptionTests],
        Test["If data input is used, all data objects have ExperimentType Quantitation:",
          MatchQ[badDataTypeBool, False],
          True
        ]
      ],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* -- REPLACE OPTIONS -- *)

  (* add the tracking options so we can figure out which data objects to upload to later *)
  newOps = ReplaceRule[safeOptions,
    {
      ReferenceObjects -> Flatten[Download[dataObjects, Object]],
      SamplesIn -> Flatten[Download[samplesIn, Object]],
      Cache -> dataObjectCache
    }
  ];

  (* call the core function - pass in the object cache so we wont need a second download*)
    AnalyzeBindingQuantitation[sampleData, newOps]
];




(* --------------------------------------- *)
(* -- ANALYZE BINDING QUANTITATION CORE -- *)
(* --------------------------------------- *)

(* analyze binding quantitation *)
AnalyzeBindingQuantitation[
  quantitationData:{_?QuantityArrayQ..},
  ops:OptionsPattern[]
]:=Module[
  {
    (* general/framework variables *)
    optionsCache, optionsWithObjects, fieldsToDownload, listedOptions, cachelessOptions, outputSpecification, output, standardFieldsStart, gatherTests, messages, notInEngine, safeOptions, safeOptionTests,
    unresolvedOptions, templateTests,combinedOptions,cacheBall,allTests,resolvedOptionsTests, resolvedOptionsResult, collapsedResolvedOptions,
    analysisObjects, upload,
    (* download and resolution *)
    resolvedOptions,
    (* parameters for setup *)
    standardData, safeStandardData, standardBaselines, standardConcentrations, baselines, concentrationUnits,
    (* resolved options *)
    fittedParameter, filterType, safeStandardConcentrations, filterWidth, initialFitDomain,
    finalFitDomain, standardCurveFit, optimizationOptions,
    (* processed data and data processing variables *)
    matchedStandardBaselines,matchedBaselines, baselinedSampleData, baselinedStandardData, filteredSampleData, filteredStandardData,
    safeSampleDomains, alignedSampleData, alignedStandardData, standardDataDensities, sampleDataDensities,
    standardCurveFits, standardCurveFitParameters, standardCurvePoints,
    sampleCurveFits, sampleFitParameters, safeSampleFitParameters, analysisObjectFieldPackets,
    standardFitPackets, sampleFitPackets, validFit, bindingFitTest, safeStandardFitParameters,
    standardCurveFitPacket, concentrationResult, alignedStandardOffsets, alignedSampleOffsets,
    safeStandardDomains, alignedStandardMaxTimes, alignedSampleMaxTimes,
    (*cleanup for output*)
    reqFit, reqFitError, rateFit, rateFitError, standardCurveFitAnalysis,
    standardDataFitAnalysis, samplesInFitAnalysis, safeSampleFitError,
    allTestsWithFit,validStandardFit,bindingStandardFitTest,allTestsWithStandardFit,
    (* output variables *)
    optionsRule, resultRule, testsRule, previewRule
  },


  (* -- FRAMEWORK CODE -- *)

  (* Make sure we're working with a list of options *)
  listedOptions = ToList[ops];

  (* remove the cache that had been passed as an option - we dont want it to show up in the unresolved options *)
  cachelessOptions = DeleteCases[listedOptions, (Cache -> _)];

  (* Determine the requested return value from the function *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* fixed starting fields *)
  standardFieldsStart = analysisPacketStandardFieldsStart[{ops}];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];
  messages=!gatherTests;

  (* Determine if we are in Engine or not, in Engine we silence warnings *)
  notInEngine=Not[MatchQ[$ECLApplication,Engine]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOptions, safeOptionTests} = If[gatherTests,
    SafeOptions[AnalyzeBindingQuantitation, cachelessOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[AnalyzeBindingQuantitation, cachelessOptions, AutoCorrect -> False], Null}
  ];

  (* If the specified options don't match their patterns return $Failed *)
  If[MatchQ[safeOptions, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> safeOptionTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];


  (* Use any template options to get values for options not specified in myOptions *)
  {unresolvedOptions, templateTests} = If[gatherTests,
    ApplyTemplateOptions[AnalyzeBindingQuantitation, quantitationData, cachelessOptions, Output -> {Result, Tests}],
    {ApplyTemplateOptions[AnalyzeBindingQuantitation, quantitationData, cachelessOptions], Null}
  ];

  combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];


  (* -- Assemble big download -- *)

  (*get all of the object from the options, note that we will remove the referenceObjects option do avoid a duplicate download*)
  optionsWithObjects = DeleteDuplicates[Cases[KeyDrop[combinedOptions, {ReferenceObjects, SamplesIn}], ObjectP[], Infinity]];

  (* fields to download are for BLI objects only. This will need to change for SPR. Note that we download a couple fields we wont use to match the previous download so we can clean up the cache*)
  fieldsToDownload = Packet[
    DataType,
    SamplesIn,
    QuantitationAnalyteDetection,
    QuantitationAnalyteDetectionBaseline,
    QuantitationStandardDetection,
    QuantitationStandardDetectionBaselines,
    QuantitationStandardDilutionConcentrations
  ];

  (* download the things *)
  optionsCache=Quiet[
    Download[
      optionsWithObjects,
      fieldsToDownload
    ],
    Download::FieldDoesntExist
  ];

  (* pass the object packets through the cache - important to look it up from listed options because everything else has it removed *)
  cacheBall = Cases[Experiment`Private`FlattenCachePackets[{Lookup[listedOptions, Cache], optionsCache}], PacketP[]];

  (*--Build the resolved options--*)
  resolvedOptionsResult=If[gatherTests,
    (*We are gathering tests. This silences any messages being thrown*)
    {resolvedOptions,resolvedOptionsTests}=resolveAnalyzeBindingQuantitationOptions[quantitationData,combinedOptions,Cache->cacheBall,Output->{Result,Tests}];

    (*Therefore, we have to run the tests to see if we encountered a failure*)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveAnalyzeBindingQuantitationOptions[quantitationData,combinedOptions,Cache->cacheBall],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];


  (*Collapse the resolved options*)
  collapsedResolvedOptions=CollapseIndexMatchedOptions[
    AnalyzeBindingQuantitation,
    resolvedOptions,
    Ignore->cachelessOptions,
    Messages->False
  ];

  allTests=Cases[Flatten[{safeOptionTests,resolvedOptionsTests}],_EmeraldTest];


  (*If option resolution failed, return early*)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->allTests,
      Options->RemoveHiddenOptions[AnalyzeBindingQuantitation, collapsedResolvedOptions],
      Preview->Null
    }]
  ];


  (* ------------------------ *)
  (* -- MAIN ANALYSIS BODY -- *)
  (* ------------------------ *)


  (* look up all the options *)
  {
    fittedParameter,
    baselines,
    initialFitDomain,
    finalFitDomain,
    filterType,
    filterWidth,
    standardData,
    standardBaselines,
    standardCurveFit,
    optimizationOptions,
    standardConcentrations,
    upload
  }=Lookup[resolvedOptions,
    {
      FittedParameter,
      Baselines,
      InitialFitDomain,
      FinalFitDomain,
      FilterType,
      FilterWidth,
      StandardData,
      StandardBaselines,
      StandardCurveFit,
      OptimizationOptions,
      StandardConcentrations,
      Upload
    }];


  (* ------------------------ *)
  (* -- MATCHED PARAMETERS -- *)
  (* ------------------------ *)

  (* -- SAMPLE DATA PROCESSING PARAMETERS -- *)

  (* -- if necessary, download and expand the baselines so they match up to the samples -- *)
  matchedBaselines = If[MatchQ[baselines, _List]&&!MatchQ[baselines, _?QuantityArrayQ],

    (* if we have a list, then check each element for validity *)
    Map[
      If[MatchQ[#, ObjectP[]],

        (* if we have an object, download the data, replace any empty lists with Nulls for the helper *)
        Download[#, QuantitationAnalyteDetectionBaseline, Cache -> cacheBall]/.{}->Null,

        (*if we have raw data, a constant, or a function just return the value. It is handled in the helper*)
        #
      ]&,
      baselines
    ],

    (* If we have a single element, just leave it because the helper function can handel it *)
    If[MatchQ[baselines, ObjectP[]],

      (* if we have an object, download the data, replace any empty lists with Nulls for the helper *)
      ConstantArray[Download[
        baselines,
        QuantitationAnalyteDetectionBaseline,
        Cache -> cacheBall
      ]/.{}->Null, Length[quantitationData]],

      (*if we have a quantityarray, function, or constant, just return that and let the helper do its thing*)
      ConstantArray[baselines, Length[quantitationData]]
    ]
  ];

  (* -- STANDARD DATA PROCESSING PARAMETERS -- *)

  (* -- get the standard data -- *)
  safeStandardData = If[MatchQ[standardData, ObjectP[]],
    DeleteDuplicates[Download[standardData, QuantitationStandardDetection, Cache -> cacheBall]]
  ];

  safeStandardConcentrations = If[MatchQ[standardConcentrations, {ObjectP[]..}|ObjectP[]],
    Flatten[DeleteDuplicates[Download[standardData, QuantitationStandardDilutionConcentrations, Cache -> cacheBall]], 1],
    standardConcentrations
  ];

  (* grab the concentration units to use later *)
  concentrationUnits = Units[First[safeStandardConcentrations]];

  (*TODO: somethign a little funny here with quantity array not gettign resepcted. I think it also gets passed into teh helper and does nto evaluate*)
  (* -- get the matched standard baselines also -- *)
  matchedStandardBaselines = Which[
    (* if there is an object, look up the baselines from it *)
    (*Note that the length of the baselines are going to match the length of the standard data since we already checked this*)
    MatchQ[standardBaselines, {ObjectP[{Object[Data]}]..}|ObjectP[{Object[Data]}]],
    Flatten[DeleteDuplicates[Download[ToList[standardBaselines], QuantitationStandardDetectionBaselines, Cache -> cacheBall], MatchQ]/.{}->Null,1],

    (* if it is a quantity array, expand it to match all elements of hte data *)
    MatchQ[standardBaselines, {{_?QuantityQ, _?QuantityQ}..}],
    ConstantArray[standardBaselines, Length[safeStandardData]],

    (*If we have a list, it is data and we can just use that, cleaning up a little*)
    MatchQ[standardBaselines, _List],
    standardBaselines/.{}->Null,

    (* return any functions or constants as they are, the helper is overloaded *)
    True,
    ConstantArray[standardBaselines, Length[safeStandardData]]
  ];


  (* ------------------- *)
  (* -- CLEAN UP DATA -- *)
  (* ------------------- *)

  (* -- BASELINE SUBTRACTION -- *)

  (* baseline the sample data *)
  baselinedSampleData = Flatten[MapThread[baselineBLIQuantitationData[#1,#2, True]&, {quantitationData, matchedBaselines}], 1];

  (* baseline the standard data *)
  baselinedStandardData = Flatten[If[MatchQ[safeStandardData, _List],
    MapThread[baselineBLIQuantitationData[#1, #2, True]&, {safeStandardData, matchedStandardBaselines/.{Null}->ConstantArray[Null, Length[safeStandardData]]}],
    Null
  ],
    1
  ];


  (* -- ALIGN THE SAMPLE AND STANDARD -- *)

  (* align to (0,0) for both standard and sample. *)
  alignedSampleData = alignBLIData[
    baselinedSampleData,
    ConstantArray[0 Nanometer, Length[baselinedSampleData]],
    ConstantArray[0 Second, Length[baselinedSampleData]]
  ];

  (* determine how much the data was shifted on the time axis so that the domain can match it. *)
  alignedSampleOffsets = Subtract[baselinedSampleData[[All, 1, 1]], alignedSampleData[[All,1,1]]];

  (* also determine the spacing of the data points so we can convert domain from time into number of points *)
  sampleDataDensities = Subtract[baselinedSampleData[[All,2,1]], baselinedSampleData[[All,1,1]]];

  (* align to (0,0) also *)
  alignedStandardData = If[MatchQ[baselinedStandardData, _List],
    alignBLIData[
      baselinedStandardData,
      ConstantArray[0 Nanometer, Length[baselinedStandardData]],
      ConstantArray[0 Second, Length[baselinedStandardData]]
    ],
    Null
  ];

  (* determine how much the standard was shifted on the time axis so that the domain can match it. *)
  alignedStandardOffsets = Subtract[alignedStandardData[[All, 1, 1]], baselinedStandardData[[All,1,1]]];

  (* also determine the spacing of the data points so we can convert domain from time into number of points *)
  standardDataDensities = Subtract[baselinedStandardData[[All,2,1]], baselinedStandardData[[All,1,1]]];

  (* --  DETERMINE THE DOMAINS -- *)

  (* identify the end times for samples and standards *)
  alignedSampleMaxTimes = alignedSampleData[[All,-1,1]];
  alignedStandardMaxTimes = alignedStandardData[[All,-1,1]];

  (* use the end and start times to turn the initialaa nd final fits into actual domains *)
  safeSampleDomains = Map[
    Which[
      MatchQ[initialFitDomain, _?QuantityQ],
      Unitless[{0 Second, initialFitDomain}],

      MatchQ[finalFitDomain, _?QuantityQ],
      Unitless[{# - finalFitDomain, #}],

      True,
      Automatic
    ]&,
    alignedSampleMaxTimes
  ];

  safeStandardDomains = Map[
    Which[
      MatchQ[initialFitDomain, _?QuantityQ],
      Unitless[{0 Second, initialFitDomain}],

      MatchQ[finalFitDomain, _?QuantityQ],
      Unitless[{# - finalFitDomain, #}],

      True,
      Automatic
    ]&,
    alignedStandardMaxTimes
  ];


  (* --------------------------- *)
  (* -- FIT THE DATA/STANDARD -- *)
  (* --------------------------- *)

  (* use the helper to fit the samples *)
  sampleFitPackets = quantitateBLIData[alignedSampleData, fittedParameter, safeSampleDomains];
  validFit = !MemberQ[sampleFitPackets, $Failed];

  bindingFitTest=If[gatherTests,Test["The binding quantitation fitting was successful:",validFit,True],Null];

  allTestsWithFit=DeleteCases[Append[allTests,bindingFitTest],Null];

  (* if the fit cant be done, return failed *)
  If[!validFit,
    If[messages, Message[Error::BindingQuantitationFittingFailed]];
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->allTestsWithFit,
      Options->RemoveHiddenOptions[AnalyzeBindingQuantitation, collapsedResolvedOptions],
      Preview->Null
    }]
  ];

  (* pull out the fit parameters *)
  sampleFitParameters = If[MatchQ[sampleFitPackets, Except[Null]],
    Lookup[sampleFitPackets, Replace[BestFitParameters]],
    {Null}
  ];

  (* pull out the one we want based on what parameter was being fit *)
  {safeSampleFitParameters, safeSampleFitError} = Which[

    (* AverageEquilibriumResponse *)
    MatchQ[fittedParameter, AverageEquilibriumResponse],
    Transpose[Cases[sampleFitParameters, {Req, _, _}, Infinity][[All,2;;3]]],

    (* FitEquilibriumResponse *)
    MatchQ[fittedParameter, FitEquilibriumResponse],
    Transpose[Cases[sampleFitParameters, {Req, _, _}, Infinity][[All,2;;3]]],

    (* FullRate *)
    MatchQ[fittedParameter, FullRate],
    Transpose[Cases[sampleFitParameters, {kobs, _, _}, Infinity][[All,2;;3]]],

    (*InitialRate*)
    MatchQ[fittedParameter, InitialRate],
    Transpose[Cases[sampleFitParameters, {kobs, _, _}, Infinity][[All,2;;3]]]
  ];


  (* use the helper to fit the standards *)
  standardFitPackets = If[MatchQ[alignedStandardData, _List],
    quantitateBLIData[alignedStandardData, fittedParameter, safeStandardDomains],
    Null
  ];

  validStandardFit = !MemberQ[standardFitPackets, $Failed];

  bindingStandardFitTest=If[gatherTests,Test["The binding quantitation fitting of the standard was successful:",validStandardFit,True],Null];

  allTestsWithStandardFit=DeleteCases[Append[allTestsWithFit,bindingStandardFitTest],Null];

  (* if the fit fails *)
  If[!validStandardFit,
    If[messages, Message[Error::BindingQuantitationStandardFitFailed]];
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->allTestsWithStandardFit,
      Options->RemoveHiddenOptions[AnalyzeBindingQuantitation, collapsedResolvedOptions],
      Preview->Null
    }]
  ];

  (* pull out the fit parameters *)
  safeStandardFitParameters = If[MatchQ[standardFitPackets, Except[Null]],
    Lookup[standardFitPackets, Replace[BestFitParameters]],
    {Null}
  ];

  (* ----------------------------- *)
  (* -- GENERATE STANDARD CURVE -- *)
  (* ----------------------------- *)

  (* extract the relevant fit parameter from teh standard Curve *)
  standardCurveFitParameters = Which[

    (* AverageEquilibriumResponse *)
    MatchQ[fittedParameter, AverageEquilibriumResponse],
    Cases[safeStandardFitParameters, {Req, _, _}, Infinity][[All,2]],

    (* FitEquilibriumResponse *)
    MatchQ[fittedParameter, FitEquilibriumResponse],
    Cases[safeStandardFitParameters, {Req, _, _}, Infinity][[All,2]],

    (* FullRate *)
    MatchQ[fittedParameter, FullRate],
    Cases[safeStandardFitParameters, {kobs, _, _}, Infinity][[All,2]],

    (*InitialRate*)
    MatchQ[fittedParameter, InitialRate],
    Cases[safeStandardFitParameters, {kobs, _, _}, Infinity][[All,2]]
  ];


  (*TODO: this is the inverse fitting right now so that the curve does not need to be inverted*)
  (* compose the data set for the standard curve fitting *)
  standardCurvePoints = If[MatchQ[standardCurveFitParameters, Except[Null]],
    Transpose[{safeStandardConcentrations, standardCurveFitParameters}],
    Null
  ];

    (* generate the standard curve equation if there was a fit for the standard curve *)
  standardCurveFitPacket = If[MatchQ[standardCurvePoints, Except[Null]],
    fitBLIQuantitationStandardCurve[standardCurvePoints, standardCurveFit],
    Null
  ];

    (* If there is no std curve (which is possible), we will just return kobs here instead of the concentration *)
  concentrationResult = Quiet[
    If[MatchQ[standardCurveFitPacket, Except[Null]],
    Module[{expressionToFit, variableToSolve, solutions},
      (* pull out the expression and solve it for x *)
      {expressionToFit, variableToSolve} = Lookup[standardCurveFitPacket, {BestFitExpression, Replace[BestFitVariables]}];

      (* then use that to evaluate for each value from the experimental fits  *)
      (*TODO: this is super sketchy to take the first solution here. we may be looking for a different solution*)
      solutions = Flatten[Map[First[(variableToSolve/.Solve[expressionToFit == #&&variableToSolve>0, variableToSolve, Reals])]&,safeSampleFitParameters]];
      concentrationUnits*solutions
    ],
    Null
  ]
  ];


  (*

(* make the standard curve points based on teh std curve fits *)
  standardCurvePoints = If[MatchQ[standardCurveFitParameters, Except[Null]],
    Transpose[{standardCurveFitParameters, safeStandardConcentrations}],
    Null
  ];

  (* generate the standard curve equation if there was a fit for the standard curve *)
  standardCurveFitPacket = If[MatchQ[standardCurvePoints, Except[Null]],
    fitBLIQuantitationStandardCurve[standardCurvePoints, standardCurveFit],
    Null
  ];


  (* -- RETURN RESULTS -- *)

  (* determine the concentration from the standard curve *)

  (* If there is no std curve (which is possible), we will just return kobs here instead of the concentration *)
  (*TODO: can include single prediction error here as well in the future*)
  concentrationResult = Quiet[
    If[MatchQ[standardCurveFitPacket, Except[Null]],
      Module[{expressionToFit, variableToSolve},
        (* pull out the expression and solve it for x *)
        {expressionToFit, variableToSolve} = Lookup[standardCurveFitPacket, {BestFitExpression, Replace[BestFitVariables]}];

        (* then use that to evaluate for each value from the experimental fits  *)
        UnitConvert[concentrationUnits * Map[expressionToFit/.First[variableToSolve]->#&, safeSampleFitParameters], Molar]
      ],
      Null
    ]
  ];
*)
  (* ----------------- *)
  (* -- FILTER DATA -- *)
  (* ----------------- *)

  (*TODO: This data is for use in the preview function and the plotted output, not for fitting*)

  (* filter the sample data *)
  filteredSampleData = filterBLIQuantitationData[alignedSampleData, filterType, filterWidth];

  (* filter the standard data *)
  filteredStandardData = If[MatchQ[alignedStandardData, _List],
    filterBLIQuantitationData[alignedStandardData, filterType, filterWidth],
    Null
  ];

  (* --------------------------- *)
  (* -- BUILD ANALYSIS OBJECT -- *)
  (* --------------------------- *)

  (*if we were fitting rates, return nulls for the response*)
  {rateFit, rateFitError} = If[MatchQ[fittedParameter, (InitialRate|FullRate)],
    {safeSampleFitParameters * (1/Second), safeSampleFitError * (1/Second)},
    Transpose[ConstantArray[{Null,Null}, Length[safeSampleFitParameters]]]
  ];

  (* if we were fitting response, return Nulls for rate *)
  {reqFit, reqFitError} = If[MatchQ[fittedParameter, (AverageEquilibriumResponse|FitEquilibriumResponse)],
    {safeSampleFitParameters * Nanometer, safeSampleFitError * Nanometer},
    Transpose[ConstantArray[{Null,Null}, Length[safeSampleFitParameters]]]
  ];


  (* -- Analysis upload packets -- *)
  (*dont upload if we are just doign tests*)
  standardDataFitAnalysis = If[upload&&MemberQ[output,Result],
    Upload[Cases[standardFitPackets, PacketP[Object[Analysis, Fit]]]],
    ConstantArray[Null, Length[quantitationData]]
  ];
  samplesInFitAnalysis = If[upload&&MemberQ[output,Result],
    ToList[Upload[Cases[sampleFitPackets, PacketP[Object[Analysis, Fit]]]]]/.{}->ConstantArray[Null, Length[quantitationData]],
    ConstantArray[Null, Length[quantitationData]]
  ];
  standardCurveFitAnalysis = If[upload&&MemberQ[output,Result],
    If[MatchQ[standardCurveFitPacket, PacketP[Object[Analysis, Fit]]],
      Upload[standardCurveFitPacket],
      {}
    ],
    standardCurveFitPacket
  ];

  (* Create the Analysis Object packet *)
  analysisObjectFieldPackets = MapThread[
    Function[{reference, sample, analysis, assayData, concResult, rateResult, rateErr, reqResult, reqErr},

    Association[
      {
        Type -> Object[Analysis, BindingQuantitation],
        Append[Reference] -> Link[reference, QuantitationAnalysis],
        ResolvedOptions -> resolvedOptions,
        UnresolvedOptions -> ops,
        Replace[SamplesIn] -> Link[sample],
        Replace[SamplesInFitting] -> Link[analysis],
        Replace[AssayData] -> assayData,
        Replace[SamplesInConcentrations] -> concResult,
        (*Replace[ConcentrationDistributions] -> concDist,*)
        Replace[Rate] -> rateResult,
        Replace[RateError] -> rateErr,
        Replace[EquilibriumResponse] -> reqResult,
        Replace[EquilibriumResponseError] -> reqErr,
        (*these arent mapped since theres only one std curve*)
        (*the standard data may be a list of objects, so need to use the actaul data that we used to make the td curve*)
        Replace[StandardData] -> alignedStandardData,
        Replace[StandardDataFitAnalysis] -> Link[standardDataFitAnalysis],
        Replace[StandardConcentrations] -> safeStandardConcentrations,
        StandardCurveFitAnalysis -> Link[standardCurveFitAnalysis]
      }
  ]
    ],
    {
      Lookup[resolvedOptions, ReferenceObjects],
      Lookup[resolvedOptions, SamplesIn],
      samplesInFitAnalysis,
      quantitationData,
      concentrationResult,
      rateFit,
      rateFitError,
      reqFit,
      reqFitError
    }
  ];


  (* -------------------------- *)
  (* -- GENERATE THE PREVIEW -- *)
  (* -------------------------- *)

  previewRule = If[MemberQ[output, Preview],
    Preview -> TabView[
      {
        "Filtered Data"-> Zoomable[
          EmeraldListLinePlot[
            filteredSampleData,
            FrameLabel -> {"Time [s]", "Biolayer Thickness [nm]"},
            If[
              MatchQ[Lookup[resolvedOptions, SamplesIn], {ObjectP[]..}|ObjectP[]],
              Legend -> ToList[Lookup[resolvedOptions, SamplesIn][ID]],
              Nothing
            ]
          ]
        ],
        "Fit Results"->Zoomable@PlotTable[
          {
            {"Concentration", concentrationResult},
            {"Observed Rate [1/s]", rateFit},
            {"Equilibrium Response [nm]", reqFit}
          },
          Alignment -> Center,
          Title->"Concentration Fit Results"
        ],
        If[MatchQ[sampleFitPackets, Except[Null|{}]],
          Sequence@@MapIndexed[("Sample "<>ToString@@#2<>" Fit" -> Zoomable[PlotObject[#1, FrameLabel -> {"Time [s]", "Biolayer Thickness [nm]"}, PlotRange -> Automatic]])&, ToList[sampleFitPackets]],
          Nothing
        ],
        "StandardCurve" -> Zoomable[
          PlotObject[
            standardCurveFitAnalysis,
            FrameLabel -> {
              "Concentration",
              If[MatchQ[fittedParameter, AverageEquilibriumResponse|FitEquilibriumResponse],
                "Equilibrium Response [nm]",
                "Observed Rate [1/s]"
              ]
            },
            PlotRange -> Automatic
          ]
        ],
        If[MatchQ[standardFitPackets, Except[Null|{}|{Null..}]],
          Sequence@@MapIndexed[("Standard "<>ToString@@#2<>" Fit" -> Zoomable[PlotObject[#1, FrameLabel -> {"Time [s]", "Biolayer Thickness [nm]"}, PlotRange -> Automatic]])&, ToList[standardFitPackets]],
          Nothing
        ]
      },
      Alignment -> Center
    ],
    Preview -> Nothing
  ];


  (* ------------------ *)
  (* -- Options Rule -- *)
  (* ------------------ *)

  optionsRule=Options->If[MemberQ[output,Options],
    RemoveHiddenOptions[AnalyzeBindingQuantitation,resolvedOptions],
    Null
  ];

  (* ---------------- *)
  (* -- Tests Rule -- *)
  (* ---------------- *)

  (* Next, define the Tests Rule *)
  testsRule=Tests->If[MemberQ[output,Tests],
    allTestsWithStandardFit,
    Null
  ];

  (* ----------------- *)
  (* -- Result Rule -- *)
  (* ----------------- *)

  (* First, upload the analysis object packet if upload is True *)
  analysisObjects=If[upload&&MemberQ[output,Result],
    Upload[analysisObjectFieldPackets],
    analysisObjectFieldPackets
  ];

  resultRule=Result->If[MemberQ[output,Result],
    Which[
      (* In the case where upload is True, return the uploaded analysis object *)
      upload,
      analysisObjects,
      (* Otherwise, (Upload is false just return the analysis object packet *)
      True,
      ToList[analysisObjects]
    ],
    Null
  ];

  outputSpecification/.{
    optionsRule,
    resultRule,
    testsRule,
    previewRule
  }
];



(* ::Subsection:: *)
(*AnalyzeBindingQuantitationPreview*)


DefineOptions[AnalyzeBindingQuantitationPreview,
  SharedOptions:>{AnalyzeBindingQuantitation}
];

AnalyzeBindingQuantitationPreview[myData:ObjectP[Object[Data,BioLayerInterferometry]]|{ObjectP[Object[Data,BioLayerInterferometry]]..}|ObjectP[Object[Protocol,BioLayerInterferometry]],myOptions:OptionsPattern[]]:=Module[
  {listedOptions},

  listedOptions=ToList[myOptions];

  AnalyzeBindingQuantitation[myData,ReplaceRule[listedOptions,Output->Preview]]
];



(* ::Subsection:: *)
(*ValidAnalyzeBindingQuantitaitonQ*)


DefineOptions[ValidAnalyzeBindingQuantitationQ,
  Options:>
      {
        VerboseOption,
        OutputFormatOption
      },
  SharedOptions:>{AnalyzeBindingQuantitation}
];

ValidAnalyzeBindingQuantitationQ[myData:ObjectP[Object[Data,BioLayerInterferometry]]|{ObjectP[Object[Data,BioLayerInterferometry]]..}|ObjectP[Object[Protocol,BioLayerInterferometry]],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,preparedOptions,bindingKineticsTests,initialTestDescription,allTests,verbose,outputFormat},

  (* Get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the output option before passing to the core function because it doesn't make sense here *)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (* Return only the tests for AnalyzeBindingQuantitation *)
  bindingKineticsTests=AnalyzeBindingQuantitation[myData,Append[preparedOptions,Output->Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[bindingKineticsTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[
      {initialTest,validObjectBooleans,voqWarnings},

      (* Generate the initial test, which we know will pass if we got this far (hopefully) *)
      initialTest=Test[initialTestDescription,True,True];

      (* Create warnings for invalid objects *)
      validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myData],_String],OutputFormat->Boolean];

      voqWarnings=MapThread[
        Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {DeleteCases[ToList[myData],_String],validObjectBooleans}
      ];

      (* Get all the tests/warnings *)
      Flatten[{initialTest,bindingKineticsTests,voqWarnings}]
    ]
  ];


  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidAnalyzeBindingQuantitationQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidAnalyzeBindingQuantitationQ"]
];








(* ::Subsection:: *)
(*AnalyzeBindingQuantitationOptions*)


DefineOptions[AnalyzeBindingQuantitationOptions,
  SharedOptions :> {AnalyzeBindingQuantitation},
  {
    OptionName -> OutputFormat,
    Default -> Table,
    AllowNull -> False,
    Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
    Description -> "Determines whether the function returns a table or a list of the options."
  }
];

AnalyzeBindingQuantitationOptions[myData:ObjectP[Object[Data,BioLayerInterferometry]]|{ObjectP[Object[Data,BioLayerInterferometry]]..}|ObjectP[Object[Protocol,BioLayerInterferometry]],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* Get only the options for CriticalMicelleConcentration *)
  options=AnalyzeBindingQuantitation[myData,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,AnalyzeBindingQuantitation],
    options
  ]
];






(* ::Subsubsection::Closed:: *)
(* -- resolveAnalyzeBindingQuantitationOptions -- *)

(* ========================= *)
(* == RESOLVE ABQ OPTIONS == *)
(* ========================= *)

DefineOptions[resolveAnalyzeBindingQuantitationOptions,
  Options:>{
    CacheOption,
    HelperOutputOption
  }
];

resolveAnalyzeBindingQuantitationOptions[
  sampleData:{_?QuantityArrayQ..},
  myOptions:{_Rule..},
  ops:OptionsPattern[resolveAnalyzeBindingQuantitationOptions]
]:= Module[
  {
    outputSpecification, output, gatherTests, messages, allInvalidABQOptions, allABQTests,abqOptionsAssociation, cache,
    (* original options *)
    fittedParameter, baselines, initialFitDomain, finalFitDomain, filterType, filterWidth,
    standardData, standardBaselines, standardCurveFit, standardCurveWeight,
    optimizationOptions,samplesIn, referenceObjects, standardConcentrations,
    (* automatic resolved options *)
    resolvedStandardCurveWeight, resolvedStandardCurveFit,
    resolvedInitialFitDomain, resolvedFinalFitDomain, resolvedStandardData,resolvedBaselines, resolvedFilterWidth,
    resolvedStandardBaselines,resolvedStandardConcentrations,
    (* error trackign variables *)
    sampleLength, standardsLength, sampleBaselineData, standardDataValues,
    standardBaselinesData, sampleDataMinMax, standardDataMinMax, standardBaselineDataMinMax, sampleBaselineMinMax,
    conflictingDomainAndParameterOptions,
    (*invalid options*)
    unusedStandardOptions, invalidStandardDataOption, invalidStandardBaselinesOption,
    invalidFilterWidthOption,
    mismatchedSampleBaselineOption,
    mismatchedStandardBaselineOption,
    invalidSampleBaselinesOption,
    missingStandardDataOption,
    invalidDomainOptions,
    invalidStandardDomainOptions,
    conflictingDomainOptions,
    (* invalid option tests *)
    invalidFilterWidthOptionTest,
    unusedStandardOptionsTest,
    invalidStandardDataTest,
    invalidStandardBaselinesTest,
    invalidSampleBaselinesTest,
    mismatchedStandardBaselineTest,
    mismatchedSampleBaselineTest,
    missingStandardDataTest,
    invalidStandardDomainTest,
    invalidDomainTest,
    conflictingDomainTest,
    (* clean up *)
    invalidInputs, resolvedOps, resultRule,testsRule
  },


  (* -- set up cache -- *)
  cache = Lookup[ToList[ops], Cache];

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = !gatherTests;

  (* make an association *)
  abqOptionsAssociation = Association[myOptions];

  (* lookup the options *)
  {
    fittedParameter,
    baselines,
    initialFitDomain,
    finalFitDomain,
    filterType,
    filterWidth,
    standardData,
    standardBaselines,
    standardCurveFit,
    samplesIn,
    referenceObjects,
    standardConcentrations
  }=Lookup[abqOptionsAssociation,
    {
      FittedParameter,
      Baselines,
      InitialFitDomain,
      FinalFitDomain,
      FilterType,
      FilterWidth,
      StandardData,
      StandardBaselines,
      StandardCurveFit,
      SamplesIn,
      ReferenceObjects,
      StandardConcentrations
    }];


  (* ------------------------------- *)
  (* -- CONFLICTING OPTIONS CHECK -- *)
  (* ------------------------------- *)

  (* -- check that the filter type and width are informed together -- *)
  (* gather the bad option *)
  invalidFilterWidthOption = If[MatchQ[filterType, Null]&&MatchQ[filterWidth, Except[Null]],
    {FilterWidth, FilterType},
    {}
  ];

  (* throw the error *)
  If[!MatchQ[invalidFilterWidthOption, {}]&&messages&&Not[MatchQ[$ECLApplication, Engine]],
    Message[Error::UnusedABQFilterWidth, invalidFilterWidthOption]
  ];

  (* make the test for meaningless filter width*)
  invalidFilterWidthOptionTest = If[gatherTests,
    Test["If FilterWidth is specified, FilterType is not None or Null:",
      MatchQ[invalidFilterWidthOption, {}],
      True
    ],
    Null
  ];


  (* ------------------------- *)
  (* -- RESOLVE THE OPTIONS -- *)
  (* ------------------------- *)

  (* note that if we are given objects as option values, we do not download form them here, that is doen in the main function.*)

  (*THE AUTOMATICS ARE:
  Baselines,
  FilterWidth,
  StandardData,
  StandardConcentrations,
  StandardBaselines,
  StandardCurveFit,
  initialFitDomain,
  finalFitDomain
  *)

  (* RESOLVE DATA PROCESSING *)

  (* If FilterType is set, then also set the width *)
  resolvedFilterWidth = If[MatchQ[filterType, Except[(None|Null)]],
    filterWidth/.Automatic->1 Second,
    filterWidth/.Automatic->Null
  ];

  (* If they did not set a baseline we can see if there is one in the data objects in ReferenceObjects*)
  resolvedBaselines = If[MatchQ[referenceObjects, ({}|Null)],

    (* if theres no refernece objects, we have no way of finding a baseline *)
    baselines/.Automatic->Null,

    (* if there are reference objects it means that the user has given a data object of protocol, and thus the reference objects are already index matched. *)
    baselines/.Automatic->referenceObjects
  ];

  (*Check for standard data. If there are multiple reference objects, make sure to only return one of them *)
  resolvedStandardData = If[MatchQ[referenceObjects, ({}|Null)],
    standardData/.Automatic -> Null,
    Module[{removedDuplicatesStandardData},
      removedDuplicatesStandardData = DeleteDuplicatesBy[ToList[referenceObjects], Download[#, QuantitationStandardDetection, Cache -> cache]&];
      standardData/.Automatic->First[removedDuplicatesStandardData]
    ]
  ];

  (* check fot he concentrations *)
  resolvedStandardConcentrations = If[MatchQ[referenceObjects, ({}|Null)],
    standardConcentrations/.Automatic -> Null,
    standardConcentrations/.Automatic -> First[DeleteDuplicatesBy[referenceObjects, Download[#, QuantitationStandardDilutionConcentrations, Cache -> cache]&]]
  ];

  (*if there is a standard and there are refernece objects, do the same thing. Note that there should only be one set of baselines so if delete duplicates returns more than one, error out.*)
  resolvedStandardBaselines =
      If[MatchQ[standardData, (Null|{})],

        (* if there is no data, the baselines should be Null *)
        standardBaselines/.Automatic -> Null,

        (* if there is standard data, we are going to check for reference objects *)
        If[MatchQ[referenceObjects, ({}|Null)],

          (* if theres no refernece objects, we have no way of finding a baseline *)
          standardBaselines/.Automatic->Null,

          (* if there are reference objects, we can look for the baseline data *)
          standardBaselines/.Automatic->referenceObjects
        ]
      ];

  (* Set the FitDomains based on the FittedParameter *)
  (* note that to avoid givign an error form our resolution, we have to avoid setting both, even if it is nonsense *)
  {resolvedInitialFitDomain, resolvedFinalFitDomain} = Which[

    MatchQ[fittedParameter, InitialRate],
    If[MatchQ[finalFitDomain, Except[Null|Automatic]],
      {initialFitDomain/.Automatic -> Null, finalFitDomain/.Automatic -> Null},
      {initialFitDomain/.Automatic -> 40 Second, finalFitDomain/.Automatic -> Null}
    ],

    MatchQ[fittedParameter, AverageEquilibriumResponse],
    If[MatchQ[initialFitDomain, Except[Null|Automatic]],
      {initialFitDomain/.Automatic -> Null, finalFitDomain/.Automatic -> Null},
      {initialFitDomain/.Automatic -> Null, finalFitDomain/.Automatic -> 40 Second}
    ],

    (* any other fit uses the full range *)
    True,
    {initialFitDomain/.Automatic -> Null, finalFitDomain/.Automatic -> Null}
  ];

  (* if there is a standard, also resolve the standard curve fit *)
  resolvedStandardCurveFit = If[MatchQ[resolvedStandardData, Except[Null]],
    standardCurveFit/.Automatic->Linear,
    standardCurveFit/.Automatic -> Null
  ];


  (* ----------------------------- *)
  (* -- CHECK THE STANDARD DATA -- *)
  (* ----------------------------- *)

  (*TODO: change this to resolved standard data since we might have an automatic but no data in the object*)
  (* if there is no sample data, warn when other options are populated *)
  unusedStandardOptions = If[MatchQ[resolvedStandardData, Null],
    PickList[
      {StandardBaselines, StandardCurveFit},
      {resolvedStandardBaselines, standardCurveFit},
      Except[{Null|{}|{Null..}}]
    ],
    {}
  ];


  (* throw the warning *)
  If[!MatchQ[unusedStandardOptions, {}]&&messages,
    Message[Error::UnusedABQStandardOptions, unusedStandardOptions]
  ];

  (*make the test*)
  unusedStandardOptionsTest = If[gatherTests,
    Test["If StandardData is not specified, options related to the standard data are Null or Automatic:",
      MatchQ[unusedStandardOptions, {}],
      True
    ],
    Null
  ];

  (* conflicting domains if both initial and final are set *)
  conflictingDomainOptions = If[MatchQ[resolvedInitialFitDomain, Except[Null]]&&MatchQ[resolvedFinalFitDomain, Except[Null]],
    {InitialFitDomain, FinalFitDomain},
    {}
  ];

  (* throw the warning *)
  If[!MatchQ[conflictingDomainOptions, {}]&&messages,
    Message[Error::ConflictingBindingQuantitationFitDomainOptions, conflictingDomainOptions]
  ];

  (*make the test*)
  conflictingDomainTest = If[gatherTests,
    Test["Only InitialFitDomain or FInalFitDomain are specified:",
      MatchQ[conflictingDomainOptions, {}],
      True
    ],
    Null
  ];

  (* error check that they dont use inital domain with eq response or final domain with initail rate *)
  conflictingDomainAndParameterOptions = Which[

    MatchQ[resolvedInitialFitDomain, Except[Null]]&&MatchQ[fittedParameter, AverageEquilibriumResponse],
    {InitialFitDomain},

    MatchQ[resolvedFinalFitDomain, Except[Null]]&&MatchQ[fittedParameter, InitialRate],
    {FinalFitDomain},

    True,
    {}
  ];

  (* throw the warning *)
  If[MatchQ[conflictingDomainAndParameterOptions, Except[{}]]&&messages&&Not[MatchQ[$ECLApplication,Engine]],
    Message[Warning::BindingQuantitationConflictingDomainAndParameter, conflictingDomainAndParameterOptions]
  ];

  (* ---------------------------------------- *)
  (* -- INVALID/UNRESOLVABLE OPTIONS CHECK -- *)
  (* ---------------------------------------- *)

  (* -- DOWNLOAD THE ACTUAL DATA/BASELINES -- *)


  (* -- if necessary, download and expand the baselines so they match up to the samples -- *)

  (* if we have and object or a list of objects, download the data, replace any empty lists with Nulls *)
  (* otherwise just return the function, constant, Null, or quantityarray(s) *)
  sampleBaselineData = If[MatchQ[resolvedBaselines, {ObjectP[]..}|ObjectP[]],
    Download[resolvedBaselines, QuantitationAnalyteDetectionBaseline, Cache -> cache]/.{}->Null,
    resolvedBaselines
    ];

  (* download the standardDataValues from the cache *)
  standardDataValues = If[MatchQ[resolvedStandardData, {ObjectP[]..}|ObjectP[]],
    Download[ToList[resolvedStandardData], QuantitationStandardDetection, Cache -> cache],
    resolvedStandardData
  ];

  (* download the standardBaselines  *)
  standardBaselinesData = If[MatchQ[resolvedStandardBaselines, {ObjectP[]..}|ObjectP[]],
    Download[ToList[resolvedStandardBaselines], QuantitationStandardDetectionBaselines, Cache -> cache],
    resolvedStandardBaselines
  ];

  (* --------------------------------- *)
  (* -- CHECK VALIDITY OF BASELINES -- *)
  (* --------------------------------- *)

  (* if we have standard data, check that the form is {{_QuantityArrayQ..}} after removing duplicates*)
  invalidStandardDataOption = If[MatchQ[DeleteDuplicates[ToList[standardDataValues]], {{_?QuantityArrayQ..}}|{Null...}|Null|{{}}],
    {},
    {StandardData}
  ];

  (* throw an error for multiple sets of standards *)
  If[MatchQ[invalidStandardDataOption, Except[{}]]&&messages,
    Message[Error::BindingQuantitationMultipleStandardDataSets]
  ];

  (*make the test*)
  invalidStandardDataTest = If[gatherTests,
    Test["Only one set of StandardData is specified:",
      MatchQ[invalidStandardDataOption, {}],
      True
    ],
    Null
  ];

  (* check for missing StandardData *)
  missingStandardDataOption = If[MatchQ[DeleteDuplicates[ToList[standardDataValues]], {{}}],
    {StandardData},
    {}
  ];

  (* throw an error for missing standards *)
  If[MatchQ[missingStandardDataOption, Except[{}]]&&messages,
    Message[Error::BindingQuantitationMissingStandardDataSets]
  ];

  (*make the test*)
  missingStandardDataTest = If[gatherTests,
    Test["StandardData is specified or resolvable:",
      MatchQ[missingStandardDataOption, {}],
      True
    ],
    Null
  ];

  (* -- DETERMINE MIN/MAX VALUES OF DATA/BASELINES -- *)

  (*TODO: this may not handle mixed input well like {QA, Null, QA} for example*)
  (* pull out the min, max values for each element of the data *)
  sampleDataMinMax = Transpose[{sampleData[[All,1,1]], sampleData[[All, - 1, 1]]}];

  (* pull out the min/max values for each element of the data baselines *)
  sampleBaselineMinMax = If[MatchQ[sampleBaselineData, {_?QuantityArrayQ..}|_?QuantityArrayQ|{{_?QuantityQ, _?QuantityQ}..}|{{{_?QuantityQ, _?QuantityQ}..}..}],
    Transpose[{ToList[sampleBaselineData][[All,1,1]], ToList[sampleBaselineData][[All,-1,1]]}],
    {{-100000 Second, 100000 Second}}
  ];

  (* pull out the min, max values for each element of the standard data *)
  standardDataMinMax = If[MatchQ[standardDataValues, {_?QuantityArrayQ..}],
    Transpose[{standardDataValues[[All,1,1]], standardDataValues[[All,-1,1]]}],
    {{100000 Second, -100000 Second}}
  ];

  (* pull out the min, max value for each element of the standard baseline *)
  standardBaselineDataMinMax = If[MatchQ[standardBaselinesData, {_?QuantityArrayQ..}|_?QuantityArrayQ|{{_?QuantityQ, _?QuantityQ}..}|{{{_?QuantityQ, _?QuantityQ}..}..}],
    Transpose[{ToList[standardDataValues][[All,1,1]], ToList[standardDataValues][[All,-1,1]]}],
    {{-100000 Second, 100000 Second}}
  ];


  (* -- VALIDATE THE BASELINE RANGES -- *)

  (*STANDARD BASELINE*)
  (* check that the range of the baseline is equal or greater than that of the standard data *)
  invalidStandardBaselinesOption = Which[

    (* if the lengths match, check that the min of the data is larger than the min of hte baseline, and the max of the data is smaller than the max of the baseline  *)
    MatchQ[Length[standardBaselineDataMinMax], Length[standardDataMinMax]],
    DeleteDuplicates[Flatten[MapThread[
      If[
        Or[
          MatchQ[First[#1], GreaterEqualP[First[#2]]],
          MatchQ[Last[#1], LessEqualP[Last[#2]]]
        ],
        {},
        {StandardBaselines}
      ]&,
      {standardDataMinMax, standardBaselineDataMinMax}
    ]]],

    (* if the standardDataBaseline has a length of 1 *)
    MatchQ[Length[standardBaselineDataMinMax], 1]&&MatchQ[Length[standardDataMinMax], Except[1]],
    DeleteDuplicates[Flatten[Map[
      If[
        Or[
          MatchQ[First[#], GreaterEqualP[standardBaselineDataMinMax[[1,1]]]],
          MatchQ[Last[#], LessEqualP[standardBaselineDataMinMax[[1,2]]]]
        ],
        {},
        {StandardBaselines}
      ]&,
      standardDataMinMax
    ]]],

    (* in every other case, we are throwing a different error for a mismatch, so we dont need to error for this *)
    True,
    {}

  ];

  (* throw an error for bad standard baseline *)
  If[MatchQ[invalidStandardBaselinesOption, Except[{}]]&&messages,
    Message[Error::BindingQuantitationInvalidStandardBaselineRange]
  ];

  (* make the test *)
  invalidStandardBaselinesTest = If[gatherTests,
    Test["All standard baselines have a domain greater than or equal to the full range of the sample data they are used for:",
      MatchQ[invalidStandardBaselinesOption, {}],
      True
    ],
    Null
  ];

  (*SAMPLE BASELINE*)
  (* check that the range of the baseline is equal or greater than that of the data *)
  invalidSampleBaselinesOption = Which[

    (* if the lengths match, check that the min of the data is larger than the min of hte baseline, and the max of the data is smaller than the max of the baseline  *)
    MatchQ[Length[sampleBaselineMinMax], Length[sampleDataMinMax]],
    DeleteDuplicates[Flatten[MapThread[
      If[
        And[
          MatchQ[First[#1], GreaterEqualP[First[#2]]],
          MatchQ[Last[#1], LessEqualP[Last[#2]]]
        ],
        {},
        {Baselines}
      ]&,
      {sampleDataMinMax, sampleBaselineMinMax}
    ]]],

    (* if the baseline has a length of 1 *)
    MatchQ[Length[sampleBaselineMinMax], 1]&&MatchQ[Length[sampleDataMinMax], Except[1]],
    DeleteDuplicates[Flatten[Map[
      If[
        And[
          MatchQ[First[#], GreaterEqualP[sampleBaselineMinMax[[1,1]]]],
          MatchQ[Last[#], LessEqualP[sampleBaselineMinMax[[1,2]]]]
        ],
        {},
        {Baselines}
      ]&,
      sampleDataMinMax
    ]]],

    (* in every other case, we are throwing a different error for a mismatch, so we dont need to error for this *)
    True,
    {}
  ];


  (* throw the error *)
  If[!MatchQ[invalidSampleBaselinesOption, {}]&&messages,
    Message[Error::BindingQuantitationInvalidBaselineRange]
  ];

  (* make the test*)
  invalidSampleBaselinesTest = If[gatherTests,
    Test["All sample baselines have a domain greater than or equal to the full range of the sample data they are used for:",
      MatchQ[invalidSampleBaselinesOption, {}],
      True
    ],
    Null
  ];

  (* -- CHECK THE INDEX MATCHING -- *)
  (* there needs to be some semi manual index matching here *)

  (* check if there is something ambiguous like 2 baselines and 3 samples - 1 is ok since there may be one baseline for all *)
  mismatchedStandardBaselineOption = If[
    And[
      !MatchQ[Length[standardBaselineDataMinMax], Length[standardDataMinMax]],
      !MatchQ[Length[standardBaselineDataMinMax], 1]
    ],
    {StandardBaselines},
    {}
  ];

  (* throw the error for mismatched number of baselines *)
  If[!MatchQ[mismatchedStandardBaselineOption, {}]&&messages,
    Message[Error::BindingQuantitationAmbiguousStandardBaseline]
  ];

  (* make the test *)
  mismatchedStandardBaselineTest = If[gatherTests,
    Test["If multiple baselines are provided, the number of baselines matches the number of standard curve measurements:",
      MatchQ[mismatchedStandardBaselineOption, {}],
      True
    ],
    Null
  ];


  mismatchedSampleBaselineOption = If[
    And[
      !MatchQ[Length[sampleBaselineMinMax], Length[sampleDataMinMax]],
      !MatchQ[Length[sampleBaselineMinMax], 1]
    ],
    {Baselines},
    {}
  ];

  (* throw the error for mismatched number of baselines *)
  If[!MatchQ[mismatchedSampleBaselineOption, {}]&&messages,
    Message[Error::BindingQuantitationAmbiguousBaseline]
  ];

  (* make the test*)
  mismatchedSampleBaselineTest = If[gatherTests,
    Test["If multiple baselines are provided, the number of baselines matches the number of measurements:",
      MatchQ[mismatchedSampleBaselineOption, {}],
      True
    ],
    Null
  ];

  (* -- standard length -- *)



  (* ------------------ *)
  (* -- GATHER TESTS -- *)
  (* ------------------ *)

  allABQTests = Cases[
    Flatten[
      {
        invalidFilterWidthOptionTest,
        unusedStandardOptionsTest,
        invalidStandardDataTest,
        invalidStandardBaselinesTest,
        invalidSampleBaselinesTest,
        mismatchedStandardBaselineTest,
        mismatchedSampleBaselineTest,
        missingStandardDataTest,
        conflictingDomainTest
      }
    ],
    _EmeraldTest
  ];

  (* ---------------------------- *)
  (* -- GATHER INVALID OPTIONS -- *)
  (* ---------------------------- *)

  (* gather all the invalid or conflicting options which have caused an error *)
  allInvalidABQOptions = DeleteDuplicates[
    Flatten[
      {
        unusedStandardOptions,
        invalidStandardDataOption,
        invalidStandardBaselinesOption,
        invalidFilterWidthOption,
        mismatchedSampleBaselineOption,
        mismatchedStandardBaselineOption,
        invalidSampleBaselinesOption,
        missingStandardDataOption,
        conflictingDomainOptions
      }
    ]
  ];

  (* Define the Invalid Options *)
  invalidInputs=DeleteDuplicates[Flatten[
    {}
  ]];

  (*Throw Error::InvalidInput if there are invalid options*)
  If[Length[invalidInputs]>0&&messages,
    Message[Error::InvalidInput,invalidInputs]
  ];


  (*Throw Error::InvalidOption if there are invalid options*)
  If[Length[allInvalidABQOptions]>0&&messages,
    Message[Error::InvalidOption,allInvalidABQOptions]
  ];

  (* --------------------------------- *)
  (* -- RETURN THE RESOLVED OPTIONS -- *)
  (* --------------------------------- *)

  resolvedOps = ReplaceRule[myOptions,
    {
      Baselines -> resolvedBaselines,
      FilterWidth -> resolvedFilterWidth,
      StandardData -> resolvedStandardData,
      InitialFitDomain -> resolvedInitialFitDomain,
      FinalFitDomain -> resolvedFinalFitDomain,
      StandardBaselines -> resolvedStandardBaselines,
      StandardCurveFit -> resolvedStandardCurveFit,
      StandardConcentrations -> resolvedStandardConcentrations
    }
  ];

  (*Generate the result output rule: if not returning result, result rule is just Null*)
  resultRule=Result->If[MemberQ[output,Result],
    resolvedOps,
    Null
  ];

  (*Generate the tests output rule*)
  testsRule=Tests->If[gatherTests,
    allABQTests,
    Null
  ];


  (*Return the output as we desire it*)
  outputSpecification/.{resultRule,testsRule}
];








(* ::Subsubsection::Closed:: *)
(* -- baselineBLIData -- *)

(* ======================= *)
(* == Baseline BLI Data == *)
(* ======================= *)

(* subtract the baseline data from the actual data *)
(* listable so that a single baseline can be applied to multiple data sets *)
(* checks for mismatch in length *)


(* -- SINGLE OVERLOAD -- *)
baselineBLIQuantitationData[singleDataSet:_?QuantityArrayQ, baseline:_?QuantityArrayQ, filterFlag_] := baselineBLIQuantitationData[ToList[singleDataSet], baseline, True];

(* -- NULL BASELINE OVERLOAD -- *)
baselineBLIQuantitationData[singleDataSet:_?QuantityArrayQ, Null, filterFlag_] :={singleDataSet};
baselineBLIQuantitationData[dataSets:{_?QuantityArrayQ..}, Null, filterFlag_]:={dataSets};
baselineBLIQuantitationData[dataSets:{_?QuantityArrayQ..}, {Null..}, filterFlag_]:={dataSets};
baselineBLIQuantitationData[Null, baseline_, filterFlag_]:=Null;

(* -- SINGLE CONSTANT OVERLOAD -- *)
baselineBLIQuantitationData[singleDataSet:_?QuantityArrayQ, constant:_?QuantityQ, filterFlag_]:=baselineBLIQuantitationData[ToList[singleDataSet], constant, False];
baselineBLIQuantitationData[dataSets:{_?QuantityArrayQ..}, constant:_?QuantityQ, filterFlag_]:=Module[
  {dataLengths, dataXVals, dataXUnits, baselineUnits, baselineResponseValues, unitlessBaseline, baselineWithUnits},

  (* determine the units *)
  dataXUnits = QuantityUnit[dataSets[[All, 1, 1]]];

  (* pull the unitless x values out *)
  dataXVals = Unitless[dataSets][[All,All,1]];

  (* data length *)
  dataLengths = Length/@dataXVals;

  (* baseline units *)
  baselineUnits = QuantityUnit[constant];

  (* baseline response values *)
  baselineResponseValues = Map[ConstantArray[Unitless[constant], #]&, dataLengths];

  (* construct baseline quantity arrays *)
  unitlessBaseline = MapThread[Transpose[{#1, #2}]&,{dataXVals, baselineResponseValues}];

  (* add the units back in and create quantity arrays to pass to the core function *)
  baselineWithUnits = MapThread[QuantityArray[#1, {#2, baselineUnits}]&, {unitlessBaseline, dataXUnits}];

  (* If the baselines are all the same, just pass it in as normal, otherwise map it over the core function *)
  If[MatchQ[Length[DeleteDuplicates[baselineWithUnits]], 1],
    baselineBLIQuantitationData[dataSets, baselineWithUnits[[1]], False],
    MapThread[baselineBLIQuantitationData[#1, #2, False]&,{dataSets, baselineWithUnits}]
  ]
];

(* -- FUNCTION OVERLOAD -- *)
(* TODO: this overload bugs out when given a function with units. It shoudl be upgraded at some point though I dont anticipate it will get a lot of use. *)
baselineBLIQuantitationData[singleDataSet:_?QuantityArrayQ, function_Function, filterFlag_]:=baselineBLIQuantitationData[ToList[singleDataSet], function, False];
baselineBLIQuantitationData[dataSets:{_?QuantityArrayQ..}, function_Function, filterFlag_]:=Module[
  {dataLengths, dataXVals, dataXUnits, dataYUnits, baselineResponseValues, unitlessBaseline, baselineWithUnits},

  (* determine the units *)
  dataXUnits = QuantityUnit[dataSets[[All, 1, 1]]];
  dataYUnits = QuantityUnit[dataSets[[All,1,2]]];

  (* pull the unitless x values out *)
  dataXVals = Unitless[dataSets][[All,All,1]];

  (* data length *)
  dataLengths = Length/@dataXVals;

  (* baseline response values *)
  baselineResponseValues = Map[function[#]&,dataXVals];

  (* construct baseline quantity arrays *)
  unitlessBaseline = MapThread[Transpose[{#1, #2}]&,{dataXVals, baselineResponseValues}];

  (* add the units back in and create quantity arrays to pass to the core function *)
  baselineWithUnits = MapThread[QuantityArray[#1, {#2, #3}]&, {unitlessBaseline, dataXUnits, dataYUnits}];

  (* If the baselines are all the same, just pass it in as normal, otherwise map it over the core function *)
  If[MatchQ[Length[DeleteDuplicates[baselineWithUnits]], 1],
    baselineBLIQuantitationData[dataSets, baselineWithUnits[[1]], False],
    MapThread[baselineBLIQuantitationData[#1, #2, False]&,{dataSets, baselineWithUnits}]
  ]
];


(* -- CORE FUNCTION -- *)
baselineBLIQuantitationData[dataSets:{_?QuantityArrayQ..},baseline:_?QuantityArrayQ, filterFlag_]:=Module[
  {baselineUnits, dataUnits,workingUnits,
    sampleUnitlessData, baselineUnitlessData,
    baselineTimeData, sampleTimeDataInput, baselineResponseData, sampleResponseDataInput,
    baselineStartEndPositions, trimmedBaselineResponsePerSample, correctedResponseValues,
    unitlessCorrectedData, correctedQuantityArrays
  },

  (* -- prepare arrays for processing -- *)
  (* determine the baseline units. If there are multiple units then return Failed. *)
  baselineUnits = DeleteDuplicates[QuantityUnit[baseline]];

  (* if there is a problem with the baseline units, return the data set since we cant do anything with it. *)
  If[MatchQ[Length[baselineUnits], (0|GreaterP[1])],
    Message[Error::BadBLIBaselineUnits, baselineUnits];
    Return[dataSets]
  ];

  (* if the units are safe, then we will set these as the default units for the rest of the manipulations *)
  workingUnits = Flatten[baselineUnits];

  (* determine the data units - note that QuantityUnit is listable *)
  dataUnits = DeleteDuplicates/@QuantityUnit[dataSets];

  (* if any of the data sets have mixed units or have no units, throw an error and return *)
  If[!MatchQ[Select[dataUnits, MatchQ[Length[#], (0|GreaterP[1])]&], {}],
    Message[Error::BadBLIDataUnits, dataUnits];
    Return[dataSets]
  ];

  (* pull out the unitless data to work with more quickly *)
  baselineUnitlessData = QuantityMagnitude[baseline];

  (* convert the data to the correct units during the magnitude lookup. Here we need to map becasue QuantityMagnitude can handle multiple units at once.*)
  sampleUnitlessData = QuantityMagnitude[#, workingUnits]&/@dataSets;

  (* split into x and y data *)
  baselineTimeData = baselineUnitlessData[[All, 1]];
  sampleTimeDataInput = sampleUnitlessData[[All,All,1]];
  (* if we are usign raw data, now is the tiem to apply a filter - important to prevent introducing extra noise. This filter is pretty agressive but its fine since its just a baseline *)
  baselineResponseData = If[MatchQ[filterFlag, True],
    MeanFilter[baselineUnitlessData[[All, 2]], 10],
    baselineUnitlessData[[All, 2]]
  ];
  sampleResponseDataInput = sampleUnitlessData[[All,All,2]];

  (* check that the x data aligns and that the baseline data is at least as long as the sample data *)
  If[!And@@Map[SubSetQ[baselineTimeData, #]&, sampleTimeDataInput],
    Message[Error::InsufficientBLIBaseline];
    (* if the baseline is too short or doesn't match we will return the data *)
    Return[dataSets]
  ];

  (* TODO: This was a clever way to do this except it breaks if any of the time values are different. Instead find the baseliens another way. *)
  (* if the baseline given is longer than the data, we will determine which position of the baseline need to be used for each data set *)
  (* this will return the start and end position of the data x values in the baseline x value *)
  (* baselineStartEndPositions = SequencePosition[baselineTimeData, #]&/@sampleTimeDataInput;

  (* note that sequence position comes out one level more nested than we would like *)
  (* we can grab the corresponding baseline response values for the given time range *)
   trimmedBaselineResponsePerSample = Module[{startAndEndPositions, partsToTake},

    (* gives {{start, end},{start, end}..} *)
    startAndEndPositions = Flatten[#,1]&/@baselineStartEndPositions;

    (* parts to take from range and take those parts of the baseline response data *)
    partsToTake = Part[baselineResponseData, Range[Sequence@@#]]&/@startAndEndPositions
  ];*)

  (* with the correct part of the baseline and the correct units, we can now do our baseline subtraction *)
  (* note that for BLI, we dont really care the absolute values of the baselien or data sicne it will be aligned later *)
  (* we just care that systematic drift and noise are subtracted out *)

  (* constant array to account for there possibly beign multiple samples *)
  correctedResponseValues = MapThread[
    Subtract[#1,#2[[;;Length[#1]]]]&,
    {sampleResponseDataInput, ConstantArray[baselineResponseData, Length[sampleResponseDataInput]]}
  ];

  (* reassemble the time and response data *)
  unitlessCorrectedData = MapThread[Transpose[{#1,#2}]&,{sampleTimeDataInput, correctedResponseValues}];

  (* add the units back in and pass the quantity array back into the main function *)
  correctedQuantityArrays = QuantityArray[#, workingUnits]&/@unitlessCorrectedData
];


(* ::Subsubsection::Closed:: *)
(* -- filterBLIData -- *)

(* ===================== *)
(* == Filter BLI Data == *)
(* ===================== *)

(* a function that filters BLI data using the indicated mecahnism:
 Easy to implement: MeanFilter, MovingAverage, ExponentialMovingAverage - note the last two change then number of data points..
 More Difficult: SavitskyGolay LowPass*)

(* -- SINGLE DATA OVERLOAD -- *)
filterBLIQuantitationData[
  singleDataSet:_?QuantityArrayQ,
  filterType_,
  filterWidth:_?QuantityQ
]:= filterBLIQuantitationData[
  ToList[singleDataSet],
  filterType,
  filterWidth
];

(* -- CORE FUNCTION -- *)
filterBLIQuantitationData[dataSets:{_?QuantityArrayQ..}, filterType_,filterWidth:_?QuantityQ]:=Module[
  {unitlessData, unitlessResponseData, unitlessTimeData, dataUnits,
    dataTimeInterval, dataProcessingMethod, meanFilterRange, meanFilterRangeInteger,
    filteredResponseData, filteredData
  },

  (* break up the quantity array for faster manipulations *)
  unitlessData = QuantityMagnitude[dataSets];
  unitlessResponseData = unitlessData[[All,All,2]];
  unitlessTimeData = unitlessData[[All,All,1]];
  dataUnits = QuantityUnit[dataSets][[All,1]];

  (* get the time increment to convert times into number of points *)
  dataTimeInterval = Subtract@@Reverse[First[unitlessTimeData][[1;;2]]]*dataUnits[[1,1]];

  (* TODO: insert options related to data processing method here - for now this is hard coded*)
  (* look up the desired filter method *)
  dataProcessingMethod = filterType;

  (* this is the number of points that the filtering is done over, higher is smoother but also more likely to distort the data *)
  meanFilterRange = filterWidth;

  (* determine the number of points per mean Filter Range (round to the nearest integer). This should never come up, but if for some reason a samplign rate of over one second arises, do not let it go to 0. *)
  meanFilterRangeInteger = Unitless[SafeRound[(meanFilterRange/.{Null -> 1})/dataTimeInterval, 1, AvoidZero -> True]];

  (* do the filtering based on the given parameters *)
  filteredResponseData = Which[
    (* if mean filter is chosen, do the filtering with the given points *)
    MatchQ[dataProcessingMethod, MeanFilter],
    MeanFilter[#, meanFilterRangeInteger]&/@unitlessResponseData,

    (* if gaussian filter is chosen, do the filtering with the given points *)
    MatchQ[dataProcessingMethod, GaussianFilter],
    MeanFilter[#, meanFilterRangeInteger]&/@unitlessResponseData,

    (* if for some reason we dont have a valid filter type then just return the response data *)
    True,
    unitlessResponseData
  ];

  (* If we allow movign averages, this will need to be a which statement since they require different processing to recompse the data *)
  filteredData = MapThread[Transpose[{#1,#2}]&,{unitlessTimeData, filteredResponseData}];

  (* return the filtered data *)
  MapThread[QuantityArray[#1, #2]&,{filteredData, dataUnits}]
];



(* ::Subsubsection::Closed:: *)
(* -- trimBLIData -- *)

(* =================== *)
(* == Trim BLI Data == *)
(* =================== *)

(* trim bad parts of association or dissociation data to exclude them from analysis. This should only be done in cases where obvious instrument articats exist*)
(* for example, switching buffer suddenly may cause a discontinuity at the beginning of an association or dissociation step *)
(* trimming small sections is unlikely to impact the analysis, but fitting bad untrimmed sections can give misleading results *)

(*TODO: make sure to replate Nulls with 0 before passing in*)

(* -- SINGLE DATA OVERLOAD -- *)
trimBLIQuantitationData[singleDataSet:_?QuantityArrayQ, trimStart:_?QuantityQ, trimEnd:_?QuantityQ]:=trimBLIQuantitationData[ToList[singleDataSet], ToList[trimStart], ToList[trimEnd]];

(* -- CORE FUNCTION -- *)
trimBLIQuantitationData[dataSets:{_?QuantityArrayQ..}, trimStart:{_?QuantityQ..}, trimEnd:{_?QuantityQ..}]:=Module[
  {unitlessData, unitlessResponseData, unitlessTimeData, dataUnits, dataTimeInterval, startPointsToTrim,
    endPointsToTrim, trimmedUnitlessData},

  (* break up the quantity array for faster manipulations *)
  unitlessData = QuantityMagnitude[dataSets];
  unitlessResponseData = unitlessData[[All,All,2]];
  unitlessTimeData = unitlessData[[All,All,1]];
  dataUnits = QuantityUnit[dataSets][[All,1]];

  (* get the time increment to convert times into number of points *)
  dataTimeInterval = Subtract@@Reverse[First[unitlessTimeData][[1;;2]]]*dataUnits[[1,1]];

  (* convert trim times to number of data points and convert 0 to 1 since we will use part later *)
  startPointsToTrim = Unitless[(Round[Divide[trimStart, dataTimeInterval],1]/.{0->1})];
  endPointsToTrim = Unitless[(Round[Divide[trimEnd, dataTimeInterval],1]/.{0->1})];

  (* trim this number of points off of each unitless array *)
  trimmedUnitlessData = MapThread[#1[[#2;;-#3]]&,{unitlessData, startPointsToTrim, endPointsToTrim}];

  (* return the quantity array *)
  MapThread[QuantityArray[#1,#2]&,{trimmedUnitlessData, dataUnits}]
];


(* ::Subsubsection::Closed:: *)
(* -- alignBLIData -- *)

(* ==================== *)
(* == Align BLI Data == *)
(* ==================== *)

(* a function to align all of the data sets such that they start at response = 0 and time = 0. *)
(* it uses the average of the first 5 points to find the 0 such that a single bad data point cant mess up alignment. *)
(* this function is ONLY  for quantitation - do not use for kinetics since the time shouldnt be aligned like this *)

(* -- SINGLE DATA OVERLOAD -- *)
alignBLIData[
  singleDataSet:_?QuantityArrayQ,
  targetInitialResponse:_?QuantityQ,
  targetInitialTime:_?QuantityQ
]:=alignBLIData[
  ToList[singleDataSet],
  ToList[targetInitialResponse],
  ToList[targetInitialTime]
];

(* -- MAPPED OVERLOAD -- *)

alignBLIData[
  dataSets:{_?QuantityArrayQ..},
  targetInitialResponse:_?QuantityQ,
  targetInitialTime:_?QuantityQ
]:=alignBLIQuantitationData[
  dataSets,
  ConstantArray[targetInitialResponse, Length[dataSets]],
  ConstantArray[targetInitialTime, Length[dataSets]]
];

(* -- CORE FUNCTION -- *)
alignBLIData[
  dataSets:{_?QuantityArrayQ..},
  targetInitialResponse:{_?QuantityQ..},
  targetInitialTime:{_?QuantityQ..}
]:=Module[
  {
    unitlessData, unitlessResponseData, unitlessTimeData, dataUnits, timeUnits,
    safeTargetInitialResponse, safeTargetInitialTime,
    actualInitialResponse, correctionFactors, timeCorrectionFactors,
    alignedResponseValues, alignedTimeValues, alignedUnitlessData
  },

  (* if the dimensions are not right, return the data and an error *)
  If[!MatchQ[Length[dataSets], Length[targetInitialResponse]],
    Message[Error::AlignBLITargetMismatch];
    Return[dataSets]
  ];

  (* break up the quantity array for faster manipulations *)
  unitlessData = QuantityMagnitude[dataSets];
  unitlessResponseData = unitlessData[[All,All,2]];
  unitlessTimeData = unitlessData[[All,All,1]];
  dataUnits = QuantityUnit[dataSets][[All,2]];
  timeUnits = QuantityUnit[dataSets][[All,1]];


  (* -- ALIGN THE RESPONSE -- *)

  (* convert the initial response value to match the units of the data *)
  safeTargetInitialResponse = MapThread[Unitless[UnitConvert[#1, #2]]&, {targetInitialResponse, dataUnits[[All, 2]]}];

  (* now determine the actual response - not that the units are matched above so we can work unitless safely *)
  actualInitialResponse = Map[Mean[#[[;;10]]]&,unitlessResponseData];

  (* calculate the correction factor - these are index matched so there wont be any problem here*)
  correctionFactors = Subtract[actualInitialResponse, safeTargetInitialResponse];

  (* do the correction *)
  alignedResponseValues = MapThread[Subtract[#1, #2]&,{unitlessResponseData, correctionFactors}];

  (* -- ALIGN THE TIME -- *)

  (* make sure the units match *)
  safeTargetInitialTime = MapThread[Unitless[UnitConvert[#1, #2]]&, {targetInitialTime, timeUnits[[All,1]]}];

  (* determine the correction factor *)
  timeCorrectionFactors = Subtract[unitlessTimeData[[All, 1]], safeTargetInitialTime];

  (* determinet the alignment *)
  alignedTimeValues = MapThread[Subtract[#1,#2]&, {unitlessTimeData, timeCorrectionFactors}];

  (* -- RECONSTRUCT THE OUTPUT -- *)

  (* reconstruct the unitless data *)
  alignedUnitlessData = MapThread[Transpose[{#1,#2}]&, {alignedTimeValues, alignedResponseValues}];

  (* return the quantity array *)
  MapThread[QuantityArray[#1,#2]&,{alignedUnitlessData, dataUnits}]
];




(* ::Subsubsection::Closed:: *)
(* -- fitBLIQuantitation -- *)

(* ======================== *)
(* == fitBLIQuantitation == *)
(* ======================== *)

(* quantitation data can be fit using the initial slope (linear fit), the observed rate (fit kobs), or the equilibrium response *)
(* the fitting models will vary depending on the given option *)
(* TODO: pass in only the data that we want to fit. Need to take care of this in the resolver, adn also do the checks for a linear region *)

quantitateBLIData[data:{_?QuantityArrayQ..}, fitType_, domains_]:=Module[
  {
    model, fitPackets
  },

  (* we aligned the data but still need to specify a domain *)

  (* ------------------ *)
  (* -- FIT THE DATA -- *)
  (* ------------------ *)

  (* determine the fit based on what we are fitting *)
  fitPackets = Quiet[Which[

    (* -- Initial rate -- *)
    MatchQ[fitType, InitialRate],
    MapThread[
      Function[
        {dataSet, domain},
        AnalyzeFit[Unitless[dataSet], kobs*#&, Domain -> Unitless[domain], Upload -> False]],
      {data, domains}
    ],

    (* -- observed rate or Req -- *)
    MatchQ[fitType, (FullRate|FitEquilibriumResponse)],
    MapThread[
      Function[
        {dataSet, domain},
        AnalyzeFit[Unitless[dataSet], Req*(1-Exp[-kobs*#])&, Domain -> domain, Upload -> False]],
      {data, domains}
    ],

    (* -- Req from averaging a specified region -- *)
    MatchQ[fitType, AverageEquilibriumResponse],
    MapThread[
      Function[{dataSet, domain},
        Module[{dataToAverage},

          (*select teh data to average, if the domain is for soem reason All, use all the data*)
          dataToAverage = If[MatchQ[domain, {_?QuantityQ, _?QuantityQ}],
            Select[Unitless[dataSet], MatchQ[First[#], RangeP[Sequence@@domain]]& ][[All, 2]],
            Unitless[dataSet][[All,2]]
          ];

          (* average the data and generate a packet*)
          <|Replace[BestFitParameters] -> {Req, Mean[dataToAverage], StandardDeviation[dataToAverage]}|>
      ]
      ],
      {data, domains}
    ]

  ]]
];




(* ::Subsubsection::Closed:: *)
(* -- fitBLIStandardCurve -- *)

(* ======================== *)
(* == fitBLIStandardCurve == *)
(* ======================== *)

(* standard curve can be fit using a weighted or unweighted 4 ro 5 parameter fit, or a linear fit if needed  *)
(* the fitting models will vary depending on the given option *)

fitBLIQuantitationStandardCurve[standardCurveData_List, fitType_]:=Module[
  {safeConcentrations, concUnits, data, weights, fitPackets},

  (*TODO: need to figur eout how to implement weighting in the standard curve fit*)
  (* look up the weighting. Note that this is just in the form Weight -> (1/#2&) or 1/(#2^2)& where #2 is the response value. You can weight x also using # *)

  (* fit the data based on the requested fit type *)
  fitPackets = Which[
    MatchQ[fitType, Linear],
    AnalyzeFit[standardCurveData, Linear, Upload->False],

    MatchQ[fitType, Sigmoid],
    AnalyzeFit[standardCurveData, Sigmoid, Upload->False],

    MatchQ[fitType, LogisticFourParameter],
    AnalyzeFit[standardCurveData, p4 + (p1 - p4)/(1 + ((#/p3)^p2))&, Upload->False],

    MatchQ[fitType, LogisticFiveParameter],
    AnalyzeFit[standardCurveData, p4 + (p1 - p4)/((1 + (#/p3)^p2)^p5)&, Upload->False],

    MatchQ[fitType, PolynomialOrder2],
    AnalyzeFit[standardCurveData, Polynomial, PolynomialDegree -> 2, Upload->False],

    MatchQ[fitType, PolynomialOrder3],
    AnalyzeFit[standardCurveData, Polynomial, PolynomialDegree -> 3, Upload->False],

    True,
    AnalyzeFit[standardCurveData, fitType, Upload -> False]
  ]
];
