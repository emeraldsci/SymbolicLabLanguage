(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentMeasureVolume*)


(* ::Subsubsection::Closed:: *)
(*Options and Messages*)


DefineOptions[
	ExperimentMeasureVolume,
	Options:>{
		{
			OptionName -> ErrorTolerance,
			Default -> 10 Percent,
			Description -> "The acceptable variance in raw liquid level measurements. Readings above this threshold will be re-taken if possible, and not used to update sample volumes.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[5 Percent,50 Percent],
				Units -> Alternatives[Percent]
			],
			Category -> "Hidden"
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "Indicates the preferred method by which the samples' volumes will be calculated.",
				ResolutionDescription -> "Method will attempt to resolve to Gravimetric measurement first. If that is not immediately possible, it will then attempt to resolve to Ultrasonic measurement. If neither option works immediately, it will see if MeasureDensity or sample transfer can resolve which option to use.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic, VolumeMeasurementMethodP]
				]
			},
			{
				OptionName -> MeasureDensity,
				Default -> Automatic,
				Description -> "Indicates if the provided samples will have their density measured prior to volume measurement.",
				ResolutionDescription -> "Defaults to False unless MeasureDensity is required for Gravimetric volume measurement.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic, BooleanP]
				]
			},
			{
				OptionName -> MeasurementVolume,
				Default -> Automatic,
				Description -> "The volume of the liquid that will be used for density measurement.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[50 Microliter, 1 Milliliter],
					Units -> Alternatives[
						{1,{Microliter,{Microliter,Milliliter}}}
					]
				]
			},
			{
				OptionName -> RecoupSample,
				Default -> Automatic,
				Description -> "Indicates if the transferred liquid used for density measurement will be recouped or transferred back into the original container.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic, BooleanP]
				]
			}
			(* This is currently not supported due to issues passing multiple values to MeasureDensity in the procedure *)
			(* We are investigating methods to bring it back, but at the moment if they want to do this, they should use ExperimentMeasureDensity *)
			(*{
				OptionName -> NumberOfMeasureDensityReplicates,
				Default -> Automatic,
				Description -> "The number of times each density measurement will be replicated.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic]
					],
					Widget[
						Type -> Number,
						Pattern :> GreaterP[0,1]
					]
				]
			}*)
		],
		{
			OptionName -> ImageSample,
			Default -> Automatic,
			Description -> "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment.",
			AllowNull -> False,
			Category -> "PostProcessing",
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> StorageMeasurements,
			Default -> False,
			Description -> "Indicates if this protocol is being enqueued in order to measure the volume of samples before storage.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		},
		ProtocolOptions,
		SimulationOption,
		PreparationOption,
		SamplePrepOptions,
		AliquotOptions,
		ModelInputOptions,
		SampleLabelOptions,
		SubprotocolDescriptionOption,
		InSituOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption,
		SamplesInStorageOptions
	}
];


Error::SolidSamples = "ExperimentMeasureVolume is intended to work on Liquid samples. The following samples are solid and cannot have their volumes measured: `1`;";
(*Error::MeasureDensityReplicatesMismatch = "In ExperimentMeasureVolume, if MeasureDensity -> False, then the option NumberOfMeasureDensityReplicates will be ignored.";*)
Error::DensityRecoupSampleMismatch = "In ExperimentMeasureVolume, if MeasureDensity -> False, then the option RecoupSample will be ignored.";
Error::DensityMeasurementVolumeMismatch = "In ExperimentMeasureVolume, if MeasureDensity -> False, then the option MeasurementVolume will be ignored.";
Error::MeasureDensityRequired = "The following samples have Method -> Gravimetric but have no Density: `1`. Please set MeasureDensity -> True or Automatic.";
Error::InsufficientMeasureDensityVolume = "The following samples require MeasureDensity to conduct this experiment but do not have enough volume (`1`) to use in ExperimentMeasureDensity: `2`. Please add volume before beginning this experiment.";
Error::UnsafeMeasureDensity = "The following samples require MeasureDensity to conduct this experiment but their densities cannot be measured in ExperimentMeasureDensity due to safety reasons (Fuming, Ventilated, InertHandling or Pyrophoric being True): `1`. Please populate the sample density to continue.";
Error::SampleUltrasonicIncompatible = "The following samples are UltrasonicIncompatible and cannot be measured with our Ultrasonic volume measurement instruments: `1`. Please use Method -> Gravimetric if possible.";
Error::SampleEHSUltrasonicIncompatible = "The following samples are not safe to uncover for ultrasonic measurements in the Ambient environment and cannot be measured ultrasonically: `1`. Please use Method -> Gravimetric if possible.";
Error::UnmeasurableContainer = "The following samples have containers that are incompatible with the Method `1`: `2`. For a sample's volume to be measured gravimetrically, its container or its container's Model must have the TareWeight field populated, its container must not be an Object[Container, Plate], and its container must have only one sample inside. Please transfer the samples to containers that meet those criteria or consider measuring the volumes ultrasonically.";
Error::VolumeCalibrationsMissing = "The following samples have containers that are not calibrated for Ultrasonic volume measurement: `1`. Please select Gravimetric volume measurement if possible, or request the containers' model be volume calibrated by submitting a Troubleshooting Report.";
Error::UnmeasurableSample = "The following samples, `1`, have Volume, Density, UltrasonicIncompatible or EHS (Fuming, Ventilated, InertHandling, Pyrophoric) information that prohibits them from having their volume measured in the lab.";
Warning::CentrifugeRecommended = "Because the following samples will have their volumes Ultrasonically measured, we recommend preparing the samples with Centrifuge -> True to reduce errant volume measurements caused by material left on the sides of the container: `1`.";
Error::InvalidInSituMethod = "With InSitu -> True, the measurement methods, `1`, aren't compatible with the location and state of the samples `2`.";
Error::InvalidInSituMeasureDensity = "With InSitu -> True, you may not set MeasureDensity -> True.";
Error::InSituImpossible = "Because of the location of the sample, InSitu measurement is not possible. Please make sure the samples `1` are on the appropriate instruments and in compatible racks if necessary.";
Warning::LivingOrSterileSamplesQueuedForMeasureVolume = "The following samples,`1`, are marked Living->True, and the following samples, `2`, are marked Sterile->True. MeasureVolume on these samples will require opening the cover and therefore pose contamination risks. We recommend removing these samples from input list.";



(* ::Subsubsection:: *)
(*ExperimentMeasureVolume - Sample Overload*)


