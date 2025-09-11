(* Source Code *)

DefineOptions[resolveLabelContainerPrimitive,
  Options:>{
    IndexMatching[
      (* NOTE: We mark the Container option as Required in our primitive so we are guarenteed to get a value here. *)
      {
        OptionName -> Container,
        Default -> Null,
        Description -> "The container object that will be labeled for future use.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{
            Object[Container],
            Model[Container]
          }]
        ]
      },
      {
        OptionName -> Restricted,
        Default -> Null,
        Description -> "Indicates whether the container should be restricted from automatic use is any of your team's experiments that request the container's models. (Restricted can only be used in experiments when specifically provided as input to the experiment functions by a team member). Setting the option to Null means the sample should be untouched. Setting the option to True or False will set the Restricted field of the sample to that value respectively.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ]
      },
      IndexMatchingInput->"container labels"
    ],

    {
      OptionName->Output,
      Default->Result,
      AllowNull->False,
      Widget->Alternatives[
        Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Simulation]],
        Adder[Widget[Type->Enumeration,Pattern:>Alternatives[CommandBuilderOutputP, Simulation]]]
      ],
      Description->"Indicate what the function should return.",
      Category->"Hidden"
    },
    PreparationOption,
    SimulationOption,
    CacheOption
  }
];

(* ::Subsection:: *)
(* resolveLabelContainerMethod *)

