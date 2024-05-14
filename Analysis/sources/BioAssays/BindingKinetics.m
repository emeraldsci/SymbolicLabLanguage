(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeBindingKinetics*)


(* ::Subsubsection:: *)
(*AnalyzeBindingKinetics*)


DefineOptions[AnalyzeBindingKinetics,
  Options :> {

    (* the sample concentrations - index matched to the QuantityArrays in the association and dissociation data*)
    {
      OptionName -> AnalyteDilutions,
      Default -> Automatic,
      Description -> "Specifies the concentration of the analyte in each of member of the dilution series.",
      ResolutionDescription -> "If the input is a data object or protocol, these values will populate automatically from the KineticsDilutions field. Mass concentrations will be automatically converted to molarity.",
      AllowNull -> True,
      Category -> "General",
      Widget ->
          Adder[
            Widget[
              Type -> Quantity,
              Pattern:>GreaterEqualP[0 Molar],
              Units -> Alternatives[Molar, Micro Molar, Nano Molar, Milli Molar]
            ]
          ]
    },

    (* -- How to do the fitting -- *)
    {
      OptionName -> FitModel,
      Default -> OneToOne,
      AllowNull -> False,
      Description -> "Specifies the model that is best suited for fitting the collected data. The OneToOne model should be selected unless it is known that the analyte/ligand interaction follows another mechanism. OneToOne: A single analyte binds to a single surface bound species at exactly one site. MassTransport: The OneToOne model with a mass transport correction that accounts for the analytes ability to access the surface bound ligand. HeterogeneousLigand: Analyte binding occurs at two distinct sites on the same ligand. BivalentAnalyte: Analyte forms bridged ligand-analyte-ligand complexes.",
      Widget->Widget[Type->Enumeration, Pattern:>Alternatives[OneToOne, HeterogeneousLigand, BivalentAnalyte, MassTransport]],
      Category -> "Method Options"
    },
    {
      OptionName -> SimultaneousFit,
      Default -> True,
      AllowNull -> False,
      Description -> "Specifies if curve fitting should be performed on all data simultaneously or individually for each association/dissociation data set. The results of the individual fits are averaged to yield a single fitted parameter. In general the simultaneous fit is more accurate, but setting this to false may be helpful in determining if a particular data set is heavily skewing the parameter fitting.",
      Widget -> Widget[Type -> Enumeration, Pattern :>BooleanP],
      Category -> "Data Processing"
    },
    {
      OptionName -> OptimizationType,
      Default -> Global,
      Description -> "Specifies whether to use global or local optimization to solve for rates. In general, a Global solution will give the most accurate result, although if the rates can be guessed with high confidence, Local may result in a faster fitting.",
      AllowNull -> False,
      Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Global,Local]],
      Category -> "Data Processing"
    },
    {
      OptionName -> LinkMaxResponse,
      Default -> False,
      Description ->"During fitting, each probe will be assigned the same maximum response value. Note that probes are rarely identical, and that this option can only be set to True when OptimizationMethod is Global.",
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern:>BooleanP],
      Category -> "Data Processing"
    },
    {
      OptionName -> CompletelyReversibleBinding,
      Default -> Automatic,
      AllowNull -> True,
      Description -> "Fit the dissociation curves with the assumption that the response will return to the pre-association level. If a binding event is not fully reversible, set this option to False to improve the fit accuracy.",
      ResolutionDescription -> "If dissociation data is found, the binding is assumed to be fully reversible.",
      Category -> "Data Processing",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern:>BooleanP
      ]
    },
    {
      OptionName -> OptimizationOptions,
      Default -> {AccuracyGoal -> 6, PrecisionGoal -> 6},
      Description -> "Additional options to pass to the optimization function. Any option for NMinimize or FindMinimum can be used.",
      AllowNull -> False,
      Category -> "Data Processing",
      Widget -> Widget[Type->Expression, Pattern:>{___Rule}, Size->Line]
    },

    (* -- pre fit processing -- *)
    {
      OptionName -> ExcludeDilution,
      Default -> Null,
      Description -> "Specifies data that should be excluded from fitting either by the concentration of the analyte or exclude data that does not reach a specified threshold.",
      AllowNull -> True,
      Widget -> Alternatives[
        "Data Index" -> Adder[Widget[Type -> Number, Pattern:>GreaterEqualP[1,1]]],
        "Minimum Response" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Nanometer], Units -> Nanometer]
      ],
      Category -> "Data Processing"
    },
    {
      OptionName -> AssociationFitDomain,
      Default -> All,
      Description -> "Specifies the time range of association data points which will be included during fitting.",
      AllowNull -> False,
      Widget -> Alternatives[
        Adder[
          {
            "Min" -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Second], Units->Alternatives[Second,Minute,Hour]],
            "Max" -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Second], Units->Alternatives[Second,Minute,Hour]]
          }
        ],
        Widget[Type->Enumeration, Pattern:>Alternatives[All]]
      ],
      Category -> "Data Processing"
    },
    {
      OptionName -> DissociationFitDomain,
      Default -> All,
      Description -> "Specifies the time range of dissociation data points which will be included during fitting.",
      AllowNull -> False,
      Widget -> Alternatives[
        Adder[
          {
            "Min" -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Second], Units->Alternatives[Second,Minute,Hour]],
            "Max" -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Second], Units->Alternatives[Second,Minute,Hour]]
          }
        ],
        Widget[Type->Enumeration, Pattern:>Alternatives[All]]
      ],
      Category -> "Data Processing"
    },
    {
      OptionName -> NormalizeAssociationStart,
      Default -> True,
      AllowNull -> False,
      Description -> "Sets the response for the first data point of all association data sets to 0 Nanometer.",
      Category -> "Data Processing",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern:>BooleanP
      ]
    },
    {
      OptionName -> MatchDissociationStart,
      Default -> True,
      AllowNull -> False,
      Description -> "Sets the first data point of dissociation data to match the value of the last point in the corresponding association data.",
      Category -> "Data Processing",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern:>BooleanP
      ]
    },
    {
      OptionName -> AssociationBaselines,
      Default -> Automatic,
      Description -> "Specifies the baseline for the data in the association step. The baseline is subtracted prior to fitting kinetic rates.",
      ResolutionDescription -> "The appropriate baseline will be populated from the KineticsAssociationBaselines field of Object[Data, BioLayerInterferometry] if available.",
      AllowNull -> True,
      Category -> "Data Processing",
      Widget->
          Alternatives[
            "Matched Baselines" -> Adder[
              Alternatives[
                "Quantity Array Baseline" -> Widget[Type->Expression, Pattern:>QuantityArrayP[{{Second, Nano Meter}..}], Size->Line],
                "Baseline Data" -> Adder[
                  {
                    "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                    "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
                  }
                ],
                "No Baseline" -> Widget[Type -> Enumeration, Pattern:>Alternatives[Null]],
                "Constant"-> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]],
                "Function" -> Widget[Type -> Expression, Pattern:>_Function, Size ->Line]
              ]
            ],
            "Single Quantity Array Baseline" -> Widget[Type->Expression, Pattern:>QuantityArrayP[{{Second, Nano Meter}..}], Size->Line],
            "Single Baseline Data" -> Adder[
              {
                "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
              }
            ],
            "Constant" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]],
            "Function" -> Widget[Type -> Expression, Pattern:>_Function, Size ->Line],
            "Data Object" -> Widget[Type -> Expression, Pattern:> ObjectP[{Object[Data, BioLayerInterferometry]}], Size -> Line]
          ]
    },
    {
      OptionName -> DissociationBaselines,
      Default -> Automatic,
      Description -> "Specifies the baseline for the data in the dissociation step. The baseline is subtracted prior to fitting kinetic rates.",
      ResolutionDescription -> "The appropriate baseline will be populated from the KineticsDissociationBaselines field of Object[Data, BioLayerInterferometry] if available.",
      AllowNull -> True,
      Category -> "Data Processing",
      Widget->
          Alternatives[
            "Matched Baselines" -> Adder[
              Alternatives[
                "Quantity Array Baseline" -> Widget[Type->Expression, Pattern:>QuantityArrayP[{{Second, Nano Meter}..}], Size->Line],
                "Baseline Data" -> Adder[
                  {
                    "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                    "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
                  }
                ],
                "No Baseline" -> Widget[Type -> Enumeration, Pattern:>Alternatives[Null]],
                "Constant"-> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]],
                "Function" -> Widget[Type -> Expression, Pattern:>_Function, Size ->Line]
              ]
            ],
            "Single Quantity Array Baseline" -> Widget[Type->Expression, Pattern:>QuantityArrayP[{{Second, Nano Meter}..}], Size->Line],
            "Single Baseline Data" -> Adder[
              {
                "Time" -> Widget[Type -> Quantity, Pattern:>GreaterEqualP[0 Second], Units -> Alternatives[Second, Minute, Hour]],
                "Response" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]]
              }
            ],
            "Constant" -> Widget[Type -> Quantity, Pattern:>RangeP[-1 Milli Meter, 1 Milli Meter], Units -> Alternatives[Nano Meter, Micro Meter, Milli Meter]],
            "Function" -> Widget[Type -> Expression, Pattern:>_Function, Size ->Line],
            "Data Object" -> Widget[Type -> Expression, Pattern:> ObjectP[{Object[Data, BioLayerInterferometry]}], Size -> Line]
          ]
    },


    (* -- Guesses for parameters -- *)

    {
      OptionName -> AssociationRate,
      Default -> Automatic,
      Description -> "Specifies and initial guess for the association rate variables being solved for in units of 1/Molar*1/Second.",
      ResolutionDescription -> "The initial rate will be estimated based on the selected model.",
      AllowNull -> False,
      Widget -> {
        "Min" -> Widget[Type->Expression, Pattern:>_?NumericQ, Size -> Word],
        "Max" -> Widget[Type->Expression, Pattern:>_?NumericQ, Size -> Word]
      },
      Category -> "Data Processing"
    },
    {
      OptionName -> DissociationRate,
      Default -> Automatic,
      Description -> "Specifies and initial guess for the dissociation rate variables being solved for in units of 1/Second.",
      ResolutionDescription -> "The initial rate will be estimated based on the selected model.",
      AllowNull -> False,
      Widget -> {
        "Min" -> Widget[Type->Expression, Pattern:>_?NumericQ, Size -> Word],
        "Max" -> Widget[Type->Expression, Pattern:>_?NumericQ, Size -> Word]
      },
      Category -> "Data Processing"
    },
    {
      OptionName -> MaxResponse,
      Default -> Automatic,
      Description -> "Specifies and initial guess for the maximum bio-layer thickness achievable with the relevant analyte and bio-probe type.",
      ResolutionDescription->"The maximum response will be estimated as 2x the highest observed response of all the association data sets.",
      AllowNull -> False,
      Widget -> {
        "Min" -> Widget[Type->Quantity, Pattern:>GreaterP[0 Nanometer], Units -> Nanometer],
        "Max" -> Widget[Type->Quantity, Pattern:>GreaterP[0 Nanometer], Units -> Nanometer]
      },
      Category -> "Data Processing"
    },

    (* -- post fit processing -- *)
    {
      OptionName -> DataFilterType,
      Default -> Gaussian,
      Description -> "Indicate the type of data filtering that to be applied to all data.",
      AllowNull ->True,
      Widget ->Widget[Type -> Enumeration, Pattern:>Alternatives[Gaussian, Mean, Median]],
      Category -> "Data Processing"
    },
    {
      OptionName -> DataFilterWidth,
      Default -> 1 Second,
      Description -> "Indicate the radius over which the filter is applied.",
      ResolutionDescription -> "The filter width will resolve to 1 Second if a DataFilterType is specified.",
      AllowNull -> True,
      Widget->Widget[Type -> Quantity, Pattern:>GreaterP[0 Second], Units->Second],
      Category -> "Data Processing"
    },

    (* -- Hidden fields for pass through from overloads -- *)
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
    AnalysisTemplateOption,
    CacheOption
  }
];

