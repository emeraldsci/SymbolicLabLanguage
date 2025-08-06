(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(*ImageColonies*)


(* ::Subsection::Closed:: *)
(*Define Options*)


(* ::Subsubsection::Closed:: *)
(*ExperimentImageColonies Options*)


(* ::Code::Initialization:: *)
(* Define Options *)
DefineOptions[ExperimentImageColonies,
  Options :>  {
    (* Non-IndexMatching InstrumentOptions *)
    {
      OptionName -> Instrument,
      Default -> Model[Instrument, ColonyHandler, "QPix 420 HT"],
      Description -> "The instrument used to image colonies on solid media.",
      AllowNull -> False,
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Model[Instrument, ColonyHandler], Object[Instrument, ColonyHandler]}],
        OpenPaths -> {
          {
            Object[Catalog, "Root"],
            "Instruments",
            "Cell Culture",
            "Colony Handlers"
          }
        }
      ],
      Category -> "General"
    },
    IndexMatching[
      IndexMatchingInput -> "experiment samples",
      {
        OptionName -> SampleLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the input samples to be imaged, for use in downstream unit operations.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Category -> "General",
        UnitOperation -> True
      },
      {
        OptionName -> SampleContainerLabel,
        Default -> Automatic,
        Description -> "A user defined word or phrase used to identify the container of the input samples to be imaged, for use in downstream unit operations.",
        AllowNull -> False,
        Widget -> Widget[
          Type -> String,
          Pattern :> _String,
          Size -> Line
        ],
        Category -> "General",
        UnitOperation -> True
      },
      (* --- Imaging Options --- *)
      {
        OptionName -> ImagingChannels,
        Default -> Automatic,
        Description -> "A list of presets which describe the light source, blue-white filter, and filter pairs for selecting fluorescence excitation and emission wavelengths when capturing images. For more details on imaging channels and recommended fluorophores for various imaging strategies, refer to Figure 3.1.",
        ResolutionDescription -> "Automatically set to BrightField if ImagingStrategies is BrightField, set to 400 Nanometer if ImagingStrategies is BlueWhiteScreen, set to {377 Nanometer, 447 Nanometer} if ImagingStrategies is VioletFluorescence, set to {457 Nanometer, 536 Nanometer} if ImagingStrategies is GreenFluorescence, set to {531 Nanometer, 593 Nanometer} if ImagingStrategies is OrangeFluorescence, set to {531 Nanometer, 624 Nanometer} if ImagingStrategies is RedFluorescence, and set to {628 Nanometer, 692 Nanometer} if ImagingStrategies is DeepRedFluorescence.",
        AllowNull -> False,
        Widget -> Alternatives[
          "Multiple Imaging Channels" -> Adder[
            Widget[
              Type -> Enumeration,
              Pattern :> QPixImagingChannelsP
            ]
          ],
          "Single Imaging Channel" -> Widget[
            Type -> Enumeration,
            Pattern :> QPixImagingChannelsP
          ]
        ],
        Category -> "Hidden"
      },
      {
        OptionName -> ImagingStrategies,
        Default -> BrightField,
        AllowNull -> False,
        Widget -> Alternatives[
          "Multiple Imaging Strategies" -> With[{insertMe = Flatten[QPixImagingStrategiesP]},
            Widget[
              Type -> MultiSelect,
              Pattern :> DuplicateFreeListableP[insertMe]
            ]
          ],
          "Single Imaging Strategy" -> Widget[
            Type -> Enumeration,
            Pattern :> Alternatives[BrightField]
          ]
        ],
        Description -> "The end goals for capturing images. ImagingStrategies can be either a single end goal of simple visualization or a list of multiple end goals. The options include BrightField, BlueWhiteScreen, and various fluorescence imaging techniques. BrightField imaging provides essential baseline images and is required if any other imaging strategies are employed. BlueWhiteScreen is used to distinguish recombinant colonies with disrupted lacZ (white colonies) from blue colonies, using an absorbance filter. Fluorescence imaging allows for the visualization of colonies with fluorescent dyes or proteins.",
        Category -> "Imaging"
      },
      {
        OptionName -> ExposureTimes,
        Default -> Automatic,
        Description -> "A single length of time that the camera sensor collects light during image acquisition for each imaging strategy. An increased exposure time leads to brighter images based on a linear scale. When set as Automatic, optimal exposure time is automatically determined during the experiment. This is done by running AnalyzeImageExposure on images taken with suggested initial exposure times. The process adjusts the exposure time for subsequent image acquisitions until the optimal value is found.",
        AllowNull -> False,
        Widget -> Alternatives[
          "Multiple Exposure Times" -> Adder[
            Alternatives[
              Widget[
                Type -> Quantity,
                Pattern :>  RangeP[1 Millisecond, 2000 Millisecond], (* This range is from the QPix *)
                Units -> {Millisecond, {Millisecond, Second}}
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Automatic]
              ]
            ]
          ],
          "Single Exposure Time" -> Alternatives[
            Widget[
              Type -> Quantity,
              Pattern :>  RangeP[1 Millisecond, 2000 Millisecond], (* This range is from the QPix *)
              Units -> {Millisecond, {Millisecond, Second}}
            ],
            Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[Automatic]
            ]
          ]
        ],
        Category -> "Imaging"
      }
    ],
    (* Redefine Preparation and WorkCell options because ImageColonies can only occur robotically on the qpix *)
    {
      OptionName -> Preparation,
      Default -> Robotic,
      Description -> "Indicates if this unit operation is carried out primarily robotically.",
      AllowNull -> False,
      Category -> "Hidden",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[Robotic]
      ]
    },
    {
      OptionName -> WorkCell,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[qPix]],
      AllowNull -> False,
      Default -> qPix,
      Description -> "Indicates the work cell that this primitive will be run on if Preparation->Robotic.",
      Category -> "Hidden"
    },
    (* Shared Options *)
    ProtocolOptions,
    SamplesInStorageOptions,
    SimulationOption
  }
];


(* ::Subsection::Closed:: *)
(*Warning and Error Messages*)


(* Input Errors *)
Error::UnsupportedColonyTypes = "The cell type of sample `1` at indices `2` is `3`. Only Bacterial and Yeast colonies are supported for `4`. Please select `5` if the cell type is Mammalian.";
Error::NonOmniTrayContainer = "The input samples, `1`, are not in a plate container that only has 1 well. Please transfer the samples to a single-well OmniTray plate before manipulating colonies.";
(* Imaging Errors *)
Error::ImagingOptionMismatch = "The following samples, `1`, have ImagingStrategies and ExposureTimes set to values of conflicting lengths. Please ensure this is an exposure time for each imaging strategy by setting both of these options as a list, neither of them as a list, or allow them to be resolved automatically.";
Error::MissingBrightField = "The following samples, `1`, have no BrightField specified in the ImagingStrategies option, `2`. Please include BrightField imaging strategy since BrightField imaging is essential for obtaining baseline images and is always required.";


(* ::Subsection::Closed:: *)
(*Experiment Function*)


