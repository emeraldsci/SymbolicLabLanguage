(* ::Package:: *)

(* ::Title:: *)
(*simulateReadPlateExperiment: Source*)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*Constant*)
readPlateExperimentProtocolTypes = {
	Object[Protocol, AbsorbanceSpectroscopy],
	Object[Protocol, AbsorbanceIntensity],
	Object[Protocol, AbsorbanceKinetics],

	Object[Protocol, LuminescenceSpectroscopy],
	Object[Protocol, LuminescenceIntensity],
	Object[Protocol, LuminescenceKinetics],

	Object[Protocol, FluorescenceSpectroscopy],
	Object[Protocol, FluorescenceIntensity],
	Object[Protocol, FluorescenceKinetics],
	Object[Protocol, FluorescencePolarization],
	Object[Protocol, FluorescencePolarizationKinetics],

	Object[Protocol, Nephelometry],
	Object[Protocol, NephelometryKinetics],

	Object[Protocol, AlphaScreen]
};

(* ::Subsection:: *)
(*Options*)
DefineOptions[
	simulateReadPlateExperiment,
	Options:>{CacheOption,SimulationOption}
];

(* ::Subsection:: *)
(*simulateReadPlateExperiment Error Messages*)

(* ::Subsection:: *)
(*simulateReadPlateExperiment*)
simulateReadPlateExperiment[
	myProtocolType:Apply[Alternatives, readPlateExperimentProtocolTypes],
	myResourcePacket:(PacketP[readPlateExperimentProtocolTypes, {Object, ResolvedOptions}]|$Failed|Null),
	myUnitOperationPackets:({PacketP[]...}|$Failed),
	mySamples:{ObjectP[Object[Sample]]..},
	myResolvedOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[simulateReadPlateExperiment]
]:=Module[
	{
		cache, simulation, samplePackets, protocolObject, fulfillmentSimulation, updatedSimulation, nephelometryQ,
		alphaQ, kineticsQ, fluorescenceQ,

		(* Download *)
		injectionDownloadSpec, blankField, fieldSpec,
		protPacket, instrumentPacket, instrumentModelPacket, instrumentWastePacket, instrumentSecondaryWastePacket, workingSamplePacket,
		workingSampleContainerPacket, workingSampleContainerModelPacket, workingContainerPacket, blankPackets, line1PrimaryPurgingPacket,
		line1SecondaryPurgingPacket, line2PrimaryPurgingPacket, line2SecondaryPurgingPacket, opticModulePacket, moatBufferModelPacket,
		controlSamplePacket, primaryInjectionPacket, secondaryInjectionPacket, tertiaryInjectionPacket, quaternaryInjectionPacket,
		focalHeightOptimizationSamplesPacket, gainOptimizationSamplesPacket,

		(* Moat *)
		moatPackets, optimizationSamplePackets,

		(* General Information *)
		absorbanceQ, temperature, equilibrationTime,

		(* Plate Reader *)
		plateReader, chipRack, blankContainers, blankVolumes,

		(* Sample Injection Prepping, Priming, Flushing *)
		injectionUpdatePackets,

		resolvedPreparation,simulationWithLabels,expandedBlankLabelsWithReplicates,blankLinkField,prepProtocolType,resolvedWorkCell
	},

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[Null]];

	(* Download containers from our sample packets. *)
	samplePackets=Download[
		mySamples,
		Packet[Container],
		Cache->cache,
		Simulation->simulation
	];

	(* lookup Preparation *)
	resolvedPreparation = Lookup[myResolvedOptions,Preparation];

	(* Lookup WorkCell to determine if RSP or RCP should be used. *)
	resolvedWorkCell = Lookup[myResolvedOptions,WorkCell];
	prepProtocolType = If[MatchQ[resolvedWorkCell,bioSTAR|microbioSTAR],
		Object[Protocol,RoboticCellPreparation],
		Object[Protocol,RoboticSamplePreparation]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[
		(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
		(* simulate an ID here in the simulation function in order to call SimulateResources. *)
		MatchQ[resolvedPreparation, Robotic],
		SimulateCreateID[prepProtocolType],
		(* NOTE: If myResourcePacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myResourcePacket, $Failed|Null],
		SimulateCreateID[myProtocolType],
		True,
		Lookup[myResourcePacket, Object]
	];

	(* Check if we are dealing with absorbance or Nephelometry experiments *)
	absorbanceQ = MatchQ[
		myProtocolType,
		Alternatives[Object[Protocol, AbsorbanceSpectroscopy], Object[Protocol, AbsorbanceIntensity], Object[Protocol, AbsorbanceKinetics]]
	];
	nephelometryQ = MatchQ[
		myProtocolType,
		Alternatives[Object[Protocol, Nephelometry], Object[Protocol, NephelometryKinetics]]
	];
	fluorescenceQ = MatchQ[
		myProtocolType,
		Alternatives[
			Object[Protocol, LuminescenceSpectroscopy],
			Object[Protocol, LuminescenceIntensity],
			Object[Protocol, LuminescenceKinetics],

			Object[Protocol, FluorescenceSpectroscopy],
			Object[Protocol, FluorescenceIntensity],
			Object[Protocol, FluorescenceKinetics],
			Object[Protocol, FluorescencePolarization],
			Object[Protocol, FluorescencePolarizationKinetics]
		]
	];
	kineticsQ = MatchQ[
		myProtocolType,
		Alternatives[
			Object[Protocol, NephelometryKinetics],
			Object[Protocol, FluorescenceKinetics],
			Object[Protocol, FluorescencePolarizationKinetics],
			Object[Protocol, LuminescenceKinetics],
			Object[Protocol, AbsorbanceKinetics]
		]
	];
	alphaQ = MatchQ[myProtocolType, Object[Protocol, AlphaScreen]];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	fulfillmentSimulation=Which[
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		MatchQ[myResourcePacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
		Module[{protocolPacket},
			protocolPacket=<|
				Object->protocolObject,
				Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[myUnitOperationPackets, Object],
				ResolvedOptions->{}
			|>;

			SimulateResources[protocolPacket, myUnitOperationPackets, ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->Lookup[ToList[myResolutionOptions], Simulation, Null]]
		],

		MatchQ[myResourcePacket, $Failed],
		SimulateResources[
			<|
				Object->protocolObject,
				Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
				ResolvedOptions->myResolvedOptions
			|>,
			Cache->cache,
			Simulation->simulation
		],

		True,
		SimulateResources[
			myResourcePacket,
			Cache->cache,
			Simulation->simulation
		]
	];

	(* Update simulation with fulfillment simulation *)
	updatedSimulation = UpdateSimulation[simulation, fulfillmentSimulation];

	(* If our option resolver/resource packets failed, don't attempt the simulation. Since we're not generative, this *)
	(* doesn't really do any harm. *)
	If[MatchQ[myResourcePacket, $Failed],
		Return[{protocolObject, updatedSimulation}];
	];

	(* ================== *)
	(* ==== Download ==== *)
	(* ================== *)

	(* Download injection sample containers -
	Kinetics experiment field is in the form {time, sample, volume};
	everything else is in the form {sample, volume} *)
	(* Download: 20/21/22/23 *)
	injectionDownloadSpec=If[MatchQ[myResourcePacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
		If[!kineticsQ,
			{
				Packet[PrimaryInjectionSample[{Model, Container}]],
				Packet[SecondaryInjectionSample[{Model, Container}]],
				Null,
				Null
			},
			{
				Packet[PrimaryInjectionSample[{Model, Container}]],
				Packet[SecondaryInjectionSample[{Model, Container}]],
				Packet[TertiaryInjectionSample[{Model, Container}]],
				Packet[QuaternaryInjectionSample[{Model, Container}]]
			}
		],
		If[!kineticsQ,
			{
				Packet[Field[PrimaryInjections[[All,1]]][{Model, Container}]],
				Packet[Field[SecondaryInjections[[All,1]]][{Model, Container}]],
				Null,
				Null
			},
			{
				Packet[Field[PrimaryInjections[[All,2]]][{Model, Container}]],
				Packet[Field[SecondaryInjections[[All,2]]][{Model, Container}]],
				Packet[Field[TertiaryInjections[[All,2]]][{Model, Container}]],
				Packet[Field[QuaternaryInjections[[All,2]]][{Model, Container}]]
			}
		]
	];

	(* Every Blank field is called Blanks, except when dealing with robotic nephlometry, since the option is different in *)
	(* ExperimentNephelometry and the UnitOperation object follows the option name. *)
	blankField = Which[
		nephelometryQ && MatchQ[resolvedPreparation, Robotic],
		BlankLink,
		MatchQ[resolvedPreparation, Robotic],
		BlanksLink,
		True,
		Blanks
	];

	(* All download values! *)
	fieldSpec = If[MatchQ[myResourcePacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
		Join[
			{
				(* 1. Unit op *)
				Packet[
					(* General *)
					Type, Mode, SampleLink, Instrument, TemperatureReal, EquilibrationTime, NumberOfReplicates, TargetPolarization, PreparedPlate,

					(* Adjustment sample *)
					AdjustmentSampleLink,

					(* Blank *)
					BlankContainers, BlankVolumes, BlankVolume,

					(* WaveLength *)
					Wavelength, MinWavelength, MaxWavelength, EmissionWavelengthRange, ExcitationWavelengthRange,
					WavelengthSelection, ExcitationWavelengths, EmissionWavelengths, DualEmissionWavelengths,
					EmissionWavelength, ExcitationWavelength, AdjustmentEmissionWavelength, AdjustmentExcitationWavelength,
					MinEmissionWavelength, MaxEmissionWavelength, MinExcitationWavelength, MaxExcitationWavelength,

					(* Focal *)
					FocalHeight, AutoFocalHeight, IntegrationTime,

					(* Gains *)
					Gains, GainPercentages, DualEmissionGains, DualEmissionGainPercentages, EmissionScanGain, EmissionScanGainPercentage, ExcitationScanGain, ExcitationScanGainPercentage, Gain, GainPercentage,

					(* Microfluidic Chip *)
					MicrofluidicChipRack, MicrofluidicChips, EquilibrationSample,

					(* Plate Reader *)
					PlateReaderMix, PlateReaderMixRate, PlateReaderMixTime, PlateReaderMixMode, PlateReaderMixSchedule, OpticModules,

					(* Sample Injections *)
					PrimaryInjectionSample, SecondaryInjectionSample, TertiaryInjectionSample, QuaternaryInjectionSample,
					PrimaryInjectionVolume, SecondaryInjectionVolume, TertiaryInjectionVolume, QuaternaryInjectionVolume,

					(* Reading *)
					ReadDirection, ReadLocation, ReadOrder, RunTime, ReadTime, DelayTime, NumberOfReadings,
					SamplingPattern, SamplingDistance, SamplingDimension,

					(* Moat Related *)
					MoatVolume, MoatSize, MoatBuffer,

					(* Optimization Samples *)
					GainOptimizationSamples, NumberOfGainOptimizations, FocalHeightOptimizationSamples, NumberOfFocalHeightOptimizations, AlphaAssayVolume
				],

				(* 2. Instrument *)
				Packet[Instrument[{Object,Name,DefaultMethodFilePath,DefaultDataFilePath,OpticModules, InjectorVolume, WasteType}]],

				(* 3. Instrument Model *)
				Packet[Instrument[Model][{Object,Name,DefaultMethodFilePath,DefaultDataFilePath,OpticModules, InjectorVolume, WasteType}]],

				(* 4/5. Instrument Derived fields *)
				Packet[Instrument[WasteContainer][{Contents,Status,Model}]],
				Packet[Instrument[SecondaryWasteContainer][{Contents,Status,Model}]],

				(* 6. WorkingSamples *)
				Packet[SampleLink[{Container, Model, Name, Volume, Position}]],

				(* 7. WorkingSample Containers *)
				Packet[SampleLink[Container][{Model, Contents}]],

				(* 8. WorkingSample Derived fields *)
				Packet[SampleLink[Container][Model][Positions]],

				(* 9. WorkingContainers *)
				Packet[SampleLink[Container][Contents]],

				(* 10. Blanks *)
				Packet[blankField[{Container, Volume, Position, Model}]],

				(* 11/12. Line1 Purging Solvents *)
				Packet[Line1PrimaryPurgingSolvent[Container]],
				Packet[Line1SecondaryPurgingSolvent[Container]],

				(* 13/14. Line2 Purging Solvents *)
				Packet[Line2PrimaryPurgingSolvent[Container]],
				Packet[Line2SecondaryPurgingSolvent[Container]],

				(* 15. OpticModules *)
				Null,

				(* 16. MoatBuffer Model *)
				Packet[MoatBuffer[Model]],

				(* 17. EquilibrationSample Model *)
				Null,

				(* 18. Gain optimization sample packet *)
				Packet[GainOptimizationSamples[Model]],

				(* 19. Focal height optimization sample packet *)
				Packet[FocalHeightOptimizationSamples[Model]]
			},
			injectionDownloadSpec
		],
		Join[
			{
				(* 1. Protocol *)
				Packet[
					(* General *)
					Type, Mode, SamplesIn, WorkingSamples, WorkingContainers,
					Instrument, Temperature, TemperatureEquilibrationTime,
					NumberOfReplicates,
					ResolvedOptions, TargetPolarization,
					PreparedPlate, Cuvettes,

					(* Adjustment sample *)
					AdjustmentSample, AdjustmentSampleWell,

					(* Blank *)
					BlankContainers, BlankVolumes, BlankVolume,

					(* WaveLength *)
					Wavelengths, MinWavelength, MaxWavelength,
					WavelengthSelection, ExcitationWavelengths, EmissionWavelengths, DualEmissionWavelengths,
					EmissionWavelength, ExcitationWavelength, AdjustmentEmissionWavelength, AdjustmentExcitationWavelength,
					MinEmissionWavelength, MaxEmissionWavelength, MinExcitationWavelength, MaxExcitationWavelength,

					(* Focal *)
					FocalHeight, AutoFocalHeight, IntegrationTime,

					(* Gains *)
					Gains, GainPercentages, DualEmissionGains, DualEmissionGainPercentages, EmissionScanGain, EmissionScanGainPercentage, ExcitationScanGain, ExcitationScanGainPercentage, Gain, GainPercentage,

					(* Microfluidic Chip *)
					MicrofluidicChipRack, MicrofluidicChips, EquilibrationSample,

					(* Plate Reader *)
					PlateReaderMix, PlateReaderMixRate, PlateReaderMixTime, PlateReaderMixMode, PlateReaderMixSchedule, OpticModules,

					(* Sample Injections *)
					PrimaryInjections, SecondaryInjections, TertiaryInjections, QuaternaryInjections,
					PrimaryInjectionVolume, SecondaryInjectionVolume, TertiaryInjectionVolume, QuaternaryInjectionVolume,

					(* Reading *)
					ReadDirection, ReadLocation, ReadOrder, RunTime, ReadTime, DelayTime, NumberOfReadings,
					SamplingPattern, SamplingDistance, SamplingDimension,

					(* Moat Related *)
					MoatVolume, MoatSize, MoatBuffer,

					(* Optimization Samples *)
					GainOptimizationSamples, NumberOfGainOptimizations, FocalHeightOptimizationSamples, NumberOfFocalHeightOptimizations, AlphaAssayVolume, OpticsOptimizationContainer
				],

				(* 2. Instrument *)
				Packet[Instrument[{Object,Name,DefaultMethodFilePath,DefaultDataFilePath,OpticModules, InjectorVolume, WasteType}]],

				(* 3. Instrument Model *)
				Packet[Instrument[Model][{Object,Name,DefaultMethodFilePath,DefaultDataFilePath,OpticModules, InjectorVolume, WasteType}]],

				(* 4/5. Instrument Derived fields *)
				Packet[Instrument[WasteContainer][{Contents,Status,Model}]],
				Packet[Instrument[SecondaryWasteContainer][{Contents,Status,Model}]],

				(* 6. WorkingSamples *)
				Packet[WorkingSamples[{Container, Model, Name, Volume, Position}]],

				(* 7. WorkingSample Containers *)
				Packet[WorkingSamples[Container][{Model, Contents}]],

				(* 8. WorkingSample Derived fields *)
				Packet[WorkingSamples[Container][Model][Positions]],

				(* 9. WorkingContainers *)
				Packet[ContainersIn[Contents]],

				(* 10. Blanks *)
				Packet[blankField[{Container, Volume, Position, Model, Composition}]],

				(* 11/12. Line1 Purging Solvents *)
				Packet[Line1PrimaryPurgingSolvent[Container]],
				Packet[Line1SecondaryPurgingSolvent[Container]],

				(* 13/14. Line2 Purging Solvents *)
				Packet[Line2PrimaryPurgingSolvent[Container]],
				Packet[Line2SecondaryPurgingSolvent[Container]],

				(* 15. OpticModules *)
				Packet[OpticModules[Name]],

				(* 16. MoatBuffer Model *)
				Packet[MoatBuffer[Model]],

				(* 17. EquilibrationSample Model *)
				Packet[EquilibrationSample[Model]],

				(* 18. Gain optimization sample packet *)
				Packet[GainOptimizationSamples[Model]],

				(* 19. Focal height optimization sample packet *)
				Packet[FocalHeightOptimizationSamples[Model]]
			},
			injectionDownloadSpec
		]
	];

	{
		(*1*)protPacket,
		(*2*)instrumentPacket,
		(*3*)instrumentModelPacket,
		(*4*)instrumentWastePacket,
		(*5*)instrumentSecondaryWastePacket,
		(*6*)workingSamplePacket,
		(*7*)workingSampleContainerPacket,
		(*8*)workingSampleContainerModelPacket,
		(*9*)workingContainerPacket,
		(*10*)blankPackets,
		(*11*)line1PrimaryPurgingPacket,
		(*12*)line1SecondaryPurgingPacket,
		(*13*)line2PrimaryPurgingPacket,
		(*14*)line2SecondaryPurgingPacket,
		(*15*)opticModulePacket,
		(*16*)moatBufferModelPacket,
		(*17*)controlSamplePacket,
		(*18*)gainOptimizationSamplesPacket,
		(*19*)focalHeightOptimizationSamplesPacket,

		(* Injection Samples *)
		(*20*)primaryInjectionPacket,
		(*21*)secondaryInjectionPacket,
		(*22*)tertiaryInjectionPacket,
		(*23*)quaternaryInjectionPacket
	} = Quiet[
		Download[
			(* if it's a robotic protocol, download info from the unit op, if not, then from the protocol *)
			If[
				MatchQ[myResourcePacket, Null] && MatchQ[myUnitOperationPackets, {PacketP[]..}],
				Last[Lookup[myUnitOperationPackets, Object]],
				protocolObject
			],
			fieldSpec,
			Cache -> cache,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::MissingCacheField}
	];

	(* Set instrument model packet correctly. *)
	instrumentModelPacket=If[MatchQ[instrumentPacket, ObjectP[Model[]]],
		instrumentPacket,
		instrumentModelPacket
	];

	(* ==================== *)
	(* ==== Simulation ==== *)
	(* ==================== *)
	(* NOTE: any data related information is not simulated, since we can't predict the data at this point *)

	(* === Moat primitives === *)
	(* If Preparation->Robotic, there cannot be any moating, as that is done with aliquoting, which is not allowed robotically *)
	(* so just return an empty list as the packets *)
	moatPackets = If[MatchQ[resolvedPreparation, Robotic],
		{},
		Module[
			{
				moatVolume, moatSize, moatBuffer,moatBufferModel,workingContainers,currentContents,emptyMoatSizeQ,tooManyContainersQ,
				plateWells, moatWells, currentWells,wellConflictQ
			},

			(* -- Lookup the Moat related variables -- *)
			{
				moatVolume,
				moatSize,
				moatBuffer
			} = Lookup[protPacket,
				{
					MoatVolume,
					MoatSize,
					MoatBuffer
				}
			] /. {x:ObjectP[] -> Download[x, Object]};

			moatBufferModel = If[MatchQ[moatBufferModelPacket, Null],
				Null,
				Lookup[moatBufferModelPacket, Model];
			] /. {x:ObjectP[] -> Download[x, Object]};

			workingContainers = Lookup[workingContainerPacket, Object, {}] /. {x:ObjectP[] -> Download[x, Object]};
			currentContents = Lookup[workingContainerPacket, Contents, {}] /. {x:ObjectP[] -> Download[x, Object]};

			(* -- Initial Setup and Checks -- *)
			(* 1. Check if we have any moat *)
			emptyMoatSizeQ = If[MatchQ[moatSize, Null],
				True,
				False
			];

			(* 2. Check if we have more than 1 assay plate *)
			tooManyContainersQ = If[Length[workingContainers] != 1 && !emptyMoatSizeQ,
				True,
				False
			];

			(* 3. Check if we have any well conflict *)
			(* Determine which wells should be filled with buffer *)
			{plateWells, moatWells, currentWells} = If[!emptyMoatSizeQ && !tooManyContainersQ,
				(* If we haven't encounter any errors so far *)
				{
					AllWells[First[workingContainers]],
					Experiment`Private`getMoatWells[AllWells[First[workingContainers]],moatSize],
					Flatten[currentContents[[All,All,1]],1]
				},
				(* Otherwise, return {{Null}, {Null}, {Null}} *)
				{{Null}, {Null}, {Null}}
			];

			(* check if there is any well conflict *)
			wellConflictQ = If[!emptyMoatSizeQ && !tooManyContainersQ && ContainsAny[moatWells, currentWells],
				True,
				False
			];

			If[
				Or[
					emptyMoatSizeQ,
					tooManyContainersQ,
					wellConflictQ
				],
				(* Return an empty list if we have encountered any of the three previous errors *)
				{},

				(* Continue if no error has been raised *)
				Module[
					{
						numberOfMoatWells,
						moatWellDestinations,
						newMoatSamples,
						uploadPackets,
						packetsForTransfer,
						transferPackets
					},

					(* Find out the target moat wells and the number of them *)
					moatWellDestinations = Map[{#,First[workingContainers]}&,moatWells];
					numberOfMoatWells = Length[moatWells];

					(* UploadSample *)
					uploadPackets = UploadSample[
						ConstantArray[moatBufferModel, numberOfMoatWells],
						moatWellDestinations,
						Upload -> False,
						FastTrack -> True,
						Simulation -> updatedSimulation,
						SimulationMode -> True,
						UpdatedBy -> protocolObject
					];

					(* UploadSampleTransfer *)
					packetsForTransfer = Take[uploadPackets, numberOfMoatWells];
					transferPackets = UploadSampleTransfer[
						ConstantArray[moatBuffer, numberOfMoatWells],
						packetsForTransfer,
						ConstantArray[moatVolume, numberOfMoatWells],
						Upload -> False,
						FastTrack -> True,
						Simulation -> updatedSimulation
					];

					(* Return the upload and transfer packets *)
					Flatten[{uploadPackets, transferPackets}]
				]
			]
		]
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[moatPackets]];

	(* === Optimization sample primitives === *)
	(* If we're not doing AlphaScreen, just return an empty list *)
	optimizationSamplePackets= If[alphaQ,
		Module[
			{preparedPlate, gainOptimizationSamples, numberOfGainOptimizations, focalHeightOptimizationSamples, numberOfFocalHeightOptimizations,
				alphaAssayVolume, opticsOptimizationContainer,gainOptimizationSampleModels,focalHeightOptimizationSampleModels,
				noOptimizationSampleQ},

			{
				preparedPlate,
				gainOptimizationSamples,
				numberOfGainOptimizations,
				focalHeightOptimizationSamples,
				numberOfFocalHeightOptimizations,
				alphaAssayVolume,
				opticsOptimizationContainer
			} = Lookup[protPacket, {
				PreparedPlate,
				GainOptimizationSamples,
				NumberOfGainOptimizations,
				FocalHeightOptimizationSamples,
				NumberOfFocalHeightOptimizations,
				AlphaAssayVolume,
				OpticsOptimizationContainer
			}] /. {x:ObjectP[] -> Download[x, Object]};

			(* Find the models for the gain optimization samples *)
			gainOptimizationSampleModels = If[MatchQ[gainOptimizationSamplesPacket, {PacketP[ObjectP[Sample]]..}],
				Lookup[gainOptimizationSamplesPacket, Model],
				{}
			] /. {x:ObjectP[] -> Download[x, Object]};

			(* Find the models for the focal height optimization samples *)
			focalHeightOptimizationSampleModels = If[MatchQ[focalHeightOptimizationSamplesPacket, {PacketP[ObjectP[Sample]]..}],
				Lookup[focalHeightOptimizationSamplesPacket, Model],
				{}
			] /. {x:ObjectP[] -> Download[x, Object]};

			(* Check if we have any optimization samples *)
			noOptimizationSampleQ = If[MatchQ[numberOfGainOptimizations, Null] && MatchQ[numberOfFocalHeightOptimizations,Null],
				True,
				False
			];

			(* Generate the packets for optimization samples *)
			If[
				(* We do not do any optimization sample simulation if preparedPlate is True *)
				MatchQ[noOptimizationSampleQ, False] && MatchQ[preparedPlate, False],

				(* If we do have optimization samples, continue *)
				Module[
					{
						optimizationPlateWells,
						sampleContainerExpand,
						availablePositions,
						updatedNumberOfGainOptimizations,
						gainOptimizationPositions,
						updatedNumberOfFocalHeightOptimizations,
						focalHeightOptimizationPositions,
						gainOptimizationPackets,
						focalHeightOptimizationPackets
					},
					(* -- Standard Path: generate manipulations -- *)
					(* we currently only support both gain and focal height optimization in one plate *)

					(* Obtain the positions (in the form of {Well, Container}) that are available for all optimization samples *)
					(* First, we obtain the available wells in the plate. *)
					optimizationPlateWells=Flatten[AllWells[opticsOptimizationContainer]];

					(* Second, expand the container to match plateWells before MapThread *)
					sampleContainerExpand=Flatten[ConstantArray[opticsOptimizationContainer,Length[optimizationPlateWells]]];

					(* Third, obtain the availablePositions {in the form of {Well, Container} in the plate object from map thread*)
					availablePositions=MapThread[{#1,#2}&,{optimizationPlateWells, sampleContainerExpand}];

					(* Select the first x (numberOfGainOptimizations) available positions for gain optimizations *)
					updatedNumberOfGainOptimizations = numberOfGainOptimizations/.{Null->0};
					gainOptimizationPositions=Take[availablePositions,updatedNumberOfGainOptimizations];

					(* Select the next y (numberOfFocalHeightOptimizations) after x available positions for focal height optimizations *)
					updatedNumberOfFocalHeightOptimizations = numberOfFocalHeightOptimizations/.{Null->0};
					focalHeightOptimizationPositions=Take[availablePositions,(updatedNumberOfGainOptimizations+1);;(updatedNumberOfGainOptimizations+updatedNumberOfFocalHeightOptimizations)];

					(* Create packet to reflect the aliquot manipulation to fill gain optimization samples *)
					gainOptimizationPackets = If[!MatchQ[updatedNumberOfGainOptimizations,0],
						(* If we have gain optimization samples, continue *)
						Module[{uploadPackets, packetsForTransfer, transferPackets},

							(* UploadSample *)
							uploadPackets = UploadSample[
								gainOptimizationSampleModels,
								gainOptimizationPositions,
								Upload -> False,
								FastTrack -> True,
								Simulation -> updatedSimulation,
								SimulationMode -> True,
								UpdatedBy -> protocolObject
							];

							(* UploadSampleTransfer *)
							packetsForTransfer = Take[uploadPackets, Length[gainOptimizationSampleModels]];
							transferPackets = UploadSampleTransfer[
								gainOptimizationSamples,
								packetsForTransfer,
								ConstantArray[alphaAssayVolume, Length[gainOptimizationSampleModels]],
								Upload -> False,
								FastTrack -> True,
								Simulation -> updatedSimulation
							];

							(* Return the upload and transfer packets *)
							Flatten[{uploadPackets, transferPackets}]
						],

						(* If we don't have gain optimization samples, return an empty list *)
						{}
					];

					(* Create packet to reflect the aliquot manipulation to fill focal height optimization samples *)
					focalHeightOptimizationPackets = If[!MatchQ[updatedNumberOfFocalHeightOptimizations,0],
						(* If we have gain optimization samples, continue *)
						Module[{uploadPackets, packetsForTransfer, transferPackets},

							(* UploadSample *)
							uploadPackets = UploadSample[
								focalHeightOptimizationSampleModels,
								focalHeightOptimizationPositions,
								Upload -> False,
								FastTrack -> True,
								Simulation -> updatedSimulation,
								SimulationMode -> True,
								UpdatedBy -> protocolObject
							];

							(* UploadSampleTransfer *)
							packetsForTransfer = Take[uploadPackets, Length[focalHeightOptimizationSampleModels]];
							transferPackets = UploadSampleTransfer[
								focalHeightOptimizationSamples,
								packetsForTransfer,
								ConstantArray[alphaAssayVolume, Length[focalHeightOptimizationSampleModels]],
								Upload -> False,
								FastTrack -> True,
								Simulation -> updatedSimulation
							];

							(* Return the upload and transfer packets *)
							Flatten[{uploadPackets, transferPackets}]
						],

						(* If we don't have gain optimization samples, return an empty list *)
						{}
					];

					(* Return the gain optimization packets and focal height optimization packets *)
					Join[gainOptimizationPackets, focalHeightOptimizationPackets]
				],

				(* If we do not have optimization samples, return an empty list *)
				{}
			]
		],
		{}
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[optimizationSamplePackets]];

	(* -- Lookup -- *)
	{
		(* Absorbance specific blanks *)
		blankContainers,
		blankVolumes,
		temperature,
		equilibrationTime,
		chipRack,

		plateReader
	} = Lookup[
		protPacket, {
			BlankContainers,
			BlankVolumes,
			Temperature,
			EquilibrationTime,
			MicrofluidicChipRack,

			Instrument
		}
	] /. {x:ObjectP[] -> Download[x, Object]};

	(* Here we need a giant If to put in the blank packets, since blanks are only for the absorbance/nephelometry experiments *)
	(* blanks should already be in the plate if Preparation->Robotic, so skip for that too. *)
	If[(MatchQ[absorbanceQ,True] || MatchQ[nephelometryQ,True]) && !MatchQ[resolvedPreparation,Robotic],
		Module[
			{blankModels, uniqueContainerPackets, lunaticQ, cuvetteQ, numberOfReplicates, blankVolumeTuplesToMove,
				blanksToMove, volumesToMove, allWells, emptyPositions, uniquePositionsRequired, maxExtraContainerPositions,
				allEmptyPositions, blankContainersModel, extraBlankCuvette, allBlankDestinations, bmgBlankPackets, blankContainersToUse,
				allBMGPlates, combinedSamplesAndBlankPackets,combinedSamplesAndBlanks, combinedSamplesAndBlankModels, maxWellsInOrder, allWellsToTransferTo,
				waterWellsToTransferTo,sampleBlankWellsToTransferTo, controlSample, controlSampleModel, controlLoadingPackets, lunaticLoadingPackets},

			(* Blank Models *)
			blankModels = If[MatchQ[blankPackets, ListableP[PacketP[]]],
				Lookup[blankPackets, Model] /. {x:ObjectP[] -> Download[x, Object]},
				{}
			];

			uniqueContainerPackets=DeleteDuplicatesBy[workingSampleContainerPacket,Lookup[#,Object]&];

			(* -- Find if we are dealing with Lunatic. Lunatic's sample can't be reused -- *)

			(* check whether we are using the Lunatic or not *)
			lunaticQ = MatchQ[instrumentModelPacket, ObjectP[Model[Instrument, PlateReader, "id:N80DNj1lbD66"]]];

			(* check whether we are using the Cary 3500 or not *)
			cuvetteQ = MatchQ[instrumentModelPacket,ObjectP[Model[Instrument, Spectrophotometer, "id:01G6nvwR99K1"]]];

			(* --- If we're using BMG, generate manipulations to move the Blanks into their corresponding wells --- *)

			(* figure out how many replicate blanks we need to make *)
			numberOfReplicates=Lookup[protPacket,NumberOfReplicates];

			(* figure out which blanks will be need to transferred into new containers and how much to transfer *)
			(* Warning: Parser assumes primitives were set up according to this logic so any changes must be made to both functions *)
			blankVolumeTuplesToMove=If[lunaticQ && MatchQ[blankPackets, ListableP[PacketP[]]],
				{},
				blankVolumeTuples[blankPackets, blankVolumes, numberOfReplicates]
			];

			(* get the blanks to move and the volumes to move *)
			blanksToMove = blankVolumeTuplesToMove[[All, 1]];
			volumesToMove = blankVolumeTuplesToMove[[All, 2]];

			(* get all the wells of the 96 well plate *)
			allWells = If[MatchQ[workingSampleContainerModelPacket,ListableP[ObjectP[Model[Container]]]],
				Flatten[AllWells[Download[First[ToList@workingSampleContainerModelPacket],Object]]],
				Flatten[AllWells[]]
			];

			(* get all the empty positions of every ContainerIn; delete duplicates to tell the _number_ of empty wells; we are going to deal with NumberOfReplicates in the BMG case below *)
			(* need to do Flatten[blah, 1] to make sure it is a list of ordered pairs and not a list of lists of ordered pairs or a totally flat list *)
			emptyPositions = Flatten[Map[
				Function[{containerInPacket},
					Map[
						{#, Lookup[containerInPacket, Object]}&,
						DeleteCases[allWells, Alternatives @@ (Lookup[containerInPacket, Contents][[All, 1]])]
					]
				],
				uniqueContainerPackets
			], 1];

			(* get the number of unique positions required *)
			uniquePositionsRequired = Length[blanksToMove];

			(* generate the destinations that will go into the sample manipulation for the extra plates *)
			(* almost definitely won't need _all_ these destinations, but having these makes the Join and Take calls below easier *)
			(* AbsorbanceKinetics can only read one plate at a time so it doesn't use extra blank containers *)
			maxExtraContainerPositions = If[MatchQ[myProtocolType,TypeP[{Object[Protocol, AbsorbanceSpectroscopy], Object[Protocol, AbsorbanceIntensity]}]],
				If[cuvetteQ,
					Flatten[Map[
						Function[{blankContainer},
							{#, blankContainer}& /@ (allWells)
						],
						blankContainers
					], 1],
					Flatten[Map[
					Function[{blankContainer},
						{#, blankContainer}& /@ (allWells)
					],
					blankContainers
					], 1]
				],
				{}
			];

			(* if blank container is the same  *)
			extraBlankCuvette = If[cuvetteQ&&MatchQ[{maxExtraContainerPositions[[1, 2]]}, blankContainers],
				Module[{aliquotContainerModel,newContainerModelPacket, newContainersModel},

					(* in case containers are not plates, get aliquot container models *)
					aliquotContainerModel = Select[Flatten[(Lookup[Lookup[protPacket, ResolvedOptions], AliquotContainer])/. Null -> {}], MatchQ[#, ObjectP[Model[Container]]] &];

					(* get a cuvette model to simulate a blank cuvette *)
					newContainersModel = Which[
						MatchQ[blankContainers,{(ObjectP[Object[Container, Cuvette]])..}], Download[blankContainers, Model, Simulation -> updatedSimulation],
						MatchQ[Lookup[uniqueContainerPackets, Model],{(ObjectP[Model[Container, Cuvette]])..}], Lookup[uniqueContainerPackets, Model],
						MatchQ[aliquotContainerModel, {(ObjectP[Model[Container, Cuvette]])..}], aliquotContainerModel
					];

					(* simulate cuvette container IDs *)
					newContainerModelPacket = Map[
						Module[{type},

							type = Object@@Download[#,Type];

							Association[
								Type -> type,
								Object -> SimulateCreateID[type],
								Model -> Link[#,Objects],
								Contents -> {},
								Simulated -> True,
								Site -> Link[$Site],
								Notebook -> Link[$Notebook, Objects]
							]
						]&,
						Flatten[{newContainersModel}]
					];

					(* Update the simulation with our new container packets *)
					updatedSimulation=UpdateSimulation[updatedSimulation,Simulation[newContainerModelPacket]];

					Flatten[Map[
						Function[{blankContainer},
							{#, blankContainer}& /@ (allWells)
						],
						Lookup[newContainerModelPacket, Object]
					], 1]
				],
				{}
			];


			(* combine the empty positions with the new container positions *)
			allEmptyPositions = Join[emptyPositions, extraBlankCuvette, maxExtraContainerPositions];

			(* get all the blank destinations *)
			allBlankDestinations = Take[allEmptyPositions, uniquePositionsRequired];

			(* move the blanks into their proper places for BMG Micro PlateReader *)
			bmgBlankPackets = If[MatchQ[Lookup[blanksToMove, Object, {}], {}],

				(* If we do not have any blanks to move, return an empty list *)
				{},

				(* Otherwise, continue *)
				Module[
					{blankSamples, numberOfBlankSamples, blankModelOrComposition, uploadPackets, packetsForTransfer, transferPackets},
					blankSamples = Lookup[blanksToMove, Object];
					numberOfBlankSamples = Length[blankSamples];

					(* If a Blank sample has Model -> Null, use the composition instead. *)
					blankModelOrComposition = Map[
						If[!NullQ[Lookup[#, Model, Null]],
							Lookup[#, Model],
							Lookup[#, Composition][[All, {1, 2}]] (* drop the time element of the compositions. *)
						]&,
						blanksToMove
					];

					(* UploadSample *)
					uploadPackets = UploadSample[
						blankModelOrComposition,
						allBlankDestinations,
						Upload -> False,
						FastTrack -> True,
						Simulation -> updatedSimulation,
						SimulationMode -> True,
						UpdatedBy -> protocolObject
					];

					(* UploadSampleTransfer *)
					packetsForTransfer = Take[uploadPackets, numberOfBlankSamples];
					transferPackets = UploadSampleTransfer[
						blankSamples,
						packetsForTransfer,
						volumesToMove,
						Upload -> False,
						FastTrack -> True,
						Simulation -> updatedSimulation,
						UpdatedBy -> protocolObject
					];

					(* Return the upload and transfer packets *)
					Flatten[{uploadPackets, transferPackets}]
				]
			];

			(* Update simulation *)
			updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[bmgBlankPackets]];

			(* get the unique containers we are moving the blanks into that are also part of the BlankContainers field *)
			blankContainersToUse = DeleteDuplicates[Cases[allBlankDestinations[[All,1]], ObjectP[blankContainers]]];

			(* combine _all_ the BMG plates to get the list of containers that we will be putting into the plate reader *)
			(* This gives the order plates are read as well and is used by the parser to link samples to data packets *)
			allBMGPlates = If[lunaticQ,
				{},
				absSpecPlatesToRead[
					blankContainersToUse,
					blankVolumeTuplesToMove,
					blankPackets,
					uniqueContainerPackets
				]
			];

			(* --- If we're using the Lunatic, generate manipulations to move the samples into the MicrofluidicChips --- *)

			(* combine samples and blanks, being sure to delete duplicates on the blanks since we don't need to make multiple of them *)
			combinedSamplesAndBlankPackets = Flatten[{workingSamplePacket, DeleteDuplicates[blankPackets]}];
			combinedSamplesAndBlanks = Lookup[combinedSamplesAndBlankPackets, Object];
			combinedSamplesAndBlankModels = Lookup[combinedSamplesAndBlankPackets, Model] /. {x:ObjectP[]:>Download[x, Object], Null->{}};

			(* get the wells we are going to transfer into in the correct order *)
			(* most importantly, since the Lunatic chips are two columns each, we need to load the plate like "A1", "B1", "C1", ..., "H1", "A2", "B2", ... *)
			(* to get these wells in that order, need to do this transposing of AllWells *)
			maxWellsInOrder = Flatten[Transpose[AllWells[]]];

			(* get the wells that correspond to the number of samples *)
			(* need to do the lunaticQ check becuase BMG can have more than 96 samples in one run (which would throw a Take error here), but the Lunatic has already been checked/split in the experiment function if that's the case *)
			(* need to add 2 because two wells are going to have only water in them and that is important for blanking from the perspective of the Lunatic *)
			allWellsToTransferTo = If[lunaticQ,
				Take[maxWellsInOrder, (Length[combinedSamplesAndBlanks] + 2)],
				{}
			];

			(* split the wells to transfer to between waters and samples/blanks (obviously the Blanks could _also_ be water, but they don't have to be) *)
			{waterWellsToTransferTo, sampleBlankWellsToTransferTo} = If[lunaticQ,
				TakeDrop[allWellsToTransferTo, 2],
				{{}, {}}
			];

			(* Translate the loading manipulations for the control (right now this is always water) (but only if we are using the Lunatic) *)
			(* need these two for the Blanks to work properly *)
			controlSample = Lookup[protPacket, EquilibrationSample] /. {x:ObjectP[] :> Download[x, Object]};
			controlSampleModel = If[MatchQ[controlSamplePacket, PacketP[Object[Sample]]],
				Lookup[controlSamplePacket, Model] /. {x:ObjectP[] :> Download[x, Object]},
				Null
			];
			controlLoadingPackets = If[lunaticQ && MatchQ[controlSample, ObjectP[Object[Sample]]],
				Module[
					{
						numberOfControlSamples,
						destinations,
						uploadPackets,
						packetsForTransfer,
						transferPackets
					},

					numberOfControlSamples = Length[waterWellsToTransferTo];
					destinations = Transpose[{waterWellsToTransferTo, ConstantArray[chipRack, numberOfControlSamples]}];

					(* UploadSample *)
					uploadPackets = UploadSample[
						ConstantArray[controlSampleModel, numberOfControlSamples],
						destinations,
						Upload -> False,
						FastTrack -> True,
						UpdatedBy -> protocolObject,
						Simulation -> updatedSimulation,
						SimulationMode -> True
					];

					(* UploadSampleTransfer *)
					packetsForTransfer = Take[uploadPackets, numberOfControlSamples];
					transferPackets = UploadSampleTransfer[
						ConstantArray[controlSample, numberOfControlSamples],
						packetsForTransfer,
						(* The volume is fixed to 2.1 uL *)
						ConstantArray[2.1 * Microliter, numberOfControlSamples],
						Upload -> False,
						FastTrack -> True,
						UpdatedBy -> protocolObject,
						Simulation -> updatedSimulation
					];

					(* Return the upload and transfer packets *)
					Flatten[{uploadPackets, transferPackets}]
				],
				{}
			];

			(* Update simulation *)
			updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[controlLoadingPackets]];

			(* generate the loading manipulations (but only if we are using the Lunatic) *)
			lunaticLoadingPackets = If[lunaticQ,
				Module[
					{
						numberOfSamples,
						destinations,
						uploadPackets,
						packetsForTransfer,
						transferPackets
					},

					numberOfSamples = Length[combinedSamplesAndBlanks];
					destinations = Transpose[{sampleBlankWellsToTransferTo, ConstantArray[chipRack, numberOfSamples]}];

					(* UploadSample *)
					uploadPackets = UploadSample[
						combinedSamplesAndBlankModels,
						destinations,
						Upload -> False,
						FastTrack -> True,
						UpdatedBy -> protocolObject,
						Simulation -> updatedSimulation,
						SimulationMode -> True
					];

					(* UploadSampleTransfer *)
					packetsForTransfer = Take[uploadPackets, numberOfSamples];
					transferPackets = UploadSampleTransfer[
						combinedSamplesAndBlanks,
						packetsForTransfer,
						(* The volume is fixed to 2.1 uL *)
						ConstantArray[2.1 * Microliter, numberOfSamples],
						Upload -> False,
						FastTrack -> True,
						UpdatedBy -> protocolObject,
						Simulation -> updatedSimulation
					];

					(* Return the upload and transfer packets *)
					Flatten[{uploadPackets, transferPackets}]
				],
				{}
			];

			(* Update simulation *)
			updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[lunaticLoadingPackets]];
		]
	];

	(* --- Sample Injections --- *)
	injectionUpdatePackets = If[alphaQ,
		(* AlphaScreen does not have injections *)
		{},
		Module[
			{primaryInjectionSamples, secondaryInjectionSamples, tertiaryInjectionSamples, quaternaryInjectionSamples,
				primaryInjectionVolumes, secondaryInjectionVolumes, tertiaryInjectionVolumes, quaternaryInjectionVolumes, workingSamples,
				sampleTransferTuples},

			{
				primaryInjectionSamples,
				secondaryInjectionSamples,
				tertiaryInjectionSamples,
				quaternaryInjectionSamples
			}=Which[
				MatchQ[resolvedPreparation, Robotic],
				Lookup[
					protPacket,
					{
						PrimaryInjectionSample,
						SecondaryInjectionSample,
						TertiaryInjectionSample,
						QuaternaryInjectionSample
					}
				],
				MatchQ[
					myProtocolType,
					Alternatives[
						Object[Protocol,AbsorbanceKinetics],
						Object[Protocol,FluorescenceKinetics],
						Object[Protocol,LuminescenceKinetics],
						Object[Protocol,FluorescencePolarizationKinetics]
					]
				],
				Lookup[
					protPacket,
					{
						PrimaryInjections,
						SecondaryInjections,
						TertiaryInjections,
						QuaternaryInjections
					}
				][[All,All,2]],
				True,
				(Lookup[
					protPacket,
					{
						PrimaryInjections,
						SecondaryInjections,
						TertiaryInjections,
						QuaternaryInjections
					}
				]/.$Failed -> {})[[All,All,1]]
			];

			{
				primaryInjectionVolumes,
				secondaryInjectionVolumes,
				tertiaryInjectionVolumes,
				quaternaryInjectionVolumes
			}=Which[
				MatchQ[resolvedPreparation, Robotic],
				Lookup[
					protPacket,
					{
						PrimaryInjectionVolume,
						SecondaryInjectionVolume,
						TertiaryInjectionVolume,
						QuaternaryInjectionVolume
					}
				],
				MatchQ[
					myProtocolType,
					Alternatives[
						Object[Protocol,AbsorbanceKinetics],
						Object[Protocol,FluorescenceKinetics],
						Object[Protocol,LuminescenceKinetics],
						Object[Protocol,FluorescencePolarizationKinetics]
					]
				],
				Lookup[
					protPacket,
					{
						PrimaryInjections,
						SecondaryInjections,
						TertiaryInjections,
						QuaternaryInjections
					}
				][[All,All,3]],
				True,
				(Lookup[
					protPacket,
					{
						PrimaryInjections,
						SecondaryInjections,
						TertiaryInjections,
						QuaternaryInjections
					}
				]/.$Failed -> {})[[All,All,2]]
			];

			(* Find out the positions of working samples *)
			workingSamples = Lookup[workingSamplePacket, Object, {}];

			(* Create the sample transfer tuples. *)
			sampleTransferTuples=Cases[
				Join[
					If[Length[primaryInjectionSamples]>0,
						Transpose@{primaryInjectionSamples, workingSamples, primaryInjectionVolumes},
						{}
					],
					If[Length[secondaryInjectionSamples]>0,
						Transpose@{secondaryInjectionSamples, workingSamples, secondaryInjectionVolumes},
						{}
					],
					If[Length[tertiaryInjectionSamples]>0,
						Transpose@{tertiaryInjectionSamples, workingSamples, tertiaryInjectionVolumes},
						{}
					],
					If[Length[quaternaryInjectionSamples]>0,
						Transpose@{quaternaryInjectionSamples, workingSamples, quaternaryInjectionVolumes},
						{}
					]
				],
				{ObjectP[], ObjectP[], GreaterP[0 Liter]}
			];

			(* Record the injection sample transfers *)
			If[Length[sampleTransferTuples]>0,
				UploadSampleTransfer[
					sampleTransferTuples[[All,1]],
					sampleTransferTuples[[All,2]],
					sampleTransferTuples[[All,3]],
					Upload -> False,
					FastTrack -> True,
					Simulation -> updatedSimulation,
					UpdatedBy -> protocolObject
				],
				{}
			]
		]
	];

	(* Update simulation *)
	updatedSimulation = UpdateSimulation[updatedSimulation,Simulation[injectionUpdatePackets]];

	(* Note that we are now doing a manual expansion of the option BlankLabel. Our myResolvedOptions are not expanded with numReplicates because we only expand in the resource packets. However, blankPackets were downloaded from the protocol packet and have been expected with replicates. Apply the same expansion to the label options for our simulation *)
	expandedBlankLabelsWithReplicates=If[TrueQ[Lookup[myResolvedOptions,NumberOfReplicates]>1],
		Flatten[(ConstantArray[#,Lookup[myResolvedOptions,NumberOfReplicates]]&/@Lookup[myResolvedOptions, BlankLabel,{}]),1],
		Lookup[myResolvedOptions, BlankLabel,{}]
	];

	(* get the blank field ending with ...Link, since these would be split fields in UO object *)
	blankLinkField = If[nephelometryQ, BlankLink, BlanksLink];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the SamplesIn field *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], Download[Lookup[samplePackets, Container], Object]}],
				{_String, ObjectP[]}
			],
			If[MatchQ[blankPackets, {PacketP[]..}],
				Rule@@@Cases[
					Transpose[{ToList[expandedBlankLabelsWithReplicates], ToList[Lookup[blankPackets, Object]]}],
					{_String, ObjectP[]}
				],
				{}
			]
		],
		LabelFields->If[MatchQ[resolvedPreparation, Manual],
			Join[
				Rule@@@Cases[
					Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				],
				Rule@@@Cases[
					Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
					{_String, _}
				],
				If[MatchQ[blankPackets, {PacketP[]..}],
					Rule@@@Cases[
						Transpose[{ToList[expandedBlankLabelsWithReplicates], (With[{insertMe=blankLinkField},Field[insertMe[[#]]]]&)/@Range[Length[blankPackets]]}],
						{_String, _}
					],
					{}
				]
			],
			{}
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[updatedSimulation, simulationWithLabels]
	}
];

(* === Helper Functions === *)

(* -- blankVolumeTuples and absSpecPlatesToRead copied from AbsorbanceSpectroscopy/Compile.m -- *)
blankVolumeTuples[blankPackets_,blankVolumes_,numberOfReplicates_]:=Module[
	{tuples,blankVolumeTuplesNoDupes,cleanedReplicates,blankVolumeTuplesToMove},
	(* join samples, blanks, and blank volumes together (assuming we have blanks *)
	(* If blankVolumes is {} this means we aren't transferring any blanks - we'll use this info later when we set up our list of wells to read *)
	tuples = If[MatchQ[blankPackets, {}] ,
		{},
		If[MatchQ[blankVolumes, {}],
			{#,Null}&/@blankPackets,
			Transpose[{blankPackets, blankVolumes}]
		]
	];

	(* remove any blanks using the same sample with the same volume *)
	blankVolumeTuplesNoDupes = DeleteDuplicates[tuples];

	(* figure out how many replicate blanks we need to make *)
	cleanedReplicates=numberOfReplicates/.{Null->1};

	(* delete the cases where the blanks shouldn't be moved - indicated with BlankVolume->Null *)
	(* expand to make as many unique blanks as replicates *)
	blankVolumeTuplesToMove = Flatten[
		Map[
			ConstantArray[#,cleanedReplicates]&,
			DeleteCases[blankVolumeTuplesNoDupes,{_,Null}]
		],
		1
	]
];

absSpecPlatesToRead[
	newBlankContainers:Null|{ObjectP[Object[Container,Plate]]...},
	(* as long as this tuple has the object, and volume to be the first two items then we are fine *)
	blankVolumeTuplesMoved:{{ObjectP[{Object[Sample],Model[Sample]}],VolumeP,___}...},
	blankPackets:{PacketP[{Object[Sample],Model[Sample]}]...},
	sampleContainers:{ObjectP[Object[Container,Plate]]...}
]:=Module[{},
	Download[
		DeleteDuplicatesBy[
			If[ListQ[newBlankContainers],
				Module[{blanksMoved,remainingBlanks,remainingBlankPackets,originalContainersToRead},
					blanksMoved=Download[blankVolumeTuplesMoved[[All,1]],Object,{}];
					remainingBlanks=Complement[ToList[Download[blankPackets,Object]],blanksMoved];
					remainingBlankPackets=Select[blankPackets,MemberQ[Lookup[#,Object],remainingBlanks]&];
					originalContainersToRead=Lookup[remainingBlankPackets,Container,{}];
					Join[sampleContainers,originalContainersToRead,newBlankContainers]
				],
				Join[sampleContainers,Lookup[blankPackets,Container,{}]]
			],
			Download[#,Object]&
		],
		Object
	]
];