(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentRamanSpectroscopy*)


DefineTests[ExperimentRamanSpectroscopy,
  {
    Example[{Basic, "Perform Raman spectroscopy on a single sample:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"]
      ],
      ObjectP[Object[Protocol, RamanSpectroscopy]],
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Perform Raman spectroscopy on multiple samples:"},
      ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"],
          Object[Sample,"RamanSpectroscopy Test Liquid 1"],
          Object[Sample,"RamanSpectroscopy Test Liquid 2"],
          Object[Sample,"RamanSpectroscopy Test Liquid 3"]
        }
      ],
      ObjectP[Object[Protocol, RamanSpectroscopy]],
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Perform Raman spectroscopy on a single container:"},
      ExperimentRamanSpectroscopy[
        Object[Container, Vessel, "Fake container 1 for RamanSpectroscopy tests" <> $SessionUUID]
      ],
      ObjectP[Object[Protocol, RamanSpectroscopy]],
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],


    (* ============= *)
    (* == OPTIONS == *)
    (* ============= *)

    Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the amount of an input Model[Sample] and the container in which it is to be prepared:"},
      options = ExperimentRamanSpectroscopy[
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

    (* -- Aliquoting Options -- *)

    Example[{Options, AliquotSampleLabel, "Set the AliquotSampleLabel option:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 1"], Aliquot -> True,AliquotSampleLabel -> "Water Aliquot", Output -> Options];
      Lookup[options, AliquotSampleLabel],
      {"Water Aliquot"},
      Variables :> {options}
    ],

    (* -- SampleType -- *)

    Example[{Options, SampleType, "Automatically resolve the SampleType based on the input object:"},
      options = ExperimentRamanSpectroscopy[
        {Object[Sample,"RamanSpectroscopy Test Solid 1"], Object[Sample,"RamanSpectroscopy Test Liquid 1"], Object[Sample,"RamanSpectroscopy Test Tablet 1"]},
        Output -> Options
      ];
      Lookup[options, SampleType],
      {Powder, Liquid, Tablet},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options},
      Messages:>{Error::IncompatibleRamanSampleTypes, Error::InvalidOption}
    ],
    Example[{Options, SampleType, "Automatically resolve the SampleType based on the PreparatoryPrimitive options:"},
      options = ExperimentRamanSpectroscopy[
        {"dissolved solid", Object[Sample,"RamanSpectroscopy Test Tablet 1"], Object[Sample,"RamanSpectroscopy Test Tablet 2"]},

        PreparatoryUnitOperations->{
          LabelContainer[
            Label->"dissolved solid",
            Container->Model[Container, Vessel, "id:bq9LA0dBGGR6"]
          ],
          Transfer[
            Source->Object[Sample,"RamanSpectroscopy Test Solid 1"],
            Amount->0.2 Gram,
            Destination->{"A1", "dissolved solid"}
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Amount->0.5 Milliliter,
            Destination->{"A1", "dissolved solid"}
          ]
        },
        TabletProcessing -> {Null, Whole, Grind},
        Output -> Options
      ];
      Lookup[options, SampleType],
      {Liquid, Tablet, Powder},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options},
      Messages:>{Error::IncompatibleRamanSampleTypes, Error::InvalidOption},
      TimeConstraint -> 500
    ],
    Example[{Options, SampleType, "Automatically resolve the SampleType for a tablet:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        Output -> Options
      ];
      Lookup[options, SampleType],
      Tablet,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SampleType, "Automatically resolve the SampleType based on the TabletProcessing options:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        TabletProcessing -> {Grind},
        Output -> Options
      ];
      Lookup[options, SampleType],
      Powder,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SampleType, "Specify the SampleType to match the input type or to call TabletProcessing options:"},
      options = ExperimentRamanSpectroscopy[
        {Object[Sample,"RamanSpectroscopy Test Tablet 1"], Object[Sample,"RamanSpectroscopy Test Tablet 1"]},
        SampleType -> {Powder, Tablet},
        Output -> Options
      ];
      Lookup[options, TabletProcessing],
     {Grind, Whole},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options},
      Messages:>{Error::IncompatibleRamanSampleTypes, Error::InvalidOption}
    ],


    (* -- TabletProcessing -- *)

    Example[{Options, TabletProcessing, "Automatically resolve the TabletProcessing option based on the type of input samples:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        Output -> Options
      ];
      Lookup[options, TabletProcessing],
      Whole,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, TabletProcessing, "Automatically resolve the TabletProcessing option based on the type of input samples and SampleType:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SampleType -> Powder,
        Output -> Options
      ];
      Lookup[options, TabletProcessing],
      Grind,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, TabletProcessing, "Set the TabletProcessing option to measure a cut or whole tablet:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Tablet 1"],
          Object[Sample,"RamanSpectroscopy Test Tablet 2"],
          Object[Sample,"RamanSpectroscopy Test Tablet 3"]
        },
        TabletProcessing -> {LargestCrossSection, SmallestCrossSection, Whole},
        Output -> Options
      ];
      Lookup[options, TabletProcessing],
      {LargestCrossSection, SmallestCrossSection, Whole},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- Instrument -- *)
    Example[{Options, Instrument, "Set the spectrometer used for the Raman Spectroscopy protocol:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        Instrument -> Model[Instrument, RamanSpectrometer, "THz Raman WPS"],
        Output -> Options];
      Lookup[options, Instrument],
      ObjectP[Model[Instrument, RamanSpectrometer, "THz Raman WPS"]],
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- CalibrationCheck -- *)
    Example[{Options, CalibrationCheck, "Include an internal calibration check with a PMMA standard prior to any measurments:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        CalibrationCheck -> True,
        Output -> Options];
      Lookup[options, CalibrationCheck],
      True,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- ReadPattern -- *)
    Example[{Options, ReadPattern, "Set the sequence in which the wells will be read:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        ReadPattern -> Row,
        Output -> Options];
      Lookup[options, ReadPattern],
      Row,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- ReadRestTime -- *)
    Example[{Options, ReadRestTime, "Set the time in between sampling patterns for repeated measurement of each sample:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        ReadRestTime -> {2 Second, 1 Second},
        Output -> Options];
      Lookup[options, ReadRestTime],
      {2 Second, 1 Second},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- NumberOfReads -- *)
    Example[{Options, NumberOfReads, "Set the number of times the sampling patterns is repeated for each sample:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        NumberOfReads -> {3, 5},
        Output -> Options];
      Lookup[options, NumberOfReads],
      {3,5},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- BackgroundRemove -- *)
    Example[{Options, BackgroundRemove, "Set BackgroundRemove to subtract the dark background from each sample:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        BackgroundRemove -> {True, False},
        Output -> Options];
      Lookup[options, BackgroundRemove],
      {True, False},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- CosmicRadiationFilter -- *)
    Example[{Options, CosmicRadiationFilter, "Set CosmicRadiationFilter to remove features realted to cosmic radiation from each sample:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        CosmicRadiationFilter -> {True, False},
        Output -> Options];
      Lookup[options, CosmicRadiationFilter],
      {True, False},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* ------------------ *)
    (* -- OPTIMIZATION -- *)
    (* ------------------ *)

    (* -- LaserPower -- *)

    Example[{Options, LaserPower, "Set LaserPower -> Optimize to have it adjusted before the sample measurement:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Liquid 1"],
        LaserPower -> Optimize,
        Output -> Options
      ];
      Lookup[options, LaserPower],
      Optimize,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, LaserPower, "Set LaserPower to a fixed percentage of the maximum power:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Liquid 1"],
        LaserPower -> 20 Percent,
        Output -> Options
      ];
      Lookup[options, LaserPower],
      20 Percent,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- ExposureTime -- *)

    Example[{Options, ExposureTime, "Set the exposure time for the CCD decetor:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        ExposureTime -> 100 Millisecond,
        Output -> Options];
      Lookup[options, ExposureTime],
      100 Millisecond,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- AdjustmentSample -- *)

    Example[{Options, AdjustmentSample, "Specify an adjustment sample to optimize the LaserPower and ExposureTime for a given sample:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        AdjustmentSample -> {Null, Object[Sample,"RamanSpectroscopy Test Solid 2"]},
        LaserPower -> {20 Percent, Optimize},
        ExposureTime -> {100 Millisecond, Optimize},
        Output -> Options
      ];
      Lookup[options, AdjustmentSample],
      {
        Null,
        ObjectP[Object[Sample,"RamanSpectroscopy Test Solid 2"]]
      },
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, AdjustmentSample, "Specify that the LaserPower and ExposureTime are to be optimized using the sample itself:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        AdjustmentSample -> All,
        LaserPower -> Optimize,
        ExposureTime -> Optimize,
        Output -> Options
      ];
      Lookup[options, AdjustmentSample],
      {
        ObjectP[Object[Sample,"RamanSpectroscopy Test Solid 1"]],
        ObjectP[Object[Sample,"RamanSpectroscopy Test Solid 2"]]
      },
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, AdjustmentSample, "Automatically resolve AdjustmentSample based on the value of LaserPower or ExposureTime:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        LaserPower -> {Optimize, Optimize},
        ExposureTime -> {Optimize, Optimize},
        Output -> Options
      ];
      Lookup[options, AdjustmentSample],
      {
        ObjectP[Object[Sample,"RamanSpectroscopy Test Solid 1"]],
        ObjectP[Object[Sample,"RamanSpectroscopy Test Solid 2"]]
      },
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, AdjustmentSample, "Set AdjustmentSample to a member of Blank for SamplesIn:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        AdjustmentSample -> {Object[Sample,"RamanSpectroscopy Test Solid 1"], Object[Sample, "RamanSpectroscopy Test Solid 3"]},
        Blank -> {Window, Object[Sample, "RamanSpectroscopy Test Solid 3"]},
        LaserPower -> {Optimize, Optimize},
        Output -> Options
      ];
      Lookup[options, AdjustmentSample],
      {ObjectP[Object[Sample,"RamanSpectroscopy Test Solid 1"]], ObjectP[Object[Sample, "RamanSpectroscopy Test Solid 3"]]},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- AdjustmentTarget -- *)

    Example[{Options, AdjustmentTarget, "Set AdjustmentTarget to specify the desired maximum intensity as a percentage of the detector saturation value:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        LaserPower->Optimize,
        AdjustmentTarget -> {60 Percent, 20 Percent},
        Output -> Options
      ];
      Lookup[options, AdjustmentTarget],
      {60 Percent, 20 Percent},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, AdjustmentTarget, "Automatically resolve the AdjustmentTarget based on the values of LaserPower and ExposureTime:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        LaserPower -> {Optimize, 20 Percent, 20 Percent},
        ExposureTime -> {100 Millisecond, Optimize, 50 Millisecond},
        Output -> Options
      ];
      Lookup[options, AdjustmentTarget],
      {50 Percent, 50 Percent, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- AdjustmentEmissionWavelength -- *)

    Example[{Options, AdjustmentEmissionWavelength, "Automatically resolve the AdjustmentEmissionWavelength based on the LaserPower and ExposureTime:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        LaserPower -> {Optimize, 20 Percent, 20 Percent},
        ExposureTime -> {100 Millisecond, Optimize, 100 Millisecond},
        Output -> Options
      ];
      Lookup[options, AdjustmentEmissionWavelength],
      {Max,Max, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, AdjustmentEmissionWavelength, "Set the AdjustmentEmissionWavelength to indicate the wavelength used for adjusting the ExposureTime and/or LaserPower:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        LaserPower -> {Optimize, 20 Percent},
        AdjustmentSample -> {Object[Sample,"RamanSpectroscopy Test Solid 1"],Null},
        AdjustmentEmissionWavelength -> {Max, Null},
        Output -> Options
      ];
      Lookup[options, AdjustmentEmissionWavelength],
      {Max, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* ------------------- *)
    (* -- OPTICAL IMAGE -- *)
    (* ------------------- *)

    (* -- InvertedMicroscopeImage -- *)

    Example[{Options, InvertedMicroscopeImage, "Set the InvertedMicroscopeImage to indicate if optical imaging is to be performed on a given sample:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        InvertedMicroscopeImage -> {False, True},
        Output -> Options
      ];
      Lookup[options, InvertedMicroscopeImage],
      {False, True},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, InvertedMicroscopeImage, "Automatically set InvertedMicroscopeImage to True when the image parameters are specified:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        MicroscopeImageLightIntensity -> {20 Percent, 50 Percent},
        Output -> Options
      ];
      Lookup[options, InvertedMicroscopeImage],
      True,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, InvertedMicroscopeImage, "Automatically set InvertedMicroscopeImage to True when the image parameters are specified:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        MicroscopeImageExposureTime -> {1 Millisecond, 10 Millisecond},
        Output -> Options
      ];
      Lookup[options, InvertedMicroscopeImage],
      True,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- MicroscopeImageLightIntensity -- *)

    Example[{Options, MicroscopeImageLightIntensity, "Set the LED brightness using MicroscopeImageLightIntenity:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        MicroscopeImageLightIntensity -> {10 Percent, 20 Percent},
        Output -> Options
      ];
      Lookup[options, MicroscopeImageLightIntensity],
      {10 Percent, 20 Percent},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, MicroscopeImageLightIntensity, "The LED brightness will be rounded to match the instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        MicroscopeImageLightIntensity -> {10.3 Percent, 20 Percent},
        Output -> Options
      ];
      Lookup[options, MicroscopeImageLightIntensity],
      {10 Percent, 20 Percent},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, MicroscopeImageLightIntensity, "Automatically resolve the MicroscopeImageLightIntensity based on InvertedMicroscopeImage:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        InvertedMicroscopeImage -> {True, False},
        Output -> Options
      ];
      Lookup[options, MicroscopeImageLightIntensity],
      {10 Percent, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- MicroscopeImageExposureTime -- *)

    Example[{Options, MicroscopeImageExposureTime, "Set the exposure time for optical imaging using MicroscopeImageExposureTime:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        MicroscopeImageExposureTime -> {Optimize, 10 Millisecond},
        Output -> Options
      ];
      Lookup[options, MicroscopeImageExposureTime],
      {Optimize, 10 Millisecond},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, MicroscopeImageExposureTime, "The exposure time for optical imaging using MicroscopeImageExposureTime is rounded to match the instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        MicroscopeImageExposureTime -> {10.501 Millisecond, 10 Millisecond},
        Output -> Options
      ];
      Lookup[options, MicroscopeImageExposureTime],
      {11 Millisecond, 10 Millisecond},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, MicroscopeImageExposureTime, "Automatically resolve MicroscopeImageExposureTime based on InvertedMicroscopeImage:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        InvertedMicroscopeImage -> {True, False},
        Output -> Options
      ];
      Lookup[options, MicroscopeImageExposureTime],
      {Optimize, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],


    (* ------------ *)
    (* -- OPTICS -- *)
    (* ------------ *)

    (* -- FloodLight -- *)

    Example[{Options, FloodLight, "Set the FloodLight option to perform measurements using a ~1 mm spot size:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        FloodLight -> True,
        Output -> Options
      ];
      Lookup[options, FloodLight],
      True,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, FloodLight, "Automatically resolve the FloodLight option based on the value of ObjectiveMagnification:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        ObjectiveMagnification -> Null,
        Output -> Options
      ];
      Lookup[options, FloodLight],
      True,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],


    (* -- ObjectiveMagnification -- *)

    Example[{Options, ObjectiveMagnification,"Set the ObjectiveMagnification to increase or decrease the spot size:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        ObjectiveMagnification -> 10,
        Output -> Options
      ];
      Lookup[options, ObjectiveMagnification],
      10,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, ObjectiveMagnification, "Set the ObjectiveMagnification for each sample to control the beam spot size:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        ObjectiveMagnification -> {20, 10, 4},
        Output -> Options
      ];
      Lookup[options, ObjectiveMagnification],
      {20,10,4},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, ObjectiveMagnification, "Automatically resolve the ObjectiveMagnification based on the value of FloodLight and InvertedMicroscopeImage:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        FloodLight -> {True, True, False},
        InvertedMicroscopeImage -> {True, False, False},
        Output -> Options
      ];
      Lookup[options, ObjectiveMagnification],
      {2, Null, 10},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],



    (* ----------------------- *)
    (* -- SAMPLING PATTERNS -- *)
    (* ----------------------- *)


    (* -- SamplingPattern -- *)

    Example[{Options, SamplingPattern, "Set the SamplingPattern uniquely for each sample:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        SamplingPattern -> {
          SinglePoint,
          Spiral,
          Grid
        },
        Output -> Options
      ];
      Lookup[options, SamplingPattern],
      {SinglePoint, Spiral, Grid},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SamplingPattern, "Set a single SamplingPattern for all given samples:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        SamplingPattern -> Spiral,
        Output -> Options
      ];
      Lookup[options, SamplingPattern],
      Spiral,
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],


    (* -- SamplingTime -- *)

    Example[{Options, SamplingTime, "Set the sampling time for SamplingPattern -> Spiral or FilledSquare:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        SamplingPattern -> {Spiral, FilledSquare, SinglePoint},
        SamplingTime -> {100 Second, 200 Second, Null},
        Output -> Options
      ];
      Lookup[options, SamplingTime],
      {100 Second, 200 Second, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SamplingTime, "Automatically resolve SamplingTime based on the SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        SamplingPattern -> {Spiral, FilledSquare, SinglePoint},
        Output -> Options
      ];
      Lookup[options, SamplingTime],
      {600 Second, 600 Second, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- SpiralInnerDiameter -- *)

    Example[{Options, SpiralInnerDiameter, "Set the inner diameter of a Spiral or FilledSpiral SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        SamplingPattern -> {Spiral, FilledSpiral, SinglePoint},
        SpiralInnerDiameter -> {100 Micrometer, 100 Micrometer, Null},
        Output -> Options
      ];
      Lookup[options, SpiralInnerDiameter],
      {100 Micrometer, 100 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SpiralInnerDiameter, "The inner diameter of a Spiral or FilledSpiral SamplingPattern is rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"]
        },
        SamplingPattern -> {Spiral},
        SpiralInnerDiameter -> {100.005 Micrometer},
        Output -> Options
      ];
      Lookup[options, SpiralInnerDiameter],
      {100 Micrometer},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, SpiralInnerDiameter, "Automatically resolve the SpiralInnerDiameter based on the SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        SamplingPattern -> {Spiral, FilledSpiral, SinglePoint},
        Output -> Options
      ];
      Lookup[options, SpiralInnerDiameter],
      {50 Micrometer, 50 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SpiralInnerDiameter, "Automatically resolve the SpiralInnerDiameter based on the SamplingPattern and SpiralOuterDiameter:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Spiral, FilledSpiral},
        SpiralOuterDiameter -> {30 Micrometer, 90 Micrometer},
        Output -> Options
      ];
      Lookup[options, SpiralInnerDiameter],
      {1 Micrometer, 1 Micrometer},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- SpiralOuterDiameter -- *)

    Example[{Options, SpiralOuterDiameter, "Set the outer diameter of a Spiral or FilledSpiral SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        SamplingPattern -> {Spiral, FilledSpiral, SinglePoint},
        SpiralOuterDiameter -> {200 Micrometer, 600 Micrometer, Null},
        Output -> Options
      ];
      Lookup[options, SpiralOuterDiameter],
      {200 Micrometer, 600 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SpiralOuterDiameter, "The outer diameter of a Spiral or FilledSpiral SamplingPattern is rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"]
        },
        SamplingPattern -> {Spiral},
        SpiralOuterDiameter -> {400.005 Micrometer},
        Output -> Options
      ];
      Lookup[options, SpiralOuterDiameter],
      {400 Micrometer},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, SpiralOuterDiameter, "Automatically resolve the SpiralOuterDiameter based on the SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"]
        },
        SamplingPattern -> {Spiral, FilledSpiral, SinglePoint},
        Output -> Options
      ];
      Lookup[options, SpiralOuterDiameter],
      {200 Micrometer, 200 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SpiralOuterDiameter, "Automatically resolve the SpiralOuterDiameter based on the SamplingPattern and SpiralInnerDiameter:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Spiral, FilledSpiral},
        SpiralInnerDiameter -> {400 Micrometer, 100 Micrometer},
        Output -> Options
      ];
      Lookup[options, SpiralOuterDiameter],
      {600 Micrometer, 300 Micrometer},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],


    (* -- SpiralFillArea -- *)

    Example[{Options, SpiralFillArea, "Set the percent coverage of a FilledSpiral SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {FilledSpiral, SinglePoint},
        SpiralFillArea -> {120 Percent, Null},
        Output -> Options
      ];
      Lookup[options, SpiralFillArea],
      {120 Percent, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SpiralFillArea, "The percent coverage of a FilledSpiral SamplingPattern is rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> FilledSpiral,
        SpiralFillArea -> {120.00123 Percent, 100.4 Percent},
        Output -> Options
      ];
      Lookup[options, SpiralFillArea],
      {120 Percent, 100 Percent},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, SpiralFillArea, "Automatically resolve the SpiralFillArea based on the SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {FilledSpiral, SinglePoint},
        Output -> Options
      ];
      Lookup[options, SpiralFillArea],
      {60 Percent, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],


    (* -- SpiralResolution -- *)

    Example[{Options, SpiralResolution, "Set the distance between consecutive measurement points in the FilledSpiral pattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {FilledSpiral, SinglePoint},
        SpiralResolution -> {1 Micrometer, Null},
        Output -> Options
      ];
      Lookup[options, SpiralResolution],
      {1 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SpiralResolution, "The distance between consecutive measurement points in the FilledSpiral pattern is rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> FilledSpiral,
        SpiralResolution -> {1.00234 Micrometer, 30 Micrometer},
        Output -> Options
      ];
      Lookup[options, SpiralResolution],
      {1 Micrometer, 30 Micrometer},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, SpiralResolution, "Automatically resolve the SpiralResolution based on the SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {FilledSpiral, SinglePoint},
        Output -> Options
      ];
      Lookup[options, SpiralResolution],
      {50 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- SamplingXDimension and SamplingYDimension -- *)

    Example[{Options, SamplingXDimension, "Set the SamplingXDimension for SamplingPattern -> Grid or FilledSquare:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        SamplingXDimension -> {200 Micrometer, 300 Micrometer},
        Output -> Options
      ];
      Lookup[options, SamplingXDimension],
      {200 Micrometer, 300 Micrometer},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SamplingXDimension, "The SamplingXDimension is rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        SamplingXDimension -> {200 Micrometer, 300.234 Micrometer},
        Output -> Options
      ];
      Lookup[options, SamplingXDimension],
      {200 Micrometer, 300 Micrometer},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, SamplingXDimension, "Automatically resolve the SamplingXDimension for SamplingPattern -> Grid or FilledSquare:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        Output -> Options
      ];
      Lookup[options, SamplingXDimension],
      {200 Micrometer, 100 Micrometer},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SamplingYDimension, "Set the SamplingYDimension for SamplingPattern -> Grid or FilledSquare:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        SamplingYDimension -> {200 Micrometer, 300 Micrometer},
        Output -> Options
      ];
      Lookup[options, SamplingYDimension],
      {200 Micrometer, 300 Micrometer},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SamplingYDimension, "The SamplingYDimension is rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        SamplingYDimension -> {200 Micrometer, 300.948 Micrometer},
        Output -> Options
      ];
      Lookup[options, SamplingYDimension],
      {200 Micrometer, 301 Micrometer},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, SamplingYDimension, "Automatically resolve the SamplingYDimension for SamplingPattern -> Grid or FilledSquare:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        Output -> Options
      ];
      Lookup[options, SamplingYDimension],
      {200 Micrometer, 100 Micrometer},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- SamplingZDimension -- *)

    Example[{Options, SamplingZDimension, "Set the SamplingZDimension for SamplingPattern -> Grid:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        SamplingZDimension -> {10 Micrometer, Null},
        Output -> Options
      ];
      Lookup[options, SamplingZDimension],
      {10 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SamplingZDimension, "The SamplingZDimension for rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> Grid,
        SamplingZDimension -> {10.023 Micrometer, 20 Micrometer},
        Output -> Options
      ];
      Lookup[options, SamplingZDimension],
      {10 Micrometer, 20 Micrometer},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, SamplingZDimension, "Automatically resolve the SamplingZDimension for SamplingPattern -> Grid:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        Output -> Options
      ];
      Lookup[options, SamplingZDimension],
      {0 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- SamplingXStepSize and SamplingYStepSize -- *)

    Example[{Options, SamplingXStepSize, "Set the SamplingXStepSize for SamplingPattern -> Grid:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        SamplingXStepSize -> {10 Micrometer, Null},
        Output -> Options
      ];
      Lookup[options, SamplingXStepSize],
      {10 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SamplingXStepSize, "Automatically resolve the SamplingXStepSize for SamplingPattern -> Grid:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        Output -> Options
      ];
      Lookup[options, SamplingXStepSize],
      {20 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables:>{options}
    ],

    Example[{Options, SamplingYStepSize, "Set the SamplingYStepSize for SamplingPattern -> Grid:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        SamplingYStepSize -> {10 Micrometer, Null},
        Output -> Options
      ];
      Lookup[options, SamplingYStepSize],
      {10 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, SamplingYStepSize, "Automatically resolve the SamplingYStepSize for SamplingPattern -> Grid:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        Output -> Options
      ];
      Lookup[options, SamplingYStepSize],
      {20 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- SamplingZStepSize -- *)

    Example[{Options, SamplingZStepSize, "Set the SamplingZStepSize for SamplingPattern -> Grid:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        SamplingZStepSize -> {10 Micrometer, Null},
        Output -> Options
      ];
      Lookup[options, SamplingZStepSize],
      {10 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- FilledSquareNumberOfTurns -- *)

    Example[{Options, FilledSquareNumberOfTurns, "Set the FilledSquareNumberOfTurns for SamplingPattern -> FilledSquare:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        FilledSquareNumberOfTurns -> {Null, 20},
        Output -> Options
      ];
      Lookup[options, FilledSquareNumberOfTurns],
      {Null, 20},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, FilledSquareNumberOfTurns, "Automatically resolve the FilledSquareNumberOfTurns for SamplingPattern -> FilledSquare:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Grid, FilledSquare},
        Output -> Options
      ];
      Lookup[options, FilledSquareNumberOfTurns],
      {Null, 5},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],


    (* -- NumberOfRings -- *)

    Example[{Options, NumberOfRings, "Set the number of concentric rings used for SamplingPattern -> Rings:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Rings, SinglePoint},
        NumberOfRings -> {20,Null},
        Output -> Options
      ];
      Lookup[options, NumberOfRings],
      {20, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, NumberOfRings, "Automatically resolve the NumberOfRings based on the SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Rings, SinglePoint},
        Output -> Options
      ];
      Lookup[options, NumberOfRings],
      {5, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- RingSpacing -- *)

    Example[{Options, RingSpacing, "Set the spacing between the concentric rings in the Rings SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Rings, SinglePoint},
        RingSpacing -> {10 Micrometer, Null},
        Output -> Options
      ];
      Lookup[options, RingSpacing],
      {10 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, RingSpacing, "The spacing between the concentric rings in the Rings SamplingPattern is rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> Rings,
        RingSpacing -> {10.04351 Micrometer, 20 Micrometer},
        Output -> Options
      ];
      Lookup[options, RingSpacing],
      {10 Micrometer, 20 Micrometer},
      Messages :> {Warning::InstrumentPrecision},
      Variables :> {options}
    ],
    Example[{Options, RingSpacing, "Automatically resolve the spacing between concentric rings when SamplingPattern -> Rings:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Rings, SinglePoint},
        Output -> Options
      ];
      Lookup[options, RingSpacing],
      {100 Micrometer, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- NumberOfSamplingPoints -- *)

    Example[{Options, NumberOfSamplingPoints, "Set the number of total points measured in the Rings SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Rings, SinglePoint},
        NumberOfSamplingPoints -> {20, Null},
        Output -> Options
      ];
      Lookup[options, NumberOfSamplingPoints],
      {20, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, NumberOfSamplingPoints, "Automatically resolve the total number of points measured in the Rings SamplingPattern:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {Rings, SinglePoint},
        Output -> Options
      ];
      Lookup[options, NumberOfSamplingPoints],
      {30, Null},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],

    (* -- NumberOfShots -- *)

    Example[{Options, NumberOfShots, "Set the number of repeated measurements of each Grid point or SinglePoint:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {SinglePoint, Grid},
        NumberOfShots -> {10, 3},
        Output -> Options
      ];
      Lookup[options, NumberOfShots],
      {10,3},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      ),
      Variables :> {options}
    ],
    Example[{Options, NumberOfShots, "Automatically resolve the number of repeated measurements of each point in Grid or SinglePoint SamplingPatterns:"},
      options = ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"]
        },
        SamplingPattern -> {SinglePoint, Grid},
        Output -> Options
      ];
      Lookup[options, NumberOfShots],
      5,
      Variables :> {options}
    ],

    (* -- SamplingCoordinates -- *)

    Example[{Options, SamplingCoordinates, "Set the SamplingCoordinates for SamplingPattern -> Coordinates:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        SamplingPattern -> Coordinates,
        SamplingCoordinates -> {
          {0 Micrometer, 0 Micrometer, 0 Micrometer},
          {10 Micrometer, 0 Micrometer, 0 Micrometer},
          {-10 Micrometer, 0 Micrometer, 0 Micrometer},
          {10 Micrometer, 10 Micrometer, 0 Micrometer},
          {-10 Micrometer, -10 Micrometer, 0 Micrometer},
          {0 Micrometer, 10 Micrometer, 0 Micrometer},
          {0 Micrometer, -10 Micrometer, 0 Micrometer}
        },
        Output -> Options
      ];
      Lookup[options, SamplingCoordinates],
      {{_?QuantityQ,_?QuantityQ,_?QuantityQ}..},
      Variables :> {options}
    ],
    Example[{Options, SamplingCoordinates, "The SamplingCoordinates are rounded to match instrument precision:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        SamplingPattern -> Coordinates,
        SamplingCoordinates -> {
          {5.19 Micrometer, 205.4 Micrometer, 0 Micrometer},
          {1 Millimeter, 1.0004 Millimeter, 2.55 Micrometer}
        },
        Output -> Options
      ];
      Lookup[options, SamplingCoordinates],
      {{5 Micrometer, 205 Micrometer, 0 Micrometer},{1000 Micrometer, 1000 Micrometer, 3 Micrometer}},
      Messages :> {Warning::RamanSamplingCoordinatesPrecision},
      Variables :> {options}
    ],
    Example[{Options, SamplingCoordinates, "Automatically resolve the SamplingCoordinates to generate a set of 20 random coordinates within the sample well:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        SamplingPattern -> Coordinates,
        Output -> Options
      ];
      Lookup[options, SamplingCoordinates],
      {{_?QuantityQ,_?QuantityQ,_?QuantityQ}..},
      Variables :> {options}
    ],


    (* -- Blank -- *)

    Example[{Options, Blank, "Specify Blank -> Window to use a spectrum generated from bottom surface of the plate well as background:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        Blank -> Window,
        Output -> Options
      ];
      Lookup[options, Blank],
      Window,
      Variables :> {options}
    ],
    Example[{Options, Blank, "Specify Blank -> Object[Sample] or Model[Sample] to use a spectrum generated from bottom surface of the plate well as background:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        Blank -> Object[Sample,"RamanSpectroscopy Test Solid 2"],
        Output -> Options
      ];
      Lookup[options, Blank],
      ObjectP[Object[Sample,"RamanSpectroscopy Test Solid 2"]],
      Variables :> {options}
    ],
    Example[{Options, Blank, "Automatically resolve Blank based on the sample form factor:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        Blank -> Automatic,
        Output -> Options
      ];
      Lookup[options, Blank],
      Window,
      Variables :> {options}
    ],
    Example[{Options, Blank, "Automatically resolve Blank based on the sample form factor:"},
      options = ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        Blank -> Automatic,
        Output -> Options
      ];
      Lookup[options, Blank],
      None,
      Variables :> {options}
    ],
    Example[{Options, NumberOfReplicates, "Specify the number of repetition measurements to perform on the set of samples and conditions:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Tablet 1"], NumberOfReplicates -> 3, Output -> Options];
      Lookup[options, NumberOfReplicates],
      3,
      Variables :> {options}
    ],




    (* ------------------- *)
    (* --  SHARED TESTS -- *)
    (* ------------------- *)

    (* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESNT BUG ON THIS. *)
    Example[{Options,Name,"Specify the name of a protocol:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],Name->"My Exploratory RamanSpectroscopy Test Protocol" <> $SessionUUID,Output->Options];
      Lookup[options,Name],
      "My Exploratory RamanSpectroscopy Test Protocol" <> $SessionUUID,
      Variables :> {options}
    ],
    Example[{Options,Template,"Inherit options from a previously run protocol:"},
      options=ExperimentRamanSpectroscopy[Object[Sample, "RamanSpectroscopy Test Tablet 1"],Template->Object[Protocol,RamanSpectroscopy,"Parent Protocol for ExperimentRamanSpectroscopy testing"],Output->Options];
      Lookup[options,TabletProcessing],
      Grind,
      Variables :> {options}
    ],
    Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True, Output->Options];
      {Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
      {True,True,True,True},
      Variables :> {options}
    ],
    Example[{Options,IncubateAliquotDestinationWell,"Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],IncubateAliquotDestinationWell->"A1",Output->Options];
      Lookup[options,IncubateAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],CentrifugeAliquotDestinationWell->"A1",CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
      Lookup[options,CentrifugeAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],FilterAliquotDestinationWell->"A1",FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
      Lookup[options,FilterAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],DestinationWell->"A1",Output->Options];
      Lookup[options,DestinationWell],
      {"A1"},
      Variables:>{options}
    ],
    Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
      options=ExperimentRamanSpectroscopy[
        Object[Sample, "RamanSpectroscopy Test Liquid 4"],
        TargetConcentration -> 4*Micromolar,
        TargetConcentrationAnalyte -> Model[Molecule, "Uracil"],
        Output -> Options];
      Lookup[options,TargetConcentrationAnalyte],
      ObjectP[Model[Molecule,"Uracil"]],
      Variables:>{options}
    ],
    (* ExperimentIncubate tests. *)
    Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], Incubate -> True, Output -> Options];
      Lookup[options, Incubate],
      True,
      Variables :> {options}
    ],
    Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], IncubationTemperature -> 40*Celsius, Output -> Options];
      Lookup[options, IncubationTemperature],
      40*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], IncubationTime -> 40*Minute, Output -> Options];
      Lookup[options, IncubationTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], MaxIncubationTime -> 40*Minute, Output -> Options];
      Lookup[options, MaxIncubationTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
    Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
      Lookup[options, IncubationInstrument],
      ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
      Variables :> {options}
    ],
    Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], AnnealingTime -> 40*Minute, Output -> Options];
      Lookup[options, AnnealingTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], IncubateAliquot -> 0.5*Milliliter, Output -> Options];
      Lookup[options, IncubateAliquot],
      0.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, IncubateAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],

    Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], Mix -> True, Output -> Options];
      Lookup[options, Mix],
      True,
      Variables :> {options}
    ],
    (* Note: You CANNOT be in a plate for the following test. *)
    Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], MixType -> Shake, Output -> Options];
      Lookup[options, MixType],
      Shake,
      Variables :> {options}
    ],
    Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], MixUntilDissolved -> True, Output -> Options];
      Lookup[options, MixUntilDissolved],
      True,
      Variables :> {options}
    ],

    (* ExperimentCentrifuge *)
    Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], Centrifuge -> True, Output -> Options];
      Lookup[options, Centrifuge],
      True,
      Variables :> {options}
    ],
    (* Note: Put your sample in a 2mL tube for the following test. *)
    Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
      Lookup[options, CentrifugeInstrument],
      ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
      Variables :> {options}
    ],
    Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], CentrifugeIntensity -> 1000*RPM, Output -> Options];
      Lookup[options, CentrifugeIntensity],
      1000*RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    (* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
    Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], CentrifugeTime -> 5*Minute, Output -> Options];
      Lookup[options, CentrifugeTime],
      5*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], CentrifugeTemperature -> 10*Celsius, Output -> Options];
      Lookup[options, CentrifugeTemperature],
      10*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], CentrifugeAliquot -> 0.5*Milliliter, Output -> Options];
      Lookup[options, CentrifugeAliquot],
      0.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, CentrifugeAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],CentrifugeAliquotDestinationWell->"A1",Output->Options];
      Lookup[options,CentrifugeAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],

    (* filter options *)
    Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], Filtration -> True, Output -> Options];
      Lookup[options, Filtration],
      True,
      Variables :> {options}
    ],
    Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FiltrationType -> Syringe, Output -> Options];
      Lookup[options, FiltrationType],
      Syringe,
      Variables :> {options}
    ],
    Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
      Lookup[options, FilterInstrument],
      ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
      Variables :> {options}
    ],
    Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
      Lookup[options, Filter],
      ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
      Variables :> {options}
    ],
    Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FilterMaterial -> PES, Output -> Options];
      Lookup[options, FilterMaterial],
      PES,
      Variables :> {options}
    ],
    Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample, "RamanSpectroscopy Test Liquid 1"], PrefilterMaterial -> GxF, Output -> Options];
      Lookup[options, PrefilterMaterial],
      GxF,
      Variables :> {options}
    ],
    Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
      Lookup[options, FilterPoreSize],
      0.22*Micrometer,
      Variables :> {options}
    ],
    Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
      options = ExperimentRamanSpectroscopy[Object[Sample, "RamanSpectroscopy Test Liquid 1"], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
      Lookup[options, PrefilterPoreSize],
      1.*Micrometer,
      Variables :> {options}
    ],
    Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
      Lookup[options, FilterSyringe],
      ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
      Variables :> {options}
    ],
    Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
      options = ExperimentRamanSpectroscopy[Object[Sample, "RamanSpectroscopy Test Liquid 1"], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
      Lookup[options, FilterHousing],
      ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
      Variables :> {options}
    ],
    Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
      Lookup[options, FilterIntensity],
      1000*RPM,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
      Lookup[options, FilterTime],
      20*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, Output -> Options];
      Lookup[options, FilterTemperature],
      10*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
    Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FilterSterile -> True, Output -> Options];
      Lookup[options, FilterSterile],
      True,
      Variables :> {options}
    ],*)
    Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FilterAliquot -> 0.4*Milliliter, Output -> Options];
      Lookup[options, FilterAliquot],
      0.4*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, FilterAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
      Lookup[options, FilterContainerOut],
      {1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
      Variables :> {options}
    ],
    (* aliquot options *)
    Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], AliquotAmount -> 0.28 Milliliter, Output -> Options];
      Lookup[options, AliquotAmount],
      0.28*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], AliquotAmount -> 0.28*Milliliter, Output -> Options];
      Lookup[options, AliquotAmount],
      0.28*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], AssayVolume -> 0.28*Milliliter, Output -> Options];
      Lookup[options, AssayVolume],
      0.28*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],


    Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],
        TargetConcentration -> 0.5*Millimolar,
        Output -> Options];
      Lookup[options, TargetConcentration],
      0.5*Millimolar,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],TargetConcentration->0.1*Molar,TargetConcentrationAnalyte->Model[Molecule, "Sodium Chloride"],AssayVolume->0.5*Milliliter,Output->Options];
      Lookup[options,TargetConcentrationAnalyte],
      ObjectP[Model[Molecule, "Sodium Chloride"]],
      Variables:>{options}
    ],
    Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 0.1 Milliliter,
        AssayVolume -> 0.3 Milliliter,
        Output -> Options];
      Lookup[options, ConcentratedBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables :> {options}
    ],
    Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],
        BufferDilutionFactor -> 10,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 0.1 Milliliter,
        AssayVolume -> 0.3 Milliliter,
        Output -> Options];
      Lookup[options, BufferDilutionFactor],
      10,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],
        BufferDiluent -> Model[Sample, "Milli-Q water"],
        BufferDilutionFactor -> 10,
        ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 0.1 Milliliter,
        AssayVolume -> 0.3 Milliliter,
        Output -> Options];
      Lookup[options, BufferDiluent],
      ObjectP[Model[Sample, "Milli-Q water"]],
      Variables :> {options}
    ],
    Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],
        AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
        AliquotAmount -> 0.1 Milliliter,
        AssayVolume -> 0.3 Milliliter,
        Output -> Options];
      Lookup[options, AssayBuffer],
      ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
      Variables :> {options}
    ],

    Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options, AliquotSampleStorageCondition],
      Refrigerator,
      Variables :> {options}
    ],
    Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], ConsolidateAliquots -> True, Output -> Options];
      Lookup[options, ConsolidateAliquots],
      True,
      Variables :> {options}
    ],
    Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
      Lookup[options, AliquotPreparation],
      Manual,
      Variables :> {options}
    ],
    Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], AliquotContainer -> Model[Container, Plate, "id:kEJ9mqR3XELE"], Output -> Options];
      Lookup[options, AliquotContainer],
      {{1, ObjectP[Model[Container, Plate, "id:kEJ9mqR3XELE"]]}},
      Variables :> {options}
    ],
    Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],DestinationWell->"A1",Output->Options];
      Lookup[options,DestinationWell],
      {"A1"},
      Variables:>{options}
    ],
    Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],IncubateAliquotDestinationWell->"A1",AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
      Lookup[options,IncubateAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],
    Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
      options=ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],FilterAliquotDestinationWell->"A1",Output->Options];
      Lookup[options,FilterAliquotDestinationWell],
      "A1",
      Variables:>{options}
    ],

    (* -- basic shared -- *)
    Example[{Options, Name, "Specify a name for the resulting protocol object:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Solid 1"], Name -> "Test Raman protocol name", Output -> Options];
      Lookup[options, Name],
      "Test Raman protocol name",
      Variables :> {options}
    ],
    Example[{Options, Template, "Use the Template option to inherit specified options (UnresolvedOptions) from the parent protocol:"},
      options = ExperimentRamanSpectroscopy[{Object[Sample,"RamanSpectroscopy Test Solid 1"]}, Template -> Object[Protocol, RamanSpectroscopy, "id:8qZ1VW0pNnxR"], Output -> Options];
      Lookup[options, ObjectiveMagnification],
      10,
      Variables :> {options},
      Messages :>{
        Warning::UnusedTemplateOptions,
        Error::RamanAdjustmentSamplesNotPresent,
        Error::InvalidOption
      }
    ],

    (* -- post-processing -- *)
    Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], ImageSample -> True, Output -> Options];
      Lookup[options, ImageSample],
      True,
      Variables :> {options}
    ],
    Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],MeasureVolume->True, Output -> Options];
      Lookup[options, MeasureVolume],
      True,
      Variables :>{options}
    ],
    Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"],MeasureWeight->True, Output -> Options];
      Lookup[options, MeasureWeight],
      True,
      Variables :>{options}
    ],
    Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
      options = ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Liquid 3"], SamplesInStorageCondition -> Refrigerator, Output -> Options];
      Lookup[options,SamplesInStorageCondition],
      Refrigerator,
      Variables:>{options}
    ],


    (* --- Sample Prep unit tests --- *)
    Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be characterized using Raman spectrsocopy:"},
      options= ExperimentRamanSpectroscopy[
        "dissolved solid",

        PreparatoryUnitOperations->{
          LabelContainer[
            Label->"dissolved solid",
            Container->Model[Container, Vessel, "id:bq9LA0dBGGR6"]
          ],
          Transfer[
            Source->Object[Sample,"RamanSpectroscopy Test Solid 1"],
            Amount->0.2 Gram,
            Destination->{"A1","dissolved solid"}
          ],
          Transfer[
            Source->Model[Sample,"Milli-Q water"],
            Amount->0.5 Milliliter,
            Destination->{"A1","dissolved solid"}
          ]
        },
        Output -> Options
      ];
      Lookup[options,SampleType],
      Liquid,
      Variables:>{options}
    ],
    Example[{Options, SampleType,"Define the SampleType for Tablets to indicate how they should be processed:"},
      options=ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Tablet 1"],
          Object[Sample,"RamanSpectroscopy Test Tablet 2"]
        },
        SampleType -> {Powder, Tablet},
        Output->Options
      ];
      Lookup[options,TabletProcessing],
      {Grind, Whole},
      Variables:>{options},
      Messages:>{Error::IncompatibleRamanSampleTypes, Error::InvalidOption}
    ],






    (* ============== *)
    (* == MESSAGES == *)
    (* ============== *)

    (* -- ObjectDoesNotExist -- *)

    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
      ExperimentRamanSpectroscopy[Object[Sample, "Nonexistent sample"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
      ExperimentRamanSpectroscopy[Object[Container, Vessel, "Nonexistent container"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
      ExperimentRamanSpectroscopy[Object[Sample, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],
    Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
      ExperimentRamanSpectroscopy[Object[Container, Vessel, "id:12345678"]],
      $Failed,
      Messages :> {Download::ObjectDoesNotExist}
    ],


    (* -- Sample Quantity -- *)

    Example[{Messages, "RamanNotEnoughSample" , "If the is not a sufficient amount of sample to perform the experiment, an error will be thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample, "RamanSpectroscopy Small Test Solid 1"]
      ],
      $Failed,
      Messages :> {Error::RamanNotEnoughSample, Error::InvalidInput},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],


    (* -- SampleType -- *)

    Example[{Messages, "IncorrectRamanSampleType" , "If the SampleType is in conflict with the physical state of the sample after TabletProcessing and Sample Preparation, an error will be thrown:"},
      ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Liquid 1"],
          Object[Sample,"RamanSpectroscopy Test Tablet 1"]
        },
        SampleType -> {Powder, Powder}
      ],
      $Failed,
      Messages :> {Error::IncorrectRamanSampleType, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "RamanSampleTypeRequiresDissolution", "If the SampleType -> Liquid but the State of the sample is Solid, an error will be thrown:"},
      ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 1"]
        },
        SampleType -> {Liquid, Liquid}
      ],
      $Failed,
      Messages :> {Error::RamanSampleTypeRequiresDissolution, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "InvalidRamanTabletProcessingRequested", "If the SampleType -> Liquid but the sample is a tablet, an error will be thrown:"},
      ExperimentRamanSpectroscopy[
        {
          Object[Sample,"RamanSpectroscopy Test Tablet 1"],
          Object[Sample,"RamanSpectroscopy Test Liquid 1"]
        },
        SampleType -> {Liquid, Liquid}
      ],
      $Failed,
      Messages :> {Error::InvalidRamanTabletProcessingRequested, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "RamanTabletProcessingInconsistancy", "If the SampleType -> Solid for a tablet sample but TabletProcessing is not Grind or Automatic, an error will be thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SampleType -> Powder,
        TabletProcessing -> Whole
      ],
      $Failed,
      Messages :> {Error::RamanTabletProcessingInconsistancy, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    (* -- TabletProcessing -- *)

    Example[{Messages, "UnusedRamanTabletProcessing" , "If TabletProcessing is specified but the sample is not a tablet, an error will be shown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Liquid 1"],
        TabletProcessing -> Whole
      ],
      $Failed,
      Messages :> {Error::UnusedRamanTabletProcessing, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "MissingRamanTabletProcessing" , "If the sample is a tablet and the TabletProcessing parameters are not specified or automatic, an error will be thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        TabletProcessing -> Null
      ],
      $Failed,
      Messages :> {Error::MissingRamanTabletProcessing, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],


    (* ------------ *)
    (* -- OPTICS -- *)
    (* ------------ *)


    Example[{Messages, "RamanObjectiveMisMatch" , "If FloodLight is True, ObjectiveMagnification can only be set if InvertedMicroscopeImage is also True:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        InvertedMicroscopeImage -> False,
        FloodLight -> True,
        ObjectiveMagnification -> 10
      ],
      $Failed,
      Messages :> {Error::RamanObjectiveMisMatch, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "NoRamanObjective" , "If FloodLight is False, ObjectiveMagnification must be specified:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        FloodLight -> False,
        ObjectiveMagnification -> Null
      ],
      $Failed,
      Messages :> {Error::NoRamanObjective, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "MissingRamanAdjustmentTarget" , "If an adjustment is performed used AdjustmentTarget must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        LaserPower -> Optimize,
        AdjustmentTarget -> Null
      ],
      $Failed,
      Messages :> {Error::MissingRamanAdjustmentTarget, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "NoRamanAdjustmentTargetRequired" , "If no adjustment is performed, AdjustmentTarget should not be informed:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        LaserPower -> 20 Percent,
        ExposureTime -> 100 Millisecond,
        AdjustmentTarget -> 50 Percent
      ],
      $Failed,
      Messages :> {Error::NoRamanAdjustmentTargetRequired, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "MissingRamanAdjustmentSample" , "If an adjustment is performed, AdjustmentSample must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        LaserPower -> Optimize,
        AdjustmentSample -> Null
      ],
      $Failed,
      Messages :> {Error::MissingRamanAdjustmentSample, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "RamanAdjustmentSamplesNotPresent" , "AdjustmentSamples must be a member of SamplesIn or Blank:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        LaserPower -> Optimize,
        AdjustmentSample -> Object[Sample,"RamanSpectroscopy Test Tablet 2"]
      ],
      $Failed,
      Messages :> {Error::RamanAdjustmentSamplesNotPresent, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "NoRamanAdjustmentSampleRequired" , "If no adjustment is performed, AdjustmentSample should not be informed:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        LaserPower -> 20 Percent,
        ExposureTime -> 100 Millisecond,
        AdjustmentSample -> Object[Sample,"RamanSpectroscopy Test Tablet 1"]
      ],
      $Failed,
      Messages :> {Error::NoRamanAdjustmentSampleRequired, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "MissingRamanAdjustmentEmissionWavelength" , "If an adjustment is performed, AdjustmentEmissionWavelength must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        LaserPower -> Optimize,
        AdjustmentEmissionWavelength -> Null
      ],
      $Failed,
      Messages :> {Error::MissingRamanAdjustmentEmissionWavelength, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "NoRamanAdjustmentEmissionWavelengthRequired" , "If no adjustment is performed, AdjustmentEmissionWavelength should not be informed:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        LaserPower -> 30 Percent,
        ExposureTime -> 100 Millisecond,
        AdjustmentEmissionWavelength -> 2000*1/Centimeter
      ],
      $Failed,
      Messages :> {Error::NoRamanAdjustmentEmissionWavelengthRequired, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],


    (* --------------------- *)
    (* -- OPTICAL IMAGING -- *)
    (* --------------------- *)

    Example[{Messages, "MissingRamanMicroscopeImageLightIntensity", "If InvertedMicroscopeImage -> True, the MicroscopeImageLightIntensity must not be Null :"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        InvertedMicroscopeImage -> True,
        MicroscopeImageLightIntensity -> Null
      ],
      $Failed,
      Messages:>{Error::MissingRamanMicroscopeImageLightIntensity, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "MissingRamanMicroscopeImageExposureTime", "If InvertedMicroscopeImage -> True, the MicroscopeImageExposureTime must not be Null :"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        InvertedMicroscopeImage -> True,
        MicroscopeImageExposureTime -> Null
      ],
      $Failed,
      Messages:>{Error::MissingRamanMicroscopeImageExposureTime, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "UnusedRamanMicroscopeImageExposureTime", "If MicroscopeImageExposureTime is set but InvertedMicroscopeImage -> False, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        InvertedMicroscopeImage -> False,
        MicroscopeImageExposureTime -> 100 Millisecond
      ],
      $Failed,
      Messages:>{Error::UnusedRamanMicroscopeImageExposureTime,Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "UnusedRamanMicroscopeImageLightIntensity", "If MicroscopeImageLightIntensity is set but InvertedMicroscopeImage -> False, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Solid 1"],
        InvertedMicroscopeImage -> False,
        MicroscopeImageLightIntensity -> 80 Percent
      ],
      $Failed,
      Messages:>{Error::UnusedRamanMicroscopeImageLightIntensity,Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    (* ---------------------- *)
    (* -- SAMPLING PATTERN -- *)
    (* ---------------------- *)


    Example[{Messages, "RamanSamplingPatternOutOfBounds" , "If the specified parameters result in points which lie outside the well region, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Spiral,
        SpiralOuterDiameter -> 9999 Micrometer
      ],
      $Failed,
      Messages :> {Error::RamanSamplingPatternOutOfBounds, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "RamanMaxSpeedExceeded", "If the specified parameters require the sample stage to move a t a speed beyond its capabilities, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> FilledSquare,
        FilledSquareNumberOfTurns -> 20,
        SamplingXDimension -> 4000 Micrometer,
        SamplingYDimension -> 4000 Micrometer,
        SamplingTime -> 1 Second
      ],
      $Failed,
      Messages :> {Error::RamanMaxSpeedExceeded, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "RamanSwappedInnerOuterDiameter" , "If the inner spiral diameter is larger than the outer spiral diameter, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Spiral,
        SpiralInnerDiameter -> 100 Micrometer,
        SpiralOuterDiameter -> 90 Micrometer
      ],
      $Failed,
      Messages :> {Error::RamanSwappedInnerOuterDiameter, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "RamanSwappedXDimensionStepSize" , "If the SamplingXDimension is Smaller than the SamplingXStepSize, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Grid,
        SamplingXDimension -> 90 Micrometer,
        SamplingXStepSize -> 100 Micrometer
      ],
      $Failed,
      Messages :> {Error::RamanSwappedXDimensionStepSize, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "RamanSwappedYDimensionStepSize" , "If the SamplingYDimension is Smaller than the SamplingYStepSize, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Grid,
        SamplingYDimension -> 90 Micrometer,
        SamplingYStepSize -> 100 Micrometer
      ],
      $Failed,
      Messages :> {Error::RamanSwappedYDimensionStepSize, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "RamanSwappedZDimensionStepSize" , "If the SamplingZDimension is Smaller than the SamplingZStepSize, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Grid,
        SamplingZDimension -> 2 Micrometer,
        SamplingZStepSize -> 10 Micrometer
      ],
      $Failed,
      Messages :> {Error::RamanSwappedZDimensionStepSize, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "MissingRamanSamplingCoordinates", "When SamplingPattern -> Coordinates, SamplingCoordinates must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Coordinates,
        SamplingCoordinates -> Null
      ],
      $Failed,
      Messages :> {Error::MissingRamanSamplingCoordinates, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "RamanMissingNumberOfSamplingPoints", "When SamplingPattern -> Rings, NumberOfSamplingPoints must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Rings,
        NumberOfSamplingPoints -> Null
      ],
      $Failed,
      Messages :> {Error::RamanMissingNumberOfSamplingPoints, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "RamanMissingNumberOfRings", "When SamplingPattern -> Rings, NumberOfRings must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Rings,
        NumberOfRings -> Null
      ],
      $Failed,
      Messages :> {Error::RamanMissingNumberOfRings, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "MissingNumberOfShots", "When SamplingPattern -> Rings, Grid, Coordinates, or SinglePoint, NumberOfShots must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Grid,
        NumberOfShots -> Null
      ],
      $Failed,
      Messages :> {Error::MissingNumberOfShots, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "MissingRamanSamplingTime",  "When SamplingPattern -> FilledSpiral, SamplingTime must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Spiral,
        SamplingTime -> Null
      ],
      $Failed,
      Messages :> {Error::MissingRamanSamplingTime, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "RamanMissingSpiralInnerDiameter",  "When SamplingPattern -> Spiral or FilledSpiral, SpiralInnerDiameter must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Spiral,
        SpiralInnerDiameter -> Null
      ],
      $Failed,
      Messages :> {Error::RamanMissingSpiralInnerDiameter, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "RamanMissingSpiralOuterDiameter",  "When SamplingPattern -> Spiral or FilledSpiral, SpiralOuterDiameter must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Spiral,
        SpiralOuterDiameter -> Null
      ],
      $Failed,
      Messages :> {Error::RamanMissingSpiralOuterDiameter, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "RamanMissingSpiralResolution",  "When SamplingPattern -> FilledSpiral, SpiralResolution must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> FilledSpiral,
        SpiralResolution -> Null
      ],
      $Failed,
      Messages :> {Error::RamanMissingSpiralResolution, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "RamanMissingSpiralFillArea",  "When SamplingPattern -> FilledSpiral, SpiralFillArea must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> FilledSpiral,
        SpiralFillArea -> Null
      ],
      $Failed,
      Messages :> {Error::RamanMissingSpiralFillArea, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "RamanMissingFilledSquareNumberOfTurns",  "When SamplingPattern -> FilledSquare, FilledSquareNumberOfTurns must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> FilledSquare,
        FilledSquareNumberOfTurns -> Null
      ],
      $Failed,
      Messages :> {Error::RamanMissingFilledSquareNumberOfTurns, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "ExcessiveRamanSamplingTime", "If the sampling pattern parameters result in excessively long sampling times, an error is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> FilledSquare,
        SamplingTime -> 9999 Second
      ],
      $Failed,
      Messages :> {Error::ExcessiveRamanSamplingTime, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "LongRamanSamplingTime", "If the sampling pattern parameters result in a long sampling time, a warning is thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> SinglePoint,
        ExposureTime -> 1000 Millisecond,
        NumberOfShots -> 2000
      ],
      ObjectP[Object[Protocol, RamanSpectroscopy]],
      Messages :> {Warning::LongRamanSamplingTime},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "MissingRamanSamplingDimension", "When SamplingPattern -> Grid, SamplingXDimension must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Grid,
        SamplingXDimension -> Null
      ],
      $Failed,
      Messages :> {Error::MissingRamanSamplingDimension, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "MissingRamanSamplingStepSize",  "When SamplingPattern -> Grid, SamplingXStepSize must not be Null:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Grid,
        SamplingXStepSize -> Null
      ],
      $Failed,
      Messages :> {Error::MissingRamanSamplingStepSize, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],

    Example[{Messages, "UnusedRamanSamplingPatternParameterOption", "If parameters are specified which are not required for the selected SamplingPattern, an error will be thrown:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> SinglePoint,
        SpiralInnerDiameter -> 20 Micrometer
      ],
      $Failed,
      Messages :> {Error::UnusedRamanSamplingPatternParameterOption, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],



    (* ---------------------- *)
    (* -- GENERAL MESSAGES -- *)
    (* ---------------------- *)

    (* -- rounding option precision -- *)
    Example[{Messages, "RamanSamplingCoordinatesPrecision", "If an option is given with higher precision than the instrument can achieve, the value is rounded to the instrument precision and a warning is displayed:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        SamplingPattern -> Coordinates,
        SamplingCoordinates -> {{10.1 Micrometer, 10.5 Micrometer, 0 Micrometer},{20.1 Micrometer, 50.5 Micrometer, 0 Micrometer},{40.1 Micrometer, 30.5 Micrometer, 0 Micrometer}}
      ],
      ObjectP[Object[Protocol, RamanSpectroscopy]],
      Messages :> {Warning::RamanSamplingCoordinatesPrecision},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "InstrumentPrecision", "If an option is given with higher precision than the instrument can achieve, the value is rounded to the instrument precision and a warning is displayed:"},
      ExperimentRamanSpectroscopy[
        Object[Sample,"RamanSpectroscopy Test Tablet 1"],
        LaserPower -> 20.1 Percent
      ],
      ObjectP[Object[Protocol, RamanSpectroscopy]],
      Messages :> {Warning::InstrumentPrecision},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "TooManyRamanSampleInputs", "If there are too many samples to be measured in a single plate for the specified SampleType, and error will be thrown:"},
      ExperimentRamanSpectroscopy[
        ConstantArray[Object[Sample,"RamanSpectroscopy Test Tablet 1"], 25],
        SampleType -> Tablet,
        TabletProcessing -> Whole
      ],
     $Failed,
      Messages :> {Error::TooManyRamanSampleInputs, Error::InvalidInput},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "IncompatibleRamanSampleTypes", "All samples must have SampleType -> Liquid or Powder, or all have SampleType -> Tablet:"},
      ExperimentRamanSpectroscopy[
        {Object[Sample,"RamanSpectroscopy Test Tablet 1"], Object[Sample,"RamanSpectroscopy Test Liquid 1"]}
      ],
      $Failed,
      Messages :> {Error::IncompatibleRamanSampleTypes, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "InvalidRamanBlankFormFactor", "Blank must be in liquid or solid form, not Tablets:"},
      ExperimentRamanSpectroscopy[
        {Object[Sample,"RamanSpectroscopy Test Solid 1"], Object[Sample,"RamanSpectroscopy Test Liquid 1"]},
        Blank -> {Object[Sample,"RamanSpectroscopy Test Tablet 1"], Window}
      ],
      $Failed,
      Messages :> {Error::InvalidRamanBlankFormFactor, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "TabletWithRamanBlankSample", "The Blank option is not supported for tablet inputs:"},
      ExperimentRamanSpectroscopy[
        {Object[Sample,"RamanSpectroscopy Test Tablet 1"], Object[Sample,"RamanSpectroscopy Test Tablet 2"]},
        Blank -> {Window, Object[Sample,"RamanSpectroscopy Test Liquid 1"]}
      ],
      $Failed,
      Messages :> {Error::TabletWithRamanBlankSample, Error::InvalidOption},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, "RamanSampleWithoutBlank", "The user will be warned if Liquid/Solid samples do not have any blank specified:"},
      ExperimentRamanSpectroscopy[
        {Object[Sample,"RamanSpectroscopy Test Liquid 1"], Object[Sample,"RamanSpectroscopy Test Solid 1"]},
        Blank -> {Window, None}
      ],
      ObjectP[Object[Protocol, RamanSpectroscopy]],
      Messages :> {Warning::RamanSampleWithoutBlank},
      SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
      ExperimentRamanSpectroscopy[
        Model[Sample, "Ammonium hydroxide"],
        PreparedModelAmount -> 0.5 Milliliter,
        Aliquot -> True,
        Mix -> True
      ],
      ObjectP[Object[Protocol, RamanSpectroscopy]]
    ]

    (* =========== *)
    (* == TESTS == *)
    (* =========== *)

  },
  (* without this, telescope crashes and the test fails *)
  HardwareConfiguration->HighRAM,

  (* make it parallel *)
  (*Parallel -> True,*)
  (*  build test objects *)
  Stubs:>{
    $EmailEnabled=False
  },
  SetUp :> ($CreatedObjects = {}; Off[Warning::SamplesOutOfStock]; Off[Warning::InstrumentUndergoingMaintenance];),
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Plate, "Fake sample plate for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container,Plate,Irregular,Raman, "Fake tablet holder for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Item, TabletCutter, "Fake tablet cutter for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Item, TabletCrusher, "Fake tablet crusher for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Item, TabletCrusherBag, "Fake tablet crusher bags for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Instrument, RamanSpectrometer, "Fake instrument for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Protocol,RamanSpectroscopy,"Parent Protocol for ExperimentRamanSpectroscopy testing"],

          Object[Container, Vessel, "Fake container 1 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 2 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 3 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 4 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 5 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 6 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 7 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 8 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 9 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 10 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 11 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopy Test Liquid 1"],
          Object[Sample,"RamanSpectroscopy Test Liquid 2"],
          Object[Sample,"RamanSpectroscopy Test Liquid 3"],
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"],
          Object[Sample,"RamanSpectroscopy Test Tablet 1"],
          Object[Sample,"RamanSpectroscopy Test Tablet 2"],
          Object[Sample,"RamanSpectroscopy Test Tablet 3"],
          Object[Sample,"RamanSpectroscopy Test Liquid 4"],
          Object[Sample, "RamanSpectroscopy Small Test Solid 1"],

              If[DatabaseMemberQ[ Object[Protocol, RamanSpectroscopy,"RamanSpectroscopy Test Template Protocol 1"]],
            Download[Object[Protocol, RamanSpectroscopy,"RamanSpectroscopy Test Template Protocol 1"], {Object, SubprotocolRequiredResources[Object], ProcedureLog[Object]}],
            Nothing
          ]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Block[{$AllowSystemsProtocols = True},
      Module[
        {
          fakeBench, instrument, tabletCutter, tabletCrusher, tabletCrusherBags, tabletHolder, glassPlate,
          container1, container2, container3, container4, container5, container6, container7, container8, container9, container11,samplePlate, container10,concentrationSample,
          liquidSample1, liquidSample2, liquidSample3, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3, smallSolidSample1
        },
        (* set up fake bench as a location for the vessel *)
        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for RamanSpectroscopy tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* set up instrument and tablet cursher bags *)
        instrument = Upload[<|
          Type -> Object[Instrument, RamanSpectrometer],
          Model ->Link[Model[Instrument, RamanSpectrometer, "THz Raman WPS"],Objects],
          Name -> "Fake instrument for RamanSpectroscopy tests" <> $SessionUUID,
          Status ->Available,
          DeveloperObject->True
        |>];

        tabletCrusherBags = Upload[<|
          Type -> Object[Item, TabletCrusherBag],
          Model -> Link[Model[Item, TabletCrusherBag, "Silent Knight tablet crusher bag"], Objects],
          Name -> "Fake tablet crusher bags for RamanSpectroscopy tests" <> $SessionUUID,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Count -> 50,
          Status -> Available
        |>];

        (*Create a protocol that we'll use for template testing*)
        Upload[
          <|
            Type->Object[Protocol,RamanSpectroscopy],
            Name->"Parent Protocol for ExperimentRamanSpectroscopy testing",
            DeveloperObject->True,
            ResolvedOptions->{TabletProcessing->Grind}
          |>
        ];

        (* set up fake containers for our samples *)
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
          glassPlate,
          tabletHolder,
          tabletCutter,
          tabletCrusher,
          container10,
          container11
        } = UploadSample[
          {
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Plate, "96-well glass bottom plate"],
            Model[Container, Plate, Irregular, Raman, "18-well multi-size tablet holder"],
            Model[Item, TabletCutter, "Single blade tablet cutter"],
            Model[Item, TabletCrusher, "Silent Knight tablet crusher"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"]
          },
          ConstantArray[{"Work Surface", fakeBench},15],
          Status -> ConstantArray[Available,15],
          Name ->
              {
                "Fake container 1 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 2 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 3 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 4 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 5 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 6 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 7 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 8 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 9 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake sample plate for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake tablet holder for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake tablet cutter for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake tablet crusher for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 10 for RamanSpectroscopy tests" <> $SessionUUID,
                "Fake container 11 for RamanSpectroscopy tests" <> $SessionUUID
              }
        ];

        (* set up fake samples to test *)
        {
          liquidSample1,
          liquidSample2,
          liquidSample3,
          solidSample1,
          solidSample2,
          solidSample3,
          tabletSample1,
          tabletSample2,
          tabletSample3,
          concentrationSample,
          smallSolidSample1
        } = UploadSample[
          {
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Ibuprofen tablets 500 Count"],
            Model[Sample, "Ibuprofen tablets 500 Count"],
            Model[Sample, "Ibuprofen tablets 500 Count"],
            Model[Sample,StockSolution,"Red Food Dye Test Solution"],
            Model[Sample, "Sodium Chloride"]
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
            {"A1", container11}
          },
          InitialAmount ->
              {
                20*Milliliter,
                20*Milliliter,
                1*Milliliter,
                1*Gram,
                1*Gram,
                1*Gram,
                3,
                3,
                3,
                10 Milliliter,
                1*Microgram
              },
          Name ->
              {
                "RamanSpectroscopy Test Liquid 1",
                "RamanSpectroscopy Test Liquid 2",
                "RamanSpectroscopy Test Liquid 3",
                "RamanSpectroscopy Test Solid 1",
                "RamanSpectroscopy Test Solid 2",
                "RamanSpectroscopy Test Solid 3",
                "RamanSpectroscopy Test Tablet 1",
                "RamanSpectroscopy Test Tablet 2",
                "RamanSpectroscopy Test Tablet 3",
                "RamanSpectroscopy Test Liquid 4",
                "RamanSpectroscopy Small Test Solid 1"
              }
        ];

        (* upload the test objects *)
        Upload[
          <|
            Object -> #,
            AwaitingStorageUpdate -> Null
          |> & /@ Cases[
            Flatten[
              {
                container1, container2, container3, container4, container5, container6, container7, container8, container9, container10,container11,
                glassPlate,tabletHolder, tabletCutter, tabletCrusher, concentrationSample,
                liquidSample1, liquidSample2, liquidSample3, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3,smallSolidSample1
              }
            ],
            ObjectP[]
          ]
        ];

        (* sever model link because it cant be relied on - also update the composition of the object that will be used for the target concentration tests*)
        Upload[
          Cases[
            Flatten[
          {
            <|Object -> liquidSample1, Model -> Null|>,
            <|Object -> liquidSample2, Model -> Null|>,
            <|
              Object -> liquidSample3, Model -> Null,
              Replace[Composition] -> {{90 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]], Now}, {Null, Null, Null}, {0.1 Molar, Link[Model[Molecule, "Sodium Chloride"]], Now}}
            |>,
            <|Object -> solidSample1, Model -> Null|>,
            <|Object -> solidSample2, Model -> Null|>,
            <|Object -> solidSample3, Model -> Null|>,
            <|Object -> tabletSample1, Model -> Null|>,
            <|Object -> tabletSample2, Model -> Null|>,
            <|Object -> tabletSample3, Model -> Null|>,
            <|Object->concentrationSample,Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]], Now},{5 Micromolar,Link[Model[Molecule,"Uracil"]],Now}},Status->Available,DeveloperObject->True|>

          }
        ],
          PacketP[]
          ]
        ];

        (*upload a test protocol for usea in template testing*)
        (*ExperimentRamanSpectroscopy[Object[Sample,"RamanSpectroscopy Test Solid 3"], Name -> "RamanSpectroscopy Test Template Protocol 1"];*)
      ]
    ]
  ),
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Plate, "Fake sample plate for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container,Plate,Irregular,Raman, "Fake tablet holder for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Item, TabletCutter, "Fake tablet cutter for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Item, TabletCrusher, "Fake tablet crusher for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Item, TabletCrusherBag, "Fake tablet crusher bags for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Instrument, RamanSpectrometer, "Fake instrument for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Protocol,RamanSpectroscopy,"Parent Protocol for ExperimentRamanSpectroscopy testing"],

          Object[Container, Vessel, "Fake container 1 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 2 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 3 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 4 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 5 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 6 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 7 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 8 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 9 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 10 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 11 for RamanSpectroscopy tests" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopy Test Liquid 1"],
          Object[Sample,"RamanSpectroscopy Test Liquid 2"],
          Object[Sample,"RamanSpectroscopy Test Liquid 3"],
          Object[Sample,"RamanSpectroscopy Test Solid 1"],
          Object[Sample,"RamanSpectroscopy Test Solid 2"],
          Object[Sample,"RamanSpectroscopy Test Solid 3"],
          Object[Sample,"RamanSpectroscopy Test Tablet 1"],
          Object[Sample,"RamanSpectroscopy Test Tablet 2"],
          Object[Sample,"RamanSpectroscopy Test Tablet 3"],
          Object[Sample,"RamanSpectroscopy Test Liquid 4"],
          Object[Sample, "RamanSpectroscopy Small Test Solid 1"],
              If[DatabaseMemberQ[ Object[Protocol, RamanSpectroscopy,"RamanSpectroscopy Test Template Protocol 1"]],
            Download[Object[Protocol, RamanSpectroscopy,"RamanSpectroscopy Test Template Protocol 1"], {Object, SubprotocolRequiredResources[Object], ProcedureLog[Object]}],
            Nothing
          ]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];




