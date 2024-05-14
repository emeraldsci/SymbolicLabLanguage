(* ::Package:: *)

(* ::Title:: *)
(*Experiment MeasureConductivity: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentMeasureConductivity*)


(* ::Subsection:: *)
(*Options*)


DefineOptions[
  ExperimentMeasureConductivity,
  Options :> {
    {
      OptionName -> Instrument,
      Default -> Model[Instrument, ConductivityMeter, "SevenExcellence Conductivity"],
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Instrument, ConductivityMeter], Model[Instrument, ConductivityMeter]}]
      ],
      Description -> "The conductivity meter which communicates with the probe in order to take conductivity measurements."
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> Probe,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Part, ConductivityProbe]}]
        ],
        Description -> "For each sample, the conductivity probe which is immersed in each sample for conductivity measurement.",
        ResolutionDescription -> "Automatically set to the 4 electrode probe will be chosen automatically if there is more than 5 mL, otherwise, it will pick the 2 electrode probe."
      },
      {
        OptionName -> NumberOfReadings,
        Default -> 3,
        AllowNull -> False,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[1, 10, 1]],
        Description -> "For each sample, the number of times the conductivity of each aliquot or sample will be read by taking another recording."
      }
    ],
    {
      OptionName -> NumberOfReplicates,
      Default -> Null,
      Description -> "The number of times sample will be additionally aliquoted to the different container to obtain additional measurements.",
      AllowNull -> True,
      Widget -> Widget[Type -> Number, Pattern :> RangeP[2, 10, 1]]
    },
    {
      OptionName -> CalibrationStandard,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
      ],
      Description -> "When measuring the conductivity standard the probe cell constant value is adjusted until the measured conductivity value matches the CalibrationConductivity option.",
      ResolutionDescription -> "Automatically set to Model[Sample, \"Conductivity Standard 1413 \[Micro]S, Sachets\"]. If CalibrationConductivity is specified, automatically set to the nearest available calibration standard.",
      Category -> "Calibration"
    },
    {
      OptionName -> CalibrationConductivity,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[10 * Micro Siemens / Centimeter, 1000 Milli Siemens / Centimeter],
        Units -> CompoundUnit[
          {1, {Micro Siemens, {Micro Siemens, Millisiemen, Siemens}}},
          {-1, {Centimeter, {Centimeter}}}
        ]
      ],
      Description -> "The probe cell constant is adjusted to match the CalibrationConductivity when measuring CalibrationStandard.",
      ResolutionDescription -> "Resolves to the conductivity of the CalibrationStandard model's Conductivity field. If the specified value does not have a matching calibration standard sample available, automatically set to the nearest available calibration standard sample's Conductivity.",
      Category -> "Calibration"
    },
    {
      OptionName -> VerificationStandard,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
      ],
      Description -> "Standard used to test the calibration by insuring that VerificationConductivity of the VerificationStandard is correct. If verification fails the failure will be recorded in the protocol object VerificationResult field, and measurement will proceed regardless.",
      ResolutionDescription -> "Automatically set to Model[Sample, \"Conductivity Standard 84\"]. If VerificationConductivity is specified, automatically set to the nearest available verification standard.",
      Category -> "Calibration"
    },
    {
      OptionName -> VerificationConductivity,
      Default -> Automatic,
      AllowNull -> False,
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[10 * Micro Siemens / Centimeter, 1000 Milli Siemens / Centimeter],
        Units -> CompoundUnit[
          {1, {Micro Siemens, {Micro Siemens, Millisiemen, Siemens}}},
          {-1, {Centimeter, {Centimeter}}}
        ]
      ],
      Description -> "The VerificationStandard is used to test the calibration by ensuring that it matches the VerificationConductivity.If verification fails the failure will be recorded in the protocol object VerificationResult field, and measurement will proceed regardless.",
      ResolutionDescription -> "Automatically set to the conductivity of the VerificationStandard model's Conductivity field. If the specified value does not have a matching verification standard sample available, automatically set to the nearest available verification standard sample's Conductivity.",
      Category -> "Calibration"
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      (* --- TemperatureCompensation --- *)
      {
        OptionName -> TemperatureCorrection,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Linear, NonLinear, None, PureWater]],
        Description -> "For each sample, the relationship between temperature and conductivity, such as Linear, NonLinear, None, or PureWater, which is optimized type of temperature algorithm. Linear should be used for the temperature correction of medium and highly conductive solutions. NonLinear should be used for natural water for temperature between 0-36\[Degree] C. PureWater should be used for the pure water measurements. None won't use any temperature compensation algorithms, and returns measured conductivity at measured temperature.",
        Category -> "TemperatureCompensation",
        ResolutionDescription -> "Automatically set to Linear. If AlphaCoefficient is specified as Null set to None."
      },
      {
        OptionName -> AlphaCoefficient,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 10, 1]],
        Description -> "For each sample, the relative change of conductivity(%) that is associated with a given change in temperature (\[Degree]C).",
        Category -> "TemperatureCompensation",
        ResolutionDescription -> "Automatically set to 2 if TemperatureCorrection is Linear and Null otherwise."
      },
      (* --- Preparation --- *)
      {
        OptionName -> SampleRinse,
        Default -> False,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "For each sample, the True/False value indicates if the probe will be rinsed with the input sample prior to measuring its conductivity.",
        Category -> "Preparation"
      },
      {
        OptionName -> SampleRinseVolume,
        Default -> Automatic,
        AllowNull -> True,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[1 Microliter, 20 Liter],
          Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
        ],
        Description -> "For each sample, the volume of a sample that should be transferred from the input samples into a fresh container used for rinsing the probe.",
        ResolutionDescription -> "Automatically set to the minimum volume required for the measurements with the conductivity probe: 5 mL for the 4 electrode probe, 150 uL for the 2 electrode probe.",
        Category -> "Preparation"
      },
      {
        OptionName -> SampleRinseStorageCondition,
        Default -> Automatic,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> (SampleStorageTypeP | Disposal | Null)],
        Description -> "For each sample, the condition under which the samples used to rinse the probe are stored after use.",
        ResolutionDescription -> "Automatically set to the Disposal if SampleRinse is True.",
        Category -> "Preparation"
      },
      {
        OptionName -> RecoupSample,
        Default -> False,
        AllowNull -> False,
        Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
        Description -> "For each sample, the True/False value indicates if the aliquots used for conductivity measurement will be transferred back into the original container after conductivity measurement.",
        Category -> "Post Processing"
      }
    ],
    FuntopiaSharedOptions,
    SamplesInStorageOption
  }
];


(* ::Subsection:: *)
(*Main Function*)


(* ::Subsubsection::Closed:: *)
(*Sample Overload*)


(*ExperimentMeasureConductivity - Error Message *)

Error::DiscardedSamples = "The following input samples `1` are discarded.";
Error::VolumeUnknown = "The following samples `1` do not have their Volume field populated. The Volume of the sample must be known in order to determine if there is enough liquid to perform a conductivity measurement.";
Error::InsufficientVolume = "The following sample(s) `1` has insufficient volume for measurement. These samples must have at least `2` in order to be measured. Please choose different samples to be measured.";
Error::SolidSamples = "The following sample(s) `1` is solid. This experiment function does not support the conductivity measurement of solids. Please choose different samples to be measured.";
Error::IncompatibleSample = "The following sample(s) `1` is not chemically compatible with any conductivity probe. Please choose different samples to be measured.";
Warning::IncompatibleSampleConductivity = "The following sample(s) `1` has a conductivity value outside any available conductivity range. Please consider choosing different samples to be measured.";
Warning::IncompatibleSampleConductivityProbe = "The following sample(s) `1` has a conductivity value outside the specified conductivity probe. Please consider choosing a different probe for the measuring.";
Warning::NoSuitableProbe = "The following sample(s) `1` have a conductivity value outside the specification of the resolved probe(s): `2`. Samples with volumes over 5 mL can use a probe capable of accurately measuring higher conductivity values.";
Error::InsufficientSampleRinseVolume = "There is not enough sample volume for the SampleRinse option for the following sample(s) `1`.";
Error::ConflictingCalibrantion = "The specified CalibrationStandard and CalibrationConductivity conflict.Please change the value of these options or let them be automatically resolved.";
Error::ConflictingVerification = "The specified VerificationStandard and VerificationConductivity conflict.Please change the value of these options or let them be automatically resolved.";
Error::ConductivityStandardUnknowConductivity = "The specified CalibrationStandard does not have Conductivity field populated. Please select another standard or populate the Conductivity field.";
Error::ConductivityVerificationStandardUnknowConductivity = "The specified VerificationStandard does not have Conductivity field populated. Please select another standard or populate the Conductivity field.";
Error::ConflictingTemperatureCorrection = "The specified TemperatureCorrection and AlphaCoefficient `1` conflict.Please change the value of these options or let them be automatically resolved.";
Error::SampleRinseStorageConditionMismatch = "The specified rinse sample storage conditions have conflicts with the specified SampleRinse option. Please change the value of SampleRinseStorageCondition or SampleRinse.";