Error::InvalidBindingKineticsDataType="The Object[Data,BindingKinetics] has the DataType of `1`, which cannot be used for this analysis function. Consider using a different data object for this function, or try another analysis function.";
Error::NoBindingKineticsData="The protocol does not contain any linked Data objects. Verify the protocol has a Status of Completed";
Warning::BindingKineticsMultipleAnalytes = "Multiple analytes found during unit conversion from densities to concentrations. Using the mass average molecular weight to convert.";
Error::SwappedBindingKineticsParameterGuesses = "The following options have swapped min and max values or min and max values that are the same: `1`.";
Error::NoMolecularWeight = "The following samples, `1`, link to a molecule model with no molecular weight, so the unit conversion for dilutions in mass/volume is impossible. Consider changing the dilution concentrations to molar units, or add the molecular weight to the Model[Molecule] linked in the Composition field of the SamplesIn field of the input data/protocol objects.";

(* -------------------------------- *)
(* -- BINDING KINETICS OVERLOADS -- *)
(* -------------------------------- *)

(* -- overload for protocol objects -- *)
AnalyzeBindingKinetics[
  protocol:ObjectP[{Object[Protocol, BioLayerInterferometry]}],
  ops:OptionsPattern[]
]:=Module[{dataObjs,outputSpecification,gatherTests,validData,tests,analysisReturn,
  listedReturn,outputRules,fullTests},

  (* extract the data objects *)
  dataObjs = Download[protocol, Data];

  (* determine if we're reporting errors with tests or messages *)
  outputSpecification=OptionValue[Output];
  gatherTests = MemberQ[ToList[outputSpecification],Tests];

  validData=!MatchQ[dataObjs, ({}|Null)];

  tests=If[gatherTests,
    {Test["The specified protocol has data objects in the Data field:",validData,True]}
  ];

  (* return failed and NoDataBindingKinetics error *)
  If[!validData,
    If[!gatherTests,Message[Error::NoBindingKineticsData]];
    Return[outputSpecification /.{
        Result->$Failed,
        Tests->tests,
        Options->$Failed,
        Preview->Null
    }]
  ];

  (* strip the link and send it to the next overload *)
  analysisReturn = AnalyzeBindingKinetics[
    ToList[Download[dataObjs, Object]],
    ops
  ];

  (* We want to use ToList since we could be asking for just one output - e.g. Tests then we'll get a single value *)
  (* We can't do that since our single output it could be a list of Tests or a list of Options so do this instead *)
  listedReturn = If[MatchQ[OptionValue[Output],_Symbol],
    {analysisReturn},
    analysisReturn
  ];

  (* setup list of rules linking output specification to actual output *)
  outputRules = Normal[AssociationThread[ToList[outputSpecification],listedReturn]];

  (* join our tests from this wrapper with all the output tests *)
  fullTests = Join[tests,Lookup[outputRules,Tests,{}]];

  (* return the output with the full tests *)
  outputSpecification/.ReplaceRule[outputRules,Tests->fullTests]
];

(* -- multiple data object overload - convert to a listed single data object -- *)
(* because of the fitting it cant be listable so sadly we have to map this very slow function *)

AnalyzeBindingKinetics[
  dataObjects:{ObjectP[{Object[Data, BioLayerInterferometry]}]..},
  ops:OptionsPattern[]
]:=AnalyzeBindingKinetics[
  #,
  ops
]&/@dataObjects;


(* ----------------------------------- *)
(* -- multiple data object overload -- *)
(* ----------------------------------- *)

(*TODO: it freaks out with multiple objects*)
(* this is the key overload to convert to raw data and to check that it is usable *)
AnalyzeBindingKinetics[
  dataObjects:ObjectP[{Object[Data, BioLayerInterferometry]}],
  ops:OptionsPattern[]
]:=Module[{safeOptions, safeOptionTests,listOps,notInEngine,outputSpecification,
  gatherTests,dataTypes,safeDataType, validDataBoolean, tests, dataPackets,samplesIn,associationData,
  dissociationData, dataObjectCache, newOps, analysisReturn, listedReturn, outputRules, fullTests},

  (* Determine if we are in Engine or not, in Engine we silence warnings *)
  notInEngine=Not[MatchQ[$ECLApplication,Engine]];

  (* get output specification for message errors *)
  outputSpecification = OptionValue[Output];
  gatherTests = MemberQ[ToList[outputSpecification],Tests];

  listOps = ToList[ops];

  (* Call SafeOptions to make sure all options match pattern - dont gather tests here because we wil do that in the core function *)
  {safeOptions, safeOptionTests} =
      {
        SafeOptions[AnalyzeBindingKinetics, listOps, AutoCorrect -> False],
        Null
      };

  (* determine which type of data objects we are looking at - plan for SPR incorporation here *)
  safeDataType =
      Which[
        (*BioLayerInterferometryData*)
        MatchQ[dataObjects, ObjectP[Object[Data, BioLayerInterferometry]]],
        BLI,

        (*TODO: add SPR pattern here when needed*)
        True,
        Null
      ];


  (* since we know that the data type is ok, we can proceed to extract the quantitation data *)
  {validDataBoolean, associationData, dissociationData, samplesIn, dataObjectCache, tests} = Which[

    (* experiment type BLI *)
    MatchQ[safeDataType, BLI],
    Module[
      {
        dataPackets, bliAssayType, bliAnalyteData, bliSamplesIn, bliDissociationData, bliAssociationData,
        rawCompositionAmounts, rawMolecularWeights, compositionAmounts, molecularWeights, mergedPacket,
        validDataType, tests
      },

      (* make a cache to pass to the next overload *)
      (* these are all the relevant fields  *)
      {dataPackets, rawCompositionAmounts, rawMolecularWeights} = Download[dataObjects,
        {
          Packet[
            DataType,
            SamplesIn,
            KineticsAssociation,
            KineticsAssociationBaselines,
            KineticsDissociation,
            KineticsDissociationBaselines,
            KineticsDilutionConcentrations
          ],
          Field[SamplesIn[Composition][[All,1]]],
          Field[SamplesIn[Composition][[All,2]][MolecularWeight]]
        },
        Date -> Now
      ];

      (* Replace {} or {{}} in raw compositions and molecular weights with null *)
      {compositionAmounts, molecularWeights} = {rawCompositionAmounts, rawMolecularWeights} /. ({{}} | {} | {{Null}} | {Null}) -> Null;

      (* merge datapackets with composition amounts and molecular weights in cache association *)
      mergedPacket = Merge[{dataPackets, <|Composition->compositionAmounts, MolecularWeight->molecularWeights|>}, First];

      (* pull out the input samples *)
      bliSamplesIn = Lookup[dataPackets, SamplesIn];

      (* look up what type of experiment it was so we can find the right keys - right now only quantitation can be processed here. *)
      bliAssayType = Lookup[dataPackets, DataType];

      (* if the data is not kinetics data, then we can just exit *)
      validDataType=MatchQ[bliAssayType, Kinetics];
      If[!validDataType&&!gatherTests,
        Message[Error::InvalidBindingKineticsDataType, bliAssayType];
      ];

      tests=If[gatherTests,
        {Test["All data objects have DataType->Kinetics:",validDataType,True]},
        {}
      ];

      (* since this is restricted to kinetics, just grab the field we know to look for *)
      (*TODO: in the future, we may want this to be able to look at quantitation or development data objects*)
      bliAssociationData = Lookup[dataPackets, KineticsAssociation];
      bliDissociationData = Lookup[dataPackets, KineticsDissociation];

      (* pass all the data input to the core function *)
      (* note if we had an error association/dissociation fields may not exist *)
      {validDataType, bliAssociationData, bliDissociationData, bliSamplesIn, mergedPacket, tests}
    ],


    (*TODO: add SPR download here*)
    True,
    {Null, Null, Null, Null, Null, Null}
  ];

  (* check for failure *)
  If[MatchQ[validDataBoolean,False],
    Return[outputSpecification /.{
      Result->$Failed,
      Tests->tests,
      Options->$Failed,
      Preview->Null
    }]
  ];

  (* add the new baseline if it was set to automatic *)
  newOps = ReplaceRule[
    listOps,
    {
      ReferenceObjects -> ToList[Download[dataObjects, Object]],
      SamplesIn -> ToList[Download[samplesIn, Object]],
      Cache -> dataObjectCache
    }
  ];


  (* call the core function with the raw data input and cache/reference objects passed in *)
  analysisReturn = AnalyzeBindingKinetics[associationData, dissociationData, newOps];

  (* We want to use ToList since we could be asking for just one output - e.g. Tests then we'll get a single value *)
  (* We can't do that since our single output it could be a list of Tests or a list of Options so do this instead *)
  listedReturn = If[MatchQ[OptionValue[Output],_Symbol],
    {analysisReturn},
    analysisReturn
  ];

  (* setup list of rules linking output specification to actual output *)
  outputRules = Normal[AssociationThread[ToList[outputSpecification],listedReturn]];

  (* join our tests from this wrapper with all the output tests *)
  fullTests = Join[tests,Lookup[outputRules,Tests,{}]];

  (* return the output with the full tests *)
  outputSpecification/.ReplaceRule[outputRules,Tests->fullTests]
];



(* ::Subsection:: *)
(*AnalyzeBindingKinetics Core Function*)

AnalyzeBindingKinetics[
  assocDataSets:{_?QuantityArrayQ..}|Null,
  dissocDataSets:{_?QuantityArrayQ..}|Null,
  ops:OptionsPattern[]
]:= Module[
  {
    (* general/framework variables *)
    optionsCache, optionsWithObjects, fieldsToDownload, downloadedFields, listedOptions, cachelessOptions, outputSpecification, output, standardFieldsStart, gatherTests, messages, notInEngine, safeOptions, safeOptionTests, flatDownloadedFields,
    unresolvedOptions, templateTests,combinedOptions,cacheBall,allTests,resolvedOptionsTests, resolvedOptionsResult, collapsedResolvedOptions,
    analysisObjects, upload, cache,
    (* download and resolution *)
    resolvedOptions, analyteDilutions, fitModel, optimizationType, linkMaxResponse, completelyReversibleBinding, optimizationOptions,
    associationFitDomain, dissociationFitDomain, normalizeAssociationStart, matchDissociationStart,
    associationBaselines, dissociationBaselines, associationRate, dissociationRate, maxResponse, dataFilterType, dataFilterWidth,
    referenceObjects, samplesIn, excludeData, simultaneousFit, scaledDissociationRate, scaledAssociationRate,
    (* data processing *)
    baselinedDissociationData, baselinedAssociationData, safeStandardConcentrations,
    matchedDissociationDomains,matchedAssociationBaselines, matchedDissociationBaselines, matchedAssociationDomains,
    alignedAssociationData, alignedAssociationOffsets, associationDataDensities, adjustedAssociationDomains,
    adjustedDissociationDomains, dissociationDataDensities, alignedDissociationOffsets, alignedDissociationData,
    alignedDissociationDataForDisplay,
    (* data fitting *)
    compositionAmounts, molecularWeights, avgMolWeight, densityAmounts, densityMolWeights, densityResult, convertedConcentrations, densityTests, dilutionUnitDimension,
    resTotal,fittedPars, fitMechanism, formattedkas, individualAssociationRates,
    formattedkds, individualDissociationRates, allIndividualRates, dissociationConstants,
    predictedTrajectories,
    updatedTrajectories, analysisObjectPacket, R0s, joinedData,eqnPacket, kinfit,
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
    SafeOptions[AnalyzeBindingKinetics, cachelessOptions, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[AnalyzeBindingKinetics, cachelessOptions, AutoCorrect -> False], Null}
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
    ApplyTemplateOptions[AnalyzeBindingKinetics, {assocDataSets, dissocDataSets}, cachelessOptions, Output -> {Result, Tests}],
    {ApplyTemplateOptions[AnalyzeBindingKinetics, {assocDataSets, dissocDataSets}, cachelessOptions], Null}
  ];

  (* combine the options *)
  combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

  (* -- Assemble big download -- *)

  (*get all of the object from the options, note that we will remove the referenceObjects option do avoid a duplicate download*)
  optionsWithObjects = DeleteDuplicates[Cases[KeyDrop[combinedOptions, {ReferenceObjects, SamplesIn}], ObjectP[Object[Data,BioLayerInterferometry]], Infinity]];

  (* fields to download are for BLI objects only. Download molecular weights for unit conversions. This will need to change for SPR. Note that we download a couple fields we wont use to match the previous download so we can clean up the cache*)
  fieldsToDownload = {
    Packet[
      DataType,
      SamplesIn,
      KineticsAssociation,
      KineticsAssociationBaselines,
      KineticsDissociation,
      KineticsDissociationBaselines,
      KineticsDilutionConcentrations
    ],
    Field[SamplesIn[Composition][[All,1]]],
    Field[SamplesIn[Composition][[All,2]][MolecularWeight]]
  };

  (* download the things *)
  downloadedFields = Quiet[
    Download[
      optionsWithObjects,
      fieldsToDownload,
      Date -> Now
    ],
    Download::FieldDoesntExist
  ];

  (* flatten level 1, because optionsWithObjects is just {object}, which double wraps downloadedFields *)
  flatDownloadedFields = Flatten[downloadedFields,1];

  (* unpack downloaded fields if it isn't empty *)
  {optionsCache, compositionAmounts, molecularWeights} = If[!MatchQ[downloadedFields,{}],
    (* replace all {{}} or {} with Null *)
    flatDownloadedFields /. ({{}} | {} | {{Null}} | {Null}) -> Null,

    (* if downloadedFields is empty, pull composition and molecular weights from cache *)
    cache = Lookup[listedOptions,Cache,Null];
    (* check if cache key is Null, set compositionAmounts and molecularWeights to Null in that case *)
    If[MatchQ[cache,Null],
      {downloadedFields, Null, Null},
      {downloadedFields, Lookup[cache, Composition], Lookup[cache, MolecularWeight]}
    ]
  ];

  (* pass the object packets through the cache - important to look it up from listed options because everything else has it removed *)
  cacheBall = Cases[Experiment`Private`FlattenCachePackets[{Lookup[listedOptions, Cache], optionsCache}], PacketP[]];


  (*--Build the resolved options--*)
  resolvedOptionsResult=If[gatherTests,
    (*We are gathering tests. This silences any messages being thrown*)
    {resolvedOptions,resolvedOptionsTests}=resolveAnalyzeBindingKineticsOptions[assocDataSets, dissocDataSets,combinedOptions,Cache->cacheBall,Output->{Result,Tests}];

    (*Therefore, we have to run the tests to see if we encountered a failure*)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveAnalyzeBindingKineticsOptions[assocDataSets, dissocDataSets,combinedOptions,Cache->cacheBall],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (*Collapse the resolved options*)
  collapsedResolvedOptions=CollapseIndexMatchedOptions[
    AnalyzeBindingKinetics,
    resolvedOptions,
    Ignore->cachelessOptions,
    Messages->False
  ];

  (*If option resolution failed, return early*)
  If[MatchQ[resolvedOptions,$Failed],
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->resolvedOptionsTests,
      Options->$Failed,
      Preview->Null
    }]
  ];

  (* look up all the options *)
  {
    analyteDilutions,
    fitModel,
    optimizationType,
    linkMaxResponse,
    completelyReversibleBinding,
    optimizationOptions,
    associationFitDomain,
    dissociationFitDomain,
    normalizeAssociationStart,
    matchDissociationStart,
    associationBaselines,
    dissociationBaselines,
    associationRate,
    dissociationRate,
    maxResponse,
    dataFilterType,
    dataFilterWidth,
    referenceObjects,
    samplesIn,
    excludeData,
    simultaneousFit,
    upload
  }=Lookup[resolvedOptions,
    {
      AnalyteDilutions,
      FitModel,
      OptimizationType,
      LinkMaxResponse,
      CompletelyReversibleBinding,
      OptimizationOptions,
      AssociationFitDomain,
      DissociationFitDomain,
      NormalizeAssociationStart,
      MatchDissociationStart,
      AssociationBaselines,
      DissociationBaselines,
      AssociationRate,
      DissociationRate,
      MaxResponse,
      DataFilterType,
      DataFilterWidth,
      ReferenceObjects,
      SamplesIn,
      ExcludeData,
      SimultaneousFit,
      Upload
    }];

  (* -------------------------------- *)
  (* -- DATA PROCESSING - BASELINE -- *)
  (* -------------------------------- *)

  (* -- ASSOCIATION -- *)

  (* -- if necessary, download and expand the baselines so they match up to the samples -- *)
  matchedAssociationBaselines = If[MatchQ[associationBaselines, _List]&&!MatchQ[associationBaselines, {{_?QuantityQ, _?QuantityQ}..}],

    (* if we have a list, then check each element for validity *)
    Map[
      If[MatchQ[#, ObjectP[]],

        (* if we have an object, download the data, replace any empty lists with Nulls for the helper *)
        Download[#, KineticsAssociationBaselines, Cache -> cacheBall]/.{}->Null,

        (*if we have raw data, a constant, or a function just return the value. It is handled in the helper*)
        #
      ]&,
      associationBaselines
    ],

    (* If we have a single element, just leave it because the helper function can handle it *)
    If[MatchQ[associationBaselines, ObjectP[]],

      (* if we have an object, download the data, replace any empty lists with Nulls for the helper *)
      Download[
        associationBaselines,
        KineticsAssociationBaselines,
        Cache -> cacheBall,
        Date -> Now
      ]/.{}->Null,

      (*if we have a quantityarray, function, or constant, just return that and let the helper do its thing*)
      associationBaselines
    ]
  ];

  (*TODO: make a safe assocDataSets in case of Null input*)
  (* -- match the domain option to the appropriate data element  -- *)
  matchedAssociationDomains = If[MatchQ[associationFitDomain, Alternatives[{_?QuantityQ, _?QuantityQ}, All]],

    (* a single sample domain needs to be expanded *)
    ConstantArray[associationFitDomain, Length[ToList[assocDataSets]]],

    (* otherwise the domains are already matched *)
    associationFitDomain
  ];


  (* -- if necessary, download and expand the baselines so they match up to the samples -- *)
  matchedDissociationBaselines = If[MatchQ[dissociationBaselines, _List]&&!MatchQ[dissociationBaselines, {{_?QuantityQ, _?QuantityQ}..}],

    (* if we have a list, then check each element for validity *)
    Map[
      If[MatchQ[#, ObjectP[]],

        (* if we have an object, download the data, replace any empty lists with Nulls for the helper *)
        Download[#, KineticsDissociationBaselines, Cache -> cacheBall, Date->Now]/.{}->Null,

        (*if we have raw data, a constant, or a function just return the value. It is handled in the helper*)
        #
      ]&,
      dissociationBaselines
    ],

    (* If we have a single element, just leave it because the helper function can handel it *)
    If[MatchQ[dissociationBaselines, ObjectP[]],

      (* if we have an object, download the data, replace any empty lists with Nulls for the helper *)
      Download[
        dissociationBaselines,
        KineticsDissociationBaselines,
        Cache -> cacheBall,
        Date->Now
      ]/.{}->Null,

      (*if we have a quantityarray, function, or constant, jsut return that and let the helper do its thing*)
      dissociationBaselines
    ]
  ];

  (*TODO: make a safe dissocDataSets in case of Null input*)
  (* -- match the domain option to the appropriate data element  -- *)
  matchedDissociationDomains = If[MatchQ[dissociationFitDomain, Alternatives[{_?QuantityQ, _?QuantityQ}, All]],

    (* a single sample domain needs to be expanded *)
    ConstantArray[dissociationFitDomain, Length[ToList[dissocDataSets]]],

    (* otherwise the domains are already matched *)
    dissociationFitDomain
  ];

  (* -- BASELINE THE DATA -- *)

  (* baseline the data using the BindingQuantitation helper function *)
  (* if there is no valid baseline data, jsut return the unbaselined data set  *)
  baselinedAssociationData = Flatten[
    Which[
      MatchQ[matchedAssociationBaselines, ({}|{Null..}|Null)],
      {assocDataSets},

      MatchQ[matchedAssociationBaselines, _List],
      MapThread[Analysis`Private`baselineBLIQuantitationData[#1, #2, True]&, {assocDataSets, matchedAssociationBaselines}],

      True,
      Analysis`Private`baselineBLIQuantitationData[assocDataSets, matchedAssociationBaselines, True]
    ],
    1
  ];

  baselinedDissociationData = Flatten[
    Which[
      MatchQ[matchedDissociationBaselines, ({}|{Null..}|Null)],
      {dissocDataSets},

      MatchQ[matchedDissociationBaselines, _List],
      MapThread[Analysis`Private`baselineBLIQuantitationData[#1, #2, True]&, {dissocDataSets, matchedDissociationBaselines}],

      True,
      Analysis`Private`baselineBLIQuantitationData[dissocDataSets, matchedDissociationBaselines, True]
    ],
    1
  ];

  (* ----------------------------- *)
  (* -- DATA PROCESSING - ALIGN -- *)
  (* ----------------------------- *)

  (* -- align association starts if requested -- *)
  (* align to all of the association data to (0,0) if requested. This is actually sort of important because it can reduce the fit parameters, which will improve the fit. *)
  alignedAssociationData = If[MatchQ[normalizeAssociationStart,True]&&!MatchQ[baselinedAssociationData, Null],
    Analysis`Private`alignBLIData[
      baselinedAssociationData,
      ConstantArray[0 Nanometer, Length[baselinedAssociationData]],
      ConstantArray[0 Second, Length[baselinedAssociationData]]
    ],
    baselinedAssociationData
  ];

  (* use the last point of the association data as the first point of the dissociation data if alignment is requested, but make it start at 0 since NDSolve needs that to handle it *)
  alignedDissociationData = If[MatchQ[matchDissociationStart,True]&&!MatchQ[baselinedDissociationData, Null],
    Analysis`Private`alignBLIData[
      baselinedDissociationData,
      alignedAssociationData[[All, -1, 2]],
      ConstantArray[0 Second, Length[baselinedDissociationData]]
    ],
    baselinedDissociationData
  ];

  (* use the last point of the association data as the first point of the dissociation data if alignment is requested *)
  alignedDissociationDataForDisplay = If[MatchQ[matchDissociationStart,True]&&!MatchQ[baselinedDissociationData, Null],
    Analysis`Private`alignBLIData[
      baselinedDissociationData,
      alignedAssociationData[[All, -1, 2]],
      alignedAssociationData[[All, -1, 1]]
    ],
    baselinedDissociationData
  ];
  (* ---------------------------------------- *)
  (* -- DATA PROCESSING - DETERMINE DOMAIN -- *)
  (* ---------------------------------------- *)
  (*TODO: needs to be updated to pass into AK - need to enforce continuity if we are fitting both dissociation and association*)

  (* -- ASSOCIATION -- *)
  (* determine how much the data was shifted on the time axis so that the domain can match it. *)
  alignedAssociationOffsets = Subtract[baselinedAssociationData[[All, 1, 1]], alignedAssociationData[[All,1,1]]];

  (* also determine the spacing of the data points so we can convert domain from time into number of points *)
  associationDataDensities = Subtract[baselinedAssociationData[[All,2,1]], baselinedAssociationData[[All,1,1]]];

  (* adjust the domains to match *)
  adjustedAssociationDomains = If[!MatchQ[alignedAssociationData, Null],
    MapThread[
      If[MatchQ[#1, {_?QuantityQ, _?QuantityQ}],
        (*adjust the domain for alignemnet and data density - this will also remove units*)
        Round[Divide[Plus[#1, #2], #3], 1],

        (*if the domain is not in the proper form, we are using the entire data set so just grab the end points which are 1 and the lenght of the data*)
        {1, Length[#4]}
      ]&,
      {matchedAssociationDomains, alignedAssociationOffsets, associationDataDensities, alignedAssociationData}
    ],
    Null
  ];


  (* -- DISSOCIATION -- *)
  (* determine how much the data was shifted on the time axis so that the domain can match it. *)
  alignedDissociationOffsets = Subtract[baselinedDissociationData[[All, 1, 1]], alignedDissociationDataForDisplay[[All,1,1]]];

  (* also determine the spacing of the data points so we can convert domain from time into number of points *)
  dissociationDataDensities = Subtract[baselinedDissociationData[[All,2,1]], baselinedDissociationData[[All,1,1]]];

  (* adjust the domains to match *)
  adjustedDissociationDomains = If[!MatchQ[alignedDissociationDataForDisplay, Null],
    MapThread[
      If[MatchQ[#1, {_?QuantityQ, _?QuantityQ}],
        (*adjust the domain for alignemnet and data density - this will also remove units*)
        Round[Divide[Plus[#1, #2], #3], 1],

        (*if the domain is not in the proper form, we are using the entire data set so just grab the end points which are 1 and the lenght of the data*)
        {1, Length[#4]}
      ]&,
      {matchedDissociationDomains, alignedDissociationOffsets, dissociationDataDensities, alignedDissociationDataForDisplay}
    ],
    Null
  ];

  (* ------------------------ *)
  (* -- DATA FITTING SETUP -- *)
  (* ------------------------ *)

  (* -- CONCENTRATIONS -- *)

  (*TODO: there is a way to specify concentrations in AK, but I dont think it will have the same meaning as it does here, since the only concentration we input is not gogin to change, and we dont know the other conc.*)
  (* -- get the concentrations in a usable form -- *)
  safeStandardConcentrations = If[MatchQ[analyteDilutions, {ObjectP[]..}|ObjectP[]],
    Flatten[DeleteDuplicates[Download[analyteDilutions, KineticsDilutionConcentrations, Cache -> cacheBall, Date ->Now]], 1],
    analyteDilutions
  ];

  (* - CONCENTRATION UNIT CONVERSION - *)

  (* isolate unit dimension of the first element of the dilution concentrations *)
  dilutionUnitDimension = UnitDimension[First[safeStandardConcentrations]];

  (* if units of KineticsDilutionConcentrations indicates a density then convert the units to concentration w/ molecular weight *)
  densityResult = If[MatchQ[dilutionUnitDimension,"Density"],
    Module[{mwTest, multipleAnalytesTest},

      mwTest = Test["All of the SamplesIn link to a molecule model with a molecular weight:",MatchQ[molecularWeights,Null],False];

      (* First check if molecular weight is null, throw error if Null *)
      If[MatchQ[molecularWeights,Null],
        If[!gatherTests, Message[Error::NoMolecularWeight, samplesIn]];
        Return[outputSpecification/.{
          Options->RemoveHiddenOptions[AnalyzeBindingKinetics,resolvedOptions],
          Result->$Failed,
          Tests->Join[safeOptionTests,templateTests,resolvedOptionsTests,{mwTest}],
          Preview->Null
        }]
      ];

      (* get molecular weights associated with a composition in units of density.
	   Flatten objects before picking list b/c there should be only one sample *)
      densityMolWeights = PickList[Flatten[molecularWeights], Flatten[compositionAmounts], UnitsP["Density"]];

      (* find mass average mol weight; if there is one analyte, no need to find average *)
      avgMolWeight = If[Length[densityMolWeights] > 1,
        (* warn user that there are multiple analytes with different molecular weights, taking mass average of them *)
        If[!gatherTests,Message[Warning::BindingKineticsMultipleAnalytes]];
        (* get the different densities *)
        densityAmounts = Cases[Flatten[compositionAmounts], UnitsP["Density"]];

        (* weight each molecular weight by density and divide by total density *)
        Total[(densityAmounts * densityMolWeights)] / Total[densityAmounts],

        (* ELSE: Length of densityMolWeights is 1, so flatten and return only value *)
        densityMolWeights[[1]]
      ];

      (* Create equivalent test for Warning::BindingKineticsMultipleAnalytes *)
      multipleAnalytesTest = Warning["There is a single analyte so there is no need to average molecular weights in order to determine the concentration:",Length[densityMolWeights] > 1,False];

      (* Divide the concentrations by average molecular weight to get concentrations *)
      {safeStandardConcentrations / avgMolWeight, {mwTest,multipleAnalytesTest}}
    ],

    (* ELSE: dilution unit is not a density, so it's either a concentration or Null, which are both fine as is *)
    {safeStandardConcentrations, {}}
  ];

  (* For unclear reasons the return in this module will cause a series of failures if we try to set these two variables directly *)
  {convertedConcentrations, densityTests} = densityResult;

  joinedData = MapThread[Join[#1,Rest[#2]]&,{alignedAssociationData,alignedDissociationDataForDisplay}];

  R0s = Map[Max[0,Unitless[#[[1,2]]]]&,joinedData];

  (* -- Identify the ODEs -- *)
  eqnPacket = bindingEquationLookup[fitModel,convertedConcentrations,
    {maxResponse,associationRate,dissociationRate},Unitless[alignedAssociationData[[1,-1,1]]],R0s];


  kinFit = AnalyzeKinetics[
    joinedData,
    eqnPacket[Equations],
    ObservedSpecies -> eqnPacket[ObservedSpecies],
    InitialConcentration -> eqnPacket[InitialValues],
    Rates -> eqnPacket[Parameters],
    Upload->False
  ];

  fittedPars = Rule@@@kinFit[Replace[Rates]];

  updatedTrajectories = Map[
    Function[traj,QuantityArray[First[traj[Coordinates]],{Second,Nanometer}]],
    kinFit[PredictedTrajectories]
  ];


  (* -- OUTPUT FIT MECHANISM -- *)
  fitMechanism = Which[
  MatchQ[fitModel, OneToOne],
    {ReactionMechanism[Reaction[{"A", "L"}, {"AL"}, ka, kd]]},

    MatchQ[fitModel, BivalentAnalyte],
    {
      ReactionMechanism[Reaction[{"A", "L"}, {"AL"}, ka1, kd1]],
      ReactionMechanism[Reaction[{"AL", "L"}, {"AL2"}, ka2, kd2]]
    },

    MatchQ[fitModel, HeterogeneousLigand],
    {
      ReactionMechanism[Reaction[{"A", "L1"}, {"AL1"}, ka1, kd1]],
      ReactionMechanism[Reaction[{"A", "L2"}, {"AL2"}, ka2, kd2]]
    },

    MatchQ[fitModel, MassTransport],
    {
      ReactionMechanism[Reaction[{"Abulk"}, {"Asurf"}, km, km]],
      ReactionMechanism[Reaction[{"Asurf", "L"}, {"AL"}, ka, kd]]
    }
  ];

  (* format the rates for output *)
  (* NMinimize/FindMinimum both output the form {ka -> value, kd -> value ..} *)
  {formattedkas, individualAssociationRates} = Module[{allkas, individualRates, averagedRates},

    (* determine if we have a list from individual fittign or a single value from a simultaneous fit *)
    (* it will come out as a one element list for simultaneous fit *)
    allkas = Which[
      MatchQ[fittedPars, {_Rule..}],
      Select[fittedPars, MatchQ[First[#], (ka|ka1|ka2)]&],

      (* If it is a list of rules, then we have done an individual fit *)
      MatchQ[fittedPars, {{_Rule..}..}],
      Select[Flatten[fittedPars],MatchQ[First[#], (ka|ka1|ka2)]&],

      True,
      Null
    ];

    (* if there are multiple rates, convert them to a useable list form so the user can see which data set made their fit go horribly wrong *)
    individualRates = If[MatchQ[Length[allkas], GreaterP[1]],
      Map[{First[#], 10^Last[#]}&, allkas],
      Null
    ];

    (* average the rates if needed and get them into the output form *)
    averagedRates = If[MatchQ[Length[allkas], GreaterP[1]],
      Module[{averages},
        averages = N[Normal[Merge[allkas, Mean]]];
        Map[{First[#], 10^Last[#]}&, averages]
      ],
      Map[{First[#], 10^Last[#]}&, allkas]
    ];

    (* output hte result *)
    {averagedRates, individualRates}
  ];

  (* format the dissociation rates both for the averaged output and the individual troubleshooting field *)
  {formattedkds, individualDissociationRates} = Module[{allkds, individualRates, averagedRates},

    (* determine if we have a list from individual fittign or a single value from a simultaneous fit *)
    (* it will come out as a one element list for simultaneous fit *)
    allkds = Which[
      MatchQ[fittedPars, {_Rule..}],
      Select[fittedPars, MatchQ[First[#], (kd|kd1|kd2)]&],

      (* If it is a list of rules, then we have done an individual fit *)
      MatchQ[fittedPars, {{_Rule..}..}],
      Select[Flatten[fittedPars],MatchQ[First[#], (kd|kd1|kd2)]&],

      True,
      Null
    ];

    (* if there are multiple rates, convert them to a useable list form so the user can see which data set made their fit go horribly wrong *)
    individualRates = If[MatchQ[Length[allkds], GreaterP[1]],
      Map[{First[#], 10^Last[#]}&, allkds],
      Null
    ];

    (* average the rates if needed and get them into the output form *)
    averagedRates = If[MatchQ[Length[allkds], GreaterP[1]],
      Module[{averages},
        averages = N[Normal[Merge[allkds, Mean]]];
        Map[{First[#], 10^Last[#]}&, averages]
      ],
      Map[{First[#], 10^Last[#]}&, allkds]
    ];

    (* output the result *)
    {averagedRates, individualRates}
  ];

  (*output all of the rates to again tell the user how the fitting has failed them*)
  allIndividualRates = DeleteCases[Join[ToList[individualDissociationRates], ToList[individualAssociationRates]], Null]/.{}->Null;

  (* compute dissociation constants for all relevant reactions *)
  dissociationConstants =
    (* determine which rates match up (ie. kd1 and ka1 or ka and kd) *)
    {
      If[MemberQ[formattedkas, {ka, _}]&&MemberQ[formattedkds, {kd, _}],
        Module[{kaValue, kdValue},
          kaValue = Cases[formattedkas, {ka, _}][[1,-1]];
          kdValue = Cases[formattedkds, {kd, _}][[1,-1]];
          N[kdValue/kaValue]
        ],
        Nothing
      ],

      (* if there is a ka1/kd1 report that first *)
      If[MemberQ[formattedkas, {ka1, _}]&&MemberQ[formattedkds, {kd1, _}],
        Module[{kaValue, kdValue},
          kaValue = Cases[formattedkas, {ka1, _}][[1,-1]];
          kdValue = Cases[formattedkds, {kd1, _}][[1,-1]];
          N[kdValue/kaValue]
        ],
        Nothing
      ],

      (* report the second ka/kd pair last, although it is somewhat arbitrary in some fit models *)
      If[MemberQ[formattedkas, {ka2, _}]&&MemberQ[formattedkds, {kd2, _}],
        Module[{kaValue, kdValue},
          kaValue = Cases[formattedkas, {ka2, _}][[1,-1]];
          kdValue = Cases[formattedkds, {kd2, _}][[1,-1]];
          N[kdValue/kaValue]
        ],
        Nothing
      ]
    };


  (* ----------------------------- *)
  (* -- PREPARE ANALYSIS OBJECT -- *)
  (* ----------------------------- *)
  analysisObjectPacket = <|
    Type -> Object[Analysis, BindingKinetics],
    If[MatchQ[Lookup[resolvedOptions, ReferenceObjects], ObjectP[]|{ObjectP[]..}],
      Append[Reference] -> Link[Lookup[resolvedOptions, ReferenceObjects], KineticsAnalysis],
      Nothing
    ],
    ResolvedOptions -> resolvedOptions,
    UnresolvedOptions -> ToList[ops],
    If[MatchQ[samplesIn, ObjectP[]|{ObjectP[]..}],
      Replace[Solution] -> Link[samplesIn],
      Nothing
    ],
    Replace[FitMechanism] -> fitMechanism,
    Replace[AssociationTrainingData] -> alignedAssociationData,
    Replace[DissociationTrainingData] -> baselinedDissociationData,
    (* fit parameters and error *)
    Replace[AssociationRates] -> formattedkas,
    Replace[DissociationRates] -> formattedkds,
    Replace[DissociationConstants] -> dissociationConstants,
    (* fits and counts *)
    Replace[PredictedTrajectories] -> updatedTrajectories,
    Replace[NumberOfIterations] -> {kinFit[NumberOfIterations]},
    (* things from fit *)
    Replace[Residuals] -> {kinFit[Residual]},
    Replace[IndividualFitRates] -> allIndividualRates
  |>;

  (* -------------------------- *)
  (* -- GENERATE THE PREVIEW -- *)
  (* -------------------------- *)

  (* this preview needs to be inproved to show the fits against the data *)
  previewRule = If[MemberQ[output, Preview],
    Preview -> TabView[
      {
        "Predicted Trajectories"-> Zoomable[EmeraldListLinePlot[updatedTrajectories]],
        "Processed Data" -> Zoomable[EmeraldListLinePlot[joinedData,Joined->False]],
        "Data with projections" -> Zoomable[Show[
          EmeraldListLinePlot[joinedData,Joined->False],
          EmeraldListLinePlot[updatedTrajectories]
        ]],
        "Fit Results"->Zoomable@PlotTable[
          {
            {"Association Rates", ScientificForm[formattedkas],1/(Molar*Second)},
            {"Dissociation Rates", ScientificForm[formattedkds], 1/Second},
            {"Dissociation Constants", ScientificForm[dissociationConstants],Molar}
          },
          TableHeadings -> {None, {"Parameter", "Fitted Values", "Units"}},
          Alignment -> Center,
          Title->"Fit Rates"
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
    RemoveHiddenOptions[AnalyzeBindingKinetics,resolvedOptions],
    Null
  ];

  (* ---------------- *)
  (* -- Tests Rule -- *)
  (* ---------------- *)

  (* gather all the tests *)
  allTests=Cases[
    Flatten[
      {
        safeOptionTests,
        resolvedOptionsTests,
        densityTests
      }
    ],
    _EmeraldTest
  ];

  (* Next, define the Tests Rule *)
  testsRule=Tests->If[MemberQ[output,Tests],
    allTests,
    Null
  ];

  (* ----------------- *)
  (* -- Result Rule -- *)
  (* ----------------- *)

  (* First, upload the analysis object packet if upload is True *)
  analysisObjects=If[upload&&MemberQ[output,Result],
    Upload[analysisObjectPacket],
    analysisObjectPacket
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
(*AnalyzeBindingKineticsPreview*)


DefineOptions[AnalyzeBindingKineticsPreview,
  SharedOptions:>{AnalyzeBindingKinetics}
];

AnalyzeBindingKineticsPreview[myData:ObjectP[Object[Data,BioLayerInterferometry]]|{ObjectP[Object[Data,BioLayerInterferometry]]..}|ObjectP[Object[Protocol,BioLayerInterferometry]],myOptions:OptionsPattern[]]:=Module[
  {listedOptions},

  listedOptions=ToList[myOptions];

  AnalyzeBindingKinetics[myData,ReplaceRule[listedOptions,Output->Preview]]
];

AnalyzeBindingKineticsPreview[assocDataSets:{_?QuantityArrayQ..}|Null, dissocDataSets:{_?QuantityArrayQ..}|Null, myOptions:OptionsPattern[]]:=Module[
  {listedOptions},

  listedOptions=ToList[myOptions];

  AnalyzeBindingKinetics[assocDataSets, dissocDataSets, ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection:: *)
(*ValidAnalyzeBindingKineticsQ*)


DefineOptions[ValidAnalyzeBindingKineticsQ,
  Options:>
      {
        VerboseOption,
        OutputFormatOption
      },
  SharedOptions:>{AnalyzeBindingKinetics}
];

ValidAnalyzeBindingKineticsQ[assocDataSets:{_?QuantityArrayQ..}|Null, dissocDataSets:{_?QuantityArrayQ..}|Null, ops:OptionsPattern[]]:=Module[
  {listedOptions,preparedOptions,bindingKineticsTests,initialTestDescription,allTests,verbose,outputFormat},

  (* Get the options as a list *)
  listedOptions=ToList[ops];

  (* Remove the output option before passing to the core function because it doesn't make sense here *)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (* Return only the tests for AnalyzeBindingKinetics *)
  bindingKineticsTests=AnalyzeBindingKinetics[assocDataSets,dissocDataSets,Append[preparedOptions,Output->Tests]];

  (* Define the general test description *)
  initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* Make a list of all of the tests, including the blanket test *)
  allTests=If[MatchQ[bindingKineticsTests,$Failed],
    {Test[initialTestDescription,False,True]},
    Module[
      {initialTest,validObjectBooleans},

      (* Generate the initial test, which we know will pass if we got this far (hopefully) *)
      initialTest=Test[initialTestDescription,True,True];

      (* Get all the tests/warnings *)
      Flatten[{initialTest,bindingKineticsTests}]
    ]
  ];


  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  {verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

  (* Run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidAnalyzeBindingKineticsQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidAnalyzeBindingKineticsQ"]
];

ValidAnalyzeBindingKineticsQ[myData:ObjectP[Object[Data,BioLayerInterferometry]]|{ObjectP[Object[Data,BioLayerInterferometry]]..}|ObjectP[Object[Protocol,BioLayerInterferometry]],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,preparedOptions,bindingKineticsTests,initialTestDescription,allTests,verbose,outputFormat},

  (* Get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the output option before passing to the core function because it doesn't make sense here *)
  preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

  (* Return only the tests for AnalyzeBindingKinetics *)
  bindingKineticsTests=AnalyzeBindingKinetics[myData,Append[preparedOptions,Output->Tests]];

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
  Lookup[RunUnitTest[<|"ValidAnalyzeBindingKineticsQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidAnalyzeBindingKineticsQ"]
];


(* ::Subsection:: *)
(*AnalyzeBindingKineticsOptions*)


DefineOptions[AnalyzeBindingKineticsOptions,
  SharedOptions :> {AnalyzeBindingKinetics},
  {
    OptionName -> OutputFormat,
    Default -> Table,
    AllowNull -> False,
    Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
    Description -> "Determines whether the function returns a table or a list of the options."
  }
];

AnalyzeBindingKineticsOptions[myData:ObjectP[Object[Data,BioLayerInterferometry]]|{ObjectP[Object[Data,BioLayerInterferometry]]..}|ObjectP[Object[Protocol,BioLayerInterferometry]],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* Get only the options for CriticalMicelleConcentration *)
  options=AnalyzeBindingKinetics[myData,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[Normal[Merge[options,Join]],AnalyzeBindingKinetics],
    options
  ]
];


(* Raw Data Overload *)
AnalyzeBindingKineticsOptions[assocDataSets:{_?QuantityArrayQ..}|Null, dissocDataSets:{_?QuantityArrayQ..}|Null, myOptions:OptionsPattern[]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions=ToList[myOptions];

  (* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

  (* Get only the options for CriticalMicelleConcentration *)
  options=AnalyzeBindingKinetics[assocDataSets,dissocDataSets,Append[noOutputOptions,Output->Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,AnalyzeBindingKinetics],
    options
  ]
];


(* ::Subsection:: *)
(*resolveAnalyzeBindingKineticsOptions*)

(* ------------------------------------------ *)
(* -- resolveAnalyzeBindingKineticsOptions -- *)
(* ------------------------------------------ *)

DefineOptions[resolveAnalyzeBindingKineticsOptions,
  Options:>{
    CacheOption,
    HelperOutputOption
  }
];


resolveAnalyzeBindingKineticsOptions[
  associationData:{_?QuantityArrayQ..}|Null,
  dissociationData:{_?QuantityArrayQ..}|Null,
  myOptions:{_Rule..},
  ops:OptionsPattern[resolveAnalyzeBindingKineticsOptions]
]:= Module[
  {
    outputSpecification, output, gatherTests, messages, allInvalidABKOptions, allABKTests,abkOptionsAssociation, cache,
    (* original options *)
    analyteDilutions, fitModel, optimizationType, linkMaxResponse, completelyReversibleBinding, optimizationOptions,
    associationFitDomain, dissociationFitDomain, normalizeAssociationStart, matchDissociationStart, associationBaselines, dissociationBaselines, associationRate,
    dissociationRate, maxResponse, dataFilterType, dataFilterWidth, referenceObjects, samplesIn, excludeData, simultaneousFit,
    (* automatic resolved options *)
    resolvedAssociationBaselines, resolvedDissociationBaselines, resolvedAssociationRate,
    resolvedDissociationRate, resolvedMaxResponse, resolvedFilterWidth, resolvedConcentrations,
    resolvedAssociationBaselinesData, resolvedDissociationBaselinesData, resolvedCompletelyReversibleBinding,
    (* error tracking variables *)
    associationDataMinMax, dissociationDataMinMax, associationBaselineMinMax,
    dissociationBaselineMinMax, validRange,
    (*invalid options*)
    invalidAssociationBaselinesOption, invalidDissociationBaselinesOption, unusedDissociationOptions,
    unusedAssociationOptions, missingConcentrationOptions, swappedParameterRangeOptions,
    (* invalid option tests *)
    invalidAssociationBaselinesTest, invalidDissociationBaselinesTest, missingConcentrationTest,
    swappedParameterRangeTests,
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
  abkOptionsAssociation = Association[myOptions];

  (* look up all the options *)
  {
    analyteDilutions,
    fitModel,
    optimizationType,
    linkMaxResponse,
    completelyReversibleBinding,
    optimizationOptions,
    associationFitDomain,
    dissociationFitDomain,
    normalizeAssociationStart,
    matchDissociationStart,
    associationBaselines,
    dissociationBaselines,
    associationRate,
    dissociationRate,
    maxResponse,
    dataFilterType,
    dataFilterWidth,
    referenceObjects,
    samplesIn,
    excludeData,
    simultaneousFit
  }=Lookup[abkOptionsAssociation,
    {
      AnalyteDilutions,
      FitModel,
      OptimizationType,
      LinkMaxResponse,
      CompletelyReversibleBinding,
      OptimizationOptions,
      AssociationFitDomain,
      DissociationFitDomain,
      NormalizeAssociationStart,
      MatchDissociationStart,
      AssociationBaselines,
      DissociationBaselines,
      AssociationRate,
      DissociationRate,
      MaxResponse,
      DataFilterType,
      DataFilterWidth,
      ReferenceObjects,
      SamplesIn,
      ExcludeData,
      SimultaneousFit
    }];

  (* ---------------------------------- *)
  (* -- RESOLVE THE AUTOMATIC FIELDS -- *)
  (* ---------------------------------- *)




  (*TODO: these are: AssociationBaselines, DissociationBaselines, AssociationRate, DissociationRate, MaxResponse *)
  (*  *)
  (* AssociationBaselines  - if there are reference objects pull the value from there, otherwise set it to null*)
  resolvedAssociationBaselines = If[MatchQ[referenceObjects, Except[Null|{}|Automatic]],
    associationBaselines/.Automatic -> Flatten[ToList[Download[referenceObjects, KineticsAssociationBaselines, Cache -> cache]],1],
    associationBaselines/.Automatic -> Null
  ];

  (* DissociationBaselines - if there are reference objects, pull the valeu from there, otherwise set to Null*)
  resolvedDissociationBaselines = If[MatchQ[referenceObjects, Except[Null|{}|Automatic]],
    dissociationBaselines/.Automatic -> Flatten[ToList[Download[referenceObjects, KineticsDissociationBaselines, Cache -> cache]], 1],
    dissociationBaselines/.Automatic -> Null
  ];

  (* Concentrations - if there are reference objects, we can also resolve the concentrations. not that it may be ok to have no concentrations if it is dissociation only. *)
  resolvedConcentrations = If[MatchQ[referenceObjects, Except[Null|{}|Automatic]],
    analyteDilutions/.Automatic -> Flatten[ToList[Download[referenceObjects, KineticsDilutionConcentrations, Cache -> cache]]],
    analyteDilutions/.Automatic -> Null
  ];

  (* resolve the association rate guess - currently hardcoded *)
  resolvedAssociationRate = associationRate/.Automatic -> {1000, 1000000};

  (* resolve the dissociation rate guess - also hard coded *)
  resolvedDissociationRate = dissociationRate/.Automatic -> {0.000000001,0.001};

  (* the max response we can set by getting the maximum value and scaling by 1.5. This should give a reasonable guess *)
  resolvedMaxResponse = Module[{allDataPoints, allResponseValues, rMaxGuess},
    (*gather all the quantity arrays*)
    allDataPoints = Join[Unitless[Cases[{associationData, dissociationData}, _?QuantityArrayQ, Infinity]]];

    (*extract the response values out*)
    allResponseValues = Flatten[allDataPoints[[All, All, 2]]];

    (*find the max value and scale by 1.5 to get our guess*)
    rMaxGuess = {(Max[allResponseValues]*1.2 - 2)*Nanometer, (Max[allResponseValues]*1.2 + 2)*Nanometer};

    (* replace the automatic with our guess *)
    maxResponse/.Automatic->rMaxGuess
  ];

  (* set reversible binding to true if there is dissociation data *)
  resolvedCompletelyReversibleBinding = If[MatchQ[dissociationData, Null],
    completelyReversibleBinding/.Automatic -> Null,
    completelyReversibleBinding/.Automatic ->True
  ];

  (* --------------------- *)
  (* -- CHECK CONFLICTS -- *)
  (* --------------------- *)

  (* check that rate and response guesses are usable *)
  swappedParameterRangeOptions = {
    If[MatchQ[First[resolvedMaxResponse], GreaterEqualP[Last[resolvedMaxResponse]]],
      MaxResponse,
      Nothing
    ],
    If[MatchQ[First[resolvedAssociationRate], GreaterEqualP[Last[resolvedAssociationRate]]],
      AssociationRate,
      Nothing
    ],
    If[MatchQ[First[resolvedDissociationRate], GreaterEqualP[Last[resolvedDissociationRate]]],
      DissociationRate,
      Nothing
    ]
  };

  (* set a variable indicating the range is okay *)
  validRange = MatchQ[swappedParameterRangeOptions, {}];

  (* make the test*)
  swappedParameterRangeTests = If[gatherTests,
    {
      Test["The given guesses for the parameters are in the form {minimum, maximum}:",
        validRange,
        True
      ]
    },
    {}
  ];

  (* error if the parameter ranges are bad *)
  If[!validRange,
    If[messages, Message[Error::SwappedBindingKineticsParameterGuesses, swappedParameterRangeOptions]];
    Return[outputSpecification/.{Result->$Failed,Tests->swappedParameterRangeTests,Options->$Failed,Preview->Null}]
  ];

  (*TODO: check conflicts between the following options *)

  (*TODO: domains - check that they are not swapped and that they encapsulate part of the data*)
  (* AssociationFitDomain needs to be check against the data *)

  (* DissociationFitDomain needs to be check against the data *)

  (*TODO: if there is association data, we need concentrations*)

  (* -- REQUIRED OPTIONS -- *)

  (* if there is association data, we need to have concentrations *)
  missingConcentrationOptions = If[!MatchQ[associationData, Null]&&MatchQ[resolvedConcentrations, Null|{}],
    {Concentrations},
    {}
  ];

  (* error if the concentrations are missing *)
  If[!MatchQ[missingConcentrationOptions, {}]&&messages,
    Message[Error::MissingBindingKineticsConcentrations, missingConcentrationOptions]
  ];

  (* make the test*)
  missingConcentrationTest = If[gatherTests,
    Test["If association data is given, the concentrations are specified or resolvable:",
      MatchQ[missingConcentrationOptions, {}],
      True
    ],
    Null
  ];


  (* -- UNUSED OPTIONS -- *)

  (* unused options from no Dissociation data *)
  unusedDissociationOptions = If[MatchQ[dissociationData, Null],
    PickList[
      {CompletelyReversibleBinding, MatchDissociationStart, DissociationFitDomain},
      {resolvedCompletelyReversibleBinding, matchDissociationStart, dissociationFitDomain},
      Except[{}|Null]
    ],
    {}
  ];

  (* throw the message for unused dissociation options *)
  If[!MatchQ[unusedDissociationOptions, {}]&&messages,
    Message[Warning::UnusedBindingKineticsDissociationOptions, unusedDissociationOptions]
  ];

  (*unused association options - this is a really weird case, but it could come up if the user has load by mistake and wants to analyze dissociation*)
  unusedAssociationOptions = If[MatchQ[associationData, Null],
    PickList[
      {NormalizeAssociationStart, MatchDissociationStart, AssociationFitDomain},
      {normalizeAssociationStart, matchDissociationStart, associationFitDomain},
      Except[{}|Null]
    ],
    {}
  ];

  (* throw the message for unused association options *)
  If[!MatchQ[unusedAssociationOptions, {}]&&messages,
    Message[Warning::UnusedBindingKineticsAssociationOptions, unusedAssociationOptions]
  ];


  (* -- BASELINES -- *)
  (* AssociationBaselines *)
  (* if this is an object, get the same data that the main function is going to use *)
  resolvedAssociationBaselinesData = If[MatchQ[resolvedAssociationBaselines, {ObjectP[]..}|ObjectP[]],
    Download[resolvedAssociationBaselines, KineticsAssociationBaselines, Cache -> cache]/.{}->Null,
    resolvedAssociationBaselines
  ];

  (* DissociationBaselines *)
  (* if this is an object, get the same data that the main function is going to use *)
  resolvedDissociationBaselinesData = If[MatchQ[resolvedDissociationBaselines, {ObjectP[]..}|ObjectP[]],
    Download[resolvedDissociationBaselines, KineticsAssociationBaselines, Cache -> cache]/.{}->Null,
    resolvedDissociationBaselines
  ];

  (* -- DETERMINE MIN/MAX VALUES OF DATA/BASELINES -- *)

  (* pull out the min, max values for each element of the data *)
  associationDataMinMax = Transpose[{associationData[[All,1,1]], associationData[[All, - 1, 1]]}];
  dissociationDataMinMax = Transpose[{dissociationData[[All,1,1]], dissociationData[[All, - 1, 1]]}];

  (* pull out the min/max values for each element of the data baselines *)
  associationBaselineMinMax = If[MatchQ[resolvedAssociationBaselinesData, {_?QuantityArrayQ..}|_?QuantityArrayQ],
    Transpose[{ToList[resolvedAssociationBaselinesData][[All,1,1]], ToList[resolvedAssociationBaselinesData][[All,-1,1]]}],
    {{-1000000 Second, 1000000 Second}}
  ];
  dissociationBaselineMinMax = If[MatchQ[resolvedDissociationBaselinesData, {_?QuantityArrayQ..}|_?QuantityArrayQ],
    Transpose[{ToList[resolvedDissociationBaselinesData][[All,1,1]], ToList[resolvedDissociationBaselinesData][[All,-1,1]]}],
    {{-1000000 Second, 1000000 Second}}
  ];


  (* -- VALIDATE THE BASELINE RANGES -- *)

  (* Association Baseline *)
  (* check that the range of the baseline is equal or greater than that of the data *)
  invalidAssociationBaselinesOption = Which[

    (* if the lengths match, check that the min of the data is larger than the min of hte baseline, and the max of the data is smaller than the max of the baseline  *)
    MatchQ[Length[associationBaselineMinMax], Length[associationDataMinMax]],
    DeleteDuplicates[Flatten[MapThread[
      If[
        Or[
          MatchQ[First[#1], GreaterEqualP[First[#2]]],
          MatchQ[Last[#1], LessEqualP[Last[#2]]]
        ],
        {},
        {Baseline}
      ]&,
      {associationDataMinMax, associationBaselineMinMax}
    ]]],

    (* if the baseline has a length of 1 *)
    MatchQ[Length[associationBaselineMinMax], 1]&&MatchQ[Length[associationDataMinMax], Except[1]],
    DeleteDuplicates[Flatten[Map[
      If[
        Or[
          MatchQ[First[#], GreaterEqualP[associationBaselineMinMax[[1,1]]]],
          MatchQ[Last[#], LessEqualP[associationBaselineMinMax[[1,2]]]]
        ],
        {},
        {Baseline}
      ]&,
      associationDataMinMax
    ]]],

    (* in every other case, we are throwing a different error for a mismatch, so we dont need to error for this *)
    True,
    {}
  ];


  (* throw the error *)
  If[!MatchQ[invalidAssociationBaselinesOption, {}]&&messages,
    Message[Error::BindingQuantitationInvalidBaselineRange]
  ];

  (* make the test*)
  invalidAssociationBaselinesTest = If[gatherTests,
    Test["All sample baselines have a domain greater than or equal to the full range of the sample data they are used for:",
      MatchQ[invalidAssociationBaselinesOption, {}],
      True
    ],
    Null
  ];

  (* Dissociation Baseline *)
  (* check that the range of the baseline is equal or greater than that of the data *)
  invalidDissociationBaselinesOption = Which[

    (* if the lengths match, check that the min of the data is larger than the min of hte baseline, and the max of the data is smaller than the max of the baseline  *)
    MatchQ[Length[dissociationBaselineMinMax], Length[dissociationDataMinMax]],
    DeleteDuplicates[Flatten[MapThread[
      If[
        Or[
          MatchQ[First[#1], GreaterEqualP[First[#2]]],
          MatchQ[Last[#1], LessEqualP[Last[#2]]]
        ],
        {},
        {Baseline}
      ]&,
      {dissociationDataMinMax, dissociationBaselineMinMax}
    ]]],

    (* if the baseline has a length of 1 *)
    MatchQ[Length[dissociationBaselineMinMax], 1]&&MatchQ[Length[dissociationDataMinMax], Except[1]],
    DeleteDuplicates[Flatten[Map[
      If[
        Or[
          MatchQ[First[#], GreaterEqualP[dissociationBaselineMinMax[[1,1]]]],
          MatchQ[Last[#], LessEqualP[dissociationBaselineMinMax[[1,2]]]]
        ],
        {},
        {Baseline}
      ]&,
      dissociationDataMinMax
    ]]],

    (* in every other case, we are throwing a different error for a mismatch, so we dont need to error for this *)
    True,
    {}
  ];


  (* throw the error *)
  If[!MatchQ[invalidDissociationBaselinesOption, {}]&&messages,
    Message[Error::BindingQuantitationInvalidBaselineRange]
  ];

  (* make the test*)
  invalidDissociationBaselinesTest = If[gatherTests,
    Test["All sample baselines have a domain greater than or equal to the full range of the sample data they are used for:",
      MatchQ[invalidDissociationBaselinesOption, {}],
      True
    ],
    Null
  ];



  (* ------------------------- *)
  (* -- CHECK VALID DOMAINS -- *)
  (* ------------------------- *)

  (* check the domain dimensions and the range against the sample data *)


  (* ------------------ *)
  (* -- GATHER TESTS -- *)
  (* ------------------ *)

  allABKTests = Cases[
    Flatten[
      {
        invalidAssociationBaselinesTest,
        invalidDissociationBaselinesTest,
        missingConcentrationTest,
        swappedParameterRangeTest
      }
    ],
    _EmeraldTest
  ];

  (* ---------------------------- *)
  (* -- GATHER INVALID OPTIONS -- *)
  (* ---------------------------- *)

  (* gather all the invalid or conflicting options which have caused an error *)
  allInvalidABKOptions = DeleteDuplicates[
    Flatten[
      {
        invalidAssociationBaselinesOption,
        invalidDissociationBaselinesOption,
        missingConcentrationOptions,
        swappedParameterRangeOptions
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
  If[Length[allInvalidABKOptions]>0&&messages,
    Message[Error::InvalidOption,allInvalidABKOptions]
  ];

  (* --------------------------------- *)
  (* -- RETURN THE RESOLVED OPTIONS -- *)
  (* --------------------------------- *)

  resolvedOps = ReplaceRule[myOptions,
    {
      AssociationBaselines -> resolvedAssociationBaselines,
      DissociationBaselines -> resolvedDissociationBaselines,
      AssociationRate -> resolvedAssociationRate,
      DissociationRate -> resolvedDissociationRate,
      MaxResponse -> resolvedMaxResponse,
      AnalyteDilutions -> resolvedConcentrations,
      CompletelyReversibleBinding -> resolvedCompletelyReversibleBinding
    }
  ];

  (*Generate the result output rule: if not returning result, result rule is just Null*)
  resultRule=Result->If[MemberQ[output,Result],
    resolvedOps,
    Null
  ];

  (*Generate the tests output rule*)
  testsRule=Tests->If[gatherTests,
    allABKTests,
    Null
  ];


  (*Return the output as we desire it*)
  outputSpecification/.{resultRule,testsRule}
];





bindingEquationLookup[OneToOne,A0s_,guesses:{rMaxGuess_,assocRateGuess_,dissocRateGuess_},offset_,R0s_]:=  <|
    Equations -> {
      A'[t]==0,
      R'[t] == (10^ka)*A[t]*Rmax - R[t]*((10^ka)*A[t]+(10^kd)),
      WhenEvent[t>offset,{A[t]->0}]
    },
    InitialValues-> MapThread[{R->#1,A->Unitless[#2,Molar]}&,{R0s,A0s}],
    ObservedSpecies->Table[{R},Length[A0s]],
    Parameters -> {Rmax -> Unitless[rMaxGuess,Nanometer], ka -> Log10[assocRateGuess], kd -> Log10[dissocRateGuess]}
  |>;


bindingEquationLookup[MassTransport,A0s_,guesses:{rMaxGuess_,assocRateGuess_,dissocRateGuess_},offset_,R0s_]:=  <|
    Equations -> {
      A'[t]==0,
      R'[t] == ((10^ka)*A[t])/(1 + (10^ka)/(10^km)*(Rmax - R[t]))*(Rmax - R[t]) - (10^kd)/(1 + (10^ka)/(10^km)*(Rmax - R[t]))*R[t],
      WhenEvent[t>offset,{A[t]->0}]
    },
    InitialValues-> MapThread[{R->#1,A->Unitless[#2,Molar]}&,{R0s,A0s}],
    ObservedSpecies->Table[{R},Length[A0s]],
    Parameters -> {Rmax -> Unitless[rMaxGuess,Nanometer], ka -> Log10[assocRateGuess], kd -> Log10[dissocRateGuess], km ->  {-10,10}}
  |>;

  bindingEquationLookup[BivalentAnalyte,A0s_,guesses:{rMaxGuess_,assocRateGuess_,dissocRateGuess_},offset_,R0s_]:=  <|
      Equations -> {
 	      A'[t] == 0,
 	      R1'[t] == 2*(10^ka1)*A[t]*(Rmax - R1[t] - 2*R2[t]) - (10^kd1)*R1[t] - R2'[t],
 	      R2'[t] == (10^ka2)*R1[t]*(Rmax - R1[t] - 2*R2[t]) - 2*(10^kd2)*R2[t],
 	      R[t] == R1[t] + R2[t],
 	      WhenEvent[t > offset, {A[t] -> 0}]
 },
      InitialValues-> MapThread[{R->#1,R1->#1,R2->0,A->Unitless[#2,Molar]}&,{R0s,A0s}],
      ObservedSpecies->Table[{R},Length[A0s]],
      Parameters -> {Rmax -> Unitless[rMaxGuess,Nanometer], ka1 -> Log10[assocRateGuess], kd1 -> Log10[dissocRateGuess], ka2 -> Log10[assocRateGuess], kd2 -> Log10[dissocRateGuess]}
    |>;

    bindingEquationLookup[HeterogeneousLigand,A0s_,guesses:{rMaxGuess_,assocRateGuess_,dissocRateGuess_},offset_,R0s_]:=  <|
        Equations -> {
 	        A'[t] == 0,
 	        R1'[t] == (10^ka1)*A[t]*R1max - R1[t]*((10^ka1)*A[t] + (10^kd1)),
 	        R2'[t] == (10^ka2)*A[t]*R2max - R2[t]*((10^ka2)*A[t] + (10^kd2)),
 	        R[t] == R1[t]*(pf/(pf + 1)) + R2[t]*(1 - (pf/(pf + 1))),
 	        WhenEvent[t > offset, {A[t] -> 0}]
        },
        InitialValues-> MapThread[{R->#1, R1 -> #1*(pf/(pf+1)),R2 -> #1*(1-(pf/(pf+1))),A->Unitless[#2,Molar]}&,{R0s,A0s}],
        ObservedSpecies->Table[{R},Length[A0s]],
        Parameters -> {pf->{0,1}, Rmax2 -> Unitless[rMaxGuess,Nanometer], ka1 -> Log10[assocRateGuess], kd1 -> Log10[dissocRateGuess], ka2 -> Log10[assocRateGuess], kd2 -> Log10[dissocRateGuess]}
      |>



(* ::Subsection::Closed:: *)
