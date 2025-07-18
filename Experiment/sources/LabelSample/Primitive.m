(* Options *)
DefineOptions[resolveLabelSamplePrimitive,
  Options:>{
    IndexMatching[
      {
        OptionName -> Sample,
        Default -> Automatic,
        Description -> "The sample that should be labeled by this primitive.",
        ResolutionDescription -> "Automatically set from the Container, if that option is specified.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Alternatives[
          "Sample Model" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Model[Sample]}]
          ],
          "Sample Object" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[{Object[Sample]}]
          ],
          "Container with Well Position"->{
            "Well Position" -> Alternatives[
              "A1 to H12" -> Widget[
                Type -> Enumeration,
                Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
                PatternTooltip -> "Enumeration must be any well from A1 to H12."
              ],
              "Container Position" -> Widget[
                Type -> String,
                Pattern :> LocationPositionP,
                PatternTooltip -> "Any valid container position.",
                Size->Line
              ]
            ],
            "Container" -> Widget[
              Type -> Object,
              Pattern :> ObjectP[{Object[Container]}]
            ]
          }
        ]
      },
      {
        OptionName -> Container,
        Default -> Automatic,
        Description -> "The container object of the sample that is to be labeled.",
        ResolutionDescription -> "Automatically resolves to an Object[Container] if an Object[Sample] is specified. Otherwise, automatically resolves to a Model[Container] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Alternatives[
          "Existing Container" -> Widget[
            Type -> Object,
            Pattern :> ObjectP[Object[Container]]
          ],
          "Single Container Model"-> Widget[
            Type -> Object,
            Pattern :> ObjectP[Model[Container]]
          ]
        ]
      },
      {
        OptionName -> Well,
        Default -> Automatic,
        Description -> "The well of the container that the Object[Sample] is already in.",
        ResolutionDescription -> "Automatically resolves from the Sample if it is an Object[Sample].",
        AllowNull -> False,
        Category -> "General",
        Widget -> Widget[
          Type -> String,
          Pattern :> WellPositionP,
          Size -> Line
        ]
      },
      {
        OptionName -> ContainerLabel,
        Default -> Null,
        Description -> "The label to assign to the container that is used for the sample.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ]
      },
      {
        OptionName -> Amount,
        Default -> Automatic,
        Description -> "The requested amount of the Model[Sample] to put in the specified Container.",
        ResolutionDescription -> "Automatically set based on the usage of the sample label in other primitives.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Alternatives[
          "Mass" -> Widget[
            Type -> Quantity,
            Pattern :> GreaterP[0 * Milligram],
            Units -> {Gram, {Milligram, Gram, Kilogram}}
          ],
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> GreaterP[0 * Milliliter],
            Units -> {Milliliter, {Microliter, Milliliter, Liter}}
          ],
          "Count" -> Widget[
            Type -> Number,
            Pattern :> GreaterEqualP[1, 1]
          ]
        ]
      },

      {
        OptionName -> ExactAmount,
        Default -> Automatic,
        Description -> "Indicates that an Object[Sample] with the exact Amount specified (+/- Tolerance) should be picked in the lab. If set to False, existing samples with an amount greater than or equal to the amount requested can be used. ExactAmount should be set to True if you are depending on the sample having an exact volume/mass/count in the lab. However, if you're just transferring out of this sample and don't care about its exact volume, setting ExactAmount->False will save time in the lab (the exact amount doesn't need to first be aliquotted out).",
        ResolutionDescription -> "Automatically set to True if the sample has FixedAmounts or if the user has manually specified the Amount option.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ]
      },
      {
        OptionName -> Tolerance,
        Default -> Automatic,
        Description -> "The allowed tolerance when preparing the specified Amount of sample. This option can only be set if ExactAmount is set to True.",
        ResolutionDescription -> "Automatically set to 1% of the requested Amount if ExactAmount is set to True.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Alternatives[
          "Mass" -> Widget[
            Type -> Quantity,
            Pattern :> GreaterP[0 * Milligram],
            Units -> {Gram, {Milligram, Gram, Kilogram}}
          ],
          "Volume" -> Widget[
            Type -> Quantity,
            Pattern :> GreaterP[0 * Milliliter],
            Units -> {Milliliter, {Microliter, Milliliter, Liter}}
          ],
          "Count" -> Widget[
            Type -> Number,
            Pattern :> GreaterEqualP[1, 1]
          ],
          "Percent Tolerance" -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Percent, 100 Percent],
            Units -> Percent
          ]
        ]
      },

      (* EHS Override Options *)
      (* NOTE: This must be called SampleModel and not Model in order to not conflict with the Model field in the *)
      (* Object[UnitOperation]. *)
      {
        OptionName -> SampleModel,
        Default -> Null,
        Description -> "Specifies the model of the given sample. This option should only be used if you want to override the default Model[Sample] of your labeled sample.",
        AllowNull -> True,
        Category -> "Health & Safety",
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[Model[Sample]]
        ]
      },
      {
        OptionName -> Composition,
        Default -> Null,
        AllowNull -> True,
        Widget -> Adder[{
          "Amount" -> Alternatives[
            Widget[
              Type -> Quantity,
              Pattern :> Alternatives[
                GreaterP[0 Molar],
                GreaterP[0 Gram / Liter],
                RangeP[0 VolumePercent, 100 VolumePercent],
                RangeP[0 MassPercent, 100 MassPercent],
                RangeP[0 PercentConfluency, 100 PercentConfluency],
                GreaterP[0 Cell / Liter],
                GreaterP[0 CFU / Liter],
                GreaterP[0 OD600],
                GreaterP[0 Colony]
              ],
              Units -> Alternatives[
                {1, {Molar, {Micromolar, Millimolar, Molar}}},
                CompoundUnit[
                  {1, {Gram, {Kilogram, Gram, Milligram, Microgram}}},
                  {-1, {Liter, {Liter, Milliliter, Microliter}}}
                ],
                {1, {VolumePercent, {VolumePercent}}},
                {1, {MassPercent, {MassPercent}}},
                {1, {PercentConfluency, {PercentConfluency}}},
                CompoundUnit[
                  {1, {EmeraldCell, {EmeraldCell}}},
                  {-1, {Milliliter, {Liter, Milliliter, Microliter}}}
                ],
                CompoundUnit[
                  {1, {CFU, {CFU}}},
                  {-1, {Milliliter, {Liter, Milliliter, Microliter}}}
                ],
                {1, {OD600, {OD600}}},
                {1, {Colony, {Colony}}}
              ]
            ],
            Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
          ],
          "Identity Model" -> Alternatives[
            Widget[Type -> Object, Pattern :> ObjectP[List @@ IdentityModelTypeP]],
            Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
          ]
        }],
        Description -> "Specifies molecular composition of this sample. This option should only be used if you want to override the automatically calculated Composition of your labeled sample.",
        Category -> "Health & Safety"
      },
      (* Option to restrict the samples *)
      {
        OptionName -> Restricted,
        Default -> Null,
        Description -> "Indicates whether the sample should be restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member). Setting the option to Null means the sample should be untouched. Setting the option to True or False will set the Restricted field of the sample to that value respectively.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ]
      },
      (* Option to specify the Density of the new sample *)
      {
        OptionName -> Density,
        Default -> Null,
        Description -> "Indicates the known density of the sample being labeled at room temperature. By setting upfront, this allows ECL to skip measuring the density later.",
        AllowNull -> True,
        Category -> "General",
        Widget -> Widget[
          Type -> Quantity,
          Pattern :> GreaterP[(0 * Gram) / Milliliter],
          Units -> CompoundUnit[
            {1, {Gram, {Kilogram, Gram}}},
            Alternatives[
              {-3, {Meter, {Centimeter, Meter}}},
              {-1, {Liter, {Milliliter, Liter}}}
            ]
          ]
        ]
      },

      (* NOTE: We include all of the EHS options from DefineEHSInformation. *)
      Sequence @@ ModifyOptions[
        "ShareAll",
        ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions,
        {
          {
            OptionName -> StorageCondition,
            Widget -> Alternatives[
              Widget[
                Type -> Enumeration,
                Pattern :> SampleStorageTypeP | Disposal
              ],
              Widget[
                Type -> Object,
                Pattern :> ObjectP[Model[StorageCondition]],
                OpenPaths -> {{Object[Catalog, "Root"], "Storage Conditions"}}
              ]
            ]
          }
        }
      ],

      IndexMatchingInput -> "sample labels"
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
    CacheOption,
    ParentProtocolOption,

    {
      OptionName->Primitives,
      Default->{},
      AllowNull->False,
      Widget->Widget[Type->Expression,Pattern:>_List,Size->Line],
      Description->"Used to pass in the complete list of primitives so that we can resolve the Amount option. Note that these primitives will have their options expanded to be index-matching but they will NOT be resolved.",
      Category->"Hidden"
    }
  }
];

DefineOptions[resolveLabelSampleMethod,
  SharedOptions:>{
    resolveLabelSamplePrimitive,
    CacheOption,
    SimulationOption,
    OutputOption
  }
];

(* Source Code *)

