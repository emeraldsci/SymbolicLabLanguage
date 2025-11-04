(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Primitive Framework: Source*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*ExperimentManualSamplePreparation*)

DefineTests[
  ExperimentManualSamplePreparation,
  {
    (* -- Input Validation Tests -- *)
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentManualSamplePreparation[{Incubate[Sample->Object[Sample, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentManualSamplePreparation[{Incubate[Sample->Object[Container, Vessel, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentManualSamplePreparation[{Incubate[Sample->Object[Sample, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentManualSamplePreparation[{Incubate[Sample->Object[Container, Vessel, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentManualSamplePreparation[{Incubate[Sample->sampleID]}, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentManualSamplePreparation[{Incubate[Sample->containerID]}, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[
      {Messages, "InvalidUnitOperationMethods", "If given a unit operation method (wrapper head) that isn't supported, throw an error:"},
      ExperimentManualSamplePreparation[{Test[Incubate[Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]]]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationMethods,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationOptions", "Throws a message if there are invalid options inside of the given unit operations:"},
      ExperimentManualSamplePreparation[{
        ManualSamplePreparation[
          Incubate[
            Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
            Time->5 Minute
          ],
          Incubate[
            Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
            Taco->"Yum!"
          ]
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationHeads", "If given a unit operation type isn't allowed, throw an error:"},
      ExperimentManualSamplePreparation[{Test[<||>]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationHeads,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationRequiredOptions", "If a unit operation doesn't have its required options filled out, throw an error:"},
      ExperimentManualSamplePreparation[{Incubate[]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationOptions", "If given a unit operation with an invalid option, throw an error:"},
      ExperimentManualSamplePreparation[{
        Incubate[
          Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
          Taco->"Yum!"
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationValues", "If given a unit operation with an invalid option value, throw an error:"},
      ExperimentManualSamplePreparation[{
        Incubate[
          Sample->100
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationValues,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationRequiredOptions", "If given a unit operation with a missing required option, throw an error::"},
      ExperimentManualSamplePreparation[{
        Incubate[
          Time->5 Minute
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "CellPreparationFunctionRecommended", "If ExperimentManualSamplePreparation is called on a Living or Sterile sample and ManualCellPreparation is a compatible Method for the input primitive(s), a warning is thrown:"},
      ExperimentManualSamplePreparation[
        {
          Incubate[
            Sample -> Object[Sample,"Test water sample 11 (Living) in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID],
            Time -> 5 Minute
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualSamplePreparation]],
      Messages:>{
        Warning::CellPreparationFunctionRecommended
      }
    ],

    (* -- Basic Manual Tests -- *)
    Test["Make sure that the unit operation inputs expander is working correctly (previously had a problem expanding the source option because it thought the destination option was of length 2):",
      ExperimentManualSamplePreparation[{
        LabelContainer[
          Label->"Container 1",
          Container->Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]
        ],
        Transfer[
          Source->Model[Sample, "Isopropanol"],
          Amount->30*Microliter,
          Destination->{"A1","Container 1"}
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Amount->30*Microliter,
          Destination->{"A2","Container 1"}
        ]
      }],
      ObjectP[Object[Protocol]]
    ],
    Test["Another simple expanding test:",
      ExperimentManualSamplePreparation[{
        LabelContainer[
          Label -> "My Plate",
          Container -> Model[Container, Plate, "384-well Polypropylene Echo Qualified Plate"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Amount -> 60 Microliter,
          Destination -> {{"A1", "My Plate"}, {"A2", "My Plate"}},
          DestinationLabel -> {"My Sample 1", "My Sample 2"}
        ]
      }],
      ObjectP[Object[Protocol]]
    ],
    Test["Generate a protocol based on a single incubate unit operation:",
      ExperimentManualSamplePreparation[{
        Incubate[
          Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
          SampleLabel -> "best sample ever",
          Time -> 5 Minute
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["Generate a protocol based on a single input as {Position,Container}:",
      ExperimentManualSamplePreparation[{
        Incubate[
          Sample -> {"A1", Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentManualSamplePreparation" <> $SessionUUID]},
          SampleLabel -> "best sample ever",
          Time -> 5 Minute
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["Generate a protocol based on a transfer unit operation and then incubate the input as {Position,Container}:",
      ExperimentManualSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            DestinationContainerLabel -> "container label",
            Amount -> 3 Milliliter
          ],
          Incubate[
            Sample -> {"A1", "container label"},
            Time -> 5 Minute]
        }
      ],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["Specify any IncompatibleMaterials for a sample using a LabelSample primitive in an ExperimentManualSamplePreparation call:",
      protocol = ExperimentManualSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample,"Milli-Q water"],
            Destination -> Model[Container,Vessel,"2mL Tube"],
            Amount -> 0.5 Milliliter
          ],
          LabelSample[
            Sample -> "transfer destination sample 1",
            ShelfLife -> 1 Week,
            IncompatibleMaterials -> {Glass}
          ]
        }
      ];
      Download[protocol, {Object, OutputUnitOperations[[2]][IncompatibleMaterials]}],
      {
        ObjectP[Object[Protocol, ManualSamplePreparation]],
        {{Glass}}
      },
      Variables:>{protocol}
    ],
    Test["Specify multiple IncompatibleMaterials for the same sample using a LabelSample primitive in an ExperimentManualSamplePreparation call:",
      protocol = ExperimentManualSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample,"Milli-Q water"],
            Destination -> Model[Container,Vessel,"2mL Tube"],
            Amount -> 0.5 Milliliter
          ],
          LabelSample[
            Sample -> "transfer destination sample 1",
            ShelfLife -> 1 Week,
            IncompatibleMaterials -> {Glass, BorosilicateGlass}
          ]
        }
      ];
      Download[protocol, {Object, OutputUnitOperations[[2]][IncompatibleMaterials]}],
      {
        ObjectP[Object[Protocol, ManualSamplePreparation]],
        {{Glass, BorosilicateGlass}}
      },
      Variables:>{protocol}
    ],
    Test["Postprocessing options from the ExperimentManualSamplePreparation call are shared with each unit operations that they are not already specified for:",
      protocol=ExperimentManualSamplePreparation[
        {
          LabelContainer[
            Label->"container",
            Container->Model[Container,Vessel,"50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"container",
            Amount->3 Milliliter,
            MeasureWeight->False
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"container",
            Amount->10 Milliliter,
            MeasureVolume->False,
            ImageSample->True
          ],
          Incubate[
            Sample->"container",
            Time->5 Minute
          ]
        },
        ImageSample->False,
        MeasureWeight->True
      ];
      Download[
        protocol,
        {
          ImageSample,
          MeasureVolume,
          MeasureWeight,
          OutputUnitOperations[{ImageSample,MeasureVolume,MeasureWeight}]
        }
      ],
      {
        False,
        True,
        True,
        {
          {Null,Null,Null},
          {False,True,False},
          {True,False,True},
          {False,True,True}}
      },
      Variables:>{protocol}
    ],
    Test["Postprocessing options from the ExperimentManualSamplePreparation call automatically resolve to False if a Sterile sample is present in the protocol:",
      protocol=ExperimentManualSamplePreparation[
        {
          Incubate[
            Sample -> Object[Sample,"Test water sample 10 (Sterile) in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID],
            Time -> 5 Minute
          ]
        },
        ImageSample -> Automatic,
        MeasureVolume -> Automatic,
        MeasureWeight -> Automatic
      ];
      Download[
        protocol,
        {
          ImageSample,
          MeasureVolume,
          MeasureWeight,
          OutputUnitOperations[{ImageSample,MeasureVolume,MeasureWeight}]
        }
      ],
      {
        False,
        False,
        False,
        {{False, False, False}}
      },
      Variables:>{protocol}
    ],
    Test["Postprocessing options from the ExperimentManualSamplePreparation call automatically resolve to False if a Living sample is present in the protocol:",
      protocol=ExperimentManualSamplePreparation[
        {
          Incubate[
            Sample -> Object[Sample,"Test water sample 11 (Living) in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID],
            Time -> 5 Minute
          ]
        },
        ImageSample -> Automatic,
        MeasureVolume -> Automatic,
        MeasureWeight -> Automatic
      ];
      Download[
        protocol,
        {
          ImageSample,
          MeasureVolume,
          MeasureWeight,
          OutputUnitOperations[{ImageSample,MeasureVolume,MeasureWeight}]
        }
      ],
      {
        False,
        False,
        False,
        {{False, False, False}}
      },
      Variables:>{protocol},
      Messages:>{Warning::CellPreparationFunctionRecommended}
    ],
    Test["Generate a protocol based on a single mix unit operation:",
      ExperimentManualSamplePreparation[{
        Mix[
          Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
          MixType -> Vortex,
          Time -> 5 Minute
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["Generate a protocol based on a single transfer unit operation:",
      ExperimentManualSamplePreparation[{
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->Model[Container, Vessel, "50mL Tube"],
          DestinationContainerLabel->"container label",
          Amount->3 Milliliter
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]],
      TimeConstraint -> 10000
    ],
    Test["Generate a protocol based on a single PCR unit operation:",
      ExperimentManualSamplePreparation[{
        PCR[
          Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]
        ]
      }],
      ObjectP[Object[Protocol,ManualSamplePreparation]]
    ],
    Test["Expands index matching inputs correctly:",
      ExperimentManualSamplePreparation[{
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> ConstantArray[Model[Container, Vessel, "50mL Tube"], 3],
          Amount -> 20 Milliliter
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["Setting OptimizeUnitOperations->False makes the optimizer not touch our transfer order:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[{
          LabelContainer[
            Label -> "destination container",
            Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],
          LabelSample[
            Label -> "water",
            Sample->Model[Sample,"Milli-Q water"],
            Container->Model[Container, Plate, "id:54n6evLWKqbG"]
          ],
          Transfer[
            Source -> {
              "water",
              "water",
              "water",
              "water"
            },
            Destination -> {
              {"A1","destination container"},
              {"C1","destination container"},
              {"B1","destination container"},
              {"D1","destination container"}
            },
            Amount -> {
              30 Microliter,
              30 Microliter,
              30 Microliter,
              30 Microliter
            },
            Tips -> {
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"]
            }
          ]
        }, OptimizeUnitOperations->False];

        Download[protocol, OutputUnitOperations[[3]][DestinationWell]]
      ],
      {
        "A1",
        "C1",
        "B1",
        "D1"
      }
    ],
    Test["Optimize transfer order with OptimizeUnitOperations->True (by default):",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[{
          LabelContainer[
            Label -> "destination container",
            Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],
          LabelSample[
            Label -> "water",
            Sample->Model[Sample,"Milli-Q water"],
            Container->Model[Container, Plate, "id:54n6evLWKqbG"]
          ],
          Transfer[
            Source -> {
              "water",
              "water",
              "water",
              "water"
            },
            Destination -> {
              {"A1","destination container"},
              {"C1","destination container"},
              {"B1","destination container"},
              {"D1","destination container"}
            },
            Amount -> {
              30 Microliter,
              30 Microliter,
              30 Microliter,
              30 Microliter
            },
            Tips -> {
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"]
            }
          ]
        }];

        Download[protocol, OutputUnitOperations[[3]][DestinationWell]]
      ],
      {
        "A1",
        "B1",
        "C1",
        "D1"
      }
    ],
    Test["When re-ordering transfers, make sure not to optimize transfers such that we use a destination as a source before that transfer actually happens:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[{
          LabelContainer[
            Label -> "destination container",
            Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],
          LabelSample[
            Label -> "water",
            Sample->Model[Sample,"Milli-Q water"],
            Container->Model[Container, Plate, "id:54n6evLWKqbG"]
          ],
          Transfer[
            Source -> {
              "water",
              "water",
              "water",
              "water",

              {"A1","destination container"},
              {"C1","destination container"},
              {"B1","destination container"},
              {"A1","destination container"}
            },
            Destination -> {
              {"A1","destination container"},
              {"C1","destination container"},
              {"B1","destination container"},
              {"D1","destination container"},

              {"C1","destination container"},
              {"B1","destination container"},
              {"A1","destination container"},
              {"D1","destination container"}
            },
            Amount -> 30 Microliter,
            Tips -> Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"]
          ]
        }];

        Download[protocol, OutputUnitOperations[[3]][DestinationWell]]
      ],
      {
        "A1",
        "B1",
        "C1",
        "D1",

        "C1",
        "B1",
        "A1",
        "D1"
      }
    ],
    Test["Make sure that our optimizer doesn't mess up plate stamps where there are multiple tip types:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[{
          LabelContainer[
            Label -> "destination container",
            Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],
          LabelSample[
            Label -> "water",
            Sample->Model[Sample,"Milli-Q water"],
            Container->Model[Container, Plate, "id:54n6evLWKqbG"]
          ],
          Transfer[
            Source -> {
              "water",
              Sequence@@ConstantArray["water", 96]
            },
            Destination -> {
              {"A1","destination container"},
              Sequence@@(({#,"destination container"}&/@Flatten[AllWells[]]))
            },
            Amount -> {
              30 Microliter,
              Sequence@@ConstantArray[50 Microliter, 96]
            },
            Tips -> {
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
              Sequence@@ConstantArray[Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"], 96]
            }
          ]
        }];

        Download[protocol, OutputUnitOperations[[3]][Tips]]
      ],
      {
        ObjectP[Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"]],
        ObjectP[Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"]]..
      }
    ],
    Test["Make sure that our optimizer doesn't mess up plate stamps where there are multiple tip types 2:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[{
          LabelContainer[
            Label -> "destination container",
            Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],
          LabelSample[
            Label -> "water",
            Sample->Model[Sample,"Milli-Q water"],
            Container->Model[Container, Plate, "id:54n6evLWKqbG"]
          ],
          Transfer[
            Source -> {
              "water",
              "water",
              "water",
              "water",
              Sequence@@ConstantArray["water", 96*5]
            },
            Destination -> {
              {"A1","destination container"},
              {"A1","destination container"},
              {"A1","destination container"},
              {"A1","destination container"},
              Sequence@@(({#,"destination container"}&/@Flatten[AllWells[]])),
              Sequence@@(({#,"destination container"}&/@Flatten[AllWells[]])),
              Sequence@@(({#,"destination container"}&/@Flatten[AllWells[]])),
              Sequence@@(({#,"destination container"}&/@Flatten[AllWells[]])),
              Sequence@@(({#,"destination container"}&/@Flatten[AllWells[]]))
            },
            Amount -> {
              30 Microliter,
              50 Microliter,
              50 Microliter,
              50 Microliter,
              Sequence@@ConstantArray[50 Microliter, 96*5]
            },
            Tips -> {
              Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
              Model[Item, Tips, "300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
              Model[Item, Tips, "300 uL Hamilton barrier tips, sterile"],
              Model[Item, Tips, "1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice"],
              Sequence@@ConstantArray[Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"], 96*5]
            }
          ]
        }];

        {
          Length/@Split[Download[protocol[OutputUnitOperations][[3]], MultichannelTransferName]],
          Download[protocol[OutputUnitOperations][[3]], Tips[Object]]
        }
      ],
      {
        {4, 96, 96, 96, 96, 96},
        Download[
          {
            Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
            Model[Item, Tips, "300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
            Model[Item, Tips, "300 uL Hamilton barrier tips, sterile"],
            Model[Item, Tips, "1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice"],
            Sequence@@ConstantArray[Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"], 96*5]
          },
          Object
        ]
      }
    ],
    Test["Using the multi probe head requires stacked tip models to be placed on different positions on deck so that we don't run out of tips (see partitionTips function for more information)",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelSample[
            Label->"water",
            Sample->Model[Sample,"Milli-Q water"],
            Amount->200 Milliliter,
            Container->Model[Container,Plate,"200mL Polypropylene Robotic Reservoir, non-sterile"]
          ],
          LabelContainer[
            Label->"dest",
            Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],

          Transfer[
            Source->"water",
            Destination->({#,"dest"}&)/@Flatten[AllWells[]],
            Amount->200 Microliter
          ],

          Transfer[
            Source->"water",
            Destination->Sequence@@@ConstantArray[(({#,"dest"}&)/@Flatten[AllWells[]][[1;;6]]),3],
            Amount->200 Microliter
          ],

          Mix[
            Sample->({#,"dest"}&)/@Flatten[AllWells[]][[1;;6]],
            MixType->Pipette,
            NumberOfMixes->20,
            MixVolume->100 Microliter
          ]
        },OptimizeUnitOperations->False];

        Download[Cases[protocol[RequiredResources], {obj_, RequiredTips, ___} :> obj], Amount]
      ],
      (* Two tip positions, of 96 tips each instead of one tip position of 96 + change tips. *)
      {Quantity[144, "Unities"], Quantity[384, "Unities"]}|{Quantity[384, "Unities"], Quantity[144, "Unities"]},
      TimeConstraint -> 10000
    ],
    Test["Using the multi probe head requires stacked tip models to be placed on different positions on deck so that we don't run out of tips test 2 (see partitionTips function for more information)",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelSample[
            Label->"water",
            Sample->Model[Sample,"Milli-Q water"],
            Amount->200 Milliliter,
            Container->Model[Container,Plate,"200mL Polypropylene Robotic Reservoir, non-sterile"]
          ],
          LabelContainer[
            Label->"dest",
            Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],

          Transfer[
            Source->"water",
            Destination->({#,"dest"}&)/@Flatten[AllWells[]],
            Amount->200 Microliter
          ],

          Transfer[
            Source->"water",
            Destination->(({#,"dest"}&)/@Flatten[AllWells[]][[1;;6]]),
            Amount->200 Microliter
          ],

          Transfer[
            Source->"water",
            Destination->({#,"dest"}&)/@Flatten[AllWells[]],
            Amount->200 Microliter
          ],

          Transfer[
            Source->"water",
            Destination->(({#,"dest"}&)/@Flatten[AllWells[]][[1;;6]]),
            Amount->200 Microliter
          ],

          Transfer[
            Source->"water",
            Destination->({#,"dest"}&)/@Flatten[AllWells[]],
            Amount->200 Microliter
          ],
          Transfer[
            Source->"water",
            Destination->(({#,"dest"}&)/@Flatten[AllWells[]][[1;;6]]),
            Amount->200 Microliter
          ],

          Transfer[
            Source->"water",
            Destination->({#,"dest"}&)/@Flatten[AllWells[]],
            Amount->200 Microliter
          ]
        }];

        Download[Cases[protocol[RequiredResources], {obj_, RequiredTips, ___} :> obj], Amount]
      ],
      {Quantity[270, "Unities"], Quantity[384, "Unities"]}|{Quantity[384, "Unities"], Quantity[270, "Unities"]},
      TimeConstraint -> 10000
    ],
    Test["When using non-stacked tips in RoboticCellPreparation, a tip box is requested:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[
          {
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
              Amount -> 500 Microliter,
              Tips -> Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"]
            ]
          }
        ];

        Download[protocol, TipRacks]
      ],
      {ObjectP[]..},
      TimeConstraint -> 10000
    ],
    Test["Make sure that the unit operation optimizer correctly adds a cover unit operation to the end of the robotic grouping 1:",
      ExperimentRoboticSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
            Amount -> 500 Microliter
          ]
        },
        Output->Input
      ],
      {_Transfer, _Cover},
      TimeConstraint -> 10000
    ],
    Test["Make sure that the unit operation optimizer correctly adds a cover unit operation to the end of the robotic grouping 2:",
      ExperimentSamplePreparation[
        {
          RoboticSamplePreparation[
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
              Amount -> 500 Microliter
            ]
          ]
        },
        Output->Input
      ],
      {RoboticSamplePreparation[_Transfer, _Cover]},
      TimeConstraint -> 10000
    ],
    Test["Simple label followed by a few transfers should result in the labeled sample getting its amount resolved correctly:",
      Module[{protocol},
        protocol=ExperimentManualSamplePreparation[{
          LabelSample[
            Label->"my sample",
            Sample->Model[Sample, "Milli-Q water"],
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          Transfer[
            Source->"my sample",
            Destination->Model[Container, Vessel, "50mL Tube"],
            Amount->3 Milliliter
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->"my sample",
            Amount->500 Microliter
          ],
          Transfer[
            Source->"my sample",
            Destination->Model[Container, Vessel, "50mL Tube"],
            Amount->5 Milliliter
          ]
        }];

        Download[FirstCase[Download[protocol, RequiredResources], {obj_, LabeledObjects, _, _}:>obj], Amount]
      ],
      RangeP[Quantity[7.999, "Milliliters"], Quantity[8.001, "Milliliters"]],
      TimeConstraint -> 10000
    ],

    Test["Simple label sample with Restricted option set to True should throw no errors:",
      Module[{protocol},
        protocol=ExperimentManualSamplePreparation[{
          LabelSample[
            Label->"my sample",
            Sample->Model[Sample, "Milli-Q water"],
            Container->Model[Container, Vessel, "50mL Tube"],
            Restricted->True
          ],
          Transfer[
            Source->"my sample",
            Destination->Model[Container, Vessel, "50mL Tube"],
            Amount->3 Milliliter
          ]
        }];

        True
      ],
      True,
      TimeConstraint -> 10000
    ],

    Test["Labeling multiple samples with different Restricted options should not throw an error",
      Module[{protocol},
        protocol=ExperimentManualSamplePreparation[{
          LabelSample[
            Label -> {"my sample 1", "my sample 2", "my sample 3"},
            Sample -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
            Restricted -> {True, False, True}
          ],
          Transfer[
            Source-> {"my sample 1", "my sample 2", "my sample 3"},
            Destination-> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
            Amount-> {3 Milliliter, 3 Milliliter, 3 Milliliter}
          ]
        }];

        True
      ],
      True,
      TimeConstraint -> 10000
    ],

    Test["LabelSample doesn't wall of red when trying to label a sample that doesn't exist:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelContainer[
            Label -> "My Filter Plate 1",
            Container -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"]
          ],
          LabelContainer[
            Label -> "My Collection Plate 1",
            Container -> Model[Container, Plate, "96-well UV-Star Plate"]
          ],
          LabelSample[
            Label -> "sample",
            Container -> "My Filter Plate 1",
            Well -> "A1"
          ],
          Transfer[
            Source -> Object[Sample, "Glorious Water Sample 1"],
            Destination -> "sample",
            Amount -> 15 Microliter
          ]
        }];

        True
      ],
      True,
      TimeConstraint -> 10000,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Test["Doing RoboticSamplePreparation protocols allows transfer amounts over 970 Microliter:",
      ExperimentRoboticSamplePreparation[{
        LabelSample[
          Label->"my sample",
          Sample->Model[Sample, "Milli-Q water"],
          Container->Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source->"my sample",
          Destination->Model[Container, Vessel, "50mL Tube"],
          Amount->10 Milliliter
        ]
      }],
      ObjectP[Object[Protocol]],
      TimeConstraint -> 10000
    ],
    Test["Simple label followed by a few transfers should result in the labeled sample getting its amount resolved correctly:",
      Module[{protocol},
        protocol=ExperimentManualSamplePreparation[{
          LabelSample[
            Label->"my sample",
            Sample->Model[Sample, "Milli-Q water"],
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          Transfer[
            Source->"my sample",
            Destination->Model[Container, Vessel, "50mL Tube"],
            Amount->3 Milliliter
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->"my sample",
            Amount->500 Microliter
          ],
          Transfer[
            Source->"my sample",
            Destination->Model[Container, Vessel, "50mL Tube"],
            Amount->5 Milliliter
          ]
        }];

        Download[FirstCase[Download[protocol, RequiredResources], {obj_, LabeledObjects, _, _}:>obj], Amount]
      ],
      RangeP[Quantity[7.999, "Milliliters"], Quantity[8.001, "Milliliters"]],
      TimeConstraint -> 10000
    ],
    Test["Optimizing together several transfers even though they use labels (the labels are defined before the transfer begin) -- ends up with {LabelSample, Transfer, Mix, Cover}:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelContainer[
            Label -> "Analyte Plate",
            Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],

          Transfer[
            Source -> Model[Sample, StockSolution, "id:n0k9mG8zoW16"],
            Destination -> {"A1", "Analyte Plate"},
            Amount -> Quantity[340., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Flow Linearity Sample"],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"B1", "Analyte Plate"},
            Amount -> Quantity[350., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Proportioning Sample"],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"C1", "Analyte Plate"},
            Amount -> Quantity[204., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Autosampler Sample"],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"C1", "Analyte Plate"},
            Amount -> Quantity[204., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Autosampler Sample"],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"D1", "Analyte Plate"},
            Amount -> Quantity[315., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Wavelength Accuracy Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"E1", "Analyte Plate"},
            Amount -> Quantity[400, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "1. Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"F1", "Analyte Plate"},
            Amount -> Quantity[320, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.8 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"F1", "Analyte Plate"},
            Amount -> Quantity[80, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.8 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"G1", "Analyte Plate"},
            Amount -> Quantity[240, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.4 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"G1", "Analyte Plate"},
            Amount -> Quantity[160, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.4 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"H1", "Analyte Plate"},
            Amount -> Quantity[320, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.2 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"H1", "Analyte Plate"},
            Amount -> Quantity[80, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.2 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"A2", "Analyte Plate"},
            Amount -> Quantity[360, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.1 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"A2", "Analyte Plate"},
            Amount -> Quantity[40, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[40, "Microliters"],
            DestinationLabel -> "0.1 Detector Linearity Sample"],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:bq9LA0JdZOda"],
            Destination -> {"B2", "Analyte Plate"},
            Amount -> Quantity[400, "Microliters"],
            DestinationLabel -> "Blank Sample"],

          Mix[
            Sample -> "1. Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ],
          Mix[
            Sample -> "0.8 Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ],
          Mix[
            Sample -> "0.4 Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ],
          Mix[
            Sample -> "0.2 Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ],
          Mix[
            Sample -> "0.1 Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ]
        }];

        Length[Download[protocol, OutputUnitOperations]]
      ],
      4
    ],
    Test["Correctly detects that vials with a LiquidHandlerAdapter are going into this adapter and doesn't double count their footprints towards the total footprint count:",
      ExperimentRoboticSamplePreparation[
        Table[
          LabelContainer[Label -> "container " <> ToString[x], Container -> Model[Container, Vessel, "id:pZx9jo8MaknP"]],
          {x, 0, 50}
        ]
      ],
      ObjectP[Object[Protocol]]
    ],
    Test["Calling the function with Output->Inputs returns the optimized (NOT calculated) unit operations inside of method headers. This is important so that the command builder front end doesn't think that all options in the optimized unit operations are specified:",
      ExperimentSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 1 Milliliter
          ]
        },
        Output->Input
      ],
      {RoboticSamplePreparation[Verbatim[Transfer][_Association?(Length[#]==3&)]]}
    ],
    Test["Calling ExperimentSamplePreparationInputs returns fully calculated unit operations:",
      ExperimentSamplePreparationInputs[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 1 Milliliter
          ]
        }
      ],
      {RoboticSamplePreparation[Verbatim[Transfer][_Association?(Length[#]>3&)]]}
    ],
    Test["ExperimentSamplePreparation can handle very malformed inputs:",
      ValidExperimentSamplePreparationQ[
        {
          ManualSamplePreparation[
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination
            ]
          ]
        },
        Verbose -> Failures
      ],
      False,
      Messages:>{
        Error::InvalidUnitOperationValues,
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Test["Optimize together several transfers, but in two separate transfer groups since they refer to labels created in previous transfers -- ends up with {LabelContainer, Transfer, Transfer, Mix}:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelContainer[
            Label -> "Analyte Plate",
            Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],

          Transfer[
            Source -> Model[Sample, StockSolution, "id:n0k9mG8zoW16"],
            Destination -> {"A1", "Analyte Plate"},
            Amount -> Quantity[340., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Flow Linearity Sample"
          ],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"B1", "Analyte Plate"},
            Amount -> Quantity[350., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Proportioning Sample"],
          Transfer[
            Source -> "Proportioning Sample",
            Destination -> {"C1", "Analyte Plate"},
            Amount -> Quantity[204., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Autosampler Sample"],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"C1", "Analyte Plate"},
            Amount -> Quantity[204., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Autosampler Sample"],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"D1", "Analyte Plate"},
            Amount -> Quantity[315., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Wavelength Accuracy Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"E1", "Analyte Plate"},
            Amount -> Quantity[400, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "1. Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"F1", "Analyte Plate"},
            Amount -> Quantity[320, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.8 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"F1", "Analyte Plate"},
            Amount -> Quantity[80, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.8 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"G1", "Analyte Plate"},
            Amount -> Quantity[240, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.4 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"G1", "Analyte Plate"},
            Amount -> Quantity[160, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.4 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"H1", "Analyte Plate"},
            Amount -> Quantity[320, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.2 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"H1", "Analyte Plate"},
            Amount -> Quantity[80, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.2 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"A2", "Analyte Plate"},
            Amount -> Quantity[360, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.1 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"A2", "Analyte Plate"},
            Amount -> Quantity[40, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[40, "Microliters"],
            DestinationLabel -> "0.1 Detector Linearity Sample"
          ],
          Transfer[
            Source -> Model[Sample, StockSolution, "id:bq9LA0JdZOda"],
            Destination -> {"B2", "Analyte Plate"},
            Amount -> Quantity[400, "Microliters"],
            DestinationLabel -> "Blank Sample"],

          Mix[
            Sample -> "1. Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ],
          Mix[
            Sample -> "0.8 Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ],
          Mix[
            Sample -> "0.4 Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ],
          Mix[
            Sample -> "0.2 Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ],
          Mix[
            Sample -> "0.1 Detector Linearity Sample",
            NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]
          ]
        }];

        Length[Download[protocol, OutputUnitOperations]]
      ],
      5
    ],
    Test["The output unit operations will not link to the same objects if running the same primitives twice to make two protocol objects:",
      Module[{primitives, protocol1, protocol2},
        primitives={LabelContainer[Label -> "Analyte Plate",
          Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
          Transfer[Source -> Model[Sample, StockSolution, "id:n0k9mG8zoW16"],
            Destination -> {"A1", "Analyte Plate"},
            Amount -> Quantity[340., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Flow Linearity Sample"],
          Transfer[Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"B1", "Analyte Plate"},
            Amount -> Quantity[350., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Proportioning Sample"],
          Transfer[Source -> "Proportioning Sample",
            Destination -> {"C1", "Analyte Plate"},
            Amount -> Quantity[204., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Autosampler Sample"],
          Transfer[Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"C1", "Analyte Plate"},
            Amount -> Quantity[204., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Autosampler Sample"],
          Transfer[Source -> Model[Sample, StockSolution, "id:R8e1PjpR1k0n"],
            Destination -> {"D1", "Analyte Plate"},
            Amount -> Quantity[315., "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "Wavelength Accuracy Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"E1", "Analyte Plate"},
            Amount -> Quantity[400, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "1. Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"F1", "Analyte Plate"},
            Amount -> Quantity[320, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.8 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"F1", "Analyte Plate"},
            Amount -> Quantity[80, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.8 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"G1", "Analyte Plate"},
            Amount -> Quantity[240, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.4 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"G1", "Analyte Plate"},
            Amount -> Quantity[160, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.4 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"H1", "Analyte Plate"},
            Amount -> Quantity[320, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.2 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"H1", "Analyte Plate"},
            Amount -> Quantity[80, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.2 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
            Destination -> {"A2", "Analyte Plate"},
            Amount -> Quantity[360, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[150, "Microliters"],
            DestinationLabel -> "0.1 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, "id:L8kPEjn8pBbG"],
            Destination -> {"A2", "Analyte Plate"},
            Amount -> Quantity[40, "Microliters"], AspirationMix -> True,
            NumberOfAspirationMixes -> 1,
            AspirationMixVolume -> Quantity[40, "Microliters"],
            DestinationLabel -> "0.1 Detector Linearity Sample"],
          Transfer[Source -> Model[Sample, StockSolution, "id:bq9LA0JdZOda"],
            Destination -> {"B2", "Analyte Plate"},
            Amount -> Quantity[400, "Microliters"],
            DestinationLabel -> "Blank Sample"],
          Mix[Sample -> "1. Detector Linearity Sample", NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]],
          Mix[Sample -> "0.8 Detector Linearity Sample", NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]],
          Mix[Sample -> "0.4 Detector Linearity Sample", NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]],
          Mix[Sample -> "0.2 Detector Linearity Sample", NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]],
          Mix[Sample -> "0.1 Detector Linearity Sample", NumberOfMixes -> 10,
            MixVolume -> Quantity[200, "Microliters"]]};

        ClearMemoization[];

        protocol1=ExperimentRoboticSamplePreparation[primitives];

        protocol2=ExperimentRoboticSamplePreparation[primitives];

        !MatchQ[
          Download[protocol1, OutputUnitOperations[Object]],
          Download[protocol2, OutputUnitOperations[Object]]
        ]
      ],
      True
    ],
    Test["Simple label container with Restricted option set to True should throw no errors:",
      Module[{protocol},
        protocol=ExperimentManualSamplePreparation[{
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"],
            Restricted->True
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->"my container",
            Amount->5 Milliliter
          ]
        }];
        True
      ],
      True,
      TimeConstraint -> 10000
    ],
    Test["Labeling multiple containers with different Restricted options should not throw an error",
      Module[{protocol},
        protocol=ExperimentManualSamplePreparation[{
          LabelContainer[
            Label -> {"my container 1", "my container 2", "my container 3"},
            Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
            Restricted -> {True, False, True}
          ],
          Transfer[
            Source-> Model[Sample, "Milli-Q water"],
            Destination-> {"my container 1", "my container 2", "my container 3"},
            Amount-> {3 Milliliter, 3 Milliliter, 3 Milliliter}
          ]
        }];
        True
      ],
      True,
      TimeConstraint -> 10000
    ],
    Test["Transfer using a container label multiple times:",
      Module[{protocol},
        protocol=ExperimentManualSamplePreparation[{
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->"my container",
            Amount->5 Milliliter
          ],
          Transfer[
            Source->"my container",
            Destination->Model[Container, Vessel, "50mL Tube"],
            Amount->500 Microliter
          ]
        }];

        Download[FirstCase[Download[protocol, RequiredResources], {obj_, LabeledObjects, _, _}:>obj], Models]
      ],
      {ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]},
      TimeConstraint -> 10000
    ],
    Test["Transfer a sample into a volumetric flask, and then fill that sample to a volume:",
      ExperimentManualSamplePreparation[{
        LabelSample[
          Label->"my sample",
          Sample->Model[Sample, "Sodium Chloride"],
          Container->Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source->"my sample",
          Destination->Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
          Amount->300 Milligram,
          DestinationLabel -> "my sample in volumetric flask"
        ],
        FillToVolume[
          Sample->"my sample in volumetric flask",
          TotalVolume -> 100 Milliliter,
          Solvent -> Model[Sample, "Milli-Q water"]
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]],
      TimeConstraint -> 10000
    ],
    Test["Overwriting a container label results in an error message being thrown:",
      ExperimentManualSamplePreparation[
        {
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          LabelSample[
            Label->"my sample",
            Sample->Model[Sample, "Milli-Q water"],
            Amount->50 Milliliter
          ],
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"]
          ]
        },
        OptimizeUnitOperations->False
      ],
      $Failed,
      Messages:>{
        Error::OverwrittenLabels,
        Error::InvalidInput
      }
    ],
    Test["Cannot perform a transfer from an empty container:",
      ExperimentRoboticSamplePreparation[
        {
          LabelContainer[
            Label -> "myplate",
            Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
          ],
          Transfer[
            Source -> {"A1", "myplate"},
            Amount ->(250*Microliter),
            Destination -> Model[Container, Vessel, "2mL Tube"]
          ]
        }
      ],
      $Failed,
      Messages:>{
        Error::InvalidTransferSource,
        Error::InvalidInput
      }
    ],
    Test["Generate a protocol using a label:",
      Module[{myProtocol},
        myProtocol=ExperimentManualSamplePreparation[{
          LabelSample[
            Label -> "best sample",
            Sample -> Model[Sample, "Milli-Q water"],
            Amount -> 1 Milliliter
          ],
          Incubate[
            Sample -> "best sample",
            Time -> 5 Minute
          ]
        }];

        Download[myProtocol, UnresolvedUnitOperationInputs]
      ],
      {
        {"best sample"},
        {"best sample"}
      },
      TimeConstraint -> 10000
    ],
    Test["Basic autofill functionality:",
      Module[{myProtocol},
        myProtocol=ExperimentManualSamplePreparation[
          {
            Incubate[
              Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute
            ],
            Incubate[
              Time -> 15 Minute
            ]
          },
          OptimizeUnitOperations->False
        ];

        Download[myProtocol, UnresolvedUnitOperationInputs]
      ],
      {
        {ObjectP[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]]},
        {ObjectP[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]]}
      }
    ],
    Test["Providing a container as input will result in it being expanded into all contents (like what happens in experiment functions)",
      Module[{myProtocol},
        myProtocol = ExperimentManualSamplePreparation[
          {
            LabelSample[
              Sample ->{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
              Label->{"my sample 1","my sample 2","my sample 3"},
              Amount->{1Milliliter,1.2Milliliter,0.5Milliliter},
              Container->Model[Container, Plate, "id:L8kPEjkmLbvW"],(* DWP *)
              ContainerLabel->"my cont",
              Well->{"A1","A2","A3"}
            ],
            Incubate[
              Sample->"my cont",
              Time->5 Minute
            ]
          }
        ];

        Download[myProtocol,UnresolvedUnitOperationInputs]
      ],
      {
        {"my sample 1","my sample 2","my sample 3"},
        {"my sample 1","my sample 2","my sample 3"}
      }
    ],
    Test["Test ResolvedOptionsJSON:",
      Block[{$Notebook = Object[LaboratoryNotebook, "id:01G6nvwalvo7"]},
        ECL`AppHelpers`ResolvedOptionsJSON[
          ExperimentSamplePreparation,
          {{
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> Model[Container, Vessel, "50mL Tube"],
              Amount -> 5 Milliliter
            ],
            ManualSamplePreparation[
              Transfer[
                Source -> Model[Sample, "Milli-Q water"],
                Destination -> Model[Container, Vessel, "50mL Tube"],
                Amount -> 5 Milliliter
              ]
            ],
            RoboticSamplePreparation[
              Transfer[
                Source -> Model[Sample, "Milli-Q water"],
                Destination -> Model[Container, Vessel, "50mL Tube"],
                Amount -> 100 Microliter
              ]
            ]
          }},
          {}
        ]
      ],
      _String
    ],
    Test["Basic autofill functionality that relies on LabelFields:",
      Module[{myProtocol},
        myProtocol=ExperimentManualSamplePreparation[
          {
            Incubate[
              Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute
            ],
            Incubate[
              Sample -> "best sample ever",
              Time -> 15 Minute
            ]
          },
          OptimizeUnitOperations->False
        ];

        Download[myProtocol, UnresolvedUnitOperationInputs]
      ],
      {
        {ObjectP[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]]},
        {ObjectP[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]]}
      }
    ],
    Test["Basic unit operation optimization test:",
      Module[{myProtocol},
        myProtocol=ExperimentManualSamplePreparation[
          {
            Incubate[
              Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute
            ],
            Incubate[
              Sample -> "best sample ever",
              Time -> 15 Minute
            ],
            Incubate[
              Time -> 15 Minute
            ],
            Mix[
              Time->30 Minute
            ]
          }
        ];

        Download[myProtocol, UnresolvedUnitOperationInputs]
      ],
      {
        {ObjectP[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]]},
        {ObjectP[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]], ObjectP[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]]},
        {ObjectP[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]]}
      }
    ],
    Test["Test LabelSample with the same ContainerName and different Well:",
      ExperimentManualSamplePreparation[{
        LabelSample[
          Label -> {"my sample 1", "my sample 2", "my sample 3", "my sample 4"},
          Sample -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
          Amount -> {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
          Container -> {Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Vessel, "id:jLq9jXvxr6OZ"], Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Vessel, "id:jLq9jXvxr6OZ"]},
          Well -> {"A1", "A1", "B1", "A1"},
          ContainerLabel -> {"my plate 1", "my tube 1", "my plate 1", "my tube 2"}
        ]
      }],
      ObjectP[Object[Protocol]]
    ],
    Test["Use Aliquot/SamplePrep options inside of a manual unit operation:",
      ExperimentManualSamplePreparation[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount->0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut->"aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["Framework correctly populates FutureLabeledObjects:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->Model[Container, Vessel, "50mL Tube"],
            Amount->500 Microliter,
            DestinationLabel->"new destination"
          ]
        }];

        Download[protocol, FutureLabeledObjects]
      ],
      {
        Verbatim[Rule][_String, _LabelField],
        Verbatim[Rule][_String, _LabelField]
      }
    ],
    Test["In manual preparation, no automatic Uncover unit operation is added even if the manipulations are to be done on a covered plate:",
      Module[{protocol},
        protocol=ExperimentManualSamplePreparation[{
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], DestinationWell -> "A1", DestinationLabel -> "water 1", Amount -> 100 Microliter],
          Cover[Sample -> "water 1"],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "water 1", Amount -> 100 Microliter]
        }];
        Download[protocol,OutputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation,Transfer]],
        ObjectP[Object[UnitOperation,Cover]],
        ObjectP[Object[UnitOperation,Transfer]]
      }
    ],

    (*---Centrifuge Integration Test---*)
    Test["Use Centrifuge inside of a manual unit operation:",
      ExperimentManualSamplePreparation[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Centrifuge[
          Sample -> {"stock solution"},
          Time -> 5 Minute, Intensity -> 3000 RPM
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["Use Centrifuge inside of a manual unit operation:",
      ExperimentManualSamplePreparation[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Centrifuge[
          Sample -> {"stock solution"},
          Time -> 5 Minute, Intensity -> 3000 RPM
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["Use Centrifuge for several samples inside of a manual unit operation:",
      ExperimentManualSamplePreparation[{
        Centrifuge[
          Sample -> {
            Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
            Object[Sample,  "Test water sample 2 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID]
          },
          Time -> 5 Minute,
          Intensity -> 3000 RPM
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],

    (* -- Plate Reader tests -- *)
    Example[
      {Basic,"Generate a protocol based on a single AbsorbanceSpectroscopy unit operation:"},
      ExperimentManualSamplePreparation[
        AbsorbanceSpectroscopy[
          Sample->{Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentManualSamplePreparation" <> $SessionUUID]},
          Preparation -> Manual
        ]
      ],
      ObjectP[Object[Protocol,ManualSamplePreparation]]
    ],
    Example[
      {Basic,"Generate a protocol based on a single AlphaScreen unit operation:"},
      ExperimentManualSamplePreparation[
        AlphaScreen[
          Sample->{Object[Sample,"Test AlphaScreen sample 8 in AlphaPlate for ExperimentManualSamplePreparation" <> $SessionUUID]}
        ]
      ],
      ObjectP[Object[Protocol,ManualSamplePreparation]]
    ],
    Example[
      {Basic,"Generate a protocol based on a single FluorescenceIntensity unit operation:"},
      ExperimentManualSamplePreparation[
        FluorescenceIntensity[
          Sample->{Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentManualSamplePreparation" <> $SessionUUID]}
        ]
      ],
      ObjectP[Object[Protocol,ManualSamplePreparation]]
    ],
    Example[
      {Basic,"Generate a protocol based on a single Nephelometry unit operation:"},
      ExperimentManualSamplePreparation[
        Nephelometry[
          Sample->{Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentManualSamplePreparation" <> $SessionUUID]}
        ]
      ],
      ObjectP[Object[Protocol,ManualSamplePreparation]],
      Messages :> {Warning::AmbiguousAnalyte}
    ],


    (* -- Stock Solution Tests -- *)
    Test["Stock Solution Integration Test 1:",
      Module[{myProtocol},
        myProtocol=ExperimentStockSolution[
          {
            {80 Gram,Model[Sample,"Sodium Chloride"]},
            {2 Gram,Model[Sample,"Potassium Chloride"]},
            {14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
            {2.4 Gram,Model[Sample,"Potassium Phosphate"]}
          },
          Model[Sample,"Milli-Q water"],
          1 Liter,
          FillToVolumeMethod->Volumetric
        ];

        TestResources[myProtocol];

        InternalExperiment`Private`compileStockSolution[myProtocol];

        ExperimentManualSamplePreparation[Download[myProtocol, Primitives]]
      ],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],

    (* -- Plate Reader Tests -- *)
    Test["Trying to robotically measure a sample (AbsorbanceSpectroscopy) in a 50mL tube results in an error:",
      ExperimentRoboticSamplePreparation[{
        AbsorbanceSpectroscopy[
          Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
          SampleLabel -> "best sample ever"
        ]
      }],
      $Failed,
      Messages:>{
        Error::ConflictingMethodRequirements,
        Error::InvalidInput
      },
      TimeConstraint->10000
    ],

    (* -- MagneticBeadSeparation Tests --  *)
    Example[{Basic,"Generate a Protocol based on a single MagneticBeadSeparation unit operation:"},
      ExperimentManualSamplePreparation[{
        MagneticBeadSeparation[
          Sample ->Object[Sample,"Test water sample 9 in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID],
          PreWash->True,
          Equilibration->True,
          Wash->True
        ]
      }],
      ObjectP[Object[Protocol,ManualSamplePreparation]],
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],

    Example[{Basic,"Generate a Protocol using MagneticBeadSeparation in a series of unit operations:"},
      ExperimentManualSamplePreparation[{
        LabelSample[
          Sample->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Label-> "my mbs sample"
        ],
        MagneticBeadSeparation[
          Sample ->"my mbs sample",
          PreWash->True,
          SampleOutLabel->{{{"my mbs sample out"}}}
        ],
        Transfer[
          Source -> "my mbs sample out",
          Destination -> Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentManualSamplePreparation" <> $SessionUUID],
          Amount -> All
        ]
      }],
      ObjectP[Object[Protocol,ManualSamplePreparation]],
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],

    Test["Generate a Protocol using MagneticBeadSeparation for multiple samples in a series of unit operations:",
      ExperimentManualSamplePreparation[{
        LabelSample[
          Sample->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Label-> {"my mbs sample 1","my mbs sample 2","my mbs sample 3"}
        ],
        MagneticBeadSeparation[
          Sample ->{"my mbs sample 1","my mbs sample 2","my mbs sample 3"},
          PreWash->True,
          SampleOutLabel->{"my mbs sample out 1","my mbs sample out 2","my mbs sample out 3"}
        ],
        Transfer[
          Source -> {"my mbs sample out 1","my mbs sample out 2","my mbs sample out 3"},
          Destination -> Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentManualSamplePreparation" <> $SessionUUID],
          Amount -> All
        ]
      }],
      ObjectP[Object[Protocol,ManualSamplePreparation]],
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],

    Test["Generate a Protocol using MagneticBeadSeparation for a mixture of sample and container inputs:",
      ExperimentManualSamplePreparation[{
        LabelContainer[
          Label->{"my mbs container 1","my mbs container 2","my mbs container 3"},
          Container->Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Destination->{"my mbs container 1","my mbs container 2","my mbs container 3"},
          DestinationLabel-> {"my mbs sample 1","my mbs sample 2","my mbs sample 3"}
        ],
        MagneticBeadSeparation[
          Sample ->{"my mbs sample 1","my mbs container 2","my mbs sample 3"},
          PreWash->True
        ]
      }],
      ObjectP[Object[Protocol,ManualSamplePreparation]],
      Messages:> {
        Warning::GeneralResolvedMagneticBeads
      }
    ],

    (* -- CrossFlowFiltration Tests --  *)
    Example[{Basic,"Generate a Protocol based on a single CrossFlowFiltration unit operation:"},
      ExperimentManualSamplePreparation[{
        CrossFlowFiltration[
          Sample ->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
          PrimaryConcentrationTarget->3,
          SecondaryConcentrationTarget->2,
          DiafiltrationBuffer->Model[Sample,StockSolution,"0.2M FITC"]
        ]
      }],
      ObjectP[Object[Protocol,ManualSamplePreparation]]
    ],

    Example[{Basic,"Generate a Protocol using CrossFlowFiltration in a series of unit operations:"},
      ExperimentManualSamplePreparation[
        {
          LabelSample[
            Sample -> Model[Sample, "Milli-Q water"],
            Amount -> 40 Milliliter,
            Label -> {"my cff sample 1", "my cff sample 2", "my cff sample 3"}
          ],
          CrossFlowFiltration[
            Sample -> {"my cff sample 1", "my cff sample 2", "my cff sample 3"},
            DiafiltrationBuffer -> Model[Sample, StockSolution, "0.2M FITC"],
            RetentateContainerOut -> {Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:jLq9jXvA8ewR"]},
            RetentateSampleOutLabel -> {"Retentate Out Sample 1", "Retentate Out Sample 2", "Retentate Out Sample 3"}
          ],
          Transfer[
            Source -> {"my cff sample 1", "my cff sample 2", "my cff sample 3"},
            Destination -> Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentManualSamplePreparation" <> $SessionUUID],
            Amount -> All]
        }
      ],
      ObjectP[Object[Protocol,ManualSamplePreparation]]
    ],

    Test["Generate a Protocol using CrossFlowFiltration for a mixture of sample and container inputs:",
      ExperimentManualSamplePreparation[{
        LabelContainer[
          Label->{"my cff container 1","my cff container 2","my cff container 3"},
          Container->Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Amount->40 Milliliter,
          Destination->{"my cff container 1","my cff container 2","my cff container 3"},
          DestinationLabel-> {"my cff sample 1","my cff sample 2","my cff sample 3"}
        ],
        CrossFlowFiltration[
          Sample ->{"my cff sample 1","my cff sample 2","my cff sample 3"}
        ]
      }],
      ObjectP[Object[Protocol,ManualSamplePreparation]]
    ],
	  Test["Throw a warning if any option is specified to use an object that is missing or expired:",
		  ExperimentManualSamplePreparation[{
			  LabelContainer[
				  Label->{"my cff container 1","my cff container 2","my cff container 3"},
				  Container->Model[Container, Vessel, "50mL Tube"]
			  ],
			  Transfer[
				  Source->Model[Sample, "Milli-Q water"],
				  Amount-> 3 Milliliter,
				  Instrument -> Object[Instrument, Pipette, "Test Missing Pipette for ExperimentManualSamplePreparation" <> $SessionUUID],
				  Destination -> "my cff container 1"
			  ]
		  }],
		  ObjectP[Object[Protocol,ManualSamplePreparation]],
		  Messages :> {Warning::OptionContainsUnusableObject}
	  ]
  },
  SymbolSetUp:>{
	  $CreatedObjects={};
    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ExpiredSamples];
    Off[Warning::SampleMustBeMoved];

	Module[{allObjects, existsFilter,
		tube1, tube2, tube3, tube4, tube5, tube6, plate6, plate7, plate8, plate9, plate10, plate11, missingPipette, sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11
	},
		(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
		allObjects = {
			Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Plate, "Test 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Plate, "Test 96-well UV Star Plate for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Plate, "Test 96-well AlphaPlate for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Plate, "Test 96 DWP 2 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Plate, "Test 96 DWP 3 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Container, Plate, "Test 96 DWP 4 for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Instrument, Pipette, "Test Missing Pipette for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test water sample 3 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test water sample 4 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test water sample 6 in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test plate reader sample 7 in UV Star plate for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test AlphaScreen sample 8 in AlphaPlate for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test water sample 9 in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test water sample 10 (Sterile) in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID],
			Object[Sample, "Test water sample 11 (Living) in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID]
		};

		(* Erase any objects that we failed to erase in the last unit test *)
		existsFilter = DatabaseMemberQ[allObjects];

		Quiet[EraseObject[
			PickList[
				allObjects,
				existsFilter
			],
			Force -> True,
			Verbose -> False
		]];

		(* Create some empty containers and a missing pipette. *)
		{tube1, tube2, tube3, tube4, tube5, tube6, plate6, plate7, plate8, plate9, plate10, plate11, missingPipette} = Upload[{
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test 50mL Tube 1 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test 50mL Tube 2 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test 50mL Tube 3 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test 50mL Tube 4 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test 50mL Tube 5 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test 50mL Tube 6 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "Test 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well UV-Star Plate"], Objects],
				Name -> "Test 96-well UV Star Plate for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], Objects],
				Name -> "Test 96-well AlphaPlate for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "Test 96 DWP 2 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "Test 96 DWP 3 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Name -> "Test 96 DWP 4 for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Instrument, Pipette],
				Model -> Link[Model[Instrument, Pipette, "id:KBL5Dvw6eLDk"], Objects], (*"Eppendorf Research Plus P5000"*)
				Name -> "Test Missing Pipette for ExperimentManualSamplePreparation" <> $SessionUUID,
				Site -> Link[$Site],
				Missing -> True,
				Status -> Available,
				DeveloperObject -> True
			|>
		}];

		(* Create some samples for testing purposes *)
		{sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11} = UploadSample[
			(* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
			{
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "id:vXl9j5qEn66B"], (* "Sodium carbonate, anhydrous" *)
				Model[Sample, "Milli-Q water"],
				Model[Sample, StockSolution, "0.2M FITC"],
				Model[Sample, StockSolution, "0.2M FITC"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"],
				Model[Sample, "Milli-Q water"]
			},
			{
				{"A1", tube1},
				{"A1", tube2},
				{"A1", tube3},
				{"A1", tube4},
				{"A1", tube5},
				{"A1", plate6},
				{"A1", plate7},
				{"A1", plate8},
				{"A1", plate9},
				{"A1", plate10},
				{"A1", plate11}
			},
			Name -> {
				"Test water sample 1 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test water sample 2 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test water sample 3 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test water sample 4 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test powder sample 5 in 50mL Tube for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test water sample 6 in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test plate reader sample 7 in UV Star plate for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test AlphaScreen sample 8 in AlphaPlate for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test water sample 9 in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test water sample 10 (Sterile) in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID,
				"Test water sample 11 (Living) in 96 DWP for ExperimentManualSamplePreparation" <> $SessionUUID
			},
			InitialAmount -> {
				25 Milliliter,
				10 Milliliter,
				10 Milliliter,
				10 Milliliter,
				10 Gram,
				1 Milliliter,
				200 Microliter,
				200 Microliter,
				1 Milliliter,
				1 Milliliter,
				1 Milliliter
			},
			SampleHandling -> {
				Liquid,
				Liquid,
				Liquid,
				Liquid,
				Powder,
				Liquid,
				Liquid,
				Liquid,
				Liquid,
				Liquid,
				Liquid
			}
		];

		(* Make some changes to our samples for testing purposes *)
		Upload[{
			<|Object -> sample1, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample2, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample3, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample4, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample5, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample6, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample7, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample8, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample9, Status -> Available, DeveloperObject -> True|>,
			<|Object -> sample10, Status -> Available, DeveloperObject -> True, Sterile -> True|>,
			<|Object -> sample11, Status -> Available, DeveloperObject -> True, Living -> True|>
		}];
	]
  },
  SymbolTearDown:>{
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ExpiredSamples];
    On[Warning::SampleMustBeMoved];
	EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects]],Force->True,Verbose->False];
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];

(* ::Subsection:: *)
(*Experiment*)

DefineTests[
  Experiment,
  {
    (* -- Input Validation Tests -- *)
    Module[{},
      Sequence@@{
        Example[
          {Messages, "InvalidUnitOperationMethods", "If given a unit operation method wrapper that isn't supported, throw an error:"},
          Experiment[{Test[Incubate[Sample->Object[Sample,"Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID]]]}],
          $Failed,
          Messages:>{
            Error::InvalidUnitOperationMethods,
            Error::InvalidInput
          }
        ],
        Example[
          {Messages, "InvalidUnitOperationOptions", "Tests the unit operations inside of a given unit operation method wrapper head:"},
          Experiment[{
            ManualSamplePreparation[
              Incubate[
                Sample->Object[Sample,"Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
                Time->5 Minute
              ],
              Incubate[
                Sample->Object[Sample,"Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
                Taco->"Yum!"
              ]
            ]
          }],
          $Failed,
          Messages:>{
            Error::InvalidUnitOperationOptions,
            Error::InvalidInput
          }
        ],
        Example[
          {Messages, "InvalidUnitOperationHeads", "If given a unit operation type that isn't supported, throw an error:"},
          Experiment[{Test[<||>]}],
          $Failed,
          Messages:>{
            Error::InvalidUnitOperationHeads,
            Error::InvalidInput
          }
        ],
        Example[
          {Messages, "InvalidUnitOperationHeads", "If given a unit operation whose required first input isn't given and it's the first unit operation, throw an error because we can't autofill it:"},
          Experiment[{Test[<||>]}],
          $Failed,
          Messages:>{
            Error::InvalidUnitOperationHeads,
            Error::InvalidInput
          }
        ],
        Example[
          {Messages, "InvalidUnitOperationRequiredOptions", "If given a unit operation with a missing required option, throw an error::"},
          Experiment[{Incubate[]}],
          $Failed,
          Messages:>{
            Error::InvalidUnitOperationRequiredOptions,
            Error::InvalidInput
          }
        ],
        Example[
          {Messages, "InvalidUnitOperationOptions", "If given a unit operation with an invalid option, throw an error:"},
          Experiment[{
            Incubate[
              Sample->Object[Sample,"Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
              Taco->"Yum!"
            ]
          }],
          $Failed,
          Messages:>{
            Error::InvalidUnitOperationOptions,
            Error::InvalidInput
          }
        ],
        Example[
          {Messages, "InvalidUnitOperationValues", "If given a unit operation with an invalid option value, throw an error:"},
          Experiment[{
            Incubate[
              Sample->100
            ]
          }],
          $Failed,
          Messages:>{
            Error::InvalidUnitOperationValues,
            Error::InvalidInput
          }
        ],
        Example[
          {Messages, "InvalidUnitOperationRequiredOptions", "If given a unit operation with a missing required option, throw an error::"},
          Experiment[{
            Incubate[
              Time->5 Minute
            ]
          }],
          $Failed,
          Messages:>{
            Error::InvalidUnitOperationRequiredOptions,
            Error::InvalidInput
          }
        ]
      }
    ],

    (* -- Framework Tests -- *)
    Test["Generate a script based on a mixture of manual and liquid handler unit operation:",
      Block[{ECL`ExperimentScript},
        Experiment[{
          ManualSamplePreparation[
            Incubate[
              Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute
            ]
          ],
          RoboticSamplePreparation[
            Incubate[
              Sample -> Object[Container,Plate,"Test 96 DWP for Experiment" <> $SessionUUID],
              Time -> 5 Minute
            ]
          ]
        }]
      ],
      ObjectP[Object[Notebook, Script]]
    ],
    Test["Resolving an invalid unit operation is okay (there is crazy message magic that we do that, make sure that isn't messed up):",
      Experiment[
        {
          (* Intentionally a bad unit operation that will cause a resolver error. *)
          Incubate[
            Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
            SampleLabel -> "best sample ever",
            Thaw -> True,
            ThawTime -> Null
          ]
        },
        Output->{Options, Input}
      ],
      {
        {_Rule..},
        {(_RoboticSamplePreparation|_ManualSamplePreparation|_ManualCellPreparation|_RoboticCellPreparation)..}
      },
      Messages:>{
        Error::MixThawOptionMismatch,
        Error::InvalidInput
      }
    ],
    Test["Test the input resolution of a few simple incubate unit operations:",
      Experiment[
        {
          Incubate[
            Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
            SampleLabel -> "best sample ever",
            Time -> 5 Minute,
            Preheat -> True
          ]
        },
        Output->{Options, Input}
      ],
      {
        {_Rule..},
        {(_RoboticSamplePreparation|_ManualSamplePreparation|_ManualCellPreparation|_RoboticCellPreparation)..}
      }
    ],
    Test["If Experiment is called on Sterile or Living samples with Preparation -> Robotic, generate an Object[Protocol, RoboticCellPreparation] and default all post processing options to False:",
      Module[
        {protocol},
        protocol = Experiment[
          {
            Incubate[
              Sample -> Object[Sample,"Test tissue culture sample in plate 1 (for Experiment tests)" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute,
              Preparation -> Robotic
            ]
          },
          ImageSample -> Automatic,
          MeasureWeight -> Automatic,
          MeasureVolume -> Automatic
        ];
        Download[protocol, {Object, ImageSample, MeasureWeight, MeasureVolume}]
      ],
      {ObjectP[Object[Protocol, RoboticCellPreparation]], False, False, False}
    ],
    Test["If Experiment is called on Sterile or Living samples with Preparation -> Manual, generate an Object[Protocol, ManualCellPreparation] and default all post processing options to False:",
      Module[
        {protocol},
        protocol = Experiment[
          {
            Incubate[
              Sample -> Object[Sample,"Test tissue culture sample in plate 1 (for Experiment tests)" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute,
              Preparation -> Manual
            ]
          },
          ImageSample -> Automatic,
          MeasureWeight -> Automatic,
          MeasureVolume -> Automatic
        ];
        Download[protocol, {Object, ImageSample, MeasureWeight, MeasureVolume}]
      ],
      {ObjectP[Object[Protocol, ManualCellPreparation]], False, False, False}
    ],
    Test["If Experiment is called on non-Sterile and non-Living samples with Preparation -> Robotic, generate an Object[Protocol, RoboticSamplePreparation] and default all post processing options to True:",
      Module[
        {protocol},
        protocol = Experiment[
          {
            Incubate[
              Sample -> Object[Sample,"Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute,
              Preparation -> Robotic
            ]
          },
          ImageSample -> Automatic,
          MeasureWeight -> Automatic,
          MeasureVolume -> Automatic
        ];
        Download[protocol, {Object, ImageSample, MeasureWeight, MeasureVolume}]
      ],
      {ObjectP[Object[Protocol, RoboticSamplePreparation]], True, True, True}
    ],
    Test["If Experiment is called on non-Sterile and non-Living samples with Preparation -> Manual, generate an Object[Protocol, ManualSamplePreparation] and default all post processing options to False:",
      Module[
        {protocol},
        protocol = Experiment[
          {
            Incubate[
              Sample -> Object[Sample,"Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute,
              Preparation -> Manual
            ]
          },
          ImageSample -> Automatic,
          MeasureWeight -> Automatic,
          MeasureVolume -> Automatic
        ];
        Download[protocol, {Object, ImageSample, MeasureWeight, MeasureVolume}]
      ],
      {ObjectP[Object[Protocol, ManualSamplePreparation]], True, True, True}
    ],
    Example[{Additional, IgnoreWarnings,"Generate a script based on a mixture of manual and liquid handler unit operation and passes down IgnoreWarnings key:"},
      Block[{ECL`ExperimentScript},
        Download[Experiment[{
          ManualSamplePreparation[
            Incubate[
              Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
              SampleLabel -> "best sample ever",
              Time -> 5 Minute
            ]
          ],
          RoboticSamplePreparation[
            Incubate[
              Sample -> Object[Container,Plate,"Test 96 DWP for Experiment" <> $SessionUUID],
              Time -> 5 Minute
            ]
          ]
        },
          IgnoreWarnings->True
        ], IgnoreWarnings]
      ],
      True
    ],

    (* -- Individual Primitive Tests -- *)
    Test["Simple centrifuge unit operation:",
      Experiment[
        {
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->"my container",
            Amount->10 Milliliter
          ],
          Centrifuge[
            Sample ->"my container",
            Time -> 5 Minute,
            Intensity -> 3000 RPM
          ]
        },
        Output->{Options, Input}
      ],
      {
        {_Rule..},
        {(_RoboticSamplePreparation|_ManualSamplePreparation|_ManualCellPreparation|_RoboticCellPreparation)..}
      }
    ],
    Test["Simple flow cytometry unit operation:",
      Experiment[
        {
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->"my container",
            Amount->10 Milliliter
          ],
          FlowCytometry[
            Sample -> "my container"
          ]
        },
        Output->{Options, Input}
      ],
      {
        {_Rule..},
        {(_RoboticSamplePreparation|_ManualSamplePreparation|_ManualCellPreparation|_RoboticCellPreparation)..}
      }
    ],
    Test["Simple PCR unit operation:",
      Experiment[
        {
          LabelContainer[
            Label->"my container",
            Container->Model[Container, Vessel, "50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Destination->"my container",
            Amount->10 Milliliter
          ],
          PCR[
            Sample->"my container"
          ]
        }
      ],
      ObjectP[Object[Protocol]]
    ],
    Test["Test the input resolution of a simple ImageCells unit operation:",
      Experiment[
        {
          ImageCells[
            Sample->Object[Sample,"Test tissue culture sample in plate 1 (for Experiment tests)" <> $SessionUUID]
          ]
        },
        Output->{Options,Input}
      ],
      {
        {_Rule..},
        {_ManualCellPreparation}
      }
    ],
    Test["Generate a script consisting of a mix of manual sample prep and manual cell prep:",
      Experiment[{
        ManualCellPreparation[
          ImageCells[Sample -> Object[Sample, "Test tissue culture sample in plate 1 (for Experiment tests)"<>$SessionUUID]]
        ],
        ManualSamplePreparation[
          Incubate[Sample -> Object[Sample, "Test water sample 1 in 50mL Tube for Experiment"<>$SessionUUID], SampleLabel -> "best sample ever", Time -> 5 Minute]
        ]
      }],
      ObjectP[Object[Notebook, Script]],
      Messages:>{Warning::CellPreparationFunctionRecommended}
    ],
    Test["Transfer a sample into a volumetric flask, and then fill that sample to a volume:",
      Experiment[{
        LabelSample[
          Label->"my sample",
          Sample->Model[Sample, "Sodium Chloride"],
          Container->Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source->"my sample",
          Destination->Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
          Amount->300 Milligram,
          DestinationLabel -> "my sample in volumetric flask"
        ],
        FillToVolume[
          Sample->"my sample in volumetric flask",
          TotalVolume -> 100 Milliliter,
          Solvent -> Model[Sample, "Milli-Q water"]
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]],
      TimeConstraint -> 10000
    ]
  },
  SymbolSetUp:>{
    ClearMemoization[];
    $CreatedObjects={};

    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ExpiredSamples];
    Off[Warning::SampleMustBeMoved];

    Module[{allObjects,existsFilter,mammalianModel,tube1,tube2,tube3,tube4,tube5,plate6,plate7,
      sample1,sample2,sample3,sample4,sample5,sample6,sample7},
      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects={
        Object[Container,Vessel,"Test 50mL Tube 1 for Experiment" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 2 for Experiment" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 3 for Experiment" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 4 for Experiment" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 5 for Experiment" <> $SessionUUID],
        Object[Container,Plate,"Test 96 DWP for Experiment" <> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 1 (for Experiment tests)" <> $SessionUUID],
        Object[Sample,"Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID],
        Object[Sample,"Test water sample 2 in 50mL Tube for Experiment" <> $SessionUUID],
        Object[Sample,"Test water sample 3 in 50mL Tube for Experiment" <> $SessionUUID],
        Object[Sample,"Test water sample 4 in 50mL Tube for Experiment" <> $SessionUUID],
        Object[Sample,"Test powder sample 5 in 50mL Tube for Experiment" <> $SessionUUID],
        Object[Sample,"Test water sample 6 in 96 DWP for Experiment" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample in plate 1 (for Experiment tests)" <> $SessionUUID],
        Model[Sample,"Mammalian cells Model (for Experiment tests)" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter=DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ]];

      (* Create some empty containers. *)
      {tube1,tube2,tube3,tube4,tube5,plate6,plate7}=Upload[{
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 1 for Experiment" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 2 for Experiment" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 3 for Experiment" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 4 for Experiment" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 5 for Experiment" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
          Name->"Test 96 DWP for Experiment" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well Greiner Tissue Culture Plate"],Objects],
          Name->"Test mammalian plate 1 (for Experiment tests)" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>
      }];

      (* Create mammalian model *)
      mammalianModel=UploadSampleModel["Mammalian cells Model (for Experiment tests)" <> $SessionUUID,
        Composition->{{95 VolumePercent,Model[Molecule,"Water"]},{5 VolumePercent,Model[Cell,Mammalian,"HeLa"]}},
        Expires->False,
        DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"],
        State->Liquid,
        BiosafetyLevel->"BSL-1",
        Flammable->False,
        MSDSFile -> NotApplicable,
        IncompatibleMaterials->{None},
        CellType->Mammalian,
        CultureAdhesion->Adherent,
        Living->True
      ];

      (* Create some samples for testing purposes *)
      {sample1,sample2,sample3,sample4,sample5,sample6,sample7}=UploadSample[
        (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
        {
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"id:vXl9j5qEn66B"],(* "Sodium carbonate, anhydrous" *)
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Mammalian cells Model (for Experiment tests)" <> $SessionUUID]
        },
        {
          {"A1",tube1},
          {"A1",tube2},
          {"A1",tube3},
          {"A1",tube4},
          {"A1",tube5},
          {"A1",plate6},
          {"A1",plate7}
        },
        Name->{
          "Test water sample 1 in 50mL Tube for Experiment" <> $SessionUUID,
          "Test water sample 2 in 50mL Tube for Experiment" <> $SessionUUID,
          "Test water sample 3 in 50mL Tube for Experiment" <> $SessionUUID,
          "Test water sample 4 in 50mL Tube for Experiment" <> $SessionUUID,
          "Test powder sample 5 in 50mL Tube for Experiment" <> $SessionUUID,
          "Test water sample 6 in 96 DWP for Experiment" <> $SessionUUID,
          "Test tissue culture sample in plate 1 (for Experiment tests)" <> $SessionUUID
        },
        InitialAmount->{
          25 Milliliter,
          10 Milliliter,
          10 Milliliter,
          10 Milliliter,
          10 Gram,
          1 Milliliter,
          100 Microliter
        },
        SampleHandling->{
          Liquid,
          Liquid,
          Liquid,
          Liquid,
          Powder,
          Liquid,
          Liquid
        }
      ];

      (* Make some changes to our samples for testing purposes *)
      Upload[{
        <|Object->sample1,Status->Available,DeveloperObject->True|>,
        <|Object->sample2,Status->Available,DeveloperObject->True|>,
        <|Object->sample3,Status->Available,DeveloperObject->True|>,
        <|Object->sample4,Status->Available,DeveloperObject->True|>,
        <|Object->sample5,Status->Available,DeveloperObject->True|>,
        <|Object->sample6,Status->Available,DeveloperObject->True|>,
        <|Object->sample7,Status->Available,DeveloperObject->True,CellType->Mammalian,CultureAdhesion->Adherent|>
      }];
    ]
  },
  SymbolTearDown:>{
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ExpiredSamples];
    On[Warning::SampleMustBeMoved];
    EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects]],Force->True,Verbose->False];
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];

(* ::Subsection:: *)
(*ExperimentRoboticSamplePreparation*)

DefineTests[
  ExperimentRoboticSamplePreparation,
  {
    Example[{Options, UnitOperationPackets, "If UnitOperationPackets is True, then don't return a protocol object; just return the OutputUnitOperation packets:"},
      ExperimentRoboticSamplePreparation[
        {
          LabelContainer[
            Label->"container",
            Container->Model[Container,Vessel,"50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"container",
            Amount->3 Milliliter
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"container",
            Amount->10 Milliliter
          ],
          Incubate[
            Sample->"container",
            Time->5 Minute
          ]
        },
        UnitOperationPackets -> True
      ],
      {{PacketP[Object[UnitOperation]]..}, TimeP}
    ],
    Example[{Options, UnitOperationPackets, "If UnitOperationPackets is True, don't run fulfillableResourceQ at all:"},
      ExperimentRoboticSamplePreparation[
        {
          LabelContainer[
            Label->"container",
            Container->Model[Container,Vessel,"50mL Tube"]
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"container",
            Amount->3 Milliliter
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"container",
            Amount->10 Milliliter
          ],
          Incubate[
            Sample->"container",
            Time->5 Minute
          ]
        },
        UnitOperationPackets -> True
      ],
      {{PacketP[Object[UnitOperation]]..}, TimeP},
      (* the intent here is that stubbing this to False doesn't matter because we're not calling it anyway *)
      Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
    ],
    Test["Postprocessing options from the ExperimentRoboticSamplePreparation call automatically resolve to False if a Sterile sample is present in the protocol:",
      protocol=ExperimentRoboticSamplePreparation[
        {
          Incubate[
            Sample -> Object[Sample,"Test water sample 10 (Sterile) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Time -> 5 Minute
          ]
        },
        ImageSample -> Automatic,
        MeasureVolume -> Automatic,
        MeasureWeight -> Automatic
      ];
      Download[
        protocol,
        {ImageSample, MeasureVolume, MeasureWeight}
      ],
      {False, False, False},
      Variables:>{protocol}
    ],

    (* -- Message Tests -- *)
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentRoboticSamplePreparation[{Incubate[Sample->Object[Sample, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentRoboticSamplePreparation[{Incubate[Sample->Object[Container, Vessel, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentRoboticSamplePreparation[{Incubate[Sample->Object[Sample, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentRoboticSamplePreparation[{Incubate[Sample->Object[Container, Vessel, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentRoboticSamplePreparation[{Incubate[Sample->sampleID]}, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentRoboticSamplePreparation[{Incubate[Sample->containerID]}, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[
      {Messages, "InvalidUnitOperationMethods", "If given a unit operation method (wrapper head) that isn't supported, throw an error:"},
      ExperimentRoboticSamplePreparation[{Test[Incubate[Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID]]]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationMethods,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationOptions", "Throws a message if there are invalid options inside of the given unit operations:"},
      ExperimentRoboticSamplePreparation[{
        ManualSamplePreparation[
          Incubate[
            Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Time->5 Minute
          ],
          Incubate[
            Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Taco->"Yum!"
          ]
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationHeads", "If given a unit operation type isn't allowed, throw an error:"},
      ExperimentRoboticSamplePreparation[{Test[<||>]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationHeads,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationRequiredOptions", "If a unit operation doesn't have its required options filled out, throw an error:"},
      ExperimentRoboticSamplePreparation[{Incubate[]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationOptions", "If given a unit operation with an invalid option, throw an error:"},
      ExperimentRoboticSamplePreparation[{
        Incubate[
          Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
          Taco->"Yum!"
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationValues", "If given a unit operation with an invalid option value, throw an error:"},
      ExperimentRoboticSamplePreparation[{
        Incubate[
          Sample->100
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationValues,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationRequiredOptions", "If given a unit operation with a missing required option, throw an error::"},
      ExperimentRoboticSamplePreparation[{
        Incubate[
          Time->5 Minute
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "UncoverUnitOperationAdded", "If a plate is covered in earlier unit operation but required in a later transfer, automatically add an Uncover unit operation:"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], DestinationWell -> "A1", DestinationLabel -> "water 1", Amount -> 100 Microliter],
          Cover[Sample -> "water 1"],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "water 1", Amount -> 100 Microliter]
        }];
        Download[protocol,OutputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation,Transfer]],
        ObjectP[Object[UnitOperation,Cover]],
        ObjectP[Object[UnitOperation,Uncover]],
        ObjectP[Object[UnitOperation,Transfer]],
        ObjectP[Object[UnitOperation,Cover]]
      },
      Messages:>{
        Warning::UncoverUnitOperationAdded
      },
      SetUp :> (ClearMemoization[]),
      TearDown :> (ClearMemoization[])
    ],
    Example[
      {Messages, "UncoverUnitOperationAdded", "If a plate is covered in earlier unit operation but required in a later pipet mixing, automatically add an Uncover unit operation:"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], DestinationWell -> "A1", DestinationLabel -> "water 1", Amount -> 100 Microliter],
          Cover[Sample -> "water 1"],
          Mix[Sample -> "water 1"]
        }];
        Download[protocol,OutputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation,Transfer]],
        ObjectP[Object[UnitOperation,Cover]],
        ObjectP[Object[UnitOperation,Uncover]],
        ObjectP[Object[UnitOperation,Mix]],
        ObjectP[Object[UnitOperation,Cover]]
      },
      Messages:>{
        Warning::UncoverUnitOperationAdded
      },
      SetUp :> (ClearMemoization[]),
      TearDown :> (ClearMemoization[])
    ],
    Example[
      {Messages, "UncoverUnitOperationAdded", "If a plate is covered in earlier unit operation but required in a later shaking, there is no need to uncover (1):"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], DestinationWell -> "A1", DestinationLabel -> "water 1", Amount -> 100 Microliter],
          Cover[Sample -> "water 1"],
          Mix[Sample -> "water 1", MixType -> Shake]
        }];
        Download[protocol,OutputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation,Transfer]],
        ObjectP[Object[UnitOperation,Cover]],
        ObjectP[Object[UnitOperation,Mix]]
      },
      SetUp :> (ClearMemoization[]),
      TearDown :> (ClearMemoization[])
    ],
    Example[
      {Messages, "UncoverUnitOperationAdded", "If a plate is covered in earlier unit operation but required in a later shaking, there is no need to uncover (2):"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], DestinationWell -> "A1", DestinationLabel -> "water 1", Amount -> 100 Microliter],
          Cover[Sample -> "water 1"],
          Mix[Sample -> "water 1", MixRate -> 500RPM]
        }];
        Download[protocol,OutputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation,Transfer]],
        ObjectP[Object[UnitOperation,Cover]],
        ObjectP[Object[UnitOperation,Mix]]
      },
      SetUp :> (ClearMemoization[]),
      TearDown :> (ClearMemoization[])
    ],
    Example[
      {Messages, "UncoverUnitOperationAdded", "No need to add Uncover unit operation if the plate is only covered before the protocol (not inside the protocol) since we have Uncover steps when loading the liquid handler deck:"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Object[Container,Plate,"Test 96 DWP 4 for ExperimentRoboticSamplePreparation"<>$SessionUUID], DestinationWell -> "A1", DestinationLabel -> "water 1", Amount -> 100 Microliter]
        }];
        Download[protocol,OutputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation,Transfer]]
      }
    ],
    Example[
      {Messages, "WorkCellIsIncompatibleWithMethod", "WorkCell types bioSTAR and microbioSTAR are only compatible with ExperimentRoboticCellPreparation and STAR is only compatible with ExperimentRoboticSamplePreparation:"},
      ExperimentRoboticSamplePreparation[{
        Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Vessel, "2mL Tube"], Amount -> 100 Microliter]},
        Instrument -> Object[Instrument, LiquidHandler, "Johnny Five"]
      ],
      $Failed,
      Messages :> {
        Error::WorkCellIsIncompatibleWithMethod,
        Error::NoWorkCellsPossibleForUnitOperation,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "ContainerLidIncompatible", "Give an error if a plate is too large to be covered with a lid:"},
      ExperimentRoboticSamplePreparation[
        {
          LabelContainer[Label->"my plate",Container->Model[Container,Plate,"Test large plate model for ExperimentRoboticSamplePreparation lidding"<>$SessionUUID]],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "my plate", Amount -> 1 Milliliter],
          Cover[Sample->"my plate"]
        }
      ],
      $Failed,
      Messages :> {
        Error::ContainerLidIncompatible,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "RoboticCellPreparationRequired", "If ExperimentRoboticSamplePreparation is called on a Living or Sterile sample, an error is thrown:"},
      ExperimentRoboticSamplePreparation[
        {
          Incubate[
            Sample -> Object[Sample,"Test water sample 11 (Living) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Time -> 5 Minute
          ]
        }
      ],
      $Failed,
      Messages:>{
        Error::RoboticCellPreparationRequired,
        Error::WorkCellIsIncompatibleWithMethod,
        Error::InvalidInput
      }
    ],

    (* -- Basic Tests -- *)
    Test["Transferring a large amount of water will automatically use a reservoir and MultiProbeHead:",
      Module[{testFunction,firstAttempt,protocol},
        testFunction[] := ExperimentRoboticSamplePreparation[{
          LabelSample[
            Sample->Model[Sample, "Milli-Q water"],
            Label->"my water"
          ],

          Transfer[
            Source->"my water",
            Destination->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
            Amount->150 Milliliter
          ]
        }];
        (* doing this goofy retry logic because this test is susceptible to these transient errors *)
        firstAttempt = Quiet[Check[
          testFunction[],
          $Failed,
          {Download::TransientNetworkError, Download::InternalError, LinkObject::linkd}
        ]];
        protocol = If[FailureQ[firstAttempt],
          testFunction[],
          firstAttempt
        ];

        {
          Download[protocol, OutputUnitOperations[[1]][ContainerLink]],
          Download[protocol, OutputUnitOperations[[2]][DeviceChannel]]
        }
      ],
      {
        {ObjectP[Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"]]},
        _?(MemberQ[#, MultiProbeHead]&)
      }
    ],
    Test["Specify any IncompatibleMaterials for a sample using a LabelSample primitive in an ExperimentRoboticSamplePreparation call:",
      protocol = ExperimentRoboticSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample,"Milli-Q water"],
            Destination -> Model[Container,Vessel,"2mL Tube"],
            Amount -> 0.5 Milliliter
          ],
          LabelSample[
            Sample -> "transfer destination sample 1",
            ShelfLife -> 1 Week,
            IncompatibleMaterials -> {Glass}
          ]
        }
      ];
      Download[protocol, {Object, OutputUnitOperations[[2]][IncompatibleMaterials]}],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        {{Glass}}
      },
      Variables:>{protocol}
    ],
    Test["Specify multiple IncompatibleMaterials for the same sample using a LabelSample primitive in an ExperimentRoboticSamplePreparation call:",
      protocol = ExperimentRoboticSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample,"Milli-Q water"],
            Destination -> Model[Container,Vessel,"2mL Tube"],
            Amount -> 0.5 Milliliter
          ],
          LabelSample[
            Sample -> "transfer destination sample 1",
            ShelfLife -> 1 Week,
            IncompatibleMaterials -> {Glass, BorosilicateGlass}
          ]
        }
      ];
      Download[protocol, {Object, OutputUnitOperations[[2]][IncompatibleMaterials]}],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        {{Glass, BorosilicateGlass}}
      },
      Variables:>{protocol}
    ],
    Test["Generate a liquid handling protocol object based on a single robotic unit operation:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Incubate[
            Sample -> Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            SampleLabel -> "best sample ever",
            Time -> 5 Minute
          ]
        }];

        Download[protocol, {Object, RequiredTips, LabeledObjects, RequiredInstruments}]
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        {},
        {{_String, LinkP[]}..},
        {LinkP[Model[Instrument, HeatBlock]]}
      }
    ],
    Test["Test setting the AspirationPositionOffset option to a coordinate:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 970 Microliter,
            AspirationPosition -> {Top, Top, Top},
            AspirationPositionOffset -> Coordinate[{10 Millimeter, 10 Millimeter, 10 Millimeter}]
          ]
        }];

        protocol[OutputUnitOperations][AspirationPositionOffset]
      ],
      {
        {
          Coordinate[{Quantity[10, "Millimeters"], Quantity[10, "Millimeters"], Quantity[10, "Millimeters"]}],
          Coordinate[{Quantity[10, "Millimeters"], Quantity[10, "Millimeters"], Quantity[10, "Millimeters"]}],
          Coordinate[{Quantity[10, "Millimeters"], Quantity[10, "Millimeters"], Quantity[10, "Millimeters"]}]
        }
      }
    ],
    Test["Test setting the DispensePositionOffset option to a coordinate:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 970 Microliter,
            DispensePosition -> {Top, Top, Top},
            DispensePositionOffset -> Coordinate[{10 Millimeter, 10 Millimeter, 10 Millimeter}]
          ]
        }];

        protocol[OutputUnitOperations][DispensePositionOffset]
      ],
      {
        {
          Coordinate[{Quantity[10, "Millimeters"], Quantity[10, "Millimeters"], Quantity[10, "Millimeters"]}],
          Coordinate[{Quantity[10, "Millimeters"], Quantity[10, "Millimeters"], Quantity[10, "Millimeters"]}],
          Coordinate[{Quantity[10, "Millimeters"], Quantity[10, "Millimeters"], Quantity[10, "Millimeters"]}]
        }
      }
    ],
    Test["Automatically detects that two plate stamps should be done to fill up the DWP (the max volume of a single pipetting is 970uL so the 1mL transfer is split into two):",
      Module[{testFunction, resolvedUnitOperations1, resolvedUnitOperations2},
        testFunction[]:=ExperimentRoboticSamplePreparationInputs[
          {
            Transfer[
              Source->Model[Sample,"Milli-Q water"],
              Destination->Model[Container,Vessel,"50mL Tube"],
              Amount->15Milliliter
            ],
            Transfer[
              Source->ConstantArray[Model[Sample,"Milli-Q water"],96],
              Destination->ConstantArray[{1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]},96],
              Amount->ConstantArray[1Milliliter,96],
              DestinationWell->Flatten[AllWells[]]
            ],
            Transfer[
              Source->Model[Sample,"Milli-Q water"],
              Destination->Model[Container,Vessel,"50mL Tube"],
              Amount->15Milliliter
            ]
          }
        ];
        (* doing this goofy retry logic because this test for whatever reason loves a transient network error *)
        resolvedUnitOperations1=Quiet[Check[
          testFunction[],
          $Failed,
          {Download::TransientNetworkError}
        ]];
        resolvedUnitOperations2 = If[FailureQ[resolvedUnitOperations1],
          testFunction[],
          resolvedUnitOperations1
        ];

        resolvedUnitOperations2[[1]][DeviceChannel]
      ],
      {
        SingleProbe1,SingleProbe2,SingleProbe3,SingleProbe4,SingleProbe5,SingleProbe6,SingleProbe7,SingleProbe8,SingleProbe1,SingleProbe2,SingleProbe3,SingleProbe4,SingleProbe5,SingleProbe6,SingleProbe7,SingleProbe8,

        MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,MultiProbeHead,

        SingleProbe1,SingleProbe2,SingleProbe3,SingleProbe4,SingleProbe5,SingleProbe6,SingleProbe7,SingleProbe8,SingleProbe1,SingleProbe2,SingleProbe3,SingleProbe4,SingleProbe5,SingleProbe6,SingleProbe7,SingleProbe8
      },
      TimeConstraint -> 600
    ],
    Test["Generate a robotic sample preparation protocol based on a transfer unit operation and then incubate the input as {Position,Container}:",
      ExperimentRoboticSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
            Amount -> 500 Microliter,
            DestinationContainerLabel -> "my contaienr 1"],
          Incubate[
            Sample -> {"A1", "my contaienr 1"},
            Time -> 5 Minute
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticSamplePreparation]]
    ],
    Test["Catch empty wells when specify a sample by {Position, Container}:",
      ExperimentRoboticSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
            Amount -> 500 Microliter,
            DestinationContainerLabel -> "my contaienr 1"],
          Incubate[
            Sample -> {"A2", "my contaienr 1"},
            Time -> 5 Minute
          ]
        }
      ],
      $Failed,
      Messages:{Error::ContainerEmptyWells}
    ],
    Test["Catch non existing wells when specify a sample by {Position, Container}:",
      ExperimentRoboticSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
            Amount -> 500 Microliter,
            DestinationContainerLabel -> "my contaienr 1"],
          Incubate[
            Sample -> {"Z1", "my contaienr 1"},
            Time -> 5 Minute
          ]
        }
      ],
      $Failed,
      Messages:{Error::WellDoesNotExist}
    ],
    Test["Generate a liquid handling protocol by specifying {Position,Container}:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Mix[
            Sample -> {"A1",Object[Container, Plate, "Test 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            SampleLabel -> "best sample ever",
            Time -> 5 Minute,
            MixType -> Shake
          ]
        }];

        Download[protocol, {Object, RequiredTips, LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        {},
        {{_String, LinkP[]}..}
      }
    ],
    Test["Generate a liquid handling protocol object based on a single mix unit operation:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Mix[
            Sample -> Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            SampleLabel -> "best sample ever",
            Time -> 5 Minute,
            MixType -> Shake
          ]
        }];

        Download[protocol, {Object, RequiredTips, LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        {},
        {{_String, LinkP[]}..}
      }
    ],
    Test["Generate a liquid handling protocol object based on a single Centrifuge unit operation:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Centrifuge[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Time -> 5 Minute,
            Intensity -> 3000 RPM
          ]
        }];

        Download[protocol, {Object, TipPlacements, LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        {},
        {{_String, LinkP[]}..}
      }
    ],
    Test["Generate a liquid handling protocol object based on a single Centrifuge unit operation with a plate that doesnt have counterweights:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Centrifuge[
            Sample -> {Object[Container,Plate, "Test 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID]},
            Time -> 5 Minute,
            Intensity -> 3000 RPM
          ]
        }];

        Download[protocol, {Object, TipPlacements, LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        {},
        {{_String, LinkP[]}..}
      },
      Stubs:>{$DeveloperSearch=False,
        Experiment`Private`allCentrifugableContainersSearch["Memoization"]:=
            {Model[Container, Vessel, "id:01G6nvkKrrb1"], Model[Container, Vessel,
              "id:eGakld01zzpq"], Model[Container, Plate, "id:L8kPEjkmLbvW"],
              Model[Container, Plate, "id:n0k9mGzRaaBn"], Model[Container, Vessel,
              "id:eGakld01zzBq"], Model[Container, Plate, "id:Vrbp1jG800ME"],
              Model[Container, Plate, "id:E8zoYveRllM7"], Model[Container, Vessel,
              "id:rea9jl1orrMp"], Model[Container, Vessel, "id:bq9LA0dBGGrd"],
              Download[Object[Container,Plate, "Test 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID][Model][Object],Object]}
      },
      TearDown :> (ClearMemoization[])
    ],
    Test["Choosing to spin too fast for the VSpin causes the HiG to be chosen and then we get an error about being unable to choose the bioSTAR with RSP:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Centrifuge[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Time -> 5 Minute,
            Intensity -> 3000 GravitationalAcceleration
          ]
        }];

        Download[protocol, {Object, TipPlacements, LabeledObjects}]
      ],
      {$Failed, $Failed, $Failed},
      Messages :> {
        Error::WorkCellIsIncompatibleWithMethod,
        Error::NoCompatibleCentrifuge,
        Error::InvalidInput
      }
    ],
    Test["Choosing to spin too slow for the HiG causes VSpin to be chosen and then we get an error about being unable to choose the STAR with RCP:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[{
          Centrifuge[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Time -> 5 Minute,
            Intensity -> 200 GravitationalAcceleration
          ]
        }];

        Download[protocol, {Object, TipPlacements, LabeledObjects}]
      ],
      {$Failed, $Failed, $Failed},
      Messages :> {
        Error::WorkCellIsIncompatibleWithMethod,
        Error::NoCompatibleCentrifuge,
        Error::InvalidInput
      }
    ],
    Test["Centrifugal Filter works in RCP:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[{
          Filter[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Volume -> 300 Microliter,
            FiltrationType->Centrifuge,
            Intensity->500 GravitationalAcceleration,
            Time-> 5 Minute
          ]
        }];

        Download[protocol, {Object, TipPlacements, LabeledObjects}]
      ],
      {ObjectP[Object[Protocol,RoboticCellPreparation]],_,_}
    ],
    Test["Centrifugal Filter works in RSP:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Filter[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Volume -> 300 Microliter,
            FiltrationType->Centrifuge,
            Intensity->500 GravitationalAcceleration,
            Time-> 5 Minute
          ]
        }];

        Download[protocol, {Object, TipPlacements, LabeledObjects}]
      ],
      {ObjectP[Object[Protocol,RoboticSamplePreparation]],_,_}
    ],

    Test["Generate a liquid handling protocol object based on a single mix unit operation with multiple samples (multichannel mixing):",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Mix[
            Sample -> {
              Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
              Object[Sample,"Test water sample 2 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
              Object[Sample,"Test water sample 3 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
              Object[Sample,"Test water sample 4 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
              Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]
            },
            MixType -> Pipette
          ]
        }];

        Download[protocol, {Object, RequiredTips, LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol, RoboticSamplePreparation]],
        {LinkP[Model[Item, Tips]]..},
        {{_String, LinkP[]}..}
      }
    ],

    (* -- Plate reader tests -- *)
    Test["Generate a liquid handling protocol object based on a single AbsorbanceSpectroscopy unit operation:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          AbsorbanceSpectroscopy[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Preparation -> Robotic
          ]
        }];

        Download[protocol,{Object,LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol,RoboticSamplePreparation]],
        {{_String,LinkP[]}..}
      }
    ],
    Test["Generate a liquid handling protocol object based on a single FluorescenceIntensity unit operation:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          FluorescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Preparation -> Robotic
          ]
        }];

        Download[protocol,{Object,LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol,RoboticSamplePreparation]],
        {{_String,LinkP[]}..}
      }
    ],
    Test["Generate a liquid handling protocol object based on a single Nephelometry unit operation:",
      Module[{protocol},
        protocol=ExperimentRoboticCellPreparation[{
          Nephelometry[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Preparation -> Robotic
          ]
        }];

        Download[protocol,{Object,LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol,RoboticCellPreparation]],
        {{_String,LinkP[]}..}
      },
      Messages:>{
        Warning::AmbiguousAnalyte,
        Warning::InsufficientVolume
      }
    ],
    Test["Generate a liquid handling protocol object based on a single AlphaScreen unit operation:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          AbsorbanceSpectroscopy[
            Sample->Object[Sample,"Test AlphaScreen sample 8 in AlphaPlate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Preparation -> Robotic
          ]
        }];

        Download[protocol,{Object,LabeledObjects}]
      ],
      {
        ObjectP[Object[Protocol,RoboticSamplePreparation]],
        {{_String,LinkP[]}..}
      }
    ],

    Test["Resolve the options/inputs for a basic liquid handling protocol:",
      ExperimentRoboticSamplePreparation[
        {
          Incubate[
            Sample -> Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            SampleLabel -> "best sample ever",
            Time -> 5 Minute
          ]
        },
        Output->{Options,Input}
      ],
      {
        {_Rule..},
        {RoboticSamplePreparationP..}
      }
    ],
    Test["Robotic Transfer while restricting the source or destination should not throw an error:" ,
      ExperimentRoboticSamplePreparation[
        {
          Transfer[
            Source -> Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Destination -> Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            Amount -> 0.5 Milliliter,
            RestrictSource -> True,
            RestrictDestination -> True
          ]
        },
        Output->{Options,Input}
      ],
      {
        {_Rule..},
        {_Transfer, ___}
      },
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
        UnrestrictSamples[{Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentRoboticSamplePreparation" <> $SessionUUID]}];
      )
    ],
    Test["Enqueue a sequence of transfer, mix and centrifuge unit operations: " ,
      ExperimentRoboticSamplePreparation[{
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->PreferredContainer[1 Milliliter, Type->Plate],
          Amount->500 Microliter
        ],
        Mix[Time->5 Minute],
        Centrifuge[Time->5 Minute]
      }],
      ObjectP[Object[Protocol, RoboticSamplePreparation]],
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
        UnrestrictSamples[{Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentRoboticSamplePreparation" <> $SessionUUID]}];
      )
    ],
    Test["Robotic Transfer while restricting multiple sources or destinations should not throw an error if they are not conflicting:" ,
      ExperimentRoboticSamplePreparation[
        {
          Transfer[
            Source -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Destination -> {Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentRoboticSamplePreparation" <> $SessionUUID],Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Amount -> {0.5 Milliliter,0.5 Milliliter},
            RestrictSource -> {True,True},
            RestrictDestination -> {True,False}
          ]
        },
        Output->{Options,Input}
      ],
      {
        {_Rule..},
        {_Transfer, ___}
      },
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
        UnrestrictSamples[{Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
          Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentRoboticSamplePreparation" <> $SessionUUID]}];
      )
    ],
    Test["Request only one lid even if multiple samples of the same plate are provided as Cover input and the container is repeatedly covered:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelContainer[Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Label -> "myPlate"],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "myPlate", Amount -> 100 Microliter, DestinationWell -> {"A1", "A2"}, DestinationLabel -> {"water 1", "water 2"}],
          Cover[Sample -> {"water 1", "water 2"}],
          Uncover[Sample -> {"water 1", "water 2"}],
          Cover[Sample -> {"water 1", "water 2"}],
          Uncover[Sample -> {"water 1", "water 2"}],
          Cover[Sample -> {"water 1", "water 2"}],
          Uncover[Sample -> {"water 1", "water 2"}],
          Cover[Sample -> {"water 1", "water 2"}]
        }];

        Count[
          Download[
            Download[protocol, RequiredObjects],
            Object
          ],
          ObjectReferenceP[Model[Item, Lid]]
        ]
      ],
      1
    ],
    Test["Skip automatic covering of large plate because the lid is too tight fot the target plate:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[
          {
            LabelContainer[Label-> {"my plate 1","my plate 2"},Container->{Model[Container,Plate,"Test large plate model for ExperimentRoboticSamplePreparation lidding"<>$SessionUUID],Model[Container, Plate, "96-well PCR Plate"]}],
            Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> {"my plate 1","my plate 2"}, Amount -> 200 Microliter]
          }
        ];
        Download[protocol,OutputUnitOperations[[-1]][SampleLink]]
      ],
      {ObjectP[Model[Container, Plate]]}
    ],
    Example[{Additional,"Robotic test call with 1 plate reader unit operation with no injection samples results in the Object[Protocol, RoboticSamplePreparation] fields NOT being filled out except for PrimaryPlateReader:"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          FluorescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID]
          ]
        }];

        MatchQ[
          Download[
            Download[protocol, {PrimaryPlateReader, PrimaryPlateReaderInjectionSample, PrimaryPlateReaderSecondaryInjectionSample}],
            Object
          ],
          {ObjectP[], Null, Null}
        ]
      ],
      True
    ],
    Example[{Additional,"Robotic test call with 1 plate reader unit operation with 1 injection sample results in the Object[Protocol, RoboticSamplePreparation] fields being filled out:"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          FluorescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
            SecondaryInjectionVolume->10 Microliter
          ]
        }];

        And[
          (* Only using one injection sample here. *)
          MatchQ[
            Download[
              Download[protocol, {PrimaryPlateReaderInjectionSample, PrimaryPlateReaderSecondaryInjectionSample}],
              Object
            ],
            {Model[Sample, "id:8qZ1VWNmdLBD"], Null}
          ],
          (* Same resources should be requested since we're cleaning only one line. *)
          MatchQ[
            Length@DeleteDuplicates@Cases[
              Join[
                Download[
                  protocol,
                  RequiredResources
                ]
              ],
              {resource_, PrimaryPlateReaderLine1PrimaryPurgingSolvent | PrimaryPlateReaderLine1SecondaryPurgingSolvent | PrimaryPlateReaderLine2PrimaryPurgingSolvent | PrimaryPlateReaderLine2SecondaryPurgingSolvent, ___} :> Download[resource, Object]
            ],
            2
          ],
          (* Resources in OutputUnitOperation match the global injection resources in robotic protocol object. *)
          MatchQ[
            Sort@DeleteDuplicates@Cases[
              Join[
                Download[
                  protocol,
                  OutputUnitOperations[[1]][RequiredResources]
                ]
              ],
              {resource_, PrimaryInjectionSampleLink | SecondaryInjectionSampleLink | TertiaryInjectionSample | QuaternaryInjectionSample, ___} :> Download[resource, Object]
            ],
            Sort@Cases[
              Download[
                protocol,
                RequiredResources
              ],
              {resource_, PrimaryPlateReaderInjectionSample | PrimaryPlateReaderSecondaryInjectionSample, ___} :> Download[resource, Object]
            ]
          ]
        ]
      ],
      True
    ],
    Example[{Additional,"Robotic test call with 1 plate reader unit operation with 2 different injection samples results in the Object[Protocol, RoboticSamplePreparation] fields being filled out (with the same resources as the output unit operation):"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          FluorescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Methanol"],
            SecondaryInjectionVolume->10 Microliter
          ]
        }];

        And[
          (* Using 2 injection samples here. *)
          MatchQ[
            Download[
              Download[protocol, {PrimaryPlateReaderInjectionSample, PrimaryPlateReaderSecondaryInjectionSample}],
              Object
            ],
            {Model[Sample, "id:8qZ1VWNmdLBD"], Model[Sample, "id:vXl9j5qEnnRD"]}
          ],
          (* Different resources should be requested since we're cleaning two lines. *)
          MatchQ[
            Length@DeleteDuplicates@Cases[
              Join[
                Download[
                  protocol,
                  RequiredResources
                ]
              ],
              {resource_, PrimaryPlateReaderLine1PrimaryPurgingSolvent | PrimaryPlateReaderLine1SecondaryPurgingSolvent | PrimaryPlateReaderLine2PrimaryPurgingSolvent | PrimaryPlateReaderLine2SecondaryPurgingSolvent, ___} :> Download[resource, Object]
            ],
            4
          ],
          (* Resources in OutputUnitOperation match the global injection resources in robotic protocol object. *)
          MatchQ[
            Sort@DeleteDuplicates@Cases[
              Join[
                Download[
                  protocol,
                  OutputUnitOperations[[1]][RequiredResources]
                ]
              ],
              {resource_, PrimaryInjectionSampleLink | SecondaryInjectionSampleLink | TertiaryInjectionSample | QuaternaryInjectionSample, ___} :> Download[resource, Object]
            ],
            Sort@Cases[
              Download[
                protocol,
                RequiredResources
              ],
              {resource_, PrimaryPlateReaderInjectionSample | PrimaryPlateReaderSecondaryInjectionSample, ___} :> Download[resource, Object]
            ]
          ]
        ]
      ],
      True
    ],
    Example[{Additional,"Robotic test call with 2 plate reader unit operations with injection samples results in the Object[Protocol, RoboticSamplePreparation] fields being filled out (with the same resources as the output unit operation):"},
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          FluorescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Methanol"],
            SecondaryInjectionVolume->10 Microliter,
            Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
          ],
          AbsorbanceSpectroscopy[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Methanol"],
            SecondaryInjectionVolume->10 Microliter,
            Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
          ]
        }];

        And[
          (* Using two injection samples here. *)
          MatchQ[
            Download[
              Download[protocol, {PrimaryPlateReaderInjectionSample, PrimaryPlateReaderSecondaryInjectionSample}],
              Object
            ],
            {Model[Sample, "id:8qZ1VWNmdLBD"], Model[Sample, "id:vXl9j5qEnnRD"]}
          ],
          (* Resources in OutputUnitOperation match the global injection resources in robotic protocol object. *)
          MatchQ[
            Sort@DeleteDuplicates@Cases[
              Join[
                Download[
                  protocol,
                  OutputUnitOperations[[1]][RequiredResources]
                ],
                Download[
                  protocol,
                  OutputUnitOperations[[2]][RequiredResources]
                ]
              ],
              {resource_, PrimaryInjectionSampleLink | SecondaryInjectionSampleLink | TertiaryInjectionSample | QuaternaryInjectionSample, ___} :> Download[resource, Object]
            ],
            Sort@Cases[
              Download[
                protocol,
                RequiredResources
              ],
              {resource_, PrimaryPlateReaderInjectionSample | PrimaryPlateReaderSecondaryInjectionSample, ___} :> Download[resource, Object]
            ]
          ]
        ]
      ],
      True
    ],
    Example[{Additional,"Test Robotic Call with AbsorbanceSpectroscopy:"},
      ExperimentRoboticSamplePreparation[{
        AbsorbanceSpectroscopy[
          Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
          PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
          PrimaryInjectionVolume->10 Microliter,
          SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
          SecondaryInjectionVolume->10 Microliter
        ]
      }],
      ObjectP[Object[Protocol]]
    ],
    Example[{Additional,"Test Robotic Call with FluorescenceIntensity:"},
      ExperimentRoboticSamplePreparation[{
        FluorescenceIntensity[
          Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
          PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
          PrimaryInjectionVolume->10 Microliter,
          SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
          SecondaryInjectionVolume->10 Microliter
        ]
      }],
      ObjectP[Object[Protocol]]
    ],
    Example[{Additional,"Test Robotic Call with LuminescenceIntensity:"},
      ExperimentRoboticSamplePreparation[{
        LuminescenceIntensity[
          Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
          PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
          PrimaryInjectionVolume->10 Microliter,
          SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
          SecondaryInjectionVolume->10 Microliter
        ]
      }],
      ObjectP[Object[Protocol]]
    ],
    Example[{Additional,"Test Robotic Call with AlphaScreen:"},
      ExperimentRoboticSamplePreparation[{
        AlphaScreen[
          Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID]
        ]
      }],
      ObjectP[Object[Protocol]]
    ],
    Example[{Additional,"Test Robotic Call using two plate readers on the bioSTAR will result in both plate reader protocol fields being filled out (and LuminescenceIntensity will default to the clarioSTAR when on the bioSTAR):"},
      Download[
        ExperimentRoboticCellPreparation[{
          Nephelometry[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
            SecondaryInjectionVolume->10 Microliter
          ],
          LuminescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
            SecondaryInjectionVolume->10 Microliter
          ]
        }],
        {PrimaryPlateReader, SecondaryPlateReader}
      ],
      {
        ObjectP[Model[Instrument, Nephelometer]],
        ObjectP[Model[Instrument, PlateReader]]
      },
      Messages:>{
        Warning::AmbiguousAnalyte,
        Warning::InsufficientVolume
      }
    ],
    Example[{Additional,"A transfer that requires too many tips to be put on deck at the same time will throw an error (call Experiment instead with multiple RoboticSamplePreparation[...] groups):"},
      ExperimentRoboticSamplePreparation[{
        LabelSample[
          Label->"water reservoir 1",
          Sample->Model[Sample,"Milli-Q water"],
          Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"],
          Amount->100 Milliliter
        ],

        LabelContainer[
          Label->"empty container 1",
          Container->Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"]
        ],

        Transfer[
          Source->"water reservoir 1",
          Destination->"empty container 1",
          Amount->{
            30 Microliter,
            30 Microliter,
            30 Microliter,
            30 Microliter,
            30 Microliter,
            30 Microliter,
            30 Microliter,
            30 Microliter
          },
          Tips->{
            Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"],
            Model[Item, Tips, "300 uL Hamilton barrier tips, sterile"],
            Model[Item, Tips, "50 uL Hamilton barrier tips, sterile"],
            Model[Item, Tips, "300 uL Hamilton tips, non-sterile"],
            Model[Item, Tips, "50 uL Hamilton tips, non-sterile"],
            Model[Item, Tips, "300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
            Model[Item, Tips, "1000 uL Hamilton barrier tips, wide bore, 3.2mm orifice"],
            Model[Item, Tips, "1000 uL Hamilton tips, non-sterile"]
          }
        ]
      }],
      $Failed,
      Messages:>{
        Error::NoWorkCellsPossibleForUnitOperation,
        Error::NoWorkCellsPossibleForUnitOperation,
        Error::InvalidInput
      }
    ],
    Example[{Additional,"Test Robotic Call using four plate readers unit operations on the bioSTAR will result in both plate reader protocol fields being filled out (and AbsorbanceSpectroscopy will default to the clarioSTAR when on the bioSTAR):"},
      Download[
        ExperimentRoboticCellPreparation[{
          Nephelometry[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
            SecondaryInjectionVolume->10 Microliter
          ],
          AbsorbanceSpectroscopy[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
            SecondaryInjectionVolume->10 Microliter
          ],
          LuminescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
            SecondaryInjectionVolume->10 Microliter
          ],
          FluorescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
            SecondaryInjectionVolume->10 Microliter
          ],
          AlphaScreen[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID]
          ]
        }],
        {PrimaryPlateReader, SecondaryPlateReader}
      ],
      {
        ObjectP[Model[Instrument, Nephelometer]],
        ObjectP[Model[Instrument, PlateReader]]
      },
      Messages:>{
        Warning::AmbiguousAnalyte,
        Warning::InsufficientVolume,
        Warning::InsufficientVolume
      }
    ],
    Example[{Additional,"There are no additional instrument resources made in the OutputUnitOperations compared to the top level protocol object (since we only pick the liquid handler and integrations based on top level fields, which will result in the fields in the OutputUnitOperation getting fulfilled):"},
      Module[{protocol, outputUnitOperationInstrumentResources, topLevelInstrumentResources},
        protocol=ExperimentRoboticCellPreparation[{
          LuminescenceIntensity[
            Sample->Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
            PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
            PrimaryInjectionVolume->10 Microliter,
            SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
            SecondaryInjectionVolume->10 Microliter
          ]
        }];

        outputUnitOperationInstrumentResources=Cases[
          Download[
            protocol,
            OutputUnitOperations[RequiredResources]
          ],
          resource:ObjectP[Object[Resource, Instrument]]:>Download[resource, Object]
        ];

        topLevelInstrumentResources=Cases[
          Download[
            protocol,
            RequiredResources
          ],
          resource:ObjectP[Object[Resource, Instrument]]:>Download[resource, Object]
        ];

        ContainsAll[topLevelInstrumentResources, outputUnitOperationInstrumentResources]
      ],
      True
    ],
    Test["Creates a resource to pick the specific instrument requested:",
      Module[{protocol, instrumentResource},
        protocol = ExperimentRoboticSamplePreparation[
          {Transfer[
            Source->Model[Sample, "Milli-Q water"],
            Amount->0.5 Milliliter,
            Destination->Model[Container, Vessel, "2mL Tube"]
          ]},
          Instrument->Object[Instrument, LiquidHandler, "Jay Z"]
        ];
        instrumentResource = FirstCase[Download[protocol, RequiredResources[[All, 1]]], ObjectP[Object[Resource, Instrument]]];
        Download[instrumentResource, Instrument]
      ],
      ObjectP[Object[Instrument, LiquidHandler, "Jay Z"]]
    ],
    Test["When using Experiment, creates a resource to pick the specific instrument requested:",
      Module[{protocol, instrumentResource},
        protocol = Experiment[{
          RoboticSamplePreparation[
            Transfer[
              Source->Model[Sample, "Milli-Q water"],
              Amount->0.5 Milliliter,
              Destination->Model[Container, Vessel, "2mL Tube"]
            ],
            Transfer[
              Source->Model[Sample, "Milli-Q water"],
              Amount->0.5 Milliliter,
              Destination->Model[Container, Vessel, "2mL Tube"]
            ],
            Instrument->Object[Instrument, LiquidHandler, "Jay Z"]
          ]
        }];
        instrumentResource = FirstCase[Download[protocol, RequiredResources[[All, 1]]], ObjectP[Object[Resource, Instrument]]];
        Download[instrumentResource, Instrument]
      ],
      ObjectP[Object[Instrument, LiquidHandler, "Jay Z"]]
    ],
    Test["Provides a clean error when an unsuitable instrument is requested:",
      Experiment[
        {
          RoboticSamplePreparation[
            LabelContainer[
              Label->("container "<>ToString[#]&)/@Range[10],
              Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]
            ],
            Instrument->Object[Instrument, LiquidHandler, "Jay Z"]
          ]
        },
        CoverAtEnd->False
      ],
      $Failed,
      Messages:>{
        Error::NoWorkCellsPossibleForUnitOperation,
        Error::InvalidInput
      }
    ],
    Example[{Additional,"Generate a protocol based off a single MagneticBeadSeparation unit operation:"},
      ExperimentRoboticSamplePreparation[{
        MagneticBeadSeparation[
          Sample ->Object[Sample,"Test water sample 9 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
          PreWash->True,
          Equilibration->True,
          Wash->True
        ]
      }],
      ObjectP[Object[Protocol,RoboticSamplePreparation]],
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],
    Example[{Additional,"Generate a Protocol using MagneticBeadSeparation in a series of unit operations:"},
      ExperimentRoboticSamplePreparation[{
        LabelSample[
          Sample->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Label-> "my mbs sample"
        ],
        MagneticBeadSeparation[
          Sample ->"my mbs sample",
          PreWash->True,
          SampleOutLabel->{{{"my mbs sample out"}}},
          PreWashBufferVolume -> 300 Microliter,
          PreWashCollectionContainerLabel -> "pre wash collection plate",
          PreWashCollectionContainer -> {"B1", Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
          SelectionStrategy->Negative
        ],
        Transfer[
          Source -> "my mbs sample out",
          Destination -> Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
          Amount -> 100 Microliter
        ],
        Transfer[
          Source -> {"B1","pre wash collection plate"},
          Destination -> {"A1","pre wash collection plate"},
          Amount -> 300 Microliter
        ]
      }],
      ObjectP[Object[Protocol,RoboticSamplePreparation]],
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],
    Test["Generate a Protocol using MagneticBeadSeparation for multiple samples in a series of unit operations:",
      ExperimentRoboticSamplePreparation[{
        LabelSample[
          Sample->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Label-> {"my mbs sample 1","my mbs sample 2","my mbs sample 3"}
        ],
        MagneticBeadSeparation[
          Sample ->{"my mbs sample 1","my mbs sample 2","my mbs sample 3"},
          PreWash->True,
          SampleOutLabel->{"my mbs sample out 1","my mbs sample out 2","my mbs sample out 3"}
        ]
      }],
      ObjectP[Object[Protocol,RoboticSamplePreparation]],
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],
    Test["Generate a Protocol using MagneticBeadSeparation for a mixture of sample and container inputs:",
      ExperimentRoboticSamplePreparation[{
        LabelContainer[
          Label->{"my mbs container 1","my mbs container 2","my mbs container 3"},
          Container->Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Destination->{"my mbs container 1","my mbs container 2","my mbs container 3"},
          DestinationLabel-> {"my mbs sample 1","my mbs sample 2","my mbs sample 3"}
        ],
        MagneticBeadSeparation[
          Sample ->{"my mbs sample 1","my mbs container 2","my mbs sample 3"},
          PreWash->True,
          Volume->400Microliter
        ]
      }],
      ObjectP[Object[Protocol,RoboticSamplePreparation]],
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],
    Test["Throw an error if the user specified to use the a heavy magnetization rack (Model[Item,MagnetizationRack,\"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"]) in series with any Filter unit operation:",
      ExperimentRoboticSamplePreparation[{
        LabelSample[
          Sample->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Label-> "my mbs sample"
        ],
        MagneticBeadSeparation[
          Sample ->"my mbs sample",
          MagnetizationRack -> Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"],(*Model[Item, MagnetizationRack, "Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"]*)
          SampleOutLabel->"my mbs sample out"
        ],
        Filter[Sample -> "my mbs sample out"]
      }],
      $Failed,
      Messages:>{
        Warning::GeneralResolvedMagneticBeads,
        Error::ConflictingSpecifiedMagnetizationRackWithFilterUnitOperation,
        Error::ConflictingSpecifiedMagnetizationRackWithFilterUnitOperation,
        Error::InvalidInput
      },
      SetUp:>{Off[General::stop]},
      TearDown:>{On[General::stop]}
    ],
    Test["Default to use the light magnetization rack (Model[Item,MagnetizationRack,\"Alpaqua 96S Super Magnet 96-well Plate Rack\"]) if there is any magnetized Transfer used in series with any Filter unit operation:",
      Module[{protocol},
        protocol = ExperimentRoboticSamplePreparation[{
          LabelSample[
            Sample -> Model[Sample, "Milli-Q water"],
            Amount -> 200 Microliter,
            Label -> "my filter sample"
          ],
          Filter[
            Sample -> "my filter sample",
            SampleOutLabel -> "my filter sample out"
          ],
          MagneticBeadSeparation[Sample -> "my filter sample out"]
        }];
        Cases[
          Flatten[Quiet[Download[protocol,
            {OutputUnitOperations[MagnetizationRack], RequiredObjects}]]],
          ObjectP[Model[Item, MagnetizationRack]]
        ]
      ],
      {ObjectP[Model[Item, MagnetizationRack, "id:aXRlGn6O3vqO"]]..},(* "Alpaqua 96S Super Magnet 96-well Plate Rack" *)
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],
    Test["Centrifugal Filter throws an error if you try to put a too tall stack in the VSpin:",
      Module[{protocol},
        protocol=ExperimentRoboticSamplePreparation[{
          Filter[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            FiltrationType->Centrifuge,
            Intensity->500 GravitationalAcceleration,
            CollectionContainer->Model[Container, Plate, "96-well 2mL Deep Well Plate"],
            Instrument->Model[Instrument,Centrifuge,"VSpin"],
            Time-> 5 Minute
          ]
        }]
      ],
      $Failed,
      Messages:>{Error::UnusableCentrifuge,Error::NoUsableCentrifuge,Error::InvalidInput}
    ],
    Test["Generate a Protocol using MagneticBeadSeparation for a mixture of sample and container (with multiple samples) inputs:",
      ExperimentRoboticSamplePreparation[{
        LabelContainer[
          Label->{"my mbs container 1","my mbs container 2"},
          Container->{Model[Container, Vessel, "2mL Tube"],Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Destination->{"my mbs container 1","my mbs container 2","my mbs container 2","my mbs container 2"},
          DestinationWell-> {"A1","A1","A2","A3"},
          DestinationLabel-> {"my mbs sample 1","my mbs sample 2","my mbs sample 3","my mbs sample 4"}
        ],
        MagneticBeadSeparation[
          Sample ->{"my mbs sample 1","my mbs container 2"},
          PreWash->True,
          Volume->400Microliter
        ]
      }],
      ObjectP[Object[Protocol,RoboticSamplePreparation]],
      Messages:>{
        Warning::GeneralResolvedMagneticBeads
      }
    ],
    Example[{Additional, MultiProbeHead, "Robotic Transfer automatically recognizes MultiProbeHead transfers of the full plate (part 1):"} ,
      Module[{protocol, downloadedInfo, transferLengths},
        protocol = ExperimentRoboticSamplePreparation[
          {
            LabelContainer[Label->"plate96", Container->Object[Container,Plate,"Test 96 DWP 3 for ExperimentRoboticSamplePreparation"<>$SessionUUID]],
            LabelContainer[Label->"new plate96", Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
            (* full plate transfer *)
            Transfer[
              Source->"plate96",
              Destination->"new plate96",
              Amount->50 Microliter,
              SourceWell->Flatten@AllWells[],
              DestinationWell->Flatten@AllWells[]
            ]
          }
        ];

        downloadedInfo = Download[protocol, OutputUnitOperations[[2]][{DeviceChannel, MultichannelTransferName}]];

        transferLengths = Length/@Split[downloadedInfo[[2]]];

        {
          transferLengths,
          Length[Cases[downloadedInfo[[1]], MultiProbeHead]]
        }

      ],
      {
        {96},
        96
      },
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
      )
    ],
    Example[{Additional, MultiProbeHead, "Robotic Transfer automatically recognizes MultiProbeHead transfers of the full plate (part 2):"} ,
      Module[{protocol, downloadedInfo, transferLengths},
        protocol = ExperimentRoboticSamplePreparation[
          {
            LabelContainer[Label->"plate96", Container->Object[Container,Plate,"Test 96 DWP 3 for ExperimentRoboticSamplePreparation"<>$SessionUUID]],
            LabelContainer[Label->"new plate96", Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
            LabelContainer[Label->"new plate96 2", Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
            (* 54 well transfer *)
            Transfer[
              Source->"plate96",
              Destination->"new plate96",
              Amount->50 Microliter,
              SourceWell->Flatten[AllWells[][[2;;7,2;;10]]],
              DestinationWell->Flatten[AllWells[][[2;;7,2;;10]]]
            ],
            (* 47 well transfer -> not automatically MultiProbeHead *)
            Transfer[
              Source->"plate96",
              Destination->"new plate96 2",
              Amount->50 Microliter,
              SourceWell->Most[Flatten[AllWells[][[;;,1;;6]]]],
              DestinationWell->Most[Flatten[AllWells[][[;;,1;;6]]]]
            ]
          }
        ];

        downloadedInfo = Download[protocol, OutputUnitOperations[[2]][{DeviceChannel, MultichannelTransferName}]];

        transferLengths = Length/@Split[downloadedInfo[[2]]];

        {
          transferLengths,
          Length[Cases[downloadedInfo[[1]], MultiProbeHead]]
        }

      ],
      {
        {54,8,8,8,8,8,7},
        54
      },
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
      )
    ],
    Example[{Additional, MultiProbeHead, "Robotic Transfer automatically recognizes MultiProbeHead transfers of the full plate (part 3):"} ,
      Module[{protocol, downloadedInfo, transferLengths},
        protocol = ExperimentRoboticSamplePreparation[
          {
            LabelContainer[Label->"plate96", Container->Object[Container,Plate,"Test 96 DWP 3 for ExperimentRoboticSamplePreparation"<>$SessionUUID]],
            LabelContainer[Label->"reservoir", Container->Object[Container,Plate,"Test reservoir with water for ExperimentRoboticSamplePreparation"<>$SessionUUID]],
            LabelContainer[Label->"new plate96", Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
            LabelContainer[Label->"new reservoir", Container->Model[Container,Plate,"id:54n6evLWKqbG"]],
            Transfer[
              Source->"reservoir",
              Destination->"new plate96",
              Amount->50 Microliter,
              DestinationWell->Flatten[AllWells[][[;;,1;;6]]]
            ],
            Transfer[
              Source->"plate96",
              Destination->"new reservoir",
              Amount->50 Microliter,
              SourceWell->Flatten[AllWells[][[;;,1;;6]]]
            ]
          }
        ];

        downloadedInfo = Download[protocol, OutputUnitOperations[[2]][{DeviceChannel, MultichannelTransferName}]];

        transferLengths = Length/@Split[downloadedInfo[[2]]];

        {
          transferLengths,
          Length[Cases[downloadedInfo[[1]], MultiProbeHead]]
        }

      ],
      {
        {48,48},
        96
      },
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
      )
    ],
    Example[{Additional, MultiProbeHead, "Robotic Transfer automatically recognizes MultiProbeHead transfers of the full plate (part 4):"} ,
      Module[{protocol, downloadedInfo, transferLengths},
        protocol = ExperimentRoboticSamplePreparation[
          {
            LabelContainer[Label->"plate96", Container->Object[Container,Plate,"Test 96 DWP 3 for ExperimentRoboticSamplePreparation"<>$SessionUUID]],
            LabelContainer[Label->"new plate384", Container->Model[Container,Plate,"384-well UV-Star Plate"]],
            (* stamp 384 plate via 4 "sub-plates" *)
            Transfer[
              Source->"plate96",
              Destination->"new plate384",
              Amount->10 Microliter,
              SourceWell->Flatten[ConstantArray[AllWells[],4]],
              DestinationWell->Flatten[{map384["A1"], map384["A2"], map384["B1"], map384["B2"]}]
            ]
          }
        ];

        downloadedInfo = Download[protocol, OutputUnitOperations[[2]][{DeviceChannel, MultichannelTransferName}]];

        transferLengths = Length/@Split[downloadedInfo[[2]]];

        {
          transferLengths,
          Length[Cases[downloadedInfo[[1]], MultiProbeHead]]
        }

      ],
      {
        {96,96,96,96},
        384
      },
      TimeConstraint->600,
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
      )
    ],
    (* Note: this example takes too much computation resource now and comment out for more robust rsp unit tests *)
    (*
    Example[{Additional, MultiProbeHead, "Robotic Transfer automatically recognizes MultiProbeHead transfers of the full plate (part 5):"} ,
      Module[{protocol, downloadedInfo, transferLengths},
        protocol = ExperimentRoboticSamplePreparation[
          {
            LabelContainer[Label->"plate384", Container->Object[Container,Plate,"Test 384 plate for ExperimentRoboticSamplePreparation"<>$SessionUUID]],
            LabelContainer[Label->"new plate384", Container->Model[Container,Plate,"384-well UV-Star Plate"]],
            (* stamp 384 plate via 4 "sub-plates" *)
            Transfer[
              Source->"plate384",
              Destination->"new plate384",
              Amount->10 Microliter,
              SourceWell->Flatten[{map384["A1"], map384["A2"], map384["B1"], map384["B2"]}],
              DestinationWell->Flatten[{map384["A1"], map384["A2"], map384["B1"], map384["B2"]}]
            ]
          }
        ];

        downloadedInfo = Download[protocol, OutputUnitOperations[[2]][{DeviceChannel, MultichannelTransferName}]];

        transferLengths = Length/@Split[downloadedInfo[[2]]];

        {
          transferLengths,
          Length[Cases[downloadedInfo[[1]], MultiProbeHead]]
        }

      ],
      {
        {96,96,96,96},
        384
      },
      TimeConstraint->1800,
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
      ),
      HardwareConfiguration -> HighRAM
    ],*)
    Example[{Additional, MultiProbeHead, "Robotic Transfer automatically recognizes MultiProbeHead transfers of the full plate (part 6):"} ,
      Module[{protocol, downloadedInfo, transferLengths},
        protocol = ExperimentRoboticSamplePreparation[
          {
            LabelContainer[Label->"reservoir", Container->Object[Container,Plate,"Test reservoir with water for ExperimentRoboticSamplePreparation"<>$SessionUUID]],
            LabelContainer[Label->"plate384", Container->Object[Container,Plate,"Test 384 plate for ExperimentRoboticSamplePreparation"<>$SessionUUID]],
            LabelContainer[Label->"new plate96", Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
            LabelContainer[Label->"new reservoir", Container->Model[Container,Plate,"id:54n6evLWKqbG"]],
            Transfer[
              Source->"plate384",
              Destination->"new plate96",
              Amount->10 Microliter,
              SourceWell->Flatten[AllWells[NumberOfWells->384][[;;;;2,;;;;2]]],
              DestinationWell->Flatten[AllWells[]]
            ],
            Transfer[
              Source->"reservoir",
              Destination->"new reservoir",
              Amount->50 Microliter,
              SourceWell->ConstantArray["A1",48],
              DestinationWell->ConstantArray["A1",48]
            ],
            Transfer[
              Source->"plate384",
              Destination->"new reservoir",
              Amount->10 Microliter,
              SourceWell->Flatten[AllWells[NumberOfWells->384][[1;;All;;2,1;;12;;2]]],
              DestinationWell->ConstantArray["A1",48]
            ]
          }
        ];

        downloadedInfo = Download[protocol, OutputUnitOperations[[2]][{DeviceChannel, MultichannelTransferName}]];

        transferLengths = Length/@Split[downloadedInfo[[2]]];

        {
          transferLengths,
          Length[Cases[downloadedInfo[[1]], MultiProbeHead]]
        }

      ],
      {
        {96,48,48},
        192
      },
      SetUp :> ($CreatedObjects = {};),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects];
      )
    ],
    Test["Request extra tip resources for nested tips in MultiProbeHead transfers so we don't use the bottom rack (to avoid collision):",
      Module[{protocol,resources,tipResources},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelSample[Label -> "my water", Sample -> Model[Sample, "Milli-Q water"], Container -> Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"], Amount -> 180 Milliliter],
          LabelContainer[Label -> "my plate", Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
          Sequence@@ConstantArray[
            Transfer[Source -> "my water", Destination -> "my plate", DestinationWell -> {"A1", "A2", "A3", "A4", "A5", "B1", "B2", "B3", "B4", "B5", "C1", "C2", "C3", "C4", "C5", "D1", "D2", "D3", "D4", "D5"}, Amount -> 0.1 Milliliter, DeviceChannel -> MultiProbeHead],
            8
          ]},
          OptimizeUnitOperations -> False
        ];
        resources=Download[protocol,RequiredResources];
        tipResources=Cases[resources,{_,RequiredTips,_,_}][[All,1]];
        Unitless@Download[tipResources,Amount]
      ],
      {_,384,384,384}
    ],
    Test["Multiple MultiProbeHead transfers can be combined into the same unit operation and given different MultichannelTransferName:",
      Module[{protocol,transferUO},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelSample[Label -> "my water", Sample -> Model[Sample, "Milli-Q water"], Container -> Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"], Amount -> 180 Milliliter],
          LabelContainer[Label -> "my plate", Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
          Transfer[Source -> "my water", Destination -> "my plate", DestinationWell -> {"A1", "A2", "A3", "A4", "A5", "B1", "B2", "B3", "B4", "B5", "C1", "C2", "C3", "C4", "C5", "D1", "D2", "D3", "D4", "D5"}, Amount -> 0.1 Milliliter, DeviceChannel -> MultiProbeHead],
          Transfer[Source -> "my water", Destination -> "my plate", DestinationWell -> {"D7", "D8", "D9", "D10", "D11", "D12", "E7", "E8", "E9", "E10", "E11", "E12", "F7", "F8", "F9", "F10", "F11", "F12", "G7", "G8", "G9", "G10", "G11", "G12", "H7", "H8", "H9", "H10", "H11", "H12"}, Amount -> 0.1 Milliliter, DeviceChannel -> MultiProbeHead]
        },
          OptimizeUnitOperations -> True
        ];
        transferUO=Download[protocol,OutputUnitOperations[[3]]];
        {
          Download[transferUO,DeviceChannel],
          Download[transferUO,DestinationWell],
          Length/@Split[Download[transferUO,MultichannelTransferName]]
        }
      ],
      {
        {MultiProbeHead..},
        {"A1", "A2", "A3", "A4", "A5", "B1", "B2", "B3", "B4", "B5", "C1", "C2", "C3", "C4", "C5", "D1", "D2", "D3", "D4", "D5","D7", "D8", "D9", "D10", "D11", "D12", "E7", "E8", "E9", "E10", "E11", "E12", "F7", "F8", "F9", "F10", "F11", "F12", "G7", "G8", "G9", "G10", "G11", "G12", "H7", "H8", "H9", "H10", "H11", "H12"},
        {20, 30}
      }
    ],
    Test["MultiProbeHead transfers with different amounts in the same UO can be split into two transfer groups, if blocks with different amounts are still in MxN shape:",
      Module[{testFunction,firstAttempt,protocol,transferUO},
        testFunction[] := ExperimentRoboticSamplePreparation[{
          LabelSample[Label -> "my water", Sample -> Model[Sample, "Milli-Q water"], Container -> Model[Container, Plate, "200mL Polypropylene Robotic Reservoir, non-sterile"], Amount -> 180 Milliliter],
          LabelContainer[Label -> "my plate", Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
          Transfer[Source -> "my water", Destination -> "my plate", DestinationWell -> Flatten[AllWells[]], Amount -> Join[ConstantArray[0.1 Milliliter,48],ConstantArray[0.2 Milliliter,48]], DeviceChannel -> MultiProbeHead]
        },
          OptimizeUnitOperations -> True
        ];
        (* doing this goofy retry logic because this test is susceptible to these transient errors *)
        firstAttempt = Quiet[Check[
          testFunction[],
          $Failed,
          {Download::TransientNetworkError, Download::InternalError, LinkObject::linkd}
        ]];
        protocol = If[FailureQ[firstAttempt],
          testFunction[],
          firstAttempt
        ];
        transferUO=Download[protocol,OutputUnitOperations[[3]]];
        {
          Download[transferUO,DeviceChannel],
          Download[transferUO,DestinationWell],
          Download[transferUO,AmountVariableUnit],
          Length/@Split[Download[transferUO,MultichannelTransferName]]
        }
      ],
      {
        {MultiProbeHead..},
        Flatten[AllWells[]],
        Join[ConstantArray[0.1 Milliliter,48],ConstantArray[0.2 Milliliter,48]],
        {48, 48}
      }
    ],
    Test["Allows singleton input for an Aliquot unit operation:",
      Module[{protocol,aliquotUO,transferUO},
        protocol=ExperimentRoboticSamplePreparation[
          {
            LabelSample[Label -> "myConcentratedSample", Sample -> Model[Sample, "Milli-Q water"], Amount -> 165 Microliter, Container -> Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]],
            Aliquot[Source -> "myConcentratedSample", Amount -> (1.6 Milliliter/{40, 100, 200}), ContainerOut -> {Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"], Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"], Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"]}]
          }
        ];
        aliquotUO=Download[protocol,OutputUnitOperations[[-1]]];
        (* Last is a mix *)
        transferUO=Download[aliquotUO,RoboticUnitOperations[[-2]]];
        {
          SameQ@@Download[aliquotUO,Source],
          Download[transferUO,SourceLabel]
        }
      ],
      {
        True,
        {"myConcentratedSample", "myConcentratedSample", "myConcentratedSample"}
      }
    ],
    Example[{Additional, ClassifyTransfer, "Once the robotic transfer protocol has run in the lab, you may call ClassifyTransfer on the OutputUnitOperations field to classify any transfer unit operations. The non-transfer unit operations are left alone:"},
      Module[{outputUnitOperations},
        outputUnitOperations = Download[Object[Protocol, RoboticCellPreparation, "id:N80DNj0kZR1D"], OutputUnitOperations];
        ClassifyTransfer[outputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation, LabelContainer]],
        ObjectP[Object[UnitOperation, Transfer]],
        ObjectP[Object[UnitOperation, Pellet]],
        ObjectP[Object[UnitOperation, Cover]]
      },
      Variables :> {outputUnitOperations},
      TearDown :> {
        (* remove the classifications and confidences from the test objects *)
        Upload[
          <|
            Object -> Object[UnitOperation, Transfer, "id:rea9jlaZnERe"],
            Replace[AspirationClassifications] -> Null,
            Replace[AspirationClassificationConfidences] -> Null
          |>
        ]
      }
    ],
    Example[{Additional, ClassifyTransfer, "After calling ClassifyTransfer on the OutputUnitOperations field of the robotic transfer protocol, the fields called AspirationClassifications and AspirationClassificationConfidences are populated:"},
      Module[{outputUnitOperations, classifiedUnitOperations, transferObjects},
        outputUnitOperations = Download[Object[Protocol, RoboticCellPreparation, "id:N80DNj0kZR1D"], OutputUnitOperations];
        classifiedUnitOperations = ClassifyTransfer[outputUnitOperations];
        transferObjects = Cases[classifiedUnitOperations, ObjectP[Object[UnitOperation, Transfer]]];
        Download[transferObjects, {AspirationClassifications, AspirationClassificationConfidences}]
      ],
      {{{(Success | Failure)..}, {RangeP[0 Percent, 100 Percent]..}}..},
      Variables :> {outputUnitOperations, classifiedUnitOperations, transferObjects},
      TearDown :> {
        (* remove the classifications and confidences from the test objects *)
        Upload[
          <|
            Object -> Object[UnitOperation, Transfer, "id:rea9jlaZnERe"],
            Replace[AspirationClassifications] -> Null,
            Replace[AspirationClassificationConfidences] -> Null
          |>
        ]
      }
    ],
    (* Resource combination & Split *)
    Test["Combines the resources for the same Model[Sample] from multiple Transfer unit operations:",
      Module[
        {testFunction,firstAttempt,protocol,requiredObjects,waterPositions,resource},
        testFunction[] := ExperimentRoboticSamplePreparation[
          {
            LabelContainer[
              Label -> {"plate1", "plate2"},
              Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
            ],
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> "plate1",
              DestinationWell -> Flatten[AllWells[]],
              Amount -> 500 Microliter
            ],
            (* Add Wait so that the two Transfers do not combine together *)
            Wait[
              Duration -> 1 Minute
            ],
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> "plate2",
              DestinationWell -> Flatten[AllWells[]],
              Amount -> 500 Microliter
            ]
          }
        ];
        (* doing this goofy retry logic because this test is susceptible to these transient errors *)
        firstAttempt = Quiet[Check[
          testFunction[],
          $Failed,
          {Download::TransientNetworkError, Download::InternalError, LinkObject::linkd}
        ]];
        protocol = If[FailureQ[firstAttempt],
          testFunction[],
          firstAttempt
        ];
        requiredObjects = Download[protocol,RequiredObjects];
        waterPositions = Flatten[Position[Download[requiredObjects,Object],Download[Model[Sample, "Milli-Q water"], Object]]];
        resource = FirstCase[Download[protocol,RequiredResources],{_,RequiredObjects,Alternatives@@waterPositions,_}][[1]];
        {
          Count[requiredObjects, ObjectP[Model[Sample, "Milli-Q water"]]],
          Download[resource,Amount],
          Download[resource,ContainerModels]
        }
      ],
      {1,GreaterEqualP[100Milliliter],{ObjectP[Model[Container, Plate, "id:54n6evLWKqbG"]]}}
    ],
    Test["Combines the resources with the same source incubation parameters and the same Model into the same container and require a large enough container:",
      Module[
        {protocol,requiredObjects,waterResource},
        protocol = ExperimentRoboticSamplePreparation[
          {
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              SourceTemperature -> 40 Celsius,
              Destination -> Model[Container, Vessel, "2mL Tube"],
              DestinationWell -> "A1",
              Amount -> 1 Milliliter
            ],
            (* Add Wait so that the two Transfers do not combine together *)
            Wait[
              Duration -> 1 Minute
            ],
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              SourceTemperature -> 40 Celsius,
              Destination -> Model[Container, Vessel, "2mL Tube"],
              DestinationWell -> "A1",
              Amount -> 1 Milliliter
            ]
          }
        ];
        requiredObjects = Download[protocol,RequiredObjects[Object]];
        waterResource = FirstCase[Download[protocol,RequiredResources],{_,RequiredObjects,FirstPosition[requiredObjects,Model[Sample, "id:8qZ1VWNmdLBD"]][[1]],_}][[1]];
        {
          Count[requiredObjects, ObjectP[Model[Sample, "Milli-Q water"]]],
          Download[waterResource,ContainerModels],
          Download[waterResource,Amount]
        }
      ],
      {
        1,
        (* "48-well Pyramid Bottom Deep Well Plate" *)
        {LinkP[Model[Container, Plate, "id:E8zoYveRllM7"]]},
        GreaterP[2Milliliter]
      }
    ],
    Test["Combines the resources with the same source incubation parameters and different Model into the same container (but different wells):",
      Module[
        {protocol,requiredObjects,waterResource,dmsoResource},
        protocol = ExperimentRoboticSamplePreparation[
          {
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              SourceTemperature -> 40 Celsius,
              Destination -> Model[Container, Vessel, "2mL Tube"],
              DestinationWell -> "A1",
              Amount -> 300 Microliter
            ],
            (* Add Wait so that the two Transfers do not combine together *)
            Wait[
              Duration -> 1 Minute
            ],
            Transfer[
              Source -> Model[Sample, "DMSO, anhydrous"],
              SourceTemperature -> 40 Celsius,
              Destination -> Model[Container, Vessel, "2mL Tube"],
              DestinationWell -> "A1",
              Amount -> 300 Microliter
            ]
          }
        ];
        requiredObjects = Download[protocol,RequiredObjects[Object]];
        waterResource = FirstCase[Download[protocol,RequiredResources],{_,RequiredObjects,FirstPosition[requiredObjects,Model[Sample, "id:8qZ1VWNmdLBD"]][[1]],_}][[1]];
        dmsoResource = FirstCase[Download[protocol,RequiredResources],{_,RequiredObjects,FirstPosition[requiredObjects,Model[Sample, "id:M8n3rx0wxbB8"]][[1]],_}][[1]];
        {
          Count[requiredObjects, ObjectP[Model[Sample, "Milli-Q water"]]],
          Count[requiredObjects, ObjectP[Model[Sample, "DMSO, anhydrous"]]],
          MatchQ[Download[waterResource,ContainerName],Download[dmsoResource,ContainerName]],
          !NullQ[Download[waterResource,ContainerName]],
          Download[waterResource,ContainerModels],
          Download[dmsoResource,ContainerModels],
          {Download[waterResource,Well],Download[dmsoResource,Well]}
        }
      ],
      {
        1,1,True,True,
        {LinkP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]},
        {LinkP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]},
        {"A1","A2"}
      }
    ],
    Test["Request only one counterweight per model across different unit operations:",
      Module[{protocol,centrifugeUOs,centrifugeCounterweightResources,allResources,allResourceModels,counterweightResources},
        protocol=ExperimentRoboticSamplePreparation[{
          Centrifuge[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Time -> 5 Minute,
            Intensity -> 3000 RPM
          ],
          (* Use a wait UO to not combine multiple Centrifuge UO *)
          Wait[
            Duration->1Minute
          ],
          Centrifuge[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Time -> 1 Minute,
            Intensity -> 3000 RPM
          ],
          (* Filter UO has a collection container so the total weight is different, requesting a new counterweight model *)
          Filter[
            Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
            Volume -> 300 Microliter,
            FiltrationType->Centrifuge,
            Intensity->500 GravitationalAcceleration,
            Time-> 5 Minute
          ]
        }];
        centrifugeUOs=Cases[Download[protocol,OutputUnitOperations],ObjectP[Object[UnitOperation,Centrifuge]]];
        centrifugeCounterweightResources=Map[
          (FirstCase[#[RequiredResources],{_,Counterweight,___}][[1]])&,
          centrifugeUOs
        ];
        allResources=protocol[RequiredResources][[All,1]];
        allResourceModels=Quiet@Download[allResources,Models];
        counterweightResources=PickList[
          allResources,
          allResourceModels,
          ListableP[ObjectP[Model[Item,Counterweight]]]
        ];
        {
          SameObjectQ@@centrifugeCounterweightResources,
          Length[counterweightResources]
        }
      ],
      {
        True,
        2
      }
    ],
    Test["Request only one counterweight per model across different unit operations and allow more plates on deck:",
      ExperimentRoboticSamplePreparation[{
        LabelContainer[
          Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"],
          Label->ToString/@Range[10]
        ],
        Transfer[
          Source->Model[Sample, "Milli-Q water"],
          Destination->ToString/@Range[10],
          DestinationWell->"A1",
          Amount->500Microliter
        ],
        Centrifuge[
          Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
          Time -> 5 Minute,
          Intensity -> 3000 RPM
        ],
        (* Use a wait UO to not combine multiple Centrifuge UO *)
        Wait[
          Duration->1Minute
        ],
        Centrifuge[
          Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
          Time -> 1 Minute,
          Intensity -> 3000 RPM
        ],
        (* Use a wait UO to not combine multiple Centrifuge UO *)
        Wait[
          Duration->1Minute
        ],
        Centrifuge[
          Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
          Time -> 1 Minute,
          Intensity -> 3000 RPM
        ],
        (* Use a wait UO to not combine multiple Centrifuge UO *)
        Wait[
          Duration->1Minute
        ],
        Centrifuge[
          Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
          Time -> 1 Minute,
          Intensity -> 3000 RPM
        ],
        (* Use a wait UO to not combine multiple Centrifuge UO *)
        Wait[
          Duration->1Minute
        ],
        Centrifuge[
          Sample -> {Object[Sample, "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID]},
          Time -> 1 Minute,
          Intensity -> 3000 RPM
        ]
      }],
      (* Because the counterweight is reused everytime, we can fit everything into one deck *)
      ObjectP[Object[Protocol,RoboticSamplePreparation]]
    ],
    Example[{Behaviors,RequiredObjects,"When creating resources, excluded Hamilton tips from RequiredObjects and only places them in RequiredTips:"},
      Download[
        ExperimentRoboticSamplePreparation[{Transfer[Source->Model[Sample, "Milli-Q water"],Destination->Model[Container, Vessel, "2mL Tube"],Amount->0.7Milliliter]}],
        {RequiredObjects,RequiredTips}
      ],
      {
        {Except[LinkP[Model[Item,Tips]]]..},
        {LinkP[Model[Item,Tips]]..}
      }
    ]
  },

  TurnOffMessages:>{Warning::SamplesOutOfStock},

  SymbolSetUp:>{
    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::SampleMustBeMoved];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ExpiredSamples];

    Module[{existsFilter,
      tube1,tube2,tube3,tube4,tube5,tube6,plate6,plate7,plate8,plate9,reservoir1,plate10,plate11,plate12,plate13,plate14,plate15,platemodel1,
      createdSamples,lid
    },

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects={
        Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 2 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 3 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 5 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96-well UV Star Plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96-well AlphaPlate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 DWP 2 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 DWP 3 for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test 96 DWP 4 for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test 96 DWP 5 for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test 96 DWP 6 for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test 384 plate for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test reservoir with water for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 2 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 3 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 4 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test powder sample 5 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test AlphaScreen sample 8 in AlphaPlate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 9 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 10 (Sterile) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 11 (Living) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Model[Container,Plate,"Test plate model with no Counterweights for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Model[Container,Plate,"Test large plate model for ExperimentRoboticSamplePreparation lidding"<>$SessionUUID],
        Object[Container,Plate,"Test tall plate"<>$SessionUUID],
        Object[Sample,"Test sample in tall plate"<>$SessionUUID],
        Object[Sample,"Test water sample 1 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Sample,"Test water sample 2 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Sample,"Test water sample 3 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Item,Lid,"Test Universal Black Lid for ExperimentRoboticSamplePreparation"<>$SessionUUID]

      };

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter=DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ]];
      (* Create a new Container model *)
      platemodel1=Upload[
        <|
          DeveloperObject->True,
          Type->Model[Container,Plate],
          Name->"Test plate model with no Counterweights for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          NumberOfWells->6,
          AspectRatio->3/2,
          Footprint->Plate,
          LiquidHandlerPrefix->"testPrefix",
          Dimensions->{Quantity[0.12776`,"Meters"],Quantity[0.08548`,"Meters"],Quantity[0.016059999999999998`,"Meters"]},
          Replace[Positions]->{
            <|Name->"A1",Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
            <|Name->"A2",Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
            <|Name->"A3",Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
            <|Name->"B1",Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
            <|Name->"B2",Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>,
            <|Name->"B3",Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>
          },
          Replace[PositionPlotting]->{
            <|Name->"A1",XOffset->0.024765 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter,CrossSectionalShape->Circle,Rotation->0.|>,
            <|Name->"A2",XOffset->0.063885 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter,CrossSectionalShape->Circle,Rotation->0.|>,
            <|Name->"A3",XOffset->0.103005 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter,CrossSectionalShape->Circle,Rotation->0.|>,
            <|Name->"B1",XOffset->0.024765 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter,CrossSectionalShape->Circle,Rotation->0.|>,
            <|Name->"B2",XOffset->0.063885 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter,CrossSectionalShape->Circle,Rotation->0.|>,
            <|Name->"B3",XOffset->0.103005 Meter,YOffset->0.023175 Meter,ZOffset->0.00254 Meter,CrossSectionalShape->Circle,Rotation->0.|>
          },
          WellDiameter->35.1 Millimeter,
          WellDepth->13 Millimeter,
          Columns->3,
          HorizontalMargin->7.045 Millimeter,
          HorizontalPitch->39.12 Millimeter,
          MaxCentrifugationForce->10000 GravitationalAcceleration,
          TareWeight->33.19 Gram,
          Rows->2,
          VerticalMargin->5.445 Millimeter,
          VerticalPitch->39.12 Millimeter,
          DepthMargin->1.27 Millimeter
        |>
      ];
      Upload[Association[
        DeveloperObject->True,
        Type->Model[Container,Plate],
        Name->"Test large plate model for ExperimentRoboticSamplePreparation lidding"<>$SessionUUID,
        LiquidHandlerPrefix->"testPrefix",
        NumberOfWells->1,
        AspectRatio->1,
        Footprint->Plate,
        DefaultStorageCondition->Link[Model[StorageCondition, "id:7X104vnR18vX"]],
        Dimensions->{Quantity[0.12776`,"Meters"],Quantity[0.08548`,"Meters"],Quantity[50`,"Millimeters"]},
        Replace[ExternalDimensions3D]->{{Quantity[0.12776`,"Meters"],Quantity[0.08548`,"Meters"],Quantity[0,"Millimeters"]},{Quantity[200,"Meters"],Quantity[200,"Meters"],Quantity[50,"Millimeters"]}},
        Replace[Positions]->{
          <|Name->"A1",Footprint->Null,MaxWidth->0.03543 Meter,MaxDepth->0.03543 Meter,MaxHeight->0.0174 Meter|>
        },
        Replace[PositionPlotting]->{
          <|Name->"A1",XOffset->0.024765 Meter,YOffset->0.062295 Meter,ZOffset->0.00254 Meter,CrossSectionalShape->Circle,Rotation->0.|>
        },
        Replace[CoverFootprints] -> {LidSBSUniversal, SealSBS, SBSPlateLid},
        Replace[CoverTypes] -> {Seal, Place},
        MaxVolume->1 Milliliter
      ]];
      (* Create some empty containers. *)
      {
        tube1,tube2,tube3,tube4,tube5,tube6,
        plate6,plate7,plate8,plate9,
        reservoir1,plate10,plate11,plate12,plate13,plate14,plate15,lid
      }=Upload[{
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 1 for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 2 for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 3 for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 4 for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 5 for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test 50mL Tube 6 for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
          Name->"Test 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well UV-Star Plate"],Objects],
          Name->"Test 96-well UV Star Plate for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"AlphaPlate Half Area 96-Well Gray Plate"],Objects],
          Name->"Test 96-well AlphaPlate for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
          Name->"Test 96 DWP 2 for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"id:54n6evLWKqbG"],Objects],
          Name->"Test reservoir with water for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
          Name->"Test 96 DWP 3 for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"384-well UV-Star Plate"],Objects],
          Name->"Test 384 plate for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"Test plate model with no Counterweights for ExperimentRoboticSamplePreparation" <> $SessionUUID],Objects],
          Name->"Test 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
          Name->"Test 96 DWP 4 for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
          Name->"Test 96 DWP 5 for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Plate],
          Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
          Name->"Test 96 DWP 6 for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Item,Lid],
          Model->Link[Model[Item, Lid, "Universal Black Lid"],Objects],
          Name->"Test Universal Black Lid for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          Site->Link[$Site],
          DeveloperObject->True
        |>

      }];

      UploadCover[plate13,Cover->lid];
      (* sample in a tall plate *)
      Module[{sample1,container},
        sample1=Upload[<|
          DeveloperObject->True,
          Type->Object[Sample],
          Model->Link[Model[Sample,"Milli-Q water"],Objects],
          Name->"Test sample in tall plate"<>$SessionUUID,
          Site->Link[$Site],
          Volume->200 Microliter
        |>];


        container=Upload[<|
          DeveloperObject->True,
          Type->Object[Container,Plate],
          Model->Link[Model[Container, Plate, Filter, "Plate Filter, GlassFiber, 30.0um, 2mL"],Objects],
          Name->"Test tall plate"<>$SessionUUID,
          Site->Link[$Site],
          Replace[Contents]->{
            {"A1", Link[sample1, Container]}
          }
        |>];
      ];
      (* Create some samples for testing purposes *)
      createdSamples=UploadSample[
        (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
        Flatten@{
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"id:vXl9j5qEn66B"],(* "Sodium carbonate, anhydrous" *)
          Model[Sample,"Milli-Q water"],
          Model[Sample,StockSolution,"0.2M FITC"],
          Model[Sample,StockSolution,"0.2M FITC"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          ConstantArray[Model[Sample,"Milli-Q water"],96],
          ConstantArray[Model[Sample,"Milli-Q water"],384]
        },
        Join[{
          {"A1",tube1},
          {"A1",tube2},
          {"A1",tube3},
          {"A1",tube4},
          {"A1",tube5},
          {"A1",plate6},
          {"A1",plate7},
          {"A1",plate8},
          {"A1",plate9},
          {"A1",reservoir1},
          {"A1",plate12},
          {"B2",plate12},
          {"B3",plate12},
          {"A1",plate14},
          {"A1",plate15}
        },
          ({#,plate10}&/@Flatten@AllWells[]),
          ({#,plate11}&/@Flatten@AllWells[NumberOfWells->384])
        ],
        Name->Join[{
          "Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test water sample 2 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test water sample 3 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test water sample 4 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test powder sample 5 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test AlphaScreen sample 8 in AlphaPlate for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test water sample 9 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          Null,
          "Test water sample 1 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          "Test water sample 2 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          "Test water sample 3 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID,
          "Test water sample 10 (Sterile) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID,
          "Test water sample 11 (Living) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID
        },
          ConstantArray[Null,96],
          ConstantArray[Null,384]
        ],
        InitialAmount->Join[{
          25 Milliliter,
          10 Milliliter,
          10 Milliliter,
          10 Milliliter,
          10 Gram,
          1 Milliliter,
          200 Microliter,
          200 Microliter,
          1 Milliliter,
          180 Milliliter,
          200 Microliter,
          200 Microliter,
          200 Microliter,
          1 Milliliter,
          1 Milliliter
        },
          ConstantArray[1.8 Milliliter,96],
          ConstantArray[100 Microliter,384]
        ],
        SampleHandling->Join[{
          Liquid,
          Liquid,
          Liquid,
          Liquid,
          Powder,
          Liquid,
          Liquid,
          Liquid,
          Liquid,
          Liquid,
          Liquid,
          Liquid,
          Liquid,
          Liquid,
          Liquid
        },
          ConstantArray[Liquid,96],
          ConstantArray[Liquid,384]
        ]
      ];

      (* Make some changes to our samples for testing purposes *)
      Upload[{
        <|Object->#,Status->Available,DeveloperObject->True|>&/@createdSamples
      }];
      Upload[{
        <|Object -> Object[Sample, "Test water sample 10 (Sterile) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID], Sterile -> True|>,
        <|Object -> Object[Sample, "Test water sample 11 (Living) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID], Living -> True|>
      }]

    ]
  },
  SymbolTearDown:>{
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ExpiredSamples];
    On[Warning::SampleMustBeMoved];
    Module[{allObjects},
      allObjects={
        Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 2 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 3 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 5 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96-well UV Star Plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96-well AlphaPlate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 DWP 2 for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 DWP 3 for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test 96 DWP 4 for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test 96 DWP 5 for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test 96 DWP 6 for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test 384 plate for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Container,Plate,"Test reservoir with water for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 2 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 3 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 4 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test powder sample 5 in 50mL Tube for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 6 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test AlphaScreen sample 8 in AlphaPlate for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 9 in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 10 (Sterile) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 11 (Living) in 96 DWP for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Model[Container,Plate,"Test plate model with no Counterweights for ExperimentRoboticSamplePreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Model[Container,Plate,"Test large plate model for ExperimentRoboticSamplePreparation lidding"<>$SessionUUID],
        Object[Container,Plate,"Test tall plate"<>$SessionUUID],
        Object[Sample,"Test sample in tall plate"<>$SessionUUID],
        Object[Sample,"Test water sample 1 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Sample,"Test water sample 2 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Sample,"Test water sample 3 in 96 well plate with no counterweights for ExperimentRoboticSamplePreparation"<>$SessionUUID],
        Object[Item,Lid,"Test Universal Black Lid for ExperimentRoboticSamplePreparation"<>$SessionUUID]

      };
      Quiet[EraseObject[allObjects,Force->True,Verbose->False]];
    ];
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];

DefineTests[
  partitionTips,
  {Test["Requiring a box of 96 non-stacked tips will result in 24 + 96 (with the original buffer, we need 12 + 96, then we buffer the new tip box to make 24 + 96):",
    partitionTips[
      Download[
        Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True],
        Packet[Object, Name, PipetteType, Sterile, WideBore,Filtered,Aspirator,GelLoading, Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint]
      ],
      ConstantArray[Resource[Sample -> Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"][Object], Amount -> 1], 96],
      {}
    ],
    {{}, {{Model[Item, Tips, "id:54n6evKx0oB9"], 24}, {Model[Item, Tips, "id:54n6evKx0oB9"], 96}}}
  ],
  Test["Requiring 96 tips from a stacked tip will result in 24 + 96 = 120 in a single stack (once again logic of 12 + 12 + 96 -- to buffer the new layer created by the buffer):",
    partitionTips[
      Download[
        Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True],
        Packet[Object, Name, PipetteType, Sterile,  WideBore,Filtered,Aspirator,GelLoading,  Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint]
      ],
      ConstantArray[Resource[Sample -> Model[Item, Tips, "300 uL Hamilton tips, non-sterile"][Object], Amount -> 1], 96],
      {}
    ],
    {{{Model[Item, Tips, "id:o1k9jAKOwwEA"], 120}}, {}}
  ],
  Test["Requiring 96*4 tips from a stacked tip will result in 96*4 in a single stack and 4*12(+12 to buffer the newly created layer we have):",
    partitionTips[
      Download[
        Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True],
        Packet[Object, Name, PipetteType, Sterile,  WideBore,Filtered,Aspirator,GelLoading,  Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint]
      ],
      ConstantArray[Resource[Sample -> Model[Item, Tips, "300 uL Hamilton tips, non-sterile"][Object], Amount -> 1], 96*4],
      {}
    ],
    {{{Model[Item, Tips, "id:o1k9jAKOwwEA"], 60}, {Model[Item, Tips, "id:o1k9jAKOwwEA"], 384}}, {}}
  ],
  Test["Requiring 96-12 tips results in a perfect tip box for non-stacked tips:",
    partitionTips[
      Download[
        Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True],
        Packet[Object, Name, PipetteType, Sterile,  WideBore,Filtered,Aspirator,GelLoading,  Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint]
      ],
      ConstantArray[Resource[Sample -> Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"][Object], Amount -> 1], 96-12],
      {}
    ],
    {{}, {{Model[Item, Tips, "id:54n6evKx0oB9"], 96}}}
  ],
  Test["Requiring 96-12 tips results in a perfect layer for stacked tips:",
    partitionTips[
      Download[
        Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True],
        Packet[Object, Name, PipetteType, Sterile,  WideBore,Filtered,Aspirator,GelLoading, Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint]
      ],
      ConstantArray[Resource[Sample -> Model[Item, Tips, "300 uL Hamilton tips, non-sterile"][Object], Amount -> 1], 96-12],
      {}
    ],
    {{{Model[Item, Tips, "id:o1k9jAKOwwEA"], 96}}, {}}
  ],
  Test["Using stacked tips in a multi probe transfer will require that at least 2 tip boxes of that tip type are on deck:",
    partitionTips[
      Download[
        Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True],
        Packet[Object, Name, PipetteType, Sterile,  WideBore,Filtered,Aspirator,GelLoading,  Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint]
      ],
      ConstantArray[Resource[Sample -> Model[Item, Tips, "300 uL Hamilton tips, non-sterile"][Object], Amount -> 1], 96-12],
      {Transfer[Tips -> {Model[Item, Tips, "300 uL Hamilton tips, non-sterile"][Object]}, DeviceChannel -> {MultiProbeHead}]}
    ],
    {{{Model[Item, Tips, "id:o1k9jAKOwwEA"], 96}, {Model[Item, Tips, "id:o1k9jAKOwwEA"], 384}}, {}}
  ],
  Test["Using non-stacked tips in a multi probe transfer will never require that there are at least 2 tip boxes of that tip type on deck:",
    partitionTips[
      Download[
        Search[Model[Item, Tips], PipetteType == Hamilton && Deprecated != True],
        Packet[Object, Name, PipetteType, Sterile,  WideBore,Filtered,Aspirator,GelLoading,  Material, AspirationDepth, TipConnectionType, MinVolume, MaxVolume, NumberOfTips, MaxStackSize, Footprint]
      ],
      ConstantArray[Resource[Sample -> Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"][Object], Amount -> 1], 96-12],
      {Transfer[Tips -> {Model[Item, Tips, "1000 uL Hamilton barrier tips, sterile"][Object]}, DeviceChannel -> {MultiProbeHead}]}
    ],
    {{}, {{Model[Item, Tips, "id:54n6evKx0oB9"], 96}}}
  ]}
];

(* ::Subsubsection:: *)
(* ExperimentRoboticCellPreparation *)


DefineTests[
  ExperimentRoboticCellPreparation,
  {
    Example[{Basic, "Generate a protocol for robotic cell preparation with bacterial cell incubation:"},
      ExperimentRoboticCellPreparation[
        {
          IncubateCells[
            Sample -> {
              Object[Sample, "ExperimentRoboticCellPreparation test suspension sample in omnitray" <> $SessionUUID]
            },
            CellType -> {Bacterial},
            CultureAdhesion -> Suspension
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 600
    ],
    Example[{Basic, "Generate a protocol for robotic cell preparation with mammalian cell incubation:"},
      ExperimentRoboticCellPreparation[
        {
          IncubateCells[
            Sample -> {
              Object[Sample, "ExperimentRoboticCellPreparation test cell sample" <> $SessionUUID]
            },
            CellType -> {Mammalian}
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 600
    ],
    Example[{Basic, "Generate a protocol for robotic cell preparation to image cell samples:"},
      ExperimentRoboticCellPreparation[
        {
          ImageCells[
            Sample -> Object[Sample, "ExperimentRoboticCellPreparation test cell sample" <> $SessionUUID]
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 600
    ],
    Example[{Basic, "Generate a protocol for robotic cell preparation to pick colonies off a plate:"},
      ExperimentRoboticCellPreparation[
        {
          PickColonies[
            Sample -> Object[Sample,"ExperimentRoboticCellPreparation test colony sample in omnitray" <> $SessionUUID],
            Populations -> Diameter[],
            DestinationMediaType -> SolidMedia
          ]
        }
      ],
      ObjectP[Object[Protocol, RoboticCellPreparation]],
      TimeConstraint -> 600
    ],
    Example[{Options, Instrument, "Specify a colony handler through the instrument option:"},
      protocol = ExperimentRoboticCellPreparation[
        {
          PickColonies[
            Sample -> Object[Sample, "ExperimentRoboticCellPreparation test colony sample in omnitray" <> $SessionUUID],
            Populations -> Diameter[],
            DestinationMediaType -> SolidMedia
          ]
        },
        Instrument -> Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"] (* QPIX *)
      ];
      Download[protocol, ColonyHandler],
      ObjectP[Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"]],
      Variables :> {protocol}
    ],
    Example[
      {Messages, "WorkCellIsIncompatibleWithMethod", "WorkCell types bioSTAR and microbioSTAR are only compatible with ExperimentRoboticCellPreparation and STAR is only compatible with ExperimentRoboticSamplePreparation:"},
      ExperimentRoboticCellPreparation[{
        Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Vessel, "2mL Tube"], Amount -> 100 Microliter]},
        Instrument -> Object[Instrument, LiquidHandler, "Lin Manuel"]
      ],
      $Failed,
      Messages :> {
        Error::WorkCellIsIncompatibleWithMethod,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "ConflictingWorkCells", "Throw an error is different unit operation requires different work cell:"},
      ExperimentRoboticCellPreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Vessel, "2mL Tube"], Amount -> 100 Microliter,
            WorkCell -> bioSTAR
          ],
          Transfer[
            Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Vessel, "2mL Tube"], Amount -> 100 Microliter,
            WorkCell -> microbioSTAR
          ]
        }
      ],
      $Failed,
      Messages :> {
        Error::ConflictingWorkCells,
        Error::InvalidInput
      }
    ],
    Test["If a plate is covered with seal in earlier unit operation for PCR unit operation, no need to uncover before PCR unit operation:",
      Module[{protocol},
        protocol = ExperimentRoboticCellPreparation[{
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Plate, "96-well PCR Plate"], DestinationWell -> "A1", DestinationLabel -> "water 1", Amount -> 100 Microliter],
          Cover[Sample -> "water 1", CoverType -> Seal, Cover -> Model[Item, PlateSeal, "id:O81aEBZzkJ1D"]],
          PCR[Sample -> "water 1"]
        }];
        Download[protocol, OutputUnitOperations]
      ],
      {
        ObjectP[Object[UnitOperation, Transfer]],
        ObjectP[Object[UnitOperation, Cover]],
        ObjectP[Object[UnitOperation, PCR]]
      }
    ],
    Test["Regardless of whether MagneticBeadSeparation or Filter is the top level unit operation, throw an error if the user specified to use the a heavy magnetization rack (Model[Item,MagnetizationRack,\"Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack\"]) in series with any Filter unit operation:",
      ExperimentRoboticCellPreparation[{
        LabelSample[
          Sample->Model[Sample, "Milli-Q water"],
          Amount->800 Microliter,
          Label-> "my protein sample"
        ],
        ExtractProtein[
          Sample ->"my protein sample",
          Purification -> {MagneticBeadSeparation, SolidPhaseExtraction},
          MagneticBeadSeparationSampleVolume -> 200 Microliter,
          MagnetizationRack -> Model[Item, MagnetizationRack, "id:kEJ9mqJYljjz"],(* "Alpaqua Magnum FLX Enhanced Universal Magnet 96-well Plate Rack"*)
          MagneticBeadSeparationElutionSolutionVolume -> 60 Microliter,
          SolidPhaseExtractionLoadingSampleVolume -> 50 Microliter,
          SolidPhaseExtractionElutionSolutionVolume -> 20 Microliter
        ]
      }],
      $Failed,
      Messages:>{
        Error::ConflictingSpecifiedMagnetizationRackWithFilterUnitOperation,
        Error::ConflictingSpecifiedMagnetizationRackWithFilterUnitOperation,
        Error::InvalidInput
      },
      SetUp:>{Off[General::stop]},
      TearDown:>{On[General::stop]},
      TimeConstraint -> 12000
    ],
    Test["Regardless of whether MagneticBeadSeparation or Filter is the top level unit operation, default to use the light magnetization rack (Model[Item,MagnetizationRack,\"Alpaqua 96S Super Magnet 96-well Plate Rack\"]) if there is any magnetized Transfer used in series with any Filter unit operation:",
      Module[{protocol},
        protocol = Quiet[ExperimentRoboticCellPreparation[{
          LabelSample[
            Sample->Model[Sample, "Milli-Q water"],
            Amount->800 Microliter,
            Label-> "my protein sample"
          ],
          ExtractProtein[
            Sample ->"my protein sample",
            Purification -> {MagneticBeadSeparation, SolidPhaseExtraction},
            MagneticBeadSeparationSampleVolume -> 200 Microliter,
            MagneticBeadSeparationElutionSolutionVolume -> 60 Microliter,
            SolidPhaseExtractionLoadingSampleVolume -> 50 Microliter,
            SolidPhaseExtractionElutionSolutionVolume -> 20 Microliter
          ]
        }], {Warning::SamplesOutOfStock}];
        Cases[
          Flatten[Quiet[Download[protocol,
            {OutputUnitOperations[RoboticUnitOperations][MagnetizationRack], RequiredObjects}]]],
          ObjectP[Model[Item, MagnetizationRack]]
        ]
      ],
      {ObjectP[Model[Item, MagnetizationRack, "id:aXRlGn6O3vqO"]]..},(* "Alpaqua 96S Super Magnet 96-well Plate Rack" *)
      TimeConstraint -> 10000
    ],
    Test["Specify a colony handler through the instrument option:",
      protocol = ExperimentRoboticCellPreparation[
        {
          PickColonies[
            Sample -> Object[Sample, "ExperimentRoboticCellPreparation test colony sample in omnitray" <> $SessionUUID],
            Populations -> Diameter[],
            DestinationMediaType -> SolidMedia
          ]
        },
        Instrument -> Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"] (* QPIX *)
      ];
      requiredCertifications = Download[protocol, RequiredCertifications];
      MemberQ[requiredCertifications,ObjectP[Model[Certification, "id:XnlV5jNAkGmM"]]],
      True,
      Variables :> {protocol, requiredCertifications}
    ]
  },
  SymbolSetUp :> (
    ClearDownload[];
    ClearMemoization[];
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ExpiredSamples];

    Block[{$AllowSystemsProtocols = True},
      Module[
        {
          testBench, plate1, plate2, plate3, tube1, tube2, cover1, cover2, cover3, cover4,
          cover5, containerSampleObjects, cellAndSampleModelObjects, allObjects
        },

        (*Gather all the created objects and models*)
        containerSampleObjects = {
          Object[Container, Bench, "Test bench for ExperimentRoboticCellPreparation Unit Tests" <> $SessionUUID],
          Object[Container, Plate, "ExperimentRoboticCellPreparation test 96-well TC plate 1" <> $SessionUUID],
          Object[Container, Vessel, "ExperimentRoboticCellPreparation test 2mL tube" <> $SessionUUID],
          Object[Container, Vessel, "ExperimentRoboticCellPreparation test 50mL tube" <> $SessionUUID],
          Object[Container, Plate, "ExperimentRoboticCellPreparation test omnitray 1" <> $SessionUUID],
          Object[Container, Plate, "ExperimentRoboticCellPreparation test omnitray 2" <> $SessionUUID],
          Object[Item, Lid, "ExperimentRoboticCellPreparation test cover 1" <> $SessionUUID],
          Object[Item, Lid, "ExperimentRoboticCellPreparation test cover 2" <> $SessionUUID],
          Object[Item, Lid, "ExperimentRoboticCellPreparation test cover 3" <> $SessionUUID],
          Object[Item, Cap, "ExperimentRoboticCellPreparation test cover 4" <> $SessionUUID],
          Object[Item, Cap, "ExperimentRoboticCellPreparation test cover 5" <> $SessionUUID],
          Object[Sample, "ExperimentRoboticCellPreparation test sample in 2mL tube" <> $SessionUUID],
          Object[Sample, "ExperimentRoboticCellPreparation test sample in 50mL tube" <> $SessionUUID],
          Object[Sample, "ExperimentRoboticCellPreparation test cell sample" <> $SessionUUID],
          Object[Sample, "ExperimentRoboticCellPreparation test colony sample in omnitray" <> $SessionUUID],
          Object[Sample, "ExperimentRoboticCellPreparation test suspension sample 2 in omnitray" <> $SessionUUID]
        };

        cellAndSampleModelObjects = {
          Model[Cell, Bacteria, "ExperimentRoboticCellPreparation test cell model 1" <> $SessionUUID],
          Model[Cell, Bacteria, "ExperimentRoboticCellPreparation test cell model 2" <> $SessionUUID],
          Model[Sample, "Experiment test e.coli and LB agar sample Model " <> $SessionUUID],
          Model[Sample, "Experiment test e.coli and LB liquid sample Model " <> $SessionUUID]
        };

        (* Make a test bench *)
        testBench = Upload[
          <|
            Type -> Object[Container, Bench],
            Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
            Name -> "Test bench for ExperimentRoboticCellPreparation Unit Tests" <> $SessionUUID,
            Site -> Link[$Site],
            DeveloperObject -> True
          |>
        ];

        (* Create test containers *)
        {plate1, plate2, plate3, tube1, tube2} = UploadSample[
          {
            Model[Container, Plate, "96-well glass bottom plate"],
            Model[Container, Plate, "Omni Tray Sterile Media Plate"],
            Model[Container, Plate, "Omni Tray Sterile Media Plate"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "50mL Tube"]
          },
          ConstantArray[{"Work Surface", testBench}, 5],
          Name -> {
            "ExperimentRoboticCellPreparation test 96-well TC plate 1" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test omnitray 1" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test omnitray 2" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test 2mL tube" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test 50mL tube" <> $SessionUUID
          }
        ];

        {cover1, cover2, cover3, cover4, cover5} = UploadSample[
          {
            Model[Item, Lid, "Universal Clear Lid"],
            Model[Item, Lid, "Universal Clear Lid"],
            Model[Item, Lid, "Universal Clear Lid"],
            Model[Item, Cap, "2 mL tube cap, standard"],
            Model[Item, Cap, "50 mL tube cap"]
          },
          ConstantArray[{"Work Surface", testBench}, 5],
          Name -> {
            "ExperimentRoboticCellPreparation test cover 1" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test cover 2" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test cover 3" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test cover 4" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test cover 5" <> $SessionUUID
          }
        ];

        (* Create test Model[Cell]'s *)
        UploadBacterialCell[
          {
            "ExperimentRoboticCellPreparation test cell model 1" <> $SessionUUID,
            "ExperimentRoboticCellPreparation test cell model 2" <> $SessionUUID
          },
          Morphology -> Bacilli,
          CellLength -> 2 Micrometer,
          IncompatibleMaterials -> {None},
          CellType -> Bacterial,
          BiosafetyLevel -> "BSL-2",
          MSDSFile -> NotApplicable,
          CultureAdhesion -> SolidMedia,
          PreferredSolidMedia -> Link[Model[Sample, Media, "id:9RdZXvdwAEo6"]], (* Model[Sample, Media, "LB (Solid Agar)"] *)
          PreferredColonyHandlerHeadCassettes -> {
            Link[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli - Deep well"]],
            Link[Model[Part, ColonyHandlerHeadCassette, "96-pin picking head for E. coli"]]
          },
          FluorescentExcitationWavelength -> {
            {452 Nanometer, 505 Nanometer},
            {300 Nanometer, 505 Nanometer}
          },
          FluorescentEmissionWavelength -> {
            {490 Nanometer, 545 Nanometer},
            {300 Nanometer, 400 Nanometer}
          }
        ];

        (* Create test sample models *)
        UploadSampleModel["Experiment test e.coli and LB agar sample Model " <> $SessionUUID,
          Composition -> {
            {15 CFU/Milliliter, Model[Cell, Bacteria, "ExperimentRoboticCellPreparation test cell model 1" <> $SessionUUID]},
            {100 VolumePercent, Model[Molecule, "Water"]},
            {(3 Gram)/(193 Milliliter), Model[Molecule, "Agarose"]}
          },
          Expires -> True,
          ShelfLife -> 2 Week,
          UnsealedShelfLife -> 1 Hour,
          DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
          State -> Solid,
          BiosafetyLevel -> "BSL-1",
          Flammable -> False,
          MSDSFile -> NotApplicable,
          IncompatibleMaterials -> {None},
          Living -> True
        ];

        UploadSampleModel["Experiment test e.coli and LB liquid sample Model " <> $SessionUUID,
          Composition -> {
            {15 CFU/Milliliter, Model[Cell, Bacteria, "ExperimentRoboticCellPreparation test cell model 1" <> $SessionUUID]},
            {100 VolumePercent, Model[Molecule, "Water"]}
          },
          Expires -> True,
          ShelfLife -> 2 Week,
          UnsealedShelfLife -> 1 Hour,
          DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
          State -> Liquid,
          BiosafetyLevel -> "BSL-1",
          Flammable -> False,
          MSDSRequired -> False,
          IncompatibleMaterials -> {None},
          Living -> True
        ];

        (*Make some test sample objects in the test container objects*)
        UploadSample[
          Join[
            ConstantArray[Model[Sample, "HeLa"], 1],
            ConstantArray[Model[Sample, "Milli-Q water"], 2],
            ConstantArray[Model[Sample, "Experiment test e.coli and LB agar sample Model " <> $SessionUUID], 1],
            ConstantArray[Model[Sample, "Experiment test e.coli and LB liquid sample Model " <> $SessionUUID], 1]
          ],
          {
            {"A1", plate1},
            {"A1", tube1},
            {"A1", tube2},
            {"A1", plate2},
            {"A1", plate3}
          },
          Name ->
            {
              "ExperimentRoboticCellPreparation test cell sample" <> $SessionUUID,
              "ExperimentRoboticCellPreparation test sample in 2mL tube" <> $SessionUUID,
              "ExperimentRoboticCellPreparation test sample in 50mL tube" <> $SessionUUID,
              "ExperimentRoboticCellPreparation test colony sample in omnitray" <> $SessionUUID,
              "ExperimentRoboticCellPreparation test suspension sample in omnitray" <> $SessionUUID
            },
          InitialAmount -> {0.5 Milliliter, 0.5 Milliliter, 5 Milliliter, 42 Gram, 20 Milliliter}
        ];

        (* Cover test containers *)
        UploadCover[{plate1, plate2, plate3, tube1, tube2},
          Cover -> {cover1, cover2, cover3, cover4, cover5}
        ];

        (*Gather all the test objects and models created in SymbolSetUp*)
        allObjects = Flatten[{containerSampleObjects, cellAndSampleModelObjects}];

        (*Make all the test objects and models developer objects*)
        Upload[<|Object -> #, DeveloperObject -> True|> &/@ allObjects]
      ]
    ];
  ),

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ExpiredSamples];
    ClearMemoization[];
    Module[{allObjects, existingObjects},
      allObjects = Quiet[Cases[
        Flatten[{
          $CreatedObjects,
          {
            Object[Container, Bench, "Test bench for ExperimentRoboticCellPreparation Unit Tests" <> $SessionUUID],
            Object[Container, Plate, "ExperimentRoboticCellPreparation test 96-well TC plate 1" <> $SessionUUID],
            Object[Container, Vessel, "ExperimentRoboticCellPreparation test 2mL tube" <> $SessionUUID],
            Object[Container, Vessel, "ExperimentRoboticCellPreparation test 50mL tube" <> $SessionUUID],
            Object[Container, Plate, "ExperimentRoboticCellPreparation test omnitray 1" <> $SessionUUID],
            Object[Container, Plate, "ExperimentRoboticCellPreparation test omnitray 2" <> $SessionUUID],
            Object[Item, Lid, "ExperimentRoboticCellPreparation test cover 1" <> $SessionUUID],
            Object[Item, Lid, "ExperimentRoboticCellPreparation test cover 2" <> $SessionUUID],
            Object[Item, Lid, "ExperimentRoboticCellPreparation test cover 3" <> $SessionUUID],
            Object[Item, Cap, "ExperimentRoboticCellPreparation test cover 4" <> $SessionUUID],
            Object[Item, Cap, "ExperimentRoboticCellPreparation test cover 5" <> $SessionUUID],
            Object[Sample, "ExperimentRoboticCellPreparation test sample in 2mL tube" <> $SessionUUID],
            Object[Sample, "ExperimentRoboticCellPreparation test sample in 50mL tube" <> $SessionUUID],
            Object[Sample, "ExperimentRoboticCellPreparation test cell sample" <> $SessionUUID],
            Object[Sample, "ExperimentRoboticCellPreparation test colony sample in omnitray" <> $SessionUUID],
            Object[Sample, "ExperimentRoboticCellPreparation test suspension sample in omnitray" <> $SessionUUID],
            Model[Cell, Bacteria, "ExperimentRoboticCellPreparation test cell model 1" <> $SessionUUID],
            Model[Cell, Bacteria, "ExperimentRoboticCellPreparation test cell model 2" <> $SessionUUID],
            Model[Sample, "Experiment test e.coli and LB agar sample Model " <> $SessionUUID],
            Model[Sample, "Experiment test e.coli and LB liquid sample Model " <> $SessionUUID]
          }
        }], ObjectP[]]];

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]];
      Unset[$CreatedObjects];
    ];
  ),
  Stubs :> {
    $PersonID = Object[User,"Test user for notebook-less test protocols"],
    $AllowPublicObjects = True
  }
];



(* ::Subsubsection::Closed:: *)
(*ExperimentManualCellPreparation*)


DefineTests[
  ExperimentManualCellPreparation,
  {
    (*-- BASIC TESTS --*)
    Example[
      {Basic,"Incubate a single bacterial sample in a flask:"},
      ExperimentManualCellPreparation[
        IncubateCells[
          Sample->Object[Sample,"Test bacteria sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID]
        ]
      ],
      ObjectP[Object[Protocol]]
    ],
    Example[
      {Basic,"Incubate a single mammalian sample in a plate at 37 Celsius:"},
      ExperimentManualCellPreparation[
        IncubateCells[
          Sample->Object[Sample,"Test tissue culture sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
          Temperature->37 Celsius
        ]
      ],
      ObjectP[Object[Protocol]]
    ],
    Example[
      {Basic,"Incubate multiple samples:"},
      ExperimentManualCellPreparation[
        IncubateCells[
          Sample->{
            Object[Sample,"Test bacteria sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID],
            Object[Sample,"Test bacterial sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
            Object[Sample,"Test 2nd bacterial sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID]
          }
        ]
      ],
      ObjectP[Object[Protocol]]
    ],
    Example[
      {Basic,"Flow multiple samples:"},
      ExperimentManualCellPreparation[
        FlowCytometry[
          Sample->{
            Object[Sample,"Test bacteria sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID],
            Object[Sample,"Test tissue culture sample in tall plate (for ExperimentManualCellPreparation)" <> $SessionUUID],
            Object[Sample,"Test water sample (for ExperimentManualCellPreparation)" <> $SessionUUID]
          }
        ]
      ],
      ObjectP[Object[Protocol]]
    ],
    Example[
      {Basic,"Flow a single sample:"},
      ExperimentManualCellPreparation[
        FlowCytometry[
          Sample->{Object[Sample,"Test bacteria sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID]}
        ]
      ],
      ObjectP[Object[Protocol]]
    ],
    Example[
      {Basic,"Generate a protocol based on a single PCR unit operation:"},
      ExperimentManualCellPreparation[
        PCR[
          Sample->{Object[Sample,"Test bacteria sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID]}
        ]
      ],
      ObjectP[Object[Protocol]],
      Messages:>Warning::SampleMustBeMoved
    ],

    (* ImageCells tests *)
    Example[{Basic,"Image a single cell sample with options specified:"},
      ExperimentManualCellPreparation[
        ImageCells[
          Sample->Object[Sample,"Test tissue culture sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
          ObjectiveMagnification->4,
          SamplingNumberOfColumns->2,
          SamplingNumberOfRows->2,
          SamplingPattern->Grid
        ]
      ],
      ObjectP[Object[Protocol]]
    ],
    Example[{Basic,"Image multiple cell samples with options specified:"},
      ExperimentManualCellPreparation[
        ImageCells[
          Sample->{
            {Object[Container,Plate,"Test mammalian plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID]},
            {Object[Container,Plate,"Test mammalian plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID]}
          },
          ObjectiveMagnification->{4,10},
          SamplingNumberOfColumns->2,
          SamplingNumberOfRows->2,
          SamplingPattern->Grid
        ]
      ],
      ObjectP[Object[Protocol]]
    ]
  },
  SymbolSetUp:>(
    ClearMemoization[];
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ExpiredSamples];

    Module[{
      existsFilter,testBench,bacteriaModel,mammalianModel,allObjs,cover1,cover2,cover3,cover4,cover5,cover6,cover7,
      cover8,cover9,cover10,cover11,emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,
      emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,
      discardedBacteriaSample1,bacteriaSample2,bacteriaModelSeveredSample3,mammalianSample1,mammalianSample2,
      bacteriaSample4,bacteriaSample4b,bacteriaSample5,bacteriaSample6,waterSample1,mammalianSample3,mammalianSample4
    },
      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      allObjs={
        Object[Container,Bench,"Test bench (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Vessel,"Test Erlenmeyer flask 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Vessel,"Test Erlenmeyer flask 2 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Vessel,"Test Erlenmeyer flask 3 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Plate,"Test mammalian plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Plate,"Test bacterial plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Plate,"Test bacterial plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Vessel,"Test incubator incompatible container 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Vessel,"Test water sample flask (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Plate,"Test tall mammalian plate (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Container,Plate,"Test short mammalian plate (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Cap,"Test cover 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Cap,"Test cover 2 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Cap,"Test cover 3 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Lid,"Test cover 4 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Lid,"Test cover 5 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Lid,"Test cover 6 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Lid,"Test cover 7 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Cap,"Test cover 8 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Cap,"Test cover 9 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Lid,"Test cover 10 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Item,Lid,"Test cover 11 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test discarded sample (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test bacteria sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test model severed sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample in plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test bacterial sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test 2nd bacterial sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test bacterial sample in plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test bacterial sample in incompatible container 1 (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test water sample (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample in tall plate (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Object[Sample,"Test tissue culture sample in short plate (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Model[Sample,"Bacterial cells Model (for ExperimentManualCellPreparation)" <> $SessionUUID],
        Model[Sample,"Mammalian cells Model (for ExperimentManualCellPreparation)" <> $SessionUUID]
      };
      existsFilter = DatabaseMemberQ[allObjs];

      EraseObject[PickList[allObjs,existsFilter],Force->True,Verbose->False];

      (* Create a test bench *)
      testBench=Upload[<|
        Type->Object[Container,Bench],
        Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
        Name->"Test bench (for ExperimentManualCellPreparation)"<>$SessionUUID,
        StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
        Site->Link[$Site],
        DeveloperObject->True
      |>];

      (* Create some empty containers *)
      {
        emptyContainer1,
        emptyContainer2,
        emptyContainer3,
        emptyContainer4,
        emptyContainer5,
        emptyContainer6,
        emptyContainer7,
        emptyContainer8,
        emptyContainer9,
        emptyContainer10,
        emptyContainer11
      }=Upload[
        {
          <|
            Type->Object[Container,Vessel],
            Model->Link[Model[Container,Vessel,"250mL Erlenmeyer Flask"],Objects],
            Name->"Test Erlenmeyer flask 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Vessel],
            Model->Link[Model[Container,Vessel,"250mL Erlenmeyer Flask"],Objects],
            Name->"Test Erlenmeyer flask 2 (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Vessel],
            Model->Link[Model[Container,Vessel,"1000mL Erlenmeyer Flask"],Objects],
            Name->"Test Erlenmeyer flask 3 (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],Objects],
            Name->"Test mammalian plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],Objects],
            Name->"Test mammalian plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container,Plate,"96-well Greiner Tissue Culture Plate"],Objects],
            Name->"Test bacterial plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "96-well Greiner Tissue Culture Plate"],Objects],
            Name->"Test bacterial plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Vessel],
            Model->Link[Model[Container, Vessel, "15mL Tube"],Objects],
            Name->"Test incubator incompatible container 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Vessel],
            Model->Link[Model[Container,Vessel,"250mL Erlenmeyer Flask"],Objects],
            Name->"Test water sample flask (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
            Name->"Test tall mammalian plate (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>,
          <|
            Type->Object[Container,Plate],
            Model->Link[Model[Container, Plate, "384-well Optical Reaction Plate"],Objects],
            Name->"Test short mammalian plate (for ExperimentManualCellPreparation)" <> $SessionUUID,
            Site->Link[$Site],
            DeveloperObject->True
          |>
        }
      ];

      {cover1,cover2,cover3,cover4,cover5,cover6,cover7,cover8,cover9,cover10,cover11}=UploadSample[
        {
          Model[Item,Cap,"Flask Cap, Breathable 49x30mm"],
          Model[Item,Cap,"Flask Cap, Breathable 49x30mm"],
          Model[Item,Cap,"Flask Cap, Breathable 49x30mm"],
          Model[Item,Lid,"Universal Clear Lid"],
          Model[Item,Lid,"Universal Clear Lid"],
          Model[Item,Lid,"Universal Clear Lid"],
          Model[Item,Lid,"Universal Clear Lid"],
          Model[Item,Cap,"15 mL tube cap"],
          Model[Item,Cap,"Flask Cap, Breathable 49x30mm"],
          Model[Item,Lid,"Universal Clear Lid"],
          Model[Item,Lid,"Universal Clear Lid"]
        },
        ConstantArray[{"Work Surface", testBench}, 11],
        Name -> {
          "Test cover 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 2 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 3 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 4 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 5 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 6 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 7 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 8 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 9 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 10 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test cover 11 (for ExperimentManualCellPreparation)" <> $SessionUUID
        }
      ];
      Upload[<|Object->#,DeveloperObject->True|>]&/@{cover1,cover2,cover3,cover4,cover5,cover6,cover7,cover8,cover9,cover10,cover11};

      (* Create some bacteria and mammalian models *)
      bacteriaModel=UploadSampleModel[
        "Bacterial cells Model (for ExperimentManualCellPreparation)" <> $SessionUUID,
        Composition -> {{95 VolumePercent,Model[Molecule, "Water"]}, {5 VolumePercent,Model[Cell, Bacteria, "E.coli MG1655"]}},
        Expires -> False,
        DefaultStorageCondition ->Model[StorageCondition, "Ambient Storage"],
        State -> Liquid,
        BiosafetyLevel -> "BSL-1",
        Flammable -> False,
        MSDSFile -> NotApplicable,
        IncompatibleMaterials -> {None},
        CellType -> Bacterial,
        CultureAdhesion -> Suspension,
        Living->True
      ];
      mammalianModel=UploadSampleModel["Mammalian cells Model (for ExperimentManualCellPreparation)" <> $SessionUUID,
        Composition -> {{95 VolumePercent,Model[Molecule, "Water"]}, {5 VolumePercent,Model[Cell, Mammalian, "HeLa"]}},
        Expires -> False,
        DefaultStorageCondition ->Model[StorageCondition, "Ambient Storage"],
        State -> Liquid,
        BiosafetyLevel -> "BSL-1",
        Flammable -> False,
        MSDSFile -> NotApplicable,
        IncompatibleMaterials -> {None},
        CellType -> Mammalian,
        CultureAdhesion -> Adherent,
        Living->True
      ];
      (* Create some bacteria and mammalian samples *)
      {
        discardedBacteriaSample1,
        bacteriaSample2,
        bacteriaModelSeveredSample3,
        mammalianSample1,
        mammalianSample2,
        bacteriaSample4,
        bacteriaSample4b,
        bacteriaSample5,
        bacteriaSample6,
        waterSample1,
        mammalianSample3,
        mammalianSample4
      }=ECL`InternalUpload`UploadSample[
        {
          bacteriaModel,
          bacteriaModel,
          bacteriaModel,
          mammalianModel,
          mammalianModel,
          bacteriaModel,
          bacteriaModel,
          bacteriaModel,
          bacteriaModel,
          Model[Sample,"Milli-Q water"],
          mammalianModel,
          mammalianModel
        },
        {
          {"A1",emptyContainer1},
          {"A1",emptyContainer2},
          {"A1",emptyContainer3},
          {"A1",emptyContainer4},
          {"A1",emptyContainer5},
          {"A1",emptyContainer6},
          {"B1",emptyContainer6},
          {"A1",emptyContainer7},
          {"A1",emptyContainer8},
          {"A1",emptyContainer9},
          {"A1",emptyContainer10},
          {"A1",emptyContainer11}

        },
        InitialAmount->{
          1 Milliliter,
          100 Milliliter,
          100 Milliliter,
          100 Microliter,
          100 Microliter,
          100 Microliter,
          100 Microliter,
          100 Microliter,
          10 Milliliter,
          100 Milliliter,
          1.5 Milliliter,
          50 Microliter
        },
        Name->{
          "Test discarded sample (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test bacteria sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test model severed sample in flask (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test tissue culture sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test tissue culture sample in plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test bacterial sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test 2nd bacterial sample in plate 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test bacterial sample in plate 2 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test bacterial sample in incompatible container 1 (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test water sample (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test tissue culture sample in tall plate (for ExperimentManualCellPreparation)" <> $SessionUUID,
          "Test tissue culture sample in short plate (for ExperimentManualCellPreparation)" <> $SessionUUID
        }
      ];

      (* Make all of our samples and models DeveloperObjects, give them their necessary CellTypes/CultureAdhesions, and set the discarded sample to discarded. *)
      Upload[{
        <|Object->discardedBacteriaSample1,CellType->Bacterial,CultureAdhesion->Suspension,Status->Discarded,DeveloperObject->True|>,
        <|Object->bacteriaSample2,CellType->Bacterial,CultureAdhesion->Suspension,DeveloperObject->True|>,
        <|Object->bacteriaModelSeveredSample3,CellType->Bacterial,CultureAdhesion->Suspension,Model->Null,DeveloperObject->True|>,
        <|Object->mammalianSample1,CellType->Mammalian,CultureAdhesion->Adherent,DeveloperObject->True|>,
        <|Object->mammalianSample2,CellType->Mammalian,CultureAdhesion->Adherent,DeveloperObject->True|>,
        <|Object->bacteriaSample4,CellType->Bacterial,CultureAdhesion->Suspension,DeveloperObject->True|>,
        <|Object->bacteriaSample4b,CellType->Bacterial,CultureAdhesion->Suspension,DeveloperObject->True|>,
        <|Object->bacteriaSample5,CellType->Bacterial,CultureAdhesion->Suspension,DeveloperObject->True|>,
        <|Object->bacteriaSample6,CellType->Bacterial,CultureAdhesion->Suspension,DeveloperObject->True|>,
        <|Object->waterSample1,DeveloperObject->True|>,
        <|Object->mammalianSample3,CellType->Mammalian,CultureAdhesion->Adherent,DeveloperObject->True|>,
        <|Object->mammalianSample4,CellType->Mammalian,CultureAdhesion->Adherent,DeveloperObject->True|>,
        <|Object->mammalianModel,DeveloperObject->True|>,
        <|Object->bacteriaModel,DeveloperObject->True|>
      }];

      (* Upload cover to cell culture vessel *)
      UploadCover[
        {emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11},
        Cover->{cover1,cover2,cover3,cover4,cover5,cover6,cover7,cover8,cover9,cover10,cover11}
      ];
    ];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ExpiredSamples];

    EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects]],Force->True,Verbose->False];
  ),
  Stubs :> {
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $EmailEnabled=False
  }
];

(* ::Subsubsection::Closed:: *)
(*UploadUnitOperation*)

DefineTests[
  UploadUnitOperation,
  {
    Test["Absorbance Spectroscopy Test 1:",
      UploadUnitOperation[AbsorbanceSpectroscopy[Sample -> {"absorbance sample 1"}]],
      ObjectP[]
    ],
    Test["Transfer Test 1 (Correction Curve option):",
      UploadUnitOperation[
        Transfer[
          Source -> Model[Sample, StockSolution, "id:n0k9mG8zoW16"],
          Destination -> Model[Container, Vessel, "50mL Tube"],
          Amount -> Quantity[340., "Microliters"],
          CorrectionCurve -> {
            {Quantity[0.`, "Microliters"], Quantity[0.`, "Microliters"]},
            {Quantity[20.`, "Microliters"], Quantity[23.6`, "Microliters"]},
            {Quantity[50.`, "Microliters"], Quantity[55.5`, "Microliters"]},
            {Quantity[100.`, "Microliters"], Quantity[107.2`, "Microliters"]},
            {Quantity[200.`, "Microliters"], Quantity[211.`, "Microliters"]},
            {Quantity[270.`, "Microliters"], Quantity[283.5`, "Microliters"]},
            {Quantity[300.`, "Microliters"], Quantity[313.5`, "Microliters"]},
            {Quantity[500.`, "Microliters"], Quantity[521.7`, "Microliters"]},
            {Quantity[1000.`, "Microliters"], Quantity[1034.`, "Microliters"]}
          }
        ]
      ],
      ObjectP[]
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];


(* ::Subsubsection::Closed:: *)
(*LookupLabeledObject*)

DefineTests[
  LookupLabeledObject,
  {
    Example[{Basic,"Lookup the labeled object from the protocol object:"},
      LookupLabeledObject[Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID], "label1"],
      ObjectP[]
    ],
    Example[{Basic,"Lookup two labeled object from the protocol object:"},
      LookupLabeledObject[Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID], {"label1","label2"}],
      {ObjectP[], ObjectP[]}
    ],
    Example[{Basic,"Returns objects for labels that exist in the protocol even if some of them don't:"},
      LookupLabeledObject[Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID], {"label1","label8"}],
      {ObjectP[], Null},
      Messages:>{Error::LabelNotFound}
    ],
    Example[{Options,Cache,"Accepts Cache option for faster lookup"},
      LookupLabeledObject[Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID], {"label1","label2"}, Cache -> {Download[Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID]]}],
      {ObjectP[], ObjectP[]}
    ],
    Example[{Additional,"Lookup the labeled object from two protocol objects:"},
      LookupLabeledObject[{
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID],
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID]
      }, {"label2","label3"}],
      {ObjectP[]..}
    ],
    Example[{Additional,"Lookup the labeled object from two protocol objects:"},
      LookupLabeledObject[{
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID],
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID]
      }, "label2"],
      ObjectP[]
    ],
    Example[{Additional,"Lookup the labeled object from two protocol objects:"},
      LookupLabeledObject[{
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID],
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID]
      }, {"label2","label3"}],
      {ObjectP[],ObjectP[]}
    ],
    Example[{Options, Script, "If Script is specified, does not error out if some protocols can not contain LabeledObjects:"},
      LookupLabeledObject[{
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID],
        Object[Protocol, HPLC, "LookupLabeledObject test protocol with no labeled objects"<>$SessionUUID]
      },
        {"label1"},
        Script -> True],
      {ObjectP[]}
    ],
    Example[{Messages, "LabeledObjectsDoNotExist","Errors if there is no LabeledObject in the protocol:"},
      LookupLabeledObject[Object[Protocol, HPLC, "LookupLabeledObject test protocol with no labeled objects"<>$SessionUUID], "Stock Solution 1"],
      $Failed,
      Messages:>{Error::LabeledObjectsDoNotExist}
    ],
    Example[{Messages,"LabelNotFound","Errors if some of the labels were not found:"},
      LookupLabeledObject[Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID], {"label1", "label5"}],
      {ObjectP[], Null},
      Messages:>{Error::LabelNotFound}
    ],
    Example[{Messages,"MultipleLabeledObjects","Warns the user if multiple protocols have the same label:"},
      LookupLabeledObject[Object[Notebook, Script, "LookupLabeledObject test script with protocols"<>$SessionUUID], "label1"],
      ObjectP[],
      Messages:>{Warning::MultipleLabeledObjects}
    ],
    Example[{Messages,"NoProtocolsInScript","Errors if script does not have protocols:"},
      LookupLabeledObject[Object[Notebook, Script, "LookupLabeledObject test script without protocols"<>$SessionUUID], "label1"],
      $Failed,
      Messages:>{Error::NoProtocolsInScript}
    ]
  },
  SymbolSetUp :> (
    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = {
        Object[Notebook, Script, "LookupLabeledObject test script with protocols"<>$SessionUUID],
        Object[Notebook, Script, "LookupLabeledObject test script without protocols"<>$SessionUUID],
        Object[Protocol, HPLC, "LookupLabeledObject test protocol with no labeled objects"<>$SessionUUID],
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID],
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID],
        Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 3 with labeled objects"<>$SessionUUID],
        Object[Sample, "LookupLabeledObject test sample 1"<>$SessionUUID],
        Object[Sample, "LookupLabeledObject test sample 2"<>$SessionUUID],
        Object[Sample, "LookupLabeledObject test sample 3"<>$SessionUUID],
        Object[Sample, "LookupLabeledObject test sample 4"<>$SessionUUID]
      };

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];

    $CreatedObjects = {};

    (* Create objects *)
    Upload[{
      <|
        Type->Object[Notebook, Script],
        Name->"LookupLabeledObject test script with protocols"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Notebook, Script],
        Name->"LookupLabeledObject test script without protocols"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Protocol, HPLC],
        Name->"LookupLabeledObject test protocol with no labeled objects"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Protocol, ManualSamplePreparation],
        Name->"LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Protocol, ManualSamplePreparation],
        Name->"LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Protocol, ManualSamplePreparation],
        Name->"LookupLabeledObject test protocol 3 with labeled objects"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Sample],
        Name->"LookupLabeledObject test sample 1"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Sample],
        Name->"LookupLabeledObject test sample 2"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Sample],
        Name->"LookupLabeledObject test sample 3"<>$SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Sample],
        Name->"LookupLabeledObject test sample 4"<>$SessionUUID,
        DeveloperObject->True
      |>
    }];

    (* establish links between objects *)
    Upload[{
      <|
        Object -> Object[Notebook, Script, "LookupLabeledObject test script with protocols"<>$SessionUUID],
        Replace[Protocols] -> Link[{
          Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID],
          Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID],
          Object[Protocol, HPLC, "LookupLabeledObject test protocol with no labeled objects"<>$SessionUUID]
        }, Script]
      |>,
      <|
        Object -> Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID],
        Replace[LabeledObjects] -> {
          {"label1", Link@Object[Sample, "LookupLabeledObject test sample 1"<>$SessionUUID]},
          {"label2", Link@Object[Sample, "LookupLabeledObject test sample 2"<>$SessionUUID]}
        }
      |>,
      <|
        Object -> Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID],
        Replace[LabeledObjects] -> {
          {"label1", Link@Object[Sample, "LookupLabeledObject test sample 4"<>$SessionUUID]},
          {"label3", Link@Object[Sample, "LookupLabeledObject test sample 3"<>$SessionUUID]}
        }
      |>
    }];
  ),
  SymbolTearDown :> (
    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects =Join[
        {
          Object[Notebook, Script, "LookupLabeledObject test script with protocols"<>$SessionUUID],
          Object[Notebook, Script, "LookupLabeledObject test script without protocols"<>$SessionUUID],
          Object[Protocol, HPLC, "LookupLabeledObject test protocol with no labeled objects"<>$SessionUUID],
          Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 1 with labeled objects"<>$SessionUUID],
          Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 2 with labeled objects"<>$SessionUUID],
          Object[Protocol, ManualSamplePreparation, "LookupLabeledObject test protocol 3 with labeled objects"<>$SessionUUID],
          Object[Sample, "LookupLabeledObject test sample 1"<>$SessionUUID],
          Object[Sample, "LookupLabeledObject test sample 2"<>$SessionUUID],
          Object[Sample, "LookupLabeledObject test sample 3"<>$SessionUUID],
          Object[Sample, "LookupLabeledObject test sample 4"<>$SessionUUID]
        },
        $CreatedObjects];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];
    Unset[$CreatedObjects];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $ddPCRNoMultiplex = False,
    $SearchMaxDateCreated=(Now-1Day)
  }
];


(* ::Subsubsection::Closed:: *)
(*ExperimentSamplePreparation*)

DefineTests[ExperimentSamplePreparation,
  {
    (* -- Message Tests -- *)
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentSamplePreparation[{Incubate[Sample->Object[Sample, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentSamplePreparation[{Incubate[Sample->Object[Container, Vessel, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentSamplePreparation[{Incubate[Sample->Object[Sample, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentSamplePreparation[{Incubate[Sample->Object[Container, Vessel, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentSamplePreparation[{Incubate[Sample->sampleID]}, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentSamplePreparation[{Incubate[Sample->containerID]}, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[
      {Messages, "InvalidUnitOperationMethods", "If given a unit operation method (wrapper head) that isn't supported, throw an error:"},
      ExperimentSamplePreparation[{Test[Incubate[Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID]]]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationMethods,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationOptions", "Throws a message if there are invalid options inside of the given unit operations:"},
      ExperimentSamplePreparation[{
        ManualSamplePreparation[
          Incubate[
            Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
            Time->5 Minute
          ],
          Incubate[
            Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
            Taco->"Yum!"
          ]
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationHeads", "If given a unit operation type isn't allowed, throw an error:"},
      ExperimentSamplePreparation[{Test[<||>]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationHeads,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationRequiredOptions", "If a unit operation doesn't have its required options filled out, throw an error:"},
      ExperimentSamplePreparation[{Incubate[]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationOptions", "If given a unit operation with an invalid option, throw an error:"},
      ExperimentSamplePreparation[{
        Incubate[
          Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
          Taco->"Yum!"
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationValues", "If given a unit operation with an invalid option value, throw an error:"},
      ExperimentSamplePreparation[{
        Incubate[
          Sample->100
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationValues,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationRequiredOptions", "If given a unit operation with a missing required option, throw an error::"},
      ExperimentSamplePreparation[{
        Incubate[
          Time->5 Minute
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Test["ExperimentSamplePreparation is able to look ahead and choose a primitive grouping that works for all primitives 1:",
      ExperimentSamplePreparation[{
        LabelContainer[Label->"container 1",Container->Model[Container,Vessel,"2mL Tube"]],
        LabelContainer[Label->"container 2",Container->Model[Container,Vessel,"50mL Tube"]],
        Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"container 1",Amount->100 Microliter],
        Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"container 1",Amount->100 Microliter],
        Mix[Sample->"container 1",MixVolume->100 Microliter],
        Wait[Duration->5 Minute],
        Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"container 1",Amount->100 Microliter],
        Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"container 2",Amount->2 Milliliter],

        (* This should force it to go to robotic *)
        Transfer[Source->"container 2",Destination->"container 1",Amount->50 Microliter,Preparation->Robotic]
      }],
      ObjectP[Object[Protocol, RoboticSamplePreparation]],
      TimeConstraint -> 10000
    ],
    Test["ExperimentSamplePreparation is able to look ahead and choose a primitive grouping that works for all primitives 2:",
      ExperimentSamplePreparation[{
        LabelContainer[Label->"container 1",Container->Model[Container,Vessel,"2mL Tube"]],
        LabelContainer[Label->"container 2",Container->Model[Container,Vessel,"50mL Tube"]],
        Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"container 1",Amount->100 Microliter],
        Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"container 1",Amount->100 Microliter],
        Mix[Sample->"container 1",MixVolume->100 Microliter],
        Wait[Duration->5 Minute],
        Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"container 1",Amount->100 Microliter],
        Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"container 2",Amount->2 Milliliter],

        (* This should force it to go to manual *)
        Transfer[Source->"container 1",Destination->Model[Container,Vessel,"20L Polypropylene Carboy"],Amount->All]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]],
      TimeConstraint -> 10000
    ],
    Test["Setting Composition option to LabelSample works correctly:",
      Module[{simulation},
        simulation=ExperimentSamplePreparation[
          {
            LabelContainer[Label -> "SL001 IDT tube", Container->Model[Container, Vessel, "2mL Tube"]],

            Transfer[
              Source -> Model[Sample, StockSolution, "Tris Buffer pH~7"],
              Destination -> "SL001 IDT tube",
              Amount -> 850 Microliter,
              MaxSourceEquilibrationTime -> 5 Minute,
              DestinationTemperature -> Ambient,
              MaxDestinationEquilibrationTime -> 5 Minute,
              SamplesOutStorageCondition -> Freezer,
              MeasureWeight -> False,
              MeasureVolume -> False,
              DestinationLabel -> "SL001 IDT sample"
            ],

            LabelSample[Sample -> "SL001 IDT sample", Composition -> {{100 VolumePercent, Model[Molecule,"Water"]}}]
          },
          Output->Simulation
        ];

        Download[Lookup[Lookup[simulation[[1]], Labels], "SL001 IDT sample"], Composition, Simulation->simulation]
      ],
      {{Quantity[100, IndependentUnit["VolumePercent"]], ObjectP[Model[Molecule, "id:vXl9j57PmP5D"]], _DateObject}},
      TimeConstraint -> 10000
    ],
    Test["Setting AliquotSampleLabel works correctly:",
      Quiet[
        ExperimentSamplePreparation[{
          LabelSample[Label -> "SL001 IDT tube", Sample -> Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID]],

          Transfer[
            Source -> Model[Sample, StockSolution, "Tris Buffer pH~7"],
            Destination -> "SL001 IDT tube",
            Amount -> 850 Microliter,
            MaxSourceEquilibrationTime -> 5 Minute,
            DestinationTemperature -> Ambient,
            MaxDestinationEquilibrationTime -> 5 Minute,
            SamplesOutStorageCondition -> Freezer,
            MeasureWeight -> False,
            MeasureVolume -> False
          ],

          Mix[
            Sample -> "SL001 IDT tube",
            Time -> 1 Minute,
            AliquotSampleLabel -> "SL001 8uM",
            AssayVolume -> 1.5 Milliliter,
            Aliquot -> True,
            MeasureWeight -> False,
            MeasureVolume -> False
          ],

          Aliquot[
            Source -> {{"SL001 8uM"}, {"SL001 8uM"}, {"SL001 8uM"}, {"SL001 8uM"}},
            Amount -> {{20 Microliter}, {10 Microliter}, {5 Microliter}, {2.5 Microliter}},
            ContainerOut -> {
              Model[Container, Vessel, "2mL Tube"],
              Model[Container, Vessel, "2mL Tube"],
              Model[Container, Vessel, "2mL Tube"],
              Model[Container, Vessel, "2mL Tube"]
            },
            MeasureWeight -> False,
            ImageSample -> False
          ]
        }],
        {Warning::InstrumentPrecision}
      ],
      ObjectP[],
      TimeConstraint -> 10000
    ],
    Test["Optimization isn't bothered by the manual specification of a ManualSamplePreparation[...] grouping (previous the PrimitiveMethodIndex internal option was messing things up):",
      ExperimentSamplePreparation[
        {
          ManualSamplePreparation[
            LabelContainer[
              Label -> {
                "Duplex 1",
                "Duplex 2"
              },
              Container -> Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]
            ],
            Transfer[
              Source -> {
                Model[Sample, "Milli-Q water"],
                Model[Sample, "Milli-Q water"]
              },
              Destination -> {
                "Duplex 1",
                "Duplex 1"
              },
              Amount -> {700 Microliter, 700 Microliter}
            ],
            Transfer[
              Source -> {
                Model[Sample, "Milli-Q water"],
                Model[Sample, "Milli-Q water"]
              },
              Destination -> {
                "Duplex 2",
                "Duplex 2"
              },
              Amount -> {700 Microliter, 700 Microliter}
            ],
            Mix[
              Sample -> {
                "Duplex 1",
                "Duplex 2"
              },
              MixType -> Pipette,
              NumberOfMixes -> 5
            ],
            Incubate[
              Sample -> {
                "Duplex 1",
                "Duplex 2"
              },
              Time -> 5 Minute,
              Temperature -> 65 Celsius,
              AnnealingTime -> 10 Minute
            ]
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualSamplePreparation]],
      TimeConstraint -> 10000
    ],
    Test["Calling the function with Output->Inputs returns the optimized (NOT calculated) unit operations inside of method headers. This is important so that the command builder front end doesn't think that all options in the optimized primitives are specified:",
      ExperimentSamplePreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 1 Milliliter
          ]
        },
        Output->Input
      ],
      {RoboticSamplePreparation[Verbatim[Transfer][_Association?(Length[#]==3&)]]}
    ],
    Test["Calling ExperimentSamplePreparationInputs returns fully calculated unit operations:",
      ExperimentSamplePreparationInputs[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 1 Milliliter
          ]
        }
      ],
      {RoboticSamplePreparation[Verbatim[Transfer][_Association?(Length[#]>3&)]]}
    ],
    Test["ExperimentSamplePreparation can handle very malformed inputs:",
      ValidExperimentSamplePreparationQ[
        {
          ManualSamplePreparation[
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination
            ]
          ]
        },
        Verbose -> Failures
      ],
      False,
      Messages:>{
        Error::InvalidUnitOperationValues,
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Test["Test ResolvedOptionsJSON:",
      Block[{$Notebook = Object[LaboratoryNotebook, "id:01G6nvwalvo7"]},
        ECL`AppHelpers`ResolvedOptionsJSON[
          ExperimentSamplePreparation,
          {{
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> Model[Container, Vessel, "50mL Tube"],
              Amount -> 5 Milliliter
            ],
            ManualSamplePreparation[
              Transfer[
                Source -> Model[Sample, "Milli-Q water"],
                Destination -> Model[Container, Vessel, "50mL Tube"],
                Amount -> 5 Milliliter
              ]
            ],
            RoboticSamplePreparation[
              Transfer[
                Source -> Model[Sample, "Milli-Q water"],
                Destination -> Model[Container, Vessel, "50mL Tube"],
                Amount -> 100 Microliter
              ]
            ]
          }},
          {}
        ]
      ],
      _String
    ],
    Test["Don't return method wrappers if PreviewFinalizedUnitOperations -> False:",
      ExperimentSamplePreparation[
        {
          Transfer[
            Source -> {Model[Sample, "Milli-Q water"]},
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 20 Milliliter
          ]
        },
        {
          PreviewFinalizedUnitOperations -> False,
          Output -> Input
        }
      ],
      {_Transfer}
    ],
    Test["Return method wrappers if PreviewFinalizedUnitOperations -> True:",
      ExperimentSamplePreparation[
        {
          Transfer[
            Source -> {Model[Sample, "Milli-Q water"]},
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 20 Milliliter
          ]
        },
        {
          PreviewFinalizedUnitOperations -> True,
          Output -> Input
        }
      ],
      {_ManualSamplePreparation|_RoboticSamplePreparation}
    ],
    Test["Sets AutomaticDisposal->False in the resource for the labeled sample:",
      Module[{protocol},
        protocol=ExperimentSamplePreparation[{
          LabelSample[Label -> "best sample ever", Sample -> Model[Sample, "Milli-Q water"], Amount -> 1 Milliliter],
          Transfer[Source -> "best sample ever", Amount -> 0.5 Milliliter, Destination -> Model[Container, Vessel, "2mL Tube"]]
        }];
        Quiet[Download[protocol, RequiredResources[[All,1]][AutomaticDisposal]], Download::FieldDoesntExist]
      ],
      (* Just our water resource should have this set *)
      {False,$Failed,$Failed}
    ],
    Test["Can use ExperimentSP to init a new CountLiquidParticles experiment:",
      ExperimentSamplePreparation[
        {
          LabelContainer[
            Label -> "Sample Vessel 1",
            Container -> Model[Container,Vessel,"50mL Tube"]
          ],
          Transfer[
            Source -> Model[Sample, "Methanol"],
            Amount -> 40 Milliliter,
            Destination -> "Sample Vessel 1",
            DestinationLabel -> "CLP Sample 1"
          ],
          LabelContainer[
            Label -> "Sample Vessel 2",
            Container -> Model[Container,Vessel,"50mL Tube"]
          ],
          Transfer[
            Source -> Model[Sample, "Methanol"],
            Amount -> 40 Milliliter,
            Destination -> "Sample Vessel 2",
            DestinationLabel -> "CLP Sample 2"
          ],
          CountLiquidParticles[
            Sample->{
              "CLP Sample 1",
              "CLP Sample 2"
            }
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualSamplePreparation]],
      TimeConstraint -> 10000
    ],
    Test["Add Cover unit operations into each group of RSP and make sure we do not repeat the simulation of labeled containers:",
      Module[{output,allUOs},
        output=ExperimentSamplePreparationInputs[{
          RoboticSamplePreparation[
            LabelContainer[Label -> "plate 1", Container->Model[Container,Plate,"96-well 2mL Deep Well Plate"]]
          ],
          RoboticSamplePreparation[
            LabelContainer[Label -> "plate 2", Container->Model[Container, Plate, "96-well UV-Star Plate"]],
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> "plate 2",
              Amount -> 200 Microliter
            ]
          ]
        }];
        allUOs=Flatten[List @@ # & /@ output];
        {Length[allUOs],Head/@allUOs}
      ],
      (* Just our water resource should have this set *)
      {5,{LabelContainer,Cover,LabelContainer,Transfer,Cover}}
    ],
    Test["Within one robotic protocol, automatically add an Uncover unit operation if a plate is covered in earlier unit operation but required in a later transfer:",
      Module[{output,allUOs},
        output=ExperimentSamplePreparationInputs[{
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], DestinationWell -> "A1", DestinationLabel -> "water 1", Amount -> 100 Microliter, Preparation -> Robotic],
          Cover[Sample -> "water 1", Preparation -> Robotic],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "water 1", Amount -> 100 Microliter, Preparation -> Robotic],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "water 1", DestinationWell -> "A1", Amount -> 100 Microliter, Preparation -> Manual],
          Cover[Sample -> "water 1", Preparation -> Manual],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "water 1", DestinationWell -> "A1", Amount -> 100 Microliter, Preparation -> Robotic]
        }];
        allUOs=Flatten[List @@ # & /@ output];
        {Head/@output,Length/@output,Head/@allUOs}
      ],
      {
        {RoboticSamplePreparation, ManualSamplePreparation, RoboticSamplePreparation},
        {5, 2, 1},
        {Transfer, Cover, Uncover, Transfer, Cover, Transfer, Cover, Transfer}
      },
      Messages:>{
        Warning::UncoverUnitOperationAdded
      },
      SetUp :> (ClearMemoization[]),
      TearDown :> (ClearMemoization[])
    ],

    Example[{Options,SampleLabel,"FlashChromatography Unit Operation can accept a container label and can label the sample inside it:"},
      protocol=ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->3 Milliliter
        ],
        FlashChromatography[
          Sample->"my container",
          SampleLabel->"my sample"
        ]
      }];
      Download[protocol,CalculatedUnitOperations[[3]][{SampleLabel,SampleContainerLabel,FlowRate}]],
      {
        {"my sample"},
        {"my container"},
        {FlowRateP}
      },
      Variables:>{protocol}
    ],
    Test["The UnresolvedUnitOperationOptions and ResolvedUnitOperationOptions fields are populated in the OutputUnitOperations for Manual:",
      protocol=ExperimentSamplePreparation[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->3 Milliliter
        ],
        FlashChromatography[
          Sample->"my container",
          SampleLabel->"my sample"
        ]
      }];
      Download[protocol, OutputUnitOperations[{UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions}]],
      {{{___Rule}, {___Rule}}..},
      Variables:>{protocol}
    ],
    Test["The UnresolvedUnitOperationOptions and ResolvedUnitOperationOptions fields are populated in the OutputUnitOperations for Robotic:",
      protocol=ExperimentSamplePreparation[{
        LabelSample[Label -> "best sample ever", Sample -> Model[Sample, "Milli-Q water"], Amount -> 1 Milliliter],
        Transfer[Source -> "best sample ever", Amount -> 0.5 Milliliter, Destination -> Model[Container, Vessel, "2mL Tube"]]
      }];
      Download[protocol, OutputUnitOperations[{UnresolvedUnitOperationOptions, ResolvedUnitOperationOptions}]],
      {{{___Rule}, {___Rule}}..},
      Variables:>{protocol}
    ],
    Test["Can use ExperimentSamplePreparation in global simulation mode:",
      Block[
        {
          $Simulation=True,
          $CurrentSimulation=Simulation[]
        },
        ExperimentSamplePreparation[
          {
            Transfer[
              <|
                Source -> {Model[Sample, "id:L8kPEjNLDDBP"]},
                Destination -> { Model[Container, Vessel, "50mL Tube"]},
                Amount -> {Quantity[1, "Grams"]}
              |>
            ]
          }
        ]
      ],
      ObjectP[Object[Protocol, ManualSamplePreparation]],
      TimeConstraint -> 10000
    ],
    Test["When generating a script as subprotocol, carry over all resolved labels:",
      Module[{script,scriptString},
        script=ExperimentSamplePreparation[
          {
            LabelContainer[
              Label -> {"tube", "plate"},
              Container -> {Model[Container, Vessel, "2mL Tube"], Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
            ],
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> "tube",
              Amount -> 1 Milliliter,
              Preparation -> Manual
            ],
            Transfer[
              Source -> "tube",
              Amount -> 900 Microliter,
              Destination -> "plate",
              DestinationWell -> "A1",
              Preparation -> Robotic
            ]
          },
          ParentProtocol->Object[Protocol, HPLC, "Test HPLC Protocol for ExperimentSamplePreparation" <> $SessionUUID]
        ];
        scriptString=ImportCloudFile[script[TemplateNotebookFile],Format -> "Text"];
        (* Both MSP and RSP should have DestinationLabel option *)
        StringCount[scriptString, "DestinationLabel"]
      ],
      2
    ],
    Test["Defaults to manual transfer if All amount is requested:",
      ExperimentSamplePreparation[{
        Transfer[
          Source->Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
          Destination->Model[Container, Vessel, "2mL Tube"],
          Amount->All
        ]
      }],
      ObjectP[Object[Protocol, ManualSamplePreparation]]
    ],
    Test["If All amount robotic transfer is requested, convert the amount to volume and split if larger than 970 uL:",
      Module[
        {protocol,transferUO},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[
            Source->Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Destination->Model[Container, Vessel, "2mL Tube"],
            Amount->All
          ]
        }];
        transferUO=protocol[OutputUnitOperations][[1]];
        {
          Download[transferUO,SourceLink],
          Download[transferUO,AmountVariableUnit],
          Download[transferUO,DestinationLink],
          SameQ@@Download[transferUO,DestinationLabel]
        }
      ],
      {
        {ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]]},
        {EqualP[500Microliter],EqualP[500Microliter]},
        {ObjectP[Model[Container, Vessel, "2mL Tube"]],ObjectP[Model[Container, Vessel, "2mL Tube"]]},
        True
      }
    ],
    Test["If All amount robotic transfer is requested, consider the sample volume transferred into this sample earlier in the protocol (1):",
      Module[
        {protocol,transferUO},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Amount->200Microliter
          ],
          Transfer[
            Source->Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Destination->Model[Container, Vessel, "2mL Tube"],
            Amount->All
          ]
        }];
        transferUO=protocol[OutputUnitOperations][[1]];
        {
          Download[transferUO,SourceLink],
          Download[transferUO,AmountVariableUnit],
          Download[transferUO,DestinationLink]
        }
      ],
      {
        {ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],ObjectP[Download[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],Object]],ObjectP[Download[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],Object]]},
        {EqualP[200Microliter],EqualP[600Microliter],EqualP[600Microliter]},
        {ObjectP[Download[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],Object]],ObjectP[Model[Container, Vessel, "2mL Tube"]],ObjectP[Model[Container, Vessel, "2mL Tube"]]}
      }
    ],
    Test["If All amount robotic transfer is requested, consider the samples transferred into this sample earlier in the protocol (2):",
      Module[
        {protocol,transferUOs},
        protocol=ExperimentRoboticSamplePreparation[{
          LabelContainer[Label -> "my tube", Container -> Model[Container, Vessel, "2mL Tube"]],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "my tube", Amount -> 800 Microliter],
          Wait[Duration->1Minute],
          Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "my tube", Amount -> 500 Microliter],
          Transfer[Source -> "my tube", Destination -> Model[Container, Vessel, "50mL Tube"], Amount -> All]
        }];
        transferUOs=Cases[protocol[OutputUnitOperations],ObjectP[Object[UnitOperation,Transfer]]];
        Download[transferUOs,AmountVariableUnit]
      ],
      {
        {EqualP[800Microliter]},
        {EqualP[500Microliter],EqualP[650Microliter],EqualP[650Microliter]}
      }
    ],
    Test["If All amount robotic transfer is requested, consider the sample volumes transferred into this sample earlier in the protocol (3):",
      Module[
        {protocol,transferUOs},
        protocol=ExperimentRoboticSamplePreparation[{
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Amount->200Microliter,
            DestinationLabel->"my sample 1"
          ],
          (* This is supposed to go into Well A2 *)
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Amount->444Microliter,
            DestinationLabel->"my sample 2"
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->"my sample 2",
            Amount->222Microliter
          ],
          (* This is supposed to go into Well A3 *)
          Transfer[
            Source->"my sample 1",
            Destination->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Amount->All
          ],
          Transfer[
            Source->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            SourceWell->"A2",
            Destination->Model[Container, Vessel, "2mL Tube"],
            Amount->All
          ],
          Transfer[
            Source->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            SourceWell->"A3",
            Destination->Model[Container, Vessel, "2mL Tube"],
            Amount->All
          ]
        }];
        transferUOs=Cases[protocol[OutputUnitOperations],ObjectP[Object[UnitOperation,Transfer]]];
        {
          Download[transferUOs,SourceLink],
          Download[transferUOs,SourceWell],
          Download[transferUOs,AmountVariableUnit],
          Download[transferUOs,DestinationLink],
          Download[transferUOs,DestinationWell]
        }
      ],
      (* Because the destination label of the second transfer is used later, all the transfers are split into two UOs  *)
      {
        {
          {
            ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]
          },
          {
            ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]]
          }
        },
        {{"A1", "A1"}, {"A1", "A1", "A1", "A2", "A3", "A3"}},
        {
          {EqualP[200Microliter],EqualP[444Microliter]},
          {EqualP[222Microliter],EqualP[600Microliter],EqualP[600Microliter],EqualP[666Microliter],EqualP[600Microliter],EqualP[600Microliter]}
        },
        {
          {
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]]
          },
          {
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
            ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
            ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]],
            ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]],
            ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]]
          }
        },
        {{"A1", "A2"}, {"A2", "A3", "A3", "A1", "A1", "A1"}}
      }
    ],
    Test["If All amount robotic transfer is requested, consider the sample volumes transferred into this sample earlier in the protocol (4):",
      Module[
        {protocol,transferUO},
        protocol=ExperimentRoboticSamplePreparation[{
          (* This is supposed to go into Well A2 *)
          Transfer[
            Source->Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Destination->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Amount->200Microliter
          ],
          (* A1 - 800 uL; A2 - 200 uL *)
          (* This is supposed to go into Well A3. Amount -> 800 uL *)
          Transfer[
            Source->Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Destination->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Amount->All
          ],
          (* A1 - Empty; A2 - 200 uL; A3 - 800 uL *)
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            DestinationWell->"A3",
            Amount->600Microliter
          ],
          (* A1 - Empty; A2 - 200 uL; A3 - 1400 uL *)
          Transfer[
            Source->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            SourceWell->"A3",
            Destination->Model[Container, Vessel, "2mL Tube"],
            Amount->300Microliter
          ],
          (* A1 - Empty; A2 - 200 uL; A3 - 1100 uL *)
          (* This is supposed to go into Well A4. Amount -> 1100 uL, split into 2*550uL *)
          Transfer[
            Source->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            SourceWell->"A3",
            Destination->Object[Container, Plate, "Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
            Amount->All
          ]
        }];
        transferUO=protocol[OutputUnitOperations][[1]];
        {
          Download[transferUO,SourceLink],
          Download[transferUO,SourceWell],
          Download[transferUO,AmountVariableUnit],
          Download[transferUO,DestinationLink],
          Download[transferUO,DestinationWell]
        }
      ],
      (* Because the destination label of the second transfer is used later, all the transfers are split into two UOs  *)
      {
        {
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
          ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]]
        },
        {"A1", "A1", "A1", "A3", "A3", "A3"},
        {EqualP[200Microliter],EqualP[800Microliter],EqualP[600Microliter],EqualP[300Microliter],EqualP[550Microliter],EqualP[550Microliter]},
        {
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
          ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]],
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]],
          ObjectP[Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID]]
        },
        {"A2", "A3", "A3", "A1", "A4", "A4"}
      }
    ],
    Test["If All amount robotic transfer is requested, consider the sample volumes transferred into an index container model earlier in the protocol (5):",
      Module[
        {protocol,transferUO},
        protocol=ExperimentRoboticSamplePreparation[{
          (* This goes to A1 of plate 1 *)
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination-> {1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            Amount->400Microliter
          ],
          (* This goes to A2 of plate 1 *)
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination-> {1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            Amount->600Microliter
          ],
          (* This goes to A1 of plate 2 *)
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination-> {2,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            Amount->800Microliter
          ],
          (* This should go to A3 of plate 1 *)
          Transfer[
            Source->{1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            Destination-> {1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            SourceWell->"A1",
            Amount->222Microliter
          ],
          (* This should go to A4 of plate 1; Amount -> 178 uL *)
          Transfer[
            Source->{1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            Destination-> {1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            SourceWell->"A1",
            Amount->All
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Destination-> {1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            DestinationWell->"A4",
            Amount->1200Microliter
          ],
          (* This should go to A5 of plate 1; Amount -> 1378 uL - 689 uL *2 *)
          Transfer[
            Source->{1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            SourceWell->"A4",
            Destination-> {1,Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
            Amount->All
          ]
        }];
        transferUO=FirstCase[protocol[OutputUnitOperations],ObjectP[Object[UnitOperation,Transfer]]];
        {
          Download[transferUO,SourceLink],
          Download[transferUO,SourceWell],
          Download[transferUO,AmountVariableUnit],
          Download[transferUO,DestinationLink],
          Download[transferUO,DestinationWell],
          Download[transferUO,DestinationContainerLabel],
          protocol[LabeledObjects]
        }
      ],
      {
        {
          ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
          ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
          ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
          ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]],
          ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]],
          ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
          ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
          ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]],
          ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]
        },
        {"A1", "A1", "A1", "A1", "A1", "A1", "A1", "A4", "A4"},
        {EqualP[400Microliter],EqualP[600Microliter],EqualP[800Microliter],EqualP[222Microliter],EqualP[178Microliter],EqualP[600Microliter],EqualP[600Microliter],EqualP[689Microliter],EqualP[689Microliter]},
        ConstantArray[ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]],9],
        {"A1", "A2", "A1", "A3", "A4", "A4", "A4", "A5", "A5"},
        {
          "transfer destination container 1",
          "transfer destination container 1",
          "transfer destination container 2",
          "transfer destination container 1",
          "transfer destination container 1",
          "transfer destination container 1",
          "transfer destination container 1",
          "transfer destination container 1",
          "transfer destination container 1"
        },
        {___,{"transfer destination container 1",ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]}, {"transfer destination container 2", ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]},___}
      }
    ]
  },
  SymbolSetUp:>Module[{allObjects,existsFilter,tube1,tube2,tube3,tube4,tube5,plate6,plate7,plate8,
    sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8},

    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ExpiredSamples];

    (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
    allObjects= {
      Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 2 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 3 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 5 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96-well UV Star Plate for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96-well AlphaPlate for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 2 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 3 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 4 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test powder sample 5 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test AlphaScreen sample 8 in AlphaPlate for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Protocol, HPLC, "Test HPLC Protocol for ExperimentSamplePreparation" <> $SessionUUID]
    };

    (* Erase any objects that we failed to erase in the last unit test *)
    existsFilter=DatabaseMemberQ[allObjects];

    Quiet[EraseObject[
      PickList[
        allObjects,
        existsFilter
      ],
      Force->True,
      Verbose->False
    ]];

    (* Create some empty containers. *)
    {tube1,tube2,tube3,tube4,tube5,plate6,plate7,plate8}=Upload[{
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 1 for ExperimentSamplePreparation" <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 2 for ExperimentSamplePreparation" <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 3 for ExperimentSamplePreparation" <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 4 for ExperimentSamplePreparation" <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 5 for ExperimentSamplePreparation" <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Plate],
        Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name->"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Plate],
        Model->Link[Model[Container, Plate, "96-well UV-Star Plate"],Objects],
        Name->"Test 96-well UV Star Plate for ExperimentSamplePreparation" <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Plate],
        Model->Link[Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],Objects],
        Name->"Test 96-well AlphaPlate for ExperimentSamplePreparation" <> $SessionUUID,
        Site -> Link[$Site],
        DeveloperObject->True
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8}=UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        Model[Sample, "Milli-Q water"],
        Model[Sample, "Milli-Q water"],
        Model[Sample, "Milli-Q water"],
        Model[Sample, "Milli-Q water"],
        Model[Sample, "id:vXl9j5qEn66B"], (* "Sodium carbonate, anhydrous" *)
        Model[Sample, "Milli-Q water"],
        Model[Sample,StockSolution,"0.2M FITC"],
        Model[Sample,StockSolution,"0.2M FITC"]
      },
      {
        {"A1",tube1},
        {"A1",tube2},
        {"A1",tube3},
        {"A1",tube4},
        {"A1",tube5},
        {"A1",plate6},
        {"A1",plate7},
        {"A1",plate8}
      },
      Name->{
        "Test water sample 1 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID,
        "Test water sample 2 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID,
        "Test water sample 3 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID,
        "Test water sample 4 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID,
        "Test powder sample 5 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID,
        "Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID,
        "Test plate reader sample 7 in UV Star plate for ExperimentSamplePreparation" <> $SessionUUID,
        "Test AlphaScreen sample 8 in AlphaPlate for ExperimentSamplePreparation" <> $SessionUUID
      },
      InitialAmount->{
        25 Milliliter,
        10 Milliliter,
        10 Milliliter,
        10 Milliliter,
        10 Gram,
        1 Milliliter,
        200 Microliter,
        200 Microliter
      },
      SampleHandling->{
        Liquid,
        Liquid,
        Liquid,
        Liquid,
        Powder,
        Liquid,
        Liquid,
        Liquid
      }
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[{
      <|Object->sample1,Status->Available,DeveloperObject->True|>,
      <|Object->sample2,Status->Available,DeveloperObject->True|>,
      <|Object->sample3,Status->Available,DeveloperObject->True|>,
      <|Object->sample4,Status->Available,DeveloperObject->True|>,
      <|Object->sample5,Status->Available,DeveloperObject->True|>,
      <|Object->sample6,Status->Available,DeveloperObject->True|>,
      <|Object->sample7,Status->Available,DeveloperObject->True|>,
      <|Object->sample8,Status->Available,DeveloperObject->True|>
    }];

    Upload[<|Type->Object[Protocol,HPLC],Name->"Test HPLC Protocol for ExperimentSamplePreparation" <> $SessionUUID|>];
  ],
  SymbolTearDown:>Module[{allObjects,existsFilter},
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ExpiredSamples];
    (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
    allObjects= {
      Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 2 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 3 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 5 for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96-well UV Star Plate for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96-well AlphaPlate for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 2 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 3 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 4 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test powder sample 5 in 50mL Tube for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 6 in 96 DWP for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Sample,"Test AlphaScreen sample 8 in AlphaPlate for ExperimentSamplePreparation" <> $SessionUUID],
      Object[Protocol, HPLC, "Test HPLC Protocol for ExperimentSamplePreparation" <> $SessionUUID]
    };

    (* Erase any objects that we failed to erase in the last unit test *)
    existsFilter=DatabaseMemberQ[allObjects];

    Quiet[EraseObject[
      PickList[
        allObjects,
        existsFilter
      ],
      Force->True,
      Verbose->False
    ]];

  ],
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];


