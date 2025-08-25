(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*AnalyzeEpitopeBinning: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*AnalyzeEpitopeBinning*)


DefineTests[AnalyzeEpitopeBinning,
  (* -- TESTS -- *)

  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry], AnalyzeEpitopeBinning returns an Analysis Object:"},
      AnalyzeEpitopeBinning[Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID]],
      ObjectP[Object[Analysis, EpitopeBinning]],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given a list of Data[Protocol,BioLayerInterferometry], AnalyzeEpitopeBinning returns an Analysis Object:"},
      AnalyzeEpitopeBinning[
        {
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 7" <> $SessionUUID]
        }
      ],
      ObjectP[Object[Analysis, EpitopeBinning]],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],


    (* ------------- *)
    (* -- OPTIONS -- *)
    (* ------------- *)

    Example[{Options, FitDomain, "Specify the region of each competition step to average to obtain the response value using time:"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        FitDomain -> 20 Second,
        Output -> Options
      ];
      Lookup[options, FitDomain],
      20 Second,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, FitDomain, "Specify the region of each competition step to average to obtain the response value using percent of the total step time:"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        FitDomain -> 10 Percent,
        Output -> Options
      ];
      Lookup[options, FitDomain],
      10 Percent,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, Threshold, "Automatically resolve the Threshold to a raw response (in Nanometer) if the data is not analyzed with a NormalizationMethod:"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        NormalizationMethod -> None,
        Output -> Options
      ];
      Lookup[options, Threshold],
      _?QuantityQ,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, Threshold, "Automatically resolve the Threshold to a normalized response if the data is analyzed with a NormalizationMethod:"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        NormalizationMethod -> LoadingCapacity,
        Output -> Options
      ];
      Lookup[options, Threshold],
      _?NumericQ,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, SlowBindingSpecies, "Specify species which exhibit slow binding that results in low response even when it is not blocked by the bound antibody:"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        SlowBindingSpecies -> {Object[Sample, "Test sample for AnalyzeEpitopeBinning 2" <> $SessionUUID], Object[Sample, "Test sample for AnalyzeEpitopeBinning 3" <> $SessionUUID]},
        Output -> Options
      ];
      Lookup[options, SlowBindingSpecies],
      {Object[Sample, "Test sample for AnalyzeEpitopeBinning 2" <> $SessionUUID], Object[Sample, "Test sample for AnalyzeEpitopeBinning 3" <> $SessionUUID]},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, SlowBindingThreshold, "Specify a lower threshold for species which exhibit slow binding:"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        SlowBindingThreshold -> 0.1 Nanometer,
        SlowBindingSpecies ->{Object[Sample, "Test sample for AnalyzeEpitopeBinning 2" <> $SessionUUID], Object[Sample, "Test sample for AnalyzeEpitopeBinning 3" <> $SessionUUID]},
        Output -> Options
      ];
      Lookup[options, SlowBindingThreshold],
      0.1 Nanometer,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, BaselineType, "Specify the type of baseline well used to account for drift or solvent/media based fluctuation in response signal (PreviousWell):"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        BaselineType -> PreviousWell,
        Output -> Options
      ];
      Lookup[options, BaselineType],
      PreviousWell,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, BaselineType, "Specify the type of baseline well used to account for drift or solvent/media based fluctuation in response signal (SelfBlocking):"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        BaselineType -> SelfBlocking,
        Output -> Options
      ];
      Lookup[options, BaselineType],
      SelfBlocking,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, NormalizationMethod, "Specify the type of well used to normalize response - use the initial loading step for a given antibody as the maximum value:"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        NormalizationMethod -> LoadingCapacity,
        Output -> Options
      ];
      Lookup[options, NormalizationMethod],
      LoadingCapacity,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, NormalizationMethod, "Specify the type of well used to normalize response - use a parallel well in which the antibody loads an unblocked antigen covered surface:"},
      options = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        NormalizationMethod -> IsolatedAntibody,
        Output -> Options
      ];
      Lookup[options, NormalizationMethod],
      IsolatedAntibody,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

        (* -------------- *)
        (* -- MESSAGES -- *)
    (* -------------- *)
    Example[{Messages, SlowBindingThreshold, "If the SlowBindingThreshold is specified but no SlowBindingSpecies are given, an error will be shown:"},
      AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        SlowBindingThreshold -> 0.2 Nanometer
      ],
      $Failed,
      Messages :> {Error::EpitopeBinningMissingSlowBindingSpecies,Error::InvalidOption},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, BaselineType, "If there is no data element matching the requested BaselineType, an error will be shown:"},
      AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        BaselineType -> Parallel
      ],
      $Failed,
      Messages :> {Error::EpitopeBinningMissingBaselineData,Error::InvalidOption},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Threshold, "If the Threshold is given in raw data form but a NormalizationMethod is specified, and error will be shown:"},
      AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        Threshold -> 0.2 Nanometer,
        NormalizationMethod -> IsolatedAntibody
      ],
      $Failed,
      Messages :> {Error::EpitopeBinningIncompatibleThresholdFormat,Error::InvalidOption},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Threshold, "If the Threshold is lower than SlowBindingThreshold, and error will be shown:"},
      AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        Threshold -> 0.2 Nanometer,
        SlowBindingThreshold -> 0.3 Nanometer,
        SlowBindingSpecies -> {Object[Sample, "Test sample for AnalyzeEpitopeBinning 6" <> $SessionUUID]}
      ],
      $Failed,
      Messages :> {Error::EpitopeBinningSwappedThresholds,Error::InvalidOption},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, IncompleteData, "Given an incomplete list of Data[Protocol,BioLayerInterferometry], AnalyzeEpitopeBinning returns $Failed:"},
      AnalyzeEpitopeBinning[
        {
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 7" <> $SessionUUID]
        }
      ],
      $Failed,
      Messages:>{
        Error::InvalidInput,
        Error::EpitopeBinningIncompleteDataSet
      },
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ]
  },

  (* -- SETUP -- *)
  SymbolSetUp :> {
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 2" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Sandwich" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - PreMix" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 8" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 8" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 8" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 1" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 2" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 3" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 4" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 5" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 6" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 7" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 8" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 9" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinning 10" <> $SessionUUID],
          Object[Sample, "Blank for AnalyzeEpitopeBinning" <> $SessionUUID],
          Object[Sample, "Antigen for AnalyzeEpitopeBinning" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];

    Module[{
      (* parameters for data generation *)
      bindingConst, nonBindingConst, ambiguousConst, timeRange,
      (*fake data and baeslines*)
      baselineData, ambiguousData, nonBindingData, bindingData,
      (* fake protocols *)
      protocolObjectPackets,
      (* fake data objects *)
      tandemDataPackets, premixDataPackets, sandwichDataPackets,
      (* fake samples *)
      fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7, fakeSample8, fakeSample9, fakeSample10,
      blank, antigen
    },

      (* make an expression to generate fake data with quasi 1:1 model, simulating kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
      bindingResponse[t_, const_]:= 2*(1 - Exp[-const*t]);
      bindingConst = 0.005;
      nonBindingConst = 0;
      ambiguousConst = 0.0005;
      timeRange = 200;

      (* -- generate fake data and baselines -- *)
      bindingData = QuantityArray[Table[{time, bindingResponse[time, bindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      nonBindingData = QuantityArray[Table[{time, bindingResponse[time, nonBindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      ambiguousData = QuantityArray[Table[{time, bindingResponse[time, ambiguousConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      baselineData = QuantityArray[Transpose[{Range[200], ConstantArray[0, 200]}], {Second, Nanometer}];


      (* make a basic fake sample to reference *)
      (*TODO: This will need to be upgraded eventually so that these all have different analytes and composition if the Model[Molecule] feature is added*)
      {
        fakeSample1,
        fakeSample2,
        fakeSample3,
        fakeSample4,
        fakeSample5,
        fakeSample6,
        fakeSample7,
        fakeSample8,
        fakeSample9,
        fakeSample10
      } = Upload[
        Table[<|
          Type -> Object[Sample],
          Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
          Name -> "Test sample for AnalyzeEpitopeBinning "<>ToString[index]<>$SessionUUID
        |>,
          {index, 1, 10}
        ]
      ];

      (* blanks and antigen *)
      {blank, antigen} = Upload[
        {
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Blank for AnalyzeEpitopeBinning" <> $SessionUUID
          |>,
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Antigen for AnalyzeEpitopeBinning" <> $SessionUUID
          |>
        }
      ];

      (* ------------ *)
      (* -- TANDEM -- *)
      (* ------------ *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      tandemDataPackets = Module[
        {tandemSolutionReplaceRules,rawTandemWellInfo, sortedTandemWellInfo, tandemMeasurementData, tandemWellData,
          tandemCompetingSolutions, tandemCompetitionData, rawTandemMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        tandemSolutionReplaceRules = {
          {1,_, _}->antigen,
          {(2|4),_, _}->blank,
          {3,1,_}->fakeSample1,
          {3,2,_}->fakeSample2,
          {3,3,_}->fakeSample3,
          {3,4,_}->fakeSample4,
          {3,5,_}->fakeSample5,
          {3,6,_}->fakeSample6,
          {3,7,_}->fakeSample7,
          {3,8,_}->blank,
          {5,_, 1}-> fakeSample1,
          {5,_, 2}-> fakeSample2,
          {5,_, 3}-> fakeSample3,
          {5,_, 4}-> fakeSample4,
          {5,_, 5}-> fakeSample5,
          {5,_, 6}-> fakeSample6,
          {5,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawTandemWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> LoadSurface, 4 ->MeasureBaseline, 5-> MeasureAssociation},
            Link[{step,channel, assay}/.tandemSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 5},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedTandemWellInfo = Sort[Cases[rawTandemWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawTandemMeasuredWellPositions = Map[Cases[sortedTandemWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 5-7 *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        tandemMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        tandemWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            tandemMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        tandemCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        tandemCompetitionData = Most[Transpose[tandemMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> Tandem,
              Name -> "Test data for AnalyzeEpitopeBinning - Tandem "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> tandemWellData,
              Replace[WellInformation] -> sortedTandemWellInfo,
              Replace[CompetingSolutions] -> Link/@tandemCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {tandemCompetitionData, rawTandemMeasuredWellPositions, tandemCompetingSolutions, Range[7]}
        ]
      ];



      (* -------------- *)
      (* -- SANDWICH -- *)
      (* -------------- *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      sandwichDataPackets = Module[
        {sandwichSolutionReplaceRules,rawsandwichWellInfo, sortedsandwichWellInfo, sandwichMeasurementData, sandwichWellData,
          sandwichCompetingSolutions, sandwichCompetitionData, rawsandwichMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        sandwichSolutionReplaceRules = {
          {3,_, _}->antigen,
          {(2|4),_, _}->blank,
          {1,1,_}->fakeSample1,
          {1,2,_}->fakeSample2,
          {1,3,_}->fakeSample3,
          {1,4,_}->fakeSample4,
          {1,5,_}->fakeSample5,
          {1,6,_}->fakeSample6,
          {1,7,_}->fakeSample7,
          {1,8,_}->blank,
          {5,_, 1}-> fakeSample1,
          {5,_, 2}-> fakeSample2,
          {5,_, 3}-> fakeSample3,
          {5,_, 4}-> fakeSample4,
          {5,_, 5}-> fakeSample5,
          {5,_, 6}-> fakeSample6,
          {5,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawsandwichWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> LoadSurface, 4 ->MeasureBaseline, 5-> MeasureAssociation},
            Link[{step,channel, assay}/.sandwichSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 5},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedsandwichWellInfo = Sort[Cases[rawsandwichWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawsandwichMeasuredWellPositions = Map[Cases[sortedsandwichWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 6, {5,7} *)
        (* 6 is a slow binder which gives an ambiguous result *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        sandwichMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[bindingData, 4], {baselineData, ambiguousData, baselineData}],
          Join[ConstantArray[bindingData, 4], {bindingData,baselineData, bindingData}],
          Join[ConstantArray[bindingData, 4], {baselineData, ambiguousData, baselineData}],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        sandwichWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            sandwichMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        sandwichCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        sandwichCompetitionData = Most[Transpose[sandwichMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> Sandwich,
              Name -> "Test data for AnalyzeEpitopeBinning - Sandwich "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> sandwichWellData,
              Replace[WellInformation] -> sortedsandwichWellInfo,
              Replace[CompetingSolutions] -> Link/@sandwichCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {sandwichCompetitionData, rawsandwichMeasuredWellPositions, sandwichCompetingSolutions, Range[7]}
        ]
      ];



      (* ------------ *)
      (* -- PREMIX -- *)
      (* ------------ *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      premixDataPackets = Module[
        {premixSolutionReplaceRules,rawpremixWellInfo, sortedpremixWellInfo, premixMeasurementData, premixWellData,
          premixCompetingSolutions, premixCompetitionData, rawpremixMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        premixSolutionReplaceRules = {
          {2,_, _}->blank,
          {1,1,_}->fakeSample1,
          {1,2,_}->fakeSample2,
          {1,3,_}->fakeSample3,
          {1,4,_}->fakeSample4,
          {1,5,_}->fakeSample5,
          {1,6,_}->fakeSample6,
          {1,7,_}->fakeSample7,
          {1,8,_}->blank,
          {3,_, 1}-> fakeSample1,
          {3,_, 2}-> fakeSample2,
          {3,_, 3}-> fakeSample3,
          {3,_, 4}-> fakeSample4,
          {3,_, 5}-> fakeSample5,
          {3,_, 6}-> fakeSample6,
          {3,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawpremixWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> MeasureAssociation},
            Link[{step,channel, assay}/.premixSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 3},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedpremixWellInfo = Sort[Cases[rawpremixWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawpremixMeasuredWellPositions = Map[Cases[sortedpremixWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 5-7 *)
        (* added some ambiguous data here *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        premixMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        premixWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            premixMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        premixCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        premixCompetitionData = Most[Transpose[premixMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> PreMix,
              Name -> "Test data for AnalyzeEpitopeBinning - PreMix "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> premixWellData,
              Replace[WellInformation] -> sortedpremixWellInfo,
              Replace[CompetingSolutions] -> Link/@premixCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {premixCompetitionData, rawpremixMeasuredWellPositions, premixCompetingSolutions, Range[7]}
        ]
      ];



      (* ------------------------- *)
      (* -- UPLOAD DATA PACKETS -- *)
      (* ------------------------- *)

      Upload[Flatten[{tandemDataPackets, sandwichDataPackets, premixDataPackets}]];


      (* ---------------------- *)
      (* -- PROTOCOL OBJECTS -- *)
      (* ---------------------- *)

      (*Make a test protocol object*)
      protocolObjectPackets = {
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Name ->  "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
            Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
            Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 2" <> $SessionUUID],
            Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 3" <> $SessionUUID],
            Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 4" <> $SessionUUID],
            Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 5" <> $SessionUUID],
            Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 6" <> $SessionUUID],
            Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 7" <> $SessionUUID]
          }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinning - Sandwich" <> $SessionUUID,
          ExperimentType -> EpitopeBinning,
          BinningType -> Sandwich,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 7" <> $SessionUUID]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinning - PreMix" <> $SessionUUID,
          ExperimentType -> EpitopeBinning,
          BinningType -> PreMix,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 7" <> $SessionUUID]
            }
          ]
        ]
        (*Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinning - Tandem 2" <> $SessionUUID,
                    ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Replace[SamplesIn] -> Link/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7},
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 7" <> $SessionUUID]
            }
          ]
        ],
*)
      };

      Upload[protocolObjectPackets];
    ];

  },


  (* -------------- *)
  (* -- TEARDOWN -- *)
  (* -------------- *)


  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Tandem 2" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - Sandwich" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinning - PreMix" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Tandem 8" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - Sandwich 8" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinning - PreMix 8" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 1" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 2" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 3" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 4" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 5" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 6" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 7" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 8" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 9" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinning 10" <> $SessionUUID],
        Object[Sample, "Blank for AnalyzeEpitopeBinning" <> $SessionUUID],
        Object[Sample, "Antigen for AnalyzeEpitopeBinning" <> $SessionUUID]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];








(* ::Subsubsection:: *)
(*ValidAnalyzeEpitopeBinningQ*)


DefineTests[ValidAnalyzeEpitopeBinningQ,
  (* -- TESTS -- *)

  {
    Example[{Basic, "Given an Object[Protocol,BioLayerInterferometry], ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID]],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic, "Given a list of Data[Protocol,BioLayerInterferometry], ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        {
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 7" <> $SessionUUID]
        }
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],


    (* ------------- *)
    (* -- OPTIONS -- *)
    (* ------------- *)
    Example[{Options, OutputFormat, "Specifying that OutputFormat->TestSummary and ValidAnalyzeEpitopeBinningQ returns a test summary:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        OutputFormat -> TestSummary
      ],
      _EmeraldTestSummary,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, FitDomain, "Specify the region of each competition step to average to obtain the response value using time and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        FitDomain -> 20 Second,
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, FitDomain, "Specify the region of each competition step to average to obtain the response value using percent of the total step time and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        FitDomain -> 10 Percent,
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, Threshold, "Automatically resolve the Threshold to a raw response (in Nanometer) if the data is not analyzed with a NormalizationMethod and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        NormalizationMethod -> None,
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, Threshold, "Automatically resolve the Threshold to a normalized response if the data is analyzed with a NormalizationMethod and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        NormalizationMethod -> LoadingCapacity,
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, SlowBindingSpecies, "Specify species which exhibit slow binding that results in low response even when it is not blocked by the bound antibody and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        SlowBindingSpecies -> {Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 2" <> $SessionUUID], Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 3" <> $SessionUUID]},
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, SlowBindingThreshold, "Specify a lower threshold for species which exhibit slow binding and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        SlowBindingThreshold -> 0.1 Nanometer,
        SlowBindingSpecies ->{Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 2" <> $SessionUUID], Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 3" <> $SessionUUID]},
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, BaselineType, "Specify the type of baseline well used to account for drift or solvent/media based fluctuation in response signal (PreviousWell) and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        BaselineType -> PreviousWell,
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, BaselineType, "Specify the type of baseline well used to account for drift or solvent/media based fluctuation in response signal (SelfBlocking) and ValidAnalyzeEpitopeBinningQ returns True:"},
      options = ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        BaselineType -> SelfBlocking,
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, NormalizationMethod, "Specify the type of well used to normalize response - use the initial loading step for a given antibody as the maximum value and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        NormalizationMethod -> LoadingCapacity,
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Options, NormalizationMethod, "Specify the type of well used to normalize response - use a parallel well in which the antibody loads an unblocked antigen covered surface and ValidAnalyzeEpitopeBinningQ returns True:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        NormalizationMethod -> IsolatedAntibody,
        Output -> Options
      ],
      True,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],

    (* -------------- *)
    (* -- MESSAGES -- *)
    (* -------------- *)
    Example[{Messages, SlowBindingThreshold, "If the SlowBindingThreshold is specified but no SlowBindingSpecies are given, ValidAnalyzeEpitopeBinningQ returns False:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        SlowBindingThreshold -> 0.2 Nanometer
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, BaselineType, "If there is no data element matching the requested BaselineType, ValidAnalyzeEpitopeBinningQ returns False:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        BaselineType -> Parallel
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Threshold, "If the Threshold is given in raw data form but a NormalizationMethod is specified, ValidAnalyzeEpitopeBinningQ returns False:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        Threshold -> 0.2 Nanometer,
        NormalizationMethod -> IsolatedAntibody
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, Threshold, "If the Threshold is lower than SlowBindingThreshold, ValidAnalyzeEpitopeBinningQ returns False:"},
      ValidAnalyzeEpitopeBinningQ[
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        Threshold -> 0.2 Nanometer,
        SlowBindingThreshold -> 0.3 Nanometer,
        SlowBindingSpecies -> {Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 6" <> $SessionUUID]}
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Messages, IncompleteData, "Given an incomplete list of Data[Protocol,BioLayerInterferometry], ValidAnalyzeEpitopeBinningQ returns False:"},
      ValidAnalyzeEpitopeBinningQ[
        {
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 7" <> $SessionUUID]
        }
      ],
      False,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ]
  },

  (* -- SETUP -- *)
  SymbolSetUp :> {
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 2" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Sandwich" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - PreMix" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 8" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 8" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 8" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 1" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 2" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 3" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 4" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 5" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 6" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 7" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 8" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 9" <> $SessionUUID],
          Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 10" <> $SessionUUID],
          Object[Sample, "Blank for ValidAnalyzeEpitopeBinningQ" <> $SessionUUID],
          Object[Sample, "Antigen for ValidAnalyzeEpitopeBinningQ" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];

    Module[{
      (* parameters for data generation *)
      bindingConst, nonBindingConst, ambiguousConst, timeRange,
      (*fake data and baeslines*)
      baselineData, ambiguousData, nonBindingData, bindingData,
      (* fake protocols *)
      protocolObjectPackets,
      (* fake data objects *)
      tandemDataPackets, premixDataPackets, sandwichDataPackets,
      (* fake samples *)
      fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7, fakeSample8, fakeSample9, fakeSample10,
      blank, antigen
    },

      (* make an expression to generate fake data with quasi 1:1 model, simulating kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
      bindingResponse[t_, const_]:= 2*(1 - Exp[-const*t]);
      bindingConst = 0.005;
      nonBindingConst = 0;
      ambiguousConst = 0.0005;
      timeRange = 200;

      (* -- generate fake data and baselines -- *)
      bindingData = QuantityArray[Table[{time, bindingResponse[time, bindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      nonBindingData = QuantityArray[Table[{time, bindingResponse[time, nonBindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      ambiguousData = QuantityArray[Table[{time, bindingResponse[time, ambiguousConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      baselineData = QuantityArray[Transpose[{Range[200], ConstantArray[0, 200]}], {Second, Nanometer}];


      (* make a basic fake sample to reference *)
      (*TODO: This will need to be upgraded eventually so that these all have different analytes and composition if the Model[Molecule] feature is added*)
      {
        fakeSample1,
        fakeSample2,
        fakeSample3,
        fakeSample4,
        fakeSample5,
        fakeSample6,
        fakeSample7,
        fakeSample8,
        fakeSample9,
        fakeSample10
      } = Upload[
        Table[<|
          Type -> Object[Sample],
          Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
          Name -> "Test sample for ValidAnalyzeEpitopeBinningQ "<>ToString[index]<>$SessionUUID
        |>,
          {index, 1, 10}
        ]
      ];

      (* blanks and antigen *)
      {blank, antigen} = Upload[
        {
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Blank for ValidAnalyzeEpitopeBinningQ" <> $SessionUUID
          |>,
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Antigen for ValidAnalyzeEpitopeBinningQ" <> $SessionUUID
          |>
        }
      ];

      (* ------------ *)
      (* -- TANDEM -- *)
      (* ------------ *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      tandemDataPackets = Module[
        {tandemSolutionReplaceRules,rawTandemWellInfo, sortedTandemWellInfo, tandemMeasurementData, tandemWellData,
          tandemCompetingSolutions, tandemCompetitionData, rawTandemMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        tandemSolutionReplaceRules = {
          {1,_, _}->antigen,
          {(2|4),_, _}->blank,
          {3,1,_}->fakeSample1,
          {3,2,_}->fakeSample2,
          {3,3,_}->fakeSample3,
          {3,4,_}->fakeSample4,
          {3,5,_}->fakeSample5,
          {3,6,_}->fakeSample6,
          {3,7,_}->fakeSample7,
          {3,8,_}->blank,
          {5,_, 1}-> fakeSample1,
          {5,_, 2}-> fakeSample2,
          {5,_, 3}-> fakeSample3,
          {5,_, 4}-> fakeSample4,
          {5,_, 5}-> fakeSample5,
          {5,_, 6}-> fakeSample6,
          {5,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawTandemWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> LoadSurface, 4 ->MeasureBaseline, 5-> MeasureAssociation},
            Link[{step,channel, assay}/.tandemSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 5},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedTandemWellInfo = Sort[Cases[rawTandemWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawTandemMeasuredWellPositions = Map[Cases[sortedTandemWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 5-7 *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        tandemMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        tandemWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            tandemMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        tandemCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        tandemCompetitionData = Most[Transpose[tandemMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> Tandem,
              Name -> "Test data for ValidAnalyzeEpitopeBinningQ - Tandem "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> tandemWellData,
              Replace[WellInformation] -> sortedTandemWellInfo,
              Replace[CompetingSolutions] -> Link/@tandemCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {tandemCompetitionData, rawTandemMeasuredWellPositions, tandemCompetingSolutions, Range[7]}
        ]
      ];



      (* -------------- *)
      (* -- SANDWICH -- *)
      (* -------------- *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      sandwichDataPackets = Module[
        {sandwichSolutionReplaceRules,rawsandwichWellInfo, sortedsandwichWellInfo, sandwichMeasurementData, sandwichWellData,
          sandwichCompetingSolutions, sandwichCompetitionData, rawsandwichMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        sandwichSolutionReplaceRules = {
          {3,_, _}->antigen,
          {(2|4),_, _}->blank,
          {1,1,_}->fakeSample1,
          {1,2,_}->fakeSample2,
          {1,3,_}->fakeSample3,
          {1,4,_}->fakeSample4,
          {1,5,_}->fakeSample5,
          {1,6,_}->fakeSample6,
          {1,7,_}->fakeSample7,
          {1,8,_}->blank,
          {5,_, 1}-> fakeSample1,
          {5,_, 2}-> fakeSample2,
          {5,_, 3}-> fakeSample3,
          {5,_, 4}-> fakeSample4,
          {5,_, 5}-> fakeSample5,
          {5,_, 6}-> fakeSample6,
          {5,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawsandwichWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> LoadSurface, 4 ->MeasureBaseline, 5-> MeasureAssociation},
            Link[{step,channel, assay}/.sandwichSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 5},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedsandwichWellInfo = Sort[Cases[rawsandwichWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawsandwichMeasuredWellPositions = Map[Cases[sortedsandwichWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 6, {5,7} *)
        (* 6 is a slow binder which gives an ambiguous result *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        sandwichMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[bindingData, 4], {baselineData, ambiguousData, baselineData}],
          Join[ConstantArray[bindingData, 4], {bindingData,baselineData, bindingData}],
          Join[ConstantArray[bindingData, 4], {baselineData, ambiguousData, baselineData}],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        sandwichWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            sandwichMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        sandwichCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        sandwichCompetitionData = Most[Transpose[sandwichMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> Sandwich,
              Name -> "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> sandwichWellData,
              Replace[WellInformation] -> sortedsandwichWellInfo,
              Replace[CompetingSolutions] -> Link/@sandwichCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {sandwichCompetitionData, rawsandwichMeasuredWellPositions, sandwichCompetingSolutions, Range[7]}
        ]
      ];



      (* ------------ *)
      (* -- PREMIX -- *)
      (* ------------ *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      premixDataPackets = Module[
        {premixSolutionReplaceRules,rawpremixWellInfo, sortedpremixWellInfo, premixMeasurementData, premixWellData,
          premixCompetingSolutions, premixCompetitionData, rawpremixMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        premixSolutionReplaceRules = {
          {2,_, _}->blank,
          {1,1,_}->fakeSample1,
          {1,2,_}->fakeSample2,
          {1,3,_}->fakeSample3,
          {1,4,_}->fakeSample4,
          {1,5,_}->fakeSample5,
          {1,6,_}->fakeSample6,
          {1,7,_}->fakeSample7,
          {1,8,_}->blank,
          {3,_, 1}-> fakeSample1,
          {3,_, 2}-> fakeSample2,
          {3,_, 3}-> fakeSample3,
          {3,_, 4}-> fakeSample4,
          {3,_, 5}-> fakeSample5,
          {3,_, 6}-> fakeSample6,
          {3,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawpremixWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> MeasureAssociation},
            Link[{step,channel, assay}/.premixSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 3},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedpremixWellInfo = Sort[Cases[rawpremixWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawpremixMeasuredWellPositions = Map[Cases[sortedpremixWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 5-7 *)
        (* added some ambiguous data here *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        premixMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        premixWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            premixMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        premixCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        premixCompetitionData = Most[Transpose[premixMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> PreMix,
              Name -> "Test data for ValidAnalyzeEpitopeBinningQ - PreMix "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> premixWellData,
              Replace[WellInformation] -> sortedpremixWellInfo,
              Replace[CompetingSolutions] -> Link/@premixCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {premixCompetitionData, rawpremixMeasuredWellPositions, premixCompetingSolutions, Range[7]}
        ]
      ];



      (* ------------------------- *)
      (* -- UPLOAD DATA PACKETS -- *)
      (* ------------------------- *)

      Upload[Flatten[{tandemDataPackets, sandwichDataPackets, premixDataPackets}]];


      (* ---------------------- *)
      (* -- PROTOCOL OBJECTS -- *)
      (* ---------------------- *)

      (*Make a test protocol object*)
      protocolObjectPackets = {
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Name ->  "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 7" <> $SessionUUID]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for ValidAnalyzeEpitopeBinningQ - Sandwich" <> $SessionUUID,
          ExperimentType -> EpitopeBinning,
          BinningType -> Sandwich,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 7" <> $SessionUUID]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for ValidAnalyzeEpitopeBinningQ - PreMix" <> $SessionUUID,
          ExperimentType -> EpitopeBinning,
          BinningType -> PreMix,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 7" <> $SessionUUID]
            }
          ]
        ]
        (*Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 2" <> $SessionUUID,
                    ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Replace[SamplesIn] -> Link/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7},
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 7" <> $SessionUUID]
            }
          ]
        ],
*)
      };

      Upload[protocolObjectPackets];
    ];

  },


  (* -------------- *)
  (* -- TEARDOWN -- *)
  (* -------------- *)


  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Tandem 2" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - Sandwich" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for ValidAnalyzeEpitopeBinningQ - PreMix" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Tandem 8" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - Sandwich 8" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for ValidAnalyzeEpitopeBinningQ - PreMix 8" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 1" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 2" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 3" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 4" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 5" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 6" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 7" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 8" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 9" <> $SessionUUID],
        Object[Sample, "Test sample for ValidAnalyzeEpitopeBinningQ 10" <> $SessionUUID],
        Object[Sample, "Blank for ValidAnalyzeEpitopeBinningQ" <> $SessionUUID],
        Object[Sample, "Antigen for ValidAnalyzeEpitopeBinningQ" <> $SessionUUID]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];








(* ::Subsubsection:: *)
(*AnalyzeEpitopeBinningOptions*)


DefineTests[AnalyzeEpitopeBinningOptions,
  (* -- TESTS -- *)

  {
      Example[{Basic,"Return all options with Automatic resolved to a fixed value:"},
        AnalyzeEpitopeBinningOptions[
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID]
        ],
        _Grid,
        SetUp :> (
          $CreatedObjects = {}
        ),
        TearDown :> (
          EraseObject[$CreatedObjects, Force -> True];
          Unset[$CreatedObjects]
        )
      ],
      Example[{Options,OutputFormat,"Return the options as a list:"},
        AnalyzeEpitopeBinningOptions[
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID],
          OutputFormat ->List
        ],
        _List,
        SetUp :> (
          $CreatedObjects = {}
        ),
        TearDown :> (
          EraseObject[$CreatedObjects, Force -> True];
          Unset[$CreatedObjects]
        )
      ]
  },

  (* -- SETUP -- *)
  SymbolSetUp :> {
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - Tandem 2" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - Sandwich" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - PreMix" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 8" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 8" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 8" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 1" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 2" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 3" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 4" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 5" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 6" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 7" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 8" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 9" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 10" <> $SessionUUID],
          Object[Sample, "Blank for AnalyzeEpitopeBinningOptions" <> $SessionUUID],
          Object[Sample, "Antigen for AnalyzeEpitopeBinningOptions" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];

    Module[{
      (* parameters for data generation *)
      bindingConst, nonBindingConst, ambiguousConst, timeRange,
      (*fake data and baeslines*)
      baselineData, ambiguousData, nonBindingData, bindingData,
      (* fake protocols *)
      protocolObjectPackets,
      (* fake data objects *)
      tandemDataPackets, premixDataPackets, sandwichDataPackets,
      (* fake samples *)
      fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7, fakeSample8, fakeSample9, fakeSample10,
      blank, antigen
    },

      (* make an expression to generate fake data with quasi 1:1 model, simulating kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
      bindingResponse[t_, const_]:= 2*(1 - Exp[-const*t]);
      bindingConst = 0.005;
      nonBindingConst = 0;
      ambiguousConst = 0.0005;
      timeRange = 200;

      (* -- generate fake data and baselines -- *)
      bindingData = QuantityArray[Table[{time, bindingResponse[time, bindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      nonBindingData = QuantityArray[Table[{time, bindingResponse[time, nonBindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      ambiguousData = QuantityArray[Table[{time, bindingResponse[time, ambiguousConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      baselineData = QuantityArray[Transpose[{Range[200], ConstantArray[0, 200]}], {Second, Nanometer}];


      (* make a basic fake sample to reference *)
      (*TODO: This will need to be upgraded eventually so that these all have different analytes and composition if the Model[Molecule] feature is added*)
      {
        fakeSample1,
        fakeSample2,
        fakeSample3,
        fakeSample4,
        fakeSample5,
        fakeSample6,
        fakeSample7,
        fakeSample8,
        fakeSample9,
        fakeSample10
      } = Upload[
        Table[<|
          Type -> Object[Sample],
          Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
          Name -> "Test sample for AnalyzeEpitopeBinningOptions "<>ToString[index]<>$SessionUUID
        |>,
          {index, 1, 10}
        ]
      ];

      (* blanks and antigen *)
      {blank, antigen} = Upload[
        {
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Blank for AnalyzeEpitopeBinningOptions" <> $SessionUUID
          |>,
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Antigen for AnalyzeEpitopeBinningOptions" <> $SessionUUID
          |>
        }
      ];

      (* ------------ *)
      (* -- TANDEM -- *)
      (* ------------ *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      tandemDataPackets = Module[
        {tandemSolutionReplaceRules,rawTandemWellInfo, sortedTandemWellInfo, tandemMeasurementData, tandemWellData,
          tandemCompetingSolutions, tandemCompetitionData, rawTandemMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        tandemSolutionReplaceRules = {
          {1,_, _}->antigen,
          {(2|4),_, _}->blank,
          {3,1,_}->fakeSample1,
          {3,2,_}->fakeSample2,
          {3,3,_}->fakeSample3,
          {3,4,_}->fakeSample4,
          {3,5,_}->fakeSample5,
          {3,6,_}->fakeSample6,
          {3,7,_}->fakeSample7,
          {3,8,_}->blank,
          {5,_, 1}-> fakeSample1,
          {5,_, 2}-> fakeSample2,
          {5,_, 3}-> fakeSample3,
          {5,_, 4}-> fakeSample4,
          {5,_, 5}-> fakeSample5,
          {5,_, 6}-> fakeSample6,
          {5,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawTandemWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> LoadSurface, 4 ->MeasureBaseline, 5-> MeasureAssociation},
            Link[{step,channel, assay}/.tandemSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 5},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedTandemWellInfo = Sort[Cases[rawTandemWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawTandemMeasuredWellPositions = Map[Cases[sortedTandemWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 5-7 *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        tandemMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        tandemWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            tandemMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        tandemCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        tandemCompetitionData = Most[Transpose[tandemMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> Tandem,
              Name -> "Test data for AnalyzeEpitopeBinningOptions - Tandem "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> tandemWellData,
              Replace[WellInformation] -> sortedTandemWellInfo,
              Replace[CompetingSolutions] -> Link/@tandemCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {tandemCompetitionData, rawTandemMeasuredWellPositions, tandemCompetingSolutions, Range[7]}
        ]
      ];





      (* -------------- *)
      (* -- SANDWICH -- *)
      (* -------------- *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      sandwichDataPackets = Module[
        {sandwichSolutionReplaceRules,rawsandwichWellInfo, sortedsandwichWellInfo, sandwichMeasurementData, sandwichWellData,
          sandwichCompetingSolutions, sandwichCompetitionData, rawsandwichMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        sandwichSolutionReplaceRules = {
          {3,_, _}->antigen,
          {(2|4),_, _}->blank,
          {1,1,_}->fakeSample1,
          {1,2,_}->fakeSample2,
          {1,3,_}->fakeSample3,
          {1,4,_}->fakeSample4,
          {1,5,_}->fakeSample5,
          {1,6,_}->fakeSample6,
          {1,7,_}->fakeSample7,
          {1,8,_}->blank,
          {5,_, 1}-> fakeSample1,
          {5,_, 2}-> fakeSample2,
          {5,_, 3}-> fakeSample3,
          {5,_, 4}-> fakeSample4,
          {5,_, 5}-> fakeSample5,
          {5,_, 6}-> fakeSample6,
          {5,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawsandwichWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> LoadSurface, 4 ->MeasureBaseline, 5-> MeasureAssociation},
            Link[{step,channel, assay}/.sandwichSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 5},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedsandwichWellInfo = Sort[Cases[rawsandwichWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawsandwichMeasuredWellPositions = Map[Cases[sortedsandwichWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 5-7 *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        sandwichMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        sandwichWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            sandwichMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        sandwichCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        sandwichCompetitionData = Most[Transpose[sandwichMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> Sandwich,
              Name -> "Test data for AnalyzeEpitopeBinningOptions - Sandwich "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> sandwichWellData,
              Replace[WellInformation] -> sortedsandwichWellInfo,
              Replace[CompetingSolutions] -> Link/@sandwichCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {sandwichCompetitionData, rawsandwichMeasuredWellPositions, sandwichCompetingSolutions, Range[7]}
        ]
      ];




      (* ------------------------- *)
      (* -- UPLOAD DATA PACKETS -- *)
      (* ------------------------- *)

      Upload[Flatten[{tandemDataPackets, sandwichDataPackets}]];

      (*Upload[Flatten[{tandemDataPackets, premixDataPackets, sandwichDataPackets}]];*)


      (* ---------------------- *)
      (* -- PROTOCOL OBJECTS -- *)
      (* ---------------------- *)

      (*Make a test protocol object*)
      protocolObjectPackets = {
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Name ->  "Test protocol for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 7" <> $SessionUUID]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinningOptions - Sandwich" <> $SessionUUID,
          ExperimentType -> EpitopeBinning,
          BinningType -> Sandwich,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 7" <> $SessionUUID]
            }
          ]
        ]
        (*Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinningOptions - Tandem 2" <> $SessionUUID,
                    ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Replace[SamplesIn] -> Link/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7},
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 7" <> $SessionUUID]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinningOptions - PreMix" <> $SessionUUID,
                    ExperimentType -> EpitopeBinning,
          BinningType -> PreMix,
          Replace[SamplesIn] -> Link/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7},
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 7" <> $SessionUUID]
            }
          ]
        ]*)
      };

      Upload[protocolObjectPackets];
    ];

  },


  (* -------------- *)
  (* -- TEARDOWN -- *)
  (* -------------- *)


  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - Tandem 2" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - Sandwich" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningOptions - PreMix" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Tandem 8" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - Sandwich 8" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningOptions - PreMix 8" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 1" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 2" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 3" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 4" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 5" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 6" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 7" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 8" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 9" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningOptions 10" <> $SessionUUID],
        Object[Sample, "Blank for AnalyzeEpitopeBinningOptions" <> $SessionUUID],
        Object[Sample, "Antigen for AnalyzeEpitopeBinningOptions" <> $SessionUUID]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];


(* ::Subsubsection:: *)
(*AnalyzeEpitopeBinningPreview*)

(*TODO: currently a pretty bad test but I cant figure out what pattern to match this on*)
DefineTests[AnalyzeEpitopeBinningPreview,
  {
    Example[{Basic,"Return a graphical display for the binning analysis:"},
      AnalyzeEpitopeBinningPreview[
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - Tandem 1" <> $SessionUUID]
      ],
      _TabView,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic,"Return a graphical display for the binning analysis without conditional formatting of slow binders:"},
      AnalyzeEpitopeBinningPreview[
        Object[Protocol,BioLayerInterferometry,"Test protocol for AnalyzeEpitopeBinningPreview - Sandwich" <> $SessionUUID],
        Threshold -> 1 Nanometer
      ],
      _TabView,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ],
    Example[{Basic,"Return a graphical display for the binning analysis with conditional formatting of slow binders:"},
      AnalyzeEpitopeBinningPreview[
        Object[Protocol,BioLayerInterferometry,"Test protocol for AnalyzeEpitopeBinningPreview - Sandwich" <> $SessionUUID],
        Threshold -> 1 Nanometer,
        SlowBindingSpecies -> {Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 6" <> $SessionUUID]},
        SlowBindingThreshold -> 0.5 Nanometer
      ],
      _TabView,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      )
    ]
  },


  (* -- SETUP -- *)
  SymbolSetUp :> {
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - Tandem 1" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - Tandem 2" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - Sandwich" <> $SessionUUID],
          Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - PreMix" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 8" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 8" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 1" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 2" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 3" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 4" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 5" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 6" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 7" <> $SessionUUID],
          Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 8" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 1" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 2" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 3" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 4" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 5" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 6" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 7" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 8" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 9" <> $SessionUUID],
          Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 10" <> $SessionUUID],
          Object[Sample, "Blank for AnalyzeEpitopeBinningPreview" <> $SessionUUID],
          Object[Sample, "Antigen for AnalyzeEpitopeBinningPreview" <> $SessionUUID]
        }],
        ObjectP[]
      ]];
      existingObjs = PickList[objs, DatabaseMemberQ[objs]];
      EraseObject[existingObjs, Force -> True, Verbose -> False]
    ];

    Module[{
      (* parameters for data generation *)
      bindingConst, nonBindingConst, ambiguousConst, timeRange,
      (*fake data and baeslines*)
      baselineData, ambiguousData, nonBindingData, bindingData,
      (* fake protocols *)
      protocolObjectPackets,
      (* fake data objects *)
      tandemDataPackets, premixDataPackets, sandwichDataPackets,
      (* fake samples *)
      fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7, fakeSample8, fakeSample9, fakeSample10,
      blank, antigen
    },

      (* make an expression to generate fake data with quasi 1:1 model, simulating kd = 0.0001 s-1, ka = 20000 M-1 s-1 *)
      bindingResponse[t_, const_]:= 2*(1 - Exp[-const*t]);
      bindingConst = 0.005;
      nonBindingConst = 0;
      ambiguousConst = 0.0005;
      timeRange = 200;

      (* -- generate fake data and baselines -- *)
      bindingData = QuantityArray[Table[{time, bindingResponse[time, bindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      nonBindingData = QuantityArray[Table[{time, bindingResponse[time, nonBindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      ambiguousData = QuantityArray[Table[{time, bindingResponse[time, ambiguousConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      baselineData = QuantityArray[Transpose[{Range[200], ConstantArray[0, 200]}], {Second, Nanometer}];


      (* make a basic fake sample to reference *)
      (*TODO: This will need to be upgraded eventually so that these all have different analytes and composition if the Model[Molecule] feature is added*)
      {
        fakeSample1,
        fakeSample2,
        fakeSample3,
        fakeSample4,
        fakeSample5,
        fakeSample6,
        fakeSample7,
        fakeSample8,
        fakeSample9,
        fakeSample10
      } = Upload[
        Table[<|
          Type -> Object[Sample],
          Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
          Name -> "Test sample for AnalyzeEpitopeBinningPreview "<>ToString[index]<>$SessionUUID
        |>,
          {index, 1, 10}
        ]
      ];

      (* blanks and antigen *)
      {blank, antigen} = Upload[
        {
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Blank for AnalyzeEpitopeBinningPreview" <> $SessionUUID
          |>,
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Antigen for AnalyzeEpitopeBinningPreview" <> $SessionUUID
          |>
        }
      ];

      (* ------------ *)
      (* -- TANDEM -- *)
      (* ------------ *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      tandemDataPackets = Module[
        {tandemSolutionReplaceRules,rawTandemWellInfo, sortedTandemWellInfo, tandemMeasurementData, tandemWellData,
          tandemCompetingSolutions, tandemCompetitionData, rawTandemMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        tandemSolutionReplaceRules = {
          {1,_, _}->antigen,
          {(2|4),_, _}->blank,
          {3,1,_}->fakeSample1,
          {3,2,_}->fakeSample2,
          {3,3,_}->fakeSample3,
          {3,4,_}->fakeSample4,
          {3,5,_}->fakeSample5,
          {3,6,_}->fakeSample6,
          {3,7,_}->fakeSample7,
          {3,8,_}->blank,
          {5,_, 1}-> fakeSample1,
          {5,_, 2}-> fakeSample2,
          {5,_, 3}-> fakeSample3,
          {5,_, 4}-> fakeSample4,
          {5,_, 5}-> fakeSample5,
          {5,_, 6}-> fakeSample6,
          {5,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawTandemWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> LoadSurface, 4 ->MeasureBaseline, 5-> MeasureAssociation},
            Link[{step,channel, assay}/.tandemSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 5},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedTandemWellInfo = Sort[Cases[rawTandemWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawTandemMeasuredWellPositions = Map[Cases[sortedTandemWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 5-7 *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        tandemMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[baselineData, 4], ConstantArray[bindingData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          Join[ConstantArray[bindingData, 4], ConstantArray[baselineData, 3]],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        tandemWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            tandemMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        tandemCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        tandemCompetitionData = Most[Transpose[tandemMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> Tandem,
              Name -> "Test data for AnalyzeEpitopeBinningPreview - Tandem "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> tandemWellData,
              Replace[WellInformation] -> sortedTandemWellInfo,
              Replace[CompetingSolutions] -> Link/@tandemCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {tandemCompetitionData, rawTandemMeasuredWellPositions, tandemCompetingSolutions, Range[7]}
        ]
      ];




      (* -------------- *)
      (* -- SANDWICH -- *)
      (* -------------- *)

      (* make wellInfo *)
      (* well info is formatted as:  {"Assay", "Assay Step", "Probe Set", "Channel", "Step Type", "Solution"}*)
      (* out assay will have no regen so each measurement has a new probe, and probeSet = Assay. The abbreviated sequence for tandem is: Load (antigen), MeasureBaseline, Load(antibody 1), MeasureBaseline, MeasureAssociation (antibody 2, competing) *)
      (* load steps use the bindingData, baseline steps use the baselineData, and the others use a mix of both. Lets put 1,2,3,4 in the same bin and 5,6,7 in the same bin *)
      sandwichDataPackets = Module[
        {sandwichSolutionReplaceRules,rawsandwichWellInfo, sortedsandwichWellInfo, sandwichMeasurementData, sandwichWellData,
          sandwichCompetingSolutions, sandwichCompetitionData, rawsandwichMeasuredWellPositions},

        (* make replace rules so that we can construct the well information table more easily *)
        sandwichSolutionReplaceRules = {
          {3,_, _}->antigen,
          {(2|4),_, _}->blank,
          {1,1,_}->fakeSample1,
          {1,2,_}->fakeSample2,
          {1,3,_}->fakeSample3,
          {1,4,_}->fakeSample4,
          {1,5,_}->fakeSample5,
          {1,6,_}->fakeSample6,
          {1,7,_}->fakeSample7,
          {1,8,_}->blank,
          {5,_, 1}-> fakeSample1,
          {5,_, 2}-> fakeSample2,
          {5,_, 3}-> fakeSample3,
          {5,_, 4}-> fakeSample4,
          {5,_, 5}-> fakeSample5,
          {5,_, 6}-> fakeSample6,
          {5,_, 7}-> fakeSample7
        };

        (* generate the well info sorted in the same order that is parsed *)
        rawsandwichWellInfo = Table[
          {
            assay,
            step,
            probe/.{probe -> assay},
            channel,
            step/.{1->LoadSurface, 2->MeasureBaseline, 3 -> LoadSurface, 4 ->MeasureBaseline, 5-> MeasureAssociation},
            Link[{step,channel, assay}/.sandwichSolutionReplaceRules]
          },
          {assay, 1, 7},
          {step, 1, 5},
          {channel, 1, 8}
        ];

        (* sort is used in the parser and will do fine here as well *)
        sortedsandwichWellInfo = Sort[Cases[rawsandwichWellInfo, {_Integer, _,_,_,_,_}, Infinity]];

        (*there's a helpful field in the data object called MeasuredWellPositions that helps users find the raw data more easily. It is the elements of WellInformation which correspond to the measurement steps*)
        (* here it is going to be the MeasureAssociationSteps for each channel *)
        rawsandwichMeasuredWellPositions = Map[Cases[sortedsandwichWellInfo, {_,_,_,#,MeasureAssociation, _}]&, Range[7]];

        (* -- make wellData -- *)
        (* per channel, the measurement results if bins are 1-4, 6, {5,7} *)
        (* slow binder on 6 gives ambiguous results *)
        (* transpose it so that the map thread can work properly, as the data is now grouped by step rather than channel *)
        sandwichMeasurementData = Transpose[{
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[baselineData, 4], {bindingData, ambiguousData, bindingData}],
          Join[ConstantArray[bindingData, 4], {baselineData, ambiguousData, baselineData}],
          Join[ConstantArray[bindingData, 4], {bindingData,baselineData, bindingData}],
          Join[ConstantArray[bindingData, 4], {baselineData, ambiguousData, baselineData}],
          ConstantArray[bindingData, 7]
        }];

        (* generate the data in the correct ordering that matches the wellInformation - VERY IMPORTANT - otherwise the analysis function cant determine the correct thing to baseline or normalize with *)
        sandwichWellData = Module[{preMeasurementStep, stepGroupedData},

          (* all the channels do the same steps before measurement *)
          preMeasurementStep = {bindingData, baselineData, bindingData, baselineData};

          (*the mapthread over each assay comes out grouped over the assay, in order of assay step assay/probe so when they are transposed it should be ordered by assay, then step, then channel which is what we wnat *)
          stepGroupedData =Map[
            (*transpose so that the grouping is by step rather, with each step ordered from channel 1 -> 8*)
            Transpose[{
              Append[preMeasurementStep, #[[1]]],
              Append[preMeasurementStep, #[[2]]],
              Append[preMeasurementStep, #[[3]]],
              Append[preMeasurementStep, #[[4]]],
              Append[preMeasurementStep, #[[5]]],
              Append[preMeasurementStep, #[[6]]],
              Append[preMeasurementStep, #[[7]]],
              Append[preMeasurementStep, #[[8]]]
            }]&,
            sandwichMeasurementData
          ];

          (* rather than fooling around with flattening, just pull cases - it will preserve the order *)
          Cases[stepGroupedData, _?QuantityArrayQ, Infinity]
        ];
        (* make CompetingSolutions this will include the self competition step *)
        sandwichCompetingSolutions = {fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7};

        (* make CompetitionData - it is grouped exactly the way it will be grouped in during the bli parse *)
        sandwichCompetitionData = Most[Transpose[sandwichMeasurementData]];

        (* make the data packet *)
        MapThread[
          Function[
            {competitionData, measuredWellPosition, sample, index},
            Association[
              Type -> Object[Data, BioLayerInterferometry],
              BinningType -> Sandwich,
              Name -> "Test data for AnalyzeEpitopeBinningPreview - Sandwich "<>ToString[index]<>$SessionUUID,
              Replace[SamplesIn] -> Link[sample, Data],
              DataType -> EpitopeBinning,
              Replace[WellData] -> sandwichWellData,
              Replace[WellInformation] -> sortedsandwichWellInfo,
              Replace[CompetingSolutions] -> Link/@sandwichCompetingSolutions,
              Replace[CompetitionData] -> competitionData,
              Replace[MeasuredWellPositions]-> measuredWellPosition
            ]
          ],
          {sandwichCompetitionData, rawsandwichMeasuredWellPositions, sandwichCompetingSolutions, Range[7]}
        ]
      ];




      (* ------------------------- *)
      (* -- UPLOAD DATA PACKETS -- *)
      (* ------------------------- *)

      Upload[Flatten[{tandemDataPackets, sandwichDataPackets}]];

      (*Upload[Flatten[{tandemDataPackets, premixDataPackets, sandwichDataPackets}]];*)


      (* ---------------------- *)
      (* -- PROTOCOL OBJECTS -- *)
      (* ---------------------- *)

      (*Make a test protocol object*)
      protocolObjectPackets = {
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Name ->  "Test protocol for AnalyzeEpitopeBinningPreview - Tandem 1" <> $SessionUUID,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 7" <> $SessionUUID]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinningPreview - Sandwich" <> $SessionUUID,
          ExperimentType -> EpitopeBinning,
          BinningType -> Sandwich,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 7" <> $SessionUUID]
            }
          ]
        ]
        (*Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinningPreview - Tandem 2" <> $SessionUUID,
                    ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Replace[SamplesIn] -> Link/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7},
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 7" <> $SessionUUID]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for AnalyzeEpitopeBinningPreview - PreMix" <> $SessionUUID,
                    ExperimentType -> EpitopeBinning,
          BinningType -> PreMix,
          Replace[SamplesIn] -> Link/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7},
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 1" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 2" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 3" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 4" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 5" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 6" <> $SessionUUID],
              Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 7" <> $SessionUUID]
            }
          ]
        ]*)
      };

      Upload[protocolObjectPackets];
    ];

  },


  (* -------------- *)
  (* -- TEARDOWN -- *)
  (* -------------- *)


  SymbolTearDown:> {
    Module[{allObjects, existingObjects},

      (* Make a list of all of the fake objects we uploaded for these tests *)
      allObjects = {
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - Tandem 1" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - Tandem 2" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - Sandwich" <> $SessionUUID],
        Object[Protocol, BioLayerInterferometry, "Test protocol for AnalyzeEpitopeBinningPreview - PreMix" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Tandem 8" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - Sandwich 8" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 1" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 2" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 3" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 4" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 5" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 6" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 7" <> $SessionUUID],
        Object[Data, BioLayerInterferometry, "Test data for AnalyzeEpitopeBinningPreview - PreMix 8" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 1" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 2" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 3" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 4" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 5" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 6" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 7" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 8" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 9" <> $SessionUUID],
        Object[Sample, "Test sample for AnalyzeEpitopeBinningPreview 10" <> $SessionUUID],
        Object[Sample, "Blank for AnalyzeEpitopeBinningPreview" <> $SessionUUID],
        Object[Sample, "Antigen for AnalyzeEpitopeBinningPreview" <> $SessionUUID]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];
