(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(*ExperimentBioconjugationPreview*)

DefineTests[ExperimentBioconjugationPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentBioconjugation:"},
      Quiet[ExperimentBioconjugationPreview[{{Object[Sample,"ExperimentBioconjugationPreview test sample 1" <> $SessionUUID],Object[Sample,"ExperimentBioconjugationPreview test sample 2" <> $SessionUUID]}},{Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 3" <> $SessionUUID]}],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentBioconjugationOptions:"},
      Quiet[ExperimentBioconjugationOptions[{{Object[Sample,"ExperimentBioconjugationPreview test sample 1" <> $SessionUUID],Object[Sample,"ExperimentBioconjugationPreview test sample 2" <> $SessionUUID]}},{Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 3" <> $SessionUUID]}],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentBioconjugationQ:"},
      Quiet[ValidExperimentBioconjugationQ[{{Object[Sample,"ExperimentBioconjugationPreview test sample 1" <> $SessionUUID],Object[Sample,"ExperimentBioconjugationPreview test sample 2" <> $SessionUUID]}},{Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 3" <> $SessionUUID]}],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
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
          Object[Container,Bench,"Test bench for ExperimentBioconjugationPreview tests" <> $SessionUUID],

          Object[Container,Plate,"Test container 1 for ExperimentBioconjugationPreview tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 1" <> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 2" <> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 3" <> $SessionUUID],

          Model[Sample,"ExperimentBioconjugationPreview model test sample 1" <> $SessionUUID],
          Model[Sample,"ExperimentBioconjugationPreview model test sample 2" <> $SessionUUID],

          Object[Sample,"ExperimentBioconjugationPreview test sample 1" <> $SessionUUID],
          Object[Sample,"ExperimentBioconjugationPreview test sample 2" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          testBench,container1,idModel1,idModel2,idModel3,model1,model2,sample1,sample2
        },

        testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentBioconjugationPreview tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload test test container for input samples *)
        container1=UploadSample[
          Model[Container, Plate, "96-well 2mL Deep Well Plate"],
          {"Work Surface", testBench},
          Status -> Available,
          Name->"Test container 1 for ExperimentBioconjugationPreview tests" <> $SessionUUID
        ];

        (*Upload oligomer identity models. For variety make one cDNA and one transcript test object.*)
        {idModel1,idModel2,idModel3}=UploadOligomer[
          {
            "ExperimentBioconjugationPreview test oligomer 1" <> $SessionUUID,
            "ExperimentBioconjugationPreview test oligomer 2" <> $SessionUUID,
            "ExperimentBioconjugationPreview test oligomer 3" <> $SessionUUID
          },
          Molecule->{
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAGCATTAG"]]
          },
          Synonyms->{
            {"TestOligomer1"},
            {"TestOligomer2"},
            {"TestOligomer3"}
          },
          PolymerType->{DNA,RNA,DNA}
        ];

        (*Upload Model samples so we can upload new sample objects later.*)
        {model1,model2}=UploadSampleModel[
          {
            "ExperimentBioconjugationPreview model test sample 1" <> $SessionUUID,
            "ExperimentBioconjugationPreview model test sample 2" <> $SessionUUID
          },
          Composition->{
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 1" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 2" <> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
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
        {sample1,sample2}=UploadSample[
          {
            Model[Sample,"ExperimentBioconjugationPreview model test sample 1" <> $SessionUUID],
            Model[Sample,"ExperimentBioconjugationPreview model test sample 2" <> $SessionUUID]
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
            "ExperimentBioconjugationPreview test sample 1" <> $SessionUUID,
            "ExperimentBioconjugationPreview test sample 2" <> $SessionUUID
          }
        ];

        Upload[<|Object ->#,DeveloperObject->True|>& /@ Cases[Flatten[{container1,idModel1,idModel2,model1,model2,sample1,sample2}], ObjectP[]]];

        MapThread[
          Upload[<|Object->#1,Replace[Analytes]->Link[#2]|>]&,
          {
            {
              Object[Sample,"ExperimentBioconjugationPreview test sample 1" <> $SessionUUID],
              Object[Sample,"ExperimentBioconjugationPreview test sample 2" <> $SessionUUID]
            },

            {
              Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 1" <> $SessionUUID],
              Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 2" <> $SessionUUID]
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
          Object[Container,Bench,"Test bench for ExperimentBioconjugationPreview tests" <> $SessionUUID],

          Object[Container,Plate,"Test container 1 for ExperimentBioconjugationPreview tests" <> $SessionUUID],

          Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 1" <> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 2" <> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentBioconjugationPreview test oligomer 3" <> $SessionUUID],

          Model[Sample,"ExperimentBioconjugationPreview model test sample 1" <> $SessionUUID],
          Model[Sample,"ExperimentBioconjugationPreview model test sample 2" <> $SessionUUID],

          Object[Sample,"ExperimentBioconjugationPreview test sample 1" <> $SessionUUID],
          Object[Sample,"ExperimentBioconjugationPreview test sample 2" <> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects]];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ExperimentBioconjugationOptions*)

DefineTests[ExperimentBioconjugationOptions,
  {
    Example[{Basic,"Display the option values which will be used in the experiment:"},
      Quiet[ExperimentBioconjugationOptions[{{Object[Sample,"ExperimentBioconjugationOptions test sample 1"<> $SessionUUID],Object[Sample,"ExperimentBioconjugationOptions test sample 2"<> $SessionUUID]}},{Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 3"<> $SessionUUID]}],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
      _Grid
    ],
    Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
      Quiet[ExperimentBioconjugationOptions[{{Object[Sample,"ExperimentBioconjugationOptions test sample 1"<> $SessionUUID],Object[Sample,"Discarded ExperimentBioconjugationOptions test sample 3"<> $SessionUUID]}},{Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 3"<> $SessionUUID]}],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
      _Grid,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
      Quiet[ExperimentBioconjugationOptions[{{Object[Sample,"ExperimentBioconjugationOptions test sample 1"<> $SessionUUID],Object[Sample,"ExperimentBioconjugationOptions test sample 2"<> $SessionUUID]}},{Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 3"<> $SessionUUID]},OutputFormat->List],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
      {(_Rule|_RuleDelayed)..}
    ]
  },
  Stubs:>{
    $EmailEnabled=False
  },
  SetUp:>(
    $CreatedObjects={}
  ),
  TearDown:>(
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objects,existingObjects},
      objects=Quiet[Cases[
        Flatten[{
          Object[Container,Bench,"Test bench for ExperimentBioconjugationOptions tests"<> $SessionUUID],

          Object[Container,Plate,"Test container 1 for ExperimentBioconjugationOptions tests"<> $SessionUUID],

          Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 1"<> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 2"<> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 3"<> $SessionUUID],

          Model[Sample,"ExperimentBioconjugationOptions model test sample 1"<> $SessionUUID],
          Model[Sample,"ExperimentBioconjugationOptions model test sample 2"<> $SessionUUID],

          Object[Sample,"ExperimentBioconjugationOptions test sample 1"<> $SessionUUID],
          Object[Sample,"ExperimentBioconjugationOptions test sample 2"<> $SessionUUID],
          Object[Sample,"Discarded ExperimentBioconjugationOptions test sample 3"<> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects,DatabaseMemberQ[objects]];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          testBench,container1,idModel1,idModel2,idModel3,model1,model2,sample1,sample2,sample3
        },

        testBench=Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ExperimentBioconjugationOptions tests"<> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload test test container for input samples *)
        container1 =UploadSample[
          Model[Container, Plate, "96-well 2mL Deep Well Plate"],
          {"Work Surface", testBench},
          Status -> Available,
          Name->"Test container 1 for ExperimentBioconjugationOptions tests"<> $SessionUUID
        ];

        (*Upload oligomer identity models. For variety make one cDNA and one transcript test object.*)
        {idModel1,idModel2,idModel3}=UploadOligomer[
          {
            "ExperimentBioconjugationOptions test oligomer 1"<> $SessionUUID,
            "ExperimentBioconjugationOptions test oligomer 2"<> $SessionUUID,
            "ExperimentBioconjugationOptions test oligomer 3"<> $SessionUUID
          },
          Molecule->{
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAGCATTAG"]]
          },
          Synonyms -> {
            {"TestOligomer1"},
            {"TestOligomer2"},
            {"TestOligomer3"}
          },
          PolymerType->{DNA,RNA,DNA}
        ];

        (*Upload Model samples so we can upload new sample objects later.*)
        {model1,model2}=UploadSampleModel[
          {
            "ExperimentBioconjugationOptions model test sample 1"<> $SessionUUID,
            "ExperimentBioconjugationOptions model test sample 2"<> $SessionUUID
          },
          Composition->{
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 1"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 2"<> $SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
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
        {sample1,sample2,sample3}=UploadSample[
          {
            Model[Sample,"ExperimentBioconjugationOptions model test sample 1"<> $SessionUUID],
            Model[Sample,"ExperimentBioconjugationOptions model test sample 2"<> $SessionUUID],
            Model[Sample,"ExperimentBioconjugationOptions model test sample 2"<> $SessionUUID]
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
            "ExperimentBioconjugationOptions test sample 1"<> $SessionUUID,
            "ExperimentBioconjugationOptions test sample 2"<> $SessionUUID,
            "Discarded ExperimentBioconjugationOptions test sample 3"<> $SessionUUID
          }
        ];

        Upload[<|Object->#,DeveloperObject->True|>& /@ Cases[Flatten[{container1,idModel1,idModel2,model1,model2,sample1,sample2,sample3}], ObjectP[]]];

        (* Discard one of the Samples *)
        Upload[<|Object->sample3,Status->Discarded|>];

        MapThread[
          Upload[<|Object->#1,Replace[Analytes]->Link[#2]|>]&,
          {
            {
              Object[Sample,"ExperimentBioconjugationOptions test sample 1"<> $SessionUUID],
              Object[Sample,"ExperimentBioconjugationOptions test sample 2"<> $SessionUUID],
              Object[Sample,"Discarded ExperimentBioconjugationOptions test sample 3"<> $SessionUUID]
            },

            {
              Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 1"<> $SessionUUID],
              Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 2"<> $SessionUUID],
              Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 2"<> $SessionUUID]
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
          Object[Container,Bench,"Test bench for ExperimentBioconjugationOptions tests"<> $SessionUUID],

          Object[Container,Plate,"Test container 1 for ExperimentBioconjugationOptions tests"<> $SessionUUID],

          Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 1"<> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 2"<> $SessionUUID],
          Model[Molecule,Oligomer,"ExperimentBioconjugationOptions test oligomer 3"<> $SessionUUID],

          Model[Sample,"ExperimentBioconjugationOptions model test sample 1"<> $SessionUUID],
          Model[Sample,"ExperimentBioconjugationOptions model test sample 2"<> $SessionUUID],

          Object[Sample,"ExperimentBioconjugationOptions test sample 1"<> $SessionUUID],
          Object[Sample,"ExperimentBioconjugationOptions test sample 2"<> $SessionUUID],
          Object[Sample,"Discarded ExperimentBioconjugationOptions test sample 3"<> $SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects=PickList[objects,DatabaseMemberQ[objects]];
      EraseObject[existingObjects,Force->True,Verbose->False]
    ]
  )
];


(* ::Subsection::Closed:: *)
(*ValidExperimentBioconjugationQ*)

DefineTests[ValidExperimentBioconjugationQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      Quiet[ValidExperimentBioconjugationQ[{{Object[Sample,"ValidExperimentBioconjugationQ test sample 1"<>$SessionUUID],Object[Sample,"ValidExperimentBioconjugationQ test sample 2"<>$SessionUUID]}},{ Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 3"<>$SessionUUID]}],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      Quiet[ValidExperimentBioconjugationQ[{{Object[Sample,"ValidExperimentBioconjugationQ test sample 1"<>$SessionUUID],Object[Sample,"Discarded ValidExperimentBioconjugationQ test sample 3"<>$SessionUUID]}},{ Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 3"<>$SessionUUID]}],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      Quiet[ValidExperimentBioconjugationQ[{{Object[Sample,"ValidExperimentBioconjugationQ test sample 1"<>$SessionUUID],Object[Sample,"ValidExperimentBioconjugationQ test sample 2"<>$SessionUUID]}},{ Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 3"<>$SessionUUID]},OutputFormat->TestSummary],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      Quiet[ValidExperimentBioconjugationQ[{{Object[Sample,"ValidExperimentBioconjugationQ test sample 1"<>$SessionUUID],Object[Sample,"ValidExperimentBioconjugationQ test sample 2"<>$SessionUUID]}},{ Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 3"<>$SessionUUID]},Verbose->True],{Warning::InvalidSampleAnalyteConcentrations, Warning::UnknownReactantsStoichiometry, Warning::UnknownProductStoichiometry}],
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
          Object[Container,Bench,"Test bench for ValidExperimentBioconjugationQ tests"<>$SessionUUID<>$SessionUUID],

          Object[Container,Plate,"Test container 1 for ValidExperimentBioconjugationQ tests"<>$SessionUUID],

          Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 1"<>$SessionUUID],
          Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 2"<>$SessionUUID],
          Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 3"<>$SessionUUID],

          Model[Sample,"ValidExperimentBioconjugationQ model test sample 1"<>$SessionUUID],
          Model[Sample,"ValidExperimentBioconjugationQ model test sample 2"<>$SessionUUID],

          Object[Sample,"ValidExperimentBioconjugationQ test sample 1"<>$SessionUUID],
          Object[Sample,"ValidExperimentBioconjugationQ test sample 2"<>$SessionUUID],
          Object[Sample,"Discarded ValidExperimentBioconjugationQ test sample 3"<>$SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          testBench, container1, idModel1, idModel2, idModel3, model1, model2, sample1, sample2, sample3
        },

        testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for ValidExperimentBioconjugationQ tests"<>$SessionUUID<>$SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload test test container for input samples *)
        container1=UploadSample[
          Model[Container, Plate, "96-well 2mL Deep Well Plate"],
          {"Work Surface", testBench},
          Status -> Available,
          Name->"Test container 1 for ValidExperimentBioconjugationQ tests"<>$SessionUUID
        ];

        (*Upload oligomer identity models. For variety make one cDNA and one transcript test object.*)
        {idModel1,idModel2,idModel3}=UploadOligomer[
          {
            "ValidExperimentBioconjugationQ test oligomer 1"<>$SessionUUID,
            "ValidExperimentBioconjugationQ test oligomer 2"<>$SessionUUID,
            "ValidExperimentBioconjugationQ test oligomer 3"<>$SessionUUID
          },
          Molecule->{
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAG"]],
            Strand[DNA["CATTAGCATTAG"]]
          },
          Synonyms -> {
            {"TestOligomer1"},
            {"TestOligomer2"},
            {"TestOligomer3"}
          },
          PolymerType->{DNA,RNA,DNA}
        ];

        (*Upload Model samples so we can upload new sample objects later.*)
        {model1,model2}=UploadSampleModel[
          {
            "ValidExperimentBioconjugationQ model test sample 1"<>$SessionUUID,
            "ValidExperimentBioconjugationQ model test sample 2"<>$SessionUUID
          },
          Composition->{
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 1"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
            {{1 Milligram/Milliliter,Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 2"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
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
        {sample1,sample2,sample3}=UploadSample[
          {
            Model[Sample,"ValidExperimentBioconjugationQ model test sample 1"<>$SessionUUID],
            Model[Sample,"ValidExperimentBioconjugationQ model test sample 2"<>$SessionUUID],
            Model[Sample,"ValidExperimentBioconjugationQ model test sample 2"<>$SessionUUID]
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
            "ValidExperimentBioconjugationQ test sample 1"<>$SessionUUID,
            "ValidExperimentBioconjugationQ test sample 2"<>$SessionUUID,
            "Discarded ValidExperimentBioconjugationQ test sample 3"<>$SessionUUID
          }
        ];

        Upload[<|Object->#,DeveloperObject->True|>& /@ Cases[Flatten[{container1,idModel1,idModel2,model1,model2,sample1,sample2,sample3}], ObjectP[]]];

        (* Discard one of the Samples *)
        Upload[<|Object->sample3,Status->Discarded|>];

        MapThread[
          Upload[<|Object->#1,Replace[Analytes]->Link[#2]|>]&,
          {
            {
              Object[Sample,"ValidExperimentBioconjugationQ test sample 1"<>$SessionUUID],
              Object[Sample,"ValidExperimentBioconjugationQ test sample 2"<>$SessionUUID],
              Object[Sample,"Discarded ValidExperimentBioconjugationQ test sample 3"<>$SessionUUID]
            },

            {
              Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 1"<>$SessionUUID],
              Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 2"<>$SessionUUID],
              Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 2"<>$SessionUUID]
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
          Object[Container,Bench,"Test bench for ValidExperimentBioconjugationQ tests"<>$SessionUUID<>$SessionUUID],

          Object[Container,Plate,"Test container 1 for ValidExperimentBioconjugationQ tests"<>$SessionUUID],

          Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 1"<>$SessionUUID],
          Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 2"<>$SessionUUID],
          Model[Molecule,Oligomer,"ValidExperimentBioconjugationQ test oligomer 3"<>$SessionUUID],

          Model[Sample,"ValidExperimentBioconjugationQ model test sample 1"<>$SessionUUID],
          Model[Sample,"ValidExperimentBioconjugationQ model test sample 2"<>$SessionUUID],

          Object[Sample,"ValidExperimentBioconjugationQ test sample 1"<>$SessionUUID],
          Object[Sample,"ValidExperimentBioconjugationQ test sample 2"<>$SessionUUID],
          Object[Sample,"Discarded ValidExperimentBioconjugationQ test sample 3"<>$SessionUUID]

        }],
        ObjectP[]
      ]];
      existingObjects = PickList[objects, DatabaseMemberQ[objects]];
      EraseObject[existingObjects, Force -> True, Verbose -> False]
    ]
  )
];