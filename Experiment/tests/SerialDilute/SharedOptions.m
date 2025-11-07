(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* DilutionSharedOptions - Tests *)

DefineTests[ResolveDilutionSharedOptions,
  {
    Example[{Basic,"Resolve the options for diluting a given sample:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID]
      ],
      {_Rule..}
    ],
    Example[{Basic,"Resolve the options for a serial dilution of a given sample:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial
      ],
      {_Rule..}
    ],
    Example[{Basic,"Resolve the options for a linear dilution of a given sample:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Linear
      ],
      {_Rule..}
    ],
    Example[{Basic,"Resolve the options for a serial dilution of a given sample with multiple dilutions in the series:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 6
      ],
      {_Rule..}
    ],

    Example[{Additional,"Dilute with a ConcentratedBuffer instead of a Diluent:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Linear,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x PBS"]
      ],
      {_Rule..}
    ],

    Example[{Options,DilutionStrategy,"Specify whether future experimentation should be performed on the final output sample, or the entire dilution series:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        DilutionStrategy -> Series,
        NumberOfDilutions -> 6
      ];
      Lookup[options,DilutionStrategy],
      Series
    ],
    Example[{Options,DilutionStrategy,"Specify whether future experimentation should be performed on the final output sample, or the entire dilution series:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        DilutionStrategy -> Series,
        NumberOfDilutions -> 6
      ];
      Lookup[options,DilutionStrategy],
      Series
    ],
    Example[{Options,NumberOfDilutions,"Specify the NumberOfDilutions to do in the series:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 6
      ];
      Lookup[options,NumberOfDilutions],
      6
    ],
    Example[{Options,TargetAnalyte,"Specify the component in the composition whose concentration should be taken into account when calculating dilutions:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        TargetAnalyte -> Model[Molecule,Oligomer,"Test Oligomer 1 for ResolveDilutionSharedOptions" <> $SessionUUID]
      ];
      Lookup[options,TargetAnalyte],
      ObjectP[Model[Molecule,Oligomer,"Test Oligomer 1 for ResolveDilutionSharedOptions" <> $SessionUUID]]
    ],
    Example[{Options,TargetAnalyte,"Specify the component in the composition whose concentration should be taken into account when calculating dilutions:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        TargetAnalyte -> Model[Molecule,Oligomer,"Test Oligomer 1 for ResolveDilutionSharedOptions" <> $SessionUUID]
      ];
      Lookup[options,TargetAnalyte],
      ObjectP[Model[Molecule,Oligomer,"Test Oligomer 1 for ResolveDilutionSharedOptions" <> $SessionUUID]]
    ],
    Example[{Options,Diluent,"Specify the solution to use as the Diluent:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent -> Model[Sample, "Milli-Q water"]
      ];
      Lookup[options,Diluent],
      ObjectP[Model[Sample, "Milli-Q water"]]
    ],
    Example[{Options,ConcentratedBuffer,"Specify the ConcentratedBuffer to use as a diluent:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Linear,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x PBS"]
      ];
      Lookup[options, ConcentratedBuffer],
      ObjectP[Model[Sample, StockSolution, "10x PBS"]]
    ],
    Example[{Options,ConcentratedBufferDiluent,"Specify the Solution to dilute the concentrated buffer before diluting the sample:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Linear,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x PBS"],
        ConcentratedBufferDiluent -> Model[Sample, "Milli-Q water"]
      ];
      Lookup[options, ConcentratedBufferDiluent],
      ObjectP[Model[Sample, "Milli-Q water"]]
    ],
    Example[{Options,CumulativeDilutionFactor,"Specify the factor to dilute the sample by specifying dilution factor in relation to the initial sample:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        CumulativeDilutionFactor -> {{10, 100, 1000}}
      ];
      Lookup[options,CumulativeDilutionFactor],
      {{10, 100, 1000}}
    ],
    Example[{Options,SerialDilutionFactor,"Specify the factor to dilute the sample by specifying dilution factor in relation to the previously diluted sample:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        SerialDilutionFactor -> {{2,2,2}}
      ];
      Lookup[options,SerialDilutionFactor],
      {{2,2,2}}
    ],
    Example[{Options,TargetAnalyteConcentration,"Specify the factor to dilute the sample by specifying the final concentration of the analyte:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        TargetAnalyteConcentration -> {{2 Millimolar, 1 Millimolar}}
      ];
      Lookup[options,TargetAnalyteConcentration],
      {{2 Millimolar, 1 Millimolar}}
    ],
    Example[{Options,TransferVolume,"Specify how much sample should be transferred into each dilution for a linear dilution:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Linear,
        TransferVolume -> {{1 Milliliter, 3 Milliliter}}
      ];
      Lookup[options,TransferVolume],
      {{1 Milliliter, 3 Milliliter}}
    ],
    Example[{Options,TransferVolume,"Specify how much sample should be transferred into each dilution for a serial dilution:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        TransferVolume -> {{1 Milliliter, 3 Milliliter}}
      ];
      Lookup[options,TransferVolume],
      {{1 Milliliter, 3 Milliliter}}
    ],
    Example[{Options,TotalDilutionVolume,"Specify the total sum of volume in each dilution sample (sum of sample, diluent, concentrated buffer, and concentrated buffer diluent:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x PBS"],
        TotalDilutionVolume -> {{1 Milliliter, 3 Milliliter}}
      ];
      Lookup[options,TotalDilutionVolume],
      {{1 Milliliter, 3 Milliliter}}
    ],
    Example[{Options,FinalVolume,"Specify the volume left in each sample at the end of the dilution series:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x PBS"],
        FinalVolume -> {{1 Milliliter, 1 Milliliter}}
      ];
      Lookup[options,FinalVolume],
      {{1 Milliliter, 1 Milliliter}}
    ],
    Example[{Options,DiluentVolume,"Specify how much diluent to use for each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        DiluentVolume -> {{1 Milliliter, 2 Milliliter, 3 Milliliter}}
      ];
      Lookup[options,FinalVolume],
      {{1 Milliliter, 2 Milliliter, 3 Milliliter}}
    ],
    Example[{Options,ConcentratedBufferVolume,"Specify how much concentrated buffer to use for each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Linear,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x PBS"],
        ConcentratedBufferVolume -> {{1 Milliliter, 2 Milliliter}}
      ];
      Lookup[options,ConcentratedBufferVolume],
      {{1 Milliliter, 2 Milliliter}}
    ],
    Example[{Options,ConcentratedBufferDiluentVolume,"Specify how much concentrated buffer diluent to use for each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x PBS"],
        ConcentratedBufferDiluentVolume -> {{10 Milliliter, 15 Milliliter}}
      ];
      Lookup[options,ConcentratedBufferDiluentVolume],
      {{10 Milliliter, 15 Milliliter}}
    ],
    Example[{Options,ConcentratedBufferDilutionFactor,"Specify the factor by which the concentrated buffer should be diluted before being combined with the sample at each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x PBS"],
        ConcentratedBufferDilutionFactor -> {{10, 15}}
      ];
      Lookup[options,ConcentratedBufferDilutionFactor],
      {{10, 15}}
    ],
    Example[{Options,Incubate,"Specify that each dilution sample should be mixed between each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 3,
        Incubate -> True
      ];
      Lookup[options,Incubate],
      True
    ],
    Example[{Options,IncubationTime,"Specify the length of time to mix each dilution sample between each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 3,
        IncubationTime -> 1 Minute
      ];
      Lookup[options,IncubationTime],
      1 Minute
    ],
    Example[{Options,IncubationInstrument,"Specify the instrument to use to mix each dilution sample between each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 3,
        IncubationInstrument -> Model[Instrument,Vortex,"Microplate Genie"]
      ];
      Lookup[options,IncubationInstrument],
      ObjectP[Model[Instrument,Vortex,"Microplate Genie"]]
    ],
    Example[{Options,IncubationTemperature,"Specify the temperature to mix each dilution sample between each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 3,
        IncubationTemperature -> 20 Celsius
      ];
      Lookup[options,IncubationTemperature],
      20 Celsius
    ],
    Example[{Options,MixType,"Specify how to mix each dilution sample between each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 2,
        MixType -> Vortex
      ];
      Lookup[options,MixType],
      Vortex
    ],
    Example[{Options,NumberOfMixes,"Specify the number of times to mix by pipette each dilution sample between each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 2,
        NumberOfMixes -> 10,
        MixType -> Pipette
      ];
      Lookup[options,NumberOfMixes],
      10
    ],
    Example[{Options,MixRate,"Specify rate at which to mix by shaking each dilution sample between each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 2,
        MixRate -> 500 RPM,
        MixType -> Shake
      ];
      Lookup[options,MixRate],
      500 RPM
    ],
    Example[{Options,MixOscillationAngle,"Specify angle at which to mix by shaking each dilution sample between each dilution step:"},
      options = ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 2,
        MixOscillationAngle -> 8 AngularDegree,
        IncubationInstrument -> Model[Instrument,Vortex,"Microplate Genie"]
      ];
      Lookup[options,MixOscillationAngle],
      8 AngularDegree
    ],
    Example[{Options,Output,"Setting the output option to Tests will return a list of EmeraldTests:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 2,
        Output -> Tests
      ],
      {_EmeraldTest..}
    ],
       
    Example[{Messages,"InvalidNumberOfDilutions","If the length of the inner list of a volume or concentration option does not match the value of NumberOfDilutions, an error is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        NumberOfDilutions -> 4,
        TotalDilutionVolume -> {{1 Milliliter, 1 Milliliter, 1 Milliliter}}
      ],
      $Failed,
      Messages :> {Error::InvalidNumberOfDilutions}
    ],
    Example[{Messages,"NoDiluentSpecified","If neither a Diluent or ConcentratedBuffer is specified and the input sample does not have a Media or Solvent, water will be used as the diluent and a warning will be thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 9 (5mL Test Oligo 1 in PBS - no Solvent) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial
      ],
      {_Rule..},
      Messages :> {Warning::NoDiluentSpecified}
    ],
    Example[{Messages,"MissingTargetAnalyteInitialConcentration","If the specified TargetAnalyte does not have a concentration in the composition of the input sample and it is required for the calculation an error will be thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 10 (5mL Test Oligo 1 in PBS - no Initial conc) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent->Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial
      ],
      {_Rule..},
      Messages :> {Warning::MissingTargetAnalyteInitialConcentration}
    ],
    Example[{Messages,"ConflictingFactorsAndVolumes","If the specified TargetAnalyte does not have a concentration in the composition of the input sample and it is required for the calculation an error will be thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 10 (5mL Test Oligo 1 in PBS - no Initial conc) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent->Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
        SerialDilutionFactor -> {{10}},
        CumulativeDilutionFactor -> {{5}},
        DilutionType->Serial
      ],
      {_Rule..},
      Messages :> {Error::ConflictingFactorsAndVolumes,Error::ConflictingDiluentParameters,Error::InvalidOption}
    ],
    Example[{Messages,"NoSampleVolume","If the input sample does not have a volume and one cannot be calculated, a warning is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 6 (Null Volume Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent->Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial
      ],
      {_Rule..},
      Messages :> {Warning::NoSampleVolume}
    ],
    Example[{Messages,"DilutionTypeAndStrategyMismatch","If there are conflicting DilutionType and DilutionStrategy options, an error is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent->Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Serial,
        DilutionStrategy -> Null
      ],
      {_Rule..},
      Messages :> {Error::DilutionTypeAndStrategyMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"DilutionTypeAndStrategyMismatch","If there are conflicting DilutionType and DilutionStrategy options, an error is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent->Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DilutionType->Linear,
        DilutionStrategy->Series
      ],
      {_Rule..},
      Messages :> {Error::DilutionTypeAndStrategyMismatch,Error::InvalidOption}
    ],
    Example[{Messages,"OverspecifiedDilution","If both Diluent and ConcentratedBuffer are specified, an error is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 10 (5mL Test Oligo 1 in PBS - no Initial conc) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent->Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
        ConcentratedBuffer -> Object[Sample,"Test Sample 4 (5mL 10x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        ConcentratedBufferDiluent -> Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID]
      ],
      {_Rule..},
      Messages :> {Error::OverspecifiedDilution,Error::ConflictingConcentratedBufferParameters,Error::ConflictingDiluentParameters,Error::InvalidOption}
    ],
    Example[{Messages,"ConflictingConcentratedBufferParameters","If there are conflicting concentrated buffer options, an error is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
        ConcentratedBuffer -> Object[Sample,"Test Sample 4 (5mL 10x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
        ConcentratedBufferDiluent -> Null
      ],
      {_Rule..},
      Messages :> {Error::ConflictingConcentratedBufferParameters,Error::InvalidOption}
    ],
    Example[{Messages,"ConflictingDiluentParameters","If there are conflicting diluent options, an error is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent->Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
        DiluentVolume->Null
      ],
      {_Rule..},
      Messages :> {Error::ConflictingDiluentParameters,Error::InvalidOption}
    ],
    Example[{Messages,"VolumesTooLarge","If the calculated volumes are not within 0.1 Microliter to 20 Liter, an error will be thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
        Diluent->Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
        CumulativeDilutionFactor -> {{10000000000}}
      ],
      {_Rule..},
      Messages :> {Error::VolumesTooLarge,Error::InvalidOption}
    ],
    Example[{Messages,"MultipleTargetAnalyteConcentrationUnitsError","If multiple units are specified in TargetAnalyteConcentration, an error is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
        TargetAnalyteConcentration -> {{500 Cell/Milliliter, 10 CFU/Milliliter}}
      ],
      {_Rule..},
      Messages :> {Error::MultipleTargetAnalyteConcentrationUnitsError,Error::InvalidOption}
    ],
    Example[{Messages,"ConflictingTargetAnalyteConcentrationUnitsError","If the units in TargetAnalyteConcentration are not compatible with the units of the concentration in the input sample, an error is thrown:"},
      ResolveDilutionSharedOptions[
        Object[Sample,"Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
        TargetAnalyteConcentration -> {{0.4 OD600, 0.2 OD600}}
      ],
      {_Rule..},
      Messages :> {Error::ConflictingTargetAnalyteConcentrationUnitsError,Error::InvalidOption}
    ]
  },
  SymbolSetUp :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ResolveDilutionSharedOptions Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Vessel,"Test 50 mL tube 1 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 2 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 3 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 4 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 5 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 6 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 7 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 8 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 9 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 10 for ResolveDilutionSharedOptions" <> $SessionUUID],

          (* Analytes *)
          Model[Molecule,Oligomer,"Test Oligomer 1 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Molecule,Oligomer,"Test Oligomer 2 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Instrument,Nephelometer,"Test Nephelometer model 1 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ResolveDilutionSharedOptions" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 (0.8 OD600 Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 (3 Millimolar Test Oligo 1 in 1x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 (3 Millimolar Test Oligo 2 in Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Sample,"Test Sample Model 4 (10,000 Cell/mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Sample,"Test Sample Model 5 (3 Millimolar Test Oligo 1 in 1x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],

          (* Sample Objects *)
          Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 3 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 4 (5mL 10x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 5 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 6 (Null Volume Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 7 (5 Gram Test Oligo 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 9 (5mL Test Oligo 1 in PBS - no Solvent) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 10 (5mL Test Oligo 1 in PBS - no Initial conc) for ResolveDilutionSharedOptions" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ];
    Module[
      {
        testBench,tube1, tube2, tube3, tube4, tube5, tube6, tube7, tube8, tube9, tube10, oligo1, oligo2, cell1,
        cellInLBModelOD600, cellInLBModelCellPermL, oligo1InPBSModel, oligo2InWaterModel,oligo1InPBSModelNoOligo1Conc,waterSample, oligo1InPBSSample,
        cell1InLBSampleOD600, cell1InLBSampleCellPermL, pbs10xSample, noTAConcentrationSample, oligo1InPBSNoVolumeSample,
        oligo1InPBSMassSample,oligo1InPBSSampleNoSolvent,oligo1InPBSSampleNoConc,developerObjectPackets
      },

      (* Upload bench *)
      testBench = Upload[
        <|
          Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
          Type->Object[Container,Bench],
          Name->"Bench for ResolveDilutionSharedOptions Testing"<>$SessionUUID
        |>
      ];

      (* Upload containers *)
      {
        tube1,
        tube2,
        tube3,
        tube4,
        tube5,
        tube6,
        tube7,
        tube8,
        tube9,
        tube10
      } = UploadSample[
        ConstantArray[Model[Container, Vessel, "50mL Tube"],10],
        ConstantArray[{"Work Surface",testBench},10],
        Name -> Table["Test 50 mL tube " <> ToString[i] <> " for ResolveDilutionSharedOptions" <> $SessionUUID,{i,1,10}]
      ];

      (* Create Test Analytes *)
      {
        oligo1,oligo2
      } = UploadOligomer[
        {
          "Test Oligomer 1 for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Oligomer 2 for ResolveDilutionSharedOptions" <> $SessionUUID
        },
        Molecule -> {
          Structure[{Strand[DNA["ATC"]]}, {}],
          Structure[{Strand[DNA["TAC"]]}, {}]
        },
        PolymerType -> DNA,
        State -> Solid
      ];

      (* Create a test standard curve *)
      standardCurve1 = Upload[
        <|
          Type->Object[Analysis,StandardCurve],
          Name->"Test StandardCurve 1 (cell/mL to cfu/mL) for ResolveDilutionSharedOptions" <> $SessionUUID,
          Replace[StandardDataUnits] -> {Cell/Milliliter,CFU/Milliliter},
          BestFitFunction -> QuantityFunction[#1^2 &, Cell/Milliliter, CFU/Milliliter],
          DateCreated -> Now - 1 Day,
          DeveloperObject -> True
        |>
      ];

      (* Create a shell Object[Protocol,Nephelometry] and Model[Instrument,Nephelometer] so the Model[Cell] can be populated properly *)
      Upload[
        {
          <|
            Type->Object[Protocol,Nephelometry],
            Name->"Test Nephelometry protocol 1 for ResolveDilutionSharedOptions" <> $SessionUUID,
            DeveloperObject -> True
          |>,
          <|
            Type->Model[Instrument,Nephelometer],
            Name->"Test Nephelometer model 1 for ResolveDilutionSharedOptions" <> $SessionUUID,
            DeveloperObject -> True
          |>
        }
      ];

      cell1 = UploadBacterialCell[
        "Test Cell 1 for ResolveDilutionSharedOptions" <> $SessionUUID,
        Morphology -> Cocci,
        BiosafetyLevel -> "BSL-1",
        Flammable -> False,
        MSDSFile -> NotApplicable,
        IncompatibleMaterials -> {None},
        CellType -> Bacterial,
        CultureAdhesion -> Suspension,
        StandardCurves -> {
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ResolveDilutionSharedOptions" <> $SessionUUID]
        },
        StandardCurveProtocols -> {
          Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ResolveDilutionSharedOptions" <> $SessionUUID]
        }
      ];

      (* Upload Test Models *)
      {
        cellInLBModelOD600,
        oligo1InPBSModel,
        oligo2InWaterModel,
        cellInLBModelCellPermL,
        oligo1InPBSModelNoOligo1Conc
      } = UploadSampleModel[
        {
          "Test Sample Model 1 (0.8 OD600 Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample Model 2 (3 Millimolar Test Oligo 1 in 1x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample Model 3 (3 Millimolar Test Oligo 2 in Water) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample Model 4 (10,000 Cell/mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample Model 5 (3 Millimolar Test Oligo 1 in 1x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID
        },
        Composition -> {
          {
            {0.8 OD600, cell1},
            {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
            {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
            {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
          },
          {
            {Quantity[100.`, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
            {Quantity[1.76`, ("Millimoles")/("Liters")], Model[Molecule, "Potassium Phosphate (Dibasic)"]},
            {Quantity[8.01`, ("Millimoles")/("Liters")], Model[Molecule, "Dibasic Sodium Phosphate"]},
            {Quantity[2.7`, ("Millimoles")/("Liters")], Model[Molecule, "Potassium Chloride"]},
            {Quantity[0.137`, ("Moles")/("Liters")], Model[Molecule, "Sodium Chloride"]},
            {4 Millimolar,oligo1}
          },
          {
            {10 Millimolar, oligo2},
            {100 VolumePercent, Model[Molecule,"Water"]}
          },
          {
            {10000 Cell/Milliliter, cell1},
            {Quantity[95, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
            {Quantity[171.116, "Millimolar"], Model[Molecule, "Sodium Chloride"]},
            {Quantity[0.005, ("Grams")/("Milliliters")], Model[Molecule, "Yeast Extract"]}
          },
          {
            {Quantity[100.`, IndependentUnit["VolumePercent"]], Model[Molecule, "Water"]},
            {Quantity[1.76`, ("Millimoles")/("Liters")], Model[Molecule, "Potassium Phosphate (Dibasic)"]},
            {Quantity[8.01`, ("Millimoles")/("Liters")], Model[Molecule, "Dibasic Sodium Phosphate"]},
            {Quantity[2.7`, ("Millimoles")/("Liters")], Model[Molecule, "Potassium Chloride"]},
            {Quantity[0.137`, ("Moles")/("Liters")], Model[Molecule, "Sodium Chloride"]},
            {Null,oligo1}
          }
        },
        IncompatibleMaterials -> {None},
        Expires -> True,
        ShelfLife -> 2 Week,
        UnsealedShelfLife -> 1 Hour,
        DefaultStorageCondition -> {
          Model[StorageCondition, "id:mnk9jORxkYOO"], (* Model[StorageCondition, "Bacterial Incubation"] *)
          Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
          Model[StorageCondition, "id:7X104vnR18vX"], (* Model[StorageCondition, "Ambient Storage"] *)
          Model[StorageCondition, "id:mnk9jORxkYOO"], (* Model[StorageCondition, "Bacterial Incubation"] *)
          Model[StorageCondition, "id:7X104vnR18vX"] (* Model[StorageCondition, "Ambient Storage"] *)
        },
        Flammable -> False,
        MSDSFile -> NotApplicable,
        BiosafetyLevel -> {"BSL-2","BSL-1","BSL-1","BSL-2","BSL-1"},
        State -> Liquid,
        UsedAsSolvent -> False,
        UsedAsMedia -> False,
        Living -> {True,False,False,True,False}
      ];

      (* Upload samples *)
      {
        waterSample,
        oligo1InPBSSample,
        cell1InLBSampleOD600,
        pbs10xSample,
        noTAConcentrationSample,
        oligo1InPBSNoVolumeSample,
        oligo1InPBSMassSample,
        cell1InLBSampleCellPermL,
        oligo1InPBSSampleNoSolvent,
        oligo1InPBSSampleNoConc
      } = UploadSample[
        {
          Model[Sample, "Milli-Q water"],
          oligo1InPBSModel,
          cellInLBModelOD600,
          Model[Sample, StockSolution, "10x PBS"],
          Model[Sample, "Milli-Q water"],
          oligo1InPBSModel,
          oligo1InPBSModel,
          cellInLBModelCellPermL,
          oligo1InPBSModel,
          oligo1InPBSModelNoOligo1Conc
        },
        {
          {"A1",tube1},
          {"A1",tube2},
          {"A1",tube3},
          {"A1",tube4},
          {"A1",tube5},
          {"A1",tube6},
          {"A1",tube7},
          {"A1",tube8},
          {"A1",tube9},
          {"A1",tube10}
        },
        Name -> {
          "Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 3 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 4 (5mL 10x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 5 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 6 (Null Volume Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 7 (5 Gram Test Oligo 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 9 (5mL Test Oligo 1 in PBS - no Solvent) for ResolveDilutionSharedOptions" <> $SessionUUID,
          "Test Sample 10 (5mL Test Oligo 1 in PBS - no Initial conc) for ResolveDilutionSharedOptions" <> $SessionUUID
        },
        InitialAmount -> Join[ConstantArray[5 Milliliter, 6],{5 Gram},{5 Milliliter},{5 Milliliter},{5 Milliliter}]
      ];

      (* Make sure everything is a developer object *)
      developerObjectPackets = (<|Object->#,DeveloperObject->True|>)&/@{
        tube1, tube2, tube3, tube4, tube5, tube6, tube7, tube8, tube9, tube10, oligo1, oligo2, cell1,
        cellInLBModelOD600, cellInLBModelCellPermL, oligo1InPBSModel, oligo2InWaterModel,oligo1InPBSModelNoOligo1Conc,waterSample, oligo1InPBSSample,
        cell1InLBSampleOD600, cell1InLBSampleCellPermL, pbs10xSample, noTAConcentrationSample, oligo1InPBSNoVolumeSample,
        oligo1InPBSMassSample,oligo1InPBSSampleNoSolvent,oligo1InPBSSampleNoConc
      };
      Upload[developerObjectPackets];

      (* Make sure solvent fields are set properly *)
      Upload[{
        <|
          Object->Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Solvent -> Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
          BaselineStock -> Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
          ConcentratedBufferDilutionFactor -> 1,
          ConcentratedBufferDiluent -> Link[Model[Sample, "Milli-Q water"]]
        |>,
        <|
          Object -> Object[Sample,"Test Sample 3 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
        |>,
        <|
          Object->Object[Sample,"Test Sample 6 (Null Volume Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Volume -> Null,
          Solvent -> Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
          BaselineStock -> Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
          ConcentratedBufferDilutionFactor -> 1,
          ConcentratedBufferDiluent -> Link[Model[Sample, "Milli-Q water"]]
        |>,
        <|
          Object->Object[Sample,"Test Sample 7 (5 Gram Test Oligo 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Solvent -> Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
          BaselineStock -> Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
          ConcentratedBufferDilutionFactor -> 1,
          ConcentratedBufferDiluent -> Link[Model[Sample, "Milli-Q water"]]
        |>,
        <|
          Object -> Object[Sample,"Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Media -> Link[Model[Sample, Media, "LB Broth, Miller"]]
        |>,
        <|
          Object->Object[Sample,"Test Sample 10 (5mL Test Oligo 1 in PBS - no Initial conc) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Solvent -> Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
          BaselineStock -> Link[Model[Sample, StockSolution, "1x PBS from 10X stock"]],
          ConcentratedBufferDilutionFactor -> 1,
          ConcentratedBufferDiluent -> Link[Model[Sample, "Milli-Q water"]]
        |>
      }]

    ];
  ),
  SymbolTearDown :> (
    Module[{objs,existingObjs},
      objs=Quiet[Cases[
        Flatten[{
          (* Bench *)
          Object[Container,Bench,"Bench for ResolveDilutionSharedOptions Testing"<>$SessionUUID],

          (* Containers *)
          Object[Container,Vessel,"Test 50 mL tube 1 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 2 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 3 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 4 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 5 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 6 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 7 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 8 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 9 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Container,Vessel,"Test 50 mL tube 10 for ResolveDilutionSharedOptions" <> $SessionUUID],

          (* Analytes *)
          Model[Molecule,Oligomer,"Test Oligomer 1 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Molecule,Oligomer,"Test Oligomer 2 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Analysis,StandardCurve,"Test StandardCurve 1 (cell/mL to cfu/mL) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Protocol,Nephelometry,"Test Nephelometry protocol 1 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Instrument,Nephelometer,"Test Nephelometer model 1 for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Cell,Bacteria,"Test Cell 1 for ResolveDilutionSharedOptions" <> $SessionUUID],

          (* Sample Models *)
          Model[Sample,"Test Sample Model 1 (0.8 OD600 Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Sample,"Test Sample Model 2 (3 Millimolar Test Oligo 1 in 1x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Sample,"Test Sample Model 3 (3 Millimolar Test Oligo 2 in Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Sample,"Test Sample Model 4 (10,000 Cell/mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Model[Sample,"Test Sample Model 5 (3 Millimolar Test Oligo 1 in 1x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],

              (* Sample Objects *)
          Object[Sample,"Test Sample 1 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 2 (5mL Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 3 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 4 (5mL 10x PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 5 (5mL Water) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 6 (Null Volume Test Oligo 1 in PBS) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 7 (5 Gram Test Oligo 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 8 (5mL Test Cell 1 in LB Broth) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 9 (5mL Test Oligo 1 in PBS - no Solvent) for ResolveDilutionSharedOptions" <> $SessionUUID],
          Object[Sample,"Test Sample 10 (5mL Test Oligo 1 in PBS - no Initial conc) for ResolveDilutionSharedOptions" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs=PickList[objs,DatabaseMemberQ[objs]];
      EraseObject[existingObjs,Force->True,Verbose->False]
    ];
  )
];