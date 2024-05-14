(* ::Package:: *)
(* ::Package:: *) 

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentAbsorbanceIntensity : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AbsorbanceIntensity*)


(* ::Subsubsection:: *)
(*ExperimentAbsorbanceIntensity*)


DefineTests[ExperimentAbsorbanceIntensity,
	{
		Example[{Basic,"Takes a sample object:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID]],
			ObjectP[Object[Protocol, AbsorbanceIntensity]]
		],
		Example[{Basic,"Accepts a list of sample objects:"},
			ExperimentAbsorbanceIntensity[{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceIntensity]]
		],
		Example[{Basic,"Generate protocol for measuring absorbance of samples in a plate object:"},
			ExperimentAbsorbanceIntensity[Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, AbsorbanceIntensity]]
		],
		Example[{Additional,"Specify the input as {Position,Container}:"},
			ExperimentAbsorbanceIntensity[{"A1",Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceIntensity]]
		],
		Example[{Additional,"Specify the input as a mixture of everything}:"},
			ExperimentAbsorbanceIntensity[{{"A1",Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID]},Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceIntensity]]
		],
		Example[{Basic,"Accepts a list of plate objects:"},
			ExperimentAbsorbanceIntensity[{Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],Object[Container, Plate,"ExperimentAbsorbanceIntensity New Test Plate 2" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceIntensity]]
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentAbsorbanceIntensity[Link[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Now - 1 Minute]],
			ObjectP[Object[Protocol, AbsorbanceIntensity]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "DiscardedSamples", "Throw an error if one or multiple of the input samples are discarded:"},
			ExperimentAbsorbanceIntensity[{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentAbsorbanceIntensity[
				Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"Test Label for ExperimentAbsorbanceIntensity 1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			"Test Label for ExperimentAbsorbanceIntensity 1",
			Variables:>{options}
		],
		Example[{Options, Preparation, "Set whether to use the liquid handlers or manual pipettes to perform this aliquot:"},
			options = ExperimentAbsorbanceIntensity[
				Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Preparation -> Manual,
				Output -> Options
			];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options,BlankLabel,"Specify a label for the blank sample:"},
			options=ExperimentAbsorbanceIntensity[
				Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"],
				BlankLabel->"Test Blank Label for ExperimentAbsorbanceIntensity 1",
				Output->Options
			];
			Lookup[options,BlankLabel],
			"Test Blank Label for ExperimentAbsorbanceIntensity 1",
			Variables:>{options}
		],
		Example[{Options, WorkCell, "If Preparation->Robotic, set WorkCell to STAR:"},
			options = ExperimentAbsorbanceIntensity[
				Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Preparation -> Robotic,
				Output -> Options
			];
			Lookup[options, WorkCell],
			STAR,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],ImageSample->True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],ImageSample->True];
			Download[protocol, ImageSample],
			True,
			Variables :> {protocol}
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID]];
			Download[protocol, ImageSample],
			True,
			Variables :> {protocol}
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"], Output -> Options];
			Lookup[options, Instrument],
			Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"],
			Variables :> {options}
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"]];
			Download[protocol, Instrument],
			ObjectP[Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"]],
			Variables :> {protocol}
		],
		Example[{Options,Instrument,"If QuantifyConcentration -> True, Instrument resolves to the Lunatic:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True];
			Download[protocol, Instrument],
			ObjectP[Model[Instrument, PlateReader, "Lunatic"]],
			Variables :> {protocol}
		],
		Example[{Options,Instrument,"If PlateReaderMix is True, Instrument resolves to the FLUOstar Omega:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], PlateReaderMix -> True];
			Download[protocol, Instrument],
			ObjectP[Model[Instrument, PlateReader, "FLUOstar Omega"]],
			Variables :> {protocol}
		],
		Example[{Options,MicrofluidicChipLoading,"If Instrument is Lunatic, MicrofluidicChipLoading resolves to Robotic:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"]];
			Download[protocol, MicrofluidicChipLoading],
			Robotic,
			Variables :> {protocol}
		],
		Example[{Options,MicrofluidicChipLoading,"If Instrument is not Lunatic, MicrofluidicChipLoading resolves to Null:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]];
			Download[protocol, MicrofluidicChipLoading],
			Null,
			Variables :> {protocol}
		],
		Example[{Messages,MicrofluidicChipLoading,"If Instrument is Lunatic, raise an error if MicrofluidicChipLoading is set to Null:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], MicrofluidicChipLoading -> Null],
			$Failed,
			Messages :> {Error::MicrofluidicChipLoading, Error::InvalidOption},
			Variables :> {protocol}
		],
		Example[{Messages,MicrofluidicChipLoading,"If Instrument is not Lunatic, raise an error if MicrofluidicChipLoading is set to anything other than Null:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], MicrofluidicChipLoading -> Robotic],
			$Failed,
			Messages :> {Error::MicrofluidicChipLoading, Error::InvalidOption},
			Variables :> {protocol}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1"];
			Download[protocol, Name],
			"Absorbance Spectroscopy protocol with sample 1",
			Variables :> {protocol}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1", Output -> Options];
			Lookup[options, Name],
			"Absorbance Spectroscopy protocol with sample 1",
			Variables :> {options}
		],
		Example[{Messages, "DuplicateName", "If the specified Name option already exists as a protocol object, throw an error and return $Failed:"},
			ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				BlankAbsorbance -> True,
				Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID
			],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[{Options, Template, "Set the Template option:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID], Output -> Options];
			Lookup[options, Template],
			ObjectP[Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID], Output -> Options];
			Lookup[options, EquilibrationTime],
			46*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, Template, "Set the Template option:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]];
			Download[protocol, Template],
			ObjectP[Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]];
			Download[protocol, EquilibrationTime],
			46*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		(* TODO make sure you add a test for ParentProtocol *)
		Test["If Confirm -> True, immediately confirm the protocol without sending it into the cart:",
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Confirm -> True];
			Download[protocol, Status],
			Processing|ShippingMaterials|Backlogged,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius];
			Download[protocol, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius];
			Download[protocol, Temperature],
			40.2*Celsius,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"If using the Lunatic, Temperature resolves to Null in protocol:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "Lunatic"]];
			Download[protocol, Temperature],
			Null,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"If using a BMG plate reader, Temperature resolves to Ambient (stored as Null):"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]];
			Download[protocol, Temperature],
			Null,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius, Output -> Options];
			Lookup[options, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius, Output -> Options];
			Lookup[options, Temperature],
			40.2*Celsius,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options,Temperature,"If using the Lunatic, Temperature resolves to Ambient in options:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, Temperature],
			Ambient,
			Variables :> {options}
		],
		Example[{Options,Temperature,"If using a BMG plate reader, Temperature resolves to Ambient:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, Temperature],
			Ambient,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute];
			Download[protocol, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to Null:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"]];
			Download[protocol, EquilibrationTime],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to 0*Minute:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]];
			Download[protocol, EquilibrationTime],
			0*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second];
			Download[protocol, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute, Output -> Options];
			Lookup[options, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to Null:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, EquilibrationTime],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to 0*Minute:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, EquilibrationTime],
			0*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second, Output -> Options];
			Lookup[options, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options,QuantifyConcentration,"Indicate that the concentration of the input samples should be calculated:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantifyConcentration],
			True,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified but Wavelength is specified, resolve option to False:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, QuantifyConcentration],
			False,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified and Wavelength is also not specified, resolve option to False:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Output -> Options];
			Lookup[options, QuantifyConcentration],
			False,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"Indicate the wavelength of the quantification that should be calculated:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"]];
			Download[protocol, Wavelengths],
			{280*Nanometer},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is not specified and Wavelength is also not specified, resolve option to 260 Nanometer:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID]];
			Download[protocol, Wavelengths],
			{260 Nanometer},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is True and Wavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			$Failed,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is True and Wavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True];
			Download[protocol, Wavelengths],
			{260*Nanometer,260*Nanometer,260*Nanometer}, (* Repeated since NumberOfReplicates resolved to 3 *)
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"Rounds specified Wavelength to the nearest nanometer:"},
			protocol = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280.477777777*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"]];
			Download[protocol, Wavelengths],
			{280*Nanometer},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"Indicate the wavelength of the quantification that should be calculated:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, Wavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is not specified and Wavelength is also not specified, resolve option to 260 Nanometer:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Output -> Options];
			Lookup[options, Wavelength],
			260 Nanometer,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is True and Wavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, Wavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is True and Wavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, Wavelength],
			260*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,Wavelength,"Rounds specified Wavelength to the nearest nanometer:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280.477777777*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, Wavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options, BlankAbsorbance, "Indicate whether the absorbance spectrum should be blanked:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Output -> Options];
			Lookup[options, BlankAbsorbance],
			False,
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			protocol = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			protocol = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]}
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Test["If Blanks is specified and we're also Aliquoting, still successfully makes a protocol object:",
			ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID]},
				Blanks -> {Model[Sample, "Milli-Q water"]},
				Aliquot -> True
			],
			ObjectP[Object[Protocol, AbsorbanceIntensity]]
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			protocol = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to empty list:"},
			protocol = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False
			];
			Download[protocol, Blanks],
			{},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			options = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"],
				Output -> Options
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]],
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			options = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]},
				Output -> Options
			];
			Lookup[options, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			options = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True,
				Output -> Options
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to Null:"},
			options = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False,
				Output -> Options
			];
			Lookup[options, Blanks],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			protocol = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.1*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{0.1*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages:>{Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample, using multiple samples:"},
			protocol = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{0.1*Milliliter, 0.15*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages:>{Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a BMG plate reader, resolve BlankVolumes to the volume of the corresponding sample:"},
			protocol = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{200*Microliter, 300*Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a Lunatic, resolve BlankVolumes to 2.1 uL:"},
			protocol = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "Lunatic"]
			];
			Download[protocol, BlankVolumes],
			{2.1*Microliter, 2.1*Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> False and BlankVolumes is not specified, resolve BlankVolumes to empty list:"},
			protocol = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> False
			];
			Download[protocol, BlankVolumes],
			{},
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			protocol = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.111112544771*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{0.1111*Milliliter},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision,Warning::NotEqualBlankVolumesWarning},
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			options = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.1*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			0.1*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages :> {Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample, using multiple samples:"},
			options = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			{0.1*Milliliter, 0.15*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages :> {Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a BMG plate reader, resolve BlankVolumes to the volume of the corresponding sample:"},
			options = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			{200*Microliter, 300*Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a Lunatic, resolve BlankVolumes to 2.1 uL:"},
			options = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			2.1*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> False and BlankVolumes is not specified, resolve BlankVolumes to Null:"},
			options = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> False,
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			options = ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.111112544771*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			0.1111*Milliliter,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision,Warning::NotEqualBlankVolumesWarning},
			Variables :> {options, protocol}
		],
		Example[{Options,PlateReaderMix,"Set PlateReaderMix to True to shake the input plate in the reader before the assay begins:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],PlateReaderMix->True],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM, 30.` Second}
		],
		Example[{Options, LiquidHandler, "If LiquidHandler->True resolves the instrument to not Lunatic:"},
			options = ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Output -> Options
			];
			Lookup[options, Instrument],
			Except[LinkP[Model[Instrument, PlateReader, "Lunatic"]]],
			Variables :> {options, protocol}
		],
		Example[{Options,PlateReaderMixMode,"Specify how the plate should be moved to perform the mixing:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],PlateReaderMixMode->Orbital],
				PlateReaderMixMode
			],
			Orbital
		],
		Example[{Options,PlateReaderMixRate,"If PlateReaderMixRate is specified, it will automatically turn mixing on and resolve PlateReaderMixTime:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],PlateReaderMixRate->100 RPM],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,100.` RPM, 30.` Second}
		],
		Example[{Options,PlateReaderMixTime,"Specify PlateReaderMixTime to automatically turn mixing on and resolve PlateReaderMixRate:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],PlateReaderMixTime->1 Hour],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM, 1 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,MeasureVolume,"Specify MeasureVolume to indicate if the samples should have their volume measured after the protocol:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],MeasureVolume -> True],
				MeasureVolume
			],
			True
		],
		Example[{Options,MeasureWeight,"Specify MeasureWeight to indicate if the samples should have their weight measured after the protocol:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],MeasureWeight -> True],
				MeasureWeight
			],
			True
		],
		Example[{Options,PrimaryInjectionSample,"Indicate that you'd like to inject water into every input sample:"},
			ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID]},
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionVolume->4 Microliter
			],
			ObjectP[Object[Protocol,AbsorbanceIntensity]]
		],
		Example[{Options,PrimaryInjectionVolume,"If you'd like to skip the injection for a subset of you samples, use Null as a placeholder in the injection samples list and injection volumes list. Here the 2nd sample will not receive injections:"},
			Download[
				ExperimentAbsorbanceIntensity[
					{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2" <> $SessionUUID]},
					PrimaryInjectionSample->{Model[Sample, "Milli-Q water"],Null},
					PrimaryInjectionVolume->{4 Microliter,Null}
				],
				PrimaryInjections
			],
			{
				{LinkP[Model[Sample, "Milli-Q water"]],4.` Microliter},
				{Null,0.` Microliter}
			}
		],
		Example[{Options,SecondaryInjectionSample,"Specify the sample to inject in the second round of injections:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceIntensity Injection 1" <> $SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceIntensity Injection 2" <> $SessionUUID],
				SecondaryInjectionVolume->3 Microliter
			],
			ObjectP[Object[Protocol,AbsorbanceIntensity]]
		],
		Example[{Options,SecondaryInjectionVolume,"Specify that 3\[Micro]L of \"Injection test sample 2\" should be injected into the input sample in the second injection round:"},
			Download[
				ExperimentAbsorbanceIntensity[
					Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceIntensity Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceIntensity Injection 2" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter
				],
				SecondaryInjections
			],
			{
				{LinkP[Object[Sample, "ExperimentAbsorbanceIntensity Injection 2" <> $SessionUUID]],3.` Microliter}
			}
		],
		Example[{Options,PrimaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the first round of injection:"},
			Download[
				ExperimentAbsorbanceIntensity[
					Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionFlowRate->400 Microliter/Second
				],
				PrimaryInjectionFlowRate
			],
			400.` Microliter/Second
		],
		Example[{Options,SecondaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the second round of injection:"},
			Download[
				ExperimentAbsorbanceIntensity[
					Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceIntensity Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceIntensity Injection 2" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionFlowRate->400 Microliter/Second
				],
				SecondaryInjectionFlowRate
			],
			400.` Microliter/Second
		],
		Example[{Options,InjectionSampleStorageCondition,"Indicate that the injection samples should be stored at room temperature after the experiment completes:"},
			Download[
				ExperimentAbsorbanceIntensity[
					Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceIntensity Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					InjectionSampleStorageCondition->AmbientStorage
				],
				InjectionStorageCondition
			],
			AmbientStorage
		],
		Example[{Options,ReadDirection,"To decrease the time it takes to read the plate minimize plate carrier movement by setting ReadDirection to SerpentineColumn:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],ReadDirection->SerpentineColumn][ReadDirection],
			SerpentineColumn
		],
		Example[{Options,NumberOfReadings,"Indicate that 50 flashes should be performed in order to gather 50 measurements which are averaged together to produce a single reading:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],NumberOfReadings->50][NumberOfReadings],
			50
		],
		Test["PlateReaderMix->False causes other mix values to resolve to Null:",
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],PlateReaderMix->False],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixTime->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],PlateReaderMixTime->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixRate->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],PlateReaderMixRate->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Example[{Messages,"MixingParametersRequired","Throws an error if PlateReaderMix->True and PlateReaderMixTime has been set to Null:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->Null
			],
			$Failed,
			Messages:>{
				Error::MixingParametersRequired,
				Error::InvalidOption
			}
		],

		Example[{Messages,"MixingParametersUnneeded","Throws an error if PlateReaderMix->False and PlateReaderMixTime has been specified:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime->3 Minute
			],
			$Failed,
			Messages:>{
				Error::MixingParametersUnneeded,
				Error::InvalidOption
			}
		],

		Example[{Messages,"MixingParametersConflict","Throw an error if PlateReaderMix cannot be resolved because one mixing parameter was specified and another was set to Null:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				PlateReaderMixRate->200 RPM,
				PlateReaderMixTime->Null
			],
			$Failed,
			Messages:>{
				Error::MixingParametersConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PlateReaderMixingUnsupported","Throw an error if mixing within the plate reader chamber is being requested, but the instrument does not support it:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				PlateReaderMix->True,
				Instrument->Model[Instrument, PlateReader, "Lunatic"]
			],
			$Failed,
			Messages:>{
				Error::PlateReaderMixingUnsupported,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw an error and return early if an input object doesn't exist:"},
			ExperimentAbsorbanceIntensity[{Object[Sample, "Nonexistent object for ExperimentAbsorbanceIntensity testing" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "InvalidInput", "Throw an error if one or multiple of the input samples are discarded:"},
			ExperimentAbsorbanceIntensity[{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput},
			Variables :> {options, protocol}
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the Temperature option is specified with an instrument that does not support it:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Temperature -> 30 Celsius, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, Temperature],
			30 Celsius,
			Messages :> {Error::TemperatureIncompatibleWithPlateReader, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the EquilibrationTime option is specified with an instrument that does not support it:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 10*Minute, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, EquilibrationTime],
			10*Minute,
			Messages :> {Error::TemperatureIncompatibleWithPlateReader, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader model is deprecated:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FlexStation 3"]],
			$Failed,
			Messages :> {Error::DeprecatedInstrument, Error::InvalidInput},
			Variables :> {options, protocol}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader object is retired:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Object[Instrument, PlateReader, "Flexstation"]],
			$Failed,
			Messages :> {Error::UnsupportedPlateReader, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "ConcentrationWavelengthMismatch", "Does NOT return an error if QuantifyConcentration is set to False and a Wavelength has been provided (unlike ExperimentAbsorbanceIntensity):"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantifyConcentration->False, Wavelength->280 Nanometer, Output -> Options];
			Lookup[options, {QuantifyConcentration, Wavelength}],
			{False, 280*Nanometer},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and Blanks -> Null:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, Blanks -> Null, Output -> Options];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and BlankVolumes -> Null:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, BlankVolumes -> Null, Output -> Options];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::BlankVolumeNotRecommended, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and Blanks is specified:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Blanks -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{False, ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and BlankVolumes is specified:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, BlankVolumes -> 2*Microliter, Output -> Options];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{False, 2*Microliter},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "BlankVolumeNotRecommended", "Returns an error if using the Lunatic and BlankVolumes is anything but 2.1*Microliter:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], BlankVolumes -> 10*Microliter, Output -> Options];
			Lookup[options, BlankVolumes],
			10*Microliter,
			Messages :> {Error::BlankVolumeNotRecommended, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "QuantificationRequiresBlanking", "Returns an error if QuantifyConcentration -> True and BlankAbsorbance -> False:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],QuantifyConcentration -> True, BlankAbsorbance -> False, Output -> Options];
			Lookup[options, {QuantifyConcentration, BlankAbsorbance}],
			{True, False},
			Messages :> {Error::QuantificationRequiresBlanking, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "AbsSpecTooManySamples", "If the combination of NumberOfReplicates * (Number of samples + number of unique blanks) is greater than 94 and we are using the Lunatic, throw an error:"},
			ExperimentAbsorbanceIntensity[
				{Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				NumberOfReplicates -> 50,
				BlankAbsorbance -> True,
				Output -> Options
			],
			{_Rule..},
			Messages :> {Error::AbsSpecTooManySamples, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "BlanksContainSamplesIn", "If the specified Blanks option contains samples that are also inputs, throw an error and return $Failed:"},
			options = ExperimentAbsorbanceIntensity[
				{
					Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]
				},
				Blanks -> {
					Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Automatic
				},
				Output -> Options
			];
			Lookup[options, Blanks],
			{ObjectP[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages :> {Error::BlanksContainSamplesIn, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "ExtCoeffNotFound", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, Wavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Messages, "ExtinctionCoefficientMissing", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, Wavelength],
			260*Nanometer,
			Messages :> {Error::ExtinctionCoefficientMissing, Warning::ExtCoeffNotFound, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Messages, "ExtinctionCoefficientMissing", "If sample concentration is NOT being quantified, the extinction doesn't need to be populated:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID], Wavelength -> 280 Nanometer, Output -> Options];
			Lookup[options, Wavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Messages, "AliquotRequired", "If the sample must be aliquoted but no aliquot options are specified, throw a warning telling the user:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options],
			{__Rule},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Messages, "AmbiguousAnalyte", "If the sample has multiple potential analytes and the QuantificationAnalyte option is not specified, throw a warning stating that one has been chosen arbitrarily:"},
			Lookup[ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options], QuantificationAnalyte],
			ObjectP[Model[Molecule, Oligomer]],
			Messages :> {Warning::ExtCoeffNotFound, Warning::AmbiguousAnalyte}
		],
		Example[{Messages, "AmbiguousAnalyte", "If the sample has multiple potential analytes and the QuantificationAnalyte option is specified, do not throw a warning:"},
			Lookup[ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"], Output -> Options], QuantificationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "ACTH 18-39"]],
			Messages :> {Warning::ExtCoeffNotFound}
		],
		Example[{Messages, "AmbiguousAnalyte", "If the sample has multiple potential analytes and the QuantificationAnalyte option is not specified but we aren't actually quantifying, don't throw an error:"},
			Lookup[ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID], QuantifyConcentration -> False, Output -> Options], QuantificationAnalyte],
			Null,
			Messages :> {Warning::ExtCoeffNotFound}
		],
		Example[{Messages,"ReplicateChipSpace","Warns the user if the sample is being quantified but there is not enough space available to do the expected number of replicates:"},
			ExperimentAbsorbanceIntensity[
				Object[Container, Plate, "Test container 11 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				QuantifyConcentration -> True
			],
			ObjectP[Object[Protocol,AbsorbanceIntensity]],
			Messages:>{Warning::ReplicateChipSpace}
		],
		Example[{Messages,"PlateReaderInjectionsUnsupported","Throws an error if injections are being requested, but the instrument does not support it:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"],
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionVolume->5 Microliter
			],
			$Failed,
			Messages:>{
				Error::PlateReaderInjectionsUnsupported,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PlateReaderMoatUnsupported","Throws an error if there's a request to create a circle of wells around the samples but a chip-based reader is being used:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"],
				MoatSize->1
			],
			$Failed,
			Messages:>{
				Error::PlateReaderMoatUnsupported,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PlateReaderReadDirectionUnsupported","Throws an error if the plate reader being does not allow the order in which samples are read to be set:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"],
				ReadDirection->SerpentineRow
			],
			$Failed,
			Messages:>{
				Error::PlateReaderReadDirectionUnsupported,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidBlankContainer","Throws an error because no blank volume has been specified but blank Buffer 1 is in a 50mL tube and must be transferred into the assay container to be read:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ExperimentAbsorbanceIntensity Blank Buffer 1" <> $SessionUUID],
				BlankVolumes->Null
			],
			$Failed,
			Messages:>{Error::InvalidBlankContainer,Error::InvalidOption}
		],
		Example[{Messages,"UnnecessaryBlankTransfer","Specifying a blank volume indicates that an aliquot of the blank should be taken and read. Gives a warning if this is set to happen even though the blank is already in a valid container:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ExperimentAbsorbanceIntensity Blank Buffer 3" <> $SessionUUID],
				BlankVolumes->100 Microliter
			],
			ObjectP[Object[Protocol,AbsorbanceIntensity]],
			Messages:>{Warning::UnnecessaryBlankTransfer,Warning::NotEqualBlankVolumesWarning}
		],
		Test["If Output -> Tests, return a list of tests:",
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID], Output -> Tests],
			{__EmeraldTest},
			Variables :> {options, protocol}
		],
		Test["If Output -> Options, return a list of resolved options:",
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],EquilibrationTime->10 Minute, Output -> Options],
			{__Rule},
			Variables :> {options, protocol}
		],
		Test["If Output is to all values, return all of these values:",
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID],EquilibrationTime->10 Minute, Output -> {Result, Tests, Options, Preview}],
			{
				ObjectP[Object[Protocol, AbsorbanceIntensity]],
				{__EmeraldTest},
				{__Rule},
				Null
			},
			Variables :> {options, protocol},
			TimeConstraint->300
		],

		Example[{Options, SamplesInStorageCondition, "Populate the SamplesInStorage field:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, NumberOfReplicates -> 2],
				SamplesInStorage
			],
			{Refrigerator, Refrigerator}
		],

		Example[{Options, NumberOfReplicates, "Populate SamplesIn in accordance with NumberOfReplicates:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], NumberOfReplicates -> 2],
				SamplesIn[Object]
			],
			{ObjectP[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID]], ObjectP[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID]]}
		],


		(* -- Primitive tests -- *)
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with Preparation->Robotic:",
			Experiment[{
				AbsorbanceIntensity[
					Sample->Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID],
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]],
			Messages :> {Warning::InsufficientVolume}
		],
		Test["Generate an AbsorbanceIntensity protocol object based on a single primitive with Preparation->Manual:",
			Experiment[{
				AbsorbanceIntensity[
					Sample -> Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
					Preparation -> Manual
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with injection options specified:",
			Experiment[{
				AbsorbanceIntensity[
					Sample->Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
					Preparation -> Robotic,
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceIntensity Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					InjectionSampleStorageCondition->AmbientStorage
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]],
			Messages :> {Warning::InsufficientVolume}
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a primitive with multiple samples and Preparation->Robotic:",
			Experiment[{
				AbsorbanceIntensity[
					Sample-> {
						Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
						Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]
					},
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]],
			Messages :> {Warning::InsufficientVolume}
		],

		(* sample prep tests *)
		Example[{Additional, "Perform all sample prep experiments on one sample:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], Incubate -> True, Mix -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True],
			ObjectP[Object[Protocol, AbsorbanceIntensity]],
			TimeConstraint -> 2000
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to create test standards prior to running the experiment:"},
			protocol = ExperimentAbsorbanceIntensity[
				{"red dye sample", Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "red dye sample", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Red Food Dye"], Amount -> 200*Microliter, Destination -> "red dye sample"]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		Example[{Options, PreparatoryPrimitives, "Use PreparatoryPrimitives option to create test standards prior to running the experiment:"},
			protocol = ExperimentAbsorbanceIntensity[
				{"red dye sample", Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				PreparatoryPrimitives -> {
					Define[Name -> "red dye sample", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Red Food Dye"], Amount -> 200*Microliter, Destination -> "red dye sample"]
				}
			];
			Download[protocol, PreparatoryPrimitives],
			{SampleManipulationP..},
			Variables :> {protocol}
		],
		(* incubate options *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the position in the incubate aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquot -> 150*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, IncubateAliquot],
			150*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the position in the centrifuge aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (1.5 mL)" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (1.5 mL)" <> $SessionUUID], CentrifugeTime -> 40*Minute, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquot -> 150*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, CentrifugeAliquot],
			150*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], Filtration -> True, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Syringe, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterInstrument -> Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates the position in the filter aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], FilterAliquotDestinationWell -> "A2", Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options},
			Messages :> {Warning::AliquotRequired},
			TimeConstraint->300
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterMaterial -> PES,Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], PrefilterMaterial -> GxF, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterSyringe, "The syringe used to force the sample through a filter:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterHousing, "FilterHousing resolves to Null for all reasonably-small samples that might be used in this experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (1.5 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquot -> 150*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquot],
			150*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired},
			TimeConstraint->300
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Indicates the position in the AliquotContainer that we want to move the sample into:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], DestinationWell -> "A2", Output -> Options];
			Lookup[options, DestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 300*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The specific analyte to get to the specified target concentration:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Red Food Dye"], AssayVolume -> 300*Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Red Food Dye"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "If instrument is set to the Lunatic, ConsolidateAliquots is automatically set to True:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], Output -> Options];
			Lookup[options, AliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well UV-Star Plate"]]},
			Variables :> {options}
		],
		Example[{Options,MoatSize,"Indicate the first two columns and rows and the last two columns and rows of the plate should be filled with water to decrease evaporation of the inner assay samples:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				MoatSize->2,
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceIntensity]]
		],
		Example[{Options,MoatVolume,"Indicate the volume which should be used to fill each moat well:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				MoatVolume->150 Microliter,
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceIntensity]]
		],
		Example[{Options,MoatBuffer,"Indicate that each moat well should be filled with water:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				MoatBuffer->Model[Sample,"Milli-Q water"],
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceIntensity]]
		],
		Example[{Options,RetainCover,"Indicate that the existing lid or plate seal should be left on during the read:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				RetainCover->True,
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			ObjectP[Object[Protocol,AbsorbanceIntensity]]
		],
		Example[{Messages, "CoveredInjections", "As injections are made into the top of the plate, RetainCover cannot be set to True:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				RetainCover->True,
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionVolume->5 Microliter
			],
			$Failed,
			Messages :> {Error::CoveredInjections,Error::InvalidOption}
		],
		Example[{Messages, "CoverUnsupported", "A plate based reader must be specified to use RetainCover:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				RetainCover->True
			],
			$Failed,
			Messages :> {Error::CoverUnsupported,Error::InvalidOption}
		],
		Example[{Options,SamplingPattern,"Indicate that a grid of readings should be taken for each well and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],SamplingPattern->Matrix],
				SamplingPattern
			],
			Matrix
		],
		Test["Do not resolve to Matrix SamplingPattern if we have more than 8 intensities:",
			Download[
				ExperimentAbsorbanceIntensity[ConstantArray[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],10],Wavelength->Range[350 Nanometer, 800 Nanometer, 50 Nanometer]],
				SamplingPattern
			],
			Null
		],
		Test["Matrix SamplingPattern is not allowed if we have more than 8 intensities is not allowed for more than 8 discrete wavelengths:",
			ExperimentAbsorbanceIntensity[ConstantArray[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],10],Wavelength->Range[350 Nanometer, 800 Nanometer, 50 Nanometer],SamplingPattern->Matrix],
			$Failed,
			Messages:>{Error::AbsorbanceSamplingCombinationUnavailable,Warning::RepeatedPlateReaderSamples,Warning::TotalAliquotVolumeTooLarge,Error::InvalidOption}
		],
		Example[{Options,SamplingDimension,"Indicate that 16 readings (4x4) should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],SamplingDimension->4],
				SamplingDimension
			],
			4
		],
		Example[{Options,SamplingDistance,"Indicate the length of the region over which sampling measurements should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],SamplingPattern->Ring,SamplingDistance->5 Millimeter],
				SamplingDistance
			],
			5.` Millimeter
		],
		Example[{Messages,"AbsorbanceSamplingCombinationUnavailable","SamplingDimension is only supported when SamplingPattern->Matrix:"},
			ExperimentAbsorbanceIntensity[
				Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				SamplingPattern->Ring,
				SamplingDimension->4
			],
			$Failed,
			Messages:>{Error::AbsorbanceSamplingCombinationUnavailable,Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedInstrumentSamplingPattern","The Omega can't sample wells using a Matrix pattern:"},
			ExperimentAbsorbanceIntensity[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],SamplingPattern->Matrix],
			$Failed,
			Messages:>{Error::UnsupportedInstrumentSamplingPattern,Error::InvalidOption}
		],
		Example[{Messages,"SamplingPatternMismatch","When using an instrument capable of sampling the SamplingPattern can't be set to Null:"},
			ExperimentAbsorbanceIntensity[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],SamplingPattern->Null],
			$Failed,
			Messages:>{Error::SamplingPatternMismatch,Error::InvalidOption}
		],
		Example[{Messages,"SamplingPatternMismatch","When using an instrument which doesn't perform sampling the SamplingPattern can't be set:"},
			ExperimentAbsorbanceIntensity[Object[Sample,"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],Instrument->Model[Instrument,PlateReader,"Lunatic"],SamplingPattern->Center],
			$Failed,
			Messages:>{Error::SamplingPatternMismatch,Error::InvalidOption}
		],
		Test["PlateReaderMix->False causes other mix values to resolve to Null:",
			Download[
				ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],PlateReaderMix->False],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Example[{Additional, "If the input sample has no model, still successfully returns a protocol:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID]],
			ObjectP[Object[Protocol, AbsorbanceIntensity]],
			TimeConstraint -> 2000,
			Messages :> {Warning::ExtCoeffNotFound}
		],
		Example[{Messages, "SampleMustContainQuantificationAnalyte", "If QuantificationAnalyte is specified, it must be a component of the input sample:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"]],
			$Failed,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::SampleMustContainQuantificationAnalyte, Error::InvalidOption}
		],
	(*Example[{Additional, "If the input sample has no model, still successfully returns a protocol when running all the sample prep options:"},
		ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID], Incubate -> True, Mix -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True],
		ObjectP[Object[Protocol, AbsorbanceIntensity]],
		TimeConstraint -> 2000,
		Messages :> {
			Messages :> Warning::ExtCoeffNotFound
		}
	],*)
		Example[{Options, QuantificationAnalyte, "Specify the desired component to be quantified:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, "Red Food Dye"], Output -> Options];
			Lookup[options, QuantificationAnalyte],
			ObjectP[Model[Molecule, "Red Food Dye"]],
			Variables :> {options}
		],
		Example[{Options, QuantificationAnalyte, "If not specified, automatically set to an identity model in the Analytes (or, if not populated, Composition) field of the sample:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "ACTH 18-39"]],
			Variables :> {options},
			Messages :> {Warning::ExtCoeffNotFound}
		],
		Example[{Options, QuantificationAnalyte, "If the QuantificationAnalyte option resolves to a peptide, set the Wavelength to 280 nm:"},
			options = ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"], Output -> Options];
			Lookup[options, Wavelength],
			EqualP[280 Nanometer],
			Variables :> {options},
			Messages :> {Warning::ExtCoeffNotFound}
		],
		Example[{Options, QuantificationAnalyte, "If the QuantificationAnalyte option is set, QuantifyConcentration cannot be False:"},
			ExperimentAbsorbanceIntensity[Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"], QuantifyConcentration -> False],
			$Failed,
			Messages :> {Warning::ExtCoeffNotFound, Error::ConcentrationWavelengthMismatch, Error::InvalidOption}
		]
	},
	(* every time a test is run reset $CreatedObjects and erase things at the end *)
	SetUp :> (ClearDownload[]; $CreatedObjects = {}),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensity New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensity New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Plate, "Fake container 10 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 11 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Blank Buffer 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Blank Buffer 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Blank Buffer 3" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 2 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceIntensity Injection 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Injection 2" <> $SessionUUID],

				Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11,
					container12, container13, container14, container15, container16, container17, sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
					sample13, sample14, sample15, sample16, sample17, sample18, sample19, plateSamples, allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,DeveloperObject->True|>];
				{
					container,
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
					container12,
					container13,
					container14,
					container15,
					container16,
					container17
				}=UploadSample[
					{
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]

					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Name->{
						"Fake container 1 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Plate 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Plate 2" <> $SessionUUID,
						"Fake container 2 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Fake container 3 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Fake container 4 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Fake container 5 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Fake container 6 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Fake container 7 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Fake container 8 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Fake container 9 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Fake container 10 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Test container 11 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Test container 12 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Test container 13 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Test container 14 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID,
						"Test container 15 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID
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
					sample17,
					sample18,
					sample19
				}=UploadSample[
					{
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Acetone, HPLC Grade"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Somatostatin 28"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "ACTH 18-39"],
						Model[Sample, "ACTH 18-39"],
						Model[Sample, "Leucine Enkephalin (Oligomer)"],
						Model[Sample, "Leucine Enkephalin (Oligomer)"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A2",container2},
						{"A1",container4},
						{"A2",container},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",container10},
						{"A1",container11},
						{"A1",container12},
						{"A2",container},
						{"A1",container14},
						{"A1",container15},
						{"A1",container16},
						{"A1",container17}
					},
					InitialAmount->{
						200*Microliter,
						200*Microliter,
						300*Microliter,
						300*Microliter,
						200*Microliter,
						200*Microliter,
						15*Milliliter,
						1.5*Milliliter,
						200*Microliter,
						200*Microliter,
						20 Milliliter,
						20 Milliliter,
						20 Milliliter,
						20 Milliliter,
						200*Microliter,
						200*Microliter,
						200*Microliter,
						200*Microliter,
						200*Microliter
					},
					State -> Liquid,
					Name->{
						"ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Chemical 2" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Chemical 1 (1.5 mL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity Injection 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity Injection 2" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity Blank Buffer 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity Blank Buffer 2" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity Blank Buffer 3" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Peptide oligomer 2 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensity New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID
					}
				];

				UploadSampleTransfer[Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID], 100 Microliter];

				UploadSampleTransfer[
					Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentAbsorbanceIntensity New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID],
					100 Microliter
				];

				plateSamples=UploadSample[
					ConstantArray[Model[Sample, "Red Food Dye"],32],
					{#,container13}&/@Take[Flatten[AllWells[]], 32],
					InitialAmount->ConstantArray[200 Microliter,32]
				];
				
				allObjs = Join[
					{
						container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11,
						container12, container13, container14, container15, container16, container17, sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
						sample13, sample14, sample15, sample16, sample17,sample18,sample19
					},
					plateSamples
				];

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceIntensity],
						Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							QuantifyConcentration -> False,
							Wavelength -> 280 Nanometer,
							NumberOfReplicates -> Null,
							BlankAbsorbance -> True,
							Blanks -> Model[Sample, "Milli-Q water"],
							BlankVolumes -> 200*Microliter,
							Confirm -> False,
							ImageSample -> False,
							Name -> Null,
							Template -> Null
						},
						UnresolvedOptions -> {EquilibrationTime -> 46*Minute}
					|>,
					<|Object -> Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID], Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Red Food Dye"]]}}|>,
					(* test on a model-less sample *)
					<|Object -> sample19, Model -> Null|>
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensity New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensity New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Plate, "Fake container 10 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 11 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for ExperimentAbsorbanceIntensity tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Chemical 1 (red food dye)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Injection 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Injection 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Blank Buffer 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Blank Buffer 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity Blank Buffer 3" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 2 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensity New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID],

				Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	),
	Variables :> {allObjsWeCreate, existingObjs},
	Stubs:> {
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"],
		$AllowSystemsProtocols = True
	}
];


