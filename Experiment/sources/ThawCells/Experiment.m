(* ::Package:: *)

(* ::Title:: *)
(*Experiment Incubate: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*ExperimentThawCells*)


(* ::Subsection::Closed:: *)
(*Options*)


DefineOptions[
  ExperimentThawCells,
  Options :> {
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      (* -- PROTOCOL -- *)
      {
        OptionName -> SampleLabel,
        Default -> Automatic,
        Description -> "The label of the cell sample(s) that are thawed, which is used for identification elsewhere in cell preparation.",
        AllowNull -> False,
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Line
        ],
        Category->"General",
        UnitOperation -> True
      },
      {
        OptionName -> SampleContainerLabel,
        Default -> Automatic,
        Description -> "The label of the container(s) of the cell sample(s) that are thawed, which is used for identification elsewhere in cell preparation.",
        AllowNull -> False,
        Widget->Widget[
          Type->String,
          Pattern:>_String,
          Size->Line
        ],
        Category->"General",
        UnitOperation -> True
      },

      {
        OptionName -> Container,
        Default -> Automatic,
        Description -> "The container of the sample that will be thawed.",
        ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to the Model[Container] that the default product for the Model[Sample] comes in.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Alternatives[
          "Existing Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Object[Container]]
          ],
          "Container Model"-> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[Container]]
          ]
        ]
      },
      {
        OptionName -> Amount,
        Default -> Automatic,
        Description -> "The amount of sample that needs to be in the container to fulfill the resource request.",
        ResolutionDescription -> "Automatically set to the default Amount of the Model[Sample] in the Object[Product], otherwise set to Null if it's an Object[Sample].",
        AllowNull -> False,
        Category -> "Hidden",
        Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milliliter],Units :> Milliliter]
      },
      {
        OptionName->Instrument,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[{
            (* NOTE: We can only use frozen samples that come in CryogenicVial with this instrument. Check ExperimentFreezeCell's helper whyCantThisModelBeCryogenicVial *)
            Model[Instrument, CellThaw],
            Object[Instrument, CellThaw],

            Model[Instrument, HeatBlock],
            Object[Instrument, HeatBlock],

            Model[Instrument, Shaker],
            Object[Instrument, Shaker]
          }]
        ],
        Description->"The instrument used to gently heat the frozen cell sample until it is thawed.",
        ResolutionDescription->"Automatically set to Model[Instrument, CellThaw, \"ThawSTAR\"], if the samples are in a cryogenic vial. Otherwise, set to Model[Instrument, HeatBlock, \"Cole-Parmer StableTemp Digital Utility Water Baths, 10 liters\"].",
        Category->"Thawing"
      },
      {
        OptionName->Time,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime],Units :> Minute],
        Description->"The minimum duration of time that the frozen samples are placed in the instrument until the sample is fully thawed.",
        ResolutionDescription->"Automatically set to 30 Second if using a heat block, otherwise, set to Null (the ThawSTAR automatically measures the phase change of the sample and stops when the sample is fully thawed).",
        Category->"Thawing"
      },
      {
        OptionName->MaxTime,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[Type -> Quantity, Pattern :> RangeP[0 Minute, $MaxExperimentTime],Units :> Minute],
        Description->"The maximum duration of time that the frozen samples are placed in the instrument until the sample is fully thawed.",
        ResolutionDescription->"Automatically set to 1 Minute if using a heat block, otherwise, set to Null (the ThawSTAR automatically measures the phase change of the sample and stops when the sample is fully thawed).",
        Category->"Thawing"
      },
      {
        OptionName->Temperature,
        Default->Automatic,
        AllowNull->True,
        Widget->Alternatives[
          "Temperature"->Widget[Type -> Quantity, Pattern :> RangeP[25 Celsius, 100 Celsius],Units :> Celsius],
          "Ambient"->Widget[
            Type->Enumeration,
            Pattern:>Alternatives[Ambient]
          ]
        ],
        Description->"The temperature that the frozen cells are thawed at. This option can only be set when using a heat block (when using the automatic cell thawing instrument, the temperature is automatically adjusted based on phase change of the sample).",
        ResolutionDescription->"Automatically set to 37 Celsius, if using a heat block. Otherwise, set to Null.",
        Category->"Thawing"
      },

      {
        OptionName->Method,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
          Type->Object,
          Pattern:>ObjectP[Object[Method, ThawCells]]
        ],
        Description->"The default method parameters to use when thawing these cells.",
        ResolutionDescription->"Automatically set to the ThawCellsMethod of the Model[Cell]s in the Composition of the sample to be thawed, if populated. Otherwise, set to Null.",
        Category->"Protocol"
      }
    ],

    (* Other shared options. *)
    ProtocolOptions,
    PreparationOption,
    WorkCellOption,
    SimulationOption
  }
];


(* ::Subsection::Closed:: *)
(*ExperimentThawCells *)

fetchModelPacketFromCache[myObject_,myCachedPackets_]:=fetchPacketFromCache[Download[Lookup[fetchPacketFromCache[myObject,myCachedPackets],Model],Object],myCachedPackets];

(* Container and Prepared Samples Overload *)
ExperimentThawCells[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {listedContainers,listedOptions,outputSpecification,output,gatherTests,containerToSampleResult,containerToSampleOutput,containerToSampleSimulation,
    samples,sampleOptions,containerToSampleTests,updatedCache, simulation},

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

  (* Lookup simulation option if it exists *)
  simulation = Lookup[listedOptions,Simulation,Null];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
      ExperimentThawCells,
      listedContainers,
      listedOptions,
      Output->{Result,Tests,Simulation},
      Simulation->Lookup[listedOptions, Simulation, Null],
      EmptyContainers->MatchQ[$ECLApplication,Engine],
      Simulation->simulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
        ExperimentThawCells,
        listedContainers,
        listedOptions,
        Output-> {Result,Simulation},
        Simulation->Lookup[listedOptions, Simulation, Null],
        EmptyContainers->MatchQ[$ECLApplication,Engine]
      ],
      $Failed,
      {Download::ObjectDoesNotExist, Error::EmptyContainer}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult,$Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null,
      InvalidInputs -> {},
      InvalidOptions -> {}
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples,sampleOptions}=containerToSampleOutput;

    (* Call our main function with our samples, converted options, and simulated cache. *)
    ExperimentThawCells[samples,ReplaceRule[sampleOptions, {Simulation -> containerToSampleSimulation}]]
  ]
];

