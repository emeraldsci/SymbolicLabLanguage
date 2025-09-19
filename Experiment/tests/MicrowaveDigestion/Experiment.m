(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMicrowaveDigestion*)


DefineTests[ExperimentMicrowaveDigestion,
	{
		Example[{Basic, "Perform microwave digestion on a single sample:"},
			ExperimentMicrowaveDigestion[
				Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Perform microwave digestion on multiple samples:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 3"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Perform microwave digestion on a prepared sample:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Prepared Test Liquid"<>$SessionUUID]
				},
				PreparedSample -> True
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Perform microwave digestion and dilute the outputs to a specified volume:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DiluteOutputAliquot -> True,
				OutputAliquot -> 2 Milliliter,
				TargetDilutionVolume -> 50 Milliliter
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],


		(* ============= *)
		(* == OPTIONS == *)
		(* ============= *)
		
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentMicrowaveDigestion[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]]
		],
		(* -- Aliquoting Options -- *)


		Example[{Options, AliquotSampleLabel, "Set the AliquotSampleLabel option:"},
			options = ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], Aliquot -> True,AliquotSampleLabel -> "Water Aliquot", Output -> Options];
			Lookup[options, AliquotSampleLabel],
			{"Water Aliquot"},
			Variables :> {options}
		],

		(* -- SampleType -- *)

		Example[{Options, SampleType, "Automatically resolve the SampleType based on the input object:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]},
				Output -> Options
			];
			Lookup[options, SampleType],
			{Organic, Organic, Tablet},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, SampleType, "Specify the SampleType to dictate digestion temperature and pressure venting resolution:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]},
				SampleType -> {Inorganic, Organic, Tablet},
				Output -> Options
			];
			Lookup[options, SampleType],
			{Inorganic, Organic, Tablet},
			Variables :> {options},
			Messages :> {}
		],

		(* -- Instrument --*)
		Example[{Options, Instrument, "Specify the Instrument used to digest samples via microwave irradiation:"},
			options=ExperimentMicrowaveDigestion[
				Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID],
				Instrument -> Object[Instrument, Reactor, Microwave, "Test instrument for MicrowaveDigestion tests"<>$SessionUUID],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Object[Instrument, Reactor, Microwave, "Test instrument for MicrowaveDigestion tests"<>$SessionUUID]],
			Variables :> {options},
			Messages :> {}
		],

		(* -- SampleAmount -- *)
		Example[{Options, SampleAmount, "Automatically resolve the SampleAmount based on the input object:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]},
				Output -> Options
			];
			Lookup[options, SampleAmount],
			{100 Milligram, 100 Microliter, 100 Milligram},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, SampleAmount, "Specify the SampleAmount to dictate volume or mass of the sample to be digested:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]},
				SampleAmount -> {200 Milligram, 200 Microliter, 200 Milligram},
				Output -> Options
			];
			Lookup[options, SampleAmount],
			{200 Milligram, 200 Microliter, 200 Milligram},
			Variables :> {options},
			Messages :> {}
		],


		(* -- CrushSample -- *)
		Example[{Options, CrushSample, "Set CrushSample to indicate if the sample is a tablet that is crushed prior to digestion:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]},
				CrushSample -> True,
				Output -> Options
			];
			Lookup[options, CrushSample],
			True,
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, CrushSample, "Automatically resolve the CrushSample option based on the properties of the input sample:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]},
				Output -> Options
			];
			Lookup[options, CrushSample],
			{False, True},
			Variables :> {options},
			Messages :> {}
		],

		(* -- PreDigestionMix -- *)
		Example[{Options, PreDigestionMix, "Set PreDigestionMix to stir the reaction mixture at ambient conditions prior to microwave heating:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				PreDigestionMix -> True,
				Output -> Options
			];
			Lookup[options, PreDigestionMix],
			True,
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, PreDigestionMix, "Automatically resolve PreDigestionMix based on the state of the input sample:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]},
				PreDigestionMix -> Automatic,
				PreDigestionMixTime -> {Automatic, Null, Automatic},
				PreDigestionMixRate -> {Automatic, Null, Automatic},
				Output -> Options
			];
			Lookup[options, PreDigestionMix],
			{True, False, True},
			Variables :> {options},
			Messages :> {}
		],


		(* -- PreDigestionMixTime -- *)
		Example[{Options, PreDigestionMixTime, "Automatically resolve the PreDigestionMixTime based on PreDigestionMix:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID]},
				PreDigestionMix -> {True, False},
				Output -> Options
			];
			Lookup[options, PreDigestionMixTime],
			{2 Minute, Null},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, PreDigestionMixTime, "Set the amount of time that the reaction mixture will stir at ambient conditions prior to microwave heating:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				PreDigestionMixTime -> 1 Minute,
				Output -> Options
			];
			Lookup[options, PreDigestionMixTime],
			1 Minute,
			Variables :> {options},
			Messages :> {}
		],

		(* -- PreDigestionMixRate -- *)
		Example[{Options, PreDigestionMixRate, "Automatically resolve the PreDigestionMixRate based on PreDigestionMix:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID]},
				PreDigestionMix -> {True, False},
				Output -> Options
			];
			Lookup[options, PreDigestionMixRate],
			{Medium, Null},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, PreDigestionMixRate, "Set the mixing rate at which the reaction mixture will stir at ambient conditions prior to microwave heating:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				PreDigestionMixRate -> High,
				Output -> Options
			];
			Lookup[options, PreDigestionMixRate],
			High,
			Variables :> {options},
			Messages :> {}
		],


		(* -- PreparedSample -- *)
		Example[{Options, PreparedSample, "Automatically determine if the sample already contains digestion agent based on composition and volume:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Prepared Test Liquid"<>$SessionUUID]},
				SampleAmount -> {Automatic, 5 Milliliter},
				Output -> Options
			];
			Lookup[options, PreparedSample],
			{False, True},
			Variables :> {options},
			Messages :> {
				Warning::MicrowaveDigestionPossiblePreparedSample
			}
		],
		Example[{Options, PreparedSample, "Set the PreparedSample option to indicate that the sample already contains digestion agent(s):"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Prepared Test Liquid"<>$SessionUUID]},
				PreparedSample -> True,
				SampleAmount -> 5 Milliliter,
				Output -> Options
			];
			Lookup[options, PreparedSample],
			True,
			Variables :> {options},
			Messages :> {}
		],


		(* -- DigestionAgents -- *)
		Example[{Options, DigestionAgents, "Set DigestionAgents to specify the identity and quantity of the reagents used to perform the digestion:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				DigestionAgents -> {{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], 10 Milliliter}},
				Output -> Options
			];
			Lookup[options, DigestionAgents],
			{{ObjectP[Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"]], EqualP[10 Milliliter]}},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, DigestionAgents, "Automatically determine if DigestionAgents are required based on the PreparedSample option:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Prepared Test Liquid"<>$SessionUUID]},
				SampleAmount -> 5 Milliliter,
				PreparedSample -> True,
				Output -> Options
			];
			Lookup[options, DigestionAgents],
			Null,
			Variables :> {options},
			Messages :> {}
		],


		(* ----------------------- *)
		(* -- DIGESTION OPTIONS -- *)
		(* ----------------------- *)

		(* -- DigestionTemperature -- *)
		Example[{Options, DigestionTemperature, "Automatically set the DigestionTemperature based on the SampleType when no DigestionTemperatureProfile is specified:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]},
				SampleType -> {Organic, Inorganic},
				DigestionTemperatureProfile -> Null,
				Output -> Options
			];
			Lookup[options, DigestionTemperature],
			{200 Celsius, 300 Celsius},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, DigestionTemperature, "Set the DigestionTempearture to indicate the temperature to which the reaction vessel will be heated for DigestionDuration:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				DigestionTemperature -> 300 Celsius,
				Output -> Options
			];
			Lookup[options, DigestionTemperature],
			300 Celsius,
			Variables :> {options},
			Messages :> {}
		],


		(* -- DigestionDuration -- *)
		Example[{Options, DigestionDuration, "Automatically set the DigestionDuration when no DigestionTemperatureProfile is specified:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]},
				SampleType -> {Organic, Inorganic},
				DigestionTemperatureProfile -> Null,
				Output -> Options
			];
			Lookup[options, DigestionDuration],
			10 Minute,
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, DigestionDuration, "Set the DigestionDuration to indicate the length of time that the reaction vessel is heated at the DigestionTemperature:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				DigestionDuration -> 3 Minute,
				Output -> Options
			];
			Lookup[options, DigestionDuration],
			3 Minute,
			Variables :> {options},
			Messages :> {}
		],

		(* -- DigestionRampDuration -- *)
		Example[{Options, DigestionRampDuration, "Automatically resolve the DigestionRampDuration based on the DigestionTemperature when no DigestionTemperatureProfile is specified:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]},
				DigestionTemperatureProfile -> Null,
				DigestionTemperature -> {100 Celsius, 200 Celsius},
				Output -> Options
			];
			Lookup[options, DigestionRampDuration],
			{2 Minute, EqualP[4.5 Minute]},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, DigestionRampDuration, "Set the DigestionRampDuration to control the rate at which the reaction vessel is heated to the DigestionTemperature:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				DigestionTemperature -> 200 Celsius,
				DigestionRampDuration -> 10 Minute,
				Output -> Options
			];
			Lookup[options, DigestionRampDuration],
			10 Minute,
			Variables :> {options},
			Messages :> {}
		],


		(* -- DigestionTemperatureProfile -- *)
		Example[{Options, DigestionTemperatureProfile, "Automatically resolve the program for microwave heating based on SampleType:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]},
				SampleType -> {Organic, Inorganic},
				DigestionTemperature -> Null,
				DigestionDuration -> Null,
				DigestionRampDuration -> Null,
				Output -> Options
			];
			Lookup[options, DigestionTemperatureProfile],
			{
				{{4.5 Minute, 200 Celsius}, {14.5 Minute, 200 Celsius}},
				{{7 Minute, 300 Celsius}, {17 Minute, 300 Celsius}}
			},
			EquivalenceFunction -> MatchQ,
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, DigestionTemperatureProfile, "Set the heating profile for the digestion:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				DigestionTemperatureProfile -> {{10 Minute, 200 Celsius}, {20 Minute, 250 Celsius}},
				Output -> Options
			];
			Lookup[options, DigestionTemperatureProfile],
			{{600 Second, 200 Celsius}, {1200 Second, 250 Celsius}},
			Variables :> {options},
			Messages :> {}
		],


		(* -- DigestionMixRateProfile -- *)
		Example[{Options, DigestionMixRateProfile, "Set the mixing profile for the digestion:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				DigestionMixRateProfile -> {{10 Minute, Low}, {20 Minute, High}},
				DigestionTemperatureProfile -> {{10 Minute, 100 Celsius}, {20 Minute, 200 Celsius}},
				Output -> Options
			];
			Lookup[options, DigestionMixRateProfile],
			{{EqualP[600 Second], Low}, {EqualP[1200 Second], High}},
			Variables :> {options},
			Messages :> {}
		],


		(* -- DigestionMaxPressure -- *)
		Example[{Options, DigestionMaxPressure, "Set the pressure at which the reaction vessel will cease to heat:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				DigestionMaxPressure -> 300 PSI,
				Output -> Options
			];
			Lookup[options, DigestionMaxPressure],
			300 PSI,
			Variables :> {options},
			Messages :> {}
		],


		(* -- DigestionMaxPower -- *)
		Example[{Options, DigestionMaxPower, "Automatically resolve the maximum power of microwave irradaition that will be used based on SampleType:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]},
				SampleType -> {Organic, Inorganic, Tablet},
				Output -> Options
			];
			Lookup[options, DigestionMaxPower],
			{200 Watt, 300 Watt, 300 Watt},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, DigestionMaxPower, "Set the maximum power of microwave irradiation that will be used to heat the reaction vessel:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				DigestionMaxPower -> 300 Watt,
				Output -> Options
			];
			Lookup[options, DigestionMaxPower],
			300 Watt,
			Variables :> {options},
			Messages :> {}
		],


		(* ------------- *)
		(* -- VENTING -- *)
		(* ------------- *)


		(* -- PressureVenting -- *)
		Example[{Options, PressureVenting, "Automatically resolve the pressure venting switch based on the venting parameters or the SampleType:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Solid 3"<>$SessionUUID]},
				SampleType -> {Inorganic, Inorganic, Organic},
				PressureVentingTriggers -> {Automatic, Null, Automatic},
				TargetPressureReduction -> {Automatic, Null, Automatic},
				Output -> Options
			];
			Lookup[options, PressureVenting],
			{True, False, True},
			Variables :> {options},
			Messages :> {
				Warning::MicrowaveDigestionMissingRecommendedVenting
			}
		],
		Example[{Options, PressureVenting, "Set the pressure venting to True to allow the reaction vessel to vent according to PressureVentingTriggers during the digestion:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				Output -> Options
			];
			Lookup[options, PressureVenting],
			True,
			Variables :> {options},
			Messages :> {}
		],


		(* -- TargetPressureReduction -- *)
		Example[{Options, TargetPressureReduction, "Automatically resolve the expected drop in pressure upon venting based on the SampleType when PressureVenting is True:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 2"<>$SessionUUID]
				},
				SampleType -> {Organic, Inorganic, Tablet, Tablet},
				PressureVenting -> {True, True, True, False},
				Output -> Options
			];
			Lookup[options, TargetPressureReduction],
			{25 PSI, 40 PSI, 25 PSI, Null},
			Variables :> {options},
			Messages :> {
				Warning::MicrowaveDigestionMissingRecommendedVenting
			}
		],
		Example[{Options, TargetPressureReduction, "Set the pressure differential that the instrument will try to achieve at each venting trigger:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				TargetPressureReduction -> 20 PSI,
				Output -> Options
			];
			Lookup[options, TargetPressureReduction],
			20 PSI,
			Variables :> {options},
			Messages :> {}
		],


		(* -- PressureVentingTriggers -- *)
		Example[{Options, PressureVentingTriggers, "Automatically resolve the pressure venting triggers based on the SampleType when PressureVenting is True:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 2"<>$SessionUUID]
				},
				SampleType -> {Organic, Inorganic, Tablet, Tablet},
				PressureVenting -> {True, True, True, False},
				Output -> Options
			];
			Lookup[options, PressureVentingTriggers],
			{
				{{50 PSI, 2}, {225 PSI, 2}, {250 PSI, 2}, {275 PSI, 2}, {300 PSI, 2}, {350 PSI, 100}},
				{{50 PSI, 2}, {400 PSI, 100}},
				{{50 PSI, 2}, {225 PSI, 2}, {250 PSI, 2}, {275 PSI, 2}, {300 PSI, 2}, {350 PSI, 100}},
				Null
			},
			Variables :> {options},
			Messages :> {
				Warning::MicrowaveDigestionMissingRecommendedVenting
			}
		],
		Example[{Options, PressureVentingTriggers, "Set the pressures that will trigger venting, and the number of attempts that the instrument will make to achieve the TargetPressureRduction a each trigger pressure:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				PressureVentingTriggers -> {{50 PSI, 2}, {100 PSI, 2}, {200 PSI, 2}, {300 PSI, 100}},
				Output -> Options
			];
			Lookup[options, PressureVentingTriggers],
			{{50 PSI, 2}, {100 PSI, 2}, {200 PSI, 2}, {300 PSI, 100}},
			Variables :> {options},
			Messages :> {}
		],

		(* ------------ *)
		(* -- WORKUP -- *)
		(* ------------ *)

		(* -- DiluteOutputAliquot -- *)
		Example[{Options, DiluteOutputAliquot, "Specify if an aliquot of the reaction mixture is diluted with a Diluent after digestion:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]
				},
				DiluteOutputAliquot -> {True, False},
				Output -> Options
			];
			Lookup[options, DiluteOutputAliquot],
			{True, False},
			Variables :> {options},
			Messages :> {}
		],

		(* -- Diluent -- *)
		Example[{Options, Diluent, "Automatically choose a diluent when DiluteOutputApliquot is True:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]
				},
				DiluteOutputAliquot -> {True, False},
				Output -> Options
			];
			Lookup[options, Diluent],
			{ObjectP[Model[Sample, "Milli-Q water"]], Null},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, Diluent, "Specify the solvent used to perform dilution of the OutputAliquot:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				Diluent -> Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options, Diluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Messages :> {}
		],

		(* -- DiluentVolume -- *)
		Example[{Options, DiluentVolume, "Automatically dilute the sample 5-fold when DiluteOutputAliquot is True:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]
				},
				DiluteOutputAliquot -> {True, False},
				Output -> Options
			];
			Lookup[options, DilutionFactor],
			{5, Null},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, DiluentVolume, "Specify the amount of diluent to be used either by the volume or the desired dilution factor:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]
				},
				DiluentVolume -> {10 Milliliter, Null},
				DilutionFactor -> {Null, 10},
				Output -> Options
			];
			Lookup[options, {DiluentVolume, DilutionFactor}],
			{{10 Milliliter, Null}, {Null, 10}},
			Variables :> {options},
			Messages :> {}
		],

		(* -- TargetDilutionVolume -- *)
		Example[{Options, TargetDilutionVolume, "Specify the volume to which the OutputAliquot should be diluted with the Diluent:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				TargetDilutionVolume -> 50 Milliliter,
				Output -> Options
			];
			Lookup[options, TargetDilutionVolume],
			50 Milliliter,
			Variables :> {options},
			Messages :> {}
		],

		(* -- OutputAliquot -- *)
		Example[{Options, OutputAliquot, "Automatically determine the amount of the reaction mixture that will be aliquotted out for dilution or as the output of the experiment:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 3"<>$SessionUUID]
				},
				DiluteOutputAliquot -> {True, True, False},
				DiluentVolume -> {20 Milliliter, Null, Null},
				DilutionFactor -> {Null, 100, Null},
				Output -> Options
			];
			Lookup[options, OutputAliquot],
			{All, EqualP[10 Milliliter], EqualP[1 Milliliter]},
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, OutputAliquot, "Specify the volume of reaction mixture that will be used for dilution or stored as the output of this experiment:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID], Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]},
				OutputAliquot -> {All, 1 Milliliter},
				Output -> Options
			];
			Lookup[options, OutputAliquot],
			{All, 1 Milliliter},
			Variables :> {options},
			Messages :> {}
		],


		(* -- ContainerOut -- *)
		Example[{Options, ContainerOut, "Automatically select an appropriate output container for the volume and chemical compatibility of the sample:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				Output -> Options
			];
			Lookup[options, ContainerOut],
			ObjectP[Model[Container]],
			Variables :> {options},
			Messages :> {}
		],
		Example[{Options, ContainerOut, "Specify a particular container of appropriate capacity and chemical compatibility:"},
			options=ExperimentMicrowaveDigestion[
				{Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]},
				ContainerOut -> Model[Container, Vessel, "250mL Amber Glass Bottle"],
				OutputAliquot -> 1 Milliliter,
				Output -> Options
			];
			Lookup[options, ContainerOut],
			ObjectP[Model[Container, Vessel, "250mL Amber Glass Bottle"]],
			Variables :> {options},
			Messages :> {}
		],


		(* ------------------- *)
		(* --  SHARED TESTS -- *)
		(* ------------------- *)

		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESN'T BUG ON THIS. *)
		Example[{Additional, "Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], Incubate -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True, Output -> Options];
			{Lookup[options, Incubate], Lookup[options, Centrifuge], Lookup[options, Filtration], Lookup[options, Aliquot]},
			{True, True, True, True},
			Variables :> {options}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], IncubationTemperature -> 40 * Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], IncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], MaxIncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], AnnealingTime -> 40 * Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], IncubateAliquot -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], CentrifugeIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], CentrifugeTime -> 5 * Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], CentrifugeTemperature -> 10 * Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], CentrifugeAliquot -> 0.5 * Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			0.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 * Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], PrefilterPoreSize -> 1. * Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1. * Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20 * Minute, Output -> Options];
			Lookup[options, FilterTime],
			20 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10 * Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FilterAliquot -> 0.4 * Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			0.4 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], AliquotAmount -> 0.28 Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.28 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], AliquotAmount -> 0.28 * Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.28 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], AssayVolume -> 0.28 * Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.28 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
				TargetConcentration -> 0.5 * Millimolar,
				Output -> Options];
			Lookup[options, TargetConcentration],
			0.5 * Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 0.1 Milliliter,
				AssayVolume -> 0.3 Milliliter,
				Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
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
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
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
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 0.1 Milliliter,
				AssayVolume -> 0.3 Milliliter,
				Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], AliquotContainer -> Model[Container, Plate, "id:kEJ9mqR3XELE"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "id:kEJ9mqR3XELE"]]}},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], MeasureVolume -> True],
				MeasureVolume
			],
			True
		],
		Example[{Options, MeasureWeight, "Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], MeasureWeight -> True],
				MeasureWeight
			],
			True
		],
		Example[{Options, SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],

		Example[{Options, Template, "Use a previous MicrowaveDigestion protocol as a template for a new one:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
				Template -> Object[Protocol, MicrowaveDigestion, "Parent Protocol for Template ExperimentMicrowaveDigestion tests"<>$SessionUUID],
				Output -> Options];
			Lookup[options, Template],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			Variables :> {options}
		],
		Example[{Options, Name, "Specify the Name of the created MicrowaveDigestion object:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], Name -> "My special MicrowaveDigestion object name", Output -> Options];
			Lookup[options, Name],
			"My special MicrowaveDigestion object name",
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], IncubateAliquotDestinationWell -> "A1", AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], TargetConcentration -> 1 * Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Sodium Chloride"], AssayVolume -> 1 * Milliliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Sodium Chloride"]],
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, SamplesOutStorageCondition, "Indicates how the output samples of the experiment should be stored:"},
			options=ExperimentMicrowaveDigestion[Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID], SamplesOutStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, SamplesOutStorageCondition],
			Refrigerator,
			Variables :> {options}
		],

		(* --- Sample Prep unit tests --- *)
		(*TODO: add more here to include dissolvign samples*)
		Example[{Options, PreparatoryUnitOperations, "Specify prepared samples to be digested under microwave conditions:"},
			options=ExperimentMicrowaveDigestion["test container",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "test container",
						Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"]
					],
					Transfer[
						Source -> Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
						Amount -> 500 * Microliter,
						Destination -> {"A1", "test container"}
					]
				},
				Output -> Options
			];
			Lookup[options, SampleType],
			Organic,
			Variables :> {options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentMicrowaveDigestion[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				PreparedModelAmount -> 20 Milliliter,
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
				{ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]..},
				{EqualP[20 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],

		(* ============== *)
		(* == MESSAGES == *)
		(* ============== *)

		(* -------------------------------- *)
		(* -- Instrument Incompatibility -- *)
		(* -------------------------------- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMicrowaveDigestion[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMicrowaveDigestion[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMicrowaveDigestion[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMicrowaveDigestion[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
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
					InitialAmount -> 20 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentMicrowaveDigestion[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
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
					InitialAmount -> 20 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentMicrowaveDigestion[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		(* -- wrong instrument type -- *)
		Example[{Messages, "MicrowaveDigestionInvalidInstrument", "If the provided instrument cannot perform digestion, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID],
				Instrument -> Model[Instrument, Reactor, Microwave, "Bad instrument for MicrowaveDigestion"<>$SessionUUID]
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionInvalidInstrument, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- insufficient samples total volume for reaction -- *)
		Example[{Messages, "InsufficientPreparedMicrowaveDigestionSample", "If PreparedSample->True and SampleAmount is less than 5 Milliliters, an warning is displayed:"},
			ExperimentMicrowaveDigestion[
				Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID],
				PreparedSample->True,
				SampleAmount->1*Milliliter
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			Messages :> {Warning::InsufficientPreparedMicrowaveDigestionSample},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "InsufficientPreparedMicrowaveDigestionSample", "If total volume of SampleAmount and DigestionAgents is less than 5 Milliliters, an error is thrown:"},
			ExperimentMicrowaveDigestion[
				Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID],
				SampleAmount -> 1*Milliliter,
				DigestionAgents -> {{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], 3 Milliliter}}
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			Messages :> {Warning::InsufficientPreparedMicrowaveDigestionSample},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ---------------------------- *)
		(* -- Errors for sample prep -- *)
		(* ---------------------------- *)

		(* -- Banned acids in composition -- *)
		Example[{Messages, "MicrowaveDigestionBannedAcids", "If the sample contains HF or HClO4, an error will be thrown as these acids are not currently supported for this experiment:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Liquid 4 HF"<>$SessionUUID]
				},
				PreparedSample -> True
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionBannedAcids, Error::InvalidInput},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Too many samples -- *)
		Example[{Messages, "MicrowaveDigestionTooManySamples", "If more samples are specified than can be run on this instrument, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				ConstantArray[Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID], 26]
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionTooManySamples, Error::InvalidInput},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],


		(* -- Errors for SampleType -- *)
		Example[{Messages, "MicrowaveDigestionComputedSampleTypeMisMatch", "If the physical state and composition of a sample is in conflict with the specified SampleType, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				SampleType -> Tablet
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionComputedSampleTypeMisMatch, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for SampleAmount -- *)
		Example[{Messages, "MicrowaveDigestionNotEnoughSample", "If the physical amount of a sample is less than the SampleAmount, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID]
				},
				SampleAmount -> 19.9 Milliliter
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionNotEnoughSample, Error::InvalidInput},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for CrushSample -- *)
		Example[{Messages, "MicrowaveDigestionSampleCannotBeCrushed", "If CrushSample -> True for a non tablet sample, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				CrushSample -> True
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionSampleCannotBeCrushed, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Warnings for CrushSample -- *)
		Example[{Messages, "MicrowaveDigestionUncrushedTablet", "If CrushSample -> False when SampleType -> Tablet, a warning message will be displayed:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID]
				},
				CrushSample -> False
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			Messages :> {Warning::MicrowaveDigestionUncrushedTablet},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Errors for PreDigestionMix -- *)
		Example[{Messages, "MicrowaveDigestionNoPreDigestionMix", "If PreDigestionMix -> False for a solid sample, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PreDigestionMix -> False
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionNoPreDigestionMix, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Errors for PreDigestionMixTime -- *)
		Example[{Messages, "MicrowaveDigestionMissingPreDigestionMixTime", "If PreDigestionMixTime is specified when PreDigestionMix -> False, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID]
				},
				PreDigestionMix -> True,
				PreDigestionMixTime -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingPreDigestionMixTime, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionUnusedPreDigestionMixTime", "If PreDigestionMixTime -> Null when PreDigestionMix -> True, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID]
				},
				PreDigestionMixTime -> 1 Minute,
				PreDigestionMix -> False
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionUnusedPreDigestionMixTime, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Errors for PreDigestionMixRate -- *)
		Example[{Messages, "MicrowaveDigestionMissingPreDigestionMixRate", "If PreDigestionMixRate -> Null when PreDigestionMix -> True, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID]
				},
				PreDigestionMix -> True,
				PreDigestionMixRate -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingPreDigestionMixRate, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionUnusedPreDigestionMixRate", "If PreDigestionMixRate is specified when PreDigestionMix -> False, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID]
				},
				PreDigestionMixRate -> High,
				PreDigestionMix -> False
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionUnusedPreDigestionMixRate, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* --------------------------------- *)
		(* -- ERRORS for digestion agents -- *)
		(* --------------------------------- *)

		(* -- Errors for DigestionAgents -- *)
		Example[{Messages, "MicrowaveDigestionNoDigestionAgent", "If the sample is not prepared and does not have DigestionAgents, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID]
				},
				PreparedSample -> False,
				DigestionAgents -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionNoDigestionAgent, Error::MicrowaveDigestionMissingDigestionAgent, Warning::InsufficientPreparedMicrowaveDigestionSample, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionNoSolvent", "If a sample is designated as a PreparedSample but does not have solvent, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PreparedSample -> True,
				DigestionAgents -> Null
			],
			$Failed,
			Messages :> {Warning::InsufficientPreparedMicrowaveDigestionSample, Error::MicrowaveDigestionNoSolvent, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for PreparedSample -- *)
		Example[{Messages, "MicrowaveDigestionPossiblePreparedSample", "If PreparedSample -> Automatic and contains common digestion agents in its composition, an warning message will be displayed:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Prepared Test Liquid"<>$SessionUUID]
				},
				PreparedSample -> Automatic
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			Messages :> {Warning::MicrowaveDigestionPossiblePreparedSample},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for DigestionAgents -- *)
		Example[{Messages, "MicrowaveDigestionMissingDigestionAgent", "If PreparedSample -> False and no DigestionAgents are specified, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PreparedSample -> False,
				DigestionAgents -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingDigestionAgent, Error::MicrowaveDigestionNoDigestionAgent, Warning::InsufficientPreparedMicrowaveDigestionSample, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionUnusedDigestionAgent", "If PreparedSample -> True and DigestionAgents is not Null, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PreparedSample -> True,
				DigestionAgents -> {{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], 10 Milliliter}}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionUnusedDigestionAgent, Error::MicrowaveDigestionNoSolvent, Warning::InsufficientPreparedMicrowaveDigestionSample, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(*TODO: also add an example where the sample is itself aqua regia*)
		Example[{Messages, "MicrowaveDigestionAquaRegiaGeneration", "If the composition of the DigestionAgents forms aqua regia, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionAgents -> {
					{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], 6 Milliliter},
					{Model[Sample, "Hydrochloric Acid 37%, (TraceMetal Grade)"], 2 Milliliter}
				}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionAquaRegiaGeneration, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],


		(* ------------------------------------- *)
		(* -- Errors for digestion conditions -- *)
		(* ------------------------------------- *)


		(* -- Errors for DigestionTemperature -- *)
		Example[{Messages, "MicrowaveDigestionMissingDigestionTemperature", "If DigestionTemperature and DigestionTemperatureProfile are both Null, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionTemperature -> Null,
				DigestionTemperatureProfile -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingDigestionTemperature, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionConflictingDigestionTemperature", "If DigestionTemperature and DigestionTemperatureProfile are both specified, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionTemperature -> 250 Celsius,
				DigestionTemperatureProfile -> {{0 Minute, $AmbientTemperature}, {10 Minute, 250 Celsius}}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionConflictingDigestionTemperature, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for DigestionDuration -- *)
		Example[{Messages, "MicrowaveDigestionMissingDigestionDuration", "If DigestionDuration and DigestionTemperatureProfile are both Null, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionDuration -> Null,
				DigestionTemperatureProfile -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingDigestionDuration, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionConflictingDigestionDuration", "If DigestionDuration and DigestionTemperatureProfile are both specified, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionDuration -> 10 Minute,
				DigestionTemperatureProfile -> {{0 Minute, $AmbientTemperature}, {10 Minute, 250 Celsius}}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionConflictingDigestionDuration, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for DigestionRampDuration -- *)
		Example[{Messages, "MicrowaveDigestionMissingDigestionRampDuration", "If DigestionRampDuration and DigestionTemperatureProfile are both Null, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionRampDuration -> Null,
				DigestionTemperatureProfile -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingDigestionRampDuration, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionConflictingDigestionRampDuration", "If DigestionRampDuration and DigestionTemperatureProfile are both specified, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionRampDuration -> 10 Minute,
				DigestionTemperatureProfile -> {{0 Minute, $AmbientTemperature}, {10 Minute, 250 Celsius}}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionConflictingDigestionRampDuration, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionRapidRampRate", "If either the DigestionRampDuration or DigestionTemperatureProfile require heating at a rate of over 50 Celsius/Minute, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionRampDuration -> 1 Minute,
				DigestionTemperature -> 200 Celsius
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionRapidRampRate, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for DigestionTemperatureProfile -- *)
		Example[{Messages, "MicrowaveDigestionAboveAmbientInitialTemperature", "If the DigestionTemperatureProfile does not start at ambient temperature, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionTemperatureProfile -> {
					{0 Minute, 150 Celsius},
					{5 Minute, 200 Celsius},
					{10 Minute, 200 Celsius}
				}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionAboveAmbientInitialTemperature, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionTemperatureProfileWithCooling", "If the DigestionTemperatureProfile includes decreasing temperature segments, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionTemperatureProfile -> {
					{0 Minute, $AmbientTemperature},
					{5 Minute, 200 Celsius},
					{10 Minute, 100 Celsius}
				}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionTemperatureProfileWithCooling, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionTimePointSwapped", "If the elements of DigestionTemperatureProfile are not in increasing order by time, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionTemperatureProfile -> {{10 Minute, 200 Celsius}, {5 Minute, 100 Celsius}}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionTimePointSwapped, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for tempearture profile, general -- *)
		Example[{Messages, "MicrowaveDigestionMissingDigestionProfile", "If no combination of specified or Automatic options can be used to resolve a valid temperature profile, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionTemperature -> Null,
				DigestionRampDuration -> Null,
				DigestionDuration -> Null,
				DigestionTemperatureProfile -> Null
			],
			$Failed,
			Messages :> {
				Error::MicrowaveDigestionMissingDigestionProfile,
				Error::MicrowaveDigestionMissingDigestionDuration,
				Error::MicrowaveDigestionMissingDigestionRampDuration,
				Error::MicrowaveDigestionMissingDigestionTemperature,
				Error::InvalidOption
			},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for DigestionMixRateProfile -- *)
		Example[{Messages, "MicrowaveDigestionMisMatchReactionLength", "If time points in the DigestionMixRateProfile exceed the highest time point of the DigestionTemperatureProfile or the sum of DigestionDuration adn DigestionRampDuration, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID]
				},
				DigestionMixRateProfile -> {{30 Minute, High}},
				DigestionTemperatureProfile -> {Null, {{5 Minute, 200 Celsius}, {10 Minute, 200 Celsius}}},
				DigestionTemperature -> {200 Celsius, Null},
				DigestionDuration -> {2 Minute, Null},
				DigestionRampDuration -> {5 Minute, Null}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMisMatchReactionLength, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* TODO: should just enforce this in the input then if it always erros when Null *)
		Example[{Messages, "MicrowaveDigestionMissingMixingProfile", "If DigestionMixRateProfile -> Null, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionMixRateProfile -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingMixingProfile, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ------------------------ *)
		(* -- Errors for venting -- *)
		(* ------------------------ *)


		(* -- Errors for TargetPressureReduction -- *)
		Example[{Messages, "MicrowaveDigestionMissingTargetPressureReduction", "If TargetPressureReduction is Null when PressureVenting is True, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PressureVenting -> True,
				TargetPressureReduction -> Null
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingTargetPressureReduction, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionUnusedTargetPressureReduction", "If TargetPressureReduction is specified when PressureVenting is False, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				SampleType -> Inorganic,
				PressureVenting -> False,
				TargetPressureReduction -> 20 PSI
			],
			$Failed,
			Messages :> {
				Error::MicrowaveDigestionUnusedTargetPressureReduction,
				Warning::MicrowaveDigestionMissingRecommendedVenting,
				Error::InvalidOption
			},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionLargePressureReduction", "If the TargetPressureReduction is greater than 50 PSI, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				TargetPressureReduction -> 200 PSI
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionLargePressureReduction, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],


		(* -- Errors for PressureVentingTriggers -- *)
		Example[{Messages, "MicrowaveDigestionMissingPressureVentingTriggers", "If PressureVentingTriggers is Null when PressureVenting -> True, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PressureVentingTriggers -> Null,
				PressureVenting -> True
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingPressureVentingTriggers, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionUnusedPressureVentingProfile", "If PressureVentingTriggers are specified when PressureVenting is False, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PressureVentingTriggers -> {{50 PSI, 2}, {320 PSI, 100}},
				SampleType -> Inorganic,
				PressureVenting -> False
			],
			$Failed,
			Messages :> {
				Error::MicrowaveDigestionUnusedPressureVentingProfile,
				Warning::MicrowaveDigestionMissingRecommendedVenting,
				Error::InvalidOption
			},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionExcessiveVentingCycles", "If the PressureVentingTriggers include greater than 150 potential total venting cycles, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PressureVentingTriggers -> {{50 PSI, 100}, {320 PSI, 100}}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionExcessiveVentingCycles, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionUnsafeOrganicVenting", "If the provided PressureVentingTriggers are insufficiently frequent to prevent unsafe and rapid pressurization of the vessel, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				SampleType -> Organic,
				PressureVentingTriggers -> {{100 PSI, 1}}
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionUnsafeOrganicVenting, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- Errors for PressureVenting -- *)
		Example[{Messages, "MicrowaveDigestionMissingRequiredVenting", "If SampleType -> Organic and PressureVenting -> False, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				SampleType -> Organic,
				PressureVenting -> False
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingRequiredVenting, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionMissingRecommendedVenting", "If SampleType -> Inorganic or Tablet and PressureVenting -> False, a message will be dispalyed:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				SampleType -> Inorganic,
				PressureVenting -> False
			],
			ObjectP[Object[Protocol, MicrowaveDigestion]],
			Messages :> {Warning::MicrowaveDigestionMissingRecommendedVenting},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],


		(* ----------------------- *)
		(* -- Errors for workup -- *)
		(* ----------------------- *)


		(* -- Errors for Diluent -- *)
		Example[{Messages, "MicrowaveDigestionUnusedDiluent", "If Diluent is specified but not used, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				Diluent -> Model[Sample, "Milli-Q water"],
				DiluteOutputAliquot -> False
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionUnusedDiluent, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionMissingDiluent", "If Diluent is required but specified as Null, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				Diluent -> Null,
				DiluteOutputAliquot -> True
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingDiluent, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Errors for DiluentVolume -- *)
		Example[{Messages, "MicrowaveDigestionMissingDiluentVolume", "If DiluentVolume is required but specified as Null, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DilutionFactor -> Null,
				DiluteOutputAliquot -> True
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionMissingDiluentVolume, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionUnusedDiluentVolume", "If DiluentVolume is specified but not used, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DiluentVolume -> 10 Milliliter,
				DiluteOutputAliquot -> False
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionUnusedDiluentVolume, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionLargeVolumeDilution", "If the DiluentVolume results in a solution greater than 1 Liter in volume, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				SampleAmount -> 150 Milligram,
				OutputAliquot -> All,
				DilutionFactor -> 200
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionLargeVolumeDilution, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* -- TargetDilutionVolume -- *)
		Example[{Messages, "MicrowaveDigestionDilutionLessThanAliquot", "If the TargetDilutionVolume is less than the OutputAliquot, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				TargetDilutionVolume -> 2 Milliliter,
				OutputAliquot -> 5 Milliliter
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionDilutionLessThanAliquot, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Errors for OutputAliquot -- *)
		Example[{Messages, "MicrowaveDigestionLargeVolumeConcAcid", "If no dilution is performed and OutputAliquot is more than 1 Milliliter, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				OutputAliquot -> All,
				DiluteOutputAliquot -> False
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionLargeVolumeConcAcid, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MicrowaveDigestionAliquotExceedsReactionVolume", "If the OutputAliquot exceeds the volume of the reaction mixture (SampleAmount with DigestionAgents), an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionAgents -> {{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], 5 Milliliter}},
				OutputAliquot -> 20 Milliliter,
				DiluteOutputAliquot -> True
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionAliquotExceedsReactionVolume, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* -- Errors for ContainerOut -- *)
		Example[{Messages, "MicrowaveDigestionIncompatibleContainerOut", "If the ContainerOut is not compatible with the reaction output's composition or volume, an error will be thrown:"},
			ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				ContainerOut -> Model[Container, Vessel, "50mL Tube"],
				DiluentVolume -> 100 Milliliter
			],
			$Failed,
			Messages :> {Error::MicrowaveDigestionIncompatibleContainerOut, Error::InvalidOption},
			SetUp :> ($CreatedObjects={}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],

		(* ----------------------- *)
		(* -- Rounding warnings -- *)
		(* ----------------------- *)


		(* -- Rounding for SampleAmount -- *)
		Example[{Messages, "MicrowaveDigestionSampleAmountPrecision", "If the SampleAmount is provided at higher precision than can be executed, the value will be rounded and a warning displayed:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID]
				},
				SampleAmount -> {100.0001 Milligram, 100.0001 Microliter},
				Output -> Options
			];
			Lookup[options, SampleAmount],
			{100 Milligram, 100 Microliter},
			Messages :> {Warning::MicrowaveDigestionSampleAmountPrecision},
			Variables :> {options}
		],
		(* -- Rounding for DigestionTemperatureProfile -- *)
		Example[{Messages, "DigestionTemperatureProfilePrecision", "If the DigestionTemperatureProfile is provided at higher precision than can be executed, the value will be rounded and a warning displayed:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionTemperatureProfile -> {{1200.1 Second, 299.04 Celsius}},
				Output -> Options
			];
			Lookup[options, DigestionTemperatureProfile],
			{{1200 Second, 299 Celsius}},
			Messages :> {Warning::DigestionTemperatureProfilePrecision},
			Variables :> {options}
		],
		(* -- Rounding for DigestionMixRateProfile -- *)
		Example[{Messages, "DigestionMixRateProfilePrecision", "If the DigestionMixRateProfile is provided at higher precision than can be executed, the value will be rounded and a warning displayed:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionMixRateProfile -> {{0 Second, High}, {100.01 Second, Medium}},
				Output -> Options
			];
			Lookup[options, DigestionMixRateProfile],
			{{0 Second, High}, {100 Second, Medium}},
			Messages :> {Warning::DigestionMixRateProfilePrecision},
			Variables :> {options}
		],

		(* -- Rounding for DigestionAgents -- *)
		Example[{Messages, "DigestionAgentsPrecision", "If the DigestionAgents is provided at higher precision than can be executed, the value will be rounded and a warning displayed:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionAgents -> {{Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"], 10.00001 Milliliter}},
				Output -> Options
			];
			Lookup[options, DigestionAgents],
			{{ObjectP[Model[Sample, "Nitric Acid 70% (TraceMetal Grade)"]], 10000 Microliter}},
			Messages :> {Warning::DigestionAgentsPrecision},
			Variables :> {options}
		],

		(* -- Rounding for PressureVentingTriggers -- *)
		Example[{Messages, "PressureVentingTriggersPrecision", "If the PressureVentingTriggers is provided at higher precision than can be executed, the value will be rounded and a warning displayed:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				PressureVentingTriggers -> {{10.001 PSI, 100}, {300 PSI, 2}},
				Output -> Options
			];
			Lookup[options, PressureVentingTriggers],
			{{10 PSI, 100}, {300 PSI, 2}},
			Messages :> {Warning::PressureVentingTriggersPrecision},
			Variables :> {options}
		],
		(* -- Rounding for DigestionMaxPressure -- *)
		Example[{Messages, "InstrumentPrecision", "If the DigestionMaxPressure is provided at higher precision than can be executed, the value will be rounded and a warning displayed:"},
			options=ExperimentMicrowaveDigestion[
				{
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID]
				},
				DigestionMaxPressure -> 350.01230123 PSI,
				Output -> Options
			];
			Lookup[options, DigestionMaxPressure],
			350 PSI,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		]

	},

	(*  build test objects *)
	Stubs :> {
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Plate, "Test sample plate for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Item, TabletCrusher, "Test tablet crusher for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Item, TabletCrusherBag, "Test tablet crusher bags for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Instrument, Reactor, Microwave, "Test instrument for MicrowaveDigestion tests"<>$SessionUUID],
					Model[Instrument, Reactor, Microwave, "Bad instrument for MicrowaveDigestion"<>$SessionUUID],

					Object[Container, Vessel, "Test container 1 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 10 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 11 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 4 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 5 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 6 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 7 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 8 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 9 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 4 HF"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Prepared Test Liquid"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 3"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 3"<>$SessionUUID],

					Object[Container, ReactionVessel, Microwave, "Test reaction vessel for MicrowaveDigestion tests 1"<>$SessionUUID],
					Object[Container, ReactionVessel, Microwave, "Test reaction vessel for MicrowaveDigestion tests 2"<>$SessionUUID],
					Object[Container, ReactionVessel, Microwave, "Test reaction vessel for MicrowaveDigestion tests 3"<>$SessionUUID],
					Object[Part, StirBar, "Test stir bar for MicrowaveDigestion tests 1"<>$SessionUUID],
					Object[Part, StirBar, "Test stir bar for MicrowaveDigestion tests 2"<>$SessionUUID],
					Object[Part, StirBar, "Test stir bar for MicrowaveDigestion tests 3"<>$SessionUUID],
					Object[Item, Cap, "Test reaction vessel caps for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Rack, "Test reaction vessel rack for MicrowaveDigestion tests 1"<>$SessionUUID],
					Object[Protocol, MicrowaveDigestion, "Parent Protocol for Template ExperimentMicrowaveDigestion tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testBench, instrument, tabletCrusher, tabletCrusherBags, glassPlate,
					container1, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, samplePlate,
					liquidSample1, liquidSample2, liquidSample3, preparedLiquidSample, hfLiquidSample, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3,
					reactionVessel1, reactionVessel2, reactionVessel3, stirBars, caps, rack, badModel
				},
				(* set up test bench as a location for the vessel *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Site -> Link[$Site],
					Name -> "Test bench for MicrowaveDigestion tests"<>$SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(* set up instrument and tablet crusher bags *)
				instrument = <|
					Type -> Object[Instrument, Reactor, Microwave],
					Model -> Link[Model[Instrument, Reactor, Microwave, "Discover SP-D 80"], Objects],
					Site -> Link[$Site],
					Name -> "Test instrument for MicrowaveDigestion tests"<>$SessionUUID,
					MethodFilePath -> "Instrument Methods\\Microwave Digestion\\",
					DataFilePath -> "Data\\Microwave Digestion\\",
					Software -> "SynergyD",
					DeveloperObject -> True,
					TemplateDatabaseFile -> Link[Object[EmeraldCloudFile, "id:o1k9jAGd1w3A"]],
					Status -> Available
				|>;

				(* set up a bad model that cant actually do digestion *)
				badModel=<|
					Type -> Model[Instrument, Reactor, Microwave],
					Name -> "Bad instrument for MicrowaveDigestion"<>$SessionUUID,
					DeveloperObject -> True
				|>;

				(* -- tablet crusher and bags -- *)
				tabletCrusherBags=<|
					Type -> Object[Item, TabletCrusherBag],
					Model -> Link[Model[Item, TabletCrusherBag, "Silent Knight tablet crusher bag"], Objects],
					Site -> Link[$Site],
					Name -> "Test tablet crusher bags for MicrowaveDigestion tests"<>$SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Count -> 50,
					Status -> Available,
					DeveloperObject -> True
				|>;

				(* stir bars and caps *)
				stirBars={
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "SP-D 80 Reaction Vessel Stir Bar"], Objects],
						Site -> Link[$Site],
						Name -> "Test stir bar for MicrowaveDigestion tests 1"<>$SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DeveloperObject -> True
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "SP-D 80 Reaction Vessel Stir Bar"], Objects],
						Site -> Link[$Site],
						Name -> "Test stir bar for MicrowaveDigestion tests 2"<>$SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DeveloperObject -> True
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "SP-D 80 Reaction Vessel Stir Bar"], Objects],
						Site -> Link[$Site],
						Name -> "Test stir bar for MicrowaveDigestion tests 3"<>$SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DeveloperObject -> True
					|>};

				caps=<|
					Type -> Object[Item, Cap],
					Model -> Link[Model[Item, Cap, "SP-D 80 Reaction Vessel Cap"], Objects],
					Site -> Link[$Site],
					Name -> "Test reaction vessel caps for MicrowaveDigestion tests"<>$SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Count -> 50,
					Status -> Available,
					DeveloperObject -> True
				|>;

				(* -- UPLOAD THE TEST OBJECTS -- *)
				Upload[Flatten[{tabletCrusherBags, instrument, stirBars, caps, badModel}]];

				(* set up reaction vessels to avoid any frq warnings *)
				{
					reactionVessel1,
					reactionVessel2,
					reactionVessel3
				}=UploadSample[
					{
						Model[Container, ReactionVessel, Microwave, "SP-D 80 Reaction Vessel"],
						Model[Container, ReactionVessel, Microwave, "SP-D 80 Reaction Vessel"],
						Model[Container, ReactionVessel, Microwave, "SP-D 80 Reaction Vessel"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status ->
						{
							Available,
							Available,
							Available
						},
					Name ->
						{
							"Test reaction vessel for MicrowaveDigestion tests 1"<>$SessionUUID,
							"Test reaction vessel for MicrowaveDigestion tests 2"<>$SessionUUID,
							"Test reaction vessel for MicrowaveDigestion tests 3"<>$SessionUUID
						},
					FastTrack ->True
				];


				(* set up test containers for our samples *)
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
					glassPlate,
					tabletCrusher,
					rack
				}=UploadSample[
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
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Model[Container, Plate, "96-well glass bottom plate"],
						Model[Item, TabletCrusher, "Silent Knight tablet crusher"],
						Model[Container, Rack, "id:J8AY5jDWmkzD"]
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
						{"Work Surface", testBench},
						{"Work Surface", testBench}
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
							Available,
							Available
						},
					Name ->
						{
							"Test container 1 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 2 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 3 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 4 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 5 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 6 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 7 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 8 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 9 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 10 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test container 11 for MicrowaveDigestion tests"<>$SessionUUID,
							"Test sample plate for MicrowaveDigestion tests"<>$SessionUUID,
							"Test tablet crusher for MicrowaveDigestion tests"<>$SessionUUID,
							"Test reaction vessel rack for MicrowaveDigestion tests 1"<>$SessionUUID
						},
					FastTrack ->True
				];

				(*TODO: set up test objects with HF and HClO4 and that are just aqua regia themselves*)
				(* set up test samples to test *)
				{
					liquidSample1,
					liquidSample2,
					liquidSample3,
					preparedLiquidSample,
					hfLiquidSample,
					solidSample1,
					solidSample2,
					solidSample3,
					tabletSample1,
					tabletSample2,
					tabletSample3
				}=UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
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
						{"A1", container10},
						{"A1", container11},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A1", container9}
					},
					InitialAmount ->
						{
							20 * Milliliter,
							20 * Milliliter,
							1 * Milliliter,
							20 * Milliliter,
							20 * Milliliter,
							1 * Gram,
							1 * Gram,
							1 * Gram,
							3,
							3,
							3
						},
					Name ->
						{
							"MicrowaveDigestion Test Liquid 1"<>$SessionUUID,
							"MicrowaveDigestion Test Liquid 2"<>$SessionUUID,
							"MicrowaveDigestion Test Liquid 3"<>$SessionUUID,
							"MicrowaveDigestion Prepared Test Liquid"<>$SessionUUID,
							"MicrowaveDigestion Test Liquid 4 HF"<>$SessionUUID,
							"MicrowaveDigestion Test Solid 1"<>$SessionUUID,
							"MicrowaveDigestion Test Solid 2"<>$SessionUUID,
							"MicrowaveDigestion Test Solid 3"<>$SessionUUID,
							"MicrowaveDigestion Test Tablet 1"<>$SessionUUID,
							"MicrowaveDigestion Test Tablet 2"<>$SessionUUID,
							"MicrowaveDigestion Test Tablet 3"<>$SessionUUID
						},
					FastTrack->True
				];

				(* Upload protocol for Template *)
				Upload[
					<|
						Type -> Object[Protocol, MicrowaveDigestion],
						Name -> "Parent Protocol for Template ExperimentMicrowaveDigestion tests"<>$SessionUUID,
						DeveloperObject -> True
					|>
				];

				(* upload the test objects *)
				Upload[
					<|
						Object -> #,
						AwaitingStorageUpdate -> Null,
						DeveloperObject -> True
					|> & /@ Cases[
						Flatten[
							{
								container1, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11,
								glassPlate, tabletCrusher,
								liquidSample1, liquidSample2, liquidSample3, preparedLiquidSample, hfLiquidSample, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3
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
									Concentration -> 1 Millimolar,
									Replace[Composition] -> {{1 Millimolar, Link[Model[Molecule, "Sodium Chloride"]], Now}, {99 MassPercent, Link[Model[Molecule, "Water"]], Now}}
								|>,
								<|
									Object -> preparedLiquidSample,
									Model -> Null,
									Replace[Composition] -> {{2 Molar, Link[Model[Molecule, "Nitric Acid"]], Now}, {1 Molar, Link[Model[Molecule, "Phosphoric Acid"]], Now}}
								|>,
								<|
									Object -> hfLiquidSample,
									Model -> Null,
									Replace[Composition] -> {{1 Molar, Link[Model[Molecule, "Hydrofluoric acid"]], Now}, {1 Molar, Link[Model[Molecule, "Phosphoric Acid"]], Now}}
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
			objs=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Plate, "Test sample plate for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Item, TabletCrusher, "Test tablet crusher for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Item, TabletCrusherBag, "Test tablet crusher bags for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Instrument, Reactor, Microwave, "Test instrument for MicrowaveDigestion tests"<>$SessionUUID],
					Model[Instrument, Reactor, Microwave, "Bad instrument for MicrowaveDigestion"<>$SessionUUID],

					Object[Container, Vessel, "Test container 1 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 10 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 11 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 4 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 5 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 6 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 7 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 8 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 9 for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 3"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Liquid 4 HF"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Prepared Test Liquid"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Solid 3"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestion Test Tablet 3"<>$SessionUUID],

					Object[Container, ReactionVessel, Microwave, "Test reaction vessel for MicrowaveDigestion tests 1"<>$SessionUUID],
					Object[Container, ReactionVessel, Microwave, "Test reaction vessel for MicrowaveDigestion tests 2"<>$SessionUUID],
					Object[Container, ReactionVessel, Microwave, "Test reaction vessel for MicrowaveDigestion tests 3"<>$SessionUUID],
					Object[Part, StirBar, "Test stir bar for MicrowaveDigestion tests 1"<>$SessionUUID],
					Object[Part, StirBar, "Test stir bar for MicrowaveDigestion tests 2"<>$SessionUUID],
					Object[Part, StirBar, "Test stir bar for MicrowaveDigestion tests 3"<>$SessionUUID],
					Object[Item, Cap, "Test reaction vessel caps for MicrowaveDigestion tests"<>$SessionUUID],
					Object[Container, Rack, "Test reaction vessel rack for MicrowaveDigestion tests 1"<>$SessionUUID],
					Object[Protocol, MicrowaveDigestion, "Parent Protocol for Template ExperimentMicrowaveDigestion tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];










(* ::Subsection:: *)
(*ExperimentMicrowaveDigestionOptions*)


(* ---------------------------------------- *)
(* -- ExperimentMicrowaveDigestionOptions -- *)
(* ---------------------------------------- *)


DefineTests[ExperimentMicrowaveDigestionOptions,
	{
		Example[{Basic, "Display the option values which will be used in the experiment:"},
			ExperimentMicrowaveDigestionOptions[
				Object[Sample, "MicrowaveDigestionOptions Test Solid 1"<>$SessionUUID]
			],
			_Grid
		],
		Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
			ExperimentMicrowaveDigestionOptions[
				Object[Sample, "MicrowaveDigestionOptions Test Solid 1"<>$SessionUUID]
			],
			_Grid
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			ExperimentMicrowaveDigestionOptions[
				{
					Object[Sample, "MicrowaveDigestionOptions Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Solid 3"<>$SessionUUID]
				},
				OutputFormat -> List
			],
			{(_Rule | _RuleDelayed)..}
		]
	},


	(*  build test objects *)
	Stubs :> {
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Plate, Irregular, Raman, "Test tablet holder for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Instrument, Reactor, Microwave, "Test instrument for MicrowaveDigestionOptions tests"<>$SessionUUID],

					Object[Container, Plate, "Test sample plate for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 4 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 5 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 6 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 7 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 8 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 9 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Liquid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Liquid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Liquid 3"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Solid 3"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Tablet 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Tablet 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Tablet 3"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testBench, instrument, glassPlate,
					container1, container2, container3, container4, container5, container6, container7, container8, container9,
					liquidSample1, liquidSample2, liquidSample3, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3
				},
				(* set up test bench as a location for the vessel *)
				testBench=Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Site -> Link[$Site],
					Name -> "Test bench for MicrowaveDigestionOptions tests"<>$SessionUUID, 
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(* set up instrument and tablet crusher bags *)
				instrument=Upload[<|
					Type -> Object[Instrument, Reactor, Microwave],
					Model -> Link[Model[Instrument, Reactor, Microwave, "Discover SP-D 80"], Objects],
					Site -> Link[$Site],
					DeveloperObject -> True,
					Name -> "Test instrument for MicrowaveDigestionOptions tests"<>$SessionUUID,
					Status -> Available
				|>];


				(* set up test containers for our samples *)
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
				}=UploadSample[
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
							"Test container 1 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test container 2 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test container 3 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test container 4 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test container 5 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test container 6 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test container 7 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test container 8 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test container 9 for MicrowaveDigestionOptions tests"<>$SessionUUID,
							"Test sample plate for MicrowaveDigestionOptions tests"<>$SessionUUID
						},
					FastTrack->True
				];

				(* set up test samples to test *)
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
				}=UploadSample[
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
							20 * Milliliter,
							20 * Milliliter,
							1 * Milliliter,
							1 * Gram,
							1 * Gram,
							1 * Gram,
							1,
							1,
							1
						},
					Name ->
						{
							"MicrowaveDigestionOptions Test Liquid 1"<>$SessionUUID,
							"MicrowaveDigestionOptions Test Liquid 2"<>$SessionUUID,
							"MicrowaveDigestionOptions Test Liquid 3"<>$SessionUUID,
							"MicrowaveDigestionOptions Test Solid 1"<>$SessionUUID,
							"MicrowaveDigestionOptions Test Solid 2"<>$SessionUUID,
							"MicrowaveDigestionOptions Test Solid 3"<>$SessionUUID,
							"MicrowaveDigestionOptions Test Tablet 1"<>$SessionUUID,
							"MicrowaveDigestionOptions Test Tablet 2"<>$SessionUUID,
							"MicrowaveDigestionOptions Test Tablet 3"<>$SessionUUID
						},
					FastTrack->True
				];

				(* upload the test objects *)
				Upload[
					<|
						Object -> #,
						AwaitingStorageUpdate -> Null,
						DeveloperObject -> True
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
			objs=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Plate, "Test sample plate for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Plate, Irregular, Raman, "Test tablet holder for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Instrument, Reactor, Microwave, "Test instrument for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 4 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 5 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 6 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 7 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 8 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 9 for MicrowaveDigestionOptions tests"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Liquid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Liquid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Liquid 3"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Solid 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Solid 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Solid 3"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Tablet 1"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Tablet 2"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionOptions Test Tablet 3"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection:: *)
(*ValidExperimentMicrowaveDigestionQ*)


(* --------------------------------------- *)
(* -- ValidExperimentMicrowaveDigestionQ -- *)
(* --------------------------------------- *)


DefineTests[ValidExperimentMicrowaveDigestionQ,
	{
		Example[{Basic, "Verify that the experiment can be run without issues:"},
			ValidExperimentMicrowaveDigestionQ[
				Object[Sample, "ValidMicrowaveDigestionQ Test Solid 1"<>$SessionUUID]
			],
			True
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentMicrowaveDigestionQ[
				Object[Sample, "ValidMicrowaveDigestionQ Test Solid 1"<>$SessionUUID],
				PressureVentingTriggers -> Null,
				PressureVenting -> True
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidExperimentMicrowaveDigestionQ[
				Object[Sample, "ValidMicrowaveDigestionQ Test Solid 1"<>$SessionUUID],
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidExperimentMicrowaveDigestionQ[
				Object[Sample, "ValidMicrowaveDigestionQ Test Solid 1"<>$SessionUUID],
				Verbose -> True
			],
			True
		]
	},


	(*  build test objects *)
	Stubs :> {
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Plate, "Test sample plate for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Plate, Irregular, Raman, "Test tablet holder for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Item, TabletCutter, "Test tablet cutter for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Item, TabletCrusher, "Test tablet crusher for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Item, TabletCrusherBag, "Test tablet crusher bags for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Instrument, Reactor, Microwave, "Test instrument for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 4 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 5 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 6 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 7 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 8 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 9 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Liquid 1"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Liquid 2"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Liquid 3"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Solid 1"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Solid 2"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Solid 3"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Tablet 1"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Tablet 2"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Tablet 3"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testBench, instrument, tabletCutter, tabletCrusher, tabletCrusherBags, tabletHolder, glassPlate,
					container1, container2, container3, container4, container5, container6, container7, container8, container9, samplePlate,
					liquidSample1, liquidSample2, liquidSample3, solidSample1, solidSample2, solidSample3, tabletSample1, tabletSample2, tabletSample3
				},
				(* set up test bench as a location for the vessel *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Site -> Link[$Site],
					Name -> "Test bench for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>];

				(* set up instrument and tablet crusher bags *)
				instrument = Upload[<|
					Type -> Object[Instrument, Reactor, Microwave],
					Model -> Link[Model[Instrument, Reactor, Microwave, "Discover SP-D 80"], Objects],
					Site -> Link[$Site],
					Name -> "Test instrument for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
					DeveloperObject -> True,
					Status -> Available
				|>];

				tabletCrusherBags = Upload[<|
					Type -> Object[Item, TabletCrusherBag],
					Model -> Link[Model[Item, TabletCrusherBag, "Silent Knight tablet crusher bag"], Objects],
					Site -> Link[$Site],
					Name -> "Test tablet crusher bags for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					DeveloperObject -> True,
					Count -> 50,
					Status -> Available
				|>];

				(* set up test containers for our samples *)
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
				}=UploadSample[
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
							"Test container 1 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test container 2 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test container 3 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test container 4 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test container 5 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test container 6 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test container 7 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test container 8 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test container 9 for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test sample plate for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test tablet holder for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test tablet cutter for ValidMicrowaveDigestionQ tests"<>$SessionUUID,
							"Test tablet crusher for ValidMicrowaveDigestionQ tests"<>$SessionUUID
						},
					FastTrack ->True
				];

				(* set up test samples to test *)
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
				}=UploadSample[
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
							20 * Milliliter,
							20 * Milliliter,
							1 * Milliliter,
							1 * Gram,
							1 * Gram,
							1 * Gram,
							1,
							1,
							1
						},
					Name ->
						{
							"ValidMicrowaveDigestionQ Test Liquid 1"<>$SessionUUID,
							"ValidMicrowaveDigestionQ Test Liquid 2"<>$SessionUUID,
							"ValidMicrowaveDigestionQ Test Liquid 3"<>$SessionUUID,
							"ValidMicrowaveDigestionQ Test Solid 1"<>$SessionUUID,
							"ValidMicrowaveDigestionQ Test Solid 2"<>$SessionUUID,
							"ValidMicrowaveDigestionQ Test Solid 3"<>$SessionUUID,
							"ValidMicrowaveDigestionQ Test Tablet 1"<>$SessionUUID,
							"ValidMicrowaveDigestionQ Test Tablet 2"<>$SessionUUID,
							"ValidMicrowaveDigestionQ Test Tablet 3"<>$SessionUUID
						},
					FastTrack->True
				];

				(* upload the test objects *)
				Upload[
					<|
						Object -> #,
						AwaitingStorageUpdate -> Null,
						DeveloperObject -> True
					|> & /@ Cases[
						Flatten[
							{
								container1, container2, container3, container4, container5, container6, container7, container8, container9,
								glassPlate, tabletHolder, tabletCutter, tabletCrusher,
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
			objs=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Plate, "Test sample plate for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Plate, Irregular, Raman, "Test tablet holder for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Item, TabletCutter, "Test tablet cutter for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Item, TabletCrusher, "Test tablet crusher for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Item, TabletCrusherBag, "Test tablet crusher bags for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Instrument, Reactor, Microwave, "Test instrument for ValidMicrowaveDigestionQ tests"<>$SessionUUID],

					Object[Container, Vessel, "Test container 1 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 3 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 4 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 5 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 6 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 7 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 8 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 9 for ValidMicrowaveDigestionQ tests"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Liquid 1"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Liquid 2"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Liquid 3"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Solid 1"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Solid 2"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Solid 3"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Tablet 1"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Tablet 2"<>$SessionUUID],
					Object[Sample, "ValidMicrowaveDigestionQ Test Tablet 3"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];




(* ::Subsection:: *)
(*ExperimentMicrowaveDigestionPreview*)


(* ---------------------------------------- *)
(* -- ExperimentMicrowaveDigestionPreview -- *)
(* ---------------------------------------- *)


DefineTests[ExperimentMicrowaveDigestionPreview,
	{
		Example[{Basic, "No preview is currently available for ExperimentMicrowaveDigestion:"},
			ExperimentMicrowaveDigestionPreview[
				Object[Sample, "MicrowaveDigestionPreview Test Liquid 1"<>$SessionUUID]
			],
			Null
		],
		Example[{Options, "If you wish to understand how the experiment will be performed, try using ExperimentMicrowaveDigestionOptions:"},
			ExperimentMicrowaveDigestionOptions[
				Object[Sample, "MicrowaveDigestionPreview Test Liquid 1"<>$SessionUUID]
			],
			_Grid
		],
		Example[{Options, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentMicrowaveDigestionQ:"},
			ValidExperimentMicrowaveDigestionQ[
				Object[Sample, "MicrowaveDigestionPreview Test Liquid 1"<>$SessionUUID]
			],
			True
		]
	},

	(*  build test objects *)
	Stubs :> {
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for MicrowaveDigestionPreview tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for MicrowaveDigestionPreview tests"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionPreview Test Liquid 1"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					testBench,
					container1,
					liquidSample1
				},
				(* set up test bench as a location for the vessel *)
				testBench=Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Site -> Link[$Site],
					Name -> "Test bench for MicrowaveDigestionPreview tests"<>$SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

				(* set up test containers for our samples *)
				{
					container1
				}=UploadSample[
					{
						Model[Container, Vessel, "id:bq9LA0dBGGR6"]
					},
					{
						{"Work Surface", testBench}
					},
					Status ->
						{
							Available
						},
					Name ->
						{
							"Test container 1 for MicrowaveDigestionPreview tests"<>$SessionUUID
						},
					FastTrack->True
				];

				(* set up test samples to test *)
				{
					liquidSample1
				}=UploadSample[
					{
						Model[Sample, "Milli-Q water"]
					},
					{
						{"A1", container1}
					},
					InitialAmount ->
						{
							20 * Milliliter
						},
					Name ->
						{
							"MicrowaveDigestionPreview Test Liquid 1"<>$SessionUUID
						},
					FastTrack->True
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
			objs=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for MicrowaveDigestionPreview tests"<>$SessionUUID],
					Object[Container, Vessel, "Test container 1 for MicrowaveDigestionPreview tests"<>$SessionUUID],
					Object[Sample, "MicrowaveDigestionPreview Test Liquid 1"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];
