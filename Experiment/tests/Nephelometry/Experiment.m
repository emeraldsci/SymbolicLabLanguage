(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentNephelometry*)


DefineTests[ExperimentNephelometry,
	{
		(* ----------- *)
		(* -- BASIC -- *)
		(* ----------- *)

		Example[{Basic,"Measure the turbidity of a single sample via nephelometry:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts a non-empty container object:"},
			ExperimentNephelometry[
				Object[Container,Plate,"ExperimentNephelometry test 96-well plate 1"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts multiple different sample objects:"},
			ExperimentNephelometry[
				{
					Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts multiple identical sample objects:"},
			ExperimentNephelometry[
				{
					Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]
				},
				AssayVolume->50Microliter
			],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Additional,"Input a sample as {Position,Plate}:"},
			ExperimentNephelometry[
				{"A1",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 1"<>$SessionUUID]}
			],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Input a mixture of all kinds of samples:"},
			ExperimentNephelometry[
				{Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],{"A1",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 1"<>$SessionUUID]}}
			],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],


		(* -- Primitive tests -- *)
		Test["Generate a RoboticCellPreparation protocol object based on a single primitive with Preparation->Robotic:",
			Experiment[{
				Nephelometry[
					Sample->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
					Preparation->Robotic,
					BlankMeasurement->False,
					Blank->Null,
					BlankVolume->Null
				]
			}],
			ObjectP[Object[Protocol,RoboticCellPreparation]]
		],
		Test["Generate an Nephelometry protocol object based on a single primitive with Preparation->Manual:",
			Experiment[{
				Nephelometry[
					Sample->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
					Preparation->Manual
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Test["Generate a RoboticCellPreparation protocol object based on a single primitive with injection options specified:",
			Experiment[{
				Nephelometry[
					Sample->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
					Preparation->Robotic,
					PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
					PrimaryInjectionVolume->4 Microliter,
					BlankMeasurement->False,
					Blank->Null,
					BlankVolume->Null
				]
			}],
			ObjectP[Object[Protocol,RoboticCellPreparation]]
		],
		Test["Generate a RoboticCellPreparation protocol object based on a primitive with multiple samples and Preparation->Robotic:",
			Experiment[{
				Nephelometry[
					Sample->{
						Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
						Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID]
					},
					Preparation->Robotic,
					BlankMeasurement->False,
					Blank->Null,
					BlankVolume->Null
				]
			}],
			ObjectP[Object[Protocol,RoboticCellPreparation]],
			SetUp:>{
				Upload[{
					<|
						Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
						Status->Available
					|>,
					<|
						Object->Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],
						Status->Available
					|>
				}]
			}
		],


		(* ------------- *)
		(* -- OPTIONS -- *)
		(* ------------- *)

		(* --Instrument-- *)
		Example[{Options,Instrument,"Specify the nephelometer instrument on which this experiment will be run:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Instrument->Object[Instrument,Nephelometer,"Instrument for ExperimentNephelometry test"<>$SessionUUID],
				Output->Options];
			Lookup[options,Instrument],
			ObjectP[ Object[Instrument,Nephelometer,"Instrument for ExperimentNephelometry test"<>$SessionUUID]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* --Method-- *)
		Example[{Options,Method,"Specify the Method which will be used to run this nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Method->Solubility,
				Output->Options];
			Lookup[options,Method],
			Solubility,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,Method,"The Method is automatically set based on the Analyte:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Output->Options];
			Lookup[options,Method],
			Solubility,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,Method,"Method if automatically set to CellCount if all samples given have a Model[Cell] with a StandardCurve that relate RelativeNephelometricUnit and Cell/Milliliter:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID], Output->Options];
			Lookup[options,Method],
			CellCount,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* --PreparedPlate-- *)
		Example[{Options,PreparedPlate,"Specify if the assay plate is a PreparedPlate and does not need to be aliquoted:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PreparedPlate->True,
				BlankMeasurement->False,
				Output->Options
			];
			Lookup[options,PreparedPlate],
			True,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* --Analyte-- *)
		Example[{Options,Analyte,"Specify the analyte of interest in the sample:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Analyte->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
				Output->Options];
			Lookup[options,Analyte],
			ObjectP[Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,Analyte,"The Analyte is automatically set based on the composition of the sample:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Output->Options];
			Lookup[options,Analyte],
			ObjectP[Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* Dilutions *)
		Example[{Options,Diluent,"Specify a diluent sample:"},
			protocol=ExperimentNephelometry[{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]},
				Diluent->Model[Sample,"Dimethyl sulfoxide"]
			];
			Download[protocol,Diluents],
			{ObjectP[Model[Sample,"Dimethyl sulfoxide"]]},
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,Diluent,"Resolve a diluent sample to the solvent:"},
			options=ExperimentNephelometry[
				{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]},
				Diluent->Automatic,
				SerialDilutionCurve->{50Microliter,50Microliter,20},
				Output->Options
			];
			Lookup[options,Diluent],
			Model[Sample,"id:vXl9j5qEnnRD"],
			Variables:>{options}
		],
		Example[
			{Options,Diluent,"Resolve a diluent sample to Null:"},
			options=ExperimentNephelometry[
				{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]},
				SerialDilutionCurve->Null,
				Output->Options
			];
			Lookup[options,Diluent],
			Null,
			Variables:>{options}
		],

		Example[
			{Options,SerialDilutionCurve,"Specify a serial dilution curve:"},
			protocol=ExperimentNephelometry[
				{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]},
				SerialDilutionCurve->{50Microliter,50Microliter,10}
			];
			Lookup[Lookup[protocol,ResolvedOptions],SerialDilutionCurve],Download[protocol,SerialDilutions],
			{50Microliter,50Microliter,10},{Flatten[Join[{{{100 Microliter,0 Microliter}},ConstantArray[{50 Microliter,50 Microliter},10]}],1]},
			Variables:>{protocol}
		],
		Example[{Options,SerialDilutionCurve,"Specify a serial dilution curve with dilution factors:"},
			protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SerialDilutionCurve->{50Microliter,{0.7,10}}
			];
			Lookup[Lookup[protocol,ResolvedOptions],SerialDilutionCurve],Download[protocol,SerialDilutions],
			{50Microliter,{0.7,10}},{Flatten[Join[{{{166.7 Microliter,0 Microliter}},ConstantArray[{116.7 Microliter,50 Microliter},10]}],1]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Options,DilutionCurve,"Specify a serial dilution curve with non constant dilution factors:"},
			protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SerialDilutionCurve->{50Microliter,{0.7,0.8,0.6,0.1}}
			];
			Lookup[Lookup[protocol,ResolvedOptions],SerialDilutionCurve],Download[protocol,SerialDilutions],
			{50Microliter,{0.7,0.8,0.6,0.1}},
			{
				{{131.5 Microliter,0 Microliter},
					{81.5 Microliter,34.9 Microliter},
					{66.4 Microliter,16.6 Microliter},
					{33. Microliter,22 Microliter},
					{5. Microliter,45. Microliter}}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Options,SerialDilutionCurve,"Specify a null serial dilution curve:"},
			protocol=ExperimentNephelometry[{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]},
				SerialDilutionCurve->Null,
				Diluent->Model[Sample,"Milli-Q water"]
			];
			Download[protocol,{SerialDilutions,Dilutions}],
			{
				{Null},
				{
					{
						{Quantity[0.00015,"Liters"],Quantity[0.00005,"Liters"]},
						{Quantity[0.0001,"Liters"],Quantity[0.0001,"Liters"]},
						{Quantity[0.00005,"Liters"],Quantity[0.00015,"Liters"]}
					}
				}
			},
			Messages:>{Warning::InsufficientVolume},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Options,SerialDilutionCurve,"Automatically resolve a serial dilution curve by specifying Diluent:"},
			protocol=ExperimentNephelometry[{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]},
				Diluent->Model[Sample,"Milli-Q water"]
			];
			Download[protocol,{Dilutions,SerialDilutions}],
			{
				{Null},
				{
					{
						{Quantity[0.00002,"Liters"],Quantity[0.0002,"Liters"]},
						{Quantity[0.00002,"Liters"],Quantity[0.0002,"Liters"]},
						{Quantity[0.00002,"Liters"],Quantity[0.0002,"Liters"]}
					}
				}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],


		Example[{Options,DilutionCurve,"Specify a custom dilution curve:"},
			protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				DilutionCurve->{{40Microliter,10Microliter},{50Microliter,0Microliter}}
			];
			Lookup[Lookup[protocol,ResolvedOptions],DilutionCurve],Download[protocol,Dilutions],
			{{40Microliter,10Microliter},{50Microliter,0Microliter}},{{{40Microliter,10Microliter},{50Microliter,0Microliter}}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[
			{Options,DilutionCurve,"Specify multiple types of dilution curves:"},
			options=ExperimentNephelometry[
				{
					Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
					Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID]
				},
				DilutionCurve->{{{40Microliter,10Microliter},{50Microliter,0Microliter}},Null},
				SerialDilutionCurve->{Null,{50 Microliter,{0.7,5}}},
				Output->Options
			];
			Lookup[options,{DilutionCurve,SerialDilutionCurve}],
			{{{{40Microliter,10Microliter},{50Microliter,0Microliter}},Null},{Null,{50 Microliter,{0.7,5}}}},
			Variables:>{options}
		],
		Example[{Options,DilutionCurve,"Specify a custom dilution curve with dilution factors:"},
			protocol=ExperimentNephelometry[
				Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				DilutionCurve->{{50Microliter,0.8},{50Microliter,0.5}}
			];
			Lookup[Lookup[protocol,ResolvedOptions],DilutionCurve],Download[protocol,Dilutions],
			{{50Microliter,0.8},{50Microliter,0.5}},
			{
				{{40. Microliter,10 Microliter},
					{25. Microliter,25.Microliter}}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[
			{Options,DilutionCurve,"Resolve to a null dilution curve:"},
			options=ExperimentNephelometry[
				{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]},
				SerialDilutionCurve->{50 Microliter,50 Microliter,20},
				Output->Options
			];
			Lookup[options,DilutionCurve],
			Null,
			Variables:>{options}
		],


		(* --BeamAperture-- *)
		Example[{Options,BeamAperture,"Specify the BeamAperture in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BeamAperture->3.2*Millimeter,
				Output->Options];
			Lookup[options,BeamAperture],
			3.2*Millimeter,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,BeamAperture,"BeamAperture must be specified to the closest 0.1 Millimeter:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BeamAperture->2.578 Millimeter,
				Output->Options];
			Lookup[options,BeamAperture],
			2.6 Millimeter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --BeamIntensity-- *)
		Example[{Options,BeamIntensity,"Specify the BeamIntensity in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BeamIntensity->30 Percent,
				Output->Options];
			Lookup[options,BeamIntensity],
			30 Percent,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,BeamIntensity,"The BeamIntensity is automatically set based on the Method:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Output->Options];
			Lookup[options,BeamIntensity],
			80 Percent,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,BeamIntensity,"BeamIntensity must be specified to the closest 1 Percent:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BeamIntensity->24.687 Percent,
				Output->Options];
			Lookup[options,BeamIntensity],
			25 Percent,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --QuantifyCellCount-- *)
		Example[{Options,QuantifyCellCount,"Specify QuantifyCellCount to calculate cell counts in this nephelometry experiment:"},
			protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],
				QuantifyCellCount->True];
			Download[protocol,QuantifyCellCount],
			{True},
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],
		Example[{Options,QuantifyCellCount,"QuantifyCellCount is automatically set based on the Method:"},
			protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],
				Method->CellCount];
			Download[protocol,QuantifyCellCount],
			{True},
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{protocol}
		],

		(* --Temperature-- *)
		Example[{Options,Temperature,"Specify the temperature of the plate reader throughout the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Temperature->43 Celsius,
				Output->Options];
			Lookup[options,Temperature],
			43 Celsius,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,Temperature,"The Temperature is automatically set based on the Method:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],
				Method->CellCount,
				Output->Options];
			Lookup[options,Temperature],
			37 Celsius,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,Temperature,"Temperature must be specified to the closest 1 Celsius:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Temperature->40.5 Celsius,
				Output->Options];
			Lookup[options,Temperature],
			41 Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --EquilibrationTime-- *)
		Example[{Options,EquilibrationTime,"Specify the time that the plate is held at the Temperature in the plate reader:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				EquilibrationTime->2.5 Minute,
				Output->Options];
			Lookup[options,EquilibrationTime],
			2.5 Minute,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,EquilibrationTime,"The EquilibrationTime is automatically set based on the Temperature:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Temperature->40 Celsius,
				Output->Options];
			Lookup[options,EquilibrationTime],
			5 Minute,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,EquilibrationTime,"EquilibrationTime must be specified to the closest 1 second:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				EquilibrationTime->300.58689 Second,
				Output->Options];
			Lookup[options,EquilibrationTime],
			301 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --TargetCarbonDioxideLevel-- *)
		Example[{Options,TargetCarbonDioxideLevel,"Specify the TargetCarbonDioxideLevel in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				TargetCarbonDioxideLevel->3 Percent,
				Output->Options];
			Lookup[options,TargetCarbonDioxideLevel],
			3 Percent,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,TargetCarbonDioxideLevel,"The TargetCarbonDioxideLevel is automatically set based on the CellType of the Analyte:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Output->Options];
			Lookup[options,TargetCarbonDioxideLevel],
			Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,TargetCarbonDioxideLevel,"TargetCarbonDioxideLevel must be specified to the closest 0.1 Percent:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				TargetCarbonDioxideLevel->4.687 Percent,
				Output->Options];
			Lookup[options,TargetCarbonDioxideLevel],
			4.7 Percent,
			EquivalenceFunction->Equal,
			Messages:>{Warning::InstrumentPrecision},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --TargetOxygenLevel-- *)
		Example[{Options,TargetOxygenLevel,"Specify the TargetOxygenLevel in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				TargetOxygenLevel->4.3 Percent,
				Output->Options];
			Lookup[options,TargetOxygenLevel],
			4.3 Percent,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,TargetOxygenLevel,"TargetOxygenLevel must be specified to the closest 1 Percent:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				TargetOxygenLevel->5.8976 Percent,
				Output->Options];
			Lookup[options,TargetOxygenLevel],
			5.9 Percent,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options, AtmosphereEquilibrationTime, "AtmosphereEquilibrationTime is automatically set to 5 minute if either TargetOxygenLevel or TargetCarbonDioxideLevel is set:"},
			Lookup[
				ExperimentNephelometry[
					Object[Sample, "ExperimentNephelometry test sample 1"<>$SessionUUID],
					TargetOxygenLevel -> 4.3 * Percent,
					Output -> Options
				],
				AtmosphereEquilibrationTime
			],
			5 * Minute,
			EquivalenceFunction -> Equal,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, AtmosphereEquilibrationTime, "AtmosphereEquilibrationTime is automatically set to Null if both TargetOxygenLevel and TargetCarbonDioxideLevel are set to Null:"},
			Lookup[
				ExperimentNephelometry[
					Object[Sample, "ExperimentNephelometry test sample 1"<>$SessionUUID],
					TargetOxygenLevel -> Null,
					TargetCarbonDioxideLevel -> Null,
					Output -> Options
				],
				AtmosphereEquilibrationTime
			],
			Null,
			SetUp :> ($CreatedObjects = {}),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			)
		],
		(* --PlateReaderMix-- *)
		Example[{Options,PlateReaderMix,"Specify the PlateReaderMix in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				Output->Options];
			Lookup[options,PlateReaderMix],
			True,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMix,"Mix options are Null if PlateReaderMix is False in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->False,
				Output->Options];
			Lookup[options,{PlateReaderMixTime,PlateReaderMixRate,PlateReaderMixMode}],
			{Null,Null,Null},
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --PlateReaderMixTime-- *)
		Example[{Options,PlateReaderMixTime,"Specify the PlateReaderMixTime in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->3 Minute,
				Output->Options];
			Lookup[options,PlateReaderMixTime],
			3 Minute,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMixTime,"The PlateReaderMixTime is automatically set if PlateReaderMix is true:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				Output->Options];
			Lookup[options,PlateReaderMixTime],
			30 Second,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMixTime,"The PlateReaderMixTime is automatically set if other PlateReader mix options are set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixRate->300 RPM,
				Output->Options];
			Lookup[options,PlateReaderMixTime],
			30 Second,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMixTime,"PlateReaderMixTime must be specified to the closest 1 Second:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->14.687 Second,
				Output->Options];
			Lookup[options,PlateReaderMixTime],
			15 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --PlateReaderMixRate-- *)
		Example[{Options,PlateReaderMixRate,"Specify the PlateReaderMixRate in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixRate->350 RPM,
				Output->Options];
			Lookup[options,PlateReaderMixRate],
			350 RPM,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMixRate,"The PlateReaderMixRate is automatically set if PlateReaderMix is true:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				Output->Options];
			Lookup[options,PlateReaderMixRate],
			700 RPM,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMixRate,"The PlateReaderMixRate is automatically set if other PlateReader mix options are set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->30 Minute,
				Output->Options];
			Lookup[options,PlateReaderMixRate],
			700 RPM,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMixRate,"PlateReaderMixRate must be specified to the closest 1 RPM:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixRate->140.687 RPM,
				Output->Options];
			Lookup[options,PlateReaderMixRate],
			141 RPM,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --PlateReaderMixMode-- *)
		Example[{Options,PlateReaderMixMode,"Specify the PlateReaderMixMode in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixMode->Linear,
				Output->Options];
			Lookup[options,PlateReaderMixMode],
			Linear,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMixMode,"The PlateReaderMixMode is automatically set if PlateReaderMix is true:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				Output->Options];
			Lookup[options,PlateReaderMixMode],
			DoubleOrbital,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PlateReaderMixMode,"The PlateReaderMixRate is automatically set if other PlateReader mix options are set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->30 Minute,
				Output->Options];
			Lookup[options,PlateReaderMixMode],
			DoubleOrbital,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --MoatSize-- *)
		Example[{Options,MoatSize,"Specify the MoatSize in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				MoatSize->3,
				Output->Options];
			Lookup[options,MoatSize],
			3,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,MoatSize,"The MoatSize is automatically set if other Moat options are set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				MoatVolume->300 Microliter,
				Output->Options];
			Lookup[options,MoatSize],
			1,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --MoatVolume-- *)
		Example[{Options,MoatVolume,"Specify the MoatVolume in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				MoatVolume->64 Microliter,
				Output->Options];
			Lookup[options,MoatVolume],
			64 Microliter,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,MoatVolume,"The MoatVolume is automatically set to the RecommendedFillVolume of the assay plate model if other moat options are set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				MoatSize->2,
				Output->Options];
			Lookup[options,MoatVolume],
			150 Microliter,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,MoatVolume,"MoatVolume must be specified to the closest 1 Microliter:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				MoatVolume->175.687 Microliter,
				Output->Options];
			Lookup[options,MoatVolume],
			176 Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --MoatBuffer-- *)
		Example[{Options,MoatBuffer,"Specify the MoatBuffer in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				MoatBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				Output->Options];
			Lookup[options,MoatBuffer],
			ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,MoatBuffer,"The MoatBuffer is automatically set to water if other moat options are set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				MoatSize->1,
				Output->Options];
			Lookup[options,MoatBuffer],
			ObjectP[Model[Sample,"Milli-Q water"]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --ReadDirection-- *)
		Example[{Options,ReadDirection,"To decrease the time it takes to read the plate minimize plate carrier movement by setting ReadDirection to SerpentineColumn:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				ReadDirection->SerpentineColumn,
				Output->Options];
			Lookup[options,ReadDirection],
			SerpentineColumn,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --SettlingTime-- *)
		Example[{Options,SettlingTime,"Specify the SettlingTime in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SettlingTime->0.5 Second,
				Output->Options];
			Lookup[options,SettlingTime],
			0.5 Second,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SettlingTime,"SettlingTime must be specified to the closest 0.1 Second:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SettlingTime->0.675 Second,
				Output->Options];
			Lookup[options,SettlingTime],
			0.7 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --ReadStartTime-- *)
		Example[{Options,ReadStartTime,"Specify the ReadStartTime in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				ReadStartTime->68 Second,
				Output->Options];
			Lookup[options,ReadStartTime],
			68 Second,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,ReadStartTime,"ReadStartTime must be specified to the closest 0.1 Second:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				ReadStartTime->78.2846 Second,
				Output->Options];
			Lookup[options,ReadStartTime],
			78.3 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --IntegrationTime-- *)
		Example[{Options,IntegrationTime,"Specify the IntegrationTime in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				IntegrationTime->4 Second,
				Output->Options];
			Lookup[options,IntegrationTime],
			4 Second,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,IntegrationTime,"IntegrationTime must be specified to the closest 0.01 Second:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				IntegrationTime->4.58496 Second,
				Output->Options];
			Lookup[options,IntegrationTime],
			4.58 Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,IntegrationTime,"The IntegrationTime is automatically set if SamplingPattern is set to Ring:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Ring,
				Output->Options];
			Lookup[options,IntegrationTime],
			0.52 Second,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,IntegrationTime,"The IntegrationTime is automatically set if SamplingPattern is set to Spiral:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Spiral,
				Output->Options];
			Lookup[options,IntegrationTime],
			1 Second,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,IntegrationTime,"The IntegrationTime is automatically set if SamplingPattern is set to Spiral and SamplingDistance is set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Spiral,
				SamplingDistance->3 Millimeter,
				Output->Options];
			Lookup[options,IntegrationTime],
			0.52 Second,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,IntegrationTime,"The IntegrationTime is automatically set if SamplingPattern is set to Ring and SamplingDistance is set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Ring,
				SamplingDistance->3 Millimeter,
				Output->Options];
			Lookup[options,IntegrationTime],
			0.26 Second,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* --Injections-- *)
		Example[{Options,PrimaryInjectionSample,"Indicate that water will be injected into every input sample:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
				PrimaryInjectionVolume->4 Microliter,
				Output->Options];
			Lookup[options,{PrimaryInjectionSample,PrimaryInjectionVolume}],
			{ObjectP[Model[Sample,"Milli-Q water"]],4 Microliter},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PrimaryInjectionVolume,"To skip the injection for a subset of samples, use Null as a placeholder in the injection samples list and injection volumes list. Here the 2nd sample will not receive injections:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PrimaryInjectionSample->{Model[Sample,"Milli-Q water"],Null},
				PrimaryInjectionVolume->{4 Microliter,Null},
				Output->Options
			],
			Lookup[options,{PrimaryInjectionSample,PrimaryInjectionVolume}],
			{{ObjectP[Model[Sample,"Milli-Q water"]],Null},{4 Microliter,Null}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SecondaryInjectionSample,"Indicate that a primary and a secondary water sample will be injected into every input sample:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
				PrimaryInjectionVolume->5 Microliter,
				SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
				SecondaryInjectionVolume->7 Microliter,
				Output->Options];
			Lookup[options,{SecondaryInjectionSample,SecondaryInjectionVolume}],
			{ObjectP[Model[Sample,"Milli-Q water"]],7 Microliter},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SecondaryInjectionVolume,"Specify the volume of a secondary injection sample:"},
			options=ExperimentNephelometry[{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]},
				PrimaryInjectionSample->{Model[Sample,"Milli-Q water"],Null},
				PrimaryInjectionVolume->{4 Microliter,Null},
				SecondaryInjectionSample->{Model[Sample,"Milli-Q water"],Null},
				SecondaryInjectionVolume->{8 Microliter,Null},
				AssayVolume->50 Microliter,
				Output->Options];
			Lookup[options,{SecondaryInjectionSample,SecondaryInjectionVolume}],
			{{ObjectP[Model[Sample,"Milli-Q water"]],Null},{8 Microliter,Null}},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PrimaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the first round of injections:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionFlowRate->220 Microliter/Second,
				Output->Options];
			Lookup[options,PrimaryInjectionFlowRate],
			220 Microliter/Second,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SecondaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the second round of injections:"},
			options=ExperimentNephelometry[
				{Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID]},
				PrimaryInjectionSample->{Model[Sample,"Milli-Q water"],Null},
				PrimaryInjectionVolume->{4 Microliter,Null},
				SecondaryInjectionSample->{Model[Sample,"Milli-Q water"],Null},
				SecondaryInjectionVolume->{8 Microliter,Null},
				SecondaryInjectionFlowRate->170 Microliter/Second,
				Output->Options];
			Lookup[options,SecondaryInjectionFlowRate],
			170 Microliter/Second,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,PrimaryInjectionSampleStorageCondition,"Indicate that the primary injection sample should be stored at room temperature after the experiment completes:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionSampleStorageCondition->AmbientStorage,
				Output->Options];
			Lookup[options,PrimaryInjectionSampleStorageCondition],
			AmbientStorage,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SecondaryInjectionSampleStorageCondition,"Indicate that the secondary injection sample should be stored in a freezer after the experiment completes:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
				PrimaryInjectionVolume->4 Microliter,
				SecondaryInjectionSample->Model[Sample,"Milli-Q water"],
				SecondaryInjectionVolume->7 Microliter,
				SecondaryInjectionSampleStorageCondition->Freezer,
				Output->Options];
			Lookup[options,SecondaryInjectionSampleStorageCondition],
			Freezer,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* Blank options *)
		(* BlankMeasurement *)
		Example[{Options,BlankMeasurement,"Indicate that blank samples will be measured to account for background light scattering:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BlankMeasurement->True,
				Output->Options];
			Lookup[options,BlankMeasurement],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* Blank *)
		Example[{Options,Blank,"Indicate the samples to be used as blank samples to background light scattering:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BlankMeasurement->True,
				Blank->Model[Sample,"id:8qZ1VWNmdLBD"],
				Output->Options];
			Lookup[options,Blank],
			ObjectP[Model[Sample,"id:8qZ1VWNmdLBD"]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,Blank,"Blank samples are automatically set to the Solvent of the sample if BlankMeasurement->True:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BlankMeasurement->True,
				Output->Options];
			Lookup[options,Blank],
			ObjectP[Model[Sample,"Methanol"]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* BlankVolume *)
		Example[{Options,BlankVolume,"Specify the BlankVolume in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BlankMeasurement->True,
				BlankVolume->17 Microliter,
				Output->Options];
			Lookup[options,BlankVolume],
			17 Microliter,
			EquivalenceFunction->Equal,
			Messages:>{Warning::NotEqualBlankVolumes},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,BlankVolume,"The BlankVolume is automatically set to the volume of the sample if BlankMeasurement is True:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BlankMeasurement->True,
				Output->Options];
			Lookup[options,BlankVolume],
			200 Microliter,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,BlankVolume,"BlankVolume must be specified to the closest 1 Microliter:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				BlankVolume->40.159457 Microliter,
				Output->Options];
			Lookup[options,BlankVolume],
			40. Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision,
				Warning::NotEqualBlankVolumes
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* Sampling Options *)
		(* SamplingPattern *)
		Example[{Options,SamplingPattern,"Specify the SamplingPattern in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Spiral,
				Output->Options];
			Lookup[options,SamplingPattern],
			Spiral,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SamplingPattern,"The SamplingPattern is automatically set to Matrix if SamplingDimension is set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingDimension->4,
				Output->Options];
			Lookup[options,SamplingPattern],
			Matrix,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SamplingPattern,"The SamplingPattern is automatically set to Center if SamplingDistance is set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingDistance->4 Millimeter,
				Output->Options];
			Lookup[options,SamplingPattern],
			Center,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SamplingPattern,"The SamplingPattern is automatically set to Center if SamplingDistance and SamplingDimension are not set:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Output->Options];
			Lookup[options,SamplingPattern],
			Center,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* SamplingDistance *)
		Example[{Options,SamplingDistance,"Specify the SamplingDistance in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Ring,
				SamplingDistance->2 Millimeter,
				Output->Options];
			Lookup[options,SamplingDistance],
			2 Millimeter,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SamplingDistance,"The SamplingDistance is automatically set to 80% of the well diameter of the assay plate if the SamplingPattern is not Null:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Spiral,
				Output->Options];
			Lookup[options,SamplingDistance],
			6 Millimeter,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SamplingDistance,"SamplingDistance must be specified to the closest 1 Millimeter:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingDistance->4.85987 Millimeter,
				Output->Options];
			Lookup[options,SamplingDistance],
			5 Millimeter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* SamplingDimension *)
		Example[{Options,SamplingDimension,"Specify the SamplingDimension in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingDimension->6,
				Output->Options];
			Lookup[options,SamplingDimension],
			6,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,SamplingDimension,"The SamplingDimension is automatically set to 3 if SamplingPattern is set to Matrix:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Matrix,
				Output->Options];
			Lookup[options,SamplingDimension],
			3,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],


		(* NumberOfReplicates *)
		Example[{Options,NumberOfReplicates,"Specify the NumberOfReplicates in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				NumberOfReplicates->2,
				AssayVolume->50 Microliter,
				Output->Options];
			Lookup[options,NumberOfReplicates],
			2,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options,NumberOfReplicates,"The NumberOfReplicates is automatically set to 3 if QuantifyCellCount is set to True:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],
				QuantifyCellCount->True,
				Output->Options];
			Lookup[options,NumberOfReplicates],
			3,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],

		(* SamplesInStorageCondition *)
		Example[{Options,SamplesInStorageCondition,"Specify the SamplesInStorageCondition for the samples in the nephelometry experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplesInStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables:>{options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentNephelometry[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:n0k9mGzRaaBn"],
				PreparedModelAmount -> 250 Microliter,
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]] ..},
				{ObjectP[Model[Container, Plate, "id:n0k9mGzRaaBn"]] ..},
				{EqualP[250 Microliter] ..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared when Preparation is Robotic:"},
			roboticProtocol = ExperimentNephelometry[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:n0k9mGzRaaBn"],
				PreparedModelAmount -> 250 Microliter,
				Preparation -> Robotic
			];
			Download[roboticProtocol, OutputUnitOperations[[1]][{
				SampleLink,
				ContainerLink,
				AmountVariableUnit,
				Well,
				ContainerLabel
			}]],
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]] ..},
				{ObjectP[Model[Container, Plate, "id:n0k9mGzRaaBn"]] ..},
				{EqualP[250 Microliter] ..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {roboticProtocol, labelSampleUO}
		],


		(* ----------- *)
		(* -- TESTS -- *)
		(* ----------- *)
		Test["Accepts a model-less sample object:",
			ExperimentNephelometry[
				Object[Sample,"ExperimentNephelometry test model-less sample"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["Accepts multiple non-empty sample container objects:",
			ExperimentNephelometry[
				{
					Object[Container,Vessel,"ExperimentNephelometry test 2mL tube"<>$SessionUUID],
					Object[Container,Vessel,"ExperimentNephelometry test 2mL tube"<>$SessionUUID]
				},
				AssayVolume->50 Microliter
			],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],


		(* -------------- *)
		(* -- MESSAGES -- *)
		(* -------------- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentNephelometry[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentNephelometry[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentNephelometry[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentNephelometry[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[
				{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample,"Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
				
				ExperimentNephelometry[sampleID, AliquotAmount->100 Microliter,Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[
				{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample,"Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];
				
				ExperimentNephelometry[containerID, AliquotAmount->100 Microliter,Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages,"DuplicateName","The Name option must not be the name of an already-existing Nephelometry protocol:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Name->"Already existing name"<>$SessionUUID],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidInput", "Throw an error if one or multiple of the input samples are discarded:"},
			ExperimentNephelometry[{Object[Sample, "ExperimentNephelometry test sample 1" <> $SessionUUID], Object[Sample, "ExperimentNephelometry test discarded sample" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput},
			Variables :> {options, protocol}
		],
		Example[{Messages, "NonLiquidSamples", "If the provided sample is not Liquid, an error will be thrown:"},
			ExperimentNephelometry[
				Object[Sample, "ExperimentNephelometry test solid sample" <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::NonLiquidSample,
				Warning::AliquotRequired,
				Error::InvalidInput
			}
		],
		(* NephelometryPreparedPlateInvalidOptions *)
		Example[{Messages,"NephelometryPreparedPlateInvalidOptions","If PreparedPlate is True, Dilutions, moat options, and BlankVolume cannot be specified:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				PreparedPlate->True,
				MoatSize->1,
				BlankMeasurement->False
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometryPreparedPlateInvalidOptions,
				Error::InvalidOption
			}
		],

		(* NephelometryPreparedPlateContainerInvalid *)
		Example[{Messages,"NephelometryPreparedPlateContainerInvalid","If PreparedPlate is True, the samples must all be in compatible plates:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample in 2mL tube"<>$SessionUUID],
				PreparedPlate->True,
				BlankMeasurement->False
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometryPreparedPlateContainerInvalid,
				Warning::AliquotRequired,
				Error::InvalidInput
			}
		],

		(* NephelometryPreparedPlateContainerInvalid *)
		Example[{Messages,"NephelometryPreparedPlateContainerInvalid","If PreparedPlate is True, the samples must all be in compatible plates:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample in 2mL tube"<>$SessionUUID],
				PreparedPlate->True,
				BlankMeasurement->False
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometryPreparedPlateContainerInvalid,
				Warning::AliquotRequired,
				Error::InvalidInput
			}
		],

		Example[{Messages,"NephelometryNonCellAnalyte","If Method is CellCount, the samples must be cells:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Method->CellCount
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometryNoStandardCurve,
				Error::NephelometryNonCellAnalyte,
				Error::InvalidOption
			}
		],

		Example[{Messages,"NephelometryNoStandardCurve","If Method is CellCount, the sample Analyte(s) specified must be Model[Cell]s with a StandardCurve that relates NephelometricTurbidityUnit to Cell/mL:"},
			ExperimentNephelometry[
				Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],
				Method->CellCount,
				Analyte->Model[Cell,"ExperimentNephelometry test cell Analyte no StandardCurves"<>$SessionUUID]
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometryNoStandardCurve,
				Error::NephelometrySampleMustContainAnalyte,
				Error::InvalidOption
			}
		],

		(* NephelometryNonCellAnalyte *)
		Example[{Messages,"NephelometryNonCellAnalyte","When Method is set to CellCount, the sample's Analyte must be a Model[Cell]:"},
			ExperimentNephelometry[
				Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],
				Method->CellCount,
				Analyte->Model[Molecule,"Formazin"]
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometryNoStandardCurve,
				Error::NephelometryNonCellAnalyte,
				Error::NephelometrySampleMustContainAnalyte,
				Error::InvalidOption
			}
		],

		(* NephelometrySampleMustContainAnalyte *)
		Example[{Messages,"NephelometrySampleMustContainAnalyte","The samples must contain the specified Analyte in their composition, if not, an error is thrown:"},
			ExperimentNephelometry[
				Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Analyte->Model[Molecule,"Formazin"]
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometrySampleMustContainAnalyte,
				Error::InvalidOption
			}
		],

		(* NephelometryMethodQuantificationMismatch *)
		Example[{Messages,"NephelometryMethodQuantificationMismatch","If Method is not CellCount, QuantifyCellCount cannot be true:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Method->Solubility,
				QuantifyCellCount->True
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometryMethodQuantificationMismatch,
				Error::InvalidOption
			}
		],

		(* NephelometryAnalyteMissing *)
		Example[{Messages,"NephelometryAnalyteMissing","If Analyte is not set and cannot be determined from the sample Analyte field or Composition:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample with Null composition"<>$SessionUUID]],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::NephelometryAnalyteMissing,
				Error::InvalidOption
			}
		],

		(* NephelometryIncompatibleGasLevels *)
		Example[{Messages,"NephelometryIncompatibleGasLevels","If TargetOxygenLevel and TargetCarbonDioxideLevel are incompatible (carbon dioxde level is high when oxygen level is low), an error is thrown:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				TargetOxygenLevel->0.5Percent,
				TargetCarbonDioxideLevel->6Percent
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::IncompatibleGasLevels,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NephelometryIncompatibleGasLevels","If TargetOxygenLevel and TargetCarbonDioxideLevel are incompatible (oxygen level is high when carbon dioxde level is high), an error is thrown:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				TargetOxygenLevel->20Percent,
				TargetCarbonDioxideLevel->6Percent
			],
			$Failed,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Error::IncompatibleGasLevels,
				Error::InvalidOption
			}
		],

		Example[{Messages,"NephelometryMissingDilutionCurve","Throw error if Diluent is specified but there's no DilutionCurve or SerialDilutionCurve:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SerialDilutionCurve->Null,
				DilutionCurve->Null,
				Diluent->Model[Sample,"Milli-Q water"]],
			$Failed,
			Messages:>{
				Error::NephelometryMissingDilutionCurve,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Messages,"NephelometryConflictingDilutionCurveTypes","If both a serial dilution curve and a custom dilution curve is given, an error will be thrown:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SerialDilutionCurve->{50Microliter,50Microliter,10},
				DilutionCurve->{{50Microliter,80Microliter},{50Microliter,30Microliter}}
			],
			$Failed,
			Messages:>{
				Error::NephelometryConflictingDilutionCurveTypes,
				Error::InvalidOption
			}
		],

		Example[{Messages,"NephelometryMissingDiluent","If a dilution curve is given with no diluent, an error will be thrown:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SerialDilutionCurve->{50Microliter,50Microliter,10},
				Diluent->Null
			],
			$Failed,
			Messages:>{
				Error::NephelometryMissingDiluent,
				Error::InvalidOption
			}
		],

		Example[{Messages,"NephelometryIntegrationTimeTooLarge","If IntegrationTime is longer than is allowed for SamplingPattern->Ring and SamplingDistance->3 Millimeter, an error is thrown:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Ring,
				SamplingDistance->3 Millimeter,
				IntegrationTime->0.5 Second
			],
			$Failed,
			Messages:>{
				Error::NephelometryIntegrationTimeTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NephelometryIntegrationTimeTooLarge","If IntegrationTime is longer than is allowed for SamplingPattern->Spiral and SamplingDistance->3 Millimeter, an error is thrown:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Spiral,
				SamplingDistance->3 Millimeter,
				IntegrationTime->0.6 Second
			],
			$Failed,
			Messages:>{
				Error::NephelometryIntegrationTimeTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NephelometryIntegrationTimeTooLarge","If IntegrationTime is longer than is allowed for SamplingPattern->Spiral, an error is thrown:"},
			ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				SamplingPattern->Spiral,
				IntegrationTime->2 Second
			],
			$Failed,
			Messages:>{
				Error::NephelometryIntegrationTimeTooLarge,
				Error::InvalidOption
			}
		],

		Example[{Messages,"NephelometryIncomputableConcentration","A warning will be shown if InputConcentrations cannot be resolved when the analyte concentration is in VolumePercent units in the sample composition and Density for the analyte is unknown:"},
			Module[{protocol},
				protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]];
				Download[protocol,InputConcentrations]
			],
			{Null},
			SetUp:>{

				(* Clear caches *)
				ClearDownload[];
				ClearMemoization[];

				(* Save the current database values *)
				{
					{sampleComposition},
					{analyteDensity}
				}=Download[
					{
						Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
						Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]
					},
					{
						{Composition},
						{Density}
					}
				];

				(* Replace the database values with failure conditions *)
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->{{1 VolumePercent,Link[Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]], Now},{99 VolumePercent,Link[Model[Molecule,"Water"]], Now}}
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							Density->Null
						|>
					}
				];
			},
			TearDown:>{
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->sampleComposition/.link_Link:>RemoveLinkID[link]
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							Density->analyteDensity
						|>
					}
				];
			},
			Variables:>{sampleComposition,analyteDensity,protocol},
			Messages:>Warning::NephelometryIncomputableConcentration
		],

		Example[{Messages,"NephelometryIncomputableConcentration","A warning will be shown if InputConcentrations cannot be resolved when the analyte concentration is in MassPercent units in the sample composition and Density for the analyte is unknown:"},
			Module[{protocol},
				protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]];
				Download[protocol,InputConcentrations]
			],
			{Null},
			SetUp:>{

				(* Clear caches *)
				ClearDownload[];
				ClearMemoization[];

				(* Save the current database values *)
				{
					{sampleComposition},
					{analyteDensity}
				}=Download[
					{
						Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
						Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]
					},
					{
						{Composition},
						{Density}
					}
				];

				(* Replace the database values with failure conditions *)
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->{{1 MassPercent,Link[Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]], Now},{99 VolumePercent,Link[Model[Molecule,"Water"]], Now}}
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							Density->Null
						|>
					}
				];
			},
			TearDown:>{
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->sampleComposition/.link_Link:>RemoveLinkID[link]
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							Density->analyteDensity
						|>
					}
				];
			},
			Variables:>{sampleComposition,analyteDensity,protocol},
			Messages:>Warning::NephelometryIncomputableConcentration
		],

		Example[{Messages,"NephelometryIncomputableConcentration","A warning will be shown if InputConcentrations cannot be resolved when the analyte concentration is in mass concentration units in the sample composition and MolecularWeight for the analyte is unknown:"},
			Module[{protocol},
				protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]];
				Download[protocol,InputConcentrations]
			],
			{Null},
			SetUp:>{

				(* Clear caches *)
				ClearDownload[];
				ClearMemoization[];

				(* Save the current database values *)
				{
					{sampleComposition},
					{analyteMW}
				}=Download[
					{
						Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
						Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]
					},
					{
						{Composition},
						{MolecularWeight}
					}
				];

				(* Replace the database values with failure conditions *)
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->{{1 Gram/Liter,Link[Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]], Now},{99 VolumePercent,Link[Model[Molecule,"Water"]], Now}}
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							MolecularWeight->Null
						|>
					}
				];
			},
			TearDown:>{
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->sampleComposition/.link_Link:>RemoveLinkID[link]
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							MolecularWeight->analyteMW
						|>
					}
				];
			},
			Variables:>{sampleComposition,analyteMW,protocol},
			Messages:>Warning::NephelometryIncomputableConcentration
		],

		Example[{Messages,"NephelometryIncomputableConcentration","A warning will be shown if InputConcentrations cannot be resolved when the analyte concentration is in VolumePercent units in the sample composition and MolecularWeight for the analyte is unknown:"},
			Module[{protocol},
				protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]];
				Download[protocol,InputConcentrations]
			],
			{Null},
			SetUp:>{

				(* Clear caches *)
				ClearDownload[];
				ClearMemoization[];

				(* Save the current database values *)
				{
					{sampleComposition},
					{analyteMW}
				}=Download[
					{
						Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
						Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]
					},
					{
						{Composition},
						{MolecularWeight}
					}
				];

				(* Replace the database values with failure conditions *)
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->{{1 VolumePercent,Link[Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]], Now},{99 VolumePercent,Link[Model[Molecule,"Water"]], Now}}
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							MolecularWeight->Null
						|>
					}
				];
			},
			TearDown:>{
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->sampleComposition/.link_Link:>RemoveLinkID[link]
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							MolecularWeight->analyteMW
						|>
					}
				];
			},
			Variables:>{sampleComposition,analyteMW,protocol},
			Messages:>Warning::NephelometryIncomputableConcentration
		],

		Example[{Messages,"NephelometryIncomputableConcentration","A warning will be shown if InputConcentrations cannot be resolved when the analyte concentration is in MassPercent units in the sample composition and MolecularWeight for the analyte is unknown:"},
			Module[{protocol},
				protocol=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID]];
				Download[protocol,InputConcentrations]
			],
			{Null},
			SetUp:>{

				(* Clear caches *)
				ClearDownload[];
				ClearMemoization[];

				(* Save the current database values *)
				{
					{sampleComposition},
					{analyteMW}
				}=Download[
					{
						Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
						Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]
					},
					{
						{Composition},
						{MolecularWeight}
					}
				];

				(* Replace the database values with failure conditions *)
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->{{1 MassPercent,Link[Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]], Now},{99 VolumePercent,Link[Model[Molecule,"Water"]], Now}}
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							MolecularWeight->Null
						|>
					}
				];
			},
			TearDown:>{
				Upload[
					{
						<|
							Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
							Replace[Composition]->sampleComposition/.link_Link:>RemoveLinkID[link]
						|>,
						<|
							Object->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
							MolecularWeight->analyteMW
						|>
					}
				];
			},
			Variables:>{sampleComposition,analyteMW,protocol},
			Messages:>Warning::NephelometryIncomputableConcentration
		],
		Example[{Messages,"TemperatureNoEquilibration","A warning will be shown if Temperature is set above Ambient and EquilibrationTime is set to zero:"},
			ExperimentNephelometry[
				Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Temperature -> 35 Celsius,
				EquilibrationTime -> 0 Second
			],
			ObjectP[Object[Protocol,Nephelometry]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>Warning::TemperatureNoEquilibration
		],


		(*--------------------------------------*)
		(*===Shared sample prep options tests===*)
		(*--------------------------------------*)


		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Variables:>{options},
			TimeConstraint->240
		],

		(*Incubate options tests*)
		Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],IncubationTime->40*Minute,Output->Options];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],MaxIncubationTime->40*Minute,Output->Options];
			Lookup[options,MaxIncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],IncubationTemperature->40*Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle*)
		Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"]],
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],AnnealingTime->40*Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],IncubateAliquot->5*Microliter,Output->Options];
			Lookup[options,IncubateAliquot],
			5*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],IncubateAliquotContainer->{1,Model[Container,Vessel,"2mL Tube"]},Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],IncubateAliquotDestinationWell->"A1",AliquotContainer->Model[Container,Plate,"96-well UV-Star Plate"],Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		(*Note: You CANNOT be in a plate for the following test*)
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample in 2mL tube"<>$SessionUUID],MixType->Shake,Output->Options];
			Lookup[options,MixType],
			Shake,
			Messages:>{Warning::AliquotRequired},
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],MixUntilDissolved->True,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],

		(*Centrifuge options tests*)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		(*Note: CentrifugeTime cannot go above 5 minutes without restricting the types of centrifuges that can be used*)
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],CentrifugeTemperature->30*Celsius,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],AliquotContainer->Model[Container,Plate,"96-well UV-Star Plate"],Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(*Note: Put your sample in a 2mL tube for the following test*)
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample in 2mL tube"<>$SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],CentrifugeAliquot->5*Microliter,Output->Options];
			Lookup[options,CentrifugeAliquot],
			5*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],CentrifugeAliquotContainer->{1,Model[Container,Vessel,"2mL Tube"]},Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],CentrifugeAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],

		(*Filter options tests*)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FiltrationType->Syringe,Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FilterMaterial->PES,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample in 50mL tube"<>$SessionUUID],PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FilterPoreSize->0.22*Micrometer,Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample in 50mL tube"<>$SessionUUID],PrefilterPoreSize->1.*Micrometer,FilterMaterial->PTFE,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FiltrationType->Syringe,FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterHousing,"FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FilterHousing->Null,Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample in 50mL tube"<>$SessionUUID],FiltrationType->Centrifuge,FilterTemperature->10*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FilterSterile->True,Output->Options];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],*)
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample in 50mL tube"<>$SessionUUID],FilterAliquot->1*Milliliter,Output->Options];
			Lookup[options,FilterAliquot],
			1*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FilterAliquotContainer->{1,Model[Container,Vessel,"2mL Tube"]},Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FilterAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],FilterContainerOut->{1,Model[Container,Vessel,"2mL Tube"]},Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],

		(*Aliquot options tests*)
		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],AliquotAmount->5*Microliter,Output->Options];
			Lookup[options,AliquotAmount],
			5*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],AssayVolume->5*Microliter,Output->Options];
			Lookup[options,AssayVolume],
			5*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],TargetConcentration->5*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentNephelometry[
				Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				TargetConcentration->1*Micromolar,
				TargetConcentrationAnalyte->Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
				AssayVolume->50Microliter,Output->Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Microliter,AssayVolume->0.2*Milliliter,Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->1*Microliter,AssayVolume->5*Microliter,Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Microliter,AssayVolume->0.2*Milliliter,Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],AliquotAmount->5*Microliter,AssayVolume->0.2*Milliliter,Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],AliquotContainer->Model[Container,Plate,"96-well UV-Star Plate"],Output->Options];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "id:n0k9mGzRaaBn"]]}},
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],

		(*Post-processing options tests*)
		Example[{Options,MeasureWeight,"Set the MeasureWeight option:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],MeasureWeight->True,Output->Options];
			Lookup[options,MeasureWeight],
			True,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Set the MeasureVolume option:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],MeasureVolume->True,Output->Options];
			Lookup[options,MeasureVolume],
			True,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Set the ImageSample option:"},
			options=ExperimentNephelometry[Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],ImageSample->True,Output->Options];
			Lookup[options,ImageSample],
			True,
			Variables:>{options}
		]

	},

	(* un comment this out when Variables works the way we would expect it to *)
	(* Variables :> {$SessionUUID},*)

	SymbolSetUp:>(
		Module[{allObjects,existingObjects},
			ClearMemoization[];

			(*Turn off warning for objects that do not exist during unit tests*)
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container,Bench,"Bench for ExperimentNephelometry tests"<>$SessionUUID],
				Model[Instrument,Nephelometer,"Instrument Model for ExperimentNephelometry testing"<>$SessionUUID],
				Object[Instrument,Nephelometer,"Instrument for ExperimentNephelometry test"<>$SessionUUID],

				Object[Container,Plate,"ExperimentNephelometry test 96-well plate 1"<>$SessionUUID],
				Object[Container,Plate,"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentNephelometry test 2mL tube"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentNephelometry test 50mL tube"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentNephelometry test 2mL tube 2"<>$SessionUUID],

				Object[Analysis,StandardCurve,"ExperimentNephelometry fake standard curve for testing"<>$SessionUUID],
				Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
				Model[Cell,"ExperimentNephelometry test cell Analyte with StandardCurves"<>$SessionUUID],
				Model[Cell,"ExperimentNephelometry test cell Analyte no StandardCurves"<>$SessionUUID],

				Model[Sample,"ExperimentNephelometry test DNA sample"<>$SessionUUID],
				Model[Sample,"ExperimentNephelometry test DNA sample (Deprecated)"<>$SessionUUID],
				Model[Sample,"ExperimentNephelometry test DNA sample with Null composition"<>$SessionUUID],
				Model[Sample,"ExperimentNephelometry test DNA sample with multiple oligomers"<>$SessionUUID],
				Model[Sample,"ExperimentNephelometry test cell sample model"<>$SessionUUID],

				Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],

				Object[Sample,"ExperimentNephelometry test discarded sample"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test deprecated model sample"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test sample with Null composition"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test sample multiple oligomers"<>$SessionUUID],

				Object[Sample,"ExperimentNephelometry test sample in 2mL tube"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test sample in 50mL tube"<>$SessionUUID],

				Object[Sample,"ExperimentNephelometry test model-less sample"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test solid sample"<>$SessionUUID],

				Object[Protocol,Nephelometry,"Already existing name"<>$SessionUUID]

			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols=True},
			Module[{testBench,testProtocol,testInstrument,emptyTestContainers,testOligomer,testInstrumentModel,testCells,
				testSampleModels,testDeprecatedSampleModel,testSampleContainerObjects,testDiscardedSamples,testModellessSample,
				containerSampleObjects,instrumentPartsObjects,developerObjects,allObjects},

				(* set up fake bench as a location for the vessel *)
				{testBench,testProtocol}=Upload[{
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Bench for ExperimentNephelometry tests"<>$SessionUUID,
						DeveloperObject->True,
						Site->Link[$Site],
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
					|>,
					<|
						Type->Object[Protocol,Nephelometry],
						Name->"Already existing name"<>$SessionUUID,
						Site->Link[$Site],
						DeveloperObject->True
					|>
				}];

				(* --- Fake Instrument and Resources --- *)
				testInstrumentModel=Upload[
					<|
						Type->Model[Instrument,Nephelometer],
						Name->"Instrument Model for ExperimentNephelometry testing"<>$SessionUUID,
						DeveloperObject->True
					|>
				];

				testInstrument=Upload[
					<|
						Type->Object[Instrument,Nephelometer],
						Model->Link[Model[Instrument,Nephelometer,"Instrument Model for ExperimentNephelometry testing"<>$SessionUUID],Objects],
						Name->"Instrument for ExperimentNephelometry test"<>$SessionUUID,
						Site->Link[$Site],
						Status->Available,
						DeveloperObject -> True
					|>
				];

				(*Make some empty test container objects*)
				emptyTestContainers=UploadSample[
					{
						Model[Container,Plate,"96-well UV-Star Plate"],
						Model[Container,Plate,"96-well UV-Star Plate"],
						Model[Container,Vessel,"2mL Tube"],
						Model[Container,Vessel,"50mL Tube"],
						Model[Container,Vessel,"2mL Tube"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					Status->
						{
							Available,
							Available,
							Available,
							Available,
							Available
						},
					Name->
						{
							"ExperimentNephelometry test 96-well plate 1"<>$SessionUUID,
							"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID,
							"ExperimentNephelometry test 2mL tube"<>$SessionUUID,
							"ExperimentNephelometry test 50mL tube"<>$SessionUUID,
							"ExperimentNephelometry test 2mL tube 2"<>$SessionUUID
						}
				];

				Upload[
					<|
						Type->Object[Analysis,StandardCurve],
						Name->"ExperimentNephelometry fake standard curve for testing"<>$SessionUUID,
						Replace[StandardDataUnits] -> {RelativeNephelometricUnit, Quantity[1, IndependentUnit["Cells"]/("Milliliters")]},
						BestFitFunction -> QuantityFunction[#1^2 &, {RelativeNephelometricUnit}, Quantity[1, IndependentUnit["Cells"]/("Milliliters")]]
					|>
				];

				(*Make a test DNA identity model*)
				testOligomer=UploadOligomer["ExperimentNephelometry test DNA molecule"<>$SessionUUID,Molecule->Strand[RandomSequence[500]],PolymerType->DNA];

				(* Make cell identity models *)
				testCells=Upload[{
					<|
						Type->Model[Cell],
						Name->"ExperimentNephelometry test cell Analyte with StandardCurves"<>$SessionUUID,
						Replace[StandardCurves]->{Link[Object[Analysis,StandardCurve,"ExperimentNephelometry fake standard curve for testing"<>$SessionUUID]]}
					|>,
					<|
						Type->Model[Cell],
						Name->"ExperimentNephelometry test cell Analyte no StandardCurves"<>$SessionUUID
					|>
				}];

				(*Make some test sample models*)
				testSampleModels=UploadSampleModel[
					{
						"ExperimentNephelometry test DNA sample"<>$SessionUUID,
						"ExperimentNephelometry test DNA sample (Deprecated)"<>$SessionUUID,
						"ExperimentNephelometry test DNA sample with Null composition"<>$SessionUUID,
						"ExperimentNephelometry test DNA sample with multiple oligomers"<>$SessionUUID,
						"ExperimentNephelometry test cell sample model"<>$SessionUUID
					},
					Composition->
						{
							{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
							{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
							{{Null,Null}},
							{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]},{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]}},
							{{10 Micromolar,Model[Cell,"ExperimentNephelometry test cell Analyte with StandardCurves"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}}
						},
					IncompatibleMaterials->ConstantArray[{None},5],
					Expires->ConstantArray[True,5],
					ShelfLife->ConstantArray[2 Year,5],
					UnsealedShelfLife->ConstantArray[90 Day,5],
					DefaultStorageCondition->ConstantArray[Model[StorageCondition,"Ambient Storage"],5],
					MSDSRequired->ConstantArray[False,5],
					BiosafetyLevel->ConstantArray["BSL-1",5],
					State->{Liquid,Liquid,Liquid,Liquid,Liquid},
					Living->{False,False,False,False,False},
					CellType->{Null,Null,Null,Null,Mammalian}
				];

				(*Make a deprecated test sample model*)
				testDeprecatedSampleModel=Upload[
					<|
						Object->Model[Sample,"ExperimentNephelometry test DNA sample (Deprecated)"<>$SessionUUID],
						Deprecated->True
					|>
				];

				(*Make some test sample objects in the test container objects*)
				testSampleContainerObjects=UploadSample[
					Join[
						{Model[Sample,"ExperimentNephelometry test DNA sample"<>$SessionUUID]},
						{Model[Sample,"ExperimentNephelometry test cell sample model"<>$SessionUUID]},
						{Model[Sample,"ExperimentNephelometry test DNA sample"<>$SessionUUID]},
						{Model[Sample,"ExperimentNephelometry test DNA sample (Deprecated)"<>$SessionUUID]},
						{Model[Sample,"ExperimentNephelometry test DNA sample with Null composition"<>$SessionUUID]},
						{Model[Sample,"ExperimentNephelometry test DNA sample with multiple oligomers"<>$SessionUUID]},
						ConstantArray[Model[Sample,"ExperimentNephelometry test DNA sample"<>$SessionUUID],2],
						{Model[Sample, "Sodium Chloride"]}
					],
					{
						{"A1",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 1"<>$SessionUUID]},
						{"A1",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID]},

						{"D1",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID]},
						{"B1",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID]},
						{"B2",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID]},

						{"C1",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID]},

						{"A1",Object[Container,Vessel,"ExperimentNephelometry test 2mL tube"<>$SessionUUID]},
						{"A1",Object[Container,Vessel,"ExperimentNephelometry test 50mL tube"<>$SessionUUID]},
						{"A1",Object[Container,Vessel,"ExperimentNephelometry test 2mL tube 2"<>$SessionUUID]}

					},
					Name->
						{
							"ExperimentNephelometry test sample 1"<>$SessionUUID,
							"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID,

							"ExperimentNephelometry test discarded sample"<>$SessionUUID,
							"ExperimentNephelometry test deprecated model sample"<>$SessionUUID,
							"ExperimentNephelometry test sample with Null composition"<>$SessionUUID,
							"ExperimentNephelometry test sample multiple oligomers"<>$SessionUUID,

							"ExperimentNephelometry test sample in 2mL tube"<>$SessionUUID,
							"ExperimentNephelometry test sample in 50mL tube"<>$SessionUUID,
							"ExperimentNephelometry test solid sample"<>$SessionUUID
						},
					InitialAmount->Join[
						ConstantArray[200*Microliter,7],
						{5 Milliliter},
						{0.5 Gram}
					]
				];


				Upload[{
					<|
						Object->Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
						Solvent->Link[Model[Sample,"Methanol"]]
					|>,
					<|
						Object->Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],
						CellType->Mammalian
					|>
				}];


				(*Modify some properties of the test sample objects*)
				testDiscardedSamples=UploadSampleStatus[
					{
						Object[Sample,"ExperimentNephelometry test discarded sample"<>$SessionUUID]
					},
					{Discarded}
				];
				UploadLocation[Object[Sample,"ExperimentNephelometry test discarded sample"<>$SessionUUID], Waste, FastTrack->True];

				(*Make a test model-less sample object*)
				testModellessSample=UploadSample[
					{{10 Micromolar,Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID]},{100 VolumePercent,Model[Molecule,"Water"]}},
					{"C2",Object[Container,Plate,"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID]},
					Name->"ExperimentNephelometry test model-less sample"<>$SessionUUID,
					InitialAmount->0.5 Milliliter
				];


				(*Gather all the created objects and models*)
				containerSampleObjects={emptyTestContainers,testOligomer,testCells,testSampleModels,testDeprecatedSampleModel,testSampleContainerObjects,testDiscardedSamples,testModellessSample};

				(*Make all the test objects and models developer objects*)
				developerObjects=Upload[<|Object->#,DeveloperObject->True|>&/@Flatten[containerSampleObjects]];

				(*Gather all the test objects and models created in SymbolSetUp*)
				allObjects=Flatten[{instrumentPartsObjects,developerObjects}];

			]
		]
	),


	SymbolTearDown:>(
		Module[{allObjects,existingObjects},

			(*Turn back on warning for objects that may not exist*)
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container,Bench,"Bench for ExperimentNephelometry tests"<>$SessionUUID],
				Model[Instrument,Nephelometer,"Instrument Model for ExperimentNephelometry testing"<>$SessionUUID],
				Object[Instrument,Nephelometer,"Instrument for ExperimentNephelometry test"<>$SessionUUID],

				Object[Container,Plate,"ExperimentNephelometry test 96-well plate 1"<>$SessionUUID],
				Object[Container,Plate,"ExperimentNephelometry test 96-well plate 2"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentNephelometry test 2mL tube"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentNephelometry test 50mL tube"<>$SessionUUID],
				Object[Container,Vessel,"ExperimentNephelometry test 2mL tube 2"<>$SessionUUID],

				Object[Analysis,StandardCurve,"ExperimentNephelometry fake standard curve for testing"<>$SessionUUID],
				Model[Molecule,Oligomer,"ExperimentNephelometry test DNA molecule"<>$SessionUUID],
				Model[Cell,"ExperimentNephelometry test cell Analyte with StandardCurves"<>$SessionUUID],
				Model[Cell,"ExperimentNephelometry test cell Analyte no StandardCurves"<>$SessionUUID],

				Model[Sample,"ExperimentNephelometry test DNA sample"<>$SessionUUID],
				Model[Sample,"ExperimentNephelometry test DNA sample (Deprecated)"<>$SessionUUID],
				Model[Sample,"ExperimentNephelometry test DNA sample with Null composition"<>$SessionUUID],
				Model[Sample,"ExperimentNephelometry test DNA sample with multiple oligomers"<>$SessionUUID],
				Model[Sample,"ExperimentNephelometry test cell sample model"<>$SessionUUID],

				Object[Sample,"ExperimentNephelometry test sample 1"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test sample 2 (cell)"<>$SessionUUID],

				Object[Sample,"ExperimentNephelometry test discarded sample"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test deprecated model sample"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test sample with Null composition"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test sample multiple oligomers"<>$SessionUUID],

				Object[Sample,"ExperimentNephelometry test sample in 2mL tube"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test sample in 50mL tube"<>$SessionUUID],

				Object[Sample,"ExperimentNephelometry test model-less sample"<>$SessionUUID],
				Object[Sample,"ExperimentNephelometry test solid sample"<>$SessionUUID],

				Object[Protocol,Nephelometry,"Already existing name"<>$SessionUUID]


			}],ObjectP[]];

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	)
];

