(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentIRSpectroscopy : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*IRSpectroscopy*)


(* ::Subsubsection:: *)
(*ExperimentIRSpectroscopy*)

DefineTests[ExperimentIRSpectroscopy,
  {
    Example[{Basic, "Takes a sample object: "},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      ObjectP[Object[Protocol, IRSpectroscopy]]
    ],
    Example[{Basic, "Takes a container object with a sample: "},
      ExperimentIRSpectroscopy[Object[Container, Vessel, "Test container 2 for ExperimentIRSpectroscopy" <> $SessionUUID]],
      ObjectP[Object[Protocol, IRSpectroscopy]]
    ],
    Example[{Basic, "Takes a sample object without a model: "},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 12 (chemical, ethanol, no model) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      ObjectP[Object[Protocol, IRSpectroscopy]]
    ],

    Example[{Additional,"Specify a number of shared and differentiated blanks, sample amounts, and suspension solutions to use with the experiment: "},
      ExperimentIRSpectroscopy[
        {
          Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],
          Object[Sample, "Test sample 6 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID],
          Object[Sample, "Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID],
          Object[Sample, "Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID]
        },
        SampleAmount -> {Automatic,100 Microliter,50 Milligram,200 Microliter},
        SuspensionSolution -> {Null, Null, Model[Sample, "Mineral Oil"], Null},
        SuspensionSolutionVolume -> {Null, Null, 100 Microliter, Null},
        Blanks->{
          {1,Model[Sample, "Milli-Q water"]},
          {Automatic,Automatic},
          {Automatic,Model[Sample, "Mineral Oil"]},
          Null
        }
      ],
      ObjectP[Object[Protocol, IRSpectroscopy]]
    ],
    (*RESOLVER checks*)

    Example[{Additional,"The Blanks of a liquid sample should resolve to Null:"},
      options=ExperimentIRSpectroscopy[Object[Container,Vessel,"Test container 2 for ExperimentIRSpectroscopy" <> $SessionUUID],Output->Options];
      Lookup[options,Blanks],
      {Null,Null},
      Variables:>{options}
    ],

    (*a stock solution with a defined solvent of water should yield water*)

    Example[{Additional,"The Blanks of a stock solution with water solvent should resolve to Null:"},
      options=ExperimentIRSpectroscopy[Object[Sample,"Test sample 6 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID],Output->Options];
      Lookup[options,Blanks],
      {Null,Null},
      Variables:>{options}
    ],
    (*a chemical should yield Null*)

    Example[{Additional,"The Blanks of a chemical sample should resolve to Null:"},
      options=ExperimentIRSpectroscopy[Object[Sample,"Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID],Output->Options];
      Lookup[options,Blanks],
      {Null,Null},
      Variables:>{options}
    ],

    (*a solid sample should yield Null*)
    Example[{Additional,"A solid sample should resolve Blanks to Null:"},
      options=ExperimentIRSpectroscopy[Object[Sample,"Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID],SuspensionSolution->Model[Sample, "id:kEJ9mqR8MnBe"],Output->Options];
      Lookup[options,Blanks],
      {Null,Null},
      Variables:>{options}
    ],

    (*TODO: many additional resolver checks needed*)

    Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the amount of an input Model[Sample] and the container in which it is to be prepared:"},
      options = ExperimentIRSpectroscopy[
        {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
        PreparedModelContainer -> Model[Container, Vessel, "2mL Tube"],
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
        {ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
        {ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]]..},
        {EqualP[1 Milliliter]..},
        {"A1", "A1"},
        {_String, _String}
      },
      Variables :> {options, prepUOs}
    ],
    Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
      ExperimentIRSpectroscopy[
        Model[Sample, "Caffeine"],
        PreparedModelAmount -> 1 Gram,
        Aliquot -> True,
        Mix -> True
      ],
      ObjectP[Object[Protocol, IRSpectroscopy]]
    ],

    (*Instrument specific options*)


    Example[{Options, SampleAmount, "Specify the amount of sample to load for Infrared measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], SampleAmount -> 100 Microliter, Output -> Options];
      Lookup[options, SampleAmount],
      100 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,PressSample,"Specify pressure application of the sample through measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample,"Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID],PressSample->True,Output->Options];
      Lookup[options, PressSample],
      True,
      Variables :> {options}
    ],
    Example[{Options, Blanks, "Specify a custom blank solution, for whose spectrum is subtracted from the samples' spectrum (Null refers to subtracting the air):"},
      options = ExperimentIRSpectroscopy[{Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Object[Sample,"Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID]},Blanks->{{Null,Null},{Automatic,Model[Sample,"Milli-Q water"]}},Output->Options];
      Lookup[options, Blanks],
      {{Null,Null},{1,ObjectP@Model[Sample,"Milli-Q water"]}},
      Variables :> {options}
    ],
    Example[{Options, BlankAmounts, "Specify a custom blank solution, for whose spectrum is subtracted from the samples' spectrum (Null refers to subtracting the air):"},
      options = ExperimentIRSpectroscopy[{Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Object[Sample,"Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID]}, Blanks -> Model[Sample,"Milli-Q water"],BlankAmounts->{50 Microliter, 100 Microliter}, Output -> Options];
      Lookup[options, BlankAmounts],
      {50 Microliter,100 Microliter},
      Variables :> {options}
    ],
    Example[{Options,PressBlank,"Specify to apply pressure to the measurement of the Blanks:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Blanks->Object[Sample,"Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID],PressBlank->True,Output->Options];
      Lookup[options, PressBlank],
      True,
      Variables :> {options},
      Messages:>{
        Warning::SampleMustBeMoved
      }
    ],
    Example[{Options, SuspensionSolution, "Specify a solution to add to the sample after loading onto the instrument:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID], SuspensionSolution -> Model[Sample, "Mineral Oil"], Output -> Options];
      Lookup[options, SuspensionSolution],
      ObjectP[Model[Sample, "Mineral Oil"]],
      Variables :> {options}
    ],
    Example[{Options, SuspensionSolutionVolume, "Specify the volume of a solution added to the sample after loading onto the instrument:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID], SuspensionSolution -> Model[Sample, "Mineral Oil"],SuspensionSolutionVolume -> 100 Microliter, Output -> Options];
      Lookup[options, SuspensionSolutionVolume],
      100 Microliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, Instrument, "Specify a specific spectrophotometer for Infrared measurement:"},
      options = Quiet[
        ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Instrument -> Object[Instrument, Spectrophotometer, "Deutsch"], Output -> Options],
        Warning::InstrumentUndergoingMaintenance
      ];
      Lookup[options, Instrument],
      ObjectP[Object[Instrument,Spectrophotometer,"Deutsch"]],
      Variables :> {options}
    ],
    Example[{Options, SampleModule, "Specify the type of module used for sample loading for Infrared measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], SampleModule -> Reflection, Output -> Options];
      Lookup[options, SampleModule],
      Reflection,
      Variables :> {options}
    ],
    Example[{Options, NumberOfReplicates, "Specify the number of repetition measurements to perform on the set of samples and conditions:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], NumberOfReplicates -> 3, Output -> Options];
      Lookup[options, NumberOfReplicates],
      3,
      Variables :> {options}
    ],
    Example[{Options, RecoupSample, "Specify to recover as much of the sample as possible after measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], RecoupSample -> True, Output -> Options];
      Lookup[options, RecoupSample],
      True,
      Variables :> {options}
    ],
    Example[{Options, IntegrationTime, "Specify the measurement time, over which, a spectrum is averaged:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], IntegrationTime -> 2 Minute, Output -> Options];
      Lookup[options, IntegrationTime],
      2 Minute,
      Variables :> {options}
    ],
    Example[{Options, NumberOfReadings, "Specify the number of readings, over which, the spectrum is averaged:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], NumberOfReadings -> 50, Output -> Options];
      Lookup[options, NumberOfReadings],
      50,
      Variables :> {options}
    ],
    Example[{Options, MinWavenumber, "Specify the minimum wavenumber of the spectrum range for measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MinWavenumber -> 1000 1/Centimeter, Output -> Options];
      Lookup[options, MinWavenumber],
      1000 1/Centimeter,
      Variables :> {options}
    ],
    Example[{Options, MaxWavenumber, "Specify the maximum wavenumber of the spectrum range for measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MaxWavenumber -> 7000 1/Centimeter, Output -> Options];
      Lookup[options, MaxWavenumber],
      7000 1/Centimeter,
      Variables :> {options}
    ],
    Example[{Options, WavenumberResolution, "Specify the wavenumber graduation of the spectrum measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], WavenumberResolution -> 4 1/Centimeter, Output -> Options];
      Lookup[options, WavenumberResolution],
      4 1/Centimeter,
      Variables :> {options}
    ],

    Example[{Options, MinWavelength, "Specify the minimum wavelength of the spectrum range for measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MinWavelength -> 2000 Nanometer, Output -> Options];
      Lookup[options, MinWavelength],
      2000 Nanometer,
      Variables :> {options}
    ],
    Example[{Options, MaxWavelength, "Specify the maximum wavelength of the spectrum range for measurement:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MaxWavelength -> 15000 Nanometer, Output -> Options];
      Lookup[options, MaxWavelength],
      15000 Nanometer,
      Variables :> {options}
    ],
    Example[{Options, Name, "Run a protocol with a defined name for it so that it may be more easily referred to:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MaxWavelength -> 15000 Nanometer, Name->"IR procedure with MaxWavelength change", Output -> Options];
      Lookup[options, Name],
      "IR procedure with MaxWavelength change",
      Variables :> {options}
    ],
    Example[{Options,Template,"A template protocol whose methodology should be reproduced in running this experiment. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this Experiment function:"},
      options=ExperimentIRSpectroscopy[
        Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Template->Object[Protocol,IRSpectroscopy,"Test Template Protocol for ExperimentIRSpectroscopy" <> $SessionUUID],
        IntegrationTime->30 Second,
        Output->Options
      ];
      Lookup[options,Blanks],
      {Null,Null},
      Variables:>{options}
    ],
    Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options,SamplesInStorageCondition],
      Refrigerator,
      Variables:>{options}
    ],

    (*Error checking*)
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentIRSpectroscopy[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentIRSpectroscopy[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentIRSpectroscopy[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentIRSpectroscopy[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages,"DiscardedSamples","Return an error for a discarded sample:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample (discarded) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages,"NotEnoughSample","Return an error for a sample with insufficient volume:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 3 (too low volume) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::NotEnoughSample,
        Error::InvalidInput
      }
    ],
    Example[{Messages,"MinWavenumberGreaterThanMax","Return an error for when the Max wavelength is set less than the Min:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MinWavelength->2000 Nanometer,MaxWavelength->1500 Nanometer],
      $Failed,
      Messages:>{
        Error::MinWavenumberGreaterThanMax,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"UnsuitableInstrument","Return an error for when a specified instrument is incapable of Infrared measurement:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Instrument->Model[Instrument, Spectrophotometer, "Cary 3500"]],
      $Failed,
      Messages:>{
        Error::UnsuitableInstrument,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"IncompatibleSample","Return an error for when the sample is chemically incompatible with all Infrared spectrometers:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 4 (incompatible) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::IncompatibleSample,
        Error::InvalidInput
      }
    ],
    Example[{Messages,"IncompatibleBlanks","Return an error for when the specified Blank is chemically incompatible with all Infrared spectrometers:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Blanks->Object[Sample, "Test sample 4 (incompatible) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::IncompatibleBlanks,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"IncompatibleSuspensionSolution","Return an error for when the specified SuspensionSolution is chemically incompatible with all Infrared spectrometers:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],SuspensionSolution->Object[Sample, "Test sample 4 (incompatible) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::IncompatibleSuspensionSolution,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"IRSpectroscopyTooManySamples","Return an error for when the user specifies too many non-plate measurements:"},
      ExperimentIRSpectroscopy[Repeat[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],21]],
      $Failed,
      Messages:>{
        Error::IRSpectroscopyTooManySamples,
        Error::InvalidInput
      }
    ],
    Example[{Messages,"ImproperSampleAmount","Return an error for when SampleAmount is specified for a quantity not populated (e.g. 20 mg for Mass->Null and no density info):"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 9 (sample no volume) for ExperimentIRSpectroscopy" <> $SessionUUID],SampleAmount->20*Microliter],
      $Failed,
      Messages:>{
        Error::ImproperSampleAmount,
        Error::InvalidInput
      }
    ],
    Example[{Messages,"ImproperBlankAmount","Return an error for when BlankAmount is specified for a quantity not populated (e.g. 20 mg for Mass->Null and no density info):"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Blanks->Object[Sample, "Test sample 10 (sample no mass) for ExperimentIRSpectroscopy" <> $SessionUUID],BlankAmounts->20*Milligram],
      $Failed,
      Messages:>{
        Error::ImproperBlankAmount,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"SampleHasNoQuantity","Return an error for a sample has only Null quantities (e.g. Mass and Volume):"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 11 (sample no mass nor volume) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::SampleHasNoQuantity,
        Error::InvalidInput
      }
    ],
    Example[{Messages,"BlankHasNoQuantity","Return an error for a Blank sample has only Null quantities (e.g. Mass and Volume):"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Blanks->Object[Sample, "Test sample 11 (sample no mass nor volume) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::BlankHasNoQuantity,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"SuspensionVolumeNull","Return an error when SuspensionSolutionVolume is set to Null when SuspensionSolution is specified:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],SuspensionSolution->Model[Sample, "Mineral Oil"],SuspensionSolutionVolume->Null],
      $Failed,
      Messages:>{
        Error::SuspensionVolumeNull,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"SuspensionSolutionNull","Return an error when SuspensionSolution is set to Null when SuspensionSolutionVolume is specified:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],SuspensionSolution->Null,SuspensionSolutionVolume->100 Microliter],
      $Failed,
      Messages:>{
        Error::SuspensionSolutionNull,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"BlankSpecifiedNull","Return an error when one of Blanks and BlankAmounts is specified and the other is Null:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Blanks->Null,BlankAmounts->100 Microliter],
      $Failed,
      Messages:>{
        Error::BlankSpecifiedNull,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"IntegrationReadingsNull","Return an error when both the IntegrationTime and the NumberOfReadings are set to Null:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],IntegrationTime->Null,NumberOfReadings->Null],
      $Failed,
      Messages:>{
        Error::IntegrationReadingsNull,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"IntegrationReadingsSpecified","Return an error when both the IntegrationTime and the NumberOfReadings are both specified:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],IntegrationTime->2 Minute,NumberOfReadings->50],
      $Failed,
      Messages:>{
        Error::IntegrationReadingsSpecified,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"MinWavenumberMaxWavelengthBothNull","Return an error when both the MinWavenumber and the MaxWavelength are set to Null:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MinWavenumber->Null,MaxWavelength->Null],
      $Failed,
      Messages:>{
        Error::MinWavenumberMaxWavelengthBothNull,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"MinWavenumberMaxWavelengthBothSpecified","Return an error when both the MinWavenumber and the MaxWavelength are both specified:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MinWavenumber->500 1/Centimeter,MaxWavelength->20000 Nanometer],
      $Failed,
      Messages:>{
        Error::MinWavenumberMaxWavelengthBothSpecified,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"MaxWavenumberMinWavelengthBothNull","Return an error when both the MaxWavenumber and the MinWavelength are set to Null:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MaxWavenumber->Null,MinWavelength->Null],
      $Failed,
      Messages:>{
        Error::MaxWavenumberMinWavelengthBothNull,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"MaxWavenumberMinWavelengthBothSpecified","Return an error when both the MaxWavenumber and the MinWavelength are both specified:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MaxWavenumber->5000 1/Centimeter,MinWavelength->2000 Nanometer],
      $Failed,
      Messages:>{
        Error::MaxWavenumberMinWavelengthBothSpecified,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"BlankIndexSpecifiedNull","Return an error when the index and sample within a Blank tuple are specified and Null:"},
      ExperimentIRSpectroscopy[
        {
          Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],
          Object[Sample, "Test sample 6 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID]
        },
        Blanks->{
          {1,Null},
          {Null,Model[Sample, "Milli-Q water"]}
        }
      ],
      $Failed,
      Messages:>{
        Error::BlankIndexSpecifiedNull,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"SameBlankIndexDifferentObjects","Return an error when the a different object is specified for the same index in Blanks:"},
      ExperimentIRSpectroscopy[
        {
          Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],
          Object[Sample, "Test sample 6 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID]
        },
        Blanks->{
          {1,Object[Sample, "Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID]},
          {1,Model[Sample, "Milli-Q water"]}
        }
      ],
      $Failed,
      Messages:>{
        Error::SameBlankIndexDifferentObjects,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"IndexDifferentSameObject","Return an error when the a different index is specified for the same sample object in Blanks:"},
      ExperimentIRSpectroscopy[
        {
          Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],
          Object[Sample, "Test sample 6 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID]
        },
        Blanks->{
          {1,Object[Sample, "Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID]},
          {2,Object[Sample, "Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID]}
        }
      ],
      $Failed,
      Messages:>{
        Error::IndexDifferentSameObject,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"RecoupSuspensionSolution","Return a warning when RecoupSample is True and a SuspensionSolution is used:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],SuspensionSolution->Model[Sample, "Mineral Oil"],RecoupSample->True],
      ObjectP[Object[Protocol, IRSpectroscopy]],
      Messages:>{
        Warning::RecoupSuspensionSolution
      }
    ],

    (*Pressure applicator warnings*)
    Example[{Messages,"PressureApplicationWithFluidSample","Return a warning when a wet sample is requested with pressure application:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],PressSample->True],
      ObjectP[Object[Protocol, IRSpectroscopy]],
      Messages:>{
        Warning::PressureApplicationWithFluidSample
      }
    ],
    Example[{Messages,"PressureApplicationWithFluidSampleBlanks","Return a warning when a wet Blanks is requested with pressure application:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Blanks->Model[Sample, "Milli-Q water"],PressBlank->True],
      ObjectP[Object[Protocol, IRSpectroscopy]],
      Messages:>{
        Warning::PressureApplicationWithFluidSampleBlanks
      }
    ],
    Example[{Messages,"DryNoPressure","Return a warning when a dry sample is requested without pressure application:"},
      ExperimentIRSpectroscopy[Object[Sample,"Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID],PressSample->False],
      ObjectP[Object[Protocol, IRSpectroscopy]],
      Messages:>{
        Warning::DryNoPressure
      }
    ],
    Example[{Messages,"DryNoPressureBlanks","Return a warning when the user requests a dry Blank Sample without pressure:"},
      ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],Blanks->Object[Sample,"Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID],PressBlank->False],
      ObjectP[Object[Protocol, IRSpectroscopy]],
      Messages:>{
        Warning::DryNoPressureBlanks,
        Warning::SampleMustBeMoved
      }
    ],

    Example[{Messages,"MinWavenumberPrecision","Return a warning when MinWavenumber is specified to unfeasible precision:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MinWavenumber->500.8298958298985 1/Centimeter,Output->Options];
      Lookup[options,MinWavenumber],
      501 1/Centimeter,
      EquivalenceFunction -> Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],
    Example[{Messages,"MaxWavenumberPrecision","Return a warning when MaxWavenumber is specified to unfeasible precision:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MaxWavenumber->5000.8298958298985 1/Centimeter,Output->Options];
      Lookup[options,MaxWavenumber],
      5001 1/Centimeter,
      EquivalenceFunction -> Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],
    Example[{Messages,"SampleAmountPrecision","Return a warning when SampleAmount is specified to unfeasible precision:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],SampleAmount->50.8298958298985 Microliter,Output->Options];
      Lookup[options,SampleAmount],
      51 Microliter,
      EquivalenceFunction -> Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables :> {options}
    ],
    Example[{Messages,"SuspensionSolutionVolumePrecision","Return a warning when SuspensionSolutionVolume is specified to unfeasible precision:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],SuspensionSolution->Model[Sample, "Mineral Oil"],SuspensionSolutionVolume->20.8298958298985 Microliter,Output->Options];
      Lookup[options,SuspensionSolutionVolume],
      21 Microliter,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    Example[{Messages,"BlankAmountsPrecision","Return a warning when BlanksAmount is specified to unfeasible precision:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],BlankAmounts->20.8298958298985 Milligram,Output->Options];
      Lookup[options,BlankAmounts],
      21 Milligram,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    Example[{Messages,"MaxWavelengthPrecision","Return a warning when MaxWavelength is specified to unfeasible precision:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MaxWavelength->15000.8925789259862689256 Nanometer,Output->Options];
      Lookup[options,MaxWavelength],
      15001 Nanometer,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    Example[{Messages,"MinWavelengthPrecision","Return a warning when MinWavelength is specified to unfeasible precision:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],MinWavelength->2000.8925789259862689256 Nanometer,Output->Options];
      Lookup[options,MinWavelength],
      2001 Nanometer,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    Example[{Messages,"IntegrationTimePrecision","Return a warning when IntegrationTime is specified to unfeasible precision:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],IntegrationTime->1.8925789259862689256 Minute,Output->Options];
      Lookup[options,IntegrationTime],
      1.9 Minute,
      EquivalenceFunction->Equal,
      Messages:>{
        Warning::InstrumentPrecision
      },
      Variables:>{options}
    ],
    Example[{Messages,"EmptyContainers","Return an error for a container without a sample:"},
      ExperimentIRSpectroscopy[Object[Container, Vessel, "Test container 3 (empty) for ExperimentIRSpectroscopy" <> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::EmptyContainers
      }
    ],
    Example[{Messages,"SuspensionSolutionResolved","Return a warning when a suspension solution is resolved, informing of the implications:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],SuspensionSolutionVolume->22 Microliter,Output->Options];
      Lookup[options,{SuspensionSolutionVolume,SuspensionSolution}],
      {EqualP[22 Microliter], ObjectReferenceP[Model[Sample, "id:kEJ9mqR8MnBe"]]},
      Messages:>{
        Warning::SuspensionSolutionResolved
      },
      Variables:>{options}
    ],

  (* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESNT BUG ON THIS. *)
    Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
      options=ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True, Output->Options];
      {Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
      {True,True,True,True},
      Variables :> {options}
    ],
    (*post processing options*)
    Example[{Options, MeasureVolume, "Indicate whether the SamplesIn should be volume measured after measurement conclusion:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MeasureVolume -> False, Output -> Options];
      Lookup[options, MeasureVolume],
      False,
      Variables :> {options}
    ],
    Example[{Options, MeasureWeight, "Indicate whether the SamplesIn should be weighed after measurement conclusion:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MeasureWeight -> False, Output -> Options];
      Lookup[options, MeasureWeight],
      False,
      Variables :> {options}
    ],
    Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for measurement:"},
      packet=First@ExperimentIRSpectroscopy[{"WaterSample Container 1", "WaterSample Container 2", "WaterSample Container 3","WaterSample Container 4"},
        PreparatoryUnitOperations -> {
          LabelContainer[Label->"WaterSample Container 1",Container->Model[Container, Vessel, "2mL Tube"]],
          LabelContainer[Label->"WaterSample Container 2",Container->Model[Container, Vessel, "2mL Tube"]],
          LabelContainer[Label->"WaterSample Container 3",Container->Model[Container, Vessel, "2mL Tube"]],
          LabelContainer[Label->"WaterSample Container 4",Container->Model[Container, Vessel, "2mL Tube"]],
          Transfer[Source->Model[Sample, "Milli-Q water"],Amount->1 Milliliter, Destination->"WaterSample Container 1"],
          Transfer[Source->Model[Sample, "Milli-Q water"],Amount->1 Milliliter, Destination->"WaterSample Container 2"],
          Transfer[Source->Model[Sample, "Milli-Q water"],Amount->1 Milliliter, Destination->"WaterSample Container 3"],
          Transfer[Source->Model[Sample, "Milli-Q water"],Amount->1 Milliliter,Destination->"WaterSample Container 4"]
        },
        Blanks -> {Null, Null, Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},MinWavenumber -> {2400/Centimeter, 2400/Centimeter, 400/Centimeter,Automatic},
        MaxWavenumber -> {5000/Centimeter, 5000/Centimeter, Automatic, Automatic}, NumberOfReadings -> 24, NumberOfReplicates -> 5,ImageSample -> False, MeasureVolume -> False, Upload -> False];
      Length[Lookup[packet,Replace[SamplesIn]]],
      20,
      Variables :> {packet}
    ],
    (* ExperimentIncubate tests. *)
    Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Incubate -> True, Output -> Options];
      Lookup[options, Incubate],
      True,
      Variables :> {options}
    ],
    Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
      Lookup[options, IncubationTemperature],
      40*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
      Lookup[options, IncubationTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
      Lookup[options, MaxIncubationTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
  (* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
    Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "Thermal-Lok  2510-1104"], Output -> Options];
      Lookup[options, IncubationInstrument],
      ObjectP[Model[Instrument, HeatBlock, "Thermal-Lok  2510-1104"]],
      Variables :> {options}
    ],
    Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
      Lookup[options, AnnealingTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], IncubateAliquot -> 1.5*Milliliter, Output -> Options];
      Lookup[options, IncubateAliquot],
      1.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, IncubateAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],

    Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Mix -> True, Output -> Options];
      Lookup[options, Mix],
      True,
      Variables :> {options}
    ],
    (* Note: You CANNOT be in a plate for the following test. *)
    Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MixType -> Shake, Output -> Options];
      Lookup[options, MixType],
      Shake,
      Variables :> {options}
    ],
    Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
      Lookup[options, MixUntilDissolved],
      True,
      Variables :> {options}
    ],

    (* ExperimentCentrifuge *)
    Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Centrifuge -> True, Output -> Options];
      Lookup[options, Centrifuge],
      True,
      Variables :> {options}
    ],
    (* Note: Put your sample in a 2mL tube for the following test. *)
    Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
      Lookup[options, CentrifugeInstrument],
      ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
      Variables :> {options}
    ],
    Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
      Lookup[options, CentrifugeIntensity],
      1000*RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
    Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
      Lookup[options, CentrifugeTime],
      5*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
      Lookup[options, CentrifugeTemperature],
      10*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
      Lookup[options, CentrifugeAliquot],
      1.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, CentrifugeAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],

  (* filter options *)
    Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Filtration -> True, Output -> Options];
      Lookup[options, Filtration],
      True,
      Variables :> {options}
    ],
    Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
      Lookup[options, FiltrationType],
      Syringe,
      Variables :> {options}
    ],
    Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
      Lookup[options, FilterInstrument],
      ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
      Variables :> {options}
    ],
    Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"], Output -> Options];
      Lookup[options, Filter],
      ObjectP[Model[Item,Filter,"Disk Filter, GxF/PTFE, 0.22um, 25mm"]],
      Variables :> {options}
    ],
    Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
      Lookup[options, FilterMaterial],
      PES,
      Variables :> {options}
    ],
    Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
      Lookup[options, PrefilterMaterial],
      GxF,
      Variables :> {options}
    ],
    Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
      Lookup[options, FilterPoreSize],
      0.22*Micrometer,
      Variables :> {options}
    ],
    Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
      Lookup[options, PrefilterPoreSize],
      1.*Micrometer,
      Variables :> {options}
    ],
    Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "id:AEqRl9Kz1VD1"], Output -> Options];
      Lookup[options, FilterSyringe],
      ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
      Variables :> {options}
    ],
    Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
      Lookup[options, FilterHousing],
      ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
      Variables :> {options}
    ],
    Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],  FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
      Lookup[options, FilterIntensity],
      1000*RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterAliquot -> 1 Milliliter, FiltrationType -> Centrifuge, FilterTime -> 5*Minute, Output -> Options];
      Lookup[options, FilterTime],
      5*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterAliquot -> 1 Milliliter,FiltrationType -> Centrifuge, FilterTemperature -> 22*Celsius, Output -> Options];
      Lookup[options, FilterTemperature],
      22*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterSterile -> True, Output -> Options];
      Lookup[options, FilterSterile],
      True,
      Variables :> {options}
    ],
    Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterAliquot -> 1.5*Milliliter, Output -> Options];
      Lookup[options, FilterAliquot],
      1.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, FilterAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, FilterContainerOut],
      {1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
      Variables :> {options}
    ],
  (* aliquot options *)
    Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Aliquot -> True, Output -> Options];
      Lookup[options, Aliquot],
      True,
      Variables :> {options}
    ],
    Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
      Lookup[options, AliquotAmount],
      0.08*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
      Lookup[options, AssayVolume],
      0.08*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], TargetConcentration -> 1*Micromolar, Output -> Options];
      Lookup[options, TargetConcentration],
      1*Micromolar,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], TargetConcentration -> 5 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Uracil"], Output -> Options];
      Lookup[options, TargetConcentrationAnalyte],
      ObjectP[Model[Molecule, "Uracil"]],
      Variables :> {options}
    ],
    Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, ConcentratedBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables :> {options}
    ],
    Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AliquotAmount->15*Milliliter,AssayVolume->30*Milliliter,AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, BufferDilutionFactor],
      10,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 15*Milliliter, AssayVolume ->30*Milliliter, AliquotContainer -> Model[Container, Vessel, "50mL Tube"],Output -> Options];
      Lookup[options, BufferDiluent],
      ObjectP[Model[Sample, "Milli-Q water"]],
      Variables :> {options}
    ],
    Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], AliquotAmount -> 0.1 Milliliter, AssayVolume -> 1 Milliliter, AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
      Lookup[options, AssayBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables :> {options}
    ],
    Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options, AliquotSampleStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],
    Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
      Lookup[options, ConsolidateAliquots],
      True,
      Variables :> {options}
    ],
    Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
      Lookup[options, AliquotPreparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "In Situ-1 Crystallization Plate"], Output -> Options];
      Lookup[options, AliquotContainer],
      {{1, ObjectP[Model[Container, Plate, "In Situ-1 Crystallization Plate"]]}},
      Variables :> {options}
    ],
    Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], ImageSample -> True, Output -> Options];
      Lookup[options, ImageSample],
      True,
      Variables :> {options}
    ],
    Example[{Options,IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], IncubateAliquotDestinationWell -> "A1", Output -> Options];
      Lookup[options,IncubateAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
      Lookup[options,CentrifugeAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
      Lookup[options,FilterAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options = ExperimentIRSpectroscopy[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
      Lookup[options,DestinationWell],
      {"A1"},
      Variables:>{options}
    ]
  },
  (* without this, telescope crashes and the test fails *)
  HardwareConfiguration->HighRAM,
  (* Every time a test is run, reset $CreatedObjects and erase things at the end *)

  (* Un-comment this out when Variables works the way we would expect it to *)
  (* Variables :> {$SessionUUID},*)

  SymbolSetUp :> (
    ClearMemoization[];
    $CreatedObjects = {};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[
      {
        (* Initial tear-down *)
        testObjList, existsFilter,
        (* Models *)
        modelIncompat, solidNoDensityModel, testModel,
        (* Bench *)
        testBench,
        (* Containers *)
        emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7,
        emptyContainer8, emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12, emptyContainer13,
        (* Samples *)
        discardedChemical, waterSample, lowVolSample, incompatibleSample, ethanolSample, ethanolSampleNoModel, ssSample,
        solidSample, solidNoDensitySample, sampleNoVolume, sampleNoMass, sampleNeither, sample1
      },

      (* Create a list of all objects that will be created in the SymbolSetUp *)
      testObjList = {
        (* Bench *)
        Object[Container, Bench, "Test bench for ExperimentIRSpectroscopy tests " <> $SessionUUID],
        (* Containers *)
        Object[Container, Vessel, "Test container 1 for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 2 for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 3 (empty) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 4 (too low volume) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 5 (incompatible) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 6 (ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 7 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 8 (Sodium phosphate solid) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 9 (solid with no density) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 10 (sample with no volume) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 11 (sample with no mass) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 12 (sample with no mass or volume) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Container, Vessel, "Test container 13 (sample with no model) for ExperimentIRSpectroscopy" <> $SessionUUID],
        (* Samples *)
        Object[Sample, "Test sample (discarded) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 3 (too low volume) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 4 (incompatible) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 4 (incompatible) for ExperimentIRSpectroscopy" <> $SessionUUID], (* haven't figured out why this needs to be deleted too *)
        Object[Sample, "Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 6 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 8 (solid sample with no density) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 9 (sample no volume) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 10 (sample no mass) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 11 (sample no mass nor volume) for ExperimentIRSpectroscopy" <> $SessionUUID],
        Object[Sample, "Test sample 12 (chemical, ethanol, no model) for ExperimentIRSpectroscopy" <> $SessionUUID],
        (* Models *)
        Model[Sample, "Test chemical model incompatible for ExperimentIRSpectroscopy" <> $SessionUUID],
        Model[Sample, "Test chemical solid model with no density for ExperimentIRSpectroscopy" <> $SessionUUID],
        Model[Sample, "Test chemical liquid model for ExperimentIRSpectroscopy" <> $SessionUUID],
        (* Protocol *)
        Object[Protocol, IRSpectroscopy, "Test Template Protocol for ExperimentIRSpectroscopy" <> $SessionUUID]
      };

      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      existsFilter = DatabaseMemberQ[testObjList];

      EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];

      Block[{$DeveloperUpload = True},
        {modelIncompat, solidNoDensityModel, testModel} = Upload[{
          <|
            Type -> Model[Sample],
            Name -> "Test chemical model incompatible for ExperimentIRSpectroscopy" <> $SessionUUID,
            State -> Liquid,
            Replace[Composition] -> {{Null, Null}},
            DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
            Append[IncompatibleMaterials] -> Platinum
          |>,
          <|
            Type -> Model[Sample],
            Name -> "Test chemical solid model with no density for ExperimentIRSpectroscopy" <> $SessionUUID,
            State -> Solid,
            Replace[Composition] -> {{Null,Null}},
            DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
          |>,
          <|
            Type -> Model[Sample],
            Name -> "Test chemical liquid model for ExperimentIRSpectroscopy" <> $SessionUUID,
            State -> Liquid,
            Replace[Composition] -> {{Null,Null}},
            DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
          |>
        }];

        (* Create test bench to put containers on *)
        testBench = Upload[
          <|
            Type -> Object[Container, Bench],
            Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
            Name -> "Test bench for ExperimentIRSpectroscopy tests " <> $SessionUUID,
            Site -> Link[$Site]
          |>
        ];

        (* Create some empty containers and put them on the bench *)
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
          emptyContainer11,
          emptyContainer12,
          emptyContainer13
        } = UploadSample[
          {
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"]
          },
          {
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench},
            {"Work Surface", testBench}
          },
          Name -> {
            "Test container 1 for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 2 for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 3 (empty) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 4 (too low volume) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 5 (incompatible) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 6 (ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 7 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 8 (Sodium phosphate solid) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 9 (solid with no density) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 10 (sample with no volume) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 11 (sample with no mass) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 12 (sample with no mass or volume) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test container 13 (sample with no model) for ExperimentIRSpectroscopy" <> $SessionUUID
          },
          Status -> Available
        ];

        (* Create some samples *)
        {
          discardedChemical,
          waterSample,
          lowVolSample,
          incompatibleSample,
          ethanolSample,
          ethanolSampleNoModel,
          ssSample,
          solidSample,
          solidNoDensitySample,
          sampleNoVolume,
          sampleNoMass,
          sampleNeither
        } = UploadSample[
          {
            Model[Sample, StockSolution, "Red Food Dye Test Solution"],
            Model[Sample, StockSolution, "Red Food Dye Test Solution"],
            Model[Sample, StockSolution, "Red Food Dye Test Solution"],
            modelIncompat,
            Model[Sample, "id:Y0lXejGKdEDW"],
            Model[Sample, "id:Y0lXejGKdEDW"],
            Model[Sample,StockSolution,"pH 2 Buffer Solution"],
            Model[Sample, "Dibasic Sodium Phosphate"],
            solidNoDensityModel,
            testModel,
            testModel,
            testModel
          },
          {
            {"A1", emptyContainer1},
            {"A1", emptyContainer2},
            {"A1", emptyContainer4},
            {"A1", emptyContainer5},
            {"A1", emptyContainer6},
            {"A1", emptyContainer13},
            {"A1", emptyContainer7},
            {"A1", emptyContainer8},
            {"A1", emptyContainer9},
            {"A1", emptyContainer10},
            {"A1", emptyContainer11},
            {"A1", emptyContainer12}
          },
          InitialAmount -> {
            50 Milliliter,
            50 Milliliter,
            5 Microliter,
            50 Milliliter,
            50 Milliliter,
            50 Milliliter,
            50 Milliliter,
            10 Gram,
            5 Gram,
            5 Gram,
            5 Milliliter,
            Null
          },
          Name -> {
            "Test sample (discarded) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 2 (red food dye) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 3 (too low volume) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 4 (incompatible) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 5 (chemical, ethanol) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 12 (chemical, ethanol, no model) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 6 (stock solution with water solvent) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 7 (solid sample) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 8 (solid sample with no density) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 9 (sample no volume) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 10 (sample no mass) for ExperimentIRSpectroscopy" <> $SessionUUID,
            "Test sample 11 (sample no mass nor volume) for ExperimentIRSpectroscopy" <> $SessionUUID
          }
        ];

        (* Make some changes to our samples to make them invalid *)
        Upload[{
          <|Object -> discardedChemical, Status -> Discarded, DeveloperObject -> True|>,
          <|Object -> waterSample,
            Replace[Composition] -> {
              {100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
              {5 Micromolar, Link[Model[Molecule, "Uracil"]], Now}
            },
            DeveloperObject->True|>,
          <|Object -> lowVolSample, DeveloperObject -> True|>,
          <|Object -> incompatibleSample, DeveloperObject -> True|>,
          <|Object -> ethanolSample, DeveloperObject -> True|>,
          <|Object -> ssSample, DeveloperObject -> True|>,
          <|Object -> solidSample, DeveloperObject -> True|>,
          <|Object -> solidNoDensitySample, DeveloperObject -> True|>,
          <|Object -> sampleNoVolume, DeveloperObject -> True|>,
          <|Object -> sampleNoMass, DeveloperObject -> True|>,
          <|Object -> sampleNeither, DeveloperObject -> True|>,
          <|Object -> ethanolSampleNoModel, Model -> Null, DeveloperObject -> True|>
        }];

        sample1 = waterSample;

        (* Create a protocol that we'll use for template testing *)
        Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
        (* Create a protocol that we'll use for template testing *)
          templateIRSpectroscopyProtocol = ExperimentIRSpectroscopy[sample1,
            Blanks -> Null,
            Name -> "Test Template Protocol for ExperimentIRSpectroscopy" <> $SessionUUID]
        ]
      ]
    ]
  ),

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
  ),

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $DeveloperUpload = True
  }
];




DefineTests[
  ExperimentIRSpectroscopyOptions,
  {
    Example[{Basic, "Display the option values which will be used in the experiment: "},
      ExperimentIRSpectroscopyOptions[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopyOptions " <> $SessionUUID]],
      _Grid
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed: "},
      ExperimentIRSpectroscopyOptions[Object[Sample, "Test sample (discarded) for ExperimentIRSpectroscopyOptions " <> $SessionUUID]],
      _Grid,
      Messages :> {
        Error::DiscardedSamples,
        Error::InvalidInput
      }
    ],
    Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options: "},
      ExperimentIRSpectroscopyOptions[Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopyOptions " <> $SessionUUID], OutputFormat -> List],
      {(_Rule | _RuleDelayed)..}
    ]
  },
  SymbolSetUp :> (
    ClearMemoization[];
    $CreatedObjects = {};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];
    Module[{testObjList, existsFilter, testBench, emptyContainer1, emptyContainer2, discardedChemical, waterSample},
      testObjList = {
        Object[Container, Bench, "Test bench for ExperimentIRSpectroscopyOptions " <> $SessionUUID],
        Object[Container, Vessel, "Test container 1 for ExperimentIRSpectroscopyOptions " <> $SessionUUID],
        Object[Container, Vessel, "Test container 2 for ExperimentIRSpectroscopyOptions " <> $SessionUUID],
        Object[Sample, "Test sample (discarded) for ExperimentIRSpectroscopyOptions " <> $SessionUUID],
        Object[Sample, "Test sample 2 (red food dye) for ExperimentIRSpectroscopyOptions " <> $SessionUUID]
      };

      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      existsFilter = DatabaseMemberQ[testObjList];

      EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];

      Block[{$DeveloperUpload = True},
        (* Create a test bench *)
        testBench = Upload[
          <|
            Type -> Object[Container, Bench],
            Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
            Name -> "Test bench for ExperimentIRSpectroscopyOptions " <> $SessionUUID
          |>
        ];

        (* Create some empty test containers and put them on the test bench *)
        {emptyContainer1, emptyContainer2} = UploadSample[
          {
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"]
          },
          {
            {"Work Surface", testBench},
            {"Work Surface", testBench}
          },
          Name -> {
            "Test container 1 for ExperimentIRSpectroscopyOptions " <> $SessionUUID,
            "Test container 2 for ExperimentIRSpectroscopyOptions " <> $SessionUUID
          },
          Status -> {
            Available,
            Available
          }
        ];

        (* Create some samples and put them in the test containers *)
        {discardedChemical, waterSample} = UploadSample[
          {
            Model[Sample, StockSolution, "Red Food Dye Test Solution"],
            Model[Sample, StockSolution, "Red Food Dye Test Solution"]
          },
          {
            {"A1", emptyContainer1},
            {"A1", emptyContainer2}
          },
          InitialAmount -> {
            50 Milliliter,
            50 Milliliter
          },
          Name -> {
            "Test sample (discarded) for ExperimentIRSpectroscopyOptions " <> $SessionUUID,
            "Test sample 2 (red food dye) for ExperimentIRSpectroscopyOptions " <> $SessionUUID
          }
        ];

        (* Make some changes to our samples to make them invalid. *)

        Upload[{
          <|Object -> emptyContainer1|>,
          <|Object -> emptyContainer2|>,
          <|Object -> discardedChemical, Status -> Discarded, DeveloperObject -> True|>,
          <|Object -> waterSample, Concentration -> 10 Micromolar, DeveloperObject -> True|>}
        ]
      ];
    ]
  ),

  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
  ),

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"],
    $DeveloperUpload = True
  }
];

DefineTests[
  ValidExperimentIRSpectroscopyQ,
  {
    Example[{Basic,"Verify that the experiment can be run without issues:"},
      ValidExperimentIRSpectroscopyQ[Object[Sample,"Test sample 2 (red food dye) for ValidExperimentIRSpectroscopyQ" <> $SessionUUID]],
      True
    ],
    Example[{Basic,"Return False if there are problems with the inputs or options:"},
      ValidExperimentIRSpectroscopyQ[Object[Sample,"Test sample (discarded) for ValidExperimentIRSpectroscopyQ" <> $SessionUUID]],
      False
    ],
    Example[{Options,OutputFormat,"Return a test summary:"},
      ValidExperimentIRSpectroscopyQ[Object[Sample,"Test sample 2 (red food dye) for ValidExperimentIRSpectroscopyQ" <> $SessionUUID],OutputFormat->TestSummary],
      _EmeraldTestSummary
    ],
    Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
      ValidExperimentIRSpectroscopyQ[Object[Sample,"Test sample 2 (red food dye) for ValidExperimentIRSpectroscopyQ" <> $SessionUUID],Verbose->True],
      True
    ]
  },

  SymbolSetUp:>(
    ClearMemoization[];
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{testObjList, existsFilter, testBench, emptyContainer1, emptyContainer2, discardedChemical, waterSample},

      testObjList={
        Object[Container, Vessel, "Test container 1 for ValidExperimentIRSpectroscopyQ" <> $SessionUUID],
        Object[Container, Vessel, "Test container 2 for ValidExperimentIRSpectroscopyQ" <> $SessionUUID],

        Object[Sample, "Test sample (discarded) for ValidExperimentIRSpectroscopyQ" <> $SessionUUID],
        Object[Sample, "Test sample 2 (red food dye) for ValidExperimentIRSpectroscopyQ" <> $SessionUUID]

      };
      (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
      (* Erase any objects that we failed to erase in the last unit test. *)
      existsFilter=DatabaseMemberQ[testObjList];

      EraseObject[PickList[testObjList, existsFilter], Force->True, Verbose->False];

      Block[{$DeveloperUpload = True},
        testBench = Upload[
          <|
            Type -> Object[Container, Bench],
            Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
            Name -> "Test bench for ValidExperimentIRSpectroscopyQ tests " <> $SessionUUID,
            Site -> Link[$Site]
          |>
        ];

        (* Create some empty containers *)
        {emptyContainer1, emptyContainer2} = UploadSample[
          {
            Model[Container, Vessel, "50mL Tube"],
            Model[Container, Vessel, "50mL Tube"]
          },
          {
            {"Work Surface", testBench},
            {"Work Surface", testBench}
          },
          Name -> {
            "Test container 1 for ValidExperimentIRSpectroscopyQ" <> $SessionUUID,
            "Test container 2 for ValidExperimentIRSpectroscopyQ" <> $SessionUUID
          }
        ];

        (* Create some samples *)
        {discardedChemical, waterSample} = ECL`InternalUpload`UploadSample[
          {
            Model[Sample, StockSolution, "Red Food Dye Test Solution"],
            Model[Sample, StockSolution, "Red Food Dye Test Solution"]
          },
          {
            {"A1", emptyContainer1}, {"A1", emptyContainer2}
          },
          InitialAmount->{50 Milliliter, 50 Milliliter},
          Name->{
            "Test sample (discarded) for ValidExperimentIRSpectroscopyQ" <> $SessionUUID,
            "Test sample 2 (red food dye) for ValidExperimentIRSpectroscopyQ" <> $SessionUUID
          }
        ];

        (* Make some changes to our samples to make them invalid. *)
        Upload[{
          <|Object->discardedChemical, Status->Discarded, DeveloperObject->True|>,
          <|Object->waterSample, Concentration->10*Micromolar, DeveloperObject->True|>
        }]
      ]
    ]
  ),

  SymbolTearDown:>(
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];
    EraseObject[$CreatedObjects,Force->True,Verbose->False];
  ),

  Stubs :> {
    $PersonID = Object[User, "Test user for notebook-less test protocols"]
  }
];

DefineTests[
  ExperimentIRSpectroscopyPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentIRSpectroscopy:"},
      ExperimentIRSpectroscopyPreview[Object[Sample,"Test sample 2 (red food dye) for ExperimentIRSpectroscopyPreview"<>$SessionUUID]],
      Null
    ],
    Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentIRSpectroscopyOptions:"},
      ExperimentIRSpectroscopyOptions[Object[Sample,"Test sample 2 (red food dye) for ExperimentIRSpectroscopyPreview"<>$SessionUUID]],
      _Grid
    ],
    Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentIRSpectroscopyQ:"},
      ValidExperimentIRSpectroscopyQ[Object[Sample,"Test sample 2 (red food dye) for ExperimentIRSpectroscopyPreview"<>$SessionUUID]],
      True
    ]
  },
  SymbolSetUp:>(
    ClearMemoization[];
    $CreatedObjects={};

    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    testObjList={
      Object[Container, Bench, "Test bench for ExperimentIRSpectroscopyPreview tests"<> $SessionUUID],

      Object[Container,Vessel,"Test container 1 for ExperimentIRSpectroscopyPreview"<>$SessionUUID],
      Object[Container,Vessel,"Test container 2 for ExperimentIRSpectroscopyPreview"<>$SessionUUID],

      Object[Sample,"Test sample (discarded) for ExperimentIRSpectroscopyPreview"<>$SessionUUID],
      Object[Sample,"Test sample 2 (red food dye) for ExperimentIRSpectroscopyPreview"<>$SessionUUID]

    };
    (* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
    (* Erase any objects that we failed to erase in the last unit test. *)
    existsFilter=DatabaseMemberQ[testObjList];

    EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];

    Block[{$DeveloperUpload = True},
      (* Create a test bench *)
      testBench = Upload[<|
        Type -> Object[Container, Bench],
        Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
        Name -> "Test bench for ExperimentIRSpectroscopyPreview tests"<> $SessionUUID,
        Site -> Link[$Site]
      |>];

      (* Create some empty containers *)
      {emptyContainer1,emptyContainer2}=UploadSample[
        {Model[Container,Vessel,"50mL Tube"],Model[Container,Vessel,"50mL Tube"]},
        {{"Work Surface", testBench}, {"Work Surface", testBench}},
        Name->{"Test container 1 for ExperimentIRSpectroscopyPreview"<>$SessionUUID, "Test container 2 for ExperimentIRSpectroscopyPreview"<>$SessionUUID}
      ];

      (* Create some samples *)
      {discardedChemical,waterSample}=ECL`InternalUpload`UploadSample[
        {
          Model[Sample, StockSolution, "Red Food Dye Test Solution"],
          Model[Sample, StockSolution, "Red Food Dye Test Solution"]
        },
        {
          {"A1",emptyContainer1},{"A1",emptyContainer2}
        },
        InitialAmount->{50 Milliliter,50 Milliliter},
        Name->{
          "Test sample (discarded) for ExperimentIRSpectroscopyPreview"<>$SessionUUID,
          "Test sample 2 (red food dye) for ExperimentIRSpectroscopyPreview"<>$SessionUUID
        }
      ];

      (* Make some changes to our samples to make them invalid. *)

      Upload[{
        <|Object->discardedChemical,Status->Discarded|>,
        <|Object->waterSample,Concentration->10*Micromolar|>
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
];
