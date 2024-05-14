(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentDesiccate*)


DefineTests[ExperimentDesiccate,
  {
    (* --- Basic --- *)
    Example[
      {Basic, "Creates a protocol to desiccate a solid sample:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, Desiccate]]
    ],
    Example[
      {Basic, "Accepts an input container containing a solid sample:"},
      ExperimentDesiccate[
        Object[Container, Vessel, "Desiccation test container 1 " <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, Desiccate]]
    ],
    Example[
      {Basic, "Desiccates a list of inputs (samples or containers) containing solid samples:"},
      ExperimentDesiccate[
        {
          Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          Object[Sample, "Desiccation Test Sample 2 " <> $SessionUUID],
          Object[Sample, "Desiccation Test Sample 3 " <> $SessionUUID],
          Object[Sample, "Desiccation Test Sample 4 " <> $SessionUUID],
          Object[Sample, "Desiccation Test Sample 5 " <> $SessionUUID],
          Object[Container, Vessel, "Desiccation test container 6 " <> $SessionUUID],
          Object[Container, Vessel, "Desiccation test container 7 " <> $SessionUUID],
          Object[Container, Vessel, "Desiccation test container 8 " <> $SessionUUID],
          Object[Container, Vessel, "Desiccation test container 9 " <> $SessionUUID],
          Object[Container, Vessel, "Desiccation test container 10 " <> $SessionUUID]
        }
      ],
      ObjectP[Object[Protocol, Desiccate]]
    ],

    (* Output Options *)
    Example[
      {Basic, "Generates a list of tests if Output is set to Tests:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Output -> Tests
      ],
      {_EmeraldTest..}
    ],
    Example[
      {Basic, "Generates a simulation if output is set to Simulation:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Output -> Simulation
      ],
      SimulationP
    ],
    (* --- Desiccate Options --- *)
    Example[
      {Options, Amount, "Determines the amount of the sample for desiccation:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Output -> Options,
        Amount -> 1 Gram
      ];
      Lookup[options, Amount],
      1 Gram,
      Variables :> {options}
    ],

    Example[
      {Options, SampleContainer, "Determines the container which the sample Amount is transferred into before desiccation:"},
      options = ExperimentDesiccate[
          Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          SampleContainer -> Model[Container, Vessel, "50mL Tube"],
          Output -> Options
      ];
      Lookup[options, SampleContainer],
      ObjectP[Model[Container, Vessel, "50mL Tube"]],
      Variables :> {options}
    ],
    Example[
      {Options, SampleContainerLabel, "Determines a value for labeling the sample container:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        SampleContainerLabel -> "Max E. Mumm's desiccation container sample",
        Output -> Options
      ];
      Lookup[options, SampleContainerLabel],
      "Max E. Mumm's desiccation container sample",
      Variables :> {options}
    ],
    Example[
      {Options, Method, "Determines the Method of drying the sample in the desiccator:"},
      options = ExperimentDesiccate[
          Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          Method -> Vacuum,
          Output -> Options
        ];
      Lookup[options, Method],
      Vacuum,
      Variables :> {options}
    ],

    Example[
      {Options, Desiccant, "Determines the desiccant:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 2 " <> $SessionUUID],
        Desiccant -> Object[Sample, "Desiccation Test Sample 15 " <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Desiccant],
      ObjectP[Object[Sample, "Desiccation Test Sample 15 " <> $SessionUUID]],
      Variables :> {options}
    ],

    Example[
      {Options, DesiccantPhase, "Determines the physical state of the desiccant:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        DesiccantPhase -> Solid,
        Output -> Options
      ];
      Lookup[options, DesiccantPhase],
      Solid,
      Variables :> {options}
    ],
    Example[
      {Options, DesiccantAmount, "Determines the Amount of the desiccant to be used in the desiccator:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        DesiccantAmount -> 250 Gram,
        Output -> Options
      ];
      Lookup[options, DesiccantAmount],
      Quantity[250, "Gram"],
      Variables :> {options}
    ],
    Example[
      {Options, Desiccator, "Determines the instrument that is used for desiccation:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Desiccator -> Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"],
        Output -> Options
      ];
      Lookup[options, Desiccator],
      ObjectP[Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"]],
      Variables :> {options}
    ],
    Example[
      {Options, Time, "Determines the duration that the sample is desiccated inside the desiccator:"},
      options = ExperimentDesiccate[
          Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          Time -> 24 Hour,
          Output -> Options
        ];
      Lookup[options, Time],
      Quantity[24, "Hour"],
      Variables :> {options}
    ],
    Example[
      {Options, SampleLabel, "Determines a value for labeling the sample:"},
      options = ExperimentDesiccate[
          Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          SampleLabel -> "Max E. Mumm's sample",
          Output -> Options
        ];
      Lookup[options, SampleLabel],
      "Max E. Mumm's sample",
      Variables :> {options}
    ],
    Example[
      {Options, SampleOutLabel, "Determines a value for labeling the output sample:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        SampleOutLabel -> "Max E. Mumm's desiccated sample",
        Output -> Options
      ];
      Lookup[options, SampleOutLabel],
      "Max E. Mumm's desiccated sample",
      Variables :> {options}
    ],
    Example[
      {Options, ContainerOut, "Determines the container that the output samples (SamplesOut) are transferred into:"},
      options = ExperimentDesiccate[
          Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          ContainerOut -> Object[Container, Vessel, "Desiccation test container 2 " <> $SessionUUID],
          Output -> Options
        ];
      Lookup[options, ContainerOut],
      ObjectP[Object[Container, Vessel, "Desiccation test container 2 " <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[
      {Options, ContainerOutLabel, "Determines a value for labeling the output container:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        ContainerOutLabel -> "Max E. Mumm's output container",
        Output -> Options
      ];
      Lookup[options, ContainerOutLabel],
      "Max E. Mumm's output container",
      Variables :> {options}
    ],
    Example[
      {Options, SamplesOutStorageCondition, "Determines the storage condition of the output samples (SampleOut):"},
      options = ExperimentDesiccate[
          Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          SamplesOutStorageCondition -> Model[StorageCondition, "Ambient Storage, Desiccated"],
          Output -> Options
        ];
      Lookup[options, SamplesOutStorageCondition],
      ObjectP[Model[StorageCondition, "Ambient Storage, Desiccated"]],
      Variables :> {options}
    ],

    (* --- Shared Options --- *)
    Example[{Options, PreparatoryUnitOperations, "Specifies prepared samples for ExperimentDesiccate (PreparatoryUnitOperations):"},
      Lookup[ExperimentDesiccate["My Desiccation Sample",
        PreparatoryUnitOperations -> {
          LabelContainer[
            Label -> "My Desiccation Sample",
            Container -> Model[Container, Vessel, "2mL Tube"]
          ],
          Transfer[
            Source -> {
              Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
              Object[Sample, "Desiccation Test Sample 2 " <> $SessionUUID]
            },
            Destination -> "My Desiccation Sample",
            Amount -> {0.1 Gram, 0.2 Gram}
          ]
        },
        Output -> Options
      ], PreparatoryUnitOperations],
      {SamplePreparationP..}
    ],
    Example[{Options, PreparatoryPrimitives, "Specifies prepared samples for ExperimentDesiccate (PreparatoryPrimitives):"},
      ExperimentDesiccate["My Desiccation Container",
        PreparatoryPrimitives -> {
          Define[
            Name -> "My Desiccation Container",
            Container -> Model[Container, Vessel, "2mL Tube"]
          ],
          Transfer[
            Source -> Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
            Amount -> 0.1 Gram,
            Destination -> "My Desiccation Container"
          ]
        },
        Output -> Options
      ],
      {_Rule..}
    ],
    Example[
      {Options, Name, "Uses an object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
      Lookup[
        ExperimentDesiccate[
          Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          Name -> "Max E. Mumm's Desiccation Sample",
          Output -> Options
        ],
        Name
      ],
      "Max E. Mumm's Desiccation Sample"
    ],
    Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
      Lookup[
        ExperimentDesiccate[Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          MeasureWeight -> True,
          Output -> Options],
        MeasureWeight
      ],
      True
    ],
    Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
      Lookup[
        ExperimentDesiccate[Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
          MeasureWeight -> True,
          Output -> Options],
        MeasureVolume
      ],
      True
    ],
    Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be imaged after running the experiment:"},
      options = ExperimentDesiccate[Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        ImageSample -> True,
        Output -> Options
      ];
      Lookup[options, ImageSample],
      True,
      Variables :> {options}
    ],
    Example[{Options,Template,"Inherits options from a previously run desiccation protocol:"},
      options = ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Template -> Object[Protocol, Desiccate, "Test Desiccate option template protocol" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, DesiccantAmount],
      500 Gram,
      Variables :> {options}
    ],

    (* ---  Messages --- *)
    Example[{Messages, "NonSolidSample", "All samples are solid:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 11 " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Message[Error::NonSolidSample],
        Message[Error::MissingMassInformation],
        Message[Error::InvalidInput]
      }
    ],
    Example[{Messages, "MissingDesiccantPhaseInformation", "The physical state of the desiccant must be informed:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Desiccant -> Model[Sample, "Test no-state sample 1 " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Message[Error::MissingDesiccantPhaseInformation],
        Message[Error::MissingDesiccantAmount],
        Message[Error::InvalidOption]
      }
    ],
    Example[{Messages, "InvalidDesiccantPhaseInformation", "The physical state of the desiccant must be solid or liquid:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Desiccant -> Model[Sample, "Test gas sample 1 " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Message[Error::InvalidDesiccantPhaseInformation],
        Message[Error::InvalidOption]
      }
    ],
    Example[{Messages, "MissingDesiccantAmount", "DesiccantAmount is specified or automatically resolved based on the physical state of the desiccant:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Desiccant -> Model[Sample, "Test no-state sample 1 " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Message[Error::MissingDesiccantPhaseInformation],
        Message[Error::MissingDesiccantAmount],
        Message[Error::InvalidOption]
      }
    ],
    Example[{Messages, "DesiccantAmountInformedForVacuumMethod", "DesiccantAmount is not specified if Method is Vacuum:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Method -> Vacuum,
        DesiccantAmount -> 200 Gram
      ],
      $Failed,
      Messages :> {
        Message[Error::DesiccantAmountInformedForVacuumMethod],
        Message[Error::InvalidOption]
      }
    ],
    Example[{Messages, "MethodAndDesiccantPhaseMismatch", "Method and DesiccantPhase do not conflict (if DesiccantPhase is Liquid, Method can NOT be Vacuum or DesiccantUnderVacuum):"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Desiccant -> Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
        Method -> DesiccantUnderVacuum
      ],
      $Failed,
      Messages :> {
        Message[Error::MethodAndDesiccantPhaseMismatch],
        Message[Error::InvalidOption]
      }
    ],
    Example[{Messages, "DesiccantPhaseAndAmountMismatch", "The unit of DesiccantAmount does matches the State of the Desiccant:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Desiccant -> Object[Sample, "Desiccation Test Sample 15 " <> $SessionUUID],
        DesiccantAmount -> 100 Milliliter
      ],
      $Failed,
      Messages :> {
        Message[Error::DesiccantPhaseAndAmountMismatch],
        Message[Error::InvalidOption]
      }
    ],
    Example[{Messages, "InvalidSamplesOutStorageCondition", "SamplesOutStorageCondition is informed if DefaultStorageCondition is not informed in Desiccant sample model:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 12 " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Message[Error::InvalidSamplesOutStorageCondition],
        Message[Error::InvalidOption]
      }
    ],
    Example[{Messages, "InsufficientDesiccantAmount", "The amount of the desiccant is Greater than or equal to 100 Gram or 100 Milliliter:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        DesiccantAmount -> 99 Gram
      ],
      ObjectP[Object[Protocol, Desiccate]],
      Messages :> {
        Message[Warning::InsufficientDesiccantAmount]
      }
    ],
    Example[{Messages, "MissingMassInformation", "The Mass of the sample is informed:"},
      ExperimentDesiccate[
        Object[Sample, "Desiccation Test Sample 14 " <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Message[Error::MissingMassInformation],
        Message[Error::InvalidInput]
      }
    ]
  },
  SetUp :> (ClearMemoization[]),
  SymbolSetUp :> (

    (* Turn off the lab state warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::SimilarMolecules];

    $CreatedObjects = {};

    Module[
      {
        objects, existsFilter
      },

      (* list of test objects*)
      objects = {
        Object[Container, Vessel, "Desiccation test container 1 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 2 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 3 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 4 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 5 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 6 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 7 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 8 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 9 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 10 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 11 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 12 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 13 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 14 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 15 " <> $SessionUUID],

        (* identity models *)
        Model[Molecule, "Test NaCl Molecule " <> $SessionUUID],
        Model[Molecule, "Test CaO Molecule " <> $SessionUUID],
        Model[Molecule, "Test Helium Molecule " <> $SessionUUID],

        (* sample models *)
        Model[Sample, "Test solid sample 1 " <> $SessionUUID],
        Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
        Model[Sample, "Test no-state sample 1 " <> $SessionUUID],
        Model[Sample, "Test no-StorageCondition sample 1 " <> $SessionUUID],
        Model[Sample, "Test gas sample 1 " <> $SessionUUID],


        (* sample objects *)
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 2 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 3 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 4 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 5 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 6 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 7 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 8 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 9 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 10 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 11 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 12 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 13 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 14 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 15 " <> $SessionUUID],

        (* Protocol Object *)
        Object[Protocol, Desiccate, "Test Desiccate option template protocol" <> $SessionUUID]
      };


      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];

    (* create all the containers and identity models, and Cartridges *)
    Block[{$DeveloperUpload = True},
      Module[
        {
          testContainer1, testContainer2, testContainer3, testContainer4, testContainer5, testContainer6, testContainer7, testContainer8, testContainer9, testContainer10, testContainer11, testContainer12, testContainer13, testContainer14, testContainer15, testMoleculeModels, solidSampleModelPacket, noStateSampleModelPacket, noStorageConditionModelPacket, liquidSampleModelPacket, testSampleModels, gasModelPacket, testSampleLocations, testSampleAmounts, testSampleNames, testSamples
        },

        {
          testContainer1,
          testContainer2,
          testContainer3,
          testContainer4,
          testContainer5,
          testContainer6,
          testContainer7,
          testContainer8,
          testContainer9,
          testContainer10,
          testContainer11,
          testContainer12,
          testContainer13,
          testContainer14,
          testContainer15
        } = Upload[{
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 1 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 2 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 3 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 4 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 5 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 6 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 7 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 8 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 9 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 10 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 11 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 12 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 13 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
            Name -> "Desiccation test container 14 " <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type -> Object[Container, Vessel],
            Model -> Link[Model[Container, Vessel, "Pyrex Crystallization Dish"], Objects],
            Name -> "Desiccation test container 15 " <> $SessionUUID,
            DeveloperObject -> True
          |>
        }];

        (* create all models *)
        testMoleculeModels = UploadMolecule[
          {
            "InChI=1S/ClH.Na/h1H;/q;+1/p-1",
            "1305-78-8",
            "InChI=1S/He"
          },
          Name -> {
            "Test NaCl Molecule " <> $SessionUUID,
            "Test CaO Molecule " <> $SessionUUID,
            "Test Helium Molecule " <> $SessionUUID
          },
          BiosafetyLevel -> {"BSL-1", "BSL-1", "BSL-1"},
          IncompatibleMaterials -> {{None}, {None}, {None}},
          MSDSRequired -> {False, False, False},
          State -> {Solid, Solid, Gas},
          CAS -> Null
        ];

        solidSampleModelPacket = UploadSampleModel[
					"Test solid sample 1 " <> $SessionUUID,
          Composition -> {{100 MassPercent, Model[Molecule, "Test NaCl Molecule " <> $SessionUUID]}},
          MSDSRequired -> False,
          DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
          Flammable -> False,
          Acid -> False,
          Base -> False,
          Pyrophoric -> False,
          NFPA -> {0, 0, 0, Null},
          DOTHazardClass -> "Class 0",
          IncompatibleMaterials -> {None},
          Expires -> False,
          State -> Solid,
          BiosafetyLevel -> "BSL-1",
          Upload -> False
        ];

        gasModelPacket = UploadSampleModel[
					"Test gas sample 1 " <> $SessionUUID,
          Composition -> {{100 MassPercent, Model[Molecule, "Test Helium Molecule " <> $SessionUUID]}},
          MSDSRequired -> False,
          DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
          Flammable -> False,
          Acid -> False,
          Base -> False,
          Pyrophoric -> False,
          NFPA -> {0, 0, 0, Null},
          DOTHazardClass -> "Class 0",
          IncompatibleMaterials -> {None},
          Expires -> False,
          State -> Gas,
          BiosafetyLevel -> "BSL-1",
          Upload -> False
        ];

        noStateSampleModelPacket = UploadSampleModel["Test no-state sample 1 " <> $SessionUUID,
          Composition -> {{100 MassPercent, Model[Molecule, "Test NaCl Molecule " <> $SessionUUID]}},
          MSDSRequired -> False,
          DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
          Flammable -> False,
          Acid -> False,
          Base -> False,
          Pyrophoric -> False,
          NFPA -> {0, 0, 0, Null},
          DOTHazardClass -> "Class 0",
          IncompatibleMaterials -> {None},
          Expires -> False,
          State -> Gas,
          BiosafetyLevel -> "BSL-1",
          Upload -> False
        ];

        noStorageConditionModelPacket = UploadSampleModel["Test no-StorageCondition sample 1 " <> $SessionUUID,
          Composition -> {{100 MassPercent, Model[Molecule, "Test NaCl Molecule " <> $SessionUUID]}},
          MSDSRequired -> False,
          DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
          Flammable -> False,
          Acid -> False,
          Base -> False,
          Pyrophoric -> False,
          NFPA -> {0, 0, 0, Null},
          DOTHazardClass -> "Class 0",
          IncompatibleMaterials -> {None},
          Expires -> False,
          State -> Solid,
          BiosafetyLevel -> "BSL-1",
          Upload -> False
        ];

        liquidSampleModelPacket = UploadSampleModel["Test liquid sample 1 " <> $SessionUUID,
          Composition -> {{100 VolumePercent, Model[Molecule, "Water"]}},
          MSDSRequired -> False,
          DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
          Flammable -> False,
          Acid -> False,
          Base -> False,
          Pyrophoric -> False,
          NFPA -> {0, 0, 0, Null},
          DOTHazardClass -> "Class 0",
          IncompatibleMaterials -> {None},
          Expires -> False,
          State -> Liquid,
          BiosafetyLevel -> "BSL-1",
          Upload -> False
        ];

        (* Upload all models *)
        Upload[Join[solidSampleModelPacket, gasModelPacket, noStateSampleModelPacket, liquidSampleModelPacket, noStorageConditionModelPacket]];

				(* Upload test samples *)
        testSampleModels = Flatten@{
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
          Model[Sample, "Test no-StorageCondition sample 1 " <> $SessionUUID],
          Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID],
          Model[Sample, "Test solid sample 1 " <> $SessionUUID]
        };

        testSampleLocations = {
          {"A1", Object[Container, Vessel, "Desiccation test container 1 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 2 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 3 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 4 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 5 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 6 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 7 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 8 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 9 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 10 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 11 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 12 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 13 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 14 " <> $SessionUUID]},
          {"A1", Object[Container, Vessel, "Desiccation test container 15 " <> $SessionUUID]}
        };

        testSampleAmounts = Flatten@{
          1.8 Gram,
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
          Null,
          500 Gram
        };

        testSampleNames = Flatten@{
          "Desiccation Test Sample 1 " <> $SessionUUID,
          "Desiccation Test Sample 2 " <> $SessionUUID,
          "Desiccation Test Sample 3 " <> $SessionUUID,
          "Desiccation Test Sample 4 " <> $SessionUUID,
          "Desiccation Test Sample 5 " <> $SessionUUID,
          "Desiccation Test Sample 6 " <> $SessionUUID,
          "Desiccation Test Sample 7 " <> $SessionUUID,
          "Desiccation Test Sample 8 " <> $SessionUUID,
          "Desiccation Test Sample 9 " <> $SessionUUID,
          "Desiccation Test Sample 10 " <> $SessionUUID,
          "Desiccation Test Sample 11 " <> $SessionUUID,
          "Desiccation Test Sample 12 " <> $SessionUUID,
          "Desiccation Test Sample 13 " <> $SessionUUID,
          "Desiccation Test Sample 14 " <> $SessionUUID,
          "Desiccation Test Sample 15 " <> $SessionUUID
        };


        (* create some samples in the above containers*)
        testSamples = UploadSample[
          testSampleModels,
          testSampleLocations,
          InitialAmount -> testSampleAmounts,
          Name -> testSampleNames,
          StorageCondition -> AmbientStorage,
          FastTrack -> True
        ];

        (* Remove fields form objects and create a test template protocol *)
        Upload[{
          <|Object -> Model[Sample, "Test no-state sample 1 " <> $SessionUUID], State -> Null|>,
          <|Object -> Model[Sample, "Test no-StorageCondition sample 1 " <> $SessionUUID], DefaultStorageCondition -> Null|>,
          <|Object -> Object[Sample, "Desiccation Test Sample 12 " <> $SessionUUID], StorageCondition -> Null|>,
          <|
            Type->Object[Protocol, Desiccate],
            Name->"Test Desiccate option template protocol" <> $SessionUUID,
            ResolvedOptions->{DesiccantAmount -> 500 Gram}
          |>
        }];
      ]
    ]
  ),
  SymbolTearDown :> {
    Module[{objects, existsFilter},
      On[Warning::SamplesOutOfStock];
      On[Warning::InstrumentUndergoingMaintenance];


      (* list of test objects*)
      objects = Cases[Flatten[{
        $CreatedObjects,
        Object[Container, Vessel, "Desiccation test container 1 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 2 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 3 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 4 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 5 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 6 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 7 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 8 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 9 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 10 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 11 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 12 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 13 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 14 " <> $SessionUUID],
        Object[Container, Vessel, "Desiccation test container 15 " <> $SessionUUID],

        (* identity models *)
        Model[Molecule, "Test NaCl Molecule " <> $SessionUUID],
        Model[Molecule, "Test CaO Molecule " <> $SessionUUID],
        Model[Molecule, "Test Helium Molecule " <> $SessionUUID],

        (* sample models *)
        Model[Sample, "Test solid sample 1 " <> $SessionUUID],
        Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
        Model[Sample, "Test no-state sample 1 " <> $SessionUUID],
        Model[Sample, "Test no-StorageCondition sample 1 " <> $SessionUUID],
        Model[Sample, "Test gas sample 1 " <> $SessionUUID],


        (* sample objects *)
        Object[Sample, "Desiccation Test Sample 1 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 2 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 3 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 4 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 5 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 6 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 7 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 8 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 9 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 10 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 11 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 12 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 13 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 14 " <> $SessionUUID],
        Object[Sample, "Desiccation Test Sample 15 " <> $SessionUUID],

        (* protocol objects *)
        Object[Protocol, Desiccate, "Test Desiccate option template protocol" <> $SessionUUID]

      }], ObjectP[]];

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];

      Unset[$CreatedObjects];
    ];
  },
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];
(* ::Subsection::Closed:: *)
(*ExperimentDesiccateOptions*)


DefineTests[
  ExperimentDesiccateOptions,
  {
    (* --- Basic Examples --- *)
    Example[
      {Basic, "Generate a table of resolved options for an ExperimentDesiccate call desiccate a single sample:"},
      ExperimentDesiccateOptions[Object[Sample, "Desiccate Test Sample for ExperimentDesiccateOptions 1" <> $SessionUUID]],
      _Grid
    ],
    Example[
      {Basic, "Generate a table of resolved options for an ExperimentDesiccate call desiccate a single container:"},
      ExperimentDesiccateOptions[Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccateOptions 1" <> $SessionUUID]],
      _Grid
    ],
    Example[
      {Basic, "Generate a table of resolved options for an ExperimentDesiccate call desiccate a sample and a container the same time:"},
      ExperimentDesiccateOptions[{
        Object[Sample, "Desiccate Test Sample for ExperimentDesiccateOptions 1" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccateOptions 2" <> $SessionUUID]
      }],
      _Grid
    ],

    (* --- Options Examples --- *)
    Example[
      {Options, OutputFormat, "Generate a resolved list of options for an ExperimentDesiccate call desiccate a single container:"},
      ExperimentDesiccateOptions[Object[Sample, "Desiccate Test Sample for ExperimentDesiccateOptions 1" <> $SessionUUID], OutputFormat->List],
      _?(MatchQ[
        Check[SafeOptions[ExperimentDesiccate, #], $Failed, {Error::Pattern}],
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
        Object[Sample, "Desiccate Test Sample for ExperimentDesiccateOptions 1" <> $SessionUUID],
        Object[Sample, "Desiccate Test Sample for ExperimentDesiccateOptions 2" <> $SessionUUID],

        (* Container Objects *)
        Object[Container, Bench, "Test Bench for ExperimentDesiccateOptions" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccateOptions 1" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccateOptions 2" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force->True, Verbose->False]];
    ];

    Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench,"The Bench of Testing"], Objects],
          Name -> "Test Bench for ExperimentDesiccateOptions" <> $SessionUUID,
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
            "Desiccate Test Container for ExperimentDesiccateOptions 1" <> $SessionUUID,
            "Desiccate Test Container for ExperimentDesiccateOptions 2" <> $SessionUUID
          }
        ];

        UploadSample[
          {
            Model[Sample, "Benzoic acid"],
            Model[Sample, "Benzoic acid"]
          },
          {
            {"A1", Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccateOptions 1" <> $SessionUUID]},
            {"A1", Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccateOptions 2" <> $SessionUUID]}
          },
          InitialAmount-> {
            1.3 Gram,
            1.3 Gram
          },
          Name->{
            "Desiccate Test Sample for ExperimentDesiccateOptions 1" <> $SessionUUID,
            "Desiccate Test Sample for ExperimentDesiccateOptions 2" <> $SessionUUID
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
      Object[Sample, "Desiccate Test Sample for ExperimentDesiccateOptions 1" <> $SessionUUID],
      Object[Sample, "Desiccate Test Sample for ExperimentDesiccateOptions 2" <> $SessionUUID],

      (* Container Objects *)
      Object[Container, Bench, "Test Bench for ExperimentDesiccateOptions" <> $SessionUUID],
      Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccateOptions 1" <> $SessionUUID],
      Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccateOptions 2" <> $SessionUUID]
    }],
      Force->True, Verbose->False];
  )
];



(* ::Subsection::Closed:: *)
(*ExperimentDesiccatePreview*)


DefineTests[
  ExperimentDesiccatePreview,
  {
    (* --- Basic Examples --- *)
    Example[
      {Basic, "Generate a preview for an ExperimentDesiccate call desiccate of a single container (will always be Null:"},
      ExperimentDesiccatePreview[Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccatePreview 1" <> $SessionUUID]],
      Null
    ],
    Example[
      {Basic, "Generate a preview for an ExperimentDesiccate call desiccate of two containers at the same time:"},
      ExperimentDesiccatePreview[{
        Object[Sample, "Desiccate Test Sample for ExperimentDesiccatePreview 1" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccatePreview 2" <> $SessionUUID]
      }],
      Null
    ],
    Example[
      {Basic, "Generate a preview for an ExperimentDesiccate call desiccate of a single sample:"},
      ExperimentDesiccatePreview[Object[Sample, "Desiccate Test Sample for ExperimentDesiccatePreview 1" <> $SessionUUID]],
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
        Object[Sample, "Desiccate Test Sample for ExperimentDesiccatePreview 1" <> $SessionUUID],
        Object[Sample, "Desiccate Test Sample for ExperimentDesiccatePreview 2" <> $SessionUUID],

        (* Container Objects *)
        Object[Container, Bench, "Test Bench for ExperimentDesiccatePreview" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccatePreview 1" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccatePreview 2" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force->True, Verbose->False]];
    ];

    Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench,"The Bench of Testing"], Objects],
          Name -> "Test Bench for ExperimentDesiccatePreview" <> $SessionUUID,
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
            "Desiccate Test Container for ExperimentDesiccatePreview 1" <> $SessionUUID,
            "Desiccate Test Container for ExperimentDesiccatePreview 2" <> $SessionUUID
          }
        ];

        UploadSample[
          {
            Model[Sample, "Benzoic acid"],
            Model[Sample, "Benzoic acid"]
          },
          {
            {"A1", Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccatePreview 1" <> $SessionUUID]},
            {"A1", Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccatePreview 2" <> $SessionUUID]}
          },
          InitialAmount-> {
            1.3 Gram,
            1.3 Gram
          },
          Name->{
            "Desiccate Test Sample for ExperimentDesiccatePreview 1" <> $SessionUUID,
            "Desiccate Test Sample for ExperimentDesiccatePreview 2" <> $SessionUUID
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
      Object[Sample, "Desiccate Test Sample for ExperimentDesiccatePreview 1" <> $SessionUUID],
      Object[Sample, "Desiccate Test Sample for ExperimentDesiccatePreview 2" <> $SessionUUID],

      (* Container Objects *)
      Object[Container, Bench, "Test Bench for ExperimentDesiccatePreview" <> $SessionUUID],
      Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccatePreview 1" <> $SessionUUID],
      Object[Container, Vessel, "Desiccate Test Container for ExperimentDesiccatePreview 2" <> $SessionUUID]
    }],
      Force->True, Verbose->False];
  )
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDesiccateQ*)


DefineTests[
  ValidExperimentDesiccateQ,
  {
    (* --- Basic Examples --- *)
    Example[
      {Basic, "Validate an ExperimentDesiccate call to Desiccate a single container:"},
      ValidExperimentDesiccateQ[Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 1" <> $SessionUUID]],
      True
    ],
    Example[
      {Basic, "Validate an ExperimentDesiccate call to Desiccate two containers at the same time:"},
      ValidExperimentDesiccateQ[{
        Object[Sample, "Desiccate Test Sample for ValidExperimentDesiccateQ 1" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 2" <> $SessionUUID]
      }],
      True
    ],
    Example[
      {Basic, "Validate an ExperimentDesiccate call to Desiccate a single sample:"},
      ValidExperimentDesiccateQ[Object[Sample, "Desiccate Test Sample for ValidExperimentDesiccateQ 1" <> $SessionUUID]],
      True
    ],

    (* --- Options Examples --- *)
    Example[
      {Options, OutputFormat, "Validate an ExperimentDesiccate call to Desiccate a single container, returning an ECL Test Summary:"},
      ValidExperimentDesiccateQ[Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 1" <> $SessionUUID], OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[
      {Options, Verbose, "Validate an ExperimentDesiccate call desiccate of a single container, printing a verbose summary of tests as they are run:"},
      ValidExperimentDesiccateQ[Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 1" <> $SessionUUID], Verbose->True],
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
        Object[Sample, "Desiccate Test Sample for ValidExperimentDesiccateQ 1" <> $SessionUUID],
        Object[Sample, "Desiccate Test Sample for ValidExperimentDesiccateQ 2" <> $SessionUUID],

        (* Container Objects *)
        Object[Container, Bench, "Test Bench for ValidExperimentDesiccateQ" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 1" <> $SessionUUID],
        Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 2" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force->True, Verbose->False]];
    ];

    Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench,"The Bench of Testing"], Objects],
          Name -> "Test Bench for ValidExperimentDesiccateQ" <> $SessionUUID,
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
            "Desiccate Test Container for ValidExperimentDesiccateQ 1" <> $SessionUUID,
            "Desiccate Test Container for ValidExperimentDesiccateQ 2" <> $SessionUUID
          }
        ];

        UploadSample[
          {
            Model[Sample, "Benzoic acid"],
            Model[Sample, "Benzoic acid"]
          },
          {
            {"A1", Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 1" <> $SessionUUID]},
            {"A1", Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 2" <> $SessionUUID]}
          },
          InitialAmount-> {
            1.3 Gram,
            1.3 Gram
          },
          Name->{
            "Desiccate Test Sample for ValidExperimentDesiccateQ 1" <> $SessionUUID,
            "Desiccate Test Sample for ValidExperimentDesiccateQ 2" <> $SessionUUID
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
      Object[Sample, "Desiccate Test Sample for ValidExperimentDesiccateQ 1" <> $SessionUUID],
      Object[Sample, "Desiccate Test Sample for ValidExperimentDesiccateQ 2" <> $SessionUUID],

      (* Container Objects *)
      Object[Container, Bench, "Test Bench for ValidExperimentDesiccateQ" <> $SessionUUID],
      Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 1" <> $SessionUUID],
      Object[Container, Vessel, "Desiccate Test Container for ValidExperimentDesiccateQ 2" <> $SessionUUID]
    }],
      Force->True, Verbose->False];
  )
];
