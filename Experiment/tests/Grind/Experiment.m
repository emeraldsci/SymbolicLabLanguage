(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentGrind*)


DefineTests[ExperimentGrind,
  {
    (* --- Basic --- *)
    Example[
      {Basic, "Creates a protocol to grind a solid sample:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, Grind]]
    ],

    Example[
      {Basic, "Accepts an input container containing a solid sample:"},
      ExperimentGrind[
        Object[Container, Vessel, "Test container for ExperimentGrind 1 " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, Grind]]
    ],

    Example[
      {Basic, "Grinds a list of inputs (samples or containers) containing solid samples:"},
      ExperimentGrind[{
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 3 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 4 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 5 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 6 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 7 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 8 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 9 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 10 " <> $SessionUUID]
      }],
      ObjectP[Object[Protocol, Grind]]
    ],

    (* Output Options *)
    Example[
      {Basic, "Generates a list of tests if Output is set to Tests:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Output -> Tests
      ],
      {_EmeraldTest..}
    ],

    Example[
      {Basic, "Generates a simulation if output is set to Simulation:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Output -> Simulation
      ],
      SimulationP
    ],

    (* --- Grind Options --- *)
    Example[
      {Options, GrinderType, "Determine the type of the grinder to grind the sample:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          GrinderType -> KnifeMill,
          Output -> Options
      ];
      Lookup[options, GrinderType],
      KnifeMill,
      Variables :> {options}
    ],

    Example[
      {Options, Instrument, "Determine the instrument to grind the sample:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          Instrument -> Model[Instrument, Grinder, "Tube Mill Control"],
          Output -> Options
      ];
      Lookup[options, Instrument],
      ObjectP[Model[Instrument, Grinder, "Tube Mill Control"]],
      Variables :> {options}
    ],

    Example[
      {Options, Amount, "Determine the amount of the sample for grinding:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          Output -> Options,
          Amount -> 1 Gram
      ];
      Lookup[options, Amount],
      1 Gram,
      Variables :> {options}
    ],

    Example[
      {Options, Fineness, "Determine the Fineness of the sample (the largest size of the particles of the sample):"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          Fineness -> 0.5 Millimeter,
          Output -> Options
        ];
      Lookup[options, Fineness],
      0.5 Millimeter,
      Variables :> {options}
    ],

    Example[
      {Options, BulkDensity, "Determine the bulk density of the sample:"},
      options = ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        BulkDensity -> 0.5 Gram/Milliliter,
        Output -> Options
      ];
      Lookup[options, BulkDensity],
      0.5 Gram/Milliliter,
      Variables :> {options}
    ],

    Example[
      {Options, GrindingContainer, "Determine the container that the sample is transferred into to be ground:"},
      options = ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        GrindingContainer -> Model[Container, Vessel, "2mL tube with no skirt"],
        Output -> Options
      ];
      Lookup[options, GrindingContainer],
      ObjectP[Model[Container, Vessel, "2mL tube with no skirt"]],
      Variables :> {options}
    ],

    Example[
      {Options, GrindingBead, "Determine the beads that are used in ball mills to grind the sample:"},
      options = ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        GrindingBead -> Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, GrindingBead],
      ObjectP[Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID]],
      Variables :> {options}
    ],

    Example[
      {Options, NumberOfGrindingBeads, "Determine the beads that are used in ball mills to grind the sample:"},
      options = ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        NumberOfGrindingBeads -> 2,
        Output -> Options
      ];
      Lookup[options, NumberOfGrindingBeads],
      2,
      Variables :> {options}
    ],

    Example[
      {Options, GrindingRate, "Determine the grinding rate of the grinder:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          GrindingRate -> 3000 RPM,
          Output -> Options
      ];
      Lookup[options, GrindingRate],
      3000 RPM,
      Variables :> {options}
    ],

    Example[
      {Options, Time, "Determine the duration that the sample is being ground inside the grinder:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          Time -> 1 Minute,
          Output -> Options
      ];
      Lookup[options, Time],
      1 Minute,
      Variables :> {options}
    ],

    Example[
      {Options, NumberOfGrindingSteps, "Determine the number of times that the sample is being ground in the grinder:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          NumberOfGrindingSteps -> 3,
          Output -> Options
      ];
      Lookup[options, NumberOfGrindingSteps],
      3,
      Variables :> {options}
    ],

    Example[
      {Options, CoolingTime, "Determine the duration of the cooling step between each grinding step:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          CoolingTime -> 1 Minute,
          NumberOfGrindingSteps -> 3,
          Output -> Options
      ];
      Lookup[options, CoolingTime],
      1 Minute,
      Variables :> {options}
    ],

    Example[
      {Options, GrindingProfile, "Determine a paired list of time and activities of the grinding process in the form of Activity (Grinding or Cooling), Duration, and GrindingRate:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          GrindingProfile -> {{Grinding, 2900 RPM, 10 Second}, {Cooling, 0 RPM, 50 Second}, {Grinding, 4500 RPM, 10 Second}},
          Output -> Options
      ];
      Lookup[options, GrindingProfile],
      {{Grinding, 2900 RPM, 10 Second}, {Cooling, 0 RPM, 50 Second}, {Grinding, 4500 RPM, 10 Second}},
      Variables :> {options}
    ],

    Example[
      {Options, SampleLabel, "Determine a value for labeling the sample:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          SampleLabel -> "My awesome sample to be ground",
          Output -> Options
        ];
      Lookup[options, SampleLabel],
      "My awesome sample to be ground",
      Variables :> {options}
    ],

    Example[
      {Options, SampleOutLabel, "Determines a value for labeling the grinding output sample:"},
      options = ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        SampleOutLabel -> "My awesome ground sample",
        Output -> Options
      ];
      Lookup[options, SampleOutLabel],
      "My awesome ground sample",
      Variables :> {options}
    ],

    Example[
      {Options, ContainerOut, "Determine the container that the output samples (SamplesOut) are transferred into:"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          ContainerOut -> Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID],
          Output -> Options
      ];
      Lookup[options, ContainerOut],
      ObjectP[Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID]],
      Variables :> {options}
    ],

    Example[
      {Options, ContainerOutLabel, "Determines a value for labeling the grinding output container:"},
      options = ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        ContainerOutLabel -> "The container of my awesome ground sample",
        Output -> Options
      ];
      Lookup[options, ContainerOutLabel],
      "The container of my awesome ground sample",
      Variables :> {options}
    ],

    Example[
      {Options, SamplesOutStorageCondition, "Determine the storage condition of the output samples (SampleOut):"},
      options = ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          SamplesOutStorageCondition -> Model[StorageCondition, "Ambient Storage, Desiccated"],
          Output -> Options
      ];
      Lookup[options, SamplesOutStorageCondition],
      ObjectP[Model[StorageCondition, "Ambient Storage, Desiccated"]],
      Variables :> {options}
    ],

    (* --- Shared Options --- *)
    Example[{Options, PreparatoryUnitOperations, "Specifies prepared samples for ExperimentGrind (PreparatoryUnitOperations):"},
      Lookup[ExperimentGrind["My Grind Sample",
        PreparatoryUnitOperations -> {
          LabelContainer[
            Label -> "My Grind Sample",
            Container -> Model[Container, Vessel, "2mL tube with no skirt"]
          ],
          Transfer[
            Source -> {
              Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
              Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID]
            },
            Destination -> "My Grind Sample",
            Amount -> {0.1 Gram, 0.2 Gram}
          ]
        },
        Output -> Options
      ], PreparatoryUnitOperations],
      {SamplePreparationP..}
    ],
    
    Example[{Options, PreparatoryPrimitives, "Specifies prepared samples for ExperimentGrind (PreparatoryPrimitives):"},
      ExperimentGrind["My Grind Container",
        PreparatoryPrimitives -> {
          Define[
            Name -> "My Grind Container",
            Container -> Model[Container, Vessel, "2mL tube with no skirt"]
          ],
          Transfer[
            Source -> Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
            Amount -> 0.1 Gram,
            Destination -> "My Grind Container"
          ]
        },
        Output -> Options
      ],
      {_Rule..}
    ],
    
    Example[
      {Options, Name, "Uses an object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
      Lookup[
        ExperimentGrind[
          Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          Name -> "Max E. Mumm's Grind Sample",
          Output -> Options
        ],
        Name
      ],
      "Max E. Mumm's Grind Sample"
    ],
    
    Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
      Lookup[
        ExperimentGrind[Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          MeasureWeight -> True,
          Output -> Options],
        MeasureWeight
      ],
      True
    ],
    
    Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
      Lookup[
        ExperimentGrind[Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
          MeasureWeight -> True,
          Output -> Options],
        MeasureVolume
      ],
      True
    ],
    
    Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be imaged after running the experiment:"},
      options = ExperimentGrind[Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        ImageSample -> True,
        Output -> Options
      ];
      Lookup[options, ImageSample],
      True,
      Variables :> {options}
    ],
    
    Example[{Options,Template,"Inherits options from a previously run grind protocol:"},
      options = ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Template -> Object[Protocol, Grind, "Test Grind option template protocol" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Time],
      2 Minute,
      Variables :> {options}
    ],

    (* ---  Messages --- *)
    Example[{Messages, "NonSolidSample", "All samples have mass information:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 11 " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::MissingMassInformation]
      }
    ],

    Example[{Messages, "InsufficientAmount", "The amount of the sample might be too small for efficient grinding of the sample:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Amount -> 0.05 Gram
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::InsufficientAmount]
      }
    ],

    Example[{Messages, "ExcessiveAmount", "The specified Amount might be too much to be ground by the specified grinder:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Amount -> 200 Gram
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::ExcessiveAmount]
      }
    ],

    Example[{Messages, "LargeParticles", "The Fineness of the sample (the size of the largest particles in the sample) is too large to be ground by the available grinders:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Fineness -> 15 Millimeter
      ],
      $Failed,
      Messages :> {
        Message[Error::LargeParticles],
        Message[Error::LargeParticles],
        Message[Error::InvalidOption]
      }
    ],

    Example[{Messages, "InvalidSampleAmounts", "Specified sample Amount(s) are not greater than the mass of available sample(s):"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        Amount -> 5 Gram
      ],
      $Failed,
      Messages :> {
        Message[Error::InvalidSampleAmounts],
        Message[Error::InvalidOption]
      }
    ],

    Example[{Messages, "HighGrindingRate", "The specified GrindingRate(s) are not greater than the maximum grinding rate of the specified grinder:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        GrindingRate -> 5000 RPM
      ],
      $Failed,
      Messages :> {
        Message[Error::HighGrindingRate],
        Message[Error::InvalidOption]
      }
    ],

    Example[{Messages, "LowGrindingRate", "The specified GrindingRate(s) are not smaller than the minimum grinding rate of the specified grinder:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        GrindingRate -> 500 RPM
      ],
      $Failed,
      Messages :> {
        Message[Error::LowGrindingRate],
        Message[Error::InvalidOption]
      }
    ],

    Example[{Messages, "HighGrindingTime", "The specified grinding Time(s) are not greater than the maximum grinding time that the timer of the specified instrument measures:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        Time -> $MaxExperimentTime
      ],
      $Failed,
      Messages :> {
        Message[Error::HighGrindingTime],
        Message[Error::InvalidOption]
      }
    ],

    Example[{Messages, "LowGrindingTime", "The specified grinding Time(s) are not smaller than the minimum grinding time that the timer of the specified instrument measures:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        Time -> 1 Second
      ],
      $Failed,
      Messages :> {
        Message[Error::LowGrindingTime],
        Message[Error::InvalidOption]
      }
    ],

    Example[{Messages, "ModifiedNumberOfGrindingSteps", "The NumberOfGrindingSteps change due to the specified parameters in GrindingProfile:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        NumberOfGrindingSteps -> 5,
        GrindingProfile -> {{Grinding, 3000 RPM, 5 Second}, {Cooling, 0 RPM, 30 Second}, {Grinding, 3000 RPM, 10 Second}}
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::ModifiedNumberOfGrindingSteps]
      }
    ],

    Example[{Messages, "ModifiedGrindingRates", "The specified GrindingRate(s) change due to specifying different parameters in GrindingProfile:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        GrindingRate -> 2800 RPM,
        GrindingProfile -> {{Grinding, 2800 RPM, 5 Second}, {Cooling, 0 RPM, 30 Second}, {Grinding, 3000 RPM, 10 Second}}
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::ModifiedGrindingRates]
      }
    ],

    Example[{Messages, "ModifiedGrindingTimes", "The specified grinding Time(s) change due to specifying different parameters in GrindingProfile:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        Time -> 10 Second,
        GrindingProfile -> {{Grinding, 2800 RPM, 5 Second}, {Cooling, 0 RPM, 30 Second}, {Grinding, 3000 RPM, 10 Second}}
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::ModifiedGrindingTimes]
      }
    ],

    Example[{Messages, "NonZeroCoolingRates", "The specified cooling rate in GrindingProfile is not 0 RPM:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        GrindingProfile -> {{Grinding, 2800 RPM, 5 Second}, {Cooling, 100 RPM, 30 Second}, {Grinding, 3000 RPM, 10 Second}}
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::NonZeroCoolingRates]
      }
    ],

    Example[{Messages, "ModifiedCoolingTimes", "The specified cooling time in GrindingProfile is different from the specified CoolingTime option:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        CoolingTime -> 1 Minute,
        GrindingProfile -> {{Grinding, 2800 RPM, 5 Second}, {Cooling, 0 RPM, 30 Second}, {Grinding, 3000 RPM, 10 Second}}
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::ModifiedCoolingTimes]
      }
    ],

    Example[{Messages, "InvalidSamplesOutStorageCondition", "SamplesOutStorageCondition is informed:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 12 " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Message[Error::InvalidSamplesOutStorageCondition],
        Message[Error::InvalidOption]
      }
    ],

    Example[{Messages, "MissingMassInformation", "The Mass of the sample is informed:"},
      ExperimentGrind[
        Object[Sample, "Test sample for ExperimentGrind 14 " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, Grind]],
      Messages :> {
        Message[Warning::MissingMassInformation]
      }
    ]
  },

  SetUp :> (ClearMemoization[]),

  SymbolSetUp :> (

    $CreatedObjects = {};

    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::SimilarMolecules];
    Off[Warning::DeprecatedProduct];
    Off[Warning::SampleMustBeMoved];

    Module[
      {allObjects},

      (* list of test objects*)
      allObjects = {
        Object[Container, Bench, "Testing bench for ExperimentGrind Tests" <> $SessionUUID],
        Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 1 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 3 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 4 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 5 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 6 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 7 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 8 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 9 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 10 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 11 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 12 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 13 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 14 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 15 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 16 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 17 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 18 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 19 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 20 " <> $SessionUUID],

        (* sample models *)
        Model[Sample, "Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID],
        Model[Sample, "Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID],
        Model[Sample, "Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID],

        (* sample objects *)
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 3 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 4 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 5 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 6 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 7 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 8 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 9 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 10 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 11 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 12 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 13 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 14 " <> $SessionUUID],

        (* Protocol Object *)
        Object[Protocol, Grind, "Test Grind option template protocol" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False]];
    ];

    Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
      Module[
        {
          testBench, noStateSampleModelPacket, noStorageConditionModelPacket,
          liquidSampleModelPacket, testSampleModels, testSampleLocations,
          testSampleAmounts, testSampleNames, createdSamples
        },

        (* create all the containers and identity models, and Cartridges *)

        Upload[
          (* Test bench to upload samples *)
          testBench = <|
            Type -> Object[Container, Bench],
            Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
            Name -> "Testing bench for ExperimentGrind Tests" <> $SessionUUID,
            Site -> Link[$Site]
          |>];

        UploadSample[
          Flatten[{
            Model[Item, GrindingBead, "2.8 mm stainless steel grinding bead"],
            ConstantArray[Model[Container, Vessel, "2mL tube with no skirt"], 20]
          }],
          ConstantArray[{"Work Surface", Object[Container, Bench, "Testing bench for ExperimentGrind Tests" <> $SessionUUID]}, 21],
          Name -> {
            "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID,
            "Test container for ExperimentGrind 1 " <> $SessionUUID,
            "Test container for ExperimentGrind 2 " <> $SessionUUID,
            "Test container for ExperimentGrind 3 " <> $SessionUUID,
            "Test container for ExperimentGrind 4 " <> $SessionUUID,
            "Test container for ExperimentGrind 5 " <> $SessionUUID,
            "Test container for ExperimentGrind 6 " <> $SessionUUID,
            "Test container for ExperimentGrind 7 " <> $SessionUUID,
            "Test container for ExperimentGrind 8 " <> $SessionUUID,
            "Test container for ExperimentGrind 9 " <> $SessionUUID,
            "Test container for ExperimentGrind 10 " <> $SessionUUID,
            "Test container for ExperimentGrind 11 " <> $SessionUUID,
            "Test container for ExperimentGrind 12 " <> $SessionUUID,
            "Test container for ExperimentGrind 13 " <> $SessionUUID,
            "Test container for ExperimentGrind 14 " <> $SessionUUID,
            "Test container for ExperimentGrind 15 " <> $SessionUUID,
            "Test container for ExperimentGrind 16 " <> $SessionUUID,
            "Test container for ExperimentGrind 17 " <> $SessionUUID,
            "Test container for ExperimentGrind 18 " <> $SessionUUID,
            "Test container for ExperimentGrind 19 " <> $SessionUUID,
            "Test container for ExperimentGrind 20 " <> $SessionUUID}
        ];

        noStateSampleModelPacket = <|
          BiosafetyLevel -> "BSL-1",
          Replace[Composition] -> {{Quantity[100, IndependentUnit["MassPercent"]], Link[Model[Molecule, "Sodium Chloride"]]}},
          DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          DOTHazardClass -> "Class 0",
          Expires -> False,
          Flammable -> False,
          Replace[IncompatibleMaterials] -> {Brass, CarbonSteel, CastIron},
          MSDSFile -> Link[Object[EmeraldCloudFile, "id:01G6nvwjr6XE"]],
          NFPA -> {Health -> 1, Flammability -> 0, Reactivity -> 0, Special -> {Null}},
          Type -> Model[Sample],
          Name -> "Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID,
          Replace[Authors] -> {Link[Object[User, Emerald, Developer, "mohamad.zandian"]]},
          Replace[Synonyms] -> {"Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID}
        |>;

        noStorageConditionModelPacket = <|
          BiosafetyLevel -> "BSL-1",
          Replace[Composition] -> {{Quantity[100, IndependentUnit["MassPercent"]], Link[Model[Molecule, "Sodium Chloride"]]}},
          DOTHazardClass -> "Class 0",
          Expires -> False,
          Flammable -> False,
          Replace[IncompatibleMaterials] -> {Brass, CarbonSteel, CastIron},
          MSDSFile -> Link[Object[EmeraldCloudFile, "id:01G6nvwjr6XE"]],
          NFPA -> {Health -> 1, Flammability -> 0, Reactivity -> 0, Special -> {Null}},
          State -> Solid,
          Type -> Model[Sample],
          Name -> "Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID,
          Replace[Authors] -> {Link[Object[User, Emerald, Developer, "mohamad.zandian"]]},
          Replace[Synonyms] -> {"Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID}
        |>;

        liquidSampleModelPacket = <|
          BiosafetyLevel -> "BSL-1",
          Replace[Composition] -> {{Quantity[100, IndependentUnit["MassPercent"]], Link[Model[Molecule, "Sodium Chloride"]]}},
          DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          DOTHazardClass -> "Class 0",
          Expires -> False,
          Flammable -> False,
          Replace[IncompatibleMaterials] -> {Brass, CarbonSteel, CastIron},
          MSDSFile -> Link[Object[EmeraldCloudFile, "id:01G6nvwjr6XE"]],
          NFPA -> {Health -> 1, Flammability -> 0, Reactivity -> 0, Special -> {Null}},
          State -> Liquid,
          Type -> Model[Sample],
          Name -> "Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID,
          Replace[Authors] -> {Link[Object[User, Emerald, Developer, "mohamad.zandian"]]},
          Replace[Synonyms] -> {"Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID}
        |>;

        (* Upload all models plus a template protocol*)
        Upload[Flatten[{
          noStateSampleModelPacket,
          liquidSampleModelPacket,
          noStorageConditionModelPacket,
          <|
            Type -> Object[Protocol, Grind],
            Name -> "Test Grind option template protocol" <> $SessionUUID,
            ResolvedOptions -> {Time -> 2 Minute}
          |>,
          <|
            Object -> Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID],
            Count -> 1000
          |>
        }]];

        testSampleModels = {
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Sodium Chloride"],
          Model[Sample, "Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID],
          Model[Sample, "Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID],
          Model[Sample, "Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID],
          Model[Sample, "Sodium Chloride"]
        };

        testSampleLocations = {
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 1 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 3 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 4 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 5 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 6 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 7 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 8 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 9 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 10 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 11 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 12 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 13 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Test container for ExperimentGrind 14 " <> $SessionUUID]}
        };

        testSampleAmounts = {
          250 Gram,
          1.25 Gram,
          1.25 Gram,
          1.7 Gram,
          1.6 Gram,
          1.5 Gram,
          .3 Gram,
          .4 Gram,
          .5 Gram,
          .95 Gram,
          10 Milliliter,
          1.95 Gram,
          Null,
          Null
        };

        testSampleNames = {
          "Test sample for ExperimentGrind 1 " <> $SessionUUID,
          "Test sample for ExperimentGrind 2 " <> $SessionUUID,
          "Test sample for ExperimentGrind 3 " <> $SessionUUID,
          "Test sample for ExperimentGrind 4 " <> $SessionUUID,
          "Test sample for ExperimentGrind 5 " <> $SessionUUID,
          "Test sample for ExperimentGrind 6 " <> $SessionUUID,
          "Test sample for ExperimentGrind 7 " <> $SessionUUID,
          "Test sample for ExperimentGrind 8 " <> $SessionUUID,
          "Test sample for ExperimentGrind 9 " <> $SessionUUID,
          "Test sample for ExperimentGrind 10 " <> $SessionUUID,
          "Test sample for ExperimentGrind 11 " <> $SessionUUID,
          "Test sample for ExperimentGrind 12 " <> $SessionUUID,
          "Test sample for ExperimentGrind 13 " <> $SessionUUID,
          "Test sample for ExperimentGrind 14 " <> $SessionUUID
        };


        (* create some samples in the above containers*)
        createdSamples = UploadSample[
          testSampleModels,
          testSampleLocations,
          InitialAmount -> testSampleAmounts,
          Name -> testSampleNames,
          FastTrack -> True
        ];
      ]]
  ),

  SymbolTearDown :> (
    Module[{allObjects},
      On[Warning::SamplesOutOfStock];
      On[Warning::InstrumentUndergoingMaintenance];
      On[Warning::SimilarMolecules];
      On[Warning::DeprecatedProduct];

      (* list of test objects*)
      allObjects = Cases[Flatten[{
        $CreatedObjects,
        Object[Container, Bench, "Testing bench for ExperimentGrind Tests" <> $SessionUUID],
        Object[Item, GrindingBead, "Test Grinding Bead for ExperimentGrind 1 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 1 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 2 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 3 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 4 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 5 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 6 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 7 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 8 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 9 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 10 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 11 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 12 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 13 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 14 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 15 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 16 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 17 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 18 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 19 " <> $SessionUUID],
        Object[Container, Vessel, "Test container for ExperimentGrind 20 " <> $SessionUUID],

        (* sample models *)
        Model[Sample, "Test liquid sample model 1 for ExperimentGrind tests " <> $SessionUUID],
        Model[Sample, "Test no-state sample model 1 for ExperimentGrind tests " <> $SessionUUID],
        Model[Sample, "Test no-StorageCondition sample model 1 for ExperimentGrind tests " <> $SessionUUID],

        (* sample objects *)
        Object[Sample, "Test sample for ExperimentGrind 1 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 2 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 3 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 4 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 5 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 6 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 7 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 8 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 9 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 10 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 11 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 12 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 13 " <> $SessionUUID],
        Object[Sample, "Test sample for ExperimentGrind 14 " <> $SessionUUID],

        (* Protocol Object *)
        Object[Protocol, Grind, "Test Grind option template protocol" <> $SessionUUID]
      }], ObjectP[]];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False]];

      Unset[$CreatedObjects];
    ];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];
(* ::Subsection::Closed:: *)
(*ExperimentGrindOptions*)

DefineTests[
  ExperimentGrindOptions,
  {
    (* --- Basic Examples --- *)
    Example[
      {Basic, "Generate a table of resolved options for an ExperimentGrind call to grind a single sample:"},
      ExperimentGrindOptions[Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID]],
      _Grid
    ],
    Example[
      {Basic, "Generate a table of resolved options for an ExperimentGrind call to grind a single container:"},
      ExperimentGrindOptions[Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID]],
      _Grid
    ],
    Example[
      {Basic, "Generate a table of resolved options for an ExperimentGrind call to grind a sample and a container the same time:"},
      ExperimentGrindOptions[{
        Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID]
      }],
      _Grid
    ],

    (* --- Options Examples --- *)
    Example[
      {Options, OutputFormat, "Generate a resolved list of options for an ExperimentGrind call to grind a single container:"},
      ExperimentGrindOptions[Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID], OutputFormat->List],
      _?(MatchQ[
        Check[SafeOptions[ExperimentGrind, #], $Failed, {Error::Pattern}],
        {(_Rule|_RuleDelayed)..}
      ]&)
    ]
  },
  SymbolSetUp :>(
    (* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    $CreatedObjects = {};

    Module[{objects},

      (* list of test objects*)
      objects = {
        (* Sample Objects *)
        Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID],
        Object[Sample, "Grind Test Sample for ExperimentGrindOptions 2" <> $SessionUUID],

        (* Container Objects *)
        Object[Container, Bench, "Test Bench for ExperimentGrindOptions" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force->True, Verbose->False]];
    ];

    Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench,"The Bench of Testing"], Objects],
          Name -> "Test Bench for ExperimentGrindOptions" <> $SessionUUID,
          DeveloperObject -> True,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Site -> Link[$Site]
        |>];

        UploadSample[
          {
            Model[Container, Vessel, "2mL tube with no skirt"],
            Model[Container, Vessel, "2mL tube with no skirt"]
          },
          {
            {"Bench Top Slot", testBench},
            {"Bench Top Slot", testBench}
          },
          Name -> {
            "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID,
            "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID
          }
        ];

        UploadSample[
          {
            Model[Sample, "Benzoic acid"],
            Model[Sample, "Benzoic acid"]
          },
          {
            {"A1", Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID]},
            {"A1", Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID]}
          },
          InitialAmount-> {
            1.3 Gram,
            1.3 Gram
          },
          Name->{
            "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID,
            "Grind Test Sample for ExperimentGrindOptions 2" <> $SessionUUID
          }
        ];
      ];
    ];


    (* upload needed objects *)
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    EraseObject[Flatten[{
      $CreatedObjects,

      (* Sample Objects *)
      Object[Sample, "Grind Test Sample for ExperimentGrindOptions 1" <> $SessionUUID],
      Object[Sample, "Grind Test Sample for ExperimentGrindOptions 2" <> $SessionUUID],

      (* Container Objects *)
      Object[Container, Bench, "Test Bench for ExperimentGrindOptions" <> $SessionUUID],
      Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 1" <> $SessionUUID],
      Object[Container, Vessel, "Grind Test Container for ExperimentGrindOptions 2" <> $SessionUUID]
    }],
      Force->True, Verbose->False];
  )
];