(* ::Subsubsection::Closed:: *)
(*ExperimentCellPreparation*)

DefineTests[ExperimentCellPreparation,
  {
    (* -- Message Tests -- *)
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentCellPreparation[{Incubate[Sample->Object[Sample, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentCellPreparation[{Incubate[Sample->Object[Container, Vessel, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentCellPreparation[{Incubate[Sample->Object[Sample, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[
      {Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentCellPreparation[{Incubate[Sample->Object[Container, Vessel, "this object does not exist"<>CreateUUID[]]]}],
      $Failed,
      Messages:>{
        Download::ObjectDoesNotExist
      }
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentCellPreparation[{Incubate[Sample->sampleID]}, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          Model[Container,Vessel,"50mL Tube"],
          {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        containerID = Lookup[First[containerPackets], Object];
        samplePackets = UploadSample[
          Model[Sample, "Milli-Q water"],
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentCellPreparation[{Incubate[Sample->containerID]}, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[
      {Messages, "InvalidUnitOperationMethods", "If given a unit operation method (wrapper head) that isn't supported, throw an error:"},
      ExperimentCellPreparation[{Test[Incubate[Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID]]]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationMethods,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationOptions", "Throws a message if there are invalid options inside of the given unit operations:"},
      ExperimentCellPreparation[{
        ManualSamplePreparation[
          Incubate[
            Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
            Time->5 Minute
          ],
          Incubate[
            Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
            Taco->"Yum!"
          ]
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationHeads", "If given a unit operation type isn't allowed, throw an error:"},
      ExperimentCellPreparation[{Test[<||>]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationHeads,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationRequiredOptions", "If a unit operation doesn't have its required options filled out, throw an error:"},
      ExperimentCellPreparation[{Incubate[]}],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationOptions", "If given a unit operation with an invalid option, throw an error:"},
      ExperimentCellPreparation[{
        Incubate[
          Sample->Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
          Taco->"Yum!"
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationOptions,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationValues", "If given a unit operation with an invalid option value, throw an error:"},
      ExperimentCellPreparation[{
        Incubate[
          Sample->100
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationValues,
        Error::InvalidInput
      }
    ],
    Example[
      {Messages, "InvalidUnitOperationRequiredOptions", "If given a unit operation with a missing required option, throw an error::"},
      ExperimentCellPreparation[{
        Incubate[
          Time->5 Minute
        ]
      }],
      $Failed,
      Messages:>{
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Test["Optimization isn't bothered by the manual specification of a ManualSamplePreparation[...] grouping (previous the PrimitiveMethodIndex internal option was messing things up):",
      ExperimentCellPreparation[
        {
          ManualCellPreparation[
            LabelContainer[
              Label -> {
                "Duplex 1",
                "Duplex 2"
              },
              Container -> Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]
            ],
            Transfer[
              Source -> {
                Model[Sample, "Milli-Q water"],
                Model[Sample, "Milli-Q water"]
              },
              Destination -> {
                "Duplex 1",
                "Duplex 1"
              },
              Amount -> {700 Microliter, 700 Microliter}
            ],
            Transfer[
              Source -> {
                Model[Sample, "Milli-Q water"],
                Model[Sample, "Milli-Q water"]
              },
              Destination -> {
                "Duplex 2",
                "Duplex 2"
              },
              Amount -> {700 Microliter, 700 Microliter}
            ],
            Mix[
              Sample -> {
                "Duplex 1",
                "Duplex 2"
              },
              MixType -> Pipette,
              NumberOfMixes -> 5
            ],
            Incubate[
              Sample -> {
                "Duplex 1",
                "Duplex 2"
              },
              Time -> 5 Minute,
              Temperature -> 65 Celsius,
              AnnealingTime -> 10 Minute
            ]
          ]
        }
      ],
      ObjectP[Object[Protocol, ManualCellPreparation]],
      TimeConstraint -> 10000
    ],
    Test["Calling the function with Output->Inputs returns the optimized (NOT calculated) unit operations inside of method headers. This is important so that the command builder front end doesn't think that all options in the optimized primitives are specified:",
      ExperimentCellPreparation[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 1 Milliliter
          ]
        },
        Output->Input
      ],
      {RoboticCellPreparation[Verbatim[Transfer][_Association?(Length[#]==3&)]]}
    ],
    Test["Calling ExperimentCellPreparationInputs returns fully calculated unit operations:",
      ExperimentCellPreparationInputs[
        {
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 1 Milliliter
          ]
        }
      ],
      {RoboticCellPreparation[Verbatim[Transfer][_Association?(Length[#]>3&)]]}
    ],
    Test["ExperimentCellPreparation can handle very malformed inputs:",
      ValidExperimentCellPreparationQ[
        {
          ManualSamplePreparation[
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination
            ]
          ]
        },
        Verbose -> Failures
      ],
      False,
      Messages:>{
        Error::InvalidUnitOperationValues,
        Error::InvalidUnitOperationRequiredOptions,
        Error::InvalidInput
      }
    ],
    Test["Test ResolvedOptionsJSON:",
      Block[{$Notebook = Object[LaboratoryNotebook, "id:01G6nvwalvo7"]},
        ECL`AppHelpers`ResolvedOptionsJSON[
          ExperimentCellPreparation,
          {{
            Transfer[
              Source -> Model[Sample, "Milli-Q water"],
              Destination -> Model[Container, Vessel, "50mL Tube"],
              Amount -> 100 Microliter
            ],
            ManualSamplePreparation[
              Transfer[
                Source -> Model[Sample, "Milli-Q water"],
                Destination -> Model[Container, Vessel, "50mL Tube"],
                Amount -> 100 Microliter
              ]
            ],
            RoboticSamplePreparation[
              Transfer[
                Source -> Model[Sample, "Milli-Q water"],
                Destination -> Model[Container, Vessel, "50mL Tube"],
                Amount -> 100 Microliter
              ]
            ]
          }},
          {}
        ]
      ],
      _String
    ],
    Test["Don't return method wrappers if PreviewFinalizedUnitOperations -> False:",
      ExperimentCellPreparation[
        {
          Transfer[
            Source -> {Model[Sample, "Milli-Q water"]},
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 20 Milliliter
          ]
        },
        {
          PreviewFinalizedUnitOperations -> False,
          Output -> Input
        }
      ],
      {_Transfer}
    ],
    Test["Return method wrappers if PreviewFinalizedUnitOperations -> True:",
      ExperimentCellPreparation[
        {
          Transfer[
            Source -> {Model[Sample, "Milli-Q water"]},
            Destination -> Model[Container, Vessel, "50mL Tube"],
            Amount -> 20 Milliliter
          ]
        },
        {
          PreviewFinalizedUnitOperations -> True,
          Output -> Input
        }
      ],
      {_ManualCellPreparation|_RoboticCellPreparation}
    ],
    Test["Sets AutomaticDisposal->False in the resource for the labeled sample:",
      Module[{protocol},
        protocol=ExperimentCellPreparation[{
          LabelSample[Label -> "best sample ever", Sample -> Model[Sample, "Milli-Q water"], Amount -> 1 Milliliter],
          Transfer[Source -> "best sample ever", Amount -> 0.5 Milliliter, Destination -> Model[Container, Vessel, "2mL Tube"]]
        }];
        Quiet[Download[protocol, RequiredResources[[All,1]][AutomaticDisposal]], Download::FieldDoesntExist]
      ],
      (* Just our water resource should have this set *)
      {False,$Failed,$Failed}
    ],
    Test["Automatically resolves ImageSample, MeasureWeight, and MeasureVolume to True if no samples are Sterile -> True or Living -> True:",
      Module[{protocol},
        protocol=ExperimentCellPreparation[{
          Transfer[
            Source -> Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
            Destination -> Model[Container, Vessel, "2mL Tube"],
            Amount -> 100 Microliter
          ]
        }];
        Download[protocol, {ImageSample, MeasureWeight, MeasureVolume}]
      ],
      {True, True, True}
    ],
    Test["Automatically resolves ImageSample, MeasureWeight, and MeasureVolume to False if any samples are Sterile -> True or Living -> True:",
      Module[{protocol},
        protocol=ExperimentCellPreparation[{
          Transfer[
            Source -> Object[Sample,"Test cell sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
            Destination -> Model[Container, Vessel, "2mL Tube"],
            Amount -> 100 Microliter
          ]
        }];
        Download[protocol, {ImageSample, MeasureWeight, MeasureVolume}]
      ],
      {False, False, False}
    ]
  },
  SymbolSetUp:>Module[{allObjects,existsFilter,tube1,tube2,tube3,tube4,tube5,tube6,plate6,plate7,plate8,
    sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,cellsample1},

    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ExpiredSamples];

    (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
    allObjects= {
      Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentCellPreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 2 for ExperimentCellPreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 3 for ExperimentCellPreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentCellPreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 5 for ExperimentCellPreparation" <> $SessionUUID],
      Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentCellPreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96 DWP for ExperimentCellPreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96-well UV Star Plate for ExperimentCellPreparation" <> $SessionUUID],
      Object[Container,Plate,"Test 96-well AlphaPlate for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 2 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 3 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 4 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test powder sample 5 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test water sample 6 in 96 DWP for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test AlphaScreen sample 8 in AlphaPlate for ExperimentCellPreparation" <> $SessionUUID],
      Object[Sample,"Test cell sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID]
    };

    (* Erase any objects that we failed to erase in the last unit test *)
    existsFilter=DatabaseMemberQ[allObjects];

    Quiet[EraseObject[
      PickList[
        allObjects,
        existsFilter
      ],
      Force->True,
      Verbose->False
    ]];

    (* Create some empty containers. *)
    {tube1,tube2,tube3,tube4,tube5,tube6,plate6,plate7,plate8}=Upload[{
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 1 for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 2 for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 3 for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 4 for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 5 for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Vessel],
        Model->Link[Model[Container, Vessel, "50mL Tube"],Objects],
        Name->"Test 50mL Tube 6 for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Plate],
        Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],
        Name->"Test 96 DWP for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Plate],
        Model->Link[Model[Container, Plate, "96-well UV-Star Plate"],Objects],
        Name->"Test 96-well UV Star Plate for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>,
      <|
        Type->Object[Container,Plate],
        Model->Link[Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],Objects],
        Name->"Test 96-well AlphaPlate for ExperimentCellPreparation" <> $SessionUUID,
        DeveloperObject->True
      |>
    }];

    (* Create some samples for testing purposes *)
    {sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,cellsample1}=UploadSample[
      (* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
      {
        Model[Sample, "Milli-Q water"],
        Model[Sample, "Milli-Q water"],
        Model[Sample, "Milli-Q water"],
        Model[Sample, "Milli-Q water"],
        Model[Sample, "id:vXl9j5qEn66B"], (* "Sodium carbonate, anhydrous" *)
        Model[Sample, "Milli-Q water"],
        Model[Sample,StockSolution,"0.2M FITC"],
        Model[Sample,StockSolution,"0.2M FITC"],
        Model[Sample, "E.coli MG1655"]
      },
      {
        {"A1",tube1},
        {"A1",tube2},
        {"A1",tube3},
        {"A1",tube4},
        {"A1",tube5},
        {"A1",plate6},
        {"A1",plate7},
        {"A1",plate8},
        {"A1",tube6}
      },
      Name->{
        "Test water sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID,
        "Test water sample 2 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID,
        "Test water sample 3 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID,
        "Test water sample 4 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID,
        "Test powder sample 5 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID,
        "Test water sample 6 in 96 DWP for ExperimentCellPreparation" <> $SessionUUID,
        "Test plate reader sample 7 in UV Star plate for ExperimentCellPreparation" <> $SessionUUID,
        "Test AlphaScreen sample 8 in AlphaPlate for ExperimentCellPreparation" <> $SessionUUID,
        "Test cell sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID
      },
      InitialAmount->{
        25 Milliliter,
        10 Milliliter,
        10 Milliliter,
        10 Milliliter,
        10 Gram,
        1 Milliliter,
        200 Microliter,
        200 Microliter,
        10 Milliliter
      },
      SampleHandling->{
        Liquid,
        Liquid,
        Liquid,
        Liquid,
        Powder,
        Liquid,
        Liquid,
        Liquid,
        Liquid
      }
    ];

    (* Make some changes to our samples for testing purposes *)
    Upload[{
      <|Object->sample1,Status->Available,DeveloperObject->True|>,
      <|Object->sample2,Status->Available,DeveloperObject->True|>,
      <|Object->sample3,Status->Available,DeveloperObject->True|>,
      <|Object->sample4,Status->Available,DeveloperObject->True|>,
      <|Object->sample5,Status->Available,DeveloperObject->True|>,
      <|Object->sample6,Status->Available,DeveloperObject->True|>,
      <|Object->sample7,Status->Available,DeveloperObject->True|>,
      <|Object->sample8,Status->Available,DeveloperObject->True|>,
      <|Object->cellsample1,Status->Available,DeveloperObject->True|>
    }];
  ],
  SymbolTearDown:>{
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ExpiredSamples];

    Module[
      {allObjects, existsFilter},
      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects = {
        Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentCellPreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 2 for ExperimentCellPreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 3 for ExperimentCellPreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentCellPreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 5 for ExperimentCellPreparation" <> $SessionUUID],
        Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentCellPreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96 DWP for ExperimentCellPreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96-well UV Star Plate for ExperimentCellPreparation" <> $SessionUUID],
        Object[Container,Plate,"Test 96-well AlphaPlate for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 2 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 3 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 4 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test powder sample 5 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test water sample 6 in 96 DWP for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test plate reader sample 7 in UV Star plate for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test AlphaScreen sample 8 in AlphaPlate for ExperimentCellPreparation" <> $SessionUUID],
        Object[Sample,"Test cell sample 1 in 50mL Tube for ExperimentCellPreparation" <> $SessionUUID]
      };

      (* Erase any objects that we failed to erase in the last unit test *)
      existsFilter=DatabaseMemberQ[allObjects];

      Quiet[EraseObject[
        PickList[
          allObjects,
          existsFilter
        ],
        Force->True,
        Verbose->False
      ]];
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  }
];


(* ::Subsubsection::Closed:: *)
(*Experiment`Private`SimulateResources*)

DefineTests[
  ExperimentOptions,
  {
    Example[{Basic,"Returns a script's options given unit operations:"},
      ExperimentOptions[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      _Grid
    ],
    Example[{Additional,"Returns a script's options given different unit operations for MSP:"},
      ExperimentOptions[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount->0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut->"aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      _Grid
    ],
    Example[{Additional,"Returns a script's options given other unit oerations:"},
      ExperimentOptions[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      _Grid
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ExperimentInputs*)

DefineTests[
  ExperimentInputs,
  {
    Example[{Basic,"Returns a script's inputs given unit operations:"},
      ExperimentInputs[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      {ManualSamplePreparation[_LabelContainer, _Transfer]}
    ],
    Example[{Additional,"Returns a script's inputs given different unit operations for MSP:"},
      ExperimentInputs[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount->0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut->"aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      {ManualSamplePreparation[_LabelContainer, _Transfer, _Mix, _Filter, _Mix]}
    ],
    Example[{Additional,"Returns a script's inputs given other unit operations:"},
      ExperimentInputs[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      {ManualSamplePreparation[_LabelContainer, _Transfer]}
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ExperimentSamplePreparationInputs*)

DefineTests[
  ExperimentSamplePreparationInputs,
  {
    Example[{Basic,"Returns a script's inputs given unit operations:"},
      ExperimentSamplePreparationInputs[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      {ManualSamplePreparation[_LabelContainer, _Transfer]}
    ],
    Example[{Additional,"Returns a script's inputs given different unit operations for MSP:"},
      ExperimentSamplePreparationInputs[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount->0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut->"aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      {ManualSamplePreparation[_LabelContainer, _Transfer, _Mix, _Filter, _Mix]}
    ],
    Example[{Additional,"Returns a script's inputs given other unit operations:"},
      ExperimentSamplePreparationInputs[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      {ManualSamplePreparation[_LabelContainer, _Transfer]}
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ExperimentManualSamplePreparationInputs*)

DefineTests[
  ExperimentManualSamplePreparationInputs,
  {
    Example[{Basic,"Returns a script's inputs given unit operations:"},
      ExperimentManualSamplePreparationInputs[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      {_LabelContainer, _Transfer}
    ],
    Example[{Additional,"Returns a script's inputs given different unit operations for MSP:"},
      ExperimentManualSamplePreparationInputs[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount->0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut->"aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      {_LabelContainer, _Transfer, _Mix, _Filter, _Mix}
    ],
    Example[{Additional,"Returns a script's inputs given other unit operations:"},
      ExperimentManualSamplePreparationInputs[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      {_LabelContainer, _Transfer}
    ]
  },
  HardwareConfiguration->HighRAM,
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ExperimentRoboticSamplePreparationInputs*)

DefineTests[
  ExperimentRoboticSamplePreparationInputs,
  {
    Example[{Basic, "Returns a robotic protocol's inputs given unit operations:"},
      ExperimentRoboticSamplePreparationInputs[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 1 Milliliter
        ]
      }],
      {_LabelContainer, _Transfer}
    ],
    Example[{Additional, "Returns a robotic protocol's inputs given different unit operations:"},
      ExperimentRoboticSamplePreparationInputs[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Mix[
          Sample -> {"stock solution"},
          MixVolume -> 0.5 Milliliter,
          NumberOfMixes -> 10
        ],
        Filter[
          Sample -> "stock solution",
          Volume -> 0.3 Milliliter,
          Filter -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"],
          FiltrateContainerOut -> "aliquot 1"
        ],
        Mix[
          Sample -> {"aliquot 1"},
          MixVolume -> 0.2 Milliliter,
          NumberOfMixes -> 10
        ]
      }],
      {_LabelContainer, _Transfer, _Mix, _Filter, _Mix, _Cover}
    ],
    Example[{Additional,"Returns a robotic protocol's inputs given unit operations:"},
      ExperimentRoboticSamplePreparationInputs[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {1 Milliliter, 1 Milliliter, 1 Milliliter}
        ]
      }],
      {_LabelContainer, _Transfer}
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];

(* ::Subsubsection::Closed:: *)
(*ExperimentCellPreparationInputs*)

DefineTests[
  ExperimentCellPreparationInputs,
  {
    Example[{Basic, "Returns a script's inputs given unit operations:"},
      ExperimentCellPreparationInputs[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 10 Milliliter
        ]
      }],
      {ManualCellPreparation[_LabelContainer, _Transfer]}
    ],
    Example[{Additional, "Returns a script's inputs given different unit operations for cell prep:"},
      ExperimentCellPreparationInputs[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount -> 0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut -> "aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      {ManualCellPreparation[_LabelContainer, _Transfer, _Mix, _Filter, _Mix]}
    ],
    Example[{Additional, "Returns a script's inputs given other unit operations:"},
      ExperimentCellPreparationInputs[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"my container 1", "my container 2", "my container 3"},
          Amount -> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      {ManualCellPreparation[_LabelContainer, _Transfer]}
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];



(* ::Subsubsection::Closed:: *)
(*ExperimentManualCellPreparationInputs*)

DefineTests[
  ExperimentManualCellPreparationInputs,
  {
    Example[{Basic, "Returns a script's inputs given unit operations:"},
      ExperimentManualCellPreparationInputs[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 10 Milliliter
        ]
      }],
      {_LabelContainer, _Transfer}
    ],
    Example[{Additional, "Returns a script's inputs given different unit operations for MSP:"},
      ExperimentManualCellPreparationInputs[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount -> 0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut -> "aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      {_LabelContainer, _Transfer, _Mix, _Filter, _Mix}
    ],
    Example[{Additional, "Returns a script's inputs given other unit operations:"},
      ExperimentManualCellPreparationInputs[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"my container 1", "my container 2", "my container 3"},
          Amount -> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      {_LabelContainer, _Transfer}
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ExperimentRoboticCellPreparationInputs*)

DefineTests[
  ExperimentRoboticCellPreparationInputs,
  {
    Example[{Basic, "Returns a robotic protocol's inputs given unit operations:"},
      ExperimentRoboticCellPreparationInputs[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 1 Milliliter
        ]
      }],
      {_LabelContainer, _Transfer}
    ],
    Example[{Additional, "Returns a robotic protocol's inputs given different unit operations:"},
      ExperimentRoboticCellPreparationInputs[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Mix[
          Sample -> {"stock solution"},
          MixVolume -> 0.5 Milliliter,
          NumberOfMixes -> 10
        ]
      }],
      {_LabelContainer, _Transfer, _Mix}
    ],
    Example[{Additional,"Returns a robotic protocol's inputs given unit operations:"},
      ExperimentRoboticCellPreparationInputs[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {1 Milliliter, 1 Milliliter, 1 Milliliter}
        ]
      }],
      {_LabelContainer, _Transfer}
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];



(* ::Subsubsection::Closed:: *)
(*ExperimentSamplePreparationOptions*)

DefineTests[
  ExperimentSamplePreparationOptions,
  {
    Example[{Basic,"Returns a script's inputs given unit operations:"},
      ExperimentSamplePreparationOptions[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      _Grid
    ],
    Example[{Options,OutputFormat,"OutputFormat indicates if the output should be a list or a table:"},
      ExperimentSamplePreparationOptions[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }, OutputFormat -> List],
      {__Rule}
    ],
    Example[{Additional,"Returns a script's inputs given different unit operations for MSP:"},
      ExperimentSamplePreparationOptions[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount->0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut->"aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      _Grid
    ],
    Example[{Additional,"Returns a script's inputs given other unit operations:"},
      ExperimentSamplePreparationOptions[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      _Grid
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];



(* ::Subsubsection::Closed:: *)
(*ExperimentManualSamplePreparationOptions*)

DefineTests[
  ExperimentManualSamplePreparationOptions,
  {
    Example[{Basic,"Returns a script's inputs given unit operations:"},
      ExperimentManualSamplePreparationOptions[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      _Grid
    ],
    Example[{Options,OutputFormat,"OutputFormat indicates if the output should be a list or a table:"},
      ExperimentManualSamplePreparationOptions[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }, OutputFormat -> List],
      {__Rule}
    ],
    Example[{Additional,"Returns a script's inputs given different unit operations for MSP:"},
      ExperimentManualSamplePreparationOptions[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount->0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut->"aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      _Grid
    ],
    Example[{Additional,"Returns a script's inputs given other unit operations:"},
      ExperimentManualSamplePreparationOptions[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      _Grid
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ExperimentRoboticSamplePreparationOptions*)

DefineTests[
  ExperimentRoboticSamplePreparationOptions,
  {
    Example[{Basic, "Returns a robotic protocol's inputs given unit operations:"},
      ExperimentRoboticSamplePreparationOptions[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 1 Milliliter
        ]
      }],
      _Grid
    ],
    Example[{Options, OutputFormat, "OutputFormat indicates if the output should be a list or a table:"},
      ExperimentRoboticSamplePreparationOptions[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 1 Milliliter
        ]
      }, OutputFormat -> List],
      {__Rule}
    ],
    Example[{Additional, "Returns a robotic protocol's inputs given different unit operations:"},
      ExperimentRoboticSamplePreparationOptions[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Mix[
          Sample -> {"stock solution"},
          MixVolume -> 0.5 Milliliter,
          NumberOfMixes -> 10
        ],
        Filter[
          Sample -> "stock solution",
          Volume -> 0.3 Milliliter,
          Filter -> Model[Container, Plate, Filter, "Plate Filter, PES, 0.22um, 0.3mL"],
          FiltrateContainerOut -> "aliquot 1"
        ],
        Mix[
          Sample -> {"aliquot 1"},
          MixVolume -> 0.2 Milliliter,
          NumberOfMixes -> 10
        ]
      }],
      _Grid
    ],
    Example[{Additional, "Returns a robotic protocol's inputs given unit operations:"},
      ExperimentRoboticSamplePreparationOptions[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"my container 1", "my container 2", "my container 3"},
          Amount -> {1 Milliliter, 1 Milliliter, 1 Milliliter}
        ]
      }],
      _Grid
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>{
    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::SampleMustBeMoved];
    Off[Warning::DeprecatedProduct];
    Off[Warning::ExpiredSamples];
  },
  SymbolTearDown:>{
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    On[Warning::ExpiredSamples];
    On[Warning::SampleMustBeMoved];
  }
];


(* ::Subsubsection::Closed:: *)
(*ExperimentCellPreparationOptions*)

DefineTests[
  ExperimentCellPreparationOptions,
  {
    Example[{Basic, "Returns a script's inputs given unit operations:"},
      ExperimentCellPreparationOptions[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 10 Milliliter
        ]
      }],
      _Grid
    ],
    Example[{Additional, "Returns a script's inputs given different unit operations for cell prep:"},
      ExperimentCellPreparationOptions[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount -> 0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut -> "aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      _Grid
    ],
    Example[{Additional, "Returns a script's inputs given other unit operations:"},
      ExperimentCellPreparationOptions[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"my container 1", "my container 2", "my container 3"},
          Amount -> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      _Grid
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];



(* ::Subsubsection::Closed:: *)
(*ExperimentManualCellPreparationOptions*)

DefineTests[
  ExperimentManualCellPreparationOptions,
  {
    Example[{Basic, "Returns a script's inputs given unit operations:"},
      ExperimentManualCellPreparationOptions[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 10 Milliliter
        ]
      }],
      _Grid
    ],
    Example[{Additional, "Returns a script's inputs given different unit operations for MSP:"},
      ExperimentManualCellPreparationOptions[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Gram}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Gram}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ],
        Filter[
          Sample -> "stock solution",
          AliquotAmount -> 0.7 Milliliter,
          Filter -> Model[Container, Vessel, Filter, "Centrifuge Filter, PTFE, 0.45um, 0.75mL filter"],
          FiltrateContainerOut -> "aliquot 1"
        ],
        Mix[
          Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      _Grid
    ],
    Example[{Additional, "Returns a script's inputs given other unit operations:"},
      ExperimentManualCellPreparationOptions[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> {"my container 1", "my container 2", "my container 3"},
          Amount -> {3 Milliliter, 3 Milliliter, 3 Milliliter}
        ]
      }],
      _Grid
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ExperimentRoboticCellPreparationOptions*)

DefineTests[
  ExperimentRoboticCellPreparationOptions,
  {
    Example[{Basic, "Returns a robotic protocol's inputs given unit operations:"},
      ExperimentRoboticCellPreparationOptions[{
        LabelContainer[
          Label -> "my container",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> Model[Sample, "Milli-Q water"],
          Destination -> "my container",
          Amount -> 1 Milliliter
        ]
      }],
      _Grid
    ],
    Example[{Additional, "Returns a robotic protocol's inputs given different unit operations:"},
      ExperimentRoboticCellPreparationOptions[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        LabelContainer[Label -> "aliquot 1",
          Container -> Model[Container, Vessel, "2mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Mix[
          Sample -> {"stock solution"},
          MixVolume -> 0.5 Milliliter,
          NumberOfMixes -> 10
        ]
      }],
      _Grid
    ],
    Example[{Additional,"Returns a robotic protocol's inputs given unit operations:"},
      ExperimentRoboticCellPreparationOptions[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]},
          Restricted -> {True, False, True}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {1 Milliliter, 1 Milliliter, 1 Milliliter}
        ]
      }],
      _Grid
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentQ*)

DefineTests[
  ValidExperimentQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      True
    ],
    Example[{Basic,"Return False if experiment can't run without issues:"},
      ValidExperimentQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      }],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },Verbose->Failures],
      False
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentSamplePreparationQ*)

DefineTests[
  ValidExperimentSamplePreparationQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      True
    ],
    Example[{Basic,"Return False if experiment can't run without issues:"},
      ValidExperimentSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      }],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },Verbose->Failures],
      False
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


DefineTests[
  ExperimentSamplePreparationPreview,
  {
    Example[{Basic,"Returns an experiment's options given unit operations:"},
      ExperimentSamplePreparationPreview[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      Null
    ],
    Example[{Additional,"Returns an experiment's options given unit operations for MSP:"},
      ExperimentSamplePreparationPreview[{
        LabelContainer[Label -> "stock solution",
          Container -> Model[Container, Vessel, "50mL Tube"]
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {1 Milliliter}
        ],
        Transfer[
          Source -> {Model[Sample, "Milli-Q water"]},
          Destination -> {"stock solution"},
          Amount -> {25 Milliliter}
        ],
        Mix[Sample -> {"stock solution"},
          MixType -> Roll,
          Time -> (4 * Hour)
        ]
      }],
      Null
    ],
    Example[{Additional,"Returns an experiment's options given robotic unit operations:"},
      ExperimentSamplePreparationPreview[{
        LabelContainer[
          Label -> {"my container 1", "my container 2", "my container 3"},
          Container -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "50mL Tube"]}
        ],
        Transfer[
          Source-> Model[Sample, "Milli-Q water"],
          Destination-> {"my container 1", "my container 2", "my container 3"},
          Amount-> {1 Milliliter, 1 Milliliter, 1 Milliliter}
        ],
        Preparation->Robotic
      }],
      Null
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentManualSamplePreparationQ*)

DefineTests[
  ValidExperimentManualSamplePreparationQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentManualSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      True
    ],
    Example[{Basic,"Return False if experiment can't run without issues:"},
      ValidExperimentManualSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      }],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentManualSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentManualSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },Verbose->Failures],
      False
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentRoboticSamplePreparationQ*)

DefineTests[
  ValidExperimentRoboticSamplePreparationQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentRoboticSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      True
    ],
    Example[{Basic,"Return False if experiment can't run without issues:"},
      ValidExperimentRoboticSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      }],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentRoboticSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentRoboticSamplePreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },Verbose->Failures],
      False
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentCellPreparationQ*)

DefineTests[
  ValidExperimentCellPreparationQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      True
    ],
    Example[{Basic,"Return False if experiment can't run without issues:"},
      ValidExperimentCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      }],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },Verbose->Failures],
      False
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentManualCellPreparationQ*)

DefineTests[
  ValidExperimentManualCellPreparationQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentManualCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      True
    ],
    Example[{Basic,"Return False if experiment can't run without issues:"},
      ValidExperimentManualCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      }],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentManualCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentManualCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },Verbose->Failures],
      False
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentRoboticCellPreparationQ*)

DefineTests[
  ValidExperimentRoboticCellPreparationQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentRoboticCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->10 Milliliter
        ]
      }],
      BooleanP
    ],
    Example[{Basic,"Return False if experiment can't run without issues:"},
      ValidExperimentRoboticCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      }],
      BooleanP
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentRoboticCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentRoboticCellPreparationQ[{
        LabelContainer[
          Label->"my container",
          Container->Model[Container,Vessel,"50mL Tube"]
        ],
        Transfer[
          Source->Model[Sample,"Milli-Q water"],
          Destination->"my container",
          Amount->100 Milliliter
        ]
      },Verbose->Failures],
      BooleanP
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];

DefineTests[ValidateUnitOperationsJSON,
  {
    Test["Correctly validates valid primitives:",
      ValidateUnitOperationsJSON[{
        ManualSamplePreparation[
          LabelContainer[
            Label -> "Salt tube",
            Container -> Model[Container, Vessel, "2mL Tube"]
          ],
          Transfer[
            Source -> {
              Model[Sample, "Sodium Chloride-Certified ACS"],
              Model[Sample, "Milli-Q water"]
            },
            Destination -> {"Salt tube", "Salt tube"},
            Amount -> {50 Milligram, 1 Milliliter}
          ],
          Mix[
            Sample -> "Salt tube",
            MixUntilDissolved -> True,
            Time -> 5 Minute
          ],
          Transfer[
            Source -> {"Salt tube", "Salt tube", "Salt tube", "Salt tube"},
            Destination -> {
              {"A1", "Aliquot plate"},
              {"B1", "Aliquot plate"},
              {"C1", "Aliquot plate"},
              {"D1", "Aliquot plate"}
            },
            Amount -> {50 Microliter, 50 Microliter, 50 Microliter, 50 Microliter}
          ]
        ]
      }],
      "{\"Messages\":[\"\",\"\",\"\",\"\"]}"
    ]
  },
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"],
    $SearchMaxDateCreated=(Now-1Day)
  },
  SymbolSetUp:>(
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
  )
];
