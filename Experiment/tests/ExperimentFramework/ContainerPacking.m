(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(* PackContainers *)

DefineTests[PackContainers,
  {
    Example[{Basic, "Wells are packed column-wise (i.e., in the order A1, B1, C1, D1 ...):"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Automatic, Automatic, Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {25 Celsius, 25 Celsius, 25 Celsius, 25 Celsius},
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]}
        },
        {"A1", "B1", "C1", "D1"}
      }
    ],

    Example[{Basic, "Select container models and group samples into the containers based on a chosen experimental parameter:"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Automatic, Automatic, Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {25 Celsius, 25 Celsius, 37 Celsius, 25 Celsius},
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {2, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]}
        },
        {"A1", "B1", "A1", "C1"}
      }
    ],

    Example[{Basic, "Group samples into specified container models based on a chosen experimental parameter:"},
      PackContainers[
        (* unresolved containers *)
        {Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Plate, "id:L8kPEjkmLbvW"]},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {25 Celsius, 37 Celsius, 25 Celsius, 37 Celsius},
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {2, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {2, Model[Container, Plate, "id:L8kPEjkmLbvW"]}
        },
        {"A1", "A1", "B1", "B1"}
      }
    ],

    Example[{Basic, "Group samples into containers based on multiple chosen experimental parameters:"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Automatic, Automatic, Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {
          {25 Celsius, 25 Celsius, 37 Celsius, 25 Celsius},
          {Shake, Shake, Pipette, Pipette},
          {300 RPM, 300 RPM, Null, Null}
        },
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {2, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {3, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]}
        },
        {"A1", "B1", "A1", "A1"}
      }
    ],

    Example[{Basic, "A container can be packed with samples while also placing a sample in a specified well within the same container:"},
      PackContainers[
        (* unresolved containers *)
        {
          Model[Container, Plate, "id:L8kPEjkmLbvW"],
          Model[Container, Plate, "id:L8kPEjkmLbvW"],
          Model[Container, Plate, "id:L8kPEjkmLbvW"],
          {"B1", {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}}
        },
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, False},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {25 Celsius, 25 Celsius, 25 Celsius, 25 Celsius}
      ],
      {
        {
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}
        },
        {"A1", "C1", "D1", "B1"}
      }
    ],

    Example[{Basic, "Mixed container input patterns are supported and do not adversely affect packing:"},
      PackContainers[
        (* unresolved containers *)
        {
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {"D1", {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}},
          Model[Container, Plate, "id:L8kPEjkmLbvW"],
          {"B1", {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}}
        },
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, False, True, False},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {25 Celsius, 25 Celsius, 25 Celsius, 25 Celsius}
      ],
      {
        {
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}
        },
        {"A1", "D1", "C1", "B1"}
      }
    ],

    Example[{Basic, "Specific container objects can be packed:"},
      PackContainers[
        (* unresolved containers *)
        {
          Object[Container, Plate, "Test 96 well DWP 0 for PackContainers " <> $SessionUUID],
          Object[Container, Plate, "Test 96 well DWP 0 for PackContainers " <> $SessionUUID],
          Object[Container, Plate, "Test 96 well DWP 1 for PackContainers " <> $SessionUUID],
          Object[Container, Plate, "Test 96 well DWP 1 for PackContainers " <> $SessionUUID]
        },
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {25 Celsius, 25 Celsius, 25 Celsius, 25 Celsius}
      ],
      {
        {
          Object[Container, Plate, "Test 96 well DWP 0 for PackContainers " <> $SessionUUID],
          Object[Container, Plate, "Test 96 well DWP 0 for PackContainers " <> $SessionUUID],
          Object[Container, Plate, "Test 96 well DWP 1 for PackContainers " <> $SessionUUID],
          Object[Container, Plate, "Test 96 well DWP 1 for PackContainers " <> $SessionUUID]
        },
        {"A1", "B1", "A1", "B1"}
      }
    ],

    Example[{Basic, "If containers are set to Null and PackPlateQ is False, all of the containers and wells resolve to Null:"},
      PackContainers[
        (* unresolved containers *)
        {Null, Null, Null, Null},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {False, False, False, False},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {Pipette, Pipette, Pipette, Pipette}
      ],
      {
        {Null, Null, Null, Null},
        {Null, Null, Null, Null}
      }
    ],

    Example[{Basic, "If containers are set to some Model[Container, Plate] without an index and PackPlateQ is True, all like container models receive indices, are grouped into plates by container model and by the specified grouping parameters, and the plates are packed column-wise:"},
      PackContainers[
        (* unresolved containers *)
        {Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Plate, "id:E8zoYveRllM7"], Model[Container, Plate, "id:E8zoYveRllM7"]},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 3 Milliliter, 3 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {Pipette, Pipette, Pipette, Shake},
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, PreferredContainer[1 Milliliter, Type -> Plate, LiquidHandlerCompatible -> True]},
          {1, PreferredContainer[1 Milliliter, Type -> Plate, LiquidHandlerCompatible -> True]},
          {2, PreferredContainer[3 Milliliter, Type -> Plate, LiquidHandlerCompatible -> True]},
          {3, PreferredContainer[3 Milliliter, Type -> Plate, LiquidHandlerCompatible -> True]}
        },
        {"A1", "B1", "A1", "A1"}
      }
    ],

    Example[{Basic, "If containers are set to Automatic and PackPlateQ is False, resolve to tube container models instead:"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Automatic, Automatic, Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {False, False, False, False},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {Pipette, Pipette, Pipette, Pipette}
      ],
      {
        {
          PreferredContainer[1 Milliliter],
          PreferredContainer[1 Milliliter],
          PreferredContainer[1 Milliliter],
          PreferredContainer[1 Milliliter]
        },
        {"A1", "A1", "A1", "A1"}
      }
    ],

    Example[{Basic, "Group the samples into plate models suitable for the volume required at each index:"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Automatic, Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 10 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {Ambient, Ambient, Ambient},
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {2, PreferredContainer[10 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]}
        },
        {"A1", "B1", "A1"}
      }
    ],

    Example[{Basic, "If more wells are needed than are available in one plate, use multiple plates:"},
      PackContainers[
        (* unresolved containers *)
        Automatic,
        (* list of booleans indicating whether packing into a plate is necessary *)
        True,
        (* minimum required volumes for the containers *)
        75 Milliliter,
        (* a list (or a list of lists) of experiment parameters to group by *)
        {{Ambient}, {200 RPM}},
        LiquidHandlerCompatible -> True,
        NumberOfReplicates -> 5
      ],
      {
        {
          {1, PreferredContainer[75 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[75 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[75 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[75 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {2, PreferredContainer[75 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]}
        },
        {"A1", "B1", "C1", "D1", "A1"}
      }
    ],

    Example[{Basic, "If PackPlateQ is True at any index where a container model or container object is specified, it is not necessary to provide a required container volume at the index:"},
      PackContainers[
        (* unresolved containers *)
        {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
        (* list of booleans indicating whether packing into a plate is necessary *)
        True,
        (* minimum required volumes for the containers *)
        Null,
        (* a list (or a list of lists) of experiment parameters to group by *)
        {{25 Celsius}, {Pipette}}
      ],
      {
        {{1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}},
        {"A1"}
      }
    ],

    Example[{Basic, "Packing does not occur at indices where a container model which is not a plate is specified, since containers without multiple positions cannot be packed:"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Model[Container, Vessel, "id:bq9LA0dBGGR6"], Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {Ambient, Ambient, Ambient},
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          Model[Container, Vessel, "id:bq9LA0dBGGR6"],
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]}
        },
        {"A1", "A1", "B1"}
      }
    ],

    Example[{Basic, "Specified container models are not overwritten when packed:"},
      PackContainers[
        (* unresolved containers *)
        {Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Plate, "id:E8zoYveRllM7"]},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {Ambient, Ambient}
      ],
      {
        {
          {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]},
          {2, Model[Container, Plate, "id:E8zoYveRllM7"]}
        },
        {"A1", "A1"}
      }
    ],

    Example[{Options, FirstNewContainerIndex, "Specify the value of the first new container index:"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Automatic, Automatic, Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {
          {25 Celsius, 25 Celsius, 37 Celsius, 25 Celsius},
          {Shake, Shake, Pipette, Pipette},
          {300 RPM, 300 RPM, Null, Null}
        },
        (* highest container index specified by the user *)
        FirstNewContainerIndex -> 4
      ],
      {
        {
          {4, PreferredContainer[1 Milliliter, Type -> Plate]},
          {4, PreferredContainer[1 Milliliter, Type -> Plate]},
          {5, PreferredContainer[1 Milliliter, Type -> Plate]},
          {6, PreferredContainer[1 Milliliter, Type -> Plate]}
        },
        {"A1", "B1", "A1", "A1"}
      }
    ],

    Example[{Options, NumberOfReplicates, "Expand the containers and wells according to the number of replicates:"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Automatic, Automatic, Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True, True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter, 1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {
          {25 Celsius, 25 Celsius, 37 Celsius, 25 Celsius},
          {Shake, Shake, Pipette, Pipette},
          {300 RPM, 300 RPM, Null, Null}
        },
        NumberOfReplicates -> 3,
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {2, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {2, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {2, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {3, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {3, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {3, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]}
        },
        {"A1", "B1", "C1", "D1", "E1", "F1", "A1", "B1", "C1", "A1", "B1", "C1"}
      }
    ],

    Example[{Options, LiquidHandlerCompatible, "Use the LiquidHandlerCompatible option to specify that any new container model must be compatible with robotic liquid handlers:"},
      PackContainers[
        (* unresolved containers *)
        {Automatic, Automatic},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, True},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {25 Celsius, 25 Celsius},
        LiquidHandlerCompatible -> True
      ],
      {
        {
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]},
          {1, PreferredContainer[1 Milliliter, LiquidHandlerCompatible -> True, Type -> Plate]}
        },
        {"A1", "B1"}
      }
    ],

    Example[{Messages, "MustRemoveContainerIndices", "If a Model[Container, Vessel] (i.e., not a plate) with an index is specified but the number of replicates is greater than 1, these container indices are removed to prevent aliquoting multiple times into the same tube and a warning message is thrown:"},
      PackContainers[
        (* unresolved containers *)
        {1, Model[Container, Vessel, "id:3em6Zv9NjjN8"]},
        (* list of booleans indicating whether packing into a plate is necessary *)
        False,
        (* minimum required volumes for the containers *)
        1 Milliliter,
        (* a list (or a list of lists) of experiment parameters to group by *)
        {{25 Celsius}, {Pipette}},
        NumberOfReplicates -> 5
      ],
      {
        {
          Model[Container, Vessel, "id:3em6Zv9NjjN8"],
          Model[Container, Vessel, "id:3em6Zv9NjjN8"],
          Model[Container, Vessel, "id:3em6Zv9NjjN8"],
          Model[Container, Vessel, "id:3em6Zv9NjjN8"],
          Model[Container, Vessel, "id:3em6Zv9NjjN8"]
        },
        {"A1", "A1", "A1", "A1", "A1"}
      },
      Messages :> {
        Warning::MustRemoveContainerIndices
      }
    ],

    Example[{Messages, "PackNullContainer", "If PackPlateQ is True at any index where the specified container is Null, PackPlateQ defaults to False at this index and a warning is thrown:"},
      PackContainers[
        (* unresolved containers *)
        Null,
        (* list of booleans indicating whether packing into a plate is necessary *)
        True,
        (* minimum required volumes for the containers *)
        1 Milliliter,
        (* a list (or a list of lists) of experiment parameters to group by *)
        {{25 Celsius}, {Pipette}}
      ],
      {
        {Null},
        {Null}
      },
      Messages :> {
        Warning::PackNullContainer
      }
    ],

    Example[{Messages, "UnknownRequiredContainerVolume", "If PackPlateQ is True at any index where the specified container is Automatic but there is insufficient information to determine the required solution volume at the index, PackPlateQ is reset to False and a warning is thrown:"},
      PackContainers[
        (* unresolved containers *)
        Automatic,
        (* list of booleans indicating whether packing into a plate is necessary *)
        True,
        (* minimum required volumes for the containers *)
        Null,
        (* a list (or a list of lists) of experiment parameters to group by *)
        {{25 Celsius}, {Pipette}}
      ],
      {
        {Null},
        {Null}
      },
      Messages :> {
        Warning::UnknownRequiredContainerVolume
      }
    ],

    Example[{Messages, "PackIntoSameContainerPosition", "If the output gives the same specific container and well position at any two (or more) indices, a warning is thrown:"},
      PackContainers[
        (* unresolved containers *)
        {{"A1", {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}}, {"A1", {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}}},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {False, False},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {{Pipette, Pipette}}
      ],
      {
        {{1, PreferredContainer[1 Milliliter, Type -> Plate]}, {1, PreferredContainer[1 Milliliter, Type -> Plate]}},
        {"A1", "A1"}
      },
      Messages :> {
        Warning::PackIntoSameContainerPosition
      }
    ],

    Example[{Messages, "AvoidOverwritingWellPosition", "If a well and container are both specified at any index at which PackPlateQ is True, PackPlateQ is reset to False to avoid overwriting the well input, and a warning is thrown:"},
      PackContainers[
        (* unresolved containers *)
        {{"A1", {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}}, {1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}},
        (* list of booleans indicating whether packing into a plate is necessary *)
        {True, False},
        (* minimum required volumes for the containers *)
        {1 Milliliter, 1 Milliliter},
        (* a list (or a list of lists) of experiment parameters to group by *)
        {{Pipette, Pipette}}
      ],
      {
        {{1, PreferredContainer[1 Milliliter, Type -> Plate]}, {1, PreferredContainer[1 Milliliter, Type -> Plate]}},
        {"A1", "B1"}
      },
      Messages :> {
        Warning::AvoidOverwritingWellPosition
      }
    ]
  },

  SetUp :> (
    $CreatedObjects = {}
  ),
  TearDown :> (
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    Unset[$CreatedObjects]
  ),
  SymbolSetUp :> Module[{existsFilter, plate0, plate1},
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Off[Warning::DeprecatedProduct];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[{
      Object[Container, Plate, "Test 96 well DWP 0 for PackContainers "<>$SessionUUID],
      Object[Container, Plate, "Test 96 well DWP 1 for PackContainers "<>$SessionUUID]
    }];

    EraseObject[
      PickList[
        {
          Object[Container, Plate, "Test 96 well DWP 0 for PackContainers "<>$SessionUUID],
          Object[Container, Plate, "Test 96 well DWP 1 for PackContainers "<>$SessionUUID]
        },
        existsFilter
      ],
      Force->True,
      Verbose->False
    ];

    {plate0, plate1} = Upload[{
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test 96 well DWP 0 for PackContainers "<>$SessionUUID,
        DeveloperObject -> True
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
        Name -> "Test 96 well DWP 1 for PackContainers "<>$SessionUUID,
        DeveloperObject -> True
      |>
    }];
  ],

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    On[Warning::DeprecatedProduct];
    Module[{allObjects, existsFilter},

      (* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
      allObjects= Cases[Flatten[{
        Object[Container, Plate, "Test 96 well DWP 0 for PackContainers "<>$SessionUUID],
        Object[Container, Plate, "Test 96 well DWP 1 for PackContainers "<>$SessionUUID]
      }], ObjectP[]];

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
  ),
  Stubs:>{
    $PersonID=Object[User,"Test user for notebook-less test protocols"]
  }
];

