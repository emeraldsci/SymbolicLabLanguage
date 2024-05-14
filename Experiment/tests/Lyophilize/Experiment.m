(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentLyophilize*)


DefineTests[
	ExperimentLyophilize,
	{
		(* --- Basic Examples --- *)
		Example[{Basic,"Lyophilize a sample:"},
			ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"]],
			ObjectP[Object[Protocol,Lyophilize]]
		],

		Example[{Basic,"Lyophilize multiple samples:"},
			ExperimentLyophilize[
				{Object[Sample,"Lyophilize Test Water Sample"],Object[Sample,"Lyophilize Test Water Sample2"]}
			],
			ObjectP[Object[Protocol,Lyophilize]]
		],

		Example[{Basic,"Lyophilize samples using one of each evaporation technique:"},
			ExperimentLyophilize[
				{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]}
			],
			ObjectP[Object[Protocol,Lyophilize]]
		],

		Example[{Options,Instrument,"Select which instrument model to use:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					Instrument->Model[Instrument,Lyophilizer,"id:KBL5Dvw6MWxJ"]
				],
				Instrument
			],
			ObjectP[Model[Instrument,Lyophilizer,"id:KBL5Dvw6MWxJ"]]
		],
		Example[{Options,Instrument,"Select which instrument to use:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					Instrument->Object[Instrument,Lyophilizer,"id:wqW9BP7JZrGA"]
				],
				Instrument
			],
			ObjectP[Object[Instrument,Lyophilizer,"id:wqW9BP7JZrGA"]]
		],
		Example[{Options,ProbeSamples,"Select which samples that temperature probes should be inserted into:"},
			Download[
				ExperimentLyophilize[
					{
						Object[Sample,"Lyophilize Test Water Sample"],
						Object[Sample,"Lyophilize Test Water Sample2"],
						Object[Sample,"Lyophilize Test Water Sample3"],
						Object[Sample,"Lyophilize Test Water Sample4"],
						Object[Sample,"Lyophilize Test Water Sample5"]
					},
					ProbeSamples->{Object[Sample,"Lyophilize Test Water Sample2"],Object[Sample,"Lyophilize Test Water Sample4"]}
				],
				ProbeSamples
			],
			{
				ObjectP[Object[Sample,"Lyophilize Test Water Sample2"]],
				ObjectP[Object[Sample,"Lyophilize Test Water Sample4"]]
			}
		],
		Example[{Options,ProbeSamples,"ProbeSamples can only accept four samples at the moment, and providing more than that will cause an error:"},
			ExperimentLyophilize[
				{
					Object[Sample,"Lyophilize Test Water Sample"],
					Object[Sample,"Lyophilize Test Water Sample2"],
					Object[Sample,"Lyophilize Test Water Sample3"],
					Object[Sample,"Lyophilize Test Water Sample4"],
					Object[Sample,"Lyophilize Test Water Sample5"]
				},
				ProbeSamples->{
					Object[Sample,"Lyophilize Test Water Sample"],
					Object[Sample,"Lyophilize Test Water Sample2"],
					Object[Sample,"Lyophilize Test Water Sample3"],
					Object[Sample,"Lyophilize Test Water Sample4"],
					Object[Sample,"Lyophilize Test Water Sample5"]
				}
			],
			$Failed,
			Messages:>{Error::NotEnoughProbes,Error::InvalidOption}
		],
		Example[{Options,TemperaturePressureProfile,"Specify the temperature and pressure gradients to be used for sublimating solvent out of the samples:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					TemperaturePressureProfile->{
						{0.`Hour,25.`Celsius,1000.`Millitorr},
						{1.`Hour,-50.`Celsius,1000.`Millitorr},
						{1.5`Hour,-50.`Celsius,400.`Millitorr},
						{3.5`Hour,-50.`Celsius,300.`Millitorr},
						{3.75`Hour,-50.`Celsius,200.`Millitorr},
						{4.`Hour,-50.`Celsius,100.`Millitorr},
						{20.`Hour,-5.`Celsius,100.`Millitorr},
						{24.`Hour,25.`Celsius,900.`Millitorr}
					}
				],
				TemperaturePressureProfile
			],
			{
				{0.`Hour,25.`Celsius,1000.`Millitorr},
				{1.`Hour,-50.`Celsius,1000.`Millitorr},
				{1.5`Hour,-50.`Celsius,400.`Millitorr},
				{3.5`Hour,-50.`Celsius,300.`Millitorr},
				{3.75`Hour,-50.`Celsius,200.`Millitorr},
				{4.`Hour,-50.`Celsius,100.`Millitorr},
				{20.`Hour,-5.`Celsius,100.`Millitorr},
				{24.`Hour,25.`Celsius,900.`Millitorr}
			}
		],
		Example[{Options,TemperaturePressureProfile,"TemperaturePressureProfile can be constructed by specifying both the Temperature and Pressure options:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					Temperature->{
						{0.`Hour,25.`Celsius},
						{1.`Hour,-50.`Celsius},
						{4.`Hour,-50.`Celsius},
						{20.`Hour,-5.`Celsius},
						{24.`Hour,25.`Celsius}
					},
					Pressure->{
						{0.`Hour,1000.`Millitorr},
						{1.`Hour,1000.`Millitorr},
						{1.5`Hour,400.`Millitorr},
						{3.5`Hour,300.`Millitorr},
						{3.75`Hour,200.`Millitorr},
						{4.`Hour,100.`Millitorr},
						{20.`Hour,100.`Millitorr},
						{24.`Hour,900.`Millitorr}
					}

				],
				TemperaturePressureProfile
			],
			{
				{0.`Hour,25.`Celsius,1000.`Millitorr},
				{1.`Hour,-50.`Celsius,1000.`Millitorr},
				{1.5`Hour,-50.`Celsius,400.`Millitorr},
				{3.5`Hour,-50.`Celsius,300.`Millitorr},
				{3.75`Hour,-50.`Celsius,200.`Millitorr},
				{4.`Hour,-50.`Celsius,100.`Millitorr},
				{20.`Hour,-5.`Celsius,100.`Millitorr},
				{24.`Hour,25.`Celsius,900.`Millitorr}
			}
		],

		Example[{Options,Temperature,"Specify the Temperature gradient used to freeze samples and then sublimate away solvent:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					Temperature->{
						{0.`Hour,25.`Celsius},
						{1.`Hour,-50.`Celsius},
						{4.`Hour,-50.`Celsius},
						{20.`Hour,-5.`Celsius},
						{24.`Hour,25.`Celsius}
					}
				],
				TemperaturePressureProfile
			],
			{
				{0.`Hour,25.`Celsius,PressureP},
				{1.`Hour,-50.`Celsius,PressureP},
				{4.`Hour,-50.`Celsius,PressureP},
				{20.`Hour,-5.`Celsius,PressureP},
				{24.`Hour,25.`Celsius,PressureP}
			}
		],

		Example[{Options,Temperature,"Temperature can be set to a single value to hold for the duration of the protocol:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					Temperature -> -35Celsius
				],
				TemperaturePressureProfile
			],
			{
				{0.`Hour, -35.`Celsius,PressureP},
				{TimeP, -35.`Celsius,PressureP}..
			}
		],

		Example[{Options,Pressure,"Specify the Pressure gradient used to freeze samples and then sublimate away solvent:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					Pressure->{
						{0.`Hour,1.`Atmosphere},
						{1.`Hour,400.`Millitorr},
						{4.`Hour,275.`Millitorr},
						{7.`Hour,200.`Millitorr},
						{20.`Hour,100.`Millitorr},
						{24.`Hour,100.`Millitorr}
					}
				],
				TemperaturePressureProfile
			],
			{
				{0.`Hour,TemperatureP,760000.`Millitorr},
				{1.`Hour,TemperatureP,400.`Millitorr},
				{4.`Hour,TemperatureP,275.`Millitorr},
				{7.`Hour,TemperatureP,200.`Millitorr},
				{20.`Hour,TemperatureP,100.`Millitorr},
				{24.`Hour,TemperatureP,100.`Millitorr}
			}
		],

		Example[{Options,Pressure,"The Pressure can be set to a single value to hold for the duration of the protocol:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					Pressure -> 250.`Millitorr
				],
				TemperaturePressureProfile
			],
			{
				{0.`Hour, TemperatureP, 250.`Millitorr},
				{TimeP, TemperatureP, 250.`Millitorr}..
			}
		],

		Example[{Options,LyophilizationTime,"Specify how long the samples should be subjected to controlled sublimation of their solvents:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					LyophilizationTime -> 17.`Hour
				],
				LyophilizationTime
			],
			17.`Hour
		],

		Example[{Options,LyophilizeUntilDry,"Specify whether containers should be re-exposed to the lyophilization process if their contents were not fully dried:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					LyophilizeUntilDry -> True
				],
				LyophilizeUntilDry
			],
			{True..}
		],
		Example[{Options,LyophilizeUntilDry,"Specifying a MaxLyophilizationTime can set LyophilizeUntilDry from Automatic to True:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					MaxLyophilizationTime -> 48 Hour
				],
				LyophilizeUntilDry
			],
			{True..}
		],
		Example[{Options,LyophilizeUntilDry,"Specifying a MaxLyophilizationTime equal to LyophilizationTime can set LyophilizeUntilDry from Automatic to False:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					LyophilizationTime -> 24.` Hour,
					MaxLyophilizationTime -> 24 Hour
				],
				LyophilizeUntilDry
			],
			{False..}
		],
		Example[{Options,MaxLyophilizationTime,"Specify the maximum number of hours samples may be subjected to temperature and pressure gradients to sublimate their solvents away:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					LyophilizationTime -> 24.`Hour,
					LyophilizeUntilDry -> True,
					MaxLyophilizationTime -> 48.`Hour
				],
				MaxLyophilizationTime
			],
			48.`Hour
		],
		Example[{Options,MaxLyophilizationTime,"The MaxLyophilizationTime will resolve from Automatic to 3x the Lyophilization time if LyophilizeUntilDry is set to True:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					LyophilizationTime -> 12.`Hour,
					LyophilizeUntilDry -> True,
					MaxLyophilizationTime -> Automatic
				],
				MaxLyophilizationTime
			],
			36.`Hour
		],
		Example[{Options,PerforateCover,"Setting PerforateCover to True will cause the operator to make a small hole in the seal for each sample's well:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					PerforateCover -> True
				],
				PerforateCover
			],
			Flatten@{True,True,Table[True,Length[Object[Container,Plate,"Lyophilize Test Plate"][Contents]]]}
		],
		Example[{Options,ContainerCover,"Specify what type of breathable seal to use for each container:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					ContainerCover -> {Chemwipe,BreathableSeal,Model[Item, PlateSeal, "id:vXl9j57mandN"]}
				],
				ContainerCovers
			],
			{Null,LinkP[Model[Item,Cap,"id:KBL5DvwVZ717"]],LinkP[Model[Item, PlateSeal, "id:vXl9j57mandN"]]}
		],
		Example[{Options,ContainerCover,"Container cover will automatically resolve to Chemwipe for vessels and breathable plate seal models for plates:"},
			Download[
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]}
				],
				ContainerCovers
			],
			{LinkP[Model[Item, Cap, "id:KBL5DvwVZ717"]],LinkP[Model[Item, Cap, "id:KBL5DvwVZ717"]],LinkP[Model[Item, PlateSeal, "id:vXl9j57mandN"]]}
		],
		Example[{Messages,"NotEnoughProbes","ProbeSamples can only accept four samples at the moment, and providing more than that will cause an error:"},
			ExperimentLyophilize[
				{
					Object[Sample,"Lyophilize Test Water Sample"],
					Object[Sample,"Lyophilize Test Water Sample2"],
					Object[Sample,"Lyophilize Test Water Sample3"],
					Object[Sample,"Lyophilize Test Water Sample4"],
					Object[Sample,"Lyophilize Test Water Sample5"]
				},
				ProbeSamples->{
					Object[Sample,"Lyophilize Test Water Sample"],
					Object[Sample,"Lyophilize Test Water Sample2"],
					Object[Sample,"Lyophilize Test Water Sample3"],
					Object[Sample,"Lyophilize Test Water Sample4"],
					Object[Sample,"Lyophilize Test Water Sample5"]
				}
			],
			$Failed,
			Messages:>{Error::NotEnoughProbes,Error::InvalidOption}
		],
		Example[{Messages,"LyophilizationTimeZero","If the provided TemperaturePressureProfile has no time length an error will be thrown:"},
			ExperimentLyophilize[
				{Object[Sample,"Lyophilize Test Water Sample"]},
				TemperaturePressureProfile->{
					{0.`Hour,25.`Celsius,1000.`Millitorr}
				}
			],
			$Failed,
			Messages:>{Error::LyophilizationTimeZero,Error::InvalidOption}
		],
		Example[{Messages,"LyophilizationTimeZero","Multiple options were provided that did not result in a TemperaturePressureProfile greater than 0 minutes:"},
			ExperimentLyophilize[
				{Object[Sample,"Lyophilize Test Water Sample"]},
				Temperature->{
					{0.`Hour,25.`Celsius}
				},
				Pressure->{
					{0.`Hour,1000.`Millitorr}
				}
			],
			$Failed,
			Messages:>{Error::LyophilizationTimeZero,Error::InvalidOption}
		],
		Example[{Messages,"ProbeSamplesInvalid","ProbeSamples can only point to members of the input samples, and will otherwise cause an error:"},
			ExperimentLyophilize[
				{Object[Sample,"Lyophilize Test Water Sample"]},
				ProbeSamples->{Object[Sample,"Lyophilize Test Water Sample2"]}
			],
			$Failed,
			Messages:>{Error::ProbeSamplesInvalid,Error::InvalidOption}
		],
		Example[{Messages,"InvalidMaxLyoTime","Specifying a MaxLyophilizationTime less than the LyophilizationTime will cause an error:"},
			ExperimentLyophilize[
				{Object[Sample,"Lyophilize Test Water Sample"],Object[Sample,"Lyophilize Test Water Sample2"]},
				MaxLyophilizationTime -> 12 Hour,
				LyophilizationTime -> 24 Hour
			],
			$Failed,
			Messages:>{Error::InvalidMaxLyoTime,Error::InvalidOption}
		],

		Test["Different length Temperature and Pressure lists that break the timepoints >0min rule don't cause anything but LyophilizationTimeZero and InvalidOption errors:",
			ExperimentLyophilize[
				{Object[Sample,"Lyophilize Test Water Sample"]},
				Temperature->{
					{0.`Hour,25.`Celsius},
					{0.`Hour,-25.`Celsius}
				},
				Pressure->{
					{0.`Hour,1000.`Millitorr}
				}
			],
			$Failed,
			Messages:>{Error::LyophilizationTimeZero,Error::InvalidOption}
		],
		Test["Lyophilize a sample with a severed model:",
			ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample Severed Model"]],
			ObjectP[Object[Protocol,Lyophilize]]
		],
		Test["The Experiment function initializes FullyLyophilized to False for each sample:",
			Download[
				ExperimentLyophilize[
					{
						Object[Sample,"Lyophilize Test Water Sample"],
						Object[Sample,"Lyophilize Test Water Sample2"],
						Object[Sample,"Lyophilize Test Water Sample3"],
						Object[Sample,"Lyophilize Test Water Sample4"],
						Object[Sample,"Lyophilize Test Water Sample5"]
					}
				],
				FullyLyophilized
			],
			{Repeated[False,5]}
		],

		Example[{Options,SamplesInStorageCondition,"Specify the StorageCondition of SamplesIn:"},
			prot=
				ExperimentLyophilize[
					{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
					SamplesInStorageCondition -> {AmbientStorage,Refrigerator,Freezer},Output->Options
				];
			Lookup[prot,SamplesInStorageCondition],
			{AmbientStorage,Refrigerator,Freezer, Freezer, Freezer, Freezer, Freezer, Freezer},
			Variables :>{prot}
		],

		Example[{Options,SamplesOutStorageCondition,"Specify the StorageCondition of SamplesOut:"},
			prot=ExperimentLyophilize[
				{Object[Container,Vessel,"Lyophilize Test 50mL 1"],Object[Container,Vessel,"Lyophilize Test 50mL 2"],Object[Container,Plate,"Lyophilize Test Plate"]},
				SamplesOutStorageCondition -> {AmbientStorage,Freezer,AmbientStorage},Output->Options
			];
			Lookup[prot,SamplesOutStorageCondition],
			{AmbientStorage,Freezer,AmbientStorage,AmbientStorage,AmbientStorage,AmbientStorage,AmbientStorage,AmbientStorage},
			Variables :>{prot}
		]


		(*
		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		(* ------------ FUNTOPIA SHARED OPTION TESTING ------------ *)
		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		Example[{Options,PreparatoryUnitOperations,"Transfer water to a tube and make sure the amount transfer matches what was requested:"},
			ExperimentLyophilize[
				"My 2mL Tube",
				PreparatoryUnitOperations -> {
					Define[
						Name -> "My 2mL Tube",
						Container -> Model[Container, Vessel, "2mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My 2mL Tube",
						Volume -> 1.75 Milliliter
					]
				},
				Method -> Gravimetric
			],
			ObjectP[Object[Protocol,Lyophilize]]
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add ethanol to a 50 milliliter tube, fill to 45 milliliters with dH2O, and then measure the volume:"},
			ExperimentLyophilize[
				{"My 50mL Tube"},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 50mL Tube",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> {Model[Sample, "id:Y0lXejGKdEDW"]},
						Destination -> "My 50mL Tube",
						Amount -> 7.5 Milliliter
					],
					FillToVolume[
						Sample -> "My 50mL Tube",
						Solvent -> Model[Sample, "id:8qZ1VWNmdLBD"],
						TotalVolume -> 45 Milliliter
					],
					Mix[
						Sample -> "My 50mL Tube",
						MixType -> Vortex
					]
				}
			],
			ObjectP[Object[Protocol,Lyophilize]]
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add a stocksolution to a bottle for preparation, then aliquot from it and measure the volume on those aliquots:"},
			ExperimentLyophilize[
				{"My 4L Bottle","My 4L Bottle","My 4L Bottle"},
				PreparatoryUnitOperations -> {
					Define[
						Name -> "My 4L Bottle",
						Container -> Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> {Model[Sample, StockSolution, "id:R8e1PjpR1k0n"]},
						Destination -> "My 4L Bottle",
						Volume -> 3.5 Liter
					]
				},
				Aliquot -> True,
				AssayVolume -> {45 Milliliter, 45 Milliliter, 1 Liter},
				AliquotContainer -> {
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "Amber Glass Bottle 4 L"]
				}
			],
			ObjectP[Object[Protocol,Lyophilize]]
		],
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], IncubateAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterInstrument -> Model[Instrument, SyringePump, "NE-1000 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1000 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], Filter -> Model[Sample, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Sample, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterMaterial->PTFE, PrefilterPoreSize -> 1.*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"], Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterAliquot -> 1.5*Milliliter, Output -> Options];
			Convert[Lookup[options, FilterAliquot],Milliliter],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Test Plate Sample 3"], TargetConcentration -> 5*Micromolar, AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Convert[Lookup[options, TargetConcentration],Micromolar],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{_Integer, ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentLyophilize[Object[Sample,"Lyophilize Test Water Sample"], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		]*)
	},
	SymbolSetUp:>{
		$CreatedObjects = {};
		ClearMemoization[];

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Container,Plate,"Lyophilize Test Plate"],
				Object[Container,Plate,"Lyophilize Test Plate2"],
				Object[Container,Plate,"Lyophilize Test Plate3"],
				Object[Container,Plate,"Lyophilize Test Plate4"],
				Object[Container,Plate,"Lyophilize Test Plate5"],
				Object[Container,Plate,"Lyophilize Test Plate6"],
				Object[Container,Plate,"Lyophilize Test Plate7"],
				Object[Container,Vessel,"Lyophilize Immobile Container"],
				Object[Container,Vessel,"Lyophilize Non Immobile Container"],
				Object[Container,Vessel,"Lyophilize Non Immobile Container 2"],
				Object[Container,Vessel,"Lyophilize Immobile Container 2"],
				Object[Container,Vessel,"Lyophilize Test 50mL 1"],
				Object[Container,Vessel,"Lyophilize Test 50mL 2"],
				Object[Sample,"Lyophilize Test Water Sample"],
				Object[Sample,"Lyophilize Test Water Sample2"],
				Object[Sample,"Lyophilize Test Water Sample3"],
				Object[Sample,"Lyophilize Test Water Sample4"],
				Object[Sample,"Lyophilize Test Water Sample5"],
				Object[Sample,"Lyophilize Test DCM Sample"],
				Object[Sample,"Lyophilize Test DCM Sample2"],
				Object[Protocol,HPLC,"Parent Protocol for ExperimentLyophilize testing"],
				Object[Sample,"Lyophilize Test Water Sample Severed Model"],
				Object[Sample,"Lyophilize Extra Water Sample2"],
				Object[Sample,"Lyophilize Extra Water Sample3"],
				Object[Sample,"Lyophilize Extra Water Sample4"],
				Object[Sample,"Lyophilize Extra Water Sample5"],
				Object[Sample,"Lyophilize Extra Water Sample6"],
				Object[Sample,"Lyophilize Extra Water Sample7"]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Module[{testNewModelID,testPlate,testPlate2,testPlate3,testPlate4,testPlate5,testPlate6,testPlate7,fiftyMLtube1,fiftyMLtube2,
			waterSample,waterSample2,waterSample3,waterSample4,waterSample5,dcmSamp1,dcmSamp2,waterSampleModelSevered,
			extraPlateSamp2,extraPlateSamp3,extraPlateSamp4,extraPlateSamp5,extraPlateSamp6,extraPlateSamp7,myMV2mLSet,myMV2mLTubes,immobileSetUp,immobileSetUp2},
			(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
			testNewModelID=CreateID[Model[Container,Vessel]];

			(* Create some containers *)
			{
				testPlate,
				testPlate2,
				testPlate3,
				testPlate4,
				testPlate5,
				testPlate6,
				testPlate7,
				fiftyMLtube1,
				fiftyMLtube2
			}=Upload[{
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Lyophilize Test Plate",DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Lyophilize Test Plate2",DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Lyophilize Test Plate3",DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Lyophilize Test Plate4",DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Lyophilize Test Plate5",DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Lyophilize Test Plate6",DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Name->"Lyophilize Test Plate7",DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"Lyophilize Test 50mL 1",DeveloperObject->True,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"Lyophilize Test 50mL 2",DeveloperObject->True,Site->Link[$Site]|>
			}];

			(* Create some samples *)
			{
				waterSample,
				waterSample2,
				waterSample3,
				waterSample4,
				waterSample5,
				dcmSamp1,
				dcmSamp2,
				waterSampleModelSevered,
				extraPlateSamp2,
				extraPlateSamp3,
				extraPlateSamp4,
				extraPlateSamp5,
				extraPlateSamp6,
				extraPlateSamp7
			}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Dichloromethane, Anhydrous"],
					Model[Sample,"Dichloromethane, Anhydrous"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]
				},
				{
					{"A1",testPlate},
					{"A2",testPlate},
					{"A3",testPlate},
					{"B1",testPlate},
					{"B2",testPlate},
					{"A1",fiftyMLtube1},
					{"A1",fiftyMLtube2},
					{"B3",testPlate},
					{"A1",testPlate2},
					{"A1",testPlate3},
					{"A1",testPlate4},
					{"A1",testPlate5},
					{"A1",testPlate6},
					{"A1",testPlate7}
				},
				InitialAmount->{
					10 Microliter,
					100 Microliter,
					1 Milliliter,
					1.9 Milliliter,
					1.5 Milliliter,
					30 Milliliter,
					45 Milliliter,
					1.7 Milliliter,
					1.7 Milliliter,
					1.7 Milliliter,
					1.7 Milliliter,
					1.7 Milliliter,
					1.7 Milliliter,
					1.7 Milliliter
				},
				StorageCondition->Refrigerator
			];

			(* Secondary uploads *)
			Upload[{
				<|Object->waterSample,Name->"Lyophilize Test Water Sample",Status->Available,DeveloperObject->True|>,
				<|Object->waterSample2,Name->"Lyophilize Test Water Sample2",Status->Available,DeveloperObject->True|>,
				<|Object->waterSample3,Name->"Lyophilize Test Water Sample3",Status->Available,DeveloperObject->True|>,
				<|Object->waterSample4,Name->"Lyophilize Test Water Sample4",Status->Available,DeveloperObject->True|>,
				<|Object->waterSample5,Name->"Lyophilize Test Water Sample5",Status->Available,DeveloperObject->True|>,
				<|Object->dcmSamp1,Name->"Lyophilize Test DCM Sample",Status->Available,DeveloperObject->True|>,
				<|Object->dcmSamp2,Name->"Lyophilize Test DCM Sample2",Status->Available,DeveloperObject->True|>,
				<|Object->waterSampleModelSevered,Name->"Lyophilize Test Water Sample Severed Model",Status->Available,DeveloperObject->True,Model->Null|>,
				<|Object->extraPlateSamp2,Name->"Lyophilize Extra Water Sample2",Status->Available,DeveloperObject->True|>,
				<|Object->extraPlateSamp3,Name->"Lyophilize Extra Water Sample3",Status->Available,DeveloperObject->True|>,
				<|Object->extraPlateSamp4,Name->"Lyophilize Extra Water Sample4",Status->Available,DeveloperObject->True|>,
				<|Object->extraPlateSamp5,Name->"Lyophilize Extra Water Sample5",Status->Available,DeveloperObject->True|>,
				<|Object->extraPlateSamp6,Name->"Lyophilize Extra Water Sample6",Status->Available,DeveloperObject->True|>,
				<|Object->extraPlateSamp7,Name->"Lyophilize Extra Water Sample7",Status->Available,DeveloperObject->True|>
			}];

			(* Upload 50 2ml tubes for batching checks *)
			myMV2mLSet=ConstantArray[
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],DeveloperObject->True,Site->Link[$Site]|>,
				50
			];

			myMV2mLTubes=Upload[myMV2mLSet];

			ECL`InternalUpload`UploadSample[
				ConstantArray[Model[Sample,"Milli-Q water"],Length[myMV2mLTubes]],
				{"A1",#}&/@myMV2mLTubes,
				InitialAmount->ConstantArray[300 * Microliter,Length[myMV2mLTubes]],
				StorageCondition->Refrigerator
			];

			immobileSetUp=Module[{modelVesselID,model,vessel1,vessel2,protocol},

				modelVesselID=CreateID[Model[Container,Vessel]];
				{model,vessel1,vessel2,protocol}=Upload[{
					<|
						Object->modelVesselID,
						Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->.1 Meter,MaxDepth->.1 Meter,MaxHeight->.1 Meter|>},
						Immobile->True
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[modelVesselID,Objects],
						DeveloperObject->True,
						Site->Link[$Site],
						Name->"Lyophilize Immobile Container"
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
						DeveloperObject->True,
						Site->Link[$Site],
						Name->"Lyophilize Non Immobile Container"
					|>,
					<|
						Type->Object[Protocol,HPLC],
						Name->"Parent Protocol for ExperimentLyophilize testing",
						Site->Link[$Site]
					|>
				}];

				UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
			];

			immobileSetUp2=Module[{modelVesselID,model,vessel1,vessel2},

				modelVesselID=CreateID[Model[Container,Vessel]];
				{model,vessel1,vessel2}=Upload[{
					<|
						Object->modelVesselID,
						Replace[Positions]->{<|Name->"A1",Footprint->Null,MaxWidth->.1 Meter,MaxDepth->.1 Meter,MaxHeight->.1 Meter|>},
						Immobile->True
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[modelVesselID,Objects],
						DeveloperObject->True,
						Site->Link[$Site],
						Name->"Lyophilize Immobile Container 2",
						TareWeight->10 Gram
					|>,
					<|
						Type->Object[Container,Vessel],
						Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],
						DeveloperObject->True,
						Site->Link[$Site],
						Name->"Lyophilize Non Immobile Container 2",
						TareWeight->10 Gram
					|>
				}];

				UploadSample[{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},{{"A1",vessel1},{"A1",vessel2}}];
			];
		]
	},
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[	$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	}
];
