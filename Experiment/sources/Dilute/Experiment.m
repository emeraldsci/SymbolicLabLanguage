(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentDilute*)


(* ::Subsubsection:: *)
(*ExperimentDilute Options and Messages*)


DefineOptions[ExperimentDilute,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Amount,
				Default -> Automatic,
				Description -> "The amount of a sample that should be diluted with a diluent. Note that if the Amount is set to less than All, the diluent is added to the source sample to attain the proper concentration for the entire sample, and the amount of mixture with the portion of original sample corresponding to Amount is transferred to the new container.",
				ResolutionDescription -> "Automatically set to the current volume of the sample, or the value necessary to reach the specified TargetConcentration.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 20 Liter],
						Units -> {1, {Milliliter, {Nanoliter, Microliter, Milliliter, Liter}}}
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				]
			},
			{
				OptionName -> TargetConcentration,
				Default -> Automatic,
				Description -> "The desired final concentration of analyte after dilution of the input samples with the Diluent.",
				ResolutionDescription -> "Automatically calculated based on Amount and Volume options.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Molar] | GreaterP[0 Gram / Liter],
					Units -> Alternatives[
						{1, {Micromolar, {Micromolar, Millimolar, Molar}}},
						CompoundUnit[
							{1, {Gram, {Gram, Microgram, Milligram}}},
							{-1, {Liter, {Liter, Microliter, Milliliter}}}
						]
					]
				]
			},
			{
				OptionName -> TargetConcentrationAnalyte,
				Default -> Automatic,
				Description -> "The substance whose final concentration is attained with the TargetConcentration option.",
				ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[IdentityModelTypes],
					ObjectTypes -> IdentityModelTypes,
					PreparedSample -> False,
					PreparedContainer -> False
				]
			},
			{
				OptionName -> TotalVolume,
				Default -> Automatic,
				Description -> "The desired total volume of the sample plus diluent. Note that if the Amount is set to less than All, the diluent is added to the source sample to attain the proper concentration for the entire sample, and TotalVolume mixture is transferred to the new container, and the portion of original sample corresponding in it equals to Amount.",
				ResolutionDescription -> "Automatically determined based on the TargetConcentration option values. If not specified and TargetConcentration is also not specified, an error is thrown.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 20 Liter],
					Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
				]
			},
			(* need this hidden option to pass the value from the resolver into the resource packets function *)
			{
				OptionName -> InitialVolume,
				Default -> Automatic,
				Description -> "The amount of liquid that goes into the initial container, prior to any potential transfers to a new container. If transferring to a new container and Amount is not set to All, then the difference between InitialVolume and TotalVolume will remain in the source container.",
				ResolutionDescription -> "Automatically set to TotalVolume if resuspending in the same container or if Amount -> All.  Automatically set to TotalVolume / (Amount / (total amount of sample)) otherwise.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 20 Liter],
					Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
				],
				Category -> "Hidden"
			},
			{
				OptionName -> ContainerOut,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]},
						PreparedSample -> False,
						PreparedContainer -> True,
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					{
						"Index" -> Alternatives[
							Widget[
								Type -> Number,
								Pattern :> GreaterEqualP[1, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						],
						"Container" -> Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Container], Object[Container]}],
								ObjectTypes -> {Model[Container], Object[Container]},
								PreparedSample -> False,
								PreparedContainer -> True,
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Containers"
									}
								}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				],
				Description -> "The desired type of container that should be used to prepare and house the diluted samples, with indices indicating grouping of samples in the same plates, if desired.",
				ResolutionDescription -> "Automatically set to the current container of the input sample."
			},
			{
				OptionName -> DestinationWell,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Description -> "The desired position in the corresponding ContainerOut in which the resuspended samples will be placed.",
				ResolutionDescription -> "Automatically set to the current position of the input sample if ContainerOut is the current container of the input sample.  Otherwise set to A1 in vessels, or an empty well of the specified plate."
			},
			{
				OptionName -> Diluent,
				Default -> Automatic,
				Description -> "The sample that should be added to the input sample, where the volume of this sample added is the TotalVolume option - the current sample volume.",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is not specified; otherwise set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				]
			},
			{
				OptionName -> ConcentratedBuffer,
				Default -> Null,
				Description -> "The concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the TotalVolume.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Buffers"
						}
					}
				]
			},

			{
				OptionName -> BufferDilutionFactor,
				Default -> Automatic,
				Description -> "The dilution factor by which the concentrated buffer should be diluted in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the TotalVolume.",
				ResolutionDescription -> "If ConcentratedBuffer is specified, automatically set to the ConcentratedBufferDilutionFactor of that sample; otherwise, set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> GreaterEqualP[1]
				]
			},
			{
				OptionName -> BufferDiluent,
				Default -> Automatic,
				Description -> "The buffer used to dilute the sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution. The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the TotalVolume.",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is specified; otherwise, resolves to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				]
			},
			(* mixing of the post-dilution samples *)
			{
				OptionName -> Mix,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if mixing of the diluted samples will occur.",
				Category -> "Incubation and Mixing"
			},
			{
				OptionName -> MixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> MixTypeP
				],
				Description -> "The style of motion used to mix the diluted samples solution following addition of liquid.",
				ResolutionDescription -> "Automatically set based on the Volume option and size of the container in which the sample is prepared.",
				Category -> "Incubation and Mixing"
			},
			{
				OptionName->NumberOfMixes,
				Default->Automatic,
				Widget->Widget[
					Type->Number,
					Pattern:>GreaterEqualP[0,1]
				],
				Description->"Determines the number of times the sample is mixed for discrete mixing processes such as Pipette or Invert.",
				AllowNull->True,
				Category -> "Incubation and Mixing"
			},
			
			(*Changed description to reference MaxIncubationTime instead of MaxMixTime*)
			{
				OptionName -> MixUntilDissolved,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sample should be mixed in an attempt to thoroughly mix the sample with the diluent.",
				ResolutionDescription -> "Automatically set to True if MaxIncubationTime is specified, or False otherwise.",
				Category -> "Incubation and Mixing"
			},
			{
				OptionName -> IncubationTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Hour, 72 Hour],
					Units -> {1, {Minute, {Second, Minute, Hour}}}
				],
				Description -> "The duration for which the sample should be mixed/incubated following addition of liquid.",
				ResolutionDescription -> "Automatically set to 30 minutes unless MixType is set to Pipette, Swirl or Invert, in which case it is set to Null.",
				Category -> "Incubation and Mixing"
			},
			{
				OptionName -> MaxIncubationTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Second, 72 Hour],
					Units -> {1, {Minute, {Second, Minute, Hour}}}
				],
				Description -> "The maximum duration for which the samples should be mixed/incubated in an attempt to dissolve any solid components following addition of liquid.",
				ResolutionDescription -> "Automatically set based on the MixType if MixUntilDissolved is set to True. If MixUntilDissolved is False, resolves to Null.",
				Category -> "Incubation and Mixing"
			},
			{
				OptionName -> IncubationInstrument,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Instruments",
							"Mixing Devices"
						}
					}
				],
				Description -> "The instrument that should be used to incubate the sample following addition of liquid.",
				ResolutionDescription -> "Automatically set to an appropriate instrument based on container model and MixType, or Null if Mix is set to False.",
				Category -> "Incubation and Mixing"
			},
			{
				OptionName -> IncubationTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[$MinIncubationTemperature, $MaxIncubationTemperature],
						Units -> {1, {Celsius, {Celsius, Fahrenheit}}}
					],
					Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
				],
				Description -> "Temperature at which the sample should be mixed/incubated for the duration of the IncubationTime following addition of liquid.",
				ResolutionDescription -> "Automatically set to Ambient, or Null if Mix is set to False or MixType is set to Pipette, Swirl or Invert.",
				Category -> "Incubation and Mixing"
			},
			{
				OptionName -> AnnealingTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, 72 Hour],
					Units -> {1, {Minute, {Minute, Hour}}}
				],
				Description -> "Minimum duration for which the sample should remain in the incubator allowing the system to settle to room temperature after the MixTime has passed if mixing while incubating.",
				ResolutionDescription -> "Automatically resolves to 0 Minute, or Null if Mix is set to False.",
				Category -> "Incubation and Mixing"
			},
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description -> "The label of the sample that is used for the dilution.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description -> "The label of the ssample's container that is used for the dilution.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> SampleOutLabel,
				Default -> Automatic,
				Description -> "The label of the sample(s) that become the SamplesOut.",
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
				OptionName -> ContainerOutLabel,
				Default -> Automatic,
				Description -> "The label of the container that holds the sample that becomes the SamplesOut.",
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
				OptionName -> DiluentLabel,
				Default -> Automatic,
				Description -> "The label of the diluent added to the sample.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> ConcentratedBufferLabel,
				Default -> Automatic,
				Description -> "The label of the concentrated buffer that is diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent).",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			{
				OptionName -> BufferDiluentLabel,
				Default -> Automatic,
				Description -> "The label of the buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			}
		],
		{
			OptionName -> MixOrder,
			Default -> Parallel,
			Description -> "Indicates if mixing/incubating are done for one sample after addition of liquid before advancing to the next (Serial) or all at once after liquid is added to all samples (Parallel).",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> ReadOrderP],
			Category -> "Mixing"
		},
		{
			OptionName -> ResolveMethod,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "If True, this resolver is being called as part of resolveDiluteMethod, and all messages should be suppressed.",
			Category -> "Hidden"
		},
		PreparationOption,
		ModelInputOptions,
		(* don't actually want this exposed to the customer, but do need it under the hood for ModelInputOptions to work *)
		ModifyOptions[
			PreparatoryUnitOperationsOption,
			Category -> "Hidden"
		],
		SamplesOutStorageOption,
		NonBiologyPostProcessingOptions,
		ProtocolOptions,
		WorkCellOption,
		SubprotocolDescriptionOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		SimulationOption,
		QueuePositionOption
	}
];