ExperimentMeasureConductivity[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
  {
    listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples,
    myOptionsWithPreparedSamples, samplePreparationCache, safeOps, safeOpsTests, validLengths, validLengthTests, outVerificationConductivity,
    templatedOptions, templateTests, inheritedOptions, expandedSafeOps, cacheBall, resolvedOptionsResult, resolvedOptions,
    resolvedOptionsTests, collapsedResolvedOptions, protocolObject, resourcePackets, resourcePacketTests, objectSamplePacketFields,
    mySamplesList, probeModels, instrumentLookup, specifiedInstrumentObjects, potentialContainers, aliquotContainerLookup,
    potentialContainersWAliquot, calibrationStandard, verificationStandard, probeLookup, specifiedProbeObjects, conductivityStandardsList,
    smallVolumeProbe, regularProbe, convertedConductivity, inputConductivity, standardsList, outConductivity, allStandardsConductivities,
    listedSamples, containerModelPreparationPackets, samplePrepPacketFilds,
    mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, safeOpsNamed
  },

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Make sure we're working with a list of options and samples*)
  {listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Simulate our sample preparation. *)
  validSamplePreparationResult = Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCache} = simulateSamplePreparationPackets[
      ExperimentMeasureConductivity,
      listedSamples,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult, $Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed, safeOpsTests} = If[gatherTests,
    SafeOptions[ExperimentMeasureConductivity, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentMeasureConductivity, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
  ];

  (* Call sanitize-inputs to clean any named objects *)
  {mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentMeasureConductivity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentMeasureConductivity, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
  ];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions, templateTests} = If[gatherTests,
    ApplyTemplateOptions[ExperimentMeasureConductivity, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentMeasureConductivity, {ToList[mySamplesWithPreparedSamples]}, myOptionsWithPreparedSamples], Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests],
      Options -> $Failed,
      Preview -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions = ReplaceRule[safeOps, templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentMeasureConductivity, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)

  (*listify the samples as needed*)
  mySamplesList = mySamplesWithPreparedSamples;

  (* Hardcoded list of all probes available in SLL *)
  {smallVolumeProbe, regularProbe} = {Model[Part, ConductivityProbe, "InLab 751-4mm"], Model[Part, ConductivityProbe, "InLab 731-ISM"]};

  (* Search for all conductivity standards available in SLL *)
  conductivityStandardsList = Search[Model[Sample], StringContainsQ[Name, "Conductivity Standard"]];

  (*Get conductivity of all standards in Microsiemen/Centimeter for the *)
  allStandardsConductivities = Unitless[UnitConvert[Mean /@ Download[conductivityStandardsList, Conductivity, Date -> Now], Microsiemen / Centimeter]];

  (* All available probes models*)
  probeModels = Join[{smallVolumeProbe, regularProbe}];

  (*check if the user supplied a instrument *)
  instrumentLookup = Lookup[myOptionsWithPreparedSamples, Instrument];

  (* Get any objects that were specified in the instrument list. *)
  specifiedInstrumentObjects = Cases[instrumentLookup, ObjectP[Object[Instrument, ConductivityMeter]]];

  (*check if the user supplied a instrument *)
  probeLookup = Lookup[myOptionsWithPreparedSamples, Probe];

  (* Get any objects that were specified in the instrument list. *)
  specifiedProbeObjects = Cases[probeLookup, ObjectP[Object[Part, ConductivityProbe]]];

  (* Get all the potential preferred containers*)
  potentialContainers = preferredConductivityContainer[All];

  (*obtain other needed look ups*)
  aliquotContainerLookup = Lookup[listedOptions, AliquotContainer];

  (*if it's a compatible type, then add to the download*)
  potentialContainersWAliquot = If[MatchQ[aliquotContainerLookup, ObjectP[{Model[Container, Vessel]}]], Union[potentialContainers, {aliquotContainerLookup}], potentialContainers];

  (*---resolve CalibrationConductivity if it's specified---*)
  outConductivity = If[
    MatchQ[Lookup[safeOps, CalibrationConductivity], RangeP[10 * Micro Siemens / Centimeter, 10000 Milli Siemens / Centimeter]],

    Module[{inputConductivity, convertedConductivity},

      (*get specified by user conductivity*)
      inputConductivity = Lookup[safeOps, CalibrationConductivity];

      (*convert conductivity to Microsiemen/Centimeter*)
      convertedConductivity = Unitless@UnitConvert[inputConductivity, Microsiemen / Centimeter];

      (*get closest conductivity*)
      First@NearestTo[convertedConductivity][allStandardsConductivities]
    ]
  ];

  outVerificationConductivity = If[
    MatchQ[Lookup[safeOps, VerificationConductivity], RangeP[10 * Micro Siemens / Centimeter, 10000 Milli Siemens / Centimeter]],

    Module[{inputConductivity, convertedConductivity},

      (*get specified by user conductivity*)
      inputConductivity = Lookup[safeOps, VerificationConductivity];

      (*convert conductivity to Microsiemen/Centimeter*)
      convertedConductivity = Unitless@UnitConvert[inputConductivity, Microsiemen / Centimeter];

      (*get closest conductivity*)
      Min@NearestTo[convertedConductivity][allStandardsConductivities]
    ]
  ];

  (* Lookup calibration standard. *)
  calibrationStandard = Cases[ToList[Lookup[safeOps, CalibrationStandard]], ObjectP[]];

  (* Lookup verification standard. *)
  verificationStandard = Cases[ToList[Lookup[safeOps, VerificationStandard]], ObjectP[]];

  objectSamplePacketFields = Packet @@ Union[{Conductivity, IncompatibleMaterials}, SamplePreparationCacheFields[Object[Sample]]];
  containerModelPreparationPackets = Packet[Container[Model[SamplePreparationCacheFields[Model[Container]]]]];
  samplePrepPacketFilds = Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]];

  cacheBall = FlattenCachePackets[{
    samplePreparationCache,
    Quiet[Download[
      {
        mySamplesList,
        probeModels,
        specifiedInstrumentObjects,
        specifiedProbeObjects,
        potentialContainersWAliquot,
        Cases[ToList@calibrationStandard, ObjectP[Object[Sample]]],
        Cases[ToList@calibrationStandard, ObjectP[Model[Sample]]],
        Cases[ToList@verificationStandard, ObjectP[Object[Sample]]],
        Cases[ToList@verificationStandard, ObjectP[Model[Sample]]],
        conductivityStandardsList
      },
      {
        {
          Evaluate@objectSamplePacketFields,
          Evaluate@containerModelPreparationPackets

        },
        {
          Packet[Name, Object, Objects, WettedMaterials, MinConductivity, MaxConductivity, MinSampleVolume, MinDepth]
        },
        {
          Packet[Name, Model]
        },
        {
          Packet[Name, Model]
        },
        {
          Evaluate@samplePrepPacketFilds
        },
        {
          Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
        },
        {
          Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
        },
        {
          Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
        },
        {
          Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
        },
        {
          Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
        }
      },
      Cache -> Flatten[{samplePreparationCache, ToList[Lookup[safeOps, Cache, {}]]}],
      Date -> Now
    ],
      {Download::FieldDoesntExist, Download::NotLinkField}]
  }];

  (* Build the resolved options *)
  resolvedOptionsResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions, resolvedOptionsTests} = resolveExperimentMeasureConductivityOptions[ToList[mySamples], expandedSafeOps, Cache -> cacheBall, Output -> {Result, Tests}];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      {resolvedOptions, resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions, resolvedOptionsTests} = {resolveExperimentMeasureConductivityOptions[ToList[mySamples], expandedSafeOps, Cache -> cacheBall], {}},
      $Failed,
      {Error::InvalidInput, Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentMeasureConductivity,
    resolvedOptions,
    Ignore -> ToList[myOptions],
    Messages -> False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult, $Failed],
    Return[outputSpecification /. {
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentMeasureConductivity, collapsedResolvedOptions],
      Preview -> Null
    }]
  ];

  (* Build packets with resources *)
  {resourcePackets, resourcePacketTests} = If[gatherTests,
    measureConductivityResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Cache -> cacheBall, Output -> {Result, Tests}],
    {measureConductivityResourcePackets[ToList[mySamplesWithPreparedSamples], expandedSafeOps, resolvedOptions, Cache -> cacheBall], {}}
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output, Result],
    Return[outputSpecification /. {
      Result -> Null,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentMeasureConductivity, collapsedResolvedOptions],
      Preview -> Null
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = If[!MatchQ[resourcePackets, $Failed] && !MatchQ[resolvedOptionsResult, $Failed],
    UploadProtocol[
      resourcePackets,
      Upload -> Lookup[safeOps, Upload],
      Confirm -> Lookup[safeOps, Confirm],
      ParentProtocol -> Lookup[safeOps, ParentProtocol],
      ConstellationMessage -> Object[Protocol, MeasureConductivity],
      Cache -> samplePreparationCache
    ],
    $Failed
  ];

  (* Return requested output *)
  outputSpecification /. {
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests(*,resourcePacketTests*)}],
    Options -> RemoveHiddenOptions[ExperimentMeasureConductivity, collapsedResolvedOptions],
    Preview -> Null
  }
];


(* ::Subsubsection::Closed:: *)
(*Container Overload*)