(* ::Subsection:: *)
(*ExperimentRamanSpectroscopyOptions*)


(* ---------------------------------------- *)
(* -- ExperimentRamanSpectroscopyOptions -- *)
(* ---------------------------------------- *)


DefineTests[ExperimentRamanSpectroscopyOptions,
  {
    Example[{Basic, "Display the option values which will be used in the experiment:"},
      ExperimentRamanSpectroscopyOptions[
        Object[Sample,"RamanSpectroscopyOptions Test Solid 1" <> $SessionUUID]
      ],
      _Grid
    ],
    Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
      ExperimentRamanSpectroscopyOptions[
        Object[Sample,"RamanSpectroscopyOptions Test Solid 1" <> $SessionUUID],
        ObjectiveMagnification -> Null,
        FloodLight -> False
      ],
      _Grid,
      Messages :> {Error::NoRamanObjective, Error::InvalidOption}
    ],
    Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
      ExperimentRamanSpectroscopyOptions[
        {
          Object[Sample,"RamanSpectroscopyOptions Test Solid 1" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Solid 2" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Solid 3" <> $SessionUUID]
        },
        OutputFormat -> List
      ],
      {(_Rule|_RuleDelayed)..}
    ]
  },


  (*  build test objects *)
  Stubs:>{
    $EmailEnabled=False
  },
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container,Plate,Irregular,Raman, "Fake tablet holder for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Instrument, RamanSpectrometer, "Fake instrument for RamanSpectroscopyOptions tests" <> $SessionUUID],

          Object[Container, Plate, "Fake sample plate for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 1 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 2 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 3 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 4 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 5 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 6 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 7 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 8 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 9 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Liquid 1" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Liquid 2" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Liquid 3" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Solid 1" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Solid 2" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Solid 3" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Tablet 1" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Tablet 2" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Tablet 3" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Block[{$AllowSystemsProtocols = True},
      Module[
        {
          fakeBench, instrument, glassPlate,
          container1, container2, container3, container4, container5, container6, container7, container8, container9,
          liquidSample1, liquidSample2, liquidSample3, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3
        },
        (* set up fake bench as a location for the vessel *)
        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for RamanSpectroscopyOptions tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* set up instrument and tablet cursher bags *)
        instrument = Upload[<|
          Type -> Object[Instrument, RamanSpectrometer],
          Model ->Link[Model[Instrument, RamanSpectrometer, "THz Raman WPS"],Objects],
          Name -> "Fake instrument for RamanSpectroscopyOptions tests" <> $SessionUUID,
          Status -> Available,
          DeveloperObject->True
        |>];


        (* set up fake containers for our samples *)
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
          glassPlate
        } = UploadSample[
          {
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Plate, "96-well glass bottom plate"]
          },
          {
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench}
          },
          Status ->
              {
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
          Name ->
              {
                "Fake container 1 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake container 2 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake container 3 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake container 4 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake container 5 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake container 6 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake container 7 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake container 8 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake container 9 for RamanSpectroscopyOptions tests" <> $SessionUUID,
                "Fake sample plate for RamanSpectroscopyOptions tests" <> $SessionUUID
              }
        ];

        (* set up fake samples to test *)
        {
          liquidSample1,
          liquidSample2,
          liquidSample3,
          solidSample1,
          solidSample2,
          solidSample3,
          tabletSample1,
          tabletSample2,
          tabletSample3
        } = UploadSample[
          {
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Ibuprofen tablets 500 Count"],
            Model[Sample, "Ibuprofen tablets 500 Count"],
            Model[Sample, "Ibuprofen tablets 500 Count"]
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
            {"A1", container9}
          },
          InitialAmount ->
              {
                20*Milliliter,
                20*Milliliter,
                1*Milliliter,
                1*Gram,
                1*Gram,
                1*Gram,
                1,
                1,
                1
              },
          Name ->
              {
                "RamanSpectroscopyOptions Test Liquid 1" <> $SessionUUID,
                "RamanSpectroscopyOptions Test Liquid 2" <> $SessionUUID,
                "RamanSpectroscopyOptions Test Liquid 3" <> $SessionUUID,
                "RamanSpectroscopyOptions Test Solid 1" <> $SessionUUID,
                "RamanSpectroscopyOptions Test Solid 2" <> $SessionUUID,
                "RamanSpectroscopyOptions Test Solid 3" <> $SessionUUID,
                "RamanSpectroscopyOptions Test Tablet 1" <> $SessionUUID,
                "RamanSpectroscopyOptions Test Tablet 2" <> $SessionUUID,
                "RamanSpectroscopyOptions Test Tablet 3" <> $SessionUUID
              }
        ];

        (* upload the test objects *)
        Upload[
          <|
            Object -> #,
            AwaitingStorageUpdate -> Null
          |> & /@ Cases[
            Flatten[
              {
                container1, container2, container3, container4, container5, container6, container7, container8, container9,
                glassPlate,
                liquidSample1, liquidSample2, liquidSample3, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3
              }
            ],
            ObjectP[]
          ]
        ];

        (* sever model link because it cant be relied on - also update the composition of the object that will be used for the target concentration tests*)
        Upload[
          Cases[
            Flatten[
              {
                <|Object -> liquidSample1, Model -> Null|>,
                <|Object -> liquidSample2, Model -> Null|>,
                <|
                  Object -> liquidSample3, Model -> Null,
                  Replace[Composition] -> {{90 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]], Now}, {Null, Null, Null}, {0.1 Molar, Link[Model[Molecule, "Sodium Chloride"]], Now}}
                |>,
                <|Object -> solidSample1, Model -> Null|>,
                <|Object -> solidSample2, Model -> Null|>,
                <|Object -> solidSample3, Model -> Null|>,
                <|Object -> tabletSample1, Model -> Null|>,
                <|Object -> tabletSample2, Model -> Null|>,
                <|Object -> tabletSample3, Model -> Null|>
              }
            ],
            PacketP[]
          ]
        ]
      ]
    ]
  ),
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Plate, "Fake sample plate for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container,Plate,Irregular,Raman, "Fake tablet holder for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Instrument, RamanSpectrometer, "Fake instrument for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 1 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 2 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 3 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 4 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 5 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 6 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 7 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 8 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 9 for RamanSpectroscopyOptions tests" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Liquid 1" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Liquid 2" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Liquid 3" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Solid 1" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Solid 2" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Solid 3" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Tablet 1" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Tablet 2" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyOptions Test Tablet 3" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];


