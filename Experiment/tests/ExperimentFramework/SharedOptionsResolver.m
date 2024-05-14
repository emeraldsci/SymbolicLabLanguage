(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*resolveSharedOptions*)

DefineTests[
  resolveSharedOptions,
  {
    Example[
      {Basic,"Resolve the centrifuge instrument using ExperimentCentrifuge while passing down the intensity from a parent function:"},
      Module[{childExpandedInputs, childExpandedOptions, optionMap, parentOptions, childMapThreadOptions, parentMapThreadOptions},

        (*Get the default options for the child function (ExperimentCentrifuge) with the intensity specified to 1000 RPM*)
        {childExpandedInputs, childExpandedOptions} = ExpandIndexMatchedInputs[
          ExperimentCentrifuge,
          {{Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]}},
          SafeOptions[ExperimentCentrifuge, {Intensity->1000 RPM}]
        ];

        (*Specify the option map for the parent function that includes all of the options we want resolved*)
        optionMap = {ParentIntensity->Intensity, ParentInstrument->Instrument};

        (*Change the names of the child ExperimentCentrifuge options to match those of the parent function specified in the option map. Note that the optionMap must be inverted to do this renaming*)
        parentOptions = childExpandedOptions/.(Reverse/@optionMap);

        (*generate the map thread options for the child function*)
        childMapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentCentrifuge, childExpandedOptions];

        (*convert the map thread options of the child function into those of the parent function by renaming the keys by the reverse of the option map*)
        parentMapThreadOptions = KeyMap[Replace[#, Reverse/@optionMap]&, #] & /@ childMapThreadOptions;

        resolveSharedOptions[
          ExperimentCentrifuge,
          "The parent function running ExperimentCentrifuge encountered an error: ",
          {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]]},
          {True},
          optionMap,
          parentOptions,
          {},
          parentMapThreadOptions,
          False
          ]
        ],
      {
        KeyValuePattern[
          {
            ParentIntensity->{1000 RPM},
            ParentInstrument->{ObjectP[Object[Instrument,Centrifuge]]|ObjectP[Model[Instrument,Centrifuge]]}
          }
        ],
        SimulationP,
        {}
      }
    ],
    Example[
      {Basic,"Resolve the centrifuge instrument using ExperimentCentrifuge while passing down the intensity from a parent function, with the input options explicitly written:"},
      (* Only options tested because simulation results too large for unit test. Gives "Results too large to store" error. *)
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]]},
        {True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument},
        {ParentIntensity->1000 RPM, ParentInstrument->Automatic},
        {},
        {<|ParentIntensity->1000 RPM, ParentInstrument->Automatic|>},
        False
      ][[1]],
      KeyValuePattern[
        {
          ParentIntensity -> {1000 RPM},
          ParentInstrument -> {(ObjectP[Object[Instrument,Centrifuge]]|ObjectP[Model[Instrument,Centrifuge]])}
        }
      ]
    ],
    Example[
      {Basic,"Input multiple packets but use the resolverMasterSwitch input to only resolve one packet:"},
      (* Only options tested because simulation results too large for unit test. Gives "Results too large to store" error. *)
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]],Download[Object[Sample,"Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID]]},
        {False,True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument},
        {ParentIntensity->Automatic, ParentInstrument->Automatic},
        {},
        {<|ParentIntensity->Automatic, ParentInstrument->Automatic|>, <|ParentIntensity->Automatic, ParentInstrument->Automatic|>},
        False
      ][[1]],
      KeyValuePattern[
        {
          ParentIntensity->{Null,UnitsP[GravitationalAcceleration] | UnitsP[RPM]},
          ParentInstrument->{Null,ObjectP[Model[Instrument,Centrifuge]]}
        }
      ]
    ],
    Example[
      {Basic,"Use the constant options input to resolve options that will be the same for all input samples:"},
      (* Only options tested because simulation results too large for unit test. Gives "Results too large to store" error. *)
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]],Download[Object[Sample,"Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID]]},
        {True,True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument},
        {ParentIntensity->{1000 RPM, 5000 RPM}},
        {ParentInstrument->Automatic},
        {<|ParentIntensity->1000 RPM|>, <|ParentIntensity->5000 RPM|>},
        False
      ][[1]],
      KeyValuePattern[
        {
          ParentIntensity->{(UnitsP[GravitationalAcceleration] | UnitsP[RPM])..},
          ParentInstrument->{ObjectP[Model[Instrument,Centrifuge]]..}
        }
      ]
    ],
    Example[
      {Basic, "Use the gatherTestsQ input to output the tests from the child function:"},
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]],Download[Object[Sample,"Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID]]},
        {False,True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument},
        {ParentIntensity->{1000 RPM, 5000 RPM}, ParentInstrument->Automatic},
        {},
        {<|ParentIntensity->1000 RPM, ParentInstrument->Automatic|>, <|ParentIntensity->5000 RPM, ParentInstrument->Automatic|>},
        True
      ],
      {
        {_Rule..},
        SimulationP,
        {TestP..}
      }
    ],
    Example[
      {Basic,"Add a prefix to an error message that is generated in the child function:"},
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 1L Glass Bottle for resolveSharedOptions"<>$SessionUUID]]},
        {True},
        {ParentIntensity->Intensity},
        {ParentIntensity->5000 RPM},
        {},
        {<|ParentIntensity->5000 RPM|>},
        False
      ],
      {
        {_Rule...},
        SimulationP,
        {}
      },
      Messages:>{Error::NoTransferContainerFound}
    ],
    Example[
      {Basic, "Resolve options in a child function that requires multiple inputs:"},
      resolveSharedOptions[
        ExperimentTransfer,
        "The parent function running ExperimentTransfer encountered an error: ",
        {Download[Object[Sample,"Test water sample in 1L Glass Bottle for resolveSharedOptions"<>$SessionUUID]]},
        {True},
        {ParentTips->Tips},
        {ParentTips->Automatic},
        {},
        {<|ParentTips->Automatic|>},
        False,
        AdditionalInputs->{{Model[Container, Vessel, "2mL Tube"]},{1 Milliliter}}
      ],
      {
        {_Rule...},
        SimulationP,
        {}
      }
    ],
    Example[
      {Additional,"Options in the myConstantOptions input are output with myOptions input if both are in the OptionMap:"},
      (* Only options tested because simulation results too large for unit test. Gives "Results too large to store" error. *)
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]],Download[Object[Sample,"Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID]]},
        {True,True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument},
        {ParentIntensity->{1000 RPM, 1000 RPM}},
        {ParentInstrument->Automatic},
        {<|ParentIntensity->1000 RPM|>, <|ParentIntensity->1000 RPM|>},
        False
      ][[1]],
      KeyValuePattern[
        {
          ParentIntensity->{EqualP[1000 RPM]..},
          ParentInstrument->{(ObjectP[Model[Instrument,Centrifuge]]|ObjectP[Model[Instrument,Centrifuge]])..}
        }
      ]
    ],
    Example[
      {Behaviors,"If a member of the optionMap is not an option of the child function, resolveSharedOptions will still run if its values are not included in myOptions, myMapThreadOptions, or myConstantOptions and will return Missing[KeyAbsent,..] for that option:"},
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]]},
        {True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument, ThisIsNotAnOption->ThisIsNotAnOption},
        {ParentIntensity->1000 RPM, ParentInstrument->Automatic},
        {},
        {<|ParentIntensity->1000 RPM, ParentInstrument->Automatic|>},
        False
      ],
      {
        {_Rule...},
        SimulationP,
        {}
      }
    ],
    Example[
      {Behaviors,"If a member of the optionMap is not an option of the child function and its values are specified in myOptions and myMapThreadOptions, resolveSharedOptions will not throw an error, but it will also not resolve any options or run any simulations:"},
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]]},
        {True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument, ThisIsNotAnOption->ThisIsNotAnOption},
        {ParentIntensity->1000 RPM, ParentInstrument->Automatic, ThisIsNotAnOption->False},
        {},
        {<|ParentIntensity->1000 RPM, ParentInstrument->Automatic, ThisIsNotAnOption->False|>},
        False
      ],
      {
        {_Rule...},
        Null,
        {}
      }
    ],
    Example[
      {Behaviors,"If the masterswitch for a sample is False but an option is set (not Automatic nor Null) in the input options, the input option will be returned unaltered, but all other options will be set to Null:"},
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]]},
        {False},
        {ParentIntensity->Intensity, ParentInstrument->Instrument},
        {ParentIntensity->1000 RPM, ParentInstrument->Automatic},
        {},
        {<|ParentIntensity->1000 RPM, ParentInstrument->Automatic|>},
        False
      ],
      {
        KeyValuePattern[
          {
            ParentIntensity -> {EqualP[1000 RPM]},
            ParentInstrument -> {Null}
          }
        ],
        Null,
        {}
      }
    ],
    Example[
      {Behaviors,"Options that are not index-matched are returned without index-matching (a single value that is not in a list):"},
      (* Only options tested because simulation results too large for unit test. Gives "Results too large to store" error. *)
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]]},
        {True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument, ParentSterile -> Sterile},
        {ParentIntensity->1000 RPM, ParentInstrument->Automatic, ParentSterile -> Automatic},
        {},
        {<|ParentIntensity->1000 RPM, ParentInstrument->Automatic, ParentSterile -> Automatic|>},
        False
      ][[1]],
      KeyValuePattern[
        {
          ParentIntensity -> {1000 RPM},
          ParentInstrument -> {ObjectP[Model[Instrument]]},
          ParentSterile -> False
        }
      ]
    ],
    Example[
      {Behaviors,"If multiple samples are input and options that are not index-matched are specified, those options will be returned (not Null) as long as at least one sample is resolved by the child function:"},
      (* Only options tested because simulation results too large for unit test. Gives "Results too large to store" error. *)
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]],Download[Object[Sample,"Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID]]},
        {False, True},
        {ParentIntensity->Intensity, ParentInstrument->Instrument, ParentSterile -> Sterile},
        {ParentIntensity->Automatic, ParentInstrument->Automatic, ParentSterile -> Automatic},
        {},
        {<|ParentIntensity->Automatic, ParentInstrument->Automatic, ParentSterile -> Automatic|>, <|ParentIntensity->Automatic, ParentInstrument->Automatic, ParentSterile -> Automatic|>},
        False
      ][[1]],
      KeyValuePattern[
        {
          ParentIntensity -> {Null, UnitsP[RPM]|UnitsP[GravitationalAcceleration]},
          ParentInstrument -> {Null, ObjectP[Model[Instrument]]},
          ParentSterile -> False
        }
      ]
    ],
    Example[
      {Behaviors,"If multiple samples are input and options that are not index-matched are specified, those options will be returned as-is (or Null if Automatic) if no samples are resolved by the child function:"},
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        {Download[Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID]],Download[Object[Sample,"Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID]]},
        {False, False},
        {ParentIntensity->Intensity, ParentInstrument->Instrument, ParentSterile -> Sterile},
        {ParentIntensity->Automatic, ParentInstrument->Automatic, ParentSterile -> Automatic},
        {},
        {<|ParentIntensity->Automatic, ParentInstrument->Automatic, ParentSterile -> Automatic|>, <|ParentIntensity->Automatic, ParentInstrument->Automatic, ParentSterile -> Automatic|>},
        False
      ],
      {
        KeyValuePattern[
          {
            ParentIntensity -> {Null, Null},
            ParentInstrument -> {Null, Null},
            ParentSterile -> Null
          }
        ],
        Null,
        {}
      }
    ],
    Example[
      {Behaviors, "If the child function has HelperOutput pattern and does not support simulation mode, return Null for simulation:"},
      resolveSharedOptions[
        ResolveDilutionSharedOptions,
        "The parent function running ResolveDilutionSharedOptions encountered an error: ",
        {
          Download[Object[Sample, "Test water sample in 50mL tube (1) for resolveSharedOptions" <>$SessionUUID]],
          Download[Object[Sample, "Test water sample in 50mL tube (2) for resolveSharedOptions" <>$SessionUUID]]},
        {False, True},
        {
          ParentDilutionType -> DilutionType,
          ParentNumberOfDilutions -> NumberOfDilutions
        },
        {
          ParentDilutionType -> Automatic,
          ParentNumberOfDilutions -> Automatic
        },
        {},
        {
          <|ParentDilutionType -> Automatic, ParentNumberOfDilutions -> Automatic|>,
          <|ParentDilutionType -> Serial, ParentNumberOfDilutions -> Automatic|>
        },
        True
      ],
      {
        {_Rule..},
        Null,
        {TestP..}
      }
    ],
    Example[
      {Messages,"If any additional inputs are not index-matched to the input sample packets, than an error is thrown:"},
      resolveSharedOptions[
        ExperimentTransfer,
        "The parent function running ExperimentTransfer encountered an error: ",
        Download[
          {
            Object[Sample, "Test water sample in 50mL tube (1) for resolveSharedOptions" <> $SessionUUID],
            Object[Sample, "Test water sample in 1L Glass Bottle for resolveSharedOptions" <> $SessionUUID]
          }
        ],
        {True, True},
        {ParentTips -> Tips},
        {ParentTips -> Automatic},
        {},
        {<|ParentTips -> Automatic|>, <|ParentTips -> Automatic|>},
        False,
        AdditionalInputs -> {{Model[Container, Vessel, "2mL Tube"]}, {1 Milliliter}}
      ],
      $Failed,
      Messages :> {
        Error::AdditionalInputsNotIndexMatching
      }
    ],
    Example[
      {Messages,"If an option value is provided in both the input options (myOptions) and the constant options (myConstantOptions), an error will be thrown:"},
      resolveSharedOptions[
        ExperimentCentrifuge,
        "The parent function running ExperimentCentrifuge encountered an error: ",
        Download[
          {
            Object[Sample, "Test water sample in 50mL tube (1) for resolveSharedOptions" <> $SessionUUID],
            Object[Sample, "Test water sample in 50mL tube (2) for resolveSharedOptions" <> $SessionUUID]
          }
        ],
        {True, False},
        {ParentIntensity -> Intensity, ParentInstrument -> Instrument, ParentTemperature -> Temperature},
        {ParentIntensity -> Automatic, ParentInstrument -> Automatic, ParentTemperature -> Ambient},
        {ParentTemperature -> 70 Celsius},
        {<|ParentIntensity -> Automatic, ParentInstrument -> Automatic, ParentTemperature -> Ambient|>, <|ParentIntensity -> Automatic, ParentInstrument -> Automatic, ParentTemperature -> Ambient|>},
        False
      ],
      $Failed,
      Messages :> {
        Error::MultipleOptionValueInputs
      }
    ]

  },
  SymbolSetUp:>(
    Module[
      {existsFilter, emptyContainer1, emptyContainer2, emptyContainer3, waterSample, waterSample2, waterSample3},
      ClearMemoization[];

      Off[Warning::SamplesOutOfStock];
      Off[Warning::InstrumentUndergoingMaintenance];

      $CreatedObjects={};

      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      existsFilter=DatabaseMemberQ[{
        Object[Container,Vessel,"Test container 1 for resolveSharedOptions"<>$SessionUUID],
        Object[Container,Vessel,"Test container 2 for resolveSharedOptions"<>$SessionUUID],
        Object[Container,Vessel,"Test container 3 for resolveSharedOptions"<>$SessionUUID],

        Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID],
        Object[Sample,"Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID],
        Object[Sample,"Test water sample in 1L Glass Bottle for resolveSharedOptions"<>$SessionUUID]
      }];

      EraseObject[
        PickList[
          {
            Object[Container,Vessel,"Test container 1 for resolveSharedOptions"<>$SessionUUID],
            Object[Container,Vessel,"Test container 2 for resolveSharedOptions"<>$SessionUUID],
            Object[Container,Vessel,"Test container 3 for resolveSharedOptions"<>$SessionUUID],

            Object[Sample,"Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID],
            Object[Sample,"Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID],
            Object[Sample,"Test water sample in 1L Glass Bottle for resolveSharedOptions"<>$SessionUUID]
          },
          existsFilter
        ],
        Force->True,
        Verbose->False
      ];

      (* Create some empty containers *)
      {emptyContainer1,emptyContainer2,emptyContainer3}=Upload[{
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test container 1 for resolveSharedOptions"<>$SessionUUID,
          Site -> Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
          Name->"Test container 2 for resolveSharedOptions"<>$SessionUUID,
          Site -> Link[$Site],
          DeveloperObject->True
        |>,
        <|
          Type->Object[Container,Vessel],
          Model->Link[Model[Container,Vessel,"1L Glass Bottle"],Objects],
          Name->"Test container 3 for resolveSharedOptions"<>$SessionUUID,
          Site -> Link[$Site],
          DeveloperObject->True
        |>
      }];

      (* Create some water samples *)
      {waterSample,waterSample2,waterSample3}=ECL`InternalUpload`UploadSample[
        {
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"],
          Model[Sample,"Milli-Q water"]
        },
        {
          {"A1",emptyContainer1},
          {"A1",emptyContainer2},
          {"A1",emptyContainer3}
        },
        InitialAmount->{40 Milliliter,20 Milliliter,1 Liter},
        Name->{
          "Test water sample in 50mL tube (1) for resolveSharedOptions"<>$SessionUUID,
          "Test water sample in 50mL tube (2) for resolveSharedOptions"<>$SessionUUID,
          "Test water sample in 1L Glass Bottle for resolveSharedOptions"<>$SessionUUID
        }
      ];

      (* Make some changes to our samples to make them invalid. *)
      Upload[{
        <|Object->waterSample,DeveloperObject->True|>,
        <|Object->waterSample2,DeveloperObject->True|>,
        <|Object->waterSample3,DeveloperObject->True|>
      }];

    ];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    EraseObject[$CreatedObjects,Force->True,Verbose->False];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
]