(* ::Subsection::Closed:: *)
(*ExperimentGrindPreview*)


DefineTests[
  ExperimentGrindPreview,
  {
    (* --- Basic Examples --- *)
    Example[
      {Basic, "Generate a preview for an ExperimentGrind call to grind of a single container (will always be Null:"},
      ExperimentGrindPreview[Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID]],
      Null
    ],
    Example[
      {Basic, "Generate a preview for an ExperimentGrind call to grind of two containers at the same time:"},
      ExperimentGrindPreview[{
        Object[Sample, "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID]
      }],
      Null
    ],
    Example[
      {Basic, "Generate a preview for an ExperimentGrind call to grind of a single sample:"},
      ExperimentGrindPreview[Object[Sample, "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID]],
      Null
    ]
  },
  SymbolSetUp :>(
    (* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    $CreatedObjects = {};

    Module[{objects},

      (* list of test objects*)
      objects = {
        (* Sample Objects *)
        Object[Sample, "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID],
        Object[Sample, "Grind Test Sample for ExperimentGrindPreview 2" <> $SessionUUID],

        (* Container Objects *)
        Object[Container, Bench, "Test Bench for ExperimentGrindPreview" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force->True, Verbose->False]];
    ];

    Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench,"The Bench of Testing"], Objects],
          Name -> "Test Bench for ExperimentGrindPreview" <> $SessionUUID,
          DeveloperObject -> True,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Site -> Link[$Site]
        |>];

        UploadSample[
          {
            Model[Container, Vessel, "2mL tube with no skirt"],
            Model[Container, Vessel, "2mL tube with no skirt"]
          },
          {
            {"Bench Top Slot", testBench},
            {"Bench Top Slot", testBench}
          },
          Name -> {
            "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID,
            "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID
          }
        ];

        UploadSample[
          {
            Model[Sample, "Benzoic acid"],
            Model[Sample, "Benzoic acid"]
          },
          {
            {"A1", Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID]},
            {"A1", Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID]}
          },
          InitialAmount-> {
            1.3 Gram,
            1.3 Gram
          },
          Name->{
            "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID,
            "Grind Test Sample for ExperimentGrindPreview 2" <> $SessionUUID
          }
        ];
      ];
    ];


    (* upload needed objects *)
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    EraseObject[Flatten[{
      $CreatedObjects,

      (* Sample Objects *)
      Object[Sample, "Grind Test Sample for ExperimentGrindPreview 1" <> $SessionUUID],
      Object[Sample, "Grind Test Sample for ExperimentGrindPreview 2" <> $SessionUUID],

      (* Container Objects *)
      Object[Container, Bench, "Test Bench for ExperimentGrindPreview" <> $SessionUUID],
      Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 1" <> $SessionUUID],
      Object[Container, Vessel, "Grind Test Container for ExperimentGrindPreview 2" <> $SessionUUID]
    }],
      Force->True, Verbose->False];
  )
];


