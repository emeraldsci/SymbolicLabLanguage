(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*OvenDry*)


(* ::Subsubsection:: *)
(*ExperimentOvenDry Options*)



DefineOptions[ExperimentOvenDry,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> Oven,
        Default -> Model[Instrument, Oven, "id:6V0npvmZnLWV"], (*"Thermo Fisher Large Oven"*)
        Description -> "For each input sample, the oven in which the samples are dried.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Instrument, Oven], Object[Instrument, Oven]}]
        ],
        Category -> "General"
      },
      {
        OptionName -> OvenTemperature,
        Default -> Automatic,
        Description -> "For each input sample, the temperature to which the oven is set before the samples are dried.",
        ResolutionDescription -> "For objects of type Object[Sample], automatically set to 110 Celsius. For other objects, automatically set to the lower of MaxTemperature of the object or 250*Celsius.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[100*Celsius, 250*Celsius],
          Units -> {Celsius, {Celsius, Kelvin, Fahrenheit}}
        ],
        Category -> "General"
      },
      {
        OptionName -> OvenTime,
        Default -> 30*Minute,
        Description -> "For each input sample, the minimum length of time for which the sample is kept in the oven before being moved to the desiccator.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[1*Minute, 240*Minute],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Category -> "General"
      },
      {
        OptionName -> DesiccatorTime,
        Default -> Automatic,
        Description -> "For each input sample, the minimum length of time for which the sample is cooled in the desiccator after being removed from the oven.",
        ResolutionDescription -> "If OvenTemperature is 110 Celsius, automatically set to 21.25 Minute. If OvenTemperature is 250 Celsius, automatically set to 56.25 Minute. Otherwise, automatically set to 0.25*Minute * (OvenTemperature [in Celsius] - 25*Celsius)",
        AllowNull -> False,
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> RangeP[1*Minute, 240*Minute],
          Units -> {Minute, {Second, Minute, Hour}}
        ],
        Category -> "General"
      },
      {
        OptionName->SampleLabel,
        Default->Automatic,
        Description->"A user defined word or phrase used to identify the samples that are being dried in ExperimentOvenDry, for use in downstream unit operations.",
        AllowNull->True,
        Category->"General",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Line
        ],
        UnitOperation->True
      },
      {
        OptionName->SampleContainerLabel,
        Default->Automatic,
        Description->"A user defined word or phrase used to identify the containers of the samples that are being dried in ExperimentOvenDry, for use in downstream unit operations.",
        AllowNull->True,
        Category->"General",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Line
        ],
        UnitOperation->True
      },
      {
        OptionName->SampleOutLabel,
        Default->Automatic,
        Description->"A user defined word or phrase used to identify the samples that are being dried in ExperimentOvenDry, after any necessary transfers, for use in downstream unit operations.",
        AllowNull->True,
        Category->"General",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Line
        ],
        UnitOperation->True
      },
      {
        OptionName->ContainerOutLabel,
        Default->Automatic,
        Description->"A user defined word or phrase used to identify the containers of the samples that are being dried in ExperimentOvenDry, after any necessary transfers, for use in downstream unit operations.",
        AllowNull->True,
        Category->"General",
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Line
        ],
        UnitOperation->True
      }
    ],
    (* Non index-matching options *)
    {
      OptionName -> Desiccator,
      Default -> Model[Instrument, Desiccator, "10L Glass Non-Vacuum Desiccator"], (* TODO: replace with "id:D8KAEv5xK1BR" after refresh *)
      Description -> "The desiccator in which the samples are cooled after being removed from the oven.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument, Desiccator], Object[Instrument, Desiccator]}]
      ],
      Category -> "General"
    },
    (* Hidden options *)
    {
      OptionName -> TransferSamples,
      Default -> Automatic,
      Description -> "The samples that will be transferred to new, OvenDry-compatible containers.",
      AllowNull -> True,
      Category -> "Hidden",
      Widget -> Adder[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
        ]
      ]
    }
  },
  SharedOptions :> {
    FastTrackOption,
    ProtocolOptions,
    NonBiologyPostProcessingOptions,
    SimulationOption,
    SubprotocolDescriptionOption,
    SamplesInStorageOptions,
    SamplesOutStorageOptions
  }
];

Error::OvenTemperatureTooHighForContainer = "The specified OvenTemperature, `1`, is in excess of the MaxTemperature of the container `2`, `3`. Please allow OvenTemperature to resolve automatically or specify an OvenTemperature no higher than `3`.";
Error::OvenTemperatureTooHighForSample = "The specified OvenTemperature, `1`, is in excess of 110 Celsius, higher than is needed to dehydrate the sample(s), `2`. Please do not set OvenTemperature higher than 110 Celsius for samples.";
Error::OvenDryIncompatibleMaterials = "The container `1` is made from material(s) `2` which cannot be oven dried. Please only use OvenDry for glass containers.";
Warning::OvenDryContainerIncompatibleMaterials = "The container(s) `1` of sample(s) `2` are made from material(s) `3` which cannot be oven dried. The sample(s) will be transferred to glass container(s) before using OvenDry. In order to use the dried samples or their containers in any downstream unit operations, you must specify a SampleOutLabel or ContainerOutLabel and invoke that label in subsequent unit operations.";
Warning::OvenDryContainerIncompatibleCoverFootprint = "The container(s) `1` of sample(s) `2` are incompatible with vented caps available in the ECL. The sample(s) will be transferred to cover-compatible container(s) before using OvenDry. In order to use the dried samples or their containers in any downstream unit operations, you must specify a SampleOutLabel or ContainerOutLabel and invoke that label in subsequent unit operations.";

(* Define OvenDry-compatible materials *)
ovenDryCompatibleMaterials = Alternatives[BorosilicateGlass, Glass, OpticalGlass];

(* ::Subsubsection::Closed:: *)
(* ExperimentOvenDry Source Code *)

(* ExperimentOvenDry *)

(* NOTE: No Container to Sample overload since we have to be able to oven dry empty containers. *)


