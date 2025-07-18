DefineTests[
  resolveLabelContainerPrimitive,
  {
    Example[
      {Basic,"Basic request for an Object[Container] and Model[Container]:"},
      resolveLabelContainerPrimitive[
        {"best container ever", "best container ever 2"},
        {
          Container -> {
            Object[Container,Vessel,"Test container 1 for resolveLabelContainerPrimitive"<>$SessionUUID],
            Model[Container, Vessel, "50mL Tube"]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Container -> {
            ObjectP[Object[Container,Vessel,"Test container 1 for resolveLabelContainerPrimitive"<>$SessionUUID]],
            ObjectP[Model[Container, Vessel, "50mL Tube"]]
          }
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[{Additional, "When simulating Model[Container], does not simulate its cover:"},
      simulation = resolveLabelContainerPrimitive[
        {"one container tube"},
        {
          Container -> {
            Model[Container, Vessel, "50mL Tube"]
          },
          Output -> Simulation
        }
      ];
      Lookup[Cases[Flatten@Values@simulation[[-1]], PacketP[Object[Container, Vessel]]], Cover],
      {Except[ObjectP[]]..},
      Variables :> {simulation}
    ],
    Test[
      {Message,"LabelContainerDiscarded","Throws an error if pointing to a discarded container:"},
      resolveLabelContainerPrimitive[
        {"best container ever", "best container ever 2"},
        {
          Container -> {
            Object[Container,Vessel,"Test container 2 for resolveLabelContainerPrimitive"<>$SessionUUID],
            Model[Container, Vessel, "50mL Tube"]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Container -> {
            ObjectP[Object[Container,Vessel,"Test container 1 for resolveLabelContainerPrimitive"<>$SessionUUID]],
            ObjectP[Model[Container, Vessel, "50mL Tube"]]
          }
        }],
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::LabelContainerDiscarded,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      resolveLabelContainerPrimitive[
        {"best container ever", "best container ever 2"},
        {
          Container -> {
            Object[Container,Vessel,"Nonexistent container"],
            Model[Container, Vessel, "50mL Tube"]
          }
        }
      ],
      $Failed,
      Messages :> {
        Download::ObjectDoesNotExist
      }
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      resolveLabelContainerPrimitive[
        {"best container ever", "best container ever 2"},
        {
          Container -> {
            Object[Container,Vessel,"id:123456"],
            Model[Container, Vessel, "50mL Tube"]
          }
        }
      ],
      $Failed,
      Messages :> {
        Download::ObjectDoesNotExist
      }
    ]
  },
  SymbolSetUp:>(
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Container,Vessel,"Test container 1 for resolveLabelContainerPrimitive"<>$SessionUUID],
      Object[Container,Vessel,"Test container 2 for resolveLabelContainerPrimitive"<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Container,Vessel,"Test container 1 for resolveLabelContainerPrimitive"<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for resolveLabelContainerPrimitive"<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    (* Create some empty containers *)
    {emptyContainer1,emptyContainer2}=Upload[{
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
        Name->"Test container 1 for resolveLabelContainerPrimitive"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
        Name->"Test container 2 for resolveLabelContainerPrimitive"<>$SessionUUID,
        Status->Discarded,
        DeveloperObject->True
      |>
    }];
  ),
  SymbolTearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $Notebook = Object[LaboratoryNotebook, "Wyatt Scratch"]
  }
];




DefineTests[
  LabelContainer,
  {
    Example[
      {Basic, "Basic request for an Object[Container] and Model[Container]:"},
      Experiment[{
        LabelContainer[
          Container -> {
            Object[Container, Vessel, "Test container 1 for LabelContainer"],
            Model[Container, Vessel, "50mL Tube"]
          },
          Label -> {"best container ever", "best container ever 2"}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"best container ever", "best container ever 2"},
          Amount -> 2 Milliliter
        ]
      }],
      ObjectP[Object[Protocol]]
    ],
    Test[
      {Message, "LabelContainerDiscarded", "Throws an error if pointing to a discarded container:"},
      Experiment[{
        LabelContainer[
          Container -> {
            Object[Container, Vessel, "Test container 2 for LabelContainer"],
            Model[Container, Vessel, "50mL Tube"]
          },
          Label -> {"best container ever", "best container ever 2"}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"best container ever", "best container ever 2"},
          Amount -> 2 Milliliter
        ]
      }],
      $Failed,
      Messages :> {
        Error::LabelContainerDiscarded,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      Experiment[{
        LabelContainer[
          Container -> {
            Object[Container, Vessel, "Nonexistent container"],
            Model[Container, Vessel, "50mL Tube"]
          },
          Label -> {"best container ever", "best container ever 2"}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"best container ever", "best container ever 2"},
          Amount -> 2 Milliliter
        ]
      }],
      $Failed,
      Messages :> {
        Download::ObjectDoesNotExist
      }
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      Experiment[{
        LabelContainer[
          Container -> {
            Object[Container, Vessel, "id:123456"],
            Model[Container, Vessel, "50mL Tube"]
          },
          Label -> {"best container ever", "best container ever 2"}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"best container ever", "best container ever 2"},
          Amount -> 2 Milliliter
        ]
      }],
      $Failed,
      Messages :> {
        Download::ObjectDoesNotExist
      }
    ]
  },
  SymbolSetUp :> (
    $CreatedObjects = {};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter = DatabaseMemberQ[{
      Object[Container, Vessel, "Test container 1 for LabelContainer"],
      Object[Container, Vessel, "Test container 2 for LabelContainer"]
    }];

    EraseObject[
      PickList[
        {
          Object[Container, Vessel, "Test container 1 for LabelContainer"],
          Object[Container, Vessel, "Test container 2 for LabelContainer"]
        },
        existsFilter
      ],
      Force -> True,
      Verbose -> False
    ];

    (* Create some empty containers *)
    {emptyContainer1, emptyContainer2} = Upload[{
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test container 1 for LabelContainer",
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "Test container 2 for LabelContainer",
        Status -> Discarded,
        DeveloperObject -> True
      |>
    }];
  ),
  SymbolTearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];