(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(* PackContainers *)

DefineOptions[PackContainers,
  Options :> {
    {
      OptionName -> FirstNewContainerIndex,
      Default -> 1,
      AllowNull -> False,
      Pattern :> GreaterEqualP[1, 1],
      Description -> "The integer that will be assigned as the first new container index generated from PackContainers.",
      Category -> "Container Packing"
    },
    {
      OptionName -> NumberOfReplicates,
      Default -> 1,
      AllowNull -> False,
      Pattern :> GreaterEqualP[1, 1],
      Description -> "The number of experiments to run under the conditions specified at each index.",
      Category -> "Container Packing"
    },

    (* Options from PreferredContainer; note that the Type and All options are omitted because they are not applicable *)

    {
      OptionName -> Sterile,
      Default -> False,
      AllowNull -> False,
      Pattern :> ListableP[Alternatives[Automatic,BooleanP]],
      Description -> "Indicates if the container should be sterile.",
      Category -> "Container Selection"
    },
    {
      OptionName -> Messages,
      Default -> True,
      AllowNull -> False,
      Pattern :> BooleanP,
      Description -> "Indicates if messages should be thrown.",
      Category -> "Container Selection"
    },
    {
      OptionName -> MaxTemperature,
      Default -> Automatic,
      AllowNull -> False,
      Pattern :> ListableP[Automatic|TemperatureP],
      Description -> "Indicates the minimum MaxTemperature that the container must be able to reach.",
      Category -> "Container Selection"
    },
    {
      OptionName -> MinTemperature,
      Default -> Automatic,
      AllowNull -> False,
      Pattern :> ListableP[Automatic|TemperatureP],
      Description -> "Indicates the maximum MinTemperature that the container must be able to reach.",
      Category -> "Container Selection"
    },
    {
      OptionName -> LiquidHandlerCompatible,
      Default -> False,
      AllowNull -> False,
      Pattern :> ListableP[Alternatives[Automatic,BooleanP]],
      Description -> "Indicates whether the containers returned must be compatible with the labs liquid handler robots.",
      Category -> "Container Selection"
    },
    {
      OptionName -> CellType,
      Default -> Null,
      AllowNull -> True,
      Pattern :> ListableP[Alternatives[CellTypeP,Null,Automatic]],
      Description -> "Indicates if the container should be compatible with tissue or microbial cell cultures.",
      Category -> "Container Selection"
    },
    {
      OptionName -> CultureAdhesion,
      Default -> Null,
      AllowNull -> True,
      Pattern :> ListableP[Alternatives[CultureAdhesionP,Null,Automatic]],
      Description -> "Indicates if the container should be treated for adherent cells or untreated for suspension cells.",
      Category -> "Container Selection"
    },

    CacheOption,
    SimulationOption
  }
];

Warning::MustRemoveContainerIndices = "Container indices are specified for the non-plate containers `1` at indices `3`, while the NumberOfReplicates option is set to `2`. These container indices will be removed to avoid transferring volumes from different experiments into the same vessel.";
Warning::PackNullContainer = "The container(s) at indices `1` are set to Null while also being designated for packing. The value of PackPlateQ will be set to False at any index where the container is Null, regardless of the input.";
Warning::UnknownRequiredContainerVolume = "The container(s) at indices `1` are designated for packing with the container set to Automatic, but there is not sufficient information to determine the required container volume. ";
Warning::PackIntoSameContainerPosition = "The combination(s) of container(s) `1` and well(s) `2` appear in `3` instances at indices `4`. If this is unintentional, please adjust the input and options to prevent packing two (or more) experiments into the same container(s).";
Warning::AvoidOverwritingWellPosition = "The container well(s) or position(s) `1` are specified at indices `2`, where PackPlateQ is set to True. To avoid overwriting the specified well(s), the value of PackPlateQ will be set to False at any index where a well/position is specified.";

PackContainers[
  myContainers:(ListableP[Alternatives[Null, Automatic, ObjectP[{Object[Container], Model[Container]}], {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[Model[Container]]}, {GreaterEqualP[1, 1], ObjectP[Model[Container]]}, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[Model[Container]]}}]]),
  myPackPlateQs:ListableP[BooleanP],
  myRequiredContainerVolumes:ListableP[Null|VolumeP],
  myParametersToGroupBy:ListableP[_List],
  myOptions:OptionsPattern[]
] := Module[
  {
    safeOptions, preferredContainerOptions, firstNewContainerIndex, numberOfReplicates, cache, listedPackPlateQs, listedRequiredContainerVolumes,
    listedContainers, parametersAsListOfLists, containerObjectFields, containerObjectPacketFields, containerModelFields, containerModelPacketFields,
    containerModelPackets, containerModelFromObjectPackets, cacheBall, fastAssoc, mustRemoveContainerIndicesCases, packNullContainerCases, listedSanitizedRequiredContainerVolumes,
    listedSanitizedPackPlateQs, unknownRequiredContainerVolumeCases, containersWithWellsRemoved, wellsFromContainers, potentialOverwritePositionCases,
    expandedContainersWithWellsRemoved, expandedRequiredContainerVolumes, expandedPackPlateQs, expandedWellsFromContainers, expandedParametersToGroupBy,
    parametersListsWithoutPreferredContainer, preferredContainers, parametersForSamplesToPreResolve, plateRequiredSampleIndices, groupedPreResolvedIndicesAndParameters,
    preResolvedIndexGroups, partitionedPreferredContainerModels, partitionedPreResolvedIndexGroups,

    userSpecifiedPlateWells, specifiedWellAndContainerPairings, containerToSpecifiedWellLookup,

    plateRequiredContainers, plateRequiredContainerWells, semiResolvedContainers,
    semiResolvedContainerWells, containerToAvailableWellsLookup, resolvedContainers, resolvedContainerWells, packIntoSameContainerPositionCases
  },

  (* Validate input options *)
  safeOptions = SafeOptions[PackContainers, ToList[myOptions]];

  (* Get the PreferredContainer options together since we'll always use them together *)
  preferredContainerOptions = PickList[
    safeOptions,
    Keys[safeOptions],
    Alternatives[
      Sterile, LightSensitive, Messages, MaxTemperature, MinTemperature, LiquidHandlerCompatible,
      AcousticLiquidHandlerCompatible, VacuumFlask, UltracentrifugeCompatible, CellType, CultureAdhesion
    ]
  ];

  (* Get the FirstNewContainerIndex and NumberOfReplicates options stored as variables *)
  firstNewContainerIndex = Lookup[safeOptions, FirstNewContainerIndex];
  numberOfReplicates = Lookup[safeOptions, NumberOfReplicates];

  (* Make sure that the PackPlate Booleans, required container volumes, and the containers themselves are formatted as lists, even for singleton inputs *)
  listedPackPlateQs = ToList[myPackPlateQs];
  listedRequiredContainerVolumes = ToList[myRequiredContainerVolumes];

  (* Reset containers to Null at any indices where *)

  (* Make sure that the parameters to group by are all formatted as lists of lists, even for singleton inputs *)
  parametersAsListOfLists = Which[
    MatchQ[myParametersToGroupBy, {_List..}],
    myParametersToGroupBy,
    True,
    {myParametersToGroupBy}
  ];

  (* Get the user specified containers into a format that won't cause issues with container singletons *)
  (* We can't just use ToList[] here, since some singleton container inputs are already lists *)
  listedContainers = Which[
    (* If the container input is a single input, convert this to a list of length 1 *)
    MatchQ[
      myContainers,
      Alternatives[
        ObjectP[{Object[Container], Model[Container]}],
        {_Integer, ObjectP[{Object[Container], Model[Container]}]},
        {_String, ObjectP[{Object[Container], Model[Container]}]},
        {_String, {_Integer, ObjectP[{Object[Container], Model[Container]}]}},
        Automatic,
        Null
      ]
    ],
      {myContainers},
    (* Otherwise, leave the specified containers as is *)
    True,
      myContainers
  ];

  (* Get the container fields we will need later on *)
  containerObjectFields = {Name, Positions, Model, Contents};
  containerObjectPacketFields = Packet@@containerObjectFields;
  containerModelFields = {Name, Positions, NumberOfWells, Type, MaxVolume};
  containerModelPacketFields = Packet@@containerModelFields;

  (* Download to make our container packets *)
  {
    containerModelPackets,
    containerModelFromObjectPackets
  } = Quiet[
    Download[
      {
        DeleteDuplicates@Flatten[{
          Cases[
            Flatten[listedContainers],
            ObjectP[Model[Container]]
          ],
          PreferredContainer[All, Join[{Type -> All}, preferredContainerOptions]]
        }],
        DeleteDuplicates@Cases[
          Flatten[listedContainers],
          ObjectP[Object[Container]]
        ]
      },
      {
        {containerModelPacketFields},
        {containerObjectPacketFields, Packet[Model[containerModelFields]]}
      }
    ],
    {Download::FieldDoesntExist,Download::NotLinkField}
  ];

  (* Flatten and make cacheBall and fastAssoc *)
  {containerModelPackets, containerModelFromObjectPackets} = Flatten /@ {containerModelPackets, containerModelFromObjectPackets};
  cacheBall = FlattenCachePackets[{cache, containerModelPackets, containerModelFromObjectPackets}];
  fastAssoc = makeFastAssocFromCache[cacheBall];

  (* Check for any cases in which an indexed vessel (not plate) is given but number of replicates is greater than 1. *)
  (* In these cases, we need to remove the indices from these vessels to avoid aliquoting multiple experiments into the *)
  (* same tube. We also throw a warning to let the user know. *)
  mustRemoveContainerIndicesCases = MapThread[
    Function[
      {container, index},
      If[
        MatchQ[container, {_Integer, ObjectP[Model[Container, Vessel]]}] && MatchQ[numberOfReplicates, GreaterP[1]],
        {container, numberOfReplicates, index},
        Nothing
      ]
    ],
    {listedContainers, Range[Length[listedContainers]]}
  ];

  If[MatchQ[Length[mustRemoveContainerIndicesCases], GreaterP[0]],
    Message[
      Warning::MustRemoveContainerIndices,
      mustRemoveContainerIndicesCases[[All,1]],
      mustRemoveContainerIndicesCases[[All,2]],
      mustRemoveContainerIndicesCases[[All,3]]
    ];
  ];

  (* Check for any cases in which the container is set to Null at the same index where PackPlateQ is True. *)
  packNullContainerCases = MapThread[
    Function[
      {container, packPlateQ, index},
      If[
        MatchQ[container, Null] && MatchQ[packPlateQ, True],
        {index},
        Nothing
      ]
    ],
    {listedContainers, listedPackPlateQs, Range[Length[listedContainers]]}
  ];

  If[MatchQ[Length[packNullContainerCases], GreaterP[0]],
    Message[
      Warning::PackNullContainer,
      packNullContainerCases[[All,1]]
    ];
  ];

  (* Check for any cases in which the required container volume is set to Null at the same index where PackPlateQ is True and the container is Automatic. *)
  unknownRequiredContainerVolumeCases = MapThread[
    Function[
      {container, packPlateQ, requiredVolume, index},
      If[
        MatchQ[container, Automatic] && MatchQ[packPlateQ, True] && MatchQ[requiredVolume, Null],
        {index},
        Nothing
      ]
    ],
    {listedContainers, listedPackPlateQs, listedRequiredContainerVolumes, Range[Length[listedContainers]]}
  ];

  If[MatchQ[Length[unknownRequiredContainerVolumeCases], GreaterP[0]],
    Message[
      Warning::UnknownRequiredContainerVolume,
      unknownRequiredContainerVolumeCases[[All,1]]
    ];
  ];

  (* Split our container inputs into containers (with or without indices) and wells *)
  containersWithWellsRemoved = Map[
    Function[{index},
      Which[
        (* If the user specified the container using the "Container with Well" widget format, remove the well. *)
        MatchQ[index, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Model[Container]}]}],
          Last[index],
        (* If the user specified the container using the "Container with Well and Index" widget format, remove the well. *)
        MatchQ[index, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Model[Container]}]}}],
          Last[index],
        (* If the user specified the container any other way, we don't have to mess with it here. *)
        True,
          index
      ]
    ], listedContainers
  ];

  wellsFromContainers = Map[
    Function[{index},
      Which[
        (* If the user specified the container using the "Container with Well" widget format, extract the well. *)
        MatchQ[index, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[{Model[Container]}]}],
          First[index],
        (* If the user specified the container using the "Container with Well and Index" widget format, extract the well. *)
        MatchQ[index, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[{Model[Container]}]}}],
          First[index],
        (* Otherwise, there isn't a well specified and we set this to automatic. *)
        True,
          Automatic
      ]
    ], listedContainers
  ];

  (* Check for any cases in which the well/position is already specified at an index where PackPlateQ is True. *)
  potentialOverwritePositionCases = MapThread[
    Function[
      {well, packPlateQ, index},
      If[
        MatchQ[well, Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]]] && MatchQ[packPlateQ, True],
        {well, index},
        Nothing
      ]
    ],
    {wellsFromContainers, listedPackPlateQs, Range[Length[listedContainers]]}
  ];

  If[MatchQ[Length[potentialOverwritePositionCases], GreaterP[0]],
    Message[
      Warning::AvoidOverwritingWellPosition,
      potentialOverwritePositionCases[[All,1]],
      potentialOverwritePositionCases[[All,2]]
    ];
  ];

  (* Sanitize the RequiredContainerVolume list by replacing any Nulls with the maxVolume of the given container model if we *)
  (* have one at that index, and if PackPlateQ at that index is True. *)
  listedSanitizedRequiredContainerVolumes = MapThread[
    Function[{requiredVolume, container, packPlateQ},
      Which[
        (* If there's a known container model at this index, use its MaxVolume *)
        And[
          MatchQ[container, ObjectP[Model[Container]]],
          MatchQ[requiredVolume, Null],
          MatchQ[packPlateQ, True]
        ],
          Lookup[fetchModelPacketFromFastAssoc[container, fastAssoc], MaxVolume],
        (* If there's a known container model with a container index at this index, use its MaxVolume *)
        And[
          MatchQ[container, {_Integer, ObjectP[Model[Container]]}],
          MatchQ[requiredVolume, Null],
          MatchQ[packPlateQ, True]
        ],
          Lookup[fetchModelPacketFromFastAssoc[Last[container], fastAssoc], MaxVolume],
        (* If there's a specific container object at this index, use its MaxVolume *)
        And[
          MatchQ[container, ObjectP[Object[Container]]],
          MatchQ[requiredVolume, Null],
          MatchQ[packPlateQ, True]
        ],
          Lookup[fetchModelPacketFromFastAssoc[container, fastAssoc], MaxVolume],
        (* Otherwise, keep the required volume as is *)
        True,
          requiredVolume
      ]
    ],
    {listedRequiredContainerVolumes, containersWithWellsRemoved, listedPackPlateQs}
  ];

  (* Sanitize the PackPlateQ list by setting it to False at: a) any index where the container is set to Null, *)
  (* b) any index at which the container is set to Automatic but there is no required container volume, or  *)
  (* c) any index at which a well and a specific plate are already specified *)
  listedSanitizedPackPlateQs = MapThread[
    Function[{packPlateQ, container, requiredVolume},
      Which[
        (* If the container is set to Null, PackPlateQ must be False *)
        MatchQ[container, Null],
          False,
        (* If the container is set to any container model that is not a plate, set PackPlateQ to False *)
        And[
          MemberQ[ToList[container], ObjectP[Model[Container]]],
          !MemberQ[ToList[container], ObjectP[Model[Container, Plate]]]
        ],
          False,
        (* If the container is set to a specific container object, set PackPlateQ to False *)
        MatchQ[container, ObjectP[Object[Container]]],
          False,
        (* If the container is Automatic and there is no required container volume, set PackPlateQ to False *)
        MatchQ[container, Automatic] && MatchQ[requiredVolume, Null],
          False,
        (* If the well and a container are specified at this index, set PackPlateQ to False *)
        MemberQ[container, Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]]],
          False,
        (* In any other case, we don't adjust PackPlateQ *)
        True,
          packPlateQ
      ]
    ],
    {listedPackPlateQs, listedContainers, listedRequiredContainerVolumes}
  ];

  (* Expand containers, required container volumes and PackPlateQ according to the number of replicates  *)
  {
    expandedContainersWithWellsRemoved,
    expandedRequiredContainerVolumes,
    expandedPackPlateQs
  } = Map[
    Flatten[
      Map[
        Function[{indexMatchedItem},
          ConstantArray[indexMatchedItem, numberOfReplicates]
        ],
        #
      ], 1 (* We flatten at level 1 to preserve any options whose input is a list; e.g. from container options or adders *)
    ]&,
    {
      containersWithWellsRemoved,
      listedSanitizedRequiredContainerVolumes,
      listedSanitizedPackPlateQs
    }
  ];

  (* Expand wells to make the replicated wells Automatic while leaving the "original" wells as specified by the user *)
  expandedWellsFromContainers = Flatten[PadRight[{#}, numberOfReplicates, Automatic] & /@ wellsFromContainers];

  (* Expand all the parameters with which we will group the samples *)
  expandedParametersToGroupBy = Map[
    Flatten[
      Map[
        Function[{indexMatchedItem},
          ConstantArray[indexMatchedItem, numberOfReplicates]
        ],
        #
      ], 1 (* We flatten at level 1 to preserve any options whose input is a list; e.g. from container options or adders *)
    ]&, parametersAsListOfLists
  ];

  (* Get all the experiment conditions which will be the criteria by which we group samples into containers *)
  (* Also, replace any temperature matching AmbientTemperatureP with $AmbientTemperature to avoid grouping (e.g.) 25 Celsius and Ambient separately *)
  parametersListsWithoutPreferredContainer = (PickList[#, expandedPackPlateQs, True] & /@ expandedParametersToGroupBy) /. AmbientTemperatureP -> $AmbientTemperature;

  (* Determine the containers for each sample-to-be-packed according to volume required and whether a container model was already specified *)
  preferredContainers = Cases[
    MapThread[
      Function[{packPlateQ, container, requiredVolume},
        Which[
          (* If packPlateQ is False at this index, set the container to Null and get rid of it with the Cases call *)
          (* Note: fewer Which[] clauses are needed here because many scenarios are already accounted for; see listedSanitizedPackPlateQs above *)
          MatchQ[packPlateQ, False],
            Null,
          (* If a container model is specified, use this as the preferred container model *)
          MemberQ[ToList[container], ObjectP[Model[Container]]],
            FirstCase[ToList[container], ObjectP[Model[Container]]],
          (* Otherwise, use PreferredContainer to find an appropriate plate *)
          True,
            PreferredContainer[requiredVolume, Join[preferredContainerOptions, {Type -> Plate}]]
        ]
      ],
      {expandedPackPlateQs, expandedContainersWithWellsRemoved, expandedRequiredContainerVolumes}
    ],
    Except[Null]
  ];

  (* Add preferred containers to the parameters list and transpose to get the complete set of parameters for each sample *)
  parametersForSamplesToPreResolve = Transpose @ Join[parametersListsWithoutPreferredContainer, {preferredContainers}];

  (* Get the indices at which we need to resolve/pack the containers *)
  plateRequiredSampleIndices = Flatten @ Position[expandedPackPlateQs, True];

  (* Group the indices for which PackPlateQ is True by their relevant conditions and preferred container models *)
  groupedPreResolvedIndicesAndParameters = GroupBy[
    Transpose[{plateRequiredSampleIndices, parametersForSamplesToPreResolve}],
    Last
  ];

  (* Remove the conditions/parameter info from the previous list to get lists of indices which can be grouped together *)
  preResolvedIndexGroups = Values[groupedPreResolvedIndicesAndParameters][[All, All, 1]];

  (* Partition each of the resolved sample groups into groups of AT MOST the number of wells in the preferred container model *)
  {partitionedPreferredContainerModels, partitionedPreResolvedIndexGroups} = Module[
    {representativeIndicesP, indexAndContainerTuples, indexToContainerModelLookup, simplifiedIndexAndContainerTuples, maxWells, newIndexGroups},
    (* Define a pattern which contains the first index for each of the resolved index groups *)
    representativeIndicesP = preResolvedIndexGroups[[All,1]];
    (* Flatten the index list and transpose this with the preferredContainers list *)
    indexAndContainerTuples = Transpose[{Flatten[preResolvedIndexGroups], preferredContainers}];
    (* Make a lookup between index and container model *)
    indexToContainerModelLookup = GroupBy[indexAndContainerTuples, First];
    (* Get the tuples whose indices are first in each of the preResolvedIndexGroups *)
    simplifiedIndexAndContainerTuples = Cases[indexAndContainerTuples, {Alternatives @@ representativeIndicesP, ObjectP[Model[Container]]}];
    (* Get the number of wells for each of the remaining container models *)
    maxWells = Length[Lookup[fetchModelPacketFromFastAssoc[#, fastAssoc], Positions]] & /@ (simplifiedIndexAndContainerTuples[[All,2]]);
    (* Partition the index groups by UpTo the number of wells for the relevant container *)
    newIndexGroups = MapThread[
      Function[{indexGroup, numberOfWells},
        Sequence @@ Partition[indexGroup, UpTo[numberOfWells]]
      ],
      {preResolvedIndexGroups, maxWells}
    ];
    (* Get the container models associated with the first index of each index group *)
    {Cases[Flatten @ Lookup[indexToContainerModelLookup, (First /@ newIndexGroups)], ObjectP[Model, Container]], newIndexGroups}
  ];

  (* Get any user-specified wells and all container information associated with them *)
  userSpecifiedPlateWells = wellsFromContainers /. {Automatic -> Null};
  specifiedWellAndContainerPairings = Cases[Transpose[{userSpecifiedPlateWells, containersWithWellsRemoved}], {Except[Null], _}];

  (* Generate a lookup associating any user-specified wells with their associated plates and indices *)
  containerToSpecifiedWellLookup = GroupBy[specifiedWellAndContainerPairings, Last -> First];

  (* Make sure that all of the samples that have to be centrifuged will be packed into DWPs efficiently, column wise. *)
  (* i.e., wells pack in the order A1, B1, C1, D1 ... rather than A1, A2, A3, A4 ... *)
  (* This is preferred because the multichannel micropipetters on the liquid handler instruments are oriented this way. *)
  {plateRequiredContainers, plateRequiredContainerWells} = If[Length[plateRequiredSampleIndices] > 0,
    Transpose@MapThread[
      Function[{partitionedIndices, index, containerModel},
        Sequence@@(
          (
            {
              {firstNewContainerIndex + index - 1, containerModel},
              (* Here, we have to skip any wells that are already specified for a given container *)
              Cases[
                Flatten[Transpose[AllWells[]]],
                Except[Alternatives @@ Lookup[containerToSpecifiedWellLookup, Key[{firstNewContainerIndex + index - 1, containerModel}]]]
              ][[#]]
            }
                &)/@Range[Length[partitionedIndices]]
        )
      ],
      {
        partitionedPreResolvedIndexGroups,
        Range[Length[partitionedPreResolvedIndexGroups]],
        partitionedPreferredContainerModels
      }
    ],
    {{}, {}}
  ];

  semiResolvedContainers = ReplacePart[
    expandedContainersWithWellsRemoved,
    Rule@@@Transpose[{
      Flatten[partitionedPreResolvedIndexGroups],
      plateRequiredContainers
    }]
  ];

  semiResolvedContainerWells = ReplacePart[
    expandedWellsFromContainers,
    Rule@@@Transpose[{
      Flatten[partitionedPreResolvedIndexGroups],
      plateRequiredContainerWells
    }]
  ];

  (* Set up a lookup that will allow us to find unoccupied wells within a container *)
  containerToAvailableWellsLookup = Module[
    {groupedContainersToWells},
    (* Find the wells of each container we are given *)
    groupedContainersToWells = GroupBy[Transpose[{semiResolvedContainers, semiResolvedContainerWells}], First -> Last];

    Association @ KeyValueMap[
      Function[{container, specifiedWells},
        Which[
          MatchQ[container, ObjectP[Object[Container]]],
            Module[{allWells, transposedWells, occupiedWells, specifiedWellsNoAutomatic},
              (* Remove all of the Automatics *)
              specifiedWellsNoAutomatic = Cases[specifiedWells, Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]]];
              (* Get all the wells of the container *)
              allWells = Lookup[Lookup[fetchModelPacketFromFastAssoc[container, fastAssoc], Positions], Name];
              (* Transpose the wells so that we occupy them column-wise *)
              transposedWells = If[
                MatchQ[allWells, Flatten[AllWells[]]],
                Flatten[Transpose[AllWells[]]],
                allWells
              ];

              occupiedWells = Lookup[fetchPacketFromFastAssoc[container, fastAssoc], Contents][[All,1]];

              container -> UnsortedComplement[transposedWells, Join[occupiedWells, specifiedWellsNoAutomatic]]
            ],
          MatchQ[container, {_Integer, ObjectP[Model[Container]]}],
            Module[{allWells, transposedWells, specifiedWellsNoAutomatic},
              (* Remove all of the Automatics *)
              specifiedWellsNoAutomatic = Cases[specifiedWells, Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]]];
              (* Get all the wells of the container *)
              allWells = Lookup[Lookup[fetchPacketFromFastAssoc[container[[2]], fastAssoc], Positions], Name];
              (* Transpose the wells so that we occupy them column-wise *)
              transposedWells = If[
                MatchQ[allWells, Flatten[AllWells[]]],
                Flatten[Transpose[AllWells[]]],
                allWells
              ];

              container -> UnsortedComplement[transposedWells, specifiedWellsNoAutomatic]
            ],
          True,
            Nothing
        ]
      ],
      groupedContainersToWells
    ]
  ];

  (* Resolve any other cases *)
  {resolvedContainers, resolvedContainerWells} = Transpose @ MapThread[
    Function[{container, containerWell, requiredContainerVolume},
      Which[
        (* If a tube with an index is selected and number of replicates is not Null, remove the index so that we don't transfer multiple times into the same tube. *)
        (* Also, throw a warning to tell the user that the indices are being wiped out for their own good. *)
        MatchQ[container, {_Integer, ObjectP[Model[Container, Vessel]]}] && MatchQ[numberOfReplicates, GreaterP[1]],
          {FirstCase[container, ObjectP[]], "A1"},
        (* If the container and well are both specified, use the specified Container and Well *)
        MatchQ[container, Except[Automatic]] && MatchQ[containerWell, Except[Automatic]],
          {container, containerWell},
        (* If the container is set to Null, set both to Null *)
        MatchQ[container, Null],
          {Null, Null},
        (* If the container is set to Automatic and there's no required volume, set both to Null *)
        MatchQ[container, Automatic] && MatchQ[requiredContainerVolume, Null],
          {Null, Null},
        (* If the user specifies a new container, default to well "A1". *)
        MatchQ[container, ObjectP[Model[Container]]],
          {container, "A1"},
        (* If the user specifies a container but not a well, find the next available well using the lookup *)
        MatchQ[container, Except[Automatic]] && MatchQ[containerWell, Automatic],
          Module[{availableWells},
            (* Get the available wells. *)
            availableWells = Lookup[containerToAvailableWellsLookup, Key[container]];

            (* Update the lookup, if there are no longer any wells left, use the standard well list. *)
            containerToAvailableWellsLookup[container] = RestOrDefault[availableWells, Flatten[Transpose[AllWells[]]]];

            {container, FirstOrDefault[availableWells, "A1"]}
          ],
        (* If the container still isn't resolved, find a suitable vessel using PreferredContainer. *)
        True,
         {
           PreferredContainer[requiredContainerVolume, preferredContainerOptions],
           "A1"
         }
      ]
    ],
    {
      semiResolvedContainers,
      semiResolvedContainerWells,
      expandedRequiredContainerVolumes
    }
  ];

  (* Check for any cases in which we resolve to the same container, index, and position for different experiments *)
  (* Throw a warning in this case. *)
  packIntoSameContainerPositionCases = Module[
    {containerWellPairings, uniqueContainerWellPairingCounts},

    (* Transpose the pairings of resolved containers and wells *)
    containerWellPairings = Transpose[{resolvedContainers, resolvedContainerWells}];

    (* Replace this list with the number of instances of each unique container well pairing *)
    uniqueContainerWellPairingCounts = containerWellPairings /. Counts[containerWellPairings];

    (* Now get any cases in which the count is greater than 1 and the container either has an index or is a specific container object *)
    MapThread[
      Function[{container, well, pairingCounts, index},
        If[
          And[
            MatchQ[pairingCounts, GreaterP[1]],
            Or[
              MatchQ[container, {_Integer, ObjectP[Model[Container]]}],
              MatchQ[container, ObjectP[Object[Container]]]
            ]
          ],
          {container, well, pairingCounts, index},
          Nothing
        ]
      ],
      {resolvedContainers, resolvedContainerWells, uniqueContainerWellPairingCounts, Range[Length[containerWellPairings]]}
    ]
  ];

  If[MatchQ[Length[packIntoSameContainerPositionCases], GreaterP[0]],
    Message[
      Warning::PackIntoSameContainerPosition,
      packIntoSameContainerPositionCases[[All,1]],
      packIntoSameContainerPositionCases[[All,2]],
      packIntoSameContainerPositionCases[[All,3]],
      packIntoSameContainerPositionCases[[All,4]]
    ];
  ];

  {resolvedContainers, resolvedContainerWells}
];


(* ::Subsection:: *)
(* AliquotIntoPlateQ *)


AliquotIntoPlateQ[
  myAliquotContainers:(ListableP[Alternatives[Null, Automatic, ObjectP[{Object[Container], Model[Container]}], {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], ObjectP[Model[Container]]}, {GreaterEqualP[1, 1], ObjectP[Model[Container]]}, {Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]], {GreaterEqualP[1, 1], ObjectP[Model[Container]]}}]]),
  myResolvedAliquotBooleans:ListableP[BooleanP],
  myResolvedCentrifugeBooleans:ListableP[ListableP[Null|BooleanP]],
  myResolvedMixTypes:ListableP[ListableP[Null|None|MixTypeP]],
  myResolvedTemperatures:ListableP[ListableP[Null|Ambient|TemperatureP]]
] := Module[
  {centrifugeBools, mixTypes, temperatures, plateRequiredSampleIndices},

  (* Make sure that the centrifuge booleans, mix types, and temperatures are lists of lists *)
  centrifugeBools = If[MatchQ[myResolvedCentrifugeBooleans, {BooleanP..}],
    {myResolvedCentrifugeBooleans},
    myResolvedCentrifugeBooleans
  ];

  mixTypes = If[MatchQ[myResolvedMixTypes, {(None|MixTypeP)..}],
    {myResolvedMixTypes},
    myResolvedMixTypes
  ];

  temperatures = If[MatchQ[myResolvedTemperatures, {(TemperatureP|Ambient)..}],
    {myResolvedTemperatures},
    myResolvedTemperatures
  ];

  (* Get the samples for which AliquotContainer is not specified and for which we have to centrifuge, shake, or heat/cool. *)
  plateRequiredSampleIndices = Flatten @ Position[
    Transpose[
      {
        myAliquotContainers,
        myResolvedAliquotBooleans,
        If[MatchQ[myResolvedCentrifugeBooleans, Null], ConstantArray[False, Length[myResolvedAliquotBooleans]], MemberQ[#, True] & /@ Transpose[centrifugeBools]],
        If[MatchQ[myResolvedMixTypes, Null], ConstantArray[False, Length[myResolvedAliquotBooleans]], MemberQ[#, Shake] & /@ Transpose[mixTypes]],
        If[MatchQ[myResolvedTemperatures, Null], ConstantArray[False, Length[myResolvedAliquotBooleans]], MemberQ[#, Except[AmbientTemperatureP|Null]] & /@ Transpose[temperatures]]
      }
    ],
    Alternatives[
      {
        Automatic,
        True,
        True,
        _,
        _
      },
      {
        Automatic,
        True,
        _,
        True,
        _
      },
      {
        Automatic,
        True,
        _,
        _,
        True
      }
    ]
  ];

  (* Generate a list with the same length as my aliquot containers, which is True for indices at which plates are needed and False elsewhere. *)
  ReplacePart[
    ConstantArray[False, Length[myAliquotContainers]],
    # -> True & /@ plateRequiredSampleIndices
  ]

];