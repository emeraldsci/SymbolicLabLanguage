(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*Primitive Framework: Primitives*)

(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(* AbsorbanceIntensity *)
DefineTests[AbsorbanceIntensity,
    {
      Example[{Basic, "Set up a plate to run an AbsorbanceIntensity protocol:"},
        ExperimentSamplePreparation[{
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Plate, "96-well UV-Star Plate"]
          ],
          Transfer[
            Source->Model[Sample, "Red Food Dye"],
            Destination->{
              {"A1","my container"},
              {"A2","my container"},
              {"A3","my container"}
            },
            Amount->150 Microliter
          ],
          AbsorbanceIntensity[
            Sample->"my container"
          ]
        }],
        ObjectP[Object[Protocol, ManualSamplePreparation]]
      ],
      Example[{Basic, "Options from ExperimentAbsorbanceIntensity can be used in the unit operation equivalently:"},
        ExperimentSamplePreparation[{
          AbsorbanceIntensity[
            Sample->Object[Sample,"AbsorbanceIntensity Unit Operation Test Sample"<>$SessionUUID],
            Temperature->30 Celsius
          ]
        }],
        ObjectP[Object[Protocol, RoboticSamplePreparation]]
      ],
      Example[{Basic, "Prepare an injection sample to be injected into the sample plate during the AbsorbanceIntensity run:"},
        ExperimentSamplePreparation[{
          LabelContainer[
            Label->"my injection container",
            Container->Model[Container, Vessel, "2mL Tube"]
          ],
          Transfer[
            Source->Model[Sample, "Red Food Dye"],
            Destination->{"A1","my injection container"},
            DestinationLabel->"my injection sample",
            Amount->1.5 Milliliter
          ],
          AbsorbanceIntensity[
            Sample->Object[Sample,"AbsorbanceIntensity Unit Operation Test Sample"<>$SessionUUID],
            PrimaryInjectionSample->"my injection sample",
            PrimaryInjectionVolume->50 Microliter
          ]
        }],
        ObjectP[Object[Protocol, ManualSamplePreparation]]
      ]
    },
  SymbolSetUp:>Module[{platePacket,plate},
    $CreatedObjects={};
    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];

    platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well UV-Star Plate"],Objects],Site->Link[$Site],DeveloperObject->True|>;
    plate=Upload[platePacket];
    UploadSample[
      Model[Sample, "Red Food Dye"],
      {"A1",plate},
      InitialAmount->150 Microliter,
      Name->"AbsorbanceIntensity Unit Operation Test Sample"<>$SessionUUID
    ]
  ],
  SymbolTearDown:>Module[{},
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    On[Warning::SamplesOutOfStock];
  ],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];


(* ::Subsection::Closed:: *)
(* AbsorbanceKinetics *)
DefineTests[AbsorbanceKinetics,
  {
    Example[{Basic, "Set up a plate to run an AbsorbanceKinetics protocol:"},
      ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container, Plate, "96-well UV-Star Plate"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->{
            {"A1","my container"},
            {"A2","my container"},
            {"A3","my container"}
          },
          Amount->150 Microliter
        ],
        AbsorbanceKinetics[
          Sample->"my container"
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Example[{Basic, "Options from ExperimentAbsorbanceKinetics can be used in the unit operation equivalently:"},
      ExperimentSamplePreparation[{
        AbsorbanceKinetics[
          Sample->Object[Sample,"AbsorbanceKinetics Unit Operation Test Sample"<>$SessionUUID],
          Temperature->30 Celsius
        ]
      }],
      ObjectP[Object[Protocol, RoboticSamplePreparation]]
    ],
    Example[{Basic, "Prepare an injection sample to be injected into the sample plate during the AbsorbanceKinetics run:"},
      ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my injection container",
          Container->Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->{"A1","my injection container"},
          DestinationLabel->"my injection sample",
          Amount->1.5 Milliliter
        ],
        AbsorbanceKinetics[
          Sample->Object[Sample,"AbsorbanceKinetics Unit Operation Test Sample"<>$SessionUUID],
          PrimaryInjectionSample->"my injection sample",
          PrimaryInjectionVolume->50 Microliter,
          PrimaryInjectionTime->5 Minute
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ]
  },
  SymbolSetUp:>Module[{platePacket,plate},
    $CreatedObjects={};
    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];

    platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well UV-Star Plate"],Objects],Site->Link[$Site],DeveloperObject->True|>;
    plate=Upload[platePacket];
    UploadSample[
      Model[Sample, "Milli-Q water"],
      {"A1",plate},
      InitialAmount->150 Microliter,
      Name->"AbsorbanceKinetics Unit Operation Test Sample"<>$SessionUUID
    ]
  ],
  SymbolTearDown:>Module[{},
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    On[Warning::SamplesOutOfStock];
  ],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];



