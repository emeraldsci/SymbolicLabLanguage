(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*ExperimentCentrifuge: Tests*)



(* ::Section::Closed:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Centrifuge*)

DefineTests[
	ExperimentCentrifuge,
	{
		Example[{Options, PreparatoryUnitOperations, "Specify prepared samples for ExperimentCentrifuge:"},
			Download[ExperimentCentrifuge["Container 1",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "Container 1",
						Container -> Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]
					],
					Transfer[
						Source -> Model[Sample, "Isopropanol"],
						Amount -> 30 * Microliter,
						Destination -> {"A1", "Container 1"}
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Amount -> 30 * Microliter,
						Destination -> {"A2", "Container 1"}
					]
				}
			], PreparatoryUnitOperations],
			{
				SamplePreparationP..
			}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentCentrifuge[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared (robotic):"},
			protocol = ExperimentCentrifuge[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				PreparedModelAmount -> 1 Milliliter,
				Preparation -> Robotic
			];
			Download[protocol, OutputUnitOperations[[1]][{SampleLink, ContainerLink, AmountVariableUnit, Well, ContainerLabel}]],
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESNT BUG ON THIS. *)
		Example[{Additional, "Use the sample preparation options to prepare samples before the main experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], Incubate -> True, Filtration -> True, Aliquot -> True, Output -> Options];
			{Lookup[options, Incubate], Lookup[options, Filtration], Lookup[options, Aliquot]},
			{True, True, True},
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], IncubationTemperature -> 40 * Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], IncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], MaxIncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], AnnealingTime -> 40 * Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], IncubateAliquot -> 1.5 * Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			TimeConstraint -> 300
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			TimeConstraint -> 500
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			TimeConstraint -> 500
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}, TimeConstraint -> 500
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			TimeConstraint -> 500
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 * Micrometer,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], PrefilterPoreSize -> 1. * Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1. * Micrometer,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentCentrifuge[Object[Sample, "50 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], FilterIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], FilterTime -> 5 * Minute, Output -> Options];
			Lookup[options, FilterTime],
			5 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], FilterTemperature -> 10 * Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages :> {Warning::ContainerCentrifugeIncompatible},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FilterAliquot -> 1.5 * Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			1.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "1 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], AliquotAmount -> 0.08 Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], AliquotAmount -> 0.08 * Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], AssayVolume -> 0.08 * Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], TargetConcentration -> 0.1 * Millimolar, Output -> Options];
			Lookup[options, TargetConcentration],
			0.1 * Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Specify which component of sample to set to the specified target concentration:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], TargetConcentration -> 0.1 * Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Sodium Chloride"], Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Sodium Chloride"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 9 Milliliter,
				AssayVolume -> 10 Milliliter,
				Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 9 Milliliter,
				AssayVolume -> 10 Milliliter,
				Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 9 Milliliter,
				AssayVolume -> 10 Milliliter,
				Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID],
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 9 Milliliter,
				AssayVolume -> 10 Milliliter,
				Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentCentrifuge[Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentCentrifuge[
				Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
				Aliquot -> True, AliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentCentrifuge[Object[Container, Vessel, "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentCentrifuge[Object[Container, Vessel, "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID], MeasureVolume -> False],
				CalculatedUnitOperations[MeasureVolume]
			],
			{False}
		],
		Example[{Options, MeasureWeight, "Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentCentrifuge[Object[Container, Vessel, "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID], MeasureWeight -> False],
				CalculatedUnitOperations[MeasureWeight]
			],
			{False}
		],
		Example[{Options, Preparation, "Indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell:"},
			Download[
				ExperimentCentrifuge[{Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID]}, Preparation -> Robotic],
				OutputUnitOperations[Preparation]
			],
			{Robotic, Robotic}
		],

		Example[{Basic, "Centrifuge all of the samples in a single container:"},
			ExperimentCentrifuge[Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID]],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional, "Centrifuge the specific position on a well:"},
			ExperimentCentrifuge[{"A1", Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, Centrifuge]],
			Messages :> {Warning::SampleStowaways}
		],
		Example[{Additional, "Centrifuge a mixture of inputs for all kinds:"},
			ExperimentCentrifuge[{
				{"A1", Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID]},
				Object[Container, Vessel, "15 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID]
			}],
			ObjectP[Object[Protocol, Centrifuge]],
			Messages :> {Warning::SampleStowaways}
		],
		Example[{Basic, "Centrifuge all of the samples in multiple containers:"},
			ExperimentCentrifuge[{
				Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
				Object[Container, Vessel, "15 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Centrifuge a single sample:"},
			ExperimentCentrifuge[Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID]],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Centrifuge multiple samples:"},
			ExperimentCentrifuge[{
				Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic, "Specify a mixture of containers and samples to centrifuge:"},
			ExperimentCentrifuge[{
				Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
				Object[Container, Plate, "Regular 2mL 96-well plate with 3 1mL samples for ExperimentCentrifuge Unit Testing " <> $SessionUUID]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional, "Generate a RoboticSamplePreparation method when preparation->Robotic:"},
			ExperimentCentrifuge[{Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID]}, Preparation -> Robotic],
			ObjectP[Object[Protocol, RoboticSamplePreparation]],
			Stubs :> {
				$DeveloperSearch = False
			}
		],
		Example[{Additional, "VSpin is preferred at low speed robotic spinning:"},
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)
				},
					Intensity -> 200 GravitationalAcceleration,
					Preparation -> Robotic
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]] ..}, {Null}},
			Stubs :> {
			}
		],
		Example[{Additional, "HiG is chosen for high speed robotic spinning:"},
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)
				},
					Intensity -> 2000 GravitationalAcceleration,
					Preparation -> Robotic
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "HiG4"]] ..}, {Null}},
			Stubs :> {$DeveloperSearch = False}
		],
		Example[{Options, WorkCell, "Specify the STAR WorkCell to use:"},
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)
				},
					WorkCell -> STAR, Preparation -> Robotic
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "VSpin"]] ..}, {Null}},
			Stubs :> {$DeveloperSearch = False}
		],
		Example[{Options, WorkCell, "Specify the bioSTAR WorkCell to use:"},
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)
				},
					WorkCell -> bioSTAR, Preparation -> Robotic
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "HiG4"]]..}, {Null}},
			Stubs :> {$DeveloperSearch = False}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentCentrifuge[{Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)},
				OptionsResolverOnly -> True, WorkCell -> STAR, Preparation -> Robotic, Output -> Options
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentCentrifuge[{Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)},
				OptionsResolverOnly -> True, WorkCell -> STAR, Preparation -> Robotic, Output -> Result
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		],
		Test["Specify the microbioSTAR WorkCell to use:",
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)
				},
					WorkCell -> microbioSTAR, Preparation -> Robotic
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "HiG4"]]..}, {Null}},
			Stubs :> {$DeveloperSearch = False}
		],
		Test["ExperimentCentrifuge works correctly on a plate with an empty counterweight field using robotic:",
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "Centrifuge Test plate without counterweights" <> $SessionUUID]
				},
					WorkCell -> bioSTAR, Preparation -> Robotic
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "HiG4"]]..}},
			Stubs :> {$DeveloperSearch = False,
				Experiment`Private`allCentrifugableContainersSearch["Memoization"] :=
					{Model[Container, Vessel, "id:01G6nvkKrrb1"], Model[Container, Vessel,
						"id:eGakld01zzpq"], Model[Container, Plate, "id:L8kPEjkmLbvW"],
						Model[Container, Plate, "id:n0k9mGzRaaBn"], Model[Container, Vessel,
						"id:eGakld01zzBq"], Model[Container, Plate, "id:Vrbp1jG800ME"],
						Model[Container, Plate, "id:E8zoYveRllM7"], Model[Container, Vessel,
						"id:rea9jl1orrMp"], Model[Container, Vessel, "id:bq9LA0dBGGrd"],
						Download[Object[Container, Plate, "Centrifuge Test plate without counterweights" <> $SessionUUID][Model], Object]}
			},
			TearDown :> (ClearMemoization[])

		],
		Test["ExperimentCentrifuge works correctly on a plate with an empty counterweight field using manual:",
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "Centrifuge Test plate without counterweights" <> $SessionUUID]
				}
				],
				CalculatedUnitOperations[Instrument]],
			{{ObjectP[Model[Instrument, Centrifuge]]..}},
			Stubs :> {$DeveloperSearch = False,
				Experiment`Private`allCentrifugableContainersSearch["Memoization"] :=
					{Model[Container, Vessel, "id:01G6nvkKrrb1"], Model[Container, Vessel,
						"id:eGakld01zzpq"], Model[Container, Plate, "id:L8kPEjkmLbvW"],
						Model[Container, Plate, "id:n0k9mGzRaaBn"], Model[Container, Vessel,
						"id:eGakld01zzBq"], Model[Container, Plate, "id:Vrbp1jG800ME"],
						Model[Container, Plate, "id:E8zoYveRllM7"], Model[Container, Vessel,
						"id:rea9jl1orrMp"], Model[Container, Vessel, "id:bq9LA0dBGGrd"],
						Download[Object[Container, Plate, "Centrifuge Test plate without counterweights" <> $SessionUUID][Model], Object]}
			},
			TearDown :> (ClearMemoization[])
		],
		Test["ExperimentCentrifuge picks the HiG4 if a plate is too tall for the VSpin:",
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "Centrifuge Test tall plate" <> $SessionUUID]
				},
					Preparation -> Robotic
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "HiG4"]]..}},
			Stubs :> {$DeveloperSearch = False,
				Experiment`Private`allCentrifugableContainersSearch["Memoization"] :=
					{Model[Container, Vessel, "id:01G6nvkKrrb1"], Model[Container, Vessel,
						"id:eGakld01zzpq"], Model[Container, Plate, "id:L8kPEjkmLbvW"],
						Model[Container, Plate, "id:n0k9mGzRaaBn"], Model[Container, Vessel,
						"id:eGakld01zzBq"], Model[Container, Plate, "id:Vrbp1jG800ME"],
						Model[Container, Plate, "id:E8zoYveRllM7"], Model[Container, Vessel,
						"id:rea9jl1orrMp"], Model[Container, Vessel, "id:bq9LA0dBGGrd"],
						Download[Object[Container, Plate, "Centrifuge Test tall plate" <> $SessionUUID][Model], Object]}
			},
			TearDown :> (ClearMemoization[])
		],
		Test["ExperimentCentrifuge throws an error if a too-tall plate is used on WorkCell STAR (which has VSpin only):",
			ExperimentCentrifuge[{
				Object[Container, Plate, "Centrifuge Test tall plate" <> $SessionUUID]
			},
				WorkCell -> STAR,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {Error::NoCompatibleCentrifuge, Error::InvalidOption},
			Stubs :> {$DeveloperSearch = True,
				Experiment`Private`allCentrifugableContainersSearch["Memoization"] := {
					Model[Container, Vessel, "id:01G6nvkKrrb1"],
					Model[Container, Vessel, "id:eGakld01zzpq"],
					Model[Container, Plate, "id:L8kPEjkmLbvW"],
					Model[Container, Plate, "id:n0k9mGzRaaBn"],
					Model[Container, Vessel, "id:eGakld01zzBq"],
					Model[Container, Plate, "id:Vrbp1jG800ME"],
					Model[Container, Plate, "id:E8zoYveRllM7"],
					Model[Container, Vessel, "id:rea9jl1orrMp"],
					Model[Container, Vessel, "id:bq9LA0dBGGrd"],
					Download[Object[Container,Plate,"Centrifuge Test tall plate"<>$SessionUUID][Model],Object]
				}
			},
			TearDown :> (ClearMemoization[])
		],
		Test["ExperimentCentrifuge picks HiG if a plate too heavy for the VSpin is used:",
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "Centrifuge Test heavy plate" <> $SessionUUID]
				},
					Preparation -> Robotic
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "HiG4"]]..}},
			Stubs :> {$DeveloperSearch = False,
				Experiment`Private`allCentrifugableContainersSearch["Memoization"] := {
					Model[Container, Vessel, "id:01G6nvkKrrb1"],
					Model[Container, Vessel, "id:eGakld01zzpq"],
					Model[Container, Plate, "id:L8kPEjkmLbvW"],
					Model[Container, Plate, "id:n0k9mGzRaaBn"],
					Model[Container, Vessel, "id:eGakld01zzBq"],
					Model[Container, Plate, "id:Vrbp1jG800ME"],
					Model[Container, Plate, "id:E8zoYveRllM7"],
					Model[Container, Vessel, "id:rea9jl1orrMp"],
					Model[Container, Vessel, "id:bq9LA0dBGGrd"],
					Download[Object[Container, Plate, "Centrifuge Test heavy plate" <> $SessionUUID][Model], Object]}
			},
			TearDown :> (ClearMemoization[])
		],
		Test["ExperimentCentrifuge throws an error if a too heavy plate is used on WorkCell STAR (which has VSpin only):",
			ExperimentCentrifuge[{
				Object[Container, Plate, "Centrifuge Test heavy plate" <> $SessionUUID]
			},
				WorkCell -> STAR,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {Error::NoCompatibleCentrifuge, Error::InvalidOption},
			Stubs :> {$DeveloperSearch = False,
				Experiment`Private`allCentrifugableContainersSearch["Memoization"] := {
					Model[Container, Vessel, "id:01G6nvkKrrb1"],
					Model[Container, Vessel, "id:eGakld01zzpq"],
					Model[Container, Plate, "id:L8kPEjkmLbvW"],
					Model[Container, Plate, "id:n0k9mGzRaaBn"],
					Model[Container, Vessel, "id:eGakld01zzBq"],
					Model[Container, Plate, "id:Vrbp1jG800ME"],
					Model[Container, Plate, "id:E8zoYveRllM7"],
					Model[Container, Vessel, "id:rea9jl1orrMp"],
					Model[Container, Vessel, "id:bq9LA0dBGGrd"],
					Download[Object[Container,Plate,"Centrifuge Test heavy plate"<>$SessionUUID][Model],Object]
				}
			},
			TearDown :> (ClearMemoization[])
		],
		Test["ExperimentCentrifuge throws an error if a plate with a too heavy sample is used:",
			ExperimentCentrifuge[{
				Object[Container, Plate, "Centrifuge Test normal plate with one heavy sample" <> $SessionUUID]
			},
				WorkCell -> STAR,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {Error::CentrifugeContainerTooHeavy, Error::InvalidInput},
			Stubs :> {$DeveloperSearch = False,
				Experiment`Private`allCentrifugableContainersSearch["Memoization"] := {
					Model[Container, Vessel, "id:01G6nvkKrrb1"],
					Model[Container, Vessel, "id:eGakld01zzpq"],
					Model[Container, Plate, "id:L8kPEjkmLbvW"],
					Model[Container, Plate, "id:n0k9mGzRaaBn"],
					Model[Container, Vessel, "id:eGakld01zzBq"],
					Model[Container, Plate, "id:Vrbp1jG800ME"],
					Model[Container, Plate, "id:E8zoYveRllM7"],
					Model[Container, Vessel, "id:rea9jl1orrMp"],
					Model[Container, Vessel, "id:bq9LA0dBGGrd"],
					Download[Object[Container,Plate,"Centrifuge Test normal plate with one heavy sample"<>$SessionUUID][Model],Object]
				}
			},
			TearDown :> (ClearMemoization[])
		],
		Test["ExperimentCentrifuge throws proper errors if you try to use a no skirt plate on the HiG (because of insert):",
			ExperimentCentrifuge[{
				Object[Container, Plate, "96-well PCR plate with 1 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID]
			},
				WorkCell -> bioSTAR,
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {Error::NoCompatibleCentrifuge, Error::InvalidOption},
			Stubs :> {$DeveloperSearch = False}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCentrifuge[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCentrifuge[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCentrifuge[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCentrifuge[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
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
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentCentrifuge[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
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
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentCentrifuge[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "EmptyContainer", "If an empty container is given as input, return $Failed:"},
			ExperimentCentrifuge[Object[Container, Vessel, "Empty container for ExperimentCentrifuge testing" <> $SessionUUID]],
			$Failed,
			Messages :> {Error::EmptyContainers}
		],
		Example[{Messages, "EmptyContainer", "If an empty container is given as one of the inputs, return $Failed:"},
			ExperimentCentrifuge[{
				Object[Container, Vessel, "15 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
				Object[Container, Vessel, "Empty container for ExperimentCentrifuge testing" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::EmptyContainers}
		],

		Example[{Messages, "DiscardedSamples", "If a sample is discarded, returns $Failed:"},
			ExperimentCentrifuge[{
				Object[Sample, "Discarded sample for ExperimentCentrifuge testing" <> $SessionUUID]
			}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],

		Example[{Messages, "InstrumentPrecision", "Gives a warning and rounds the temperature option if temperature is more precise than 1C:"},
			Download[ExperimentCentrifuge[
				{
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID]
				},
				Temperature -> 30.001Celsius],
				OutputUnitOperations[TemperatureReal]],
			{{Quantity[30., "DegreesCelsius"], Quantity[30., "DegreesCelsius"], Quantity[30., "DegreesCelsius"], Quantity[30., "DegreesCelsius"]}},
			Messages :> {Warning::InstrumentPrecision}
		],
		Example[{Messages, "InstrumentPrecision", "Gives a warning and rounds the time option if time is more precise than 1 second:"},
			Download[ExperimentCentrifuge[
				{
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID]
				},
				Time -> 50.5`Second],
				OutputUnitOperations[Time]],
			{{Quantity[0.85, "Minutes"], Quantity[0.85, "Minutes"], Quantity[0.85, "Minutes"], Quantity[0.85, "Minutes"]}},
			Messages :> {Warning::InstrumentPrecision}
		],


		Example[{Messages, "IncompatibleCentrifuge", "If centrifuge is specified as an object, and the corresponding centrifuge model cannot reach the desired settings, throws an error and returns $Failed:"},
			ExperimentCentrifuge[{
				Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID](* sample in container that will fit cent 2 *)
			},
				Temperature -> 30 Celsius,
				Instrument -> Object[Instrument, Centrifuge, "Test object centrifuge for ExperimentCentrifuge (2, sterile)" <> $SessionUUID](*cent 2 object--  that can't do 30C*)
			],
			$Failed,
			Messages :> {Error::IncompatibleCentrifuge, Error::InvalidOption}
		],
		Example[{Messages, "IncompatibleCentrifuge", "If centrifuge is specified as model, and the centrifuge model cannot reach the desired settings, throws an error and returns $Failed:"},
			ExperimentCentrifuge[{
				Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID](* sample in container that will fit cent 2 *)
			},
				Temperature -> 30 Celsius,
				Instrument -> Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID](*cent 2 model--  that can't do 30C*)
			],
			$Failed,
			Messages :> {Error::IncompatibleCentrifuge, Error::InvalidOption}
		],
		Example[{Options, Instrument, "Specify the centrifuge to use as model:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID](* sample in container that will fit cent 2 *)
				},
					Instrument -> Model[Instrument, Centrifuge, "Avanti J-15R"](*cent 2 model--  that can't do 30C*)
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]]}}
		],
		Example[{Options, Instrument, "Specify the centrifuge to use an object:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID](* sample in container that will fit cent 2 *)
				},
					Instrument -> Object[Instrument, Centrifuge, "Test object centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID]
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Object[Instrument, Centrifuge, "Test object centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID]]}}
		],
		Example[{Messages, "NoCompatibleCentrifuge", "If no centrifuges could be found that can match the desired settings, throws and error and returns $Failed:"},
			ExperimentCentrifuge[{
				Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID](*samples that will fit on cent 1*)
			},
				Temperature -> -10 Celsius, Intensity -> 20000 RPM
			],
			$Failed,
			Messages :> {Error::NoCompatibleCentrifuge, Error::InvalidOption}
		],
		Example[{Options, Instrument, "Centrifuge automatically resolves to a centrifuge that will work with the desired settings. If possible, a centrifuge that will work the current container of the sample is chosen:"},
			Download[
				ExperimentCentrifuge[{
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID](*will only fit on cent 2*)
				},
					Intensity -> Quantity[500., ("Revolutions") / ("Minutes")]
				],
				CalculatedUnitOperations[Instrument]],
			{{LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
				LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
				LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
				LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]]}}
		],
		Example[{Options, Instrument, "Centrifuge automatically resolves to the same centrifuge model when possible without transferring samples:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID](*will fit on cent 1 and 2*)
				},
					Intensity -> Quantity[500., ("Revolutions") / ("Minutes")]
				],
				CalculatedUnitOperations[Instrument]],
			{
				{
					LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
					LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
					LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
					LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]]
				}
			}
		],
		Example[{Options, Instrument, "Centrifuge automatically resolves to the ultracentrifuge at high rotation rate:"},
			Download[
				ExperimentCentrifuge[
					Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Intensity -> 50000RPM
				],
				CalculatedUnitOperations[Instrument]
			],
			{
				{LinkP[Model[Instrument, Centrifuge, "id:lYq9jRxY9RzA"]]}
			},
			SetUp :> {
				ClearMemoization[];
				$DeveloperSearch = False;
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],
		Example[{Options, RotorGeometry, "The type of rotors desired whether it's a fixed-angle or a swinging bucket:"},
			Lookup[
				ExperimentCentrifuge[
					Object[Sample, "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Intensity -> 30000RPM,
					RotorGeometry -> SwingingBucketRotor,
					ChilledRotor -> False,
					Output -> Options
				],
				Rotor
			],
			ObjectP[Model[Container, CentrifugeRotor, "Swing Bucket Rotor SW 32 Ti"]],
			SetUp :> {
				ClearMemoization[];
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:N80DNj18DMdk"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:N80DNj18DMdk"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],
		Example[{Options, RotorAngle, "The angle at which the samples tilts from the verticle axis while sitting in the Rotor:"},
			Lookup[
				ExperimentCentrifuge[
					Object[Sample, "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Intensity -> 30000RPM,
					RotorAngle -> Degree23,
					ChilledRotor -> False,
					Output -> Options
				],
				Rotor
			],
			ObjectP[Model[Container, CentrifugeRotor, "Fixed-Angle Rotor Type 70 Ti"]],
			SetUp :> {
				ClearMemoization[];
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:vXl9j57X91xm"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:vXl9j57X91xm"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],
		Example[{Options, ChilledRotor, "Whether the centrifuge rotor is kept in refrigerated conditions prior to the protocol:"},
			Lookup[
				ExperimentCentrifuge[
					Object[Sample, "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Intensity -> 30000RPM,
					ChilledRotor -> True,
					Output -> Options
				],
				ChilledRotor
			],
			True,
			SetUp :> {
				ClearMemoization[];
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:8qZ1VW0qbYon"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:8qZ1VW0qbYon"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],
		Example[{Options, Rotor, "Automatically resolve to a Rotor that's compatible with the resolved Centrifuge Instrument. If multiple rotors are compatible, the simpliest setup will be use (without buckets, adapters, etc.):"},
			Lookup[
				ExperimentCentrifuge[
					Object[Sample, "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Intensity -> 30000RPM,
					Output -> Options
				],
				Rotor
			],
			ObjectP[Model[Container, CentrifugeRotor, "Fixed-Angle Rotor Type 70 Ti Refrigerator"]],
			SetUp :> {
				ClearMemoization[];
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:vXl9j57X91xm"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:vXl9j57X91xm"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],
		Example[{Options, Rotor, "A specific centrifuge rotor desired to use in the experiment protocol:"},
			Lookup[
				ExperimentCentrifuge[
					Object[Sample, "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Intensity -> 30000RPM,
					Rotor -> Model[Container, CentrifugeRotor, "id:O81aEBZ8aM4O"],
					ChilledRotor -> False,
					Output -> Options
				],
				Rotor
			],
			ObjectP[Model[Container, CentrifugeRotor, "Swing Bucket Rotor SW 32 Ti"]],
			SetUp :> {
				ClearMemoization[];
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:N80DNj18DMdk"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:N80DNj18DMdk"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],
		Example[{Options, Rotor, "Automatically resolve to the desired rotor from the specified rotor-related parameters:"},
			Lookup[
				ExperimentCentrifuge[
					Object[Sample, "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Intensity -> 30000RPM,
					RotorAngle -> Degree90,
					RotorGeometry -> SwingingBucketRotor,
					ChilledRotor -> True,
					Output -> Options
				],
				Rotor
			],
			ObjectP[Model[Container, CentrifugeRotor, "Swing Bucket Rotor SW 32 Ti Refrigerator"]],
			SetUp :> {
				ClearMemoization[];
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:N80DNj18DMdk"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:N80DNj18DMdk"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],

		Example[{Messages, "RotorRotorGeometryConflict", "If both Rotor and RotorGeometry are specified, their values have to be consistent:"},
			ExperimentCentrifuge[
				Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
				Intensity -> 50000RPM,
				Rotor -> Model[Container, CentrifugeRotor, "Fixed-Angle Rotor Type 70.1 Ti"],
				RotorGeometry -> SwingingBucketRotor
			],
			$Failed,
			Messages :> {Error::RotorRotorGeometryConflict, Error::InvalidOption},
			SetUp :> {
				ClearMemoization[];
				$DeveloperSearch = False;
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:N80DNj18DMdk"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:N80DNj18DMdk"],
					Replace[RequestedResources] -> {}
				|>]
			}

		],
		Example[{Messages, "RotorRotorAngleConflict", "If both Rotor and RotorAngle are specified, their values have to be consistent:"},
			ClearMemoization[];
			ExperimentCentrifuge[
				Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
				Intensity -> 50000RPM,
				Rotor -> Model[Container, CentrifugeRotor, "Fixed-Angle Rotor Type 70.1 Ti"],
				RotorAngle -> Degree23
			],
			$Failed,
			Messages :> {Error::RotorRotorAngleConflict, Error::InvalidOption},
			SetUp :> {
				ClearMemoization[];
				$DeveloperSearch = False;
			}
		],
		Example[{Messages, "RotorInstrumentConflict", "If both Rotor and Instrument are specified, the specified Rotor must have the correct Footprint to fit onto the specified Instrument:"},
			ExperimentCentrifuge[
				Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Centrifuge, "id:lYq9jRxY9RzA"],
				Rotor -> Model[Container, CentrifugeRotor, "id:wqW9BP7x5A4M"]
			],
			$Failed,
			Messages :> {Error::RotorInstrumentConflict, Error::InvalidOption},
			SetUp :> {
				ClearMemoization[];
				$DeveloperSearch = False;
			}
		],
		Example[{Messages, "RotorDefaultStorageConditionChilledRotorConflict", "If both Rotor and ChilledRotor are specified, the storage condition of the specified Rotor must be consistent with the boolean of ChilledRotor:"},
			ExperimentCentrifuge[
				Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
				Intensity -> 50000RPM,
				Rotor -> Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
				ChilledRotor -> True
			],
			$Failed,
			Messages :> {Error::RotorDefaultStorageConditionChilledRotorConflict, Error::InvalidOption},
			SetUp :> {
				ClearMemoization[];
				$DeveloperSearch = False;
			}
		],
		Example[{Messages, "InstrumentCentrifugeTypeChilledRotorConflict", "If both Instrument and ChilledRotor are specified, the Instrument has to be an ultracentrifuge:"},
			ExperimentCentrifuge[
				Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Centrifuge, "Avanti J-15R with JA-10.100 Fixed Angle Rotor"],
				ChilledRotor -> True
			],
			$Failed,
			Messages :> {Error::InstrumentCentrifugeTypeChilledRotorConflict, Error::InvalidOption},
			Stubs :> {
				$DeveloperSearch = True
			}
		],
		Example[{Messages, "UltracentrifugeChilledRotorHighTempConflict", "If ChilledRotor is set to True and Temperature is specified, the specified Temperature must be between 4 Celsius and Ambient Temperature:"},
			ExperimentCentrifuge[
				Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
				Intensity -> 50000RPM,
				ChilledRotor -> True,
				Temperature -> 30 Celsius
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages :> {Warning::UltracentrifugeChilledRotorHighTempConflict},
			SetUp :> {
				ClearMemoization[];
				$DeveloperSearch = False;
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
					Replace[RequestedResources] -> {}
				|>]
			}

		],
		Example[{Messages, "UltracentrifugeChilledRotorLowTempConflict", "If ChilledRotor is set to False and Temperature is specified, the specified Temperature must not be lower than Ambient Temperature:"},
			ExperimentCentrifuge[
				Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
				Intensity -> 50000RPM,
				ChilledRotor -> False,
				Temperature -> 20 Celsius
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages :> {Warning::UltracentrifugeChilledRotorLowTempConflict},
			SetUp :> {
				ClearMemoization[];
				$DeveloperSearch = False;
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],
		Example[{Messages, "NoCompatibleRotor", "If no compatible rotor can be found with the specified rotor parameters, throw an error:"},
			ClearMemoization[];
			ExperimentCentrifuge[
				Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
				Intensity -> 50000RPM,
				RotorAngle -> Degree90,
				RotorGeometry -> FixedAngleRotor
			],
			$Failed,
			Messages :> {Error::NoCompatibleRotor, Error::CentrifugeRotorOptionsNotSpecified, Error::InvalidOption},
			SetUp :> {
				$DeveloperSearch = False;
			}
		],

		Example[{Options, Sterile, "Specify that a sterile centrifuge should be used:"},
			ExperimentCentrifuge[{
				Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID](* sample in container that will fit cent 2 *)
			},
				Sterile -> True
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],

		Example[{Messages, "SterileConflict", "If the user specified sterile as False and any samples are sterile, a warning is given:"},
			ExperimentCentrifuge[{
				Object[Sample, "Sample oligo with volume, sterile, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID](* sample in container that will fit cent 2 *)
			},
				Sterile -> False
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages :> {Warning::SterileConflict}
		],
		Example[{Messages, "ContainerCentrifugeIncompatible", "If a centrifuge cannot be found that works with the current container model, the sample will be transferred to another container. If possible, the sample will be transferred to a plate if it is currently in a plate, and to a vessel if it is currently in a vessel.:"},
			With[{protocol = ExperimentCentrifuge[{
				Object[Sample, "10 mL sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID]
			},
				Intensity -> Quantity[10000., ("Revolutions") / ("Minutes")]
			]},
				{Download[protocol, Centrifuges], Lookup[Download[protocol, AliquotSamplePreparation], AliquotContainer]}],
			{
				{
					ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R with JA-10.100 Fixed Angle Rotor"]]
				},
				{
					{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}
				}
			},
			Messages :> {Warning::ContainerCentrifugeIncompatible}
		],
		Example[{Messages, "ContainerCentrifugeIncompatible", "If a centrifuge cannot be found that works with the current container model, the sample will be transferred to another container. The sample may be moved from a plate to a vessel or vice versa if a container of the same type could not be found:"},
			With[{protocol = ExperimentCentrifuge[{
				Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID]
			},
				Intensity -> Quantity[10000., ("Revolutions") / ("Minutes")]
			]},
				{Download[protocol, Centrifuges], Lookup[Download[protocol, AliquotSamplePreparation], AliquotContainer]}],
			{
				{
					ObjectP[Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"]],
					ObjectP[Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"]],
					ObjectP[Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"]]
				},
				{
					{1, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]},
					{2, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]},
					{3, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]}
				}
			},
			Messages :> {Warning::ContainerCentrifugeIncompatible}
		],
		Example[{Messages, "ContainerCentrifugeIncompatible", "If the current container model does not work with the desired centrifuge, the sample will be transferred to another container. If possible, the sample will be transferred to a plate if it is currently in a plate, and to a vessel if it is currently in a vessel.:"},
			With[{protocol = ExperimentCentrifuge[
				{Object[Sample, "Sample oligo, 1mL, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID]},
				Instrument -> Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"]
			]},
				{
					Download[protocol, Centrifuges],
					Lookup[Download[protocol, AliquotSamplePreparation], AliquotContainer]
				}
			],
			{
				{ObjectP[Model[Instrument, Centrifuge, "Beckman Coulter Microfuge 20R"]]},
				{{1, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]}}
			},
			Messages :> {Warning::ContainerCentrifugeIncompatible}
		],
		Example[{Messages, "ContainerCentrifugeIncompatible", "If the current container model does not work with the desired centrifuge, the sample will be transferred to another container. The sample may be moved from a plate to a vessel or vice versa if a container of the same type could not be found:"},
			With[{protocol = ExperimentCentrifuge[{
				Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID]
			},
				Instrument -> Model[Instrument, Centrifuge, "Avanti J-15R with JA-10.100 Fixed Angle Rotor"]
			]},
				{Download[protocol, Centrifuges], Lookup[Download[protocol, AliquotSamplePreparation], AliquotContainer]}],
			{{ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R with JA-10.100 Fixed Angle Rotor"]], ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R with JA-10.100 Fixed Angle Rotor"]], ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R with JA-10.100 Fixed Angle Rotor"]]}, {
				{1, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]},
				{2, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]},
				{3, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]}}},
			Messages :> {Warning::ContainerCentrifugeIncompatible}
		],
		Example[{Messages, "NoTransferContainerFound", "If the sample is not in a container that is compatible with a centrifuge of the desired settings and no compatible container could be found to transfer the sample into, throw an error and return $Failed:"},
			ExperimentCentrifuge[{
				Object[Sample, "Large volume sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID]
			},
				Intensity -> Quantity[10000., ("Revolutions") / ("Minutes")]
			],
			$Failed,
			Messages :> {Error::NoTransferContainerFound, Error::InvalidInput}
		],
		Example[{Messages, "NoTransferContainerFound", "If the sample is not in a container that is compatible with the desired centrifuge and no compatible container could be found to transfer the sample into, throw an error and return $Failed:"},
			ExperimentCentrifuge[{
				Object[Sample, "Large volume sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID]
			},
				Instrument -> Model[Instrument, Centrifuge, "Avanti J-15R with JA-10.100 Fixed Angle Rotor"]
			],
			$Failed,
			Messages :> {Error::NoTransferContainerFound, Error::InvalidInput}
		],


		Example[{Messages, "CentrifugePrecision", "Gives a warning and rounds the rate option if the rate is more precise than the achievable precision of the specified centrifuge:"},
			Download[ExperimentCentrifuge[
				{Object[Sample, "Sample oligo, 1mL, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID]},
				Intensity -> Quantity[544, ("Revolutions") / ("Minutes")]
			],
				OutputUnitOperations[Intensity]],
			{{Quantity[540, ("Revolutions") / ("Minutes")]}},
			Messages :> {Warning::CentrifugePrecision},
			EquivalenceFunction -> Equal
		],

		Example[{Messages, "SampleStowaways", "If there are non-input samples in the same containers as any input samples, samples will be transferred to exclude non-input samples:"},
			Lookup[Download[ExperimentCentrifuge[{
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID],
				Object[Sample, "Sample oligo, 1mL, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID]
			}
			], AliquotSamplePreparation], AliquotContainer],
			(* check the aliquot options for confirm transfer of the sample with stowaways but not of the others *)
			{
				{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				Null,
				{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
			},
			Messages :> {Warning::SampleStowaways}
		],

		Example[{Options, Temperature, "Specify the temperature that the samples will be centrifuged at:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID]
				},
					Temperature -> 37Celsius
				],
				OutputUnitOperations[TemperatureReal]],
			{{Quantity[37.`, "DegreesCelsius"]}}
		],
		Example[{Options, Temperature, "Specify that samples will be centrifuged at different temperatures:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID](*will fit on cent 1 and 2*)
				},
					Temperature -> {40Celsius, 40Celsius, 40Celsius, Ambient}
				],
				{OutputUnitOperations[TemperatureReal], OutputUnitOperations[TemperatureExpression]}],
			{
				{
					{Quantity[40., "DegreesCelsius"], Quantity[40., "DegreesCelsius"], Quantity[40., "DegreesCelsius"], Null}
				},
				{
					{Null, Null, Null, Ambient}
				}
			}
		],
		Example[{Options, Time, "Specify the duration for which the samples will be centrifuged:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID]
				},
					Time -> 45Minute
				],
				OutputUnitOperations[Time]],
			{{Quantity[45., "Minutes"]}}
		],
		Example[{Options, Time, "Specify that samples will be centrifuged for different durations:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID](*will fit on cent 1 and 2*)
				},
					Time -> {10Minute, 10Minute, 10Minute, 5Minute}
				],
				OutputUnitOperations[Time]],
			{{Quantity[10., "Minutes"], Quantity[10., "Minutes"], Quantity[10., "Minutes"], Quantity[5., "Minutes"]}}
		],
		Example[{Options, Intensity, "Specify the rate with which the samples will be centrifuged:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID](*will fit on cent 1 and 2*)
				},
					Intensity -> Quantity[500, ("Revolutions") / ("Minutes")]
				],
				OutputUnitOperations[Intensity]
			],
			{{Quantity[500, ("Revolutions") / ("Minutes")],
				Quantity[500, ("Revolutions") / ("Minutes")],
				Quantity[500, ("Revolutions") / ("Minutes")],
				Quantity[500, ("Revolutions") / ("Minutes")]}}
		],
		Example[{Options, Intensity, "Specify the force with which the samples will be centrifuged:"},
			Download[
				ExperimentCentrifuge[
					{
						Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID],
						Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID],
						Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID],
						Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID]
					},
					Intensity -> Quantity[295.22`, "StandardAccelerationOfGravity"]
				],
				OutputUnitOperations[Intensity]],
			Messages :> {Warning::CentrifugePrecision},
			{{Quantity[295., "StandardAccelerationOfGravity"],
				Quantity[295., "StandardAccelerationOfGravity"],
				Quantity[295., "StandardAccelerationOfGravity"],
				Quantity[296.71, "StandardAccelerationOfGravity"]}}
		],
		Example[{Options, Intensity, "Specify that samples will be centrifuged at different intensities:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID], (*will only fit on cent 1*)
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID](*will fit on cent 1 and 2*)
				},
					Intensity -> {Quantity[500, ("Revolutions") / ("Minutes")], Quantity[500, ("Revolutions") / ("Minutes")], Quantity[500, ("Revolutions") / ("Minutes")], Quantity[300, ("Revolutions") / ("Minutes")]}
				],
				OutputUnitOperations[Intensity]
			],
			{{Quantity[500, ("Revolutions") / ("Minutes")],
				Quantity[500, ("Revolutions") / ("Minutes")],
				Quantity[500, ("Revolutions") / ("Minutes")],
				Quantity[300, ("Revolutions") / ("Minutes")]}}
		],
		Example[{Options, Intensity, "Intensity automatically resolves to a force that is 1/5 of the max rotational rate of the centrifuge that will be used, rounded to the precision of the centrifuge:"},
			Download[
				ExperimentCentrifuge[{
					Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID](* sample in container that will fit cent 2 *)
				},
					Instrument -> Model[Instrument, Centrifuge, "Avanti J-15R"]
				],
				OutputUnitOperations[Intensity]],
			{{Quantity[967.04, "StandardAccelerationOfGravity"]}}
		],

		Example[{Messages, "ConflictingOptionsWithinContainer", "If samples in the same container are requested to be centrifuged with different time, temperature, instrument, or intensity, the samples will be transferred to different containers:"},
			Lookup[Download[ExperimentCentrifuge[{
				(* Group 1: Container 1, 10 min, 15 C *)Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
				(* Group 2: Container 2, 10 min, 15 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
				(* Group 5: Container 2, 30 min, 15 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (2)" <> $SessionUUID],
				(* Group 3: Container 2, 20 min, 15 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (3)" <> $SessionUUID],
				(* Group 5: Container 2, 30 min, 15 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (4)" <> $SessionUUID],
				(* Group 1: Container 1, 10 min, 15 C *)Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
				(* Group 1: Container 1, 10 min, 15 C *)Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID],
				(* Group 4: Container 2, 20 min, 25 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (5)" <> $SessionUUID],
				(* Group 5: Container 2, 30 min, 15 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (6)" <> $SessionUUID],
				(* Group 2: Container 2, 10 min, 15 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (7)" <> $SessionUUID],
				(* Group 2: Container 2, 10 min, 15 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (8)" <> $SessionUUID],
				(* Group 3: Container 2, 20 min, 15 C *)Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (9)" <> $SessionUUID]
			},
				Time -> {10 Minute, 10 Minute, 30 Minute, 20 Minute, 30 Minute, 10 Minute, 10 Minute, 20 Minute, 30 Minute, 10 Minute, 10 Minute, 20 Minute},
				Temperature -> {15 Celsius, 15 Celsius, 15 Celsius, 15 Celsius, 15 Celsius, 15 Celsius, 15 Celsius, 25 Celsius, 15 Celsius, 15 Celsius, 15 Celsius, 15 Celsius}
			], AliquotSamplePreparation], AliquotContainer],
			{
				Null,
				Null,
				{3, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				{4, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				{3, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				Null,
				Null,
				{8, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				{3, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
				Null,
				Null,
				{4, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}
			},
			Messages :> {Warning::ConflictingOptionsWithinContainer},
			TimeConstraint -> 3000
		],

		Example[{Options, CollectionContainer, "Specify the container that will collect the filtered sample during centrifugation:"},
			Lookup[
				ExperimentCentrifuge[
					Object[Sample, "20 mL sample in 50 mL filter tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Instrument -> Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"],
					CollectionContainer -> Model[Container, Vessel, "id:bq9LA0dBGGrd"],
					Output -> Options
				],
				CollectionContainer
			],
			ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGrd"]]
		],
		Example[{Messages, "ConflictingCollectionContainers", "Throw an error message when the specified collection containers is conflicting with the filter the sample is in:"},
			ExperimentCentrifuge[
				{Object[Sample, "0.2 mL sample in 96 well filter plate for ExperimentCentrifuge testing 1" <> $SessionUUID], Object[Sample, "0.2 mL sample in 96 well filter plate for ExperimentCentrifuge testing 2" <> $SessionUUID]},
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				CollectionContainer -> {Model[Container, Plate, "id:n0k9mGzRaaBn"], Model[Container, Plate, "id:L8kPEjkmLbvW"]}
			],
			$Failed,
			Messages :> {Error::ConflictingCollectionContainers, Error::InvalidInput, Error::InvalidOption}
		],
		Example[{Messages, "SamplesNotInFilterContainer", "Throw an error message when the input sample(s) is not in a filter container when one or more collection containers are specified:"},
			ExperimentCentrifuge[
				Object[Sample, "1 mL sample in 96 well deep well plate for ExperimentCentrifuge testing" <> $SessionUUID],
				Instrument -> Model[Instrument, Centrifuge, "id:eGakldJEz14E"],
				CollectionContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"]
			],
			$Failed,
			Messages :> {Error::SamplesNotInFilterContainer, Error::InvalidInput, Error::InvalidOption}
		],
		Example[{Options, ImageSample, "Specify that the samples should be imaged after the protocol completes:"},
			Download[ExperimentCentrifuge[{
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID]
			},
				ImageSample -> True
			], ImageSample],
			True
		],
		Example[{Options, ImageSample, "If there is a parent protocol and the parent protocol has ImageSample->False, ImageSample is false:"},
			Download[ExperimentCentrifuge[{
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID]
			},
				ParentProtocol -> Object[Protocol, DNASynthesis, "Protocol with ImageSample False for ExperimentCentrifuge testing" <> $SessionUUID]
			], OutputUnitOperations[ImageSample]],
			{False}
		],
		Example[{Options, ImageSample, "If there is a parent protocol and the parent protocol has ImageSample->True, ImageSample is true:"},
			Download[ExperimentCentrifuge[{
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID]
			},
				ParentProtocol -> Object[Protocol, DNASynthesis, "Protocol with ImageSample True for ExperimentCentrifuge testing" <> $SessionUUID]
			], OutputUnitOperations[ImageSample]],
			{True}
		],
		Example[{Options, ImageSample, "The ImageSample option overrides any option pulled from the parent protocol:"},
			Download[ExperimentCentrifuge[{
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID]
			},
				ImageSample -> False,
				ParentProtocol -> Object[Protocol, DNASynthesis, "Protocol with ImageSample True for ExperimentCentrifuge testing" <> $SessionUUID]
			], OutputUnitOperations[ImageSample]],
			{False}
		],
		Example[{Options, ImageSample, "If there is no parent protocol, image sample automatically resolves to True:"},
			Download[ExperimentCentrifuge[{
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID]
			}
			], OutputUnitOperations[ImageSample]],
			{True}
		],

		Example[{Options, Name, "Give the protocol a name:"},
			Download[ExperimentCentrifuge[{
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID]
			},
				Name -> "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID <> $SessionUUID
			], Name],
			("Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID <> $SessionUUID)
		],
		Example[{Messages, "DuplicateName", "If the name is already in use, throws an error:"},
			ExperimentCentrifuge[{
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
				Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID]
			},
				Name -> "Existing centrifuge protocol for ExperimentCentrifuge testing" <> $SessionUUID
			],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[{Messages, "UltracentrifugeNotEnoughSample", "The samples for ultracentrifuge runs have sufficient volume to fill to tube to at least 95% maximum volume:"},
			ExperimentCentrifuge[
				Object[Sample, "5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
				Intensity -> 50000RPM
			],
			$Failed,
			Messages :> {Error::UltracentrifugeNotEnoughSample, Error::InvalidInput},
			SetUp :> {
				ClearMemoization[];
				$DeveloperSearch = False;
				UploadSampleStatus[
					Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
					Available,
					Force -> True
				];
				Upload[<|
					Object -> Object[Container, CentrifugeRotor, "id:aXRlGn6XlBY9"],
					Replace[RequestedResources] -> {}
				|>]
			}
		],

		Test["Makes the expected resources:",
			Module[{protocol, requiredResources, centrifugeResources, groupedCentrifuges, centrifugeMatch, sampleResources,
				sampleMatch, bucketResources, bucketMatch, balanceResource, balanceMatch, rackResources, rackMatch},
				protocol = ExperimentCentrifuge[{
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 9 1mL samples for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (3)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (4)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (5)" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with 1 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (2)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (3)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (4)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (5)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (6)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (7)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (8)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (9)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (10)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (11)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (12)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (13)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (14)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (15)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (16)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (17)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (18)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (19)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (20)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (21)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (22)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (23)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (24)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (25)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (26)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (27)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (28)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (29)" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (30)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (6)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (7)" <> $SessionUUID]
				},
					Time -> {Quantity[15, "Minutes"], Quantity[15, "Minutes"],
						Quantity[15, "Minutes"], Quantity[15, "Minutes"],
						Quantity[15, "Minutes"], Quantity[20, "Minutes"],
						Quantity[20, "Minutes"], Quantity[20, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[30, "Minutes"], Quantity[30, "Minutes"],
						Quantity[5, "Minutes"], Quantity[5, "Minutes"]},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID]
				];

				(* Get the required resources *)
				requiredResources = Download[protocol, RequiredResources];

				(* Get the centrifuge resources *)
				centrifugeResources = Cases[requiredResources, {LinkP[], Centrifuges, ___}];

				(* Gather the centrifuges resources that will use the same resource together *)
				groupedCentrifuges = GatherBy[centrifugeResources, #[[1]][Object] &];

				(* Make sure we have only made 2 centrifuge resources that are used for all 55 samples *)
				centrifugeMatch = MatchQ[groupedCentrifuges[[1]], {Repeated[{LinkP[], Centrifuges, _, Null}, {54}]}];

				(* Make sure we made the sample resources, one per sample *)
				sampleResources = Cases[requiredResources, {LinkP[], SamplesIn, ___}];
				sampleMatch = MatchQ[Length[DeleteDuplicates[sampleResources[[All, 1]][Object]]], 54];

				(* Make sure we made 8 bucket resources, 4 each of 2 models *)
				bucketResources = Cases[requiredResources, {LinkP[], Buckets, ___}];
				bucketMatch = MatchQ[Length[DeleteDuplicates[bucketResources[[All, 1]][Object]]], 8] && MatchQ[Flatten[
					Download[bucketResources[[All, 1]],
						Models[Object]]], {ObjectP[{Model[Container, CentrifugeBucket, "Microplate Carrier for JS-4.750 Rotor"],
					Model[Container, CentrifugeBucket, "15mL Conical Tube Bucket for JS-4.750 Rotor"]}] ..}];

				(* Expect one balance resource *)
				balanceResource = Cases[requiredResources, {LinkP[], Balance, ___}];
				balanceMatch = MatchQ[balanceResource, {{LinkP[Object[Resource, Instrument]], Balance, Null, Null}}];

				(* Expect 2 rack resources *)
				rackResources = Cases[requiredResources, {LinkP[], TareRacks, ___}];
				rackMatch = MatchQ[rackResources, {{LinkP[Object[Resource, Sample]], TareRacks, 1, Null}}];

				{centrifugeMatch, sampleMatch, bucketMatch, balanceMatch, rackMatch}
			],
			{True, True, True, True, True},
			(* This test is pretty slow locally, but holy hell *)
			TimeConstraint -> 50000
		],
		Test["Resources are made correctly when samples are duplicated:",
			protocol = ExperimentCentrifuge[{
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-2)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID]
			}, {
				Time -> {5, 5, 5, 15, 5, 5, 15, 5, 10, 5} * Minute
			}
			];
			Download[Cases[Download[protocol, RequiredResources], {_, SamplesIn, _, _}][[All, 1]], Sample[Object]],
			{
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-2)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID]],
				ObjectP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID]]
			},
			Variables :> {protocol},
			TimeConstraint -> 3000,
			Messages :> {Warning::ConflictingOptionsWithinContainer}
		],
		Example[{Additional, "If samples in the same container are specified with different number of replicates (as indicated by duplicate inputs), samples are transfered:"},
			Lookup[Download[ExperimentCentrifuge[{
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-2)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID]
			}, {Time -> {5, 5, 5, 15, 5, 5, 15, 5, 10, 5} * Minute}], AliquotSamplePreparation], AliquotContainer],
			{Null, {2, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}, Null, Null, Null, {6, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}, Null, Null, Null, Null},
			Messages :> {Warning::ConflictingOptionsWithinContainer}
		],
		Example[{Options, NumberOfReplicates, "If NumberOfReplicates is specified and duplicate inputs are given, the inputs and their corresponding options are expanded accordingly:"},
			Module[{
				centrifuges,
				forces,
				rotors,
				samplesIn,
				speeds,
				temperatures,
				times
			},
				{
					centrifuges,
					forces,
					rotors,
					samplesIn,
					speeds,
					temperatures,
					times
				} = Download[
					ExperimentCentrifuge[{
						Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID],
						Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
						Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID],
						Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID]
					},
						NumberOfReplicates -> 2,
						ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID],
						Time -> {4 Minute, 10 Minute, 4 Minute, 15Minute}
					],
					{Centrifuges, Forces, Rotors, SamplesIn, Speeds, Temperatures, Times}
				];

				MapThread[
					MatchQ[#1, #2]&,
					{
						{
							centrifuges,
							forces,
							rotors,
							samplesIn,
							speeds,
							temperatures,
							times
						},
						{
							{LinkP[Model[Instrument, Centrifuge, "Avanti J-15R"]]..},
							{
								EqualP[Quantity[852.55, "StandardAccelerationOfGravity"]],
								EqualP[Quantity[852.55, "StandardAccelerationOfGravity"]],
								EqualP[Quantity[967.04, "StandardAccelerationOfGravity"]],
								EqualP[Quantity[967.04, "StandardAccelerationOfGravity"]],
								EqualP[Quantity[852.55, "StandardAccelerationOfGravity"]],
								EqualP[Quantity[852.55, "StandardAccelerationOfGravity"]],
								EqualP[Quantity[967.04, "StandardAccelerationOfGravity"]],
								EqualP[Quantity[967.04, "StandardAccelerationOfGravity"]]
							},
							{
								LinkP[Model[Container, CentrifugeRotor, "JS-4.750"]],
								LinkP[Model[Container, CentrifugeRotor, "JS-4.750"]],
								LinkP[Model[Container, CentrifugeRotor, "JS-4.750"]],
								LinkP[Model[Container, CentrifugeRotor, "JS-4.750"]],
								LinkP[Model[Container, CentrifugeRotor, "JS-4.750"]],
								LinkP[Model[Container, CentrifugeRotor, "JS-4.750"]],
								LinkP[Model[Container, CentrifugeRotor, "JS-4.750"]],
								LinkP[Model[Container, CentrifugeRotor, "JS-4.750"]]
							},
							{
								LinkP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID]],
								LinkP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID]],
								LinkP[Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID]],
								LinkP[Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID]],
								LinkP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID]],
								LinkP[Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID]],
								LinkP[Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID]],
								LinkP[Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID]]
							},
							{
								Quantity[2040., ("Revolutions") / ("Minutes")],
								Quantity[2040., ("Revolutions") / ("Minutes")],
								Quantity[2040., ("Revolutions") / ("Minutes")],
								Quantity[2040., ("Revolutions") / ("Minutes")],
								Quantity[2040., ("Revolutions") / ("Minutes")],
								Quantity[2040., ("Revolutions") / ("Minutes")],
								Quantity[2040., ("Revolutions") / ("Minutes")],
								Quantity[2040., ("Revolutions") / ("Minutes")]
							},
							{
								Quantity[25.`, "DegreesCelsius"],
								Quantity[25.`, "DegreesCelsius"],
								Quantity[25.`, "DegreesCelsius"],
								Quantity[25.`, "DegreesCelsius"],
								Quantity[25.`, "DegreesCelsius"],
								Quantity[25.`, "DegreesCelsius"],
								Quantity[25.`, "DegreesCelsius"],
								Quantity[25.`, "DegreesCelsius"]
							},
							{
								Quantity[4.`, "Minutes"],
								Quantity[4.`, "Minutes"],
								Quantity[10.`, "Minutes"],
								Quantity[10.`, "Minutes"],
								Quantity[4.`, "Minutes"],
								Quantity[4.`, "Minutes"],
								Quantity[15.`, "Minutes"],
								Quantity[15.`, "Minutes"]
							}
						}
					}
				]
			],
			{True..}
		],
		Test["Resources are made correctly when samples are replicated:",
			protocol = ExperimentCentrifuge[{
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID],
				Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
				Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID],
				Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID]
			},
				NumberOfReplicates -> 2,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID],
				Time -> {4 Minute, 10 Minute, 4 Minute, 15Minute}
			];
			Download[Cases[Download[protocol, RequiredResources], {_, SamplesIn, _, _}][[All, 1]], Sample[Object]],
			Download[protocol, SamplesIn[Object]],
			Variables :> {protocol}
		],
		Test["Two duplicated samples takes twice as long to spin as two separate samples that can be centrifuges together:",
			Module[{protocol1, protocol2},
				protocol1 = ExperimentCentrifuge[
					{
						Object[Container, Vessel, "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
						Object[Container, Vessel, "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
						Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (17)" <> $SessionUUID]
					},
					Time -> 10 Minute,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID]
				];

				protocol2 = ExperimentCentrifuge[
					{
						Object[Container, Vessel, "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
						Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (17)" <> $SessionUUID]
					},
					Time -> 10 Minute,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID]
				];
				{
					Download[Cases[Download[protocol1, RequiredResources], {_, Centrifuges, _, _}][[All, 1]], EstimatedTime],
					Download[Cases[Download[protocol2, RequiredResources], {_, Centrifuges, _, _}][[All, 1]], EstimatedTime]
				}
			],
			{
				{Quantity[0.5, "Hours"], Quantity[0.5, "Hours"], Quantity[0.5, "Hours"]},
				{Quantity[0.25, "Hours"], Quantity[0.25, "Hours"]}
			}
		],
		Example[{Options, Confirm, "If Confirm -> True, skip InCart protocol status and go directly to Processing:"},
			Download[
				ExperimentCentrifuge[Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID], Confirm -> True],
				Status],
			Processing | ShippingMaterials | Backlogged
		],
		Example[{Options, CanaryBranch, "Specify the CanaryBranch on which the protocol is run:"},
			Download[
				ExperimentCentrifuge[Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID], CanaryBranch -> "d1cacc5a-948b-4843-aa46-97406bbfc368"],
				CanaryBranch],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Stubs:>{GitBranchExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		Example[{Options, SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			Lookup[
				ExperimentCentrifuge[Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					SamplesInStorageCondition -> Refrigerator, Output -> Options], SamplesInStorageCondition],
			Refrigerator
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentCentrifuge[Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
				AliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				DestinationWell -> "A2",
				Output -> Options
			];
			Lookup[options, DestinationWell],
			{"A2"},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCentrifuge[Object[Sample, "1 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],

		Example[{Options, FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentCentrifuge[Object[Sample, "1 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A1",
			Variables :> {options},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],

		Example[{Additional, "Function runs successfully on an Object[Sample] with no subtype and with the Model link severed:"},
			ExperimentCentrifuge[Object[Sample, "Sample with no subtype and no Model, 2 mL container for ExperimentCentrifuge testing" <> $SessionUUID]],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],

		Test["Does not prepare to weigh samples when given the CounterbalanceWeights option:",
			Download[
				ExperimentCentrifuge[
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					CounterbalanceWeight -> 20 Gram
				],
				CalculatedUnitOperations[CounterbalanceWeights]
			],
			{{}}
		],

		Example[{Messages, "InvalidCounterweights", "Throws a message if no counterweight could be found to balance the container:"},
			ExperimentCentrifuge[Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID], CounterbalanceWeight -> 500 Gram],
			$Failed,
			Messages :> {Error::InvalidCounterweights, Error::InvalidOption}
		],
		Example[{Additional,"Make sure we populate Plier resource for Object[Protocol, Centrifuge] subprotocol when doing ultracentrifuge:"},
			mspProtocol=ExperimentCentrifuge[
				Object[Sample,"8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing"<>$SessionUUID],
				Intensity->50000*RPM
			];
			Download[
				ExperimentCentrifuge[
					mspProtocol[ResolvedUnitOperationInputs][[1]],
					Sequence@@(mspProtocol[ResolvedUnitOperationOptions][[1]]),
					ParentProtocol->mspProtocol
				],
				{Plier,RequiredResources}
			],
			{ObjectP[Model[Item,Plier]],_?((MemberQ[#,{_,Plier,_,_}])&)},
			Variables:>{mspProtocol}
		]
	},
	Parallel -> True,
	SetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects = {};
		ClearDownload[];
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[Flatten[
				{
					Object[Sample, "1 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (1)" <> $SessionUUID],
					Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID],
					Object[Instrument, Centrifuge, "Test object centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID],
					Object[Container, Vessel, "Empty container for ExperimentCentrifuge testing" <> $SessionUUID],
					Model[Sample, "Model sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Discarded sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "1.5 mL container with a discarded sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample without volume for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with sample without volume for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample oligo with volume, 2 mL container for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[30],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[30],
					Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample oligo, 1mL, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with 1 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "10 mL sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "incompatible container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Large volume sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "incompatible container with sample for ExperimentCentrifuge testing (2)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID],
					Object[Container, Plate, "Regular 2mL 96-well plate with 3 1mL samples for ExperimentCentrifuge Unit Testing " <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[9],
					Object[Container, Plate, "96-well plate with 9 1mL samples for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (3)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (4)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (5)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (6-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (6-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (6)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (7-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (7-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (7)" <> $SessionUUID],
					Object[Protocol, DNASynthesis, "Protocol with ImageSample False for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, DNASynthesis, "Protocol with ImageSample True for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, Centrifuge, "Existing centrifuge protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Model[Container, CentrifugeRotor, "Test model centrifuge rotor for ExperimentCentrifuge (JS-4.750)" <> $SessionUUID],
					Object[Container, CentrifugeRotor, "Test centrifuge rotor for ExperimentCentrifuge (JS-4.750)" <> $SessionUUID],
					Model[Container, CentrifugeRotor, "Test model centrifuge rotor for microcentrifuge for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID],
					Object[Container, CentrifugeRotor, "Test centrifuge rotor for microcentrifuge for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID],
					Model[Container, CentrifugeRotor, "Test model centrifuge rotor for microcentrifuge for ExperimentCentrifuge (15mL Tube)" <> $SessionUUID],
					Object[Container, CentrifugeRotor, "Test centrifuge rotor for microcentrifuge for ExperimentCentrifuge (15mL Tube)" <> $SessionUUID],
					Model[Container, CentrifugeBucket, "Test model centrifuge bucket for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID],
					Model[Container, CentrifugeBucket, "Test model centrifuge bucket for ExperimentCentrifuge (50mL Conical)" <> $SessionUUID],
					Model[Container, CentrifugeBucket, "Test model centrifuge bucket for ExperimentCentrifuge (Plate)" <> $SessionUUID],
					Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (1, sterile)" <> $SessionUUID],
					Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (2, sterile)" <> $SessionUUID],
					Object[Instrument, Centrifuge, "Test object centrifuge for ExperimentCentrifuge (2, sterile)" <> $SessionUUID],
					Object[Sample, "Sample oligo with volume, sterile, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with sterile sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[10],
					Object[Container, Vessel, "50 mL tube with 10 mL sample for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[10],
					Object[Protocol, ManualSamplePreparation, "Test template protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample with no subtype and no Model, 2 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with subtype-less, model-less for ExperimentCentrifuge testing" <> $SessionUUID],
					Model[Container, Rack, "15mL Tube Stand for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "50 mL tube with 1 mL sample for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Sample, "50 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Container, Vessel, "50 mL tube with 50 mL sample for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing with insufficient sample" <> $SessionUUID],
					Object[Sample, "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "20 mL sample in 50 mL filter tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, Filter, "50 mL filter tube with 20 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "0.2 mL sample in 96 well filter plate for ExperimentCentrifuge testing 1" <> $SessionUUID],
					Object[Sample, "0.2 mL sample in 96 well filter plate for ExperimentCentrifuge testing 2" <> $SessionUUID],
					Object[Container, Plate, Filter, "0.3 mL PES filter plate with 2 0.2 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96 well deep well plate for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Plate, "96 deep well plate with 1 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Model[Container, Plate, "Centrifuge Test plate model without counterweights" <> $SessionUUID],
					Object[Container, Plate, "Centrifuge Test plate without counterweights" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample1 in counterweightless plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample2 in counterweightless plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample3 in counterweightless plate" <> $SessionUUID],
					Model[Container, Plate, "Centrifuge Test tall plate model" <> $SessionUUID],
					Model[Container, Plate, "Centrifuge Test heavy plate model" <> $SessionUUID],
					Object[Container, Plate, "Centrifuge Test tall plate" <> $SessionUUID],
					Object[Container, Plate, "Centrifuge Test heavy plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample in tall plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample in heavy plate" <> $SessionUUID],
					Object[Container, Plate, "Centrifuge Test normal plate with one heavy sample" <> $SessionUUID],
					Object[Sample, "Centrifuge Test heavy sample in normal plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test normal sample next to heavy sample in normal plate" <> $SessionUUID],
					Object[Container, Plate, "96-well PCR plate with 1 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well PCR plate for ExperimentCentrifuge testing (plate 7, sample 1)" <> $SessionUUID],
					Model[Item, Counterweight, "Test Model Counterweight for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, DNASynthesis, "Protocol with ImageSample False for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, DNASynthesis, "Protocol with ImageSample True for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, Centrifuge, "Existing centrifuge protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Download[
						{
							Object[Protocol, Centrifuge, "Test template protocol for ExperimentCentrifuge testing" <> $SessionUUID],
							Object[Protocol, ManualSamplePreparation, "Test template protocol for ExperimentCentrifuge testing" <> $SessionUUID]
						},
						{
							Object,
							Subprotocols[Object],
							RequiredResources[[All, 1]][Object],
							BatchedUnitOperations[Object],
							ProcedureLog[Object]
						}
					]
				}], ObjectP[]]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True]
		];
		Module[
			{
				modelCentrifuge1, modelCentrifuge2, modelCentrifuge3, modelCentrifuge4, modelRotor1, rotor1, modelRotor2, rotor2,
				modelRotor3, rotor3, modelBucket1, modelBucket2, modelBucket3, centrifuge1, centrifuge2, tube1, modelSample1,
				modelPlate1, modelPlate2, modelPlate3,
				sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,
				sample11, sample12, sample13, sample14, sample15, sample16, sample17, sample18, sample19, sample20,
				sample21, sample22, sample23, sample24, sample25, sample26, sample27, sample28, sample29, sample30,
				sample31, sample32, sample33, sample34, sample35, sample36, sample37, sample38, sample39, sample40,
				sample41, sample42, sample43, sample44, sample45, sample46, sample47, sample48, sample49, sample50,
				sample51, sample52, sample53, sample54, sample55, sample56, sample57, sample58, sample59, sample60,
				sample61, sample62, sample63, sample64, sample65, sample66, sample67, sample68, sample69, sample70,
				sample71, sample72, sample73, sample74, sample75, sample76, sample77, sample78, sample79, sample80,
				sample81, sample82, sample83, sample84, sample85, sample86, sample87, sample88, sample89, sample90,
				sample91, sample92, sample93, sample94, sample95, sample96, sample97, sample98, sample99, sample100,
				container1, container2, container3, container4, container5, container6, container7, container8, container9, container10,
				container11, container12, container13, container14, container15, container16, container17, container18, container19, container20,
				container21, container22, container23, container24, container25, container26, container27, container28, container29, container30,
				container31, container32, container33, container34, container35, container36, container37, container38, container39, container40,
				container41, container42, container43, plate44, plate45, plate46, plate47, plate48, plate49, plate50,
				plate51, plate52, plate53, plate54, plate55, plate56, container57, container58, container59, container60,
				container61, container62, container63, container64, container65, container66, container67, container68, container69, plateFilter70,
				plate71, container72, container73, container74, container75, container76, container77, container78, container79, container80,
				dnaSynthProt1, dnaSynthProt2, centrifugeProt1, mspProt1, modelRack1, modelCounterweight1, protocol
			},
			{
				(*1*)modelCentrifuge1,
				(*2*)modelCentrifuge2,
				(*3*)modelCentrifuge3,
				(*4*)modelCentrifuge4,
				(*5*)modelRotor1,
				(*6*)rotor1,
				(*7*)modelRotor2,
				(*8*)rotor2,
				(*9*)modelRotor3,
				(*10*)rotor3,
				(*11*)modelBucket1,
				(*12*)modelBucket2,
				(*13*)modelBucket3,
				(*14*)centrifuge1,
				(*15*)centrifuge2,
				(*16*)tube1,
				(*17*)modelSample1,
				(*18*)modelPlate1,
				(*19*)modelPlate2,
				(*20*)modelPlate3,
				(*21*)sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10,
				(*22*)sample11, sample12, sample13, sample14, sample15, sample16, sample17, sample18, sample19, sample20,
				(*23*)sample21, sample22, sample23, sample24, sample25, sample26, sample27, sample28, sample29, sample30,
				(*24*)sample31, sample32, sample33, sample34, sample35, sample36, sample37, sample38, sample39, sample40,
				(*25*)sample41, sample42, sample43, sample44, sample45, sample46, sample47, sample48, sample49, sample50,
				(*26*)sample51, sample52, sample53, sample54, sample55, sample56, sample57, sample58, sample59, sample60,
				(*27*)sample61, sample62, sample63, sample64, sample65, sample66, sample67, sample68, sample69, sample70,
				(*28*)sample71, sample72, sample73, sample74, sample75, sample76, sample77, sample78, sample79, sample80,
				(*29*)sample81, sample82, sample83, sample84, sample85, sample86, sample87, sample88, sample89, sample90,
				(*30*)sample91, sample92, sample93, sample94, sample95, sample96, sample97, sample98, sample99, sample100,
				(*31*)container1, container2, container3, container4, container5, container6, container7, container8, container9, container10,
				(*32*)container11, container12, container13, container14, container15, container16, container17, container18, container19, container20,
				(*33*)container21, container22, container23, container24, container25, container26, container27, container28, container29, container30,
				(*34*)container31, container32, container33, container34, container35, container36, container37, container38, container39, container40,
				(*35*)container41, container42, container43, plate44, plate45, plate46, plate47, plate48, plate49, plate50,
				(*36*)plate51, plate52, plate53, plate54, plate55, plate56, container57, container58, container59, container60,
				(*37*)container61, container62, container63, container64, container65, container66, container67, container68, container69, plateFilter70,
				(*38*)plate71, container72, container73, container74, container75, container76, container77, container78, container79, container80,
				(*39*)dnaSynthProt1,
				(*40*)dnaSynthProt2,
				(*41*)centrifugeProt1,
				(*42*)mspProt1,
				(*43*)modelRack1,
				(*44*)modelCounterweight1
			} = CreateID[{
				(*1*)Model[Instrument, Centrifuge],
				(*2*)Model[Instrument, Centrifuge],
				(*3*)Model[Instrument, Centrifuge],
				(*4*)Model[Instrument, Centrifuge],
				(*5*)Model[Container, CentrifugeRotor],
				(*6*)Object[Container, CentrifugeRotor],
				(*7*)Model[Container, CentrifugeRotor],
				(*8*)Object[Container, CentrifugeRotor],
				(*9*)Model[Container, CentrifugeRotor],
				(*10*)Object[Container, CentrifugeRotor],
				(*11*)Model[Container, CentrifugeBucket],
				(*12*)Model[Container, CentrifugeBucket],
				(*13*)Model[Container, CentrifugeBucket],
				(*14*)Object[Instrument, Centrifuge],
				(*15*)Object[Instrument, Centrifuge],
				(*16*)Object[Container, Vessel],
				(*17*)Model[Sample],
				(*18*)Model[Container, Plate],
				(*19*)Model[Container, Plate],
				(*20*)Model[Container, Plate],
				(*21*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*22*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*23*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*24*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*25*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*26*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*27*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*28*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*29*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*30*)Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample], Object[Sample],
				(*31*)Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel],
				(*32*)Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel],
				(*33*)Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel],
				(*34*)Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel],
				(*35*)Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Plate], Object[Container, Plate], Object[Container, Plate], Object[Container, Plate], Object[Container, Plate], Object[Container, Plate], Object[Container, Plate],
				(*36*)Object[Container, Plate], Object[Container, Plate], Object[Container, Plate], Object[Container, Plate], Object[Container, Plate], Object[Container, Plate], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel],
				(*37*)Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel, Filter], Object[Container, Plate, Filter],
				(*38*)Object[Container, Plate], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel], Object[Container, Vessel],
				(*39*)Object[Protocol, DNASynthesis],
				(*40*)Object[Protocol, DNASynthesis],
				(*41*)Object[Protocol, Centrifuge],
				(*42*)Object[Protocol, ManualSamplePreparation],
				(*43*)Model[Container, Rack],
				(*44*)Model[Item, Counterweight]
			}];

			(* Model centrifuges *)
			Upload[Flatten[{
				<|
					Object -> modelCentrifuge1,
					DeveloperObject -> True,
					CentrifugeType -> Tabletop,
					MaxRotationRate -> Quantity[5000.`, ("Revolutions") / ("Minutes")],
					MaxTemperature -> Quantity[40.`, "DegreesCelsius"],
					MaxTime -> Quantity[30.`, "Minutes"],
					MinRotationRate -> Quantity[0.`, ("Revolutions") / ("Minutes")],
					MinTemperature -> Quantity[4.`, "DegreesCelsius"],
					Name -> "Test model centrifuge for ExperimentCentrifuge (1)" <> $SessionUUID,
					AsepticHandling -> False,
					SpeedResolution -> Quantity[10, ("Revolutions") / ("Minutes")],
					Type -> Model[Instrument, Centrifuge],
					Replace[Positions] -> {
						<|Name -> "Rotor Slot", Footprint -> AvantiJ15Rotor, MaxWidth -> 45 Centimeter, MaxDepth -> 45 Centimeter, MaxHeight -> Null|>
					}
				|>,
				<|
					Object -> modelCentrifuge2,
					DeveloperObject -> True,
					CentrifugeType -> Micro,
					MaxRotationRate -> Quantity[15000.`, ("Revolutions") / ("Minutes")],
					MaxTemperature -> Quantity[25.`, "DegreesCelsius"],
					MaxTime -> Quantity[99.9833`, "Minutes"],
					MinRotationRate -> Quantity[0.`, ("Revolutions") / ("Minutes")],
					MinTemperature -> Quantity[25.`, "DegreesCelsius"],
					Name -> "Test model centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID,
					AsepticHandling -> False,
					SpeedResolution -> Quantity[100, ("Revolutions") / ("Minutes")],
					Type -> Model[Instrument, Centrifuge],
					Replace[Positions] -> {<|Name -> "Rotor Slot", Footprint -> Microfuge16Rotor, MaxWidth -> Quantity[0.14`, "Meters"], MaxDepth -> Quantity[0.14`, "Meters"], MaxHeight -> Null|>}
				|>,
				<|
					Object -> modelCentrifuge3,
					DeveloperObject -> True,
					CentrifugeType -> Tabletop,
					MaxRotationRate -> Quantity[5000.`, ("Revolutions") / ("Minutes")],
					MaxTemperature -> Quantity[40.`, "DegreesCelsius"],
					MaxTime -> Quantity[30.`, "Minutes"],
					MinRotationRate -> Quantity[0.`, ("Revolutions") / ("Minutes")],
					MinTemperature -> Quantity[4.`, "DegreesCelsius"],
					Name -> "Test model centrifuge for ExperimentCentrifuge (1, sterile)" <> $SessionUUID,
					AsepticHandling -> True,
					SpeedResolution -> Quantity[10, ("Revolutions") / ("Minutes")],
					Type -> Model[Instrument, Centrifuge],
					Replace[Positions] -> {
						<|Name -> "Rotor Slot", Footprint -> AvantiJ15Rotor, MaxWidth -> 45 Centimeter, MaxDepth -> 45 Centimeter, MaxHeight -> Null|>
					}
				|>,
				<|
					Object -> modelCentrifuge4,
					DeveloperObject -> True,
					CentrifugeType -> Micro,
					MaxRotationRate -> Quantity[15000.`, ("Revolutions") / ("Minutes")],
					MaxTemperature -> Quantity[25.`, "DegreesCelsius"],
					MaxTime -> Quantity[99.9833`, "Minutes"],
					MinRotationRate -> Quantity[0.`, ("Revolutions") / ("Minutes")],
					MinTemperature -> Quantity[25.`, "DegreesCelsius"],
					Name -> "Test model centrifuge for ExperimentCentrifuge (2, sterile)" <> $SessionUUID,
					AsepticHandling -> True,
					SpeedResolution -> Quantity[100, ("Revolutions") / ("Minutes")],
					Type -> Model[Instrument, Centrifuge],
					Replace[Positions] -> {<|Name -> "Rotor Slot", Footprint -> Microfuge16Rotor, MaxWidth -> Quantity[0.14`, "Meters"], MaxDepth -> Quantity[0.14`, "Meters"], MaxHeight -> Null|>}
				|>,
				(* Model centrifuge rotors *)
				<|
					Object -> modelRotor1,
					DeveloperObject -> True,
					Type -> Model[Container, CentrifugeRotor],
					Name -> "Test model centrifuge rotor for ExperimentCentrifuge (JS-4.750)" <> $SessionUUID,
					RotorType -> SwingingBucket,
					NumberOfBuckets -> 4,
					Replace@BalancePositions -> {{"Bucket Slot 1", "Bucket Slot 3"}, {"Bucket Slot 2", "Bucket Slot 4"}},
					MaxRadius -> 207.8 Millimeter,
					MaxForce -> 4820 GravitationalAcceleration,
					MaxImbalance -> 50 Gram,
					Replace@Positions -> {<|Name -> "Bucket Slot 1",
						Footprint -> JS4750Bucket, MaxWidth -> Quantity[0.13`, "Meters"],
						MaxDepth -> Quantity[0.088`, "Meters"],
						MaxHeight -> Null|>, <|Name -> "Bucket Slot 2",
						Footprint -> JS4750Bucket, MaxWidth -> Quantity[0.13`, "Meters"],
						MaxDepth -> Quantity[0.088`, "Meters"],
						MaxHeight -> Null|>, <|Name -> "Bucket Slot 3",
						Footprint -> JS4750Bucket, MaxWidth -> Quantity[0.13`, "Meters"],
						MaxDepth -> Quantity[0.088`, "Meters"],
						MaxHeight -> Null|>, <|Name -> "Bucket Slot 4",
						Footprint -> JS4750Bucket, MaxWidth -> Quantity[0.13`, "Meters"],
						MaxDepth -> Quantity[0.088`, "Meters"], MaxHeight -> Null|>},
					Footprint -> AvantiJ15Rotor
				|>,
				<|
					Object -> rotor1,
					DeveloperObject -> True,
					Type -> Object[Container, CentrifugeRotor],
					Name -> "Test centrifuge rotor for ExperimentCentrifuge (JS-4.750)" <> $SessionUUID,
					Model -> Link[modelRotor1, Objects],
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				<|
					Object -> modelRotor2,
					DeveloperObject -> True,
					Type -> Model[Container, CentrifugeRotor],
					Name -> "Test model centrifuge rotor for microcentrifuge for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID,
					RotorType -> FixedAngle,
					NumberOfBuckets -> 24,
					Replace@BalancePositions -> {{"1", "13"}, {"3", "15"}, {"5", "17"}, {"7", "19"}, {"9", "21"}, {"11", "23"}, {"2", "14"}, {"4", "16"}, {"6", "18"}, {"8", "20"}, {"10", "22"}, {"12", "24"}} ,
					MaxRadius -> 66. Millimeter,
					MaxForce -> 16162.5 GravitationalAcceleration,
					MaxImbalance -> 24. Gram,
					Replace@Positions -> {
						<|Name -> "1", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "2", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "3", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "4", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "5", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "6", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "7", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "8", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "9", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "10", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "11", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "12", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "13", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "14", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "15", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "16", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "17", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "18", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "19", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "20", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "21", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "22", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "23", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "24", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>
					},
					Footprint -> Microfuge16Rotor
				|>,
				<|
					Object -> rotor2,
					DeveloperObject -> True,
					Type -> Object[Container, CentrifugeRotor],
					Name -> "Test centrifuge rotor for microcentrifuge for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID,
					Model -> Link[modelRotor2, Objects],
					Site -> Link[$Site],
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				(* This rotor bears no relation to anything in real life, but the ExperimentCentrifuge tests are set up to expect that 15mL tubes can be
				spun only in microcentrifuges so here we are *)
				<|
					Object -> modelRotor3,
					DeveloperObject -> True,
					Type -> Model[Container, CentrifugeRotor],
					Name -> "Test model centrifuge rotor for microcentrifuge for ExperimentCentrifuge (15mL Tube)" <> $SessionUUID,
					RotorType -> FixedAngle,
					NumberOfBuckets -> 24,
					Replace@BalancePositions -> {{"1", "13"}, {"3", "15"}, {"5", "17"}, {"7", "19"}, {"9", "21"}, {"11", "23"}, {"2", "14"}, {"4", "16"}, {"6", "18"}, {"8", "20"}, {"10", "22"}, {"12", "24"}} ,
					MaxRadius -> 66. Millimeter,
					MaxForce -> 16162.5 GravitationalAcceleration,
					MaxImbalance -> 24. Gram,
					Replace@Positions -> {
						<|Name -> "1", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "2", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "3", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "4", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "5", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "6", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "7", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "8", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "9", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "10", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "11", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "12", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "13", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "14", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "15", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "16", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "17", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "18", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "19", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "20", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "21", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "22", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "23", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>,
						<|Name -> "24", Footprint -> Conical15mLTube, MaxWidth -> 0.012 Meter, MaxDepth -> 0.012 Meter, MaxHeight -> 0.0405 Meter|>
					},
					Footprint -> Microfuge16Rotor
				|>,
				<|
					Object -> rotor3,
					DeveloperObject -> True,
					Type -> Object[Container, CentrifugeRotor],
					Name -> "Test centrifuge rotor for microcentrifuge for ExperimentCentrifuge (15mL Tube)" <> $SessionUUID,
					Model -> Link[modelRotor3, Objects],
					Site -> Link[$Site],
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>,
				(* Model centrifuge buckets *)
				(* Position definitions have correct footprints, but other dimensions are not correct (nor do they need to be) *)
				(* NOTE: There is a 2mL tube bucket but no 15mL Tube bucket because centrifuge tests were set up for 2mL tubes to be compatible with
						both types of test centrifuges, and for 15mL tubes to be compatible only with the microcentrifuge. Even though this is super
						not how the real world works, it's fine for the test environment to look like this. *)
				<|
					Object -> modelBucket1,
					DeveloperObject -> True,
					Type -> Model[Container, CentrifugeBucket],
					Name -> "Test model centrifuge bucket for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID, (* Not representative of physical reality *)
					MaxRadius -> 207.8 Millimeter,
					MaxForce -> 4820 GravitationalAcceleration,
					Footprint -> JS4750Bucket,
					Replace@Positions -> {
						<|Name -> "1", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "2", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "3", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "4", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "5", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "6", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "7", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "8", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "9", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "10", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "11", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "12", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "13", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "14", Footprint -> MicrocentrifugeTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>
					}
				|>,
				<|
					Object -> modelBucket2,
					DeveloperObject -> True,
					Type -> Model[Container, CentrifugeBucket],
					Name -> "Test model centrifuge bucket for ExperimentCentrifuge (50mL Conical)" <> $SessionUUID,
					MaxRadius -> 207.8 Millimeter,
					MaxForce -> 4820 GravitationalAcceleration,
					Footprint -> JS4750Bucket,
					Replace@Positions -> {
						<|Name -> "1", Footprint -> Conical50mLTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "2", Footprint -> Conical50mLTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "3", Footprint -> Conical50mLTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "4", Footprint -> Conical50mLTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "5", Footprint -> Conical50mLTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "6", Footprint -> Conical50mLTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>,
						<|Name -> "7", Footprint -> Conical50mLTube, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>
					}
				|>,
				<|
					Object -> modelBucket3,
					DeveloperObject -> True,
					Type -> Model[Container, CentrifugeBucket],
					Name -> "Test model centrifuge bucket for ExperimentCentrifuge (Plate)" <> $SessionUUID,
					MaxRadius -> 207.8 Millimeter,
					MaxForce -> 4820 GravitationalAcceleration,
					Footprint -> JS4750Bucket,
					Replace@Positions -> {
						<|Name -> "1", Footprint -> Plate, MaxWidth -> 0.02 Meter, MaxDepth -> 0.02 Meter, MaxHeight -> 0.1 Meter|>
					}
				|>,
				(* Object Centrifuges *)
				<|
					Object -> centrifuge1,
					Type -> Object[Instrument, Centrifuge],
					Model -> Link[Model[Instrument, Centrifuge, "Avanti J-15R"], Objects],
					DeveloperObject -> True,
					Name -> "Test object centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID,
					Site -> Link[$Site]
				|>,
				<|
					Object -> centrifuge2,
					Type -> Object[Instrument, Centrifuge],
					Model -> Link[modelCentrifuge4, Objects],
					DeveloperObject -> True,
					Name -> "Test object centrifuge for ExperimentCentrifuge (2, sterile)" <> $SessionUUID,
					Site -> Link[$Site]
				|>,
				(*Empty Container *)
				<|
					Object -> tube1,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL brown tube"], Objects],
					Site -> Link[$Site],
					Name -> "Empty container for ExperimentCentrifuge testing" <> $SessionUUID
				|>,
				(* Model to use for samples *)
				<|
					Object -> modelSample1,
					DeveloperObject -> True,
					Type -> Model[Sample],
					Name -> "Model sample for ExperimentCentrifuge testing" <> $SessionUUID
				|>,
				(* plate model without counterweights *)
				<|
					Object -> modelPlate1,
					DeveloperObject -> True,
					Type -> Model[Container, Plate],
					Name -> "Centrifuge Test plate model without counterweights" <> $SessionUUID,
					NumberOfWells -> 6,
					AspectRatio -> 3 / 2,
					Footprint -> Plate,
					LiquidHandlerPrefix -> "testPrefix",
					Dimensions -> {Quantity[0.12776`, "Meters"], Quantity[0.08548`, "Meters"], Quantity[0.016059999999999998`, "Meters"]},
					Replace[Positions] -> {
						<|Name -> "A1", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "A2", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "A3", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B1", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B2", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B3", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>
					},
					Replace[PositionPlotting] -> {
						<|Name -> "A1", XOffset -> 0.024765 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "A2", XOffset -> 0.063885 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "A3", XOffset -> 0.103005 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B1", XOffset -> 0.024765 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B2", XOffset -> 0.063885 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B3", XOffset -> 0.103005 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>
					},
					WellDiameter -> 35.1 Millimeter,
					WellDepth -> 13 Millimeter,
					Columns -> 3,
					HorizontalMargin -> 7.045 Millimeter,
					HorizontalPitch -> 39.12 Millimeter,
					MaxCentrifugationForce -> 10000 GravitationalAcceleration,
					TareWeight -> 33.19 Gram,
					Rows -> 2,
					VerticalMargin -> 5.445 Millimeter,
					VerticalPitch -> 39.12 Millimeter,
					DepthMargin -> 1.27 Millimeter
				|>,
				(* tall plate model*)
				<|
					Object -> modelPlate2,
					DeveloperObject -> True,
					Type -> Model[Container, Plate],
					Name -> "Centrifuge Test tall plate model" <> $SessionUUID,
					NumberOfWells -> 6,
					AspectRatio -> 3 / 2,
					Footprint -> Plate,
					LiquidHandlerPrefix -> "testPrefix",
					Dimensions -> {Quantity[0.12776`, "Meters"], Quantity[0.08548`, "Meters"], Quantity[50`, "Millimeters"]},
					Replace[Positions] -> {
						<|Name -> "A1", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "A2", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "A3", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B1", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B2", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B3", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>
					},
					Replace[PositionPlotting] -> {
						<|Name -> "A1", XOffset -> 0.024765 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "A2", XOffset -> 0.063885 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "A3", XOffset -> 0.103005 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B1", XOffset -> 0.024765 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B2", XOffset -> 0.063885 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B3", XOffset -> 0.103005 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>
					},
					WellDiameter -> 35.1 Millimeter,
					WellDepth -> 13 Millimeter,
					Columns -> 3,
					HorizontalMargin -> 7.045 Millimeter,
					HorizontalPitch -> 39.12 Millimeter,
					MaxCentrifugationForce -> 10000 GravitationalAcceleration,
					TareWeight -> 33.19 Gram,
					Rows -> 2,
					VerticalMargin -> 5.445 Millimeter,
					VerticalPitch -> 39.12 Millimeter,
					DepthMargin -> 1.27 Millimeter
				|>,
				(* heavy plate model*)
				<|
					Object -> modelPlate3,
					DeveloperObject -> True,
					Type -> Model[Container, Plate],
					Name -> "Centrifuge Test heavy plate model" <> $SessionUUID,
					NumberOfWells -> 6,
					AspectRatio -> 3 / 2,
					Footprint -> Plate,
					LiquidHandlerPrefix -> "testPrefix",
					Dimensions -> {Quantity[0.12776`, "Meters"], Quantity[0.08548`, "Meters"], Quantity[0.016059999999999998`, "Meters"]},
					Replace[Positions] -> {
						<|Name -> "A1", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "A2", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "A3", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B1", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B2", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>,
						<|Name -> "B3", Footprint -> Null, MaxWidth -> 0.03543 Meter, MaxDepth -> 0.03543 Meter, MaxHeight -> 0.0174 Meter|>
					},
					Replace[PositionPlotting] -> {
						<|Name -> "A1", XOffset -> 0.024765 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "A2", XOffset -> 0.063885 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "A3", XOffset -> 0.103005 Meter, YOffset -> 0.062295 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B1", XOffset -> 0.024765 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B2", XOffset -> 0.063885 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>,
						<|Name -> "B3", XOffset -> 0.103005 Meter, YOffset -> 0.023175 Meter, ZOffset -> 0.00254 Meter, CrossSectionalShape -> Circle, Rotation -> 0.|>
					},
					WellDiameter -> 35.1 Millimeter,
					WellDepth -> 13 Millimeter,
					Columns -> 3,
					HorizontalMargin -> 7.045 Millimeter,
					HorizontalPitch -> 39.12 Millimeter,
					MaxCentrifugationForce -> 10000 GravitationalAcceleration,
					TareWeight -> 320 Gram,
					Rows -> 2,
					VerticalMargin -> 5.445 Millimeter,
					VerticalPitch -> 39.12 Millimeter,
					DepthMargin -> 1.27 Millimeter
				|>,
				(* Sample without volume *)
				<|
					Object -> sample1,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Name -> "Discarded sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 10Milliliter,
					Status -> Discarded,
					Site -> Link[$Site],
					Model -> Link[modelSample1, Objects]
				|>,
				<|
					Object -> container1,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"], Objects],
					Name -> "1.5 mL container with a discarded sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Site -> Link[$Site],
					Replace[Contents] -> {{"A1", Link[sample1, Container]}}
				|>,
				(* Sample without volume *)
				<|
					Object -> sample2,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Site -> Link[$Site],
					Name -> "Sample without volume for ExperimentCentrifuge testing" <> $SessionUUID,
					Model -> Link[modelSample1, Objects]
				|>,
				<|
					Object -> container2,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "15mL Tube"], Objects],
					Site -> Link[$Site],
					Name -> "15 mL container with sample without volume for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample2, Container]}}
				|>,
				(* 1.5 mL container *)
				<|
					Object -> sample3,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 1.5Milliliter
				|>,
				<|
					Object -> container3,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"], Objects],
					Name -> "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample3, Container]}}
				|>,
				(* Sample with no subtype and no model *)
				<|
					Object -> sample4,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Site -> Link[$Site],
					Name -> "Sample with no subtype and no Model, 2 mL container for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 1.5Milliliter
				|>,
				<|
					Object -> container4,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Vessel, "2mL brown tube"], Objects],
					Name -> "2 mL container with subtype-less, model-less for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample4, Container]}}
				|>,
				(* set of 30 samples and containers *)
				MapThread[
					<|
						Object -> #1,
						DeveloperObject -> True,
						Type -> Object[Sample],
						Site -> Link[$Site],
						Model -> Link[modelSample1, Objects],
						Name -> "Sample oligo with volume, 2 mL container for ExperimentCentrifuge testing (" <> ToString[#2] <> ")" <> $SessionUUID,
						Volume -> 1Milliliter
					|>&,
					{
						{sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16, sample17, sample18, sample19, sample20, sample21, sample22, sample23, sample24, sample25, sample26, sample27, sample28, sample29, sample30, sample31, sample32, sample33, sample34},
						Range[30]
					}
				],
				MapThread[
					<|
						Object -> #1,
						DeveloperObject -> True,
						Type -> Object[Container, Vessel],
						Site -> Link[$Site],
						Model -> Link[Model[Container, Vessel, "2mL brown tube"], Objects],
						Name -> "2 mL container with sample for ExperimentCentrifuge testing (" <> ToString[#2] <> ")" <> $SessionUUID,
						Replace[Contents] -> {
							{"A1", Link[#3, Container]}
						}
					|>&,
					{
						{container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, container15, container16, container17, container18, container19, container20, container21, container22, container23, container24, container25, container26, container27, container28, container29, container30, container31, container32, container33, container34},
						Range[30],
						{sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16, sample17, sample18, sample19, sample20, sample21, sample22, sample23, sample24, sample25, sample26, sample27, sample28, sample29, sample30, sample31, sample32, sample33, sample34}
					}
				],
				(* 15 mL container *)
				<|
					Object -> sample36,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Site -> Link[$Site],
					Model -> Link[modelSample1, Objects],
					Name -> "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 10Milliliter
				|>,
				<|
					Object -> container36,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Vessel, "15mL Tube"], Objects],
					Name -> "15 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample36, Container]}}
				|>,
				(* 15 mL container with sterile sample*)
				<|
					Object -> sample37,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "Sample oligo with volume, sterile, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID,
					Sterile -> True,
					Volume -> 10Milliliter
				|>,
				<|
					Object -> container37,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "15mL Tube"], Objects],
					Site -> Link[$Site],
					Name -> "15 mL container with sterile sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample37, Container]}}
				|>,
				(* 15 mL container *)
				<|
					Object -> sample38,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "Sample oligo, 1mL, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> container38,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "15mL Tube"], Objects],
					Site -> Link[$Site],
					Name -> "15 mL container with 1 mL sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample38, Container]}}
				|>,
				(* 8.9 mL OptiSeal centrifuge tube *)
				<|
					Object -> sample39,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 8.5Milliliter
				|>,
				<|
					Object -> container39,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "8.9mL OptiSeal Centrifuge Tube"], Objects],
					Site -> Link[$Site],
					Name -> "8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample39, Container]}}
				|>,
				(* 8.9 mL OptiSeal centrifuge tube with insufficient sample *)
				<|
					Object -> sample40,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 5Milliliter
				|>,
				<|
					Object -> container40,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "8.9mL OptiSeal Centrifuge Tube"], Objects],
					Site -> Link[$Site],
					Name -> "8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing with insufficient sample" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample40, Container]}}
				|>,
				(* 32.4 mL OptiSeal centrifuge tube *)
				<|
					Object -> sample41,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 32Milliliter
				|>,
				<|
					Object -> container41,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "32.4mL OptiSeal Centrifuge Tube"], Objects],
					Site -> Link[$Site],
					Name -> "32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample41, Container]}}
				|>,
				(*Sample in incompatible container *)
				<|
					Object -> sample42,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "10 mL sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 10Milliliter
				|>,
				<|
					Object -> container42,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "1000mL Erlenmeyer Flask"], Objects],
					Site -> Link[$Site],
					Name -> "incompatible container with sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample42, Container]}}
				|>,
				(* Excessive volume sample in incompatible container *)
				<|
					Object -> sample43,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "Large volume sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 100Milliliter
				|>,
				<|
					Object -> container43,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "1000mL Erlenmeyer Flask"], Objects],
					Site -> Link[$Site],
					Name -> "incompatible container with sample for ExperimentCentrifuge testing (2)" <> $SessionUUID,
					Replace[Contents] -> {{"A1", Link[sample43, Container]}}
				|>,
				(* 3 samples in plate *)
				<|
					Object -> sample44,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample45,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample46,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> plate44,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample44, Container]},
						{"A2", Link[sample45, Container]},
						{"A3", Link[sample46, Container]}}
				|>,
				(* 3 samples in plate *)
				<|
					Object -> sample47,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample48,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample49,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> plate45,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "Regular 2mL 96-well plate with 3 1mL samples for ExperimentCentrifuge Unit Testing " <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample47, Container]},
						{"A2", Link[sample48, Container]},
						{"A3", Link[sample49, Container]}}
				|>,
				(* 3 samples in plate with no counterweights *)
				<|
					Object -> sample50,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test sample1 in counterweightless plate" <> $SessionUUID,
					Volume -> 200 Microliter
				|>,
				<|
					Object -> sample51,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test sample2 in counterweightless plate" <> $SessionUUID,
					Volume -> 200 Microliter
				|>,
				<|
					Object -> sample52,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test sample3 in counterweightless plate" <> $SessionUUID,
					Volume -> 200 Microliter
				|>,
				<|
					Object -> plate46,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[modelPlate1, Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test plate without counterweights" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample50, Container]},
						{"A3", Link[sample51, Container]},
						{"B2", Link[sample52, Container]}}
				|>,
				(* sample in a tall plate *)
				<|
					Object -> sample53,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test sample in tall plate" <> $SessionUUID,
					Volume -> 200 Microliter
				|>,
				<|
					Object -> plate47,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[modelPlate2, Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test tall plate" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample53, Container]}
					}
				|>,
				(* sample in a heavy plate *)
				<|
					Object -> sample54,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test sample in heavy plate" <> $SessionUUID,
					Volume -> 200 Microliter
				|>,
				<|
					Object -> plate48,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[modelPlate3, Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test heavy plate" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample54, Container]}
					}
				|>,
				(* heavy sample and normal sample in a normal plate *)
				<|
					Object -> sample55,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test heavy sample in normal plate" <> $SessionUUID,
					Volume -> 240 Milliliter
				|>,
				<|
					Object -> sample56,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test normal sample next to heavy sample in normal plate" <> $SessionUUID,
					Volume -> 200 Microliter
				|>,
				<|
					Object -> plate49,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[modelPlate1, Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge Test normal plate with one heavy sample" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample55, Container]},
						{"A3", Link[sample56, Container]}}
				|>,
				(*1 sample in a pcr plate *)
				<|
					Object -> sample57,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 96-well PCR plate for ExperimentCentrifuge testing (plate 7, sample 1)" <> $SessionUUID,
					Volume -> 200 Microliter
				|>,
				<|
					Object -> plate50,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well PCR Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96-well PCR plate with 1 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample57, Container]}}
				|>,
				(*9 samples in 1 plate *)
				MapThread[
					<|
						Object -> #1,
						DeveloperObject -> True,
						Type -> Object[Sample],
						Model -> Link[modelSample1, Objects],
						Site -> Link[$Site],
						Name -> "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (" <> ToString[#2] <> ")" <> $SessionUUID,
						Volume -> 1Milliliter
					|>&,
					{
						{sample58, sample59, sample60, sample61, sample62, sample63, sample64, sample65, sample66},
						Range[9]
					}
				],
				<|
					Object -> plate51,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96-well plate with 9 1mL samples for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample58, Container]},
						{"A2", Link[sample59, Container]},
						{"A3", Link[sample60, Container]},
						{"A4", Link[sample61, Container]},
						{"A5", Link[sample62, Container]},
						{"A6", Link[sample63, Container]},
						{"B1", Link[sample64, Container]},
						{"B2", Link[sample65, Container]},
						{"B3", Link[sample66, Container]}
					}
				|>,
				<|
					Object -> sample67,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample68,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> plate52,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (3)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample67, Container]},
						{"A2", Link[sample68, Container]}
					}
				|>,
				<|
					Object -> sample69,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample70,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> plate53,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (4)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample69, Container]},
						{"A2", Link[sample70, Container]}
					}
				|>,
				<|
					Object -> sample71,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample72,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-2)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> plate54,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (5)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample71, Container]},
						{"A2", Link[sample72, Container]}
					}
				|>,
				<|
					Object -> sample73,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (6-1)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample74,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (6-2)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> plate55,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (6)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample73, Container]},
						{"A2", Link[sample74, Container]}
					}
				|>,
				<|
					Object -> sample75,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (7-1)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> sample76,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[modelSample1, Objects],
					Site -> Link[$Site],
					Name -> "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (7-2)" <> $SessionUUID,
					Volume -> 1Milliliter
				|>,
				<|
					Object -> plate56,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (7)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample75, Container]},
						{"A2", Link[sample76, Container]}
					}
				|>,
				<|
					Object -> dnaSynthProt1,
					Type -> Object[Protocol, DNASynthesis],
					Site -> Link[$Site],
					Name -> "Protocol with ImageSample False for ExperimentCentrifuge testing" <> $SessionUUID,
					ImageSample -> False,
					DeveloperObject -> True
				|>,
				<|
					Object -> dnaSynthProt2,
					Type -> Object[Protocol, DNASynthesis],
					Site -> Link[$Site],
					Name -> "Protocol with ImageSample True for ExperimentCentrifuge testing" <> $SessionUUID,
					ImageSample -> True,
					DeveloperObject -> True
				|>,
				<|
					Object -> centrifugeProt1,
					Type -> Object[Protocol, Centrifuge],
					Site -> Link[$Site],
					Name -> "Existing centrifuge protocol for ExperimentCentrifuge testing" <> $SessionUUID,
					DeveloperObject -> True
				|>,
				<|
					Object -> mspProt1,
					Type -> Object[Protocol, ManualSamplePreparation],
					Site -> Link[$Site],
					Name -> "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID,
					DeveloperObject -> True
				|>,
				MapThread[
					<|
						Object -> #1,
						DeveloperObject -> True,
						Type -> Object[Sample],
						Model -> Link[Model[Sample, "Milli-Q water"], Objects],
						Site -> Link[$Site],
						Name -> "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (" <> ToString[#2] <> ")" <> $SessionUUID,
						Volume -> 10 Milliliter,
						Replace[Composition] -> {{10 Millimolar, Link[Model[Molecule, "Water"]], Now}, {0.137 Millimolar, Link[Model[Molecule, "Sodium Chloride"]], Now}}
					|>&,
					{
						{sample77, sample78, sample79, sample80, sample81, sample82, sample83, sample84, sample85, sample86},
						Range[10]
					}
				],
				MapThread[
					<|
						Object -> #1,
						DeveloperObject -> True,
						Type -> Object[Container, Vessel],
						Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
						Site -> Link[$Site],
						Name -> "50 mL tube with 10 mL sample for ExperimentCentrifuge testing (" <> ToString[#2] <> ")" <> $SessionUUID,
						Replace[Contents] -> {
							{"A1", Link[#3, Container]}
						}
					|>&,
					{
						{container57, container58, container59, container60, container61, container62, container63, container64, container65, container66},
						Range[10],
						{sample77, sample78, sample79, sample80, sample81, sample82, sample83, sample84, sample85, sample86}
					}
				],
				<|
					Object -> sample87,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID,
					Volume -> 1Milliliter,
					Replace[Composition] -> {{10 Millimolar, Link[Model[Molecule, "Water"]], Now}}
				|>,
				<|
					Object -> container67,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Site -> Link[$Site],
					Name -> "50 mL tube with 1 mL sample for ExperimentCentrifuge testing (1)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample87, Container]}
					}
				|>,
				<|
					Object -> sample88,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "50 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID,
					Volume -> 50Milliliter,
					Replace[Composition] -> {{10 Millimolar, Link[Model[Molecule, "Water"]], Now}}
				|>,
				<|
					Object -> container68,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "50 mL tube with 50 mL sample for ExperimentCentrifuge testing (1)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample88, Container]}
					}
				|>,
				(* Rack for non-self-standing 15mL conicals *)
				<|
					Object -> modelRack1,
					DeveloperObject -> True,
					Type -> Model[Container, Rack],
					Name -> "15mL Tube Stand for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Positions] -> {<|Name -> "A1", Footprint -> Conical15mLTube, MaxWidth -> Quantity[0.017, "Meters"], MaxDepth -> Quantity[0.017, "Meters"], MaxHeight -> Null|>},
					TareWeight -> 10Gram
				|>,
				<|
					Object -> modelCounterweight1,
					DeveloperObject -> True,
					Type -> Model[Item, Counterweight],
					Name -> "Test Model Counterweight for ExperimentCentrifuge testing" <> $SessionUUID,
					Footprint -> Plate,
					Weight -> 50 Gram
				|>,
				<|
					Object -> sample89,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "20 mL sample in 50 mL filter tube for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 20Milliliter,
					Replace[Composition] -> {{10 Millimolar, Link[Model[Molecule, "Water"]], Now}}
				|>,
				<|
					Object -> container69,
					DeveloperObject -> True,
					Type -> Object[Container, Vessel, Filter],
					Site -> Link[$Site],
					Model -> Link[Model[Container, Vessel, Filter, "id:GmzlKjPYBJ8M"], Objects],
					Name -> "50 mL filter tube with 20 mL sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample89, Container]}
					}
				|>,
				<|
					Object -> sample90,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "0.2 mL sample in 96 well filter plate for ExperimentCentrifuge testing 1" <> $SessionUUID,
					Volume -> 20Milliliter,
					Replace[Composition] -> {{10 Millimolar, Link[Model[Molecule, "Water"]], Now}}
				|>,
				<|
					Object -> sample91,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "0.2 mL sample in 96 well filter plate for ExperimentCentrifuge testing 2" <> $SessionUUID,
					Volume -> 20Milliliter,
					Replace[Composition] -> {{10 Millimolar, Link[Model[Molecule, "Water"]], Now}}
				|>,
				<|
					Object -> plateFilter70,
					DeveloperObject -> True,
					Type -> Object[Container, Plate, Filter],
					Model -> Link[Model[Container, Plate, Filter, "id:eGakld0955Lo"], Objects],
					Site -> Link[$Site],
					Name -> "0.3 mL PES filter plate with 2 0.2 mL sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample90, Container]},
						{"A2", Link[sample91, Container]}
					}
				|>,
				<|
					Object -> sample92,
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Site -> Link[$Site],
					Name -> "1 mL sample in 96 well deep well plate for ExperimentCentrifuge testing" <> $SessionUUID,
					Volume -> 1Milliliter,
					Replace[Composition] -> {{10 Millimolar, Link[Model[Molecule, "Water"]], Now}}
				|>,
				<|
					Object -> plate71,
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "96 deep well plate with 1 mL sample for ExperimentCentrifuge testing" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample92, Container]}
					}
				|>
			}]];

			Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
				protocol = ExperimentCentrifuge[
					Object[Container, Plate, "96-well plate with 9 1mL samples for ExperimentCentrifuge testing" <> $SessionUUID],
					Time -> 11Minute,
					Name -> "Test template protocol for ExperimentCentrifuge testing" <> $SessionUUID
				];
				Upload[<|Object -> protocol, DeveloperObject -> True|>]
			]
		];


		ClearDownload[];
		ClearMemoization[];


	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[Flatten[
				{
					Object[Sample, "1 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (1)" <> $SessionUUID],
					Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID],
					Object[Instrument, Centrifuge, "Test object centrifuge for ExperimentCentrifuge (2)" <> $SessionUUID],
					Object[Container, Vessel, "Empty container for ExperimentCentrifuge testing" <> $SessionUUID],
					Model[Sample, "Model sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Discarded sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "1.5 mL container with a discarded sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample without volume for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with sample without volume for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample oligo with volume, 1.5 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "1.5 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample oligo with volume, 2 mL container for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[30],
					Object[Container, Vessel, "2 mL container with sample for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[30],
					Object[Sample, "Sample oligo with volume, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample oligo, 1mL, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with 1 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "10 mL sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "incompatible container with sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Large volume sample in incompatible container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "incompatible container with sample for ExperimentCentrifuge testing (2)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1, sample 1)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 2)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing (plate 1 sample 3)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 3 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 1" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 2" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well plate for ExperimentCentrifuge testing New Plate 3" <> $SessionUUID],
					Object[Container, Plate, "Regular 2mL 96-well plate with 3 1mL samples for ExperimentCentrifuge Unit Testing " <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 9 samples for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[9],
					Object[Container, Plate, "96-well plate with 9 1mL samples for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (3-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (3)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (4-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (4)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (5-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (5)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (6-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (6-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (6)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (7-1)" <> $SessionUUID],
					Object[Sample, "1mL sample in 96-well plate with 2 samples for ExperimentCentrifuge testing (7-2)" <> $SessionUUID],
					Object[Container, Plate, "96-well plate with 2 1mL samples for ExperimentCentrifuge testing (7)" <> $SessionUUID],
					Object[Protocol, DNASynthesis, "Protocol with ImageSample False for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, DNASynthesis, "Protocol with ImageSample True for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, Centrifuge, "Existing centrifuge protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Model[Container, CentrifugeRotor, "Test model centrifuge rotor for ExperimentCentrifuge (JS-4.750)" <> $SessionUUID],
					Object[Container, CentrifugeRotor, "Test centrifuge rotor for ExperimentCentrifuge (JS-4.750)" <> $SessionUUID],
					Model[Container, CentrifugeRotor, "Test model centrifuge rotor for microcentrifuge for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID],
					Object[Container, CentrifugeRotor, "Test centrifuge rotor for microcentrifuge for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID],
					Model[Container, CentrifugeRotor, "Test model centrifuge rotor for microcentrifuge for ExperimentCentrifuge (15mL Tube)" <> $SessionUUID],
					Object[Container, CentrifugeRotor, "Test centrifuge rotor for microcentrifuge for ExperimentCentrifuge (15mL Tube)" <> $SessionUUID],
					Model[Container, CentrifugeBucket, "Test model centrifuge bucket for ExperimentCentrifuge (2mL Tube)" <> $SessionUUID],
					Model[Container, CentrifugeBucket, "Test model centrifuge bucket for ExperimentCentrifuge (50mL Conical)" <> $SessionUUID],
					Model[Container, CentrifugeBucket, "Test model centrifuge bucket for ExperimentCentrifuge (Plate)" <> $SessionUUID],
					Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (1, sterile)" <> $SessionUUID],
					Model[Instrument, Centrifuge, "Test model centrifuge for ExperimentCentrifuge (2, sterile)" <> $SessionUUID],
					Object[Instrument, Centrifuge, "Test object centrifuge for ExperimentCentrifuge (2, sterile)" <> $SessionUUID],
					Object[Sample, "Sample oligo with volume, sterile, 15 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "15 mL container with sterile sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "10 mL sample in 50 mL tube for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[10],
					Object[Container, Vessel, "50 mL tube with 10 mL sample for ExperimentCentrifuge testing (" <> ToString[#] <> ")" <> $SessionUUID] & /@ Range[10],
					Object[Protocol, ManualSamplePreparation, "Test template protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "Sample with no subtype and no Model, 2 mL container for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "2 mL container with subtype-less, model-less for ExperimentCentrifuge testing" <> $SessionUUID],
					Model[Container, Rack, "15mL Tube Stand for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "50 mL tube with 1 mL sample for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Sample, "50 mL sample in 50 mL tube for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Container, Vessel, "50 mL tube with 50 mL sample for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Sample, "8.5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "5 mL sample in 8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "8.9 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing with insufficient sample" <> $SessionUUID],
					Object[Sample, "32 mL sample in 32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, "32.4 mL OptiSeal centrifuge tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "20 mL sample in 50 mL filter tube for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Vessel, Filter, "50 mL filter tube with 20 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "0.2 mL sample in 96 well filter plate for ExperimentCentrifuge testing 1" <> $SessionUUID],
					Object[Sample, "0.2 mL sample in 96 well filter plate for ExperimentCentrifuge testing 2" <> $SessionUUID],
					Object[Container, Plate, Filter, "0.3 mL PES filter plate with 2 0.2 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96 well deep well plate for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Container, Plate, "96 deep well plate with 1 mL sample for ExperimentCentrifuge testing" <> $SessionUUID],
					Model[Container, Plate, "Centrifuge Test plate model without counterweights" <> $SessionUUID],
					Object[Container, Plate, "Centrifuge Test plate without counterweights" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample1 in counterweightless plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample2 in counterweightless plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample3 in counterweightless plate" <> $SessionUUID],
					Model[Container, Plate, "Centrifuge Test tall plate model" <> $SessionUUID],
					Model[Container, Plate, "Centrifuge Test heavy plate model" <> $SessionUUID],
					Object[Container, Plate, "Centrifuge Test tall plate" <> $SessionUUID],
					Object[Container, Plate, "Centrifuge Test heavy plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample in tall plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test sample in heavy plate" <> $SessionUUID],
					Object[Container, Plate, "Centrifuge Test normal plate with one heavy sample" <> $SessionUUID],
					Object[Sample, "Centrifuge Test heavy sample in normal plate" <> $SessionUUID],
					Object[Sample, "Centrifuge Test normal sample next to heavy sample in normal plate" <> $SessionUUID],
					Object[Container, Plate, "96-well PCR plate with 1 1mL samples for ExperimentCentrifuge testing (1)" <> $SessionUUID],
					Object[Sample, "1 mL sample in 96-well PCR plate for ExperimentCentrifuge testing (plate 7, sample 1)" <> $SessionUUID],
					Model[Item, Counterweight, "Test Model Counterweight for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, DNASynthesis, "Protocol with ImageSample False for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, DNASynthesis, "Protocol with ImageSample True for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, Centrifuge, "Existing centrifuge protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Existing MSP protocol for ExperimentCentrifuge testing" <> $SessionUUID],
					Download[
						{
							Object[Protocol, Centrifuge, "Test template protocol for ExperimentCentrifuge testing" <> $SessionUUID],
							Object[Protocol, ManualSamplePreparation, "Test template protocol for ExperimentCentrifuge testing" <> $SessionUUID]
						},
						{
							Object,
							Subprotocols[Object],
							RequiredResources[[All, 1]][Object],
							BatchedUnitOperations[Object],
							ProcedureLog[Object]
						}
					]
				}], ObjectP[]]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True]
		]
	)
];


(* ::Subsubsection::Closed:: *)
(*CentrifugeDevices*)



DefineTests[
	CentrifugeDevices,
	{
		Example[{Basic, "Find all centrifuges that can be used to centrifuge the input with the desired settings:"},
			CentrifugeDevices[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]],
			{Model[Instrument, Centrifuge, "id:O81aEB4kJYLO"], Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"], Model[Instrument, Centrifuge, "id:6V0npvmZ1l3Z"], Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"]}
		],
		Example[{Basic, "Find all centrifuges that can be used to centrifuge each if the inputs with the desired settings:"},
			CentrifugeDevices[{
				Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
				Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Object[Sample, "sample for CentrifugeDevices testing" <> $SessionUUID],
				Object[Container, Vessel, "container for CentrifugeDevices testing" <> $SessionUUID]}],
			{
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:O81aEB4kJYLO"],
					Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"],
					Model[Instrument, Centrifuge, "id:6V0npvmZ1l3Z"],
					Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"],
					Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"],
					Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"]]},
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:eGakldJEz14E"]]},
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"]]},
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"]]}
			}
		],
		Example[{Basic, "Find all centrifuges and required container models that can be used to centrifuge at the desired settings:"},
			CentrifugeDevices[Temperature -> 40Celsius],
			{{ObjectP[Model[Instrument, Centrifuge]], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}}..}
		],
		Test["Correctly finds only centrifuges that can spin at the desired temperature:",
			Download[
				CentrifugeDevices[Temperature -> 40Celsius][[All, 1]],
				MaxTemperature
			],
			{GreaterEqualP[40 Celsius]..}
		],
		Example[{Additional, "If the given container is made of Quartz, return an empty list:"},
			CentrifugeDevices[Model[Container, ReactionVessel, Microwave, "SP-D 80 Reaction Vessel"]],
			{}
		],
		Example[{Additional, "If no centrifuges can be found to centrifuge the given container model, returns an empty list:"},
			CentrifugeDevices[Model[Container, Vessel, VolumetricFlask, "Volumetric flask, 500 ml"]],
			{}
		],
		Example[{Additional, "If no centrifuges can be found to centrifuge the given input at the desired settings, returns an empty list:"},
			CentrifugeDevices[Model[Container, Vessel, "50mL Tube"], Intensity -> Quantity[15000.`, ("Revolutions") / ("Minutes")]],
			{}
		],
		Example[{Additional, "If no centrifuges can be found to centrifuge at the desired settings, returns an empty list:"},
			CentrifugeDevices[Temperature -> 40 Celsius, Intensity -> Quantity[100000.`, ("Revolutions") / ("Minutes")]],
			{}
		],
		Example[{Additional, "If a list of settings is specified, provides the centrifuges and associated containers that can meet each setting in the list:"},
			CentrifugeDevices[Temperature -> {40Celsius, Ambient}],
			{
				{OrderlessPatternSequence[
					{Model[Instrument, Centrifuge, "id:6V0npvmZ1l3Z"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:eGakldJEz14E"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:lYq9jRxY9RzA"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:3em6ZvLEbvP7"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:mnk9jOk7RoaR"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}}
				]},
				{OrderlessPatternSequence[
					{Model[Instrument, Centrifuge, "id:O81aEB4kJYLO"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:6V0npvmZ1l3Z"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:eGakldJEz14E"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:lYq9jRxY9RzA"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:3em6ZvLEbvP7"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}},
					{Model[Instrument, Centrifuge, "id:mnk9jOk7RoaR"], {ObjectP[{Model[Container, Plate], Model[Container, Vessel]}]..}}
				]}
			}
		],

		Example[{Messages, "InputLengthMismatch", "If inputs and options don't match in length, return $Failed:"},
			CentrifugeDevices[Model[Container, Vessel, VolumetricFlask, "Volumetric flask, 500 ml"], Temperature -> {40 Celsius, Ambient}],
			$Failed,
			Messages :> {Error::InputLengthMismatch}
		],
		Example[{Messages, "OptionLengthDisagreement", "If options don't match in length, return $Failed:"},
			CentrifugeDevices[Time -> {5 Minute, 6 Minute, 20 Minute}, Temperature -> {40 Celsius, Ambient}],
			$Failed,
			Messages :> {Error::OptionLengthDisagreement}
		],
		Example[{Options, Time, "Find centrifuges that will work with the desired times:"},
			CentrifugeDevices[{
				Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
				Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
				Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				Time -> {1Hour, Automatic, 10000Hour, Automatic}
			],
			{
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:O81aEB4kJYLO"], Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"], Model[Instrument, Centrifuge, "id:6V0npvmZ1l3Z"], Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"]]},
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:O81aEB4kJYLO"], Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"], Model[Instrument, Centrifuge, "id:6V0npvmZ1l3Z"], Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"]]},
				{},
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:eGakldJEz14E"]]}
			}
		],
		Example[{Options, Temperature, "Find centrifuges that will work with the desired temperatures:"},
			CentrifugeDevices[{
				Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
				Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"],
				Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				Temperature -> {30Celsius, Automatic, 30Celsius, Automatic}
			],
			{
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:6V0npvmZ1l3Z"], Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"]]},
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:O81aEB4kJYLO"], Model[Instrument, Centrifuge, "id:jLq9jXY4kGJx"], Model[Instrument, Centrifuge, "id:6V0npvmZ1l3Z"], Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:9RdZXv1XwWex"]]},
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:eGakldJEz14E"]]},
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:eGakldJEz14E"]]}
			}
		],
		Example[{Options, Intensity, "Find centrifuges that will work with the desired force or rate:"},
			CentrifugeDevices[{
				Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
				Intensity -> {500 GravitationalAcceleration, 5000 GravitationalAcceleration}],
			{
				{OrderlessPatternSequence[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Model[Instrument, Centrifuge, "id:WNa4ZjKxm86R"], Model[Instrument, Centrifuge, "id:eGakldJEz14E"]]},
				{}
			}
		],
		Example[{Options, Preparation, "Find centrifuges that will work with desired instensity when centrifuged on deck:"},
			CentrifugeDevices[
				{
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				Intensity -> {
					500 GravitationalAcceleration,
					5000 GravitationalAcceleration
				},
				Preparation -> Robotic
			],
			{{Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"], Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}, {}}
		],
		Example[{Options, Preparation, "Return all allowed plates for on deck centrifuge:"},
			Module[
				{result, allFootPrint},
				result = CentrifugeDevices[Preparation -> Robotic];
				allFootPrint = Download[result[[All, 2]], Footprint];

				{result[[All, 1]], allFootPrint}
			],
			{
				{Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"], Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]},
				{{Plate..}, {Plate..}}
			}
		],
		Example[{Options, Preparation, "No result if the input container model is not plate:"},
			CentrifugeDevices[{Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]}, Preparation -> Robotic],
			{{}}
		],
		Example[{Options, WorkCell, "Specify the STAR WorkCell to use:"},
			CentrifugeDevices[{
				Object[Container, Plate, "96-well plate with 3 1mL samples for CentrifugeDevices testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)
			},
				WorkCell -> STAR, Preparation -> Robotic
			],
			{{Model[Instrument, Centrifuge, "id:vXl9j57YaYrk"]}}
		],
		Example[{Options, WorkCell, "Specify the bioSTAR WorkCell to use:"},
			CentrifugeDevices[{
				Object[Container, Plate, "96-well plate with 3 1mL samples for CentrifugeDevices testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)
			},
				WorkCell -> bioSTAR, Preparation -> Robotic
			],
			{{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}}
		],
		Example[{Options, WorkCell, "Specify the microbioSTAR WorkCell to use:"},
			CentrifugeDevices[{
				Object[Container, Plate, "96-well plate with 3 1mL samples for CentrifugeDevices testing (1)" <> $SessionUUID](* sample in container that will fit cent 2 *)
			},
				WorkCell -> microbioSTAR, Preparation -> Robotic
			],
			{{Model[Instrument, Centrifuge, "id:kEJ9mqaVPAXe"]}}
		]

	},
	SetUp :> {ClearDownload[]; ClearMemoization[];},
	SymbolSetUp :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];

		$CreatedObjects = {};

		Module[{sample, container},
			sample = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Sample],
				Model -> Link[Model[Sample, "Milli-Q water"], Objects],
				Site -> Link[$Site],
				Name -> "sample for CentrifugeDevices testing" <> $SessionUUID,
				Volume -> 1Milliliter
			|>];

			container = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "id:xRO9n3vk11pw"], Objects],
				Site -> Link[$Site],
				Name -> "container for CentrifugeDevices testing" <> $SessionUUID,
				Replace[Contents] -> {{"A1", Link[sample, Container]}}
			|>]
		];

		(* 3 samples in plate *)
		Module[{sample1, sample2, sample3, container},
			sample1 = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Sample],
				Model -> Link[Model[Sample, "Milli-Q water"], Objects],
				Site -> Link[$Site],
				Name -> "1 mL sample in 96-well plate for CentrifugeDevices testing (plate 1, sample 1)" <> $SessionUUID,
				Volume -> 1Milliliter
			|>];

			sample2 = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Sample],
				Model -> Link[Model[Sample, "Milli-Q water"], Objects],
				Site -> Link[$Site],
				Name -> "1 mL sample in 96-well plate for CentrifugeDevices testing (plate 1 sample 2)" <> $SessionUUID,
				Volume -> 1Milliliter
			|>];

			sample3 = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Sample],
				Model -> Link[Model[Sample, "Milli-Q water"], Objects],
				Site -> Link[$Site],
				Name -> "1 mL sample in 96-well plate for CentrifugeDevices testing (plate 1 sample 3)" <> $SessionUUID,
				Volume -> 1Milliliter
			|>];

			container = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
				Site -> Link[$Site],
				Name -> "96-well plate with 3 1mL samples for CentrifugeDevices testing (1)" <> $SessionUUID,
				Replace[Contents] -> {
					{"A1", Link[sample1, Container]},
					{"A2", Link[sample2, Container]},
					{"A3", Link[sample3, Container]}}
			|>]
		];

	},
	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
		ClearMemoization[];
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifugeOptions*)

