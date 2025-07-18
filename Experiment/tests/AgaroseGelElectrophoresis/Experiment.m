(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentAgaroseGelElectrophoresis*)


DefineTests[ExperimentAgaroseGelElectrophoresis,
	{
		(* -- Basic Examples -- *)
		Example[{Basic,"Accepts a sample object:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]],
			ObjectP[Object[Protocol,AgaroseGelElectrophoresis]],
			SetUp:>(
				$CreatedObjects={};
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				On[Warning::SamplesOutOfStock];
				On[Warning::InstrumentUndergoingMaintenance];
			)
		],
		Example[{Basic,"Accepts a non-empty container object:"},
			ExperimentAgaroseGelElectrophoresis[Object[Container,Vessel,"Container 1 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]],
			ObjectP[Object[Protocol,AgaroseGelElectrophoresis]],
			SetUp:>(
				$CreatedObjects={};
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				On[Warning::SamplesOutOfStock];
				On[Warning::InstrumentUndergoingMaintenance];
			)
		],
		Example[{Basic,"Accepts a mixture of sample objects and non-empty container objects:"},
			ExperimentAgaroseGelElectrophoresis[
				{Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Object[Container,Vessel,"Container 3 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]},
				CollectionSize->1600*BasePair
			],
			ObjectP[Object[Protocol,AgaroseGelElectrophoresis]],
			SetUp:>(
				$CreatedObjects={};
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				On[Warning::SamplesOutOfStock];
				On[Warning::InstrumentUndergoingMaintenance];
			)
		],

		(* -- Additional -- *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True,Output->Options];
			{Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
			{True,True,True,True},
			Variables :> {options},
			TimeConstraint->240
		],

		(* -- Message tests -- *)
		(* Error Messages before option resolution *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentAgaroseGelElectrophoresis[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentAgaroseGelElectrophoresis[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentAgaroseGelElectrophoresis[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages :> {Error::UnableToDetermineAgarosePeakDetectionRange,Error::InvalidOption}
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

				ExperimentAgaroseGelElectrophoresis[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages :> {Error::UnableToDetermineAgarosePeakDetectionRange,Error::InvalidOption}
		],
		Example[{Messages,"DiscardedSamples","If the provided sample is discarded, an error will be thrown:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"Discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"TooManyAgaroseInputs","A maximum of 48 samples can be run if Scale is Preparative. If Scale is Analytical, the maximum is 92 samples:"},
			ExperimentAgaroseGelElectrophoresis[Table[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],49]],
			$Failed,
			Messages :> {
				Error::TooManyAgaroseInputs,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidAgaroseLoadingDye","Any specified LoadingDye must be a member of AgaroseLoadingDyeP:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDye->{Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Model[Sample,"500 bp dyed loading buffer for agarose gel electrophoresis"]}
			],
			$Failed,
			Messages :> {
				Error::InvalidAgaroseLoadingDye,
				Error::InvalidOption
			}
		],
		(* Error Messages after option resolution *)
		Example[{Messages,"TooManyAgaroseLoadingDyes","A maximum of two LoadingDyes can be specified for each input sample:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDye->{Model[Sample, "200 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample, "500 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample, "2000 bp dyed loading buffer for agarose gel electrophoresis"]}
			],
			$Failed,
			Messages :> {
				Error::TooManyAgaroseLoadingDyes,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AgaroseLoadingDyeRangeCollectionOptionMismatch","Most accurate sizing is achieved when the collection-related Option (PeakDetectionRange, CollecitonSize, or CollectionRange) are within the range of Oligomers present in the LoadingDyes:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDye->{Model[Sample, "1000 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample, "5000 bp dyed loading buffer for agarose gel electrophoresis"]},
				PeakDetectionRange->500*BasePair;;800*BasePair
			],
			ObjectP[Object[Protocol,AgaroseGelElectrophoresis]],
			SetUp:>(
				$CreatedObjects={};
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				On[Warning::SamplesOutOfStock];
				On[Warning::InstrumentUndergoingMaintenance];
			),
			Messages :> {
				Warning::AgaroseLoadingDyeRangeCollectionOptionMismatch
			}
		],
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs contain temporal links:"},
			ExperimentAgaroseGelElectrophoresis[Link[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Now],
				LoadingDye->{Model[Sample, "1000 bp dyed loading buffer for agarose gel electrophoresis"],Model[Sample, "5000 bp dyed loading buffer for agarose gel electrophoresis"]}
			],
			ObjectP[Object[Protocol,AgaroseGelElectrophoresis]],
			SetUp:>(
				$CreatedObjects={};
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				On[Warning::SamplesOutOfStock];
				On[Warning::InstrumentUndergoingMaintenance];
			),
			Messages :> {
				Warning::InputContainsTemporalLinks
			}
		],
		Example[{Messages,"OnlyOneAgaroseLoadingDye","Most accurate sizing is achieved when there are two LoadingDyes specified for each input sample:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDye->{Model[Sample, "200 bp dyed loading buffer for agarose gel electrophoresis"]}
			],
			ObjectP[Object[Protocol,AgaroseGelElectrophoresis]],
			SetUp:>(
				$CreatedObjects={};
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				On[Warning::SamplesOutOfStock];
				On[Warning::InstrumentUndergoingMaintenance];
			),
			Messages :> {
				Warning::OnlyOneAgaroseLoadingDye
			}
		],
		Example[{Messages,"NotEnoughAgaroseSampleToLoad","The sum of the SampleVolume, the LoadingDyeVolume times the number of LoadingDyes, and LoadingDilutionBufferVolume must be greater than or equal to the SampleLoadingVolume for each input sample:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				SampleVolume->5*Microliter,LoadingDyeVolume->2*Microliter,LoadingDilutionBufferVolume->20*Microliter,SampleLoadingVolume->50*Microliter
			],
			$Failed,
			Messages :> {
				Error::NotEnoughAgaroseSampleToLoad,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgaroseCollectionSizeScaleOptions","The Scale and CollectionSize options must not be in conflict:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,CollectionSize->1600*BasePair
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgaroseCollectionSizeScaleOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnableToDetermineAgaroseCollectionSize","The Components field of the input sample must contain an Oligomer with a Strand or Structure in order to determine the CollectionSize option:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False
			],
			$Failed,
			Messages :> {
				Error::UnableToDetermineAgaroseCollectionSize,
				Error::UnableToDetermineAgaroseCollectionRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgaroseCollectionSizeAndRangeOptions","If the CollectionSize option is specified as a non-Null value, the CollectionRange option must be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,CollectionSize->1500*BasePair,CollectionRange->1300*BasePair;;1600*BasePair
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgaroseCollectionSizeAndRangeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnableToDetermineAgarosePeakDetectionRange","The Components field of the input sample must contain an Oligomer with a Strand or Structure in order to determine the PeakDetectionRange option:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->True
			],
			$Failed,
			Messages :> {
				Error::UnableToDetermineAgarosePeakDetectionRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnableToDetermineAgaroseCollectionRange","The Components field of the input sample must contain a Structure in order to determine the CollectionRange option:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,CollectionSize->Null
			],
			$Failed,
			Messages :> {
				Error::UnableToDetermineAgaroseCollectionRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AgaroseSampleLoadingVolumeScaleMismatch","The SampleLoadingVolume must be at most 8 uL if the Scale is Analytical:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,SampleLoadingVolume->20*Microliter
			],
			$Failed,
			Messages :> {
				Error::AgaroseSampleLoadingVolumeScaleMismatch,
				Error::NotEnoughAgaroseSampleToLoad,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AgaroseLoadingDilutionBufferMismatch","If the LoadingDilutionBuffer option is set to an Object, the LoadingDilutionBufferVolume cannot be 0 uL. Conversely, if the LoadingDilutionBufferVolume is 0 uL, the LoadingDilutionBuffer option must be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDilutionBuffer->Null,LoadingDilutionBufferVolume->20*Microliter
			],
			$Failed,
			Messages :> {
				Error::AgaroseLoadingDilutionBufferMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AgaroseExtractionVolumeScaleMismatch","The Scale and ExtractionVolume options must not be in conflict:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,ExtractionVolume->50*Microliter
			],
			$Failed,
			Messages :> {
				Error::AgaroseExtractionVolumeScaleMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AgaroseGelOptionsMismatch","If specified, the Gel must be Agarose and be compatible with the AgarosePercentage and Scale options:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative, Gel->Model[Item, Gel, "Analytical 1.0% agarose cassette, 24 channel"]
			],
			$Failed,
			Messages :> {
				Error::AgaroseGelOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidAgaroseLadder","The Ladder must be Null if the Scale is Preparative, or the Ladder must not be Null if the Scale is Analytical:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical, Ladder->Null
			],
			$Failed,
			Messages :> {
				Error::InvalidAgaroseLadder,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidAgaroseLadderFrequency","The LadderFrequency must be Null if the Scale is Preparative, or the Ladder must not be Null if the Scale is Analytical:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical, LadderFrequency->Null
			],
			$Failed,
			Messages :> {
				Error::InvalidAgaroseLadderFrequency,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgaroseAutomaticPeakDetectionScaleOptions","If the Scale is Analytical, the AutomaticPeakDetection option must be Null. If the Scale is Preparative, the AutomaticPeakDetection option must be True or False:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AutomaticPeakDetection->True
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgaroseAutomaticPeakDetectionScaleOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgaroseAutomaticPeakDetectionRangeOptions","If the AutomaticPeakDetection option is True, the PeakDetectionRange option must not be Null. If the AutomaticPeakDetection is False, the PeakDetectionRange option must be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->True,PeakDetectionRange->Null
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgaroseAutomaticPeakDetectionRangeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgaroseAutomaticPeakDetectionCollectionRangeOptions","If the AutomaticPeakDetection option is True, the CollectionRange option must be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->True,CollectionRange->1000*BasePair;;1300*BasePair
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgaroseAutomaticPeakDetectionCollectionRangeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgaroseAutomaticPeakDetectionCollectionSizeOptions","If the AutomaticPeakDetection option is True, the CollectionSize option must be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->True,CollectionSize->2000*BasePair
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgaroseAutomaticPeakDetectionCollectionSizeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgarosePeakDetectionRangeScaleOptions","If the Scale is Analytical, the PeakDetectionRange option must be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,PeakDetectionRange->1000*BasePair;;1500*BasePair
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgarosePeakDetectionRangeScaleOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgarosePeakDetectionRangeCollectionRangeOptions","If the PeakDetectionRange option is specified, the CollectionRange option must be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				PeakDetectionRange->1000*BasePair;;1500*BasePair,CollectionRange->1200*BasePair;;1400*BasePair
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgarosePeakDetectionRangeCollectionRangeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingAgaroseCollectionRangeScaleOptions","If the Scale is Analytical, the CollectionRange option must be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,CollectionRange->1200*BasePair;;1400*BasePair
			],
			$Failed,
			Messages :> {
				Error::ConflictingAgaroseCollectionRangeScaleOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AgaroseCollectionSizeAndRangeBothNull","If the AutomaticPeakDetection option is False, either the CollectionSize or CollecitonRange option must not be Null:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,CollectionSize->Null,CollectionRange->Null
			],
			$Failed,
			Messages :> {
				Error::AgaroseCollectionSizeAndRangeBothNull,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidAgaroseCollectionRange","The CollectionRange option cannot be specified as a Span with the same value listed as the start and the end of the range:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				CollectionRange->1600*BasePair;;1600*BasePair
			],
			$Failed,
			Messages :> {
				Error::InvalidAgaroseCollectionRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidAgarosePeakDetectionRange","The PeakDetectionRange option cannot be specified as a Span with the same value listed as the start and the end of the range:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				PeakDetectionRange->1600*BasePair;;1600*BasePair
			],
			$Failed,
			Messages :> {
				Error::InvalidAgarosePeakDetectionRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MoreThanOneAgaroseGelModel","If the Gel option is supplied as a list of Objects, all must be of the same Model:"},
			ExperimentAgaroseGelElectrophoresis[
				Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Gel->{
					Object[Item,Gel,"Preparative 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 1.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]
				},
				NumberOfReplicates->20
			],
			$Failed,
			Messages :> {
				Error::MoreThanOneAgaroseGelModel,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidNumberOfAgaroseGels","If the Gel input is an Object or list of Objects, the number of input samples must be compatible with the number of Gels:"},
			ExperimentAgaroseGelElectrophoresis[
				{Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]},
				Gel->Object[Item,Gel,"Preparative 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				NumberOfReplicates->15
			],
			$Failed,
			Messages:>{
				Error::InvalidNumberOfAgaroseGels,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DuplicateAgaroseGelObjects","If the Gel input is a list of Objects, each Gel Object in the list must be unique:"},
			ExperimentAgaroseGelElectrophoresis[
				{Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]},
				Gel->{
					Object[Item,Gel,"Preparative 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]
				},
				NumberOfReplicates->8
			],
			$Failed,
			Messages:>{
				Error::DuplicateAgaroseGelObjects,
				Error::InvalidOption
			}
		],
		Example[{Messages,"OverwriteLadderStorageCondition","LadderStorageCondition is overwritten and set to Null if a Ladder is not used in an experiment:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,LadderStorageCondition->AmbientStorage
			],
			ObjectP[Object[Protocol,AgaroseGelElectrophoresis]],
			SetUp:>(
				$CreatedObjects={};
				Off[Warning::SamplesOutOfStock];
				Off[Warning::InstrumentUndergoingMaintenance];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				On[Warning::SamplesOutOfStock];
				On[Warning::InstrumentUndergoingMaintenance];
			),
			Messages :> {
				Warning::OverwriteLadderStorageCondition
			}
		],
		Example[{Messages,"SharedContainerStorageCondition","The specified SamplesInStorageCondition is fullfillable for samples sharing the same container:"},
			ExperimentAgaroseGelElectrophoresis[{Object[Sample,"Test 1600mer DNA oligomer 1 for plate storage condition tests" <> $SessionUUID],Object[Sample,"Test 1600mer DNA oligomer 2 for plate storage condition tests" <> $SessionUUID]},
				SamplesInStorageCondition->{AmbientStorage,Refrigerator}],
			$Failed,
			Messages:>{
				Error::SharedContainerStorageCondition,
				Error::InvalidOption
			}
		],

		(* - Option Unit Tests - *)
		(* Option Precision Tests *)
		Example[{Options,SampleVolume,"Rounds specified SampleVolume to the nearest 0.1 uL:"},
			roundedSampleVolumeOptions=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				SampleVolume->35.97*Microliter,Output->Options];
			Lookup[roundedSampleVolumeOptions,SampleVolume],
			36*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {roundedSampleVolumeOptions}
		],
		Example[{Options,LoadingDyeVolume,"Rounds specified LoadingDyeVolume to the nearest 0.1 uL:"},
			roundedLoadingDyeVolumeOptions=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDyeVolume->5.97*Microliter,Output->Options];
			Lookup[roundedLoadingDyeVolumeOptions,LoadingDyeVolume],
			6*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {roundedLoadingDyeVolumeOptions}
		],
		Example[{Options,LoadingDilutionBufferVolume,"Rounds specified LoadingDilutionBufferVolume to the nearest 0.1 uL:"},
			roundedLoadingDilutionBufferVolumeOptions=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDilutionBufferVolume->5.97*Microliter,Output->Options];
			Lookup[roundedLoadingDilutionBufferVolumeOptions,LoadingDilutionBufferVolume],
			6*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {roundedLoadingDilutionBufferVolumeOptions}
		],
		Example[{Options,SampleLoadingVolume,"Rounds specified SampleLoadingVolume to the nearest 0.1 uL:"},
			roundedSampleLoadingVolumeOptions=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				SampleLoadingVolume->44.12*Microliter,Output->Options];
			Lookup[roundedSampleLoadingVolumeOptions,SampleLoadingVolume],
			44.1*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {roundedSampleLoadingVolumeOptions}
		],
		Example[{Options,SeparationTime,"Rounds specified SeparationTime to the nearest 1 second:"},
			roundedSampleLoadingVolumeOptions=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				SeparationTime->3498.7*Second,Output->Options];
			Lookup[roundedSampleLoadingVolumeOptions,SeparationTime],
			3499*Second,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {roundedSampleLoadingVolumeOptions}
		],
		Example[{Options,DutyCycle,"Rounds specified DutyCycle to the nearest 1 Percent:"},
			roundedDutyCycleOptions=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				DutyCycle->88.7*Percent,Output->Options];
			Lookup[roundedDutyCycleOptions,DutyCycle],
			89*Percent,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {roundedDutyCycleOptions}
		],
		Example[{Options,ExtractionVolume,"Rounds specified ExtractionVolume to the nearest 1 uL:"},
			roundedExtractionVolumeOptions=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				ExtractionVolume->123.3*Microliter,Output->Options];
			Lookup[roundedExtractionVolumeOptions,ExtractionVolume],
			123*Microliter,
			EquivalenceFunction->Equal,
			Messages:>{
				Warning::InstrumentPrecision
			},
			Variables :> {roundedExtractionVolumeOptions}
		],

		(* - Options with Defaults Tests *)
		Example[{Options,Instrument,"The Instrument option defaults to Model[Instrument, Electrophoresis, \"Ranger\"]:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,Instrument],
			ObjectP[Model[Instrument, Electrophoresis, "Ranger"]],
			Variables :> {options}
		],
		Example[{Options,Instrument,"The Instrument option can accept an Instrument Object:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Instrument->Object[Instrument, Electrophoresis, "Test Ranger Electrophoresis Instrument for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Output->Options];
			Lookup[options,Instrument],
			ObjectP[Object[Instrument, Electrophoresis, "Test Ranger Electrophoresis Instrument for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]],
			Variables :> {options}
		],

		(* - Option Resolution Tests - *)
		Example[{Options,Scale,"The Scale option defaults to Analytical if the Gel option has been specified as a member of AnalyticalAgaroseGelP:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Gel->Model[Item, Gel, "Analytical 1.0% agarose cassette, 24 channel"],Output->Options];
			Lookup[options,Scale],
			Analytical,
			Variables :> {options}
		],
		Example[{Options,Scale,"The Scale option defaults to Preparative if the Gel option is either not specified, or specified as a member of PreparativeAgaroseGelP:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,Scale],
			Preparative,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 0.5% if the Gel is specified and its GelPercentage is 0.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"Analytical 0.5% agarose cassette, 24 channel"],Output->Options];
			Lookup[options,AgarosePercentage],
			0.5*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 1% if the Gel is specified and its GelPercentage is 1%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"Size Selection 1.0% agarose cassette, 12 channel"],Output->Options];
			Lookup[options,AgarosePercentage],
			1*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 1.5% if the Gel is specified and its GelPercentage is 1.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"Analytical 1.5% agarose cassette, 24 channel"],Output->Options];
			Lookup[options,AgarosePercentage],
			1.5*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 2% if the Gel is specified and its GelPercentage is 2%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"Size Selection 2.0% agarose cassette, 12 channel"],Output->Options];
			Lookup[options,AgarosePercentage],
			2*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 3% if the Gel is specified and its GelPercentage is 3%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Gel->Model[Item,Gel,"Analytical 3.0% agarose cassette, 24 channel"],Output->Options];
			Lookup[options,AgarosePercentage],
			3*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 0.5% if the Gel is not specified, and the average Length of the longest Model[Molecule,Oligomer] present in each of the input Samples' Analytes field (or Composition field if there are no Oligomer Analytes for a given sample) is 4000 basepairs or greater:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"100 and 6000mer DNA oligomer mixture for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,AgarosePercentage],
			0.5*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 1% if the Gel is not specified, and the average Length of the longest Model[Molecule,Oligomer] present in each of the input Samples' Analytes field (or Composition field if there are no Oligomer Analytes for a given sample) is between 1250 and 3999 basepairs:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,AgarosePercentage],
			1*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 1.5% if the Gel is not specified, and the average Length of the longest Model[Molecule,Oligomer] present in each of the input Samples' Analytes field (or Composition field if there are no Oligomer Analytes for a given sample) is between 400 and 1249 basepairs:"},
			options=ExperimentAgaroseGelElectrophoresis[{Object[Sample,"100mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Object[Sample,"200 and 800mer DNA oligomer mixture with 800mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]},
				PeakDetectionRange->500*BasePair;;900*BasePair,Output->Options];
			Lookup[options,AgarosePercentage],
			1.5*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 2% if the Gel is not specified, and the average Length of the longest Model[Molecule,Oligomer] present in each of the input Samples' Analytes field (or Composition field if there are no Oligomer Analytes for a given sample) is between 200 and 399 basepairs:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"200 and 800mer DNA oligomer mixture with 200mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,AgarosePercentage],
			2*Percent,
			Variables :> {options}
		],
		Example[{Options,AgarosePercentage,"The AgarosePercentage defaults to 3% if the Gel is not specified, and the average Length of the longest Model[Molecule,Oligomer] present in each of the input Samples' Analytes field (or Composition field if there are no Oligomer Analytes for a given sample) is between 1 and 199 basepairs:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"100mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Output->Options];
			Lookup[options,AgarosePercentage],
			3*Percent,
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Analytical 0.5% agarose cassette, 24 channel\"] if the Scale is Analytical and the AgarosePercentage is 0.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->0.5*Percent,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Analytical 0.5% agarose cassette, 24 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Analytical 1.0% agarose cassette, 24 channel\"] if the Scale is Analytical and the AgarosePercentage is 1%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->1*Percent,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Analytical 1.0% agarose cassette, 24 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Analytical 1.5% agarose cassette, 24 channel\"] if the Scale is Analytical and the AgarosePercentage is 1.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->1.5*Percent,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Analytical 1.5% agarose cassette, 24 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Analytical 2.0% agarose cassette, 24 channel\"] if the Scale is Analytical and the AgarosePercentage is 2%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->2*Percent,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Analytical 2.0% agarose cassette, 24 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Analytical 3.0% agarose cassette, 24 channel\"] if the Scale is Analytical and the AgarosePercentage is 3%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->3*Percent,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Analytical 3.0% agarose cassette, 24 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Size Selection 0.5% agarose cassette, 12 channel\"] if the Scale is Preparative and the AgarosePercentage is 0.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AgarosePercentage->0.5*Percent,PeakDetectionRange->3000*BasePair;;5000*BasePair,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Size Selection 0.5% agarose cassette, 12 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Size Selection 1.0% agarose cassette, 12 channel\"] if the Scale is Preparative and the AgarosePercentage is 1%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AgarosePercentage->1*Percent,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Size Selection 1.0% agarose cassette, 12 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Size Selection 1.5% agarose cassette, 12 channel\"] if the Scale is Preparative and the AgarosePercentage is 1.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AgarosePercentage->1.5*Percent,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Size Selection 1.5% agarose cassette, 12 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Size Selection 2.0% agarose cassette, 12 channel\"] if the Scale is Preparative and the AgarosePercentage is 2%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AgarosePercentage->2*Percent,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Size Selection 2.0% agarose cassette, 12 channel"],
			Variables :> {options}
		],
		Example[{Options,Gel,"The Gel option defaults to Model[Item, Gel, \"Size Selection 3.0% agarose cassette, 12 channel\"] if the Scale is Preparative and the AgarosePercentage is 3%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AgarosePercentage->3*Percent,PeakDetectionRange->400*BasePair;;1800*BasePair,Output->Options];
			Lookup[options,Gel],
			Model[Item, Gel, "Size Selection 3.0% agarose cassette, 12 channel"],
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Null if the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,Output->Options];
			Lookup[options,Ladder],
			Null,
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Model[Sample, StockSolution, Standard, \"GeneRuler dsDNA 10000-50000 bp, 8 bands, 50 ng/uL\"] if the Scale is Analytical and the AgarosePercentage is 0.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->0.5*Percent,Output->Options];
			Lookup[options,Ladder],
			Model[Sample, StockSolution, Standard, "GeneRuler dsDNA 10000-50000 bp, 8 bands, 50 ng/uL"],
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Model[Sample, StockSolution, Standard, \"GeneRuler dsDNA 75-20000 bp, 15 bands, 50 ng/uL\"] if the Scale is Analytical and the AgarosePercentage is 1% or 1.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->1.5*Percent,Output->Options];
			Lookup[options,Ladder],
			Model[Sample, StockSolution, Standard, "GeneRuler dsDNA 75-20000 bp, 15 bands, 50 ng/uL"],
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Model[Sample, StockSolution, Standard, \"GeneRuler dsDNA 25-700 bp, 10 bands, 50 ng/uL\"] if the Scale is Analytical and the AgarosePercentage is 2%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->2*Percent,Output->Options];
			Lookup[options,Ladder],
			Model[Sample, StockSolution, Standard, "GeneRuler dsDNA 25-700 bp, 10 bands, 50 ng/uL"],
			Variables :> {options}
		],
		Example[{Options,Ladder,"The Ladder option defaults to Model[Sample, StockSolution, Standard, \"GeneRuler dsDNA 10-300 bp, 11 bands, 50 ng/uL\"] if the Scale is Analytical and the AgarosePercentage is 3%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,AgarosePercentage->3*Percent,Output->Options];
			Lookup[options,Ladder],
			Model[Sample, StockSolution, Standard, "GeneRuler dsDNA 10-300 bp, 11 bands, 50 ng/uL"],
			Variables :> {options}
		],
		Example[{Options,LadderStorageCondition,"The non-default conditions under which any ladder used by this experiment should be stored after the protocol is completed:"},
        	options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
        		Scale->Analytical,AgarosePercentage->3*Percent,LadderStorageCondition->AmbientStorage,Output->Options];
        	Lookup[options,LadderStorageCondition],
        	AmbientStorage,
        	Variables :> {options}
        ],
        Example[{Options,LadderStorageCondition,"Specify to dispose ladder after the experiment protocol:"},
            protocol=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
                Scale->Analytical,AgarosePercentage->3*Percent,LadderStorageCondition->Disposal];
            Download[protocol,LadderStorageCondition],
            Disposal,
            Variables :> {protocol}
        ],
        Example[{Options,LadderStorageCondition,"LadderStorageCondition will be overwritten and set to Null if no ladder is used in an experiment:"},
            protocol=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
                Scale->Preparative,LadderStorageCondition->Disposal];
            Download[protocol,LadderStorageCondition],
            Null,
            Variables :> {protocol},
            Messages :> {Warning::OverwriteLadderStorageCondition}
        ],
		Example[{Options,LadderFrequency,"The LadderFrequency option defaults to Null if the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,Output->Options];
			Lookup[options,LadderFrequency],
			Null,
			Variables :> {options}
		],
		Example[{Options,LadderFrequency,"The LadderFrequency option can be specified for analytical gels:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,LadderFrequency->First,Output->Options];
			Lookup[options,LadderFrequency],
			First,
			Variables :> {options}
		],
		Example[{Options,LadderFrequency,"The LadderFrequency option Defaults to FirstAndLast if the scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,LadderFrequency],
			FirstAndLast,
			Variables :> {options}
		],
		Example[{Options,DutyCycle,"The DutyCycle option defaults to 35% if the AgarosePercentrage is 0.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AgarosePercentage->0.5*Percent,PeakDetectionRange->3000*BasePair;;5000*BasePair,Output->Options];
			Lookup[options,DutyCycle],
			35*Percent,
			Variables :> {options}
		],
		Example[{Options,DutyCycle,"The DutyCycle option defaults to 50% if the AgarosePercentrage is 1% or 1.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AgarosePercentage->1*Percent,Output->Options];
			Lookup[options,DutyCycle],
			50*Percent,
			Variables :> {options}
		],
		Example[{Options,DutyCycle,"The DutyCycle option defaults to 100% if the AgarosePercentrage is 2% or 3%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AgarosePercentage->2*Percent,Output->Options];
			Lookup[options,DutyCycle],
			100*Percent,
			Variables :> {options}
		],
		Example[{Options,SeparationTime,"The SeparationTime option defaults to 5000 seconds if the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,Output->Options];
			Lookup[options,SeparationTime],
			5000*Second,
			Variables :> {options}
		],
		Example[{Options,SeparationTime,"The SeparationTime option defaults to 2500 seconds if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,SeparationTime],
			2500*Second,
			Variables :> {options}
		],
		Example[{Options,ExtractionVolume,"The ExtractionVolume option defaults to Null if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,ExtractionVolume],
			Null,
			Variables :> {options}
		],
		Example[{Options,ExtractionVolume,"The ExtractionVolume option defaults to 150 uL if the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,Output->Options];
			Lookup[options,ExtractionVolume],
			150*Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleLoadingVolume,"The SampleLoadingVolume option defaults to 8 uL if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,SampleLoadingVolume],
			8*Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleLoadingVolume,"The SampleLoadingVolume option defaults to 50 uL if the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,Output->Options];
			Lookup[options,SampleLoadingVolume],
			50*Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleVolume,"The SampleVolume option defaults to 45 uL if the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,Output->Options];
			Lookup[options,SampleVolume],
			45*Microliter,
			Variables :> {options}
		],
		Example[{Options,SampleVolume,"The SampleVolume option defaults to 10 uL if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,SampleVolume],
			10*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingDyeVolume,"The LoadingDyeVolume option defaults to 5 uL if the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,Output->Options];
			Lookup[options,LoadingDyeVolume],
			5*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingDyeVolume,"The LoadingDyeVolume option defaults to 1.3 uL if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,LoadingDyeVolume],
			1.3*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingDye,"The LoadingDye option defaults to {Model[Sample, \"100 bp dyed loading buffer for agarose gel electrophoresis\"], Model[Sample, \"500 bp dyed loading buffer for agarose gel electrophoresis\"]} if the AgarosePercentagae is 3%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AgarosePercentage->3*Percent,PeakDetectionRange->100*BasePair;;200*BasePair,Output->Options];
			Lookup[options,LoadingDye],
			{Model[Sample, "100 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "500 bp dyed loading buffer for agarose gel electrophoresis"]},
			Variables :> {options}
		],
		Example[{Options,LoadingDye,"The LoadingDye option defaults to {Model[Sample, \"200 bp dyed loading buffer for agarose gel electrophoresis\"], Model[Sample, \"2000 bp dyed loading buffer for agarose gel electrophoresis\"]} if the AgarosePercentagae is 2%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AgarosePercentage->2*Percent,Output->Options];
			Lookup[options,LoadingDye],
			{Model[Sample, "200 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "2000 bp dyed loading buffer for agarose gel electrophoresis"]},
			Variables :> {options}
		],
		Example[{Options,LoadingDye,"The LoadingDye option defaults to {Model[Sample, \"300 bp dyed loading buffer for agarose gel electrophoresis\"], Model[Sample, \"3000 bp dyed loading buffer for agarose gel electrophoresis\"]} if the AgarosePercentagae is 1.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AgarosePercentage->1.5*Percent,Output->Options];
			Lookup[options,LoadingDye],
			{Model[Sample, "300 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "3000 bp dyed loading buffer for agarose gel electrophoresis"]},
			Variables :> {options}
		],
		Example[{Options,LoadingDye,"The LoadingDye option defaults to {Model[Sample, \"1000 bp dyed loading buffer for agarose gel electrophoresis\"], Model[Sample, \"10000 bp dyed loading buffer for agarose gel electrophoresis\"]} if the AgarosePercentagae is 1%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AgarosePercentage->1*Percent,Output->Options];
			Lookup[options,LoadingDye],
			{Model[Sample, "1000 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "10000 bp dyed loading buffer for agarose gel electrophoresis"]},
			Variables :> {options}
		],
		Example[{Options,LoadingDye,"The LoadingDye option defaults to {Model[Sample, \"3000 bp dyed loading buffer for agarose gel electrophoresis\"], Model[Sample, \"10000 bp dyed loading buffer for agarose gel electrophoresis\"]} if the AgarosePercentagae is 0.5%:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AgarosePercentage->0.5*Percent,PeakDetectionRange->3500*BasePair;;5000*BasePair,Output->Options];
			Lookup[options,LoadingDye],
			{Model[Sample, "3000 bp dyed loading buffer for agarose gel electrophoresis"], Model[Sample, "10000 bp dyed loading buffer for agarose gel electrophoresis"]},
			Variables :> {options}
		],
		Example[{Options,LoadingDilutionBuffer,"The LoadingDilutionBuffer option defaults to Model[Sample, StockSolution, \"1x TE Buffer\"] if the LoadingDilutionBufferVolume has been set to a non-zero volume:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDilutionBufferVolume->5*Microliter,Output->Options];
			Lookup[options,LoadingDilutionBuffer],
			Model[Sample, StockSolution, "1x TE Buffer"],
			Variables :> {options}
		],
		Example[{Options,LoadingDilutionBuffer,"The LoadingDilutionBuffer option defaults to Null if the sum of the SampleVolume and the (LoadingDyeVolume times 2) is equal to or larger than 10 uL when the Scale is Analytical or 60 uL when the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				SampleVolume->52.8*Microliter,LoadingDyeVolume->3.6*Microliter,SampleLoadingVolume->50*Microliter,Output->Options];
			Lookup[options,LoadingDilutionBuffer],
			Null,
			Variables :> {options}
		],
		Example[{Options,LoadingDilutionBuffer,"The LoadingDilutionBuffer option defaults to Model[Sample, StockSolution, \"1x TE Buffer\"] if the sum of the SampleVolume and the (LoadingDyeVolume times 2) is smaller than 10 uL when the Scale is Analytical or 60 uL when the Scale is Preparative:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				SampleVolume->30*Microliter,LoadingDyeVolume->3.6*Microliter,SampleLoadingVolume->50*Microliter,Output->Options];
			Lookup[options,LoadingDilutionBuffer],
			Model[Sample, StockSolution, "1x TE Buffer"],
			Variables :> {options}
		],
		Example[{Options,LoadingDilutionBufferVolume,"The LoadingDilutionBufferVolume option defaults to 0 uL if the LoadingDilutionBuffer is set to or has resolved to Null:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				LoadingDilutionBuffer->Null,Output->Options];
			Lookup[options,LoadingDilutionBufferVolume],
			0*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingDilutionBufferVolume,"The LoadingDilutionBufferVolume option defaults to 0 uL if the sum of the SampleVolume and the (LoadingDyeVolume times the number of LoadingDyes) is equal to or larger than the SampleLoadingVolume:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				SampleVolume->52.8*Microliter,LoadingDyeVolume->3.6*Microliter,SampleLoadingVolume->50*Microliter,Output->Options];
			Lookup[options,LoadingDilutionBufferVolume],
			0*Microliter,
			Variables :> {options}
		],
		Example[{Options,LoadingDilutionBufferVolume,"The LoadingDilutionBufferVolume option defaults to the SampleLoadingVolume minus the sum of the SampleVolume and the (LoadingDyeVolume times the number of LoadingDyes) if the sum of the SampleVolume and the (LoadingDyeVolume times the number of LoadingDyes) is less than the SampleLoadingVolume:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				SampleVolume->30*Microliter,LoadingDyeVolume->3.6*Microliter,SampleLoadingVolume->50*Microliter,Output->Options];
			Lookup[options,LoadingDilutionBufferVolume],
			17.8*Microliter,
			Variables :> {options}
		],
		Example[{Options,AutomaticPeakDetection,"The AutomaticPeakDetection option defaults to Null if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,AutomaticPeakDetection],
			Null,
			Variables :> {options}
		],
		Example[{Options,AutomaticPeakDetection,"The AutomaticPeakDetection option defaults to True if the Scale is Preparative and the PeakDetectionRange option has been specified as a non-Null value:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,PeakDetectionRange->1000*BasePair;;1500*BasePair,Output->Options];
			Lookup[options,AutomaticPeakDetection],
			True,
			Variables :> {options}
		],
		Example[{Options,AutomaticPeakDetection,"The AutomaticPeakDetection option defaults to False if the Scale is Preparative and the CollectionRange option has been specified as a non-Null value:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,CollectionRange->1200*BasePair;;1400*BasePair,Output->Options];
			Lookup[options,AutomaticPeakDetection],
			False,
			Variables :> {options}
		],
		Example[{Options,AutomaticPeakDetection,"The AutomaticPeakDetection option defaults to False if the Scale is Preparative and the CollectionSize option has been specified as a non-Null value:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,CollectionSize->1600*BasePair,Output->Options];
			Lookup[options,AutomaticPeakDetection],
			False,
			Variables :> {options}
		],
		Example[{Options,AutomaticPeakDetection,"The AutomaticPeakDetection option defaults to False if the Scale is Preparative and the PeakDetectionRange has been specified as Null:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,PeakDetectionRange->Null,Output->Options];
			Lookup[options,AutomaticPeakDetection],
			False,
			Variables :> {options}
		],
		Example[{Options,AutomaticPeakDetection,"The AutomaticPeakDetection option defaults to True if the Scale is Preparative and the CollectionSize has been specified as Null:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,CollectionSize->Null,Output->Options];
			Lookup[options,AutomaticPeakDetection],
			True,
			Variables :> {options}
		],
		Example[{Options,AutomaticPeakDetection,"The AutomaticPeakDetection option defaults to True if the Scale is Preparative and none of the PeakDetectionRange, CollectionSize, or CollectionRange options has been specified:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,Output->Options];
			Lookup[options,AutomaticPeakDetection],
			True,
			Variables :> {options}
		],
		Example[{Options,CollectionSize,"The CollectionSize option defaults to Null if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,CollectionSize],
			Null,
			Variables :> {options}
		],
		Example[{Options,CollectionSize,"The CollectionSize option defaults to Null if the Scale is Preparative and the AutomaticPeakDetection option is True:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->True,Output->Options];
			Lookup[options,CollectionSize],
			Null,
			Variables :> {options}
		],
		Example[{Options,CollectionSize,"The CollectionSize option defaults to largest Length in base pairs of all of the Structures present in the Model field of the input sample's Composition if the Scale is Preparative and the AutomaticPeakDetection option is False:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,Output->Options];
			Lookup[options,CollectionSize],
			1600*BasePair,
			Variables :> {options}
		],
		Example[{Options,CollectionSize,"The CollectionSize option defaults to Null if the Scale is Preparative, the AutomaticPeakDetection option is False, and the Molecule field of all of Objects present in the sample's Composition do not contain a Strand or Structure:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,Output->Options];
			Lookup[options,CollectionSize],
			Null,
			Messages :> {
				Error::UnableToDetermineAgaroseCollectionSize,
				Error::UnableToDetermineAgaroseCollectionRange,
				Error::InvalidOption
			},
			Variables :> {options}
		],
		Example[{Options,CollectionRange,"The CollectionRange option defaults to Null if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,CollectionRange],
			Null,
			Variables :> {options}
		],
		Example[{Options,CollectionRange,"The CollectionRange option defaults to Null if the Scale is Preparative and the AutomaticPeakDetection option is True:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->True,Output->Options];
			Lookup[options,CollectionRange],
			Null,
			Variables :> {options}
		],
		Example[{Options,CollectionRange,"The CollectionRange option defaults to Null if the Scale is Preparative, the AutomaticPeakDetection option is False, and the CollectionSize is specified as a non-Null value:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,CollectionSize->1400*BasePair,Output->Options];
			Lookup[options,CollectionRange],
			Null,
			Variables :> {options}
		],
		Example[{Options,CollectionRange,"The CollectionRange option defaults to Null if the Scale is Preparative, the AutomaticPeakDetection option is False, the CollectionSize is Null, and the Molecule field of all of Objects present in the sample's Composition do not contain a Strand or Structure:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,CollectionSize->Null,Output->Options];
			Lookup[options,CollectionRange],
			Null,
			Messages :> {
				Error::UnableToDetermineAgaroseCollectionRange,
				Error::InvalidOption
			},
			Variables :> {options}
		],
		Example[{Options,CollectionRange,"The CollectionRange option defaults to Span[(0.92*Length of largest Strand in the Molecule field of the sample's Composition),(1.05*Length of largest Strand in the Molecule field of the sample's Composition)] if the Scale is Preparative, the AutomaticPeakDetection option is False, and the CollectionSize is Null:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,CollectionSize->Null,Output->Options];
			Lookup[options,CollectionRange],
			1472*BasePair;;1680*BasePair,
			Variables :> {options}
		],
		Example[{Options,PeakDetectionRange,"The PeakDetectionRange option defaults to Null if the Scale is Analytical:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Analytical,Output->Options];
			Lookup[options,PeakDetectionRange],
			Null,
			Variables :> {options}
		],
		Example[{Options,PeakDetectionRange,"The PeakDetectionRange option defaults to Null if the Scale is Preparative and the AutomaticPeakDetection is False:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->False,Output->Options];
			Lookup[options,PeakDetectionRange],
			Null,
			Variables :> {options}
		],
		Example[{Options,PeakDetectionRange,"The PeakDetectionRange option defaults to Span[(0.75*Length of largest Strand in the Molecule field of the sample's Composition),(1.1*Length of largest Strand in the Molecule field of the sample's Composition)] if the Scale is Preparative and the AutomaticPeakDetection is True:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->True,Output->Options];
			Lookup[options,PeakDetectionRange],
			Span[1200*BasePair,1760*BasePair],
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,PeakDetectionRange,"The PeakDetectionRange option defaults to Null if the Scale is Preparative, the AutomaticPeakDetection is True, but there are no Strands in the Composition of the input sample:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				Scale->Preparative,AutomaticPeakDetection->True,Output->Options];
			Lookup[options,PeakDetectionRange],
			Null,
			Messages :> {
				Error::UnableToDetermineAgarosePeakDetectionRange,
				Error::InvalidOption
			},
			Variables :> {options}
		],

		(* - Shared option unit tests - *)
		Example[{Options,Template,"Inherit options from a previously run protocol:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Template->Object[Protocol,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis option template protocol" <> $SessionUUID],Output->Options];
			Lookup[options,AgarosePercentage],
			2*Percent,
			Variables :> {options}
		],
		Example[{Options,Name,"Name the protocol for AgaroseGelElectrophoresis:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Name->"Super cool test protocol",Output->Options];
			Lookup[options,Name],
			"Super cool test protocol",
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition, "Indicates how the samples created by the experiment should be stored:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Scale->Preparative, SamplesOutStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesOutStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,NumberOfReplicates,"A maximum of 48 samples can be run if Scale is Preparative. If Scale is Analytical, the maximum is 92 samples:"},
			ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], NumberOfReplicates->49],
			$Failed,
			Messages :> {
				Error::TooManyAgaroseInputs,
				Error::InvalidInput
			}
		],
		(* - Sample Prep unit tests - *)
		(* PreparatoryUnitOperations *)
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples to be run on a Preparative or Analytical Scale agarose gel:"},
			options=ExperimentAgaroseGelElectrophoresis["Oligomer Container",
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Oligomer Container",
						Container->Model[Container, Vessel, "id:3em6Zv9NjjN8"]
					],
					Transfer[
						Source->Object[Sample,"100mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
						Amount->100*Microliter,
						Destination->{"A1","Oligomer Container"}
					],
					Transfer[
						Source->Object[Sample,"200 and 800mer DNA oligomer mixture with 200mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
						Amount->100*Microliter,
						Destination->{"A1","Oligomer Container"}
					]
				},
				Scale->Preparative,
				Output->Options
			];
			Lookup[options,AgarosePercentage],
			2*Percent,
			Variables:>{options}
		],

		(* Incubate Options *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:WNa4ZjRDVw64"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], IncubateAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],IncubateAliquotDestinationWell -> "A1",AliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],
		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* Centrifuge Options *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], CentrifugeTime -> 5*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], CentrifugeTemperature -> 30*Celsius,CentrifugeAliquotContainer->Model[Container, Vessel, "50mL Tube"],AliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], CentrifugeAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], CentrifugeAliquotContainer->Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],

		(* Filter Options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FiltrationType -> Syringe,Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FilterMaterial -> PES,FilterContainerOut->Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],PrefilterMaterial -> GxF,CollectionSize->2000*BasePair, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options},
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE,CollectionSize->2000*BasePair, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"],CollectionSize->2000*BasePair, Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius,Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FilterAliquot -> 0.5*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables :> {options}
		],

		(* Aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Aliquot->True,Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				AliquotSampleLabel->"Test Label for ExperimentAgaroseGelElectrophoresis sample 1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"Test Label for ExperimentAgaroseGelElectrophoresis sample 1"},
			Variables :> {options}
		],	
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], AliquotAmount -> 0.5*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], AssayVolume -> 0.5*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], TargetConcentration -> 5.5*Micromolar, AssayVolume->100*Microliter,Output -> Options];
			Lookup[options, TargetConcentration],
			5.5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], TargetConcentration -> 5.5*Micromolar,TargetConcentrationAnalyte->Model[Molecule, Oligomer, "1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],AssayVolume->100*Microliter,Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				ConcentratedBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],
				BufferDilutionFactor->2,
				BufferDiluent->Model[Sample, "Milli-Q water"],
				AliquotAmount->0.2*Milliliter,
				AssayVolume->0.5*Milliliter,
				Output -> Options
			];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
				BufferDiluent->Model[Sample, "Milli-Q water"],
				AliquotAmount->0.1*Milliliter,
				AssayVolume->0.8*Milliliter,
				Output -> Options
			];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
				BufferDiluent -> Model[Sample, "Milli-Q water"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, "Simple Western 10X Sample Buffer"],
				AliquotAmount->0.2*Milliliter,
				AssayVolume->0.8*Milliliter,
				Output -> Options
			];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "Simple Western 0.1X Sample Buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator,Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentAgaroseGelElectrophoresis[{Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]}, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentAgaroseGelElectrophoresis[Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentAgaroseGelElectrophoresis[
				ConstantArray[Model[Sample, StockSolution, Standard, "id:9RdZXv1KzGOK"](* GeneRuler dsDNA 10-300 bp, 11 bands, 167 ng/uL *),2],
				PreparedModelContainer -> Model[Container, Vessel, "id:bq9LA0dBGGR6"](* 50mL Tube *),
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
				{ObjectP[Model[Sample, StockSolution, Standard, "id:9RdZXv1KzGOK"]]..},
				{ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentAgaroseGelElectrophoresis[Model[Sample, StockSolution, Standard, "id:9RdZXv1KzGOK"], PreparedModelAmount -> 1 Milliliter, Aliquot -> True, Mix -> True],
			ObjectP[Object[Protocol, AgaroseGelElectrophoresis]]
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearMemoization[];
		(* Turn off the lab state warning for unit tests, since parallel is True, warnings should be turned off in SetUp as well *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	),

	Parallel -> True,

	SymbolSetUp:>(

		(* Turn off the lab state warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Container,Vessel,"Container 1 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 2 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 3 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 4 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 5 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 6 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 7 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Plate,"Container 8 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Instrument, Electrophoresis, "Test Ranger Electrophoresis Instrument for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Item,Gel,"Preparative 0.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 1.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 2% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 3% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 0.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 1.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 2% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 3% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Model[Molecule,Oligomer,"100mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Model[Molecule,Oligomer,"200mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Model[Molecule,Oligomer,"800mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Model[Molecule,Oligomer,"1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Model[Molecule,Oligomer,"6000mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"Discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"100mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"200 and 800mer DNA oligomer mixture with 200mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"200 and 800mer DNA oligomer mixture with 800mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"100 and 6000mer DNA oligomer mixture for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"Test 1600mer DNA oligomer 1 for plate storage condition tests" <> $SessionUUID],
					Object[Sample,"Test 1600mer DNA oligomer 2 for plate storage condition tests" <> $SessionUUID],

					Object[Protocol,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis option template protocol" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];

		Block[{$AllowSystemsProtocols = True, $DeveloperUpload = True},
			Module[
				{
					testBench,

					container1,container2,container3,container4,container5,container6,container7,container8,

					gel1,gel2,gel3,gel4,gel5,gel6,gel7,gel8,gel9,gel10,

					sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Bench for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				(* Upload test Containers and Gels *)
				{
					container1,container2,container3,container4,container5,container6,container7,container8,

					(* Uploading a bunch of gels to use in tests but also so that we never get SamplesOutOfStock Warnings *)
					gel1,gel2,gel3,gel4,gel5,gel6,gel7,gel8,gel9,gel10
				}=UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Item,Gel,"Size Selection 0.5% agarose cassette, 12 channel"],
						Model[Item,Gel,"Size Selection 1.0% agarose cassette, 12 channel"],
						Model[Item,Gel,"Size Selection 1.5% agarose cassette, 12 channel"],
						Model[Item,Gel,"Size Selection 2.0% agarose cassette, 12 channel"],
						Model[Item,Gel,"Size Selection 3.0% agarose cassette, 12 channel"],
						Model[Item,Gel,"Analytical 0.5% agarose cassette, 24 channel"],
						Model[Item,Gel,"Analytical 1.0% agarose cassette, 24 channel"],
						Model[Item,Gel,"Analytical 1.5% agarose cassette, 24 channel"],
						Model[Item,Gel,"Analytical 2.0% agarose cassette, 24 channel"],
						Model[Item,Gel,"Analytical 3.0% agarose cassette, 24 channel"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name->{
						"Container 1 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Container 2 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Container 3 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Container 4 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Container 5 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Container 6 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Container 7 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Container 8 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Preparative 0.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Preparative 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Preparative 1.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Preparative 2% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Preparative 3% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Analytical 0.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Analytical 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Analytical 1.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Analytical 2% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Analytical 3% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID
					}
				];

				(* Create Oligomer Molecule ID Models for the test samples' Composition field - and a test instrument *)
				Upload[
					{
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 25]]]],
							PolymerType-> DNA,
							Name-> "100mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
							MolecularWeight->30832.8*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 50]]]],
							PolymerType-> DNA,
							Name-> "200mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
							MolecularWeight->61727.5*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 200]]]],
							PolymerType-> DNA,
							Name-> "800mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
							MolecularWeight->247096*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 400]]]],
							PolymerType-> DNA,
							Name-> "1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
							MolecularWeight->494254*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 1500]]]],
							PolymerType-> DNA,
							Name-> "6000mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
							MolecularWeight->1853620*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Object[Instrument,Electrophoresis],
							Model->Link[Model[Instrument, Electrophoresis, "Ranger"],Objects],
							Name->"Test Ranger Electrophoresis Instrument for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
							Site -> Link[$Site],
							DeveloperObject->True
						|>
					}
				];

				(* Upload test sample objects *)
				{
					sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9
				}=UploadSample[
					{
						{
							{20*Micromolar,Link[Model[Molecule, Oligomer, "1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						},
						{
							{20*Micromolar,Link[Model[Molecule, Oligomer, "1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						},
						{
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						},
						{
							{20*Micromolar,Link[Model[Molecule, Oligomer, "100mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						},
						{
							{20*Micromolar,Link[Model[Molecule, Oligomer, "200mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{20*Micromolar,Link[Model[Molecule, Oligomer, "800mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						},
						{
							{20*Micromolar,Link[Model[Molecule, Oligomer, "200mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{20*Micromolar,Link[Model[Molecule, Oligomer, "800mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						},
						{
							{20*Micromolar,Link[Model[Molecule, Oligomer, "100mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{20*Micromolar,Link[Model[Molecule, Oligomer, "6000mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						},
						{
							{20*Micromolar,Link[Model[Molecule, Oligomer, "1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						},
						{
							{20*Micromolar,Link[Model[Molecule, Oligomer, "1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]},
							{100*VolumePercent,Link[Model[Molecule, "Water"]]}
						}
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", container6},
						{"A1", container7},
						{"A1", container8},
						{"A2", container8}
					},
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount->{
						1*Milliliter,
						1*Milliliter,
						25*Milliliter,
						1*Milliliter,
						1*Milliliter,
						1*Milliliter,
						1*Milliliter,
						1*Milliliter,
						1*Milliliter
					},
					Name->{
						"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"100mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"200 and 800mer DNA oligomer mixture with 200mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"200 and 800mer DNA oligomer mixture with 800mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"100 and 6000mer DNA oligomer mixture for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID,
						"Test 1600mer DNA oligomer 1 for plate storage condition tests" <> $SessionUUID,
						"Test 1600mer DNA oligomer 2 for plate storage condition tests" <> $SessionUUID
					}
				];

				Upload[<|Object -> #, DeveloperObject -> True, AwaitingStorageUpdate -> Null|> & /@ Cases[Flatten[{container1,container2,container3,container4,container5,container6,container7,container8,sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9}], ObjectP[]]];

				Upload[Cases[Flatten[{
					<|
						Object -> Object[Sample,"Discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
						Status -> Discarded
					|>,
					<|
						Object -> Object[Sample,"200 and 800mer DNA oligomer mixture with 200mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
						Replace[Analytes]->{Link[Model[Molecule, Oligomer, "200mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]}
					|>,
					<|
						Object -> Object[Sample,"200 and 800mer DNA oligomer mixture with 800mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
						Replace[Analytes]->{Link[Model[Molecule, Oligomer, "800mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID]]}
					|>
				}], PacketP[]]];

				(* Make a test protocol for the Template option unit test *)
				Upload[
					{
						<|
							Type->Object[Protocol,AgaroseGelElectrophoresis],
							Name->"Test AgaroseGelElectrophoresis option template protocol" <> $SessionUUID,
							ResolvedOptions->{AgarosePercentage->2*Percent}
						|>
					}
				]
			]
		]
	),
	SymbolTearDown:>(

		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existingObjects},
			objects=Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Container,Vessel,"Container 1 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 2 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 3 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 4 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 5 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 6 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container 7 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Container,Plate,"Container 8 for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Instrument, Electrophoresis, "Test Ranger Electrophoresis Instrument for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Item,Gel,"Preparative 0.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 1.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 2% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Preparative 3% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 0.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 1% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 1.5% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 2% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Item,Gel,"Analytical 3% Gel ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Model[Molecule,Oligomer,"100mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Model[Molecule,Oligomer,"200mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Model[Molecule,Oligomer,"800mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Model[Molecule,Oligomer,"1600mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Model[Molecule,Oligomer,"6000mer DNA Model Molecule for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Sample,"1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"Discarded 1600mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"25 mL water sample in 50mL Tube for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"100mer DNA oligomer for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"200 and 800mer DNA oligomer mixture with 200mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"200 and 800mer DNA oligomer mixture with 800mer Analyte for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],
					Object[Sample,"100 and 6000mer DNA oligomer mixture for ExperimentAgaroseGelElectrophoresis tests" <> $SessionUUID],

					Object[Protocol,AgaroseGelElectrophoresis,"Test AgaroseGelElectrophoresis option template protocol" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	)
]