DefineOptions[resolveLabelContainerMethod,
  SharedOptions:>{
    resolveLabelContainerPrimitive,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

resolveLabelContainerMethod[
  myLabels:ListableP[(Automatic|_String)],
  myOptions:OptionsPattern[]
]:=Module[
  {safeOptions, outputSpecification, output, gatherTests, objectContainerPackets, modelContainerPackets,
    manualRequirementStrings, roboticRequirementStrings, allModelContainerPackets, allModelContainerPlatePackets, liquidHandlerIncompatibleContainers, result, tests},

  (* Get our safe options. *)
  safeOptions=SafeOptions[resolveLabelContainerMethod, ToList[myOptions]];

  (* Determine the requested return value from the function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Download information that we need from our inputs and/or options. *)
  {
    objectContainerPackets,
    modelContainerPackets
  }=Quiet[
    Download[
      {
        Cases[Flatten[Lookup[safeOptions, Container]], ObjectP[Object[Container]]],
        Cases[Flatten[Lookup[safeOptions, Container]], ObjectP[Model[Container]]]
      },
      {
        {Packet[Model, Name], Packet[Model[{Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix}]]},
        {Packet[Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix]}
      },
      Cache->Lookup[ToList[myOptions], Cache, {}],
      Simulation->Lookup[ToList[myOptions], Simulation, Null]
    ],
    {Download::NotLinkField, Download::FieldDoesntExist}
  ];

  (* Get all of our Model[Container]s and look at their footprints. *)
  allModelContainerPackets=Cases[
    Flatten[{objectContainerPackets, modelContainerPackets}],
    PacketP[Model[Container]]
  ];


  (* Get all of our Model[Container,Plate]s and look at their LiquidHandlerPrefix. *)
  allModelContainerPlatePackets=Cases[
    allModelContainerPackets,
    PacketP[Model[Container,Plate]]
  ];

  (* Get the containers that are liquid handler incompatible *)
  liquidHandlerIncompatibleContainers=DeleteDuplicates[
    Join[
      Lookup[Cases[allModelContainerPackets,KeyValuePattern[Footprint->Except[LiquidHandlerCompatibleFootprintP]]],Object,{}],
      Lookup[Cases[allModelContainerPlatePackets,KeyValuePattern[LiquidHandlerPrefix->Null]],Object,{}]
    ]
  ];

  (* Create a list of reasons why we need Preparation->Manual. *)
  manualRequirementStrings={
    If[!MatchQ[liquidHandlerIncompatibleContainers,{}],
      "the sample containers "<>ToString[ObjectToString/@liquidHandlerIncompatibleContainers]<>" are not liquid handler compatible",
      Nothing
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
      Test["There are not conflicting Manual and Robotic requirements when resolving the Preparation method for the LabelContainer primitive", False, Length[manualRequirementStrings]>0 && Length[roboticRequirementStrings]>0]
    }
  ];

  outputSpecification/.{Result->result, Tests->tests}
];

resolveLabelContainerWorkCell[myLabels:ListableP[_String], myOptions:OptionsPattern[]]:={STAR, bioSTAR, microbioSTAR};

(* NOTE: If you're looking for a primitive to template off of, do NOT pick this one. LabelContainer is weird because we use the same function *)
(* for both the manual and work cell versions. There are also exceptions in the framework code for it since it doesn't generate a protocol *)
(* object. *)
resolveLabelContainerPrimitive[myLabels:ListableP[_String],myOptions:OptionsPattern[]]:=Module[
  {outputSpecification, output, gatherTests, listedLabels, listedOptions, safeOps, safeOpsTests,
    validLengths, validLengthTests, expandedSafeOps, containerOption, allContainerObjects,
    allContainerModels, cacheBall, resolvedOptionsResult, simulation, unitOperationPacket, resourceTests,
    resolvedOptions,resolvedOptionsTests, updatedSimulation, sanitizedLabels, safeOpsNamed
  },

  (* Determine the requested return value from the function *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links and named objects. *)
  {listedLabels, listedOptions}=removeLinks[ToList[myLabels], ToList[myOptions]];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOpsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[resolveLabelContainerPrimitive,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[resolveLabelContainerPrimitive,listedOptions,AutoCorrect->False],{}}
  ];
  simulation = Lookup[safeOpsNamed, Simulation, Null];
  (* Replace all objects referenced by Name to ID *)
  (* note that listedLabels won't ever have objects so this is a little silly but need to assign the output to something to make it return the safeOps (which I do care about)*)
  {sanitizedLabels, safeOps} = sanitizeInputs[listedLabels, safeOpsNamed, Simulation -> simulation];

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
    ValidInputLengthsQ[resolveLabelContainerPrimitive,{listedLabels},safeOps,Output->{Result,Tests}],
    {ValidInputLengthsQ[resolveLabelContainerPrimitive,{listedLabels},safeOps],Null}
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

  (* Expand index-matching options *)
  expandedSafeOps = Last[ExpandIndexMatchedInputs[resolveLabelContainerPrimitive,{listedLabels},safeOps]];

  (* Download information from the Sample and Container options. *)
  containerOption=Lookup[expandedSafeOps, Container];

  allContainerObjects=DeleteDuplicates[Cases[containerOption, ObjectP[Object[Container]]]];
  allContainerModels=DeleteDuplicates[Cases[containerOption, ObjectP[Model[Container]]]];

  (* Extract the packets that we need from our downloaded cache. *)
  cacheBall=Quiet[Flatten[{Download[
    {
      allContainerObjects,
      allContainerModels
    },
    {
      {
        Packet[Object, Name, Status]
      },
      {
        Packet[Object, Name]
      }
    },
    Cache->Lookup[expandedSafeOps,Cache,{}],
    Simulation->simulation,
    Date->Now
  ]}],Download::FieldDoesntExist];

  (* Build the resolved options *)
  resolvedOptionsResult = Check[
    {resolvedOptions,resolvedOptionsTests} = If[gatherTests,
      resolveLabelContainerPrimitiveOptions[listedLabels,expandedSafeOps,Cache->cacheBall,Simulation->Lookup[expandedSafeOps, Simulation, Null],Output->{Result,Tests}],
      {resolveLabelContainerPrimitiveOptions[listedLabels,expandedSafeOps,Cache->cacheBall,Simulation->Lookup[expandedSafeOps, Simulation, Null]],{}}
    ],
    $Failed,
    {Error::InvalidInput,Error::InvalidOption}
  ];

  (* Build packets with resources *)
  {unitOperationPacket, resourceTests}=If[gatherTests,
    labelContainerPrimitiveResources[listedLabels,resolvedOptions,Cache->cacheBall,Simulation->simulation,Output->{Result,Tests}],
    {labelContainerPrimitiveResources[listedLabels,resolvedOptions,Cache->cacheBall,Simulation->simulation],{}}
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  updatedSimulation = If[MemberQ[output, Simulation],
    simulateLabelContainerPrimitive[unitOperationPacket,listedLabels,resolvedOptions,Cache->cacheBall,Simulation->simulation,ParentProtocol->Lookup[safeOps, ParentProtocol, Null]],
    Null
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> unitOperationPacket,
    Options -> resolvedOptions,
    Simulation -> updatedSimulation,
    Tests -> Flatten[{resolvedOptionsTests, resourceTests}]
  }
];

(* Helper Functions *)
DefineOptions[
  resolveLabelContainerPrimitiveOptions,
  Options:>{ResolverOutputOption,CacheOption,SimulationOption}
];

Error::LabelContainerDiscarded="The given container(s), `1`, are already discarded. Only non-discarded container(s) can be labeled and used in an experiment. Please only supply non-discarded container(s).";

(* NOTE: This function doesn't resolve any options and just does one error check. *)
resolveLabelContainerPrimitiveOptions[myLabels:{_String..}, myOptions:{_Rule..}, myResolutionOptions:OptionsPattern[]]:=Module[
  {outputSpecification, output, gatherTests, cache, simulation, discardedContainers, discardedContainerInvalidOptions,
    discardedContainerTest, invalidOptions, preparationResult, allowedPreparation, preparationTest, resolvedPreparation},

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests=MemberQ[output,Tests];

  (* Fetch our cache from the parent function. *)
  cache=Lookup[ToList[myResolutionOptions],Cache];
  simulation=Lookup[ToList[myResolutionOptions],Simulation];

  (* Resolve our preparation option. *)
  preparationResult=Check[
    {allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
      {
        resolveLabelContainerMethod[myLabels, ReplaceRule[myOptions, {Output->Result}]],
        {}
      },
      resolveLabelContainerMethod[myLabels, ReplaceRule[myOptions, {Output->{Result, Tests}}]]
    ],
    $Failed
  ];

  (* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
  (* options so that OptimizeUnitOperations can perform primitive grouping. *)
  resolvedPreparation=If[MatchQ[allowedPreparation, _List],
    First[allowedPreparation],
    allowedPreparation
  ];

  (* ERROR CHECKING: *)
  (* 1) Containers can't be discarded. *)
  discardedContainers=Map[
    Function[container,
      If[MatchQ[container, ObjectP[Object[Container]]] && MatchQ[Lookup[fetchPacketFromCache[container, cache], Status], Discarded],
        container,
        Nothing
      ]
    ],
    Lookup[myOptions, Container]
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  discardedContainerInvalidOptions=If[Length[discardedContainers]>0&&!gatherTests,
    Message[Error::LabelContainerDiscarded,ObjectToString[discardedContainers,Cache->cache]];
    {Container},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  discardedContainerTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Cases[Complement[Lookup[myOptions, Container],discardedContainers], ObjectP[]];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" are not discarded:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[discardedContainers]>0,
        Test["The sample(s) "<>ObjectToString[discardedContainers,Cache->cache]<>" are not discarded:",True,False],
        Nothing
      ];

      (* Return our created tests. *)
      {
        passingInputsTest,
        nonPassingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];


  (* Throw Error::InvalidOption. *)
  invalidOptions=DeleteDuplicates@Flatten@{
    discardedContainerInvalidOptions,

    If[MatchQ[preparationResult, $Failed],
      {Preparation},
      Nothing
    ]
  };

  If[Length[invalidOptions]>0,
    Message[Error::InvalidOption, invalidOptions];
  ];

  (* Return back our result. *)
  outputSpecification/.{
    Result -> ReplaceRule[
      myOptions,
      {
        Preparation -> resolvedPreparation
      }
    ],
    Tests -> {
      preparationTest,
      discardedContainerTest
    }
  }
];

DefineOptions[
  simulateLabelContainerPrimitive,
  Options:>{CacheOption,SimulationOption}
];

simulateLabelContainerPrimitive[myUnitOperationPacket:PacketP[], myLabels:{_String..},myResolvedOptions:{_Rule...},myResolutionOptions:OptionsPattern[simulateLabelContainerPrimitive]]:=Module[
  {cache, currentSimulation, containerObjects, labelToContainerLookup, finalLabelFieldLookup},

  (* Lookup our cache. *)
  cache=Lookup[ToList[myResolutionOptions], Cache, {}];

  (* NOTE: SimulateResources requires you to have a protocol object, so just make a fake one to simulate our unit operation. *)
  currentSimulation=Module[{protocolPacket},
    protocolPacket=<|
      Object->SimulateCreateID[Object[Protocol, ManualSamplePreparation]],
      Replace[OutputUnitOperations]->Link[Lookup[myUnitOperationPacket, Object], Protocol],
      (* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
      (* simulate resources will NOT simulate them for you. *)
      (* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
      Replace[RequiredObjects]->DeleteDuplicates[
        Cases[myUnitOperationPacket, Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
      ],
      Replace[RequiredInstruments]->DeleteDuplicates[
        Cases[myUnitOperationPacket, Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
      ],
      ResolvedOptions-> {}
    |>;

    (* Note: In SimulateResources (in the call of UploadSample), if we are simulating a covered container by default, *)
    (* we are turning off the cover simulation here with IgnoreCoverSimulation->True since LabelContainer is only picking container, not cover *)
    SimulateResources[
      protocolPacket,
      {myUnitOperationPacket},
      IgnoreCoverSimulation -> True,
      ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null],
      Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]
    ]
  ];

  (* Get the simulated objects of our samples. *)
  containerObjects=Download[
    Download[Lookup[myUnitOperationPacket, Object], ContainerLink, Simulation->currentSimulation],
    Object
  ];

  (* Generate our labels. *)
  labelToContainerLookup=Rule@@@Cases[
    Transpose[{myLabels, containerObjects}],
    {_String, ObjectP[Object[Container]]}
  ];

  (* NOTE: This string indicates to the framework that the sample is coming from the label lookup. *)
  finalLabelFieldLookup=(#->#&)/@Cases[myLabels, _String];

  (* Update our simulation. *)
  currentSimulation=UpdateSimulation[currentSimulation, Simulation[Labels->labelToContainerLookup, LabelFields->finalLabelFieldLookup]];

  (* Return our simulation. *)
  currentSimulation
];

DefineOptions[
  labelContainerPrimitiveResources,
  Options:>{ResolverOutputOption,CacheOption,SimulationOption}
];

labelContainerPrimitiveResources[myLabels:{_String..},myResolvedOptions:{_Rule...},myResolutionOptions:OptionsPattern[labelContainerPrimitiveResources]]:=Module[
  {cache, mapThreadFriendlyOptions, resources, labelContainerUnitOperationPacket, labelSampleUnitOperationPacketWithLabeledObjects},

  (* Lookup our cache. *)
  cache=Lookup[ToList[myResolutionOptions], Cache, {}];

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[resolveLabelContainerPrimitive,myResolvedOptions];

  (* Create all of our resources. *)
  resources=MapThread[
    Function[{label, container},
      Which[
        MatchQ[container, ObjectP[{Model[Container], Object[Container]}]],
          Resource[
            Name->CreateUUID[],
            Sample->container
          ],
        (* NOTE: We make any Null containers into 50mL tubes for downstream resolving purposes. *)
        MatchQ[container, Null],
          Resource[
            Name->CreateUUID[],
            Sample->Model[Container, Vessel, "id:bq9LA0dBGGR6"] (* 50mL Tube *)
          ],
        _,
          Nothing
      ]
    ],
    {
      myLabels,
      Lookup[myResolvedOptions, Container]
    }
  ];

  (* Create the unit operation packet. *)
  labelContainerUnitOperationPacket=Module[{nonHiddenOptions},
    nonHiddenOptions=Lookup[
      Cases[OptionDefinition[resolveLabelContainerPrimitive], KeyValuePattern["Category"->Except["Hidden"]]],
      "OptionSymbol"
    ];

    UploadUnitOperation[
      LabelContainer@@Join[
        {
          Label->myLabels
        },
        ReplaceRule[
          Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
          Container->resources
        ]
      ],
      Preparation->Lookup[myResolvedOptions, Preparation],
      UnitOperationType->Output,
      FastTrack->True,
      Upload->False
    ]
  ];

  (* Add the LabeledObjects field to the Robotic unit operation packet. *)
  (* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
  labelSampleUnitOperationPacketWithLabeledObjects=Append[
    labelContainerUnitOperationPacket,
    Replace[LabeledObjects]->Cases[
      Transpose[{myLabels, resources}],
      {_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Container], Model[Container]}]]]}
    ]
  ];

  (* NOTE: We call FRQ in the framework, so we do not need to call it here. *)
  OptionValue[Output]/.{
    Result->labelSampleUnitOperationPacketWithLabeledObjects,
    Tests->{}
  }
];