(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCyclicVoltammetry*)


DefineTests[PlotCyclicVoltammetry,
	{
		(* -- BASIC -- *)
		Example[{Basic,"Given a CyclicVoltammetry data object, creates a plot for the RawVoltammogram:"},
			PlotCyclicVoltammetry[
				Object[Data, CyclicVoltammetry, "Example data 1 for PlotCyclicVoltammetry tests"]
			],
			ValidGraphicsP[]
		],

		Example[{Basic,"Given a CyclicVoltammetry protocol object, creates plots for the ElectrodePretreatmentData (if any), CyclicVoltammetryData, PostMeasurementStandardAdditionData (if any):"},
			PlotCyclicVoltammetry[
				Object[Protocol, CyclicVoltammetry, "Example protocol 1 for PlotCyclicVoltammetry tests"]
			],
			_TabView
		],

		Example[{Basic,"Given a CyclicVoltammetry protocol object, does not plot for the ElectrodePretreatmentData or PostMeasurementStandardAdditionData if there are no corresponding data:"},
			PlotCyclicVoltammetry[
				Object[Protocol, CyclicVoltammetry, "Example protocol 2 for PlotCyclicVoltammetry tests"]
			],
			 _TabView
		],

		(* -- OPTIONS -- *)
		Example[{Options, MeasurementType, "Given a CyclicVoltammetry protocol object, use MeasurementType -> All to create plots for the ElectrodePretreatmentData (if any), CyclicVoltammetryData, PostMeasurementStandardAdditionData (if any):"},
			PlotCyclicVoltammetry[
				Object[Protocol, CyclicVoltammetry, "Example protocol 1 for PlotCyclicVoltammetry tests"],
				MeasurementType -> All
			],
			_TabView
		],
		Example[{Options, MeasurementType, "Given a CyclicVoltammetry protocol object, use MeasurementType -> ElectrodePretreatment to only plot the ElectrodePretreatmentData:"},
			PlotCyclicVoltammetry[
				Object[Protocol, CyclicVoltammetry, "Example protocol 1 for PlotCyclicVoltammetry tests"],
				MeasurementType -> ElectrodePretreatment
			],
			_TabView
		],
		Example[{Options, MeasurementType, "Given a CyclicVoltammetry protocol object, use MeasurementType -> CyclicVoltammetryMeasurement to only plot the CyclicVoltammetryData:"},
			PlotCyclicVoltammetry[
				Object[Protocol, CyclicVoltammetry, "Example protocol 1 for PlotCyclicVoltammetry tests"],
				MeasurementType -> CyclicVoltammetryMeasurement
			],
			_TabView
		],
		Example[{Options, MeasurementType, "Given a CyclicVoltammetry protocol object, use MeasurementType -> PostMeasurementStandardAddition to only plot the PostMeasurementStandardAdditionData:"},
			PlotCyclicVoltammetry[
				Object[Protocol, CyclicVoltammetry, "Example protocol 1 for PlotCyclicVoltammetry tests"],
				MeasurementType -> PostMeasurementStandardAddition
			],
			_TabView
		],
		Example[{Options, MeasurementType, "Given a CyclicVoltammetry data object, MeasurementType option is ignored:"},
			plotOptions = PlotCyclicVoltammetry[
				Object[Data, CyclicVoltammetry, "Example data 3 for PlotCyclicVoltammetry tests"],
				MeasurementType -> All,
				Output -> Options
			];
			Lookup[plotOptions, MeasurementType],
			CyclicVoltammetryMeasurement,
			Variables :> {plotOptions}
		],

		(* -- Messages -- *)
		Example[
			{Messages,MeasurementType,"An error will be shown if the specified CyclicVoltammetry protocol object does not have ElectrodePretreatmentData but MeasurementType is set to ElectrodePretreatment:"},
			PlotCyclicVoltammetry[
				Object[Protocol, CyclicVoltammetry, "Example protocol 2 for PlotCyclicVoltammetry tests"],
				MeasurementType -> ElectrodePretreatment
			],
			$Failed,
			Messages:>Error::NoDataForPlotCyclicVoltammetryMeasurementType
		],
		Example[
			{Messages,MeasurementType,"An error will be shown if the specified CyclicVoltammetry protocol object does not have PostMeasurementStandardAdditionData but MeasurementType is set to PostMeasurementStandardAddition:"},
			PlotCyclicVoltammetry[
				Object[Protocol, CyclicVoltammetry, "Example protocol 2 for PlotCyclicVoltammetry tests"],
				MeasurementType -> PostMeasurementStandardAddition
			],
			$Failed,
			Messages:>Error::NoDataForPlotCyclicVoltammetryMeasurementType
		]
	},

	(*  build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for PlotCyclicVoltammetry tests"],
					Object[Sample, "Example Ferrocene solid sample for PlotCyclicVoltammetry tests"],
					Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"],
					Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"],
					Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"],

					Object[Data, CyclicVoltammetry, "Example data 1 for PlotCyclicVoltammetry tests"],
					Object[Data, CyclicVoltammetry, "Example data 2 for PlotCyclicVoltammetry tests"],
					Object[Data, CyclicVoltammetry, "Example data 3 for PlotCyclicVoltammetry tests"],
					Object[Data, CyclicVoltammetry, "Example data 4 for PlotCyclicVoltammetry tests"],
					Object[Data, CyclicVoltammetry, "Example data 5 for PlotCyclicVoltammetry tests"],

					Object[Protocol, CyclicVoltammetry, "Example protocol 1 for PlotCyclicVoltammetry tests"],
					Object[Protocol, CyclicVoltammetry, "Example protocol 2 for PlotCyclicVoltammetry tests"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					solidSample1, solidSample2, liquidSample1, liquidSample2, liquidSample3,
					dataObject1, dataObject2, dataObject3, dataObject4, dataObject5,
					testProtocol1, testProtocol2
				},

				(* Example samples *)
				{
					solidSample1,
					solidSample2,
					liquidSample1,
					liquidSample2,
					liquidSample3
				} = Upload[{
					<|
						Type -> Object[Sample],
						Model -> Link[Model[Sample, "1,1\[Prime]-Dimethylferrocene"], Objects],
						State -> Solid,
						Name -> "Example 1,1\[Prime]-Dimethylferrocene solid sample for PlotCyclicVoltammetry tests"
					|>,
					<|
						Type -> Object[Sample],
						Model -> Link[Model[Sample, "Ferrocene"], Objects],
						State -> Solid,
						Name -> "Example Ferrocene solid sample for PlotCyclicVoltammetry tests"
					|>,
					<|
						Type -> Object[Sample],
						Model -> Link[Model[Sample, StockSolution, "5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"], Objects],
						State -> Liquid,
						Name -> "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"
					|>,
					<|
						Type -> Object[Sample],
						Model -> Link[Model[Sample, StockSolution, "5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"], Objects],
						State -> Liquid,
						Name -> "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"
					|>,
					<|
						Type -> Object[Sample],
						Model -> Link[Model[Sample, StockSolution, "5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile, 20 mL"], Objects],
						State -> Liquid,
						Name -> "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"
					|>
				}];

				(* -- The following data are from the Object[Protocol, CyclicVoltammetry, "id:lYq9jRxdXWnB"] -- *)

				(* -- FAKE Pretreatment DATA OBJECT -- *)
				dataObject1 = Upload[<|
					Type -> Object[Data, CyclicVoltammetry],
					Name -> "Example data 1 for PlotCyclicVoltammetry tests",
					Replace[SamplesIn] -> {Link[solidSample1, Data]},
					LoadingSample -> Link[liquidSample1, Data],
					DataType -> ElectrodePretreatment,
					Replace[RawVoltammograms] -> Download[Object[Data, CyclicVoltammetry, "id:WNa4ZjKkAWW4"], RawVoltammograms],
					Replace[VoltammogramPotentials]-> Download[Object[Data, CyclicVoltammetry, "id:WNa4ZjKkAWW4"], VoltammogramPotentials]
				|>];

				(* -- FAKE CyclicVoltammetry DATA OBJECTS -- *)
				dataObject2 = Upload[<|
					Type -> Object[Data, CyclicVoltammetry],
					Name -> "Example data 2 for PlotCyclicVoltammetry tests",
					Replace[SamplesIn] -> {Link[solidSample1, Data]},
					LoadingSample -> Link[liquidSample1, Data],
					DataType -> CyclicVoltammetryMeasurement,
					Replace[RawVoltammograms] -> Download[Object[Data, CyclicVoltammetry, "id:n0k9mG8Eq44o"], RawVoltammograms],
					Replace[VoltammogramPotentials]-> Download[Object[Data, CyclicVoltammetry, "id:n0k9mG8Eq44o"], VoltammogramPotentials]
				|>];

				dataObject3 = Upload[<|
					Type -> Object[Data, CyclicVoltammetry],
					Name -> "Example data 3 for PlotCyclicVoltammetry tests",
					Replace[SamplesIn] -> {Link[solidSample2, Data]},
					LoadingSample -> Link[liquidSample3, Data],
					DataType -> CyclicVoltammetryMeasurement,
					Replace[RawVoltammograms] -> Download[Object[Data, CyclicVoltammetry, "id:n0k9mG8Eq44o"], RawVoltammograms],
					Replace[VoltammogramPotentials]-> Download[Object[Data, CyclicVoltammetry, "id:n0k9mG8Eq44o"], VoltammogramPotentials]
				|>];

				dataObject4 = Upload[<|
					Type -> Object[Data, CyclicVoltammetry],
					Name -> "Example data 4 for PlotCyclicVoltammetry tests",
					Replace[SamplesIn] -> {Link[solidSample2, Data]},
					LoadingSample -> Link[liquidSample3, Data],
					DataType -> CyclicVoltammetryMeasurement,
					Replace[RawVoltammograms] -> Download[Object[Data, CyclicVoltammetry, "id:n0k9mG8Eq44o"], RawVoltammograms],
					Replace[VoltammogramPotentials]-> Download[Object[Data, CyclicVoltammetry, "id:n0k9mG8Eq44o"], VoltammogramPotentials]
				|>];

				(* -- FAKE PostMeasurementStandardAddition DATA OBJECT -- *)
				dataObject5 = Upload[<|
					Type -> Object[Data, CyclicVoltammetry],
					Name -> "Example data 5 for PlotCyclicVoltammetry tests",
					Replace[SamplesIn] -> {Link[solidSample1, Data]},
					LoadingSample -> Link[liquidSample2, Data],
					DataType -> PostMeasurementStandardAddition,
					Replace[RawVoltammograms] -> Download[Object[Data, CyclicVoltammetry, "id:1ZA60vLVJNNq"], RawVoltammograms],
					Replace[VoltammogramPotentials]-> Download[Object[Data, CyclicVoltammetry, "id:1ZA60vLVJNNq"], VoltammogramPotentials]
				|>];

				(* -- FAKE protocols -- *)
				testProtocol1 = Upload[<|
					Type -> Object[Protocol, CyclicVoltammetry],
					Name -> "Example protocol 1 for PlotCyclicVoltammetry tests",
					Replace[ElectrodePretreatmentData] -> {Link[dataObject1, Protocol], Null},
					Replace[CyclicVoltammetryData] -> {Link[dataObject2], Link[dataObject3]},
    					Replace[Data] -> {Link[dataObject2, Protocol], Link[dataObject3, Protocol]},
					Replace[PostMeasurementStandardAdditionData] -> {Link[dataObject5, Protocol], Null}
				|>];

				testProtocol2 = Upload[<|
					Type -> Object[Protocol, CyclicVoltammetry],
					Name -> "Example protocol 2 for PlotCyclicVoltammetry tests",
					Replace[ElectrodePretreatmentData] -> {Null},
					Replace[CyclicVoltammetryData] -> {Link[dataObject4]},
     					Replace[Data] -> {Link[dataObject4, Protocol]},
					Replace[PostMeasurementStandardAdditionData] -> {Null}
				|>]
			]
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample, "Example 1,1\[Prime]-Dimethylferrocene solid sample for PlotCyclicVoltammetry tests"],
					Object[Sample, "Example Ferrocene solid sample for PlotCyclicVoltammetry tests"],
					Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"],
					Object[Sample, "Example 5 mM 1,1\[Prime]-Dimethylferrocene 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"],
					Object[Sample, "Example 5mM Ferrocene 0.1M [NBu4][PF6] in acetonitrile liquid sample for PlotCyclicVoltammetry tests"],

					Object[Data, CyclicVoltammetry, "Example data 1 for PlotCyclicVoltammetry tests"],
					Object[Data, CyclicVoltammetry, "Example data 2 for PlotCyclicVoltammetry tests"],
					Object[Data, CyclicVoltammetry, "Example data 3 for PlotCyclicVoltammetry tests"],
					Object[Data, CyclicVoltammetry, "Example data 4 for PlotCyclicVoltammetry tests"],
					Object[Data, CyclicVoltammetry, "Example data 5 for PlotCyclicVoltammetry tests"],

					Object[Protocol, CyclicVoltammetry, "Example protocol 1 for PlotCyclicVoltammetry tests"],
					Object[Protocol, CyclicVoltammetry, "Example protocol 2 for PlotCyclicVoltammetry tests"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];