(* ::Subsection::Closed:: *)
(*ValidExperimentGrindQ*)


DefineTests[
  ValidExperimentGrindQ,
  {
    (* --- Basic Examples --- *)
    Example[
      {Basic, "Validate an ExperimentGrind call to Grind a single container:"},
      ValidExperimentGrindQ[Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID]],
      True
    ],
    Example[
      {Basic, "Validate an ExperimentGrind call to Grind two containers at the same time:"},
      ValidExperimentGrindQ[{
        Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID]
      }],
      True
    ],
    Example[
      {Basic, "Validate an ExperimentGrind call to Grind a single sample:"},
      ValidExperimentGrindQ[Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID]],
      True
    ],

    (* --- Options Examples --- *)
    Example[
      {Options, OutputFormat, "Validate an ExperimentGrind call to Grind a single container, returning an ECL Test Summary:"},
      ValidExperimentGrindQ[Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID], OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[
      {Options, Verbose, "Validate an ExperimentGrind call to grind of a single container, printing a verbose summary of tests as they are run:"},
      ValidExperimentGrindQ[Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID], Verbose->True],
      True
    ]
  },
  SymbolSetUp :>(
    (* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    $CreatedObjects = {};

    Module[{objects},

      (* list of test objects*)
      objects = {
        (* Sample Objects *)
        Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID],
        Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 2" <> $SessionUUID],

        (* Container Objects *)
        Object[Container, Bench, "Test Bench for ValidExperimentGrindQ" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID],
        Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force->True, Verbose->False]];
    ];

    Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench,"The Bench of Testing"], Objects],
          Name -> "Test Bench for ValidExperimentGrindQ" <> $SessionUUID,
          DeveloperObject -> True,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Site -> Link[$Site]
        |>];

        UploadSample[
          {
            Model[Container, Vessel, "2mL tube with no skirt"],
            Model[Container, Vessel, "2mL tube with no skirt"]
          },
          {
            {"Bench Top Slot", testBench},
            {"Bench Top Slot", testBench}
          },
          Name -> {
            "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID,
            "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID
          }
        ];

        UploadSample[
          {
            Model[Sample, "Benzoic acid"],
            Model[Sample, "Benzoic acid"]
          },
          {
            {"A1", Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID]},
            {"A1", Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID]}
          },
          InitialAmount-> {
            1.3 Gram,
            1.3 Gram
          },
          Name->{
            "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID,
            "Grind Test Sample for ValidExperimentGrindQ 2" <> $SessionUUID
          }
        ];
      ];
    ];


    (* upload needed objects *)
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    EraseObject[Flatten[{
      $CreatedObjects,

      (* Sample Objects *)
      Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 1" <> $SessionUUID],
      Object[Sample, "Grind Test Sample for ValidExperimentGrindQ 2" <> $SessionUUID],

      (* Container Objects *)
      Object[Container, Bench, "Test Bench for ValidExperimentGrindQ" <> $SessionUUID],
      Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 1" <> $SessionUUID],
      Object[Container, Vessel, "Grind Test Container for ValidExperimentGrindQ 2" <> $SessionUUID]
    }],
      Force->True, Verbose->False];
  )
];