(* ::Code::Initialization:: *)
(* CORE Overload *)
ExperimentImageColonies[mySamples: ListableP[ObjectP[Object[Sample]]], myOptions: OptionsPattern[ExperimentImageColonies]] := Module[
  {
    outputSpecification, output, gatherTests, listedSamplesNamed, listedOptionsNamed, safeOpsNamed, safeOpsTests,
    listedSamples, safeOps, validLengths, validLengthTests, templatedOptions, templateTests, simulation, currentSimulation,
    inheritedOptions, preExpandedImagingStrategies, preExpandedImagingChannels, preExpandedExposureTimes,
    manuallyExpandedImagingStrategies, manuallyExpandedImagingChannels, manuallyExpandedExposureTimes, expandedSafeOps,
    cache, defaultInstrumentObjects, allObjects, objectSampleFields, modelSampleFields, objectContainerFields, modelContainerFields,
    modelInstrumentFields, sampleObjects, instrumentObjects, modelInstrumentObjects, objectContainerObjects, downloadedCache,
    cacheBall, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, preCollapsedResolvedOptions, collapsedResolvedOptions,
    returnEarlyQ, performSimulationQ, unitOperationPacket, batchedUnitOperationPackets, runTime, updatedSimulation, uploadQ,
    allUnitOperationPackets, protocolObject, resourcePacketTests
  },

  (* Determine the requested return value from the function. *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests. *)
  gatherTests = MemberQ[output, Tests];

  (* Remove temporal links. *)
  (* Make sure we're working with a list of options/inputs. *)
  {listedSamplesNamed, listedOptionsNamed} = removeLinks[ToList[mySamples], ToList[myOptions]];

  (* Note: we do not have sample prep options, not check validSamplePrep here *)

  (* Call SafeOptions to make sure all options match pattern. *)
  {safeOpsNamed, safeOpsTests} = If[gatherTests,
    SafeOptions[ExperimentImageColonies, listedOptionsNamed, AutoCorrect -> False, Output -> {Result, Tests}],
    {SafeOptions[ExperimentImageColonies, listedOptionsNamed, AutoCorrect -> False], {}}
  ];

  (* Call sanitize-inputs to clean any named objects. *)
  {listedSamples, safeOps} = sanitizeInputs[listedSamplesNamed, safeOpsNamed, Simulation -> Lookup[safeOpsNamed, Simulation, Null]];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed. *)
  If[MatchQ[safeOps, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> safeOpsTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Call ValidInputLengthsQ to make sure all options are the right length. *)
  {validLengths, validLengthTests} = If[gatherTests,
    ValidInputLengthsQ[ExperimentImageColonies, {listedSamples}, safeOps, Output -> {Result, Tests}],
    {ValidInputLengthsQ[ExperimentImageColonies, {listedSamples}, safeOps], Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point). *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions, templateTests} = If[gatherTests,
    ApplyTemplateOptions[ExperimentImageColonies, {ToList[listedSamples]}, safeOps, Output -> {Result, Tests}],
    {ApplyTemplateOptions[ExperimentImageColonies, {ToList[listedSamples]}, safeOps], Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests],
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null
    }]
  ];

  (* Lookup simulation if it exists *)
  simulation = Lookup[safeOps, Simulation];

  (* Initialize the simulation if it doesn't exist *)
  currentSimulation = If[MatchQ[simulation, SimulationP],
    simulation,
    Simulation[]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions = ReplaceRule[safeOps, templatedOptions];

  (* Expand index-matching options *)
  (* Normally, SingletonClassificationPreferred or ExpandedClassificationPreferred is used to expand multi-select *)
  (* Note: but we can be smart here to check if it is singleton or not *)
  (* Basically, the only value allowed for singleton for ImagingStrategies is BrightField *)
  (* And ImagingChannels and ExposureTimes are index matched to ImagingStrategies *)
  {
    preExpandedImagingStrategies,
    preExpandedImagingChannels,
    preExpandedExposureTimes
  } = Lookup[inheritedOptions,
    {
      ImagingStrategies,
      ImagingChannels,
      ExposureTimes
    }
  ];

  {
    manuallyExpandedImagingStrategies,
    manuallyExpandedImagingChannels,
    manuallyExpandedExposureTimes
  } = Which[
    MatchQ[preExpandedImagingStrategies, BrightField],
      (* If a singleton value is given and collapsed *)
      (* Example: samples:{s1,s2}, ImagingChannels:{BrightField(for s1),BrightField(for s2)}, ExposureTimes:{Automatic|10ms(for s1),Automatic|10ms(for s2)}*)
      {
        ConstantArray[preExpandedImagingStrategies, Length[ToList[listedSamples]]],
        If[!MatchQ[preExpandedImagingChannels, _List],
          ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          preExpandedImagingChannels
        ],
        If[!MatchQ[preExpandedExposureTimes, _List],
          ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          preExpandedExposureTimes
        ]
      },
    MatchQ[preExpandedImagingStrategies, {BrightField..}] && EqualQ[Length[preExpandedImagingStrategies], Length@ToList[listedSamples]],
      (* If a singleton value is given and not collapsed *)
      (* Example: samples:{s1,s2}, ImagingChannels:{BrightField(for s1),BrightField(for s2)}, ExposureTimes:{Automatic|10ms(for s1),Automatic|10ms(for s2)}*)
      {
        preExpandedImagingStrategies,
        If[!MatchQ[preExpandedImagingChannels, _List],
          ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          preExpandedImagingChannels
        ],
        If[!MatchQ[preExpandedExposureTimes, _List],
          ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          preExpandedExposureTimes
        ]
      },
    MatchQ[preExpandedImagingStrategies, _List] && !MemberQ[preExpandedImagingStrategies, _List],
      (* If it is a list and collapsed *)
      (* Example1: samples:{s1,s2}, ImagingChannels:{{BrightField,400nm}(for s1),{BrightField,400nm}(for s2)}, ExposureTimes:{Automatic|{10ms, 10ms}(for s1),Automatic|{10ms, 10ms}(for s2)}*)
      (* Example2: samples:{s1,s2}, ImagingChannels:{{BrightField(for s1)},{BrightField(for s2)}}, ExposureTimes:{Automatic(for s1),Automatic(for s2)}*)
      {
        ConstantArray[preExpandedImagingStrategies, Length[ToList[listedSamples]]],
        If[!MatchQ[preExpandedImagingChannels, {_List..}],
          ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          preExpandedImagingChannels
        ],
        If[!MatchQ[preExpandedExposureTimes, {_List..}],
          ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          preExpandedExposureTimes
        ]
      },
    MatchQ[preExpandedImagingStrategies, {_List..}],
      (* If a list of values are given and not collapsed *)
      (* Example: samples:{s1,s2}, ImagingChannels:{{BrightField(for s1)},{BrightField, 400nm(for s2)}}, ExposureTimes:{Automatic(for s1),Automatic(for s2)}*)
      {
        preExpandedImagingStrategies,
        Which[
          MatchQ[preExpandedExposureTimes, Automatic],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          And[
            !MatchQ[preExpandedImagingChannels, {_List..}],
            MatchQ[preExpandedImagingChannels, _List] && !MemberQ[preExpandedImagingChannels, _List] && !SameQ @@ preExpandedImagingChannels
          ],
            ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          True,
            preExpandedImagingChannels
        ],
        Which[
          MatchQ[preExpandedExposureTimes, Automatic],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          And[
            !MatchQ[preExpandedExposureTimes, {_List..}],
            MatchQ[preExpandedExposureTimes, _List] && !MemberQ[preExpandedExposureTimes, _List] && !SameQ @@ preExpandedExposureTimes
          ],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          True,
            preExpandedExposureTimes
        ]
      },
    True,
      (* If a mixture of singleton and list of values are given and not collapsed *)
      {
        preExpandedImagingStrategies,
        Which[
          MatchQ[preExpandedExposureTimes, Automatic],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          And[
            !MatchQ[preExpandedImagingChannels, {_List..}],
            MatchQ[preExpandedImagingChannels, _List] && !MemberQ[preExpandedImagingChannels, _List] && !SameQ @@ preExpandedImagingChannels
          ],
            ConstantArray[preExpandedImagingChannels, Length[ToList[listedSamples]]],
          True,
            preExpandedImagingChannels
        ],
        Which[
          MatchQ[preExpandedExposureTimes, Automatic],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          And[
            !MatchQ[preExpandedExposureTimes, {_List..}],
            MatchQ[preExpandedExposureTimes, _List] && !MemberQ[preExpandedExposureTimes, _List] && !SameQ @@ preExpandedExposureTimes
          ],
            ConstantArray[preExpandedExposureTimes, Length[ToList[listedSamples]]],
          True,
            preExpandedExposureTimes
        ]
      }
  ];

  (* Updating imaging options with the manually expanded values *)
  expandedSafeOps = Join[
    Last[
      ExpandIndexMatchedInputs[
        ExperimentImageColonies,
        {ToList[listedSamples]},
        Normal@KeyDrop[inheritedOptions, {ImagingStrategies, ImagingChannels, ExposureTimes}]
      ]
    ],
    {
      ImagingStrategies -> manuallyExpandedImagingStrategies,
      ImagingChannels -> manuallyExpandedImagingChannels,
      ExposureTimes -> manuallyExpandedExposureTimes
    }
  ];

  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* Combine our downloaded and simulated cache. *)
  (* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
  cache = Lookup[expandedSafeOps, Cache, {}];

  (* Default instrument model. *)
  defaultInstrumentObjects = {
    Model[Instrument, ColonyHandler, "id:mnk9jORxz0El"](*"QPix 420 HT"*)
  };

  (* All the objects. *)
  (* NOTE: Include the default samples, containers, methods and instruments that we can use since we want their packets as well. *)
  allObjects = DeleteDuplicates@Download[
    Cases[
      Flatten@Join[
        ToList[listedSamples],
        ToList[Lookup[expandedSafeOps, Instrument]],
        defaultInstrumentObjects
      ],
      ObjectP[]
    ],
    Object,
    Date -> Now
  ];

  (* Create the Packet Download syntax for our Object and Model. *)
  objectSampleFields = Union[{Volume, Composition, Media, State, CultureAdhesion, Position, Notebook}, SamplePreparationCacheFields[Object[Sample]]];
  modelSampleFields = Union[{Composition, CultureAdhesion, State}, SamplePreparationCacheFields[Model[Sample]]];
  objectContainerFields = Union[{Notebook}, SamplePreparationCacheFields[Object[Container]]];
  modelContainerFields = SamplePreparationCacheFields[Model[Container]];
  modelInstrumentFields = {Name, Positions, WettedMaterials};

  sampleObjects = Cases[allObjects, ObjectP[Object[Sample]]];
  instrumentObjects = Cases[allObjects, ObjectP[Object[Instrument]]];
  modelInstrumentObjects = Cases[allObjects, ObjectP[Model[Instrument]]];
  objectContainerObjects = Cases[allObjects, ObjectP[Object[Container]]];

  (* Combine our simulated cache and download cache. *)
  downloadedCache = Quiet[
    Download[
      {
        sampleObjects,
        instrumentObjects,
        modelInstrumentObjects,
        objectContainerObjects
      },
      {
        {
          Evaluate[Packet@@objectSampleFields],
          Packet[Model[modelSampleFields]],
          Packet[Composition[[All, 2]][{CellType, CultureAdhesion, DoublingTime}]],
          Packet[Container[objectContainerFields]],
          Packet[Container[Model][modelContainerFields]]
        },
        {
          Packet[Name, Status, Model, Contents],
          Packet[Model[modelInstrumentFields]]
        },
        {
          Evaluate[Packet@@modelInstrumentFields]
        },
        {
          Evaluate[Packet@@objectContainerFields],
          Packet[Model[modelContainerFields]]
        }
      },
      Cache -> cache,
      Simulation -> currentSimulation
    ],
    {Download::FieldDoesntExist, Download::NotLinkField}
  ];

  cacheBall = FlattenCachePackets[{
    cache,
    downloadedCache
  }];

  (* Build the resolved options *)
  resolvedOptionsResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions, resolvedOptionsTests} = resolveExperimentImageColoniesOptions[
      ToList[mySamples],
      expandedSafeOps,
      Cache -> cacheBall,
      Simulation -> currentSimulation,
      Output -> {Result, Tests}
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      {resolvedOptions, resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions, resolvedOptionsTests} = {
        resolveExperimentImageColoniesOptions[
          ToList[mySamples],
          expandedSafeOps,
          Cache -> cacheBall,
          Simulation -> currentSimulation
        ],
        {}
      },
      $Failed,
      {Error::InvalidInput, Error::InvalidOption}
    ]
  ];

  (* Manually collapse ImagingStrategies, ImagingChannels, ExposureTimes. They are NestedIndexMatched to each other but that information is not *)
  (* in their OptionDefinition because there can only be one NestedIndexMatching block per IndexMatching block *)
  (* NOTE: This collapsing logic is mirrored from CollapseIndexMatchedOptions. We know that both options are IndexMatching *)
  (* are currently in an expanded form and are nested index matching *)
  preCollapsedResolvedOptions = Map[
    Function[{option},
      Module[{resolvedOptionRule, inheritedOptionRule},
        resolvedOptionRule = Lookup[resolvedOptions, option];
        inheritedOptionRule = Lookup[inheritedOptions, option];
        Which[
          (* If the option was specified by the user, ignore it *)
          MatchQ[resolvedOptionRule, inheritedOptionRule],
            option -> resolvedOptionRule,
          (* If there is the same singleton pattern across all samples, collapse it to a single singleton value *)
          And[
            MatchQ[resolvedOptionRule, _List],
            !MemberQ[resolvedOptionRule, _List],
            SameQ @@ Flatten[ToList[resolvedOptionRule], 1]
          ],
            option -> First[ToList[resolvedOptionRule]],
          (* If there is the same list pattern across all nested lists, collapse it to a list value *)
          MatchQ[resolvedOptionRule, {_List..}] && SameQ @@ resolvedOptionRule, option -> First[resolvedOptionRule],
          (* Otherwise, this means the option is not the same across all nested lists, so leave it alone *)
          True, option -> resolvedOptionRule
        ]
      ]
    ],
    {ImagingStrategies, ImagingChannels, ExposureTimes}
  ];

  (* Collapse the resolved options *)
  collapsedResolvedOptions = Join[
    CollapseIndexMatchedOptions[
      ExperimentImageColonies,
      Normal@KeyDrop[resolvedOptions, {ImagingStrategies, ImagingChannels, ExposureTimes}],
      Ignore -> ToList[myOptions],
      Messages -> False
    ],
    {
      ImagingStrategies -> Lookup[preCollapsedResolvedOptions, ImagingStrategies],
      ImagingChannels -> Lookup[preCollapsedResolvedOptions, ImagingChannels],
      ExposureTimes -> Lookup[preCollapsedResolvedOptions, ExposureTimes]
    }
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult, $Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentImageColonies, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> currentSimulation
    }]
  ];

  (* Run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed],
      True,
    gatherTests,
      Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True,
      False
  ];

  (* Figure out if we need to perform our simulation. *)
  (* NOTE: We need to perform simulation if Result is asked for in Pick since it's part of the CellPreparation experiments. *)
  (* This is because we pass down our simulation to ExperimentRCP. *)
  performSimulationQ = MemberQ[output, Result|Simulation];

  (* If option resolution failed, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
      Options -> RemoveHiddenOptions[ExperimentImageColonies, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> currentSimulation
    }]
  ];

  (* Build packets with resources *)
  (* NOTE: Don't actually run our resource packets function if there was a problem with our option resolving. *)
  (* NOTE: Because ImageColonies can currently only happen robotically, resourcePackets only contains UnitOperationPackets *)
  {{unitOperationPacket, batchedUnitOperationPackets, runTime}, resourcePacketTests} = If[returnEarlyQ,
    {{$Failed, $Failed, $Failed}, {}},
    If[gatherTests,
      imageColoniesResourcePackets[listedSamples, expandedSafeOps, resolvedOptions, ExperimentImageColonies, Cache -> cacheBall, Simulation -> currentSimulation, Output -> {Result, Tests}],
      {imageColoniesResourcePackets[listedSamples, expandedSafeOps, resolvedOptions, ExperimentImageColonies, Cache -> cacheBall, Simulation -> currentSimulation], {}}
    ]
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  (* If option resolver fails, return Null *)
  updatedSimulation = If[!returnEarlyQ && performSimulationQ,
    simulateExperimentImageColonies[unitOperationPacket, listedSamples, resolvedOptions, ExperimentImageColonies, Cache -> cacheBall, Simulation -> currentSimulation],
    currentSimulation
  ];

  (* If Result does not exist in the output, return everything without uploading *)
  If[!MemberQ[output, Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentImageColonies, collapsedResolvedOptions],
      Preview -> Null,
      Simulation -> updatedSimulation
    }]
  ];

  (* Lookup if we are supposed to upload *)
  uploadQ = Lookup[safeOps, Upload];

  (* Gather all the unit operation packets *)
  allUnitOperationPackets = Flatten[{unitOperationPacket,batchedUnitOperationPackets}];

  (* We have to return our result. Either return a protocol with a simulated procedure if SimulateProcedure\[Rule]True or return a real protocol that's ready to be run. *)
  protocolObject = Which[
    (* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
    MatchQ[unitOperationPacket, $Failed] || MatchQ[resolvedOptionsResult, $Failed],
      $Failed,

    (* If Upload->False, return the unit operation packets without RequireResources called*)
    !uploadQ,
      allUnitOperationPackets,

    (* Otherwise, upload an ExperimentRoboticCellPreparation *)
    True,
      Module[
        {
          primitive, nonHiddenOptions
        },
        (* Create the ImageColonies primitive to feed into RoboticCellPreparation *)
        primitive = ImageColonies@@Join[
          {
            Sample -> Download[ToList[mySamples], Object]
          },
          RemoveHiddenPrimitiveOptions[ImageColonies, ToList[myOptions]]
        ];

        (* Remove any hidden options before returning *)
        nonHiddenOptions = RemoveHiddenOptions[ExperimentImageColonies, collapsedResolvedOptions];

        (* Memoize the value of ExperimentImageColonies so the framework doesn't spend time resolving it again. *)
        Block[{ExperimentImageColonies, $PrimitiveFrameworkResolverOutputCache},
          $PrimitiveFrameworkResolverOutputCache = <||>;

          ExperimentImageColonies[___, options: OptionsPattern[]] := Module[{frameworkOutputSpecification},
            (* Lookup the output specification the framework is asking for *)
            frameworkOutputSpecification = Lookup[ToList[options], Output];

            frameworkOutputSpecification/.{
              Result ->  allUnitOperationPackets,
              Options -> nonHiddenOptions,
              Preview -> Null,
              Simulation -> updatedSimulation,
              RunTime -> runTime
            }
          ];
          (* Note: we override postprocessing options to False since ImageColonies is postprocessing for bio *)
          ExperimentRoboticCellPreparation[
            {primitive},
            Name -> Lookup[safeOps, Name],
            Instrument -> Lookup[collapsedResolvedOptions, Instrument],
            Upload -> Lookup[collapsedResolvedOptions, Upload],
            ImageSample -> False,
            MeasureVolume -> False,
            MeasureWeight -> False,
            Confirm -> Lookup[collapsedResolvedOptions, Confirm],
            CanaryBranch -> Lookup[collapsedResolvedOptions, CanaryBranch],
            ParentProtocol -> Lookup[collapsedResolvedOptions, ParentProtocol],
            Priority -> Lookup[collapsedResolvedOptions, Priority],
            StartDate -> Lookup[collapsedResolvedOptions, StartDate],
            HoldOrder -> Lookup[collapsedResolvedOptions, HoldOrder],
            QueuePosition -> Lookup[collapsedResolvedOptions, QueuePosition],
            Cache -> cacheBall
          ]
        ]
      ]
  ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentImageColonies, collapsedResolvedOptions],
    Preview -> Null,
    Simulation -> updatedSimulation,
    RunTime -> runTime
  }
];

(* Container Overload *)
ExperimentImageColonies[myContainers: ListableP[ObjectP[{Object[Container], Object[Sample]}]|_String|{LocationPositionP, _String|ObjectP[Object[Container]]}], myOptions: OptionsPattern[ExperimentImageColonies]] := Module[
  {
    outputSpecification, output, gatherTests, listedInputs, listedOptions, updatedSimulation, containerToSampleResult,
    containerToSampleOutput, containerToSampleSimulation, containerToSampleTests, samples, sampleOptions
  },

  (* Determine the requested return value from the function. *)
  outputSpecification = Quiet[OptionValue[Output]];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests. *)
  gatherTests = MemberQ[output, Tests];

  (* Make sure we're working with a list of options/inputs. *)
  {listedInputs, listedOptions} = {ToList[myContainers], ToList[myOptions]};

  (* Lookup simulation option if it exists *)
  updatedSimulation = Lookup[listedOptions, Simulation, Null];

  (* Note: we do not have sample prep options, not check validSamplePrep here *)

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult = If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
      ExperimentImageColonies,
      listedInputs,
      listedOptions,
      Output -> {Result, Tests, Simulation},
      Simulation -> updatedSimulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
        ExperimentImageColonies,
        listedInputs,
        listedOptions,
        Output -> {Result, Simulation},
        Simulation -> updatedSimulation
      ],
      $Failed,
      {Download::ObjectDoesNotExist, Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];

  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult, $Failed],
    (* If containerToSampleOptions failed - return $Failed. *)
    outputSpecification/.{
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> updatedSimulation,
      InvalidInputs -> {},
      InvalidOptions -> {}
    },
    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentImageColonies[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
  ]
];


