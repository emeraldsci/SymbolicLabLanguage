(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasureSurfaceTension*)

DefineTests[ExperimentMeasureSurfaceTension,

	{Example[{Basic,"Takes a sample object:"},
		ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]],
		ObjectP[Object[Protocol, MeasureSurfaceTension]],
		SetUp:>($CreatedObjects={}),
		TearDown:>(
			EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects]
		)
	],
		Example[{Basic,"Accepts a list of sample objects:"},
			ExperimentMeasureSurfaceTension[{Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]}],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Generate protocol for measuring surface tension of samples in a plate object:"},
			ExperimentMeasureSurfaceTension[Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts a list of plate objects:"},
			ExperimentMeasureSurfaceTension[{Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Takes a sample object with a severed model:"},
			ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension No Model Test Sample"<> $SessionUUID]],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		(* - Sample Prep unit tests - *)
		Example[{Options,PreparatoryPrimitives,"Specify prepared samples to have their SurfaceTensions measured:"},
			protocol = ExperimentMeasureSurfaceTension[
				"SDS sample 1",
				PreparatoryPrimitives -> {
					Define[Name -> "SDS sample 1",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, StockSolution, "0.5M Sodium dodecyl sulfate"],
						Destination -> "SDS sample 1", Amount -> 500*Microliter
					]
				}
			];
			Download[protocol, PreparatoryPrimitives],
			{SampleManipulationP..},
			Variables :> {protocol}
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to have their SurfaceTensions measured:"},
			protocol = ExperimentMeasureSurfaceTension[
				"SDS sample 1",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "SDS sample 1",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, StockSolution, "0.5M Sodium dodecyl sulfate"],
						Destination -> "SDS sample 1",
						Amount -> 500*Microliter
					]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		(*option rounding*)
		Example[{Options,DilutionCurve,"Rounds specified DilutionCurve to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				DilutionCurve->{{39.99*Microliter,10*Microliter},{29.99*Microliter,20*Microliter}},Output->Options];
			Lookup[options,DilutionCurve],
			{{40Microliter,10*Microliter},{30*Microliter,20*Microliter}},
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Rounds multiple specified DilutionCurves to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->{{{39.99*Microliter,10*Microliter},{29.99*Microliter,20*Microliter}},{{39.99*Microliter,10*Microliter},{29.99*Microliter,20*Microliter}}},Output->Options];
			Lookup[options,DilutionCurve],
			{{{40Microliter,10*Microliter},{30*Microliter,20*Microliter}},{{40Microliter,10*Microliter},{30*Microliter,20*Microliter}}},
			Messages:>{
				Warning::InstrumentPrecision,
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Rounds specified DilutionCurve with dilution factors to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				DilutionCurve->{{49.99*Microliter,0.9},{49.99*Microliter,0.8}},Output->Options];
			Lookup[options,DilutionCurve],
			{{50*Microliter,0.9},{50*Microliter,0.8}},
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Rounds multiple specified DilutionCurve with dilution factors to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->{{{49.99*Microliter,0.9},{49.99*Microliter,0.8}},{{39.99*Microliter,10*Microliter},{29.99*Microliter,20*Microliter}}},Output->Options];
			Lookup[options,DilutionCurve],
			{{{50*Microliter,0.9},{50*Microliter,0.8}},{{40Microliter,10*Microliter},{30*Microliter,20*Microliter}}},
			Messages:>{
				Warning::InstrumentPrecision,
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Rounds specified SerialDilutionCurve to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				SerialDilutionCurve->{39.99*Microliter,50*Microliter,10},Output->Options];
			Lookup[options,SerialDilutionCurve],
			{40*Microliter,50*Microliter,10},
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Rounds multiple specified SerialDilutionCurve to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{{39.99*Microliter,50*Microliter,10},{39.99*Microliter,50*Microliter,10}},Output->Options];
			Lookup[options,SerialDilutionCurve],
			{{40*Microliter,50*Microliter,10},{40*Microliter,50*Microliter,10}},
			Messages:>{
				Warning::InstrumentPrecision,
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Rounds specified SerialDilutionCurve with dilution factors to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				SerialDilutionCurve->{49.99*Microliter,{0.5,10}},Output->Options];
			Lookup[options,SerialDilutionCurve],
			{50*Microliter,{0.5,10}},
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Rounds specified multiple SerialDilutionCurve with dilution factors to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{{49.99*Microliter,{0.5,10}},{49.99*Microliter,{0.5,10}}},Output->Options];
			Lookup[options,SerialDilutionCurve],
			{{50*Microliter,{0.5,10}},{50*Microliter,{0.5,10}}},
			Messages:>{
				Warning::InstrumentPrecision,
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Rounds specified SerialDilutionCurve with multiple dilution factors to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				SerialDilutionCurve->{49.99*Microliter,{0.5,0.9,0.7}},Output->Options];
			Lookup[options,SerialDilutionCurve],
			{50*Microliter,{0.5,0.9,0.7}},
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Rounds multiple specified SerialDilutionCurve with multiple dilution factors to the nearest 0.1 Microliter:"},
			options=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{{39.99*Microliter,50*Microliter,10},{49.99*Microliter,{0.5,10}},{49.99*Microliter,{0.5,0.9,0.7}}},Output->Options];
			Lookup[options,SerialDilutionCurve],
			{{40*Microliter,50*Microliter,10},{50*Microliter,{0.5,10}},{50*Microliter,{0.5,0.9,0.7}}},
			Messages:>{
				Warning::InstrumentPrecision,
				Warning::InstrumentPrecision,
				Warning::InstrumentPrecision,
				General::stop
			},
			Variables:>{options}
		],
		Example[{Options,CalibrantSurfaceTension,"Rounds specified MaxCalibrationNoise to the nearest 0.01 MilliNewton/Meter:"},
			options=ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				MaxCalibrationNoise->0.111111 Milli*Newton/Meter,Output->Options];
			Lookup[options,MaxCalibrationNoise],
			0.11  Milli*Newton/Meter,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables:>{options}
		],
		(*options*)
		Example[
			{Options,Instrument,"Specify the instrument used to perform the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				Instrument->Model[Instrument, Tensiometer, "Kibron Delta 8 Tensiometer"],
				Output -> Options
			];
			Lookup[options,Instrument],
			ObjectP[Model[Instrument, Tensiometer, "Kibron Delta 8 Tensiometer"]],
			Variables:>{options}
		],
		Example[
			{Options,NumberOfReplicates,"Specify the number of times an experiment of repeated:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				NumberOfReplicates->3,
				Output -> Options
			];
			Lookup[options,NumberOfReplicates],
			3,
			Variables:>{options}
		],
		Example[{Options,NumberOfReplicates,"Specify the number of times an experiment of repeated:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				NumberOfReplicates->3];
			Download[protocol,NumberOfReplicates],
			3,
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,NumberOfReplicates,"Specify that an experiment of is not to be repeated:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				NumberOfReplicates->Null,
				Output -> Options
			];
			Lookup[options,NumberOfReplicates],
			Null,
			Variables:>{options}
		],
		Example[{Options,NumberOfReplicates,"Specify that an experiment of is not to be repeated:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				NumberOfReplicates->Null];
			Download[protocol,NumberOfReplicates],
			1,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,SerialDilutionCurve,"Specify a serial dilution curve:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{50Microliter,50Microliter,10},
				Output -> Options
			];
			Lookup[options,SerialDilutionCurve],
			{50Microliter,50Microliter,10},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Specify a serial dilution curve:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{50Microliter,50Microliter,10}];
			Download[protocol,SerialDilutions],
			{Flatten[Join[{{{100 Microliter,0 Microliter}},ConstantArray[{50 Microliter,50 Microliter},10]}],1]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,SerialDilutionCurve,"Specify a serial dilution curve with dilution factors:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{50Microliter,{0.7,10}},
				Output -> Options
			];
			Lookup[options,SerialDilutionCurve],
			{50Microliter,{0.7,10}},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Specify a serial dilution curve with dilution factors:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],SerialDilutionCurve->{50Microliter,{0.7,10}}];
			Download[protocol,SerialDilutions],
			{Flatten[Join[{{{166.7 Microliter,0 Microliter}},ConstantArray[{116.7 Microliter,50 Microliter},10]}],1]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,SerialDilutionCurve,"Specify a serial dilution curve with non constant dilution factors:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{50Microliter,{0.7,0.8,0.6,0.1}},
				Output -> Options
			];
			Lookup[options,SerialDilutionCurve],
			{50Microliter,{0.7,0.8,0.6,0.1}},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Specify a serial dilution curve with non constant dilution factors:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],SerialDilutionCurve->{50Microliter,{0.7,0.8,0.6,0.1}}];
			Download[protocol,SerialDilutions],
			{{{131.5 Microliter, 0 Microliter},
				{81.5 Microliter, 34.9 Microliter},
				{66.4 Microliter, 16.6 Microliter},
				{33. Microliter, 22 Microliter},
				{5. Microliter,45. Microliter}}},
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,SerialDilutionCurve,"Specify a null serial dilution curve:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->Null,
				Output -> Options
			];
			Lookup[options,SerialDilutionCurve],
			Null,
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Specify a null serial dilution curve:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->Null];
			Download[protocol,SerialDilutions],
			{Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,SerialDilutionCurve,"Resolve a serial dilution curve when calibrant=diluent:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Calibrant->Model[Sample, "Milli-Q water"],
				Diluent->Model[Sample, "Milli-Q water"],
				Output -> Options
			];
			Lookup[options,SerialDilutionCurve],
			{100 Microliter,{0.7,21}},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Resolve a serial dilution curve when calibrant=diluent:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Calibrant->Model[Sample, "Milli-Q water"],
				Diluent->Model[Sample, "Milli-Q water"]];
			Download[protocol,SerialDilutions],
			{Flatten[Join[{{{333.3` Microliter,0 Microliter}},ConstantArray[{233.3` Microliter,100 Microliter},21]}],1]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,SerialDilutionCurve,"Resolve a serial dilution curve when calibrant!=diluent:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Calibrant->Model[Sample, "Milli-Q water"],
				Diluent->Model[Sample,"Dimethyl sulfoxide"],
				Output -> Options
			];
			Lookup[options,SerialDilutionCurve],
			{100 Microliter,{0.7,20}},
			Variables:>{options}
		],
		Example[{Options,SerialDilutionCurve,"Resolve a serial dilution curve when calibrant!=diluent:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Calibrant->Model[Sample, "Milli-Q water"],
				Diluent->Model[Sample,"Dimethyl sulfoxide"]];
			Download[protocol,SerialDilutions],
			{Flatten[Join[{{{333.3` Microliter,0 Microliter}},ConstantArray[{233.3` Microliter,100 Microliter},20],{{0 Microliter,100 Microliter}}}],1]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionCurve,"Specify a custom dilution curve:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->{{40Microliter,10Microliter},{50Microliter,0Microliter}},
				Output -> Options
			];
			Lookup[options,DilutionCurve],
			{{40Microliter,10Microliter},{50Microliter,0Microliter}},
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Specify a custom dilution curve:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],DilutionCurve->{{40Microliter,10Microliter},{50Microliter,0Microliter}}];
			Download[protocol,Dilutions],
			{{{40Microliter,10Microliter},{50Microliter,0Microliter}}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionCurve,"Specify multiple types of dilution curves:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				DilutionCurve->{{{40Microliter,10Microliter},{50Microliter,0Microliter}},Null,Null},
				SerialDilutionCurve->{Null,Null,{50 Microliter, {0.7,5}}},
				Output -> Options
			];
			Lookup[options,DilutionCurve],
			{{{40Microliter,10Microliter},{50Microliter,0Microliter}},Null,Null},
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Specify multiple types of dilution curves:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				DilutionCurve->{{{40Microliter,10Microliter},{50Microliter,0Microliter}},Null,Null},
				SerialDilutionCurve->{Null,Null,{50 Microliter, {0.7,5}}}];
			Download[protocol,Dilutions],
			{{{40Microliter,10Microliter},{50Microliter,0Microliter}},Null,Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionCurve,"Specify a custom dilution curve with dilution factors:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->{{50Microliter,0.8},{50Microliter,0.5}},
				Output -> Options
			];
			Lookup[options,DilutionCurve],
			{{50Microliter,0.8},{50Microliter,0.5}},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Specify a custom dilution curve with dilution factors:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],DilutionCurve->{{50Microliter,0.8},{50Microliter,0.5}}];
			Download[protocol,Dilutions],
			{
				{{40. Microliter,10 Microliter},
				{25. Microliter,25.Microliter}}
			},
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionCurve,"Specify a null dilution curve:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->Null,
				Output -> Options
			];
			Lookup[options,DilutionCurve],
			Null,
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Specify a null dilution curve:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],DilutionCurve->Null];
			Download[protocol,Dilutions],
			{Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionCurve,"Resolve to a null dilution curve:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{50 Microliter,50 Microliter,20},
				Output -> Options
			];
			Lookup[options,DilutionCurve],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,Diluent,"Specify a null diluent:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Diluent->Null,
				Output -> Options
			];
			Lookup[options,Diluent],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,SingleSamplePerProbe,"Specify a SingleSamplePerProbe:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SingleSamplePerProbe->False,
				CleaningMethod->Burn,
				Output -> Options
			];
			Lookup[options,SingleSamplePerProbe],
			False,
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Specify a SingleSamplePerProbe:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				SingleSamplePerProbe->False,
				CleaningMethod->Burn
			];
			Download[protocol,SingleSamplePerProbe],
			False,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Diluent,"Specify a null diluent:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Diluent->Null];
			Download[protocol,Diluents],
			{Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,Diluent,"Specify a diluent sample:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Diluent->Model[Sample,"Dimethyl sulfoxide"],
				Output -> Options
			];
			Lookup[options,Diluent],
			ObjectP[Model[Sample,"Dimethyl sulfoxide"]],
			Variables:>{options}
		],
		Example[{Options,Diluent,"Specify a diluent sample:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Diluent->Model[Sample,"Dimethyl sulfoxide"]];
			Download[protocol,Diluents],
			{ObjectP[Model[Sample,"Dimethyl sulfoxide"]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,Diluent,"Resolve a diluent sample to water:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Diluent->Automatic,
				SerialDilutionCurve->{50Microliter,50Microliter,20},
				Output -> Options
			];
			Lookup[options,Diluent],
			Model[Sample,"Milli-Q water"],
			Variables:>{options}
		],
		Example[
			{Options,Diluent,"Resolve a diluent sample to Null:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->Null,
				Output -> Options
			];
			Lookup[options,Diluent],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,DilutionContainer,"Specify a dilution container for the sample:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionContainer->{1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]},
				Output -> Options
			];
			Lookup[options,DilutionContainer],
			{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},
			Variables:>{options}
		],
		Example[{Options,DilutionContainer,"Specify a dilution container for the sample:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionContainer->{1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]}];
			Download[protocol,DilutionContainers],
			{ObjectP[Model[Container, Plate]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionContainer,"Specify multiple dilution containers for the sample:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				DilutionCurve -> {Automatic, {{30 Microliter, 20 Microliter}},Automatic},
				DilutionContainer->{{1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]},{2,Model[Container,Vessel,"2mL Tube"]},Null},
				Output -> Options
			];
			Lookup[options,DilutionContainer],
			{{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},{2,ObjectP[Model[Container,Vessel,"2mL Tube"]]},{3,Null}},
			Variables:>{options}
		],
		Example[{Options,DilutionContainer,"Specify muiltiple dilution container  for the sample:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				DilutionCurve -> {Automatic, {{30 Microliter, 20 Microliter}},Automatic},
				DilutionContainer->{{1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]},{2,Model[Container,Vessel,"2mL Tube"]},Automatic}];
			Download[protocol,DilutionContainers],
			{ObjectP[Model[Container,Plate]],ObjectP[Model[Container,Vessel]],ObjectP[Model[Container,Plate]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionContainer,"Specify multiple dilution containers with no grouping for the sample and resolve to the same container:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				DilutionCurve -> {Automatic, {{30 Microliter, 20 Microliter}},Automatic},
				DilutionContainer->{Model[Container, Plate,"96-well 2mL Deep Well Plate"],Model[Container, Plate,"96-well 2mL Deep Well Plate"],Model[Container, Plate,"96-well 2mL Deep Well Plate"]},
				Output -> Options
			];
			Lookup[options,DilutionContainer],
			{{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]}},
			Variables:>{options}
		],
		Example[
			{Options,DilutionContainer,"Specify multiple dilution containers with no grouping for the sample and resolve to two containers:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				SerialDilutionCurve -> {{50Microliter,50Microliter,35}, {50Microliter,50Microliter,35},{50Microliter,50Microliter,35}},
				DilutionContainer->{Model[Container, Plate,"96-well 2mL Deep Well Plate"],Model[Container, Plate,"96-well 2mL Deep Well Plate"],Model[Container, Plate,"96-well 2mL Deep Well Plate"]},
				Output -> Options
			];
			Lookup[options,DilutionContainer],
			{{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},{2,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]}},
			Variables:>{options}
		],
		Example[
			{Options,DilutionContainer,"Specify multiple different dilution containers with no grouping for the sample and resolve to two containers:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				SerialDilutionCurve -> {{50Microliter,50Microliter,35}, {50Microliter,50Microliter,35},{50Microliter,50Microliter,35}},
				DilutionContainer->{Model[Container, Plate, "96-well Round Bottom Plate"],Model[Container, Plate,"96-well 2mL Deep Well Plate"],Model[Container, Plate, "96-well Round Bottom Plate"]},
				Output -> Options
			];
			Lookup[options,DilutionContainer],
			{{1,ObjectP[Model[Container, Plate, "96-well Round Bottom Plate"]]},{2,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},{1,ObjectP[Model[Container, Plate, "96-well Round Bottom Plate"]]}},
			Variables:>{options}
		],
		Example[
			{Options,DilutionContainer,"Specify multiple different dilution containers with no grouping and an Automatic input for the sample and resolve to two containers:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				SerialDilutionCurve -> {{50Microliter,50Microliter,35}, {50Microliter,50Microliter,35},{50Microliter,50Microliter,35}},
				DilutionContainer->{Model[Container, Plate,"96-well 2mL Deep Well Plate"],Model[Container, Plate, "96-well Round Bottom Plate"],Automatic},
				Output -> Options
			];
			Lookup[options,DilutionContainer],
			{{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},{2,ObjectP[Model[Container, Plate, "96-well Round Bottom Plate"]]},{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]}},
			Variables:>{options}
		],
		Example[
			{Options,DilutionContainer,"Specify multiple different dilution containers with some grouping and an Automatic input for the sample and resolve to two containers:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				SerialDilutionCurve -> {{50Microliter,50Microliter,35}, {50Microliter,50Microliter,35},{50Microliter,50Microliter,35}},
				DilutionContainer->{{1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]},Model[Container, Plate, "96-well Round Bottom Plate"],Automatic },
				Output -> Options
			];
			Lookup[options,DilutionContainer],
			{{1,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]},{2,ObjectP[Model[Container, Plate, "96-well Round Bottom Plate"]]},{3,ObjectP[Model[Container, Plate,"96-well 2mL Deep Well Plate"]]}},
			Variables:>{options}
		],
		Example[
			{Options,DilutionMixVolume,"Specify a Mix Volume to dilute the sample:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionMixVolume->40Microliter,
				Output -> Options
			];
			Lookup[options,DilutionMixVolume],
			40Microliter,
			Variables:>{options}
		],
		Example[{Options,DilutionMixVolume,"Specify a Mix Volume to dilute the sample:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionMixVolume->40Microliter];
			Download[protocol,DilutionMixVolumes],
			{40. Microliter},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionMixVolume,"Resolve a Mix Volume from a serial dilution Curve to dilute the sample:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{50 Microliter,50Microliter,20},
				Output -> Options
			];
			Lookup[options,DilutionMixVolume],
			50 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,DilutionMixVolume,"Resolve a Mix Volume from a dilution Curve to dilute the sample:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->{{20 Microliter,30Microliter}},
				Output -> Options
			];
			Lookup[options,DilutionMixVolume],
			40 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,DilutionNumberOfMixes,"Specify a mixing number to dilute the sample:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionNumberOfMixes->10,
				Output -> Options
			];
			Lookup[options,DilutionNumberOfMixes],
			10,
			Variables:>{options}
		],
		Example[{Options,DilutionNumberOfMixes,"Specify a mixing number to dilute the sample:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionNumberOfMixes->10];
			Download[protocol,DilutionNumberOfMixes],
			{10},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,DilutionMixRate,"Specify a mixing rate to dilute the sample:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionMixRate->50Microliter/Second,
				Output->Options
			];
			Lookup[options,DilutionMixRate],
			50Microliter/Second,
			Variables:>{options}
		],

		Example[
			{Options,DilutionStorageCondition,"Specify a storage condition for the leftover samples:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionStorageCondition->Refrigerator,
				OutputFormat -> List
			];
			Lookup[options,DilutionStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SamplesOutStorageCondition,"Specify a storage condition for the plate after it is measured:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SamplesOutStorageCondition->Refrigerator,
				OutputFormat -> List
			];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,ContainerOut,"Specify a container for samples in the assay plate to be transferred to after it is measured:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				ContainerOut->Model[Container, Vessel, "2mL Tube"],
				SamplesOutStorageCondition->Refrigerator,
				OutputFormat -> List
			];
			Lookup[options,ContainerOut],
			ObjectP[Model[Container, Vessel, "2mL Tube"]],
			Variables:>{options}
		],
		Example[
			{Options,ContainerOut,"Specify a container for samples in the assay plate to be transferred to after it is measured:"},
			protocol=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				ContainerOut->Model[Container, Vessel, "2mL Tube"],
				SamplesOutStorageCondition->Refrigerator
			];
			Download[protocol,ContainersOut],
			{ObjectP[Model[Container,Vessel]]..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,ContainerOut,"Resolve a Null container for samples in the assay plate to be transferred to after it is measured:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				OutputFormat -> List
			];
			Lookup[options,ContainerOut],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,ContainerOut,"Resolve a Null container for samples in the assay plate to be transferred to after it is measured:"},
			protocol=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]}
			];
			Download[protocol,ContainersOut],
			{},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,ContainerOut,"Resolve a plate for samples in the assay plate to be transferred to after it is measured:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SamplesOutStorageCondition->Refrigerator,
				OutputFormat -> List
			];
			Lookup[options,ContainerOut],
			ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
			Variables:>{options}
		],
		Example[
			{Options,ContainerOut,"Resolve a plate for samples in the assay plate to be transferred to after it is measured:"},
			protocol=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SamplesOutStorageCondition->Refrigerator
			];
			Download[protocol,ContainersOut],
			{ObjectP[Model[Container]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,NumberOfCalibrationMeasurements,"Specify the number of times the probes are calibrated plate is measured:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				NumberOfCalibrationMeasurements->5,
				OutputFormat -> List
			];
			Lookup[options,NumberOfCalibrationMeasurements],
			5,
			Variables:>{options}
		],
		Example[
			{Options,Calibrant,"Specify a calibrant solution:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Calibrant->Model[Sample, "Milli-Q water"],
				OutputFormat -> List
			];
			Lookup[options,Calibrant],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],
			Example[{Options,Calibrant,"Specify a calibrant solution:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Calibrant->Model[Sample, "Milli-Q water"]
			];
			Download[protocol,Calibrant],
				{ObjectP[Model[Sample]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,Calibrant,"Resolve a calibrant  to water from Null Diluents:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				Diluent->{Null,Null,Null},
				OutputFormat -> List
			];
			Lookup[options,Calibrant],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,Calibrant,"Resolve a calibrant  to water from water Diluents:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				Diluent->{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				OutputFormat -> List
			];
			Lookup[options,Calibrant],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,Calibrant,"Resolve a calibrant  to water from multiple Diluents:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				Diluent->{Model[Sample,"Dimethyl sulfoxide"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				OutputFormat -> List
			];
			Lookup[options,Calibrant],
			Model[Sample, "Milli-Q water"],
			Variables:>{options}
		],
		Example[
			{Options,Calibrant,"Resolve a calibrant to DMSO from DMSO Diluents:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				Diluent->{Model[Sample,"Dimethyl sulfoxide"],Model[Sample,"Dimethyl sulfoxide"],Model[Sample,"Dimethyl sulfoxide"]},
				OutputFormat -> List
			];
			Lookup[options,Calibrant],
			Model[Sample, "Milli-Q water"],
			Variables:>{options}
		],
		Example[
			{Options,Calibrant,"Resolve a calibrant  to DMSO from DMSO Diluents:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				Diluent->{Model[Sample,"Dimethyl sulfoxide"],Model[Sample,"Dimethyl sulfoxide"],Model[Sample,"Dimethyl sulfoxide"]}];
			Download[protocol,Calibrant],
			{ObjectP[Model[Sample]]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,Calibrant,"Resolve a calibrant to water from DMSO Diluent:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				Diluent->Model[Sample,"Dimethyl sulfoxide"],
				OutputFormat -> List
			];
			Lookup[options,Calibrant],
			Model[Sample, "Milli-Q water"],
			Variables:>{options}
		],
		Example[
			{Options,CalibrantSurfaceTension,"Specify a calibrant surfaceTension:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CalibrantSurfaceTension->	72.8Milli Newton/Meter,
				OutputFormat -> List
			];
			Lookup[options,CalibrantSurfaceTension],
			72.8Milli Newton/Meter,
			Variables:>{options}
		],
		Example[{Options,CalibrantSurfaceTension,"Specify a calibrant surfaceTension:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CalibrantSurfaceTension->	72.8Milli Newton/Meter];
			Download[protocol,CalibrantSurfaceTension],
			72.8Milli Newton/Meter,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,CalibrantSurfaceTension,"Resolve a calibrant surfaceTension from the field of the calibrant:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Calibrant->	Model[Sample, "Milli-Q water"],
				OutputFormat -> List
			];
			Lookup[options,CalibrantSurfaceTension],
			72.8Milli Newton/Meter,
			Variables:>{options}
		],
		Example[
			{Options,MaxCalibrationNoise,"Specify a max calibration noise:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				MaxCalibrationNoise->	0.2Milli Newton/Meter,
				OutputFormat -> List
			];
			Lookup[options,MaxCalibrationNoise],
			0.2Milli Newton/Meter,
			Variables:>{options}
		],
		Example[
			{Options,EquilibrationTime,"Specify a equillibration time:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				EquilibrationTime->	30 Minute,
				OutputFormat -> List
			];
			Lookup[options,EquilibrationTime],
			30 Minute,
			Variables:>{options}
		],
		Example[
			{Options,NumberOfSampleMeasurements,"Specify how many times each sample is measured:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				NumberOfSampleMeasurements->	5,
				OutputFormat -> List
			];
			Lookup[options,NumberOfSampleMeasurements],
			5,
			Variables:>{options}
		],
		Example[
			{Options,ProbeSpeed,"Specify the speed the probe is moved to take a measurement:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				ProbeSpeed->	70 Percent,
				OutputFormat -> List
			];
			Lookup[options,ProbeSpeed],
			70 Percent,
			Variables:>{options}
		],
		Example[
			{Options,MaxDryNoise,"Specify the noise allowed in air before taking a measurement:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				MaxDryNoise->0.2Milli Newton/Meter,
				OutputFormat -> List
			];
			Lookup[options,MaxDryNoise],
			0.2Milli Newton/Meter,
			Variables:>{options}
		],
		Example[
			{Options,MaxWetNoise,"Specify the noise allowed in water before taking a measurement:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				MaxWetNoise->0.2Milli Newton/Meter,
				OutputFormat -> List
			];
			Lookup[options,MaxWetNoise],
			0.2Milli Newton/Meter,
			Variables:>{options}
		],
		Example[
			{Options,SingleSamplePerProbe,"Resolve that a probe will measure more than one sample if there is no dilution and more than eight samples:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
					Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
					Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
					Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
					Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]
				},
				CleaningMethod->Burn,
				Diluent->Null,
				OutputFormat -> List
			];
			Lookup[options,SingleSamplePerProbe],
			False,
			Variables:>{options}
		],
		Example[
			{Options,SingleSamplePerProbe,"Resolve that a probe will only measure one sample:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				OutputFormat -> List
			];
			Lookup[options,SingleSamplePerProbe],
			True,
			Variables:>{options}
		],
		Example[
			{Options,PreCleaningMethod,"Specify the burning cleaning method before taking a measurement:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				PreCleaningMethod->Burn,
				OutputFormat -> List
			];
			Lookup[options,PreCleaningMethod],
			Burn,
			Variables:>{options}
		],
			Example[{Options,PreCleaningMethod,"Specify the burning cleaning method before taking a measurement:"},
				protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
					PreCleaningMethod->Burn];
				Download[protocol,PreCleaningMethod],
				{Burn},
				TearDown:>(
					EraseObject[$CreatedObjects,Force->True,Verbose->False];
					Unset[$CreatedObjects]
				)
			],
		Example[
			{Options,PreCleaningMethod,"Specify the solution cleaning method before taking a measurement:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				PreCleaningMethod->Solution,
				OutputFormat -> List
			];
			Lookup[options,PreCleaningMethod],
			Solution,
			Variables:>{options}
		],
		Example[
			{Options,PreCleaningMethod,"Specify the solution cleaning method before taking a measurement:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],PreCleaningMethod->Solution];
			Download[protocol,PreCleaningMethod],
			{Solution},
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,CleaningMethod,"Specify the burn cleaning method before taking each measurement:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CleaningMethod->Burn,
				OutputFormat -> List
			];
			Lookup[options,CleaningMethod],
			Burn,
			Variables:>{options}
		],
		Example[{Options,CleaningMethod,"Specify the burn cleaning method before taking each measurement:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CleaningMethod->Burn];
			Download[protocol,CleaningMethod],
			{Burn},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,CleaningMethod,"Specify the solution cleaning method before taking each measurement:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CleaningMethod->Solution,
				OutputFormat -> List
			];
			Lookup[options,CleaningMethod],
			Solution,
			Variables:>{options}
		],
		Example[{Options,CleaningMethod,"Specify the solution cleaning method before taking each measurement:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CleaningMethod->Solution];
			Download[protocol,CleaningMethod],
			{Solution},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,CleaningSolution,"Specify the first cleaning solution used to clean the probes:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CleaningSolution->Model[Sample,"Dimethyl sulfoxide"],
				OutputFormat -> List
			];
			Lookup[options,CleaningSolution],
			ObjectP[Model[Sample,"Dimethyl sulfoxide"]],
			Variables:>{options}
		],
		Example[
			{Options,SecondaryCleaningSolution,"Specify the first cleaning solution used to clean the probes:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SecondaryCleaningSolution->Null,
				OutputFormat -> List
			];
			Lookup[options,SecondaryCleaningSolution],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,TertiaryCleaningSolution,"Specify the first cleaning solution used to clean the probes:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				TertiaryCleaningSolution->Model[Sample,"Dimethyl sulfoxide"],
				OutputFormat -> List
			];
			Lookup[options,TertiaryCleaningSolution],
			ObjectP[Model[Sample,"Dimethyl sulfoxide"]],
			Variables:>{options}
		],
		Example[{Options,CleaningSolution,"Specify the cleaning solution used to clean the probes:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CleaningSolution->Model[Sample,"Dimethyl sulfoxide"]];
			Download[protocol,CleaningSolutions],
			{ObjectP[Model[Sample]],ObjectP[Model[Sample]],Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,PreheatingTime,"Specify the time the probes will be preheated before the main clean:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				PreheatingTime->0.5 Second,
				OutputFormat -> List
			];
			Lookup[options,PreheatingTime],
			0.5 Second,
			Variables:>{options}
		],
		Example[
			{Options,BurningTime,"Specify the time the probes will be heated during the main clean:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				BurningTime->9 Second,
				OutputFormat -> List
			];
			Lookup[options,BurningTime],
			9 Second,
			Variables:>{options}
		],
		Example[
			{Options,CoolingTime,"Specify the time the probes will be cooled after the main clean:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				CoolingTime->9 Second,
				OutputFormat -> List
			];
			Lookup[options,CoolingTime],
			9 Second,
			Variables:>{options}
		],
		Example[
			{Options,BetweenMeasurementBurningTime,"Specify the time the probes will be heated during the main clean between measurements:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				BetweenMeasurementBurningTime->4 Second,
				OutputFormat -> List
			];
			Lookup[options,BetweenMeasurementBurningTime],
			4 Second,
			Variables:>{options}
		],
		Example[
			{Options,BetweenMeasurementCoolingTime,"Specify the time the probes will be cooled after the main clean  between measurements:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				BetweenMeasurementCoolingTime->6 Second,
				OutputFormat -> List
			];
			Lookup[options,BetweenMeasurementCoolingTime],
			6 Second,
			Variables:>{options}
		],
		Example[
			{Options,MaxCleaningNoise,"Specify the noise allowed in air before taking cleaning:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				MaxCleaningNoise->0.2 Milli Newton / Meter,
				OutputFormat -> List
			];
			Lookup[options,MaxCleaningNoise],
			0.2 Milli Newton / Meter,
			Variables:>{options}
		],
		Example[{Options, PreparedPlate, "Specify that the samples are in a PreparedPlate:"},
			options = ExperimentMeasureSurfaceTensionOptions[Object[Container, Plate, "Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID], PreparedPlate -> True, OutputFormat -> List];
			Lookup[options, PreparedPlate],
			True,
			Variables :> {options}
		],
		Example[{Options, PreparedPlate, "Specify that the samples are in a PreparedPlate:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Container, Plate, "Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID], PreparedPlate -> True];
			Download[protocol,PreparedPlate],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
				Example[{Options, PreparedPlate, "Specify that the samples are in two PreparedPlates:"},
					protocol=ExperimentMeasureSurfaceTension[{Object[Container, Plate, "Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID], Object[Container, Plate, "Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}, PreparedPlate -> True];
					Download[protocol,PreparedPlate],
					True,
					SetUp:>($CreatedObjects={}),
					TearDown:>(
						EraseObject[$CreatedObjects,Force->True,Verbose->False];
						Unset[$CreatedObjects]
					)
				],
		Example[{Options, SampleLoadingVolume, "Specify the volume used to load the samples on the assay plate:"},
			options = ExperimentMeasureSurfaceTensionOptions[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], SampleLoadingVolume -> 55 Microliter, OutputFormat -> List];
			Lookup[options, SampleLoadingVolume],
			55 Microliter,
			Variables :> {options}
		],
		Example[{Options, SampleLoadingVolume, "Specify the volume used to load the samples on the assay plate:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], SampleLoadingVolume -> 55 Microliter];
			Download[protocol,SampleLoadingVolume],
			55. Microliter,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "ContainerOutMismatch", "If a non disposal storage condition is given with no containers out, a error will by thrown:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				ContainerOut->Null,
				SamplesOutStorageCondition->Refrigerator],
			$Failed,
			Messages :> {
				Error::ContainerOutMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SamplesOutStorageConditionMismatch", "If a containers out is given with no storage condition, a warning will by thrown:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				ContainerOut->Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			Messages :> {
				Warning::SamplesOutStorageConditionMismatch
			}
		],
		Example[{Messages, "MeasureSurfaceTesnsionContainerOutConflictingStorage", "If the samples out storage condition varies between samples, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				ContainerOut->Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				SamplesOutStorageCondition->{Freezer,Disposal}],
			$Failed,
			Messages :> {
				Error::MeasureSurfaceTesnsionContainerOutConflictingStorage,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatableDilutionContainer", "If the sample manipulation cannot be done on the liquid handler because of the containers, throw an error:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionContainer -> {{2, Model[Container, Vessel, "1L Glass Bottle"]}, {1, Model[Container, Vessel, "250mL Glass Bottle"]}}
			],
			$Failed,
			Messages :> {
				Error::IncompatableDilutionContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MultipleAssayPlates", "If a samples that take up more than one assay plate are given, a warning will by thrown:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
					Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->Null, SingleSamplePerProbe->True],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			Messages :> {
				Warning::MultipleAssayPlates
			}
		],
		Example[{Messages, "ConflictingDilutionMixSettings", "If a samples with conflicting dilution mix settings are given, an error will by thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],SerialDilutionCurve->{50Microliter,50Microliter,10},DilutionMixVolume->Null],
			$Failed,
			Messages :> {
				Error::ConflictingDilutionMixSettings,
				Warning::MissingDilutionMixVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingPreparedPlateDilution", "If a prepared plate is given and dilution options are not Null, an error will by thrown:"},
			ExperimentMeasureSurfaceTension[Object[Container, Plate, "Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID], PreparedPlate -> True, DilutionCurve->{{40 Microliter,10 Microliter},{50 Microliter,0 Microliter}}],
			$Failed,
			Messages :> {
				Error::ConflictingPreparedPlateDilution,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidAssayPlate", "If a prepared plate is given and the samples are not in an appropriate assay plate, an error will by thrown:"},
			ExperimentMeasureSurfaceTension[Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID], PreparedPlate -> True],
			$Failed,
			Messages :> {
				Error::InvalidAssayPlate,
				Error::NoCalibrantProvided,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoCalibrantProvided", "If a prepared plate is given and the samples and there is no calibrant in the plate, an error will by thrown:"},
			ExperimentMeasureSurfaceTension[Object[Container,Plate,"Test dyneplate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID], PreparedPlate -> True],
			$Failed,
			Messages :> {
				Error::NoCalibrantProvided,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingPreparedPlateCalibrants","Warn that the calibrant samples in PreparedPlate do not have the same composition:"},
			ExperimentMeasureSurfaceTension[Object[Container, Plate, "Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],PreparedPlate->True],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			Messages:>{
				Warning::ConflictingPreparedPlateCalibrants
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"PreparedPlateFalse","Warn that the samples are in an assay plate but PreparedPlate is False:"},
			options=ExperimentMeasureSurfaceTensionOptions[Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				OutputFormat -> List
			];
			Lookup[options,PreparedPlate],
			False,
			Messages:>{
				Warning::PreparedPlateFalse,
				Warning::InsufficientVolume

			},
			Variables :> {options}
		],
		Example[{Messages,"PreparedPlateFalse","Warn that the samples are in an assay plate but PreparedPlate is False:"},
			ExperimentMeasureSurfaceTension[Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			Messages:>{
				Warning::PreparedPlateFalse,
				Warning::InsufficientVolume
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "DilutionContainerInsufficientVolume", "If the dilution container is too small, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID],DilutionCurve -> {{0.01 Milliliter, 3 Milliliter}}],
			$Failed,
			Messages :> {
				Error::DilutionContainerInsufficientVolume,
				Error::InvalidOption,
				Warning::DilutionCurveExcessVolume
			}
		],
		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 4"<> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"MustSpecifyDiluent", "If a dilution curve is given with no diluent, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],SerialDilutionCurve->{50Microliter,50Microliter,10},Diluent->Null],
			$Failed,
			Messages :> {
				Error::MustSpecifyDiluent,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MissingDilutionContainer", "If a dilution curve is given with no dilution container, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],SerialDilutionCurve->{50Microliter,50Microliter,10},DilutionContainer->Null],
			$Failed,
			Messages :> {
				Error::MissingDilutionContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingDilutionContainer", "If multiple dilution containers are given with the same index, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionContainer->{{1,Model[Container,Vessel,"2mL Tube"]}, {1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]}}
			],
			$Failed,
			Messages :> {
				Error::ConflictingDilutionContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MustSpecifyCleaningSolution", "If a cleaning method with solution is given and the cleaning solution is null, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],CleaningMethod->{Solution,Burn},CleaningSolution->Null, SecondaryCleaningSolution->Null],
			$Failed,
			Messages :> {
				Error::MustSpecifyCleaningSolution,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingCleaningSolution", "If a cleaning solution is given and cleaning method solution is not given, a warning will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				CleaningMethod->Burn,
				PreCleaningMethod->Burn,
				CleaningSolution->Null,
				SecondaryCleaningSolution->Model[Sample,"Milli-Q water"]],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			Messages :> {
				Warning::ConflictingCleaningSolution
			}
		],
		Example[{Messages,"CannotSpecifyBothDilutionCurveAndSerialDilutionCurve", "If both a serial dilution curve and a custom dilution curve is given, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],SerialDilutionCurve->{50Microliter,50Microliter,10},DilutionCurve->{{50Microliter,80Microliter},{50Microliter,30Microliter}}],
			$Failed,
			Messages :> {
				Error::CannotSpecifyBothDilutionCurveAndSerialDilutionCurve,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InsufficientDilutionCurveVolume", "If any sample in the dilution curve has a volume below 50ul, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],DilutionCurve->{{30Microliter,10Microliter},{10Microliter,30Microliter}}],
			$Failed,
			Messages :> {
				Error::InsufficientDilutionCurveVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DilutionContainerConflictingStorage", "If any the dilution container has samples that have different storage conditions, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				DilutionContainer->{{1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]},{1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]},{1,Model[Container, Plate,"96-well 2mL Deep Well Plate"]}},
				DilutionStorageCondition->{Refrigerator,Disposal,Disposal}
			],
			$Failed,
			Messages :> {
				Error::DilutionContainerConflictingStorage,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MissingCalibrantSurfaceTension", "If a calibrant is givin without a known surface tension is given, an error will be thrown:"},
			ExperimentMeasureSurfaceTension[Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],Calibrant->Model[Sample,"Dimethyl sulfoxide"]],
			$Failed,
			Messages :> {
				Error::MissingCalibrantSurfaceTension,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DilutionCurveExcessVolume","Warn that there will be excess sample from a serial dilution curve:"},

			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{50 Microliter,170Microliter,20},
				OutputFormat -> List
			];

			Lookup[options,SerialDilutionCurve],
			{50 Microliter,170 Microliter,20},
			Messages:>{
				Warning::DilutionCurveExcessVolume
			},
			Variables :> {options}
		],
		Example[{Messages,"DilutionCurveExcessVolume","Warn that there will be excess sample from a serial dilution curve:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->{50 Microliter,170Microliter,20}],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			Messages:>{
				Warning::DilutionCurveExcessVolume
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"MissingDilutionCurve","Warn that there will be no dilution even though a diluent was given:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->Null,
				Diluent->Model[Sample, "Milli-Q water"],
				OutputFormat -> List
			];
			Lookup[options,Diluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Messages:>{
				Warning::MissingDilutionCurve
			},
			Variables :> {options}
		],
		Example[{Messages,"MissingCleaningMethod","Warn that there will be no cleaning between measurements, even though multiple samples are measured per probe:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SingleSamplePerProbe -> False,
				CleaningMethod -> Null,
				OutputFormat -> List
			];
			Lookup[options,SingleSamplePerProbe],
			False,
			Messages:>{
				Warning::MissingCleaningMethod
			},
			Variables :> {options}
		],
		Example[{Messages,"MissingCleaningMethod","Warn that there will be no cleaning between measurements, even though multiple samples are measured per probe:"},
			ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SingleSamplePerProbe -> False,
				CleaningMethod -> Null
			],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			Messages:>{
				Warning::MissingCleaningMethod
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"MissingDilutionCurve","Warn that there will be no dilution even though a diluent was given:"},
			ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->Null,
				Diluent->Model[Sample, "Milli-Q water"]],
			ObjectP[Object[Protocol, MeasureSurfaceTension]],
			Messages:>{
				Warning::MissingDilutionCurve
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"MissingDilutionMixVolume","Warn that there no dilution mix volume was given even though there is diluting:"},
			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->{{50 Microliter,0.9},{50 Microliter,0.8}},
				DilutionMixVolume->Null,
				OutputFormat -> List
			];
			Lookup[options,DilutionMixVolume],
			Null,
			Messages:>{
				Warning::MissingDilutionMixVolume,
				Error::ConflictingDilutionMixSettings,
				Error::InvalidOption
			},
			Variables :> {options}
		],
		Example[{Messages,"ConflictingDilutionMixVolume","Warn that there no dilution was given even though there was a dilution mix volume specified:"},

			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->Null,
				DilutionMixVolume->40 Microliter,
				OutputFormat -> List
			];

			Lookup[options,DilutionMixVolume],
			40 Microliter,
			Messages:>{
				Warning::ConflictingDilutionMixVolume
			},
			Variables :> {options}
		],
		Example[{Messages,"MissingDilutionNumberOfMixes","Warn that a dilution was given even though the dilution number of mixes was set to null:"},

			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->{{50 Microliter,0.9},{50 Microliter,0.8}},
				DilutionNumberOfMixes->Null,
				OutputFormat -> List
			];

			Lookup[options,DilutionNumberOfMixes],
			Null,
			Messages:>{
				Warning::MissingDilutionNumberOfMixes,
				Error::ConflictingDilutionMixSettings,
				Error::InvalidOption

			},
			Variables :> {options}
		],
		Example[{Messages,"MissingDilutionMixRate","Warn that a dilution was given even though the dilution mix rate was set to null:"},

			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				DilutionCurve->{{50 Microliter,0.9},{50 Microliter,0.8}},
				DilutionMixRate->Null,
				OutputFormat -> List
			];

			Lookup[options,DilutionMixRate],
			Null,
			Messages:>{
				Warning::MissingDilutionMixRate,
				Error::ConflictingDilutionMixSettings,
				Error::InvalidOption
			},
			Variables :> {options}
		],
		Example[{Messages,"CalibrantSurfaceTensionMismatch","Warn that a dilution was given even though the dilution mix rate was set to null:"},

			options=ExperimentMeasureSurfaceTensionOptions[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				Calibrant->Model[Sample, "Milli-Q water"],
				CalibrantSurfaceTension->70Milli Newton/Meter,
				OutputFormat -> List
			];

			Lookup[options,CalibrantSurfaceTension],
			70Milli Newton/Meter,
			Messages:>{
				Warning::CalibrantSurfaceTensionMismatch
			},
			Variables :> {options}
		],
		Example[
			{Options,Template,"Specify a template protocol whose methodology should be reproduced in running this experiment:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},Template->Null];
			Download[protocol,Template],
			Null,
			Variables:>{protocol}
		],
		Example[
			{Options,Name,"Specify a name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			protocol=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				Name->"My particular ExperimentMeasureSurfaceTension protocol"<>$SessionUUID
			];
			Download[protocol,Name],
			"My particular ExperimentMeasureSurfaceTension protocol"<>$SessionUUID,
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,Incubate,"Specify if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				Incubate->True,
				Output->Options
			];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[
			{Options,IncubationTemperature,"Specify the temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				IncubationTemperature->40 Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			40 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,IncubationTime,"Specify duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				IncubationTime->40 Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			40 Minute,
			Variables:>{options}
		],
		Example[
			{Options,Mix,"Specify the samples should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				Mix->True,
				Output->Options
			];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MixType,"Specify the style of motion used to mix the samples, prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				MixType->Vortex,
				Output->Options
			];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[
			{Options,MixUntilDissolved,"Specify if the samples should be mixed in an attempt dissolve any solute prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				MixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MaxIncubationTime,"Specify Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				MaxIncubationTime->1 Hour,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,IncubationInstrument,"Specify the instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				IncubationInstrument->Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables:>{options}
		],
		Example[
			{Options,AnnealingTime,"Specify minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				AnnealingTime->20 Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			20 Minute,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquotContainer,"Specify the container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquotDestinationWell,"Specify the position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				IncubateAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				IncubateAliquot->0.5*Milliliter,
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,Centrifuge,"Specify if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				Centrifuge->True,
				Output->Options
			];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeInstrument,"Specify the centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				CentrifugeInstrument->Model[Instrument, Centrifuge, "Avanti J-15R"],
				Output->Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeIntensity,"Specify the rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				CentrifugeIntensity->1000 RPM,
				Output -> Options
			];
			Lookup[options,CentrifugeIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeTime,"Specify the amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				CentrifugeTime->2 Minute,
				Output -> Options
			];
			Lookup[options,CentrifugeTime],
			2 Minute,
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeTemperature,"Specify the temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				CentrifugeTemperature->10 Celsius,
				Output -> Options
			];
			Lookup[options,CentrifugeTemperature],
			10 Celsius,
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeAliquotContainer,"Specify the desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				CentrifugeAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				CentrifugeAliquotDestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				CentrifugeAliquot->0.9 Milliliter,
				Output -> Options
			];
			Lookup[options,CentrifugeAliquot],
			0.9 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,Filtration,"Specify if the SamplesIn should be filter prior to starting the experiment or any aliquoting:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				Filtration->True,
				Output -> Options
			];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[
			{Options,FiltrationType,"Specify the type of filtration method that should be used to perform the filtration:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				FiltrationType->Syringe,
				Output -> Options
			];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[
			{Options,FilterInstrument,"Specify the instrument that should be used to perform the filtration:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Huge Test Sample"<> $SessionUUID],
				FilterInstrument->Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],
				Output -> Options
			];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,Filter,"Specify whether to filter in order to remove impurities from the input samples prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Huge Test Sample"<> $SessionUUID],
				Filter->Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"],
				Output -> Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"]],
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,FilterMaterial,"Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				FilterMaterial->PES,
				Output -> Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		Example[
			{Options,PrefilterMaterial,"Specify the material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				PrefilterMaterial->GxF,
				Output -> Options
			];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[
			{Options,FilterPoreSize,"Specify the pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				FilterPoreSize->0.22 Micrometer,
				Output -> Options
			];
			Lookup[options,FilterPoreSize],
			0.22 Micrometer,
			Variables:>{options}
		],
		Example[
			{Options,PrefilterPoreSize,"Specify the pore size of the filter; all particles larger than this should be removed during the filtration:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				PrefilterPoreSize -> 1.*Micrometer,
				FilterMaterial -> PTFE,
				Output -> Options
			];
			Lookup[options,PrefilterPoreSize],
			1.`*Micrometer,
			Variables:>{options}
		],
		Example[
			{Options,FilterSyringe,"Specify the syringe used to force that sample through a filter:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				FiltrationType -> Syringe,
				FilterSyringe->Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output -> Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options}
		],
		Example[
			{Options,FilterHousing,"Specify the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Huge Test Sample"<> $SessionUUID],
				FiltrationType -> PeristalticPump,
				FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"],
				Output -> Options
			];
			Lookup[options,FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,FilterIntensity,"Specify the rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				FilterIntensity->1000 RPM,
				Output -> Options
			];
			Lookup[options,FilterIntensity],
			1000 RPM,
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,FilterTime,"Specify the time for which the samples will be centrifuged during filtration:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Huge Test Sample"<> $SessionUUID],
				FilterTime->5 Minute,
				Output -> Options
			];
			Lookup[options,FilterTime],
			5 Minute,
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,FilterTemperature,"Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterTemperature->10 Celsius,
				Output -> Options
			];
			Lookup[options,FilterTemperature],
			10 Celsius,
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,FilterContainerOut,"Specify the container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				FilterContainerOut->Model[Container, Vessel, "250mL Glass Bottle"],
				Output -> Options
			];
			Lookup[options,FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "250mL Glass Bottle"]]},
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				FilterAliquotDestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquotContainer,"Specify the container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				FilterAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				FilterAliquot->0.9 Milliliter,
				Output -> Options
			];
			Lookup[options,FilterAliquot],
			0.9 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,FilterSterile,"Specify if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Huge Test Sample"<> $SessionUUID],
				FilterSterile->True,
				Output -> Options
			];
			Lookup[options,FilterSterile],
			True,
			Messages :> {Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[
			{Options,Aliquot,"Specify if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				Aliquot->True,
				Output -> Options
			];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[
			{Options,AliquotAmount,"Specify the amount of a sample that should be transferred from the input samples into aliquots:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				AliquotAmount->0.8 Milliliter,
				Output -> Options
			];
			Lookup[options,AliquotAmount],
			0.8 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"mySample1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			"mySample1",
			Variables:>{options}
		],
		Example[
			{Options,AssayVolume,"Specify the desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				AssayVolume->1 Milliliter,
				Output -> Options
			];
			Lookup[options,AssayVolume],
			1 Milliliter,
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedBuffer,"Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 500 Microliter,
				AliquotAmount -> 20 Microliter,
				Output -> Options
			];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables:>{options}
		],
		Example[
			{Options,BufferDilutionFactor,"Specify the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 500 Microliter,
				AliquotAmount -> 20 Microliter,
				Output -> Options
			];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,BufferDiluent,"Specify the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				BufferDiluent -> Model[Sample, "Methanol - LCMS grade"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 500 Microliter,
				AliquotAmount -> 20 Microliter,
				Output -> Options
			];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample, "Methanol - LCMS grade"]],
			Variables:>{options}
		],
		Example[
			{Options,AssayBuffer,"Specify the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 500 Microliter,
				AliquotAmount -> 20 Microliter,
				Output -> Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables:>{options}
		],
		Example[
			{Options,AliquotSampleStorageCondition,"Specify the non-default conditions under which any aliquot samples generated by this experiment should be stored after the options is completed:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				AliquotSampleStorageCondition->Refrigerator,
				Output -> Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,DestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				DestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,DestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[
			{Options,AliquotContainer,"Specify the container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.  This option will resolve to be the length of the SamplesIn * NumberOfReplicates:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				AliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options,AliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options}
		],
		Example[
			{Options,AliquotPreparation,"Specify the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				AliquotPreparation->Manual,
				Output -> Options
			];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[
			{Options,ConsolidateAliquots,"Specify if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				Aliquot->True, ConsolidateAliquots -> True,
				Output -> Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MeasureWeight,"Specify if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				MeasureWeight->False,
				Output -> Options
			];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[
			{Options,MeasureVolume,"Specify if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				MeasureVolume->False,
				Output -> Options
			];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{protocol}
		],
		Example[
			{Options,ImageSample,"Specify if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID]},
				ImageSample->False,
				Output -> Options
			];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		Example[
			{Options,TargetConcentration,"Specify the desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				TargetConcentration -> 45 Micromolar,
				Output -> Options];
			Lookup[options,TargetConcentration],
			45 Micromolar,
			Variables:>{options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentMeasureSurfaceTension[
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				TargetConcentration -> 5 Micromolar,
				TargetConcentrationAnalyte -> Model[Molecule, "Acetone"],
				Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Acetone"]],
			Variables :> {options}
		],
		Example[{Additional,"Specify enough samples to require two assay plates:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID]},
				NumberOfReplicates -> 3];
			Length[Download[protocol,AssayPlates]],
			2,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify no dilution and make the required resources:"},
			protocol=ExperimentMeasureSurfaceTension[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},
				SerialDilutionCurve->Null];
			{Length[Download[protocol,AssayPlates]],Download[protocol,DilutionContainers],Download[protocol,Diluents],Download[protocol,Dilutions],Download[protocol,SerialDilutions]},
			{1,{Null},{Null},{Null},{Null}},
					SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify a prepared plate and make the required resources:"},
			protocol=ExperimentMeasureSurfaceTension[Object[Container, Plate, "Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				PreparedPlate->True];
			{Length[Download[protocol,AssayPlates]],Download[protocol,DilutionContainers],Download[protocol,Diluents],Download[protocol,Dilutions],Download[protocol,SerialDilutions]},
			{0, {Null, Null, Null,Null, Null, Null,Null, Null, Null,Null}, {Null, Null, Null,Null, Null, Null,Null, Null, Null,Null}, {Null, Null, Null,Null, Null, Null,Null, Null, Null,Null}, {Null, Null, Null,Null, Null, Null,Null, Null, Null,Null}},
					SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, SamplesInStorageCondition, "Use the SamplesInStorageCondition option to set the StorageCondition to which the SamplesIn will be set at the end of the protocol:"},
			options = ExperimentMeasureSurfaceTensionOptions[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID], SamplesInStorageCondition -> Refrigerator, OutputFormat -> List];
			Lookup[options, SamplesInStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ImageDilutionContainers, "Use the ImageDilutionContainers option to set image the dilution contaners after mixing:"},
			options = ExperimentMeasureSurfaceTensionOptions[Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				ImageDilutionContainers -> True, OutputFormat -> List];
			Lookup[options, ImageDilutionContainers],
			True,
			Variables :> {options}
		],
		Test["The cleaning solution container resource is the same in the CleaningSolution and CleaningSolutionPlacements fields:",
			protocol=ExperimentMeasureSurfaceTensionOptions[{Object[Sample, "ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID]},CleaningSolution->Model[Sample,"Dimethyl sulfoxide"]];
			SameQ@@Cases[Download[protocol,RequiredResources],{x_,CleaningSolutionContainer|CleaningSolutionPlacements,__}:>Download[x,Object]],
			True,
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 2 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 2 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 2 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Test 2 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Test 2 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Test 2 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension Huge Test Sample"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTension No Model Test Sample"<> $SessionUUID],
				Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for big ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for huge ExperimentMeasureSurfaceTension tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for no model ExperimentMeasureSurfaceTension tests"<> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		(*module for ecreating objects*)
		Module[{containerPackets, container2Packets, samplePackets, vesselPackets, vessel2Packets,  vesselbigPackets,  vesselhugePackets, samplevesselPacket, sample3Packets,
			samplevessel2Packet, vesselnomodelPackets, bigsamplePacket, hugesamplePacket, nomodelsamplePacket, sample2Packets, container3Packets, containerPackets2, samplePackets2,
			container4aPackets, container4bPackets, sample4aPackets, sample4bPackets, container5Packets, sample5Packets},

			containerPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[containerPackets];

			containerPackets2 = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[containerPackets2];

			container2Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container2Packets];

			container3Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container3Packets];

			container4aPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container4aPackets];

			container4bPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container4bPackets];

			container5Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container5Packets];

			vesselPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"2mL Tube"], Objects],
					Name -> "Test vessel 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselPackets];

			vessel2Packets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"50mL Tube"], Objects],
					Name -> "Test vessel 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vessel2Packets];

			vesselbigPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"50mL Tube"], Objects],
					Name -> "Test vessel for big ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselbigPackets];

			vesselhugePackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "250mL Glass Bottle"], Objects],
					Name -> "Test vessel for huge ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselhugePackets];

			vesselnomodelPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model ->Link[Model[Container,Vessel,"2mL Tube"], Objects],
					Name -> "Test vessel for no model ExperimentMeasureSurfaceTension tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselnomodelPackets];

			samplePackets = UploadSample[
				{Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
				{{"A1",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}},
				InitialAmount -> 1950 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension Test Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension Test Sample 3"<> $SessionUUID
				},
				Upload->False
			];

			samplePackets2 = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A1",Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}},
				InitialAmount -> 1950 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTension Test 2 Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension Test 2 Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension Test 2 Sample 3"<> $SessionUUID
				},
				Upload->False
			];

			sample2Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"H12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}},
				InitialAmount -> 300 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 3"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 4"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 5"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 6"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 7"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 8"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 9"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample3Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A1",Object[Container,Plate,"Test dyneplate 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTension DynePlate Test 2 Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 2 Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 2 Sample 3"<> $SessionUUID
				},
				Upload->False
			];

			sample4aPackets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 3"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 4"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 5"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 6"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 7"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 8"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 9"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3a Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample4bPackets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 3"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 4"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 5"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 6"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 7"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 8"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 9"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 3b Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample5Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, StockSolution, "70% Ethanol"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"B12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"C12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
					{"G12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 3"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 4"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 5"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 6"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 7"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 8"<> $SessionUUID,
					"ExperimentMeasureSurfaceTension DynePlate Test 4 Sample 9"<> $SessionUUID
				},
				Upload->False
			];



			samplevesselPacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel 1 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
				InitialAmount -> 1900 Microliter,
				Name->"ExperimentMeasureSurfaceTension Test Sample 4"<> $SessionUUID,
				Upload->False
			];

			samplevessel2Packet = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel 2 for ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
				InitialAmount -> 15 Milliliter,
				Name->"ExperimentMeasureSurfaceTension Test Sample 5"<> $SessionUUID,
				Upload->False
			];

			bigsamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for big ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
				InitialAmount -> 5 Milliliter,
				Name->"ExperimentMeasureSurfaceTension Big Test Sample"<> $SessionUUID,
				Upload->False
			];

			hugesamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for huge ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
				InitialAmount -> 200 Milliliter,
				Name->"ExperimentMeasureSurfaceTension Huge Test Sample"<> $SessionUUID,
				Upload->False
			];

			nomodelsamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for no model ExperimentMeasureSurfaceTension tests"<> $SessionUUID]},
				InitialAmount -> 500 Microliter,
				Name->"ExperimentMeasureSurfaceTension No Model Test Sample"<> $SessionUUID,
				Upload->False
			];

			Upload[samplePackets];

			Upload[sample2Packets];

			Upload[sample3Packets];

			Upload[sample4aPackets];

			Upload[sample4bPackets];

			Upload[sample5Packets];

			Upload[samplevesselPacket];

			Upload[samplevessel2Packet];

			Upload[bigsamplePacket];

			Upload[hugesamplePacket];

			Upload[nomodelsamplePacket];

			Upload[samplePackets2];

			Upload[<|Object->Object[Sample,"ExperimentMeasureSurfaceTension No Model Test Sample"<> $SessionUUID],Model->Null,DeveloperObject->True|>];

			Upload[<|Object->Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 4"<> $SessionUUID],Status->Discarded,DeveloperObject->True|>];

			(*update concentration*)
			Upload[
					Association[
						Object -> Object[Sample,"ExperimentMeasureSurfaceTension Test Sample 1"<> $SessionUUID],
						Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}
					]
			];

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

(* ::Subsection:: *)
(*ExperimentMeasureSurfaceTensionOptions*)

DefineTests[ExperimentMeasureSurfaceTensionOptions,

	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentMeasureSurfaceTensionOptions[Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 1"<> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for multiple samples together:"},
			ExperimentMeasureSurfaceTensionOptions[{Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 2"<> $SessionUUID]}],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of rules:"},
			ExperimentMeasureSurfaceTensionOptions[Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 1"<> $SessionUUID], OutputFormat -> List],
			{__Rule}
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 2 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 2 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 2 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3a Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 3b Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions DynePlate Test 4 Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test 2 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test 2 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test 2 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Test Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Big Test Sample"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionOptions Huge Test Sample"<> $SessionUUID],
				Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 2 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 3a for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 3b for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 4 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel 1 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel 2 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for big ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for huge ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for no model ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		(*module for ecreating objects*)
		Module[{containerPackets, container2Packets, samplePackets, vesselPackets, vessel2Packets,  vesselbigPackets,  vesselhugePackets, samplevesselPacket, sample3Packets,
			samplevessel2Packet, vesselnomodelPackets, bigsamplePacket, hugesamplePacket, nomodelsamplePacket, sample2Packets, container3Packets, containerPackets2, samplePackets2,
			container4aPackets, container4bPackets, sample4aPackets, sample4bPackets, container5Packets, sample5Packets},

			containerPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 1 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[containerPackets];

			samplePackets = UploadSample[
				{Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
				{{"A1",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionOptions tests"<> $SessionUUID]}},
				InitialAmount -> 1950 Microliter,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTensionOptions Test Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionOptions Test Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionOptions Test Sample 3"<> $SessionUUID
				},
				Upload->False
			];

			Upload[samplePackets];

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

(* ::Subsection:: *)
(*ExperimentMeasureSurfaceTensionPreview*)

DefineTests[ExperimentMeasureSurfaceTensionPreview,

	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentMeasureSurfaceTensionPreview[Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 1"<> $SessionUUID]],
			Null
		],
		Example[{Basic, "Return Null for mulitple samples:"},
			ExperimentMeasureSurfaceTensionPreview[{Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 1"<> $SessionUUID], Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 2"<> $SessionUUID]}],
			Null
		],
		Example[{Basic, "Return Null for a plate:"},
			ExperimentMeasureSurfaceTensionPreview[Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]],
			Null
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 2 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 2 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 2 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 6"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 7"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 8"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 9"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 10"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test 2 Sample 1"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test 2 Sample 2"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test 2 Sample 3"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 4"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 5"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Big Test Sample"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview Huge Test Sample"<> $SessionUUID],
				Object[Sample,"ExperimentMeasureSurfaceTensionPreview No Model Test Sample"<> $SessionUUID],
				Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for big ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for huge ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for no model ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		(*module for ecreating objects*)
		Module[{containerPackets, container2Packets, samplePackets, vesselPackets, vessel2Packets,  vesselbigPackets,  vesselhugePackets, samplevesselPacket, sample3Packets,
			samplevessel2Packet, vesselnomodelPackets, bigsamplePacket, hugesamplePacket, nomodelsamplePacket, sample2Packets, container3Packets, containerPackets2, samplePackets2,
			container4aPackets, container4bPackets, sample4aPackets, sample4bPackets, container5Packets, sample5Packets},

			containerPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[containerPackets];

			containerPackets2 = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[containerPackets2];

			container2Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container2Packets];

			container3Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container3Packets];

			container4aPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container4aPackets];

			container4bPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container4bPackets];

			container5Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container5Packets];

			vesselPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"2mL Tube"], Objects],
					Name -> "Test vessel 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselPackets];

			vessel2Packets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"50mL Tube"], Objects],
					Name -> "Test vessel 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vessel2Packets];

			vesselbigPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"50mL Tube"], Objects],
					Name -> "Test vessel for big ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselbigPackets];

			vesselhugePackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "250mL Glass Bottle"], Objects],
					Name -> "Test vessel for huge ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselhugePackets];

			vesselnomodelPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model ->Link[Model[Container,Vessel,"2mL Tube"], Objects],
					Name -> "Test vessel for no model ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselnomodelPackets];

			samplePackets = UploadSample[
				{Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
				{{"A1",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test plate 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]}},
				InitialAmount -> 1950 Microliter,
				Name->{
					"ExperimentMeasureSurfaceTensionPreview Test Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview Test Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview Test Sample 3"<> $SessionUUID
				},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			samplePackets2 = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A1",Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test plate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]}},
				InitialAmount -> 1950 Microliter,
				Name->{
					"ExperimentMeasureSurfaceTensionPreview Test 2 Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview Test 2 Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview Test 2 Sample 3"<> $SessionUUID
				},
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			sample2Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"H12",Object[Container,Plate,"Test dyneplate 0 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]}},
				InitialAmount -> 300 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 3"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 4"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 5"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 6"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 7"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 8"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 9"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample3Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A1",Object[Container,Plate,"Test dyneplate 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 2 Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 2 Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 2 Sample 3"<> $SessionUUID
				},
				Upload->False
			];

			sample4aPackets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 3a for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 3"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 4"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 5"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 6"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 7"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 8"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 9"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3a Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample4bPackets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 3b for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition ->Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 3"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 4"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 5"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 6"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 7"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 8"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 9"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 3b Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample5Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, StockSolution, "70% Ethanol"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"B12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"C12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 4 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 1"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 2"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 3"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 4"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 5"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 6"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 7"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 8"<> $SessionUUID,
					"ExperimentMeasureSurfaceTensionPreview DynePlate Test 4 Sample 9"<> $SessionUUID
				},
				Upload->False
			];



			samplevesselPacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel 1 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
				InitialAmount -> 1900 Microliter,
				Name->"ExperimentMeasureSurfaceTensionPreview Test Sample 4"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			samplevessel2Packet = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel 2 for ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
				InitialAmount -> 15 Milliliter,
				Name->"ExperimentMeasureSurfaceTensionPreview Test Sample 5"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			bigsamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for big ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
				InitialAmount -> 5 Milliliter,
				Name->"ExperimentMeasureSurfaceTensionPreview Big Test Sample"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			hugesamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for huge ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
				InitialAmount -> 200 Milliliter,
				Name->"ExperimentMeasureSurfaceTensionPreview Huge Test Sample"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			nomodelsamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for no model ExperimentMeasureSurfaceTensionPreview tests"<> $SessionUUID]},
				InitialAmount -> 500 Microliter,
				Name->"ExperimentMeasureSurfaceTensionPreview No Model Test Sample"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			Upload[samplePackets];

			Upload[sample2Packets];

			Upload[sample3Packets];

			Upload[sample4aPackets];

			Upload[sample4bPackets];

			Upload[sample5Packets];

			Upload[samplevesselPacket];

			Upload[samplevessel2Packet];

			Upload[bigsamplePacket];

			Upload[hugesamplePacket];

			Upload[nomodelsamplePacket];

			Upload[samplePackets2];

			Upload[<|Object->Object[Sample,"ExperimentMeasureSurfaceTensionPreview No Model Test Sample"<> $SessionUUID],Model->Null,DeveloperObject->True|>];

			Upload[<|Object->Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 4"<> $SessionUUID],Status->Discarded,DeveloperObject->True|>];

			(*update concentration*)
			Upload[
				Association[
					Object -> Object[Sample,"ExperimentMeasureSurfaceTensionPreview Test Sample 1"<> $SessionUUID],
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}
				]
			];

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

(* ::Subsection:: *)
(*ValidExperimentMeasureSurfaceTensionQ*)

DefineTests[ValidExperimentMeasureSurfaceTensionQ,

	{
		Example[{Basic, "Determine the validity of a Measure Surface Tension call on one sample:"},
			ValidExperimentMeasureSurfaceTensionQ[
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 1"<> $SessionUUID]
			],
			True
		],
		Example[{Basic, "Determine the validity of a Measure Surface Tension call on multiple samples:"},
			ValidExperimentMeasureSurfaceTensionQ[
				{
					Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 1"<> $SessionUUID],
					Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 2"<> $SessionUUID]
				}
			],
			True
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentMeasureSurfaceTensionQ[
				{
					Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 1"<> $SessionUUID],
					Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 2"<> $SessionUUID]
				},
				OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentMeasureSurfaceTensionQ[
				Object[Container, Plate, "Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				PreparedPlate -> True,
				DilutionCurve->{{40 Microliter,10 Microliter},{50 Microliter,0 Microliter}},
				Verbose -> Failures
			],
			False
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 1"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 2"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 3"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 4"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 5"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 6"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 7"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 8"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 9"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 10"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 2 Sample 1"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 2 Sample 2"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 2 Sample 3"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 1"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 2"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 3"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 4"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 5"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 6"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 7"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 8"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 9"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 10"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 1"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 2"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 3"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 4"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 5"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 6"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 7"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 8"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 9"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 10"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 1"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 2"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 3"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 4"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 5"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 6"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 7"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 8"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 9"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 10"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 1"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 2"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 3"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test 2 Sample 1"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test 2 Sample 2"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test 2 Sample 3"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 4"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 5"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Big Test Sample"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Huge Test Sample"<> $SessionUUID],
				Object[Sample,"ValidExperimentMeasureSurfaceTensionQ No Model Test Sample"<> $SessionUUID],
				Object[Container,Plate,"Test plate 1 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container,Plate,"Test plate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container, Plate, "Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel 1 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for big ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for huge ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID],
				Object[Container,Vessel,"Test vessel for no model ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		(*module for ecreating objects*)
		Module[{containerPackets, container2Packets, samplePackets, vesselPackets, vessel2Packets,  vesselbigPackets,  vesselhugePackets, samplevesselPacket, sample3Packets,
			samplevessel2Packet, vesselnomodelPackets, bigsamplePacket, hugesamplePacket, nomodelsamplePacket, sample2Packets, container3Packets, containerPackets2, samplePackets2,
			container4aPackets, container4bPackets, sample4aPackets, sample4bPackets, container5Packets, sample5Packets},

			containerPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 1 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[containerPackets];

			containerPackets2 = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test plate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[containerPackets2];

			container2Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container2Packets];

			container3Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container3Packets];

			container4aPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container4aPackets];

			container4bPackets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container4bPackets];

			container5Packets = {
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "DynePlate 96-well plate"], Objects],
					Name -> "Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[container5Packets];

			vesselPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"2mL Tube"], Objects],
					Name -> "Test vessel 1 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselPackets];

			vessel2Packets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"50mL Tube"], Objects],
					Name -> "Test vessel 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vessel2Packets];

			vesselbigPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container,Vessel,"50mL Tube"], Objects],
					Name -> "Test vessel for big ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselbigPackets];

			vesselhugePackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "250mL Glass Bottle"], Objects],
					Name -> "Test vessel for huge ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselhugePackets];

			vesselnomodelPackets = {
				Association[
					Type -> Object[Container, Vessel],
					Model ->Link[Model[Container,Vessel,"2mL Tube"], Objects],
					Name -> "Test vessel for no model ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID,
					Site -> Link[$Site]
				]
			};

			Upload[vesselnomodelPackets];

			samplePackets = UploadSample[
				{Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"],Model[Sample,StockSolution,"80% Heptane, 20% Ethanol diluent for SFC"]},
				{{"A1",Object[Container,Plate,"Test plate 1 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 1 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test plate 1 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]}},
				InitialAmount -> 1950 Microliter,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ValidExperimentMeasureSurfaceTensionQ Test Sample 1"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ Test Sample 2"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ Test Sample 3"<> $SessionUUID
				},
				Upload->False
			];

			samplePackets2 = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A1",Object[Container,Plate,"Test plate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A2",Object[Container,Plate,"Test plate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test plate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]}},
				InitialAmount -> 1950 Microliter,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ValidExperimentMeasureSurfaceTensionQ Test 2 Sample 1"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ Test 2 Sample 2"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ Test 2 Sample 3"<> $SessionUUID
				},
				Upload->False
			];

			sample2Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"H12",Object[Container,Plate,"Test dyneplate 0 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]}},
				InitialAmount -> 300 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 1"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 2"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 3"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 4"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 5"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 6"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 7"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 8"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 9"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample3Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A1",Object[Container,Plate,"Test dyneplate 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 2 Sample 1"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 2 Sample 2"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 2 Sample 3"<> $SessionUUID
				},
				Upload->False
			];

			sample4aPackets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 3a for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 1"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 2"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 3"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 4"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 5"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 6"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 7"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 8"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 9"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3a Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample4bPackets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A11",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"B12",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"C12",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 3b for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 1"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 2"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 3"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 4"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 5"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 6"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 7"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 8"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 9"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 3b Sample 10"<> $SessionUUID
				},
				Upload->False
			];

			sample5Packets = UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, StockSolution, "70% Ethanol"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A10",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"B12",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"A12",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"C12",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"D12",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
					{"E12",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"F12",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"G12",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},{"H12",Object[Container,Plate,"Test dyneplate 4 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]}},
				InitialAmount -> 50 Microliter,
				StorageCondition -> Link[Model[StorageCondition,"Ambient Storage"]],
				Name->{
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 1"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 2"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 3"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 4"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 5"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 6"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 7"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 8"<> $SessionUUID,
					"ValidExperimentMeasureSurfaceTensionQ DynePlate Test 4 Sample 9"<> $SessionUUID
				},
				Upload->False
			];



			samplevesselPacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel 1 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
				InitialAmount -> 1900 Microliter,
				Name->"ValidExperimentMeasureSurfaceTensionQ Test Sample 4"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			samplevessel2Packet = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel 2 for ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
				InitialAmount -> 15 Milliliter,
				Name->"ValidExperimentMeasureSurfaceTensionQ Test Sample 5"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			bigsamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for big ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
				InitialAmount -> 5 Milliliter,
				Name->"ValidExperimentMeasureSurfaceTensionQ Big Test Sample"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			hugesamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for huge ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
				InitialAmount -> 200 Milliliter,
				Name->"ValidExperimentMeasureSurfaceTensionQ Huge Test Sample"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			nomodelsamplePacket = UploadSample[
				Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],
				{"A1",Object[Container,Vessel,"Test vessel for no model ValidExperimentMeasureSurfaceTensionQ tests"<> $SessionUUID]},
				InitialAmount -> 500 Microliter,
				Name->"ValidExperimentMeasureSurfaceTensionQ No Model Test Sample"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
				Upload->False
			];

			Upload[samplePackets];

			Upload[sample2Packets];

			Upload[sample3Packets];

			Upload[sample4aPackets];

			Upload[sample4bPackets];

			Upload[sample5Packets];

			Upload[samplevesselPacket];

			Upload[samplevessel2Packet];

			Upload[bigsamplePacket];

			Upload[hugesamplePacket];

			Upload[nomodelsamplePacket];

			Upload[samplePackets2];

			Upload[<|Object->Object[Sample,"ValidExperimentMeasureSurfaceTensionQ No Model Test Sample"<> $SessionUUID],Model->Null,DeveloperObject->True|>];

			Upload[<|Object->Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 4"<> $SessionUUID],Status->Discarded,DeveloperObject->True|>];

			(*update concentration*)
			Upload[
				Association[
					Object -> Object[Sample,"ValidExperimentMeasureSurfaceTensionQ Test Sample 1"<> $SessionUUID],
					Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]]}, {5 Millimolar, Link[Model[Molecule, "Acetone"]]}}
				]
			];

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
