(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentDigitalPCR: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentDigitalPCR*)

DefineTests[
  ExperimentDigitalPCR,
  {
    (*-- Basic Examples --*)
    Example[{Basic, "Accepts a list of sample objects, and corresponding pairs of primer objects and probe objects:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test sample 2" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}, {{Object[Sample, "ExperimentDigitalPCR test primer 2 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    Example[{Basic, "Accepts multiple pairs of primer objects and probe objects for each sample when multiplexing:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 2 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    Example[{Basic, "Accepts a fully prepared plate ready for digital PCR:"},
      ExperimentDigitalPCR[Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    (*-- Additional Examples --*)
    Example[{Additional, "Accepts primer sets when same object is used for forward and reverse primers:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    Example[{Additional, "Accepts target assay with primers and probe when same object is used for both primers and the probe:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    Example[{Additional, "Accepts sample only input when a probe is a part of sample composition:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]}
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    (*-- Error Messages --*)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentDigitalPCR[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentDigitalPCR[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentDigitalPCR[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentDigitalPCR[Object[Container, Vessel, "id:12345678"]],
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
          {
            {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID]},
            {100 VolumePercent, Model[Molecule, "Water"]}
          },
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentDigitalPCR[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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
          {
            {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID]},
            {100 VolumePercent, Model[Molecule, "Water"]}
          },
          {"A1", containerID},
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        sampleID = Lookup[First[samplePackets], Object];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentDigitalPCR[containerID, Simulation -> simulationToPassIn, Output -> Options]
      ],
      {__Rule}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample/container as primer but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID1,containerID2,containerID3, sampleID1,sampleID2,sampleID3, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          {
            Model[Container,Vessel,"50mL Tube"],
            Model[Container,Vessel,"50mL Tube"],
            Model[Container,Vessel,"50mL Tube"]
          },
          {
            {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
            {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
            {"Work Surface", Object[Container, Bench, "The Bench of Testing"]}
          },
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        {containerID1,containerID2,containerID3} = DeleteDuplicates[Cases[Lookup[containerPackets, Object],ObjectP[Object[Container,Vessel]]]];
        samplePackets = UploadSample[
          {
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"]
          },
          {
            {"A1", containerID1},
            {"A1", containerID2},
            {"A1", containerID3}
          },
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        {sampleID1,sampleID2,sampleID3} = DeleteDuplicates[Cases[Lookup[samplePackets, Object],ObjectP[Object[Sample]]]];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentDigitalPCR[
          containerID1,
          {{sampleID2, containerID3}},
          Null,
          Simulation -> simulationToPassIn,
          Output -> Options
        ]
      ],
      {__Rule},
      Messages :> {Error::DigitalPCRProbeWavelengthsNull,Error::DigitalPCRPremixedPrimerProbe,Error::DigitalPCRForwardPrimerStockConcentration,Error::DigitalPCRReversePrimerStockConcentration,Error::InvalidOption}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample/container as probe but a simulation is specified that indicates that it is simulated:"},
      Module[{containerPackets, containerID1,containerID2,containerID3, sampleID1,sampleID2,sampleID3, samplePackets, simulationToPassIn},
        containerPackets = UploadSample[
          {
            Model[Container,Vessel,"50mL Tube"],
            Model[Container,Vessel,"50mL Tube"],
            Model[Container,Vessel,"50mL Tube"]
          },
          {
            {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
            {"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
            {"Work Surface", Object[Container, Bench, "The Bench of Testing"]}
          },
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True
        ];
        simulationToPassIn = Simulation[containerPackets];
        {containerID1,containerID2,containerID3} = DeleteDuplicates[Cases[Lookup[containerPackets, Object],ObjectP[Object[Container,Vessel]]]];
        samplePackets = UploadSample[
          {
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"]
          },
          {
            {"A1", containerID1},
            {"A1", containerID2},
            {"A1", containerID3}
          },
          Upload -> False,
          SimulationMode -> True,
          FastTrack -> True,
          Simulation -> simulationToPassIn,
          InitialAmount -> 25 Milliliter
        ];
        {sampleID1,sampleID2,sampleID3} = DeleteDuplicates[Cases[Lookup[samplePackets, Object],ObjectP[Object[Sample]]]];
        simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

        ExperimentDigitalPCR[
          containerID1,
          {Null, Null},
          {sampleID2},
          Simulation -> simulationToPassIn,
          Output -> Options
        ]
      ],
      {__Rule},
      Messages :> {Error::DigitalPCRSingleFluorophorePerProbe,Error::DigitalPCRProbeWavelengthsNull,Error::DigitalPCRPremixedPrimerProbe,Error::DigitalPCRProbeStockConcentration,Error::DigitalPCRProbeConcentrationVolumeMismatch,Error::InvalidInput,Error::InvalidOption}
    ],

    (* Protocol Name Exists in database *)
    Example[{Messages, "DuplicateName", "The specified Name cannot already exist for another DigitalPCR protocol:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        Name -> "ExperimentDigitalPCR test protocol" <> $SessionUUID
      ],
      $Failed,
      Messages :> {
        Error::DuplicateName,
        Error::InvalidOption
      }
    ],

    (* Discarded Samples *)
    Example[{Messages, "DiscardedSamples", "The primers cannot have a Status of Discarded:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test discarded primer sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test discarded primer sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DiscardedSamples", "The sample cannot have a Status of Discarded:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test discarded sample with primers and probes" <> $SessionUUID]}
      ],
      $Failed,
      Messages :> {
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],

    (* Deprecated Models *)
    Example[{Messages, "DeprecatedModels", "The primers cannot have a Model that is Deprecated:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test deprecated model sample" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test deprecated model primer sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test deprecated model primer sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DeprecatedModels,
        Error::InvalidInput
      }
    ],
    Example[{Messages, "DeprecatedModels", "The sample cannot have a Model that is Deprecated:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test deprecated model sample with primers and probes" <> $SessionUUID]}
      ],
      $Failed,
      Messages :> {
        Error::DeprecatedModels,
        Error::InvalidInput
      }
    ],

    (* Null composition *)
    (* Liquid vs solid state *)
    Example[{Messages, "DigitalPCRNonLiquidSamples", "The input samples cannot be solid:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test solid sample" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRNonLiquidSamples,
        Error::InvalidInput,
        Error::SolidSamplesUnsupported
      }
    ],

    Example[{Messages, "DigitalPCRNonLiquidSamples", "The input primers cannot be solid:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test solid sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRNonLiquidSamples,
        Error::DigitalPCRForwardPrimerStockConcentration,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidInput,
        Error::InvalidOption
      }
    ],

    (* this test needs to through InvalidOption error only. need to test for solids in inputs vs options separately *)
    Example[{Messages, "DigitalPCRNonLiquidSamples", "The reference primers cannot be solid:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test solid sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRNonLiquidSamples,
        Error::DigitalPCRReferenceForwardPrimerStockConcentration,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidInput,
        Error::InvalidOption
      }
    ],

    (* Prepared Plate *)
    Example[{Messages, "DigitalPCRInvalidPreparedPlate", "When using PreparedPlate, samples should be in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"]:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        PreparedPlate -> True
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRInvalidPreparedPlate,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRInvalidPreparedPlate", "When using PreparedPlate, primerPairs, probes, ReferencePrimerPairs and ReferenceProbes should be Null:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PreparedPlate -> True,
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRInvalidPreparedPlate,
        Error::InvalidInput,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRInvalidPreparedPlate", "When using PreparedPlate with samples in a droplet cartridge, any wells without sample input must contain passive sample required for droplet generation in block of 16 wells in parallel:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes in cartridge unfilled" <> $SessionUUID]},
        PreparedPlate -> True
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRInvalidPreparedPlate,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InvalidInputSampleContainer", "When not using PreparedPlate, samples cannot be in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"]:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 without primers and probes in cartridge" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PreparedPlate -> False
      ],
      $Failed,
      Messages :> {
        Error::InvalidInputSampleContainer,
        Error::InvalidInput
      }
    ],

    Example[{Messages, "DigitalPCRSampleDilutionMismatch", "When SampleDilution is True, SerialDilutionCurve cannot be Null:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        SerialDilutionCurve -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSampleDilutionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRSampleDilutionMismatch", "When SampleDilution is True, DilutionNumberOfMixes cannot be Null:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        DilutionNumberOfMixes -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSampleDilutionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRSampleDilutionMismatch", "When SampleDilution is True, DilutionMixVolume cannot be Null:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        DilutionMixVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSampleDilutionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRSampleDilutionMismatch", "When SampleDilution is True, DilutionMixRate cannot be Null:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        DilutionMixRate -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSampleDilutionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRSampleDilutionMismatch", "When PreparedPlate is True, SampleDilution cannot be True:"},
      ExperimentDigitalPCR[
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID],
        PreparedPlate -> True,
        SampleDilution -> True
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRInvalidPreparedPlate,
        Error::DigitalPCRSampleDilutionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRSampleDilutionMismatch", "When SampleDilution is False, SerialDilutionCurve cannot be specified:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> False,
        SerialDilutionCurve -> {10 * Microliter, {0.5, 3}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSampleDilutionMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRSampleDilutionMismatch", "When SampleDilution is False, DilutionMixVolume cannot be specified:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> False,
        DilutionMixVolume -> {5 * Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSampleDilutionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRDilutionSampleVolume", "When SampleDilution is True, volume of diluted samples to be created must be higher than SampleVolume*1.1 to ensure that sufficient dilute sample volume will be created:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        SerialDilutionCurve -> {5 * Microliter, 5 * Microliter, 3},
        SampleVolume -> 5 * Microliter
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRDilutionSampleVolume,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRDilutionSampleVolume", "When SampleDilution is True and NumberOfReplicates is specified, volume of diluted samples to be created must be higher than SampleVolume*NumberOfReplicates*1.1 to ensure that sufficient dilute sample volume will be created:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        SerialDilutionCurve -> {8 * Microliter, 8 * Microliter, 3},
        NumberOfReplicates -> 2,
        SampleVolume -> 4 * Microliter
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRDilutionSampleVolume,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InvalidInputSampleContainer", "When not using PreparedPlate, samples cannot be in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"]:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 without primers and probes in cartridge" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PreparedPlate -> False
      ],
      $Failed,
      Messages :> {
        Error::InvalidInputSampleContainer,
        Error::InvalidInput
      }
    ],

    Example[{Messages, "ActiveWellOverConstrained", "When using PreparedPlate, ActiveWell must match the position of sample in the prepared plate:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True,
        ActiveWell -> {"B1"}
      ],
      $Failed,
      Messages :> {
        Error::ActiveWellOverConstrained,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCROverConstrainedRowOptions", "When using PreparedPlate, PrimerGradientAnnealingRow must match the row of the sample in the prepared plate:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True,
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        PrimerGradientAnnealingRow -> {"Row B"}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCROverConstrainedRowOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRDiluentVolume", "When using PreparedPlate, DiluentVolume cannot be specified:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True,
        DiluentVolume -> {3 Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRDiluentVolume,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRMasterMixMismatch", "When using PreparedPlate, MasterMixVolume cannot be specified:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True,
        MasterMixVolume -> {11 Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRMasterMixMismatch,
        Error::InvalidOption
      }
    ],

    (* Invalid Secondary Inputs *)
    Example[{Messages, "InvalidPrimerProbeInputs", "For each sample, primerPair and probe inputs are index-matched to each other:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::InvalidPrimerProbeInputs
      }
    ],

    (* Well Assignment & Sample Grouping *)
    Example[{Messages, "ActiveWellOptionLengthMismatch", "ActiveWell are specified for all samples or left as Automatic:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ActiveWell -> {"A1"}
      ],
      $Failed,
      Messages :> {
        Error::ActiveWellOptionLengthMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "ActiveWellOptionLengthMismatch", "ActiveWell are specified for all samples or left as Automatic:"},
      ExperimentDigitalPCR[
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID],
        ActiveWell -> {"A1"}
      ],
      $Failed,
      Messages :> {
        Error::ActiveWellOptionLengthMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InvalidActiveWells", "ActiveWell are specifications are unique for all samples:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ActiveWell -> {"A1", "A1"}
      ],
      $Failed,
      Messages :> {
        Error::InvalidActiveWells,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "InvalidActiveWells", "ActiveWell are specifications comply with 96-well plate format:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ActiveWell -> {"A1", "A13"}
      ],
      $Failed,
      Messages :> {
        Error::InvalidActiveWells,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ThermocyclingOptionsMismatchInPlate", "All input samples in a plate have identical thermocycling options:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ActiveWell -> {{1, "A1"}, {1, "B1"}},
        ReverseTranscription -> {True, False}
      ],
      $Failed,
      Messages :> {
        Error::ThermocyclingOptionsMismatchInPlate,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "ThermocyclingOptionsMismatchInPlate", "When using PreparedPlate, all input samples in a plate have identical thermocycling options:"},
      ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 2 with primers and probes in cartridge" <> $SessionUUID]
        },
        ReverseTranscription -> {True, False}
      ],
      $Failed,
      Messages :> {
        Error::ThermocyclingOptionsMismatchInPlate,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "PassiveWellsAssignment", "For each pair of odd and even numbered columns in a plate (i.e. {{1,2},{3,4}...}) if any well is occupied by a sample, other wells are assigned to passive buffer solution:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ActiveWell -> {"A1"},
        PassiveWells -> {"B1"}
      ],
      $Failed,
      Messages :> {
        Error::PassiveWellsAssignment,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "TooManyPlates", "Total number of plates cannot exceed 5 in a single experiment:"},
      ExperimentDigitalPCR[
        ConstantArray[Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], 6],
        ConstantArray[{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}, 6],
        ConstantArray[{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}, 6],
        PrimerAnnealingTemperature -> Range[55 * Celsius, 60 * Celsius, 1 * Celsius]
      ],
      $Failed,
      Messages :> {
        Error::TooManyPlates,
        Error::InvalidOption
      }
    ],

    (* Master Mix *)
    Example[{Messages, "DigitalPCRMasterMixMismatch", "When not using PreparedPlate, MasterMixConcentrationFactor and MasterMixVolume options do not have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        MasterMixConcentrationFactor -> {Null},
        MasterMixVolume -> {10 Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRMasterMixMismatch,
        Error::InvalidOption
      }
    ],

    (* Thermocycling *)
    Example[{Messages, "DigitalPCRReverseTranscriptionMismatch", "ReverseTranscription options cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscription -> {False},
        ReverseTranscriptionTime -> {1 Minute}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReverseTranscriptionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRActivationMismatch", "Activation options cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Activation -> {False},
        ActivationTime -> {1 Minute}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRActivationMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRPrimerAnnealingMismatch", "PrimerAnnealing options cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerAnnealingTime -> {60 Second}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRPrimerAnnealingMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRPrimerGradientAnnealingMismatch", "PrimerGradientAnnealing options cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerGradientAnnealing -> {False},
        PrimerGradientAnnealingMinTemperature -> {60 Celsius}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRPrimerGradientAnnealingMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRPrimerGradientAnnealingRowTemperatureMismatch", "When PrimerGradientAnnealingRow is specified with Row and Temperature, the specified temperature matches the gradient generated from PrimerGradientMinTemperature and PrimerGradientMaxTemperature:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        PrimerGradientAnnealingMinTemperature -> {55 Celsius},
        PrimerGradientAnnealingMaxTemperature -> {65 Celsius},
        PrimerGradientAnnealingRow -> {{"Row B", 60 Celsius}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRPrimerGradientAnnealingRowTemperatureMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCROverConstrainedRowOptions", "When ActiveWell and PrimerGradientAnnealingRow are specified, they cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ActiveWell -> {"A1"},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        PrimerGradientAnnealingRow -> {"Row B"}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCROverConstrainedRowOptions,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRExtensionMismatch", "Extension options cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Extension -> {False},
        ExtensionTime -> {1 Minute}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRExtensionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRPolymeraseDegradationMismatch", "PolymeraseDegradation options cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradation -> {False},
        PolymeraseDegradationTime -> {1 Minute}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRPolymeraseDegradationMismatch,
        Error::InvalidOption
      }
    ],

    (* Primer/Probe Options *)
    Example[{Messages, "DigitalPCRPremixedPrimerProbe", "Inputs primerPair and probe have identical models or objects for TargetAssay, only primerPair inputs have identical models or objects for PrimerSet, and all three input objects are unique for None:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {
          {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        PremixedPrimerProbe -> {None, None}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRPremixedPrimerProbe,
        Error::DigitalPCRProbeStockConcentration,
        Error::DigitalPCRForwardPrimerStockConcentration,
        Error::DigitalPCRReversePrimerStockConcentration,
        Error::DigitalPCRPrimerProbeMismatchedOptionLengths,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferencePremixedPrimerProbe", "ReferencePrimerPairs and ReferenceProbes have identical models or objects for TargetAssay, only ReferencePrimerPairs inputs have identical models or objects for PrimerSet, and all three reference assay objects are unique for None:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePremixedPrimerProbe -> {None, None}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferencePremixedPrimerProbe,
        Error::DigitalPCRReferenceProbeStockConcentration,
        Error::DigitalPCRReferenceForwardPrimerStockConcentration,
        Error::DigitalPCRReferenceReversePrimerStockConcentration,
        Error::DigitalPCRReferencePrimerProbeMismatchedOptionLengths,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRProbeConcentrationVolumeMismatch", "Probe concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ProbeConcentration -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRProbeConcentrationVolumeMismatch,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRProbeConcentrationVolumeMismatch", "Probe concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ProbeVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRProbeConcentrationVolumeMismatch,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceProbeConcentrationVolumeMismatch", "Reference probe concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceProbeConcentration -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceProbeConcentrationVolumeMismatch", "Reference probe concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceProbeVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerConcentrationVolumeMismatch", "Forward primer concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ForwardPrimerConcentration -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerConcentrationVolumeMismatch", "Forward primer concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ForwardPrimerVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerConcentrationVolumeMismatch", "Reverse primer concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReversePrimerConcentration -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerConcentrationVolumeMismatch", "Reverse primer concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReversePrimerVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch", "Reference forward primer concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceForwardPrimerConcentration -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch", "Reference forward primer concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceForwardPrimerVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch", "Reference reverse primer concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceReversePrimerConcentration -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch", "Reference reverse primer concentration and volume cannot have conflicts:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceReversePrimerVolume -> Null
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRPrimerProbeMismatchedOptionLengths", "Options index-matched with primerPairs and probes have matching lengths:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ForwardPrimerVolume -> {1 * Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRPrimerProbeMismatchedOptionLengths,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferencePrimerProbeMismatchedOptionLengths", "Options index-matched with ReferencePrimerPairs and ReferenceProbes have matching lengths:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceForwardPrimerVolume -> {1 * Microliter, 1 * Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferencePrimerProbeMismatchedOptionLengths,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRTotalVolume", "Sum of volumes of all stock solutions matches the specified ReactionVolume:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ForwardPrimerVolume -> {5 * Microliter, 5 * Microliter},
        ProbeVolume -> {5 * Microliter, 5 * Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRTotalVolume,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRTotalVolume", "Total volume with all components matches ReactionVolume:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        DiluentVolume -> {20 * Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRTotalVolume,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRTotalVolume", "When Model[Sample,\"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer\"] (concentration factor = 4) is used as MasterMix, total volume calculation adjusts for the use of Model[Sample,StockSolution,\"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix\"] (concentration factor = 2) when calculating the total volume:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        MasterMix -> {Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"]},
        DiluentVolume -> {17.8 * Microliter}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRTotalVolume,
        Error::InvalidOption
      }
    ],

    (* Amplitude Multiplexing *)
    Example[{Messages, "DigitalPCRAmplitudeMultiplexing", "AmplitudeMultiplexing is Null if no channel has a count of more than 1:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        AmplitudeMultiplexing -> {{{517. * Nanometer, 1}}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRAmplitudeMultiplexing,
        Error::DigitalPCRProbeConcentrationVolumeMismatch,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRAmplitudeMultiplexing", "AmplitudeMultiplexing channel counts match the emission wavelengths of any input probes and ReferenceProbes:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        AmplitudeMultiplexing -> {{{517. * Nanometer, 2}, {665. * Nanometer, 1}}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRAmplitudeMultiplexing,
        Error::DigitalPCRProbeConcentrationVolumeMismatch,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    (* Probe Fluorescence *)
    Example[{Messages, "DigitalPCRSingleFluorophorePerProbe", "Each probe input object has at most 1 fluorophore tag:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe with multiple fluorophores" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSingleFluorophorePerProbe,
        Error::DigitalPCRProbeWavelengthsLengthMismatch,
        Error::InvalidInput,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRProbeWavelengthsLengthMismatch", "The length of each probe input matches the lengths of excitation and emission channels:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe with multiple fluorophores" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSingleFluorophorePerProbe,
        Error::DigitalPCRProbeWavelengthsLengthMismatch,
        Error::InvalidInput,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRSingleFluorophorePerProbe", "Each probe input object has at least 1 fluorophore tag:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe without fluorescence" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSingleFluorophorePerProbe,
        Error::DigitalPCRProbeWavelengthsNull,
        Error::InvalidInput,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRProbeWavelengthsNull", "Probe fluorescence excitation and emission inputs should not have Null:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe without fluorescence" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSingleFluorophorePerProbe,
        Error::DigitalPCRProbeWavelengthsNull,
        Error::DigitalPCRProbeWavelengthsIncompatible,
        Error::InvalidInput,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRProbeWavelengthsNull", "When PreparedPlate is True, probe fluorescence excitation and emission inputs cannot be Null:"},
      ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1 without primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRProbeWavelengthsNull,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRProbeWavelengthsIncompatible", "Probe fluorescence wavelengths are compatible with instrument channels:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe with incompatible fluorophore" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRProbeWavelengthsIncompatible,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRSingleReferenceFluorophorePerProbe", "Each probe object in ReferenceProbes has at most 1 fluorophore tag:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe with multiple fluorophores" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSingleReferenceFluorophorePerProbe,
        Error::DigitalPCRReferenceProbeWavelengthsLengthMismatch,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRReferenceProbeWavelengthsLengthMismatch", "Reference probe objects cannot have multiple fluorescence excitation and emission wavelengths:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe with multiple fluorophores" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSingleReferenceFluorophorePerProbe,
        Error::DigitalPCRReferenceProbeWavelengthsLengthMismatch,
        Error::DigitalPCRProbeConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRSingleReferenceFluorophorePerProbe", "Each probe object in Reference Probes has at least 1 fluorophore tag:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe without fluorescence" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSingleReferenceFluorophorePerProbe,
        Error::DigitalPCRReferenceProbeWavelengthsNull,
        Error::InvalidOption
      }
    ],
    Example[{Messages, "DigitalPCRReferenceProbeWavelengthsNull", "Fluorescence excitation and emission should not be Null for reference probe objects:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe without fluorescence" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRSingleReferenceFluorophorePerProbe,
        Error::DigitalPCRReferenceProbeWavelengthsNull,
        Error::DigitalPCRReferenceProbeWavelengthsIncompatible,
        Error::DigitalPCRProbeConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceProbeWavelengthsIncompatible", "Probe fluorescence wavelengths for ReferenceProbes are compatible with instrument channels:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe with incompatible fluorophore" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceProbeWavelengthsIncompatible,
        Error::InvalidOption
      }
    ],

    (* Stock Concentration *)
    Example[{Messages, "DigitalPCRProbeStockConcentrationTooLow", "Concentration of probe oligomer must be at least 4x higher than specified final concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe with low concentration" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRProbeStockConcentrationTooLow,
        Error::DigitalPCRTotalVolume,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerStockConcentrationTooLow", "Concentration of forward primer oligomer must be at least 4x higher than specified final concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer forward with low concentration" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRForwardPrimerStockConcentrationTooLow,
        Error::DigitalPCRTotalVolume,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerStockConcentrationTooLow", "Concentration of reverse primer oligomer must be at least 4x higher than specified final concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse with low concentration" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerStockConcentrationTooLow,
        Error::DigitalPCRTotalVolume,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceProbeStockConcentrationTooLow", "Concentration of reference probe oligomer must be at least 4x higher than specified final concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe with low concentration" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceProbeStockConcentrationTooLow,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceForwardPrimerStockConcentrationTooLow", "Concentration of reference forward primer oligomer must be at least 4x higher than specified final concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer forward with low concentration" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceForwardPrimerStockConcentrationTooLow,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerStockConcentrationTooLow", "Concentration of reference reverse primer oligomer must be at least 4x higher than specified final concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse with low concentration" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceReversePrimerStockConcentrationTooLow,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRProbeStockConcentration", "Probe oligomer concentration must be in units of Molar Concentration or Mass Concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe sample with mass percent" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRProbeStockConcentration,
        Error::DigitalPCRProbeConcentrationVolumeMismatch,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRProbeStockConcentration", "When probe oligomer concentration is in units of Mass Concentration, MolecularWeight is informed in the respective Model[Molecule,Oligomer] object:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration, no MW" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRProbeStockConcentration,
        Error::DigitalPCRProbeConcentrationVolumeMismatch,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceProbeStockConcentration", "Reference probe oligomer concentration must be in units of Molar Concentration or Mass Concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe sample with mass percent" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceProbeStockConcentration,
        Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceProbeStockConcentration", "Reference probe oligomer concentration is in units of Mass Concentration, MolecularWeight is informed in the respective Model[Molecule,Oligomer] object:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration, no MW" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceProbeStockConcentration,
        Error::DigitalPCRReferenceProbeConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerStockConcentration", "Forward primer oligomer concentration must be in units of Molar Concentration or Mass Concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass percent" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRForwardPrimerStockConcentration,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerStockConcentration", "When forward primer oligomer concentration is in units of Mass Concentration, MolecularWeight is informed in the respective Model[Molecule,Oligomer] object:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration, no MW" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRForwardPrimerStockConcentration,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerStockConcentration", "Primer input object must have at least one oligomer in its composition:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Model[Sample, "Milli-Q water"], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRForwardPrimerStockConcentration,
        Error::DigitalPCRForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerStockConcentration", "Reverse primer oligomer concentration must be in units of Molar Concentration or Mass Concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass percent" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerStockConcentration,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerStockConcentration", "When reverse primer oligomer concentration is in units of Mass Concentration, MolecularWeight is informed in the respective Model[Molecule,Oligomer] object:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration, no MW" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerStockConcentration,
        Error::DigitalPCRReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceForwardPrimerStockConcentration", "Reference forward primer oligomer concentration must be in units of Molar Concentration or Mass Concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass percent" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceForwardPrimerStockConcentration,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceForwardPrimerStockConcentration", "When reference forward primer oligomer concentration is in units of Mass Concentration, MolecularWeight is informed in the respective Model[Molecule,Oligomer] object:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration, no MW" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceForwardPrimerStockConcentration,
        Error::DigitalPCRReferenceForwardPrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerStockConcentration", "Reference reverse primer oligomer concentration must be in units of Molar Concentration or Mass Concentration:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass percent" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceReversePrimerStockConcentration,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerStockConcentration", "When reference reverse primer oligomer concentration is in units of Mass Concentration, MolecularWeight is informed in the respective Model[Molecule,Oligomer] object:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration, no MW" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceReversePrimerStockConcentration,
        Error::DigitalPCRReferenceReversePrimerConcentrationVolumeMismatch,
        Error::InvalidOption
      }
    ],

    (* Storage Condition *)
    Example[{Messages, "DigitalPCRProbeStorageConditionMismatch", "ProbeStorageCondition cannot have conflicts with probe input:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ProbeStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRProbeStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerStorageConditionMismatch", "ForwardPrimerStorageCondition cannot have conflicts with forward primer input:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ForwardPrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRForwardPrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerStorageConditionMismatch", "When using any TargetAssay, ForwardPrimerCondition cannot have conflicts with ProbeStorageCondition:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        PremixedPrimerProbe -> {{TargetAssay}},
        ForwardPrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRForwardPrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerStorageConditionMismatch", "ReversePrimerStorageCondition cannot have conflicts with reverse primer input:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ReversePrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerStorageConditionMismatch", "When using any TargetAssay, ReversePrimerCondition cannot have conflicts with ProbeStorageCondition:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        PremixedPrimerProbe -> {{TargetAssay}},
        ReversePrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerStorageConditionMismatch", "When using any PrimerSet, ReversePrimerCondition cannot have conflicts with ForwardPrimerStorageCondition:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PremixedPrimerProbe -> {{PrimerSet}},
        ReversePrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceProbeStorageConditionMismatch", "ReferenceProbeStorageCondition cannot have conflicts with ReferenceProbes:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ReferenceProbeStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceProbeStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceForwardPrimerStorageConditionMismatch", "ReferenceForwardPrimerStorageCondition cannot have conflicts with the forward primer input in ReferencePrimerPairs:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ReferenceForwardPrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceForwardPrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceForwardPrimerStorageConditionMismatch", "When using any TargetAssay, ReferenceForwardPrimerCondition cannot have conflicts with ReferenceProbeStorageCondition:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        ReferencePremixedPrimerProbe -> {{TargetAssay}},
        ReferenceForwardPrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceForwardPrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerStorageConditionMismatch", "ReferenceReversePrimerStorageCondition cannot have conflicts with the reverse primer input in ReferencePrimerPair:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ReversePrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReversePrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerStorageConditionMismatch", "When using any TargetAssay, ReferenceReversePrimerCondition cannot have conflicts with ReferenceProbeStorageCondition:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        ReferencePremixedPrimerProbe -> {{TargetAssay}},
        ReferenceReversePrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceReversePrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerStorageConditionMismatch", "When using any PrimerSet, ReferenceReversePrimerCondition cannot have conflicts with ReferenceForwardPrimerStorageCondition:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePremixedPrimerProbe -> {{PrimerSet}},
        ReferenceReversePrimerStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRReferenceReversePrimerStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRMasterMixStorageConditionMismatch", "When using PreparedPlate, MasterMixStorageCondition cannot have a specified value:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        MasterMixStorageCondition -> {DeepFreezer}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRMasterMixStorageConditionMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRDropletCartridgeLengthMismatch", "When specifying DropletCartridge, the length of objects must match the number of plates required:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        DropletCartridge -> {
          Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID],
          Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 2" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRDropletCartridgeLengthMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRDropletCartridgeRepeatedObjects", "When specifying DropletCartridge, all the objects must be unique:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test sample 2" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}, {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ActiveWell -> {{1, "A1"}, {2, "A1"}},
        DropletCartridge -> {
          Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID],
          Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRDropletCartridgeRepeatedObjects,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRDropletCartridgeObjectMismatch", "When using PreparedPlate and specifying DropletCartridge, the container object(s) must match the actual input sample container(s):"},
      ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 17 with primers and probes in cartridge" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 18 with primers and probes in cartridge" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 19 with primers and probes in cartridge" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 20 with primers and probes in cartridge" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 21 with primers and probes in cartridge" <> $SessionUUID]
        },
        PreparedPlate -> True,
        DropletCartridge -> {Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID]}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRDropletCartridgeObjectMismatch,
        Error::InvalidOption
      }
    ],

    Example[{Messages, "DigitalPCRMultiplexedTargetQuantity", "When multiplexing more than 2 probes in a single channel droplet population may be difficult to isolate:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRMultiplexedTargetQuantity
      }
    ],

    Example[{Messages, "DigitalPCRProbeStockConcentrationAccuracy", "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRProbeStockConcentrationAccuracy
      }
    ],

    Example[{Messages, "DigitalPCRForwardPrimerStockConcentrationAccuracy", "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRForwardPrimerStockConcentrationAccuracy
      }
    ],

    Example[{Messages, "DigitalPCRReversePrimerStockConcentrationAccuracy", "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRReversePrimerStockConcentrationAccuracy
      }
    ],

    Example[{Messages, "DigitalPCRReferenceForwardPrimerStockConcentrationAccuracy", "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRReferenceForwardPrimerStockConcentrationAccuracy
      }
    ],

    Example[{Messages, "DigitalPCRReferenceReversePrimerStockConcentrationAccuracy", "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration" <> $SessionUUID]}}
        },
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRReferenceReversePrimerStockConcentrationAccuracy
      }
    ],

    Example[{Messages, "DigitalPCRReferenceProbeStockConcentrationAccuracy", "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRReferenceProbeStockConcentrationAccuracy
      }
    ],

    Example[{Messages, "DigitalPCRMasterMixConcentrationFactorNotInformed", "When MasterMix and MasterMixVolume are specified, warns if concentration factor is not found in the specified MasterMix model:"},
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        MasterMix -> {Model[Sample, "Bio-Rad ddPCR Supermix for Probes without Concentration" <> $SessionUUID]},
        MasterMixVolume -> {20 Microliter}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRMasterMixConcentrationFactorNotInformed
      }
    ],

    Example[{Messages, "DigitalPCRMasterMixQuantityMismatch", "When MasterMixVolume is specified, it checks for conflicts with the MasterMixConcentrationFactor for the MasterMix model:"},
      ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}
        },
        MasterMix -> {
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"]
        },
        MasterMixVolume -> {9 Microliter, 12 Microliter},
        ReactionVolume -> {40 Microliter, 40 Microliter}
      ],
      ObjectP[Object[Protocol, DigitalPCR]],
      Messages :> {
        Warning::DigitalPCRMasterMixQuantityMismatch
      }
    ],


    Example[{Messages, "DigitalPCRMultiplexingNotAvailable", "When multiplex features are not available, amplitude multiplexing cannot be used:"},
      ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {{
          {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{
          Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]
        }}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRMultiplexingNotAvailable,
        Error::InvalidInput
      },
      Stubs :> {$ddPCRNoMultiplex = True}
    ],


    Example[{Messages, "DigitalPCRMultiplexingNotAvailable", "When multiplex features are not available, multiplexing in differnt channels for a single sample cannot be used:"},
      ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {{
          {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{
          Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]
        }}
      ],
      $Failed,
      Messages :> {
        Error::DigitalPCRMultiplexingNotAvailable,
        Error::InvalidInput
      },
      Stubs :> {$ddPCRNoMultiplex = True}
    ],


    (*-- Options --*)
    Example[{Options, SamplesInStorageCondition, "SamplesInStorageCondition can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SamplesInStorageCondition -> Refrigerator,
        Output -> Options
      ];
      Lookup[options, SamplesInStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],

    (* Prepared Plate *)
    Example[{Options, PreparedPlate, "Specify PreparedPlate when samples are prepared and loaded in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"]:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True,
        Output -> Options
      ];
      Lookup[options, PreparedPlate],
      True,
      Variables :> {options}
    ],

    Example[{Options, PreparedPlate, "Automatically resolves to True when samples are loaded in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"] and no primers or probes are specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        Output -> Options
      ];
      Lookup[options, PreparedPlate],
      True,
      Variables :> {options}
    ],

    Example[{Options, PreparedPlate, "Automatically resolves to True when a container with prepared samples is used as an input:"},
      options = ExperimentDigitalPCR[
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, PreparedPlate],
      True,
      Variables :> {options}
    ],

    Example[{Options, PreparedPlate, "Automatically resolves to True when an input container has prepared samples in some wells and passive well buffer in the rest of the wells in any block that will be processed for droplet generation:"},
      options = ExperimentDigitalPCR[
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, PreparedPlate],
      True,
      Variables :> {options}
    ],

    Example[{Options, PreparedPlate, "Automatically resolves to False when prepared samples are not loaded in Model[Container,Plate,DropletCartridge,\"Bio-Rad GCR96 Digital PCR Cartridge\"]:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        Output -> Options
      ];
      Lookup[options, PreparedPlate],
      False,
      Variables :> {options}
    ],

    Example[{Options, DropletCartridge, "Specify droplet cartridge object(s):"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        DropletCartridge -> {Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID]},
        Output -> Options
      ];
      Lookup[options, DropletCartridge],
      {ObjectP[Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID]]},
      Variables :> {options}
    ],

    (* Amplitude Multiplexing *)
    Example[{Options, AmplitudeMultiplexing, "Automatically resolves number of targets in each fluorescence emission channel:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, AmplitudeMultiplexing],
      {{517. Nanometer, 2}, {556. Nanometer, 0}, {665. Nanometer, 0}, {694. Nanometer, 0}},
      Variables :> {options}
    ],

    Example[{Options, AmplitudeMultiplexing, "When multiplexing more than 2 probes in a single channel droplet population may be difficult to isolate:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, AmplitudeMultiplexing],
      {{517. Nanometer, 3}, {556. Nanometer, 0}, {665. Nanometer, 0}, {694. Nanometer, 0}},
      Messages :> {
        Warning::DigitalPCRMultiplexedTargetQuantity
      },
      Variables :> {options}
    ],

    Example[{Options, AmplitudeMultiplexing, "AmplitudeMultiplexing can be used to specify number of genetic targets to be detected in each fluorescence channel:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        AmplitudeMultiplexing -> {{{517. Nanometer, 2}}},
        Output -> Options
      ];
      Lookup[options, AmplitudeMultiplexing],
      {{{517. Nanometer, 2}, {556. Nanometer, 0}, {665. Nanometer, 0}, {694. Nanometer, 0}}},
      Variables :> {options}
    ],

    Example[{Options, Instrument, "Instrument can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Instrument -> Model[Instrument, Thermocycler, DigitalPCR, "Bio-Rad QX One"],
        Output -> Options
      ];
      Lookup[options, Instrument],
      ObjectP[Model[Instrument, Thermocycler, DigitalPCR, "Bio-Rad QX One"]],
      Variables :> {options}
    ],

    Example[{Options, DropletGeneratorOil, "DropletGeneratorOil can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        DropletGeneratorOil -> Model[Sample, "QX One Droplet Generation Oil"],
        Output -> Options
      ];
      Lookup[options, DropletGeneratorOil],
      ObjectP[Model[Sample, "QX One Droplet Generation Oil"]],
      Variables :> {options}
    ],

    Example[{Options, DropletReaderOil, "DropletReaderOil can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        DropletReaderOil -> Model[Sample, "QX One Droplet Reader Oil"],
        Output -> Options
      ];
      Lookup[options, DropletReaderOil],
      ObjectP[Model[Sample, "QX One Droplet Reader Oil"]],
      Variables :> {options}
    ],

    Example[{Options, NumberOfReplicates, "NumberOfReplicates can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        NumberOfReplicates -> 2,
        Output -> Options
      ];
      Lookup[options, NumberOfReplicates],
      2,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, SampleDilution, "SampleDilution can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        Output -> Options
      ];
      Lookup[options, SampleDilution],
      True,
      Variables :> {options}
    ],

    Example[{Options, SerialDilutionCurve, "SerialDilutionCurve can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        SerialDilutionCurve -> {10 * Microliter, {0.2, 3}},
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      {10 * Microliter, {0.2, 3}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, SerialDilutionCurve, "SerialDilutionCurve resolves automatically when SampleDilution is True:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        Output -> Options
      ];
      Lookup[options, SerialDilutionCurve],
      {50 * Microliter, {0.1, 4}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, DilutionMixVolume, "DilutionMixVolume can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        DilutionMixVolume -> 10 * Microliter,
        Output -> Options
      ];
      Lookup[options, DilutionMixVolume],
      10 * Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DilutionMixVolume, "DilutionMixVolume resolves automatically when SampleDilution is True:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        Output -> Options
      ];
      Lookup[options, DilutionMixVolume],
      10 * Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, DilutionNumberOfMixesDilutionNumberOfMixes, "DilutionNumberOfMixes can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        DilutionNumberOfMixes -> 5,
        Output -> Options
      ];
      Lookup[options, DilutionNumberOfMixes],
      5,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DilutionNumberOfMixes, "DilutionNumberOfMixes resolves automatically when SampleDilution is True:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        Output -> Options
      ];
      Lookup[options, DilutionNumberOfMixes],
      10,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, DilutionMixRate, "DilutionMixRate can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        DilutionMixRate -> 5 * (Microliter / Second),
        Output -> Options
      ];
      Lookup[options, DilutionMixRate],
      5 * (Microliter / Second),
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, DilutionMixRate, "DilutionMixRate resolves automatically when SampleDilution is True:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        Output -> Options
      ];
      Lookup[options, DilutionMixRate],
      30 * (Microliter / Second),
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, SampleVolume, "SampleVolume can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleVolume -> 2.2 Microliter,
        Output -> Options
      ];
      Lookup[options, SampleVolume],
      2.2 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, SampleVolume, "SampleVolume, if specified, is rounded to 0.1 microliter:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleVolume -> 2.22 Microliter,
        Output -> Options
      ];
      Lookup[options, SampleVolume],
      2.2 Microliter,
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],

    Example[
      {Options, PremixedPrimerProbe, "Automatically resolves to TargetAssay if primerPair and probe inputs have the same object or PrimerSet if only primerPairs have the same object or None if all three objects are different:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{
          {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        }},
        {{
          Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, PremixedPrimerProbe],
      {None, PrimerSet, TargetAssay},
      Variables :> {options}
    ],

    Example[
      {Options, PremixedPrimerProbe, "Use of TargetAssay or PrimerSet can be specified with PremixedPrimerProbe:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{
          {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        }},
        {{
          Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        PremixedPrimerProbe -> {{None, PrimerSet, TargetAssay}},
        Output -> Options
      ];
      Lookup[options, PremixedPrimerProbe],
      {{None, PrimerSet, TargetAssay}},
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerConcentration, "Automatically resolves to 900 nanomolar AmplitudeMultiplexing is Null or counts in a channel is at most 1; otherwise a series of primer concentrations is calculated for multiplexed targets in each channel:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]},
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]
          }
        },
        Output -> Options
      ];
      Lookup[options, ForwardPrimerConcentration],
      {1350 Nanomolar, 675 Nanomolar},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerConcentration, "Specify concentration of forward primer inputs:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ForwardPrimerConcentration -> {{950 Nanomolar}, {850 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ForwardPrimerConcentration],
      {{950 Nanomolar}, {850 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerConcentration, "When using TargetAssay, concentration of forward primer inputs must be specified as 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]
          }
        },
        ForwardPrimerConcentration -> {{950 Nanomolar, 0 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ForwardPrimerConcentration],
      {{950 Nanomolar, 0 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerConcentration, "When using TargetAssay, concentration of forward primer automatically resolves to 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]
          }
        },
        Output -> Options
      ];
      Lookup[options, ForwardPrimerConcentration],
      {1350 Nanomolar, 0 Nanomolar},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerConcentration, "ForwardPrimerConcentration, if specified, is rounded to 1 nanomolar:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ForwardPrimerConcentration -> {{950.6 Nanomolar}, {850 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ForwardPrimerConcentration],
      {{951 Nanomolar}, {850 Nanomolar}},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerVolume, "Automatically resolves volume using the formula,  ForwardPrimerVolume=(ForwardPrimerConcentration*ReactionVolume)/(stock concentration):"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]
          }
        },
        Output -> Options
      ];
      Lookup[options, ForwardPrimerVolume],
      {3.6 Microliter},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerVolume, "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ForwardPrimerVolume],
      {5.5 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::DigitalPCRForwardPrimerStockConcentrationAccuracy
      },
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerVolume, "Specify volume of forward primer inputs:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ForwardPrimerVolume -> {{1 Microliter}, {1.5 Microliter}},
        Output -> Options
      ];
      Lookup[options, ForwardPrimerVolume],
      {{1 Microliter}, {1.5 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerVolume, "When using TargetAssay, volume of forward primer inputs must be specified as 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]
          }
        },
        ForwardPrimerVolume -> {{1 Microliter, 0 Microliter}},
        Output -> Options
      ];
      Lookup[options, ForwardPrimerVolume],
      {{1 Microliter, 0 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ForwardPrimerVolume, "ForwardPrimerVolume, if specified, is rounded to 0.1 microliter:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ForwardPrimerVolume -> {{1 Microliter}, {1.56 Microliter}},
        Output -> Options
      ];
      Lookup[options, ForwardPrimerVolume],
      {{1 Microliter}, {1.6 Microliter}},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],

    Example[
      {Options, ReversePrimerConcentration, "Automatically resolves to 900 nanomolar AmplitudeMultiplexing is Null or counts in a channel is at most 1; otherwise a series of concentrations is calculated for primers in each channel:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]},
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]
          }
        },
        Output -> Options
      ];
      Lookup[options, ReversePrimerConcentration],
      {1350 Nanomolar, 675 Nanomolar},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReversePrimerConcentration, "Specify concentration of reverse primer inputs:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReversePrimerConcentration -> {{950 Nanomolar}, {850 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReversePrimerConcentration],
      {{950 Nanomolar}, {850 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReversePrimerConcentration, "When using TargetAssay, concentration of reverse primer inputs must be specified as 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]
          }
        },
        ReversePrimerConcentration -> {{950 Nanomolar, 0 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReversePrimerConcentration],
      {{950 Nanomolar, 0 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReversePrimerConcentration, "When using PrimerSet, concentration of reverse primer inputs must be specified as 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]
          }
        },
        ReversePrimerConcentration -> {{950 Nanomolar, 0 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReversePrimerConcentration],
      {{950 Nanomolar, 0 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReversePrimerVolume, "Specify volume of reverse primer inputs:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReversePrimerVolume -> {{1 Microliter}, {1.5 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReversePrimerVolume],
      {{1 Microliter}, {1.5 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReversePrimerVolume, "When using TargetAssay, volume of reverse primer inputs must be specified as 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]
          }
        },
        ReversePrimerVolume -> {{1 Microliter, 0 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReversePrimerVolume],
      {{1 Microliter, 0 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReversePrimerVolume, "When using PrimerSet, volume of reverse primer inputs must be specified as 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]
          }
        },
        ReversePrimerVolume -> {{1 Microliter, 0 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReversePrimerVolume],
      {{1 Microliter, 0 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReversePrimerVolume, "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReversePrimerVolume],
      {5.5 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::DigitalPCRReversePrimerStockConcentrationAccuracy
      },
      Variables :> {options}
    ],

    Example[
      {Options, ProbeConcentration, "Automatically resolves to 250 nanomolar AmplitudeMultiplexing is Null or counts in a channel is at most 1; otherwise a series of concentrations is calculated for primers in each channel:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]},
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]
          }
        },
        Output -> Options
      ];
      Lookup[options, ProbeConcentration],
      {375 Nanomolar, 187.5 Nanomolar},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ProbeConcentration, "Specify concentration of probe inputs:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ProbeConcentration -> {{300 Nanomolar}, {150 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ProbeConcentration],
      {{300 Nanomolar}, {150 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ProbeVolume, "Specify volume of probe inputs:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ProbeVolume -> {{1 Microliter}},
        Output -> Options
      ];
      Lookup[options, ProbeVolume],
      {{1 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ProbeVolume, "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ProbeVolume],
      {2 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::DigitalPCRProbeStockConcentrationAccuracy
      },
      Variables :> {options}
    ],

    Example[
      {Options, ReferencePremixedPrimerProbe, "Automatically resolves to TargetAssay if ReferencePrimerPairs and ReferenceProbes inputs have the same object or PrimerSet if only ReferencePrimerPairs have the same object or None if all three objects are different:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{
          {Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        }},
        ReferenceProbes -> {{
          Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]
        }},
        Output -> Options
      ];
      Lookup[options, ReferencePremixedPrimerProbe],
      {PrimerSet, TargetAssay},
      Variables :> {options}
    ],

    Example[
      {Options, ReferencePremixedPrimerProbe, "Use of TargetAssay or PrimerSet can be specified with ReferencePremixedPrimerProbe:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{
          {Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        }},
        ReferenceProbes -> {{
          Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]
        }},
        ReferencePremixedPrimerProbe -> {{PrimerSet, TargetAssay}},
        Output -> Options
      ];
      Lookup[options, ReferencePremixedPrimerProbe],
      {{PrimerSet, TargetAssay}},
      Variables :> {options}
    ],

    Example[
      {Options, ReferencePrimerPairs, "Specify primer pairs to detect reference targets in sample:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        Output -> Options
      ];
      Lookup[options, ReferencePrimerPairs],
      {{{ObjectP[Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID]], ObjectP[Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]]}}},
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerConcentration, "Specify concentration of forward primer for reference targets:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferenceForwardPrimerConcentration -> {{950 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerConcentration],
      {{950 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerConcentration, "When using TargetAssay, concentration of forward primer for reference targets must be specified as 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        ReferenceForwardPrimerConcentration -> {{0 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerConcentration],
      {{0 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerConcentration, "When using TargetAssay, concentration of forward primer for reference targets automatically resolves to 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerConcentration],
      {0 Nanomolar},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerConcentration, "ReferenceForwardPrimerConcentration, if specified, is rounded to 1 nanomolar:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferenceForwardPrimerConcentration -> {{755.6 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerConcentration],
      {{756 Nanomolar}},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerVolume, "Specify volume of forward primer for reference targets:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferenceForwardPrimerVolume -> {{1 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerVolume],
      {{1 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerVolume, "When using TargetAssay, volume of forward primer for reference targets must be specified as 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        ReferenceForwardPrimerVolume -> {{0 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerVolume],
      {{0 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerVolume, "When using TargetAssay, volume of forward primer for reference targets automatically resolves to 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerVolume],
      {0 Microliter},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerVolume, "ReferenceForwardPrimerVolume, if specified, is rounded to 0.1 microliter:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferenceForwardPrimerVolume -> {{1.23 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerVolume],
      {{1.2 Microliter}},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceForwardPrimerVolume, "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerVolume],
      {5.5 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::DigitalPCRReferenceForwardPrimerStockConcentrationAccuracy
      },
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerConcentration, "Specify concentration of reverse primer for reference targets:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferenceReversePrimerConcentration -> {{950 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerConcentration],
      {{950 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerConcentration, "When using TargetAssay, concentration of reverse primer for reference targets must be specified as 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        ReferenceReversePrimerConcentration -> {{0 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerConcentration],
      {{0 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerConcentration, "When using TargetAssay, concentration of reverse primer for reference targets automatically resolves to 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerConcentration],
      {0 Nanomolar},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerConcentration, "When using PrimerSet, concentration of reverse primer for reference targets must be specified as 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceReversePrimerConcentration -> {{0 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerConcentration],
      {{0 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerConcentration, "When using PrimerSet, concentration of reverse primer for reference targets automatically resolves to 0 nanomolar at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerConcentration],
      {0 Nanomolar},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerVolume, "Specify volume of reverse primer for reference targets:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferenceReversePrimerVolume -> {{1 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerVolume],
      {{1 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerVolume, "When using TargetAssay, volume of reverse primer for reference targets must be specified as 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        ReferenceReversePrimerVolume -> {{0 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerVolume],
      {{0 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerVolume, "When using TargetAssay, volume of reverse primer for reference targets automatically resolves to 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerVolume],
      {0 Microliter},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerVolume, "When using PrimerSet, volume of reverse primer for reference targets must be specified as 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferenceReversePrimerVolume -> {{0 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerVolume],
      {{0 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerVolume, "When using PrimerSet, volume of reverse primer for reference targets automatically resolves to 0 microliter at matching indices:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerVolume],
      {0 Microliter},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceReversePrimerVolume, "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration" <> $SessionUUID]}}
        },
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerVolume],
      {5.5 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::DigitalPCRReferenceReversePrimerStockConcentrationAccuracy
      },
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceProbes, "Specify probes to detect reference targets in sample:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        Output -> Options
      ];
      Lookup[options, ReferenceProbes],
      {{ObjectP[Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]]}},
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceProbeConcentration, "Specify concentration of probes for reference targets:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferenceProbeConcentration -> {{150 Nanomolar}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeConcentration],
      {{150 Nanomolar}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceProbeVolume, "Specify volume of probe for reference targets:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReferenceProbeVolume -> {{1 Microliter}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeVolume],
      {{1 Microliter}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, ReferenceProbeVolume, "When resolved automatically, warns if molar concentration is calculated using mass concentration and MolecularWeight of identity oligomer:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}
        },
        ReferencePrimerPairs -> {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeVolume],
      {1.5 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::DigitalPCRReferenceProbeStockConcentrationAccuracy
      },
      Variables :> {options}
    ],

    Example[
      {Options, MasterMix, "Specify the MasterMix that will be used for each sample:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}
        },
        MasterMix -> {
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"]
        },
        Output -> Options
      ];
      Lookup[options, MasterMix],
      {ObjectP[Model[Sample, "Bio-Rad ddPCR Supermix for Probes"]], ObjectP[Model[Sample, "Bio-Rad ddPCR Supermix for Probes"]]},
      Variables :> {options}
    ],

    Example[
      {Options, MasterMix, "Automatically resolves to Model[Sample,\"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer\"] if ReverseTranscription is True:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}
        },
        ReverseTranscription -> {True, True},
        Output -> Options
      ];
      Lookup[options, MasterMix],
      ObjectP[Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"]],
      Variables :> {options}
    ],

    Example[
      {Options, MasterMix, "Automatically resolves to Model[Sample,\"Bio-Rad ddPCR Multiplex Supermix\"] if AmplitudeMultiplexing is used:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {
            {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}
          }
        },
        {
          {
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
            Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]
          }
        },
        Output -> Options
      ];
      Lookup[options, MasterMix],
      ObjectP[Model[Sample, "Bio-Rad ddPCR Multiplex Supermix"]],
      Variables :> {options}
    ],

    Example[
      {Options, MasterMixConcentrationFactor, "Concentration factor automatically resolves to the ConcentratedBufferDilutionFactor field in MasterMix model:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}
        },
        MasterMix -> {
          Model[Sample, "Bio-Rad ddPCR Multiplex Supermix"],
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"]
        },
        Output -> Options
      ];
      Lookup[options, MasterMixConcentrationFactor],
      {4, 2},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, MasterMixVolume, "Automatically resolves from the MasterMixConcentrationFactor for a MasterMix using the formula MasterMixVolume=ReactionVolume/MasterMixConcentrationFactor:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}
        },
        MasterMix -> {
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"]
        },
        Output -> Options
      ];
      Lookup[options, MasterMixVolume],
      20 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, MasterMixConcentrationFactor, "When MasterMix and MasterMixVolume are specified, warns if concentration factor is not found in the specified MasterMix model:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        MasterMix -> {Model[Sample, "Bio-Rad ddPCR Supermix for Probes without Concentration" <> $SessionUUID]},
        MasterMixVolume -> {20 Microliter},
        Output -> Options
      ];
      Lookup[options, MasterMixConcentrationFactor],
      2,
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::DigitalPCRMasterMixConcentrationFactorNotInformed
      },
      Variables :> {options}
    ],

    Example[
      {Options, MasterMixVolume, "When MasterMixVolume is specified, it checks for conflicts with the MasterMixConcentrationFactor for the MasterMix model:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}
        },
        MasterMix -> {
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
          Model[Sample, "Bio-Rad ddPCR Supermix for Probes"]
        },
        MasterMixVolume -> {9 Microliter, 12 Microliter},
        ReactionVolume -> {40 Microliter, 40 Microliter},
        Output -> Options
      ];
      Lookup[options, MasterMixVolume],
      {9 Microliter, 12 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::DigitalPCRMasterMixQuantityMismatch
      },
      Variables :> {options}
    ],

    Example[{Options, MasterMixStorageCondition, "MasterMixStorageCondition can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        MasterMixStorageCondition -> {DeepFreezer},
        Output -> Options
      ];
      Lookup[options, MasterMixStorageCondition],
      {DeepFreezer},
      Variables :> {options}
    ],

    Example[{Options, Diluent, "Diluent can be specified:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Diluent -> Model[Sample, "Milli-Q water"],
        Output -> Options
      ];
      Lookup[options, Diluent],
      ObjectP[Model[Sample, "Milli-Q water"]],
      Variables :> {options}
    ],

    Example[
      {Options, DiluentVolume, "Automatically resolved using the formula, DiluentVolume = ReactionVolume-(SampleVolume+ForwardPrimerVolume+ReversePrimerVolume+ProbeVolume+ReferenceForwardPrimerVolume+ReferenceReversePrimerVolume+ReferenceProbeVolume+MasterMixVolume):"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}
        },
        Output -> Options
      ];
      Lookup[options, DiluentVolume],
      7.8 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[
      {Options, DiluentVolume, "DiluentVolume, if specified, is rounded to 0.1 microliter:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}
        },
        DiluentVolume -> {7.81 Microliter, 7.81 Microliter},
        Output -> Options
      ];
      Lookup[options, DiluentVolume],
      {7.8 Microliter, 7.8 Microliter},
      EquivalenceFunction -> Equal,
      Messages :> {
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],

    Example[{Options, ReactionVolume, "Specify the volume of reaction including sample, primers, probes, master mix and diluent:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReactionVolume -> 40 Microliter,
        Output -> Options
      ];
      Lookup[options, ReactionVolume],
      40 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ActiveWell, "ActiveWell is automatically resolved to well indices for samples, while also grouping samples based on Thermocycling conditions; Samples with ReverseTranscription options are prioritized:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ReverseTranscription -> {False, True},
        Output -> Options
      ];
      Lookup[options, ActiveWell],
      {{2, "A1"}, {1, "A1"}},
      Variables :> {options}
    ],

    Example[{Options, ActiveWell, "ActiveWell can be specified for samples in a single plate:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ActiveWell -> {"B2", "A1"},
        Output -> Options
      ];
      Lookup[options, ActiveWell],
      {"B2", "A1"},
      Variables :> {options}
    ],

    Example[{Options, ActiveWell, "ActiveWell can be specified for samples in multiple plates using plate index:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ActiveWell -> {{1, "B2"}, {2, "A1"}},
        Output -> Options
      ];
      Lookup[options, ActiveWell],
      {{1, "B2"}, {2, "A1"}},
      Variables :> {options}
    ],

    Example[{Options, ActiveWell, "Automatically resolves ActiveWell when PreparedPlate is True:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True,
        Output -> Options
      ];
      Lookup[options, ActiveWell],
      {"A1"},
      Variables :> {options}
    ],

    Example[{Options, PassiveWells, "PassiveWells can be automatically determined based on ActiveWell assigment:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ActiveWell -> {"A1", "A2"},
        Output -> Options
      ];
      Lookup[options, PassiveWells],
      {"B1", "C1", "D1", "E1", "F1", "G1", "H1", "B2", "C2", "D2", "E2", "F2", "G2", "H2"},
      Variables :> {options}
    ],

    Example[{Options, PassiveWells, "PassiveWells can be specified, but must be identified correctly based on ActiveWell assigment:"},
      options = ExperimentDigitalPCR[
        {
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]
        },
        {
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}
        },
        {
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}
        },
        ActiveWell -> {"A1", "A2"},
        PassiveWells -> {"B1", "C1", "D1", "E1", "F1", "G1", "H1", "B2", "C2", "D2", "E2", "F2", "G2", "H2"},
        Output -> Options
      ];
      Lookup[options, PassiveWells],
      {"B1", "C1", "D1", "E1", "F1", "G1", "H1", "B2", "C2", "D2", "E2", "F2", "G2", "H2"},
      Variables :> {options}
    ],

    Example[{Options, PassiveWells, "Automatically resolves PassiveWells when PreparedPlate is True:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True,
        Output -> Options
      ];
      Lookup[options, PassiveWells],
      {"B1", "C1", "D1", "E1", "F1", "G1", "H1", "A2", "B2", "C2", "D2", "E2", "F2", "G2", "H2"},
      Variables :> {options}
    ],

    Example[{Options, PassiveWellBuffer, "Specify a control solution with viscosity matched to master mix:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PassiveWellBuffer -> Model[Sample, "Bio-Rad ddPCR Buffer Control for Probes"],
        Output -> Options
      ];
      Lookup[options, PassiveWellBuffer],
      ObjectP[Model[Sample, "Bio-Rad ddPCR Buffer Control for Probes"]],
      Variables :> {options}
    ],

    Example[{Options, PlateSealInstrument, "Specify the instrument used to apply heat-seal digital PCR plates with foil prior to assay run:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PlateSealInstrument -> Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"],
        Output -> Options
      ];
      Lookup[options, PlateSealInstrument],
      ObjectP[Model[Instrument, PlateSealer, "Bio-Rad PX1 Plate Sealer"]],
      Variables :> {options}
    ],

    Example[{Options, PlateSealFoil, "Specify the pierceable membrane used to seal digital PCR plate:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PlateSealFoil -> Model[Item, PlateSeal, "GCR96 PCR Plate Seal, Pierceable Heat-Sealed Aluminum"],
        Output -> Options
      ];
      Lookup[options, PlateSealFoil],
      ObjectP[Model[Item, PlateSeal, "GCR96 PCR Plate Seal, Pierceable Heat-Sealed Aluminum"]],
      Variables :> {options}
    ],

    Example[{Options, PlateSealTemperature, "Specify the temperature that will be used to heat the foil for sealing a plate:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PlateSealTemperature -> 180 Celsius,
        Output -> Options
      ];
      Lookup[options, PlateSealTemperature],
      180 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PlateSealTime, "Specify the duration of time used for applying PlateSealTemperature to seal the digital PCR plate:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PlateSealTime -> 0.5 Second,
        Output -> Options
      ];
      Lookup[options, PlateSealTime],
      0.5 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- ReverseTranscription -*)
    Example[{Options, ReverseTranscription, "Specify if reverse transcription should be performed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscription -> {True},
        Output -> Options
      ];
      Lookup[options, ReverseTranscription],
      {True},
      Variables :> {options}
    ],

    Example[{Options, ReverseTranscription, "Automatically set to True if any of the reverse transcription options are set:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscriptionTime -> {15 Minute},
        Output -> Options
      ];
      Lookup[options, ReverseTranscription],
      True,
      Variables :> {options}
    ],

    Example[{Options, ReverseTranscription, "Automatically set to True if MasterMix is specified as Model[Sample,\"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer\"]:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        MasterMix -> {Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"]},
        Output -> Options
      ];
      Lookup[options, ReverseTranscription],
      True,
      Variables :> {options}
    ],

    Example[{Options, ReverseTranscriptionTime, "Specify the duration for reverse transcription step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscriptionTime -> {30 Minute},
        Output -> Options
      ];
      Lookup[options, ReverseTranscriptionTime],
      {30 Minute},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReverseTranscriptionTime, "Automatically set to 15 minutes if ReverseTranscription is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscription -> {True},
        Output -> Options
      ];
      Lookup[options, ReverseTranscriptionTime],
      15 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReverseTranscriptionTemperature, "Specify the incubation temperature for reverse transcription step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscriptionTemperature -> {55 Celsius},
        Output -> Options
      ];
      Lookup[options, ReverseTranscriptionTemperature],
      {55 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReverseTranscriptionTemperature, "Automatically set to 50\[Degree]Celsius if ReverseTranscription is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscription -> {True},
        Output -> Options
      ];
      Lookup[options, ReverseTranscriptionTemperature],
      50 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReverseTranscriptionRampRate, "Specify the rate of temperature change for reverse transcription step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscriptionRampRate -> {2.0 (Celsius / Second)},
        Output -> Options
      ];
      Lookup[options, ReverseTranscriptionRampRate],
      {2.0 (Celsius / Second)},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReverseTranscriptionRampRate, "Automatically set to 1.6\[Degree]Celsius/Second if ReverseTranscription is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReverseTranscription -> {True},
        Output -> Options
      ];
      Lookup[options, ReverseTranscriptionRampRate],
      1.6 (Celsius / Second),
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- Activation -*)
    Example[{Options, Activation, "Specify if activation will be performed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Activation -> {False},
        Output -> Options
      ];
      Lookup[options, Activation],
      {False},
      Variables :> {options}
    ],

    Example[{Options, ActivationTime, "Specify the duration for activation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ActivationTime -> {10 Minute},
        Output -> Options
      ];
      Lookup[options, ActivationTime],
      {10 Minute},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ActivationTime, "Automatically set to 10 minutes if Activation is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Activation -> {True},
        Output -> Options
      ];
      Lookup[options, ActivationTime],
      10 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ActivationTemperature, "Specify the incubation temperature for activation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ActivationTemperature -> {95 Celsius},
        Output -> Options
      ];
      Lookup[options, ActivationTemperature],
      {95 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ActivationTemperature, "Automatically set to 95\[Degree]Celsius if Activation is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Activation -> {True},
        Output -> Options
      ];
      Lookup[options, ActivationTemperature],
      95 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ActivationRampRate, "Specify the rate of temperature change for activation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ActivationRampRate -> {2.0 (Celsius / Second)},
        Output -> Options
      ];
      Lookup[options, ActivationRampRate],
      {2.0 (Celsius / Second)},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ActivationRampRate, "Automatically set to 1.6\[Degree]Celsius/Second if Activation is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Activation -> {True},
        Output -> Options
      ];
      Lookup[options, ActivationRampRate],
      1.6 (Celsius / Second),
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- Denaturation -*)
    Example[{Options, DenaturationTime, "Specify the duration for denaturation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        DenaturationTime -> {30 Second},
        Output -> Options
      ];
      Lookup[options, DenaturationTime],
      {30 Second},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, DenaturationTemperature, "Specify the incubation temperature for denaturation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        DenaturationTemperature -> {95 Celsius},
        Output -> Options
      ];
      Lookup[options, DenaturationTemperature],
      {95 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, DenaturationRampRate, "Specify the rate of temperature change for denaturation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        DenaturationRampRate -> {2.0 (Celsius / Second)},
        Output -> Options
      ];
      Lookup[options, DenaturationRampRate],
      {2.0 (Celsius / Second)},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- PrimerAnnealing -*)
    Example[{Options, PrimerAnnealing, "Specify if primer annealing will be performed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealing],
      {False},
      Variables :> {options}
    ],

    Example[{Options, PrimerAnnealingTime, "Specify the duration for primer annealing step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealingTime -> {60 Second},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealingTime],
      {60 Second},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerAnnealingTime, "Automatically set to 60 seconds if PrimerAnnealing is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {True},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealingTime],
      60 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerAnnealingTemperature, "Specify the incubation temperature for primer annealing step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealingTemperature -> {60 Celsius},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealingTemperature],
      {60 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerAnnealingTemperature, "Automatically set to 60\[Degree]Celsius if PrimerAnnealing is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {True},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealingTemperature],
      60 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerAnnealingRampRate, "Specify the rate of temperature change for primer annealing step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealingRampRate -> {2.0 (Celsius / Second)},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealingRampRate],
      {2.0 (Celsius / Second)},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerAnnealingRampRate, "Automatically set to 2.0\[Degree]Celsius/Second if PrimerAnnealing is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {True},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealingRampRate],
      2.0 (Celsius / Second),
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- PrimerGradientAnnealing -*)
    Example[{Options, PrimerGradientAnnealing, "Specify if gradient annealing will be performed; PrimerAnnealing must be specified as False when PrimerGradientAnnealing is True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        Output -> Options
      ];
      Lookup[options, PrimerGradientAnnealing],
      {True},
      Variables :> {options}
    ],

    Example[{Options, PrimerAnnealingTime, "Specify the duration for gradient annealing step; PrimerAnnealing must be specified as False when PrimerGradientAnnealing is True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        PrimerAnnealingTime -> {60 Second},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealingTime],
      {60 Second},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerAnnealingTime, "Automatically set to 60 seconds if PrimerGradientAnnealing is set to True and PrimerAnnealing is set to False:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        Output -> Options
      ];
      Lookup[options, PrimerAnnealingTime],
      60 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerGradientAnnealingMinTemperature, "Specify the minimum incubation temperature for gradient annealing step; PrimerAnnealing must be specified as False when PrimerGradientAnnealing is True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        PrimerGradientAnnealingMinTemperature -> {55 Celsius},
        Output -> Options
      ];
      Lookup[options, PrimerGradientAnnealingMinTemperature],
      {55 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerGradientAnnealingMinTemperature, "Automatically set to 55\[Degree]Celsius if PrimerGradientAnnealing is set to True and PrimerAnnealing is set to False:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        Output -> Options
      ];
      Lookup[options, PrimerGradientAnnealingMinTemperature],
      55 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerGradientAnnealingMaxTemperature, "Specify the maximum incubation temperature for gradient annealing step; PrimerAnnealing must be specified as False when PrimerGradientAnnealing is True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        PrimerGradientAnnealingMaxTemperature -> {60 Celsius},
        Output -> Options
      ];
      Lookup[options, PrimerGradientAnnealingMaxTemperature],
      {60 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerGradientAnnealingMaxTemperature, "Automatically set to 65\[Degree]Celsius if PrimerGradientAnnealing is set to True and PrimerAnnealing is set to False:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        Output -> Options
      ];
      Lookup[options, PrimerGradientAnnealingMaxTemperature],
      65 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerGradientAnnealingRow, "Specify the row for sample during gradient annealing step; Temperature is determined automatically using minimum and maximum gradient values, or must match the exact value if specified; PrimerAnnealing must be specified as False when PrimerGradientAnnealing is True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        PrimerGradientAnnealingRow -> {"Row B"},
        Output -> Options
      ];
      Lookup[options, PrimerGradientAnnealingRow],
      {{"Row B", 56.4 Celsius}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerGradientAnnealingRow, "Row is automatically determined from ActiveWell when PrimerAnnealing is specified as False and PrimerGradientAnnealing is True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PrimerAnnealing -> {False},
        PrimerGradientAnnealing -> {True},
        ActiveWell -> {"B1"},
        Output -> Options
      ];
      Lookup[options, PrimerGradientAnnealingRow],
      {"Row B", 56.4 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PrimerGradientAnnealingRow, "Automatically resolves PrimerGradientAnnealingRow when PreparedPlate is True, PrimerAnnealing is False and PrimerGradientAnnealing is True:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID]},
        PreparedPlate -> True,
        PrimerAnnealing -> False,
        PrimerGradientAnnealing -> True,
        Output -> Options
      ];
      Lookup[options, PrimerGradientAnnealingRow],
      {"Row A", 55. Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- Extension -*)
    Example[{Options, Extension, "Specify if extension will be performed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Extension -> {False},
        Output -> Options
      ];
      Lookup[options, Extension],
      {False},
      Variables :> {options}
    ],

    Example[{Options, ExtensionTime, "Specify the duration for extension step; Extension must be specified as True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Extension -> {True},
        ExtensionTime -> {60 Second},
        Output -> Options
      ];
      Lookup[options, ExtensionTime],
      {60 Second},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ExtensionTime, "Automatically set to 60 seconds if Extension is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Extension -> {True},
        Output -> Options
      ];
      Lookup[options, ExtensionTime],
      60 Second,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ExtensionTemperature, "Specify the incubation temperature for extension step; Extension must be specified as True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Extension -> {True},
        ExtensionTemperature -> {60 Celsius},
        Output -> Options
      ];
      Lookup[options, ExtensionTemperature],
      {60 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ExtensionTemperature, "Automatically set to 60\[Degree]Celsius if Extension is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Extension -> {True},
        Output -> Options
      ];
      Lookup[options, ExtensionTemperature],
      60 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ExtensionRampRate, "Specify the rate of temperature change for extension step Extension must be set as True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Extension -> {True},
        ExtensionRampRate -> {2.0 (Celsius / Second)},
        Output -> Options
      ];
      Lookup[options, ExtensionRampRate],
      {2.0 (Celsius / Second)},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ExtensionRampRate, "Automatically set to 2.0\[Degree]Celsius/Second if Extension is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Extension -> {True},
        Output -> Options
      ];
      Lookup[options, ExtensionRampRate],
      2.0 (Celsius / Second),
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- Number Of Cycles -*)
    Example[{Options, NumberOfCycles, "Specify number of PCR cycles to run:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        NumberOfCycles -> {40},
        Output -> Options
      ];
      Lookup[options, NumberOfCycles],
      {40},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- Polymerase Degradation -*)
    Example[{Options, PolymeraseDegradation, "Specify if polymerase degradation will be performed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradation -> {False},
        Output -> Options
      ];
      Lookup[options, PolymeraseDegradation],
      {False},
      Variables :> {options}
    ],

    Example[{Options, PolymeraseDegradationTime, "Specify the duration for polymerase degradation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradationTime -> {10 Minute},
        Output -> Options
      ];
      Lookup[options, PolymeraseDegradationTime],
      {10 Minute},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PolymeraseDegradationTime, "Automatically set to 10 Minutes when PolymeraseDegradation is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradation -> {True},
        Output -> Options
      ];
      Lookup[options, PolymeraseDegradationTime],
      10 Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PolymeraseDegradationTemperature, "Specify the incubation temperature for polymerase degradation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradationTemperature -> {98 Celsius},
        Output -> Options
      ];
      Lookup[options, PolymeraseDegradationTemperature],
      {98 Celsius},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PolymeraseDegradationTemperature, "Automatically set to 98\[Degree]Celsius when PolymeraseDegradation is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradation -> {True},
        Output -> Options
      ];
      Lookup[options, PolymeraseDegradationTemperature],
      98 Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PolymeraseDegradationRampRate, "Specify the rate of temperature change for polymerase degradation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradationRampRate -> {2.5 (Celsius / Second)},
        Output -> Options
      ];
      Lookup[options, PolymeraseDegradationRampRate],
      {2.5 (Celsius / Second)},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PolymeraseDegradationRampRate, "Automatically set to 2.5\[Degree]Celsius/Second when PolymeraseDegradation is set to True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradation -> {True},
        Output -> Options
      ];
      Lookup[options, PolymeraseDegradationRampRate],
      2.5 (Celsius / Second),
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, PolymeraseDegradationRampRate, "Specify the rate of temperature change for polymerase degradation step:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        PolymeraseDegradationRampRate -> {2.5 (Celsius / Second)},
        Output -> Options
      ];
      Lookup[options, PolymeraseDegradationRampRate],
      {2.5 (Celsius / Second)},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- Probe Fluorescence Properties -*)
    Example[{Options, ProbeFluorophore, "Specify fluorophore model molecule on probe input to sample; must be index matched to probe input:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ProbeFluorophore -> {{Model[Molecule, "id:9RdZXv1oADYx"]}},
        Output -> Options
      ];
      Lookup[options, ProbeFluorophore],
      {{ObjectP[Model[Molecule, "id:9RdZXv1oADYx"]]}},
      Variables :> {options}
    ],

    Example[{Options, ProbeFluorophore, "Fluorophore molecule is automatically determined from probe identity oligomer model:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ProbeFluorophore],
      {ObjectP[Model[Molecule, "id:9RdZXv1oADYx"]]},
      Variables :> {options}
    ],

    Example[{Options, ProbeExcitationWavelength, "Specify excitation wavelength for probe input to sample; must be index matched to probe input:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ProbeExcitationWavelength -> {{495. Nanometer}},
        Output -> Options
      ];
      Lookup[options, ProbeExcitationWavelength],
      {{495. Nanometer}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ProbeExcitationWavelength, "Fluorophore excitation wavelength is automatically determined from probe identity oligomer model:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ProbeExcitationWavelength],
      {495. Nanometer},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ProbeEmissionWavelength, "Specify emission wavelength for probe input to sample; must be index matched to probe input:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ProbeEmissionWavelength -> {{517. Nanometer}},
        Output -> Options
      ];
      Lookup[options, ProbeEmissionWavelength],
      {{517. Nanometer}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ProbeEmissionWavelength, "Fluorophore emission wavelength is automatically determined from probe identity oligomer model:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ProbeEmissionWavelength],
      {517. Nanometer},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    (*- Reference Probe Fluorescence Properties -*)
    Example[{Options, ReferenceProbeFluorophore, "Specify fluorophore model molecule on probe used for reference targets; must be index matched to ReferenceProbes:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ReferenceProbeFluorophore -> {{Model[Molecule, "HEX"]}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeFluorophore],
      {{ObjectP[Model[Molecule, "HEX"]]}},
      Variables :> {options}
    ],

    Example[{Options, ReferenceProbeFluorophore, "Fluorophore molecule is automatically determined from probe identity oligomer model:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeFluorophore],
      {ObjectP[Model[Molecule, "HEX"]]},
      Variables :> {options}
    ],

    Example[{Options, ReferenceProbeExcitationWavelength, "Specify excitation wavelength for probe used for reference targets; must be index matched to ReferenceProbes:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ReferenceProbeExcitationWavelength -> {{535. Nanometer}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeExcitationWavelength],
      {{535. Nanometer}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReferenceProbeExcitationWavelength, "Fluorophore excitation wavelength is automatically determined from probe identity oligomer model:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeExcitationWavelength],
      {535. Nanometer},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReferenceProbeEmissionWavelength, "Specify emission wavelength for probe used for reference targets; must be index matched to ReferenceProbes:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ReferenceProbeEmissionWavelength -> {{556. Nanometer}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeEmissionWavelength],
      {{556. Nanometer}},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReferenceProbeEmissionWavelength, "Fluorophore emission wavelength is automatically determined from probe identity oligomer model:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeEmissionWavelength],
      {556. Nanometer},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReferenceProbeEmissionWavelength, "Fluorophore emission wavelength is automatically determined from probe identity oligomer models when multiplexing is used:"},
      protocol = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ];
      Download[protocol, MultiplexedReferenceProbeEmissionWavelengths],
      {{517. Nanometer, 517. Nanometer}},
      EquivalenceFunction -> Equal,
      Variables :> {protocol}
    ],

    (*- Storage Condition -*)
    Example[{Options, ForwardPrimerStorageCondition, "ForwardPrimerStorageCondition can be specified:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ForwardPrimerStorageCondition -> {Refrigerator},
        Output -> Options
      ];
      Lookup[options, ForwardPrimerStorageCondition],
      {Refrigerator},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReversePrimerStorageCondition, "ReversePrimerStorageCondition can be specified:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ReversePrimerStorageCondition -> {Refrigerator},
        Output -> Options
      ];
      Lookup[options, ReversePrimerStorageCondition],
      {Refrigerator},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ProbeStorageCondition, "ProbeStorageCondition can be specified:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ProbeStorageCondition -> {Refrigerator},
        Output -> Options
      ];
      Lookup[options, ProbeStorageCondition],
      {Refrigerator},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReferenceForwardPrimerStorageCondition, "ReferenceForwardPrimerStorageCondition can be specified:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ReferenceForwardPrimerStorageCondition -> {Refrigerator},
        Output -> Options
      ];
      Lookup[options, ReferenceForwardPrimerStorageCondition],
      {Refrigerator},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReferenceReversePrimerStorageCondition, "ReferenceReversePrimerStorageCondition can be specified:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ReferenceReversePrimerStorageCondition -> {Refrigerator},
        Output -> Options
      ];
      Lookup[options, ReferenceReversePrimerStorageCondition],
      {Refrigerator},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, ReferenceProbeStorageCondition, "ReferenceProbeStorageCondition can be specified:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        ReferencePrimerPairs -> {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        ReferenceProbes -> {{Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        ReferenceProbeStorageCondition -> {Refrigerator},
        Output -> Options
      ];
      Lookup[options, ReferenceProbeStorageCondition],
      {Refrigerator},
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],

    Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared, and corresponding pairs of primer objects and probe objects:"},
      options = ExperimentDigitalPCR[
        {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 2 sample forward" <> $SessionUUID],
            Object[Sample, "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        PreparedModelContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
        PreparedModelAmount -> 1 Milliliter,
        Output -> Options
      ];
      prepUOs = Lookup[options, PreparatoryUnitOperations];
      {
        prepUOs[[-1, 1]][Sample],
        prepUOs[[-1, 1]][Container],
        prepUOs[[-1, 1]][Amount],
        prepUOs[[-1, 1]][Well],
        prepUOs[[-1, 1]][ContainerLabel]
      },
      {
        {ObjectP[Model[Sample, "Milli-Q water"]]..},
        {ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]..},
        {EqualP[1 Milliliter]..},
        {"A1", "B1"},
        {_String, _String}
      },
      Variables :> {options, prepUOs}
    ],

    Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
      ExperimentDigitalPCR[
        {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID],
          Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}},
          {{Object[Sample, "ExperimentDigitalPCR test primer 2 sample forward" <> $SessionUUID],
            Object[Sample, "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]},
          {Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID]}},
        PreparedModelAmount -> 1 Milliliter, Aliquot -> True, Mix -> True
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],


    (*-- Tests --*)
    Test["Accepts a model-less sample object:",
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test model-less sample" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    Test["Accepts non-empty containers for primer inputs:",
      ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID], Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    Test["Accepts multiple non-empty containers as input:",
      ExperimentDigitalPCR[
        {Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID], Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}, {{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}, {Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}
      ],
      ObjectP[Object[Protocol, DigitalPCR]]
    ],

    Test["Uses Model[Sample,StockSolution,\"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix\"], when Model[Sample,\"Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer\"] is supplied as the MasterMix:",
      protocol = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        MasterMix -> {Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"]}
      ];
      Download[protocol, MasterMixes],
      {LinkP[Model[Sample, StockSolution, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix"]]},
      Variables :> {protocol}
    ],

    Test["When SampleDilution is specified as True, ActiveWells are assigned according to number of dilutions:",
      protocol = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        SerialDilutionCurve -> {10 * Microliter, {0.2, 3}}
      ];
      Download[protocol, ActiveWells],
      {"A1", "B1", "C1", "D1"},
      Variables :> {protocol}
    ],
    Test["When NumberofReplicates is specified as 3, SamplesIn, primers and probes are all expanded accordingly:",
      protocol = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        NumberOfReplicates -> 3
      ];
      Download[
        protocol,
        {
          SamplesIn,
          ForwardPrimers,
          ReversePrimers,
          Probes
        }
      ],
      {
        {
          ObjectP[Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]]
        },
        {
          ObjectP[Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID]]
        },
        {
          ObjectP[Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]]
        },
        {
          ObjectP[Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]],
          ObjectP[Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]]
        }
      },
      Variables :> {protocol}
    ],
    Test["When SampleDilution is specified as True and NumberofReplicates is specified as 2, ActiveWells are assigned according to number of dilutions and number of replicates:",
      protocol = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        SerialDilutionCurve -> {10 * Microliter, {0.2, 3}},
        NumberOfReplicates -> 2
      ];
      Download[protocol, ActiveWells],
      {"A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1"},
      Variables :> {protocol}
    ],
    Test["When SampleDilution is specified as True, SampleVolume is expanded to match number of dilutions:",
      protocol = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        SerialDilutionCurve -> {10 * Microliter, {0.2, 3}}
      ];
      Length[Download[protocol, SampleVolumes]],
      4,
      EquivalenceFunction -> Equal,
      Variables :> {protocol}
    ],
    Test["When SampleDilution is specified as True and NumberofReplicates is specified as 2, SampleVolume is expanded to match number of dilutions and number of replicates:",
      protocol = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        SampleDilution -> True,
        SerialDilutionCurve -> {10 * Microliter, {0.2, 3}},
        NumberOfReplicates -> 2
      ];
      Length[Download[protocol, SampleVolumes]],
      8,
      EquivalenceFunction -> Equal,
      Variables :> {protocol}
    ],

    (*-- Shared protocol options tests --*)
    (* Shared Option Test *)
    Example[{Options, Template, "Inherit options from a previously run protocol:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
        Template -> Object[Protocol, DigitalPCR, "ExperimentDigitalPCR test protocol" <> $SessionUUID],
        Output -> Options
      ];
      Lookup[options, ReverseTranscription],
      True,
      Variables :> {options}
    ],

    Example[{Options, Name, "Name the protocol for ExperimentDigitalPCR:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Name -> "My ddPCR protocol",
        Output -> Options
      ];
      Lookup[options, Name],
      "My ddPCR protocol",
      Variables :> {options}
    ],

    (*-- Shared sample prep options tests --*)
    Example[{Additional, "Use the sample preparation options to prepare samples before the main experiment:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        Incubate -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True, Output -> Options
      ];
      {Lookup[options, Incubate], Lookup[options, Centrifuge], Lookup[options, Filtration], Lookup[options, Aliquot]},
      {True, True, True, True},
      Variables :> {options},
      TimeConstraint -> 240
    ],

    Example[{Options, PreparatoryUnitOperations, "Specify prepared samples to be run on a digital PCR experiment:"},
      (
        ClearDownload[]; ClearMemoization[];
        protocol = ExperimentDigitalPCR[
          {"ExperimentDigitalPCR PreparatoryUnitOperations test vessel 1" <> $SessionUUID},
          {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
          {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
          PreparatoryUnitOperations -> {
            LabelContainer[Label -> "ExperimentDigitalPCR PreparatoryUnitOperations test vessel 1" <> $SessionUUID, Container -> Model[Container, Vessel, "2mL Tube"]],
            Transfer[Source -> Model[Sample, "Milli-Q water"], Destination -> "ExperimentDigitalPCR PreparatoryUnitOperations test vessel 1" <> $SessionUUID, Amount -> 2 Microliter]
          }
        ];
        Download[protocol, PreparatoryUnitOperations]
      ),
      {SamplePreparationP..},
      Variables :> {protocol},
      TimeConstraint -> 300
    ],

    Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare primer samples from models before the experiment is run:"},
      (
        ClearDownload[]; ClearMemoization[];
        protocol = ExperimentDigitalPCR[
          {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
          {{{"ExperimentDigitalPCR PreparatoryUnitOperations test vessel 1" <> $SessionUUID, "ExperimentDigitalPCR PreparatoryUnitOperations test vessel 2" <> $SessionUUID}}},
          {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
          PreparatoryUnitOperations -> {
            LabelContainer[Label -> "ExperimentDigitalPCR PreparatoryUnitOperations test vessel 1" <> $SessionUUID, Container -> Model[Container, Vessel, "2mL Tube"]],
            LabelContainer[Label -> "ExperimentDigitalPCR PreparatoryUnitOperations test vessel 2" <> $SessionUUID, Container -> Model[Container, Vessel, "2mL Tube"]],
            Transfer[
              Source -> Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
              Destination -> {"ExperimentDigitalPCR PreparatoryUnitOperations test vessel 1" <> $SessionUUID, "ExperimentDigitalPCR PreparatoryUnitOperations test vessel 2" <> $SessionUUID},
              Amount -> {5., 5.} Microliter
            ]
          }
        ];
        Download[protocol, PreparatoryUnitOperations]
      ),
      {SamplePreparationP..},
      Variables :> {protocol},
      TimeConstraint -> 300
    ],

    (*Incubate options tests*)
    Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, Incubate -> True, Output -> Options];
      Lookup[options, Incubate],
      True,
      Variables :> {options}
    ],
    Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, IncubationTime -> 40 * Minute, Output -> Options];
      Lookup[options, IncubationTime],
      40 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, MaxIncubationTime -> 40 * Minute, Output -> Options];
      Lookup[options, MaxIncubationTime],
      40 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, IncubationTemperature -> 40 * Celsius, Output -> Options];
      Lookup[options, IncubationTemperature],
      40 * Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (*Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle*)
    Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, IncubationInstrument -> Model[Instrument, HeatBlock, "AHP-1200CPV"], Output -> Options];
      Lookup[options, IncubationInstrument],
      ObjectP[Model[Instrument, HeatBlock, "AHP-1200CPV"]],
      Variables :> {options}
    ],
    Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, AnnealingTime -> 40 * Minute, Output -> Options];
      Lookup[options, AnnealingTime],
      40 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, IncubateAliquot -> 0.1 * Milliliter, Output -> Options];
      Lookup[options, IncubateAliquot],
      0.1 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, IncubateAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, IncubateAliquotDestinationWell -> "A1", AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, IncubateAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],
    Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, Mix -> True, Output -> Options];
      Lookup[options, Mix],
      True,
      Variables :> {options}
    ],
    (*Note: You CANNOT be in a plate for the following test*)
    Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, MixType -> Shake, Output -> Options];
      Lookup[options, MixType],
      Shake,
      Variables :> {options}
    ],
    Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, MixUntilDissolved -> True, Output -> Options];
      Lookup[options, MixUntilDissolved],
      True,
      Variables :> {options}
    ],

    (*Centrifuge options tests*)
    Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, Centrifuge -> True, Output -> Options];
      Lookup[options, Centrifuge],
      True,
      Variables :> {options}
    ],
    (*Note: CentrifugeTime cannot go above 5 minutes without restricting the types of centrifuges that can be used*)
    Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, CentrifugeTime -> 5 * Minute, Output -> Options];
      Lookup[options, CentrifugeTime],
      5 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
      options = ExperimentDigitalPCR[
        {Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]},
        {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}},
        {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}},
        CentrifugeTemperature -> 30 * Celsius,
        CentrifugeAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
        AliquotContainer -> Model[Container, Vessel, "2mL Tube"],
        Output -> Options];
      Lookup[options, CentrifugeTemperature],
      30 * Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options},
      TimeConstraint -> 240
    ],
    Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, CentrifugeIntensity -> 1000 * RPM, Output -> Options];
      Lookup[options, CentrifugeIntensity],
      1000 * RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (*Note: Put your sample in a 2mL tube for the following test*)
    Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
      Lookup[options, CentrifugeInstrument],
      ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, CentrifugeAliquot -> 0.5 * Milliliter, Output -> Options];
      Lookup[options, CentrifugeAliquot],
      0.5 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, CentrifugeAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
      Lookup[options, CentrifugeAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],

    (*Filter options tests*)
    Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, Filtration -> True, Output -> Options];
      Lookup[options, Filtration],
      True,
      Variables :> {options}
    ],
    Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, FiltrationType -> Syringe, Output -> Options];
      Lookup[options, FiltrationType],
      Syringe,
      Variables :> {options}
    ],
    Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump" ], Output -> Options];
      Lookup[options, FilterInstrument],
      ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
      Variables :> {options}
    ],
    Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
      Lookup[options, Filter],
      ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
      Variables :> {options},
      TimeConstraint -> 240
    ],
    Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, FilterMaterial -> PES, FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, FilterMaterial],
      PES,
      Variables :> {options}
    ],

    (*Note: Put your sample in a 50mL tube for the following test*)
    Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, PrefilterMaterial -> GxF, Output -> Options];
      Lookup[options, PrefilterMaterial],
      GxF,
      Variables :> {options}
    ],
    Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
      Lookup[options, FilterPoreSize],
      0.22 * Micrometer,
      Variables :> {options}
    ],
    (*Note: Put your sample in a 50mL tube for the following test*)
    Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, PrefilterPoreSize -> 1. * Micrometer, FilterMaterial -> PTFE, Output -> Options];
      Lookup[options, PrefilterPoreSize],
      1. * Micrometer,
      Variables :> {options}
    ],
    Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
      Lookup[options, FilterSyringe],
      ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
      Variables :> {options}
    ],
    Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, Output -> Options];
      Lookup[options, FilterHousing],
      Null,
      Variables :> {options}
    ],
    Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, FiltrationType -> Centrifuge, FilterTime -> 20 * Minute, Output -> Options];
      Lookup[options, FilterTime],
      20 * Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (*Note: Put your sample in a 50mL tube for the following test*)
    Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, FiltrationType -> Centrifuge, FilterTemperature -> 10 * Celsius, Output -> Options];
      Lookup[options, FilterTemperature],
      10 * Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, FiltrationType -> Centrifuge, FilterIntensity -> 1000 * RPM, Output -> Options];
      Lookup[options, FilterIntensity],
      1000 * RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
    Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]}, FilterSterile -> True, Output -> Options];
      Lookup[options, FilterSterile],
      True,
      Variables :> {options}
    ],*)
    Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, FilterAliquot -> 0.5 * Milliliter, Output -> Options];
      Lookup[options, FilterAliquot],
      0.5 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, FilterAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID]}, FilterAliquotDestinationWell -> "A1", Output -> Options];
      Lookup[options, FilterAliquotDestinationWell],
      "A1",
      Variables :> {options}
    ],
    Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, FilterContainerOut],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],

    (*Aliquot options tests*)
    Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, Aliquot -> True, Output -> Options];
      Lookup[options, Aliquot],
      True,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, AliquotAmount -> 0.15 * Milliliter, Output -> Options];
      Lookup[options, AliquotAmount],
      0.15 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, AssayVolume -> 0.15 * Milliliter, Output -> Options];
      Lookup[options, AssayVolume],
      0.15 * Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, TargetConcentration -> 5 * Micromolar, Output -> Options];
      Lookup[options, TargetConcentration],
      5 * Micromolar,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, TargetConcentration -> 1 * Micromolar, TargetConcentrationAnalyte -> Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID], AssayVolume -> 0.5 * Milliliter, Output -> Options];
      Lookup[options, TargetConcentrationAnalyte],
      ObjectP[Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]],
      Variables :> {options}
    ],
    Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 0.15 * Milliliter, AssayVolume -> 0.5 * Milliliter, Output -> Options];
      Lookup[options, ConcentratedBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables :> {options}
    ],
    Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 0.1 * Milliliter, AssayVolume -> 0.2 * Milliliter, Output -> Options];
      Lookup[options, BufferDilutionFactor],
      10,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 0.15 * Milliliter, AssayVolume -> 0.8 * Milliliter, Output -> Options];
      Lookup[options, BufferDiluent],
      ObjectP[Model[Sample, "Milli-Q water"]],
      Variables :> {options}
    ],
    Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 0.15 * Milliliter, AssayVolume -> 0.8 * Milliliter, Output -> Options];
      Lookup[options, AssayBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables :> {options}
    ],
    Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options, AliquotSampleStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],
    Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, ConsolidateAliquots -> True, Output -> Options];
      Lookup[options, ConsolidateAliquots],
      True,
      Variables :> {options}
    ],
    Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
      Lookup[options, AliquotPreparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, AliquotContainer],
      {{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
      Variables :> {options}
    ],
    Example[{Options, DestinationWell, "Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID]}, {{{Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID], Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID]}}}, {{Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID]}}, DestinationWell -> "A1", Output -> Options];
      Lookup[options, DestinationWell],
      {"A1"},
      Variables :> {options}
    ],

    (*Post-processing options tests*)
    Example[{Options, MeasureWeight, "Set the MeasureWeight option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, MeasureWeight -> True, Output -> Options];
      Lookup[options, MeasureWeight],
      True,
      Messages:> {Warning::PostProcessingSterileSamples},
      Variables :> {options}
    ],
    Example[{Options, MeasureVolume, "Set the MeasureVolume option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, MeasureVolume -> True, Output -> Options];
      Lookup[options, MeasureVolume],
      True,
      Messages:> {Warning::PostProcessingSterileSamples},
      Variables :> {options}
    ],
    Example[{Options, ImageSample, "Set the ImageSample option to True will trigger a warning because we expect the samples for post processing will be Sterile->True:"},
      options = ExperimentDigitalPCR[{Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID]}, ImageSample -> True, Output -> Options];
      Lookup[options, ImageSample],
      True,
      Messages:> {Warning::PostProcessingSterileSamples},
      Variables :> {options}
    ]
  },
  SymbolSetUp :> {
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = Cases[Flatten[{
        Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID],
        Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID],
        Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 3" <> $SessionUUID],
        Object[Container, Vessel, "ExperimentDigitalPCR test 2mL tube" <> $SessionUUID],
        Object[Container, Vessel, "ExperimentDigitalPCR test 2mL tube for mastermix" <> $SessionUUID],
        Object[Container, Vessel, "ExperimentDigitalPCR test 50mL tube" <> $SessionUUID],
        Object[Container, Vessel, "ExperimentDigitalPCR test 50mL tube 2" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge without passive well buffer" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 2" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 3" <> $SessionUUID],
        Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID],
        Object[Item, PlateSeal, "ExperimentDigitalPCR fake foil resource" <> $SessionUUID],

        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 2" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 3" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 4" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule Without Fluorescence" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule With Multiple Fluorophores" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule Incompatible Fluorophore" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule (No Molecular Weight)" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule (No Molecular Weight)" <> $SessionUUID],

        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 2 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 3 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 4 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample without fluorescence" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample with multiple fluorophores" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample (Deprecated)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes (Deprecated)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test target assay model" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer set model" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 2 model sample (Low Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Low Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Conc, No MW)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Conc, No MW)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Percent)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Percent)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample with incompatible fluorophore" <> $SessionUUID],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes without Concentration" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR 1x dilute passive well buffer model" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 2" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer 2 sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer large volume" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test discarded sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded primer sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded primer sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded sample with primers and probes" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test deprecated model sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test deprecated model primer sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test deprecated model primer sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test deprecated model sample with primers and probes" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample with primers and probes in cartridge unfilled" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 2 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 3 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 4 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 5 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 6 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 7 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 8 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 9 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 10 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 11 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 12 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 13 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 14 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 15 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 16 with primers and probes in cartridge" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample 17 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 18 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 19 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 20 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 21 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 1" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 2" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 3" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 4" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 5" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 6" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 7" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 8" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 9" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 10" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 11" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample 1 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 2 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 3 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 4 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 5 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 6 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 7 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 8 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 9 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 10 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 11 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 12 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 13 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 14 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 15 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 16 without primers and probes in cartridge" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test model-less sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test solid sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe without fluorescence" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe with multiple fluorophores" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe with low concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer forward with low concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer reverse with low concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration, no MW" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration, no MW" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration, no MW" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe sample with mass percent" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass percent" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass percent" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe with incompatible fluorophore" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Supermix for Probes Sample without Concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes buffer sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes enzyme sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes dtt sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Multiplex Supermix sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Supermix for Probes sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Supermix for Probes (No dUTP) sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Supermix for Residual DNA Quantification sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Buffer Control for Probes sample" <> $SessionUUID],

        If[DatabaseMemberQ[Object[Protocol, DigitalPCR, "ExperimentDigitalPCR test protocol" <> $SessionUUID]],
          Download[Object[Protocol, DigitalPCR, "ExperimentDigitalPCR test protocol" <> $SessionUUID], {Object, SubprotocolRequiredResources[Object], ProcedureLog[Object]}]
        ]
      }], ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];

    (*Make some empty test container objects*)
    Upload[{
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ExperimentDigitalPCR test 96-well PCR plate 3" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCR test cartridge without passive well buffer" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID,
        Site -> Link[$Site],
        Status -> Available
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCR fake resource cartridge 2" <> $SessionUUID,
        Site -> Link[$Site],
        Status -> Available
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCR fake resource cartridge 3" <> $SessionUUID,
        Site -> Link[$Site],
        Status -> Available
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
        Name -> "ExperimentDigitalPCR test 2mL tube" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
        Name -> "ExperimentDigitalPCR test 2mL tube for mastermix" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "ExperimentDigitalPCR test 50mL tube" <> $SessionUUID,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Vessel],
        Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
        Name -> "ExperimentDigitalPCR test 50mL tube 2" <> $SessionUUID,
        Site -> Link[$Site]
      |>
    }];

    (* Create Model[Molecule]s for primers and fluorescent probes *)
    oligoPackets = UploadOligomer[
      {
        "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID, (*FAM*)
        "ExperimentDigitalPCR test Probe Oligo Molecule 2" <> $SessionUUID, (*HEX*)
        "ExperimentDigitalPCR test Probe Oligo Molecule 3" <> $SessionUUID, (*Cy5*)
        "ExperimentDigitalPCR test Probe Oligo Molecule 4" <> $SessionUUID, (*Cy5.5*)
        "ExperimentDigitalPCR test Probe Oligo Molecule Without Fluorescence" <> $SessionUUID,
        "ExperimentDigitalPCR test Probe Oligo Molecule With Multiple Fluorophores" <> $SessionUUID, (* Cy5 and Cy5.5 *)
        "ExperimentDigitalPCR test Probe Oligo Molecule Incompatible Fluorophore" <> $SessionUUID, (*Alexa488*)
        "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID,
        "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID
      },
      Molecule -> {
        Strand[DNA["CAGCGTGGTTACATACCTGG"]],
        Strand[DNA["GCATTCGCAATGCACACTAA"]],
        Strand[DNA["GCATTCGCAATGCACACTAC"]],
        Strand[DNA["GCATTCGCAATGCACACTAT"]],
        Strand[DNA["GGATTCGCAATGCACACTAC"]],
        Strand[DNA["GCTTTCGCAATGCACACTAT"]],
        Strand[DNA["CAGAGTGGTTAGTTTCCTGG"]],
        Strand[DNA["CAGAGTGGTTACATACCTGG"]],
        Strand[DNA["GTCTCACCAATGTATGGACC"]]
      },
      PolymerType -> DNA,
      MSDSFile -> NotApplicable,
      IncompatibleMaterials -> ConstantArray[{None}, 9],
      State -> Liquid,
      BiosafetyLevel -> "BSL-1",
      Upload -> False
    ];

    (* UploadOligomer doesn't support assignment of fluorophore-related fields, so update with that information *)
    probeMoleculeUpdates = With[
      {
        probeMolec1 = Lookup[oligoPackets[[1]], Object],
        probeMolec2 = Lookup[oligoPackets[[2]], Object],
        probeMolec3 = Lookup[oligoPackets[[3]], Object],
        probeMolec4 = Lookup[oligoPackets[[4]], Object],
        probeMolec6 = Lookup[oligoPackets[[6]], Object],
        probeMolec7 = Lookup[oligoPackets[[7]], Object]
      },
      {
        <|
          Object -> probeMolec1,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> 495 Nanometer,
          Replace[FluorescenceEmissionMaximums] -> 517 Nanometer,
          Replace[DetectionLabels] -> Link[Model[Molecule, "id:9RdZXv1oADYx"]], (*FAM*)
          DeveloperObject -> True
        |>,
        <|
          Object -> probeMolec2,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> 535 Nanometer,
          Replace[FluorescenceEmissionMaximums] -> 556 Nanometer,
          Replace[DetectionLabels] -> Link[Model[Molecule, "HEX"]],
          DeveloperObject -> True
        |>,
        <|
          Object -> probeMolec3,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> 647 Nanometer,
          Replace[FluorescenceEmissionMaximums] -> 665 Nanometer,
          Replace[DetectionLabels] -> Link[Model[Molecule, "Cy5"]],
          DeveloperObject -> True
        |>,
        <|
          Object -> probeMolec4,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> 675 Nanometer,
          Replace[FluorescenceEmissionMaximums] -> 694 Nanometer,
          Replace[DetectionLabels] -> Link[Model[Molecule, "Cy5.5"]],
          DeveloperObject -> True
        |>,
        <|
          Object -> probeMolec6,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> {647 Nanometer, 675 Nanometer},
          Replace[FluorescenceEmissionMaximums] -> {665 Nanometer, 694 Nanometer},
          Replace[DetectionLabels] -> {Link[Model[Molecule, "Cy5"]], Link[Model[Molecule, "Cy5.5"]]},
          DeveloperObject -> True
        |>,
        <|
          Object -> probeMolec7,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> 490 Nanometer,
          Replace[FluorescenceEmissionMaximums] -> 525 Nanometer,
          Replace[DetectionLabels] -> Link[Model[Molecule, "id:eGakldJP9pw1"]],
          DeveloperObject -> True
        |>
      }
    ];

    (* Upload the probe identity models and their updates *)
    Upload[Join[oligoPackets, probeMoleculeUpdates]];

    (* Upload oligomer identity models without Molecular Weight *)
    Upload[
      <|
        Type -> Model[Molecule, Oligomer],
        Name -> "ExperimentDigitalPCR test Probe Oligo Molecule (No Molecular Weight)" <> $SessionUUID,
        Molecule -> Strand[DNA["CAGCGTGGTTACATACCTGG"]],
        PolymerType -> DNA,
        MSDSRequired -> False,
        Replace[IncompatibleMaterials] -> {None},
        State -> Liquid,
        Fluorescent -> True,
        Replace[FluorescenceExcitationMaximums] -> 495 Nanometer,
        Replace[FluorescenceEmissionMaximums] -> 517 Nanometer,
        Replace[DetectionLabels] -> Link[Model[Molecule, "id:9RdZXv1oADYx"]], (*FAM*)
        DeveloperObject -> True
      |>
    ];
    Upload[
      <|
        Type -> Model[Molecule, Oligomer],
        Name -> "ExperimentDigitalPCR test Primer Oligo Molecule (No Molecular Weight)" <> $SessionUUID,
        Molecule -> Strand[DNA["CAGCGTGGGGCCATACCTGG"]],
        PolymerType -> DNA,
        MSDSRequired -> False,
        Replace[IncompatibleMaterials] -> {None},
        State -> Liquid,
        DeveloperObject -> True
      |>
    ];

    (*Make some test sample models*)
    UploadSampleModel[
      {
        "ExperimentDigitalPCR test probe 1 model sample" <> $SessionUUID,
        "ExperimentDigitalPCR test probe 2 model sample" <> $SessionUUID,
        "ExperimentDigitalPCR test probe 3 model sample" <> $SessionUUID,
        "ExperimentDigitalPCR test probe 4 model sample" <> $SessionUUID,
        "ExperimentDigitalPCR test probe model sample without fluorescence" <> $SessionUUID,
        "ExperimentDigitalPCR test probe model sample with multiple fluorophores" <> $SessionUUID,
        "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID,
        "ExperimentDigitalPCR test primer 1 model sample (Deprecated)" <> $SessionUUID,
        "ExperimentDigitalPCR test primer 2 model sample" <> $SessionUUID,
        "ExperimentDigitalPCR test probe 1 model sample (Mass Concentration)" <> $SessionUUID,
        "ExperimentDigitalPCR test primer 2 model sample (Mass Concentration)" <> $SessionUUID,
        "ExperimentDigitalPCR test target assay model" <> $SessionUUID,
        "ExperimentDigitalPCR test primer set model" <> $SessionUUID,
        "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID,
        "ExperimentDigitalPCR test model sample with primers and probes (Deprecated)" <> $SessionUUID,
        "ExperimentDigitalPCR test probe 2 model sample (Low Concentration)" <> $SessionUUID,
        "ExperimentDigitalPCR test primer 2 model sample (Low Concentration)" <> $SessionUUID,
        "ExperimentDigitalPCR test probe 1 model sample (Mass Conc, No MW)" <> $SessionUUID,
        "ExperimentDigitalPCR test primer 2 model sample (Mass Conc, No MW)" <> $SessionUUID,
        "ExperimentDigitalPCR test probe 1 model sample (Mass Percent)" <> $SessionUUID,
        "ExperimentDigitalPCR test primer 2 model sample (Mass Percent)" <> $SessionUUID,
        "ExperimentDigitalPCR test probe model sample with incompatible fluorophore" <> $SessionUUID,
        "ExperimentDigitalPCR 1x dilute passive well buffer model" <> $SessionUUID
      },
      Composition ->
          {
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 2" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 3" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 4" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule Without Fluorescence" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule With Multiple Fluorophores" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {30 (Nanogram / Microliter), Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {40 (Nanogram / Microliter), Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID]},
              {5 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID]},
              {5 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID]},
              {5 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {950 Nanomolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 2" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {3 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {15 (Nanogram / Microliter), Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule (No Molecular Weight)" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {15 (Nanogram / Microliter), Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule (No Molecular Weight)" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 MassPercent, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 MassPercent, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule Incompatible Fluorophore" <> $SessionUUID]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {100 VolumePercent, Model[Molecule, "Water"]}
            }
          },
      IncompatibleMaterials -> ConstantArray[{None}, 23],
      Expires -> True,
      ShelfLife -> 2 Year,
      UnsealedShelfLife -> 90 Day,
      DefaultStorageCondition -> ConstantArray[Model[StorageCondition, "Refrigerator"], 23],
      MSDSFile -> NotApplicable,
      BiosafetyLevel -> "BSL-1",
      State -> Liquid
    ];

    (*Make a deprecated test sample model*)
    Upload[
      <|
        Object -> Model[Sample, "ExperimentDigitalPCR test primer 1 model sample (Deprecated)" <> $SessionUUID],
        Deprecated -> True
      |>
    ];
    Upload[
      <|
        Object -> Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes (Deprecated)" <> $SessionUUID],
        Deprecated -> True
      |>
    ];

    (*Make some test sample objects in the test container objects*)
    UploadSample[
      {
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],

        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 2 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test target assay model" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer set model" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID],

        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],

        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample (Deprecated)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample (Deprecated)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample (Deprecated)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes (Deprecated)" <> $SessionUUID],

        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample without fluorescence" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample with multiple fluorophores" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 2 model sample (Low Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Low Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Low Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Conc, No MW)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Conc, No MW)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Conc, No MW)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Percent)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Percent)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Percent)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample with incompatible fluorophore" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID],

        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID],

        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID]
      },
      {
        {"A1", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID]},

        {"A1", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"A2", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"A3", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"A4", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"A5", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"A6", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"A7", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"A8", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"B1", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C1", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},

        {"B2", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"B3", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"B4", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},

        {"B5", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"B6", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"B7", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"B8", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},

        {"B9", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"E1", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C2", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C3", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C4", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C5", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C6", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C7", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C8", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C9", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C10", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C11", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"C12", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"D1", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"D2", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"D3", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID]},
        {"A1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge without passive well buffer" <> $SessionUUID]},

        {"A1", Object[Container, Vessel, "ExperimentDigitalPCR test 2mL tube" <> $SessionUUID]},
        {"A1", Object[Container, Vessel, "ExperimentDigitalPCR test 50mL tube" <> $SessionUUID]},

        {"A1", Object[Container, Vessel, "ExperimentDigitalPCR test 50mL tube 2" <> $SessionUUID]}
      },
      Name ->
          {
            "ExperimentDigitalPCR test sample 1" <> $SessionUUID,

            "ExperimentDigitalPCR test sample 2" <> $SessionUUID,
            "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID,
            "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID,
            "ExperimentDigitalPCR test primer 2 sample forward" <> $SessionUUID,
            "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID,
            "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID,
            "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID,
            "ExperimentDigitalPCR test target assay sample" <> $SessionUUID,
            "ExperimentDigitalPCR test primer set sample" <> $SessionUUID,
            "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID,

            "ExperimentDigitalPCR test discarded sample" <> $SessionUUID,
            "ExperimentDigitalPCR test discarded primer sample forward" <> $SessionUUID,
            "ExperimentDigitalPCR test discarded primer sample reverse" <> $SessionUUID,

            "ExperimentDigitalPCR test deprecated model sample" <> $SessionUUID,
            "ExperimentDigitalPCR test deprecated model primer sample forward" <> $SessionUUID,
            "ExperimentDigitalPCR test deprecated model primer sample reverse" <> $SessionUUID,
            "ExperimentDigitalPCR test deprecated model sample with primers and probes" <> $SessionUUID,

            "ExperimentDigitalPCR test discarded sample with primers and probes" <> $SessionUUID,
            "ExperimentDigitalPCR test probe without fluorescence" <> $SessionUUID,
            "ExperimentDigitalPCR test probe with multiple fluorophores" <> $SessionUUID,
            "ExperimentDigitalPCR test probe with low concentration" <> $SessionUUID,
            "ExperimentDigitalPCR test primer forward with low concentration" <> $SessionUUID,
            "ExperimentDigitalPCR test primer reverse with low concentration" <> $SessionUUID,

            "ExperimentDigitalPCR test probe sample with mass concentration" <> $SessionUUID,
            "ExperimentDigitalPCR test primer forward sample with mass concentration" <> $SessionUUID,
            "ExperimentDigitalPCR test primer reverse sample with mass concentration" <> $SessionUUID,
            "ExperimentDigitalPCR test probe sample with mass concentration, no MW" <> $SessionUUID,
            "ExperimentDigitalPCR test primer forward sample with mass concentration, no MW" <> $SessionUUID,
            "ExperimentDigitalPCR test primer reverse sample with mass concentration, no MW" <> $SessionUUID,
            "ExperimentDigitalPCR test probe sample with mass percent" <> $SessionUUID,
            "ExperimentDigitalPCR test primer forward sample with mass percent" <> $SessionUUID,
            "ExperimentDigitalPCR test primer reverse sample with mass percent" <> $SessionUUID,
            "ExperimentDigitalPCR test probe with incompatible fluorophore" <> $SessionUUID,
            "ExperimentDigitalPCR test sample with primers and probes in cartridge unfilled" <> $SessionUUID,

            "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID,
            "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID,

            "ExperimentDigitalPCR test primer large volume" <> $SessionUUID

          },
      InitialAmount -> Join[
        ConstantArray[0.5 Milliliter, 36],
        {5 Milliliter},
        {50 Milliliter}
      ]
    ];

    (* Make a prepared plate with fully prepared samples only *)
    UploadSample[
      ConstantArray[Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID], 16],
      {
        {"A1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"B1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"C1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"D1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"E1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"F1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"G1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"H1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"A2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"B2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"C2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"D2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"E2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"F2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"G2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]},
        {"H2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID]}
      },
      Name -> {
        "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 2 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 3 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 4 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 5 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 6 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 7 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 8 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 9 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 10 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 11 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 12 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 13 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 14 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 15 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 16 with primers and probes in cartridge" <> $SessionUUID
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 16]
    ];

    (* Make a prepared plate with prepared samples in active wells and passive buffer samples in passive wells *)
    UploadSample[
      Join[
        ConstantArray[Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID], 5],
        ConstantArray[Model[Sample, "ExperimentDigitalPCR 1x dilute passive well buffer model" <> $SessionUUID], 11]
      ],
      {
        {"A1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"B1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"C1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"D1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"E1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"F1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"G1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"H1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"A2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"B2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"C2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"D2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"E2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"F2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"G2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]},
        {"H2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID]}
      },
      Name -> {
        "ExperimentDigitalPCR test sample 17 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 18 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 19 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 20 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 21 with primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 1" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 2" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 3" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 4" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 5" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 6" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 7" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 8" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 9" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 10" <> $SessionUUID,
        "ExperimentDigitalPCR passive well buffer sample 11" <> $SessionUUID
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 16]
    ];

    (* Make a prepared plate with samples without fluorescent probe oligomers *)
    UploadSample[
      ConstantArray[Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID], 16],
      {
        {"A1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"B1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"C1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"D1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"E1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"F1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"G1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"H1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"A2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"B2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"C2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"D2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"E2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"F2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"G2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]},
        {"H2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID]}
      },
      Name -> {
        "ExperimentDigitalPCR test sample 1 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 2 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 3 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 4 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 5 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 6 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 7 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 8 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 9 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 10 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 11 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 12 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 13 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 14 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 15 without primers and probes in cartridge" <> $SessionUUID,
        "ExperimentDigitalPCR test sample 16 without primers and probes in cartridge" <> $SessionUUID
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 16]
    ];

    (*Modify some properties of the test sample objects to set their status as discarded*)
    UploadSampleStatus[
      {
        Object[Sample, "ExperimentDigitalPCR test discarded sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded primer sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded primer sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded sample with primers and probes" <> $SessionUUID]
      },
      ConstantArray[Discarded, 4]
    ];

    (*Make a test model-less sample object*)
    UploadSample[
      {
        {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]},
        {100 VolumePercent, Model[Molecule, "Water"]}
      },
      {"A1", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 3" <> $SessionUUID]},
      Name -> {"ExperimentDigitalPCR test model-less sample" <> $SessionUUID},
      InitialAmount -> 0.5 Milliliter
    ];

    (* Make a test sample with state as Solid instead of Liquid *)
    UploadSample[
      {
        {100 MassPercent, Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID]}
      },
      {"A2", Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 3" <> $SessionUUID]},
      Name -> {"ExperimentDigitalPCR test solid sample" <> $SessionUUID},
      State -> Solid,
      InitialAmount -> 0.5 Milliliter
    ];

    Upload[{
      (* Make a dummy master-mix model without concentration factor *)
      <|
        Type -> Model[Sample],
        Name -> "Bio-Rad ddPCR Supermix for Probes without Concentration" <> $SessionUUID,
        DefaultStorageCondition -> Link[Model[StorageCondition, "Refrigerator"]],
        DeveloperObject -> True,
        State -> Liquid
      |>,
      (* Make a plate to hold master mix samples that can be checked for fulfillment *)
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID
      |>
    }];

    (* Make a dummy master-mix samples for each relevant model for resource picking *)
    UploadSample[
      {
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes without Concentration" <> $SessionUUID],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, RT enzyme"],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, DTT"],
        Model[Sample, "Bio-Rad ddPCR Multiplex Supermix"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes (No dUTP)"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Residual DNA Quantification"],
        Model[Sample, "Bio-Rad ddPCR Buffer Control for Probes"]
      },
      {
        {"A1", Object[Container, Vessel, "ExperimentDigitalPCR test 2mL tube for mastermix" <> $SessionUUID]},
        {"A1", Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID]},
        {"A2", Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID]},
        {"A3", Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID]},
        {"A4", Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID]},
        {"A5", Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID]},
        {"A6", Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID]},
        {"A7", Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID]},
        {"A8", Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID]}
      },
      Name -> {
        "ExperimentDigitalPCR ddPCR Supermix for Probes Sample without Concentration" <> $SessionUUID,
        "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes buffer sample" <> $SessionUUID,
        "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes enzyme sample" <> $SessionUUID,
        "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes dtt sample" <> $SessionUUID,
        "ExperimentDigitalPCR ddPCR Multiplex Supermix sample" <> $SessionUUID,
        "ExperimentDigitalPCR ddPCR Supermix for Probes sample" <> $SessionUUID,
        "ExperimentDigitalPCR ddPCR Supermix for Probes (No dUTP) sample" <> $SessionUUID,
        "ExperimentDigitalPCR ddPCR Supermix for Residual DNA Quantification sample" <> $SessionUUID,
        "ExperimentDigitalPCR ddPCR Buffer Control for Probes sample" <> $SessionUUID
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 9]
    ];

    (* Upload fake DropletCartridge sealing foil object for resource picking *)
    Upload[
      <|
        Type -> Object[Item, PlateSeal],
        Model -> Link[Model[Item, PlateSeal, "GCR96 PCR Plate Seal, Pierceable Heat-Sealed Aluminum"], Objects],
        Name -> "ExperimentDigitalPCR fake foil resource" <> $SessionUUID,
        Count -> 100,
        Status -> Available
      |>
    ];

    (*Generate a test protocol*)
    testProtocol = ExperimentDigitalPCR[
      {Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID]},
      Name -> "ExperimentDigitalPCR test protocol" <> $SessionUUID,
      ReverseTranscription -> {True}
    ];

    (*Get the objects generated in the test protocol*)
    protocolObjects = Download[testProtocol, {Object, SubprotocolRequiredResources[Object], ProcedureLog[Object]}];

    (*Gather all the test objects and models created in SymbolSetUp*)
    allObjects = Flatten[{containerSampleObjects, protocolObjects}];

    allObjects = {
      Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID],
      Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID],
      Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 3" <> $SessionUUID],
      Object[Container, Vessel, "ExperimentDigitalPCR test 2mL tube" <> $SessionUUID],
      Object[Container, Vessel, "ExperimentDigitalPCR test 2mL tube for mastermix" <> $SessionUUID],
      Object[Container, Vessel, "ExperimentDigitalPCR test 50mL tube" <> $SessionUUID],
      Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID],
      Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID],
      Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge without passive well buffer" <> $SessionUUID],
      Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID],
      Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID],

      Model[Sample, "ExperimentDigitalPCR test probe 1 model sample" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe 2 model sample" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe 3 model sample" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe 4 model sample" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe model sample without fluorescence" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe model sample with multiple fluorophores" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test primer 1 model sample (Deprecated)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes (Deprecated)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test primer 2 model sample" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Concentration)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test target assay model" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test primer set model" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe 2 model sample (Low Concentration)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Low Concentration)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Concentration)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Conc, No MW)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Conc, No MW)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Percent)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Percent)" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR test probe model sample with incompatible fluorophore" <> $SessionUUID],
      Model[Sample, "ExperimentDigitalPCR 1x dilute passive well buffer model" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 2" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer 2 sample forward" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test discarded sample" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test discarded primer sample forward" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test discarded primer sample reverse" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test discarded sample with primers and probes" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test deprecated model sample" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test deprecated model primer sample forward" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test deprecated model primer sample reverse" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test deprecated model sample with primers and probes" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample with primers and probes in cartridge unfilled" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 2 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 3 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 4 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 5 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 6 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 7 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 8 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 9 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 10 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 11 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 12 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 13 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 14 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 15 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 16 with primers and probes in cartridge" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test sample 17 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 18 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 19 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 20 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 21 with primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 1" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 2" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 3" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 4" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 5" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 6" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 7" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 8" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 9" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 10" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR passive well buffer sample 11" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test sample 1 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 2 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 3 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 4 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 5 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 6 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 7 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 8 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 9 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 10 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 11 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 12 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 13 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 14 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 15 without primers and probes in cartridge" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample 16 without primers and probes in cartridge" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test model-less sample" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test solid sample" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test probe without fluorescence" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test probe with multiple fluorophores" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test probe with low concentration" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer forward with low concentration" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer reverse with low concentration" <> $SessionUUID],

      Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration, no MW" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration, no MW" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration, no MW" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test probe sample with mass percent" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass percent" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass percent" <> $SessionUUID],
      Object[Sample, "ExperimentDigitalPCR test probe with incompatible fluorophore" <> $SessionUUID]
    };

    (*Make all the test objects and models developer objects*)
    Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
  },
  SymbolTearDown :> {
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = Cases[Flatten[{
        Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 1" <> $SessionUUID],
        Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 2" <> $SessionUUID],
        Object[Container, Plate, "ExperimentDigitalPCR test 96-well PCR plate 3" <> $SessionUUID],
        Object[Container, Vessel, "ExperimentDigitalPCR test 2mL tube" <> $SessionUUID],
        Object[Container, Vessel, "ExperimentDigitalPCR test 2mL tube for mastermix" <> $SessionUUID],
        Object[Container, Vessel, "ExperimentDigitalPCR test 50mL tube" <> $SessionUUID],
        Object[Container, Vessel, "ExperimentDigitalPCR test 50mL tube 2" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test prepared plate with samples & passive well buffer" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge without passive well buffer" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR test cartridge with unprepared samples" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 1" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 2" <> $SessionUUID],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCR fake resource cartridge 3" <> $SessionUUID],
        Object[Container, Plate, "ExperimentDigitalPCR test plate for buffers and diluents" <> $SessionUUID],
        Object[Item, PlateSeal, "ExperimentDigitalPCR fake foil resource" <> $SessionUUID],

        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 1" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 2" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 3" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule 4" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule Without Fluorescence" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule With Multiple Fluorophores" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule Incompatible Fluorophore" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 1" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule 2" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Probe Oligo Molecule (No Molecular Weight)" <> $SessionUUID],
        Model[Molecule, Oligomer, "ExperimentDigitalPCR test Primer Oligo Molecule (No Molecular Weight)" <> $SessionUUID],

        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 2 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 3 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 4 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample without fluorescence" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample with multiple fluorophores" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 1 model sample (Deprecated)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes (Deprecated)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test target assay model" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer set model" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test model sample with primers and probes" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 2 model sample (Low Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Low Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Concentration)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Conc, No MW)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Conc, No MW)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe 1 model sample (Mass Percent)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test primer 2 model sample (Mass Percent)" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR test probe model sample with incompatible fluorophore" <> $SessionUUID],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes without Concentration" <> $SessionUUID],
        Model[Sample, "ExperimentDigitalPCR 1x dilute passive well buffer model" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample 1" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 2" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer 1 sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer 1 sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer 2 sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer 2 sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe 1 sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe 2 sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test target assay sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer set sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample with primers and probes" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer large volume" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test discarded sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded primer sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded primer sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test discarded sample with primers and probes" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test deprecated model sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test deprecated model primer sample forward" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test deprecated model primer sample reverse" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test deprecated model sample with primers and probes" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample with primers and probes in cartridge unfilled" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample 1 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 2 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 3 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 4 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 5 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 6 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 7 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 8 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 9 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 10 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 11 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 12 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 13 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 14 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 15 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 16 with primers and probes in cartridge" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample 17 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 18 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 19 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 20 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 21 with primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 1" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 2" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 3" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 4" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 5" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 6" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 7" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 8" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 9" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 10" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR passive well buffer sample 11" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample 1 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 2 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 3 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 4 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 5 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 6 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 7 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 8 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 9 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 10 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 11 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 12 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 13 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 14 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 15 without primers and probes in cartridge" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample 16 without primers and probes in cartridge" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test sample in 2mL tube" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test sample in 50mL tube" <> $SessionUUID],

        Object[Sample, "ExperimentDigitalPCR test model-less sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test solid sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe without fluorescence" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe with multiple fluorophores" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe with low concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer forward with low concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer reverse with low concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe sample with mass concentration, no MW" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass concentration, no MW" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass concentration, no MW" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe sample with mass percent" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer forward sample with mass percent" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test primer reverse sample with mass percent" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR test probe with incompatible fluorophore" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Supermix for Probes Sample without Concentration" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes buffer sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes enzyme sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR One-Step RT-ddPCR Advanced Kit for Probes dtt sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Multiplex Supermix sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Supermix for Probes sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Supermix for Probes (No dUTP) sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Supermix for Residual DNA Quantification sample" <> $SessionUUID],
        Object[Sample, "ExperimentDigitalPCR ddPCR Buffer Control for Probes sample" <> $SessionUUID],

        If[DatabaseMemberQ[Object[Protocol, DigitalPCR, "ExperimentDigitalPCR test protocol" <> $SessionUUID]],
          Download[Object[Protocol, DigitalPCR, "ExperimentDigitalPCR test protocol" <> $SessionUUID], {Object, SubprotocolRequiredResources[Object], ProcedureLog[Object]}]
        ]
      }], ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];
  },
  SetUp :> ($CreatedObjects = {}),
  TearDown :> (
    EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
    (* Cleanse $CreatedObjects *)
    Unset[$CreatedObjects];
  ),
  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $ddPCRNoMultiplex = False,
    $AllowPublicObjects = True
  },
  Parallel -> True,
  HardwareConfiguration -> HighRAM,
  NumberOfParallelThreads -> 8
];


