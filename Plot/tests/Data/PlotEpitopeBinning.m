(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotEpitopeBinning*)

(* ------------------------- *)
(* -- PlotEpitopeBinning --  *)
(* ------------------------- *)

DefineTests[PlotEpitopeBinning,
  {
    Example[{Basic,"Returns a graph showing the binned antibodies:"},
      analysis = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Tandem 1"]
      ];
      PlotEpitopeBinning[analysis],
      _Graph,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Example[{Basic,"Returns a graph showing the binned antibodies:"},
      analysis = AnalyzeEpitopeBinning[
        Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Sandwich"],
        Threshold -> 1 Nanometer
      ];
      PlotEpitopeBinning[analysis],
      _Graph,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Example[{Messages,"EpitopeBinningAnalysisMissing","Warns if analysis object is missing:"},
      PlotEpitopeBinning[Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Tandem 1"]],
      {$Failed..},
      Messages:>{
        Warning::EpitopeBinningAnalysisMissing,
        General::stop
      }
    ],
    Test["Given output option as Result, returns a plot:",
      analysis=AnalyzeEpitopeBinning[Object[Protocol,BioLayerInterferometry,"Test protocol for PlotEpitopeBinning - Tandem 1"]];
      PlotEpitopeBinning[analysis,Output->Result],
      _Graph,
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Test["Given output option as Preview, returns a plot:",
      analysis=AnalyzeEpitopeBinning[Object[Protocol,BioLayerInterferometry,"Test protocol for PlotEpitopeBinning - Tandem 1"]];
      PlotEpitopeBinning[analysis,Output->Preview],
      ValidGraphicsP[],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Test["Given output option as Options, returns a list of resolved options:",
      analysis=AnalyzeEpitopeBinning[Object[Protocol,BioLayerInterferometry,"Test protocol for PlotEpitopeBinning - Tandem 1"]];
      PlotEpitopeBinning[analysis,Output->Options],
      KeyValuePattern[{}],
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ],
    Test["Given output option as Tests, returns {}:",
      analysis=AnalyzeEpitopeBinning[Object[Protocol,BioLayerInterferometry,"Test protocol for PlotEpitopeBinning - Tandem 1"]];
      PlotEpitopeBinning[analysis,Output->Tests],
      {},
      SetUp :> (
        $CreatedObjects = {}
      ),
      TearDown :> (
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
      ),
      TimeConstraint -> 1000
    ]
  },


  (* -- SETUP -- *)
  SymbolSetUp :> {
    Module[{objs, existingObjs},
      objs = Quiet[Cases[
        Flatten[{
          Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Tandem 1"],
          Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Tandem 2"],
          Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Sandwich"],
          Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - PreMix"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 1"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 2"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 3"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 4"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 5"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 6"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 7"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 8"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 1"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 2"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 3"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 4"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 5"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 6"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 7"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 8"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 1"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 2"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 3"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 4"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 5"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 6"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 7"],
          Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 8"],
          Object[Sample, "Test sample for PlotEpitopeBinning 1"],
          Object[Sample, "Test sample for PlotEpitopeBinning 2"],
          Object[Sample, "Test sample for PlotEpitopeBinning 3"],
          Object[Sample, "Test sample for PlotEpitopeBinning 4"],
          Object[Sample, "Test sample for PlotEpitopeBinning 5"],
          Object[Sample, "Test sample for PlotEpitopeBinning 6"],
          Object[Sample, "Test sample for PlotEpitopeBinning 7"],
          Object[Sample, "Test sample for PlotEpitopeBinning 8"],
          Object[Sample, "Test sample for PlotEpitopeBinning 9"],
          Object[Sample, "Test sample for PlotEpitopeBinning 10"],
          Object[Sample, "Blank for PlotEpitopeBinning"],
          Object[Sample, "Antigen for PlotEpitopeBinning"]
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
      (*add that factor of 10 to allow the shape to be reasonable and reduce the amount of data to 60 points*)
      bindingResponse[t_, const_]:= 2*(1 - Exp[-const*10*t]);
      bindingConst = 0.005;
      nonBindingConst = 0;
      ambiguousConst = 0.0005;
      timeRange = 60;

      (* -- generate fake data and baselines -- *)
      bindingData = QuantityArray[Table[{time, bindingResponse[time, bindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      nonBindingData = QuantityArray[Table[{time, bindingResponse[time, nonBindingConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      ambiguousData = QuantityArray[Table[{time, bindingResponse[time, ambiguousConst]}, {time, 1, timeRange}],{Second, Nanometer}];
      baselineData = QuantityArray[Transpose[{Range[60], ConstantArray[0, 60]}], {Second, Nanometer}];


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
          Name -> "Test sample for PlotEpitopeBinning "<>ToString[index]
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
            Name -> "Blank for PlotEpitopeBinning"
          |>,
          <|
            Type -> Object[Sample],
            Model -> Link[Model[Sample, "id:8qZ1VWNmdLBD"], Objects],
            Name -> "Antigen for PlotEpitopeBinning"
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

        (* generate teh well info sorted in the same order that is parsed *)
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
              Name -> "Test data for PlotEpitopeBinning - Tandem "<>ToString[index],
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

        (* generate teh well info sorted in the same order that is parsed *)
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
              Name -> "Test data for PlotEpitopeBinning - Sandwich "<>ToString[index],
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
          Name ->  "Test protocol for PlotEpitopeBinning - Tandem 1",
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 1"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 2"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 3"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 4"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 5"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 6"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 7"]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for PlotEpitopeBinning - Sandwich",
          ExperimentType -> EpitopeBinning,
          BinningType -> Sandwich,
          Replace[SamplesIn] -> (Link[#,Protocols]&/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7}),
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 1"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 2"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 3"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 4"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 5"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 6"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 7"]
            }
          ]
        ]
        (*Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for PlotEpitopeBinning - Tandem 2",
                    ExperimentType -> EpitopeBinning,
          BinningType -> Tandem,
          Replace[SamplesIn] -> Link/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7},
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 1"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 2"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 3"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 4"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 5"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 6"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 7"]
            }
          ]
        ],
        Association[
          Type -> Object[Protocol, BioLayerInterferometry],
          Name ->  "Test protocol for PlotEpitopeBinning - PreMix",
                    ExperimentType -> EpitopeBinning,
          BinningType -> PreMix,
          Replace[SamplesIn] -> Link/@{fakeSample1, fakeSample2, fakeSample3, fakeSample4, fakeSample5, fakeSample6, fakeSample7},
          (*add the data*)
          Replace[Data] -> Map[
            Link[#,Protocol]&,
            {
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 1"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 2"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 3"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 4"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 5"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 6"],
              Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 7"]
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
        Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Tandem 1"],
        Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Tandem 2"],
        Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - Sandwich"],
        Object[Protocol, BioLayerInterferometry, "Test protocol for PlotEpitopeBinning - PreMix"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 1"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 2"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 3"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 4"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 5"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 6"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 7"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Tandem 8"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 1"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 2"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 3"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 4"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 5"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 6"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 7"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - Sandwich 8"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 1"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 2"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 3"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 4"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 5"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 6"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 7"],
        Object[Data, BioLayerInterferometry, "Test data for PlotEpitopeBinning - PreMix 8"],
        Object[Sample, "Test sample for PlotEpitopeBinning 1"],
        Object[Sample, "Test sample for PlotEpitopeBinning 2"],
        Object[Sample, "Test sample for PlotEpitopeBinning 3"],
        Object[Sample, "Test sample for PlotEpitopeBinning 4"],
        Object[Sample, "Test sample for PlotEpitopeBinning 5"],
        Object[Sample, "Test sample for PlotEpitopeBinning 6"],
        Object[Sample, "Test sample for PlotEpitopeBinning 7"],
        Object[Sample, "Test sample for PlotEpitopeBinning 8"],
        Object[Sample, "Test sample for PlotEpitopeBinning 9"],
        Object[Sample, "Test sample for PlotEpitopeBinning 10"],
        Object[Sample, "Blank for PlotEpitopeBinning"],
        Object[Sample, "Antigen for PlotEpitopeBinning"]
      };

      (*Check whether the created objects and models exist in the database*)
      existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

      (*Erase all the created objects and models*)
      Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

    ]
  }
];