ExperimentThawCells[myInputs:ListableP[ObjectP[{Object[Sample], Model[Sample]}]],myOptions:OptionsPattern[]]:=Module[
  {listedSamples,outputSpecification,output,gatherTests,safeOps,safeOpsTests,validLengths,validLengthTests,
    templatedOptions,templateTests,inheritedOptions,expandedSafeOps,resolvedOptionsResult,cache,messages,
    resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourceResult,resourcePacketTests,
    simulation,returnEarlyQ,resolvedPreparation,performSimulationQ,simulatedProtocol,listedSamplesNamed,listedOptionsNamed,safeOpsNamed},

  (* Determine the requested return value from the function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];
  messages=!gatherTests;

  (* Lookup our cache. *)
  cache=Lookup[ToList[myOptions], Cache, {}];

  (* Remove temporal links. *)
  {listedSamplesNamed, listedOptionsNamed}=removeLinks[ToList[myInputs], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentThawCells,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentThawCells,listedOptionsNamed,AutoCorrect->False],{}}
  ];

  (* replace all objects referenced by Name to ID *)
  {listedSamples, safeOps} = sanitizeInputs[listedSamplesNamed, safeOpsNamed, Simulation->Lookup[safeOpsNamed, Simulation, Null]];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentThawCells,{listedSamples},safeOpsNamed,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentThawCells,{listedSamples},safeOpsNamed],Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests,validLengthTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentThawCells,{listedSamples},safeOps,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentThawCells,{listedSamples},safeOps],Null}
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
  inheritedOptions = ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentThawCells,{listedSamples},inheritedOptions]];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

  (* Build the resolved options *)
  resolvedOptionsResult = Check[
    {resolvedOptions,resolvedOptionsTests} = If[gatherTests,
      resolveThawCellsOptions[listedSamples,expandedSafeOps,Cache->cache,Simulation->Lookup[safeOps, Simulation],Output->{Result,Tests}],
      {resolveThawCellsOptions[listedSamples,expandedSafeOps,Cache->cache,Simulation->Lookup[safeOps, Simulation]],{}}
    ],
    $Failed,
    {Error::InvalidInput,Error::InvalidOption}
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions=CollapseIndexMatchedOptions[
    ExperimentThawCells,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed], True,
    gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True, False
  ];

  (* Lookup our resolved Preparation option. *)
  resolvedPreparation = Lookup[safeOps, Preparation];

  (* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
  (* need to return some type of simulation to our parent function that called us. *)
  performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP] || MatchQ[Lookup[resolvedOptions, Preparation], Robotic];

  (* If option resolution failed and we aren't asked for the simulation or output, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentThawCells,collapsedResolvedOptions],
      Preview->Null,
      Simulation->Simulation[]
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
  {resourceResult,resourcePacketTests}=If[returnEarlyQ,
    {$Failed, {}},
    If[gatherTests,
      thawCellsResourcePackets[listedSamples,expandedSafeOps,resolvedOptions,collapsedResolvedOptions,Cache->cache,Simulation->Lookup[safeOps, Simulation],Output->{Result,Tests}],
      {thawCellsResourcePackets[listedSamples,expandedSafeOps,resolvedOptions,collapsedResolvedOptions,Cache->cache,Simulation->Lookup[safeOps, Simulation]],{}}
    ]
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  (* NOTE: We use this simulation function for both wash cells and thaw cells. *)
  {simulatedProtocol, simulation} = If[performSimulationQ,
    simulateExperimentThawCells[
      If[MatchQ[resourceResult, $Failed],
        $Failed,
        resourceResult[[1]] (* protocolPacket *)
      ],
      If[MatchQ[resourceResult, $Failed],
        $Failed,
        ToList[resourceResult[[2]]] (* unitOperationPackets *)
      ],
      listedSamples,
      resolvedOptions,
      Cache->cache,
      Simulation->Lookup[safeOps, Simulation]
    ],
    {Null, Lookup[safeOps, Simulation]}
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentThawCells,collapsedResolvedOptions],
      Preview -> Null,
      Simulation->simulation
    }]
  ];

  (* Upload our protocol object, if asked to do so by the user. *)
  protocolObject = Which[
    (* If our resource packets failed, we can't upload anything. *)
    MatchQ[resourceResult,$Failed],
      $Failed,

    (* If we're doing Preparation->Robotic, return our unit operations packets back without RequireResources called if *)
    (* Upload->False. *)
    MatchQ[resolvedPreparation, Robotic] && MatchQ[Lookup[safeOps,Upload], False],
      resourceResult[[2]], (* unitOperationPackets *)

    (* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticCellPreparation with our primitive. *)
    MatchQ[resolvedPreparation, Robotic],
      Module[{primitive, nonHiddenOptions},
        (* Create our transfer primitive to feed into RoboticSamplePreparation. *)
        primitive=ThawCells@@Join[
          {
            Sample->myInputs
          },
          RemoveHiddenPrimitiveOptions[ThawCells,ToList[myOptions]]
        ];

        (* Remove any hidden options before returning. *)
        nonHiddenOptions=RemoveHiddenOptions[ExperimentThawCells, collapsedResolvedOptions];

        (* Memoize the value of ExperimentThawCells so the framework doesn't spend time resolving it again. *)
        Internal`InheritedBlock[{ExperimentThawCells, $PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache=<||>;

          DownValues[ExperimentThawCells]={};

          ExperimentThawCells[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for. *)
            frameworkOutputSpecification=Lookup[ToList[options], Output];

            frameworkOutputSpecification/.{
              Result -> resourceResult[[2]],
              Options -> nonHiddenOptions,
              Preview -> Null,
              Simulation -> simulation,
              RunTime -> (5 Minute * Length[ToList[myInputs]])
            }
          ];

          (* ThawCells can only be done on bioSTAR/microbioSTAR, so call RCP *)
          ExperimentRoboticCellPreparation[
            {primitive},
            Name->Lookup[safeOps,Name],
            Upload->Lookup[safeOps,Upload],
            Confirm->Lookup[safeOps,Confirm],
            CanaryBranch->Lookup[safeOps,CanaryBranch],
            ParentProtocol->Lookup[safeOps,ParentProtocol],
            Priority->Lookup[safeOps,Priority],
            StartDate->Lookup[safeOps,StartDate],
            HoldOrder->Lookup[safeOps,HoldOrder],
            QueuePosition->Lookup[safeOps,QueuePosition],
            Simulation -> simulation
          ]
        ]
      ],

    (* If we're doing Preparation->Manual AND our ParentProtocol isn't ManualCellPreparation, generate an *)
    (* Object[Protocol, ManualCellPreparation]. *)
    (* NOTE: Transfer doesn't have sample prep options so don't copy this one. *)
    !MatchQ[Lookup[safeOps,ParentProtocol], ObjectP[Object[Protocol, ManualCellPreparation]]],
      Module[{primitive, nonHiddenOptions},
        (* Create our transfer primitive to feed into RoboticSamplePreparation. *)
        primitive=ThawCells@@Join[
          {
            Sample->myInputs
          },
          RemoveHiddenPrimitiveOptions[ThawCells,ToList[myOptions]]
        ];

        (* Remove any hidden options before returning (with some exceptions). *)
        nonHiddenOptions=RemoveHiddenOptions[ExperimentThawCells, collapsedResolvedOptions];

        (* Memoize the value of ExperimentThawCells so the framework doesn't spend time resolving it again. *)
        Internal`InheritedBlock[{ExperimentThawCells, $PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache=<||>;

          DownValues[ExperimentThawCells]={};

          ExperimentThawCells[___, options:OptionsPattern[]]:=Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for. *)
            frameworkOutputSpecification=Lookup[ToList[options], Output];

            frameworkOutputSpecification/.{
              Options -> nonHiddenOptions,
              Preview -> Null,
              Simulation -> simulation
            }
          ];

          ExperimentManualCellPreparation[
            {primitive},
            Name->Lookup[safeOps,Name],
            Upload->Lookup[safeOps,Upload],
            Confirm->Lookup[safeOps,Confirm],
            CanaryBranch->Lookup[safeOps,CanaryBranch],
            ParentProtocol->Lookup[safeOps,ParentProtocol],
            Priority->Lookup[safeOps,Priority],
            StartDate->Lookup[safeOps,StartDate],
            HoldOrder->Lookup[safeOps,HoldOrder],
            QueuePosition->Lookup[safeOps,QueuePosition],
            Simulation -> simulation
          ]
        ]
      ],

    (* Actually upload our protocol object. We are being called as a subprotcol in ExperimentManualCellPreparation. *)
    True,
      UploadProtocol[
        resourceResult[[1]], (* protocolPacket *)
        resourceResult[[2]], (* unitOperationPackets *)
        Upload->Lookup[safeOps,Upload],
        Confirm->Lookup[safeOps,Confirm],
        CanaryBranch->Lookup[safeOps,CanaryBranch],
        ParentProtocol->Lookup[safeOps,ParentProtocol],
        Priority->Lookup[safeOps,Priority],
        StartDate->Lookup[safeOps,StartDate],
        HoldOrder->Lookup[safeOps,HoldOrder],
        QueuePosition->Lookup[safeOps,QueuePosition],
        ConstellationMessage->Object[Protocol,ThawCells],
        Simulation->simulation
      ]
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentThawCells,collapsedResolvedOptions],
    Preview -> Null,
    Simulation->simulation
  }
];


