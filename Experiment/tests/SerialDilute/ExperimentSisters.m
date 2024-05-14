(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ExperimentSerialDilutePreview*)


DefineTests[ExperimentSerialDilutePreview,
    {
        (*new unit tests*)
        Example[{Basic,
            "Returns Null when given any samples and set of options, with Preparation set to Manual:"},
            ExperimentSerialDilutePreview[
                {Object[Sample,
                    "ExperimentSerialDilutePreview New Test Chemical 3 (200 uL)" <> $SessionUUID],
                    Object[Sample,
                        "ExperimentSerialDilutePreview New Test Chemical 1 (100 uL)" <> $SessionUUID]},
                SerialDilutionFactors->Table[10,6],
                FinalVolume->{Table[2 Milliliter,6],Table[100 Microliter,6]},
                ConcentratedBuffer->{Model[Sample,StockSolution,"10x PBS"],
                    Model[Sample,StockSolution,"10x PBS"]},
                BufferDilutionFactor->10,
                BufferDilutionStrategy->FromConcentrate,Preparation->Manual],
            Null,
            TimeConstraint->3000
        ],

        Example[{Basic,
            "Returns Null when given any samples and set of options, with Preparation set to Robotic:"},
            ExperimentSerialDilutePreview[
                {Object[Sample,
                    "ExperimentSerialDilutePreview New Test Chemical 3 (200 uL)" <> $SessionUUID],
                    Object[Sample,
                        "ExperimentSerialDilutePreview New Test Chemical 1 (100 uL)" <> $SessionUUID]},
                SerialDilutionFactors->Table[10,6],
                FinalVolume->{Table[100 Microliter,6],Table[100 Microliter,6]},
                BufferDilutionStrategy->FromConcentrate,Preparation->Robotic],
            Null,
            TimeConstraint->3000
        ]
    },
    Stubs:>{
        $EmailEnabled=False,
        $AllowSystemsProtocols=True,
        $PersonID=Object[User,"Test user for notebook-less test protocols"]
    },
    SetUp:>(
        ClearDownload[];
        ClearMemoization[];
        InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
        InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
        InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
        $CreatedObjects={}
    ),
    TearDown:>(
        EraseObject[$CreatedObjects,Force->True,Verbose->False];
        InternalUpload`Private`$UploadSampleTransferSolventDilutionLookup = Association[];
        InternalUpload`Private`$UploadSampleTransferSolventMixtureLookup = Association[];
        InternalUpload`Private`$UploadSampleTransferMediaMixtureLookup = Association[];
        Unset[$CreatedObjects]
    ),
    SymbolSetUp:>(
        Off[Warning::SamplesOutOfStock];
        Off[Warning::InstrumentUndergoingMaintenance];

        Module[
            {allObjs,existingObjs},
            allObjs={
                Object[Container,Bench,"Fake bench for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 1 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 2 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 3 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 4 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 5 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 6 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 7 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 8 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 9 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 10 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 11 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 12 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 13 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 14 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Plate,"Fake plate 1 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 1 (100 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 2 (100 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 3 (200 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 4 (Discarded)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 5 (no amount)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemcial 6 (100 mg)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 7 (0.01 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 8 (120 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 9 (200 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical In Plate 2 (100 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical In Plate 3 (100 uL)" <> $SessionUUID],
                Object[Protocol,SampleManipulation,Dilute,"Existing ExperimentSerialDilutePreview Protocol" <> $SessionUUID]
            };
            existingObjs=PickList[allObjs,DatabaseMemberQ[allObjs]];
            EraseObject[existingObjs,Force->True,Verbose->False]
        ];
        Block[{$AllowSystemsProtocols=True},
            Module[
                {
                    fakeBench,
                    container,container2,container3,container4,container5,container6,container7,container8,container9,container10,container11,container12,container13,container14,plate1,
                    sample,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,
                    allObjs,templateProtocol
                },

                (* create a fake bench for our test containers *)
                fakeBench=Upload[<|
                    Type->Object[Container,Bench],
                    Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
                    Name->"Fake bench for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                    DeveloperObject->True|>];

                (* call UploadSample to create test containers *)
                {
                    container,
                    container2,
                    container3,
                    container4,
                    container5,
                    container6,
                    container7,
                    container8,
                    container9,
                    container10,
                    container11,
                    container12,
                    container13,
                    container14,
                    plate1
                }=UploadSample[
                    {
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Vessel,"2mL Tube"],
                        Model[Container,Plate,"96-well 2mL Deep Well Plate"]
                    },
                    {
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench},
                        {"Work Surface",fakeBench}
                    },
                    Status->{
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available,
                        Available
                    },
                    Name->{
                        "Fake container 1 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 2 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 3 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 4 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 5 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 6 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 7 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 8 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 9 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 10 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 11 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 12 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 13 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake container 14 for ExperimentSerialDilutePreview tests" <> $SessionUUID,
                        "Fake plate 1 for ExperimentSerialDilutePreview tests" <> $SessionUUID
                    }
                ];

                (* call UploadSample to create test samples *)
                {
                    sample,
                    sample2,
                    sample3,
                    sample4,
                    sample5,
                    sample6,
                    sample7,
                    sample8,
                    sample9,
                    sample10,
                    sample11
                }=UploadSample[
                    {
                        Model[Sample,"Milli-Q water"],
                        Model[Sample,"Acetone, Reagent Grade"],
                        Model[Sample,StockSolution,"10x UV buffer"],
                        Model[Sample,"Milli-Q water"],
                        Model[Sample,"Milli-Q water"],
                        Model[Sample,"Sodium Chloride"],
                        Model[Sample,"Milli-Q water"],
                        Model[Sample,"Milli-Q water"],
                        Model[Sample,"T7 RNA Polymerase"],
                        Model[Sample,"Milli-Q water"],
                        Model[Sample,"Milli-Q water"]
                    },
                    {
                        {"A1",container},
                        {"A1",container2},
                        {"A1",container3},
                        {"A1",container4},
                        {"A1",container5},
                        {"A1",container6},
                        {"A1",container7},
                        {"A1",container8},
                        {"A1",container9},
                        {"A1",plate1},
                        {"A2",plate1}
                    },
                    InitialAmount->{
                        100 Microliter,
                        100 Microliter,
                        200 Microliter,
                        100 Microliter,
                        Null,
                        100 Milligram,
                        0.01 Microliter,
                        120 Microliter,
                        200 Microliter,
                        100 Microliter,
                        100 Microliter
                    },
                    Name->{
                        "ExperimentSerialDilutePreview New Test Chemical 1 (100 uL)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical 2 (100 uL)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical 3 (200 uL)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical 4 (Discarded)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical 5 (no amount)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemcial 6 (100 mg)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical 7 (0.01 uL)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical 8 (120 uL)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical 9 (200 uL)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical In Plate 2 (100 uL)" <> $SessionUUID,
                        "ExperimentSerialDilutePreview New Test Chemical In Plate 3 (100 uL)" <> $SessionUUID
                    }
                ];

                (* make a new protocol object for templating *)
                (*templateProtocol=ExperimentSerialDilutePreview[sample8,TotalVolume->123 Microliter,Name->"Existing ExperimentSerialDilutePreview Protocol" <> $SessionUUID];*)

                allObjs=Cases[Flatten[{
                    container,container2,container3,container4,container5,container6,container7,container8,container9,container10,container11,container12,container13,container14,plate1,
                    sample,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,
                    templateProtocol,Download[templateProtocol,{ProcedureLog[Object],RequiredResources[[All,1]][Object]}]
                }],ObjectP[]];

                (* final upload call: *)
                (* 1) make sure we set all objects to DeveloperObject -> True *)
                Upload[Flatten[{
                    <|Object->#,DeveloperObject->True|>&/@PickList[allObjs,DatabaseMemberQ[allObjs]]
                }]];
                UploadSampleStatus[sample4,Discarded,FastTrack->True]
            ]
        ]
    ),
    SymbolTearDown:>(
        On[Warning::SamplesOutOfStock];
        On[Warning::InstrumentUndergoingMaintenance];

        Module[
            {allObjs,existingObjs},
            allObjs={
                Object[Container,Bench,"Fake bench for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 1 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 2 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 3 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 4 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 5 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 6 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 7 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 8 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 9 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 10 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 11 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 12 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 13 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Vessel,"Fake container 14 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Container,Plate,"Fake plate 1 for ExperimentSerialDilutePreview tests" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 1 (100 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 2 (100 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 3 (200 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 4 (Discarded)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 5 (no amount)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemcial 6 (100 mg)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 7 (0.01 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 8 (120 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical 9 (200 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical In Plate 2 (100 uL)" <> $SessionUUID],
                Object[Sample,"ExperimentSerialDilutePreview New Test Chemical In Plate 3 (100 uL)" <> $SessionUUID],
                Object[Protocol,SampleManipulation,Dilute,"Existing ExperimentSerialDilutePreview Protocol" <> $SessionUUID]
            };
            existingObjs=PickList[allObjs,DatabaseMemberQ[allObjs]];
            EraseObject[existingObjs,Force->True,Verbose->False]
        ]
    )
];