DefineTests[ExperimentCentrifugeOptions,
	{
		Example[
			{Basic, "Return the resolved options:"},
			ExperimentCentrifugeOptions[{
				Object[Sample, "ExperimentCentrifugeOptions test sample 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentCentrifugeOptions test sample 2 (container)" <> $SessionUUID]
			}],
			Graphics_
		],
		Example[
			{Basic, "Even if an input is invalid, returns as many of the options as could be resolved:"},
			ExperimentCentrifugeOptions[{
				Object[Sample, "ExperimentCentrifugeOptions test sample 1" <> $SessionUUID],
				Object[Container, Vessel, "Empty container for ExperimentCentrifugeOptions testing" <> $SessionUUID]
			}],
			Graphics_,
			Messages :> {Error::EmptyContainers}
		],
		Example[
			{Basic, "Even if an option is invalid, returns as many of the options as could be resolved:"},
			ExperimentCentrifugeOptions[{
				Object[Sample, "ExperimentCentrifugeOptions test sample 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentCentrifugeOptions test sample 2 (container)" <> $SessionUUID]
			}, Preparation -> Robotic
			],
			Graphics_,
			Messages :> {Error::NoCompatibleCentrifuge, Error::InvalidOption}
		],
		Example[
			{Options, OutputFormat, "Return the resolved options as a list:"},
			ExperimentCentrifugeOptions[{
				Object[Sample, "ExperimentCentrifugeOptions test sample 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentCentrifugeOptions test sample 2 (container)" <> $SessionUUID]
			}, OutputFormat -> List],
			Rule___
		]
	},

	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[
			{allObjs, existingObjs},

			allObjs = {
				Model[Sample, "Model sample for ExperimentCentrifugeOptions testing" <> $SessionUUID],
				Object[Container, Vessel, Name -> "Empty container for ExperimentCentrifugeOptions testing" <> $SessionUUID],
				Object[Sample, Name -> "ExperimentCentrifugeOptions test sample 1" <> $SessionUUID],
				Object[Container, Vessel, Name -> "ExperimentCentrifugeOptions test sample 1 (container)" <> $SessionUUID],
				Object[Sample, "ExperimentCentrifugeOptions test sample 2-1" <> $SessionUUID],
				Object[Sample, "ExperimentCentrifugeOptions test sample 2-2" <> $SessionUUID],
				Object[Sample, "ExperimentCentrifugeOptions test sample 2-3" <> $SessionUUID],
				Object[Container, Plate, "ExperimentCentrifugeOptions test sample 2 (container)" <> $SessionUUID]
			};

			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		{
			EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
			$CreatedObjects = {};

			(* Model to use for samples *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Model[Sample],
				Name -> "Model sample for ExperimentCentrifugeOptions testing" <> $SessionUUID
			|>];

			(*Empty Container *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
				Site -> Link[$Site],
				Name -> "Empty container for ExperimentCentrifugeOptions testing" <> $SessionUUID
			|>];

			Module[{sample, container},
				sample = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Model sample for ExperimentCentrifugeOptions testing" <> $SessionUUID], Objects],
					Site -> Link[$Site],
					Name -> "ExperimentCentrifugeOptions test sample 1" <> $SessionUUID,
					Volume -> 1Milliliter
				|>];

				container = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Site -> Link[$Site],
					Name -> "ExperimentCentrifugeOptions test sample 1 (container)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample, Container]}
					}
				|>]
			];

			Module[{samples, container, wells, samplesAndWells},
				samples = Upload[
					Map[
						<|
							DeveloperObject -> True,
							Type -> Object[Sample],
							Model -> Link[Model[Sample, "Model sample for ExperimentCentrifugeOptions testing" <> $SessionUUID], Objects],
							Site -> Link[$Site],
							Name -> "ExperimentCentrifugeOptions test sample 2-" <> ToString[#] <> $SessionUUID,
							Volume -> 1Milliliter
						|>&, Range[3]]
				];

				wells = Take[Flatten[AllWells[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]]], 3];

				samplesAndWells = Transpose[{wells, Link[samples, Container]}];

				container = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "ExperimentCentrifugeOptions test sample 2 (container)" <> $SessionUUID,
					Replace[Contents] -> samplesAndWells,
					TareWeight -> 0.01Gram
				|>]
			];
		}
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		{
			EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
			Unset[$CreatedObjects]
		}
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentCentrifugePreview*)

