(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentAlphaScreen*)


DefineTests[
	ExperimentAlphaScreen,
	{
		(* AlphaScreen Specific *)
		(* -- Input examples -- *)
		Example[{Basic, "Measure the AlphaScreen signal of a sample:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID]],
			ObjectP[Object[Protocol, AlphaScreen]],
			TimeConstraint -> 240
		],
		Example[{Basic, "Measure the AlphaScreen signal of two samples:"},
			ExperimentAlphaScreen[{Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID], Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AlphaScreen]],
			TimeConstraint -> 240
		],
		Example[{Basic, "Measure the AlphaScreen signal of all samples in a prepared plate:"},
			ExperimentAlphaScreen[Object[Container, Plate, "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID], PreparedPlate -> True],
			ObjectP[Object[Protocol, AlphaScreen]],
			TimeConstraint -> 240
		],
		Example[{Basic, "Measure the AlphaScreen signal of all samples in two prepared plates:"},
			ExperimentAlphaScreen[{Object[Container, Plate, "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID], Object[Container, Plate, "Test 96-well plate 2 for ExperimentAlphaScreen" <> $SessionUUID]}, PreparedPlate -> True, AlphaAssayVolume -> Null],
			ObjectP[Object[Protocol, AlphaScreen]],
			TimeConstraint -> 240
		],
		Example[{Basic, "Measure the AlphaScreen signal of all samples that are aliquoted in multiple plates:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID], NumberOfReplicates -> 100, AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"]],
			ObjectP[Object[Protocol, AlphaScreen]],
			TimeConstraint -> 240
		],

		(*Shared Tests*)
		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESNT BUG ON THIS.  *)
		Example[{Additional, "Use the sample preparation options (Filtration and Incubate) to prepare samples before the main experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Filtration -> True , Incubate -> True, Output -> Options];
			{Lookup[options, Filtration], Lookup[options, Incubate]},
			{True, True},
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Additional, "Use the sample preparation options (Centrifuge and Aliquot) to prepare samples before the main experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Centrifuge -> True, Aliquot -> True, Output -> Options];
			{Lookup[options, Centrifuge], Lookup[options, Aliquot]},
			{True, True},
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Additional, "Input as {Position,Container}:"},
			ExperimentAlphaScreen[{"A1", Object[Container, Plate, "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AlphaScreen]],
			TimeConstraint -> 240
		],
		Example[{Additional, "Input as a mixture of samples :"},
			ExperimentAlphaScreen[{{"A2", Object[Container, Plate, "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID]}, Object[Sample, "Test sample 4 for ExperimentAlphaScreen" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AlphaScreen]],
			TimeConstraint -> 240
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], IncubationTemperature -> 40 * Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40 * Celsius,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], IncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], MaxIncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], AnnealingTime -> 40 * Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], IncubateAliquot -> 100 * Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			100 * Microliter,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			TimeConstraint -> 240,
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], CentrifugeIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], CentrifugeTime -> 5 * Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5 * Minute,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], CentrifugeTemperature -> 10 * Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], CentrifugeAliquot -> 100 * Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			100 * Microliter,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			TimeConstraint -> 240,
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PLUS, 0.45um, 33mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PLUS, 0.45um, 33mm"]],
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			TimeConstraint -> 240,
			Variables :> {options}
		],

		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test 1M NaCl solution for ExperimentAlphaScreen" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],

		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 * Micrometer,
			TimeConstraint -> 240,
			Variables :> {options}
		],

		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test 1M NaCl solution for ExperimentAlphaScreen" <> $SessionUUID], PrefilterPoreSize -> 1. * Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1. * Micrometer,
			Variables :> {options}
		],

		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FilterHousing -> Model[Instrument, FilterBlock, "Filter Block"], FiltrationType -> Vacuum, Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterBlock, "Filter Block"]],
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20 * Minute, Output -> Options];
			Lookup[options, FilterTime],
			20 * Minute,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10 * Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FilterAliquot -> 1 * Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			1 * Milliliter,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			TimeConstraint -> 240,
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		(*an error check for conflict with AlphaAssayVolume?*)
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], AliquotAmount -> 0.1 * Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.1 * Milliliter,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], AssayVolume -> 0.1 * Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.1 * Milliliter,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			Quiet[options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], TargetConcentration -> 1 * Millimolar, Output -> Options]];
			Lookup[options, TargetConcentration],
			1 * Millimolar,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			Quiet[options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options]];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			Quiet[options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options]];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			Quiet[options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options]];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			Quiet[options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options]];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		(* For plate reader experiment, ConsolidateAliquots cannot be True *)
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position. This cannot be True for a plate reader experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], ConsolidateAliquots -> False, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			False,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"]]}},
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentAlphaScreen[Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			TimeConstraint -> 240,
			Variables :> {options}
		],

		(* -- Primitive tests -- *)
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with Preparation->Robotic:",
			Experiment[{
				AlphaScreen[
					Sample -> Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Test["Generate an ManualSamplePreparation protocol object based on a single primitive with Preparation->Manual:",
			Experiment[{
				AlphaScreen[
					Sample -> Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					Aliquot -> True,
					Filtration -> True,
					Preparation -> Manual
				]
			}],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a primitive with multiple samples and Preparation->Robotic:",
			Experiment[{
				AlphaScreen[
					Sample -> {
						Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
						Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID]
					},
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],


		(* -- Messages -- *)
		Example[{Messages, "InputContainsTemporalLinks", "A Warning is thrown if any inputs or options contain temporal links:"},
			ExperimentAlphaScreen[
				Link[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID], Now]
			],
			ObjectP[Object[Protocol, AlphaScreen]],
			Messages :> {
				Warning::InputContainsTemporalLinks
			},
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenNotBMGPlates", "A Warning is thrown if the plate mode doesn't match any available plate layouts in the reader:"},
			ExperimentAlphaScreen[
				Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				AlphaAssayVolume -> 200 Microliter
			],
			ObjectP[Object[Protocol, AlphaScreen]],
			Messages :> {
				Warning::AlphaScreenNotBMGPlates
			},
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenNotBMGPlates", "A Warning is thrown if the samples are in a prepared plate whose container doesn't match any available plate layouts in the reader:"},
			ExperimentAlphaScreen[
				Object[Container, Plate, "Test 96-well 2mL deep well plate for ExperimentAlphaScreen" <> $SessionUUID],
				PreparedPlate -> True
			],
			ObjectP[Object[Protocol, AlphaScreen]],
			Messages :> {
				Warning::AlphaScreenNotBMGPlates
			},
			TimeConstraint -> 240
		],
		Example[{Messages, "EmptyContainers", "All containers provided as input to the experiment must contain samples:"},
			ExperimentAlphaScreen[{Object[Container, Plate, "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID], Object[Container, Plate, "Empty plate for ExperimentAlphaScreen" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::EmptyContainers},
			TimeConstraint -> 240
		],
		Test["When running tests return False if all containers provided as input to the experiment don't contain samples:",
			ValidExperimentAlphaScreenQ[{Object[Container, Plate, "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID], Object[Container, Plate, "Empty plate for ExperimentAlphaScreen" <> $SessionUUID]}],
			False
		],
		Example[{Messages, "AlphaScreenRepeatedPlateReaderSamples", "Throws an error if the same sample appears multiple time in the input list, but Aliquot has been set to False so aliquots of the repeated sample cannot be created for the read:"},
			ExperimentAlphaScreen[{
				Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID]
			},
				Aliquot -> {False, False, False}
			],
			$Failed,
			Messages :> {Error::AlphaScreenRepeatedPlateReaderSamples, Error::InvalidInput},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the same sample appears multiple time in the input list, but Aliquot has been set to False so aliquots of the repeated sample cannot be created for the read:",
			ValidExperimentAlphaScreenQ[{
				Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID]
			},
				Aliquot -> {False, False, False}
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 9 for ExperimentAlphaScreen" <> $SessionUUID]],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the provided sample is discarded:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 9 for ExperimentAlphaScreen" <> $SessionUUID]],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "RetiredInstrument", "If the plate reader is retired, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Instrument -> Object[Instrument, PlateReader, "Test retired plate reader for ExperimentAlphaScreen" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::RetiredInstrument, Error::InvalidInput},
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenNotSupportedPlateReader", "If the plate reader does not support AlphaScreen, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "Lunatic"]
			],
			$Failed,
			Messages :> {Error::AlphaScreenNotSupportedPlateReader, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the plate reader is retired:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Instrument -> Object[Instrument, PlateReader, "Test retired plate reader for ExperimentAlphaScreen" <> $SessionUUID]
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenPreparedPlateIrrelevant", "If a PreparedPlate is used, irrelevant options should not be specified. Otherwise, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PreparedPlate -> True,
				AssayPlateModel -> Null,
				AlphaAssayVolume -> 10 Microliter,
				NumberOfReplicates -> Null,
				MoatWells -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenPreparedPlateIrrelevant, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if a PreparedPlate is used but irrelevant options are specified:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PreparedPlate -> True,
				AssayPlateModel -> Null,
				AlphaAssayVolume -> 10 Microliter,
				NumberOfReplicates -> Null,
				MoatWells -> Null
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenAssayPlateInfoRequired", "If a PreparedPlate is not used, plate and assay options should be specified. Otherwise, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PreparedPlate -> False,
				AssayPlateModel -> Null,
				AlphaAssayVolume -> 10 Microliter
			],
			$Failed,
			Messages :> {Error::AlphaScreenAssayPlateInfoRequired, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if a PreparedPlate is not used and assay options are not specified:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PreparedPlate -> False,
				AssayPlateModel -> Null,
				AlphaAssayVolume -> 10 Microliter
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenInvalidAssayPlate", "If the plate model is not compatible with the liquid handler, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "12-well Tissue Culture Plate"]
			],
			$Failed,
			Messages :> {Error::AlphaScreenInvalidAssayPlate, Warning::AlphaScreenNotBMGPlates, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the plate model is not compatible with the liquid handler:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "12-well Tissue Culture Plate"]],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenWellVolumeBelowLimit", "If the assay volume (AlphaAssayVolume) is below the lowest working volume of any available plates, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				AlphaAssayVolume -> 2 Microliter
			],
			$Failed,
			Messages :> {Error::AlphaScreenWellVolumeBelowLimit, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the assay volume (AlphaAssayVolume) is below the lowest working volume of any available plates:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				AlphaAssayVolume -> 2 Microliter
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenWellVolumeAboveLimit", "If the assay volume (AlphaAssayVolume) is above the highest working volume of any available plates, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AlphaAssayVolume -> 200 Microliter
			],
			$Failed,
			Messages :> {Error::AlphaScreenWellVolumeAboveLimit, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the assay volume (AlphaAssayVolume) is above the highest working volume of any available plates:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AlphaAssayVolume -> 200 Microliter
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenHighWellVolume", "If the assay volume (AlphaAssayVolume) is above the recommended working volume of the plate, a warning will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],
				AlphaAssayVolume -> 80 Microliter
			],
			ObjectP[Object[Protocol, AlphaScreen]],
			Messages :> {Warning::AlphaScreenHighWellVolume},
			TimeConstraint -> 240
		],
		Test["When running tests return indicate if the assay volume (AlphaAssayVolume) is above the recommended working volume of the plate:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],
				AlphaAssayVolume -> 80 Microliter
			],
			True,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenLowWellVolume", "If the assay volume (AlphaAssayVolume) is below the minimum working volume of the plate, a warning will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
				AlphaAssayVolume -> 20 Microliter
			],
			ObjectP[Object[Protocol, AlphaScreen]],
			Messages :> {Warning::AlphaScreenLowWellVolume},
			TimeConstraint -> 240
		],
		Test["When running tests indicate if the assay volume (AlphaAssayVolume) is below the minimum working volume of the plate:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
				AlphaAssayVolume -> 20 Microliter
			],
			True,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenWellVolumeExceeded", "If the assay volume (AlphaAssayVolume) exceeds the maximum working volume of the plate, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],
				AlphaAssayVolume -> 110 Microliter
			],
			$Failed,
			Messages :> {Error::AlphaScreenWellVolumeExceeded, Error::VolumeOverContainerMax, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the assay volume (AlphaAssayVolume) exceeds the maximum working volume of the plate:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],
				AlphaAssayVolume -> 110 Microliter
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMixParametersUnneeded", "When plate reader mixing is not needed (PlateReaderMix is False), the irrelevant options should not be specified. Otherwise, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PlateReaderMix -> False,
				PlateReaderMixRate -> 700 RPM,
				PlateReaderMixTime -> Null,
				PlateReaderMixMode -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMixParametersUnneeded, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When plate reader mixing is not needed (PlateReaderMix is False), the irrelevant options should not be specified. Otherwise, an error will be thrown:",
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PlateReaderMix -> False,
				PlateReaderMixRate -> 700 RPM,
				PlateReaderMixTime -> Null,
				PlateReaderMixMode -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMixParametersUnneeded, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if plate reader mixing is not needed (PlateReaderMix is False) but the irrelevant options are specified:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PlateReaderMix -> False,
				PlateReaderMixRate -> 700 RPM,
				PlateReaderMixTime -> Null,
				PlateReaderMixMode -> Null
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMixParametersRequired", "When plate reader mixing is needed (PlateReaderMix is True), the relevant options should be specified. Otherwise, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PlateReaderMix -> True,
				PlateReaderMixRate -> 700 RPM,
				PlateReaderMixTime -> 10 Second,
				PlateReaderMixMode -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMixParametersRequired, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When plate reader mixing is needed (PlateReaderMix is True), the relevant options should be specified. Otherwise, an error will be thrown:",
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PlateReaderMix -> True,
				PlateReaderMixRate -> 700 RPM,
				PlateReaderMixTime -> 10 Second,
				PlateReaderMixMode -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMixParametersRequired, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if plate reader mixing is needed (PlateReaderMix is True) but the relevant options are not specified:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PlateReaderMix -> True,
				PlateReaderMixRate -> 700 RPM,
				PlateReaderMixTime -> 10 Second,
				PlateReaderMixMode -> Null
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMixParametersConflicting", "When plate reader mixing is resolved automatically, the relevant options must all be set to values or all be set to Null. Otherwise, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PlateReaderMix -> Automatic,
				PlateReaderMixRate -> 700 RPM,
				PlateReaderMixTime -> 10 Second,
				PlateReaderMixMode -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMixParametersConflicting, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMoatParametersUnneeded", "When moat is not needed (MoatWells is False), the irrelevant options should not be specified. Otherwise, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				MoatWells -> False,
				MoatSize -> 1,
				MoatVolume -> Null,
				MoatBuffer -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMoatParametersUnneeded, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When moat is not needed (MoatWells is False), the irrelevant options should not be specified. Otherwise, an error will be thrown:",
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				MoatWells -> False,
				MoatSize -> 1,
				MoatVolume -> Null,
				MoatBuffer -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMoatParametersUnneeded, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if moat is not needed (MoatWells is False) but the irrelevant options are specified:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				MoatWells -> False,
				MoatSize -> 1,
				MoatVolume -> Null,
				MoatBuffer -> Null
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMoatParametersRequired", "When moat is needed (MoatWells is True), the relevant options should be specified. Otherwise, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				MoatWells -> True,
				MoatSize -> 1,
				MoatVolume -> 5 Microliter,
				MoatBuffer -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMoatParametersRequired, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if moat is needed (MoatWells is True) but the relevant options are not specified:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				MoatWells -> True,
				MoatSize -> 1,
				MoatVolume -> 5 Microliter,
				MoatBuffer -> Null
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMoatParametersConflicting", "When moat is resolved automatically (MoatWells is Automatic), the relevant parameter options should be specified. Otherwise, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				MoatWells -> Automatic,
				MoatSize -> 1,
				MoatVolume -> 5 Microliter,
				MoatBuffer -> Null
			],
			$Failed,
			Messages :> {Error::AlphaScreenMoatParametersConflicting, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMoatAliquotsRequired", "Moats are created as part of sample aliquoting. As a result if a moat is requested Aliquot must then be set to True:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Aliquot -> False,
				MoatWells -> True,
				MoatBuffer -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::AlphaScreenMoatAliquotsRequired, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["Moats are created as part of sample aliquoting. As a result if a moat is requested Aliquot must then be set to True:",
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Aliquot -> False,
				MoatWells -> True,
				MoatBuffer -> Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages :> {Error::AlphaScreenMoatAliquotsRequired, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if a moat is requested but Aliquot->False:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Aliquot -> False,
				MoatWells -> True,
				MoatBuffer -> Model[Sample, "Milli-Q water"]
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMoatVolumeOverlimit", "The moat volumes cannot exceed the maximum volume limit of available plates:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Aliquot -> True,
				MoatWells -> True,
				MoatVolume -> 500 Microliter
			],
			$Failed,
			Messages :> {Error::AlphaScreenMoatVolumeOverlimit, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the moat wells have volumes that are beyond the MaxVolume of the container:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				Aliquot -> True,
				MoatWells -> True,
				MoatVolume -> 500 Microliter
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenMoatVolumeOverflow", "The moat wells cannot be filled beyond the MaxVolume of the container:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],
				Aliquot -> True,
				MoatWells -> True,
				MoatVolume -> 120 Microliter
			],
			$Failed,
			Messages :> {Error::AlphaScreenMoatVolumeOverflow, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the moat wells have volumes that are beyond the MaxVolume of the container that we specified:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],
				Aliquot -> True,
				MoatWells -> True,
				MoatVolume -> 120 Microliter
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenTooManyMoatWells", "Throws an error if moat size is above 3 which will limits the available wells for the input samples:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
				NumberOfReplicates -> 5,
				Aliquot -> True,
				MoatWells -> True,
				MoatSize -> 4
			],
			$Failed,
			Messages :> {Error::AlphaScreenTooManyMoatWells, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["Throws an error if moat size is above 3 which will limits the available wells for the input samples:",
			ExperimentAlphaScreen[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
				NumberOfReplicates -> 5,
				Aliquot -> True,
				MoatWells -> True,
				MoatSize -> 4
			],
			$Failed,
			Messages :> {Error::AlphaScreenTooManyMoatWells, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if more wells are required than are available in the plate. Here the moat requires 64 wells and the samples with replicates require 40 wells:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
				NumberOfReplicates -> 5,
				Aliquot -> True,
				MoatWells -> True,
				MoatSize -> 4
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenWellOverlap", "The wells to be used for the moat cannot also be used to hold assay samples:"},
			ExperimentAlphaScreen[
				{
					Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID]
				},
				DestinationWell -> {"A1", "B2"},
				AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
				MoatWells -> True,
				MoatVolume -> 50 Microliter,
				Aliquot -> True
			],
			$Failed,
			Messages :> {Error::AlphaScreenWellOverlap, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the wells to be used for the moat are also used to hold assay samples:",
			ValidExperimentAlphaScreenQ[
				{
					Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID]
				},
				DestinationWell -> {"A1", "B2"},
				MoatVolume -> 50 Microliter,
				Aliquot -> True
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenCoverNotRecommended", "If a cover is retained on the plate, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				RetainCover -> True
			],
			$Failed,
			Messages :> {Error::AlphaScreenCoverNotRecommended, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["If a cover is retained on the plate, an error will be thrown:",
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				RetainCover -> True
			],
			$Failed,
			Messages :> {Error::AlphaScreenCoverNotRecommended, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if a cover is retained on the plate during measurement:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				RetainCover -> True
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenConflictAliquotOption", "If Aliquot has a mix of True and False for SamplesIn in AlphaScreen, an error will be thrown:"},
			ExperimentAlphaScreen[{Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID], Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID]},
				Aliquot -> {True, False}
			],
			$Failed,
			Messages :> {Error::AlphaScreenConfiltAliquotOption, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["If Aliquot has a mix of True and False for SamplesIn in AlphaScreen, an error will be thrown:",
			ExperimentAlphaScreen[{Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID], Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID]},
				Aliquot -> {True, False}
			],
			$Failed,
			Messages :> {Error::AlphaScreenConfiltAliquotOption, Error::InvalidOption},
			TimeConstraint -> 240
		],

		Example[{Messages, "AlphaScreenInvalidExcitationWavelength", "If the excitation wavelength is not set to 680nm, an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				ExcitationWavelength -> 500 Nanometer
			],
			$Failed,
			Messages :> {Error::AlphaScreenInvalidExcitationWavelength, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["If the excitation wavelength is not set to 680nm, an error will be thrown:",
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				ExcitationWavelength -> 500 Nanometer
			],
			$Failed,
			Messages :> {Error::AlphaScreenInvalidExcitationWavelength, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["When running tests return False if the excitation wavelength is not set to 680nm:",
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				ExcitationWavelength -> 500 Nanometer
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Messages, "AlphaScreenInvalidSampleAliquot", "Aliquot cannot be specified for a prepared plate, otherwise an error will be thrown:"},
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PreparedPlate -> False,
				Aliquot -> False
			],
			$Failed,
			Messages :> {Error::AlphaScreenInvalidSampleAliquot, Error::InvalidOption},
			TimeConstraint -> 240
		],
		Test["If PreparedPlate->False, the aliquot cannot be specified. Otherwise, an error will be thrown:",
			ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
				PreparedPlate -> False,
				Aliquot -> False
			],
			$Failed,
			Messages :> {Error::AlphaScreenInvalidSampleAliquot, Error::InvalidOption},
			TimeConstraint -> 240
		],
		(* -- Option Resolution -- *)
		Example[{Options, PreparedPlate, "Specify the input container as a prepared plate that should be measured in AlphaScreen:"},
			Module[{options, preparedPlate},
				options = ExperimentAlphaScreen[Object[Container, Plate, "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PreparedPlate -> True,
					Output -> Options
				];
				preparedPlate = Lookup[options, PreparedPlate]
			],
			True,
			TimeConstraint -> 240
		],
		Example[{Options, Instrument, "Specify the plate reader model that should be used to measure signal in AlphaScreen:"},
			Module[{options, instrument},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					Instrument -> Model[Instrument, PlateReader, "CLARIOstar"],
					Output -> Options
				];
				instrument = Lookup[options, Instrument][Name]
			],
			"CLARIOstar",
			TimeConstraint -> 240
		],
		Example[{Options, AssayPlateModel, "Specify the assay plate model that should be used to aliquot samples:"},
			Module[{options, assayPlateModel},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
					Output -> Options
				];
				assayPlateModel = Lookup[options, AssayPlateModel][Name]
			],
			"AlphaPlate Half Area 96-Well Gray Plate",
			TimeConstraint -> 240
		],
		Example[{Options, AssayPlateModel, "The assay plate model will be automatically resolved:"},
			Module[{options, assayPlateModel},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AssayPlateModel -> Automatic,
					Output -> Options
				];
				assayPlateModel = Lookup[options, AssayPlateModel][Name]
			],
			"AlphaPlate Half Area 96-Well Gray Plate",
			TimeConstraint -> 240
		],
		Example[{Options, AssayPlateModel, "The assay plate model will be automatically selected (half area 96-well plate) so that the assay volume is in the range of plate working volume:"},
			Module[{options, assayPlateModel},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AssayPlateModel -> Automatic,
					AlphaAssayVolume -> 90 Microliter,
					Output -> Options
				];
				assayPlateModel = Lookup[options, AssayPlateModel][Name]
			],
			"AlphaPlate Half Area 96-Well Gray Plate",
			TimeConstraint -> 240
		],
		Example[{Options, AssayPlateModel, "The assay plate model will be automatically selected (384-well plate) so that the assay volume is in the range of plate working volume:"},
			Module[{options, assayPlateModel},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AssayPlateModel -> Automatic,
					AlphaAssayVolume -> 30 Microliter,
					Output -> Options
				];
				assayPlateModel = Lookup[options, AssayPlateModel][Name]
			],
			"AlphaPlate 384-Well Gray Plate",
			TimeConstraint -> 240
		],
		Example[{Options, AssayPlateModel, "The assay plate model will be automatically selected (384-shallow-well plate) so that the assay volume is in the range of plate working volume:"},
			Module[{options, assayPlateModel},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AssayPlateModel -> Automatic,
					AlphaAssayVolume -> 10 Microliter,
					Output -> Options
				];
				assayPlateModel = Lookup[options, AssayPlateModel][Name]
			],
			"AlphaPlate 384-Shallow-Well Gray Plate",
			TimeConstraint -> 240
		],
		Example[{Options, AlphaAssayVolume, "Specify the sample volume in the plate before signal measurement in the plate reader:"},
			Module[{options, alphaAssayVolume},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AlphaAssayVolume -> 50 Microliter,
					Output -> Options
				];
				alphaAssayVolume = Lookup[options, AlphaAssayVolume]
			],
			50 Microliter,
			TimeConstraint -> 240
		],
		Example[{Options, AlphaAssayVolume, "The assay volume will be automatically resolved:"},
			Module[{options, alphaAssayVolume},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AlphaAssayVolume -> Automatic,
					Output -> Options
				];
				alphaAssayVolume = Lookup[options, AlphaAssayVolume]
			],
			EqualP[100 Microliter],
			TimeConstraint -> 240
		],
		Example[{Options, AlphaAssayVolume, "The assay volume will be automatically resolved based on the working volume of assay plate model (half area 96-well plate):"},
			Module[{options, alphaAssayVolume},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AssayPlateModel -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
					AlphaAssayVolume -> Automatic,
					Output -> Options
				];
				alphaAssayVolume = Lookup[options, AlphaAssayVolume]
			],
			100. Microliter,
			TimeConstraint -> 240
		],
		Example[{Options, AlphaAssayVolume, "The assay volume will be automatically resolved based on the working volume of assay plate model (384-well plate):"},
			Module[{options, alphaAssayVolume},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AssayPlateModel -> Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"],
					AlphaAssayVolume -> Automatic,
					Output -> Options
				];
				alphaAssayVolume = Lookup[options, AlphaAssayVolume]
			],
			60. Microliter,
			TimeConstraint -> 240
		],
		Example[{Options, AlphaAssayVolume, "The assay volume will be automatically resolved based on the working volume of assay plate model (384-shallow-well plate):"},
			Module[{options, alphaAssayVolume},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					AssayPlateModel -> Model[Container, Plate, "AlphaPlate 384-Shallow-Well Gray Plate"],
					AlphaAssayVolume -> Automatic,
					Output -> Options
				];
				alphaAssayVolume = Lookup[options, AlphaAssayVolume]
			],
			15. Microliter,
			TimeConstraint -> 240
		],
		Example[{Options, NumberOfReplicates, "Specify number of wells each sample is aliquoted into and read independently:"},
			Module[{options, numberOfReplicates},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					NumberOfReplicates -> 2,
					Output -> Options
				];
				numberOfReplicates = Lookup[options, NumberOfReplicates]
			],
			2,
			TimeConstraint -> 240
		],
		Example[{Options, ReadTemperature, "Request that the assay plate be maintained at a particular temperature in the plate reader during AlphaScreen signal readings:"},
			Module[{options, readTemperature},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					ReadTemperature -> 37 Celsius,
					Output -> Options
				];
				readTemperature = Lookup[options, ReadTemperature]
			],
			37 Celsius,
			TimeConstraint -> 240
		],
		Example[{Options, ReadEquilibrationTime, "Indicate the time for which to allow assay samples to equilibrate with the requested assay temperature. This equilibration will occur after the plate reader chamber reaches the requested ReadTemperature, and before readings are taken:"},
			Module[{options, readEquilibrationTime},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					ReadEquilibrationTime -> 4 Minute,
					Output -> Options
				];
				readEquilibrationTime = Lookup[options, ReadEquilibrationTime]
			],
			4 Minute,
			TimeConstraint -> 240
		],
		Example[{Options, Instrument, "Instrument is automatically set to Model[Instrument, PlateReader, \"id:zGj91a7Ll0Rv\"] if TargetCarbonDioxideLevel/TargetOxygenLevel is set:"},
			Lookup[
				ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID], TargetCarbonDioxideLevel -> 5 * Percent, Output -> Options],
				Instrument
			],
			ObjectP[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]]
		],
		Example[{Options, TargetCarbonDioxideLevel, "TargetCarbonDioxideLevel is automatically set to 5 Percent if sample contains Mammalian cells:"},
			Lookup[
				ExperimentAlphaScreen[Object[Sample, "Test sample with mammalian cells for ExperimentAlphaScreen "<>$SessionUUID], Instrument -> Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"], Output -> Options],
				TargetCarbonDioxideLevel
			],
			5 * Percent
		],
		Example[{Options, PlateReaderMixTime, "Specify PlateReaderMixTime for plate reader mixing:"},
			Module[{options, plateReaderMixTime},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PlateReaderMix -> True,
					PlateReaderMixTime -> 30 Second,
					PlateReaderMixRate -> Automatic,
					PlateReaderMixMode -> Automatic,
					Output -> Options
				];
				plateReaderMixTime = Lookup[options, PlateReaderMixTime]
			],
			30 Second,
			TimeConstraint -> 240
		],
		Example[{Options, PlateReaderMixRate, "Specify PlateReaderMixRate for plate reader mixing:"},
			Module[{options, plateReaderMixRate},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PlateReaderMix -> True,
					PlateReaderMixTime -> Automatic,
					PlateReaderMixRate -> 700 RPM,
					PlateReaderMixMode -> Automatic,
					Output -> Options
				];
				plateReaderMixRate = Lookup[options, PlateReaderMixRate]
			],
			700 RPM,
			TimeConstraint -> 240
		],
		Example[{Options, PlateReaderMixMode, "Specify PlateReaderMixMode for plate reader mixing:"},
			Module[{options, plateReaderMixMode},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PlateReaderMix -> True,
					PlateReaderMixTime -> Automatic,
					PlateReaderMixRate -> Automatic,
					PlateReaderMixMode -> DoubleOrbital,
					Output -> Options
				];
				plateReaderMixMode = Lookup[options, PlateReaderMixMode]
			],
			DoubleOrbital,
			TimeConstraint -> 240
		],
		Example[{Options, PlateReaderMix, "If a mixing is required before plate reader measurement, the relevant parameters can be resolved automatically:"},
			Module[{options, plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PlateReaderMix -> True,
					PlateReaderMixTime -> Automatic,
					PlateReaderMixRate -> Automatic,
					PlateReaderMixMode -> Automatic,
					Output -> Options
				];
				{plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode} = Lookup[options, {PlateReaderMix, PlateReaderMixTime, PlateReaderMixRate, PlateReaderMixMode}]
			],
			{True, 30 Second, 700 RPM, DoubleOrbital},
			TimeConstraint -> 240
		],
		Example[{Options, PlateReaderMix, "If a mixing is not required before plate reader measurement, the relevant parameters can be resolved to Null automatically:"},
			Module[{options, plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PlateReaderMix -> False,
					PlateReaderMixTime -> Automatic,
					PlateReaderMixRate -> Automatic,
					PlateReaderMixMode -> Automatic,
					Output -> Options
				];
				{plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode} = Lookup[options, {PlateReaderMix, PlateReaderMixTime, PlateReaderMixRate, PlateReaderMixMode}]
			],
			{False, Null, Null, Null},
			TimeConstraint -> 240
		],
		Example[{Options, PlateReaderMix, "PlateReaderMix can be resolved automatically, if any of the relevant parameters are specified:"},
			Module[{options, plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PlateReaderMix -> Automatic,
					PlateReaderMixTime -> Automatic,
					PlateReaderMixRate -> Automatic,
					PlateReaderMixMode -> Automatic,
					Output -> Options
				];
				{plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode} = Lookup[options, {PlateReaderMix, PlateReaderMixTime, PlateReaderMixRate, PlateReaderMixMode}]
			],
			{False, Null, Null, Null},
			TimeConstraint -> 240
		],
		Example[{Options, PlateReaderMix, "PlateReaderMix can be resolved automatically, if any of the relevant parameters are specified:"},
			Module[{options, plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PlateReaderMix -> Automatic,
					PlateReaderMixTime -> Null,
					PlateReaderMixRate -> Automatic,
					PlateReaderMixMode -> Automatic,
					Output -> Options
				];
				{plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode} = Lookup[options, {PlateReaderMix, PlateReaderMixTime, PlateReaderMixRate, PlateReaderMixMode}]
			],
			{False, Null, Null, Null},
			TimeConstraint -> 240
		],
		Example[{Options, PlateReaderMix, "PlateReaderMix can be resolved automatically, if any of the relevant parameters are specified:"},
			Module[{options, plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					PlateReaderMix -> Automatic,
					PlateReaderMixTime -> 10 Second,
					PlateReaderMixRate -> Automatic,
					PlateReaderMixMode -> Automatic,
					Output -> Options
				];
				{plateReaderMix, plateReaderMixTime, plateReaderMixRate, plateReaderMixMode} = Lookup[options, {PlateReaderMix, PlateReaderMixTime, PlateReaderMixRate, PlateReaderMixMode}]
			],
			{True, 10 Second, 700 RPM, DoubleOrbital},
			TimeConstraint -> 240
		],
		Example[{Options, Gain, "Specify direct gain value for the AlphaScreen measurement:"},
			Module[{options, gain},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					Gain -> 3600 Microvolt,
					Output -> Options
				];
				gain = Lookup[options, Gain]
			],
			3600 Microvolt,
			TimeConstraint -> 240
		],
		Example[{Options, FocalHeight, "Specify direct focal height value for the AlphaScreen measurement:"},
			Module[{options, focalHeight},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					FocalHeight -> 11 Millimeter,
					Output -> Options
				];
				focalHeight = Lookup[options, FocalHeight]
			],
			11 Millimeter,
			TimeConstraint -> 240
		],
		Example[{Options, FocalHeight, "If not specified, automatically set to Auto:"},
			Module[{options, focalHeight},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					FocalHeight -> Automatic,
					Output -> Options
				];
				focalHeight = Lookup[options, FocalHeight]
			],
			Auto,
			TimeConstraint -> 240
		],
		Example[{Options, SettlingTime, "Specify settling time for the AlphaScreen measurement:"},
			Module[{options, settlingTime},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					SettlingTime -> 0 Millisecond,
					Output -> Options
				];
				settlingTime = Lookup[options, SettlingTime]
			],
			0 Millisecond,
			TimeConstraint -> 240
		],

		Example[{Options, ExcitationTime, "Specify excitation time for the AlphaScreen measurement:"},
			Module[{options, excitationTime},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					ExcitationTime -> 80 Millisecond,
					Output -> Options
				];
				excitationTime = Lookup[options, ExcitationTime]
			],
			80 Millisecond,
			TimeConstraint -> 240
		],
		Example[{Options, DelayTime, "Specify delay time for the AlphaScreen measurement:"},
			Module[{options, delayTime},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					DelayTime -> 120 Millisecond,
					Output -> Options
				];
				delayTime = Lookup[options, DelayTime]
			],
			120 Millisecond,
			TimeConstraint -> 240
		],
		Example[{Options, IntegrationTime, "Specify integration time for the AlphaScreen measurement:"},
			Module[{options, integrationTime},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					IntegrationTime -> 300 Millisecond,
					Output -> Options
				];
				integrationTime = Lookup[options, IntegrationTime]
			],
			300 Millisecond,
			TimeConstraint -> 240
		],
		Example[{Options, ExcitationWavelength, "Specify excitation wavelength for the AlphaScreen measurement:"},
			Module[{options, excitationWavelength},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					ExcitationWavelength -> 680 Nanometer,
					Output -> Options
				];
				excitationWavelength = Lookup[options, ExcitationWavelength]
			],
			680 Nanometer,
			TimeConstraint -> 240
		],
		Example[{Options, EmissionWavelength, "Specify emission wavelength for the AlphaScreen measurement:"},
			Module[{options, emissionWavelength},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					EmissionWavelength -> 615 Nanometer,
					Output -> Options
				];
				emissionWavelength = Lookup[options, EmissionWavelength]
			],
			615 Nanometer,
			TimeConstraint -> 240
		],
		Example[{Options, RetainCover, "Specify if a cover will be retained during plate reader measurement:"},
			Module[{options, retainCover},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					RetainCover -> False,
					Output -> Options
				];
				retainCover = Lookup[options, RetainCover]
			],
			False,
			TimeConstraint -> 240
		],
		Example[{Options, ReadDirection, "Specify the order in which wells should be read during plate reader measurement:"},
			Module[{options, readDirection},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					ReadDirection -> Row,
					Output -> Options
				];
				readDirection = Lookup[options, ReadDirection]
			],
			Row,
			TimeConstraint -> 240
		],
		Example[{Options, MoatSize, "Specify MoatSize for moat:"},
			Module[{options, moatSize},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					MoatWells -> True,
					MoatSize -> 1,
					MoatVolume -> Automatic,
					MoatBuffer -> Automatic,
					Output -> Options
				];
				moatSize = Lookup[options, MoatSize]
			],
			1,
			TimeConstraint -> 240
		],
		Example[{Options, MoatVolume, "Specify MoatVolume for moat:"},
			Module[{options, moatVolume},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					MoatWells -> True,
					MoatSize -> Automatic,
					MoatVolume -> 50 Microliter,
					MoatBuffer -> Automatic,
					Output -> Options
				];
				moatVolume = Lookup[options, MoatVolume]
			],
			50 Microliter,
			TimeConstraint -> 240
		],
		Example[{Options, MoatBuffer, "Specify MoatBuffer for moat:"},
			Module[{options, moatBuffer},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					MoatWells -> True,
					MoatSize -> Automatic,
					MoatVolume -> Automatic,
					MoatBuffer -> Model[Sample, "Milli-Q water"],
					Output -> Options
				];
				moatBuffer = Lookup[options, MoatBuffer]
			],
			ObjectP[Model[Sample]],
			TimeConstraint -> 240
		],
		Example[{Options, MoatWells, "If moat is required for sample preparation, the relevant parameters can be resolved automatically:"},
			Module[{options, moatWells, moatSize, moatVolume, moatBuffer},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					MoatWells -> True,
					MoatSize -> Automatic,
					MoatVolume -> Automatic,
					MoatBuffer -> Automatic,
					Output -> Options
				];
				{moatWells, moatSize, moatVolume, moatBuffer} = Lookup[options, {MoatWells, MoatSize, MoatVolume, MoatBuffer}]
			],
			{True, 1, EqualP[100 Microliter], ObjectP[Model[Sample]]},
			TimeConstraint -> 240
		],
		Example[{Options, MoatWells, "If moat is not required for sample preparation, the relevant parameters can be resolved to Null automatically:"},
			Module[{options, moatWells, moatSize, moatVolume, moatBuffer},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					MoatWells -> False,
					MoatSize -> Automatic,
					MoatVolume -> Automatic,
					MoatBuffer -> Automatic,
					Output -> Options
				];
				{moatWells, moatSize, moatVolume, moatBuffer} = Lookup[options, {MoatWells, MoatSize, MoatVolume, MoatBuffer}]
			],
			{False, Null, Null, Null},
			TimeConstraint -> 240
		],
		Example[{Options, MoatWells, "If moat is left automatic, the relevant parameters can be resolved automatically:"},
			Module[{options, moatWells, moatSize, moatVolume, moatBuffer},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					MoatWells -> Automatic,
					MoatSize -> Automatic,
					MoatVolume -> Automatic,
					MoatBuffer -> Automatic,
					Output -> Options
				];
				{moatWells, moatSize, moatVolume, moatBuffer} = Lookup[options, {MoatWells, MoatSize, MoatVolume, MoatBuffer}]
			],
			{False, Null, Null, Null},
			TimeConstraint -> 240
		],
		Example[{Options, MoatWells, "If moat is left automatic, the relevant parameters can be resolved automatically:"},
			Module[{options, moatWells, moatSize, moatVolume, moatBuffer},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					MoatWells -> Automatic,
					MoatSize -> Null,
					MoatVolume -> Automatic,
					MoatBuffer -> Automatic,
					Output -> Options
				];
				{moatWells, moatSize, moatVolume, moatBuffer} = Lookup[options, {MoatWells, MoatSize, MoatVolume, MoatBuffer}]
			],
			{False, Null, Null, Null},
			TimeConstraint -> 240
		],
		Example[{Options, MoatWells, "If moat is left automatic, the relevant parameters can be resolved automatically:"},
			Module[{options, moatWells, moatSize, moatVolume, moatBuffer},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					MoatWells -> Automatic,
					MoatSize -> 1,
					MoatVolume -> Automatic,
					MoatBuffer -> Automatic,
					Output -> Options
				];
				{moatWells, moatSize, moatVolume, moatBuffer} = Lookup[options, {MoatWells, MoatSize, MoatVolume, MoatBuffer}]
			],
			{True, 1, EqualP[100 Microliter], ObjectP[Model[Sample]]},
			TimeConstraint -> 240
		],
		Example[{Options, SamplesInStorageCondition, "Specify a SamplesInStorageCondition for samples in:"},
			Module[{options, samplesInStorageCondition},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					SamplesInStorageCondition -> Disposal,
					Output -> Options
				];
				samplesInStorageCondition = Lookup[options, SamplesInStorageCondition]
			],
			Disposal,
			TimeConstraint -> 240
		],
		Example[{Options, StoreMeasuredPlates, "Indicate if the assay plate should be stored:"},
			Module[{options, storeMeasuredPlate},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					StoreMeasuredPlates -> True,
					Output -> Options
				];
				storeMeasuredPlate = Lookup[options, StoreMeasuredPlates]
			],
			True,
			TimeConstraint -> 240
		],
		Example[{Options, Template, "Specify a protocol template for AlphaScreen:"},
			Module[{options, template},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					Template -> Object[Protocol, AlphaScreen, "Existing AlphaScreen Protocol" <> $SessionUUID],
					Output -> Options
				];
				template = Lookup[options, Template][Name]
			],
			"Existing AlphaScreen Protocol" <> $SessionUUID,
			TimeConstraint -> 240
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			Module[{options, name},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					Name -> "Test Protocol Name",
					Output -> Options
				];
				name = Lookup[options, Name]
			],
			"Test Protocol Name",
			TimeConstraint -> 240
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			Module[{options, incubationInstrument},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					IncubationInstrument -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
					Output -> Options
				];
				incubationInstrument = Lookup[options, IncubationInstrument]
			],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]]
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the position in the incubate aliquot container that the sample should be moved into:"},
			Module[{options, incubateAliquotDestinationWell},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					IncubateAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"],
					IncubateAliquotDestinationWell -> "A2", Output -> Options];
				incubateAliquotDestinationWell = Lookup[options, IncubateAliquotDestinationWell]
			],
			"A2"
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the position in the centrifuge aliquot container that the sample should be moved into:"},
			Module[{options, centrifugeAliquotDestinationWell},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					CentrifugeAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"],
					CentrifugeAliquotDestinationWell -> "A2",
					Output -> Options];
				centrifugeAliquotDestinationWell = Lookup[options, CentrifugeAliquotDestinationWell]
			],
			"A2"
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates the position in the filter aliquot container that the sample should be moved into:"},
			Module[{options, filterAliquotDestinationWell},
				options = ExperimentAlphaScreen[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
					FilterAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"],
					FilterAliquotDestinationWell -> "A2",
					Output -> Options];
				filterAliquotDestinationWell = Lookup[options, FilterAliquotDestinationWell]
			],
			"A2"
		],
		Example[{Options, TargetConcentrationAnalyte, "The specific analyte to get to the specified target concentration:"},
			Module[{options, targetConcentrationAnalyte},
				options = ExperimentAlphaScreen[Object[Sample, "Test 1M NaCl solution for ExperimentAlphaScreen" <> $SessionUUID],
					TargetConcentration -> 10 * Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Sodium Chloride"],
					AssayVolume -> 100 * Microliter,
					Output -> Options];
				targetConcentrationAnalyte = Lookup[options, TargetConcentrationAnalyte]
			],
			ObjectP[Model[Molecule, "Sodium Chloride"]]
		],

		Example[{Options, DestinationWell, "Indicates the position in the AliquotContainer that we want to move the sample into:"},
			Module[{options, destinationWell},
				options = ExperimentAlphaScreen[Object[Sample, "Test 1M NaCl solution for ExperimentAlphaScreen" <> $SessionUUID],
					AliquotContainer -> Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
					DestinationWell -> "A2",
					Output -> Options];
				destinationWell = Lookup[options, DestinationWell]
			],
			{"A2"}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentAlphaScreen[
				{Model[Sample, "Red Food Dye"], Model[Sample, "Red Food Dye"]},
				PreparedModelContainer -> Model[Container, Plate, "96-well UV-Star Plate"],
				PreparedModelAmount -> 200 Microliter,
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
				{ObjectP[Model[Sample, "Red Food Dye"]]..},
				{ObjectP[Model[Container, Plate, "96-well UV-Star Plate"]]..},
				{EqualP[200 Microliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to create test standards prior to running the experiment:"},
			Module[{options, preparatoryPrimitives},
				options = ExperimentAlphaScreen[
					{"red dye sample", Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID]},
					PreparatoryUnitOperations -> {
						LabelContainer[Label -> "red dye sample", Container -> Model[Container, Vessel, "2mL Tube"]],
						Transfer[Source -> Model[Sample, "Red Food Dye"], Amount -> 200 * Microliter, Destination -> "red dye sample"]
					},
					Output -> Options
				];
				preparatoryPrimitives = Lookup[options, PreparatoryUnitOperations]
			],
			{SamplePreparationP..},
			TimeConstraint -> 240
		],

		(* Resource packets tests *)
		Test["Creates resources for the input samples - combining volumes as needed:",
			Module[{protocol, resourceEntries, samplesInResources},
				protocol = ExperimentAlphaScreen[
					{
						Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
						Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID],
						Object[Sample, "Test sample 3 for ExperimentAlphaScreen" <> $SessionUUID],
						Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID]
					},
					AliquotAmount -> {100 Microliter, 100 Microliter, 100 Microliter, 100 Microliter}
				];

				resourceEntries = Download[protocol, RequiredResources];
				samplesInResources = Download[Cases[resourceEntries, {_, SamplesIn, ___}][[All, 1]], Object];

				{
					MatchQ[samplesInResources[[1]], samplesInResources[[4]]],
					!MatchQ[samplesInResources[[1]], samplesInResources[[2]]],
					Download[samplesInResources[[1]], Amount] == 200 Microliter
				}
			],
			{True..},
			TimeConstraint -> 240
		],
		Test["Expands SamplesIn and the fields index-matched to SamplesIn when replicates are requested:",
			Module[{protocol},
				protocol = ExperimentAlphaScreen[
					{
						Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
						Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID],
						Object[Sample, "Test sample 3 for ExperimentAlphaScreen" <> $SessionUUID]
					},
					AliquotAmount -> {100 Microliter, 100 Microliter, 100 Microliter},
					NumberOfReplicates -> 2
				];
				Download[protocol, SamplesIn][Object]
			],
			{
				ObjectP[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID][Object]],
				ObjectP[Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID][Object]],
				ObjectP[Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID][Object]],
				ObjectP[Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID][Object]],
				ObjectP[Object[Sample, "Test sample 3 for ExperimentAlphaScreen" <> $SessionUUID][Object]],
				ObjectP[Object[Sample, "Test sample 3 for ExperimentAlphaScreen" <> $SessionUUID][Object]]
			},
			TimeConstraint -> 240
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentAlphaScreen[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentAlphaScreen[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentAlphaScreen[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentAlphaScreen[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentAlphaScreen[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentAlphaScreen[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		]
	},
	SetUp :> {
		ClearMemoization[];
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},

	(* un comment this out when Variables works the way we would expect it to *)
	(* Variables :> {$SessionUUID},*)

	SymbolSetUp :> Block[{$DeveloperUpload = True},
		Module[{testBench, testBenchPacket, allPlates, plate1, plate2, plate3, plate4, plate5, plate6, emptyPlate, moreWellPlate1, moreWellSWPlate1, plateModels, plateNames, allVessels, vesselModels, vesselNames, retiredInstrumentPacket, allContainerModels, allContainerPackets, vessel1, vessel2, vessel3, vessel4, vessel5, bottle1, naclSolutionSample, naclSolutionSamplePackets, numberOfInputSamples, sampleNames, samples, samplePackets},

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			ClearDownload[];
			asBackUpCleanup[];

			$CreatedObjects = {};

			testBench = CreateID[Object[Container, Bench]];
			testBenchPacket = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{$Site[AllowedPositions][[1]], $Site},
				Name -> "Test Bench for ExperimentAlphaScreen" <> $SessionUUID,
				ID -> testBench[ID],
				FastTrack -> True,
				Upload -> False
			];

			allPlates = CreateID[ConstantArray[Object[Container, Plate], 9]];
			{plate1, plate2, plate3, plate4, emptyPlate, moreWellPlate1, moreWellSWPlate1, plate5, plate6} = allPlates;
			{plateModels, plateNames} = Transpose[{
				(*1*) {Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID},
				(*2*) {Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], "Test 96-well plate 2 for ExperimentAlphaScreen" <> $SessionUUID},
				(*3*) {Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], "Test 96-well plate 3 for ExperimentAlphaScreen" <> $SessionUUID},
				(*4*) {Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], "Test 96-well plate 4 for ExperimentAlphaScreen" <> $SessionUUID},
				(*5*) {Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], "Empty plate for ExperimentAlphaScreen" <> $SessionUUID},
				(*6*) {Model[Container, Plate, "AlphaPlate 384-Well Gray Plate"], "Test 384-well plate for ExperimentAlphaScreen" <> $SessionUUID},
				(*7*) {Model[Container, Plate, "AlphaPlate 384-Shallow-Well Gray Plate"], "Test 384-shallow-well plate for ExperimentAlphaScreen" <> $SessionUUID},
				(*8*) {Model[Container, Plate, "96-well 2mL Deep Well Plate"], "Test 96-well 2mL deep well plate for ExperimentAlphaScreen" <> $SessionUUID},
				(*9*) {Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], "Test 96-well plate 5 for ExperimentAlphaScreen" <> $SessionUUID}
			}];

			allVessels = CreateID[ConstantArray[Object[Container, Vessel], 6]];
			{vessel1, vessel2, vessel3, vessel4, vessel5, bottle1} = allVessels;
			{vesselModels, vesselNames} = Transpose[{
				(*1*) {Model[Container, Vessel, "2mL Tube"], "Test vessel 1 for ExperimentAlphaScreen" <> $SessionUUID},
				(*2*) {Model[Container, Vessel, "2mL Tube"], "Test vessel 2 for ExperimentAlphaScreen" <> $SessionUUID},
				(*3*) {Model[Container, Vessel, "2mL Tube"], "Test vessel 3 for ExperimentAlphaScreen" <> $SessionUUID},
				(*4*) {Model[Container, Vessel, "2mL Tube"], "Test vessel 4 for ExperimentAlphaScreen" <> $SessionUUID},
				(*5*) {Model[Container, Vessel, "2mL Tube"], "Test vessel 5 for ExperimentAlphaScreen" <> $SessionUUID},
				(*6*) {Model[Container, Vessel, "250mL Glass Bottle"], "Test bottle 1 for ExperimentAlphaScreen" <> $SessionUUID}
			}];

			retiredInstrumentPacket = <|
				Type -> Object[Instrument, PlateReader],
				Model -> Link[Model[Instrument, PlateReader, "CLARIOstar"], Objects],
				Name -> "Test retired plate reader for ExperimentAlphaScreen" <> $SessionUUID,
				Status -> Retired,
				Site -> Link[$Site],
				DeveloperObject -> True|>;

			allContainerModels = Join[plateModels, vesselModels];
			allContainerPackets = UploadSample[
				allContainerModels,
				ConstantArray[{"Bench Top Slot", testBench}, Length[allContainerModels]],
				ID -> Join[allPlates, allVessels][ID],
				Name -> Join[plateNames, vesselNames],
				Cache -> testBenchPacket,
				Upload -> False
			];

			numberOfInputSamples = 10;
			sampleNames = "Test sample " <> ToString[#] <> " for ExperimentAlphaScreen" <> $SessionUUID& /@ Range[numberOfInputSamples];

			(* Creating testing samples: "Test sample 1-6" are 0.2M FITC, "Test sample 7-9" are test oligomer. Test sample 9 is further modified for tests (See later Upload call). Samples in plate3 are for insufficient injection volume test. Samples in plate1 can be used for PreparedPlate option. *)

			samples = CreateID[ConstantArray[Object[Sample], 11]];
			samplePackets = UploadSample[
				Join[ConstantArray[Model[Sample, StockSolution, "0.2M FITC"], numberOfInputSamples], {{{1000 * EmeraldCell / Milliliter, Model[Cell, Mammalian, "id:eGakldJvLvzq"]}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}}],
				{
					{"A1", plate1}, {"A2", plate1}, {"A3", plate1}, {"A4", plate1}, {"A1", plate2}, {"A2", plate2}, {"A1", bottle1}, {"A1", vessel1}, {"A1", plate3}, {"A1", plate5}, {"A1", plate6}
				},
				Name -> Join[sampleNames, {"Test sample with mammalian cells for ExperimentAlphaScreen "<>$SessionUUID}],
				ID -> samples[ID],
				InitialAmount -> Join[
					ConstantArray[200 Microliter, numberOfInputSamples - 4], {200 Milliliter, 1 Milliliter, 100 Microliter, 200 Microliter, 200 Microliter}
				],
				Cache -> allContainerPackets,
				Living -> False,
				Upload -> False
			];

			(* Creating a water testing sample for filter options *)
			naclSolutionSample = CreateID[Object[Sample]];
			naclSolutionSamplePackets = With[{naclSolutionModel = UploadSampleModel["1M NaCl test solution for ExperimentAlphaScreen" <> $SessionUUID,
				Composition -> {{1Molar, Model[Molecule, "Sodium Chloride"]}, {100VolumePercent, Model[Molecule, "Water"]}},
				DefaultStorageCondition -> Model[StorageCondition, "Ambient Storage"],
				Expires -> False,
				State -> Liquid,
				MSDSRequired -> False]
			},
				UploadSample[naclSolutionModel,
					{"A1", bottle1},
					Name -> "Test 1M NaCl solution for ExperimentAlphaScreen" <> $SessionUUID,
					ID -> naclSolutionSample[ID];
					InitialAmount -> 50 Milliliter,
					Cache -> allContainerPackets,
					Upload -> False
				]
			];

			Upload[
				Join[
					testBenchPacket,
					allContainerPackets,
					samplePackets,
					naclSolutionSamplePackets,
					{
						retiredInstrumentPacket,
						<|Object -> samples[[9]], Status -> Discarded|>,
						<|Type -> Object[Protocol, AlphaScreen], Name -> "Existing AlphaScreen Protocol" <> $SessionUUID, Site -> Link[$Site]|>
					}
				]
			]
		]
	],
	SymbolTearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
		asBackUpCleanup[];

		(* Turn lab state warnings back on *)
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];