(* ::Subsection:: *)
(*Nephelometry*)


DefineTests[Nephelometry,
	{
		Example[{Basic,"Make a Nephelometry Unit Operation:"},
			Nephelometry[],
			_Nephelometry
		],
		Test["Generate an Nephelometry protocol object based on a single primitive with Preparation->Manual:",
			Experiment[{
				Nephelometry[
					Sample->Object[Sample,"Nephelometry test DNA sample "<>$SessionUUID],
					Preparation->Manual
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Test["Generate a RoboticCellPreparation protocol object with a DNA sample based on a single primitive with Preparation->Robotic:",
			Experiment[{
				Nephelometry[
					Sample->Object[Sample,"Nephelometry test DNA sample "<>$SessionUUID],
					Preparation->Robotic,
					BlankMeasurement->False,
					Blank->Null,
					BlankVolume->Null
				]
			}],
			ObjectP[Object[Protocol,RoboticCellPreparation]]
		]
	},
	SetUp:>{
		$CreatedObjects={}
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	},
	SymbolSetUp:>{

		Module[{allObjects,existingObjects},
			ClearMemoization[];

			(*Turn off warning for objects that do not exist during unit tests*)
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container,Bench,"Nephelometry test bench "<>$SessionUUID],

				Model[Instrument,Nephelometer,"Nephelometry test instrument model "<>$SessionUUID],
				Object[Instrument,Nephelometer,"Nephelometry test instrument "<>$SessionUUID],

				Object[Container,Plate,"Nephelometry test 96-well plate "<>$SessionUUID],
				Model[Molecule,Oligomer,"Nephelometry test DNA molecule "<>$SessionUUID],
				Model[Sample,"Nephelometry test DNA sample model "<>$SessionUUID],
				Object[Sample,"Nephelometry test DNA sample "<>$SessionUUID]

			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Module[{testBench,testInstrumentModel,testInstrument,testOligomer,testSampleModel,testContainer,testSampleObject},

			testBench=Upload[
				<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Nephelometry test bench "<>$SessionUUID,
					DeveloperObject->True,
					StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
				|>
			];

			testInstrumentModel=Upload[
				<|
					Type->Model[Instrument,Nephelometer],
					Name->"Nephelometry test instrument model "<>$SessionUUID,
					DeveloperObject->True
				|>
			];

			testInstrument=Upload[
				<|
					Type->Object[Instrument,Nephelometer],
					Model->Link[testInstrumentModel,Objects],
					Name->"Nephelometry test instrument "<>$SessionUUID,
					DeveloperObject -> True,
					Status->Available
				|>
			];

			testContainer=UploadSample[
				Model[Container,Plate,"96-well UV-Star Plate"],
				{"Work Surface",testBench},
				Status->Available,
				Name->"Nephelometry test 96-well plate "<>$SessionUUID
			];

			testOligomer=UploadOligomer["Nephelometry test DNA molecule "<>$SessionUUID,Molecule->Strand[RandomSequence[500]],PolymerType->DNA];

			testSampleModel=UploadSampleModel[
				"Nephelometry test DNA sample model "<>$SessionUUID,
				Composition->{{10 Micromolar,testOligomer},{100 VolumePercent,Model[Molecule,"Water"]}},
				IncompatibleMaterials->{None},
				Expires->True,
				ShelfLife->2 Year,
				UnsealedShelfLife->90 Day,
				DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"],
				MSDSRequired->False,
				BiosafetyLevel->"BSL-1",
				State->Liquid,
				CellType->Null
			];

			testSampleObject=UploadSample[
				testSampleModel,
				{"A1",testContainer},
				Name->"Nephelometry test DNA sample "<>$SessionUUID,
				InitialAmount->200 Microliter
			];

			Upload[<|
				Object->testSampleObject,
				Solvent->Link[Model[Sample,"Methanol"]]
			|>];
		];
	},
	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			ClearMemoization[];

			(*Turn off warning for objects that do not exist during unit tests*)
			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				Object[Container,Bench,"Nephelometry test bench "<>$SessionUUID],

				Model[Instrument,Nephelometer,"Nephelometry test instrument model "<>$SessionUUID],
				Object[Instrument,Nephelometer,"Nephelometry test instrument "<>$SessionUUID],

				Object[Container,Plate,"Nephelometry test 96-well plate "<>$SessionUUID],
				Model[Molecule,Oligomer,"Nephelometry test DNA molecule "<>$SessionUUID],
				Model[Sample,"Nephelometry test DNA sample model "<>$SessionUUID],
				Object[Sample,"Nephelometry test DNA sample "<>$SessionUUID]

			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
	}
];
