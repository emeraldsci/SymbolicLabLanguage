(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentImageCells: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentImageCells*)

DefineTests[
	ExperimentImageCells,
	{
		(* ---basic tests--- *)
		Example[{Basic,"Acquire image from a sample object:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID]
			],
			ObjectP[Object[Protocol,ImageCells]]
		],
		Example[{Basic,"Acquire images from multiple sample objects:"},
			ExperimentImageCells[
				{
					Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
					Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
					Object[Sample,"Fake cell sample 3 for ExperimentImageCells tests"<> $SessionUUID]
				}
			],
			ObjectP[Object[Protocol,ImageCells]]
		],
		Example[{Basic,"Acquire images from multiple sample pools:"},
			ExperimentImageCells[
				{
					{
						Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 3 for ExperimentImageCells tests"<> $SessionUUID]
					},
					{
						Object[Sample,"Hemocytometer sample 1 for ExperimentImageCells tests"<> $SessionUUID]
					}
				}
			],
			ObjectP[Object[Protocol,ImageCells]]
		],
		Test["Acquire images from samples in a plate:",
			ExperimentImageCells[
				{Object[Container,Plate,"Fake plate 1 for ExperimentImageCells tests"<> $SessionUUID]}
			],
			ObjectP[Object[Protocol,ImageCells]]
		],
		Test["Accepts a combination of samples and containers as inputs:",
			ExperimentImageCells[
				{
					{Object[Container,Plate,"Fake plate 2 for ExperimentImageCells tests"<> $SessionUUID]},
					{
						Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 3 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID]
					}
				}
			],
			ObjectP[Object[Protocol,ImageCells]]
		],

		(* manual primitive support *)
		Example[{Basic,"Output an updated simulation packet when Output is set to Simulation:"},
			output=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SampleLabel->"ImageCells primitive test sample",
				Output->Simulation
			];
			Lookup[Association@@output,Labels],
			(* Second label is for SampleContainerLabel *)
			{"ImageCells primitive test sample"->ObjectP[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID]],___},
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			Variables:>{output},
			TimeConstraint->300
		],
		Example[{Basic,"Output a Script notebook with a set of primitives:"},
			Experiment[{
				ImageCells[
					Sample->Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
					SampleLabel->"Test Sample",
					SampleContainerLabel -> "Test Container"
				],
				Cover[Sample -> "Test Container"],
				IncubateCells[
					Sample->"Test Container",
					Time->5 Minute
				]
			}],
			ObjectP[{Object[Protocol,ManualCellPreparation], Object[Notebook, Script]}],
			Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
			TimeConstraint->300
		],

		(* messages *)
		Example[{Messages,"ImageCellsInstrumentModelNotFound","If Instrument is not given, instrument model that can support specified options must be available:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				MicroscopeOrientation->Upright
			],
			$Failed,
			Messages:>{Error::ImageCellsInstrumentModelNotFound}
		],
		Example[{Messages,"DiscardedSamples","If the given samples are discarded, they cannot be imaged:"},
			ExperimentImageCells[Object[Sample,"Discarded sample for ExperimentImageCells tests"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ImageCellsContainerlessSamples","Samples without container cannot be imaged:"},
			ExperimentImageCells[Object[Sample,"Containerless sample for ExperimentImageCells tests"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::ImageCellsContainerlessSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"MicroscopeOrientationMismatch","The Orientation of the specified Instrument and MicroscopeOrientation option value must be copacetic:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
				MicroscopeOrientation->Upright
			],
			$Failed,
			Messages:>{
				Error::MicroscopeOrientationMismatch,
				Error::InvalidOption
			},
			SetUp:>(
				Download[Model[Maintenance,CalibrateMicroscope,"Fake Model Maintenance Microscope Calibration for ExperimentImageCells tests"<> $SessionUUID]];
			)
		],
		Example[{Messages,"InvalidMicroscopeStatus","Specified Instrument object must not be retired:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Object[Instrument,Microscope,"Fake Inverted Microscope Object for ExperimentImageCells tests"<> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::InvalidMicroscopeStatus,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Object[Instrument,Microscope,"Fake Inverted Microscope Object for ExperimentImageCells tests"<> $SessionUUID],Status->Retired|>];
			),
			TearDown:>(
				Upload[<|Object->Object[Instrument,Microscope,"Fake Inverted Microscope Object for ExperimentImageCells tests"<> $SessionUUID],Status->Available|>];
			)
		],
		Test["Specified Instrument model must not be deprecated:",
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::InvalidMicroscopeStatus,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],Deprecated->True|>];
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],Deprecated->Null|>];
			)
		],
		Example[{Messages,"MicroscopeCalibrationNotAllowed","If ReCalibrateMicroscope is True, the selected Instrument must allow performing calibration by running a maintenance:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				ReCalibrateMicroscope->True
			],
			$Failed,
			Messages:>{
				Error::MicroscopeCalibrationNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MicroscopeCalibrationMismatch","If ReCalibrateMicroscope is False, MicroscopeCalibration must be Null:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Object[Instrument,Microscope,"Fake Inverted Microscope Object for ExperimentImageCells tests"<> $SessionUUID],
				ReCalibrateMicroscope->False,
				MicroscopeCalibration->Object[Maintenance,CalibrateMicroscope,"Fake Object Maintenance Microscope Calibration for ExperimentImageCells tests"<> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::MicroscopeCalibrationMismatch,
				Error::InvalidOption
			}
		],
		Test["If ReCalibrateMicroscope is True, MicroscopeCalibration cannot be Null:",
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ReCalibrateMicroscope->True,
				MicroscopeCalibration->Null
			],
			$Failed,
			Messages:>{
				Error::MicroscopeCalibrationMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MicroscopeCalibrationNotFound","If ReCalibrateMicroscope is True and Instrument allows calibration, MicroscopeCalibration option must be specified with or successfully resolved to Object[Maintenance,CalibrationMicroscope]:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
				ReCalibrateMicroscope->True
			],
			$Failed,
			Messages:>{
				Error::MicroscopeCalibrationNotFound,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|
					Object->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
					Replace[MaintenanceFrequency]->{}
				|>];
			),
			TearDown:>(
				Upload[<|
					Object->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
					Replace[MaintenanceFrequency]->{Link[Model[Maintenance,CalibrateMicroscope,"Fake Model Maintenance Microscope Calibration for ExperimentImageCells tests"<> $SessionUUID],Targets],Null}
				|>];
			)
		],
		Example[{Messages,"InvalidMicroscopeCalibration","If ReCalibrateMicroscope is True and Instrument allows calibration, the Target of MicroscopeCalibration option must not conflict with the Instrument option:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
				ReCalibrateMicroscope->True,
				MicroscopeCalibration->Object[Maintenance,CalibrateMicroscope,"Fake Object Maintenance Microscope Calibration for ExperimentImageCells tests"<> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::InvalidMicroscopeCalibration,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|
					Object->Object[Maintenance,CalibrateMicroscope,"Fake Object Maintenance Microscope Calibration for ExperimentImageCells tests"<> $SessionUUID],
					Target->Link[Object[Instrument,Microscope,"Fake High Content Imager Object for ExperimentImageCells tests"<> $SessionUUID]]
				|>];
			),
			TearDown:>(
				Upload[<|
					Object->Object[Maintenance,CalibrateMicroscope,"Fake Object Maintenance Microscope Calibration for ExperimentImageCells tests"<> $SessionUUID],
					Target->Link[Object[Instrument,Microscope,"Fake Inverted Microscope Object for ExperimentImageCells tests"<> $SessionUUID]]
				|>];
			)
		],
		Example[{Messages,"InvalidMicroscopeTemperature","Temperature must be within range supported by the Instrument:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
				Temperature->30 Celsius
			],
			$Failed,
			Messages:>{
				Error::InvalidMicroscopeTemperature,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CO2IncompatibleMicroscope","If CarbonDioxide is True, the Instrument must support carbon dioxide incubation:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
				CarbonDioxide->True
			],
			$Failed,
			Messages:>{
				Error::CO2IncompatibleMicroscope,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CarbonDioxideOptionsMismatch","If CarbonDioxide is False, CarbonDioxidePercentage cannot be specified:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
				CarbonDioxide->False,
				CarbonDioxidePercentage->10 Percent
			],
			$Failed,
			Messages:>{
				Error::CarbonDioxideOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsMismatchedContainers","Samples in the same sample pool must be in containers with the same model:"},
			ExperimentImageCells[
				{
					{Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],Object[Sample,"Fake cell sample 5 for ExperimentImageCells tests"<> $SessionUUID]}
				}
			],
			$Failed,
			Messages:>{
				Error::ImageCellsMismatchedContainers,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ImageCellsIncompatibleContainer","Samples must be in valid containers that can fit into 'Sample Slot' of the instrument:"},
			ExperimentImageCells[
				Object[Sample,"Sample with incompatible container for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::ImageCellsIncompatibleContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ImageCellsInvalidWellBottom","Samples must be in containers with clear bottom:"},
			ExperimentImageCells[Object[Sample,"Sample with opaque container for ExperimentImageCells tests"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidWellBottom,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ImageCellsInvalidContainerOrientation","Samples in plates cannot be imaged upside-down:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ContainerOrientation->UpsideDown
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidContainerOrientation,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MismatchedCoverslipThickness","Throw a warning message when specified CoverslipThickness option does not match value stored in sample's container model:"},
			ExperimentImageCells[
				Object[Container,MicroscopeSlide,"Fake microscope slide for ExperimentImageCells tests"<> $SessionUUID],
				CoverslipThickness->0.2 Millimeter
			],
			ObjectP[Object[Protocol,ImageCells]],
			Messages:>{Warning::MismatchedCoverslipThickness}
		],
		Example[{Messages,"ImageCellsInvalidCoverslipThickness","Throw an error message if CoverslipThickness is not Null when samples are not on microscope slides:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				CoverslipThickness->0.2 Millimeter
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidCoverslipThickness,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsNegativePlateBottomThickness","Throw an error message when calculated plate bottom thickness is a negative value:"},
			ExperimentImageCells[Object[Sample,"Fake cell sample 5 for ExperimentImageCells tests"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::ImageCellsNegativePlateBottomThickness,
				Error::InvalidInput
			},
			SetUp:>(
				Upload[<|
					Object->Model[Container,Plate,"id:E8zoYveRlldX"],
					DepthMargin->3 Millimeter
				|>];
			),
			TearDown:>(
				Upload[<|
					Object->Model[Container,Plate,"id:E8zoYveRlldX"],
					DepthMargin->1.27 Millimeter
				|>];
			)
		],
		Example[{Messages,"MismatchedPlateBottomThickness","Throw a warning message when specified PlateBottomThickness option does not match value calculated from the sample's container model:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 5 for ExperimentImageCells tests"<> $SessionUUID],
				PlateBottomThickness->2 Millimeter
			],
			ObjectP[Object[Protocol,ImageCells]],
			Messages:>{Warning::MismatchedPlateBottomThickness}
		],
		Example[{Messages,"ImageCellsInvalidPlateBottomThickness","Throw an error message if PlateBottomThickness is not Null when samples are not in plates:"},
			ExperimentImageCells[
				Object[Sample,"Microscope slide sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				PlateBottomThickness->2 Millimeter
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidPlateBottomThickness,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidObjectiveMagnification","The specified objective magnification must be supported by the instrument:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				ObjectiveMagnification->100
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidObjectiveMagnification,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidPixelBinning","The specified PixelBinning must be supported by the instrument:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				PixelBinning->5
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidPixelBinning,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsTimelapseIntervalNotAllowed","The specified TimelapseInterval must be Null when Timelaspe is False:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->False,
				TimelapseInterval->5 Second
			],
			$Failed,
			Messages:>{
				Error::ImageCellsTimelapseIntervalNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsTimelapseDurationNotAllowed","The specified TimelapseDuration must be Null when Timelaspe is False:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->False,
				TimelapseDuration->5 Hour
			],
			$Failed,
			Messages:>{
				Error::ImageCellsTimelapseDurationNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsNumberOfTimepointsNotAllowed","The specified NumberOfTimepoints must be Null when Timelaspe is False:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->False,
				NumberOfTimepoints->5
			],
			$Failed,
			Messages:>{
				Error::ImageCellsNumberOfTimepointsNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsContinuousTimelapseImagingNotAllowed","The specified TimelapseDuration cannot be True when Timelaspe is False:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->False,
				ContinuousTimelapseImaging->True
			],
			$Failed,
			Messages:>{
				Error::ImageCellsContinuousTimelapseImagingNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsTimelapseAcquisitionOrderNotAllowed","The specified TimelapseAcquisitionOrder must be Null when Timelaspe is False:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->False,
				TimelapseAcquisitionOrder->ColumnByColumn
			],
			$Failed,
			Messages:>{
				Error::ImageCellsTimelapseAcquisitionOrderNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsUnsupportedTimelapseImaging","Timelapse option cannot be set to True when the selected instrument does not support timelapse imaging:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True
			],
			$Failed,
			Messages:>{
				Error::ImageCellsUnsupportedTimelapseImaging,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],TimelapseImaging->Null|>];
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],TimelapseImaging->True|>];
			)
		],
		Example[{Messages,"ImageCellsInvalidTimelapseDefinition","When Timelapse is set to True at least one of the following options must be left to be set automatically: TimelapseInterval, NumberOfTimepoints, TimelapseDuration:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				TimelapseInterval->10 Second,
				TimelapseDuration->1 Hour,
				NumberOfTimepoints->5
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidTimelapseDefinition,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidContinuousTimelapseImaging","When ContinuousTimelapseImaging is set to True, TimelapseInterval must be less than 1 Hour:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				ContinuousTimelapseImaging->True,
				TimelapseInterval->5 Hour
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidContinuousTimelapseImaging,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsUnsupportedZStackImaging","ZStack option cannot be set to True when the selected instrument does not support z-stack imaging:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True
			],
			$Failed,
			Messages:>{
				Error::ImageCellsUnsupportedZStackImaging,
				Error::InvalidOption
			},
			SetUp:>(
				Upload[<|Object->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],ZStackImaging->Null|>];
			),
			TearDown:>(
				Upload[<|Object->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],ZStackImaging->True|>];
			)
		],
		Example[{Messages,"ImageCellsInvalidZStackDefinition","When ZStack is set to True at least one of the following options must be left to be set automatically: ZStepSize, NumberOfZSteps, ZStackSpan:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True,
				ZStepSize->1 Micrometer,
				NumberOfZSteps->5,
				ZStackSpan->Span[-10 Micrometer,10 Micrometer]
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidZStackDefinition,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsZStepSizeNotAllowed","The specified ZStepSize must be Null when ZStack is False:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->False,
				ZStepSize->1 Micrometer
			],
			$Failed,
			Messages:>{
				Error::ImageCellsZStepSizeNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsNumberOfZStepsNotAllowed","The specified NumberOfZSteps must be Null when ZStack is False:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->False,
				NumberOfZSteps->5
			],
			$Failed,
			Messages:>{
				Error::ImageCellsNumberOfZStepsNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsZStackSpanNotAllowed","The specified ZStackSpan must be Null when ZStack is False:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->False,
				ZStackSpan->Span[-10 Micrometer,10 Micrometer]
			],
			$Failed,
			Messages:>{
				Error::ImageCellsZStackSpanNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidZStackSpan","The specified ZStackSpan must be within the instrument's max allowed distance on the z-axis:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True,
				ZStackSpan->Span[-9000 Micrometer,9000 Micrometer]
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidZStackSpan,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidZStepSizeNumberOfZSteps","The product of ZStepSize and NumberOfZSteps option values must be within the instrument's max allowed distance on the z-axis:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True,
				ZStepSize->150 Micrometer,
				NumberOfZSteps->100
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidZStepSizeNumberOfZSteps,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidZStepSize","The specified ZStepSize must be smaller than the distance on the z-axis defined by the ZStackSpan option:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True,
				ZStepSize->200 Micrometer,
				ZStackSpan->Span[-50 Micrometer,50 Micrometer]
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidZStepSize,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidAcquireImagePrimitive","Throw an error message if AcquireImage primitive specified as Images option is invalid:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->False,
				Images->{
					AcquireImage[ZStackImageCollection->True]
				}
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidAcquireImagePrimitive,
				Error::ZStackImageCollectionNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidAdjustmentSample","The AdjustmentSample option can only be set to sample object if that sample is included in the pool:"},
			ExperimentImageCells[
				{
					{
						Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 3 for ExperimentImageCells tests"<> $SessionUUID]
					}
				},
				AdjustmentSample->{Object[Sample,"Fake cell sample 5 for ExperimentImageCells tests"<> $SessionUUID]}
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidAdjustmentSample,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsMultipleContainersForAdjustmentSample","The AdjustmentSample option can only be set to sample if the given sample pool has a single sample container:"},
			ExperimentImageCells[
				{{
					Object[Container,Plate,"Fake plate 1 for ExperimentImageCells tests"<> $SessionUUID],
					Object[Container,Plate,"Fake plate 5 for ExperimentImageCells tests"<> $SessionUUID]
				}},
				AdjustmentSample->{Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID]}
			],
			$Failed,
			Messages:>{
				Error::ImageCellsMultipleContainersForAdjustmentSample,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsUnsupportedSamplingPattern","The specified SamplingPattern must be supported by the instrument:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Coordinates
			],
			$Failed,
			Messages:>{
				Error::ImageCellsUnsupportedSamplingPattern,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingCoordinatesNotAllowed","SamplingCoordinates must be Null when SamplingPattern is set to Grid or Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingCoordinates->{{1 Micrometer,2 Micrometer}}
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingCoordinatesNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingRowSpacingMismatch","SamplingRowSpacing must be Null when SamplingNumberOfRows is set to 1:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfRows->1,
				SamplingRowSpacing->100 Micrometer
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingRowSpacingMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingRowSpacingNotSpecified","SamplingRowSpacing cannot be Null when SamplingNumberOfRows is higher than 1:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfRows->5,
				SamplingRowSpacing->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingRowSpacingNotSpecified,
				Error::ImageCellsCannotDetermineImagingSites,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingColumnSpacingMismatch","SamplingColumnSpacing must be Null when SamplingNumberOfColumns is set to 1:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfColumns->1,
				SamplingColumnSpacing->100 Micrometer
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingColumnSpacingMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingColumnSpacingNotSpecified","SamplingColumnSpacing cannot be Null when SamplingNumberOfColumns is higher than 1:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfColumns->5,
				SamplingColumnSpacing->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingColumnSpacingNotSpecified,
				Error::ImageCellsCannotDetermineImagingSites,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsGridDefinedAsSinglePoint","Both SamplingNumberOfColumns and SamplingNumberOfRows cannot be set to 1 when SamplingPattern is Grid or Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfColumns->1,
				SamplingNumberOfRows->1
			],
			$Failed,
			Messages:>{
				Error::ImageCellsGridDefinedAsSinglePoint,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsCannotDetermineImagingSites","SamplingPattern, SamplingNumberOfColumns, SamplingNumberOfRows, SamplingColumnSpacing, SamplingRowSpacing cannot be Null when SamplingPattern is Grid or Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfColumns->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsCannotDetermineImagingSites,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidGridDefinition","Imaging sites calculated from SamplingNumberOfColumns, SamplingNumberOfRows, SamplingColumnSpacing, SamplingRowSpacing must fit inside each sample's container when SamplingPattern is Grid or Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfRows->30,
				SamplingNumberOfColumns->30,
				SamplingRowSpacing->1 Millimeter,
				SamplingColumnSpacing->1 Millimeter
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidGridDefinition,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidAdaptiveExcitationWaveLength","AdaptiveExcitationWaveLength must match one of the ExcitationWavelengths specified in Images option:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveExcitationWaveLength->500 Nanometer
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidAdaptiveExcitationWaveLength,
				Error::InvalidOption
			}
		],
		Test["AdaptiveExcitationWaveLength cannot be Null when SamplingPattern is Adaptive:",
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveExcitationWaveLength->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidAdaptiveExcitationWaveLength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"FirstWavelengthNotUsedForAdaptive","Throw a warning message if the specified AdaptiveExcitationWaveLength does not match the ExcitationWavelength of the first AcquireImage primitive in the Images option:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveExcitationWaveLength->638 Nanometer
			],
			ObjectP[Object[Protocol,ImageCells]],
			Messages:>{Warning::FirstWavelengthNotUsedForAdaptive}
		],
		Example[{Messages,"ImageCellsAdaptiveNumberOfCellsNotSpecified","AdaptiveNumberOfCells cannot be Null when SamplingPattern is Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveNumberOfCells->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveNumberOfCellsNotSpecified,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsAdaptiveMinNumberOfImagesNotSpecified","AdaptiveMinNumberOfImages cannot be Null when SamplingPattern is Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveMinNumberOfImages->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveMinNumberOfImagesNotSpecified,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsTooManyAdaptiveImagingSites","AdaptiveMinNumberOfImages must not exceed total number of imageable sites for each sample:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveMinNumberOfImages->25
			],
			$Failed,
			Messages:>{
				Error::ImageCellsTooManyAdaptiveImagingSites,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsAdaptiveCellWidthNotSpecified","AdaptiveCellWidth cannot be Null when SamplingPattern is Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveCellWidth->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveCellWidthNotSpecified,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsAdaptiveIntensityThresholdNotSpecified","AdaptiveIntensityThreshold cannot be Null when SamplingPattern is Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveIntensityThreshold->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveIntensityThresholdNotSpecified,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidAdaptiveIntensityThreshold","AdaptiveIntensityThreshold must not exceed the instrument's maximum gray level:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 4 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveIntensityThreshold->65000
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidAdaptiveIntensityThreshold,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsAdaptiveExcitationWaveLengthNotAllowed","If specified, AdaptiveExcitationWaveLength must be Null when SamplingPattern is not Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				AdaptiveExcitationWaveLength->477 Nanometer
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveExcitationWaveLengthNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsAdaptiveNumberOfCellsNotAllowed","If specified, AdaptiveNumberOfCells must be Null when SamplingPattern is not Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				AdaptiveNumberOfCells->20
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveNumberOfCellsNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsAdaptiveMinNumberOfImagesNotAllowed","If specified, AdaptiveMinNumberOfImages must be Null when SamplingPattern is not Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				AdaptiveMinNumberOfImages->20
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveMinNumberOfImagesNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsAdaptiveCellWidthNotAllowed","If specified, AdaptiveCellWidth must be Null when SamplingPattern is not Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				AdaptiveCellWidth->Span[5 Micrometer,10 Micrometer]
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveCellWidthNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsAdaptiveIntensityThresholdNotAllowed","If specified, AdaptiveIntensityThreshold must be Null when SamplingPattern is not Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				AdaptiveIntensityThreshold->200
			],
			$Failed,
			Messages:>{
				Error::ImageCellsAdaptiveIntensityThresholdNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingNumberOfRowsNotAllowed","If specified, SamplingNumberOfRows must be Null when SamplingPattern is not Grid or Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->SinglePoint,
				SamplingNumberOfRows->5
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingNumberOfRowsNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingNumberOfColumnsNotAllowed","If specified, SamplingNumberOfColumns must be Null when SamplingPattern is not Grid or Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->SinglePoint,
				SamplingNumberOfColumns->5
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingNumberOfColumnsNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingRowSpacingNotAllowed","If specified, SamplingRowSpacing must be Null when SamplingPattern is not Grid or Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->SinglePoint,
				SamplingRowSpacing->10 Micrometer
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingRowSpacingNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingColumnSpacingNotAllowed","If specified, SamplingColumnSpacing must be Null when SamplingPattern is not Grid or Adaptive:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->SinglePoint,
				SamplingColumnSpacing->10 Micrometer
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingColumnSpacingNotAllowed,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidSamplingCoordinates","SamplingCoordinates must be within each sample's well or position when SamplingPatten is Coordinates:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Coordinates,
				SamplingCoordinates->{{1 Micrometer,1 Micrometer},{3482 Micrometer,3482 Micrometer}}
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidSamplingCoordinates,
				Error::InvalidOption
			}
		],
		Test["SamplingCoordinates must be {0 \[Mu]m,0 \[Mu]m} when SamplingPatten is SinglePoint:",
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->SinglePoint,
				SamplingCoordinates->{{0 Micrometer,1 Micrometer}}
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidSamplingCoordinates,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsSamplingCoordinatesNotSpecified","SamplingCoordinates cannot be Null when SamplingPattern is Coordinates:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake Inverted Microscope Model for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Coordinates,
				SamplingCoordinates->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingCoordinatesNotSpecified,
				Error::InvalidOption
			}
		],
		Test["SamplingCoordinates cannot be Null when SamplingPattern is SinglePoint:",
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->SinglePoint,
				SamplingCoordinates->Null
			],
			$Failed,
			Messages:>{
				Error::ImageCellsSamplingCoordinatesNotSpecified,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ImageCellsInvalidCellType","Input samples must not contain any live yeast or bacterial cells:"},
			ExperimentImageCells[
				{
					{Object[Sample,"Yeast sample for ExperimentImageCells tests"<> $SessionUUID],Object[Sample,"Bacteria sample for ExperimentImageCells tests"<> $SessionUUID]}
				}
			],
			$Failed,
			Messages:>{
				Error::ImageCellsInvalidCellType,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ImageCellsObjectDoesNotExist","Specified objects must exist in the database:"},
			ExperimentImageCells[Object[Sample,"This sample does not exist"]],
			$Failed,
			Messages:>{
				Error::ImageCellsObjectDoesNotExist,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ImageCellsIncompatibleContainerThickness","Sample container's thickness must be smaller than the working distance of the objective:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 5 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Fake High Content Imager Model for ExperimentImageCells tests"<> $SessionUUID],
				ObjectiveMagnification->20
			],
			$Failed,
			Messages:>{
				Error::ImageCellsIncompatibleContainerThickness,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingImageCellsMethodRequirements","Throw an error if preparation is set to Robotic but cannot be performed that way:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 5 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Model[Instrument,Microscope,"Ti-E Inverted Microscope"],
				Preparation->Robotic
			],
			$Failed,
			Messages:>{
				Error::ConflictingImageCellsMethodRequirements,
				Error::InvalidOption
			}
		],
		(* ---options--- *)
		Example[{Options,Instrument,"The instrument that should be used to acquire images from the sample:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Object[Instrument,Microscope,"Fake High Content Imager Object for ExperimentImageCells tests"<> $SessionUUID],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectP[Object[Instrument,Microscope,"Fake High Content Imager Object for ExperimentImageCells tests"<> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,MicroscopeOrientation,"Specify the microscope orientation:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				MicroscopeOrientation->Inverted,
				Output->Options
			];
			Lookup[options,MicroscopeOrientation],
			Inverted,
			Variables:>{options}
		],
		Example[{Options,ReCalibrateMicroscope,"Indicates if the optical components of the microscope should be adjusted before imaging the sample:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ReCalibrateMicroscope->True,
				Instrument->Object[Instrument,Microscope,"Fake Inverted Microscope Object for ExperimentImageCells tests"<> $SessionUUID],
				Output->Options
			];
			Lookup[options,ReCalibrateMicroscope],
			True,
			Variables:>{options}
		],
		Example[{Options,"MicroscopeCalibration","A calibration object that specifies a set of parameters used to adjust optical components of the microscope:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ReCalibrateMicroscope->True,
				MicroscopeCalibration->Object[Maintenance,CalibrateMicroscope,"Fake Object Maintenance Microscope Calibration for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Object[Instrument,Microscope,"Fake Inverted Microscope Object for ExperimentImageCells tests"<> $SessionUUID],
				Output->Options
			];
			Lookup[options,MicroscopeCalibration],
			ObjectP[Object[Maintenance,CalibrateMicroscope,"Fake Object Maintenance Microscope Calibration for ExperimentImageCells tests"<> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,Temperature,"Set the temperature of the stage where the sample container is placed during imaging:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Temperature->30 Celsius,
				Output->Options
			];
			Lookup[options,Temperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CarbonDioxide,"Indicates if the sample will be incubated with CO2 during imaging:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				CarbonDioxide->True,
				Output->Options
			];
			Lookup[options,CarbonDioxide],
			True,
			Variables:>{options}
		],
		Example[{Options,CarbonDioxidePercentage,"Indicates percentage of CO2 in the gas mixture that will be provided to the sample during imaging:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				CarbonDioxide->True,
				CarbonDioxidePercentage->6 Percent,
				Output->Options
			];
			Lookup[options,CarbonDioxidePercentage],
			6*Percent,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,EquilibrationTime,"Indicates the amount of time for which the samples are placed on the stage of the microscope before the first image is acquired:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				EquilibrationTime->10 Minute,
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ContainerOrientation,"The orientation of the sample container when placed on the microscope stage for imaging:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ContainerOrientation->RightSideUp,
				Output->Options
			];
			Lookup[options,ContainerOrientation],
			RightSideUp,
			Variables:>{options}
		],
		Example[{Options,CoverslipThickness,"Specifies the thickness of the coverslip on sample's container:"},
			options=ExperimentImageCells[
				Object[Sample,"Microscope slide sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				CoverslipThickness->1.17 Millimeter,
				Output->Options
			];
			Lookup[options,CoverslipThickness],
			1.17*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,PlateBottomThickness,"Specifies the thickness of the sample's plate bottom:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				PlateBottomThickness->0.21 Millimeter,
				Output->Options
			];
			Lookup[options,PlateBottomThickness],
			0.21*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ObjectiveMagnification,"Specifies the objective lens magnification:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ObjectiveMagnification->20,
				Output->Options
			];
			Lookup[options,ObjectiveMagnification],
			20,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,PixelBinning,"Specifies the pixel binning of the acquired images:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				PixelBinning->8,
				Output->Options
			];
			Lookup[options,PixelBinning],
			8,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,Images,"Specifies the AcquireImage primitive containing parameters that are used to image the sample:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Images->{
					AcquireImage[
						Mode->ConfocalFluorescence,
						ExposureTime->10 Millisecond
					]
				},
				Output->Options
			];
			Lookup[options,Images],
			{AcquireImagePrimitiveP...},
			Variables:>{options}
		],
		Example[{Options,AdjustmentSample,"Specifies the sample that should be used to adjust the ExposureTime and FocalHeight in each imaging session:"},
			options=ExperimentImageCells[
				{
					{
						Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
						Object[Sample,"Fake cell sample 3 for ExperimentImageCells tests"<> $SessionUUID]
					}
				},
				AdjustmentSample->Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Output->Options
			];
			Lookup[options,AdjustmentSample],
			ObjectP[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,SamplingPattern,"Specifies the pattern of images that will be acquired from the samples:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				Output->Options
			];
			Lookup[options,SamplingPattern],
			Grid,
			Variables:>{options}
		],
		Example[{Options,SamplingNumberOfRows,"The number of rows which will be acquired for each sample if the Grid SamplingPattern is selected:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfRows->3,
				Output->Options
			];
			Lookup[options,SamplingNumberOfRows],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,SamplingNumberOfColumns,"The number of columns which will be acquired for each sample if the Grid SamplingPattern is selected:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingNumberOfColumns->3,
				Output->Options
			];
			Lookup[options,SamplingNumberOfColumns],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,SamplingRowSpacing,"The distance between each row of images to be acquired:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingRowSpacing->10 Percent,
				Output->Options
			];
			Lookup[options,SamplingRowSpacing],
			DistanceP,
			Variables:>{options}
		],
		Example[{Options,SamplingColumnSpacing,"The distance between each column of images to be acquired:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Grid,
				SamplingColumnSpacing->10 Percent,
				Output->Options
			];
			Lookup[options,SamplingColumnSpacing],
			DistanceP,
			Variables:>{options}
		],
		Example[{Options,SamplingCoordinates,"Specifies the positions at which images are acquired:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Instrument->Object[Instrument,Microscope,"Fake Inverted Microscope Object for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Coordinates,
				SamplingCoordinates->{{-10 Micrometer,10 Micrometer},{-5 Micrometer,20 Micrometer}},
				Output->Options
			];
			Lookup[options,SamplingCoordinates],
			{{-10 Micrometer,10 Micrometer},{-5 Micrometer,20 Micrometer}},
			Variables:>{options}
		],
		Example[{Options,AdaptiveExcitationWaveLength,"Specifies the excitation wavelength used to determine the number of cells in each field of view for the Adaptive SamplingPattern:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveExcitationWaveLength->477 Nanometer,
				Output->Options
			];
			Lookup[options,AdaptiveExcitationWaveLength],
			477*Nanometer,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AdaptiveNumberOfCells,"Specifies the minimum cell count per well that the instrument will work to satisfy by acquiring images from multiple regions before moving to the next sample:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveNumberOfCells->25,
				Output->Options
			];
			Lookup[options,AdaptiveNumberOfCells],
			25,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AdaptiveMinNumberOfImages,"The minimum number of regions that must be acquired when using the adpative sampling, even if the specified cell count (AdaptiveNumberOfCells) is already reached:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveNumberOfCells->25,
				AdaptiveMinNumberOfImages->10,
				Output->Options
			];
			Lookup[options,AdaptiveMinNumberOfImages],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AdaptiveCellWidth,"Specifies the expected range of cell size in the sample:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveCellWidth->5 Micrometer;;20 Micrometer,
				Output->Options
			];
			Lookup[options,AdaptiveCellWidth],
			Span[5 Micrometer,20 Micrometer],
			Variables:>{options}
		],
		Example[{Options,AdaptiveIntensityThreshold,"Specifies the intensity above local background value that a putative cell needs to have in order to be counted.:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				SamplingPattern->Adaptive,
				AdaptiveIntensityThreshold->250,
				Output->Options
			];
			Lookup[options,AdaptiveIntensityThreshold],
			250,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,Timelapse,"Indicates if the sample will be imaged at multiple time points:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				Output->Options
			];
			Lookup[options,Timelapse],
			True,
			Variables:>{options}
		],
		Example[{Options,TimelapseInterval,"Indicates the amount of time between the start of an acquisition at one time point and the start of an acquisition at the next time point:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				TimelapseInterval->10 Second,
				Output->Options
			];
			Lookup[options,TimelapseInterval],
			10*Second,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TimelapseDuration,"Indicates the total amount of time that the Timelapse images will be acquired for the sample:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				TimelapseDuration->10 Minute,
				Output->Options
			];
			Lookup[options,TimelapseDuration],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,NumberOfTimepoints,"Indicates the number of images that will be acquired from the sample in during the course of Timelapse imaging:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				NumberOfTimepoints->10,
				Output->Options
			];
			Lookup[options,NumberOfTimepoints],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ContinuousTimelapseImaging,"Indicates if images from multiple time points should be acquired from the samples in a single imaging session:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				ContinuousTimelapseImaging->True,
				Output->Options
			];
			Lookup[options,ContinuousTimelapseImaging],
			True,
			Variables:>{options}
		],
		Example[{Options,TimelapseAcquisitionOrder,"Indicates the order in which the time-series images are acquired with respect to the sample's location in the plate:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				TimelapseAcquisitionOrder->RowByRow,
				Output->Options
			];
			Lookup[options,TimelapseAcquisitionOrder],
			RowByRow,
			Variables:>{options}
		],
		Example[{Options,TimelapseAcquisitionOrder,"Indicates the order in which the time-series images are acquired with respect to the sample's location in the plate:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Timelapse->True,
				TimelapseAcquisitionOrder->RowByRow,
				Output->Options
			];
			Lookup[options,TimelapseAcquisitionOrder],
			RowByRow,
			Variables:>{options}
		],
		Example[{Options,ZStack,"Indicates if a series of images at multiple z-axis positions will be acquired for the sample:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True,
				Output->Options
			];
			Lookup[options,ZStack],
			True,
			Variables:>{options}
		],
		Example[{Options,ZStepSize,"Indicates the distance between each image plane in the Z-Stack:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True,
				ZStepSize->5 Micrometer,
				Output->Options
			];
			Lookup[options,ZStepSize],
			5*Micrometer,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,NumberOfZSteps,"Indicates the total number of image planes that will be acquired in the Z-stack:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True,
				NumberOfZSteps->5,
				Output->Options
			];
			Lookup[options,NumberOfZSteps],
			5,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ZStackSpan,"Indicates the range of Z-heights that the microscope will acquire images from in a Z-Stack:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				ZStack->True,
				ZStackSpan->(-10 Micrometer;;30 Micrometer),
				Output->Options
			];
			Lookup[options,ZStackSpan],
			Span[-10 Micrometer,30 Micrometer],
			Variables:>{options}
		],

		(* shared options *)
		Example[{Options,PreparatoryUnitOperations,"Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol=ExperimentImageCells[
				"my sample",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "my sample",
						Container -> Model[Container, Plate, "id:L8kPEjno5XoE"]
					],
					Transfer[
						Source -> Object[Sample, "Fake cell sample 1 for ExperimentImageCells tests" <> $SessionUUID],
						Destination -> "my sample",
						Amount -> 100 Microliter
					]
				}
			];
			Download[protocol,PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables:>{protocol}
		],
		Example[{Options,Name,"Name of the output protocol object can be specified:"},
			ExperimentImageCells[
				Object[Sample,"Fake cell sample 2 for ExperimentImageCells tests"<> $SessionUUID],
				Name->"ExperimentImageCells name test protocol"<> $SessionUUID
			],
			Object[Protocol,ImageCells,"ExperimentImageCells name test protocol"<> $SessionUUID]
		],
		Example[{Options,Template,"Template can be specified to inherit specified options from the parent protocol:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				Template->Object[Protocol,ImageCells,"ExperimentImageCells template test protocol"<> $SessionUUID],
				Output->Options
			];
			Lookup[options,ObjectiveMagnification],
			20,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"SamplesInStorageCondition can be specified:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				SamplesInStorageCondition->Refrigerator,
				Output->Options
			];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],

		(* post-processing options *)
		Example[{Options,MeasureWeight,"Set the MeasureWeight option:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				MeasureWeight->True,
				Output->Options
			];
			Lookup[options,MeasureWeight],
			True,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Set the MeasureVolume option:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				MeasureVolume->True,
				Output->Options
			];
			Lookup[options,MeasureVolume],
			True,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Set the ImageSample option:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				ImageSample->True,
				Output->Options
			];
			Lookup[options,ImageSample],
			True,
			Variables:>{options}
		],

		(* ---shared sample prep options--- *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample with incompatible container for ExperimentImageCells tests"<> $SessionUUID],
				Incubate->True,
				Centrifuge->True,
				Filtration->True,
				Aliquot->True,
				FilterContainerOut->Model[Container,Plate,"id:L8kPEjno5XoE"],
				Output->Options
			];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Variables:>{options},
			TimeConstraint->240
		],

		(* incubate options tests *)
		Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],IncubationTime->40*Minute,Output->Options];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],MaxIncubationTime->40*Minute,Output->Options];
			Lookup[options,MaxIncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],IncubationTemperature->40*Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"]],
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],AnnealingTime->40*Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],
				IncubateAliquot->100*Microliter,
				IncubateAliquotContainer->Model[Container,Plate,"id:L8kPEjno5XoE"],
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			100*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],IncubateAliquotContainer->Model[Container,Plate,"id:L8kPEjno5XoE"],Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Plate,"id:L8kPEjno5XoE"]]},
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],IncubateAliquotDestinationWell->"A1",IncubateAliquotContainer->Model[Container,Plate,"id:L8kPEjno5XoE"],Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 1 for ExperimentImageCells tests"<> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample with incompatible container for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"id:L8kPEjno5XoE"],
				MixType->Shake,
				Output->Options
			];
			Lookup[options,MixType],
			Shake,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample with incompatible container for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"id:L8kPEjno5XoE"],
				MixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options},
			TimeConstraint->240
		],

		(* centrifuge options tests *)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],CentrifugeTemperature->30*Celsius,Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				CentrifugeAliquotContainer->Model[Container,Plate,"id:L8kPEjno5XoE"],
				CentrifugeAliquot->0.1*Milliliter,
				Output->Options
			];
			Lookup[options,CentrifugeAliquot],
			0.1*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				CentrifugeAliquotContainer->Model[Container,Plate,"id:L8kPEjno5XoE"],
				Output->Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Plate,"id:L8kPEjno5XoE"]]},
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				CentrifugeAliquotContainer->Model[Container,Plate,"id:L8kPEjno5XoE"],
				CentrifugeAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			TimeConstraint->240
		],

		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"id:L8kPEjno5XoE"],
				Filtration->True,
				Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"id:L8kPEjno5XoE"],
				FiltrationType->Syringe,
				Output->Options
			];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"id:L8kPEjno5XoE"],
				FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],
				Output->Options
			];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"id:L8kPEjno5XoE"],
				Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],
				Output->Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"id:L8kPEjno5XoE"],
				FilterMaterial->PES,
				Output->Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options},
			TimeConstraint->240
		],
		(*Note: Put your sample in a 50mL tube with larger volume for the following test*)
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				PrefilterMaterial->GxF,
				Output->Options
			];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FilterPoreSize->0.22*Micrometer,
				Output->Options
			];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options},
			TimeConstraint->240
		],
		(*Note: Put your sample in a 50mL tube with larger volume for the following test*)
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				PrefilterPoreSize->1.*Micrometer,
				FilterMaterial->PTFE,
				Output->Options
			];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FiltrationType->Syringe,
				FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output->Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterHousing,"FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FiltrationType->Centrifuge,
				FilterTime->20*Minute,
				Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		(*Note: Put your sample in a 50mL tube for the following test*)
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FiltrationType->Centrifuge,
				FilterTemperature->10*Celsius,
				Output->Options
			];
			Lookup[options,FilterTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FiltrationType->Centrifuge,
				FilterIntensity->1000*RPM,
				Output->Options
			];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FilterSterile->False,
				Output->Options
			];
			Lookup[options,FilterSterile],
			False,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FilterAliquot->0.5*Milliliter,
				Output->Options
			];
			Lookup[options,FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],
				Output->Options
			];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentImageCells[
				Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],
				FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],
				FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],
				FilterAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentImageCells[Object[Sample,"Sample in 50mL tube for ExperimentImageCells tests"<> $SessionUUID],FilterContainerOut->Model[Container,Plate,"6-well Tissue Culture Plate"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Plate,"6-well Tissue Culture Plate"]]},
			Variables:>{options},
			TimeConstraint->240
		],
		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				Aliquot->True,
				Output->Options
			];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				AliquotAmount->50*Microliter,
				Output->Options
			];
			Lookup[options,AliquotAmount],
			50*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				AssayVolume->50*Microliter,
				Output->Options
			];
			Lookup[options,AssayVolume],
			50*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 10 for ExperimentImageCells tests"<> $SessionUUID],
				TargetConcentration->5*Micromolar,
				Output->Options
			];
			Lookup[options,TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 10 for ExperimentImageCells tests"<> $SessionUUID],
				TargetConcentration->1*Micromolar,
				TargetConcentrationAnalyte->Model[Molecule,"id:qdkmxzqabxnV"],
				Output->Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"id:qdkmxzqabxnV"]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->100*Microliter,
				AssayVolume->200*Microliter,
				Output->Options
			];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				BufferDilutionFactor->10,
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->100*Microliter,
				AssayVolume->200*Microliter,
				Output->Options
			];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				BufferDiluent->Model[Sample,"Milli-Q water"],
				BufferDilutionFactor->10,
				ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->100*Microliter,
				AssayVolume->200*Microliter,
				Output->Options
			];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],
				AliquotAmount->100*Microliter,
				AssayVolume->200*Microliter,
				Output->Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],Aliquot->True,ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],AliquotContainer->Model[Container,Plate,"6-well Tissue Culture Plate"],Output->Options];
			Lookup[options,AliquotContainer],
			{1,ObjectP[Model[Container,Plate,"6-well Tissue Culture Plate"]]},
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentImageCells[Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			"A1",
			Variables:>{options}
		],
		(* -- Labels -- *)
		Example[{Options, SampleLabel, "Specify the a label for the sample:"},
			options = ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				SampleLabel -> "a fancy sample",
				Output -> Options
			];
			Lookup[options, SampleLabel],
			"a fancy sample",
			Variables :> {options}
		],
		Example[{Options, SampleContainerLabel, "Specify the a label for the sample container:"},
			options = ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				SampleContainerLabel -> "a fancy sample container",
				Output -> Options
			];
			Lookup[options, SampleContainerLabel],
			"a fancy sample container",
			Variables :> {options}
		],
		Example[{Options, AliquotSampleLabel, "Specify the a label for the aliquot:"},
			options = ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel -> "a fancy aliquot of cells",
				Output -> Options
			];
			Lookup[options, AliquotSampleLabel],
			"a fancy aliquot of cells",
			Variables :> {options}
		],
		Example[{Options, AliquotSampleLabel, "Specify the a label for the aliquot:"},
			options = ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel -> "a fancy aliquot sample",
				Output -> Options
			];
			Lookup[options, AliquotSampleLabel],
			"a fancy aliquot sample",
			Variables :> {options}
		],
		Example[{Options, Preparation, "Specify the if the imaging should be done robotically:"},
			options = ExperimentImageCells[
				Object[Sample,"Fake cell sample 9 for ExperimentImageCells tests"<> $SessionUUID],
				Preparation->Manual,
				Output -> Options
			];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		setUpImageCellsTestObjects["ExperimentImageCells"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownImageCellsTestObjects["ExperimentImageCells"]
	)
];