(* ::Subsection::Closed:: *)
(* AliquotIntoPlateQ *)

DefineTests[AliquotIntoPlateQ,
  {
    Example[{Basic, "If the parameters at any index at which the container is left automatic and aliquot is True necessitate centrifugation, temperatures other than AmbientTemperatureP, or shaking, return True at that index:"},
      AliquotIntoPlateQ[
        {Automatic, Automatic, Automatic, Automatic}, (* unresolved aliquot containers *)
        {True, True, True, True}, (* resolved aliquot Booleans *)
        {True, False, False, False}, (* resolved centrifuge Booleans or Null *)
        {Pipette, Shake, None, Pipette}, (* resolved mix types or Null *)
        {25 Celsius, Ambient, 37 Celsius, 25 Celsius} (* resolved temperatures or Null *)
      ],
      {True, True, True, False}
    ],

    Example[{Basic, "If the container is Automatic and any centrifuge Boolean at the same index is True, return True at this index:"},
      AliquotIntoPlateQ[
        {Automatic, Automatic}, (* unresolved aliquot containers *)
        {True, True}, (* resolved aliquot Booleans *)
        {False, True}, (* resolved centrifuge Booleans or Null *)
        Null, (* resolved mix types or Null *)
        Null (* resolved temperatures or Null *)
      ],
      {False, True}
    ],

    Example[{Basic, "If the container is Automatic and any mix type at the same index is Shake, return True at this index:"},
      AliquotIntoPlateQ[
        {Automatic, Automatic}, (* unresolved aliquot containers *)
        {True, True}, (* resolved aliquot Booleans *)
        Null, (* resolved centrifuge Booleans or Null *)
        {Pipette, Shake}, (* resolved mix types or Null *)
        Null (* resolved temperatures or Null *)
      ],
      {False, True}
    ],

    Example[{Basic, "If the container is Automatic and any temperature parameter at the same index does not match AmbientTemperatureP, return True at this index:"},
      AliquotIntoPlateQ[
        {Automatic, Automatic}, (* unresolved aliquot containers *)
        {True, True}, (* resolved aliquot Booleans *)
        Null, (* resolved centrifuge Booleans or Null *)
        Null, (* resolved mix types or Null *)
        {25 Celsius, 37 Celsius} (* resolved temperatures or Null *)
      ],
      {False, True}
    ],

    Example[{Basic, "If no aliquot Booleans are set to True, return a list of Falses of length equal to the number of aliquot Booleans:"},
      AliquotIntoPlateQ[
        {Automatic, Automatic, Null, Null}, (* unresolved aliquot containers *)
        {False, False, False, False}, (* resolved aliquot Booleans *)
        Null, (* resolved centrifuge Booleans or Null *)
        Null, (* resolved mix types or Null *)
        Null (* resolved temperatures or Null *)
      ],
      {False, False, False, False}
    ],

    Example[{Basic, "If none of the containers are set to Automatic, return a list of Falses of length equal to the number of aliquot containers:"},
      AliquotIntoPlateQ[
        {Model[Container, Vessel, "id:o1k9jAG00e3N"], Model[Container, Vessel, "id:o1k9jAG00e3N"], Model[Container, Vessel, "id:o1k9jAG00e3N"], Null}, (* unresolved aliquot containers *)
        {True, True, True, False}, (* resolved aliquot Booleans *)
        Null, (* resolved centrifuge Booleans or Null *)
        Null, (* resolved mix types or Null *)
        Null (* resolved temperatures or Null *)
      ],
      {False, False, False, False}
    ],

    Example[{Basic, "If an experimental condition at a given index typically requires aliquoting into a plate but a container is specified at the index, return False at that index:"},
      AliquotIntoPlateQ[
        {{1, Model[Container, Plate, "id:L8kPEjkmLbvW"]}, Automatic}, (* unresolved aliquot containers *)
        {True, True}, (* resolved aliquot Booleans *)
        Null, (* resolved centrifuge Booleans or Null *)
        Null, (* resolved mix types or Null *)
        {37 Celsius, 37 Celsius} (* resolved temperatures or Null *)
      ],
      {False, True}
    ]
  }
];