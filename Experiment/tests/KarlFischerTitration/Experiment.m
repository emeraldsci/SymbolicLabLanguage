(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentKarlFischerTitration : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*KarlFischerTitration*)


(* ::Subsubsection:: *)
(*ExperimentKarlFischerTitration*)

DefineTests[ExperimentKarlFischerTitration,
	{
		Example[{Basic, "Measure the water content of a given sample:"},
			ExperimentKarlFischerTitration[Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, KarlFischerTitration]]
		],
		Example[{Basic, "Return a list of options if Output -> Options on multiple samples:"},
			ExperimentKarlFischerTitration[{Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID]}, Output -> Options],
			{__Rule}
		],
		Example[{Basic, "Create a ManualSamplePreparation with KarlFischerTitration in it:"},
			ExperimentManualSamplePreparation[{
				KarlFischerTitration[
					Sample -> {
						Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
						Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
						Object[Sample, "Test Sample 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID]
					}
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],

		Test["Make sure the fields that are not specified in options are populated properly (volumetric):",
			Download[
				ExperimentKarlFischerTitration[
					{Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID]},
					Technique -> Volumetric
				],
				{
					Technique,
					HeadspaceVials,
					StandardHeadspaceVials,
					BlankHeadspaceVials,
					StandardSyringes,
					StandardNeedles,
					SyringeRack,
					StandardWeighingFunnels,
					StandardSpatulas
				}
			],
			{
				Volumetric,
				{},
				{},
				{},
				{ObjectP[Model[Container, Syringe]], ObjectP[Model[Container, Syringe]], ObjectP[Model[Container, Syringe]]},
				{Null, Null, Null},
				ObjectP[Model[Container, Rack]],
				{Null, Null, Null},
				{Null, Null, Null}
			}
		],
		Test["If using a solid standard, make sure the right fields are populated:",
			Download[
				ExperimentKarlFischerTitration[
					{Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID]},
					Standard -> Model[Sample, "HYDRANAL-Sodium tartrate dihydrate"],
					StandardAmount -> 40 Milligram,
					SampleAmount -> {45 Milligram, 400 Microliter},
					Technique -> Volumetric
				],
				{
					Technique,
					HeadspaceVials,
					StandardHeadspaceVials,
					BlankHeadspaceVials,
					SystemPrepHeadspaceVial,
					ConditioningHeadspaceVial,
					StandardSyringes,
					StandardNeedles,
					SyringeRack,
					StandardWeighingFunnels,
					StandardSpatulas,
					SampleSyringes,
					SampleNeedles,
					SampleWeighingFunnels,
					SampleSpatulas,
					AmpouleOpener,
					ExpectedStandardTareWeight,
					ExpectedStandardWeight,
					ExpectedStandardEmptyWeight,
					ExpectedSampleTareWeight,
					ExpectedSampleWeight,
					ExpectedSampleEmptyWeight,
					StandardAmount,
					StandardTolerance,
					StandardTareTolerance,
					SampleAmount,
					SampleTolerance,
					SampleTareTolerance,
					SystemPrepSyringe,
					SystemPrepNeedle,
					SystemPrepWeighingFunnel,
					SystemPrepSpatula
				}
			],
			{
				Volumetric,
				{},
				{},
				{},
				Null,
				Null,
				{Null, Null, Null},
				{Null, Null, Null},
				ObjectP[Model[Container, Rack]],
				{ObjectP[Model[Item, WeighBoat, WeighingFunnel]], ObjectP[Model[Item, WeighBoat, WeighingFunnel]], ObjectP[Model[Item, WeighBoat, WeighingFunnel]]},
				{ObjectP[Model[Item, Spatula]], ObjectP[Model[Item, Spatula]], ObjectP[Model[Item, Spatula]]},
				{Null, ObjectP[Model[Container, Syringe]]},
				{Null, ObjectP[Model[Item, Needle]]},
				{ObjectP[Model[Item, WeighBoat, WeighingFunnel]], Null},
				{ObjectP[Model[Item, Spatula]], Null},
				ObjectP[Model[Part, AmpouleOpener]],
				(* for weigh boat, need to have a nonzero value for the tare (i.e., the weight of the weighing funnel) *)
				{GreaterP[0 Gram], GreaterP[0 Gram], GreaterP[0 Gram]},
				(* for the standard weight, should  be the StandardAmount plus the tare weight *)
				{GreaterP[40 Milligram], GreaterP[40 Milligram], GreaterP[40 Milligram]},
				(* for the weigh boat after, again, it's just the same as the tare *)
				{GreaterP[0 Gram], GreaterP[0 Gram], GreaterP[0 Gram]},
				(* for the sample, we have greater tahn zero for both the liquid and solid *)
				{GreaterP[0 Gram], GreaterP[0 Gram]},
				(* for the sample weight, in both cases it's above the sample amount *)
				{GreaterP[45 Milligram], GreaterP[350 Milligram]},
				(* for the after, it's the weigh boat/syringe tare weights *)
				{GreaterP[0 Gram], GreaterP[0 Gram]},
				EqualP[40 Milligram],
				EqualP[5 Milligram],
				GreaterP[0 Gram],
				{EqualP[45 Milligram], EqualP[400 Microliter]},
				{EqualP[5 Milligram], EqualP[173.4 Milligram]},
				{GreaterP[0 Gram], GreaterP[0 Gram]},
				Null,
				Null,
				ObjectP[Model[Item, WeighBoat, WeighingFunnel]],
				ObjectP[Model[Item, Spatula]]
			}
		],
		Test["Make sure the fields that are not specified in options are populated properly (coulometric):",
			Download[
				ExperimentKarlFischerTitration[
					{Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID]},
					Technique -> Coulometric
				],
				{
					Technique,
					HeadspaceVials,
					StandardHeadspaceVials,
					BlankHeadspaceVials,
					SystemPrepHeadspaceVial,
					ConditioningHeadspaceVial,
					StandardSyringes,
					StandardNeedles
				}
			],
			{
				Coulometric,
				{ObjectP[Model[Container, Vessel]], ObjectP[Model[Container, Vessel]]},
				{ObjectP[Model[Container, Vessel]], ObjectP[Model[Container, Vessel]], ObjectP[Model[Container, Vessel]]},
				{ObjectP[Model[Container, Vessel]], ObjectP[Model[Container, Vessel]], ObjectP[Model[Container, Vessel]]},
				ObjectP[Model[Container, Vessel]],
				ObjectP[Model[Container, Vessel]],
				{Null, Null, Null},
				{Null, Null, Null}
			}
		],
		(* --- Experiment option tests --- *)

		Example[{Options, Instrument, "Specify the instrument on which the experiment should be run; if given liquid samples, will default to a Volumetric instrument:"},
			Lookup[
				ExperimentKarlFischerTitration[
					{Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID]},
					Output -> Options
				],
				Instrument
			],
			ObjectP[Model[Instrument, KarlFischerTitrator, "Metrohm 901 Titrando"]]
		],
		Example[{Options, Technique, "Specify the way the Karl Fischer reagent is generated and reacted with the sample.  If liquid samples are provided and no other information is specified, defaults to Volumetric:"},
			Lookup[
				ExperimentKarlFischerTitration[
					{Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID]},
					Output -> Options
				],
				Technique
			],
			Volumetric
		],
		Example[{Options, {Technique, KarlFischerReagent}, "If KarlFischerReagent is set to a reagent that only works with Coulometric because it has iodine instead of iodide in it, automatically set Technique to coulometric:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					KarlFischerReagent -> Model[Sample, "HYDRANAL Coulomat AG"],
					Output -> Options
				],
				Technique
			],
			Coulometric
		],
		Example[{Options, KarlFischerReagent, "Specify the reagent used to react iodine with water to measure its concentration.  If Technique is set to Coulometric, automatically set to Coulomat AG:"},
			Lookup[
				ExperimentKarlFischerTitration[Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Output -> Options, Technique -> Coulometric],
				KarlFischerReagent
			],
			ObjectP[Model[Sample,"HYDRANAL - Coulomat AG-Oven"]]
		],
		Example[{Options, SamplingMethod, "Specify whether the water should be measured via headspace gas contents or in solution.  If Technique is set to Coulometric, automatically set to Headspace:"},
			Lookup[
				ExperimentKarlFischerTitration[Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Output -> Options, Technique -> Coulometric],
				SamplingMethod
			],
			Headspace
		],
		Example[{Options, {SampleLabel, SampleContainerLabel}, "Specify labels for the input sample and its container:"},
			Lookup[
				ExperimentKarlFischerTitration[Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID], SampleLabel -> "Karl Fischer Sample 1", SampleContainerLabel -> "Karl Fischer Container 1", Output -> Options],
				{
					SampleLabel,
					SampleContainerLabel
				}
			],
			{
				"Karl Fischer Sample 1",
				"Karl Fischer Container 1"
			}
		],
		Example[{Options, Temperature, "Specify the temperature at which the sample should be heated to release its water:"},
			Lookup[
				ExperimentKarlFischerTitration[
					{Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID]},
					Temperature -> {200 Celsius, Automatic},
					Output -> Options
				],
				Temperature
			],
			{EqualP[200 Celsius], EqualP[220 Celsius]}
		],
		Example[{Options, Medium, "Specify the solvent in which the sample is dissolved during the course of the protocol:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					Medium -> Model[Sample, "HYDRANAL Methanol Rapid"],
					Output -> Options
				],
				Medium
			],
			ObjectP[Model[Sample, "HYDRANAL Methanol Rapid"]]
		],

		Example[{Options, GasFlowRate, "Specify the rate at which the nitrogen is going to flow to carry headspace into the Karl Fischer reagent:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					GasFlowRate -> 14 Milliliter / Minute,
					Output -> Options
				],
				{
					GasFlowRate,
					SamplingMethod
				}
			],
			{
				EqualP[14 Milliliter / Minute],
				Headspace
			}
		],
		Example[{Options, SampleAmount, "Specify the amount of sample to be used in this experiment:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					SampleAmount -> 150 Milligram,
					Output -> Options
				],
				SampleAmount
			],
			EqualP[150 Milligram]
		],
		Example[{Options, Standard, "Specify the standard used in this experiment to establish efficacy and water content drift:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					Technique -> Coulometric,
					Output -> Options
				],
				{Standard, StandardTemperature}
			],
			{ObjectP[Model[Sample, "HYDRANAL-Water Standard KF-Oven 150-160 C"]], EqualP[150 Celsius]}
		],
		Example[{Options, StandardAmount, "Specify the amount of standard to be used in this experiment to establish efficacy and water content drift:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					Technique -> Coulometric,
					StandardAmount -> 150 Milligram,
					Output -> Options
				],
				StandardAmount
			],
			EqualP[150 Milligram]
		],
		Example[{Options, StandardAmount, "Specify the amount of standard to be used in this experiment to establish efficacy and water content drift:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					Technique -> Coulometric,
					StandardAmount -> 150 Milligram,
					StandardTemperature -> 160 Celsius,
					Output -> Options
				],
				StandardTemperature
			],
			EqualP[160 Celsius]
		],
		Example[{Options, NumberOfStandards, "Specify the number of standards to be used in this experiment to establish efficacy and water content drift:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					Technique -> Coulometric,
					StandardAmount -> 150 Milligram,
					NumberOfStandards -> 4,
					Output -> Options
				],
				NumberOfStandards
			],
			4
		],
		Example[{Options, NumberOfBlanks, "Specify the number of empty containers whose water content should be measured to get a reading on the surroundings:"},
			Lookup[
				ExperimentKarlFischerTitration[
					Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					Technique -> Coulometric,
					StandardAmount -> 150 Milligram,
					NumberOfBlanks -> 2,
					Output -> Options
				],
				NumberOfBlanks
			],
			2
		],
		Example[{Options, Grind, "Specify that the sample should be ground up before being measured for water content.  If the sample is a tablet, this is automatically set to True:"},
			Lookup[
				ExperimentKarlFischerTitration[
					{
						Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
						Object[Sample, "Test Sample 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID]
					},
					Output -> Options
				],
				Grind
			],
			{False, True}
		],
		Example[{Options, {GrindAmount, GrinderType, Grinder, Fineness, BulkDensity, GrindingContainer, GrindingBead, NumberOfGrindingBeads, GrindingRate, GrindingTime, NumberOfGrindingSteps, CoolingTime, GrindingProfile}, "All grinding options are set automatically if Grind is set to True:"},
			Lookup[
				ExperimentKarlFischerTitration[
					{
						Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
						Object[Sample, "Test Sample 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID]
					},
					Output -> Options
				],
				{
					GrinderType,
					GrindAmount,
					Grinder,
					Fineness,
					BulkDensity,
					GrindingContainer,
					GrindingBead,
					NumberOfGrindingBeads,
					GrindingRate,
					GrindingTime,
					NumberOfGrindingSteps,
					CoolingTime,
					GrindingProfile
				}
			],
			{
				{Null, GrinderTypeP},
				{Null, 4},
				{Null, ObjectP[Model[Instrument, Grinder]]},
				{Null, DistanceP},
				{Null, DensityP},
				{Null, ObjectP[Model[Container, Vessel]]},
				{Null, ObjectP[Model[Item, GrindingBead]]},
				{Null, GreaterEqualP[1, 1]},
				{Null, RPMP},
				{Null, TimeP},
				{Null, GreaterEqualP[1, 1]},
				Null,
				{Null, {{RPMP, TimeP}..}}
			}
		],
		(* --- Sample prep option tests --- *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the amount of an input Model[Sample] and the container in which it is to be prepared:"},
			options = ExperimentKarlFischerTitration[
				{Model[Sample, "Toluene, Reagent Grade"], Model[Sample, "Toluene, Reagent Grade"]},
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
				{ObjectP[Model[Sample, "id:mnk9jO3qD6ZK"]]..},
				{ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentKarlFischerTitration[
				Model[Sample, "Caffeine"],
				PreparedModelAmount -> 5 Milligram,
				MixType -> Vortex, IncubationTime -> 10 Minute
			],
			ObjectP[Object[Protocol, KarlFischerTitration]]
		],
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentKarlFischerTitration[
				{"caffeine sample 1", "caffeine sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "caffeine sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "caffeine sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 1", Amount -> 500*Milligram],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 2", Amount -> 300*Milligram]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		Example[{Options, {Incubate, IncubationTemperature, IncubationTime, MaxIncubationTime, IncubationInstrument, AnnealingTime, IncubateAliquot, IncubateAliquotContainer, IncubateAliquotDestinationWell}, "Set any number of the incubate options:"},
			options = ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Incubate -> True,
				IncubationTemperature -> 40 Celsius,
				IncubationTime -> 40 Minute,
				MaxIncubationTime -> 80*Minute,
				AnnealingTime -> 40*Minute,
				IncubationInstrument -> Model[Instrument, Shaker, "id:N80DNj15vreD"],
				IncubateAliquot -> 80 Microliter,
				IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				IncubateAliquotDestinationWell -> "A2",
				Output -> Options
			];
			Lookup[
				options,
				{
					Incubate,
					IncubationTemperature,
					IncubationTime,
					MaxIncubationTime,
					IncubationInstrument,
					AnnealingTime,
					IncubateAliquot,
					IncubateAliquotContainer,
					IncubateAliquotDestinationWell
				}
			],
			{
				True,
				EqualP[40 Celsius],
				EqualP[40 Minute],
				EqualP[80 Minute],
				ObjectP[Model[Instrument, Shaker, "id:N80DNj15vreD"]],
				EqualP[40 Minute],
				EqualP[80 Microliter],
				{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				"A2"
			},
			Variables :> {options}
		],
		Example[{Options, {Mix, MixType, MixUntilDisoolved}, "Set any number of Mix options:"},
			options = ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Mix -> True,
				MixType -> Shake,
				MixUntilDissolved -> True,
				Output -> Options
			];
			Lookup[options, {Mix, MixType, MixUntilDissolved}],
			{True, Shake, True},
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, {Centrifuge, CentrifugeInstrument, CentrifugeIntensity, CentrifugeTime, CentrifugeTemperature, CentrifugeAliquot}, "Set any number of Centrifuge options:"},
			options = ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Centrifuge -> True,
				CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"],
				CentrifugeIntensity -> 1000 RPM,
				CentrifugeTime -> 40 Minute,
				CentrifugeTemperature -> 10 Celsius,
				CentrifugeAliquot -> 100 Microliter,
				CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				CentrifugeAliquotDestinationWell -> "A1",
				Output -> Options

			];
			Lookup[
				options,
				{
					Centrifuge,
					CentrifugeInstrument,
					CentrifugeIntensity,
					CentrifugeTime,
					CentrifugeTemperature,
					CentrifugeAliquot,
					CentrifugeAliquotContainer,
					CentrifugeAliquotDestinationWell
				}
			],
			{
				True,
				ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
				EqualP[1000 RPM],
				EqualP[40 Minute],
				EqualP[10 Celsius],
				EqualP[100 Microliter],
				{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
				"A1"
			},
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, {Filtration, FiltrationType, FilterInstrument, Filter, FilterMaterial, PrefilterMaterial, FilterPoreSize, PrefilterPoreSize, FilterSyringe, FilterAliquot, FilterAliquotContainer, FilterAliquotDestinationWell, FilterContainerOut}, "Set any number of Filtration options:"},
			options = ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Filtration -> True,
				FiltrationType -> Syringe,
				FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
				Filter -> Model[Item, Filter, "Disk Filter, GxF/PTFE, 0.22um, 25mm"],
				FilterMaterial -> PTFE,
				PrefilterMaterial -> GxF,
				FilterPoreSize -> 0.22 Micrometer,
				PrefilterPoreSize -> 1. Micrometer,
				FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"],
				FilterAliquot -> 5 Milliliter,
				FilterAliquotContainer -> Model[Container, Vessel, "15mL Tube"],
				FilterAliquotDestinationWell -> "A1",
				FilterContainerOut -> Model[Container, Vessel, "15mL Tube"],
				Output -> Options
			];
			Lookup[
				options,
				{
					Filtration,
					FiltrationType,
					FilterInstrument,
					Filter,
					FilterMaterial,
					PrefilterMaterial,
					FilterPoreSize,
					PrefilterPoreSize,
					FilterSyringe,
					FilterAliquot,
					FilterAliquotContainer,
					FilterAliquotDestinationWell,
					FilterContainerOut
				}
			],
			{
				True,
				Syringe,
				ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
				ObjectP[Model[Item, Filter, "id:GmzlKjPzn0z5"]],
				PTFE,
				GxF,
				EqualP[0.22 Micrometer],
				EqualP[1 Micrometer],
				ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
				EqualP[5 Milliliter],
				{1, ObjectP[Model[Container, Vessel, "15mL Tube"]]},
				"A1",
				{1, ObjectP[Model[Container, Vessel, "15mL Tube"]]}
			},
			Variables :> {options}
		],
		Example[{Options, {FilterIntensity, FilterTime, FilterTemperature, FilterSterile}, "Set all options relevant to centrifuge filtering:"},
			options = ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterIntensity -> 1000*RPM,
				FilterTime -> 20 Minute,
				FilterTemperature -> 10 Celsius,
				FilterSterile -> False,
				Output -> Options
			];
			Lookup[
				options,
				{
					FilterIntensity,
					FilterTime,
					FilterTemperature,
					FilterSterile
				}
			],
			{
				EqualP[1000 * RPM],
				EqualP[20 Minute],
				EqualP[10 Celsius],
				False
			},
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentKarlFischerTitration[Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		(* aliquot options *)
		(* this is kind of a stupid example because you wouldn't use an aqueous solvent in KF but just to show that the shared options actually work here is enough *)
		Example[{Options, {Aliquot, AliquotAmount, AssayVolume, ConcentratedBuffer, BufferDilutionFactor, BufferDiluent, AliquotSampleStorageCondition, ConsolidateAliquots, AliquotPreparation, AliquotContainer, DestinationWell}, "Set any number of Aliquot options:"},
			options = ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Aliquot -> True,
				AliquotAmount -> 10 Milligram,
				AssayVolume -> 1 Milliliter,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				BufferDilutionFactor -> 10,
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				AliquotSampleStorageCondition -> Refrigerator,
				ConsolidateAliquots -> True,
				AliquotPreparation -> Manual,
				AliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				DestinationWell -> "A1",
				Output -> Options
			];
			Lookup[
				options,
				{
					Aliquot,
					AliquotAmount,
					AssayVolume,
					ConcentratedBuffer,
					BufferDilutionFactor,
					BufferDiluent,
					AliquotSampleStorageCondition,
					ConsolidateAliquots,
					AliquotPreparation,
					AliquotContainer,
					DestinationWell
				}
			],
			{
				True,
				EqualP[10 Milligram],
				EqualP[1 Milliliter],
				ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
				EqualP[10],
				ObjectP[Model[Sample, "Milli-Q water"]],
				Refrigerator,
				True,
				Manual,
				{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
				{"A1"}
			},
			Variables :> {options}
		],
		Example[{Options, {Aliquot, AssayBuffer, TargetConcentration, TargetConcentrationAnalyte}, "Set any number of Aliquot options:"},
			options = ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Aliquot -> True,
				AssayBuffer -> Model[Sample, "Methanol"],
				TargetConcentration -> 10 Millimolar,
				TargetConcentrationAnalyte -> Model[Molecule, "Caffeine"],
				Output -> Options
			];
			Lookup[
				options,
				{
					AssayBuffer,
					TargetConcentration,
					TargetConcentrationAnalyte
				}
			],
			{
				ObjectP[Model[Sample, "Methanol"]],
				EqualP[10 Millimolar],
				ObjectP[Model[Molecule, "Caffeine"]]
			},
			Variables :> {options}
		],
		Example[{Options, {ImageSample, MeasureWeight, MeasureVolume}, "Set the ImageSample/MeasureWeight/MeasureVolume postprocesing options:"},
			options = ExperimentKarlFischerTitration[Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID], ImageSample -> True, MeasureWeight -> True, MeasureVolume -> True, Output -> Options];
			Lookup[options, {ImageSample, MeasureWeight, MeasureVolume}],
			{True, True, True},
			Variables :> {options}
		],
		Example[{Options, Output, "If Output -> Simulation, decrement the amount of the input sample appropriately in the simulation:"},
			sim = ExperimentKarlFischerTitration[
				{
					Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					Object[Sample, "Test Sample 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID]
				},
				Output -> Simulation
			];
			Download[
				{
					Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					Object[Sample, "Test Sample 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID]
				},
				Mass,
				Simulation -> sim
			],
			{
				EqualP[1.9 Gram],
				With[{packet = Download[Object[Sample, "Test Sample 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID], Packet[Mass, SolidUnitWeight]]},
					EqualP[SafeRound[Lookup[packet, Mass] - 4 * Lookup[packet, SolidUnitWeight], 0.1 Milligram]]
				]
			},
			Variables :> {sim}
		],
		Example[{Messages, "KarlFischerReagentComponents", "If a KarlFischerReagent is specified that does not match one of the ones in the catalog, a warning is thrown:"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				KarlFischerReagent -> Model[Sample, "Methanol"]
			],
			ObjectP[Object[Protocol, KarlFischerTitration]],
			Messages :> {Warning::KarlFischerReagentComponents}
		],
		Example[{Messages, "SamplingMethodMismatch", "If SamplingMethod is set to Liquid, Temperature must be Ambient:"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				SamplingMethod -> Liquid,
				Temperature -> 200 Celsius
			],
			$Failed,
			Messages :> {Error::SamplingMethodMismatch, Error::InvalidOption}
		],
		Example[{Messages, "SamplingMethodMismatch", "If SamplingMethod is set to Headspace, Temperature must not be Ambient:"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				SamplingMethod -> Headspace,
				Temperature -> Ambient
			],
			$Failed,
			Messages :> {Error::SamplingMethodMismatch, Error::InvalidOption}
		],
		Example[{Messages, "TechniqueSamplingMethodMismatch", "If Technique is set to Coulometric, SamplingMethod cannot be Liquid:"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Technique -> Coulometric,
				SamplingMethod -> Liquid
			],
			$Failed,
			Messages :> {Error::TechniqueSamplingMethodMismatch, Error::InvalidOption}
		],
		Example[{Messages, "InstrumentTechniqueMismatch", "The specified Technique must match the TitrationTechnique of the specified instrument:"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Technique -> Coulometric,
				Instrument -> Model[Instrument, KarlFischerTitrator, "Metrohm 901 Titrando"]
			],
			$Failed,
			Messages :> {Error::InstrumentTechniqueMismatch, Error::InvalidOption}
		],
		Example[{Messages, "StandardAmountMismatch", "Solid standards must have a mass specified for StandardAmount, and liquid standards must have a volume specified for StandardAmount:"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Technique -> Coulometric,
				Standard -> Model[Sample,"HYDRANAL-Water Standard KF-Oven 150-160 C"],
				StandardAmount -> 1 Milliliter
			],
			$Failed,
			Messages :> {Error::StandardAmountMismatch, Error::InvalidOption}
		],
		Example[{Messages, "SampleAmountStateConflict", "Solid samples can't have volumes set for SampleAmount (and liquids can't have mass set):"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				SampleAmount -> 1 Milliliter
			],
			$Failed,
			Messages :> {Error::SampleAmountStateConflict, Error::InvalidOption}
		],
		Example[{Messages, "NumberOfBlanksMismatch", "NumberOfBlanks can't be specified if Technique is Volumetric"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				NumberOfBlanks -> 3,
				Technique -> Volumetric
			],
			$Failed,
			Messages :> {Error::NumberOfBlanksMismatch, Error::InvalidOption}
		],
		Example[{Messages, "NonGrindableSamples", "Grind may only be set to True for solid tablet samples:"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Grind -> True
			],
			$Failed,
			Messages :> {Error::NonGrindableSamples, Error::InvalidOption}
		],
		Example[{Messages, "GrindOptionMismatch", "If Grind is set to False, no other Grind options may be specified:"},
			ExperimentKarlFischerTitration[
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Grind -> False,
				GrinderType -> KnifeMill
			],
			$Failed,
			Messages :> {Error::GrindOptionMismatch, Error::InvalidOption}
		],
		Example[{Messages, "TooManySamplesKarlFischerTitration", "If too many samples are specified, a message is thrown:"},
			ExperimentKarlFischerTitration[
				ConstantArray[
					Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
					30
				],
				SampleAmount -> 10 Milligram,
				NumberOfStandards -> 5,
				NumberOfBlanks -> 5
			],
			$Failed,
			Messages :> {
				Error::TooManySamplesKarlFischerTitration,
				Error::InvalidOption
			}
		]

	},
	TurnOffMessages :> {
		Warning::SamplesOutOfStock
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test Bench for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID],
				Object[Sample, "Test Sample 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True];
		];
		(* note that these instruments cannot be made $DeveloperObject because otherwise frq not going to find them and will freak out *)
		makeTestKFInstruments[ExperimentKarlFischerTitration];
		Block[{$DeveloperUpload = True},
			Module[{testBench, sample1, sample2, sample3, sample4, tube1, tube2, tube3, tube4},
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test Bench for ExperimentKarlFischerTitration tests" <> $SessionUUID
					|>
				];

				{
					tube1,
					tube2,
					tube3,
					tube4
				} = UploadSample[
					{
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Container 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID,
						"Test Container 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID,
						"Test Container 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID,
						"Test Container 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID
					}
				];
				{
					sample1,
					sample2,
					sample3,
					sample4
				} = UploadSample[
					{
						Model[Sample, "Caffeine"],
						Model[Sample, "Caffeine"],
						Model[Sample, "Toluene, Reagent Grade"],
						Model[Sample, "Ibuprofen tablets 500 Count"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", tube4}
					},
					Name -> {
						"Test Sample 1 for ExperimentKarlFischerTitration tests" <> $SessionUUID,
						"Test Sample 2 for ExperimentKarlFischerTitration tests" <> $SessionUUID,
						"Test Sample 3 for ExperimentKarlFischerTitration tests" <> $SessionUUID,
						"Test Sample 4 for ExperimentKarlFischerTitration tests" <> $SessionUUID
					},
					InitialAmount -> {
						2 Gram,
						2 Gram,
						10 Milliliter,
						500
					}
				];
			]
		]
	)
];

(* ::Subsubsection:: *)
(*ExperimentKarlFischerTitrationOptions*)


DefineTests[ExperimentKarlFischerTitrationOptions,
	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentKarlFischerTitrationOptions[Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID]],
			_Grid
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options rather than a table:"},
			ExperimentKarlFischerTitrationOptions[{Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID]}, OutputFormat -> List],
			{__Rule}
		]

	},
	TurnOffMessages :> {
		Warning::SamplesOutOfStock
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test Bench for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 1 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 2 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 3 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID],
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True];
		];
		(* note that these instruments cannot be made $DeveloperObject because otherwise frq not going to find them and will freak out *)
		makeTestKFInstruments[ExperimentKarlFischerTitrationOptions];
		Block[{$DeveloperUpload = True},
			Module[{testBench, sample1, sample2, sample3, tube1, tube2, tube3},
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test Bench for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID
					|>
				];

				{
					tube1,
					tube2,
					tube3
				} = UploadSample[
					{
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Container 1 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID,
						"Test Container 2 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID,
						"Test Container 3 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID
					}
				];
				{
					sample1,
					sample2,
					sample3
				} = UploadSample[
					{
						Model[Sample, "Caffeine"],
						Model[Sample, "Caffeine"],
						Model[Sample, "Toluene, Reagent Grade"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3}
					},
					Name -> {
						"Test Sample 1 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID,
						"Test Sample 2 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID,
						"Test Sample 3 for ExperimentKarlFischerTitrationOptions tests" <> $SessionUUID
					},
					InitialAmount -> {
						2 Gram,
						2 Gram,
						10 Milliliter
					}
				];
			]
		]
	)
];

