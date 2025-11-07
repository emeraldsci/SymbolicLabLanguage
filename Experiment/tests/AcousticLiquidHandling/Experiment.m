(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentAcousticLiquidHandling : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentAcousticLiquidHandling*)


(* ::Subsubsection:: *)
(*ExperimentAcousticLiquidHandling*)


DefineTests[
	ExperimentAcousticLiquidHandling,
	{
		Example[{Basic,"Transfer a specified volume of a sample to an empty container:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1",Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]]
		],
		Example[{Basic,"Transfer a specified volume of a sample into another sample in a different container:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Destination Sample"<>$SessionUUID],
				100 Nanoliter
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]]
		],
		Test["Transfer a specified volume of a sample to an empty container specified as a model:",
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1",Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"]},
				100 Nanoliter
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]]
		],
		Example[{Basic,"Aliquot specified volumes of a sample into multiple destination containers:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {3,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}
				},
				{25 Nanoliter,50 Nanoliter,100 Nanoliter}
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]]
		],
		Example[{Basic,"Consolidate specific volumes of multiple samples from different containers into a single destination well:"},
			ExperimentAcousticLiquidHandling[
				{Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID]},
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				{50 Nanoliter,100 Nanoliter}
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]]
		],
		Test["Handle mixed input specifications:",
			ExperimentAcousticLiquidHandling[
				{
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Container, Plate, "AcousticLiquidHandling Test Source Plate 1"<>$SessionUUID],
					{"A1", Object[Container, Plate, "AcousticLiquidHandling Test Source Plate 2"<>$SessionUUID]}
				},
				{
					Object[Sample,"AcousticLiquidHandling Test Destination Sample"<>$SessionUUID],
					{"A1", {1,Model[Container, Plate, "384-well Polypropylene Echo Qualified Plate"]}},
					{"A1", {2,Model[Container, Plate, "384-well Polypropylene Echo Qualified Plate"]}},
					{"A1", {3,Model[Container, Plate, "384-well Polypropylene Echo Qualified Plate"]}}
				},
				100 Nanoliter
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]],
			Messages :> {Warning::SampleAndContainerSpecified}
		],

		(* ---------------- *)
		(* --- MESSAGES --- *)
		(* ---------------- *)

		(* ---main function messages--- *)
		Example[{Messages, "ObjectDoesNotExist", "Throws an error and fails cleanly if an object is specified in the unit operations that does not exist (ID form):"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"id:123456"],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throws an error and fails cleanly if an object is specified in the unit operations that does not exist (name form):"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"Nonexistent object"],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"InputLengthMismatch","The length of Amounts Key values defined in input primitives much match the length of Sources in Aliquot primitive and Destinations in Consolidation primitive:"},
			ExperimentAcousticLiquidHandling[
				{
					Object[Sample, "AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID]
				},
				{
					{"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}
				},
				{
					50 Nanoliter, 100 Nanoliter
				}
			],
			$Failed,
			Messages:>{Error::InputLengthMismatch}
		],

		(* ---resolver messages--- *)

		Example[{Messages,"AliquotContainerOccupied","If the AliquotContainer option is specified as a plate object, the plate must be empty:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID], {"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]}, 100 Nanoliter,
				AliquotContainer->{Object[Container,Plate,"AcousticLiquidHandling Test Occupied Destination Plate"<>$SessionUUID]}
			],
			$Failed,
			Messages:>{
				Error::AliquotContainerOccupied,
				Error::AliquotContainers,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TotalAliquotVolumeTooLarge","If the Aliquot option is True, the sample must have enough volume to be aliquoted:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Low Volume Sample in 50mL Tube"<>$SessionUUID], {"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]}, 100 Nanoliter,
				Aliquot->True
			],
			$Failed,
			Messages:>{
				Error::TotalAliquotVolumeTooLarge,
				Error::InvalidInput
			}
		],
		Example[{Messages,"MultipleSourceContainerModels","All source containers must have the same model:"},
			ExperimentAcousticLiquidHandling[
				{Object[Sample, "AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID], Object[Sample,"AcousticLiquidHandling Test Low Dead Volume Sample"<>$SessionUUID]},
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter,
				Aliquot->False
			],
			$Failed,
			Messages:>{
				Error::MultipleSourceContainerModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ContainerWithNonInputSamples","Throws a warning message if source container has non-input samples:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 4"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]],
			Messages:>{Warning::ContainerWithNonInputSamples}
		],
		Example[{Messages,"MultipleDestinationContainerModels","All destination containers must have the same model:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{
					{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
					{"A1", Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"]}
				},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::MultipleDestinationContainerModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DiscardedSourceSamples","Source samples that are discarded cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Discarded Source Sample"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::DiscardedSourceSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedSourceModels","Source samples whose models are deprecated cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Deprecated Source Sample"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::DeprecatedSourceModels,
				Error::InvalidInput
			}
		],
		Example[{Messages,"NonLiquidSourceSamples","Source samples whose states are not liquid cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Solid Sample"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::SolidSamplesUnsupported,
				Error::NonLiquidSourceSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"PrimitivesWithContainerlessSamples","Source samples are required to be in a container:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Containerless Sample"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter,
				Aliquot->False
			],
			$Failed,
			Messages:>{
				Error::PrimitivesWithContainerlessSamples,
				Error::IncompatibleSourceContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"IncompatibleSourceContainer","Source samples are required to be in a container compatible with an acoustic liquid handling:"},
			ExperimentAcousticLiquidHandling[
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Invalid Source Plate"<>$SessionUUID]},
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter,
				Aliquot->False
			],
			$Failed,
			Messages:>{
				Error::IncompatibleSourceContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DiscardedDestinationContainer","Destination containers that are discarded cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Discarded Destination Container"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::DiscardedDestinationContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DeprecatedDestinationContainerModel","Destination containers whose models are deprecated cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1", Model[Container, Plate, "384-well Optical Reaction Plate"]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::DeprecatedDestinationContainerModel,
				Error::IncompatibleAcousticLiquidHandlingDestinationContainer,
				Error::MissingLabwareDefinitionFields,
				Error::InvalidInput
			}
		],
		Example[{Messages,"IncompatibleDestinationContainer","Destination containers whose models are incompatible with an acoustic liquid handler cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1", Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::IncompatibleAcousticLiquidHandlingDestinationContainer,
				Error::MissingLabwareDefinitionFields,
				Error::InvalidInput
			}
		],
		Example[{Messages,"MissingLabwareDefinitionFields","Destination containers whose models are missing required Fields for creating labware definition cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1", Model[Container,Plate,"96-well 2mL Deep Well Plate"]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::IncompatibleAcousticLiquidHandlingDestinationContainer,
				Error::MissingLabwareDefinitionFields,
				Error::InvalidInput
			}
		],
		Example[{Messages,"UnsafeDestinationVolume","Destination containers with volumes that may spill during manipulation cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Destination Plate With Unsafe Volume"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::UnsafeDestinationVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages,"AmountOutOfRange","The Amount defined in the input primitives must be withing the volume range supported by the instrument:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				10 Microliter
			],
			$Failed,
			Messages:>{
				Error::AmountOutOfRange,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InsufficientSourceVolume","The source samples with insufficient volume to satisfy all manipulations cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{
					{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
					{"A2", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
					{"A3", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
					{"A4", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]}
				},
				5 Microliter
			],
			$Failed,
			Messages:>{
				Error::InsufficientSourceVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages,"SamePlateTransfer","Transfer between wells in the same container is not supported by ExperimentAcousticLiquidHandling:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"C1", Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 1"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::SamePlateTransfer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidDestinationWellAcousticLiquidHandling","Destination Wells that are not in the AllowedPositions of the container cannot be provided:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"S20", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::InvalidDestinationWellAcousticLiquidHandling,
				Error::InvalidInput
			}
		],
		Example[{Messages,"OverFilledDestinationVolume","Destination Wells cannot be over-filled:"},
			ExperimentAcousticLiquidHandling[
				{
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 4"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 5"<>$SessionUUID]
				},
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Low Dead Volume Plate"<>$SessionUUID]},
				4 Microliter
			],
			$Failed,
			Messages:>{
				Error::OverFilledDestinationVolume,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidInWellSeparationOption","The InWellSeparation Option cannot be set to True when physical separation of droplets in the destination well is not possible to achieve:"},
			ExperimentAcousticLiquidHandling[
				{
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 4"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 5"<>$SessionUUID]
				},
				{"A1", Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]},
				200 Nanoliter,
				InWellSeparation->True
			],
			$Failed,
			Messages:>{
				Error::InvalidInWellSeparationOption,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GlycerolConcentrationTooHigh","If the samples contain glycerol, the concentration cannot exceed 50 VolumePercent:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test 100% Glycerol Sample"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter
			],
			$Failed,
			Messages:>{
				Error::GlycerolConcentrationTooHigh,
				Error::InvalidInput
			}
		],
		Example[{Messages,"CalibrationAndMeasurementTypeMismatch","The options FluidTypeCalibration and FluidAnalysisMeasurement cannot conflict each other:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test 10% Triton-X"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter,
				FluidTypeCalibration->AqueousWithSurfactant,
				FluidAnalysisMeasurement->DMSO
			],
			$Failed,
			Messages:>{
				Error::CalibrationAndMeasurementTypeMismatch,
				Warning::FluidAnalysisMeasurementMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidFluidTypeCalibration","FluidTypeCalibration cannot be set to Glycerol when a low-dead-volume plate is used:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Low Dead Volume Sample"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				5 Nanoliter,
				FluidTypeCalibration->Glycerol
			],
			$Failed,
			Messages:>{
				Error::InvalidFluidTypeCalibration,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidFluidAnalysisMeasurement","FluidAnalysisMeasurement cannot be set to Glycerol when a low-dead-volume plate is used:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Low Dead Volume Sample"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				5 Nanoliter,
				FluidAnalysisMeasurement->Glycerol
			],
			$Failed,
			Messages:>{
				Error::InvalidFluidAnalysisMeasurement,
				Error::InvalidOption
			}
		],
		Example[{Messages,"FluidTypeCalibrationMismatch","It is recommended that FluidTypeCalibration be set to a value not intended for the composition of samples:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test 10% Triton-X"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter,
				FluidTypeCalibration->DMSO,
				Aliquot->False
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]],
			Messages:>{Warning::FluidTypeCalibrationMismatch}
		],
		Example[{Messages,"FluidAnalysisMeasurementMismatch","It is recommended that FluidAnalysisMeasurement be set to a value not intended for the composition of samples:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test 10% Triton-X"<>$SessionUUID],
				{"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]},
				100 Nanoliter,
				FluidAnalysisMeasurement->DMSO,
				Aliquot->False
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]],
			Messages:>{Warning::FluidAnalysisMeasurementMismatch}
		],

		(* ---Options specific to ExperimentAcousticLiquidHandling---*)

		Example[{Options,Instrument,"Specify the instrument to perform acoustic liquid handling:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID], {"A1", Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID]}, 100 Nanoliter,
				Instrument->Model[Instrument,LiquidHandler,AcousticLiquidHandler,"id:o1k9jAGrz9MG"],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectP[Model[Instrument,LiquidHandler,AcousticLiquidHandler,"id:o1k9jAGrz9MG"]],
			Variables:>{options}
		],
		Example[{Options,OptimizePrimitives,"Specify how the manipulations should be rearranged to improve transfer throughput:"},
			options=ExperimentAcousticLiquidHandling[
				{
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID]
				},
				{
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {3,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}
				},
				{
					100 Nanoliter, 25 Nanoliter, 50 Nanoliter, 100 Nanoliter, 50 Nanoliter, 100 Nanoliter
				},
				OptimizePrimitives->SourcePlateCentric,
				Output->Options
			];
			Lookup[options,OptimizePrimitives],
			SourcePlateCentric,
			Variables:>{options}
		],
		Example[{Options,FluidAnalysisMeasurement,"Specify the measurement type used to determine the fluid properties of the source samples:"},
			options=ExperimentAcousticLiquidHandling[
				{
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID]
				},
				{
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {3,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}
				},
				{
					100 Nanoliter,25 Nanoliter,50 Nanoliter,100 Nanoliter,50 Nanoliter,100 Nanoliter
				},
				FluidAnalysisMeasurement->AcousticImpedance,
				Output->Options
			];
			Lookup[options,FluidAnalysisMeasurement],
			AcousticImpedance,
			Variables:>{options}
		],
		Test["Measurement type automatically resolves based on source samples' compositions and expanded with respect to each transfer pair:",
			options=ExperimentAcousticLiquidHandling[
				{
					Object[Sample,"AcousticLiquidHandling Test 80% DMSO Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID]
				},
				{
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {3,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}
				},
				{
					100 Nanoliter,25 Nanoliter,50 Nanoliter,100 Nanoliter,50 Nanoliter,100 Nanoliter
				},
				FluidAnalysisMeasurement->Automatic,
				Output->Options
			];
			Lookup[options,FluidAnalysisMeasurement],
			{DMSO,Glycerol,Glycerol,Glycerol,AcousticImpedance,AcousticImpedance},
			Variables:>{options}
		],
		Example[{Options,FluidTypeCalibration,"Specify the calibration used by the acoustic liquid handler to transfer liquid of different types:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				FluidTypeCalibration->DMSO,
				Output->Options
			];
			Lookup[options,FluidTypeCalibration],
			DMSO,
			Variables:>{options}
		],
		Test["Calibration type automatically resolves based on source samples' compositions and expanded with respect to each transfer pair:",
			options=ExperimentAcousticLiquidHandling[
				{
					Object[Sample,"AcousticLiquidHandling Test 80% DMSO Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID]
				},
				{
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {3,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
					{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}
				},
				{
					100 Nanoliter,25 Nanoliter,50 Nanoliter,100 Nanoliter,50 Nanoliter,100 Nanoliter
				},
				FluidTypeCalibration->Automatic,
				Output->Options
			];
			Lookup[options,FluidTypeCalibration],
			{DMSO,Glycerol,Glycerol,Glycerol,AqueousWithoutSurfactant,AqueousWithoutSurfactant},
			Variables:>{options}
		],
		Example[{Options,InWellSeparation,"Specify whether the droplets transfer to the same destination well are physically separated:"},
			options=ExperimentAcousticLiquidHandling[
				{
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID]
				},
				{"A1", {2,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				{50 Nanoliter,100 Nanoliter},
				InWellSeparation->True,
				Output->Options
			];
			Lookup[options,InWellSeparation],
			True,
			Variables:>{options}
		],

		(* ---sample prep options--- *)

		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options
			];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Variables:>{options}
		],

		(* ---incubate tests--- *)
		Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Incubate->True,
				Output->Options
			];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				IncubationTemperature->40*Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				IncubationTime->40*Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				MaxIncubationTime->40*Minute,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample in 2mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				AnnealingTime->40*Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID],
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				IncubateAliquot->30 Microliter,
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			30 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				IncubateAliquotContainer->Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"],
				Output->Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"]]},
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Mix->True,
				Output->Options
			];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Large Water Sample"<>$SessionUUID],
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				MixType->Shake,
				Output->Options
			];
			Lookup[options,MixType],
			Shake,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				MixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		Example[
			{Options,IncubateAliquotDestinationWell,"Specify the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID],
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				IncubateAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		(* ---centrifuge tests--- *)

		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Centrifuge->True,
				Output->Options
			];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample in 2mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],
				Output->Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				CentrifugeIntensity->1000*RPM,
				Output->Options
			];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				CentrifugeTime->5*Minute,
				Output->Options
			];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				CentrifugeTemperature->10*Celsius,
				Output->Options
			];
			Lookup[options,CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID],
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				CentrifugeAliquot->30 Microliter,
				Output->Options
			];
			Lookup[options,CentrifugeAliquot],
			30 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID],
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],
				Output->Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Specify The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID],
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				CentrifugeAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],

		(* ---filter tests--- *)

		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID],
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				Filtration->True,
				Output->Options
			];
			Lookup[options,Filtration],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FiltrationType->Syringe,
				Output->Options
			];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],
				Output->Options
			];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],
				Output->Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,PrefilterMaterial,"Set the PrefilterMaterial option:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterMaterial->PTFE,
				PrefilterMaterial->GxF,
				AliquotAmount->60 Microliter,
				Output->Options
			];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterMaterial->PES,
				Output->Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,PrefilterPoreSize,"Set the PrefilterPoreSize option:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterMaterial->PTFE,
				PrefilterPoreSize->1. Micrometer,
				AliquotAmount->60 Microliter,
				Output->Options
			];
			Lookup[options,PrefilterPoreSize],
			1. Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterPoreSize->0.22 Micrometer,
				Output->Options
			];
			Lookup[options,FilterPoreSize],
			0.22 Micrometer,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FiltrationType->Syringe,
				FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output->Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Large Water Sample"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				FiltrationType->PeristalticPump,
				FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"],
				Output->Options
			];
			Lookup[options,FilterHousing],
			ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FiltrationType->Centrifuge,
				FilterIntensity->1000 RPM,
				Output->Options
			];
			Lookup[options,FilterIntensity],
			1000 RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FiltrationType->Centrifuge,
				FilterTime->20 Minute,
				Output->Options
			];
			Lookup[options,FilterTime],
			20 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FiltrationType->Centrifuge,
				FilterTemperature->10 Celsius,
				Output->Options
			];
			Lookup[options,FilterTemperature],
			10 Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterSterile->False,
				FilterInstrument->Model[Instrument,Centrifuge,"id:9RdZXv1XwWex"],(*"Avanti J-15R with JA-10.100 Fixed Angle Rotor"*)
				Output->Options
			];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterAliquot->1 Milliliter,
				Output->Options
			];
			Lookup[options,FilterAliquot],
			1 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],
				Output->Options
			];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterContainerOut->Model[Container,Vessel,"15mL Tube"],
				Output->Options
			];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"15mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquotDestinationWell,"Specify The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				FilterAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],

		(* aliquot tests *)

		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				AliquotAmount->30 Microliter,
				Output->Options
			];
			Lookup[options,{Aliquot,AliquotAmount}],
			{True,30 Microliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				AliquotAmount->0.03 Milliliter,
				Output->Options
			];
			Lookup[options,AliquotAmount],
			0.03 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				AssayVolume->30 Microliter,
				Output->Options
			];
			Lookup[options,AssayVolume],
			30 Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				TargetConcentration->0.125 Gram/Liter,
				Output->Options
			];
			Lookup[options,TargetConcentration],
			0.125 Gram/Liter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				TargetConcentration->0.125 Gram/Liter,
				TargetConcentrationAnalyte->Model[Molecule,Protein,"Bovine Serum Albumin"],
				Output->Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Protein,"Bovine Serum Albumin"]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->15 Microliter,
				AssayVolume->30 Microliter,
				Output->Options
			];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				BufferDilutionFactor->10,
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->15 Microliter,
				AssayVolume->30 Microliter,
				Output->Options
			];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				BufferDiluent->Model[Sample,"Milli-Q water"],
				BufferDilutionFactor->10,
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->15 Microliter,
				AssayVolume->30 Microliter,
				Output->Options
			];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->15 Microliter,
				AssayVolume->30 Microliter,
				Output->Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				AliquotSampleStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				ConsolidateAliquots->True,
				Output->Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Aliquot->True,
				AliquotPreparation->Manual,
				Output->Options
			];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				AliquotContainer->Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"],
				Output->Options
			];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "384-well Polypropylene Echo Qualified Plate"]]}},
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Specify The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				DestinationWell->"A1",
				Output->Options
			];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],

		(* ---post-processing options--- *)

		Example[{Options,ImageSample,"Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				ImageSample->True,
				Output->Options
			];
			Lookup[options,ImageSample],
			True,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				MeasureVolume->True,
				Output->Options
			];
			Lookup[options,MeasureVolume],
			True,
			Variables:>{options}
		],

		(* ---Misc shared option tests--- *)

		Example[{Options,Name,"Specify a name for AcousticLiquidHandling protocol:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Name->"AcousticLiquidHandling Unit Test Protocol",
				Output->Options
			];
			Lookup[options,Name],
			"AcousticLiquidHandling Unit Test Protocol",
			Variables:>{options}
		],
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter ,
				Template->Object[Protocol,AcousticLiquidHandling,"AcousticLiquidHandling Test Template Protocol"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Template],
			ObjectP[Object[Protocol,AcousticLiquidHandling,"AcousticLiquidHandling Test Template Protocol"<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,Upload,"Specify if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Upload->False
			],
			{PacketP[]..}
		],
		Example[{Options,Output,"Indicate what the function should return:"},
			ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Output->Result
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]]
		],
		Example[{Options,PreparatoryUnitOperations,"Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSamplePreparation:"},
			ExperimentAcousticLiquidHandling[
				{"My Sample 1","My Sample 2"},
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"My Plate",
						Container->Model[Container,Plate,"384-well Polypropylene Echo Qualified Plate"]
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Amount->60 Microliter,
						Destination->{{"A1","My Plate"},{"A2","My Plate"}},
						DestinationLabel->{"My Sample 1", "My Sample 2"}
					]
				}
			],
			ObjectP[Object[Protocol,AcousticLiquidHandling]]
		],
		Example[{Options,SamplesInStorageCondition,"Specify The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample, "AcousticLiquidHandling Test 80% DMSO Sample" <> $SessionUUID], {"A1", {1, Model[Container, Plate, "96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				SamplesInStorageCondition->Disposal,
				Output->Options
			];
			Lookup[options,SamplesInStorageCondition],
			Disposal,
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition,"Specify The non-default conditions under which the SampleOut of this experiment should be stored after the protocol is completed. If left unset, SamplesOut will be stored according to their current StorageCondition:"},
			options=ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				{"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}},
				100 Nanoliter,
				SamplesOutStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Water Sample 3"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Water Sample 4"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Water Sample 5"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Destination Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Solid Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Discarded Source Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Deprecated Source Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Containerless Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Sample With Unsafe Volume"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test 100% Glycerol Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test 10% Triton-X"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test 80% DMSO Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Low Dead Volume Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Large Water Sample"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Water Sample in 2mL Tube"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Low Volume Sample in 50mL Tube"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 1"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 2"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Occupied Destination Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Solid Sample Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Invalid Source Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Source Plate With Multiple Samples"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Plate With Discarded Sample"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Plate With Deprecated Sample"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Discarded Destination Container"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Invalid Destination Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Destination Plate With Unsafe Volume"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Low Dead Volume Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Glycerol Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Triton-X Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test DMSO Plate"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Low Concentration Glycerol Plate"<>$SessionUUID],
				Object[Container,Vessel,"AcousticLiquidHandling Test 50mL Tube"<>$SessionUUID],
				Object[Container,Vessel,"AcousticLiquidHandling Test 2mL Tube"<>$SessionUUID],
				Object[Container,Vessel,"AcousticLiquidHandling Test Protein Tube"<>$SessionUUID],
				Object[Container,Vessel,"AcousticLiquidHandling Test Low Volume 50mL Tube"<>$SessionUUID],
				Model[Sample,"AcousticLiquidHandling Test Deprecated Sample Model"<>$SessionUUID],
				Model[Sample,"AcousticLiquidHandling Test 30% Glycerol Model"<>$SessionUUID],
				Model[Sample,"AcousticLiquidHandling Test 80% DMSO Model"<>$SessionUUID],
				Model[Sample,"AcousticLiquidHandling Test 0.5mg/mL BSA Model"<>$SessionUUID],
				Object[Protocol,AcousticLiquidHandling,"AcousticLiquidHandling Test Template Protocol"<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Module[
			(* add variable for object we are creating here *)
			{
				(* sample variables *)
				sourceWaterSample1,sourceWaterSample2,destWaterSample1,solidSample,invalidSample,multiSample1,multiSample2,
				discardedSource,deprecatedModel,deprecatedSample,containerlessSample,unsafeVolumeSample,highGlycerolSample,
				tritonXSample,ldvSample,dmsoSample,lowGlycerolSample,largeWaterSample,tubeSample,proteinSample,lowVolSample,

				(* container variables *)
				sourcePlate1,sourcePlate2,emptyDestPlate,filledDestPlate,solidSamplePlate,invalidSourcePlate,multiSamplePlate,
				plateWithDiscardedSample,plateWithDeprecatedSample,discardedDestPlate,invalidDestPlate,unsafeVolumePlate,
				ldvPlate,glycerolPlate,tritonXPlate,dmsoPlate,lowGlycerolPlate,falconTube,smallTube,proteinTube,lowVolTube,

				(* template protocol *)
				fakeProtocol
			},

			(* create models here *)
			deprecatedModel=UploadSampleModel[
				"AcousticLiquidHandling Test Deprecated Sample Model"<>$SessionUUID,
				Composition->{
					{100 VolumePercent,Model[Molecule,"Water"]}
				},
				IncompatibleMaterials->{None},
				Expires->False,
				DefaultStorageCondition->Model[StorageCondition,"id:N80DNj1r04jW"],
				MSDSFile -> NotApplicable,
				BiosafetyLevel->"BSL-1",
				State->Liquid
			];

			(* make a 30% Glycerol model for our input samples *)
			UploadSampleModel[
				"AcousticLiquidHandling Test 30% Glycerol Model"<>$SessionUUID,
				Composition->{
					{70 VolumePercent,Model[Molecule,"Water"]},
					{30 VolumePercent,Model[Molecule,"Glycerol"]}
				},
				IncompatibleMaterials->{None},
				Expires->False,
				DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
				MSDSFile -> NotApplicable,
				BiosafetyLevel->"BSL-1",
				State->Liquid
			];

			(* make a 80% DMSO model for our input samples *)
			UploadSampleModel[
				"AcousticLiquidHandling Test 80% DMSO Model"<>$SessionUUID,
				Composition->{
					{20 VolumePercent,Model[Molecule,"Water"]},
					{80 VolumePercent,Model[Molecule,"Dimethyl sulfoxide"]}
				},
				IncompatibleMaterials->{None},
				Expires->False,
				DefaultStorageCondition->Model[StorageCondition, "id:vXl9j57YrPlN"], (* Model[StorageCondition, "Ambient Storage, Flammable"] *)
				MSDSFile -> NotApplicable,
				BiosafetyLevel->"BSL-1",
				State->Liquid
			];

			(* make 0.5mg/mL BSA model for our input samples *)
			UploadSampleModel[
				"AcousticLiquidHandling Test 0.5mg/mL BSA Model"<>$SessionUUID,
				Composition->{
					{100 VolumePercent,Model[Molecule,"Water"]},
					{0.5 Gram/Liter,Model[Molecule,Protein,"Bovine Serum Albumin"]}
				},
				IncompatibleMaterials->{None},
				Expires->False,
				DefaultStorageCondition->Model[StorageCondition,"Refrigerator"],
				MSDSFile -> NotApplicable,
				BiosafetyLevel->"BSL-1",
				State->Liquid
			];

			(* Create some containers *)
			{
				(*1*)sourcePlate1,
				(*2*)sourcePlate2,
				(*3*)emptyDestPlate,
				(*4*)filledDestPlate,
				(*5*)solidSamplePlate,
				(*6*)invalidSourcePlate,
				(*7*)multiSamplePlate,
				(*8*)plateWithDiscardedSample,
				(*9*)plateWithDeprecatedSample,
				(*10*)deprecatedModel,
				(*11*)discardedDestPlate,
				(*12*)invalidDestPlate,
				(*13*)unsafeVolumePlate,
				(*14*)ldvPlate,
				(*15*)glycerolPlate,
				(*16*)tritonXPlate,
				(*17*)dmsoPlate,
				(*18*)lowGlycerolPlate,
				(*19*)falconTube,
				(*20*)smallTube,
				(*21*)proteinTube,
				(*22*)lowVolTube
			}=Upload[{
				(*1*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Source Plate 1"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*2*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Source Plate 2"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*3*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:AEqRl9KmGPWa"],Objects],Name->"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*4*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Occupied Destination Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*5*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Solid Sample Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*6*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:AEqRl9KmGPWa"],Objects],Name->"AcousticLiquidHandling Test Invalid Source Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*7*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Source Plate With Multiple Samples"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*8*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Plate With Discarded Sample"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*9*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Plate With Deprecated Sample"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*10*)<|Object->deprecatedModel,Deprecated->True,DeveloperObject->True|>,
				(*11*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:AEqRl9KmGPWa"],Objects],Name->"AcousticLiquidHandling Test Discarded Destination Container"<>$SessionUUID,Status->Discarded,DeveloperObject->True,Site->Link[$Site]|>,
				(*12*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,Irregular,Raman,"id:zGj91a7ORj7O"],Objects],Name->"AcousticLiquidHandling Test Invalid Destination Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*13*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Destination Plate With Unsafe Volume"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*14*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:01G6nvwNDARA"],Objects],Name->"AcousticLiquidHandling Test Low Dead Volume Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*15*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Glycerol Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*16*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Triton-X Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*17*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test DMSO Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*18*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Low Concentration Glycerol Plate"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*19*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"AcousticLiquidHandling Test 50mL Tube"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*20*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:3em6Zv9NjjN8"],Objects],Name->"AcousticLiquidHandling Test 2mL Tube"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*21*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"AcousticLiquidHandling Test Protein Tube"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>,
				(*22*)<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:bq9LA0dBGGR6"],Objects],Name->"AcousticLiquidHandling Test Low Volume 50mL Tube"<>$SessionUUID,DeveloperObject->True,Site->Link[$Site]|>
			}];

			(* Create some samples *)
			{
				(*1*)sourceWaterSample1,
				(*2*)sourceWaterSample2,
				(*3*)destWaterSample1,
				(*4*)solidSample,
				(*5*)invalidSample,
				(*6*)multiSample1,
				(*7*)multiSample2,
				(*8*)discardedSource,
				(*9*)deprecatedSample,
				(*10*)containerlessSample,
				(*11*)unsafeVolumeSample,
				(*12*)highGlycerolSample,
				(*13*)tritonXSample,
				(*14*)ldvSample,
				(*15*)dmsoSample,
				(*16*)lowGlycerolSample,
				(*17*)largeWaterSample,
				(*18*)tubeSample,
				(*19*)proteinSample,
				(*20*)lowVolSample
			}=ECL`InternalUpload`UploadSample[
				{
					(*1*)Model[Sample,"Milli-Q water"],
					(*2*)Model[Sample,"Milli-Q water"],
					(*3*)Model[Sample,"Milli-Q water"],
					(*4*)Model[Sample,"Dibasic Sodium Phosphate"],
					(*5*)Model[Sample,"Milli-Q water"],
					(*6*)Model[Sample,"Milli-Q water"],
					(*7*)Model[Sample,"Milli-Q water"],
					(*8*)Model[Sample,"Milli-Q water"],
					(*9*)deprecatedModel,
					(*10*)Model[Sample,"Milli-Q water"],
					(*11*)Model[Sample,"Milli-Q water"],
					(*12*)Model[Sample,"Glycerol"],
					(*13*)Model[Sample,StockSolution,"10% Triton-X in Water"],
					(*14*)Model[Sample,"AcousticLiquidHandling Test 30% Glycerol Model"<>$SessionUUID],
					(*15*)Model[Sample,"AcousticLiquidHandling Test 80% DMSO Model"<>$SessionUUID],
					(*16*)Model[Sample,"AcousticLiquidHandling Test 30% Glycerol Model"<>$SessionUUID],
					(*17*)Model[Sample,"Milli-Q water"],
					(*18*)Model[Sample,"Milli-Q water"],
					(*19*)Model[Sample,"AcousticLiquidHandling Test 0.5mg/mL BSA Model"<>$SessionUUID],
					(*20*)Model[Sample,"Milli-Q water"]
				},
				{
					(*1*){"A1",sourcePlate1},
					(*2*){"A1",sourcePlate2},
					(*3*){"A1",filledDestPlate},
					(*4*){"A1",solidSamplePlate},
					(*5*){"A1",invalidSourcePlate},
					(*6*){"A1",multiSamplePlate},
					(*7*){"A2",multiSamplePlate},
					(*8*){"A1",plateWithDiscardedSample},
					(*9*){"A1",plateWithDeprecatedSample},
					(*10*){"A2",invalidSourcePlate},
					(*11*){"A1",unsafeVolumePlate},
					(*12*){"A1",glycerolPlate},
					(*13*){"A1",tritonXPlate},
					(*14*){"C1",ldvPlate},
					(*15*){"A1",dmsoPlate},
					(*16*){"A2",lowGlycerolPlate},
					(*17*){"A1",falconTube},
					(*18*){"A1",smallTube},
					(*19*){"A1",proteinTube},
					(*20*){"A1",lowVolTube}
				},
				InitialAmount->{
					(*1*)30 Microliter,
					(*2*)30 Microliter,
					(*3*)30 Microliter,
					(*4*)100 Milligram,
					(*5*)30 Microliter,
					(*6*)30 Microliter,
					(*7*)30 Microliter,
					(*8*)30 Microliter,
					(*9*)30 Microliter,
					(*10*)30 Microliter,
					(*11*)60 Microliter,
					(*12*)30 Microliter,
					(*13*)30 Microliter,
					(*14*)5 Microliter,
					(*15*)30 Microliter,
					(*16*)30 Microliter,
					(*17*)30 Milliliter,
					(*18*)1 Milliliter,
					(*19*)5 Milliliter,
					(*20*)10 Microliter
				},
				StorageCondition->Refrigerator
			];

			(* Secondary uploads *)
			Upload[{
				(*1*)<|Object->sourceWaterSample1,Name->"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*2*)<|Object->sourceWaterSample2,Name->"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*3*)<|Object->destWaterSample1,Name->"AcousticLiquidHandling Test Destination Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*4*)<|Object->solidSample,Name->"AcousticLiquidHandling Test Solid Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*5*)<|Object->invalidSample,Name->"AcousticLiquidHandling Test Water Sample 3"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*6*)<|Object->multiSample1,Name->"AcousticLiquidHandling Test Water Sample 4"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*7*)<|Object->multiSample2,Name->"AcousticLiquidHandling Test Water Sample 5"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*8*)<|Object->discardedSource,Name->"AcousticLiquidHandling Discarded Source Sample"<>$SessionUUID,Status->Discarded,DeveloperObject->True|>,
				(*9*)<|Object->deprecatedSample,Name->"AcousticLiquidHandling Deprecated Source Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*10*)<|Object->containerlessSample,Name->"AcousticLiquidHandling Test Containerless Sample"<>$SessionUUID,Status->Available,Container->Null,DeveloperObject->True|>,
				(*11*)<|Object->unsafeVolumeSample,Name->"AcousticLiquidHandling Test Sample With Unsafe Volume"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*12*)<|Object->highGlycerolSample,Name->"AcousticLiquidHandling Test 100% Glycerol Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*13*)<|Object->tritonXSample,Name->"AcousticLiquidHandling Test 10% Triton-X"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*14*)<|Object->ldvSample,Name->"AcousticLiquidHandling Test Low Dead Volume Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*15*)<|Object->dmsoSample,Name->"AcousticLiquidHandling Test 80% DMSO Sample"<>$SessionUUID,Status->Available,Concentration->2 Millimolar,DeveloperObject->True|>,
				(*16*)<|Object->lowGlycerolSample,Name->"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*17*)<|Object->largeWaterSample,Name->"AcousticLiquidHandling Test Large Water Sample"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*18*)<|Object->tubeSample,Name->"AcousticLiquidHandling Test Water Sample in 2mL Tube"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*19*)<|Object->proteinSample,Name->"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID,Status->Available,DeveloperObject->True|>,
				(*20*)<|Object->lowVolSample,Name->"AcousticLiquidHandling Test Low Volume Sample in 50mL Tube"<>$SessionUUID,Status->Available,DeveloperObject->True|>
			}];

			(* create a fake protocol to test Template option *)
			fakeProtocol=Quiet[ExperimentAcousticLiquidHandling[
				Object[Sample,"AcousticLiquidHandling Test Large Water Sample"<>$SessionUUID], {"A1", {1,Model[Container,Plate,"96-well Polypropylene Flat-Bottom Plate, Black"]}}, 100 Nanoliter,
				Name->"AcousticLiquidHandling Test Template Protocol"<>$SessionUUID
			]];

			(* Make all of the objects created during the protocol developer objects *)
			Upload[<|Object->#,DeveloperObject->True|> &/@Cases[Flatten[$CreatedObjects],ObjectP[]]];

		];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects},
			namedObjects=Quiet[Cases[
				Flatten[{
					(* also get rid of any other created objects *)
					$CreatedObjects,

					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 3"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 4"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 5"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Destination Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Solid Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Discarded Source Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Deprecated Source Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Containerless Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Sample With Unsafe Volume"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 100% Glycerol Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 10% Triton-X"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 30% Glycerol Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test 80% DMSO Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Low Dead Volume Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Large Water Sample"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample in 2mL Tube"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Protein Sample in 50mL Tube"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Low Volume Sample in 50mL Tube"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 1"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 2"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Empty Destination Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Occupied Destination Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Solid Sample Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Invalid Source Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Source Plate With Multiple Samples"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Plate With Discarded Sample"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Plate With Deprecated Sample"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Discarded Destination Container"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Invalid Destination Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Destination Plate With Unsafe Volume"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Low Dead Volume Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Glycerol Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Triton-X Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test DMSO Plate"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Low Concentration Glycerol Plate"<>$SessionUUID],
					Object[Container,Vessel,"AcousticLiquidHandling Test 50mL Tube"<>$SessionUUID],
					Object[Container,Vessel,"AcousticLiquidHandling Test 2mL Tube"<>$SessionUUID],
					Object[Container,Vessel,"AcousticLiquidHandling Test Protein Tube"<>$SessionUUID],
					Object[Container,Vessel,"AcousticLiquidHandling Test Low Volume 50mL Tube"<>$SessionUUID],
					Model[Sample,"AcousticLiquidHandling Test Deprecated Sample Model"<>$SessionUUID],
					Model[Sample,"AcousticLiquidHandling Test 30% Glycerol Model"<>$SessionUUID],
					Model[Sample,"AcousticLiquidHandling Test 80% DMSO Model"<>$SessionUUID],
					Model[Sample,"AcousticLiquidHandling Test 0.5mg/mL BSA Model"<>$SessionUUID],
					Object[Protocol,AcousticLiquidHandling,"AcousticLiquidHandling Test Template Protocol"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			];

			(* clear $CreatedObjects *)
			Unset[$CreatedObjects]
		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];