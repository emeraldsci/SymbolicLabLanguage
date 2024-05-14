DefineTests[
  resolveLabelContainerPrimitive,
  {
    Example[
      {Basic,"Basic request for an Object[Container] and Model[Container]:"},
      resolveLabelContainerPrimitive[
        {"best container ever", "best container ever 2"},
        {
          Container -> {
            Object[Container,Vessel,"Test container 1 for LabelContainer"],
            Model[Container, Vessel, "50mL Tube"]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Container -> {
            ObjectP[Object[Container,Vessel,"Test container 1 for LabelContainer"]],
            ObjectP[Model[Container, Vessel, "50mL Tube"]]
          }
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Test[
      {Message,"LabelContainerDiscarded","Throws an error if pointing to a discarded container:"},
      resolveLabelContainerPrimitive[
        {"best container ever", "best container ever 2"},
        {
          Container -> {
            Object[Container,Vessel,"Test container 2 for LabelContainer"],
            Model[Container, Vessel, "50mL Tube"]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Container -> {
            ObjectP[Object[Container,Vessel,"Test container 1 for LabelContainer"]],
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
    ]
  },
  SymbolSetUp:>(
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Container,Vessel,"Test container 1 for LabelContainer"],
      Object[Container,Vessel,"Test container 2 for LabelContainer"]
    }];

    EraseObject[
      PickList[
        {
          Object[Container,Vessel,"Test container 1 for LabelContainer"],
          Object[Container,Vessel,"Test container 2 for LabelContainer"]
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
        Name->"Test container 1 for LabelContainer",
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
        Name->"Test container 2 for LabelContainer",
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
]