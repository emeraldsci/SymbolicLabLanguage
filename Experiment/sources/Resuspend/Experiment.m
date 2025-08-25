(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentResuspend*)


(* ::Subsubsection::Closed:: *)
(*ExperimentResuspend Options and Messages*)


DefineOptions[ExperimentResuspend,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Amount,
				Default -> Automatic,
				Description -> "The amount of a sample that should be resuspended in a diluent.",
				ResolutionDescription -> "Automatically set to the current mass of the sample, or the value necessary to reach the specified TargetConcentration.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}
					],
					"Count" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					],
					"Count" -> Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
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
				Description -> "The desired final concentration of analyte after resuspension of the input samples with the Diluent.",
				ResolutionDescription -> "Automatically calculated based on Amount and Volume options.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Molar] | GreaterP[0 Gram / Liter],
					Units -> Alternatives[
						{1, {Micromolar, {Micromolar, Millimolar, Molar}}},
						CompoundUnit[
							{1, {Gram, {Gram, Nanogram, Microgram, Milligram}}},
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
				OptionName -> Volume,
				Default -> Automatic,
				Description -> "The desired total volume of the resuspended sample plus diluent.",
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
				Description -> "The amount of liquid that goes into the initial container, prior to any potential transfers to a new container. If transferring to a new container and Amount is not set to All, then the difference between InitialVolume and Volume will remain in the source container.",
				ResolutionDescription -> "Automatically set to Volume if resuspending in the same container or if Amount -> All.  Automatically set to Volume / (Amount / (total amount of sample)) otherwise.",
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
				Description -> "The desired type of container that should be used to prepare and house the resuspended samples, with indices indicating grouping of samples in the same plates, if desired.",
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
				Description -> "The sample that should be added to the input sample, where the volume of this sample added is the Volume option.",
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
				Description -> "The concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the total Volume.",
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
				Description -> "The dilution factor by which the concentrated buffer should be diluted in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the total Volume.",
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
				Description -> "The buffer used to dilute the sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution. The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the total Volume.",
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
			(* mixing of the post-resuspension samples *)
			{
				OptionName -> Mix,
				Default -> True,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if mixing of the resuspended samples will occur following the addition of liquid.",
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
				Description -> "The style of motion used to mix the resuspended samples solution following addition of liquid.",
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

			{
				OptionName -> MixUntilDissolved,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sample should be mixed in an attempt to completely dissolve any solid components following addition of liquid.",
				ResolutionDescription -> "Automatically set to True if MaxMixTime is specified, or False otherwise.",
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
				Description -> "The instrument that should be used to mix/incubate the sample following addition of liquid.",
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
						Pattern :> RangeP[22 Celsius, $MaxIncubationTemperature],
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
				Description -> "Minimum duration for which the sample should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed if mixing while incubating.",
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
			Category -> "Incubation and Mixing"
		},
		{
			OptionName -> ResolveMethod,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "If True, this resolver is being called as part of resolveResuspendMethod, and all messages should be suppressed.",
			Category -> "Hidden"
		},
		PreparationOption,
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelContainer
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 10 Milligram."
			}
		],
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
		SimulationOption,
		HoldOrderOption,
		QueuePositionOption
	}
];


(* ::Subsubsection:: *)
(*ExperimentResuspend*)


Error::SampleStateInvalid = "The following sample(s) are `1` or have undetermined state: `2`.  Please only specify `3` to `4`.";
Error::CannotResolveVolume = "The Volume option was left unspecified and cannot be calculated for the following sample(s): `1`.  Please specify the Volume option directly, or use the TargetConcentration and Amount options to allow for it to be calculated.";
Error::PartialResuspensionContainerInvalid = "The following sample(s) are being resuspended in their current container, but only with a portion of the sample's Amount: `1`.  Please leave Amount unspecified, or resuspend in a different container.";
Error::DuplicateSampleConflictingConditions = "The following sample(s) are specified multiple times, but with different options specified: `1` for options `2`.  If replicates are specified, then all options must be identical becuase the sample can only be resuspended once.";
Error::ResuspendVolumeOverContainerMax = "Some of the specified volumes (`1`), exceed the max volume that the ContainerOut option, `2`, can hold (`3`). Please either lower these volumes to a value below `3` or specifiy ContainerOut to a container that is large enough to hold these volumes.";
Error::ResuspendInitialVolumeOverContainerMax = "In order to resuspend the specified amounts of the following sample(s) in the volume specified by the Volume option, the total volume in the current container after liquid addition (`1`) exceeds the container's maximum volume (`2`) (`3`).  Please set the Volume to a smaller value or increase the TargetConcentration of the sample(s).";
Error::ResuspendPreparationInvalid = "The specified Preparation requests Robotic, but some of the mix settings, input containers or ContainerOut containers are not compatible with Robotic.  Please change to Manual, or first change the input or output containers.";
Error::ResuspendMixTypeIncubationMismatch="The following Type `1` and Incubation options (MixUntilDissolved, IncubationTime, MaxIncubationTime, IncubationTemperature, AnnealingTime), are conflicting for the input(s) `2`. The Incubation options can not be set when the Type option is Invert, Swirl, Pipette. Please change these options in order to specify a valid protocol.";

(* just define this pattern here because we need it in many places; essentially, a non-plate container *)
nonPlateContainerP := Except[ObjectP[{Object[Container, Plate], Model[Container, Plate]}], ObjectP[{Object[Container], Model[Container]}]];

(*
	Single Sample with No Second Input:
		- Takes a single sample and passes through to core overload
*)
ExperimentResuspend[mySample : ObjectP[Object[Sample]], myOptions : OptionsPattern[ExperimentResuspend]] := ExperimentResuspend[{mySample}, myOptions];

