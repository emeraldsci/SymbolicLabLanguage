(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentUVMelting: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentUVMelting*)


DefineTests[
	ExperimentUVMelting,
	(* Basic examples *)
	{
		Example[{Basic,"Generates a protocol to measure the UV melting curve of a single oligomer sample in a cuvette:"},
			ExperimentUVMelting[Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID]],
			ObjectP[Object[Protocol,UVMelting]]
		],
		Example[{Basic,"Generates a protocol to measure the UV melting curve of a single oligomer sample in a cuvette with no model:"},
			ExperimentUVMelting[Object[Sample,"PNA sample for ExperimentUVMelting testing with no model" <> $SessionUUID]],
			ObjectP[Object[Protocol,UVMelting]]
		],
		Example[{Basic,"Generates a protocol used to measure the UV melting curve for multiple oligomer samples in cuvettes:"},
			ExperimentUVMelting[{Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"Sample in Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID]}],
			_
		(*ObjectP[Object[Protocol,UVMelting]],*)
		],

		Example[{Basic,"Generates a protocol to measure the UV melting curve of a mixture of multiple oligomers:"},
			ExperimentUVMelting[{
				{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
			}
			],
			ObjectP[Object[Protocol,UVMelting]]
		],
		Example[{Basic,"Generates a protocol to measure the UV melting curve of a model:"},
			ExperimentUVMelting[Model[Sample,"Milli-Q water"]],
			ObjectP[Object[Protocol,UVMelting]]
		],

		Example[{Additional,"Accepts a list of containers:"},
			ExperimentUVMelting[{{Object[Container,Vessel,"50ml container 1 for UVMelting testing" <> $SessionUUID],Object[Container,Vessel,"50ml container 2 for UVMelting testing" <> $SessionUUID]}}],
			ObjectP[Object[Protocol,UVMelting]]
		],

		Example[{Additional,"If given a plate, assumes each sample inside the plate is treated as an individual input sample (no pooling) and will be measured separately:"},
			ExperimentUVMelting[Object[Container,Plate,"96-well plate 1 for UVMelting testing" <> $SessionUUID]],
			ObjectP[Object[Protocol,UVMelting]],
			Messages:>{Warning::TransferRequired}
		],

		Example[{Additional,"If given a plate container inside a list, assumes all the samples inside the plate should be pooled for the experiment:"},
			ExperimentUVMelting[{{Object[Container,Plate,"96-well plate 2 for UVMelting testing" <> $SessionUUID]}}],
			ObjectP[Object[Protocol,UVMelting]]
		],

		Example[{Additional,"There is no limit to the number of samples to be pooled as long as the total volume of the samples and buffer used does not exceed the working volume of the cuvette:"},
			ExperimentUVMelting[{
				{
					Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
					Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
					Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
					Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
					Object[Sample, "Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
					Object[Sample, "Water sample 2 for ExperimentUVMelting testing" <> $SessionUUID]
				}
			}],
			ObjectP[Object[Protocol,UVMelting]]
		],

		(* MESSAGES *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentUVMelting[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentUVMelting[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentUVMelting[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentUVMelting[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentUVMelting[Link[Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID], Now - 1 Minute]],
			ObjectP[Object[Protocol, UVMelting]],
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages,"DiscardedSamples","If the given input samples are discarded, they cannot be measured:"},
			ExperimentUVMelting[{{Object[Sample,"Discarded sample for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "Protein sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}}],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"NonLiquidSample","If the given input sample is Solid, it cannot be measured:"},
			ExperimentUVMelting[{{Object[Sample,"Solid sample for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "Protein sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}}],
			$Failed,
			Messages:>{
				Error::NonLiquidSample,Error::InvalidInput}
		],
		Example[{Messages,"InstrumentPrecision","The precision of the Wavelength cannot be not more than 0.1 Nanometer, the maximum precision achievable by the ECL spectrophotometers:"},
			Lookup[
				ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},Wavelength->300.009 Nanometer,Output->Options],
				Wavelength
			],
			300.01 Nanometer,
			Messages:>{Warning::InstrumentPrecision},
			EquivalenceFunction->Equal
		],
		Example[{Messages,"IncompatibleSpectrophotometer","Only spectrophotometers with UV/Vis capabilities can be used for this experiment:"},
			ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}},
				Instrument->Object[Instrument, Spectrophotometer, "id:qdkmxzqGbkmp"]
			],
			$Failed,
			Messages:>{Error::IncompatibleSpectrophotometer,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleCuvette","The container in which the samples are to be pooled and measured (AliquotContainer) has to be compatible with the instrument (for example, it has to be made of quartz):"},
			ExperimentUVMelting[{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
			(* cuvette not made of quartz *)
				AliquotContainer->Model[Container, Cuvette, "id:M8n3rxYE557M"]
			],
			$Failed,
			Messages:>{Error::IncompatibleCuvette,Error::InvalidOption, Error::InvalidInput, Error::DeprecatedModels}
		],
		Example[{Messages,"NestedIndexMatchingVolumeOutOfRange","Samples with assay volume (total volume of samples and buffers inside a particular pool) smaller than the minimum working range of the smallest cuvette cannot be reliably measured:"},
			ExperimentUVMelting[{{Object[Sample,"Small volume sample for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"Small volume sample for ExperimentUVMelting testing" <> $SessionUUID]}}],
			$Failed,
			Messages:>{Error::NestedIndexMatchingVolumeOutOfRange,Error::InvalidOption}
		],
		Example[{Messages,"NestedIndexMatchingVolumeOutOfRange","The assay volume (total volume of samples and buffers inside a particular pool) has to fall within the working range of an available cuvette:"},
			ExperimentUVMelting[{Object[Sample,"Incompatible volume sample for ExperimentUVMelting testing" <> $SessionUUID]}],
			$Failed,
			Messages:>{Error::NestedIndexMatchingVolumeOutOfRange,Error::InvalidOption}
		],
		Example[{Messages,"MismatchingNestedIndexMatchingdMixOptions","If the NestedIndexMatchingMix boolean option is turned to False, other mixing options for the pool cannot be specified:"},
			ExperimentUVMelting[
				{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				NestedIndexMatchingMix->False,
				NestedIndexMatchingMixType->Pipette
			],
			$Failed,
			Messages:>{Error::MismatchingNestedIndexMatchingdMixOptions,Warning::NoMixingDespiteAliquotting,Error::InvalidOption}
		],
		Example[{Messages,"NestedIndexMatchingMixVolumeNotCompatibleWithMixType","If NestedIndexMatchingMixType is specified to Pipette, NestedIndexMatchingMixVolume cannot be set to Null:"},
			ExperimentUVMelting[
				{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				NestedIndexMatchingMix->True,
				NestedIndexMatchingMixType->Pipette,
				NestedIndexMatchingMixVolume->Null
			],
			$Failed,
			Messages:>{Error::NestedIndexMatchingMixVolumeNotCompatibleWithMixType,Error::InvalidOption}
		],
		Example[{Messages,"NestedIndexMatchingMixVolumeNotCompatibleWithMixType","If NestedIndexMatchingMixType is specified to Invert, NestedIndexMatchingMixVolume cannot be set to a volume:"},
			ExperimentUVMelting[
				{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				NestedIndexMatchingMix->True,
				NestedIndexMatchingMixType->Invert,
				NestedIndexMatchingMixVolume->300 Microliter
			],
			$Failed,
			Messages:>{Error::NestedIndexMatchingMixVolumeNotCompatibleWithMixType,Error::InvalidOption}
		],
		Example[{Messages,"MismatchingNestedIndexMatchingIncubateOptions","If the NestedIndexMatchingIncubate boolean option is turned to False, other incubation options for the pool(s) cannot be specified:"},
			ExperimentUVMelting[
				{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				NestedIndexMatchingIncubate->False,
				NestedIndexMatchingIncubationTemperature->30 Celsius
			],
			$Failed,
			Messages:>{Error::MismatchingNestedIndexMatchingIncubateOptions,Error::InvalidOption}
		],
		Example[{Messages,"MismatchingWavelengthOptions","If the Wavelength is specified, neither MinWavelength or MaxWavelength can be specified as well:"},
			ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				Wavelength -> 500 Nanometer,
				MinWavelength -> 200 Nanometer
			],
			$Failed,
			Messages:>{Error::MismatchingWavelengthOptions,Error::InvalidOption}
		],
		Example[{Messages,"InvalidWavelengthRange","MinWavelength must be smaller than MaxWavelength:"},
			ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				MaxWavelength -> 300 Nanometer,
				MinWavelength -> 500 Nanometer
			],
			$Failed,
			Messages:>{Error::InvalidWavelengthRange,Error::InvalidOption}
		],
		Example[{Messages,"TransferRequired","A warning is thrown if a single sample input is given whose container does not fit on the deck and the sample will be transferred into a cuvette prior to measurement:"},
			ExperimentUVMelting[{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}],
			ObjectP[Object[Protocol,UVMelting]],
			Messages:>{Warning::TransferRequired}
		],
		Example[{Messages,"NoMixingDespiteAliquotting","A warning is thrown if samples are being aliquotted but NestedIndexMatchingMix is set to False:"},
			ExperimentUVMelting[
				{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}

				},
				NestedIndexMatchingMix->False
			],
			ObjectP[Object[Protocol,UVMelting]],
			Messages:>{Warning::NoMixingDespiteAliquotting}
		],
		Example[{Messages,"TooManyUVMeltingSamples","The number of samples or sample pools to be measured cannot exceed the number of available slots in the cuvette block of the instrument:"},
			ExperimentUVMelting[{
				Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample, "Protein sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample, "Protein sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample, "Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample, "Water sample 2 for ExperimentUVMelting testing" <> $SessionUUID]
			}, NumberOfReplicates -> 5
			],
			$Failed,
			Messages:>{Error::TooManyUVMeltingSamples,Warning::TransferRequired,Error::InvalidOption}
		],
		Example[{Messages,"UnableToBlank","BlankMeasurement can only be set to True if we're using an AliquotContainer to mix the input sample(s) with buffer:"},
			ExperimentUVMelting[{Object[Sample,"Sample in Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID]},
				BlankMeasurement -> True
			],
			$Failed,
			Messages:>{Error::UnableToBlank,Error::InvalidOption}
		],

		Example[{Messages,"SamplesOutStorageConditionConflict","If SamplesOutStorageCondition is set to Disposal, ContainerOut can't be specified:"},
			ExperimentUVMelting[{
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				BufferDilutionFactor -> {10,10},
				ConcentratedBuffer -> {Model[Sample, StockSolution, "10x UV buffer"],Model[Sample, StockSolution, "10x UV buffer"]},
				AssayVolume->{950*Microliter,1000*Microliter},
				AliquotAmount->{200*Microliter,250*Microliter},
				ContainerOut->Model[Container,Plate,"48-well Pyramid Bottom Deep Well Plate"],
				SamplesOutStorageCondition->Disposal
			],
			$Failed,
			Messages:>{Error::SamplesOutStorageConditionConflict,Error::InvalidOption}
		],

		Example[{Messages,"ContainerOutMismatchedIndex","When specifying ContainerOut using the index syntax, each :"},
			ExperimentUVMelting[{
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				ContainerOut->{{1,Model[Container,Plate,"48-well Pyramid Bottom Deep Well Plate"]},{1,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}}
			],
			$Failed,
			Messages:>{Error::ContainerOutMismatchedIndex,Error::InvalidOption}
		],

		Example[{Messages,"ContainerOverOccupied","The specified ContainerOut cannot request more positions than the container has:"},
			ExperimentUVMelting[{
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				ContainerOut->{{1,Model[Container,Vessel,"id:3em6Zv9NjjN8"]},{1,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}}
			],
			$Failed,
			Messages:>{Error::ContainerOverOccupied,Error::InvalidOption}
		],

		Example[{Messages,"NestedIndexMatchingVolumeBelowMinThreshold","A warning is thrown if the total volume of samples and buffers is smaller than the recommended minimum volume of the AliquotContainer specified:"},
			ExperimentUVMelting[{
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
				AliquotAmount->{{0.1 Milliliter,0.1 Milliliter},{0.1 Milliliter,0.1 Milliliter}},
				AssayVolume->0.5*Milliliter,
				AliquotContainer->{Model[Container, Cuvette, "id:Y0lXejGKdd1x"],Automatic}
			],
			ObjectP[Object[Protocol,UVMelting]],
			Messages:>{Warning::NestedIndexMatchingVolumeBelowMinThreshold}
		],

		Example[{Messages,"ContainerOutStorageConditionConflict","If samples are to be stored in a plate, there can be only one storage condition:"},
			ExperimentUVMelting[{
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
			},
				SamplesOutStorageCondition -> {Freezer,Refrigerator},
				ContainerOut->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			$Failed,
			Messages:>{Error::ContainerOutStorageConditionConflict,Error::InvalidOption}
		],

		Example[{Messages,"ContainerOutStorageConditionConflict","If samples are to be stored in a plate, there can be only one storage condition (index-matched ContainerOut case):"},
			ExperimentUVMelting[{
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}

			},
				SamplesOutStorageCondition -> {Freezer,Refrigerator,Freezer,AmbientStorage,Disposal},
				ContainerOut->{Model[Container,Plate,"96-well 2mL Deep Well Plate"],Model[Container,Plate,"96-well 2mL Deep Well Plate"],Model[Container,Plate,"96-well 2mL Deep Well Plate"],Automatic,Null}
			],
			$Failed,
			Messages:>{Error::ContainerOutStorageConditionConflict,Error::InvalidOption}
		],

		Example[{Messages, "NumberOfReplicatesRequiresAliquoting", "If NumberOfReplicates is set, Aliquot must not be set to False:"},
			ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}}, NumberOfReplicates -> 2, Aliquot -> False],
			$Failed,
			Messages :> {Error::AliquotOptionMismatch,Error::NumberOfReplicatesRequiresAliquoting, Error::InvalidOption}
		],
		Example[{Messages,"UVMeltingIncompatibleBlankOptions","If BlankMeasurement -> True, then Blank cannot be Null:"},
			ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}}, BlankMeasurement -> True, Blank -> Null],
			$Failed,
			Messages :> {Error::UVMeltingIncompatibleBlankOptions, Error::InvalidOption}
		],
		Example[{Messages,"UVMeltingIncompatibleBlankOptions","If BlankMeasurement -> False, then Blank must be Null:"},
			ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}}, BlankMeasurement -> False, Blank -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::UVMeltingIncompatibleBlankOptions, Error::InvalidOption}
		],
		Example[{Messages,"BlanksContainSamplesIn","An input sample cannot also be specified as a Blank:"},
			ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}}, BlankMeasurement -> True, Blank -> Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]],
			$Failed,
			Messages :> {Error::BlanksContainSamplesIn, Error::InvalidOption}
		],

	(* OPTIONS *)
		Example[{Options,Instrument,"Specify the spectrophotometer to be used for this experiment (note that it needs to have UV/Vis capabilities (refer to the instrument Model's field ElectromagneticRange):"},
			Lookup[
				ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}},
					Instrument->Object[Instrument, Spectrophotometer, "Fake Spectrophotometer for UVMelting testing" <> $SessionUUID],
					Output->Options
				],
				Instrument
			],
			ObjectP[Object[Instrument, Spectrophotometer, "Fake Spectrophotometer for UVMelting testing" <> $SessionUUID]]
		],
		Example[{Options,AliquotContainer,"Specify the cuvette in which the samples are to be pooled and measured:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					AliquotContainer->Model[Container, Cuvette, "Semi-Micro Scale Black Walled UV Quartz Cuvette"],
					Output->Options
				],
				AliquotContainer
			],
			{{1, ObjectP[Model[Container, Cuvette, "id:R8e1PjRDbbld"]]}}
		],
		Example[{Options,AliquotContainer,"If the input is a pool of samples, AliquotContainer always resolves to a cuvette that can contain the total volume of the samples (including buffer, if specified) and in which the measurement is going to be performed:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					AliquotContainer->Automatic,
					Output->Options
				],
				AliquotContainer
			],
			{{1, ObjectP[Model[Container, Cuvette, "id:R8e1PjRDbbld"]]}}
		],
		Example[{Options,AliquotContainer,"If the input is a single sample that is inside a container compatible with the measurement, then no aliquotting is performed:"},
			Lookup[
				ExperimentUVMelting[
					Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID],
					AliquotContainer->Automatic,
					Aliquot->Automatic,
					Output->Options
				],
				Aliquot
			],
			False
		],
		Example[{Options,AliquotContainer,"If the input is a single sample that is inside a container compatible with the measurement, then no aliquotting is performed 2:"},
			Lookup[
				ExperimentUVMelting[
					Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing 2" <> $SessionUUID],
					AliquotContainer->Automatic,
					Aliquot->Automatic,
					Output->Options
				],
				Aliquot
			],
			False
		],
		Example[{Options,AliquotContainer,"If the input is a single sample that is inside a container compatible with the measurement, but an aliquot related option was specified, then the sample is going to be aliquotted out of the original container into a new container:"},
			Lookup[
				ExperimentUVMelting[
					Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID],
					AliquotContainer->Automatic,
					Aliquot->Automatic,
					AliquotAmount->0.5 Milliliter,
					Output->Options
				],
				Aliquot
			],
			True
		],
		Example[{Options,AliquotContainer,"If the input is a single sample that is inside a container compatible with the measurement, but an aliquot related option was specified, then the sample is going to be aliquotted out of the original container into a new container:"},
			Lookup[
				ExperimentUVMelting[
					Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
					AliquotContainer->Automatic,
					Aliquot->Automatic,
					AliquotAmount->0.5 Milliliter,
					Output->Options
				],
				{Aliquot,AliquotContainer}
			],
			{True, {{1, ObjectP[Model[Container, Cuvette, "id:eGakld01zz3E"]]}}}
		],
		Example[{Options,NestedIndexMatchingMix,"Indicate that the pooled samples should be mixed prior to measurement:"},
			Lookup[
				ExperimentUVMelting[
					{
						{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
					},
					NestedIndexMatchingMix->True,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes}
			],
			{True,Pipette,400 Microliter,10}
		],
		Example[{Options,NestedIndexMatchingMix,"Indicate that some of the pools should be mixed prior to measurement, but not all:"},
			Lookup[
				ExperimentUVMelting[
					{
						{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
						{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
					},
					NestedIndexMatchingMix->{True,False},
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes}
			],
			{{True,False},{Pipette,Null},{400 Microliter,Null},{10,Null}},
			Messages:>{Warning::NoMixingDespiteAliquotting}
		],
		Example[{Options,NestedIndexMatchingMix,"If NestedIndexMatchingMix is turned to True, the mix type automatically resolves to Pipette if the cuvette's aperture allows for mix by pipetting:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMix->True,
					NestedIndexMatchingMixType->Automatic,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes}
			],
			{True, Pipette,400 Microliter, 10}
		],
		Example[{Options,NestedIndexMatchingMix,"Specify that the samples to be measured should not be mixed even though we're pooling several samples inside a new container:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMix->False,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes}
			],
			{False, Null, Null,Null},
			Messages:>{Warning::NoMixingDespiteAliquotting}
		],
		Example[{Options,NestedIndexMatchingMix,"If pooling of the samples is performed, the samples are always mixed even if the Mix options are left automatic, but they are not automatically incubated:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					AliquotContainer->Automatic,
					NestedIndexMatchingMix->Automatic,
					Output->Options
				],
				{AliquotContainer,NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingIncubate}
			],
			{{{1, ObjectP[Model[Container, Cuvette, "id:R8e1PjRDbbld"]]}}, True, Pipette, False}
		],
		Example[{Options,NestedIndexMatchingMixType,"Specify that the sample should be mixed by Inversion after pooling of the input samples inside the cuvette:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMixType->Invert,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes}
			],
			{True, Invert, Null,10}
		],

		Example[{Options,NestedIndexMatchingNumberOfMixes,"Specify how many times the samples should be inverted when mixing by Inversion:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMixType->Invert,
					NestedIndexMatchingNumberOfMixes->5,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingNumberOfMixes}
			],
			{True, Invert,5}
		],
		Example[{Options,NestedIndexMatchingMixVolume,"Specify the volume that should be pipetted up and down when mixing by Pipette:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMixType->Pipette,
					NestedIndexMatchingMixVolume->250 Microliter,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes}
			],
			{True, Pipette,250 Microliter,10}
		],
		Example[{Options,NestedIndexMatchingMixVolume,"NestedIndexMatchingMixVolume automatically resolves to half of the sample volume or 400 Microliter, whichever smaller:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMixType->Pipette,
					NestedIndexMatchingMixVolume->Automatic,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume}
			],
			{True, Pipette,400 Microliter}
		],
		Example[{Options,NestedIndexMatchingMixVolume,"If NestedIndexMatchingMixVolume is specified, NestedIndexMatchingMixType automatically resolves to mix by Pipette:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMixType->Automatic,
					NestedIndexMatchingMixVolume->100 Microliter,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume}
			],
			{True,Pipette,100 Microliter}
		],
		Example[{Options,NestedIndexMatchingNumberOfMixes,"NestedIndexMatchingMixVolume automatically resolves to half of the sample volume or 400 Microliter, whichever smaller:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMixType->Pipette,
					NestedIndexMatchingNumberOfMixes->Automatic,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingNumberOfMixes}
			],
			{True, Pipette,10}
		],
		Example[{Options,NestedIndexMatchingMixType,"NestedIndexMatchingMixType automatically resolves to mixing by Pipette using a small volume and higher number of mixes, if the AliquotContainer was resolved to the Micro sclae cuvette:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMix->True,
					NestedIndexMatchingMixType->Automatic,
					AliquotContainer->Automatic,
					AliquotAmount->{{0.3 Milliliter,0.3 Milliliter}},
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingNumberOfMixes,NestedIndexMatchingMixVolume,AliquotContainer}
			],
			{True,Pipette,15,200*Microliter, {{1, Model[Container, Cuvette, "id:eGakld01zz3E"]}}}
		],
		Example[{Options,NestedIndexMatchingMixType,"NestedIndexMatchingMixType automatically resolves to mixing by Pipette if the AliquotContainer was resolved to a container that is suitable for mix by Pipette:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingMix->True,
					NestedIndexMatchingMixType->Automatic,
					AliquotContainer->Automatic,
					AliquotAmount->{{0.55 Milliliter,0.55 Milliliter}},
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingNumberOfMixes,AliquotContainer}
			],
			{True, Pipette,10, {{1, Model[Container, Cuvette, "id:R8e1PjRDbbld"]}}}
		],
		Example[{Options,NestedIndexMatchingMix,"NestedIndexMatchingMix automatically resolves to False if no aliquotting/pooling is performed and none of the mixing parameters are specified:"},
			Lookup[
				ExperimentUVMelting[{Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID]},
					NestedIndexMatchingMix->Automatic,
					NestedIndexMatchingMixType->Automatic,
					AliquotContainer->Automatic,
					Output->Options
				],
				{NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes,Aliquot,AliquotContainer}
			],
			{False,Null,Null,Null,False, {Null}}
		],
		Example[{Options,NestedIndexMatchingIncubate,"If NestedIndexMatchingIncubate is set to False, no incubation of the pooled samples will occur prior to the measurement:"},
			Lookup[
				ExperimentUVMelting[{Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID]},
					NestedIndexMatchingIncubate->False,
					NestedIndexMatchingIncubationTemperature->Automatic,
					PooledIncubationTime->Automatic,
					NestedIndexMatchingAnnealingTime->Automatic,
					Output->Options
				],
				{NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime}
			],
			{False,Null,Null,Null}
		],
		Example[{Options,NestedIndexMatchingIncubate,"NestedIndexMatchingIncubate automatically resolves to False if none of the incubation parameters are specified:"},
			Lookup[
				ExperimentUVMelting[{{Object[Container,Plate,"96-well plate 2 for UVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingIncubate->Automatic,
					NestedIndexMatchingIncubationTemperature->Automatic,
					PooledIncubationTime->Automatic,
					NestedIndexMatchingAnnealingTime->Automatic,
					Output->Options
				],
				{NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime}
			],
			{False,Null,Null,Null}
		],
		Example[{Options,NestedIndexMatchingIncubate,"If NestedIndexMatchingIncubate is set to True, the parameters for the incubation of the pools prior to the measurement are automatically resolved:"},
			Lookup[
				ExperimentUVMelting[{{Object[Container,Plate,"96-well plate 1 for UVMelting testing" <> $SessionUUID]}},
					NestedIndexMatchingIncubate->True,
					NestedIndexMatchingIncubationTemperature->Automatic,
					PooledIncubationTime->Automatic,
					NestedIndexMatchingAnnealingTime->Automatic,
					Output->Options
				],
				{NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime}
			],
			{True,85 Celsius,5 Minute,3 Hour}
		],
		Example[{Options,NestedIndexMatchingIncubationTemperature,"Specify at which temperature the pooled samples should be incubated prior to measurement:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "Water sample 2 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					NestedIndexMatchingIncubate->Automatic,
					NestedIndexMatchingIncubationTemperature->80 Celsius,
					PooledIncubationTime->Automatic,
					NestedIndexMatchingAnnealingTime->Automatic,
					Output->Options
				],
				{NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime}
			],
			{True,80 Celsius,5 Minute,3 Hour}
		],
		Example[{Options,PooledIncubationTime,"Specify how long the pooled samples should be incubated prior to measurement:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "Water sample 2 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					NestedIndexMatchingIncubate->Automatic,
					NestedIndexMatchingIncubationTemperature->Automatic,
					PooledIncubationTime->10 Minute,
					NestedIndexMatchingAnnealingTime->Automatic,
					Output->Options
				],
				{NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime}
			],
			{True,85 Celsius,10 Minute,3 Hour}
		],
		Example[{Options,NestedIndexMatchingAnnealingTime,"If the sample pools are incubated prior to the measurement, the annealing time automatically resolves to 3 hours:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
					},
					NestedIndexMatchingIncubate->True,
					NestedIndexMatchingIncubationTemperature->75 Celsius,
					PooledIncubationTime->10 Minute,
					NestedIndexMatchingAnnealingTime->Automatic,
					Output->Options
				],
				{NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime}
			],
			{True,75 Celsius,10 Minute,3 Hour}
		],
		(* Thermocycle related options *)
		Example[{Options,MaxTemperature,"Specify the upper end of the temperature range at which absorbance should be measured during the melting and cooling curves:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					MaxTemperature->80 Celsius,
					Output->Options
				],
				MaxTemperature
			],
			80 Celsius,
			EquivalenceFunction->Equal
		],
		Example[{Options,MinTemperature,"Specify the lower end of the temperature at which absorbance should be measured during the melting and cooling curves:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					MinTemperature->30 Celsius,
					Output->Options
				],
				MinTemperature
			],
			30 Celsius,
			EquivalenceFunction->Equal
		],
		Example[{Options,NumberOfCycles,"Specify how many times the temperature will be cycled from MinTemperature to MaxTemperature and back:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					NumberOfCycles->3,
					Output->Options
				],
				NumberOfCycles
			],
			3,
			EquivalenceFunction->Equal
		],
		Example[{Options,EquilibrationTime,"Specify for how long samples will be allowed to equilibrate once a low or high temperature endpoint has been reached:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					EquilibrationTime->10 Minute,
					Output->Options
				],
				EquilibrationTime
			],
			10 Minute,
			EquivalenceFunction->Equal
		],
		Example[{Options,TemperatureRampOrder,"Specify whether cycles will go from low to high temperature and back, or from high to low temperature and back:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					TemperatureRampOrder->{Heating, Cooling},
					Output->Options
				],
				TemperatureRampOrder
			],
			{Heating, Cooling}
		],
		Example[{Options,TemperatureResolution,"Specify the size of the temperature steps that will be taken when moving between MinTemperature and MaxTemperature:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					TemperatureResolution->7 Celsius,
					Output->Options
				],
				TemperatureResolution
			],
			7 Celsius
		],
		Example[{Options,TemperatureRampRate,"Specify how quickly the temperature will change during the progression of heating or cooling:"},
			Lookup[
				ExperimentUVMelting[{{Object[Container,Plate,"96-well plate 1 for UVMelting testing" <> $SessionUUID]}},
					TemperatureRampRate -> 1 Celsius / Minute,
					Output->Options
				],
				TemperatureRampRate
			],
			1 Celsius / Minute
		],
		Example[{Options,TemperatureMonitor,"Specify which temperature sensor will be used to control the progression of heating and cooling:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					TemperatureMonitor->ImmersionProbe,
					Output->Options
				],
				TemperatureMonitor
			],
			ImmersionProbe
		],
		Test["Properly populate the ReferenceSample, ReferenceCuvette, and TemperatureProbe options:",
			Download[
				ExperimentUVMelting[
					{
						{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
						{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
					},
					TemperatureMonitor->ImmersionProbe
				],
				{ReferenceSample, ReferenceCuvette, TemperatureProbe}
			],
			{ObjectP[Model[Sample]], ObjectP[Model[Container, Cuvette]], ObjectP[Model[Part, TemperatureProbe]]}
		],
		Example[{Options,BlankMeasurement,"Specify whether each cuvette will be blanked with buffer alone before the addition of sample and measurement of the pools:"},
			Lookup[
				ExperimentUVMelting[{{Object[Container,Plate,"96-well plate 1 for UVMelting testing" <> $SessionUUID]}},
					BlankMeasurement->False,
					Output->Options
				],
				BlankMeasurement
			],
			False
		],
		Example[{Options,Blank,"Specify the blank to use before measuring the absorbance of the sample:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					AliquotAmount->{{0.5 Milliliter,0.5 Milliliter},{0.3 Milliliter,0.3 Milliliter}},
					AssayVolume->1.1*Milliliter,
					BlankMeasurement->True,
					Blank -> Model[Sample, StockSolution, "1X UV buffer"],
					Output -> Options
				],
				Blank
			],
			ObjectP[Model[Sample, StockSolution, "1X UV buffer"]]
		],
		Example[{Options,Blank,"If not specified, automatically set to the value of AssayBuffer:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					AliquotAmount->{{0.5 Milliliter,0.5 Milliliter},{0.3 Milliliter,0.3 Milliliter}},
					AssayVolume->1.1*Milliliter,
					AssayBuffer -> {Model[Sample, StockSolution, "1X UV buffer"], Automatic},
					BlankMeasurement -> True,
					Output -> Options
				],
				Blank
			],
			{ObjectP[Model[Sample, StockSolution, "1X UV buffer"]], ObjectP[Model[Sample, "Milli-Q water"]]}
		],
		Example[{Options,Blank,"Specify the blank to use before measuring the absorbance of the sample:"},
			Download[
				ExperimentUVMelting[{
					{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},
					AliquotAmount->{{0.5 Milliliter,0.5 Milliliter},{0.3 Milliliter,0.3 Milliliter}},
					AssayVolume->1.1*Milliliter,
					BlankMeasurement->True,
					Blank -> Model[Sample, StockSolution, "1X UV buffer"]
				],
				Blanks
			],
			{ObjectP[Model[Sample, StockSolution, "1X UV buffer"]], ObjectP[Model[Sample, StockSolution, "1X UV buffer"]]}
		],
		Example[{Options,AliquotAmount,"Specify the aliquot volume that should be used from each input sample:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					AliquotAmount->{{0.5 Milliliter,0.5 Milliliter},{0.3 Milliliter,0.3 Milliliter}},
					Output->Options
				],
				AliquotAmount
			],
			{0.5 Milliliter,0.3 Milliliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,Wavelength,"Specify the wavelength of light that should be passed through the samples:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					Wavelength->260*Nanometer,
					Output->Options
				],
				Wavelength
			],
			260 Nanometer
		],
		Example[{Options,Wavelength,"Wavelength automatically resolves to 260 Nanometers if the samples contain oligomers:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					Wavelength->Automatic,
					Output->Options
				],
				Wavelength
			],
			260 Nanometer
		],
		Example[{Options,Wavelength,"Wavelength automatically resolves to 280 Nanometers if the samples do not contain oligomers (for instance, proteins instead):"},
			Lookup[
				ExperimentUVMelting[{{Object[Sample, "Water sample 2 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "Protein sample 3 for ExperimentUVMelting testing" <> $SessionUUID]}},
					Wavelength->Automatic,
					Output->Options
				],
				Wavelength
			],
			280 Nanometer
		],
		Example[{Options,MinWavelength,"Specify the range of wavelength of the light that should be passed through the sample during the measurement:"},
			Lookup[
				ExperimentUVMelting[{
					{Object[Sample, "Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "Water sample 2 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
					MinWavelength->200 Nanometer,
					MaxWavelength->300 Nanometer,
					Output->Options
				],
				{MinWavelength,MaxWavelength}
			],
			{200 Nanometer,300 Nanometer}
		],
		Example[{Options,MaxWavelength,"If MaxWavelength is provided, the lower limit of wavelength (MinWavelength) automatically resolves to the lowest possible wavelength (190 Nanometer):"},
			Lookup[
				ExperimentUVMelting[{{Object[Sample, "Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "Protein sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}},
					MinWavelength->Automatic,
					MaxWavelength->300 Nanometer,
					Output->Options
				],
				{MinWavelength,MaxWavelength}
			],
			{190 Nanometer,300 Nanometer}
		],
		Example[{Options,MinWavelength,"If MinWavelength is provided, the upper limit of wavelength (MaxWavelength) automatically resolves to the largest possible wavelength (900 Nanometer):"},
			Lookup[
				ExperimentUVMelting[{{Object[Sample, "Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "Protein sample 1 for ExperimentUVMelting testing" <> $SessionUUID]}},
					MinWavelength->500 Nanometer,
					MaxWavelength->Automatic,
					Output->Options
				],
				{MinWavelength,MaxWavelength}
			],
			{500 Nanometer,900 Nanometer}
		],

	(* some shared options *)

		Example[{Options,Confirm,"Indicate that the protocol should be moved directly into the queue:"},
			Download[
				ExperimentUVMelting[{{Object[Sample, "Protein sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "Protein sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},Confirm->True],
				Status
			],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options,CanaryBranch,"Specify the CanaryBranch on which the protocol is run:"},
			Download[
				ExperimentUVMelting[{{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},CanaryBranch->"d1cacc5a-948b-4843-aa46-97406bbfc368"],
				CanaryBranch
			],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Stubs:>{GitBranchExistsQ[___] = True, InternalUpload`Private`sllDistroExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		Example[{Options,Template,"Indicate that all the same options used for a previous protocol should be used again for the current protocol:"},
			Module[{templateUVMeltingProtocol,repeatProtocol},
			(* Create an initial protocol *)
				templateUVMeltingProtocol=ExperimentUVMelting[{{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},Wavelength->265 Nanometer];

				(* Create another protocol which will exactly repeat the first *)
				repeatProtocol=ExperimentUVMelting[{{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}},Template->templateUVMeltingProtocol];

				Download[
					{templateUVMeltingProtocol,repeatProtocol},
					{Wavelength,NestedIndexMatchingMixSamplePreparation[[All,Mix]],NestedIndexMatchingIncubateSamplePreparation[[All,Incubate]]}
				]
			],
			{
				{265.` Nanometer,{True},{False}},
				{265.` Nanometer,{True},{False}}
			}
		],
		Example[{Options,NumberOfReplicates,"Indicate each input sample should each be aliquotted 2 times into a different cuvette:"},
			Download[
				ExperimentUVMelting[
					{
						{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
						{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
					},
					NumberOfReplicates->2,
					AliquotAmount->20*Microliter,
					AssayVolume->1*Milliliter
				],
				{
					SamplesIn[Name],
					AliquotSamplePreparation[[All, AliquotAmount]],
					AssayBufferVolumes,
					ContainersOut
				}
			],
			{
				{
					"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID,
					"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID,
					"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID,
					"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID,
					"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID,
					"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID,
					"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID,
					"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID
				},
				{
					{EqualP[20.*Microliter], EqualP[20.*Microliter]},
					{EqualP[20.*Microliter], EqualP[20.*Microliter]},
					{EqualP[20.*Microliter], EqualP[20.*Microliter]},
					{EqualP[20.*Microliter], EqualP[20.*Microliter]}
				},
				{EqualP[960.*Microliter], EqualP[960.*Microliter], EqualP[960.*Microliter], EqualP[960.*Microliter]},
				{
					ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]],
					ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]],
					ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]],
					ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]
				}
			}
		],
		Example[{Options,Name,"Give the protocol to be created a unique identifier which can be used instead of its ID:"},
			Download[
				ExperimentUVMelting[{{Object[Container,Plate,"96-well plate 1 for UVMelting testing" <> $SessionUUID]}},Name->"Best Protocol Ever" <> $SessionUUID],
				Name
			],
			"Best Protocol Ever" <> $SessionUUID,
			TimeConstraint->300
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			Download[
				ExperimentUVMelting[{{Object[Container,Vessel,"50ml container 1 for UVMelting testing" <> $SessionUUID],Object[Container,Vessel,"50ml container 2 for UVMelting testing" <> $SessionUUID]}}, SamplesInStorageCondition -> Refrigerator],
				SamplesInStorage
			],
			{Refrigerator}
		],
		Example[{Options,SamplesOutStorageCondition,"Indicates how the output samples of the experiment should be stored:"},
			Download[
				ExperimentUVMelting[{{Object[Container,Vessel,"50ml container 1 for UVMelting testing" <> $SessionUUID],Object[Container,Vessel,"50ml container 2 for UVMelting testing" <> $SessionUUID]}}, SamplesOutStorageCondition -> Freezer],
				SamplesOutStorage
			],
			{Freezer}
		],
		Example[{Options,SamplesOutStorageCondition,"If samples are to be stored in different plates and different storage conditions, the index-syntax of ContainerOut can be used to indicate that:"},
			Lookup[ExperimentUVMelting[{
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
			},
				SamplesOutStorageCondition -> {Freezer,Freezer,Refrigerator,AmbientStorage,Disposal},
				ContainerOut->{{1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]},{1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]},{2,Model[Container,Plate,"96-well 2mL Deep Well Plate"]},Automatic,Null},
				Output->Options
			],SamplesOutStorageCondition],
			{Freezer,Freezer,Refrigerator,AmbientStorage,Disposal}
		],

		Example[{Options,SamplesOutStorageCondition,"Setting SamplesOutStorageCondition to Disposal marks samples to be disposed upon experiment completion rather than transferring them to the ContainerOut:"},
			Lookup[ExperimentUVMelting[
				{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
				SamplesOutStorageCondition -> {Freezer,Disposal}, Output->Options],SamplesOutStorageCondition],
			{Freezer,Disposal}
		],
		Example[{Options, ContainerOut, "Indicate the containers that the samples should be stored in upon completion of the experiment:"},
			Lookup[ExperimentUVMelting[
				{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
				ContainerOut -> {Automatic, {1, Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]}},
				Output -> Options], ContainerOut],
			{{2, ObjectP[Model[Container, Vessel, "1.5mL Tube with 2mL Tube Skirt"]]}, {1, ObjectP[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]]}}
		],
		Example[{Options,ContainerOut,"If ContainerOut is specified to a plate model, samples will be stored inside the same plate, if possible (as indicated by the tag):"},
			Lookup[ExperimentUVMelting[
				{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
				ContainerOut -> Model[Container,Plate,"48-well Pyramid Bottom Deep Well Plate"],
				Output->Options], ContainerOut],
			{{1,ObjectP[Model[Container,Plate,"48-well Pyramid Bottom Deep Well Plate"]]},{1,ObjectP[Model[Container,Plate,"48-well Pyramid Bottom Deep Well Plate"]]}}
		],
		Test["Populates the volumes of the buffers when we're diluting the samples (no ConcentratedBuffer specified):",
			Download[
				ExperimentUVMelting[
					{{Object[Container, Vessel, "50ml container 1 for UVMelting testing" <> $SessionUUID], Object[Container, Vessel, "50ml container 2 for UVMelting testing" <> $SessionUUID]}},
					AssayVolume -> 3.5 Milliliter,
					AliquotAmount -> 0.5 Milliliter
				],
				{AssayBufferVolumes, ConcentratedBufferVolumes, BufferDiluentVolumes}
			],
			{{EqualP[2500.` Microliter]}, {Null}, {Null}},
			TimeConstraint -> 600
		],
		Test["Populates the NestedIndexMatchingMixSamplePreparation and NestedIndexMatchingIncubateSamplePreparation protocol fields when we're mixing/ thermally incubating the pools:",
			Download[
				ExperimentUVMelting[
					{{Object[Container,Vessel,"50ml container 1 for UVMelting testing" <> $SessionUUID],Object[Container,Vessel,"50ml container 2 for UVMelting testing" <> $SessionUUID]}},
					BufferDilutionFactor -> 10,
					ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
					AssayVolume->950*Microliter,
					AliquotAmount->200*Microliter,
					NestedIndexMatchingIncubate->True
				],
				{NestedIndexMatchingMixSamplePreparation,NestedIndexMatchingIncubateSamplePreparation}
			],
			{
				{
					<|
						Mix -> True,
						MixType -> Pipette,
						NumberOfMixes -> 15,
						MixVolume -> 200.`*Microliter,
						Incubate -> False
					|>
				},
				{
					<|
						Incubate -> True,
						IncubationTemperature -> 85.`*Celsius,
						IncubationTime -> 300.`*Second,
						Mix -> False,
						MixType -> Null,
						MixUntilDissolved -> Null,
						MaxIncubationTime -> Null,
						IncubationInstrument -> Null,
						AnnealingTime -> 10800.`*Second,
						IncubateAliquotContainer -> Null,
						IncubateAliquot -> Null,
						IncubateAliquotDestinationWell -> Null
					|>
				}
			}
		],
		Test["Populates the PooledSamplesIn, SamplesIn, and ContainersIn properly when dealing with pooled inputs:",
			Download[ExperimentUVMelting[
				{
					{Object[Sample, "PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]},
					{Object[Sample, "DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
				},
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume->950*Microliter,
				AliquotAmount->200*Microliter
			], {PooledSamplesIn,SamplesIn,ContainersIn}
			],
			{
				{
					{ObjectP[Object[Sample]],ObjectP[Object[Sample]]},
					{ObjectP[Object[Sample]],ObjectP[Object[Sample]]}
				},
				{ObjectP[Object[Sample]],ObjectP[Object[Sample]],ObjectP[Object[Sample]],ObjectP[Object[Sample]]},
				{ObjectP[Object[Container,Vessel]],ObjectP[Object[Container,Vessel]],ObjectP[Object[Container,Vessel]],ObjectP[Object[Container,Vessel]]}
			}
		],

	(* SAMPLE PREP OPTIONS *)

	(* Note that for most of the sample needs to be liquid and for most tests requires Volume to be informed and above 1.5*Milliliter *)
	(* Relevant fields for Centrifuge are Footprint in Model[Container], the function CentrifugeDevices, the field MinTemperature/MaxTemperature in Centrifuge *)
	(* Useful for Filter is to run ExperimentFilter with Output->Options and see what the Automatic resolves to for your particualr container / volume *)

	(* THIS TEST TURNS ON ALL THE BOOLEAN MASTER SWITCHES -> AUTOMATIC RESOLUTION *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True, Output -> Options];
			{Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
			{True,True,True,True},
			Variables :> {options},
			TimeConstraint->600
		],
		Example[{Additional,"Sample preparation options can be indicated for each individual input sample:"},
			options=ExperimentUVMelting[{
				{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]},
				{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID]}
			},
			Incubate->{{True,True},{False,False}},
			Output -> Options];
			Lookup[options, Incubate],
			{{True,True},{False,False}},
			Variables :> {options},
			TimeConstraint->600
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for ExperimentUVMelting:"},
			Download[ExperimentUVMelting["My NestedIndexMatching Sample",
				PreparatoryUnitOperations-> {
					LabelContainer[
						Label->"My NestedIndexMatching Sample",
						Container->Model[Container,Vessel,"2mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Isopropanol"],
						Amount->500*Microliter,
						Destination->"My NestedIndexMatching Sample"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->30*Microliter,
						Destination->"My NestedIndexMatching Sample"
					]
				}
			],PreparatoryUnitOperations],
			{SamplePreparationP..},
			Messages:>{Warning::TransferRequired}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentUVMelting[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True
			],
			ObjectP[Object[Protocol, UVMelting]]
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentUVMelting[
				{{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]}},
				PreparedModelContainer -> Model[Container,Vessel,"50mL Tube"],
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
				{ObjectP[Model[Container,Vessel,"id:bq9LA0dBGGR6"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, IncubateAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, IncubateAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},{2, ObjectP[Model[Container, Vessel, "50mL Tube"]]}}},
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options, DestinationWell, "Indicates the desired position in the corresponding DestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

	(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, CentrifugeTime -> 5*Minute,CentrifugeInstrument->Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}}},
			Variables :> {options}
		],

	(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}},
				FilterMaterial -> PES,
				Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
	(* this test requires a 50ml tube and a larger volume and FilterMaterial HAS to be set to PTFE, and the volume needs to be between 1.5 and 50ml *)
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"50 mL PNA sample 5 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"50 mL PNA sample 6 for ExperimentUVMelting testing" <> $SessionUUID]}},
				FilterMaterial->PTFE,
				PrefilterMaterial -> GxF,
				AliquotAmount -> 0.7 Milliliter,
				Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"50 mL PNA sample 5 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"50 mL PNA sample 6 for ExperimentUVMelting testing" <> $SessionUUID]}},
				FilterPoreSize -> 0.22*Micrometer,
				AliquotAmount -> 0.7 Milliliter,
				Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"50 mL PNA sample 5 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"50 mL PNA sample 6 for ExperimentUVMelting testing" <> $SessionUUID]}},
				PrefilterPoreSize -> 1.*Micrometer,
				FilterMaterial -> PTFE,
				AliquotAmount -> 0.7 Milliliter,
				Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
	(* This test needs Volume 50ml *)
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentUVMelting[{{Object[Sample,"50 mL PNA sample 5 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"50 mL PNA sample 6 for ExperimentUVMelting testing" <> $SessionUUID]}},
				FiltrationType -> PeristalticPump,
				FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"],
				AliquotAmount -> 0.7 Milliliter,
				Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FilterAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FilterAliquotContainer -> Model[Container, Vessel, "15mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{{{1, ObjectP[Model[Container, Vessel, "15mL Tube"]]},{2, ObjectP[Model[Container, Vessel, "15mL Tube"]]}}},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, FilterContainerOut -> Model[Container, Vessel, "15mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{{{1, ObjectP[Model[Container, Vessel, "15mL Tube"]]},{2, ObjectP[Model[Container, Vessel, "15mL Tube"]]}}},
			Variables :> {options}
		],
	(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, AliquotAmount -> 1.6 Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			1.6*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, AliquotAmount -> 1.2 Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			1.2*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentUVMelting[{{Object[Sample,"50 mL PNA sample 5 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"50 mL PNA sample 6 for ExperimentUVMelting testing" <> $SessionUUID]}},
				AssayVolume -> 3.5 Milliliter,
				AliquotAmount -> 1 Milliliter,
				Output -> Options
			];
			Lookup[options, AssayVolume],
			3.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentUVMelting[
				{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}},
				TargetConcentration -> 400*Micromolar,
				Output -> Options
			];
			Lookup[options, TargetConcentration],
			400*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte to attain the desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentUVMelting[
				{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}},
				TargetConcentration -> 400*Micromolar,
				TargetConcentrationAnalyte -> {{Model[Molecule, Oligomer, "Test PNA for UVMelting" <> $SessionUUID], Model[Molecule, Oligomer, "Test PNA for UVMelting" <> $SessionUUID]}},
				Output -> Options
			];
			Lookup[options, TargetConcentrationAnalyte],
			{ObjectP[Model[Molecule, Oligomer, "Test PNA for UVMelting" <> $SessionUUID]]},
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}},
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume->1300*Microliter,
				AliquotAmount->400*Microliter,
				Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}},
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume->950*Microliter,
				AliquotAmount->200*Microliter,
				Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}},
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume->1000*Microliter,
				AliquotAmount->100*Microliter,
				Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AssayVolume->1.2*Milliliter,AliquotAmount->500*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		(* this one doesn't make sense since we're pooling, so a warning is thrown *)
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options},
			Messages :> {Warning::NestedIndexMatchingConsolidateAliquotsNotSupported}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}}, ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}},MeasureVolume->False],
				MeasureVolume
			],
			False
		],
		Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentUVMelting[{{Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID]}},MeasureWeight->False],
				MeasureWeight
			],
			False
		]

	},
	(* without this, telescope crashes and the test fails *)
	HardwareConfiguration->HighRAM,
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{uploadedObjects,existsFilter},
			uploadedObjects={
				(* containers *)
				Object[Container,Vessel,"Empty 50ml container 1 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 2 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 1 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 2 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 3 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 4 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 5 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 6 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 7 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 8 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 9 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 10 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 11 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 12 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 13 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 14 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 15 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 16 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 17 for UVMelting testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 18 for UVMelting testing" <> $SessionUUID],
				Object[Container,Cuvette,"50ml container 19 for UVMelting testing" <> $SessionUUID],
				Object[Container,Cuvette,"Micro sized Cuvette for UVMelting testing" <> $SessionUUID],
				Object[Container,Cuvette,"Medium sized Cuvette for UVMelting testing" <> $SessionUUID],
				Object[Container,Cuvette,"Medium sized Cuvette for UVMelting testing 2" <> $SessionUUID],
				Object[Container,Cuvette,"Macro sized Cuvette for UVMelting testing" <> $SessionUUID],
				Object[Container,Plate,"96-well plate 1 for UVMelting testing" <> $SessionUUID],
				Object[Container,Plate,"96-well plate 2 for UVMelting testing" <> $SessionUUID],
				(* models *)
				Model[Molecule, Oligomer, "Test DNA for UVMelting" <> $SessionUUID],
				Model[Molecule, Oligomer, "Test PNA for UVMelting" <> $SessionUUID],
				Model[Sample, "Test DNA oligomer for UVMelting" <> $SessionUUID],
				Model[Sample, "Test PNA oligomer for UVMelting" <> $SessionUUID],

				(* samples *)
				Object[Sample,"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Protein sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Protein sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Protein sample 3 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Water sample 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Sample in Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMelting testing 2" <> $SessionUUID],
				Object[Sample,"Sample in Standard cuvette for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Solid sample for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Discarded sample for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Small volume sample for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Incompatible volume sample for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"No volume sample for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Available sample 1 in plate 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Available sample 2 in plate 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Available sample 3 in plate 1 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Available sample 1 in plate 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Available sample 2 in plate 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"Available sample 3 in plate 2 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"50 mL PNA sample 5 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"50 mL PNA sample 6 for ExperimentUVMelting testing" <> $SessionUUID],
				Object[Sample,"PNA sample for ExperimentUVMelting testing with no model" <> $SessionUUID],
				(* the protocol for the template *)
				Object[Protocol,UVMelting,"Best Protocol Ever" <> $SessionUUID],
				Object[Instrument,Spectrophotometer,"Fake Spectrophotometer for UVMelting testing" <> $SessionUUID]

			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[uploadedObjects];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					uploadedObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{fakeInstrument,emptyContainer,secondEmptyContainer,emptyContainer1,emptyContainer2,
			emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,
			emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,emptyContainer12,
			emptyContainer13,emptyContainer14,emptyContainer15,emptyContainer16,emptyContainer17,emptyContainer18,emptyContainer19,
			microCuvette,mediumCuvette,mediumCuvette2,macroCuvette,plate1,plate2,availablePNA1,availablePNA2,availableDNA1,
			availableDNA2,availableProtein1,availableProtein2,availableProtein3,availableWater1,availableWater2,
			sampleInMicroCuvette,sampleInMediumCuvette,sampleInMediumCuvette2,sampleInMacroCuvette,solidSample7,discardedSample,
			sampleWithLittleVolume,sampleWithIncompatibleVolume,sampleWithNoVolume,sample1Plate1,
			sample2Plate1,sample3Plate1,sample1Plate2,sample2Plate2,sample3Plate2,sampleForSamplePrep1,
			sampleForSamplePrep2,sampleForSamplePrep3,sampleForSamplePrep4,samplefornomodeltest},

			(* Create some empty containers and some other useful things *)
			{emptyContainer,secondEmptyContainer,emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,
				emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,emptyContainer12,emptyContainer13,emptyContainer14,emptyContainer15,emptyContainer16,emptyContainer17,emptyContainer18,emptyContainer19,
				microCuvette,mediumCuvette,mediumCuvette2,macroCuvette,plate1,plate2,fakeInstrument}=Upload[{
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 1 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 2 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 1 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 2 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 3 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 4 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 5 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 6 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 7 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 8 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 9 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 10 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 11 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 12 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 13 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 14 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 15 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 16 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 17 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 18 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Semi-Micro Scale Black Walled UV Quartz Cuvette"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"50ml container 19 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Micro Scale Black Walled UV Quartz Cuvette"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Micro sized Cuvette for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Semi-Micro Scale Black Walled UV Quartz Cuvette"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Medium sized Cuvette for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container, Cuvette, "Semi-Micro 10mm Lighpath Quartz Cuvette"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Medium sized Cuvette for UVMelting testing 2" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Standard Scale Frosted UV Quartz Cuvette"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Macro sized Cuvette for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"96-well plate 1 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"96-well plate 2 for UVMelting testing" <> $SessionUUID, Status->Available|>,
				<|Type->Object[Instrument,Spectrophotometer],Model->Link[Model[Instrument, Spectrophotometer, "Cary 3500"],Objects],Site->Link[$Site],Status->Available,DeveloperObject->True,Name->"Fake Spectrophotometer for UVMelting testing" <> $SessionUUID|>
			}];


			(* Create some samples in those containers *)
			(* Create test DNA and PNA Models *)
			UploadOligomer[
				"Test DNA for UVMelting" <> $SessionUUID,
				Molecule -> Strand[DNA["AATTGTTCGGACACT"]],
				PolymerType -> DNA
			];

			UploadOligomer[
				"Test PNA for UVMelting" <> $SessionUUID,
				Molecule -> Strand[Modification["Acetylated"], PNA["ACTATCGGATCA", "H'"], Modification["3'-6-azido-L-norleucine"]],
				Enthalpy -> Quantity[-111.3`, ("KilocaloriesThermochemical")/("Moles")],
				Entropy -> Quantity[-319.3340126733501`, ("CaloriesThermochemical")/("Kelvins" "Moles")],
				FreeEnergy -> Quantity[-12.258555969360472`, ("KilocaloriesThermochemical")/("Moles")],
				PolymerType -> PNA
			];

			UploadSampleModel["Test DNA oligomer for UVMelting" <> $SessionUUID,
				Composition -> {
					{10 MassPercent, Model[Molecule, Oligomer, "Test DNA for UVMelting" <> $SessionUUID]},
					{90 MassPercent, Model[Molecule, "Water"]}
				},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null}, DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False, State -> Liquid, BiosafetyLevel -> "BSL-1"];

			UploadSampleModel["Test PNA oligomer for UVMelting" <> $SessionUUID,
				Composition -> {
					{10 MassPercent, Model[Molecule, Oligomer, "Test PNA for UVMelting" <> $SessionUUID]},
					{90 MassPercent, Model[Molecule, "Water"]}
				},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null}, DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False, State -> Liquid, BiosafetyLevel -> "BSL-1"];

			{
				availablePNA1,
				availablePNA2,
				availableDNA1,
				availableDNA2,
				availableProtein1,
				availableProtein2,
				availableProtein3,
				availableWater1,
				availableWater2,
				sampleInMicroCuvette,
				sampleInMediumCuvette,
				sampleInMediumCuvette2,
				sampleInMacroCuvette,
				solidSample7,
				discardedSample,
				sampleWithLittleVolume,
				sampleWithIncompatibleVolume,
				sampleWithNoVolume,

				sample1Plate1,
				sample2Plate1,
				sample3Plate1,
				sample1Plate2,
				sample2Plate2,
				sample3Plate2,

				sampleForSamplePrep1,
				sampleForSamplePrep2,
				sampleForSamplePrep3,
				sampleForSamplePrep4,

				samplefornomodeltest


			}=ECL`InternalUpload`UploadSample[
				{
					(* normal samples in falcon tubes *)
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample, "id:Vrbp1jKDwGjz"],
					Model[Sample, "id:Vrbp1jKDwGjz"],
					Model[Sample, "id:Vrbp1jKDwGjz"],
					Model[Sample,"RO Water"],
					Model[Sample,"RO Water"],

					(* samples in cuvettes *)
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test DNA oligomer for UVMelting" <> $SessionUUID],

					(* samples for error checking *)
					Model[Sample,"Fake salt chemical model for ExperimentMeasureWeight testing"],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],

					(* samples in plates *)
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMelting" <> $SessionUUID],

					(* samples for the sample prep tests *)
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID],

					(*sample for no model test*)
					Model[Sample,"Test PNA oligomer for UVMelting" <> $SessionUUID]

				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer5},
					{"A1", emptyContainer6},
					{"A1", emptyContainer18},
					{"A1", emptyContainer7},
					{"A1", emptyContainer8},

					{"A1",microCuvette},
					{"A1",mediumCuvette},
					{"A1",mediumCuvette2},
					{"A1",macroCuvette},

					{"A1", emptyContainer9},
					{"A1", emptyContainer10},
					{"A1", emptyContainer11},
					{"A1", emptyContainer12},
					{"A1", emptyContainer13},

					{"A1", plate1},
					{"A2", plate1},
					{"A3", plate1},
					{"A1", plate2},
					{"A2", plate2},
					{"A3", plate2},

					{"A1", emptyContainer14},
					{"A1", emptyContainer15},
					{"A1", emptyContainer16},
					{"A1", emptyContainer17},

					{"A1", emptyContainer19}

				},
				InitialAmount -> {
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.7 Milliliter,
					0.7 Milliliter,

					0.6 Milliliter,
					1 Milliliter,
					1 Milliliter,
					3 Milliliter,

					1 Milliliter,
					1 Milliliter,
					0.025 Milliliter, (* very little volume *)
					4.1 Milliliter,(* incompatible volume - to large to fit into micro and to small to fit into medium *)
					1 Milliliter,

					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,

					1.6 Milliliter,
					1.6 Milliliter,
					50 Milliliter,
					50 Milliliter,

					1 Milliliter

				}

			];
			Upload[{
				<|Object->availablePNA1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->availablePNA2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->availableDNA1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"DNA sample 1 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->availableDNA2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"DNA sample 2 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->availableProtein1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Protein sample 1 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->availableProtein2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Protein sample 2 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->availableProtein3,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Protein sample 3 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->availableWater1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Water sample 1 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->availableWater2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Water sample 2 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleInMicroCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleInMediumCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Semi-Micro cuvette for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleInMediumCuvette2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Semi-Micro cuvette for ExperimentUVMelting testing 2" <> $SessionUUID|>,
				<|Object->sampleInMacroCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Standard cuvette for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->solidSample7,DeveloperObject->True,Status->Available,Name->"Solid sample for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->discardedSample,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Discarded,Name->"Discarded sample for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleWithLittleVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Small volume sample for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleWithIncompatibleVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Incompatible volume sample for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleWithNoVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Volume->Null,Name->"No volume sample for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sample1Plate1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 1 in plate 1 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sample2Plate1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 2 in plate 1 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sample3Plate1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 3 in plate 1 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sample1Plate2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 1 in plate 2 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sample2Plate2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 2 in plate 2 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sample3Plate2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 3 in plate 2 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleForSamplePrep1,DeveloperObject->True,Replace[Composition] -> {{1000 Micromolar, Link[Model[Molecule, Oligomer, "Test PNA for UVMelting" <> $SessionUUID]], Now}, {100 VolumePercent, Link[Model[Molecule, "Water"]], Now}}, Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 3 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleForSamplePrep2,DeveloperObject->True,Replace[Composition] -> {{1000 Micromolar, Link[Model[Molecule, Oligomer, "Test PNA for UVMelting" <> $SessionUUID]], Now}, {100 VolumePercent, Link[Model[Molecule, "Water"]], Now}}, Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 4 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleForSamplePrep3,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"50 mL PNA sample 5 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->sampleForSamplePrep4,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"50 mL PNA sample 6 for ExperimentUVMelting testing" <> $SessionUUID|>,
				<|Object->samplefornomodeltest,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample for ExperimentUVMelting testing with no model" <> $SessionUUID|>
			}]
		];
		(*remove the model from the no model test sample*)
		Upload[<|Object->Object[Sample, "PNA sample for ExperimentUVMelting testing with no model" <> $SessionUUID],
			Model->Null
		|>];
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	}
];


(* ::Subsection::Closed:: *)
(*ExperimentUVMeltingOptions*)

DefineTests[ExperimentUVMeltingOptions,
	{
		Example[{Basic, "Return a list of options in table form for one sample:"},
			ExperimentUVMeltingOptions[Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID]],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for multiple samples:"},
			ExperimentUVMeltingOptions[{Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID],Object[Sample,"Sample in Micro cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID]}],
			Graphics_
		],
		Example[{Basic, "Return a list of options in table form for multiple pools:"},
			ExperimentUVMeltingOptions[{
				{Object[Sample, "PNA sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID]},
				{Object[Sample, "DNA sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID]}
			}
			],
			Graphics_
		],
		Example[{Options, OutputFormat, "If OutputFormat -> List, return a list of options rather than a table:"},
			ExperimentUVMeltingOptions[{
				{Object[Sample, "PNA sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID], Object[Sample, "PNA sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID]},
				{Object[Sample, "DNA sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID], Object[Sample, "DNA sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID]}
				},
				OutputFormat -> List],
			{__Rule}
		],
		Example[{Additional, "Return a list of options in table form for one container:"},
			ExperimentUVMeltingOptions[Object[Container,Cuvette,"Micro sized Cuvette for UVMeltingOptions testing" <> $SessionUUID]],
			Graphics_
		],
		Example[{Additional, "Return a list of options in table form for multiple containers:"},
			ExperimentUVMeltingOptions[{Object[Container,Cuvette,"Micro sized Cuvette for UVMeltingOptions testing" <> $SessionUUID],Object[Container,Cuvette,"Medium sized Cuvette for UVMeltingOptions testing" <> $SessionUUID]}],
			Graphics_
		]

	},
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects = {};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{uploadedObjects,existsFilter},
			uploadedObjects={
			(* containers *)
				Object[Container,Vessel,"Empty 50ml container 1 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 2 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 1 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 2 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 3 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 4 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 5 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 6 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 7 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 8 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 9 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 10 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 11 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 12 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 13 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 14 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 15 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 16 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Vessel,"50ml container 17 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Cuvette,"Micro sized Cuvette for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Cuvette,"Medium sized Cuvette for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Cuvette,"Macro sized Cuvette for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Plate,"96-well plate 1 for UVMeltingOptions testing" <> $SessionUUID],
				Object[Container,Plate,"96-well plate 2 for UVMeltingOptions testing" <> $SessionUUID],

				(* models *)
				Model[Molecule, Oligomer, "Test DNA for UVMeltingOptions testing" <> $SessionUUID],
				Model[Molecule, Oligomer, "Test PNA for UVMeltingOptions testing" <> $SessionUUID],
				Model[Sample, "Test DNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
				Model[Sample, "Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],

			(* samples *)
				Object[Sample,"PNA sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"PNA sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"DNA sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"DNA sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Protein sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Protein sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Water sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Water sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Sample in Micro cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Sample in Semi-Micro cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Sample in Standard cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Solid sample for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Discarded sample for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Small volume sample for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Incompatible volume sample for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"No volume sample for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Available sample 1 in plate 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Available sample 2 in plate 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Available sample 3 in plate 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Available sample 1 in plate 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Available sample 2 in plate 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"Available sample 3 in plate 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"PNA sample 3 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"PNA sample 4 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"50 mL PNA sample 5 for ExperimentUVMeltingOptions testing" <> $SessionUUID],
				Object[Sample,"50 mL PNA sample 6 for ExperimentUVMeltingOptions testing" <> $SessionUUID]


			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[uploadedObjects];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					uploadedObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{emptyContainer,secondEmptyContainer,emptyContainer1,emptyContainer2,emptyContainer3,
			emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,
			emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,
			emptyContainer12,emptyContainer13,emptyContainer14,emptyContainer15,emptyContainer16,emptyContainer17,
			microCuvette,mediumCuvette,macroCuvette,plate1,plate2,availablePNA1,availablePNA2,availableDNA1,
			availableDNA2,availableProtein1,availableProtein2,availableWater1,availableWater2,
			sampleInMicroCuvette,sampleInMediumCuvette,sampleInMacroCuvette,solidSample7,discardedSample,
			sampleWithLittleVolume,sampleWithIncompatibleVolume,sampleWithNoVolume,sample1Plate1,
			sample2Plate1,sample3Plate1,sample1Plate2,sample2Plate2,sample3Plate2,sampleForSamplePrep1,
			sampleForSamplePrep2,sampleForSamplePrep3,sampleForSamplePrep4},

			(* Create some empty containers and some other useful things *)
			{emptyContainer,secondEmptyContainer,emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,
				emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,emptyContainer12,emptyContainer13,emptyContainer14,emptyContainer15,emptyContainer16,emptyContainer17,
				microCuvette,mediumCuvette,macroCuvette,plate1,plate2}=Upload[{
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 1 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 2 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 1 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 2 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 3 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 4 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 5 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 6 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 7 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 8 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 9 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 10 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 11 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 12 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 13 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 14 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 15 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 16 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 17 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Micro Scale Black Walled UV Quartz Cuvette"],Objects],DeveloperObject->True,Name->"Micro sized Cuvette for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Semi-Micro Scale Black Walled UV Quartz Cuvette"],Objects],DeveloperObject->True,Name->"Medium sized Cuvette for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Standard Scale Frosted UV Quartz Cuvette"],Objects],DeveloperObject->True,Name->"Macro sized Cuvette for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],DeveloperObject->True,Name->"96-well plate 1 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],DeveloperObject->True,Name->"96-well plate 2 for UVMeltingOptions testing" <> $SessionUUID, Status->Available,Site->Link[$Site]|>
			}];
			(* Create test DNA and PNA Models *)
			UploadOligomer["Test DNA for UVMeltingOptions testing" <> $SessionUUID, Molecule -> Strand[DNA["AATTGTTCGGACACT"]],
				PolymerType -> DNA];

			UploadOligomer["Test PNA for UVMeltingOptions testing" <> $SessionUUID,Molecule ->
					Strand[Modification["Acetylated"], PNA["ACTATCGGATCA", "H'"],
						Modification["3'-6-azido-L-norleucine"]],
				Enthalpy ->
						Quantity[-111.3`, ("KilocaloriesThermochemical")/(
							"Moles")], Entropy ->
					Quantity[-319.3340126733501`, ("CaloriesThermochemical")/(
						"Kelvins" "Moles")], FreeEnergy ->
					Quantity[-12.258555969360472`, ("KilocaloriesThermochemical")/(
						"Moles")],
				PolymerType -> PNA];

			UploadSampleModel["Test DNA oligomer for UVMeltingOptions testing" <> $SessionUUID,
				Composition -> {{100 MassPercent,
					Model[Molecule, Oligomer, "Test DNA for UVMeltingOptions testing" <> $SessionUUID]}},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null}, DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False, State -> Liquid, BiosafetyLevel -> "BSL-1"];

			UploadSampleModel["Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID,
				Composition -> {{100 MassPercent,
					Model[Molecule, Oligomer, "Test PNA for UVMeltingOptions testing" <> $SessionUUID]}},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null}, DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False, State -> Liquid, BiosafetyLevel -> "BSL-1"];

			(* Create some samples in those containers *)
			{availablePNA1,
				availablePNA2,
				availableDNA1,
				availableDNA2,
				availableProtein1,
				availableProtein2,
				availableWater1,
				availableWater2,
				sampleInMicroCuvette,
				sampleInMediumCuvette,
				sampleInMacroCuvette,
				solidSample7,
				discardedSample,
				sampleWithLittleVolume,
				sampleWithIncompatibleVolume,
				sampleWithNoVolume,

				sample1Plate1,
				sample2Plate1,
				sample3Plate1,
				sample1Plate2,
				sample2Plate2,
				sample3Plate2,

				sampleForSamplePrep1,
				sampleForSamplePrep2,
				sampleForSamplePrep3,
				sampleForSamplePrep4

			}=ECL`InternalUpload`UploadSample[
				{
				(* normal samples in falcon tubes *)
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample, "id:Vrbp1jKDwGjz"],
					Model[Sample, "id:Vrbp1jKDwGjz"],
					Model[Sample,"RO Water"],
					Model[Sample,"RO Water"],

				(* samples in cuvettes *)
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test DNA oligomer for UVMeltingOptions testing" <> $SessionUUID],

				(* samples for error checking *)
					Model[Sample,"Fake salt chemical model for ExperimentMeasureWeight testing"],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],

				(* samples in plates *)
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMeltingOptions testing" <> $SessionUUID],

				(* samples for the sample prep tests *)
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingOptions testing" <> $SessionUUID]

				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer5},
					{"A1", emptyContainer6},
					{"A1", emptyContainer7},
					{"A1", emptyContainer8},

					{"A1",microCuvette},
					{"A1",mediumCuvette},
					{"A1",macroCuvette},

					{"A1", emptyContainer9},
					{"A1", emptyContainer10},
					{"A1", emptyContainer11},
					{"A1", emptyContainer12},
					{"A1", emptyContainer13},

					{"A1", plate1},
					{"A2", plate1},
					{"A3", plate1},
					{"A1", plate2},
					{"A2", plate2},
					{"A3", plate2},

					{"A1", emptyContainer14},
					{"A1", emptyContainer15},
					{"A1", emptyContainer16},
					{"A1", emptyContainer17}

				},
				InitialAmount -> {
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,

					0.6 Milliliter,
					1 Milliliter,
					3 Milliliter,

					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					0.8 Milliliter,(* incompatible volume - to large to fit into micro and to small to fit into medium *)
					1 Milliliter,

					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,

					1.6 Milliliter,
					1.6 Milliliter,
					50 Milliliter,
					50 Milliliter
				}
			];
			Upload[{
				<|Object->availablePNA1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->availablePNA2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->availableDNA1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"DNA sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->availableDNA2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"DNA sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->availableProtein1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Protein sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->availableProtein2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Protein sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->availableWater1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Water sample 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->availableWater2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Water sample 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleInMicroCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Micro cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleInMediumCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Semi-Micro cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleInMacroCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Standard cuvette for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->solidSample7,DeveloperObject->True,Status->Available,Name->"Solid sample for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->discardedSample,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Discarded,Name->"Discarded sample for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleWithLittleVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Small volume sample for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleWithIncompatibleVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Incompatible volume sample for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleWithNoVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Volume->Null,Name->"No volume sample for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sample1Plate1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 1 in plate 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sample2Plate1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 2 in plate 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sample3Plate1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 3 in plate 1 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sample1Plate2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 1 in plate 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sample2Plate2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 2 in plate 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sample3Plate2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Available sample 3 in plate 2 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,

				<|Object->sampleForSamplePrep1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 3 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleForSamplePrep2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 4 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleForSamplePrep3,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"50 mL PNA sample 5 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>,
				<|Object->sampleForSamplePrep4,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"50 mL PNA sample 6 for ExperimentUVMeltingOptions testing" <> $SessionUUID|>
			}]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Quiet[EraseObject[$CreatedObjects,Force->True,Verbose->False],EraseObject::NotFound];
		Unset[$CreatedObjects]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentUVMeltingPreview*)

DefineTests[ExperimentUVMeltingPreview,
	{
		Example[{Basic, "Return Null for one sample:"},
			ExperimentUVMeltingPreview[Object[Sample,"Sample in Semi-Micro cuvette for UVMeltingPreview testing"<>$SessionUUID]],
			Null
		],
		Example[{Basic, "Return  Null for multiple samples:"},
			ExperimentUVMeltingPreview[{Object[Sample,"Sample in Semi-Micro cuvette for UVMeltingPreview testing"<>$SessionUUID],Object[Sample,"Sample in Micro cuvette for UVMeltingPreview testing"<>$SessionUUID]}],
			Null
		],
		Example[{Basic, "Return  Null for multiple pools:"},
			ExperimentUVMeltingPreview[{
				{Object[Sample, "PNA sample 1 for UVMeltingPreview testing"<>$SessionUUID], Object[Sample, "PNA sample 2 for UVMeltingPreview testing"<>$SessionUUID]},
				{Object[Sample, "DNA sample 1 for UVMeltingPreview testing"<>$SessionUUID], Object[Sample, "DNA sample 2 for UVMeltingPreview testing"<>$SessionUUID]}
			}
			],
			Null
		],
		Example[{Additional, "Return Null for one container:"},
			ExperimentUVMeltingPreview[Object[Container,Cuvette,"Micro sized Cuvette for UVMeltingPreview testing"<>$SessionUUID]],
			Null
		],
		Example[{Additional, "Return Null for multiple containers:"},
			ExperimentUVMeltingPreview[{Object[Container,Cuvette,"Micro sized Cuvette for UVMeltingPreview testing"<>$SessionUUID],Object[Container,Cuvette,"Medium sized Cuvette for UVMeltingPreview testing"<>$SessionUUID]}],
			Null
		]
	},
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{uploadedObjects,existsFilter},
			uploadedObjects={
			(* containers *)
				Object[Container,Vessel,"50ml container 1 for UVMeltingPreview testing"<>$SessionUUID],
				Object[Container,Vessel,"50ml container 2 for UVMeltingPreview testing"<>$SessionUUID],
				Object[Container,Vessel,"50ml container 3 for UVMeltingPreview testing"<>$SessionUUID],
				Object[Container,Vessel,"50ml container 4 for UVMeltingPreview testing"<>$SessionUUID],
				Object[Container,Cuvette,"Micro sized Cuvette for UVMeltingPreview testing"<>$SessionUUID],
				Object[Container,Cuvette,"Medium sized Cuvette for UVMeltingPreview testing"<>$SessionUUID],
				(* models *)
				Model[Molecule, Oligomer, "Test DNA for UVMeltingPreview testing"<>$SessionUUID],
				Model[Molecule, Oligomer, "Test PNA for UVMeltingPreview testing"<>$SessionUUID],
				Model[Sample, "Test DNA oligomer for UVMeltingPreview testing"<>$SessionUUID],
				Model[Sample, "Test PNA oligomer for UVMeltingPreview testing"<>$SessionUUID],
			(* samples *)
				Object[Sample,"PNA sample 1 for UVMeltingPreview testing"<>$SessionUUID],
				Object[Sample,"PNA sample 2 for UVMeltingPreview testing"<>$SessionUUID],
				Object[Sample,"DNA sample 1 for UVMeltingPreview testing"<>$SessionUUID],
				Object[Sample,"DNA sample 2 for UVMeltingPreview testing"<>$SessionUUID],
				Object[Sample,"Sample in Micro cuvette for UVMeltingPreview testing"<>$SessionUUID],
				Object[Sample,"Sample in Semi-Micro cuvette for UVMeltingPreview testing"<>$SessionUUID]

			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[uploadedObjects];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					uploadedObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{emptyContainer,secondEmptyContainer,emptyContainer1,emptyContainer2,emptyContainer3,
			emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,
			emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,
			emptyContainer12,emptyContainer13,emptyContainer14,emptyContainer15,emptyContainer16,emptyContainer17,
			microCuvette,mediumCuvette,macroCuvette,plate1,plate2,availablePNA1,availablePNA2,availableDNA1,
			availableDNA2,availableProtein1,availableProtein2,availableWater1,availableWater2,
			sampleInMicroCuvette,sampleInMediumCuvette,sampleInMacroCuvette,solidSample7,discardedSample,
			sampleWithLittleVolume,sampleWithIncompatibleVolume,sampleWithNoVolume,sample1Plate1,
			sample2Plate1,sample3Plate1,sample1Plate2,sample2Plate2,sample3Plate2,sampleForSamplePrep1,
			sampleForSamplePrep2,sampleForSamplePrep3,sampleForSamplePrep4},

		(* Create some empty containers and some other useful things *)
			{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,microCuvette,mediumCuvette}=Upload[{
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 1 for UVMeltingPreview testing"<>$SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 2 for UVMeltingPreview testing"<>$SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 3 for UVMeltingPreview testing"<>$SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 4 for UVMeltingPreview testing"<>$SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Micro Scale Black Walled UV Quartz Cuvette"],Objects],DeveloperObject->True,Name->"Micro sized Cuvette for UVMeltingPreview testing"<>$SessionUUID, Status->Available,Site->Link[$Site]|>,
				<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Semi-Micro Scale Black Walled UV Quartz Cuvette"],Objects],DeveloperObject->True,Name->"Medium sized Cuvette for UVMeltingPreview testing"<>$SessionUUID, Status->Available,Site->Link[$Site]|>
			}];

			(* Create some samples in those containers *)
			(* Create test DNA and PNA Models *)
			UploadOligomer["Test DNA for UVMeltingPreview testing"<>$SessionUUID,
				Molecule -> Strand[DNA["AATTGTTCGGACACT"]],
				PolymerType -> DNA
			];

			UploadOligomer["Test PNA for UVMeltingPreview testing"<>$SessionUUID,
				Molecule -> Strand[Modification["Acetylated"], PNA["ACTATCGGATCA", "H'"],Modification["3'-6-azido-L-norleucine"]],
				Enthalpy -> Quantity[-111.3`, ("KilocaloriesThermochemical")/("Moles")],
				Entropy -> Quantity[-319.3340126733501`, ("CaloriesThermochemical")/("Kelvins" "Moles")],
				FreeEnergy -> Quantity[-12.258555969360472`, ("KilocaloriesThermochemical")/("Moles")],
				PolymerType -> PNA
			];

			UploadSampleModel["Test DNA oligomer for UVMeltingPreview testing"<>$SessionUUID,
				Composition -> {{100 MassPercent,Model[Molecule, Oligomer, "Test DNA for UVMeltingPreview testing"<>$SessionUUID]}},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null},
				DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False,
				State -> Liquid,
				BiosafetyLevel -> "BSL-1"
			];

			UploadSampleModel["Test PNA oligomer for UVMeltingPreview testing"<>$SessionUUID,
				Composition -> {{100 MassPercent,Model[Molecule, Oligomer, "Test PNA for UVMeltingPreview testing"<>$SessionUUID]}},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null}, DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False, State -> Liquid, BiosafetyLevel -> "BSL-1"];
			
			{availablePNA1,
				availablePNA2,
				availableDNA1,
				availableDNA2,
				sampleInMicroCuvette,
				sampleInMediumCuvette

			}=ECL`InternalUpload`UploadSample[
				{
				(* normal samples in falcon tubes *)
					Model[Sample,"Test PNA oligomer for UVMeltingPreview testing"<>$SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingPreview testing"<>$SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMeltingPreview testing"<>$SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMeltingPreview testing"<>$SessionUUID],
				(* samples in cuvettes *)
					Model[Sample,"Test PNA oligomer for UVMeltingPreview testing"<>$SessionUUID],
					Model[Sample,"Test PNA oligomer for UVMeltingPreview testing"<>$SessionUUID]
				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1",microCuvette},
					{"A1",mediumCuvette}
				},
				InitialAmount -> {
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					1 Milliliter
				}
			];
			Upload[{
				<|Object->availablePNA1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 1 for UVMeltingPreview testing"<>$SessionUUID|>,
				<|Object->availablePNA2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 2 for UVMeltingPreview testing"<>$SessionUUID|>,
				<|Object->availableDNA1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"DNA sample 1 for UVMeltingPreview testing"<>$SessionUUID|>,
				<|Object->availableDNA2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"DNA sample 2 for UVMeltingPreview testing"<>$SessionUUID|>,
				<|Object->sampleInMicroCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Micro cuvette for UVMeltingPreview testing"<>$SessionUUID|>,
				<|Object->sampleInMediumCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Semi-Micro cuvette for UVMeltingPreview testing"<>$SessionUUID|>
			}]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
				(* containers *)
					Object[Container,Vessel,"50ml container 1 for UVMeltingPreview testing"<>$SessionUUID],
					Object[Container,Vessel,"50ml container 2 for UVMeltingPreview testing"<>$SessionUUID],
					Object[Container,Vessel,"50ml container 3 for UVMeltingPreview testing"<>$SessionUUID],
					Object[Container,Vessel,"50ml container 4 for UVMeltingPreview testing"<>$SessionUUID],
					Object[Container,Cuvette,"Micro sized Cuvette for UVMeltingPreview testing"<>$SessionUUID],
					Object[Container,Cuvette,"Medium sized Cuvette for UVMeltingPreview testing"<>$SessionUUID],

				(* models *)
					Model[Molecule, Oligomer, "Test DNA for UVMeltingPreview testing"<>$SessionUUID],
					Model[Molecule, Oligomer, "Test PNA for UVMeltingPreview testing"<>$SessionUUID],
					Model[Sample, "Test DNA oligomer for UVMeltingPreview testing"<>$SessionUUID],
					Model[Sample, "Test PNA oligomer for UVMeltingPreview testing"<>$SessionUUID],

				(* samples *)
					Object[Sample,"PNA sample 1 for UVMeltingPreview testing"<>$SessionUUID],
					Object[Sample,"PNA sample 2 for UVMeltingPreview testing"<>$SessionUUID],
					Object[Sample,"DNA sample 1 for UVMeltingPreview testing"<>$SessionUUID],
					Object[Sample,"DNA sample 2 for UVMeltingPreview testing"<>$SessionUUID],
					Object[Sample,"Sample in Micro cuvette for UVMeltingPreview testing"<>$SessionUUID],
					Object[Sample,"Sample in Semi-Micro cuvette for UVMeltingPreview testing"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Quiet[EraseObject[$CreatedObjects,Force->True,Verbose->False],EraseObject::NotFound];
			Unset[$CreatedObjects]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentUVMeltingQ*)

DefineTests[ValidExperimentUVMeltingQ,
	{
		Example[{Basic, "Measure the UV melting curve of a given sample:"},
			ValidExperimentUVMeltingQ[Object[Sample,"Sample in Semi-Micro cuvette for ValidExperimentUVMeltingQ testing"]],
			True
		],
		Example[{Basic, "Measure the UV melting curve of multiple samples:"},
			ValidExperimentUVMeltingQ[{Object[Sample,"Sample in Semi-Micro cuvette for ValidExperimentUVMeltingQ testing"],Object[Sample,"Sample in Micro cuvette for ValidExperimentUVMeltingQ testing"]}],
			True
		],
		Example[{Basic, "Measure the UV melting curve of multiple pools:"},
			ValidExperimentUVMeltingQ[{
				{Object[Sample,"PNA sample 1 for ValidExperimentUVMeltingQ testing"], Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]},
				{Object[Sample, "DNA sample 1 for ValidExperimentUVMeltingQ testing"], Object[Sample, "DNA sample 2 for ValidExperimentUVMeltingQ testing"]}
			}
			],
			True
		],
		Example[{Options, Verbose, "If Verbose -> Failures, print the failing tests:"},
			ValidExperimentUVMeltingQ[{
				{Object[Sample,"Discarded sample for ValidExperimentUVMeltingQ testing"], Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]},
				{Object[Sample, "DNA sample 1 for ValidExperimentUVMeltingQ testing"], Object[Sample, "DNA sample 2 for ValidExperimentUVMeltingQ testing"]}
			},
				Verbose -> Failures],
			False
		],
		Example[{Options, OutputFormat, "If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentUVMeltingQ[{
				{Object[Sample,"Discarded sample for ValidExperimentUVMeltingQ testing"], Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]},
				{Object[Sample, "DNA sample 1 for ValidExperimentUVMeltingQ testing"], Object[Sample, "DNA sample 2 for ValidExperimentUVMeltingQ testing"]}
			},
				OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Additional, "Measure the UV melting curve of one container:"},
			ValidExperimentUVMeltingQ[Object[Container,Cuvette,"Micro sized Cuvette for ValidExperimentUVMeltingQ testing"]],
			True
		],
		Example[{Additional, "Measure the UV melting curve of multiple containers:"},
			ValidExperimentUVMeltingQ[{Object[Container,Cuvette,"Micro sized Cuvette for ValidExperimentUVMeltingQ testing"],Object[Container,Cuvette,"Medium sized Cuvette for ValidExperimentUVMeltingQ testing"]}],
			True
		],
		Example[{Messages, "DiscardedSamples", "If the provided sample is discarded, an error will be thrown:"},
			ValidExperimentUVMeltingQ[Object[Sample,"Discarded sample for ValidExperimentUVMeltingQ testing"]],
			False
		],
		Example[{Messages,"NonLiquidSample","If the given input sample is Solid, an error will be thrown:"},
			ValidExperimentUVMeltingQ[{{Object[Sample,"Solid sample for ValidExperimentUVMeltingQ testing"],Object[Sample, "Protein sample 1 for ValidExperimentUVMeltingQ testing"]}}],
			False
		],
		Example[{Messages,"IncompatibleSpectrophotometer","Only spectrophotometers with UV/Vis capabilities can be used for this experiment:"},
			ValidExperimentUVMeltingQ[{{Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"]}},
				Instrument->Object[Instrument, Spectrophotometer, "id:qdkmxzqGbkmp"]
			],
			False
		],
		Example[{Messages,"IncompatibleCuvette","The container in which the samples are to be pooled and measured (AliquotContainer) has to be compatible with the instrument (for example, it has to be made of quartz):"},
			ValidExperimentUVMeltingQ[{Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]},
			(* cuvette not made of quartz *)
				AliquotContainer->Model[Container, Cuvette, "id:M8n3rxYE557M"]
			],
			False
		],
		Example[{Messages,"NestedIndexMatchingVolumeOutOfRange","Samples with assay volume (total volume of samples and buffers inside a particular pool) smaller than the minimum working range of the smallest cuvette cannot be reliably measured:"},
			ValidExperimentUVMeltingQ[{{Object[Sample,"Small volume sample for ValidExperimentUVMeltingQ testing"],Object[Sample,"Small volume sample for ValidExperimentUVMeltingQ testing"]}}],
			False
		],
		Example[{Messages,"MismatchingNestedIndexMatchingdMixOptions","If the NestedIndexMatchingMix boolean option is turned to False, other mixing options for the pool cannot be specified:"},
			ValidExperimentUVMeltingQ[
				{{Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]}},
				NestedIndexMatchingMix->False,
				NestedIndexMatchingMixType->Pipette
			],
			False
		],
		Example[{Messages,"NestedIndexMatchingMixVolumeNotCompatibleWithMixType","If NestedIndexMatchingMixType is specified to Pipette, NestedIndexMatchingMixVolume cannot be set to Null:"},
			ValidExperimentUVMeltingQ[
				{{Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]}},
				NestedIndexMatchingMix->True,
				NestedIndexMatchingMixType->Pipette,
				NestedIndexMatchingMixVolume->Null
			],
			False
		],
		Example[{Messages,"NestedIndexMatchingMixVolumeNotCompatibleWithMixType","If NestedIndexMatchingMixType is specified to Invert, NestedIndexMatchingMixVolume cannot be set to a volume:"},
			ValidExperimentUVMeltingQ[
				{{Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]}},
				NestedIndexMatchingMix->True,
				NestedIndexMatchingMixType->Invert,
				NestedIndexMatchingMixVolume->300 Microliter
			],
			False
		],
		Example[{Messages,"MismatchingNestedIndexMatchingIncubateOptions","If the NestedIndexMatchingIncubate boolean option is turned to False, other incubation options for the pool(s) cannot be specified:"},
			ValidExperimentUVMeltingQ[
				{{Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]}},
				NestedIndexMatchingIncubate->False,
				NestedIndexMatchingIncubationTemperature->30 Celsius
			],
			False
		],
		Example[{Messages,"InvalidWavelengthRange","MinWavelength must be smaller than MaxWavelength:"},
			ValidExperimentUVMeltingQ[{{Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"]}},
				MaxWavelength -> 300 Nanometer,
				MinWavelength -> 500 Nanometer
			],
			False
		],
		Example[{Messages,"TooManyUVMeltingSamples","The number of samples or sample pools to be measured cannot exceed the number of available slots in the cuvette block of the instrument:"},
			ValidExperimentUVMeltingQ[{
				Object[Sample, "PNA sample 1 for ValidExperimentUVMeltingQ testing"],
				Object[Sample, "PNA sample 2 for ValidExperimentUVMeltingQ testing"],
				Object[Sample, "DNA sample 1 for ValidExperimentUVMeltingQ testing"],
				Object[Sample, "DNA sample 2 for ValidExperimentUVMeltingQ testing"],
				Object[Sample, "Protein sample 1 for ValidExperimentUVMeltingQ testing"],
				Object[Sample, "Protein sample 2 for ValidExperimentUVMeltingQ testing"],
				Object[Sample, "Water sample 1 for ValidExperimentUVMeltingQ testing"],
				Object[Sample, "Water sample 2 for ValidExperimentUVMeltingQ testing"]
			}, NumberOfReplicates -> 5],
			False
		],
		Example[{Messages,"UnableToBlank","BlankMeasurement can only be set to True if we're using an AliquotContainer to mix the input sample(s) with buffer:"},
			ValidExperimentUVMeltingQ[{Object[Sample,"Sample in Micro cuvette for ValidExperimentUVMeltingQ testing"]},
				BlankMeasurement -> True
			],
			False
		],
		Example[{Messages,"SamplesOutStorageConditionConflict","If SamplesOutStorageCondition is set to Disposal, ContainerOut can't be specified:"},
			ValidExperimentUVMeltingQ[{
				{Object[Sample,"DNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample,"DNA sample 2 for ValidExperimentUVMeltingQ testing"]},
				{Object[Sample,"PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample,"PNA sample 2 for ValidExperimentUVMeltingQ testing"]}},
				BufferDilutionFactor -> {10,10},
				ConcentratedBuffer -> {Model[Sample, StockSolution, "10x UV buffer"],Model[Sample, StockSolution, "10x UV buffer"]},
				AssayVolume->{950*Microliter,1000*Microliter},
				AliquotAmount->{200*Microliter,250*Microliter},
				ContainerOut->Model[Container,Plate,"48-well Pyramid Bottom Deep Well Plate"],
				SamplesOutStorageCondition->Disposal
			],
			False
		],
		Example[{Messages,"ContainerOutMismatchedIndex","When specifying ContainerOut using the index syntax, each :"},
			ValidExperimentUVMeltingQ[{
				{Object[Sample,"DNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample,"DNA sample 2 for ValidExperimentUVMeltingQ testing"]},
				{Object[Sample,"PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample,"PNA sample 2 for ValidExperimentUVMeltingQ testing"]}},
				ContainerOut->{{1,Model[Container,Plate,"48-well Pyramid Bottom Deep Well Plate"]},{1,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}}
			],
			False
		],
		Example[{Messages,"ContainerOverOccupied","The specified ContainerOut cannot request more positions than the container has:"},
			ValidExperimentUVMeltingQ[{
				{Object[Sample,"DNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample,"DNA sample 2 for ValidExperimentUVMeltingQ testing"]},
				{Object[Sample,"PNA sample 1 for ValidExperimentUVMeltingQ testing"],Object[Sample,"PNA sample 2 for ValidExperimentUVMeltingQ testing"]}},
				ContainerOut->{{1,Model[Container,Plate,"48-well Pyramid Bottom Deep Well Plate"]},{1,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}}
			],
			False
		],
		Test["If giving a string as the input, this function still works properly:",
			ValidExperimentUVMeltingQ["My NestedIndexMatching Sample",
				PreparatoryUnitOperations-> {
					LabelContainer[
						Label->"My NestedIndexMatching Sample",
						Container->Model[Container,Vessel,"2mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Isopropanol"],
						Amount->500*Microliter,
						Destination->"My NestedIndexMatching Sample"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->30*Microliter,
						Destination->"My NestedIndexMatching Sample"
					]
				}
			],
			True
		]
	},
	Stubs:>{
		$EmailEnabled=False
	},
	HardwareConfiguration -> HighRAM,
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects = {};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{uploadedObjects,existsFilter},
			uploadedObjects={
			(* containers *)
				Object[Container,Vessel,"Empty 50ml container 1 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"Empty 50ml container 2 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 1 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 2 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 3 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 4 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 5 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 6 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 7 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 8 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 9 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 10 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 11 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 12 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Vessel,"50ml container 13 for ValidExperimentUVMeltingQ testing"],
				Object[Container,Cuvette,"Micro sized Cuvette for ValidExperimentUVMeltingQ testing"],
				Object[Container,Cuvette,"Medium sized Cuvette for ValidExperimentUVMeltingQ testing"],
				Object[Container,Cuvette,"Macro sized Cuvette for ValidExperimentUVMeltingQ testing"],

			(* models *)
				Model[Molecule, Oligomer, "Test DNA for ValidExperimentUVMeltingQ testing"],
				Model[Molecule, Oligomer, "Test PNA for ValidExperimentUVMeltingQ testing"],
				Model[Sample, "Test DNA oligomer for ValidExperimentUVMeltingQ testing"],
				Model[Sample, "Test PNA oligomer for ValidExperimentUVMeltingQ testing"],

			(* samples *)
				Object[Sample,"PNA sample 1 for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"PNA sample 2 for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"DNA sample 1 for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"DNA sample 2 for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Protein sample 1 for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Protein sample 2 for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Water sample 1 for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Water sample 2 for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Sample in Micro cuvette for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Sample in Semi-Micro cuvette for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Sample in Standard cuvette for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Solid sample for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Discarded sample for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Small volume sample for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"Incompatible volume sample for ValidExperimentUVMeltingQ testing"],
				Object[Sample,"No volume sample for ValidExperimentUVMeltingQ testing"]

			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[uploadedObjects];
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					uploadedObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{emptyContainer,secondEmptyContainer,emptyContainer1,emptyContainer2,emptyContainer3,
			emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,
			emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,
			emptyContainer12,emptyContainer13,
			microCuvette,mediumCuvette,macroCuvette,availablePNA1,availablePNA2,availableDNA1,
			availableDNA2,availableProtein1,availableProtein2,availableWater1,availableWater2,
			sampleInMicroCuvette,sampleInMediumCuvette,sampleInMacroCuvette,solidSample7,discardedSample,
			sampleWithLittleVolume,sampleWithIncompatibleVolume,sampleWithNoVolume},

			(* Create some empty containers and some other useful things *)
			{emptyContainer,secondEmptyContainer,emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,
				emptyContainer8,emptyContainer9,emptyContainer10,emptyContainer11,emptyContainer12,emptyContainer13,
				microCuvette,mediumCuvette,macroCuvette}=Upload[{
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 1 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 2 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 1 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 2 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 3 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 4 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 5 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 6 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 7 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 8 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 9 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 10 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 11 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 12 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"50ml container 13 for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Micro Scale Black Walled UV Quartz Cuvette"],Objects],DeveloperObject->True,Name->"Micro sized Cuvette for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Semi-Micro Scale Black Walled UV Quartz Cuvette"],Objects],DeveloperObject->True,Name->"Medium sized Cuvette for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>,
					<|Type->Object[Container,Cuvette],Model->Link[Model[Container,Cuvette,"Standard Scale Frosted UV Quartz Cuvette"],Objects],DeveloperObject->True,Name->"Macro sized Cuvette for ValidExperimentUVMeltingQ testing", Site -> Link[$Site], Status->Available|>
				}
			];

			(* Create some samples in those containers *)
			(* Create test DNA and PNA Models *)
			UploadOligomer["Test DNA for ValidExperimentUVMeltingQ testing",
				Molecule -> Strand[DNA["AATTGTTCGGACACT"]],
				PolymerType -> DNA
			];

			UploadOligomer["Test PNA for ValidExperimentUVMeltingQ testing",
				Molecule ->
					Strand[Modification["Acetylated"], PNA["ACTATCGGATCA", "H'"],
						Modification["3'-6-azido-L-norleucine"]],
				Enthalpy ->
						Quantity[-111.3`, ("KilocaloriesThermochemical")/(
							"Moles")], Entropy ->
					Quantity[-319.3340126733501`, ("CaloriesThermochemical")/(
						"Kelvins" "Moles")], FreeEnergy ->
					Quantity[-12.258555969360472`, ("KilocaloriesThermochemical")/(
						"Moles")],
				PolymerType -> PNA];

			UploadSampleModel["Test DNA oligomer for ValidExperimentUVMeltingQ testing",
				Composition -> {{100 MassPercent,
					Model[Molecule, Oligomer, "Test DNA for ValidExperimentUVMeltingQ testing"]}},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null}, DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False, State -> Liquid, BiosafetyLevel -> "BSL-1"
			];

			UploadSampleModel["Test PNA oligomer for ValidExperimentUVMeltingQ testing",
				Composition -> {{100 MassPercent,
					Model[Molecule, Oligomer, "Test PNA for ValidExperimentUVMeltingQ testing"]}},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null}, DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False, State -> Liquid, BiosafetyLevel -> "BSL-1"
			];


			(* Create some samples in those containers *)
			{availablePNA1,
				availablePNA2,
				availableDNA1,
				availableDNA2,
				availableProtein1,
				availableProtein2,
				availableWater1,
				availableWater2,
				sampleInMicroCuvette,
				sampleInMediumCuvette,
				sampleInMacroCuvette,
				solidSample7,
				discardedSample,
				sampleWithLittleVolume,
				sampleWithIncompatibleVolume,
				sampleWithNoVolume

			}=UploadSample[
				{
				(* normal samples in falcon tubes *)
					Model[Sample, "Test PNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample,"Test PNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample, "Test DNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample, "Test DNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample, "id:Vrbp1jKDwGjz"],
					Model[Sample, "id:Vrbp1jKDwGjz"],
					Model[Sample,"RO Water"],
					Model[Sample,"RO Water"],

				(* samples in cuvettes *)
					Model[Sample,"Test PNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample,"Test PNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample,"Test DNA oligomer for ValidExperimentUVMeltingQ testing"],

				(* samples for error checking *)
					Model[Sample,"Fake salt chemical model for ExperimentMeasureWeight testing"],
					Model[Sample,"Test PNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample,"Test PNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample,"Test PNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample,"Test PNA oligomer for ValidExperimentUVMeltingQ testing"]

				},
				{
					{"A1", emptyContainer1},
					{"A1", emptyContainer2},
					{"A1", emptyContainer3},
					{"A1", emptyContainer4},
					{"A1", emptyContainer5},
					{"A1", emptyContainer6},
					{"A1", emptyContainer7},
					{"A1", emptyContainer8},

					{"A1",microCuvette},
					{"A1",mediumCuvette},
					{"A1",macroCuvette},

					{"A1", emptyContainer9},
					{"A1", emptyContainer10},
					{"A1", emptyContainer11},
					{"A1", emptyContainer12},
					{"A1", emptyContainer13}

				},
				InitialAmount -> {
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,
					0.6 Milliliter,

					0.6 Milliliter,
					1 Milliliter,
					3 Milliliter,

					1 Milliliter,
					1 Milliliter,
					0.01 Milliliter, (*  *)
					0.8 Milliliter,(* incompatible volume - to large to fit into micro and to small to fit into medium *)
					1 Milliliter

				}

			];
			Upload[{
				<|Object->availablePNA1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 1 for ValidExperimentUVMeltingQ testing"|>,
				<|Object->availablePNA2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"PNA sample 2 for ValidExperimentUVMeltingQ testing"|>,
				<|Object->availableDNA1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"DNA sample 1 for ValidExperimentUVMeltingQ testing"|>,
				<|Object->availableDNA2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"DNA sample 2 for ValidExperimentUVMeltingQ testing"|>,
				<|Object->availableProtein1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Protein sample 1 for ValidExperimentUVMeltingQ testing"|>,
				<|Object->availableProtein2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Protein sample 2 for ValidExperimentUVMeltingQ testing"|>,
				<|Object->availableWater1,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Water sample 1 for ValidExperimentUVMeltingQ testing"|>,
				<|Object->availableWater2,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Water sample 2 for ValidExperimentUVMeltingQ testing"|>,
				<|Object->sampleInMicroCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Micro cuvette for ValidExperimentUVMeltingQ testing"|>,
				<|Object->sampleInMediumCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Semi-Micro cuvette for ValidExperimentUVMeltingQ testing"|>,
				<|Object->sampleInMacroCuvette,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Sample in Standard cuvette for ValidExperimentUVMeltingQ testing"|>,
				<|Object->solidSample7,DeveloperObject->True,Status->Available,Name->"Solid sample for ValidExperimentUVMeltingQ testing"|>,
				<|Object->discardedSample,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Discarded,Name->"Discarded sample for ValidExperimentUVMeltingQ testing"|>,
				<|Object->sampleWithLittleVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Small volume sample for ValidExperimentUVMeltingQ testing"|>,
				<|Object->sampleWithIncompatibleVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Name->"Incompatible volume sample for ValidExperimentUVMeltingQ testing"|>,
				<|Object->sampleWithNoVolume,DeveloperObject->True,Concentration->1000 Micro Molar,Status->Available,Volume->Null,Name->"No volume sample for ValidExperimentUVMeltingQ testing"|>

			}]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					(* containers *)
					Object[Container,Vessel,"Empty 50ml container 1 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"Empty 50ml container 2 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 1 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 2 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 3 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 4 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 5 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 6 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 7 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 8 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 9 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 10 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 11 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 12 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Vessel,"50ml container 13 for ValidExperimentUVMeltingQ testing"],
					Object[Container,Cuvette,"Micro sized Cuvette for ValidExperimentUVMeltingQ testing"],
					Object[Container,Cuvette,"Medium sized Cuvette for ValidExperimentUVMeltingQ testing"],
					Object[Container,Cuvette,"Macro sized Cuvette for ValidExperimentUVMeltingQ testing"],

					(* models *)
					Model[Molecule, Oligomer, "Test DNA for ValidExperimentUVMeltingQ testing"],
					Model[Molecule, Oligomer, "Test PNA for ValidExperimentUVMeltingQ testing"],
					Model[Sample, "Test DNA oligomer for ValidExperimentUVMeltingQ testing"],
					Model[Sample, "Test PNA oligomer for ValidExperimentUVMeltingQ testing"],

					(* samples *)
					Object[Sample,"PNA sample 1 for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"PNA sample 2 for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"DNA sample 1 for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"DNA sample 2 for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Protein sample 1 for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Protein sample 2 for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Water sample 1 for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Water sample 2 for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Sample in Micro cuvette for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Sample in Semi-Micro cuvette for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Sample in Standard cuvette for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Solid sample for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Discarded sample for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Small volume sample for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"Incompatible volume sample for ValidExperimentUVMeltingQ testing"],
					Object[Sample,"No volume sample for ValidExperimentUVMeltingQ testing"]

				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Quiet[EraseObject[$CreatedObjects,Force->True,Verbose->False],EraseObject::NotFound];
			Unset[$CreatedObjects]
		]
	)
];