(* ::Subsection:: *)
(*ValidExperimentAbsorbanceIntensityQ*)


DefineTests[ValidExperimentAbsorbanceIntensityQ,
	{
		Example[{Basic,"Takes a sample object:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Accepts a list of sample objects:"},
			ValidExperimentAbsorbanceIntensityQ[{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID]}],
			True
		],
		Example[{Basic,"Generate protocol for measuring absorbance of samples in a plate object:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Container, Plate, "Fake container 1 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Accepts a list of plate objects:"},
			ValidExperimentAbsorbanceIntensityQ[{Object[Container, Plate, "Fake container 1 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],Object[Container, Plate,"ValidExperimentAbsorbanceIntensityQ New Test Plate 2" <> $SessionUUID]}],
			True
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],ImageSample->True],
			True
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID]],
			True
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"]],
			True
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1 for ValidQ function"],
			True
		],
		Example[{Messages, "DuplicateName", "If the specified Name option already exists as a protocol object, throw an error and return $Failed:"},
			ValidExperimentAbsorbanceIntensityQ[
				{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				BlankAbsorbance -> True,
				Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID
			],
			False
		],
		Example[{Options, Template, "Set the Template option:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID]],
			True
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID]],
			True
		],
		Test["If Confirm -> True, immediately confirm the protocol without sending it into the cart:",
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Confirm -> True],
			True
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius],
			True
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius],
			True
		],
		Example[{Options,Temperature,"If using the Lunatic, Temperature resolves to Null:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			True
		],
		Example[{Options,Temperature,"If using a BMG plate reader, Temperature resolves to Ambient:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]],
			True
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute],
			True
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to Null:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			True
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to 0*Minute:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]],
			True
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second],
			True
		],
		Example[{Options,QuantifyConcentration,"Indicate that the concentration of the input samples should be calculated:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			True
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified but Wavelength is specified, resolve option to False:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			True
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified and Wavelength is also not specified, resolve option to False:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID]],
			True
		],
		Example[{Options,Wavelength,"Indicate the wavelength of the quantification that should be calculated:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			True
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is not specified and Wavelength is also not specified, resolve option to 260 Nanometer:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID]],
			True
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is True and Wavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model (and throw a warning):"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			False
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is True and Wavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			True
		],
		Example[{Options,Wavelength,"Rounds specified Wavelength to the nearest nanometer:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280.477777777*Nanometer],
			True
		],
		Example[{Options, BlankAbsorbance, "Indicate whether the absorbance spectrum should be blanked:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False],
			True
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			ValidExperimentAbsorbanceIntensityQ[
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]
			],
			True
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			ValidExperimentAbsorbanceIntensityQ[
				{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]}
			],
			True
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			ValidExperimentAbsorbanceIntensityQ[
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True
			],
			True
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to Null:"},
			ValidExperimentAbsorbanceIntensityQ[
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False
			],
			True
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			ValidExperimentAbsorbanceIntensityQ[
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.1*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			],
			True
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample, using multiple samples:"},
			ValidExperimentAbsorbanceIntensityQ[
				{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			],
			True
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a BMG plate reader, resolve BlankVolumes to the volume of the corresponding sample:"},
			ValidExperimentAbsorbanceIntensityQ[
				{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			],
			True
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a Lunatic, resolve BlankVolumes to 2 uL:"},
			ValidExperimentAbsorbanceIntensityQ[
				{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "Lunatic"]
			],
			True
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> False and BlankVolumes is not specified, resolve BlankVolumes to Null:"},
			ValidExperimentAbsorbanceIntensityQ[
				{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> False
			],
			True
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			ValidExperimentAbsorbanceIntensityQ[
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.111112544771*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			],
			True
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to create test standards prior to running the experiment:"},
			ValidExperimentAbsorbanceIntensityQ[
				{"red dye sample", Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "red dye sample", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Red Food Dye"], Amount -> 200*Microliter, Destination -> "red dye sample"]
				}
			],
			True
		],
		Example[{Messages, "DiscardedSamples", "Throw an error if one or multiple of the input samples are discarded:"},
			ValidExperimentAbsorbanceIntensityQ[{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			False
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the Temperature option is specified with an instrument that does not support it:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Temperature -> 30 Celsius, Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			False
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the EquilibrationTime option is specified with an instrument that does not support it:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 10*Minute, Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			False
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader model is deprecated:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FlexStation 3"]],
			False
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader object is retired:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Instrument -> Object[Instrument, PlateReader, "Flexstation"]],
			False
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and Blanks -> Null:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, Blanks -> Null],
			False
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and BlankVolumes -> Null:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, BlankVolumes -> Null],
			False
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and Blanks is specified:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Blanks -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and BlankVolumes is specified:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, BlankVolumes -> 2*Microliter],
			False
		],
		Example[{Messages, "BlankVolumeNotRecommended", "Returns an error if using the Lunatic and BlankVolumes is anything but 2.1*Microliter:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], BlankVolumes -> 10*Microliter],
			False
		],
		Example[{Messages, "QuantificationRequiresBlanking", "Returns an error if QuantifyConcentration -> True and BlankAbsorbance -> False:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],QuantifyConcentration -> True, BlankAbsorbance -> False],
			False
		],
		Example[{Messages, "TooManySamples", "If the combination of NumberOfReplicates * (Number of samples + number of unique blanks) is greater than 94 and we are using the Lunatic, throw an error:"},
			ValidExperimentAbsorbanceIntensityQ[
				{Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				NumberOfReplicates -> 50,
				BlankAbsorbance -> True
			],
			False
		],
		Example[{Messages, "BlanksContainSamplesIn", "If the specified Blanks option contains samples that are also inputs, throw an error and return $Failed:"},
			ValidExperimentAbsorbanceIntensityQ[
				{
					Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID]
				},
				Blanks -> {
					Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Automatic
				}
			],
			False
		],
		Example[{Messages, "ExtCoeffNotFound", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			False
		],
		Example[{Options, Verbose, "If Verbose -> Failures, return the results of all failing tests and warnings:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Verbose -> Failures],
			False
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Messages, "SampleMustContainQuantificationAnalyte", "If QuantificationAnalyte is specified, it must be a component of the input sample:"},
			ValidExperimentAbsorbanceIntensityQ[Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"]],
			False
		]
	},
	(* every time a test is run reset $CreatedObjects and erase things at the end *)
	SetUp :> (ClearDownload[]; $CreatedObjects = {}),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentAbsorbanceIntensityQ New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentAbsorbanceIntensityQ New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],

				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5,
					sample, sample2, sample3, sample4, sample5, sample6, sample7,

					allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID,DeveloperObject->True|>];
				{
					container,
					container2,
					container3,
					container4,
					container5
				}=UploadSample[
					{
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Name->{
						"Fake container 1 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID,
						"ValidExperimentAbsorbanceIntensityQ New Test Plate 1" <> $SessionUUID,
						"ValidExperimentAbsorbanceIntensityQ New Test Plate 2" <> $SessionUUID,
						"Fake container 2 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID,
						"Fake container 3 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7
				}=UploadSample[
					{
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Acetone, HPLC Grade"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A2",container2},
						{"A1",container4},
						{"A2",container},
						{"A1", container5}
					},
					InitialAmount->{
						200*Microliter,
						200*Microliter,
						300*Microliter,
						300*Microliter,
						200*Microliter,
						200*Microliter,
						200*Microliter
					},
					Name->{
						"ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID,
						"ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ValidExperimentAbsorbanceIntensityQ Acetone Test Chemical 1" <> $SessionUUID,
						"ValidExperimentAbsorbanceIntensityQ New Test Chemical 2" <> $SessionUUID,
						"ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (red food dye)" <> $SessionUUID
					}
				];


				allObjs = {
					container, container2, container3, container4, container5,
					sample, sample2, sample3, sample4, sample5, sample6, sample7
				};

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceIntensity],
						Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							QuantifyConcentration -> False,
							Wavelength -> Null,
							NumberOfReplicates -> Null,
							BlankAbsorbance -> True,
							Blanks -> Model[Sample, "Milli-Q water"],
							BlankVolumes -> 200*Microliter,
							Confirm -> False,
							ImageSample -> False,
							Name -> Null,
							Template -> Null
						},
						UnresolvedOptions -> {EquilibrationTime -> 46*Minute}
					|>
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentAbsorbanceIntensityQ New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentAbsorbanceIntensityQ New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ValidExperimentAbsorbanceIntensityQ tests" <> $SessionUUID],

				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceIntensityQ New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	),
	Stubs:> {
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"],
		ValidObjectQ[x_List, ___]:=ConstantArray[True, Length[x]]
	}
];


