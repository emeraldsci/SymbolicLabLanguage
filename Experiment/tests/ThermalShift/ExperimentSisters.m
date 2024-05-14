(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(*ExperimentThermalShiftPreview*)

DefineTests[ExperimentThermalShiftPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentThermalShift:"},
      ExperimentThermalShiftPreview[{Object[Sample,"ExperimentThermalShiftPreview test sample 1" <> $SessionUUID],Object[Sample,"ExperimentThermalShiftPreview test sample 2" <> $SessionUUID]}],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentThermalShiftOptions:"},
      ExperimentThermalShiftOptions[{Object[Sample,"ExperimentThermalShiftPreview test sample 1" <> $SessionUUID],Object[Sample,"ExperimentThermalShiftPreview test sample 2" <> $SessionUUID]}],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentThermalShiftQ:"},
      ValidExperimentThermalShiftQ[{Object[Sample,"ExperimentThermalShiftPreview test sample 1" <> $SessionUUID],Object[Sample,"ExperimentThermalShiftPreview test sample 2" <> $SessionUUID]}],
      True
    ]
  },
  Stubs:>{
    $EmailEnabled=False
  },
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ExperimentThermalShiftPreview tests" <> $SessionUUID],

          Object[Container,Plate,"Fake container 1 for ExperimentThermalShiftPreview tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"ExperimentThermalShiftPreview test oligomer 1" <> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentThermalShiftPreview test oligomer 2" <> $SessionUUID],

          Model[Sample,"ExperimentThermalShiftPreview model test sample 1" <> $SessionUUID],
          Model[Sample,"ExperimentThermalShiftPreview model test sample 2" <> $SessionUUID],

          Object[Sample,"ExperimentThermalShiftPreview test sample 1" <> $SessionUUID],
          Object[Sample,"ExperimentThermalShiftPreview test sample 2" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          fakeBench,

          container1,

          idModel1,idModel2,

          model1, model2,

          sample1, sample2
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentThermalShiftPreview tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload fake test container for input samples *)
        {
          container1
        }=UploadSample[
          {
            Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          },
          {
            {"Work Surface", fakeBench}
          },
          Status -> Available,
          Name->{
            "Fake container 1 for ExperimentThermalShiftPreview tests" <> $SessionUUID
          }
        ];

        (*Upload oligomer identity models. For variety make one cDNA and one transcript test object.*)
        {
          idModel1,idModel2
        }=UploadOligomer[
          {
            "ExperimentThermalShiftPreview test oligomer 1" <> $SessionUUID,
            "ExperimentThermalShiftPreview test oligomer 2" <> $SessionUUID
          },
          Molecule->{
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAG"]]
          },
          Synonyms -> {
            {"TestOligomer1"},
            {"TestOligomer2"}
          },
          PolymerType->{DNA,RNA}
        ];

        (*Upload Model samples so we can upload new sample objects later.*)
        {
          model1,model2
        }=UploadSampleModel[
          {
            "ExperimentThermalShiftPreview model test sample 1" <> $SessionUUID,
            "ExperimentThermalShiftPreview model test sample 2" <> $SessionUUID
          },
          Composition->{
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ExperimentThermalShiftPreview test oligomer 1" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ExperimentThermalShiftPreview test oligomer 2" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
          },
          IncompatibleMaterials->{{None},{None}},
          Expires->{True,True},
          ShelfLife->{1 Year,1 Year},
          UnsealedShelfLife->{2 Week,2 Week},
          DefaultStorageCondition->{Model[StorageCondition,"Refrigerator"],Model[StorageCondition,"Refrigerator"]},
          MSDSRequired->{False,False},
          BiosafetyLevel->{"BSL-1","BSL-1"},
          State->{Liquid,Liquid}
        ];


        (* Upload test sample objects *)
        {
          sample1,sample2
        }=UploadSample[
          {
            Model[Sample,"ExperimentThermalShiftPreview model test sample 1" <> $SessionUUID],
            Model[Sample,"ExperimentThermalShiftPreview model test sample 2" <> $SessionUUID]
          },
          {
            {"A1", container1},
            {"A2", container1}
          },
          InitialAmount->{
            0.5*Milliliter,
            0.5*Milliliter
          },
          Status->Available,
          Name->{
            "ExperimentThermalShiftPreview test sample 1" <> $SessionUUID,
            "ExperimentThermalShiftPreview test sample 2" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container1,idModel1,idModel2,model1,model2,sample1,sample2}], ObjectP[]]];

        MapThread[
          Upload[<|Object->#1, Replace[Analytes]->Link[#2]|>]&,
          {
            {
              Object[Sample,"ExperimentThermalShiftPreview test sample 1" <> $SessionUUID],
              Object[Sample,"ExperimentThermalShiftPreview test sample 2" <> $SessionUUID]
            },

            {
              Model[Molecule,Oligomer,"ExperimentThermalShiftPreview test oligomer 1" <> $SessionUUID],
              Model[Molecule,Oligomer,"ExperimentThermalShiftPreview test oligomer 2" <> $SessionUUID]
            }
          }
        ];


      ]
    ]

  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ExperimentThermalShiftPreview tests" <> $SessionUUID],

          Object[Container,Plate,"Fake container 1 for ExperimentThermalShiftPreview tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"ExperimentThermalShiftPreview test oligomer 1" <> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentThermalShiftPreview test oligomer 2" <> $SessionUUID],

          Model[Sample,"ExperimentThermalShiftPreview model test sample 1" <> $SessionUUID],
          Model[Sample,"ExperimentThermalShiftPreview model test sample 2" <> $SessionUUID],

          Object[Sample,"ExperimentThermalShiftPreview test sample 1" <> $SessionUUID],
          Object[Sample,"ExperimentThermalShiftPreview test sample 2" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ExperimentThermalShiftOptions*)

