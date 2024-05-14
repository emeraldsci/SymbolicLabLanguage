(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentAbsorbanceSpectroscopy : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AbsorbanceSpectroscopy*)


(* ::Subsubsection:: *)
(*ExperimentAbsorbanceSpectroscopy*)


DefineTests[ExperimentAbsorbanceSpectroscopy,
	{
		Example[{Basic,"Takes a sample object:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID]],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Example[{Basic,"Accepts a list of sample objects:"},
			ExperimentAbsorbanceSpectroscopy[{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Example[{Basic,"Generate protocol for measuring absorbance of samples in a plate object:"},
			ExperimentAbsorbanceSpectroscopy[Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Example[{Basic,"Accepts a list of plate objects:"},
			ExperimentAbsorbanceSpectroscopy[{Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],Object[Container, Plate,"ExperimentAbsorbanceSpectroscopy New Test Plate 2" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Example[{Additional,"Specify the input as {Position,Container}:"},
			ExperimentAbsorbanceSpectroscopy[{"A1",Object[Container, Plate,"ExperimentAbsorbanceSpectroscopy New Test Plate 2" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Example[{Additional,"Specify the input as a mixture of everything}:"},
			ExperimentAbsorbanceSpectroscopy[
				{
					{"A1",Object[Container, Plate, "ExperimentAbsorbanceSpectroscopy New Test Plate 2" <> $SessionUUID]},
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Example[{Additional,"Robotic test call:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Preparation -> Robotic
			],
			ObjectP[],
			Messages:>{Warning::InsufficientVolume}
		],
		Example[{Additional,"Robotic test call with Injection Samples results in the Object[Protocol, RoboticSamplePreparation] fields being filled out (with the same resources as the output unit operation):"},
			Module[{protocol},
				protocol=ExperimentAbsorbanceSpectroscopy[
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Model[Sample,"Milli-Q water"],
					PrimaryInjectionVolume->10 Microliter,
					SecondaryInjectionSample->Model[Sample,"Methanol"],
					SecondaryInjectionVolume->10 Microliter,
					Preparation -> Robotic
				];

				And[
					MatchQ[
						Download[
							Download[protocol, {PrimaryPlateReaderInjectionSample, PrimaryPlateReaderSecondaryInjectionSample}],
							Object
						],
						{Model[Sample, "id:8qZ1VWNmdLBD"], Model[Sample, "id:vXl9j5qEnnRD"]}
					],
					MatchQ[
						Sort@DeleteDuplicates@Cases[
							Download[
								protocol,
								OutputUnitOperations[[1]][RequiredResources]
							],
							{resource_, PrimaryInjectionSampleLink | SecondaryInjectionSampleLink | TertiaryInjectionSample | QuaternaryInjectionSample, ___} :> Download[resource, Object]
						],
						Sort@Cases[
							Download[
								protocol,
								RequiredResources
							],
							{resource_, PrimaryPlateReaderInjectionSample | PrimaryPlateReaderSecondaryInjectionSample, ___} :> Download[resource, Object]
						]
					]
				]
			],
			True,
			Messages:>{Warning::InsufficientVolume}
		],
		Example[{Additional,"Manual test call:"},
			ExperimentSamplePreparation[{
				AbsorbanceSpectroscopy[
					Sample->Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID]
				]
			}],
			ObjectP[]
		],
		Example[{Additional,"Robotic test call fails if given a non compatible container model:"},
			ExperimentRoboticSamplePreparation[{
				AbsorbanceSpectroscopy[
					Sample->Object[Container, Vessel, "Test container 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID]
				]
			}],
			$Failed,
			Messages:>{
				Error::ConflictingMethodRequirements,
				Error::InvalidInput
			}
		],
		Example[{Additional,"Basic simulation call with Preparation->Manual:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Output -> Simulation
			],
			SimulationP
		],
		Example[{Additional,"Simulation with a Moat:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				MoatBuffer -> Model[Sample, "Milli-Q water"],
				Output -> Simulation
			],
			SimulationP
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentAbsorbanceSpectroscopy[Link[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Now - 1 Minute]],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],

		Example[{Options,Methods,"Specify the Method set for the protocol:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Methods -> Microfluidic,Output->Options];
			Lookup[options, Methods],
			Microfluidic,
			Variables :> {options}
		],

		Example[{Options,Methods,"Sets Methods -> Microfluidic if Instrument option and other instrument specific options are not specified:"},
			options = ExperimentAbsorbanceSpectroscopy[{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID]},Output->Options];
			Lookup[options, Methods],
			Microfluidic,
			Variables :> {options}
		],

		Example[{Options,Methods,"If Methods -> Cuvette, instrument resolves to Cary 3500:"},
			options = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Methods->Cuvette,
				Output->Options];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, Spectrophotometer, "id:01G6nvwR99K1"](* Cary 3500 *)],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],

		Example[{Options,Instrument,"If Methods and/or instrument is not specified and no other instrument specific options are provided, sets instrument to Lunatic:"},
			options = Quiet[ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID]},
				QuantifyConcentration->True,
				BlankAbsorbance->True,
				Output->Options],{Warning::RepeatedPlateReaderSamples,Warning::InsufficientVolume,Warning::TotalAliquotVolumeTooLarge}];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, PlateReader, "id:N80DNj1lbD66"](* Lunatic *)],
			Variables :> {options}
		],

		Example[{Messages, "SpectralBandwidthIncompatibleWithPlateReader", "Throws an error if SpectralBandwidth options is not compatible with the instrument:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Methods -> PlateReader,
				SpectralBandwidth -> 1.0 Nanometer
			],
			$Failed,
			Messages :> {Error::SpectralBandwidthIncompatibleWithPlateReader, Error::InvalidOption}
		],

		Example[{Messages, "AcquisitionMixIncompatibleWithPlateReader", "Throws an error if AcquisitionMix option is incompatible with the specified instrument:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Methods -> PlateReader,
				AcquisitionMix -> True
			],
			$Failed,
			Messages :> {Error::AcquisitionMixIncompatibleWithPlateReader, Error::InvalidOption}
		],

		Example[{Messages, "AcquisitionMixRequiredOptions", "If the StirBar, AcquisitionMixRate, AcquisitionMixRateIncrements, AdjustMixRate, and MaxStirAttempts are specified, AcquisitionMix cannot be Null:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Methods ->Cuvette,
				Aliquot -> True,
				AcquisitionMix -> Null,
				AcquisitionMixRate -> Null,
				AcquisitionMixRateIncrements -> 50 RPM
			],
			$Failed,
			Messages :> {Error::AcquisitionMixRequiredOptions, Error::InvalidOption}
		],

		Example[{Messages, "MethodsInstrumentMismatch", "If Methods -> Cuvette and Instrument -> Lunatic, throws an error since the method is not compatible with the instrument:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Methods -> Cuvette,
				Instrument -> Model[Instrument, PlateReader, "Lunatic"]
			],
			$Failed,
			Messages :> {Error::MethodsInstrumentMismatch, Error::InvalidOption}
		],
		Example[{Messages,"AbsorbanceSpectroscopyIncompatibleCuvette","The container in which the samples are to be pooled and measured (AliquotContainer) has to be compatible with the instrument (for example, it has to be made of quartz):"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Methods -> Cuvette,
				(* cuvette not made of quartz *)
				AliquotContainer->Model[Container, Cuvette, "id:M8n3rxYE557M"]
			],
			$Failed,
			Messages:>{Error::AbsorbanceSpectroscopyIncompatibleCuvette, Error::AbsorbanceSpectroscopyCuvetteVolumeOutOfRange, Error::InvalidOption, Error::InvalidInput, Error::DeprecatedModels}
		],
		Example[{Messages,"AbsorbanceSpectroscopyCuvetteVolumeOutOfRange","The assay volume (total volume of samples and buffers inside a particular pool) has to fall within the working range of an available cuvette:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Methods -> Cuvette,
				AliquotContainer -> Model[Container, Cuvette, "id:Y0lXejGKdd1x"]
			],
			$Failed,
			Messages:>{Error::AbsorbanceSpectroscopyCuvetteVolumeOutOfRange,Error::InvalidOption,Warning::AbsSpecInsufficientSampleVolume}
		],
		Example[{Messages,"InvalidAcquisitionMixRateRange","MinAcquisitionMixRate must be smaller than MaxAcquisitionMixRate:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				AcquisitionMix -> True,
				MaxAcquisitionMixRate -> 500 RPM,
				MinAcquisitionMixRate -> 800 RPM
			],
			$Failed,
			Messages:>{Error::InvalidAcquisitionMixRateRange,Error::InvalidOption,Warning::AliquotRequired}
		],

		Example[{Messages,"InvalidCuvettePlateReaderOptions","Throws an error if mixing within the plate reader chamber is being requested, but the method/instrument does not support it:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Methods -> Cuvette,
				Aliquot -> True,
				AcquisitionMix -> True,
				PlateReaderMixRate -> 200 RPM
			],
			$Failed,
			Messages:>{Error::InvalidCuvettePlateReaderOptions,Error::InvalidOption}
		],

		Example[{Messages,"InvalidCuvetteMoatOptions","Throws an error if plate reader moat options is being requested, but the method/instrument does not support it:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Methods -> Cuvette,
				SpectralBandwidth -> 1.0 Nanometer,
				MoatSize->1
			],
			$Failed,
			Messages:>{Error::InvalidCuvetteMoatOptions,Error::InvalidOption}
		],

		Example[{Messages,"InvalidCuvetteSamplingOptions","Throws an error if plate reader sampling options is being requested, but the method/instrument does not support it:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Methods -> Cuvette,
				SpectralBandwidth -> 1.0 Nanometer,
				SamplingPattern -> Ring
			],
			$Failed,
			Messages:>{Error::SamplingPatternMismatch,Error::InvalidCuvetteSamplingOptions,Warning::AliquotRequired,Error::InvalidOption}
		],

		Example[{Messages, "DiscardedSamples", "Throw an error if one or multiple of the input samples are discarded:"},
			ExperimentAbsorbanceSpectroscopy[{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],

		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],ImageSample->True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],ImageSample->True];
			Download[protocol, ImageSample],
			True,
			Variables :> {protocol}
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID]];
			Download[protocol, ImageSample],
			True,
			Variables :> {protocol}
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"], Output -> Options];
			Lookup[options, Instrument],
			Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"],
			Variables :> {options}
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"]];
			Download[protocol, Instrument],
			ObjectP[Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"]],
			Variables :> {protocol}
		],
		Example[{Options,Instrument,"If PlateReaderMix is True, Instrument resolves to the FLUOstar Omega:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], PlateReaderMix -> True];
			Download[protocol, Instrument],
			ObjectP[Model[Instrument, PlateReader, "FLUOstar Omega"]],
			Variables :> {protocol}
		],
		Example[{Options,MicrofluidicChipLoading,"If Instrument is Lunatic, MicrofluidicChipLoading resolves to Robotic:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"]];
			Download[protocol, MicrofluidicChipLoading],
			Robotic,
			Variables :> {protocol}
		],
		Example[{Options,MicrofluidicChipLoading,"If Instrument is not Lunatic, MicrofluidicChipLoading resolves to Null:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]];
			Download[protocol, MicrofluidicChipLoading],
			Null,
			Variables :> {protocol}
		],
		Example[{Messages,MicrofluidicChipLoading,"If Instrument is Lunatic, raise an error if MicrofluidicChipLoading is set to Null:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], MicrofluidicChipLoading -> Null],
			$Failed,
			Messages :> {Error::MicrofluidicChipLoading, Error::InvalidOption},
			Variables :> {protocol}
		],
		Example[{Messages,MicrofluidicChipLoading,"If Instrument is not Lunatic, raise an error if MicrofluidicChipLoading is set to anything other than Null:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], MicrofluidicChipLoading -> Robotic],
			$Failed,
			Messages :> {Error::MicrofluidicChipLoading, Error::InvalidOption},
			Variables :> {protocol}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1"];
			Download[protocol, Name],
			"Absorbance Spectroscopy protocol with sample 1",
			Variables :> {protocol}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1", Output -> Options];
			Lookup[options, Name],
			"Absorbance Spectroscopy protocol with sample 1",
			Variables :> {options}
		],
		Example[{Messages, "DuplicateName", "If the specified Name option already exists as a protocol object, throw an error and return $Failed:"},
			ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				BlankAbsorbance -> True,
				Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID
			],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[{Options, Template, "Set the Template option:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID], Output -> Options];
			Lookup[options, Template],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID], Output -> Options];
			Lookup[options, EquilibrationTime],
			46*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, Template, "Set the Template option:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]];
			Download[protocol, Template],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]];
			Download[protocol, EquilibrationTime],
			46*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		(* TODO make sure you add a test for ParentProtocol *)
		Test["If Confirm -> True, immediately confirm the protocol without sending it into the cart:",
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Confirm -> True];
			Download[protocol, Status],
			Processing|ShippingMaterials|Backlogged,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius];
			Download[protocol, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the spectrophotometer (cary 3500):"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],Temperature -> 45*Celsius];
			Download[protocol, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::AliquotRequired},
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius];
			Download[protocol, Temperature],
			40.2*Celsius,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"If using the Lunatic, Temperature resolves to Null in protocol:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "Lunatic"]];
			Download[protocol, Temperature],
			Null,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"If using a BMG plate reader, Temperature resolves to Ambient (stored as Null):"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]];
			Download[protocol, Temperature],
			Null,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius, Output -> Options];
			Lookup[options, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the spectrophotometer (cary 3500):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],Temperature -> 45*Celsius, Output -> Options];
			Lookup[options, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::AliquotRequired},
			Variables :> {options}
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius, Output -> Options];
			Lookup[options, Temperature],
			40.2*Celsius,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options,Temperature,"If using the Lunatic, Temperature resolves to Ambient in options:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, Temperature],
			Ambient,
			Variables :> {options}
		],
		Example[{Options,Temperature,"If using a BMG plate reader, Temperature resolves to Ambient:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, Temperature],
			Ambient,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute];
			Download[protocol, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the cuvette samples should be equilibrated at the Temperature:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], EquilibrationTime -> 7*Minute];
			Download[protocol, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::AliquotRequired},
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to Null:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"]];
			Download[protocol, EquilibrationTime],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to 0*Minute:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]];
			Download[protocol, EquilibrationTime],
			0*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second];
			Download[protocol, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second (cuvette):"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], EquilibrationTime -> 31.5*Second];
			Download[protocol, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision,Warning::AliquotRequired},
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute, Output -> Options];
			Lookup[options, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to Null:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, EquilibrationTime],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to 0*Minute:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, EquilibrationTime],
			0*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second, Output -> Options];
			Lookup[options, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second (cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], EquilibrationTime -> 31.5*Second, Output -> Options];
			Lookup[options, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision,Warning::AliquotRequired},
			Variables :> {options, protocol}
		],
		Example[{Options,NumberOfReadings,"Indicate that 50 flashes should be performed in order to gather 50 measurements which are averaged together to produce a single reading:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],NumberOfReadings->50][NumberOfReadings],
			50
		],
		Example[{Options,PrimaryInjectionSample,"Indicate that you'd like to inject water into every input sample:"},
			ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID]},
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionVolume->4 Microliter
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]]
		],
		Example[{Options,PrimaryInjectionVolume,"If you'd like to skip the injection for a subset of you samples, use Null as a placeholder in the injection samples list and injection volumes list. Here the 2nd sample will not receive injections:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[
					{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2" <> $SessionUUID]},
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
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 2" <> $SessionUUID],
				SecondaryInjectionVolume->3 Microliter
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]]
		],
		Example[{Options,SecondaryInjectionVolume,"Specify that 3\[Micro]L of \"Injection test sample 2\" should be injected into the input sample in the second injection round:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 2" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter
				],
				SecondaryInjections
			],
			{
				{LinkP[Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 2" <> $SessionUUID]],3.` Microliter}
			}
		],
		Example[{Options,PrimaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the first round of injection:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
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
				ExperimentAbsorbanceSpectroscopy[
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 2" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionFlowRate->400 Microliter/Second
				],
				SecondaryInjectionFlowRate
			],
			400.` Microliter/Second
		],
		Example[{Options,InjectionSampleStorageCondition,"Indicate that the injection samples should be stored at room temperature after the experiment completes:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					InjectionSampleStorageCondition->AmbientStorage
				],
				InjectionStorageCondition
			],
			AmbientStorage
		],
		Example[{Options,ReadDirection,"To decrease the time it takes to read the plate minimize plate carrier movement by setting ReadDirection to SerpentineColumn:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],ReadDirection->SerpentineColumn][ReadDirection],
			SerpentineColumn
		],
		Example[{Options,QuantifyConcentration,"Indicate that the concentration of the input samples should be calculated:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantifyConcentration],
			True,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantifyConcentration,"Indicate that the concentration of the input samples should be calculated (cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantifyConcentration],
			True,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified but QuantificationWavelength is specified, resolve option to True:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, QuantifyConcentration],
			True,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified and QuantificationWavelength is also not specified, resolve option to False:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Output -> Options];
			Lookup[options, QuantifyConcentration],
			False,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"Indicate the wavelength of the quantification that should be calculated:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"],NumberOfReplicates->Null];
			Download[protocol, QuantificationWavelengths],
			{280*Nanometer},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is not specified and QuantificationWavelength is also not specified, resolve option to Null:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID]];
			Download[protocol, QuantificationWavelengths],
			{Null},
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			$Failed,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model (cuvette):"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 2 (1.5 mL)" <> $SessionUUID], QuantifyConcentration -> True],
			$Failed,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, NumberOfReplicates->Null];
			Download[protocol, QuantificationWavelengths],
			{260*Nanometer},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field (cuvette):"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], Methods -> Cuvette, QuantifyConcentration -> True, NumberOfReplicates->Null];
			Download[protocol, QuantificationWavelengths],
			{260*Nanometer},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options,QuantificationWavelength,"Rounds specified QuantificationWavelength to the nearest nanometer:"},
			protocol = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280.477777777*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], NumberOfReplicates->Null];
			Download[protocol, QuantificationWavelengths],
			{280*Nanometer},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"Indicate the wavelength of the quantification that should be calculated:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, QuantificationWavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is not specified and QuantificationWavelength is also not specified, resolve option to Null:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Output -> Options];
			Lookup[options, QuantificationWavelength],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model (cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 2 (1.5 mL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field (cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,QuantificationWavelength,"Rounds specified QuantificationWavelength to the nearest nanometer:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280.477777777*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, QuantificationWavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options, BlankAbsorbance, "Indicate whether the absorbance spectrum should be blanked:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Output -> Options];
			Lookup[options, BlankAbsorbance],
			False,
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]}
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Test["If Blanks is specified and we're also Aliquoting, still successfully makes a protocol object (Cuvette):",
			ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID]},
				Blanks -> {Model[Sample, "Milli-Q water"]},
				Aliquot -> True
			],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Test["If Blanks is specified and we're also Aliquoting, still successfully makes a protocol object (Microfluidic):",
			ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID]},
				Blanks -> {Model[Sample, "Milli-Q water"]},
				Aliquot -> True,
				Methods -> Microfluidic
			],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Test["If Blanks is specified and we're also Aliquoting, still successfully makes a protocol object (PlateReader):",
			ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID]},
				Blanks -> {Model[Sample, "Milli-Q water"]},
				Aliquot -> True,
				Methods -> PlateReader
			],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]]
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to empty list:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False
			];
			Download[protocol, Blanks],
			{},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"],
				Output -> Options
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]],
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			options = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]},
				Output -> Options
			];
			Lookup[options, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to the Solvent if the input sample if one is populated:"},
			options = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Sample with Solvent Field Populated" <> $SessionUUID],
				BlankAbsorbance -> True,
				Output -> Options
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, "Red Food Dye"]],
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			options = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True,
				Output -> Options
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to Null:"},
			options = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False,
				Output -> Options
			];
			Lookup[options, Blanks],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
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
			protocol = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2" <> $SessionUUID]},
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
			protocol = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{200*Microliter, 300*Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a Lunatic, resolve BlankVolumes to 2.1 uL:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "Lunatic"]
			];
			Download[protocol, BlankVolumes],
			{2.1*Microliter, 2.1*Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> False and BlankVolumes is not specified, resolve BlankVolumes to empty list:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> False
			];
			Download[protocol, BlankVolumes],
			{},
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
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
			options = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
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
			options = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			{0.1*Milliliter, 0.15*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages:> {Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a BMG plate reader, resolve BlankVolumes to the volume of the corresponding sample:"},
			options = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			options = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			options = ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> False,
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			options = ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
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
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],PlateReaderMix->True],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM, 30.` Second}
		],
		Example[{Options,PlateReaderMixMode,"Specify how the plate should be moved to perform the mixing:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],PlateReaderMixMode->Orbital],
				PlateReaderMixMode
			],
			Orbital
		],
		Example[{Options,PlateReaderMixRate,"If PlateReaderMixRate is specified, it will automatically turn mixing on and resolve PlateReaderMixTime:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],PlateReaderMixRate->100 RPM],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,100.` RPM, 30.` Second}
		],
		Example[{Options,PlateReaderMixTime,"Specify PlateReaderMixTime to automatically turn mixing on and resolve PlateReaderMixRate:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],PlateReaderMixTime->1 Hour],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM, 1 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,MeasureVolume,"Specify MeasureVolume to indicate if the samples should have their volume measured after the protocol:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],MeasureVolume -> True],
				MeasureVolume
			],
			True
		],
		Example[{Options,MeasureWeight,"Specify MeasureWeight to indicate if the samples should have their weight measured after the protocol:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],MeasureWeight -> True],
				MeasureWeight
			],
			True
		],
		Example[{Options,MoatSize,"Indicate the first two columns and rows and the last two columns and rows of the plate should be filled with water to decrease evaporation of the inner assay samples:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				MoatSize->2,
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]]
		],
		Example[{Options,MoatVolume,"Indicate the volume which should be used to fill each moat well:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				MoatVolume->150 Microliter,
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]]
		],
		Example[{Options,MoatBuffer,"Indicate that each moat well should be filled with water:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				MoatBuffer->Model[Sample,"Milli-Q water"],
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]]
		],
		Example[{Options,RetainCover,"Indicate that the existing lid or plate seal should be left on during the read:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				RetainCover->True,
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]]
		],
		Example[{Options,SamplingPattern,"Indicate that readings should be taken for at the center of the wells for each sample:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],SamplingPattern->Center],
				SamplingPattern
			],
			Center
		],
		Example[{Options,SamplingDimension,"Indicate that 16 readings (4x4) should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],SamplingDimension->4],
				SamplingDimension
			],
			4
		],
		Example[{Options,SamplingDistance,"Indicate the length of the region over which sampling measurements should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],SamplingPattern->Ring,SamplingDistance->5 Millimeter],
				SamplingDistance
			],
			5.` Millimeter
		],
		Example[{Messages,"AbsorbanceSamplingCombinationUnavailable","SamplingDimension is only supported when SamplingPattern->Matrix:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				SamplingPattern->Ring,
				SamplingDimension->4
			],
			$Failed,
			Messages:>{Error::AbsorbanceSamplingCombinationUnavailable,Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedInstrumentSamplingPattern","The Omega can't sample wells using a Matrix pattern:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],SamplingPattern->Matrix],
			$Failed,
			Messages:>{Error::UnsupportedInstrumentSamplingPattern,Error::UnsupportedSamplingPattern,Error::InvalidOption}
		],
		Example[{Messages,"SamplingPatternMismatch","When using an instrument capable of sampling the SamplingPattern can't be set to Null:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],SamplingPattern->Null],
			$Failed,
			Messages:>{Error::SamplingPatternMismatch,Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedSamplingPattern","The Matrix pattern is not allowed in ExperimentAbsorbanceSpectroscopy:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],SamplingPattern->Matrix],
			$Failed,
			Messages:>{Error::UnsupportedSamplingPattern,Error::InvalidOption}
		],
		Example[{Messages,"SamplingPatternMismatch","When using an instrument which doesn't perform sampling the SamplingPattern can't be set:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],Instrument->Model[Instrument,PlateReader,"Lunatic"],SamplingPattern->Center],
			$Failed,
			Messages:>{Error::SamplingPatternMismatch,Error::InvalidOption}
		],
		Test["PlateReaderMix->False causes other mix values to resolve to Null:",
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],PlateReaderMix->False],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixTime->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],PlateReaderMixTime->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixRate->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],PlateReaderMixRate->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Example[{Messages,"MixingParametersRequired","Throws an error if PlateReaderMix->True and PlateReaderMixTime has been set to Null:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
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
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime->3 Minute
			],
			$Failed,
			Messages:>{
				Error::MixingParametersUnneeded,
				Error::InvalidOption
			}
		],

		Example[{Messages,"MixingParametersConflict","Throws an error if PlateReaderMix cannot be resolved because one mixing parameter was specified and another was set to Null:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				PlateReaderMixRate->200 RPM,
				PlateReaderMixTime->Null
			],
			$Failed,
			Messages:>{
				Error::MixingParametersConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PlateReaderMixingUnsupported","Throws an error if mixing within the plate reader chamber is being requested, but the instrument does not support it:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				PlateReaderMix->True,
				Instrument->Model[Instrument, PlateReader, "Lunatic"]
			],
			$Failed,
			Messages:>{
				Error::PlateReaderMixingUnsupported,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PlateReaderInjectionsUnsupported","Throws an error if injections are being requested, but the instrument does not support it:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
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
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
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
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"],
				ReadDirection->SerpentineRow
			],
			$Failed,
			Messages:>{
				Error::PlateReaderReadDirectionUnsupported,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw an error and return early if an input object doesn't exist:"},
			ExperimentAbsorbanceSpectroscopy[{Object[Sample, "Nonexistent object for ExperimentAbsorbanceSpectroscopy testing" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "InvalidInput", "Throw an error if one or multiple of the input samples are discarded:"},
			ExperimentAbsorbanceSpectroscopy[{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput},
			Variables :> {options, protocol}
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the Temperature option is specified with an instrument that does not support it:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Temperature -> 30 Celsius, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, Temperature],
			30 Celsius,
			Messages :> {Error::TemperatureIncompatibleWithPlateReader, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the EquilibrationTime option is specified with an instrument that does not support it:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 10*Minute, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, EquilibrationTime],
			10*Minute,
			Messages :> {Error::TemperatureIncompatibleWithPlateReader, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader model is deprecated:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FlexStation 3"]],
			$Failed,
			Messages :> {Error::DeprecatedInstrument, Error::InvalidInput},
			Variables :> {options, protocol}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader object is retired:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Object[Instrument, PlateReader, "Flexstation"]],
			$Failed,
			Messages :> {Error::UnsupportedPlateReader, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "ConcentrationWavelengthMismatch", "Returns an error if QuantifyConcentration is set to False and a QuantificationWavelength has been provided:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantifyConcentration->False,QuantificationWavelength->280 Nanometer, Output -> Options];
			Lookup[options, {QuantifyConcentration, QuantificationWavelength}],
			{False, 280*Nanometer},
			EquivalenceFunction -> Equal,
			Messages :> {Error::ConcentrationWavelengthMismatch, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "ConcentrationWavelengthMismatch", "Returns an error if QuantifyConcentration is set to True and a QuantificationWavelength has been set to Null (Cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], QuantifyConcentration->True,QuantificationWavelength->Null, Output -> Options];
			Lookup[options, {QuantifyConcentration, QuantificationWavelength}],
			{True, Null},
			Messages :> {Error::ConcentrationWavelengthMismatch, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "ConcentrationWavelengthMismatch", "Returns an error if QuantifyConcentration is set to True and a QuantificationWavelength has been set to Null (Microfluidic):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], QuantifyConcentration->True,QuantificationWavelength->Null, Methods->Microfluidic,Output -> Options];
			Lookup[options, {QuantifyConcentration, QuantificationWavelength}],
			{True, Null},
			Messages :> {Error::ConcentrationWavelengthMismatch, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and Blanks -> Null:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, Blanks -> Null, Output -> Options];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and BlankVolumes -> Null:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, BlankVolumes -> Null, Output -> Options];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::BlankVolumeNotRecommended, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and Blanks is specified:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Blanks -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{False, ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and BlankVolumes is specified:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, BlankVolumes -> 2*Microliter, Output -> Options];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{False, 2*Microliter},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "BlankVolumeNotRecommended", "Returns an error if using the Lunatic and BlankVolumes is anything but 2.1*Microliter:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], BlankVolumes -> 10*Microliter, Output -> Options];
			Lookup[options, BlankVolumes],
			10*Microliter,
			Messages :> {Error::BlankVolumeNotRecommended, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "QuantificationRequiresBlanking", "Returns an error if QuantifyConcentration -> True and BlankAbsorbance -> False (Cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID],QuantifyConcentration -> True, BlankAbsorbance -> False, Output -> Options];
			Lookup[options, {QuantifyConcentration, BlankAbsorbance}],
			{True, False},
			Messages :> {Error::QuantificationRequiresBlanking, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "QuantificationRequiresBlanking", "Returns an error if QuantifyConcentration -> True and BlankAbsorbance -> False (Microfluidic):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],QuantifyConcentration -> True, BlankAbsorbance -> False, Methods->Microfluidic, Output -> Options];
			Lookup[options, {QuantifyConcentration, BlankAbsorbance}],
			{True, False},
			Messages :> {Error::QuantificationRequiresBlanking, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "AbsSpecTooManySamples", "If the combination of NumberOfReplicates * (Number of samples + number of unique blanks) is greater than 94 and we are using the Lunatic, throw an error:"},
			ExperimentAbsorbanceSpectroscopy[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			options = ExperimentAbsorbanceSpectroscopy[
				{
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]
				},
				Blanks -> {
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Automatic
				},
				Output -> Options
			];
			Lookup[options, Blanks],
			{ObjectP@Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID],ObjectP@Model[Sample, "Milli-Q water"]},
			Messages :> {Error::BlanksContainSamplesIn, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "ExtCoeffNotFound", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model (Cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 2 (1.5 mL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Messages, "ExtCoeffNotFound", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model (Microfluidic):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Messages, "ExtinctionCoefficientMissing", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model (Cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 2 (1.5 mL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			Messages :> {Error::ExtinctionCoefficientMissing, Warning::ExtCoeffNotFound, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Messages, "ExtinctionCoefficientMissing", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model (Microfluidic):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			Messages :> {Error::ExtinctionCoefficientMissing, Warning::ExtCoeffNotFound, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Messages, "SampleMustContainQuantificationAnalyte", "If QuantificationAnalyte is specified, it must be a component of the input sample:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"]],
			$Failed,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::SampleMustContainQuantificationAnalyte, Error::InvalidOption}
		],
		Example[{Messages, "AliquotRequired", "If the sample must be aliquoted but no aliquot options are specified, throw a warning telling the user:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options],
			{__Rule},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Messages, "AmbiguousAnalyte", "If the sample has multiple potential analytes and the QuantificationAnalyte option is not specified, throw a warning stating that one has been chosen arbitrarily:"},
			Lookup[ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options], QuantificationAnalyte],
			ObjectP[Model[Molecule, Oligomer]],
			Messages :> {Warning::ExtCoeffNotFound, Warning::AmbiguousAnalyte}
		],
		Example[{Messages, "AmbiguousAnalyte", "If the sample has multiple potential analytes and the QuantificationAnalyte option is specified, do not throw a warning:"},
			Lookup[ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"], Output -> Options], QuantificationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "ACTH 18-39"]],
			Messages :> {Warning::ExtCoeffNotFound}
		],
		Example[{Messages, "AmbiguousAnalyte", "If the sample has multiple potential analytes and the QuantificationAnalyte option is not specified but we aren't actually quantifying, don't throw an error:"},
			Lookup[ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID], Output -> Options], QuantificationAnalyte],
			Null
		],
		Example[{Messages, "CoveredInjections", "As injections are made into the top of the plate, RetainCover cannot be set to True:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				RetainCover->True,
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionVolume->5 Microliter
			],
			$Failed,
			Messages :> {Error::CoveredInjections,Error::InvalidOption}
		],
		Example[{Messages, "CoverUnsupported", "A plate based reader must be specified to use RetainCover:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				RetainCover->True
			],
			$Failed,
			Messages :> {Error::CoverUnsupported,Error::InvalidOption}
		],
		Example[{Messages, "AliquotRequired", "If the sample must be aliquoted but no aliquot options are specified, throw a warning telling the user:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options],
			{__Rule},
			Messages :> {Warning::AliquotRequired}
		],
		Test["If Output -> Tests, return a list of tests:",
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID], Output -> Tests],
			{__EmeraldTest},
			Variables :> {options, protocol}
		],
		Test["If Output -> Options, return a list of resolved options:",
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID],EquilibrationTime->10 Minute, Output -> Options],
			{__Rule},
			Variables :> {options, protocol}
		],
		Test["If Output is to all values, return all of these values:",
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID],EquilibrationTime->10 Minute, Output -> {Result, Tests, Options, Preview}],
			{
				ObjectP[Object[Protocol, AbsorbanceSpectroscopy]],
				{__EmeraldTest},
				{__Rule},
				Null
			}
		],


		(* -- Primitive tests -- *)
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with Preparation->Robotic:",
			Experiment[{
				AbsorbanceSpectroscopy[
					Sample->Object[Sample,"ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID],
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]],
			Messages:>{
				Warning::InsufficientVolume
			}
		],
		Test["Generate an AbsorbanceSpectroscopy protocol object based on a single primitive with Preparation->Manual:",
			Experiment[{
				AbsorbanceSpectroscopy[
					Sample -> Object[Sample,"ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID],
					Preparation -> Manual
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with injection options specified:",
			Experiment[{
				AbsorbanceSpectroscopy[
					Sample->Object[Sample,"ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID],
					Preparation -> Robotic,
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					InjectionSampleStorageCondition->AmbientStorage
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]],
			Messages:>{
				Warning::InsufficientVolume
			}
		],

		Example[{Options, SamplesInStorageCondition, "Populate the SamplesInStorage field:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, NumberOfReplicates -> 2, Methods -> Microfluidic],
				SamplesInStorage
			],
			{Refrigerator, Refrigerator}
		],

		Example[{Options, NumberOfReplicates, "Populate SamplesIn in accordance with NumberOfReplicates:"},
			Download[
				ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], NumberOfReplicates -> 2, Methods -> Microfluidic],
				SamplesIn[Object]
			],
			{ObjectP[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID]], ObjectP[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID]]}
		],

		(* sample prep tests *)
		Example[{Additional, "Perform all sample prep experiments on one sample (Cuvette):"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], Incubate -> True, Mix -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]],
			TimeConstraint -> 2000
		],
		Example[{Additional, "Perform all sample prep experiments on one sample (Microfluidic):"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], Incubate -> True, Mix -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True, Methods -> Microfluidic],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]],
			TimeConstraint -> 2000
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to create test standards prior to running the experiment:"},
			protocol = ExperimentAbsorbanceSpectroscopy[
				{"red dye sample", Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			protocol = ExperimentAbsorbanceSpectroscopy[
				{"red dye sample", Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the position in the incubate aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquot -> 100*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, IncubateAliquot],
			100*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired,Warning::AbsSpecInsufficientSampleVolume}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the position in the centrifuge aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], CentrifugeTime -> 40*Minute, Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquot -> 150*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, CentrifugeAliquot],
			150.*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], Filtration -> True, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Syringe, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterInstrument -> Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates the position in the filter aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], FilterAliquotDestinationWell -> "A2", Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options},
			Messages :> {Warning::AliquotRequired},
			TimeConstraint->300
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterMaterial -> PES,Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment (cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], PrefilterMaterial -> GxF, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment (platereader):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], PrefilterMaterial -> GxF, FilterMaterial -> PTFE, Methods -> PlateReader, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment (Cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment (PlateReader):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Methods -> PlateReader, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterSyringe, "The syringe used to force the sample through a filter:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterHousing, "FilterHousing resolves to Null for all reasonably-small samples that might be used in this experiment (Cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterHousing, "FilterHousing resolves to Null for all reasonably-small samples that might be used in this experiment (PlateReader):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], Filtration -> True, Methods -> PlateReader, Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment (Cuvette):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment (PlateReader):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID], FilterSterile -> True, Methods -> PlateReader, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquot -> 100*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquot],
			100*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired,Warning::AbsSpecInsufficientSampleVolume}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired},
			TimeConstraint->300
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Indicates the position in the AliquotContainer that we want to move the sample into:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], DestinationWell -> "A2", Output -> Options];
			Lookup[options, DestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 300*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The specific analyte to get to the specified target concentration:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, TargetConcentrationAnalyte -> Model[Molecule, "Water"], AssayVolume -> 300*Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Water"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "If instrument is set to the Lunatic, ConsolidateAliquots is automatically set to True:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], Output -> Options];
			Lookup[options, AliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well UV-Star Plate"]]},
			Variables :> {options}
		],
		Example[{Messages,"InvalidBlankContainer","Throws an error because no blank volume has been specified but blank Buffer 1 is in a 50mL tube and must be transferred into the assay container to be read:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ExperimentAbsorbanceSpectroscopy Blank Buffer 1" <> $SessionUUID],
				BlankVolumes->Null
			],
			$Failed,
			Messages:>{Error::InvalidBlankContainer,Error::InvalidOption}
		],
		Example[{Messages,"UnnecessaryBlankTransfer","Specifying a blank volume indicates that an aliquot of the blank should be taken and read. Gives a warning if this is set to happen even though the blank is already in a valid container:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ExperimentAbsorbanceSpectroscopy Blank Buffer 3" <> $SessionUUID],
				BlankVolumes->100 Microliter
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]],
			Messages:>{Warning::UnnecessaryBlankTransfer,Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Messages,"NotEqualBlankVolumesWarning","Print a warning message if the blank volume is not equal to the volume of the sample:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ExperimentAbsorbanceSpectroscopy Blank Buffer 3" <> $SessionUUID],
				BlankVolumes->100 Microliter
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]],
			Messages:>{Warning::UnnecessaryBlankTransfer,Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Messages,"ReplicateAliquotsRequired","Throws an error if replicates are specified and Aliquot->False since replicates are performed by reading multiple aliquots of the same sample:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				Aliquot->False,
				NumberOfReplicates->2
			],
			$Failed,
			Messages:>{Error::ReplicateAliquotsRequired,Error::InvalidOption}
		],
		Example[{Messages,"RepeatedPlateReaderSamples","Throws an error if the same sample is repeated multiple times and Aliquot->False since repeat readings are performed by reading multiple aliquots of the same sample:"},
			ExperimentAbsorbanceSpectroscopy[
				{
					Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
					Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID]
				},
				Aliquot->False,
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			$Failed,
			Messages:>{Error::RepeatedPlateReaderSamples,Error::InvalidOption}
		],
		Example[{Messages,"ReplicateAliquotsRequired","Prints a warning if aliquots will be generated in order to make replicate readings:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				NumberOfReplicates->2
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]],
			Messages:>{Warning::ReplicateAliquotsRequired}
		],
		Example[{Messages,"RepeatedPlateReaderSamples","Prints a warning if aliquots will be generated in order to make repeat readings of the same sample:"},
			ExperimentAbsorbanceSpectroscopy[
				{
					Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID]
				},
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]],
			Messages:>{Warning::RepeatedPlateReaderSamples}
		],
		Test["When Blanks are already in a valid container, resolves BlankVolume to match the volume of the sample:",
			Lookup[
				ExperimentAbsorbanceSpectroscopy[
					Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
					Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
					Blanks->Object[Sample,"ExperimentAbsorbanceSpectroscopy Blank Buffer 1" <> $SessionUUID],
					Output->Options
				],
				BlankVolumes
			],
			0.0002` Liter
		],
		Test["When Blanks are already in a valid container, resolves BlankVolume->Null:",
			Lookup[
				ExperimentAbsorbanceSpectroscopy[
					Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
					Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
					Blanks->Object[Sample,"ExperimentAbsorbanceSpectroscopy Blank Buffer 3" <> $SessionUUID],
					Output->Options
				],
				BlankVolumes
			],
			Null
		],
		Example[{Messages,"ReplicateChipSpace","Warns the user if the sample is being quantified but there is not enough space available to do the expected number of replicates:"},
			ExperimentAbsorbanceSpectroscopy[
				Object[Container, Plate, "Test container 11 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				QuantifyConcentration -> True,
				QuantificationWavelength -> 280 Nanometer
			],
			ObjectP[Object[Protocol,AbsorbanceSpectroscopy]],
			Messages:>{Warning::ReplicateChipSpace},
			TimeConstraint->300
		],
		Test["Creates resources for everything needed in the experiment:",
			Sort@DeleteDuplicates@Download[
				ExperimentAbsorbanceSpectroscopy[
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					InjectionSampleStorageCondition->AmbientStorage,
					Blanks -> Model[Sample, "Milli-Q water"]
				],
				RequiredResources[[All, 2]]
			],
			Sort@{
				BlankContainers,Blanks,Checkpoints,ContainersIn,Instrument,Null,PrimaryFlushingSolvent,PrimaryInjections,PrimaryPreppingSolvent,
				SamplesIn,SecondaryFlushingSolvent,SecondaryPreppingSolvent
			}
		],
		Example[{Options, QuantificationAnalyte, "Specify the desired component to be quantified:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, "Red Food Dye"], Output -> Options];
			Lookup[options, QuantificationAnalyte],
			ObjectP[Model[Molecule, "Red Food Dye"]],
			Variables :> {options}
		],
		Example[{Options, QuantificationAnalyte, "If not specified, automatically set to an identity model in the Analytes (or, if not populated, Composition) field of the sample:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID], QuantifyConcentration -> True, Output -> Options];
			Lookup[options, QuantificationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "ACTH 18-39"]],
			Variables :> {options},
			Messages :> {Warning::ExtCoeffNotFound}
		],
		Example[{Options, QuantificationAnalyte, "If the QuantificationAnalyte option resolves to a peptide, set the QuantificationWavelength to 280 nm:"},
			options = ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"], Output -> Options];
			Lookup[options, QuantificationWavelength],
			EqualP[280 Nanometer],
			Variables :> {options},
			Messages :> {Warning::ExtCoeffNotFound}
		],
		Example[{Options, QuantificationAnalyte, "If the QuantificationAnalyte option is set, QuantifyConcentration cannot be False:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"], QuantifyConcentration -> False],
			$Failed,
			Messages :> {Error::ConcentrationWavelengthMismatch, Error::InvalidOption}
		],
		Example[{Additional, "If the input sample has no model, still successfully returns a protocol:"},
			ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID]],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy]],
			TimeConstraint -> 2000
		]
	(*Example[{Additional, "If the input sample has no model, still successfully returns a protocol when running all the sample prep options:"},
		ExperimentAbsorbanceSpectroscopy[Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID], Incubate -> True, Mix -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True],
		ObjectP[Object[Protocol, AbsorbanceSpectroscopy]],
		TimeConstraint -> 2000
	],*)
	},
	(* every time a test is run reset $CreatedObjects and erase things at the end *)
	SetUp :> (ClearDownload[]; ClearMemoization[]; $CreatedObjects = {}),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Test bench for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],

				Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopy New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopy New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Test container 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 19 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 10 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 11 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 16 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Standard Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Standard Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Standard Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Standard Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Semi-Micro Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Semi-Micro Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Semi-Micro Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Semi-Micro Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Micro Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Micro Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Micro Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Micro Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],

				Object[Part, StirBar, "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID],
				Object[Part, StirBar, "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID],
				Object[Part, StirBar, "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID],
				Object[Part, StirBar, "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID],
				Object[Part, StirBar, "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID],
				Object[Part, StirBar, "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID],
				Object[Part, StirBar, "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID],
				Object[Part, StirBar, "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID],
				Object[Part, StirBar, "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID],
				Object[Part, StirBar, "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID],
				Object[Part, StirBar, "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID],
				Object[Part, StirBar, "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID],

				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 5" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 6" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Sample with Solvent Field Populated" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Blank Buffer 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Blank Buffer 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Blank Buffer 3" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 2 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 2 (1.5 mL)" <> $SessionUUID],


				Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 2" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11,
					container12, container13, container14, container15, container16, container17, container18, container19, cuvette1, cuvette2, cuvette3, cuvette4, cuvette5, cuvette6, cuvette7, cuvette8, cuvette9, cuvette10, cuvette11, cuvette12, sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
					sample13, sample14, sample15, sample16, sample17,sample18,sample19, sample20, sample21, plateSamples, allObjs, stirBars, cuvetteCaps, stirBarObjs, cuvetteCapsObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,DeveloperObject->True|>];

				(* make stir bars for cuvettes *)
				stirBars = {
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:xRO9n3BLRZZO"], Objects],
						Name -> "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:xRO9n3BLRZZO"], Objects],
						Name -> "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:xRO9n3BLRZZO"], Objects],
						Name -> "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:xRO9n3BLRZZO"], Objects],
						Name -> "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:Z1lqpMza1XPV"], Objects],
						Name -> "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:Z1lqpMza1XPV"], Objects],
						Name -> "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:Z1lqpMza1XPV"], Objects],
						Name -> "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:Z1lqpMza1XPV"], Objects],
						Name -> "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:Y0lXejMD0VKP"], Objects],
						Name -> "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:Y0lXejMD0VKP"], Objects],
						Name -> "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:Y0lXejMD0VKP"], Objects],
						Name -> "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>,
					<|
						Type -> Object[Part, StirBar],
						Model -> Link[Model[Part, StirBar, "id:Y0lXejMD0VKP"], Objects],
						Name -> "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						DateStocked -> DateObject[List[2013, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						DateUnsealed -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Replace[StorageConditionLog] ->List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]]
					|>
				};


				(* make cuvette caps for containers *)

				cuvetteCaps = {
					<|
						Type -> Object[Item, Cap],
						Model -> Link[Model[Item, Cap, "id:xRO9n3BM1BaO"], Objects],
						Name -> "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						Replace[StorageConditionLog] -> List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]],
						DateStocked ->DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant","Gregorian", -7.`],
						Reusable -> True
					|>,
					<|
						Type -> Object[Item, Cap],
						Model -> Link[Model[Item, Cap, "id:xRO9n3BM1BaO"], Objects],
						Name -> "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						Replace[StorageConditionLog] -> List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]],
						DateStocked ->DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant","Gregorian", -7.`],
						Reusable -> True
					|>,
					<|
						Type -> Object[Item, Cap],
						Model -> Link[Model[Item, Cap, "id:xRO9n3BM1BaO"], Objects],
						Name -> "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						Replace[StorageConditionLog] -> List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]],
						DateStocked ->DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant","Gregorian", -7.`],
						Reusable -> True
					|>,
					<|
						Type -> Object[Item, Cap],
						Model -> Link[Model[Item, Cap, "id:xRO9n3BM1BaO"], Objects],
						Name -> "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						Replace[StorageConditionLog] -> List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]],
						DateStocked ->DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant","Gregorian", -7.`],
						Reusable -> True
					|>,
					<|
						Type -> Object[Item, Cap],
						Model -> Link[Model[Item, Cap, "id:xRO9n3BM1BaO"], Objects],
						Name -> "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 5" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						Replace[StorageConditionLog] -> List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]],
						DateStocked ->DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant","Gregorian", -7.`],
						Reusable -> True
					|>,
					<|
						Type -> Object[Item, Cap],
						Model -> Link[Model[Item, Cap, "id:xRO9n3BM1BaO"], Objects],
						Name -> "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 6" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Status -> Available,
						Replace[StorageConditionLog] -> List[List[DateObject[List[2022, 4, 25, 12, 29, 22.`], "Instant","Gregorian", -7.`],Link[Model[StorageCondition, "id:7X104vnR18vX"]],Link[Object[User, Emerald, Developer, "id:qdkmxzqMB8Px"]]]],
						DateStocked ->DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant","Gregorian", -7.`],
						Reusable -> True
					|>
				};

				(* Upload cuvette stir bars *)
				stirBarObjs = Upload[Flatten[stirBars]];

				cuvetteCapsObjs = Upload[Flatten[cuvetteCaps]];

				(* upload stir bar locations *)
				UploadLocation[Flatten[{stirBarObjs, cuvetteCapsObjs}],{"Work Surface",fakeBench}];

				{
					container,
					container2,
					container3,
					container4,
					container19,
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
					container17,
					container18,
					cuvette1,
					cuvette2,
					cuvette3,
					cuvette4,
					cuvette5,
					cuvette6,
					cuvette7,
					cuvette8,
					cuvette9,
					cuvette10,
					cuvette11,
					cuvette12
				}=UploadSample[
					{
						Model[Container, Plate, "96-well UV-Star Plate"],
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
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Cuvette, "id:mnk9jOR4n89R"],
						Model[Container, Cuvette, "id:mnk9jOR4n89R"],
						Model[Container, Cuvette, "id:mnk9jOR4n89R"],
						Model[Container, Cuvette, "id:mnk9jOR4n89R"],
						Model[Container, Cuvette, "id:Y0lXejMD0VBm"],
						Model[Container, Cuvette, "id:Y0lXejMD0VBm"],
						Model[Container, Cuvette, "id:Y0lXejMD0VBm"],
						Model[Container, Cuvette, "id:Y0lXejMD0VBm"],
						Model[Container, Cuvette, "id:Vrbp1jKkre0x"],
						Model[Container, Cuvette, "id:Vrbp1jKkre0x"],
						Model[Container, Cuvette, "id:Vrbp1jKkre0x"],
						Model[Container, Cuvette, "id:Vrbp1jKkre0x"]
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
						"Test container 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Plate 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Plate 2" <> $SessionUUID,
						"Test container 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 19 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 5 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 6 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 7 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 8 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 9 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 10 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 11 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 12 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 13 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 14 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 15 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test container 16 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Standard Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Standard Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Standard Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Standard Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Semi-Micro Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Semi-Micro Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Semi-Micro Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Semi-Micro Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Micro Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Micro Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Micro Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID,
						"Test Micro Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID
					}
				];

				{
					sample,
					sample2,
					sample3,
					sample4,
					sample21,
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
					sample19,
					sample20
				}=UploadSample[
					{
						Model[Sample, "Red Food Dye"],
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
						Model[Sample, "Leucine Enkephalin (Oligomer)"],
						Model[Sample, "Acetone, HPLC Grade"]
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A2",container2},
						{"A1",container19},
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
						{"A1",container13},
						{"A1",container14},
						{"A1",container15},
						{"A1",container16},
						{"A1",container18}
					},
					State -> Liquid,
					InitialAmount->{
						200*Microliter,
						200*Microliter,
						300*Microliter,
						300*Microliter,
						200*Microliter,
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
						200*Microliter,
						1.5*Milliliter
					},
					Name->{
						"ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy Sample with Solvent Field Populated" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Chemical 2" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy Injection 2" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy Blank Buffer 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy Blank Buffer 2" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy Blank Buffer 3" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 2 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 2 (1.5 mL)" <> $SessionUUID
					}
				];

				plateSamples=UploadSample[
					ConstantArray[Model[Sample, "ACTH 18-39"],32],
					{#,container13}&/@Take[Flatten[AllWells[]], 32],
					InitialAmount->ConstantArray[200 Microliter,32],
					State -> Liquid
				];

				(* Raw upload to the solvent field for the Sample with Solvent Sample *)
				Upload[
					<|
					  Object->sample21,
						Solvent -> Link[Model[Sample, "Red Food Dye"]]
					|>
				];


				allObjs = Join[
					{
						container, container2, container3, container4, container5, container6, container7, container8,
						container9, container10, container11, container12, container13, container14,container15,container16, container18, container19,
						cuvette1, cuvette2, cuvette3, cuvette4, cuvette5, cuvette6, cuvette7, cuvette8, cuvette9, cuvette10, cuvette11, cuvette12,
						sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
						sample13,sample14,sample15, sample16, sample17,sample18,sample19, sample20, sample21
					},
					plateSamples
				];

				UploadSampleTransfer[
					Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID],
					Object[Sample,"ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID],
					100 Microliter
				];

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceSpectroscopy],
						Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							QuantifyConcentration -> False,
							QuantificationWavelength -> Null,
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
					<|Object -> Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID], Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Water"]]}}|>,
					(* test on a model-less sample *)
					<|Object -> sample19, Model -> Null|>
				}]];

				(* upload more fields for cuvettes *)
				Upload[
					<|
						Object -> #,
						TareWeight -> Quantity[18.9194`, "Grams"],
						TareWeightDistribution -> DataDistribution["Empirical", List[List[1.`], List[18.9194`], False], 1, 3, "Grams"],
						Replace[TareWeightLog] -> List[List[DateObject[List[2019, 5, 17, 17, 20, 1.`], "Instant","Gregorian", -7.`], Quantity[18.9194`, "Grams"],Link[Object[Protocol, MeasureWeight, "id:O81aEBZlKLMX"]]]],
						DateStocked -> DateObject[List[2014, 9, 11, 13, 17, 0.`], "Instant", "Gregorian", -7.`],
						Product -> Link[Object[Product, "id:Z1lqpMGVGGmM"], Samples],
						Position -> "A1",
						(* TODO: delete developerobject->false when done testing engine *)
						DeveloperObject->False
					|>
				]&/@{cuvette1, cuvette2, cuvette3, cuvette4, cuvette5, cuvette6, cuvette7, cuvette8, cuvette9, cuvette10, cuvette11, cuvette12};

				(* upload positions for stir bars *)
				Upload[
					<|
						Object -> #,
						Position -> "A1",
						(* TODO: delete developerobject->false when done testing engine *)
						DeveloperObject->False
					|>
				]&/@Flatten[stirBarObjs];

				UploadSampleStatus[sample4, Discarded, FastTrack -> True]
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Test bench for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],

				Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopy New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopy New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Test container 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 19 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 10 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 11 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 12 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 13 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 14 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 15 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 16 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Standard Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Standard Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Standard Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Standard Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Semi-Micro Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Semi-Micro Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Semi-Micro Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Semi-Micro Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Micro Cuvette with Stirring 1 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Micro Cuvette with Stirring 2 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Micro Cuvette with Stirring 3 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],
				Object[Container,Cuvette,"Test Micro Cuvette with Stirring 4 for ExperimentAbsorbanceSpectroscopy tests" <> $SessionUUID],

				Object[Part, StirBar, "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID],
				Object[Part, StirBar, "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID],
				Object[Part, StirBar, "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID],
				Object[Part, StirBar, "Test Standard Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID],
				Object[Part, StirBar, "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID],
				Object[Part, StirBar, "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID],
				Object[Part, StirBar, "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID],
				Object[Part, StirBar, "Test Semi-Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID],
				Object[Part, StirBar, "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID],
				Object[Part, StirBar, "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID],
				Object[Part, StirBar, "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID],
				Object[Part, StirBar, "Test Micro Cuvette stir bar for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID],

				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 1" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 2" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 3" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 4" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 5" <> $SessionUUID],
				Object[Item, Cap, "Test Cuvette Cap 18x17mm for ExperimentAbsorbanceSpectroscopy 6" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Sample with Solvent Field Populated" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Chemical 1 (red food dye)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Injection 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Blank Buffer 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Blank Buffer 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Blank Buffer 3" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 2 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 3 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 4 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy New Test Peptide oligomer 5 (200 uL), no model" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopy Acetone Test Chemical 2 (1.5 mL)" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time" <> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			ClearMemoization[];
		]
	),
	Variables :> {allObjsWeCreate, existingObjs},
	Stubs:> {
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"],
		$AllowSystemsProtocols = True
	}
];


(* ::Subsection:: *)
(*ValidExperimentAbsorbanceSpectroscopyQ*)


DefineTests[ValidExperimentAbsorbanceSpectroscopyQ,
	{
		Example[{Basic,"Takes a sample object:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Accepts a list of sample objects:"},
			ValidExperimentAbsorbanceSpectroscopyQ[{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample,"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID]}],
			True
		],
		Example[{Basic,"Generate protocol for measuring absorbance of samples in a plate object:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Container, Plate, "Test container 1 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Accepts a list of plate objects:"},
			ValidExperimentAbsorbanceSpectroscopyQ[{Object[Container, Plate, "Test container 1 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],Object[Container, Plate,"ValidExperimentAbsorbanceSpectroscopyQ New Test Plate 2" <> $SessionUUID]}],
			True
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],ImageSample->True],
			True
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID]],
			True
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"]],
			True
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1 for ValidQ function"],
			True
		],
		Example[{Messages, "DuplicateName", "If the specified Name option already exists as a protocol object, throw an error and return $Failed:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				BlankAbsorbance -> True,
				Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID
			],
			False
		],
		Example[{Options, Template, "Set the Template option:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID]],
			True
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID]],
			True
		],
		Test["If Confirm -> True, immediately confirm the protocol without sending it into the cart:",
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Confirm -> True],
			True
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius],
			True
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius],
			True
		],
		Example[{Options,Temperature,"If using the Lunatic, Temperature resolves to Null:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			True
		],
		Example[{Options,Temperature,"If using a BMG plate reader, Temperature resolves to Ambient:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]],
			True
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute],
			True
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to Null:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			True
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to 0*Minute:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]],
			True
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second],
			True
		],
		Example[{Options,QuantifyConcentration,"Indicate that the concentration of the input samples should be calculated:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			True
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified but QuantificationWavelength is specified, resolve option to True:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			True
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified and QuantificationWavelength is also not specified, resolve option to False:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID]],
			True
		],
		Example[{Options,QuantificationWavelength,"Indicate the wavelength of the quantification that should be calculated:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			True
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is not specified and QuantificationWavelength is also not specified, resolve option to Null:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID]],
			True
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model (and throw a warning):"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			False
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			True
		],
		Example[{Options,QuantificationWavelength,"Rounds specified QuantificationWavelength to the nearest nanometer:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280.477777777*Nanometer],
			True
		],
		Example[{Options, BlankAbsorbance, "Indicate whether the absorbance spectrum should be blanked:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False],
			True
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]
			],
			True
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]}
			],
			True
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True
			],
			True
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to Null:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False
			],
			True
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.1*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			],
			True
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample, using multiple samples:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			],
			True
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a BMG plate reader, resolve BlankVolumes to the volume of the corresponding sample:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			],
			True
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a Lunatic, resolve BlankVolumes to 2 uL:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "Lunatic"]
			],
			True
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> False and BlankVolumes is not specified, resolve BlankVolumes to Null:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> False
			],
			True
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.111112544771*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			],
			True
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to create test standards prior to running the experiment:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{"red dye sample", Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "red dye sample", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Red Food Dye"], Amount -> 200*Microliter, Destination -> "red dye sample"]
				}
			],
			True
		],
		Example[{Messages, "DiscardedSamples", "Throw an error if one or multiple of the input samples are discarded:"},
			ValidExperimentAbsorbanceSpectroscopyQ[{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			False
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the Temperature option is specified with an instrument that does not support it:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Temperature -> 30 Celsius, Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			False
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the EquilibrationTime option is specified with an instrument that does not support it:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 10*Minute, Instrument -> Model[Instrument, PlateReader, "Lunatic"]],
			False
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader model is deprecated:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FlexStation 3"]],
			False
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader object is retired:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Instrument -> Object[Instrument, PlateReader, "Flexstation"]],
			False
		],
		Example[{Messages, "ConcentrationWavelengthMismatch", "Returns an error if QuantifyConcentration is set to False and a QuantificationWavelength has been provided:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantifyConcentration->False,QuantificationWavelength->280 Nanometer],
			False
		],
		Example[{Messages, "ConcentrationWavelengthMismatch", "Returns an error if QuantifyConcentration is set to True and a QuantificationWavelength has been set to Null:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], QuantifyConcentration->True,QuantificationWavelength->Null],
			False
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and Blanks -> Null:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, Blanks -> Null],
			False
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and BlankVolumes -> Null:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, BlankVolumes -> Null],
			False
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and Blanks is specified:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Blanks -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and BlankVolumes is specified:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, BlankVolumes -> 2*Microliter],
			False
		],
		Example[{Messages, "BlankVolumeNotRecommended", "Returns an error if using the Lunatic and BlankVolumes is anything but 2.1*Microliter:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], BlankVolumes -> 10*Microliter],
			False
		],
		Example[{Messages, "QuantificationRequiresBlanking", "Returns an error if QuantifyConcentration -> True and BlankAbsorbance -> False:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],QuantifyConcentration -> True, BlankAbsorbance -> False],
			False
		],
		Example[{Messages, "TooManySamples", "If the combination of NumberOfReplicates * (Number of samples + number of unique blanks) is greater than 94 and we are using the Lunatic, throw an error:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				NumberOfReplicates -> 50,
				BlankAbsorbance -> True
			],
			False
		],
		Example[{Messages, "BlanksContainSamplesIn", "If the specified Blanks option contains samples that are also inputs, throw an error and return $Failed:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				{
					Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID]
				},
				Blanks -> {
					Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Automatic
				}
			],
			False
		],
		Example[{Additional,"Returns False if mixing within the plate reader chamber is being requested, but the instrument does not support it:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				PlateReaderMix->True,
				Instrument->Model[Instrument, PlateReader, "Lunatic"]
			],
			False
		],
		Example[{Additional,"Returns False if injections are being requested, but the instrument does not support it:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"],
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionVolume->5 Microliter
			],
			False
		],
		Example[{Additional,"Returns False if there's a request to create a circle of wells around the samples but a chip-based reader is being used:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"],
				MoatSize->1
			],
			False
		],
		(*Error::PlateReaderReadDirectionUnsupported*)
		Example[{Additional,"Returns False if the plate reader being does not allow the order in which samples are read to be set:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument, PlateReader, "Lunatic"],
				ReadDirection->SerpentineRow
			],
			False
		],
		(*Error::CoverUnsupported*)
		Example[{Additional,"Returns False if a BMG reader is not specified but RetainCover -> True:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				RetainCover->True
			],
			False
		],
		(*Error::CoveredInjections*)
		Example[{Additional,"Returns False if RetainCover is set to True but injections are being performed:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				RetainCover->True,
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionVolume->5 Microliter
			],
			False
		],
		(*Warning::ReplicateChipSpace*)
		Example[{Additional,"Returns True if the sample is being quantified but there is not enough space available to do the expected number of replicates since the experiment can still be done:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Container, Plate, "Test container 11 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				QuantifyConcentration -> True
			],
			True
		],
		(*Error::InvalidBlankContainer*)
		Example[{Additional,"Returns False if no blank volume has been specified but blank Buffer 1 is in a 50mL tube and must be transferred into the assay container to be read:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample,"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 1" <> $SessionUUID],
				BlankVolumes->Null
			],
			False
		],
		(*Warning::UnnecessaryBlankTransfer*)
		Example[{Additional,"Returns True but gives a warning if blank is set to be transferred even though it is already in a valid container:"},
			ValidExperimentAbsorbanceSpectroscopyQ[
				Object[Sample,"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 3" <> $SessionUUID],
				BlankVolumes->100 Microliter
			],
			True
		],
		Example[{Messages, "ExtCoeffNotFound", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True],
			False
		],
		Example[{Options, Verbose, "If Verbose -> Failures, return the results of all failing tests and warnings:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, Verbose -> Failures],
			False
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Messages, "SampleMustContainQuantificationAnalyte", "If QuantificationAnalyte is specified, it must be a component of the input sample:"},
			ValidExperimentAbsorbanceSpectroscopyQ[Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationAnalyte -> Model[Molecule, Oligomer, "ACTH 18-39"]],
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
				Object[Container, Bench, "Test bench for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],

				Object[Container, Plate, "Test container 1 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentAbsorbanceSpectroscopyQ New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentAbsorbanceSpectroscopyQ New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Test container 2 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 10 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 11 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],

				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (red food dye)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 3" <> $SessionUUID],


				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Injection 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Injection 2" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID]

			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11,
					container12, container13, sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
					sample13, sample14, sample15, plateSamples, allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,DeveloperObject->True|>];
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
					container13
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
						Model[Container, Plate, "96-well UV-Star Plate"]
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
						{"Work Surface",fakeBench}
					},
					Name->{
						"Test container 1 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Plate 1" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Plate 2" <> $SessionUUID,
						"Test container 2 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 3 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 4 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 5 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 6 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 7 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 8 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 9 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 10 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID,
						"Test container 11 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID
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
					sample15
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
						Model[Sample, "Red Food Dye"]
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
						{"A2",container}
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
						200*Microliter
					},
					State -> Liquid,
					Name->{
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ Acetone Test Chemical 1" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (15 mL)" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (1.5 mL)" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (red food dye)" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ Injection 1" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ Injection 2" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 1" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 2" <> $SessionUUID,
						"ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 3" <> $SessionUUID
					}
				];

				plateSamples=UploadSample[
					ConstantArray[Model[Sample, "Red Food Dye"],32],
					{#,container13}&/@Take[Flatten[AllWells[]], 32],
					InitialAmount->ConstantArray[200 Microliter,32],
					State -> Liquid
				];


				allObjs = Join[
					{
						container, container2, container3, container4, container5, container6, container7, container8,
						sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
						sample13,sample14,sample15
					},
					plateSamples
				];

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceSpectroscopy],
						Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							QuantifyConcentration -> False,
							QuantificationWavelength -> Null,
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
					<|Object -> Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID], Concentration -> 5*Millimolar|>
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
				Object[Container, Bench, "Test bench for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],

				Object[Container, Plate, "Test container 1 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentAbsorbanceSpectroscopyQ New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentAbsorbanceSpectroscopyQ New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Test container 2 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 7 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 8 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 9 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 10 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 11 for ValidExperimentAbsorbanceSpectroscopyQ tests" <> $SessionUUID],



				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Chemical 1 (red food dye)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ New Test Peptide oligomer 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Injection 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Injection 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentAbsorbanceSpectroscopyQ Blank Buffer 3" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for ValidQ function" <> $SessionUUID]

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
(*ExperimentAbsorbanceSpectroscopyOptions*)


