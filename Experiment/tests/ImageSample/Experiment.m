(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentImageSample*)


(* ::Section::Closed:: *)
(*ExperimentImageSample*)


DefineTests[
	ExperimentImageSample,
	{
		
		(* === Basic examples === *)
		Example[
			{Basic, "Image a sample in a plate:"},
			ExperimentImageSample[Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID]],
			ObjectP[Object[Protocol, ImageSample]]
		],
		Example[
			{Basic, "Image a sample in a tube:"},
			ExperimentImageSample[Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID]],
			ObjectP[Object[Protocol, ImageSample]]
		],
		Example[
			{Basic, "Image all samples in a plate:"},
			ExperimentImageSample[Object[Container, Plate, "Test DWP for ExperimentImageSample "<>$SessionUUID]],
			ObjectP[Object[Protocol, ImageSample]]
		],
			
		
		(* === Additional examples === *)
		Example[
			{Additional, "If multiple rackable tubes are supplied that can fit into the same rack, they are imaged in the same rack:"},
			Length[Download[
				ExperimentImageSample[
					{
						Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
						Object[Sample, "Test water sample in 2mL Tube 2 for ExperimentImageSample "<>$SessionUUID]
					}
				],
				BatchLengths
			]],
			1
		],
		Example[
			{Additional, "Robotic Reservoir", "Unlike other plates, 200mL robotic reservoirs are imaged from above on the sample imager:"},
			Download[
				ExperimentImageSample[Object[Sample, "Test water sample in 200mL reservoir for ExperimentImageSample "<>$SessionUUID]],
				{PlateImagerInstruments, SampleImagerInstruments, ImagingDirections}
			],
			{{}, {ObjectP[Model[Instrument, SampleImager]]}, {{Top}}}
		],
		
		
		(* === Options examples === *)
		
		Example[
			{Options, Instrument, "Specify the model of imaging instrument to be used:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
					Instrument->Model[Instrument, SampleImager, "Emerald DSLR Camera Imaging Station"],
					Output->{Options}
				]],
				Instrument
			],
			ObjectP[Model[Instrument, SampleImager]]
		],
		
		Example[
			{Options, Instrument, "Force a tube that would normally be imaged in the plate imager to be imaged in a specific sample imager:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
					Instrument->Object[Instrument, SampleImager, "Inspector Clouseau"],
					Output->{Options}
				]],
				Instrument
			],
			ObjectP[Object[Instrument, SampleImager]]
		],
		
		Example[
			{Options, Instrument, "For plate input, resolves to plate imager:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
					Output->{Options}
				]],
				Instrument
			],
			ObjectP[Model[Instrument, PlateImager]]
		],
		
		Example[
			{Options, Instrument, "For vessel input, resolves to sample imager:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID],
					Output->{Options}
				]],
				Instrument
			],
			ObjectP[Model[Instrument, SampleImager]]
		],
		
		Example[
			{Options, Instrument, "For vessel input where plate imager is preferred, resolves to plate imager:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
					Output->{Options}
				]],
				Instrument
			],
			ObjectP[Model[Instrument, PlateImager]]
		],

		Example[{Options,AlternateInstruments,"Resolves to a list of instrument models that are different from the specified Instrument option:"},
			options=ExperimentImageSample[
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
				Instrument->Model[Instrument,PlateImager,"id:n0k9mGzRal41"],
				Output->Options
			];
			MemberQ[Lookup[options,AlternateInstruments],Lookup[options,Instrument]],
			False,
			Variables:>{options}
		],

		Example[{Options,AlternateInstruments,"Resolves to a list of instrument models that are different from the Instrument option:"},
			options=ExperimentImageSample[
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
				Output->Options
			];
			MemberQ[Lookup[options,AlternateInstruments],Lookup[options,Instrument]],
			False,
			Variables:>{options}
		],

		Example[{Options,AlternateInstruments,"Allows a different instrument model than the Instrument option to be set:"},
			options=ExperimentImageSample[
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
				Instrument->Model[Instrument,PlateImager,"id:n0k9mGzRal41"],
				AlternateInstruments->{Model[Instrument, PlateImager, "id:Z1lqpMzwbxEo"]},
				Output->Options
			];
			Lookup[options,{Instrument,AlternateInstruments}],
			{ObjectP[Model[Instrument,PlateImager,"id:n0k9mGzRal41"]],{ObjectP[Model[Instrument, PlateImager, "id:Z1lqpMzwbxEo"]]}},
			Variables:>{options}
		],

		Example[
			{Options, ImageContainer, "Image the vessel an input sample is in, where the photo will be associated with the container instead of the sample:"},
			Download[
				ExperimentImageSample[Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],ImageContainer->True],
				ImageContainers
			],
			{True}
		],
		Example[
			{Options, ImageContainer, "Image the plate an input sample is in, where the photo will be associated with the container instead of the sample:"},
			Download[
				ExperimentImageSample[Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],ImageContainer->True],
				ImageContainers
			],
			{True}
		],
		Example[
			{Options, ImageContainer, "Imaging a plate with ImageContainer -> True defaults Instrument to SampleImager and ImagingDirection to Top:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
					ImageContainer->True,
					Output->{Options}
				]],
				{Instrument,ImagingDirection}
			],
			{ObjectP[Model[Instrument, SampleImager]],{Top}}
		],
		Example[
			{Options, ImageContainer, "Imaging multiple samples with ImageContainer -> True defaults Instrument to SampleImager batch over unique container:"},
			Download[
				ExperimentImageSample[
					{Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
						Object[Sample, "Test water sample 2 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
						Object[Sample, "Test water sample in 384-well plate for ExperimentImageSample "<>$SessionUUID]},
					ImageContainer->True
				],
				BatchedImagingParameters[[All, {Imager, Wells}]]
			],
			{
				<|Imager -> LinkP[Model[Instrument, SampleImager]], Wells -> Null|>,
				<|Imager -> LinkP[Model[Instrument, SampleImager]], Wells -> Null|>
			}
		],
		Example[
			{Options, ImageContainer, "Imaging multiple samples without ImageContainer -> True defaults Instrument to PlateImager batch over samples:"},
			Download[
				ExperimentImageSample[
					{Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
						Object[Sample, "Test water sample 2 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
						Object[Sample, "Test water sample in 384-well plate for ExperimentImageSample "<>$SessionUUID]}
				],
				BatchedImagingParameters[[All, {Imager, Wells}]]
			],
			{
				<|Imager -> LinkP[Model[Instrument, PlateImager]], Wells -> {"A1", "A2"}|>,
				<|Imager -> LinkP[Model[Instrument, PlateImager]], Wells -> {"A1"}|>
			}
		],
		Example[
			{Options, ImageContainer, "Imaging multiple containers with ImageContainer specified will resolve Instrument differently:"},
			Download[
				ExperimentImageSample[
					{Object[Container, Plate, "Test DWP for ExperimentImageSample " <> $SessionUUID],
						Object[Container, Plate, "Test 384-well plate for ExperimentImageSample " <> $SessionUUID]},
					ImageContainer->{True, False}
				],
				BatchedImagingParameters[[All, {Imager, Wells}]]
			],
			{
				<|Imager -> LinkP[Model[Instrument, PlateImager]], Wells -> {"A1"}|>,
				<|Imager -> LinkP[Model[Instrument, SampleImager]], Wells -> Null|>
			}
		],
		(*Example[
			{Options, ImageContainer, "Image an empty plate and associated the photo with the plate:"},
			Download[
				ExperimentImageSample[Object[Container, Plate, "Empty Test DWP for ExperimentImageSample "<>$SessionUUID]],
				{SamplesIn,ContainersIn,ImageContainers}
			],
			{
				{},(* No SamplesIn...crazy right? *)
				{ObjectP[Object[Container,Plate]]},
				{True}(* Auto resolve ImageContainer->True *)
			}
		],
		Example[
			{Options, ImageContainer, "Image an empty tube and associated the photo with the plate:"},
			Download[
				ExperimentImageSample[Object[Container, Vessel, "Empty Test 0.5mL Tube for ExperimentImageSample "<>$SessionUUID]],
				{SamplesIn,ContainersIn,ImageContainers}
			],
			{
				{},(* No SamplesIn...crazy right? *)
				{ObjectP[Object[Container,Vessel]]},
				{True}(* Auto resolve ImageContainer->True *)
			}
		],*)
		
		Example[
			{Options, ImagingDirection, "Specify the direction from which a sample should be imaged:"},
			Lookup[
				Download[
					ExperimentImageSample[
						{
							Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
							Object[Sample, "Test water sample in 2mL Tube 2 for ExperimentImageSample "<>$SessionUUID]
						},
						ImagingDirection->{{Top}, {Side}}
					],
					BatchedImagingParameters
				],
				ImagingDirection
			],
			{{Top}, {Side}}
		],
		
		Example[
			{Options, ImagingDirection, "If ImagingDirection specification is a flat list, it will be auto-expanded to index match the inputs even if it already index-matches:"},
			Lookup[
				Download[
					ExperimentImageSample[
						{
							Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
							Object[Sample, "Test water sample in 2mL Tube 2 for ExperimentImageSample "<>$SessionUUID]
						},
						ImagingDirection->{Top, Side}
					],
					BatchedImagingParameters
				],
				ImagingDirection
			],
			{{Top, Side}, {Top, Side}}
		],
		Example[
			{Options, ImagingDirection, "For Hermetic Opaque bottle, use Side imaging to avoid opening Crimp cap:"},
			Lookup[
				Download[
					ExperimentImageSample[
						Object[Sample, "Test water sample in Opaque Hermetic bottle for ExperimentImageSample " <> $SessionUUID]
					],
					BatchedImagingParameters
				],
				ImagingDirection
			],
			{{Side}}
		],
		
		Example[
			{Options, IlluminationDirection, "Specify the direction from which a sample should be illuminated:"},
			Lookup[
				Download[
					ExperimentImageSample[
						{
							Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
							Object[Sample, "Test water sample in 2mL Tube 2 for ExperimentImageSample "<>$SessionUUID]
						},
						IlluminationDirection->{{Top}, {Side}}
					],
					BatchedImagingParameters
				],
				IlluminationDirection
			],
			{{Top}, {Side}}
		],
		
		Example[
			{Options, IlluminationDirection, "If IlluminationDirection specification is a flat list, it will be auto-expanded to index match the inputs even if it already index-matches:"},
			Lookup[
				Download[
					ExperimentImageSample[
						{
							Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
							Object[Sample, "Test water sample in 2mL Tube 2 for ExperimentImageSample "<>$SessionUUID]
						},
						IlluminationDirection->{Top, Side}
					],
					BatchedImagingParameters
				],
				IlluminationDirection
			],
			{{Top, Side}, {Top, Side}}
		],
		
		Example[
			{Options, Name, "Specify the name of the resultant ImageSample protocol:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
					Name->"Custom named ImageSample protocol for ExperimentImageSample "<>$SessionUUID,
					Output->{Options}
				]],
				Name
			],
			"Custom named ImageSample protocol for ExperimentImageSample "<>$SessionUUID
		],
		
		Example[
			{Options, Template, "Specify an existing ImageSample protocol for use as a template:"},
			Download[
				ExperimentImageSample[
					Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
					Template->templateProtocol
				],
				IlluminationDirections
			],
			{{Top}},
			Variables :> {templateProtocol},
			SetUp :> {
				(* Set up a template protocol with a non-default option value to be inherited *)
				templateProtocol = ExperimentImageSample[
					Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
					IlluminationDirection->{{Top}}
				]
			}
		],
		
		Example[
			{Options, SamplesInStorageCondition, "Specify the storage condition to which the SamplesIn should be returned after imaging:"},
			Download[
				ExperimentImageSample[
					{
						Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
						Object[Sample, "Test water sample in 2mL Tube 2 for ExperimentImageSample "<>$SessionUUID]
					},
					SamplesInStorageCondition->{Freezer, Refrigerator}
				],
				SamplesInStorage
			],
			{Freezer, Refrigerator}
		],
		
		Example[{Options,TargetConcentrationAnalyte,"Specify the analyte whose final concentration is specified:"},
			options=ExperimentImageSample[
				Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
				TargetConcentration->1 Millimolar,
				TargetConcentrationAnalyte->Model[Molecule,"Water"],
				Output->Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Water"]],
			Variables:>{options}
		],
		Example[{Options,SampleLabel,"SampleLabel applies a label to the sample for use in SamplePreparation - label automatically applied:"},
			Lookup[ExperimentImageSample[Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID], Output -> Options], SampleLabel],
			"image sample sample" ~~ ___,
			EquivalenceFunction -> StringMatchQ
		],
		Example[{Options,SampleLabel,"SampleLabel applies a label to the sample for use in SamplePreparation:"},
			Lookup[ExperimentImageSample[Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID], SampleLabel -> "my sample", Output -> Options], SampleLabel],
			"my sample"
		],
		Example[{Options,SampleContainerLabel,"SampleContainerLabel applies a label to the container of the sample for use in SamplePreparation: - label automatically applied:"},
			Lookup[ExperimentImageSample[Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID], Output -> Options], SampleContainerLabel],
			"image sample container" ~~ ___,
			EquivalenceFunction -> StringMatchQ
		],
		Example[{Options,SampleContainerLabel,"SampleContainerLabel applies a label to the container of the sample for use in SamplePreparation:"},
			Lookup[ExperimentImageSample[Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID], SampleContainerLabel -> "my container", Output -> Options], SampleContainerLabel],
			"my container"
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentImageSample[
				Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Test["ExperimentImageSample returns a simulation blob if Output -> Simulation:",
			ExperimentImageSample[Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Output -> Simulation],
			SimulationP
		],
		
		(* === Invalid Input Examples === *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentImageSample[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentImageSample[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentImageSample[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentImageSample[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentImageSample[sampleID, Simulation -> simulationToPassIn, Output -> Options]
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

				ExperimentImageSample[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[
			{Messages, "DiscardedSamples", "If samples are discarded, an error is displayed:"},
			ExperimentImageSample[Object[Sample, "Test discarded sample for ExperimentImageSample "<>$SessionUUID]],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[
			{Messages, "DuplicateName", "If the specified Name already exists in the ECL database, an error is displayed:"},
			ExperimentImageSample[Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID], Name->"LegacyID:451"],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "HazardousSamples", "If all samples are hazardous and it's on Engine, return an empty list without error message:"},
			ExperimentImageSample[Object[Sample, "Test hazardous sample in 100mL glass bottle for ExperimentImageSample "<>$SessionUUID],ImagingDirection->Top],
			{},
			Messages:>{},
			Stubs:>{$ECLApplication=Engine}
		],
		Example[
			{Messages, "HazardousSamples", "If some samples are hazardous to be imaged, an error message is displayed:"},
			ExperimentImageSample[{Object[Sample, "Test hazardous sample in 100mL glass bottle for ExperimentImageSample "<>$SessionUUID],Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID]},ImagingDirection->Top],
			$Failed,
			Messages:>{
				Error::HazardousImaging
			}
		],
		Example[
			{Messages, "HazardousSamples", "Inputs containing mixed-up safe and hazardous samples and ImagingDirection can be successfully resolved:"},
			Download[
				ExperimentImageSample[{Object[Sample,"Test water sample in 15mL tube for ExperimentImageSample " <>$SessionUUID],Object[Sample, "Test hazardous sample in 100mL glass bottle for ExperimentImageSample "<>$SessionUUID],Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID]},ImagingDirection->{{Top,Side},Side,Top}],
				{Length[SamplesIn],ImagingDirections}
			],
			{3, {{Top, Side}, {Side}, {Top}}},
			Messages:>{},
			Stubs:>{$ECLApplication=Engine}
		],
		
		(* === Conflicting Options Tests === *)
		Example[
			{Messages, "OptionMismatch", "If Instrument and ImagingDirection are incompatible, an error is displayed:"},
			ExperimentImageSample[
				Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID], 
				Instrument -> Model[Instrument, PlateImager, "id:n0k9mGzRal41"],
				ImagingDirection -> Side
			],
			$Failed,
			Messages :> {
				Error::OptionMismatch,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "IlluminationOptionMismatch", "If Instrument and IlluminationDirection are incompatible, an error is displayed:"},
			ExperimentImageSample[
				Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID], 
				Instrument -> Model[Instrument, PlateImager, "id:n0k9mGzRal41"],
				IlluminationDirection -> Side
			],
			$Failed,
			Messages :> {
				Error::IlluminationOptionMismatch,
				Error::InvalidOption
			}
		],
		Example[
			{Messages, "ImagingIncompatibleContainer", "Aliquoting is requested for samples in containers whose models are marked Unimageable->True:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample in 96-well Ground Steel MALDI Plate for ExperimentImageSample "<>$SessionUUID],
					Output->{Options}
				]],
				AliquotContainer
			],
			{{1, ObjectP[Model[Container]]}},
			Messages :> {Warning::ImagingIncompatibleContainer, Warning::AliquotRequired},
			Variables :> {currentDeprecationState},
			SetUp :> (
				(* Un-deprecate 300mL robotic reservoir for use in this unit test, then restore its former state later *)
				currentDeprecationState = Download[Model[Container, Plate, "id:Vrbp1jG800Vb"], Deprecated];
				Upload[<|Object->Model[Container, Plate, "id:Vrbp1jG800Vb"], Deprecated->Null|>];
			),
			TearDown :> (	
				Upload[<|Object->Model[Container, Plate, "id:Vrbp1jG800Vb"], Deprecated->currentDeprecationState|>];
			)
		],
		Example[
			{Messages, "AliquotRequired", "If plate imager is specified for imaging of tubes that are not plate imager compatible, samples are aliquoted into compatible tubes if possible and an appropriate warning is displayed:"},
			Lookup[
				First[ExperimentImageSample[
					Object[Sample, "Test water sample in 8x43mm vial for ExperimentImageSample "<>$SessionUUID],
					Instrument->Model[Instrument, PlateImager, "Vision M3 Sample Imager"],
					Output->{Options}
				]],
				AliquotContainer
			],
			{{1, Model[Container, Vessel, "id:eGakld01zzpq"]}},
			Messages :> {Warning::AliquotRequired}
		],
		Example[
			{Messages, "AliquotRequired", "Any samples requiring aliquoting are excluded without additional error if in Engine and ParentProtocol is non-Null:"},
			Download[
				ExperimentImageSample[
					{
						Object[Sample, "Test water sample in 96-well Ground Steel MALDI Plate for ExperimentImageSample "<>$SessionUUID],
						Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID]
					},
					ParentProtocol -> Object[Protocol, Centrifuge, "id:8qZ1VWNvxmnD"]
				],
				SamplesIn
			],
			{_?(SameObjectQ[#, Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID]]&)},
			Stubs :> {$ECLApplication=Engine},
			Variables :> {currentDeprecationState},
			SetUp :> (
				(* Un-deprecate 300mL robotic reservoir for use in this unit test, then restore its former state later *)
				currentDeprecationState = Download[Model[Container, Plate, "id:Vrbp1jG800Vb"], Deprecated];
				Upload[<|Object->Model[Container, Plate, "id:Vrbp1jG800Vb"], Deprecated->Null|>];
			),
			TearDown :> (	
				Upload[<|Object->Model[Container, Plate, "id:Vrbp1jG800Vb"], Deprecated->currentDeprecationState|>];
			)
		],
		Example[
			{Messages, "PreferredIlluminationIncompatible", "If a sample container's PreferredIllumination field cannot be satisfied given other experimental constraints, a warning message is displayed:"},
			ExperimentImageSample[
				Object[Sample, "Test water sample in tube with PreferredIllumination->Side for ExperimentImageSample "<>$SessionUUID], 
				Instrument -> Model[Instrument, PlateImager, "id:n0k9mGzRal41"]
			],
			ObjectP[Object[Protocol, ImageSample]],
			Messages :> {Warning::PreferredIlluminationIncompatible}
		],


		Example[{Messages,"ImageSampleInvalidAlternateInstruments","Instrument model already specified as Instrument option cannot be included in AlternateInstruments option:"},
			ExperimentImageSample[
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
				Instrument->Model[Instrument,PlateImager,"id:n0k9mGzRal41"],
				AlternateInstruments->{Model[Instrument,PlateImager,"id:n0k9mGzRal41"],Model[Instrument,PlateImager,"id:Z1lqpMzwbxEo"]}
			],
			$Failed,
			Messages:>{
				Error::ImageSampleInvalidAlternateInstruments,
				Error::InvalidOption
			}
		],

		Test["AlternateInstruments cannot be specified when Instrument option is an instrument object:",
			ExperimentImageSample[
				Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],
				Instrument->Object[Instrument,PlateImager,"id:XnlV5jmbZWMz"],
				AlternateInstruments->{Model[Instrument,PlateImager,"id:Z1lqpMzwbxEo"]}
			],
			$Failed,
			Messages:>{
				Error::ImageSampleInvalidAlternateInstruments,
				Error::InvalidOption
			}
		],
		
		(* === Tests === *)
		Test[
			"If IlluminationDirection is not specified but container has PreferredIllumination populated, it is used if it is compatible with the selected instrument:",
			Download[
				ExperimentImageSample[Object[Container, Vessel, "Test 8x43mm Vial for ExperimentImageSample "<>$SessionUUID]],
				IlluminationDirections
			],
			{{Side}}
		],		
		Test[
			"Exposure time is resolved successfully for cases where IlluminationDirection contains multiple non-Ambient light sources:",
			Lookup[
				Download[
					ExperimentImageSample[
						Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID],
						IlluminationDirection -> {Top, Bottom}
					],
					BatchedImagingParameters
				],
				ExposureTime
			],
			{10.` Millisecond}	
		],
		Test[
			"Exposure time is resolved successfully for cases where IlluminationDirection contains multiple non-Ambient light sources but also includes Ambient (which does nothing in this case):",
			Lookup[
				Download[
					ExperimentImageSample[
						Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID],
						IlluminationDirection -> {Top, Bottom, Ambient}
					],
					BatchedImagingParameters
				],
				ExposureTime
			],
			{10.` Millisecond}
		],		
		Test[
			"Exposure time resolves to 500 Milliseconds when the only light source is Ambient:",
			Lookup[
				Download[
					ExperimentImageSample[
						Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID],
						IlluminationDirection -> {Ambient}
					],
					BatchedImagingParameters
				],
				ExposureTime
			],
			{500.` Millisecond}	
		],
		Test[
			"Exposure time resolves to 200 Milliseconds when the only light source is Ambient and we are at CMU:",
			Lookup[
				Download[
					ExperimentImageSample[
						Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID],
						IlluminationDirection -> {Ambient},
						Site->Object[Container, Site, "id:P5ZnEjZpRlK4"]
					],
					BatchedImagingParameters
				],
				ExposureTime
			],
			{200.` Millisecond}
		],
		Test[
			"ImageContainers is index matched to ContainersIn:",
			Download[
				ExperimentImageSample[Object[Container, Plate, "Test DWP for ExperimentImageSample "<>$SessionUUID]],
				ImageContainers
			],
			{False}
		],		
		Test[
			"Zoomed-in camera (22mm FOV) is used on the plate imager for 96-well plates:",
			Lookup[
				Download[
					ExperimentImageSample[Object[Sample, "Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID]],
					BatchedImagingParameters
				],
				FieldOfView
			],
			{22 Millimeter}	
		],		
		Test[
			"Zoomed-in camera (22mm FOV) is used on the plate imager for 384-well plates:",
			Lookup[
				Download[
					ExperimentImageSample[Object[Sample, "Test water sample in 384-well plate for ExperimentImageSample "<>$SessionUUID]],
					BatchedImagingParameters
				],
				FieldOfView
			],
			{22 Millimeter}	
		],		
		Test[
			"Zoomed-out camera (35mm FOV) is used on the plate imager for imaging tubes in 48-position racks:",
			Lookup[
				Download[
					ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID]],
					BatchedImagingParameters
				],
				FieldOfView
			],
			{35 Millimeter}	
		],
		
		
		
		(* === FUNTOPIA SHARED EXAMPLES === *)
		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESNT BUG ON THIS. *)
		Example[{Options, PreparatoryUnitOperations, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			protocol = ExperimentImageSample[
				{"caffeine sample 1", "caffeine sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "caffeine sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "caffeine sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 1", Amount -> 500*Milligram],
					Transfer[Source -> Model[Sample, "Caffeine"], Destination -> "caffeine sample 2", Amount -> 300*Milligram]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentImageSample[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container,Vessel,"id:3em6Zv9NjjN8"],(*2mL Tube*)
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
				{ObjectP[Model[Container,Vessel,"id:3em6Zv9NjjN8"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentImageSample[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, ImageSample]]
		],
		Example[{Options, Incubate, "Set the Incubate option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Set the IncubationTemperature option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Set the IncubationTime option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Set the MaxIncubationTime option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Set the IncubationInstrument option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the AnnealingTime option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Set the IncubateAliquot option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], IncubateAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Set the IncubateAliquotContainer option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Set the IncubateAliquotDestinationWell option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, Mix, "Set the Mix option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Set the MixType option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Set the MixUntilDissolved option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* centrifuge options *)
		Example[{Options, Centrifuge, "Set the Centrifuge option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "Set the CentrifugeInstrument option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "Set the CentrifugeIntensity option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "Set the CentrifugeTime option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "Set the CentrifugeTemperature option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID], CentrifugeTemperature -> 10*Celsius, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "Set the CentrifugeAliquot option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], CentrifugeAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "Set the CentrifugeAliquotContainer option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Set the CentrifugeAliquotDestinationWell option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Set the Filtration option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Set the FiltrationType option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Set the FilterInstrument option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Set the Filter option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "Set the FilterMaterial option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID], FilterMaterial -> PTFE, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, FilterMaterial],
			PTFE,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Set the PrefilterMaterial option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Set the PrefilterPoreSize option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID], FilterMaterial -> PTFE, PrefilterPoreSize -> 1.*Micrometer, AliquotAmount -> 100*Microliter, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Set the FilterPoreSize option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Set the FilterSyringe option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option resolves to Null because it can't be used reasonably for volumes we would use in this experiment:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Set the FilterIntensity option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Set the FilterTime option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the FilterTemperature option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Set the FilterSterile option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "Set the FilterAliquot option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FilterAliquot -> 80*Microliter, Output -> Options];
			Lookup[options, FilterAliquot],
			80*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Set the FilterAliquotContainer option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterAliquotDestinationWell, "Set the FilterAliquotDestinationWell option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], FilterAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Set the FilterContainerOut option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Set the Aliquot option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Set the AliquotAmount option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Set the AssayVolume option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Set the TargetConcentration option:"},
			options = ExperimentImageSample[Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Set the ConcentratedBuffer option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "Set the BufferDilutionFactor option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "Set the BufferDiluent option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Set the AssayBuffer option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 50*Microliter, AssayVolume -> 100*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleLabel, "Set the AliquotSampleLabel option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Aliquot -> True,AliquotSampleLabel -> "Water Aliquot", Output -> Options];
			Lookup[options, AliquotSampleLabel],
			{"Water Aliquot"},
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the AliquotSampleStorageCondition option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Set the ConsolidateAliquots option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Set the AliquotPreparation option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "Set the AliquotContainer option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], AliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "Set the DestinationWell option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A1"},
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Set the MeasureWeight option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Set the MeasureVolume option:"},
			options = ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		
		],
		
		Test[
			"Function runs properly on typeless, modelless samples:",
			ExperimentImageSample[Object[Sample, "Test water sample with no subtype and no model for ExperimentImageSample "<>$SessionUUID]],
			ObjectP[Object[Protocol, ImageSample]]
		],
		(*If there is Living sample in the input, and it has a non-stocksolution parent protocol, quietly filter the sample out, and if no sample is left, return failed to proceed*)
		Test[
			"Living samples will be filtered out if there is a parent non-stocksolution protocol:",
			ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],ParentProtocol->Object[Protocol, Centrifuge, "id:8qZ1VWNvxmnD"]],
			$Failed,
			SetUp:>(Upload[<|Object->Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],Living->True|>]),
			TearDown:>(Upload[<|Object->Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],Living->Null|>])
		],
		(*If there is Sterile sample in the input, and it has a non-stocksolution parent protocol, quietly filter the sample out, and if no sample is left, return failed to proceed*)
		Test[
			"Sterile samples will be filtered out if there is a parent non-stocksolution protocol:",
			Download[ExperimentImageSample[{
				Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],
				Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID]
			},ParentProtocol->Object[Protocol, Centrifuge, "id:8qZ1VWNvxmnD"]],
				{Object,SamplesIn}],
			{
				ObjectP[Object[Protocol,ImageSample]],
				{ObjectP[Object[Sample, "Test water sample in 50mL tube for ExperimentImageSample "<>$SessionUUID]]}
			},
			SetUp:>(Upload[<|Object->Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],Sterile->True|>]),
			TearDown:>(Upload[<|Object->Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],Sterile->Null|>])
		],
		(*If there is Living or Sterile sample in the input, and it has a parent stock solution protocol, the sample is not filtered out*)
		Test[
			"Sterile/Living samples will not be filtered out if the parent protocol is stocksolution:",
			Download[ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],ParentProtocol->Object[Protocol,StockSolution,"Test StockSolution protocol for ExperimentImageSample " <> $SessionUUID]],
				{Object,SamplesIn}],
			{
				ObjectP[Object[Protocol,ImageSample]],
				{ObjectP[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID]]}
			},
			SetUp:>(Upload[<|Object->Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],Sterile->True|>]),
			TearDown:>(Upload[<|Object->Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],Sterile->Null|>])
		],
		(*If there is Living or Sterile sample in the input, and it does not have a parent protocol, the sample is not filtered out*)
		Test[
			"Sterile/Living samples will not be filtered out if there is no parent protocol:",
			Download[ExperimentImageSample[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID]],
				{Object,SamplesIn}],
			{
				ObjectP[Object[Protocol,ImageSample]],
				{ObjectP[Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID]]}
			},
			SetUp:>(Upload[<|Object->Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],Living->True|>]),
			TearDown:>(Upload[<|Object->Object[Sample, "Test water sample in 2mL Tube 1 for ExperimentImageSample "<>$SessionUUID],Living->Null|>])
		],
		(*If there is Living or Sterile sample in the input, the sample is in a plate, and it does not have a parent protocol, a warning is thrown *)
		Test[
			"A warning is thrown if there is Living samples in a plate when there is no parent protocol, but a protocol can still be generated:",
		Download[ExperimentImageSample[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID]],
			{Object, SamplesIn}
			],
			{
				ObjectP[Object[Protocol,ImageSample]],
				{ObjectP[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID]]}
			},
			Messages:>{Warning::LivingOrSterileSamplesInPlateQueuedForImaging},
			SetUp:>(Upload[<|Object->Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],Living->True|>]),
			TearDown:>(Upload[<|Object->Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],Living->Null|>])
		],
		Test[
			"A warning is thrown if there is Sterile samples in a plate when there is no parent protocol, but a protocol can still be generated:",
			Download[ExperimentImageSample[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID]],
				{Object, SamplesIn}
				],
			{
				ObjectP[Object[Protocol,ImageSample]],
				{ObjectP[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID]]}
			},
			Messages:>{Warning::LivingOrSterileSamplesInPlateQueuedForImaging},
			SetUp:>(Upload[<|Object->Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],Sterile->True|>]),
			TearDown:>(Upload[<|Object->Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],Sterile->Null|>])
		]
		(*Test[
			"If imaging standalone and a container transfer will be necessary, a warning is displayed:"
		]
		*)
		
		(* This shouldn't pass without error:
		ExperimentImageSample[Object[Sample,"Test water sample 1 in 96 deep-well plate for ExperimentImageSample "<>$SessionUUID],IlluminationDirection->Side]*)
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		InternalExperiment`Private`imageSampleTestSampleSetup["ExperimentImageSample"];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];