(* ::Subsubsection:: *)
(*ValidExperimentKarlFischerTitrationQ*)

DefineTests[ValidExperimentKarlFischerTitrationQ,
	{
		Example[{Basic, "Return a boolean indicating if the sample passes all the validation tests:"},
			ValidExperimentKarlFischerTitrationQ[Object[Sample, "Test Sample 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID]],
			True
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentKarlFischerTitrationQ[
				{Object[Sample, "Test Sample 2 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID]},
				SamplingMethod -> Liquid,
				Temperature -> 200 Celsius,
				Verbose -> Failures
			],
			False
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentKarlFischerTitrationQ[
				{Object[Sample, "Test Sample 2 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID]},
				SamplingMethod -> Liquid,
				Temperature -> 200 Celsius,
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Messages, "KarlFischerReagentComponents", "If a KarlFischerReagent is specified that does not match one of the ones in the catalog, a warning is thrown:"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				KarlFischerReagent -> Model[Sample, "Methanol"]
			],
			True
		],
		Example[{Messages, "SamplingMethodMismatch", "If SamplingMethod is set to Liquid, Temperature must be Ambient:"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				SamplingMethod -> Liquid,
				Temperature -> 200 Celsius
			],
			False
		],
		Example[{Messages, "SamplingMethodMismatch", "If SamplingMethod is set to Headspace, Temperature must not be Ambient:"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				SamplingMethod -> Headspace,
				Temperature -> Ambient
			],
			False
		],
		Example[{Messages, "TechniqueSamplingMethodMismatch", "If Technique is set to Coulometric, SamplingMethod cannot be Liquid:"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Technique -> Coulometric,
				SamplingMethod -> Liquid
			],
			False
		],
		Example[{Messages, "InstrumentTechniqueMismatch", "The specified Technique must match the TitrationTechnique of the specified instrument:"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Technique -> Coulometric,
				Instrument -> Model[Instrument, KarlFischerTitrator, "Metrohm 901 Titrando"]
			],
			False
		],
		Example[{Messages, "StandardAmountMismatch", "Solid standards must have a mass specified for StandardAmount, and liquid standards must have a volume specified for StandardAmount:"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Technique -> Coulometric,
				Standard -> Model[Sample,"HYDRANAL-Water Standard KF-Oven 150-160 C"],
				StandardAmount -> 1 Milliliter
			],
			False
		],
		Example[{Messages, "SampleAmountStateConflict", "Solid samples can't have volumes set for SampleAmount (and liquids can't have mass set):"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 2 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				SampleAmount -> 1 Milliliter
			],
			False
		],
		Example[{Messages, "NumberOfBlanksMismatch", "NumberOfBlanks can't be specified if Technique is Volumetric"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 2 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				NumberOfBlanks -> 3,
				Technique -> Volumetric
			],
			False
		],
		Example[{Messages, "NonGrindableSamples", "Grind may only be set to True for solid tablet samples:"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Grind -> True
			],
			False
		],
		Example[{Messages, "GrindOptionMismatch", "If Grind is set to False, no other Grind options may be specified:"},
			ValidExperimentKarlFischerTitrationQ[
				Object[Sample, "Test Sample 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Grind -> False,
				GrinderType -> KnifeMill
			],
			False
		]
	},
	TurnOffMessages :> {
		Warning::SamplesOutOfStock
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test Bench for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 2 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 4 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Object[Sample, "Test Sample 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID],
				Object[Sample, "Test Sample 4 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True];
		];
		(* note that these instruments cannot be made $DeveloperObject because otherwise frq not going to find them and will freak out *)
		makeTestKFInstruments[ValidExperimentKarlFischerTitrationQ];
		Block[{$DeveloperUpload = True},
			Module[{testBench, sample1, sample2, sample3, sample4, tube1, tube2, tube3, tube4},
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test Bench for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID
					|>
				];

				{
					tube1,
					tube2,
					tube3,
					tube4
				} = UploadSample[
					{
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Container 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID,
						"Test Container 2 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID,
						"Test Container 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID,
						"Test Container 4 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID
					}
				];
				{
					sample1,
					sample2,
					sample3,
					sample4
				} = UploadSample[
					{
						Model[Sample, "Caffeine"],
						Model[Sample, "Caffeine"],
						Model[Sample, "Toluene, Reagent Grade"],
						Model[Sample, "Ibuprofen tablets 500 Count"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", tube4}
					},
					Name -> {
						"Test Sample 1 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID,
						"Test Sample 2 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID,
						"Test Sample 3 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID,
						"Test Sample 4 for ValidExperimentKarlFischerTitrationQ tests" <> $SessionUUID
					},
					InitialAmount -> {
						2 Gram,
						2 Gram,
						10 Milliliter,
						500
					}
				];
			]
		]
	)
];


(* ::Subsubsection:: *)
(*ExperimentKarlFischerTitrationPreview*)

DefineTests[
	ExperimentKarlFischerTitrationPreview,
	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentKarlFischerTitrationPreview[Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID]],
			Null
		],
		Example[{Basic, "Return Null for multiple samples:"},
			ExperimentKarlFischerTitrationPreview[{Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID]}],
			Null
		]
	},
	TurnOffMessages :> {
		Warning::SamplesOutOfStock
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test Bench for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 1 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 2 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 3 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID],
				Object[Sample, "Test Sample 1 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True];
		];
		(* note that these instruments cannot be made $DeveloperObject because otherwise frq not going to find them and will freak out *)
		makeTestKFInstruments[ExperimentKarlFischerTitrationPreview];
		Block[{$DeveloperUpload = True},
			Module[{testBench, sample1, sample2, sample3, tube1, tube2, tube3},
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test Bench for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID
					|>
				];

				{
					tube1,
					tube2,
					tube3
				} = UploadSample[
					{
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Container 1 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID,
						"Test Container 2 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID,
						"Test Container 3 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID
					}
				];
				{
					sample1,
					sample2,
					sample3
				} = UploadSample[
					{
						Model[Sample, "Caffeine"],
						Model[Sample, "Caffeine"],
						Model[Sample, "Toluene, Reagent Grade"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3}
					},
					Name -> {
						"Test Sample 1 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID,
						"Test Sample 2 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID,
						"Test Sample 3 for ExperimentKarlFischerTitrationPreview tests" <> $SessionUUID
					},
					InitialAmount -> {
						2 Gram,
						2 Gram,
						10 Milliliter
					}
				];
			]
		]
	)
];



(* ::Subsubsection:: *)
(*KarlFischerTitration*)

DefineTests[
	KarlFischerTitration,
	{
		Example[{Basic, "Create a ManualSamplePreparation with KarlFischerTitration in it:"},
			ExperimentManualSamplePreparation[{
				KarlFischerTitration[
					Sample -> {
						Object[Sample, "Test Sample 2 for KarlFischerTitration tests" <> $SessionUUID],
						Object[Sample, "Test Sample 3 for KarlFischerTitration tests" <> $SessionUUID],
						Object[Sample, "Test Sample 4 for KarlFischerTitration tests" <> $SessionUUID]
					}
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic,"Specify the way the Karl Fischer reagent is generated and reacted with the sample.  If liquid samples are provided and no other information is specified, defaults to Volumetric:"},
			ExperimentManualSamplePreparation[{
				KarlFischerTitration[
					Sample -> {Object[Sample, "Test Sample 2 for KarlFischerTitration tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for KarlFischerTitration tests" <> $SessionUUID]},
					Technique -> Volumetric
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		]
	},
	TurnOffMessages :> {
		Warning::SamplesOutOfStock
	},
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test Bench for KarlFischerTitration tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 1 for KarlFischerTitration tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 2 for KarlFischerTitration tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 3 for KarlFischerTitration tests" <> $SessionUUID],
				Object[Container, Vessel, "Test Container 4 for KarlFischerTitration tests" <> $SessionUUID],
				Object[Sample, "Test Sample 1 for KarlFischerTitration tests" <> $SessionUUID],
				Object[Sample, "Test Sample 2 for KarlFischerTitration tests" <> $SessionUUID],
				Object[Sample, "Test Sample 3 for KarlFischerTitration tests" <> $SessionUUID],
				Object[Sample, "Test Sample 4 for KarlFischerTitration tests" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True];
		];
		(* note that these instruments cannot be made $DeveloperObject because otherwise frq not going to find them and will freak out *)
		makeTestKFInstruments[KarlFischerTitration];
		Block[{$DeveloperUpload = True},
			Module[{testBench, sample1, sample2, sample3, sample4, tube1, tube2, tube3, tube4},
				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test Bench for KarlFischerTitration tests" <> $SessionUUID
					|>
				];

				{
					tube1,
					tube2,
					tube3,
					tube4
				} = UploadSample[
					{
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "15mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test Container 1 for KarlFischerTitration tests" <> $SessionUUID,
						"Test Container 2 for KarlFischerTitration tests" <> $SessionUUID,
						"Test Container 3 for KarlFischerTitration tests" <> $SessionUUID,
						"Test Container 4 for KarlFischerTitration tests" <> $SessionUUID
					}
				];
				{
					sample1,
					sample2,
					sample3,
					sample4
				} = UploadSample[
					{
						Model[Sample, "Caffeine"],
						Model[Sample, "Caffeine"],
						Model[Sample, "Toluene, Reagent Grade"],
						Model[Sample, "Ibuprofen tablets 500 Count"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", tube4}
					},
					Name -> {
						"Test Sample 1 for KarlFischerTitration tests" <> $SessionUUID,
						"Test Sample 2 for KarlFischerTitration tests" <> $SessionUUID,
						"Test Sample 3 for KarlFischerTitration tests" <> $SessionUUID,
						"Test Sample 4 for KarlFischerTitration tests" <> $SessionUUID
					},
					InitialAmount -> {
						2 Gram,
						2 Gram,
						10 Milliliter,
						500
					}
				];
			]
		]
	)
];
