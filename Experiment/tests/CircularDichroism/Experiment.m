(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentCircularDichroism : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*CircularDichroism*)


(* ::Subsubsection:: *)
(*ExperimentCircularDichroism*)


DefineTests[ExperimentCircularDichroism,
	{
		Example[{Basic, "Create a circular dichroism protocol for a given sample:"},
			ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol, CircularDichroism]]
		],
		Example[{Basic, "Create a circular dichroism protocol for a given container:"},
			ExperimentCircularDichroism[Object[Container,Plate,"CD Unit Test Prepraed Black Quartz Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID]],
			ObjectP[Object[Protocol, CircularDichroism]]
		],
		Example[{Additional, "Create a simulation for a container input when Output->Simulation:"},
			ExperimentCircularDichroism[Object[Container,Plate,"CD Unit Test Prepraed Black Quartz Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID],Output->Simulation],
			SimulationP
		],
		Example[{Additional, "Input a position on a plate:"},
			ExperimentCircularDichroism[{"A3",Object[Container, Plate, "CD Unit Test 2mL Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID]},Output->Simulation],
			SimulationP
		],
		Example[{Additional, "Input mixture of all kinds of samples:"},
			ExperimentCircularDichroism[{{"A3",Object[Container, Plate, "CD Unit Test 2mL Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID]},Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID]},Output->Simulation],
			SimulationP
		],
		Example[{Additional, "Create a simulation protocol for given samples when Output->Simulation:"},
			ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]
				},
				Output->Simulation
			],
			SimulationP
		],
		Example[
			{Options,SampleLabel,"Specify label for sample:"},
			options=ExperimentCircularDichroism[Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				SampleLabel->{"Test Label1"},Output->Options
			];
			Lookup[options,SampleLabel],
			{"Test Label1"},
			Variables:>{options}
		],
		Example[
			{Options,SampleContainerLabel,"Specify the plate reader that is used for measuring circular dichroism spectroscopy or circular dichroism intensity at specific wavelengths:"},
			options=ExperimentCircularDichroism[Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				SampleContainerLabel->{"Test Label1"},Output->Options
			];
			Lookup[options,SampleContainerLabel],
			{"Test Label1"},
			Variables:>{options}
		],
		Example[
			{Options,AliquotSampleLabel,"Specify the plate reader that is used for measuring circular dichroism spectroscopy or circular dichroism intensity at specific wavelengths:"},
			options=ExperimentCircularDichroism[Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				AliquotSampleLabel->{"Test Label1"},Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"Test Label1"},
			Variables:>{options}
		],
		Example[
			{Options,SamplesOutStorageCondition,"Specify the plate reader that is used for measuring circular dichroism spectroscopy or circular dichroism intensity at specific wavelengths:"},
			options=ExperimentCircularDichroism[Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				SamplesOutStorageCondition->{Disposal},Output->Options
			];
			Lookup[options,SamplesOutStorageCondition],
			{Disposal},
			Variables:>{options}
		],
		Example[
			{Options,Instrument,"Specify the plate reader that is used for measuring circular dichroism spectroscopy or circular dichroism intensity at specific wavelengths:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Instrument->Object[Instrument, PlateReader, "ExperimentCircularDichroism Test Instrument"<>$SessionUUID]
			];
			Download[protocol,Instrument],
			ObjectP[Object[Instrument, PlateReader, "ExperimentCircularDichroism Test Instrument"<>$SessionUUID]],
			Variables:>{protocol}
		],
		Example[
			{Options,PreparedPlate,"Specify if the plate containing the samples for the CircularDichroism experiment has been previously prepared that does not need to run sample preparation steps:"},
			options=ExperimentCircularDichroism[
				{
					Object[Sample,"ExperimentCircularDichroism Test Sample 1 on a prepared black quartz plate"<>$SessionUUID],
					Object[Sample,"ExperimentCircularDichroism Test Sample 2 on a prepared black quartz plate"<>$SessionUUID],
					Object[Sample,"ExperimentCircularDichroism Test Sample 3 on a prepared black quartz plate"<>$SessionUUID],
					Object[Sample,"ExperimentCircularDichroism Test Sample 4 on a prepared black quartz plate"<>$SessionUUID]
				},
				PreparedPlate->True,
				Output->Options
			];
			Lookup[options,PreparedPlate],
			True,
			Variables:>{options}
		],
		Example[
			{Options,RetainCover,"Specify if the plate seal or lid on the assay container is left on during measurement to decrease evaporation. It is strongly recommended not to retain a cover because Circular Dichroism can only read from top:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				RetainCover->False
			];
			Download[protocol,RetainCover],
			False,
			Variables:>{protocol}
		],
		Example[
			{Options,ReadPlate,"Specify the plate that is loaded with input samples then inserted into the CircularDichroism plater reader instrument:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				ReadPlate->Model[Container, Plate, "Hellma Black Quartz Microplate"]
			];
			Download[protocol,ReadPlate],
			ObjectP[Model[Container, Plate, "Hellma Black Quartz Microplate"]],
			Variables:>{protocol}
		],
		Example[
			{Options,ContainerOut,"Specify the container in which the samples in the read plate are transferred into after the experiment:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				ContainerOut->Model[Container, Plate, "96-well 2mL Deep Well Plate"]
			];
			Download[protocol,ContainersOut],
			{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]},
			Variables:>{protocol}
		],
		Example[
			{Options,NitrogenPurge,"Specify if the experiment is run under purge with dry nitrogen gas to avoid condensation of ozone generated by the light source:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				NitrogenPurge->False
			];
			Download[protocol,NitrogenPurge],
			False,
			Variables:>{protocol}
		],
		Example[
			{Options,EmptyAbsorbance,"Specify if a empty well will be scan to check the container's backgound signal at the begining of the experiment.:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				EmptyAbsorbance->False
			];
			Download[protocol,EmptyWells],
			{},
			Variables:>{protocol}
		],
		Example[
			{Options,BlankAbsorbance,"Specify if blank samples are prepared to account for the background signal when reading circular dichroism of the assay samples:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				BlankAbsorbance->False
			];
			Download[protocol,BlankWells],
			{},
			Variables:>{protocol}
		],
		Example[
			{Options,Blanks,"Specify the source used to generate a blank sample whose circular dichroism is subtracted as background from the circular dichroism readings of the input sample:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Blanks->Model[Sample, "Milli-Q water"]
			];
			Download[protocol,Blanks],
			{ObjectP[Model[Sample, "Milli-Q water"]],ObjectP[Model[Sample, "Milli-Q water"]],ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables:>{protocol}
		],
		Example[
			{Options,BlankVolumes,"Specify the volume of the blank that should be transferred out and used for blank measurements. Set BlankVolumes to Null to indicate blanks should be read inside their current containers:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				BlankVolumes->123Microliter
			];
			Download[protocol,BlankVolumes],
			{Quantity[123.`, "Microliters"], Quantity[123.`, "Microliters"],Quantity[123.`, "Microliters"]},
			Variables:>{protocol}
		],
		Example[
			{Options,ReadDirection,"Specify Indicate the plate path the instrument will follow as it measures circular dichroism circular dichroism in each well, for instance reading all wells in a row before continuing on to the next row (Row):"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				ReadDirection->Column
			];
			Download[protocol,ReadDirection],
			Column,
			Variables:>{protocol}
		],
		Example[
			{Options,NumberOfReplicates,"Specify the number of times to repeat circular dichroism reading on each provided sample. If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				NumberOfReplicates->2
			];
			Download[protocol,NumberOfReplicates],
			2,
			Variables:>{protocol}
		],
		Example[
			{Options,MoatSize,"Specify the number of concentric perimeters of wells to leave as empty. Some plates (e.g. Quartz plate) may have higher birefringence in outer wells due to manufacturing, resulting in the circular dichroism data collected for the samples in the outer wells are not and with high noise levels:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				MoatSize->3
			];
			Download[protocol,MoatSize],
			3,
			Variables:>{protocol}
		],
		Example[
			{Options,MoatBuffer,"Specify the sample to use to fill each moat well. If the moat well is intended to be empty, specify this option as Null:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				MoatBuffer->Model[Sample, "Milli-Q water"]
			];
			Download[protocol,MoatBuffer],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{protocol}
		],
		Example[
			{Options,MoatVolume,"Specify the volume to add to to each moat well:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				MoatVolume->222Microliter
			];
			Download[protocol,MoatVolume],
			Quantity[222.`, "Microliters"],
			Variables:>{protocol}
		],
		Example[
			{Options,AverageTime,"Specify the time on data collection for each measurment points. The collected data are averaged for this period of time and export as the result data point for this wavelength:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AverageTime->2Second
			];
			Download[protocol,AverageTime],
			Quantity[2.`, "Seconds"],
			Variables:>{protocol}
		],
		Example[
			{Options,EnantiomericExcessMeasurement,"Specify if the experiment will be used to determined enantiomeric excess of SamplesIn:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				EnantiomericExcessMeasurement->False,
				Output->Options
			];
			Lookup[options,EnantiomericExcessMeasurement],
			False,
			Variables:>{protocol}
		],
		Example[
			{Options,EnantiomericExcessWavelength,"Specify if the wavelength will be used to determined enantiomeric excess of SamplesIn:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				EnantiomericExcessStandards->{
					{
						Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
						Quantity[-100, "Percent"]
					},
					{
						Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
						Quantity[100, "Percent"]
					}
				},
				EnantiomericExcessWavelength->250 Nanometer
			];
			Download[protocol,EnantiomericExcessWavelengths],
			{Quantity[250.`, "Nanometers"]},
			Variables:>{protocol}
		],
		Example[
			{Options,EnantiomericExcessStandards,"Specify Indicate samples with a known EnantiomericExcess values and the corresponding value. Preferrable to have optical pure isomers (with +100% and -100% in enantiomeric excess) and one racemic sample (0% in enantiomeric excess). The blank sample can be used as the racemic sample. Will throw an error message if not enough sample (<=3) is specified as SamplesIn:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				EnantiomericExcessStandards->{
					{
						Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
						Quantity[-100, "Percent"]
					},
					{
						Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
						Quantity[100, "Percent"]
					}
				}
			];
			Download[protocol,{EnantiomericExcessStandards,EnantiomericExcessStandardValues,EnantiomericExcessStandardWells}],
			{
				{
					ObjectP[Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID]],
					ObjectP[Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID]]
				},
				{
					Quantity[-100.`, "Percent"], Quantity[100.`, "Percent"]
				},
				{"C3", "C4"}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,SampleVolume,"Auto set the SampleVolume based on the sample with lowest volume:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test Sample 1 on a prepared UV-Star plate"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test Sample 2 on a prepared UV-Star plate"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test Sample 3 on a prepared UV-Star plate"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test Sample 4 on a prepared UV-Star plate"<>$SessionUUID]
				}
			];
			Round[Download[protocol,SampleVolumes],0.01 Milliliter],
			{
				Quantity[0.17, "Milliliters"],
				Quantity[0.17, "Milliliters"],
				Quantity[0.17, "Milliliters"],
				Quantity[0.17, "Milliliters"]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,SampleVolume,"Specify the volume that is taken from each input sample and aliquoted onto the read plate:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				SampleVolume->188Microliter
			];
			Round[Download[protocol,SampleVolumes],0.001 Milliliter],
			{Quantity[0.188, "Milliliters"], Quantity[0.188, "Milliliters"],Quantity[0.188, "Milliliters"]},
			Variables:>{protocol}
		],
		Example[
			{Options,CalculatingMolarEllipticitySpectrum,"Specify Decide if the data will be transfered to molar ellipticity after the protocol is finished. If True, the Analyte and AnalyteConcentration option will set a single value for each of SamplesIn:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				CalculatingMolarEllipticitySpectrum->False
			];
			Download[protocol,CalculatingMolarEllipticitySpectrum],
			{False, False, False},
			Variables:>{protocol}
		],
		Example[
			{Options,Analyte,"Specify the compound of interest that is present in the given samples, will be used to determine the other settings for the plate reader (e.g. DetectionWavelength) and will be used to caluclate the molar epplicity:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				Analyte->{
					Model[Molecule, "id:vXl9j57PmP5D"],
					Model[Molecule, "id:vXl9j57PmP5D"],
					Model[Molecule, "id:dORYzZJNK955"],
					Model[Molecule, "id:dORYzZJNK955"],
					Model[Molecule, "id:dORYzZJNK955"]
				}
			];
			Download[protocol,Analytes],
			ObjectP /@ {Model[Molecule, "id:vXl9j57PmP5D"], Model[Molecule, "id:vXl9j57PmP5D"], Model[Molecule, "id:dORYzZJNK955"], Model[Molecule, "id:dORYzZJNK955"], Model[Molecule, "id:dORYzZJNK955"]},
			Variables:>{protocol}
		],
		Example[
			{Options,Analyte,"Analyte can be supplied as a Link"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]
				},
				Analyte->{
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID][Composition][[1,2]],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID][Composition][[1,2]]
				}
			];
			Download[protocol,Analytes],
			ObjectP /@ {Model[Molecule, "id:J8AY5jDB0nlE"], Model[Molecule, "id:J8AY5jDB0nlE"]},
			Variables:>{protocol}
		],
		Example[
			{Options,AnalyteConcentrations,"Specify the known concentration of the Analyte for each of the SamplesIn:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				Analyte->{
					Model[Molecule, "id:dORYzZJNK955"],
					Model[Molecule, "id:J8AY5jDB0nlE"],
					Model[Molecule, "id:dORYzZJNK955"],
					Model[Molecule, "id:dORYzZJNK955"],
					Model[Molecule, "id:dORYzZJNK955"]
				},
				AnalyteConcentrations->{
					Quantity[8609.56`, "Micromolar"],
					Quantity[8609.56`, "Micromolar"],
					Quantity[2152.39`, "Micromolar"],
					Quantity[4304.78`, "Micromolar"],
					Quantity[6457.17`, "Micromolar"]
				}
			];
			Download[protocol,AnalyteConcentrations],
			{
				Quantity[8609.56`, "Micromolar"],
				Quantity[8609.56`, "Micromolar"],
				Quantity[2152.39`, "Micromolar"],
				Quantity[4304.78`, "Micromolar"],
				Quantity[6457.17`, "Micromolar"]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,DetectionWavelength,"Specify the specific wavelength(s) which should be used to measure circular dichroism in the samples:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				DetectionWavelength->{Span[200 Nanometer, 500 Nanometer],Span[222 Nanometer, 500 Nanometer], {222 Nanometer, 333 Nanometer,	444 Nanometer}}
			];
			Download[protocol,{MinWavelengths,MaxWavelengths,Wavelengths}],
			{
				{Quantity[200., "Nanometers"], Quantity[222., "Nanometers"],Null},
				{Quantity[500., "Nanometers"], Quantity[500., "Nanometers"],Null},
				{Null, Null, {Quantity[222, "Nanometers"], Quantity[333, "Nanometers"], Quantity[444, "Nanometers"]}}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,StepSize,"Specify This option determines how often the spectrophotometer will record an circular dichroism circular dichroism measurement, if the sample was scanned in a range of wavelength. For example, a step size of 2 nanometer indicates that the spectrophotometer will collect circular dichroism circular dichroism data for every 2 nanometer within the wavelength range:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				StepSize->1Nanometer
			];
			Download[protocol,StepSizes],
			{Quantity[1.`, "Nanometers"], Quantity[1.`, "Nanometers"],Quantity[1.`, "Nanometers"]},
			Variables:>{protocol}
		],
		Example[
			{Options,AliquotAmount,"Specify the amount of a sample that should be transferred from the input samples into aliquots:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AliquotAmount->177Microliter,
				Output->Options
			];
			Round[Lookup[options,AliquotAmount],1Microliter],
			177Microliter,
			Variables:>{options}
		],
		Example[
			{Options,AssayVolume,"Specify the desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AssayVolume->150Microliter,
				Output->Options
			];
			Lookup[options,AssayVolume],
			Quantity[150, "Microliters"],
			Variables:>{options}
		],
		Example[
			{Options,DestinationWell,"Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				DestinationWell->{"F5","F6","F7"},
				Output->Options
			];
			Lookup[options,DestinationWell],
			{"F5","F6","F7"},
			Variables:>{options}
		],
		Test["Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:",
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				DestinationWell->{"F5","F6","F7"}
			];
			Download[protocol,SamplesInWells],
			{"F5","F6","F7"},
			Variables:>{protocol}
		],
		Example[
			{Options,AliquotContainer,"Specify the desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired. This option will resolve to be the length of the SamplesIn * NumberOfReplicates:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AliquotContainer->Model[Container, Plate, "Hellma Black Quartz Microplate"],
				Output->Options
			];
			Lookup[options,AliquotContainer],
			{
				{1, Download[Model[Container, Plate, "Hellma Black Quartz Microplate"], Object]},
				{1, Download[Model[Container, Plate, "Hellma Black Quartz Microplate"], Object]},
				{1, Download[Model[Container, Plate, "Hellma Black Quartz Microplate"], Object]}
			},
			Variables:>{options}
		],
		Example[
			{Options,AliquotPreparation,"Specify the desired scale at which liquid handling used to generate aliquots will occur:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AliquotPreparation->Manual
			];
			Download[protocol,AliquotPreparation],
			Manual,
			Variables:>{protocol}
		],
		Example[
			{Options,ConsolidateAliquots,"Specify if identical aliquots should be prepared in the same container/position:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				ConsolidateAliquots->True
			];
			Download[protocol,ConsolidateAliquots],
			True,
			Variables:>{protocol}
		],
		Example[
			{Options,SamplesInStorageCondition,"Specify the non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				SamplesInStorageCondition->Refrigerator
			];
			Download[protocol,SamplesInStorage],
			{Refrigerator, Refrigerator, Refrigerator},
			Variables:>{protocol}
		],
		Example[{Options,Template,"Indicate that all the same options used for a previous protocol should be used again for the current protocol:"},
			ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				Template->Object[Protocol, CircularDichroism, "Old CircularDichroism Spectroscopy Protocol"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,CircularDichroism]]
		],
		Example[
			{Options,Name,"Specify the name of this protocol:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Name->"Test ExperimentCD Protocol"
			];
			Download[protocol,Name],
			"Test ExperimentCD Protocol",
			Variables:>{protocol},
			SetUp:>{
				If[
					DatabaseMemberQ[Object[Protocol, CircularDichroism, "Test ExperimentCD Protocol"]],
					EraseObject[Object[Protocol, CircularDichroism, "Test ExperimentCD Protocol"],Force->True,Verbose->False]
				]
			}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentCircularDichroism[
				{Model[Sample, "Methanol"], Model[Sample, "Methanol"]},
				PreparedModelContainer -> Model[Container, Plate, "Hellma Black Quartz Microplate"],
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
				{ObjectP[Model[Sample, "Methanol"]]..},
				{ObjectP[Model[Container, Plate, "Hellma Black Quartz Microplate"]]..},
				{EqualP[200 Microliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[
			{Options,PreparatoryUnitOperations,"Use PreparatoryUnitOperations to prepare the samples:"},
			ExperimentCircularDichroism["CD Sample 1",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "Sample Plate 1",
						Container -> Model[Container, Plate, "Hellma Black Quartz Microplate"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol"],
						Amount -> 200 Microliter,
						Destination -> "Sample Plate 1",
						DestinationLabel -> "CD Sample 1"]
				}
			],
			ObjectP[Object[Protocol,CircularDichroism]]
		],
		Example[
			{Options,Incubate,"Specify Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Incubate->True,
				Output->Options
			];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[
			{Options,IncubationTemperature,"Specify Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				IncubationTemperature->50 Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			50 Celsius,
			Variables:>{options}
		],
		Example[
			{Options,IncubationTime,"Specify Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				IncubationTime->10 Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			10 Minute,
			Variables:>{options}
		],
		Example[
			{Options,Mix,"Specify Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Mix->True,
				Output->Options
			];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MixType,"Specify Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				MixType->Vortex,
				Output->Options
			];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options}
		],
		Example[
			{Options,MixUntilDissolved,"Specify Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute. Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				MixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MaxIncubationTime,"Specify Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				MaxIncubationTime->11Minute,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			11Minute,
			Variables:>{options}
		],
		Example[
			{Options,IncubationInstrument,"Specify the instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"]],
			Variables:>{options}
		],
		Example[
			{Options,AnnealingTime,"Specify Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AnnealingTime->12Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			12Minute,
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquotContainer,"Specify the desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				IncubateAliquotContainer->Model[Container, Plate, "96-well UV-Star Plate"],
				Output->Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container, Plate, "96-well UV-Star Plate"]]},
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquotDestinationWell,"Specify the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				IncubateAliquotContainer->Model[Container, Plate, "96-well UV-Star Plate"],
				IncubateAliquotDestinationWell->{"A1","B1","C1"},
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			{"A1","B1","C1"},
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				IncubateAliquot->200Microliter,
				Output->Options
			];
			Round[Lookup[options,IncubateAliquot],1Microliter],
			200Microliter,
			Variables:>{options}
		],
		Example[
			{Options,Centrifuge,"Specify Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Centrifuge->True,
				Output->Options
			];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options},
			Messages:>{Warning::SampleStowaways}
		],
		Example[
			{Options,CentrifugeInstrument,"Specify the centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],
				CentrifugeAliquot -> 200 Microliter,
				Output->Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeIntensity,"Specify the rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				CentrifugeIntensity->1000RPM,
				Output->Options
			];
			Lookup[options,CentrifugeIntensity],
			1000RPM,
			Variables:>{options},
			Messages:>{Warning::SampleStowaways}
		],
		Example[
			{Options,CentrifugeTime,"Specify the amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				CentrifugeTime->13Minute,
				Output->Options
			];
			Lookup[options,CentrifugeTime],
			13Minute,
			Variables:>{options},
			Messages:>{Warning::SampleStowaways}
		],
		Example[
			{Options,CentrifugeTemperature,"Specify the temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				CentrifugeTemperature->40Celsius,
				Output->Options
			];
			Lookup[options,CentrifugeTemperature],
			40Celsius,
			Variables:>{options},
			Messages:>{Warning::SampleStowaways}
		],
		Example[
			{Options,CentrifugeAliquotContainer,"Specify the desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				CentrifugeAliquotContainer->Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output->Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeAliquotDestinationWell,"Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID]},
				CentrifugeAliquotDestinationWell->{"A1"},
				Output->Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[
			{Options,CentrifugeAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				CentrifugeAliquot->200Microliter,
				Output->Options
			];
			Round[Lookup[options,CentrifugeAliquot],1Microliter],
			200Microliter,
			Variables:>{options}
		],
		Example[
			{Options,Filtration,"Specify Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Filtration->True,
				Output->Options
			];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[
			{Options,FiltrationType,"Specify the type of filtration method that should be used to perform the filtration:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FiltrationType->Syringe,
				Output->Options
			];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[
			{Options,FilterInstrument,"Specify the instrument that should be used to perform the filtration:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterInstrument->Model[Instrument,VacuumPump,"Rocker 300 for Filtration, Non-sterile"],
				Output->Options
			];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,VacuumPump,"Rocker 300 for Filtration, Non-sterile"]],
			Variables:>{options}
		],
		Example[
			{Options,Filter,"Specify the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Filtration -> True,
				Filter -> Model[Container, Vessel, Filter, "id:6V0npvmeAX81"],
				Output->Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Container, Vessel, Filter, "id:6V0npvmeAX81"]],
			Variables:>{options}
		],
		Example[
			{Options,FilterMaterial,"Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterMaterial->PES,
				Output->Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		Example[
			{Options,PrefilterMaterial,"Specify the material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				PrefilterMaterial->Null,
				Output->Options
			];
			Lookup[options,PrefilterMaterial],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,FilterPoreSize,"Specify the pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Filtration -> True, FilterPoreSize -> 0.22 Micrometer,
				Output->Options
			];
			Lookup[options,FilterPoreSize],
			0.22 Micrometer,
			Variables:>{options}
		],
		Example[
			{Options,PrefilterPoreSize,"Specify the pore size of the filter; all particles larger than this should be removed during the filtration:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				PrefilterPoreSize->Null,
				Output->Options
			];
			Lookup[options,PrefilterPoreSize],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,FilterSyringe,"Specify the syringe used to force that sample through a filter:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output->Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options}
		],
		Example[
			{Options,FilterHousing,"Specify the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterHousing->Null,
				Filtration -> True,
				Output->Options
			];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[
			{Options,FilterIntensity,"Specify the rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterIntensity->1000 RPM,
				Output->Options
			];
			Lookup[options,FilterIntensity],
			1000 RPM,
			Variables:>{options}
		],
		Example[
			{Options,FilterTime,"Specify the amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterTime->9Minute,
				Output->Options
			];
			Lookup[options,FilterTime],
			9Minute,
			Variables:>{options}
		],
		Example[
			{Options,FilterTemperature,"Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterTemperature->35Celsius,
				Output->Options
			];
			Lookup[options,FilterTemperature],
			35Celsius,
			Variables:>{options}
		],
		Example[
			{Options,FilterContainerOut,"Specify the desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterContainerOut->Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output->Options
			];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquotDestinationWell,"Specify the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID]},
				FilterAliquotDestinationWell->{"A1"},
				Output->Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquotContainer,"Specify the desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterAliquotContainer->Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Output->Options
			];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables:>{options}
		],
		Example[
			{Options,FilterAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterAliquot->200Microliter,
				Output->Options
			];
			Round[Lookup[options,FilterAliquot],1Microliter],
			200Microliter,
			Variables:>{options}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[
			{Options,FilterSterile,"Specify Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				FilterSterile->True,
				Output->Options
			];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],*)
		Example[
			{Options,Aliquot,"Specify Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment. Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times. Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				Aliquot->True,
				Output->Options
			];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[
			{Options,TargetConcentration,"Specify the desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				TargetConcentration->0.0001Molar,
				Output->Options
			];
			Lookup[options,TargetConcentration],
			0.0001Molar,
			Variables:>{options},
			Messages:>{Warning::AmbiguousAnalyte}
		],
		Example[
			{Options,TargetConcentrationAnalyte,"Specify the substance whose final concentration is attained with the TargetConcentration option:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				TargetConcentration -> {
					0.5 Milligram/Milliliter,
					0.5 Milligram/Milliliter,
					0.5 Milligram/Milliliter
				},
				TargetConcentrationAnalyte -> {
					Model[Molecule, "id:dORYzZJNK955"],
					Model[Molecule, "id:J8AY5jDB0nlE"],
					Model[Molecule, "id:J8AY5jDB0nlE"]
				},
				Output->Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			{ObjectP[Model[Molecule, "id:dORYzZJNK955"]],ObjectP[Model[Molecule, "id:J8AY5jDB0nlE"]],ObjectP[Model[Molecule, "id:J8AY5jDB0nlE"]]},
			Variables:>{options}
		],
		Example[
			{Options,AssayVolume,"Specify the desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AssayVolume->250Microliter,
				Output->Options
			];
			Lookup[options,AssayVolume],
			250Microliter,
			Variables:>{options}
		],
		Example[
			{Options,ConcentratedBuffer,"Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 100*Microliter,
				AssayVolume -> 200*Microliter,
				Output->Options
			];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables:>{options}
		],
		Example[
			{Options,BufferDilutionFactor,"Specify the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 100*Microliter,
				AssayVolume -> 200*Microliter,
				Output->Options
			];
			Lookup[options,BufferDilutionFactor],
			10,
			Variables:>{options}
		],
		Example[
			{Options,BufferDiluent,"Specify the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				BufferDiluent->Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount -> 100*Microliter,
				AssayVolume -> 200*Microliter,
				Output->Options
			];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,AssayBuffer,"Specify the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter,
				Output->Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables:>{options}
		],
		Example[
			{Options,AliquotSampleStorageCondition,"Specify the non-default conditions under which any aliquot samples generated by this experiment should be stored after the options is completed:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				AliquotSampleStorageCondition->Disposal,
				Output->Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			Disposal,
			Variables:>{options}
		],
		
		Example[
			{Options,ConsolidateAliquots,"Specify Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				ConsolidateAliquots->True,
				Output->Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[
			{Options,MeasureWeight,"Specify Indicates if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				MeasureWeight->True
			];
			Download[protocol,MeasureWeight],
			True,
			Variables:>{protocol}
		],
		Example[
			{Options,MeasureVolume,"Specify Indicates if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				MeasureVolume->True
			];
			Download[protocol,MeasureVolume],
			True,
			Variables:>{protocol}
		],
		Example[
			{Options,ImageSample,"Specify Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				ImageSample->False
			];
			Download[protocol,ImageSample],
			False,
			Variables:>{protocol}
		],
		(* == Messages == *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCircularDichroism[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCircularDichroism[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCircularDichroism[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCircularDichroism[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentCircularDichroism[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentCircularDichroism[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages, "DiscardedSamples", "Discarded samples cannot be used:"},
			ExperimentCircularDichroism[Object[Sample,"ExperimentCircularDichroism Discarded Sample for Test"<>$SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages, "IncompatibleInstrumentForCircularDichroism", "Instrument specified can measure circular dichroism:"},
			ExperimentCircularDichroism[Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				Instrument -> Object[Instrument, PlateReader, "id:qdkmxz0A8D70"]
				],
			$Failed,
			Messages:>{
				Error::IncompatibleInstrumentForCircularDichroism,
				Error::InvalidOption
			}
		],
		Example[{Messages, "IncompatibleReadPlateForCircularDichroism", "Readplate specified can measure circular dichroism:"},
			ExperimentCircularDichroism[Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				ReadPlate ->Model[Container,Plate,Irregular,"id:9RdZXv1nGK3j"]
				],
			$Failed,
			Messages:>{
				Error::IncompatibleReadPlateForCircularDichroism,
				Error::CircularDichroismTooManySamples,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"CircularDichroismQuartzPlateCannotRetainCover","If we using a quartz plate as the read plate, RetainCover cannot be true:"},
			protocol=ExperimentCircularDichroism[{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID], Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				RetainCover->True
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismQuartzPlateCannotRetainCover,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismDuplicateDestinationWell","DestinationWell can not be same:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample,"ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]
				},
				DestinationWell -> {"C3", "C3", "C4"}
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismDuplicateDestinationWell,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismInvalidDestinationWellLength","DestinationWell should have same length with total sample we are gonna measure (including NumberOfReplicates):"},
			protocol=ExperimentCircularDichroism[{
				Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
				Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				NumberOfReplicates -> 2, DestinationWell -> {"C3", "C4", "C5"},SampleVolume -> 100 Microliter
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismInvalidDestinationWellLength,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismContainerOutStorageConditionMismatch","ContainrOut can only be Null if all samples are going to be disposed after the experiment:"},
			protocol=ExperimentCircularDichroism[{Object[Sample,
				"ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
				Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID]},
				SamplesOutStorageCondition -> {Disposal, Disposal, Disposal},
				ContainerOut -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
			$Failed,
			Messages:>{
				Error::CircularDichroismContainerOutStorageConditionMismatch,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismNeedMoreEnatiomericExcessStandards","Need at least two EnantiomericExcessStandards:"},
			protocol=ExperimentCircularDichroism[{
				Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
				Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
				Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
				Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
				Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]},
				EnantiomericExcessStandards -> {
					{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Quantity[-100, "Percent"]}
				}
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismNeedMoreEnatiomericExcessStandards,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismUnknownEnatiomericExcessStandards","EnantiomericExcessStandards should be one of the SamplesIn or specified in PreparatoryUnitOperations:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				EnantiomericExcessStandards -> {
					{Model[Sample, "Milli-Q water"], Quantity[-100, "Percent"]},
					{Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID], Quantity[100, "Percent"]}
				}
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismUnknownEnatiomericExcessStandards,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismNeedMoreSamplesForEnantiomericExcessMeasurement","EnantiomericExcessStandards should be one of the SamplesIn or specified in PreparatoryUnitOperations:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID]
				},
				EnantiomericExcessMeasurement -> True,
				EnantiomericExcessStandards -> {
					{Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID], Quantity[-100, "Percent"]},
					{Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],	Quantity[100, "Percent"]}
				}
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismNeedMoreSamplesForEnantiomericExcessMeasurement,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismInvalidDetectionWavelength","EnantiomericExcessStandards should be one of the SamplesIn or specified in PreparatoryUnitOperations:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID]
				},
				DetectionWavelength -> 500 Nanometer ;; 200 Nanometer
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismInvalidDetectionWavelength,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismDetectionWavelengthIncompatibleForReadPlate","Use quartz plate for low wavelength detection:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID]
				},
				DetectionWavelength -> 200 Nanometer ;; 300 Nanometer,
				ReadPlate -> Model[Container, Plate, "id:6V0npvK611zG"]
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismDetectionWavelengthIncompatibleForReadPlate,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDirchroismQuartzPlateNeedMoat","If using quartz plate as the Readplate, moatsize should be larger than or equals 2:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID]
				},
				DetectionWavelength -> 200 Nanometer ;; 300 Nanometer,
				ReadPlate -> Model[Container, Plate, "Hellma Black Quartz Microplate"],
				MoatSize -> 0
			],
			$Failed,
			Messages:>{
				Error::CircularDirchroismQuartzPlateNeedMoat,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismSampleVolumeNotValid","Sample should have enougth volume for this experiment:"},
			protocol=ExperimentCircularDichroism[
				Object[Sample, "ExperimentCircularDichroism Test Sample 3 (10 uL)"<>$SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismSampleVolumeNotValid,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismTooManySamples","One readplate should have enough wells to incorporate all the sample with replicates, blank wells and the well for the empty well:"},
			protocol=ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				NumberOfReplicates -> 10,
				SampleVolume -> {100 Microliter, 110 Microliter, 130 Microliter, 140 Microliter, 150 Microliter},
				BlankVolumes -> {100 Microliter, 110 Microliter, 130 Microliter, 140 Microliter, 150 Microliter},
				EmptyAbsorbance -> True
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismTooManySamples,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismUnNeededBlankOption","If BlankAbsorbance -> False, the blank related options can only be Null:"},
			protocol=ExperimentCircularDichroism[
				{

					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				NitrogenPurge -> False,
				EmptyAbsorbance -> True,
				BlankAbsorbance -> False,
				Blanks -> {
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				BlankVolumes -> {200. Microliter, 123 Microliter, 232 Microliter},
				ReadDirection -> Column, AverageTime -> 2 Second
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismUnNeededBlankOption,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		Example[
			{Messages,"CircularDichroismRequiredBlankOption","If BlankAbsorbance -> True, the blank related options cannot be Null:"},
			protocol=ExperimentCircularDichroism[
				{

					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				NitrogenPurge -> False,
				EmptyAbsorbance -> True,
				BlankAbsorbance -> True,
				Blanks -> {
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				BlankVolumes -> Null,
				ReadDirection -> Column, AverageTime -> 2 Second
			],
			$Failed,
			Messages:>{
				Error::CircularDichroismRequiredBlankOption,
				Error::InvalidOption
			},
			Variables:>{protocol}
		],
		(* Warnings *)
		Example[
			{Messages,"NeedConcentrationForMolarEllipticity","If calculate molar ellipticity, the analyte concentration needs to be specified:"},
			ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				CalculatingMolarEllipticitySpectrum -> True,
				AnalyteConcentrations -> Null
			],
			ObjectP[Object[Protocol, CircularDichroism]],
			Messages:>{Warning::NeedConcentrationForMolarEllipticity}
		],
		Example[
			{Messages,"CircularDirchroismUnknownAnalytes","The specified analyte should be in sample's composition:"},
			ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				CalculatingMolarEllipticitySpectrum -> True,
				Analyte -> {
					Model[Molecule, "id:J8AY5jDB0nlE"],
					Model[Molecule, "id:vXl9j57PmP5D"],
					Model[Molecule, "id:xRO9n3BPmP3q"]
				},
				AnalyteConcentrations -> {6457.17 Micromolar, 1.3 Molar, 1.2 Molar}
			],
			ObjectP[Object[Protocol, CircularDichroism]],
			Messages:>{Warning::CircularDirchroismUnknownAnalytes}
		],
		Example[
			{Messages,"CircularDichroismEnantiomericExcessWavelengthsNotCovered","The specified analyte should be in sample's composition:"},
			ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				DetectionWavelength ->200 Nanometer ;; 300 Nanometer,
				EnantiomericExcessWavelength -> {301 Nanometer}
			],
			ObjectP[Object[Protocol, CircularDichroism]],
			Messages:>{Warning::CircularDichroismEnantiomericExcessWavelengthsNotCovered}
		],
		Example[
			{Messages,"CircularDichroismInconsistentAnalyteConcentration","The specified AnalyteConcentaion are consistent with what are calculated from sample's composition:"},
			ExperimentCircularDichroism[
				{
					Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
					Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID]
				},
				CalculatingMolarEllipticitySpectrum -> True,
				Analyte -> {
					Model[Molecule, "id:J8AY5jDB0nlE"],
					Model[Molecule, "id:J8AY5jDB0nlE"],
					Model[Molecule, "id:J8AY5jDB0nlE"]
				},
				AnalyteConcentrations -> {6457.17 Micromolar, 1.3 Molar, 1.2 Molar}
			],
			ObjectP[Object[Protocol, CircularDichroism]],
			Messages:>{Warning::CircularDichroismInconsistentAnalyteConcentration}
		]


	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		circularDichroismTestObjectsCleanup[];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5,testInstrument,
					sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
					sample13, sample14, sample15, sample16, sample17, plateSamples, allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"CD Unit Test bench for ExperimentCircularDichroism tests"<>$SessionUUID,DeveloperObject->True|>];

				(*Build Test Containers*)
				{
					(*1*)container,
					(*2*)container2,
					(*3*)container3,
					(*4*)container4,
					(*5*)container5
				}=UploadSample[
					{
						(*1*)Model[Container, Plate, "96-well 2mL Deep Well Plate"], (*"id:KBL5DvwJ0q4k"*)
						(*2*)Model[Container, Plate, "Hellma Black Quartz Microplate"],
						(*3*)Model[Container, Plate, "96-well UV-Star Plate"], (*"id:n0k9mGzRaaBn"*)
						(*4*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*5*)Model[Container, Plate, "96-well 2mL Deep Well Plate"](*"id:L8kPEjkmLbvW"*)
					},
					{
						(*1*){"Work Surface",fakeBench},
						(*2*){"Work Surface",fakeBench},
						(*3*){"Work Surface",fakeBench},
						(*4*){"Work Surface",fakeBench},
						(*5*){"Work Surface",fakeBench}
					},
					Name->{
						(*1*)"CD Unit Test 2mL Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID,
						(*2*)"CD Unit Test Prepraed Black Quartz Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID,
						(*3*)"CD Unit Test UV-Star Plate 2 (Prepared Plate) for ExperimentCircularDichroism tests"<>$SessionUUID,
						(*4*)"CD Unit Test Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID,
						(*5*)"CD Unit Test Plate 2 for ExperimentCircularDichroism tests"<>$SessionUUID
					}
				];

				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sample11,
					sample12,
					sample13,
					sample14,
					sample15,
					sample16,
					sample17
				}=UploadSample[
					{
						(*1*)Model[Sample,"Milli-Q water"], (*Discarded sample on a 96-well 2mL Deep Well Plate*)
						(*2*)Model[Sample, "(-)- CSA Aqueous Solution (2 gm/mL)"], (*Regular 1.5 Microliter 64 Millimolar (+)-CSA aqueous solution on a 96-well 2mL Deep Well Plate*)
						(*3*)Model[Sample, "(+)- CSA Aqueous Solution (2 gm/mL)"], (*Regular 1.5 Milliliter sample on a 96-well 2mL Deep Well Plate*)
						(*4*)Model[Sample,"Milli-Q water"], (*Regular 10 Microliter sample on a 96-well 2mL Deep Well Plate*)
						(*5*)Model[Sample,"Milli-Q water"],(*Sample on a prepared black quartz plate on A1 well, used to test Moat option*)
						(*6*)Model[Sample,"Milli-Q water"],(*Sample on a prepared black quartz plate on C4 well*)
						(*7*)Model[Sample, "(+)- CSA Aqueous Solution (2 gm/mL)"],(*Sample on a prepared black quartz plate on C5 well*)
						(*8*)Model[Sample, "(-)- CSA Aqueous Solution (2 gm/mL)"],(*Sample on a prepared black quartz plate on D4 well*)
						(*9*)Model[Sample,"Milli-Q water"],(*Sample on a prepared UV-Star plate on A1 well, used to test Moat option*)
						(*10*)Model[Sample,"Milli-Q water"],(*Sample on a prepared UV-Star plate on C4 well*)
						(*11*)Model[Sample, "Leucine Enkephalin (Oligomer)"],(*Sample on a prepared UV-Star plate on C5 well*)
						(*12*)Model[Sample, "ACTH 18-39"],(*Sample on a prepared UV-Star plate on D4 well*)
						(*13*)Model[Sample, "75/25 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],(*"(1S)-(+)-10-Camphorsulfonic acid" on a 96-Well deep well plate on A1 well, used to test Moat option*)
						(*14*)Model[Sample, "50/50 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],(*"(1R)-(-)-10-camphorsulfonic acid" on a 96-Well deep well plate on C4 well*)
						(*15*)Model[Sample, "25/75 (+/-)- CSA Aqueous Solution (2 gm/mL), mixture of enantiomers"],(*Sample on a 96-Well deep well plate on C5 well*)
						(*16*)Model[Sample, "ACTH 18-39"],(*Sample on a 96-Well deep well plate on D4 well*)
						(*17*)Model[Sample,"Milli-Q water"](*Sample on a 96-Well deep well plate on A2 well, Model less*)

					},
					{
						(*1*){"A1",container},
						(*2*){"A2",container},
						(*3*){"A3",container},
						(*4*){"A4",container},
						(*5*){"A1",container2},
						(*6*){"C4",container2},
						(*7*){"C5",container2},
						(*8*){"D4",container2},
						(*9*){"A1",container3},
						(*10*){"C4",container3},
						(*11*){"C5",container3},
						(*12*){"D4",container3},
						(*13*){"A1",container4},
						(*14*){"C4",container4},
						(*15*){"C5",container4},
						(*16*){"D4",container4},
						(*17*){"A2",container4}
					},
					InitialAmount->{
						(*1*)200*Microliter,
						(*2*)1500*Microliter,
						(*3*)1500*Microliter,
						(*4*)10*Microliter,
						(*5*)200*Microliter,
						(*6*)190*Microliter,
						(*7*)180*Microliter,
						(*8*)170*Microliter,
						(*9*)200*Microliter,
						(*10*)190*Microliter,
						(*11*)180*Microliter,
						(*12*)170*Microliter,
						(*13*)1500*Microliter,
						(*14*)1500*Microliter,
						(*15*)1500*Microliter,
						(*16*)170*Microliter,
						(*17*)200*Microliter
					},
					Name->{
						(*1*)"ExperimentCircularDichroism Discarded Sample for Test"<>$SessionUUID,
						(*2*)"ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID,
						(*3*)"ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID,
						(*4*)"ExperimentCircularDichroism Test Sample 3 (10 uL)"<>$SessionUUID,
						(*5*)"ExperimentCircularDichroism Test Sample 1 on a prepared black quartz plate"<>$SessionUUID,
						(*6*)"ExperimentCircularDichroism Test Sample 2 on a prepared black quartz plate"<>$SessionUUID,
						(*7*)"ExperimentCircularDichroism Test Sample 3 on a prepared black quartz plate"<>$SessionUUID,
						(*8*)"ExperimentCircularDichroism Test Sample 4 on a prepared black quartz plate"<>$SessionUUID,
						(*9*)"ExperimentCircularDichroism Test Sample 1 on a prepared UV-Star plate"<>$SessionUUID,
						(*10*)"ExperimentCircularDichroism Test Sample 2 on a prepared UV-Star plate"<>$SessionUUID,
						(*11*)"ExperimentCircularDichroism Test Sample 3 on a prepared UV-Star plate"<>$SessionUUID,
						(*12*)"ExperimentCircularDichroism Test Sample 4 on a prepared UV-Star plate"<>$SessionUUID,
						(*13*)"ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID,
						(*14*)"ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID,
						(*15*)"ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID,
						(*16*)"ExperimentCircularDichroism Test Sample 4 on a 96-well deep plate"<>$SessionUUID,
						(*17*)"ExperimentCircularDichroism Test No Model Sample 5 on a 96-well deep plate"<>$SessionUUID
					},
					StorageCondition->Model[StorageCondition, "id:vXl9j57YlZ5N"]
				];


				plateSamples=UploadSample[
					ConstantArray[Model[Sample, "ACTH 18-39"],32],
					{#,container5}&/@Take[Flatten[AllWells[]], 32],
					InitialAmount->ConstantArray[200 Microliter,32]
				];


				allObjs = Join[
					{
						container, container2, container3, container4, container5,
						sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
						sample13,sample14,sample15, sample16, sample17
					},
					plateSamples
				];
				
				testInstrument=Upload[
					<|
						Type -> Object[Instrument, PlateReader],
						Name -> "ExperimentCircularDichroism Test Instrument"<>$SessionUUID,
						Model -> Link[Model[Instrument, PlateReader, "id:mnk9jORmGjEw"], Objects],
						Container -> Link[Object[Container, Shelf, "id:P5ZnEj4PAnrL"], Contents, 2],
						Cost -> Quantity[143306., "USDollars"],
						DateInstalled -> DateObject[{2021, 2, 6, 0, 0, 0.}, "Instant", "Gregorian", -7.],
						DatePurchased -> DateObject[{2020, 7, 2, 0, 0, 0.}, "Instant", "Gregorian", -7.],
						ImageFile -> Link[Object[EmeraldCloudFile, "id:01G6nvwBxqBY"]],
						Position -> "Slot 3",
						ProgramFilePath -> "C:\\CDReader\\",
						Site -> Link[$Site],
						Software -> "CDReader",
						Status -> Available,
						Replace[InstrumentSoftware]->{
							{VISASharedComponente, "5.12"},
							{CDReader, "2.5.6.1.0.43"},
							{ZurichInstrumentsLabOne, "20.07.2701"},
							{AndorDriverPack3, "3.14.30031.0"},
							{AndorDriverPack2, "2.103.30031.0"}
						},
						Replace[SerialNumbers] -> {{"Instrument", "0103"}},
						DeveloperObject -> True
					|>
				];
				

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, CircularDichroism],
						Name -> "Old CircularDichroism Spectroscopy Protocol"<>$SessionUUID,
						ResolvedOptions -> {
							Instrument -> Object[Instrument, PlateReader, "ExperimentCircularDichroism Test Instrument"<>$SessionUUID],
							NumberOfReplicates -> Null,
							BlankAbsorbance -> True,
							Blanks -> Model[Sample, "Milli-Q water"],
							BlankVolumes -> 200*Microliter,
							Confirm -> False,
							ImageSample -> False,
							Name -> Null,
							Template -> Null
						},
						UnresolvedOptions -> {},
						DeveloperObject -> True
					|>,
					(* test on a model-less sample *)
					<|Object -> sample17, Model -> Null|>
				}]];

				UploadSampleStatus[sample, Discarded, FastTrack -> True]
			]
		]
	),
	SymbolTearDown :>(Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
		circularDichroismTestObjectsCleanup[];
	]),
	Stubs:> {
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection:: *)
(*circularDichroismTestObjectsCleanup*)


circularDichroismTestObjectsCleanup[]:=Module[
	{allObjs, existingObjs},

	allObjs = {
		Object[Container, Bench, "CD Unit Test bench for ExperimentCircularDichroism tests"<>$SessionUUID],
		Object[Container, Plate, "CD Unit Test 2mL Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID],
		Object[Container, Plate, "CD Unit Test Prepraed Black Quartz Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID],
		Object[Container, Plate, "CD Unit Test UV-Star Plate 2 (Prepared Plate) for ExperimentCircularDichroism tests"<>$SessionUUID],
		Object[Container, Plate, "CD Unit Test Plate 1 for ExperimentCircularDichroism tests"<>$SessionUUID],
		Object[Container, Plate, "CD Unit Test Plate 2 for ExperimentCircularDichroism tests"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Discarded Sample for Test"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test (-) CSA Sample"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test (+) CSA Sample"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 3 (10 uL)"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 1 on a prepared black quartz plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 2 on a prepared black quartz plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 3 on a prepared black quartz plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 4 on a prepared black quartz plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 1 on a prepared UV-Star plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 2 on a prepared UV-Star plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 3 on a prepared UV-Star plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test ee=+50% sample"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test ee=0% sample"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test ee=-50% sample"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 4 on a prepared UV-Star plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test Sample 4 on a 96-well deep plate"<>$SessionUUID],
		Object[Sample, "ExperimentCircularDichroism Test No Model Sample 5 on a 96-well deep plate"<>$SessionUUID],
		Object[Protocol, CircularDichroism, "Old CircularDichroism Spectroscopy Protocol"<>$SessionUUID]
	};

	existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
	EraseObject[existingObjs, Force -> True, Verbose -> False]
]


(* ::Section:: *)
(*End Test Package*)