DefineTests[ExperimentCentrifugePreview,
	{
		Example[
			{Basic, "Returns Null:"},
			ExperimentCentrifugePreview[{
				Object[Sample, "centrifugePreview test sample 1"],
				Object[Container, Plate, "centrifugePreview test sample 2 (container)"]
			}],
			Null
		],
		Example[
			{Basic, "Even if an input is invalid, returns Null:"},
			ExperimentCentrifugePreview[{
				Object[Sample, "centrifugePreview test sample 1"],
				Object[Container, Vessel, "Empty container for centrifugePreview testing"]
			}],
			Null,
			Messages :> {Error::EmptyContainers}
		],
		Example[
			{Basic, "Even if an option is invalid, returns Null:"},
			ExperimentCentrifugePreview[{
				Object[Sample, "centrifugePreview test sample 1"],
				Object[Container, Plate, "centrifugePreview test sample 2 (container)"]
			}, Preparation -> Robotic
			],
			Null,
			Messages :> {Error::NoCompatibleCentrifuge, Error::InvalidOption}
		]
	},

	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		{
			EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
			$CreatedObjects = {};

			(* Model to use for samples *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Model[Sample],
				Name -> "Model sample for centrifugePreview testing"
			|>];

			Upload[<|
				Type -> Object[Protocol, ManualSamplePreparation],
				Site -> Link[$Site],
				Name -> "Existing centrifugePreview protocol"
			|>];

			(*Empty Container *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
				Site -> Link[$Site],
				Name -> "Empty container for centrifugePreview testing"
			|>];

			Module[{sample, container},
				sample = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Model sample for centrifugePreview testing"], Objects],
					Site -> Link[$Site],
					Name -> "centrifugePreview test sample 1",
					Volume -> 1Milliliter
				|>];

				container = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Site -> Link[$Site],
					Name -> "centrifugePreview test sample 1 (container)",
					Replace[Contents] -> {
						{"A1", Link[sample, Container]}
					}
				|>]
			];

			Module[{samples, container, wells, samplesAndWells},
				samples = Upload[
					Map[
						<|
							DeveloperObject -> True,
							Type -> Object[Sample],
							Model -> Link[Model[Sample, "Model sample for centrifugePreview testing"], Objects],
							Site -> Link[$Site],
							Name -> "centrifugePreview test sample 2-" <> ToString[#],
							Volume -> 1Milliliter
						|>&, Range[3]]
				];

				wells = Take[Flatten[AllWells[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]]], 3];

				samplesAndWells = Transpose[{wells, Link[samples, Container]}];

				container = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "centrifugePreview test sample 2 (container)",
					Replace[Contents] -> samplesAndWells
				|>]
			];
		}
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		{
			EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
			Unset[$CreatedObjects]
		}
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentCentrifugeQ*)