(* ::Subsubsection::Closed:: *)
(*setUpImageCellsTestObjects*)


setUpImageCellsTestObjects[funcStringName_String]:=Module[{},
	Module[{allObjects,existingObjects},
		allObjects=Quiet[Cases[
			Flatten[{
				(*fake bench for creating containers*)
				Object[Container,Bench,"Fake bench for "<>funcStringName<>" tests"<> $SessionUUID],

				(*test containers*)
				Object[Container,Plate,"Fake plate 1 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 2 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 3 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 4 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 5 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 6 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 7 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Vessel,"Fake 2mL tube for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Hemocytometer,"Fake Hemocytometer for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate with opaque well for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,MicroscopeSlide,"Fake microscope slide for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Vessel,"Fake 50mL tube for "<>funcStringName<>" tests"<> $SessionUUID],

				(*identity models*)
				Model[Molecule,Protein,"Fake GFP for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Molecule,Protein,"Fake dsRed for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Molecule,Protein,"Fake iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Cell,Mammalian,"Fake mammalian cell for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Cell,Mammalian,"Fake mammalian cell with GFP for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Cell,Mammalian,"Fake mammalian cell with dsRed for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Cell,Mammalian,"Fake mammalian cell with GFP/dsRed/iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID],

				(*sample models*)
				Model[Sample,"Fake mammalian cell for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Sample,"Fake mammalian cell with GFP for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Sample,"Fake mammalian cell with dsRed for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Sample,"Fake mammalian cell with GFP/dsRed/iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Sample,"Fake mammalian cell with Trypan Blue for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Sample,"Fake trypan blue solution for "<>funcStringName<>" tests"<> $SessionUUID],

				(*test samples*)
				Object[Sample,"Fake cell sample 1 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 2 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 3 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 4 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 5 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 6 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 7 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 8 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 9 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Fake cell sample 10 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Discarded sample for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Containerless sample for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Sample with incompatible container for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Hemocytometer sample 1 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Hemocytometer sample 2 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Sample with opaque container for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Microscope slide sample 1 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Yeast sample for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Bacteria sample for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Sample,"Sample in 50mL tube for "<>funcStringName<>" tests"<> $SessionUUID],

				(* objective *)
				Model[Part,Objective,"Fake 4x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Part,Objective,"Fake 10x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Part,Objective,"Fake 20x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Part,Objective,"Fake 60x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID],

				(* Instrument *)
				Model[Instrument,Microscope,"Fake High Content Imager Model for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Instrument,Microscope,"Fake High Content Imager Object for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Instrument,Microscope,"Fake Inverted Microscope Model for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Instrument,Microscope,"Fake Inverted Microscope Object for "<>funcStringName<>" tests"<> $SessionUUID],
				Model[Maintenance,CalibrateMicroscope,"Fake Model Maintenance Microscope Calibration for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Maintenance,CalibrateMicroscope,"Fake Object Maintenance Microscope Calibration for "<>funcStringName<>" tests"<> $SessionUUID],

				(* protocol *)
				Object[Protocol,ImageCells,funcStringName<>" template test protocol"<> $SessionUUID],
				(* protocol objects *)
				If[DatabaseMemberQ[#],
					Download[#,{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}]
				]&/@{Object[Protocol,ImageCells,funcStringName<>" template test protocol"<> $SessionUUID],Object[Protocol,ImageCells,funcStringName<>" name test protocol"<> $SessionUUID]}
			}],
			ObjectP[]
		]];

		(* Check whether the names we want to give below already exist in the database *)
		existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

		(* Erase any objects that we failed to erase in the last unit test. *)
		EraseObject[existingObjects,Force->True,Verbose->False]
	];

	$CreatedObjects={};

	Block[{$AllowSystemsProtocols=True,$DeveloperSearch=True},
		Module[
			{
				fakeBenchPacket,instModelPacket,instModel,proteinPacket1,proteinPacket2,proteinPacket3,fakeBench,protein1,protein2,protein3,
				containerPackets,cellIdentityModelPacket1,cellIdentityModelPacket2,cellIdentityModelPacket3,cellIdentityModelPacket4,
				sampleModel1,sampleModel2,sampleModel3,sampleModel4,sampleModel5,sampleModel6,invertedModelPacket,instObjectPacket,invertedObjectPacket,
				sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,sample12,sample13,sample14,sample15,sample16,sample17,sample18,sample19,sample20,
				sampleList,containerList,templateTestProtocol,protocolObjects,objectivePackets,obj1,obj2,obj3,obj4,invertedModel,instObject,invertedObject,
				maintModelPacket,maintObjectPacket,invertedObjectUpdatePacket
			},

			(* set up fake bench as a location for the vessel *)
			fakeBenchPacket=<|
				Type->Object[Container,Bench],
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				Name->"Fake bench for "<>funcStringName<>" tests"<> $SessionUUID,
				StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]
			|>;

			(* create fake objective lenses *)
			objectivePackets={
				<|
					Object->CreateID[Model[Part,Objective]],
					Name->"Fake 4x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID,
					Magnification->4,
					MinWorkingDistance->20 Millimeter,
					MaxWorkingDistance->20 Millimeter,
					NumericalAperture->0.2,
					ImmersionMedium->Air
				|>,
				<|
					Object->CreateID[Model[Part,Objective]],
					Name->"Fake 10x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID,
					Magnification->10,
					MinWorkingDistance->4 Millimeter,
					MaxWorkingDistance->4 Millimeter,
					NumericalAperture->0.45,
					ImmersionMedium->Air
				|>,
				<|
					Object->CreateID[Model[Part,Objective]],
					Name->"Fake 20x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID,
					Magnification->20,
					MinWorkingDistance->900 Micrometer,
					MaxWorkingDistance->990 Micrometer,
					NumericalAperture->0.95,
					ImmersionMedium->Water
				|>,
				<|
					Object->CreateID[Model[Part,Objective]],
					Name->"Fake 60x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID,
					Magnification->60,
					MinWorkingDistance->280 Micrometer,
					MaxWorkingDistance->310 Micrometer,
					NumericalAperture->1.2,
					ImmersionMedium->Water
				|>
			};

			(* create an instrument model packet for high content imager *)
			instModelPacket=<|
				Object->CreateID[Model[Instrument,Microscope]],
				Name->"Fake High Content Imager Model for "<>funcStringName<>" tests"<> $SessionUUID,
				Deprecated->Null,
				Replace[Positions]->{<|Name->"Sample Slot",Footprint->Plate,MaxWidth->0.13 Meter,MaxDepth->0.09 Meter,MaxHeight->0.0196 Meter|>},
				ActiveHumidityControl->False,
				Autofocus->True,
				CameraModel->Link[Model[Part,Camera,"id:KBL5DvwEj5Xa"]],
				CarbonDioxideControl->True,
				CustomizableImagingChannel->True,
				Replace[DefaultExcitationPowers]->ConstantArray[100 Percent,9],
				Replace[DefaultImageCorrections]->{ShadingCorrection,BackgroundAndShadingCorrection,BackgroundAndShadingCorrection},
				DefaultSamplingMethod->SinglePoint,
				DefaultTransmittedLightPower->20 Percent,
				Replace[DichroicFilterWavelengths]->{421 Nanometer,445 Nanometer,488 Nanometer,520 Nanometer,564 Nanometer,593 Nanometer,656 Nanometer,656 Nanometer,774 Nanometer},
				Replace[FluorescenceEmissionWavelengths]->{452 Nanometer,483 Nanometer,520 Nanometer,562 Nanometer,595 Nanometer,624 Nanometer,692 Nanometer,692 Nanometer,819 Nanometer},
				Replace[FluorescenceExcitationWavelengths]->{405 Nanometer,446 Nanometer,477 Nanometer,520 Nanometer,546 Nanometer,546 Nanometer,546 Nanometer,638 Nanometer,749 Nanometer},
				HighContentImaging->True,
				HumidityControl->True,
				Replace[IlluminationTypes]->{LED,SolidStateLaser,SolidStateLaser},
				Replace[ImageCorrectionMethods]->{BackgroundCorrection,ShadingCorrection,BackgroundAndShadingCorrection},
				ImageDeconvolution->True,
				Replace[ImagingChannels]->{DAPI,CFP,FITC,YFP,TRITC,TexasRed,Cy3Cy5FRET,Cy5,Cy7},
				Replace[LampTypes]->{LED},
				MaxTemperatureControl->40 Celsius,
				MinTemperatureControl->25 Celsius,
				Replace[Modes]->{BrightField,ConfocalFluorescence,Epifluorescence},
				Replace[ObjectiveMagnifications]->{4.,10.,20.,60.},
				Replace[Objectives]->Link[Lookup[objectivePackets,Object]],
				Orientation->Inverted,
				Replace[PixelBinning]->{1,2,3,4,8},
				Replace[SamplingMethods]->{SinglePoint,Grid,Adaptive},
				TemperatureControlledEnvironment->True,
				TimelapseImaging->True,
				ZStackImaging->True,
				MicroscopeCalibration->False,
				MaxImagingChannels->8,
				TransmittedLightColorCorrection->Null,
				MinExposureTime->0.01 Millisecond,
				MaxExposureTime->5000 Millisecond,
				DefaultTargetMaxIntensity->33000,
				MaxGrayLevel->60000,
				ImageSizeX->2048 Pixel,
				ImageSizeY->2048 Pixel,
				Replace[ImageScalesX]->{1.7003 Micrometer/Pixel,0.6790 Micrometer/Pixel,0.3399 Micrometer/Pixel,0.1136 Micrometer/Pixel},
				Replace[ImageScalesY]->{1.7003 Micrometer/Pixel,0.6790 Micrometer/Pixel,0.3399 Micrometer/Pixel,0.1136 Micrometer/Pixel},
				MaxFocalHeight->14300 Micrometer
			|>;

			invertedModelPacket=<|
				Object->CreateID[Model[Instrument,Microscope]],
				Name->"Fake Inverted Microscope Model for "<>funcStringName<>" tests"<> $SessionUUID,
				Replace[Positions]->{<|Name->"Sample Slot",Footprint->Open,MaxWidth->0.2794 Meter,MaxDepth->0.3048 Meter,MaxHeight->Null|>},
				ActiveHumidityControl->False,
				Autofocus->True,
				CameraModel->Link[Model[Part,Camera,"id:Z1lqpMGjeK6V"]],
				CarbonDioxideControl->False,
				CustomizableImagingChannel->False,
				Replace[DefaultExcitationPowers]->{100 Percent,100 Percent,100 Percent,100 Percent},
				DefaultSamplingMethod->SinglePoint,
				DefaultTransmittedLightPower->20 Percent,
				Replace[DichroicFilterWavelengths]->{400 Nanometer,495 Nanometer,570 Nanometer,660 Nanometer},
				Replace[FluorescenceEmissionWavelengths]->{460 Nanometer,525 Nanometer,620 Nanometer,700 Nanometer},
				Replace[FluorescenceExcitationWavelengths]->{350 Nanometer,470 Nanometer,545 Nanometer,620 Nanometer},
				HighContentImaging->False,
				HumidityControl->False,
				Replace[IlluminationTypes]->{MercuryLamp,MercuryLamp,Fiber},
				ImageDeconvolution->False,
				Replace[ImagingChannels]->{DAPI,FITC,TRITC,Cy5},
				Replace[LampTypes]->{MercuryLamp,Fiber},
				Replace[Modes]->{BrightField,PhaseContrast,Epifluorescence},
				Replace[ObjectiveMagnifications]->{4.,10.,20.,60.},
				Replace[Objectives]->Link[Lookup[objectivePackets,Object]],
				Orientation->Inverted,
				Replace[PixelBinning]->{1,2,3,4,8},
				Replace[SamplingMethods]->{SinglePoint,Coordinates},
				TemperatureControlledEnvironment->False,
				TimelapseImaging->False,
				ZStackImaging->False,
				MicroscopeCalibration->True,
				MaxImagingChannels->4,
				TransmittedLightColorCorrection->True,
				MinExposureTime->0.1 Millisecond,
				MaxExposureTime->1.8*10^7 Millisecond,
				DefaultTargetMaxIntensity->12288,
				MaxGrayLevel->16384,
				ImageSizeX->1392 Pixel,
				ImageSizeY->1040 Pixel,
				Replace[ImageScalesX]->{1.61 Micrometer/Pixel,0.64 Micrometer/Pixel,0.32 Micrometer/Pixel,0.16 Micrometer/Pixel},
				Replace[ImageScalesY]->{1.61 Micrometer/Pixel,0.64 Micrometer/Pixel,0.32 Micrometer/Pixel,0.16 Micrometer/Pixel},
				MaxFocalHeight->9760 Micrometer
			|>;

			(* create instrument object packets *)
			instObjectPacket=<|
				Type->Object[Instrument,Microscope],
				Model->Link[Lookup[instModelPacket,Object],Objects],
				Name->"Fake High Content Imager Object for "<>funcStringName<>" tests"<> $SessionUUID,
				DeveloperObject->True,
				Status->Available,
				Site -> Link[$Site]
			|>;

			invertedObjectPacket=<|
				Type->Object[Instrument,Microscope],
				Model->Link[Lookup[invertedModelPacket,Object],Objects],
				Name->"Fake Inverted Microscope Object for "<>funcStringName<>" tests"<> $SessionUUID,
				DeveloperObject->True,
				Status->Available,
				Site -> Link[$Site]
			|>;

			(* create fluorescent protein identity models *)
			{proteinPacket1,proteinPacket2,proteinPacket3}=UploadProtein[
				{
					"Fake GFP for "<>funcStringName<>" tests"<> $SessionUUID,
					"Fake dsRed for "<>funcStringName<>" tests"<> $SessionUUID,
					"Fake iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID
				},
				State->Solid,
				BiosafetyLevel->"BSL-1",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				DetectionLabel->True,
				Fluorescent->True,
				FluorescenceExcitationMaximums->{
					{488 Nanometer},
					{558 Nanometer},
					{643 Nanometer}
				},
				FluorescenceEmissionMaximums->{
					{510 Nanometer},
					{583 Nanometer},
					{670 Nanometer}
				},
				Upload->False
			];

			(* first upload call *)
			{
				fakeBench,protein1,protein2,protein3,obj1,obj2,obj3,obj4,instModel,invertedModel,instObject,invertedObject
			}=Upload[
				Append[#,DeveloperObject->True]&/@Flatten[{fakeBenchPacket,proteinPacket1,proteinPacket2,proteinPacket3,objectivePackets,instModelPacket,invertedModelPacket,instObjectPacket,invertedObjectPacket}]
			];

			(* create maintenance model calibrate microscope *)
			maintModelPacket=<|
				Object->CreateID[Model[Maintenance,CalibrateMicroscope]],
				Name->"Fake Model Maintenance Microscope Calibration for "<>funcStringName<>" tests"<> $SessionUUID,
				Replace[Authors]->Link[$PersonID],
				Replace[Targets]->Link[invertedModel,MaintenanceFrequency,1],
				CalibrateCondenserHeight->True,
				CalibratePhaseRing->True,
				ApertureDiaphragm->25 Percent,
				FieldDiaphragm->80 Percent,
				DeveloperObject->True
			|>;

			(* create maintenance calibrate microscope *)
			maintObjectPacket=<|
				Object->CreateID[Object[Maintenance,CalibrateMicroscope]],
				Name->"Fake Object Maintenance Microscope Calibration for "<>funcStringName<>" tests"<> $SessionUUID,
				Model->Link[Lookup[maintModelPacket,Object],Objects],
				Target->Link[invertedObject],
				Status->Completed,
				DateConfirmed->(Today-3 Day),
				DateEnqueued->(Today-2 Day),
				DateStarted->(Today-1 Day),
				DateCompleted->Today,
				CondenserHeight->50 Centimeter,
				CondenserXPosition->2,
				CondenserYPosition->3,
				PhaseRingXPosition->4,
				PhaseRingYPosition->5,
				ApertureDiaphragm->25 Percent,
				FieldDiaphragm->80 Percent,
				DeveloperObject->True
			|>;

			(* update instrument object with maintenances model/object *)
			invertedObjectUpdatePacket=<|
				Object->invertedObject,
				CurrentMicroscopeCalibration->{Today,Link[Lookup[maintObjectPacket,Object]],Link[Lookup[maintModelPacket,Object]]}
			|>;

			(* set up fake containers for our samples *)
			containerPackets=UploadSample[
				{
					(*1*)Model[Container,Plate,"id:L8kPEjno5XoE"],(* 96-well clear bottom *)
					(*2*)Model[Container,Plate,"id:E8zoYveRlldX"],(* 24-well clear bottom *)
					(*3*)Model[Container,Plate,"id:E8zoYveRlldX"],(* 24-well clear bottom *)
					(*4*)Model[Container,Plate,"id:E8zoYveRlldX"],(* 24-well clear bottom *)
					(*5*)Model[Container,Vessel,"id:3em6Zv9NjjN8"],(* 2mL tube *)
					(*6*)Model[Container,Hemocytometer,"id:aXRlGn6wP7z9"],(* 2-chip hemocytometer *)
					(*7*)Model[Container,Plate,"id:L8kPEjno5XoE"],(* 96-well clear bottom *)
					(*8*)Model[Container,Plate,"id:AEqRl9KmGPWa"],(* 96-well opaque black *)
					(*9*)Model[Container,MicroscopeSlide,"id:1ZA60vLVWzqa"],
					(*10*)Model[Container,Plate,"id:L8kPEjno5XoE"],(* 96-well clear bottom *)
					(*11*)Model[Container,Vessel,"id:bq9LA0dBGGR6"],(* 50mL tube *)
					(*12*)Model[Container,Plate,"id:L8kPEjno5XoE"](* 96-well clear bottom *)
				},
				{
					(*1*){"Work Surface",fakeBench},
					(*2*){"Work Surface",fakeBench},
					(*3*){"Work Surface",fakeBench},
					(*4*){"Work Surface",fakeBench},
					(*5*){"Work Surface",fakeBench},
					(*6*){"Work Surface",fakeBench},
					(*7*){"Work Surface",fakeBench},
					(*8*){"Work Surface",fakeBench},
					(*9*){"Work Surface",fakeBench},
					(*10*){"Work Surface",fakeBench},
					(*11*){"Work Surface",fakeBench},
					(*12*){"Work Surface",fakeBench}
				},
				Status->{
					(*1*)Available,
					(*2*)Available,
					(*3*)Available,
					(*4*)Available,
					(*5*)Available,
					(*6*)Available,
					(*7*)Available,
					(*8*)Available,
					(*9*)Available,
					(*10*)Available,
					(*11*)Available,
					(*12*)Available
				},
				Name->{
					(*1*)"Fake plate 1 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*2*)"Fake plate 2 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*3*)"Fake plate 3 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*4*)"Fake plate 4 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*5*)"Fake 2mL tube for "<>funcStringName<>" tests"<> $SessionUUID,
					(*6*)"Fake Hemocytometer for "<>funcStringName<>" tests"<> $SessionUUID,
					(*7*)"Fake plate 5 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*8*)"Fake plate with opaque well for "<>funcStringName<>" tests"<> $SessionUUID,
					(*9*)"Fake microscope slide for "<>funcStringName<>" tests"<> $SessionUUID,
					(*10*)"Fake plate 6 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*11*)"Fake 50mL tube for "<>funcStringName<>" tests"<> $SessionUUID,
					(*10*)"Fake plate 7 for "<>funcStringName<>" tests"<> $SessionUUID
				},
				FastTrack->True,
				Upload->False
			];

			(* create mammalian cell identity models *)
			{
				cellIdentityModelPacket1,
				cellIdentityModelPacket2,
				cellIdentityModelPacket3,
				cellIdentityModelPacket4
			}=UploadMammalianCell[
				{
					"Fake mammalian cell for "<>funcStringName<>" tests"<> $SessionUUID,
					"Fake mammalian cell with GFP for "<>funcStringName<>" tests"<> $SessionUUID,
					"Fake mammalian cell with dsRed for "<>funcStringName<>" tests"<> $SessionUUID,
					"Fake mammalian cell with GFP/dsRed/iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID
				},
				(*CellType->Adherent,*)
				Morphology->Epithelial,
				Diameter->15 Micrometer,
				BiosafetyLevel->"BSL-2",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				DetectionLabels->{
					Null,
					{protein1},
					{protein2},
					{protein1,protein2,protein3}
				},
				CellType->{
					Mammalian,
					Mammalian,
					Mammalian,
					Mammalian
				},
				CultureAdhesion->{
					Adherent,
					Adherent,
					Adherent,
					Adherent
				},
				Upload->False
			];

			(* second upload call *)
			Upload[Flatten[{containerPackets,cellIdentityModelPacket1,cellIdentityModelPacket2,cellIdentityModelPacket3,
				cellIdentityModelPacket4,maintModelPacket,maintObjectPacket,invertedObjectUpdatePacket}]];

			(* create default sample models *)
			{sampleModel1,sampleModel2,sampleModel3,sampleModel4,sampleModel5,sampleModel6}=UploadSampleModel[
				{
					(*1*)"Fake mammalian cell for "<>funcStringName<>" tests"<> $SessionUUID,
					(*2*)"Fake mammalian cell with GFP for "<>funcStringName<>" tests"<> $SessionUUID,
					(*3*)"Fake mammalian cell with dsRed for "<>funcStringName<>" tests"<> $SessionUUID,
					(*4*)"Fake mammalian cell with GFP/dsRed/iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*5*)"Fake mammalian cell with Trypan Blue for "<>funcStringName<>" tests"<> $SessionUUID,
					(*6*)"Fake trypan blue solution for "<>funcStringName<>" tests"<> $SessionUUID
				},
				Composition->{
					(*1*){{100 MassPercent,Model[Cell,Mammalian,"Fake mammalian cell for "<>funcStringName<>" tests"<> $SessionUUID]}},
					(*2*){{100 MassPercent,Model[Cell,Mammalian,"Fake mammalian cell with GFP for "<>funcStringName<>" tests"<> $SessionUUID]}},
					(*3*){{100 MassPercent,Model[Cell,Mammalian,"Fake mammalian cell with dsRed for "<>funcStringName<>" tests"<> $SessionUUID]}},
					(*4*){{100 MassPercent,Model[Cell,Mammalian,"Fake mammalian cell with GFP/dsRed/iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID]}},
					(*5*){{98.8 VolumePercent,Model[Cell,Mammalian,"Fake mammalian cell for "<>funcStringName<>" tests"<> $SessionUUID]},{0.2 VolumePercent,Model[Molecule,"id:qdkmxzqabxnV"]}},(* with 0.2% trypan blue *)
					(*6*){{100 VolumePercent,Model[Molecule,"id:vXl9j57PmP5D"]},{10 Micromolar,Model[Molecule,"id:qdkmxzqabxnV"]}} (* with trypan blue *)

				},
				Expires->False,
				DefaultStorageCondition->{
					(*1*)Model[StorageCondition,"id:BYDOjvGNDpvm"],(* Mammalian Incubation *)
					(*2*)Model[StorageCondition,"id:BYDOjvGNDpvm"],(* Mammalian Incubation *)
					(*3*)Model[StorageCondition,"id:BYDOjvGNDpvm"],(* Mammalian Incubation *)
					(*4*)Model[StorageCondition,"id:BYDOjvGNDpvm"],(* Mammalian Incubation *)
					(*5*)Model[StorageCondition,"id:7X104vnR18vX"],(* Ambient *)
					(*6*)Model[StorageCondition,"id:7X104vnR18vX"] (* Ambient *)
				},
				State->Liquid,
				BiosafetyLevel->"BSL-2",
				Flammable->False,
				MSDSRequired->False,
				IncompatibleMaterials->{None},
				Living -> {True,True,True,True,True,False}
			];

			(* set up fake samples to test *)
			{
				(*1*)sample1,
				(*2*)sample2,
				(*3*)sample3,
				(*4*)sample4,
				(*5*)sample5,
				(*6*)sample6,
				(*7*)sample7,
				(*8*)sample8,
				(*9*)sample9,
				(*10*)sample10,
				(*11*)sample11,
				(*12*)sample12,
				(*13*)sample13,
				(*14*)sample14,
				(*15*)sample15,
				(*16*)sample16,
				(*17*)sample17,
				(*18*)sample18,
				(*19*)sample19,
				(*20*)sample20
			}=UploadSample[
				{
					(*1*)sampleModel1,
					(*2*)sampleModel2,
					(*3*)sampleModel3,
					(*4*)sampleModel4,
					(*5*)sampleModel1,
					(*6*)sampleModel2,
					(*7*)sampleModel3,
					(*8*)sampleModel4,
					(*9*)sampleModel1,
					(*10*)sampleModel1,
					(*11*)sampleModel1,
					(*12*)sampleModel5,
					(*13*)sampleModel5,
					(*14*)sampleModel4,
					(*15*)sampleModel1,
					(*16*)sampleModel1,
					(*17*)Model[Sample,"id:Z1lqpMGjeYWW"],(* yeast *)
					(*18*)Model[Sample,"id:D8KAEvdqzbBY"],(* E. coli *)
					(*19*)sampleModel1,
					(*20*)sampleModel6
				},
				{
					(*1*){"A1",Object[Container,Plate,"Fake plate 1 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*2*){"B1",Object[Container,Plate,"Fake plate 1 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*3*){"C1",Object[Container,Plate,"Fake plate 1 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*4*){"D1",Object[Container,Plate,"Fake plate 1 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*5*){"A2",Object[Container,Plate,"Fake plate 2 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*6*){"B2",Object[Container,Plate,"Fake plate 2 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*7*){"C2",Object[Container,Plate,"Fake plate 2 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*8*){"D2",Object[Container,Plate,"Fake plate 2 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*9*){"A1",Object[Container,Plate,"Fake plate 3 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*10*){"A1",Object[Container,Plate,"Fake plate 4 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*11*){"A1",Object[Container,Vessel,"Fake 2mL tube for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*12*){"A1",Object[Container,Hemocytometer,"Fake Hemocytometer for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*13*){"A2",Object[Container,Hemocytometer,"Fake Hemocytometer for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*14*){"A1",Object[Container,Plate,"Fake plate 5 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*15*){"A1",Object[Container,Plate,"Fake plate with opaque well for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*16*){"A1",Object[Container,MicroscopeSlide,"Fake microscope slide for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*17*){"A1",Object[Container,Plate,"Fake plate 6 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*18*){"A2",Object[Container,Plate,"Fake plate 6 for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*19*){"A1",Object[Container,Vessel,"Fake 50mL tube for "<>funcStringName<>" tests"<> $SessionUUID]},
					(*20*){"A1",Object[Container,Plate,"Fake plate 7 for "<>funcStringName<>" tests"<> $SessionUUID]}
				},
				InitialAmount->{
					(*1*)200 Microliter,
					(*2*)200 Microliter,
					(*3*)200 Microliter,
					(*4*)200 Microliter,
					(*5*)500 Microliter,
					(*6*)500 Microliter,
					(*7*)500 Microliter,
					(*8*)500 Microliter,
					(*9*)500 Microliter,
					(*10*)500 Microliter,
					(*11*)200 Microliter,
					(*12*)10 Microliter,
					(*13*)10 Microliter,
					(*14*)200 Microliter,
					(*15*)200 Microliter,
					(*16*)1 Microliter,
					(*17*)200 Microliter,
					(*18*)200 Microliter,
					(*19*)4 Milliliter,
					(*20*)200 Microliter
				},
				Name->{
					(*1*)"Fake cell sample 1 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*2*)"Fake cell sample 2 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*3*)"Fake cell sample 3 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*4*)"Fake cell sample 4 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*5*)"Fake cell sample 5 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*6*)"Fake cell sample 6 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*7*)"Fake cell sample 7 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*8*)"Fake cell sample 8 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*9*)"Discarded sample for "<>funcStringName<>" tests"<> $SessionUUID,
					(*10*)"Containerless sample for "<>funcStringName<>" tests"<> $SessionUUID,
					(*11*)"Sample with incompatible container for "<>funcStringName<>" tests"<> $SessionUUID,
					(*12*)"Hemocytometer sample 1 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*13*)"Hemocytometer sample 2 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*14*)"Fake cell sample 9 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*15*)"Sample with opaque container for "<>funcStringName<>" tests"<> $SessionUUID,
					(*16*)"Microscope slide sample 1 for "<>funcStringName<>" tests"<> $SessionUUID,
					(*17*)"Yeast sample for "<>funcStringName<>" tests"<> $SessionUUID,
					(*18*)"Bacteria sample for "<>funcStringName<>" tests"<> $SessionUUID,
					(*19*)"Sample in 50mL tube for "<>funcStringName<>" tests"<> $SessionUUID,
					(*20*)"Fake cell sample 10 for "<>funcStringName<>" tests"<> $SessionUUID
				},
				SampleHandling->{
					(*1*)Liquid,
					(*2*)Liquid,
					(*3*)Liquid,
					(*4*)Liquid,
					(*5*)Liquid,
					(*6*)Liquid,
					(*7*)Liquid,
					(*8*)Liquid,
					(*9*)Liquid,
					(*10*)Liquid,
					(*11*)Liquid,
					(*12*)Liquid,
					(*13*)Liquid,
					(*14*)Liquid,
					(*15*)Liquid,
					(*16*)Liquid,
					(*17*)Null,
					(*18*)Null,
					(*19*)Liquid,
					(*20*)Null
				},
				CellType->{
					(*1*)Mammalian,
					(*2*)Mammalian,
					(*3*)Mammalian,
					(*4*)Mammalian,
					(*5*)Mammalian,
					(*6*)Mammalian,
					(*7*)Mammalian,
					(*8*)Mammalian,
					(*9*)Mammalian,
					(*10*)Mammalian,
					(*11*)Mammalian,
					(*12*)Mammalian,
					(*13*)Mammalian,
					(*14*)Mammalian,
					(*15*)Mammalian,
					(*16*)Mammalian,
					(*17*)Yeast,
					(*18*)Bacterial,
					(*19*)Mammalian,
					(*20*)Null
				},
				CultureAdhesion->ConstantArray[Adherent,20]
			];

			(* make lists of samples/containers *)
			sampleList={sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,sample10,sample11,sample12,sample13,sample14,sample15,sample16,sample17,sample18,sample19,sample20};
			containerList={
				Object[Container,Plate,"Fake plate 1 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 2 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 3 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 4 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Vessel,"Fake 2mL tube for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Hemocytometer,"Fake Hemocytometer for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 5 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate with opaque well for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Microscope,"Fake microscope slide for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 6 for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Vessel,"Fake 50mL tube for "<>funcStringName<>" tests"<> $SessionUUID],
				Object[Container,Plate,"Fake plate 7 for "<>funcStringName<>" tests"<> $SessionUUID]
			};

			(*Generate a test protocol for the template test*)
			templateTestProtocol=ExperimentImageCells[
				Object[Sample,"Fake cell sample 1 for "<>funcStringName<>" tests"<> $SessionUUID],
				Name->funcStringName<>" template test protocol"<> $SessionUUID,
				Instrument->instModel,
				ObjectiveMagnification->20
			];

			(*Get the objects generated in the test protocol*)
			protocolObjects=Download[templateTestProtocol,{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}];

			(* final upload call *)
			Upload[Flatten[{
				(* upload DeveloperObject -> True for all test objects *)
				Map[
					<|Object->#,DeveloperObject->True|>&,
					Cases[Flatten[{$CreatedObjects,sampleList,containerList,protocolObjects}],ObjectP[]]
				],
				(* update DefaultSampleModel of cell identity models *)
				MapThread[
					<|Object->#1,DefaultSampleModel->Link[#2]|>&,
					{
						Lookup[Flatten[{cellIdentityModelPacket1,cellIdentityModelPacket2,cellIdentityModelPacket3,cellIdentityModelPacket4}],Object],
						{sampleModel1,sampleModel2,sampleModel3,sampleModel4}
					}
				],
				(* upload status for discarded sample *)
				<|Object->sample9,Status->Discarded|>,
				(* remove container for containerless test sample *)
				<|Object->sample10,Container->Null|>
			}]];
		]
	];
];


(* ::Subsubsection::Closed:: *)
(*tearDownImageCellsTestObjects*)


tearDownImageCellsTestObjects[funcStringName_String]:=Module[{allObjects,existingObjects},
	allObjects=Quiet[Cases[
		Flatten[{
			$CreatedObjects,

			(*fake bench for creating containers*)
			Object[Container,Bench,"Fake bench for "<>funcStringName<>" tests"<> $SessionUUID],

			(*test containers*)
			Object[Container,Plate,"Fake plate 1 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Plate,"Fake plate 2 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Plate,"Fake plate 3 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Plate,"Fake plate 4 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Plate,"Fake plate 5 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Plate,"Fake plate 6 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Plate,"Fake plate 7 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Vessel,"Fake 2mL tube for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Hemocytometer,"Fake Hemocytometer for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Plate,"Fake plate with opaque well for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,MicroscopeSlide,"Fake microscope slide for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Container,Vessel,"Fake 50mL tube for "<>funcStringName<>" tests"<> $SessionUUID],

			(*identity models*)
			Model[Molecule,Protein,"Fake GFP for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Molecule,Protein,"Fake dsRed for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Molecule,Protein,"Fake iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Cell,Mammalian,"Fake mammalian cell for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Cell,Mammalian,"Fake mammalian cell with GFP for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Cell,Mammalian,"Fake mammalian cell with dsRed for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Cell,Mammalian,"Fake mammalian cell with GFP/dsRed/iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID],

			(*sample models*)
			Model[Sample,"Fake mammalian cell for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Sample,"Fake mammalian cell with GFP for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Sample,"Fake mammalian cell with dsRed for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Sample,"Fake mammalian cell with GFP/dsRed/iRFP670 for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Sample,"Fake mammalian cell with Trypan Blue for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Sample,"Fake trypan blue solution for "<>funcStringName<>" tests"<> $SessionUUID],

			(*test samples*)
			Object[Sample,"Fake cell sample 1 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 2 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 3 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 4 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 5 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 6 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 7 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 8 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 9 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Fake cell sample 10 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Discarded sample for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Containerless sample for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Sample with incompatible container for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Hemocytometer sample 1 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Hemocytometer sample 2 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Sample with opaque container for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Microscope slide sample 1 for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Yeast sample for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Bacteria sample for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Sample,"Sample in 50mL tube for "<>funcStringName<>" tests"<> $SessionUUID],

			(* objective *)
			Model[Part,Objective,"Fake 4x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Part,Objective,"Fake 10x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Part,Objective,"Fake 20x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Part,Objective,"Fake 60x Objective Model for "<>funcStringName<>" tests"<> $SessionUUID],

			(* Instrument *)
			Model[Instrument,Microscope,"Fake High Content Imager Model for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Instrument,Microscope,"Fake High Content Imager Object for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Instrument,Microscope,"Fake Inverted Microscope Model for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Instrument,Microscope,"Fake Inverted Microscope Object for "<>funcStringName<>" tests"<> $SessionUUID],
			Model[Maintenance,CalibrateMicroscope,"Fake Model Maintenance Microscope Calibration for "<>funcStringName<>" tests"<> $SessionUUID],
			Object[Maintenance,CalibrateMicroscope,"Fake Object Maintenance Microscope Calibration for "<>funcStringName<>" tests"<> $SessionUUID],

			(* protocol *)
			Object[Protocol,ImageCells,funcStringName<>" template test protocol"<> $SessionUUID],
			(* protocol objects *)
			If[DatabaseMemberQ[#],
				Download[#,{Object,SubprotocolRequiredResources[Object],ProcedureLog[Object]}]
			]&/@{Object[Protocol,ImageCells,funcStringName<>" template test protocol"<> $SessionUUID],Object[Protocol,ImageCells,funcStringName<>" name test protocol"<> $SessionUUID]}
		}],
		ObjectP[]
	]];

	(* Check whether the names we want to give below already exist in the database *)
	existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

	(* Erase any objects that we failed to erase in the last unit test. *)
	EraseObject[existingObjects,Force->True,Verbose->False];

	(* clean $CreatedObjects *)
	Unset[$CreatedObjects]
];



(* ::Subsection:: *)
(* ImageCells *)

DefineTests[ImageCells,
	{
		Example[{Basic, "Make ImageCell Unit operations with a single sample:"},
			ImageCells[
				Sample -> Object[Sample, "Fake cell sample 1 for ImageCells tests"<> $SessionUUID]
			],
			_ImageCells
		],
		Example[{Basic,"Make imageCell unit operations with sample labeling:"},
			ImageCells[
				Sample -> Object[Sample, "Fake cell sample 1 for ImageCells tests"<> $SessionUUID],
				SampleLabel -> "Test sample"
			],
			_ImageCells
		],
		Example[{Basic,"Make ImageCell unit operations with multiple samples:"},
			ImageCells[
				Sample -> {
					Object[Sample, "Fake cell sample 1 for ImageCells tests"<> $SessionUUID],
					Object[Sample, "Fake cell sample 2 for ImageCells tests"<> $SessionUUID]
				},
				SampleLabel -> "Test sample"
			],
			_ImageCells
		],
		Test["Generate ManualCellPreparation protocol using ImageCells unit operations:",
			Experiment[{
				ImageCells[
					Sample -> Object[Sample, "Fake cell sample 1 for ImageCells tests"<> $SessionUUID],
					SampleLabel -> "Test sample",
					SampleContainerLabel->"Test container"
				],
				Cover[
					Sample->"Test container"
				],
				IncubateCells[
					Sample->"Test container",
					Time->5Hour
				]
			}],
			ObjectP[Object[Protocol,ManualCellPreparation]]
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		setUpImageCellsTestObjects["ImageCells"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownImageCellsTestObjects["ImageCells"]
	)
];
