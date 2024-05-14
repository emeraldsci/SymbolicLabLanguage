(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTADM*)


DefineTests[PlotTADM,
	{

		(* -- BASIC -- *)
		(*SM with data*)
		Example[{Basic, "Plot aspiration and dispense pressures from robotic transfers in SampleManipulation:"},
			PlotTADM[Object[Protocol, SampleManipulation, "Test SampleManipulation 1 for PlotTADM "<>$SessionUUID]],
			_Pane
		],
		(* RSP with data *)
		Example[{Basic, "Plot aspiration and dispense pressure traces from robotic transfers in RoboticSamplePreparation:"},
			PlotTADM[Object[Protocol, RoboticSamplePreparation, "Test RoboticSamplePreparation 1 for PlotTADM "<>$SessionUUID]],
			_Pane
		],
		(*Transfer with data*)
		Example[{Basic, "Plot aspiration and dispense pressure traces from robotic transfers in a Transfer unit operation:"},
			PlotTADM[Object[UnitOperation, Transfer, "Test Transfer UnitOperation 1 for PlotTADM "<>$SessionUUID]],
			_Pane
		],
		(*Aliquot with data*)
		Example[{Basic,  "Plot aspiration and dispense pressure traces from robotic transfers in an Aliquot unit operation:"},
			PlotTADM[Object[UnitOperation, Aliquot, "Test Aliquot UnitOperation 1 for PlotTADM "<>$SessionUUID]],
			_Pane
		],

		(* -- OPTIONS -- *)

		(*Select index - UO*)
		Example[{Options,Index, "Display only the transfer at the selected index:"},
			PlotTADM[
				Object[UnitOperation, Transfer, "Test Transfer UnitOperation 3 for PlotTADM "<>$SessionUUID],
				Index -> 1
			],
			_Pane
		],

		(*Select sources - SM*)
		Example[{Options,Source, "Display only transfers from a selected source sample:"},
			PlotTADM[
				Object[Protocol, SampleManipulation, "Test SampleManipulation 2 for PlotTADM "<>$SessionUUID],
				Source -> Object[Sample, "Test Sample 1 for PlotTADM " <> $SessionUUID]
			],
			_Pane
		],
		(*Select destinations - SM*)
		(*	Example[{Options,Destination, "Display only transfers to a selected destination:"},
			PlotTADM[
				Object[Protocol, SampleManipulation, "Test SampleManipulation 2 for PlotTADM "<>$SessionUUID],
				Destination -> {"A1",Object[Container, Plate, "Test Plate 1 for PlotTADM " <> $SessionUUID]}
			],
			_Pane
		],*)
		(*Select sources - RSP*)
		(*Example[{Options,Source, "Display only transfers from a selected source sample:"},
			PlotTADM[
				Object[UnitOperation, Transfer, "Test Transfer UnitOperation 3 for PlotTADM "<>$SessionUUID],
				Source ->  Object[Sample, "Test Sample 1 for PlotTADM " <> $SessionUUID]
			],
			_Pane
		],*)
		(*Select destinations - RSP*)
		Example[{Options,Destination, "Display only transfers to a selected destination sample:"},
			PlotTADM[
				Object[UnitOperation, Transfer, "Test Transfer UnitOperation 3 for PlotTADM "<>$SessionUUID],
				Destination -> {"A3",Object[Container, Plate, "Test Plate 1 for PlotTADM " <> $SessionUUID]}
			],
			_Pane
		],

		(* -- MESSAGES -- *)

		(*SM with no data*)
		Example[{Messages,"NoData","If there is no pressure trace data in the SampleManipulation ResolvedManipulations return $Failed:"},
			PlotTADM[Object[Protocol, SampleManipulation, "Test SampleManipulation 3 for PlotTADM "<>$SessionUUID]],
			$Failed,
			Messages:>{
				PlotTADM::NoData
			}
		],

		(*RSP with no data*)
		(*Example[{Messages,"NoData", "If there is no pressure trace data in the associated RoboticSamplePreparation unit operations return $Failed:"},
			PlotTADM[Object[Protocol, RoboticSamplePreparation, "Test RoboticSamplePreparation 3 for PlotTADM "<>$SessionUUID]],
			$Failed,
			Messages:>{
				PlotTADM::NoData
			}
		],
		(*Transfer with no data*)
		Example[{Messages,"NoData", "If there is no pressure trace data in the associated RoboticSamplePreparation unit operations return $Failed:"},
			PlotTADM[Object[UnitOperation, Transfer, "Test Transfer UnitOperation 5 for PlotTADM "<>$SessionUUID]],
			$Failed,
			Messages:>{
				PlotTADM::NoData
			}
		],*)
		(* bad options for input type *)
		Example[{Messages,"IndexContainerConflict", "Error if both Index and Source and/or Destination are specified:"},
			PlotTADM[
				Object[Protocol, SampleManipulation, "Test SampleManipulation 1 for PlotTADM "<>$SessionUUID],
				Index -> 1,
				Source -> Object[Sample, "Test Sample 1 for PlotTADM " <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				PlotTADM::IndexContainerConflict
			}
		],
		Example[{Messages,"DestinationsSourcesConflict", "Error if both Destination and Source are specified:"},
			PlotTADM[
				Object[Protocol, SampleManipulation, "Test SampleManipulation 1 for PlotTADM "<>$SessionUUID],
				Source -> Object[Sample, "Test Sample 1 for PlotTADM " <> $SessionUUID],
				Destination -> {"A1",Object[Container, Vessel, "Test Vessel 1 for PlotTADM " <> $SessionUUID]}
			],
			$Failed,
			Messages:>{
				PlotTADM::DestinationsSourcesConflict
			}
		],
		Example[{Messages,"FieldLengthMismatch", "If the primitive containing pressure data is not correctly formatted, return $Failed:"},
			PlotTADM[Object[UnitOperation, Transfer, "Test Transfer UnitOperation 6 for PlotTADM "<>$SessionUUID]],
			$Failed,
			Messages:>{
				PlotTADM::FieldLengthMismatch
			}
		],
		Example[{Messages,"InvalidSourceOptionForSampleManipulation", "Deprecated source format results in an error:"},
			PlotTADM[
				Object[Protocol, SampleManipulation, "Test SampleManipulation 1 for PlotTADM "<>$SessionUUID],
				Source -> {"A1",Object[Container, Vessel, "Test Vessel 2 for PlotTADM " <> $SessionUUID]}
			],
			$Failed,
			Messages:>{
				PlotTADM::InvalidSourceOptionForSampleManipulation
			}
		]
	},

	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs = Quiet[
				Cases[
					Flatten[{
						Table[Object[Sample, "Test Sample " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}],
						Table[Object[Container, Vessel, "Test Vessel " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}],
						Table[Object[Container, Plate, "Test Plate " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}],
						Table[Object[Protocol, SampleManipulation, "Test SampleManipulation " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}],
						Table[Object[Protocol, Transfer, "Test Transfer Protocol " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 3}],
						Table[Object[UnitOperation, Transfer, "Test Transfer UnitOperation " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 6}],
						Table[Object[UnitOperation, Aliquot, "Test Aliquot UnitOperation " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 3}],
						Table[Object[Protocol, RoboticSamplePreparation, "Test RoboticSamplePreparation " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}]
					}],
					ObjectP[]
				]
			];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Module[{
			aspirationData,aspirationData2, aspirationData3,dispenseData, dispenseData2, dispenseData3,
			aspirationDataQA, dispenseDataQA,badDispenseQA, badAspirateQA, aspirationDataQA2, aspirationDataQA3, dispenseDataQA2, dispenseDataQA3,
			sample1, sample2, sample3, sample4,
			vessel1, vessel2, vessel3, vessel4,
			plate1, plate2, plate3, plate4,
			sm1, sm2, sm3,sm4,
			transfer1, transfer2, transfer3,
			transferUO1, transferUO2, transferUO3, transferUO4, transferUO5,transferUO6,
			aliquotUO1, aliquotUO2, aliquotUO3,
			rsp1, rsp2, rsp3,rsp4,
			genericUploadPackets,
			transferUnitOpPackets, aliquotUnitOpPackets,
			transferPrimitive1, transferPrimitive2, transferPrimitive3,transferPrimitive4,smPackets
		},

			(* -- set up TADM data -- *)

			(* use piecewise functions to mock up some TADM data *)
			aspirationTestData[t_]:=Piecewise[
				{
					{0, t < 1},
					{-8t + 8, 1 <= t < 10},
					{-0.5t - 68, 10 <= t < 80},
					{-108 + 20 (t - 80), 80 <= t < 83},
					{-48, 83 <= t}
				}
			];

			(* generate some mock curves to display in unit tests *)
			aspirationData = Table[{t,N[(aspirationTestData[t]+RandomReal[{-2,2}])]}, {t,0,100, 0.5}];
			dispenseData = Table[{t,-N[(aspirationTestData[t]+RandomReal[{-2,2}])]}, {t,0,100, 0.5}];
			aspirationData2 = Table[{t,0.9*N[(aspirationTestData[t]+RandomReal[{-2,2}])]}, {t,0,100, 0.5}];
			dispenseData2 = Table[{t,-0.9*N[(aspirationTestData[t]+RandomReal[{-2,2}])]}, {t,0,100, 0.5}];
			aspirationData3 = Table[{t,0.8*N[(aspirationTestData[t]+RandomReal[{-1.5,1.5}])]}, {t,0,100, 0.5}];
			dispenseData3 = Table[{t,-0.8*N[(aspirationTestData[t]+RandomReal[{-1.5,1.5}])]}, {t,0,100, 0.5}];

			(* make Quantity arrays for good and bad data *)
			{aspirationDataQA, aspirationDataQA2, aspirationDataQA3} = Map[
				QuantityArray[#, {Millisecond, Pascal}]&,
				{aspirationData, aspirationData2, aspirationData3}
				];
			{dispenseDataQA, dispenseDataQA2, dispenseDataQA3} = Map[
				QuantityArray[#, {Millisecond, Pascal}]&,
				{dispenseData, dispenseData2, dispenseData3}
			];
			(*bad data!*)
			badDispenseQA = QuantityArray[Table[{t, RandomReal[{-2,2}]}, {t, 0, 100, 0.5}], {Millisecond, Pascal}];
			badAspirateQA = QuantityArray[Table[{t, RandomReal[{-2,2}]}, {t, 0, 100, 0.5}], {Millisecond, Pascal}];


			(* -- upload samples and containers -- *)

			(* reserve IDs *)
			{
				sample1, sample2, sample3, sample4,
				vessel1, vessel2, vessel3, vessel4,
				plate1, plate2, plate3, plate4,
				sm1, sm2, sm3, sm4,
				transfer1, transfer2, transfer3,
				transferUO1, transferUO2, transferUO3, transferUO4, transferUO5, transferUO6,
				aliquotUO1, aliquotUO2, aliquotUO3,
				rsp1, rsp2, rsp3, rsp4
			} = CreateID[
				Join[
					ConstantArray[Object[Sample], 4],
					ConstantArray[Object[Container, Vessel], 4],
					ConstantArray[Object[Container, Plate], 4],
					ConstantArray[Object[Protocol, SampleManipulation], 4],
					ConstantArray[Object[Protocol, Transfer], 3],
					ConstantArray[Object[UnitOperation, Transfer], 6],
					ConstantArray[Object[UnitOperation, Aliquot], 3],
					ConstantArray[Object[Protocol, RoboticSamplePreparation], 4]
				]
			];

			(*TODO: things to test:*)
			(*all options in cases where they are or are not applicable*)
			(* protocols missing all data *)
			(* protocols missing partial data *)
			(* unit operations with mismatched field lengths *)
			(* unit operations that were actually done manually (LiquidHandler -> Null) *)
			(* multiprobe head manipulations that do not have data *)

			(* Sm with no transfer, RSP with multiple Transfers, RSP with a transfer and an aliquot, RSP with only one transfer *)

			(* hlper to make generic name and DeveloperObject updates *)
			plotTADMTestsGenericUpdate[objects_, name_String]:=Module[{names, packets},
				names = Table[name<>" "<> ToString[x] <>" for PlotTADM "<>$SessionUUID, {x, 1, Length[objects]}];
				packets = MapThread[<|Object -> #1, Name -> #2, DeveloperObject -> True|>&, {objects, names}]
			];

			(* -- Generic Uploads -- *)
			genericUploadPackets = Map[
				plotTADMTestsGenericUpdate[#[[1]], #[[2]]]&,
				{
					{{sample1, sample2, sample3, sample4}, "Test Sample"},
					{{vessel1, vessel2, vessel3, vessel4}, "Test Vessel"},
					{{plate1, plate2, plate3, plate4}, "Test Plate"},
					{{sm1, sm2, sm3, sm4}, "Test SampleManipulation"},
					{{transfer1, transfer2, transfer3}, "Test Transfer Protocol"},
					{{transferUO1, transferUO2, transferUO3, transferUO4, transferUO5, transferUO6}, "Test Transfer UnitOperation"},
					{{aliquotUO1, aliquotUO2, aliquotUO3}, "Test Aliquot UnitOperation"},
					{{rsp1, rsp2, rsp3, rsp4}, "Test RoboticSamplePreparation"}
				}
			];
			Upload[Flatten[genericUploadPackets]];

			(* --------------------------- *)
			(* -- UnitOperation Support -- *)
			(* --------------------------- *)

			(* -- Construct primitives with and without data -- *)
			transferUnitOpPackets = {
				Association[
					Object -> transferUO1,
					Replace[SourceLink] -> Link/@{sample1, sample2},
					Replace[DestinationLink] -> Link/@{plate1, plate1},
					Replace[SourceWell] -> {"A1", "A2"},
					Replace[DestinationWell] -> {"A3", "A3"},
					Replace[AmountVariableUnit] -> {10 Microliter, 10 Microliter},
					Replace[AspirationPressure] -> {aspirationDataQA, aspirationDataQA2},
					Replace[DispensePressure] -> {dispenseDataQA, dispenseDataQA2}
				],
				Association[
					Object -> transferUO2,
					Replace[SourceLink] -> Link/@{sample1, sample2, sample3},
					Replace[DestinationLink] -> Link/@{plate2, plate2, plate2},
					Replace[SourceWell] -> {"A1", "A2", "A3"},
					Replace[DestinationWell] -> {"A2", "A3", "A4"},
					Replace[AmountVariableUnit] -> {10 Microliter, 10 Microliter, 10 Microliter},
					Replace[AspirationPressure] -> {aspirationDataQA, aspirationDataQA2, aspirationDataQA3},
					Replace[DispensePressure] -> {dispenseDataQA, dispenseDataQA2, dispenseDataQA3}
				],
				(*bad transfer*)
				Association[
					Object -> transferUO3,
					Replace[SourceLink] -> Link/@{sample1, sample2},
					Replace[DestinationLink] -> Link/@{plate1, plate1},
					Replace[SourceWell] -> {"A1", "A2"},
					Replace[DestinationWell] -> {"A3", "A3"},
					Replace[AmountVariableUnit] -> {10 Microliter, 10 Microliter},
					Replace[AspirationPressure] -> {aspirationDataQA, badAspirateQA},
					Replace[DispensePressure] -> {dispenseDataQA, badDispenseQA}
				],
				(*aliquot*)
				Association[
					Object -> transferUO4,
					Replace[SourceLink] -> Link/@{sample3, sample3, sample3, sample3},
					Replace[DestinationLink] -> Link/@{plate3, plate3,plate3,plate3},
					Replace[SourceWell] -> {"A1", "A1", "A1", "A1"},
					Replace[DestinationWell] -> {"A1", "A2","A3","A4"},
					Replace[AmountVariableUnit] -> {20 Microliter, 20 Microliter, 20 Microliter, 20 Microliter},
					Replace[AspirationPressure] -> {aspirationDataQA, aspirationDataQA2,aspirationDataQA3, badAspirateQA},
					Replace[DispensePressure] -> {dispenseDataQA, dispenseDataQA2,dispenseDataQA3, badDispenseQA}
				],
				Association[
					Object -> transferUO6,
					Replace[SourceLink] -> Link/@{sample3},
					Replace[DestinationLink] -> Link/@{plate3, plate3},
					Replace[SourceWell] -> {"A1"},
					Replace[DestinationWell] -> {"A1", "A2"},
					Replace[AmountVariableUnit] -> {20 Microliter, 20 Microliter},
					Replace[AspirationPressure] -> {aspirationDataQA, aspirationDataQA2},
					Replace[DispensePressure] -> {dispenseDataQA}
				]
			};

			(* link UnitOperations to the parent protocol (RSP or Aliquot) *)
			(*aliquot needs to connect to Transfer UOs via RoboticUnitOperations field, and Aliquot and Transfer both need to connect via Output Unit Operations*)
			aliquotUnitOpPackets = {
				(* aliquot to tranfer *)
				Association[
					Object -> aliquotUO1,
					Replace[RoboticUnitOperations]-> Link[transferUO4]
				],
				(* aliquot from RSP *)
				Association[
					Object -> rsp1,
					Replace[OutputUnitOperations]-> Link[aliquotUO1, Protocol]
				],
				Association[
					Object -> rsp2,
					Replace[OutputUnitOperations]-> Link[transferUO1, Protocol]
				],
				Association[
					Object -> rsp3,
					Replace[OutputUnitOperations]-> Link[transferUO5, Protocol]
				],
				Association[
					Object -> rsp4,
					Replace[OutputUnitOperations]-> Link[transferUO6, Protocol]
				]
			};

			(* ----------------------- *)
			(* -- SM Legacy Support -- *)
			(* ----------------------- *)

			(* make primitives for SM *)
			{transferPrimitive1, transferPrimitive2, transferPrimitive3, transferPrimitive4} = {
				Transfer[Source -> {{sample1}}, Destination -> {{plate4, "A1"}}, AspirationPressure -> {{aspirationDataQA}}, DispensePressure -> {{dispenseDataQA}}, Volume -> {10 Microliter}],
				Transfer[Source -> {{sample1}, {sample2}}, Destination -> {{plate1, "A1"}, {plate1, "A2"}}, AspirationPressure -> {{aspirationDataQA}, {aspirationDataQA2}}, DispensePressure -> {{dispenseDataQA}, {dispenseDataQA3}},Volume -> {10 Microliter, 20 Microliter}],
				Transfer[Source -> {{sample1}, {sample2}}, Destination -> {{plate1, "A1"}, {plate1, "A2"}}, Volume -> {10 Microliter, 10 Milliliter}],
				Transfer[Source -> {{sample1}}, Destination -> {{plate1, "A1"}, {plate1, "A2"}}, Volume -> {10 Milliliter}]
			};

			(* update SM with the transfers *)
			smPackets = {
				Association[
					Object -> sm1,
					Replace[ResolvedManipulations]-> {transferPrimitive1}
				],
				Association[
					Object -> sm2,
					Replace[ResolvedManipulations]-> {transferPrimitive2}
				],
				Association[
					Object -> sm3,
					Replace[ResolvedManipulations]-> {transferPrimitive3}
				],
				Association[
					Object -> sm4,
					Replace[ResolvedManipulations]-> {transferPrimitive4}
				]
			};


			(* big upload to finish test setup *)
			Upload[Flatten[{transferUnitOpPackets, aliquotUnitOpPackets, smPackets}]];
		]
	},

	(*generic tear down, we didnt do anything crazy here*)
	SymbolTearDown:> {
		Module[{allObjects, existingObjects},

			(* Make a list of all of the fake objects we uploaded for these tests *)
			allObjects = Quiet[
				Cases[
					Flatten[{
						Table[Object[Sample, "Test Sample " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}],
						Table[Object[Container, Vessel, "Test Vessel " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}],
						Table[Object[Container, Plate, "Test Plate " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}],
						Table[Object[Protocol, SampleManipulation, "Test SampleManipulation " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}],
						Table[Object[Protocol, Transfer, "Test Transfer Protocol " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 3}],
						Table[Object[UnitOperation, Transfer, "Test Transfer UnitOperation " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 6}],
						Table[Object[UnitOperation, Aliquot, "Test Aliquot UnitOperation " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 3}],
						Table[Object[Protocol, RoboticSamplePreparation, "Test RoboticSamplePreparation " <> ToString[x] <> " for PlotTADM " <> $SessionUUID], {x, 1, 4}]
					}],
					ObjectP[]
				]
			];

			(*Check whether the created objects and models exist in the database*)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]

		]
	}
];