(* ::Subsection::Closed:: *)
(* AbsorbanceSpectroscopy *)
DefineTests[AbsorbanceSpectroscopy,
  {
    Example[{Basic, "Set up a plate to run an AbsorbanceSpectroscopy protocol:"},
      ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container, Plate, "96-well UV-Star Plate"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->{
            {"A1","my container"},
            {"A2","my container"},
            {"A3","my container"}
          },
          Amount->150 Microliter
        ],
        AbsorbanceSpectroscopy[
          Sample->"my container"
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Example[{Basic, "Set up a cuvette to run an AbsorbanceSpectroscopy protocol:"},
      ExperimentSamplePreparation[
        {
          LabelContainer[
            Label -> "my container",
            Container -> Model[Container, Cuvette, "id:eGakld01zz3E"]
          ],
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> "my container",
            Amount -> 1000 Microliter
          ],
          AbsorbanceSpectroscopy[
            Sample -> "my container",
            Methods -> Cuvette
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Example[{Basic, "Options from ExperimentAbsorbanceSpectroscopy can be used in the unit operation equivalently:"},
      ExperimentSamplePreparation[{
        AbsorbanceSpectroscopy[
          Sample->Object[Sample,"AbsorbanceSpectroscopy Unit Operation Test Sample"<>$SessionUUID],
          Temperature->30 Celsius
        ]
      }],
      ObjectP[Object[Protocol, RoboticSamplePreparation]]
    ],
    Example[{Basic, "Prepare an injection sample to be injected into the sample plate during the AbsorbanceSpectroscopy run:"},
      ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my injection container",
          Container->Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->{"A1","my injection container"},
          DestinationLabel->"my injection sample",
          Amount->1.5 Milliliter
        ],
        AbsorbanceSpectroscopy[
          Sample->Object[Sample,"AbsorbanceSpectroscopy Unit Operation Test Sample"<>$SessionUUID],
          PrimaryInjectionSample->"my injection sample",
          PrimaryInjectionVolume->50 Microliter
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ]
  },
  SymbolSetUp:>Module[{platePacket,plate},
    $CreatedObjects={};
    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];

    platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well UV-Star Plate"],Objects],Site->Link[$Site],DeveloperObject->True|>;
    plate=Upload[platePacket];
    UploadSample[
      Model[Sample, "Milli-Q water"],
      {"A1",plate},
      InitialAmount->150 Microliter,
      Name->"AbsorbanceSpectroscopy Unit Operation Test Sample"<>$SessionUUID
    ]
  ],
  SymbolTearDown:>Module[{},
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    On[Warning::SamplesOutOfStock];
  ]
];

DefineTests[AlphaScreen,
  {
    Example[{Basic, "Set up a plate to run an AlphaScreen protocol:"},
      ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container, Plate, "96-well UV-Star Plate"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->{
            {"A1","my container"},
            {"A2","my container"},
            {"A3","my container"}
          },
          Amount->150 Microliter
        ],
        AlphaScreen[
          Sample->"my container"
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Example[{Basic, "Options from ExperimentAlphaScreen can be used in the unit operation equivalently:"},
      ExperimentSamplePreparation[{
        AlphaScreen[
          Sample->Object[Sample,"AlphaScreen Unit Operation Test Sample"<>$SessionUUID],
          ReadTemperature->30 Celsius
        ]
      }],
      ObjectP[Object[Protocol, RoboticSamplePreparation]]
    ],
    Example[{Basic, "Use one prepared sample and on existing sample:"},
      ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container, Plate, "96-well UV-Star Plate"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->{"A1","my container"},
          DestinationLabel->"my second sample",
          Amount->150 Microliter
        ],
        AlphaScreen[
          Sample->{
            Object[Sample,"AlphaScreen Unit Operation Test Sample"<>$SessionUUID],
            "my second sample"
          }
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ]
  },
  SymbolSetUp:>Module[{platePacket,plate},
    $CreatedObjects={};
    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];

    platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well UV-Star Plate"],Objects],Site->Link[$Site],DeveloperObject->True|>;
    plate=Upload[platePacket];
    UploadSample[
      Model[Sample, "Milli-Q water"],
      {"A1",plate},
      InitialAmount->150 Microliter,
      Name->"AlphaScreen Unit Operation Test Sample"<>$SessionUUID
    ]
  ],
  SymbolTearDown:>Module[{},
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    On[Warning::SamplesOutOfStock];
  ],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];

(* ::Subsection::Closed:: *)
(* DynamicLightScattering *)
DefineTests[DynamicLightScattering,
  {
    Example[{Basic, "Set up a plate to run a DynamicLightScattering protocol:"},
      ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container, Plate, "96 well Flat Bottom DLS Plate"]
        ],
        Transfer[
          Source->Model[Sample, "40 kDa test protein Model[Sample] for DynamicLightScattering unit operation Tests" <> $SessionUUID],
          Destination->{
            {"A1","my container"},
            {"A2","my container"},
            {"A3","my container"}
          },
          Amount->110 Microliter
        ],
        DynamicLightScattering[
          Sample->"my container",
          CollectStaticLightScattering->False
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Example[{Basic, "Options from DynamicLightScattering can be used in the unit operation equivalently:"},
      ExperimentSamplePreparation[{
        DynamicLightScattering[
          Sample->Object[Sample,"DynamicLightScattering Unit Operation Test Sample 2"<>$SessionUUID],
          Temperature->30 Celsius,
          CollectStaticLightScattering->False
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ]
  },
  SymbolSetUp:>(
    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container,Bench,"Bench for DynamicLightScattering unit operations tests" <> $SessionUUID],
          Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for DynamicLightScattering unit operation Tests" <> $SessionUUID],
          Model[Sample, "40 kDa test protein Model[Sample] for DynamicLightScattering unit operation Tests" <> $SessionUUID],
          Object[Sample,"DynamicLightScattering Unit Operation Test Sample 1"<>$SessionUUID],
          Object[Sample,"DynamicLightScattering Unit Operation Test Sample 2"<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ];
    Module[{testBench,plate1,plate2,container1,container2,protein,sampleModel},
    $CreatedObjects={};
    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    (* Upload a test bench to put containers onto *)
    testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Bench for DynamicLightScattering unit operations tests" <> $SessionUUID, DeveloperObject -> True, Site->Link[$Site], StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];
    {plate1,plate2,container1,container2}=UploadSample[
      {
        Model[Container, Plate, "96 well Flat Bottom DLS Plate"],
        Model[Container, Plate, "96 well Flat Bottom DLS Plate"],
        Model[Container, Vessel, "15mL Tube"],
        Model[Container, Vessel, "15mL Tube"]
      },
      {
        {"Work Surface", testBench},
        {"Work Surface", testBench},
        {"Work Surface", testBench},
        {"Work Surface", testBench}
      },
      Status->Available
    ];
    protein=Upload[
      <|
        Type->Model[Molecule,Protein],
        Name->"Test 40 kDa Model[Molecule,Protein] for DynamicLightScattering unit operation Tests" <> $SessionUUID,
        MolecularWeight->40*(Kilogram/Mole),
        DeveloperObject->True
      |>
    ];
    sampleModel=Upload[
      <|
        Type -> Model[Sample],
        Name -> "40 kDa test protein Model[Sample] for DynamicLightScattering unit operation Tests" <> $SessionUUID,
        Replace[Authors] -> {Link[$PersonID]},
        DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
        Replace[Composition] -> {
          {10 * (Milligram / Milliliter), Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for DynamicLightScattering unit operation Tests" <> $SessionUUID]]},
          {100 * VolumePercent, Link[Model[Molecule, "Water"]]}
        }
      |>
    ];
    UploadSample[
      {
        Model[Sample, "40 kDa test protein Model[Sample] for DynamicLightScattering unit operation Tests" <> $SessionUUID],
        Model[Sample, "40 kDa test protein Model[Sample] for DynamicLightScattering unit operation Tests" <> $SessionUUID]
      },
      {
        {"A1", container1},
        {"A1", container2}
      },
      InitialAmount-> {
        5 Milliliter,
        5 Milliliter
      },
      Name-> {
        "DynamicLightScattering Unit Operation Test Sample 1" <> $SessionUUID,
        "DynamicLightScattering Unit Operation Test Sample 2"<>$SessionUUID
      }
    ];
    Upload[
      <|
        Object->Object[Sample,"DynamicLightScattering Unit Operation Test Sample 1" <> $SessionUUID],
        Status->Available,
        Site->Link[$Site]
      |>,
      <|
        Object->Object[Sample,"DynamicLightScattering Unit Operation Test Sample 2" <> $SessionUUID],
        Status->Available,
        Site->Link[$Site]
      |>
    ]
  ]),
  SymbolTearDown:>Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container,Bench,"Bench for DynamicLightScattering unit operations tests" <> $SessionUUID],
          Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for DynamicLightScattering unit operation Tests" <> $SessionUUID],
          Model[Sample, "40 kDa test protein Model[Sample] for DynamicLightScattering unit operation Tests" <> $SessionUUID],
          Object[Sample,"DynamicLightScattering Unit Operation Test Sample 1"<>$SessionUUID],
          Object[Sample,"DynamicLightScattering Unit Operation Test Sample 2"<>$SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
      EraseObject[existingObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    On[Warning::SamplesOutOfStock];
  ],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];

(* ::Subsection::Closed:: *)
(* ICPMS *)
DefineTests[ICPMS,
  {
    Example[{Options,SampleLabel,"ICPMS Unit Operation can accept a container label and can label the sample inside it:"},
      Module[{protocol},
        protocol=Experiment[{
          LabelContainer[
            Label -> "my container",
            Container -> Object[Container, Vessel, "Test container 1 for ICPMS" <> $SessionUUID]
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"my container",
            Amount->3 Milliliter
          ],
          ICPMS[
            Sample->"my container",
            SampleLabel->"my sample",
            QuantifyConcentration -> False,
            StandardType -> None
          ]
        }];
        Download[protocol,CalculatedUnitOperations[[3]][{SampleLabel,StandardType}]]
      ],
      {
        {"my sample"},
        None
      },
      Variables:>{protocol}
    ]
  },
  SymbolSetUp:>Module[{},
    $CreatedObjects={};
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ComponentOrder];
    Module[{objects, existsFilter},
      (* list of test objests *)
      objects = {
        Object[Container, Vessel, "Test container 1 for ICPMS" <> $SessionUUID],
        Object[Container, Bench, "Test Bench for ICPMS"<>$SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];
    Module[{testBench},
      testBench = Upload[<|
        Type -> Object[Container, Bench],
        Model -> Link[Model[Container,Bench,"The Bench of Testing"],Objects],
        Name -> "Test Bench for ValidExperimentICPMSQ"<>$SessionUUID,
        DeveloperObject -> True,
        StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
        Site -> Link[$Site]
      |>];
      Block[{$DeveloperUpload=True},
        UploadSample[Model[Container, Vessel, "50mL Tube"],
          {"Bench Top Slot", testBench},
          Name -> "Test container 1 for ICPMS" <> $SessionUUID
        ]
      ];
    ];
  ],
  SymbolTearDown:>Module[{},
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ComponentOrder];
    Module[{objects, existsFilter},
      (* list of test objests *)
      objects = {
        Object[Container, Vessel, "Test container 1 for ICPMS" <> $SessionUUID],
        Object[Container, Bench, "Test Bench for ICPMS"<>$SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];
  ],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];


(* ::Subsection::Closed:: *)
(* MicrowaveDigestion *)
DefineTests[MicrowaveDigestion,
  {
    Example[{Options,SampleLabel,"MicrowaveDigestion Unit Operation can accept a container label and can label the sample inside it:"},
      Module[{protocol},
        protocol=ExperimentSamplePreparation[{
          LabelContainer[
            Label -> "my container",
            Container -> Object[Container, Vessel, "Test container 1 for MicrowaveDigestion" <> $SessionUUID]
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"my container",
            Amount->3 Milliliter
          ],
          MicrowaveDigestion[
            Sample->"my container",
            SampleLabel->"my sample"
          ]
        }];
        Download[protocol,CalculatedUnitOperations[[3]][{SampleLabel,DigestionAgents}]]
      ],
      {
        {"my sample"},
        {{{ObjectP[Model[Sample]], VolumeP}..}}
      },
      Variables:>{protocol}
    ]
  },
  SymbolSetUp:>Module[{},
    $CreatedObjects={};
    ClearMemoization[];
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{objects, existsFilter},
      (* list of test objests *)
      objects = {
        Object[Container, Vessel, "Test container 1 for MicrowaveDigestion" <> $SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];
    Module[{},
      Upload[<|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Site -> Link[$Site],
        Name -> "Test container 1 for MicrowaveDigestion" <> $SessionUUID,
        DeveloperObject -> True
      |>];
    ]
  ],
  SymbolTearDown:>Module[{},
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    Module[{objects, existsFilter},
      (* list of test objests *)
      objects = {
        Object[Container, Vessel, "Test container 1 for MicrowaveDigestion" <> $SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];
  ],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];


(* ::Subsection::Closed:: *)
(* AdjustpH *)
DefineTests[AdjustpH,
    {
      Example[{Basic, "Define a sample and then add acid/base as needed to reach a pH of 7.2:"},
        ExperimentSamplePreparation[{
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->{"A1","my container"},
            Amount->35 Milliliter
          ],
          AdjustpH[
            Sample->"my container",
            NominalpH->7.2
          ]
        }],
        ObjectP[Object[Protocol, ManualSamplePreparation]]
      ],
      Example[{Basic, "Options from ExperimentAdjustpH can be used equivalently in the AdjustpH unit operation:"},
        ExperimentSamplePreparation[{
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->{"A1","my container"},
            Amount->35 Milliliter
          ],
          AdjustpH[
            Sample->"my container",
            NominalpH->7.2,
            MinpH->6.9,
            MaxpH->7.4
          ]
        }],
        ObjectP[Object[Protocol, ManualSamplePreparation]]
      ],
      Example[{Basic, "Create an acid sample and use it to adjust the pH for a variety of samples:"},
        ExperimentSamplePreparation[{
          Transfer[
            Source->Model[Sample, StockSolution, "2 M HCl"],
            Destination->Model[Container, Vessel, "50mL Tube"],
            DestinationLabel->"acid sample",
            Amount->30 Milliliter
          ],
          AdjustpH[
            Sample->Object[Sample,"AdjustpH Unit Operation Test Sample"<>$SessionUUID],
            NominalpH->5,
            TitratingAcid->"acid sample"
          ]
        }],
        ObjectP[Object[Protocol, ManualSamplePreparation]]
      ]
    },
    SymbolSetUp:>(
      Module[{allObjects, existingObjects},

        (*Gather all the objects and models created in SymbolSetUp*)
        allObjects = {
          Object[Container, Bench, "Test bench for AdjustpH tests"<> $SessionUUID],
          Object[Container, Vessel, "Test tube for AdjustpH tests" <> $SessionUUID],
          Object[Sample, "AdjustpH Unit Operation Test Sample"<>$SessionUUID]
        };

        (*Check whether the names we want to give below already exist in the database*)
        existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

        (*Erase any test objects and models that we failed to erase in the last unit test*)
        Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
      ];
      Module[{testBench,tube},
        $CreatedObjects={};

        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Test bench for AdjustpH tests"<> $SessionUUID,
          Site -> Link[$Site],
          DeveloperObject -> True
        |>];

        tube = UploadSample[
          Model[Container, Vessel, "50mL Tube"],
          {"Work Surface", testBench},
          Name -> "Test tube for AdjustpH tests" <> $SessionUUID
        ];

        UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1",tube},
          InitialAmount->30 Milliliter,
          Name->"AdjustpH Unit Operation Test Sample"<>$SessionUUID
        ]
      ]
    ),
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];

(* ::Subsection::Closed:: *)
(* Grind *)
DefineTests[Grind,
  {
    Example[{Options,SampleLabel,"Grind Unit Operation can accept a container label and can label the sample inside it:"},
      Module[{protocol},
        protocol=Experiment[{
          LabelContainer[
            Label -> "my container",
            Container -> Object[Container, Vessel, "Test container 1 for Grind" <> $SessionUUID]
          ],
          Transfer[
            Source->Model[Sample, "Benzoic acid"],
            Destination->"my container",
            Amount->3 Gram
          ],
          Grind[
            Sample->"my container",
            SampleLabel->"my sample",
            Instrument -> Model[Instrument, Grinder, "Tube Mill Control"]
          ]
        }];
        Download[protocol,CalculatedUnitOperations[[3]][{SampleLabel, Instrument, GrinderType}]]
      ],
      {
        {"my sample"},
        {ObjectP[Model[Instrument, Grinder, "Tube Mill Control"]]},
        {KnifeMill}
      },
      Variables:>{protocol}
    ]
  },
  SymbolSetUp:> (
    $CreatedObjects = {};
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Module[{objects, existsFilter},
      (* list of test objects *)
      objects = {
        Object[Container, Vessel, "Test container 1 for Grind" <> $SessionUUID],
        Object[Container, Bench, "Test Bench for Grind" <> $SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];

    Block[{$DeveloperUpload = True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
          Name -> "Test Bench for Grind" <> $SessionUUID,
          DeveloperObject -> True,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Site -> Link[$Site]
        |>];
        UploadSample[Model[Container, Vessel, "50mL Tube"],
          {"Bench Top Slot", testBench},
          Name -> "Test container 1 for Grind" <> $SessionUUID
        ]
      ]
    ]
  ),
  SymbolTearDown:> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects];
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{objects, existsFilter},
      (* list of test objects *)
      objects = {
        Object[Container, Vessel, "Test container 1 for Grind" <> $SessionUUID],
        Object[Container, Bench, "Test Bench for Grind" <> $SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];
  ),
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];
(* ::Subsection::Closed:: *)
(* Desiccate *)
DefineTests[Desiccate,
  {
    Example[{Options,SampleLabel,"Desiccate Unit Operation can accept a container label and can label the sample inside it:"},
      Module[{protocol},
        protocol=Experiment[{
          LabelContainer[
            Label -> "my container",
            Container -> Object[Container, Vessel, "Test container 1 for Desiccate" <> $SessionUUID]
          ],
          Transfer[
            Source->Model[Sample, "Benzoic acid"],
            Destination->"my container",
            Amount->3 Gram
          ],
          Desiccate[
            Sample->"my container",
            SampleLabel->"my sample"
          ]
        }];
        Download[protocol,CalculatedUnitOperations[[3]][{SampleLabel}]]
      ],
      {
        {"my sample"}
      },
      Variables:>{protocol}
    ]
  },
  SymbolSetUp:>Module[{},
    $CreatedObjects={};
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Module[{objects, existsFilter},
      (* list of test objects *)
      objects = {
        Object[Container, Bench, "Test Bench for Desiccate"<>$SessionUUID],
        Object[Container, Vessel, "Test container 1 for Desiccate" <> $SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];

    Block[{$DeveloperUpload=True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container,Bench,"The Bench of Testing"],Objects],
          Name -> "Test Bench for Desiccate"<>$SessionUUID,
          StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
          Site -> Link[$Site]
        |>];

        UploadSample[
          Model[Container, Vessel, "50mL Tube"],
          {"Bench Top Slot", testBench},
          Name -> "Test container 1 for Desiccate" <> $SessionUUID
        ];
      ]
    ]
  ],
  SymbolTearDown:>Module[{},
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{objects, existsFilter},
      (* list of test objects *)
      objects = {
        Object[Container, Bench, "Test Bench for Desiccate"<>$SessionUUID],
        Object[Container, Vessel, "Test container 1 for Desiccate" <> $SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];
  ],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];
(* ::Subsection::Closed:: *)
(* MeasureMeltingPoint *)
DefineTests[MeasureMeltingPoint,
  {
    Example[{Options,SampleLabel,"MeasureMeltingPoint Unit Operation can accept a container label and can label the sample inside it:"},
      Module[{protocol},
        protocol=Experiment[{
          LabelContainer[
            Label -> "my container",
            Container -> Object[Container, Vessel, "Test container 1 for MeasureMeltingPoint" <> $SessionUUID]
          ],
          Transfer[
            Source->Model[Sample, "Benzoic acid"],
            Destination->"my container",
            Amount->3 Gram
          ],
          MeasureMeltingPoint[
            Sample->"my container",
            SampleLabel->"my sample",
            Desiccate->False,
            Grind->False
          ]
        }];
        Download[protocol,CalculatedUnitOperations[[3]][{SampleLabel}]]
      ],
      {
        {"my sample"}
      },
      Variables:>{protocol}
    ]
  },

  TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},

  SymbolSetUp:>Module[{},
    Module[{objects, existsFilter},
      (* list of test objects *)
      objects = {
        Object[Container, Vessel, "Test container 1 for MeasureMeltingPoint" <> $SessionUUID],
        Object[Container, Bench, "Test Bench for MeasureMeltingPoint Unit Operation"<>$SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];
    Block[{$DeveloperUpload = True},
      Module[{testBench},
        testBench = Upload[<|
          Type -> Object[Container, Bench],
          Model -> Link[Model[Container,Bench,"The Bench of Testing"],Objects],
          Name -> "Test Bench for MeasureMeltingPoint Unit Operation"<>$SessionUUID,
          StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
          Site -> Link[$Site]
        |>];

        UploadSample[Model[Container, Vessel, "50mL Tube"],
          {"Bench Top Slot", testBench},
          Name -> "Test container 1 for MeasureMeltingPoint" <> $SessionUUID
        ]
      ]
    ];
  ],

  SymbolTearDown:>Module[{},
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects];
    Module[{objects, existsFilter},
      (* list of test objects *)
      objects = {
        Object[Container, Vessel, "Test container 1 for MeasureMeltingPoint" <> $SessionUUID],
        Object[Container, Bench, "Test Bench for MeasureMeltingPoint Unit Operation"<>$SessionUUID]
      };

      (* Check whether the names we want to give below already exist in the database *)
      existsFilter = DatabaseMemberQ[objects];

      (* Erase any objects that we failed to erase in the last unit test. *)
      Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
    ];
  ],

  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];
