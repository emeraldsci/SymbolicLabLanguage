(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentMeasureMeltingPoint*)


DefineTests[ExperimentMeasureMeltingPoint,
	{
		(* --- Basic --- *)
		Example[
			{Basic, "Creates a protocol to measure the melting point of a solid sample:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, MeasureMeltingPoint]]
		],

		Example[
			{Basic, "Accepts an input container containing a solid sample:"},
			ExperimentMeasureMeltingPoint[
				Object[Container, Vessel, "MeasureMeltingPointing test container 1 " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, MeasureMeltingPoint]]
		],

		Example[
			{Basic, "Creates a protocol to measure the melting temperature of a list of inputs (samples or containers) containing solid samples:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 3 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 4 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 5 " <> $SessionUUID],
					Object[Container, Vessel, "MeasureMeltingPointing test container 6 " <> $SessionUUID],
					Object[Container, Vessel, "MeasureMeltingPointing test container 7 " <> $SessionUUID],
					Object[Container, Vessel, "MeasureMeltingPointing test container 8 " <> $SessionUUID],
					Object[Container, Vessel, "MeasureMeltingPointing test container 9 " <> $SessionUUID],
					Object[Container, Vessel, "MeasureMeltingPointing test container 10 " <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, MeasureMeltingPoint]]
		],

		Example[
			{Basic, "Creates a protocol to measure the melting point of a solid sample without grinding and desiccation steps:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				Desiccate -> False
			],
			ObjectP[Object[Protocol, MeasureMeltingPoint]]
		],

		Example[
			{Basic, "Creates a protocol to measure the melting point of a solid sample with determining the order of grinding and desiccation:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				OrderOfOperations -> {Grind, Desiccate}
			],
			ObjectP[Object[Protocol, MeasureMeltingPoint]]
		],

		(* Output Options *)
		Example[
			{Basic, "Generates a list of tests if Output is set to Tests for ExperimentMeasureMeltingPoint:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Tests
			],
			{_EmeraldTest..}
		],

		Example[
			{Basic, "Generates a simulation if output is set to Simulation for ExperimentMeasureMeltingPoint:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Simulation
			],
			SimulationP
		],

		(* --- MeasureMeltingPoint Options --- *)
		Example[
			{Options, MeasurementMethod, "MeasurementMethod is properly resolved with one input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID], Output -> Options];
			Lookup[options, MeasurementMethod],
			Pharmacopeia,
			Variables :> {options}
		],

		Example[
			{Options, MeasurementMethod, "MeasurementMethod is specified with multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 3 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID]
				},
				MeasurementMethod -> Thermodynamic,
				Output -> Options
			];
			Lookup[options, MeasurementMethod],
			Thermodynamic,
			Variables :> {options}
		],

		Example[
			{Options, OrderOfOperations, "OrderOfOperations is properly resolved if both Desiccate and Grind are set to True:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID], Output -> Options];
			Lookup[options, OrderOfOperations],
			{Desiccate, Grind},
			Variables :> {options}
		],

		Example[
			{Options, OrderOfOperations, "OrderOfOperations is properly resolved if both Desiccate and Grind are set to True for multiple samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 3 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID]
				},
				Output -> Options];
			Lookup[options, OrderOfOperations],
			{Desiccate, Grind},
			Variables :> {options}
		],

		Example[
			{Options, OrderOfOperations, "OrderOfOperations is set to a user-specified value:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				OrderOfOperations -> {Grind, Desiccate},
				Output -> Options];
			Lookup[options, OrderOfOperations],
			{Grind, Desiccate},
			Variables :> {options}
		],

		Example[
			{Options, OrderOfOperations, "OrderOfOperations is set to a user-specified value for multiple samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 3 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID]
				},
				OrderOfOperations -> {{Grind, Desiccate}, {Grind, Desiccate}, {Desiccate, Grind}, {Grind, Desiccate}},
				Output -> Options];
			Lookup[options, OrderOfOperations],
			{{Grind, Desiccate}, {Grind, Desiccate}, {Desiccate, Grind}, {Grind, Desiccate}},
			Variables :> {options}
		],

		Example[
			{Options, OrderOfOperations, "OrderOfOperations is automatically set to Null if both Desiccate and Grind are not set to True:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Desiccate -> False,
				Grind -> True,
				Output -> Options
			];
			Lookup[options, OrderOfOperations],
			Null,
			Variables :> {options}
		],

		Example[
			{Options, OrderOfOperations, "OrderOfOperations is properly resolved if Desiccate and Grind are set to True for some of the input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 3 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID]
				},
				Grind -> {True, False, False, True},
				Desiccate -> {True, True, False, False},
				Output -> Options];
			Lookup[options, OrderOfOperations],
			{{Desiccate, Grind}, Null, Null, Null},
			Variables :> {options}
		],

		Example[
			{Options, ExpectedMeltingPoint, "ExpectedMeltingPoint is set to a user-specified value:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				ExpectedMeltingPoint -> 123Celsius,
				Output -> Options
			];
			Lookup[options, ExpectedMeltingPoint],
			123Celsius | 123.Celsius,
			Variables :> {options}
		],

		Example[
			{Options, ExpectedMeltingPoint, "ExpectedMeltingPoint is automatically looked up from composition identity model if informed:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ExpectedMeltingPoint],
			99Celsius | 99.Celsius,
			Variables :> {options}
		],

		Example[
			{Options, ExpectedMeltingPoint, "ExpectedMeltingPoint is automatically looked up from sample object if informed:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ExpectedMeltingPoint],
			331Celsius | 331.Celsius,
			Variables :> {options}
		],

		Example[
			{Options, ExpectedMeltingPoint, "ExpectedMeltingPoint is automatically set to Unknown MeltingPoint is not informed in sample object or the dominant identity model of the composition:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ExpectedMeltingPoint],
			Unknown,
			Variables :> {options}
		],

		Example[
			{Options, ExpectedMeltingPoint, "ExpectedMeltingPoint is automatically set to the MeltingPoint of the most dominant identity model of the composition:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 19 - Multi-Component " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ExpectedMeltingPoint],
			152Celsius | 152.Celsius,
			Variables :> {options}
		],

		Example[
			{Options, ExpectedMeltingPoint, "ExpectedMeltingPoint is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 19 - Multi-Component " <> $SessionUUID]
				},
				ExpectedMeltingPoint -> {123Celsius, Automatic, Automatic, Automatic, Automatic},
				Output -> Options
			];
			Lookup[options, ExpectedMeltingPoint],
			{123Celsius | 123.Celsius, 99Celsius | 99.Celsius, 331Celsius | 331.Celsius, Unknown, 152Celsius | 152.Celsius},
			Variables :> {options}
		],

		Example[
			{Options, NumberOfReplicates, "NumberOfReplicates is properly resolved for one input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			3,
			Variables :> {options}
		],

		Example[
			{Options, NumberOfReplicates, "NumberOfReplicates is properly resolved for one input samples that is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, NumberOfReplicates, "NumberOfReplicates is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, NumberOfReplicates],
			{3, 3, Null, Null},
			Variables :> {options}
		],

		Example[
			{Options, Amount, "Amount is properly resolved for one input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Amount],
			MassP,
			Variables :> {options}
		],

		Example[
			{Options, Amount, "Amount is properly resolved for one input sample which is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Amount],
			ListableP[NullP],
			Variables :> {options}
		],

		Example[
			{Options, Amount, "Amount is properly set to a user-specified value:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Amount -> 5Gram,
				Output -> Options
			];
			Lookup[options, Amount],
			MassP,
			Variables :> {options}
		],

		Example[
			{Options, Amount, "Amount is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, Amount],
			{MassP, MassP, Null, Null},
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleLabel, "PreparedSampleLabel is properly resolved for an input sample:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID]
				},
				RecoupSample -> True,
				Output -> Options
			];
			Lookup[options, PreparedSampleLabel],
			_String,
			Variables :> {options}
		].

			Example[
				{Options, PreparedSampleLabel, "PreparedSampleLabel is properly resolved for multiple input samples:"},
				options = ExperimentMeasureMeltingPoint[
					{
						Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
						Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
						Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
						Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
					},
					RecoupSample -> {True, False, Automatic, Null},
					Output -> Options
				];
				Lookup[options, PreparedSampleLabel],
				ListableP[_String | NullP],
				Variables :> {options}
			],

		Example[
			{Options, PreparedSampleContainerLabel, "PreparedSampleContainerLabel is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID]
				},
				RecoupSample -> True,
				Output -> Options
			];
			Lookup[options, PreparedSampleContainerLabel],
			_String,
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleContainerLabel, "PreparedSampleContainerLabel is properly set to a user-specified value:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID]
				},
				RecoupSample -> True,
				PreparedSampleContainerLabel -> "container of melting point prepared-sample",
				Output -> Options
			];
			Lookup[options, PreparedSampleContainerLabel],
			_String,
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleContainerLabel, "PreparedSampleContainerLabel is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				RecoupSample -> {True, False, Automatic, Null},
				Output -> Options
			];
			Lookup[options, PreparedSampleContainerLabel],
			ListableP[_String | NullP],
			Variables :> {options}
		],

		Example[
			{Options, SealCapillary, "SealCapillary is properly resolved for a single input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, SealCapillary],
			ListableP[BooleanP],
			Variables :> {options}
		],

		Example[
			{Options, SealCapillary, "SealCapillary is properly set to a user-specified value:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID]
				},
				Output -> Options,
				SealCapillary -> True
			];
			Lookup[options, SealCapillary],
			True,
			Variables :> {options}
		],

		Example[
			{Options, SealCapillary, "SealCapillary is resolved to True if boiling point is less than 20 Celsius above melting point:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID]
				},
				Output -> Options,
				SealCapillary -> True
			];
			Lookup[options, SealCapillary],
			True,
			Variables :> {options}
		],

		Example[
			{Options, SealCapillary, "SealCapillary is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, SealCapillary],
			ListableP[BooleanP],
			Variables :> {options}
		],

		Example[
			{Options, SealCapillary, "SealCapillary is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, SealCapillary],
			ListableP[BooleanP],
			Variables :> {options}
		],

		Example[
			{Options, Instrument, "Instrument is properly set to the default melting point apparatus for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Instrument],
			ListableP[
				ObjectP[Model[Instrument, MeltingPointApparatus]] |
					ObjectP[Object[Instrument, MeltingPointApparatus]]
			],
			Variables :> {options}
		],

		Example[
			{Options, Instrument, "Instrument is properly set to the default melting point apparatus for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, Instrument],
			ListableP[
				ObjectP[Model[Instrument, MeltingPointApparatus]] |
					ObjectP[Object[Instrument, MeltingPointApparatus]]
			],
			Variables :> {options}
		],

		Example[
			{Options, StartTemperature, "StartTemperature is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, StartTemperature],
			ListableP[TemperatureP],
			Variables :> {options}
		],

		Example[
			{Options, StartTemperature, "StartTemperature is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				StartTemperature -> 100Celsius,
				Output -> Options
			];
			Lookup[options, StartTemperature],
			100Celsius | 100.Celsius,
			Variables :> {options}
		],

		Example[
			{Options, StartTemperature, "StartTemperature is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, StartTemperature],
			ListableP[TemperatureP],
			Variables :> {options}
		],

		Example[
			{Options, EquilibrationTime, "EquilibrationTime is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, EquilibrationTime],
			TimeP,
			Variables :> {options}
		],

		Example[
			{Options, EquilibrationTime, "EquilibrationTime is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				EquilibrationTime -> 1Minute,
				Output -> Options
			];
			Convert[Lookup[options, EquilibrationTime], Minute],
			1Minute | 1.Minute,
			Variables :> {options}
		],

		Example[
			{Options, EquilibrationTime, "EquilibrationTime is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, EquilibrationTime],
			ListableP[TimeP],
			Variables :> {options}
		],

		Example[
			{Options, EndTemperature, "EndTemperature is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, EndTemperature],
			ListableP[TemperatureP],
			Variables :> {options}
		],

		Example[
			{Options, EndTemperature, "EndTemperature is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				EndTemperature -> 100Celsius,
				Output -> Options
			];
			Lookup[options, EndTemperature],
			100Celsius | 100.Celsius,
			Variables :> {options}
		],

		Example[
			{Options, EndTemperature, "EndTemperature is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, EndTemperature],
			ListableP[TemperatureP],
			Variables :> {options}
		],

		Example[
			{Options, TemperatureRampRate, "TemperatureRampRate is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, TemperatureRampRate],
			ListableP[GreaterP[0Celsius / Minute]],
			Variables :> {options}
		],

		Example[
			{Options, TemperatureRampRate, "TemperatureRampRate is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				TemperatureRampRate -> 10Celsius / Minute,
				Output -> Options
			];
			Lookup[options, TemperatureRampRate],
			ListableP[GreaterP[0Celsius / Minute]],
			Variables :> {options}
		],

		Example[
			{Options, TemperatureRampRate, "TemperatureRampRate is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, TemperatureRampRate],
			ListableP[GreaterP[0Celsius / Minute]],
			Variables :> {options}
		],

		Example[
			{Options, RampTime, "RampTime is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, RampTime],
			TimeP,
			Variables :> {options}
		],

		Example[
			{Options, RampTime, "RampTime is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
				RampTime -> 5Minute,
				Output -> Options
			];
			Convert[Lookup[options, RampTime], Minute],
			TimeP,
			Variables :> {options}
		],

		Example[
			{Options, RampTime, "RampTime is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				RampTime -> {Automatic, 5Minute, 20Minute, Automatic, Automatic},
				Output -> Options
			];
			Lookup[options, RampTime],
			ListableP[TimeP],
			Variables :> {options}
		],

		Example[
			{Options, RecoupSample, "RecoupSample is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, RecoupSample],
			BooleanP,
			Variables :> {options}
		],

		Example[
			{Options, RecoupSample, "RecoupSample is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
				RecoupSample -> True,
				Output -> Options
			];
			Lookup[options, RecoupSample],
			True,
			Variables :> {options}
		],

		Example[
			{Options, RecoupSample, "RecoupSample is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				RecoupSample -> {True, Automatic, False, Automatic, Null},
				Output -> Options
			];
			Lookup[options, RecoupSample],
			ListableP[BooleanP | NullP],
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleContainer, "PreparedSampleContainer is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, PreparedSampleContainer],
			ObjectP[Model[Container]] | ObjectP[Object[Container]] | NullP,
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleContainer, "PreparedSampleContainer is properly resolved for a single input sample when RecoupSample is set to True:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				RecoupSample -> True,
				Output -> Options
			];
			Lookup[options, PreparedSampleContainer],
			ObjectP[Model[Container]] | ObjectP[Object[Container]],
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleContainer, "PreparedSampleContainer is properly set to a user-specified value for a single input sample when RecoupSample is set to True:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
				RecoupSample -> True,
				PreparedSampleContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			];
			Lookup[options, PreparedSampleContainer],
			ObjectP[Model[Container, Vessel, "50mL Tube"]],
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleContainer, "PreparedSampleContainer is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				RecoupSample -> {True, Automatic, False, Automatic, Automatic},
				Output -> Options
			];
			Lookup[options, PreparedSampleContainer],
			ListableP[ObjectP[Model[Container]] | ObjectP[Object[Container]] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleStorageCondition, "PreparedSampleStorageCondition is properly set to the default value (Null) for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, PreparedSampleStorageCondition],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleStorageCondition, "PreparedSampleStorageCondition is properly set to the default value (Null) for a single input sample when RecoupSample is set to True:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				RecoupSample -> True,
				Output -> Options
			];
			Lookup[options, PreparedSampleStorageCondition],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleStorageCondition, "PreparedSampleStorageCondition is properly set to a user-specified value for a single input sample when RecoupSample is set to True:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
				RecoupSample -> True,
				PreparedSampleStorageCondition -> Model[StorageCondition, "Refrigerator"],
				Output -> Options
			];
			Lookup[options, PreparedSampleStorageCondition],
			ObjectP[Model[StorageCondition, "Refrigerator"]],
			Variables :> {options}
		],

		Example[
			{Options, PreparedSampleStorageCondition, "PreparedSampleStorageCondition is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				RecoupSample -> {True, Automatic, False, Automatic, Automatic},
				PreparedSampleStorageCondition -> {Model[StorageCondition, "Refrigerator"], Null, Null, Null, Null},
				Output -> Options
			];
			Lookup[options, PreparedSampleStorageCondition],
			ListableP[ObjectP[Model[StorageCondition]] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, CapillaryStorageCondition, "CapillaryStorageCondition is properly set to the default value (Disposal) for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, CapillaryStorageCondition],
			Disposal,
			Variables :> {options}
		],

		Example[
			{Options, CapillaryStorageCondition, "CapillaryStorageCondition is properly set to a user-specified value for a single input sample when RecoupSample is set to True:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
				RecoupSample -> True,
				CapillaryStorageCondition -> Model[StorageCondition, "Refrigerator"],
				Output -> Options
			];
			Lookup[options, CapillaryStorageCondition],
			ObjectP[Model[StorageCondition, "Refrigerator"]],
			Variables :> {options}
		],

		Example[
			{Options, CapillaryStorageCondition, "CapillaryStorageCondition is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				CapillaryStorageCondition -> {Model[StorageCondition, "Refrigerator"], Disposal, RefrigeratorDesiccated, Disposal, AmbientStorage},
				Output -> Options
			];
			Lookup[options, CapillaryStorageCondition],
			ListableP[ObjectP[Model[StorageCondition]] | SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal],
			Variables :> {options}
		],

		(* --- Grind Options --- *)
		Example[
			{Options, Grind, "Grind is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Grind],
			ListableP[BooleanP],
			Variables :> {options}
		],

		Example[
			{Options, Grind, "Grind is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Grind],
			ListableP[False],
			Variables :> {options}
		],

		Example[
			{Options, Grind, "Grind is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Grind -> {True, False, Automatic, False, Automatic},
				Output -> Options
			];
			Lookup[options, Grind],
			ListableP[BooleanP],
			Variables :> {options}
		],

		Example[
			{Options, GrinderType, "GrinderType is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrinderType],
			GrinderTypeP,
			Variables :> {options}
		],

		Example[
			{Options, GrinderType, "GrinderType is properly set to a user-defined value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				GrinderType -> KnifeMill,
				Output -> Options
			];
			Lookup[options, GrinderType],
			GrinderTypeP,
			Variables :> {options}
		],

		Example[
			{Options, GrinderType, "GrinderType is automatically set to Null if the input sample is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrinderType],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, GrinderType, "GrinderType is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				GrinderType -> {Automatic, KnifeMill, Automatic, Automatic, Automatic};
				Output -> Options
			];
			Lookup[options, GrinderType],
			ListableP[GrinderTypeP | NullP],
			Variables :> {options}
		],

		Example[
			{Options, Grinder, "Grinder is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Grinder],
			ListableP[ObjectP[Model[Instrument, Grinder]] | ObjectP[Object[Instrument, Grinder]] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, Grinder, "Grinder is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grinder -> Model[Instrument, Grinder, "Automated Mortar Grinder"],
				Output -> Options
			];
			Lookup[options, Grinder],
			ListableP[ObjectP[Model[Instrument, Grinder]] | ObjectP[Object[Instrument, Grinder]] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, Grinder, "Grinder is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Grinder -> {Automatic, Model[Instrument, Grinder, "Tube Mill Control"], Automatic, Automatic, Automatic},
				Output -> Options
			];
			Lookup[options, Grinder],
			ListableP[ObjectP[Model[Instrument, Grinder]] | ObjectP[Object[Instrument, Grinder]] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, Fineness, "Fineness is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Fineness],
			ListableP[GreaterP[0Millimeter] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, Fineness, "Fineness is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Fineness],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, Fineness, "Fineness is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Fineness -> {Automatic, 10Millimeter, Automatic, Null, Automatic},
				Output -> Options
			];
			Lookup[options, Fineness],
			ListableP[GreaterP[0Millimeter] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, BulkDensity, "BulkDensity is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BulkDensity],
			ListableP[GreaterP[0Gram / Milliliter] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, BulkDensity, "BulkDensity is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BulkDensity],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, BulkDensity, "BulkDensity is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				BulkDensity -> {Automatic, 5Gram / Milliliter, Automatic, Null, Automatic},
				Output -> Options
			];
			Lookup[options, BulkDensity],
			ListableP[GreaterP[0Gram / Milliliter] | Null],
			Variables :> {options}
		],

		Example[
			{Options, GrindingContainer, "GrindingContainer is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingContainer],
			ListableP[Alternatives[
				ObjectP[Model[Container, GrindingContainer]],
				ObjectP[Object[Container, GrindingContainer]],
				ObjectP[Model[Container, Vessel]],
				ObjectP[Object[Container, Vessel]],
				NullP
			]],
			Variables :> {options}
		],

		Example[
			{Options, GrindingContainer, "GrindingContainer is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingContainer],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, GrindingContainer, "GrindingContainer is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, GrindingContainer],
			ListableP[Alternatives[
				ObjectP[Model[Container, GrindingContainer]],
				ObjectP[Object[Container, GrindingContainer]],
				ObjectP[Model[Container, Vessel]],
				ObjectP[Object[Container, Vessel]],
				NullP
			]],
			Variables :> {options}
		],

		Example[
			{Options, GrindingBead, "GrindingBead is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingBead],
			ListableP[Alternatives[
				ObjectP[Model[Item, GrindingBead]],
				ObjectP[Object[Item, GrindingBead]],
				NullP
			]],
			Variables :> {options}
		],

		Example[
			{Options, GrindingBead, "GrindingBead is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingBead],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, GrindingBead, "GrindingBead is properly resolved to Null if the GrinderType is not set to BallMill:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				GrinderType -> KnifeMill,
				Output -> Options
			];
			Lookup[options, GrindingBead],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, GrindingBead, "GrindingBead is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, GrindingBead],
			ListableP[Alternatives[
				ObjectP[Model[Item, GrindingBead]],
				ObjectP[Object[Item, GrindingBead]],
				NullP
			]],
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingBeads, "NumberOfGrindingBeads is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, NumberOfGrindingBeads],
			ListableP[NumberP],
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingBeads, "NumberOfGrindingBeads is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, NumberOfGrindingBeads],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingBeads, "NumberOfGrindingBeads is properly resolved to Null if the GrinderType is not set to BallMill:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				GrinderType -> KnifeMill,
				Output -> Options
			];
			Lookup[options, NumberOfGrindingBeads],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingBeads, "NumberOfGrindingBeads is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, NumberOfGrindingBeads],
			ListableP[NumberP | NullP],
			Variables :> {options}
		],

		Example[
			{Options, GrindingRate, "GrindingRate is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingRate],
			ListableP[RPMP | FrequencyP],
			Variables :> {options}
		],

		Example[
			{Options, GrindingRate, "GrindingRate is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingRate],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, GrindingRate, "GrindingRate is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, GrindingRate],
			ListableP[RPMP | FrequencyP | NullP],
			Variables :> {options}
		],

		Example[
			{Options, GrindingTime, "GrindingTime is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingTime],
			ListableP[TimeP],
			Variables :> {options}
		],

		Example[
			{Options, GrindingTime, "GrindingTime is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingTime],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, GrindingTime, "GrindingTime is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Output -> Options
			];
			Lookup[options, GrindingTime],
			ListableP[TimeP | NullP],
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingSteps, "NumberOfGrindingSteps is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, NumberOfGrindingSteps],
			ListableP[NumberP],
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingSteps, "NumberOfGrindingSteps is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, NumberOfGrindingSteps],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingSteps, "NumberOfGrindingSteps is properly resolved to Null if Grind is set to False:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				Output -> Options
			];
			Lookup[options, NumberOfGrindingSteps],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, NumberOfGrindingSteps, "NumberOfGrindingSteps is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				NumberOfGrindingSteps -> {2, Automatic, Automatic, Automatic, Automatic},
				Grind -> {Automatic, False, Automatic, Automatic, Automatic},
				Output -> Options
			];
			Lookup[options, NumberOfGrindingSteps],
			ListableP[NumberP | NullP],
			Variables :> {options}
		],

		Example[
			{Options, GrindingProfile, "GrindingProfile is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingProfile],
			ListableP[{{Grinding | Cooling, RPMP | FrequencyP, TimeP}..} | NullP],
			Variables :> {options}
		],

		Example[
			{Options, GrindingProfile, "GrindingProfile is properly resolved to Null if the input is prepacked in a melting point capillary tube:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, GrindingProfile],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, GrindingProfile, "GrindingProfile is properly resolved to Null if Grind is set to False:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				Output -> Options
			];
			Lookup[options, GrindingProfile],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, GrindingProfile, "GrindingProfile is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				NumberOfGrindingSteps -> {4, Automatic, 5, Automatic, Automatic},
				Grind -> {Automatic, False, True, Automatic, Automatic},
				Output -> Options
			];
			Lookup[options, GrindingProfile],
			ListableP[{{Grinding | Cooling, RPMP | FrequencyP, TimeP} ..} | NullP],
			Variables :> {options}
		],

		(* --- Desiccate Options --- *)
		Example[
			{Options, Desiccate, "Desiccate is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Desiccate],
			ListableP[BooleanP],
			Variables :> {options}
		],

		Example[
			{Options, Desiccate, "Desiccate is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Desiccate],
			ListableP[False],
			Variables :> {options}
		],

		Example[
			{Options, Desiccate, "Desiccate is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {True, False, Automatic, False, Automatic},
				Output -> Options
			];
			Lookup[options, Desiccate],
			ListableP[BooleanP],
			Variables :> {options}
		],

		Example[
			{Options, SampleContainer, "SampleContainer is properly set to the default value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, SampleContainer],
			ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]],
			Variables :> {options}
		],

		Example[
			{Options, SampleContainer, "SampleContainer is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, SampleContainer],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, SampleContainer, "SampleContainer is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				SampleContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			];
			Lookup[options, SampleContainer],
			ObjectP[Model[Container, Vessel, "50mL Tube"]],
			Variables :> {options}
		],

		Example[
			{Options, SampleContainer, "SampleContainer is properly resolved for multiple input samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				SampleContainer -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"], Null, Null, Null},
				Output -> Options
			];
			Lookup[options, SampleContainer],
			ListableP[ObjectP[Model[Container, Vessel]] | NullP],
			Variables :> {options}
		],

		Example[
			{Options, DesiccationMethod, "DesiccationMethod is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DesiccationMethod],
			DesiccationMethodP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationMethod, "DesiccationMethod is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DesiccationMethod],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationMethod, "DesiccationMethod is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				DesiccationMethod -> DesiccantUnderVacuum,
				Output -> Options
			];
			Lookup[options, DesiccationMethod],
			DesiccationMethodP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationMethod, "DesiccationMethod is properly resolved to a method of desiccation if at least one sample is Desiccate is set to True:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {True, False, False, False, False},
				Output -> Options
			];
			Lookup[options, DesiccationMethod],
			DesiccationMethodP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationMethod, "DesiccationMethod is automatically set to Null if Desiccate is set to False for all samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False, False, False, False},
				Output -> Options
			];
			Lookup[options, DesiccationMethod],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, Desiccant, "Desiccant is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Desiccant],
			ObjectP[Object[Sample]] | ObjectP[Model[Sample]],
			Variables :> {options}
		],

		Example[
			{Options, Desiccant, "Desiccant is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Desiccant],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, Desiccant, "Desiccant is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Desiccant -> Model[Sample, "Test Indicating Drierite For ExperimentMeasureMeltingPoint Tests " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Desiccant],
			ObjectP[Object[Sample]] | ObjectP[Model[Sample]],
			Variables :> {options}
		],

		Example[
			{Options, Desiccant, "Desiccant is properly resolved to a method of desiccation if at least one sample is Desiccate is set to True:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {True, False, False, False, False},
				Output -> Options
			];
			Lookup[options, Desiccant],
			ObjectP[Object[Sample]] | ObjectP[Model[Sample]],
			Variables :> {options}
		],

		Example[
			{Options, Desiccant, "Desiccant is automatically set to Null if Desiccate is set to False for all samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False, False, False, False},
				Output -> Options
			];
			Lookup[options, Desiccant],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantPhase, "DesiccantPhase is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DesiccantPhase],
			PhysicalStateP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantPhase, "DesiccantPhase is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DesiccantPhase],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantPhase, "DesiccantPhase is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				DesiccantPhase -> Liquid,
				Output -> Options
			];
			Lookup[options, DesiccantPhase],
			Liquid,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantPhase, "DesiccantPhase is properly resolved to a method of desiccation if at least one sample is Desiccate is set to True:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {True, False, False, False, False},
				Output -> Options
			];
			Lookup[options, DesiccantPhase],
			PhysicalStateP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantPhase, "DesiccantPhase is automatically set to Null if Desiccate is set to False for all samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False, False, False, False},
				Output -> Options
			];
			Lookup[options, DesiccantPhase],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantAmount, "DesiccantAmount is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DesiccantAmount],
			MassP | VolumeP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantAmount, "DesiccantAmount is properly resolved to a volume unit if the DesiccantPhase is set to Liquid:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				DesiccantPhase -> Liquid,
				Output -> Options
			];
			Lookup[options, DesiccantAmount],
			VolumeP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantAmount, "DesiccantAmount is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DesiccantAmount],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantAmount, "DesiccantAmount is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				DesiccantAmount -> 200Gram,
				Output -> Options
			];
			Lookup[options, DesiccantAmount],
			200.Gram | 200Gram,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantAmount, "DesiccantAmount is properly resolved to a method of desiccation if at least one sample is Desiccate is set to True:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {True, False, False, False, False},
				Output -> Options
			];
			Lookup[options, DesiccantAmount],
			MassP | VolumeP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccantAmount, "DesiccantAmount is automatically set to Null if Desiccate is set to False for all samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False, False, False, False},
				Output -> Options
			];
			Lookup[options, DesiccantAmount],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, Desiccator, "Desiccator is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Desiccator],
			ObjectP[Model[Instrument, Desiccator]] | ObjectP[Object[Instrument, Desiccator]],
			Variables :> {options}
		],

		Example[
			{Options, Desiccator, "Desiccator is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, Desiccator],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, Desiccator, "Desiccator is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Desiccator -> Object[Instrument, Desiccator, "Kavir"],
				Output -> Options
			];
			Lookup[options, Desiccator],
			ObjectP[Model[Instrument, Desiccator]] | ObjectP[Object[Instrument, Desiccator]],
			Variables :> {options}
		],

		Example[
			{Options, Desiccator, "Desiccator is properly resolved to a method of desiccation if at least one sample is Desiccate is set to True:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {True, False, False, False, False},
				Output -> Options
			];
			Lookup[options, Desiccator],
			ObjectP[Model[Instrument, Desiccator]] | ObjectP[Object[Instrument, Desiccator]],
			Variables :> {options}
		],

		Example[
			{Options, Desiccator, "Desiccator is automatically set to Null if Desiccate is set to False for all samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False, False, False, False},
				Output -> Options
			];
			Lookup[options, Desiccator],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationTime, "DesiccationTime is properly resolved for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DesiccationTime],
			TimeP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationTime, "DesiccationTime is properly resolved for a single input sample that is prepacked in a melting point capillary:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, DesiccationTime],
			NullP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationTime, "DesiccationTime is properly set to a user-specified value for a single input sample:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				DesiccationTime -> 16Hour,
				Output -> Options
			];
			Convert[Lookup[options, DesiccationTime], Hour],
			16Hour | 16.Hour,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationTime, "DesiccationTime is properly resolved to a method of desiccation if at least one sample is Desiccate is set to True:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {True, False, False, False, False},
				Output -> Options
			];
			Lookup[options, DesiccationTime],
			TimeP,
			Variables :> {options}
		],

		Example[
			{Options, DesiccationTime, "DesiccationTime is automatically set to Null if Desiccate is set to False for all samples:"},
			options = ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False, False, False, False},
				Output -> Options
			];
			Lookup[options, DesiccationTime],
			NullP,
			Variables :> {options}
		],

		(* --- Shared Options --- *)
		Example[{Options, PreparatoryUnitOperations, "Specifies prepared samples for ExperimentMeasureMeltingPoint (PreparatoryUnitOperations):"},
			Lookup[ExperimentMeasureMeltingPoint["My MeasureMeltingPoint Sample",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My MeasureMeltingPoint Sample",
						Container -> Model[Container, Vessel, "2mL tube with no skirt"]
					],
					Transfer[
						Source -> {
							Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
							Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID]
						},
						Destination -> "My MeasureMeltingPoint Sample",
						Amount -> {0.1 Gram, 0.2 Gram}
					]
				},
				Output -> Options
			], PreparatoryUnitOperations],
			{SamplePreparationP..}
		],

		Example[{Options, PreparatoryPrimitives, "Specifies prepared samples for ExperimentMeasureMeltingPoint (PreparatoryPrimitives):"},
			Lookup[ExperimentMeasureMeltingPoint["My MeasureMeltingPoint Container",
				PreparatoryPrimitives -> {
					Define[
						Name -> "My MeasureMeltingPoint Container",
						Container -> Model[Container, Vessel, "2mL tube with no skirt"]
					],
					Transfer[
						Source -> Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
						Amount -> 0.3 Gram,
						Destination -> "My MeasureMeltingPoint Container"
					]
				},
				Output -> Options
			], PreparatoryPrimitives],
			{Define[_], Transfer[_]}
		],

		Example[
			{Options, Name, "Uses an object name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			Lookup[
				ExperimentMeasureMeltingPoint[
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Name -> "Max E. Mumm's MeasureMeltingPoint Sample",
					Output -> Options
				],
				Name
			],
			"Max E. Mumm's MeasureMeltingPoint Sample"
		],

		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Lookup[
				ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					MeasureWeight -> True,
					Output -> Options],
				MeasureWeight
			],
			True
		],

		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Lookup[
				ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					MeasureWeight -> True,
					Output -> Options],
				MeasureVolume
			],
			True
		],

		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be imaged after running the experiment:"},
			options = ExperimentMeasureMeltingPoint[Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				ImageSample -> True,
				Output -> Options
			];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],

		Example[{Options, Template, "Inherits options from a previously run MeasureMeltingPoint protocol:"},
			options = ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Template -> Object[Protocol, MeasureMeltingPoint, "Test MeasureMeltingPoint option template protocol" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ExpectedMeltingPoint],
			100Celsius | 100.Celsius,
			Variables :> {options}
		],

		(* ---  Messages --- *)
		Example[
			{Messages, "InvalidOrderOfOperations", "If Grind or Desiccate are set to False but OrderOfOperations is NOT set to Null, ExtraneousOrderOfOperations is generated:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Desiccate -> False,
				Grind -> True,
				OrderOfOperations -> {Desiccate, Grind}
			],
			ObjectP[Object[Protocol, MeasureMeltingPoint]],
			Messages :> {Warning::ExtraneousOrderOfOperations}
		],

		Example[
			{Messages, "UndefinedOrderOfOperations", "If Grind and Desiccate are set to True but OrderOfOperations is set to Null, InvalidOrderOfOperations is generated:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Desiccate -> True,
				Grind -> True,
				OrderOfOperations -> Null
			],
			$Failed,
			Messages :> {Error::UndefinedOrderOfOperations, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidExpectedMeltingPoint", "An error is thrown if ExpectedMeltingPoint is set to a value greater than 349.9 Celsius:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				ExpectedMeltingPoint -> 350Celsius
			],
			$Failed,
			Messages :> {
				Error::InvalidExpectedMeltingPoint,
				Error::InvalidOption
			}
		],

		Example[
			{Messages, "InvalidStartEndTemperature", "An error is thrown if the specified StartTemperature is equal or greater than the specified EndTemperature:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				EndTemperature -> 250Celsius,
				StartTemperature -> 260Celsius
			],
			$Failed,
			Messages :> {
				Error::InvalidStartEndTemperatures,
				Error::InvalidOption
			}
		],

		Example[
			{Messages, "MismatchedRampRateAndTime", "A warning is thrown if both TemperatureRampRate and RampTime are specified but they do not match:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				TemperatureRampRate -> 2Celsius / Minute,
				RampTime -> 5Minute,
				Output -> Options
			],
			{_Rule...},
			Messages :> {Warning::MismatchedRampRateAndTime}
		],

		Example[
			{Messages, "InvalidPreparedSampleContainer", "An error is thrown if RecoupSample is False but PreparedSampleContainer is specified:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				RecoupSample -> False,
				PreparedSampleContainer -> Model[Container, Vessel, "50mL Tube"]
			],
			$Failed,
			Messages :> {Error::InvalidPreparedSampleContainer, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidPreparedSampleStorageCondition", "An error is thrown if RecoupSample is False but PreparedSampleStorageCondition is specified:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				RecoupSample -> False,
				PreparedSampleStorageCondition -> Model[StorageCondition, "Refrigerator"]
			],
			$Failed,
			Messages :> {Error::InvalidPreparedSampleStorageCondition, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidNumberOfReplicates", "An error is thrown if the input sample is prepacked in a melting point capillary and NumberOfReplicates is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				NumberOfReplicates -> 3
			],
			$Failed,
			Messages :> {Error::InvalidNumberOfReplicates, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidDesiccateOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but Desiccate is not False:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Desiccate -> True
			],
			$Failed,
			Messages :> {Error::InvalidDesiccateOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidDesiccationMethodOptions", "An error is thrown if all input samples are prepacked in melting point capillaries but DesiccationMethod is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				DesiccationMethod -> StandardDesiccant
			],
			$Failed,
			Messages :> {Error::InvalidDesiccationMethodOptions, Error::DesiccationMethodMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccationMethodMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but DesiccationMethod is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				DesiccationMethod -> StandardDesiccant
			],
			$Failed,
			Messages :> {Error::DesiccationMethodMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccationMethodMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but DesiccationMethod is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				DesiccationMethod -> StandardDesiccant
			],
			$Failed,
			Messages :> {Error::DesiccationMethodMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidDesiccantOptions", "An error is thrown if all input samples are prepacked in melting point capillaries but Desiccant is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccant -> Model[Sample, "Test Indicating Drierite For ExperimentMeasureMeltingPoint Tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::InvalidDesiccantOptions, Error::DesiccantMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccantMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but Desiccant is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				Desiccant -> Model[Sample, "Test Indicating Drierite For ExperimentMeasureMeltingPoint Tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::DesiccantMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccantMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but Desiccant is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				Desiccant -> Model[Sample, "Test Indicating Drierite For ExperimentMeasureMeltingPoint Tests " <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::DesiccantMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidDesiccantPhaseOptions", "An error is thrown if all input samples are prepacked in melting point capillaries but DesiccantPhase is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				DesiccantPhase -> Solid
			],
			$Failed,
			Messages :> {Error::InvalidDesiccantPhaseOptions, Error::DesiccantPhaseMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccantPhaseMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but DesiccantPhase is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				DesiccantPhase -> Liquid
			],
			$Failed,
			Messages :> {Error::DesiccantPhaseMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccantPhaseMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but DesiccantPhase is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				DesiccantPhase -> Solid
			],
			$Failed,
			Messages :> {Error::DesiccantPhaseMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidDesiccantAmountOptions", "An error is thrown if all input samples are prepacked in melting point capillaries but DesiccantAmount is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				DesiccantAmount -> 100Gram
			],
			$Failed,
			Messages :> {Error::InvalidDesiccantAmountOptions, Error::DesiccantAmountMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccantAmountMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but DesiccantAmount is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				DesiccantAmount -> 200Gram
			],
			$Failed,
			Messages :> {Error::DesiccantAmountMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccantAmountMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but DesiccantAmount is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				DesiccantAmount -> 150Gram
			],
			$Failed,
			Messages :> {Error::DesiccantAmountMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidDesiccatorOptions", "An error is thrown if all input samples are prepacked in melting point capillaries but Desiccator is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccator -> Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"]
			],
			$Failed,
			Messages :> {Error::InvalidDesiccatorOptions, Error::DesiccatorMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccatorMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but Desiccator is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				Desiccator -> Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"]
			],
			$Failed,
			Messages :> {Error::DesiccatorMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccatorMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but Desiccator is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				Desiccator -> Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"]
			],
			$Failed,
			Messages :> {Error::DesiccatorMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidDesiccationTimeOptions", "An error is thrown if all input samples are prepacked in melting point capillaries but DesiccationTime is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				DesiccationTime -> 16Hour
			],
			$Failed,
			Messages :> {Error::InvalidDesiccationTimeOptions, Error::DesiccationTimeMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccationTimeMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but DesiccationTime is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				DesiccationTime -> 10Hour
			],
			$Failed,
			Messages :> {Error::DesiccationTimeMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "DesiccationTimeMismatchOptions", "An error is thrown if Desiccate is set to False for all input samples but DesiccationTime is not Null:"},
			ExperimentMeasureMeltingPoint[
				{
					Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
					Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID]
				},
				Desiccate -> {False, False},
				DesiccationTime -> 8Hour
			],
			$Failed,
			Messages :> {Error::DesiccationTimeMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidSampleContainerOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but SampleContainer is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				SampleContainer -> Model[Container, Vessel, "50mL Tube"]
			],
			$Failed,
			Messages :> {Error::InvalidSampleContainerOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "SampleContainerMismatchOptions", "An error is thrown if Desiccate is set to False but SampleContainer is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Desiccate -> False,
				SampleContainer -> Model[Container, Vessel, "50mL Tube"]
			],
			$Failed,
			Messages :> {
				Error::SampleContainerMismatchOptions,
				Error::InvalidOption
			}
		],

		Example[
			{Messages, "InvalidGrindOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but Grind is not False:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Grind -> True
			],
			$Failed,
			Messages :> {Error::InvalidGrindOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidGrinderTypeOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but GrinderType is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				GrinderType -> KnifeMill
			],
			$Failed,
			Messages :> {Error::InvalidGrinderTypeOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "GrinderTypeMismatchOptions", "An error is thrown if Grind is set to False but GrinderType is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				GrinderType -> KnifeMill
			],
			$Failed,
			Messages :> {Error::GrinderTypeMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidGrinderOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but Grinder is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Grinder -> Model[Instrument, Grinder, "Tube Mill Control"]
			],
			$Failed,
			Messages :> {Error::InvalidGrinderOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "GrinderMismatchOptions", "An error is thrown if Grind is set to False but Grinder is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				Grinder -> Model[Instrument, Grinder, "Tube Mill Control"]
			],
			$Failed,
			Messages :> {Error::GrinderMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidFinenessOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but Fineness is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Fineness -> 2Millimeter
			],
			$Failed,
			Messages :> {Error::InvalidFinenessOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "FinenessMismatchOptions", "An error is thrown if Grind is set to False but Fineness is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				Fineness -> 2Millimeter
			],
			$Failed,
			Messages :> {Error::FinenessMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidBulkDensityOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but BulkDensity is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				BulkDensity -> 2Gram / Milliliter
			],
			$Failed,
			Messages :> {Error::InvalidBulkDensityOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "BulkDensityMismatchOptions", "An error is thrown if Grind is set to False but BulkDensity is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				BulkDensity -> 2Gram / Milliliter
			],
			$Failed,
			Messages :> {Error::BulkDensityMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidGrindingContainerOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but GrindingContainer is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				GrindingContainer -> Model[Container, GrindingContainer, "Grinding Bowl for Automated Mortar Grinder"]
			],
			$Failed,
			Messages :> {Error::InvalidGrindingContainerOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "GrindingContainerMismatchOptions", "An error is thrown if Grind is set to False but GrindingContainer is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				GrindingContainer -> Model[Container, GrindingContainer, "Grinding Bowl for Automated Mortar Grinder"]
			],
			$Failed,
			Messages :> {Error::GrindingContainerMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidGrindingBeadOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but GrindingBead is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				GrindingBead -> Model[Item, GrindingBead, "2.8 mm stainless steel grinding bead"]
			],
			$Failed,
			Messages :> {Error::InvalidGrindingBeadOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "GrindingBeadMismatchOptions", "An error is thrown if Grind is set to False but GrindingBead is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				GrindingBead -> Model[Item, GrindingBead, "2.8 mm stainless steel grinding bead"]
			],
			$Failed,
			Messages :> {Error::GrindingBeadMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidNumberOfGrindingBeadsOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but NumberOfGrindingBeads is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				NumberOfGrindingBeads -> 5
			],
			$Failed,
			Messages :> {Error::InvalidNumberOfGrindingBeadsOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "NumberOfGrindingBeadsMismatchOptions", "An error is thrown if Grind is set to False but NumberOfGrindingBeads is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				NumberOfGrindingBeads -> 5
			],
			$Failed,
			Messages :> {Error::NumberOfGrindingBeadsMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidGrindingRateOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but GrindingRate is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				GrindingRate -> 3000RPM
			],
			$Failed,
			Messages :> {Error::InvalidGrindingRateOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "GrindingRateMismatchOptions", "An error is thrown if Grind is set to False but GrindingRate is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				GrindingRate -> 3000RPM
			],
			$Failed,
			Messages :> {Error::GrindingRateMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidGrindingTimeOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but GrindingTime is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				GrindingTime -> 1Minute
			],
			$Failed,
			Messages :> {Error::InvalidGrindingTimeOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "GrindingTimeMismatchOptions", "An error is thrown if Grind is set to False but GrindingTime is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				GrindingTime -> 1Minute
			],
			$Failed,
			Messages :> {Error::GrindingTimeMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidNumberOfGrindingStepsOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but NumberOfGrindingSteps is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				NumberOfGrindingSteps -> 2
			],
			$Failed,
			Messages :> {Error::InvalidNumberOfGrindingStepsOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "NumberOfGrindingStepsMismatchOptions", "An error is thrown if Grind is set to False but NumberOfGrindingSteps is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				NumberOfGrindingSteps -> 2
			],
			$Failed,
			Messages :> {Error::NumberOfGrindingStepsMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidCoolingTimeOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but CoolingTime is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				CoolingTime -> 5Minute
			],
			$Failed,
			Messages :> {Error::InvalidCoolingTimeOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "CoolingTimeMismatchOptions", "An error is thrown if Grind is set to False but CoolingTime is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				CoolingTime -> 5Minute
			],
			$Failed,
			Messages :> {Error::CoolingTimeMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "InvalidGrindingProfileOptions", "An error is thrown if the input sample is prepacked in a melting point capillary but GrindingProfile is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				GrindingProfile -> {{Grinding, 3000RPM, 30Second}}
			],
			$Failed,
			Messages :> {Error::InvalidGrindingProfileOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "GrindingProfileMismatchOptions", "An error is thrown if Grind is set to False but GrindingProfile is not Null:"},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Grind -> False,
				GrindingProfile -> {{Grinding, 3000RPM, 30Second}}
			],
			$Failed,
			Messages :> {Error::GrindingProfileMismatchOptions, Error::InvalidOption}
		],

		Example[
			{Messages, "MissingMassInformation", "If Amount is not specified and Mass of the sample is not informed, 1 Gram will be considered to calculate options automatically."},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Sample 15 No Mass" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, MeasureMeltingPoint]],
			Messages :> {Warning::MissingMassInformation}
		],

		Example[
			{Messages, "NoPreparedSample", "If the input sample is prepacked in a melting point capillary tube, no new sample is prepared in this experiment by grinding or desiccating, therefore, RecoupSample must be Null if the sample is prepacked in a melting point capillary."},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				RecoupSample -> True
			],
			$Failed,
			Messages :> {Error::NoPreparedSampleToRecoup, Error::InvalidOption}
		],

		Example[
			{Messages, "NoPreparedSampleToRecoup", "If the input sample is prepacked in a melting point capillary tube, no new sample is prepared in this experiment by grinding or desiccating, therefore, PreparedSampleContainer must be Null if the sample is prepacked in a melting point capillary."},
			ExperimentMeasureMeltingPoint[
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				PreparedSampleContainer -> Model[Container, Vessel, "2mL Tube"]
			],
			$Failed,
			Messages :> {Error::NoPreparedSample, Error::InvalidPreparedSampleContainer, Error::InvalidOption}
		]
	},

	SetUp :> (ClearMemoization[]),
	SymbolSetUp :> (

		$CreatedObjects = {};

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::SimilarMolecules];
		Off[Warning::SampleMustBeMoved];
		Off[Warning::DeprecatedProduct];

		Module[
			{allObjects},

			(* list of test objects*)
			allObjects = {
				Object[Container, Bench, "Test Bench for ExperimentMeasureMelting" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 1 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 2 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 3 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 4 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 5 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 6 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 7 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 8 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 9 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 10 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 11 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 12 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 13 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 14 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 15 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 16 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 17 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 18 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 19 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 20 " <> $SessionUUID],
				Object[Container, Bag, "MeasureMeltingPointing test capillary bag " <> $SessionUUID],
				Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 1 " <> $SessionUUID],
				Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 2 " <> $SessionUUID],
				Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 3 " <> $SessionUUID],


				(* identity models *)
				Model[Molecule, "Test Molecule with melting point of 99 Celsius" <> $SessionUUID],
				Model[Molecule, "Test Molecule with melting point of 152 Celsius" <> $SessionUUID],
				Model[Molecule, "Test Molecule with melting point of 350 Celsius" <> $SessionUUID],
				Model[Molecule, "Test NaCl Molecule " <> $SessionUUID],
				Model[Molecule, "Test CaO Molecule " <> $SessionUUID],
				Model[Molecule, "Test Helium Molecule " <> $SessionUUID],

				(* sample models *)
				Model[Sample, "Test solid sample 1 " <> $SessionUUID],
				Model[Sample, "Test solid sample 99C " <> $SessionUUID],
				Model[Sample, "Test solid sample 350C " <> $SessionUUID],
				Model[Sample, "Test solid sample with 3 components " <> $SessionUUID],
				Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
				Model[Sample, "Test no-state sample 1 " <> $SessionUUID],
				Model[Sample, "Test no-StorageCondition sample 1 " <> $SessionUUID],
				Model[Sample, "Test Indicating Drierite For ExperimentMeasureMeltingPoint Tests " <> $SessionUUID],
				Model[Sample, "Test gas sample 1 " <> $SessionUUID],


				(* sample objects *)
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 3 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 4 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 5 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 6 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 7 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 8 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 9 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 10 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 11 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 12 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 13 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 14 Liquid" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 15 No Mass" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 16 Liquid No Amount" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 18 - 350 Celsius " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 19 - Multi-Component " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 3 " <> $SessionUUID],

				(* template protocol *)
				Object[Protocol, MeasureMeltingPoint, "Test MeasureMeltingPoint option template protocol" <> $SessionUUID]

			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False]];
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[
				{
					testMoleculeModelPacket, solidSampleModelPacket, multipleComponentSampleModelPacket, sampleModelPacket350C, sampleModelPacket99C, noStateSampleModelPacket, noStorageConditionModelPacket, liquidSampleModelPacket, testSampleModels, desiccantModelPacket, gasModelPacket, testSampleLocations, testSampleAmounts, testSampleNames, createdSamples1, testSampleMeltingPoints, testSampleBoilingPoints, testBench
				},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test Bench for ExperimentMeasureMelting" <> $SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];
				(* create all the containers and identity models, and Cartridges *)
				UploadSample[
					Flatten[{
						ConstantArray[Model[Container, Vessel, "2mL Tube"], 20],
						Model[Container, Bag, "Bag for storage of capillary tubes"]
					}],
					ConstantArray[{"Bench Top Slot", testBench}, 21],
					Name -> Flatten[{
						Table["MeasureMeltingPointing test container " <> ToString[i] <> " " <> $SessionUUID, {i, 20}],
						"MeasureMeltingPointing test capillary bag " <> $SessionUUID
					}]
				];

				UploadSample[
					{
						Model[Container, Capillary, "Melting point capillary"],
						Model[Container, Capillary, "Melting point capillary"],
						Model[Container, Capillary, "Melting point capillary"]
					},
					{
						{"A1", Object[Container, Bag, "MeasureMeltingPointing test capillary bag " <> $SessionUUID]},
						{"A1", Object[Container, Bag, "MeasureMeltingPointing test capillary bag " <> $SessionUUID]},
						{"A1", Object[Container, Bag, "MeasureMeltingPointing test capillary bag " <> $SessionUUID]}
					},
					Name -> {
						"MeasureMeltingPointing Test Capillary 1 " <> $SessionUUID,
						"MeasureMeltingPointing Test Capillary 2 " <> $SessionUUID,
						"MeasureMeltingPointing Test Capillary 3 " <> $SessionUUID
					}
				];

				(*create all models*)
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test Molecule with melting point of 99 Celsius" <> $SessionUUID,
						MeltingPoint -> 99Celsius
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test Molecule with melting point of 152 Celsius" <> $SessionUUID,
						MeltingPoint -> 152Celsius
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test Molecule with melting point of 350 Celsius" <> $SessionUUID,
						MeltingPoint -> 350Celsius
					|>
				}];

				testMoleculeModelPacket = UploadMolecule[
					{
						"InChI=1S/ClH.Na/h1H;/q;+1/p-1",
						PubChem["14778"],
						"InChI=1S/He"
					},
					Name -> {
						"Test NaCl Molecule " <> $SessionUUID,
						"Test CaO Molecule " <> $SessionUUID,
						"Test Helium Molecule " <> $SessionUUID
					},
					BiosafetyLevel -> {"BSL-1", "BSL-1", "BSL-1"},
					IncompatibleMaterials -> {{None}, {None}, {None}},
					MSDSRequired -> {False, False, False},
					State -> {Solid, Solid, Gas},
					CAS -> Null
				];

				sampleModelPacket99C = UploadSampleModel["Test solid sample 99C " <> $SessionUUID,
					Composition -> {
						{100 MassPercent, Model[Molecule, "Test Molecule with melting point of 99 Celsius" <> $SessionUUID]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				sampleModelPacket350C = UploadSampleModel["Test solid sample 350C " <> $SessionUUID,
					Composition -> {
						{100 MassPercent, Model[Molecule, "Test Molecule with melting point of 350 Celsius" <> $SessionUUID]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				multipleComponentSampleModelPacket = UploadSampleModel["Test solid sample with 3 components " <> $SessionUUID,
					Composition -> {
						{10 MassPercent, Model[Molecule, "Test Molecule with melting point of 350 Celsius" <> $SessionUUID]},
						{89 MassPercent, Model[Molecule, "Test Molecule with melting point of 152 Celsius" <> $SessionUUID]},
						{1 MassPercent, Model[Molecule, "Test Molecule with melting point of 99 Celsius" <> $SessionUUID]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				solidSampleModelPacket = UploadSampleModel["Test solid sample 1 " <> $SessionUUID,
					Composition -> {
						{100 MassPercent, Model[Molecule, "Test NaCl Molecule " <> $SessionUUID]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				desiccantModelPacket = UploadSampleModel["Test Indicating Drierite For ExperimentMeasureMeltingPoint Tests " <> $SessionUUID,
					Composition -> {
						{100 MassPercent, Model[Molecule, "Test CaO Molecule " <> $SessionUUID]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				gasModelPacket = UploadSampleModel["Test gas sample 1 " <> $SessionUUID,
					Composition -> {
						{100 MassPercent, Model[Molecule, "Test Helium Molecule " <> $SessionUUID]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Gas,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				noStateSampleModelPacket = UploadSampleModel["Test no-state sample 1 " <> $SessionUUID,
					Composition -> {
						{100 MassPercent, Model[Molecule, "Test NaCl Molecule " <> $SessionUUID]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Gas,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				noStorageConditionModelPacket = UploadSampleModel["Test no-StorageCondition sample 1 " <> $SessionUUID,
					Composition -> {
						{100 MassPercent, Model[Molecule, "Test NaCl Molecule " <> $SessionUUID]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				liquidSampleModelPacket = UploadSampleModel["Test liquid sample 1 " <> $SessionUUID,
					Composition -> {
						{100 VolumePercent, Model[Molecule, "Water"]}
					},
					MSDSRequired -> False,
					DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
					Flammable -> False,
					Acid -> False,
					Base -> False,
					Pyrophoric -> False,
					NFPA -> {0, 0, 0, Null},
					DOTHazardClass -> "Class 0",
					IncompatibleMaterials -> {None},
					Expires -> False,
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Upload -> False
				];

				(* Upload all models *)
				Upload[Join[multipleComponentSampleModelPacket, sampleModelPacket350C, sampleModelPacket99C, solidSampleModelPacket, desiccantModelPacket, gasModelPacket, noStateSampleModelPacket, liquidSampleModelPacket, noStorageConditionModelPacket]];

				(* Remove fields form sample models if needed *)
				Upload[
					{
						<|Object -> Model[Sample, "Test no-state sample 1 " <> $SessionUUID], State -> Null|>
					}
				];

				testSampleModels = Flatten@{
					(*1*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*2*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*3*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*4*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*5*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*6*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*7*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*8*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*9*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*10*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*11*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*12*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*13*)Model[Sample, "Test Indicating Drierite For ExperimentMeasureMeltingPoint Tests " <> $SessionUUID],
					(*14*)Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
					(*15*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*16*)Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
					(*17*)Model[Sample, "Test solid sample 99C " <> $SessionUUID],
					(*18*)Model[Sample, "Test solid sample 350C " <> $SessionUUID],
					(*19*)Model[Sample, "Test solid sample with 3 components " <> $SessionUUID],
					(*20*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*21*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*22*)Model[Sample, "Test solid sample 1 " <> $SessionUUID],
					(*23*)Model[Sample, "Test solid sample 1 " <> $SessionUUID]
				};

				testSampleLocations = {
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 1 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 2 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 3 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 4 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 5 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 6 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 7 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 8 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 9 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 10 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 11 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 12 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 13 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 14 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 15 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 16 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 17 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 18 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 19 " <> $SessionUUID]},
					{"A1", Object[Container, Vessel, "MeasureMeltingPointing test container 20 " <> $SessionUUID]},
					{"A1", Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 1 " <> $SessionUUID]},
					{"A1", Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 2 " <> $SessionUUID]},
					{"A1", Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 3 " <> $SessionUUID]}
				};

				testSampleAmounts = Flatten@{
					(*1*)250 Gram,
					(*2*)1.25 Gram,
					(*3*)1.25 Gram,
					(*4*)2 Gram,
					(*5*)2 Gram,
					(*6*)2 Gram,
					(*7*)2 Gram,
					(*8*)2 Gram,
					(*9*)2 Gram,
					(*10*)2 Gram,
					(*11*)2 Gram,
					(*12*)2 Gram,
					(*13*)10000.95 Gram,
					(*14*)10 Milliliter,
					(*15*)Null,
					(*16*)Null,
					(*17*)1.7 Gram,
					(*18*)1.6 Gram,
					(*19*)1.5 Gram,
					(*20*).3 Gram,
					(*21*)5 Milligram,
					(*22*)5 Milligram,
					(*23*)5 Milligram
				};

				testSampleMeltingPoints = Flatten@{
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					331Celsius,
					Null,
					Null,
					Null
				};

				testSampleBoilingPoints = Flatten@{
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					331Celsius,
					Null,
					Null,
					Null
				};

				testSampleNames = Flatten@{
					"MeasureMeltingPoint Test Sample 1 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 2 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 3 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 4 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 5 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 6 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 7 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 8 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 9 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 10 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 11 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 12 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 13 " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 14 Liquid" <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 15 No Mass" <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 16 Liquid No Amount" <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 18 - 350 Celsius " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 19 - Multi-Component " <> $SessionUUID,
					"MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID,
					"MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID,
					"MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID,
					"MeasureMeltingPoint Test Capillary Sample 3 " <> $SessionUUID
				};


				(* create some samples in the above containers*)
				createdSamples1 = ECL`InternalUpload`UploadSample[
					testSampleModels,
					testSampleLocations,
					InitialAmount -> testSampleAmounts,
					Name -> testSampleNames,
					StorageCondition -> AmbientStorage,
					FastTrack -> True
				];

				Upload[Flatten@{
					MapThread[<|Object -> #1, MeltingPoint -> #2|>&, {createdSamples1, testSampleMeltingPoints}],
					<|Object -> Object[Sample, "MeasureMeltingPoint Test Sample 13 " <> $SessionUUID], DeveloperObject -> False|>,
					(* Upload a test protocol object for the Template option *)
					<|
						Type -> Object[Protocol, MeasureMeltingPoint],
						Name -> "Test MeasureMeltingPoint option template protocol" <> $SessionUUID,
						ResolvedOptions -> {ExpectedMeltingPoint -> 100Celsius}
					|>
				}];
			]
		]
	),
	SymbolTearDown :> {
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::SimilarMolecules];
			On[Warning::SampleMustBeMoved];
			On[Warning::DeprecatedProduct];

			(* list of test objects*)
			allObjects = Cases[Flatten[{
				$CreatedObjects,
				Object[Container, Bench, "Test Bench for ExperimentMeasureMelting" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 1 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 2 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 3 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 4 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 5 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 6 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 7 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 8 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 9 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 10 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 11 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 12 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 13 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 14 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 15 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 16 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 17 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 18 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 19 " <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPointing test container 20 " <> $SessionUUID],
				Object[Container, Bag, "MeasureMeltingPointing test capillary bag " <> $SessionUUID],
				Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 1 " <> $SessionUUID],
				Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 2 " <> $SessionUUID],
				Object[Container, Capillary, "MeasureMeltingPointing Test Capillary 3 " <> $SessionUUID],


				(* identity models *)
				Model[Molecule, "Test Molecule with melting point of 99 Celsius" <> $SessionUUID],
				Model[Molecule, "Test Molecule with melting point of 152 Celsius" <> $SessionUUID],
				Model[Molecule, "Test Molecule with melting point of 350 Celsius" <> $SessionUUID],
				Model[Molecule, "Test NaCl Molecule " <> $SessionUUID],
				Model[Molecule, "Test CaO Molecule " <> $SessionUUID],
				Model[Molecule, "Test Helium Molecule " <> $SessionUUID],

				(* sample models *)
				Model[Sample, "Test solid sample 1 " <> $SessionUUID],
				Model[Sample, "Test solid sample 99C " <> $SessionUUID],
				Model[Sample, "Test solid sample 350C " <> $SessionUUID],
				Model[Sample, "Test solid sample with 3 components " <> $SessionUUID],
				Model[Sample, "Test liquid sample 1 " <> $SessionUUID],
				Model[Sample, "Test no-state sample 1 " <> $SessionUUID],
				Model[Sample, "Test no-StorageCondition sample 1 " <> $SessionUUID],
				Model[Sample, "Test Indicating Drierite For ExperimentMeasureMeltingPoint Tests " <> $SessionUUID],
				Model[Sample, "Test gas sample 1 " <> $SessionUUID],

				(* sample objects *)
				Object[Sample, "MeasureMeltingPoint Test Sample 1 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 2 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 3 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 4 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 5 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 6 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 7 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 8 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 9 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 10 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 11 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 12 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 13 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 14 Liquid" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 15 No Mass" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 16 Liquid No Amount" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 17 - 99 Celsius " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 18 - 350 Celsius " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 19 - Multi-Component " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample 20 - 331 Celsius " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 1 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 2 " <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Capillary Sample 3 " <> $SessionUUID],

				(* template protocol *)
				Object[Protocol, MeasureMeltingPoint, "Test MeasureMeltingPoint option template protocol" <> $SessionUUID]

			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False]];

			Unset[$CreatedObjects];
		];
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsection::Closed:: *)
(*ExperimentMeasureMeltingPointOptions*)


DefineTests[
	ExperimentMeasureMeltingPointOptions,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentMeasureMeltingPoint call to measure the melting point of a single sample:"},
			ExperimentMeasureMeltingPointOptions[Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentMeasureMeltingPoint call to measure the melting point of a single container:"},
			ExperimentMeasureMeltingPointOptions[Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentMeasureMeltingPoint call to measure the melting point of a sample and a container the same time:"},
			ExperimentMeasureMeltingPointOptions[{
				Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 2" <> $SessionUUID]
			}],
			_Grid
		],

		(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Generate a resolved list of options for an ExperimentMeasureMeltingPoint call to measure the melting point of a single container:"},
			ExperimentMeasureMeltingPointOptions[Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID], OutputFormat -> List],
			_?(MatchQ[
				Check[SafeOptions[ExperimentMeasureMeltingPoint, #], $Failed, {Error::Pattern}],
				{(_Rule | _RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		$CreatedObjects = {};

		Module[{objects},

			(* list of test objects*)
			objects = {
				(* Sample Objects *)
				Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 2" <> $SessionUUID],

				(* Container Objects *)
				Object[Container, Bench, "Test Bench for ExperimentMeasureMeltingPointOptions" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 2" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force -> True, Verbose -> False]];
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[{testBench},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test Bench for ExperimentMeasureMeltingPointOptions" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				UploadSample[
					{
						Model[Container, Vessel, "2mL tube with no skirt"],
						Model[Container, Vessel, "2mL tube with no skirt"]
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID,
						"MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 2" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Benzoic acid"],
						Model[Sample, "Benzoic acid"]
					},
					{
						{"A1", Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 2" <> $SessionUUID]}
					},
					InitialAmount -> {
						1.3 Gram,
						1.3 Gram
					},
					Name -> {
						"MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID,
						"MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 2" <> $SessionUUID
					}
				];
			];
		];


		(* upload needed objects *)
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		EraseObject[Flatten[{
			$CreatedObjects,

			(* Sample Objects *)
			Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID],
			Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointOptions 2" <> $SessionUUID],

			(* Container Objects *)
			Object[Container, Bench, "Test Bench for ExperimentMeasureMeltingPointOptions" <> $SessionUUID],
			Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 1" <> $SessionUUID],
			Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointOptions 2" <> $SessionUUID]
		}],
			Force -> True, Verbose -> False];
	)
];



(* ::Subsection::Closed:: *)
(*ExperimentMeasureMeltingPointPreview*)


DefineTests[
	ExperimentMeasureMeltingPointPreview,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a preview for an ExperimentMeasureMeltingPoint call to measure the melting point of a single container (will always be Null:"},
			ExperimentMeasureMeltingPointPreview[Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID]],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentMeasureMeltingPoint call to measure the melting point of two containers at the same time:"},
			ExperimentMeasureMeltingPointPreview[{
				Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 2" <> $SessionUUID]
			}],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentMeasureMeltingPoint call to measure the melting point of a single sample:"},
			ExperimentMeasureMeltingPointPreview[Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID]],
			Null
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		$CreatedObjects = {};

		Module[{objects},

			(* list of test objects*)
			objects = {
				(* Sample Objects *)
				Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointPreview 2" <> $SessionUUID],

				(* Container Objects *)
				Object[Container, Bench, "Test Bench for ExperimentMeasureMeltingPointPreview" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 2" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force -> True, Verbose -> False]];
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[{testBench},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test Bench for ExperimentMeasureMeltingPointPreview" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				UploadSample[
					{
						Model[Container, Vessel, "2mL tube with no skirt"],
						Model[Container, Vessel, "2mL tube with no skirt"]
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID,
						"MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 2" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Benzoic acid"],
						Model[Sample, "Benzoic acid"]
					},
					{
						{"A1", Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 2" <> $SessionUUID]}
					},
					InitialAmount -> {
						1.3 Gram,
						1.3 Gram
					},
					Name -> {
						"MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID,
						"MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointPreview 2" <> $SessionUUID
					}
				];
			];
		];


		(* upload needed objects *)
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];

		EraseObject[Flatten[{
			$CreatedObjects,

			(* Sample Objects *)
			Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID],
			Object[Sample, "MeasureMeltingPoint Test Sample for ExperimentMeasureMeltingPointPreview 2" <> $SessionUUID],

			(* Container Objects *)
			Object[Container, Bench, "Test Bench for ExperimentMeasureMeltingPointPreview" <> $SessionUUID],
			Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 1" <> $SessionUUID],
			Object[Container, Vessel, "MeasureMeltingPoint Test Container for ExperimentMeasureMeltingPointPreview 2" <> $SessionUUID]
		}],
			Force -> True, Verbose -> False];
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentMeasureMeltingPointQ*)


DefineTests[
	ValidExperimentMeasureMeltingPointQ,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic, "Validate an ExperimentMeasureMeltingPoint call to measure the melting point of a single container:"},
			ValidExperimentMeasureMeltingPointQ[Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID]],
			True
		],
		Example[
			{Basic, "Validate an ExperimentMeasureMeltingPoint call to MeasureMeltingPoint two containers at the same time:"},
			ValidExperimentMeasureMeltingPointQ[{
				Object[Sample, "MeasureMeltingPoint Test Sample for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 2" <> $SessionUUID]
			}],
			True
		],
		Example[
			{Basic, "Validate an ExperimentMeasureMeltingPoint call to measure the melting point of a single sample:"},
			ValidExperimentMeasureMeltingPointQ[Object[Sample, "MeasureMeltingPoint Test Sample for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID]],
			True
		],

		(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Validate an ExperimentMeasureMeltingPoint call to measure the melting point of a single container, returning an ECL Test Summary:"},
			ValidExperimentMeasureMeltingPointQ[Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[
			{Options, Verbose, "Validate an ExperimentMeasureMeltingPoint call to measure the melting point of a single container, printing a verbose summary of tests as they are run:"},
			ValidExperimentMeasureMeltingPointQ[Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID], Verbose -> True],
			True
		]
	},
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		$CreatedObjects = {};

		Module[{objects},

			(* list of test objects*)
			objects = {
				(* Sample Objects *)
				Object[Sample, "MeasureMeltingPoint Test Sample for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID],
				Object[Sample, "MeasureMeltingPoint Test Sample for ValidExperimentMeasureMeltingPointQ 2" <> $SessionUUID],

				(* Container Objects *)
				Object[Container, Bench, "Test Bench for ValidExperimentMeasureMeltingPointQ" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID],
				Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 2" <> $SessionUUID]
			};

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, DatabaseMemberQ[objects]], Force -> True, Verbose -> False]];
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[{testBench},
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test Bench for ValidExperimentMeasureMeltingPointQ" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				UploadSample[
					{
						Model[Container, Vessel, "2mL tube with no skirt"],
						Model[Container, Vessel, "2mL tube with no skirt"]
					},
					{
						{"Bench Top Slot", testBench},
						{"Bench Top Slot", testBench}
					},
					Name -> {
						"MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID,
						"MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 2" <> $SessionUUID
					}
				];

				UploadSample[
					{
						Model[Sample, "Benzoic acid"],
						Model[Sample, "Benzoic acid"]
					},
					{
						{"A1", Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID]},
						{"A1", Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 2" <> $SessionUUID]}
					},
					InitialAmount -> {
						1.3 Gram,
						1.3 Gram
					},
					Name -> {
						"MeasureMeltingPoint Test Sample for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID,
						"MeasureMeltingPoint Test Sample for ValidExperimentMeasureMeltingPointQ 2" <> $SessionUUID
					}
				];
			];
		];


		(* upload needed objects *)
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];

		EraseObject[Flatten[{
			$CreatedObjects,

			(* Sample Objects *)
			Object[Sample, "MeasureMeltingPoint Test Sample for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID],
			Object[Sample, "MeasureMeltingPoint Test Sample for ValidExperimentMeasureMeltingPointQ 2" <> $SessionUUID],

			(* Container Objects *)
			Object[Container, Bench, "Test Bench for ValidExperimentMeasureMeltingPointQ" <> $SessionUUID],
			Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 1" <> $SessionUUID],
			Object[Container, Vessel, "MeasureMeltingPoint Test Container for ValidExperimentMeasureMeltingPointQ 2" <> $SessionUUID]
		}],
			Force -> True, Verbose -> False];
	)
];

(* ::Section:: *)
(*End Test Package*)