DefineTests[ExperimentAbsorbanceSpectroscopyOptions,
	{
		Example[{Basic,"Display all the resolved options for ExperimentAbsorbanceSpectroscopyOptions as a table:"},
			ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],ImageSample->True],
			_Grid
		],
		Example[{Basic,"Display all the resolved options for ExperimentAbsorbanceSpectroscopyOptions as a table for plates:"},
			ExperimentAbsorbanceSpectroscopyOptions[Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"Display all the resolved options for ExperimentAbsorbanceSpectroscopyOptions as a table for a list of plates:"},
			ExperimentAbsorbanceSpectroscopyOptions[{Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],Object[Container, Plate,"ExperimentAbsorbanceSpectroscopyOptions New Test Plate 2" <> $SessionUUID]}],
			_Grid
		],
		Example[{Options, OutputFormat,"Display all the resolved options for ExperimentAbsorbanceSpectroscopyOptions as a list if OutputFormat -> List:"},
			ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],ImageSample->True, OutputFormat -> List],
			{_Rule..}
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],ImageSample->True, OutputFormat -> List];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"], OutputFormat -> List];
			Lookup[options, Instrument],
			Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"],
			Variables :> {options}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1 for Options function", OutputFormat -> List];
			Lookup[options, Name],
			"Absorbance Spectroscopy protocol with sample 1 for Options function",
			Variables :> {options}
		],
		Example[{Messages, "DuplicateName", "If the specified Name option already exists as a protocol object, throw an error and return $Failed:"},
			ExperimentAbsorbanceSpectroscopyOptions[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID]},
				Instrument -> Model[Instrument, PlateReader, "Lunatic"],
				BlankAbsorbance -> True,
				Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID
			],
			_Grid,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[{Options, Template, "Set the Template option:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, Template],
			ObjectP[Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			46*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius, OutputFormat -> List];
			Lookup[options, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius, OutputFormat -> List];
			Lookup[options, Temperature],
			40.2*Celsius,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options,Temperature,"If using the Lunatic, Temperature resolves to Ambient in options:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, Temperature],
			Ambient,
			Variables :> {options}
		],
		Example[{Options,Temperature,"If using a BMG plate reader, Temperature resolves to Ambient:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], OutputFormat -> List];
			Lookup[options, Temperature],
			Ambient,
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute, OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to Null:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"If using the Lunatic, EquilibrationTime resolves to 0*Minute:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			0*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second, OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options,QuantifyConcentration,"Indicate that the concentration of the input samples should be calculated:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> List];
			Lookup[options, QuantifyConcentration],
			True,
			Variables :> {options}
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified but QuantificationWavelength is specified, resolve option to True:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, QuantifyConcentration],
			True,
			Variables :> {options}
		],
		Example[{Options,QuantifyConcentration,"If QuantifyConcentration is not specified and QuantificationWavelength is also not specified, resolve option to False:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, QuantifyConcentration],
			False,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"Indicate the wavelength of the quantification that should be calculated:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, QuantificationWavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is not specified and QuantificationWavelength is also not specified, resolve option to Null:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], OutputFormat -> List];
			Lookup[options, QuantificationWavelength],
			Null,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to 260 Nanometer IF the ExtinctionCoefficients field is not populated in any sample's model (and throw an error):"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> List];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			Messages :> {Warning::ExtCoeffNotFound, Error::ExtinctionCoefficientMissing, Error::InvalidOption},
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"If QuantifyConcentration is True and QuantificationWavelength is not specified, resolve option to the first value stored in the sample's model's ExtinctionCoefficients field:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> List];
			Lookup[options, QuantificationWavelength],
			260*Nanometer,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,QuantificationWavelength,"Rounds specified QuantificationWavelength to the nearest nanometer:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantificationWavelength -> 280.477777777*Nanometer, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, QuantificationWavelength],
			280*Nanometer,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options, BlankAbsorbance, "Indicate whether the absorbance spectrum should be blanked:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, OutputFormat -> List];
			Lookup[options, BlankAbsorbance],
			False,
			Variables :> {options}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"],
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]],
			Variables :> {options}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]},
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True,
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to Null:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False,
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			Null,
			Variables :> {options}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.1*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			0.1*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample, using multiple samples:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			{0.1*Milliliter, 0.15*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::NotEqualBlankVolumesWarning}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified, and Instrument -> a BMG plate reader, resolve BlankVolumes to the volume of the corresponding sample:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			options = ExperimentAbsorbanceSpectroscopyOptions[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			options = ExperimentAbsorbanceSpectroscopyOptions[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				BlankAbsorbance -> False,
				OutputFormat -> List
			];
			Lookup[options, BlankVolumes],
			Null,
			Variables :> {options}
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],
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
			options = ExperimentAbsorbanceSpectroscopyOptions[
				{"red dye sample", Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			ExperimentAbsorbanceSpectroscopyOptions[{Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			_Grid,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput},
			Variables :> {options}
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the Temperature option is specified with an instrument that does not support it:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], Temperature -> 30 Celsius, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, Temperature],
			30 Celsius,
			Messages :> {Error::TemperatureIncompatibleWithPlateReader, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "TemperatureIncompatibleWithPlateReader", "Returns an error if the EquilibrationTime option is specified with an instrument that does not support it:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 10*Minute, Instrument -> Model[Instrument, PlateReader, "Lunatic"], OutputFormat -> List];
			Lookup[options, EquilibrationTime],
			10*Minute,
			Messages :> {Error::TemperatureIncompatibleWithPlateReader, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader model is deprecated:"},
			ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FlexStation 3"]],
			_Grid,
			Messages :> {Error::DeprecatedInstrument, Error::InvalidInput},
			Variables :> {options}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader object is retired:"},
			ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Object[Instrument, PlateReader, "Flexstation"]],
			_Grid,
			Messages :> {Error::UnsupportedPlateReader, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "ConcentrationWavelengthMismatch", "Returns an error if QuantifyConcentration is set to False and a QuantificationWavelength has been provided:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (red food dye)" <> $SessionUUID], QuantifyConcentration->False,QuantificationWavelength->280 Nanometer, OutputFormat -> List];
			Lookup[options, {QuantifyConcentration, QuantificationWavelength}],
			{False, 280*Nanometer},
			EquivalenceFunction -> Equal,
			Messages :> {Error::ConcentrationWavelengthMismatch, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "ConcentrationWavelengthMismatch", "Returns an error if QuantifyConcentration is set to True and a QuantificationWavelength has been set to Null:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], QuantifyConcentration->True,QuantificationWavelength->Null, OutputFormat -> List];
			Lookup[options, {QuantifyConcentration, QuantificationWavelength}],
			{True, Null},
			Messages :> {Error::ConcentrationWavelengthMismatch, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and Blanks -> Null:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, Blanks -> Null, OutputFormat -> List];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and BlankVolumes -> Null:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, BlankVolumes -> Null, OutputFormat -> List];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::BlankVolumeNotRecommended, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and Blanks is specified:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Blanks -> Model[Sample, "Milli-Q water"], OutputFormat -> List];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{False, ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and BlankVolumes is specified:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, BlankVolumes -> 2*Microliter, OutputFormat -> List];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{False, 2*Microliter},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "BlankVolumeNotRecommended", "Returns an error if using the Lunatic and BlankVolumes is anything but 2.1*Microliter:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "Lunatic"], BlankVolumes -> 10*Microliter, OutputFormat -> List];
			Lookup[options, BlankVolumes],
			10*Microliter,
			Messages :> {Error::BlankVolumeNotRecommended, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "QuantificationRequiresBlanking", "Returns an error if QuantifyConcentration -> True and BlankAbsorbance -> False:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],QuantifyConcentration -> True, BlankAbsorbance -> False, OutputFormat -> List];
			Lookup[options, {QuantifyConcentration, BlankAbsorbance}],
			{True, False},
			Messages :> {Error::QuantificationRequiresBlanking, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "TooManySamples", "If the combination of NumberOfReplicates * (Number of samples + number of unique blanks) is greater than 94 and we are using the Lunatic, throw an error:"},
			ExperimentAbsorbanceSpectroscopyOptions[
				{Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]},
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
			options = ExperimentAbsorbanceSpectroscopyOptions[
				{
					Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID]
				},
				Blanks -> {
					Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
					Automatic
				},
				OutputFormat -> List
			];
			Lookup[options, Blanks],
			{ObjectP@Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID], ObjectP@Model[Sample, "Milli-Q water"]},
			Messages :> {Error::BlanksContainSamplesIn, Error::InvalidOption},
			Variables :> {options}
		],
		Example[{Messages, "ExtCoeffNotFound", "If sample concentration is being quantified, the extinction coefficient should be populated in the sample model:"},
			options = ExperimentAbsorbanceSpectroscopyOptions[Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions Acetone Test Chemical 1" <> $SessionUUID], QuantifyConcentration -> True, OutputFormat -> List];
			Lookup[options, QuantificationWavelength],
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
				Object[Container, Bench, "Test bench for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],

				Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopyOptions New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopyOptions New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Test container 2 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID]

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

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID,DeveloperObject->True|>];
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
						"Test container 1 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyOptions New Test Plate 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyOptions New Test Plate 2" <> $SessionUUID,
						"Test container 2 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID,
						"Test container 3 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID
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
					State -> Liquid,
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
						"ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyOptions Acetone Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (red food dye)" <> $SessionUUID
					}
				];


				allObjs = {
					container, container2, container3, container4, container5,
					sample, sample2, sample3, sample4, sample5, sample6, sample7
				};

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceSpectroscopy],
						Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							QuantifyConcentration -> False,
							QuantificationWavelength -> Null,
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
				Object[Container, Bench, "Test bench for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],

				Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopyOptions New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopyOptions New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Test container 2 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAbsorbanceSpectroscopyOptions tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyOptions New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Options function" <> $SessionUUID]

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
(*ExperimentAbsorbanceSpectroscopyPreview*)


DefineTests[ExperimentAbsorbanceSpectroscopyPreview,
	{
		Example[{Basic,"Return Null regardles of the input:"},
			ExperimentAbsorbanceSpectroscopyPreview[Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1" <> $SessionUUID]],
			Null
		],
		Example[{Basic,"Return Null for a plate:"},
			ExperimentAbsorbanceSpectroscopyPreview[Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID]],
			Null
		],
		Example[{Basic,"Returns Null for a list of plates:"},
			ExperimentAbsorbanceSpectroscopyPreview[{Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],Object[Container, Plate,"ExperimentAbsorbanceSpectroscopyPreview New Test Plate 2" <> $SessionUUID]}],
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
				Object[Container, Bench, "Test bench for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],

				Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopyPreview New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopyPreview New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Test container 2 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Preview function" <> $SessionUUID]

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

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID,DeveloperObject->True|>];
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
						"Test container 1 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyPreview New Test Plate 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyPreview New Test Plate 2" <> $SessionUUID,
						"Test container 2 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID,
						"Test container 3 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID
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
					State -> Liquid,
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
						"ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyPreview Acetone Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 2" <> $SessionUUID,
						"ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (red food dye)" <> $SessionUUID
					}
				];


				allObjs = {
					container, container2, container3, container4, container5,
					sample, sample2, sample3, sample4, sample5, sample6, sample7
				};

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceSpectroscopy],
						Name -> "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Preview function" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							QuantifyConcentration -> False,
							QuantificationWavelength -> Null,
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
				Object[Container, Bench, "Test bench for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],

				Object[Container, Plate, "Test container 1 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopyPreview New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceSpectroscopyPreview New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Test container 2 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for ExperimentAbsorbanceSpectroscopyPreview tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceSpectroscopyPreview New Test Chemical 1 (red food dye)" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Old Absorbance Spectroscopy Protocol with 1 Hour of equilibration time for Preview function" <> $SessionUUID]

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