asBackUpCleanup[] := Module[{namedObjects, lurkers},
	namedObjects = {
		Object[Container, Bench, "Test Bench for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Protocol, AlphaScreen, "Existing AlphaScreen Protocol" <> $SessionUUID],
		Object[Protocol, AlphaScreen, "World's Best AlphaScreen Protocol" <> $SessionUUID],
		Object[Sample, "Test sample 1 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 2 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 3 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 4 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 5 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 6 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 7 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 8 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 9 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample 10 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test 1M NaCl solution for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Sample, "Test sample with mammalian cells for ExperimentAlphaScreen "<>$SessionUUID],
		Object[Container, Plate, "Empty plate for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Plate, "Test 96-well plate 1 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Plate, "Test 96-well plate 2 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Plate, "Test 96-well plate 3 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Plate, "Test 96-well plate 4 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Plate, "Test 96-well plate 5 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Plate, "Test 384-well plate for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Plate, "Test 384-shallow-well plate for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Plate, "Test 96-well 2mL deep well plate for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Vessel, "Test vessel 1 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Vessel, "Test vessel 2 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Vessel, "Test vessel 3 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Vessel, "Test vessel 4 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Vessel, "Test vessel 5 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Container, Vessel, "Test bottle 1 for ExperimentAlphaScreen" <> $SessionUUID],
		Object[Instrument, PlateReader, "Test retired plate reader for ExperimentAlphaScreen" <> $SessionUUID],
		Model[Sample, "1M NaCl test solution for ExperimentAlphaScreen" <> $SessionUUID]
	};
	lurkers = PickList[namedObjects, DatabaseMemberQ[namedObjects], True];
	EraseObject[lurkers, Force -> True, Verbose -> False]
];

(* ::Subsection::Closed:: *)
(*ExperimentAlphaScreenPreview*)
DefineTests[
	ExperimentAlphaScreenPreview,
	{
		Example[{Basic, "No preview is currently available for ExperimentAlphaScreen:"},
			ExperimentAlphaScreenPreview[Object[Sample, "Test sample 1 for ExperimentAlphaScreenPreview" <> $SessionUUID]],
			Null
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed try using ExperimentAlphaScreenOptions:"},
			ExperimentAlphaScreenOptions[Object[Sample, "Test sample 1 for ExperimentAlphaScreenPreview" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ExperimentAlphaScreenPreview" <> $SessionUUID], Verbose -> Failures],
			True
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test Bench for ExperimentAlphaScreenPreview" <> $SessionUUID],
				Object[Container, Plate, "Test plate 1 for ExperimentAlphaScreenPreview" <> $SessionUUID],
				Object[Sample, "Test sample 1 for ExperimentAlphaScreenPreview" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{testBench, testBenchPacket, testPlate, testPlatePackets, testSamplePackets},

			testBench = CreateID[Object[Container, Bench]];
			testBenchPacket = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{"First Floor Slot", Object[Container, Building, "15500 Wells Port Drive"]},
				Name -> "Test Bench for ExperimentAlphaScreenPreview" <> $SessionUUID,
				ID -> testBench[ID],
				FastTrack -> True,
				Upload -> False
			];

			testPlate = CreateID[Object[Container, Plate]];
			testPlatePackets = UploadSample[Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
				{"Bench Top Slot", testBench},
				Name -> "Test plate 1 for ExperimentAlphaScreenPreview" <> $SessionUUID,
				ID -> testPlate[ID],
				Cache -> testBenchPacket,
				Upload -> False
			];

			testSamplePackets = UploadSample[Model[Sample, StockSolution, "0.2M FITC"], {"A1", testPlate},
				Name -> "Test sample 1 for ExperimentAlphaScreenPreview" <> $SessionUUID,
				InitialAmount -> 100 Microliter,
				Cache -> testPlatePackets,
				Upload -> False
			];

			Upload[Flatten[{testBenchPacket, testPlatePackets, testSamplePackets}]]
		]
	),
	SymbolTearDown :> Module[{objs, existingObjs},
		objs = {
			Object[Container, Bench, "Test Bench for ExperimentAlphaScreenPreview" <> $SessionUUID];
			Object[Container, Plate, "Test plate 1 for ExperimentAlphaScreenPreview" <> $SessionUUID],
			Object[Sample, "Test sample 1 for ExperimentAlphaScreenPreview" <> $SessionUUID]
		};
		existingObjs = PickList[objs, DatabaseMemberQ[objs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False]
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentAlphaScreenOptions*)
DefineTests[
	ExperimentAlphaScreenOptions,
	{
		Example[{Basic, "Display the option values which will be used in the experiment:"},
			ExperimentAlphaScreenOptions[Object[Sample, "Test sample 1 for ExperimentAlphaScreenOptions" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic, "Any potential issues with provided inputs/options will be displayed:"},
			Quiet[ExperimentAlphaScreenOptions[Object[Sample, "Test sample 1 for ExperimentAlphaScreenOptions" <> $SessionUUID],
				AssayPlateModel -> Model[Container, Plate, "12-well Tissue Culture Plate"]
			], {Warning::TotalAliquotVolumeTooLarge, Warning::InsufficientVolume}],
			_Grid,
			Messages :> {Error::AlphaScreenInvalidAssayPlate, Warning::AlphaScreenNotBMGPlates, Error::InvalidOption}
		],
		Example[
			{Options, OutputFormat, "If OutputFormat -> List, return a list of options:"},
			ExperimentAlphaScreenOptions[{Object[Sample, "Test sample 1 for ExperimentAlphaScreenOptions" <> $SessionUUID]}, OutputFormat -> List],
			{(_Rule | _RuleDelayed)..}
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test Bench for ExperimentAlphaScreenOptions" <> $SessionUUID],
				Object[Container, Plate, "Test plate 1 for ExperimentAlphaScreenOptions" <> $SessionUUID],
				Object[Sample, "Test sample 1 for ExperimentAlphaScreenOptions" <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{testBench, testBenchPacket, testPlate, testPlatePackets, testSamplePackets},

			testBench = CreateID[Object[Container, Bench]];
			testBenchPacket = UploadSample[
				Model[Container, Bench, "The Bench of Testing"],
				{"First Floor Slot", Object[Container, Building, "15500 Wells Port Drive"]},
				Name -> "Test Bench for ExperimentAlphaScreenOptions" <> $SessionUUID,
				ID -> testBench[ID],
				FastTrack -> True,
				Upload -> False
			];

			testPlate = CreateID[Object[Container, Plate]];
			testPlatePackets = UploadSample[Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"],
				{"Bench Top Slot", testBench},
				Name -> "Test plate 1 for ExperimentAlphaScreenOptions" <> $SessionUUID,
				ID -> testPlate[ID],
				Cache -> testBenchPacket,
				Upload -> False
			];

			testSamplePackets = UploadSample[Model[Sample, StockSolution, "0.2M FITC"], {"A1", testPlate},
				Name -> "Test sample 1 for ExperimentAlphaScreenOptions" <> $SessionUUID,
				InitialAmount -> 100 Microliter,
				Cache -> testPlatePackets,
				Upload -> False
			];

			Upload[Flatten[{testBenchPacket, testPlatePackets, testSamplePackets}]]
		]
	),
	SymbolTearDown :> Module[{objs, existingObjs},
		objs = {
			Object[Container, Bench, "Test Bench for ExperimentAlphaScreenOptions" <> $SessionUUID];
			Object[Container, Plate, "Test plate 1 for ExperimentAlphaScreenOptions" <> $SessionUUID],
			Object[Sample, "Test sample 1 for ExperimentAlphaScreenOptions" <> $SessionUUID]
		};
		existingObjs = PickList[objs, DatabaseMemberQ[objs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False]
	]
];

(* ::Subsection::Closed:: *)
(* ValidExperimentAlphaScreenQ*)

DefineTests[
	ValidExperimentAlphaScreenQ,
	{
		Example[{Basic, "Verify that the experiment can be run without issue:"},
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID]],
			True
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID],
				PlateReaderMix -> False,
				PlateReaderMixTime -> 30 Second
			],
			False
		],
		Example[{Options, OutputFormat, "Return a test summary:"},
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID], OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose messages reporting test passage/failure:"},
			ValidExperimentAlphaScreenQ[Object[Sample, "Test sample 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID], Verbose -> True],
			True
		]
	},
	Stubs :> {
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{allObjs, existingObjs},

			allObjs = {
				Object[Container, Plate, "Test plate 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID],

				Object[Sample, "Test sample 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

		];
		Module[{plate1, platePacket, samples},
			platePacket = <|
				Type -> Object[Container, Plate],
				Model -> Link[Model[Container, Plate, "AlphaPlate Half Area 96-Well Gray Plate"], Objects],
				DeveloperObject -> True,
				Name -> "Test plate 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID
			|>;

			plate1 = Upload[platePacket];

			samples = UploadSample[Model[Sample, StockSolution, "0.2M FITC"], {"A1", plate1},
				Name -> "Test sample 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID,
				InitialAmount -> 100 Microliter
			];
		]
	),
	SymbolTearDown :> Module[{allObjs, existingObjs},

		allObjs = {
			Object[Container, Plate, "Test plate 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID],

			Object[Sample, "Test sample 1 for ValidExperimentAlphaScreenQ" <> $SessionUUID]
		};
		existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False];

	]
];


(* ::Section:: *)
(*End Test Package*)