(* ::Subsection:: *)
(*ValidExperimentRamanSpectroscopyQ*)


(* --------------------------------------- *)
(* -- ValidExperimentRamanSpectroscopyQ -- *)
(* --------------------------------------- *)


DefineTests[ValidExperimentRamanSpectroscopyQ,
  {
    Example[{Basic, "Verify that the experiment can be run without issues:"},
      ValidExperimentRamanSpectroscopyQ[
        Object[Sample,"ValidRamanSpectroscopyQ Test Solid 1" <> $SessionUUID]
      ],
      True
    ],
    Example[{Basic, "Return False if there are problems with the inputs or options:"},
      ValidExperimentRamanSpectroscopyQ[
        Object[Sample,"ValidRamanSpectroscopyQ Test Solid 1" <> $SessionUUID],
        ObjectiveMagnification -> Null,
        FloodLight -> False
      ],
      False
    ],
    Example[{Options, OutputFormat, "Return a test summary:"},
      ValidExperimentRamanSpectroscopyQ[
        Object[Sample,"ValidRamanSpectroscopyQ Test Solid 1" <> $SessionUUID],
        OutputFormat -> TestSummary
      ],
      _EmeraldTestSummary
    ],
    Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
      ValidExperimentRamanSpectroscopyQ[
        Object[Sample,"ValidRamanSpectroscopyQ Test Solid 1" <> $SessionUUID],
        Verbose -> True
      ],
      True
    ]
  },


  (*  build test objects *)
  Stubs:>{
    $EmailEnabled=False
  },
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Plate, "Fake sample plate for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container,Plate,Irregular,Raman, "Fake tablet holder for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Item, TabletCutter, "Fake tablet cutter for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Item, TabletCrusher, "Fake tablet crusher for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Item, TabletCrusherBag, "Fake tablet crusher bags for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Instrument, RamanSpectrometer, "Fake instrument for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 1 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 2 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 3 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 4 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 5 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 6 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 7 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 8 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 9 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Liquid 1" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Liquid 2" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Liquid 3" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Solid 1" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Solid 2" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Solid 3" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Tablet 1" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Tablet 2" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Tablet 3" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Block[{$AllowSystemsProtocols = True},
      Module[
        {
          fakeBench, instrument, tabletCutter, tabletCrusher, tabletCrusherBags, tabletHolder, glassPlate,
          container1, container2, container3, container4, container5, container6, container7, container8, container9, samplePlate,
          liquidSample1, liquidSample2, liquidSample3, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3
        },
        (* set up fake bench as a location for the vessel *)
        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for ValidRamanSpectroscopyQ tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* set up instrument and tablet crusher bags *)
        instrument = Upload[<|
          Type -> Object[Instrument, RamanSpectrometer],
          Model ->Link[Model[Instrument, RamanSpectrometer, "THz Raman WPS"],Objects],
          Name -> "Fake instrument for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
          Status -> Available,
          DeveloperObject->True
        |>];

        tabletCrusherBags = Upload[<|
          Type -> Object[Item, TabletCrusherBag],
          Model -> Link[Model[Item, TabletCrusherBag, "Silent Knight tablet crusher bag"], Objects],
          Name -> "Fake tablet crusher bags for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
          StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
          Count -> 50,
          Status -> Available
        |>];

        (* set up fake containers for our samples *)
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
          glassPlate,
          tabletHolder,
          tabletCutter,
          tabletCrusher
        } = UploadSample[
          {
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Vessel, "id:bq9LA0dBGGR6"],
            Model[Container, Plate, "96-well glass bottom plate"],
            Model[Container, Plate, Irregular, Raman, "18-well multi-size tablet holder"],
            Model[Item, TabletCutter, "Single blade tablet cutter"],
            Model[Item, TabletCrusher, "Silent Knight tablet crusher"]
          },
          {
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench},
            {"Work Surface", fakeBench}
          },
          Status ->
              {
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
          Name ->
              {
                "Fake container 1 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake container 2 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake container 3 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake container 4 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake container 5 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake container 6 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake container 7 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake container 8 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake container 9 for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake sample plate for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake tablet holder for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake tablet cutter for ValidRamanSpectroscopyQ tests" <> $SessionUUID,
                "Fake tablet crusher for ValidRamanSpectroscopyQ tests" <> $SessionUUID
              }
        ];

        (* set up fake samples to test *)
        {
          liquidSample1,
          liquidSample2,
          liquidSample3,
          solidSample1,
          solidSample2,
          solidSample3,
          tabletSample1,
          tabletSample2,
          tabletSample3
        } = UploadSample[
          {
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Milli-Q water"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Sodium Chloride"],
            Model[Sample, "Ibuprofen tablets 500 Count"],
            Model[Sample, "Ibuprofen tablets 500 Count"],
            Model[Sample, "Ibuprofen tablets 500 Count"]
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
            {"A1", container9}
          },
          InitialAmount ->
              {
                20*Milliliter,
                20*Milliliter,
                1*Milliliter,
                1*Gram,
                1*Gram,
                1*Gram,
                1,
                1,
                1
              },
          Name ->
              {
                "ValidRamanSpectroscopyQ Test Liquid 1" <> $SessionUUID,
                "ValidRamanSpectroscopyQ Test Liquid 2" <> $SessionUUID,
                "ValidRamanSpectroscopyQ Test Liquid 3" <> $SessionUUID,
                "ValidRamanSpectroscopyQ Test Solid 1" <> $SessionUUID,
                "ValidRamanSpectroscopyQ Test Solid 2" <> $SessionUUID,
                "ValidRamanSpectroscopyQ Test Solid 3" <> $SessionUUID,
                "ValidRamanSpectroscopyQ Test Tablet 1" <> $SessionUUID,
                "ValidRamanSpectroscopyQ Test Tablet 2" <> $SessionUUID,
                "ValidRamanSpectroscopyQ Test Tablet 3" <> $SessionUUID
              }
        ];

        (* upload the test objects *)
        Upload[
          <|
            Object -> #,
            AwaitingStorageUpdate -> Null
          |> & /@ Cases[
            Flatten[
              {
                container1, container2, container3, container4, container5, container6, container7, container8, container9,
                glassPlate,tabletHolder, tabletCutter, tabletCrusher,
                liquidSample1, liquidSample2, liquidSample3, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3
              }
            ],
            ObjectP[]
          ]
        ];

        (* sever model link because it cant be relied on - also update the composition of the object that will be used for the target concentration tests*)
        Upload[
          Cases[
            Flatten[
              {
                <|Object -> liquidSample1, Model -> Null|>,
                <|Object -> liquidSample2, Model -> Null|>,
                <|
                  Object -> liquidSample3, Model -> Null,
                  Replace[Composition] -> {{90 VolumePercent, Link[Model[Molecule, "id:vXl9j57PmP5D"]], Now}, {Null, Null, Null}, {0.1 Molar, Link[Model[Molecule, "Sodium Chloride"]], Now}}
                |>,
                <|Object -> solidSample1, Model -> Null|>,
                <|Object -> solidSample2, Model -> Null|>,
                <|Object -> solidSample3, Model -> Null|>,
                <|Object -> tabletSample1, Model -> Null|>,
                <|Object -> tabletSample2, Model -> Null|>,
                <|Object -> tabletSample3, Model -> Null|>
              }
            ],
            PacketP[]
          ]
        ]
      ]
    ]
  ),
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Plate, "Fake sample plate for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container,Plate,Irregular,Raman, "Fake tablet holder for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Item, TabletCutter, "Fake tablet cutter for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Item, TabletCrusher, "Fake tablet crusher for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Item, TabletCrusherBag, "Fake tablet crusher bags for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Instrument, RamanSpectrometer, "Fake instrument for ValidRamanSpectroscopyQ tests" <> $SessionUUID],

          Object[Container, Vessel, "Fake container 1 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 2 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 3 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 4 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 5 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 6 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 7 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 8 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 9 for ValidRamanSpectroscopyQ tests" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Liquid 1" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Liquid 2" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Liquid 3" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Solid 1" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Solid 2" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Solid 3" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Tablet 1" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Tablet 2" <> $SessionUUID],
          Object[Sample,"ValidRamanSpectroscopyQ Test Tablet 3" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];




