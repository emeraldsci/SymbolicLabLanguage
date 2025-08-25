(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentDynamicLightScattering Unit Tests*)

DefineTests[ExperimentDynamicLightScattering,
  {
    (* Basic Examples *)
    Example[{Basic, "Accepts a sample object:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID]],
      ObjectP[Object[Protocol, DynamicLightScattering]]
    ],
    Example[{Basic, "Accepts a non-empty container object:"},
      ExperimentDynamicLightScattering[Object[Container, Vessel, "Container 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID]],
      ObjectP[Object[Protocol, DynamicLightScattering]]
    ],
    Example[{Basic, "Accepts a sample model:"},
      ExperimentDynamicLightScattering[Model[Sample,"Milli-Q water"], CollectStaticLightScattering -> False],
      ObjectP[Object[Protocol, DynamicLightScattering]]
    ],
    Example[{Basic, "Accepts a mixture of sample objects and non-empty container objects:"},
      ExperimentDynamicLightScattering[
        {
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
          Object[Container, Vessel, "Container 3 for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        }
      ],
      ObjectP[Object[Protocol, DynamicLightScattering]]
    ],
    Example[{Additional, "Use the sample preparation options to prepare samples before the main experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Incubate -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True, Output -> Options];
      {Lookup[options, Incubate], Lookup[options, Centrifuge], Lookup[options, Filtration], Lookup[options, Aliquot]},
      {True, True, True, True},
      Variables :> {options},
      TimeConstraint -> 240
    ],
    Example[{Additional, "The experiment accepts an input sample without a Model:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test Model-less protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        CollectStaticLightScattering -> False,
        Output -> Options
      ];
      Lookup[options, AssayType],
      SizingPolydispersity,
      Variables :> {options}
    ],
    (* - Messages - *)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentDynamicLightScattering[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentDynamicLightScattering[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentDynamicLightScattering[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentDynamicLightScattering[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
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

        ExperimentFilter[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

        ExperimentFilter[containerID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "DiscardedSamples", "If any provided input sample is discarded, an error will be thrown:"},
      ExperimentDynamicLightScattering[Object[Sample, "Discarded test sample for ExperimentDynamicLightScattering" <> $SessionUUID]],
      $Failed,
      Messages :> {
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "InvalidDLSInstrument", "If specified, the Instrument must be of Model[Instrument,MultimodeSpectrophotometer,\"Uncle\"] or Model[Instrument,DLSPlateReader,\"DynaPro\"]:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Instrument -> Model[Instrument, MultimodeSpectrophotometer, "Unsupported instrument Model for ExperimentDynamicLightScattering Tests" <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Error::InvalidDLSInstrument,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSAssayTypeOptions", "If the AssayType is specified, no options which are unique to a different AssayType can be specified:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        IsothermalRunTime -> 10 * Minute
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSAssayTypeOptions,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSAssayTypeNullOptions", "If the AssayType is specified, no options which are required for that AssayType can be Null:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        MeasurementDelayTime -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSAssayTypeNullOptions,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSIsothermalOptions", "If the AssayType is IsothermalStability, the IsothermalMeasurements and IsothermalRunTime options cannot both be specified or both be Null:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        IsothermalMeasurements -> 10,
        IsothermalRunTime -> 20 * Minute
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSIsothermalOptions,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "LowDLSReplicateConcentrations", "It is recommended to have 3 replicates at each dilution concentration for ColloidalStability assays:"},
      Lookup[ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        NumberOfReplicates -> 2,
        Output -> Options
      ], NumberOfReplicates],
      2,
      Messages :> {
        Warning::LowDLSReplicateConcentrations
      }
    ],
    Example[{Messages, "ConflictingDLSAssayTypeSampleVolumeOptions", "If the AssayType is ColloidalStability, the SampleVolume option cannot be specified. If the AssayType is SizingPolydispersity, MeltingCurve, or IsothermalStability, the SampleVolume option must be specified:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        SampleVolume -> 16 * Microliter
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSAssayTypeSampleVolumeOptions,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSAssayTypeNullOptions", "If the AssayType has not been specified but is implied by another option, there must be no options set as Null that are required for the set AssayType:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        IsothermalRunTime -> 10 * Minute,
        MeasurementDelayTime -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSAssayTypeNullOptions,
        Error::InvalidOption
      }
    ],
    (*todo: this needs to be fixed for DynaPro*)
    Example[{Messages, "DLSMeasurementDelayTimeTooLow", "The specified MeasurementDelayTime must not be smaller than the minimum required MeasurementDelayTime, which is dependent on the number of samples and the IsothermalAttenuatorAdjustment options:"},
      ExperimentDynamicLightScattering[
        {
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID]
        },
        NumberOfReplicates -> 2,
        AssayType -> IsothermalStability,
        MeasurementDelayTime -> 200 * Second
      ],
      $Failed,
      Messages :> {
        Error::DLSMeasurementDelayTimeTooLow,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSIsothermalTimeOptions", "If the AssayType is IsothermalStability, the MeasurementDelayTime cannot be larger than the IsothermalRunTime:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        IsothermalRunTime -> 5 * Minute,
        MeasurementDelayTime -> 6 * Minute
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSIsothermalTimeOptions,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSConflictingLaserSettings", "If AutomaticLaserSettings is True, both the LaserPower and DiodeAttenuation must be Null. If AutomaticLaserSettings is False, both the LaserPower and DiodeAttenuation cannot be Null:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AutomaticLaserSettings -> True,
        LaserPower -> 50 * Percent
      ],
      $Failed,
      Messages :> {
        Error::DLSConflictingLaserSettings,
        Error::InvalidOption
      }
    ],
    (*todo: verify for DynaPro*)
    Example[{Messages, "DLSIsothermalAssayTooLong", "The product of the MeasurementDelayTime and IsothermalMeasurements cannot be larger than 6.5 days:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        MeasurementDelayTime -> 2 * Hour,
        IsothermalMeasurements -> 500
      ],
      $Failed,
      Messages :> {
        Error::DLSIsothermalAssayTooLong,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSDilutionMixOptions", "If any of the Dilution Mix options is Null, they all must be Null. If any is specified, they all must be specified:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"],
        DilutionMixRate -> 100 Microliter/Second,
        DilutionNumberOfMixes -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSDilutionMixOptions,
        Error::ConflictingDLSDilutionMixTypeOptions,(*this necessarily gets thrown here as well*)
        Error::InvalidOption
      }
    ],
    Example[{Messages, "InvalidDLSTemperature", "If the AssayType is ColloidalStability and AssayFormFactor is Capillary, the Temperature must be 25 Celsius:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"],
        Temperature -> 30 * Celsius
      ],
      $Failed,
      Messages :> {
        Error::InvalidDLSTemperature,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSBufferNotSpecified", "For ColloidalStability assays, it is very highly recommended to specify the Buffer option. For accurate experimental results, the Buffer should be the same buffer that makes up the input sample:"},
      Lookup[ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Output -> Options
      ], AssayType],
      ColloidalStability,
      Messages :> {
        Warning::DLSBufferNotSpecified
      },
      SetUp:>(On[Warning::DLSBufferNotSpecified]),
      TearDown:>(Off[Warning::DLSBufferNotSpecified])
    ],
    Example[{Messages, "ConflictingDLSDilutionCurves", "When AssayType is ColloidalStability, for each input sample, the corresponding StandardDilutionCurve and SerialDilutionCurve options cannot both be Null or both be specified as non-Null values:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"],
        StandardDilutionCurve -> Null,
        SerialDilutionCurve -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSDilutionCurves,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSBufferAndBlankBufferDiffer", "For ColloidalStability assays, it is very highly recommended that the Buffer and BlankBuffer options are identical. For accurate experimental results, the options should be the same buffer that makes up the input sample:"},
      Lookup[ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"],
        BlankBuffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ], AssayType],
      ColloidalStability,
      Messages :> {
        Warning::DLSBufferAndBlankBufferDiffer
      }
    ],
    Example[{Messages, "DLSDilutionCurveLoadingPlateMismatch", "The largest volume required in a well of the SampleLoadingPlate during sample dilution cannot be larger than the MaxVolume of the SampleLoadingPlate:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"],
        SampleLoadingPlate -> Model[Container, Plate, "96-well PCR Plate"],
        StandardDilutionCurve -> {
          {205 * Microliter, 205 * Microliter},
          {40 * Microliter, 50 * Microliter},
          {40 * Microliter, 80 * Microliter}
        }
      ],
      $Failed,
      Messages :> {
        Error::DLSDilutionCurveLoadingPlateMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSNotEnoughDilutionCurveVolume", "The smallest volume in a well of the SampleLoadingPlate after sample dilution must be large enough for the volume required for the assay:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"],
        StandardDilutionCurve -> {
          {40 * Microliter, 40 * Microliter},
          {40 * Microliter, 50 * Microliter},
          {20 * Microliter, 40 * Microliter},
          {10 * Microliter, 20 * Microliter}
        },
        ReplicateDilutionCurve -> False,
        NumberOfReplicates -> 3
      ],
      $Failed,
      Messages :> {
        Error::DLSNotEnoughDilutionCurveVolume,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "OccupiedDLSSampleLoadingPlate", "The specified SampleLoadingPlate must be empty:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        SampleLoadingPlate -> Object[Container, Plate, "Occupied plate for ExperimentDynamicLightScattering tests" <> $SessionUUID]
      ],
      $Failed,
      Messages :> {
        Error::OccupiedDLSSampleLoadingPlate,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "NonDefaultDLSSampleLoadingPlate", "Using a non-default SampleLoadingPlate Model may result in poor experimental results:"},
      Lookup[ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        SampleLoadingPlate -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        Output -> Options
      ], SampleLoadingPlate],
      ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
      Messages :> {
        Warning::NonDefaultDLSSampleLoadingPlate
      }
    ],
    Example[{Messages, "DLSOnlyOneDilutionCurveConcentration", "Each StandardDilutionCurve or SerialDilutionCurve must have at least two unique dilutions:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        SerialDilutionCurve -> {40 * Microliter, {1}, 1},
        Buffer -> Model[Sample, "Milli-Q water"]
      ],
      $Failed,
      Messages :> {
        Error::DLSOnlyOneDilutionCurveConcentration,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "TooManyDLSInputs", "The NumberOfReplicates times the number of input samples cannot be larger than 48 when the AssayFormFactor is Capillary and the AssayType is SizingPolydispersity, MeltingCurve, or IsothermalStability:"},
      ExperimentDynamicLightScattering[
        {
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID]
        },
        AssayFormFactor -> Capillary,
        AssayType -> SizingPolydispersity,
        NumberOfReplicates -> 25
      ],
      $Failed,
      Messages :> {
        Error::TooManyDLSInputs,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "TooManyDLSInputs", "The NumberOfReplicates times the number of input samples cannot be larger than 384 when the AssayFormFactor is Plate and the AssayType is SizingPolydispersity, MeltingCurve, or IsothermalStability:"},
      ExperimentDynamicLightScattering[
        {
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID]
        },
        AssayFormFactor -> Plate,
        AssayType -> SizingPolydispersity,
        NumberOfReplicates -> 200
      ],
      $Failed,
      Messages :> {
        Error::TooManyDLSInputs,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DLSTooManyDilutionWellsRequired", "In ColloidalStability Assays, when the AssayFormFactor is Capillary, the sample dilutions and blank buffers can only take up a maximum of 48 AssayContainer wells:"},
      ExperimentDynamicLightScattering[
        {
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID]
        },
        AssayFormFactor -> Capillary,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"],
        SerialDilutionCurve -> {40 * Microliter, {1.0, 1.25, 1.333, 1.5, 2.0, 2.5, 2.0, 3.333, 2., 3.333}, 1},
        NumberOfReplicates -> 3
      ],
      $Failed,
      Messages :> {
        Error::DLSTooManyDilutionWellsRequired,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSInputSampleNoAnalyte", "For ColloidalStability assays, each input sample must have a Model[Molecule,Protein] or Model[Molecule,Polymer] in its Composition, or have the Analyte option specified:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 1 mL water for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"]
      ],
      $Failed,
      Messages :> {
        Error::DLSInputSampleNoAnalyte,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSInputSampleNoAnalyte", "When CollectStaticLightScattering in a Plate format, each input sample must have a Model[Molecule,Protein] or Model[Molecule,Polymer] in its Composition, or have the Analyte option specified:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 1 mL water for ExperimentDynamicLightScattering" <> $SessionUUID],
        CollectStaticLightScattering -> True,
        AssayFormFactor -> Plate,
        Buffer -> Model[Sample, "Milli-Q water"]
      ],
      $Failed,
      Messages :> {
        Error::DLSInputSampleNoAnalyte,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSInputSampleNoAnalyteMassConcentration", "For ColloidalStability assays, the Analyte must have an associated amount in the Composition field, or have the AnalyteMassConcentration option specified:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test unknown concentration protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"]
      ],
      $Failed,
      Messages :> {
        Error::DLSInputSampleNoAnalyteMassConcentration,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSInputSampleNoAnalyteMassConcentration", "When CollectStaticLightScattering in a Plate format, the Analyte must have an associated amount in the Composition field, or have the AnalyteMassConcentration option specified:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test unknown concentration protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        CollectStaticLightScattering -> True,
        AssayFormFactor -> Plate,
        Buffer -> Model[Sample, "Milli-Q water"]
      ],
      $Failed,
      Messages :> {
        Error::DLSInputSampleNoAnalyteMassConcentration,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSInputSampleNoAnalyteMolecularWeight", "For ColloidalStability assays, the Analyte must have an associated molecular weight in the MolecularWeight field:"},
      ExperimentDynamicLightScattering[Object[Sample,"Test no MW Protein sample for ExperimentDynamicLightScattering tests" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"]
      ],
      $Failed,
      Messages :> {
        Error::DLSInputSampleNoAnalyteMolecularWeight,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSInputSampleNoAnalyteMolecularWeight", "When CollectStaticLightScattering in a Plate format, the Analyte must have an associated molecular weight in the MolecularWeight field:"},
      ExperimentDynamicLightScattering[Object[Sample,"Test no MW Protein sample for ExperimentDynamicLightScattering tests" <> $SessionUUID],
        CollectStaticLightScattering -> True,
        AssayFormFactor -> Plate,
        Buffer -> Model[Sample, "Milli-Q water"]
      ],
      $Failed,
      Messages :> {
        Error::DLSInputSampleNoAnalyteMolecularWeight,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DLSMoreThanOneCompositionAnalyte", "For ColloidalStability assays, each input sample should only have one Model[Molecule,Protein] or Model[Molecule,Polymer] in its Composition:"},
      Lookup[ExperimentDynamicLightScattering[Object[Sample, "Mixture of proteins sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, "Milli-Q water"],
        Output -> Options
      ], AssayType],
      ColloidalStability,
      Messages :> {
        Warning::DLSMoreThanOneCompositionAnalyte
      }
    ],
    Example[{Messages, CapillaryLoading, "Raise error when CapillaryLoading is set to Manual and AssayContainerFillDirection to Row:"},
      Lookup[ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        CapillaryLoading -> Manual, AssayContainerFillDirection -> Row,
        Output -> Options
      ], CapillaryLoading],
      Manual,
      Messages :> {
        Error::DLSManualLoadingByRow,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "MinMaxTemperatureMismatch", "Raise error when MinTemperature is greater than or equal to MaxTemperature:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        MinTemperature -> (35*Celsius),
        MaxTemperature -> (25*Celsius)
      ],
      $Failed,
      Messages :> {
        Error::MinMaxTemperatureMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSFormFactorReplicateDilutionCurve", "Raise error when AssayFormFactor, ColloidalStability, and ReplicateDilutionCurve are in conflict:"},
      ExperimentDynamicLightScattering[Object[Sample,"Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayType -> ColloidalStability,
        ReplicateDilutionCurve -> False
      ],
      $Failed,
      Messages :> {
        Warning::DLSBufferNotSpecified,
        Error::ConflictingDLSFormFactorReplicateDilutionCurve,
        Error::InvalidOption
      },
      SetUp:>(On[Warning::DLSBufferNotSpecified]),
      TearDown:>(Off[Warning::DLSBufferNotSpecified])
    ],
    Example[{Messages, "ConflictingDLSFormFactorInstrument", "Raise error when AssayFormFactor and Instrument are in conflict:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        Instrument -> Model[Instrument, MultimodeSpectrophotometer, "id:4pO6dM508MbX"]
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSFormFactorInstrument,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSFormFactorLoadingPlate", "Raise error when AssayFormFactor and SampleLoadingPlate are in conflict:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        SampleLoadingPlate -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSFormFactorLoadingPlate,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSFormFactorCapillaryLoading", "Raise error when AssayFormFactor and CapillaryLoading are in conflict:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        CapillaryLoading -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSFormFactorCapillaryLoading,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSFormFactorPlateStorage", "Raise error when AssayFormFactor and SampleLoadingPlateStorageCondition are in conflict:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        SampleLoadingPlateStorageCondition -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSFormFactorPlateStorage,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingFormFactorWellCover", "Raise error when AssayFormFactor and WellCover are in conflict:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        WellCover -> Null
      ],
      $Failed,
      Messages :> {
        Error::ConflictingFormFactorWellCover,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingFormFactorWellCoverHeating", "Raise error when AssayFormFactor and WellCoverHeating are in conflict:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        WellCoverHeating -> True
      ],
      $Failed,
      Messages :> {
        Error::ConflictingFormFactorWellCoverHeating,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "Preplated", "Raise error when the DLS assay samples are already in their assay containers:"},
      options = ExperimentDynamicLightScattering[Object[Container, Plate, "Container 24 (preplated plate) for ExperimentDynamicLightScattering tests" <> $SessionUUID],
        CollectStaticLightScattering -> False,
        Output -> Options
      ];
      Lookup[options, WellCover],
      ObjectP[Model[Sample, "Silicone Oil"]],
      Messages :> {
        Warning::Preplated
      }
    ],
    Example[{Messages, "NoWellCover", "Raise error when the DLS assay samples are not preplated and WellCover is set to None:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        CollectStaticLightScattering -> False,
        WellCover -> None
      ],
      $Failed,
      Messages :> {
        Error::NoWellCover,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "TooLowSampleVolume", "Raise error when the SampleVolume is too low for the given AssayFormFactor:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        SampleVolume -> (20*Microliter)
      ],
      $Failed,
      Messages :> {
        Error::TooLowSampleVolume,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingRampOptions", "Raise error when the TemperatureRamping is in conflict with one or more of NumberOfTemperatureRampSteps or StepHoldTime:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        TemperatureRamping -> Linear,
        NumberOfTemperatureRampSteps -> 5
      ],
      $Failed,
      Messages :> {
        Error::ConflictingRampOptions,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSDilutionMixTypeOptions", "Raise error when the DilutionMixType is in conflict with one or more of DilutionMixRate and DilutionNumberOfMixes:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        DilutionMixType -> Vortex,
        DilutionNumberOfMixes -> 5
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSDilutionMixOptions,(*this necessarily comes up as well*)
        Error::ConflictingDLSDilutionMixTypeOptions,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingDLSDilutionMixTypeInstrument", "Raise error when the DilutionMixType is in conflict with DilutionMixInstrument:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        DilutionMixType -> Vortex,
        DilutionMixInstrument -> Model[Instrument,Pipette,"id:1ZA60vL547EM"]
      ],
      $Failed,
      Messages :> {
        Error::ConflictingDLSDilutionMixTypeInstrument,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ConflictingFormFactorCalibratePlate", "Raise error when the AssayFormFactor is in conflict with CalibratePlate:"},
      ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        CalibratePlate -> True
      ],
      $Failed,
      Messages :> {
        Error::ConflictingFormFactorCalibratePlate,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"ConflictingFormFactorAssayContainers","Raise an error if we were given more a plate model assay container when AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayContainers -> {
          Object[Container,Plate,"Empty Plate AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::ConflictingFormFactorAssayContainers,Error::InvalidOption}
    ],
    Example[{Messages,"ConflictingFormFactorAssayContainers","Raise an error if we were given more a plate model assay container when AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayContainers -> {
          Object[Container,Plate,CapillaryStrip,"Empty Capillary AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::ConflictingFormFactorAssayContainers,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidAssayContainers","Raise an error if we were given more than one plate type assay container:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayContainers -> {
          Object[Container,Plate,"Empty Plate AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
          Object[Container,Plate,"Empty Plate AssayContainer 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::InvalidAssayContainers,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidAssayContainers","Raise an error if we were given more than three capillary type assay containers:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayContainers -> {
          Object[Container,Plate,CapillaryStrip,"Empty Capillary AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
          Object[Container,Plate,CapillaryStrip,"Empty Capillary AssayContainer 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
          Object[Container,Plate,CapillaryStrip,"Empty Capillary AssayContainer 3 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
          Object[Container,Plate,CapillaryStrip,"Empty Capillary AssayContainer 4 for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::InvalidAssayContainers,Warning::SpecifiedCapillaryAssayContainers,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidAssayContainers","Raise an error if we were given a mix of plate type and capillary type assay containers:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayContainers -> {
          Object[Container,Plate,CapillaryStrip,"Empty Capillary AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
          Object[Container,Plate,"Empty Plate AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {Error::InvalidAssayContainers,Error::ConflictingFormFactorAssayContainers,Error::InvalidOption}
    ],
    Example[{Messages,"InvalidAssayContainers","Raise an error if we were given an invalid dls assay container model:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayContainers -> {
          Model[Container, Plate, "id:L8kPEjkmLbvW"] (* "96-well 2mL Deep Well Plate" *)
        }
      ],
      $Failed,
      Messages :> {Error::InvalidAssayContainers,Error::InvalidOption}
    ],
    Example[{Messages,"SpecifiedCapillaryAssayContainers","Raise an error if AssayFormFactor is Capillary and AssayContainer is specified as an Object[Container]:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayContainers -> {Object[Container,Plate,CapillaryStrip,"Empty Capillary AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID]},
        Output -> Options
      ];
      Lookup[options,AssayContainers],
      {ObjectP[Object[Container,Plate,CapillaryStrip,"Empty Capillary AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID]]},
      Messages :> {Warning::SpecifiedCapillaryAssayContainers}
    ],

    Example[{Messages,"SolventNameMismatch","Raise error when there is a conflict with the given SolventName, SolventViscosity, and/or SolventRefractiveIndex:"},
      options = ExperimentDynamicLightScattering[
        {
          Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
          Object[Sample, "Test cDNA sample for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        },
        AssayFormFactor -> Plate,
        CalibratePlate -> True,
        Buffer -> Model[Sample, "id:Vrbp1jG80zno"], (* Acetone, Reagent Grade *)
        SolventName -> "Acetone 100%",
        SolventViscosity -> {0.321369 Centipoise, 0.36 Centipoise},
        SolventRefractiveIndex -> {1.02, 1.361},
        Output->Options
      ];
      Lookup[options,{SolventViscosity,SolventRefractiveIndex}],
      {
        {EqualP[0.321369 Centipoise],EqualP[0.321369 Centipoise]},
        {EqualP[1.361],EqualP[1.361]}
      },
        Messages :> {Warning::SolventNameMismatch}
    ],
    Example[{Messages,"InvalidCapillaryAssayContainerContents","Raise error when AssayFormFactor is Capillary and any supplied AssayContainers already have Contents:"},
      ExperimentDynamicLightScattering[
        Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayContainers -> {Object[Container, Plate, CapillaryStrip, "Filled Capillary AssayContainer for ExperimentDynamicLightScattering tests" <> $SessionUUID]}
      ],
      $Failed,
      Messages :> {Warning::SpecifiedCapillaryAssayContainers,Error::InvalidCapillaryAssayContainerContents,Error::InvalidOption}
    ],
    Example[{Messages,"NotEnoughAssayContainerSpace","Raise error when AssayFormFactor is Plate and the supplied AssayContainers do not have enough empty wells for the assay:"},
      ExperimentDynamicLightScattering[
        Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayContainers -> {Object[Container, Plate, "Partially Filled Plate AssayContainer for ExperimentDynamicLightScattering tests" <> $SessionUUID]},
        NumberOfReplicates -> 8,
        SerialDilutionCurve -> {40*Microliter, {1.0, 1.25, 1.333, 1.5, 2.0, 2.5, 2.0, 3.333, 2., 3.333}, 1}
      ],
      $Failed,
      Messages :> {Error::NotEnoughAssayContainerSpace,Error::InvalidOption}
    ],
    
    (* - Options - *)
    (* Option Precision *)
    Example[{Options, SampleVolume, "Rounds specified SampleVolume to the nearest 0.1 uL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        SampleVolume -> 16.03 * Microliter, Output -> Options];
      Lookup[options, SampleVolume],
      16.0 * Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, AcquisitionTime, "Rounds specified AcquisitionTime to the nearest 1 second:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AcquisitionTime -> 4.8 * Second, Output -> Options];
      Lookup[options, AcquisitionTime],
      5 * Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, Temperature, "Rounds specified Temperature to the nearest 1 Celsius:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Temperature -> 31.4 * Celsius, Output -> Options];
      Lookup[options, Temperature],
      31 * Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, EquilibrationTime, "Rounds specified EquilibrationTime to the nearest 1 second:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        EquilibrationTime -> 104.6 * Second, Output -> Options];
      Lookup[options, EquilibrationTime],
      105 * Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, LaserPower, "Rounds specified LaserPower to the nearest 1%:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AutomaticLaserSettings -> False, LaserPower -> 86.3 * Percent, Output -> Options];
      Lookup[options, LaserPower],
      86 * Percent,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, DiodeAttenuation, "Rounds specified DiodeAttenuation to the nearest 1%:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AutomaticLaserSettings -> False, DiodeAttenuation -> 4.1 * Percent, Output -> Options];
      Lookup[options, DiodeAttenuation],
      4 * Percent,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, MeasurementDelayTime, "Rounds specified MeasurementDelayTime to the nearest 1 second:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        MeasurementDelayTime -> 200.3 * Second, Output -> Options];
      Lookup[options, MeasurementDelayTime],
      200 * Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, IsothermalRunTime, "Rounds specified IsothermalRunTime to the nearest 1 second:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        IsothermalRunTime -> 6000.3 * Second, Output -> Options];
      Lookup[options, IsothermalRunTime],
      6000 * Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, DilutionMixRate, "Rounds specified DilutionMixRate to the nearest 0.1 uL/second:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        DilutionMixRate -> 50.32 * Microliter / Second, Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"], Output -> Options];
      Lookup[options, DilutionMixRate],
      50.3 * Microliter / Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, AnalyteMassConcentration, "Rounds specified AnalyteMassConcentration to the nearest 0.01 mg/mL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AnalyteMassConcentration -> 19.893 * Milligram / Milliliter, Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"], Output -> Options];
      Lookup[options, AnalyteMassConcentration],
      19.89 * Milligram / Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, MinTemperature, "Rounds specified MinTemperature to the nearest 1 Celsius:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        MinTemperature->13.2*Celsius, Output -> Options];
      Lookup[options, MinTemperature],
      13.*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, MaxTemperature, "Rounds specified MaxTemperature to the nearest 1 Celsius:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        MaxTemperature->54.7*Celsius, Output -> Options];
      Lookup[options, MaxTemperature],
      55.*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, TemperatureRampRate, "Rounds specified TemperatureRampRate to the nearest 0.0001 Celsius/Second:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        TemperatureRampRate->0.00239*(Celsius/Second), Output -> Options];
      Lookup[options, TemperatureRampRate],
      0.0024*(Celsius/Second),
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, TemperatureResolution, "Rounds specified TemperatureResolution to the nearest 0.0001 Celsius:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        TemperatureResolution->0.00239*(Celsius), Output -> Options];
      Lookup[options, TemperatureResolution],
      0.0024*(Celsius),
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, StepHoldTime, "Rounds specified StepHoldTime to the nearest 1 Second:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        StepHoldTime->2.6*Second, Output -> Options];
      Lookup[options, StepHoldTime],
      3*Second,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, StandardDilutionCurve, "Rounds specified StandardDilutionCurve volumes to the nearest 0.1 uL:"},
      options = ExperimentDynamicLightScattering[
        Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        StandardDilutionCurve -> {
          {60 * Microliter, 60 * Microliter},
          {50 * Microliter, 60 * Microliter},
          {40.03 * Microliter, 60 * Microliter},
          {30 * Microliter, 60 * Microliter},
          {20 * Microliter, 60 * Microliter}
        },
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, StandardDilutionCurve],
      {
        {60 * Microliter, 60 * Microliter},
        {50 * Microliter, 60 * Microliter},
        {40 * Microliter, 60 * Microliter},
        {30 * Microliter, 60 * Microliter},
        {20 * Microliter, 60 * Microliter}
      },
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],
    Example[{Options, SerialDilutionCurve, "Rounds specified SerialDilutionCurve volumes to the nearest 0.1 uL:"},
      options = ExperimentDynamicLightScattering[
        Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        SerialDilutionCurve -> {
          40.3222 * Microliter,
          {1, 1.25, 1.333, 2.0, 2.0},
          1
        },
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      {
        40.3 * Microliter,
        {1, 1.25, 1.333, 2.0, 2.0},
        1
      },
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],

    Example[{Options, SerialDilutionCurve, "Rounds specified SerialDilutionCurve dilution factors to the nearest 0.001:"},
      options = ExperimentDynamicLightScattering[
        Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        SerialDilutionCurve -> {
          40 * Microliter,
          {1, 1.25, 1.333, 1.8888, 2.0},
          1
        },
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      {
        40 * Microliter,
        {1, 1.25, 1.333, 1.889, 2.0},
        1
      },
      EquivalenceFunction -> Equal,
      Variables :> {options},
      Messages :> {
        Warning::InstrumentPrecision
      }
    ],


    (* Options with Defaults *)
    Example[{Options, Instrument, "The Instrument option can be specified as an Object:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Instrument -> Object[Instrument, MultimodeSpectrophotometer, "Uncle Instrument for ExperimentDynamicLightScattering Tests" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Instrument],
      ObjectP[Object[Instrument, MultimodeSpectrophotometer, "Uncle Instrument for ExperimentDynamicLightScattering Tests" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, SampleLoadingPlate, "The SampleLoadingPlate option defaults to Model[Container, Plate, \"96-well PCR Plate\"], a plate well suited for the small volumes typically used for dynamic light scattering, when AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, SampleLoadingPlate],
      ObjectP[Model[Container, Plate, "96-well PCR Plate"]],
      Variables :> {options}
    ],
    Example[{Options, SampleLoadingPlate, "The SampleLoadingPlate option defaults to Null when AssayFormFactor is Plate and there is no large dilution:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, SampleLoadingPlate],
      Null,
      Variables :> {options}
    ],
    Example[{Options, SampleLoadingPlate, "The SampleLoadingPlate option defaults to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] when AssayFormFactor is Plate and there is a large dilution:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        StandardDilutionCurve -> {{90*Microliter, 250*Microliter}, {80*Microliter, 250*Microliter}, {70*Microliter, 250*Microliter}, {60*Microliter, 250*Microliter}},
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        AssayFormFactor -> Plate,
        Output -> Options
      ];
      Lookup[options, SampleLoadingPlate],
      ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
      Variables :> {options}
    ],
    Example[{Options, Temperature, "The Temperature option defaults to 25 Celsius:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, Temperature],
      25 * Celsius,
      Variables :> {options}
    ],
    Example[{Options, EquilibrationTime, "The EquilibrationTime option defaults to 2 minutes:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, EquilibrationTime],
      2 * Minute,
      Variables :> {options}
    ],
    Example[{Options, NumberOfAcquisitions, "The NumberOfAcquisitions option defaults to 4:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, NumberOfAcquisitions],
      4,
      Variables :> {options}
    ],
    Example[{Options, AcquisitionTime, "The AcquisitionTime option defaults to 5 seconds:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AcquisitionTime],
      5 * Second,
      Variables :> {options}
    ],
    Example[{Options, AutomaticLaserSettings, "The AutomaticLaserSettings option defaults to True:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AutomaticLaserSettings],
      True,
      Variables :> {options}
    ],
    Example[{Options, NumberOfReplicates, "The NumberOfReplicates option is used to make replicate measurements on each input sample. ExperimentDynamicLightScattering[{sample1,sample2},NumberOfReplicates->3] is identical to ExperimentDynamicLightScattering[{sample1,sample1,sample1,sample2,sample2,sample2}]:"},(*todo: what is this doing here?*)
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        NumberOfReplicates -> 5,
        Output -> Options
      ];
      Lookup[options, NumberOfReplicates],
      5,
      Variables :> {options}
    ],
    (* AssayContainers *)
    Example[{Options,AssayContainers,"The AssayContainers option defaults to the uncle 16-capillary strip if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, AssayContainers],
      {
        ObjectP[Model[Container, Plate, CapillaryStrip, "id:R8e1Pjp9Kjjj"]] (*"Uncle 16-capillary strip"*)
      }
    ],
    Example[{Options,AssayContainers,"The AssayContainers option defaults to 384-well Aurora Flat Bottom DLS Plate if we are expecting 384 wells:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        NumberOfReplicates->30,
        AssayType->ColloidalStability,
        Output -> Options
      ];
      Lookup[options, AssayContainers],
      {
        ObjectP[Model[Container, Plate, "id:4pO6dMOlqJLw"]] (*"384-well Aurora Flat Bottom DLS Plate"*)
      }
    ],
    Example[{Options,AssayContainers,"The AssayContainers option defaults to 96 well Flat Bottom DLS Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AssayContainers],
      {
        ObjectP[Model[Container, Plate, "id:rea9jlaPWNGx"]] (*"96 well Flat Bottom DLS Plate"*)
      }
    ],
    (* SolventName *)
    Example[{Options,SolventName,"SolventName is set to \"Water\" if buffer defaults to water and AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, SolventName],
      "Water"
    ],
    Example[{Options,SolventName,"SolventName is set to Null if AssayType is not ColloidalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType->SizingPolydispersity,
        CollectStaticLightScattering->False,
        Output -> Options
      ];
      Lookup[options, SolventName],
      Null
    ],
    Example[{Options,SolventName,"SolventName is set to Null if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor->Capillary,
        Output -> Options
      ];
      Lookup[options, SolventName],
      Null
    ],
    Example[{Options,SolventName,"SolventName is set to \"Acetone 100%\" if SolventViscosity and SolventRefractiveIndex are a match in our lookup:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Buffer -> Model[Sample, "Acetone, Reagent Grade"],
        SolventViscosity -> 0.321369 Centipoise,
        SolventRefractiveIndex -> 1.361,
        Output -> Options
      ];
      Lookup[options, SolventName],
      "Acetone 100%"
    ],
    Example[{Options,SolventName,"SolventName is set to \"New\" if SolventRefractiveIndex is 1.361 and Viscosity is 0.321369 cP:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        SolventViscosity -> 10 Centipoise,
        SolventRefractiveIndex -> 3,
        Output -> Options
      ];
      Lookup[options, SolventName],
      "New"
    ],
    (* SolventViscosity *)
    Example[{Options,SolventViscosity,"SolventViscosity is set to Null if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor->Capillary,
        Output -> Options
      ];
      Lookup[options, SolventViscosity],
      Null
    ],
    Example[{Options,SolventViscosity,"SolventViscosity is set to Null if AssayType is not ColloidalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType->SizingPolydispersity,
        CollectStaticLightScattering->False,
        Output -> Options
      ];
      Lookup[options, SolventViscosity],
      Null
    ],
    Example[{Options,SolventViscosity,"SolventViscosity is set to the value in the dynapro lookup if a SolventName is specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Buffer -> Model[Sample, "id:Vrbp1jG80zno"],
        SolventName -> "Acetone 100%",
        Output -> Options
      ];
      Lookup[options, SolventViscosity],
      0.321369 Centipoise,
      EquivalenceFunction -> EqualQ
    ],
    Example[{Options,SolventViscosity,"SolventViscosity can be downloaded from the supplied buffer:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Buffer -> Model[Sample, "id:Vrbp1jG80zno"], (* Model[Sample, "Acetone, Reagent Grade"] *)
        Output -> Options
      ];
      Lookup[options, SolventViscosity],
      0.295 Centipoise,
      EquivalenceFunction -> EqualQ
    ],
    (* SolventRefractiveIndex *)
    Example[{Options,SolventRefractiveIndex,"SolventRefractiveIndex is set to Null if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor->Capillary,
        Output -> Options
      ];
      Lookup[options, SolventRefractiveIndex],
      Null
    ],
    Example[{Options,SolventRefractiveIndex,"SolventRefractiveIndex is set to Null if AssayType is not ColloidalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType->SizingPolydispersity,
        CollectStaticLightScattering->False,
        Output -> Options
      ];
      Lookup[options, SolventRefractiveIndex],
      Null
    ],
    Example[{Options,SolventRefractiveIndex,"SolventRefractiveIndex is set to the value in the dynapro lookup if a SolventName is specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Buffer -> Model[Sample, "id:Vrbp1jG80zno"],
        SolventName -> "Acetone 100%",
        Output -> Options
      ];
      Lookup[options, SolventRefractiveIndex],
      1.361,
      EquivalenceFunction -> EqualQ
    ],
    Example[{Options,SolventRefractiveIndex,"SolventRefractiveIndex can be downloaded from the supplied buffer:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Buffer -> Model[Sample, "id:Vrbp1jG80zno"], (* Model[Sample, "Acetone, Reagent Grade"] *)
        Output -> Options
      ];
      Lookup[options, SolventRefractiveIndex],
      1.323,
      EquivalenceFunction -> EqualQ,
      SetUp :> {
        Upload[<|Object->Model[Sample, "id:Vrbp1jG80zno"],RefractiveIndex->1.323|>]
      },
      TearDown :> {
        Upload[<|Object->Model[Sample, "id:Vrbp1jG80zno"],RefractiveIndex->Null|>]
      }
    ],
    (* AnalyteRefractiveIndexIncrement *)
    Example[{Options,AnalyteRefractiveIndexIncrement,"AnalyteRefractiveIndexIncrement is set to Null if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor->Capillary,
        Output -> Options
      ];
      Lookup[options, AnalyteRefractiveIndexIncrement],
      Null
    ],
    Example[{Options,AnalyteRefractiveIndexIncrement,"AnalyteRefractiveIndexIncrement is set to Null if AssayType is not ColloidalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType->SizingPolydispersity,
        CollectStaticLightScattering->False,
        Output -> Options
      ];
      Lookup[options, AnalyteRefractiveIndexIncrement],
      Null
    ],
    Example[{Options,AnalyteRefractiveIndexIncrement,"AnalyteRefractiveIndexIncrement is set to 0.185 Milliliter/Gram if our analyte is a protein or cDNA:"},
      options = ExperimentDynamicLightScattering[
        {
          Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
          Object[Sample,"Test cDNA sample for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        },
        AssayType->ColloidalStability,
        Output -> Options
      ];
      Lookup[options, AnalyteRefractiveIndexIncrement],
      0.185 Milliliter/Gram,
      EquivalenceFunction -> EqualQ
    ],
    Example[{Options,AnalyteRefractiveIndexIncrement,"AnalyteRefractiveIndexIncrement is set to 0.15 Milliliter/Gram if our analyte is a polymer or oligomer:"},
      options = ExperimentDynamicLightScattering[
        {
          Object[Sample,"Test Oligomer sample for ExperimentDynamicLightScattering tests" <> $SessionUUID],
          Object[Sample,"Test Polymer sample for ExperimentDynamicLightScattering tests" <> $SessionUUID]
        },
        AssayType->ColloidalStability,
        Output -> Options
      ];
      Lookup[options, AnalyteRefractiveIndexIncrement],
      0.15 Milliliter/Gram,
      EquivalenceFunction -> EqualQ
    ],
    (* CalibratePlate *)
    Example[{Options,CalibratePlate,"CalibratePlate is set to False if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor->Capillary,
        Output -> Options
      ];
      Lookup[options, CalibratePlate],
      False
    ],
    Example[{Options,CalibratePlate,"CalibratePlate is set to False if AssayType is not ColloidalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType->SizingPolydispersity,
        CollectStaticLightScattering->False,
        Output -> Options
      ];
      Lookup[options, CalibratePlate],
      False
    ],
    Example[{Options,CalibratePlate,"CalibratePlate is set to True if AssayFormFactor is Plate and CollectStaticLightScattering is True:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor->Plate,
        CollectStaticLightScattering->True,
        Output -> Options
      ];
      Lookup[options, CalibratePlate],
      True
    ],
    (* AssayContainerFillDirection *)
    Example[{Options, AssayContainerFillDirection, "The AssayContainerFillDirection option defaults to Column, which indicates that all 16 wells of one capillary strip will be filled before starting to fill a second capillary strip:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AssayContainerFillDirection],
      Column,
      Variables :> {options}
    ],
    (* Options without defaults *)
    Example[{Options, AssayFormFactor, "The AssayFormFactor option defaults to Capillary if the Instrument is set to a member of Model[Instrument,MultimodeSpectrophotometer]:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Instrument -> Model[Instrument, MultimodeSpectrophotometer, "id:4pO6dM508MbX"],
        Output -> Options
      ];
      Lookup[options, AssayFormFactor],
      Capillary,
      Variables :> {options}
    ],
    Example[{Options, AssayFormFactor, "The AssayFormFactor option defaults to Plate if the Instrument is set to a member of Model[Instrument,DLSPlateReader]:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Instrument -> Model[Instrument,DLSPlateReader,"DynaPro"],
        Output -> Options
      ];
      Lookup[options, AssayFormFactor],
      Plate,
      Variables :> {options}
    ],
    Example[{Options, AssayFormFactor, "The AssayFormFactor option defaults to Capillary if any of SampleLoadingPlate, CapillaryLoading, or SampleLoadingPlateStorageCondition are specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        CapillaryLoading -> Manual,
        Output -> Options
      ];
      Lookup[options, AssayFormFactor],
      Capillary,
      Variables :> {options}
    ],
    Example[{Options, AssayFormFactor, "The AssayFormFactor option defaults to Plate if any of WellCover or WellCoverHeating are specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        WellCoverHeating -> True,
        Output -> Options
      ];
      Lookup[options, AssayFormFactor],
      Plate,
      Variables :> {options}
    ],
    Example[{Options, AssayFormFactor, "The AssayFormFactor option defaults to Plate if the SampleVolume is set to a value greater than or equal to 25 uL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        SampleVolume -> (30*Microliter),
        Output -> Options
      ];
      Lookup[options, AssayFormFactor],
      Plate,
      Variables :> {options}
    ],
    Example[{Options, AssayFormFactor, "The AssayFormFactor option defaults to Capillary if the SampleVolume is set to a value less than 25 uL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        SampleVolume -> (20*Microliter),
        Output -> Options
      ];
      Lookup[options, AssayFormFactor],
      Capillary,
      Variables :> {options}
    ],
    Example[{Options, AssayFormFactor, "The AssayFormFactor option defaults to Plate if no additional options are specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AssayFormFactor],
      Plate,
      Variables :> {options}
    ],
    Example[{Options, Instrument, "The Instrument option defaults to Model[Instrument, DLSPlateReader, \"id:mnk9jOkYvNpK\"] if AssayFormFactor is set to Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        Output -> Options
      ];
      Lookup[options, Instrument],
      Model[Instrument, DLSPlateReader, "id:mnk9jOkYvNpK"],
      Variables :> {options}
    ],
    Example[{Options, Instrument, "The Instrument option defaults to Model[Instrument,MultimodeSpectrophotometer,\"id:4pO6dM508MbX\"] if AssayFormFactor is set to Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, Instrument],
      Model[Instrument, MultimodeSpectrophotometer, "id:4pO6dM508MbX"],
      Variables :> {options}
    ],
    Example[{Options, AssayType, "The AssayType option defaults to IsothermalStability if any of options in the \"Isothermal Stability\" category are specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        MeasurementDelayTime -> 5 * Minute,
        Output -> Options
      ];
      Lookup[options, AssayType],
      IsothermalStability,
      Variables :> {options}
    ],
    Example[{Options, AssayType, "The AssayType option defaults to ColloidalStability if any of the options in the \"Sample Dilution\" or \"Colloidal Stability\" categories are specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        DilutionNumberOfMixes -> 3,
        Output -> Options
      ];
      Lookup[options, AssayType],
      ColloidalStability,
      Variables :> {options}
    ],
    Example[{Options, AssayType, "The AssayType option defaults to MeltingCurve if any of the options in the \"Melting Curve\" categories are specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        TemperatureRampOrder -> {Cooling,Heating},
        Output -> Options
      ];
      Lookup[options, AssayType],
      MeltingCurve,
      Variables :> {options}
    ],
    Example[{Options, AssayType, "The AssayType option defaults to SizingPolydispersity if none of the options in the \"Sample Dilution\", \"Isothermal Stability\", or \"Melting Curve\" categories are specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AssayType],
      SizingPolydispersity,
      Variables :> {options}
    ],
    Example[{Options, CapillaryLoading, "The CapillaryLoading option defaults to Manual if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, CapillaryLoading],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, CapillaryLoading, "The CapillaryLoading option defaults to Null if AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        Output -> Options
      ];
      Lookup[options, CapillaryLoading],
      Null,
      Variables :> {options}
    ],
    Example[{Options, SampleLoadingPlateStorageCondition, "The SampleLoadingPlateStorageCondition option defaults to Disposal if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, SampleLoadingPlateStorageCondition],
      Disposal,
      Variables :> {options}
    ],
    Example[{Options, SampleLoadingPlateStorageCondition, "The SampleLoadingPlateStorageCondition option defaults to Null if AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        Output -> Options
      ];
      Lookup[options, SampleLoadingPlateStorageCondition],
      Null,
      Variables :> {options}
    ],
    Example[{Options, WellCover, "The WellCover option defaults to Model[Sample,\"Silicone Oil\"] if AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        Output -> Options
      ];
      Lookup[options, WellCover],
      ObjectP[Model[Sample,"Silicone Oil"]],
      Variables :> {options}
    ],
    Example[{Options, WellCover, "The WellCover option defaults to Null if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, WellCover],
      Null,
      Variables :> {options}
    ],
    Example[{Options, WellCoverHeating, "The WellCoverHeating option defaults to False if AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        Output -> Options
      ];
      Lookup[options, WellCoverHeating],
      False,
      Variables :> {options}
    ],
    Example[{Options, WellCoverHeating, "The WellCoverHeating option defaults to Null if AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, WellCoverHeating],
      Null,
      Variables :> {options}
    ],
    Example[{Options, LaserPower, "The LaserPower option defaults to Null if AutomaticLaserSettings is True:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AutomaticLaserSettings -> True,
        Output -> Options
      ];
      Lookup[options, LaserPower],
      Null,
      Variables :> {options}
    ],
    Example[{Options, LaserPower, "The LaserPower option defaults to 100% if AutomaticLaserSettings is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AutomaticLaserSettings -> False,
        Output -> Options
      ];
      Lookup[options, LaserPower],
      100 * Percent,
      Variables :> {options}
    ],
    Example[{Options, DiodeAttenuation, "The DiodeAttenuation option defaults to Null if AutomaticLaserSettings is True:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AutomaticLaserSettings -> True,
        Output -> Options
      ];
      Lookup[options, DiodeAttenuation],
      Null,
      Variables :> {options}
    ],
    Example[{Options, DiodeAttenuation, "The DiodeAttenuation option defaults to 100% if AutomaticLaserSettings is False and AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AutomaticLaserSettings -> False,
        AssayFormFactor->Capillary,
        Output -> Options
      ];
      Lookup[options, DiodeAttenuation],
      100 * Percent,
      Variables :> {options}
    ],
    Example[{Options, DiodeAttenuation, "The DiodeAttenuation option defaults to 0% if AutomaticLaserSettings is False and AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AutomaticLaserSettings -> False,
        AssayFormFactor->Plate,
        Output -> Options
      ];
      Lookup[options, DiodeAttenuation],
      0 * Percent,
      Variables :> {options}
    ],
    Example[{Options, CapillaryLoading, "The CapillaryLoading option defaults to Manual when AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor->Capillary,
        Output -> Options
      ];
      Lookup[options, CapillaryLoading],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, CapillaryLoading, "The CapillaryLoading option can be set to Robotic:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        CapillaryLoading -> Robotic,
        Output -> Options
      ];
      Lookup[options, CapillaryLoading],
      Robotic,
      Variables :> {options}
    ],
    Example[{Options, SampleVolume, "The SampleVolume option defaults to 15 uL if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve and AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, SampleVolume],
      15 * Microliter,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, SampleVolume, "The SampleVolume option defaults to 100 uL if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve and AssayFormFactor is Plate and fewer than 96 wells are required:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        AssayFormFactor -> Plate,
        Output -> Options
      ];
      Lookup[options, SampleVolume],
      100 * Microliter,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, SampleVolume, "The SampleVolume option defaults to 30 uL if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve and AssayFormFactor is Plate and greater than 96 wells are required:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        AssayFormFactor -> Plate,
        Output -> Options,
        NumberOfReplicates -> 100
      ];
      Lookup[options, SampleVolume],
      30 * Microliter,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, SampleVolume, "The SampleVolume option defaults to Null if the AssayType is ColloidalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, SampleVolume],
      Null,
      Variables :> {options}
    ],
    Example[{Options, IsothermalAttenuatorAdjustment, "The IsothermalAttenuatorAdjustment option defaults to Every if the AssayType is IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, IsothermalAttenuatorAdjustment],
      Every,
      Variables :> {options}
    ],
    Example[{Options, IsothermalAttenuatorAdjustment, "The IsothermalAttenuatorAdjustment option defaults to Null if the AssayType is not IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        Output -> Options
      ];
      Lookup[options, IsothermalAttenuatorAdjustment],
      Null,
      Variables :> {options}
    ],
    Example[{Options, MeasurementDelayTime, "The MeasurementDelayTime option defaults to Null if the AssayType is not IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        Output -> Options
      ];
      Lookup[options, MeasurementDelayTime],
      Null,
      Variables :> {options}
    ],
    Example[{Options, MeasurementDelayTime, "The MeasurementDelayTime option defaults to a value calculated by the Instrument manufacture's proprietary algorithm (dependent on the number of input samples and the IsothermalAttenuatorAdjustment) if the AssayType is IsothermalStability and IsothermalAttenuatorAdjustment is Every:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> IsothermalStability,
        IsothermalAttenuatorAdjustment -> Every,
        Output -> Options
      ];
      Lookup[options, MeasurementDelayTime],
      124 * Second,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, MeasurementDelayTime, "The MeasurementDelayTime option defaults to a value calculated by the Instrument manufacture's proprietary algorithm (dependent on the number of input samples and the IsothermalAttenuatorAdjustment) if the AssayType is IsothermalStability and IsothermalAttenuatorAdjustment is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> IsothermalStability,
        IsothermalAttenuatorAdjustment -> First,
        Output -> Options
      ];
      Lookup[options, MeasurementDelayTime],
      109 * Second,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, IsothermalMeasurements, "The IsothermalMeasurements option defaults to Null if the AssayType is not IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        Output -> Options
      ];
      Lookup[options, IsothermalMeasurements],
      Null,
      Variables :> {options}
    ],
    Example[{Options, IsothermalMeasurements, "The IsothermalMeasurements option defaults to Null if the AssayType is IsothermalStability and the IsothermalRunTime option is specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        IsothermalRunTime -> 30 * Minute,
        Output -> Options
      ];
      Lookup[options, IsothermalMeasurements],
      Null,
      Variables :> {options}
    ],
    Example[{Options, IsothermalMeasurements, "The IsothermalMeasurements option defaults to 10 if the AssayType is IsothermalStability and the IsothermalRunTime option is not specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, IsothermalMeasurements],
      10,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, IsothermalRunTime, "The IsothermalRunTime option defaults to Null if the AssayType is not IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        Output -> Options
      ];
      Lookup[options, IsothermalRunTime],
      Null,
      Variables :> {options}
    ],
    Example[{Options, IsothermalRunTime, "The IsothermalRunTime option defaults to 10 times the MeasurementDelayTime if the AssayType is IsothermalStability and the IsothermalMeasurements option is Null:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        MeasurementDelayTime -> 300 * Second,
        IsothermalMeasurements -> Null,
        Output -> Options
      ];
      Lookup[options, IsothermalRunTime],
      3000 * Second,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, IsothermalRunTime, "The IsothermalRunTime option defaults to Null if the AssayType is IsothermalStability and the IsothermalMeasurements has been specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        IsothermalMeasurements -> 20,
        MeasurementDelayTime -> 5 * Minute,
        Output -> Options
      ];
      Lookup[options, IsothermalRunTime],
      Null,
      Variables :> {options}
    ],
    Example[{Options, MinTemperature, "The MinTemperature option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, MinTemperature],
      Null,
      Variables :> {options}
    ],
    Example[{Options, MinTemperature, "The MinTemperature option defaults to 4 Celsius if the AssayType is MeltingCurve and AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayType -> MeltingCurve,
        Output -> Options
      ];
      Lookup[options, MinTemperature],
      4. * Celsius,
      Variables :> {options}
    ],
    Example[{Options, MinTemperature, "The MinTemperature option defaults to 15 Celsius if the AssayType is MeltingCurve and AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> MeltingCurve,
        Output -> Options
      ];
      Lookup[options, MinTemperature],
      15. * Celsius,
      Variables :> {options}
    ],
    Example[{Options, MaxTemperature, "The MaxTemperature option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, MaxTemperature],
      Null,
      Variables :> {options}
    ],
    Example[{Options, MaxTemperature, "The MaxTemperature option defaults to 85 Celsius if the AssayType is MeltingCurve and AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayType -> MeltingCurve,
        Output -> Options
      ];
      Lookup[options, MaxTemperature],
      85. * Celsius,
      Variables :> {options}
    ],
    Example[{Options, MaxTemperature, "The MaxTemperature option defaults to 95 Celsius if the AssayType is MeltingCurve and AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> MeltingCurve,
        Output -> Options
      ];
      Lookup[options, MaxTemperature],
      95. * Celsius,
      Variables :> {options}
    ],
    Example[{Options, TemperatureRampOrder, "The TemperatureRampOrder option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, TemperatureRampOrder],
      Null,
      Variables :> {options}
    ],
    Example[{Options, TemperatureRampOrder, "The TemperatureRampOrder option defaults to {Heating,Cooling} if the AssayType is MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> MeltingCurve,
        Output -> Options
      ];
      Lookup[options, TemperatureRampOrder],
      {Heating,Cooling},
      Variables :> {options}
    ],
    Example[{Options, NumberOfCycles, "The NumberOfCycles option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, NumberOfCycles],
      Null,
      Variables :> {options}
    ],
    Example[{Options, NumberOfCycles, "The NumberOfCycles option defaults to 1 if the AssayType is MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> MeltingCurve,
        Output -> Options
      ];
      Lookup[options, NumberOfCycles],
      1,
      Variables :> {options}
    ],
    Example[{Options, TemperatureRamping, "The TemperatureRamping option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, TemperatureRamping],
      Null,
      Variables :> {options}
    ],
    Example[{Options, TemperatureRamping, "The TemperatureRamping option defaults to Step if the AssayType is MeltingCurve and either NumberOfTemperatureRampSteps or StepHoldTime is set:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> MeltingCurve,
        NumberOfTemperatureRampSteps -> 5,
        Output -> Options
      ];
      Lookup[options, TemperatureRamping],
      Step,
      Variables :> {options}
    ],
    Example[{Options, TemperatureRamping, "The TemperatureRamping option defaults to Linear if the AssayType is MeltingCurve and neither NumberOfTemperatureRampSteps nor StepHoldTime is set:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayType -> MeltingCurve,
        Output -> Options
      ];
      Lookup[options, TemperatureRamping],
      Linear,
      Variables :> {options}
    ],
    Example[{Options, TemperatureRampRate, "The TemperatureRampRate option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, TemperatureRampRate],
      Null,
      Variables :> {options}
    ],
    Example[{Options, TemperatureRampRate, "The TemperatureRampRate option defaults to the maximum available for the instrument if the AssayType is MeltingCurve and TemperatureRamping is Step:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> MeltingCurve,
        TemperatureRamping -> Step,
        Output -> Options
      ];
      Lookup[options, TemperatureRampRate],
      0.1667 * (Celsius/Second),
      Variables :> {options}
    ],
    Example[{Options, TemperatureRampRate, "The TemperatureRampRate option defaults to 1 Celsius/Minute if the AssayType is MeltingCurve, TemperatureRamping is Linear, and AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> MeltingCurve,
        TemperatureRamping -> Linear,
        Output -> Options
      ];
      Lookup[options, TemperatureRampRate],
      1 * (Celsius/Minute),
      Variables :> {options}
    ],
    Example[{Options, TemperatureRampRate, "The TemperatureRampRate option defaults to 0.25 Celsius/Minute if the AssayType is MeltingCurve, TemperatureRamping is Linear, and AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayType -> MeltingCurve,
        TemperatureRamping -> Linear,
        Output -> Options
      ];
      Lookup[options, TemperatureRampRate],
      0.25 * (Celsius/Minute),
          Variables :> {options}
    ],
    Example[{Options, TemperatureResolution, "The TemperatureResolution option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, TemperatureResolution],
      Null,
      Variables :> {options}
    ],
    Example[{Options, TemperatureResolution, "The TemperatureResolution option defaults to a value based on the number of instruments, the total number of samples, and the TemperatureRampRate if the AssayType is MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> MeltingCurve,
        TemperatureRampRate -> 6. * (Celsius/Minute),
        Output -> Options
      ];
      Lookup[options, TemperatureResolution],
      0.68*Celsius,
      Variables :> {options}
    ],
    Example[{Options, NumberOfTemperatureRampSteps, "The NumberOfTemperatureRampSteps option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, NumberOfTemperatureRampSteps],
      Null,
      Variables :> {options}
    ],
    Example[{Options, NumberOfTemperatureRampSteps, "The NumberOfTemperatureRampSteps option defaults to Null if the AssayType is MeltingCurve and TemperatureRamping is Linear:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> MeltingCurve,
        TemperatureRamping -> Linear,
        Output -> Options
      ];
      Lookup[options, NumberOfTemperatureRampSteps],
      Null,
      Variables :> {options}
    ],
    Example[{Options, NumberOfTemperatureRampSteps, "The NumberOfTemperatureRampSteps option defaults to the difference between MinTemperature and MaxTemperature divided by 1 Celsius if the AssayType is MeltingCurve and TemperatureRamping is Step:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> MeltingCurve,
        MinTemperature -> 20*Celsius,
        MaxTemperature -> 40*Celsius,
        TemperatureRamping -> Step,
        Output -> Options
      ];
      Lookup[options, NumberOfTemperatureRampSteps],
      20,
      Variables :> {options}
    ],
    Example[{Options, StepHoldTime, "The StepHoldTime option defaults to Null if the AssayType is not MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, StepHoldTime],
      Null,
      Variables :> {options}
    ],
    Example[{Options, StepHoldTime, "The StepHoldTime option defaults to Null if the AssayType is MeltingCurve and TemperatureRamping is Linear:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> MeltingCurve,
        TemperatureRamping -> Linear,
        Output -> Options
      ];
      Lookup[options, StepHoldTime],
      Null,
      Variables :> {options}
    ],
    Example[{Options, StepHoldTime, "The StepHoldTime option defaults to a calculated time if the AssayType is MeltingCurve and TemperatureRamping is Step:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> MeltingCurve,
        TemperatureRamping -> Step,
        Output -> Options
      ];
      Lookup[options, StepHoldTime],
      Except[Null],
      Variables :> {options}
    ],
    Example[{Options, NumberOfReplicates, "The NumberOfReplicates option defaults to 3 if the AssayType is ColloidalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, NumberOfReplicates],
      3,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, NumberOfReplicates, "The NumberOfReplicates option defaults to 2 if the AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, NumberOfReplicates],
      2,
      Variables :> {options}
    ],
    Example[{Options, CalibratePlate, "The CalibratePlate option defaults to True if the AssayFormFactor is Plate and CollectStaticLightScattering is True:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        CollectStaticLightScattering -> True,
        Output -> Options
      ];
      Lookup[options, CalibratePlate],
      True,
      Variables :> {options}
    ],
    Example[{Options, CalibratePlate, "The CalibratePlate option defaults to False if the AssayFormFactor is Plate and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        CollectStaticLightScattering -> False,
        Output -> Options
      ];
      Lookup[options, CalibratePlate],
      False,
      Variables :> {options}
    ],
    Example[{Options, CalibratePlate, "The CalibratePlate option defaults to False if the AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        Output -> Options
      ];
      Lookup[options, CalibratePlate],
      False,
      Variables :> {options}
    ],
    Example[{Options, ReplicateDilutionCurve, "The ReplicateDilutionCurve option defaults to Null if the AssayType is SizingPolydispersity or IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, ReplicateDilutionCurve],
      Null,
      Variables :> {options}
    ],
    Example[{Options, ReplicateDilutionCurve, "The ReplicateDilutionCurve option defaults to False if the AssayType is ColloidalStability and the AssayFormFactor is Capillary:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, ReplicateDilutionCurve],
      False,
      Variables :> {options}
    ],
    Example[{Options, ReplicateDilutionCurve, "The ReplicateDilutionCurve option defaults to True if the AssayType is ColloidalStability and the AssayFormFactor is Plate:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, ReplicateDilutionCurve],
      True,
      Variables :> {options}
    ],
    Example[{Options, StandardDilutionCurve, "The StandardDilutionCurve option defaults to Null if the AssayType is SizingPolydispersity or IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        Output -> Options
      ];
      Lookup[options, StandardDilutionCurve],
      Null,
      Variables :> {options}
    ],
    Example[{Options, StandardDilutionCurve, "The StandardDilutionCurve option defaults to Null if the SerialDilutionCurve is specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        SerialDilutionCurve -> {
          45 * Microliter,
          {1, 1.25, 1.333, 1.5, 2},
          1
        },
        Output -> Options
      ];
      Lookup[options, StandardDilutionCurve],
      Null,
      Variables :> {options}
    ],
    Example[{Options, StandardDilutionCurve, "When the AssayFormFactor is Capillary, the AssayType is ColloidalStability, the SerialDilutionCurve is not specified, and the ReplicateDilutionCurve option is False, the StandardDilutionCurve option defaults to a curve with a \"Sample Volume\" of (14 uL times the NumberOfReplicates) and \"Target Concentrations\" of {10 mg/mL, 8 mg/mL, 6 mg/mL, 4 mg/mL, and 2 mg/mL}, giving five concentrations which span a 5-fold dilution:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        ReplicateDilutionCurve -> False,
        NumberOfReplicates -> 3,
        Output -> Options
      ];
      Lookup[options, StandardDilutionCurve],
      {
        {45 * Microliter, 10.*(Milligram/Milliliter)},
        {45 * Microliter, 8.*(Milligram/Milliliter)},
        {45 * Microliter, 6.*(Milligram/Milliliter)},
        {45 * Microliter, 4.*(Milligram/Milliliter)},
        {45 * Microliter, 2.*(Milligram/Milliliter)}
      },
      Variables :> {options}
    ],
    Example[{Options, StandardDilutionCurve, "When the AssayFormFactor is Capillary, the AssayType is ColloidalStability, the SerialDilutionCurve is Null, and the ReplicateDilutionCurve option is True, the StandardDilutionCurve option defaults to a curve with a \"Sample Volume\" of 15 uL and \"DilutionFactors\" of {1, 0.8, 0.6, 0.4, 0.2}, giving five concentrations which span a 5-fold dilution. If the input sample has a mass concentration of 10 mg/mL, the five dilution concentrations will be 10, 8, 6, 4, and 2 mg/mL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        ReplicateDilutionCurve -> True,
        Output -> Options
      ];
      Lookup[options, StandardDilutionCurve],
      {
        {15 * Microliter, 10.*(Milligram/Milliliter)},
        {15 * Microliter, 8.*(Milligram/Milliliter)},
        {15 * Microliter, 6.*(Milligram/Milliliter)},
        {15 * Microliter, 4.*(Milligram/Milliliter)},
        {15 * Microliter, 2.*(Milligram/Milliliter)}
      },
      Variables :> {options}
    ],
    Example[{Options, StandardDilutionCurve, "When the AssayFormFactor is Plate, the AssayType is ColloidalStability, the SerialDilutionCurve is Null, and the ReplicateDilutionCurve option is True, the StandardDilutionCurve option defaults to a curve with a \"Sample Volume\" of 90 uL and \"DilutionFactors\" of {1, 0.8, 0.6, 0.4, 0.2}, giving five concentrations which span a 5-fold dilution. If the input sample has a mass concentration of 10 mg/mL, the five dilution concentrations will be 10, 8, 6, 4, and 2 mg/mL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        ReplicateDilutionCurve -> True,
        Output -> Options
      ];
      Lookup[options, StandardDilutionCurve],
      {
        {90 * Microliter, 10.*(Milligram/Milliliter)},
        {72 * Microliter, 8.*(Milligram/Milliliter)},
        {54 * Microliter, 6.*(Milligram/Milliliter)},
        {36 * Microliter, 4.*(Milligram/Milliliter)},
        {18 * Microliter, 2.*(Milligram/Milliliter)}
      },
      Variables :> {options}
    ],
    Example[{Options, Analyte, "The Analyte option defaults to Null if the AssayType is SizingPolydispersity or IsothermalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        CollectStaticLightScattering -> False,
        Output -> Options
      ];
      Lookup[options, Analyte],
      Null,
      Variables :> {options}
    ],
    Example[{Options, Analyte, "The Analyte option defaults to the most concentrated Model[Molecule,Protein] in the input sample's Composition field if the AssayType is ColloidalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, Analyte],
      ObjectP[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, AnalyteMassConcentration, "The AnalyteMassConcentration option defaults to Null if the AssayType is SizingPolydispersity or IsothermalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        CollectStaticLightScattering -> False,
        Output -> Options
      ];
      Lookup[options, AnalyteMassConcentration],
      Null,
      Variables :> {options}
    ],
    Example[{Options, AnalyteMassConcentration, "The AnalyteMassConcentration option defaults to the mass concentration of the most concentrated Model[Molecule,Protein] in the input sample's Composition field if the AssayType is ColloidalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, AnalyteMassConcentration],
      10 * Milligram / Milliliter,
      Variables :> {options},
      EquivalenceFunction -> Equal
    ],
    Example[{Options, SerialDilutionCurve, "The SerialDilutionCurve option defaults to Null if the AssayType is SizingPolydispersity or IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> IsothermalStability,
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      Null,
      Variables :> {options}
    ],
    Example[{Options, SerialDilutionCurve, "The SerialDilutionCurve option defaults to Null if the StandardDilutionCurve option is specified:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        StandardDilutionCurve -> {
          {42 * Microliter, 10 * (Milligram/Milliliter)},
          {42 * Microliter, 8 * (Milligram/Milliliter)},
          {42 * Microliter, 6 * (Milligram/Milliliter)},
          {42 * Microliter, 4 * (Milligram/Milliliter)},
          {42 * Microliter, 2 * (Milligram/Milliliter)}
        },
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      Null,
      Variables :> {options}
    ],
    Example[{Options, SerialDilutionCurve, "When the AssayFormFactor is Capillary, the AssayType is ColloidalStability, the StandardDilutionCurve is Null, and the ReplicateDilutionCurve option is False, the SerialDilutionCurve option defaults to a curve with a \"Sample Volume\" of (15 uL times the NumberOfReplicates) and a \"Variable Dilution Factor\" of {1,0.8,0.75,0.667,0.5}, giving five concentrations which span a 5-fold dilution. If the input sample has a mass concentration of 10 mg/mL, the five dilution concentrations will be 10, 8, 6, 4, and 2 mg/mL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        ReplicateDilutionCurve -> False,
        StandardDilutionCurve -> Null,
        NumberOfReplicates -> 3,
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      {
        45 * Microliter,
        {1, 1.25, 1.333, 1.5, 2},
        1
      },
      Variables :> {options}
    ],
    Example[{Options, SerialDilutionCurve, "When the AssayFormFactor is Capillary, the AssayType is ColloidalStability, the StandardDilutionCurve is Null, and the ReplicateDilutionCurve option is True, the SerialDilutionCurve option defaults to a curve with a \"Sample Volume\" of 15 uL and a \"Variable Dilution Factor\" of {1, 1.25, 1.333, 1.5, 2}, giving five concentrations which span a 5-fold dilution. If the input sample has a mass concentration of 10 mg/mL, the five dilution concentrations will be 10, 8, 6, 4, and 2 mg/mL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Capillary,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        StandardDilutionCurve -> Null,
        ReplicateDilutionCurve -> True,
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      {
        15 * Microliter,
        {1, 1.25, 1.333, 1.5, 2},
        1
      },
      Variables :> {options}
    ],
    Example[{Options, SerialDilutionCurve, "When the AssayFormFactor is Plate, the AssayType is ColloidalStability, the StandardDilutionCurve is Null, and the ReplicateDilutionCurve option is True, the SerialDilutionCurve option defaults to a curve with a \"Sample Volume\" of 30 uL and a \"Variable Dilution Factor\" of {1,0.8,0.75,0.667,0.5}, giving five concentrations which span a 5-fold dilution. If the input sample has a mass concentration of 10 mg/mL, the five dilution concentrations will be 10, 8, 6, 4, and 2 mg/mL:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayFormFactor -> Plate,
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        StandardDilutionCurve -> Null,
        ReplicateDilutionCurve -> True,
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      {
        90 * Microliter,
        {1, 1.25, 1.333, 1.5, 2},
        1
      },
      Variables :> {options}
    ],
    Example[{Options, DilutionNumberOfMixes, "The DilutionNumberOfMixes defaults to Null if the AssayType is either SizingPolydispersity or IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        Output -> Options
      ];
      Lookup[options, DilutionNumberOfMixes],
      Null,
      Variables :> {options}
    ],
    Example[{Options, DilutionNumberOfMixes, "The DilutionNumberOfMixes defaults to Null if the DilutionMixType is set to :"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        DilutionMixType -> Null,
        Output -> Options
      ];
      Lookup[options, DilutionNumberOfMixes],
      Null,
      Variables :> {options}
    ],
    Example[{Options, DilutionNumberOfMixes, "The DilutionNumberOfMixes defaults to 5 if the AssayType is ColloidalStability and the DilutionVolume is not Null:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, DilutionNumberOfMixes],
      5,
      Variables :> {options}
    ],
    Example[{Options, DilutionMixRate, "The DilutionNumberOfMixes defaults to 30 uL/s if the AssayType is ColloidalStability and the DilutionVolume is not Null:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, DilutionMixRate],
      30 * Microliter / Second,
      Variables :> {options}
    ],
    Example[{Options, DilutionMixRate, "The DilutionMixRate defaults to Null if the AssayType is either SizingPolydispersity or IsothermalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        Output -> Options
      ];
      Lookup[options, DilutionMixRate],
      Null,
      Variables :> {options}
    ],
    Example[{Options, DilutionMixRate, "The DilutionMixRate defaults to Null if the DilutionMixType is not Pipette:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        DilutionMixType -> Vortex,
        Output -> Options
      ];
      Lookup[options, DilutionMixRate],
      Null,
      Variables :> {options}
    ],
    Example[{Options, Buffer, "The Buffer defaults to Null if the AssayType is either SizingPolydispersity or IsothermalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        CollectStaticLightScattering -> False,
        Output -> Options
      ];
      Lookup[options, Buffer],
      Null,
      Variables :> {options}
    ],
    Example[{Options, Buffer, "The Buffer defaults to Model[Sample, \"Milli-Q water\"] if the AssayType is ColloidalStability and the input sample does not have its Solvent populated, or has no Model[Sample]s in the Solvent field:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Output -> Options
      ];
      Lookup[options, Buffer],
      Model[Sample, "id:8qZ1VWNmdLBD"],(*"Milli-Q water"*)
      Variables :> {options},
      Messages :> {
        Warning::DLSBufferNotSpecified
      },
      SetUp:>(On[Warning::DLSBufferNotSpecified]),
      TearDown:>(Off[Warning::DLSBufferNotSpecified])
    ],
    Example[{Options, Buffer, "The Buffer defaults to the Model[Sample] with the largest VolumePercentage of the input sample's Solvent field if the AssayType is ColloidalStability and the sample's Solvent field is populated:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test protein sample with populated Solvent Field for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Output -> Options
      ];
      Lookup[options, Buffer],
      Model[Sample, StockSolution, "id:J8AY5jwzPdaB"],
      Variables :> {options}
    ],

    Example[{Options, BlankBuffer, "The BlankBuffer defaults to Null if the AssayType is either SizingPolydispersity or IsothermalStability and CollectStaticLightScattering is False:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> SizingPolydispersity,
        CollectStaticLightScattering -> False,
        Output -> Options
      ];
      Lookup[options, BlankBuffer],
      Null,
      Variables :> {options}
    ],
    Example[{Options, BlankBuffer, "The BlankBuffer defaults to the Buffer if the AssayType is ColloidalStability:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        AssayType -> ColloidalStability,
        Buffer -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
        Output -> Options
      ];
      Lookup[options, BlankBuffer],
      ObjectP[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
      Variables :> {options}
    ],
    (* - Shared option unit tests - *)
    Example[{Options, Template, "Inherit options from a previously run protocol:"},
      options = ExperimentDynamicLightScattering[
        Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Template -> Object[Protocol, DynamicLightScattering, "Test IsothermalStability DynamicLightScattering option template protocol" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, AssayType],
      IsothermalStability,
      Variables :> {options}
    ],
    Example[{Options, Name, "Name the protocol for DynamicLightScattering:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        Name -> "Super cool test protocol",
        Output -> Options
      ];
      Lookup[options, Name],
      "Super cool test protocol",
      Variables :> {options}
    ],
    Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], ImageSample -> True, Output -> Options];
      Lookup[options, ImageSample],
      True,
      Variables :> {options}
    ],
    Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
      Lookup[options, MeasureVolume],
      True,
      Variables :> {options}
    ],
    Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
      Lookup[options, MeasureWeight],
      True,
      Variables :> {options}
    ],
    Example[{Options, SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options, SamplesInStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],
    (* - Sample Prep unit tests - *)
    Example[{Options, PreparatoryUnitOperations, "Specify prepared samples to be run in a dynamic light scattering experiment:"},
      options = ExperimentDynamicLightScattering["Protein Container",
        PreparatoryUnitOperations -> {
          LabelContainer[
            Label -> "Protein Container",
            Container -> Model[Container, Vessel, "id:3em6Zv9NjjN8"]
          ],
          Transfer[
            Source -> Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
            Amount -> 100 * Microliter,
            Destination -> {"A1", "Protein Container"}
          ],
          Transfer[
            Source -> Model[Sample, "Milli-Q water"],
            Amount -> 100 * Microliter,
            Destination -> {"A1", "Protein Container"}
          ]
        },
        Output -> Options
      ];
      Lookup[options, AssayType],
      SizingPolydispersity,
      Variables :> {options}
    ],
    (* Incubate Options *)
    Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Incubate -> True, Output -> Options];
      Lookup[options, Incubate],
      True,
      Variables :> {options}
    ],
    Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], IncubationTemperature -> 40 * Celsius, Output -> Options];
      Lookup[options, IncubationTemperature],
      40 * Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], IncubationTime -> 40 * Minute, Output -> Options];
      Lookup[options, IncubationTime],
      40 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], MaxIncubationTime -> 40 * Minute, Output -> Options];
      Lookup[options, MaxIncubationTime],
      40 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
      Lookup[options, IncubationInstrument],
      ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
      Variables :> {options}
    ],
    Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], AnnealingTime -> 40 * Minute, Output -> Options];
      Lookup[options, AnnealingTime],
      40 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], IncubateAliquot -> 0.49 * Milliliter, Output -> Options];
      Lookup[options, IncubateAliquot],
      0.49 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, IncubateAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], IncubateAliquotDestinationWell -> "A1", IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, IncubateAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],
    Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Mix -> True, Output -> Options];
      Lookup[options, Mix],
      True,
      Variables :> {options}
    ],
    (* Note: You CANNOT be in a plate for the following test. *)
    Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], MixType -> Shake, Output -> Options];
      Lookup[options, MixType],
      Shake,
      Variables :> {options}
    ],
    Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
      Lookup[options, MixUntilDissolved],
      True,
      Variables :> {options}
    ],

    (* Centrifuge Options *)
    Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Centrifuge -> True, Output -> Options];
      Lookup[options, Centrifuge],
      True,
      Variables :> {options}
    ],
    (* Note: Put your sample in a 2mL tube for the following test. *)
    Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
      Lookup[options, CentrifugeInstrument],
      ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
      Variables :> {options}
    ],
    Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], CentrifugeIntensity -> 1000 * RPM, Output -> Options];
      Lookup[options, CentrifugeIntensity],
      1000 * RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
    Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], CentrifugeTime -> 5 * Minute, Output -> Options];
      Lookup[options, CentrifugeTime],
      5 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], CentrifugeTemperature -> 30 * Celsius, CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, CentrifugeTemperature],
      30 * Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], CentrifugeAliquot -> 0.49 * Milliliter, Output -> Options];
      Lookup[options, CentrifugeAliquot],
      0.49 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, CentrifugeAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
      Lookup[options, CentrifugeAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],

    (* Filter Options *)
    Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Filtration -> True, Output -> Options];
      Lookup[options, Filtration],
      True,
      Variables :> {options}
    ],
    Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
      Lookup[options, FiltrationType],
      Syringe,
      Variables :> {options}
    ],
    Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
      Lookup[options, FilterInstrument],
      ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
      Variables :> {options}
    ],
    Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
      Lookup[options, Filter],
      ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
      Variables :> {options}
    ],
    Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FilterMaterial -> PES, FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, FilterMaterial],
      PES,
      Variables :> {options}
    ],
    Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "25 mL water sample in 50mL Tube for ExperimentDynamicLightScattering tests" <> $SessionUUID], PrefilterMaterial -> GxF, CollectStaticLightScattering -> False, Output -> Options];
      Lookup[options, PrefilterMaterial],
      GxF,
      Variables :> {options}
    ],
    Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
      Lookup[options, FilterPoreSize],
      0.22 * Micrometer,
      Variables :> {options}
    ],
    Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "25 mL water sample in 50mL Tube for ExperimentDynamicLightScattering tests" <> $SessionUUID], PrefilterPoreSize -> 1. * Micrometer, FilterMaterial -> PTFE, CollectStaticLightScattering -> False, Output -> Options];
      Lookup[options, PrefilterPoreSize],
      1. * Micrometer,
      Variables :> {options}
    ],
    Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
      Lookup[options, FilterSyringe],
      ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
      Variables :> {options}
    ],
    Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "25 mL water sample in 50mL Tube for ExperimentDynamicLightScattering tests" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], CollectStaticLightScattering -> False, Output -> Options];
      Lookup[options, FilterHousing],
      ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
      Variables :> {options}
    ],
    Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000 * RPM, Output -> Options];
      Lookup[options, FilterIntensity],
      1000 * RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20 * Minute, Output -> Options];
      Lookup[options, FilterTime],
      20 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10 * Celsius, Output -> Options];
      Lookup[options, FilterTemperature],
      10 * Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FilterSterile -> True, Output -> Options];
      Lookup[options, FilterSterile],
      True,
      Variables :> {options}
    ],
    Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FilterAliquot -> 0.49 * Milliliter, Output -> Options];
      Lookup[options, FilterAliquot],
      0.49 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, FilterAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, FilterContainerOut],
      {1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
      Lookup[options, FilterAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],

    (* Aliquot options *)
    Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Aliquot -> True, Output -> Options];
      Lookup[options, Aliquot],
      True,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], AliquotAmount -> 0.49 * Milliliter, Output -> Options];
      Lookup[options, AliquotAmount],
      0.49 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], AssayVolume -> 0.5 * Milliliter, Output -> Options];
      Lookup[options, AssayVolume],
      0.5 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and ConcentratedBufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], TargetConcentration -> 5 * Milligram / Milliliter, AssayVolume -> 100 * Microliter, Output -> Options];
      Lookup[options, TargetConcentration],
      5 * Milligram / Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 20 uM 40 kDa protein sample for ExperimentDynamicLightScattering tests" <> $SessionUUID], TargetConcentration -> 5 * Micromolar, TargetConcentrationAnalyte -> Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID], Output -> Options];
      Lookup[options, TargetConcentrationAnalyte],
      ObjectP[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the ConcentratedBufferDilutionFactor with the ConcentratedBufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        ConcentratedBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],
        BufferDilutionFactor -> 2,(*todo: change this name when dilution is merged*)
        BufferDiluent -> Model[Sample, "Milli-Q water"],(*todo: change this name when dilution is merged*)
        AliquotAmount -> 0.2 * Milliliter,
        AssayVolume -> 0.5 * Milliliter,
        Output -> Options
      ];
      Lookup[options, ConcentratedBuffer],
      ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
      Variables :> {options}
    ],
    Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        BufferDilutionFactor -> 10,(*todo: change this name when dilution is merged*)
        ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
        BufferDiluent -> Model[Sample, "Milli-Q water"],(*todo: change this name when dilution is merged*)
        AliquotAmount -> 0.1 * Milliliter,
        AssayVolume -> 0.8 * Milliliter,
        Output -> Options
      ];
      Lookup[options, BufferDilutionFactor],
      10,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (*todo: change this name when dilution is merged*)Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by ConcentratedBufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
        BufferDilutionFactor -> 10,
        ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
        BufferDiluent -> Model[Sample, "Milli-Q water"],
        AliquotAmount -> 0.2 * Milliliter,
        AssayVolume -> 0.8 * Milliliter,
        Output -> Options
      ];
      Lookup[options, BufferDiluent],
      ObjectP[Model[Sample, "Milli-Q water"]],
      Variables :> {options}
    ],
    Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"], AliquotAmount -> 0.2 * Milliliter, AssayVolume -> 0.8 * Milliliter, Output -> Options];
      Lookup[options, AssayBuffer],
      ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
      Variables :> {options}
    ],
    Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options, AliquotSampleStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],
    Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
      options = ExperimentDynamicLightScattering[{Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID]}, ConsolidateAliquots -> True, Output -> Options];
      Lookup[options, ConsolidateAliquots],
      True,
      Variables :> {options}
    ],
    Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
      Lookup[options, AliquotPreparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, AliquotContainer],
      _List,
      Variables :> {options}
    ],
    Example[{Options, DestinationWell, "Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentDynamicLightScattering[Object[Sample, "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
      Lookup[options, DestinationWell],
      {"A1","A1"},
      Variables :> {options}
    ]
  },
  Parallel->True,
  TurnOffMessages :> {Warning::SamplesOutOfStock},
  Stubs:>{
    $EmailEnabled=False,
    $AllowSystemsProtocols = True,
    $PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
  },

  (* Turn this off, as default behavior for DLS is to do CollectStaticLightScattering on a Plate and it does want Buffer specified at that point *)
  SetUp:>(Off[Warning::DLSBufferNotSpecified]),

  SymbolSetUp:>(

    (* Turn off the SamplesOutOfStock warning for unit tests *)
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    (* Erase any of the test objects that somehow may still exist *)
    dlsUnitTestCleanUp[];

    Block[{$AllowSystemsProtocols=True},
      Module[
        {
          fakeBench,

          container1,container2,container3,container4,container5,container6,container7,container8,container9,container10,container11,
          container12,container13,container14,container15,container16,container17,container18,container19,container20,container21,
          container22,container23, container24,

          sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,sample12,sample13,sample14,sample15,
          sample16, sample17, sample18,
          numSamplesInAssayPlate
        },

        (* Upload a test bench to put containers onto *)
        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Bench for ExperimentDynamicLightScattering tests" <> $SessionUUID, DeveloperObject -> True, Site->Link[$Site], StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* Upload test Containers *)
        {
          container1,
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
          container15,
          container16,
          container17,
          container18,
          container19,
          container20,
          container21,
          container22,
          container23,
          container24
        }=UploadSample[
          {
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Plate, "96-well PCR Plate"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Plate, CapillaryStrip, "Uncle 16-capillary strip"],
            Model[Container, Plate, CapillaryStrip, "Uncle 16-capillary strip"],
            Model[Container, Plate, "96 well Flat Bottom DLS Plate"],
            Model[Container, Plate, "96 well Flat Bottom DLS Plate"],
            Model[Container, Plate, "96 well Flat Bottom DLS Plate"],
            Model[Container, Plate, CapillaryStrip, "Uncle 16-capillary strip"],
            Model[Container, Plate, CapillaryStrip, "Uncle 16-capillary strip"],
            Model[Container, Plate, CapillaryStrip, "Uncle 16-capillary strip"],
            Model[Container, Vessel, "2mL Tube"],
            Model[Container, Plate, "96 well Flat Bottom DLS Plate"]
          },
          ConstantArray[{"Work Surface", fakeBench},24],
          Status -> Available,
          Name->{
            "Container 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 3 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Occupied plate for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 5 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 6 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 7 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 8 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 9 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 10 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 11 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 12 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 13 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 14 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Empty Capillary AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Filled Capillary AssayContainer for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Partially Filled Plate AssayContainer for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Empty Plate AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Empty Plate AssayContainer 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Empty Capillary AssayContainer 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Empty Capillary AssayContainer 3 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Empty Capillary AssayContainer 4 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 23 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Container 24 (preplated plate) for ExperimentDynamicLightScattering tests" <> $SessionUUID
          }
        ];

        (* Create a test Model[Molecule]s to populate the Composition field test inputs, as well a fake instrument Model and Object *)
        Upload[
          {
            <|
              Type->Model[Molecule,Protein],
              Name->"Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID,
              MolecularWeight->40*(Kilogram/Mole),
              DeveloperObject->True
            |>,
            <|
              Type->Model[Molecule,Protein],
              Name->"Test 100 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID,
              MolecularWeight->100*(Kilogram/Mole),
              DeveloperObject->True
            |>,
            <|
              Type->Model[Molecule,cDNA],
              Name->"Test Model[Molecule,cDNA] for ExperimentDynamicLightScattering Tests" <> $SessionUUID,
              MolecularWeight->20*(Kilogram/Mole),
              DeveloperObject->True
            |>,
            <|
              Type->Model[Molecule,Polymer],
              Name->"Test Model[Molecule,Polymer] for ExperimentDynamicLightScattering Tests" <> $SessionUUID,
              MolecularWeight->1000*(Kilogram/Mole),
              DeveloperObject->True
            |>,
            <|
              Type->Model[Molecule,Oligomer],
              Name->"Test Model[Molecule,Oligomer] for ExperimentDynamicLightScattering Tests" <> $SessionUUID,
              MolecularWeight->800*(Kilogram/Mole),
              DeveloperObject->True
            |>,
            <|
              Type->Model[Molecule,Protein],
              Name->"Test Model[Molecule,Protein] with no MolecularWeight for ExperimentDynamicLightScattering Tests" <> $SessionUUID,
              DeveloperObject->True
            |>,
            <|
              Type->Model[Instrument,MultimodeSpectrophotometer],
              Name->"Unsupported instrument Model for ExperimentDynamicLightScattering Tests" <> $SessionUUID,
              DeveloperObject->True
            |>,
            <|
              Type->Object[Instrument,MultimodeSpectrophotometer],
              Name->"Uncle Instrument for ExperimentDynamicLightScattering Tests" <> $SessionUUID,
              Model->Link[Model[Instrument, MultimodeSpectrophotometer, "Uncle"],Objects],
              Site->Link[$Site],
              DeveloperObject->True
            |>,
            <|
              Type->Object[Protocol,DynamicLightScattering],
              DeveloperObject->True,
              Name->"Test IsothermalStability DynamicLightScattering option template protocol" <> $SessionUUID,
              ResolvedOptions->{AssayType->IsothermalStability}
            |>
          }
        ];

        (* Create test Model[Sample]s *)
        Upload[
          {
            <|
              Type->Model[Sample],
              Name->"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"daniel.shlian"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>,
            <|
              Type->Model[Sample],
              Name->"Test mixture of proteins Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"daniel.shlian"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {20*(Milligram/Milliliter),Link[Model[Molecule, Protein, "Test 100 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>,
            <|
              Type->Model[Sample],
              Name->"50 mg/mL 40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"daniel.shlian"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {50*(Milligram/Milliliter),Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>,
            <|
              Type->Model[Sample],
              Name->"40 kDa test protein Model[Sample] with Concentration in uM for ExperimentTotalProteinDetection" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"daniel.shlian"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {20*Micromolar,Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>,
            <|
              Type->Model[Sample],
              Name->"20 kDa test cDNA Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"daniel.shlian"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, cDNA, "Test Model[Molecule,cDNA] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>,
            <|
              Type->Model[Sample],
              Name->"800 kDa test Oligomer Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"daniel.shlian"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, Oligomer, "Test Model[Molecule,Oligomer] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>,
            <|
              Type->Model[Sample],
              Name->"1000 kDa test Polymer Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"daniel.shlian"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, Polymer, "Test Model[Molecule,Polymer] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>,
            <|
              Type->Model[Sample],
              Name->"Test no MW protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID,
              Replace[Authors]->{Link[Object[User,Emerald,Developer,"daniel.shlian"]]},
              DeveloperObject->True,
              DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
              Replace[Composition]->{
                {10*(Milligram/Milliliter),Link[Model[Molecule, Protein, "Test Model[Molecule,Protein] with no MolecularWeight for ExperimentDynamicLightScattering Tests" <> $SessionUUID]]},
                {100*VolumePercent,Link[Model[Molecule, "Water"]]}
              }
            |>
          }
        ];

        (* Upload Object[Sample]s to use in the unit tests *)
        {
          sample1,
          sample2,
          sample3,
          sample4,
          sample5,
          sample6,
          sample7,
          sample8,
          sample9,
          sample10,
          sample11,
          sample12,
          sample13,
          sample14,
          sample15,
          sample16,
          sample17,
          sample18
        }=UploadSample[
          {
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample, "Milli-Q water"],
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample, "Milli-Q water"],
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"Test mixture of proteins Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"50 mg/mL 40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"40 kDa test protein Model[Sample] with Concentration in uM for ExperimentTotalProteinDetection" <> $SessionUUID],
            Model[Sample,"20 kDa test cDNA Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"800 kDa test Oligomer Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"1000 kDa test Polymer Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample, "Milli-Q water"],
            Model[Sample,"Test no MW protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
            Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID]
          },
          {
            {"A1", container1},
            {"A1", container2},
            {"A1", container3},
            {"A1", container4},
            {"A1", container5},
            {"A1", container6},
            {"A1", container7},
            {"A1", container8},
            {"A1", container9},
            {"A1", container10},
            {"A1", container11},
            {"A1", container12},
            {"A1", container13},
            {"A1", container14},
            {"A1", container16},
            {"A1", container23},
            {"A1", container24},
            {"B1", container24}
          },
          InitialAmount->{
            25*Milliliter,
            1.5*Milliliter,
            1.7*Milliliter,
            1.5*Milliliter,
            1.5*Milliliter,
            1.5*Milliliter,
            25*Milliliter,
            1.5*Milliliter,
            1.7*Milliliter,
            1.5*Milliliter,
            1.5*Milliliter,
            1.5*Milliliter,
            1.5*Milliliter,
            1.5*Milliliter,
            5 Microliter,
            1.5Milliliter,
            100*Microliter,
            100*Microliter
          },
          Name->{
            "Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID,
            "Discarded test sample for ExperimentDynamicLightScattering" <> $SessionUUID,
            "Test protein sample with populated Solvent Field for ExperimentDynamicLightScattering" <> $SessionUUID,
            "Test sample in SampleLoadingPlate for ExperimentDynamicLightScattering" <> $SessionUUID,
            "Test 1 mL water for ExperimentDynamicLightScattering" <> $SessionUUID,
            "Test unknown concentration protein sample for ExperimentDynamicLightScattering" <> $SessionUUID,
            "25 mL water sample in 50mL Tube for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Test Model-less protein sample for ExperimentDynamicLightScattering" <> $SessionUUID,
            "Mixture of proteins sample for ExperimentDynamicLightScattering" <> $SessionUUID,
            "Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID,
            "Test 20 uM 40 kDa protein sample for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Test cDNA sample for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Test Oligomer sample for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Test Polymer sample for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Test Water sample in capillary for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Test no MW Protein sample for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Test preplated sample 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID,
            "Test preplated sample 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID
          }
        ];

        (* Upload Samples into our test Plate AssayContainer *)
        numSamplesInAssayPlate = 10;
        Block[{$DeveloperUpload=True},
          UploadSample[
            ConstantArray[Model[Sample, "Milli-Q water"],numSamplesInAssayPlate],
            MapThread[{#1,#2}&,{Flatten[AllWells[]][[1 ;; numSamplesInAssayPlate]],ConstantArray[container17,numSamplesInAssayPlate]}],
            InitialAmount->ConstantArray[0.5 Milliliter,numSamplesInAssayPlate],
            Name -> (("Test Water sample " <> ToString[#] <>" in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID)&/@Range[numSamplesInAssayPlate])
          ]
        ];

        (* Make the Objects DeveloperObjects and set the statuses *)
        Upload[
          Flatten[
            Join[
              Map[
                <|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|>&,
                Cases[
                  Flatten[
                    {
                      container1,container2,container3,container4,container5,container6,container7,container8,container9,
                      container10,container11,container12,container13,container14,container15,container16,container17,container18,
                      container19,container20,container21,container22,container23,container24,
                      sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,sample12,
                      sample13,sample14,sample15,sample16,sample17,sample18
                    }
                  ],
                  ObjectP[]]
              ],
              Cases[
                Flatten[
                  {
                    <|Object -> sample1, Status -> Available,MassConcentration->10*Milligram/Milliliter|>,
                    <|Object -> sample2, Status -> Discarded|>,
                    <|Object -> sample3, Status -> Available,Solvent->Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]]|>,
                    <|Object -> sample4, Status -> Available|>,
                    <|Object -> sample5, Status -> Available|>,
                    <|Object -> sample6, Status -> Available,Replace[Composition]->{{Null,Link[Model[Molecule, Protein, "Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID]], Now}, {100*VolumePercent,Link[Model[Molecule, "Water"]], Now}}|>,
                    <|Object -> sample7, Status -> Available|>,
                    <|Object -> sample8, Status -> Available,Model->Null|>,
                    <|Object -> sample9, Status -> Available|>,
                    <|Object -> sample10, Status -> Available|>,
                    <|Object -> sample11, Status -> Available|>,
                    <|Object -> sample12, Status -> Available|>,
                    <|Object -> sample13, Status -> Available|>,
                    <|Object -> sample14, Status -> Available|>,
                    <|Object -> sample15, Status -> Available|>,
                    <|Object -> sample17, Status -> Available|>,
                    <|Object -> sample18, Status -> Available|>
                  }
                ],
                PacketP[]
              ]
            ]
          ]
        ];

      ]
    ];
  ),
  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    dlsUnitTestCleanUp[];
  )
];

dlsUnitTestCleanUp[]:=Module[{objects,existingObjects},
  objects=Quiet[Cases[
    Flatten[{
      Object[Container, Bench, "Bench for ExperimentDynamicLightScattering tests" <> $SessionUUID],

      Object[Container,Vessel,"Container 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 3 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Plate,"Occupied plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 5 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 6 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 7 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 8 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 9 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 10 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 11 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 12 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 13 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 14 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container, Plate, CapillaryStrip, "Empty Capillary AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container, Plate, CapillaryStrip, "Filled Capillary AssayContainer for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Plate,"Partially Filled Plate AssayContainer for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Plate,"Empty Plate AssayContainer 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Plate,"Empty Plate AssayContainer 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container, Plate, CapillaryStrip, "Empty Capillary AssayContainer 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container, Plate, CapillaryStrip, "Empty Capillary AssayContainer 3 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container, Plate, CapillaryStrip, "Empty Capillary AssayContainer 4 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container,Vessel,"Container 23 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Container, Plate, "Container 24 (preplated plate) for ExperimentDynamicLightScattering tests" <> $SessionUUID],

      Model[Instrument,MultimodeSpectrophotometer,"Unsupported instrument Model for ExperimentDynamicLightScattering Tests" <> $SessionUUID],
      Object[Instrument,MultimodeSpectrophotometer,"Uncle Instrument for ExperimentDynamicLightScattering Tests" <> $SessionUUID],

      Object[Protocol,DynamicLightScattering,"Test IsothermalStability DynamicLightScattering option template protocol" <> $SessionUUID],

      Model[Molecule,Protein,"Test 40 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID],
      Model[Molecule,Protein,"Test 100 kDa Model[Molecule,Protein] for ExperimentDynamicLightScattering Tests" <> $SessionUUID],
      Model[Molecule,Protein,"Test Model[Molecule,Protein] with no MolecularWeight for ExperimentDynamicLightScattering Tests" <> $SessionUUID],
      Model[Molecule,cDNA,"Test Model[Molecule,cDNA] for ExperimentDynamicLightScattering Tests" <> $SessionUUID],
      Model[Molecule,Oligomer,"Test Model[Molecule,Oligomer] for ExperimentDynamicLightScattering Tests" <> $SessionUUID],
      Model[Molecule,Polymer,"Test Model[Molecule,Polymer] for ExperimentDynamicLightScattering Tests" <> $SessionUUID],

      Model[Sample,"40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
      Model[Sample,"Test mixture of proteins Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
      Model[Sample,"50 mg/mL 40 kDa test protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
      Model[Sample,"40 kDa test protein Model[Sample] with Concentration in uM for ExperimentTotalProteinDetection" <> $SessionUUID],
      Model[Sample,"1000 kDa test Polymer Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
      Model[Sample,"800 kDa test Oligomer Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
      Model[Sample,"20 kDa test cDNA Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],
      Model[Sample,"Test no MW protein Model[Sample] for ExperimentDynamicLightScattering" <> $SessionUUID],

      Object[Sample,"Test 10 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"Discarded test sample for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"Test protein sample with populated Solvent Field for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"Test sample in SampleLoadingPlate for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"Test 1 mL water for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"Test unknown concentration protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"25 mL water sample in 50mL Tube for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Model-less protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"Mixture of proteins sample for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"Test 50 mg/mL 40 kDa protein sample for ExperimentDynamicLightScattering" <> $SessionUUID],
      Object[Sample,"Test 20 uM 40 kDa protein sample for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test cDNA sample for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Oligomer sample for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Polymer sample for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample in capillary for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample, "Test preplated sample 1 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample, "Test preplated sample 2 for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 1 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 2 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 3 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 4 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 5 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 6 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 7 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 8 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 9 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test Water sample 10 in plate assay plate for ExperimentDynamicLightScattering tests" <> $SessionUUID],
      Object[Sample,"Test no MW Protein sample for ExperimentDynamicLightScattering tests" <> $SessionUUID]
    }],
    ObjectP[]
  ]];
  existingObjects=PickList[objects,DatabaseMemberQ[objects],True];
  EraseObject[existingObjects,Force->True,Verbose->False]
]