(* ::Subsection:: *)
(*ExperimentAbsorbanceIntensityOptions*)


DefineTests[ExperimentAbsorbanceIntensityOptions,
	{
		Example[{Basic,"Display all the resolved options for ExperimentAbsorbanceIntensityOptions as a table:"},
			ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],ImageSample->True],
			_Grid
		],
		Example[{Basic,"Display all the resolved options for ExperimentAbsorbanceIntensityOptions as a table for plates:"},
			ExperimentAbsorbanceIntensityOptions[Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"Display all the resolved options for ExperimentAbsorbanceIntensityOptions as a table for a list of plates:"},
			ExperimentAbsorbanceIntensityOptions[{Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],Object[Container, Plate,"ExperimentAbsorbanceIntensityOptions New Test Plate 2" <> $SessionUUID]}],
			_Grid
		],
		Example[{Options, OutputFormat,"Display all the resolved options for ExperimentAbsorbanceIntensityOptions as a list if OutputFormat -> List:"},
			ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],ImageSample->True, OutputFormat -> List],
			{_Rule..}
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],ImageSample->True, OutputFormat -> List];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"], OutputFormat -> List];
			Lookup[options, Instrument],
			Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"],
			Variables :> {options}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1 for Options function", OutputFormat -> List];
			Lookup[options, Name],
			"Absorbance Spectroscopy protocol with sample 1 for Options function",
			Variables :> {options}
		],
		Example[{Messages, "DuplicateName", "If the specified Name option already exists as a protocol object, throw an error and return $Failed:"},
			ExperimentAbsorbanceIntensityOptions[
				{Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				BlankAbsorbance -> True,
				Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID
			],
			_Grid,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[{Options, Template, "Set the Template option:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, Template],
			ObjectP[Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			46*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius, OutputFormat -> List];
			Lookup[options, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius, OutputFormat -> List];
			Lookup[options, Temperature],
			40.2*Celsius,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options,Temperature,"If using the Lunatic, Temperature resolves to Ambient in options:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, Temperature],
			Ambient,
			Variables :> {options}
		],
		Example[{Options,Temperature,"If using a BMG plate reader, Temperature resolves to Ambient:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], OutputFormat -> List];
			Lookup[options, Temperature],
			Ambient,
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute, OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to Null:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to 0*Minute:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			0*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second, OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options,QuantifyConcentration,"Indicate that the concentration of the input samples should be calculated:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> List];
			Lookup[options, QuantifyConcentration],
			True,
			Variables :> {options}
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified but Wavelength is specified, resolve option to False:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, QuantifyConcentration],
			False,
			Variables :> {options}
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified and Wavelength is also not specified, resolve option to False:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, QuantifyConcentration],
			False,
			Variables :> {options}
		],
		Example[{Options,Wavelength,"Indicate the wavelength of the quantification that should be calculated:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, Wavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is not specified and Wavelength is also not specified, resolve option to 260 Nanometer:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, Wavelength],
			260 Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is True and Wavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model (and throw an error):"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> List];
			Lookup[options, Wavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Wavelength,"If QuantifyConcentration is True and Wavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> List];
			Lookup[options, Wavelength],
			260*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Wavelength,"Rounds specified Wavelength to the nearest nanometer:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (red food dye)" <> $SessionUUID], Wavelength -> 280.477777777*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, Wavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, BlankAbsorbance, "Indicate whether the absorbance spectrum should be blanked:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, OutputFormat -> List];
			Lookup[options, BlankAbsorbance],
			False,
			Variables :> {options}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			options = ExperimentAbsorbanceIntensityOptions[
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"],
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]],
			Variables :> {options}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			options = ExperimentAbsorbanceIntensityOptions[
				{Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]},
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			options = ExperimentAbsorbanceIntensityOptions[
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True,
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to Null:"},
			options = ExperimentAbsorbanceIntensityOptions[
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False,
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			Null,
			Variables :> {options}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			options = ExperimentAbsorbanceIntensityOptions[
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.1*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			0.1*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample, using multiple samples:"},
			options = ExperimentAbsorbanceIntensityOptions[
				{Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			{0.1*Milliliter, 0.15*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a BMG plate reader, resolve BlankVolumes to the volume of the corresponding sample:"},
			options = ExperimentAbsorbanceIntensityOptions[
				{Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			{200*Microliter, 300*Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a Lunatic, resolve BlankVolumes to 2.1 uL:"},
			options = ExperimentAbsorbanceIntensityOptions[
				{Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			2.1*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> False and BlankVolumes is not specified, resolve BlankVolumes to Null:"},
			options = ExperimentAbsorbanceIntensityOptions[
				{Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> False,
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			Null,
			Variables :> {options}
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			options = ExperimentAbsorbanceIntensityOptions[
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.111112544771*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			0.1111*Milliliter,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision,Warning::NotEqualBlankVolumesWarning},
			Variables :> {options}
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to create test standards prior to running the experiment:"},
			options = ExperimentAbsorbanceIntensityOptions[
				{"red dye sample", Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "red dye sample", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Red Food Dye"], Amount -> 200*Microliter, Destination -> "red dye sample"]
				},
				OutputFormat -> List
			];
			Lookup[options, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {options}
		],
		Example[{Messages, "DiscardedSamples", "Throw an error if one or multiple of the input samples are discarded:"},
			ExperimentAbsorbanceIntensityOptions[{Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			_Grid,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput},
			Variables :> {options}
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the Temperature option is specified with an instrument that does not support it:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], Temperature -> 30 Celsius, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, Temperature],
			30 Celsius,
			Messages :> {Error::TemperatureIncompatibleWithPlateReader, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the EquilibrationTime option is specified with an instrument that does not support it:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 10*Minute, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			10*Minute,
			Messages :> {Error::TemperatureIncompatibleWithPlateReader, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader model is deprecated:"},
			ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FlexStation 3"]],
			_Grid,
			Messages :> {Error::DeprecatedInstrument, Error::InvalidInput},
			Variables :> {options}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader object is retired:"},
			ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Object[Instrument, PlateReader, "Flexstation"]],
			_Grid,
			Messages :> {Error::UnsupportedPlateReader, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and Blanks -> Null:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, Blanks -> Null, OutputFormat -> List];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and BlankVolumes -> Null:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, BlankVolumes -> Null, OutputFormat -> List];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::BlankVolumeNotRecommended, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and Blanks is specified:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Blanks -> Model[Sample, "Milli-Q water"], OutputFormat -> List];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{False, ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and BlankVolumes is specified:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, BlankVolumes -> 2*Microliter, OutputFormat -> List];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{False, 2*Microliter},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "BlankVolumeNotRecommended", "Returns an error if using the Lunatic and BlankVolumes is anything but 2.1*Microliter:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], BlankVolumes -> 10*Microliter, OutputFormat -> List];
			Lookup[options, BlankVolumes],
			10*Microliter,
			Messages :> {Error::BlankVolumeNotRecommended, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "QuantificationRequiresBlanking", "Returns an error if QuantifyConcentration -> True and BlankAbsorbance -> False:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],QuantifyConcentration -> True, BlankAbsorbance -> False, OutputFormat -> List];
			Lookup[options, {QuantifyConcentration, BlankAbsorbance}],
			{True, False},
			Messages :> {Error::QuantificationRequiresBlanking, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "TooManySamples", "If the combination of NumberOfReplicates * (Number of samples + number of unique blanks) is greater than 94 and we are using the Lunatic, throw an error:"},
			ExperimentAbsorbanceIntensityOptions[
				{Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				NumberOfReplicates -> 50,
				BlankAbsorbance -> True,
				OutputFormat -> List
			],
			{_Rule..},
			Messages :> {Error::AbsSpecTooManySamples, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "BlanksContainSamplesIn", "If the specified Blanks option contains samples that are also inputs, throw an error and return $Failed:"},
			options = ExperimentAbsorbanceIntensityOptions[
				{
					Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]
				},
				Blanks -> {
					Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Automatic
				},
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			{ObjectP[Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages :> {Error::BlanksContainSamplesIn, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "ExtCoeffNotFound", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model:"},
			options = ExperimentAbsorbanceIntensityOptions[Object[Sample, "ExperimentAbsorbanceIntensityOptions Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> List];
			Lookup[options, Wavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options}		
		]
	},
	(* every time a test is run reset $CreatedObjects and erase things at the end *)
	SetUp :> (ClearDownload[]; $CreatedObjects = {}),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensityOptions New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensityOptions New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5,
					sample, sample2, sample3, sample4, sample5, sample6, sample7,

					allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID,DeveloperObject->True|>];
				{
					container,
					container2,
					container3,
					container4,
					container5
				}=UploadSample[
					{
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Name->{
						"Fake container 1 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityOptions New Test Plate 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityOptions New Test Plate 2" <> $SessionUUID,
						"Fake container 2 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID,
						"Fake container 3 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7
				}=UploadSample[
					{
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Acetone, HPLC Grade"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A2",container2},
						{"A1",container4},
						{"A2",container},
						{"A1", container5}
					},
					InitialAmount->{
						200*Microliter,
						200*Microliter,
						300*Microliter,
						300*Microliter,
						200*Microliter,
						200*Microliter,
						200*Microliter
					},
					Name->{
						"ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityOptions Acetone Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityOptions New Test Chemical 2" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (red food dye)" <> $SessionUUID
					}
				];


				allObjs = {
					container, container2, container3, container4, container5,
					sample, sample2, sample3, sample4, sample5, sample6, sample7
				};

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceIntensity],
						Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							QuantifyConcentration -> False,
							Wavelength -> 280 Nanometer,
							NumberOfReplicates -> Null,
							BlankAbsorbance -> True,
							Blanks -> Model[Sample, "Milli-Q water"],
							BlankVolumes -> 200*Microliter,
							Confirm -> False,
							ImageSample -> False,
							Name -> Null,
							Template -> Null
						},
						UnresolvedOptions -> {EquilibrationTime -> 46*Minute}
					|>
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensityOptions New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensityOptions New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentAbsorbanceIntensityOptions tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityOptions New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	),
	Variables :> {allObjsWeCreate, existingObjs},
	Stubs:> {
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	}
];


(* ::Subsection:: *)
(*ExperimentAbsorbanceIntensityPreview*)


DefineTests[ExperimentAbsorbanceIntensityPreview,
	{
		Example[{Basic,"Return Null regardles of the input:"},
			ExperimentAbsorbanceIntensityPreview[Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1" <> $SessionUUID]],
			Null
		],
		Example[{Basic,"Return Null for a plate:"},
			ExperimentAbsorbanceIntensityPreview[Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID]],
			Null
		],
		Example[{Basic,"Returns Null for a list of plates:"},
			ExperimentAbsorbanceIntensityPreview[{Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],Object[Container, Plate,"ExperimentAbsorbanceIntensityPreview New Test Plate 2" <> $SessionUUID]}],
			Null
		]
	},
	(* every time a test is run reset $CreatedObjects and erase things at the end *)
	SetUp :> (ClearDownload[]; $CreatedObjects = {}),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensityPreview New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensityPreview New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Preview function" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5,
					sample, sample2, sample3, sample4, sample5, sample6, sample7,

					allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID,DeveloperObject->True|>];
				{
					container,
					container2,
					container3,
					container4,
					container5
				}=UploadSample[
					{
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Name->{
						"Fake container 1 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityPreview New Test Plate 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityPreview New Test Plate 2" <> $SessionUUID,
						"Fake container 2 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID,
						"Fake container 3 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7
				}=UploadSample[
					{
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Acetone, HPLC Grade"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Red Food Dye"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A2",container2},
						{"A1",container4},
						{"A2",container},
						{"A1",container5}
					},
					InitialAmount->{
						200*Microliter,
						200*Microliter,
						300*Microliter,
						300*Microliter,
						200*Microliter,
						200*Microliter,
						200*Microliter
					},
					Name->{
						"ExperimentAbsorbanceIntensityPreview New Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityPreview New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityPreview Acetone Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityPreview New Test Chemical 2" <> $SessionUUID,
						"ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (red food dye)" <> $SessionUUID
					}
				];


				allObjs = {
					container, container2, container3, container4, container5,
					sample, sample2, sample3, sample4, sample5, sample6, sample7
				};

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceIntensity],
						Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Preview function" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							QuantifyConcentration -> False,
							Wavelength -> Null,
							NumberOfReplicates -> Null,
							BlankAbsorbance -> True,
							Blanks -> Model[Sample, "Milli-Q water"],
							BlankVolumes -> 200*Microliter,
							Confirm -> False,
							ImageSample -> False,
							Name -> Null,
							Template -> Null
						},
						UnresolvedOptions -> {EquilibrationTime -> 46*Minute}
					|>
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensityPreview New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceIntensityPreview New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentAbsorbanceIntensityPreview tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceIntensityPreview New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceIntensity, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Preview function" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	),
	Stubs:> {
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	}
];



(* ::Section:: *)
(*End Test Package*)