(* ::Subsection:: *)
(*ExperimentRamanSpectroscopyPreview*)


(* ---------------------------------------- *)
(* -- ExperimentRamanSpectroscopyPreview -- *)
(* ---------------------------------------- *)


DefineTests[ExperimentRamanSpectroscopyPreview,
  {
    Example[{Basic,"No preview is currently available for ExperimentRamanSpectroscopy:"},
      ExperimentRamanSpectroscopyPreview[
        Object[Sample,"RamanSpectroscopyPreview Test Liquid 1" <> $SessionUUID]
      ],
      Null
    ],
    Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentRamanSpectroscopyOptions:"},
      ExperimentRamanSpectroscopyOptions[
        Object[Sample,"RamanSpectroscopyPreview Test Liquid 1" <> $SessionUUID]
      ],
      _Grid
    ],
    Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentRamanSpectroscopyQ:"},
      ValidExperimentRamanSpectroscopyQ[
        Object[Sample,"RamanSpectroscopyPreview Test Liquid 1" <> $SessionUUID]
      ],
      True
    ]
  },

  (*  build test objects *)
  Stubs:>{
    $EmailEnabled=False
  },
  SymbolSetUp :> (
    Off[Warning::SamplesOutOfStock];
    Off[Warning::InstrumentUndergoingMaintenance];

    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for RamanSpectroscopyPreview tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 1 for RamanSpectroscopyPreview tests" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyPreview Test Liquid 1" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];
    Block[{$AllowSystemsProtocols = True},
      Module[
        {
          fakeBench,
          container1,
          liquidSample1
        },
        (* set up fake bench as a location for the vessel *)
        fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Fake bench for RamanSpectroscopyPreview tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

        (* set up fake containers for our samples *)
        {
          container1
        } = UploadSample[
          {
            Model[Container, Vessel, "id:bq9LA0dBGGR6"]
          },
          {
            {"Work Surface", fakeBench}
          },
          Status ->
              {
                Available
              },
          Name ->
              {
                "Fake container 1 for RamanSpectroscopyPreview tests" <> $SessionUUID
              }
        ];

        (* set up fake samples to test *)
        {
          liquidSample1
        } = UploadSample[
          {
            Model[Sample, "Milli-Q water"]
          },
          {
            {"A1", container1}
          },
          InitialAmount ->
              {
                20*Milliliter
              },
          Name ->
              {
                "RamanSpectroscopyPreview Test Liquid 1" <> $SessionUUID
              }
        ];

        (* upload the test objects *)
        Upload[
          <|
            Object -> #,
            DeveloperObject -> True,
            AwaitingStorageUpdate -> Null
          |> & /@ Cases[
            Flatten[
              {
                container1,
                liquidSample1
              }
            ],
            ObjectP[]
          ]
        ];

        (* sever model link because it cant be relied on - also update the composition of the object that will be used for the target concentration tests*)
        Upload[
          Cases[
            Flatten[
              {
                <|Object -> liquidSample1, Model -> Null|>
              }
            ],
            PacketP[]
          ]
        ]
      ]
    ]
  ),
  SymbolTearDown :> (
    On[Warning::SamplesOutOfStock];
    On[Warning::InstrumentUndergoingMaintenance];

    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Container, Bench, "Fake bench for RamanSpectroscopyPreview tests" <> $SessionUUID],
          Object[Container, Vessel, "Fake container 1 for RamanSpectroscopyPreview tests" <> $SessionUUID],
          Object[Sample,"RamanSpectroscopyPreview Test Liquid 1" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ]
  )
];