(*
	CORE OVERLOAD: List Sample with No Second Input (all options):
		- Core functionality lives here
		- If initial experiment call involved volume/concentration second inputs, these will be in option values for this overload
*)
ExperimentResuspend[mySamples : {ObjectP[Object[Sample]]..}, myOptions : OptionsPattern[ExperimentResuspend]] := Module[
	{
		specifiedDiluent, specifiedContainerOut, inheritedCache,
		allBufferModels, allBufferObjs, containerOutModels, containerOutObjs, allDownloadValues, newCache, listedOptions,
		listedSamples, outputSpecification, output, gatherTests, messages, safeOptionTests, upload, confirm, canaryBranch, fastTrack,
		parentProt, validLengthTests, combinedOptions, expandedCombinedOptions, resolveOptionsResult, resolvedOptions,
		resolutionTests, resolvedOptionsNoHidden, returnEarlyQ, finalizedPackets, runTime, resourcePacketTests, allTests, validQ,
		safeOptions, validLengths, unresolvedOptions, applyTemplateOptionTests, initialLiquidHandlers,
		preferredVesselContainerModels, previewRule, optionsRule, testsRule, resultRule, sampleFields, modelFields,
		containerFields, containerModelFields, concentratedBuffer, bufferDiluent, samplesWithoutTemporalLinks,
		optionsWithoutTemporalLinks, safeOpsWithNames,preparation,workCell,resolveMethod,performSimulationQ,resultQ,
		resourcePacketsResult,updatedSimulation,simulationResult,simulatedProtocol, newSimulation,resolvedOptionsWithHidden,
		simulationRule, runTimeRule, validSamplePreparationResult, samplesWithPreparedSamplesNamed,
		optionsWithPreparedSamplesNamed, resourcePacketsSimulation, constellationMessageRule
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
			ExperimentResuspend,
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
		SafeOptions[ExperimentResuspend, optionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentResuspend, optionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
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
		ValidInputLengthsQ[ExperimentResuspend, {listedSamples}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentResuspend, {listedSamples}, listedOptions], Null}
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
		ApplyTemplateOptions[ExperimentResuspend, {listedSamples}, optionsWithoutTemporalLinks, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentResuspend, {listedSamples}, optionsWithoutTemporalLinks, Output -> Result], Null}
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* expand the combined options *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentResuspend, {listedSamples}, combinedOptions]];

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
	sampleFields = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], MassConcentration, Concentration, StorageCondition, ThawTime, ThawTemperature, TransportTemperature, LightSensitive];
	modelFields = Packet[Model[{SamplePreparationCacheFields[Model[Sample], Format -> Sequence], UsedAsSolvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock}]];
	containerFields = Packet[Container[{SamplePreparationCacheFields[Object[Container], Format -> Sequence]}]];
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
						Packet[Field[Composition[[All, 2]][MolecularWeight]]]
					},
					{
						Packet[SamplePreparationCacheFields[Model[Sample], Format -> Sequence], UsedAsSolvent,ConcentratedBufferDiluent,ConcentratedBufferDilutionFactor,BaselineStock]
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
			resolveExperimentResuspendOrDiluteOptions[Resuspend, listedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Simulation -> updatedSimulation,Cache -> newCache],
			{resolveExperimentResuspendOrDiluteOptions[Resuspend, listedSamples, expandedCombinedOptions, Output -> Result, Simulation -> updatedSimulation,Cache -> newCache], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* pull out the Preparation option *)
	{preparation, workCell} = Lookup[resolvedOptions, {Preparation, WorkCell}];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveExperimentResuspendOrDiluteOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentResuspend,
		RemoveHiddenOptions[ExperimentResuspend, resolvedOptions],
		Messages -> False
	];

	resolvedOptionsWithHidden = CollapseIndexMatchedOptions[
		ExperimentResuspend,
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
			Not[MemberQ[output, Result]] && MemberQ[output, Options] && Not[MemberQ[output, Simulation]] && gatherTests, shortcutResuspendResourcePackets[Resuspend,listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation, Tests}], Cache -> newCache, Simulation -> updatedSimulation],
			Not[MemberQ[output, Result]] && MemberQ[output, Options] && Not[MemberQ[output, Simulation]], {shortcutResuspendResourcePackets[Resuspend,listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> Result], Cache -> newCache, Simulation -> updatedSimulation], updatedSimulation, Null},
			gatherTests, resuspendOrDiluteResourcePackets[Resuspend,listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation, Tests}], Cache -> newCache, Simulation -> updatedSimulation],
			True, {Sequence @@ resuspendOrDiluteResourcePackets[Resuspend,listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation}], Cache -> newCache, Simulation -> updatedSimulation], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];


	(* if we asked for a simulation, then return a simulation *)
	simulationResult = Check[
		{simulatedProtocol, newSimulation} = Which[
			performSimulationQ&&!resultQ,
			simulateExperimentResuspend[
				Resuspend,
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
					Resuspend,
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
			{Null, resourcePacketsSimulation}
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
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"ExperimentResuspend" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
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

	(* Set a rule for the ConstellationMessage since we can generate different protocol types. *)
	constellationMessageRule = ConstellationMessage -> {
		Object[Protocol, RoboticSamplePreparation], Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]
	};

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
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

				unitOperation = Resuspend @@ Join[
					{
						Sample -> samplesMaybeWithModels
					},
					RemoveHiddenPrimitiveOptions[Resuspend, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentResuspend, resolvedOptionsNoHidden];

				(* Memoize the value of ExperimentResuspend so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentResuspend, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentResuspend]={};

					ExperimentResuspend[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
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

	runTimeRule=RunTime->runTime;

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule,simulationRule,runTimeRule}

];

(*
	Single container with no second input:
		- Takes a single container and passes it to the core container overload
*)

ExperimentResuspend[myContainer : ObjectP[{Object[Container], Model[Sample]}], myOptions : OptionsPattern[ExperimentResuspend]] := ExperimentResuspend[{myContainer}, myOptions];

(*
	Multiple containers with no second input:
		- expands the Containers into their contents and passes to the core function
*)

ExperimentResuspend[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
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
			ExperimentResuspend,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> 10 Milligram
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
			ExperimentResuspend,
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
				ExperimentResuspend,
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
		ExperimentResuspend[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentResuspendOrDiluteOptions *)


DefineOptions[resolveExperimentResuspendOrDiluteOptions,
	Options :> {
		(* this doesn't actually exist yet but for now we're just going to have it in here *)
		{EnableSamplePreparation -> False, BooleanP, "If True, this resolver is being called as part of sample prep option resolution.", Category -> Hidden},
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

(* private function to resolve all the options *)
resolveExperimentResuspendOrDiluteOptions[myType : Resuspend|Dilute, mySamples : {ObjectP[Object[Sample]]..}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentResuspendOrDiluteOptions]] := Module[
	{outputSpecification, output, gatherTests, messages, inheritedCache, specifiedDiluent,
		specifiedContainerOut, containerOutModels, containerOutObjs,
		samplePackets, sampleModelPackets, sampleContainerPackets, specifiedConcentratedBuffer, specifiedBufferDiluent,
		sampleContainerModelPackets, containerOutPackets, containerOutModelPackets,
		samplePacketsToCheckIfDiscarded, discardedSamplePackets, discardedInvalidInputs, discardedTest,
		modelPacketsToCheckIfDeprecated, deprecatedModelPackets, deprecatedInvalidInputs, deprecatedTest,
		unknownAmountWarnings, roundedOptionsAssoc, precisionTests, name, validNameQ, nameInvalidOptions,
		validNameTest, missingMolecularWeightErrors, stateAmountMismatchErrors, targetConcNotUsedWarnings,
		mapThreadFriendlyOptions, resolvedTargetConcentration, resolvedAmount, cannotResolveAmountErrors,
		resolvedVolume, nullVolumeErrors, fakeVolumes, currentContainers, currentPositions, bufferTooConcentratedErrors,
		concentrationRatioMismatchErrors, samplesOutStorageCondition, cannotResolveAmountInvalidInputs,
		cannotResolveAmountTests, concMismatchAnalyte, concMismatchSamples, concMismatchAmount,
		concMismatchVolume, concMismatchTargetConc, concMismatchSampleConc, concentrationRatioMismatchOptions,
		concentrationRatioMismatchTest, fakeAmounts, mixOrder,
		indexedContainerOut, specifiedIntegerIndices, samplesVolumeContainerTuples, resuspendAllQs,
		groupedSamplesVolumeContainerTuples, positionsOfGroupings, preResolvedGroupContainerOut, reorderingReplaceRules,
		preResolvedContainerOut, preResolvedContainerOutWithPackets, bufferDilutionMismatchErrors, overspecifiedBufferErrors,
		maxNumWells, numWells, groupedPreResolvedContainerOut, positionsOfPreResolvedContainerOut,
		groupedResolvedContainerOut, resolvedContainerOutReplaceRules, resolvedContainerOutWithUniques,
		uniqueUniques, uniqueIntegers, integersToDrawFrom, integersWithIntegersRemoved, integersForOldUniques,
		uniqueToIntegerReplaceRules, resolvedContainerOut, preferredVesselContainerModels, preferredVesselPackets,
		indexedContainerOutWithCurrentContainers,
		preResolvedDestWells, partialResuspensionInCurrentContainerSamples, partialResuspensionInCurrentContainerOptions,
		partialResuspensionInCurrentContainerTest, resolvedContainerOutGroupedByIndex, numContainersPerIndex, invalidContainerOutSpecs,
		containerOutMismatchedIndexOptions, containerOutMismatchedIndexTest, numReservedWellsPerIndex,
		numWellsPerContainerRules, numWellsAvailablePerIndex, overOccupiedContainerOutBool, overOccupiedContainerOut,
		overOccupiedAvailableWells, overOccupiedReservedWells, containerOverOccupiedOptions, containerOverOccupiedTest,
		destinationContainerModelPackets, maxVolumes, allWellsForContainerOut, allOpenWellsForContainerOut,
		containerMaxVolumeVolumes, containerMaxVolumeVolumesGroupedByIndex, totalVolumeEachIndex,
		maxVolumeEachIndex, tooMuchVolumeQ, volumeTooHighContainerOut, volumeTooHighAssayVolume, volumeTooHighMaxVolume,
		volumeOverContainerMaxOptions, volumeOverContainerMaxTest, invalidOptions, invalidInputs, allTests, confirm, canaryBranch,
		template, cache, fastTrack, operator, parentProtocol, upload, outputOption, email,
		resolvedOptions, testsRule, resultRule, resolvedDiluent,
		safeOptions, resolvedContainerOutModel,
		maxVolumePerSampleFromContainerOut, maxResolutionAmountPerSample, samplePrep, resolvedConcentratedBuffer,
		resolvedBufferDilutionFactor, resolvedBufferDiluent, resolvedInitialVolume, currentContainerMaxVolumes,
		samplesVolumePreResolvedContainerTuples, changingContainerQs,
		maxVolumeGroupedByConsolidatedResuspends, openWellsReplaceRules, openWellsPerGrouping,
		groupedDestWells, resolvedDestWells, resolvedDestWellReplaceRules, specifiedDestWells, specifiedDestWellReplaceRules,
		specifiedDestWellsPerGrouping, invalidDestWellBools, invalidDestWellSpecs, invalidDestWellContainerOut,
		invalidDestWellOptions, invalidDestWellTest, noAmountSamples, stateAmountMismatchOptions, stateAmountMismatchTests,
		noMolecularWeightInvalidOptions, noMolecularWeightTests, targetConcNotUsedTests,
		flatSamplePackets, flatAmounts, flatTargetConc, duplicateSampleOptions, bufferContainerPackets, bufferContainerModelPackets, unknownAmountWarningTests,
		cannotResolveVolumeSamples, cannotResolveVolumeOptions, cannotResolveVolumeTest, badDuplicateSamples, badDuplicateOptions,
		sampleCompositionPackets, preResolvedAnalyte, duplicateDifferentOptions, bufferObjectPackets, bufferModelPackets,
		potentialAnalytesToUse, potentialAnalyteTests, potentialAnalytePackets, allBufferModels, allBufferObjs,
		nonSolidSamplePackets, nonSolidSampleInputs, nonSolidSampleTest, replicatesQ, mapThreadFriendlyResolvedOptions,
		samplesAndResolvedOptions, gatheredSamplesAndResolvedOptions, duplicateGatherings,
		duplicateSampleTests, bufferDilutionMismatchSamples, bufferDilutionMismatchOptions,
		bufferDilutionInvalidTest, overspecifiedBufferSamples, overspecifiedBufferInvalidOptions, overspecifiedBufferInvalidTest,
		bufferTooConcentratedSamples, bufferTooConcentratedBufferDilutionFactors, bufferTooConcentratedAssayVolumes,
		bufferTooConcentratedOptions, bufferTooConcentratedTests, simplifiedType, resuspendQ, noConcentrationErrors,
		targetConcentrationTooLargeErrors, noConcentrationOptions, noConcentrationTest, targetConcentrationTooLargeSamples,
		targetConcentrationTooLargeTargetConc, targetConcentrationTooLargeAnalyte, targetConcentrationTooLargeSampleConc,
		targetConcentrationTooLargeOptions, targetConcentrationTooLargeTest, resolvedPostProcessingOptions,
		initialVolumeTooHighErrors, initialVolumeTooHighSamples, initialVolumeTooHighInitialVolumes,
		initialVolumeTooHighContainerVolumes, initialVolumeTooHighOptions, initialVolumeTooHighTests,resolvedNumberOfMixes,resolvedMixUntilDissolveds, resolvedIncubationTimes, resolvedMaxIncubationTimes, resolvedIncubationTemperatures, resolvedAnnealingTimes, resolvedIncubationInstruments,
		potentialTransferMethods,couldBeMicroQ,preparation,allowedWorkCells,workCell,preparationInvalidOptions,
		preparationInvalidTest,samplesToTransferNoZeroes, destinationsToTransferToNoZeroes, destinationWellsToTransferToNoZeroes,
		typeAndInstrumentMismatchErrors, typeAndNumberOfMixesMismatchErrors, typeAndIncubationMismatchErrors,
		typeAndInstrumentMismatchOptions,typeAndInstrumentMismatchTests,typeAndNumberOfMixesMismatchOptions,typeAndNumberOfMixesMismatchTests,typeAndIncubationMismatchOptions,typeAndIncubationMismatchTests,
		amountsToTransferNoZeroes,fakeResolvedOptions,resolvedSampleLabel, resolvedSampleContainerLabel,
		resolvedConcentratedBufferLabel, resolvedBufferDiluentLabel, resolvedDiluentLabel,allPotentiallyLabeledSamples,
		allPotentiallyLabeledContainers,sampleLabelReplaceRules,containerLabelReplaceRules,simulation,containerOutLabelReplaceRules,
		resolvedContainerOutLabel,sampleOutLabelReplaceRules,resolvedSampleOutLabel,resolveMethod,mixPrimitivesSetUp,
		potentialIncubateMethods,resolvedMixes,resolvedMixType,sameContainerQs
	},

	(* --- Setup our user specified options and cache --- *)

	(* simplify the Type to be Dilute/Resuspend *)
	resuspendQ = MatchQ[myType, Resuspend];

	(* need to call SafeOptions; this will ONLY make a difference in the theoretical shared resolver where it doesn't pass the hidden options down *)
	(* as of this comment this shared resolver doesn't exist, but it might in the future and this mirrors aliquot closelyD *)
	safeOptions = If[resuspendQ,
		Last[ExpandIndexMatchedInputs[ExperimentResuspend, {mySamples}, SafeOptions[ExperimentResuspend, myOptions]]],
		Last[ExpandIndexMatchedInputs[ExperimentDilute, {mySamples}, SafeOptions[ExperimentDilute, myOptions]]]
	];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	resolveMethod = Lookup[safeOptions, ResolveMethod];
	messages = Not[gatherTests]&& Not[resolveMethod];

	(* pull out the Cache and EnableSamplePreparation options *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	samplePrep = Lookup[ToList[myResolutionOptions], EnableSamplePreparation, False];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];

	(* --- Make our one big Download call --- *)

	(* pull out the ConcentratedBuffer, Diluent, BufferDiluent, and ContainerOut options *)
	{
		specifiedDiluent,
		specifiedConcentratedBuffer,
		specifiedBufferDiluent,
		specifiedContainerOut,
		specifiedDestWells,
		name,
		samplesOutStorageCondition,
		fastTrack,
		parentProtocol
	} = Lookup[safeOptions, {Diluent, ConcentratedBuffer, BufferDiluent, ContainerOut, DestinationWell, Name, SamplesOutStorageCondition, FastTrack, ParentProtocol}];

	(* get all the buffers that were specified as models and objects *)
	allBufferModels = Cases[Flatten[{specifiedDiluent, specifiedConcentratedBuffer, specifiedBufferDiluent}], ObjectP[Model[Sample]]];
	allBufferObjs = Cases[Flatten[{specifiedDiluent, specifiedConcentratedBuffer, specifiedBufferDiluent}], ObjectP[Object[Sample]]];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Object[Container]]];

	(* if the Container option is Automatic, we might end up calling PreferredContainer; so we've gotta make sure we download info from all the objects it might spit out *)
	preferredVesselContainerModels = If[MatchQ[specifiedContainerOut, Automatic] || MemberQ[Flatten[ToList[specifiedContainerOut]], Automatic],
		PreferredContainer[All],
		{}
	];

	(* pull out all the sample/sample model/container/container model packets; also get these in the proper shape that the samples are in *)
	samplePackets = fetchPacketFromCache[#, inheritedCache]& /@ mySamples;
	sampleModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[samplePackets, Model, {}], Object];
	sampleContainerPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[samplePackets, Container, {}], Object];
	sampleContainerModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[sampleContainerPackets, Model, {}], Object];
	sampleCompositionPackets = Map[
		Function[{composition},
			fetchPacketFromCache[#, inheritedCache]& /@ Download[composition[[All, 2]], Object]
		],
		Lookup[samplePackets, Composition, {}]
	];

	(* get the ContainerOut object and model packets (again like with the buffers, these two don't have to be the same length) *)
	containerOutPackets = fetchPacketFromCache[#, inheritedCache]& /@ containerOutObjs;
	containerOutModelPackets = DeleteDuplicates[fetchPacketFromCache[#, inheritedCache]& /@ Flatten[{Download[Lookup[containerOutPackets, Model, {}], Object], containerOutModels}]];

	(* get the packets for the buffer objects*)
	bufferObjectPackets = fetchPacketFromCache[#, inheritedCache]& /@ allBufferObjs;
	bufferModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Flatten[{Download[Lookup[bufferObjectPackets, Model, {}], Object], allBufferModels}];
	bufferContainerPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[bufferObjectPackets, Container, {}], Object];
	bufferContainerModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[bufferContainerPackets, Model, {}], Object];

	(* get the packets for the PreferredContainers *)
	preferredVesselPackets = fetchPacketFromCache[#, inheritedCache]& /@ preferredVesselContainerModels;

	(* --- Do the Input Validation Checks --- *)

	(* get all the sample packets together that are going to be checked for whether they are discarded *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	samplePacketsToCheckIfDiscarded = Cases[Flatten[{samplePackets, sampleContainerPackets, bufferObjectPackets, bufferContainerPackets, containerOutPackets}], PacketP[{Object[Sample], Object[Container]}]];

	(* get the samples that are discarded; if on the FastTrack, don't bother checking *)
	discardedSamplePackets = If[Not[fastTrack],
		Select[samplePacketsToCheckIfDiscarded, MatchQ[Lookup[#, Status], Discarded]&],
		{}
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {PacketP[]..}] && messages,
		(
			Message[Error::DiscardedSamples, Lookup[discardedSamplePackets, Object, {}]];
			Lookup[discardedSamplePackets, Object, {}]
		),
		Lookup[discardedSamplePackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples " <> ObjectToString[discardedInvalidInputs, Cache -> inheritedCache] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[samplePacketsToCheckIfDiscarded],
				Nothing,
				Test["Provided input samples " <> ObjectToString[Download[Complement[samplePacketsToCheckIfDiscarded, discardedInvalidInputs], Object], Cache -> inheritedCache] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* get all the model packets together that are going to be checked for whether they are deprecated *)
	(* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
	modelPacketsToCheckIfDeprecated = Cases[Flatten[{sampleModelPackets, sampleContainerModelPackets, bufferModelPackets, bufferContainerModelPackets, containerOutModelPackets}], PacketP[{Model[Sample], Model[Container]}]];

	(* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
	deprecatedModelPackets = If[Not[fastTrack],
		Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&],
		{}
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	deprecatedInvalidInputs = If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
		(
			Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
			Lookup[deprecatedModelPackets, Object, {}]
		),
		Lookup[deprecatedModelPackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> inheritedCache] <> " that are not deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
				Nothing,
				Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object], Cache -> inheritedCache] <> " that are not deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* get the samples that are liquid/gas, or have Null state but also don't have mass or count if we're resuspending, or samples that are solid/counted/gas if we're diluting *)
	nonSolidSamplePackets = Which[
		fastTrack, {},
		resuspendQ, Select[samplePackets, MatchQ[Lookup[#, State], Liquid | Gas] || (NullQ[Lookup[#, State]] && NullQ[Lookup[#, Count]] && NullQ[Lookup[#, Mass]])&],
		Not[resuspendQ], Select[samplePackets, MatchQ[Lookup[#, State], Solid | Gas] || (NullQ[Lookup[#, State]] && NullQ[Lookup[#, Volume]])&],
		(* shouldn't ever actually get to this part *)
		True, {}
	];

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	nonSolidSampleInputs = If[MatchQ[nonSolidSamplePackets, {PacketP[]..}] && messages,
		(
			Message[
				Error::SampleStateInvalid,
				If[resuspendQ, "fluid", "solid"],
				ObjectToString[nonSolidSamplePackets, Cache -> inheritedCache],
				If[resuspendQ, "solid or counted items", "liquid samples"],
				myType
			];
			Lookup[nonSolidSamplePackets, Object, {}]
		),
		Lookup[nonSolidSamplePackets, Object, {}]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonSolidSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonSolidSampleInputs] == 0,
				Nothing,
				Test["Provided samples are " <> If[resuspendQ, "solid", "fluid"] <> ": " <> ObjectToString[nonSolidSampleInputs, Cache -> inheritedCache], True, False]
			];

			passingTest = If[Length[nonSolidSampleInputs] == Length[nonSolidSamplePackets],
				Nothing,
				Test["Provided samples are " <> If[resuspendQ, "solid", "fluid"] <> ": " <> ObjectToString[Download[Complement[samplePackets, nonSolidSampleInputs], Object], Cache -> inheritedCache], True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* --- Option precision checks --- *)

	(* ensure that the Volume option have the proper precision *)
	{roundedOptionsAssoc, precisionTests} = If[gatherTests,
		OptionsHandling`Private`roundPooledOptionPrecision[Association[safeOptions], {If[resuspendQ, Volume, TotalVolume]}, {10^-1 * Microliter}, Output -> {Result, Tests}],
		{OptionsHandling`Private`roundPooledOptionPrecision[Association[safeOptions], {If[resuspendQ, Volume, TotalVolume]}, {10^-1 * Microliter}], {}}
	];

	(* --- Make sure the Name isn't currently in use --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[Or[DatabaseMemberQ[Object[Protocol, ManualSamplePreparation, Lookup[roundedOptionsAssoc, Name]]],DatabaseMemberQ[Object[Protocol, RoboticSamplePreparation, Lookup[roundedOptionsAssoc, Name]]]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "SamplePreparation" <> " protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name, _String],
		Test["If specified, Name is not already a " <> "SamplePreparation" <> " object name:",
			validNameQ,
			True
		],
		Null
	];

	(* --- Start resolving options for real, first those that do not need to be MapThreaded --- *)

	(* get the maximum volume of the ContainerOut option *)
	maxVolumePerSampleFromContainerOut = MapThread[
		Function[{containerOutEntry},
			Switch[containerOutEntry,
				(* if we've got a model container, get its max volume *)
				ObjectP[Model[Container]],
				Lookup[SelectFirst[containerOutModelPackets, MatchQ[containerOutEntry, ObjectP[Lookup[#, Object]]]&], MaxVolume],
				(* if we've got an indexed model container, get _its_ max volume *)
				{_, ObjectP[Model[Container]]},
				Lookup[SelectFirst[containerOutModelPackets, MatchQ[Last[containerOutEntry], ObjectP[Lookup[#, Object]]]&], MaxVolume],
				(* if we've got a container object, get its max volume from its model *)
				ObjectP[Object[Container]],
				With[{containerPacket = SelectFirst[containerOutPackets, MatchQ[containerOutEntry, ObjectP[Lookup[#, Object]]]&]},
					Lookup[
						SelectFirst[containerOutModelPackets, MatchQ[#, ObjectP[Download[Lookup[containerPacket, Model], Object]]]&],
						MaxVolume
					]
				],
				(* if we've got an indexed container object, get _its max volume from its model *)
				{_, ObjectP[Object[Container]]},
				With[{containerPacket = SelectFirst[containerOutPackets, MatchQ[Last[containerOutEntry], ObjectP[Lookup[#, Object]]]&]},
					Lookup[
						SelectFirst[containerOutModelPackets, MatchQ[#, ObjectP[Download[Lookup[containerPacket, Model], Object]]]&],
						MaxVolume
					]
				],
				(* if ContainerOut isn't specified, resolve 20*Liter (i.e., the maximum; we are going to narrow this below) *)
				_, 20 * Liter
			]
		],
		{specifiedContainerOut}
	];

	(* get the maximum volume we can resolve to for each sample *)
	(* since we have volumes and masses here at the same time, need to do some shenanigans since Min of a mass and volume together doesn't work *)
	maxResolutionAmountPerSample = Map[
		If[resuspendQ,
			Which[
				MatchQ[Lookup[#, State], Liquid | Gas], Null,
				IntegerQ[Lookup[#, Count]], Lookup[#, Count],
				MassQ[Lookup[#, Mass]], Lookup[#, Mass],
				True, Null
			],
			Lookup[#, Volume]
		]&,
		samplePackets
	];

	(* --- Resolve the index matched options --- *)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[If[resuspendQ, ExperimentResuspend, ExperimentDilute], roundedOptionsAssoc];

	(* pre-resolve the TargetConcentrationAnalyte based on what the target concentration is (i.e., set it to Null if the TargetConcentration is Null (or Automatic since Automatic always becomes Null for that option)) *)
	preResolvedAnalyte = MapThread[
		If[MatchQ[#1, Null | Automatic] && MatchQ[#2, Automatic],
			Null,
			#2
		]&,
		{Lookup[mapThreadFriendlyOptions, TargetConcentration], Lookup[mapThreadFriendlyOptions, TargetConcentrationAnalyte]}
	];

	(* decide the potential analyte using selectAnalyteFromSample (this is defined in AbsorbanceSpectroscopy/Experiment.m) *)
	(* need to flatten everything though because pooling; will make correct after *)
	{potentialAnalytesToUse, potentialAnalyteTests} = If[gatherTests,
		selectAnalyteFromSample[samplePackets, Analyte -> preResolvedAnalyte, Cache -> inheritedCache, Output -> {Result, Tests}],
		{selectAnalyteFromSample[samplePackets, Analyte -> preResolvedAnalyte, Cache -> inheritedCache, Output -> Result], Null}
	];


	(* get the packet for each of the potential analytes *)
	potentialAnalytePackets = Map[
		Function[{potentialAnalyte},
			SelectFirst[Flatten[sampleCompositionPackets], Not[NullQ[#]] && MatchQ[potentialAnalyte, ObjectP[Lookup[#, Object]]]&, Null]
		],
		potentialAnalytesToUse
	];

	(* do our big MapThread *)
	{
		resolvedTargetConcentration,
		resolvedAmount,
		resolvedVolume,
		resolvedDiluent,
		resolvedConcentratedBuffer,
		resolvedBufferDilutionFactor,
		resolvedBufferDiluent,
		resolvedInitialVolume,
		resuspendAllQs,
		resolvedMixes,
		resolvedMixType,
		currentContainerMaxVolumes,
		cannotResolveAmountErrors,
		concentrationRatioMismatchErrors,
		bufferDilutionMismatchErrors,
		overspecifiedBufferErrors,
		unknownAmountWarnings,
		missingMolecularWeightErrors,
		stateAmountMismatchErrors,
		targetConcNotUsedWarnings,
		nullVolumeErrors,
		bufferTooConcentratedErrors,
		noConcentrationErrors,
		targetConcentrationTooLargeErrors,
		initialVolumeTooHighErrors,
		resolvedNumberOfMixes,
		resolvedMixUntilDissolveds,
		resolvedIncubationTimes,
		resolvedMaxIncubationTimes,
		resolvedIncubationTemperatures,
		resolvedAnnealingTimes,
		resolvedIncubationInstruments,
		typeAndInstrumentMismatchErrors,
		typeAndNumberOfMixesMismatchErrors,
		typeAndIncubationMismatchErrors
	} = Transpose[MapThread[
		Function[{samplePacket, sampleContainerModelPacket, options, maxResolutionAmount, potentialAnalytePacket},
			Module[
				{cannotResolveAmountError, concentrationRatioMismatchError, specifiedVolume, unknownAmountWarning,
					missingMolecularWeightError, specifiedAmount, targetConcentration,
					stateAmountMismatchError, targetConcNotUsedWarning, volume, bufferDilutionMismatchError,
					overspecifiedBufferError, eitherConcP, molecularWeight, concentrationQ, nullVolumeError,
					countQ, liquidQ, solidQ, sampleComposition, sampleConc, sampleMassPercent, sampleVolumePercent,
					sampleMassConc, resolvedSampleConc, potentialVolume, amount, roundedAmount, roundedVolume,
					roundedTargetConcentration, diluent, concentratedBuffer, concBufferPacket, concBufferModelPacket,
					bufferDilutionFactor, bufferDiluent, bufferVolume, concBufferVolume, bufferTooConcentratedError,
					dilutionFactor, noConcentrationError, targetConcentrationTooLargeError, initialVolume,
					initialVolumeTooHighError, currentContainerPacket, currentContainerModelPacket,mix,mixType,
					currentContainerMaxVolume,
					resuspendAllQ,mixContainer,vortexPossibleQ,numberOfMixes,mixUntilDissolved,incubationTime,maxIncubationTime,incubationInstrument,incubationTemperature,annealingTime,
					resolvedNumberOfMix,resolvedMixUntilDissolved,resolvedIncubationTime,resolvedMaxIncubationTime,resolvedIncubationTemperature,resolvedAnnealingTime,resolvedIncubationInstrument,
					typeAndInstrumentMismatchQ,typeAndNumberOfMixesMismatchQ,typeAndIncubationMismatchQ
				},

				(* set our error tracking variables *)
				{
					cannotResolveAmountError,
					concentrationRatioMismatchError,
					bufferDilutionMismatchError,
					overspecifiedBufferError,
					missingMolecularWeightError,
					stateAmountMismatchError,
					targetConcNotUsedWarning,
					unknownAmountWarning,
					nullVolumeError,
					bufferTooConcentratedError,
					noConcentrationError,
					targetConcentrationTooLargeError,
					initialVolumeTooHighError,
					typeAndInstrumentMismatchQ,
					typeAndNumberOfMixesMismatchQ,
					typeAndIncubationMismatchQ
				} = {
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False,
					False
				};

				(* pull out the specified Volume/TotalVolume value *)
				specifiedVolume = Lookup[options, If[resuspendQ, Volume, TotalVolume]];

				(* make a pattern that is just the combination of ConcentrationP and MassConcentrationP (since I'll be using it a lot below) *)
				eitherConcP = ConcentrationP | MassConcentrationP;

				(* if Mass and Count are not populated for the sample, flip the switch on unknownAmountWarning*)
				(* also if the sample we're on is already determined to be the wrong state, then just don't throw this error since we don't want to throw too many errors of the same type *)
				unknownAmountWarning = And[
					Not[MemberQ[nonSolidSamplePackets, samplePacket]],
					Or[
						And[
							resuspendQ,
							Not[MassQ[Lookup[samplePacket, Mass]]],
							Not[MatchQ[Lookup[samplePacket, Count], GreaterP[0., 1.]]]
						],
						And[
							Not[resuspendQ],
							Not[VolumeQ[Lookup[samplePacket, Volume]]]
						]
					]
				];

				(* figure out if we are dealing with what is _basically_ a solid or a liquid or a counted quantity (could be False for both if unknownAmountWarning is True *)
				countQ = MatchQ[Lookup[samplePacket, Count], GreaterEqualP[0., 1.]];
				liquidQ = VolumeQ[Lookup[samplePacket, Volume]] || MatchQ[Lookup[samplePacket, State], Liquid];
				solidQ = And[
					Not[countQ],
					Or[
						Not[liquidQ] && MassQ[Lookup[samplePacket, Mass]],
						MatchQ[Lookup[samplePacket, State], Solid]
					]
				];

				(* convert the specified Amount value to not have the Unit unit anymore; that will make things cleaner below *)
				specifiedAmount = If[MatchQ[Lookup[options, Amount], UnitsP[Unit]],
					Unitless[Lookup[options, Amount], Unit],
					Lookup[options, Amount]
				];

				(* get the target concentration option; if it is *)
				targetConcentration = Lookup[options, TargetConcentration] /. {Automatic -> Null};

				(* flip the TargetConcentrationNotUsed warning switch specifically if TargetConcentration is set and we're using tablets *)
				targetConcNotUsedWarning = If[countQ && Not[NullQ[targetConcentration]], True, False];

				(* just pull out MolecularWeight directly.  Note that this could be $Failed because the field doesn't exist for everything *)
				molecularWeight = If[NullQ[potentialAnalytePacket],
					Null,
					Lookup[potentialAnalytePacket, MolecularWeight, Null]
				];

				(* figure out if I need to flip the missingMolecularWeightErrorInsidePool switch *)
				(* essentially, if we have a specified TargetConcentration as a normal Concentration (and not MassConcentration) and it's a solid, must have MolecularWeight *)
				missingMolecularWeightError = If[ConcentrationQ[targetConcentration] && solidQ,
					Not[MolecularWeightQ[molecularWeight]],
					False
				];

				(* pull out the Composition of the sample packet *)
				(* Time is not useful, remove it here *)
				sampleComposition = Lookup[samplePacket, Composition, {}][[All, {1, 2}]];

				(* pull out the concentration and mass concentration of the chosen component from the composition field *)
				sampleConc = If[MatchQ[potentialAnalytePacket, PacketP[]],
					FirstCase[sampleComposition, {conc : ConcentrationP, ObjectP[Lookup[potentialAnalytePacket, Object]]} :> conc, Null],
					Null
				];
				sampleMassConc = If[MatchQ[potentialAnalytePacket, PacketP[]],
					FirstCase[sampleComposition, {massConc : MassConcentrationP, ObjectP[Lookup[potentialAnalytePacket, Object]]} :> massConc, Null],
					Null
				];

				(* pick the real concentration we are going to use; should mirror the units of TargetConcentration *)
				resolvedSampleConc = Which[
					ConcentrationQ[targetConcentration], sampleConc,
					MassConcentrationQ[targetConcentration], sampleMassConc,
					True, Null
				];

				(* pull out the MassPercent/VolumePercent of the sample *)
				(* the goofy ReplaceAll at the end of each of these converts these to a number (since 100 MassPercent is actually just 1 and math doesn't work on MassPercent/VolumePercent like normal percents) *)
				sampleMassPercent = If[MatchQ[potentialAnalytePacket, PacketP[]],
					FirstCase[sampleComposition, {massPercent : MassPercentP, ObjectP[Lookup[potentialAnalytePacket, Object]]} :> massPercent, Null],
					Null
				] /. {Null :> 1., rawPercent : MassPercentP :> Unitless[rawPercent] / 100.};
				sampleVolumePercent = If[MatchQ[potentialAnalytePacket, PacketP[]],
					FirstCase[sampleComposition, {volumePercent : VolumePercentP, ObjectP[Lookup[potentialAnalytePacket, Object]]} :> volumePercent, Null],
					Null
				] /. {Null :> 1., rawPercent : VolumePercentP :> Unitless[rawPercent] / 100.};

				(* check whether the units of the resolvedSampleConc are the same as targetConcentration; flip the boolean if they are not *)
				(* also check whether the target concentration is greater than the current sample concentration (if so, that's a problem) *)
				(* obviously if targetConcentration is Null or we're dealing with a solid we don't care *)
				(* this is implicitly also checking that TargetConcentration and TargetConcentrationAnalyte must be both Null or both not Null *)
				{
					noConcentrationError,
					targetConcentrationTooLargeError
				} = Which[
					(NullQ[targetConcentration] && NullQ[potentialAnalytePacket]) || solidQ || countQ, {False, False},
					Not[MatchQ[targetConcentration, UnitsP[resolvedSampleConc]]], {True, False},
					MatchQ[targetConcentration, GreaterP[resolvedSampleConc]], {False, True},
					True, {False, False}
				];


				(* get the dilution factor, which is the ratio of the sample's target concentration to the current concentration; if target conc is Null or noConcentrationError is True, then set it as 1 *)
				dilutionFactor = If[NullQ[noConcentrationError] || TrueQ[noConcentrationError] || NullQ[resolvedSampleConc],
					1,
					(resolvedSampleConc / targetConcentration)
				];

				(* calculate what Volume _could_ be in the specific case of dealing with a solid and a specified target concentration *)
				(* doing this here because it would make the big Switch below even uglier otherwise *)
				potentialVolume = Which[
					VolumeQ[specifiedVolume], specifiedVolume,
					MassQ[specifiedAmount] && MassConcentrationQ[targetConcentration],
						(specifiedAmount * sampleMassPercent) / targetConcentration,
					MatchQ[specifiedAmount, Automatic|All] && MassQ[maxResolutionAmount] && MassConcentrationQ[targetConcentration],
						(maxResolutionAmount * sampleMassPercent) / targetConcentration,
					Or[
						MatchQ[specifiedAmount, Automatic|All] && VolumeQ[maxResolutionAmount] && MassConcentrationQ[targetConcentration] && MassConcentrationQ[resolvedSampleConc],
						MatchQ[specifiedAmount, Automatic|All] && VolumeQ[maxResolutionAmount] && ConcentrationQ[targetConcentration] && ConcentrationQ[resolvedSampleConc]
					],
						(maxResolutionAmount * (resolvedSampleConc / targetConcentration)),
					Or[
						VolumeQ[specifiedAmount] && MassConcentrationQ[targetConcentration] && MassConcentrationQ[resolvedSampleConc],
						VolumeQ[specifiedAmount] && ConcentrationQ[targetConcentration] && ConcentrationQ[resolvedSampleConc]
					],
						(specifiedAmount * (resolvedSampleConc / targetConcentration)),
					MassQ[specifiedAmount] && ConcentrationQ[targetConcentration] && Not[missingMolecularWeightError],
					(* need to use Convert because multiplying molar units by gram/mole doesn't simplify by default and UnitSimplify will for some reason convert to INCHES CUBED as their volume unit *)
						Convert[(specifiedAmount * sampleMassPercent) / (targetConcentration * molecularWeight), Milliliter],
					MatchQ[specifiedAmount, Automatic|All] && MassQ[maxResolutionAmount] && ConcentrationQ[targetConcentration] && Not[missingMolecularWeightError],
					(* need to use Convert because multiplying molar units by gram/mole doesn't simplify by default and UnitSimplify will for some reason convert to INCHES CUBED as their volume unit *)
						Convert[(maxResolutionAmount * sampleMassPercent) / (targetConcentration * molecularWeight), Milliliter],
					True, Null
				];

				(* make a big 'ole Switch where we go through a bunch of different branches for resolving the Amount/Volume options *)
				{
					amount,
					volume,
					stateAmountMismatchError
				} = Switch[{targetConcentration, countQ, solidQ, liquidQ},
					(* if we are dealing with a counted item, things are pretty straightforward; all Automatics in Volume become Null *)
					{_, True, _, _},
					Which[
						(* if dealing with a specified amount, going to strip off the Unit unit here because using the mixed syntax is annoying *)
						MatchQ[specifiedAmount, GreaterP[0., 1.] | Null], {specifiedAmount, potentialVolume, False},
						(* if dealing with All or Automatic, go with the max resolution amount *)
						MatchQ[specifiedAmount, Automatic | All], {maxResolutionAmount, potentialVolume, False},
						(* if dealing with anything else specified (masses or volumes or Null), just go with that but also flip the stateAmountMismatchError switch *)
						True, {specifiedAmount, potentialVolume, True}
					],
					(* not dealing with counted items and TargetConcentration is Null *)
					{Null, False, _, _},
					Which[
						(* if dealing with a solid and the amount was specified, resolve to the specified amount *)
						solidQ && MassQ[specifiedAmount], {specifiedAmount, potentialVolume, False},
						(* if dealing with a liquid and the amount was specified, resolve to that specified amount *)
						liquidQ && VolumeQ[specifiedAmount], {specifiedAmount, potentialVolume, False},
						(* if dealing with a solid and the amount was not specified, resolve to the max resolution amount *)
						solidQ && MatchQ[specifiedAmount, Automatic | All], {maxResolutionAmount, potentialVolume, False},
						(* if a solid has a count specified, that's a problem and we're flipping the StateAmountMismatch switch *)
						solidQ && MatchQ[specifiedAmount, GreaterP[0., 1.] | Null], {specifiedAmount, potentialVolume, True},
						(* if dealing with a liquid and All/Automatic is the and the amount and max resolution amount is also a liquid, then just go with that*)
						liquidQ && Not[resuspendQ] && MatchQ[specifiedAmount, Automatic | All], {maxResolutionAmount, potentialVolume, False},
						(* if we're dealing with a liquid otherwise then we're hosed no matter what so I guess just pick Null (error will have already been set anyway) *)
						liquidQ && MatchQ[specifiedAmount, Automatic | All | Null], {Null, potentialVolume, False},
						True, {specifiedAmount, potentialVolume, True}
					],

					(* if TargetConcentration WAS specified *)
					{eitherConcP, False, True, False} | {eitherConcP, False, False, True},
					Which[

						(* - these are the options if Volume is specified - *)
						(* if dealing with a specified amount, just go with that *)
						VolumeQ[specifiedVolume] && MassQ[specifiedAmount], {specifiedAmount, specifiedVolume, False},
						VolumeQ[specifiedVolume] && VolumeQ[specifiedAmount], {specifiedAmount, specifiedVolume, False},


						(* if dealing with Automatic, resolve to whatever the TargetConcentration dictates (MassConcentration) *)
						VolumeQ[specifiedVolume] && MatchQ[specifiedAmount, Automatic] && solidQ && MassConcentrationQ[targetConcentration], {(specifiedVolume * targetConcentration), specifiedVolume, False},
						(* if dealing with Automatic, resolve to whatever the TargetConcentration dictates (Concentration; needs to have a MolecularWeight too) *)
						VolumeQ[specifiedVolume] && MatchQ[specifiedAmount, Automatic] && solidQ && ConcentrationQ[targetConcentration] && MolecularWeightQ[molecularWeight], {UnitSimplify[(specifiedVolume * molecularWeight * targetConcentration)], specifiedVolume, False},
						(* if dealing with Automatic but no MolecularWeight, we're hosed but the error above will have already been thrown so just resolve to whatever and figure out the rest later *)
						VolumeQ[specifiedVolume] && MatchQ[specifiedAmount, Automatic] && solidQ && ConcentrationQ[targetConcentration], {maxResolutionAmount, specifiedVolume, False},
						(* if dealing with Automatic and a liquid and a Concentration, scale things down *)
						VolumeQ[specifiedVolume] && MatchQ[specifiedAmount, Automatic] && liquidQ && CompatibleUnitQ[targetConcentration, resolvedSampleConc], {specifiedVolume * (targetConcentration / resolvedSampleConc), specifiedVolume, False},
						(* if dealing with All, use maxResolutionAmount *)
						VolumeQ[specifiedVolume] && MatchQ[specifiedAmount, All], {maxResolutionAmount, specifiedVolume, False},
						(* if dealing with something else, use what was specified but flip the stateAmountMismatchError switch *)
						VolumeQ[specifiedVolume], {specifiedAmount, specifiedVolume, True},

						(* - these are the options of if Volume is Automatic - *)
						(* note that in these cases the math was already done above when calculating potentialAssayVolume so we can rely on it here*)
						(* if dealing with a specified amount, just go with that *)
						MassQ[specifiedAmount], {specifiedAmount, potentialVolume, False},
						VolumeQ[specifiedAmount], {specifiedAmount, potentialVolume, False},
						(* if dealing with All or Automatic, use maxResolutionAmount *)
						MatchQ[specifiedAmount, Automatic | All], {maxResolutionAmount, potentialVolume, False},
						(* if dealing with something else, use what was specified but set Volume to Null and flip the stateAmountMismatchError switch *)
						True, {specifiedAmount, Null, True}
					]
				];

				(* flip the cannotResolveAmountError switch now for the case where Amount is resolved to Null *)
				cannotResolveAmountError = NullQ[amount];

				(* if Volume resolved to Null, then flip the Null volume error *)
				nullVolumeError = NullQ[volume];

				(* calculate the InitialVolume (i.e., the volume of liquid in the container prior to transfer); if you are doing a partial resuspension/dilution and are only transferring some out of the same container, then this will be higher than the Volume/TotalVolume *)
				initialVolume = Which[
					(* if Amount or Volume are Null then this will just be Null *)
					NullQ[amount] || NullQ[volume], Null,
					(* if Amount is greater than or equal to the max resolution amount, then this is just the same as the volume *)
					MatchQ[amount, GreaterEqualP[maxResolutionAmount]], volume,
					(* if Amount is less than the max resolution amount then things get tricky *)
					(* the initial volume is volume / (amount / maxResolutionAmount) (i.e., Volume scaled up appropriately so that the concentration of the source is the same as the concentration as the destination post transfer *)
					MatchQ[amount, LessP[maxResolutionAmount]], volume / (amount / maxResolutionAmount),
					(* if maxResolutionAmount is Null then we're just going to set to volume; this is a goofy state but better than trainwrecking below *)
					NullQ[maxResolutionAmount], volume,
					(* otherwise set to Null but this shouldn't ever get here *)
					True, Null
				];

				(* get the max volume of the current containers *)
				currentContainerPacket = fetchPacketFromCache[Download[Lookup[samplePacket, Container], Object], inheritedCache];
				currentContainerModelPacket = fetchPacketFromCache[Download[Lookup[currentContainerPacket, Model], Object], inheritedCache];
				currentContainerMaxVolume = Lookup[currentContainerModelPacket, MaxVolume, {}];

				(* if InitialVolume is greater than the current container max volume, throw an error *)
				initialVolumeTooHighError = VolumeQ[initialVolume] && MatchQ[initialVolume, GreaterP[currentContainerMaxVolume]];

				(* get whether we have a concentation or not *)
				concentrationQ = ConcentrationQ[targetConcentration] || MassConcentrationQ[targetConcentration];

				(* three cases where we throw the ConcentrationRatioMismatch error *)
				concentrationRatioMismatchError = Or[
					(* -1.) not counted *)
					(* 0.) solid *)
					(* 1.) TargetConcentration is specified *)
					(* 2.) Volume resolved to a volume *)
					(* 3.) Amount resolved to a mass *)
					(* 4a.) If TargetConcentration is a normal Concentration, make sure the mass * molecular weight / volume is equal to target conc *)
					(* 4b.) If TargetConcentration is a MassConcentration, if the mass / assay volume is not equal to target conc *)
					And[
						Not[countQ],
						solidQ,
						concentrationQ,
						VolumeQ[volume],
						MassQ[amount],
						If[ConcentrationQ[targetConcentration],
							(* note that we need the TrueQ here in case molecularWeight doesn't exist, in which we still want to get False *)
							TrueQ[amount / (molecularWeight * volume) != targetConcentration / sampleMassPercent],
							amount / volume != targetConcentration / sampleMassPercent
						]
					],
					(* -1.) not counted *)
					(* 0.) solid *)
					(* 1.) TargetConcentration is specified *)
					(* 2.) Volume is Null *)
					And[
						Not[countQ],
						solidQ,
						concentrationQ,
						NullQ[volume]
					],
					(* 0.) liquid *)
					(* 1.) TargetConcentration is specified *)
					(* 2.) resolvedSampleConc is not Null*)
					(* 3.) Volume resolved to a volume *)
					(* 4.) Amount resolved to a volume *)
					(* 5.) (Amount / Volume) * sample concentration is not the same as target concentration *)
					And[
						liquidQ,
						concentrationQ,
						Not[NullQ[resolvedSampleConc]],
						VolumeQ[volume],
						VolumeQ[amount],
						!MatchQ[(amount / volume) * resolvedSampleConc, RangeP@@(targetConcentration / (sampleMassPercent + {0.01, -0.01}))]
					]
				];

				(* round the amounts to make sure we haven't resolved to something with the wrong precision *)
				(* if Amount is no longer Mass/Volume/Count, then it must be Null *)
				(* do NOT round the amount because it can be arbitrarily small if we're not transferring it; we will do that after we figure out if we're changing containers or not *)
				roundedAmount = Which[
					MassQ[amount] || VolumeQ[amount], amount,
					MatchQ[amount, GreaterP[0., 1.]], RoundOptionPrecision[amount, 1, Round -> Down],
					True, Null
				];
				roundedVolume = If[NullQ[volume],
					Null,
					RoundOptionPrecision[volume, 10^-1 * Microliter, Round -> Down]
				];
				roundedTargetConcentration = Switch[targetConcentration,
					ConcentrationP, RoundOptionPrecision[targetConcentration, 10^-1 * Nanomolar],
					MassConcentrationP, RoundOptionPrecision[targetConcentration, 10^-1 * Nanogram / Liter],
					_, Null
				];

				(* pull out the concentrated buffer immediately *)
				concentratedBuffer = Lookup[options, ConcentratedBuffer];

				(* get the concentrated buffer packet *)
				concBufferPacket = fetchPacketFromCache[concentratedBuffer, inheritedCache];
				concBufferModelPacket = Which[
					NullQ[concBufferPacket], Null,
					MatchQ[concBufferPacket, ObjectP[Model[Sample]]], concBufferPacket,
					True,  fetchPacketFromCache[Download[Lookup[concBufferPacket, Model], Object], inheritedCache]
				];

				(* if BufferDilutionFactor was specified, just use that; if it was Automatic but ConcentratedBuffer was Null, resolve to Null; if it was Automatic and ConcentratedBuffer is set, then resolve to the ConcentratedBufferDilutionFactor value *)
				bufferDilutionFactor = Which[
					MatchQ[Lookup[options, BufferDilutionFactor], Except[Automatic]], Lookup[options, BufferDilutionFactor],
					NullQ[concentratedBuffer] || NullQ[concBufferModelPacket], Null,
					True, Lookup[concBufferModelPacket, ConcentratedBufferDilutionFactor, Null]
				];

				(* if BufferDiluent was specified, just use that; if it was Automatic but ConcentratedBuffer was Null, resolve to Null; if it was Automatic and ConcentratedBuffer is set, then resolve to water *)
				bufferDiluent = Which[
					MatchQ[Lookup[options, BufferDiluent], Except[Automatic]], Lookup[options, BufferDiluent],
					NullQ[concentratedBuffer], Null,
					True, Model[Sample, "Milli-Q water"]
				];

				(* flip the bufferDilutionMismatchError is anything but all Null or none Null *)
				(* note that here True means there is an error and False means everything is fine *)
				bufferDilutionMismatchError = If[AllTrue[{concentratedBuffer, bufferDilutionFactor, bufferDiluent}, NullQ] || NoneTrue[{concentratedBuffer, bufferDilutionFactor, bufferDiluent}, NullQ],
					False,
					True
				];

				(* if Diluent was specified, just use that; if ConcentratedBuffer was specified, resolve to Null; otherwise resolve to water *)
				diluent = Which[
					MatchQ[Lookup[options, Diluent], Except[Automatic]], Lookup[options, Diluent],
					Not[NullQ[concentratedBuffer]], Null,
					True, Model[Sample, "Milli-Q water"]
				];

				(* Make sure we have precisely one of Diluent or ConcentratedBuffer populated *)
				overspecifiedBufferError = Or[
					AllTrue[{diluent, concentratedBuffer}, NullQ],
					NoneTrue[{diluent, concentratedBuffer}, NullQ]
				];

				(* determine how much buffer volume is necessary *)
				bufferVolume = If[VolumeQ[amount],
					volume - amount,
					volume
				];

				(* determine how much concentrated buffer is needed *)
				concBufferVolume = If[NumericQ[bufferDilutionFactor],
					volume / bufferDilutionFactor,
					Null
				];

				(* if the amount of concentrated buffer volume is greater than the buffer volume, then flip the error switch *)
				bufferTooConcentratedError = VolumeQ[concBufferVolume] && VolumeQ[bufferVolume] && concBufferVolume > bufferVolume;

				(* Decide if we are resuspending All to determine the container we are going to use for Mix option resolution *)
				resuspendAllQ=Switch[roundedAmount,
					Null, True,
					MassP, TrueQ[RoundOptionPrecision[roundedAmount, 10^-1 * Milligram, Round -> Down] == RoundOptionPrecision[Lookup[samplePacket, Mass], 10^-1 * Milligram, Round -> Down]],
					VolumeP, TrueQ[RoundOptionPrecision[roundedAmount, 10^-1 * Microliter, Round -> Down] == RoundOptionPrecision[Lookup[samplePacket, Volume], 10^-1 * Microliter, Round -> Down]],
					_Integer, TrueQ[roundedAmount == Lookup[samplePacket, Count]],
					_, True
				];

				(* Decide the container in which we are going to mix our sample in *)
				mixContainer=Which[
					MatchQ[Lookup[options,ContainerOut],ObjectP[Model]],Download[Lookup[options,ContainerOut],Object],
					MatchQ[Lookup[options,ContainerOut],{_,ObjectP[Model]}],Download[Lookup[options,ContainerOut][[2]],Object],
					MatchQ[Lookup[options,ContainerOut],ObjectP[Object]],Download[Lookup[fetchPacketFromCache[Download[Lookup[options,ContainerOut],Object],inheritedCache],Model],Object],
					MatchQ[Lookup[options,ContainerOut],{_,ObjectP[Object]}],Download[Lookup[fetchPacketFromCache[Download[Lookup[options,ContainerOut][[2]],Object],inheritedCache],Model],Object],
					resuspendAllQ,Lookup[sampleContainerModelPacket,Object],
					VolumeQ[roundedVolume],PreferredContainer[roundedVolume],
					True,Lookup[sampleContainerModelPacket,Object]
				];

				(* Check if it is possible to do Vortex on this container. This will help us resolve MixType *)
				vortexPossibleQ=!MatchQ[MixDevices[mixContainer,roundedVolume/.{Null->1Microliter},Types->Vortex],{}];

				(* resolve Incubate and Mix options - only deal with MixType and NumberOfMixes here. For all the others, we*)
				(* Mix is not an Automatic option *)
				mix=Lookup[options,Mix];

				(* Other Mix options *)
				{numberOfMixes,mixUntilDissolved,incubationTime,maxIncubationTime,incubationInstrument,incubationTemperature,annealingTime}=Lookup[
					options,
					{NumberOfMixes,MixUntilDissolved,IncubationTime,MaxIncubationTime,IncubationInstrument,IncubationTemperature,AnnealingTime}
				];

				mixType=Which[
					MatchQ[Lookup[options,MixType],Except[Automatic]],
					Lookup[options,MixType],
					!TrueQ[mix],Null,
					(* Preparation - Robotic. Resolve based on other Mix options. Default to Pipette if possible *)
					MatchQ[Lookup[roundedOptionsAssoc, Preparation],Robotic]&&!NullQ[numberOfMixes],
					Pipette,
					And[
						MatchQ[Lookup[roundedOptionsAssoc, Preparation],Robotic],
						!NullQ[{mixUntilDissolved,incubationTime,maxIncubationTime,incubationInstrument,incubationTemperature,annealingTime}]
					],
					Shake,
					MatchQ[Lookup[roundedOptionsAssoc, Preparation],Robotic],Pipette,
					(* Instrument specified *)
					!MatchQ[incubationInstrument,Automatic|Null],
					Switch[incubationInstrument,
						ObjectP[{Model[Instrument,Vortex],Object[Instrument,Vortex]}],
						Vortex,
						ObjectP[{Model[Instrument,Shaker],Object[Instrument,Shaker]}],
						Shake,
						ObjectP[{Model[Instrument,BottleRoller],Object[Instrument,BottleRoller],Object[Instrument,Roller],Model[Instrument,Roller]}],
						Roll,
						ObjectP[{Model[Instrument,Sonicator],Object[Instrument,Sonicator]}],
						Sonicate,
						ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}],
						Stir,
						ObjectP[{Model[Instrument,Homogenizer],Object[Instrument,Homogenizer]}],
						Homogenize,
						ObjectP[{Model[Instrument,Disruptor],Object[Instrument,Disruptor]}],
						Disrupt,
						ObjectP[{Model[Instrument,Nutator],Object[Instrument,Nutator]}],
						Nutate,
						ObjectP[{Model[Instrument,Pipette],Object[Instrument,Pipette]}],
						Pipette,
						ObjectP[{Model[Instrument,HeatBlock],Object[Instrument,HeatBlock],Model[Instrument, EnvironmentalChamber],Object[Instrument, EnvironmentalChamber]}],
						Null
					],
					(* Preparation - Manual. Resolve based on other Mix options. If NumberOfMixes is set, resolve to Swirl/Invert/Pipette based on volume. Otherwise default to Vortex for Resuspend and Shake for Dilute *)
					!MatchQ[numberOfMixes,Null|Automatic]&&MatchQ[volume,GreaterP[4Liter]],
					Swirl,
					!MatchQ[numberOfMixes,Null|Automatic]&&MatchQ[volume,GreaterP[50Milliliter]],
					Invert,
					!MatchQ[numberOfMixes,Null|Automatic],
					Pipette,
					resuspendQ&&vortexPossibleQ,
					Vortex,
					True,
					Shake
				];

				resolvedNumberOfMix=Which[
					!MatchQ[numberOfMixes,Automatic],numberOfMixes,
					(* NumberOfMixes is only applicable to Pipette/Swirl/Invert *)
					MatchQ[mixType,(Pipette|Swirl|Invert)],
					If[resuspendQ,
						(* if resuspending, set to 25 *)
						25,
						(* else: set to 15 *)
						15
					],
					True,Null
				];

				(* Resolve MixUntilResolved for incubation *)
				resolvedMixUntilDissolved=Which[
					MatchQ[mixUntilDissolved,Except[Automatic]],
					mixUntilDissolved,
					!TrueQ[mix],Null,
					(* We do not provide MaxNumberOfMixes option in framework so Swirl/Pipette/Invert and Robotic prep cannot do mix until resolved  *)
					MatchQ[mixType,(Pipette|Swirl|Invert)]||MatchQ[Lookup[roundedOptionsAssoc, Preparation],Robotic],
					False,
					(* Decide from MaxIncubationTime *)
					!MatchQ[maxIncubationTime,Null|Automatic],True,
					True,False
				];

				(* Resolve IncubationTime and MaxIncubationTime *)
				resolvedIncubationTime=Which[
					MatchQ[incubationTime,Except[Automatic]],
					incubationTime,
					(* No Mix or (Pipette|Swirl|Invert) do not have IncubationTime *)
					!TrueQ[mix]||MatchQ[mixType,(Pipette|Swirl|Invert)],Null,
					!MatchQ[maxIncubationTime,Null|Automatic],Round[(1/3)*maxIncubationTime,Second],
					True,15Minute
				];

				resolvedMaxIncubationTime=Which[
					MatchQ[maxIncubationTime,Except[Automatic]],
					maxIncubationTime,
					(* No Mix or (Pipette|Swirl|Invert) do not have IncubationTime *)
					!TrueQ[mix]||MatchQ[mixType,(Pipette|Swirl|Invert)]||!TrueQ[resolvedMixUntilDissolved],Null,
					True,3*resolvedIncubationTime
				];

				resolvedIncubationTemperature=Which[
					MatchQ[incubationTemperature,Except[Automatic]],
					incubationTemperature,
					(* No Mix or (Pipette|Swirl|Invert) do not have IncubationTemperature *)
					!TrueQ[mix]||MatchQ[mixType,(Pipette|Swirl|Invert)],Null,
					(* If AnnealingTime is set, a temperature above Ambient is desired. Default to 40 Celsius *)
					MatchQ[annealingTime,TimeP],40Celsius,
					True,Ambient
				];

				(* Set Annealing Time to 0 minute unless specified by user *)
				resolvedAnnealingTime=Which[
					MatchQ[annealingTime,Except[Automatic]],
					annealingTime,
					(* No Mix or (Pipette|Swirl|Invert) do not have IncubationTemperature *)
					!TrueQ[mix]||MatchQ[mixType,(Pipette|Swirl|Invert)],Null,
					True,0Minute
				];

				resolvedIncubationInstrument=Which[
					MatchQ[incubationInstrument,Except[Automatic]],incubationInstrument,
					!TrueQ[mix]||MatchQ[mixType,(Pipette|Swirl|Invert)],Null,
					(* Call MixDevices to resolve instrument *)
					MatchQ[Lookup[roundedOptionsAssoc, Preparation],Robotic],
					FirstOrDefault@MixDevices[mixContainer,roundedVolume/.{Null->1Microliter},Types->mixType,Temperature->resolvedIncubationTemperature,IntegratedLiquidHandler->True],
					True,
					FirstOrDefault@MixDevices[mixContainer,roundedVolume/.{Null->1Microliter},Types->mixType,Temperature->resolvedIncubationTemperature]
				];

				(* Mix option error checking *)
				(* 1 - MixType and IncubationInstrument Error::MixInstrumentTypeMismatch *)
				(* Based on our mix type, make sure that the mix instrument matches. *)
				typeAndInstrumentMismatchQ=Switch[mixType,
					Roll,
					If[MatchQ[resolvedIncubationInstrument,ObjectP[{Model[Instrument,BottleRoller],Object[Instrument,BottleRoller],Model[Instrument,Roller],Object[Instrument,Roller]}]],
						False,
						True
					],
					Shake,
					If[MatchQ[resolvedIncubationInstrument,ObjectP[{Model[Instrument,Shaker],Object[Instrument,Shaker]}]],
						False,
						True
					],
					Stir,
					If[MatchQ[resolvedIncubationInstrument,ObjectP[{Model[Instrument,OverheadStirrer],Object[Instrument,OverheadStirrer]}]],
						False,
						True
					],
					Vortex,
					If[MatchQ[resolvedIncubationInstrument,ObjectP[{Model[Instrument,Vortex],Object[Instrument,Vortex]}]],
						False,
						True
					],
					Disrupt,
					If[MatchQ[resolvedIncubationInstrument,ObjectP[{Model[Instrument,Disruptor],Object[Instrument,Disruptor]}]],
						False,
						True
					],
					Nutate,
					If[MatchQ[resolvedIncubationInstrument,ObjectP[{Model[Instrument,Nutator],Object[Instrument,Nutator]}]],
						False,
						True
					],
					Sonicate,
					If[MatchQ[resolvedIncubationInstrument,ObjectP[{Model[Instrument,Sonicator],Object[Instrument,Sonicator]}]],
						False,
						True
					],
					Homogenize,
					If[MatchQ[resolvedIncubationInstrument,ObjectP[{Model[Instrument,Homogenizer],Object[Instrument,Homogenizer]}]],
						False,
						True
					],
					Pipette,
					If[MatchQ[resolvedIncubationInstrument,Null|ObjectP[{Model[Instrument,Pipette],Object[Instrument,Pipette]}]],
						False,
						True
					],
					Invert,
					If[MatchQ[resolvedIncubationInstrument,Null],
						False,
						True
					],
					Swirl,
					If[MatchQ[resolvedIncubationInstrument,Null],
						False,
						True
					],
					_,
					False
				];

				(* 2 - MixType and NumberOfMixes Error::MixTypeNumberOfMixesMismatch *)
				typeAndNumberOfMixesMismatchQ=If[MatchQ[resolvedNumberOfMix,_Integer]&&!MatchQ[mixType,Invert|Swirl|Pipette],
					True,
					False
				];

				(* 3 - MixType and Incubation options Error::ResuspendMixTypeIncubationMismatch*)
				typeAndIncubationMismatchQ=If[MemberQ[{resolvedMixUntilDissolved,resolvedIncubationTime,resolvedMaxIncubationTime,resolvedIncubationTemperature,resolvedAnnealingTime},Except[(Null|False)]]&&MatchQ[mixType,Invert|Swirl|Pipette],
					True,
					False
				];

				(* return the MapThread variables in order *)
				{
					roundedTargetConcentration,
					roundedAmount,
					roundedVolume,
					diluent,
					concentratedBuffer,
					bufferDilutionFactor,
					bufferDiluent,
					initialVolume,
					resuspendAllQ,
					mix,
					mixType,
					currentContainerMaxVolume,
					cannotResolveAmountError,
					concentrationRatioMismatchError,
					bufferDilutionMismatchError,
					overspecifiedBufferError,
					unknownAmountWarning,
					missingMolecularWeightError,
					stateAmountMismatchError,
					targetConcNotUsedWarning,
					nullVolumeError,
					bufferTooConcentratedError,
					noConcentrationError,
					targetConcentrationTooLargeError,
					initialVolumeTooHighError,
					resolvedNumberOfMix,
					resolvedMixUntilDissolved,
					resolvedIncubationTime,
					resolvedMaxIncubationTime,
					resolvedIncubationTemperature,
					resolvedAnnealingTime,
					resolvedIncubationInstrument,
					typeAndInstrumentMismatchQ,
					typeAndNumberOfMixesMismatchQ,
					typeAndIncubationMismatchQ
				}

			]
		],
		{samplePackets, sampleContainerModelPackets, mapThreadFriendlyOptions, maxResolutionAmountPerSample, potentialAnalytePackets}
	]];

	(* --- Unresolvable error checking --- *)

	(* get the flat sample packets and amounts here because we're going to need to do a lot of flattening *)
	flatSamplePackets = Flatten[samplePackets];
	flatAmounts = Flatten[resolvedAmount];
	flatTargetConc = Flatten[resolvedTargetConcentration];

	(* get the samples that have no volume or mass populated *)
	noAmountSamples = PickList[flatSamplePackets, Flatten[unknownAmountWarnings]];

	(* throw a warning if no amount is known for the input samples; since this isn't actually an InvalidOption (just a warning), don't actually need to assign this to any value *)
	If[MatchQ[noAmountSamples, {PacketP[]..}] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::UnknownAmount, ObjectToString[Lookup[noAmountSamples, Object], Cache -> inheritedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing warning test with the appropriate result. *)
	unknownAmountWarningTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[noAmountSamples] == 0,
				Nothing,
				Warning["Provided samples " <> ObjectToString[Lookup[noAmountSamples, Object], Cache -> inheritedCache] <> " have Mass or Count currently populated:", True, False]
			];

			passingTest = If[Length[noAmountSamples] == Length[flatSamplePackets],
				Nothing,
				Warning["Provided samples have models " <> ObjectToString[Lookup[Complement[flatSamplePackets, noAmountSamples], Object], Cache -> inheritedCache] <> " have Mass or Count currently populated:", True, True]
			];

			{failingTest, passingTest}
		]
	];

	(* throw a message if there was a sample where we needed the molecular weight but it isn't populated *)
	noMolecularWeightInvalidOptions = If[MemberQ[Flatten[missingMolecularWeightErrors], True] && messages,
		(
			Message[Error::MissingMolecularWeight, ObjectToString[PickList[flatSamplePackets, Flatten[missingMolecularWeightErrors]], Cache -> inheritedCache]];
			{TargetConcentration}
		),
		{}
	];

	(* generate the MissingMolecularWeight tests *)
	noMolecularWeightTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[missingMolecularWeightErrors]];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[missingMolecularWeightErrors], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> " have MolecularWeight populated if it is nessary to resolve Volume:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> " have MolecularWeight populated if it is nessary to resolve Volume:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if Amount was specified such that it mismatched with the state of the sample being resuspended *)
	stateAmountMismatchOptions = If[MemberQ[Flatten[stateAmountMismatchErrors], True] && messages,
		(
			Message[Error::StateAmountMismatch, ObjectToString[PickList[Lookup[flatSamplePackets, Object], Flatten[stateAmountMismatchErrors]], Cache -> inheritedCache], ObjectToString[PickList[flatAmounts, Flatten[stateAmountMismatchErrors]]]];
			{Amount}
		),
		{}
	];

	(* generate the stateAmountMismatch tests *)
	stateAmountMismatchTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests, failingAmounts},

			(* get the inputs that fail this test *)
			failingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[stateAmountMismatchErrors]];
			failingAmounts = PickList[flatAmounts, Flatten[stateAmountMismatchErrors]];

			(* get the inputs that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[stateAmountMismatchErrors], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> " have Amount specified that matches these samples' states " <> ObjectToString[failingAmounts] <> ":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> " have Amount specified that matches these samples' states:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a warning if TargetConcentration was set for tablets *)
	If[MemberQ[Flatten[targetConcNotUsedWarnings], True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::TargetConcentrationNotUsed, ObjectToString[PickList[Lookup[flatSamplePackets, Object], Flatten[targetConcNotUsedWarnings]], Cache -> inheritedCache], ObjectToString[PickList[flatAmounts, Flatten[targetConcNotUsedWarnings]]]]
	];

	(* generate TargetConcentrationNotUsed warning tests *)
	targetConcNotUsedTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[targetConcNotUsedWarnings]];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[targetConcNotUsedWarnings], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Warning["The provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> " do not have TargetConcentration specified if Amount is a Count:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Warning["The provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> " do not have TargetConcentration specified if Amount is a Count:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if there was a part where we couldn't resolve the amount since it was Null some places *)
	cannotResolveAmountInvalidInputs = If[MemberQ[Flatten[cannotResolveAmountErrors], True] && messages,
		(
			Message[Error::CannotResolveAmount, ObjectToString[PickList[Lookup[flatSamplePackets, Object], Flatten[cannotResolveAmountErrors], True], Cache -> inheritedCache], "Mass/Count", "Volume"];
			PickList[Lookup[flatSamplePackets, Object], Flatten[cannotResolveAmountErrors], True]
		),
		PickList[Lookup[flatSamplePackets, Object], Flatten[cannotResolveAmountErrors], True]
	];

	(* generate the cannotResolveAmount tests *)
	cannotResolveAmountTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[cannotResolveAmountErrors]];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[cannotResolveAmountErrors], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> " have Mass or Count populated or specified in the Amount option:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> " have Mass or Count populated or specified in the Amount option:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples that have the concentration ratio mismatch *)
	concMismatchSamples = PickList[flatSamplePackets, Flatten[concentrationRatioMismatchErrors]];
	concMismatchAmount = PickList[flatAmounts, Flatten[concentrationRatioMismatchErrors]];
	concMismatchVolume = PickList[resolvedVolume, concentrationRatioMismatchErrors];
	concMismatchTargetConc = PickList[flatTargetConc, Flatten[concentrationRatioMismatchErrors]];
	concMismatchAnalyte = PickList[potentialAnalytesToUse, Flatten[concentrationRatioMismatchErrors]];

	(* pull out what the current concentration is for the samples *)
	concMismatchSampleConc = MapThread[
		Function[{composition, analytePacket},
			FirstCase[composition, {conc_, ObjectP[analytePacket]} :> conc, Null]
		],
		{Lookup[concMismatchSamples, Composition, {}], concMismatchAnalyte}
	];


	(* throw a message if the ratio of the current Concentration is proportional to the TargetConcentration in the same ratio as the Amount/Volume *)
	concentrationRatioMismatchOptions = If[MemberQ[Flatten[concentrationRatioMismatchErrors], True] && messages,
		(
			Message[
				Error::ConcentrationRatioMismatch,
				ObjectToString[concMismatchSamples, Cache -> inheritedCache],
				Replace[concMismatchSampleConc / concMismatchTargetConc, {Except[NumericP] -> "N/A"}, {1}],
				concMismatchTargetConc,
				concMismatchAmount,
				concMismatchVolume,
				If[MatchQ[concMismatchAmount, EqualP[0 Gram]],
					"N/A",
					Replace[concMismatchVolume / concMismatchAmount, {Except[NumericP] -> "N/A"}, {1}]
				],
				If[resuspendQ, Volume, TotalVolume]
			];
			{TargetConcentration}
		),
		{}
	];

	(* tests for whether the ratios of concentration and volumes are the same *)
	concentrationRatioMismatchTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[concentrationRatioMismatchErrors]];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[concentrationRatioMismatchErrors], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The ratios of requested aliquot/assay volumes and target/current concentrations agree for the following sample(s): " <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The ratios of requested aliquot/assay volumes and target/current concentrations agree for the following sample(s): " <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples for which there is a BufferDilutionMismatch error *)
	bufferDilutionMismatchSamples = PickList[samplePackets, bufferDilutionMismatchErrors];

	(* throw a message if for any sample the ConcentratedBuffer/BufferDilutionFactor/BufferDiluent options aren't specified together *)
	bufferDilutionMismatchOptions = If[MemberQ[bufferDilutionMismatchErrors, True] && messages,
		(
			Message[Error::BufferDilutionMismatched, ObjectToString[bufferDilutionMismatchSamples, Cache -> inheritedCache]];
			{ConcentratedBuffer, BufferDilutionFactor, BufferDiluent}
		),
		{}
	];

	(* tests for whether the ConcentratedBuffer/BufferDilutionFactor/BufferDiluent options are specified properly *)
	bufferDilutionInvalidTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			failingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, bufferDilutionMismatchErrors];

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			passingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, bufferDilutionMismatchErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["ConcentratedBuffer, BufferDiluent, and BufferDilutionFactor are either all Null or all specified for the following samples: " <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["ConcentratedBuffer, BufferDiluent, and BufferDilutionFactor are either all Null or all specified for the following samples: " <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples for which there is a BufferDilutionMismatch error *)
	overspecifiedBufferSamples = PickList[samplePackets, overspecifiedBufferErrors];

	(* throw a message if for any sample the Diluent and ConcentratedBuffer options are both specified *)
	overspecifiedBufferInvalidOptions = If[MemberQ[overspecifiedBufferErrors, True] && messages,
		(
			Message[Error::OverspecifiedBuffer, ObjectToString[overspecifiedBufferSamples, Cache -> inheritedCache]];
			{ConcentratedBuffer, Diluent}
		),
		{}
	];

	(* tests for if for any sample the Diluent and ConcentratedBuffer options are both specified *)
	overspecifiedBufferInvalidTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			failingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, overspecifiedBufferErrors];

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			passingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, overspecifiedBufferErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["Only one of ConcentratedBuffer and Diluent are specified for the following samples:" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["Only one of ConcentratedBuffer and Diluent are specified for the following samples:" <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];


	(* get the samples for we can't resolve Volume *)
	cannotResolveVolumeSamples = PickList[samplePackets, nullVolumeErrors];

	(* throw a message if we can't resolve Volume *)
	cannotResolveVolumeOptions = If[MemberQ[nullVolumeErrors, True] && messages,
		(
			If[resuspendQ,
				Message[Error::CannotResolveVolume, ObjectToString[cannotResolveVolumeSamples, Cache -> inheritedCache]],
				Message[Error::CannotResolveTotalVolume, ObjectToString[cannotResolveVolumeSamples, Cache -> inheritedCache]]
			];
			{Amount, TargetConcentration, If[resuspendQ, Volume, TotalVolume]}
		),
		{}
	];

	(* tests for if we can resolve Volume *)
	cannotResolveVolumeTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			failingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, nullVolumeErrors];

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			passingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, nullVolumeErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The Volume option was either specified or was able to be calculated from the TargetConcentration for the following samples: " <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The Volume option was either specified or was able to be calculated from the TargetConcentration for the following samples: " <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples/buffer dilution factors/assay volumes for which BufferDilutionFactor is too low *)
	bufferTooConcentratedSamples = PickList[samplePackets, bufferTooConcentratedErrors];
	bufferTooConcentratedBufferDilutionFactors = PickList[resolvedBufferDilutionFactor, bufferTooConcentratedErrors];
	bufferTooConcentratedAssayVolumes = PickList[resolvedVolume, bufferTooConcentratedErrors];

	(* throw a message if BufferDilutionFactor is too high *)
	bufferTooConcentratedOptions = If[MemberQ[bufferTooConcentratedErrors, True] && MatchQ[myType, Dilute] &&  messages,
		(
			Message[Error::BufferDilutionFactorTooLow, bufferTooConcentratedBufferDilutionFactors, ObjectToString[bufferTooConcentratedAssayVolumes], ObjectToString[bufferTooConcentratedSamples, Cache -> inheritedCache]];
			{If[resuspendQ, Volume, TotalVolume], BufferDilutionFactor, ConcentratedBuffer}
		),
		{}
	];

	(* make tests for if BufferDilutionFactor is too high *)
	bufferTooConcentratedTests = If[gatherTests && MatchQ[myType, Dilute],
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			failingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, bufferTooConcentratedErrors];

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			passingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, bufferTooConcentratedErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The BufferDilutionFactor and Volume options are set to values such that the ConcentratedBuffer can be diluted to the proper value for the following samples:" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The BufferDilutionFactor and Volume options are set to values such that the ConcentratedBuffer can be diluted to the proper value for the following samples:" <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if there was no Concentration and TargetConcentration was specified *)
	noConcentrationOptions = If[MemberQ[Flatten[noConcentrationErrors], True] && messages,
		(
			Message[Error::NoConcentration, ObjectToString[PickList[Lookup[flatSamplePackets, Object, {}], Flatten[noConcentrationErrors]], Cache -> inheritedCache]];
			{TargetConcentration}
		),
		{}
	];

	(* tests for if samples don't have Concentration *)
	noConcentrationTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[noConcentrationErrors]];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[noConcentrationErrors], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The Concentration or MassConcentration of the specified TargetConcentrationAnalyte are populated in the Composition field if TargetConcentration was specified for the following sample(s):" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The Concentration or MassConcentration of the specified TargetConcentrationAnalyte are populated in the Composition field if TargetConcentration was specified for the following sample(s):" <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples where the aliquot volume is too large (and those volumes, and those assay volumes, and those analyte packets) *)
	targetConcentrationTooLargeSamples = PickList[flatSamplePackets, Flatten[targetConcentrationTooLargeErrors]];
	targetConcentrationTooLargeTargetConc = PickList[flatTargetConc, Flatten[targetConcentrationTooLargeErrors]];
	targetConcentrationTooLargeAnalyte = PickList[potentialAnalytesToUse, Flatten[targetConcentrationTooLargeErrors]];

	(* pull out what the current concentration is for the samples *)
	targetConcentrationTooLargeSampleConc = MapThread[
		Function[{composition, analytePacket},
			FirstCase[composition, {conc_, ObjectP[analytePacket]} :> conc, Null]
		],
		{Lookup[targetConcentrationTooLargeSamples, Composition, {}], targetConcentrationTooLargeAnalyte}
	];

	(* throw a message if the TargetConcentration is higher than the current concentration *)
	targetConcentrationTooLargeOptions = If[MemberQ[Flatten[targetConcentrationTooLargeErrors], True] && messages,
		(
			Message[Error::TargetConcentrationTooLarge, ObjectToString[PickList[Lookup[flatSamplePackets, Object, {}], Flatten[targetConcentrationTooLargeErrors]], Cache -> inheritedCache], targetConcentrationTooLargeTargetConc, targetConcentrationTooLargeSampleConc];
			{TargetConcentration}
		),
		{}
	];

	(* tests for if the TargetConcentration is higher than the current concentration *)
	targetConcentrationTooLargeTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[targetConcentrationTooLargeErrors]];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[targetConcentrationTooLargeErrors], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The specified TargetConcentration is less than the Concentration/MassConcentration of the following sample(s):" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The specified TargetConcentration is less than the Concentration/MassConcentration of the following sample(s):" <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples for which InitialVolume is too high*)
	initialVolumeTooHighSamples = PickList[samplePackets, initialVolumeTooHighErrors];
	initialVolumeTooHighInitialVolumes = PickList[resolvedInitialVolume, initialVolumeTooHighErrors];
	initialVolumeTooHighContainerVolumes = PickList[currentContainerMaxVolumes, initialVolumeTooHighErrors];

	(* throw a message if InitialVolume is too high for the source container *)
	initialVolumeTooHighOptions = Which[
		MemberQ[initialVolumeTooHighErrors, True] && resuspendQ && messages,
			(
				Message[Error::ResuspendInitialVolumeOverContainerMax, ObjectToString[initialVolumeTooHighInitialVolumes], ObjectToString[initialVolumeTooHighContainerVolumes], ObjectToString[initialVolumeTooHighSamples, Cache -> inheritedCache]];
				{Volume, Amount, TargetConcentration}
			),
		MemberQ[initialVolumeTooHighErrors, True] && messages,
			(
				Message[Error::DiluteInitialVolumeOverContainerMax, ObjectToString[initialVolumeTooHighInitialVolumes], ObjectToString[initialVolumeTooHighContainerVolumes], ObjectToString[initialVolumeTooHighSamples, Cache -> inheritedCache]];
				{TotalVolume, Amount, TargetConcentration}
			),
		True, {}
	];

	(* make tests for if InitialVolume is too high for the source container *)
	initialVolumeTooHighTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test *)
			failingSamples = PickList[samplePackets, initialVolumeTooHighErrors];

			(* get the inputs that fail this test *)
			passingSamples = PickList[samplePackets, initialVolumeTooHighErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The total volume of sample + diluent prior to transfer (if necessary) is less than or equal to the MaxVolume of the source container for the following samples:" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The total volume of sample + diluent prior to transfer (if necessary) is less than or equal to the MaxVolume of the source container for the following samples:" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* ---error check for mismatched Mix Options --- *)
	(* 1 - MixType and IncubationInstrument Error::MixInstrumentTypeMismatch *)
	typeAndInstrumentMismatchOptions=If[MemberQ[typeAndInstrumentMismatchErrors,True],
		Module[
			{typeAndInstrumentMismatchValues,typeAndInstrumentMismatchInputs},
			typeAndInstrumentMismatchValues=Transpose[{
				PickList[resolvedMixType,typeAndInstrumentMismatchErrors,True],
				PickList[resolvedIncubationInstruments,typeAndInstrumentMismatchErrors,True]
			}];
			typeAndInstrumentMismatchInputs=Download[PickList[samplePackets,typeAndInstrumentMismatchErrors,True],Object];
			Message[Error::MixInstrumentTypeMismatch,typeAndInstrumentMismatchValues,ObjectToString[typeAndInstrumentMismatchInputs,Cache->inheritedCache]]
		];
		{MixType, IncubationInstrument},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	typeAndInstrumentMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,failingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Download[PickList[samplePackets,typeAndInstrumentMismatchErrors,False],Object];
			failingInputs=Download[PickList[samplePackets,typeAndInstrumentMismatchErrors,True],Object];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options Instrument and MixType match, for the inputs "<>ObjectToString[passingInputs,Cache->inheritedCache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[failingInputs]>0,
				Test["The options Instrument and MixType match, for the inputs "<>ObjectToString[failingInputs,Cache->inheritedCache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 2 - MixType and NumberOfMixes Error::MixTypeNumberOfMixesMismatch *)
	typeAndNumberOfMixesMismatchOptions=If[MemberQ[typeAndNumberOfMixesMismatchErrors,True],
		Module[
			{typeAndNumberOfMixesMismatchValues,typeAndNumberOfMixesMismatchInputs},
			typeAndNumberOfMixesMismatchValues=Transpose[{
				PickList[resolvedMixType,typeAndNumberOfMixesMismatchErrors,True],
				PickList[resolvedNumberOfMixes,typeAndNumberOfMixesMismatchErrors,True]
			}];
			typeAndNumberOfMixesMismatchInputs=Download[PickList[samplePackets,typeAndNumberOfMixesMismatchErrors,True],Object];
			Message[Error::MixTypeNumberOfMixesMismatch,typeAndNumberOfMixesMismatchValues,ObjectToString[typeAndNumberOfMixesMismatchInputs,Cache->inheritedCache]]
		];
		{MixType, NumberOfMixes},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	typeAndNumberOfMixesMismatchTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,failingInputs,passingInputsTest,nonPassingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Download[PickList[samplePackets,typeAndNumberOfMixesMismatchErrors,False],Object];
			failingInputs=Download[PickList[samplePackets,typeAndNumberOfMixesMismatchErrors,True],Object];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The options NumberOfMixes/MaxNumberOfMixes are only set when MixType is Invert, Swirl, Pipette, or Automatic for the input(s) "<>ObjectToString[passingInputs,Cache->inheritedCache]<>" if supplied by the user:",True,True],
				Nothing
			];

			(* Create a test for the non-passing inputs. *)
			nonPassingInputsTest=If[Length[failingInputs]>0,
				Test["The options NumberOfMixes/MaxNumberOfMixes are only set when MixType is Invert, Swirl, Pipette, or Automatic for the input(s) "<>ObjectToString[failingInputs,Cache->inheritedCache]<>" if supplied by the user:",True,False],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				nonPassingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 3 - MixType and Incubation options Error::ResuspendMixTypeIncubationMismatch *)
	typeAndIncubationMismatchOptions=If[MemberQ[typeAndIncubationMismatchErrors,True],
		Module[
			{typeAndIncubationMismatchTypes,typeAndIncubationMismatchInputs},
			typeAndIncubationMismatchTypes=DeleteDuplicates[PickList[resolvedMixType,typeAndIncubationMismatchErrors,True]];
			typeAndIncubationMismatchInputs=Download[PickList[samplePackets,typeAndIncubationMismatchErrors,True],Object];
			Message[Error::ResuspendMixTypeIncubationMismatch,typeAndIncubationMismatchTypes,ObjectToString[typeAndIncubationMismatchInputs,Cache->inheritedCache]]
		];
		{MixType},
		{}
	];
	typeAndIncubationMismatchTests=If[gatherTests,
		If[MemberQ[typeAndIncubationMismatchErrors,True],
			Test["Incubation options (MixUntilDissolved, IncubationTime, MaxIncubationTime, IncubationTemperature, AnnealingTime) can only be specified for MixType except Invert, Swirl or Pipette:",True,False],
			Test["Incubation options (MixUntilDissolved, IncubationTime, MaxIncubationTime, IncubationTemperature, AnnealingTime) can only be specified for MixType except Invert, Swirl or Pipette:",True,True]
		],
		{}
	];

	(* --- Resolve the ContainerOut option --- *)

	(* get the current container objects and their current positions *)
	currentContainers = Download[Lookup[samplePackets, Container, {}], Object];
	currentPositions = Lookup[samplePackets, Position, {}];

	(* make fake volumes and assay volumes replacing any Nulls with 1 Gram; need to do this to make PreferredContainer happy, and if we are at this point we're already in trouble anyway *)
	(* assuming the tablet weight of a given tablet is 1 Gram.  That is a good enough assumption this is already fake *)
	fakeAmounts = resolvedAmount /. {Null :> If[resuspendQ, 1 Gram, 1 Milliliter]};
	fakeVolumes = resolvedVolume /. {Null -> 1 Milliliter};

	(* convert any indices of the ContainerOut option to the indexed version of it *)
	(*we only want to expand to the indexed form of this function; don't actually resolve any Automatics *)
	indexedContainerOut = Map[
		Switch[#,
			Automatic, {Automatic, Automatic},
			ObjectP[{Model[Container], Object[Container]}], {Automatic, #},
			_, #
		]&,
		specifiedContainerOut
	];

	(* pre-resolve the ContainerOut/DestinationWell options to the current container/position if both are left to Automatic, or match the current ones, and everything is being resuspended *)
	{indexedContainerOutWithCurrentContainers, preResolvedDestWells} = Transpose[MapThread[
		Function[{allQ, currentContainer, currentPosition, containerOutIndex, destWell},
			If[allQ && MatchQ[containerOutIndex[[2]], Automatic | ObjectP[currentContainer]] && MatchQ[destWell, Automatic | currentPosition],
				{{containerOutIndex[[1]], currentContainer}, currentPosition},
				{containerOutIndex, destWell}
			]
		],
		{resuspendAllQs, currentContainers, currentPositions, indexedContainerOut, specifiedDestWells}
	]];

	(* get all the listed integer indices in ContainerOut option *)
	specifiedIntegerIndices = Cases[indexedContainerOutWithCurrentContainers[[All, 1]], _Integer];

	(* group the samples (and volume and container information) together for cases where the sample and dilution factor are the same *)
	(* if we're not consolidating aliquots we're just going to make this an empty list because we don't need to do anything in the next big MapThread *)
	(* need to add the Buffer options here too because if you're diluting the same concentration but with different buffers obviously that's an issue *)
	(* also need to group by the specified well *)
	samplesVolumeContainerTuples = Transpose[{Lookup[#, Object, {}]& /@ samplePackets, fakeVolumes, fakeAmounts, indexedContainerOutWithCurrentContainers, resolvedDiluent, preResolvedDestWells}];

	(* grouping by the sample, volume, amount, and containers *)
	groupedSamplesVolumeContainerTuples = GatherBy[
		samplesVolumeContainerTuples,
		{
			#[[1 ;; 3]],
			#[[5]],
			#[[6]]
		}&
	];

	(* get the position that each the groupedSamplesVolumeContainerTuples has in samplesVolumeContainerTuples for each one *)
	(* the Alternatives @@@ is a little gross, admittedly, but basically we want to get the position of the grouped tuples in the original ungrouped list *)
	positionsOfGroupings = Position[samplesVolumeContainerTuples, #]& /@ Alternatives @@@ groupedSamplesVolumeContainerTuples;

	(* need to map over the grouped samples and return (in the grouped order) the ContainerOut constructs*)
	preResolvedGroupContainerOut = Map[
		Function[{sampleVolumeContainerValues},
			Module[
				{sampleVolumeContainerValuesPlatesOnly, sampleVolumeContainerValuesNoPlates, automaticContainerEntries,
					automaticContainerGroupedByIndex, autoContainerGroupingVolumes, resolvedContainerGroupsWithUniques,
					preferredVesselByContainersGroupedByIndex, containerAutomaticsToContainersRules, tuplesNoAutomatics,
					resolvedContainerGroupedByIndex, tuplesNoContainerAutomatics,
					sampleVolumeContainerNoPlatesByContainerTuple, autoToIntegerReplaceRules,
					positionsOfAutomaticContainerGroupings, positionsOfAutomaticIndexGroupings},

				(* --- Resolve the container Automatics to a container --- *)

				(* get the entries that correspond to plates *)
				sampleVolumeContainerValuesPlatesOnly = Select[sampleVolumeContainerValues, MatchQ[#[[4, 2]], ObjectP[{Object[Container, Plate], Model[Container, Plate]}]]&];

				(* get all the instances where the ContainerOut is NOT a plate (we are leaving those alone in this MapThread *)
				sampleVolumeContainerValuesNoPlates = DeleteCases[sampleVolumeContainerValues, Alternatives @@ sampleVolumeContainerValuesPlatesOnly];

				(* get all the tuples where ContainerOut is in the form of {_, Automatic} *)
				automaticContainerEntries = Select[sampleVolumeContainerValuesNoPlates, MatchQ[#[[4]], {_, Automatic}]&];

				(* Gather those tuples where ContainerOut is in the form {_, Automatic} by what the first index is *)
				automaticContainerGroupedByIndex = GatherBy[automaticContainerEntries, #[[4, 1]]&];

				(* get the position for these groupings in the original list *)
				positionsOfAutomaticContainerGroupings = Position[sampleVolumeContainerValues, #]& /@ Alternatives @@@ automaticContainerGroupedByIndex;

				(* get the total volume of each grouping *)
				autoContainerGroupingVolumes = Map[
					Total[#[[All, 2]]]&,
					automaticContainerGroupedByIndex
				];

				(* get the PreferredContainer for each grouping *)
				preferredVesselByContainersGroupedByIndex = PreferredContainer[#]& /@ autoContainerGroupingVolumes;

				(* get the automaticContainerGroupedByIndex except the Automatics are replaced with the preferred vessel of note *)
				resolvedContainerGroupedByIndex = MapThread[
					Function[{indexGroup, vessel},
						Replace[indexGroup, {index_, Automatic} :> {index, vessel}, {2}]
					],
					{automaticContainerGroupedByIndex, preferredVesselByContainersGroupedByIndex}
				];

				(* make replace rules converting the container Automatics into containers *)
				containerAutomaticsToContainersRules = MapThread[
					#1 -> #2&,
					(* doing Join @@ because that will remove one level of listiness *)
					{Join @@ positionsOfAutomaticContainerGroupings, Join @@ resolvedContainerGroupedByIndex}
				];

				(* get the tuples with the ContainerOut resolved but not the index yet *)
				tuplesNoContainerAutomatics = ReplacePart[sampleVolumeContainerValues, containerAutomaticsToContainersRules];

				(* --- Resolve the index Automatics to an index (now a Unique[]; will turn to an integer after the MapThread) --- *)

				(* get the values gathered by the ContainerOut tuples *)
				sampleVolumeContainerNoPlatesByContainerTuple = GatherBy[tuplesNoContainerAutomatics, #[[4]]&];

				(* get the position for these groupings in the no-Automatics-in-vessel list *)
				positionsOfAutomaticIndexGroupings = Position[tuplesNoContainerAutomatics, #]& /@ Alternatives @@@ sampleVolumeContainerNoPlatesByContainerTuple;

				(* resolve the first index; all the Automatics here are going to go together, and so will get a Unique[] (that will turn into an integer below) *)
				resolvedContainerGroupsWithUniques = Map[
					With[{index = Unique[]},
						Replace[
							#,
							(* if we have a plate, don't resolve index yet; if we have a different container, then do resolve the index *)
							{
								{Automatic, plate : ObjectP[{Object[Container, Plate], Model[Container, Plate]}]} :> {Automatic, plate},
								{Automatic, container : ObjectP[{Object[Container], Model[Container]}]} :> {index, container}

							},
							{2}
						]
					]&,
					sampleVolumeContainerNoPlatesByContainerTuple
				];

				(* make replace rules converting index Automatics into Unique[] constructs *)
				autoToIntegerReplaceRules = MapThread[
					#1 -> #2&,
					(* doing Join @@ because that will remove one level of listiness *)
					{Join @@ positionsOfAutomaticIndexGroupings, Join @@ resolvedContainerGroupsWithUniques}
				];

				(* get the tuples with the ContainerOut in the {index, container} form *)
				tuplesNoAutomatics = ReplacePart[tuplesNoContainerAutomatics, autoToIntegerReplaceRules];

				(* return just the ContainerOut part *)
				tuplesNoAutomatics[[All, 4]]

			]
		],
		groupedSamplesVolumeContainerTuples
	];

	(* make replace rules that effectively reorder the preResolvedGroupContainerOut to the proper order *)
	reorderingReplaceRules = MapThread[
		#1 -> #2&,
		(* need to do Join @@ to get rid of one level of listiness *)
		{Join @@ positionsOfGroupings, Join @@ preResolvedGroupContainerOut}
	];

	(* get the pre-resolved ContainersOut; we have Uniques[] in here for Vessels but still Automatics for plates; at this point we've converged between whether or not we are consolidating aliquots *)
	preResolvedContainerOut = ReplacePart[samplesVolumeContainerTuples, reorderingReplaceRules];

	(* get the container or model container packets for all the pre-resolved containers out *)
	preResolvedContainerOutWithPackets = Map[
		Function[{indexAndContainerOut},
			fetchPacketFromCache[indexAndContainerOut[[2]], inheritedCache]
		],
		preResolvedContainerOut
	];

	(* get the model packets for these contianers/models from the destinations *)
	destinationContainerModelPackets = Map[
		Function[{containerOrModel},
			(* a little tricky to get the container model packet from the container object; basically need to do two different fetchPacketFromCache calls*)
			With[{containerOrModelPacket = fetchPacketFromCache[containerOrModel, inheritedCache]},
				If[MatchQ[containerOrModelPacket, ObjectP[Model[Container]]],
					containerOrModelPacket,
					fetchPacketFromCache[Download[Lookup[containerOrModelPacket, Model], Object], inheritedCache]
				]
			]
		],
		preResolvedContainerOut[[All, 2]]
	];

	(* get the max volume and positions index matched with the resolvedContainerOut *)
	maxVolumes = Lookup[destinationContainerModelPackets, MaxVolume, {}];

	(* get all the allowed positions for the given destination container *)
	(* there shouldn't be duplicates but it will also mess us up if there is so just make sure *)
	allWellsForContainerOut = Map[
		DeleteDuplicates[Lookup[#, Name, {}]]&,
		Lookup[destinationContainerModelPackets, Positions, {}]
	];

	(* get all the wells that are not already occupied by things in there *)
	(* note that we are _not_ checking whether a _vessel_ is occupied or not *)
	(* also exclude the wells that were already directly specified because we aren't going to resolve to that if one is Automatic and one is specified *)
	allOpenWellsForContainerOut = MapThread[
		Function[{containerPacket, allWells, destWell},
			Switch[containerPacket,
				ObjectP[Model[Container, Plate]], allWells,
				ObjectP[Object[Container, Plate]], DeleteCases[allWells, Alternatives @@ (Lookup[containerPacket, Contents][[All, 1]])],
				_, allWells
			]
		],
		{preResolvedContainerOutWithPackets, allWellsForContainerOut, preResolvedDestWells}
	];

	(* get the DestinationWell specifications that are invalid  *)
	invalidDestWellBools = MapThread[
		Not[MemberQ[#1, #2]] && Not[MatchQ[#2, Automatic]]&,
		{allWellsForContainerOut, preResolvedDestWells}
	];
	invalidDestWellSpecs = PickList[preResolvedDestWells, invalidDestWellBools];
	invalidDestWellContainerOut = PickList[Lookup[preResolvedContainerOutWithPackets, Object], invalidDestWellBools];

	(* throw an error if there are any DestinationWell specifications that don't exist for the corresponding ContainerOut *)
	invalidDestWellOptions = If[Not[MatchQ[invalidDestWellSpecs, {}]] && messages,
		(
			Message[Error::DestinationWellDoesntExist, DestinationWell, invalidDestWellSpecs, ContainerOut, validDestWellContainerOut];
			{DestinationWell, ContainerOut}
		),
		{}
	];

	(* make a test making sure the DestinationWell specified exists for the resolved ContainerOut *)
	invalidDestWellTest = If[gatherTests,
		Test["The specified DestinationWell values exist for all specified or resolved ContainerOut values:",
			MatchQ[invalidDestWellSpecs, {}],
			True
		]
	];

	(* get the max number of wells in each container *)
	maxNumWells = Map[
		Function[{containerPacket},
			Switch[containerPacket,
				ObjectP[Model[Container, Plate]], Lookup[containerPacket, NumberOfWells],
				ObjectP[Object[Container, Plate]], Lookup[fetchPacketFromCache[Download[Lookup[containerPacket, Model], Object], inheritedCache], NumberOfWells],
				_, 1
			]
		],
		preResolvedContainerOutWithPackets
	];

	(* get the number of wells in each container (accounting for plates with things already in them; subtract how many plates there could be there; delete samples that we care about from this accounting though because if you are adding liquid to samples you aren't actually consuming any wells so we don't want to count those as unavailable) *)
	numWells = MapThread[
		Function[{containerPacket, maxNumWell},
			If[MatchQ[containerPacket, ObjectP[Object[Container, Plate]]],
				maxNumWell - Length[DeleteCases[Download[Lookup[containerPacket, Contents][[All, 2]], Object], Alternatives @@ Download[mySamples, Object]]],
				maxNumWell
			]
		],
		{preResolvedContainerOutWithPackets, maxNumWells}
	];

	(* make replace rules whereby a given pairing gets converted to open wells for that pairing as well as the specified destination wells *)
	openWellsReplaceRules = AssociationThread[preResolvedContainerOut, allOpenWellsForContainerOut];
	specifiedDestWellReplaceRules = AssociationThread[preResolvedContainerOut, preResolvedDestWells];

	(* group the samples volumes and pre-resolved containers together again like we did above, except this time we're taking plates into account below *)
	(* need to tack the Unique[]s on the end there for weird Gather/ReplacPart-ing stuff I do below *)
	samplesVolumePreResolvedContainerTuples = Transpose[{Lookup[#, Object, {}]& /@ samplePackets, fakeVolumes, fakeAmounts, preResolvedContainerOut, resolvedDiluent, preResolvedDestWells, Table[Unique[], Length[preResolvedDestWells]]}];

	(* Group the pre resolved containers out by what they are, being sure to Download object to ensure we group properly *)
	(* the rest of the stuff we're including (the samples and volumes) is for use later potentially if we're consolidating aliquots *)
	groupedPreResolvedContainerOut = GatherBy[samplesVolumePreResolvedContainerTuples, {#[[4, 1]], Download[#[[4, 2]], Object]}&];

	(* get the positions of the pre resolved containers out *)
	positionsOfPreResolvedContainerOut = Position[samplesVolumePreResolvedContainerTuples, #]& /@ Alternatives @@@ groupedPreResolvedContainerOut;

	(* get the open wells per grouping *)
	openWellsPerGrouping = Map[
		Replace[#[[1, 4]], openWellsReplaceRules, {0}]&,
		groupedPreResolvedContainerOut
	];

	(* get the specified destination wells per grouping *)
	specifiedDestWellsPerGrouping = Map[
		Replace[#[[1, 4]], specifiedDestWellReplaceRules, {0}]&,
		groupedPreResolvedContainerOut
	];

	(* resolve the automatics for each grouping *)
	{groupedResolvedContainerOut, groupedDestWells} = Transpose[MapThread[
		Function[{groupedContainers, emptyWells},
			Module[{gatheredSampleVolumeContainers, partitionedContainers, partitionedContainersNoAutomatics,
				positionsOfContainers, noPartitionContainersNoAutomatics, postPartitionReplaceRules,
				resolvedContainerOutOutput, partitionedDestWells, flatDestWells, wellReplaceRules,
				resolvedDestWellOutput, partitionedPreResolvedDestWells, automaticPositions,
				emptyWellsNotCountingSpecified, destWellReplaceRules},

				(* this GatherBy call is different depending on whether ConsolidateResuspends -> True *)
				(* if ConsolidateResuspends -> True, the following: *)
				(* gather the sample/volume/amount/containers by cases of the source sample/volume/amount being the same *)
				(* also the diluent needs to be the same *)
				(* also the specified well needs to be the same (or Automatic and not specified) *)
				gatheredSampleVolumeContainers = GatherBy[
					groupedContainers,
					{
						#[[1 ;; 3]],
						#[[5]],
						#[[6]]
					}&
				];

				(* get the position that each of the gatheredSampleVolumeContainers has in groupedContainers for each one *)
				(* the Alternatives @@@ is a little gross, admittedly, but basically we want to get the position of the grouped tuples in the original ungrouped list *)
				positionsOfContainers = Position[groupedContainers, #]& /@ Alternatives @@@ gatheredSampleVolumeContainers;

				(* partition the gathered containers that are assuming that everything in the same grouping will go into the same well to correlate with the number of empty wells *)
				partitionedContainers = If[MatchQ[gatheredSampleVolumeContainers[[All, All, 4]], {{{Automatic, ObjectP[Model[Container, Plate]]}..}..}],
					Partition[gatheredSampleVolumeContainers, UpTo[Length[emptyWells]]],
					{gatheredSampleVolumeContainers}
				];

				(* get the partitioned pre-resolved wells *)
				(* care about [[All, 1, 9]] because if it's grouped together it is only going to have duplicates anyway so just take the first one *)
				partitionedPreResolvedDestWells = If[MatchQ[gatheredSampleVolumeContainers[[All, All, 4]], {{{Automatic, ObjectP[Model[Container, Plate]]}..}..}],
					Partition[gatheredSampleVolumeContainers[[All, 1, 6]], UpTo[Length[emptyWells]]],
					{gatheredSampleVolumeContainers[[All, 1, 6]]}
				];

				(* get the positions of the automatics in the pre-resolved dest wells *)
				automaticPositions = Map[
					Position[#, Automatic]&,
					partitionedPreResolvedDestWells
				];

				(* get the empty wells that don't count the specified dest wells *)
				emptyWellsNotCountingSpecified = Map[
					DeleteCases[emptyWells, Alternatives @@ #]&,
					partitionedPreResolvedDestWells
				];

				(* make replace rules to replace the Automatics with empty wells *)
				(* note that if we have fewer empty wells than positions, expand emptyWellsPerGroup such that it cannot be shorter than positions (there is a check for having too many things for the number of positions later anyway so doing this is fine) *)
				(* note that if we have NO empty positions, we need to fake it a bit and just arbitrarily choose "A1" as the "available" well here (we will throw an error later) *)
				destWellReplaceRules = MapThread[
					Function[{positions, emptyWellsPerGroup},
						Which[
							Length[emptyWellsPerGroup] < Length[positions] && Length[emptyWellsPerGroup] == 0,
							MapThread[
								#1 -> #2&,
								{positions, Take[Flatten[ConstantArray[{"A1"}, Length[positions]]], Length[positions]]}
							],
							Length[emptyWellsPerGroup] < Length[positions],
							MapThread[
								#1 -> #2&,
								{positions, Take[Flatten[ConstantArray[emptyWellsPerGroup, Length[positions]]], Length[positions]]}
							],
							True,
							MapThread[
								#1 -> #2&,
								{positions, Take[emptyWellsPerGroup, Length[positions]]}
							]
						]
					],
					{automaticPositions, emptyWellsNotCountingSpecified}
				];

				(* get the specified destination wells for each grouping *)
				partitionedDestWells = MapThread[
					ReplacePart[#1, #2]&,
					{partitionedPreResolvedDestWells, destWellReplaceRules}
				];

				(* get the flattened destination wells *)
				flatDestWells = Flatten[MapThread[
					Function[{destWells, containers},
						MapThread[
							ConstantArray[#1, Length[#2]]&,
							{destWells, containers}
						]
					],
					{partitionedDestWells, partitionedContainers}
				]];

				(* get the partitioned containers with no automatics *)
				(* note that we need to use -> instead of :> because otherwise we'll evaluate Unique[] too many times *)
				partitionedContainersNoAutomatics = Map[
					# /. {Automatic -> Unique[]}&,
					partitionedContainers
				];

				(* remove the partitions *)
				noPartitionContainersNoAutomatics = Join @@ partitionedContainersNoAutomatics;

				(* make post-partition replace rules *)
				postPartitionReplaceRules = MapThread[
					#1 -> #2&,
					(* doing Join @@ because that will remove one level of listiness *)
					{Join @@ positionsOfContainers, Join @@ (noPartitionContainersNoAutomatics[[All, All, 4]])}
				];

				(* make well replace rules *)
				wellReplaceRules = MapThread[
					#1 -> #2&,
					(* doing Join @@ because that will remove one level of listiness *)
					{Join @@ positionsOfContainers, flatDestWells}
				];

				(* use ReplacePart to have the proper indices for each Automatic *)
				resolvedDestWellOutput = ReplacePart[groupedContainers, wellReplaceRules];
				resolvedContainerOutOutput = ReplacePart[groupedContainers, postPartitionReplaceRules];

				{resolvedContainerOutOutput, resolvedDestWellOutput}

			]
		],
		{groupedPreResolvedContainerOut, openWellsPerGrouping}
	]];

	(* make replace rules that effectively reorder the groupedPreResolvedContainerOut to the proper order (and also get the DestinationWell values) *)
	resolvedContainerOutReplaceRules = MapThread[
		#1 -> #2&,
		{Join @@ positionsOfPreResolvedContainerOut, Join @@ groupedResolvedContainerOut}
	];
	resolvedDestWellReplaceRules = MapThread[
		#1 -> #2&,
		{Join @@ positionsOfPreResolvedContainerOut, Join @@ groupedDestWells}
	];

	(* pull out the resolved ContainerOut option (still including uniques) *)
	resolvedContainerOutWithUniques = ReplacePart[preResolvedContainerOut, resolvedContainerOutReplaceRules];

	(* get the unique uniques unique integers *)
	uniqueUniques = DeleteDuplicates[Cases[resolvedContainerOutWithUniques[[All, 1]], Except[_Integer]]];
	uniqueIntegers = DeleteDuplicates[Cases[resolvedContainerOutWithUniques[[All, 1]], _Integer]];

	(* get the list of integers we are going to draw from *)
	integersToDrawFrom = Range[Length[Join[uniqueUniques, uniqueIntegers]]];

	(* get the integers to draw from with the already-selected integers removed *)
	integersWithIntegersRemoved = DeleteCases[integersToDrawFrom, Alternatives @@ uniqueIntegers];

	(* get the first n integers to draw from that will be converted to uniques *)
	(* need to do this because if uniqueIntegers = {34} and uniqueUniques = {$4974, $4976, $4992, $5020}, integersWithIntegersRemoved will still be {1, 2, 3, 4, 5}, and we only need the first 4 *)
	integersForOldUniques = Take[integersWithIntegersRemoved, Length[uniqueUniques]];

	(* make replace rules for uniques to integers *)
	uniqueToIntegerReplaceRules = AssociationThread[uniqueUniques, integersForOldUniques];

	(* use the replace rules to have the resolved ContainerOut option*)
	resolvedContainerOut = Replace[resolvedContainerOutWithUniques, uniqueToIntegerReplaceRules, {2}];

	(* get the resolved DestinationWells *)
	resolvedDestWells = ReplacePart[preResolvedContainerOut, resolvedDestWellReplaceRules];

	(* figure out if we're changing containers *)
	changingContainerQs = MapThread[
		Function[{allQ, containerOut, currentContainer, destWell, currentPosition},
			Not[allQ] || Not[MatchQ[containerOut, ObjectP[currentContainer]]] || Not[MatchQ[destWell, currentPosition]]
		],
		{resuspendAllQs, resolvedContainerOut[[All, 2]], currentContainers, resolvedDestWells, currentPositions}
	];

	(* --- Make sure the same index doens't apply to different models --- *)

	(* group the resolved containers out by index; need to include other stuff because of the ConsolidateResuspends-with-plates case *)
	resolvedContainerOutGroupedByIndex = GatherBy[Transpose[{Lookup[#, Object, {}]& /@ samplePackets, fakeVolumes, fakeAmounts, resolvedContainerOut, resolvedDiluent}], #[[4, 1]]&];

	(* get the number of unique containers in the second index for each grouping *)
	numContainersPerIndex = Map[
		Function[{containersByIndex},
			Length[DeleteDuplicatesBy[containersByIndex, Download[#[[4, 2]], Object]&]]
		],
		resolvedContainerOutGroupedByIndex
	];

	(* get the ContainerOut specifications that are invalid *)
	invalidContainerOutSpecs = PickList[resolvedContainerOutGroupedByIndex, numContainersPerIndex, Except[1]];

	(* throw an error if there are any indices with multiple different containers *)
	containerOutMismatchedIndexOptions = If[Not[MatchQ[invalidContainerOutSpecs, {}]] && messages,
		(
			Message[Error::ContainerOutMismatchedIndex, invalidContainerOutSpecs[[All, All, 4]]];
			{ContainerOut}
		),
		{}
	];

	(* make a test making sure the ContainerOut indices are set properly *)
	containerOutMismatchedIndexTest = If[gatherTests,
		Test["The specified ContainerOut indices do not refer to multiple containers at once:",
			MatchQ[invalidContainerOutSpecs, {}],
			True
		]
	];

	(* get the number of wells that need to be reserved for each index grouping *)
	numReservedWellsPerIndex = Map[
		Function[{sampleVolumeContainerTuple},
			Length[GatherBy[
				sampleVolumeContainerTuple,
				{
					#[[1 ;; 3]],
					#[[5]]
				}&
			]]
		],
		resolvedContainerOutGroupedByIndex
	];

	(* get the replace rule for the max number of wells allowed in each container *)
	numWellsPerContainerRules = AssociationThread[resolvedContainerOut, numWells];

	(* get the number of wells that available per index *)
	(* doing First because otherwise each index will have Length[#] duplicates *)
	numWellsAvailablePerIndex = Map[
		First[#[[All, 4]] /. numWellsPerContainerRules]&,
		resolvedContainerOutGroupedByIndex
	];

	(* get the Booleans indicating if the ContainerOut specifications that are requesting more than the allowed number *)
	(* If we're using a plate but we still are occupying more than the allowed number of wells *)
	overOccupiedContainerOutBool = MapThread[
		#1 > #2&,
		{numReservedWellsPerIndex, numWellsAvailablePerIndex}
	];

	(* get the ContainerOut specifications where they're overspecified (and the number of available and requested wells) *)
	overOccupiedContainerOut = PickList[resolvedContainerOutGroupedByIndex[[All, All, 4]], overOccupiedContainerOutBool, True];
	overOccupiedAvailableWells = PickList[numWellsAvailablePerIndex, overOccupiedContainerOutBool, True];
	overOccupiedReservedWells = PickList[numReservedWellsPerIndex, overOccupiedContainerOutBool, True];

	(* throw an error if there are any over-occupied containers out *)
	containerOverOccupiedOptions = If[Not[MatchQ[overOccupiedContainerOut, {}]] && messages,
		(
			Message[Error::ContainerOverOccupied, overOccupiedContainerOut, overOccupiedReservedWells, overOccupiedAvailableWells];
			{ContainerOut}
		),
		{}
	];

	(* make a test making sure the ContainerOut is not overspecified *)
	containerOverOccupiedTest = If[gatherTests,
		Test["The requested containers out have enough positions to hold all requested samples:",
			MatchQ[overOccupiedContainerOut, {}],
			True
		]
	];

	(* transpose together the sample packets, fakeVolumes, fakeAmounts, resolvedContainerOut, and MaxVolumes *)
	containerMaxVolumeVolumes = Transpose[{Lookup[#, Object, {}]& /@ samplePackets, fakeVolumes, fakeAmounts, resolvedContainerOut, maxVolumes, resolvedDestWells}];

	(* gather these by the ContainerOut *)
	containerMaxVolumeVolumesGroupedByIndex = GatherBy[containerMaxVolumeVolumes, #[[4, 1]]&];

	(* we need to need to group by what well/container a given sample is going to be put in *)
	maxVolumeGroupedByConsolidatedResuspends = Map[
		Function[{maxVolumeTuples},
			GatherBy[
				maxVolumeTuples,
				{
					#[[1]],
					#[[6]]
				}&
			]
		],
		containerMaxVolumeVolumesGroupedByIndex
	];

	(* get the volume going into each given position and also the MaxVolume *)
	(* need the Join @@ to remove one of the levels of listiness *)
	totalVolumeEachIndex = Join @@ Map[
		Total[#[[All, 2]]]&,
		maxVolumeGroupedByConsolidatedResuspends,
		{2}
	];
	maxVolumeEachIndex = Join @@ Map[
		#[[1, 5]]&,
		maxVolumeGroupedByConsolidatedResuspends,
		{2}
	];

	(* if we are using plates, then I need to make sure _each_ sample's assay volume is more than the MaxVolume; othrewise, need to use the combined amount *)
	(* if the units aren't compatible and we're dealing with solids, then just assume that we don't have too much volume *)
	tooMuchVolumeQ = MapThread[
		Function[{totalVolume, maxVolume},
			If[CompatibleUnitQ[totalVolume, maxVolume],
				totalVolume > maxVolume,
				False
			]
		],
		{totalVolumeEachIndex, maxVolumeEachIndex}
	];

	(* get the ContainersOut, Combined Volume, and container MaxVolume for containers where the assay volume is too high *)
	(* need to do the Join @@ to get rid of some of the extra listiness *)
	volumeTooHighContainerOut = PickList[Join @@ maxVolumeGroupedByConsolidatedResuspends[[All, All, 1, 4, 2]], tooMuchVolumeQ, True];
	volumeTooHighAssayVolume = PickList[totalVolumeEachIndex, tooMuchVolumeQ, True];
	volumeTooHighMaxVolume = PickList[maxVolumeEachIndex, tooMuchVolumeQ, True];

	(* throw an error if the Volume is greater than the max volume of the ContainerOut *)
	volumeOverContainerMaxOptions = If[Not[MatchQ[volumeTooHighContainerOut, {}]] && messages,
		(
			If[resuspendQ,
				Message[Error::ResuspendVolumeOverContainerMax, UnitScale[volumeTooHighAssayVolume, Simplify -> False], volumeTooHighContainerOut, volumeTooHighMaxVolume],
				Message[Error::DiluteTotalVolumeOverContainerMax, UnitScale[volumeTooHighAssayVolume, Simplify -> False], volumeTooHighContainerOut, volumeTooHighMaxVolume]
			];
			{ContainerOut}
		),
		{}
	];

	(* make a test to ensure that ContainerOut isn't too small *)
	volumeOverContainerMaxTest = If[gatherTests,
		Test["The resolved Volume is less than or equal to the MaxVolume of the specified ContainerOut:",
			MatchQ[volumeOverContainerMaxOptions, {}],
			True
		]
	];

	(* get the samples that are resuspending in their current containers but are NOT transferring all *)
	partialResuspensionInCurrentContainerSamples = MapThread[
		Function[{samplePacket, allQ, currentContainer, currentPosition, resolvedContainer, resolvedPosition},
			If[Not[allQ] && MatchQ[currentContainer, ObjectP[resolvedContainer[[2]]]] && currentPosition === resolvedPosition,
				samplePacket,
				Nothing
			]
		],
		{samplePackets, resuspendAllQs, currentContainers, currentPositions, resolvedContainerOut, resolvedDestWells}
	];

	(* throw an error if we're doing only partial resuspending in the current container *)
	partialResuspensionInCurrentContainerOptions = If[Not[MatchQ[partialResuspensionInCurrentContainerSamples, {}]] && messages,
		(
			Message[Error::PartialResuspensionContainerInvalid, ObjectToString[partialResuspensionInCurrentContainerSamples, Cache -> inheritedCache]];
			{Amount, ContainerOut, DestinationWell}
		),
		{}
	];
	partialResuspensionInCurrentContainerTest = If[gatherTests,
		Test["If resuspending in the container/position that the sample currently is in, all of the sample is resuspended at once:",
			MatchQ[partialResuspensionInCurrentContainerSamples, {}],
			True
		]
	];

	(* get the container model from the resolved ContainerOut option *)
	resolvedContainerOutModel = Map[
		Function[{containerOut},
			If[MatchQ[containerOut, ObjectP[Model[Container]]],
				containerOut,
				Lookup[SelectFirst[Flatten[{sampleContainerPackets, containerOutPackets}], MatchQ[#, ObjectP[containerOut]]&], Model]
			]
		],
		resolvedContainerOut[[All, 2]]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* get all the aliquot samples that can be labeled, as well as the containers  *)
	allPotentiallyLabeledSamples = Download[Cases[DeleteDuplicates[Flatten[{
		Lookup[Flatten[samplePackets], Object],
		resolvedConcentratedBuffer,
		resolvedBufferDiluent,
		resolvedDiluent
	}]], ObjectP[]], Object];

	allPotentiallyLabeledContainers = Download[Cases[DeleteDuplicates[Flatten[{
		Lookup[Flatten[samplePackets], Container]
	}]], ObjectP[]], Object];

	(* make replace rules converting the samples and containers into labels *)
	sampleLabelReplaceRules = Map[
		# -> If[resuspendQ,CreateUniqueLabel["resuspension sample"],CreateUniqueLabel["dilution sample"]]&,
		allPotentiallyLabeledSamples
	];
	containerLabelReplaceRules = Map[
		# -> If[resuspendQ,CreateUniqueLabel["resuspension container"],CreateUniqueLabel["dilution container"]]&,
		allPotentiallyLabeledContainers
	];

	(* get the resolved labels *)
	{
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedConcentratedBufferLabel,
		resolvedBufferDiluentLabel,
		resolvedDiluentLabel
	} = Transpose[MapThread[
		Function[{samplePackets, options, concentratedBuffer, bufferDiluent, diluent},
			Module[{sampleLabel, sampleContainerLabel,
				concentratedBufferLabel, bufferDiluentLabel, diluentLabel},

				(* resolve the label options *)
				{
					sampleLabel,
					sampleContainerLabel
				} =
					{
						Which[
							Not[MatchQ[Lookup[options, SampleLabel], Automatic]],
							Lookup[options, SampleLabel],
							MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[samplePackets, Object]],
							Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePackets, Object]],
							True,
							Lookup[samplePackets, Object] /. sampleLabelReplaceRules
						],
						Which[
							Not[MatchQ[Lookup[options, SampleContainerLabel], Automatic]],
							Lookup[options, SampleContainerLabel],
							MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Download[Lookup[samplePackets, Container], Object]],
							Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Download[Lookup[samplePackets, Container], Object]],
							True,
							Download[Lookup[samplePackets, Container], Object] /. containerLabelReplaceRules
						]
					};

				(* get the concentrated buffer/buffer diluent/assay buffer label *)
				concentratedBufferLabel = Which[
					Not[MatchQ[Lookup[options, ConcentratedBufferLabel], Automatic]], Lookup[options, ConcentratedBufferLabel],
					NullQ[concentratedBuffer], Null,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[concentratedBuffer, Object]], _String],
						LookupObjectLabel[simulation, Download[concentratedBuffer, Object]],
					True, Download[concentratedBuffer, Object] /. sampleLabelReplaceRules
				];
				(* get the buffer diluent label *)
				bufferDiluentLabel = Which[
					Not[MatchQ[Lookup[options, BufferDiluentLabel], Automatic]], Lookup[options, BufferDiluentLabel],
					NullQ[bufferDiluent], Null,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[bufferDiluent, Object]], _String],
						LookupObjectLabel[simulation, Download[bufferDiluent, Object]],
					True, Download[bufferDiluent, Object] /. sampleLabelReplaceRules
				];

				(* get the assay buffer label *)
				diluentLabel = Which[
					Not[MatchQ[Lookup[options, DiluentLabel], Automatic]], Lookup[options, DiluentLabel],
					NullQ[diluent], Null,
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, Download[diluent, Object]], _String],
						LookupObjectLabel[simulation, Download[diluent, Object]],
					True, Download[diluent, Object] /. sampleLabelReplaceRules
				];

				(* return our labels *)
				{
					sampleLabel,
					sampleContainerLabel,
					concentratedBufferLabel,
					bufferDiluentLabel,
					diluentLabel
				}
			]
		],
		{samplePackets, mapThreadFriendlyOptions, resolvedConcentratedBuffer, resolvedBufferDiluent, resolvedDiluent}
	]];

	(* deterimine if the sample in question is staying in its existing container, or if it is moving to a new one *)
	sameContainerQs = MapThread[
		MatchQ[Lookup[#1, Container], ObjectP[#2[Object]]]&,
		{samplePackets, resolvedContainerOut/. (x : {_, ObjectP[]} :> x[[2]])}
	];

	(* make labels for the resolved containers out*)
	containerOutLabelReplaceRules = Map[
		# -> If[resuspendQ,CreateUniqueLabel["resuspension container out"],CreateUniqueLabel["dilution container out"]]&,
		(* Delete Duplicates with the proper index to make sure we have the correct unique labels *)
		DeleteDuplicates[resolvedContainerOut]
	];

	resolvedContainerOutLabel = MapThread[
		Function[{containerOut, containerOutLabel,sameContainerQ,sampleContainerLabel},
			Which[
				Not[MatchQ[containerOutLabel, Automatic]],
				containerOutLabel,

				MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]],containerOut],
				Lookup[Reverse /@ Lookup[simulation[[1]], Labels], containerOut],

				sameContainerQ,
				sampleContainerLabel,

				True,
				containerOut /. containerOutLabelReplaceRules
			]
		],
		{resolvedContainerOut, Lookup[myOptions, ContainerOutLabel],sameContainerQs,resolvedSampleContainerLabel}
	];

	(* make labels for the things that will become the SamplesOut *)
	sampleOutLabelReplaceRules = Map[
		# -> If[resuspendQ,CreateUniqueLabel["resuspension sample out"],CreateUniqueLabel["dilution sample out"]]&,
		DeleteDuplicates[Transpose[{resolvedContainerOutLabel, resolvedDestWells}]]
	];
	resolvedSampleOutLabel = MapThread[
		If[Not[MatchQ[#1, Automatic]],
			#1,
			{#2, #3} /. sampleOutLabelReplaceRules
		]&,
		{Lookup[myOptions, SampleOutLabel], resolvedContainerOutLabel, resolvedDestWells}
	];

	(* --- Construct a fake resolveTransferMethod call to figure out if we need to do manual vs robotic sample preparation --- *)

	(* construct fake resolved options for the following helper *)
	fakeResolvedOptions = {
		Diluent -> resolvedDiluent,
		ConcentratedBuffer -> resolvedConcentratedBuffer,
		BufferDiluent -> resolvedBufferDiluent,
		BufferDilutionFactor -> resolvedBufferDilutionFactor,
		DestinationWell -> resolvedDestWells,
		ContainerOut -> resolvedContainerOut,
		Amount -> resolvedAmount,
		If[resuspendQ, Volume, TotalVolume] -> resolvedVolume,
		Preparation -> Lookup[roundedOptionsAssoc, Preparation],

		SampleLabel -> resolvedSampleLabel,
		SampleContainerLabel -> resolvedSampleContainerLabel,
		SampleOutLabel -> resolvedSampleOutLabel,
		ContainerOutLabel -> resolvedContainerOutLabel,
		DiluentLabel -> resolvedDiluentLabel,
		ConcentratedBufferLabel -> resolvedConcentratedBufferLabel,
		BufferDiluentLabel -> resolvedBufferDiluentLabel
	};

	(* get all the inputs and options needed for resolveTransferMethod *)
	{
		samplesToTransferNoZeroes,
		destinationsToTransferToNoZeroes,
		destinationWellsToTransferToNoZeroes,
		amountsToTransferNoZeroes
	} = If[
		(*if the volume can't be resolved*)
		MemberQ[nullVolumeErrors, True],
		{Null,Null,Null,Null},
		convertResuspendOrDiluteToTransferSteps[myType,samplePackets, fakeResolvedOptions]
	];

	(* figure out if it could be micro or not *)
	(* if we have solids to transfer automatically going to have Manual only *)
	(* if we somehow have no samples to transfer (because resolution went poorly and errors were thrown above), just pick Manual *)
	potentialTransferMethods = Which[
		MemberQ[nullVolumeErrors, True],{Manual},
		MatchQ[amountsToTransferNoZeroes, {}], {Manual},
		MemberQ[amountsToTransferNoZeroes, MassP | CountP | UnitsP[Unit]], {Manual},
		True,
		resolveTransferMethod[
			samplesToTransferNoZeroes,
			destinationsToTransferToNoZeroes,
			amountsToTransferNoZeroes,
			DestinationWell -> destinationWellsToTransferToNoZeroes,
			Simulation -> simulation,
			Cache -> inheritedCache
		]
	];

	mixPrimitivesSetUp = Transpose[MapThread[
		Which[
			!resuspendQ&&MatchQ[Lookup[#1,Mix],(False|Null)],Table[Null,12],

			MatchQ[Lookup[#1, Mix], False|Null], Table[Null,12],

			MatchQ[#4, Pipette],
			{
				Lookup[#2, Object],
					(*Time -> *)Null,
					(*MaxTime ->*)Null,
					(*MixType -> *)#4,
					(*MixVolume -> *)Max[Min[#3 / 2, 970 * Microliter], 1 Microliter],
					(*NumberOfMixes -> *)Lookup[#1, NumberOfMixes],
					(*MixUntilDissolved ->*)Null,
					(*Instrument ->*)Null,
					(*Temperature ->*)Null,
					(*AnnealingTime ->*)Null,
					(*ResidualIncubation ->*)Null,
					(*ResidualTemperature ->*)Null
			},
			True,
			{
				Lookup[#2, Object],

					(*Time -> *)Lookup[#1, IncubationTime],
					(*MaxTime ->*) Lookup[#1, MaxIncubationTime],
					(*MixType ->*) #4,
					(*MixVolume -> *)Null,
					(*NumberOfMixes -> *)Null,
					(*MixUntilDissolved ->*) Lookup[#1, MixUntilDissolved],
					(*Instrument ->*) Lookup[#1, IncubationInstrument],
					(*Temperature ->*) (Lookup[#1, IncubationTemperature] /. {Null -> Ambient}),
					(*AnnealingTime ->*) Lookup[#1, AnnealingTime],
					(* These are not options for Resuspend *)
					(*ResidualIncubation ->*)Null,
					(*ResidualTemperature ->*)Null

			}
		]&,
		{mapThreadFriendlyOptions, samplePackets,resolvedInitialVolume,resolvedMixType}
	]];

	potentialIncubateMethods = Which[
		!MemberQ[Lookup[myOptions,Mix],True],{Manual,Robotic},
		MemberQ[resolvedMixType,  Automatic|Except[Pipette|Shake]], {Manual},
		True,
		resolveIncubateMethod[
			First[mixPrimitivesSetUp],
			Sequence @@Normal[AssociationThread[
				{Time, MaxTime, MixType, MixVolume, NumberOfMixes, MixUntilDissolved, Instrument, Temperature, AnnealingTime, ResidualIncubation, ResidualTemperature} -> Rest[mixPrimitivesSetUp]
			]],
			Simulation -> simulation
		]
	];


	couldBeMicroQ = MemberQ[potentialTransferMethods, Robotic]&&MemberQ[potentialIncubateMethods, Robotic];

	(* resolve the Preparation option *)
	preparation = Which[
		Not[MatchQ[Lookup[roundedOptionsAssoc, Preparation], Automatic]], Lookup[roundedOptionsAssoc, Preparation],
		couldBeMicroQ, Robotic,
		True, Manual
	];

	(* Resolve the work cell that we're going to operator on. *)
	allowedWorkCells = resolveResuspendOrDiluteWorkCell[mySamples, {Preparation -> preparation, Simulation -> simulation, Cache -> inheritedCache, Output -> Result}];

	workCell = FirstOrDefault[allowedWorkCells];


	(* throw an error if the liquid handler is set to Micro but it can't be *)
	preparationInvalidOptions = If[
		MatchQ[preparation, Robotic] && Not[couldBeMicroQ] && messages,
		(
			If[resuspendQ,Message[Error::ResuspendPreparationInvalid],Message[Error::DilutePreparationInvalid]];
			{Preparation}
		),
		{}
	];

	(* make a test making sure the Preparation option is set properly *)
	preparationInvalidTest = If[gatherTests,
		Test["The specified Preparation option is compatible with the containers and amounts specified:",
			(* only fail the test if we are on micro liquid handling and we also can't be *)
			MatchQ[preparation, Robotic] && Not[couldBeMicroQ],
			False
		]
	];

	(* --- pull out all the shared options from the input options --- *)

	(* get the rest directly *)
	{confirm, canaryBranch, template, samplesOutStorageCondition, mixOrder, cache, operator, upload, outputOption} = Lookup[safeOptions, {Confirm, CanaryBranch, Template, SamplesOutStorageCondition, MixOrder, Cache, Operator, Upload, Output}];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[safeOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[safeOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[{Object[Protocol], Object[Control], Object[Maintenance]}]], False,
		True, Lookup[safeOptions, Email]
	];

	(* --- Do the final preparations --- *)

	(* get the final resolved options (pre-collapsed; that is happening outside the function) *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Amount -> resolvedAmount,
			TargetConcentration -> resolvedTargetConcentration,
			TargetConcentrationAnalyte -> potentialAnalytesToUse,
			If[resuspendQ, Volume, TotalVolume] -> resolvedVolume,
			InitialVolume -> resolvedInitialVolume,
			ContainerOut -> resolvedContainerOut,
			DestinationWell -> resolvedDestWells,
			Diluent -> resolvedDiluent,
			ConcentratedBuffer -> resolvedConcentratedBuffer,
			BufferDilutionFactor -> resolvedBufferDilutionFactor,
			BufferDiluent -> resolvedBufferDiluent,
			MixOrder -> mixOrder,
			Mix -> resolvedMixes,
			MixType ->resolvedMixType,
			NumberOfMixes->resolvedNumberOfMixes,
			MixUntilDissolved->resolvedMixUntilDissolveds,
			IncubationTime->resolvedIncubationTimes,
			MaxIncubationTime->resolvedMaxIncubationTimes,
			IncubationTemperature->resolvedIncubationTemperatures,
			AnnealingTime->resolvedAnnealingTimes,
			IncubationInstrument->resolvedIncubationInstruments,
			Preparation -> preparation,
			WorkCell -> workCell,
			Confirm -> confirm,
			CanaryBranch -> canaryBranch,
			Name -> name,
			Template -> template,
			SamplesOutStorageCondition -> samplesOutStorageCondition,
			PreparatoryUnitOperations -> Lookup[myOptions, PreparatoryUnitOperations],
			Cache -> cache,
			Email -> email,
			FastTrack -> fastTrack,
			Operator -> operator,
			Output -> outputOption,
			ParentProtocol -> parentProtocol,
			Upload -> upload,
			SampleLabel -> resolvedSampleLabel,
			SampleContainerLabel -> resolvedSampleContainerLabel,
			SampleOutLabel -> resolvedSampleOutLabel,
			ContainerOutLabel -> resolvedContainerOutLabel,
			DiluentLabel -> resolvedDiluentLabel,
			ConcentratedBufferLabel -> resolvedConcentratedBufferLabel,
			BufferDiluentLabel -> resolvedBufferDiluentLabel,
			resolvedPostProcessingOptions
		}]
	];

	(* --- Just kidding one more error check --- *)

	(* make sure that if there replicates, all the entries are the same across everything *)
	replicatesQ = Not[DuplicateFreeQ[samplePackets]];

	(* get the MapThread-friendly resolved options *)
	mapThreadFriendlyResolvedOptions = OptionsHandling`Private`mapThreadOptions[If[resuspendQ, ExperimentResuspend, ExperimentDilute], resolvedOptions];

	(* transpose the sample packets together with the map thread friendly options and then gather them by sample *)
	samplesAndResolvedOptions = Transpose[{samplePackets, mapThreadFriendlyResolvedOptions}];
	gatheredSamplesAndResolvedOptions = GatherBy[samplesAndResolvedOptions, #[[1]]&];

	(* get the duplicate gatherings *)
	duplicateGatherings = Select[gatheredSamplesAndResolvedOptions, Length[#] > 1&];

	(* for each duplicate gathering, make sure all the options are the same values (using == for numbers and SameObjectQ for objects) *)
	duplicateDifferentOptions = Map[
		Function[{gatheringOfDuplicates},
			KeyValueMap[
				(* not counting ContainerOut because that is a weird case *)
				(* doing this Quiet becuase if you're comparing numbers with different units then it will get grumpy and throw a message, when really I just want it to return False *)
				If[MatchQ[#1, ContainerOut] || SameQ @@ #2 || Quiet[TrueQ[Equal @@ #2]] || ECL`SameObjectQ @@ #2,
					Nothing,
					#1
				]&,
				(* this means we're mapping over each option rather than each sample's list of all options *)
				Merge[gatheringOfDuplicates[[All, 2]], Identity]
			]
		],
		duplicateGatherings
	];

	(* get the duplicate samples that have different options *)
	badDuplicateSamples = First /@ PickList[duplicateGatherings[[All, 1]], duplicateDifferentOptions, Except[{}]];
	badDuplicateOptions = Cases[duplicateDifferentOptions, Except[{}]];

	(* throw a message if there are duplicates with differently specified options *)
	duplicateSampleOptions = If[Not[MatchQ[badDuplicateSamples, {}]] && messages,
		(
			Message[Error::DuplicateSampleConflictingConditions, ObjectToString[badDuplicateSamples, Cache -> inheritedCache], badDuplicateOptions];
			Flatten[badDuplicateOptions]
		),
		{}
	];
	duplicateSampleTests = If[gatherTests,
		Test["If duplicate samples are specified, all options between these samples are the same:",
			MatchQ[badDuplicateSamples, {}],
			True
		]
	];

	(* combine all the invalid options *)
	invalidOptions = DeleteDuplicates[Join[
		nameInvalidOptions,
		concentrationRatioMismatchOptions,
		containerOutMismatchedIndexOptions,
		invalidDestWellOptions,
		containerOverOccupiedOptions,
		volumeOverContainerMaxOptions,
		noMolecularWeightInvalidOptions,
		stateAmountMismatchOptions,
		cannotResolveVolumeOptions,
		partialResuspensionInCurrentContainerOptions,
		duplicateSampleOptions,
		bufferDilutionMismatchOptions,
		overspecifiedBufferInvalidOptions,
		bufferTooConcentratedOptions,
		noConcentrationOptions,
		targetConcentrationTooLargeOptions,
		initialVolumeTooHighOptions,
		typeAndInstrumentMismatchOptions,
		typeAndNumberOfMixesMismatchOptions,
		typeAndIncubationMismatchOptions,
		preparationInvalidOptions
	]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* combine the invalid inputs *)
	invalidInputs = DeleteDuplicates[Join[
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		cannotResolveAmountInvalidInputs,
		nonSolidSampleInputs
	]];

	(* throw the InvalidInputs error if necessary *)
	If[Not[MatchQ[invalidInputs, {}]] && messages,
		Message[Error::InvalidInput, invalidInputs]
	];

	(* gather all the tests together *)
	allTests = Cases[Flatten[{
		discardedTest,
		deprecatedTest,
		nonSolidSampleTest,
		validNameTest,
		cannotResolveAmountTests,
		potentialAnalyteTests,
		concentrationRatioMismatchTest,
		containerOutMismatchedIndexTest,
		invalidDestWellTest,
		containerOverOccupiedTest,
		volumeOverContainerMaxTest,
		unknownAmountWarningTests,
		noMolecularWeightTests,
		stateAmountMismatchTests,
		targetConcNotUsedTests,
		cannotResolveVolumeTest,
		partialResuspensionInCurrentContainerTest,
		duplicateSampleTests,
		bufferDilutionInvalidTest,
		overspecifiedBufferInvalidTest,
		bufferTooConcentratedTests,
		noConcentrationTest,
		targetConcentrationTooLargeTest,
		initialVolumeTooHighTests,
		typeAndInstrumentMismatchTests,
		typeAndNumberOfMixesMismatchTests,
		typeAndIncubationMismatchTests,
		preparationInvalidTest
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
(*resuspendOrDiluteResourcePackets *)

(* function to populate the fields of this resuspend protocol and make all the resources *)
(* importantly, this calls ExperimentSamplePreparation *)
resuspendOrDiluteResourcePackets[myType : Resuspend|Dilute, mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule},  ops : OptionsPattern[resuspendOrDiluteResourcePackets]] := Module[
	{
		expandedResolvedOptions, resolvedOptionsNoHidden, resolvedConcentratedBuffer, resolvedDiluent,mixPrimitivesSetUp,
		resolvedBufferDiluent, specifiedContainerOut, allBufferModels, allBufferObjs, containerOutModels,
		containerOutObjs, resolvedTargetConcentrationAnalyte, samplesOutStorageCondition,
		outputSpecification, output, gatherTests, messages, inheritedCache,
		samplePackets, sampleContainerPackets, sameContainerQs, resolvedBufferDilutionFactor,
		sampleContainerModelPackets, bufferModelPackets, bufferContainerPackets,
		bufferContainerModelPackets, containerOutPackets, containerOutModelPackets, resolvedVolume,
		resolvedTargetConcentration, resolvedContainerOut, resolvedContainerOutWithPacket,
		transferDests, allTransferManipulations, uniqueSamplesInResources, samplesInResources, totalDiluentVolumes,
		protocolTests, resolvedOpsFinal, resolvedInitialVolume, currentAmounts, labelSampleUOToPrepend, sampleToLabelRules,
		previewRule, optionsRule, testsRule, resultRule, resolvedDestWell, containerOutIndices,
		containerOutIndexReplaceRules, resolvedAmount, resolvedAmountOptions, finalTransferPrimitives,
		labelPrimitives, labelContainerPrimitivesNoDupes, mapThreadFriendlyOptions, mixPrimitives, resuspendQ,
		groupedTransferPrimitives, protPacketFinal, concBufferVolumes, bufferDiluentVolumes,
		modelExchangedInputs, expandedResolvedOptionsWithLabels, resolvedPreparation, simulation, allUnitOperationPackets, runTime,
		updatedSimulation, resolvedWorkCell, experimentFunction, resuspendUnitOperationBlobs, simulatedObjectsToLabel,
		resuspendUnitOperationPacketsNotLinked, resuspendUnitOperationPackets, simulationRule, sortedFutureLabeledObjects,
		sortedSampleOutFutureLabeledObjects,unsortedSampleOutFutureLabeledObjects,unsortedFutureLabeledObjects,
		samplesOutLabels,protPacket,accessoryProtPackets,finalSimulation,protocolPackets,containerOutLabel,
		bufferObjectPackets, sampleOutLabel, labelSamplePrimitives, bufferVolumeRules, uniqueBufferVolumeRules,
		bufferLabelSamplePrimitives, bufferLabelReplaceRules, sampleLabel,
		sampleContainerLabel,diluentLabel, bufferDiluentLabel, concentratedBufferLabel, resolvedPrepUOs
	},

	(* simplify the Type to be Dilute/Resuspend *)
	resuspendQ = MatchQ[myType, Resuspend];
	{resolvedPreparation, resolvedWorkCell} = Lookup[myResolvedOptions, {Preparation, WorkCell}];

	(* expand the resolved options if they weren't expanded already *)
	expandedResolvedOptions = If[resuspendQ,
		Last[ExpandIndexMatchedInputs[ExperimentResuspend, {mySamples}, myResolvedOptions]],
		Last[ExpandIndexMatchedInputs[ExperimentDilute, {mySamples}, myResolvedOptions]]
	];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = If[resuspendQ,
		CollapseIndexMatchedOptions[
			ExperimentResuspend,
			RemoveHiddenOptions[ExperimentResuspend, myResolvedOptions],
			Ignore -> myUnresolvedOptions,
			Messages -> False
		],
		CollapseIndexMatchedOptions[
			ExperimentDilute,
			RemoveHiddenOptions[ExperimentDilute, myResolvedOptions],
			Ignore -> myUnresolvedOptions,
			Messages -> False
		]
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[expandedResolvedOptions, Output];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* get the inherited cache and simulation *)
	{inheritedCache, simulation} = Lookup[ToList[ops], {Cache, Simulation}];

	(* --- Make our one big Download call --- *)

	(* pull out the ConcentratedBuffer, Diluent, BufferDiluent, and ContainerOut options *)
	{
		resolvedDiluent,
		resolvedConcentratedBuffer,
		resolvedBufferDiluent,
		resolvedBufferDilutionFactor,
		specifiedContainerOut,
		samplesOutStorageCondition,
		resolvedInitialVolume,
		containerOutLabel,
		sampleOutLabel,
		sampleLabel,
		sampleContainerLabel,
		diluentLabel,
		bufferDiluentLabel,
		concentratedBufferLabel,
		resolvedPrepUOs
	} = Lookup[
		expandedResolvedOptions,
		{
			Diluent,
			ConcentratedBuffer,
			BufferDiluent,
			BufferDilutionFactor,
			ContainerOut,
			SamplesOutStorageCondition,
			InitialVolume,
			ContainerOutLabel,
			SampleOutLabel,
			SampleLabel,
			SampleContainerLabel,
			DiluentLabel,
			BufferDiluentLabel,
			ConcentratedBufferLabel,
			PreparatoryUnitOperations
		}
	];

	(* get all the buffers that were specified as models and objects *)
	allBufferModels = Cases[Flatten[{resolvedConcentratedBuffer, resolvedDiluent, resolvedBufferDiluent}], ObjectP[Model[Sample]]];
	allBufferObjs = Cases[Flatten[{resolvedConcentratedBuffer, resolvedDiluent, resolvedBufferDiluent}], ObjectP[Object[Sample]]];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Object[Container]]];

	(* pull out all the sample/sample model/container/container model packets; also get these in the proper shape that the samples are in *)
	samplePackets = fetchPacketFromCache[#, inheritedCache]& /@ mySamples;
	sampleContainerPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[samplePackets, Container, {}], Object];
	sampleContainerModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[sampleContainerPackets, Model, {}], Object];

	(* get the ContainerOut object and model packets (again like with the buffers, these two don't have to be the same length) *)
	containerOutPackets = fetchPacketFromCache[#, inheritedCache]& /@ containerOutObjs;
	containerOutModelPackets = DeleteDuplicates[fetchPacketFromCache[#, inheritedCache]& /@ Flatten[{Download[Lookup[containerOutPackets, Model, {}], Object], containerOutModels}]];

	(* get the packets for the buffer objects*)
	bufferObjectPackets = fetchPacketFromCache[#, inheritedCache]& /@ allBufferObjs;
	bufferModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Flatten[{Download[Lookup[bufferObjectPackets, Model, {}], Object], allBufferModels}];
	bufferContainerPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[bufferObjectPackets, Container, {}], Object];
	bufferContainerModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[Lookup[bufferContainerPackets, Model, {}], Object];

	(* --- Make all the transfer manipulations of the samples --- *)

	(* split the resolved options into MapThread friendly options *)
	mapThreadFriendlyOptions = If[resuspendQ,
		OptionsHandling`Private`mapThreadOptions[ExperimentResuspend, expandedResolvedOptions],
		OptionsHandling`Private`mapThreadOptions[ExperimentDilute, expandedResolvedOptions]
	];

	(* get the LabelSample unit operation we're going to be using here *)
	labelSampleUOToPrepend = If[MatchQ[resolvedPrepUOs, {_[_LabelSample]}],
		resolvedPrepUOs[[1, 1]],
		Null
	];

	(* get the samples from labels from the LabelSample we're prepending *)
	sampleToLabelRules = If[NullQ[labelSampleUOToPrepend] || Not[MatchQ[simulation, _Simulation]],
		{},
		With[
			{
				labelRules = Lookup[simulation[[1]], Labels],
				prepUOLabels = Flatten[{labelSampleUOToPrepend[Label], labelSampleUOToPrepend[ContainerLabel]}]
			},
			Reverse /@ Select[labelRules, MemberQ[prepUOLabels, #[[1]]]&]
		]
	];

	(* update the simulation to _not_ have the labels that we are adding above *)
	updatedSimulation = If[NullQ[simulation],
		Null,
		With[{oldLabelRules = Lookup[First[simulation], Labels], labelsToRemove = Values[sampleToLabelRules]},
			Simulation[
				Append[
					First[simulation],
					Labels -> Select[oldLabelRules, Not[MemberQ[labelsToRemove, #[[1]]]]&]
				]
			]
		]
	];

	(* pull out the Volume, Mass, Volume, TargetConcentration, TargetConcentrationAnalyte, ContainerOut, and DestinationWell (and BufferDilutionFactor) options *)
	{resolvedAmount, resolvedVolume, resolvedTargetConcentration, resolvedTargetConcentrationAnalyte, resolvedContainerOut, resolvedDestWell} = Lookup[expandedResolvedOptions, {Amount, If[resuspendQ, Volume, TotalVolume], TargetConcentration, TargetConcentrationAnalyte, ContainerOut, DestinationWell}];

	(* get the resolved container out with packets instead of objects *)
	resolvedContainerOutWithPacket = Map[
		Function[{indexAndContainer},
			{indexAndContainer[[1]], fetchPacketFromCache[Download[indexAndContainer[[2]], Object], inheritedCache]}
		],
		resolvedContainerOut
	];

	(* deterimine if the sample in question is staying in its existing container, or if it is moving to a new one *)
	sameContainerQs = MapThread[
		MatchQ[Lookup[#1, Container], ObjectP[Lookup[#2, Object]]]&,
		{samplePackets, resolvedContainerOutWithPacket[[All, 2]]}
	];

	(* get the current amount of the given sample we have *)
	currentAmounts = Map[
		If[resuspendQ,
			Which[
				MatchQ[Lookup[#, State], Liquid | Gas], Null,
				IntegerQ[Lookup[#, Count]], Lookup[#, Count],
				MassQ[Lookup[#, Mass]], Lookup[#, Mass],
				True, Null
			],
			Lookup[#, Volume]
		]&,
		samplePackets
	];

	(* get all the integers we care about in the resolved ContainerOut, and turn those into replace rules to turn them into Unique[]s for the transfers below *)
	containerOutIndices = DeleteDuplicates[resolvedContainerOut[[All, 1]]];
	containerOutIndexReplaceRules = Map[
		# -> Unique[]&,
		containerOutIndices
	];

	(* create the define primitives for the destinations *)
	labelPrimitives = MapThread[
		LabelContainer[Container -> Lookup[#1[[2]], Object], Label ->#2]&,
		{resolvedContainerOutWithPacket,containerOutLabel}
	];

	(* make the LabelSample primitives for the input samples and the destinations *)
	(* note that if this label is already taken by the PreparatoryUnitOperation UnitOperation above, then don't put it in here *)
	labelSamplePrimitives = DeleteDuplicates[Flatten[MapThread[
		If[StringQ[#3] && StringQ[#4] && Not[MemberQ[Values[sampleToLabelRules], #3]],
			LabelSample[
				Sample -> Lookup[#1, Object],
				Container -> Lookup[#2, Object],
				Label -> #3,
				ContainerLabel -> #4],
			Nothing
		]&,
		{samplePackets, sampleContainerPackets, sampleLabel, sampleContainerLabel}
	]]];


	(* get the destination names from the define primitives *)
	transferDests = MapThread[
		If[MatchQ[#3[[2]], nonPlateContainerP],
			{"A1",#1[Label]},
			{#2,#1[Label]}
		]&,
		{labelPrimitives, resolvedDestWell, resolvedContainerOutWithPacket}
	];

	(* remove the LabelContainer primitives that are repetitive with the LabelSample from model inputs *)
	(* must do this here because the above transferDests call still is necessary to get the transfers created properly *)
	labelContainerPrimitivesNoDupes = Select[labelPrimitives, Not[MemberQ[Values[sampleToLabelRules], #[Label]]]&];

	(* calculate the total diluent volume (i.e., if resuspending this the same as the InitialVolume, or if Diluting this is InitialVolume - Amount) *)
	totalDiluentVolumes = If[resuspendQ,
		resolvedInitialVolume,
		SafeRound[resolvedInitialVolume - resolvedAmount, 1 Microliter]
	];

	(* calculate the concentrated buffer volume and the buffer dliuent volume (if we are using those options) *)
	(* note that I am using the InitialVolume and not the resolved Volume/TotalVolume in here because we are adding these to the source sample and then (potentially) transferring the Volume/TotalVolume out *)
	(* this is different for Dilute *)
	(* The resolved volumes here need to comply with the precision of LabelSample *)
	{concBufferVolumes, bufferDiluentVolumes} = Transpose[MapThread[
		Function[{volume, diluent, bufferDilutionFactor, amount},
			(* if Diluent is populated, then we aren't using the ConcentratedBuffer system so all Null; otherwise, figure out how much concentrated buffer vs diluent *)
			Which[
				MatchQ[diluent, ObjectP[]], {Null, Null},
				resuspendQ, {SafeRound[volume / bufferDilutionFactor, 1 Microliter], SafeRound[volume - (volume / bufferDilutionFactor), 1 Microliter]},
				True, {SafeRound[volume / bufferDilutionFactor, 1 Microliter], SafeRound[volume - (amount + (volume / bufferDilutionFactor)), 1 Microliter]}
			]
		],
		{resolvedInitialVolume, resolvedDiluent, resolvedBufferDilutionFactor, currentAmounts}
	]];


	(* make the LabelSample primitives for all Diluents, BufferDiluents, and ConcentratedBuffers *)
	(* Create the volume rules for the buffers (with labels) *)
	bufferVolumeRules=MapThread[
		If[StringQ[#2],
			{#1,#2}->#3,
			Nothing
		]&,
		{
			Flatten[{resolvedDiluent, resolvedBufferDiluent, resolvedConcentratedBuffer}],
			Flatten[{diluentLabel, bufferDiluentLabel, concentratedBufferLabel}],
			Flatten[{totalDiluentVolumes,bufferDiluentVolumes,concBufferVolumes}]
		}

	];
	(* Merge the buffer volumes together to get the total volume of each buffer's resource *)
	uniqueBufferVolumeRules=Merge[bufferVolumeRules,Total];
	bufferLabelSamplePrimitives = KeyValueMap[
		LabelSample[
			Sample -> #1[[1]],
			Label -> #1[[2]],
			(* Do not give Amount to Object[Sample] *)
			Amount -> If[MatchQ[#1[[1]],ObjectP[Model]],
				#2,
				Null
			],
			Container -> If[MatchQ[#1[[1]], ObjectP[Model]], PreferredContainer[#2], Automatic],
			ContainerLabel -> StringJoin["Container of ",#1[[2]]]
		]&,
		uniqueBufferVolumeRules
	];

	bufferLabelReplaceRules=Map[
		(#[Sample]->#[Label])&,
		bufferLabelSamplePrimitives
	];

	(* generate the transfer primitives as a list of lists *)
	groupedTransferPrimitives = MapThread[
		Function[{samplePacket, dest, sameContainerQ, diluent, concBuffer, bufferDiluent, concBufferVolume, bufferDiluentVolume, totalDiluentVolume},

			Module[{sampleOutLabelReplaceRules,sampleOutLabelsForTransfer},

			(* make replace rules converting ContainerOutLabel + DestinationWell pairs into the SampleOutLabel *)
			sampleOutLabelReplaceRules = MapThread[
				{#2, #1} -> #3&,
				{containerOutLabel, resolvedDestWell, sampleOutLabel}
			];

			sampleOutLabelsForTransfer = dest /. sampleOutLabelReplaceRules;

			Which[
				(* if we are in the same container, then just transfer diluent directly into the sample *)
				sameContainerQ && MatchQ[diluent, ObjectP[]],
					{
						If[MatchQ[resolvedPreparation, Manual],
							Transfer[
								Source -> diluent/.bufferLabelReplaceRules,
								Amount -> totalDiluentVolume,
								Destination -> dest,
								DestinationLabel -> Replace[sampleOutLabelsForTransfer, _List :> Null, {1}],
								DestinationContainerLabel -> dest[[2]]
							],
							Transfer[
								Source -> diluent/.bufferLabelReplaceRules,
								Amount -> totalDiluentVolume,
								Destination -> dest,
								DestinationLabel -> Replace[sampleOutLabelsForTransfer, _List :> Null, {1}],
								DestinationContainerLabel -> dest[[2]],
								DispensePosition -> Bottom,
								DispensePositionOffset -> 2 Millimeter
							]
						]
					},
				(* if we are in the same container and are using the conc buffer/buffer diluent, then just transfer conc buffer + buffer diluent directly into the sample *)
				sameContainerQ,
				{
					If[
						MatchQ[resolvedPreparation, Manual],
						Transfer[
							Source -> {bufferDiluent /. bufferLabelReplaceRules, concBuffer/.bufferLabelReplaceRules},
							Amount -> {bufferDiluentVolume, concBufferVolume},
							Destination -> dest,
							DestinationLabel -> Replace[sampleOutLabelsForTransfer, _List :> Null, {1}],
							DestinationContainerLabel ->  dest[[2]]
						],
						Transfer[
							Source -> {bufferDiluent /. bufferLabelReplaceRules, concBuffer/.bufferLabelReplaceRules},
							Amount -> {bufferDiluentVolume, concBufferVolume},
							Destination -> dest,
							DestinationLabel -> Replace[sampleOutLabelsForTransfer, _List :> Null, {1}],
							DestinationContainerLabel -> dest[[2]],
							DispensePosition -> Bottom,
							DispensePositionOffset -> 2 Millimeter
						]
					]
				},
				(* if we are not in the same container, transfer the sample and diluent to the new container *)
				Not[sameContainerQ] && MatchQ[diluent, ObjectP[]],
					{
						If[MatchQ[resolvedPreparation, Manual],
							Transfer[
								Source -> diluent/.bufferLabelReplaceRules,
								Amount -> totalDiluentVolume,
								Destination -> Lookup[samplePacket, Object]
							],
							Transfer[
								Source -> diluent/.bufferLabelReplaceRules,
								Amount -> totalDiluentVolume,
								Destination -> Lookup[samplePacket, Object],
								DispensePosition -> Bottom,
								DispensePositionOffset -> 2 Millimeter
							]
						]
					},
				(* otherwise, we are using the conc buffer/buffer diluent system so transfer sample, buffer diluent, and concentrated buffer into the new container *)
				True,
					{
						If[MatchQ[resolvedPreparation, Manual],
							Transfer[
								Source -> {bufferDiluent /. bufferLabelReplaceRules, concBuffer/.bufferLabelReplaceRules},
								Amount -> {bufferDiluentVolume, concBufferVolume},
								Destination -> Lookup[samplePacket, Object]
							],
							Transfer[
								Source -> {bufferDiluent /. bufferLabelReplaceRules, concBuffer/.bufferLabelReplaceRules},
								Amount -> {bufferDiluentVolume, concBufferVolume},
								Destination -> Lookup[samplePacket, Object],
								DispensePosition -> Bottom,
								DispensePositionOffset -> 2 Millimeter
							]
						]
					}

			]]
		],
		{samplePackets, transferDests, sameContainerQs, resolvedDiluent, resolvedConcentratedBuffer, resolvedBufferDiluent, concBufferVolumes, bufferDiluentVolumes, totalDiluentVolumes}
	];

	(* determine what to put in the resolved Amount field; we want to put All instead of an Amount if the Amount is equal/greater than the sample's current Amount *)
	resolvedAmountOptions = MapThread[
		Which[
			(* if there's only one manipulation here, then that means we're resuspending everything *)
			Length[#2] == 1, All,
			(* if there are two manipulations but count/mass/volume is >= the current value, also All *)
			CompatibleUnitQ[Lookup[#1, Count], First[#2][Amount]] && Lookup[#1, Count] <= First[#2][Amount], All,
			CompatibleUnitQ[Lookup[#1, If[resuspendQ, Volume, TotalVolume]], First[#2][Amount]] && Lookup[#1, If[resuspendQ, Volume, TotalVolume]] <= First[#2][Amount], All,
			CompatibleUnitQ[Lookup[#1, Mass], First[#2][Amount]] && Lookup[#1, Mass] <= First[#2][Amount], All,
			True, First[#2][Amount]
		]&,
		{samplePackets, groupedTransferPrimitives}
	];

	(* calculate the resolved options that are actually going to go into the aliquot protocol object *)
	resolvedOpsFinal = ReplaceRule[myResolvedOptions, Amount -> resolvedAmountOptions];

	(* get the mix primitives for each option*)
	(* if using mixing by pipette, use a Mix primitive and not an incubate one *)
	(* if MixOrder->Serial, go nuts creating these. If MixOrder->Parallel, then we need to combine them. *)
	mixPrimitivesSetUp = MapThread[
		Which[
			MatchQ[Lookup[#1,Mix],(False|Null)],Null,

			MatchQ[Lookup[#1, MixType], Pipette],
				Mix[
					Sample -> Lookup[#2, Object],
					MixType -> Lookup[#1, MixType],
					MixVolume -> Max[Min[Lookup[#1, InitialVolume] / 2, 970*Microliter], 1 Microliter],
					NumberOfMixes -> Lookup[#1, NumberOfMixes]
				],
			True,
				If[MatchQ[Lookup[expandedResolvedOptions, MixOrder],Serial],
					Incubate[
						Sample -> Lookup[#2, Object],
						Time -> Lookup[#1, IncubationTime],
						MaxTime -> Lookup[#1, MaxIncubationTime],
						MixType -> Lookup[#1, MixType],
						MixUntilDissolved -> Lookup[#1, MixUntilDissolved],
						Instrument -> Lookup[#1, IncubationInstrument],
						Temperature -> (Lookup[#1, IncubationTemperature] /. {Null -> Ambient}),
						AnnealingTime -> Lookup[#1, AnnealingTime]
					],
					(* if MixOrder was not Serial (aka was parallel), store these values for us to combine later *)
					{#1,#2}
				]
		]&,
		{mapThreadFriendlyOptions, samplePackets}
	];

	mixPrimitives=Which[
		(* check if any of the mix primitives set up matches our stored pattern, in which case we will set up the combined primitive here *)
		MemberQ[mixPrimitivesSetUp,{_?AssociationQ,_?AssociationQ}],

		Module[{primitivesToCombine,tempPrimitivesOptions,tempPrimitivesSample},
			primitivesToCombine=Cases[mixPrimitivesSetUp,{_?AssociationQ, _?AssociationQ}];
			tempPrimitivesSample=Last@Transpose@primitivesToCombine;
			tempPrimitivesOptions=First@Transpose@primitivesToCombine;
			Flatten@{
				Cases[mixPrimitivesSetUp,Except[{_?AssociationQ, _?AssociationQ}]],
				Incubate[
					Sample->Lookup[tempPrimitivesSample,Object],
					Time->Lookup[tempPrimitivesOptions,IncubationTime],
					MaxTime->Lookup[tempPrimitivesOptions,MaxIncubationTime],
					MixType->Lookup[tempPrimitivesOptions,MixType],
					MixUntilDissolved->Lookup[tempPrimitivesOptions,MixUntilDissolved],
					Instrument->Lookup[tempPrimitivesOptions,IncubationInstrument],
					Temperature->(Lookup[tempPrimitivesOptions,IncubationTemperature]/.{Null->Ambient}),
					AnnealingTime->Lookup[tempPrimitivesOptions,AnnealingTime]
				]
			}],

		(* if it doesn't match, that means standard primitives were made and we can just keep it *)
		True,
		mixPrimitivesSetUp
	];

	(* get the mix primitives, the sample containers, and the map thread options transposed together so we can delete some duplicates *)
	(* the DeleteDuplicatesBy call is a little weird because we do not want to delete any Mix duplicates but we do want to remove any incubate duplicates *)
	(*groupedMixPrimitives = Transpose[{mixPrimitives, sampleContainerPackets, mapThreadFriendlyOptions}];
	groupedMixPrimitivesNoDupes = DeleteDuplicatesBy[groupedMixPrimitives, {If[MatchQ[#[[1]], _Mix|Null], Unique[], True], #[[2]], Lookup[#[[3]], {Time, MaxTime, MixType, MixUntilDissolved, Instrument, Temperature, AnnealingTime}]}&];
	mixPrimitivesNoDupes = groupedMixPrimitivesNoDupes[[All, 1]];*)

	(* make the primitives for transferring the samples to their new containers (if necessary)*)
	(* generate the transfer primitives as a list of lists *)
	finalTransferPrimitives = MapThread[
		Function[{samplePacket, dest, sameContainerQ, volume},
			Module[{sampleOutLabelReplaceRules,sampleOutLabelsForTransfer},

				(* make replace rules converting ContainerOutLabel + DestinationWell pairs into the SampleOutLabel *)
				sampleOutLabelReplaceRules = MapThread[
					{#2, #1} -> #3&,
					{containerOutLabel, resolvedDestWell, sampleOutLabel}
				];

				sampleOutLabelsForTransfer = dest /. sampleOutLabelReplaceRules;

				(* if not changing the container then there is no final transfer at all*)
				If[sameContainerQ,
					{},
					Transfer[
						Source -> Lookup[samplePacket, Object],
						Amount -> volume,
						Destination -> dest,
						DestinationLabel -> Replace[sampleOutLabelsForTransfer, _List :> Null, {1}],
						DestinationContainerLabel -> dest[[2]]
					]
				]
			]
		],
		{samplePackets, transferDests, sameContainerQs, resolvedVolume}
	];

	(* put all the primitives together *)
	(* DeleteDuplicates since don't want to do the same thing multiple times*)
	(* that /. sampleToLabelRules at the end is important because if we had model inputs, then we might have simulated objets here and we don't want that *)
	allTransferManipulations = DeleteDuplicates[Flatten[{
		If[NullQ[labelSampleUOToPrepend], Nothing, labelSampleUOToPrepend],
		DeleteDuplicates[labelContainerPrimitivesNoDupes],
		DeleteDuplicates[labelSamplePrimitives],
		DeleteDuplicates[bufferLabelSamplePrimitives],
		(* note that if we are doing Serial, go wild with the mixes, but if we are doing Parallel, only use the duplicate-deleted ones *)
		DeleteCases[Flatten[If[MatchQ[Lookup[expandedResolvedOptions, MixOrder], Serial],
			MapThread[
				{#1, #2, #3}&,
				{groupedTransferPrimitives, mixPrimitives, finalTransferPrimitives}
			],
			{groupedTransferPrimitives, mixPrimitives, finalTransferPrimitives}
		]], Null]
	}]] /. sampleToLabelRules;

	(* --- get the unit operation packets for the UOs made above; need to replicate what ExperimentRoboticSamplePreparation does if that is what is happening (otherwise just do nothing) ---*)

	(* Create Resources for input sample *)
	(* We need resources here if our samples are simulated as we cannot upload non-existing IDs to the Sample field of the Resuspend/Dilute UO *)
	(* By providing resources, the fields points back to the original model, if necessary *)
	(* We only use this for RSP Dilute/Resuspend UO, which basically means we won't do resource picking on these directly. *)
	(* Create a lookup of each unique sample to a resource of that sample *)
	uniqueSamplesInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&) /@ DeleteDuplicates[Download[mySamples, Object]];

	(* Use the lookup to create a flat resource list *)
	(* note that we are only using these resources if we are _not_ in _LabelSample land *)
	(* this is because if we have a simulated sample that is just in sequence with a bunch of normal UOs, then we need to make resources (but if we're using model inputs, it shouldn't be necessary I think (?)) *)
	samplesInResources = (Download[mySamples, Object]) /. uniqueSamplesInResources;

	(* exchange samples to models here; note that we do not need resources here because we'll have them below in the RoboticUnitOperations *)
	(* NOTE: using simulation and not updatedSimulation because this needs to be using the simulation from before we removed labels *)
	modelExchangedInputs = If[MatchQ[First[allTransferManipulations], _LabelSample],
		simulatedSamplesToModels[
			First[allTransferManipulations],
			simulation,
			mySamples
		],
		samplesInResources
	];

	(* Resolve the experiment function (MSP/RSP/MCP/RCP) to call using the shared helper function *)
	experimentFunction = If[MatchQ[resolvedPreparation, Manual],
		resolveManualFrameworkFunction[mySamples, myResolvedOptions, Cache -> inheritedCache, Simulation -> simulation],
		Lookup[$WorkCellToExperimentFunction, resolvedWorkCell]
	];

	(* make unit operation packets for the UOs we just made here *)
	{{allUnitOperationPackets,runTime}, updatedSimulation} = If[MatchQ[resolvedPreparation, Manual],
		{{{},(Length[Flatten[mySamples]] * 20 Second)}, updatedSimulation},
		(* quieting this message (like Aliquot) because I can't figure out where it's coming from and it doesn't seem to do anything; TODO please figure this out; task here  *)
		Quiet[experimentFunction[
			allTransferManipulations,
			UnitOperationPackets -> True,
			Output -> {Result, Simulation},
			FastTrack -> Lookup[expandedResolvedOptions, FastTrack],
			ParentProtocol -> Lookup[expandedResolvedOptions, ParentProtocol],
			Name -> Lookup[expandedResolvedOptions, Name],
			Simulation -> updatedSimulation,
			Upload -> False,
			ImageSample -> Lookup[expandedResolvedOptions, ImageSample],
			MeasureVolume -> Lookup[expandedResolvedOptions, MeasureVolume],
			MeasureWeight -> Lookup[expandedResolvedOptions, MeasureWeight],
			Priority -> Lookup[expandedResolvedOptions, Priority],
			StartDate -> Lookup[expandedResolvedOptions, StartDate],
			HoldOrder -> Lookup[expandedResolvedOptions, HoldOrder],
			QueuePosition -> Lookup[expandedResolvedOptions, QueuePosition]
		], Warning::UnableToExpandInputs]
	];

	(* determine which objects in the simulation are simulated and make replace rules for those *)
	simulatedObjectsToLabel = If[NullQ[simulation],
		{},
		Module[{allObjectsInSimulation, simulatedQ},
			(* Get all objects out of our simulation. *)
			allObjectsInSimulation = Download[Lookup[simulation[[1]], Labels][[All, 2]], Object];

			(* Figure out which objects are simulated. *)
			simulatedQ = Experiment`Private`simulatedObjectQs[allObjectsInSimulation, simulation];

			(Reverse /@ PickList[Lookup[simulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
		]
	];

	(* get the resolved options with simulated objects replaced with labels *)
	expandedResolvedOptionsWithLabels = expandedResolvedOptions /. simulatedObjectsToLabel;

	(* make the resuspend or dilute unit operation blob *)
	resuspendUnitOperationBlobs = If[MatchQ[resolvedPreparation, Robotic],
		If[resuspendQ,
			Resuspend[
				Sample -> modelExchangedInputs,
				SampleLabel -> Lookup[expandedResolvedOptionsWithLabels, SampleLabel],
				SampleContainerLabel -> Lookup[expandedResolvedOptionsWithLabels, SampleContainerLabel],
				SampleOutLabel -> Lookup[expandedResolvedOptionsWithLabels, SampleOutLabel],
				ContainerOutLabel -> Lookup[expandedResolvedOptionsWithLabels, ContainerOutLabel],
				DiluentLabel -> Lookup[expandedResolvedOptionsWithLabels, DiluentLabel],
				ConcentratedBufferLabel -> Lookup[expandedResolvedOptionsWithLabels, ConcentratedBufferLabel],
				BufferDiluentLabel -> Lookup[expandedResolvedOptionsWithLabels, BufferDiluentLabel],
				Amount -> Lookup[expandedResolvedOptionsWithLabels, Amount],
				TargetConcentration -> Lookup[expandedResolvedOptionsWithLabels, TargetConcentration],
				TargetConcentrationAnalyte -> Lookup[expandedResolvedOptionsWithLabels, TargetConcentrationAnalyte],
				Volume -> Lookup[expandedResolvedOptionsWithLabels, Volume],
				InitialVolume-> Lookup[expandedResolvedOptionsWithLabels, InitialVolume],
				ContainerOut -> Lookup[expandedResolvedOptionsWithLabels, ContainerOut],
				DestinationWell -> Lookup[expandedResolvedOptionsWithLabels, DestinationWell],
				ConcentratedBuffer -> Lookup[expandedResolvedOptionsWithLabels, ConcentratedBuffer],
				BufferDilutionFactor -> Lookup[expandedResolvedOptionsWithLabels, BufferDilutionFactor],
				BufferDiluent -> Lookup[expandedResolvedOptionsWithLabels, BufferDiluent],
				Diluent -> Lookup[expandedResolvedOptionsWithLabels, Diluent],
				SamplesOutStorageCondition -> Lookup[expandedResolvedOptionsWithLabels, SamplesOutStorageCondition],
				Preparation -> resolvedPreparation,
				WorkCell -> resolvedWorkCell,
				Mix->Lookup[expandedResolvedOptionsWithLabels, Mix],
				MixType->Lookup[expandedResolvedOptionsWithLabels, MixType],
				NumberOfMixes->Lookup[expandedResolvedOptionsWithLabels, NumberOfMixes],
				MixUntilDissolved->Lookup[expandedResolvedOptionsWithLabels, MixUntilDissolved],
				IncubationTime->Lookup[expandedResolvedOptionsWithLabels, IncubationTime],
				MaxIncubationTime->Lookup[expandedResolvedOptionsWithLabels, MaxIncubationTime],
				IncubationInstrument->Lookup[expandedResolvedOptionsWithLabels, IncubationInstrument],
				IncubationTemperature->Lookup[expandedResolvedOptionsWithLabels, IncubationTemperature],
				AnnealingTime->Lookup[expandedResolvedOptionsWithLabels, AnnealingTime],
				MixOrder->Lookup[expandedResolvedOptionsWithLabels, MixOrder]
			],
			Dilute[
				Sample -> modelExchangedInputs,
				SampleLabel -> Lookup[expandedResolvedOptionsWithLabels, SampleLabel],
				SampleContainerLabel -> Lookup[expandedResolvedOptionsWithLabels, SampleContainerLabel],
				SampleOutLabel -> Lookup[expandedResolvedOptionsWithLabels, SampleOutLabel],
				ContainerOutLabel -> Lookup[expandedResolvedOptionsWithLabels, ContainerOutLabel],
				DiluentLabel -> Lookup[expandedResolvedOptionsWithLabels, DiluentLabel],
				ConcentratedBufferLabel -> Lookup[expandedResolvedOptionsWithLabels, ConcentratedBufferLabel],
				BufferDiluentLabel -> Lookup[expandedResolvedOptionsWithLabels, BufferDiluentLabel],
				Amount -> Lookup[expandedResolvedOptionsWithLabels, Amount],
				TargetConcentration -> Lookup[expandedResolvedOptionsWithLabels, TargetConcentration],
				TargetConcentrationAnalyte -> Lookup[expandedResolvedOptionsWithLabels, TargetConcentrationAnalyte],
				TotalVolume -> Lookup[expandedResolvedOptionsWithLabels,TotalVolume],
				InitialVolume-> Lookup[expandedResolvedOptionsWithLabels, InitialVolume],
				ContainerOut -> Lookup[expandedResolvedOptionsWithLabels, ContainerOut],
				DestinationWell -> Lookup[expandedResolvedOptionsWithLabels, DestinationWell],
				ConcentratedBuffer -> Lookup[expandedResolvedOptionsWithLabels, ConcentratedBuffer],
				BufferDilutionFactor -> Lookup[expandedResolvedOptionsWithLabels, BufferDilutionFactor],
				BufferDiluent -> Lookup[expandedResolvedOptionsWithLabels, BufferDiluent],
				Diluent -> Lookup[expandedResolvedOptionsWithLabels, Diluent],
				SamplesOutStorageCondition -> Lookup[expandedResolvedOptionsWithLabels, SamplesOutStorageCondition],
				Preparation -> resolvedPreparation,
				WorkCell -> resolvedWorkCell,
				Mix->Lookup[expandedResolvedOptionsWithLabels, Mix],
				MixType->Lookup[expandedResolvedOptionsWithLabels, MixType],
				NumberOfMixes->Lookup[expandedResolvedOptionsWithLabels, NumberOfMixes],
				MixUntilDissolved->Lookup[expandedResolvedOptionsWithLabels, MixUntilDissolved],
				IncubationTime->Lookup[expandedResolvedOptionsWithLabels, IncubationTime],
				MaxIncubationTime->Lookup[expandedResolvedOptionsWithLabels, MaxIncubationTime],
				IncubationInstrument->Lookup[expandedResolvedOptionsWithLabels, IncubationInstrument],
				IncubationTemperature->Lookup[expandedResolvedOptionsWithLabels, IncubationTemperature],
				AnnealingTime->Lookup[expandedResolvedOptionsWithLabels, AnnealingTime],
				MixOrder->Lookup[expandedResolvedOptionsWithLabels, MixOrder]
			]
		]
	];


	(* if we're doing robotic sample preparation, then make unit operation packets for the aliquot blob *)
	resuspendUnitOperationPacketsNotLinked = If[MatchQ[experimentFunction, ExperimentRoboticSamplePreparation|ExperimentRoboticCellPreparation],
		UploadUnitOperation[
			resuspendUnitOperationBlobs,
			UnitOperationType -> Input,
			FastTrack -> True,
			Upload -> False
		],
		Null
	];


	(* link the transfer unit operations to the aliquot one *)
	resuspendUnitOperationPackets = If[NullQ[resuspendUnitOperationPacketsNotLinked],
		Null,
		Join[
			resuspendUnitOperationPacketsNotLinked,
			<|
				Replace[RoboticUnitOperations] -> Link[Lookup[allUnitOperationPackets, Object]]
			|>
		]
	];

	(* since we are putting this UO inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
	updatedSimulation=updateLabelFieldReferences[updatedSimulation,RoboticUnitOperations];


	{protocolPackets, finalSimulation, protocolTests} = Which[
		MatchQ[experimentFunction, ExperimentRoboticSamplePreparation|ExperimentRoboticCellPreparation],
		{Flatten[{Null, resuspendUnitOperationPackets, allUnitOperationPackets}], updatedSimulation, {}},
		gatherTests,
		(* quieting this message because I can't figure out where it's coming from and it doesn't seem to do anything; TODO please figure this out; task here  *)
		Quiet[experimentFunction[
			allTransferManipulations,
			FastTrack -> Lookup[expandedResolvedOptionsWithLabels, FastTrack],
			ParentProtocol -> Lookup[expandedResolvedOptionsWithLabels, ParentProtocol],
			Name -> Lookup[expandedResolvedOptionsWithLabels, Name],
			Simulation -> updatedSimulation,
			Output -> {Result, Simulation, Tests},
			Upload -> False,
			ImageSample -> Lookup[expandedResolvedOptionsWithLabels, ImageSample],
			MeasureVolume -> Lookup[expandedResolvedOptionsWithLabels, MeasureVolume],
			MeasureWeight -> Lookup[expandedResolvedOptionsWithLabels, MeasureWeight],
			Priority -> Lookup[expandedResolvedOptionsWithLabels, Priority],
			StartDate -> Lookup[expandedResolvedOptionsWithLabels, StartDate],
			HoldOrder -> Lookup[expandedResolvedOptionsWithLabels, HoldOrder],
			QueuePosition -> Lookup[expandedResolvedOptionsWithLabels, QueuePosition]
		], Warning::UnableToExpandInputs],
		True,
		{
			Sequence @@ Quiet[experimentFunction[
				allTransferManipulations,
				FastTrack -> Lookup[expandedResolvedOptionsWithLabels, FastTrack],
				ParentProtocol -> Lookup[expandedResolvedOptionsWithLabels, ParentProtocol],
				Name -> Lookup[expandedResolvedOptionsWithLabels, Name],
				Simulation -> updatedSimulation,
				Output -> {Result, Simulation},
				Upload -> False,
				ImageSample -> Lookup[expandedResolvedOptionsWithLabels, ImageSample],
				MeasureVolume -> Lookup[expandedResolvedOptionsWithLabels, MeasureVolume],
				MeasureWeight -> Lookup[expandedResolvedOptionsWithLabels, MeasureWeight],
				Priority -> Lookup[expandedResolvedOptionsWithLabels, Priority],
				StartDate -> Lookup[expandedResolvedOptionsWithLabels, StartDate],
				HoldOrder -> Lookup[expandedResolvedOptionsWithLabels, HoldOrder],
				QueuePosition -> Lookup[expandedResolvedOptionsWithLabels, QueuePosition]
			], Warning::UnableToExpandInputs],
			{}
		}
	];

	(* if the protocol packet generation failed, need to return early here (with the tests, of course) *)
	(* note that we do NOT need to call fulfillableResourceQ here because ExperimentManualSamplePreparation will call it for us, and ExperimentRoboticSamplePreparation means it will get called for us later *)
	If[MemberQ[protocolPackets, $Failed] || MatchQ[protocolPackets, $Failed],
		Return[outputSpecification /. {Result -> $Failed, Tests -> protocolTests}]
	];

	(* get the protocol packet specifically and the accessory packets *)
	{protPacket, accessoryProtPackets} = {First[protocolPackets], Rest[protocolPackets]};

	(* pull out the samples out labels from the resolved options *)
	samplesOutLabels = Lookup[expandedResolvedOptionsWithLabels, SampleOutLabel];

	(* pull out the FutureLabeledObjects from the packets we just generated *)
	unsortedFutureLabeledObjects = If[NullQ[protPacket],
		{},
		Lookup[protPacket, Replace[FutureLabeledObjects]]
	];

	(* get the entries of the FutureLabeledObjects that correspond with the SampleOutLabel values *)
	unsortedSampleOutFutureLabeledObjects = Select[unsortedFutureLabeledObjects, MatchQ[First[#], Alternatives @@ samplesOutLabels] &];

	(* sort the entries of the FutureLabeledObjects that correspond with the SampleOutLabel values *)
	sortedSampleOutFutureLabeledObjects = If[NullQ[protPacket],
		{},
		Map[
			Function[{label},
				SelectFirst[unsortedSampleOutFutureLabeledObjects, MatchQ[First[#], label]&,Nothing]
			],
			samplesOutLabels
		]
	];

	(* recombine these sorted future labeled object values with the other FutureLabeledObjects *)
	sortedFutureLabeledObjects = Join[
		Select[unsortedFutureLabeledObjects, Not[MatchQ[First[#], Alternatives @@ samplesOutLabels]] &],
		sortedSampleOutFutureLabeledObjects
	];


	(* add the ResolvedOptions/UnresolvedOptions in, as well as the sorted FutureLabeledObjects *)
	protPacketFinal = If[NullQ[protPacket],
		Null,
		Append[
			protPacket,
			{
				UnresolvedOptions -> DeleteCases[myUnresolvedOptions, (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)],
				ResolvedOptions -> DeleteCases[resolvedOpsFinal, (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)],
				Replace[FutureLabeledObjects] -> sortedFutureLabeledObjects
			}
		]
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
		Cases[Flatten[{protocolTests}], _EmeraldTest],
		Null
	];

	(* note that I am not calling fulfillableResourceQ here because ExperimentSamplePreparation will have already called it*)
	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result],
		{Flatten[{protPacketFinal, accessoryProtPackets}],(runTime+10Minute)},
		$Failed
	];

	(* generate the simulation rule *)
	simulationRule = Simulation -> finalSimulation;

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule, simulationRule}

];


(* ::Subsubsection:: *)
(*Sister functions*)


DefineOptions[ExperimentResuspendOptions,
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
	SharedOptions :> {ExperimentResuspend}
];


ExperimentResuspendOptions[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentResuspend *)
	options = ExperimentResuspend[myInput, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentResuspend],
		options
	]
];


ExperimentResuspendPreview[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentResuspend]] :=
	ExperimentResuspend[myInput, Append[ToList[myOptions], Output -> Preview]];


DefineOptions[ValidExperimentResuspendQ,
	Options :> {VerboseOption, OutputFormatOption},
	SharedOptions :> {ExperimentResuspend}
];


ValidExperimentResuspendQ[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ValidExperimentResuspendQ]] := Module[
	{listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentResuspend *)
	filterTests = ExperimentResuspend[myInput, Append[preparedOptions, Output -> Tests]];

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
	Lookup[RunUnitTest[<|"ValidExperimentResuspendQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentResuspendQ"]
];

(* ::Subsubsection::Closed:: *)
(*convertResuspendOrDiluteToTransferSteps*)

DefineOptions[convertResuspendOrDiluteToTransferSteps,
	Options :> {
		{Label -> False, BooleanP, "Indicates if the inputs to Transfer should be given with labels in place of objects or not."}
	}
];

(* helper function that takes in the input sample (packets) and resolved options of ExperimentAliquot, and returns a list of four things: the sources, the destinations, the destination wells, and the amounts to transfer in an ExperimentTransfer call *)
(* note that the resolved options must contain the hidden options as well, most notably the label options.  Also they cannot be collapsed *)
(* probably want to provide mySamplePackets as the pooled format as a list of lists since myResolvedOptions needs that anyway *)
(* but if you don't provide it as a list of lists I will make it so *)
convertResuspendOrDiluteToTransferSteps[myType : Resuspend|Dilute,mySamplePackets:{ListableP[PacketP[Object[Sample]]]..}, myResolvedOptions:{_Rule...}, ops:OptionsPattern[convertResuspendOrDiluteToTransferSteps]]:=Module[
	{listedSamplePackets, resolvedDiluent, resolvedConcentratedBuffer, resolvedBufferDiluent,
		resolvedBufferDilutionFactor, resolvedDestWells, resolvedContainerOut, resolvedAmount, allSamplesToTransfer,
		destinationsToTransferTo, destinationWellsToTransferTo, resolvedAmountNoAll, resolvedVolume,
		diluentVolume, diluentSourceDestWellTrio, diluentToTransfer, diluentDestination,
		diluentDestWell, concBufferAndBufferDiluentVolumes, concBufferAndBufferDiluentSourceDestWellTrio,
		concBufferAndBufferDiluentToTransfer, concBufferAndBufferDiluentDestination, concBufferAndBufferDiluentDestWell,
		amountsToTransfer, safeOps, labelQ, sourceLabels, sourceContainerLabels, containerOutLabels, diluentLabels,
		concBufferLabels, bufferDiluentLabels, sourceLabelReplaceRules, sourceContainerLabelReplaceRules,
		containerOutLabelReplaceRules, diluentLabelReplaceRules, concBufferLabelReplaceRules,
		bufferDiluentLabelReplaceRules, nonzeroSamplesToTransfer,
		nonzeroDestsToTransferTo, nonzeroDestWellsToTransferTo, nonzeroAmountsToTransfer,
		sourceDestAndWellsToAmountRules, specifiedPreparation, consolidatedSourceSamplesToTransfer,
		consolidatedDestSamplesToTransfer, consolidatedDestWellsToTransferTo, consolidatedAmountsToTransfer,
		splitSourceSamples, splitDestSamples, splitDestWells, splitAmountsToTransfer, splitOptions,
		newContainerQs,resuspendQ
	},

	(* get the Label option of the function *)
	safeOps = SafeOptions[convertResuspendOrDiluteToTransferSteps, ToList[ops]];
	labelQ = Lookup[safeOps, Label];
	resuspendQ = MatchQ[myType, Resuspend];

	(* in case we don't have a list of lists at this point, do it *)
	listedSamplePackets = mySamplePackets;

	(* pull out the relevant resolved options that we will need shortly *)
	{
		resolvedDiluent,
		resolvedConcentratedBuffer,
		resolvedBufferDiluent,
		resolvedBufferDilutionFactor,
		resolvedDestWells,
		resolvedContainerOut,
		resolvedAmount,
		resolvedVolume,
		specifiedPreparation
	} = Lookup[
		myResolvedOptions,
		{
			Diluent,
			ConcentratedBuffer,
			BufferDiluent,
			BufferDilutionFactor,
			DestinationWell,
			ContainerOut,
			Amount,
			If[resuspendQ, Volume, TotalVolume],
			Preparation
		}
	];

	(* deterimine if the sample in question is staying in its existing container, or if it is moving to a new one *)
	newContainerQs = MapThread[
		!MatchQ[Lookup[#1, Container], ObjectP[Download[#2, Object]]]&,
		{listedSamplePackets, resolvedContainerOut[[All, 2]]}
	];

	(* pull out the relevant label options *)
	{
		sourceLabels,
		sourceContainerLabels,
		containerOutLabels,
		diluentLabels,
		concBufferLabels,
		bufferDiluentLabels
	} = Lookup[
		myResolvedOptions,
		{
			SampleLabel,
			SampleContainerLabel,
			ContainerOutLabel,
			DiluentLabel,
			ConcentratedBufferLabel,
			BufferDiluentLabel
		}
	];

	(* make replace rules converting the option values to their labels *)
	sourceLabelReplaceRules = DeleteDuplicates[Flatten[MapThread[
		Function[{sourcePacketsInLoop, sourceLabelsInLoop},
				Lookup[sourcePacketsInLoop, Object] -> sourceLabelsInLoop
		],
		{listedSamplePackets, sourceLabels}
	]]];

	sourceContainerLabelReplaceRules = DeleteDuplicates[Flatten[MapThread[
		Function[{sourcePacketsInLoop, sourceContainerLabelsInLoop},
				Download[Lookup[sourcePacketsInLoop, Container], Object] ->  sourceContainerLabelsInLoop

		],
		{listedSamplePackets, sourceContainerLabels}
	]]];

	containerOutLabelReplaceRules = DeleteDuplicates[MapThread[#1 -> #2&, {resolvedContainerOut, containerOutLabels}]];
	diluentLabelReplaceRules = DeleteDuplicates[MapThread[#1 -> #2&, {resolvedDiluent, diluentLabels}]];
	concBufferLabelReplaceRules = DeleteDuplicates[MapThread[#1 -> #2&, {resolvedConcentratedBuffer, concBufferLabels}]];
	bufferDiluentLabelReplaceRules = DeleteDuplicates[MapThread[#1 -> #2&, {resolvedBufferDiluent, bufferDiluentLabels}]];



	(* get the Amount option without any Alls (which convert into the volume, or Null if there is no volume) *)
	resolvedAmountNoAll = MapThread[
		If[
			MatchQ[#2, All],
			Lookup[#1, Volume],
			#2
		]&,
		{listedSamplePackets, resolvedAmount}
	];

	(* --- get all the amounts for the ConcentratedBuffer/BufferDiluent --- *)

	(* get the volume of ConcentratedBuffer and BufferDiluent to be transferred *)
	concBufferAndBufferDiluentVolumes = MapThread[
		Function[{assayVolume, concBuffer, bufferDilutionFactor, amountsInPool},
			(* if we don't have a concentrated buffer then obviously nothing here *)
			If[NullQ[concBuffer] || NullQ[assayVolume],
				Nothing,
				{
					assayVolume / bufferDilutionFactor,
					assayVolume - ((assayVolume / bufferDilutionFactor) + Total[Cases[amountsInPool, VolumeP]])
				}
			]
		],
		{resolvedVolume, resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedAmountNoAll}
	];

	(* get the source/destination/destination well trio to be transferred for ConcentratedBuffer/BufferDiluent, then split it out *)
	concBufferAndBufferDiluentSourceDestWellTrio = MapThread[
		Function[{assayVolume, concBuffer, bufferDiluent, containerOut, destWell},
			(* if we don't have an assay buffer then obviously nothing here *)
			If[NullQ[concBuffer] || NullQ[bufferDiluent] || NullQ[assayVolume],
				Nothing,
				{
					{concBuffer, bufferDiluent},
					{containerOut, containerOut},
					{destWell, destWell}
				}
			]
		],
		{resolvedVolume, resolvedConcentratedBuffer, resolvedBufferDiluent, resolvedContainerOut, resolvedDestWells}
	];
	{
		concBufferAndBufferDiluentToTransfer,
		concBufferAndBufferDiluentDestination,
		concBufferAndBufferDiluentDestWell
	} = If[MatchQ[concBufferAndBufferDiluentSourceDestWellTrio, {}],
		{{}, {}, {}},
		Transpose[concBufferAndBufferDiluentSourceDestWellTrio]
	];

	(* --- get all the amounts for Diluent ---*)

	(* get the volume of Diluent to be transferred *)
	diluentVolume = MapThread[
		Function[{assayVolume, amountsInPool, diluent},
			(* if we don't have an assay buffer then obviously nothing here *)
			If[NullQ[diluent] || NullQ[assayVolume],
				Nothing,
				assayVolume - Total[Cases[amountsInPool, VolumeP]]
			]
		],
		{resolvedVolume, resolvedAmountNoAll, resolvedDiluent}
	];

	(* get the source/destination/destination well trio to be transferred, then split it out *)
	diluentSourceDestWellTrio = MapThread[
		Function[{assayVolume, diluent, containerOut, destWell},
			(* if we don't have an assay buffer then obviously nothing here *)
			If[NullQ[diluent] || NullQ[assayVolume],
				Nothing,
				{diluent, containerOut, destWell}
			]
		],
		{resolvedVolume, resolvedDiluent, resolvedContainerOut, resolvedDestWells}
	];
	{
		diluentToTransfer,
		diluentDestination,
		diluentDestWell
	} = If[MatchQ[diluentSourceDestWellTrio, {}],
		{{}, {}, {}},
		Transpose[diluentSourceDestWellTrio]
	];

	(* get everything that needs to be transferred put together in the order they will be added.  This means ConcentratedBuffer + BufferDiluent to everything (in pairs), then Diluent to everything, then samples to everything *)
	(* if we want to return labels, do that *)
	allSamplesToTransfer = Flatten[{
		concBufferAndBufferDiluentToTransfer /. If[labelQ, Join[concBufferLabelReplaceRules, bufferDiluentLabelReplaceRules], {}],
		diluentToTransfer /. If[labelQ, diluentLabelReplaceRules, {}],
		PickList[Lookup[Flatten[listedSamplePackets], Object],newContainerQs] /. If[labelQ, sourceLabelReplaceRules, {}]
	}];

	(* get the destinations to transfer to *)
	(* if we want to return labels, do that *)
	destinationsToTransferTo = Join[
		(* again need to be in pairs because the concentrated buffer and buffer diluent are paired together *)
		Join @@ concBufferAndBufferDiluentDestination,
		diluentDestination,
		PickList[resolvedContainerOut,newContainerQs]
	] /. If[labelQ, containerOutLabelReplaceRules, {}];


	(* put the destination wells together *)
	destinationWellsToTransferTo = Flatten[{
		concBufferAndBufferDiluentDestWell,
		diluentDestWell,
		PickList[resolvedDestWells,newContainerQs]
	}];

	(* get all the amounts to transfer *)
	amountsToTransfer = Flatten[{
		MapThread[
			Function[{assayVolume, concentratedBuffer, bufferDilutionFactor, amountsInPool},
				(* if we don't have a concentrated buffer then obviously nothing here *)
				If[NullQ[concentratedBuffer] || NullQ[assayVolume],
					Nothing,
					{
						assayVolume / bufferDilutionFactor,
						assayVolume - ((assayVolume / bufferDilutionFactor) + Total[Cases[amountsInPool, VolumeP]])
					}
				]
			],
			{resolvedVolume, resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedAmountNoAll}
		],
		(* for Diluent it's easy enough: it's just the difference between the Volume and the resolved Amount *)
		MapThread[
			Function[{assayVolume, amountsInPool, diluent},
				(* if we don't have an assay buffer then obviously nothing here *)
				Which[
					NullQ[diluent], Nothing,
					NullQ[assayVolume], 0 Liter,
					True, assayVolume - Total[Cases[amountsInPool, VolumeP]]
				]
			],
			{resolvedVolume, resolvedAmountNoAll, resolvedDiluent}
		],
		PickList[resolvedAmountNoAll,newContainerQs]
	}];

	(* return all this in order: *)
	(* remove any instances where we are transferring 0 L/G/unit *)
	(* 1.) the samples to transfer *)
	(* 2.) the destinations to transfer them to *)
	(* 3.) the destination wells to transfer them to *)
	(* 4.) the amount to transfer *)

	{
		nonzeroSamplesToTransfer,
		nonzeroDestsToTransferTo,
		nonzeroDestWellsToTransferTo,
		nonzeroAmountsToTransfer
	} = {
		PickList[allSamplesToTransfer, amountsToTransfer, GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit]],
		PickList[destinationsToTransferTo, amountsToTransfer, GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit]],
		PickList[destinationWellsToTransferTo, amountsToTransfer, GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit]],
		Cases[amountsToTransfer, GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit]] /. {x:UnitsP[Unit] :> Unitless[x, Unit]}
	};

	(* make rules to consolidate the source/destination/destination well into a single amount if necessary (like for ConsolidateAliquots) *)
	sourceDestAndWellsToAmountRules = Merge[
		MapThread[
			{#1, #2, #3} -> #4 &,
			{nonzeroSamplesToTransfer, nonzeroDestsToTransferTo, nonzeroDestWellsToTransferTo, nonzeroAmountsToTransfer}
		],
		Total
	];

	(* split the sources, destinations, destination wells, and amounts by 970 Microliter *)
	(* if Preparation -> Manual, just stick with what we have.  If we have Automatic, split into 970 uL or less transfers because robot can't do more than that *)
	(* also solid transfers are always manual *)
	{
		splitSourceSamples,
		splitDestSamples,
		splitAmountsToTransfer,
		splitOptions
	} = If[!MatchQ[nonzeroSamplesToTransfer,{}]&&!MatchQ[nonzeroDestsToTransferTo,{}]&&!MatchQ[nonzeroAmountsToTransfer,{}],
		splitTransfersBy970[
			nonzeroSamplesToTransfer,
			nonzeroDestsToTransferTo,
			nonzeroAmountsToTransfer,
			DestinationWell -> nonzeroDestWellsToTransferTo,
			Preparation -> specifiedPreparation
		],
		ConstantArray[{},4]
	];
	splitDestWells = Lookup[splitOptions, DestinationWell];


	{
		splitSourceSamples,
		splitDestSamples/. {x : {_Integer, ObjectP[Object[Container]]} :> Last[x]},
		splitDestWells,
		splitAmountsToTransfer
	}

];

(* ::Subsubsection::Closed:: *)
(* resolveResuspendMethod *)

DefineOptions[resolveResuspendMethod,
	SharedOptions:>{
		ExperimentResuspend,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveResuspendMethod[mySamples:ObjectP[{Object[Sample], Object[Container]}] | {ListableP[ObjectP[{Object[Sample], Object[Container]}]]..}, myOptions:OptionsPattern[]]:=Module[
	{specifiedOptions, resolvedOptions, outputSpecification, methodResolutionOptions, method, resuspendQ},

	(* get the output specification *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];

	(* get the options that were provided *)
	specifiedOptions = ToList[myOptions];

	(* replace the options with Output -> Options and ResolveMethod -> True *)
	methodResolutionOptions = ReplaceRule[specifiedOptions, {Output -> Options, ResolveMethod -> True}];

	(* get the resolved options, and whether we're Robotic or Manual *)
	resolvedOptions = ExperimentResuspend[mySamples, methodResolutionOptions];
	method = Lookup[resolvedOptions, Preparation];

	outputSpecification /. {Result -> method, Tests -> {}, Preview -> Null, Options -> methodResolutionOptions}

];


(* ::Subsection:: *)
(*resolveResuspendOrDiluteWorkCell*)

DefineOptions[resolveResuspendOrDiluteWorkCell,
	SharedOptions :> {
		ExperimentDilute,
		ExperimentResuspend,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveResuspendOrDiluteWorkCell[
	mySamples:ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | {ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]]..},
	myOptions:OptionsPattern[]
] := Module[
	{safeOptions, cache, simulation, workCell, preparation},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveResuspendOrDiluteWorkCell, ToList[myOptions]];
	{cache, simulation, workCell, preparation} = Lookup[safeOptions, {Cache, Simulation, WorkCell, Preparation}];

	(* Determine the WorkCell that can be used *)
	If[MatchQ[workCell, WorkCellP|Null],
		(* If WorkCell is specified, use that *)
		{workCell}/.{Null} -> {},
		(* Otherwise, use helper function to resolve potential work cells based on experiment options and sample properties *)
		(* Note: there is no Sterile or SterileTechnique for ExperimentDilute or ExperimentResuspend *)
		resolvePotentialWorkCells[Cases[Flatten@{mySamples}, ObjectP[]], {Preparation -> preparation}, Cache -> cache, Simulation -> simulation]
	]
];

(* ::Subsubsection::Closed:: *)
(*shortcutResuspendResourcePackets *)

DefineOptions[
	shortcutResuspendResourcePackets,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

(* function _just_ to make the resources and call fulfillableResourceQ on them *)
(* importantly, this does NOT call ExperimentSamplePreparation *)
shortcutResuspendResourcePackets[myType : Resuspend|Dilute,mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, ops:OptionsPattern[resuspendResourcePackets]]:=Module[
	{
		outputSpecification, output, amount, volume, diluent, concentratedBuffer, bufferDilutionFactor, bufferDiluent,
		cache, sampleAmountRules, sampleResources, bufferVolumes, splitBufferVolumes, bufferVolumeRules, bufferResources,
		allResources, fulfillable, frqTests, simulatedProtocolPacket, gatherTests, resultRule, testsRule, preparation,
		workCell, simulation, resuspendQ, protocolType
	},

	(* pull out the Output option *)
	outputSpecification = Lookup[myResolvedOptions, Output];
	output = ToList[outputSpecification];
	gatherTests = MemberQ[output, Tests];
	resuspendQ = MatchQ[myType, Resuspend];

	(* pull out the cache *)
	{cache, simulation} = Lookup[SafeOptions[shortcutResuspendResourcePackets, ToList[ops]], {Cache, Simulation}, {}];

	(* pull out the relevant options for what I'm doing below *)
	{
		amount,
		volume,
		diluent,
		concentratedBuffer,
		bufferDilutionFactor,
		bufferDiluent,
		preparation,
		workCell
	} = Lookup[
		myResolvedOptions,
		{
			Amount,
			If[resuspendQ, Volume, TotalVolume],
			Diluent,
			ConcentratedBuffer,
			BufferDilutionFactor,
			BufferDiluent,
			Preparation,
			WorkCell
		}
	];

	(* make rules correlating the amount of a given sample, and Total it all up *)
	sampleAmountRules = Merge[
		MapThread[
			#1 -> #2&,
			{Download[Flatten[mySamples], Object, Cache -> cache, Simulation -> simulation], Flatten[amount]}
		],
		Total
	];

	(* make resources for the samples *)
	sampleResources = KeyValueMap[
		Resource[Sample -> #1, Amount -> #2, Name -> ToString[Unique[]]]&,
		sampleAmountRules
	];

	(* get the buffer volume *)
	(* if we're adding liquid to a solid then just say the volume we are adding *)
	(* if we're adding more than Volume that should have already been caught, but just default to 0 in case *)
	(* need to do the Total[ToList[#1]] thing because of pooling *)
	bufferVolumes = MapThread[
		With[{volumeAmount = Total[Cases[ToList[#1], VolumeP]]},
			If[VolumeQ[volumeAmount],
				Max[{#2 - volumeAmount, 0 Liter}],
				#2
			]
		]&,
		{amount, volume}
	];

	(* get the volume of the Diluent (if using that) or the ConcentratedBuffer/BufferDiluent (if using that) *)
	splitBufferVolumes = MapThread[
		Function[{assBuffer, buffDiluFactor, bufferVolume},
			Which[
				bufferVolume == 0 Liter, 0 Liter,
				MatchQ[assBuffer, ObjectP[]], bufferVolume,
				(* first value is the amount of concentrated buffer, second is the amount of buffer diluent *)
				True, {bufferVolume / buffDiluFactor, bufferVolume * (1 - 1 / buffDiluFactor)}
			]
		],
		{diluent, bufferDilutionFactor, bufferVolumes}
	];

	(* make rules correlating the amount of a given buffer, and Total it all up *)
	bufferVolumeRules = Merge[
		Flatten[MapThread[
			Function[{volumes, assBuffer, concBuffer, diluent},
				Which[
					(* if we have 0 Liter of volume, or if there is no assay buffer and no concentrated buffer, then just don't make a rule*)
					MatchQ[volumes, EqualP[0 Liter]] || (NullQ[assBuffer] && NullQ[concBuffer]), Nothing,
					(*if volumes is just one volume, then we're using Diluent*)
					MatchQ[volumes, VolumeP], assBuffer -> volumes,
					MatchQ[volumes, {VolumeP, VolumeP}], {concBuffer -> volumes[[1]], diluent -> volumes[[2]]},
					True, Nothing
				]
			],
			{splitBufferVolumes, Download[diluent, Object, Cache -> cache, Simulation -> simulation], Download[concentratedBuffer, Object, Cache -> cache, Simulation -> simulation], Download[bufferDiluent, Object, Cache -> cache, Simulation -> simulation]}
		]],
		Total
	];

	(* make resources for the buffers *)
	bufferResources = KeyValueMap[
		If[MatchQ[#1, WaterModelP],
			Resource[Sample -> #1, Amount -> #2, Name -> ToString[Unique[]], Container -> PreferredContainer[#2]],
			Resource[Sample -> #1, Amount -> #2, Name -> ToString[Unique[]]]
		]&,
		bufferVolumeRules
	];

	(* combine the sample and buffer resources together *)
	allResources = Flatten[{sampleResources, bufferResources}];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResources, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> cache, Simulation -> simulation],
		True, {Resources`Private`fulfillableResourceQ[allResources, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> cache, Simulation -> simulation], Null}
	];

	(* If preparation is Robotic, determine the protocol type (RCP vs. RSP) that we want to create an ID for. *)
	protocolType = If[MatchQ[preparation, Robotic],
		Module[{experimentFunction},
			experimentFunction = Lookup[$WorkCellToExperimentFunction, workCell];
			Object[Protocol, ToExpression@StringDelete[ToString[experimentFunction], "Experiment"]]
		],
		(* Otherwise this doesn't matter. *)
		Null
	];

	(* make a simulated output packet *)
	simulatedProtocolPacket = <|
		Type -> protocolType,
		Name -> "Protocol that will never actually be uploaded since this is in a shortcut function only called if Output -> Options"
	|>;

	(* make Result and Tests output rules *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{ToList[simulatedProtocolPacket],(Length[Flatten[mySamples]] * 20 Second)},
		$Failed
	];
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}

];


(* ::Subsubsection::Closed:: *)
(*simulateExperimentResuspend*)

DefineOptions[simulateExperimentResuspend,
	Options :> {
		CacheOption,
		SimulationOption
	}
];

(* very simple simulation function because it is entirely relying on ExperimentRobotic/ManualSamplePreparation to do the heavy lifting *)
simulateExperimentResuspend[
	myType : Resuspend|Dilute,
	myProtocolPacket:PacketP[{Object[Protocol, RoboticSamplePreparation], Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]}]|$Failed,
	myAccessoryPackets:{PacketP[]...}|$Failed,
	mySamples:{{ObjectP[Object[Sample]]..}..},
	myResolvedOptions:{___Rule},
	ops:OptionsPattern[simulateExperimentResuspend]
]:=Module[
	{
		safeResolutionOps, cache, simulation, preparation, workCell, protocolObject, samplePackets, sourcesToTransfer,
		destinationsToTransferTo, expandedDestWells, amountsToTransfer, accessoryPacketSimulation,resuspendQ,
		sampleOutLabels, containerOutLabels, diluentLabels, concBufferLabels, bufferDiluentLabels,
		containerOutLabelFields, diluentLabelFields, concentratedBufferLabelFields,
		bufferDiluentLabelFields, updatedSimulation, protocolType
	},

	resuspendQ = MatchQ[myType, Resuspend];

	(* pull out the cache and simulation blob now *)
	safeResolutionOps = SafeOptions[simulateExperimentResuspend, ToList[ops]];
	cache = Lookup[safeResolutionOps, Cache];
	simulation = If[NullQ[Lookup[safeResolutionOps, Simulation]],
		Simulation[],
		Lookup[safeResolutionOps, Simulation]
	];

	(* Get the preparation and the protocol type. *)
	{preparation, workCell} = Lookup[myResolvedOptions, {Preparation, WorkCell}];
	(* Get the protocol type that we want to create an ID for. *)
	protocolType = If[MatchQ[preparation, Manual],
		resolveManualFrameworkFunction[mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation, Output -> Type],
		Module[{experimentFunction},
			experimentFunction = Lookup[$WorkCellToExperimentFunction, workCell];
			Object[Protocol, ToExpression@StringDelete[ToString[experimentFunction], "Experiment"]]
		]
	];

	(* get the protocol object ID *)
	protocolObject = If[MatchQ[myProtocolPacket, $Failed],
		SimulateCreateID[protocolType],
		Lookup[myProtocolPacket, Object]
	];

	(* get the sample packets from the input samples *)
	samplePackets = Map[
		fetchPacketFromCache[#, cache]&,
		mySamples,
		{2}
	];

	(* get all the input sand options needed for the ExperimentManual/RoboticSamplePreparation call *)
	(* Label -> True is important because we have to get labels to be correct in the simulation function *)
	{
		sourcesToTransfer,
		destinationsToTransferTo,
		expandedDestWells,
		amountsToTransfer
	} = convertResuspendOrDiluteToTransferSteps[myType,samplePackets, myResolvedOptions, Label -> True];

	(* if we don't have anything to transfer (and this only happens if things are messed up), just return early with the simulation we came in with *)
	If[MatchQ[amountsToTransfer, {}],
		Return[
			(* merge the simulation we started with with what we have now *)
			{
				protocolObject,
				simulation
			}
		]
	];

	(* pull out label field options *)
	{
		sampleOutLabels,
		containerOutLabels,
		diluentLabels,
		concBufferLabels,
		bufferDiluentLabels
	} = Lookup[
		myResolvedOptions,
		{
			SampleOutLabel,
			ContainerOutLabel,
			DiluentLabel,
			ConcentratedBufferLabel,
			BufferDiluentLabel
		}
	];

	containerOutLabelFields = MapIndexed[
		With[{index = First[#2]},
			#1 -> Field[ContainerOutLink[[index]]]
		]&,
		containerOutLabels
	];

	(* generate the extra LabelFields that we want with the AssayBufferLabel/BufferDiluentLabel/ConcentratedBufferLabel *)
	diluentLabelFields = MapIndexed[
		With[{index = First[#2]},
			If[StringQ[#1],
				#1 -> Field[DiluentLink[[index]]],
				Nothing
			]
		]&,
		diluentLabels
	];
	concentratedBufferLabelFields = MapIndexed[
		With[{index = First[#2]},
			If[StringQ[#1],
				#1 -> Field[ConcentratedBufferLink[[index]]],
				Nothing
			]
		]&,
		concBufferLabels
	];
	bufferDiluentLabelFields = MapIndexed[
		With[{index = First[#2]},
			If[StringQ[#1],
				#1 -> Field[BufferDiluentLink[[index]]],
				Nothing
			]
		]&,
		bufferDiluentLabels
	];

	(* replace the LabelFields key in the old simulation blob to make a new one *)
	(* only do this for manual; for robotic, we don't change anything here because it is magic and handles itself properly *)
	updatedSimulation = If[MatchQ[preparation, Manual],
		UpdateSimulation[
			simulation,
			Simulation[LabelFields -> Flatten[{containerOutLabelFields, diluentLabelFields, concentratedBufferLabelFields, bufferDiluentLabelFields}]]
		],
		simulation
	];

	(* NOTE: SimulateResources requires you to have a protocol object, so just make one to simulate our unit operation. *)
	accessoryPacketSimulation = Module[{protocolPacket},
		protocolPacket = <|
			Object -> SimulateCreateID[protocolType],
			Replace[OutputUnitOperations] -> Link[Lookup[Cases[myAccessoryPackets, Except[PacketP[Object[UnitOperation, Resuspend]], PacketP[Object[UnitOperation]]]], Object, {}], Protocol],
			(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
			(* simulate resources will NOT simulate them for you. *)
			(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
			Replace[RequiredObjects] -> DeleteDuplicates[
				Cases[Lookup[Cases[myAccessoryPackets, PacketP[]], Object, {}], Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]], Infinity]
			],
			Replace[RequiredInstruments] -> DeleteDuplicates[
				Cases[Lookup[Cases[myAccessoryPackets, PacketP[]], Object, {}], Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]
			],
			ResolvedOptions -> {}
		|>;
		If[MatchQ[Cases[myAccessoryPackets, PacketP[]], {}],
			simulation,
			SimulateResources[
				protocolPacket,
				(* want to exclude accessory packets that don't have the Object key because seemingly SimulateResources freaks out at that (like notifications and procedure events) *)
				<|#|> & /@ GatherBy[Cases[myAccessoryPackets, KeyValuePattern[{Object -> _}]], Key[Object]],
				ParentProtocol -> Lookup[ToList[myResolvedOptions], ParentProtocol, Null],
				Simulation -> updatedSimulation
			]
		]
	];

	(* merge the simulation we started with with what we have now *)
	{
		protocolObject,
		UpdateSimulation[updatedSimulation, accessoryPacketSimulation]
	}

];