(* ::Subsubsection:: *)
(*ExperimentDilute*)


Error::DiluteTotalVolumeOverContainerMax = "Some of the specified volumes (`1`), exceed the max volume that the ContainerOut option, `2`, can hold (`3`). Please either lower these volumes to a value below `3` or specifiy ContainerOut to a container that is large enough to hold these volumes.";
Error::CannotResolveTotalVolume = "The TotalVolume option was left unspecified and cannot be calculated for the following sample(s): `1`.  Please specify the TotalVolume option directly, or use the TargetConcentration and Volume options to allow for it to be calculated.";
Error::DiluteInitialVolumeOverContainerMax = "In order to dilute the specified amounts of the following sample(s) in the volume specified by the TotalVolume option, the total volume in the current container after liquid addition (`1`) exceeds the container's maximum volume (`2`) (`3`).  Please set the TotalVolume to a smaller value or increase the TargetConcentration of the sample(s).";
Error::DilutePreparationInvalid = "The specified Preparation requests Robotic, but some of the mix settings, input containers or ContainerOut containers are not compatible with Robotic.  Please change to Manual, or first change the input or output containers.";


(*
	Single Sample with No Second Input:
		- Takes a single sample and passes through to core overload
*)
ExperimentDilute[mySample : ObjectP[Object[Sample]], myOptions : OptionsPattern[ExperimentDilute]] := ExperimentDilute[{mySample}, myOptions];