ExperimentMeasureVolume[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,listedSamples,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,
		templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,resolvedOptionsResult,parentProtocol,
		resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resolvedPreparation, optionsResolverOnly,
		returnEarlyBecauseOptionsResolverOnly,returnEarlyBecauseFailuresQ,performSimulationQ, protocolObject,protocolPacket,resourcePacketTests,
		simulatedProtocol,finalSimulation,aliquotAdjustedOptions,cache,inSituOp,packets,metaContainers,metaContainerParents,
		samplePackets,sampleModels,containerPackets, containerModels,volumeCalibrations,filteredSamplesIn,filteredExpandedOptions,metaMetaContainerParents,
		objectSampleFields,modelSampleFields,containerFields,modelContainerFields,rackPackets,mySamplesWithPreparedSamplesNamed,
		myOptionsWithPreparedSamplesNamed,safeOptionsNamed, numberOfReplicates,parentProtocolPacket,parentPostProcessingBool,storageMeasurements
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureVolume,
			listedSamples,
			listedOptions
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentMeasureVolume,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentMeasureVolume,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(*change all Names to objects *)
	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentMeasureVolume,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentMeasureVolume,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Determine whether this should be an InSitu protocol *)
	inSituOp = Lookup[safeOps,InSitu];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests} = If[!inSituOp,
		If[gatherTests,
			ApplyTemplateOptions[ExperimentMeasureVolume,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
			{ApplyTemplateOptions[ExperimentMeasureVolume,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
		],
		{{},{}}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	{parentProtocol,cache} = Lookup[safeOps,{ParentProtocol,Cache}];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentMeasureVolume,{mySamplesWithPreparedSamples},inheritedOptions]];

	(* --- Build lists of fields that we want to download from each associated type --- *)
	(* Sample fields*)
	objectSampleFields = Packet@@Flatten[{
		(* Necessary for MeasureVol *)
		Status,Volume,Density,Container,UltrasonicIncompatible,LightSensitive,Sterile,Density,State,Living,Sterile,
		(* Cache required *)
		SamplePreparationCacheFields[Object[Sample]]
	}];

	(* Model fields *)
	modelSampleFields = Packet[Model[Flatten[{
		(* Necessary for MeasureVol *)
		Density,
		(* Cache required *)
		SamplePreparationCacheFields[Model[Sample]]
	}]]];

	(* Container fields *)
	containerFields = Packet[Container[Flatten[{
		(* Necessary for MeasureVol *)
		Model,Status,TareWeight,Contents,Container,Position,
		(* Cache required *)
		SamplePreparationCacheFields[Object[Container]]
	}]]];

	(* Container Model fields *)
	modelContainerFields = Packet[Container[Model][Flatten[{
		(* Necessary for MeasureVol *)
		VolumeCalibrations,MinVolume,MaxVolume,TareWeight,Immobile,Ampoule,UltrasonicIncompatible,
		(* Cache required *)
		SamplePreparationCacheFields[Model[Container]]
	}]]];

	(* --- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --- *)
	packets = Quiet[Download[
		{
			(*1*)mySamplesWithPreparedSamples,
			(*2*)mySamplesWithPreparedSamples,
			(*3*)mySamplesWithPreparedSamples,
			(*4*)mySamplesWithPreparedSamples,
			(*5*)mySamplesWithPreparedSamples,
			(*6*)mySamplesWithPreparedSamples,
			(*7*)mySamplesWithPreparedSamples,
			(*8*)mySamplesWithPreparedSamples,
			(*9*)mySamplesWithPreparedSamples,
			(*10*){parentProtocol}
		},
		{
			(* 1. Sample packet information *)
			{objectSampleFields},

			(* 2. Light Sensitive and Sterile used for PreferredContainer options *)
			{modelSampleFields},

			(* 3. Sample's Container packet information *)
			{containerFields},

			(* 4. Container Model Packet *)
			{modelContainerFields},

			(* 5. Volume Calibration Packets *)
			{Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel, LiquidLevelDetector, Anomalous, Deprecated, DeveloperObject, SensorArmHeight, RackModel, LayoutFileName}]]},

			(* 6. TubeRack and PlateRack packets*)
			{Packet[Container[Model][VolumeCalibrations][RackModel][{AvailableLayouts, TareWeight, Positions, Footprint, Name, Dimensions}]]},

			(* 7. Meta Container - Used to determine if In Situ is possible *)
			{Packet[Container[Container][{Model, Container, Position}]]},

			(* 8. Meta Container Parent - Used to determine if In Situ is possible *)
			{Packet[Container[Container][Container][{Model, Container, Position}]]},

			(* 9. Container of the Container's Container's Container - Used for InSitu *)
			{Packet[Container[Container][Container][Container][{Model, Container, Position}]]},

			(* 10. Parent protocol packet*)
			{Packet[MeasureVolume,Target,ParentProtocol]}
		},
		Date->Now,
		Cache -> cache,
		Simulation -> updatedSimulation
	],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	{
		(*1*)samplePackets,
		(*2*)sampleModels,
		(*3*)containerPackets,
		(*4*)containerModels,
		(*5*)volumeCalibrations,
		(*6*)rackPackets,
		(*7*)metaContainers,
		(*8*)metaContainerParents,
		(*9*)metaMetaContainerParents,
		(*10*)parentProtocolPacket
	} = Flatten[#,1]&/@packets;

	cacheBall = FlattenCachePackets[{cache, packets}];

	(*This section will also check the Living/Sterile field of the samples and parent protocol to throw warning accordingly. If experiment is called directly, we throw a warning without filtering any sample out. Otherwise (i.e. we are in a subprotocol while Sterile -> True or sample is marked Living ->True), we filter the samples out in the next section without throwing any warning *)
	Module[{livings,steriles,sampleObjects},
		{livings,steriles,sampleObjects}=Transpose[Lookup[samplePackets,{Living,Sterile,Object}]];
		(*We are called directly, if there is living or sterile sample, will not filter, just a warning*)
		If[!MatchQ[parentProtocol,ObjectP[]]&&MemberQ[Flatten[{livings,steriles}],True] && !gatherTests && !MatchQ[$ECLApplication, Engine],
			Message[Warning::LivingOrSterileSamplesQueuedForMeasureVolume,
				ObjectToString[PickList[sampleObjects,livings,True], Cache -> cacheBall, Simulation->updatedSimulation],
				ObjectToString[PickList[sampleObjects,steriles,True], Cache -> cacheBall, Simulation->updatedSimulation]
			]
		]
	];

	(*Check if the parent protocol specified ImageSample -> True. If parent protocol called for MeasureVolume, we will not filter it out for living/sterile*)
	parentPostProcessingBool = Lookup[Replace[fetchPacketFromCache[parentProtocol,cacheBall],{Null -> <||>}],MeasureVolume,Null];

	(* Determine if we are doing storage measurements *)
	storageMeasurements = Lookup[safeOps, StorageMeasurements, False];

	(* If we are in a subprotocol for post-processing, this section will filter out samples that are incapable of being volume measured *)
	(* Note that for other subprotocols, we will proceed as normal since the parent protocol must be requesting volume measurements for a valid reason. *)
	{filteredSamplesIn,filteredExpandedOptions} = If[MatchQ[parentProtocol,ObjectP[Object[]]]&&TrueQ[storageMeasurements],

		(* If we ARE in a subprotocol for post-processing, we need to filter out Solid and Discarded samples *)
		Module[
			{invalidBools,invalidPositions,validSamples,measureVolumeOptionNames,lengthOfInput,indexMatchedOptions,validOptions,aliquotRaw,
				trimmedAliquotOption,aliquotDestinationWellRaw,trimmedAliquotDestinationWellOption},

			(* Return a list of bools where TRUE means the sample is INVALID *)
			(* Samples can be invalid if
					- they are solid or discarded
					(* This has been disable for now - the volume of the sample is below MinVolume of the container *)
					- they are in an ampoule
					- they are in a plate without a volume calibration
					- they don't have any density information and are in container that doesn't have a volume calibration (are completely unmeasurable)
			*)
			invalidBools = MapThread[
				Function[{samplePack,sampleModPack,containerPack,containerMod,volumeCals},
					Or[
						(* If the sample is Solid *)
						MatchQ[Lookup[samplePack,State],Solid],

						(* If the Sample's State is Null for some reason, check the model to see if its Solid *)
						And[
							NullQ[Lookup[samplePack,State]],
							!NullQ[sampleModPack],(* Some samples can have no model after a transfer in *)
							MatchQ[Lookup[sampleModPack,State],Solid]
						],

						(* If the sample is Discarded *)
						MatchQ[Lookup[samplePack,Status],Discarded],

						(* If we can't move the container to a volume check and we don't expect to measure the sample in position it's currently in *)
						And[
							!TrueQ[inSituOp],
							TrueQ[Lookup[containerMod,Immobile]]
						],

						(* If the sample is in an Ampoule *)
						TrueQ[Lookup[containerMod,Ampoule]],

						(* The sample cannot be measured gravimetrically or ultrasonically *)
						And[
							(* Cannot be measured ultrasonically *)
							Or[
								(* the sample is UltrasonicIncompatible *)
								TrueQ[Lookup[samplePack,UltrasonicIncompatible,Null]],
								(* no volume calibrations *)
								MatchQ[volumeCals,{}|$Failed|Null],
								(* Or every calibration is anomalous, deprecated or a dev object *)
								And@@(MatchQ[
									#,
									Alternatives[
										KeyValuePattern[Anomalous->True],
										KeyValuePattern[Deprecated->True],
										KeyValuePattern[DeveloperObject->True]
									]
								]&/@volumeCals),
								(* If the Container is exempt from Ultrasonic measurement due to being incompatible with our liquid level detectors *)
								TrueQ[Lookup[containerMod,UltrasonicIncompatible]],
								(* There is safety concern uncovering the sample for ultrasonic measurements. Ultrasonic measurements can only happen in Ambient environment and require the container to be uncovered *)
								(* Note that we don't do the same check for gravimetric measurements as MeasureWeight won't uncover and also it can select the balance in the corresponding handling environment *)
								(* We also don't care if the sample volume is small enough, like in a plate, or MaxVolume of the container < 2mL. These containers are going into plate volume check instruments (VC50, VC100, VC384) *)
								And[
									!MatchQ[containerMod,ObjectP[{Model[Container,Plate],Model[Container, MicrofluidicChip], Model[Container,ProteinCapillaryElectrophoresisCartridge]}]],
									MatchQ[Lookup[containerMod,MaxVolume],GreaterP[2Milliliter]],
									MemberQ[Lookup[samplePack, {Fuming, Ventilated, InertHandling, Pyrophoric}, Null], True]
								]
							],
							(* Cannot be measured gravimetrically *)
							(* Note that we are only here if we have StorageMeasurements->True, and we will always estimate density with solventEstimatedDensities in this case, we should not care about missing density *)
							Or[
								(* in a plate or other multi-position fluid containers *)
								MatchQ[containerMod,ObjectP[{Model[Container,Plate],Model[Container, MicrofluidicChip], Model[Container,ProteinCapillaryElectrophoresisCartridge]}]],
								(* container has tare weight *)
								!Or[
									MatchQ[Lookup[containerPack,TareWeight],MassP],
									MatchQ[Lookup[containerMod,TareWeight],MassP]
								]
							]
						],
						(*If the sample is living or sterile while the parent does not directly call for MeasureVolume*)
						Or[
							TrueQ[Lookup[samplePack,Living,Null]],
							TrueQ[Lookup[samplePack,Sterile,Null]]
						]&&!TrueQ[parentPostProcessingBool]
					]
				],
				{samplePackets,sampleModels,containerPackets,containerModels,volumeCalibrations}
			];

			(* Determine which positions were Invalid *)
			invalidPositions = Position[invalidBools,True];

			(* Determine the valid positions *)
			validSamples = Delete[samplePackets,invalidPositions];

			(* Stash the length of the input *)
			lengthOfInput = Length[mySamplesWithPreparedSamples];

			(* Gather the list of option names that are index matched to the input *)
			indexMatchedOptions = Select[
				OptionDefinition[ExperimentMeasureVolume],
				MatchQ[#["IndexMatchingInput"],"experiment samples"]&
			][[All,"OptionSymbol"]];

			(* Map over the options and for any option that is index matched to the input, delete the positions that are invalid  *)
			validOptions = MapThread[
				Function[{optionName,optionVal},
					If[MatchQ[Length[optionVal],lengthOfInput],

						(* If the length of the option matches the length of the input, assume Index Matched and trim the bad values *)
						optionName->Delete[optionVal,invalidPositions],

						(* Otherwise it isn't index matched so leave it be *)
						optionName->optionVal
					]
				],
				{indexMatchedOptions,Lookup[expandedSafeOps,indexMatchedOptions]}
			];

			(* Temporarily setting this to 1. When we fix the procedure and parser will add it back to what it should be *)
			(* numberOfReplicates = Lookup[expandedSafeOps,NumberOfReplicates]; *)
			numberOfReplicates = 1;

			(*	The option AliquotContainers is NOT Index-Matched to Samples in so we need to trim it as a special case
					Length[AliquotContainers] = 1 OR Length[mySamples])
					We have to handle each of those cases and trim the indexes associated with samples being filtered out
			*)
			aliquotRaw = Lookup[expandedSafeOps,AliquotContainer];
			trimmedAliquotOption = Flatten@Delete[
				Partition[aliquotRaw, numberOfReplicates],
				invalidPositions
			];

			aliquotDestinationWellRaw = Lookup[expandedSafeOps,DestinationWell];
			trimmedAliquotDestinationWellOption = Flatten@Delete[
				Partition[aliquotDestinationWellRaw, numberOfReplicates],
				invalidPositions
			];

			(* Return our new samples and options *)
			{validSamples,ReplaceRule[expandedSafeOps,Join[validOptions, {AliquotContainer -> trimmedAliquotOption,DestinationWell -> trimmedAliquotDestinationWellOption}]]}
		],

		(* If we're not in a sub protocol for post-processing, just return the samples we're working with and the options we already expanded *)
		{samplePackets,expandedSafeOps}
	];

	(* If we no longer have any samples to work with, and we're in a sub protocol, quietly return $Failed so the procedure may skip past volume measurement *)
	If[
		And[
			SameQ[filteredSamplesIn,{}],
			MatchQ[parentProtocol,ObjectP[Object[]]],
			TrueQ[storageMeasurements]
		],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Flatten[Join[safeOpsTests,validLengthTests,templateTests]],
			Options->$Failed,
			Preview->Null,
			Simulation -> Null
		}]
	];

	(* If ParentProtocol != Null, we refuse to move the samples. Set Aliquot -> False *)
	aliquotAdjustedOptions = If[MatchQ[parentProtocol,ObjectP[]],
		ReplaceRule[filteredExpandedOptions,Aliquot->Table[False,Length[filteredSamplesIn]]],
		filteredExpandedOptions
	];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests} = resolveExperimentMeasureVolumeOptions[filteredSamplesIn,aliquotAdjustedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests} = {resolveExperimentMeasureVolumeOptions[filteredSamplesIn, filteredExpandedOptions, Output -> Result, Cache -> cacheBall, Simulation -> updatedSimulation], {}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentMeasureVolume,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation = Lookup[resolvedOptions, Preparation];

	(* Lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* If Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* Run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Simulation];

	(* If option resolution failed (or if we have all hazardous inputs/options) and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureVolume, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> updatedSimulation
		}]
	];

	(* Build packets with resources *)
	{protocolPacket,resourcePacketTests} = Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
			{$Failed, {}},
		gatherTests,
			measureVolumeResourcePackets[
				filteredSamplesIn,
				templatedOptions,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				Output->{Result,Tests}
			],
		True,
			{
				measureVolumeResourcePackets[
					filteredSamplesIn,
					templatedOptions,
					resolvedOptions,
					Cache->cacheBall,
					Simulation->updatedSimulation,
					Output->Result],
				{}
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, finalSimulation} = Which[
		MatchQ[protocolPacket, $Failed],
			{$Failed, updatedSimulation},
		performSimulationQ,
			simulateExperimentMeasureVolume[
				protocolPacket,
				(* NOTE: This is unusual, but here filteredSamplesIn is Packets *)
				Lookup[ToList[filteredSamplesIn],Object],
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			],
		True,
			{Null, updatedSimulation}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentMeasureVolume,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> finalSimulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[protocolPacket,$Failed],
		UploadProtocol[
			protocolPacket,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],

			Priority -> Lookup[safeOps,Priority],
			StartDate -> Lookup[safeOps,StartDate],
			HoldOrder -> Lookup[safeOps,HoldOrder],
			QueuePosition -> Lookup[safeOps,QueuePosition],

			ConstellationMessage->Object[Protocol,MeasureVolume],
			Cache->cacheBall,
			Simulation -> finalSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentMeasureVolume,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> finalSimulation
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureVolume - Container Overload*)


ExperimentMeasureVolume[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification,output,gatherTests,listedOptions,listedContainers,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,containerToSampleTests,containerToSampleSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Make sure we're working with a list of inputs and options *)
	{listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentMeasureVolume,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation} = containerToSampleOptions[
			ExperimentMeasureVolume,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		If[NullQ[Lookup[listedOptions,ParentProtocol,Null]],
			Check[
				{containerToSampleOutput,containerToSampleSimulation} = containerToSampleOptions[
					ExperimentMeasureVolume,
					mySamplesWithPreparedSamples,
					myOptionsWithPreparedSamples,
					Output-> {Result,Simulation},
					Simulation -> updatedSimulation
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			],

			(* However, if we are in a Subprotocol, silence the empty container errors *)
			{containerToSampleOutput,containerToSampleSimulation} = Quiet[
				containerToSampleOptions[
					ExperimentMeasureVolume,
					mySamplesWithPreparedSamples,
					myOptionsWithPreparedSamples,
					Output-> {Result,Simulation},
					Simulation -> updatedSimulation
				],
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			]
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],

		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentMeasureVolume[samples, ReplaceRule[sampleOptions, {Simulation -> containerToSampleSimulation}]]
	]
];



(* ::Subsection:: *)
(*resolveExperimentMeasureVolumeOptions*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[
	resolveExperimentMeasureVolumeOptions,
	Options:>{
		CacheOption,
		OutputOption,
		SimulationOption
	}
];


(* ::Subsubsection:: *)
(*resolveExperimentMeasureVolumeOptions*)


resolveExperimentMeasureVolumeOptions[mySamples:{ObjectP[Object[Sample]]..},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentMeasureVolumeOptions]]:=Module[
	{
		outputSpecification,output,listedInputs,fastTrack,gatherTests,cache,simulation,samplePrepOptions,measureVolumeOptions,simulatedSamples,
		resolvedSamplePrepOptions,updatedSimulation,measureVolumeOptionsAssociation,fullCache,samplePackets,sampleModelPackets,
		containerPackets,modelContainerPackets,parentProtocol,discardedSamplePackets,discardedInvalidInputs,discardedTests,
		solidSamplePackets,solidInvalidInputs,solidSampleTests,immobileSamplePackets,immobileInvalidInputs,immobileSampleTests,
		(*numMeasureDensityReplicatesMismatchOptions,numMeasureDensityReplicatesMismatchInputs,*)numMeasureDensityMismatches,numMeasureDensityInvalidOptions,
		recoupSampleMismatches,recoupSampleMismatchOptions,recoupSampleMismatchInputs,recoupSampleInvalidOptions,
		measurementVolMismatches,measurementVolMismatchOptions,measurementVolMismatchInputs,measurementVolInvalidOptions,
		numMeasureDensityTest,recoupSampleTest,measurementVolumeTest,mapThreadFriendlyOptions,samplePrepTests,
		measurementVolumeOptionWithRoundedVolumes,measurementVolumePrecisionTests,ultrasonicCompatibleContainerModels,
		imageSample,methods,measureDensityOps,measurementVolumes,recoupSampleOps,(*numMeasureDensityReplicatesOps,*)
		sampleLabels,sampleContainerLabels,
		unmeasurableSampleErrors,unmeasurableContainerErrors,measureDensityRequiredErrors,sampleUltrasonicIncompatibleErrors,
		unsafeUltrasonicMeasurementErrors,insufficientMeasureDensityVolumeErrors,unsafeMeasureDensityErrors,centrifugeRecommendedWarnings,
		lookupP,resolvedAliquotOptions,aliquotTests,unmeasurableContainerInvalidOptions,insufficientMeasureDensityVolumeInvalidInputs,inSitu,
		sampleUltrasonicIncompatibleInvalidOptions,unmeasurableContainerTest,samplePrepOpsWithCentrifuge,
		sampleUltrasonicIncompatibleTests,centrifugeRecommendedTests,insufficientMeasureDensityVolumeTests,
		unmeasurableSampleInvalidInputs,unmeasurableSampleTest,measureDensityRequiredInvalidOptions,volCals,
		unsafeUltrasonicMeasurementInvalidOptions,unsafeUltrasonicMeasurementTests,
		unsafeMeasureDensityInvalidOptions,unsafeMeasureDensityTests,
		measureDensityRequiredTest,invalidInputs,invalidOptions,metaContainers,metaContainerParents,inSituBools,
		inSituMethodErrors,inSituMeasureDensityError,inSituQ,inSituInvalidOptions,inSituMethodInvalidOptions,
		inSituMeasureDensityInvalidOptions,inSituMeasureDensityErrors,uncalibratedContainerErrors,metaMetaContainerParents,
		requiredAliquotAmounts,sampleComps,matchedIntensiveProperties,compositionDensities,uncalibratedContainerInvalidInputs,
		uncalibratedContainerTest,sameContainerStorageConditionConflictBooleans,sameContainerStorageConditionConflictTest,
		sameContainerStorageConditionConflictOption,suppliedSampleInStorageCondition, storageMeasurements, estimatedDensities, allMolecules,
		resolvedPreparation
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Make sure we are dealing with a list of inputs rather than a singleton *)
	listedInputs = ToList[mySamples];

	(* Stash the FastTrack option *)
	fastTrack = Lookup[myOptions,FastTrack];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions],Cache];
	simulation = Lookup[ToList[myResolutionOptions],Simulation];

	(* Separate out our MeasureVolume options from our Sample Prep options. *)
	{samplePrepOptions,measureVolumeOptions} = splitPrepOptions[myOptions];

	(* Determine if the protocol wants to be conducted In Situ *)
	inSitu = Lookup[measureVolumeOptions,InSitu];

	(* Determine if there's a parent protocol. If there is, our behavior (particularly around errors) will be change *)
	parentProtocol = Lookup[measureVolumeOptions,ParentProtocol];

	(* Determine if we are doing storage measurements *)
	storageMeasurements = Lookup[measureVolumeOptions, StorageMeasurements];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentMeasureVolume, listedInputs, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentMeasureVolume, listedInputs, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	measureVolumeOptionsAssociation = Append[
		Association[measureVolumeOptions],
		Centrifuge -> Lookup[myOptions,Centrifuge]
	];

	(* Extract the packets that we need from our downloaded cache. *)
	{samplePackets,sampleModelPackets,containerPackets,modelContainerPackets,metaContainers,metaContainerParents,metaMetaContainerParents,volCals}=Quiet[
		Transpose@Download[
			ToList[simulatedSamples],
			{
				(* Sample packet information *)
				(* Light Sensitive and Sterile used for PreferredContainer options *)
				Packet[Name,Status,Volume,Density,Container,Position,Composition,Count,State,UltrasonicIncompatible,LightSensitive,Sterile, StorageCondition,Fuming,Ventilated,InertHandling,Pyrophoric],

				Packet[Model[{Density}]],

				(* Sample's Container packet information *)
				Packet[Container[{Model,Status,TareWeight,Contents,Container,Position, StorageCondition}]],

				(* Model information of the Sample's Container*)
				Packet[Container[Model][{TareWeight,Immobile,MaxVolume,MinVolume}]],

				(* Container of the Container info - Used for InSitu *)
				Packet[Container[Container][{Model,Container,Position}]],

				(* Container of the Container's Container - Used for InSitu *)
				Packet[Container[Container][Container][{Model,Container,Position}]],

				(* Container of the Container's Container's Container - Used for InSitu *)
				Packet[Container[Container][Container][Container][{Model,Container,Position}]],

				(* Volume Calibrations *)
				Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel,LiquidLevelDetector,Anomalous,Deprecated,DeveloperObject}]]
			},
			Cache -> cache,
			Simulation -> updatedSimulation
		],
		Download::FieldDoesntExist
	];

	(* Store the full cache so lower functions (like PreferredContainer) don't need to go to the DB *)
	fullCache = FlattenCachePackets[Join[cache,{samplePackets,sampleModelPackets,containerPackets,modelContainerPackets,metaContainers,metaContainerParents,metaMetaContainerParents,volCals}]];

	(*-- INPUT VALIDATION CHECKS --*)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[samplePackets,KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded. *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are discard samples in the inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->fullCache,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->fullCache,Simulation->updatedSimulation]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Cache->fullCache,Simulation->updatedSimulation]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check for Immobile containers - *)
	immobileSamplePackets = PickList[
		samplePackets,
		modelContainerPackets,
		_?(
			And[
				!NullQ[#],
				TrueQ[Lookup[#,Immobile]]
			]&
		)
	];

	(* We will have already filtered out any immobile samples if we have a parent so errors will only be thrown for stand-alone protocols *)
	immobileInvalidInputs = If[MatchQ[immobileSamplePackets,{}],
		{},
		Lookup[immobileSamplePackets,Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[
		And[
			Length[immobileInvalidInputs]>0,
			!gatherTests,
			NullQ[parentProtocol]
		],

		Message[Error::ImmobileSamples,"volume checked","measuring instrument",immobileInvalidInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	immobileSampleTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[immobileInvalidInputs]==0,
				Nothing,
				Test["The input sample(s) "<>ObjectToString[immobileInvalidInputs,Cache->fullCache,Simulation->updatedSimulation]<>" can be moved to a volume checking instrument:",True,False]
			];

			passingTest=If[Length[immobileInvalidInputs]==Length[mySamples],
				Nothing,
				Test["The input sample(s) "<>ObjectToString[Complement[mySamples,immobileInvalidInputs],Cache->fullCache,Simulation->updatedSimulation]<>" can be moved to a volume checking instrument:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(*-- OPTION PRECISION CHECKS --*)
	(* MeasurementVolume Option *)
	{measurementVolumeOptionWithRoundedVolumes,measurementVolumePrecisionTests}=If[gatherTests,
		RoundOptionPrecision[measureVolumeOptionsAssociation,MeasurementVolume,1 Microliter,Output->{Result,Tests}],
		{RoundOptionPrecision[measureVolumeOptionsAssociation,MeasurementVolume,1 Microliter],Null}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)
	(*Check if SamplesIn in the same container have the same storage conditions.*)
	suppliedSampleInStorageCondition=Lookup[measurementVolumeOptionWithRoundedVolumes,SamplesInStorageCondition];

	(* call ValidContainerStorageConditionQ. message will be thrown by the helper function if not gathering tests *)
	{sameContainerStorageConditionConflictBooleans,sameContainerStorageConditionConflictTest}=If[gatherTests,
		ValidContainerStorageConditionQ[ToList[mySamples],suppliedSampleInStorageCondition,Output->{Result,Tests},Cache->fullCache,Simulation->updatedSimulation],
		{ValidContainerStorageConditionQ[ToList[mySamples],suppliedSampleInStorageCondition,Output->Result,Cache->fullCache,Simulation->updatedSimulation],{}}
	];

	(*Collect Invalid options SamplesInStorageCondition*)
	sameContainerStorageConditionConflictOption=If[And@@sameContainerStorageConditionConflictBooleans,{},{SamplesInStorageCondition}];

	(* Check each index for a conflict between MeasureDensity and RecoupSample *)
	recoupSampleMismatches = MapThread[
		Function[
			{measureDensity,recoupSample,sampleObject},
			If[
				Or[
				(* If MeasureDensity -> False but an option value was given for the option *)
					MatchQ[measureDensity,False] && !MatchQ[recoupSample,Null|Automatic],

				(* OR If MeasureDensity -> True but an option value was given as Null *)
					MatchQ[measureDensity,True] && MatchQ[recoupSample,Null]
				],
				{{measureDensity,recoupSample},sampleObject},
				Nothing
			]
		],
		{Lookup[measureVolumeOptionsAssociation,MeasureDensity],Lookup[measureVolumeOptionsAssociation,RecoupSample],ToList[simulatedSamples]}
	];

	(* Transpose our result if there were mismatches. *)
	{recoupSampleMismatchOptions,recoupSampleMismatchInputs} = If[MatchQ[recoupSampleMismatches,{}],
		{{},{}},
		Transpose[recoupSampleMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	recoupSampleInvalidOptions = If[Length[recoupSampleMismatchOptions]>0,
		If[!gatherTests,
			Message[Error::DensityRecoupSampleMismatch,recoupSampleMismatchOptions,ObjectToString[recoupSampleMismatchInputs,Cache->fullCache,Simulation->updatedSimulation]]
		];

		(* Store the errant options for later InvalidOption checks *)
		{MeasureDensity, RecoupSample},

	(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* Build a test for whether RecoupSample was specified even if MeasureDensity -> False *)
	recoupSampleTest = Test["If MeasureDensity -> False, RecoupSample was not provided as an option:",
		recoupSampleInvalidOptions,
		{}
	];

	(* Check each index for a conflict between MeasureDensity and RecoupSample *)
	measurementVolMismatches = MapThread[
		Function[
			{measureDensity,measureVol,sampleObject},
			If[
				Or[
				(* If MeasureDensity -> False but an option value was given for the option *)
					MatchQ[measureDensity,False] && !MatchQ[measureVol,Null|Automatic],

				(* OR If MeasureDensity -> True but an option value was given as Null *)
					MatchQ[measureDensity,True] && MatchQ[measureVol,Null]
				],
				{{measureDensity,measureVol},sampleObject},
				Nothing
			]
		],
		{Lookup[measureVolumeOptionsAssociation,MeasureDensity],Lookup[measureVolumeOptionsAssociation,MeasurementVolume],ToList[simulatedSamples]}
	];

	(* Transpose our result if there were mismatches. *)
	{measurementVolMismatchOptions,measurementVolMismatchInputs} = If[MatchQ[measurementVolMismatches,{}],
		{{},{}},
		Transpose[measurementVolMismatches]
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	measurementVolInvalidOptions = If[Length[measurementVolMismatchOptions]>0,
		If[!gatherTests,
			Message[Error::DensityMeasurementVolumeMismatch,measurementVolMismatchOptions,ObjectToString[measurementVolMismatchInputs,Cache->fullCache,Simulation->updatedSimulation]]
		];

		(* Store the errant options for later InvalidOption checks *)
		{MeasureDensity, MeasurementVolume},

	(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* Build a test for whether MeasurementVolume was provided even though MeasureDensity -> False *)
	measurementVolumeTest = Test["If MeasureDensity -> False, MeasurementVolume was not provided as an option:",
		measurementVolInvalidOptions,
		{}
	];

	(* Stash the composition of our samples *)
	sampleComps = Lookup[samplePackets,Composition];

	(* Build a list of which container's we have that are compatible with Ultrasonic measurement *)
	{ultrasonicCompatibleContainerModels,matchedIntensiveProperties} = Module[
		{containersWithNullsReplaced,listOfContainerfModelsPresent,contSearchInput,contSearchCriteria,
			compsToSearchFor,propsSearchInput,propsSearchCriteria,searchCriteria,searchInput,searchResults,
			ultrasonicSearchResults,propertySearchResults,ultrasonicCompatibleModelsDiscovered,intensivePropertiesDiscovered},

		(* If we are handed Discarded samples that do not have containers, we will throw an error above but shouldn't throw one here
		Replace any Nulls caused by samples without containers with a basic container vessel *)
		containersWithNullsReplaced=If[NullQ[#],<|Model -> PreferredContainer[1*Milliliter]|>,#]&/@containerPackets;

		(* Store the list of Model[Container] objects we'll have to deal with *)
		listOfContainerfModelsPresent = DeleteDuplicates[Download[Lookup[containersWithNullsReplaced,Model],Object]];

		(* Define the search input and criteria for each Model[Container] we'll search for *)
		contSearchInput = ConstantArray[Object[Calibration, Volume],Length[listOfContainerfModelsPresent]];
		contSearchCriteria = And[ContainerModels == #, Anomalous != True, Deprecated != True, DeveloperObject != True,LiquidLevelDetectorModel!=Null]&/@listOfContainerfModelsPresent;

		(* Build a list of models to search for, which are the de-linked models found in Composition *)
		(* NOTE: The Models field in Object[IntensiveProperty] is always sorted by the MM Sort[...] function. *)
		(* Since we search using Exactly[...] below, we must have the order match exactly. *)
		compsToSearchFor = Sort[Download[#[[All,2]],Object]]&/@sampleComps;

		(* Build a list of property Models field search criteria *)
		propsSearchInput = ConstantArray[Object[IntensiveProperty,Density],Length[samplePackets]];

		(* We don't want to search for IntensiveProperty matches if we have a Null in our Composition or in our component amounts. *)
		propsSearchCriteria = MapThread[
			Function[{sampleComposition, sortedComponents},
				If[MemberQ[sampleComposition[[All,1]], Null] || MemberQ[sortedComponents, Null],
					Exactly[Models == {$Site}], (* This should never match anything. *)
					Exactly[Models == sortedComponents]
				]
			],
			{sampleComps, compsToSearchFor}
		];

		searchCriteria = Join[contSearchCriteria,propsSearchCriteria];

		searchInput = Join[contSearchInput,propsSearchInput];

		(* Search for Object[Calibration,Volume]s that aren't anomalous or deprecated that point at one of our models *)
		searchResults = Search[
			Evaluate[searchInput],
			Evaluate[searchCriteria]
		];

		(* Split our search results into the two different search queries we were interested in *)
		ultrasonicSearchResults = Take[searchResults,Length[contSearchInput]];
		propertySearchResults = Take[searchResults,-Length[propsSearchInput]];

		(* Prepare to return the list of our Model[Container]s that have at least 1 valid Volume Calibration *)
		ultrasonicCompatibleModelsDiscovered = PickList[listOfContainerfModelsPresent,ultrasonicSearchResults,_?(Greater[Length[#],0]&)];

		(* Also prepare to return the list of Object[IntensiveProperty,Density] that we care about *)
		intensivePropertiesDiscovered = If[!MatchQ[#,{}],First[#],Null]&/@propertySearchResults;

		{ultrasonicCompatibleModelsDiscovered, intensivePropertiesDiscovered}
	];

	(* For each Object[IntensiveProperty,Density] we matched with our samples, determine if we can pull a density that matches our samples' composition *)
	(* This is a memoizing helper to determine density from the discovered Object[IntensiveProperty]s. DO NOT put this in the mapthread *)
	(* This helper has no input because the samples that would be input here may have their IDs change if they're being simulated.
	This would defeat the point of memoizing at all. This function should only be run by the options resolver and resource packet
	function, and thus the empty brackets shouldn't cause problems. The ClearAll here is left in place to prevent conflicts
	from previous ExperimentMeasureVolume calls *)
	ClearAll[mvCompositionDensities];
	mvCompositionDensities[] := mvCompositionDensities[] = If[

		(* See if we can skip past this part (eg if all the search results were {} and no objects were found) *)
		MemberQ[matchedIntensiveProperties,ObjectP[Object[IntensiveProperty,Density]]],

		(* We established we found at least one possible match so work through the samples and see if any composition matches allow us to use known densities *)
		Module[{propertyPackets},

			(* Get a download of every intensive property *)
			(* NOTE: this second download is necessary as we don't know which properties to download these values from until after we simulate the samples *)
			propertyPackets = Download[
				matchedIntensiveProperties,
				Packet[Models,Compositions,Density]
			];

			MapThread[
				Function[{sampleComposition, propertyPacket},

					(* Check that we found a property packet to work with *)
					If[!NullQ[propertyPacket],

						(* We have a packet to work with so explore if that packet has a composition that matches our sample *)
						Module[{matchingCompositionPos, possibleMatchPositions},

							(* Determine if there's a composition in the Object[IntensiveProperty] that is pretty close to our samples' composition *)
							possibleMatchPositions = Position[
								Lookup[propertyPacket,Compositions,{}],

								(* Look for a composition where every composition value is +/- 3 percent of the sample's corresponding comp value
								 but only as long as the contribution of that identiy model is known to be above a minimum amount *)
								If[
									MatchQ[
										#,
										Alternatives[
											Null,
											LessP[3VolumePercent],
											LessP[3MassPercent],
											LessP[1Millimolar],
											LessP[.03Kilogram/Liter](*~concentration of a 100-mer oligomer at 1millimolar*)
										]
									],

									(* The composition of the identity molecule is too low so set its contribution to Nothing *)
									Nothing,

									(* The identity model we're looking at has a significant contribution so match anything that is +/- 3% of its contribution *)
									RangeP[.97*#, 1.03*#]
								]&/@(sampleComposition[[All,1]])
							];

							(* If we found a position, use it to pull the density value from the corresponding Object[IntensiveProperty, Density] *)
							If[!MatchQ[possibleMatchPositions,{}],

								(* Use the position found to select a density from the property packet *)
								Mean[
									Lookup[propertyPacket,Density][[Flatten[possibleMatchPositions]]]
								],

								(* Otherwise return Null to indicate no density was found for the specific composition *)
								Null
							]
						],

						(* We did NOT find a property packet to work with so return Null *)
						Null
					]
				],
				{sampleComps,propertyPackets}
			]
		],

		(* We established there were no matching property objects so we can just return the list of nulls we got from the search block *)
		matchedIntensiveProperties
	];

	(* Set a local value to the memoized value created by *)
	(* The helper here works off of memoization so call it ONCE and DO NOT PUT THIS in the Mapthread *)
	compositionDensities = mvCompositionDensities[];

	(* If we are doing storage measurements, we want to avoid MeasureDensity altogether. However, since we need some kind of density for Gravimetric method to work *)
	(* We'll make some guess here. It will be less accurate but more robust, guaranteed to return some numeric value *)
	(* Define a memoized function to do the work *)

	allMolecules = DeleteDuplicates[Download[Cases[Flatten[sampleComps], ObjectP[Model[Molecule]]], Object]];
	ClearAll[solventEstimatedDensities];
	solventEstimatedDensities[] := solventEstimatedDensities[] = Module[
		{
			densityAssociation
		},

		densityAssociation = findCommonSolventDensities[allMolecules];

		Map[
			Function[{sampleComposition},
				Module[
					{majorCompositions, majorCompositionsCleaned, countedVolumePercent, uncountedVolumePercent, percentAndDensityList, estimatedDensity},
					(* First, find all components that's >5 VolumePercent *)
					majorCompositions = Cases[sampleComposition, {GreaterEqualP[5 VolumePercent], LinkP[], _}];

					(* Do some clean up for to speed up downstream calculations*)
					majorCompositionsCleaned = majorCompositions /. {x:VolumePercentP :> Unitless[x, VolumePercent], y:ObjectP[] :> Download[y, Object]};

					(* Find the total counted volume percentage *)
					countedVolumePercent = Total[majorCompositionsCleaned[[All,1]]];
					(* Find the remaining uncounted volume percentage. Make sure it's non-negative *)
					uncountedVolumePercent = Max[0, 100 - countedVolumePercent];
					(* Construct a list of {volume percent, density}. Use 1 g/ml for all compositions with unknown densities *)
					percentAndDensityList = (majorCompositionsCleaned /. densityAssociation) /. {ObjectP[] -> 1 Gram/Milliliter};
					(* estimate the density using weighted average. Use 1g/ml for unaccounted volume percent *)
					estimatedDensity = Total[
						(* If the total counted volume percent somehow exceeds 100%, use that value instead of 100% *)
						Map[#[[1]] * #[[2]] / Max[{countedVolumePercent, 100}] &, Join[percentAndDensityList, {{uncountedVolumePercent, 1 Gram/Milliliter, Null}}]]
					];

					(* Finally for the sake of robustness, make sure the output is within 0.5 to 3 g/ml *)
					If[MatchQ[estimatedDensity, DensityP],
						Max[Min[3 Gram/Milliliter, estimatedDensity], 0.5 Gram/Milliliter],
						(* If for whatever reason we did not get a numeric value, don't error out, use 1g/ml as default value *)
						1 Gram/Milliliter
					]
				]
			],
			sampleComps
		]
	];

	(* Store the function value into a local variable. Note we only do this estimate if we are doing storage measurement *)
	(* If not, then we make a list of Nulls for pattern matching purpose *)
	estimatedDensities = If[TrueQ[storageMeasurements],
		solventEstimatedDensities[],
		ConstantArray[Null, Length[sampleComps]]
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Resolve the preparation option *)
	resolvedPreparation = If[MatchQ[Lookup[measureVolumeOptionsAssociation,Preparation],Except[Automatic]],
		Lookup[measureVolumeOptionsAssociation,Preparation],
		Manual
	];

	(* Resolve the InSitu option *)
	inSituBools = If[inSitu,

		(* Determine whether all the samples are actually in a volume measurable position or not
			- Must be on an instrument
			- If Ultrasonic, that instrument must have a valid volume calibration for the container model in question
		*)
		MapThread[

			(* The meat of this function is to determine if MetaContainer or the MetaContainer's Container is an instrument
			If so, then we need to make sure, if it's a LiquidLevelDetector, that there is a valid VolumeCalibration between
			container and instrument *)
			Function[{containerX,metaContX,metaMetaContX,metaMetaMetaContX,volCalX},
				Which[
					(* The container is on a balance so InSitu is possible. Method checks will happen below in the large MapThread *)
					MatchQ[metaContX,ObjectP[Object[Instrument,Balance]]]||MatchQ[metaMetaContX,ObjectP[Object[Instrument,Balance]]]||MatchQ[metaMetaMetaContX,ObjectP[Object[Instrument,Balance]]],
						True,

					(* The container is on an LLD, next we must determine if the LLD has a volume calibration for the container model *)
					MatchQ[metaContX,ObjectP[Object[Instrument,LiquidLevelDetector]]]||MatchQ[metaMetaContX,ObjectP[Object[Instrument,LiquidLevelDetector]]]||MatchQ[metaMetaMetaContX,ObjectP[Object[Instrument,LiquidLevelDetector]]],

						(* Now that we know it's on an instrument we have to determine if it's in a plate-based volume check or under a sonic sensor it is compatible with *)
						Which[
							Or[MatchQ[Lookup[containerX,Position],"Plate Slot"],MatchQ[Lookup[metaContX,Position],"Plate Slot"]],
								True,

							MemberQ[
								Lookup[volCalX,{LiquidLevelDetectorModel,Anomalous,Deprecated,DeveloperObject}],
								Alternatives[
									{LinkP@Download[Lookup[metaContX,Model],Object],Except[True],Except[True],Except[True]},
									{LinkP@Download[Lookup[metaMetaContX,Model],Object],Except[True],Except[True],Except[True]},
									{LinkP@Download[Lookup[metaMetaMetaContX,Model],Object],Except[True],Except[True],Except[True]}
								]
							],
								True,

							(* The container is apparently on an in-compatible instrument so InSitu is not possible *)
							True,
								False
						],

					(* We determined the container is not on an instrument and thus InSitu is not possible *)
					True,
						False
				]
			],
			{containerPackets,metaContainers,metaContainerParents,metaMetaContainerParents,volCals}
		],

		(* If InSitu is False, just set the InSituBools to false as none should be conducted InSitu*)
		ConstantArray[False,Length[simulatedSamples]]
	];

	inSituInvalidOptions = If[!gatherTests&&inSitu&&MemberQ[inSituBools,False],
		Message[Error::InSituImpossible,ObjectToString[PickList[simulatedSamples,inSituBools,False],Cache->fullCache,Simulation->updatedSimulation]];

		(* Store the errant options for later InvalidOption checks *)
		{InSitu},

		(* No errors so just initialize the variable to a list for joining later *)
		{}
	];

	(* Determine whether the we can run this protocol as InSitu or not *)
	inSituQ = And@@inSituBools;

	(* Resolve ImageSample *)
	imageSample = Which[
		(* If we're in a subprotocol, Automatic -> False *)
		And[
			MatchQ[Lookup[measureVolumeOptionsAssociation,ImageSample],Automatic],
			!NullQ[parentProtocol]
		],
		False,

		(* If we're not in a subprotocol, Automatic -> True *)
		And[
			MatchQ[Lookup[measureVolumeOptionsAssociation,ImageSample],Automatic],
			NullQ[parentProtocol]
		],
		True,

		(* Otherwise, do whatever we were told *)
		True,
		Lookup[measureVolumeOptionsAssociation,ImageSample]
	];

	(* MapThread-ify my options such that we can investigate each option value corresponding to the sample we're resolving around *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentMeasureVolume,measurementVolumeOptionWithRoundedVolumes];

	(* -------- MAP THREAD -------- *)
	{
		methods,
		measureDensityOps,
		measurementVolumes,
		recoupSampleOps,
		(*numMeasureDensityReplicatesOps,*)
		sampleLabels,
		sampleContainerLabels,
		unmeasurableSampleErrors,
		unmeasurableContainerErrors,
		measureDensityRequiredErrors,
		sampleUltrasonicIncompatibleErrors,
		unsafeUltrasonicMeasurementErrors,
		insufficientMeasureDensityVolumeErrors,
		unsafeMeasureDensityErrors,
		centrifugeRecommendedWarnings,
		inSituMethodErrors,
		inSituMeasureDensityErrors,
		uncalibratedContainerErrors
	} = Transpose[
		MapThread[
			Function[{mySample,mySampleModel,myContainer,compositionDensity, solventDensity, myContainerModel,inSituQ,myMetaContainer,myMetaMetaContainer,myMetaMetaMetaContainer,myMapThreadOptions},
				Module[{
					solidOrDiscardedSample,
					method,measureDensity,centrifuge,measurementVolume,recoupSample,(*numMeasureDensityReplicates,*)
					unresolvedSampleLabel,unresolvedSampleContainerLabel,
					sampleLabel,myContainerNoNull,sampleContainerLabel,
					unmeasurableSampleError,
					unmeasurableContainerError,
					measureDensityRequiredError,
					sampleUltrasonicIncompatibleError,
					unsafeUltrasonicMeasurementError,
					insufficientMeasureDensityVolumeError,
					unsafeMeasureDensityError,
					centrifugeRecommendedWarning,
					inSituMethodError,
					inSituMeasureDensityError,
					uncalibratedContainerError,

					resolveMethod,
					myContents
				},

					(* Setup our error tracking variables *)
					{unmeasurableSampleError,unmeasurableContainerError,uncalibratedContainerError,measureDensityRequiredError,sampleUltrasonicIncompatibleError,unsafeUltrasonicMeasurementError,insufficientMeasureDensityVolumeError,unsafeMeasureDensityError,centrifugeRecommendedWarning,inSituMethodError,inSituMeasureDensityError}=ConstantArray[False,11];

					(* Store our SafeOps options in their variables *)
					{
						method,
						measureDensity,
						centrifuge,
						measurementVolume,
						recoupSample,
						unresolvedSampleLabel,
						unresolvedSampleContainerLabel
						(*numMeasureDensityReplicates*)
					} = Lookup[
						myMapThreadOptions,
						{
							Method,
							MeasureDensity,
							Centrifuge,
							MeasurementVolume,
							RecoupSample,
							SampleLabel,
							SampleContainerLabel
							(*NumberOfMeasureDensityReplicates*)
						}
					];

					(* If the sample is a solid or discarded, we circumvent everything and ignore it *)
					(* Note: an error would have been thrown above if this was a User protocol, and this will silently pass through if it's a *)
					solidOrDiscardedSample=Or[
						MatchQ[Lookup[mySample,State],Solid],
						MatchQ[Lookup[mySample,Status],Discarded|Null]
					];

					(* Store the contents list of the container our sample is in *)
					myContents = If[
						!solidOrDiscardedSample,
						Download[
							Lookup[myContainer,Contents][[All,2]],
							Object
						],
						Null
					];

					(* Build a helper to automatically resolve Method -> Automatic *)
					resolveMethod[Automatic] := Which[

						(* Case 0 - If the sample is a solid we can immediately ignore it.
							It will be excluded from measurement later *)
						solidOrDiscardedSample,
							Ultrasonic,

						(* InSitu Case - If the sample IS InSitu compatible, resolve to the method supported by the instrument involved *)
						inSituQ,
							Which[
								Or[MatchQ[myMetaContainer,ObjectP[Object[Instrument,Balance]]],MatchQ[myMetaMetaContainer,ObjectP[Object[Instrument,Balance]]],MatchQ[myMetaMetaMetaContainer,ObjectP[Object[Instrument,Balance]]]],
									Gravimetric,
								Or[MatchQ[myMetaContainer,ObjectP[Object[Instrument,LiquidLevelDetector]]],MatchQ[myMetaMetaContainer,ObjectP[Object[Instrument,LiquidLevelDetector]]],MatchQ[myMetaMetaMetaContainer,ObjectP[Object[Instrument,LiquidLevelDetector]]]],
									Ultrasonic,
								True,
									Ultrasonic
							],

						(* Case 1: Everything works with Gravimetric
							 - The sample has a Density OR MeasureDensity -> True AND the Volume is over 50 Microliter (min MeasureDensity requirement) AND there is no safety concern uncovering the sample in Ambient environment for density measurements
							 - The sample's container only has one thing in Contents
							 - The sample's container has a TareWeight
						*)
						And[
							Or[
								MatchQ[Lookup[mySample,Density],DensityP],
								!NullQ[mySampleModel]&&MatchQ[Lookup[mySampleModel,Density],DensityP],
								MatchQ[compositionDensity,{DensityP}],
								And[
									TrueQ[measureDensity],
									GreaterEqual[Lookup[mySample,Volume],50*Microliter],
									!MemberQ[Lookup[mySample, {Fuming, Ventilated, InertHandling, Pyrophoric}, Null], True]
								]
							],
							Or[
								MatchQ[Lookup[myContainer,TareWeight],MassP],
								MatchQ[Lookup[myContainerModel,TareWeight],MassP]
							],
							!MatchQ[myContainerModel,ObjectP[{Model[Container,Plate],Model[Container, MicrofluidicChip], Model[Container,ProteinCapillaryElectrophoresisCartridge]}]],
							MatchQ[myContents,{ObjectP[Lookup[mySample,Object]]}]
						],
							Gravimetric,

						(* Case 2: The sample is Ultrasonic Measurable
							 - EITHER:
							 		- We are FastTrack -> True so we ignore UltrasonicIncompatible
							 		- The sample is NOT UltrasonicIncompatible
							- There is no safety concern uncovering the sample in Ambient environment for ultrasonic measurement - {Fuming,Ventilated,InertHandling,Pyrophoric} (skipped for plate volume check instrument for plates or small tubes)
							 - The sample's container has a valid volume calibration
						*)
						And[
							Or[
								TrueQ[fastTrack],
								!TrueQ[Lookup[mySample,UltrasonicIncompatible]]
							],
							Or[
								MatchQ[myContainer,ObjectP[{Object[Container,Plate],Object[Container, MicrofluidicChip], Object[Container,ProteinCapillaryElectrophoresisCartridge]}]],
								MatchQ[Lookup[myContainerModel,MaxVolume],LessEqualP[2Milliliter]],
								!MemberQ[Lookup[mySample,{Fuming,Ventilated,InertHandling,Pyrophoric},Null],True]
							],
							MatchQ[Download[Lookup[myContainer,Model],Object],Alternatives@@ultrasonicCompatibleContainerModels]
						],
							Ultrasonic,

						(* Case 3: The sample is only missing Density information and we could run ExperimentMeasureDensity
							- The sample has no Density
							- There is no corresponding Object[IntensiveProperty,Density] that could provide a density for the sample
							- The sample is in a single-content container that has a TareWeight
							EITHER
								- MeasureDensity -> Automatic
								- Volume is over 50 uL (Min measurable volume for MeasureDensity)
								- There is no safety concern uncovering the sample for density measurements. The density measurement uses Micro balance, which is currently only available in Ambient environment
							OR
								- The sample has estimated density (from solventEstimatedDensities)
						*)
						(* NOTE: We put this AFTER the Ultrasonic tests for the sake of speed. Gravimetric is the most accurate measurement method but we don't want to MeasureDensity every sample we test in the lab. Quicker to go to Ultrasonic if Gravimetric isn't easily doable. If Ultrasonic isn't immediately doable we can default to Gravimetric via ExperimentMeasureDensity *)
						(* We only put solventDensity consideration here after Ultrasonic, as it is estimated and may not be as accurate as Ultrasonic either *)
						And[
							MatchQ[mySample,ObjectP[{Object[Sample]}]],
							Or[
								MatchQ[Lookup[myContainer,TareWeight],MassP],
								MatchQ[Lookup[myContainerModel,TareWeight],MassP]
							],
							!MatchQ[myContainerModel,ObjectP[{Model[Container,Plate],Model[Container, MicrofluidicChip], Model[Container,ProteinCapillaryElectrophoresisCartridge]}]],
							MatchQ[myContents,{ObjectP[Lookup[mySample,Object]]}],
							Or[
								And[
									MatchQ[measureDensity,Automatic],
									GreaterEqual[Lookup[mySample,Volume],50*Microliter],
									!MemberQ[Lookup[mySample,{Fuming,Ventilated,InertHandling,Pyrophoric},Null],True]
								],
								MatchQ[solventDensity,DensityP]
							]
						],
							Gravimetric,

						(* Case 4: The sample is the only problem because it has no density, it UltrasonicIncompatible, and it can't be moved or MeasureDensity'd
							- The sample has no Density
							- There is no corresponding Object[IntensiveProperty,Density] that could provide a density for the sample
							- We ARE allowed to MeasureDensity
							- But its Density cannot be measured (vol too low or safety concern)
							- And the sample is UltrasonicIncompatible
						*)
						And[
							NullQ[Lookup[mySample,Density]],
							NullQ[mySampleModel]||NullQ[Lookup[mySampleModel,Density]],
							!MatchQ[compositionDensity,{DensityP}],
							MatchQ[measureDensity,True|Automatic],
							TrueQ[Lookup[mySample,UltrasonicIncompatible]]
						],
							unmeasurableSampleError = True;
							Gravimetric,

						(* Final Case: We're now in a case where we can't measure the volume of this sample, but we should've been able to measure the sample by other means *)
						True,
							(
								(* If the container doesn't have a valid volume calibration but the sample was compatible with ultrasonic measurement, throw a calibration specific error *)
								If[
									And[
										!MatchQ[Download[Lookup[myContainer,Model],Object],Alternatives@@ultrasonicCompatibleContainerModels],
										!TrueQ[Lookup[mySample,UltrasonicIncompatible]],
										!MemberQ[Lookup[mySample,{Fuming,Ventilated,InertHandling,Pyrophoric},Null],True]
									],

									(* Stash an uncalibratedContainerError *)
									uncalibratedContainerError = True,

									(* Otherwise just say the sample isn't compatible with anything*)
									unmeasurableSampleError = True
								];
								Ultrasonic
							)
					];

					(* Build a helper to double check the User specified Method for Errors *)
					resolveMethod[methodX:VolumeMeasurementMethodP] := Switch[method,

						(* Run through valid option checks for Method -> Ultrasonic*)
						Ultrasonic,
							Which[

								(* If we're InSitu and marked as Ultrasonic, make sure the sample in on an LLD *)
								inSituQ,
									If[
										!Or[MatchQ[myMetaContainer,ObjectP[Object[Instrument,LiquidLevelDetector]]],MatchQ[myMetaMetaContainer,ObjectP[Object[Instrument,LiquidLevelDetector]]],MatchQ[myMetaMetaMetaContainer,ObjectP[Object[Instrument,LiquidLevelDetector]]]],
										inSituMethodError = True
									];
									methodX,

								(* If the sample solid or discarded then bypass it *)
								solidOrDiscardedSample,
									methodX,

								(* If the User asks for Ultrasonic but the sample is UltrasonicIncompatible, unless FastTrack->True, prepare an Error *)
								And[
									!TrueQ[fastTrack],
									TrueQ[Lookup[mySample,UltrasonicIncompatible]]
								],
									(
										sampleUltrasonicIncompatibleError = True;
										methodX
									),

								(* If the User asks for Ultrasonic but the sample has safety concerns for ambient uncover, prepare an Error *)
								(* This is skipped for plate volume check instrument for plates or small tubes due to their small volumes *)
								And[
									MemberQ[Lookup[mySample,{Fuming,Ventilated,InertHandling,Pyrophoric},Null],True],
									!MatchQ[myContainer,ObjectP[{Object[Container,Plate],Object[Container, MicrofluidicChip], Object[Container,ProteinCapillaryElectrophoresisCartridge]}]],
									MatchQ[Lookup[myContainerModel,MaxVolume],GreaterP[2Milliliter]]
								],
								(
									unsafeUltrasonicMeasurementError = True;
									methodX
								),

								(* If the User gives us a sample that's in a Ultrasonic compatible container, return *)
								MatchQ[Download[Lookup[myContainer,Model],Object],Alternatives@@ultrasonicCompatibleContainerModels],
									methodX,

								(* If the user gives us a container that is not presently calibrated for Ultrasonic volume measurement *)
								And[
									!MatchQ[Download[Lookup[myContainer,Model],Object],Alternatives@@ultrasonicCompatibleContainerModels],
									!TrueQ[Lookup[mySample,UltrasonicIncompatible]]
								],
									(
										uncalibratedContainerError = True;
										methodX
									),

								(* If the User asked for Ultrasonic but the container its in can't be measured Ultrasonically, we need to throw an error *)
								True,
									(
										unmeasurableContainerError = True;
										methodX
									)
							],

						(* Run through valid option checks for Method -> Gravimetric*)
						Gravimetric,
							Which[

								inSituQ,
									If[
										!Or[MatchQ[myMetaContainer,ObjectP[Object[Instrument,Balance]]],MatchQ[myMetaMetaContainer,ObjectP[Object[Instrument,Balance]]],MatchQ[myMetaMetaMetaContainer,ObjectP[Object[Instrument,Balance]]]],
										inSituMethodError = True
									];
									methodX,

								(* If the sample solid or discarded then bypass it *)
								solidOrDiscardedSample,
									methodX,

								(* If the sample has a Density and is in a container with 1 thing and the container has a TareWeight *)
								And[
									Or[
										MatchQ[Lookup[mySample,Density],DensityP],
										!NullQ[mySampleModel]&&MatchQ[Lookup[mySampleModel,Density],DensityP],
										MatchQ[compositionDensity,{DensityP}],
										MatchQ[solventDensity,DensityP],
										And[
											MatchQ[measureDensity,Alternatives[True,Automatic]],
											GreaterEqual[Lookup[mySample,Volume],50*Microliter],
											!MemberQ[Lookup[mySample,{Fuming,Ventilated,InertHandling,Pyrophoric},Null],True]
										]
									],
									Or[
										MatchQ[Lookup[myContainer,TareWeight],MassP],
										MatchQ[Lookup[myContainerModel,TareWeight],MassP]
									],
									!MatchQ[myContainerModel,ObjectP[{Model[Container,Plate],Model[Container, MicrofluidicChip], Model[Container,ProteinCapillaryElectrophoresisCartridge]}]],
									MatchQ[myContents,{ObjectP[Lookup[mySample,Object]]}]
								],
									methodX,

								(* If we don't have a density and can't MeasureDensity *)
								And[
									NullQ[Lookup[mySample,Density]],
									NullQ[mySampleModel]||NullQ[Lookup[mySampleModel,Density]],
									!MatchQ[compositionDensity,{DensityP}],
									!MatchQ[solventDensity,DensityP]
								],

									(* This might be ok if we can measure density, but if we can't decide which of two errors to throw*)
									Which[

										(* We don't have enough volume to MeasureDensity *)
										Less[Replace[Lookup[mySample,Volume],Null->0Microliter],50*Microliter],
											insufficientMeasureDensityVolumeError = True;
											methodX,

										(* We have safety concerns measuring the density of the sample *)
										MemberQ[Lookup[mySample,{Fuming,Ventilated,InertHandling,Pyrophoric},Null],True],
											unsafeMeasureDensityError = True;
											methodX,

										(* MeasureDensity is set to False *)
										!TrueQ[measureDensity],
											measureDensityRequiredError = True;
											methodX,

										(* Since we're capable of measuring density, if the container is single-content and has a tare weight we're in the clear  *)
										And[
											Or[
												MatchQ[Lookup[myContainer,TareWeight],MassP],
												MatchQ[Lookup[myContainerModel,TareWeight],MassP]
											],
											!MatchQ[myContainerModel,ObjectP[Model[Container,Plate]]],
											MatchQ[myContents,{ObjectP[Lookup[mySample,Object]]}]
										],
											methodX,

										(* We now know the container is the problem, so  Gravimetric is not a valid measurement method here so we need to throw an error *)
										True,
											unmeasurableContainerError = True;
											methodX
									],

								(* Otherwise we've determined our sample is in an unmeasurable container so we should throw an error *)
								True,
									(
										unmeasurableContainerError = True;
										methodX
									)
							],

						(* Catch-all in case new methods are added later *)
						_,
							(* You should never get here *)
							(
								unmeasurableSampleError=True;
								methodX
							)
					];

					(* Resolve our Method option *)
					method = resolveMethod[method];


					(* Throw warnings for centrifuge issues but do not resolve it *)
					If[MatchQ[centrifuge,False]&&MatchQ[method,Ultrasonic],
						centrifugeRecommendedWarning = True;
					];

					(* Resolve the MeasureDensity option *)
					measureDensity = Switch[measureDensity,

						(* If the User specified MeasureDensity -> False *)
						False,

							(* If Method -> Gravimetric and the sample has no Density *)
							If[
								And[
									MatchQ[method,Gravimetric],
									NullQ[Lookup[mySample,Density]],
									NullQ[mySampleModel]||NullQ[Lookup[mySampleModel,Density]],
									!MatchQ[compositionDensity,{DensityP}]
								],

								(* Prepare an error and return the User's specified value *)
								(
									measureDensityRequiredError = True;
									False
								),

								(* Otherwise there's no issue, set it to False *)
								False
							],

						(* If the User specified MeasureDensity -> True *)
						True,

							(* If InSitu -> True *)
							If[
								inSituQ,

								(* If User asked for MeasureDensity AND specified InSitu, throw an error *)
								(
									inSituMeasureDensityError = True;
									True
								),

								(* If the sample doesn't have enough volume throw an error *)
								If[Less[Lookup[mySample,Volume],50*Microliter],
									(
										insufficientMeasureDensityVolumeError = True;
										True
									),

									(* Other there's no issue, set it to True *)
									True
								]
							],

						(* If the User specified MeasureDensity -> Automatic *)
						Automatic,

							(* InSitu was False and we determined Method -> Gravimetric *)
							If[And[!inSituQ,MatchQ[method,Gravimetric]],

								(* If the sample has a density *)
								If[
									Or[
										MatchQ[Lookup[mySample,Density],DensityP],
										!NullQ[mySampleModel]&&MatchQ[Lookup[mySampleModel,Density],DensityP],
										MatchQ[compositionDensity,DensityP],
										MatchQ[solventDensity, DensityP]
									],

									(* MeasureDensity -> False *)
									False,

									(* Otherwise we need to make sure the sample can have it's density measured *)
									If[GreaterEqual[Lookup[mySample,Volume],50*Microliter],

										(* Set MeasureDensity -> True *)
										True,

										(* Otherwise the sample can't have it's density measured and we have a problem *)
										(
											insufficientMeasureDensityVolumeError = True;
											Null
										)
									]
								],

								(* If Method != Gravimetric, there's no need to MeasureDensity *)
								False
							]
					];

					(* For now we'll just replace the options with reasonable values *)
					{measurementVolume,recoupSample(*numMeasureDensityReplicates*)} = If[TrueQ[measureDensity],
						{
							(* MeasurementVolume for MeasureDensity maxes out at 1mL *)
							Replace[
								measurementVolume,
								Automatic->If[MatchQ[0.9*Lookup[mySample,Volume],LessEqualP[50Microliter]],
									50Microliter,
									Min[
										Round[UnitScale[0.9*Lookup[mySample,Volume]],10^-2],
										1Milliliter
									]
								]
							],
							Replace[recoupSample,Automatic->True](*,
							Replace[numMeasureDensityReplicates,Automatic->5]*)
						},
						{
							Replace[measurementVolume,Automatic->Null],
							Replace[recoupSample,Automatic->Null](*,
							Replace[numMeasureDensityReplicates,Automatic->Null]*)
						}
					];

					(* Resolve the label options *)
					(* for Sample/ContainerLabel options, automatically resolve to Null *)
					(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
					(* labels if we have duplicates. *)
					sampleLabel = Which[
						Not[MatchQ[unresolvedSampleLabel, Automatic]],
						unresolvedSampleLabel,
						MatchQ[updatedSimulation, SimulationP] && MemberQ[Lookup[updatedSimulation[[1]], Labels][[All,2]], Lookup[mySample, Object]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[mySample, Object]],
						True,
						"measure volume sample " <> StringDrop[Lookup[mySample, ID], 3]
					];
					(* If we don't have a container, need to not use Null *)
					myContainerNoNull = myContainer /. {Null -> {}};
					sampleContainerLabel = Which[
						Not[MatchQ[unresolvedSampleContainerLabel, Automatic]],
						unresolvedSampleContainerLabel,
						MatchQ[updatedSimulation, SimulationP] && MemberQ[Lookup[updatedSimulation[[1]], Labels][[All, 2]], Lookup[myContainerNoNull, Object,Null]],
						Lookup[Reverse /@ Lookup[updatedSimulation[[1]], Labels], Lookup[myContainerNoNull, Object]],
						(* In case we have a container-less sample, use sample ID *)
						True,
						"measure volume container " <> StringDrop[Lookup[myContainerNoNull, ID, Lookup[mySample, ID]], 3]
					];

					(* Gather MapThread results *)
					{
						method,
						measureDensity,
						measurementVolume,
						recoupSample,
						sampleLabel,
						sampleContainerLabel,
						(*numMeasureDensityReplicates,*)
						unmeasurableSampleError,
						unmeasurableContainerError,
						measureDensityRequiredError,
						sampleUltrasonicIncompatibleError,
						unsafeUltrasonicMeasurementError,
						insufficientMeasureDensityVolumeError,
						unsafeMeasureDensityError,
						centrifugeRecommendedWarning,
						inSituMethodError,
						inSituMeasureDensityError,
						uncalibratedContainerError
					}
				]
			],

			(* MapThread over our index-matched lists *)
			{samplePackets,sampleModelPackets,containerPackets,compositionDensities, estimatedDensities, modelContainerPackets,inSituBools,metaContainers,metaContainerParents,metaMetaContainerParents,mapThreadFriendlyOptions}
		]
	];

	(* --- UNRESOLVABLE OPTION CHECKS --- *)

	(* Define a helper that will generate lookup patterns based on whether the sample's id is of the form "id:..." or the
	 sample's name. This is required to lookup samples stored as Object[Sample,Subtype,"The Sample's Name"] *)
	lookupP[objsForPattern:ListableP[ObjectP[Object]]] := If[StringMatchQ[Last[#],"id:"~~___],

	(* If ID is used as the string, return an Object pattern *)
		Object -> #,

	(* Otherwise a name was provided for the string, so we want to look the object by the name field *)
		Name -> Last[#]

	]&/@ToList[objsForPattern];

	(* Unmeasurable sample error check *)
	unmeasurableSampleInvalidInputs=If[Or@@unmeasurableSampleErrors&&!gatherTests,
		Module[{invalidSamples},
		(* Get the samples that correspond to this error. *)
			invalidSamples=Download[PickList[simulatedSamples,unmeasurableSampleErrors],Object];

			(* Throw the corresponding error. *)
			Message[Error::UnmeasurableSample,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			invalidSamples
		],
		{}
	];

	(* Create the corresponding test for the unmeasurable container error. *)
	unmeasurableSampleTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
		(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,unmeasurableSampleErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", are measurable by volume measurement methods in the lab:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", are measurable by volume measurement methods in the lab:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Unmeasurable container error check *)
	unmeasurableContainerInvalidOptions=If[Or@@unmeasurableContainerErrors&&!gatherTests,
		Module[{invalidSamples,sampleMethods},
			(* Get the samples that correspond to this error. *)
			invalidSamples=Download[PickList[simulatedSamples,unmeasurableContainerErrors],Object];

			(* Get the volumes of these samples. *)
			sampleMethods=PickList[methods,unmeasurableContainerErrors];

			(* Throw the corresponding error. *)
			Message[Error::UnmeasurableContainer,ToString[sampleMethods],ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{Method}
		],
		{}
	];

	(* Unmeasurable container error check *)
	uncalibratedContainerInvalidInputs = If[Or@@uncalibratedContainerErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=Download[PickList[simulatedSamples,uncalibratedContainerErrors],Object];

			(* Throw the corresponding error. *)
			Message[Error::VolumeCalibrationsMissing,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{invalidSamples}
		],
		{}
	];

	(* Create the corresponding test for the uncalibrated container error. *)
	uncalibratedContainerTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,uncalibratedContainerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The containers of the following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", have valid volume calibrations associated with them:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The containers of the following samples, "<>ObjectToString[passingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", have valid volume calibrations associated with them:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Create the corresponding test for the unmeasurable container error. *)
	unmeasurableContainerTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
		(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,unmeasurableContainerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The containers of the following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", are measurable with their specified Method:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The containers of the following samples, "<>ObjectToString[passingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", are measurable with their specified Method:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* MeasureDensity required error check *)
	measureDensityRequiredInvalidOptions=If[Or@@measureDensityRequiredErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples=Download[PickList[simulatedSamples,measureDensityRequiredErrors],Object];

			(* Throw the corresponding error. *)
			Message[Error::MeasureDensityRequired,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{MeasureDensity}
		],
		{}
	];

	(* Create the corresponding test for the unmeasurable container error. *)
	measureDensityRequiredTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
		(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,measureDensityRequiredErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", do not need their Density measured prior to their Volume being Gravimetrically measured:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", do not need their Density measured prior to their Volume being Gravimetrically measured:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Sample UltraonicIncompatible error check *)
	sampleUltrasonicIncompatibleInvalidOptions=If[Or@@sampleUltrasonicIncompatibleErrors&&!gatherTests,
		Module[{invalidSamples,sampleMethods},
			(* Get the samples that correspond to this error. *)
			invalidSamples=Download[PickList[simulatedSamples,sampleUltrasonicIncompatibleErrors],Object];

			(* Throw the corresponding error. *)
			Message[Error::SampleUltrasonicIncompatible,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{Method}
		],
		{}
	];

	(* Create the corresponding test for the UltraonicIncompatible error. *)
	sampleUltrasonicIncompatibleTests=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
		(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,sampleUltrasonicIncompatibleErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["Samples that are being Ultrasonically volume measured ("<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>") are compatible with Ultrasonic volume measurement:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", are either being measured Gravimetrically or are compatible with Ultrasonic volume measurement:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Sample EHS error check *)
	unsafeUltrasonicMeasurementInvalidOptions=If[Or@@unsafeUltrasonicMeasurementErrors&&!gatherTests,
		Module[{invalidSamples,sampleMethods},
			(* Get the samples that correspond to this error. *)
			invalidSamples=Download[PickList[simulatedSamples,unsafeUltrasonicMeasurementErrors],Object];

			(* Throw the corresponding error. *)
			Message[Error::SampleEHSUltrasonicIncompatible,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{Method}
		],
		{}
	];

	(* Create the corresponding test for the UltraonicIncompatible error. *)
	unsafeUltrasonicMeasurementTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,unsafeUltrasonicMeasurementErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["Samples that are being Ultrasonically volume measured ("<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>") are safe to handle at Ambient environment (Fuming, Ventilated, InertHandling and Pyrophoric are not True):",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", are either being measured Gravimetrically or are safe to handle at Ambient environment (Fuming, Ventilated, InertHandling and Pyrophoric are not True):",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Insufficient MeasureDensity volume error check *)
	insufficientMeasureDensityVolumeInvalidInputs=If[Or@@insufficientMeasureDensityVolumeErrors&&!gatherTests,
		Module[{invalidSamples,lookupPatterns,sampleVolumes},
		(* Get the samples that correspond to this error. *)
			invalidSamples = Lookup[PickList[simulatedSamples,insufficientMeasureDensityVolumeErrors],Object];

			(* Store the lookup patterns for our failing samples *)
			lookupPatterns = lookupP[invalidSamples];

			(* Get the volumes of these samples. *)
			sampleVolumes = Lookup[FirstCase[samplePackets,KeyValuePattern[#]],Volume,0 Liter]&/@lookupPatterns;

			(* Throw the corresponding error. *)
			Message[Error::InsufficientMeasureDensityVolume,sampleVolumes,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			(* Return our invalid samples. *)
			invalidSamples
		],
		{}
	];

	(* Create the corresponding test for the unmeasurable container error. *)
	insufficientMeasureDensityVolumeTests=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
		(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,insufficientMeasureDensityVolumeErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", have enough volume to have their Density measured:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", have enough volume to have their Density measured or aren't going to have their Density measured:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Insufficient MeasureDensity volume error check *)
	unsafeMeasureDensityInvalidOptions=If[Or@@unsafeMeasureDensityErrors&&!gatherTests,
		Module[{invalidSamples},
			(* Get the samples that correspond to this error. *)
			invalidSamples = Lookup[PickList[simulatedSamples,unsafeMeasureDensityErrors],Object];

			(* Throw the corresponding error. *)
			Message[Error::UnsafeMeasureDensity,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			(* Return our invalid options. *)
			{Method}
		],
		{}
	];

	(* Create the corresponding test for the unmeasurable container error. *)
	unsafeMeasureDensityTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,unsafeMeasureDensityErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", are safe to handle at Ambient environment to have their Density measured (Fuming, Ventilated, InertHandling and Pyrophoric are not True):",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", are being measured Gravimetrically, have their Density information populated, or are safe to handle at Ambient environment to have their Density measured (Fuming, Ventilated, InertHandling and Pyrophoric are not True):",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Centrifuge recommended Warning *)
	If[Or@@centrifugeRecommendedWarnings&&!gatherTests&&!MatchQ[$ECLApplication,Engine],
		Module[{invalidSamples},
		(* Get the samples that correspond to this error. *)
			invalidSamples=Download[PickList[simulatedSamples,centrifugeRecommendedWarnings],Object];

			(* Throw the corresponding error. *)
			Message[Warning::CentrifugeRecommended,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]]
		],

		{}
	];

	(* Create the corresponding test for the unmeasurable container error. *)
	centrifugeRecommendedTests=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
		(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,centrifugeRecommendedWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Warning["The following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", will not be Centrifuged, even though they will have their volume Ultrasonically measured:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->fullCache,Simulation->updatedSimulation]<>", may be centrifuged, if needed, for Ultrasonic volume measurement:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* InSitu doesn't comply with Method checks *)
	inSituMethodInvalidOptions = If[Or@@inSituMethodErrors&&!gatherTests,
		Module[{invalidSamples,invalidMethods},
			(* Get the samples that correspond to this error. *)
			invalidSamples = Download[PickList[simulatedSamples,inSituMethodErrors],Object];

			(* Get the list of invalid methods *)
			invalidMethods = ToString/@PickList[methods,inSituMethodErrors];

			(* Throw the corresponding error. *)
			Message[Error::InvalidInSituMethod,invalidMethods,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			{InSitu,Method}
		],
		{}
	];

	(* InSitu doesn't comply with MeasureDensity checks *)
	inSituMeasureDensityInvalidOptions = If[Or@@inSituMeasureDensityErrors&&!gatherTests,
		Module[{invalidSamples},
		(* Get the samples that correspond to this error. *)
			invalidSamples =Download[PickList[simulatedSamples,inSituMeasureDensityErrors],Object];

			(* Throw the corresponding error. *)
			Message[Error::InvalidInSituMeasureDensity,ObjectToString[invalidSamples,Cache->fullCache,Simulation->updatedSimulation]];

			{InSitu,MeasureDensity}
		],
		{}
	];


	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates@Flatten[
		{
			discardedInvalidInputs,
			immobileInvalidInputs,
			unmeasurableSampleInvalidInputs,
			uncalibratedContainerInvalidInputs,
			insufficientMeasureDensityVolumeInvalidInputs
		}
	];
	invalidOptions=DeleteDuplicates@Flatten[
		{
			(*numMeasureDensityInvalidOptions,*)
			recoupSampleInvalidOptions,
			measurementVolInvalidOptions,
			unmeasurableContainerInvalidOptions,
			measureDensityRequiredInvalidOptions,
			sampleUltrasonicIncompatibleInvalidOptions,
			unsafeUltrasonicMeasurementInvalidOptions,
			unsafeMeasureDensityInvalidOptions,
			inSituInvalidOptions,
			inSituMethodInvalidOptions,
			inSituMeasureDensityInvalidOptions,
			sameContainerStorageConditionConflictOption
		}
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests&&Length[invalidInputs]>0,
		Message[Error::InvalidInput,invalidInputs]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests&&Length[invalidOptions]>0,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* Determine how much volume the protocol will require. This ONLY applies if MeasureDensity -> True and RecoupSample -> False *)
	(* TODO: Update this if we re-enable NumberOfMeasureDensityReplicates *)
	requiredAliquotAmounts = MapThread[
		Function[
			{measureDensity,reocoupSample,measurementVol},
			If[
				TrueQ[measureDensity] && !TrueQ[reocoupSample] && !NullQ[measurementVol],
				measurementVol * 5, (* 5 is the currently hardcoded number of NumberOfMeasureDensityReplicates *)
				Null
			]
		],
		{measureDensityOps,recoupSampleOps,measurementVolumes}
	];

	(* NOTE: Aliquotting would normally go hear but we do not permit Aliquotting in post-processing experiments *)
	(* Cont: However a user can aliquot samples before a MeasureVolume (though this is really weird) so we still have to resolve them *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,

		resolveAliquotOptions[
			ExperimentMeasureVolume,
			mySamples,simulatedSamples,
			ReplaceRule[myOptions, resolvedSamplePrepOptions],
			RequiredAliquotAmounts -> requiredAliquotAmounts,
			AliquotWarningMessage -> Null,(* This warning only applies to mismatched container options *)
			Cache->fullCache,
			Simulation->updatedSimulation,
			Output->{Result,Tests}
		],

		{
			resolveAliquotOptions[
				ExperimentMeasureVolume,
				mySamples,
				simulatedSamples,
				ReplaceRule[myOptions, resolvedSamplePrepOptions],
				RequiredAliquotAmounts -> requiredAliquotAmounts,
				AliquotWarningMessage -> Null,(* This warning only applies to mismatched container options *)
				Cache -> fullCache,
				Simulation->updatedSimulation,
				Output -> Result
			],
			{}
		}
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			{
				Method -> methods,
				MeasureDensity -> measureDensityOps,
				MeasurementVolume -> measurementVolumes,
				RecoupSample -> recoupSampleOps,
				SampleLabel -> sampleLabels,
				SampleContainerLabel -> sampleContainerLabels,
				Preparation -> resolvedPreparation,
				(*NumberOfMeasureDensityReplicates -> numMeasureDensityReplicatesOps,*)
				ErrorTolerance -> Lookup[measurementVolumeOptionWithRoundedVolumes,ErrorTolerance],
				ParentProtocol -> Lookup[measurementVolumeOptionWithRoundedVolumes,ParentProtocol],
				PreparatoryUnitOperations->Lookup[myOptions,PreparatoryUnitOperations],
				Confirm -> Lookup[myOptions,Confirm],
				CanaryBranch -> Lookup[myOptions,CanaryBranch],
				Template -> Lookup[myOptions,Template],
				Name -> Lookup[myOptions,Name],
				OptionsResolverOnly -> Lookup[myOptions,OptionsResolverOnly],
				ImageSample -> imageSample,
				InSitu -> inSitu,
				SamplesInStorageCondition->suppliedSampleInStorageCondition (*,
				NumberOfReplicates->numberOfReplicates
				*)
			}
		],

		Tests -> Flatten[{
			samplePrepTests,
			immobileSampleTests,
			discardedTests,
			measurementVolumePrecisionTests,
			(*numMeasureDensityTest,*)
			recoupSampleTest,
			measurementVolumeTest,
			unmeasurableSampleTest,
			unmeasurableContainerTest,
			sampleUltrasonicIncompatibleTests,
			unsafeUltrasonicMeasurementTests,
			measureDensityRequiredTest,
			unsafeMeasureDensityTests,
			insufficientMeasureDensityVolumeTests,
			centrifugeRecommendedTests,
			aliquotTests,
			sameContainerStorageConditionConflictTest,
			uncalibratedContainerTest
		}]
	}
];


(* ::Subsubsection:: *)
(*measureVolumeResourcePackets*)


DefineOptions[
	measureVolumeResourcePackets,
	Options :>{
		CacheOption,
		OutputOption,
		SimulationOption
	}
];

measureVolumeResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:Alternatives[{_Rule..},{}],myResolvedOptions:{_Rule..},myOptions:OptionsPattern[]]:=Module[
	{
		safeOps,outputSpecification,output,gatherTests,messages,inheritedCache,simulation,parentProtocol,maintenanceQ,qualificationQ,
		resolvedOptionsNoHidden,inSitu,
		lookupObjID,dupeFreeResources,resourcesToSampleMap,
		containerPackets,containerModelPackets,volCalibrationPackets,
		sonicMethodPositions,weightMethodPositions,sonicMethodContainers,weightMethodContainers,
		sonicDistanceModels,sonicDistanceHeightRules,sonicDistanceContainerContents,
		modelFormFactorIdentifiers,uniqueModelFormFactors,groupedSonicDistanceContainers,
		groupedSonicDistanceContents,uniqueFormFactorPositions,containerGroupRepresentativeModels,containerGroupHeights,
		containerGroupCalibrationPackets,sonicDistanceAssociations,tubeRackPositionTuples,stickyRackModels,uniqueTubeRacks,tubeRackResources,
		tubeRackResourceLookup,uniquePlatePlatforms,platePlatformResources,platePlatformResourceLookup,
		liquidLevelDetectorSets,collapseLiquidLevelDetectorSetsFunction,liquidLevelDetectorResourceSets,
		liquidLevelDetectorResources,allObjectIDs,protocolID,sonicDistancePacketsWithResources,
		simulatedSampObjects,simulatedSamps,allSamplePackets,parentTargetListed,simulatedSampsListed,updatedSimulation,workingContainers,sampleReplicateRules,containerReplicateRules,
		replicatedContainers,myExpandedSimulatedSamples,unsortedSonicContainers,unsortedWeightContainers,
		orderedSonicAssociations,sonicDistanceContainersIn,sonicDistanceSamplesIn,weightContainerPositions,
		weightContainerContents,containersIn,samplesInResources,measureDensity,samplesToDensityMeasure,
		expandedAndFilteredMeasurementVolume,expandedAndFilteredRecoupSample,(*numberOfDensityReplicatesOption,*)updatedBy,
		protocolPacket,protocolAndProgramPackets,rootProtocol,packetsIncludingResources,measureDensityParameters,
		batchLengths,batchedSamps,batchedSamples,batchedContainers,batchedRacks,batchedMeasurementDevices,
		batchLengthsContainers,batchLengthsSamples,myExpandedSamples,myExpandedOptions,
		tubeRackPlacements,sonicDistanceContainerIndexes,sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable,
		frqTests,previewRule,optionsRule,testsRule,resultRule,containerLookup,metaContainerPackets,metaMetaContainerPackets,
		groupedMetaContainers,groupedMetaMetaContainers,groupedMetaMetaMetaContainers,metaMetaMetaContainerPackets,
		liquidLevelDetectors,duplicateFreeDetectors,sonicAssociations,reverseContainerLookup,knownDensities,samplePackets,sampleModelPackets,
		rackModelPacks,parentTarget,cleanedVolCalPackets,sensorArmHeightLookup,layoutFileNameLookup,sonicRackModelLookup,sonicRackPacketLookup,
		modelFormFactorIdentifiersWithCalibration, numberOfReplicates, batchedVolumeCalibrations, containerCache, batchedVolumeCalibrationsObject
	},

	(* Stash safe options *)
	safeOps = SafeOptions[measureVolumeResourcePackets,ToList[myOptions]];

	(* Determine the requested output format of this function. *)
	outputSpecification = Lookup[safeOps,Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* get the cache that was passed from the main function *)
	inheritedCache = Lookup[safeOps, Cache, {}];
	simulation  = Lookup[safeOps, Simulation, Simulation[]];

	(* Store the ParentProtocol of the protocol being created *)
	parentProtocol = Lookup[myResolvedOptions,ParentProtocol];

	(* Figure out if this function is being called as part of an Object[Maintenance, CalibrateVolume]. *)
	maintenanceQ = MatchQ[parentProtocol, ObjectP[Object[Maintenance, CalibrateVolume]]];

	(* Figure out if this function is being called as part of an Object[Qualification, LiquidLevelDetector]. *)
	qualificationQ = MatchQ[parentProtocol, ObjectP[Object[Qualification, LiquidLevelDetector]]];

	(* Determine if we expect this to be an InSitu protocol *)
	inSitu = Lookup[myResolvedOptions,InSitu];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentMeasureVolume,
		RemoveHiddenOptions[ExperimentMeasureVolume, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Regenerate the simulations done in the option resolver *)
	{simulatedSampObjects,updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentMeasureVolume,Download[mySamples,Object],myResolvedOptions,Cache->inheritedCache,Simulation->simulation];

	{allSamplePackets, parentTargetListed, simulatedSampsListed} = Quiet[Download[
		{
			simulatedSampObjects,
			{parentProtocol},
			simulatedSampObjects
		},
		{
			{
				(* Sample Packets *)Packet[Density],
				(* Sample Model Packets *)Packet[Model[{Density}]],
				(* Container Packet *)Packet[Container[{Model, Contents, Container, Position}]],
				(* Container Model Packet *)Packet[Container[Model][{VolumeCalibrations, Dimensions}]],
				(* Container's Container Packet *)Packet[Container[Container][{Model, Position, Container}]],
				(* Container's Container's Container Packet *)Packet[Container[Container][Container][{Model, Position, Container}]],
				(* Container's Container's Container's Container Packet *)Packet[Container[Container][Container][Container][{Model, Position, Container}]],
				(* Volume Calibration Packets *)Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel, LiquidLevelDetector, Anomalous, Deprecated, DeveloperObject, RackModel, LayoutFileName, SensorArmHeight, Name}]],
				(* Rack Model Packets *)Packet[Container[Model][VolumeCalibrations][RackModel][{Positions, Footprint}]]
			},
			{
				Target
			},
			{All}
		},
		Cache -> inheritedCache,
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist}];

	(* Pull values out of the downloaded packets *)
	{samplePackets,sampleModelPackets,containerPackets,containerModelPackets,metaContainerPackets,metaMetaContainerPackets,metaMetaMetaContainerPackets,volCalibrationPackets,rackModelPacks}=Transpose[allSamplePackets];
	parentTarget=FirstOrDefault[Flatten[parentTargetListed]];
	simulatedSamps = Flatten[simulatedSampsListed];

	(* Build a sample to simulated sample lookup. Then convert that to a Container to SimulatedContainer lookup *)
	containerLookup = DeleteDuplicates@MapThread[Rule,
		{
			Download[Lookup[mySamples,Container],Object],
			Download[Lookup[simulatedSamps,Container],Object]
		}
	];

	(* Create a reverse mapping as well. *)
	reverseContainerLookup=Reverse/@containerLookup;

	(* Get our NumberOfReplicates option. *)
	(* numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates,1]/.{Null->1}; *)

	(* For now set this option to 1 *)
	numberOfReplicates = 1;

	(* Expand our input samples and resolved options. *)
	myExpandedSamples=Flatten[(ConstantArray[#,numberOfReplicates]&)/@mySamples];
	myExpandedSimulatedSamples=Flatten[(ConstantArray[#,numberOfReplicates]&)/@simulatedSamps];
	myExpandedOptions=MapThread[
		Rule[
			#1,
			Flatten[
				Map[
					Function[{optionVal},ConstantArray[optionVal,numberOfReplicates]],
					#2
				]
			]
		]&,
		{
			{Method,Centrifuge,MeasureDensity,MeasurementVolume,RecoupSample(*NumberOfMeasureDensityReplicates*)},
			Lookup[myResolvedOptions, {Method,Centrifuge,MeasureDensity,MeasurementVolume,RecoupSample(*NumberOfMeasureDensityReplicates*)}]
		}
	];

	(* Store a simulation of what WorkingContainers will look like *)
	workingContainers = DeleteDuplicates[containerPackets];

	(* Clean out our volume calibrations of any Anomalous, Deprecated or DeveloperObject volume calibrations, also remove ones with no LiquidLevelDetectorModel, these are probably cap sensor calibrations *)
	(* Take the first in the reversed list because it should be the most recently created one *)
	cleanedVolCalPackets = If[MatchQ[#,{(_Association)..}],
		FirstCase[
			Reverse[#],
			AssociationMatchP[
				<|
					Object->ObjectP[Object[Calibration,Volume]],
					Anomalous->Except[True],
					Deprecated->Except[True],
					DeveloperObject->Except[True],
					LiquidLevelDetectorModel->Except[Null],
					(* If we are in a calibrate volume maintenance, we need a calibration from the target (it can be a placeholder or not) *)
					If[
						maintenanceQ,
						LiquidLevelDetector->ObjectP[parentTarget],
						(* If we are not in a calibrate volume maintenance, then we cannot use a placeholder calibration *)
						Name->_?(Not[StringContainsQ[#/.Null->"","Placeholder calibration for "~~__~~uuid_/;MatchQ[uuid, UUIDP]]]&)
					]
				|>,
				AllowForeignKeys->True],
			<||>],
		<||>
	]&/@volCalibrationPackets;

	(* Build volume calibration lookups *)
	sensorArmHeightLookup = DeleteDuplicates@MapThread[Rule,{Lookup[containerModelPackets,Object],Lookup[cleanedVolCalPackets,SensorArmHeight,Null]}];
	layoutFileNameLookup = DeleteDuplicates@MapThread[Rule,{Lookup[containerModelPackets,Object],Lookup[cleanedVolCalPackets,LayoutFileName,Null]}];
	sonicRackModelLookup = DeleteDuplicates@MapThread[Rule,{Lookup[containerModelPackets,Object],Lookup[cleanedVolCalPackets,RackModel,Null]}];

	sonicRackPacketLookup[rackMod:ObjectP[Model[Container,Rack]]|Null]:=If[!NullQ[rackMod],

		(* Find the first packet with that object *)
		FirstCase[Flatten[rackModelPacks],AssociationMatchP[<|Object->Download[rackMod,Object]|>, AllowForeignKeys->True]],

		(* No Rack, return Null*)
		<||>
	];

	(* Build a list of rules that counts the number of time each sample will be measured
	(this is NumberOfReplicates * number of times the sample showed up in the input) *)
	sampleReplicateRules = Map[Apply[Rule,#]&, Tally[Download[simulatedSamps,Object]]];

	(* Build a list of rules that counts how many times a container will be measured
	 (Plates will only be read the max number of times one of their contents will be measured)
	 Example: Input was {sampleA, sampleB, sampleC, sampleA} and the two samples are in a plate,
	  	the plate must be measured twice instead of once or three times
	*)
	containerReplicateRules = Map[
		Rule[
			#,
			Max[
				DeleteCases[
					ReplaceAll[
						Download[Lookup[#,Contents][[All, 2]],Object],
						sampleReplicateRules
					],
					Except[_Integer]
				]
			]
		]&,
		workingContainers
	];

	(* Now expand our simulated container list by the number of times a container must be measured *)
	replicatedContainers = Flatten[Table[#,Replace[#,containerReplicateRules]]&/@workingContainers];

	(* Make a list, by pulling from SimulatedSamples, of the containers to be used in Sonic measurement *)
	unsortedSonicContainers = DeleteDuplicates[
		Download[
			Lookup[
				PickList[
					myExpandedSimulatedSamples,
					Lookup[myExpandedOptions,Method],
					Ultrasonic
				],
				Container
			],
			Object
		]
	];

	(* Make a list, by pulling from SimulatedSamples, of the containers to be used in Weight measurement *)
	unsortedWeightContainers = DeleteDuplicates[
		Download[
			Lookup[
				PickList[
					myExpandedSimulatedSamples,
					Lookup[myExpandedOptions,Method],
					Gravimetric
				],
				Container
			],
			Object
		]
	];

	(* Build a helper that can convert Object[Sample,Subtype,"Sample Name"] to Object[Sample,Subtype,"id:blahblah"] *)
	lookupObjID[objsForPattern:ListableP[PacketP[Object]]] := Lookup[objsForPattern,Object];
	lookupObjID[objsForPattern:ListableP[ObjectReferenceP[Object]]] := If[!StringMatchQ[Last[#],"id:"~~___],

		(* Search our packets for the sample with that name *)
		FirstCase[simulatedSamps,KeyValuePattern[Name->Last[#]],#],

		(* Otherwise we already have an object with an ID so return it *)
		FirstCase[simulatedSamps,KeyValuePattern[ID->Last[#]],#]
	]&/@ToList[objsForPattern];

	(* --- SonicDistance Program Packet Creation --- *)

	(* Find the containers being measured with each volume measurement Method *)
	(* Delete duplicates is necessary as the positions are determined by the Method option which is indexed to SamplesIn *)
	sonicMethodContainers = ReplaceAll[
		Cases[replicatedContainers,KeyValuePattern[Object->(Alternatives@@unsortedSonicContainers)]],
		containerLookup
	];
	weightMethodContainers = ReplaceAll[
		Cases[replicatedContainers,KeyValuePattern[Object->(Alternatives@@unsortedWeightContainers)]],
		containerLookup
	];

	(* Determine which model containers will be used in sonic ping measurement *)
	sonicDistanceModels = FirstCase[containerModelPackets,KeyValuePattern[Object->#]]&/@Download[Lookup[sonicMethodContainers,Model,{}],Object];

	(* Gather the heights of each model container involved in sonic ping measurement *)
	sonicDistanceHeightRules = If[
		GreaterEqual[Length[sonicDistanceModels],1],
		MapThread[#1->#2[[3]]&,{Lookup[sonicDistanceModels,Object],Lookup[sonicDistanceModels,Dimensions]}],
		{}
	];

	(* create a list that converts the container models into unique identifiers based on form factor;
	 	this may be just the model if it is not in a group of like form factors, or a unique group identifier *)
	modelFormFactorIdentifiers = formFactorGroup/@Lookup[sonicDistanceModels,Object];

	modelFormFactorIdentifiersWithCalibration=If[!MatchQ[sonicDistanceModels,{}],
		Transpose[{modelFormFactorIdentifiers,Download[Last@#, LiquidLevelDetectorModel]/@Lookup[sonicDistanceModels,VolumeCalibrations]}]/. Link[x_, __] :> x,
		{}
	];

	(* collapse the modelFormFactorIdentifiers into unique/duplicate free list *)
	uniqueModelFormFactors = DeleteDuplicates[modelFormFactorIdentifiersWithCalibration];

	dupeFreePartition[objList_List, maxPerBatch:(_Integer|Infinity)] := If[DuplicateFreeQ[Lookup[objList,Object]],

		(* The list is duplicate free so all we do is partition remainder unless we've been told not to partition by number *)
		If[MatchQ[maxPerBatch,Infinity],
			{objList},
			PartitionRemainder[objList,maxPerBatch]
		],

		(* The list was not duplicate free, so we have to no build multiple duplicate free lists of length N instead *)
		Module[{gatheredObjs, greatestLength, expandedGatheredList},

			(* Gather into lists of the same object *)
			gatheredObjs = GatherBy[objList,Lookup[#,Object]&];

			(* Determine the max number of times an object is found *)
			greatestLength = Max[Length /@ gatheredObjs];

			(* We want to Transpose in a second, but to do so each sublist must be the same length, so pad with Nulls *)
			expandedGatheredList = PadRight[#, greatestLength, Null] & /@ gatheredObjs;

			(* Now we will transpose our gathered lists, giving us many duplicate free lists, but then we'll partition remainder
			 those to ensure no list is greater than the maxContainersPerBatch *)
			Flatten[
				Map[
					{DeleteCases[#,Null]}&,
					Transpose[expandedGatheredList]
				],

				(* We've potentially generated extra list heads, so flattening to 1 layer gives us back a list of lists*)
				1
			]
		]
	];

	(* group the sonic distance containers based on the unique model form factors *)
	groupedSonicDistanceContainers = PickList[sonicMethodContainers,modelFormFactorIdentifiersWithCalibration,#]&/@uniqueModelFormFactors;

	(* group the container contents based on the unique model form factors, flattening each container group's content list *)
	groupedSonicDistanceContents = Download[Flatten[Lookup[#,Contents][[All,All,2]]],Object]&/@groupedSonicDistanceContainers;

	(* Following gathers containers for InSitu protocol execution *)
	(* gather the containers of the grouped containers - let's kick this up a notch *)
	groupedMetaContainers = Function[
		{sublistOfContainers},
		DeleteDuplicates[
			Function[
				{containerY},
				FirstCase[metaContainerPackets,ObjectP@Lookup[containerY,Container]]
			]/@sublistOfContainers
		]
	]/@groupedSonicDistanceContainers;

	(* now gather the container of the container's container...did you think we were done? *)
	groupedMetaMetaContainers = If[inSitu,
		Function[
			{sublistOfMetaContainers},
			DeleteDuplicates[
				Function[
					{containerY},
					FirstCase[metaMetaContainerPackets,ObjectP@Lookup[containerY,Container]]
				]/@sublistOfMetaContainers
			]
		]/@groupedMetaContainers,

		(* We're not InSitu so we can just return Nulls to save time *)
		ConstantArray[{Null},Length[groupedSonicDistanceContainers]]
	];

	(* now gather the container of the container's container's container...because we we're not *)
	groupedMetaMetaMetaContainers = If[inSitu,
		Function[
			{sublistOfMetaMetaContainers},
			DeleteDuplicates[
				Function[
					{containerY},
					FirstCase[metaMetaMetaContainerPackets,ObjectP@Lookup[containerY,Container]]
				]/@sublistOfMetaMetaContainers
			]
		]/@groupedMetaMetaContainers,

		(* We're not InSitu so we can just return Nulls to save time *)
		ConstantArray[{Null},Length[groupedSonicDistanceContainers]]
	];

(*	*)(* find the first position in the index-matched form factor list of each of the unique form factors *)(*
	uniqueFormFactorPositions = FirstPosition[modelFormFactorIdentifiers,#,{1},Heads->False]&/@uniqueModelFormFactors;*)

	(* use the first form factor positions to pick out container models, heights calibration packets that are index-matched to the container groups *)
	containerGroupRepresentativeModels = Map[
		Function[
			{nextBatchGrouping},
			FirstCase[
				containerModelPackets,
				KeyValuePattern[
					Object->Download[Lookup[First[nextBatchGrouping],Model,{}],Object]
				]
			]
		],
		groupedSonicDistanceContainers
	];

	containerGroupHeights = Download[containerGroupRepresentativeModels,Object]/.sonicDistanceHeightRules;

	(* generate the program packets for each container group *)
	sonicDistanceAssociations = Flatten@MapThread[
		Function[
			{containersIn,samplesIn,containerModel,containerHeight,metaContainersX,metaMetaContainersX,metaMetaMetaContainersX},
			Module[{containerModelObj,partitionedContainersIn,partitionedSamplesIn,sensorArmHeight,
				roundedSensorArmHeight,plateLayoutFileName,tubeRack,resolvedTubeRack,platePlatform,containerCalibrationPackets,
				validCalibrations,uniqueLiquidLevelDetectorModels},

				(* Convert packets back into objects *)
				containerModelObj = Download[containerModel,Object];

				(* 2mL tubes and Waters HPLC vials have a capacity limit per program (48); partition the container list accordingly *)
				(* TODO: determine the partition size by number of positions in the racks *)
				partitionedContainersIn = Which[
					MatchQ[containerModelObj,tube2mLP|hplcVialP],dupeFreePartition[containersIn,48],
					MatchQ[containerModelObj,Model[Container, Vessel, "id:4pO6dM5WvJKM"]],dupeFreePartition[containersIn,96],
					(* For plates, since they receive a DataFileName for each individual plate, we must break them into different batches *)
					MatchQ[containerModelObj,ObjectP[Model[Container,Plate]]],List/@containersIn,
					True,{containersIn}
				];

				(* Partition our samples into *)
				partitionedSamplesIn = Map[
					Flatten@Download[Lookup[#, Contents][[All, All, 2]], Object]&,
					partitionedContainersIn
				];

				(* determine the sensor arm height required (only applicable to vessels) *)
				sensorArmHeight = Lookup[sensorArmHeightLookup,Lookup[containerModel,Object]];

				(* round the sensor arm height into a readable quantity for the operator *)
				roundedSensorArmHeight = If[DistanceQ[sensorArmHeight],
					Round[Convert[sensorArmHeight,Centimeter],0.1]
				];

				(* determine if a plate layout file name needs to be set *)
				plateLayoutFileName = Lookup[layoutFileNameLookup,Lookup[containerModel,Object]];

				(* determine if a tube rack needs to be picked *)
				tubeRack = If[MatchQ[containerModel,ObjectP[Model[Container,Vessel]]],
					Lookup[sonicRackModelLookup,Lookup[containerModel,Object]],
					Null
				];

				(* For sticky racks, if the containers are all in the appropriate rack already, just make the resource for that rack *)
				resolvedTubeRack = If[
					And[
						(* If we determined we need a rack *)
						!NullQ[tubeRack],

						(* If we found a container *)
						!MemberQ[metaContainersX,Null],

						(* If everything is in one rack *)
						Length[DeleteDuplicates[Download[metaContainersX,Object]]]==1,

						(* AND the rack they're in is one of our VolumeCheck-able small tube racks*)
						MatchQ[
							Download[Lookup[First[metaContainersX],Model,Null],Object],
							Download[tubeRack,Object]
						]
					],

					(* We've determined we want to keep the tubes in the rack, so make a specific resource for THAT rack in particular *)
					Download[First[metaContainersX],Object],

					(* Otherwise we don't want a sticky rack, and so we'll just resource pick w/e we resolved earlier *)
					Download[tubeRack,Object]
				];

				(* determine if a plate platform is required *)
				platePlatform = If[MatchQ[containerModel,ObjectP[Model[Container,Plate]]],
					Lookup[sonicRackModelLookup,Lookup[containerModel,Object]],
					Null
				];

				(* Take the calibration objects from the models involved and convert them to packets *)
				containerCalibrationPackets = FirstCase[Flatten[volCalibrationPackets],KeyValuePattern[Object->#]]&/@Download[Lookup[containerModel,VolumeCalibrations,{}],Object];

				(* pull out the valid calibrations from the container model calibration list *)
				validCalibrations = Select[
					containerCalibrationPackets,
					And[
						!NullQ[Lookup[#,LiquidLevelDetectorModel]],
						!TrueQ[#[Anomalous]],
						!TrueQ[#[Deprecated]],
						!TrueQ[#[DeveloperObject]],
						(* If we are in a calibrate volume maintenance, we need a calibration from the target (it can be a placeholder or not) *)
						If[
							maintenanceQ,
							MatchQ[Lookup[#,LiquidLevelDetector],ObjectP[parentTarget]],
							(* If we are not in a calibrate volume maintenance, then we cannot use a placeholder calibration *)
							!StringContainsQ[#[Name]/.Null->"","Placeholder calibration for "~~__~~uuid_/;MatchQ[uuid, UUIDP]]
						]
					]&
				];

				(* get the liquid level detector models that have valid calibrations for this container model *)
				uniqueLiquidLevelDetectorModels = If[!inSitu,

					(* get the list of LLD devices *)
					Module[{validCalibrationLiquidLevelDetectorModels},
						validCalibrationLiquidLevelDetectorModels = Download[Lookup[validCalibrations,LiquidLevelDetectorModel],Object];
						(* If there is only one calibrationPacket and it is for VC 50/100/384, we expect any instrument of VC 50/100/384 will work *)
						If[Length[validCalibrationLiquidLevelDetectorModels] == 1 &&
								MatchQ[
										First[validCalibrationLiquidLevelDetectorModels],
										Alternatives[
											Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"], (*Model[Instrument, LiquidLevelDetector, "VolumeCheck 384"]*)
											Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"], (*Model[Instrument, LiquidLevelDetector, "VolumeCheck 100"]*)
											Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]] (*Model[Instrument, LiquidLevelDetector, "VolumeCheck 50"]*)
									],
							{Model[Instrument, LiquidLevelDetector, "id:8qZ1VW0VaMVD"], (*Model[Instrument, LiquidLevelDetector, "VolumeCheck 384"]*)
								Model[Instrument, LiquidLevelDetector, "id:zGj91aR3d5b6"], (*Model[Instrument, LiquidLevelDetector, "VolumeCheck 100"]*)
								Model[Instrument, LiquidLevelDetector, "id:9RdZXvKBee8x"]}, (*Model[Instrument, LiquidLevelDetector, "VolumeCheck 50"]*)
							(*Otherwise, we can only use the LLD whose calibration is recorded*)
							DeleteDuplicates[Download[Lookup[validCalibrations,LiquidLevelDetectorModel],Object]]
						]
					],

					(* Otherwise we're in the InSitu case so pick the first instrument we see *)
					(* We can pick the first because the Options resolver would already have thrown an error if InSitu wasn't valid *)
					{Download[FirstCase[Join[metaContainersX,metaMetaContainersX,metaMetaMetaContainersX],ObjectP[Object[Instrument]]],Object]}
				];

				(* create multiple associations for each container/sample group;
				 	TubeRack and LiquidLevelDetector are set incorrectly for now; these MUST be replaced with resources *)
				MapThread[
					Function[{containersInGroup,samplesInGroup},
						<|
							ContainersIn -> Link[containersInGroup],
							SensorArmHeight -> roundedSensorArmHeight,
							PlateLayoutFileName -> plateLayoutFileName,
							TubeRack -> resolvedTubeRack,
							PlatePlatform -> platePlatform,
							LiquidLevelDetector -> uniqueLiquidLevelDetectorModels
						|>
					],
					{partitionedContainersIn,partitionedSamplesIn}
				]
			]
		],
		{
			groupedSonicDistanceContainers,
			groupedSonicDistanceContents,
			containerGroupRepresentativeModels,
			containerGroupHeights,
			groupedMetaContainers,
			groupedMetaMetaContainers,
			groupedMetaMetaMetaContainers
		}
	];

	(* --- Section 4: SonicDistance Program Packet Resource Creation and Substitution --- *)

	(* --- TubeRack ---*)

	(* Treat multi-position racks as "sticky racks" (this is to avoid the hard-coded list of sticky racks that we used to have *)
	tubeRackPositionTuples=Map[{Lookup[#,Object],Length[Lookup[#,Positions]]}&,DeleteDuplicates[DeleteCases[Flatten[rackModelPacks],Null]]];
	stickyRackModels=Cases[tubeRackPositionTuples,{x_,GreaterP[1]}:>x];

	(* pull out the unique, non-Null, non-sticky TubeRack models from the programs *)
	(* We won't generate Stick Rack resources here because each instance of those sticky rack models must get their own unique resource *)
	uniqueTubeRacks = DeleteCases[DeleteDuplicates[Lookup[sonicDistanceAssociations,TubeRack,{}]],Alternatives@@Flatten[{Null,stickyRackModels}]];

	(* create a single resource for each unique tube rack model *)
	tubeRackResources = Resource[Sample->#,Name->ToString[Unique[]],Rent->True]&/@uniqueTubeRacks;

	(* create a lookup between the unique tube rack models and their associated Resource blobs *)
	tubeRackResourceLookup = AssociationThread[uniqueTubeRacks,tubeRackResources];

	(* --- PlatePlatform --- *)

	(* pull out the unique, non-Null PlatePlatform models from the programs *)
	uniquePlatePlatforms = DeleteCases[DeleteDuplicates[Lookup[sonicDistanceAssociations,PlatePlatform,{}]],Null];

	(* create a single resource for each unique plate platform model *)
	platePlatformResources = Resource[Sample->#,Name->ToString[Unique[]],Rent->True]&/@uniquePlatePlatforms;

	(* create a lookup between the unique tube rack models and their associated Resource blobs *)
	platePlatformResourceLookup = AssociationThread[uniquePlatePlatforms,platePlatformResources];

	(* --- LiquidLevelDetector --- *)

	(* pull out the LiquidLevelDetector model lists from the programs *)
	liquidLevelDetectorSets = Lookup[sonicDistanceAssociations,LiquidLevelDetector,{}];

	(* define a recursive internal helper function that will allow us to prune the LLD sets for Resource creation:
	  	- Combine LLD sets that have at least 1 Model in common; if there are multiple pair-wise intersections, we want the LONGEST
		e.g. we have the LLD Model sets {{ModelA,ModelB,ModelC},{ModelA},{ModelD,ModelE},{ModelB,ModelC}}
		 	- We want the unique combined sets to be {{ModelB,ModelC},{ModelA},{ModelD,ModelE}}
			- This collapsing will maximize choices for any given picking, while reducing the total number of distinct LLDs required *)
	collapseLiquidLevelDetectorSetsFunction[myLiquidLevelDetectorSets:{{ObjectP[{Object[Instrument,LiquidLevelDetector],Model[Instrument,LiquidLevelDetector]}]..}...}] := Module[
		{pairSubsets,intersectionsByPair,longestIntersection,collapsedLiquidLevelDetectorSets},

		(* if the set list is of length 0 or 1, just return it *)
		If[Length[myLiquidLevelDetectorSets]<=1,
			Return[myLiquidLevelDetectorSets]
		];

		(* get all of the pairs of LLD sets *)
		pairSubsets = Subsets[myLiquidLevelDetectorSets,{2}];

		(* find the intersection of each pair of LLD sets *)
		intersectionsByPair = Intersection@@#&/@pairSubsets;

		(* find the longest intersection (if there is a tie, doesn't matter which we pick) *)
		longestIntersection = Last[SortBy[intersectionsByPair,Length]];

		(* if the longest intersection is nothing, we have collapsed the sets as much as possible; exit recursion with the current sets *)
		If[Length[longestIntersection]==0,
			myLiquidLevelDetectorSets,

			(* Otherwise, continue recursion *)
			(
			(* remove the sets from the input list that contain all the elements of the longest intersection *)
				collapsedLiquidLevelDetectorSets = Map[
					If[ContainsAll[#,longestIntersection],
						Nothing,
						#
					]&,
					myLiquidLevelDetectorSets
				];

				(* append one instance of the longest intersection back onto the collapsed list and call this function on the new list of LLD sets *)
				collapseLiquidLevelDetectorSetsFunction[Append[collapsedLiquidLevelDetectorSets,longestIntersection]]
			)
		]
	];

	(* use the function defined in the previous block to determined the LLD model sets for which we want to create individual resources *)
	(* But if we are in a volume calibration maintenance or a liquid level detector qualification, we must use the target *)
	liquidLevelDetectorResourceSets = If[Or[maintenanceQ,qualificationQ],
		{parentTarget},
		collapseLiquidLevelDetectorSetsFunction[liquidLevelDetectorSets]
	];

	(* Create a single resource for each unique liquid level detector set. If it's a list of models leave it be
		If it's a single instrument remove it from the list. *)
	liquidLevelDetectorResources = Resource[
		Instrument->If[
			MatchQ[#,{ObjectP[Object[Instrument]]}],
			First[#],
			#
		],
		Name->ToString[Unique[]],
		Time->5.5*Minute
	]&/@liquidLevelDetectorResourceSets;

	(* create IDs for the future protocol object now *)
	protocolID = CreateID[Object[Protocol,MeasureVolume]];

	(* map back through the sonic distance associations, replacing the raw TubeRack and LiquidLevelDetector models with resources,
	 	and adding the Object key *)
	sonicDistancePacketsWithResources = Map[
		Function[{sonicDistanceAssoc},
			Module[{tubeRackObject,platePlatformModel,assocContainersIn,tubeRackResource,
				platePlatformResource,tubeRackPlacements,dataFileNames,liquidLevelDetectorResource},

				(* pull out the tube rack model, plate platform and containers in from the program packet *)
				tubeRackObject = Lookup[sonicDistanceAssoc,TubeRack];
				platePlatformModel = Lookup[sonicDistanceAssoc,PlatePlatform];
				assocContainersIn = Lookup[sonicDistanceAssoc,ContainersIn];

				(* Generate a resource for the tube rack if we have one. Sticky racks get their own unique resource,
				 non-sticky racks get one of the shared resources we generated above *)
				tubeRackResource = If[!NullQ[tubeRackObject] && !MatchQ[tubeRackObject,ObjectP[Object[Container,Rack]]] && MatchQ[Lookup[sonicRackPacketLookup[tubeRackObject],Footprint,Null],Plate],

					(* If it's a sticky rack, generate a brand new resource *)
					Resource[Sample->tubeRackObject,Name->ToString[Unique[]],Rent->True],

					(* Otherwise we can use one of the shared resources we generated above if we need one, or default to Null *)
					Lookup[tubeRackResourceLookup,tubeRackObject,Null]
				];

				(* Generate the plate platform resources if we need one or default to Null*)
				platePlatformResource = Lookup[platePlatformResourceLookup,platePlatformModel,Null];

				(* if this is the 2mL tube rack or HPLC vial rack, we want to create placements fields with the resource now;
				 	this way, we can resource pick the tube racks as they're needed, and the placements will fill themselves out *)
				tubeRackPlacements = Which[

					(* We have a sticky rack so the positions should be the tubes' current positions *)
					MatchQ[tubeRackObject,ObjectP[Object[Container,Rack]]],

						(* Build positional placements that mirror the current rack setup *)
						Module[
							{positions},

							(* Lookup the positions of the tubes we're dealing with *)
							positions = Lookup[
								FirstCase[containerPackets,KeyValuePattern[Object->Download[#,Object]]],
								Position
							]&/@assocContainersIn;

							MapThread[
								{Link[#1],Link[tubeRackResource],#2}&,
								{assocContainersIn,positions}
							]
						],

					(* We don't have a sticky rack to use so we must pick a new tube rack *)
					MatchQ[
						Lookup[
							sonicRackPacketLookup[tubeRackObject],
							Footprint,
							Null
						],
						Plate
					],

						(* Create the appropriate placements *)
						Module[{tubeRackPositions,tubeRackPositionsToUse},
							(* set the known positions in the rack *)
							tubeRackPositions = Lookup[
								Lookup[
									sonicRackPacketLookup[tubeRackObject],
									Positions
								],
								Name
							];

							(* take only as many positions as we'll need (Experiment function guarantees a single program has 48 or fewer tubes) *)
							tubeRackPositionsToUse=Take[tubeRackPositions,Length[assocContainersIn]];

							(* create placements for the tubes into the rack *)
							MapThread[
								Function[
									{tube,rackPosition},
									{Link[tube],Link[tubeRackResource],rackPosition}
								],
								{assocContainersIn,tubeRackPositionsToUse}
							]
						],

					True,
						(* Table the tube rack placements so they're still indexed to our BatchedContainers *)
						Table[{Null,Null,Null},Length[assocContainersIn]]
				];

				(* we need to make data file names for BML programs; we can identify these if they have PlateLayoutFileName populated *)
				dataFileNames = If[StringQ[Lookup[sonicDistanceAssoc,PlateLayoutFileName]],
					Module[{uuid},

						(* create a UUID to use as the file name shard *)
						uuid = CreateUUID[];

						(* TODO: use footprint here instead *)
						Which[
							MatchQ[tubeRackObject,ObjectP[Object[Container,Rack]]],
								uuid<>"_rack_"<>StringReplace[Download[tubeRackObject,ID],":"->"_"],
							MatchQ[tubeRackObject,Model[Container,Rack,"id:BYDOjv1VAAml"]],
								uuid<>"_tuberack",
							MatchQ[tubeRackObject,Model[Container,Rack,"id:XnlV5jKRn10M"]],
								uuid<>"_hplcrack",
							MatchQ[tubeRackObject,Model[Container,Rack,"id:WNa4ZjKKz6MZ"]],
								uuid<>"_vialrack",
							True,
								uuid<>"_plate"
						]
					],
					Null
				];

				(* determine which liquid level detector resource to use; the correct choice is the one with the longest intersection between the resource's models and this program's models*)
				(* If we are in a maintenance calibrate volume or a liquid level detector qualification, we just have a resource for the target *)
				liquidLevelDetectorResource = If[
					Or[maintenanceQ,qualificationQ],
					FirstOrDefault[liquidLevelDetectorResources],
					Last[
						SortBy[
							Select[
								liquidLevelDetectorResources,
								ContainsAll[
									Lookup[sonicDistanceAssoc,LiquidLevelDetector],
									ToList[#[Instrument]] (* This is ToList'd because models will be in lists but objects must be singular in the resource blob *)
								]
									&],
							Length
						]
					]
				];

				(* add the resources (and object ID) to the program packet *)
				Append[sonicDistanceAssoc,
					{
						TubeRack->Link[tubeRackResource],
						TubeRackPlacements->tubeRackPlacements,
						PlatePlatform->Link[platePlatformResource],
						LiquidLevelDetector->Link[liquidLevelDetectorResource],
						DataFileNames->dataFileNames
					}
				]
			]
		],
		sonicDistanceAssociations
	];

	(* We have full-formed packets (excluding BatchNumber); gather them such that ones using the same resources/parameters
	 	are next to each other GatherBy with a list as second element will create a nested list after applying each gathering
	 	function in the order they're provided to each of the sublists; once these are grouped, flattening back out gives us
	 	the ordered packet list *)
	orderedSonicAssociations = Flatten@GatherBy[
		sonicDistancePacketsWithResources,
		{
			#[LiquidLevelDetector]&,
			#[TubeRack]&,
			#[SensorArmHeight]&,
			#[PlateLayoutFileName]&,
			#[PlatePlatform]&
		}
	];

	(* Finalize the associations created by appending a batch number to each *)
	sonicAssociations = MapThread[
		Function[{assoc,batchNum},Append[assoc,BatchNumber->batchNum]],
		{orderedSonicAssociations,Range[Length[orderedSonicAssociations]]}
	];

	(* Finally, extract the information for each index of our batching fields and piece them together into the final field formats *)
	{
		batchLengthsContainers,
		batchLengthsSamples,
		batchedContainers,
		batchedSamps,
		batchedMeasurementDevices,
		tubeRackPlacements,
		liquidLevelDetectors
	} = If[!MatchQ[sonicAssociations,{}],

		(* If we made any Sonic Associations, generate the batched fields for these objects *)
		Module[
			{containerBatchLengths,sampleBatchLengths,containerBatches,batchedContainerPacks,sampleBatches,measurementDeviceInfos,
				contentsLookup,rackPlacements,instrumentsByBatch},

			(* The length of each batch *)
			containerBatchLengths = Length/@Lookup[sonicAssociations,ContainersIn];

			(* BatchedContainers: {{ContainerIn,DataFileName}..} *)
			containerBatches = Flatten[Lookup[sonicAssociations,ContainersIn]];

			(* Build a Container->Contents map  *)
			contentsLookup = MapThread[Rule,{Lookup[containerPackets,Object],Download[Lookup[containerPackets,Contents][[All,All,2]],Object]}];

			(* Pull the contents of the containers from each batch *)
			sampleBatches = Map[Flatten,Download[Lookup[sonicAssociations,ContainersIn],Object]/.contentsLookup];

			(* Determine the length of each batch of samples *)
			sampleBatchLengths = Length/@sampleBatches;

			(* Organize the required rack information *)
			batchedRacks = MapThread[
				Function[{tubeRack,platePlatform},
					If[MatchQ[{tubeRack,platePlatform},{Null,Null}],
						Null,
						FirstCase[{tubeRack,platePlatform},Except[Null]]
					]
				],
				{
					Flatten[Lookup[sonicAssociations,TubeRack]],
					Flatten[Lookup[sonicAssociations,PlatePlatform]]
				}
			];

			measurementDeviceInfos = Map[
				<|
					LiquidLevelDetector->Lookup[#1,LiquidLevelDetector],
					SensorArmHeight->Lookup[#1,SensorArmHeight],
					TubeRack->Lookup[#1,TubeRack],
					PlatePlatform->Lookup[#1,PlatePlatform],
					PlateLayoutFileName->Lookup[#1,PlateLayoutFileName],
					DataFileName->Lookup[#1,DataFileNames],
					BatchNumber->Lookup[#1,BatchNumber]
				|>&,
				sonicAssociations
			];

			(* TubeRackPlacements: {{container,rack,placementString}..} *)
			rackPlacements = Flatten[Lookup[sonicAssociations,TubeRackPlacements],1];

			(* pull out the instruments we plan to use LiquidLevelDetectors *)
			instrumentsByBatch = Flatten[Lookup[sonicAssociations,LiquidLevelDetector]];

			{
				containerBatchLengths,
				sampleBatchLengths,
				containerBatches,
				Flatten[sampleBatches],
				measurementDeviceInfos,
				rackPlacements,
				instrumentsByBatch
			}
		],

		(* Otherwise we're not measuring anything ultrasonically. Return empty lists *)
		{{},{},{},{},{},{},{}}
	];

	(* Delete duplicates on the instrument resources we plan to use *)
	duplicateFreeDetectors = DeleteDuplicates[liquidLevelDetectors];

	(* --- Section 6: MeasureVolume Protocol Creation --- *)

	(* pull the containers and samples in from the finished sonic distance program packets *)
	sonicDistanceContainersIn = Flatten[Lookup[sonicAssociations,ContainersIn,{}]];

	(* Grab a list of the index of the container in WorkingSamples. This will be used by the compiler to fill out BatchedContainers *)
	sonicDistanceContainerIndexes = Flatten[FirstPosition[Download[workingContainers,Object],#]&/@Download[batchedContainers,Object]];

	(* create containers in and samples in lists; use original input lists to start,
	 	removing any indices that we cut out (this only happens if ParentProtocol is not Null) *)
	dupeFreeResources = Resource[Sample->#,Name->ToString[Unique[]]]&/@DeleteDuplicates[lookupObjID[mySamples]];
	resourcesToSampleMap = (#[Sample] -> #)&/@dupeFreeResources;
	samplesInResources = lookupObjID[myExpandedSamples]/.resourcesToSampleMap;
	containersIn = DeleteDuplicates[Download[Lookup[mySamples,Container],Object]];
	batchedSamples = batchedSamps/.resourcesToSampleMap;

	(* determine which samples (or their containers) have to have their density measures (including sample auto measured as a result of Gravimetric being requested *)
	measureDensity = Lookup[myExpandedOptions,MeasureDensity];

	(* Gather which samples must have the density measured *)
	samplesToDensityMeasure = Flatten[Download[PickList[myExpandedSamples,measureDensity],Object]];

	(* expand and filter the measurment volume and recoup sample option*)
	expandedAndFilteredMeasurementVolume = PickList[Lookup[myExpandedOptions,MeasurementVolume],measureDensity,True];
	expandedAndFilteredRecoupSample = PickList[Lookup[myExpandedOptions,RecoupSample],measureDensity,True];
	(*numberOfDensityReplicatesOption = PickList[Lookup[myExpandedOptions,NumberOfMeasureDensityReplicates],measureDensity,True];*)

	(* format the optoins for storage in the named field*)
	measureDensityParameters = If[AnyTrue[measureDensity,TrueQ],
		MapThread[
			Association[
				FixedVolume->#1,
				NumberOfReplicates->5,
				RecoupSample->#2
			]&,
			{
				expandedAndFilteredMeasurementVolume,
				(*numberOfDensityReplicatesOption,*)
				expandedAndFilteredRecoupSample
			}
		],
		Null
	];

	(* filter samples (their containers) in using the MD option*)
	samplesToDensityMeasure = PickList[Download[myExpandedSamples,Object],measureDensity,True];

	(* In the resolve were memoized a function to store the densities found for each of our samples and their compositions. *)
	(* Set a local value that stashes the memoized values until we upload them in our protocol object *)
	knownDensities = MapThread[
		Function[{sampleDensity,sampleModelPacket,compDensity, estimateDensity},
			Module[
				{modelDensity},
				modelDensity=If[NullQ[sampleModelPacket],
					Null,
					Lookup[sampleModelPacket,Density,Null]
				];
				FirstCase[{sampleDensity,compDensity,modelDensity, estimateDensity},DensityP,Null]
			]
		],
		{Lookup[samplePackets,Density],sampleModelPackets,mvCompositionDensities[], solventEstimatedDensities[]}
	];

	(* construct the final protocol packet *)
	(* NOTE: We will NOT upload BatchedContainers despite the fact we'll upload BatchingLengths
			This is because we will use compileMeasureVolume to upload contents of WorkingSamples post
			sample prep into BatchingContainers using the field BatchedContainerIndexes
	*)

	protocolPacket = <|
		Object->protocolID,
		Type->Object[Protocol,MeasureVolume],
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->resolvedOptionsNoHidden,
		ParentProtocol->Link[parentProtocol,Subprotocols],
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@containersIn,
		Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),
		Replace[SamplesInStorage]->Lookup[myResolvedOptions,SamplesInStorageCondition],
		Replace[Instruments]->duplicateFreeDetectors,
		Replace[GravimetricallyMeasured]->(Resource[Sample->#[Object]/.reverseContainerLookup]&/@weightMethodContainers),
		Replace[UltrasonicallyMeasured]->(Resource[Sample->#[Object]/.reverseContainerLookup]&/@sonicDistanceContainersIn),
		Replace[BatchLengths]->batchLengthsContainers,
		Replace[BatchedMeasurementDevices]->batchedMeasurementDevices,
		Replace[BatchedContainerIndexes]->sonicDistanceContainerIndexes,
		Replace[BatchedVolumeCalibrations]->ConstantArray[Null,Length[sonicDistanceContainerIndexes]],
		Replace[DensityMeasurementSamples]->(Resource[Sample->#]&/@samplesToDensityMeasure),
		Replace[Densities] -> knownDensities,
		If[NullQ[measureDensityParameters],
			Nothing,
			Replace[DensityMeasurementParameters]->measureDensityParameters
		],
		If[MatchQ[tubeRackPlacements,{{}..}],
			Nothing,
			Replace[TubeRackPlacements]->tubeRackPlacements
		],
		ErrorTolerance->Lookup[myResolvedOptions,ErrorTolerance],
		InSitu->Lookup[myResolvedOptions,InSitu],
		Replace[Checkpoints]->{
			{"Picking Resources",If[NullQ[parentProtocol],5 Minute,1 Minute],"Samples required to execute this protocol are gathered from storage.",Link[Resource[Operator -> $BaselineOperator, Time -> If[NullQ[parentProtocol],5 Minute,1 Minute]]]},
			{"Measuring Volume",Length[containersIn]*7 Minute,"Volume measurements of the provided samples are made.",Link[Resource[Operator -> $BaselineOperator, Time -> Length[containersIn]*7 Minute]]},
			{"Returning Materials",5 Minute,"Samples are returned to storage.",Link[Resource[Operator -> $BaselineOperator, Time -> 5 Minute]]}
		}
	|>;

	(* Get the prep options to populate resources and field values *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache->inheritedCache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[protocolPacket,sharedFieldPacket];

	(* Gather the resources blobs we've created *)
	allResourceBlobs = DeleteDuplicates[Cases[Values[finalizedPacket], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache, Simulation -> updatedSimulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache, Simulation -> updatedSimulation],Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		finalizedPacket,
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];


(* ::Subsubsection:: *)
(* simulateExperimentMeasureVolume *)
DefineOptions[simulateExperimentMeasureVolume,
	Options :> {
		CacheOption,
		SimulationOption
	}
];

simulateExperimentMeasureVolume[
	myProtocolPacket: PacketP[Object[Protocol, MeasureVolume]],
	mySamples: {ObjectP[Object[Sample]]..},
	myResolvedOptions: {_Rule...},
	myResolutionOptions: OptionsPattern[simulateExperimentMeasureVolume]
] := Module[
	{
		cache, simulation, protocolObject, currentSimulation, downloadInfo, samplePackets,
		densityMeasurementSamples, densityMeasurementParameters, transferSamplesAndVolumes, simulationWithLabels
	},

	(* Lookup the cache and simulation *)
	cache = Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation = Lookup[ToList[myResolutionOptions],Simulation,Simulation[]];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed *)
	protocolObject = Lookup[myProtocolPacket, Object];

	(* Simulate the fulfillment of all resources by the procedure *)
	currentSimulation = SimulateResources[
		myProtocolPacket,
		Cache -> cache,
		Simulation -> simulation
	];

	(* Make sample packets so we know our containers and density measurements. *)
	downloadInfo=Download[
		{
			mySamples,
			{protocolObject},
			{protocolObject}
		},
		{
			{Packet[Container]},
			{DensityMeasurementSamples[Object]},
			{DensityMeasurementParameters}
		},
		Cache->cache,
		Simulation->currentSimulation
	];

	(* Parse the download *)
	samplePackets = Flatten[First[downloadInfo]];
	densityMeasurementSamples = Flatten[downloadInfo[[2]]];
	densityMeasurementParameters = Flatten[Last[downloadInfo]];

	(* Create transfer tuples for any density measurements where we are not recouping our sample *)
	transferSamplesAndVolumes = MapThread[
		Function[{sample,parameters},
			If[!Lookup[parameters,RecoupSample],
				{
					sample,
					Lookup[parameters,FixedVolume] * Lookup[parameters,NumberOfReplicates]
				},
				Nothing
			]
		],
		{
			densityMeasurementSamples,
			densityMeasurementParameters
		}
	];

	(* Do any Transfers if we have any. If sample is not recouped from MeasureDensity, it goes into waste. *)
	(* Simulate that here by putting it in new waste container *)
	(* If we don't have any samples we are losing, skip this and move on *)
	If[!MatchQ[transferSamplesAndVolumes,{}],
		Module[{wasteContainerPackets,wasteContainerSampleContainerObject,wasteSamplePackets,wasteSampleObject,ustPackets},

			(* Create the simulated waste container *)
			wasteContainerPackets = UploadSample[
				Model[Container, Vessel, "id:3em6Zv9NjjkY"],
				{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]} (* Object[Container, Room, "Empty Room for Simulated Objects"] *),
				FastTrack -> True,
				SimulationMode -> True,
				Upload -> False
			];
			wasteContainerSampleContainerObject = Lookup[First[wasteContainerPackets], Object];

			(* Update the simulation with the container packets. *)
			currentSimulation = UpdateSimulation[currentSimulation,Simulation[wasteContainerPackets]];

			(* Put some water in our simulated waste container. *)
			wasteSamplePackets = UploadSample[
				Model[Sample, "id:8qZ1VWNmdLBD"],
				{"A1", wasteContainerSampleContainerObject},
				State->Liquid,
				InitialAmount->$MaxTransferVolume,
				Simulation -> currentSimulation,
				SimulationMode -> True,
				FastTrack -> True,
				Upload -> False
			];
			wasteSampleObject = Lookup[First[wasteSamplePackets], Object];

			(* Update the simulation with the sample packets. *)
			currentSimulation = UpdateSimulation[currentSimulation, Simulation[wasteSamplePackets]];


			(* Do the sample transfer *)
			ustPackets = UploadSampleTransfer[
				transferSamplesAndVolumes[[All,1]],
				ConstantArray[wasteSampleObject,Length[transferSamplesAndVolumes]],
				transferSamplesAndVolumes[[All,2]],
				Upload->False,
				FastTrack->True,
				Simulation->currentSimulation
			];

			(* Add the packets to the simulation *)
			(* Update the simulation with the sample packets. *)
			currentSimulation = UpdateSimulation[currentSimulation, Simulation[ustPackets]];
		]
	];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Lookup[samplePackets, Container]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
				{_String, _}
			]
		]
	];

	(* Merge our packets with our labels. *)
	{
		protocolObject,
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}
];

(* ::Subsubsection:: *)
(*VolumeMeasurementDevices*)


DefineOptions[
	VolumeMeasurementDevices,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "Indicates the preferred method by which the samples' volumes will be calculated.",
				ResolutionDescription -> "Method will attempt to resolve to Gravimetric measurement first. If that is not immediately possible, it will then attempt to resolve to Ultrasonic measurement. If neither option works immediately, it will see if MeasureDensity or sample transfer can resolve which option to use.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic,All,VolumeMeasurementMethodP]
				]
			}
		],
		{
			OptionName -> Types,
			Default -> All,
			Description -> "Determines which Types of compatible Objects are returned by the function.",
			ResolutionDescription -> "Will resolve to return all instruments and their compatible racks if no types are specified.",
			AllowNull -> False,
			Widget -> Alternatives[
				Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All,Model[Instrument,LiquidLevelDetector],Model[Instrument,Balance],Model[Container,Rack]]
					]
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[All,Model[Instrument,LiquidLevelDetector],Model[Instrument,Balance],Model[Container,Rack]]
				]
			]
		},
		InSituOption,
		CacheOption,
		HelperOutputOption
	}
];

VolumeMeasurementDevices[containersIn:ObjectP[{Object[Container,Plate],Object[Container,Vessel],Model[Container,Plate],Model[Container,Vessel]}],ops:OptionsPattern[VolumeMeasurementDevices]]:=Module[{},Null];

VolumeMeasurementDevices[containersIn:ObjectP[{Object[Container,Plate],Object[Container,Vessel],Model[Container,Plate],Model[Container,Vessel]}],ops:OptionsPattern[VolumeMeasurementDevices]]:=First[VolumeMeasurementDevices[ToList[containersIn],ops]];
VolumeMeasurementDevices[containersIn:{ObjectP[{Object[Container,Plate],Object[Container,Vessel],Model[Container,Plate],Model[Container,Vessel]}]..},ops:OptionsPattern[VolumeMeasurementDevices]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,containerToSampleResult,
		containerToSampleOutput,samplesIn,samplesPerContainer,sampleCache,samples,sampleOptions,measurementDevicesResult,
		containerToSampleTests,measurementDevicesTests,result,tests},

	listedOptions = ToList[ops];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Determine how many samples per container *)
	samplesIn = Download[containersIn,Contents[[All,2]][Object]];
	samplesPerContainer = Length/@samplesIn;

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
	(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests} = containerToSampleOptions[
			VolumeMeasurementDevices,
			containersIn,
			listedOptions,
			Output->{Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		If[NullQ[Lookup[listedOptions,ParentProtocol,Null]],
			Check[
				containerToSampleOutput = containerToSampleOptions[
					VolumeMeasurementDevices,
					containersIn,
					listedOptions,
					Output->Result
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			],

		(* However, if we are in a Subprotocol, silence the empty container errors *)
			containerToSampleOutput = Quiet[
				containerToSampleOptions[
					ExperimentMeasureVolume,
					containersIn,
					listedOptions,
					Output->Result
				],
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			]
		]
	];

	(* containerToSampleOptions failed - return $Failed *)
	If[MatchQ[containerToSampleResult,$Failed],
		outputSpecification/.{
			Result -> $Failed,
			Tests -> {containerToSampleTests},
			Options -> $Failed,
			Preview -> Null
		}
	];

	(* Split up our containerToSample result into the samples and sampleOptions. *)
	{samples,sampleOptions,sampleCache} = containerToSampleOutput;

	(* If we were given an empty container, return early. *)
	{measurementDevicesResult,measurementDevicesTests} = If[gatherTests,
		VolumeMeasurementDevices[samples,ReplaceRule[listedOptions,Output->{Result,Tests}]],
		{VolumeMeasurementDevices[samples,ReplaceRule[listedOptions,Output->Result]],{}}
	];

	(* Since we only want to return results for each container (not for every sample in those containers) we have to
		extract each container's sublists, combine them and then delete duplicates*)
	result = If[MatchQ[measurementDevicesResult,$Failed],
		$Failed,
		DeleteDuplicates[Flatten[#]]&/@TakeList[measurementDevicesResult,samplesPerContainer]
	];

	tests = {containerToSampleTests,measurementDevicesTests};

	outputSpecification/.{
		Result -> result,
		Tests -> tests
	}
];

VolumeMeasurementDevices[samplesIn:ObjectP[Object[Sample]],ops:OptionsPattern[VolumeMeasurementDevices]]:=First[VolumeMeasurementDevices[ToList[samplesIn],ops]];
VolumeMeasurementDevices[samplesIn:{ObjectP[Object[Sample]]..},ops:OptionsPattern[VolumeMeasurementDevices]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,safeOps,safeOpsTests,expandedSafeOps,inSitu,cacheBall,
		samplePackets,containerPackets,containerModels,volumeCalibrations,metaContainers,metaContainerParents,
		resolvedMethods,possibleInstruments,possibleRacks,possibleRackForEachContainer, cache,sampleIndexedOutput,result,tests,availableHolders,
		sampleInformation,metaMetaContainerParents
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[ops];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps,safeOpsTests}=If[gatherTests,
		SafeOptions[Experiment`Private`VolumeMeasurementDevices,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[Experiment`Private`VolumeMeasurementDevices,listedOptions,AutoCorrect->False],{}}
	];

	(* Expand index-matching options *)
	expandedSafeOps = Last@Quiet[
		ExpandIndexMatchedInputs[VolumeMeasurementDevices,{samplesIn},safeOps,2],
		Warning::UnableToExpandInputs
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point)*)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests
		}]
	];

	(* Stash the InSitu flag *)
	inSitu = Lookup[safeOps,InSitu];

	(* Stash cache *)
	cache = Lookup[safeOps,Cache];

	(* make a hardcoded list of container racks that we currently support to utilize for non-selfstanding containers during the weighing process *)
	(* TODO: If you add anything here, update measureWeightResourcePackets *)
	(* TODO: These can be defaults? *)
	(*TODO: if we can avoid this in the future that might be a good idea*)
	availableHolders = {Model[Container, Rack, "50mL Tube Stand"],Model[Container, Rack, "15mL Tube Stand"],Model[Container, Rack, "id:XnlV5jKvVOA3"]};

	(* *)
	cacheBall = FlattenCachePackets@Quiet[
		{sampleInformation} = Download[
			{
				samplesIn
			},
			{
				{
					(* Sample packet information *)
					Packet[
						(* Necessary for MeasureVol *)
						Model,Status,Volume,Density,Container,Position,State,UltrasonicIncompatible,LightSensitive,Sterile
					],

					(* Sample's Container packet information *)
					Packet[Container[{Model,Status,TareWeight,Contents,Container,Position}]],

					(* Container Model Packet *)
					Packet[Container[Model][{VolumeCalibrations,MinVolume,TareWeight}]],

					(* Volume Calibration Packets *)
					Packet[Container[Model][VolumeCalibrations][{LiquidLevelDetectorModel,LiquidLevelDetector,Anomalous,Deprecated,DeveloperObject}]],

					(* Meta Container - Used to determine if In Situ is possible *)
					Packet[Container[Container][{Model,Container,Position}]],

					(* Meta Container Parent - Used to determine if In Situ is possible *)
					Packet[Container[Container][Container][{Model,Container,Position}]],

					(* Meta Meta Container Parent - Used to determine if In Situ is possible *)
					Packet[Container[Container][Container][{Model,Container,Position}]]
				}
			},
			Cache -> cache
		],
		Download::FieldDoesntExist
	];

	(* Stash the values of each sublist of the samples related downloads *)
	{samplePackets,containerPackets,containerModels,volumeCalibrations,metaContainers,metaContainerParents,metaMetaContainerParents} = Transpose[sampleInformation];

	(* For each sample, determine which methods we should lookup instruments and racks for *)
	resolvedMethods = MapThread[
		Function[{method,sampIn,contIn,contMod,volCals,metaCont,metaMetaCont,metaMetaMetaCont},
			Which[
				(* Case 0 - A method was requested *)
				MatchQ[method,Alternatives[All,Gravimetric,Ultrasonic]],
					method,

				(* Case 1 - InSitu
						- The container is on an instrument or in an rack on an instrument *)
				And[
					TrueQ[inSitu],
					MemberQ[{metaCont,metaMetaCont,metaMetaMetaCont},ObjectP[{Object[Instrument,Balance],Object[Instrument,LiquidLevelDetector]}]]
				],
					(* We now need to resolve Method to whichever instrument the container is sitting on *)
					Which[
						MemberQ[{metaCont,metaMetaCont,metaMetaMetaCont},ObjectP[Object[Instrument,Balance]]],
							Gravimetric,
						MemberQ[{metaCont,metaMetaCont,metaMetaMetaCont},ObjectP[Object[Instrument,LiquidLevelDetector]]],
							Ultrasonic
					],

				(* Case 2 - We can do everything
						- Sample or Sample's model has a density
						- Sample isn't ultrasonic incompatible
						- Sample's tube has a TareWeight in the container or model container
						- Container it's in has at least one valid volume calibration *)
				And[
					MatchQ[Lookup[sampIn,Density],DensityP],
					!TrueQ[Lookup[sampIn,UltrasonicIncompatible]],
					Or[MatchQ[Lookup[contIn,TareWeight],MassP],MatchQ[Lookup[contMod,TareWeight],MassP]],
					Or@@(!MatchQ[
						#,
						Alternatives[
							KeyValuePattern[Anomalous->True],
							KeyValuePattern[Deprecated->True],
							KeyValuePattern[DeveloperObject->True]
						]
					]&/@volCals)
				],
					All,

				(* Case 3 - We can only do Ultrasonic
						- Neither Sample or Sample's model have a density OR Sample's tube doesn't have a TareWeight
						- Sample isn't ultrasonic incompatible
						- Container it's in has at least one valid volume calibration *)
				And[
					Or[
						!MatchQ[Lookup[sampIn,Density],DensityP],
						!Or[MatchQ[Lookup[contIn,TareWeight],MassP],MatchQ[Lookup[contMod,TareWeight],MassP]]
					],
					!TrueQ[Lookup[sampIn,UltrasonicIncompatible]],
					Or@@(!MatchQ[
						#,
						Alternatives[
							KeyValuePattern[Anomalous->True],
							KeyValuePattern[Deprecated->True],
							KeyValuePattern[DeveloperObject->True]
						]
					]&/@volCals)
				],
					Ultrasonic,

				(* Case 4 - We can only do Gravimetric
						- Either Sample or Sample's model has a density
						- Tube the sample is in has a tare weight
						- Either Sample is ultrasonic incompatible OR container it's in has no valid volume calibration *)
				And[
					MatchQ[Lookup[sampIn,Density],DensityP],
					Or[MatchQ[Lookup[contIn,TareWeight],MassP],MatchQ[Lookup[contMod,TareWeight],MassP]],
					Or[
						TrueQ[Lookup[sampIn,UltrasonicIncompatible]],
						Or@@(!MatchQ[
							#,
							Alternatives[
								KeyValuePattern[Anomalous->True],
								KeyValuePattern[Deprecated->True],
								KeyValuePattern[DeveloperObject->True]
							]
						]&/@volCals)
					]
				],
					Gravimetric,

				(* Ambiguous case - none of the above cases seem to apply, return everything and exterior logic will decide *)
				True,
					All
			]
		],
		{
			Lookup[expandedSafeOps,Method],
			samplePackets,
			containerPackets,
			containerModels,
			volumeCalibrations,
			metaContainers,
			metaContainerParents,
			metaMetaContainerParents
		}
	];

	(* Get the list of all possible instruments per sample in *)
	possibleInstruments = MapThread[
		Function[{method,cont,contMod,metaCont,metaMetaCont,metaMetaMetaCont,volCals},
			Which[
				(* If we're InSitu, AND the container is on an instrument *)
				And[
					TrueQ[inSitu],
					MemberQ[{metaCont,metaMetaCont,metaMetaMetaCont},ObjectP[{Object[Instrument,Balance],Object[Instrument,LiquidLevelDetector]}]]
				],
					(* Then we need to get the instruments related to the resolved Method *)
					Which[
						MatchQ[method,All],
							Download[FirstCase[{metaCont,metaMetaCont,metaMetaMetaCont},ObjectP[{Object[Instrument,Balance],Object[Instrument,LiquidLevelDetector]}]],Object],
						MatchQ[method,Gravimetric],
							Download[FirstCase[{metaCont,metaMetaCont,metaMetaMetaCont},ObjectP[Object[Instrument,Balance]]],Object],
						MatchQ[method,Ultrasonic],
							Download[FirstCase[{metaCont,metaMetaCont,metaMetaMetaCont},ObjectP[Object[Instrument,LiquidLevelDetector]]],Object],
						True,
							Download[FirstCase[{metaCont,metaMetaCont,metaMetaMetaCont},ObjectP[Object[Instrument]]],Object]
					],

				(* If we're returning All method-compatible instruments and racks *)
				MatchQ[method,All],
					Join[
						Download[
							Lookup[
								Cases[volCals,KeyValuePattern[{Anomalous->Except[True],Deprecated->Except[True],DeveloperObject->Except[True]}]],
								LiquidLevelDetectorModel
							],
							Object
						],
						(* Since we're returning All, we will return all balances that are large enough to handle the container *)
						(* Smallest compatible balance first such that if someone just picks the first element, the best balance is chosen *)
						Switch[FirstCase[{Lookup[cont,TareWeight],Lookup[contMod,TareWeight]},MassP],
							Null,
								{},
							LessP[3 Gram],
								{Model[Instrument,Balance,"id:54n6evKx08XN"],Model[Instrument,Balance,"id:rea9jl5Vl1ae"],Model[Instrument,Balance,"id:o1k9jAGvbWMA"],Model[Instrument,Balance,"id:aXRlGn6V7Jov"]},
							(* preferred balance type -> Analytical|Micro AND (either cannot be trusted, then we don't care, OR sample can be trusted and weight < 120 Gram ) *)
							LessP[60 Gram],
								{Model[Instrument,Balance,"id:rea9jl5Vl1ae"],Model[Instrument,Balance,"id:o1k9jAGvbWMA"],Model[Instrument,Balance,"id:aXRlGn6V7Jov"]},
							(* preferred balance type -> Macro|Analytical|Micro AND (either cannot be trusted, then we don't care, OR sample can be trusted and weight < (0.8)6000 Gram ) *)
							LessP[3000 Gram],
								{Model[Instrument,Balance,"id:o1k9jAGvbWMA"],Model[Instrument,Balance,"id:aXRlGn6V7Jov"]},
							(* preferred balance type -> Macro|Analytical|Micro|Bulk AND (either cannot be trusted, then we don't care, OR sample can be trusted and weight < (0.8)25000 Gram ) *)
							GreaterEqual[3000 Gram],
								{Model[Instrument,Balance,"id:aXRlGn6V7Jov"]}
						]
					],

				(* If we're just returning Ultrasonic method-compatible instruments, don't resolve their racks for balances *)
				MatchQ[method,Ultrasonic],
					DeleteDuplicates@Download[
						Lookup[
							Cases[volCals,KeyValuePattern[{Anomalous->Except[True],Deprecated->Except[True],DeveloperObject->Except[True]}]],
							LiquidLevelDetectorModel
						],
						Object
					],

				(* If we're just returning Gravimetric method-compatible instruments, don't resolved racks for LLDs *)
				MatchQ[method,Gravimetric],
					Switch[FirstCase[{Lookup[cont,TareWeight],Lookup[contMod,TareWeight]},MassP],
						Null,
							{},
						LessP[3 Gram],
							{Model[Instrument,Balance,"id:54n6evKx08XN"]},
						(* preferred balance type -> Analytical|Micro AND ( either cannot be trusted, then we don't care, OR sample can be trusted and weight < 120 Gram ) *)
						LessP[60 Gram],
							{Model[Instrument,Balance,"id:rea9jl5Vl1ae"]},
						(* preferred balance type -> Macro|Analytical|Micro AND ( either cannot be trusted, then we don't care, OR sample can be trusted and weight < (0.8)6000 Gram ) *)
						LessP[3000 Gram],
							{Model[Instrument,Balance,"id:o1k9jAGvbWMA"]},
						(* preferred balance type -> Macro|Analytical|Micro|Bulk AND ( eeither cannot be trusted, then we don't care, OR sample can be trusted and weight < (0.8)25000 Gram ) *)
						GreaterEqual[3000 Gram],
							{Model[Instrument,Balance,"id:aXRlGn6V7Jov"]}
					]
			]
		],
		{resolvedMethods,containerPackets,containerModels,metaContainers,metaContainerParents,metaMetaContainerParents,volumeCalibrations}
	];

	(*to avoid spamming the rack selection function, just call it once up front*)
	(*TODO: there this function does not need the second argument, this will limit the racks to the ones we currently know work for weighing. This should be removed if we want to make more racks available*)
	possibleRackForEachContainer = findContainerStands[Download[containerModels, Object], availableHolders];

	(* find any required racks based on the method and container model *)
	possibleRacks = MapThread[
		Function[{method,contMod,metaCont,rack},
			Which[

				(* If we're InSitu, then only return the rack the sample is on *)
				And[TrueQ[inSitu],MatchQ[metaCont,Object[Container,Rack]]],
					Download[metaCont,Object],

				(* If we're returning All method-compatible instruments and racks *)
				MatchQ[method,All],
					Join[
						DeleteCases[
							{
								pickVolumeMeasurementRack[Download[contMod,Object],PlatePlatform],
								pickVolumeMeasurementRack[Download[contMod,Object],TubeRack]
							},
							Null
						],
						ToList[rack/.Null->{}]
					],

				(* If we're just returning Ultrasonic method-compatible instruments, don't resolve their racks for balances *)
				MatchQ[method,Ultrasonic],
					DeleteCases[
						{
							pickVolumeMeasurementRack[Download[contMod,Object],PlatePlatform],
							pickVolumeMeasurementRack[Download[contMod,Object],TubeRack]
						},
						Null
					],

				(* If we're just returning Gravimetric method-compatible instruments, don't resolved racks for LLDs *)
				MatchQ[method,Gravimetric],
					ToList[rack/.Null->{}]
			]
		],
		{resolvedMethods,containerModels,metaContainers,possibleRackForEachContainer}
	];

	(* Our output is currently in the form {{instrument..}..} and {{rack..}..}. Convert it to one sublist per input sample
		and convert any links into objects *)
	sampleIndexedOutput = DeleteDuplicates@Flatten[#]&/@(Transpose[{possibleInstruments,possibleRacks}]/.xLink:_Link:>Download[xLink,Object]);

	(* Finally we need to remove any objects that aren't in our Types option value *)
	result = If[MatchQ[Lookup[expandedSafeOps,Types],ListableP[All]],

		(* In this case we want every type so just return what we have *)
		sampleIndexedOutput,

		(* In this case we only want certain types so delete the rest *)
		DeleteCases[#,Except[ObjectP[Lookup[expandedSafeOps,Types]]]]&/@sampleIndexedOutput
	];

	tests = {safeOpsTests};

	outputSpecification/.{
		Result -> result,
		Tests -> tests
	}
];


(* ::Subsubsection:: *)
(*formFactorGroup*)


(* hard code patterns for container model groups with equivalent form factors *)

tube2mLP:=Alternatives[
	Model[Container,Vessel,"id:3em6Zv9NjjN8"], (* 2mL Tube *)
	Model[Container,Vessel,"id:M8n3rx03Ykp9"], (* 2mL brown tube *)
	Model[Container,Vessel,"id:o1k9jAG00e3N"], (* 0.5mL Tube with 2mL Tube Skirt *)
	Model[Container,Vessel,"id:bq9LA0JPKJE6"], (* 0.5mL Tube with 2mL Tube Skirt *)
	Model[Container,Vessel,"id:01G6nvkKrrb1"], (* 0.5mL Tube with 2mL Tube Skirt Deprecated *)
	Model[Container,Vessel,"id:aXRlGn6LO7Bk"], (* 700uL Skirted *)
	Model[Container,Vessel,"id:eGakld01zzpq"] (* 1.5mL Tube with 2mL Tube Skirt *)
];
formFactorGroup[tube2mLP]:="2mL Tube";

hplcVialP:=Alternatives[
	Model[Container,Vessel,"id:jLq9jXvxr6OZ"]
];
formFactorGroup[hplcVialP]:="HPLC Vial";

tube15mLP:=Alternatives[
	Model[Container,Vessel,"id:xRO9n3vk11pw"],(* 15mL Tube *)
	Model[Container,Vessel,"id:dORYzZJDpJmR"],(* 15mL Tube, LabOps Evaluation Model *)
	Model[Container,Vessel,"id:rea9jl1orrMp"](* 15mL Light Sensitive Centrifuge Tube *)
];
formFactorGroup[tube15mLP]:="15mL Tube";

tube50mLP:=Alternatives[
	Model[Container,Vessel,"id:bq9LA0dBGGR6"], (* 50mL Tube *)
	Model[Container,Vessel,"id:bq9LA0dBGGrd"], (* 50mL Light Sensitive Centrifuge Tube *)
	Model[Container,Vessel,Filter,"id:pZx9jo8nPKe5"], (* Centrifuge Filter, PVDF, 0.22um, 25mL *)
	Model[Container,Vessel,Filter,"id:Z1lqpMzGRX1V"], (* Centrifuge Filter, Nylon, 0.45um, 25mL *)
	Model[Container,Vessel,Filter,"id:dORYzZJn3E75"], (* Centrifuge Filter, Nylon, 0.22um, 25mL *)
	Model[Container,Vessel,Filter,"id:eGakldJ0vYWo"], (* Centrifuge Filter, PVDF, 0.45um, 25mL *)
	Model[Container,Vessel,Filter,"id:R8e1PjpBwDod"](* Centrifuge Filter, PES, 0.22um, 5mL *)
];
formFactorGroup[tube50mLP]:="50mL Tube";

bottle250mLP:=Alternatives[
	Model[Container,Vessel,"id:J8AY5jwzPPR7"], (* 250mL Glass Bottle *)
	Model[Container,Vessel,"id:J8AY5jwzPPex"] (* 250mL Amber Glass Bottle *)
];
formFactorGroup[bottle250mLP]:="250mL Bottle";

bottle500mLP:=Alternatives[
	Model[Container,Vessel,"id:aXRlGnZmOONB"], (* 500mL Glass Bottle *)
	Model[Container,Vessel,"id:8qZ1VWNmddlD"] (* 500mL Amber Glass Bottle *)
];
formFactorGroup[bottle500mLP]:="500mL Bottle";

shallowWellPlateP:=Alternatives[
	Model[Container,Plate,"id:n0k9mGzRaaBn"], (* 96-well UV-Star Plate *)
	Model[Container,Plate,"id:6V0npvK611zG"], (* 96-well Black Wall Plate *)
	Model[Container,Plate,"id:kEJ9mqR3XELE"], (* 96-well Black Wall Greiner Plate *)
	Model[Container,Plate,"id:1ZA60vwjbbqa"], (* 96-well Round Bottom Plate *)
	Model[Container,Plate,"id:BYDOjvG1pRnE"] (* 96-well All Black Plate *)
];
formFactorGroup[shallowWellPlateP]:="Shallow-well Plate";

formFactorGroup[model:ObjectP[Model[Container]]]:=model;



(* ::Subsubsection:: *)
(*pickVolumeMeasurementRack*)


(* Pick a plate platform based of the container model *)
pickVolumeMeasurementRack[containerModelObj:ObjectP[Model[Container]],PlatePlatform]:=Switch[containerModelObj,
	shallowWellPlateP,
		Model[Container,Rack,"id:qdkmxzqonkNa"], (* Plate Platform for BML VolumeChecks *)

	Model[Container, Plate, "id:Y0lXejML17rm"], (* 96-well Black Optical-Bottom Plates with Polymer Base *)
		Model[Container,Rack,"id:qdkmxzqonkNa"], (* Plate Platform for BML VolumeChecks *)

	Model[Container,Plate,"id:jLq9jXY4kknW"], (* 96-well 500uL Round Bottom DSC Plate *)
		Model[Container,Rack,"id:qdkmxzqGWrGY"], (* Volume Check Plate Adaptor for Medium-Well Plates *)

	(* 250/500 mL cross flow reservoirs *)
	Alternatives[
		Model[Container,Vessel,CrossFlowContainer,"id:WNa4ZjKZ07E7"],
		Model[Container,Vessel,CrossFlowContainer,"id:n0k9mG8mYZdp"],
		Model[Container,Vessel,CrossFlowWashContainer,"id:WNa4ZjK60wML"],
		Model[Container,Vessel,CrossFlowWashContainer,"id:54n6evL9PkJ7"]
	],Model[Container,Rack,"id:01G6nvwXDYBr"],

	(* Otherwise no rack is required *)
	_,
		Null
];

(* Pick a tube rack based of the container model *)
pickVolumeMeasurementRack[containerModelObj:ObjectP[Model[Container]],TubeRack]:=Switch[containerModelObj,
	tube2mLP,
		Model[Container,Rack,"id:BYDOjv1VAAml"], (* "2mL Tube Holder for ImageSample" *)

	Model[Container,Vessel,"id:jLq9jXvxr6OZ"],
		Model[Container,Rack,"id:XnlV5jKRn10M"], (* "Universal 2mL Tube Rack" *)

	tube15mLP|tube50mLP|Model[Container,Vessel,"id:kEJ9mqaVPPjX"]| Model[Container,Vessel,"id:M8n3rxYE55b5"],
		Model[Container,Rack,"id:9RdZXvK8OKXZ"], (* "Medium Tube Holder for MeasureVolume" *)

	(Model[Container,Vessel,"id:AEqRl954GGvv"]|Model[Container,Vessel,"id:jLq9jXvxr6OZ"]|Model[Container,Vessel,"id:dORYzZn0ooaG"]|Model[Container,Vessel,Filter,"id:qdkmxzq0WNnm"]),
		Model[Container,Rack,"id:vXl9j5qk0qDN"], (* "Small Tube Holder for MeasureVolume" *)

	Model[Container,Vessel,"id:4pO6dM5WvJKM"],
		Model[Container,Rack,"id:WNa4ZjKKz6MZ"], (* Reactor Vial Rack *)

	(* Otherwise no rack is required *)
	_,
		Null
];




(* ========================= *)
(* == findContainerStands == *)
(* ========================= *)

(* a helper function to find a single position rack to hold a Model[Container, Vessel] *)
(* it first looks at the SelfStandingContainers field, then checks for Model[Container, Rack] with a single position with the right footprint *)
(* if that doesnt work, it will check for a single position rack of the right dimensions *)
(* there is an overload that will run this in turbo mode - passing in some choices will skip a search *)
(* this is designed to run on a ton of containers at once and eliminates containers it has already found a rack for as it passes to the next search *)

(* -- singleton overload -- *)
findContainerStands[container:ObjectP[Model[Container]]]:=FirstOrDefault[findContainerStands[{container}]];

(* -- singleton overload with possible racks -- *)
findContainerStands[
	container:ObjectP[Model[Container]],
	possibleRacks:ObjectP[Model[Container, Rack]]
]:=FirstOrDefault[
	findContainerStands[{container}, possibleRacks]
];

(* -- multiple overload with no racks given -- *)
findContainerStands[containers:{ObjectP[Model[Container]]..}]:=Module[{possibleRacks},

	(*do a search excluding anything where there are no objects, also we need a tare weight*)
	possibleRacks=Search[
		Model[Container, Rack],
		Length[Positions] == 1&&Deprecated!=True&&Length[Objects]>0&&TareWeight!=Null,
		PublicObjects -> True,
		Notebooks -> {$Notebook}
	];

	findContainerStands[containers, possibleRacks]
];

(* -- core function -- *)
findContainerStands[containers:{ObjectP[Model[Container]]..}, possibleRacks:{ObjectP[Model[Container, Rack]]..}]:=Module[
	{containerPackets, rackPackets, containerObjects,footprints, dimensions,selfStandingContainers,
		filteredContainerObjects,
		racksFromSSCRules, SSCReplacedList,containersAfterSSC, rackPositionTuples,
		racksFromFootprintRules, footprintReplaceList, filteredFootprints, footprintReplacedList, containersAfterFootprint,
		racksFromDimensionRules, dimensionsReplaceList, dimensionsReplacedList, filteredDimensions, selfStandingBools},

	(* -- Download and Setup-- *)
	(*do the big download - there may not be much point in passing in a cache here*)
	{containerPackets, rackPackets}=Flatten[#, 1]&/@Quiet[
		Download[
		{
			containers,
			possibleRacks
		},
		{
			{Packet[Footprint, Dimensions, SelfStanding]},
			{Packet[Positions]}
		}
	],
		Download::FieldDoesntExist
	];

	(*lookup things that we don't want to map Lookup on*)
	{containerObjects,footprints, dimensions, selfStandingBools}=Transpose[
		Lookup[
			containerPackets,
			{Object,Footprint, Dimensions, SelfStanding}
		]/.x:LinkP[]:>Download[x, Object]
	];
	selfStandingContainers = ToList[RackFinder[containerObjects]];

	(* -- Null any instances where the container is self standing -- *)
	filteredContainerObjects = MapThread[If[TrueQ[#2], Null, #1]&, {containerObjects, selfStandingBools}];

	(* ---------------------- *)
	(* -- Search for Racks -- *)
	(* ---------------------- *)

	(*in this section, always return Rules so we can exclude the container from the next map if we don't find anything*)

	(* -- (1) check if there is a rack that is a member of self-standing containers -- *)
	(* remove any rules for cases where the container is already self standing or there are no self standing containers *)
	(* some types don't have this field so we need to also exclude $Failed *)
	racksFromSSCRules = DeleteCases[
		Normal[AssociationThread[filteredContainerObjects -> (FirstOrDefault/@selfStandingContainers)]],
		Alternatives[(_->(Null|$Failed))|(Null -> _)]
	];

	(*apply the rules*)
	SSCReplacedList = filteredContainerObjects/.racksFromSSCRules;
	(*find any thing that hasn't been replaced yet*)
	containersAfterSSC = Cases[SSCReplacedList, Except[(ObjectP[Model[Container, Rack]]|Null)]];

	(*if there were no Model[Container, Vessel]s left, we are done and can just return the index matched list*)
	If[MatchQ[containersAfterSSC, {}],
		Return[SSCReplacedList]];


	(* -- (2) check if there is a footprint/position match -- *)

	(* first filter the footprints to preserve index matching *)
	filteredFootprints = PickList[footprints, SSCReplacedList, Except[(ObjectP[Model[Container, Rack]]|Null)]];

	(* lookup the tuples from the packets to make the next map cleaner *)
	rackPositionTuples = Lookup[rackPackets, {Object, Positions}];

	(*map over the remaining containers and find racks with a single position matching the footprint of the container*)
	racksFromFootprintRules = DeleteCases[
		MapThread[
			If[MatchQ[#2, Null],
				(*do not want to match on a Null footprint*)
				Nothing,

				(*if we have a not Null Footprint lets see how that goes*)
				Module[{possibleRacksFromFootprint},

					(* find any rack that has a single position of hte correct footprint - return {Null} if we cant find one *)
					possibleRacksFromFootprint = FirstOrDefault[
						Cases[
							rackPositionTuples,
							{_,{KeyValuePattern[Footprint->#2]}}
						],
						{Null}
					];

					(* make rules to do the replacement with *)
					#1 -> First[possibleRacksFromFootprint]
				]
			]&,
			{containersAfterSSC, filteredFootprints}
		],
		(_ -> Null)
	];

	(*apply our footprint rules to the list of containers we had previously applied the other rules to*)
	footprintReplacedList = SSCReplacedList/.racksFromFootprintRules;
	(*find any thing that hasnt been replaced yet*)
	containersAfterFootprint = Cases[footprintReplacedList, Except[(ObjectP[Model[Container, Rack]]|Null)]];

	(* if this round of replace rules has turned all Vessels into Racks, we are done*)
	If[MatchQ[containersAfterFootprint, {}],
		Return[footprintReplacedList]];


	(* -- (3) check if the external dimensions fit the dimension of a position -- *)

	(* first filter the footprints to preserve index matching *)
	filteredDimensions = PickList[dimensions, footprintReplacedList, Except[(ObjectP[Model[Container, Rack]]|Null)]];

	(*map over the remaining containers and find racks with a single position matching the footprint of the container*)
	racksFromDimensionRules = DeleteCases[
		MapThread[
			Module[{possibleRacksFromDimensions, depth, width},

				(* get the detph and width *)
				{depth, width} = #2[[;;2]];

				(* find any rack that has a single position of the correct dimensions - return {Null} if we cant find one *)
				(* as with similar instances where we try to do this, there is a little wiggle room, we don't want to be too restrictive *)
				(* also be flexible interchanging width/depth since it may be arbitrary anyway *)
				(*TODO: this could be an option indicating how restrictive we want to be on upper an lower bounds*)
				possibleRacksFromDimensions = FirstOrDefault[
					Cases[
						rackPositionTuples,
						{_,
							{
								Alternatives[
									KeyValuePattern[{MaxWidth -> RangeP[depth,depth*1.2], MaxDepth -> RangeP[width, width*1.2]}],
									KeyValuePattern[{MaxWidth -> RangeP[width,width*1.2], MaxDepth -> RangeP[depth, depth*1.2]}]
								]
							}
						}
					],
					{Null}
				];

				(* make rules to do the replacement with *)
				#1 -> First[possibleRacksFromDimensions]
			]&,
			{containersAfterFootprint, filteredDimensions}
		],
		(_ -> Null)
	];

	(*apply our footprint rules to the list of containers we had previously applied the other rules to*)
	dimensionsReplacedList = footprintReplacedList/.racksFromDimensionRules;

	(*return an empty list by replacing any remaining Model[Container]\[Rule] Null to preserve index matching*)
	Replace[dimensionsReplacedList,(Except[ObjectP[Model[Container, Rack]]]-> Null), 1]
];

(* ========================= *)
(* == findCommonSolventDensities == *)
(* ========================= *)

(* findCommonSolventDensities is a helper function to construct a dictionary of Model[Molecule] -> Density *)
findCommonSolventDensities[myMolecules:{ObjectReferenceP[Model[Molecule]]...}] := findCommonSolventDensities[myMolecules] = Module[{allCommonSolventMolecules, densities, nonNullDensity, nonNullDensityMolecules},
	If[!MemberQ[$Memoization, Experiment`Private`findCommonSolventDensities],
		AppendTo[$Memoization, Experiment`Private`findCommonSolventDensities]
	];

	densities = Download[myMolecules, Density];

	nonNullDensityMolecules = PickList[myMolecules, densities, DensityP];
	nonNullDensity = PickList[densities, densities, DensityP];

	AssociationThread[nonNullDensityMolecules -> nonNullDensity]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentMeasureVolumeQ*)


DefineOptions[ValidExperimentMeasureVolumeQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{ExperimentMeasureVolume}
];


ValidExperimentMeasureVolumeQ[myObjects : ListableP[ObjectP[Object[Container]]] | ListableP[(ObjectP[{Object[Sample], Model[Sample]}] | _String)],myOptions:OptionsPattern[ValidExperimentMeasureVolumeQ]]:=Module[
	{listedOptions, preparedOptions, measureVolumeTests, allTests, verbose,outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentMeasureVolume *)
	measureVolumeTests = ExperimentMeasureVolume[myObjects, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[DeleteCases[ToList[myObjects], _String], OutputFormat -> Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{DeleteCases[ToList[myObjects], _String], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{measureVolumeTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMeasureVolumeQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]],
		it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out - Steven
	 	^ what he said - Cam *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentMeasureVolumeQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentMeasureVolumeQ"]

];



(* ::Subsubsection:: *)
(*ExperimentMeasureVolumeOptions*)


DefineOptions[ExperimentMeasureVolumeOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentMeasureVolume}
];


ExperimentMeasureVolumeOptions[myObjects : ListableP[ObjectP[Object[Container]]] | ListableP[(ObjectP[{Object[Sample], Model[Sample]}] | _String)],myOptions:OptionsPattern[ExperimentMeasureVolumeOptions]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentMeasureVolume *)
	options=ExperimentMeasureVolume[myObjects,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentMeasureVolume],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentMeasureVolumePreview*)


DefineOptions[ExperimentMeasureVolumePreview,
	SharedOptions:>{ExperimentMeasureVolume}
];


ExperimentMeasureVolumePreview[myObjects : ListableP[ObjectP[Object[Container]]] | ListableP[(ObjectP[{Object[Sample], Model[Sample]}] | _String)],myOptions:OptionsPattern[ExperimentMeasureVolumePreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentMeasureVolume *)
	ExperimentMeasureVolume[myObjects, Append[noOutputOptions, Output -> Preview]]
];