DefineTests[ExperimentThermalShiftOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      ExperimentThermalShiftOptions[{Object[Sample,"ExperimentThermalShiftOptions test sample 1" <> $SessionUUID],Object[Sample,"ExperimentThermalShiftOptions test sample 2" <> $SessionUUID]}],
      _Grid
    ],
    Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
      ExperimentThermalShiftOptions[{Object[Sample,"ExperimentThermalShiftOptions test sample 1" <> $SessionUUID],Object[Sample,"Discarded ExperimentThermalShiftOptions test sample 3" <> $SessionUUID]}],
      _Grid,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      ExperimentThermalShiftOptions[{Object[Sample,"ExperimentThermalShiftOptions test sample 1" <> $SessionUUID],Object[Sample,"ExperimentThermalShiftOptions test sample 2" <> $SessionUUID]},OutputFormat->List],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  Stubs:>{
    $EmailEnabled=False
  },
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ExperimentThermalShiftOptions tests" <> $SessionUUID],

          Object[Container,Plate,"Fake container 1 for ExperimentThermalShiftOptions tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 1" <> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 2" <> $SessionUUID],

          Model[Sample,"ExperimentThermalShiftOptions model test sample 1" <> $SessionUUID],
          Model[Sample,"ExperimentThermalShiftOptions model test sample 2" <> $SessionUUID],

          Object[Sample,"ExperimentThermalShiftOptions test sample 1" <> $SessionUUID],
          Object[Sample,"ExperimentThermalShiftOptions test sample 2" <> $SessionUUID],
          Object[Sample,"Discarded ExperimentThermalShiftOptions test sample 3" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          fakeBench,

          container1,

          idModel1,idModel2,

          model1, model2,

          sample1, sample2, sample3
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ExperimentThermalShiftOptions tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload fake test container for input samples *)
        {
          container1
        }=UploadSample[
          {
            Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          },
          {
            {"Work Surface", fakeBench}
          },
          Status -> Available,
          Name->{
            "Fake container 1 for ExperimentThermalShiftOptions tests" <> $SessionUUID
          }
        ];

        (*Upload oligomer identity models. For variety make one cDNA and one transcript test object.*)
        {
          idModel1,idModel2
        }=UploadOligomer[
          {
            "ExperimentThermalShiftOptions test oligomer 1" <> $SessionUUID,
            "ExperimentThermalShiftOptions test oligomer 2" <> $SessionUUID
          },
          Molecule->{
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAG"]]
          },
          Synonyms -> {
            {"TestOligomer1"},
            {"TestOligomer2"}
          },
          PolymerType->{DNA,RNA}
        ];

        (*Upload Model samples so we can upload new sample objects later.*)
        {
          model1,model2
        }=UploadSampleModel[
          {
            "ExperimentThermalShiftOptions model test sample 1" <> $SessionUUID,
            "ExperimentThermalShiftOptions model test sample 2" <> $SessionUUID
          },
          Composition->{
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 1" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 2" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
          },
          IncompatibleMaterials->{{None},{None}},
          Expires->{True,True},
          ShelfLife->{1 Year,1 Year},
          UnsealedShelfLife->{2 Week,2 Week},
          DefaultStorageCondition->{Model[StorageCondition,"Refrigerator"],Model[StorageCondition,"Refrigerator"]},
          MSDSRequired->{False,False},
          BiosafetyLevel->{"BSL-1","BSL-1"},
          State->{Liquid,Liquid}
        ];


        (* Upload test sample objects *)
        {
          sample1,sample2,sample3
        }=UploadSample[
          {
            Model[Sample,"ExperimentThermalShiftOptions model test sample 1" <> $SessionUUID],
            Model[Sample,"ExperimentThermalShiftOptions model test sample 2" <> $SessionUUID],
            Model[Sample,"ExperimentThermalShiftOptions model test sample 2" <> $SessionUUID]
          },
          {
            {"A1", container1},
            {"A2", container1},
            {"A3", container1}
          },
          InitialAmount->{
            0.5*Milliliter,
            0.5*Milliliter,
            0.5*Milliliter
          },
          Status->Available,
          Name->{
            "ExperimentThermalShiftOptions test sample 1" <> $SessionUUID,
            "ExperimentThermalShiftOptions test sample 2" <> $SessionUUID,
            "Discarded ExperimentThermalShiftOptions test sample 3" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container1,idModel1,idModel2,model1,model2,sample1,sample2,sample3}], ObjectP[]]];

        (* Discard one of the Samples *)
        Upload[<|Object->sample3,Status->Discarded|>];

        MapThread[
          Upload[<|Object->#1, Replace[Analytes]->Link[#2]|>]&,
          {
            {
              Object[Sample,"ExperimentThermalShiftOptions test sample 1" <> $SessionUUID],
              Object[Sample,"ExperimentThermalShiftOptions test sample 2" <> $SessionUUID],
              Object[Sample,"Discarded ExperimentThermalShiftOptions test sample 3" <> $SessionUUID]
            },

            {
              Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 1" <> $SessionUUID],
              Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 2" <> $SessionUUID],
              Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 2" <> $SessionUUID]
            }
          }
        ];


      ]
    ]

  ),
  SymbolTearDown:>(

    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ExperimentThermalShiftOptions tests" <> $SessionUUID],

          Object[Container,Plate,"Fake container 1 for ExperimentThermalShiftOptions tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 1" <> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentThermalShiftOptions test oligomer 2" <> $SessionUUID],

          Model[Sample,"ExperimentThermalShiftOptions model test sample 1" <> $SessionUUID],
          Model[Sample,"ExperimentThermalShiftOptions model test sample 2" <> $SessionUUID],

          Object[Sample,"ExperimentThermalShiftOptions test sample 1" <> $SessionUUID],
          Object[Sample,"ExperimentThermalShiftOptions test sample 2" <> $SessionUUID],
          Object[Sample,"Discarded ExperimentThermalShiftOptions test sample 3" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ValidExperimentThermalShiftQ*)

DefineTests[ValidExperimentThermalShiftQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentThermalShiftQ[{Object[Sample,"ValidExperimentThermalShiftQ test sample 1" <> $SessionUUID],Object[Sample,"ValidExperimentThermalShiftQ test sample 2" <> $SessionUUID]}],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentThermalShiftQ[{Object[Sample,"ValidExperimentThermalShiftQ test sample 1" <> $SessionUUID],Object[Sample,"Discarded ValidExperimentThermalShiftQ test sample 3" <> $SessionUUID]}],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentThermalShiftQ[{Object[Sample,"ValidExperimentThermalShiftQ test sample 1" <> $SessionUUID],Object[Sample,"ValidExperimentThermalShiftQ test sample 2" <> $SessionUUID]},OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentThermalShiftQ[{Object[Sample,"ValidExperimentThermalShiftQ test sample 1" <> $SessionUUID],Object[Sample,"ValidExperimentThermalShiftQ test sample 2" <> $SessionUUID]},Verbose->True],
      True
    ]
  },
  Stubs:>{
    $EmailEnabled=False
  },
  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ValidExperimentThermalShiftQ tests" <> $SessionUUID],

          Object[Container,Plate,"Fake container 1 for ValidExperimentThermalShiftQ tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 1" <> $SessionUUID],
          Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 2" <> $SessionUUID],

          Model[Sample,"ValidExperimentThermalShiftQ model test sample 1" <> $SessionUUID],
          Model[Sample,"ValidExperimentThermalShiftQ model test sample 2" <> $SessionUUID],

          Object[Sample,"ValidExperimentThermalShiftQ test sample 1" <> $SessionUUID],
          Object[Sample,"ValidExperimentThermalShiftQ test sample 2" <> $SessionUUID],
          Object[Sample,"Discarded ValidExperimentThermalShiftQ test sample 3" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          fakeBench,

          container1,

          idModel1,idModel2,

          model1, model2,

          sample1, sample2, sample3
        },

        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ValidExperimentThermalShiftQ tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload fake test container for input samples *)
        {
          container1
        }=UploadSample[
          {
            Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          },
          {
            {"Work Surface", fakeBench}
          },
          Status -> Available,
          Name->{
            "Fake container 1 for ValidExperimentThermalShiftQ tests" <> $SessionUUID
          }
        ];

        (*Upload oligomer identity models. For variety make one cDNA and one transcript test object.*)
        {
          idModel1,idModel2
        }=UploadOligomer[
          {
            "ValidExperimentThermalShiftQ test oligomer 1" <> $SessionUUID,
            "ValidExperimentThermalShiftQ test oligomer 2" <> $SessionUUID
          },
          Molecule->{
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAG"]]
          },
          Synonyms -> {
            {"TestOligomer1"},
            {"TestOligomer2"}
          },
          PolymerType->{DNA,RNA}
        ];

        (*Upload Model samples so we can upload new sample objects later.*)
        {
          model1,model2
        }=UploadSampleModel[
          {
            "ValidExperimentThermalShiftQ model test sample 1" <> $SessionUUID,
            "ValidExperimentThermalShiftQ model test sample 2" <> $SessionUUID
          },
          Composition->{
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 1" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 2" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
          },
          IncompatibleMaterials->{{None},{None}},
          Expires->{True,True},
          ShelfLife->{1 Year,1 Year},
          UnsealedShelfLife->{2 Week,2 Week},
          DefaultStorageCondition->{Model[StorageCondition,"Refrigerator"],Model[StorageCondition,"Refrigerator"]},
          MSDSRequired->{False,False},
          BiosafetyLevel->{"BSL-1","BSL-1"},
          State->{Liquid,Liquid}
        ];


        (* Upload test sample objects *)
        {
          sample1,sample2,sample3
        }=UploadSample[
          {
            Model[Sample,"ValidExperimentThermalShiftQ model test sample 1" <> $SessionUUID],
            Model[Sample,"ValidExperimentThermalShiftQ model test sample 2" <> $SessionUUID],
            Model[Sample,"ValidExperimentThermalShiftQ model test sample 2" <> $SessionUUID]
          },
          {
            {"A1", container1},
            {"A2", container1},
            {"A3", container1}
          },
          InitialAmount->{
            0.5*Milliliter,
            0.5*Milliliter,
            0.5*Milliliter
          },
          Status->Available,
          Name->{
            "ValidExperimentThermalShiftQ test sample 1" <> $SessionUUID,
            "ValidExperimentThermalShiftQ test sample 2" <> $SessionUUID,
            "Discarded ValidExperimentThermalShiftQ test sample 3" <> $SessionUUID
          }
        ];

        Upload[<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container1,idModel1,idModel2,model1,model2,sample1,sample2,sample3}], ObjectP[]]];

        (* Discard one of the Samples *)
        Upload[<|Object->sample3,Status->Discarded|>];

        MapThread[
          Upload[<|Object->#1, Replace[Analytes]->Link[#2]|>]&,
          {
            {
              Object[Sample,"ValidExperimentThermalShiftQ test sample 1" <> $SessionUUID],
              Object[Sample,"ValidExperimentThermalShiftQ test sample 2" <> $SessionUUID],
              Object[Sample,"Discarded ValidExperimentThermalShiftQ test sample 3" <> $SessionUUID]
            },

            {
              Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 1" <> $SessionUUID],
              Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 2" <> $SessionUUID],
              Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 2" <> $SessionUUID]
            }
          }
        ];


      ]
    ]

  ),
  SymbolTearDown:>(

    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ValidExperimentThermalShiftQ tests" <> $SessionUUID],

          Object[Container,Plate,"Fake container 1 for ValidExperimentThermalShiftQ tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 1" <> $SessionUUID],
          Model[Molecule,Oligomer,"ValidExperimentThermalShiftQ test oligomer 2" <> $SessionUUID],

          Model[Sample,"ValidExperimentThermalShiftQ model test sample 1" <> $SessionUUID],
          Model[Sample,"ValidExperimentThermalShiftQ model test sample 2" <> $SessionUUID],

          Object[Sample,"ValidExperimentThermalShiftQ test sample 1" <> $SessionUUID],
          Object[Sample,"ValidExperimentThermalShiftQ test sample 2" <> $SessionUUID],
          Object[Sample,"Discarded ValidExperimentThermalShiftQ test sample 3" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];