(* Note: The container overload should come after the sample overload. *)
ExperimentMeasureConductivity[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
  {
    listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult, mySamplesWithPreparedSamples,
    myOptionsWithPreparedSamples, samplePreparationCache, containerToSampleResult, containerToSampleOutput, updatedCache, samples, sampleCache,
    sampleOptions, containerToSampleTests, listedContainers
  },

  (* Determine the requested return value from the function *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests = MemberQ[output, Tests];

  (* Make sure we're working with a list of options *)
  {listedContainers, listedOptions} = removeLinks[ToList[myContainers], ToList[myOptions]];

  (* First, simulate our sample preparation. *)
  validSamplePreparationResult = Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache} = simulateSamplePreparationPackets[
      ExperimentMeasureConductivity,
      listedContainers,
      listedOptions
    ],
    $Failed,
    {Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult, $Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests} = containerToSampleOptions[
      ExperimentMeasureConductivity,
      mySamplesWithPreparedSamples,
      myOptionsWithPreparedSamples,
      Output -> {Result, Tests},
      Cache -> samplePreparationCache
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      containerToSampleOutput = containerToSampleOptions[
        ExperimentMeasureConductivity,
        mySamplesWithPreparedSamples,
        myOptionsWithPreparedSamples,
        Output -> Result,
        Cache -> samplePreparationCache
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];

  (* Update our cache with our new simulated values. *)
  (* It is important the sample preparation cache appears first in the cache ball. *)
  updatedCache = Flatten[{
    samplePreparationCache,
    Lookup[listedOptions, Cache, {}]
  }];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult, $Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification /. {
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions, sampleCache} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentMeasureConductivity[samples, ReplaceRule[sampleOptions, Cache -> Flatten[{updatedCache, sampleCache}]]]
  ]
];


(* ::Subsubsection::Closed:: *)
(*Resolver*)


DefineOptions[
  resolveExperimentMeasureConductivityOptions,
  Options :> {HelperOutputOption, CacheOption}
];

resolveExperimentMeasureConductivityOptions[mySamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentMeasureConductivityOptions]] := Module[
  {
    outputSpecification, output, gatherTests, cache, samplePrepOptions, measureConductivityOptions, simulatedSamples, resolvedSamplePrepOptions,
    simulatedCache, samplePrepTests, measureConductivityOptionsAssociation, invalidInputs, invalidOptions, targetContainers, resolvedAliquotOptions,
    aliquotTests, mapThreadFriendlyOptions, smallVolumeProbe, regularProbe, samplePackets, allProbeModelPackets, containerModelPackets,
    allProbeObjectPackets, calibrationStandardPacket, instrumentPacket, smallVolumeProbeConductivity, allProbeObjectDownloadValues, standardsPackets,
    allStandardDownloadValues, parentProtocol, instrument, probe, calibrationStandard, verificationStandard, numberOfReplicates, sampleRinse,
    aliquotContainer, allDownloadValues, objectSamplePacketFields, potentialContainersWAliquot, potentialContainers, specifiedProbeObjects,
    specifiedInstrumentObjects, probeModels, allSampleDownloadValues, allProbeModelDownloadValues, allInstrumentObjDownloadValues,
    potentialContainerDownloadValues, calibrationObjectDownloadValues, calibrationModelDownloadValues, verificationObjectDownloadValues,
    verificationModelDownloadValues, smallVolumeProbePacket, regularProbePacket, aliquotVolume, conductivityStandardsList, conductivityStandardsConductivities, conductivityStandardsConductivityValues,
    resolvedVerificationConductivity, verificationStandardPacket, name, confirm, template, samplesInStorageCondition, operator, upload, email,
    outputOption, numberOfReadings, calibrationConductivity, verificationConductivity, convertedConductivity, inputConductivity, standardsList,
    outConductivity, allStandardsConductivities, outVerificationConductivity, discardedSamplePackets, discardedInvalidInputs, discardedTest,
    solidSamplePackets, solidInvalidInputs, solidSampleTests, nullVolSampleTests, nullVolInvalidInputs, nullVolSamplePackets, minVolumeLookup,
    lowestVolume, lowVolumeBool, lowVolPackets, lowVolInvalidInputs, lowVolSampleTests, incompatibleInputsBool, incompatibleBoolMatrix, incompatibleBool, incompatibleInputConductivityBool, incompatibleBoolMaterials, incompatibleBoolConductivity, incompatibleBoolConductivityMatrix,
    sampleProbeCombinations, probeModel, probeModelPackets, incompatibleWithProbeBool, incompatibleWithProbeBoolMaterials, incompatibleWithProbeBoolConductivity, incompatibleWithProbeInputsBool, incompatibleInputWithProbeConductivityBool,
    incompatibleInputsAnyProbe, incompatibleInputsAnyProbeTests, incompatibleInputsConductivityAnyProbeTests, incompatibleInputsConductivityAnyProbe, incompatibleInputsConductivitySpecificProbe, incompatibleInputsConductivitySpecificProbeTests,
    nullConductivityStandardTests,
    nullConductivityInvalidInputs, nullConductivityStandardPacket, validNameTest, validNameQ, nameInvalidOptions, roundedMeasureConductivityOptions,
    precisionTest, calibrationStandardCodnuctivityLookup, conflictingCalibrantionQ, calibrantionInvalidOptions, conflictingCalibrationTest,
    verificationStandardCodnuctivityLookup, conflictingVerificationQ, verificationInvalidOptions, conflictingVerificationTest,
    probeInstrumentConflictInputs, probeInstrumentConflictOptions, conflictingInstrumentProbeTest, lowSampleRinseVolumePackets,
    lowSampleRinseVolumeInvalidInputs, lowSampleRinseVolumeSampleTests, temperatureCorrectionCombinedOptions, temperatureCorrectionInvalidOptions,
    conflictingTemperatureCorrectionTest, noSuitableProbeInputs, noSuitableProbeProbes, noSuitableProbeTests, nullConductivityVerificationPacket,
    nullVerificationConductivityInvalidInputs, nullConductivityVerificationStandardTests, conflictingSampleRinseStorageConditionsBoolList,
    aliquotVolumeList, aliquotContainersList, probeList, numberOfReplicatesList, recoupSampleList, probePrimeList, aquisitionTimeList, noSuitableProbeList,
    acquisitionTime, aliquotOptionNames, aliquotTuples, aliquotBool, sampleRinseVolumeList, lowSampleRinseVolumeBoolList, minVolume, regularVolume,
    sampleRinseList, imageSample, recoupSample, temperatureCorrectionsList, alphaCoefficientsList, numberOfReadingsList,
    conflictingTemperatureCorrectionBoolList, resolvedOptions, allTests, resolvedPostProcessingOptions, resolvedImageSample, originalCache,
    alphaCoefficients, temperatureCorrections, resolvedCalibrationStandard, resolvedCalibrationConductivity, resolvedMeasureVolume,
    resolvedMeasureWeight, measureVolume, measureWeight, resolvedVerificationStandard, validSampleRinseStorageConditionTest,
    invalidSampleRinseStorageConditionOptions, resolvedSampleRinseStorageConditionList, samplePrepPacketFilds, containerModelPreparationPackets
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];

  (* Seperate out our MeasureConductivity options from our Sample Prep options. *)
  {samplePrepOptions, measureConductivityOptions} = splitPrepOptions[myOptions];

  (* Resolve our sample prep options *)
  {{simulatedSamples, resolvedSamplePrepOptions, simulatedCache}, samplePrepTests} = If[gatherTests,
    resolveSamplePrepOptions[ExperimentMeasureConductivity, mySamples, samplePrepOptions, Cache -> cache, Output -> {Result, Tests}],
    {resolveSamplePrepOptions[ExperimentMeasureConductivity, mySamples, samplePrepOptions, Cache -> cache, Output -> Result], {}}
  ];

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  measureConductivityOptionsAssociation = Association[measureConductivityOptions];

  (* pull out the options that are defaulted and shared option *)
  {
    instrument,
    probe,
    numberOfReplicates,
    parentProtocol,
    aliquotContainer,
    aliquotVolume,
    name,
    confirm,
    template,
    samplesInStorageCondition,
    operator,
    upload,
    email,
    outputOption,
    imageSample,
    originalCache,
    alphaCoefficients,
    temperatureCorrections,
    calibrationConductivity,
    verificationConductivity
  } = Lookup[myOptions, {
    Instrument,
    Probe,
    NumberOfReplicates,
    ParentProtocol,
    AliquotContainer,
    AliquotAmount,
    Name,
    Confirm,
    Template,
    SamplesInStorageCondition,
    Operator,
    Upload,
    Email,
    Output,
    ImageSample,
    Cache,
    AlphaCoefficient,
    TemperatureCorrection,
    CalibrationConductivity,
    VerificationConductivity
  }];

  (* Hardcoded list of all probes available in SLL ({Model[Part, ConductivityProbe, "InLab 751-4mm"], Model[Part, ConductivityProbe, "InLab 731-ISM"]}) *)
  {smallVolumeProbe, regularProbe} = {Model[Part, ConductivityProbe, "id:N80DNj1d751l"], Model[Part, ConductivityProbe, "id:J8AY5jDJbqZ7"]};

  (* Search for all conductivity standards available in SLL *)
  conductivityStandardsList = Search[Model[Sample], StringContainsQ[Name, "Conductivity Standard"]];

  (*Get conductivity of all standards in Microsiemen/Centimeter for the *)
  allStandardsConductivities = Unitless[UnitConvert[Mean /@ Download[conductivityStandardsList, Conductivity, Date -> Now], Microsiemen / Centimeter]];


  (* All available probes models*)
  probeModels = Join[{smallVolumeProbe, regularProbe}];

  (* Get any objects that were specified in the instrument list. *)
  specifiedInstrumentObjects = Cases[instrument, ObjectP[Object[Instrument, ConductivityMeter]]];

  (* Get any objects that were specified in the probe list. *)
  specifiedProbeObjects = Cases[probe, ObjectP[Object[Part, ConductivityProbe]]];

  (* Get any objects that were specified in the probe list. *)
  specifiedProbeObjects = Cases[probe, ObjectP[Object[Part, ConductivityProbe]]];

  (* Get all the potential preferred containers*)
  potentialContainers = preferredConductivityContainer[All];

  (*if it's a compatible type, then add to the download*)
  potentialContainersWAliquot = If[MatchQ[aliquotContainer, ObjectP[{Model[Container, Vessel]}]], Union[potentialContainers, {aliquotContainerLookup}], potentialContainers];

  objectSamplePacketFields = Packet @@ Union[Flatten[{Conductivity, IncompatibleMaterials, SamplePreparationCacheFields[Object[Sample]]}]];

  (*---resolve CalibrationConductivity if it's specified---*)
  outConductivity = If[
    MatchQ[Lookup[myOptions, CalibrationConductivity], RangeP[10 * Micro Siemens / Centimeter, 10000 Milli Siemens / Centimeter]],

    Module[{inputConductivity, convertedConductivity},

      (*get specified by user conductivity*)
      inputConductivity = Lookup[myOptions, CalibrationConductivity];

      (*convert conductivity to Microsiemen/Centimeter*)
      convertedConductivity = Unitless@UnitConvert[inputConductivity, Microsiemen / Centimeter];

      (*get closest conductivity*)
      First@NearestTo[convertedConductivity][allStandardsConductivities]
    ]
  ];

  outVerificationConductivity = If[
    MatchQ[Lookup[myOptions, VerificationConductivity], RangeP[10 * Micro Siemens / Centimeter, 10000 Milli Siemens / Centimeter]],

    Module[{inputConductivity, convertedConductivity},

      (*get specified by user conductivity*)
      inputConductivity = Lookup[myOptions, VerificationConductivity];

      (*convert conductivity to Microsiemen/Centimeter*)
      convertedConductivity = Unitless@UnitConvert[inputConductivity, Microsiemen / Centimeter];

      (*get closest conductivity*)
      Min@NearestTo[convertedConductivity][allStandardsConductivities]
    ]
  ];

  (* Lookup calibration standard. *)
  calibrationStandard = Switch[Lookup[myOptions, {CalibrationStandard, CalibrationConductivity}],
    {Automatic, Automatic}, Model[Sample, "id:eGakldJ6WqD4"], (*"Conductivity Standard 1413 \[Micro]S, Sachets"*)
    {Automatic, _}, FirstOrDefault[PickList[conductivityStandardsList, allStandardsConductivities, EqualP[outConductivity]]],
    {_, _}, Lookup[myOptions, CalibrationStandard]
  ];

  (* Lookup verification standard. *)
  verificationStandard = Switch[Lookup[myOptions, {VerificationStandard, VerificationConductivity}],
    {Automatic, Automatic}, Model[Sample, "id:AEqRl9qdZzlp"], (* "Conductivity Standard 84 \[Micro]S" *)
    {Automatic, _}, FirstOrDefault[PickList[conductivityStandardsList, allStandardsConductivities, EqualP[outVerificationConductivity]]],
    {_, _}, Lookup[myOptions, VerificationStandard]
  ];

  samplePrepPacketFilds = SamplePreparationCacheFields[Model[Container]];
  containerModelPreparationPackets = Packet[Container[Model[SamplePreparationCacheFields[Model[Container]]]]];

  (* Extract the packets that we need from our downloaded cache. *)
  allDownloadValues = Replace[Quiet[Download[
    {
      simulatedSamples,
      probeModels,
      specifiedProbeObjects,
      specifiedInstrumentObjects,
      potentialContainersWAliquot,
      Cases[ToList@calibrationStandard, ObjectP[Object[Sample]]],
      Cases[ToList@calibrationStandard, ObjectP[Model[Sample]]],
      Cases[ToList@verificationStandard, ObjectP[Object[Sample]]],
      Cases[ToList@verificationStandard, ObjectP[Model[Sample]]],
      conductivityStandardsList
    },
    {
      {
        Evaluate@objectSamplePacketFields,
        Evaluate@containerModelPreparationPackets
      },
      {
        Packet[Name, Object, Objects, WettedMaterials, MinConductivity, MaxConductivity, MinSampleVolume, MinDepth]
      },
      {
        Packet[Name, Model]
      },
      {
        Packet[Name, Model]
      },
      {
        samplePrepPacketFilds
      },
      {
        Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
      },
      {
        Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
      },
      {
        Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
      },
      {
        Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
      },
      {
        Packet[Conductivity, TransportWarmed, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, Products, Container]
      }
    },
    Cache -> simulatedCache,
    Date -> Now
  ],
    {Download::FieldDoesntExist, Download::NotLinkField}], $Failed -> Nothing, 1];

  (*split the download packet based on object type*)
  {
    allSampleDownloadValues,
    allProbeModelDownloadValues,
    allProbeObjectDownloadValues,
    allInstrumentObjDownloadValues,
    potentialContainerDownloadValues,
    calibrationObjectDownloadValues,
    calibrationModelDownloadValues,
    verificationObjectDownloadValues,
    verificationModelDownloadValues,
    allStandardDownloadValues
  } = allDownloadValues;

  (*pull out the sample packets*)
  samplePackets = allSampleDownloadValues[[All, 1]];

  (*get all of the probe model packets*)
  allProbeModelPackets = allProbeModelDownloadValues[[All, 1]];

  (* get packets for smallVolumeProbe and regularProbe *)
  smallVolumeProbePacket = allProbeModelDownloadValues[[1, 1]];
  regularProbePacket = allProbeModelDownloadValues[[2, 1]];

  (*get all of the container model packets*)
  containerModelPackets = allSampleDownloadValues[[All, 2]];

  (* get all standards packets *)
  standardsPackets = allStandardDownloadValues[[All, 1]];

  (* get calibration standard packet *)
  calibrationStandardPacket = If[MatchQ[calibrationStandard, ObjectP[Model[Sample]]],
    calibrationModelDownloadValues[[All, 1]],
    calibrationObjectDownloadValues[[All, 1]]
  ];

  (* get verification standard packet *)
  verificationStandardPacket = If[MatchQ[verificationStandard, ObjectP[Model[Sample]]],
    verificationModelDownloadValues[[All, 1]],
    verificationObjectDownloadValues[[All, 1]]
  ];

  (* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

  (*-- INPUT VALIDATION CHECKS --*)

  (* 1. DISCARDED SAMPLES *)
  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets = Cases[Flatten[samplePackets], KeyValuePattern[Status -> Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
    {},
    Lookup[discardedSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs] > 0 && !gatherTests,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> simulatedCache]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest = If[gatherTests,
    Module[{failingTest, passingTest},

      failingTest = If[Length[discardedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> simulatedCache] <> " are not discarded:", True, False]
      ];

      passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> simulatedCache] <> " are not discarded:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* 2. SOLID SAMPLES *)
  (* Get the samples from mySamples that are solids. *)
  solidSamplePackets = Cases[samplePackets, KeyValuePattern[State -> Solid]];

  (* Set solidInvalidInputs to the input objects whose states are Solid *)
  solidInvalidInputs = If[MatchQ[solidSamplePackets, {}],
    {},
    Lookup[solidSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[And[Length[solidInvalidInputs] > 0, !gatherTests, NullQ[parentProtocol]],
    Message[Error::SolidSamples, solidInvalidInputs]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  solidSampleTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[solidInvalidInputs] == 0,
        Nothing,
        Test["The input sample(s) " <> ObjectToString[solidInvalidInputs, Cache -> simulatedCache] <> " are not solids:", True, False]
      ];

      passingTest = If[Length[solidInvalidInputs] == Length[mySamples],
        Nothing,
        Test["The input sample(s) " <> ObjectToString[Complement[mySamples, solidInvalidInputs], Cache -> simulatedCache] <> " are not solids:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* 3. NO VOLUME SAMPLES *)
  (* Get the samples from mySamples that have no volume. *)
  nullVolSamplePackets = Cases[samplePackets, KeyValuePattern[Volume -> Null]];

  (* Set nullVolInvalidInputs to the input objects whose volume is Null *)
  nullVolInvalidInputs = If[MatchQ[nullVolSamplePackets, {}],
    {},
    Lookup[nullVolSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[
    And[
      Length[nullVolInvalidInputs] > 0,
      !gatherTests,
      NullQ[parentProtocol]
    ],

    Message[Error::VolumeUnknown, nullVolInvalidInputs]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nullVolSampleTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[nullVolInvalidInputs] == 0,
        Nothing,
        Test["The input sample(s) " <> ObjectToString[nullVolInvalidInputs, Cache -> simulatedCache] <> " have volumes:", True, False]
      ];

      passingTest = If[Length[nullVolInvalidInputs] == Length[mySamples],
        Nothing,
        Test["The input sample(s) " <> ObjectToString[Complement[mySamples, nullVolInvalidInputs], Cache -> simulatedCache] <> " have volumes:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* 4. LOW VOLUME SAMPLES *)
  (*lookup the lowest volume from the probe model packets*)
  minVolumeLookup = Lookup[allProbeModelPackets, MinSampleVolume];

  (*get the lowest possible volume for measurement*)
  lowestVolume = Min[Cases[minVolumeLookup, GreaterP[0 Milli Liter]]];

  (*get a boolean for which samples are low volume*)
  lowVolumeBool = Map[
    If[NullQ[#], False, MatchQ[Lookup[#, Volume], LessP[lowestVolume]]] &,
    samplePackets];

  (* Get the samples from mySamples that have too low volume *)
  lowVolPackets = PickList[samplePackets, lowVolumeBool, True];

  (* Set lowVolInvalidInputs to the input objects whose volumes are too low *)
  lowVolInvalidInputs = If[MatchQ[lowVolPackets, {}],
    {},
    Lookup[lowVolPackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[And[Length[lowVolInvalidInputs] > 0, !gatherTests,
    NullQ[parentProtocol]
  ],
    Message[Error::InsufficientVolume, ObjectToString[lowVolInvalidInputs, Cache -> simulatedCache], ObjectToString[lowestVolume]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  lowVolSampleTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[lowVolInvalidInputs] == 0,
        Nothing,
        Test["The input sample(s) " <> ObjectToString[lowVolInvalidInputs, Cache -> simulatedCache] <> " have at least 50 Microliter of volume:", True, False]
      ];

      passingTest = If[Length[lowVolInvalidInputs] == Length[mySamples],
        Nothing,
        Test["The input sample(s) " <> ObjectToString[Complement[mySamples, lowVolInvalidInputs], Cache -> simulatedCache] <> " have at least 50 Microliter of volume:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* 5. INCOMPATIBLE SAMPLE *)
  (*5a. Check if sample is compatible with all available probes*)

  (*generate the material compatibility combination of probe and samples*)
  sampleProbeCombinations = Tuples[{allProbeModelPackets, samplePackets}];

  (*get boolean for which sample/probes combinations are incompatible (based on material and conductivity)*)
  incompatibleBool = Map[
    Function[tuple,
      Not /@ compatibleConductivityProbeQ[First[tuple], Last[tuple], Cache -> simulatedCache]
    ],
    sampleProbeCombinations
  ];

  {incompatibleBoolMaterials, incompatibleBoolConductivity} = Transpose[incompatibleBool];

  (*arrange into matrix where each column is the sample and the rows are the probe*)
  incompatibleBoolMatrix = Partition[incompatibleBoolMaterials, Length[samplePackets]];
  incompatibleBoolConductivityMatrix = Partition[incompatibleBoolConductivity, Length[samplePackets]];

  (*check to see if any of the samples are compatible with no probe*)
  incompatibleInputsBool = Map[And @@ #&, Transpose[incompatibleBoolMatrix]];
  incompatibleInputConductivityBool = Map[And @@ #&, Transpose[incompatibleBoolConductivityMatrix]];

  (*-- OPTION PRECISION CHECKS --*)
  (* SampleRinseVolume *)
  {roundedMeasureConductivityOptions, precisionTest} = If[gatherTests,
    RoundOptionPrecision[measureConductivityOptionsAssociation, SampleRinseVolume, 10^-1Microliter, Output -> {Result, Tests}],
    {RoundOptionPrecision[measureConductivityOptionsAssociation, SampleRinseVolume, 10^-1Microliter], Null}
  ];

  (*---NAME OPTION CHECK---*)
  (* --- Check to see if the Name option is properly specified --- *)

  (* If the specified Name is not in the database, it is valid *)
  validNameQ = If[MatchQ[name, _String],
    Not[DatabaseMemberQ[Object[Protocol, MeasureConductivity, Lookup[roundedMeasureConductivityOptions, Name]]]],
    True
  ];

  (* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
  nameInvalidOptions = If[Not[validNameQ] && !gatherTests,
    (
      Message[Error::DuplicateName, "MeasureConductivity protocol"];
      {Name}
    ),
    {}
  ];

  (* Generate Test for Name check *)
  validNameTest = If[gatherTests && MatchQ[name, _String],
    Test["If specified, Name is not already a MeasureConductivity object name:",
      validNameQ,
      True
    ],
    Null
  ];

  (*get all of the aliquot option names -- AliquotPreparation,ConsolidateAliquots are impertinent *)
  aliquotOptionNames = Complement[Map[ToExpression, Keys@Options[AliquotOptions]], {AliquotPreparation, ConsolidateAliquots}];

  (*get the aliquot options for each sample*)
  aliquotTuples = MapThread[List, Lookup[samplePrepOptions, aliquotOptionNames]];

  (*If any of the aliquot options were set positively, then this should be true*)
  aliquotBool = Map[MemberQ[#, Except[False | Null | Automatic]]&, aliquotTuples];

  (*-- RESOLVE EXPERIMENT OPTIONS --*)
  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureConductivity, roundedMeasureConductivityOptions];

  (* get min sample volume for conductivity measurements from small volume probe and regular probe *)
  minVolume = Lookup[smallVolumeProbePacket, MinSampleVolume];
  regularVolume = Lookup[regularProbePacket, MinSampleVolume];

  (* get max measureble conductivity for smallVolumeProbe *)
  smallVolumeProbeConductivity = Lookup[smallVolumeProbePacket, MaxConductivity];

  (* MapThread over each of our samples. *)
  {
    probeList,
    aliquotVolumeList,
    aliquotContainersList,
    noSuitableProbeList,
    sampleRinseList,
    sampleRinseVolumeList,
    lowSampleRinseVolumeBoolList,
    recoupSampleList,
    temperatureCorrectionsList,
    alphaCoefficientsList,
    conflictingTemperatureCorrectionBoolList,
    conflictingSampleRinseStorageConditionsBoolList,
    resolvedSampleRinseStorageConditionList
  } = Transpose[MapThread[Function[
    {mySample, myMapThreadOptions, currentSamplePacket, aliquotOption, aliquotVolume, aliquotContainer, temperatureCorrection, alphaCoefficient},
    Module[
      {
        lowSampleRinseVolumeError, noSuitableProbe, lowVolumeError, lowSampleRinseVolumeBool, sampleVolume, sampleConductivity, sampleRinseVolume,
        probe, resolvedProbe, resolvedAcquisitionTime, resolvedAliquot, resolvedAliquotVolume, sampleRinse, resolvedAliquotContainer,
        resolvedProbePrime, resolvedSampleRinseVolume, recoupSample, resolvedAlphaCoefficient, resolvedTemperatureCorrection,
        conflictingTemperatureCorrectionBool, resolvedSampleRinse, conflictingSampleRinseStorageConditionsBool, resolvedSampleRinseStorageCondition
      },

      (* Setup our error tracking variables *)
      {lowSampleRinseVolumeBool, noSuitableProbe, lowVolumeError, conflictingTemperatureCorrectionBool, conflictingSampleRinseStorageConditionsBool} = ConstantArray[False, 5];

      (* get sample volume and conductivity if known*)
      {sampleVolume, sampleConductivity} = Lookup[currentSamplePacket, {Volume, Conductivity}];

      probe = Lookup[myMapThreadOptions, Probe] /. {x_} :> x;

      (* Resolve master switches *)
      (* if specified by user: returns spesified probe *)
      resolvedProbe = If[MatchQ[probe, Alternatives[ObjectP[Model[Part, ConductivityProbe]], ObjectP[Object[Part, ConductivityProbe]]]],
        probe,

        (* if not specified by user resolve based on sample volume: *)
        (* if more than 5 mL resolve to regular probe*)
        If[MatchQ[sampleVolume, GreaterP[regularVolume]], regularProbe,

          (* if sample has a low volume(less than 5mL), check conductivity *)
          If[MatchQ[sampleConductivity, (LessP[smallVolumeProbeConductivity] | Null)], smallVolumeProbe,

            (* if no flag noSuitableProbe but still allow the small volume probe *)
            noSuitableProbe = True;smallVolumeProbe
          ]
        ]
      ];

      (* Resolve aliquot option*)
      {resolvedAliquotVolume, resolvedAliquotContainer} = If[aliquotOption,
        Switch[
          {MatchQ[aliquotVolume, GreaterP[0 Milliliter]], MatchQ[aliquotContainer, ObjectP[{Object[Container], Model[Container]}]]},

          (*if specified both, then that's our resolution*)
          {True, True},
          {aliquotVolume, aliquotContainer},

          (*if neither are specified, resolve volume based on resolved probe and container as preferred container*)
          {False, False},
          Module[{volume},
            volume = If[MatchQ[resolvedProbe, smallVolumeProbe], minVolume, regularVolume];
            {volume, preferredConductivityContainer[volume]}
          ],

          (*if only volume specified, find an preferred container based on tFhe specified volume*)
          {True, False},
          {aliquotVolume, preferredConductivityContainer[aliquotVolume]},

          (*if only the container specified, find the volume based on ...*)
          {False, True},
          {Null, aliquotContainer}
        ],
        {Null, Null}
      ];

      recoupSample = Lookup[myMapThreadOptions, RecoupSample];

      (* resolve sample rinse *)
      {
        resolvedSampleRinse,
        resolvedSampleRinseVolume
      } = Switch[{Lookup[myMapThreadOptions, SampleRinse], Lookup[myMapThreadOptions, SampleRinseVolume]},

        (*if SampleRinse is True and SampleRinseVolume is specified*)
        {True, GreaterP[0 * Microliter]}, {Lookup[myMapThreadOptions, SampleRinse], Lookup[myMapThreadOptions, SampleRinseVolume]},

        {True, Automatic}, {
          Lookup[myMapThreadOptions, SampleRinse],
          Switch[resolvedProbe,
            smallVolumeProbe, minVolume,
            regularProbe, regularVolume
          ]
        },

        {False, GreaterP[0 * Microliter]}, {True, Lookup[myMapThreadOptions, SampleRinseVolume]},

        {False, Automatic | Null}, {False, Null}
      ];

      {
        resolvedSampleRinseStorageCondition,
        conflictingSampleRinseStorageConditionsBool
      } = Switch[{resolvedSampleRinse, Lookup[myMapThreadOptions, SampleRinseStorageCondition]},

        {True, (SampleStorageTypeP | Disposal)}, {Lookup[myMapThreadOptions, SampleRinseStorageCondition], False},

        {True, Automatic}, {Disposal, False},

        {False, (SampleStorageTypeP | Disposal)}, {Null, True},

        {False, Automatic | Null}, {Null, False}
      ];

      (*check if there is enough volume to aliquot sample(prepare SampleRinse)*)
      lowSampleRinseVolumeBool = If[
        MatchQ[resolvedSampleRinse, True],
        If[MatchQ[resolvedSampleRinseVolume, LessP[2 * sampleVolume]], False, True],
        False
      ];

      (*resolve Temperature Correction algorithm*)
      {resolvedTemperatureCorrection, resolvedAlphaCoefficient} = Switch[{temperatureCorrection, alphaCoefficient},
        (*if both specified set to specified values*)
        {Alternatives[Linear, NonLinear, None, PureWater], (RangeP[0, 10, 1] | Null)}, {temperatureCorrection, alphaCoefficient},

        (*if only temperature correction specified*)
        (*resolve alphaCoefficient to 2 if temperature correction is Linear and Null otherwise*)
        {Alternatives[Linear, NonLinear, None, PureWater], Automatic},
        {If[MatchQ[temperatureCorrection, None], Off, temperatureCorrection], If[MatchQ[temperatureCorrection, Linear], 2, Null]},

        (*if only AlphaCoefficient specified*)
        (*if AlphaCoefficient Null turn off temperature correction, otherwise set to Linear*)
        {Automatic, (RangeP[0, 10, 1] | Null)}, {If[MatchQ[alphaCoefficient, (Null | 0)], Off, Linear], alphaCoefficient},

        (*if both Automatic*)
        {Automatic, Automatic}, {Linear, 2}
      ];

      conflictingTemperatureCorrectionBool = If[
        !MatchQ[resolvedTemperatureCorrection, Linear] && MatchQ[resolvedAlphaCoefficient, RangeP[0, 10, 1]],
        True,
        False
      ];

      (* Gather MapThread results *)
      {
        resolvedProbe,
        resolvedAliquotVolume,
        resolvedAliquotContainer,
        noSuitableProbe,
        resolvedSampleRinse,
        resolvedSampleRinseVolume,
        lowSampleRinseVolumeBool,
        recoupSample,
        resolvedTemperatureCorrection,
        resolvedAlphaCoefficient,
        conflictingTemperatureCorrectionBool,
        conflictingSampleRinseStorageConditionsBool,
        resolvedSampleRinseStorageCondition
      }
    ]
  ],

    (* MapThread inputs *)
    {simulatedSamples, mapThreadFriendlyOptions, samplePackets, aliquotBool, aliquotVolume, aliquotContainer, temperatureCorrections, alphaCoefficients}
  ]];

  (* CALIBRATION AND VERIFICATION STANDARDS RESOLUTION *)

  resolvedCalibrationConductivity = If[
    MatchQ[calibrationConductivity, RangeP[10 * Micro Siemens / Centimeter, 1000 Milli Siemens / Centimeter]],
    {outConductivity Micro Siemens / Centimeter},
    Mean /@ Lookup[calibrationStandardPacket, Conductivity]
  ];

  resolvedVerificationConductivity = If[
    MatchQ[verificationConductivity, RangeP[10 * Micro Siemens / Centimeter, 1000 Milli Siemens / Centimeter]],
    {outVerificationConductivity Micro Siemens / Centimeter},
    Mean /@ Lookup[verificationStandardPacket, Conductivity]
  ];

  (* CALIBRATION STANDARD  *)
  (*---check if calibration standard model has specified conductivity---*)
  nullConductivityStandardPacket = Cases[calibrationStandardPacket, KeyValuePattern[Conductivity -> Null]];

  (* Set nullConductivityInvalidInputs to the input objects whose conductivity is Null *)
  nullConductivityInvalidInputs = If[MatchQ[nullConductivityStandardPacket, {}], {}, Lookup[nullConductivityStandardPacket, Object]];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[And[Length[nullConductivityInvalidInputs] > 0, !gatherTests, NullQ[parentProtocol]],
    Message[Error::ConductivityStandardUnknowConductivity, nullConductivityInvalidInputs]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nullConductivityStandardTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[nullConductivityInvalidInputs] == 0,
        Nothing,
        Test["The input conductivity standard(s) " <> ObjectToString[nullConductivityInvalidInputs, Cache -> simulatedCache] <> " have conductivity:", True, False]
      ];

      passingTest = If[Length[nullConductivityInvalidInputs] == Length[calibrationStandard],
        Nothing,
        Test["The input conductivity standard(s) " <> ObjectToString[Complement[{calibrationStandard}, nullConductivityInvalidInputs], Cache -> simulatedCache] <> " have conductivity:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*---check if verification standard model has specified conductivity---*)
  nullConductivityVerificationPacket = Cases[verificationStandardPacket, KeyValuePattern[Conductivity -> Null]];

  (* Set nullConductivityVerificationPacket to the input objects whose conductivity is Null *)
  nullVerificationConductivityInvalidInputs = If[MatchQ[nullConductivityVerificationPacket, {}], {}, Lookup[nullConductivityVerificationPacket, Object]];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[And[Length[nullVerificationConductivityInvalidInputs] > 0, !gatherTests, NullQ[parentProtocol]],
    Message[Error::ConductivityVerificationStandardUnknowConductivity, nullConductivityInvalidInputs]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nullConductivityVerificationStandardTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[nullVerificationConductivityInvalidInputs] == 0,
        Nothing,
        Test["The input conductivity standard(s) " <> ObjectToString[nullVerificationConductivityInvalidInputs, Cache -> simulatedCache] <> " have conductivity:", True, False]
      ];

      passingTest = If[Length[nullVerificationConductivityInvalidInputs] == Length[verificationStandard],
        Nothing,
        Test["The input conductivity standard(s) " <> ObjectToString[Complement[{verificationStandard}, nullVerificationConductivityInvalidInputs], Cache -> simulatedCache] <> " have conductivity:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*-- CONFLICTING OPTIONS CHECKS --*)
  (*---mismatching TemperatureCorrection and AlphaCoefficient check---*)

  (*combine temperature correction and alpha coefficient together*)
  temperatureCorrectionCombinedOptions = Transpose@Join[{temperatureCorrectionsList}, {alphaCoefficientsList}];

  (* Get the samples from mySamples that have too low volume for PrimeSample option*)
  temperatureCorrectionInvalidOptions = PickList[temperatureCorrectionCombinedOptions, conflictingTemperatureCorrectionBoolList, True];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[temperatureCorrectionInvalidOptions] > 0 && !gatherTests,
    Message[Error::ConflictingTemperatureCorrection, ObjectToString[temperatureCorrectionInvalidOptions, Cache -> simulatedCache]];
  ];

  conflictingTemperatureCorrectionTest = If[gatherTests,
    Module[{failingTest, passingTest},

      failingTest = If[Length[temperatureCorrectionInvalidOptions] > 0,
        Warning["The options TemperatureCorrection and AlphaCoefficient match, for the inputs " <> ObjectToString[temperatureCorrectionInvalidOptions, Cache -> simulatedCache] <> " if supplied by the user:", True, False],
        Nothing
      ];

      passingTest = If[Length[temperatureCorrectionInvalidOptions] == Length[mySamples],
        Warning["The options TemperatureCorrection and AlphaCoefficient match, for the inputs " <> ObjectToString[temperatureCorrectionInvalidOptions, Cache -> simulatedCache] <> " if supplied by the user:", True, True],
        Nothing
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*---mismatching SampleRinse and SampleRinseStorageCondition check---*)

  (*If there are SampleRinseStorageConditionMismatch error and we are throwing messages, then throw an error message*)
  invalidSampleRinseStorageConditionOptions = If[MemberQ[conflictingSampleRinseStorageConditionsBoolList, True],
    (
      Message[Error::SampleRinseStorageConditionMismatch];
      {SampleRinseStorageCondition}
    ),
    {}
  ];

  (*If we are gathering tests, create a test for SampleRinseStorageCondition mismatch*)
  validSampleRinseStorageConditionTest = If[gatherTests,
    Module[
      {failingSamples, passingSamples, failingSampleTests, passingSampleTests},

      (*Get the inputs that fail this test*)
      failingSamples = PickList[simulatedSamples, conflictingSampleRinseStorageConditionsBoolList];

      (*Get the inputs that pass this test*)
      passingSamples = PickList[simulatedSamples, conflictingSampleRinseStorageConditionsBoolList, False];

      (*Create a test for the non-passing inputs*)
      failingSampleTests = If[Length[failingSamples] > 0,
        Test["For the provided samples " <> ObjectToString[failingSamples, Cache -> simulatedCache] <> ", the SampleRinseStorageCondition does not have conflicts with specified SampleRinse option:", False, True],
        Nothing
      ];

      (*Create a test for the passing inputs*)
      passingSampleTests = If[Length[passingSamples] > 0,
        Test["For the provided samples " <> ObjectToString[passingSamples, Cache -> simulatedCache] <> ", the SampleRinseStorageCondition does not have conflicts with the specified SampleRinse option:", True, True],
        Nothing
      ];

      (*Return the created tests*)
      {failingSampleTests, passingSampleTests}
    ],
    Nothing
  ];

  (* --- conductivity of specified CalibrationStandard and CalibrationConductivity should matched ---*)

  (*lookup the conductivity of Calibration Standard from the calibration standart packet*)
  calibrationStandardCodnuctivityLookup = Mean /@ Lookup[calibrationStandardPacket, Conductivity];

  conflictingCalibrantionQ = !MatchQ[calibrationStandardCodnuctivityLookup, resolvedCalibrationConductivity];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
  calibrantionInvalidOptions = If[conflictingCalibrantionQ,
    Message[Error::ConflictingCalibrantion, ObjectToString[{calibrationStandardCodnuctivityLookup, resolvedCalibrationConductivity}, Cache -> simulatedCache]];
    {CalibrationStandard, CalibrationConductivity},
    {}
  ];

  conflictingCalibrationTest = If[gatherTests,
    Module[{failingTest, passingTest},

      failingTest = If[Length[calibrantionInvalidOptions] > 0,
        Test["The options CalibrationStandard and CalibrationConductivity match, for the inputs " <> ObjectToString[conflictingCalibrantOptions, Cache -> simulatedCache] <> " if supplied by the user:", True, False],
        Nothing
      ];

      passingTest = If[conflictingCalibrantionQ,
        Test["The options CalibrationStandard and CalibrationConductivity match, for the inputs " <> ObjectToString[{calibrationStandardCodnuctivityLookup, resolvedCalibrationConductivity}, Cache -> simulatedCache] <> " if supplied by the user:", True, True],
        Nothing
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* 7. VerificationStandard and VerificationConductivity should matched if both specified *)
  (*lookup the conductivity of Verification Standard from the verification standart packet*)
  verificationStandardCodnuctivityLookup = If[
    MatchQ[verificationStandardPacket, {}],
    resolvedVerificationConductivity,
    Mean /@ Lookup[verificationStandardPacket, Conductivity]
  ];

  conflictingVerificationQ = !MatchQ[verificationStandardCodnuctivityLookup, resolvedVerificationConductivity];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
  verificationInvalidOptions = If[conflictingVerificationQ,
    Message[Error::ConflictingVerification, ObjectToString[{verificationStandardCodnuctivityLookup, resolvedVerificationConductivity}, Cache -> simulatedCache]];
    {VerificationStandard, VerificationConductivity},
    {}
  ];

  conflictingVerificationTest = If[gatherTests,
    Module[{failingTest, passingTest},

      failingTest = If[Length[verificationInvalidOptions] > 0,
        Test["The options VerificationStandard and VerificationConductivity match, for the inputs " <> ObjectToString[verificationInvalidOptions, Cache -> simulatedCache] <> " if supplied by the user:", True, False],
        Nothing
      ];

      passingTest = If[conflictingVerificationQ,
        Test["The options VerificationStandard and VerificationConductivity match, for the inputs " <> ObjectToString[{verificationStandardCodnuctivityLookup, resolvedVerificationConductivity}, Cache -> simulatedCache] <> " if supplied by the user:", True, True],
        Nothing
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*-- UNRESOLVABLE OPTION CHECKS --*)
  (* 9. No suitable probe due to not sufficient volume for the expected conductivity range *)
  (* Get the sample packets that we can not measure because there is no suitable probe. *)
  noSuitableProbeInputs = PickList[Lookup[samplePackets, Object], noSuitableProbeList, True];
  noSuitableProbeProbes = PickList[probeList, noSuitableProbeList, True];

  (*output an error if probe can not be resolved based on sample volume and expected conductivity range *)
  If[Length[noSuitableProbeInputs] > 0 && !gatherTests,
    Message[Warning::NoSuitableProbe, ObjectToString[noSuitableProbeInputs, Cache -> simulatedCache], ObjectToString[noSuitableProbeProbes]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  noSuitableProbeTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[noSuitableProbeInputs] == 0,
        Nothing,
        Warning["The is no suitable probe for the input sample(s) " <> ObjectToString[noSuitableProbeInputs, Cache -> simulatedCache] <> " due to not sufficient volume for the expected conductivity range:", True, False]
      ];
      passingTest = If[Length[noSuitableProbeInputs] == Length[simulatedSamples],
        Nothing,
        Warning["The is no suitable probe for the input sample(s) " <> ObjectToString[Complement[simulatedSamples, noSuitableProbeInputs], Cache -> simulatedCache] <> " due to not sufficient volume for the expected conductivity range:", True, True]
      ];
      {failingTest, passingTest}
    ],
    (* if we're not gathering tests, do Nothing *)
    Nothing
  ];

  (* 9. sample volume should be greater than sum of SampleRinseVolume and MinVolum if SampleRinse is True*)
  (* Get the samples from mySamples that have too low volume for PrimeSample option*)
  lowSampleRinseVolumePackets = PickList[samplePackets, lowSampleRinseVolumeBoolList, True];

  (* Set lowPrimeVolInvalidInputs to the input objects whose volumes are too low for PrimeSample option*)
  lowSampleRinseVolumeInvalidInputs = If[MatchQ[lowSampleRinseVolumePackets, {}],
    {},
    Lookup[lowSampleRinseVolumePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[And[Length[lowSampleRinseVolumeInvalidInputs] > 0, !gatherTests, NullQ[parentProtocol]],
    Message[Error::InsufficientSampleRinseVolume, lowSampleRinseVolumeInvalidInputs]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  lowSampleRinseVolumeSampleTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[lowSampleRinseVolumeInvalidInputs] == 0,
        Nothing,
        Test["The input sample(s) " <> ObjectToString[lowSampleRinseVolumeInvalidInputs, Cache -> simulatedCache] <> " have enough volume to prime probe:", True, False]
      ];
      passingTest = If[Length[lowSampleRinseVolumeInvalidInputs] == Length[mySamples],
        Nothing,
        Test["The input sample(s) " <> ObjectToString[Complement[mySamples, lowSampleRinseVolumeInvalidInputs], Cache -> simulatedCache] <> " have enough volume to prime probe:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* 10. If the user specifies a probe, need to make sure that the sample is compatible with specified probe model*)
  (* if the user specified an object, we take the model. *)
  probeModel = (If[MatchQ[#, ObjectP[Object[Part, ConductivityProbe]]],
    Lookup[fetchPacketFromCache[#, allProbeObjectPackets], Model] /. {link_Link :> Download[link, Object]},
    #
  ]&) /@ probeList;

  (*get the model packets for each model*)
  probeModelPackets = (If[MatchQ[#, ObjectP[Model[Part, ConductivityProbe]]],
    fetchPacketFromCache[#, allProbeModelPackets],
    #
  ]&) /@ probeModel;

  (*see if the model is incompatible with the given sample (based on material and conductivity)*)
  incompatibleWithProbeBool = MapThread[
    Function[
      {probeModelPacket, samplePacket},
      If[MatchQ[probeModelPacket, ObjectP[Model[Part, ConductivityProbe]]],
        Not /@ compatibleConductivityProbeQ[probeModelPacket, samplePacket, Cache -> simulatedCache],
        {False, False}
      ]
    ], {probeModelPackets, samplePackets}
  ];


  {incompatibleWithProbeBoolMaterials, incompatibleWithProbeBoolConductivity} = Transpose[incompatibleWithProbeBool];

  (*check to see if any of the samples are compatible with the specific probe*)
  (*do not throw the same error if we are not compatible with any probe*)
  incompatibleWithProbeInputsBool = MapThread[And[#1, !#2]&, {incompatibleWithProbeBoolMaterials, incompatibleInputsBool}];
  incompatibleInputWithProbeConductivityBool = MapThread[And[#1, !#2]&, {incompatibleWithProbeBoolConductivity, incompatibleInputConductivityBool}];

  (*get the samples that are chemically incompatible with any instrument*)
  incompatibleInputsAnyProbe = PickList[Lookup[samplePackets, Object], incompatibleInputsBool];

  (* If there are incompatible samples and we are throwing messages, throw an error message *)
  If[Length[incompatibleInputsAnyProbe] > 0 && !gatherTests,
    Message[Error::IncompatibleSample, ObjectToString[incompatibleInputsAnyProbe, Cache -> simulatedCache]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  incompatibleInputsAnyProbeTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[incompatibleInputsAnyProbe] == 0,
        (* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
        Nothing,
        (* otherwise, we throw one failing test for all discarded samples *)
        Test["The input sample(s) " <> ObjectToString[incompatibleInputsAnyProbe, Cache -> simulatedCache] <> " is/are chemically compatible with an available conductivity probe:", True, False]
      ];
      passingTest = If[Length[incompatibleInputsAnyProbe] == Length[simulatedSamples],
        (* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
        Nothing,
        (* otherwise, we throw one passing test for all non-discarded samples *)
        Test["The input sample(s) " <> ObjectToString[Complement[simulatedSamples, incompatibleInputsAnyProbe], Cache -> simulatedCache] <> " is/are chemically compatible with an available conductivity probe:", True, True]
      ];
      {failingTest, passingTest}
    ],
    (* if we're not gathering tests, do Nothing *)
    Nothing
  ];

  (*get the samples that are incompatible with any instrument due to existing conductivity*)
  incompatibleInputsConductivityAnyProbe = PickList[Lookup[samplePackets, Object], incompatibleInputConductivityBool];

  (* If there are incompatible samples and we are throwing messages, throw a warning message *)
  If[Length[incompatibleInputsConductivityAnyProbe] > 0 && !gatherTests,
    Message[Warning::IncompatibleSampleConductivity, ObjectToString[incompatibleInputsConductivityAnyProbe, Cache -> simulatedCache]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  incompatibleInputsConductivityAnyProbeTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[incompatibleInputsConductivityAnyProbe] == 0,
        (* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
        Nothing,
        (* otherwise, we throw one failing test for all discarded samples *)
        Warning["The input sample(s) " <> ObjectToString[incompatibleInputsConductivityAnyProbe, Cache -> simulatedCache] <> " has a conductivity value outside any available conductivity range. Please consider choosing different samples to be measured:", True, False]
      ];
      passingTest = If[Length[incompatibleInputsConductivityAnyProbe] == Length[simulatedSamples],
        (* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
        Nothing,
        (* otherwise, we throw one passing test for all non-discarded samples *)
        Warning["The input sample(s) " <> ObjectToString[Complement[simulatedSamples, incompatibleInputsConductivityAnyProbe], Cache -> simulatedCache] <> " has a conductivity value outside any available conductivity range. Please consider choosing different samples to be measured:", True, True]
      ];
      {failingTest, passingTest}
    ],
    (* if we're not gathering tests, do Nothing *)
    Nothing
  ];



  (*get the samples that are incompatible with the specific probe due to existing conductivity*)
  incompatibleInputsConductivitySpecificProbe = PickList[Lookup[samplePackets, Object], incompatibleInputWithProbeConductivityBool];

  (* If there are incompatible samples and we are throwing messages, throw a warning message *)
  If[Length[incompatibleInputsConductivitySpecificProbe] > 0 && !gatherTests,
    Message[Warning::IncompatibleSampleConductivityProbe, ObjectToString[incompatibleInputsConductivitySpecificProbe, Cache -> simulatedCache]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  incompatibleInputsConductivitySpecificProbeTests = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[incompatibleInputsConductivitySpecificProbe] == 0,
        (* when not a single sample is chemically incompatible, we know we don't need to throw any failing test *)
        Nothing,
        (* otherwise, we throw one failing test for all discarded samples *)
        Warning["The input sample(s) " <> ObjectToString[incompatibleInputsConductivitySpecificProbe, Cache -> simulatedCache] <> " has a conductivity value outside the specified conductivity probe. Please consider choosing different samples to be measured:", True, False]
      ];
      passingTest = If[Length[incompatibleInputsConductivitySpecificProbe] == Length[simulatedSamples],
        (* when ALL samples are chemically incompatible, we know we don't need to throw any passing test *)
        Nothing,
        (* otherwise, we throw one passing test for all non-discarded samples *)
        Warning["The input sample(s) " <> ObjectToString[Complement[simulatedSamples, incompatibleInputsConductivitySpecificProbe], Cache -> simulatedCache] <> " has a conductivity value outside the specified conductivity probe. Please consider choosing different samples to be measured:", True, True]
      ];
      {failingTest, passingTest}
    ],
    (* if we're not gathering tests, do Nothing *)
    Nothing
  ];

  (* Resolve Aliquot Options *)
  {resolvedAliquotOptions, aliquotTests} = If[gatherTests,
    (* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
    resolveAliquotOptions[ExperimentMeasureConductivity, mySamples,
      simulatedSamples,
      ReplaceRule[myOptions, resolvedSamplePrepOptions],
      RequiredAliquotAmounts -> aliquotVolumeList,
      Cache -> simulatedCache,
      RequiredAliquotContainers -> aliquotContainersList,
      Output -> {Result, Tests}],

    {resolveAliquotOptions[ExperimentMeasureConductivity, mySamples, simulatedSamples, ReplaceRule[myOptions, resolvedSamplePrepOptions],
      RequiredAliquotAmounts -> aliquotVolumeList,
      Cache -> simulatedCache,
      RequiredAliquotContainers -> aliquotContainersList,
      Output -> Result], {}}
  ];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

  (* resolve the ImageSample option if Automatic; for this experiment, the default is False *)
  resolvedImageSample = If[MatchQ[imageSample, Automatic], False, imageSample];

  (* --- final preparations --- *)
  resolvedOptions = ReplaceRule[measureConductivityOptions,
    Join[
      {
        Instrument -> instrument,
        Probe -> probeList,
        CalibrationConductivity -> resolvedCalibrationConductivity /. {x_} :> x,
        VerificationConductivity -> resolvedVerificationConductivity /. {x_} :> x,
        CalibrationStandard -> calibrationStandard,
        VerificationStandard -> verificationStandard,
        SampleRinseVolume -> sampleRinseVolumeList,
        SampleRinse -> sampleRinseList,
        SampleRinseStorageCondition -> resolvedSampleRinseStorageConditionList,
        RecoupSample -> recoupSampleList,
        TemperatureCorrection -> temperatureCorrectionsList,
        AlphaCoefficient -> alphaCoefficientsList,
        Confirm -> confirm,
        Name -> name,
        Template -> template,
        SamplesInStorageCondition -> samplesInStorageCondition,
        ImageSample -> resolvedImageSample,
        Cache -> originalCache,
        Operator -> operator,
        Output -> outputOption,
        ParentProtocol -> parentProtocol,
        Upload -> upload
      },
      resolvedSamplePrepOptions,
      resolvedAliquotOptions,
      resolvedPostProcessingOptions
    ]
  ];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, solidInvalidInputs, nullVolInvalidInputs, lowVolInvalidInputs, incompatibleInputsAnyProbe, nullConductivityInvalidInputs, nullVerificationConductivityInvalidInputs, lowSampleRinseVolumeInvalidInputs}]];
  invalidOptions = DeleteDuplicates[Flatten[{calibrantionInvalidOptions, verificationInvalidOptions, invalidSampleRinseStorageConditionOptions,  temperatureCorrectionInvalidOptions}]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs] > 0 && !gatherTests,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> simulatedCache]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions] > 0 && !gatherTests,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* combine all the tests together *)
  allTests = Cases[
    Flatten[{
      discardedTest,
      solidSampleTests,
      nullVolSampleTests,
      lowVolSampleTests,
      validNameTest,
      nullConductivityStandardTests,
      nullConductivityVerificationStandardTests,
      validSampleRinseStorageConditionTest,
      noSuitableProbeTests,
      lowSampleRinseVolumeSampleTests,
      incompatibleInputsAnyProbeTests,
      incompatibleInputsConductivityAnyProbeTests,
      incompatibleInputsConductivitySpecificProbeTests,
      aliquotTests,
      conflictingCalibrationTest,
      conflictingVerificationTest,
      conflictingTemperatureCorrectionTest
    }],
    _EmeraldTest
  ];

  (* Return our resolved options and/or tests. *)
  outputSpecification /. {
    Result -> If[MemberQ[output, Result],
      resolvedOptions,
      Null
    ],
    Tests -> If[gatherTests,
      allTests,
      Null
    ]
  }
];


(* ::Subsubsection::Closed:: *)
(*Resource Packets*)


DefineOptions[measureConductivityResourcePackets,
  Options :> {
    CacheOption,
    HelperOutputOption
  }
];

measureConductivityResourcePackets[mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, ops : OptionsPattern[]] := Module[
  {
    expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, inheritedCache, numReplicates,
    samplePacketFields, samplePacks, expandedSamplesWithNumReplicates, minimumVolume, expandedAliquotVolume, sampleVolumes, pairedSamplesInAndVolumes,
    sampleVolumeRules, sampleResourceReplaceRules, samplesInResources, instrument, instrumentTime, instrumentResource, protocolPacket, sharedFieldPacket,
    finalizedPacket, allResourceBlobs, fulfillable, frqTests, testsRule, resultRule, batchedSampleRinse, batchedRinseContainers, smallVolRinseContainers,
    regularVolRinseContainers, calibrationStandard, verificationStandard, calibrationStandardType, smallVolumeProbe, regularProbe,
    smallVolumeProbeSamplePositions, regularProbeSamplePositions, samplesWithoutLinks, samplesWithReplicates, optionsWithReplicates, probes,
    recoupSample, sampleRinse, smallVolumeProbeSamples, regularProbeSamples, containerInResources, smallVolumeProbeCalibrationStandardResource,
    probeObjects, smallVolumeProbeObject, regularProbeObject, regularProbeCalibrationStandardResource, calibrationStandardResource,
    verificationStandardResource, smallVolumeProbeVerificationStandardResource, verificationStandardType, regularProbeVerificationStandardResource,
    washSolutionResource, rinseContainersResources, rinseContainers, batchLengths, calibrationStandardContainer, verificationContainer, calibrationContainer,
    verificationStandardContainer, temperatureCorrectionsList, alphaCoefficientsList, batchRinseLengths,
    batchedTemperatureCorrection, smallVolumeProbeTemperatureCorrection, regularProbeTemperatureCorrection, batchedAlphaCoefficient, smallVolumeProbeAlphaCoefficient,
    regularProbeAlphaCoefficient, smallVolumeProbeSampleRinse, regularProbeSampleRinse, probeIndices, batchedNumberOfReadings, numberOfReadings,
    smallVolumeProbeNumberOfReadings, regularProbeNumberOfReadings, regularProbeCalibrationConductivity, smallVolumeProbeCalibrationConductivity,
    calibrationStandardConductivity, calibrationConductivity, instrumentProbes, instrumentProbeModels, smallVolumeProbeResource, regularProbeResource,
    rawCalibrationStandardType, rawVerificationStandardType, rawCalibrationStandardContainer, rawVerificationStandardContainer, calibrationStandardProductDeprecated, verificationStandardProductDeprecated
  },
  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentMeasureConductivity, {mySamples}, myResolvedOptions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    ExperimentMeasureConductivity,
    RemoveHiddenOptions[ExperimentMeasureConductivity, myResolvedOptions],
    Ignore -> myUnresolvedOptions,
    Messages -> False
  ];

  (* Determine the requested return value from the function *)
  outputSpecification = OptionDefault[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* Get the inherited cache *)
  inheritedCache = Lookup[ToList[ops], Cache];

  {smallVolumeProbe, regularProbe} = {Model[Part, ConductivityProbe, "id:N80DNj1d751l"], Model[Part, ConductivityProbe, "id:J8AY5jDJbqZ7"]};

  (* Get rid of the links in mySamples. *)
  samplesWithoutLinks = mySamples /. {link_Link :> Download[link, Object]};

  (* Expand our samples and options according to NumberOfReplicates. *)
  {samplesWithReplicates, optionsWithReplicates} = expandNumberOfReplicates[ExperimentMeasureConductivity, samplesWithoutLinks, myResolvedOptions];

  (* Lookup for some of options we need *)
  {
    calibrationStandard,
    verificationStandard,
    probes,
    recoupSample,
    sampleRinse,
    instrument,
    temperatureCorrectionsList,
    alphaCoefficientsList,
    numberOfReadings
  } = Lookup[
    optionsWithReplicates,
    {
      CalibrationStandard,
      VerificationStandard,
      Probe,
      RecoupSample,
      SampleRinse,
      Instrument,
      TemperatureCorrection,
      AlphaCoefficient,
      NumberOfReadings
    }];

  (* Get number of replicates *)
  numReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

  (* --- Make our one big Download call --- *)
  samplePacketFields = Packet @@ Flatten[{Object, Container, Volume, Conductivity}];
  {
    samplePacks,
    rawCalibrationStandardType, (* can be Packet|Bottle: Packet is a sample in Sachet which we are using from the same bag *)
    rawVerificationStandardType, (* can be Packet|Bottle *)
    rawCalibrationStandardContainer,
    rawVerificationStandardContainer,
    calibrationStandardProductDeprecated,
    verificationStandardProductDeprecated,
    calibrationStandardConductivity,
    instrumentProbes,
    instrumentProbeModels
  } = Quiet[Download[{
    samplesWithReplicates,
    {calibrationStandard},
    {verificationStandard},
    {calibrationStandard},
    {verificationStandard},
    {calibrationStandard},
    {verificationStandard},
    {calibrationStandard},
    {instrument},
    {instrument}
  },
    {
      {samplePacketFields},
      {Products[SampleType]},
      {Products[SampleType]},
      {Products[DefaultContainerModel][Object]},
      {Products[DefaultContainerModel][Object]},
      {Products[Deprecated]},
      {Products[Deprecated]},
      {Conductivity},
      {Probes},
      {Probes[Model]}
    },
    Cache -> inheritedCache,
    Date -> Now
  ],
    {
      Download::FieldDoesntExist,
      Download::NotLinkField
    }
  ];

  (*handle multiple products for verification and calibration standards*)


  calibrationStandardType = LastOrDefault[
    PickList[
      Flatten[rawCalibrationStandardType],
      Flatten[calibrationStandardProductDeprecated],
      Except[True]
    ]
  ];
  verificationStandardType = LastOrDefault[
    PickList[
      Flatten[rawVerificationStandardType],
      Flatten[verificationStandardProductDeprecated],
      Except[True]
    ]
  ];

  calibrationContainer = LastOrDefault[
    PickList[
      Flatten[rawCalibrationStandardContainer],
      Flatten[calibrationStandardProductDeprecated],
      Except[True]
    ]
  ];
  verificationContainer = LastOrDefault[
    PickList[
      Flatten[rawVerificationStandardContainer],
      Flatten[verificationStandardProductDeprecated],
      Except[True]
    ]
  ];


  (* --- Make all the resources needed in the experiment --- *)

  (* -- Generate resources for the SamplesIn -- *)
  samplesInResources = Resource[Sample -> #, Name -> ToString[#]]& /@ samplesWithReplicates;

  (* -- Generate resources for the ContainersIn -- *)
  containerInResources = Link[Resource[Sample -> #, Name -> ToString[#]], Protocols]& /@ (Lookup[fetchPacketFromCache[#, inheritedCache], Container]& /@ samplesWithReplicates);

  (* -- Generate resources for the Instrument -- *)
  (*  The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
  this will probably look like set-up time + time/sample + tear-down time *)
  instrumentTime = 10Minute * Length[samplesInResources];
  instrumentResource = Resource[Instrument -> instrument, Time -> instrumentTime, Name -> ToString[Unique[]]];

  (*Batching calculations based on Probe type: smallVolumeProbe(2-electrodes) or regularProbe(4-electrodes)*)

  (*Find the index positions of each sample with smallVolumeProbe and regularProbe*)
  smallVolumeProbeSamplePositions = Flatten@Position[probes, ObjectP[smallVolumeProbe]];
  regularProbeSamplePositions = Flatten@Position[probes, ObjectP[regularProbe]];

	(* Generate resources for probes *)
	{smallVolumeProbeResource,regularProbeResource}=Which[
		(* If instrument is resolved to model, we don't need to resource pick now *)
		MatchQ[instrument, ObjectP[Model[Instrument,ConductivityMeter]]],
			{
				If[MemberQ[probes,ObjectP[smallVolumeProbe]],{smallVolumeProbe},{}],
				If[MemberQ[probes,ObjectP[regularProbe]],{regularProbe},{}]
			},
		(* If instrument has resolved to an object, the probes should reslove to that instrument's probes *)
		MatchQ[instrument, ObjectP[Object[Instrument,ConductivityMeter]]],
		{
			If[MemberQ[probes,ObjectP[smallVolumeProbe]],{Resource[Sample->FirstOrDefault[Cases[Transpose[{Flatten@instrumentProbes, Flatten@instrumentProbeModels}], {x_,ObjectP[smallVolumeProbe]} :> x]]]},{}],
			If[MemberQ[probes,ObjectP[regularProbe]],{Resource[Sample->FirstOrDefault[Cases[Transpose[{Flatten@instrumentProbes, Flatten@instrumentProbeModels}], {x_,ObjectP[regularProbe]} :> x]]]},{}]
		}
	];

  probeObjects = Join[smallVolumeProbeResource, regularProbeResource];

  (* Split up our samples into smallVolumeProbe and regularProbe groups. *)
  smallVolumeProbeSamples = samplesWithReplicates[[smallVolumeProbeSamplePositions]];
  regularProbeSamples = samplesWithReplicates[[regularProbeSamplePositions]];

  (* 	get batchedTemperatureCorrection by splitting up temperatureCorrectionsList into smallVolumeProbe and regularProbe groups. *)
  (* + verification TemperatureCorrection: Linear*)
  smallVolumeProbeTemperatureCorrection = If[
    MatchQ[temperatureCorrectionsList[[smallVolumeProbeSamplePositions]], {}],
    {},
    Join[{Linear}, temperatureCorrectionsList[[smallVolumeProbeSamplePositions]]]
  ];

  regularProbeTemperatureCorrection = If[
    MatchQ[temperatureCorrectionsList[[regularProbeSamplePositions]], {}],
    {},
    Join[{Linear}, temperatureCorrectionsList[[regularProbeSamplePositions]]]
  ];

  batchedTemperatureCorrection = Join[smallVolumeProbeTemperatureCorrection, regularProbeTemperatureCorrection];

  (* 	get batchAlphaCoefficient by splitting up alphaCoefficientsList into smallVolumeProbe and regularProbe groups. *)
  (* + verification AlphaCoefficient =2*)
  smallVolumeProbeAlphaCoefficient = If[
    MatchQ[alphaCoefficientsList[[smallVolumeProbeSamplePositions]], {}],
    {},
    Join[{2}, alphaCoefficientsList[[smallVolumeProbeSamplePositions]]]
  ];
  regularProbeAlphaCoefficient = If[
    MatchQ[alphaCoefficientsList[[regularProbeSamplePositions]], {}],
    {},
    Join[{2}, alphaCoefficientsList[[regularProbeSamplePositions]]]
  ];
  batchedAlphaCoefficient = Join[smallVolumeProbeAlphaCoefficient, regularProbeAlphaCoefficient];

  (* 	get batchNumberOfReadings by splitting up numberOfReadings into smallVolumeProbe and regularProbe groups. *)
  (* + verification NumberOfReadings =3*)
  smallVolumeProbeNumberOfReadings = If[
    MatchQ[numberOfReadings[[smallVolumeProbeSamplePositions]], {}], {},
    Join[{3}, numberOfReadings[[smallVolumeProbeSamplePositions]]]
  ];
  regularProbeNumberOfReadings = If[
    MatchQ[numberOfReadings[[regularProbeSamplePositions]], {}],
    {},
    Join[{3}, numberOfReadings[[regularProbeSamplePositions]]]
  ];
  batchedNumberOfReadings = Join[smallVolumeProbeNumberOfReadings, regularProbeNumberOfReadings];

  (* 	split up sampleRinse into smallVolumeProbe and regularProbe groups. *)
  (* verification sample rinse=False*)
  smallVolumeProbeSampleRinse = If[
    MatchQ[sampleRinse[[smallVolumeProbeSamplePositions]], {}], {},
    Join[{False}, sampleRinse[[smallVolumeProbeSamplePositions]]]
  ];
  regularProbeSampleRinse = If[
    MatchQ[sampleRinse[[regularProbeSamplePositions]], {}], {},
    Join[{False}, sampleRinse[[regularProbeSamplePositions]]]
  ];
  batchedSampleRinse = Join[smallVolumeProbeSampleRinse, regularProbeSampleRinse];

  (*get batchLengths for the batching based on the number of samples for each probe*)
  batchLengths = Switch[{Length[smallVolumeProbeSamples], Length[regularProbeSamples]},
    {0, _}, {Total[regularProbeNumberOfReadings]},
    {_, 0}, {Total[smallVolumeProbeNumberOfReadings]},
    {_, _}, {Total[smallVolumeProbeNumberOfReadings], Total[regularProbeNumberOfReadings]}
  ];

  (* -- Generate resources for the CalibrationStandard -- *)
  (*NOTE: there may be multiple products for a calibrant model so we need to just get the last contaienr type from it*)
  (* generate calibration standard resource for smallVolumeProbe *)
  smallVolumeProbeCalibrationStandardResource = If[Length[smallVolumeProbeSamples] > 0,
    Switch[calibrationStandardType,
      Packet, {Resource[Sample -> calibrationStandard, Amount -> 20 Milliliter]},
      _, {Resource[Sample -> calibrationStandard, Amount -> 10 Milliliter, Container -> Model[Container, Vessel, "15mL Tube"]]}

    ],
    {}
  ];

  (*get conductivity of the standard*)
  smallVolumeProbeCalibrationConductivity = If[Length[smallVolumeProbeSamples] > 0, {Mean /@ Flatten@calibrationStandardConductivity}, {}];

  (* generate calibration standard resource for regularProbe *)
  regularProbeCalibrationStandardResource = If[Length[regularProbeSamples] > 0,
    Switch[calibrationStandardType,
      Packet, {Resource[Sample -> calibrationStandard, Amount -> 20 Milliliter]},
      _, {Resource[Sample -> calibrationStandard, Amount -> 10 Milliliter, Container -> Model[Container, Vessel, "15mL Tube"]]}
    ],
    {}
  ];

  (*get conductivity of the standard*)
  regularProbeCalibrationConductivity = If[Length[regularProbeSamples] > 0, {Mean /@ Flatten@calibrationStandardConductivity}, {}];

  calibrationConductivity = Join[smallVolumeProbeCalibrationConductivity, regularProbeCalibrationConductivity];

  (* combine all calibration standard resources for upload *)
  calibrationStandardResource = Join[smallVolumeProbeCalibrationStandardResource, regularProbeCalibrationStandardResource];

  (* -- Generate resources for the VerificationStandard -- *)
  (* generate verification standard resource for smallVolumeProbe *)
  smallVolumeProbeVerificationStandardResource = If[Length[smallVolumeProbeSamples] > 0,
    Switch[verificationStandardType,
      Packet, {Resource[Sample -> verificationStandard, Amount -> 20 Milliliter]},
      _, {Resource[Sample -> verificationStandard, Amount -> 10 Milliliter, Container -> Model[Container, Vessel, "15mL Tube"]]}
    ],
    {}
  ];

  (* generate verification standard resource for regularProbe *)
  regularProbeVerificationStandardResource = If[Length[regularProbeSamples] > 0,
    Switch[verificationStandardType,
      Packet, {Resource[Sample -> verificationStandard, Amount -> 20 Milliliter]},
      _, {Resource[Sample -> verificationStandard, Amount -> 10 Milliliter, Container -> Model[Container, Vessel, "15mL Tube"]]}
    ],
    {}
  ];

  (* combine all verification standard resources for upload *)
  verificationStandardResource = Join[smallVolumeProbeVerificationStandardResource, regularProbeVerificationStandardResource];

  (* generate wash solution resource for every selected probe *)
  washSolutionResource = Resource[
    Sample -> Model[Sample, "id:8qZ1VWNmdLBD"],
    Amount -> 400 Milliliter,
    Container -> Model[Container, Vessel, "id:R8e1PjRDbbOv"],
    RentContainer -> True
  ];

  (* resolve and generate resources for rinse containers *)
  rinseContainers = MapThread[
    Function[{sampleRinseBool, probe},
      If[TrueQ[sampleRinseBool],
        Switch[probe,
          ObjectP[Model[Part, ConductivityProbe, "id:N80DNj1d751l"]], Model[Container, Vessel, "2mL Tube"], (* Model[Part, ConductivityProbe, "InLab 751-4mm"] *)
          ObjectP[Model[Part, ConductivityProbe, "id:J8AY5jDJbqZ7"]], Model[Container, Vessel, "15mL Tube"] (* Model[Part, ConductivityProbe, "InLab 731-ISM"] *)
        ],
        Null
      ]
    ],
    {sampleRinse, probes}
  ];
  rinseContainersResources = If[MatchQ[#, Except[Null]], Resource[Sample -> #], Null]& /@ rinseContainers;

  (*batching of rinse containers + verification Null*)
  smallVolRinseContainers = If[
    MatchQ[rinseContainers[[smallVolumeProbeSamplePositions]], {}],
    {},
    Join[{Null}, rinseContainers[[smallVolumeProbeSamplePositions]]]
  ];
  regularVolRinseContainers = If[
    MatchQ[rinseContainers[[regularProbeSamplePositions]], {}],
    {},
    Join[{Null}, rinseContainers[[regularProbeSamplePositions]]]
  ];

  batchedRinseContainers = Join[smallVolRinseContainers, regularVolRinseContainers];

  (* --- Generate the protocol packet --- *)
  protocolPacket = <|
    Type -> Object[Protocol, MeasureConductivity],
    Object -> CreateID[Object[Protocol, MeasureConductivity]],
    Replace[SamplesIn] -> samplesInResources,
    Replace[ContainersIn] -> containerInResources,
    Replace[RecoupSample] -> recoupSample,
    Replace[RinseContainers] -> rinseContainersResources,
    Replace[Probes] -> Link /@ probeObjects,
    Replace[CalibrationStandard] -> Link /@ calibrationStandardResource,
    Replace[CalibrationConductivity] -> Flatten@calibrationConductivity,
    Replace[VerificationStandard] -> Link /@ verificationStandardResource,
    UnresolvedOptions -> myUnresolvedOptions,
    ResolvedOptions -> myResolvedOptions,
    NumberOfReplicates -> numReplicates,
    Replace[SampleRinseStorageConditions] -> Lookup[myResolvedOptions, SampleRinseStorageCondition],
    Replace[BatchLengths] -> batchLengths,
    Replace[BatchingParameters] -> MapThread[
      Function[{temperatureCorrection, alphaCoefficient, rinseBool, container, index},
        <|
          Container -> Null,
          TemperatureCorrection -> temperatureCorrection,
          AlphaCoefficient -> alphaCoefficient,
          RinseContainer -> container,
          SampleRinse -> rinseBool,
          BatchedIndex -> index,
          DataFilePath -> Null,
          ContainerModel -> Null,
          Well -> Null
        |>
      ],
      (*taking into account the number of readings*)
      {
        Flatten@MapThread[ConstantArray[#1, #2] &, {batchedTemperatureCorrection, batchedNumberOfReadings}],
        Flatten@MapThread[ConstantArray[#1, #2] &, {batchedAlphaCoefficient, batchedNumberOfReadings}],
        Flatten@MapThread[ConstantArray[#1, #2] &, {batchedSampleRinse, batchedNumberOfReadings}],
        Flatten@MapThread[ConstantArray[#1, #2] &, {Link /@ batchedRinseContainers, batchedNumberOfReadings}],
        Range[1, Length[Flatten@MapThread[ConstantArray[#1, #2] &, {batchedTemperatureCorrection, batchedNumberOfReadings}]]]
      }
    ],
    Replace[BatchedNumberOfReadings] -> batchedNumberOfReadings,
    Replace[SmallVolumeProbeIndices] -> smallVolumeProbeSamplePositions,
    Replace[RegularProbeIndices] -> regularProbeSamplePositions,
    Instrument -> instrumentResource,
    WashSolution -> washSolutionResource,
    WasteBeaker -> Resource[Sample -> Model[Container, Vessel, "id:O81aEB4kJJJo"], Rent -> True],
    Replace[Checkpoints] -> {
      {"Picking Resources", 10 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 Minute]]},
      {"Preparing Samples", 30 Minute, "Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 Minute]]},
      {"Measuring Conductivity", 10Minute * Length[samplesInResources], "The conductivity of the requested samples is measured.", Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10Minute * Length[samplesInResources]]},
      {"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 1 * Hour]]},
      {"Returning Materials", 10 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Trainee"], Time -> 10 * Minute]]}
    }
  |>;

  (* generate a packet with the shared fields *)
  sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> inheritedCache];

  (* Merge the shared fields with the specific fields *)
  finalizedPacket = Join[sharedFieldPacket, protocolPacket];

  (* get all the resource symbolic representations *)
  (* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

  (* call fulfillableResourceQ on all the resources we created *)
  {fulfillable, frqTests} = Which[
    MatchQ[$ECLApplication, Engine], {True, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Cache -> inheritedCache],
    True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Messages -> messages, Cache -> inheritedCache], Null}
  ];

  (* generate the tests rule *)
  testsRule = Tests -> If[gatherTests,
    frqTests,
    Null
  ];

  (* generate the Result output rule *)
  (* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
    finalizedPacket,
    $Failed
  ];

  (* return the output as we desire it *)
  outputSpecification /. {resultRule, testsRule}
];



(* ::Subsubsection:: *)
(*Devices Function*)


(* internal function which returns True or False depending on the sample and probe compatibility *)
DefineOptions[compatibleConductivityProbeQ,
  Options :> {
    CacheOption
  }
];

(*internal function for conductivity probe compatibility. Checks for material and conductivity compatibility.*)
compatibleConductivityProbeQ[probeModelPacket : PacketP[Model[Part, ConductivityProbe]], samplePacket : ObjectP[Object[Sample]], myOptions : OptionsPattern[]] := Module[

  {listedOptions, cache, isCompatible, conductivityCompatibility, minConductivityValue, maxConductivityValue, sampleConductivity, materialCompatibility},

  (* Make sure we're working with a list of options *)
  listedOptions = ToList[myOptions];

  (* assign the option values to local variables *)
  cache = Lookup[listedOptions, Cache];

  (*check the material compatibility: true or false*)
  materialCompatibility = Quiet[CompatibleMaterialsQ[probeModelPacket, samplePacket, Cache -> cache]];

  (*get the relevant conductivity values*)
  minConductivityValue = Lookup[probeModelPacket, MinConductivity];
  maxConductivityValue = Lookup[probeModelPacket, MaxConductivity];
  sampleConductivity = If[MatchQ[Lookup[samplePacket, Conductivity], Null], Null, Mean@Lookup[samplePacket, Conductivity]];

  (*check conductivity compatibility if the conductivity value is not Null*)
  conductivityCompatibility = If[Not[Or[NullQ[sampleConductivity], NullQ[minConductivityValue], NullQ[maxConductivityValue]]],
    MatchQ[sampleConductivity, RangeP[minConductivityValue, maxConductivityValue]],
    True
  ];

  (*overall compatibility to return as a list*)
  {materialCompatibility, conductivityCompatibility}
];

(*internal function to find the preferred container depends on volume*)
preferredConductivityContainer[input : Alternatives[GreaterP[0 Milliliter], All]] := Module[{},

  (*if the input requests All, then provide all the containers including the 15 mL*)
  If[MatchQ[input, All],

    (*provide everything including the 50 mL, 15 mL and 2 mL tube *)
    Union[PreferredContainer[All], {Model[Container, Vessel, "2mL Tube"], Model[Container, Vessel, "15mL Tube"], Model[Container, Vessel, "50mL Tube"]}],

    (*for custom volumes we'll want to use specific containers*)
    Switch[input,
      (* Default to 15mL tubes if the volume is appropriate. *)
      RangeP[2 Milliliter, 10 Milliliter], Model[Container, Vessel, "15mL Tube"],

      (* If the volume is greater than 11 mL resolve to 50mL tubes *)
      RangeP[11 Milliliter, 40 Milliliter], Model[Container, Vessel, "50mL Tube"],

      (*if below 300 uL, then we'll use 2mL tubes*)
      RangeP[50 Microliter, 300 * Microliter], Model[Container, Vessel, "2mL Tube"],

      (*otherwise, use the preferred container*)
      _, PreferredContainer[input]
    ]
  ]
];



(* ::Subsection::Closed:: *)
(*ExperimentMeasureConductivityOptions*)


DefineOptions[ExperimentMeasureConductivityOptions,
  Options :> {
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
      Description -> "Determines whether the function returns a table or a list of the options.",
      Category -> "Protocol"
    }
  },
  SharedOptions :> {ExperimentMeasureConductivity}
];


ExperimentMeasureConductivityOptions[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
  {listedOptions, noOutputOptions, options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output and OutputFormat option before passing to the core function because it doens't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

  (* get only the options *)
  options = ExperimentMeasureConductivity[myInputs, Append[noOutputOptions, Output -> Options]];


  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
    LegacySLL`Private`optionsToTable[options, ExperimentMeasureConductivity],
    options
  ]
];



(* ::Subsection::Closed:: *)
(*ExperimentMeasureConductivityPreview*)


(* currently we only accept either a list of containers, or a list of samples *)
ExperimentMeasureConductivityPreview[myInput : ListableP[ObjectP[{Object[Container]}]] | ListableP[ObjectP[Object[Sample]] | _String], myOptions : OptionsPattern[ExperimentMeasureConductivity]] :=
    ExperimentMeasureConductivity[myInput, Append[ToList[myOptions], Output -> Preview]];



(* ::Subsection::Closed:: *)
(*ValidExperimentMeasureConductivityQ*)


DefineOptions[ValidExperimentMeasureConductivityQ,
  Options :> {VerboseOption, OutputFormatOption},
  SharedOptions :> {ExperimentMeasureConductivity}
];

(* currently we only accept either a list of containers, or a list of samples *)
ValidExperimentMeasureConductivityQ[myInput : ListableP[ObjectP[{Object[Container]}]] | ListableP[ObjectP[Object[Sample]] | _String], myOptions : OptionsPattern[ValidExperimentMeasureConductivityQ]] := Module[
  {listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];
  listedInput = ToList[myInput];

  (* remove the Output option before passing to the core function because it doens't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentMeasureConductivity *)
  filterTests = ExperimentMeasureConductivity[myInput, Append[preparedOptions, Output -> Tests]];

  (* define the general test description *)
  initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* make a list of all the tests, including the blanket test *)
  allTests = If[MatchQ[filterTests, $Failed],
    {Test[initialTestDescription, False, True]},
    Module[
      {initialTest, validObjectBooleans, voqWarnings},

      (* generate the initial test, which we know will pass if we got this far (?) *)
      initialTest = Test[initialTestDescription, True, True];

      (* create warnings for invalid objects *)
      validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
      voqWarnings = MapThread[
        Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {DeleteCases[listedInput, _String], validObjectBooleans}
      ];

      (* get all the tests/warnings *)
      Flatten[{initialTest, filterTests, voqWarnings}]
    ]
  ];

  (* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  (* like if I ran OptionDefault[OptionValue[ValidExperimentMeasureConductivityQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentMeasureConductivityQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureConductivityQ"]


];