DefineTests[ValidExperimentCentrifugeQ,
	{
		Example[
			{Basic, "Return a boolean indicating whether the call is valid:"},
			ValidExperimentCentrifugeQ[{
				Object[Sample, "ValidExperimentCentrifugeQ test sample 1"<>$SessionUUID],
				Object[Container, Plate, "ValidExperimentCentrifugeQ test sample 2 (container)"<>$SessionUUID]
			}],
			True
		],
		Example[
			{Basic, "If an input is invalid, returns False:"},
			ValidExperimentCentrifugeQ[{
				Object[Sample, "ValidExperimentCentrifugeQ test sample 1"<>$SessionUUID],
				Object[Container, Vessel, "Empty container for ValidExperimentCentrifugeQ testing"<>$SessionUUID]
			}],
			False
		],
		Example[
			{Basic, "If an option is invalid, returns False:"},
			ValidExperimentCentrifugeQ[{
				Object[Sample, "ValidExperimentCentrifugeQ test sample 1"<>$SessionUUID],
				Object[Container, Plate, "ValidExperimentCentrifugeQ test sample 2 (container)"<>$SessionUUID]
			}, Preparation -> Robotic
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary of the tests run to validate the call:"},
			ValidExperimentCentrifugeQ[{
				Object[Sample, "ValidExperimentCentrifugeQ test sample 1"<>$SessionUUID],
				Object[Container, Plate, "ValidExperimentCentrifugeQ test sample 2 (container)"<>$SessionUUID]
			},
				Name -> "Existing ValidExperimentCentrifugeQ protocol",
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print the test results in addition to returning a boolean indicating the validity of the call:"},
			ValidExperimentCentrifugeQ[{
				Object[Sample, "ValidExperimentCentrifugeQ test sample 1"<>$SessionUUID],
				Object[Container, Plate, "ValidExperimentCentrifugeQ test sample 2 (container)"<>$SessionUUID]
			},
				Name -> "Existing ValidExperimentCentrifugeQ protocol",
				Verbose -> True
			],
			BooleanP
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False,
		$AllowPublicObjects = True
	},
	SymbolSetUp :> {
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects = {};
		Module[{allObjects, singleSample, multipleSamples, wells, samplesAndWells},

			(* Define all objects that are defined in this unit test. *)
			allObjects = Flatten[{
				Model[Sample, "Model sample for ValidExperimentCentrifugeQ testing"<>$SessionUUID],
				Object[Protocol,ManualSamplePreparation, "Existing ValidExperimentCentrifugeQ protocol"<>$SessionUUID],
				Object[Container, Vessel, "Empty container for ValidExperimentCentrifugeQ testing"<>$SessionUUID],
				Object[Sample, "ValidExperimentCentrifugeQ test sample 1"<>$SessionUUID],
				Object[Container, Vessel, "ValidExperimentCentrifugeQ test sample 1 (container)"<>$SessionUUID],
				Object[Sample,"ValidExperimentCentrifugeQ test sample 2-" <> ToString[#]<>$SessionUUID]&/@Range[3],
				Object[Container,Plate, "ValidExperimentCentrifugeQ test sample 2 (container)"<>$SessionUUID]
			}];

			(* Erase test objects if they exist in the data base.  *)
			EraseObject[PickList[allObjects, DatabaseMemberQ[allObjects]], Force -> True, Verbose -> False];

			(* Model to use for samples *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Model[Sample],
				Name -> "Model sample for ValidExperimentCentrifugeQ testing"<>$SessionUUID
			|>];

			(* Upload test MSP protocol *)
			Upload[<|
				Type -> Object[Protocol, ManualSamplePreparation],
				Site -> Link[$Site],
				Name -> "Existing ValidExperimentCentrifugeQ protocol"<>$SessionUUID
			|>];

			(*Empty Container *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
				Site -> Link[$Site],
				Name -> "Empty container for ValidExperimentCentrifugeQ testing"<>$SessionUUID
			|>];

			(* Upload test sample. *)
			singleSample = Upload[<|
				DeveloperObject -> True,
				Type -> Object[Sample],
				Model -> Link[Model[Sample, "Model sample for ValidExperimentCentrifugeQ testing"<>$SessionUUID], Objects],
				Site -> Link[$Site],
				Name -> "ValidExperimentCentrifugeQ test sample 1"<>$SessionUUID,
				Volume -> 1Milliliter
			|>];

			(* Upload test tube and its contents. *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
				Site -> Link[$Site],
				Name -> "ValidExperimentCentrifugeQ test sample 1 (container)"<>$SessionUUID,
				Replace[Contents] -> {
					{"A1", Link[singleSample, Container]}
				}
			|>];

			(* Upload test samples. *)
			multipleSamples = Upload[
				Map[
					<|
						DeveloperObject -> True,
						Type -> Object[Sample],
						Model -> Link[Model[Sample, "Model sample for ValidExperimentCentrifugeQ testing"<>$SessionUUID], Objects],
						Site -> Link[$Site],
						Name -> "ValidExperimentCentrifugeQ test sample 2-" <> ToString[#]<>$SessionUUID,
						Volume -> 1Milliliter
					|>&, Range[3]]
			];

			(* Get first 3 available wells from 48-well plate. *)
			wells = Take[Flatten[AllWells[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]]], 3];

			(* Generate the upload information for the Contents field. *)
			samplesAndWells = Transpose[{wells, Link[multipleSamples, Container]}];

			(* Upload the plate and its contents. *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"], Objects],
				Site -> Link[$Site],
				Name -> "ValidExperimentCentrifugeQ test sample 2 (container)"<>$SessionUUID,
				Replace[Contents] -> samplesAndWells
			|>];
		]
	},
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	}
];



(* ::Subsubsection:: *)
(*Centrifuge*)


DefineTests[Centrifuge,
	{
		Example[
			{Basic, "Perform a basic centrifuge"},
			Experiment[{
				Centrifuge[
					Sample -> {
						Object[Sample, "Centrifuge test sample 1"<>$SessionUUID],
						Object[Container, Plate, "Centrifuge test sample 2 (container)"<>$SessionUUID]
					}
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[
			{Basic, "If an input is invalid, returns $Failed 1:"},
			Experiment[{
				Centrifuge[
					Sample -> {
						Object[Sample, "Centrifuge test sample 1"<>$SessionUUID],
						Object[Container, Vessel, "Empty container for Centrifuge testing"<>$SessionUUID]
					}
				]
			}],
			$Failed,
			Messages :> {Error::EmptyContainers, Error::InvalidInput}
		],
		Example[
			{Basic, "If an input is invalid, returns $Failed 2:"},
			ExperimentRoboticSamplePreparation[{
				Centrifuge[
					Sample -> {
						Object[Sample, "Centrifuge test sample 1"<>$SessionUUID],
						Object[Container, Plate, "Centrifuge test sample 2 (container)"<>$SessionUUID]
					}
				]
			}],
			$Failed,
			Messages :> {Error::NoCompatibleCentrifuge, Error::InvalidInput}
		]
	},

	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[
			{allObjs, existingObjs},

			allObjs = {
				Model[Sample, "Model sample for Centrifuge testing" <> $SessionUUID],
				Object[Container, Vessel, Name -> "Empty container for Centrifuge testing" <> $SessionUUID],
				Object[Sample, Name -> "Centrifuge test sample 1" <> $SessionUUID],
				Object[Container, Vessel, Name -> "Centrifuge test sample 1 (container)" <> $SessionUUID],
				Object[Sample, "Centrifuge test sample 2-1" <> $SessionUUID],
				Object[Sample, "Centrifuge test sample 2-2" <> $SessionUUID],
				Object[Sample, "Centrifuge test sample 2-3" <> $SessionUUID],
				Object[Container, Plate, "Centrifuge test sample 2 (container)" <> $SessionUUID]
			};

			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		{
			EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
			$CreatedObjects = {};

			(* Model to use for samples *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Model[Sample],
				Name -> "Model sample for Centrifuge testing" <> $SessionUUID
			|>];

			(*Empty Container *)
			Upload[<|
				DeveloperObject -> True,
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
				Site -> Link[$Site],
				Name -> "Empty container for Centrifuge testing" <> $SessionUUID
			|>];

			Module[{sample, container},
				sample = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Sample],
					Model -> Link[Model[Sample, "Model sample for Centrifuge testing" <> $SessionUUID], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge test sample 1" <> $SessionUUID,
					Volume -> 1Milliliter
				|>];

				container = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge test sample 1 (container)" <> $SessionUUID,
					Replace[Contents] -> {
						{"A1", Link[sample, Container]}
					}
				|>]
			];

			Module[{samples, container, wells, samplesAndWells},
				samples = Upload[
					Map[
						<|
							DeveloperObject -> True,
							Type -> Object[Sample],
							Model -> Link[Model[Sample, "Model sample for Centrifuge testing" <> $SessionUUID], Objects],
							Site -> Link[$Site],
							Name -> "Centrifuge test sample 2-" <> ToString[#] <> $SessionUUID,
							Volume -> 1Milliliter
						|>&, Range[3]]
				];

				wells = Take[Flatten[AllWells[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]]], 3];

				samplesAndWells = Transpose[{wells, Link[samples, Container]}];

				container = Upload[<|
					DeveloperObject -> True,
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "Centrifuge test sample 2 (container)" <> $SessionUUID,
					Replace[Contents] -> samplesAndWells,
					TareWeight -> 0.01Gram
				|>]
			];
		}
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		{
			EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
			Unset[$CreatedObjects]
		}
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"],
		$EmailEnabled = False
	}
];
