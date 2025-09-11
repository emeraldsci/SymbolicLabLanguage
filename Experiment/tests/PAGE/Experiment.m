(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[
	ExperimentPAGE,
	{
		(* Basic Examples *)
		Example[{Basic,"Accepts a sample object:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, PAGE]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts a container object:"},
			ExperimentPAGE[Object[Container,Vessel,"Container 1 for ExperimentPAGE tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, PAGE]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts a list of samples:"},
			ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]}],
			ObjectP[Object[Protocol, PAGE]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		(* Additional *)
		(* All of the InvalidInput and InvalidOption errors *)
		(* --- Messages that occur before the option resolver --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentPAGE[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentPAGE[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentPAGE[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentPAGE[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"DiscardedSamples","If the input samples are discarded, they cannot be used:"},
			ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"Discarded 40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]}],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"TooManyPAGEInputs","A maximum of 72 input samples can be run in one protocol:"},
			ExperimentPAGE[
				{
					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]
				},
				Gel->Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
				NumberOfReplicates->13
			],
			$Failed,
			Messages:>{
				Error::TooManyPAGEInputs,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidPAGEGelMaterial","If specified, the Gel option must have a GelMaterial of Polyacrylamide:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "Analytical 3.0% agarose cassette, 24 channel"]
			],
			$Failed,
			Messages:>{
				Error::InvalidPAGEGelMaterial,
				Error::InvalidPAGENumberOfLanes,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidNumberOfPAGEGels","If the Gel input is an Object, the number of input samples must be compatible with the number of Gels:"},
			ExperimentPAGE[
				{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				Gel->Object[Item,Gel,"24-channel 10% polyacrylamide TBE-Urea gel for ExperimentPAGE tests" <> $SessionUUID],
				NumberOfReplicates->10
			],
			$Failed,
			Messages:>{
				Error::InvalidNumberOfPAGEGels,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DuplicatePAGEGelObjects","If the Gel input is a list of Objects, each Gel Object in the list must be unique:"},
			ExperimentPAGE[
				{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				Gel->{
					Object[Item,Gel,"24-channel 10% polyacrylamide TBE-Urea gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"24-channel 10% polyacrylamide TBE-Urea gel for ExperimentPAGE tests" <> $SessionUUID]
				},
				NumberOfReplicates->10
			],
			$Failed,
			Messages:>{
				Error::DuplicatePAGEGelObjects,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingPAGESampleDenaturingOptions","The SampleDenaturing option cannot be in conflict with either the DenaturingTime or DenaturingTemperature options"},
			ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				SampleDenaturing->False,
				DenaturingTime->10*Minute
			],
			$Failed,
			Messages:>{
				Error::ConflictingPAGESampleDenaturingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidPAGENumberOfLanes","The specified Gel must have a NumberOfLanes of either 10 or 20:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Object[Item,Gel,"40-lane polyacrylamide gel for ExperimentPAGE tests" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::InvalidPAGENumberOfLanes,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NotEnoughVolumeToLoadPAGE","The sum of the SampleVolume and LoadingBufferVolume must be greater than or equal to the SampleLoadingVolume for each input sample:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleVolume->1*Microliter,LoadingBufferVolume->2*Microliter,SampleLoadingVolume->4.5*Microliter
			],
			$Failed,
			Messages:>{
				Error::NotEnoughVolumeToLoadPAGE,
				Error::NotEnoughLadderVolumeToLoadPAGE,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DuplicateName","If the Name option is specified, it cannot be identical to an existing Object[Protocol,PAGE] Name:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Name->"LegacyID:5"
			],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingPAGEDenaturingGelOptions","The DenaturingGel option must match the Denaturing field of the Gel option:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				DenaturingGel->False
			],
			$Failed,
			Messages:>{
				Error::ConflictingPAGEDenaturingGelOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingPAGESampleLoadingVolumeGelOptions","The SampleLoadingVolume cannot be larger than the MaxWellVolume of the Gel option:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				SampleLoadingVolume->7*Microliter
			],
			$Failed,
			Messages:>{
				Error::ConflictingPAGESampleLoadingVolumeGelOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingPAGEPostRunStainingSolutionOptions","The PostRunStaining option cannot be in conflict with the StainingSolution option:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				StainingSolution->Null
			],
			$Failed,
			Messages:>{
				Error::ConflictingPAGEPostRunStainingSolutionOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingPAGEPostRunRinsingSolutionOptions","The PostRunStaining option cannot be in conflict with the RinsingSolution option:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->False,
				RinsingSolution->Model[Sample, "Milli-Q water"]
			],
			$Failed,
			Messages:>{
				Error::ConflictingPAGEPostRunRinsingSolutionOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NotEnoughLadderVolumeToLoadPAGE","The sum of the LadderVolume and the LadderLoadingBufferVolume must be larger than the SampleLoadingVolume:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				LadderVolume->1*Microliter,
				LadderLoadingBufferVolume->2*Microliter,
				SampleLoadingVolume->4*Microliter
			],
			$Failed,
			Messages:>{
				Error::NotEnoughLadderVolumeToLoadPAGE,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingPAGELadderLoadingBufferOptions","The LadderLoadingBuffer and LadderLoadingBufferVolume options must both be specified or both be Null:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				LadderLoadingBuffer->Null,
				LadderLoadingBufferVolume->10*Microliter
			],
			$Failed,
			Messages:>{
				Error::ConflictingPAGELadderLoadingBufferOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MismatchedPAGEStainingOptions","The StainingSolution, StainVolume, and StainingTime options cannot be in conflict:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				StainingSolution->Model[Sample, StockSolution, "10X SYBR Gold in 1X TBE"],
				StainVolume->Null,
				StainingTime->Null
			],
			$Failed,
			Messages:>{
				Error::MismatchedPAGEStainingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MismatchedPAGEPrewashingOptions","The PrewashingSolution, PrewashVolume, and PrewashingTime options cannot be in conflict:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				PrewashingSolution->Model[Sample, "Milli-Q water"],
				PrewashVolume->Null,
				PrewashingTime->20*Minute
			],
			$Failed,
			Messages:>{
				Error::MismatchedPAGEPrewashingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MismatchedPAGERinsingOptions","The RinsingSolution, RinseVolume, RinsingTime, and NumberOfRinses options cannot be in conflict:"},
			ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				RinsingSolution->Model[Sample, "Milli-Q water"],
				RinseVolume->Null,
				RinsingTime->20*Minute,
				NumberOfRinses->3
			],
			$Failed,
			Messages:>{
				Error::MismatchedPAGERinsingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"TooMuchPAGEWasteVolume","A maximum of 400 mL of post-run staining waste can be generated in one experiemnt:"},
			ExperimentPAGE[
				{
					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]
				},
				PostRunStaining->True,
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				NumberOfReplicates->14,
				PrewashingSolution->Model[Sample, "Milli-Q water"],
				StainVolume->15*Milliliter,
				PrewashVolume->15*Milliliter,
				RinseVolume->15*Milliliter,
				NumberOfRinses->4
			],
			$Failed,
			Messages:>{
				Error::TooMuchPAGEWasteVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MoreThanOnePAGEGelModel","If the Gel option is supplied as a list of Objects, all must be of the same Model:"},
			ExperimentPAGE[
				Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->{
					Object[Item,Gel,"24-channel 10% polyacrylamide TBE-Urea gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"24-channel 10% polyacrylamide TBE gel for ExperimentPAGE tests" <> $SessionUUID]
				},
				NumberOfReplicates->20
			],
			$Failed,
			Messages :> {
				Error::MoreThanOnePAGEGelModel,
				Error::InvalidOption
			}
		],
		Example[{Options,SampleVolume,"Rounds specified SampleVolume to the nearest 0.1 Microliter:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleVolume->3.01*Micro*Liter,
				Output->Options
			];
			Lookup[options,SampleVolume],
			3.0*Microliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,DenaturingTime,"Rounds specified DenaturingTime to the nearest 1 minute:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleDenaturing->True,
				DenaturingTime->3.8*Minute,
				Output->Options
			];
			Lookup[options,DenaturingTime],
			4.0*Minute,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options,DenaturingTemperature,"Rounds specified DenaturingTemperature to the nearest 0.1 Celsius:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleDenaturing->True,
				DenaturingTemperature->84.33*Celsius,
				Output->Options
			];
			Lookup[options,DenaturingTemperature],
			84.3*Celsius,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {options}
		],
		Example[{Options,LadderVolume,"Rounds specified LadderVolume to the nearest 0.1 Microliter:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				LadderVolume->2.99*Microliter,
				Output->Options
			];
			Lookup[options,LadderVolume],
			3.0*Microliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LoadingBufferVolume,"Rounds specified LoadingBufferVolume to the nearest 0.1 Microliter:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				LoadingBufferVolume->39.99*Microliter,
				Output->Options
			];
			Lookup[options,LoadingBufferVolume],
			40.0*Microliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,LadderLoadingBufferVolume,"Rounds specified LadderLoadingBufferVolume to the nearest 0.1 Microliter:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				LadderLoadingBufferVolume->39.99*Microliter,
				Output->Options
			];
			Lookup[options,LadderLoadingBufferVolume],
			40.0*Microliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SampleLoadingVolume,"Rounds specified SampleLoadingVolume to the nearest 0.1 Microliter:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleLoadingVolume->4.48*Microliter,
				Output->Options
			];
			Lookup[options,SampleLoadingVolume],
			4.5*Microliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,SeparationTime,"Rounds specified SeparationTime to the nearest 1 Second:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SeparationTime->7200.1*Second,
				Output->Options
			];
			Lookup[options,SeparationTime],
			7200*Second,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,PrewashingTime,"Rounds specified PrewashingTime to the nearest 1 Minute:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PrewashingSolution->Model[Sample, "Milli-Q water"],
				PrewashingTime->7.8*Minute,
				Output->Options
			];
			Lookup[options,PrewashingTime],
			8.0*Minute,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,PrewashVolume,"Rounds specified PrewashVolume to the nearest 1 Milliliter:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PrewashingSolution->Model[Sample, "Milli-Q water"],
				PrewashVolume->14.6*Milliliter,
				Output->Options
			];
			Lookup[options,PrewashVolume],
			15.*Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,StainingTime,"Rounds specified StainingTime to the nearest 1 Minute:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				StainingTime->36.8*Minute,
				Output->Options
			];
			Lookup[options,StainingTime],
			37.0*Minute,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,StainVolume,"Rounds specified StainVolume to the nearest 1 Milliliter:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				StainVolume->14.6*Milliliter,
				Output->Options
			];
			Lookup[options,StainVolume],
			15.*Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,RinsingTime,"Rounds specified RinsingTime to the nearest 1 Minute:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				RinsingTime->36.8*Minute,
				Output->Options
			];
			Lookup[options,RinsingTime],
			37.0*Minute,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,RinseVolume,"Rounds specified RinseVolume to the nearest 1 Milliliter:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				RinseVolume->14.6*Milliliter,
				Output->Options
			];
			Lookup[options,RinseVolume],
			15.*Milliliter,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,Voltage,"Rounds specified Voltage to the nearest 1 Volt:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Voltage->50.1*Volt,
				Output->Options
			];
			Lookup[options,Voltage],
			50*Volt,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Options,DutyCycle,"Rounds specified DutyCycle to the nearest 1 Percent:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				DutyCycle->99.9*Percent,
				Output->Options
			];
			Lookup[options,DutyCycle],
			100*Percent,
			EquivalenceFunction->Equal,
			Variables :> {options},
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		(* --- Examples for various Options in the resolver --- *)
		(* - Options currently with defaults - *)
		Example[{Options,Gel,"When not specified, the Gel option is set to a 10& PA TBE gel:"},
			Lookup[
				ExperimentPAGE[
					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Output->Options
				],
				Gel
			],
			ObjectP[Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"]]
		],
		Example[{Options,LadderStorageCondition,"The LadderStorageCondition is used to specify how the Ladder is stored after it is used in the experiment:"},
			Lookup[
				ExperimentPAGE[
					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					LadderStorageCondition->AmbientStorage,
					Output->Options
				],
				LadderStorageCondition
			],
			AmbientStorage
		],
		(* Automatic Options *)
		Example[{Options,DenaturingGel,"The DenaturingGel option defaults to True if the Gel has Denaturing->True:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,DenaturingGel],
			True,
			Variables :> {options}
		],
		Example[{Options,DenaturingGel,"The DenaturingGel option defaults to False if the Gel has Denaturing->False:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,DenaturingGel],
			False,
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Model[Sample,StockSolution,Standard,\"GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL\"] if the Gel is a denaturing TBE gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,Ladder],
			Model[Sample,StockSolution,Standard,"GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL"],
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Model[Sample,StockSolution,Standard,\"GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL\"] if the Gel is a native TBE gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,Ladder],
			Model[Sample,StockSolution,Standard,"GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL"],
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Model[Sample,StockSolution,Standard,\"Precision Plus Unstained Protein Standards, 10-200 kDa\"] if the Gel is a denaturing Tris/Glycine/SDS gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,Ladder],
			Model[Sample,StockSolution,Standard,"Precision Plus Unstained Protein Standards, 10-200 kDa"],
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Model[Sample,StockSolution,Standard,\"NativeMark Unstained Protein Standards, 20-1236 kDa\"] if the Gel is a native Tris/Glycine gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,Ladder],
			Model[Sample,StockSolution,Standard,"NativeMark Unstained Protein Standards, 20-1236 kDa"],
			Variables :> {options}
		],
		Example[{Options,LoadingBuffer,"The LoadingBuffer option defaults to Model[Sample, \"PAGE SYBR Gold non-denaturing loading buffer, 25% Ficoll\"] if the Gel is a native TBE gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,LoadingBuffer],
			Model[Sample, "PAGE SYBR Gold non-denaturing loading buffer, 25% Ficoll"],
			Variables :> {options}
		],
		Example[{Options,LoadingBuffer,"The LoadingBuffer option defaults to Model[Sample, \"PAGE denaturing loading buffer, 22% Ficoll\"] if the gel is a denaturing TBE gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,LoadingBuffer],
			Model[Sample, "PAGE denaturing loading buffer, 22% Ficoll"],
			Variables :> {options}
		],
		Example[{Options,LoadingBuffer,"The LoadingBuffer option defaults to Model[Sample, \"Sample Buffer, Laemmli 2x Concentrate\"] if the gel is a denaturing Tris/Glycine/SDS gel::"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,LoadingBuffer],
			Model[Sample, "Sample Buffer, Laemmli 2x Concentrate"],
			Variables :> {options}
		],
		Example[{Options,LoadingBuffer,"The LoadingBuffer option defaults to Model[Sample, \"Native Sample Buffer for Protein Gels\"] if the Gel is a native Tris/Glycine gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,LoadingBuffer],
			Model[Sample, "Native Sample Buffer for Protein Gels"],
			Variables :> {options}
		],
		Example[{Options,ReservoirBuffer,"The ReservoirBuffer option defaults to Model[Sample, StockSolution, \"1x TBE Buffer\"] if the gel is a TBE gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,ReservoirBuffer],
			Model[Sample, StockSolution, "1x TBE Buffer"],
			Variables :> {options}
		],
		Example[{Options,ReservoirBuffer,"The ReservoirBuffer option defaults to Model[Sample,StockSolution,\"1x Tris-Glycine-SDS Buffer\"] if the gel is a denaturing Tris/Glycine/SDS gel::"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,ReservoirBuffer],
			Model[Sample,StockSolution,"1x Tris-Glycine-SDS Buffer"],
			Variables :> {options}
		],
		Example[{Options,ReservoirBuffer,"The ReservoirBuffer option defaults to Model[Sample,StockSolution,\"1x Tris-Glycine Buffer\"] if the Gel is a native Tris/Glycine gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,ReservoirBuffer],
			Model[Sample,StockSolution,"1x Tris-Glycine Buffer"],
			Variables :> {options}
		],
		Example[{Options,GelBuffer,"The GelBuffer option defaults to Model[Sample, StockSolution, \"1x TBE Buffer\"] if the Gel is a non-Denaturing TBE gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,GelBuffer],
			Model[Sample, StockSolution, "1x TBE Buffer"],
			Variables :> {options}
		],
		Example[{Options,GelBuffer,"The GelBuffer option defaults to Model[Sample, StockSolution, \"1X TBE buffer with 7M Urea\"] if the gel is a denaturing gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,GelBuffer],
			Model[Sample, StockSolution, "1X TBE buffer with 7M Urea"],
			Variables :> {options}
		],
		Example[{Options,PostRunStaining,"The PostRunStaining option defaults to True if any of the StainingSolution, StainingTime, or RinsingSolution are specified:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				StainingSolution->Model[Sample, StockSolution, "10X SYBR Gold in 1X TBE"],
				Output->Options
			];
			Lookup[options,PostRunStaining],
			True,
			Variables :> {options}
		],
		Example[{Options,PostRunStaining,"The PostRunStaining option defaults to True if any of the StainingSolution, StainingTime, or RinsingSolution are specified:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PrewashingSolution->Model[Sample, "Milli-Q water"],
				Output->Options
			];
			Lookup[options,PostRunStaining],
			True,
			Variables :> {options}
		],
		Example[{Options,PostRunStaining,"The PostRunStaining option defaults to True if any of the StainingSolution, StainingTime, or RinsingSolution are specified:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				RinsingSolution->Model[Sample, "Milli-Q water"],
				Output->Options
			];
			Lookup[options,PostRunStaining],
			True,
			Variables :> {options}
		],
		Example[{Options,PostRunStaining,"The PostRunStaining option defaults to True if none of the StainingSolution, PrewashingSolution, or RinsingSolution are specified, and the gel is a denaturing gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,PostRunStaining],
			True,
			Variables :> {options}
		],
		Example[{Options,PostRunStaining,"The PostRunStaining option defaults to False if none of the StainingSolution, StainingTime, or RinsingSolution are specified, and the gel is a non-denaturing TBE gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,PostRunStaining],
			False,
			Variables :> {options}
		],
		(* commenting this out since we don't offer 10-lane gels at the moment*)
		(*Example[{Options,SampleLoadingVolume,"The SampleLoadingVolume option defaults to 10.5 uL if the Gel has 10 lanes:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SampleLoadingVolume],
			10.5*Microliter,
			Variables :> {options}
		],*)
		Example[{Options,SampleLoadingVolume,"The SampleLoadingVolume option defaults to 5 uL if the Gel has 20 lanes:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SampleLoadingVolume],
			4*Microliter,
			Variables :> {options}
		],
		Example[{Options,PrewashingSolution,"When not specified, the PrewashingSolution option defaults to Null:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,PrewashingSolution],
			Null,
			Variables :> {options}
		],
		Example[{Options,PrewashVolume,"The PrewashVolume defaults to Null if the PrewashingSolution is Null:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PrewashingSolution->Null,
				Output->Options
			];
			Lookup[options,PrewashVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,PrewashVolume,"The PrewashVolume defaults to 12 mL if the PrewashingSolution is specified:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PrewashingSolution->Model[Sample, "Milli-Q water"],
				Output->Options
			];
			Lookup[options,PrewashVolume],
			12*Milliliter,
			Variables :> {options}
		],
		Example[{Options,PrewashingTime,"The PrewashingTime defaults to Null if the PrewashingSolution is Null:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PrewashingSolution->Null,
				Output->Options
			];
			Lookup[options,PrewashingTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,PrewashingTime,"The PrewashingTime defaults to 6 minutes if the PrewashingSolution is specified:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PrewashingSolution->Model[Sample, "Milli-Q water"],
				Output->Options
			];
			Lookup[options,PrewashingTime],
			6*Minute,
			Variables :> {options}
		],
		Example[{Options,StainingSolution,"The StainingSolution option defaults to Model[Sample, StockSolution, \"10X SYBR Gold in 1X TBE\"] if PostRunStaining is True and the Gel is a TBE gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,StainingSolution],
			Model[Sample, StockSolution, "10X SYBR Gold in 1X TBE"],
			Variables :> {options}
		],
		Example[{Options,StainingSolution,"The StainingSolution option defaults to Null if PostRunStaining is False:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				PostRunStaining->False,
				Output->Options
			];
			Lookup[options,StainingSolution],
			Null,
			Variables :> {options}
		],
		Example[{Options,StainingSolution,"The StainingSolution option defaults to Model[Sample,StockSolution,\"1x SYPRO Orange Protein Gel Stain in 7.5% acetic acid\"] if PostRunStaining is True and the Gel is a Tris/Glycine gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,StainingSolution],
			Model[Sample,StockSolution,"1x SYPRO Orange Protein Gel Stain in 7.5% acetic acid"],
			Variables :> {options}
		],
		Example[{Options,StainingTime,"The StainingTime option defaults to 36 minutes if PostRunStaining is True and the Gel is a TBE oligomer gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,StainingTime],
			36*Minute,
			Variables :> {options}
		],
		Example[{Options,StainingTime,"The StainingTime option defaults to 1 hour if PostRunStaining is True and the Gel is a Tris/Glyine protein gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,StainingTime],
			1*Hour,
			Variables :> {options}
		],
		Example[{Options,StainingTime,"The StainingTime option defaults to Null if PostRunStaining is False:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				PostRunStaining->False,
				Output->Options
			];
			Lookup[options,StainingTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,StainVolume,"The StainVolume defaults to Null if the StainingSolution is Null:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->False,
				StainingSolution->Null,
				Output->Options
			];
			Lookup[options,StainVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,StainVolume,"The StainVolume defaults to 12 mL if the StainingSolution is specified:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				StainingSolution->Model[Sample, StockSolution, "10X SYBR Gold in 1X TBE"],
				Output->Options
			];
			Lookup[options,StainVolume],
			12*Milliliter,
			Variables :> {options}
		],
		Example[{Options,RinsingSolution,"The RinsingSolution option defaults to Model[Sample, StockSolution, \"1x TBE Buffer\"] if PostRunStaining is True and the Gel is a TBE oligomer gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,RinsingSolution],
			Model[Sample, StockSolution, "1x TBE Buffer"],
			Variables :> {options}
		],
		Example[{Options,RinsingSolution,"The RinsingSolution option defaults to Model[Sample,StockSolution,\"7.5% acetic acid in water\"] if PostRunStaining is True and the Gel is a Tris/Glycine protein gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,RinsingSolution],
			Model[Sample,StockSolution,"7.5% acetic acid in water"],
			Variables :> {options}
		],
		Example[{Options,RinsingSolution,"The RinsingSolution option defaults to Null if PostRunStaining is False:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				PostRunStaining->False,
				Output->Options
			];
			Lookup[options,RinsingSolution],
			Null,
			Variables :> {options}
		],
		Example[{Options,RinseVolume,"The RinseVolume defaults to Null if the RinsingSolution is Null:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->False,
				RinsingSolution->Null,
				Output->Options
			];
			Lookup[options,RinseVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,RinseVolume,"The RinseVolume defaults to 12 mL if the RinsingSolution is specified:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				RinsingSolution->Model[Sample, StockSolution, "1x TBE Buffer"],
				Output->Options
			];
			Lookup[options,RinseVolume],
			12*Milliliter,
			Variables :> {options}
		],
		Example[{Options,RinsingTime,"The RinsingTime option defaults to 6 minutes if the RinsingSolution is specified:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->True,
				Output->Options
			];
			Lookup[options,RinsingTime],
			6*Minute,
			Variables :> {options}
		],
		Example[{Options,RinsingTime,"The RinsingTime option defaults to Null if the RinsingSolution is Null:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				PostRunStaining->False,
				RinsingSolution->Null,
				Output->Options
			];
			Lookup[options,RinsingTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,NumberOfRinses,"Specify NumberOfRinses:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				NumberOfRinses->4,
				Output->Options
			];
			Lookup[options,NumberOfRinses],
			4,
			EquivalenceFunction->Equal,
			Variables :> {options}
		],
		Example[{Options,LadderVolume,"The LadderVolume option defaults to the mean of the SampleVolume option:"},
			options=ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				SampleVolume->{4,5}*Microliter,
				Output->Options
			];
			Lookup[options,LadderVolume],
			4.5*Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleVolume,"The SampleVolume option defaults to 12 uL if the Gel is a native TBE oligomer gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SampleVolume],
			12*Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleVolume,"The SampleVolume option defaults to 3 uL if the gel is a denaturing TBE-Urea oligomer gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SampleVolume],
			3*Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleVolume,"The SampleVolume option defaults to 7.5 uL if the gel is a protein gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SampleVolume],
			7.5*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingBufferVolume,"The LoadingBufferVolume option defaults to 3 uL if the Gel is a native TBE oligomer gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,LoadingBufferVolume],
			3*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingBufferVolume,"The LoadingBufferVolume option defaults to 40 uL if the gel is a denaturing TBE-Urea oligomer gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,LoadingBufferVolume],
			40*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingBufferVolume,"The LoadingBufferVolume option defaults to 7.5 uL if the gel is a protein gel:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,LoadingBufferVolume],
			7.5*Microliter,
			Variables :> {options}
		],
		Example[{Options,LadderLoadingBuffer,"The LadderLoadingBuffer option defaults to the value of the LoadingBuffer:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				LoadingBuffer->Model[Sample, "PAGE denaturing loading buffer, 22% Ficoll"],
				Output->Options
			];
			Lookup[options,LadderLoadingBuffer],
			ObjectP[Model[Sample, "PAGE denaturing loading buffer, 22% Ficoll"]],
			Variables :> {options}
		],
		Example[{Options,LadderLoadingBuffer,"The LadderLoadingBuffer option defaults to Null if the LadderLoadingBufferVolume is Null:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				LadderLoadingBufferVolume->Null,
				LadderVolume->15*Microliter,
				Output->Options
			];
			Lookup[options,LadderLoadingBuffer],
			Null,
			Variables :> {options}
		],
		Example[{Options,LadderLoadingBufferVolume,"The LadderLoadingBufferVolume option defaults to the mean of the LoadingBufferVolume option if the LadderLoadingBuffer is not Null:"},
			options=ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				LoadingBufferVolume->{30,35}*Microliter,
				Output->Options
			];
			Lookup[options,LadderLoadingBufferVolume],
			32.5*Microliter,
			Variables :> {options}
		],
		Example[{Options,LadderLoadingBufferVolume,"The LadderLoadingBufferVolume option defaults to Null if the LadderLoadingBuffer is Null:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				LadderLoadingBuffer->Null,
				LadderVolume->15*Microliter,
				Output->Options
			];
			Lookup[options,LadderLoadingBufferVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,SampleDenaturing,"The SampleDenaturing option defaults to the True if the Gel is a denaturing Tris/Glycine/SDS protein gel:"},
			options=ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SampleDenaturing],
			True,
			Variables :> {options}
		],
		Example[{Options,SampleDenaturing,"The SampleDenaturing option defaults to the False if the Gel is not a denaturing Tris/Glycine/SDS protein gel:"},
			options=ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SampleDenaturing],
			False,
			Variables :> {options}
		],
		Example[{Options,SeparationTime,"The SeparationTime option defaults to the 2 hours if the Gel is an Oligomer TBE gel:"},
			options=ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				Gel->Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SeparationTime],
			2*Hour,
			Variables :> {options}
		],
		Example[{Options,SeparationTime,"The SeparationTime option defaults to the 133 minutes if the Gel is not an Oligomer TBE gel:"},
			options=ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				Gel->Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
				Output->Options
			];
			Lookup[options,SeparationTime],
			133*Minute,
			Variables :> {options}
		],
		Example[{Options,DenaturingTime,"The DenaturingTime option defaults to Null if SampleDenaturing is False:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleDenaturing->False,
				Output->Options
			];
			Lookup[options,DenaturingTime],
			Null,
			Variables :> {options}
		],
		Example[{Options,DenaturingTime,"The DenaturingTime option defaults to 5 minutes if SampleDenaturing is True:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleDenaturing->True,
				Output->Options
			];
			Lookup[options,DenaturingTime],
			5*Minute,
			Variables :> {options}
		],
		Example[{Options,DenaturingTemperature,"The DenaturingTemperature option defaults to Null if SampleDenaturing is False:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleDenaturing->False,
				Output->Options
			];
			Lookup[options,DenaturingTemperature],
			Null,
			Variables :> {options}
		],
		Example[{Options,DenaturingTemperature,"The DenaturingTemperature option defaults to 95 Celsius if SampleDenaturing is True:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SampleDenaturing->True,
				Output->Options
			];
			Lookup[options,DenaturingTemperature],
			95*Celsius,
			Variables :> {options}
		],
		Example[{Options,FilterSet,"The FilterSet option is used to indicate which set of excitation and emission filters is used to generate the gel images for the experiment:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				FilterSet->BlueFluorescence,
				Output->Options
			];
			Lookup[options,FilterSet],
			BlueFluorescence,
			Variables :> {options}
		],
		Example[{Options, Instrument, "The instrument used to perform the PAGE:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Instrument -> Object[Instrument, Electrophoresis, "id:qdkmxzqlmn7V"],
				Output -> Options
			];
			Lookup[options, Instrument],
			ObjectP[Object[Instrument, Electrophoresis, "id:qdkmxzqlmn7V"]],
			Variables :> {options}
		],



		Example[{Options,NumberOfReplicates,"The product of the NumberOfReplicates and the number of input samples cannot be greater than the (NumberOfLanes in the Gel minus 2) times 4:"},
			ExperimentPAGE[{Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID]},
				NumberOfReplicates->56,
				SampleVolume->3*Microliter
			],
			$Failed,
			Messages:>{
				Error::TooManyPAGEInputs,
				Error::InvalidInput
			}
		],
		(* This isnt a great test.   make a fake protocol in the symbol setup with some unique option value we can test *)
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			Lookup[ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Template->Object[Protocol,PAGE,"Test Option Template protocol for ExperimentPAGE" <> $SessionUUID],
				Output->Options],
				SampleLoadingVolume
			],
			4.2*Microliter,
			EquivalenceFunction->Equal
		],
		Example[{Options,Name,"Name the protocol for PAGE:"},
			Lookup[ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Output->Options,
				Name->"Super cool test protocol"],
				Name
			],
			"Super cool test protocol"
		],
		Example[{Options,Confirm,"If Confirm -> True, Skip InCart and go directly to Processing:"},
			Download[ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],Confirm->True],Status],
			Processing|ShippingMaterials|Backlogged,
			TimeConstraint->240,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,CanaryBranch,"Specify the CanaryBranch on which the protocol is run:"},
			Download[ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],CanaryBranch->"d1cacc5a-948b-4843-aa46-97406bbfc368"],CanaryBranch],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			TimeConstraint->240,
			Stubs:>{GitBranchExistsQ[___] = True, InternalUpload`Private`sllDistroExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
	(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESNT BUG ON THIS. *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				Incubate->True,
				Centrifuge->True,
				Filtration->True,
				Aliquot->True,
				Output -> Options
			];
			{Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
			{True,True,True,True},
			Variables :> {options},
			TimeConstraint->240
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentPAGE[
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
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentPAGE[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, PAGE]]
		],
		(* PreparatoryUnitOperations Option *)
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for ExperimentPAGE:"},
			options=ExperimentPAGE["Container 1",
				PreparatoryUnitOperations-> {
					LabelContainer[
						Label->"Container 1",
						Container->Model[Container,Plate,"96-well PCR Plate"]
					],
					Transfer[
						Source->Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
						Amount->30*Microliter,
						Destination->{"A1","Container 1"}
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Amount->30*Microliter,
						Destination->{"A2","Container 1"}
					]
				},
				Output->Options
			];
			Lookup[options,LoadingBufferVolume],
			40*Microliter,
			Variables :> {options}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Incubate -> True,
				Output -> Options
			];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				IncubationTemperature -> 40*Celsius,
				Output -> Options
			];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				IncubationTime -> 40*Minute,
				Output -> Options
			];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				MaxIncubationTime -> 40*Minute,
				Output -> Options
			];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				IncubationInstrument -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
				Output -> Options
			];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				AnnealingTime -> 40*Minute,
				Output -> Options];
			Lookup[options, AnnealingTime
			],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				IncubateAliquot -> 0.05*Milliliter,
				Output -> Options
			];
			Lookup[options, IncubateAliquot],
			0.05*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Mix -> True,
				Output -> Options
			];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				MixType -> Shake,
				Output -> Options
			];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				MixUntilDissolved -> True,
				Output -> Options
			];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

	(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Centrifuge -> True,
				Output -> Options
			];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options},
			TimeConstraint->240
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"],
				Output -> Options
			];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options},
			TimeConstraint->240
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				CentrifugeIntensity -> 1000*RPM,
				Output -> Options
			];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint->240
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				CentrifugeTime -> 5*Minute,
				Output -> Options
			];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint->240
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				CentrifugeTemperature -> 10*Celsius,
				CentrifugeAliquotContainer->Model[Container, Vessel, "50mL Tube"],
				AliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint->240
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				CentrifugeAliquot -> 0.05*Milliliter,
				Output -> Options
			];
			Lookup[options, CentrifugeAliquot],
			0.05*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint->240
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				CentrifugeAliquotContainer -> Model[Container, Plate, "id:01G6nvkKrrYm"],
				Output -> Options
			];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "id:01G6nvkKrrYm"]]},
			Variables :> {options},
			TimeConstraint->240
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				Filtration -> True,
				Output -> Options
			];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FiltrationType -> Syringe,
				Output -> Options
			];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
				Output -> Options
			];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],
				Output -> Options
			];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options},
			TimeConstraint->300
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FilterMaterial -> PES,
				Output -> Options
			];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				PrefilterMaterial -> GxF,
				FilterMaterial->PTFE,
				Output -> Options
			];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FilterPoreSize -> 0.22*Micrometer,
				Output -> Options
			];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				PrefilterPoreSize -> 1.*Micrometer,
				FilterMaterial -> PTFE,
				Output -> Options
			];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				FiltrationType -> Syringe,
				FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output -> Options];
			Lookup[options, FilterSyringe
			],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FiltrationType -> PeristalticPump,
				FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"],
				Output -> Options
			];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterIntensity -> 1000*RPM,
				Output -> Options
			];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterTime -> 20*Minute,
				Output -> Options
			];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterTemperature -> 22*Celsius,
				Output -> Options
			];
			Lookup[options, FilterTemperature],
			22*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{
				Warning::AliquotRequired
			}
		],(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FilterSterile -> True,
				Output -> Options
			];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FilterAliquot -> 0.05*Milliliter,
				Output -> Options
			];
			Lookup[options, FilterAliquot],
			0.05*Milliliter,
			EquivalenceFunction -> Equal
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentPAGE[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
				FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			TimeConstraint->240,
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				FilterContainerOut -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
	(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Aliquot -> True,
				Output -> Options
			];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				AliquotAmount -> 0.05*Milliliter,
				Output -> Options
			];
			Lookup[options, AliquotAmount],
			0.05*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				AssayVolume -> 0.05*Milliliter,
				Output -> Options
			];
			Lookup[options, AssayVolume],
			0.05*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				TargetConcentration -> 1*Micromolar,
				AssayVolume->20*Microliter,
				Output -> Options
			];
			Lookup[options, TargetConcentration],
			1*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID], TargetConcentration -> 1*Micromolar,TargetConcentrationAnalyte->Model[Molecule, Oligomer, "40mer DNA Model Molecule for ExperimentPAGE tests" <> $SessionUUID],AssayVolume->20*Microliter,Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
		ObjectP[Model[Molecule, Oligomer, "40mer DNA Model Molecule for ExperimentPAGE tests" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount->15*Microliter,
				AssayVolume->30*Microliter,
				Output -> Options
			];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount->15*Microliter,
				AssayVolume->30*Microliter,
				Output -> Options
			];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount->15*Microliter,
				AssayVolume->30*Microliter,
				AliquotContainer -> Model[Container, Plate, "id:01G6nvkKrrYm"],
				Output -> Options
			];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AliquotAmount->15*Microliter,
				AssayVolume->30*Microliter,
				Output -> Options
			];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				AliquotSampleStorageCondition -> Refrigerator,
				Output -> Options
			];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				ConsolidateAliquots -> True,
				Output -> Options
			];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				Aliquot -> True,
				AliquotPreparation -> Manual,
				Output -> Options
			];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				AliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				ImageSample -> False,
				Output -> Options
			];
			Lookup[options, ImageSample],
			False,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				MeasureVolume -> True,
				Output -> Options
			];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				MeasureWeight -> False,
				Output -> Options
			];
			Lookup[options, MeasureWeight],
			False,
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				SamplesInStorageCondition -> Refrigerator,
				Output -> Options
			];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				IncubateAliquotDestinationWell -> "A1",
				Output -> Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				CentrifugeAliquotDestinationWell -> "A1",
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				FilterAliquotDestinationWell -> "A1",
				Output -> Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentPAGE[Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
				DestinationWell -> "A1",
				Aliquot->True,
				Output -> Options
			];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables :> {options}
		]
	(* --- Examples for the messages that are thrown after the MapThread --- *)
	},
	Parallel -> True,
	(* Turn off the SamplesOutOfStock warning for unit tests *)
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance},

	SymbolSetUp:>(

		Module[{objects,existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ExperimentPAGE tests" <> $SessionUUID],

					Model[Item,Gel,"40-lane polyacrylamide gel for ExperimentPAGE tests" <> $SessionUUID],

					Object[Container,Vessel,"Container 1 for ExperimentPAGE tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 2 for ExperimentPAGE tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 3 for ExperimentPAGE tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 4 for ExperimentPAGE tests" <> $SessionUUID],

					Object[Item,Gel,"24-channel 10% polyacrylamide TBE-Urea gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"40-lane polyacrylamide gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"24-channel 12% polyacrylamide Tris/Glycine/SDS gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"24-channel 12% polyacrylamide Tris/Glycine gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"24-channel 10% polyacrylamide TBE gel for ExperimentPAGE tests" <> $SessionUUID],

					Object[Instrument, Electrophoresis, "Test Ranger Electrophoresis Instrument for ExperimentPAGE Tests" <> $SessionUUID],

					Model[Molecule,Oligomer,"40mer DNA Model Molecule for ExperimentPAGE tests" <> $SessionUUID],

					Model[Sample,"40mer DNA oligomer sample model for ExperimentPAGE tests" <> $SessionUUID],

					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"Discarded 40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"Non-denaturing loading buffer for ExperimentPAGETests" <> $SessionUUID],

					Object[Protocol,PAGE,"Test Option Template protocol for ExperimentPAGE" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];

		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					fakeBench,

					gelModel1,

					container1,container2,container3,container4,

					gel1,gel2,gel3,gel4,gel5,

					sampleModel,

					sample1,sample2,sample3,sample4
				},

				fakeBench = Upload[<|Type -> Object[Container, Bench], Site -> Link[$Site], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Bench for ExperimentPAGE tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];


				(* Upload a fake gel Model that has 40 lanes *)
				gelModel1=Upload[
					<|
						Type->Model[Item,Gel],
						Name->"40-lane polyacrylamide gel for ExperimentPAGE tests" <> $SessionUUID,
						GelMaterial->Polyacrylamide,
						NumberOfLanes->40,
						MaxWellVolume->15*Microliter,
						Rig->Robotic,
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]]
					|>
				];


				(* Upload test Containers and fake instrument *)
				{
					container1,container2,container3,container4,
					gel1,gel2,gel3,gel4,gel5
				}=UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Item, Gel, "10% polyacrylamide TBE-Urea cassette, 20 channel"],
						Model[Item, Gel, "40-lane polyacrylamide gel for ExperimentPAGE tests" <> $SessionUUID],
						Model[Item,Gel,"12% polyacrylamide Tris-Glycine-SDS cassette, 20 channel"],
						Model[Item,Gel,"12% polyacrylamide Tris-Glycine cassette, 20 channel"],
						Model[Item, Gel, "10% polyacrylamide TBE cassette, 20 channel"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> Available,
					Name->{
						"Container 1 for ExperimentPAGE tests" <> $SessionUUID,
						"Container 2 for ExperimentPAGE tests" <> $SessionUUID,
						"Container 3 for ExperimentPAGE tests" <> $SessionUUID,
						"Container 4 for ExperimentPAGE tests" <> $SessionUUID,
						"24-channel 10% polyacrylamide TBE-Urea gel for ExperimentPAGE tests" <> $SessionUUID,
						"40-lane polyacrylamide gel for ExperimentPAGE tests" <> $SessionUUID,
						"24-channel 12% polyacrylamide Tris/Glycine/SDS gel for ExperimentPAGE tests" <> $SessionUUID,
						"24-channel 12% polyacrylamide Tris/Glycine gel for ExperimentPAGE tests" <> $SessionUUID,
						"24-channel 10% polyacrylamide TBE gel for ExperimentPAGE tests" <> $SessionUUID
					}
				];

				(* Create Oligomer Molecule ID Models for the test samples' Composition field - also a fake instrument *)
				Upload[
					{
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 10]]]],
							PolymerType-> DNA,
							Name-> "40mer DNA Model Molecule for ExperimentPAGE tests" <> $SessionUUID,
							MolecularWeight->12295.9*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Object[Instrument,Electrophoresis],
							Model->Link[Model[Instrument, Electrophoresis, "Ranger"],Objects],
							Name->"Test Ranger Electrophoresis Instrument for ExperimentPAGE Tests" <> $SessionUUID,
							DeveloperObject->True,
							Site -> Link[$Site]
						|>
					}
				];

			sampleModel=UploadSampleModel[
				{"40mer DNA oligomer sample model for ExperimentPAGE tests" <> $SessionUUID},
				Composition -> {{
					{20*Micromolar,Model[Molecule, Oligomer,"40mer DNA Model Molecule for ExperimentPAGE tests" <> $SessionUUID]}
				}},
				DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				Expires -> False,
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				MSDSRequired -> False,
				IncompatibleMaterials -> {None}
			];

				(* Upload test sample objects *)
				{
					sample1,sample2,sample3
				}=UploadSample[
					{
						Model[Sample,"40mer DNA oligomer sample model for ExperimentPAGE tests" <> $SessionUUID],
						Model[Sample,"40mer DNA oligomer sample model for ExperimentPAGE tests" <> $SessionUUID],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3}
					},
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> {
						1 * Milliliter,
						1 * Milliliter,
						25 * Milliliter
					},
					Name->{
						"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID,
						"Discarded 40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID,
						"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID
					}
				];

				(* Upload some samples from Model *)
				{
					sample4
				}=UploadSample[
					{
						Model[Sample, "PAGE SYBR Gold non-denaturing loading buffer, 25% Ficoll"]
					},
					{
						{"A1", container4}
					},
					Status->Available,
					InitialAmount->{
						1*Milliliter
					},
					Name->{
						"Non-denaturing loading buffer for ExperimentPAGETests" <> $SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,container3,sample1,sample2,sample3}], ObjectP[]]];
				Upload[<|Object -> sampleModel, DeveloperObject -> True|>];

				Upload[Cases[Flatten[{
					<|
						Object -> Object[Sample,"Discarded 40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
						Status -> Discarded,
						Site -> Link[$Site]
					|>
				}], PacketP[]]];

				Upload[
					<|
						Type -> Object[Protocol,PAGE],
						Name->"Test Option Template protocol for ExperimentPAGE" <> $SessionUUID,
						DeveloperObject -> True,
						ResolvedOptions->{SampleLoadingVolume->4.2*Microliter}
					|>
				];
			]
		]
	),
	SymbolTearDown:>(
		Module[{objects,existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ExperimentPAGE tests" <> $SessionUUID],

					Model[Item,Gel,"40-lane polyacrylamide gel for ExperimentPAGE tests" <> $SessionUUID],

					Object[Container,Vessel,"Container 1 for ExperimentPAGE tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 2 for ExperimentPAGE tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 3 for ExperimentPAGE tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 4 for ExperimentPAGE tests" <> $SessionUUID],

					Object[Item,Gel,"24-channel 10% polyacrylamide TBE-Urea gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"40-lane polyacrylamide gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"24-channel 12% polyacrylamide Tris/Glycine/SDS gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"24-channel 12% polyacrylamide Tris/Glycine gel for ExperimentPAGE tests" <> $SessionUUID],
					Object[Item,Gel,"24-channel 10% polyacrylamide TBE gel for ExperimentPAGE tests" <> $SessionUUID],

					Object[Instrument, Electrophoresis, "Test Ranger Electrophoresis Instrument for ExperimentPAGE Tests" <> $SessionUUID],

					Model[Molecule,Oligomer,"40mer DNA Model Molecule for ExperimentPAGE tests" <> $SessionUUID],

					Model[Sample,"40mer DNA oligomer sample model for ExperimentPAGE tests" <> $SessionUUID],

					Object[Sample,"40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"Discarded 40mer DNA oligomer for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"25 mL water sample in 50mL Tube for ExperimentPAGE tests" <> $SessionUUID],
					Object[Sample,"Non-denaturing loading buffer for ExperimentPAGETests" <> $SessionUUID],

					Object[Protocol,PAGE,"Test Option Template protocol for ExperimentPAGE" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	),
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User,"Test user for notebook-less test protocols"]
	}
];