(* ::Subsection::Closed:: *)
(*Option Resolver*)

(* ::Subsubsection::Closed:: *)
(*resolveExperimentImageColoniesOptions*)


(* ::Code::Initialization:: *)
DefineOptions[
  resolveExperimentImageColoniesOptions,
  Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentImageColoniesOptions[mySamples: {ObjectP[Object[Sample]]...}, myOptions: {_Rule...}, myResolutionOptions: OptionsPattern[resolveExperimentImageColoniesOptions]] := Module[
  {
    (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
    outputSpecification, output, gatherTests, messages, cacheBall, currentSimulation, imageColoniesOptionsAssociation,
    samplePackets, sampleModelPackets, sampleContainerPackets, sampleContainerModelPackets, combinedFastAssoc,
    (*-- INPUT VALIDATION CHECKS --*)
    mainCellIdentityModels, sampleCellTypes, validCellTypeQs, invalidCellTypeSamples, invalidCellTypePositions,
    invalidCellTypeCellTypes, invalidCellTypeTest, discardedSamplePackets, discardedInvalidInputs, discardedTest,
    deprecatedSampleModelPackets, deprecatedInvalidInputs, deprecatedTest, nonSolidSamplePackets, nonSolidInvalidInputs,
    nonSolidTest, validContainerSampleQ, invalidContainerSampleInputs, invalidContainerTest, duplicatedInvalidInputs,
    duplicatesTest, compatibleMaterialsBools, compatibleMaterialsTests,
    (*-- OPTION PRECISION CHECKS --*)
    optionPrecisions, roundedImageColoniesOptions, optionPrecisionTests,
    (*-- RESOLVE INDEPENDENT OPTIONS --*)
    resolvedPreparation, resolvedWorkCell, resolvedInstrument,
    (*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)
    mapThreadFriendlyOptions, resolvedSampleLabels, resolvedSampleContainerLabels, strategiesMappingToChannels,
    missingBrightFieldErrors, imagingOptionSameLengthErrors, resolvedImagingChannels, resolvedImagingStrategies, resolvedExposureTimes,
    (* -- CONFLICTING OPTIONS CHECKS -- *)
    missingBrightFieldOptions, missingBrightFieldTests, duplicateImagingStrategiesTests, imagingOptionSameLengthOptions,
    imagingOptionSameLengthTests,
    (*-- SUMMARY OF CHECKS --*)
    specifiedOperator, upload, specifiedEmail, specifiedName, resolvedEmail, resolvedOperator, nameInvalidBool,
    nameInvalidOption, nameInvalidTest, invalidInputs, invalidOptions, allTests, resolvedOptions
  },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification = OptionValue[Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output, Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  cacheBall = Lookup[ToList[myResolutionOptions], Cache, {}];
  (* Initialize the simulation if none exists *)
  currentSimulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

  (* Note: There is no sample prep options, no resolveSamplePrpOptionsNew is needed here *)

  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  imageColoniesOptionsAssociation = Association[myOptions];

  (* Create combined fast assoc *)
  combinedFastAssoc = makeFastAssocFromCache[cacheBall];

  (* Pull out packets from the fast association *)
  samplePackets = fetchPacketFromFastAssoc[#, combinedFastAssoc]& /@ mySamples;
  sampleModelPackets = fastAssocPacketLookup[combinedFastAssoc, #, Model]& /@ mySamples;
  sampleContainerPackets = fastAssocPacketLookup[combinedFastAssoc, #, Container]& /@ mySamples;
  sampleContainerModelPackets = fastAssocPacketLookup[combinedFastAssoc, #, {Container, Model}]& /@ mySamples;

  (*-- INPUT VALIDATION CHECKS --*)

  (*--Unsupported Cell Type check--*)
  (* Get whether the input cell types are supported *)

  (* first get the main cell object in the composition; if this is a mixture it will pick the one with the highest concentration *)
  mainCellIdentityModels = selectMainCellFromSample[mySamples, Cache -> cacheBall, Simulation -> currentSimulation];

  (* Determine what kind of cells the input samples are *)
  sampleCellTypes = lookUpCellTypes[samplePackets, sampleModelPackets, mainCellIdentityModels, Cache -> cacheBall];

  (* Note here that Null is acceptable because we can image empty omni tray to check contamination *)
  validCellTypeQs = MatchQ[#, Yeast|Bacterial|Null]& /@ sampleCellTypes;
  invalidCellTypeSamples = Lookup[PickList[samplePackets, validCellTypeQs, False], Object, {}];
  invalidCellTypePositions = First /@ Position[validCellTypeQs, False];
  invalidCellTypeCellTypes = PickList[sampleCellTypes, validCellTypeQs, False];

  If[Length[invalidCellTypeSamples] > 0 && messages,
    Message[Error::UnsupportedColonyTypes, ObjectToString[invalidCellTypeSamples, Cache -> cacheBall], invalidCellTypePositions, invalidCellTypeCellTypes, "ExperimentImageColonies", "ExperimentImageCells"]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  invalidCellTypeTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[invalidCellTypeSamples] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[invalidCellTypeSamples, Cache -> cacheBall] <> " are of supported cell types (Bacterial or Yeast):", True, False]
      ];

      passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidCellTypeSamples], Cache -> cacheBall] <> " are of supported cell types (Bacterial or Yeast):", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Discarded input check--*)
  (* Get the samples from mySamples that are discarded. *)
  discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
    {},
    Lookup[discardedSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs] >0 && messages,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[discardedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
      ];

      passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];


  (*--Deprecated input check--*)
  (* Get the model packets from simulatedSamples that are deprecated *)
  deprecatedSampleModelPackets = Cases[sampleModelPackets, KeyValuePattern[Deprecated -> True]];

  (* Set deprecatedInvalidInputs to the input objects whose models are Deprecated. *)
  deprecatedInvalidInputs = If[MatchQ[deprecatedSampleModelPackets, {}],
    {},
    PickList[samplePackets, sampleModelPackets, KeyValuePattern[Deprecated -> True]]
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
  If[Length[deprecatedInvalidInputs]>0 && messages,
    Message[Error::DeprecatedModels, ObjectToString[Lookup[deprecatedSampleModelPackets, Object], Cache -> cacheBall]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  deprecatedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[deprecatedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall] <> " that are not deprecated:", True, False]
      ];

      passingTest = If[Length[deprecatedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples have models " <> ObjectToString[Complement[mySamples, deprecatedInvalidInputs], Cache -> cacheBall] <> " that are not deprecated:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Non Solid input check--*)
  (* Get the samples from mySamples that do not have Solid state *)
  nonSolidSamplePackets = Cases[samplePackets, KeyValuePattern[State -> Except[Solid]]];

  (* Set nonSolidInvalidInputs to the input objects whose state is not Solid *)
  nonSolidInvalidInputs = Lookup[nonSolidSamplePackets, Object, {}];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[nonSolidInvalidInputs] > 0 && messages,
    Message[Error::NonSolidSamples, ObjectToString[nonSolidInvalidInputs, Cache -> cacheBall]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  nonSolidTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[nonSolidInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[nonSolidInvalidInputs, Cache -> cacheBall] <> " are Solid State:", True, False]
      ];

      passingTest = If[Length[nonSolidInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, nonSolidInvalidInputs], Cache -> cacheBall] <> " are Solid State:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Invalid Input Container Model check--*)
  (* Make sure all input containers are SBS plates and only has 1 well *)
  validContainerSampleQ = validqPixContainer[sampleContainerModelPackets];

  invalidContainerSampleInputs =  If[MemberQ[validContainerSampleQ, False],
    PickList[samplePackets, validContainerSampleQ, False],
    {}
  ];

  (* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
  If[Length[invalidContainerSampleInputs] >0 && messages,
    Message[Error::NonOmniTrayContainer, ObjectToString[invalidContainerSampleInputs, Cache -> cacheBall]];
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  invalidContainerTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[invalidContainerSampleInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[invalidContainerSampleInputs, Cache -> cacheBall] <> " in a SBS format plate:", True, False]
      ];

      passingTest = If[Length[invalidContainerSampleInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidContainerSampleInputs], Cache -> cacheBall] <> " in a SBS format plate:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*--Duplicated Input check--*)
  (* - Check if samples are duplicated (ImageColonies does not handle replicates.) - *)
  (* Get the samples that are duplicated. *)
  duplicatedInvalidInputs = Cases[Tally[mySamples], {_, Except[1]}][[All, 1]];

  (* If there are invalid inputs and we are throwing messages, throw an error message .*)
  If[Length[duplicatedInvalidInputs] > 0 && !gatherTests,
    Message[Error::DuplicatedSamples, ObjectToString[duplicatedInvalidInputs, Cache -> cacheBall], "ExperimentImageColonies"]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  duplicatesTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[duplicatedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[duplicatedInvalidInputs, Cache -> cacheBall]<>" are not listed more than once:", True, False]
      ];

      passingTest = If[Length[duplicatedInvalidInputs] == Length[mySamples],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[mySamples, duplicatedInvalidInputs], Cache -> cacheBall] <> " are not listed more than once:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];
  (*-- OPTION PRECISION CHECKS --*)
  (* Define the option precisions that need to be checked for ImageColonies *)
  optionPrecisions = {
    {ExposureTimes, 10^0*Millisecond}
  };

  (* Check the precisions of these options. *)
  {roundedImageColoniesOptions, optionPrecisionTests} = If[gatherTests,
    (*If we are gathering tests *)
    RoundOptionPrecision[imageColoniesOptionsAssociation, optionPrecisions[[All,1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
    (* Otherwise *)
    {RoundOptionPrecision[imageColoniesOptionsAssociation, optionPrecisions[[All,1]], optionPrecisions[[All, 2]]], {}}
  ];


  (*--- Resolve non-IndexMatching General options ---*)
  (* Resolve Preparation and WorkCell - currently this function is only robotic on the qPix *)
  resolvedPreparation = FirstOrDefault@resolveImageColoniesMethod[mySamples, myOptions];
  resolvedWorkCell = FirstOrDefault@resolveImageColoniesWorkCell[mySamples, myOptions];

  (* Resolve the Instrument Option *)
  resolvedInstrument = Lookup[roundedImageColoniesOptions, Instrument];

  (* Note: currently ImagingChannels is not a field for colony handler instrument model or objects, and both sites have full channels *)
  (* so we do not have any conflicting instrument option check. Future instrument check can be added here. *)

  (* Check that the input samples are compatible with the wetted materials of the resolved instrument *)
  {compatibleMaterialsBools, compatibleMaterialsTests} = If[gatherTests,
    CompatibleMaterialsQ[
      resolvedInstrument,
      mySamples,
      OutputFormat -> Boolean,
      Output -> {Result, Tests},
      Cache -> cacheBall,
      Simulation -> currentSimulation
    ],
    {
      CompatibleMaterialsQ[
        resolvedInstrument,
        mySamples,
        OutputFormat -> Boolean,
        Messages -> messages,
        Cache -> cacheBall,
        Simulation -> currentSimulation],
      {}
    }
  ];

  (*-- RESOLVE MAPTHREAD EXPERIMENT OPTIONS --*)
  (* Convert our options into a MapThread friendly version. *)
  (* NOTE: Imaging options have been properly expanded in the core function, and everything should be index matching *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentImageColonies, roundedImageColoniesOptions, AmbiguousNestedResolution -> IndexMatchingOptionPreferred];

  (* Resolve label options *)
  resolvedSampleLabels = Module[
    {specifiedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelLookup},

    (* Create a unique label for each unique sample in the input *)
    specifiedSampleObjects = Lookup[samplePackets, Object];
    uniqueSamples = DeleteDuplicates[specifiedSampleObjects];
    preResolvedSampleLabels = Table[CreateUniqueLabel["image colonies input sample"], Length[uniqueSamples]];
    preResolvedSampleLabelLookup = MapThread[
      (#1 -> #2)&,
      {uniqueSamples, preResolvedSampleLabels}
    ];

    (* Expand the sample-specific unique labels *)
    MapThread[
      Function[{object, label},
        Which[
          (* respect user specification *)
          MatchQ[label, Except[Automatic]], label,
          (* respect upstream LabelSample/LabelContainer input *)
          MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, object], _String], LookupObjectLabel[currentSimulation, object],
          (* get a label from the lookup *)
          True, Lookup[preResolvedSampleLabelLookup, object]
        ]
      ],
      {specifiedSampleObjects, Lookup[myOptions, SampleLabel]}
    ]
  ];

  resolvedSampleContainerLabels = Module[
    {specifiedContainerObjects, uniqueContainers, preResolvedSampleContainerLabels, preResolvedContainerLabelLookup},
    (* Create a unique label for each unique container in the input *)
    specifiedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
    uniqueContainers = DeleteDuplicates[specifiedContainerObjects];
    preResolvedSampleContainerLabels = Table[CreateUniqueLabel["image colonies input sample container"], Length[uniqueContainers]];
    preResolvedContainerLabelLookup = MapThread[
      (#1 -> #2)&,
      {uniqueContainers, preResolvedSampleContainerLabels}
    ];

    (* Expand the sample-specific unique labels *)
    MapThread[
      Function[{object, label},
        Which[
          (* respect user specification *)
          MatchQ[label, Except[Automatic]], label,
          (* respect upstream LabelSample/LabelContainer input *)
          MatchQ[currentSimulation, SimulationP] && MatchQ[LookupObjectLabel[currentSimulation, object], _String], LookupObjectLabel[currentSimulation, object],
          (* get a label from the lookup *)
          True, Lookup[preResolvedContainerLabelLookup, object]
        ]
      ],
      {specifiedContainerObjects, Lookup[myOptions, SampleContainerLabel]}
    ]
  ];

  (* Lookup table for each imaging strategy what imaging channel it is corresponding to *)
  strategiesMappingToChannels = {
    BlueWhiteScreen -> 400 Nanometer,
    VioletFluorescence -> {377 Nanometer, 447 Nanometer},
    GreenFluorescence -> {457 Nanometer, 536 Nanometer},
    OrangeFluorescence -> {531 Nanometer, 593 Nanometer},
    RedFluorescence -> {531 Nanometer, 624 Nanometer},
    DarkRedFluorescence -> {628 Nanometer, 692 Nanometer}
  };

  (* MapThread over each of our samples *)
  {
    missingBrightFieldErrors,
    imagingOptionSameLengthErrors,
    resolvedImagingChannels,
    resolvedImagingStrategies,
    resolvedExposureTimes
  } = Transpose[
    Map[
      Function[{myMapThreadOptions},
        Module[
          {
            (* -- ERROR TRACKING VARIABLES -- *)
            missingBrightFieldError, imagingOptionSameLengthError,
            (* Imaging *)
            specifiedImagingStrategies, specifiedExposureTimes, updatedImagingChannels, updatedExposureTimes
          },

          (* Look up the option values *)
          {
            specifiedImagingStrategies,
            specifiedExposureTimes
          } = Lookup[
            myMapThreadOptions,
            {
              ImagingStrategies,
              ExposureTimes
            }
          ];

          (* Resolve imaging options *)
          (* Currently there is default value as BrightField if nothing is specified for ImagingStrategies *)
          updatedImagingChannels = specifiedImagingStrategies/.strategiesMappingToChannels;

          updatedExposureTimes = Which[
            !MatchQ[specifiedExposureTimes, Automatic],
              specifiedExposureTimes,
            MatchQ[specifiedImagingStrategies, QPixImagingStrategiesP],
              (* If ImagingStrategies is a single value, ExposureTime should also be a single value *)
              Automatic,
            True,
              (* If ImagingStrategies is a list, ExposureTime should also be a list *)
              ConstantArray[Automatic, Length[specifiedImagingStrategies]]
          ];

          (* Check errors *)
          (* If there is no BrightField imaging channel specified, mark the warning *)
          missingBrightFieldError = !MemberQ[ToList[specifiedImagingStrategies], BrightField];

          (* Check that ImagingStrategies and ExposureTimes are the same length manually *)
          (* There is an imagingOption mismatch error if ImagingStrategies -> single channel and ExposureTimes -> list of times or *)
          (* ImagingStrategies -> list of channels and ExposureTimes -> single time *)
          imagingOptionSameLengthError = Or[
            MatchQ[specifiedImagingStrategies, QPixImagingStrategiesP] && MatchQ[updatedExposureTimes, _List],
            MatchQ[specifiedImagingStrategies, {QPixImagingStrategiesP..}] && MatchQ[updatedExposureTimes, _Real],
            !EqualQ[Length[ToList[specifiedImagingStrategies]], Length[ToList[updatedExposureTimes]]]
          ];

          (* Gather MapThread results *)
          {
            missingBrightFieldError,
            imagingOptionSameLengthError,
            updatedImagingChannels,
            specifiedImagingStrategies,
            updatedExposureTimes
          }
        ]
      ],
      mapThreadFriendlyOptions
    ]
  ];

  (* -- MAPTHREAD ERROR MESSAGES -- *)
  (* MissingBrightFieldImagingChannels *)
  missingBrightFieldOptions = If[MemberQ[missingBrightFieldErrors, True] && messages,
    Message[
      Error::MissingBrightField,
      PickList[mySamples, missingBrightFieldErrors],
      PickList[resolvedImagingStrategies, missingBrightFieldErrors]
    ];
    {ImagingStrategies},
    {}
  ];

  missingBrightFieldTests = If[MemberQ[missingBrightFieldErrors, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, missingBrightFieldErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The input samples " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " have BrightField specified in ImagingStrategies:", True, True];

      (* Create the failing test *)
      failingTest = Test["The input samples " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " do not have BrightField specified in ImagingStrategies:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];

  (* Imaging Option Same Length *)
  imagingOptionSameLengthOptions = If[MemberQ[imagingOptionSameLengthErrors, True] && messages,
    Message[Error::ImagingOptionMismatch, PickList[mySamples, imagingOptionSameLengthErrors]];
    {ImagingStrategies, ExposureTimes},
    {}
  ];

  imagingOptionSameLengthTests = If[MemberQ[imagingOptionSameLengthErrors, True] && gatherTests,
    Module[{passingInputs, failingInputs, passingTest, failingTest},

      (* Get the failing inputs *)
      failingInputs = PickList[mySamples, imagingOptionSameLengthErrors];

      (* Get the passing inputs *)
      passingInputs = Complement[mySamples, failingInputs];

      (* Create the passing test *)
      passingTest = Test["The imaging options for the input samples " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " have the same length:", True, True];

      (* Create the failing test *)
      failingTest = Test["The imaging options for the input samples " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " have the same length:", True, False];

      (* Return the tests *)
      {passingTest, failingTest}
    ],
    Nothing
  ];


  (*---SHARED OPTIONS AND CHECKS---*)
  (* NOTE: there is no Aliquot options *)

  (* Get the options needed to resolve Email and Operator and to check for Error::DuplicateName. *)
  {
    specifiedOperator,
    upload,
    specifiedEmail,
    specifiedName
  } = Lookup[myOptions, {Operator, Upload, Email, Name}];

  (* Adjust the email option based on the upload option *)
  resolvedEmail = If[!MatchQ[specifiedEmail, Automatic],
    specifiedEmail,
    upload && MemberQ[output, Result]
  ];

  (* Resolve the operator option. *)
  resolvedOperator = If[NullQ[specifiedOperator], Model[User, Emerald, Operator, "Level 2"], specifiedOperator];

  (* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
  nameInvalidBool = StringQ[specifiedName] && TrueQ[DatabaseMemberQ[Append[Object[Protocol, RoboticCellPreparation], specifiedName]]];

  (* NOTE: unique *)
  (* If the name is invalid, will add it to the list if invalid options later. *)
  nameInvalidOption = If[nameInvalidBool && messages,
    (
      Message[Error::DuplicateName, Object[Protocol, RoboticCellPreparation]];
      {Name}
    ),
    {}
  ];
  nameInvalidTest = If[gatherTests,
    Test["The specified Name is unique:", False, nameInvalidBool],
    Nothing
  ];


  (* Get the final resolved options  *)
  resolvedOptions = ReplaceRule[
    myOptions,
    {
      Instrument -> resolvedInstrument,
      ImagingChannels -> resolvedImagingChannels,
      ImagingStrategies -> resolvedImagingStrategies,
      ExposureTimes -> resolvedExposureTimes,
      Preparation -> resolvedPreparation,
      WorkCell -> resolvedWorkCell,
      SampleLabel -> resolvedSampleLabels,
      SampleContainerLabel -> resolvedSampleContainerLabels,
      Name -> specifiedName,
      Email -> resolvedEmail,
      Operator -> resolvedOperator
    }
  ];

  (*-- SUMMARY OF CHECKS --*)
  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  invalidInputs = DeleteDuplicates[Flatten[
    {
      invalidCellTypeSamples,
      discardedInvalidInputs,
      deprecatedInvalidInputs,
      nonSolidInvalidInputs,
      duplicatedInvalidInputs,
      invalidContainerSampleInputs
    }
  ]];

  invalidOptions = DeleteDuplicates[Flatten[
    {
      nameInvalidOption,
      missingBrightFieldOptions,
      imagingOptionSameLengthOptions,
      If[MemberQ[compatibleMaterialsBools, False],
        {Instrument},
        Nothing
      ]
    }
  ]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Length[invalidInputs] > 0 && messages,
    Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Length[invalidOptions] > 0 && messages,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* Get all the tests together. *)
  allTests = Cases[Flatten[{
    invalidCellTypeTest,
    discardedTest,
    deprecatedTest,
    nonSolidTest,
    duplicatesTest,
    invalidContainerTest,
    optionPrecisionTests,
    missingBrightFieldTests,
    duplicateImagingStrategiesTests,
    imagingOptionSameLengthTests,
    compatibleMaterialsTests,
    nameInvalidTest
  }], TestP];

  (* Return our resolved options and/or tests. *)
  outputSpecification/.{
    Result -> resolvedOptions,
    Tests -> allTests
  }
];


(* ::Subsection:: *)
(*Resource Packets*)
DefineOptions[imageColoniesResourcePackets,
  Options :> {
    HelperOutputOption,
    CacheOption,
    SimulationOption
  }
];

imageColoniesResourcePackets[
  mySamples: {ObjectP[Object[Sample]]..},
  myUnresolvedOptions: {_Rule...},
  myResolvedOptions: {_Rule...},
  experimentFunction: Alternatives[ExperimentImageColonies, ExperimentQuantifyColonies],
  ops:OptionsPattern[imageColoniesResourcePackets]
] := Module[
  {
    unresolvedOptionsNoHidden, resolvedOptionsNoHidden, safeOps, outputSpecification, output, gatherTests, messages,
    simulation, inheritedCache, samplePackets, containerPackets, containers, samplesInResourceReplaceRules,
    samplesInResources, containersNoDupes, sampleContainerResources, containerResourceRules, resolvedPreparation,
    resolvedInstrument, resolvedImagingChannels, toListMultiselectRules, runTime, instrumentResource, opticalFilterResource,
    updatedResolvedOptions, splitOptionPackets, sampleInfoPackets, fastAssoc, unitOpGroupedByImagingParameters, flattenedPhysicalGroups, finalPhysicalGroups,
    flatLightTableContainersPerPhysicalBatch, flatLightTableContainerPlacementsPerPhysicalBatch, lightTableContainerLengthsPerPhysicalBatch,
    batchedUnitOperationPackets, batchedUnitOperationPacketsWithID, outputUnitOperationPacket, rawResourceBlobs,
    resourcesWithoutName, resourceToNameReplaceRules, allResourceBlobs, fulfillable, frqTests, previewRule, optionsRule,
    resultRule, testsRule, currentSimulation
  },

  (* Get the collapsed unresolved index-matching options that don't include hidden options *)
  unresolvedOptionsNoHidden = RemoveHiddenOptions[experimentFunction, myUnresolvedOptions];

  (* Get the collapsed resolved index-matching options that don't include hidden options *)
  (* Ignore to collapse those options that are set in expandedSafeOptions *)
  resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
    experimentFunction,
    RemoveHiddenOptions[experimentFunction, myResolvedOptions],
    Ignore -> myUnresolvedOptions,
    Messages -> False
  ];

  (* Get the safe options for this function *)
  safeOps = SafeOptions[imageColoniesResourcePackets, ToList[ops]];

  (* Determine the requested output format of this function *)
  outputSpecification = Lookup[safeOps, Output];
  output = ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user *)
  gatherTests = MemberQ[output, Tests];
  messages = !gatherTests;

  (* Get the inherited cache *)
  inheritedCache = Lookup[safeOps, Cache, {}];
  simulation = Lookup[safeOps, Simulation, {}];

  (* Initialize the simulation if it does not exist *)
  currentSimulation = If[MatchQ[simulation, SimulationP],
    simulation,
    Simulation[]
  ];

  (* Make the fast association *)
  fastAssoc = makeFastAssocFromCache[inheritedCache];

  (* Pull out the packets from the fast assoc *)
  samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
  containerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;
  containers = Lookup[containerPackets, Object];

  (* --- Make all the resources needed in the experiment --- *)

  (*--Generate the samples in resources--*)
  samplesInResourceReplaceRules = (# -> Resource[Sample -> #, Name -> CreateUUID[]])& /@ DeleteDuplicates[Download[mySamples, Object]];
  samplesInResources = mySamples /. samplesInResourceReplaceRules;

  (* Prepare the container resources *)
  containersNoDupes = DeleteDuplicates[containers];
  sampleContainerResources = Resource[Sample -> #, Name -> ToString[#]]& /@ containersNoDupes;
  containerResourceRules = AssociationThread[containersNoDupes, sampleContainerResources];

  (* Pull out the necessary resolved options that need to be in discrete fields in the protocol object *)
  {
    resolvedPreparation,
    resolvedInstrument,
    resolvedImagingChannels
  } = Lookup[
    myResolvedOptions,
    {
      Preparation,
      If[MatchQ[experimentFunction, ExperimentImageColonies], Instrument, ImagingInstrument],
      ImagingChannels
    }
  ];

  (* We convert singleton value to a list (e.g.,BrightField to {BrightField}) here so they can be split properly for batch unit operations *)
  toListMultiselectRules = Map[
    Function[{optionName},
      If[MatchQ[optionName, ExposureTimes],
        (* NOTE: We use Long Automatic for exposure times in option resolver, but records it as AutoExpose in batchedUO for clarity *)
        optionName -> Map[(ToList[#]/.Automatic -> AutoExpose)&, Lookup[myResolvedOptions, optionName]],
        optionName -> Map[ToList[#]&, Lookup[myResolvedOptions, optionName]]
      ]
    ],
    Join[
      {ImagingStrategies, ImagingChannels, ExposureTimes},
      If[MatchQ[experimentFunction, ExperimentImageColonies], {}, {Populations, PopulationIdentities, PopulationCellTypes}]
    ]
  ];

  (* Update the resolved options with unique imaging options *)
  updatedResolvedOptions = ReplaceRule[myResolvedOptions, toListMultiselectRules];

  (* -- Generate the Instrument Resource -- *)
  (* Calculate the runTime of the experiment *)
  runTime = 20 Minute + 2 Minute* Length[ToList[mySamples]];
  instrumentResource = Resource[Instrument -> resolvedInstrument, Time -> runTime];

  (* If we need to do blue-white screening(Absorbance), create the filter resource. *)
  opticalFilterResource = If[MemberQ[Flatten@resolvedImagingChannels, 400 Nanometer],
    Resource[Sample -> Model[Part, OpticalFilter, "id:aXRlGnRvl8K9"], Rent -> True](*"QPix Chroma Filter"*)
  ];

  (* Next, we need to batch our input samples to create batched unit operations *)
  (* In order to batch the samples we need to gather the information for each sample into packets we can move around *)
  (* Do this by mapthreading the resolved options and then adding sample keys for each packet *)
  splitOptionPackets = OptionsHandling`Private`mapThreadOptions[experimentFunction, updatedResolvedOptions];

  (* Add the sample keys and keep track of the original index of each sample *)
  sampleInfoPackets = MapThread[
    Function[{sample, options, index},
      Merge[{options, <|Sample -> sample, OriginalIndex -> index|>}, First]
    ],
    {mySamples, splitOptionPackets, Range[Length[mySamples]]}
  ];

  (* First, group by Imaging parameters (ImagingChannels and ExposureTimes). *)
  unitOpGroupedByImagingParameters = Values@GroupBy[sampleInfoPackets, Lookup[#, {ImagingChannels, ExposureTimes}]&];

  (* Then, create final physical group by size *)
  (* The ExposureFinding routine only works for up to 2 plates at a time and in order to minimize operator interactions with  *)
  (* the instrument, we want to do the imaging for 2 source plates without having to remove them from the deck *)
  (* In order to achieve this we partition up to groups of 2. *)
  (* Note: each unique physical group such as {sample1Packet,sample2Packet} is in 2 layers of list {{{sample1Packet,sample2Packet}},{{sample3Packet,sample4Packet}}} *)
  flattenedPhysicalGroups = Flatten[Map[Partition[#, UpTo[2]]&, unitOpGroupedByImagingParameters], 1];
  finalPhysicalGroups = Thread[List[flattenedPhysicalGroups]];

  (* For each batched unit operations, create a list of the source containers that are a part of the physical batch *)
  (* as well as a list of batching lengths so we can batch loop in the procedure *)
  {
    flatLightTableContainersPerPhysicalBatch,
    flatLightTableContainerPlacementsPerPhysicalBatch,
    lightTableContainerLengthsPerPhysicalBatch
  } = Transpose@Map[
    Function[{physicalGroupPackets},
      Module[{lightTableContainerPlacements},
        (* Determine the light table container placements from the physical group *)
        lightTableContainerPlacements = MapIndexed[
          Function[{samplePacket, index},
            {Link[Lookup[samplePacket, Sample]], {"QPix LightTable Slot", "A1", First[index] /. {1 -> "A1", 2 -> "B1"}}}
          ],
          physicalGroupPackets
        ];

        {
          Download[Lookup[physicalGroupPackets, Sample], Object],
          lightTableContainerPlacements,
          {Length@physicalGroupPackets}
        }
      ]
    ],
    flattenedPhysicalGroups
  ];

  (* For each physical batch, create a batched unit operation packet that contains the information to pass through to the procedure *)
  (* Note: field BatchedSourceContainerLengths is in 1 layer of list, for the same example above, value should be {{2}} *)
  batchedUnitOperationPackets = MapThread[
    Function[{physicalBatchSamplePackets, flatLightTableContainers, flatLightTableContainerPlacements, lightTableContainerLengths},
      <|
        Type -> If[MatchQ[experimentFunction, ExperimentImageColonies], Object[UnitOperation, ImageColonies], Object[UnitOperation, QuantifyColonies]],
        UnitOperationType -> Batched,
        Replace[FlatBatchedSourceContainers] -> (Link /@ flatLightTableContainers /. samplesInResourceReplaceRules),
        Replace[FlatBatchedSourceContainerPlacements] -> flatLightTableContainerPlacements /. samplesInResourceReplaceRules,
        Replace[BatchedSourceContainerLengths] -> lightTableContainerLengths,
        (* Note: the imaging parameters are after removing duplicated imaging channels *)
        Replace[FlatBatchedImagingChannels] -> Lookup[physicalBatchSamplePackets, ImagingChannels],
        Replace[FlatBatchedExposureTimes] -> Lookup[physicalBatchSamplePackets, ExposureTimes],
        Replace[FlatBatchedSamplesInStorageConditions] -> Lookup[physicalBatchSamplePackets, SamplesInStorageCondition]
      |>
    ],
    {
      flattenedPhysicalGroups,
      flatLightTableContainersPerPhysicalBatch,
      flatLightTableContainerPlacementsPerPhysicalBatch,
      lightTableContainerLengthsPerPhysicalBatch
    }
  ];


  (* Currently, our batched unit operation packets do not have id's, give them ids but only call  *)
  (* CreateID a single time *)
  batchedUnitOperationPacketsWithID = Module[{unitOperationType,batchedUnitOperationNewObjects},

    (* Get the Unit Operation type from the experiment function *)
    unitOperationType = If[MatchQ[experimentFunction, ExperimentImageColonies], Object[UnitOperation, ImageColonies], Object[UnitOperation, QuantifyColonies]];

    (* Use a single CreateID call to limit the number of times we contact the db *)
    batchedUnitOperationNewObjects = CreateID[ConstantArray[unitOperationType, Length[batchedUnitOperationPackets]]];

    (* Add a unique object to each packet *)
    MapThread[
      Function[{batchedUnitOpPacket, object},
        Append[batchedUnitOpPacket, Object -> object]
      ],
      {
        batchedUnitOperationPackets,
        batchedUnitOperationNewObjects
      }
    ]
  ];

  (* Create the pick colonies unit operation *)
  outputUnitOperationPacket = UploadUnitOperation[
    Module[{nonHiddenOptions, unitOpHead},
      (* Only include non-hidden options from ExperimentImageColonies. *)
      nonHiddenOptions = Lookup[
        Cases[OptionDefinition[experimentFunction], KeyValuePattern["Category" -> Except["Hidden"]]],
        "OptionSymbol"
      ];

      (* Get the unit operation head *)
      unitOpHead = If[MatchQ[experimentFunction, ExperimentImageColonies],
        ImageColonies,
        QuantifyColonies
      ];

      (* Join the Sample Key, Developer fields, and resolved options into a single unit op *)
      unitOpHead @@ Join[
        {
          Sample -> samplesInResources,
          BatchedUnitOperations -> (Link /@ Lookup[batchedUnitOperationPacketsWithID, Object]),
          PhysicalBatchingGroups -> finalPhysicalGroups,
          AbsorbanceFilter -> Link[opticalFilterResource]
        },

        (* Put all of our resources in *)
        (* Note:we are using Long Automatic for ExposureTimes but record it as Null in UO *)
        ReplaceRule[
          Cases[Normal[myResolvedOptions], Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
          {
            If[MatchQ[experimentFunction, ExperimentImageColonies],
              Instrument -> instrumentResource,
              ImagingInstrument -> instrumentResource
            ],
            ExposureTimes -> (Lookup[myResolvedOptions, ExposureTimes]/. Automatic -> Null)
          }
        ]
      ]
    ],
    Preparation -> Robotic,
    UnitOperationType -> Output,
    FastTrack -> True,
    Upload -> False
  ];

  (* Update the simulation *)
  currentSimulation = UpdateSimulation[
    currentSimulation,
    Simulation[
      Packets -> {
        <|
          Object->SimulateCreateID[Object[Protocol, RoboticCellPreparation]],
          Replace[OutputUnitOperations] -> (Link[Lookup[outputUnitOperationPacket, Object], Protocol]),
          ResolvedOptions -> {}
        |>
      }
    ]
  ];

  (*--Gather all the resource symbolic representations--*)

  (* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
  rawResourceBlobs = DeleteDuplicates[Cases[{outputUnitOperationPacket, batchedUnitOperationPackets}, _Resource, Infinity]];

  (* Get all resources without a name *)
  resourcesWithoutName = DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False]&)]]];
  resourceToNameReplaceRules = MapThread[#1 -> #2&,{resourcesWithoutName, (Resource[Append[#[[1]], Name -> CreateUUID[]]]&) /@ resourcesWithoutName}];
  allResourceBlobs = rawResourceBlobs/.resourceToNameReplaceRules;


  (*---Call fulfillableResourceQ on all the resources we created---*)
  {fulfillable, frqTests} = Which[
    MatchQ[$ECLApplication,Engine], {True, {}},
    (* When Preparation->Robotic, the framework will call FRQ for us *)
    MatchQ[resolvedPreparation, Robotic], {True, {}},
    gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Cache -> inheritedCache, Simulation -> currentSimulation],
    True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Messages -> messages, Cache -> inheritedCache, Simulation -> currentSimulation], Null}
  ];


  (*---Return our options, packets, and tests---*)

  (* Generate the preview output rule; Preview is always Null *)
  previewRule = Preview -> Null;

  (* Generate the options output rule *)
  optionsRule = Options -> If[MemberQ[output, Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the result output rule: if not returning result, or the resources are not fulfillable, result rule is just $Failed *)
  resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
    {outputUnitOperationPacket, batchedUnitOperationPacketsWithID, runTime}/.resourceToNameReplaceRules,
    $Failed
  ];

  (* Generate the tests output rule *)
  testsRule = Tests -> If[gatherTests,
    frqTests,
    {}
  ];

  (* Return the output as we desire it *)
  outputSpecification/.{previewRule, optionsRule, resultRule, testsRule}
];


(* ::Subsection:: *)
(*Simulation Function*)
DefineOptions[simulateExperimentImageColonies,
  Options :> {CacheOption, SimulationOption}
];

simulateExperimentImageColonies[
  myUnitOperationPacket: (PacketP[{Object[UnitOperation, ImageColonies], Object[UnitOperation, QuantifyColonies]}]|Null|$Failed),
  mySamples: {ObjectP[Object[Sample]]..},
  myResolvedOptions: {_Rule..},
  experimentFunction: Alternatives[ExperimentImageColonies, ExperimentQuantifyColonies],
  myResolutionOptions: OptionsPattern[simulateExperimentImageColonies]
] := Module[
  {
    inheritedCache, currentSimulation, inheritedFastAssoc, testProtocolObject, protocolPacket
  },

  (* Get simulation and cache *)
  {inheritedCache, currentSimulation} = Lookup[ToList[myResolutionOptions], {Cache, Simulation}, {}];

  (* Create a faster version of the cache to improve speed *)
  inheritedFastAssoc = makeFastAssocFromCache[inheritedCache];

  (* Simulate a protocol ID. *)
  testProtocolObject = SimulateCreateID[Object[Protocol, RoboticCellPreparation]];

  (* Make a test protocol packet *)
  protocolPacket = <|
    Object -> testProtocolObject,
    Replace[OutputUnitOperations] -> If[MatchQ[myUnitOperationPacket, PacketP[]], {Link[myUnitOperationPacket, Protocol]}, {}],
    ResolvedOptions -> {}
  |>;

  (* Simulate the fulfillment of all resources by the procedure. *)
  currentSimulation = UpdateSimulation[
    currentSimulation,
    SimulateResources[
      protocolPacket,
      {myUnitOperationPacket},
      ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null],
      Simulation -> currentSimulation
    ]
  ];

  (* Return the Updated simulation *)
  currentSimulation
];

(* ::Subsection:: *)
(*workCellResolver Function*)
resolveImageColoniesWorkCell[
  myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]],
  myOptions: OptionsPattern[]
] := Module[
  {workCell},

  workCell = Lookup[myOptions, WorkCell, Automatic];

  (* Determine the WorkCell that can be used *)
  If[MatchQ[workCell, Except[Automatic]],
    {workCell},
    (* Just the qpix *)
    {qPix}
  ]
];


(* ::Subsection:: *)
(*Method Resolver Function*)
resolveImageColoniesMethod[
  myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]],
  myOptions: OptionsPattern[]
]:=Module[
  {method},

  method = Lookup[myOptions, Preparation, Automatic];

  (* Determine the Method that can be used *)
  If[MatchQ[method, Except[Automatic]],
    {method},
    (* Just Robotic *)
    {Robotic}
  ]
];

(* ::Subsubsection::Closed:: *)
(*ExperimentImageColoniesOptions*)

DefineOptions[ExperimentImageColoniesOptions,
  Options :> {
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
      Description -> "Determines whether the function returns a table or a list of the options."
    }

  },
  SharedOptions :> {ExperimentImageColonies}
];

ExperimentImageColoniesOptions[myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions: OptionsPattern[]] := Module[
  {listedOptions, noOutputOptions, options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

  (* get only the options for ExperimentImageColonies *)
  options = ExperimentImageColonies[myInputs, Append[noOutputOptions, Output -> Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
    LegacySLL`Private`optionsToTable[options, ExperimentImageColonies],
    options
  ]
];

(* ::Subsection:: *)
(*ExperimentImageColoniesPreview*)


DefineOptions[ExperimentImageColoniesPreview,
  SharedOptions :> {ExperimentImageColonies}
];

ExperimentImageColoniesPreview[
  myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions: OptionsPattern[]] := Module[
  {listedOptions, noOutputOptions},

  (* Get the options as a list*)
  listedOptions = ToList[myOptions];

  (* Remove the Output options before passing to the main function. *)
  noOutputOptions = DeleteCases[listedOptions, Output -> _];

  (*PlotContents, MouseOver, Tooltip*)
  (* Return only the preview for ExperimentImageColonies *)
  ExperimentImageColonies[myInputs, Append[noOutputOptions, Output -> Preview]]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentImageColoniesQ*)


DefineOptions[ValidExperimentImageColoniesQ,
  Options :> {
    VerboseOption,
    OutputFormatOption
  },
  SharedOptions :> {ExperimentImageColonies}
];

ValidExperimentImageColoniesQ[myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions: OptionsPattern[]] := Module[
  {
    listedOptions, preparedOptions, experimentImageColoniesTests, initialTestDescription, allTests, verbose, outputFormat
  },

  (* Get the options as a list. *)
  listedOptions = ToList[myOptions];

  (* Remove the Output option before passing to the core function because it doesn't make sense here. *)
  preparedOptions = DeleteCases[listedOptions, (Output|Verbose|OutputFormat) -> _];

  (* Return only the tests for ExperimentImageColonies. *)
  experimentImageColoniesTests = ExperimentImageColonies[myInputs, Append[preparedOptions, Output -> Tests]];

  (* Define the general test description. *)
  initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* Make a list of all the tests, including the blanket test. *)
  allTests = If[MatchQ[experimentImageColoniesTests, $Failed],
    {Test[initialTestDescription, False, True]},
    Module[
      {
        initialTest, validObjectBooleans, voqWarnings, inputObjects, inputStrands, inputSequences, validStrandBooleans,
        validStrandsWarnings, validSequenceBooleans, validSequencesWarnings
      },

      (* Generate the initial test, which we know will pass if we got this far (?) *)
      initialTest = Test[initialTestDescription, True, True];

      (* Sort inputs by what kind of input this is. *)
      inputObjects = Cases[ToList[myInputs], ObjectP[]];
      inputStrands = Cases[ToList[myInputs], StrandP[]];
      inputSequences = Cases[ToList[myInputs], SequenceP[]];

      (* Create warnings for invalid objects. *)
      validObjectBooleans = If[Length[inputObjects]>0,
        ValidObjectQ[inputObjects, OutputFormat -> Boolean],
        {}
      ];
      voqWarnings = If[Length[inputObjects]>0,
        Module[{},
          MapThread[
            Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
              #2,
              True
            ]&,
            {inputObjects, validObjectBooleans}
          ]
        ],
        {}
      ];

      (* Create warnings for invalid Strands. *)
      validStrandBooleans = If[Length[inputStrands]>0,
        ValidStrandQ[inputStrands],
        {}
      ];
      validStrandsWarnings = If[Length[inputStrands]>0,
        Module[{},
          MapThread[
            Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidStrandQ for more detailed information):"],
              #2,
              True
            ]&,
            {inputStrands, validStrandBooleans}
          ]
        ],
        {}
      ];

      (* Create warnings for invalid Strands. *)
      validSequenceBooleans = If[Length[inputSequences]>0,
        ValidSequenceQ[inputSequences],
        {}
      ];
      validSequencesWarnings = If[Length[inputSequences]>0,
        Module[{},
          MapThread[
            Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidSequenceQ for more detailed information):"],
              #2,
              True
            ]&,
            {inputSequences, validSequenceBooleans}
          ]
        ],
        {}
      ];

      (* Get all the tests/warnings. *)
      DeleteCases[Flatten[{initialTest, experimentImageColoniesTests, voqWarnings, validStrandsWarnings, validSequencesWarnings}], Null]
    ]
  ];

  (* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense. *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* Run all the tests as requested. *)
  Lookup[RunUnitTest[<|"ValidExperimentImageColoniesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentImageColoniesQ"]
];

(* ::Subsubsection::Closed:: *)