(* ::Subsection::Closed:: *)
(*PreferredGrinder*)


DefineTests[PreferredGrinder,
  {
    (* --- Basic --- *)
    Example[
      {Basic, "Selects the preferred grinder for 1 g of a solid sample:"},
      PreferredGrinder[1 Gram],
      ObjectP[Model[Instrument, Grinder]]
    ],

    (* --- Grind Options --- *)
    Example[
      {Options, GrinderType, "Selects the preferred grinder for 10 g of a solid sample when GrinderType is KnifeMill:"},
      grinder = PreferredGrinder[10Gram, GrinderType -> KnifeMill];
      Download[grinder, GrinderType],
      KnifeMill,
      Variables :> {grinder}
    ],
    Example[
      {Options, GrinderType, "Selects the preferred grinder for 50 g of a solid sample when GrinderType is MortarGrinder:"},
      grinder = PreferredGrinder[50Gram, GrinderType -> MortarGrinder];
      Download[grinder, GrinderType],
      MortarGrinder,
      Variables :> {grinder}
    ],
    Example[
      {Options, GrinderType, "Selects the preferred grinder for 10 g of a solid sample when GrinderType is BallMill:"},
      grinder = PreferredGrinder[10Gram, GrinderType -> BallMill];
      Download[grinder, GrinderType],
      BallMill,
      Variables :> {grinder}
    ],
    Example[
      {Options, Fineness, "Selects the preferred grinder for 10 g of a solid sample that has a fineness of 3 mm:"},
      grinder = PreferredGrinder[10Gram, Fineness -> 3Millimeter];
      Download[grinder, FeedFineness],
      3Millimeter,
      Variables :> {grinder},
      EquivalenceFunction :> GreaterEqual
    ],
    Example[
      {Options, BulkDensity, "Selects the preferred grinder for 10 g of a solid sample that has a bulk density of of 0.5 g/mL:"},
      grinder = PreferredGrinder[10Gram, BulkDensity -> 0.5 Gram/Milliliter];
      Download[grinder, MaxAmount],
      20Milliliter,
      Variables :> {grinder},
      EquivalenceFunction :> GreaterEqual
    ],

    (* ---  Messages --- *)
    Example[{Messages, "LargeParticles", "Throw a warning if the particle size is greater than 10 mm as 10 mm is currently the max feed fineness of the available grinders:"},
      PreferredGrinder[10Gram, Fineness -> 20Millimeter],
      ObjectP[Model[Instrument, Grinder]],
      Messages :> {
        Message[Error::LargeParticles]
      }
    ],
    Example[{Messages, "InsufficientAmount", "Throw a warning if the amount of the sample is too small:"},
      PreferredGrinder[1Milligram],
      ObjectP[Model[Instrument, Grinder]],
      Messages :> {
        Message[Warning::InsufficientAmount]
      }
    ],
    Example[{Messages, "ExcessiveAmount", "Throw a warning if the amount of the sample is too much:"},
      PreferredGrinder[300Gram],
      ObjectP[Model[Instrument, Grinder]],
      Messages :> {
        Message[Warning::ExcessiveAmount]
      }
    ]
  }
];