(* ::Subsection::Closed:: *)
(*ExperimentDigitalPCROptions*)


DefineTests[ExperimentDigitalPCROptions,
  {
    Example[{Basic, "Returns the options in table form given a sample, a pair of primers, and a probe:"},
      ExperimentDigitalPCROptions[
        {Object[Sample, "ExperimentDigitalPCROptions test sample 1"]},
        {{{Object[Sample, "ExperimentDigitalPCROptions test primer 1 sample forward"], Object[Sample, "ExperimentDigitalPCROptions test primer 1 sample reverse"]}}},
        {{Object[Sample, "ExperimentDigitalPCROptions test probe 1 sample"]}}
      ],
      _Grid
    ],
    Example[{Basic, "Returns the options in table form given a sample:"},
      ExperimentDigitalPCROptions[
        {Object[Sample, "ExperimentDigitalPCROptions test sample with primers and probes"]}
      ],
      _Grid
    ],
    Example[{Basic, "Returns the options in table form given a prepared plate:"},
      ExperimentDigitalPCROptions[
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]
      ],
      _Grid
    ],
    Example[{Options, OutputFormat, "If OutputFormat -> List, returns the options as a list of rules:"},
      ExperimentDigitalPCROptions[
        {Object[Sample, "ExperimentDigitalPCROptions test sample with primers and probes"]},
        OutputFormat -> List
      ],
      {_Rule..}
    ]
  },

  SymbolSetUp :> {
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = Cases[Flatten[{
        Object[Container, Plate, "ExperimentDigitalPCROptions test 96-well PCR plate 1"],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions fake resource cartridge 1"],
        Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"],
        Object[Item, PlateSeal, "ExperimentDigitalPCROptions fake foil resource"],

        Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Probe Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Primer Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Primer Oligo Molecule 2"],

        Model[Sample, "ExperimentDigitalPCROptions test probe 1 model sample"],
        Model[Sample, "ExperimentDigitalPCROptions test primer 1 model sample"],
        Model[Sample, "ExperimentDigitalPCROptions test model sample with primers and probes"],
        Model[Sample, "ExperimentDigitalPCROptions 1x dilute passive well buffer model"],

        Object[Sample, "ExperimentDigitalPCROptions test sample 1"],
        Object[Sample, "ExperimentDigitalPCROptions test primer 1 sample forward"],
        Object[Sample, "ExperimentDigitalPCROptions test primer 1 sample reverse"],
        Object[Sample, "ExperimentDigitalPCROptions test probe 1 sample"],
        Object[Sample, "ExperimentDigitalPCROptions test sample with primers and probes"],

        Object[Sample, "ExperimentDigitalPCROptions test sample 1 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions test sample 2 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions test sample 3 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions test sample 4 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions test sample 5 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 1"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 2"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 3"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 4"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 5"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 6"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 7"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 8"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 9"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 10"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 11"],

        Object[Sample, "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes buffer sample"],
        Object[Sample, "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes enzyme sample"],
        Object[Sample, "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes dtt sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Multiplex Supermix sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Supermix for Probes sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Supermix for Probes (No dUTP) sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Supermix for Residual DNA Quantification sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Buffer Control for Probes sample"]
      }], ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];

    (*Make some empty test container objects*)
    Upload[{
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ExperimentDigitalPCROptions test 96-well PCR plate 1",
        DeveloperObject->True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer",
        DeveloperObject->True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCROptions fake resource cartridge 1",
        Status -> Available,
        DeveloperObject->True,
        Site -> Link[$Site]
      |>
    }];

    (* Create Model[Molecule]s for primers and fluorescent probes *)
    oligoPackets = UploadOligomer[
      {
        "ExperimentDigitalPCROptions test Probe Oligo Molecule 1", (*FAM*)
        "ExperimentDigitalPCROptions test Primer Oligo Molecule 1",
        "ExperimentDigitalPCROptions test Primer Oligo Molecule 2"
      },
      Molecule -> {
        Strand[DNA["CAGCGTGGTTACATACCTGG"]],
        Strand[DNA["CAGAGTGGTTACATACCTGG"]],
        Strand[DNA["GTCTCACCAATGTATGGACC"]]
      },
      PolymerType -> DNA,
      MSDSFile -> NotApplicable,
      IncompatibleMaterials -> ConstantArray[{None}, 3],
      State -> Liquid,
      BiosafetyLevel -> "BSL-1",
      Upload -> False
    ];

    (* UploadOligomer doesn't support assignment of fluorophore-related fields, so update with that information *)
    probeMoleculeUpdates = With[
      {
        probeMolec1 = Lookup[oligoPackets[[1]], Object]
      },
      {
        <|
          Object -> probeMolec1,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> 495 Nanometer,
          Replace[FluorescenceEmissionMaximums] -> 517 Nanometer,
          Replace[DetectionLabels] -> Link[Model[Molecule, "id:9RdZXv1oADYx"]], (*FAM*)
          DeveloperObject -> True
        |>
      }
    ];

    (* Upload the probe identity models and their updates *)
    Upload[Join[oligoPackets, probeMoleculeUpdates]];

    (*Make some test sample models*)
    UploadSampleModel[
      {
        "ExperimentDigitalPCROptions test probe 1 model sample",

        "ExperimentDigitalPCROptions test primer 1 model sample",

        "ExperimentDigitalPCROptions test model sample with primers and probes",

        "ExperimentDigitalPCROptions 1x dilute passive well buffer model"
      },
      Composition ->
          {
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Probe Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Primer Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Primer Oligo Molecule 1"]},
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Primer Oligo Molecule 2"]},
              {5 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Probe Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {100 VolumePercent, Model[Molecule, "Water"]}
            }
          },
      IncompatibleMaterials -> ConstantArray[{None}, 4],
      Expires -> True,
      ShelfLife -> 2 Year,
      UnsealedShelfLife -> 90 Day,
      DefaultStorageCondition -> ConstantArray[Model[StorageCondition, "Refrigerator"], 4],
      MSDSFile -> NotApplicable,
      BiosafetyLevel -> "BSL-1",
      State -> Liquid
    ];

    (*Make some test sample objects in the test container objects*)
    UploadSample[
      {
        Model[Sample, "ExperimentDigitalPCROptions test primer 1 model sample"],

        Model[Sample, "ExperimentDigitalPCROptions test primer 1 model sample"],
        Model[Sample, "ExperimentDigitalPCROptions test primer 1 model sample"],

        Model[Sample, "ExperimentDigitalPCROptions test probe 1 model sample"],

        Model[Sample, "ExperimentDigitalPCROptions test model sample with primers and probes"]
      },
      {
        {"A1", Object[Container, Plate, "ExperimentDigitalPCROptions test 96-well PCR plate 1"]},

        {"A2", Object[Container, Plate, "ExperimentDigitalPCROptions test 96-well PCR plate 1"]},
        {"A3", Object[Container, Plate, "ExperimentDigitalPCROptions test 96-well PCR plate 1"]},

        {"A4", Object[Container, Plate, "ExperimentDigitalPCROptions test 96-well PCR plate 1"]},

        {"A5", Object[Container, Plate, "ExperimentDigitalPCROptions test 96-well PCR plate 1"]}
      },
      Name ->
          {
            "ExperimentDigitalPCROptions test sample 1",

            "ExperimentDigitalPCROptions test primer 1 sample forward",
            "ExperimentDigitalPCROptions test primer 1 sample reverse",

            "ExperimentDigitalPCROptions test probe 1 sample",

            "ExperimentDigitalPCROptions test sample with primers and probes"
          },
      InitialAmount -> ConstantArray[0.5 Milliliter, 5]
    ];

    (* Make a prepared plate with prepared samples in active wells and passive buffer samples in passive wells *)
    UploadSample[
      Join[
        ConstantArray[Model[Sample, "ExperimentDigitalPCROptions test model sample with primers and probes"], 5],
        ConstantArray[Model[Sample, "ExperimentDigitalPCROptions 1x dilute passive well buffer model"], 11]
      ],
      {
        {"A1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"B1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"C1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"D1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"E1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"F1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"G1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"H1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"A2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"B2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"C2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"D2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"E2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"F2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"G2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]},
        {"H2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"]}
      },
      Name -> {
        "ExperimentDigitalPCROptions test sample 1 with primers and probes in cartridge",
        "ExperimentDigitalPCROptions test sample 2 with primers and probes in cartridge",
        "ExperimentDigitalPCROptions test sample 3 with primers and probes in cartridge",
        "ExperimentDigitalPCROptions test sample 4 with primers and probes in cartridge",
        "ExperimentDigitalPCROptions test sample 5 with primers and probes in cartridge",
        "ExperimentDigitalPCROptions passive well buffer sample 1",
        "ExperimentDigitalPCROptions passive well buffer sample 2",
        "ExperimentDigitalPCROptions passive well buffer sample 3",
        "ExperimentDigitalPCROptions passive well buffer sample 4",
        "ExperimentDigitalPCROptions passive well buffer sample 5",
        "ExperimentDigitalPCROptions passive well buffer sample 6",
        "ExperimentDigitalPCROptions passive well buffer sample 7",
        "ExperimentDigitalPCROptions passive well buffer sample 8",
        "ExperimentDigitalPCROptions passive well buffer sample 9",
        "ExperimentDigitalPCROptions passive well buffer sample 10",
        "ExperimentDigitalPCROptions passive well buffer sample 11"
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 16]
    ];

    Upload[
      (* Make a plate to hold master mix samples that can be checked for fulfillment *)
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ExperimentDigitalPCROptions test plate for buffers and diluents",
        DeveloperObject->True,
        Site -> Link[$Site]
      |>
    ];

    (* Make a dummy master-mix samples for each relevant model for resource picking *)
    UploadSample[
      {
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, RT enzyme"],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, DTT"],
        Model[Sample, "Bio-Rad ddPCR Multiplex Supermix"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes (No dUTP)"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Residual DNA Quantification"],
        Model[Sample, "Bio-Rad ddPCR Buffer Control for Probes"]
      },
      {
        {"A1", Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"]},
        {"A2", Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"]},
        {"A3", Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"]},
        {"A4", Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"]},
        {"A5", Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"]},
        {"A6", Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"]},
        {"A7", Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"]},
        {"A8", Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"]}
      },
      Name -> {
        "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes buffer sample",
        "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes enzyme sample",
        "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes dtt sample",
        "ExperimentDigitalPCROptions ddPCR Multiplex Supermix sample",
        "ExperimentDigitalPCROptions ddPCR Supermix for Probes sample",
        "ExperimentDigitalPCROptions ddPCR Supermix for Probes (No dUTP) sample",
        "ExperimentDigitalPCROptions ddPCR Supermix for Residual DNA Quantification sample",
        "ExperimentDigitalPCROptions ddPCR Buffer Control for Probes sample"
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 8]
    ];

    (* Upload fake DropletCartridge sealing foil object for resource picking *)
    Upload[
      <|
        Type -> Object[Item, PlateSeal],
        Model -> Link[Model[Item, PlateSeal, "GCR96 PCR Plate Seal, Pierceable Heat-Sealed Aluminum"], Objects],
        Name -> "ExperimentDigitalPCROptions fake foil resource",
        Count -> 100,
        Status -> Available
      |>
    ];

    (*Gather all the test objects and models created in SymbolSetUp*)
    allObjects = Flatten[{containerSampleObjects, protocolObjects}];

    allObjects = {
      Object[Container, Plate, "ExperimentDigitalPCROptions test 96-well PCR plate 1"],
      Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"],
      Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"],

      Model[Sample, "ExperimentDigitalPCROptions test probe 1 model sample"],
      Model[Sample, "ExperimentDigitalPCROptions test primer 1 model sample"],
      Model[Sample, "ExperimentDigitalPCROptions test model sample with primers and probes"],
      Model[Sample, "ExperimentDigitalPCROptions 1x dilute passive well buffer model"],

      Object[Sample, "ExperimentDigitalPCROptions test sample 1"],
      Object[Sample, "ExperimentDigitalPCROptions test primer 1 sample forward"],
      Object[Sample, "ExperimentDigitalPCROptions test primer 1 sample reverse"],
      Object[Sample, "ExperimentDigitalPCROptions test probe 1 sample"],
      Object[Sample, "ExperimentDigitalPCROptions test sample with primers and probes"],

      Object[Sample, "ExperimentDigitalPCROptions test sample 1 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCROptions test sample 2 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCROptions test sample 3 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCROptions test sample 4 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCROptions test sample 5 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 1"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 2"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 3"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 4"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 5"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 6"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 7"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 8"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 9"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 10"],
      Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 11"]
    };

    (*Make all the test objects and models developer objects*)
    Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
  },

  SymbolTearDown :> {
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = Cases[Flatten[{
        Object[Container, Plate, "ExperimentDigitalPCROptions test 96-well PCR plate 1"],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions test prepared plate with samples & passive well buffer"],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCROptions fake resource cartridge 1"],
        Object[Container, Plate, "ExperimentDigitalPCROptions test plate for buffers and diluents"],
        Object[Item, PlateSeal, "ExperimentDigitalPCROptions fake foil resource"],

        Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Probe Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Primer Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ExperimentDigitalPCROptions test Primer Oligo Molecule 2"],

        Model[Sample, "ExperimentDigitalPCROptions test probe 1 model sample"],
        Model[Sample, "ExperimentDigitalPCROptions test primer 1 model sample"],
        Model[Sample, "ExperimentDigitalPCROptions test model sample with primers and probes"],
        Model[Sample, "ExperimentDigitalPCROptions 1x dilute passive well buffer model"],

        Object[Sample, "ExperimentDigitalPCROptions test sample 1"],
        Object[Sample, "ExperimentDigitalPCROptions test primer 1 sample forward"],
        Object[Sample, "ExperimentDigitalPCROptions test primer 1 sample reverse"],
        Object[Sample, "ExperimentDigitalPCROptions test probe 1 sample"],
        Object[Sample, "ExperimentDigitalPCROptions test sample with primers and probes"],

        Object[Sample, "ExperimentDigitalPCROptions test sample 1 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions test sample 2 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions test sample 3 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions test sample 4 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions test sample 5 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 1"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 2"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 3"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 4"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 5"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 6"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 7"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 8"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 9"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 10"],
        Object[Sample, "ExperimentDigitalPCROptions passive well buffer sample 11"],

        Object[Sample, "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes buffer sample"],
        Object[Sample, "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes enzyme sample"],
        Object[Sample, "ExperimentDigitalPCROptions One-Step RT-ddPCR Advanced Kit for Probes dtt sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Multiplex Supermix sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Supermix for Probes sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Supermix for Probes (No dUTP) sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Supermix for Residual DNA Quantification sample"],
        Object[Sample, "ExperimentDigitalPCROptions ddPCR Buffer Control for Probes sample"]
      }], ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];
  },

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $ddPCRNoMultiplex = False,
    $AllowPublicObjects = True
  }
];


(* ::Subsection::Closed:: *)
(*ExperimentDigitalPCRPreview*)


DefineTests[ExperimentDigitalPCRPreview,
  {
    Example[{Basic, "Returns 'Null' given a sample, a pair of primers, and a probe:"},
      ExperimentDigitalPCRPreview[
        {Object[Sample, "ExperimentDigitalPCRPreview test sample 1"]},
        {{{Object[Sample, "ExperimentDigitalPCRPreview test primer 1 sample forward"], Object[Sample, "ExperimentDigitalPCRPreview test primer 1 sample reverse"]}}},
        {{Object[Sample, "ExperimentDigitalPCRPreview test probe 1 sample"]}}
      ],
      Null
    ],
    Example[{Basic, "Returns 'Null' given a sample:"},
      ExperimentDigitalPCRPreview[
        {Object[Sample, "ExperimentDigitalPCRPreview test sample with primers and probes"]}
      ],
      Null
    ],
    Example[{Basic, "Returns 'Null' given a prepared plate:"},
      ExperimentDigitalPCRPreview[
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]
      ],
      Null
    ]
  },

  SymbolSetUp :> {
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = Cases[Flatten[{
        Object[Container, Plate, "ExperimentDigitalPCRPreview test 96-well PCR plate 1"],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview fake resource cartridge 1"],
        Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"],
        Object[Item, PlateSeal, "ExperimentDigitalPCRPreview fake foil resource"],

        Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Probe Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Primer Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Primer Oligo Molecule 2"],

        Model[Sample, "ExperimentDigitalPCRPreview test probe 1 model sample"],
        Model[Sample, "ExperimentDigitalPCRPreview test primer 1 model sample"],
        Model[Sample, "ExperimentDigitalPCRPreview test model sample with primers and probes"],
        Model[Sample, "ExperimentDigitalPCRPreview 1x dilute passive well buffer model"],

        Object[Sample, "ExperimentDigitalPCRPreview test sample 1"],
        Object[Sample, "ExperimentDigitalPCRPreview test primer 1 sample forward"],
        Object[Sample, "ExperimentDigitalPCRPreview test primer 1 sample reverse"],
        Object[Sample, "ExperimentDigitalPCRPreview test probe 1 sample"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample with primers and probes"],

        Object[Sample, "ExperimentDigitalPCRPreview test sample 1 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample 2 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample 3 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample 4 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample 5 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 1"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 2"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 3"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 4"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 5"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 6"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 7"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 8"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 9"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 10"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 11"],

        Object[Sample, "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes buffer sample"],
        Object[Sample, "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes enzyme sample"],
        Object[Sample, "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes dtt sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Multiplex Supermix sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Supermix for Probes sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Supermix for Probes (No dUTP) sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Supermix for Residual DNA Quantification sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Buffer Control for Probes sample"]
      }], ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];

    (*Make some empty test container objects*)
    Upload[{
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ExperimentDigitalPCRPreview test 96-well PCR plate 1",
        DeveloperObject->True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer",
        DeveloperObject->True,
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ExperimentDigitalPCRPreview fake resource cartridge 1",
        Status -> Available,
        DeveloperObject->True,
        Site -> Link[$Site]
      |>
    }];

    (* Create Model[Molecule]s for primers and fluorescent probes *)
    oligoPackets = UploadOligomer[
      {
        "ExperimentDigitalPCRPreview test Probe Oligo Molecule 1", (*FAM*)
        "ExperimentDigitalPCRPreview test Primer Oligo Molecule 1",
        "ExperimentDigitalPCRPreview test Primer Oligo Molecule 2"
      },
      Molecule -> {
        Strand[DNA["CAGCGTGGTTACATACCTGG"]],
        Strand[DNA["CAGAGTGGTTACATACCTGG"]],
        Strand[DNA["GTCTCACCAATGTATGGACC"]]
      },
      PolymerType -> DNA,
      MSDSFile -> NotApplicable,
      IncompatibleMaterials -> ConstantArray[{None}, 3],
      State -> Liquid,
      BiosafetyLevel -> "BSL-1",
      Upload -> False
    ];

    (* UploadOligomer doesn't support assignment of fluorophore-related fields, so update with that information *)
    probeMoleculeUpdates = With[
      {
        probeMolec1 = Lookup[oligoPackets[[1]], Object]
      },
      {
        <|
          Object -> probeMolec1,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> 495 Nanometer,
          Replace[FluorescenceEmissionMaximums] -> 517 Nanometer,
          Replace[DetectionLabels] -> Link[Model[Molecule, "id:9RdZXv1oADYx"]], (*FAM*)
          DeveloperObject -> True
        |>
      }
    ];

    (* Upload the probe identity models and their updates *)
    Upload[Join[oligoPackets, probeMoleculeUpdates]];

    (*Make some test sample models*)
    UploadSampleModel[
      {
        "ExperimentDigitalPCRPreview test probe 1 model sample",

        "ExperimentDigitalPCRPreview test primer 1 model sample",

        "ExperimentDigitalPCRPreview test model sample with primers and probes",

        "ExperimentDigitalPCRPreview 1x dilute passive well buffer model"
      },
      Composition ->
          {
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Probe Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Primer Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Primer Oligo Molecule 1"]},
              {10 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Primer Oligo Molecule 2"]},
              {5 Micromolar, Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Probe Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {100 VolumePercent, Model[Molecule, "Water"]}
            }
          },
      IncompatibleMaterials -> ConstantArray[{None}, 4],
      Expires -> True,
      ShelfLife -> 2 Year,
      UnsealedShelfLife -> 90 Day,
      DefaultStorageCondition -> ConstantArray[Model[StorageCondition, "Refrigerator"], 4],
      MSDSFile -> NotApplicable,
      BiosafetyLevel -> "BSL-1",
      State -> Liquid
    ];

    (*Make some test sample objects in the test container objects*)
    UploadSample[
      {
        Model[Sample, "ExperimentDigitalPCRPreview test primer 1 model sample"],

        Model[Sample, "ExperimentDigitalPCRPreview test primer 1 model sample"],
        Model[Sample, "ExperimentDigitalPCRPreview test primer 1 model sample"],

        Model[Sample, "ExperimentDigitalPCRPreview test probe 1 model sample"],

        Model[Sample, "ExperimentDigitalPCRPreview test model sample with primers and probes"]
      },
      {
        {"A1", Object[Container, Plate, "ExperimentDigitalPCRPreview test 96-well PCR plate 1"]},

        {"A2", Object[Container, Plate, "ExperimentDigitalPCRPreview test 96-well PCR plate 1"]},
        {"A3", Object[Container, Plate, "ExperimentDigitalPCRPreview test 96-well PCR plate 1"]},

        {"A4", Object[Container, Plate, "ExperimentDigitalPCRPreview test 96-well PCR plate 1"]},

        {"A5", Object[Container, Plate, "ExperimentDigitalPCRPreview test 96-well PCR plate 1"]}
      },
      Name ->
          {
            "ExperimentDigitalPCRPreview test sample 1",

            "ExperimentDigitalPCRPreview test primer 1 sample forward",
            "ExperimentDigitalPCRPreview test primer 1 sample reverse",

            "ExperimentDigitalPCRPreview test probe 1 sample",

            "ExperimentDigitalPCRPreview test sample with primers and probes"
          },
      InitialAmount -> ConstantArray[0.5 Milliliter, 5]
    ];

    (* Make a prepared plate with prepared samples in active wells and passive buffer samples in passive wells *)
    UploadSample[
      Join[
        ConstantArray[Model[Sample, "ExperimentDigitalPCRPreview test model sample with primers and probes"], 5],
        ConstantArray[Model[Sample, "ExperimentDigitalPCRPreview 1x dilute passive well buffer model"], 11]
      ],
      {
        {"A1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"B1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"C1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"D1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"E1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"F1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"G1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"H1", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"A2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"B2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"C2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"D2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"E2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"F2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"G2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]},
        {"H2", Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"]}
      },
      Name -> {
        "ExperimentDigitalPCRPreview test sample 1 with primers and probes in cartridge",
        "ExperimentDigitalPCRPreview test sample 2 with primers and probes in cartridge",
        "ExperimentDigitalPCRPreview test sample 3 with primers and probes in cartridge",
        "ExperimentDigitalPCRPreview test sample 4 with primers and probes in cartridge",
        "ExperimentDigitalPCRPreview test sample 5 with primers and probes in cartridge",
        "ExperimentDigitalPCRPreview passive well buffer sample 1",
        "ExperimentDigitalPCRPreview passive well buffer sample 2",
        "ExperimentDigitalPCRPreview passive well buffer sample 3",
        "ExperimentDigitalPCRPreview passive well buffer sample 4",
        "ExperimentDigitalPCRPreview passive well buffer sample 5",
        "ExperimentDigitalPCRPreview passive well buffer sample 6",
        "ExperimentDigitalPCRPreview passive well buffer sample 7",
        "ExperimentDigitalPCRPreview passive well buffer sample 8",
        "ExperimentDigitalPCRPreview passive well buffer sample 9",
        "ExperimentDigitalPCRPreview passive well buffer sample 10",
        "ExperimentDigitalPCRPreview passive well buffer sample 11"
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 16]
    ];

    Upload[
      (* Make a plate to hold master mix samples that can be checked for fulfillment  *)
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ExperimentDigitalPCRPreview test plate for buffers and diluents"
      |>
    ];

    (* Make a dummy master-mix samples for each relevant model for resource picking *)
    UploadSample[
      {
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, RT enzyme"],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, DTT"],
        Model[Sample, "Bio-Rad ddPCR Multiplex Supermix"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes (No dUTP)"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Residual DNA Quantification"],
        Model[Sample, "Bio-Rad ddPCR Buffer Control for Probes"]
      },
      {
        {"A1", Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"]},
        {"A2", Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"]},
        {"A3", Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"]},
        {"A4", Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"]},
        {"A5", Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"]},
        {"A6", Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"]},
        {"A7", Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"]},
        {"A8", Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"]}
      },
      Name -> {
        "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes buffer sample",
        "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes enzyme sample",
        "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes dtt sample",
        "ExperimentDigitalPCRPreview ddPCR Multiplex Supermix sample",
        "ExperimentDigitalPCRPreview ddPCR Supermix for Probes sample",
        "ExperimentDigitalPCRPreview ddPCR Supermix for Probes (No dUTP) sample",
        "ExperimentDigitalPCRPreview ddPCR Supermix for Residual DNA Quantification sample",
        "ExperimentDigitalPCRPreview ddPCR Buffer Control for Probes sample"
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 8]
    ];

    (* Upload fake DropletCartridge sealing foil object for resource picking *)
    Upload[
      <|
        Type -> Object[Item, PlateSeal],
        Model -> Link[Model[Item, PlateSeal, "GCR96 PCR Plate Seal, Pierceable Heat-Sealed Aluminum"], Objects],
        Name -> "ExperimentDigitalPCRPreview fake foil resource",
        Count -> 100,
        Status -> Available
      |>
    ];

    (*Gather all the test objects and models created in SymbolSetUp*)
    allObjects = Flatten[{containerSampleObjects, protocolObjects}];

    allObjects = {
      Object[Container, Plate, "ExperimentDigitalPCRPreview test 96-well PCR plate 1"],
      Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"],
      Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"],

      Model[Sample, "ExperimentDigitalPCRPreview test probe 1 model sample"],
      Model[Sample, "ExperimentDigitalPCRPreview test primer 1 model sample"],
      Model[Sample, "ExperimentDigitalPCRPreview test model sample with primers and probes"],
      Model[Sample, "ExperimentDigitalPCRPreview 1x dilute passive well buffer model"],

      Object[Sample, "ExperimentDigitalPCRPreview test sample 1"],
      Object[Sample, "ExperimentDigitalPCRPreview test primer 1 sample forward"],
      Object[Sample, "ExperimentDigitalPCRPreview test primer 1 sample reverse"],
      Object[Sample, "ExperimentDigitalPCRPreview test probe 1 sample"],
      Object[Sample, "ExperimentDigitalPCRPreview test sample with primers and probes"],

      Object[Sample, "ExperimentDigitalPCRPreview test sample 1 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCRPreview test sample 2 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCRPreview test sample 3 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCRPreview test sample 4 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCRPreview test sample 5 with primers and probes in cartridge"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 1"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 2"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 3"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 4"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 5"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 6"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 7"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 8"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 9"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 10"],
      Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 11"]
    };

    (*Make all the test objects and models developer objects*)
    Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
  },

  SymbolTearDown :> {
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = Cases[Flatten[{
        Object[Container, Plate, "ExperimentDigitalPCRPreview test 96-well PCR plate 1"],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview test prepared plate with samples & passive well buffer"],
        Object[Container, Plate, DropletCartridge, "ExperimentDigitalPCRPreview fake resource cartridge 1"],
        Object[Container, Plate, "ExperimentDigitalPCRPreview test plate for buffers and diluents"],
        Object[Item, PlateSeal, "ExperimentDigitalPCRPreview fake foil resource"],

        Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Probe Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Primer Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ExperimentDigitalPCRPreview test Primer Oligo Molecule 2"],

        Model[Sample, "ExperimentDigitalPCRPreview test probe 1 model sample"],
        Model[Sample, "ExperimentDigitalPCRPreview test primer 1 model sample"],
        Model[Sample, "ExperimentDigitalPCRPreview test model sample with primers and probes"],
        Model[Sample, "ExperimentDigitalPCRPreview 1x dilute passive well buffer model"],

        Object[Sample, "ExperimentDigitalPCRPreview test sample 1"],
        Object[Sample, "ExperimentDigitalPCRPreview test primer 1 sample forward"],
        Object[Sample, "ExperimentDigitalPCRPreview test primer 1 sample reverse"],
        Object[Sample, "ExperimentDigitalPCRPreview test probe 1 sample"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample with primers and probes"],

        Object[Sample, "ExperimentDigitalPCRPreview test sample 1 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample 2 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample 3 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample 4 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview test sample 5 with primers and probes in cartridge"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 1"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 2"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 3"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 4"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 5"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 6"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 7"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 8"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 9"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 10"],
        Object[Sample, "ExperimentDigitalPCRPreview passive well buffer sample 11"],

        Object[Sample, "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes buffer sample"],
        Object[Sample, "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes enzyme sample"],
        Object[Sample, "ExperimentDigitalPCRPreview One-Step RT-ddPCR Advanced Kit for Probes dtt sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Multiplex Supermix sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Supermix for Probes sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Supermix for Probes (No dUTP) sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Supermix for Residual DNA Quantification sample"],
        Object[Sample, "ExperimentDigitalPCRPreview ddPCR Buffer Control for Probes sample"]
      }], ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];
  },

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $ddPCRNoMultiplex = False,
    $AllowPublicObjects = True
  }
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDigitalPCRQ*)


DefineTests[ValidExperimentDigitalPCRQ,
  {
    Example[{Basic, "Returns a Boolean indicating the validity of a DigitalPCR experimental setup on a sample, a primer pair and a probe:"},
      ValidExperimentDigitalPCRQ[
        {Object[Sample, "ValidExperimentDigitalPCRQ test sample 1"]},
        {{{Object[Sample, "ValidExperimentDigitalPCRQ test primer 1 sample forward"], Object[Sample, "ValidExperimentDigitalPCRQ test primer 1 sample reverse"]}}},
        {{Object[Sample, "ValidExperimentDigitalPCRQ test probe 1 sample"]}}
      ],
      True
    ],
    Example[{Basic, "Returns a Boolean indicating the validity of a DigitalPCR experimental setup on a sample:"},
      ValidExperimentDigitalPCRQ[
        {Object[Sample, "ValidExperimentDigitalPCRQ test sample with primers and probes"]}
      ],
      True
    ],
    Example[{Basic, "Returns a Boolean indicating the validity of a DigitalPCR experimental setup on a prepared plate:"},
      ValidExperimentDigitalPCRQ[
        Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]
      ],
      True
    ],
    Example[{Options, Verbose, "If Verbose -> True, returns the passing and failing tests:"},
      ValidExperimentDigitalPCRQ[
        {Object[Sample, "ValidExperimentDigitalPCRQ test sample with primers and probes"]},
        Verbose -> True
      ],
      True
    ],
    Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
      ValidExperimentDigitalPCRQ[
        {Object[Sample, "ValidExperimentDigitalPCRQ test sample with primers and probes"]},
        OutputFormat -> TestSummary
      ],
      _EmeraldTestSummary
    ]
  },

  SymbolSetUp :> {
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = Cases[Flatten[{
        Object[Container, Plate, "ValidExperimentDigitalPCRQ test 96-well PCR plate 1"],
        Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"],
        Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ fake resource cartridge 1"],
        Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"],
        Object[Item, PlateSeal, "ValidExperimentDigitalPCRQ fake foil resource"],

        Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Probe Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 2"],

        Model[Sample, "ValidExperimentDigitalPCRQ test probe 1 model sample"],
        Model[Sample, "ValidExperimentDigitalPCRQ test primer 1 model sample"],
        Model[Sample, "ValidExperimentDigitalPCRQ test model sample with primers and probes"],
        Model[Sample, "ValidExperimentDigitalPCRQ 1x dilute passive well buffer model"],

        Object[Sample, "ValidExperimentDigitalPCRQ test sample 1"],
        Object[Sample, "ValidExperimentDigitalPCRQ test primer 1 sample forward"],
        Object[Sample, "ValidExperimentDigitalPCRQ test primer 1 sample reverse"],
        Object[Sample, "ValidExperimentDigitalPCRQ test probe 1 sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample with primers and probes"],

        Object[Sample, "ValidExperimentDigitalPCRQ test sample 1 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample 2 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample 3 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample 4 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample 5 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 1"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 2"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 3"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 4"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 5"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 6"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 7"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 8"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 9"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 10"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 11"],

        Object[Sample, "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes buffer sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes enzyme sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes dtt sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Multiplex Supermix sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Supermix for Probes sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Supermix for Probes (No dUTP) sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Supermix for Residual DNA Quantification sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Buffer Control for Probes sample"]
      }], ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];

    (*Make some empty test container objects*)
    Upload[{
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ValidExperimentDigitalPCRQ test 96-well PCR plate 1",
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer",
        Site -> Link[$Site]
      |>,
      <|
        Type -> Object[Container, Plate, DropletCartridge],
        Model -> Link[Model[Container, Plate, DropletCartridge, "Bio-Rad GCR96 Digital PCR Cartridge"], Objects],
        Name -> "ValidExperimentDigitalPCRQ fake resource cartridge 1",
        Status -> Available,
        Site -> Link[$Site]
      |>
    }];

    (* Create Model[Molecule]s for primers and fluorescent probes *)
    oligoPackets = UploadOligomer[
      {
        "ValidExperimentDigitalPCRQ test Probe Oligo Molecule 1", (*FAM*)
        "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 1",
        "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 2"
      },
      Molecule -> {
        Strand[DNA["CAGCGTGGTTACATACCTGG"]],
        Strand[DNA["CAGAGTGGTTACATACCTGG"]],
        Strand[DNA["GTCTCACCAATGTATGGACC"]]
      },
      PolymerType -> DNA,
      MSDSFile -> NotApplicable,
      IncompatibleMaterials -> ConstantArray[{None}, 3],
      State -> Liquid,
      BiosafetyLevel -> "BSL-1",
      Upload -> False
    ];

    (* UploadOligomer doesn't support assignment of fluorophore-related fields, so update with that information *)
    probeMoleculeUpdates = With[
      {
        probeMolec1 = Lookup[oligoPackets[[1]], Object]
      },
      {
        <|
          Object -> probeMolec1,
          Fluorescent -> True,
          Replace[FluorescenceExcitationMaximums] -> 495 Nanometer,
          Replace[FluorescenceEmissionMaximums] -> 517 Nanometer,
          Replace[DetectionLabels] -> Link[Model[Molecule, "id:9RdZXv1oADYx"]], (*FAM*)
          DeveloperObject -> True
        |>
      }
    ];

    (* Upload the probe identity models and their updates *)
    Upload[Join[oligoPackets, probeMoleculeUpdates]];

    (*Make some test sample models*)
    UploadSampleModel[
      {
        "ValidExperimentDigitalPCRQ test probe 1 model sample",

        "ValidExperimentDigitalPCRQ test primer 1 model sample",

        "ValidExperimentDigitalPCRQ test model sample with primers and probes",

        "ValidExperimentDigitalPCRQ 1x dilute passive well buffer model"
      },
      Composition ->
          {
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Probe Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {10 Micromolar, Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 1"]},
              {10 Micromolar, Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 2"]},
              {5 Micromolar, Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Probe Oligo Molecule 1"]},
              {100 VolumePercent, Model[Molecule, "Water"]}
            },
            {
              {100 VolumePercent, Model[Molecule, "Water"]}
            }
          },
      IncompatibleMaterials -> ConstantArray[{None}, 4],
      Expires -> True,
      ShelfLife -> 2 Year,
      UnsealedShelfLife -> 90 Day,
      DefaultStorageCondition -> ConstantArray[Model[StorageCondition, "Refrigerator"], 4],
      MSDSFile -> NotApplicable,
      BiosafetyLevel -> "BSL-1",
      State -> Liquid
    ];

    (*Make some test sample objects in the test container objects*)
    UploadSample[
      {
        Model[Sample, "ValidExperimentDigitalPCRQ test primer 1 model sample"],

        Model[Sample, "ValidExperimentDigitalPCRQ test primer 1 model sample"],
        Model[Sample, "ValidExperimentDigitalPCRQ test primer 1 model sample"],

        Model[Sample, "ValidExperimentDigitalPCRQ test probe 1 model sample"],

        Model[Sample, "ValidExperimentDigitalPCRQ test model sample with primers and probes"]
      },
      {
        {"A1", Object[Container, Plate, "ValidExperimentDigitalPCRQ test 96-well PCR plate 1"]},

        {"A2", Object[Container, Plate, "ValidExperimentDigitalPCRQ test 96-well PCR plate 1"]},
        {"A3", Object[Container, Plate, "ValidExperimentDigitalPCRQ test 96-well PCR plate 1"]},

        {"A4", Object[Container, Plate, "ValidExperimentDigitalPCRQ test 96-well PCR plate 1"]},

        {"A5", Object[Container, Plate, "ValidExperimentDigitalPCRQ test 96-well PCR plate 1"]}
      },
      Name ->
          {
            "ValidExperimentDigitalPCRQ test sample 1",

            "ValidExperimentDigitalPCRQ test primer 1 sample forward",
            "ValidExperimentDigitalPCRQ test primer 1 sample reverse",

            "ValidExperimentDigitalPCRQ test probe 1 sample",

            "ValidExperimentDigitalPCRQ test sample with primers and probes"
          },
      InitialAmount -> ConstantArray[0.5 Milliliter, 5]
    ];

    (* Make a prepared plate with prepared samples in active wells and passive buffer samples in passive wells *)
    UploadSample[
      Join[
        ConstantArray[Model[Sample, "ValidExperimentDigitalPCRQ test model sample with primers and probes"], 5],
        ConstantArray[Model[Sample, "ValidExperimentDigitalPCRQ 1x dilute passive well buffer model"], 11]
      ],
      {
        {"A1", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"B1", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"C1", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"D1", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"E1", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"F1", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"G1", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"H1", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"A2", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"B2", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"C2", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"D2", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"E2", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"F2", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"G2", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]},
        {"H2", Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"]}
      },
      Name -> {
        "ValidExperimentDigitalPCRQ test sample 1 with primers and probes in cartridge",
        "ValidExperimentDigitalPCRQ test sample 2 with primers and probes in cartridge",
        "ValidExperimentDigitalPCRQ test sample 3 with primers and probes in cartridge",
        "ValidExperimentDigitalPCRQ test sample 4 with primers and probes in cartridge",
        "ValidExperimentDigitalPCRQ test sample 5 with primers and probes in cartridge",
        "ValidExperimentDigitalPCRQ passive well buffer sample 1",
        "ValidExperimentDigitalPCRQ passive well buffer sample 2",
        "ValidExperimentDigitalPCRQ passive well buffer sample 3",
        "ValidExperimentDigitalPCRQ passive well buffer sample 4",
        "ValidExperimentDigitalPCRQ passive well buffer sample 5",
        "ValidExperimentDigitalPCRQ passive well buffer sample 6",
        "ValidExperimentDigitalPCRQ passive well buffer sample 7",
        "ValidExperimentDigitalPCRQ passive well buffer sample 8",
        "ValidExperimentDigitalPCRQ passive well buffer sample 9",
        "ValidExperimentDigitalPCRQ passive well buffer sample 10",
        "ValidExperimentDigitalPCRQ passive well buffer sample 11"
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 16]
    ];

    Upload[
      (* Make a plate to hold master mix samples that can be checked for fulfillment *)
      <|
        Type -> Object[Container, Plate],
        Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
        Name -> "ValidExperimentDigitalPCRQ test plate for buffers and diluents"
      |>
    ];

    (* Make a dummy master-mix samples for each relevant model for resource picking *)
    UploadSample[
      {
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, Buffer"],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, RT enzyme"],
        Model[Sample, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, DTT"],
        Model[Sample, "Bio-Rad ddPCR Multiplex Supermix"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Probes (No dUTP)"],
        Model[Sample, "Bio-Rad ddPCR Supermix for Residual DNA Quantification"],
        Model[Sample, "Bio-Rad ddPCR Buffer Control for Probes"]
      },
      {
        {"A1", Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"]},
        {"A2", Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"]},
        {"A3", Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"]},
        {"A4", Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"]},
        {"A5", Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"]},
        {"A6", Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"]},
        {"A7", Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"]},
        {"A8", Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"]}
      },
      Name -> {
        "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes buffer sample",
        "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes enzyme sample",
        "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes dtt sample",
        "ValidExperimentDigitalPCRQ ddPCR Multiplex Supermix sample",
        "ValidExperimentDigitalPCRQ ddPCR Supermix for Probes sample",
        "ValidExperimentDigitalPCRQ ddPCR Supermix for Probes (No dUTP) sample",
        "ValidExperimentDigitalPCRQ ddPCR Supermix for Residual DNA Quantification sample",
        "ValidExperimentDigitalPCRQ ddPCR Buffer Control for Probes sample"
      },
      InitialAmount -> ConstantArray[0.5 Milliliter, 8]
    ];

    (* Upload fake DropletCartridge sealing foil object for resource picking *)
    Upload[
      <|
        Type -> Object[Item, PlateSeal],
        Model -> Link[Model[Item, PlateSeal, "GCR96 PCR Plate Seal, Pierceable Heat-Sealed Aluminum"], Objects],
        Name -> "ValidExperimentDigitalPCRQ fake foil resource",
        Count -> 100,
        Status -> Available,
        Site -> Link[$Site]
      |>
    ];

    (*Gather all the test objects and models created in SymbolSetUp*)
    allObjects = Flatten[{containerSampleObjects, protocolObjects}];

    allObjects = {
      Object[Container, Plate, "ValidExperimentDigitalPCRQ test 96-well PCR plate 1"],
      Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"],
      Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"],

      Model[Sample, "ValidExperimentDigitalPCRQ test probe 1 model sample"],
      Model[Sample, "ValidExperimentDigitalPCRQ test primer 1 model sample"],
      Model[Sample, "ValidExperimentDigitalPCRQ test model sample with primers and probes"],
      Model[Sample, "ValidExperimentDigitalPCRQ 1x dilute passive well buffer model"],

      Object[Sample, "ValidExperimentDigitalPCRQ test sample 1"],
      Object[Sample, "ValidExperimentDigitalPCRQ test primer 1 sample forward"],
      Object[Sample, "ValidExperimentDigitalPCRQ test primer 1 sample reverse"],
      Object[Sample, "ValidExperimentDigitalPCRQ test probe 1 sample"],
      Object[Sample, "ValidExperimentDigitalPCRQ test sample with primers and probes"],

      Object[Sample, "ValidExperimentDigitalPCRQ test sample 1 with primers and probes in cartridge"],
      Object[Sample, "ValidExperimentDigitalPCRQ test sample 2 with primers and probes in cartridge"],
      Object[Sample, "ValidExperimentDigitalPCRQ test sample 3 with primers and probes in cartridge"],
      Object[Sample, "ValidExperimentDigitalPCRQ test sample 4 with primers and probes in cartridge"],
      Object[Sample, "ValidExperimentDigitalPCRQ test sample 5 with primers and probes in cartridge"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 1"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 2"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 3"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 4"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 5"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 6"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 7"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 8"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 9"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 10"],
      Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 11"]
    };

    (*Make all the test objects and models developer objects*)
    Upload[<|Object -> #, DeveloperObject -> True|>& /@ allObjects]
  },

  SymbolTearDown :> {
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{allObjects, existingObjects},

      (*Gather all the objects and models created in SymbolSetUp*)
      allObjects = Cases[Flatten[{
        Object[Container, Plate, "ValidExperimentDigitalPCRQ test 96-well PCR plate 1"],
        Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ test prepared plate with samples & passive well buffer"],
        Object[Container, Plate, DropletCartridge, "ValidExperimentDigitalPCRQ fake resource cartridge 1"],
        Object[Container, Plate, "ValidExperimentDigitalPCRQ test plate for buffers and diluents"],
        Object[Item, PlateSeal, "ValidExperimentDigitalPCRQ fake foil resource"],

        Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Probe Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 1"],
        Model[Molecule, Oligomer, "ValidExperimentDigitalPCRQ test Primer Oligo Molecule 2"],

        Model[Sample, "ValidExperimentDigitalPCRQ test probe 1 model sample"],
        Model[Sample, "ValidExperimentDigitalPCRQ test primer 1 model sample"],
        Model[Sample, "ValidExperimentDigitalPCRQ test model sample with primers and probes"],
        Model[Sample, "ValidExperimentDigitalPCRQ 1x dilute passive well buffer model"],

        Object[Sample, "ValidExperimentDigitalPCRQ test sample 1"],
        Object[Sample, "ValidExperimentDigitalPCRQ test primer 1 sample forward"],
        Object[Sample, "ValidExperimentDigitalPCRQ test primer 1 sample reverse"],
        Object[Sample, "ValidExperimentDigitalPCRQ test probe 1 sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample with primers and probes"],

        Object[Sample, "ValidExperimentDigitalPCRQ test sample 1 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample 2 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample 3 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample 4 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ test sample 5 with primers and probes in cartridge"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 1"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 2"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 3"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 4"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 5"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 6"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 7"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 8"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 9"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 10"],
        Object[Sample, "ValidExperimentDigitalPCRQ passive well buffer sample 11"],

        Object[Sample, "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes buffer sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes enzyme sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ One-Step RT-ddPCR Advanced Kit for Probes dtt sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Multiplex Supermix sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Supermix for Probes sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Supermix for Probes (No dUTP) sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Supermix for Residual DNA Quantification sample"],
        Object[Sample, "ValidExperimentDigitalPCRQ ddPCR Buffer Control for Probes sample"]
      }], ObjectP[]];

      (*Check whether the names we want to give below already exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase any test objects and models that we failed to erase in the last unit test*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
    ];
  },

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $ddPCRNoMultiplex = False,
    $AllowPublicObjects = True
  }
]
