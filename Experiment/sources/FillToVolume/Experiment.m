(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentFillToVolume*)


(* ::Subsubsection::Closed:: *)
(*ExperimentFillToVolume Options and Messages*)



DefineOptions[ExperimentFillToVolume,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the samples that are used for the fill to volume, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the containers of the samples that are used for the fill to volume, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> Method,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> FillToVolumeMethodP
				],
				Description -> "The method by which to add the Solvent to the bring the input sample up to the TotalVolume.",
				ResolutionDescription -> "Automatically set to Volumetric if in a volumetric flask, or Null and throws an error if in an UltrasonicIncompatible container or using an UltrasonicIncompatible solvent, or Ultrasonic otherwise.",
				Category -> "General"
			},
			{
				OptionName->GraduationFilling,
				Default->False,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				],
				Description->"Indicates if the Solvent specified in the stock solution model is added to bring the stock solution model up to the TotalVolume based on the horizontal markings on the container indicating discrete volume levels, not necessarily in a volumetric flask.",
				Category->"Hidden"
			},
			{
				OptionName -> Solvent,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Object[Container, Vessel], Model[Sample]}],
					Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						},
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Solvents"
						}
					}
				],
				Description -> "The solvent used to bring up the volume to the solution's TotalVolume.",
				ResolutionDescription -> "Automatically set to the value in the input sample's Solvent field, or Model[Sample, \"Milli-Q water\"] otherwise (with a warning).",
				Category -> "General"
			},
			{
				OptionName -> SolventLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the solvent that is used for the fill to volume, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName -> SolventContainer,
				Default -> Automatic,
				ResolutionDescription -> "Automatically set to the Object[Container, Vessel] if an Object[Sample] is specified in the Solvent option. Otherwise, automatically set to a Model[Container, Vessel] on any existing samples that can be used to fulfill the Model[Sample] request or based on the container that the default product for the Model[Sample] comes in.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Existing Container"->Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Container, Vessel]]
					],
					"New Container"->Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[Container, Vessel]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					]
				],
				Description -> "The container that the source sample will be located in during the transfer.",
				Category->"General"
			},
			{
				OptionName -> SolventContainerLabel,
				Default -> Automatic,
				Description->"A user defined word or phrase used to identify the solvent's container that is used for the fill to volume, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName -> Tolerance,
				Default -> Automatic,
				ResolutionDescription -> "Automatically set to the Precision field of the sample's container if Method -> Volumetric, or calculated from the VolumeCalibrations field of the sample's container model at the specified volume.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume Tolerance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Milliliter],
						Units -> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
					],
					"Percent Tolerance" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					]
				],
				Description -> "The allowed tolerance of the final volume.  If the sample's volume reaches the specified volume +/- this value then no more Solvent will be added.  If the sample's volume is below the specified volume +/- this value then more Solvent will be added.  If the sample's volume is above the specified volume +/-, no further Solvent will be added and TargetVolumeToleranceAchieved in the protocol object will be set to False.",
				Category -> "Instrument Specifications"
			},
			{
				OptionName -> SolventStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which the specified Solvent used by this experiment should be stored after the protocol is completed. If left unset, the solvents will be stored according to their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Post Experiment",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
				]
			},
			{
				OptionName -> LiquidLevelDetector,
				Default -> Automatic,
				Description -> "The liquid level detector that will be used to measure the volume of the sample if Method -> Ultrasonic.",
				AllowNull -> True,
				Category -> "Hidden",
				(*Null indicates Method -> Volumetric*)
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Instrument, LiquidLevelDetector], Model[Instrument, LiquidLevelDetector]}]
				]
			}
		],
		(* options shared with ExperimentTransfer *)
		TransferDestinationWellOption,
		TransferInstrumentOption,
		TransferEnvironmentOption,
		EquivalentTransferEnvironmentsOption,
		TransferTipOptions,
		TransferNeedleOption,
		TransferFunnelOption,
		HandPumpOption,
		TransferHermeticSourceOptions,
		TipRinseOptions,
		AspirationMixOptions,
		DispenseMixOptions,
		IntermediateDecantOptions,
		{
			OptionName -> WasteContainer,
			Default->Automatic,
			Description->"The container used to temporarily hold the excess samples removed from the intermediate containers and graduated cylinders after the samples are filled to the target volumes. The sample in this vessel will be discarded at the end of the protocol.",
			ResolutionDescription -> "Automatically set to Model[Container, Vessel, \"250mL Glass Bottle\"] if any sample is filled with Volumetric method.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Container],
					Object[Container]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers"
					}
				}
			],
			Category -> "Hidden"
		},
		SourceTemperatureOptions,
		DestinationTemperatureOptions,
		SterileTechniqueOption,
		RNaseFreeTechniqueOption,
		(* Aliquot Options without DestinationWell, Hidden for now *)
		ModifyOptions[AliquotOptions,
			{
				Aliquot,
				AliquotSampleLabel,
				AliquotAmount,
				TargetConcentration,
				TargetConcentrationAnalyte,
				AssayVolume,
				ConcentratedBuffer,
				BufferDilutionFactor,
				BufferDiluent,
				AssayBuffer,
				AliquotSampleStorageCondition,
				AliquotContainer,
				AliquotPreparation,
				ConsolidateAliquots},
				{Category -> "Hidden"}
		],
		(* Rename the AliquotOption DestinationWell to AliquotDestinationWell as ExperimentFillToVolume has its own DestinationWellOption, Hidden for now *)
		ModifyOptions[AliquotOptions, DestinationWell, {OptionName -> AliquotDestinationWell, Category -> "Hidden", Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed. This sample preparation option is typically called DestinationWell for other functions."}],

		(* if you're giving a model input, the starting volume/container to use by default *)
		PreparatoryUnitOperationsOption,
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 5 Milliliter."
			}
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Vessel, \"50mL Tube\"]."
			}
		],
		(* Shared protocol options *)
		SamplesOutStorageOption,
		ProtocolOptions,
		SimulationOption,  (* TODO: Remove this and add to ProtocolOptions when it is time to blitz. Also add SimulateProcedureOption. *)
		{
			OptionName->MaxNumberOfOverfillingRepreparations,
			Default->Automatic,
			Description->"The maximum number of times the FillToVolume protocol can be repeated in the event of target volume overfilling. When a repreparation is triggered, the same inputs and options are used, and the value of MaxNumberOfOverfillingRepreparations is decreased by 1. If this value is set to Null, the protocol will complete normally, even if the final sample volume exceeds the target.",
			ResolutionDescription -> "For a new FillToVolume protocol, automatically set to 3 if all experiment inputs are of type Model[Sample]. When a repeat protocol is enqueued, the value is decremented by 1 from the current MaxNumberOfOverfillingRepreparations. For all other cases, set to Null.",
			AllowNull->True,
			Category->"General",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,3]
			]
		},
		NonBiologyPostProcessingOptions,
		SubprotocolDescriptionOption
	}
];

Error::ReplicateFillToVolumeSamples="The following input(s) correspond to duplicate containers and positions: `1`.  Duplicate samples are not permitted in ExperimentFillToVolume.  Please remove the duplicates and try again.";
Error::MissingDestinationWell="The DestinationWell option could not resolved for the following input container(s) because more they have more than one possible position.  Please specify the DestinationWell option for these containers, or specify the input as a sample rather than as a container.";
Error::SampleNotInDestinationWell="The current position of input sample(s) `1` do not match the specified DestinationWell (`2`) for those sample(s).  Please set the DestinationWell to the samples' current values, or allow it to be set automatically.";
Error::FillToVolumeEmptyPosition="The specified DestinationWell `1` for the input container(s) `2` is currently empty. If you would like to add liquid to an empty container or empty position in a container, please use ExperimentTransfer rather than ExperimentFillToVolume.";
Error::FillToVolumeIncompatibleMethod="The specified Method does not match the current container of the following input(s): `1`.  If the sample is in a volumetric flask, Method must be set to Volumetric.  Otherwise, Method must be Ultrasonic.  Please update this value, or transfer the sample to a different container before performing a FillToVolume.";
Warning::FillToVolumeSolventDefaulted="The Solvent option could not be automatically set for the following input sample(s) or container(s) because the option was not specified and the Solvent field is not sufficiently populated: `1`.  This option has been set to Model[Sample, \"Milli-Q water\"], but if this is not satisfactory please specify the Solvent option directly.";
Error::FillToVolumeUltrasonicIncompatibleSample="The Method option was set to Ultrasonic, but the following specified sample(s) (or the corresponding value of the Solvent option) have their UltrasonicIncompatible fields set to True, and so their volume will not be measurable ultrasonically.  Please transfer the sample to a volumetric flask before performing a FillToVolume, or use a different, ultrasonic-compatible Solvent.";
Error::FillToVolumeUltrasonicIncompatibleContainer="The Method option was set to Ultrasonic, but the following specified sample(s) or container(s) are in a container that cannot be measured ultrasonically: `1`.  Please transfer the sample to a volumetric flask (or a different container whose UltrasonicIncompatible field is not True and that has its VolumeCalibrations field populated) before performing a FillToVolume.";
Error::ToleranceTooSmall="The Tolerance option for the following sample(s) or container(s) was smaller than the minimum allowed Tolerance for the specified Method and volume: `1`.  The minimum allowed Tolerance is `2`.  Please increase the Tolerance, or allow it to be set Automatically.";
Error::VolumetricWrongVolume="The specified Volume for the following sample(s) or container(s) `1` (`2`) does not equal the MaxVolume of the containers (`3`), but Method -> Volumetric.  Volumetric flasks may only be used if filling to the MaxVolume of the container.  Please change the specified volume.";
Error::VolumetricTooLargeVolume="The specified Volume for the following sample(s) or container(s) `1` (`2`) is larger than the MaxVolume of the containers (`3`), but Method -> Volumetric. When GraduationFilling is true, volumetric flasks may not be used for a volume greater than the MaxVolume of the container. Please change the specified volume.";
Error::SampleVolumeAboveRequestedVolume="The current volume for the following sample(s) or container(s) `1` (`2`) is greater than the requested volume to fill to (`3`).  Please increase the requested volume to be greater than the current volume.";
Error::TransferEnvironmentUltrasonicForbidden="The following sample(s) or container(s) have Method -> Ultrasonic and TransferEnvironment set to a GloveBox or BiosafetyCabinet: `1`.  Only volumetric methods are allowed in those transfer environments.  Please adjust the Method or TransferEnvironment options accordingly.";
Error::InvalidMaxNumberOfOverfillingRepreparations="MaxNumberOfOverfillingRepreparationsOptions option can only be set when the inputs are all sample Models. Please set MaxNumberOfOverfillingRepreparationsOptions to Null or allow it to be automatically resolved.";

(* ::Subsubsection:: *)
(*ExperimentFillToVolume*)

(*
	Single Sample with single second input:
		- Takes a single sample and single volume and passes through to core overload
*)
ExperimentFillToVolume[
	mySample : ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | {LocationPositionP,ObjectP[Object[Container]]},
	myVolume : VolumeP,
	myOptions : OptionsPattern[ExperimentFillToVolume]
] := ExperimentFillToVolume[{mySample}, {myVolume}, myOptions];

(*
	Multiple samples with single second input:
		- Expands the volume to be the value for all samples and passes through to the core overload
*)
ExperimentFillToVolume[
	mySamples : {(ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | {LocationPositionP, ObjectP[Object[Container]]})..},
	myVolume : VolumeP,
	myOptions : OptionsPattern[ExperimentFillToVolume]
] := ExperimentFillToVolume[mySamples, ConstantArray[myVolume, Length[mySamples]], myOptions];