(* ::Subsection:: *)
(*ResolveOptions*)


DefineOptions[
  resolveThawCellsOptions,
  Options:>{ResolverOutputOption,CacheOption,SimulationOption}
];

DefineOptions[
  resolveThawCellsMethod,
  SharedOptions:>{
    ExperimentThawCells,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

Error::ThawInstrumentTemperatureMismatch="The sample(s), `1`, have the Temperature option set to, `2`, but have their Instrument option set to, `3`. The Temperature option must be set when the Instrument is a Model/Object[Instrument, HeatBlock]. When using an automated CellThaw instrument (Model[Instrument, CellThaw]), the temperature is automatically adjusted according to the measured phase change of the sample and therefore, the Temperature option cannot be set. Please let the Temperature option resolve automatically.";
Error::ThawInstrumentTimeMismatch="The sample(s), `1`, have the Instrument option set to `2` but have the Time option set to `3` and the MaxTime option set to `4`. When using a heat block to thaw the sample, the Time/MaxTime options must be set when thawing the cells manually. When thawing the cells robotically, only the Time option can be set. When using a specialized cell thawing instrument, the Time/MaxTime options cannot be set since the instrument dynamically monitors the phase change of the sample as it is heated. Please change the value of these options to specify a valid thawing experiment.";
Error::ThawInstrumentContainerMismatch="The sample(s), `1`, in the following container model(s), `2`, cannot be used with the Instrument(s), `3`. The specialized cell thawing instrument is only compatible with a 2mL cryovial (Model[Container, Vessel, \"id:vXl9j5qEnnOB\"]). Please allow the instrument option automatically resolve to a heat block.";

resolveThawCellsMethod[mySamples:{ObjectP[{Object[Sample], Model[Sample]}]...}, myOptions:OptionsPattern[]]:=Module[
  {safeOptions, cacheBall, outputSpecification, output, gatherTests, objectSamplePackets, objectSampleContainerPackets,
    objectSampleContainerModelPackets, modelSamplePackets, modelSampleProductPacketList, samplePackets, allModelContainerPackets,
    resolvedSampleContainers, sampleContainerModelPackets, manualRequirementStrings, roboticRequirementStrings, result, tests},

  (* Get our safe options. *)
  safeOptions=ToList[myOptions];
  cacheBall=Lookup[safeOptions, Cache];

  (* Determine the requested return value from the function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Download the information that we need from our samples. *)

  {
    objectSamplePackets,
    objectSampleContainerPackets,
    objectSampleContainerModelPackets,

    modelSamplePackets,
    modelSampleProductPacketList
  }=Quiet[
    Download[
      {
        Cases[mySamples, ObjectP[Object[Sample]]],
        Cases[mySamples, ObjectP[Object[Sample]]],
        Cases[mySamples, ObjectP[Object[Sample]]],

        Cases[mySamples, ObjectP[Model[Sample]]],
        Cases[mySamples, ObjectP[Model[Sample]]]
      },
      {
        {Packet[Container]},
        {Packet[Container[Model]]},
        {Packet[Container[Model][Footprint]]},

        {Packet[Products, KitProducts, MixBatchedProducts]},
        {
          Packet[Products[{DefaultContainerModel}]],
          Packet[Products[DefaultContainerModel][{Footprint}]],
          Packet[KitProducts[{DefaultContainerModel}]],
          Packet[KitProducts[DefaultContainerModel][{Footprint}]],
          Packet[MixedBatchProducts[{DefaultContainerModel}]],
          Packet[MixedBatchProducts[DefaultContainerModel][{Footprint}]]
        }
      },
      Cache->cacheBall,
      Simulation->Lookup[safeOptions, Simulation]
    ],
    {Download::FieldDoesntExist, Download::NotLinkField}
  ];

  {
    objectSamplePackets,
    objectSampleContainerPackets,
    objectSampleContainerModelPackets,

    modelSamplePackets,

    modelSampleProductPacketList
  }=Flatten/@{
    objectSamplePackets,
    objectSampleContainerPackets,
    objectSampleContainerModelPackets,

    modelSamplePackets,

    modelSampleProductPacketList
  };

  cacheBall=FlattenCachePackets[{
    objectSamplePackets,
    objectSampleContainerPackets,
    objectSampleContainerModelPackets,

    modelSamplePackets,

    modelSampleProductPacketList
  }];

  (* Thread together our Object[Sample] and Model[Sample] packets into the order of our input sample list. *)
  samplePackets=(fetchPacketFromCache[#, cacheBall]&)/@mySamples;

  resolvedSampleContainers=MapThread[
    Function[{samplePacket},
      (* If we are dealing with an Object[Sample], then the container will be an Object[Container]. *)
      If[MatchQ[samplePacket, PacketP[Object[Sample]]],
        Lookup[samplePacket, Container],
        (* Otherwise, we must have a Model[Sample]. *)
        Module[{productObject, productPacket},
          (* This is downloaded in the order of Products, KitProducts, MixedBatchProducts *)
          productObject=FirstCase[samplePacket, ObjectP[Object[Product]], Null, Infinity];
          productPacket=fetchPacketFromCache[productObject, modelSampleProductPacketList];

          If[MatchQ[productPacket, PacketP[Object[Product]]],
            Download[Lookup[productPacket, DefaultContainerModel], Object],
            Null
          ]
        ]
      ]
    ],
    {samplePackets}
  ];

  sampleContainerModelPackets=Map[
    Function[{sampleContainer},
      (* Get the packet of our sample container's model. *)
      Which[
        MatchQ[sampleContainer, ObjectP[Object[Container]]],
        fetchModelPacketFromCache[sampleContainer, cacheBall],
        MatchQ[sampleContainer, ObjectP[Model[Container]]],
        fetchPacketFromCache[sampleContainer, cacheBall],
        True,
        Null
      ]
    ],
    resolvedSampleContainers
  ];

  (* Create a list of reasons why we need Preparation->Manual. *)
  manualRequirementStrings={
    If[MemberQ[Lookup[sampleContainerModelPackets, Footprint, {}], Except[CEVial]],
      "the sample container footprints "<>ToString[Cases[Transpose[{(ObjectToString[#, Cache->sampleContainerModelPackets]&)/@Lookup[sampleContainerModelPackets, Object, {}], Lookup[sampleContainerModelPackets, Footprint, {}]}], {_, Except[CEVial]}][[All,1]]]<>" are not able to be thawed on the liquid handler",
      Nothing
    ],
    If[MemberQ[Lookup[safeOptions, Instrument], Except[Automatic|ObjectP[{Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"], Model[Instrument, Shaker, "id:pZx9jox97qNp"], Model[Instrument, Shaker, "id:KBL5Dvw5Wz6x"], Model[Instrument, Shaker, "id:eGakldJkWVnz"]}]]], (* Hamilton Heater Cooler *)
      "the following manual-only instruments were specified "<>ObjectToString[Cases[Lookup[safeOptions, Instrument], Except[Automatic|ObjectP[Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"]]]], Cache->cacheBall],
      Nothing
    ],
    If[MemberQ[Lookup[samplePackets, LiquidHandlerIncompatible], True],
      "the following samples are liquid handler incompatible "<>ObjectToString[Lookup[Cases[samplePackets, KeyValuePattern[LiquidHandlerIncompatible->True]], Object], Cache->cacheBall],
      Nothing
    ],
    Module[{manualOnlyOptions},
      manualOnlyOptions=Select[
        {MaxTime},
        (!MatchQ[Lookup[ToList[myOptions], #, Null], ListableP[Null|Automatic]]&)
      ];

      If[Length[manualOnlyOptions]>0,
        "the following Manual-only options were specified "<>ToString[manualOnlyOptions],
        Nothing
      ]
    ],
    If[MatchQ[Lookup[safeOptions, Preparation], Manual],
      "the Preparation option is set to Manual by the user",
      Nothing
    ]
  };

  (* Create a list of reasons why we need Preparation->Robotic. *)
  roboticRequirementStrings={
    If[MatchQ[Lookup[safeOptions, Preparation], Robotic],
      "the Preparation option is set to Robotic by the user",
      Nothing
    ]
  };

  (* Throw an error if the user has already specified the Preparation option and it's in conflict with our requirements. *)
  If[Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0 && !gatherTests,
    (* NOTE: Blocking $MessagePrePrint stops our error message from being truncated with ... if it gets too long. *)
    Block[{$MessagePrePrint},
      Message[
        Error::ConflictingUnitOperationMethodRequirements,
        listToString[manualRequirementStrings],
        listToString[roboticRequirementStrings]
      ]
    ]
  ];

  (* Return our result and tests. *)
  result=Which[
    !MatchQ[Lookup[safeOptions, Preparation], Automatic],
      Lookup[safeOptions, Preparation],
    Length[manualRequirementStrings]>0,
      Manual,
    Length[roboticRequirementStrings]>0,
      Robotic,
    True,
      {Manual, Robotic}
  ];

  tests=If[MatchQ[gatherTests, False],
    {},
    {
      Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the Transfer primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
    }
  ];

  outputSpecification/.{Result->result, Tests->tests}
];

resolveThawCellsWorkCell[
  mySamples:{ObjectP[{Object[Sample], Model[Sample]}]...},
  myOptions:OptionsPattern[]
]:=Module[
  {workCell,samplePackets},

  (* Download the CellType of our samples. *)
  samplePackets=Download[
    mySamples,
    Packet[CellType],
    Simulation->Lookup[myOptions, Simulation, Null]
  ];

  (* Lookup our passed down WorkCell option. *)
  workCell=Lookup[myOptions,WorkCell,Automatic];

  Which[
    (* Did the user give us the work cell option? *)
    MatchQ[workCell,Except[Automatic]],
      {workCell},
    (* Do we have any microbial samples as input? *)
    MemberQ[Lookup[samplePackets, CellType, {}], MicrobialCellTypeP],
      {microbioSTAR},
    True,
      {bioSTAR, microbioSTAR}
  ]
];

resolveThawCellsOptions[mySamples:{ObjectP[{Object[Sample], Model[Sample]}]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveThawCellsOptions]]:=Module[
  {
    (* Boilerplate Variables *)
    outputSpecification,output,gatherTests,messages,cache,simulation,listedOptions,

    (* Download Variables *)
    objectSampleFields,objectSamplePacketFields,objectContainerFields,modelContainerFields,modelSamplePacketFields,
    objectSamplePackets, objectSampleContainerPackets,objectSampleContainerModelPackets,modelSampleFields,productFields,
    objectContainerPacketFields,modelContainerPacketFields,methodPacketFields,modelSamplePackets,modelSampleProductPacketList,
    cacheBall,samplePackets,methodFields,compositionPackets,compositionMethodPackets,specifiedMethodPackets,

    mapThreadFriendlyOptions, allowedPreparation, preparationTest, resolvedPreparation, preparationResult, allowedWorkCells,
    resolvedWorkCell,

    resolvedSampleContainers, resolvedAmounts, resolvedMethods, resolvedMethodPackets, resolvedInstruments, resolvedTemperatures, resolvedTimes, resolvedMaxTimes,
    sampleContainerModelPackets, resolvedSampleLabels, resolvedSampleContainerLabels,

    (* Option Precision Checks *)
    optionsAndPrecisions,roundedThawingOptions,precisionTests, instrumentTemperatureMismatchTest,
    instrumentTemperatureMismatchResult,instrumentTimeMismatchResult,instrumentTimeMismatchTest,
    instrumentContainerMismatchResult,instrumentContainerMismatchTest,

    invalidInputs,invalidOptions, resolvedOptions},

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
  
  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];
  
  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = !gatherTests;
  
  (* Fetch our cache from the parent function. *)
  cache = Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation=Lookup[ToList[myResolutionOptions],Simulation];

  (* Get our options. *)
  listedOptions=ToList[myOptions];

  (* Download the information that we need from our samples. *)
  objectSampleFields= DeleteDuplicates[Flatten[{ThawCellsMethod,LiquidHandlerIncompatible,SamplePreparationCacheFields[Object[Sample]]}]];
  objectSamplePacketFields=Packet@@objectSampleFields;
  modelSampleFields={CellType,CultureAdhesion,ThawCellsMethod,LiquidHandlerIncompatible,Products,KitProducts,MixedBatchProducts};
  modelSamplePacketFields=Packet@@modelSampleFields;
  objectContainerFields=DeleteDuplicates[Flatten[{Hermetic,SamplePreparationCacheFields[Object[Container]]}]];
  objectContainerPacketFields=Packet@@objectContainerFields;
  modelContainerFields=DeleteDuplicates[Flatten[{HorizontalPitch,VerticalPitch,VolumeCalibrations,Columns,Aperture,WellDepth,Sterile,RNaseFree,Squeezable,Material,TareWeight,Object,Positions,Hermetic,MaxVolume,IncompatibleMaterials,SamplePreparationCacheFields[Model[Container]]}]];
  modelContainerPacketFields=Packet@@modelContainerFields;
  productFields={Name, ProductModel, KitComponents, MixedBatchComponents, DefaultContainerModel, Deprecated, Amount};
  methodFields={Instrument, Temperature};
  methodPacketFields=Packet@@methodFields;

  {
    objectSamplePackets,
    objectSampleContainerPackets,
    objectSampleContainerModelPackets,

    modelSamplePackets,
    modelSampleProductPacketList,

    compositionPackets,
    compositionMethodPackets,
    specifiedMethodPackets
  }=Quiet[
    Download[
      {
        Cases[mySamples, ObjectP[Object[Sample]]],
        Cases[mySamples, ObjectP[Object[Sample]]],
        Cases[mySamples, ObjectP[Object[Sample]]],

        Cases[mySamples, ObjectP[Model[Sample]]],
        Cases[mySamples, ObjectP[Model[Sample]]],

        Cases[mySamples, ObjectP[{Object[Sample], Model[Sample]}]],
        Cases[mySamples, ObjectP[{Object[Sample], Model[Sample]}]],
        Cases[Lookup[myOptions, Method], ObjectP[Object[Method, ThawCells]]]
      },
      {
        List@objectSamplePacketFields,
        List@Packet[Container[objectContainerFields]],
        List@Packet[Container[Model][modelContainerFields]],

        List@modelSamplePacketFields,
        {
          Packet[Products[productFields]],
          Packet[Products[DefaultContainerModel][modelContainerFields]],
          Packet[KitProducts[productFields]],
          Packet[KitProducts[DefaultContainerModel][modelContainerFields]],
          Packet[MixedBatchProducts[productFields]],
          Packet[MixedBatchProducts[DefaultContainerModel][modelContainerFields]]
        },
        {
          Packet[Composition[[All,2]][ThawCellsMethod]]
        },
        {
          Packet[Composition[[All,2]][ThawCellsMethod][methodFields]]
        },
        {
          methodPacketFields
        }
      },
      Cache->cache,
      Simulation->simulation
    ],
    {Download::FieldDoesntExist, Download::NotLinkField}
  ];

  {
    objectSamplePackets,
    objectSampleContainerPackets,
    objectSampleContainerModelPackets,

    modelSamplePackets,

    modelSampleProductPacketList
  }=Flatten/@{
    objectSamplePackets,
    objectSampleContainerPackets,
    objectSampleContainerModelPackets,

    modelSamplePackets,

    modelSampleProductPacketList
  };

  cacheBall=FlattenCachePackets[{
    objectSamplePackets,
    objectSampleContainerPackets,
    objectSampleContainerModelPackets,

    modelSamplePackets,

    modelSampleProductPacketList
  }];

  (* Thread together our Object[Sample] and Model[Sample] packets into the order of our input sample list. *)
  samplePackets=(fetchPacketFromCache[#, cacheBall]&)/@mySamples;

  (* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

  (*-- OPTION PRECISION CHECKS --*)
  (* NOTE: We round ALL of our options here so that we do not get separate round option warnings in our sub resolvers. *)
  optionsAndPrecisions={
    {Temperature, 1 Celsius},
    {Time, 1 Second},
    {MaxTime, 1 Second}
  };

  {roundedThawingOptions,precisionTests}=If[gatherTests,
    RoundOptionPrecision[Association@myOptions,optionsAndPrecisions[[All,1]],optionsAndPrecisions[[All,2]],AvoidZero->True,Output->{Result,Tests}],
    {RoundOptionPrecision[Association@myOptions,optionsAndPrecisions[[All,1]],optionsAndPrecisions[[All,2]],AvoidZero->True],Null}
  ];

  (*-- CONFLICTING OPTIONS CHECKS --*)

  (*-- RESOLVE EXPERIMENT OPTIONS --*)

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentThawCells,Normal@roundedThawingOptions];

  (* 1) Resolve SampleContainer. *)
  {resolvedSampleContainers, resolvedAmounts}=Transpose@MapThread[
    Function[{samplePacket},
      (* If we are dealing with an Object[Sample], then the container will be an Object[Container]. *)
      If[MatchQ[samplePacket, PacketP[Object[Sample]]],
        If[MatchQ[Lookup[samplePacket, Volume], VolumeP],
          {Lookup[samplePacket, Container], Lookup[samplePacket, Volume]},
          {Lookup[samplePacket, Container], Lookup[samplePacket, Mass]}
        ],
        (* Otherwise, we must have a Model[Sample]. *)
        Module[{productObject, productPacket},
          (* This is downloaded in the order of Products, KitProducts, MixedBatchProducts *)
          productObject=FirstCase[samplePacket, ObjectP[Object[Product]], Null, Infinity];
          productPacket=fetchPacketFromCache[productObject, modelSampleProductPacketList];

          If[MatchQ[productPacket, PacketP[Object[Product]]],
            {Download[Lookup[productPacket, DefaultContainerModel], Object], Lookup[productPacket, Amount]},
            {Null, Null}
          ]
        ]
      ]
    ],
    {samplePackets}
  ];

  sampleContainerModelPackets=Map[
    Function[{sampleContainer},
      (* Get the packet of our sample container's model. *)
      Which[
        MatchQ[sampleContainer, ObjectP[Object[Container]]],
          fetchModelPacketFromCache[sampleContainer, cacheBall],
        MatchQ[sampleContainer, ObjectP[Model[Container]]],
          fetchPacketFromCache[sampleContainer, cacheBall],
        True,
          Null
      ]
    ],
    resolvedSampleContainers
  ];

  (* Resolve our preparation option. *)
  preparationResult=Check[
    {allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
      {
        resolveThawCellsMethod[mySamples, ReplaceRule[listedOptions, {Cache->cacheBall, Output->Result}]],
        {}
      },
      resolveThawCellsMethod[mySamples, ReplaceRule[listedOptions, {Cache->cacheBall, Output->{Result, Tests}}]]
    ],
    $Failed
  ];

  (* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
  (* options so that OptimizeUnitOperations can perform primitive grouping. *)
  resolvedPreparation=If[MatchQ[allowedPreparation, _List],
    First[allowedPreparation],
    allowedPreparation
  ];

  (* Resolve the work cell that we're going to operator on. *)
  allowedWorkCells=resolveThawCellsWorkCell[mySamples, ReplaceRule[listedOptions, {Cache->cacheBall, Output->Result}]];

  resolvedWorkCell=Which[
    MatchQ[Lookup[myOptions, WorkCell], Except[Automatic]],
      Lookup[myOptions, WorkCell],
    Length[allowedWorkCells]>0,
      First[allowedWorkCells],
    MatchQ[resolvedPreparation, Manual],
      Null,
    True,
      bioSTAR
  ];

  (* 2) Resolve the Method option. *)
  resolvedMethods=MapThread[
    Function[{samplePacket, options},
      Module[{},
        (* If the user gave us a method, use that. *)
        Which[
          MatchQ[Lookup[options, Method], ObjectP[Object[Method, ThawCells]]],
            Lookup[options, Method],
          MatchQ[Lookup[samplePacket, ThawCellsMethod], ObjectP[]],
            Lookup[samplePacket, ThawCellsMethod],
          True,
            Module[{sampleCompositionPackets},
              sampleCompositionPackets=fetchPacketFromCache[#, cacheBall]&/@Cases[Lookup[samplePackets, Composition][[All,2]], ObjectP[]];

              If[MemberQ[compositionPackets, ObjectP[Object[Method, ThawCells]], Infinity],
                FirstCase[compositionPackets, ObjectP[Object[Method, ThawCells]], Infinity],
                Null
              ]
            ]
        ]
      ]
    ],
    {samplePackets, mapThreadFriendlyOptions}
  ];

  resolvedMethodPackets=(fetchPacketFromCache[#, cacheBall]&)/@resolvedMethods;

  (* 2) Resolve Instruments, Temperature, Time, and MaxTime. *)
  {resolvedInstruments, resolvedTemperatures, resolvedTimes, resolvedMaxTimes}=Transpose@MapThread[
    Function[{sampleContainerModelPacket, methodPacket, options},
      Module[{instrument, temperature, time, maxTime},
        (* Use the Cell Thaw instrument by default if we're in a Cryogenic Vial. *)
        instrument=Which[
          !MatchQ[Lookup[options, Instrument], Automatic],
            Lookup[options, Instrument],
          MatchQ[resolvedPreparation, Robotic],
            Model[Instrument, HeatBlock, "id:R8e1Pjp1W39a"], (* Hamilton Heater Cooler *)
          MatchQ[methodPacket, PacketP[]],
            Lookup[methodPacket, Instrument],
          MatchQ[Lookup[sampleContainerModelPacket, Object, Null], ObjectP[Model[Container, Vessel, "id:vXl9j5qEnnOB"]]], (* "2mL Cryogenic Vial" *)
            Model[Instrument, CellThaw, "id:E8zoYveRllXB"], (* "ThawSTAR" *)
          True,
            Model[Instrument, HeatBlock, "id:eGakldJWknme"] (* "Cole-Parmer StableTemp Digital Utility Water Baths, 10 liters" *)
        ];

        (* Use 37 Celsius if we're using the heat block. *)
        temperature=Which[
          !MatchQ[Lookup[options, Temperature], Automatic],
            Lookup[options, Temperature],
          MatchQ[instrument, ObjectP[Model[Instrument, CellThaw]]],
            Null,
          MatchQ[methodPacket, PacketP[]] && MatchQ[Lookup[methodPacket, Temperature], TemperatureP],
            Lookup[methodPacket, Temperature],
          True,
            37 Celsius
        ];

        (* Resolve Time to 1 minute if we're using a heat block. *)
        time=Which[
          !MatchQ[Lookup[options, Time], Automatic],
            Lookup[options, Time],
          (* NOTE: It takes a little bit of extra time to heat up the thermally conductive rack. We need to test this in the lab to see if 4 min is adequate. *)
          MatchQ[resolvedPreparation, Robotic],
            4 Minute,
          MatchQ[instrument, ObjectP[{Model[Instrument, HeatBlock], Object[Instrument, HeatBlock]}]],
            1 Minute,
          True,
            Null
        ];

        (* Resolve MaxTime to 2 minute if we're using a heat block. *)
        maxTime=Which[
          !MatchQ[Lookup[options, MaxTime], Automatic],
            Lookup[options, MaxTime],
          MatchQ[resolvedPreparation, Robotic],
            Null,
          MatchQ[instrument, ObjectP[{Model[Instrument, HeatBlock], Object[Instrument, HeatBlock]}]],
            2 Minute,
          True,
            Null
        ];

        {instrument, temperature, time, maxTime}
      ]
    ],
    {sampleContainerModelPackets, resolvedMethodPackets, mapThreadFriendlyOptions}
  ];

  resolvedSampleLabels = MapThread[
    Which[
      (* Use user specified values first*)
      MatchQ[#1, Except[Automatic]],
        #1,

      (* Then check if they are labeled in simulation*)
      MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[#2, Object]], _String],
        LookupObjectLabel[simulation, Download[#2, Object]],

      (* Then fetch the label from preresolved value *)
      True,
        CreateUniqueLabel["thawed cell sample"]
    ]&,
    {Lookup[mapThreadFriendlyOptions, SampleLabel], Lookup[samplePackets, Object, {}]}
  ];

  resolvedSampleContainerLabels = MapThread[
    Which[
      (* Use user specified values first*)
      MatchQ[#1, Except[Automatic]],
        #1,

      (* Then check if they are labeled in simulation*)
      MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[#2, Object]], _String],
        LookupObjectLabel[simulation, Download[#2, Object]],

      (* Then fetch the label from preresolved value *)
      True,
        CreateUniqueLabel["thawed cell container"]
    ]&,
    {Lookup[mapThreadFriendlyOptions, SampleContainerLabel], Download[Lookup[samplePackets, Container, {}], Object]}
  ];

  (*-- UNRESOLVABLE OPTION CHECKS --*)

  (* 1) Error if given a cell toaster and a temperature. *)
  instrumentTemperatureMismatchResult=MapThread[
    Function[{sample, instrument, temperature},
      If[Or[
        MatchQ[instrument, ObjectP[{Model[Instrument, HeatBlock], Object[Instrument, HeatBlock]}]] && !MatchQ[temperature, TemperatureP],
        MatchQ[instrument, ObjectP[{Model[Instrument, CellThaw], Object[Instrument, CellThaw]}]] && MatchQ[temperature, TemperatureP]
      ],
        {sample, temperature, instrument},
        Nothing
      ]
    ],
    {
      mySamples,
      resolvedInstruments,
      resolvedTemperatures
    }
  ];

  instrumentTemperatureMismatchTest=If[Length[instrumentTemperatureMismatchResult]==0,
    Test["The Temperature option is not specified if the given Instrument to thaw the samples is a not a heat block:", True, True],
    Test["The Temperature option is not specified if the given Instrument to thaw the samples is a not a heat block:", False, True]
  ];

  If[Length[instrumentTemperatureMismatchResult]>0 && messages,
    Message[
      Error::ThawInstrumentTemperatureMismatch,
      ObjectToString[instrumentTemperatureMismatchResult[[All,1]], Cache->cacheBall],
      ObjectToString[instrumentTemperatureMismatchResult[[All,2]], Cache->cacheBall],
      ObjectToString[instrumentTemperatureMismatchResult[[All,3]], Cache->cacheBall]
    ];
  ];

  (* 2) Error if given a cell toaster and a time/maxtime. *)
  instrumentTimeMismatchResult=MapThread[
    Function[{sample, instrument, time, maxTime},
      If[Or[
          And[
            MatchQ[resolvedPreparation, Robotic],
            (!MatchQ[time, TimeP] || !MatchQ[maxTime, Null])
          ],
          And[
            MatchQ[resolvedPreparation, Manual],
            Or[
              MatchQ[instrument, ObjectP[{Model[Instrument, HeatBlock], Object[Instrument, HeatBlock]}]] && (!MatchQ[time, TimeP] || !MatchQ[maxTime, TimeP]),
              MatchQ[instrument, ObjectP[{Model[Instrument, CellThaw], Object[Instrument, CellThaw]}]] && (MatchQ[time, TimeP] || MatchQ[maxTime, TimeP])
            ]
          ]
        ],
        {sample, instrument, time, maxTime},
        Nothing
      ]
    ],
    {
      mySamples,
      resolvedInstruments,
      resolvedTimes,
      resolvedMaxTimes
    }
  ];

  instrumentTimeMismatchTest=If[Length[instrumentTimeMismatchResult]==0,
    Test["The Time/MaxTime options can only be specified if the instrument used to thaw the sample is a heat block:", True, True],
    Test["The Time/MaxTime options can only be specified if the instrument used to thaw the sample is a heat block:", False, True]
  ];

  If[Length[instrumentTimeMismatchResult]>0 && messages,
    Message[
      Error::ThawInstrumentTimeMismatch,
      ObjectToString[instrumentTimeMismatchResult[[All,1]], Cache->cacheBall],
      ObjectToString[instrumentTimeMismatchResult[[All,2]], Cache->cacheBall],
      ObjectToString[instrumentTimeMismatchResult[[All,3]], Cache->cacheBall],
      ObjectToString[instrumentTimeMismatchResult[[All,4]], Cache->cacheBall]
    ];
  ];

  (* 3) We can only use the cell toaster with the 2mL cryovial. *)
  instrumentContainerMismatchResult=MapThread[
    Function[{sample, sampleContainerModelPacket, instrument},
      If[MatchQ[instrument, ObjectP[{Model[Instrument, CellThaw], Object[Instrument, CellThaw]}]] && !MatchQ[Lookup[sampleContainerModelPacket, Object], ObjectP[Model[Container, Vessel, "id:vXl9j5qEnnOB"]]],
        {sample, Lookup[sampleContainerModelPacket, Object], instrument},
        Nothing
      ]
    ],
    {
      mySamples,
      sampleContainerModelPackets,
      resolvedInstruments
    }
  ];

  instrumentContainerMismatchTest=If[Length[instrumentContainerMismatchResult]==0,
    Test["A specialized cell thawing instrument (Model[Instrument, CellThaw, \"ThawSTAR\"]) can only be used with a 2mL cryogenic vial due to instrument compatibility constraints:", True, True],
    Test["A specialized cell thawing instrument (Model[Instrument, CellThaw, \"ThawSTAR\"]) can only be used with a 2mL cryogenic vial due to instrument compatibility constraints:", False, True]
  ];

  If[Length[instrumentContainerMismatchResult]>0 && messages,
    Message[
      Error::ThawInstrumentContainerMismatch,
      ObjectToString[instrumentContainerMismatchResult[[All,1]], Cache->cacheBall],
      ObjectToString[instrumentContainerMismatchResult[[All,2]], Cache->cacheBall],
      ObjectToString[instrumentContainerMismatchResult[[All,3]], Cache->cacheBall]
    ];
  ];

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs=DeleteDuplicates[Flatten[{}]];
  invalidOptions=DeleteDuplicates[Flatten[{
    If[Length[instrumentTemperatureMismatchResult]>0,
      {Instrument, Temperature},
      Nothing
    ],
    If[Length[instrumentTimeMismatchResult]>0,
      {Instrument, Time, MaxTime},
      Nothing
    ],
    If[Length[instrumentContainerMismatchResult]>0,
      {Instrument},
      Nothing
    ]
  }]];
  
  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs]>0&&!gatherTests,
    Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cacheBall]]
  ];
  
  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions]>0&&!gatherTests,
    Message[Error::InvalidOption,invalidOptions]
  ];

  (* Combine our resolved options. *)
  resolvedOptions=ReplaceRule[
    myOptions,
    {
      Container->resolvedSampleContainers,
      Amount->resolvedAmounts,
      SampleLabel->resolvedSampleLabels,
      SampleContainerLabel->resolvedSampleContainerLabels,
      Instrument->resolvedInstruments,
      Temperature->resolvedTemperatures,
      Time->resolvedTimes,
      MaxTime->resolvedMaxTimes,
      Method->resolvedMethods,
      Preparation->resolvedPreparation,
      WorkCell->resolvedWorkCell
    }
  ];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> Flatten[{
      precisionTests,
      instrumentTemperatureMismatchTest,
      instrumentTimeMismatchTest,
      instrumentContainerMismatchTest
    }]
  }
];

(* ::Subsection::Closed:: *)
(*Resource Packets*)


DefineOptions[thawCellsResourcePackets,
  Options:>{
    CacheOption,
    SimulationOption,
    HelperOutputOption
  }
];


thawCellsResourcePackets[
  mySamples:{ObjectP[{Object[Sample], Model[Sample]}]..},
  myUnresolvedOptions:{___Rule},
  myResolvedOptions:{___Rule},
  myCollapsedResolvedOptions:{___Rule},
  myOptions:OptionsPattern[]
]:=Module[
  {
    outputSpecification,output,gatherTests,messages,cache,simulation,allResourceBlobs,fulfillable,frqTests,
    protocolPacket,allUnitOperationPackets,resolvedPreparation,sampleResources,
    uniqueInstruments,instrumentResourceReplaceRules,instrumentResources
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests=MemberQ[output,Tests];

  (* whenever we are not collecting tests, print messages instead *)
  messages = !gatherTests;

  (* Fetch our cache from the parent function. *)
  cache=Lookup[ToList[myOptions],Cache];
  simulation=Lookup[ToList[myOptions],Simulation];
  resolvedPreparation=Lookup[myResolvedOptions, Preparation];

  (* Create resources for our samples. *)
  (* NOTE: It's important that our samples are in the required container in order to be compatible with our cell thawing instrument *)
  (* or with the thermally conductive racks on the hamilton. *)
  sampleResources=MapThread[
    Function[{sample, sampleContainer, amount},
      Resource[
        Sample->sample,
        If[MatchQ[sampleContainer, ObjectP[Model[Container]]],
          Container->sampleContainer,
          Nothing
        ],
        If[MatchQ[amount, UnitsP[]],
          Amount->amount,
          Nothing
        ],

        (* NOTE: This key makes it such that we don't try to thaw our sample. *)
        ThawRequired->False,

        Name->CreateUUID[]
      ]
    ],
    {mySamples, Lookup[myResolvedOptions, Container], Lookup[myResolvedOptions, Amount]}
  ];

  (* Create resources for our instruments. *)
  uniqueInstruments = DeleteDuplicates[Lookup[myResolvedOptions, Instrument]];
  instrumentResourceReplaceRules = (# -> Which[
    (* If we've got a generic Cole-Parmer heat bath, allow for transform-specific heat bath as well *)
    MatchQ[#, ObjectP[Model[Instrument, HeatBlock, "id:eGakldJWknme"]]], (*"Cole-Parmer StableTemp Digital Utility Water Baths, 10 liters"*)
      Resource[
        Instrument -> {Model[Instrument, HeatBlock, "id:eGakldJWknme"], Model[Instrument, HeatBlock, "id:Z1lqpMrx4XW0"]}, (*"Cole-Parmer StableTemp Digital Utility Water Baths, 10 liters for Transform"*)
        Time -> (5 Minute * Length[Cases[uniqueInstruments, #]]),
        Name->CreateUUID[]
      ],
    MatchQ[#, ObjectP[]],
      Resource[
        Instrument -> #,
        Time -> (5 Minute * Length[Cases[uniqueInstruments, #]]),
        Name->CreateUUID[]
      ],
    True,
      Null
  ]&)/@uniqueInstruments;
  instrumentResources = Lookup[myResolvedOptions, Instrument] /. instrumentResourceReplaceRules;

  {protocolPacket, allUnitOperationPackets} = If[MatchQ[resolvedPreparation,Manual],
    Module[{protocolPacket},
      {
        <|
          Type->Object[Protocol,ThawCells],
          Object->CreateID[Object[Protocol,ThawCells]],

          Replace[SamplesIn] -> sampleResources,

          Replace[Instruments] -> instrumentResources,
          Replace[Temperatures] -> Lookup[myResolvedOptions, Temperature],
          Replace[Times] -> Lookup[myResolvedOptions, Time],
          Replace[MaxTimes] -> Lookup[myResolvedOptions, MaxTime],
          Replace[AdditionalTimes] -> MapThread[
            If[MatchQ[#1, TimeP] && MatchQ[#2, TimeP], #2-#1, Null]&,
            {Lookup[myResolvedOptions, Time], Lookup[myResolvedOptions, MaxTime]}
          ],

          HeatBlock -> FirstCase[
            instrumentResources,
            Verbatim[Resource][KeyValuePattern[{Instrument -> ObjectP[{Model[Instrument, HeatBlock], Object[Instrument, HeatBlock]}]}]],
            Null
          ],

          InitialTemperature -> FirstCase[
            Lookup[myResolvedOptions, Temperature],
            TemperatureP,
            Null
          ],

          CellThaw -> FirstCase[
            instrumentResources,
            Verbatim[Resource][KeyValuePattern[{Instrument -> ObjectP[{Model[Instrument, CellThaw], Object[Instrument, CellThaw]}]}]],
            Null
          ],

          Replace[Checkpoints]->{
            {"Picking Resources", 30 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator->Model[User,Emerald,Operator,"Level 3"],Time -> 30 Minute]]},
            {"Thawing Cells",5 Minute * Length[sampleResources],"The frozen cell samples are thawed.",Resource[Operator->Model[User,Emerald,Operator,"Level 3"],Time->(5 Minute * Length[sampleResources])]},
            {"Returning Materials",15 Minute,"Samples are returned to storage.",Resource[Operator->Model[User,Emerald,Operator,"Level 3"],Time->15 Minute]}
          },

          ResolvedOptions->myCollapsedResolvedOptions,
          UnresolvedOptions->myUnresolvedOptions
        |>,
        Null
      }
    ],
    Module[{unitOperationPacket},
      (* Create our unit operation packet. *)
      unitOperationPacket=UploadUnitOperation[
        Module[{nonHiddenOptions},
          nonHiddenOptions=allowedKeysForUnitOperationType[Object[UnitOperation,ThawCells]];

          (* Override any options with resource. *)
          ThawCells@Join[
            Cases[Normal[myResolvedOptions], Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
            {
              Sample->sampleResources,
              Instrument->instrumentResources
            }
          ]
        ],
        UnitOperationType->Output,
        Upload->False
      ];

      {
        Null,
        unitOperationPacket
      }
    ]
  ];
  (* get all the resource symbolic representations *)
  (* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  allResourceBlobs = DeleteDuplicates[Cases[Null, _Resource, Infinity]];

  (* call fulfillableResourceQ on all the resources we created *)
  {fulfillable, frqTests} = Which[
    MatchQ[$ECLApplication, Engine], {True, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache, Simulation->simulation],
    True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache->cache, Simulation->simulation], Null}
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result->If[fulfillable,
      {protocolPacket, allUnitOperationPackets},
      $Failed
    ],
    Tests->frqTests
  }
];

(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
  simulateExperimentThawCells,
  Options:>{CacheOption,SimulationOption}
];

simulateExperimentThawCells[
  myResourcePacket:(PacketP[Object[Protocol, ThawCells], {Object, ResolvedOptions}]|$Failed|Null),
  myUnitOperationPackets:({PacketP[]...}|$Failed),
  mySamples:{ObjectP[{Model[Sample], Object[Sample]}]...},
  myResolvedOptions:{_Rule...},
  myResolutionOptions:OptionsPattern[simulateExperimentThawCells]
]:=Module[
  {cache, simulation, samplePackets, protocolObject, resolvedPreparation, fulfillmentSimulation, simulationWithLabels},

  (* Lookup our cache and simulation. *)
  cache=Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

  (* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
  protocolObject=If[MatchQ[myResourcePacket, $Failed|Null],
    SimulateCreateID[Object[Protocol,ThawCells]],
    Lookup[myResourcePacket, Object]
  ];

  (* Get our resolved preparation. *)
  resolvedPreparation=Lookup[myResolvedOptions, Preparation];

  (* Simulate the fulfillment of all resources by the procedure. *)
  (* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
  (* just make a shell of a protocol object so that we can return something back. *)
  fulfillmentSimulation=Which[
    (* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
    (* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
    MatchQ[myResourcePacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
      Module[{protocolPacket},
        protocolPacket=<|
          Object->protocolObject,
          Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[myUnitOperationPackets, Object],
          ResolvedOptions->{}
        |>;

        SimulateResources[protocolPacket, myUnitOperationPackets, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]]
      ],

    MatchQ[myResourcePacket, $Failed],
      SimulateResources[
        <|
          Object->protocolObject,
          Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
          ResolvedOptions->myResolvedOptions
        |>,
        Cache->cache,
        Simulation->simulation
      ],

    True,
      SimulateResources[
        myResourcePacket,
        Cache->cache,
        Simulation->simulation
      ]
  ];

  (* Download containers from our sample packets. *)
  samplePackets=Flatten@If[MatchQ[myResourcePacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
    Download[
      protocolObject,
      Packet[OutputUnitOperations[SampleLink][{Object, Container}]],
      Simulation->fulfillmentSimulation
    ],
    Download[
      protocolObject,
      Packet[SamplesIn[Object, Container]],
      Simulation->fulfillmentSimulation
    ]
  ];

  (* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
  (* SamplesIn field. *)
  simulationWithLabels=Simulation[
    Labels->Join[
      Rule@@@Cases[
        Transpose[{Lookup[myResolvedOptions, SampleLabel], Lookup[samplePackets, Object]}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
        {_String, ObjectP[]}
      ]
    ],
    LabelFields->If[MatchQ[resolvedPreparation, Manual],
      Join[
        Rule@@@Cases[
          Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
          {_String, _}
        ],
        Rule@@@Cases[
          Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
          {_String, _}
        ]
      ],
      {}
    ]
  ];

  (* Merge our packets with our labels. *)
  {
    protocolObject,
    UpdateSimulation[fulfillmentSimulation, simulationWithLabels]
  }
];