(* ::Subsection::Closed:: *)
(*ExperimentImageSampleOptions*)


DefineTests[ExperimentImageSampleOptions,
	{
		Example[{Basic,"Returns the options in table form given a sample:"},
			ExperimentImageSampleOptions[
				Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSampleOptions "<>$SessionUUID]
			],
			_Grid,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, returns the options as a list of rules:"},
			ExperimentImageSampleOptions[
				Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSampleOptions "<>$SessionUUID],
				OutputFormat->List
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "View any potential issues with provided inputs/options displayed:"},
			ExperimentImageSampleOptions[
				Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSampleOptions "<>$SessionUUID],
				Instrument->Object[Instrument,PlateImager,"id:XnlV5jmbZWMz"],
				AlternateInstruments->{Model[Instrument,PlateImager,"id:Z1lqpMzwbxEo"]}
			],
			_Grid,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages :> {
				Error::ImageSampleInvalidAlternateInstruments,
				Error::InvalidOption
			}
		]
	},


	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		InternalExperiment`Private`imageSampleTestSampleSetup["ExperimentImageSampleOptions"];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*ExperimentImageSamplePreview*)

DefineTests[ExperimentImageSamplePreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentImageSample:"},
			ExperimentImageSamplePreview[
				Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSamplePreview "<>$SessionUUID]
			],
			Null,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentImageSampleOptions:"},
			ExperimentImageSampleOptions[
				Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSamplePreview "<>$SessionUUID]
			],
			_Grid,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentImageSampleQ:"},
			ValidExperimentImageSampleQ[
				Object[Sample,"Test water sample in 2mL Tube 1 for ExperimentImageSamplePreview "<>$SessionUUID]
			],
			BooleanP,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		]
	},


	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		InternalExperiment`Private`imageSampleTestSampleSetup["ExperimentImageSamplePreview"];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*ValidExperimentImageSampleQ*)


DefineTests[ValidExperimentImageSampleQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of an ExperimentImageSample experimental setup on a sample:"},
			ValidExperimentImageSampleQ[
				Object[Sample,"Test water sample in 2mL Tube 1 for ValidExperimentImageSampleQ "<>$SessionUUID]
			],
			BooleanP,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Return False if there are problems with the inputs or options:"},
			ValidExperimentImageSampleQ[
				Object[Sample,"Test water sample in 2mL Tube 1 for ValidExperimentImageSampleQ "<>$SessionUUID],
				Instrument->Object[Instrument,PlateImager,"id:XnlV5jmbZWMz"],
				AlternateInstruments->{Model[Instrument,PlateImager,"id:Z1lqpMzwbxEo"]}
			],
			BooleanP,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentImageSampleQ[
				Object[Sample,"Test water sample in 2mL Tube 1 for ValidExperimentImageSampleQ "<>$SessionUUID],
				Verbose->True
			],
			BooleanP,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentImageSampleQ[
				Object[Sample,"Test water sample in 2mL Tube 1 for ValidExperimentImageSampleQ "<>$SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$EmailEnabled=False
	},


	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		InternalExperiment`Private`imageSampleTestSampleSetup["ValidExperimentImageSampleQ"];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection:: *)
(* ImageSample *)
DefineTests[ImageSample,
	{
		Example[{Basic,"Form an ImageSample unit operation:"},
		    ImageSample[
				Sample -> Object[Sample, "Test water sample 1 in 96 deep-well plate for ImageSample "<>$SessionUUID],
				Instrument->Object[Instrument, SampleImager, "Inspector Clouseau"],
				ImageContainer->True
			],
		    ImageSampleP
		],
		Example[{Basic,"Specifying a key incorrectly will not form a unit operation:"},
			primitive = ImageSample[
				Sample -> Object[Sample, "Test water sample 1 in 96 deep-well plate for ImageSample "<>$SessionUUID],
				Instrument->Model[Container, Plate, "id:L8kPEjkmLbvW"],
				ImageContainer->True
			];
			MatchQ[primitive, SamplePreparationP],
			False,
			Variables -> {primitive}
		],
		Example[{Basic,"A protocol is generated when the unit op is inside an MSP:"},
		    ExperimentManualSamplePreparation[
				{
					ImageSample[
						Sample -> Object[Sample, "Test water sample 1 in 96 deep-well plate for ImageSample "<>$SessionUUID]
					]
				}
			],
		    ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[{Basic,"A protocol is generated when the unit op is given labels as input:"},
		    ExperimentManualSamplePreparation[
				{
					LabelSample[
						Sample -> Model[Sample, "Milli-Q water"],
						Container -> Model[Container, Vessel, "2mL Tube"],
						Amount -> 1 Milliliter,
						Label -> "my sample"
					],
					ImageSample[
						Sample -> "my sample",
						ImageContainer -> True
					]
				}
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[{Basic,"A protocol is generated when the output of the image sample is passed to another unit op using a label:"},
			ExperimentManualSamplePreparation[
				{
					ImageSample[
						Sample -> Object[Sample, "Test water sample 1 in 96 deep-well plate for ImageSample "<>$SessionUUID],
						ImageContainer -> True,
						SampleLabel -> "my imaged sample"
					],
					Transfer[
						Source -> "my imaged sample",
						Destination -> Model[Container, Vessel, "2mL Tube"],
						Amount -> 0.5 Milliliter
					]
				}
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		InternalExperiment`Private`imageSampleTestSampleSetup["ImageSample"];
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	)
];
(* ::Subsection::Closed:: *)
(* AcquireImage *)
DefineTests[AcquireImage,
    {
		Example[
			{Basic,"Use AcquireImage to image multiple samples with the same sets of imaging parameters:"},
			ExperimentImageCells[
				{Object[Sample,"AcquireImage Test Sample 1-"<>$SessionUUID],Object[Sample,"AcquireImage Test Sample 2-"<>$SessionUUID]},
				ObjectiveMagnification->10,
				Images->{
					AcquireImage[
						Mode->Epifluorescence,
						ExcitationWavelength->477 Nanometer,
						EmissionWavelength->520 Nanometer
					],
					AcquireImage[
						Mode->Epifluorescence,
						ExcitationWavelength->405 Nanometer,
						EmissionWavelength->452 Nanometer
					],
					AcquireImage[
						Mode->BrightField,
						TransmittedLightPower->20 Percent
					]
				}
			],
			ObjectP[Object[Protocol,ImageCells]]
		],
        Example[{Basic,"Use Mode->Epifluorescence to take two images the first sample and Model->BrightField to take two images of the second sample:"},
			ExperimentImageCells[
				{Object[Sample,"AcquireImage Test Sample 1-"<>$SessionUUID],Object[Sample,"AcquireImage Test Sample 2-"<>$SessionUUID]},
				ObjectiveMagnification->{4,10},
				Images->{
					{
						AcquireImage[
							Mode->Epifluorescence,
							ExcitationWavelength->477 Nanometer,
							EmissionWavelength->520 Nanometer
						],
						AcquireImage[
							Mode->Epifluorescence,
							ExcitationWavelength->405 Nanometer,
							EmissionWavelength->452 Nanometer
						]
					},
					{
						AcquireImage[
							Mode->BrightField,
							TransmittedLightPower->20 Percent
						],
						AcquireImage[
							Mode->BrightField,
							TransmittedLightPower->50 Percent
						]
					}
				}
			],
			ObjectP[Object[Protocol,ImageCells]]
		],
		Example[{Basic,"For the first two samples use Mode->Epifluorescence two take two images of each sample. Take two BrightField images of the last sample:"},
			ExperimentImageCells[
				{
					{
						Object[Sample,"AcquireImage Test Sample 1-"<>$SessionUUID],
						Object[Sample,"AcquireImage Test Sample 2-"<>$SessionUUID]
					},
					Object[Sample,"AcquireImage Test Sample 3-"<>$SessionUUID]
				},
				ObjectiveMagnification->{4,10},
				Images->{
					{
						AcquireImage[
							Mode->Epifluorescence,
							ExcitationWavelength->477 Nanometer,
							EmissionWavelength->520 Nanometer
						],
						AcquireImage[
							Mode->Epifluorescence,
							ExcitationWavelength->405 Nanometer,
							EmissionWavelength->452 Nanometer
						]
					},
					{
						AcquireImage[
							Mode->BrightField,
							TransmittedLightPower->20 Percent
						],
						AcquireImage[
							Mode->BrightField,
							TransmittedLightPower->50 Percent
						]
					}
				}
			],
			ObjectP[Object[Protocol,ImageCells]]
		]
    },
	SymbolSetUp:>Module[{tubePacket,tube1,tube2,tube3},
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		tubePacket=<|Type->Object[Container,MicroscopeSlide],Model->Link[Model[Container, MicroscopeSlide, "id:1ZA60vLVWzqa"],Objects],Site->Link[$Site],DeveloperObject->True|>;
		{tube1,tube2,tube3}=Upload[{tubePacket,tubePacket,tubePacket}];
		UploadSample[
			{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
			{{"A1",tube1},{"A1",tube2},{"A1",tube3}},
			InitialAmount->1 Microliter,
			Name->{
				"AcquireImage Test Sample 1-"<>$SessionUUID,
				"AcquireImage Test Sample 2-"<>$SessionUUID,
				"AcquireImage Test Sample 3-"<>$SessionUUID
			}
		]
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	]
]