(*
	CORE OVERLOAD: List Sample with No Second Input (all options):
		- Core functionality lives here
		- If initial experiment call involved volume/concentration second inputs, these will be in option values for this overload
*)
ExperimentDilute[mySamples : {ObjectP[Object[Sample]]..}, myOptions : OptionsPattern[ExperimentDilute]] := Module[
	{
		specifiedDiluent, specifiedContainerOut, inheritedCache,
		allBufferModels, allBufferObjs, containerOutModels, containerOutObjs, allDownloadValues, newCache, listedOptions,
		listedSamples, outputSpecification, output, gatherTests, messages, safeOptionTests, upload, confirm, canaryBranch, fastTrack,
		parentProt, validLengthTests, combinedOptions, expandedCombinedOptions,
		safeOptions, validLengths, unresolvedOptions, applyTemplateOptionTests, initialLiquidHandlers,
		preferredVesselContainerModels, sampleFields, modelFields,
		containerFields, containerModelFields, concentratedBuffer, bufferDiluent, resolveOptionsResult,
		resolvedOptionsNoHidden, returnEarlyQ, resolvedOptions, resolutionTests, finalizedPackets, runTime, resourcePacketTests,
		allTests, validQ, previewRule, optionsRule, testsRule, resultRule, safeOpsWithNames,
		samplesWithoutTemporalLinks, optionsWithoutTemporalLinks,preparation,workCell,resolveMethod,
		performSimulationQ,resultQ,resourcePacketsResult,updatedSimulation,simulationResult,simulatedProtocol, newSimulation,
		resolvedOptionsWithHidden, simulationRule, runTimeRule, validSamplePreparationResult,
		samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, resourcePacketsSimulation,
		constellationMessageRule, experimentFunction
	},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	resolveMethod = Lookup[ToList[myOptions], ResolveMethod, False];
	messages = Not[gatherTests] && Not[resolveMethod];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{samplesWithoutTemporalLinks, optionsWithoutTemporalLinks} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentDilute,
			samplesWithoutTemporalLinks,
			optionsWithoutTemporalLinks
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
	{safeOpsWithNames, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentDilute, optionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentDilute, optionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* change all Names to objects *)
	{listedSamples, safeOptions, listedOptions} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOpsWithNames, optionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if the option lengths are invalid, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> updatedSimulation
		}]
	];

	(* call ValidInputLengthsQ to make sure all the options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentDilute, {listedSamples}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentDilute, {listedSamples}, listedOptions], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[Not[validLengths],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> updatedSimulation
		}]
	];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache} = Lookup[safeOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* apply the template options *)
	(* need to specify the definition number (we are number 6 for samples at this point *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentDilute, {listedSamples}, optionsWithoutTemporalLinks, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentDilute, {listedSamples}, optionsWithoutTemporalLinks, Output -> Result], Null}
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentDilute, {listedSamples}, combinedOptions]];

	(* --- Make our one big Download call --- *)

	(* pull out the Diluent, ConcentratedBuffer, BufferDiluent, and ContainerOut options *)
	{specifiedDiluent, concentratedBuffer, bufferDiluent, specifiedContainerOut} = Lookup[expandedCombinedOptions, {Diluent, ConcentratedBuffer, BufferDiluent, ContainerOut}];

	(* get all the buffers that were specified as models and objects *)
	allBufferModels = Cases[Flatten[{specifiedDiluent, concentratedBuffer, bufferDiluent}], ObjectP[Model[Sample]]];
	allBufferObjs = Cases[Flatten[{specifiedDiluent, concentratedBuffer, bufferDiluent}], ObjectP[Object[Sample]]];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Object[Container]]];

	(* get the liquid handlers we might need to download info from; Search for disposable-tip models *)
	initialLiquidHandlers = Search[Model[Instrument, LiquidHandler], Deprecated != True && TipType == DisposableTip];

	(* if the Container option is Automatic, we might end up calling PreferredContainer; so we've gotta make sure we download info from all the objects it might spit out *)
	preferredVesselContainerModels = If[MatchQ[specifiedContainerOut, Automatic] || MemberQ[Flatten[ToList[specifiedContainerOut]], Automatic],
		PreferredContainer[All],
		{}
	];

	(* get the Object[Sample], Model[Sample], Object[Container], and Model[Container] fields I need *)
	sampleFields = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], MassConcentration, Concentration, StorageCondition, ThawTime, ThawTemperature,TransportTemperature, LightSensitive];
	modelFields = Packet[Model[{SamplePreparationCacheFields[Model[Sample], Format -> Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock}]];
	containerFields = Packet[Container[{SamplePreparationCacheFields[Object[Container], Format -> Sequence], Position}]];
	containerModelFields = Packet[Container[Model][{SamplePreparationCacheFields[Model[Container], Format -> Sequence]}]];

	(* make the Download call on all the samples, containers, and buffers *)
	allDownloadValues = Check[
		Quiet[
			Download[
				{
					Flatten[listedSamples],
					allBufferModels,
					allBufferObjs,
					containerOutModels,
					containerOutObjs,
					initialLiquidHandlers,
					preferredVesselContainerModels
				},
				Evaluate[{
					{
						sampleFields,
						modelFields,
						containerFields,
						containerModelFields,
						Packet[Field[Composition[[All, 2]][MolecularWeight,ExtinctionCoefficients]]]
					},
					{
						Packet[SamplePreparationCacheFields[Model[Sample], Format -> Sequence], UsedAsSolvent, ConcentratedBufferDiluent, ConcentratedBufferDilutionFactor, BaselineStock]
					},
					{
						sampleFields,
						modelFields,
						containerFields,
						containerModelFields
					},
					{
						Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]]
					},
					{
						Packet[SamplePreparationCacheFields[Object[Container], Format -> Sequence], Position],
						Packet[Model[{SamplePreparationCacheFields[Model[Container], Format -> Sequence]}]]
					},
					{Packet[Name, TipType, MaxVolume, MaxDefaultTransfers]},
					{
						Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]]
					}
				}],
				Cache -> inheritedCache,
				Simulation -> updatedSimulation,
				Date -> Now
			],
			{Download::FieldDoesntExist}
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

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolveExperimentResuspendOrDiluteOptions[Dilute, listedSamples, expandedCombinedOptions, Output -> {Result, Tests},  Simulation -> updatedSimulation, Cache -> newCache],
			{resolveExperimentResuspendOrDiluteOptions[Dilute, listedSamples, expandedCombinedOptions, Output -> Result,  Simulation -> updatedSimulation, Cache -> newCache], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(*get rid of Incubate in resolvedOptions if it exists there*)
	If[KeyExistsQ[Association[resolvedOptions],Incubate],
		resolvedOptions = Normal[KeyDrop[Association[resolvedOptions],Incubate]]
	];

	(* pull out the Preparation option *)
	{preparation, workCell} = Lookup[resolvedOptions, {Preparation, WorkCell}];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveExperimentResuspendOrDiluteOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentDilute,
		RemoveHiddenOptions[ExperimentDilute, resolvedOptions],
		Messages -> False
	];

	resolvedOptionsWithHidden = CollapseIndexMatchedOptions[
		ExperimentDilute,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolveOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolutionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		resolveMethod, True,
		True, False
	];

	(* NOTE: We need to perform simulation if Result is asked for in Aliquot since it's part of the SamplePreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
	performSimulationQ = MemberQ[output, Result|Simulation];
	(* If we did get the result, we should try to quiet messages in simulation so that we will not duplicate them. We will just silently update our simulation *)
	resultQ = MemberQ[output, Result];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ && resolveMethod,
		Return[outputSpecification /. {
			Result -> $Failed,
			Options -> resolvedOptionsNoHidden,
			Preview -> Null,
			Tests -> Flatten[{safeOptionTests, applyTemplateOptionTests, validLengthTests, resolutionTests}],
			Simulation->Simulation[]
		}]
	];

	(* call the resuspendOrDiluteResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	resourcePacketsResult = Check[
		{{finalizedPackets,runTime}, resourcePacketsSimulation, resourcePacketTests} = Which[
			(* if we're inside the work cell resolver then don't bother with this *)
			(MatchQ[preparation, Robotic] && Not[MemberQ[output, Result|Simulation]]) || MatchQ[resolveOptionsResult, $Failed] || returnEarlyQ, {{$Failed,$Failed}, updatedSimulation, {}},
			Not[MemberQ[output, Result]] && MemberQ[output, Options] && Not[MemberQ[output, Simulation]] && gatherTests, shortcutResuspendResourcePackets[Dilute,listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation, Tests}], Cache -> newCache, Simulation -> updatedSimulation],
			Not[MemberQ[output, Result]] && MemberQ[output, Options] && Not[MemberQ[output, Simulation]], {shortcutResuspendResourcePackets[Dilute,listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> Result], Cache -> newCache, Simulation -> updatedSimulation], updatedSimulation, Null},
			gatherTests, resuspendOrDiluteResourcePackets[Dilute,listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation, Tests}], Cache -> newCache, Simulation -> updatedSimulation],
			True, {Sequence @@ resuspendOrDiluteResourcePackets[Dilute,listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation}], Cache -> newCache, Simulation -> updatedSimulation], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];


	(* if we asked for a simulation, then return a simulation *)
	simulationResult = Check[
		{simulatedProtocol, newSimulation} = Which[
			performSimulationQ&&!resultQ,
			simulateExperimentResuspend[
				Dilute,
				If[MatchQ[finalizedPackets, $Failed] || MemberQ[Flatten[finalizedPackets], $Failed|Null],
					$Failed,
					finalizedPackets[[1]](* protocol packet*)
				],
				If[MatchQ[finalizedPackets, $Failed] || MemberQ[Flatten[finalizedPackets], $Failed],
					$Failed,
					Rest[finalizedPackets]
				],
				(* in case we're not in pooled form yet, needs to be now *)
				ToList /@ listedSamples,
				resolvedOptions,
				Cache -> newCache,
				Simulation -> resourcePacketsSimulation
			],
			performSimulationQ&&resultQ,
			Quiet[
				simulateExperimentResuspend[
					Dilute,
					If[MatchQ[finalizedPackets, $Failed] || MemberQ[Flatten[finalizedPackets], $Failed|Null],
						$Failed,
						finalizedPackets[[1]](* protocol packet*)
					],
					If[MatchQ[finalizedPackets, $Failed] || MemberQ[Flatten[finalizedPackets], $Failed],
						$Failed,
						Rest[finalizedPackets]
					],
					(* in case we're not in pooled form yet, needs to be now *)
					ToList /@ listedSamples,
					resolvedOptions,
					Cache -> newCache,
					Simulation -> resourcePacketsSimulation
				]
			],
			True,
			{Null, Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
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
		MatchQ[finalizedPackets, $Failed] || MemberQ[Flatten[finalizedPackets], $Failed]|| MatchQ[simulationResult, $Failed]|| MatchQ[resourcePacketsResult, $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"ExperimentDilute" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Which[
		MemberQ[output, Options] && MatchQ[preparation, Robotic], resolvedOptionsWithHidden,
		MemberQ[output, Options], resolvedOptionsWithHidden,
		True, Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the simulation rule*)
	simulationRule = Simulation -> If[performSimulationQ,
		newSimulation,
		Null
	];

	runTimeRule=RunTime->runTime;

	(* Set a rule for the ConstellationMessage since we can generate different protocol types. *)
	constellationMessageRule = ConstellationMessage -> {
		Object[Protocol, RoboticSamplePreparation], Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]
	};

	(* note that we are NOT calling UploadProtocol here because the ExperimentSamplePreparation call already did that so no need to do it again *)
	resultRule = Result -> Which[
		Not[validQ], $Failed,
		Not[MemberQ[output, Result]], $Failed,
		(* if we're doing Preparation -> Robotic, return all our unit operation packets without RequireResources called if Upload -> False *)
		MatchQ[preparation, Robotic] && MatchQ[upload, False],
			Rest[finalizedPackets],
		(* if we are doing Preparation -> Robotic and Upload -> True, then call ExperimentRoboticSamplePreparation on the aliquot unit operations *)
		MatchQ[preparation, Robotic],
			Module[{unitOperation, nonHiddenOptions, unsortedPackets, allPackets, samplesMaybeWithModels, experimentFunction},

				(* convert the samples to models if we had model inputs originally *)
				(* if we don't have a simulation or a single prep unit op, then we know we didn't have a model input *)
				(* NOTE: this is important: need to use the simulation from before the resource packets function to do this sample -> model conversion, because we had to do some label shenanigans in the resource packets function that made the label-deconvolution here _not_ work *)
				(* otherwise, the same label will point at two different IDs, and that's going to cause problems *)
				samplesMaybeWithModels = If[NullQ[updatedSimulation] || Not[MatchQ[Lookup[resolvedOptions, PreparatoryUnitOperations], {_[_LabelSample]}]],
					samplesWithoutTemporalLinks,
					simulatedSamplesToModels[
						Lookup[resolvedOptions, PreparatoryUnitOperations][[1, 1]],
						updatedSimulation,
						samplesWithoutTemporalLinks
					]
				];

				unitOperation = Dilute @@ Join[
					{
						Sample -> samplesMaybeWithModels
					},
					RemoveHiddenPrimitiveOptions[Dilute, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentDilute, resolvedOptionsNoHidden];

				(* Memoize the value of ExperimentDilute so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentDilute, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentDilute]={};

					ExperimentDilute[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification /. {
							Result -> Rest[finalizedPackets],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> newSimulation,
							RunTime -> runTime,
							Tests -> allTests
						}
					];

					(* pick the corresponding function from the association above *)
					experimentFunction = Lookup[$WorkCellToExperimentFunction, workCell];

					unsortedPackets = experimentFunction[
						{unitOperation},
						Name -> Lookup[safeOptions, Name],
						Upload -> False,
						Confirm -> False,
						CanaryBranch -> Lookup[safeOptions, CanaryBranch],
						ParentProtocol -> Lookup[safeOptions, ParentProtocol],
						Priority -> Lookup[safeOptions, Priority],
						StartDate -> Lookup[safeOptions, StartDate],
						HoldOrder -> Lookup[safeOptions, HoldOrder],
						QueuePosition -> Lookup[safeOptions, QueuePosition],
						ImageSample -> Lookup[resolvedOptions, ImageSample],
						MeasureVolume -> Lookup[resolvedOptions, MeasureVolume],
						MeasureWeight -> Lookup[resolvedOptions, MeasureWeight],
						Cache -> newCache
					];

					(* get all the packets together *)
					allPackets = Flatten[{
						First[unsortedPackets],
						Rest[unsortedPackets]
					}];

					If[upload,
						(
							Upload[allPackets, constellationMessageRule];
							If[confirm, UploadProtocolStatus[Lookup[First[allPackets], Object], OperatorStart, Upload -> True, FastTrack -> True, UpdatedBy -> If[NullQ[parentProt], $PersonID, parentProt]]];
							Lookup[First[allPackets], Object]
						),
						allPackets
					]
				]
			],
		(* don't need to call ExperimentManualSamplePreparation here because we already called it in the resource packet sfunction*)
		MatchQ[preparation, Manual] && MemberQ[output, Result] && upload && StringQ[Lookup[resolvedOptions, Name]],
			(
				Upload[finalizedPackets, constellationMessageRule];
				If[confirm, UploadProtocolStatus[Lookup[First[finalizedPackets], Object], OperatorStart, Upload -> True, FastTrack -> True, UpdatedBy -> If[NullQ[parentProt], $PersonID, parentProt]]];
				Append[Lookup[First[finalizedPackets], Type], Lookup[resolvedOptions, Name]]
			),
		MatchQ[preparation, Manual] && MemberQ[output, Result] && upload,
			(
				Upload[finalizedPackets, constellationMessageRule];
				If[confirm, UploadProtocolStatus[Lookup[First[finalizedPackets], Object], OperatorStart, Upload -> True, FastTrack -> True, UpdatedBy -> If[NullQ[parentProt], $PersonID, parentProt]]];
				Lookup[First[finalizedPackets], Object]
			),
		MatchQ[preparation, Manual] && MemberQ[output, Result] && Not[upload],
			finalizedPackets,
		True,
			$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule,simulationRule,runTimeRule}

];


(*
	Single container with no second input:
		- Takes a single container and passes it to the core container overload
*)

ExperimentDilute[myContainer : ObjectP[{Object[Container], Model[Sample]}], myOptions : OptionsPattern[ExperimentDilute]] := ExperimentDilute[{myContainer}, myOptions];

(*
	Multiple containers with no second input:
		- expands the Containers into their contents and passes to the core function
*)

ExperimentDilute[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
		containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests,listedContainers,cache,containerToSampleSimulation,
		samplePreparationSimulation},


	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

	(* Fetch the cache from listedOptions *)
	cache=ToList[Lookup[listedOptions, Cache, {}]];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentDilute,
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentDilute,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->samplePreparationSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentDilute,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result,Simulation},
				Simulation->samplePreparationSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::EmptyWells, Error::WellDoesNotExist}
		]
	];


	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = {containerToSampleOutput[[1]],containerToSampleOutput[[2]]};

		(* Call our main function with our samples and converted options. *)
		ExperimentDilute[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


(* ::Subsubsection::Closed:: *)
(*Sister functions*)


DefineOptions[ExperimentDiluteOptions,
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
	SharedOptions :> {ExperimentDilute}
];


ExperimentDiluteOptions[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentDilute *)
	options = ExperimentDilute[myInput, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentDilute],
		options
	]
];


ExperimentDilutePreview[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentDilute]] :=
	ExperimentDilute[myInput, Append[ToList[myOptions], Output -> Preview]];


DefineOptions[ValidExperimentDiluteQ,
	Options :> {VerboseOption, OutputFormatOption},
	SharedOptions :> {ExperimentDilute}
];


ValidExperimentDiluteQ[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ValidExperimentDiluteQ]] := Module[
	{listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentDilute *)
	filterTests = ExperimentDilute[myInput, Append[preparedOptions, Output -> Tests]];

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
	Lookup[RunUnitTest[<|"ValidExperimentDiluteQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDiluteQ"]
];

(* ::Subsubsection::Closed:: *)
(* resolveDiluteMethod *)

DefineOptions[resolveDiluteMethod,
	SharedOptions:>{
		ExperimentDilute,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveDiluteMethod[mySamples:ObjectP[{Object[Sample], Object[Container]}] | {ListableP[ObjectP[{Object[Sample], Object[Container]}]]..}, myOptions:OptionsPattern[]]:=Module[
	{specifiedOptions, resolvedOptions, outputSpecification, methodResolutionOptions, method, resuspendQ},

	(* get the output specification *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];

	(* get the options that were provided *)
	specifiedOptions = ToList[myOptions];

	(* replace the options with Output -> Options and ResolveMethod -> True *)
	methodResolutionOptions = ReplaceRule[specifiedOptions, {Output -> Options, ResolveMethod -> True}];

	(* get the resolved options, and whether we're Robotic or Manual *)
	resolvedOptions =ExperimentDilute[mySamples, methodResolutionOptions];
	method = Lookup[resolvedOptions, Preparation];

	outputSpecification /. {Result -> method, Tests -> {}, Preview -> Null, Options -> methodResolutionOptions}

];