(*
	CORE OVERLOAD: List Sample with list volumes (all options):
		- Core functionality lives here
*)
ExperimentFillToVolume[
	mySamples : {(ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | {LocationPositionP,ObjectP[Object[Container]]})..},
	myVolumes : {VolumeP..},
	myOptions : OptionsPattern[ExperimentFillToVolume]
] := Module[
	{
		inheritedCache, allDownloadValues, newCache, listedOptions, currentSimulation, userSpecifiedObjects,
		listedSamples, outputSpecification, output, gatherTests, messages, safeOptionTests, upload, confirm, canaryBranch, fastTrack,
		parentProt, validLengthTests, combinedOptions, expandedCombinedOptions, resolveOptionsResult, resolvedOptions,
		resolutionTests, resolvedOptionsNoHidden, returnEarlyQ, finalizedPackets, resourcePacketTests, allTests, validQ,
		safeOptions, validLengths, unresolvedOptions, applyTemplateOptionTests, specifiedSolventValues,
		previewRule, optionsRule, testsRule, resultRule, sampleFields, modelFields, specifiedTransferEnvironments,
		allTransferEnvironmentObjs, containerFields, containerModelFields, allSolventModels, allSolventObjs,
		contentsFields, contentsModelFields, expandedCombinedOptionsWithoutDestWell, actualSpecifiedDestinationWell,
		sampleCacheFields, containerCacheFields, modelSampleCacheFields, modelContainerCacheFields, solventFields,
		solventComponentFields, solventContainerFields, solventContainerComponentFields, sampleContainerCalibrationFields,
		containerCalibrationFields, allTipModels, allFunnels, allHandlingStation,
		simulatedSampleQ, objectsExistQs, objectsExistTests, performSimulationQ, simulatedProtocol, simulation,
		listedSamplesWithDestinationWells, resolverCache, samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
		updatedSimulation, validSamplePreparationResult, modelInputQ
	},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamplesWithDestinationWells, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* get the input samples, removing the destination well if specified in the input *)
	listedSamples = Map[
		If[MatchQ[#, ObjectP[]],
			#,
			#[[2]]
		]&,
		listedSamplesWithDestinationWells
	];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, currentSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentFillToVolume,
			listedSamples,
			listedOptions,
			DefaultPreparedModelAmount -> 5 Milliliter,
			DefaultPreparedModelContainer -> Model[Container, Vessel, "50mL Tube"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentFillToVolume, optionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentFillToVolume, optionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns or if the option lengths are invalid, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* call ValidInputLengthsQ to make sure all the options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentFillToVolume, {samplesWithPreparedSamplesNamed, myVolumes}, optionsWithPreparedSamplesNamed, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentFillToVolume, {samplesWithPreparedSamplesNamed, myVolumes}, optionsWithPreparedSamplesNamed], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[Not[validLengths],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* get assorted hidden options *)
	{
		upload,
		confirm,
		canaryBranch,
		fastTrack,
		parentProt,
		inheritedCache
	} = Lookup[
		safeOptions,
		{
			Upload,
			Confirm,
			CanaryBranch,
			FastTrack,
			ParentProtocol,
			Cache
		}
	];

	(* apply the template options *)
	(* need to specify the definition number (we are number 6 for samples at this point *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentFillToVolume, {samplesWithPreparedSamplesNamed, myVolumes}, optionsWithPreparedSamplesNamed, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentFillToVolume, {samplesWithPreparedSamplesNamed, myVolumes}, optionsWithPreparedSamplesNamed, Output -> Result], Null}
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	expandedCombinedOptionsWithoutDestWell = Last[ExpandIndexMatchedInputs[ExperimentFillToVolume, {samplesWithPreparedSamplesNamed, myVolumes}, combinedOptions]];

	(* get the correct DestinationWell value; if specified in the input, then that overrides what was specified in the option *)
	actualSpecifiedDestinationWell = MapThread[
		If[MatchQ[#1, ObjectP[]],
			#2,
			#1[[1]]
		]&,
		{ToList[mySamples], Lookup[expandedCombinedOptionsWithoutDestWell, DestinationWell]}
	];
	expandedCombinedOptions = ReplaceRule[expandedCombinedOptionsWithoutDestWell, DestinationWell -> actualSpecifiedDestinationWell];

	(* --- Make our one big Download call --- *)

	(* - Throw an error if any of the specified input objects or objects in Options are not members of the database - *)
	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates[Cases[
		Flatten[{samplesWithPreparedSamplesNamed, myOptions}],
		ObjectP[]
	]];

	(* Check that the specified objects exist or are visible to the current user *)
	simulatedSampleQ = Lookup[fetchPacketFromCache[#, inheritedCache], Simulated, False]& /@ userSpecifiedObjects;
	objectsExistQs = DatabaseMemberQ[PickList[userSpecifiedObjects, simulatedSampleQ, False], Simulation -> currentSimulation];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1], #2, True]&,
			{PickList[userSpecifiedObjects, simulatedSampleQ, False], objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[MemberQ[objectsExistQs, False],
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist, PickList[PickList[userSpecifiedObjects, simulatedSampleQ, False], objectsExistQs, False]];
			Message[Error::InvalidInput, PickList[PickList[userSpecifiedObjects, simulatedSampleQ, False], objectsExistQs, False]]
		];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests, applyTemplateOptionTests, objectsExistTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* pull out the Solvent option; also need to always include water here *)
	specifiedSolventValues = Lookup[expandedCombinedOptions, Solvent];
	allSolventModels = Flatten[{Model[Sample, "Milli-Q water"], Cases[Flatten[ToList[specifiedSolventValues]], ObjectP[Model[Sample]]]}];
	allSolventObjs = Cases[Flatten[ToList[specifiedSolventValues]], ObjectP[Object[Sample]]];

	(* pull out the TransferEnvironment option; for all the objects, we need to get all the recursive contents *)
	specifiedTransferEnvironments = Lookup[expandedCombinedOptions, TransferEnvironment];
	allTransferEnvironmentObjs = Cases[Flatten[ToList[specifiedTransferEnvironments]], ObjectP[Object]];

	(* get the cache fields for Object[Sample] and Model[Sample] (and Object[Container and Model[Container]) *)
	sampleCacheFields = Sequence @@ {SamplePreparationCacheFields[Object[Sample], Format -> Sequence], UltrasonicIncompatible, RequestedResources};
	containerCacheFields = Sequence @@ {SamplePreparationCacheFields[Object[Container], Format -> Sequence], UltrasonicIncompatible, RequestedResources};
	modelSampleCacheFields = Sequence @@ {SamplePreparationCacheFields[Model[Sample], Format -> Sequence], UltrasonicIncompatible, RequestedResources};
	modelContainerCacheFields = Sequence @@ {SamplePreparationCacheFields[Model[Container], Format -> Sequence], UltrasonicIncompatible, VolumeCalibrations, Precision, RequestedResources};

	(* get the Object[Sample], Model[Sample], Object[Container], and Model[Container] fields I need *)
	sampleFields = Packet[sampleCacheFields, containerCacheFields];
	modelFields = Packet[Model[{modelSampleCacheFields, modelContainerCacheFields}]];
	containerFields = Packet[Container[{containerCacheFields}]];
	containerModelFields = Packet[Container[Model][{modelContainerCacheFields}]];
	contentsFields = Packet[Field[Contents[[All, 2]]][{sampleCacheFields}]];
	contentsModelFields = Packet[Field[Contents[[All, 2]]][Model][{modelSampleCacheFields}]];
	solventFields = Packet[Field[Solvent[DefaultSampleModel]]];
	solventComponentFields = Packet[Field[Solvent][DefaultSampleModel][{modelSampleCacheFields}]];
	solventContainerFields = Packet[Field[Contents[[All, 2]][Solvent]][DefaultSampleModel]];
	solventContainerComponentFields = Packet[Field[Contents[[All, 2]][Solvent]][DefaultSampleModel][{modelSampleCacheFields}]];
	sampleContainerCalibrationFields = Packet[Container[Model][VolumeCalibrations][{Name, Anomalous, Deprecated, DeveloperObject, CalibrationFunction, CalibrationStandardDeviationFunction, CalibrationDistributionFunction, FitAnalysis, DateCreated, LiquidLevelDetectorModel}]];
	containerCalibrationFields = Packet[Model[VolumeCalibrations][{Name, Anomalous, Deprecated, DeveloperObject, CalibrationFunction, CalibrationStandardDeviationFunction, CalibrationDistributionFunction, FitAnalysis, DateCreated, LiquidLevelDetectorModel}]];

	(* get all the potential instruments/parts/etc that we migth use *)
	{
		allTipModels,
		allHandlingStation,
		allFunnels
	}=Search[
		{
			{Model[Item, Tips]},
			{Object[Instrument, HandlingStation]},
			{Model[Part, Funnel]}
		},
		{
			Deprecated!=True && DeveloperObject != True,
			DateRetired == Null && DeveloperObject != True,
			Deprecated!=True && DeveloperObject != True
		}
	];

	(* make the Download call on all the samples, containers, and buffers *)
	allDownloadValues = Check[
		Quiet[
			Download[
				{
					samplesWithPreparedSamplesNamed,
					allSolventModels,
					allSolventObjs,

					DeleteDuplicates@Flatten[{allTipModels, Cases[safeOptions, ObjectReferenceP[Model[Item, Tips]], Infinity]}],
					Cases[Flatten[Lookup[safeOptions, {Tips}]], ObjectP[Object[Item, Tips]]],
					Cases[Lookup[safeOptions, TransferEnvironment], ObjectP[Object[]]],
					allHandlingStation
				},
				Evaluate[{
					{
						sampleFields,
						modelFields,
						containerFields,
						containerModelFields,
						contentsFields,
						contentsModelFields,
						Packet[Field[Composition[[All, 2]][MolecularWeight]]],
						solventFields,
						solventComponentFields,
						solventContainerFields,
						solventContainerComponentFields,
						sampleContainerCalibrationFields,
						containerCalibrationFields
					},
					{
						Packet[modelSampleCacheFields]
					},
					{
						sampleFields,
						modelFields,
						containerFields,
						containerModelFields
					},
					{Packet[Name, NumberOfTips, RentByDefault]},
					{Packet[Model[{Name, NumberOfTips, RentByDefault}]]},
					{Packet[Contents, Pipettes, Balances, Status], Packet[Pipettes[{Model}]], Packet[Balances[{Model}]], Packet[Model[{Name, CultureHandling}]]}, (* suppliedTransferEnvironmentPackets *)
					{Packet[Model[{CultureHandling}]], Packet[Model, PipetteCamera, Contents, Pipettes, Balances, Status, Model, RequestedResources], Packet[Pipettes[Model]], Packet[Balances[Model]]} (* allHandlingStationPackets *)
				}],
				Cache -> inheritedCache,
				Simulation -> currentSimulation
			],
			{Download::FieldDoesntExist, Download::NotLinkField}
		],
		$Failed,
		{Download::ObjectDoesNotExist}
	];

	(* Return early if objects do not exist *)
	If[MatchQ[allDownloadValues, $Failed],
		Return[$Failed]
	];

	(* make the new cache, removing any nulls or $Faileds *)
	newCache = Cases[FlattenCachePackets[{inheritedCache, allDownloadValues}], PacketP[]];

	(* --- Resolve the options! --- *)

	(* Check if we have model inputs only to help resolve MaxNumberOfOverfillingRepreparations. Otherwise we cannot do re-preparation *)
	(* This has to happen here before resolver because model inputs are treated as PreparatoryUnitOperations and simulated Objects will be passed to the resolver below. *)
	(* The boolean here will be passed down to resolver. *)
	modelInputQ = MatchQ[mySamples,ListableP[ObjectP[Model[Sample]]]];

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolveExperimentFillToVolumeOptions[samplesWithPreparedSamplesNamed, myVolumes, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache, Simulation -> currentSimulation, ModelInputQ->modelInputQ],
			{resolveExperimentFillToVolumeOptions[samplesWithPreparedSamplesNamed, myVolumes, expandedCombinedOptions, Output -> Result, Cache -> newCache, Simulation -> currentSimulation, ModelInputQ->modelInputQ], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* remove the hidden options (except GraduationFilling) and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveExperimentFillToVolumeOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentFillToVolume,
		Normal[KeyDrop[resolvedOptions, {LiquidLevelDetector, Email, Site}], Association],
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolveOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolutionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Result|Simulation];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ && Not[performSimulationQ],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				(* no work cells allowed here; it's all manual here so I don't need to do logic here like Transfer*)
				Options -> resolvedOptionsNoHidden,
				Preview -> Null,
				Tests -> Flatten[{safeOptionTests, applyTemplateOptionTests, validLengthTests, objectsExistTests, resolutionTests}],
				Preview -> Null,
				Simulation -> Simulation[]
			}
		]
	];

	(* If automatic aliquoting was performed, then there might be new model containers in the cache and simulation *)
	resolverCache = Lookup[resolvedOptions, Cache];

	(* call the aliquotPacket function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	(* Simulation is passed via resolvedOptions*)
	{finalizedPackets, resourcePacketTests} = Which[
		returnEarlyQ,
		{$Failed, {}},
		gatherTests,
		fillToVolumeResourcePackets[samplesWithPreparedSamplesNamed, myVolumes, unresolvedOptions, ReplaceRule[resolvedOptions, {Output -> {Result, Tests}}],  Simulation -> currentSimulation, Cache -> resolverCache],
		True,
		{fillToVolumeResourcePackets[samplesWithPreparedSamplesNamed, myVolumes, unresolvedOptions, ReplaceRule[resolvedOptions, {Output -> Result}], Simulation -> currentSimulation, Cache -> resolverCache], Null}
	];

	(* If aliquoting was perfromed we added samples to simulations (simulated and discarded during resolver) and resimulated during resource packets*)
	(* These simulated samples ended up in the finalized packets so we need to get them out *)
	updatedSimulation = If[MatchQ[finalizedPackets, $Failed], currentSimulation, finalizedPackets[[3]]];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentFillToVolume[
			If[MatchQ[finalizedPackets, $Failed],
				$Failed,
				finalizedPackets[[1]] (* protocolPacket *)
			],
			If[MatchQ[finalizedPackets, $Failed],
				$Failed,
				finalizedPackets[[2]] (* unitOperationPackets *)
			],
			samplesWithPreparedSamplesNamed,
			myVolumes,
			resolvedOptions,
			Cache -> resolverCache,
			Simulation -> updatedSimulation
		],
		{Null, updatedSimulation}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOptionTests,validLengthTests,applyTemplateOptionTests,resolutionTests,resourcePacketTests}],
			Options -> resolvedOptionsNoHidden,
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* --- Packaging the return value --- *)

	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOptionTests, applyTemplateOptionTests, validLengthTests, resolutionTests, resourcePacketTests}], _EmeraldTest];

	(* figure out if we are returning $Failed for the Result option *)
	(* the tricky part is that if the Output option includes Tests _and_ Result, messages will be suppressed.
		Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed
		Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		(* needs to be MemberQ because could possibly generate multiple protocols *)
		MatchQ[finalizedPackets, $Failed] || MemberQ[Flatten[finalizedPackets], $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"ExperimentFillToVolume" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
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
		allTests,
		Null
	];

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
	resultRule = Result -> If[MemberQ[output, Result] && validQ,
		(* need to do this because want to return only one protocol and not a list of length one *)
		(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
		Which[
			(* If our resource packets failed, we can't upload anything. *)
			MatchQ[finalizedPackets, $Failed], $Failed,

			(* Actually upload our protocol object. *)
			True,
				UploadProtocol[
					finalizedPackets[[1]], (* protocolPacket *)
					finalizedPackets[[2]], (* unitOperationPackets *)
					Upload -> upload,
					Confirm -> confirm,
					CanaryBranch -> canaryBranch,
					ParentProtocol -> parentProt,
					Priority -> Lookup[safeOptions, Priority],
					StartDate -> Lookup[safeOptions, StartDate],
					HoldOrder -> Lookup[safeOptions, HoldOrder],
					QueuePosition -> Lookup[safeOptions, QueuePosition],
					ConstellationMessage -> Object[Protocol, FillToVolume],
					Cache -> resolverCache,
					Simulation -> simulation
			]
		],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];


(* ::Subsection:: *)
(* resolveFillToVolumeMethod *)

DefineOptions[resolveFillToVolumeMethod,
	SharedOptions:>{
		ExperimentFillToVolume,
		CacheOption,
		SimulationOption,
		OutputOption,
		{ModelInputQ -> False, BooleanP, "Whether this function is being called with Model[Sample] inputs only."}
	}
];

(* NOTE: mySamples can be Automatic when the user has not yet specified a value for autofill. *)
resolveFillToVolumeMethod[
	mySamples:ListableP[Automatic|(ObjectP[{Object[Sample], Object[Container]}] | {LocationPositionP,ObjectP[Object[Container]]})],
	myVolumes : ListableP[VolumeP],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions, outputSpecification, output, gatherTests, result, tests},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveFillToVolumeMethod, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = Lookup[safeOptions, Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* for FillToVolume, result is always ManualSamplePreparation and there are no tests *)
	result = Manual;
	tests = {};

	outputSpecification /. {Result -> result, Tests -> tests}
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentFillToVolumeOptions *)


DefineOptions[resolveExperimentFillToVolumeOptions,
	Options :> {
		(* this doesn't actually exist yet but for now we're just going to have it in here *)
		{EnableSamplePreparation -> False, BooleanP, "If True, this resolver is being called as part of sample prep option resolution.", Category -> Hidden},
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

(* private function to resolve all the options *)
resolveExperimentFillToVolumeOptions[mySamples : {ObjectP[{Object[Sample], Object[Container]}]..}, myVolumes : {VolumeP..}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentFillToVolumeOptions]] := Module[
	{safeOptions, outputSpecification, output, gatherTests, messages, invalidOptions, invalidInputs, allTests, testsRule,
		resultRule, resolvedOptions, inheritedCache, sampleOrContainerPackets, firstTransferVolumes, maxVolumes,
		sampleOrContainerModelPackets, missingDestinationWellErrors, resolvedDestinationWell, sampleNotInPositionErrors,
		missingDestinationWellOptions, missingDestinationWellTest, sampleNotInPositionOptions, sampleNotInPositionTest,
		emptyContainerErrors, emptyContainerOptions, emptyContainerTest, mapThreadFriendlyOptions, allSamplePackets,
		resolvedMethod, incompatibleMethodErrors, incompatibleMethodOptions, incompatibleMethodTest, resolvedSolvent,
		solventDefaultedToWaterWarnings, solventDefaultedToWaterTests, ultrasonicIncompatibleSampleErrors,
		ultrasonicIncompatibleContainerErrors, ultrasonicIncompatibleSampleOptions, ultrasonicIncompatibleSampleTest,
		ultrasonicIncompatibleContainerOptions, ultrasonicIncompatibleContainerTest, resolvedTolerance, simulation,
		toleranceTooSmallErrors, resolvedMaxTolerance, toleranceTooSmallOptions, toleranceTooSmallTest, transferOptions,requiredSolventVolumes,
		resolvedTransferOptions,transferResolvingTests, sharedOptionsBetweenFtVAndTransfer, sharedOptionsToPass,
		relevantResolvedTransferOptions,postTransferReplaceRules,postTransferResolutionInstruments, postTransferTipReplaceRules,postTransferSourceContainer,postTransferSourceContainerInternalDepth,name, validNameQ, nameInvalidOptions, validNameTest, volumetricWrongVolumeErrors,
		postTransferIntermediateContainerReplaceRules,volumetricWrongVolumeOptions, volumetricWrongVolumeSamples, volumetricWrongVolumeVolumes, volumetricWrongVolumeTest,
		volumetricWrongVolumeMaxVolumes, volumetricTooLargeVolumeErrors, volumetricTooLargeVolumeOptions, volumetricTooLargeVolumeSamples,
		volumetricTooLargeVolumeVolumes, volumetricTooLargeVolumeTest, volumetricTooLargeVolumeMaxVolumes, samplesOutStorage,
		solventStorage, solventObjs, solventObjsStorage,
		validContainerStorageConditionBool, validContainerStorageConditionTests, validContainerStorageConditionInvalidOptions,
		talliedSamplePackets, replicateSamplePackets, replicateSamplePositions, replicateInvalidInputs, duplicateSampleInputs,
		duplicateSampleTest, ultrasonicForbiddenEnvironmentQ, ultrasonicForbiddenSamples, ultrasonicForbiddenOptions,
		ultrasonicForbiddenTests, resolvedLiquidLevelDetectors, resolvedPostProcessingOptions,
		modelInputQ, resolvedMaxNumberOfOverfillingRepreparations, invalidMaxNumberOfOverfillingRepreparationsOptions, maxNumberOfOverfillingRepreparationsTest,
		currentSampleVolumes, sampleVolumeAboveRequestedVolumeErrors, sampleVolumeAboveRequestedVolumeSamples, updatedSimulation,
		sampleVolumeAboveRequestedVolumeSampleVolumes, samplesWithSimulatedSamples, resolvedAliquotOptions, aliquotTests,
		sampleVolumeAboveRequestedVolumeRequestedVolumes, sampleVolumeAboveRequestedVolumeInputs,
		sampleVolumeAboveRequestedVolumeTest, initialSampleOrContainerPackets, aliquotOptions, requiredAliquotContainers,
		resolvedAliquotOptionsManualPreparation, simulatedSamples, newCache, sampleCacheFields, containerCacheFields,
		modelSampleCacheFields, modelContainerCacheFields, sampleContainerCalibrationFields, sampleFields, modelFields,
		containerFields, containerModelFields, updatedCache, inputSampleOrContainerPackets, samplesToAliquot
	},

	(* --- Setup our user specified options and cache --- *)

	(* need to call SafeOptions; this will ONLY make a difference in the shared resolveExperimentFillToVolumeOptions function where it doesn't pass the hidden options down *)
	safeOptions = Last[ExpandIndexMatchedInputs[ExperimentFillToVolume, {mySamples, myVolumes}, SafeOptions[ExperimentFillToVolume, myOptions]]];

	(* determine the requested return value from the function *)
	outputSpecification = Lookup[ToList[myResolutionOptions], Output, {}];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* pull out the Cache and EnableSamplePreparation options *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* pull out the Name *)
	name = Lookup[safeOptions, Name];

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Object[Protocol, FillToVolume, name]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "FillToVolume protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name,_String],
		Test["If specified, Name is not already a FillToVolume object name:",
			validNameQ,
			True
		],
		Null
	];

	(* pull out the sample or container packets (based on whether the input was a sample or container) *)
	initialSampleOrContainerPackets = Map[
		fetchPacketFromCache[Download[#, Object, Simulation -> simulation], inheritedCache]&,
		mySamples
	];

	(* Create a list of larger containers for resolveAliquotOptions *)
	(* where a larger container is required to fulfill the requested volume *)
	{samplesToAliquot, requiredAliquotContainers} = Transpose[MapThread[Function[{sampleOrContainerPacket, requestedFillVolume ,destinationWell},
		Module[{containerPacket, containerModelPacket, maxVolume, samplePacket, sampleModelPacket, aliquotContainer},
			(* Determine the container of the input sample or container *)
			containerPacket = If[MatchQ[sampleOrContainerPacket, ObjectP[Object[Container]]],
				sampleOrContainerPacket,
				fetchPacketFromCache[Lookup[sampleOrContainerPacket, Container], inheritedCache]
			];

			(* Find the model for the container *)
			containerModelPacket = fetchPacketFromCache[Download[Lookup[containerPacket, Model, Simulation -> simulation], Object], inheritedCache];

			(* Find the MaxVolume for the model *)
			maxVolume = Lookup[containerModelPacket, MaxVolume];

			(* If the requested volume is larger than MaxVolume, transfer is required, return a larger container *)
			If[maxVolume < requestedFillVolume,
				samplePacket = Which[
					MatchQ[sampleOrContainerPacket, ObjectP[Object[Sample]]], sampleOrContainerPacket,
					MatchQ[sampleOrContainerPacket, ObjectP[Object[Container]]], fetchPacketFromCache[LastOrDefault[SelectFirst[Lookup[sampleOrContainerPacket, Contents], MatchQ[#[[1]], destinationWell]&, Null]], inheritedCache],
					True, Null
				];

				(* figure out the sample and container model packets *)
				sampleModelPacket = If[NullQ[samplePacket],
					Null,
					fetchPacketFromCache[Download[Lookup[samplePacket, Model], Object], inheritedCache]
				];

				(* Determine the preferred container. *)
				aliquotContainer = If[NullQ[sampleModelPacket],
					PreferredContainer[requestedFillVolume],
					PreferredContainer[Lookup[sampleModelPacket, Object], requestedFillVolume]
				];

				(* Return the sample to aliquot and its target container. *)
				{Lookup[samplePacket, Object], aliquotContainer},

				(* Otherwise, the current container is large enough, return the Object and null for aliquot amount and container.*)
				{Lookup[sampleOrContainerPacket, Object], Null}
			]
		]],

		(* MapThread over initialSampleOrContainerPackets and input volumes *)
		{initialSampleOrContainerPackets, myVolumes, Lookup[safeOptions, DestinationWell]}
	]];

	(* Create a list of options to pass to resolveAliquotOptions *)
	aliquotOptions = {
		Aliquot -> ConstantArray[Automatic, Length[mySamples]],
		AliquotSampleLabel -> ConstantArray[Automatic, Length[mySamples]],
		AliquotAmount -> ConstantArray[Automatic, Length[mySamples]],
		TargetConcentration -> ConstantArray[Automatic, Length[mySamples]],
		TargetConcentrationAnalyte -> ConstantArray[Automatic, Length[mySamples]],
		AssayVolume -> ConstantArray[Automatic, Length[mySamples]],
		AliquotContainer -> ConstantArray[Automatic, Length[mySamples]],
		DestinationWell -> ConstantArray[Automatic, Length[mySamples]],
		ConcentratedBuffer -> ConstantArray[Automatic, Length[mySamples]],
		BufferDilutionFactor -> ConstantArray[Automatic, Length[mySamples]],
		BufferDiluent -> ConstantArray[Automatic, Length[mySamples]],
		AssayBuffer -> ConstantArray[Automatic, Length[mySamples]],
		AliquotSampleStorageCondition -> ConstantArray[Automatic, Length[mySamples]],
		ConsolidateAliquots -> Automatic,
		AliquotPreparation -> Automatic (* Note: This resolves to Robotic, which is not capable of transferring "All". *)
	};

	(* Resolve Aliquot Options for Samples, with a RequiredAliquotContainer where a pre-transfer is required *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentFillToVolume,
			samplesToAliquot,
			samplesToAliquot,
			aliquotOptions,
			RequiredAliquotContainers-> requiredAliquotContainers,
			RequiredAliquotAmounts -> Null,
			AllowSolids -> True,
			Cache -> inheritedCache,
			Simulation -> simulation,
			Output -> {Result,Tests}
		],
		{
			resolveAliquotOptions[
				ExperimentFillToVolume,
				samplesToAliquot,
				samplesToAliquot,
				aliquotOptions,
				RequiredAliquotContainers -> requiredAliquotContainers,
				RequiredAliquotAmounts -> Null,
				AliquotWarningMessage -> "because MaxVolume for the current container(s) is less than the requested fill volume(s). Where the automatic aliquoting is undesired, either transfer the sample to a larger container or decrease the fill volume.",
				AllowSolids -> True,
				Cache -> inheritedCache,
				Simulation -> simulation
			],
			{}
		}
	];

	(* Replace Preparation rule with Preparation -> Manual as it's the only method that can handle transferring All *)
	resolvedAliquotOptionsManualPreparation = resolvedAliquotOptions /. (Preparation -> Robotic) -> (Preparation -> Manual);

	(* If automatic aliquoting will be performed, then the samples post-aliquot need to be simulated and the cache updated *)
	If[!MatchQ[requiredAliquotContainers, {Null...}],
		(* To simulate the samples from aliquoting, call resolveSamplePrepOptionsNew (which does not return AliquotOptions but does return its simulation *)
		{samplesWithSimulatedSamples, updatedSimulation} = resolveSamplePrepOptionsNew[ExperimentFillToVolume, mySamples, resolvedAliquotOptionsManualPreparation, Cache -> inheritedCache, Simulation -> simulation, Output -> Result][[{1,3}]];
		simulatedSamples = PickList[samplesWithSimulatedSamples, requiredAliquotContainers, ObjectP[Model[Container]]];

		(* get the cache fields for Object[Sample] and Model[Sample] (and Object[Container and Model[Container]) *)
		sampleCacheFields = Sequence @@ {SamplePreparationCacheFields[Object[Sample], Format -> Sequence], UltrasonicIncompatible, RequestedResources};
		containerCacheFields = Sequence @@ {SamplePreparationCacheFields[Object[Container], Format -> Sequence], UltrasonicIncompatible, RequestedResources};
		modelSampleCacheFields = Sequence @@ {SamplePreparationCacheFields[Model[Sample], Format -> Sequence], UltrasonicIncompatible, RequestedResources};
		modelContainerCacheFields = Sequence @@ {SamplePreparationCacheFields[Model[Container], Format -> Sequence], UltrasonicIncompatible, VolumeCalibrations, Precision, RequestedResources};
		sampleContainerCalibrationFields = Packet[Container[Model][VolumeCalibrations][{Name, Anomalous, Deprecated, DeveloperObject, CalibrationFunction, CalibrationStandardDeviationFunction, CalibrationDistributionFunction, FitAnalysis, DateCreated, LiquidLevelDetectorModel}]];

		(* get the Object[Sample], Model[Sample], Object[Container], and Model[Container] fields I need *)
		sampleFields = Packet[sampleCacheFields, containerCacheFields];
		modelFields = Packet[Model[{modelSampleCacheFields, modelContainerCacheFields}]];
		containerFields = Packet[Container[{containerCacheFields}]];
		containerModelFields = Packet[Container[Model][{modelContainerCacheFields}]];

		newCache = Quiet[Download[simulatedSamples, {sampleFields, modelFields, containerFields, containerModelFields, 	sampleContainerCalibrationFields}, Simulation -> updatedSimulation, Cache -> inheritedCache], {Download::FieldDoesntExist}];
		updatedCache = FlattenCachePackets[{inheritedCache, newCache}],

		(* Otherwise, no simulation nor cache updating is needed *)
		samplesWithSimulatedSamples = mySamples;
		simulatedSamples = {};
		newCache = {};
		updatedSimulation = simulation;
		updatedCache = inheritedCache
	];

	(* pull out the sample or container packets (based on whether the input was a sample or container) *)
	sampleOrContainerPackets = Map[
		fetchPacketFromCache[#, updatedCache]&,
		samplesWithSimulatedSamples
	];

	(* pull out the sample or container packets (based on whether the input was a sample or container) *)
	inputSampleOrContainerPackets = Map[
		fetchPacketFromCache[#, updatedCache]&,
		mySamples
	];

	sampleOrContainerModelPackets = Map[
		fetchPacketFromCache[Download[Lookup[#, Model], Object], updatedCache]&,
		sampleOrContainerPackets
	];

	(*--- jumping _straight_ into the big MapThread; all the other options are going to get checked in ExperimentTransfer anyway ---*)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFillToVolume, safeOptions];

	{
		resolvedDestinationWell,
		resolvedMethod,
		resolvedSolvent,
		resolvedTolerance,
		resolvedMaxTolerance,
		firstTransferVolumes,
		maxVolumes,
		allSamplePackets,
		resolvedLiquidLevelDetectors,
		currentSampleVolumes,
		missingDestinationWellErrors,
		sampleNotInPositionErrors,
		emptyContainerErrors,
		incompatibleMethodErrors,
		solventDefaultedToWaterWarnings,
		ultrasonicIncompatibleSampleErrors,
		ultrasonicIncompatibleContainerErrors,
		toleranceTooSmallErrors,
		volumetricWrongVolumeErrors,
		volumetricTooLargeVolumeErrors,
		sampleVolumeAboveRequestedVolumeErrors
	} = Transpose[MapThread[
		Function[{sampleOrContainerPacket, volume, options, sampleOrContainerModelPacket, inputSampleOrContainerPacket},
			Module[{specifiedDestinationWell, destinationWell, missingDestinationWellError, sampleNotInPositionError,
				emptyContainerError, specifiedMethod, method, requiredMethod, incompatibleMethodError, samplePacket,
				containerPacket, expectedSolvent,
				specifiedSolvent, solventDefaultedToWaterWarning, solvent, solventPacket, specifiedTolerance, specifiedGraduationFilling,
				ultrasonicIncompatibleSampleError, ultrasonicIncompatibleContainerError, sampleModelPacket,
				containerModelPacket, allVolumeCalibrationPackets, volumeCalibrationPackets, mostRecentDateCreated,
				volumeCalibrationPacketToUse, fit, volumePureFunction, ultrasonicDistribution, maxTolerance,
				tolerance, toleranceTooSmallError, firstTransferVolume, currentSampleVolume, maxVolume,
				volumetricWrongVolumeError, volumetricTooLargeVolumeError, specifiedLiquidLevelDetector, liquidLevelDetector,
				preRoundedFirstTransferVolume, sampleVolumeAboveRequestedVolumeError},

				(* set the error checking variables now*)
				{
					missingDestinationWellError,
					sampleNotInPositionError,
					emptyContainerError,
					incompatibleMethodError,
					solventDefaultedToWaterWarning,
					ultrasonicIncompatibleSampleError,
					ultrasonicIncompatibleContainerError,
					toleranceTooSmallError,
					volumetricWrongVolumeError,
					volumetricTooLargeVolumeError,
					sampleVolumeAboveRequestedVolumeError
				} = {False, False, False, False, False, False, False, False, False, False, False};

				(* pull out the specified options *)
				{
					specifiedDestinationWell,
					specifiedMethod,
					specifiedSolvent,
					specifiedTolerance,
					specifiedLiquidLevelDetector,
					specifiedGraduationFilling
				} = Lookup[options, {DestinationWell, Method, Solvent, Tolerance, LiquidLevelDetector, GraduationFilling}];

				(* determine if there is going to be an error for resolving DestinationWell option; this will happen if we were given a container, DestinationWell is unspecified, and there are multiple positions*)
				missingDestinationWellError = And[
					MatchQ[specifiedDestinationWell, Automatic],
					MatchQ[sampleOrContainerPacket, ObjectP[Object[Container]]],
					Length[Lookup[sampleOrContainerModelPacket, Positions]] =!= 1
				];

				(* actually determine the DestinationWell option; if the MissingDestinationWell message was thrown, then automatically set to A1 *)
				destinationWell = Which[
					Not[MatchQ[specifiedDestinationWell, Automatic]], specifiedDestinationWell,
					missingDestinationWellError, "A1",
					MatchQ[sampleOrContainerPacket, ObjectP[Object[Sample]]], Lookup[sampleOrContainerPacket, Position],
					(* this is if we are in a container, just pick the first position of the model *)
					True, Lookup[First[Lookup[sampleOrContainerModelPacket, Positions]], Name]
				];

				(* make sure that if DestinationWell was specified that the sample is actually in that position *)
				(* if we were given a container then it is going to be a False no matter what*)
				sampleNotInPositionError = MatchQ[sampleOrContainerPacket, ObjectP[Object[Sample]]] && Not[MatchQ[Lookup[sampleOrContainerPacket, Position], destinationWell]];

				(* make sure the specified container/position is not empty; in that case we need to use Transfer and not FillToVolume *)
				(* if we already threw the SampleNotInDestinationWell or MissingDestinationWell messages then DON'T throw this one here since they might both get thrown and that is redundant for the user *)
				emptyContainerError = If[MatchQ[sampleOrContainerPacket, ObjectP[simulatedSamples]],
					(* If the sample is a simulated sample, look instead at parent sample (prior to aliquoting) *)
					And[
						MatchQ[inputSampleOrContainerPacket, ObjectP[Object[Container]]],
						Not[MemberQ[Lookup[inputSampleOrContainerPacket, Contents][[All, 1]], destinationWell]],
						Not[missingDestinationWellError],
						Not[sampleNotInPositionError]
					],
					And[
						MatchQ[sampleOrContainerPacket, ObjectP[Object[Container]]],
						Not[MemberQ[Lookup[sampleOrContainerPacket, Contents][[All, 1]], destinationWell]],
						Not[missingDestinationWellError],
						Not[sampleNotInPositionError]
					]
				];

				(* get what the method has to be (i.e., if you're in a volumetric flask, it has to be Volumetric, and if not it has to be Ultrasonic) *)
				requiredMethod = If[MatchQ[sampleOrContainerPacket, ObjectP[Object[Container, Vessel, VolumetricFlask]]] || MatchQ[Lookup[sampleOrContainerPacket, Container], ObjectP[Object[Container, Vessel, VolumetricFlask]]],
					Volumetric,
					Ultrasonic
				];

				(* resolve the method option; if we're in a Volumetric flask then it's Volumetric; otherwise it's Ultrasonic *)
				method = If[MatchQ[specifiedMethod, Automatic],
					requiredMethod,
					specifiedMethod
				];

				(* flip the error switch if the required method doesn't match the specified method *)
				incompatibleMethodError = Not[MatchQ[method, requiredMethod]];

				(* figure out the sample and container packets but actually *)
				samplePacket = Which[
					MatchQ[sampleOrContainerPacket, ObjectP[Object[Sample]]], sampleOrContainerPacket,
					emptyContainerError, Null,
					True, fetchPacketFromCache[LastOrDefault[SelectFirst[Lookup[sampleOrContainerPacket, Contents], MatchQ[#[[1]], destinationWell]&, Null]], updatedCache]
				];
				containerPacket = If[MatchQ[sampleOrContainerPacket, ObjectP[Object[Container]]],
					sampleOrContainerPacket,
					fetchPacketFromCache[Lookup[sampleOrContainerPacket, Container], updatedCache]
				];

				(* note that this logic also exists in the resource packets function*)
				(* figure out how much we are going to transfer in.  This is a little tricky because we don't _actually_ know how much we are going to transfer; we just know the final volume *)
				(* still, we have to guess. My algorithm is to subtract the specified volume from the volume of the sample and multiply by 0.9 *)
				(* when we have a solid sample, we then check if we have a density and compute the volume if we do. If not, we divide the mass by 0.997 g/mL and multiply by 1.25 on the assumption
						that the solid sample may take up more space. This logic matches ExperimentTransfer *)
				currentSampleVolume = Which[
					NullQ[samplePacket], 0 Milliliter,
					VolumeQ[Lookup[samplePacket, Volume]], Lookup[samplePacket, Volume],
					MassQ[Lookup[samplePacket, Mass]], If[DensityQ[Lookup[samplePacket, Density]], Lookup[samplePacket, Mass] / Lookup[samplePacket, Density], Lookup[samplePacket, Mass] / (0.997` Gram / Milliliter) * 1.25],
					IntegerQ[Lookup[samplePacket, Count]], Lookup[samplePacket, Count] * Lookup[samplePacket, SolidUnitWeight] * (1 Milliliter / Gram),
					True, 0 Milliliter
				];

				(* flip an error switch if the current sample volume is above the requested volume *)
				sampleVolumeAboveRequestedVolumeError = currentSampleVolume > volume;

				(* get the first transfer volume before we actually pass it to AchievableResolution. This is because we usually want to use RoundingFunction -> Floor *)
				(* However, in the special case where we have 1 Microliter as the transfer amount, having RoundingFunction -> Floor changes that to 0.998 Nanoliter so we need to use RoundingFunction -> Round there because 1 Microliter is our minimum allowed *)
				preRoundedFirstTransferVolume = Max[0.9 * (volume - currentSampleVolume), 1 Microliter];

				(* calculate the first transfer volume; want to use AchievableResolution so that ExperimentTransfer is happy *)
				(* using Floor just in case the rounding up overshoots where we want *)
				(* also make sure we don't have a negative value *)
				firstTransferVolume = Quiet[AchievableResolution[preRoundedFirstTransferVolume, All, RoundingFunction -> If[preRoundedFirstTransferVolume == 1 Microliter, Round, Floor]], Warning::AmountRounded];

				(* figure out the sample and container model packets *)
				sampleModelPacket = If[NullQ[samplePacket],
					Null,
					fetchPacketFromCache[Download[Lookup[samplePacket, Model], Object], updatedCache]
				];
				containerModelPacket = fetchPacketFromCache[Download[Lookup[containerPacket, Model], Object], updatedCache];

				(* pull out the MaxVolume *)
				maxVolume = Lookup[containerModelPacket, MaxVolume];

				(* flip an error switch if MaxVolume doesn't match the specified volume if we are doing Method -> Volumetric and GraduationFilling is not specified *)
				volumetricWrongVolumeError = MatchQ[method, Volumetric] && Not[TrueQ[maxVolume == volume]] && Not[TrueQ[specifiedGraduationFilling]];

				(* flip an error switch if GraduationFilling is true, but the specified volume exceeds the MaxVolume of the container *)
				volumetricTooLargeVolumeError = MatchQ[method,Volumetric] && Not[LessEqualQ[volume, maxVolume]] && TrueQ[specifiedGraduationFilling];

				(* get the volume calibration packets for the container model *)
				allVolumeCalibrationPackets = Which[
					NullQ[containerModelPacket], {},
					Not[MatchQ[Lookup[containerModelPacket, VolumeCalibrations], {ObjectP[Object[Calibration, Volume]]..}]], {},
					True, fetchPacketFromCache[Download[#, Object], updatedCache]& /@ Lookup[containerModelPacket, VolumeCalibrations]
				];

				(* remove the calibration packets that are Anomalous, Deprecated or DeveloperObject->True *)
				(* also remove and Placeholder calibrations from Maintenance CalibrateVolume*)
				volumeCalibrationPackets = Select[allVolumeCalibrationPackets, Not[TrueQ[Lookup[#, Anomalous]]] && Not[TrueQ[Lookup[#, Deprecated]]] && Not[TrueQ[Lookup[#, DeveloperObject]]] && Not[NullQ[Lookup[#, LiquidLevelDetectorModel]]] && Not[StringContainsQ[Lookup[#, Name, ""] /. Null -> "", "Placeholder calibration for " ~~ __ ~~ uuid_ /; MatchQ[uuid, UUIDP]]]&];

				(* pick the most recent volume calibration packet *)
				mostRecentDateCreated = Max[Cases[Lookup[volumeCalibrationPackets, DateCreated, {}], _?DateObjectQ]];
				volumeCalibrationPacketToUse = SelectFirst[volumeCalibrationPackets, MatchQ[Lookup[#, DateCreated], mostRecentDateCreated]&, Null];

				(* resolve the LiquidLevelDetectorModel option *)
				liquidLevelDetector = Which[
					MatchQ[specifiedLiquidLevelDetector, ObjectP[]], specifiedLiquidLevelDetector,
					NullQ[volumeCalibrationPacketToUse], Null,
					True, Download[Lookup[volumeCalibrationPacketToUse, LiquidLevelDetectorModel, Null], Object]
				];

				(* get the fit object that created this volume calibration, and the pure function we get out *)
				{fit, volumePureFunction} = If[NullQ[volumeCalibrationPacketToUse],
					{Null, Null},
					{Download[Lookup[volumeCalibrationPacketToUse, FitAnalysis], Object], Lookup[volumeCalibrationPacketToUse, CalibrationDistributionFunction]}
				];

				(* use the fit object and the final volume to calculate the distribution of expected volume if we're doing this ultrasonically *)
				(* need to Quiet this because somehow this is (sort of?) being thrown and caught by the testing framework but the message doesn't actuallyt surface *)
				ultrasonicDistribution = If[NullQ[fit],
					Null,
					Quiet[InversePrediction[fit, volume], Solve::dinv]
				];

				(* figure out the precision of the sample *)
				(* if we're doing Ultrasonic, then use the values we have gotten from the calibration object *)
				(* if we're doing Volumetric, then we need to pull out the Precision field *)
				maxTolerance = Which[
					MatchQ[method, Ultrasonic] && NullQ[fit], Null,
					MatchQ[method, Ultrasonic], SafeRound[StandardDeviation[volumePureFunction[Mean[ultrasonicDistribution]]], 0.1 Microliter],
					True, Lookup[containerModelPacket, Precision]
				];

				(* resolve the Tolerance option; if we have Volumetric then set it to whatever the maxTolerance is since it doesn't really matter anyway *)
				(* if we have Ultrasonic, then pick the larger of 0.5% and the maxTolerance of the instrument *)
				tolerance = Which[
					Not[MatchQ[specifiedTolerance, Automatic]], specifiedTolerance,
					(* if we have a Null tolerance here somehow, just go with 0.5 Percent for us here *)
					MatchQ[method, Volumetric], maxTolerance,
					(* sometimes the calibration functions act screwy and we don't get a number out of maxTolerance. Assume 0.5 % for now but definitely revisit this *)
					NullQ[maxTolerance] || !MatchQ[maxTolerance,_Quantity], 0.5 Percent,
					(* need to use UnitScale because otherwise it will have something like 50.%mL which is obviously silly and not correct *)
					(* if the instrument can't actually get within 0.5% then we will go with what the instrument can do*)
					True, Max[maxTolerance, UnitScale[0.5 Percent * volume]]
				] /. {Null -> UnitScale[0.5 Percent * volume]};

				(* flip the error switch if the tolerance is less than the maximum possible *)
				(* if we have no MaxTolerance, then this can be False *)
				(* for reasons that I'm not entirely sure, maxTolerance can resolve from the above StandardDeviation/SafeRound call nondeterministically, and so if you use a past protocol as a template, something like 0.7049 mL vs 0.7048 mL will cause an error to be thrown erroneously *)
				(* thus, giving myself a bit of buffer here (0.5%), and so only throw the error if the resolved tolerance is less than 0.995 times the maximum (if it is in that buffer area just say it's fine) *)
				toleranceTooSmallError = Which[
					NullQ[maxTolerance], False,
					VolumeQ[tolerance], tolerance < 0.995 * maxTolerance,
					True, (tolerance * volume) < 0.995 * maxTolerance
				];

				(* pull out the solvent value of the sample packet *)
				expectedSolvent = If[NullQ[samplePacket],
					Null,
					Lookup[samplePacket, Solvent,Null]
				];

				(* resolve the solvent option, and flip the warning switch if we don't have anything to resolve to *)
				{solvent, solventDefaultedToWaterWarning} = Which[
					Not[MatchQ[specifiedSolvent, Automatic]], {specifiedSolvent, False},
					MatchQ[expectedSolvent, ObjectP[Model[Sample]]], {expectedSolvent, False},
					True, {Model[Sample, "Milli-Q water"], True}
				];

				(* get the solvent packet *)
				solventPacket = fetchPacketFromCache[Download[solvent, Object], updatedCache];

				(* get whether the sample or solvent are ultrasonic incompatible but Method is Ultrasonic *)
				ultrasonicIncompatibleSampleError = And[
					MatchQ[method, Ultrasonic],
					MemberQ[Lookup[Cases[{samplePacket, solventPacket}, PacketP[]], UltrasonicIncompatible], True]
				];

				(* get whether the container is ultrasonic incompatible but the Method is Ultrasonic *)
				ultrasonicIncompatibleContainerError = And[
					MatchQ[method, Ultrasonic],
					TrueQ[Lookup[containerPacket, UltrasonicIncompatible]] || NullQ[volumeCalibrationPacketToUse]
				];

				(* return everything *)
				{
					destinationWell,
					method,
					solvent,
					tolerance,
					maxTolerance,
					firstTransferVolume,
					maxVolume,
					samplePacket,
					liquidLevelDetector,
					currentSampleVolume,
					missingDestinationWellError,
					sampleNotInPositionError,
					emptyContainerError,
					incompatibleMethodError,
					solventDefaultedToWaterWarning,
					ultrasonicIncompatibleSampleError,
					ultrasonicIncompatibleContainerError,
					toleranceTooSmallError,
					volumetricWrongVolumeError,
					volumetricTooLargeVolumeError,
					sampleVolumeAboveRequestedVolumeError
				}

			]
		],
		{sampleOrContainerPackets, myVolumes, mapThreadFriendlyOptions, sampleOrContainerModelPackets, inputSampleOrContainerPackets}
	]];

	(* --- Throw the messages and generate the tests ---*)

	(* figure out if we have duplicate samples because we can't have those *)
	talliedSamplePackets = Tally[allSamplePackets];
	replicateSamplePackets = Cases[talliedSamplePackets, {packet_, GreaterP[1]} :> packet];

	(* get the positions of the replicate samples *)
	replicateSamplePositions = Position[allSamplePackets, Alternatives @@ replicateSamplePackets, {1}];

	(* get the invalid inputs that come with replicate*)
	replicateInvalidInputs = DeleteDuplicates[Extract[mySamples, replicateSamplePositions]];

	(* throw a message and make a test if we have duplicate samples in *)
	duplicateSampleInputs = If[messages && Not[MatchQ[replicateInvalidInputs, {}]],
		(
			Message[Error::ReplicateFillToVolumeSamples, ObjectToString[replicateInvalidInputs, Cache -> updatedCache]];
			replicateInvalidInputs
		),
		replicateInvalidInputs
	];
	duplicateSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},

			(* generate the tests; only one will get actually created *)
			failingTest = If[MatchQ[duplicateSampleInputs, {}],
				Nothing,
				Test["The provided sample(s) or container(s) do not contain replicates:", False, True]
			];
			passingTest = If[MatchQ[duplicateSampleInputs, {}],
				Test["The provided sample(s) or container(s) do not contain replicates:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];


	(* throw a message and make at test for if DestinationWell is specified and not able to be resolved *)
	missingDestinationWellOptions = If[messages && MemberQ[missingDestinationWellErrors, True],
		(
			Message[Error::MissingDestinationWell, ObjectToString[PickList[mySamples, missingDestinationWellErrors], Cache -> updatedCache]];
			{DestinationWell}
		),
		{}
	];
	missingDestinationWellTest = If[gatherTests,
		Module[{missingDestWellInputs, failingTest, passingTest},

			(* get the actual failing inputs *)
			missingDestWellInputs = PickList[mySamples, missingDestinationWellErrors];

			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[missingDestWellInputs] == 0,
				Nothing,
				Test["The provided containers " <> ObjectToString[missingDestWellInputs, Cache -> updatedCache] <> " have DestinationWell specified, or only one position allowed:", True, False]
			];

			passingTest = If[Length[missingDestWellInputs] == 0,
				Test["All provided containers have DestinationWell specified, or only one position allowed:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* throw a message/make a test for if the sample is not actually in the specified destination well*)
	sampleNotInPositionOptions = If[messages && MemberQ[sampleNotInPositionErrors, True],
		(
			Message[Error::SampleNotInDestinationWell, ObjectToString[PickList[mySamples, sampleNotInPositionErrors], Cache -> updatedCache], PickList[resolvedDestinationWell, sampleNotInPositionErrors]];
			{DestinationWell}
		),
		{}
	];
	sampleNotInPositionTest = If[gatherTests,
		Module[{sampleNotInPositionInputs, sampleNotInPositionWells, failingTest, passingTest},

			(* get the actual failing inputs *)
			sampleNotInPositionInputs = PickList[mySamples, sampleNotInPositionErrors];
			sampleNotInPositionWells = PickList[resolvedDestinationWell, sampleNotInPositionErrors];

			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[sampleNotInPositionInputs] == 0,
				Nothing,
				Test["The provided sample(s) " <> ObjectToString[sampleNotInPositionInputs, Cache -> updatedCache] <> " are in the specified DestinationWell(s) " <> ObjectToString[sampleNotInPositionWells] <> ":", True, False]
			];

			passingTest = If[Length[sampleNotInPositionInputs] == 0,
				Test["All specified samples are in the specified DestinationWell:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* throw a message/make a test for if the container is empty *)
	emptyContainerOptions = If[messages && MemberQ[emptyContainerErrors, True],
		(
			Message[Error::FillToVolumeEmptyPosition, PickList[resolvedDestinationWell, emptyContainerErrors], ObjectToString[PickList[mySamples, emptyContainerErrors], Cache -> updatedCache]];
			{DestinationWell}
		),
		{}
	];
	emptyContainerTest = If[gatherTests,
		Module[{emptyContainerContainers, emptyPositionWells, failingTest, passingTest},

			(* get the actual failing inputs *)
			emptyContainerContainers = PickList[mySamples, emptyContainerErrors];
			emptyPositionWells = PickList[resolvedDestinationWell, emptyContainerErrors];

			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[emptyContainerContainers] == 0,
				Nothing,
				Test["The provided container(s) " <> ObjectToString[emptyContainerContainers, Cache -> updatedCache] <> " are not empty in position(s) " <> ObjectToString[emptyPositionWells] <> ":", True, False]
			];

			passingTest = If[Length[sampleNotInPositionInputs] == 0,
				Test["All provided container(s) are not empty in their specified DestinationWell:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* throw a message/make a test for if the method does not match the current container *)
	incompatibleMethodOptions = If[messages && MemberQ[incompatibleMethodErrors, True],
		(
			Message[Error::FillToVolumeIncompatibleMethod, ObjectToString[PickList[mySamples, incompatibleMethodErrors], Cache -> updatedCache]];
			{Method}
		),
		{}
	];
	incompatibleMethodTest = If[gatherTests,
		Module[{incompatibleMethodSamples, failingTest, passingTest},

			(* get the actual failing inputs *)
			incompatibleMethodSamples = PickList[mySamples, incompatibleMethodErrors];

			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[incompatibleMethodSamples] == 0,
				Nothing,
				Test["The specified Method(s) for " <> ObjectToString[incompatibleMethodSamples, Cache -> updatedCache] <> " matches the current container of these samples:", True, False]
			];

			passingTest = If[Length[incompatibleMethodSamples] == 0,
				Test["All specified Method(s) match the current container of the sample(s):", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* throw a warning/make a test for if we had to default Solvent *)
	If[messages && MemberQ[solventDefaultedToWaterWarnings, True] && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::FillToVolumeSolventDefaulted, ObjectToString[PickList[mySamples, solventDefaultedToWaterWarnings], Cache -> updatedCache]]
	];
	solventDefaultedToWaterTests = If[gatherTests,
		Module[{solventDefaultedSamples, failingTest, passingTest},

			(* get the actual failing inputs *)
			solventDefaultedSamples = PickList[mySamples, solventDefaultedToWaterWarnings];

			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[solventDefaultedSamples] == 0,
				Nothing,
				Warning["The Solvent option was specified or could be resolved from the Solvent field of the following sample(s) (or contents of the container(s)): " <> ObjectToString[solventDefaultedSamples, Cache -> updatedCache] <> ":", True, False]
			];

			passingTest = If[Length[solventDefaultedSamples] == 0,
				Warning["The Solvent option was specified or could be resolved from the Solvent field of all sample(s) (or contents of the container(s)): ", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* throw a message/make a test for if the sample or solvent are UltrasonicIncompatible *)
	ultrasonicIncompatibleSampleOptions = If[messages && MemberQ[ultrasonicIncompatibleSampleErrors, True],
		(
			Message[Error::FillToVolumeUltrasonicIncompatibleSample, ObjectToString[PickList[mySamples, ultrasonicIncompatibleSampleErrors], Cache -> updatedCache]];
			{Method, Solvent}
		),
		{}
	];
	ultrasonicIncompatibleSampleTest = If[gatherTests,
		Module[{ultrasonicIncompatibleSamples, failingTest, passingTest},

			(* get the actual failing inputs *)
			ultrasonicIncompatibleSamples = PickList[mySamples, ultrasonicIncompatibleSampleErrors];

			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[ultrasonicIncompatibleSamples] == 0,
				Nothing,
				Test["If Method -> Ultrasonic, the following sample(s) (or their corresponding Solvent) are not UltrasonicIncompatible:" <> ObjectToString[ultrasonicIncompatibleSamples, Cache -> updatedCache] <> ":", True, False]
			];

			passingTest = If[Length[ultrasonicIncompatibleSamples] == 0,
				Test["For all sample(s) whose Method -> Ultrasonic, the sample(s) and Solvent(s) are not UltrasonicIncompatible:" <> ObjectToString[ultrasonicIncompatibleSamples, Cache -> updatedCache] <> ":", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* throw a message/make a test for if the container is UltrasonicIncompatible *)
	ultrasonicIncompatibleContainerOptions = If[messages && MemberQ[ultrasonicIncompatibleContainerErrors, True],
		(
			Message[Error::FillToVolumeUltrasonicIncompatibleContainer, ObjectToString[PickList[mySamples, ultrasonicIncompatibleContainerErrors], Cache -> updatedCache]];
			{Method}
		),
		{}
	];
	ultrasonicIncompatibleContainerTest = If[gatherTests,
		Module[{ultrasonicIncompatibleContainers, failingTest, passingTest},

			(* get the actual failing inputs *)
			ultrasonicIncompatibleContainers = PickList[mySamples, ultrasonicIncompatibleContainerErrors];

			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[ultrasonicIncompatibleContainers] == 0,
				Nothing,
				Test["If Method -> Ultrasonic, the container of the following sample(s) (or the container(s) themselves) can have their volumes measured ultrasonically:" <> ObjectToString[ultrasonicIncompatibleContainers, Cache -> updatedCache] <> ":", True, False]
			];

			passingTest = If[Length[ultrasonicIncompatibleContainers] == 0,
				Test["For all sample(s) whose Method -> Ultrasonic, the container(s) can have their volumes measured ultrasonically:" <> ObjectToString[ultrasonicIncompatibleContainers, Cache -> updatedCache] <> ":", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* throw a message/make a test if the tolerance is less than the theoretical maximum of specified Method *)
	toleranceTooSmallOptions = If[messages && MemberQ[toleranceTooSmallErrors, True],
		(
			Message[Error::ToleranceTooSmall, ObjectToString[PickList[mySamples, toleranceTooSmallErrors], Cache -> updatedCache], ObjectToString[PickList[resolvedMaxTolerance, toleranceTooSmallErrors]]];
			{Tolerance}
		),
		{}
	];
	toleranceTooSmallTest = If[gatherTests,
		Module[{toleranceTooSmallSamples, toleranceTooSmallMax, failingTest, passingTest},

			(* get the actual failing inputs *)
			toleranceTooSmallSamples = PickList[mySamples, toleranceTooSmallErrors];
			toleranceTooSmallMax = PickList[resolvedMaxTolerance, toleranceTooSmallErrors];


			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[toleranceTooSmallSamples] == 0,
				Nothing,
				Test["The specified Tolerance for " <> ObjectToString[toleranceTooSmallSamples, Cache -> updatedCache] <> " is greater than or equal to the minimum allowed Tolerance for the specified container and volume (" <> ObjectToString[toleranceTooSmallMax] <> "):", True, False]
			];

			passingTest = If[Length[toleranceTooSmallSamples] == 0,
				Test["The specified Tolerance for all inputs is  is greater than or equal to the minimum allowed Tolerance for the specified containers and volumes:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* get the actual failing inputs *)
	sampleVolumeAboveRequestedVolumeSamples = PickList[mySamples, sampleVolumeAboveRequestedVolumeErrors];
	sampleVolumeAboveRequestedVolumeSampleVolumes = PickList[currentSampleVolumes, sampleVolumeAboveRequestedVolumeErrors];
	sampleVolumeAboveRequestedVolumeRequestedVolumes = PickList[myVolumes, sampleVolumeAboveRequestedVolumeErrors];

	(* throw a message/make a test if the specified volume is less than the sample volume *)
	sampleVolumeAboveRequestedVolumeInputs = If[messages && MemberQ[sampleVolumeAboveRequestedVolumeErrors, True],
		(
			Message[
				Error::SampleVolumeAboveRequestedVolume,
				ObjectToString[sampleVolumeAboveRequestedVolumeSamples, Cache -> updatedCache],
				ObjectToString[sampleVolumeAboveRequestedVolumeSampleVolumes, Cache -> updatedCache],
				ObjectToString[sampleVolumeAboveRequestedVolumeRequestedVolumes, Cache -> updatedCache]
			];
			sampleVolumeAboveRequestedVolumeSamples
		),
		sampleVolumeAboveRequestedVolumeSamples
	];
	sampleVolumeAboveRequestedVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},

			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[sampleVolumeAboveRequestedVolumeSamples] == 0,
				Nothing,
				Test["The current Volume for " <> ObjectToString[sampleVolumeAboveRequestedVolumeSamples, Cache -> inheritedCache] <> " (" <> ObjectToString[sampleVolumeAboveRequestedVolumeSampleVolumes, Cache -> inheritedCache] <> ") is less than the requested volume for these samples (" <> ObjectToString[sampleVolumeAboveRequestedVolumeRequestedVolumes, Cache -> inheritedCache] <> ") :", True, False]
			];

			passingTest = If[Length[sampleVolumeAboveRequestedVolumeSamples] == 0,
				Test["The current Volume for " <> ObjectToString[mySamples, Cache -> inheritedCache] <> " (" <> ObjectToString[currentSampleVolumes, Cache -> inheritedCache] <> ") is less than the requested volume for these samples (" <> ObjectToString[myVolumes, Cache -> inheritedCache] <> ") :", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* get the actual failing inputs *)
	volumetricWrongVolumeSamples = PickList[mySamples, volumetricWrongVolumeErrors];
	volumetricWrongVolumeVolumes = PickList[myVolumes, volumetricWrongVolumeErrors];
	volumetricWrongVolumeMaxVolumes = PickList[maxVolumes, volumetricWrongVolumeErrors];

	(* throw a message/make a test if the specified volume does not match the method *)
	(* don't bother throwing this error message if we threw the error message above because they're redundant*)
	volumetricWrongVolumeOptions = If[messages && MemberQ[volumetricWrongVolumeErrors, True] && Not[MemberQ[sampleVolumeAboveRequestedVolumeErrors, True]],
		(
			Message[Error::VolumetricWrongVolume, ObjectToString[volumetricWrongVolumeSamples, Cache -> updatedCache], ObjectToString[volumetricWrongVolumeVolumes], ObjectToString[volumetricWrongVolumeMaxVolumes]];
			{Method}
		),
		{}
	];
	volumetricWrongVolumeTest = If[gatherTests && Not[MemberQ[sampleVolumeAboveRequestedVolumeErrors, True]],
		Module[{failingTest, passingTest},


			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[volumetricWrongVolumeSamples] == 0,
				Nothing,
				Test["The specified Volume for " <> ObjectToString[volumetricWrongVolumeSamples, Cache -> updatedCache] <> " (" <> ObjectToString[volumetricWrongVolumeVolumes] <> ") is equal to the MaxVolume of the volumetric flask if Method -> Volumetric:", True, False]
			];

			passingTest = If[Length[volumetricWrongVolumeSamples] == 0,
				Test["The specified Volume for " <> ObjectToString[mySamples, Cache -> updatedCache] <> " (" <> ObjectToString[myVolumes] <> ") is equal to the MaxVolume of the volumetric flask if Method -> Volumetric:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* get the actual failing inputs *)
	volumetricTooLargeVolumeSamples = PickList[mySamples, volumetricTooLargeVolumeErrors];
	volumetricTooLargeVolumeVolumes = PickList[myVolumes, volumetricTooLargeVolumeErrors];
	volumetricTooLargeVolumeMaxVolumes = PickList[maxVolumes, volumetricTooLargeVolumeErrors];

	(* throw a message/make a test if the specified volume does not match the method *)
	(* don't bother throwing this error message if we threw the error message above because they're redundant*)
	volumetricTooLargeVolumeOptions = If[messages && MemberQ[volumetricTooLargeVolumeErrors, True] && Not[MemberQ[sampleVolumeAboveRequestedVolumeErrors, True]],
		(
			Message[Error::VolumetricTooLargeVolume, ObjectToString[volumetricTooLargeVolumeSamples, Cache -> inheritedCache], ObjectToString[volumetricTooLargeVolumeVolumes], ObjectToString[volumetricTooLargeVolumeMaxVolumes]];
			{Method}
		),
		{}
	];
	volumetricTooLargeVolumeTest = If[gatherTests && Not[MemberQ[sampleVolumeAboveRequestedVolumeErrors, True]],
		Module[{failingTest, passingTest},


			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[volumetricTooLargeVolumeSamples] == 0,
				Nothing,
				Test["The specified Volume for " <> ObjectToString[volumetricTooLargeVolumeSamples, Cache -> inheritedCache] <> " (" <> ObjectToString[volumetricTooLargeVolumeVolumes] <> ") is less than the MaxVolume of the volumetric flask if Method -> Volumetric and GraduationFilling -> True:", True, False]
			];

			passingTest = If[Length[volumetricTooLargeVolumeSamples] == 0,
				Test["The specified Volume for " <> ObjectToString[mySamples, Cache -> inheritedCache] <> " (" <> ObjectToString[myVolumes] <> ") is less than the MaxVolume of the volumetric flask if Method -> Volumetric and GraduationFilling -> True:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* --- Call ExperimentTransfer to resolve those options --- *)

	(* generate the options for ExperimentTransfer from the ones we have*)
	(* note that we both have the DestinationWell option, and so we need to replace the output with what we already resolved*)
	(* note also that ExperimentTransfer has a Tolerance option that conflicts with our own in ExperimentFillToVolume so be sure to delete that before passing into ExperimentTransfer *)
	(* PassOptions is just so dumb because it returns string keys for options which messes everything up and there is no reason to do that but whatever I'll just implement it myself*)
	sharedOptionsBetweenFtVAndTransfer = Intersection[Keys[SafeOptions[ExperimentFillToVolume]], Keys[SafeOptions[ExperimentTransfer]]];
	sharedOptionsToPass = (# -> Lookup[safeOptions, #])& /@ sharedOptionsBetweenFtVAndTransfer;
	transferOptions = ReplaceRule[
		sharedOptionsToPass,
		{
			SourceContainer -> Lookup[myOptions, SolventContainer],
			SourceLabel -> Lookup[myOptions, SolventLabel],
			SourceContainerLabel -> Lookup[myOptions, SolventContainerLabel],
			DestinationLabel -> Lookup[myOptions, SampleLabel],
			DestinationContainerLabel -> Lookup[myOptions, SampleContainerLabel],
			DestinationWell -> resolvedDestinationWell,
			Tolerance -> Automatic,
			(* don't want to pass the wrong template into the core function; if we pass a FillToVolume template into ExperimentTransfer it gets confused*)
			Template -> Null,
			(* Don't pass the name because if you have a name that is available for ExperimentFillToVolume and not ExperimentTransfer we don't want to throw an error but default is that it will *)
			Name -> Null,
			Simulation -> updatedSimulation
		}
	];

	(* pull out the storage options *)
	{samplesOutStorage, solventStorage} = Lookup[myOptions, {SamplesOutStorageCondition, SolventStorageCondition}];

	(* get the solvents and solvent storage options that correspond to actual samples *)
	solventObjs = Cases[resolvedSolvent, ObjectP[Object[Sample]]];
	solventObjsStorage = PickList[solventStorage, resolvedSolvent, ObjectP[Object[Sample]]];

	(* Check whether the samples out storage condition is OK are ok *)
	{validContainerStorageConditionBool, validContainerStorageConditionTests} = Which[
		MatchQ[solventObjs, {}], {{}, {}},
		gatherTests, ValidContainerStorageConditionQ[solventObjs, solventObjsStorage, Output -> {Result, Tests}, Cache -> updatedCache],
		True, {ValidContainerStorageConditionQ[solventObjs, solventObjsStorage, Output -> Result, Cache -> updatedCache], {}}
	];
	validContainerStorageConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];
	
	(* estimate the requiredSolventVolumes from currentSampleVolumes and myVolumes (totalVolume) so we can feed it to resolvedTransferOptions *)
	(* minimum amount of solvent is set 2 mL in order to allow pipette dropper use with IntermediateContainer beaker if necessary *)
	requiredSolventVolumes = MapThread[
		Function[{estimatedSampleVolume,totalVolume},
			Which[
				MatchQ[(totalVolume-estimatedSampleVolume)*1.1,LessEqualP[2 Milliliter]],
				2 Milliliter,
				
				MatchQ[(totalVolume-estimatedSampleVolume)*1.1,GreaterP[2 Milliliter]],
				(totalVolume-estimatedSampleVolume)*1.1,
				
				True,
				totalVolume (* if required volume cannot be appropriately calculated, set to desired total volume of solution *)
			]
		],
		{currentSampleVolumes,myVolumes}
	];
	
	(* call ExperimentTransfer to resolve the options that are shared*)
	(* Quiet the messages that round the volumes; we don't really care about those and this is not controlled by the user anyway so don't want to surface it*)
	(* Here we call ExperimentTransfer with myVolumes so that we can resolve the resource container properly. *)
	(* In resource packets later, we request our solvent resources based on the total max volumes, to make sure we always have enough solvent to use *)
	(* However, the resource is always put in the resolved SolventContainer, or Transfer's SourceContainer, which is resolved based on the volume of the resource request *)
	(* Using myVolumes here guarantees a large enough SolventContainer *)
	{resolvedTransferOptions, transferResolvingTests} = Quiet[If[gatherTests,
		ExperimentTransfer[resolvedSolvent, samplesWithSimulatedSamples, requiredSolventVolumes,
			ReplaceRule[transferOptions, {
				FillToVolume -> True,
				Preparation -> Manual,
				OptionsResolverOnly -> True,
				Output -> {Options, Tests}
			}]],
		{ExperimentTransfer[resolvedSolvent, samplesWithSimulatedSamples, requiredSolventVolumes,
			ReplaceRule[transferOptions, {
				FillToVolume -> True,
				Preparation -> Manual,
				OptionsResolverOnly -> True,
				Output -> Options
			}]], {}}
	], Warning::RoundedTransferAmount];

	(* grab the options from the resolved transfer options that we actually care about *)
	relevantResolvedTransferOptions = Select[resolvedTransferOptions, MemberQ[Keys[sharedOptionsToPass], First[#]]&];
	
	(* we need to update the resolution of options Tip, TipType, TipMaterial if we are doing FTV to a VolumetricFlask - a pipette dropper (Model[Item, Consumable, "VWR Disposable Transfer Pipet"]) and a Model[Container, Vessel, "20mL Pyrex Beaker"] is used for the small amount of volume needed to reach the graduation mark of the VolFlask *)
	(* Note if you change any of these resolutions, please update QualificationTrainingVolumetricFlask as well *)
	postTransferResolutionInstruments = Lookup[relevantResolvedTransferOptions,Instrument];
	postTransferTipReplaceRules=MapThread[
		Function[{option,updatedValue},
			Module[{transferResolvedOption,updatedOptionValues},
				
				transferResolvedOption = Lookup[relevantResolvedTransferOptions,option];
				
				updatedOptionValues = MapThread[
					If[MatchQ[Lookup[#1,option],Automatic] && MatchQ[#3,Volumetric] && MatchQ[#4,Null|ObjectP[{Object[Container,GraduatedCylinder],Model[Container,GraduatedCylinder]}]],
						updatedValue,
						#2
					]&,
					{
						mapThreadFriendlyOptions,
						transferResolvedOption,
						resolvedMethod,
						postTransferResolutionInstruments
					}
				];
				
				(option->value_)->(option->updatedOptionValues)
			]
		],
		{
			{
				Tips,
				TipType,
				TipMaterial
			},
			{
				Model[Item, Consumable, "id:bq9LA0J1xmBd"], (*Model[Item, Consumable, "VWR Disposable Transfer Pipet"]*)
				Normal,
				Polyethylene
			}
		}
	];
	
	(* introduce IntermediateContainer for FTV to VolFlask based on internal depth of source container and amount of liquid *)
	postTransferSourceContainer = Lookup[resolvedTransferOptions,SourceContainer];

	(* do a second download here to decide if we would like to use an intermediate container for dropper pipette transfer (only do this if we need volumetric flask transfer) *)
	(* this has to happen after transfer resolver since transfer has a complicated logic deciding what source container to use *)
	postTransferSourceContainerInternalDepth = If[MemberQ[resolvedMethod,Volumetric],
		Quiet[Download[postTransferSourceContainer,InternalDepth,Simulation->updatedSimulation],{Download::FieldDoesntExist, Download::NotLinkField}],
		(* we don't need this value so default to Null to avoid another Download *)
		ConstantArray[Null,Length[postTransferSourceContainer]]
	];

	postTransferIntermediateContainerReplaceRules = (IntermediateContainer->x_)->(IntermediateContainer->MapThread[
		Function[{suppliedIntermediateContainer,method,instrument,sourceInternalDepth},
			Switch[{suppliedIntermediateContainer,method,instrument,sourceInternalDepth},
				{Except[Automatic],_,_,_},
					suppliedIntermediateContainer,
				(* If Volumetric and Instrument is a graduated cylinder, use a 20mL beaker as intermediate container*)
				{Automatic,Volumetric,ObjectP[{Object[Container,GraduatedCylinder],Model[Container,GraduatedCylinder]}],_},
					Model[Container, Vessel, "id:kEJ9mqaVPPD8"] (*Model[Container, Vessel, "20mL Pyrex Beaker"]*),
				(* If Volumetric and there is no Instrument and the original source container is too tall (pipette dropper is 155 mm, including bulb), use a 20mL beaker as intermediate container *)
				{Automatic,Volumetric,Null,GreaterP[120 Millimeter]},
				Model[Container, Vessel, "id:kEJ9mqaVPPD8"],
				(* no IntermediateContainer is introduced if internaldepth of source container is reachable by  pipette *)
				{_,_,_,_},
					Null
			]
		],
		{
			Lookup[mapThreadFriendlyOptions,IntermediateContainer],
			resolvedMethod,
			postTransferResolutionInstruments,
			postTransferSourceContainerInternalDepth
		}
	]);
	
	postTransferReplaceRules = Append[postTransferTipReplaceRules,postTransferIntermediateContainerReplaceRules];

	(* --- Unresolvable options checks --- *)

	(* If TransferEnvironment is BSC or GloveBox, Method must be Volumetric *)
	ultrasonicForbiddenEnvironmentQ = MapThread[
		MatchQ[#1, Ultrasonic] && MatchQ[#2, ObjectP[{Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet], Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox]}]]&,
		{resolvedMethod, Lookup[resolvedTransferOptions, TransferEnvironment]}
	];

	(* get the samples where Method -> Ultrasonic but the environment does not allow it *)
	ultrasonicForbiddenSamples = PickList[mySamples, ultrasonicForbiddenEnvironmentQ];

	(* throw a message if Method -> Ultrasonic but the transfer environment is not conducive to that *)
	ultrasonicForbiddenOptions = If[messages && MemberQ[ultrasonicForbiddenEnvironmentQ, True],
		(
			Message[Error::TransferEnvironmentUltrasonicForbidden, ObjectToString[ultrasonicForbiddenSamples, Cache -> updatedCache]];
			{Method, TransferEnvironment}
		),
		{}
	];
	ultrasonicForbiddenTests = If[gatherTests,
		Module[{failingTest, passingTest},


			(* generate the tests; only one will only actually get created*)
			failingTest = If[Length[ultrasonicForbiddenSamples] == 0,
				Nothing,
				Test["If Method -> Ultrasonic, TransferEnvironment is not set to a BiosafetyCabinet or GloveBox:", True, False]
			];

			passingTest = If[Length[ultrasonicForbiddenSamples] == 0,
				Test["If Method -> Ultrasonic, TransferEnvironment is not set to a BiosafetyCabinet or GloveBox:", True, True],
				Nothing
			];

			{failingTest, passingTest}
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* Resolve MaxNumberOfOverfillingRepreparations *)
	(* Check if we have model inputs only. Otherwise we cannot do re-preparation *)
	modelInputQ = Lookup[ToList[myResolutionOptions], ModelInputQ, False];
	resolvedMaxNumberOfOverfillingRepreparations = If[!MatchQ[Lookup[myOptions, MaxNumberOfOverfillingRepreparations],Automatic],
		(* Respect user input OR if we are doing re-preparation already, we have this option *)
		Lookup[myOptions, MaxNumberOfOverfillingRepreparations],
		(* If we have only model inputs, set to 3; Otherwise Null *)
		If[modelInputQ,
			3,
			Null
		]
	];

	(* Error checking *)
	invalidMaxNumberOfOverfillingRepreparationsOptions=If[messages && !NullQ[resolvedMaxNumberOfOverfillingRepreparations] && !modelInputQ,
		(
			Message[Error::InvalidMaxNumberOfOverfillingRepreparations];
			{MaxNumberOfOverfillingRepreparations}
		),
		{}
	];

	maxNumberOfOverfillingRepreparationsTest=If[gatherTests,
		Test["MaxNumberOfOverfillingRepreparationsOptions option can only be set when the inputs are Model[Sample]:", !NullQ[resolvedMaxNumberOfOverfillingRepreparations] && !modelInputQ, False],
		Null
	];

	(* --- Gather everything up for the end --- *)

	(* the options that we resolved manually here, or that were defaulted, should override the resolved Transfer options*)
	resolvedOptions = ReplaceRule[
		relevantResolvedTransferOptions/.postTransferReplaceRules,
		Flatten[{
			DestinationWell -> resolvedDestinationWell,
			Method -> resolvedMethod,
			Solvent -> resolvedSolvent,
			Tolerance -> resolvedTolerance,
			LiquidLevelDetector -> resolvedLiquidLevelDetectors,
			SolventContainer -> Lookup[resolvedTransferOptions, SourceContainer],
			SolventLabel -> Lookup[resolvedTransferOptions, SourceLabel],
			SolventContainerLabel -> Lookup[resolvedTransferOptions, SourceContainerLabel],
			SampleLabel -> Lookup[resolvedTransferOptions, DestinationLabel],
			SampleContainerLabel -> Lookup[resolvedTransferOptions, DestinationContainerLabel],
			Name -> Lookup[myOptions, Name],
			Template -> Lookup[myOptions, Template],
			SolventStorageCondition -> Lookup[myOptions, SolventStorageCondition],
			SamplesOutStorageCondition -> Lookup[myOptions, SamplesOutStorageCondition],
			SubprotocolDescription -> Lookup[myOptions, SubprotocolDescription],
			Priority -> Lookup[myOptions, Priority],
			StartDate -> Lookup[myOptions, StartDate],
			HoldOrder -> Lookup[myOptions, HoldOrder],
			QueuePosition -> Lookup[myOptions, QueuePosition],
			GraduationFilling -> Lookup[myOptions, GraduationFilling],
			PreparatoryUnitOperations -> Lookup[myOptions, PreparatoryUnitOperations],
			resolvedPostProcessingOptions,
			MaxNumberOfOverfillingRepreparations -> resolvedMaxNumberOfOverfillingRepreparations,
			(* replace the DestinationWell symbol with AliquotDestinationWell in the resolvedAliquotOptions *)
			(resolvedAliquotOptions /. {(DestinationWell -> x_) :> (AliquotDestinationWell -> x)}),
			Cache -> updatedCache
		}]
	];

	(* combine all the invalid options *)
	invalidOptions = DeleteDuplicates[Flatten[{
		missingDestinationWellOptions,
		sampleNotInPositionOptions,
		emptyContainerOptions,
		incompatibleMethodOptions,
		ultrasonicIncompatibleSampleOptions,
		ultrasonicIncompatibleContainerOptions,
		toleranceTooSmallOptions,
		nameInvalidOptions,
		volumetricWrongVolumeOptions,
		volumetricTooLargeVolumeOptions,
		validContainerStorageConditionInvalidOptions,
		ultrasonicForbiddenOptions,
		invalidMaxNumberOfOverfillingRepreparationsOptions
	}]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* combine the invalid inputs *)
	(* currently there are no InvalidInput tests on our end but want to leave this here to keep the framework and also to allow us to add them in the future *)
	invalidInputs = DeleteDuplicates[Flatten[{
		duplicateSampleInputs,
		sampleVolumeAboveRequestedVolumeInputs
	}]];

	(* throw the InvalidInputs error if necessary *)
	If[Not[MatchQ[invalidInputs, {}]] && messages,
		Message[Error::InvalidInput, invalidInputs]
	];

	(* gather all the tests together *)
	allTests = Cases[Flatten[{
		duplicateSampleTest,
		missingDestinationWellTest,
		sampleNotInPositionTest,
		emptyContainerTest,
		incompatibleMethodTest,
		solventDefaultedToWaterTests,
		ultrasonicIncompatibleSampleTest,
		ultrasonicIncompatibleContainerTest,
		toleranceTooSmallTest,
		validNameTest,
		volumetricWrongVolumeTest,
		volumetricTooLargeVolumeTest,
		validContainerStorageConditionTests,
		ultrasonicForbiddenTests,
		sampleVolumeAboveRequestedVolumeTest,
		aliquotTests,
		maxNumberOfOverfillingRepreparationsTest
	}], _EmeraldTest];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
	resultRule = Result -> If[MemberQ[output, Result],
		resolvedOptions,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}

];


(* ::Subsubsection::Closed:: *)
(*fillToVolumeResourcePackets *)

DefineOptions[
	fillToVolumeResourcePackets,
	Options:>{HelperOutputOption, CacheOption, SimulationOption}
];

(* function to populate the fields of this fill to volume protocol and make all the resources *)
fillToVolumeResourcePackets[mySamples : {ObjectP[{Object[Sample], Object[Container]}]..}, myVolumes : {VolumeP..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, ops : OptionsPattern[fillToVolumeResourcePackets]] := Module[
	{expandedResolvedOptions, resolvedOptionsNoHidden, outputSpecification, output, gatherTests, messages, inheritedCache,
		fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule, sampleOrContainerPackets,
		resolvedDestinationWell, samplePackets, containerPackets, sampleModelPackets, containerModelPackets,sampleObjectsForResource,
		samplesInResources, resolvedSolvent, solventPackets, gatheredSolventsAndVolumes, gatheredSolventResources,
		solventResourceReplaceRules, solventResources, allSharedInstruments, sharedInstrumentResources,
		allTips, talliedTips, tipToResourceListLookup, popTipResource, reusableSyringesModels,
		allHandPumps, sharedHandPumpResources, tipRinseSolutionAndVolume, resolvedMethod, reusableNeedleModels,
		tipRinseSolutionResources, handPumpWasteContainerResource, funnelResources, instrumentResources, tipResources,resolvedTipType,
		resolvedTipMaterial,
		needleResources, resolvedFunnels,destination,destinationToIntermediateContainerAssoc,handPumpResources, backfillNeedleResources, ventingNeedleResources,
		combinedMapThreadFriendlyOptions, splitTransferEnvironments, transferEnvironmentResources, resolvedSolventContainer,
		protocolID, currentSampleVolumes, requiredSolventVolumes,firstTransferVolumes, rawResourceBlobs, containersInResourcesPreAliquot,
		resourcesWithoutName, resourceToNameReplaceRules, allResourceBlobs, transferUnitOperationPacketsMissingFields,
		availablePipetteObjectsAndModels, resourcesNotToPickUpFront, containersInResources, protPacketFinal,
		splitLiquidLevelDetector, liquidLevelDetectorResources, liquidLevelDetectorResourceNoNulls,
		sharedInstrumentTypes,resolvedIntermediateContainers,solventResourceToIntermediateContainerAssoc, intermediateContainerResources, wasteContainerResource, transferUnitOperations, transferUnitOperationPackets,
		combinedMapThreadFriendlyOptionsNoHidden, fillToVolumeUnitOperations, fillToVolumeUnitOperationPackets,
		fillToVolumeUnitOperationPacketsNotLinked, currentSimulation, aliquotPacket, protPacket, aliquotDestinationLabel,
		aliquotQ, aliquotSamples, sampleOrContainerPacketsPreAliquot, samplePacketsPreAliquot, rawResourceBlobsWithoutAliquotSamples,
		samplesInResourcesPreAliquot, simulatedSamples, updatedSimulation, samplePrepOptions, cacheWithSimulatedSamples},

	(* expand the resolved options if they weren't expanded already *)
	expandedResolvedOptions = Last[ExpandIndexMatchedInputs[ExperimentFillToVolume, {mySamples, myVolumes}, myResolvedOptions]];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentFillToVolume,
		RemoveHiddenOptions[ExperimentFillToVolume, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[expandedResolvedOptions, Output];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(*get the cache (and cache from simulated samples downloaded durring resolver) and simulation *)
	inheritedCache = Lookup[ToList[ops], Cache, {}];
	currentSimulation = Lookup[ToList[ops], Simulation, {}];

	(* Split Prep Options, remove DestinationWell (from ExperimentFillToVolume) and replace with AliquotDestinationWell *)
	samplePrepOptions = splitPrepOptions[(expandedResolvedOptions /. (DestinationWell -> _) :> Nothing) /. {AliquotDestinationWell -> DestinationWell}][[1]];

	(* simulate the samples after they go through all the sample prep *)
	{simulatedSamples, updatedSimulation} = resolveSamplePrepOptionsNew[ExperimentFillToVolume, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation -> currentSimulation, Output -> Result][[{1,3}]];

	(* Add these simulated samples to the cache as we lookup packets from cache throught this function *)
	cacheWithSimulatedSamples = FlattenCachePackets[{inheritedCache, updatedSimulation[[1]][Packets]}];

	(* Generate an ID for the new protocol *)
	protocolID = CreateID[Object[Protocol, FillToVolume]];

	(* pull out the resolved DestinationWell, Solvent, SolventContainer, Method, and AliquotOptions *)
	{
		resolvedDestinationWell,
		resolvedSolvent,
		resolvedSolventContainer,
		resolvedMethod,
		aliquotQ,
		aliquotDestinationLabel
	} = Lookup[expandedResolvedOptions, {DestinationWell, Solvent, SolventContainer, Method, Aliquot, AliquotSampleLabel}];

	(* get the sample/container packets *)
	sampleOrContainerPackets = fetchPacketFromCache[#, cacheWithSimulatedSamples]& /@ Download[simulatedSamples, Object, Simulation -> updatedSimulation];
	sampleOrContainerPacketsPreAliquot = fetchPacketFromCache[#, inheritedCache]& /@ Download[mySamples, Object, Simulation -> currentSimulation];

	(* get the sample packets and container packets *)
	samplePackets = MapThread[
		Function[{sampleOrContainerPacket, destWell},
			If[MatchQ[sampleOrContainerPacket, ObjectP[Object[Sample]]],
				sampleOrContainerPacket,
				With[{contents = Lookup[sampleOrContainerPacket, Contents]},
					fetchPacketFromCache[
						Download[LastOrDefault[SelectFirst[contents, MatchQ[#[[1]], destWell]&, Null]], Object],
						cacheWithSimulatedSamples
					]
				]
			]
		],
		{sampleOrContainerPackets, resolvedDestinationWell}
	];
	samplePacketsPreAliquot = MapThread[
		Function[{sampleOrContainerPacket, destWell},
			If[MatchQ[sampleOrContainerPacket, ObjectP[Object[Sample]]],
				sampleOrContainerPacket,
				With[{contents = Lookup[sampleOrContainerPacket, Contents]},
					fetchPacketFromCache[
						Download[LastOrDefault[SelectFirst[contents, MatchQ[#[[1]], destWell]&, Null]], Object],
						cacheWithSimulatedSamples
					]
				]
			]
		],
		{sampleOrContainerPacketsPreAliquot, resolvedDestinationWell}
	];
	containerPackets = Map[
		Function[{sampleOrContainerPacket},
			If[MatchQ[sampleOrContainerPacket, ObjectP[Object[Container]]],
				sampleOrContainerPacket,
				fetchPacketFromCache[
					Download[Lookup[sampleOrContainerPacket, Container], Object],
					cacheWithSimulatedSamples
				]
			]
		],
		sampleOrContainerPackets
	];

	(* get the sample model and container model packets *)
	sampleModelPackets = fetchPacketFromCache[#, cacheWithSimulatedSamples]& /@ Download[Lookup[samplePackets, Model], Object];
	containerModelPackets = fetchPacketFromCache[#, cacheWithSimulatedSamples]& /@ Download[Lookup[containerPackets, Model], Object];

	(* get the solvent packets *)
	solventPackets = fetchPacketFromCache[#, cacheWithSimulatedSamples]& /@ Download[resolvedSolvent, Object];

	(* make the SamplesIn resources; since we are using all of the resource, don't need to specify the Amount *)
	samplesInResourcesPreAliquot = Resource[Sample -> #]&/@Lookup[samplePacketsPreAliquot, Object];
	samplesInResources = Resource[Sample -> #]&/@Lookup[samplePackets, Object];
	
	(* generate Solvent resource by first calculating how much solvent is required - get estimate of sample volume and subtract from desired total volume and add buffer amount *)
	
	(* note that this exactly mirrors the option resolver logic*)
	(* figure out how much we are going to transfer in.  This is a little tricky because we don't _actually_ know how much we are going to transfer; we just know the final volume *)
	(* still, we have to guess. My algorithm is to subtract the specified volume from the volume of the sample and multiply by 0.9 *)
	(* when we have a solid sample, we then check if we have a density and compute the volume if we do. If not, we divide the mass by 0.997 g/mL and multiply by 1.25 on the assumption
	  that the solid sample may take up more space. This logic matches ExperimentTransfer *)
	currentSampleVolumes = Map[
		Which[
			NullQ[#], 0 Milliliter,
			VolumeQ[Lookup[#, Volume]], Lookup[#, Volume],
			MassQ[Lookup[#, Mass]], If[DensityQ[Lookup[#, Density]], Lookup[#, Mass] / Lookup[#, Density], Lookup[#, Mass] / (0.997` Gram / Milliliter) * 1.25],
			IntegerQ[Lookup[#, Count]], Lookup[#, Count] * Lookup[#, TabletWeight] * (1 Milliliter / Gram),
			True, 0 Milliliter
		]&,
		samplePackets
	];
	
	(* minimum of 10 Microliter excess resource *)
	requiredSolventVolumes = MapThread[
		Function[{estimatedSampleVolume,totalVolume},
			Which[
				MatchQ[totalVolume-estimatedSampleVolume,RangeP[50 Microliter, 100 Microliter]],
				(totalVolume-estimatedSampleVolume)+10 Microliter,
				
				MatchQ[totalVolume-estimatedSampleVolume,GreaterP[100 Microliter]],
				(totalVolume-estimatedSampleVolume)*1.1,
				
				True,
				totalVolume (* if required volume cannot be appropriately calculated, set to desired total volume of solution *)
			]
		],
		{currentSampleVolumes,myVolumes}
	];


	(* make the ContainersIn resources *)
	(* doing Name -> ToString[#] is a neat trick to make the same resource object if we have duplicate containers *)
	containersInResourcesPreAliquot = Resource[Sample -> #, Name -> ToString[#]]& /@ Download[Lookup[samplePacketsPreAliquot, Container], Object];
	containersInResources =  Resource[Sample -> #, Name -> ToString[#]]& /@ Download[Lookup[samplePackets, Container], Object];

	(* gather the solvents so that duplicates go together *)
	gatheredSolventsAndVolumes = GatherBy[Transpose[{solventPackets, requiredSolventVolumes, resolvedSolventContainer}], #[[1]]&];

	(* make the solvent resources; this is NOT index matched with solventPackets yet because we have no duplicates *)
	(* for whatever reason, if you're making a resource for water, you have to specify the container too; we _could_ be using water here, so in that case use the preferred vessel *)
	gatheredSolventResources = Map[
		With[{sample = Lookup[#[[1, 1]], Object], volume = Total[#[[All, 2]]], container = #[[1, 3]]},

			(* If we're dealing with water, and the container provided is just a model container at the moment, let the water
			resource generated just ask for any preferred contaienr *)
			If[MatchQ[sample, WaterModelP] && (NullQ[container] || MatchQ[container,ObjectP[Model[Container]]]),
				Resource[
					Sample -> sample,
					Amount -> volume,
					Container -> PreferredContainer[volume],
					Name -> ToString[Unique[]]
				],
				Resource[
					Sample -> sample,
					Amount -> volume,
					Container -> container,
					Name -> ToString[Unique[]]
				]
			]
		]&,
		gatheredSolventsAndVolumes
	];
	solventResourceReplaceRules = MapThread[
		#1 -> #2&,
		{gatheredSolventsAndVolumes[[All, 1, 1]], gatheredSolventResources}
	];

	(* get the solvent resources in the proper format *)
	solventResources = solventPackets /. solventResourceReplaceRules;
	
	(* calculate the first transfer volume; want to use AchievableResolution so that ExperimentTransfer is happy *)
	(* using Floor just in case the rounding up overshoots where we want *)
	(* note that if Method has resolved to Volumetric, then we don't want to round down at all because we actually want the correct amount *)
	firstTransferVolumes = MapThread[
		If[MatchQ[#3, Volumetric],
			Quiet[AchievableResolution[(#1 - #2), All, RoundingFunction -> Floor], Warning::AmountRounded],
			Quiet[AchievableResolution[0.9 * (#1 - #2), All, RoundingFunction -> Floor], Warning::AmountRounded]
		]&,
		{myVolumes, currentSampleVolumes, resolvedMethod}
	];

	(* --- This part is ripped pretty clearly from ExperimentTransfer --- *)

	(* get the shared instrument types that we're going to make the same resource for  *)
	sharedInstrumentTypes = {
		Model[Instrument, Pipette],
		Object[Instrument, Pipette],
		Model[Item, Spatula],
		Object[Item, Spatula],
		Model[Item, Tweezer],
		Object[Item, Tweezer],
		Model[Item, ChippingHammer],
		Object[Item, ChippingHammer],
		Model[Item, Scissors],
		Object[Item, Scissors],
		Model[Instrument, Aspirator],
		Object[Instrument, Aspirator]
	};

	(* Create resources for all of the Model[Instrument, Pipette]s and Model[Item, Spatula]s to be the same. *)
	allSharedInstruments = Download[Cases[
		Flatten[{Lookup[myResolvedOptions, Instrument]}],
		ObjectP[sharedInstrumentTypes]
	], Object];

	(* either make an instrument resource or sample resource depending on if we have an instrument or item *)
	sharedInstrumentResources = Map[
		If[MatchQ[#, ObjectP[{Model[Instrument], Object[Instrument]}]],
			# -> Resource[Instrument -> #, Name -> CreateUUID[], Time -> (5 Minute + (5 Minute * Count[allSharedInstruments, ObjectP[#]]))],
			# -> Resource[Sample -> #, Name -> CreateUUID[]]
		]&,
		DeleteDuplicates[allSharedInstruments]
	];

	(* Create resources for all of the tips (both the regular Tips and the QuantitativeTransferWashTips). *)
	allTips = Download[Cases[Flatten[{Lookup[myResolvedOptions, Tips]}], ObjectP[{Model[Item, Tips], Object[Item, Tips]}]], Object];
	talliedTips = Tally[allTips];

	(* Make resources for tips *)
	tipToResourceListLookup = Association[Map[
		Function[{tipInformation},
			Module[{tipObject, numberOfTipsNeeded, tipModelPacket, numberOfTipsPerBox},

				(* Pull out from our tip information. *)
				tipObject = tipInformation[[1]];
				numberOfTipsNeeded = tipInformation[[2]];

				(* Get the tip model packet. *)
				tipModelPacket = If[MatchQ[tipObject, ObjectP[Model[Item, Tips]]],
					fetchPacketFromCache[tipObject, cacheWithSimulatedSamples],
					fetchPacketFromCache[
						Download[Lookup[fetchPacketFromCache[tipObject, cacheWithSimulatedSamples], Model], Object],
						cacheWithSimulatedSamples
					]
				];

				(* Lookup the number of tips per box. *)
				(* NOTE: This can be one if they're individually wrapped or are reusable tips like the glass pipettes *)
				numberOfTipsPerBox = Lookup[tipModelPacket, NumberOfTips];

				(* Return a list that we will pop off of everytime we take a tip. *)
				If[

					(* If the tips are individual objects *)
					numberOfTipsPerBox==1,
					Download[tipObject,Object] -> Table[
						Resource[
							Sample->tipObject,
							Name->CreateUUID[]
						],
						numberOfTipsNeeded
					],


					(* Otherwise, tips are counted and needs to be returned with amounts *)
					Download[tipObject, Object] -> Flatten[{
						Table[ (* Resources for full boxes of tips. For each resource, expand the resource to index match with the number of tip requests *)
							ConstantArray[
								Resource[
									Sample -> tipObject,
									Amount -> numberOfTipsPerBox,
									Name -> CreateUUID[]
								],
								numberOfTipsPerBox
							],
							IntegerPart[numberOfTipsNeeded / numberOfTipsPerBox]
						],
						 (* Resources for the tips in the non-full box. There will only be one resource for this, so just expand it to match the number of objects it represents *)
						ConstantArray[
							Resource[
								Sample -> tipObject,
								Amount -> Mod[numberOfTipsNeeded, numberOfTipsPerBox],
								Name -> CreateUUID[]
							],
							Mod[numberOfTipsNeeded, numberOfTipsPerBox]
						]
					}]
				]
			]
		],
		talliedTips
	]];

	(* Helper function to pop a tip resource off of a given stack. *)
	popTipResource[tipObject_]:=Module[{oldResourceList},
		If[MatchQ[tipObject, Null],
			Null,
			oldResourceList=Lookup[tipToResourceListLookup, Download[tipObject, Object]];

			tipToResourceListLookup[Download[tipObject, Object]]=Rest[oldResourceList];

			First[oldResourceList]
		]
	];

	(* Create resources for all of the hand pumps. *)
	allHandPumps = Download[Cases[Lookup[myResolvedOptions, HandPump], ObjectP[{Model[Part, HandPump], Object[Part, HandPump]}]], Object];
	sharedHandPumpResources = Map[
		Download[#, Object] -> Resource[Sample -> #, Name -> CreateUUID[]]&,
		DeleteDuplicates[allHandPumps]
	];

	(* Create resources for the tip rinse solution. *)
	tipRinseSolutionAndVolume = Transpose[{Download[Lookup[myResolvedOptions, TipRinseSolution], Object], Lookup[myResolvedOptions, TipRinseVolume]}];
	tipRinseSolutionResources = Map[
		# -> If[MatchQ[#, ObjectP[Model[Sample]]],
			Resource[
				Sample -> #,
				Amount -> Total[Cases[tipRinseSolutionAndVolume, {#, _}][[All, 2]]] * 1.05,
				Container -> PreferredContainer[Total[Cases[tipRinseSolutionAndVolume, {#, _}][[All, 2]]] * 1.05],
				Name -> CreateUUID[]
			],
			Resource[
				Sample -> #,
				Amount -> Total[Cases[tipRinseSolutionAndVolume, {#, _}][[All, 2]]] * 1.05,
				Name -> CreateUUID[]
			]
		]&,
		DeleteDuplicates[Download[Cases[Lookup[myResolvedOptions, TipRinseSolution], ObjectP[]], Object]]
	];

	(* Create a single resource for HandPumpWasteContainer *)
	(* Model[Container, Vessel, "1000mL Glass Beaker"] *)
	(* note that this gets hard coded again in fillToVolumeAchievedQ *)
	handPumpWasteContainerResource = Resource[
		Sample -> Model[Container, Vessel, "id:O81aEB4kJJJo"],
		Name -> CreateUUID[],
		Rent -> True
	];

	(* get the MapThread friendly options, including hidden and not *)
	combinedMapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFillToVolume, myResolvedOptions];
	combinedMapThreadFriendlyOptionsNoHidden = OptionsHandling`Private`mapThreadOptions[ExperimentFillToVolume, RemoveHiddenOptions[ExperimentFillToVolume, myResolvedOptions]];

	(* try to group adjacent transfers as much as possible now that we know each transfer has a specific list of "real" equivalent environments that we can do transfers on no problem
	 given a list: list = {{a, b, c}, {a, b}, {a, c}, {d}, {a, d}}
	 the goal is get this output: {{{a}, {a}, {a}}, {{d}, {d}}} (the first set will use TransferEnvironment a, the next one uses TransferEnvironment d)
	 such that we have the longest group that shares the same TransferEnvironment resource *)
	splitTransferEnvironments = splitByCommonElements[Lookup[combinedMapThreadFriendlyOptions, EquivalentTransferEnvironments]];

	(* Create our index matched transfer environment resources. *)
	transferEnvironmentResources = Map[
		(* NOTE: Since splitTransferEnvironments is legit grouped, it will be a list of the same thing. *)
		Function[{groupedTransferEnvironments},
			Sequence @@ ConstantArray[
				Resource[
					(* InstrumentResourceP only accepts a single instrument OBJECT/MODEL, or a list of instrument MODELs, but not a list of OBJECTs, so we have to branch here *)
					Instrument -> If[MatchQ[First[groupedTransferEnvironments], {ObjectP[Model[Instrument]]..}],
						First[groupedTransferEnvironments],
						First[First[groupedTransferEnvironments]]
					],
					Time -> 30 * Minute * Length[groupedTransferEnvironments],
					Name -> CreateUUID[]
				],
				Length[groupedTransferEnvironments]
			]

		],
		splitTransferEnvironments
	];

	(* split the liquid level detector in the same way that the TransferEnvironment was *)
	(* there is no guarantee that same transfer environment would have same LLDs resolved! and it is fine that they are different right? *)
	splitLiquidLevelDetector = Split[Download[Lookup[combinedMapThreadFriendlyOptions, LiquidLevelDetector], Object]];

	(* make a unique resource for each unique transfer environment *)
	liquidLevelDetectorResourceNoNulls = Map[
		Function[{groupedLiquidLevelDetector},
			Sequence @@ If[MatchQ[groupedLiquidLevelDetector, {Null..}],
				groupedLiquidLevelDetector,
				ConstantArray[
					Resource[
						Instrument -> First[groupedLiquidLevelDetector],
						(* this time is kind of arbitrary*)
						Time -> 1 Hour * Length[groupedLiquidLevelDetector],
						Name -> CreateUUID[]
					],
					Length[groupedLiquidLevelDetector]
				]
			]
		],
		splitLiquidLevelDetector
	];

	(* for each entry where Method -> Volumetric, the liquid level detector is actually Null *)
	liquidLevelDetectorResources = MapThread[
		If[MatchQ[#2, Ultrasonic],
			#1,
			Null
		]&,
		{liquidLevelDetectorResourceNoNulls, Lookup[combinedMapThreadFriendlyOptions, Method]}
	];

	(* get a list of needles used *)
	{reusableNeedleModels, reusableSyringesModels} = Module[
		{allNeedlesUsed, allSyringesUsed, allNeedlesReusable, allSyringesReusable, needles, syringes},

		(* get all the needles models used *)
		allNeedlesUsed = DeleteDuplicates[Flatten[Lookup[combinedMapThreadFriendlyOptions, Needles, {}]]];
		allSyringesUsed = Cases[DeleteDuplicates[Flatten[Lookup[combinedMapThreadFriendlyOptions, Instrument, {}]]], ObjectP[Model[Container, Syringe]]];

		(* get reusability for those models *)
		{allNeedlesReusable, allSyringesReusable} = If[MatchQ[allNeedlesUsed, Null | {}] && MatchQ[allSyringesUsed, Null | {}],
			{{}, {}},
			Download[{allNeedlesUsed, allSyringesUsed}, Reusable]];

		(* return only reusable ones *)
		needles = PickList[allNeedlesUsed, allNeedlesReusable, True];
		syringes = PickList[allSyringesUsed, allSyringesReusable, True];

		(* output *)
		{needles, syringes}
	];

	(* --- pre-generate all the resources that I'm going to make below because otherwise the Names are not going to agree --- *)

	(* make the instrument, tip, and needle resources *)
	instrumentResources = Map[
		Function[{options},
			Switch[Lookup[options, Instrument],
				ObjectP[{Model[Container], Object[Container]}], (* Need to make a new resource every time we use a syringe or graduated cylinder. *)
				Resource[
					Sequence@@{
						Sample -> Lookup[options, Instrument],
						(* if we are taking a reusable syringe or a graduated cylinder, rent them instead of buying *)
						If[MatchQ[Lookup[options, Instrument], (ObjectP[Model[Container, GraduatedCylinder]] | Alternatives@@reusableSyringesModels)], Rent->True, Nothing],
						Name -> CreateUUID[]
					}
				],
				(* These can be shared between transfers -- we'll tell operators to wipe down the spatulas. *)
				ObjectP[sharedInstrumentTypes],
				Lookup[sharedInstrumentResources, Download[Lookup[options, Instrument], Object]],
				_, Null
			]
		],
		combinedMapThreadFriendlyOptions
	];
	(* require Tips->Model[Item, Consumable, "id:bq9LA0J1xmBd"] to serve as pipette dropper when transfering from GraduatedCylinder to VolumetricFlask *)
	tipResources = Map[
		Function[{options},
			If[MatchQ[Lookup[options,Tips],ObjectP[{Model[Item,Consumable],Object[Item,Consumable]}]],
				Resource[
					Sample->Lookup[options,Tips],
					Name->CreateUUID[]
				],
				popTipResource[Lookup[options, Tips]]
			]
		],
		combinedMapThreadFriendlyOptions
	];
	
	needleResources = Map[
		With[{specifiedNeedle = Lookup[#, Needle]},
			If[MatchQ[specifiedNeedle, ObjectP[]],
				Resource[Sequence@@{
					Sample -> specifiedNeedle,
					If[MatchQ[specifiedNeedle, Alternatives @@ reusableNeedleModels],
						Rent -> True,
						Nothing
					],
					(* only use UUID as name if we're dealing with a model; if we're dealing with an object then we can't do that *)
					Name -> If[MatchQ[specifiedNeedle, ObjectP[Model]],
						CreateUUID[],
						ToString[specifiedNeedle]
					]
				}],
				Null
			]
		]&,
		combinedMapThreadFriendlyOptions
	];
	
	(* consolidate funnels that are of teh same model and are going to the same destination - destination is indexed-matched to the individual transfer UOs*)
	resolvedFunnels = Lookup[combinedMapThreadFriendlyOptions,Funnel];
	
	(* create a list of destination based on aliquot *)
	destination = MapThread[
		Function[{aliquot,aliquotLabel,sample},
			If[aliquot,
				aliquotLabel,
				sample
			]
		],
		{
			aliquotQ,
			aliquotDestinationLabel,
			samplesInResources
		}
	];
	
	destinationToIntermediateContainerAssoc = DeleteDuplicates[
		MapThread[#1->Download[#2,Object]&,{destination,resolvedFunnels}]
	]/.(destination_->x:ObjectP[]):>destination->Resource[Sample->x,Name->CreateUUID[]];
	
	funnelResources = destination/.destinationToIntermediateContainerAssoc;

	(* make more resources *)
	handPumpResources = Map[
		If[MatchQ[Lookup[#, HandPump], ObjectP[]],
			Lookup[sharedHandPumpResources, Download[Lookup[#, HandPump], Object]],
			Null
		]&,
		combinedMapThreadFriendlyOptions
	];
	backfillNeedleResources = Map[
		Switch[Lookup[#, BackfillNeedle],
			ObjectP[Model], Resource[Sample -> Lookup[#, BackfillNeedle], Name -> CreateUUID[]],
			ObjectP[], Resource[Sample -> Lookup[#, BackfillNeedle], Name -> ToString[Lookup[#, BackfillNeedle]]],
			_, Null
		]&,
		combinedMapThreadFriendlyOptions
	];
	ventingNeedleResources = Map[
		Switch[Lookup[#, VentingNeedle],
			ObjectP[Model], Resource[Sample -> Lookup[#, VentingNeedle], Name -> CreateUUID[]],
			ObjectP[], Resource[Sample -> Lookup[#, VentingNeedle], Name -> ToString[Lookup[#, VentingNeedle]]],
			_, Null
		]&,
		combinedMapThreadFriendlyOptions
	];
	
	(* consolidate intermediate container resources based on solventResources - solventResources is indexed-matched to the individual transfer UOs *)
	resolvedIntermediateContainers = Lookup[combinedMapThreadFriendlyOptions,IntermediateContainer];
	solventResourceToIntermediateContainerAssoc = DeleteDuplicates[
		MapThread[#1->Download[#2,Object]&,{solventResources,resolvedIntermediateContainers}]
	]/.(solventRes_->x:ObjectP[]):>solventRes->Resource[Sample->x,Name->CreateUUID[]];
	
	intermediateContainerResources = solventResources/.solventResourceToIntermediateContainerAssoc;

	(* Single WasteContainer resource *)
	wasteContainerResource = If[MatchQ[Lookup[myResolvedOptions, WasteContainer], ObjectP[]],
		Resource[
			Sample -> Lookup[myResolvedOptions, WasteContainer],
			Name -> CreateUUID[],
			Rent -> True
		],
		Null
	];

	(* make our Transfer unit operations.  each one will go into a different FillToVolume unit operation *)
	(* everything is a list, annoyingly, because if FastTrack -> True in UploadUnitOperation then we have to have expanded unit operation keys *)
	transferUnitOperations = MapThread[
		Function[
			{
				sample,
				samplePacket,
				firstTransferVolume,
				solvent,
				transferEnvironmentResource,
				options,
				instrumentResource,
				tipResource,
				needleResource,
				funnelResource,
				handPumpResource,
				backfillNeedleResource,
				ventingNeedleResource,
				intermediateContainerResource,
				aliquotQ,
				aliquotDestinationLabel
			},
			Transfer[
				(* we will now treat water as a normal resource now (dealt by RP framework, WaterPrep task), so is in Transfer, so we should pass the resource blob upfront so this will be an actual object once it is there *)
				Source -> {solvent},
				(* If we are aliquot temporary store a label in the input unit operation that we will update via execute *)
				Destination -> If[aliquotQ,{aliquotDestinationLabel},{sample}],
				Amount -> {firstTransferVolume},
				SourceWell -> {Lookup[samplePacket, Position]},
				DestinationWell -> {Lookup[options, DestinationWell]},
				TransferEnvironment -> {transferEnvironmentResource},
				Instrument -> {instrumentResource},
				SterileTechnique -> {Lookup[options, SterileTechnique]},
				RNaseFreeTechnique -> {Lookup[options, RNaseFreeTechnique]},

				Tips -> {tipResource},
				TipType -> {Lookup[options,TipType]},
				TipMaterial -> {Lookup[options,TipMaterial]},
				ReversePipetting -> {Lookup[options, ReversePipetting]},
				Needle -> {needleResource},
				Funnel -> {funnelResource},
				HandPump -> {handPumpResource},
				UnsealHermeticSource -> {Lookup[options, UnsealHermeticSource]},
				BackfillNeedle -> {backfillNeedleResource},
				BackfillGas -> Lookup[options, BackfillGas],
				VentingNeedle -> {ventingNeedleResource},
				TipRinse -> {Lookup[options, TipRinse]},
				TipRinseSolution -> {If[MatchQ[Lookup[options, TipRinseSolution], ObjectP[]],
					Lookup[tipRinseSolutionResources, Download[Lookup[options, TipRinseSolution], Object]],
					Null
				]},
				TipRinseVolume -> {Lookup[options, TipRinseVolume]},
				NumberOfTipRinses -> {Lookup[options, NumberOfTipRinses]},
				AspirationMix -> {Lookup[options, AspirationMix]},
				AspirationMixType -> {Lookup[options, AspirationMixType]},
				NumberOfAspirationMixes -> {Lookup[options, NumberOfAspirationMixes]},
				DispenseMix -> {Lookup[options, DispenseMix]},
				DispenseMixType -> {Lookup[options, DispenseMixType]},
				NumberOfDispenseMixes -> {Lookup[options, NumberOfDispenseMixes]},
				IntermediateDecant -> {Lookup[options, IntermediateDecant]},
				IntermediateContainer -> {intermediateContainerResource},
				IntermediateFunnel -> {Null},
				(* Only need WasteContainer for Volumetric *)
				WasteContainer -> If[MatchQ[Lookup[options,Method],Volumetric],
					wasteContainerResource,
					Null
				],
				SourceTemperature -> {Lookup[options, SourceTemperature]},
				SourceEquilibrationTime -> {Lookup[options, SourceEquilibrationTime]},
				MaxSourceEquilibrationTime -> {Lookup[options, MaxSourceEquilibrationTime]},
				SourceEquilibrationCheck -> {Lookup[options, SourceEquilibrationCheck]},
				DestinationTemperature -> {Lookup[options, DestinationTemperature]},
				DestinationEquilibrationTime -> {Lookup[options, DestinationEquilibrationTime]},
				MaxDestinationEquilibrationTime -> {Lookup[options, MaxDestinationEquilibrationTime]},
				DestinationEquilibrationCheck -> {Lookup[options, DestinationEquilibrationCheck]}
			]
		],
		{
			samplesInResources,
			samplePackets,
			firstTransferVolumes,
			solventResources,
			transferEnvironmentResources,
			combinedMapThreadFriendlyOptions,
			instrumentResources,
			tipResources,
			needleResources,
			funnelResources,
			handPumpResources,
			backfillNeedleResources,
			ventingNeedleResources,
			intermediateContainerResources,
			aliquotQ,
			aliquotDestinationLabel
		}
	];

	(* make unit operation packets out of the blobs we just created  *)
	transferUnitOperationPacketsMissingFields = UploadUnitOperation[
		transferUnitOperations,
		UnitOperationType -> Input,
		Upload -> False,
		FastTrack -> True
	];

	(* add some fields that we're missing from the transfer unit operations *)
	transferUnitOperationPackets = Map[
		Join[
			#,
			<|
				HandPumpWasteContainer -> If[MatchQ[Lookup[#, Replace[HandPump]], ListableP[Null]],
					Null,
					Link[handPumpWasteContainerResource]
				]
			|>
		]&,
		transferUnitOperationPacketsMissingFields
	];


	(* now automatically generate the FillToVolume unit operations, except with the resources replaced *)
	fillToVolumeUnitOperations = MapThread[
		Function[
			{
				options,
				sampleResource,
				solventResource,
				volume,
				transferEnvironmentResource,
				instrumentResource,
				tipResource,
				needleResource,
				funnelResource,
				handPumpResource,
				backfillNeedleResource,
				ventingNeedleResource,
				intermediateContainerResource,
				liquidLevelDetectorResource
			},
			FillToVolume @@ Join[
				{
					Sample -> {sampleResource},
					TotalVolume -> {volume}
				},
				ReplaceRule[
					Normal[options],
					{
						Solvent -> {solventResource},
						TransferEnvironment -> {transferEnvironmentResource},
						Instrument -> {instrumentResource},
						Tips -> {tipResource},
						Needle -> {needleResource},
						Funnel -> {funnelResource},
						HandPump -> {handPumpResource},
						BackfillNeedle -> {backfillNeedleResource},
						VentingNeedle -> {ventingNeedleResource},
						IntermediateContainer -> {intermediateContainerResource},
						(* Only need WasteContainer for Volumetric *)
						WasteContainer -> If[MatchQ[Lookup[options,Method],Volumetric],
							wasteContainerResource,
							Null
						],
						TipRinseSolution -> {If[MatchQ[Lookup[options, TipRinseSolution], ObjectP[]],
							Lookup[tipRinseSolutionResources, Download[Lookup[options, TipRinseSolution], Object]],
							Null
						]},
						LiquidLevelDetector -> {liquidLevelDetectorResource},
						(* need to do this because don't want to inherit the name option from the parent *)
						Name -> Null
					}
				]
			]
		],
		{
			combinedMapThreadFriendlyOptionsNoHidden,
			samplesInResources,
			solventResources,
			myVolumes,
			transferEnvironmentResources,
			instrumentResources,
			tipResources,
			needleResources,
			funnelResources,
			handPumpResources,
			backfillNeedleResources,
			ventingNeedleResources,
			intermediateContainerResources,
			liquidLevelDetectorResources
		}
	];

	(* make unit operation packets out of the blobs we just created, part 2  *)
	fillToVolumeUnitOperationPacketsNotLinked = UploadUnitOperation[
		fillToVolumeUnitOperations,
		UnitOperationType -> Batched,
		Upload -> False,
		FastTrack -> True
	];

	(* Add extra fields to the fill to volume unit operations, notably, the link between the FillToVolume and Transfer. *)
	fillToVolumeUnitOperationPackets = MapThread[
		Join[
			#1,
			<|
				Replace[TransferUnitOperations] -> Link[Lookup[#2, Object]],
				HandPumpWasteContainer -> If[MatchQ[Lookup[#1, Replace[HandPump]], ListableP[Null]],
					Null,
					Link[handPumpWasteContainerResource]
				],
				Replace[SourceWell] -> ToList[Lookup[#2, Replace[SourceWell]]]
			|>
		]&,
		{fillToVolumeUnitOperationPacketsNotLinked, transferUnitOperationPackets}
	];

	(* Make list of all the resources we need to check in FRQ. *)
	rawResourceBlobs = DeleteDuplicates[Cases[Flatten[{fillToVolumeUnitOperationPackets, transferUnitOperationPackets}], _Resource, Infinity]];
	rawResourceBlobsWithoutAliquotSamples = Cases[rawResourceBlobs,
		Except[Alternatives@@Join[
			PickList[samplesInResources,aliquotQ],
			PickList[containersInResources, aliquotQ]
		]]];

	(* Get all resources without a name. *)
	resourcesWithoutName = DeleteDuplicates[Cases[rawResourceBlobsWithoutAliquotSamples, Resource[_?(MatchQ[KeyExistsQ[#, Name], False]&)]]];
	resourceToNameReplaceRules = MapThread[#1 -> #2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name -> CreateUUID[]]]&) /@ resourcesWithoutName}];
	allResourceBlobs = rawResourceBlobsWithoutAliquotSamples /. resourceToNameReplaceRules;

	(* Figure out which resources we shouldn't pick up front. Right now, these only include pipettes and pipette tips *)
	(* if we're in the BSC/glove box since we stash pipettes in these transfer environments. *)
	(* NOTE: We do this at experiment time to try to avoid any un-linking of resources at experiment time. *)
	(* This can be a little inaccurate since things can change between experiment and procedure time but generally, *)
	(* we don't expect the types of pipettes to change. Additionally, the operator is still given free-reign to *)
	(* pick whatever they want so they can still pick something from the VLM if there aren't enough stashed in the box. *)

	(* Figure out what pipette objects and models are available in each of the transfer environments that we have. *)
	availablePipetteObjectsAndModels = Map[
		Function[{transferEnvironment},
			(* Figure out what pipette objects/models are available in our transfer environment. *)
			Download[transferEnvironment, Object] -> Switch[Download[transferEnvironment, Object],
				ObjectP[{Object[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, BiosafetyCabinet]}],
					Module[{transferEnvironmentObjectPacket},
						(* Get the packet for the transfer environment. *)
						transferEnvironmentObjectPacket = fetchPacketFromCache[transferEnvironment, cacheWithSimulatedSamples];

						Download[
							Flatten[{
								Lookup[transferEnvironmentObjectPacket, Pipettes],
								(Lookup[fetchPacketFromCache[#, cacheWithSimulatedSamples], Model]&) /@ Lookup[transferEnvironmentObjectPacket, Pipettes]
							}],
							Object
						]
					],
				ObjectP[{Model[Instrument, HandlingStation, GloveBox], Model[Instrument, HandlingStation, BiosafetyCabinet]}],
					Module[{transferEnvironmentModelPacket, transferEnvironmentObjectsPacket, allPipetteObjects},
						(* Get the packet for the transfer environment. *)
						transferEnvironmentModelPacket = fetchPacketFromCache[transferEnvironment, cacheWithSimulatedSamples];
						(* Instead of downloading objects from the model which may grab DeveloperObjects instead pull objects from the cache that point to the model *)
						transferEnvironmentObjectsPacket = Cases[cacheWithSimulatedSamples, KeyValuePattern[Model -> LinkP[transferEnvironment]]];

						allPipetteObjects = Cases[Flatten[(Lookup[#, Pipettes]&) /@ transferEnvironmentObjectsPacket], ObjectP[]];

						(* Include all objects but do an intersection of the models. *)
						Download[
							(Flatten[{
								allPipetteObjects,
								(* Its possible that the result will Intersection@@{}, Quiet the error message that would be thrown and remove unevaluated Interesction by replacing it Sequence *)
								Quiet[Intersection @@ (Lookup[fetchPacketFromCache[#, cacheWithSimulatedSamples], Model]& /@ allPipetteObjects), {Intersection::argm}]
							}] /. Intersection -> Sequence),
							Object
						]
					],
				_,
				{}
			]
		],
		DeleteDuplicates[Download[Lookup[myResolvedOptions, TransferEnvironment], Object]]
	];

	(* If we have a BSC or glove box transfer environment, do not pick the pipette (and corresponding pipette tips) up front *)
	(* if we think that we can fulfill it from the stash inside of the box. *)
	resourcesNotToPickUpFront = Flatten[MapThread[
		Function[{fillToVolumePacket, transferEnvironment},
			If[MatchQ[transferEnvironment, ObjectP[{Model[Instrument, HandlingStation, GloveBox], Object[Instrument, HandlingStation, GloveBox], Model[Instrument, HandlingStation, BiosafetyCabinet], Object[Instrument, HandlingStation, BiosafetyCabinet]}]],
				Module[{availablePipettes},
					availablePipettes = Lookup[availablePipetteObjectsAndModels, Download[transferEnvironment, Object]];
					{
						If[
							And[
								MatchQ[Lookup[fillToVolumePacket, Instrument], Resource[KeyValuePattern[Instrument -> ObjectP[{Object[Instrument, Pipette], Model[Instrument, Pipette]}]]]],
								MemberQ[availablePipettes, ObjectP[Lookup[Lookup[fillToVolumePacket, Instrument], Instrument]]]
							],
							{
								Lookup[fillToVolumePacket, Instrument],
								Lookup[fillToVolumePacket, Replace[Tips]]
							},
							Nothing
						]
					}
				],
				Nothing
			]
		],
		{fillToVolumeUnitOperationPackets, Lookup[combinedMapThreadFriendlyOptions, TransferEnvironment]}
	]];

	(* return our final protocol packet *)
	protPacket = <|
		Object -> protocolID,
		(* TODO actually fix these once the procedure is written *)
		Replace[Checkpoints] -> {
			{"Picking Resourecs", 1 Hour, "Samples and plates required to execute this protocol are gathered from storage and stock solutions are freshly prepared.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]},
			{"Performing Fill to Volume Transfers", 15 * Minute * Length[fillToVolumeUnitOperations], "The fill to volume transfers are performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 * Minute * Length[fillToVolumeUnitOperations]]]},
			{"Returning Materials", 30 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]}
		},
		Author -> If[MatchQ[Lookup[myResolvedOptions, ParentProtocol], Null],
			Link[$PersonID, ProtocolsAuthored]
		],
		ParentProtocol -> If[MatchQ[Lookup[myResolvedOptions, ParentProtocol], ObjectP[ProtocolTypes[]]],
			Link[Lookup[myResolvedOptions, ParentProtocol], Subprotocols]
		],
		Replace[BatchedUnitOperations] -> Link[Lookup[fillToVolumeUnitOperationPackets, Object], Protocol],
		UnresolvedOptions -> RemoveHiddenOptions[ExperimentFillToVolume, myUnresolvedOptions],
		ResolvedOptions -> myResolvedOptions,
		Name -> Lookup[myResolvedOptions, Name],
		MaxNumberOfOverfillingRepreparations -> Lookup[myResolvedOptions, MaxNumberOfOverfillingRepreparations],
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResourcesPreAliquot),
		Replace[ContainersIn] -> (Link[#, Protocols]& /@ containersInResourcesPreAliquot),
		Replace[TotalVolumes] -> myVolumes,
		Replace[Solvents] -> (Link[#]& /@ solventResources),
		Replace[FillToVolumeMethods] -> Lookup[expandedResolvedOptions, Method],
		Replace[Tolerance] -> Lookup[expandedResolvedOptions, Tolerance],
		Replace[GraduationFillings] -> Lookup[myResolvedOptions,GraduationFilling],
		(* these all need to be Null, and then get flipped to True/False once the transfers are each done*)
		Replace[TargetVolumeToleranceAchieved] -> ConstantArray[Null, Length[Lookup[expandedResolvedOptions, Tolerance]]],
		Replace[SolventStorage] -> Lookup[expandedResolvedOptions, SolventStorageCondition],
		Replace[SamplesOutStorage] -> Lookup[expandedResolvedOptions, SamplesOutStorageCondition],

		(* NOTE: These are all resource picked at once so that we can minimize trips to the VLM. *)
		Replace[RequiredObjects] -> (Link /@ DeleteDuplicates[
			Cases[
				Cases[allResourceBlobs, Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]]],
				Except[Alternatives @@ resourcesNotToPickUpFront]
			]
		]),
		(* NOTE: These are resource picked on the fly, but we need this field so that ReadyCheck knows if we can start the protocol or not. *)
		Replace[RequiredInstruments] -> (Link /@ DeleteDuplicates[
			Cases[
				Cases[allResourceBlobs, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]]],
				Except[Alternatives @@ resourcesNotToPickUpFront]
			]
		]),
		WasteContainer -> wasteContainerResource,
		ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
		MeasureVolume -> Lookup[expandedResolvedOptions, MeasureVolume],
		MeasureWeight -> Lookup[expandedResolvedOptions, MeasureWeight]
	|>;

	(* Create upload rules for aliquot sample prep *)
	aliquotPacket = populateSamplePrepFields[mySamples, expandedResolvedOptions, Simulation -> updatedSimulation, Cache -> cacheWithSimulatedSamples];

	(* Make the upload packet *)
	protPacketFinal = Join[protPacket, aliquotPacket];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Simulation -> updatedSimulation, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Output -> {Result, Tests}],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, Simulation -> updatedSimulation, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Output -> Result, Messages -> messages], Null}
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
		Cases[Flatten[{frqTests}], _EmeraldTest],
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{protPacketFinal, Flatten[{fillToVolumeUnitOperationPackets, transferUnitOperationPackets}], updatedSimulation},
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];


(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentFillToVolume,
	Options :> {CacheOption, SimulationOption}
];

simulateExperimentFillToVolume[
	myResourcePacket:(PacketP[Object[Protocol, FillToVolume], {Object, ResolvedOptions}]|$Failed),
	myUnitOperationPackets:({PacketP[]..}|$Failed),
	mySamples:{(ObjectP[{Object[Sample], Object[Container]}])..},
	myVolumes:{VolumeP..},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentFillToVolume]
]:=Module[
	{protocolObject, mapThreadFriendlyOptions, currentSimulation, cache, inheritedSimulation, resolvedSolvent,
		resolvedSolventContainer, simulatedUnitOperationPackets, simulatedSourceSamplePackets,
		simulatedSourceContainerPackets, simulatedDestinationSamplePackets, simulatedDestinationContainerPackets,
		simulatedSourceAndDestinationCache, fakeContainerPackets, fakeWaterSampleContainerObject,
		fakeWasteSampleContainerObject, fakeWaterAndWastePackets, fakeWaterSample, fakeWasteSample,
		solventSamples, solventContainers, destinationSamples, destinationContainers, amountsToTransfer,
		uploadSampleTransferPackets, simulationWithLabels, volumeCorrectionPackets},

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = If[MatchQ[myResourcePacket, $Failed],
		SimulateCreateID[Object[Protocol, FillToVolume]],
		Lookup[myResourcePacket, Object]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
		ExperimentFillToVolume,
		myResolvedOptions
	];

	(* pull out the cache and simulation from the resolution options*)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	inheritedSimulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* pull out the resolved Solvent and SolventContainer ) *)
	{resolvedSolvent, resolvedSolventContainer} = Lookup[myResolvedOptions, {Solvent, SolventContainer}];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation = If[MatchQ[myResourcePacket, $Failed],
		(* NOTE: Even if our resource packets simulation failed, we're going to have to generate some shell primitive *)
		(* objects so that we can simulate the transfer samples and return them. This is NOT REQUIRED for most experiment *)
		(* functions where a shell protocol object is just fine. *)
		Module[
			{protocolPacket, simulatedUnitOperationIDs, fillToVolumeUnitOperationPackets, sampleOrContainerPackets,
				sampleObjs, containerObjs, samplesInResources, containersInResources, gatheredSolventsAndVolumes,
				gatheredSolventResources, solventResourceReplaceRules, solventResources, fillToVolumeUnitOperations},
			(* NOTE: The following is code from the resource packets function. It should be kept in sync. *)
			(* We basically just run the part of the resource packets function here that we can be sure is error-proof. *)

			(* Download the information we need here *)
			sampleOrContainerPackets = Quiet[Download[
				mySamples,
				Packet[Contents, Container],
				Cache -> cache,
				Simulation -> inheritedSimulation
			], {Download::FieldDoesntExist}];

			(* get the sample and the container for each sample *)
			{sampleObjs, containerObjs} = Transpose[Map[
				Function[packet,
					If[MatchQ[packet, ObjectP[Object[Sample]]],
						{Lookup[packet, Object], Download[Lookup[packet, Container], Object]},
						{
							(* if you gave a container then it must have been a vessel and so there should only be one sample in it *)
							Download[Lookup[packet, Contents][[1, 2]], Object],
							Lookup[packet, Object]
						}
					]
				],
				sampleOrContainerPackets
			]];

			(* make the SamplesIn and ContainersIn resources *)
			(* doing Name -> ToString[#] is a neat trick to make the same resource object if we have duplicate containers *)
			samplesInResources = Resource[Sample -> #]& /@ sampleObjs;
			containersInResources = Resource[Sample -> #, Name -> ToString[#]]& /@ containerObjs;

			(* Simulate the creation of transfer primitive IDs. *)
			simulatedUnitOperationIDs = SimulateCreateID[ConstantArray[Object[UnitOperation, FillToVolume], Length[mySamples]]];

			(* gather the solvents so that duplicates go together *)
			(* gathering with the total volume because that's how much we're requesting, even if we're overshooting it a little bit *)
			gatheredSolventsAndVolumes = GatherBy[Transpose[{resolvedSolvent, myVolumes, resolvedSolventContainer}], #[[1]]&];

			(* make the solvent resources; this is NOT index matched with resolvedSolvent yet because we have no duplicates *)
			(* for whatever reason, if you're making a resource for water, you have to specify the container too; we _could_ be using water here, so in that case use the preferred vessel *)
			gatheredSolventResources = Map[
				With[{sample = #[[1, 1]], volume = Total[#[[All, 2]]], container = #[[1, 3]]},
					If[MatchQ[sample, WaterModelP] && NullQ[container],
						Resource[
							Sample -> sample,
							Amount -> volume,
							Container -> PreferredContainer[volume],
							Name -> ToString[Unique[]]
						],
						Resource[
							Sample -> sample,
							Amount -> volume,
							Container -> container,
							Name -> ToString[Unique[]]
						]
					]
				]&,
				gatheredSolventsAndVolumes
			];
			solventResourceReplaceRules = MapThread[
				#1 -> #2&,
				{gatheredSolventsAndVolumes[[All, 1, 1]], gatheredSolventResources}
			];

			(* get the solvent resources in the proper format *)
			solventResources = resolvedSolvent /. solventResourceReplaceRules;

			(* Make packets for the transfer primitives. *)
			(* NOTE: Once again this is an excerpt from the resource packets function, just for the important fields that *)
			(* are error proof. *)
			fillToVolumeUnitOperations = MapThread[
				Function[{sample, solvent, volume},
					FillToVolume[
						(* we will now treat water as a normal resource now (dealt by RP framework, WaterPrep task), so is in Transfer, so we should pass the resource blob in regardless *)
						Solvent -> {Link[solvent]},
						Sample -> {Link[sample]},
						(* note that this is different from the ExperimentFillToVolume call *)
						(* this is because in ExperimentFTV, we put the volume of only the first transfer, which almost definitely undershoots the amount we actually need to add *)
						(* by including the full amount here, we don't underestimate what we need in the simulation and avoid issues in the future *)
						TotalAmount -> {volume}
					]
				],
				{
					samplesInResources,
					solventResources,
					myVolumes
				}
			];
			fillToVolumeUnitOperationPackets = UploadUnitOperation[
				fillToVolumeUnitOperations,
				UnitOperationType -> Batched,
				Upload -> False,
				FastTrack -> True
			];

			(* Make the transfer primitives. *)
			protocolPacket = <|
				Object -> protocolObject,
				Replace[SamplesIn] -> (Link[#, Protocols]& /@ samplesInResources),
				Replace[ContainersIn] -> (Link[#, Protocols]& /@ containersInResources),
				Replace[TotalVolumes] -> myVolumes,
				Replace[Solvents] -> (Link[#]& /@ solventResources),
				Replace[BatchedUnitOperations] -> (Link[#, Protocol]&) /@ Lookup[fillToVolumeUnitOperationPackets, Object],
				Replace[RequiredObjects] -> (Link[#]& /@ DeleteDuplicates[
					Cases[fillToVolumeUnitOperationPackets, Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]], Infinity]
				]),
				Replace[RequiredInstruments] -> (Link[#]& /@ DeleteDuplicates[
					Cases[fillToVolumeUnitOperationPackets, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]
				]),
				ResolvedOptions -> myResolvedOptions
			|>;

			SimulateResources[protocolPacket, fillToVolumeUnitOperationPackets, Simulation -> inheritedSimulation]
		],
		SimulateResources[myResourcePacket, myUnitOperationPackets, Simulation -> inheritedSimulation]
	];

	(* Download information from our simulated resources. *)
	{
		simulatedUnitOperationPackets,
		simulatedSourceSamplePackets,
		simulatedSourceContainerPackets,
		simulatedDestinationSamplePackets,
		simulatedDestinationContainerPackets
	}=Quiet[
		Download[
			protocolObject,
			{
				Packet[BatchedUnitOperations[{SolventLink, SampleLink}]],
				Packet[BatchedUnitOperations[SolventLink][[1]][{Model, State, Container, Name, Contents, Volume, Mass, Position}]],
				Packet[BatchedUnitOperations[SolventLink][[1]][Container][{Model, State, Name, Contents}]],
				Packet[BatchedUnitOperations[SampleLink][[1]][{Model, State, Container, Name, Volume, Mass, Position}]],
				Packet[BatchedUnitOperations[SampleLink][[1]][Container][{Model, State, Name, Contents}]]
			},
			Simulation->currentSimulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	simulatedSourceAndDestinationCache = FlattenCachePackets[{
		simulatedSourceSamplePackets,
		simulatedSourceContainerPackets,
		simulatedDestinationSamplePackets,
		simulatedDestinationContainerPackets
	}];

	(* Make a fake water sample with 20L of volume so that we can use it whenever we are asked to transfer in *)
	(* Model[Sample, "Milli-Q water"] since we don't actually make a resource for our water sample if we're going to *)
	(* get it straight from the water purifier. Also make a fake waste sample. *)
	fakeContainerPackets = UploadSample[
		{Model[Container, Vessel, "id:3em6Zv9NjjkY"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]},
		{
			{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]}, (* Object[Container, Room, "Empty Room for Simulated Objects"] *)
			{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]} (* Object[Container, Room, "Empty Room for Simulated Objects"] *)
		},
		FastTrack -> True,
		SimulationMode -> True,
		Upload -> False
	];
	{fakeWaterSampleContainerObject, fakeWasteSampleContainerObject} = Lookup[fakeContainerPackets[[1;;2]], Object];

	(* Update it with the container packets. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[fakeContainerPackets]];

	(* Put some water in our container. *)
	fakeWaterAndWastePackets = UploadSample[
		{
			Model[Sample, "Milli-Q water"],
			Model[Sample, "Milli-Q water"]
		},
		{
			{"A1", fakeWaterSampleContainerObject},
			{"A1", fakeWasteSampleContainerObject}
		},
		State->Liquid,
		InitialAmount->{20 Liter, Null},
		Simulation -> currentSimulation,
		FastTrack -> True,
		Upload -> False,
		SimulationMode -> True
	];

	{fakeWaterSample, fakeWasteSample} = Lookup[fakeWaterAndWastePackets[[1;;2]], Object];

	(* Update it with the sample packets. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[fakeWaterAndWastePackets]];

	(* We SHOULD be guarenteed to always have samples in our source containers. If this is not the case, we will have *)
	(* thrown an error about it in our resolver function and we just need to do something in our simulation function *)
	(* to not crash. If we don't find a sample, just transfer from our giant water sample. *)
	{solventSamples, solventContainers} = Transpose[Map[
		Function[{simulatedSource},
			Module[{simulatedSourcePacket},
				(* get the simulated source packet*)
				simulatedSourcePacket = fetchPacketFromCache[simulatedSource, simulatedSourceAndDestinationCache];

				Sequence @@ Switch[simulatedSource,
					ObjectP[Object[Sample]],
						{{Lookup[simulatedSourcePacket, Object], Download[Lookup[simulatedSourcePacket, Container], Object]}},
					ObjectP[Object[Container]],
						Map[
							{
								(* Get the sample that's in the well of this container. If we can't find it, fall back on our giant water sample. *)
								FirstCase[
									Lookup[simulatedSourcePacket, Contents],
									{#, obj_} :> Download[obj, Object],
									fakeWaterSample
								],
								Download[simulatedSource, Object]
							}&,
							Lookup[simulatedSourcePacket, Contents][[All, 1]]
						],
					(* If we don't have a sample or a container (should be Null), it signifies that we're going to use the water purifier. *)
					_,
						{{fakeWaterSample, fakeWaterSampleContainerObject}}
				]
			]
		],
		Lookup[simulatedUnitOperationPackets, SolventLink][[All, 1]]
	]];

	(* these guys are going to exist already so we're fine (different from ExperimentTransfer) *)
	destinationSamples = Lookup[simulatedDestinationSamplePackets, Object];
	destinationContainers = Lookup[simulatedDestinationContainerPackets, Object];

	(* get the amount that we are transferring in; if the destination sample is a liquid then we're doing the difference between myVolumes and its current volume; otherwise use myVolumes *)
	amountsToTransfer = MapThread[
		If[VolumeQ[Lookup[#1, Volume]],
			Max[{#2 - Lookup[#1, Volume], 0.1 Microliter}],
			#2
		]&,
		{simulatedDestinationSamplePackets, myVolumes}
	];

	(* Call UploadSampleTransfer on our source and destination samples. *)
	(* This will cause some small error if we start from solid sample, because solvent volume is incorrect; will fix later *)
	uploadSampleTransferPackets = UploadSampleTransfer[
		solventSamples,
		destinationSamples,
		amountsToTransfer,
		Upload -> False,
		FastTrack -> True,
		Simulation -> currentSimulation
	];

	(* Update our simulation. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

	(* Correct the total volume. This is important because it will affect the TotalVolume of StockSolution, if we are using FillToVolume UO *)
	(* Composition is hard to correct, in most cases we assume the discrepancy is negligeegible *)
	volumeCorrectionPackets = UploadSampleProperties[destinationSamples, Volume -> myVolumes, Simulation -> currentSimulation, Upload -> False];
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[volumeCorrectionPackets]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SolventLabel], solventSamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SolventContainerLabel], solventContainers}],
				{_String, ObjectP[]}
			],

			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], destinationSamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], destinationContainers}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SolventLabel], (Field[SolventLink[[#]]]&) /@ Range[Length[solventSamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SolventContainerLabel], (Field[SolventContainerLink[[#]]]&) /@ Range[Length[solventContainers]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&) /@ Range[Length[destinationSamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleContainerLink[[#]]]&) /@ Range[Length[destinationContainers]]}],
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
(*Sister functions*)


DefineOptions[ExperimentFillToVolumeOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {ExperimentFillToVolume}
];

ExperimentFillToVolumeOptions[mySample : ObjectP[{Object[Sample], Object[Container], Model[Sample]}], myVolume : VolumeP, myOptions : OptionsPattern[ExperimentFillToVolumeOptions]]:=ExperimentFillToVolumeOptions[{mySample}, {myVolume}, myOptions];
ExperimentFillToVolumeOptions[mySamples : {ObjectP[{Object[Sample], Object[Container], Model[Sample]}]..}, myVolume : VolumeP, myOptions : OptionsPattern[ExperimentFillToVolumeOptions]] := ExperimentFillToVolumeOptions[mySamples, ConstantArray[myVolume, Length[mySamples]], myOptions];
ExperimentFillToVolumeOptions[mySamples : {ObjectP[{Object[Sample], Object[Container], Model[Sample]}]..}, myVolumes : {VolumeP..}, myOptions : OptionsPattern[ExperimentFillToVolumeOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentFillToVolume *)
	options = ExperimentFillToVolume[mySamples, myVolumes, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentFillToVolume],
		options
	]
];

ExperimentFillToVolumePreview[mySample : ObjectP[{Object[Sample], Object[Container], Model[Sample]}], myVolume : VolumeP, myOptions : OptionsPattern[ExperimentFillToVolumePreview]]:=ExperimentFillToVolume[mySample, myVolume, Append[ToList[myOptions], Output -> Preview]];
ExperimentFillToVolumePreview[mySamples : {ObjectP[{Object[Sample], Object[Container], Model[Sample]}]..}, myVolume : VolumeP, myOptions : OptionsPattern[ExperimentFillToVolumePreview]] := ExperimentFillToVolume[mySamples, ConstantArray[myVolume, Length[mySamples]], Append[ToList[myOptions], Output -> Preview]];
ExperimentFillToVolumePreview[mySamples : {ObjectP[{Object[Sample], Object[Container], Model[Sample]}]..}, myVolumes : {VolumeP..}, myOptions : OptionsPattern[ExperimentFillToVolumePreview]] := ExperimentFillToVolume[mySamples, myVolumes, Append[ToList[myOptions], Output -> Preview]];


DefineOptions[ValidExperimentFillToVolumeQ,
	Options :> {VerboseOption, OutputFormatOption},
	SharedOptions :> {ExperimentFillToVolume}
];

ValidExperimentFillToVolumeQ[mySample : ObjectP[{Object[Sample], Object[Container], Model[Sample]}], myVolume : VolumeP, myOptions : OptionsPattern[ValidExperimentFillToVolumeQ]]:=ValidExperimentFillToVolumeQ[{mySample}, {myVolume}, myOptions];
ValidExperimentFillToVolumeQ[mySamples : {ObjectP[{Object[Sample], Object[Container], Model[Sample]}]..}, myVolume : VolumeP, myOptions : OptionsPattern[ValidExperimentFillToVolumeQ]] := ValidExperimentFillToVolumeQ[mySamples, ConstantArray[myVolume, Length[mySamples]], myOptions];
ValidExperimentFillToVolumeQ[mySamples : {ObjectP[{Object[Sample], Object[Container], Model[Sample]}]..}, myVolumes : {VolumeP..}, myOptions : OptionsPattern[ValidExperimentFillToVolumeQ]] := Module[
	{listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[mySamples];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentFillToVolume *)
	filterTests = ExperimentFillToVolume[mySamples, myVolumes, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[filterTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, filterTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMassSpectrometryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentFillToVolumeQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentFillToVolumeQ"]
];
