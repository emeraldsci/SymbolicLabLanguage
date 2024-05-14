DefineTests[
  resolveLabelSamplePrimitive,
  {
    Example[
      {Basic,"Resolve a basic sample request for an Object[Sample]:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Object[Sample, "Test water sample in 50mL tube for LabelSample 3 "<>$SessionUUID],
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {ObjectP[Object[Sample, "Test water sample in 50mL tube for LabelSample 3 "<>$SessionUUID]]},
          Container -> {ObjectP[Object[Container]]},
          Well -> {"A1"}
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"Set the storage condition for an Object[Sample]:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Object[Sample, "Test water sample in 50mL tube for LabelSample 3 "<>$SessionUUID],
          StorageCondition -> AmbientStorage,
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {ObjectP[Object[Sample, "Test water sample in 50mL tube for LabelSample 3 "<>$SessionUUID]]},
          Container -> {ObjectP[Object[Container]]},
          Well -> {"A1"}
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Test[
      "Internally calls UploadStorageCondition to make sure there aren't any conflicting storage condition issues:",
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Object[Sample, "Test water sample 1 in DWP for LabelSample "<>$SessionUUID],
          StorageCondition -> Freezer,
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {Object[Sample, "Test water sample 1 in DWP for LabelSample "<>$SessionUUID]},
          Container -> {ObjectP[Object[Container]]},
          Well -> {"A1"}
        }],
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::ConflictingConditionsInContainer,
        Error::InvalidOption
      }
    ],
    Example[
      {Basic,"Resolve a basic sample request for a Model[Sample]:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Amount -> 10 Milliliter,
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {ObjectP[Model[Sample, "Milli-Q water"]]},
          Container -> {ObjectP[Model[Container]]},
          Well -> {"A1"}
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"ExactAmount option resolves to False if the Amount option is not specified:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Object[Sample, "Test water sample in 50mL tube for LabelSample 2 "<>$SessionUUID],
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {ObjectP[Object[Sample, "Test water sample in 50mL tube for LabelSample 2 "<>$SessionUUID]]},
          Container -> {ObjectP[Object[Container]]},
          Well -> {"A1"},
          ExactAmount -> {False},
          Tolerance -> {Null}
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"ExactAmount option resolves to False if the Amount option is not specified 2:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {ObjectP[Model[Sample, "Milli-Q water"]]},
          Container -> {ObjectP[Model[Container]]},
          Well -> {"A1"},
          Amount -> {Quantity[10, "Milliliters"]},
          ExactAmount -> {False},
          Tolerance -> {Null}
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"ExactAmount option resolves to True if the Amount option is specified:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Amount -> 10 Milliliter,
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {ObjectP[Model[Sample, "Milli-Q water"]]},
          Container -> {ObjectP[Model[Container]]},
          Well -> {"A1"},
          Amount -> {Quantity[10, "Milliliters"]},
          ExactAmount -> {True},
          Tolerance -> {VolumeP}
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"Set the Tolerance option to a percent:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Tolerance -> 1 Percent,
          Amount -> 1 Milliliter,
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {ObjectP[Model[Sample, "Milli-Q water"]]},
          Container -> {ObjectP[Model[Container]]},
          Well -> {"A1"},
          ExactAmount -> {True},
          Tolerance -> {1 Percent}
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"Resolve a basic sample request, given other primitives:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {ObjectP[Model[Sample, "Milli-Q water"]]},
          Container -> {ObjectP[Model[Container]]},
          Well -> {"A1"},
          Amount -> {Quantity[10, "Milliliters"]}
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"Resolve a basic sample request, with some safety overrides. This should simulate the safety changes and pass them down in the simulation:"},
      Module[{simulation},
        simulation=resolveLabelSamplePrimitive[
          {"best sample ever"},
          {
            Sample -> Model[Sample, "Milli-Q water"],
            SampleModel -> Model[Sample, "Methanol"],
            Expires -> False,
            Primitives->{
              Transfer[
                Source->{"best sample ever", "best sample ever"},
                Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
                Amount->{5 Milliliter, 5 Milliliter}
              ]
            },
            Output -> {Options, Simulation, Tests, Result}
          }
        ][[2]];

        Download[Lookup[Lookup[simulation[[1]], Labels], "best sample ever"], Model, Simulation->simulation]
      ],
      ObjectP[Model[Sample, "Methanol"]]
    ],
    Example[
      {Basic,"Resolve a label request for a few Object[Sample]s:"},
      resolveLabelSamplePrimitive[
        {"best sample ever", "best sample ever 2"},
        {
          Sample -> {
            Object[Sample,"Test water sample in 50mL tube for LabelSample "<>$SessionUUID],
            Object[Sample,"Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID]
          },
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever 2"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation,Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {
            ObjectP[Object[Sample, "Test water sample in 50mL tube for LabelSample "<>$SessionUUID]],
            ObjectP[Object[Sample, "Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID]]
          },
          Container -> {
            ObjectP[Object[Sample, "Test water sample in 50mL tube for LabelSample "<>$SessionUUID][Container]],
            ObjectP[Object[Sample, "Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID][Container]]
          },
          Well -> {"A1", "A1"},
          ContainerLabel -> {Null, Null},
          Amount -> {
            Null,
            Null
          }
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"Resolve a label request using {Object[Container], WellPositionP} syntax:"},
      resolveLabelSamplePrimitive[
        {"best sample ever", "best sample ever 2"},
        {
          Sample -> {
            {"A1",Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID]},
            Object[Sample,"Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID]
          },
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever 2"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {
            {"A1",ObjectP[Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID]]},
            ObjectP[Object[Sample, "Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID]]
          },
          Container -> {
            ObjectP[Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID]],
            ObjectP[Object[Sample, "Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID][Container]]
          },
          Well -> {"A1", "A1"},
          ContainerLabel -> {Null, Null},
          Amount -> {
            Null,
            Null
          }
        }],
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"Make sure that we can request counted samples 1:"},
      resolveLabelSamplePrimitive[
        {"best sample ever", "best sample ever 2"},
        {
          Sample -> {
            Object[Sample,"Test tablet sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
            Model[Sample, "Ibuprofen tablets 500 Count"]
          },
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever 2"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5, 10}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"Make sure that we can request counted samples 2:"},
      resolveLabelSamplePrimitive[
        {"best sample ever", "best sample ever 2"},
        {
          Sample -> {
            Object[Sample,"Test tablet sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
            Model[Sample, "Ibuprofen tablets 500 Count"]
          },
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever 2"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5, 10}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      }
    ],
    Example[
      {Basic,"Make sure that the ContainerLabel option works:"},
      resolveLabelSamplePrimitive[
        {"best sample ever", "best sample ever 2", "best sample ever 3"},
        {
          Sample -> {
            {"A1",Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID]},
            Object[Sample,"Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
            Model[Sample, "Milli-Q water"]
          },
          Amount -> {Automatic, Automatic, 1 Liter},
          ContainerLabel->{"best container ever", "best container ever 2", "best container ever 3"},
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever 2"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{1 Milliliter, 2 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        KeyValuePattern[{
          Sample -> {
            {"A1",ObjectP[Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID]]},
            ObjectP[Object[Sample,"Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID]],
            ObjectP[Model[Sample, "Milli-Q water"]]
          },
          Amount -> {Null, Null, Quantity[1, "Liters"]},
          Container -> {
            ObjectP[Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID]],
            ObjectP[Object[Sample,"Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID][Container]],
            ObjectP[Model[Container]]
          },
          ContainerLabel->{"best container ever", "best container ever 2", "best container ever 3"}
        }],
        (* NOTE: Make sure that all of our sample and container labels are being returned back. *)
        SimulationP?(
          MatchQ[
            Lookup[#[[1]], Labels],
            KeyValuePattern[{
              "best sample ever"->ObjectP[Object[Sample]],
              "best sample ever 2"->ObjectP[Object[Sample]],
              "best sample ever 3"->ObjectP[Object[Sample]],
              "best container ever"->ObjectP[Object[Container]],
              "best container ever 2"->ObjectP[Object[Container]],
              "best container ever 3"->ObjectP[Object[Container]]
            }]
          ]
        &),
        PacketP[]
      }
    ],
    Example[
      {Messages,"ExactNullAmount","If ExactAmount is set to True, Amount must be specified:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> {
            Model[Sample, "Methanol"]
          },
          Amount -> {
            Null
          },
          ExactAmount -> True,
          Tolerance -> 1 Milliliter,
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::RequiredAmountAndContainer,
        Error::ExactNullAmount,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"ExactAmountToleranceRequiredTogether","ExactAmount cannot be False if a Tolerance is given:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> {
            {"A1", Object[Container,Vessel,"Test container 6 for LabelSample "<>$SessionUUID]}
          },
          ExactAmount -> False,
          Tolerance -> 1 Milliliter,
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::ExactAmountToleranceRequiredTogether,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"SolidWithVolumeRequested","Throws an error if you request a solid sample with a volume:"},
      resolveLabelSamplePrimitive[
        {"best sample ever", "best sample ever 2"},
        {
          Sample -> {
            {"A1",Object[Container,Vessel,"Test container 6 for LabelSample "<>$SessionUUID]},
            Object[Sample,"Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID]
          },
          Amount -> {
            5 Milliliter,
            Automatic
          },
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever 2"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::SolidWithVolumeRequested,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"AmountGreaterThanContainerMaxVolume","Throws an error if the amount requested is over the container max volume:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Amount -> 50 Milliliter,
          Container -> Model[Container, Vessel, "2mL Tube"],
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::AmountGreaterThanContainerMaxVolume,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"SampleContainerLabelMismatch","Throws an error if there is a mismatch between sample/container/well 1:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Container -> Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID],
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::SampleContainerLabelMismatch,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"SampleContainerLabelMismatch","Throws an error if there is a mismatch between sample/container/well 2:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Object[Sample,"Test water sample in 50mL tube for LabelSample "<>$SessionUUID],
          Container -> Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID],
          Well -> "A2",
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::SampleContainerLabelMismatch,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"SampleContainerLabelMismatch","Throws an error if there is a mismatch between sample/container/well 3:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> { "A1", Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID]},
          Well -> "A2",
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::SampleContainerLabelMismatch,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"NoSampleExistsInWell","Throws an error if no sample exists in the given well:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> {"A1",Object[Container,Vessel,"Test container 5 for LabelSample "<>$SessionUUID]},
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::NoSampleExistsInWell,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"LabelSampleDiscarded","Throws an error if the given sample is already discarded 1:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Object[Sample,"Test discarded sample for LabelSample "<>$SessionUUID],
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::LabelSampleDiscarded,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"LabelSampleDiscarded","Throws an error if the given sample is already discarded 2:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> {"A1",Object[Sample,"Test discarded sample for LabelSample "<>$SessionUUID][Container]},
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::LabelSampleDiscarded,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"AmountSpecifiedAsCount","Throws an error if the amount is specified as a count for a non-tablet sample:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Amount -> 5,
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::AmountSpecifiedAsCount,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"RequiredAmountAndContainer","Throws an error if Amount/Container is set to Null but we're given a Model[Sample]:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Amount -> Null,
          Container -> Model[Container, Vessel, "50mL Tube"],
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::RequiredAmountAndContainer,
        Error::InvalidOption
      }
    ],
    Example[
      {Messages,"ConflictingSafetyAndStorageCondition","Throws an error if a safety field was set but the storage condition was not updated:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Container -> Model[Container, Vessel, "50mL Tube"],
          Flammable -> True,
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{10 Milliliter, 10 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::ConflictingSafetyAndStorageCondition,
        Error::InvalidOption
      }
    ],
    (* This test is kinda janky because 70% ethanol has an non-flammable storage condition so it comes out as Flammable->True with Model[StorageCondition,"Ambient Storage"] *)
    Example[
      {Messages,"ConflictingSafetyAndStorageCondition","Throws an error if a hazardous sample is prepared with a mismatched storage condition:"},
      Experiment`Private`resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample->Model[Sample,StockSolution,"70% Ethanol"],
          Container->Model[Container,Vessel,"50mL Tube"],
          Flammable->True,
          Primitives->{
            Transfer[
              Source->{"best sample ever","best sample ever"},
              Destination->{Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"]},
              Amount->{10 Milliliter,10 Milliliter}
            ]
          },
          Output->{Options,Simulation,Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::ConflictingSafetyAndStorageCondition,
        Error::InvalidOption
      }
    ],
    (* This test is kinda janky because 70% ethanol has an non-flammable storage condition so it comes out as Flammable->True with Model[StorageCondition,"Ambient Storage"] *)
    Test["No error is thrown if a hazardous sample is prepared with a mismatched storage condition, but the amount is less than the hazardous storage threshold:",
      Experiment`Private`resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample->Model[Sample,StockSolution,"70% Ethanol"],
          Container->Model[Container,Vessel,"50mL Tube"],
          Flammable->False,
          Primitives->{
            Transfer[
              Source->{"best sample ever","best sample ever"},
              Destination->{Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"]},
              Amount->{$FlammableStorageThreshold/3,$FlammableStorageThreshold/3}
            ]
          },
          Output->{Options,Simulation,Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
      }
    ],
    
    
    
    Example[
      {Messages,"ConflictingTransportConditions","Throws an error if both TransportWarmed and TransportChilled are set:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        {
          Sample -> Model[Sample, "Milli-Q water"],
          Container -> Model[Container, Vessel, "50mL Tube"],
          TransportWarmed -> 50 Celsius,
          TransportChilled -> True,
          Primitives->{
            Transfer[
              Source->{"best sample ever", "best sample ever"},
              Destination->{Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
              Amount->{5 Milliliter, 5 Milliliter}
            ]
          },
          Output -> {Options, Simulation, Result}
        }
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::ConflictingTransportConditions,
        Error::InvalidOption
      }
    ],

    Example[
      {Messages,"UnresolvableLabeledSampleAmount","Throws an error if the required amount of Model[Sample] cannot be determined:"},
      resolveLabelSamplePrimitive[
        {"best sample ever"},
        Sample -> Model[Sample, "Milli-Q water"],
        Output -> {Options, Simulation, Result}
      ],
      {
        _List,
        SimulationP,
        PacketP[]
      },
      Messages:>{
        Error::UnresolvableLabeledSampleAmount,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "LabeledSampleAmount", "Throws a warning if the required amount is specified, but the sample is an Object[Sample]:"},
      resolveLabelSamplePrimitive[
        {"Label 1"},
        Sample -> Object[Sample,"Test water sample in 50mL tube for LabelSample "<>$SessionUUID],
        Amount -> 40 Milliliter
      ],
      PacketP[],
      Messages :> {Warning::LabeledSampleAmount}
    ],
    Test["When a label is directly created without a parent protocol resources are created with AutomaticDisposal->False:",
      Module[{packet},
          packet=resolveLabelSamplePrimitive[
            {"best sample ever"},
            Sample -> Model[Sample, "Milli-Q water"],
            Amount -> 1 Milliliter,
            Output -> Result
          ];
          First[Lookup[packet,Replace[SampleLink]]][AutomaticDisposal]
      ],
      False
    ]
  },
  SymbolSetUp:>(
    $CreatedObjects={};

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Container,Vessel,"Test container 1 for LabelSample "<>$SessionUUID],
      Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID],
      Object[Container,Vessel,"Test container 3 for LabelSample "<>$SessionUUID],
      Object[Container,Vessel,"Test container 3a for LabelSample "<>$SessionUUID],
      Object[Container,Vessel,"Test container 3b for LabelSample "<>$SessionUUID],
      Object[Container,Vessel,"Test container 4 for LabelSample "<>$SessionUUID],
      Object[Container,Vessel,"Test container 5 for LabelSample "<>$SessionUUID], (* LEAVE THIS EMPTY *)
      Object[Container,Vessel,"Test container 6 for LabelSample "<>$SessionUUID],
      Object[Container,Plate,"Test container 7 for LabelSample "<>$SessionUUID],
      Object[Sample,"Test discarded sample for LabelSample "<>$SessionUUID],
      Object[Sample,"Test water sample in 50mL tube for LabelSample "<>$SessionUUID],
      Object[Sample,"Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
      Object[Sample, "Test water sample in 50mL tube for LabelSample 2 "<>$SessionUUID],
      Object[Sample, "Test water sample in 50mL tube for LabelSample 3 "<>$SessionUUID],
      Object[Sample,"Test solid sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
      Object[Sample,"Test tablet sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
      Object[Sample, "Test water sample 1 in DWP for LabelSample "<>$SessionUUID],
      Object[Sample, "Test water sample 2 in DWP for LabelSample "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Container,Vessel,"Test container 1 for LabelSample "<>$SessionUUID],
          Object[Container,Vessel,"Test container 2 for LabelSample "<>$SessionUUID],
          Object[Container,Vessel,"Test container 3 for LabelSample "<>$SessionUUID],
          Object[Container,Vessel,"Test container 3a for LabelSample "<>$SessionUUID],
          Object[Container,Vessel,"Test container 3b for LabelSample "<>$SessionUUID],
          Object[Container,Vessel,"Test container 4 for LabelSample "<>$SessionUUID],
          Object[Container,Vessel,"Test container 5 for LabelSample "<>$SessionUUID], (* LEAVE THIS EMPTY *)
          Object[Container,Vessel,"Test container 6 for LabelSample "<>$SessionUUID],
          Object[Container,Plate,"Test container 7 for LabelSample "<>$SessionUUID],
          Object[Sample,"Test discarded sample for LabelSample "<>$SessionUUID],
          Object[Sample,"Test water sample in 50mL tube for LabelSample "<>$SessionUUID],
          Object[Sample,"Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
          Object[Sample, "Test water sample in 50mL tube for LabelSample 2 "<>$SessionUUID],
          Object[Sample, "Test water sample in 50mL tube for LabelSample 3 "<>$SessionUUID],
          Object[Sample,"Test solid sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
          Object[Sample,"Test tablet sample in 1L Glass Bottle for LabelSample "<>$SessionUUID],
          Object[Sample, "Test water sample 1 in DWP for LabelSample "<>$SessionUUID],
          Object[Sample, "Test water sample 2 in DWP for LabelSample "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    (* set up the test objects *)
    Module[
      {
        emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer3a, emptyContainer3b,emptyContainer4,emptyContainer5,emptyContainer6,
        discardedChemical, waterSample, waterSample2, waterSample3, waterSample4, solidSample3, tabletSample4, waterSample5, waterSample6,
        emptyContainer7
      },

      (* Create some empty containers *)
      {
        emptyContainer1,
        emptyContainer2,
        emptyContainer3,
        emptyContainer3a,
        emptyContainer3b,
        emptyContainer4,
        emptyContainer5,
        emptyContainer6,
        emptyContainer7
      }=Upload[{
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
        Name->"Test container 1 for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
        Name->"Test container 2 for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
        Name->"Test container 3 for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
        Name->"Test container 3a for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
        Name->"Test container 3b for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
        Name->"Test container 4 for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
        Name->"Test container 5 for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
        Name->"Test container 6 for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Plate],
        Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
        Name->"Test container 7 for LabelSample "<>$SessionUUID,
        DeveloperObject->True
      |>
    }];

    (* Create some water/solid/tablet samples *)
    {
      discardedChemical,
      waterSample,
      waterSample2,
      waterSample3,
      waterSample4,
      solidSample3,
      tabletSample4,
      waterSample5,
      waterSample6
    }=ECL`InternalUpload`UploadSample[
      {
        Model[Sample,"Milli-Q water"],
        Model[Sample,"Milli-Q water"],
        Model[Sample,"Milli-Q water"],
        Model[Sample,"Milli-Q water"],
        Model[Sample,"Milli-Q water"],
        Model[Sample,"Sodium Phosphate Monobasic Monohydrate"],
        Model[Sample,"Ibuprofen tablets 500 Count"],
        Model[Sample,"Milli-Q water"],
        Model[Sample,"Milli-Q water"]
      },
      {
        {"A1",emptyContainer1},
        {"A1",emptyContainer2},
        {"A1",emptyContainer3},
        {"A1",emptyContainer3a},
        {"A1",emptyContainer3b},
        {"A1",emptyContainer4},
        {"A1",emptyContainer6},
        {"A1",emptyContainer7},
        {"A2",emptyContainer7}
      },
      InitialAmount->{
        50 Milliliter,
        47 Milliliter,
        1 Liter,
        10 Milliliter,
        10 Milliliter,
        5 Gram,
        10,
        1 Milliliter,
        1 Milliliter
      },
      Name->{
        "Test discarded sample for LabelSample "<>$SessionUUID,
        "Test water sample in 50mL tube for LabelSample "<>$SessionUUID,
        "Test water sample in 1L Glass Bottle for LabelSample "<>$SessionUUID,
        "Test water sample in 50mL tube for LabelSample 2 "<>$SessionUUID,
        "Test water sample in 50mL tube for LabelSample 3 "<>$SessionUUID,
        "Test solid sample in 1L Glass Bottle for LabelSample "<>$SessionUUID,
        "Test tablet sample in 1L Glass Bottle for LabelSample "<>$SessionUUID,
        "Test water sample 1 in DWP for LabelSample "<>$SessionUUID,
        "Test water sample 2 in DWP for LabelSample "<>$SessionUUID
      }
    ];

    (* Make some changes to our samples to make them invalid. *)
    Upload[{
      <|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>,
      <|Object->waterSample,DeveloperObject->True|>,
      <|Object->waterSample2,DeveloperObject->True|>,
      <|Object->waterSample3,DeveloperObject->True|>,
      <|Object->waterSample4,DeveloperObject->True|>,
      <|Object->solidSample3,DeveloperObject->True|>,
      <|Object->tabletSample4,DeveloperObject->True|>,
      <|Object->waterSample5,DeveloperObject->True|>,
      <|Object->waterSample6,DeveloperObject->True|>
    }]
];
  ),
  SymbolTearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $Notebook = Object[LaboratoryNotebook, "Wyatt Scratch"]
  }
]