resolveLabelSampleMethod[myLabels:ListableP[_String|Automatic], myOptions:OptionsPattern[]]:=Module[
  {safeOptions, outputSpecification, output, gatherTests, objectContainerPackets, modelContainerPackets,
    manualRequirementStrings, roboticRequirementStrings, allModelContainerPackets, allModelContainerPlatePackets, liquidHandlerIncompatibleContainers, result, tests},

  (* Get our safe options. *)
  safeOptions=SafeOptions[resolveLabelSampleMethod, ToList[myOptions]];

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
        Cases[Flatten[ToList[Lookup[safeOptions, Container]]], ObjectP[Object[Container]]],
        Cases[Flatten[ToList[Lookup[safeOptions, Container]]], ObjectP[Model[Container]]]
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
  allModelContainerPlatePackets=Cases[allModelContainerPackets,PacketP[Model[Container,Plate]]];

  (* determine if all the container model packets in question can fit on the liquid handler (MetaXpress can only accept plate) *)
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

resolveLabelSampleWorkCell[myLabels:ListableP[_String|Automatic], myOptions:OptionsPattern[]]:={STAR, bioSTAR, microbioSTAR};

(* NOTE: If you're looking for a primitive to template off of, do NOT pick this one. LabelSample is weird because we use the same function *)
(* for both the manual and work cell versions. There are also exceptions in the framework code for it since it doesn't generate a protocol *)
(* object. *)
resolveLabelSamplePrimitive[myLabels:ListableP[_String],myOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification, output, gatherTests, listedLabels, listedOptions, safeOps, safeOpsTests,
    validLengths, validLengthTests, expandedSafeOps, sampleOption, containerOption, modelOption,
    storageConditionOption, parentProtocolOption, allSampleObjects,
    allSampleModels, allContainerObjects, allContainerModels, allObjectEHSFields, allModelEHSFields,
    storageConditionModelFields, storageConditionModelPacket, sampleObjectFields, sampleObjectPacket, sampleModelFields, sampleModelPacket,
    containerObjectFields, containerObjectPacket, containerModelFields, containerModelPacket, downloadedCacheBall, cacheBall,
    resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, simulation, unitOperationPacket, resourceTests,
    productFields, safeOpsNamed, updatedSimulation, sanitizedLabels
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
    SafeOptions[resolveLabelSamplePrimitive,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[resolveLabelSamplePrimitive,listedOptions,AutoCorrect->False],{}}
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
    ValidInputLengthsQ[resolveLabelSamplePrimitive,{listedLabels},safeOps,Output->{Result,Tests}],
    {ValidInputLengthsQ[resolveLabelSamplePrimitive,{listedLabels},safeOps],Null}
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
  expandedSafeOps = Last[ExpandIndexMatchedInputs[resolveLabelSamplePrimitive,{listedLabels},safeOps]];

  (* Download information from the Sample, Container, SampleModel and StorageCondition options. *)
  sampleOption=Lookup[expandedSafeOps, Sample];
  containerOption=Lookup[expandedSafeOps, Container];
  modelOption=Lookup[expandedSafeOps,SampleModel];
  storageConditionOption=Cases[Lookup[expandedSafeOps,StorageCondition], ObjectP[Model[StorageCondition]]];
  parentProtocolOption=Lookup[expandedSafeOps,ParentProtocol];

  allSampleObjects=DeleteDuplicates[Cases[sampleOption, ObjectP[Object[Sample]]]];
  allSampleModels=DeleteDuplicates[Cases[Flatten[{sampleOption, modelOption}], ObjectP[Model[Sample]]]];
  allContainerObjects=DeleteDuplicates[Cases[Flatten[{sampleOption, containerOption}], ObjectP[Object[Container]]]];
  allContainerModels=DeleteDuplicates[Cases[containerOption, ObjectP[Model[Container]]]];

  allObjectEHSFields=ToExpression/@Options[ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions][[All,1]];
  allModelEHSFields=ToExpression/@Options[ExternalUpload`Private`ModelSampleHealthAndSafetyOptions][[All,1]];

  storageConditionModelFields={Name, Flammable, Acid, Base, Pyrophoric};
  sampleObjectFields={Name, State, Density, Container, Position, Model, Status, Volume, Mass, Density, Tablet, Sequence@@allObjectEHSFields};
  sampleObjectPacket=Packet@@sampleObjectFields;
  sampleModelFields={Name, Autoclave, Products, KitProducts, MixedBatchProducts, Density, State, Tablet, SolidUnitWeight, Fiber, FixedAmounts, Composition, Living, Sequence@@allModelEHSFields};
  sampleModelPacket=Packet@@sampleModelFields;
  containerObjectFields={Name, Status, Contents, Model};
  containerObjectPacket=Packet@@containerObjectFields;
  containerModelFields={Name, MaxVolume, Footprint, LiquidHandlerAdapter, LiquidHandlerPrefix};
  containerModelPacket=Packet@@containerModelFields;
  storageConditionModelPacket=Packet@@storageConditionModelFields;
  productFields={Name, ProductModel, KitComponents, MixedBatchComponents, DefaultContainerModel, Deprecated};

  (* Extract the packets that we need from our downloaded cache. *)
  downloadedCacheBall=Quiet[Flatten[{Download[
    {
      (*1*)allSampleObjects,
      (*2*)Flatten[{allSampleModels, Model[Sample, "Milli-Q water"]}],
      (*3*)allContainerObjects,
      (*4*)allContainerModels,
      (*5*)storageConditionOption,
      (*6*){parentProtocolOption},
      (*7*){parentProtocolOption},
      (*8*){parentProtocolOption},
      (*9*){$PersonID},
      (*10*){$PersonID}
    },
    {
      (*1*){
        sampleObjectPacket,
        Packet[StorageCondition[storageConditionModelFields]],
        Packet[Model[sampleModelFields]],
        Packet[Model[DefaultStorageCondition][storageConditionModelFields]],
        Packet[Container[Model][containerModelFields]]
      },
      (*2*){
        sampleModelPacket,
        Packet[DefaultStorageCondition[storageConditionModelFields]],
        Packet[Products[productFields]],
        Packet[KitProducts[productFields]],
        Packet[MixedBatchProducts[productFields]],
        Packet[Products[DefaultContainerModel][Footprint]],
        Packet[KitProducts[KitComponents][[All, DefaultContainerModel]][Footprint]],
        Packet[MixedBatchProducts[MixedBatchComponents][[All, DefaultContainerModel]][Footprint]]
      },
      (*3*){
        containerObjectPacket,
        Packet[Contents[[All,2]][sampleObjectFields]],
        Packet[Contents[[All,2]][Model][sampleModelFields]],
        Packet[Contents[[All,2]][StorageCondition][storageConditionModelFields]],
        Packet[Contents[[All,2]][Model][DefaultStorageCondition][storageConditionModelFields]],
        Packet[Model[containerModelFields]]
      },
      (*4*){containerModelPacket},
      (*5*){storageConditionModelPacket},
      (*6*){Packet[ParentProtocol..[Object]]},
      (*7*){
        Packet[Repeated[ParentProtocol][Author][FinancingTeams][Notebooks, NotebooksFinanced]],
        Packet[Author[FinancingTeams][Notebooks, NotebooksFinanced]]
      },
      (*8*){
        Packet[Repeated[ParentProtocol][Author][SharingTeams][Notebooks, NotebooksFinanced, ViewOnly]],
        Packet[Author[SharingTeams][Notebooks, NotebooksFinanced, ViewOnly]]
      },
      (*9*){Packet[FinancingTeams[Notebooks, NotebooksFinanced]]},
      (*10*){Packet[SharingTeams[Notebooks, NotebooksFinanced, ViewOnly]]}
    },
    Cache->Lookup[expandedSafeOps,Cache,{}],
    Simulation->simulation,
    Date->Now
  ]}],Download::FieldDoesntExist];

  cacheBall = Experiment`Private`FlattenCachePackets[{downloadedCacheBall, Lookup[expandedSafeOps,Cache,{}]}];

  (* Build the resolved options *)
  resolvedOptionsResult = Check[
    {resolvedOptions,resolvedOptionsTests} = If[gatherTests,
      resolveLabelSamplePrimitiveOptions[listedLabels,expandedSafeOps,Cache->cacheBall,Simulation->simulation,Output->{Result,Tests}],
      {resolveLabelSamplePrimitiveOptions[listedLabels,expandedSafeOps,Cache->cacheBall,Simulation->simulation],{}}
    ],
    $Failed,
    {Error::InvalidInput,Error::InvalidOption}
  ];

  (* Build packets with resources *)
  {unitOperationPacket, resourceTests}=If[gatherTests,
    labelSamplePrimitiveResources[listedLabels,resolvedOptions,Cache->cacheBall,Simulation->simulation,Output->{Result,Tests}],
    {labelSamplePrimitiveResources[listedLabels,resolvedOptions,Cache->cacheBall,Simulation->simulation],{}}
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  updatedSimulation = If[MemberQ[output, Simulation],
    simulateLabelSamplePrimitive[unitOperationPacket,listedLabels,resolvedOptions,Cache->cacheBall,Simulation->simulation,ParentProtocol->Lookup[safeOps, ParentProtocol, Null]],
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
  resolveLabelSamplePrimitiveOptions,
  Options:>{PreparationOption,ResolverOutputOption,CacheOption,SimulationOption}
];

Error::SolidWithVolumeRequested="The following sample(s), `1`, were requested with a volume, `2`. However, these samples do not have a density associated with them. Please request these samples using a mass instead.";
Error::AmountGreaterThanContainerMaxVolume="The sample(s), `1`, have the following amount(s), `2`, requested, but these amount(s) are greater than the MaxVolume of the specified container(s), `3`. Please either specify a smaller amount or specify a larger container.";
Error::SampleContainerLabelMismatch="The given sample(s), `1`, containers, `2`, and wells, `3`, are in conflict with one another. Object[Container]s can only be specified for the container option if the given sample is already in the container. Please either 1) specify a Model[Container] instead or 2) if you would like to transfer a sample into this specific container, please use the Transfer[...] primitive instead.";
Error::NoSampleExistsInWell="The container(s), `1`, do not currently have samples in them in the corresponding well(s), `2`. Samples can only be labeled in an Object[Container] if they already exist. Please either use the Transfer[...] primitive if you would like to transfer a sample into this specific container, or specify a Model[Container] (instead of an Object[Container]) to create a new sample in a new container.";
Error::LabelSampleDiscarded="The given sample(s), `1`, are already discarded. Only non-discarded samples can be labeled and used in an experiment. Please only supply non-discarded samples.";
Error::AmountSpecifiedAsCount="The sample(s), `1`, have their amount specified as a count, `2`, but these sample(s) are not marked as Tablet->True or Fiber->True. Please only specify the amount as a count if the sample is a tablet.";
Error::RequiredAmountAndContainer="The sample(s), `1`, are specified as Model[Sample]s. If Model[Sample]s are specified, the Amount and Container options cannot be Null. Please do not set these options to Null and let them automatically resolve.";
Error::ConflictingSafetyAndStorageCondition="The sample(s), `1`, will have the following safety fields set, Flammable->`2`, Acid->`3`, Base->`4`, Pyrophoric->`5`, set after the specified overrides. However, the sample(s) will also have the following storage conditions set, `6`. The given safety information does not match the give storage conditions. Please ensure that if you are overriding any safety fields to also change the storage condition of the samples.";
Warning::AutomaticSampleGiven="The Sample option wasn't specified at the current LabelSample primitive. The LabelSample primitive requires a Sample to be specified (either a new Model[Sample] to transfer into the container or an existing Object[Sample] already in the container). If you wish to label an empty container, use the LabelContainer primitive instead. The Sample option will default to Model[Sample, \"Milli-Q water\"].";
Error::ExactNullAmount="The sample(s), `1`, have the ExactAmount option set to True but the Amount option set to Null. The ExactAmount option can only be set if the Amount option is set to a mass, volume, or count. Please change the value of the Amount option.";
Error::ExactAmountToleranceRequiredTogether="The sample(s), `1`, have conflicting Tolerance and ExactAmount options. If a sample is required to have an ExactAmount, it is required that a Tolerance is specified. Likewise, if a Tolerance is specified, ExactAmount must be set to True. Please resolve this conflict to proceed.";
Error::UnresolvableLabeledSampleAmount="The sample(s), `1`, need to have Volume/Mass specified in the LabelSample call or later in the SamplePreparation call. Otherwise, the amount of `1` to use cannot be determined.";
Warning::LabeledSampleAmount="The sample(s), `1`, have Amount specified (`2`).  Amount should not be specified for Object[Sample]s, only for Model[Sample]s.  The specified amount will be ignored, and the full amount of the sample(s) will be selected instead.";

resolveLabelSamplePrimitiveOptions[myLabels:{_String..}, myOptions:{_Rule..}, myResolutionOptions:OptionsPattern[]]:=Module[
  {
    outputSpecification, output, gatherTests, cache, simulation, parentProtocol, parentProtocolTree, roundedVolumeOptions,precisionVolumeTests,
    roundedOptions,precisionMassTests, mapThreadFriendlyOptions, resolvedSamples, resolvedAmounts, resolvedContainers,
    resolvedWells, resolvedExactAmounts, resolvedSampleModelPackets, storageConditionSafetyFieldsMismatchResult,
    storageConditionSafetyFieldsInvalidOptions, storageConditionSafetyFieldsTest, requiredAmountAndContainerResult,
    requiredAmountAndContainerInvalidOptions, requiredAmountAndContainerTest, countSampleAndAmountResult, countSampleAndAmountInvalidOptions,
    countSampleAndAmountTest, discardedSamples, discardedSampleInvalidOptions, discardedSampleTest, noSampleCurrentlyExistsResult,
    noSampleCurrentlyExistsInvalidOptions, noSampleCurrentlyExistsTest, objectContainerMismatchResult, objectContainerMismatchInvalidOptions,
    objectContainerMismatchTest, amountGreaterThanContainerMaxVolumeResult, amountGreaterThanContainerMaxVolumeInvalidOptions,
    amountGreaterThanContainerMaxVolumeTest, solidVolumeNoDensitySamplesAndVolumes, solidVolumeNoDensityInvalidOptions,
    solidVolumeNoDensityTest, invalidOptions, sampleModelsAndWithoutResolvedContainers,
    resolvedSampleModelContainers, semiResolvedContainers, amountSampleWarningTests, resolvedPreparation,
    preparationResult, allowedPreparation, preparationTest, resolvedTolerances, toleranceExactAmountConflictSamples,
    toleranceExactAmountOptions, toleranceExactAmountTest, invalidExactAmountSamples, invalidExactAmountOptions, exactAmountTest,
    standardAmountPositions, standardAmounts, roundedAmounts, mergedAmounts, finalRoundOptions, unresolvableAmountSamples,
    unresolvableAmountOptions, unresolvableAmountTest, resolvedRequiredAmounts, amountSampleWarnings, otherStorageConditionErrorsResult,
    otherStorageConditionInvalidOptions, otherStorageConditionTest, specifiedDensity
  },

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests=MemberQ[output,Tests];

  (* Fetch our cache from the parent function. *)
  cache=Lookup[ToList[myResolutionOptions],Cache];
  simulation=Lookup[ToList[myResolutionOptions],Simulation];
  parentProtocol=Lookup[ToList[myOptions], ParentProtocol, Null];

  (* Get our full list of protocol ancestors. Protocols should be be our cache*)
  parentProtocolTree=Download[parentProtocol,ParentProtocol..[Object],Cache->cache];

  (* Resolve our preparation option. *)
  preparationResult=Check[
    {allowedPreparation, preparationTest}=If[MatchQ[gatherTests, False],
      {
        resolveLabelSampleMethod[myLabels, ReplaceRule[myOptions, {Cache->cache, Output->Result}]],
        {}
      },
      resolveLabelSampleMethod[myLabels, ReplaceRule[myOptions, {Cache->cache, Output->{Result, Tests}}]]
    ],
    $Failed
  ];

  (* If we have more than one allowable preparation method, just choose the first one. Our function returns multiple *)
  (* options so that OptimizeUnitOperations can perform primitive grouping. *)
  resolvedPreparation=If[MatchQ[allowedPreparation, _List],
    First[allowedPreparation],
    allowedPreparation
  ];

  (*-- OPTION PRECISION CHECKS --*)
  (* NOTE: We want to round up here if we are given numbers that are too precise because it is better to have too much sample *)
  (* that too little sample. *)

  (* We don't want to round if we're using FixedAmount/ExactAmount (?) *)

  (* Select only the standard non-fixed aliquot, non-exact-amount Amount options for rounding *)
  standardAmountPositions = Position[Lookup[myOptions,ExactAmount],False|Null|Automatic,{1}];
  standardAmounts=Extract[Lookup[myOptions,Amount],standardAmountPositions];

  (* Do our rounding on the filtered list *)
  {roundedVolumeOptions,precisionVolumeTests}=If[gatherTests,
    RoundOptionPrecision[<|Amount -> standardAmounts|>,{Amount},{1 Microliter},Output->{Result,Tests}, Round->Up],
    {RoundOptionPrecision[<|Amount -> standardAmounts|>,{Amount},{1 Microliter}, Round->Up],Null}
  ];

  {roundedOptions,precisionMassTests}=If[gatherTests,
    RoundOptionPrecision[roundedVolumeOptions,{Amount},{1 Milligram},Output->{Result,Tests}, Round->Up],
    {RoundOptionPrecision[roundedVolumeOptions,{Amount},{1 Milligram}, Round->Up],Null}
  ];

  (* Recreate our non-filtered list of amounts - replace any amounts that were rounded with their rounded versions *)
  roundedAmounts = Lookup[roundedOptions,Amount];
  mergedAmounts = ReplacePart[Lookup[myOptions,Amount],AssociationThread[standardAmountPositions,roundedAmounts]];

  finalRoundOptions = ReplaceRule[myOptions, Amount -> mergedAmounts];

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[resolveLabelSamplePrimitive,Association[finalRoundOptions]];

  (* ERROR CHECKING *)

  (* MAPTHREAD OPTION RESOLUTION *)
  {
    resolvedSamples,
    resolvedAmounts,
    semiResolvedContainers,
    resolvedWells,
    resolvedExactAmounts,
    resolvedTolerances,
    resolvedSampleModelPackets,
    resolvedRequiredAmounts,
    amountSampleWarnings
  }=Transpose@MapThread[
    Function[{label, mapThreadOptions},
      Module[{resolvedSample, sampleModelPacket, requiredAmounts, resolvedAmount, resolvedContainer, resolvedWell, resolvedExactAmount, resolvedTolerance, samplePacket, amountSampleWarning},
        (* Resolve the sample option. *)
        resolvedSample=Which[
          MatchQ[Lookup[mapThreadOptions, Sample], Except[Automatic]],
            Lookup[mapThreadOptions, Sample],
          MatchQ[Lookup[mapThreadOptions, Container], ObjectP[Object[Container]]],
            Module[{containerObjectPacket},
              (* Get the container packet. *)
              containerObjectPacket=fetchPacketFromCache[Lookup[mapThreadOptions, Container], cache];

              (* If we have a specific well, lookup the sample at that well. Otherwise, just take the sample in "A1". *)
              If[MatchQ[Lookup[mapThreadOptions, Well], WellPositionP],
                FirstCase[Lookup[containerObjectPacket, Contents], {Lookup[mapThreadOptions, Well], obj_}:>Download[obj, Object], Null],
                FirstCase[Lookup[containerObjectPacket, Contents], {"A1", obj_}:>Download[obj, Object], Null]
              ]
            ],
          True,
            Model[Sample, "Milli-Q water"]
        ];

        (* Get the packet of our sample for further resolving information. This is always the model packet, unless the model link *)
        (* is severed, in which case it is the Object[Sample] packet. It kind of also makes sense here that if we are labeling a sample as a model...we
        should pull that model packet instead of whatever packet our simulation code has generated which will not contain a model. *)
        sampleModelPacket=Which[
          MatchQ[Lookup[mapThreadOptions,SampleModel],ObjectP[Model[]]],
            fetchPacketFromCache[Lookup[mapThreadOptions,SampleModel],cache],
          MatchQ[resolvedSample, ObjectP[Model[Sample]]],
            fetchPacketFromCache[resolvedSample, cache],
          MatchQ[resolvedSample, ObjectP[Object[Sample]]],
            Module[{objectSamplePacket},
              (* Get the object packet. *)
              objectSamplePacket=fetchPacketFromCache[resolvedSample, cache];

              If[MatchQ[Lookup[objectSamplePacket, Model], Null],
                objectSamplePacket,
                fetchPacketFromCache[Lookup[objectSamplePacket, Model], cache]
              ]
            ],
          MatchQ[resolvedSample, {_String, ObjectP[Object[Container]]}],
            Module[{containerPacket, samplePacket},
              (* Get the packet of the object container. *)
              containerPacket=fetchPacketFromCache[resolvedSample[[2]], cache];

              (* Get the sample at the given position. *)
              samplePacket=fetchPacketFromCache[
                FirstCase[Lookup[containerPacket, Contents], {resolvedSample[[1]], sample_}:>sample, Null],
                cache
              ];

              (* Get the packet of the sample's model. *)
              Which[
                MatchQ[samplePacket, Null],
                  <||>,
                MatchQ[Lookup[samplePacket, Model], Null],
                  samplePacket,
                True,
                  fetchPacketFromCache[Lookup[samplePacket, Model], cache]
              ]
            ],
          True,
            <||>
        ];

        (* Get the packet of our sample for further resolving information. This is <||> in the case that we were given a *)
        (* sample model. *)
        samplePacket=Which[
          MatchQ[resolvedSample, ObjectP[Model[Sample]]],
            <||>,
          MatchQ[resolvedSample, ObjectP[Object[Sample]]],
            fetchPacketFromCache[resolvedSample, cache],
          MatchQ[resolvedSample, {_String, ObjectP[Object[Container]]}],
            FirstCase[cache, KeyValuePattern[{Container->ObjectP[resolvedSample[[2]]], Position->resolvedSample[[1]]}], <||>],
          True,
            <||>
        ];

        (* Resolve the amount option. *)
        (* For each unresolved primitive, look for options where our label can come up. If we find it, return an amount of how much that primitive will *)
        (* need of that label. *)

        (* NOTE: We are mapping over UNRESOLVED primitives here. This is fine because the sample label cannot come up unless the user specifically *)
        (* specifies it. There is a little bit of a chicken-and-the-egg issue if you have a corresponding option that has yet to be resolved (ex. BufferVolume). *)
        (* Just make sure that you're requesting an amount of the sample that makes sense -- plus a little buffer amount. This amount will be used to make the *)
        (* resource for the sample SO INCLUDE YOUR BUFFER AMOUNTS. *)

        (* NOTE: THIS IS THE PLACE WHERE YOU SHOULD ADD ANOTHER BRANCH TO THE SWITCH STATEMENT THAT SAYS HOW MUCH OF THE SAMPLE TO REQUEST. *)
        (* note that the required amounts are also {} if the sample was specified as a sample (and not a model); the Amount option doesn't really make sense for a sample *)
        requiredAmounts=If[MatchQ[Lookup[mapThreadOptions, Amount], Except[Automatic]] || MatchQ[resolvedSample, ObjectP[Object[Sample]]],
          {},
          Flatten@Map[
            Function[unresolvedPrimitive,
              Switch[unresolvedPrimitive,
                _Transfer|_Aliquot,
                  Module[{transposedSamplesAndAmounts},
                    (* Thread our sample and amounts together. *)
                    (* NOTE: We are given index-matched options here so we can do this. *)
                    transposedSamplesAndAmounts=Transpose[{ToList[Lookup[unresolvedPrimitive[[1]], Source]], ToList[Lookup[unresolvedPrimitive[[1]], Amount]]}];

                    (* Get indices that specifically reference this label or the sample ID/{container, well}. *)
                    (* NOTE: Special case here because transfer allows {container, well} syntax as inputs. Most experiments don't. *)
                    If[MatchQ[resolvedSample, ObjectP[Object[Sample]]|{_String, ObjectP[Object[Container]]}],
                      Cases[transposedSamplesAndAmounts, {label|resolvedSample, _}/.{link_Link:>ObjectP[link]}][[All,2]],
                      Cases[transposedSamplesAndAmounts, {label, _}][[All,2]]
                    ]
                  ],
                _,
                  Nothing
              ]
            ],
            Lookup[mapThreadOptions, Primitives]
          ]
        ];

        (* Are we dealing with an Object[Sample] or Model[Sample]? *)
        resolvedAmount=If[MatchQ[Lookup[samplePacket, Object], ObjectReferenceP[Object[Sample]]],
          (* - Objects - *)
          (* Amount should just be Null for Object[Sample]s *)
          Lookup[mapThreadOptions, Amount] /. {Automatic -> Null},

          (* - Models - *)
          Which[
            MatchQ[Lookup[mapThreadOptions, Amount], Except[Automatic]],
              Lookup[mapThreadOptions, Amount],
            (* NOTE: This should never occur, but if it does, we must have thrown an error somewhere else. *)
            MemberQ[requiredAmounts, All],
              Which[
                MatchQ[Lookup[sampleModelPacket, State], Liquid],
                  1 Milliliter,
                MatchQ[Lookup[sampleModelPacket, Tablet], True],
                  10,
                MatchQ[Lookup[sampleModelPacket, State], Solid],
                  1 Gram,
                True,
                  Null
              ],
            MatchQ[requiredAmounts, {VolumeP..}] && MatchQ[Lookup[sampleModelPacket, State], Liquid],
              Total[requiredAmounts],
            MatchQ[requiredAmounts, {MassP..}],
              Total[requiredAmounts],
            MatchQ[requiredAmounts, {_Integer..}],
              Total[requiredAmounts],
            (* If we don't have any primitive requirements but are given a container model, fill up the container. *)
            MatchQ[Lookup[mapThreadOptions, Container], ObjectP[Model[Container]]],
              Lookup[fetchPacketFromCache[Lookup[mapThreadOptions, Container], cache], MaxVolume],
            (* If we don't have any primitive requirements but are given a container model well, fill up the well. *)
            MatchQ[Lookup[mapThreadOptions, Sample], {_String, ObjectP[Model[Container]]}],
             Lookup[fetchPacketFromCache[Lookup[mapThreadOptions, Sample][[2]], cache], MaxVolume],
            (* If we don't have any primitive requirements but are given a container, fill up the container. *)
            MatchQ[Lookup[mapThreadOptions, Container], ObjectP[Object[Container]]],
              Lookup[
                fetchPacketFromCache[
                  Lookup[fetchPacketFromCache[Lookup[mapThreadOptions, Container], cache],Model],
                  cache
                ],
                MaxVolume
              ],
            (* If we don't have any primitive requirements but are given a container well, fill up the well. *)
            MatchQ[Lookup[mapThreadOptions, Sample], {_String, ObjectP[Object[Container]]}],
              Times[
                Lookup[
                  fetchPacketFromCache[
                    Lookup[fetchPacketFromCache[Lookup[mapThreadOptions, Sample][[2]], cache],Model],
                    cache
                  ],
                  MaxVolume
                ],
                (* Convert to mass if the sample is supposed to be a solid. *)
                If[MatchQ[Lookup[samplePacket, State], Solid],
                  Quantity[0.997, ("Grams")/("Milliliters")],
                  1
                ]
              ],
            (* Default to 1mL if we are asked for a Model[Sample] because we have no clue. We will also error in this case *)
            True,
              Which[
                MatchQ[Lookup[sampleModelPacket, State], Liquid],
                  1 Milliliter,
                MatchQ[Lookup[sampleModelPacket, Tablet], True],
                  10,
                MatchQ[Lookup[sampleModelPacket, State], Solid],
                  1 Gram,
                True,
                  Null
              ]
          ]
        ];

        (* flip a warning switch for if Amount is specified for an Object[Sample] *)
        amountSampleWarning = MatchQ[resolvedSample, ObjectP[Object[Sample]]] && Not[NullQ[resolvedAmount]];

        (* Resolve the ExactAmount option. *)
        resolvedExactAmount=Which[
          (* if user specified one, use it *)
          MatchQ[Lookup[mapThreadOptions, ExactAmount], Except[Automatic]],
            Lookup[mapThreadOptions, ExactAmount],
          (* resolve to True if this is a FixedAmounts sample *)
          MatchQ[Lookup[sampleModelPacket, FixedAmounts], {(VolumeP|MassP..)}],
            True,
          (* resolve to True if the user has set the Amount option *)
          MatchQ[Lookup[mapThreadOptions, Amount], Except[Automatic|Null]],
            True,
          (* resolve to True if the user has set the Tolerance option *)
          MatchQ[Lookup[mapThreadOptions, Tolerance], Except[Automatic|Null]],
            True,
          (* otherwise, resolve to False *)
          True,
            False
        ];

        (* Resolve the Tolerance option. *)
        resolvedTolerance=Which[
          (* if user specified one, use it *)
          MatchQ[Lookup[mapThreadOptions, Tolerance], Except[Automatic]],
            Lookup[mapThreadOptions, Tolerance],
          (* resolve to True if we have ExactAmount->True *)
          MatchQ[resolvedExactAmount, True]&&MatchQ[resolvedAmount, UnitsP[]],
            0.01*resolvedAmount,
          (* otherwise, resolve to Null *)
          True,
            Null
        ];

        (* Resolve the container option. *)
        (* NOTE: We do NOT resolve the container option here if we have a Model[Sample]. We will do a single search *)
        (* later to get all of the available samples that the user already has. *)
        resolvedContainer=Which[
          MatchQ[Lookup[mapThreadOptions, Container], Except[Automatic]],
            Lookup[mapThreadOptions, Container],
          MatchQ[resolvedSample, ObjectP[Object[Sample]]],
            Download[Lookup[fetchPacketFromCache[resolvedSample, cache], Container], Object],
          MatchQ[resolvedSample, {_String, ObjectP[Object[Container]]}],
            Download[resolvedSample[[2]], Object],

          (* pick the 50 mL tube somewhat arbitrarily if we got this far and have a Null amount but a Model[Sample] (or if we have a funky water sample) *)
          Or[
            MatchQ[resolvedSample, ObjectP[Model[Sample]]] && NullQ[resolvedAmount],
            MatchQ[resolvedSample, ObjectP[Model[Sample, "Milli-Q water"]]] && Not[VolumeQ[resolvedAmount]]
          ],
            Model[Container, Vessel, "50mL Tube"],
          (* If we have a water sample, resolve the container to PreferredContainer[...] so that we don't do a search *)
          (* for samples that have water in them. *)
          MatchQ[resolvedSample, ObjectP[Model[Sample, "Milli-Q water"]]],
            If[MatchQ[resolvedPreparation, Robotic],
              If[MatchQ[Max[resolvedAmount*1.1,$MicroWaterMaximum], GreaterP[50 Milliliter]],
                Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
                PreferredContainer[Max[resolvedAmount*1.1,$MicroWaterMaximum], LiquidHandlerCompatible->True, Cache -> cache, Simulation -> simulation]
              ],
              PreferredContainer[Max[resolvedAmount*1.1,$MicroWaterMaximum], Cache -> cache, Simulation -> simulation]
            ],
          True,
            Automatic
        ];

        (* Resolve the well option. *)
        resolvedWell=Which[
          MatchQ[Lookup[mapThreadOptions, Well], Except[Automatic]],
            Lookup[mapThreadOptions, Well],
          MatchQ[resolvedSample, {_String, ObjectP[Object[Container]]}],
            resolvedSample[[1]],
          MatchQ[resolvedSample, ObjectP[Object[Sample]]],
            Lookup[fetchPacketFromCache[resolvedSample, cache], Position],
          True,
            "A1"
        ];

        (* Return our resolved options. *)
        {
          resolvedSample,
          resolvedAmount,
          resolvedContainer,
          resolvedWell,
          resolvedExactAmount,
          resolvedTolerance,
          sampleModelPacket,
          requiredAmounts,
          amountSampleWarning
        }
      ]
    ],
    {myLabels, mapThreadFriendlyOptions}
  ];

  (* If we still have containers that are not resolved, do a search for Model[Sample]s of these containers. *)
  (* NOTE: Above, we resolved the container option if we had Milli-Q water. Therefore, we should never do searches for Milli-Q water. *)
  (* also going to add the specified density if they gave it since we'll use it below *)
  specifiedDensity = Lookup[myOptions, Density];
  sampleModelsAndWithoutResolvedContainers=Cases[
    Transpose[{resolvedSamples, resolvedAmounts, semiResolvedContainers, resolvedSampleModelPackets, Range[Length[resolvedSamples]], specifiedDensity, resolvedExactAmounts, resolvedTolerances, Lookup[mapThreadFriendlyOptions, Sterile]}],
    {ObjectP[Model[Sample]], _, Automatic, _, _, _, _, _, _}
  ];

  (* call helper to resolve a container for any Model[Sample] in the source *)
  resolvedSampleModelContainers = If[Length[sampleModelsAndWithoutResolvedContainers] == 0,
    {},
    resolveModelSampleContainer[
      (* list of Model[Sample]s *)
      sampleModelsAndWithoutResolvedContainers[[All, 1]],
      (* the amount in volume for each Model[Sample] *)
      sampleModelsAndWithoutResolvedContainers[[All, 2]],
      (* parent protocol *)
      parentProtocol,
      (* root protocol *)
      Last[Flatten[{parentProtocolTree}], parentProtocol],
      (* sterile booleans *)
      sampleModelsAndWithoutResolvedContainers[[All, 9]],
      (* resolved method *)
      resolvedPreparation,

      Density -> sampleModelsAndWithoutResolvedContainers[[All, 6]],
      ExactAmount -> sampleModelsAndWithoutResolvedContainers[[All, 7]],
      Tolerance -> sampleModelsAndWithoutResolvedContainers[[All, 8]],

      Cache -> cache,
      Simulation -> simulation
    ]
  ];

  (* Put these resolved containers into the larger list. *)
  (* NOTE: We make sure to only put these resolved containers for Model[Sample]s into our resolved list if the user *)
  (* didn't give us an option. *)
  resolvedContainers=semiResolvedContainers;
  MapThread[
    Function[{resolvedSampleModelContainer, index},
      If[MatchQ[resolvedContainers[[index]], Automatic],
        resolvedContainers[[index]]=resolvedSampleModelContainer;
      ]
    ],
    {resolvedSampleModelContainers, sampleModelsAndWithoutResolvedContainers[[All,5]]}
  ];

  (* 4) If given a Model[Sample], amount and container can't be Null. *)
  requiredAmountAndContainerResult=MapThread[
    Function[{sample, amount, container},
      If[MatchQ[sample, ObjectP[Model[Sample]]] && (MatchQ[amount, Null] || MatchQ[container, Null]),
        sample,
        Nothing
      ]
    ],
    {resolvedSamples, resolvedAmounts, resolvedContainers}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  requiredAmountAndContainerInvalidOptions=If[Length[requiredAmountAndContainerResult]>0&&!gatherTests,
    Message[Error::RequiredAmountAndContainer,ObjectToString[requiredAmountAndContainerResult[[All,1]],Cache->cache]];
    {Sample},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  requiredAmountAndContainerTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,requiredAmountAndContainerResult[[All,1]]];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" do not have the Amount/Container option set to Null if they are Model[Sample]s:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[requiredAmountAndContainerResult[[All,1]]]>0,
        Test["The sample(s) "<>ObjectToString[requiredAmountAndContainerResult[[All,1]],Cache->cache]<>" do not have the Amount/Container option set to Null if they are Model[Sample]s:",True,False],
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

  (* 5) Count can only be requested if Tablet->True or Fiber->True. *)
  countSampleAndAmountResult=MapThread[
    Function[{sample, amount, sampleModelPacket},
      If[!(MatchQ[Lookup[sampleModelPacket, Tablet], True]||MatchQ[Lookup[sampleModelPacket, Fiber], True]) && MatchQ[amount, _Integer],
        {sample, amount},
        Nothing
      ]
    ],
    {resolvedSamples, resolvedAmounts, resolvedSampleModelPackets}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  countSampleAndAmountInvalidOptions=If[Length[countSampleAndAmountResult]>0&&!gatherTests,
    Message[Error::AmountSpecifiedAsCount,ObjectToString[countSampleAndAmountResult[[All,1]],Cache->cache],countSampleAndAmountResult[[All,2]]];
    {Sample, Amount},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  countSampleAndAmountTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,countSampleAndAmountResult[[All,1]]];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" do not have their amounts specified as counts if they are not marked as Tablet->True:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[countSampleAndAmountResult[[All,1]]]>0,
        Test["The sample(s) "<>ObjectToString[countSampleAndAmountResult[[All,1]],Cache->cache]<>" do not have their amounts specified as counts if they are not marked as Tablet->True:",True,False],
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

  (* 6) Sample can't be discarded. *)
  discardedSamples=Map[
    Function[sample,
      Module[{samplePacket},
        (* Get the sample OBJECT packet. *)
        samplePacket=Which[
          MatchQ[sample, ObjectP[Object[Sample]]],
            fetchPacketFromCache[sample, cache],
          MatchQ[sample, {_String, ObjectP[Object[Container]]}],
            Module[{containerPacket, sampleObject},
              (* Get the packet of the object container. *)
              containerPacket=fetchPacketFromCache[sample[[2]], cache];

              (* Get the sample object. *)
              sampleObject=FirstCase[Lookup[containerPacket, Contents], {sample[[1]], actualSample_}:>actualSample, Null];

              (* Get the sample at the given position. *)
              If[MatchQ[sampleObject, Null],
                <||>,
                fetchPacketFromCache[sampleObject, cache]
              ]
            ],
          True,
            <||>
        ];

        If[MatchQ[Lookup[samplePacket, Status], Discarded],
          sample,
          Nothing
        ]
      ]
    ],
    resolvedSamples
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  discardedSampleInvalidOptions=If[Length[discardedSamples]>0&&!gatherTests,
    Message[Error::LabelSampleDiscarded,ObjectToString[discardedSamples[[All,1]],Cache->cache]];
    {Sample},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  discardedSampleTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,discardedSamples];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" are not discarded:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[discardedSamples]>0,
        Test["The sample(s) "<>ObjectToString[discardedSamples,Cache->cache]<>" are not discarded:",True,False],
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

  (* 7) No sample exists in the given {Container, Well}. *)
  noSampleCurrentlyExistsResult=MapThread[
    Function[{sample, container, well},
      Which[
        MatchQ[sample, {_String, ObjectP[Object[Container]]}],
          Module[{containerPacket},
            (* Get the packet of the object container. *)
            containerPacket=fetchPacketFromCache[sample[[2]], cache];

            (* Make sure that there is a sample at the given position. *)
            If[MatchQ[FirstCase[Lookup[containerPacket, Contents], {sample[[1]], _}, Null], Null],
              sample,
              Nothing
            ]
          ],
        MatchQ[sample, Null] && MatchQ[container, ObjectP[Object[Container]]] && MatchQ[well, WellPositionP],
          {well, container},
        True,
          Nothing
      ]
    ],
    {resolvedSamples, resolvedContainers, resolvedWells}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  noSampleCurrentlyExistsInvalidOptions=If[Length[noSampleCurrentlyExistsResult]>0&&!gatherTests,
    Message[Error::NoSampleExistsInWell,ObjectToString[noSampleCurrentlyExistsResult[[All,2]],Cache->cache],noSampleCurrentlyExistsResult[[All,1]]];
    {Container, Well},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  noSampleCurrentlyExistsTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedContainers,noSampleCurrentlyExistsResult[[All,1]]];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The container(s) "<>ObjectToString[passingInputs,Cache->cache]<>" have a sample that exists in the given well, if the container and well options are given but the sample option is not specified:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[noSampleCurrentlyExistsResult]>0,
        Test["The container(s) "<>ObjectToString[noSampleCurrentlyExistsResult[[All,1]],Cache->cache]<>" have a sample that exists in the given well, if the container and well options are given but the sample option is not specified:",True,False],
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

  (* 7.5) If the user gave us an Automatic for the Sample key, warn them that it will resolve to "Milli-Q water". *)
  If[Length[Cases[Lookup[mapThreadFriendlyOptions, Sample], Automatic]]>0&&!gatherTests&&Length[noSampleCurrentlyExistsInvalidOptions]==0,
    Message[Warning::AutomaticSampleGiven];
  ];


  (* 7.75) For each sample, the safety fields (Flammable/Acid/Base/Pyrophoric) match the storage condition if we're overriding things. *)
  (* NOTE: Don't do this check if we don't have samples in wells. *)
  (* NOTE: It's important that we do this even though we call UploadStorageCondition to error check as well because the *)
  (* user could be changing some of the safety fields without changing the storage condition field and cause a storage condition problem. *)
  (* Also, the UploadStorageCondition check only applies to Object[Sample]s, not Model[Model]s. *)
  storageConditionSafetyFieldsMismatchResult=If[Length[noSampleCurrentlyExistsInvalidOptions]>0,
    {},
    MapThread[
      Function[{sample, mapThreadOptions, sampleModelPacket,amount},
        Module[{samplePacket,sampleVolume,flammable,acid,base,pyrophoric,flammableOverride,acidOverride,
          baseOverride,pyrophoricOverride,anyOverrides,storageConditionModel,storageConditionModelPacket, flammableOverrideWithColdStorage},

          (* Get the sample packet *)
          samplePacket=Which[
            MatchQ[sample,ObjectP[Model[Sample]]],<||>,
            MatchQ[sample,ObjectP[Object[Sample]]],fetchPacketFromCache[sample,cache],
            MatchQ[sample,{_String, ObjectP[Object[Container]]}],FirstCase[cache,KeyValuePattern[{Container->ObjectP[sample[[2]]],Position->sample[[1]]}],<||>],
            True,<||>
          ];

          (* Find the sample volume *)
          sampleVolume=If[
            MatchQ[Lookup[samplePacket,Volume,Null],VolumeP],
            Lookup[samplePacket,Volume,Null],
            amount
          ];

          (* Figure out what the safety fields (Flammable/Acid/Base/Pyrophoric) and storage condition will be after the overrides *)
          {{flammable,acid,base,pyrophoric},{flammableOverride,acidOverride,baseOverride,pyrophoricOverride}}=Transpose@MapThread[
            Function[
              {hazardSymbol,threshold},
              Module[{belowThreshold,isHazard,hazardValue,thresholdOverride},
                (* If we have a known volume and it's below $AcidStorageThreshold (or corresponding) then we don't currently mark as Acidic (or corresponding) *)
                belowThreshold=If[
                  MatchQ[sampleVolume,VolumeP],
                  sampleVolume<=threshold,
                  False
                ];

                isHazard=If[
                  MatchQ[Lookup[mapThreadOptions,hazardSymbol],Except[Null]],
                  Lookup[mapThreadOptions,hazardSymbol],
                  Lookup[sampleModelPacket,hazardSymbol]
                ];

                (* Mark sample as a hazard (e.g. Acid->True) if that value is set or in the model _and_ if the volume of sample is above our threshold *)
                hazardValue=!belowThreshold&&isHazard;

                (* Determine if our sample is marked as a hazard (Acid etc.) but has a low enough volume that we don't need to store it as such *)
                thresholdOverride=belowThreshold&&(isHazard/.Null->False);

                {hazardValue,thresholdOverride}
              ]
            ],
            {
              {Flammable,Acid,Base,Pyrophoric},
              {$FlammableStorageThreshold,$AcidStorageThreshold,$BaseStorageThreshold,$PyrophoricStorageThreshold}
            }
          ];

          (* Find the storage condition model *)
          storageConditionModel=Which[

            (* If specified, use it *)
            MatchQ[Lookup[mapThreadOptions, StorageCondition], ObjectP[]], Lookup[mapThreadOptions, StorageCondition],

            (* If we have model packet, get it from there -- we are actually given the Object[Sample] packet if the Model link is severed *)
            KeyExistsQ[sampleModelPacket, DefaultStorageCondition], Lookup[sampleModelPacket, DefaultStorageCondition],

            (* Otherwise, get it from the Object[Sample] packet *)
            True,Lookup[sampleModelPacket, StorageCondition]
          ];

          (* Get the model for the storage condition *)
          storageConditionModelPacket=Replace[fetchPacketFromCache[storageConditionModel, cache],Null-><||>,{0}];

          (* We want to allow Flammable AND non-Flammable samples to be stored in DeepFreezer and CryogenicStorage conditions. *)
          (* So we'll default flammableOverride to True to match those storage conditions if that is our storage condition. *)
          flammableOverrideWithColdStorage = If[MatchQ[Lookup[storageConditionModelPacket, Object], ObjectP[
            {
              Model[StorageCondition, "id:xRO9n3BVOe3z"], (* Model[StorageCondition, "Deep Freezer"] *)
              Model[StorageCondition, "id:6V0npvmE09vG"] (* Model[StorageCondition, "Cryogenic Storage"] *)
            }
          ]],
            True,
            flammableOverride
          ];

          (* Save the sample info if the computed storage condition packet does not matches our hazard variables *)
          If[
            And[
              (* NOTE: The storage condition might be Null, in which case we won't have a packet to lookup from. *)
              MatchQ[storageConditionModelPacket, PacketP[]],
              Or@@MapThread[
                (* If there's no override and conditions don't match we need to report *)
                (!#3 && !MatchQ[#1,#2])&,
                {
                  Lookup[storageConditionModelPacket, {Flammable, Acid, Base, Pyrophoric}]/.{False->Null},
                  {flammable, acid, base, pyrophoric}/.{False->Null},
                  {flammableOverrideWithColdStorage,acidOverride,baseOverride,pyrophoricOverride}
                }
              ]
            ],
            {sample, flammable, acid, base, pyrophoric, storageConditionModel},
            Nothing
          ]
        ]
      ],
      {resolvedSamples, mapThreadFriendlyOptions, resolvedSampleModelPackets,resolvedAmounts}
    ]
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  storageConditionSafetyFieldsInvalidOptions=If[Length[storageConditionSafetyFieldsMismatchResult]>0&&!gatherTests,
    Message[
      Error::ConflictingSafetyAndStorageCondition,
      ObjectToString[storageConditionSafetyFieldsMismatchResult[[All,1]],Cache->cache],
      storageConditionSafetyFieldsMismatchResult[[All,2]],
      storageConditionSafetyFieldsMismatchResult[[All,3]],
      storageConditionSafetyFieldsMismatchResult[[All,4]],
      storageConditionSafetyFieldsMismatchResult[[All,5]],
      ObjectToString[storageConditionSafetyFieldsMismatchResult[[All,6]],Cache->cache]
    ];
    {StorageCondition},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  storageConditionSafetyFieldsTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,storageConditionSafetyFieldsMismatchResult[[All,1]]];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" do not have conflicting safety and storage condition information:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[storageConditionSafetyFieldsMismatchResult[[All,1]]]>0,
        Test["The sample(s) "<>ObjectToString[storageConditionSafetyFieldsMismatchResult[[All,1]],Cache->cache]<>" do not have conflicting safety and storage condition information:",True,False],
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

  (* 7.9) Call UploadStorageCondition to make sure that there aren't any other storage condition conflicts. We want to make sure that *)
  (* we call the actual function *)
  (* NOTE: We only need to do this check if the StorageCondition option is specified and if the Sample matches *)
  (* ObjectP[Object[Sample]]|{_String, ObjectP[Object[Container]]}. We can't have StorageCondition conflicts if given a Model[Sample]. *)
  otherStorageConditionErrorsResult=If[Or[
      Length[storageConditionSafetyFieldsMismatchResult]>0,
      Length[noSampleCurrentlyExistsInvalidOptions]>0,
      MatchQ[Lookup[myOptions, StorageCondition], {Null..}]
    ],
    Null,
    Module[{safetyPacketsAndCorrespondingStorageConditions, simulationWithSafetyUpdates},
      (* Quickly simulate any safety changes that have occurred to our samples. *)
      safetyPacketsAndCorrespondingStorageConditions=MapThread[
        Function[{sample, options},
          If[And[
              MatchQ[Lookup[options, StorageCondition], Except[Null]],
              MatchQ[sample, ObjectP[Object[Sample]]|{_String, ObjectP[Object[Container]]}]
            ],

            Module[{sampleObject},
              (* Make sure we have an Object[Sample]. *)
              sampleObject=If[MatchQ[sample, ObjectP[Object[Sample]]],
                sample,
                Module[{containerObjectPacket},
                  (* Get the container packet. *)
                  containerObjectPacket=fetchPacketFromCache[sample[[2]], cache];

                  FirstCase[Lookup[containerObjectPacket, Contents], {sample[[1]], obj_}:>Download[obj, Object], Null]
                ]
              ];

              {
                <|
                  Object->sampleObject,
                  If[MatchQ[Lookup[options, Flammable], Except[Null]],
                    Flammable->Lookup[options, Flammable],
                    Nothing
                  ],
                  If[MatchQ[Lookup[options, Acid], Except[Null]],
                    Acid->Lookup[options, Acid],
                    Nothing
                  ],
                  If[MatchQ[Lookup[options, Base], Except[Null]],
                    Base->Lookup[options, Base],
                    Nothing
                  ],
                  If[MatchQ[Lookup[options, Pyrophoric], Except[Null]],
                    Pyrophoric->Lookup[options, Pyrophoric],
                    Nothing
                  ]
                |>,
                Lookup[options, StorageCondition]
              }
            ],
            Nothing
          ]
        ],
        {resolvedSamples, mapThreadFriendlyOptions}
      ];

      simulationWithSafetyUpdates = If[MatchQ[simulation, SimulationP],
        UpdateSimulation[simulation, Simulation[safetyPacketsAndCorrespondingStorageConditions[[All,1]]]],
        UpdateSimulation[Simulation[], Simulation[safetyPacketsAndCorrespondingStorageConditions[[All,1]]]]
      ];

      (* NOTE: This will throw messages if there is an issue telling the user what the issue is. *)
      (* We quiet {Error::InvalidInput, Error::InvalidOptions} so they don't show up multiple times. *)
      If[Length[safetyPacketsAndCorrespondingStorageConditions]>0,
        Quiet[
          Check[
            UploadStorageCondition[
              Lookup[safetyPacketsAndCorrespondingStorageConditions[[All,1]], Object],
              safetyPacketsAndCorrespondingStorageConditions[[All,2]],
              Simulation->simulationWithSafetyUpdates,
              Output->Options
            ],
            $Failed,
            {Error::InvalidInput, Error::InvalidOptions}
          ],
          {Error::InvalidInput, Error::InvalidOptions}
        ],
        Null
      ]
    ]
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  otherStorageConditionInvalidOptions=If[MatchQ[otherStorageConditionErrorsResult, $Failed],
    {StorageCondition},
    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  otherStorageConditionTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Test[
      "All storage condition options are valid for the given samples, considering any other samples in the same container as the input sample and any safety considerations:",
      !MatchQ[otherStorageConditionErrorsResult, $Failed],
      True
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (* 8) If given an Object[Container], we must have an Object[Sample] and that Object[Sample] must ALREADY be in that specific container. *)
  objectContainerMismatchResult=MapThread[
    Function[{sample, container, well},
      Which[
        MatchQ[sample, {_String, ObjectP[Object[Container]]}] && (!MatchQ[sample[[2]], ObjectP[container]] || !MatchQ[sample[[1]], well]),
          {sample, container, well},
        (* If we have an Object[Container] but not an Object[Sample], immediate error. *)
        MatchQ[container, ObjectP[Object[Container]]] && MatchQ[sample, ObjectP[Model[Sample]]],
          {sample, container, well},
        (* We have an Object[Container] and Object[Sample]. Make sure the Object[Sample] is in the Object[Container] in the well. *)
        MatchQ[container, ObjectP[Object[Container]]] && MatchQ[sample, ObjectP[Object[Sample]]],
          Module[{samplePacket},
            (* Get the packet of the sample. *)
            samplePacket=fetchPacketFromCache[sample, cache];

            If[!MatchQ[Lookup[samplePacket, Container], ObjectP[container]] || !MatchQ[Lookup[samplePacket, Position], well],
              {sample, container, well},
              Nothing
            ]
          ],
        True,
          Nothing
      ]
    ],
    {resolvedSamples, resolvedContainers, resolvedWells}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  objectContainerMismatchInvalidOptions=If[Length[objectContainerMismatchResult]>0&&!gatherTests,
    Message[Error::SampleContainerLabelMismatch,ObjectToString[objectContainerMismatchResult[[All,1]],Cache->cache],objectContainerMismatchResult[[All,2]], objectContainerMismatchResult[[All,3]]];
    {Sample, Container},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  objectContainerMismatchTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,objectContainerMismatchResult[[All,1]]];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" are not in conflict with the Container option, if given as an Object[Sample]:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[objectContainerMismatchResult]>0,
        Test["The sample(s) "<>ObjectToString[objectContainerMismatchResult[[All,1]],Cache->cache]<>" are not in conflict with the Container option, if given as an Object[Sample]:",True,False],
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

  (* 9) The amount requested cannot be above the maximum volume of the container given. *)
  amountGreaterThanContainerMaxVolumeResult=MapThread[
    Function[{sample, containerList, amount, sampleModelPacket, densityOrNull},
      (* For each of our containers, see if there's an issue. *)
      Sequence@@Map[
        Function[{container},
          Module[{maxVolume, amountAsVolume},
            (* Get the MaxVolume of our container. *)
            maxVolume=Switch[container,
              ObjectP[Object[Container]],
                Lookup[fetchPacketFromCache[Lookup[fetchPacketFromCache[container, cache], Model], cache], MaxVolume],
              ObjectP[Model[Container]],
                Lookup[fetchPacketFromCache[container, cache], MaxVolume]
            ];

            (* Convert amount to a volume. *)
            amountAsVolume=Which[
              MatchQ[amount, VolumeP],
                amount,
              MatchQ[amount, MassP] && MatchQ[densityOrNull, DensityP],
                amount/densityOrNull,
               MatchQ[amount, MassP] && MatchQ[Lookup[sampleModelPacket, Density], DensityP],
                amount/Lookup[sampleModelPacket, Density],
              MatchQ[amount, MassP],
                amount/Quantity[0.997`, ("Grams")/("Milliliters")],
              MatchQ[amount, _Integer] && MatchQ[Lookup[sampleModelPacket, SolidUnitWeight], MassP] && MatchQ[densityOrNull, DensityP],
                (amount * Lookup[sampleModelPacket, SolidUnitWeight])/densityOrNull,
              MatchQ[amount, _Integer] && MatchQ[Lookup[sampleModelPacket, SolidUnitWeight], MassP] && MatchQ[Lookup[sampleModelPacket, Density], DensityP],
                (amount * Lookup[sampleModelPacket, SolidUnitWeight])/Lookup[sampleModelPacket, Density],
              MatchQ[amount, _Integer] && MatchQ[Lookup[sampleModelPacket, SolidUnitWeight], MassP],
                (amount * Lookup[sampleModelPacket, SolidUnitWeight])/Quantity[0.997`, ("Grams")/("Milliliters")]
            ];

            If[MatchQ[amountAsVolume, GreaterP[maxVolume]]&&!MatchQ[parentProtocol,ObjectP[Object[Protocol,StockSolution]]],
              {sample, amount, container},
              Nothing
            ]
          ]
        ],
        ToList[containerList]
      ]
    ],
    {resolvedSamples, resolvedContainers, resolvedAmounts, resolvedSampleModelPackets, specifiedDensity}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  amountGreaterThanContainerMaxVolumeInvalidOptions=If[Length[amountGreaterThanContainerMaxVolumeResult]>0&&!gatherTests,
    Message[Error::AmountGreaterThanContainerMaxVolume,ObjectToString[amountGreaterThanContainerMaxVolumeResult[[All,1]],Cache->cache],amountGreaterThanContainerMaxVolumeResult[[All,2]],amountGreaterThanContainerMaxVolumeResult[[All,3]]];
    {Amount, Container},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  amountGreaterThanContainerMaxVolumeTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,amountGreaterThanContainerMaxVolumeResult[[All,1]]];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" do not have a requested Amount that is greater than the MaxVolume of the specified container:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[amountGreaterThanContainerMaxVolumeResult]>0,
        Test["The sample(s) "<>ObjectToString[amountGreaterThanContainerMaxVolumeResult[[All,1]],Cache->cache]<>" do not  do not have a requested Amount that is greater than the MaxVolume of the specified container: a volume given as their amount if their State->Solid and do not have a density:",True,False],
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

  (* 10) Cannot request a volume of a solid without density information. *)
  solidVolumeNoDensitySamplesAndVolumes=MapThread[
    Function[{sample, amount, sampleModelPacket},
      If[And[
          MatchQ[amount, VolumeP],
          MatchQ[Lookup[sampleModelPacket, State], Solid],
          MatchQ[Lookup[sampleModelPacket, Density], Null]
        ],
        {sample, amount},
        Nothing
      ]
    ],
    {resolvedSamples, resolvedAmounts, resolvedSampleModelPackets}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  solidVolumeNoDensityInvalidOptions=If[Length[solidVolumeNoDensitySamplesAndVolumes]>0&&!gatherTests,
    Message[Error::SolidWithVolumeRequested,ObjectToString[solidVolumeNoDensitySamplesAndVolumes[[All,1]],Cache->cache],solidVolumeNoDensitySamplesAndVolumes[[All,2]]];
    {Amount},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  solidVolumeNoDensityTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,solidVolumeNoDensitySamplesAndVolumes[[All,1]]];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" do not have a volume given as their amount if their State->Solid and do not have a density:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[solidVolumeNoDensitySamplesAndVolumes[[All,1]]]>0,
        Test["The sample(s) "<>ObjectToString[solidVolumeNoDensitySamplesAndVolumes[[All,1]],Cache->cache]<>" do not have a volume given as their amount if their State->Solid and do not have a density:",True,False],
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

  (* 11) The ExactAmount option cannot be set if the Amount option is Null. *)
  invalidExactAmountSamples=MapThread[
    Function[{sample, exactAmount, amount},
      If[And[
        MatchQ[amount, Null],
        MatchQ[exactAmount, True]
      ],
        sample,
        Nothing
      ]
    ],
    {resolvedSamples, resolvedExactAmounts, resolvedAmounts}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  invalidExactAmountOptions=If[Length[invalidExactAmountSamples]>0&&!gatherTests,
    Message[Error::ExactNullAmount,ObjectToString[invalidExactAmountSamples,Cache->cache]];
    {ExactAmount, Amount},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  exactAmountTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,invalidExactAmountSamples];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" do not have ExactAmount->True if the Amount option is Null.",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[invalidExactAmountSamples]>0,
        Test["The sample(s) "<>ObjectToString[invalidExactAmountSamples,Cache->cache]<>" do not have ExactAmount->True if the Amount option is Null.",True,False],
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

  (* 12) The Tolerance option and ExactAmount option are required together. *)
  toleranceExactAmountConflictSamples=MapThread[
    Function[{sample, exactAmount, tolerance},
      If[Or[
        And[
          MatchQ[exactAmount, Except[True]],
          MatchQ[tolerance, Except[Null]]
        ],
        And[
          MatchQ[exactAmount, True],
          MatchQ[tolerance, Null]
        ]
      ],
        sample,
        Nothing
      ]
    ],
    {resolvedSamples, resolvedExactAmounts, resolvedTolerances}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  toleranceExactAmountOptions=If[Length[toleranceExactAmountConflictSamples]>0&&!gatherTests,
    Message[Error::ExactAmountToleranceRequiredTogether,ObjectToString[toleranceExactAmountConflictSamples,Cache->cache]];
    {ExactAmount, Amount},

    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  toleranceExactAmountTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,toleranceExactAmountConflictSamples];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" have a Tolerance specified if ExactAmount is set to True:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[toleranceExactAmountConflictSamples]>0,
        Test["The sample(s) "<>ObjectToString[toleranceExactAmountConflictSamples,Cache->cache]<>" have a Tolerance specified if ExactAmount is set to True:",True,False],
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


  (* 13) The Amount must be resolvable. *)
  (* Scenarios in which we have made a wild and likely wrong guess:*)
  (* if the sample is a Model and the required amount is All or {} and we are resolving the Amount, we cannot possibly get it right, we just default to some amount to finish the resolver *)
  unresolvableAmountSamples=MapThread[
    Function[{sample, requiredAmount, amount},
      If[MatchQ[{sample, requiredAmount, amount}, {ObjectP[Model[Sample]], (All|{}), Automatic}],
        sample,
        Nothing
      ]
    ],
    {resolvedSamples, resolvedRequiredAmounts, Lookup[mapThreadFriendlyOptions, Amount]}
  ];

  (* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOption. *)
  unresolvableAmountOptions=If[Length[unresolvableAmountSamples]>0&&!gatherTests,
    Message[Error::UnresolvableLabeledSampleAmount,ObjectToString[unresolvableAmountSamples,Cache->cache]];
    {Sample,Amount},
    {}
  ];

  (* If we are gathering tests, create a test with the appropriate result. *)
  unresolvableAmountTest=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs,passingInputsTest,nonPassingInputsTest},
      (* Get the inputs that pass this test. *)
      passingInputs=Complement[resolvedSamples,unresolvableAmountSamples];

      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[passingInputs]>0,
        Test["The sample(s) "<>ObjectToString[passingInputs,Cache->cache]<>" are not models with an unambiguous quantity requested:",True,True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest=If[Length[unresolvableAmountSamples]>0,
        Test["The sample(s) "<>ObjectToString[unresolvableAmountSamples,Cache->cache]<>" have an unambiguous required amount if the sample is a model:",True,False],
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

  (* 14) Don't specify Amount if the sample is an Object[Sample] *)
  If[MemberQ[amountSampleWarnings, True] && Not[gatherTests] && Not[MatchQ[$ECLApplication, Engine]],
    Message[Warning::LabeledSampleAmount, ObjectToString[PickList[resolvedSamples, amountSampleWarnings], Cache->cache], ObjectToString[PickList[resolvedAmounts, amountSampleWarnings]]]
  ];
  amountSampleWarningTests = If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputs, passingInputsTest, nonPassingInputsTest, failingInputs},
      (* Get the inputs that pass this test. *)
      passingInputs = PickList[resolvedSamples, amountSampleWarnings, False];
      failingInputs = PickList[resolvedSamples, amountSampleWarnings];

      (* Create a test for the passing inputs. *)
      passingInputsTest = If[Length[passingInputs] > 0,
        Warning["The sample(s) " <> ObjectToString[passingInputs, Cache -> cache] <> " only have Amount specified if they are not Object[Sample]s:", True, True],
        Nothing
      ];

      (* Create a test for the non-passing inputs. *)
      nonPassingInputsTest = If[Length[unresolvableAmountSamples] > 0,
        Warning["The sample(s) " <> ObjectToString[failingInputs, Cache -> cache] <> " only have Amount specified if they are not Object[Sample]s:", True, False],
        Nothing
      ];

      (* Return our created tests. *)
      {
        passingInputsTest,
        nonPassingInputsTest
      }
    ],
    {}
  ];

  (* Throw Error::InvalidOption. *)
  invalidOptions=DeleteDuplicates@Flatten@{
    storageConditionSafetyFieldsInvalidOptions,
    requiredAmountAndContainerInvalidOptions,
    countSampleAndAmountInvalidOptions,
    discardedSampleInvalidOptions,
    noSampleCurrentlyExistsInvalidOptions,
    objectContainerMismatchInvalidOptions,
    otherStorageConditionInvalidOptions,
    amountGreaterThanContainerMaxVolumeInvalidOptions,
    solidVolumeNoDensityInvalidOptions,
    invalidExactAmountOptions,
    toleranceExactAmountOptions,
    unresolvableAmountOptions,

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
        Sample->resolvedSamples,
        Container->resolvedContainers,
        Well->resolvedWells,
        Amount->resolvedAmounts,
        ExactAmount->resolvedExactAmounts,
        Tolerance->resolvedTolerances,
        Preparation->resolvedPreparation
      }
    ],
    Tests -> {
      precisionVolumeTests,
      precisionMassTests,
      storageConditionSafetyFieldsTest,
      requiredAmountAndContainerTest,
      countSampleAndAmountTest,
      discardedSampleTest,
      noSampleCurrentlyExistsTest,
      objectContainerMismatchTest,
      otherStorageConditionTest,
      solidVolumeNoDensityTest,
      exactAmountTest,
      toleranceExactAmountTest,
      unresolvableAmountTest,
      amountSampleWarningTests
    }
  }
];

DefineOptions[
  simulateLabelSamplePrimitive,
  Options:>{CacheOption,SimulationOption}
];

DefineOptions[
  labelSamplePrimitiveResources,
  Options:>{ResolverOutputOption,CacheOption,SimulationOption}
];

labelSamplePrimitiveResources[myLabels:{_String..},myResolvedOptions:{_Rule...},myResolutionOptions:OptionsPattern[labelSamplePrimitiveResources]]:=Module[
  {cache, simulation, mapThreadFriendlyOptions, parent, automaticDisposal, sampleResources, simulatedObjectsToLabel, containerLabelOrResources, labelSampleUnitOperationPacket, labelSampleUnitOperationPacketWithLabeledObjects},

  (* Lookup our cache. *)
  cache=Lookup[ToList[myResolutionOptions], Cache];
  simulation=Lookup[ToList[myResolutionOptions], Simulation];

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[resolveLabelSamplePrimitive,myResolvedOptions];

  (* Check our parent - if Null, don't auto dispose, if set auto dispose *)
  (* When we do label samples in stock solutions or for other subs we want to dispose of dregs since we should only be making the amount we need *)
  parent=Lookup[myResolvedOptions,ParentProtocol];
  automaticDisposal=!MatchQ[parent,Null];

  (* Create all of our sample resources. *)
  sampleResources=MapThread[
    Function[{sample, amount, container, well, exactAmount, tolerance, containerLabel},
      Which[
        MatchQ[sample, ObjectP[Object[Sample]]],
          (* for Object[Sample]s we don't need to actually reserve the volume/mass/whatever *)
          Resource[
            Sample->sample,
            Name->CreateUUID[]
          ],
        MatchQ[sample, ObjectP[Model[Sample]]],
          Resource[
            Sample->sample,
            Amount->Which[
              MatchQ[Download[sample, Object], WaterModelP] && Not[VolumeQ[amount]], 1 Milliliter, (* if we have to do this then we're already in an error state and this is just to prevent the resource system from trainwrecking *)
              MatchQ[amount, Null], 1 Gram, (* Mass will always work, no matter the state of the sample. *)
              True, amount
            ],
            ExactAmount->exactAmount,
            Tolerance->If[MatchQ[tolerance, PercentP],
              N[QuantityMagnitude[tolerance, Percent]/100] * amount,
              tolerance
            ],
            AutomaticDisposal->automaticDisposal,
            (* NOTE: Our container option can be a ListableP[Model[Container]] or Object[Container]. *)
            Container->If[MatchQ[container, ObjectP[Object[Container]]],
              PreferredContainer[amount],
              container
            ],
            Well -> well,
            ContainerName -> (containerLabel /. {Null -> CreateUUID[]}),
            Name->CreateUUID[]
          ],
        MatchQ[sample, {_String, ObjectP[Object[Container]]}],
          (* Get the sample that's in the position of the container. *)
          Module[{samplePacket},
            (* Try to find the sample that's at in the well of this container. *)
            samplePacket=FirstCase[cache, KeyValuePattern[{Container->ObjectP[sample[[2]]], Position->sample[[1]]}], Null];

            (* If we can't find the sample, don't make a resource. *)
            (* NOTE: We must have thrown an error about this in the resolver above. *)
            If[MatchQ[samplePacket, Null],
              Null,
              (* for Object[Sample]s we don't need to actually reserve the volume/mass/whatever *)
              Resource[
                Sample->If[!MatchQ[samplePacket, Null],
                  Lookup[samplePacket, Object],
                  sample[[1]]
                ],
                Name->CreateUUID[]
              ]
            ]

          ],
        MatchQ[container, ObjectP[Model[Container]]],
          Resource[
            Sample->container,
            Name->CreateUUID[]
          ],
        True,
          Null
      ]
    ],
    {
      Lookup[myResolvedOptions, Sample],
      Lookup[myResolvedOptions, Amount],
      Lookup[myResolvedOptions, Container],
      Lookup[myResolvedOptions, Well],
      Lookup[myResolvedOptions, ExactAmount],
      Lookup[myResolvedOptions, Tolerance],
      Lookup[myResolvedOptions, ContainerLabel]
    }
  ];

  (* determine which objects in the simulation are simulated and make replace rules for those *)
  simulatedObjectsToLabel = If[NullQ[simulation],
    {},
    Module[{allObjectsInSimulation, simulatedQ},
      (* Get all objects out of our simulation. *)
      allObjectsInSimulation = Download[Lookup[simulation[[1]], Labels][[All, 2]], Object];

      (* Figure out which objects are simulated. *)
      simulatedQ = Experiment`Private`simulatedObjectQs[allObjectsInSimulation, simulation];

      (Reverse /@ PickList[Lookup[simulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
    ]
  ];

  (* For the containers in the UO, we are creating resources for them or using the simulated label so the system knows it is pointing back to the correct object *)
  containerLabelOrResources=Map[
    If[MatchQ[#, ObjectP[Object[Container]]], Resource[Sample->#], #]&,
    Lookup[myResolvedOptions, Container]/. simulatedObjectsToLabel
  ];

  (* Create the unit operation packet. *)
  labelSampleUnitOperationPacket=Module[{nonHiddenOptions},
    nonHiddenOptions=Lookup[
      Cases[OptionDefinition[resolveLabelSamplePrimitive], KeyValuePattern["Category"->Except["Hidden"]]],
      "OptionSymbol"
    ];

    UploadUnitOperation[
      LabelSample@@Join[
        {
          Label->myLabels
        },
        ReplaceRule[
          Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenOptions, _]],
          {
            Sample->sampleResources,
            Container->containerLabelOrResources
          }
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
    labelSampleUnitOperationPacket,
    Replace[LabeledObjects]->Cases[
      Transpose[{myLabels, sampleResources}],
      {_String, Resource[KeyValuePattern[Sample->ObjectP[{Object[Sample], Model[Sample]}]]]}
    ]
  ];

  (* NOTE: We call FRQ in the framework, so we do not need to call it here. *)
  OptionValue[Output]/.{
    Result->labelSampleUnitOperationPacketWithLabeledObjects,
    Tests->{}
  }
];

simulateLabelSamplePrimitive[myUnitOperationPacket:PacketP[],myLabels:{_String..},myResolvedOptions:{_Rule...},myResolutionOptions:OptionsPattern[simulateLabelSamplePrimitive]]:=Module[
  {cache, mapThreadFriendlyOptions, currentSimulation, samplePackets, allEHSOptions, indexMatchedSpecifiedEHSOptions,
    ehsChangePackets, storageConditionPacketUpdates, labelToSampleLookup, finalLabelFieldLookup, specifiedDensity,
    densityPackets},

  (* Lookup our cache. *)
  cache=Lookup[ToList[myResolutionOptions], Cache, {}];

  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[resolveLabelSamplePrimitive,myResolvedOptions];

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

    SimulateResources[protocolPacket, {myUnitOperationPacket}, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]]
  ];

  (* Get the simulated objects of our samples. *)
  samplePackets=Download[Lookup[myUnitOperationPacket, Object], Packet[SampleLink[Container]], Simulation->currentSimulation];

  (* make sure the density gets inherited in the simulated objects *)
  specifiedDensity = Lookup[myResolvedOptions, Density];
  densityPackets = MapThread[
    If[NullQ[#2],
      Nothing,
      <|Object -> Lookup[#1, Object], Density -> #2|>
    ]&,
    {samplePackets, specifiedDensity}
  ];

  currentSimulation = UpdateSimulation[currentSimulation, Simulation[densityPackets]];

  (* Generate EHS override change packets. *)
  (* Change the SampleModel option into the Model option to pass down to generateChangePacket. *)
  allEHSOptions=Cases[
    Flatten@{SampleModel, Composition, ToExpression/@Options[ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions][[All,1]]},
    (* NOTE: StorageCondition is special and needs to be updated via UploadStorageCondition. *)
    Except[StorageCondition]
  ];
  indexMatchedSpecifiedEHSOptions=(
    Cases[
      Normal[#],
      rule:Verbatim[Rule][(Alternatives@@allEHSOptions),Except[Null]]:>(If[MatchQ[rule[[1]], SampleModel], Model->rule[[2]], rule])
    ]
  &)/@mapThreadFriendlyOptions;

  (* For each object, generate a change packet with the EHS changes if we have options filled out. *)
  ehsChangePackets=MapThread[
    Function[{sampleObject, specifiedEHSOptions},
      If[Length[specifiedEHSOptions]==0,
        Nothing,
        Append[
          ExternalUpload`Private`generateChangePacket[Object[Sample],specifiedEHSOptions],
          Object->sampleObject
        ]
      ]
    ],
    {Lookup[samplePackets/.{Null|$Failed-><||>}, Object], indexMatchedSpecifiedEHSOptions}
  ];

  (* Update the simulation to include the EHS changes. *)
  currentSimulation=UpdateSimulation[currentSimulation, Simulation[ehsChangePackets]];

  (* Call UploadStorageCondition to process any storage condition updates. *)
  storageConditionPacketUpdates=If[Length[Cases[Lookup[myResolvedOptions, StorageCondition], Except[Null]]] == 0,
    {},
    Module[{rawStorageConditionPacketUpdates},
      (* NOTE: We Quiet[...] here because we could have an invalid storage condition. In the simulation, we always have *)
      (* to return a valid simulation. If there was an issue, we will have already thrown an error in the resolver. *)
      rawStorageConditionPacketUpdates=Quiet[
        UploadStorageCondition[
          PickList[Lookup[samplePackets, Object], Lookup[myResolvedOptions, StorageCondition], Except[Null]],
          Cases[Lookup[myResolvedOptions, StorageCondition], Except[Null]],
          Simulation->currentSimulation,
          Upload->False
        ]
      ];

      If[!MatchQ[rawStorageConditionPacketUpdates, {PacketP[]..}],
        {},
        rawStorageConditionPacketUpdates
      ]
    ]
  ];

  (* Update the simulation to include the storage condition changes. *)
  currentSimulation=UpdateSimulation[currentSimulation, Simulation[storageConditionPacketUpdates]];

  (* Generate our labels. *)
  (* NOTE: In the case we have an error, we may have a Null here. *)
  labelToSampleLookup=If[MemberQ[samplePackets,Null],
    {},
    Rule@@@Join[
      Cases[
        Transpose[{myLabels, Lookup[samplePackets, Object]}],
        {_String, ObjectReferenceP[Object[Sample]]}
      ],
      Cases[
        Transpose[{Lookup[myResolvedOptions, ContainerLabel], Download[Lookup[samplePackets, Container], Object]}],
        {_String, ObjectReferenceP[Object[Container]]}
      ]
    ]
  ];

  (* NOTE: This string indicates to the framework that the sample is coming from the label lookup. *)
  finalLabelFieldLookup=(#->#&)/@Cases[Join[myLabels, Lookup[myResolvedOptions, ContainerLabel]], _String];

  (* Update our simulation. *)
  currentSimulation=UpdateSimulation[currentSimulation, Simulation[Labels->labelToSampleLookup, LabelFields->finalLabelFieldLookup]];

  (* Return our simulation. *)
  currentSimulation
];