(* -- Main Overload --*)
ExperimentOvenDry[myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]],myOptions:OptionsPattern[]]:=Module[
  {
    cache, cacheBall, collapsedResolvedOptions, expandedSafeOps, gatherTests, inheritedOptions, listedOptions,
    listedInputs, messages, myOptionsWithPreparedSamples, myOptionsWithPreparedSamplesNamed, myInputsWithPreparedSamples,
    myInputsWithPreparedSamplesNamed, output, outputSpecification, ovenDryCache, performSimulationQ,
    protocolObject, resolvedOptions, resolvedOptionsResult, resolvedOptionsTests, resourceResult, resourcePacketTests,
    optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ, safeOps, safeOpsNamed, safeOpsTests, templatedOptions, templateTests,
    samplePreparationSimulation, validLengths, validLengthTests, validSamplePreparationResult, simulatedProtocol, simulation,
    listedContainers, objectContainerFields, objectContainerPacketFields, modelContainerFields, objectSampleFields,
    modelSampleFields, optionsWithoutCache, estimatedRunTime, objectToContainerRules
  },

  (* Determine the requested return value from the function. *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests. *)
  gatherTests=MemberQ[output,Tests];
  messages=!gatherTests;

  (* Remove temporal links. *)
  {listedInputs, listedOptions}=removeLinks[ToList[myInputs], ToList[myOptions]];

  (* Simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {myInputsWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentOvenDry,
      listedInputs,
      listedOptions
    ],
    $Failed,
    {Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentOvenDry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentOvenDry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
  ];

  (* Call sanitize-inputs to clean any named objects. *)
  {myInputsWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[myInputsWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed. *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length. *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentOvenDry,{myInputsWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentOvenDry,{myInputsWithPreparedSamples},myOptionsWithPreparedSamples],Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point). *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions. *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentOvenDry,{ToList[myInputsWithPreparedSamples]},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentOvenDry,{ToList[myInputsWithPreparedSamples]},ToList[myOptionsWithPreparedSamples]],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests,templateTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options. *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentOvenDry,{ToList[myInputsWithPreparedSamples]},inheritedOptions]];

  (* Fetch the cache from expandedSafeOps. *)
  cache=ToList[Lookup[expandedSafeOps, Cache, {}]];

  (* Drop the cache from myOptions. *)
  optionsWithoutCache=Normal[KeyDrop[ToList[myOptions], Cache], Association];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

  (* Normalize our inputs all into containers. This is because OvenDry cares about the container, not about the sample. *)
  (* Brief aside - we sometimes very much do care about the sample, from a scientific standpoint. But the code works better if we ignore it. *)
  listedContainers=If[Length[Cases[myInputsWithPreparedSamples, ObjectP[Object[Sample]]]]>0,
    Module[{samplePackets},
      (* Get the packets of any sample inputs we have. *)
      samplePackets=Download[
        Cases[myInputsWithPreparedSamples, ObjectP[Object[Sample]]],
        Packet[Container],
        Simulation->samplePreparationSimulation
      ];

      (* Replace samples with their container. *)
      objectToContainerRules = Rule@@@Transpose[
        {
          ObjectP/@Lookup[samplePackets, Object],
          Download[Lookup[samplePackets, Container], Object]
        }
      ];
      myInputsWithPreparedSamples/.objectToContainerRules
    ],
    myInputsWithPreparedSamples
  ];

  (* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
  objectContainerFields=DeleteDuplicates[Flatten[{Model, MaxTemperature, ContainerMaterials, Contents, Notebook, Name}]];
  objectContainerPacketFields=Packet@@objectContainerFields;
  modelContainerFields=DeleteDuplicates[Flatten[{MaxTemperature, ContainerMaterials, CoverFootprints}]];
  objectSampleFields=DeleteDuplicates[Flatten[{Container, MaxTemperature,Model}]];
  modelSampleFields=DeleteDuplicates[Flatten[{MaxTemperature}]];

  ovenDryCache=Flatten@Quiet[
    Download[
      {
        listedContainers,
        listedContainers,
        listedContainers,
        listedContainers
      },
      {
        List@objectContainerPacketFields,
        List@Packet[Model[modelContainerFields]],
        List@Packet[Contents[[All,2]][objectSampleFields]],
        List@Packet[Contents[[All,2]][Model][modelSampleFields]]
      },
      Cache->cache,
      Simulation->samplePreparationSimulation
    ],
    {Download::FieldDoesntExist,Download::NotLinkField}
  ];

  (* Combine our downloaded and passed cache. *)
  cacheBall=FlattenCachePackets[{cache,ovenDryCache}];

  (* Build the resolved options. *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentOvenDryOptions[
      listedInputs,
      listedContainers,
      expandedSafeOps,
      Cache->cacheBall,
      Simulation->samplePreparationSimulation,
      Output->{Result,Tests}
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={
        resolveExperimentOvenDryOptions[
          myInputsWithPreparedSamples,
          listedContainers,
          expandedSafeOps,
          Cache->cacheBall,
          Simulation->samplePreparationSimulation
        ],
        {}
      },
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options. *)
  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentOvenDry,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
  (* if Output contains Result or Simulation, then we can't do this *)
  optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
  returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

  (* Run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early. *)
  returnEarlyBecauseFailuresQ = Which[
    MatchQ[resolvedOptionsResult, $Failed], True,
    gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True, False
  ];

  performSimulationQ = MemberQ[output, Simulation];

  (* If option resolution failed, return early. *)
  If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentOvenDry,collapsedResolvedOptions],
      Preview->Null,
      Simulation -> Simulation[]
    }]
  ];

  (* Build packets with resources. *)
  (* NOTE: resourceResult is either $Failed or {protocolPacket, unitOperationPackets} *)
  {resourceResult, resourcePacketTests} = Which[
    MatchQ[resolvedOptionsResult, $Failed],
    {$Failed, {}},
    gatherTests,
    ovenDryResourcePackets[
      listedInputs,
      listedContainers,
      templatedOptions,
      resolvedOptions,
      Cache->cacheBall,
      Simulation->samplePreparationSimulation,
      Output->{Result,Tests}
    ],
    True,
    {
      ovenDryResourcePackets[
        listedInputs,
        listedContainers,
        templatedOptions,
        resolvedOptions,
        Cache->cacheBall,
        Simulation->samplePreparationSimulation
      ],
      {}
    }
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  {simulatedProtocol, simulation} = Which[
    !performSimulationQ,
    {Null, samplePreparationSimulation},
    True,
    simulateExperimentOvenDry[
      If[MatchQ[resourceResult, $Failed],
        $Failed,
        resourceResult[[1]]
      ],
      If[MatchQ[resourceResult, $Failed],
        $Failed,
        resourceResult[[2]]
      ],
      listedInputs,
      listedContainers,
      resolvedOptions,
      Cache->cacheBall,
      Simulation->samplePreparationSimulation,
      ParentProtocol->Lookup[safeOps,ParentProtocol]
    ]
  ];

  (* Estimate run time. Do this by finding the maximum oven time + desiccator time and adding 15 minutes. *)
  estimatedRunTime = Max[
    MapThread[
      (#1 + #2)&,
      Lookup[resolvedOptions, {OvenTime, DesiccatorTime}]
    ] + 15*Minute
  ];

  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentOvenDry,collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> simulation,
      RunTime -> estimatedRunTime
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
  protocolObject = If[
    (* If our resource packets failed, we can't upload anything. *)
    MatchQ[resourceResult,$Failed],
      $Failed,

    (* Actually upload our protocol object. We are being called as a subprotocol in ExperimentManualSamplePreparation. *)
      UploadProtocol[
        resourceResult[[1]],
        resourceResult[[2]],
        Upload->Lookup[safeOps,Upload],
        Confirm->Lookup[safeOps,Confirm],
        CanaryBranch->Lookup[safeOps,CanaryBranch],
        ParentProtocol->Lookup[safeOps,ParentProtocol],
        Priority->Lookup[safeOps,Priority],
        StartDate->Lookup[safeOps,StartDate],
        HoldOrder->Lookup[safeOps,HoldOrder],
        QueuePosition->Lookup[safeOps,QueuePosition],
        ConstellationMessage->Object[Protocol,OvenDry],
        Cache->cache,
        Simulation-> simulation
      ]
  ];

  (* Return requested output. *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentOvenDry,collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> simulation,
    RunTime -> estimatedRunTime
  }
];

(* ::Subsection:: *)
(* resolveExperimentOvenDryOptions *)

DefineOptions[
  resolveExperimentOvenDryOptions,
  Options:>{
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

resolveExperimentOvenDryOptions[
  myInputs:{ObjectP[{Object[Container], Object[Sample]}]..},
  myContainers:{ObjectP[Object[Container]]..},
  myOptions:{_Rule..},
  myResolutionOptions:OptionsPattern[resolveExperimentOvenDryOptions]
]:=Module[
  {
    outputSpecification, output, gatherTests, messagesQ, warningsQ, cache, currentSimulation, samplePrepOptions, ovenDryOptions,
    objectContainerFields, objectContainerPacketFields, modelContainerFields, objectSampleFields, modelSampleFields, objectContainerPackets,
    modelContainerPackets, objectSamplePacketList, modelSamplePacketList, cacheBall, fastCacheBall, mapThreadFriendlyOptions,
    resolvedOvenTemperatures, resolvedDesiccatorTimes, resolvedPostProcessingOptions,
    resolvedOptions, mapThreadFriendlyResolvedOptions, ovenTemperatureTooHighForContainerErrors, ovenTemperatureTooHighForSampleErrors,
    nonGlassContainerPackets, nonGlassContainers, nonGlassContainerInputs, nonGlassContainerSampleInputs,
    discardedInvalidInputs, discardedTests, discardedSamplePackets, nonGlassContainerTests, nonGlassContainerSampleTests, failingOvenTemperatureContainers, passingOvenTemperatureContainers, invalidOvenTemperatureTooHighForContainerOptions,
    failingOvenTemperatureForContainerValues, ovenTemperatureTooHighForContainerTests, ovenTemperatureTooHighForContainerErrorQ, failingOvenTemperatureSamples, passingOvenTemperatureSamples, invalidOvenTemperatureTooHighForSampleOptions,
    failingOvenTemperatureForSampleValues, ovenTemperatureTooHighForSampleTests, ovenTemperatureTooHighForSampleErrorQ, invalidInputs,
    invalidOptions, optionPrecisions, roundedExperimentOptions, optionPrecisionTests, nonGL45ContainerPackets, nonGL45Containers,
    nonGL45ContainerObjects, nonGL45ContainerInputs, nonGL45ContainerSampleInputs, glassNonGL45ContainerSampleInputs, nonGL45ContainerSampleTests,
    transferSamples, inputContainerTuples, fastAssoc, nonGlassContainerSampleContainers, resolvedSampleLabels, resolvedSampleContainerLabels,
    resolvedSampleOutLabels, resolvedContainerOutLabels
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  (* warnings assume we're not in engine; if we are they are not surfaced *)
  gatherTests = MemberQ[output,Tests];
  messagesQ = !gatherTests;
  warningsQ = !gatherTests && !MatchQ[$ECLApplication, Engine];

  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  fastAssoc = makeFastAssocFromCache[cache];

  (* Lookup our simulation. *)
  currentSimulation=Lookup[ToList[myResolutionOptions],Simulation];

  (* Separate out our <Type> options from our Sample Prep options. *)
  {samplePrepOptions, ovenDryOptions}=splitPrepOptions[myOptions];

  (* === OPTION PRECISION CHECKS === *)
  (* First, define the option precisions that need to be checked for OvenDry *)
  optionPrecisions={
    {OvenTime,10^0*Second},
    {OvenTemperature,10^0*Celsius},
    {DesiccatorTime,10^0*Second}
  };

  (* Verify that the experiment options are not overly precise *)
  {roundedExperimentOptions,optionPrecisionTests}=If[gatherTests,

    (*If we are gathering tests *)
    RoundOptionPrecision[Association[ovenDryOptions],optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],

    (* Otherwise *)
    {RoundOptionPrecision[Association[ovenDryOptions],optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
  ];

  (* ExperimentOvenDry does not have sample prep options so we are skipping those. *)

  (* Create the Packet Download syntax for our Object and Model samples. *)
  objectContainerFields=DeleteDuplicates[Flatten[{Model, MaxTemperature, ContainerMaterials, Contents, Notebook, Name}]];
  objectContainerPacketFields=Packet@@objectContainerFields;
  modelContainerFields=DeleteDuplicates[Flatten[{MaxTemperature, ContainerMaterials, CoverFootprints}]];
  objectSampleFields=DeleteDuplicates[Flatten[{Container, MaxTemperature}]];
  modelSampleFields=DeleteDuplicates[Flatten[{MaxTemperature}]];

  (* Get packets via the fast assoc *)
  {
    objectContainerPackets,
    modelContainerPackets,
    objectSamplePacketList,
    modelSamplePacketList
  } = fetchPacketFromFastAssoc[#, fastAssoc]&/@{
    myContainers,
    fastAssocLookup[fastAssoc,myContainers,Model],
    Flatten[(fastAssocLookup[fastAssoc,myContainers,Contents]/.{{}->{{Null,Null}}}),1][[All,2]],
    fastAssocLookup[fastAssoc,Flatten[(fastAssocLookup[fastAssoc,myContainers,Contents]/.{{}->{{Null,Null}}}),1][[All,2]],Model]
  };

  {
    objectSamplePacketList,
    modelSamplePacketList
  }=Map[
    Flatten,
    {
      objectSamplePacketList,
      modelSamplePacketList
    },
    {1}
  ];

  {
    objectContainerPackets,
    modelContainerPackets
  }=Flatten/@{
    objectContainerPackets,
    modelContainerPackets
  };

  cacheBall = FlattenCachePackets[{
    objectContainerPackets,
    modelContainerPackets,
    objectSamplePacketList,
    modelSamplePacketList
  }];

  (* Make the fast association. *)
  fastCacheBall = makeFastAssocFromCache[cacheBall];

  (* Get our map thread friendly options. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentOvenDry,Normal[roundedExperimentOptions, Association]];

  (* INPUT VALIDATION CHECKS *)

  (* Before we get too far, make tuples out of our inputs and containers *)
  inputContainerTuples = Transpose[{myInputs, myContainers}];

  (* Need to make sure that the containers we're using are made out of glass. Don't want to try this with other non-validated materials. *)
  nonGlassContainerPackets = Select[objectContainerPackets, !MatchQ[Lookup[#, ContainerMaterials], {ovenDryCompatibleMaterials...}]&];

  (* Get the problematic objects from the packets *)
  nonGlassContainers = Lookup[nonGlassContainerPackets, Object, {}];

  (* Split these into containers that were specified as inputs vs. samples in containers that were specified as inputs *)
  nonGlassContainerInputs = Intersection[nonGlassContainers, myInputs];
  nonGlassContainerSampleContainers = Complement[nonGlassContainers, nonGlassContainerInputs];
  nonGlassContainerSampleInputs = FirstOrDefault/@Select[inputContainerTuples, MemberQ[#, Alternatives@@nonGlassContainerSampleContainers]&];

  (* If there are non-glass container inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[nonGlassContainerInputs]>0&&messagesQ,
    Message[Error::OvenDryIncompatibleMaterials, ObjectToString[nonGlassContainerInputs,Cache->cacheBall], ObjectToString[Download[nonGlassContainerInputs, ContainerMaterials, Cache->cacheBall]]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonGlassContainerTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[nonGlassContainerInputs]==0,
        Nothing,
        Test["The input containers "<>ObjectToString[nonGlassContainerInputs,Cache->cacheBall]<>" are made from a compatible material:",True,False]
      ];

      passingTest=If[Length[nonGlassContainerInputs]==Length[Cases[myInputs, ObjectP[{Object[Container], Model[Container]}]]],
        Nothing,
        Test["The input containers "<>ObjectToString[Complement[Cases[myInputs, ObjectP[{Object[Container], Model[Container]}]],nonGlassContainerInputs],Cache->cacheBall]<>" are made from a compatible material:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* If there are input samples in non-glass containers and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
  If[Length[nonGlassContainerSampleInputs]>0 && messagesQ && !MatchQ[$ECLApplication, Engine],
    Message[Warning::OvenDryContainerIncompatibleMaterials, ObjectToString[Download[nonGlassContainerSampleInputs, Container, Cache->cacheBall]], ObjectToString[nonGlassContainerSampleInputs,Cache->cacheBall], ObjectToString[Download[nonGlassContainerSampleInputs, Container[ContainerMaterials], Cache->cacheBall]]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonGlassContainerSampleTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[nonGlassContainerSampleInputs]==0,
        Nothing,
        Test["The input samples "<>ObjectToString[nonGlassContainerSampleInputs,Cache->cacheBall]<>" are in containers made from a compatible material:",True,False]
      ];

      passingTest=If[Length[nonGlassContainerSampleInputs]==Length[Cases[myInputs, ObjectP[{Object[Sample], Model[Sample]}]]],
        Nothing,
        Test["The input samples "<>ObjectToString[Complement[Cases[myInputs, ObjectP[{Object[Sample], Model[Sample]}]],nonGlassContainerInputs],Cache->cacheBall]<>" are in containers made from a compatible material:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* At least for now, if we are working with samples, we need our container models to have CoverFootprints that include GL45 caps. *)
  nonGL45ContainerPackets = Select[modelContainerPackets, !MemberQ[Lookup[#, CoverFootprints], CapGL45]&];

  (* Get the problematic objects from the packets *)
  nonGL45Containers = Lookup[nonGL45ContainerPackets, Object, {}];

  (* Since we had to pull these from the models, we need to get the associated objects *)
  nonGL45ContainerObjects = Flatten@Map[
    If[MatchQ[#, ObjectP[Object[Container]]],
      #,
      Lookup[Cases[objectContainerPackets, KeyValuePattern[Model -> ObjectP[#]]], Object, Null]
    ]&,
    nonGL45Containers
  ];

  (* Split these into containers that were specified as inputs vs. samples in containers that were specified as inputs (we only care about the latter) *)
  nonGL45ContainerInputs = Intersection[nonGL45ContainerObjects, myInputs];
  nonGL45ContainerSampleInputs = FirstOrDefault/@Select[inputContainerTuples, MemberQ[#, Alternatives@@Complement[nonGL45ContainerObjects, nonGL45ContainerInputs]]&];

  (* Also ignore containers that were flagged by the non-glass checks *)
  glassNonGL45ContainerSampleInputs = Complement[nonGL45ContainerSampleInputs, nonGlassContainerSampleInputs];

  (* If there are input samples in non-glass containers and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
  If[Length[glassNonGL45ContainerSampleInputs]>0 && messagesQ && !MatchQ[$ECLApplication, Engine],
    Message[Warning::OvenDryContainerIncompatibleCoverFootprint, ObjectToString[glassNonGL45ContainerSampleInputs,Cache->cacheBall], ObjectToString[Download[glassNonGL45ContainerSampleInputs, Container, Cache->cacheBall]]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonGL45ContainerSampleTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[glassNonGL45ContainerSampleInputs]==0,
        Nothing,
        Test["The input samples "<>ObjectToString[glassNonGL45ContainerSampleInputs,Cache->cacheBall]<>" are in containers compatible with GL45 caps:",True,False]
      ];

      passingTest=If[Length[glassNonGL45ContainerSampleInputs]==Length[Cases[myInputs, ObjectP[{Object[Sample], Model[Sample]}]]],
        Nothing,
        Test["The input samples "<>ObjectToString[Complement[Cases[myInputs, ObjectP[{Object[Sample], Model[Sample]}]],glassNonGL45ContainerSampleInputs],Cache->cacheBall]<>" are in containers compatible with GL45 caps:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* Combine samples that need to be moved to new containers. We'll pass this directly to resource packets. *)
  transferSamples = Join[nonGlassContainerSampleInputs, glassNonGL45ContainerSampleInputs]/.{{}->Null};

  (* Get the samples from simulatedSamples that are discarded. *)
  discardedSamplePackets = Join[Cases[objectSamplePacketList, KeyValuePattern[Status -> Discarded]], Cases[objectContainerPackets, KeyValuePattern[Status -> Discarded]]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs=Lookup[discardedSamplePackets,Object,{}];

  (* If there are discarded invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs]>0&&messagesQ,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs,Cache->cacheBall]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[Length[discardedInvalidInputs]==0,
        Nothing,
        Test["The input samples "<>ObjectToString[discardedInvalidInputs,Cache->cacheBall]<>" are not discarded:",True,False]
      ];

      passingTest=If[Length[discardedInvalidInputs]==Length[objectSamplePacketList],
        Nothing,
        Test["The input samples "<>ObjectToString[Complement[objectSamplePacketList,discardedInvalidInputs],Cache->cacheBall]<>" are not discarded:",True,True]
      ];

      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* Resolve our map thread options. *)
  {
    resolvedSampleLabels,
    resolvedSampleContainerLabels,
    resolvedSampleOutLabels,
    resolvedContainerOutLabels,
    resolvedOvenTemperatures,
    resolvedDesiccatorTimes,
    ovenTemperatureTooHighForContainerErrors,
    ovenTemperatureTooHighForSampleErrors
  }=Transpose@MapThread[
    Function[{originalInputObject, containerObject, options, modelContainerPacket, objectSamplePacket},
      Module[{
        ovenTemperature, desiccatorTime, ovenTemperatureTooHighForContainerError, ovenTemperatureTooHighForSampleError,
        sampleLabel, sampleContainerLabel, objectToNewResolvedLabelLookup, sampleOutLabel, containerOutLabel
      },

        (* Resolve the labels *)
        objectToNewResolvedLabelLookup = {};
        sampleLabel=Which[
          MatchQ[Lookup[options, SampleLabel], Except[Automatic]],
            Lookup[options, SampleLabel],
          MatchQ[originalInputObject, ObjectP[{Object[Container], Model[Container]}]],
            Null,
          MatchQ[currentSimulation, SimulationP] && MatchQ[originalInputObject, ObjectP[{Object[Sample], Model[Sample]}]] && MatchQ[LookupObjectLabel[currentSimulation, Download[originalInputObject, Object]], _String],
            LookupObjectLabel[currentSimulation, Download[originalInputObject, Object]],
          KeyExistsQ[objectToNewResolvedLabelLookup, originalInputObject],
            Lookup[objectToNewResolvedLabelLookup, originalInputObject],
          True,
            Module[{newLabel},
              newLabel=CreateUniqueLabel["oven dry sample label"];

              AppendTo[objectToNewResolvedLabelLookup, originalInputObject -> newLabel];

              newLabel
            ]
        ];
        sampleContainerLabel=Which[
          MatchQ[Lookup[options, SampleContainerLabel], Except[Automatic]],
            Lookup[options, SampleContainerLabel],
          MatchQ[currentSimulation, SimulationP] && MatchQ[containerObject, ObjectP[{Object[Container], Model[Container]}]] && MatchQ[LookupObjectLabel[currentSimulation, Download[containerObject, Object]], _String],
            LookupObjectLabel[currentSimulation, Download[containerObject, Object]],
          KeyExistsQ[objectToNewResolvedLabelLookup, containerObject],
            Lookup[objectToNewResolvedLabelLookup, containerObject],
          True,
            Module[{newLabel},
              newLabel=CreateUniqueLabel["oven dry container label"];

              AppendTo[objectToNewResolvedLabelLookup, containerObject -> newLabel];

              newLabel
            ]
        ];
        sampleOutLabel=Which[
          MatchQ[Lookup[options, SampleOutLabel], Except[Automatic]],
            Lookup[options, SampleOutLabel],
          MatchQ[originalInputObject, ObjectP[{Object[Container], Model[Container]}]],
            Null,
          True,
            Module[{newLabel},
              newLabel=CreateUniqueLabel["oven dry sample out label"];

              newLabel
            ]
        ];
        containerOutLabel=Which[
          MatchQ[Lookup[options, ContainerOutLabel], Except[Automatic]],
            Lookup[options, SampleContainerLabel],
          True,
            Module[{newLabel},
              newLabel=CreateUniqueLabel["oven dry container out label"];

              newLabel
            ]
        ];

        (* Resolve what oven temperature to use *)
        ovenTemperature = Which[

          (* If user-supplied, take it *)
          MatchQ[Lookup[options, OvenTemperature], Except[Automatic]],
            Lookup[options, OvenTemperature],

          (* If the original input object was a sample, we're presumably dehydrating and going to 110 Celsius *)
          MatchQ[originalInputObject, ObjectP[{Object[Sample], Model[Sample]}]],
            110*Celsius,

          (* If we have a max temperature and it's less than 250 Celsius, crank it up to the MaxTemperature *)
          !NullQ[Lookup[modelContainerPacket, MaxTemperature]] && LessQ[Lookup[modelContainerPacket, MaxTemperature], 250*Celsius],
            Lookup[modelContainerPacket, MaxTemperature],

          (* Otherwise, we're cranking it up to 250 Celsius *)
          True,
            250*Celsius
        ];

        (* Resolved the desiccator time *)
        desiccatorTime = If[

          (* If user-supplied, take it *)
          MatchQ[Lookup[options, DesiccatorTime], Except[Automatic]],
            Lookup[options, DesiccatorTime],

          (* Otherwise, we're resolving based on the oven temperature above 25 Celsius *)
          Unitless[UnitConvert[ovenTemperature, Celsius] - 25*Celsius] * 0.25 Minute
        ];

        (* Errors. Set our error booleans to False. *)
        {ovenTemperatureTooHighForContainerError, ovenTemperatureTooHighForSampleError} = {False, False};

        (* First, is our oven temperature too high for the container? *)
        (* We'll be super careful here. If we don't have a listed max temperature, there's no way we're oven heating this thing. *)
        (* Also, ignore this if we're swapping containers anyhow. *)
        ovenTemperatureTooHighForContainerError = And[
          GreaterQ[ovenTemperature, Lookup[modelContainerPacket, MaxTemperature]/.{Null -> 25*Celsius}],
          !MemberQ[Join[nonGlassContainerSampleInputs, glassNonGL45ContainerSampleInputs], originalInputObject]
        ];

        (* Next, is our oven temperature too high for our sample? *)
        (* We'll be less careful with samples. Pretend that Null is 115 Celsius. *)
        (* However, we are not exceeding 115 C for any sample. *)
        ovenTemperatureTooHighForSampleError = !NullQ[objectSamplePacket] && Or[
          GreaterQ[ovenTemperature, Lookup[objectSamplePacket, MaxTemperature, 115*Celsius]/.{Null -> 115*Celsius}],
          (GreaterQ[ovenTemperature, 115*Celsius] && !NullQ[Lookup[objectSamplePacket, Object, Null]])
        ];

        {
          sampleLabel, sampleContainerLabel, sampleOutLabel, containerOutLabel, ovenTemperature, desiccatorTime,
          ovenTemperatureTooHighForContainerError, ovenTemperatureTooHighForSampleError
        }
      ]
    ],
    {myInputs, myContainers, mapThreadFriendlyOptions, modelContainerPackets, objectSamplePacketList}
  ];

  (* Resolve post-processing options *)
  resolvedPostProcessingOptions = resolvePostProcessingOptions[Normal[roundedExperimentOptions, Association]];

  (* Gather all options together *)
  resolvedOptions = ReplaceRule[
    Normal[roundedExperimentOptions, Association],
    {
      OvenTemperature -> resolvedOvenTemperatures,
      DesiccatorTime -> resolvedDesiccatorTimes,
      ImageSample -> Lookup[resolvedPostProcessingOptions, ImageSample],
      MeasureVolume -> Lookup[resolvedPostProcessingOptions, MeasureVolume],
      MeasureWeight -> Lookup[resolvedPostProcessingOptions, MeasureWeight],
      SamplesInStorageCondition -> Lookup[myOptions, SamplesInStorageCondition],
      TransferSamples -> transferSamples,
      SampleLabel -> resolvedSampleLabels,
      SampleContainerLabel -> resolvedSampleContainerLabels,
      SampleOutLabel -> resolvedSampleOutLabels,
      ContainerOutLabel -> resolvedContainerOutLabels
    }
  ];

  mapThreadFriendlyResolvedOptions=OptionsHandling`Private`mapThreadOptions[ExperimentOvenDry,resolvedOptions];

  (* UNRESOLVABLE OPTIONS *)
  (* - Throw Error for ovenTemperatureTooHighForContainerErrors - *)
  (* First, determine if we need to throw this Error *)
  ovenTemperatureTooHighForContainerErrorQ=MemberQ[ovenTemperatureTooHighForContainerErrors,True];

  (* Create lists of the input samples that have the ovenTemperatureTooHighForContainerError set to True and to False *)
  failingOvenTemperatureContainers=PickList[myContainers,ovenTemperatureTooHighForContainerErrors,True];
  passingOvenTemperatureContainers=PickList[myContainers,ovenTemperatureTooHighForContainerErrors,False];

  (* Define the invalid option variable *)
  invalidOvenTemperatureTooHighForContainerOptions=If[ovenTemperatureTooHighForContainerErrorQ,
    {OvenTemperature},
    {}
  ];

  (* Create lists of the OvenTemperature options that are failing (for Error message and Tests) *)
  failingOvenTemperatureForContainerValues=PickList[resolvedOvenTemperatures,ovenTemperatureTooHighForContainerErrors,True];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused ovenTemperatureTooHighForContainerErrors to be set to True *)
  If[ovenTemperatureTooHighForContainerErrorQ&&messagesQ,
    Message[Error::OvenTemperatureTooHighForContainer,ObjectToString[failingOvenTemperatureForContainerValues,Cache->cacheBall],ObjectToString[failingOvenTemperatureContainers, Cache->cacheBall],ObjectToString[Download[failingOvenTemperatureContainers, MaxTemperature, Cache->cacheBall]]]
  ];

  (* Define the tests the user will see for the above message *)
  ovenTemperatureTooHighForContainerTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[ovenTemperatureTooHighForContainerErrorQ,
        Test["The OvenTemperature(s), "<>ToString[failingOvenTemperatureForContainerValues]<>" for the following containers, "<>ObjectToString[failingOvenTemperatureContainers,Cache->cacheBall]<>", exceed those containers' MaxTemperature(s), "<>ToString[Download[failingOvenTemperatureContainers, MaxTemperature, Cache->cacheBall]]<>". OvenTemperature must be less than the MaxTemperature for the Container:",True,False],
        Nothing
      ];
      passingTest=If[Length[passingOvenTemperatureContainers]>0,
        Test["The following containers have OvenTemperatures which are not higher than their MaxTemperatures, "<>ObjectToString[passingOvenTemperatureContainers,Cache->cacheBall]<>":",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* - Throw Error for ovenTemperatureTooHighForSampleErrors - *)
  (* First, determine if we need to throw this Error *)
  ovenTemperatureTooHighForSampleErrorQ=MemberQ[ovenTemperatureTooHighForSampleErrors,True];

  (* Create lists of the input samples that have the ovenTemperatureTooHighForSampleError set to True and to False *)
  failingOvenTemperatureSamples=PickList[myInputs,ovenTemperatureTooHighForSampleErrors,True];
  passingOvenTemperatureSamples=PickList[myInputs,ovenTemperatureTooHighForSampleErrors,False];

  (* Define the invalid option variable *)
  invalidOvenTemperatureTooHighForSampleOptions=If[ovenTemperatureTooHighForSampleErrorQ,
    {OvenTemperature},
    {}
  ];

  (* Create lists of the OvenTemperature options that are failing (for Error message and Tests) *)
  failingOvenTemperatureForSampleValues=PickList[resolvedOvenTemperatures,ovenTemperatureTooHighForSampleErrors,True];

  (* Throw an Error if we are throwing messages, and there are some input samples that caused ovenTemperatureTooHighForSampleErrors to be set to True *)
  If[ovenTemperatureTooHighForSampleErrorQ&&messagesQ,
    Message[Error::OvenTemperatureTooHighForSample,ObjectToString[failingOvenTemperatureForSampleValues,Cache->cacheBall],ObjectToString[failingOvenTemperatureSamples, Cache->cacheBall],ObjectToString[Download[failingOvenTemperatureSamples, MaxTemperature, Cache->cacheBall]]]
  ];

  (* Define the tests the user will see for the above message *)
  ovenTemperatureTooHighForSampleTests=If[gatherTests,
    Module[{failingTest,passingTest},
      failingTest=If[ovenTemperatureTooHighForSampleErrorQ,
        Test["The OvenTemperature(s), "<>ToString[failingOvenTemperatureForSampleValues]<>" for the following samples, "<>ObjectToString[failingOvenTemperatureSamples,Cache->cacheBall]<>", exceed those containers' MaxTemperature(s), "<>ToString[Download[failingOvenTemperatureSamples, MaxTemperature, Cache->cacheBall]]<>". OvenTemperature must be less than the MaxTemperature for the Sample:",True,False],
        Nothing
      ];
      passingTest=If[Length[passingOvenTemperatureSamples]>0,
        Test["The following samples have OvenTemperatures which are not higher than their MaxTemperatures, "<>ObjectToString[passingOvenTemperatureSamples,Cache->cacheBall]<>":",True,True],
        Nothing
      ];
      {failingTest,passingTest}
    ],
    Nothing
  ];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs=DeleteDuplicates[Flatten[
    {
      discardedInvalidInputs,nonGlassContainerInputs
    }
  ]];
  invalidOptions=DeleteDuplicates[Flatten[
    {
      invalidOvenTemperatureTooHighForContainerOptions, invalidOvenTemperatureTooHighForSampleOptions
    }
  ]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cacheBall]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (* Return. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> Cases[
      Flatten@{
        discardedTests, nonGlassContainerTests, nonGlassContainerSampleTests, nonGL45ContainerSampleTests, ovenTemperatureTooHighForContainerTests,
        ovenTemperatureTooHighForSampleTests, optionPrecisionTests
      },
      _EmeraldTest
    ]
  }
];

(* ::Subsection:: *)
(*ovenDryResourcePackets*)

DefineOptions[
  ovenDryResourcePackets,
  Options:>{ExperimentOutputOption,CacheOption,SimulationOption}
];

(* Create the protocol with resources included *)
ovenDryResourcePackets[myInputs:{ObjectP[{Object[Container], Object[Sample]}]..}, myContainers:{ObjectP[Object[Container]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, myOptions : OptionsPattern[]] := Module[
  {
    safeOps, expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests,
    messages, cache, simulation, ovens, ovenTimes, ovenTemperatures, desiccator, desiccatorTimes, inputsAndOptions, inputsGroupedByOvenAndOvenTemp,
    ovensAndTempsNoDupes, ovensAndTempsMaxTimes, ovenResources, desiccatorMaxTime, desiccatorResource,
    mapThreadFriendlyResolvedOptions, ovenResourceReplaceRules, desiccatorResourceReplaceRules, sampleResources, protocolPacket,
    groupedInputsIndices, unitOperationPackets, sharedFieldPacket, finalizedPacket, containerPackets, rawResourceBlobs, resourcesWithoutName,
    resourceToNameReplaceRules, allResourceBlobs, resourcesOk, resourceTests, testsRule, resultRule, ovenRampTimes, desiccantResource,
    desiccantContainerResource, ventingCapResources, transferSamples, sampleTransferUnitOperations

  },
  (* get the safe options for this function *)
  safeOps = SafeOptions[ovenDryResourcePackets, ToList[myOptions]];

  (* Expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentOvenDry, {myInputs}, myResolvedOptions];

  (* get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    ExperimentOvenDry,
    RemoveHiddenOptions[ExperimentDynamicLightScattering, myResolvedOptions],
    Ignore -> myUnresolvedOptions,
    Messages -> False
  ];

  (* pull out the Output option and make it a list *)
  outputSpecification = Lookup[safeOps, Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests; if True, then silence the messages *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* lookup helper options *)
  {cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

  (* Put together container packets *)
  containerPackets = Quiet[
    Download[myContainers, Packet[Name, Contents, Notebook], Simulation->simulation, Cache->cache],
    {Download::FieldDoesntExist, Download::NotLinkField}
  ];

  (* Pull the options out *)
  {ovens, ovenTimes, ovenTemperatures, desiccator, desiccatorTimes, transferSamples} = Lookup[
    expandedResolvedOptions,
    {Oven, OvenTime, OvenTemperature, Desiccator, DesiccatorTime, TransferSamples}
  ];

  (* Get a map thread friendly version of our resolved options. *)
  mapThreadFriendlyResolvedOptions=OptionsHandling`Private`mapThreadOptions[ExperimentCover, myResolvedOptions];

  sampleResources=(Which[
    MatchQ[#, ObjectP[Model[]]],
      Resource[Sample->#],
    MatchQ[#, ObjectP[Object[]]],
      Resource[Sample->Link[Download[#, Object]]],
    True,
      Null
  ]&)/@myInputs;

  (* We also need to create venting cap resources here, for all sample inputs (not containers). *)
  ventingCapResources = If[MatchQ[#, ObjectP[{Model[Sample], Object[Sample]}]],
    Resource[Sample -> Model[Item, Cap, "id:N80DNjkzeLvA"]], (*"GL45 Bottle Cap Vented"*)
    Null
  ]&/@myInputs;

  (* If we need to transfer samples, set that up here *)
  sampleTransferUnitOperations = (Transfer[
    Source -> #,
    Destination -> Model[Container, Vessel, "id:J8AY5jwzPPR7"], (* "250mL Glass Bottle" *)
    Amount -> All
  ]&)/@transferSamples;

  (* If we need the same oven at the same temperature, then even if the times are different, we can heat them together. *)

  (* Smush the inputs and options together. *)
  inputsAndOptions = MapThread[Prepend[#1, #2]&, {Transpose[{ovens, ovenTimes, ovenTemperatures, desiccatorTimes, ventingCapResources}], myInputs}];

  (* Functionally, if an oven needs two different temps, we can run it back to back at best. So we need to isolate the oven/temperature combos. *)
  ovensAndTempsNoDupes = DeleteDuplicates[Part[#, {2, 4}]&/@inputsAndOptions];

  (* Then let's figure out the longest time needed for each oven/temp combo *)
  ovensAndTempsMaxTimes = Map[
    Function[{ovenTempCombo},
      Max[
        Map[
          Function[{inputAndOptions},
            If[MatchQ[inputAndOptions, {_, ObjectP[First[ovenTempCombo]], _, Last[ovenTempCombo], ___}],
              inputAndOptions[[3]],
              Nothing
            ]
          ],
          inputsAndOptions
        ]
      ]
    ],
    ovensAndTempsNoDupes
  ];

  (* We also need to figure out which inputs are going with which oven/temp combo. Similar logic. *)
  {inputsGroupedByOvenAndOvenTemp, groupedInputsIndices} = Transpose@Map[
    Function[{ovenTempCombo},
      Transpose@MapThread[
        Function[{inputAndOptions, index},
          If[MatchQ[inputAndOptions, {_, ObjectP[First[ovenTempCombo]], _, Last[ovenTempCombo], ___}],
            {First[inputAndOptions], index},
            Nothing
          ]
        ],
        {inputsAndOptions, Range[Length[inputsAndOptions]]}
      ]
    ],
    ovensAndTempsNoDupes
  ];

  (* Make the oven resources *)
  ovenResources = MapThread[Resource[Instrument -> First[#1], Time -> #2]&, {ovensAndTempsNoDupes, ovensAndTempsMaxTimes}];

  (* Make a replace rule for ovens *)
  ovenResourceReplaceRules = MapThread[(First[#1] -> #2)&, {ovensAndTempsNoDupes, ovenResources}];

  (* Similar logic for desiccator, but a lot simpler *)
  desiccatorMaxTime = Max[
    Map[
      Function[{inputAndOptions},
        If[MatchQ[desiccator, ObjectP[desiccator]],
          inputAndOptions[[5]],
          Nothing
        ]
      ],
      inputsAndOptions
    ]
  ];

  (* Make the desiccator resources *)
  desiccatorResource = Resource[Instrument -> desiccator, Time -> desiccatorMaxTime];
  desiccatorResourceReplaceRules = {desiccator -> desiccatorResource};
  desiccantResource = Resource[Sample -> Model[Sample, "id:GmzlKjzrmB85"], Amount -> 110 Gram]; (*Indicating Drierite*)
  desiccantContainerResource = Resource[Sample -> Model[Container, Vessel, "id:01G6nvPVqYB7"]]; (*Model[Container, Vessel, "Pyrex Reusable Petri Dishes (100 x 20 mm)"]*)


  (* lastly, figure out our oven ramp times *)
  (* We're going to assume about 30 seconds per degree above the previous temperature that the oven was at and assume the oven is getting started at 25 Celsius *)
  ovenRampTimes = Module[
    {ovenTemps},
    ovenTemps = Prepend[Flatten[DeleteDuplicates[inputsAndOptions[[#]][[All, 4]]]&/@groupedInputsIndices], 25*Celsius];
    Map[
      If[ovenTemps[[#]] > ovenTemps[[#-1]],
        30 Second * Unitless[ovenTemps[[#]] - ovenTemps[[#-1]]],
        30 Second * Unitless[ovenTemps[[#-1]] - ovenTemps[[#]]]
      ]&,
      Range[2,Length[ovenTemps]]
    ]
  ];

  (* Assemble the UO and protocol packets *)
  unitOperationPackets = UploadUnitOperation[
    MapThread[
      Function[{index, ovenRampTime},
      (* Batch our unit operations together. *)
        OvenDry[
          Sample -> inputsAndOptions[[index]][[All, 1]],
          Oven -> inputsAndOptions[[index]][[All, 2]],
          OvenTime -> inputsAndOptions[[index]][[All, 3]],
          OvenTemperature -> inputsAndOptions[[index]][[All, 4]],
          Desiccator -> desiccator,
          DesiccatorTime -> inputsAndOptions[[index]][[All, 5]],
          OvenRampTime -> ovenRampTime,
          VentingCaps -> Link/@(inputsAndOptions[[index]][[All, 6]])
        ]
      ],
      {groupedInputsIndices, ovenRampTimes}
    ],
    Upload -> False
  ];

  protocolPacket = <|
    Object -> CreateID[Object[Protocol, OvenDry]],
    (* We are deleting duplicates here not because we should actually have any duplicate samples, but because using the Infinity *)
    (* levelspec with Cases weirdly duplicates things *)
    Replace[SamplesIn]->Flatten[If[
      MemberQ[Lookup[#, Contents], ObjectP[Object[Sample]], Infinity],
        (Link[#, Protocols] &)/@DeleteDuplicates[Download[Cases[Lookup[#, Contents], ObjectP[Object[Sample]], Infinity], Object]],
        Null
    ]&/@containerPackets],
    Replace[ContainersIn]->(Link[#, Protocols]&)/@DeleteDuplicates[myContainers],
    Replace[Oven] -> Link/@ovenResources,
    Replace[OvenTime] -> ovenTimes,
    Replace[OvenTemperature] -> ovenTemperatures,
    Replace[Desiccator] -> Link@desiccatorResource,
    Replace[DesiccatorTime] -> desiccatorTimes,
    Replace[Desiccant] -> Link@desiccantResource,
    Replace[DesiccantContainer] -> Link@desiccantContainerResource,
    Replace[VentingCaps] -> Link/@ventingCapResources,
    Replace[SampleTransferUnitOperations] -> sampleTransferUnitOperations,
    Author->If[MatchQ[Lookup[myResolvedOptions, ParentProtocol],Null],
      Link[$PersonID,ProtocolsAuthored]
    ],
    ParentProtocol->If[MatchQ[Lookup[myResolvedOptions, ParentProtocol],ObjectP[ProtocolTypes[Output -> Short]]],
      Link[Lookup[myResolvedOptions, ParentProtocol],Subprotocols]
    ],
    UnresolvedOptions -> RemoveHiddenOptions[ExperimentOvenDry, myUnresolvedOptions],
    ResolvedOptions -> myResolvedOptions,
    Name -> Lookup[myResolvedOptions, Name],
    Replace[BatchedUnitOperations] -> (Link[#, Protocol]&)/@Lookup[unitOperationPackets, Object],
    Replace[Checkpoints]->{
      {"Heating",Max[ovensAndTempsMaxTimes],"The samples are heated.",Link[Resource[Operator -> $BaselineOperator, Time -> Max[ovensAndTempsMaxTimes]]]},
      {"Cooling",Max[desiccatorMaxTime],"The samples are cooled in a desiccator.",Link[Resource[Operator -> $BaselineOperator, Time -> Max[desiccatorMaxTime]]]}
    }
  |>;

  (* Generate a packet with the shared fields. *)
  sharedFieldPacket = populateSamplePrepFields[myInputs, myResolvedOptions, Cache -> cache];

  (* Merge the shared fields with the specific fields. *)
  finalizedPacket = Join[sharedFieldPacket, protocolPacket];

  (* Make list of all the resources we need to check in FRQ. *)
  rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{protocolPacket, unitOperationPackets}],_Resource,Infinity]];

  (* Get all resources without a name. *)
  (* NOTE: Don't try to consolidate operator resources. *)
  resourcesWithoutName=DeleteDuplicates[Select[rawResourceBlobs, Resource[MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&]]];

  resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
  allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

  (* Verify we can satisfy all our resources. *)
  {resourcesOk,resourceTests}=Which[
    MatchQ[$ECLApplication,Engine],
      {True,{}},
    gatherTests,
      Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Simulation->simulation,Cache->cache],
    True,
      {Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Simulation->simulation,Cache->cache],Null}
  ];

  (* --- Output --- *)

  (* Generate the tests rule. *)
  testsRule=Tests->If[gatherTests,
    resourceTests,
    {}
  ];

  (* Generate the Result output rule *)
  (* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed. *)
  resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
    {finalizedPacket, unitOperationPackets}/.resourceToNameReplaceRules,
    $Failed
  ];

  (* Return the output as we desire it. *)
  outputSpecification/.{resultRule,testsRule}
];

(* ::Subsection::Closed:: *)
(* Simulation *)

DefineOptions[
  simulateExperimentCover,
  Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentOvenDry[
  myProtocolPacket:(PacketP[Object[Protocol, OvenDry], {Object, ResolvedOptions}]|$Failed|Null),
  myUnitOperationPackets:({PacketP[]..}|$Failed),
  myInputs:{ObjectP[{Object[Sample], Object[Container]}]..},
  myContainers:{ObjectP[Object[Container]]..},
  myResolvedOptions:{_Rule...},
  myResolutionOptions:OptionsPattern[simulateExperimentOvenDry]
]:=Module[
  {
    protocolObject, mapThreadFriendlyOptions, resolvedPreparation, currentSimulation, unitOperationField,
    simulatedUnitOperationPackets, simulationWithLabels, simulatedProtocol, simulatedContainersIn, simulatedSamplesIn,
    simulatedSampleTransferUOs, containersToTransferFrom, samplesToTransfer, simulatedContainersOutPackets, simulatedSamplesOutPackets,
    ustPackets, samplesOutReplaceRules, containersOutReplaceRules
  },

  (* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
  protocolObject=If[
    (* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
    MatchQ[myProtocolPacket, $Failed],
      SimulateCreateID[Object[Protocol,OvenDry]],
      Lookup[myProtocolPacket, Object]
  ];

  (* Get our map thread friendly options. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
    ExperimentOvenDry,
    myResolvedOptions
  ];

  (* Lookup our resolved preparation option. *)
  resolvedPreparation=Lookup[myResolvedOptions, Preparation];

  (* Simulate the fulfillment of all resources by the procedure. *)
  (* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
  (* just make a shell of a protocol object so that we can return something back. *)
  currentSimulation=If[

    (* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
    (* and skipped resource packet generation. *)
    MatchQ[myProtocolPacket, $Failed],
    SimulateResources[
      <|
        Object->protocolObject,
        Replace[ContainersIn]->(Link[Resource[Sample->#]]&)/@DeleteDuplicates[myContainers],
        ResolvedOptions->myResolvedOptions,
        UnresolvedOptions -> {}
      |>,
      Cache->Lookup[ToList[myResolutionOptions], Cache, {}],
      Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]
    ],

    (* Otherwise, our resource packets went fine and we have an Object[Protocol, Cover]. *)
    SimulateResources[myProtocolPacket, myUnitOperationPackets, Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]]
  ];

  (*If SampleTransferUnitOperations is populated, a new sample should be created*)
  simulatedProtocol = Download[protocolObject, Simulation -> currentSimulation];
  simulatedContainersIn = Lookup[simulatedProtocol, ContainersIn];
  simulatedSamplesIn = Lookup[simulatedProtocol, SamplesIn];
  simulatedSampleTransferUOs = Lookup[simulatedProtocol, SampleTransferUnitOperations];
  samplesToTransfer = #[Source]&/@simulatedSampleTransferUOs;
  containersToTransferFrom = PickList[myContainers, MemberQ[#, Alternatives@@samplesToTransfer]&/@myInputs];

  (* Simulate new ContainersOut and then new SamplesOut *)
  simulatedContainersOutPackets = UploadSample[
    #[Destination]&/@simulatedSampleTransferUOs,
    ConstantArray[{"A1", Object[Container, Shelf, "id:Y0lXejMZvWPa"]}, Length[simulatedSampleTransferUOs]], (*"Ambient Storage Shelf"*)
    Simulation -> currentSimulation,
    UpdatedBy -> protocolObject,
    FastTrack -> True,
    Upload -> False
  ];

  (* Update the simulation with the new ContainersOut *)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulatedContainersOutPackets]];

  (* Now create the new empty sample packets, which we will eventually transfer stuff into *)
  simulatedSamplesOutPackets = UploadSample[
    ConstantArray[{}, Length[simulatedSampleTransferUOs]],
    {"A1", #}&/@DeleteDuplicates[Cases[Lookup[simulatedContainersOutPackets, Object], ObjectP[Object[Container, Vessel]]]],
    State -> ConstantArray[Solid, Length[simulatedSampleTransferUOs]],
    InitialAmount -> ConstantArray[Null, Length[simulatedSampleTransferUOs]],
    Simulation -> currentSimulation,
    UpdatedBy -> protocolObject,
    FastTrack -> True,
    Upload -> False
  ];

  (* Update the simulation with the new SamplesOut *)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulatedSamplesOutPackets]];

  (* Lastly transfer the necessary samples into the new samples *)
  ustPackets = UploadSampleTransfer[
    samplesToTransfer,
    DeleteDuplicates[Cases[Lookup[simulatedSamplesOutPackets, Object], ObjectP[Object[Sample]]]],
    ConstantArray[All, Length[simulatedSampleTransferUOs]],
    Upload -> False,
    FastTrack -> True,
    Simulation -> currentSimulation,
    UpdatedBy -> protocolObject
  ];

  (* Again update the simulation *)
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[ustPackets]];

  (* We want to organize our samples out and containers out for the labeling stuff below *)
  samplesOutReplaceRules = MapThread[(#1->#2)&,{samplesToTransfer, DeleteDuplicates[Cases[Lookup[simulatedSamplesOutPackets, Object], ObjectP[Object[Sample]]]]}];
  containersOutReplaceRules = MapThread[(#1->#2)&,{containersToTransferFrom, DeleteDuplicates[Cases[Lookup[simulatedContainersOutPackets, Object], ObjectP[Object[Container, Vessel]]]]}];

  (* Figure out what field to download from. *)
  unitOperationField=If[MatchQ[protocolObject, ObjectP[Object[Protocol, OvenDry]]],
    BatchedUnitOperations,
    OutputUnitOperations
  ];

  (* Download information from our simulated resources. *)
  simulatedUnitOperationPackets=Quiet[
    With[{insertMe=unitOperationField},
      Download[
        protocolObject,
        Packet[insertMe[{SampleLink}]],
        Simulation->currentSimulation
      ]
    ],
    {Download::NotLinkField, Download::FieldDoesntExist}
  ];

  (* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the SamplesIn field. *)
  simulationWithLabels=Simulation[
    Labels->Rule@@@Join[
      Cases[
        Transpose[{Lookup[myResolvedOptions, SampleLabel], myInputs}],
        {_String, ObjectP[Object[Sample]]}
      ],
      Cases[
        Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], myContainers}],
        {_String, ObjectP[Object[Container]]}
      ],
      Cases[
        Transpose[{Lookup[myResolvedOptions, SampleOutLabel], myInputs/.samplesOutReplaceRules}],
        {_String, ObjectP[Object[Sample]]}
      ],
      Cases[
        Transpose[{Lookup[myResolvedOptions, ContainerOutLabel], myContainers/.containersOutReplaceRules}],
        {_String, ObjectP[Object[Container]]}
      ]
    ],
    LabelFields->Rule@@@Join[
      Cases[
        Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[myContainers]]}],
        {_String, _}
      ],
      Cases[
        Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[myContainers]]}],
        {_String, _}
      ],
      Cases[
        Transpose[{Lookup[myResolvedOptions, SampleOutLabel], (Field[SamplesOut[[#]]]&)/@Range[Length[myContainers]]}],
        {_String, _}
      ],
      Cases[
        Transpose[{Lookup[myResolvedOptions, ContainerOutLabel], (Field[ContainersOut[[#]]]&)/@Range[Length[myContainers]]}],
        {_String, _}
      ]
    ]
  ];

  (* Merge our packets with our labels. *)
  {
    protocolObject,
    UpdateSimulation[currentSimulation, simulationWithLabels]
  }
];
