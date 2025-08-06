(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentAliquot*)


(* ::Subsubsection::Closed:: *)
(*ExperimentAliquot Options and Messages*)


DefineOptions[ExperimentAliquot,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SourceLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the aliquot samples, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				NestedIndexMatching -> True,
				UnitOperation -> True
			},
			{
				OptionName -> SourceContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the aliquot sample's containers, for use in downstream unit operations.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				NestedIndexMatching -> True,
				UnitOperation -> True
			},
			{
				OptionName -> Amount,
				Default -> Automatic,
				Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container if a liquid, or the current Mass or Count if a solid or counted item, respectively.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count"->Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					],
					"Count"->Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
					],
					"All"->Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> TargetConcentration,
				Default -> Automatic,
				Description -> "The desired final concentration of analyte in the aliquot samples after dilution of aliquots of the input samples with the ConcentratedBuffer and BufferDiluent (or AssayBuffer).",
				ResolutionDescription -> "Automatically calculated based on aliquot and buffer volumes.",
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
				],
				NestedIndexMatching -> True
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
				],
				NestedIndexMatching -> True
			},
			{
				OptionName -> AssayVolume,
				Default -> Automatic,
				Description -> "The desired total volume of the aliquoted sample plus dilution buffer.",
				ResolutionDescription -> "Automatically determined based on Volume, Mass, and TargetConcentration option values.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 20 Liter],
					Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
				]
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
						PreparedContainer -> True
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
				Description -> "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the AssayVolume of the sample.  For plates, attempts to fill all wells of a single plate with the same model before aliquoting into the next."
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
				OptionName -> DestinationWell,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> WellPositionP,
					Size->Line,
					PatternTooltip -> "Enumeration must be any well from A1 to H12 for a 96-well plate or from A1 to P24 for a 384-well plate."
				],
				Description -> "The desired position in the corresponding ContainerOut in which the aliquot samples will be placed.",
				ResolutionDescription -> "Automatically set to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
			},
			{
				OptionName -> ConcentratedBuffer,
				Default -> Null,
				Description -> "The concentrated buffer which should be diluted by the BufferDilutionFactor in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the total AssayVolume.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					PreparedSample -> True,
					PreparedContainer -> True,
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
				OptionName -> ConcentratedBufferLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the concentrated buffer that is diluted by the BufferDilutionFactor in the final solution, for use in downstream unit operations.",
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
				OptionName -> BufferDilutionFactor,
				Default -> Automatic,
				Description -> "The dilution factor by which the concentrated buffer should be diluted in the final solution (i.e., the combination of the sample, ConcentratedBuffer, and BufferDiluent). The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the total AssayVolume.",
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
				Description -> "The buffer used to dilute the aliquot sample such that ConcentratedBuffer is diluted by BufferDilutionFactor in the final solution. The ConcentratedBuffer and BufferDiluent will be combined and then mixed with the sample, where the combined volume of these buffers is the difference between the Amount and the total AssayVolume.",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is specified; otherwise, set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					PreparedSample -> True,
					PreparedContainer -> True,
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
			},
			{
				OptionName -> AssayBuffer,
				Default -> Automatic,
				Description -> "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume.",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is not specified and AssayVolume dictates we require a buffer; otherwise, set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
					PreparedSample -> True,
					PreparedContainer -> True,
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
				OptionName -> AssayBufferLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the buffer added to the aliquoted sample, for use in downstream unit operations.",
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
			OptionName -> ConsolidateAliquots,
			Default -> False,
			Description -> "Indicates if aliquots from the same sample with the same target concentration should be prepared in the same ContainerOut. Aliquots from the same source sample not requiring dilution will also be consolidated.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		PreparationOption,
		{
			OptionName -> SamplesInStorageCondition,
			Default -> Null,
			Description -> "The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition.",
			AllowNull -> True,
			Category -> "Post Experiment",
			(* Null indicates the storage conditions will be inherited from the model *)
			Widget -> Alternatives[
				Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal]
			]
		},
		{
			OptionName -> EnableSamplePreparation,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "If True, this resolver is being called as part of sample prep option resolution.",
			Category -> "Hidden"
		},
		{
			OptionName -> ResolveMethod,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "If True, this resolver is being called as part of resolveAliquotMethod, and all messages should be suppressed.",
			Category -> "Hidden"
		},
		ModifyOptions[
			ModelInputOptions,
			{
				{
					OptionName -> PreparedModelAmount,
					NestedIndexMatching -> True
				},
				{
					OptionName -> PreparedModelContainer,
					NestedIndexMatching -> True
				}
			}
		],
		(* don't actually want this exposed to the customer, but do need it under the hood for ModelInputOptions to work *)
		ModifyOptions[
			PreparatoryUnitOperationsOption,
			Category -> "Hidden"
		],
		SamplesOutStorageOptions,
		BiologyPostProcessingOptions,
		ProtocolOptions,
		WorkCellOption,
		SimulationOption,
		SubprotocolDescriptionOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption
	}
];

(* conflicting options checks that don't need to do any MapThreading *)
Error::NonEmptyContainers = "The containers `1` provided as ContainerOut options are non-empty and cannot be used as aliquoting destinations at this time. Please check the Contents field of any non-plate container objects used as destinations and ensure they are empty.";

(* MapThreaded error checking *)
Warning::UnknownAmount = "The following sample(s) do not have a known current volume or mass: `1`. Additional checks to validate the requested aliquot amounts will not be performed for these samples.";
Error::ConcentrationRatioMismatch = "Based on the current concentration(s) of `1`, they must be diluted by a ratio of `2` to reach the requested TargetConcentration, `3`. However, Amount (`4`) and `7` (`5`) were also specified, and are in a different ratio (`6`) than that required to reach TargetConcentration. Please consider letting either TargetConcentration or the Amount options remain Automatic.";
Error::NoConcentration = "The TargetConcentration option cannot be reached for `1` because this sample does not have any current concentration information in the correct units for the specified TargetConcentrationAnalyte. Please request either an aliquot Volume only for this sample, or measure the concentration of the value specified with the TargetConcentrationAnalyte option.";
Error::TargetConcentrationTooLarge = "The TargetConcentration specified for `1`, `2`, exceeds the current sample concentration(s), `3`. Currently, ExperimentAliquot only supports dilution. Please specify a TargetConcentration less than or equal to `3`.";
Error::CannotResolveAmount = "Sample(s) `1` do not have a current known `2`, or the Amount and/or `3` option(s) was set explicitly to Null; the request to transfer an Automatic amount (or All or Null) of this sample cannot be satisfied. Please either measure the amount of this sample using ExperimentMeasureVolume, ExperimentMeasureWeight, or ExperimentMeasureCount, or specify a particular amount.";
Error::AliquotVolumeTooLarge = "The sample(s) `1` have their Amount option set to `2`, which exceeds the AssayVolume requested for these sample(s) (`3`). The Amount of sample to be aliquoted must be less than or equal the total AssayVolume; please lower the Amount or raise the AssayVolume for this sample.";
Error::MinimumAliquotAmount = "All Amounts must be above the minimum mass or volume that can be manipulated using standard transfer devices. Check `1` which have amounts of `2`.";
Error::BufferDilutionMismatched = "One or more (but not all) of ConcentratedBuffer, BufferDilutionFactor and/or BufferDiluent are specified for `1`. Please supply values for all or none of these options.";
Error::OverspecifiedBuffer = "Both AssayBuffer and some of ConcentratedBuffer/BufferDilutionFactor/BufferDiluent have been specified for `1`. These buffer options are in conflict; please specify either just AssayBuffer or just ConcentratedBuffer options.";
Warning::BufferWillNotBeUsed = "AssayBuffer and/or ConcentratedBuffer were specified for `1`. However, the buffer(s) will not be used because AssayVolume and Amount are equal. The amount of buffer is determined by AssayVolume minus Amount, therefore currently no dilution will occur for these samples. If it is intended to use the buffer(s) to dilute, please set the the AssayVolume and Amount accordingly. Otherwise, please leave AssayBuffer and/or ConcentratedBuffer Automatic or Null.";
Error::MissingMolecularWeight = "The TargetConcentration option cannot be reached for `1` because these sample(s) do not have a MolecularWeight.  Please request an Amount only for this sample, or specify its TargetConcentration as a mass concentration rather than a molarity concentration.";
Error::StateAmountMismatch = "The Amount option is specified for the following sample(s): `1` using units `2` that do not correspond to these samples' states. Note that if a counted item, Amount must be specified as an integer and not a mass. Please leave Amount as Automatic or specify it directly to the right quantity for the sample's state.";
Warning::TargetConcentrationNotUsed = "The TargetConcentration option has been specified for the following sample(s): `1` for which Amount has been specified as a Count: `2`.  TargetConcentration is not used if specified for counted items.";
Error::NestedIndexMatchingVolumeAboveAssayVolume = "The resolved total volume of nested index matching samples `1` (`2`) is greater than the specified AssayVolume for these samples: `3`.  This may happen if AssayVolume is set but Amount and TargetConcentration are not specified.  Please leave AssayVolume as Automatic, or set Amount or TargetConcentration to the desired values.";
Error::CannotResolveAssayVolume = "The combination of the specified Amount and TargetConcentration options for nested index matching samples `1` is such that AssayVolume cannot be resolved within the same pool.  Please split these nested index matching samples into different groups, or leave TargetConcentration or Amount Automatic.";
Warning::NestedIndexMatchingConsolidateAliquotsNotSupported = "The ConsolidateAliquots option has been set to True when pooling multiple samples together.  Consolidating aliquots is not currently supported when pooling multiple samples together.  Option resolution will continue as if ConsolidateAliquots is set to False.";
Error::BufferDilutionFactorTooLow = "The BufferDilutionFactor option was specified or set automatically to `1`, but this value is too low for the specified or automatically set AssayVolume option `2` for the following sample(s) `3`.  Please increase AssayVolume to allow for sufficiently concentrated buffer, or increase BufferDilutionFactor and use a more concentrated ConcentratedBuffer.";

(* post MapThreaded error checking *)
Warning::TotalAliquotVolumeTooLarge = "The following sample(s) `1` have a volume requested `2` that exceed the volume of these sample(s). The experiment will still attempt to aliquot these amounts with what is currently available; please change the Amount option if this is not desired.";

(* ContainerOut resolution stuff *)
Error::AssayVolumeAboveMaximum = "The following sample(s) `1` have a specified or calculated AssayVolume (`2`) that exceeds the maximum volume supported at ECL (`3`).  Please adjust the options such that the AssayVolume is at or below that value.";
Error::DestinationWellDoesntExist = "The specified `1` value(s) `2` do not exist for corresponding `3` value(s) `4`.  Please specify a destination well position that exists for this container by checking its Positions field, or leave `1` Automatic.";
Error::VolumeOverContainerMax = "Some of the total assay volumes (`1`), exceed the max volume that the ContainerOut option, `2`, can hold (`3`). Please either lower these total volumes to a value below `3` or allow the ContainerOut to be chosen automatically.  If ConsolidateAliquots is set to True, consider turning it to False to ensure no container is overflowing.";
Error::PreparationInvalid = "The specified Preparation requests Robotic, but some of the input containers or ContainerOut containers are not compatible with Robotic.  Please change to Manual, or first change the input or output containers.";
Error::LiquidHandlerOverOccupied = "The Preparation option was set to or resolved to Robotic, but the liquid handlers cannot accommodate the requested aliquots due to deck space limitations. Please either set the Preparation option to Manual, or split the requested aliquot into multiple protocols.";



(* ::Subsubsection:: *)
(*ExperimentAliquot*)


(* just define this pattern here because we need it in many places; essentially, a non-plate container *)
nonPlateContainerP := Except[ObjectP[{Object[Container, Plate], Model[Container, Plate]}], ObjectP[{Object[Container], Model[Container]}]];

(*
	Single Sample with No Second Input:
		- Takes a single sample and passes through to core overload
*)
ExperimentAliquot[mySample:ObjectP[Object[Sample]], myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[{{mySample}}, myOptions];

(*
	CORE OVERLOAD: List Sample with No Second Input (all options):
		- Core functionality lives here
		- If initial experiment call involved volume/concentration second inputs, these will be in option values for this overload
*)
ExperimentAliquot[mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myOptions:OptionsPattern[ExperimentAliquot]] := Module[
	{
		specifiedConcentratedBuffer, specifiedAssayBuffer, specifiedBufferDiluent, specifiedContainerOut, inheritedCache,
		allBufferModels, allBufferObjs, containerOutModels, containerOutObjs, allDownloadValues, newCache, listedOptions,
		listedSamples, outputSpecification, output, gatherTests, messages, safeOptionTests, upload, confirm, canaryBranch, fastTrack,
		parentProt, validLengthTests, combinedOptions, expandedCombinedOptions, resolveOptionsResult, resolvedOptions,
		resolutionTests, preCollapsedResolvedOptions, finalizedPackets, resourcePacketTests, allTests, validQ,
		safeOptions, validLengths, unresolvedOptions, applyTemplateOptionTests, safeOpsWithNames, updatedSimulation,
		preferredVesselContainerModels, previewRule, optionsRule, testsRule, resultRule, collapseAmountQ,
		collapseTargetConcQ, resolvedOptionsCollapsedPooled, samplesWithoutTemporalLinks, optionsWithoutTemporalLinks,
		resourcePacketsSimulation, resolvedOptionsCollapsedPooledWithHidden, performSimulationQ, resultQ, runTimeRule,
		simulatedProtocol, newSimulation, simulationRule, resolvedPreparation, enableSamplePreparation, resolvedWorkCell,
		semiCollapsedAmount, semiCollapsedTargetConc, semiCollapsedTargetConcAnalyte, collapseTargetConcAnalyteQ, resolveMethod,
		resourcePacketsResult, simulationResult, optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly,
		returnEarlyBecauseFailuresOrMethodQ, samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
		validSamplePreparationResult, constellationMessageRule
	},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages (also silence messages if we are just resolving the method) *)
	gatherTests = MemberQ[output, Tests];
	resolveMethod = Lookup[ToList[myOptions], ResolveMethod, False];
	messages = Not[gatherTests] && Not[resolveMethod];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{samplesWithoutTemporalLinks, optionsWithoutTemporalLinks} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAliquot,
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
		SafeOptions[ExperimentAliquot, optionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAliquot, optionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
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
		ValidInputLengthsQ[ExperimentAliquot, {listedSamples}, listedOptions, 6, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAliquot, {listedSamples}, listedOptions, 6], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[Not[validLengths],
		Return[outputSpecification /.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,validLengthTests}],
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
		ApplyTemplateOptions[ExperimentAliquot, {listedSamples}, optionsWithoutTemporalLinks, 6, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentAliquot, {listedSamples}, optionsWithoutTemporalLinks, 6, Output -> Result], Null}
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* expand the combined options *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentAliquot, {listedSamples}, combinedOptions, 6]];

	(* --- Make our one big Download call --- *)

	(* pull out the ConcentratedBuffer, AssayBuffer, BufferDiluent, and ContainerOut options *)
	{
		specifiedConcentratedBuffer,
		specifiedAssayBuffer,
		specifiedBufferDiluent,
		specifiedContainerOut
	} = Lookup[expandedCombinedOptions, {ConcentratedBuffer, AssayBuffer, BufferDiluent, ContainerOut}];

	(* get all the buffers that were specified as models and objects *)
	allBufferModels = Cases[Flatten[{specifiedConcentratedBuffer, specifiedAssayBuffer, specifiedBufferDiluent}], ObjectP[Model[Sample]]];
	allBufferObjs = Cases[Flatten[{specifiedConcentratedBuffer, specifiedAssayBuffer, specifiedBufferDiluent}], ObjectP[Object[Sample]]];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Object[Container]]];

	(* if the Container option is Automatic, we might end up calling PreferredContainer; so we've gotta make sure we download info from all the objects it might spit out *)
	preferredVesselContainerModels = If[MatchQ[specifiedContainerOut, Automatic] || MemberQ[Flatten[ToList[specifiedContainerOut]], Automatic],
		DeleteDuplicates[
			Flatten[{
				PreferredContainer[All, Type -> All],
				PreferredContainer[All, Sterile -> True, Type -> All],
				PreferredContainer[All, Sterile -> True, LiquidHandlerCompatible -> True, Type -> All]
			}]
		],
		{}
	];

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
					preferredVesselContainerModels
				},
				{
					{
						Packet[Name, Volume, Mass, Count, Status, Model, Position, Container, Sterile, AsepticHandling, State, Tablet, SolidUnitWeight, Living, LiquidHandlerIncompatible, CellType, Composition, Analytes, IncompatibleMaterials],
						Packet[Model[{Name, Living, CellType, Composition, Sterile, AsepticHandling, Deprecated, LiquidHandlerIncompatible, IncompatibleMaterials}]],
						Packet[Container[{Name, Status, Model, Contents, Sterile, AsepticHandling, TareWeight, Container, Position}]],
						Packet[Container[Model][{Name, Deprecated, MaxVolume, Sterile, AspectRatio, Dimensions, NumberOfWells, Footprint, Positions, LiquidHandlerPrefix, LiquidHandlerAdapter, CoverTypes, CoverFootprints}]],
						Packet[Composition[[All,2]][MolecularWeight]]
					},
					{
						Packet[Name, Sterile, AsepticHandling, Deprecated, ConcentratedBufferDilutionFactor, LiquidHandlerIncompatible, IncompatibleMaterials]
					},
					{
						Packet[Name, Volume, Mass, Count, Status, Model, Position, Container, Sterile, AsepticHandling, State, Tablet, SolidUnitWeight, Sterile, LiquidHandlerIncompatible, Composition, Analytes, IncompatibleMaterials],
						Packet[Model[{Name, Deprecated, ConcentratedBufferDilutionFactor, LiquidHandlerIncompatible, IncompatibleMaterials}]],
						Packet[Container[{Name, Status, Model, Contents, Sterile, AsepticHandling, TareWeight, Container, Position}]],
						Packet[Container[Model][{Name, Deprecated, MaxVolume, Sterile, Footprint, Positions, LiquidHandlerPrefix, LiquidHandlerAdapter, CoverTypes, CoverFootprints}]]
					},
					{
						Packet[Name, MaxVolume, Sterile, AsepticHandling, Deprecated, AspectRatio, Dimensions, NumberOfWells, Footprint, Positions, CoverTypes, CoverFootprints, LiquidHandlerPrefix, LiquidHandlerAdapter]
					},
					{
						Packet[Name, Status, Model, Contents, TareWeight, Sterile, AsepticHandling, Position, Container],
						Packet[Model[{Name, MaxVolume, Sterile, AsepticHandling, Deprecated, AspectRatio, Dimensions, NumberOfWells, Footprint, Positions, LiquidHandlerPrefix, LiquidHandlerAdapter, CoverTypes, CoverFootprints}]]
					},
					{
						Packet[Name, MaxVolume, Sterile, AsepticHandling, Deprecated, AspectRatio, Dimensions, NumberOfWells, Footprint, Positions, LiquidHandlerPrefix, LiquidHandlerAdapter]
					}
				},
				Cache -> inheritedCache,
				Simulation -> updatedSimulation,
				Date -> Now
			],
			{Download::FieldDoesntExist,Download::MissingCacheField}
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
			resolveExperimentAliquotOptions[listedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache, Simulation -> updatedSimulation],
			{resolveExperimentAliquotOptions[listedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache, Simulation -> updatedSimulation], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* pull out the Preparation option *)
	{resolvedPreparation, enableSamplePreparation, resolvedWorkCell} = Lookup[resolvedOptions, {Preparation, EnableSamplePreparation, WorkCell}];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveExperimentAliquotOptions doesn't have access to listedOptions *)
	preCollapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentAliquot,
		resolvedOptions,
		(* ContainerOut is special and CANNOT be collapsed because it needs to be a list of lists and should be returned expanded *)
		Ignore -> ReplaceRule[listedOptions, ContainerOut -> Lookup[resolvedOptions, ContainerOut]],
		Messages -> False
	];

	(* get the collapsed amount/TargetConcentration/TargetConcentrationAnalyte so that it's not unnecessarily listy *)
	(* only semi-collapsed though; just to remove pools, not to make totally singleton *)
	semiCollapsedAmount = Map[
		Function[resolvedValue,
			If[ListQ[resolvedValue] && Length[DeleteDuplicates[Flatten[resolvedValue]]] == 1,
				First[resolvedValue],
				resolvedValue
			]
		],
		Lookup[resolvedOptions, Amount]
	];
	semiCollapsedTargetConc = Map[
		Function[resolvedValue,
			If[ListQ[resolvedValue] && Length[DeleteDuplicates[Flatten[resolvedValue]]] == 1,
				First[resolvedValue],
				resolvedValue
			]
		],
		Lookup[resolvedOptions, TargetConcentration]
	];
	semiCollapsedTargetConcAnalyte = Map[
		Function[resolvedValue,
			If[ListQ[resolvedValue] && Length[DeleteDuplicates[Flatten[resolvedValue]]] == 1,
				First[resolvedValue],
				resolvedValue
			]
		],
		Lookup[resolvedOptions, TargetConcentrationAnalyte]
	];

	(* collapse the Amount option if *)
	(* 0.) Amount is a list *)
	(* 1.) all the Amount values are the same *)
	(* 2.) Amount was either not specified, or if it was specified, was not specified in a listed form *)
	collapseAmountQ = And[
		ListQ[semiCollapsedAmount],
		Length[DeleteDuplicates[Flatten[semiCollapsedAmount]]] == 1,
		MatchQ[Lookup[listedOptions, Amount], Null|UnitsP[]|Automatic|_?MissingQ]
	];

	(* collapse the TargetConcentration option if *)
	(* 1.) all the TargetConcentration values are the same *)
	(* 2.) TargetConcentration was either not specified, or if it was specified, was not specified in a listed form *)
	collapseTargetConcQ = And[
		ListQ[semiCollapsedTargetConc],
		Length[DeleteDuplicates[Flatten[semiCollapsedTargetConc]]] == 1,
		MatchQ[Lookup[listedOptions, TargetConcentration], Null|UnitsP[]|Automatic|_?MissingQ]
	];

	(* collapse the TargetConcentrationAnalyte option if *)
	(* 1.) all the TargetConcentrationAnalyte values are the same *)
	(* 2.) TargetConcentrationAnalyte was either not specified, or if it was specified, was not specified in a listed form *)
	collapseTargetConcAnalyteQ = And[
		ListQ[semiCollapsedTargetConcAnalyte],
		Length[DeleteDuplicates[Flatten[semiCollapsedTargetConcAnalyte]]] == 1,
		MatchQ[Lookup[listedOptions, TargetConcentrationAnalyte], Null|UnitsP[]|Automatic|_?MissingQ]
	];

	(* collapse the Amount and TargetConcentration options if necessary *)
	resolvedOptionsCollapsedPooledWithHidden = ReplaceRule[
		preCollapsedResolvedOptions,
		{
			Amount -> If[collapseAmountQ,
				First[semiCollapsedAmount],
				semiCollapsedAmount
			],
			TargetConcentration -> If[collapseTargetConcQ,
				First[semiCollapsedTargetConc],
				semiCollapsedTargetConc
			],
			TargetConcentrationAnalyte -> If[collapseTargetConcAnalyteQ,
				First[semiCollapsedTargetConcAnalyte],
				semiCollapsedTargetConcAnalyte
			]
		}
	];

	(* remove the hidden options if desired *)
	resolvedOptionsCollapsedPooled = RemoveHiddenOptions[ExperimentAliquot, resolvedOptionsCollapsedPooledWithHidden];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	(* also return early if we are resolving the method because we don't want the overhead of everything else; we just want robotic vs manual *)
	returnEarlyBecauseFailuresOrMethodQ = Which[
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
	If[(returnEarlyBecauseFailuresOrMethodQ && resolveMethod) || (!performSimulationQ && returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Options -> If[MatchQ[resolvedPreparation, Robotic] || enableSamplePreparation || resolveMethod,
				resolvedOptionsCollapsedPooledWithHidden,
				resolvedOptionsCollapsedPooled
			],
			Preview -> Null,
			Tests -> Flatten[{
				safeOptionTests,
				applyTemplateOptionTests,
				validLengthTests,
				resolutionTests
			}],
			Simulation -> Simulation[]
		}]
	];

	(* call the aliquotResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	(* if we have Output -> Options and we are in a SamplePrep sub call we are going to cut some corners to at least do some of the necessary error checking with fulfillableResourceQ; that's what this function is here; not sure if it is sufficient anymore though given how simulation works so might need to delete this; we'll see *)
	resourcePacketsResult = Check[
		{finalizedPackets, resourcePacketsSimulation, resourcePacketTests} = Which[
			(* if we're inside the work cell resolver then don't bother with this *)
			(MatchQ[resolvedPreparation, Robotic] && Not[MemberQ[output, Result|Simulation]]) || MatchQ[resolveOptionsResult, $Failed] || returnEarlyBecauseFailuresOrMethodQ, {$Failed, updatedSimulation, {}},
			Not[MemberQ[output, Result]] && MemberQ[output, Options] && Not[MemberQ[output, Simulation]] && gatherTests, shortcutAliquotResourcePackets[listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation, Tests}], Cache -> newCache, Simulation -> updatedSimulation],
			Not[MemberQ[output, Result]] && MemberQ[output, Options] && Not[MemberQ[output, Simulation]], {shortcutAliquotResourcePackets[listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> Result], Cache -> newCache, Simulation -> updatedSimulation], updatedSimulation, Null},
			gatherTests, aliquotResourcePackets[listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation, Tests}], Cache -> newCache, Simulation -> updatedSimulation],
			True, {Sequence @@ aliquotResourcePackets[listedSamples, unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Simulation}], Cache -> newCache, Simulation -> updatedSimulation], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* if we asked for a simulation, then return a simulation *)
	simulationResult = Check[
		{simulatedProtocol, newSimulation} = Which[
			performSimulationQ&&!resultQ,
			simulateExperimentAliquot[
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
				simulateExperimentAliquot[
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
		MatchQ[finalizedPackets, $Failed] || MemberQ[Flatten[finalizedPackets], $Failed] || MatchQ[simulationResult, $Failed] || MatchQ[resourcePacketsResult, $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"ExperimentAliquot tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Which[
		MemberQ[output, Options] && (MatchQ[resolvedPreparation, Robotic] || enableSamplePreparation), resolvedOptionsCollapsedPooledWithHidden,
		MemberQ[output, Options], resolvedOptionsCollapsedPooled,
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

	(* generate the RunTime rule *)
	runTimeRule = RunTime -> If[MatchQ[resolvedPreparation, Robotic],
		Length[Flatten[mySamples]] * 20 Second,
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
		MatchQ[resolvedPreparation, Robotic] && MatchQ[upload, False],
			Rest[finalizedPackets],
		(* if we are doing Preparation -> Robotic and Upload -> True, then call ExperimentRoboticSamplePreparation on the aliquot unit operations *)
		MatchQ[resolvedPreparation, Robotic],
			Module[
				{
					unitOperation, nonHiddenOptions, unsortedPackets, samplesOutLabels, unsortedFutureLabeledObjects,
					unsortedSampleOutFutureLabeledObjects, sortedSampleOutFutureLabeledObjects, sortedFutureLabeledObjects,
					newProtocolPacket, allPackets, samplesMaybeWithModels, experimentFunction
				},

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

				unitOperation = Aliquot @@ Join[
					{
						Source -> samplesMaybeWithModels
					},
					RemoveHiddenPrimitiveOptions[Aliquot, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentAliquot, resolvedOptionsCollapsedPooled];

				(* Memoize the value of ExperimentAliquot so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentAliquot, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache=<||>;

					DownValues[ExperimentAliquot]={};

					ExperimentAliquot[___, options : OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification /. {
							Result -> Rest[finalizedPackets],
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> newSimulation,
							RunTime -> (Length[Flatten[mySamples]] * 20 Second),
							Tests -> allTests
						}
					];

					(* pick the corresponding function from the association above *)
					experimentFunction = Lookup[$WorkCellToExperimentFunction, resolvedWorkCell];

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

					(* if for whatever reason this RSP fails, return $Failed instead of going any further *)
					If[MatchQ[unsortedPackets, $Failed],
						Return[$Failed, Module]
					];

					(* pull out the samples out labels from the resolved options *)
					samplesOutLabels = Lookup[resolvedOptions, SampleOutLabel];

					(* pull out the FutureLabeledObjects from the packets we just generated *)
					unsortedFutureLabeledObjects = Lookup[First[unsortedPackets], Replace[FutureLabeledObjects]];

					(* get the entries of the FutureLabeledObjects that correspond with the SampleOutLabel values *)
					unsortedSampleOutFutureLabeledObjects = Select[unsortedFutureLabeledObjects, MatchQ[First[#], Alternatives @@ samplesOutLabels] &];

					(* sort the entries of the FutureLabeledObjects that correspond with the SampleOutLabel values *)
					sortedSampleOutFutureLabeledObjects = Map[
						Function[{label},
							SelectFirst[unsortedSampleOutFutureLabeledObjects, MatchQ[First[#], label]&]
						],
						samplesOutLabels
					];

					(* recombine these sorted future labeled object values with the other FutureLabeledObjects *)
					sortedFutureLabeledObjects = Join[
						Select[unsortedFutureLabeledObjects, Not[MatchQ[First[#], Alternatives @@ samplesOutLabels]] &],
						sortedSampleOutFutureLabeledObjects
					];

					(* make the new product packet with the sorted FutureLabeledObjects *)
					newProtocolPacket = Append[
						First[unsortedPackets],
						Replace[FutureLabeledObjects] -> sortedFutureLabeledObjects
					];

					(* get all the packets together *)
					allPackets = Flatten[{
						newProtocolPacket,
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
		(* don't need to call experimentFunction here because we already called it in the resource packets function *)
		MatchQ[resolvedPreparation, Manual] && MemberQ[output, Result] && upload && StringQ[Lookup[resolvedOptions, Name]],
			(
				Upload[finalizedPackets, constellationMessageRule];
				If[confirm, UploadProtocolStatus[Lookup[First[finalizedPackets], Object], OperatorStart, Upload -> True, FastTrack -> True, UpdatedBy -> If[NullQ[parentProt], $PersonID, parentProt]]];
				Append[Lookup[First[finalizedPackets], Type], Lookup[resolvedOptions, Name]]
			),
		MatchQ[resolvedPreparation, Manual] && MemberQ[output, Result] && upload,
			(
				Upload[finalizedPackets, constellationMessageRule];
				If[confirm, UploadProtocolStatus[Lookup[First[finalizedPackets], Object], OperatorStart, Upload -> True, FastTrack -> True, UpdatedBy -> If[NullQ[parentProt], $PersonID, parentProt]]];
				Lookup[First[finalizedPackets], Object]
			),
		MatchQ[resolvedPreparation, Manual] && MemberQ[output, Result] && Not[upload],
			finalizedPackets,
		True,
			$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule, simulationRule, runTimeRule}

];

(*
	Single container with no second input:
		- Takes a single container and passes it to the core container overload
*)

ExperimentAliquot[myContainer:ObjectP[{Object[Container], Model[Sample]}], myOptions:OptionsPattern[ExperimentAliquot]]:=ExperimentAliquot[{{myContainer}}, myOptions];

(*
	Multiple containers with no second input:
		- expands the Containers into their contents and passes to the core function
*)

ExperimentAliquot[myContainers:{ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]]..}, myOptions:OptionsPattern[ExperimentAliquot]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, containerToSampleResult,
		containerToSampleTests, inputSamples, samplesOptions, aliquotResults, initialReplaceRules, testsRule, resultRule,
		previewRule, optionsRule, pooledContainers, safePooledOptions, simulationRule, runTimeRule, safeOptionsWithNames,
		sanitizedContainers, optionsWithPreparedSamples, simulation, listedContainers, allPreparedContainers,
		myOptionsWithPreparedSamplesNamed, updatedSimulation, validSamplePreparationResult},

	(* make sure we're working with a list of options *)
	listedContainers = ToList[myContainers];
	listedOptions = ToList[myOptions];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* lookup the simulation, if one exists *)
	simulation = Lookup[listedOptions, Simulation];

	(*--Simulate sample preparation--*)
	(* initialSamplePreparationCache,samplePreparationCache *)
	validSamplePreparationResult = Check[
		{allPreparedContainers, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentAliquot,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(*If we are given an invalid define name, return early*)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];
		Return[$Failed]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsWithNames, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentAliquot, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAliquot, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];

	(* Replace all objects referenced by Name to ID *)
	{sanitizedContainers, safeOptions, optionsWithPreparedSamples} = sanitizeInputs[allPreparedContainers, safeOptionsWithNames, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* need to pool the containers and safe options *)
	pooledContainers = ToList[#]& /@ sanitizedContainers;
	safePooledOptions = ReplaceRule[
		safeOptions,
		{
			Amount->If[MatchQ[Lookup[safeOptions, Amount], UnitsP[] | Automatic | Null], ConstantArray[{Lookup[safeOptions,Amount]}, Length[sanitizedContainers]], (ToList/@Lookup[safeOptions,Amount])],
			TargetConcentration->If[MatchQ[Lookup[safeOptions, TargetConcentration], UnitsP[] | Automatic | Null], ConstantArray[{Lookup[safeOptions,TargetConcentration]}, Length[myContainers]], (ToList/@Lookup[safeOptions,TargetConcentration])]
		}
	];

	(* convert the containers to samples, and also get the options index matched properly *)
	{containerToSampleResult, containerToSampleTests} = If[gatherTests,
		pooledContainerToSampleOptions[
			ExperimentAliquot,
			pooledContainers,
			safePooledOptions,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],
		{
			pooledContainerToSampleOptions[
				ExperimentAliquot,
				pooledContainers,
				safePooledOptions,
				Simulation -> updatedSimulation
			],
			Null
		}
	];

	(* If the specified containers aren't allowed *)
	If[MatchQ[containerToSampleResult,$Failed],
		Return[$Failed]
	];

	(* separate out the samples and the options *)
	{inputSamples, samplesOptions} = containerToSampleResult;

	(* call ExperimentAliquot and get all its outputs *)
	aliquotResults = ExperimentAliquot[inputSamples, ReplaceRule[samplesOptions, Simulation -> updatedSimulation]];

	(* create a list of replace rules from the mass spec call above and whatever the output specification is *)
	initialReplaceRules = If[MatchQ[outputSpecification, _List],
		MapThread[
			#1 -> #2&,
			{outputSpecification, aliquotResults}
		],
		{outputSpecification -> aliquotResults}
	];

	(* if we are gathering tests, then prepend the safeOptionsTests and containerToSampleTests to the tests we already have *)
	testsRule = Tests -> If[gatherTests,
		Prepend[Lookup[initialReplaceRules, Tests], Flatten[{safeOptionTests, containerToSampleTests}]],
		Null
	];

	(* Results rule is just always what was output in the ExperimentAliquot call *)
	resultRule = Result -> Lookup[initialReplaceRules, Result, Null];

	(* preview is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Lookup[initialReplaceRules, Options, Null];

	(* generate the simulation rule*)
	simulationRule = Simulation -> Lookup[initialReplaceRules, Simulation, Null];

	(* generate the RUnTime rule *)
	runTimeRule = RunTime -> Lookup[initialReplaceRules, RunTime, Null];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule, simulationRule, runTimeRule}
];

(* --- Specific Amount Overloads --- *)

(*
	Single Sample, Single amount; pass to listed overload
*)
ExperimentAliquot[mySample:ObjectP[Object[Sample]], myAmount:(GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[{{mySample}}, {{myAmount}}, myOptions];

(*
	Many Samples, Single Amount:
		- Extend the single amount to match the length of the sample list, and pass to MapThread Overload
*)
ExperimentAliquot[mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myAmount:(GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[mySamples, ConstantArray[myAmount, Length[mySamples]], myOptions];

(*
	Single container, single amount; pass to listed overload
*)
ExperimentAliquot[myContainer:ObjectP[{Object[Container], Object[Sample], Model[Sample]}], myAmount:(GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All), myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[{{myContainer}}, {{myAmount}}, myOptions];

(*
	Many Containers, single Volume:
		- Extend the single volume to match the length of the container list, and pass to MapThread overload
*)
ExperimentAliquot[myContainers:{ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]]..}, myAmount:(GreaterP[0 Liter] | GreaterP[0 Gram] | All), myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[myContainers, ConstantArray[myAmount, Length[myContainers]], myOptions];

(*
	MapThread Containers/Volumes overload:
		- Convert the Volume input to a Volume option call for the CORE overload
		- Convert the containers to samples
		- pass to the core sample overload
*)

ExperimentAliquot[myContainers:{ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]]..}, myAmounts:{ListableP[(GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..}, myOptions:OptionsPattern[ExperimentAliquot]] := Module[
	{outputSpecification, output, gatherTests, validLengths, validLengthsTests, updatedOptions, safeOptions,
		safeOptionTests, containerToSampleTests, containerToSampleResult, inputSamples, samplesOptions, aliquotResults,
		initialReplaceRules, testsRule, resultRule, previewRule, optionsRule, pooledContainers, safePooledOptions,
		simulationRule,runTimeRule, safeOptionsWithNames, sanitizedContainers, optionsWithPreparedSamples},

	(* Determine the requested return value from the function; can't get from safe options since we need to GIVE it to SafeOptions! *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* set a boolean to indicate throughout this function if we will be gathering Tests a la ValidExperimentAliquotQ;
	assume that Output won't be given with Tests AND Results *)
	gatherTests = MemberQ[output, Tests];

	(* validate input/option lengths; again, make sure to gather tests if asked *)
	{validLengths, validLengthsTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentAliquot, {myContainers, myAmounts}, {}, 4, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAliquot, {myContainers, myAmounts}, {}, 4], {}}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> validLengthsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Lookup[ToList[myOptions], Simulation, Simulation[]]
		}]
	];

	(* update these option values in the provided options *)
	updatedOptions = ReplaceRule[ToList[myOptions], {Amount -> myAmounts}];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsWithNames, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentAliquot, updatedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAliquot, updatedOptions, AutoCorrect -> False], Null}
	];

	(* Replace all objects referenced by Name to ID *)
	{sanitizedContainers, safeOptions, optionsWithPreparedSamples} = sanitizeInputs[myContainers, safeOptionsWithNames, updatedOptions, Simulation -> Lookup[safeOptionsWithNames, Simulation]];


	(* TODO simulate sample preparation packets new here *)

	(* If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthsTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* need to pool the containers and safe options *)
	pooledContainers = ToList[#]& /@ sanitizedContainers;
	safePooledOptions = ReplaceRule[safeOptions,{Amount->(ToList/@Lookup[safeOptions,Amount]),TargetConcentration->(ToList/@Lookup[safeOptions,TargetConcentration])}];

	(* convert the containers to samples, and also get the options index matched properly *)
	(* pooledContainerToSampleOptions for whatever reason needs its simulation passed directly in *)
	{containerToSampleResult, containerToSampleTests} = If[gatherTests,
		pooledContainerToSampleOptions[ExperimentAliquot, pooledContainers, safePooledOptions, Simulation -> Lookup[safePooledOptions, Simulation], Output -> {Result, Tests}],
		{pooledContainerToSampleOptions[ExperimentAliquot, pooledContainers, safePooledOptions, Simulation -> Lookup[safePooledOptions, Simulation]], Null}
	];

	(* If the specified containers aren't allowed *)
	If[MatchQ[containerToSampleResult,$Failed],
		Return[$Failed]
	];

	(* separate out the samples and the options *)
	{inputSamples, samplesOptions} = containerToSampleResult;

	(* call ExperimentAliquot and get all its outputs *)
	aliquotResults = ExperimentAliquot[inputSamples, samplesOptions];

	(* create a list of replace rules from the mass spec call above and whatever the output specification is *)
	initialReplaceRules = If[MatchQ[outputSpecification, _List],
		MapThread[
			#1 -> #2&,
			{outputSpecification, aliquotResults}
		],
		{outputSpecification -> aliquotResults}
	];

	(* if we are gathering tests, then prepend the safeOptionsTests and containerToSampleTests to the tests we already have *)
	testsRule = Tests -> If[gatherTests,
		Prepend[Lookup[initialReplaceRules, Tests], Flatten[{safeOptionTests, containerToSampleTests}]],
		Null
	];

	(* Results rule is just always what was output in the ExperimentAliquot call *)
	resultRule = Result -> Lookup[initialReplaceRules, Result, Null];

	(* preview is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Lookup[initialReplaceRules, Options, Null];

	(* generate the simulation rule*)
	simulationRule = Simulation -> Lookup[initialReplaceRules, Simulation, Null];

	(* generate the RUnTime rule *)
	runTimeRule = RunTime -> Lookup[initialReplaceRules, RunTime, Null];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule, simulationRule, runTimeRule}

];

(*
	MapThread Samples/Amount Overload:
		- Convert the Amount input to a Volume/Mass option call for the CORE overload
*)
ExperimentAliquot[mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myAmounts:{ListableP[(GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit] | GreaterP[0., 1.] | All)]..}, myOptions:OptionsPattern[ExperimentAliquot]] := Module[
	{outputSpecification, output, gatherTests, updatedOptions, validLengths, validLengthsTests},

	(* Determine the requested return value from the function; can't get from safe options since we need to GIVE it to SafeOptions! *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* set a boolean to indicate throughout this function if we will be gathering Tests a la ValidExperimentAliquotQ;
	assume that Output won't be given with Tests AND Results *)
	gatherTests = MemberQ[output, Tests];

	(* validate input/option lengths; again, make sure to gather tests if asked *)
	{validLengths, validLengthsTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentAliquot, {mySamples, myAmounts}, {}, 4, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAliquot, {mySamples, myAmounts}, {}, 4], {}}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> validLengthsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Lookup[ToList[myOptions], Simulation, Simulation[]]
		}]
	];

	(* update these option values in the provided options *)
	updatedOptions = ReplaceRule[ToList[myOptions], {Amount -> myAmounts}];

	(* pipe to the main overload *)
	ExperimentAliquot[mySamples, updatedOptions]
];

(* --- Specific TargetConcentration Overloads --- *)

(*
	Single Sample, Single TargetConcentration; pass to listed overload
*)
ExperimentAliquot[mySample:ObjectP[Object[Sample]], myConcentration:(GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)]), myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[{{mySample}}, {{myConcentration}}, myOptions];

(*
	Many Samples, Single TargetConcentration:
		- Extend the single concentration to match the length of the sample list, and pass to MapThread Overload
*)
ExperimentAliquot[mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myConcentration:(GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)]), myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[mySamples, ConstantArray[myConcentration, Length[mySamples]], myOptions];

(*
	MapThread Samples/Concentrations Overload:
		- Make sure we haven't been given BOTH the concentration input and TargetConcentration option
		- Convert the concentration input to a TargetConcentration option call for the CORE overload
*)
ExperimentAliquot[mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myConcentrations:{ListableP[(GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)])]..}, myOptions:OptionsPattern[ExperimentAliquot]] := Module[
	{outputSpecification, output, gatherTests, validLengths, validLengthsTests, updatedOptions},

	(* Determine the requested return value from the function; this is a Hidden option, so assume it was provided correctly (i.e. do not default);
	 can't get from safe options since we need to GIVE it to SafeOptions! *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* set a boolean to indicate throughout this function if we will be gathering Tests a la ValidExperimentAliquotQ;
	assume that Output won't be given with Tests AND Results *)
	gatherTests = MemberQ[output, Tests];

	(* validate input/option lengths; again, make sure to gather tests if asked *)
	{validLengths, validLengthsTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentAliquot, {mySamples, myConcentrations}, {}, 5, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAliquot, {mySamples, myConcentrations}, {}, 5], {}}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> validLengthsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Lookup[ToList[myOptions], Simulation, Simulation[]]
		}]
	];

	(* update these option values in the safe options *)
	updatedOptions = ReplaceRule[ToList[myOptions], {TargetConcentration -> myConcentrations}];

	(* pipe to the main overload *)
	ExperimentAliquot[mySamples, updatedOptions]
];


(*
	Single container, single concentration; pass to listed overload
*)
ExperimentAliquot[myContainer:ObjectP[{Object[Container], Model[Sample]}], myConcentration:(GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)]), myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[{{myContainer}}, {{myConcentration}}, myOptions];

(*
	Many Containers, single concentration:
		- Extend the single volume to match the length of the container list, and pass to MapThread overload
*)
ExperimentAliquot[myContainers:{ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]]..}, myConcentration:(GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)]), myOptions:OptionsPattern[ExperimentAliquot]] := ExperimentAliquot[myContainers, ConstantArray[myConcentration, Length[myContainers]], myOptions];

(*
	MapThread Containers/concentration overload:
		- Convert the Volume input to a Volume option call for the CORE overload
		- Convert the containers to samples
		- pass to the core sample overload
*)

ExperimentAliquot[myContainers:{ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]]..}, myConcentrations:{ListableP[(GreaterP[0 Molar] | GreaterP[0 (Gram / Liter)])]..}, myOptions:OptionsPattern[ExperimentAliquot]] := Module[
	{outputSpecification, output, gatherTests, validLengths, validLengthsTests, updatedOptions, safeOptions,
		safeOptionTests, containerToSampleTests, containerToSampleResult, inputSamples, samplesOptions, aliquotResults,
		initialReplaceRules, testsRule, resultRule, previewRule, optionsRule, pooledContainers, safePooledOptions,
		simulationRule, runTimeRule, safeOptionsWithNames, optionsWithPreparedSamples, sanitizedContainers},

	(* Determine the requested return value from the function; can't get from safe options since we need to GIVE it to SafeOptions! *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* set a boolean to indicate throughout this function if we will be gathering Tests a la ValidExperimentAliquotQ;
	assume that Output won't be given with Tests AND Results *)
	gatherTests = MemberQ[output, Tests];

	(* validate input/option lengths; again, make sure to gather tests if asked *)
	{validLengths, validLengthsTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentAliquot, {myContainers, myConcentrations}, {}, 5, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentAliquot, {myContainers, myConcentrations}, {}, 5], {}}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> validLengthsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* update these option values in the provided options *)
	updatedOptions = ReplaceRule[ToList[myOptions], {TargetConcentration -> myConcentrations}];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsWithNames, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentAliquot, updatedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentAliquot, updatedOptions, AutoCorrect -> False], Null}
	];

	(* Replace all objects referenced by Name to ID *)
	{sanitizedContainers, safeOptions, optionsWithPreparedSamples} = sanitizeInputs[myContainers, safeOptionsWithNames, updatedOptions, Simulation -> Lookup[safeOptionsWithNames, Simulation]];

	(* TODO simulate sample preparation packets new *)

	(* If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthsTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* need to pool the containers and safe options *)
	pooledContainers = ToList[#]& /@ sanitizedContainers;
	safePooledOptions = ReplaceRule[safeOptions,{Amount->(ToList/@Lookup[safeOptions,Amount]),TargetConcentration->(ToList/@Lookup[safeOptions,TargetConcentration])}];

	(* convert the containers to samples, and also get the options index matched properly *)
	(* pooledContainerToSampleOptions for whatever reason needs its simulation passed directly in *)
	{containerToSampleResult, containerToSampleTests} = If[gatherTests,
		pooledContainerToSampleOptions[ExperimentAliquot, pooledContainers, safePooledOptions, Simulation -> Lookup[safePooledOptions, Simulation], Output -> {Result, Tests}],
		{pooledContainerToSampleOptions[ExperimentAliquot, pooledContainers, safePooledOptions, Simulation -> Lookup[safePooledOptions, Simulation]], Null}
	];

	(* If the specified containers aren't allowed *)
	If[MatchQ[containerToSampleResult,$Failed],
		Return[$Failed]
	];


	(* separate out the samples and the options *)
	{inputSamples, samplesOptions} = containerToSampleResult;

	(* call ExperimentAliquot and get all its outputs *)
	aliquotResults = ExperimentAliquot[inputSamples, samplesOptions];

	(* create a list of replace rules from the mass spec call above and whatever the output specification is *)
	initialReplaceRules = If[MatchQ[outputSpecification, _List],
		MapThread[
			#1 -> #2&,
			{outputSpecification, aliquotResults}
		],
		{outputSpecification -> aliquotResults}
	];

	(* if we are gathering tests, then prepend the safeOptionsTests and containerToSampleTests to the tests we already have *)
	testsRule = Tests -> If[gatherTests,
		Prepend[Lookup[initialReplaceRules, Tests], Flatten[{safeOptionTests, containerToSampleTests}]],
		Null
	];

	(* Results rule is just always what was output in the ExperimentAliquot call *)
	resultRule = Result -> Lookup[initialReplaceRules, Result, Null];

	(* preview is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> Lookup[initialReplaceRules, Options, Null];

	(* generate the simulation rule*)
	simulationRule = Simulation -> Lookup[initialReplaceRules, Simulation, Null];

	(* generate the RUnTime rule *)
	runTimeRule = RunTime -> Lookup[initialReplaceRules, RunTime, Null];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule, simulationRule, runTimeRule}

];


(* ::Subsubsection::Closed:: *)
(*convertTransferStepsToPrimitives*)

DefineOptions[convertTransferStepsToPrimitives,
	Options :> {
		CacheOption,
		SimulationOption
	}
];

(* helper function that takes the transfers we want to do + the resolved options, and makes them into actual transfer primitives.  This called in the resource packets function and the simulation function *)
convertTransferStepsToPrimitives[
	mySamplePackets:{{PacketP[Object[Sample]]..}..},
	mySourcesToTransfer:{(ObjectP[]|_String)..},
	myDestsToTransferTo:{(ObjectP[]|_String)..},
	myDestWells:{WellP..},
	myAmountsToTransfer:{(VolumeP|MassP|CountP|UnitsP[Unit])..},
	myResolvedOptions:{___Rule},
	ops:OptionsPattern[convertTransferStepsToPrimitives]
]:=Module[
	{resolvedAssayBuffer, resolvedBufferDiluent, resolvedConcentratedBuffer, assayBufferLabel, bufferDiluentLabel,
		concentratedBufferLabel, sourceLabelsToAmountRules, bufferLabelSamplePrimitives, samplesOutStorageCondition,
		preparation, containerOutLabel, resolvedDestWell, sampleOutLabel, destLabelToStorageConditionRules,
		expandedSamplesOutStorageCondition, sampleOutLabelReplaceRules, sampleOutLabelsForTransfer,
		samplesInStorageCondition, safeOps, cache, resolvedContainerOut, containerOutModels, containerOutObjs,
		containerOutPackets, containerOutModelPackets, resolvedContainerOutWithPacket, simulation,
		resolvedAssayVolume, resolvedAmount, transferPrimitives, resolvedAmountNoAll, sourceLabel,
		destinationAndWellToVolumeRules, totalVolumeToEachDestRules, destinationAndWellToBufferVolumeRules,
		bufferVolumeToEachDestRules, mixPrimitives, allPrimitives, sourceContainerLabel, resolvedPreparatoryUnitOperations,
		poolingShapes, sampleContainerPackets, labelSamplePrimitives, labelDestinationContainerPrimitives,
		labelSampleUOToPrepend, sampleToLabelRules, updatedSimulation},

	(* get the cache to grab the packets *)
	safeOps = SafeOptions[convertTransferStepsToPrimitives, ToList[ops]];
	cache = Lookup[safeOps, Cache];
	simulation = Lookup[safeOps, Simulation];

	(* pull out relevant values from the resolved options *)
	{
		resolvedAmount,
		resolvedAssayVolume,
		resolvedAssayBuffer,
		resolvedBufferDiluent,
		resolvedConcentratedBuffer,
		sourceLabel,
		sourceContainerLabel,
		assayBufferLabel,
		bufferDiluentLabel,
		concentratedBufferLabel,
		containerOutLabel,
		sampleOutLabel,
		samplesInStorageCondition,
		samplesOutStorageCondition,
		preparation,
		(* note that this is the DestinationWell option, which is different from myDestWells because the index matching is different *)
		resolvedDestWell,
		resolvedContainerOut,
		resolvedPreparatoryUnitOperations
	} = Lookup[
		myResolvedOptions,
		{
			Amount,
			AssayVolume,
			AssayBuffer,
			BufferDiluent,
			ConcentratedBuffer,
			SourceLabel,
			SourceContainerLabel,
			AssayBufferLabel,
			BufferDiluentLabel,
			ConcentratedBufferLabel,
			ContainerOutLabel,
			SampleOutLabel,
			SamplesInStorageCondition,
			SamplesOutStorageCondition,
			Preparation,
			DestinationWell,
			ContainerOut,
			PreparatoryUnitOperations
		}
	];

	(* get the LabelSample unit operation we're going to be using here *)
	labelSampleUOToPrepend = If[MatchQ[resolvedPreparatoryUnitOperations, {_[_LabelSample]}],
		resolvedPreparatoryUnitOperations[[1, 1]],
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

	(* get the shape of the sample inputs *)
	poolingShapes = Length[#]& /@ mySamplePackets;
	sampleContainerPackets = TakeList[fetchPacketFromCache[#, cache]& /@ Lookup[Flatten[mySamplePackets], Container, {}], poolingShapes];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[resolvedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[resolvedContainerOut]], ObjectP[Object[Container]]];

	(* get the ContainerOut object and model packets (these two don't have to be the same length) *)
	containerOutPackets = fetchPacketFromCache[#, cache]& /@ containerOutObjs;
	containerOutModelPackets = Flatten[{
		fetchPacketFromCache[#, cache]& /@ containerOutModels,
		fetchPacketFromCache[#, cache]& /@ Lookup[containerOutPackets, Model, {}]
	}];

	(* get the resolved container out with packets instead of objects *)
	resolvedContainerOutWithPacket = Map[
		Function[{indexAndContainer},
			{indexAndContainer[[1]], SelectFirst[Flatten[{containerOutPackets, containerOutModelPackets}], MatchQ[#, ObjectP[indexAndContainer[[2]]]]&]}
		],
		resolvedContainerOut
	];

	(* make the LabelSample primitives for the input samples and the destinations *)
	(* note that if this label is already taken by the PreparatoryUnitOperation UnitOperation above, then don't put it in here *)
	labelSamplePrimitives = DeleteDuplicates[Flatten[MapThread[
		Function[{samplePacketsInPool, sampleContainerPacketsInPool, sampleLabelsInPool, sampleContainerLabelsInPool},
			MapThread[
				If[StringQ[#3] && StringQ[#4] && Not[MemberQ[Values[sampleToLabelRules], #3]],
					LabelSample[Sample -> Lookup[#1, Object], Container -> Lookup[#2, Object], Label -> #3, ContainerLabel -> #4],
					Nothing
				]&,
				{samplePacketsInPool, sampleContainerPacketsInPool, sampleLabelsInPool, sampleContainerLabelsInPool}
			]
		],
		{mySamplePackets, sampleContainerPackets, sourceLabel, sourceContainerLabel}
	]]];
	(* create the define primitives for the destinations *)
	labelDestinationContainerPrimitives = DeleteDuplicates[MapThread[
		LabelContainer[Container -> Lookup[#[[2]], Object], Label -> #2]&,
		{resolvedContainerOutWithPacket, containerOutLabel}
	]];

	(* make replace rules converting labels into the amounts that are being transferred from them *)
	sourceLabelsToAmountRules = Merge[
		MapThread[
			#1 -> #2&,
			{mySourcesToTransfer, myAmountsToTransfer}
		],
		Total
	];

	(* make the LabelSample primitives for all AssayBuffers, BufferDiluents, and ConcentratedBuffers *)
	bufferLabelSamplePrimitives = DeleteDuplicates[MapThread[
		(* if we're not actually transferring the buffer because we have 0L of it, then don't actually make a LabelSample primitive for it *)
		If[Not[MemberQ[mySourcesToTransfer, #2]],
			Nothing,
			LabelSample[
				Sample -> #1,
				Label -> #2,
				Amount -> (#2 /. sourceLabelsToAmountRules) * 1.1,
				Container -> If[MatchQ[#1, ObjectP[Model]], PreferredContainer[(#2 /. sourceLabelsToAmountRules) * 1.1], Automatic],
				ContainerLabel -> If[MatchQ[#2, _String], StringJoin["Container of ", #2], Automatic]
			]
		]&,
		{
			Cases[Flatten[{resolvedAssayBuffer, resolvedBufferDiluent, resolvedConcentratedBuffer}], ObjectP[]],
			Cases[Flatten[{assayBufferLabel, bufferDiluentLabel, concentratedBufferLabel}], _String]
		}
	]];

	(* make the expanded samples out storage condition; note that to do this, we need to make replace rules converting the destination labels to the given storage condition *)
	destLabelToStorageConditionRules = MapThread[
		{#1, #2} -> #3&,
		{containerOutLabel, resolvedDestWell, samplesOutStorageCondition}
	];
	expandedSamplesOutStorageCondition = MapThread[
		Replace[{#1, #2}, destLabelToStorageConditionRules, {0}]&,
		{myDestsToTransferTo, myDestWells}
	];

	(* make replace rules converting ContainerOutLabel + DestinationWell pairs into the SampleOutLabel *)
	sampleOutLabelReplaceRules = MapThread[
		{#1, #2} -> #3&,
		{containerOutLabel, resolvedDestWell, sampleOutLabel}
	];
	sampleOutLabelsForTransfer = Transpose[{myDestsToTransferTo, myDestWells}] /. sampleOutLabelReplaceRules;

	(* make the big Transfer primitive that has everything we want to do in the proper order in it *)
	transferPrimitives = If[MatchQ[preparation, Manual],
		{
			Transfer[
				Source -> mySourcesToTransfer,
				Destination -> myDestsToTransferTo,
				DestinationWell -> myDestWells,
				Amount -> myAmountsToTransfer,
				(* in case something didn't get labeled (and so is still a list) then set those to Null*)
				DestinationLabel -> Replace[sampleOutLabelsForTransfer, _List :> Null, {1}],

				SamplesInStorageCondition -> samplesInStorageCondition,
				SamplesOutStorageCondition -> expandedSamplesOutStorageCondition,

				DispenseMix -> True,

				(* Make the post-processing options Automatic so that it can resolve based on sample's living/sterile properties *)
				ImageSample -> Automatic,
				MeasureVolume -> Automatic,
				MeasureWeight -> Automatic
			]
		},
		{
			Transfer[
				Source -> mySourcesToTransfer,
				Destination -> myDestsToTransferTo,
				DestinationWell -> myDestWells,
				Amount -> myAmountsToTransfer,
				(* in case something didn't get labeled (and so is still a list) then set those to Null*)
				DestinationLabel -> Replace[sampleOutLabelsForTransfer, _List :> Null, {1}],
				SamplesInStorageCondition -> samplesInStorageCondition,
				SamplesOutStorageCondition -> expandedSamplesOutStorageCondition,
				(* Make the post-processing options Automatic so that it can resolve based on sample's living/sterile properties *)
				ImageSample -> Automatic,
				MeasureVolume -> Automatic,
				MeasureWeight -> Automatic
			]
		}
	];

	(* get amount with no All *)
	resolvedAmountNoAll = MapThread[
		Function[{samplePacketsInPool, amountsInPool},
			MapThread[
				If[MatchQ[#2, All],
					Lookup[#1, Volume],
					#2
				]&,
				{samplePacketsInPool, amountsInPool}
			]
		],
		{mySamplePackets, resolvedAmount}
	];

	(* get the total volume going into each destination/well pair *)
	destinationAndWellToVolumeRules = MapThread[
		{#1, #2} -> #3&,
		{containerOutLabel, resolvedDestWell, resolvedAssayVolume}
	];
	totalVolumeToEachDestRules = Merge[destinationAndWellToVolumeRules, Total];

	(* get the volume of buffer going into each destination/well pair*)
	destinationAndWellToBufferVolumeRules = MapThread[
		{#1, #2} -> (#3 - Total[Cases[#4, VolumeP]])&,
		{containerOutLabel, resolvedDestWell, resolvedAssayVolume, resolvedAmountNoAll}
	];
	bufferVolumeToEachDestRules = Merge[destinationAndWellToBufferVolumeRules, Total];

	(* make the mix primitives *)
	mixPrimitives = Flatten[MapThread[
		Function[{destLabel, destWell, destSampleLabel},
			If[MatchQ[preparation, Robotic] && VolumeQ[{destLabel, destWell} /. destinationAndWellToVolumeRules],
				Mix[Sample -> destSampleLabel, MixType -> Pipette, MixVolume -> Max[Min[({destLabel, destWell} /. destinationAndWellToVolumeRules) / 2, 970*Microliter], 1*Microliter], NumberOfMixes -> 10],
				Nothing
			]
		],
		{containerOutLabel, resolvedDestWell, sampleOutLabel}
	]];

	(* put all the primitives for the ExperimentSamplePreparation call *)
	(* if we're doing a preparatory unit operation model input, we need to remove the simulated IDs here and replace them with the labels in question *)
	allPrimitives = ReplaceAll[
		Flatten[{
			If[NullQ[labelSampleUOToPrepend], Nothing, labelSampleUOToPrepend],
			labelSamplePrimitives,
			labelDestinationContainerPrimitives,
			bufferLabelSamplePrimitives,
			transferPrimitives,
			mixPrimitives
		}],
		sampleToLabelRules
	];

	(* return the updated simulation too with the labels we replaced above removed *)
	{allPrimitives, updatedSimulation}

];

(* ::Subsubsection::Closed:: *)
(*convertAliquotToTransferSteps*)

DefineOptions[convertAliquotToTransferSteps,
	Options :> {
		{Label -> False, BooleanP, "Indicates if the inputs to Transfer should be given with labels in place of objects or not."}
	}
];


(* helper function that takes in the input sample (packets) and resolved options of ExperimentAliquot, and returns a list of four things: the sources, the destinations, the destination wells, and the amounts to transfer in an ExperimentTransfer call *)
(* note that the resolved options must contain the hidden options as well, most notably the label options.  Also they cannot be collapsed *)
(* probably want to provide mySamplePackets as the pooled format as a list of lists since myResolvedOptions needs that anyway *)
(* but if you don't provide it as a list of lists I will make it so *)
convertAliquotToTransferSteps[mySamplePackets:{ListableP[PacketP[Object[Sample]]]..}, myResolvedOptions:{_Rule...}, ops:OptionsPattern[convertAliquotToTransferSteps]]:=Module[
	{listedSamplePackets, resolvedAssayBuffer, resolvedConcentratedBuffer, resolvedBufferDiluent,
		resolvedBufferDilutionFactor, resolvedDestWells, resolvedContainerOut, resolvedAmount, allSamplesToTransfer,
		destinationsToTransferTo, destinationWellsToTransferTo, resolvedAmountNoAll, resolvedAssayVolume,
		assayBufferVolume, assayBufferSourceDestWellTrio, assayBufferToTransfer, assayBufferDestination,
		assayBufferDestWell, concBufferAndBufferDiluentVolumes, concBufferAndBufferDiluentSourceDestWellTrio,
		concBufferAndBufferDiluentToTransfer, concBufferAndBufferDiluentDestination, concBufferAndBufferDiluentDestWell,
		amountsToTransfer, safeOps, labelQ, sourceLabels, sourceContainerLabels, containerOutLabels, assayBufferLabels,
		concBufferLabels, bufferDiluentLabels, sourceLabelReplaceRules, sourceContainerLabelReplaceRules,
		containerOutLabelReplaceRules, assayBufferLabelReplaceRules, concBufferLabelReplaceRules,
		bufferDiluentLabelReplaceRules, resolvedConsolidateAliquots, nonzeroSamplesToTransfer,
		nonzeroDestsToTransferTo, nonzeroDestWellsToTransferTo, nonzeroAmountsToTransfer,
		sourceDestAndWellsToAmountRules, specifiedPreparation, consolidatedSourceSamplesToTransfer,
		consolidatedDestSamplesToTransfer, consolidatedDestWellsToTransferTo, consolidatedAmountsToTransfer,
		splitSourceSamples, splitDestSamples, splitDestWells, splitAmountsToTransfer, splitOptions
	},

	(* get the Label option of the function *)
	safeOps = SafeOptions[convertAliquotToTransferSteps, ToList[ops]];
	labelQ = Lookup[safeOps, Label];

	(* in case we don't have a list of lists at this point, do it *)
	listedSamplePackets = ToList /@ mySamplePackets;

	(* pull out the relevant resolved options that we will need shortly *)
	{
		resolvedAssayBuffer,
		resolvedConcentratedBuffer,
		resolvedBufferDiluent,
		resolvedBufferDilutionFactor,
		resolvedDestWells,
		resolvedContainerOut,
		resolvedAmount,
		resolvedAssayVolume,
		resolvedConsolidateAliquots,
		specifiedPreparation
	} = Lookup[
		myResolvedOptions,
		{
			AssayBuffer,
			ConcentratedBuffer,
			BufferDiluent,
			BufferDilutionFactor,
			DestinationWell,
			ContainerOut,
			Amount,
			AssayVolume,
			ConsolidateAliquots,
			Preparation
		}
	];

	(* pull out the relevant label options *)
	{
		sourceLabels,
		sourceContainerLabels,
		containerOutLabels,
		assayBufferLabels,
		concBufferLabels,
		bufferDiluentLabels
	} = Lookup[
		myResolvedOptions,
		{
			SourceLabel,
			SourceContainerLabel,
			ContainerOutLabel,
			AssayBufferLabel,
			ConcentratedBufferLabel,
			BufferDiluentLabel
		}
	];

	(* make replace rules converting the option values to their labels *)
	sourceLabelReplaceRules = DeleteDuplicates[Flatten[MapThread[
		Function[{sourcePacketsInLoop, sourceLabelsInLoop},
			MapThread[
				Lookup[#1, Object] -> #2&,
				{sourcePacketsInLoop, sourceLabelsInLoop}
			]
		],
		{listedSamplePackets, sourceLabels}
	]]];
	sourceContainerLabelReplaceRules = DeleteDuplicates[Flatten[MapThread[
		Function[{sourcePacketsInLoop, sourceContainerLabelsInLoop},
			MapThread[
				Download[Lookup[#1, Container], Object] -> #2 &,
				{sourcePacketsInLoop, sourceContainerLabelsInLoop}
			]
		],
		{listedSamplePackets, sourceContainerLabels}
	]]];
	containerOutLabelReplaceRules = DeleteDuplicates[MapThread[#1 -> #2&, {resolvedContainerOut, containerOutLabels}]];
	assayBufferLabelReplaceRules = DeleteDuplicates[MapThread[#1 -> #2&, {resolvedAssayBuffer, assayBufferLabels}]];
	concBufferLabelReplaceRules = DeleteDuplicates[MapThread[#1 -> #2&, {resolvedConcentratedBuffer, concBufferLabels}]];
	bufferDiluentLabelReplaceRules = DeleteDuplicates[MapThread[#1 -> #2&, {resolvedBufferDiluent, bufferDiluentLabels}]];


	(* get the Amount option without any Alls (which convert into the volume, or Null if there is no volume) *)
	resolvedAmountNoAll = MapThread[
		Function[{samplePacketsInPool, amountsInPool},
			MapThread[
				If[MatchQ[#2, All],
					Lookup[#1, Volume],
					#2
				]&,
				{samplePacketsInPool, amountsInPool}
			]
		],
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
		{resolvedAssayVolume, resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedAmountNoAll}
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
		{resolvedAssayVolume, resolvedConcentratedBuffer, resolvedBufferDiluent, resolvedContainerOut, resolvedDestWells}
	];
	{
		concBufferAndBufferDiluentToTransfer,
		concBufferAndBufferDiluentDestination,
		concBufferAndBufferDiluentDestWell
	} = If[MatchQ[concBufferAndBufferDiluentSourceDestWellTrio, {}],
		{{}, {}, {}},
		Transpose[concBufferAndBufferDiluentSourceDestWellTrio]
	];

	(* --- get all the amounts for AssayBuffer ---*)

	(* get the volume of AssayBuffer to be transferred *)
	assayBufferVolume = MapThread[
		Function[{assayVolume, amountsInPool, assayBuffer},
			(* if we don't have an assay buffer then obviously nothing here *)
			If[NullQ[assayBuffer] || NullQ[assayVolume],
				Nothing,
				assayVolume - Total[Cases[amountsInPool, VolumeP]]
			]
		],
		{resolvedAssayVolume, resolvedAmountNoAll, resolvedAssayBuffer}
	];

	(* get the source/destination/destination well trio to be transferred, then split it out *)
	assayBufferSourceDestWellTrio = MapThread[
		Function[{assayVolume, assayBuffer, containerOut, destWell},
			(* if we don't have an assay buffer then obviously nothing here *)
			If[NullQ[assayBuffer] || NullQ[assayVolume],
				Nothing,
				{assayBuffer, containerOut, destWell}
			]
		],
		{resolvedAssayVolume, resolvedAssayBuffer, resolvedContainerOut, resolvedDestWells}
	];
	{
		assayBufferToTransfer,
		assayBufferDestination,
		assayBufferDestWell
	} = If[MatchQ[assayBufferSourceDestWellTrio, {}],
		{{}, {}, {}},
		Transpose[assayBufferSourceDestWellTrio]
	];

	(* get everything that needs to be transferred put together in the order they will be added.  This means ConcentratedBuffer + BufferDiluent to everything (in pairs), then AssayBuffer to everything, then samples to everything *)
	(* if we want to return labels, do that *)
	allSamplesToTransfer = Flatten[{
		concBufferAndBufferDiluentToTransfer /. If[labelQ, Join[concBufferLabelReplaceRules, bufferDiluentLabelReplaceRules], {}],
		assayBufferToTransfer /. If[labelQ, assayBufferLabelReplaceRules, {}],
		Lookup[Flatten[listedSamplePackets], Object] /. If[labelQ, sourceLabelReplaceRules, {}]
	}];

	(* get the destinations to transfer to *)
	(* these are the same for each value; just need to be careful when it comes to the samples because multiple pooled things go into the same container *)
	(* need to use Join and not Flatten because ContainerOut is a paired list at this point *)
	(* if we want to return labels, do that *)
	destinationsToTransferTo = Join[
		(* again need to be in pairs because the concentrated buffer and buffer diluent are paired together *)
		Join @@ concBufferAndBufferDiluentDestination,
		assayBufferDestination,
		Join @@ MapThread[
			ConstantArray[#2, Length[#1]]&,
			{listedSamplePackets, resolvedContainerOut}
		]
	] /. If[labelQ, containerOutLabelReplaceRules, {}];

	(* put the destination wells together *)
	destinationWellsToTransferTo = Flatten[{
		concBufferAndBufferDiluentDestWell,
		assayBufferDestWell,
		MapThread[
			ConstantArray[#2, Length[#1]]&,
			{listedSamplePackets, resolvedDestWells}
		]
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
			{resolvedAssayVolume, resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedAmountNoAll}
		],
		(* for AssayBuffer it's easy enough: it's just the difference between the AssayVolume and the resolved Amount *)
		MapThread[
			Function[{assayVolume, amountsInPool, assayBuffer},
				(* if we don't have an assay buffer then obviously nothing here *)
				Which[
					NullQ[assayBuffer], Nothing,
					NullQ[assayVolume], 0 Liter,
					True, assayVolume - Total[Cases[amountsInPool, VolumeP]]
				]
			],
			{resolvedAssayVolume, resolvedAmountNoAll, resolvedAssayBuffer}
		],
		resolvedAmountNoAll
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

	(* get the samples/destinations/destination wells/amounts; combine to a single well if ConsolidateAliquots is True *)
	{
		consolidatedSourceSamplesToTransfer,
		consolidatedDestSamplesToTransfer,
		consolidatedDestWellsToTransferTo,
		consolidatedAmountsToTransfer
	} = If[TrueQ[resolvedConsolidateAliquots],
		{
			Keys[sourceDestAndWellsToAmountRules][[All, 1]],
			Keys[sourceDestAndWellsToAmountRules][[All, 2]],
			Keys[sourceDestAndWellsToAmountRules][[All, 3]],
			Values[sourceDestAndWellsToAmountRules]
		},
		{
			nonzeroSamplesToTransfer,
			nonzeroDestsToTransferTo,
			nonzeroDestWellsToTransferTo,
			nonzeroAmountsToTransfer
		}
	];



	(* split the sources, destinations, destination wells, and amounts by 970 Microliter *)
	(* if Preparation -> Manual, just stick with what we have.  If we have Automatic, split into 970 uL or less transfers because robot can't do more than that *)
	(* also solid transfers are always manual *)
	{
		splitSourceSamples,
		splitDestSamples,
		splitAmountsToTransfer,
		splitOptions
	} = If[!MatchQ[consolidatedSourceSamplesToTransfer,{}]&&!MatchQ[consolidatedDestSamplesToTransfer,{}]&&!MatchQ[consolidatedAmountsToTransfer,{}],
		splitTransfersBy970[
			consolidatedSourceSamplesToTransfer,
			consolidatedDestSamplesToTransfer,
			consolidatedAmountsToTransfer,
			DestinationWell -> consolidatedDestWellsToTransferTo,
			Preparation -> specifiedPreparation
		],
		ConstantArray[{},4]
	];
	splitDestWells = Lookup[splitOptions, DestinationWell];


	{
		splitSourceSamples,
		splitDestSamples,
		splitDestWells,
		splitAmountsToTransfer
	}

];

(* spilt a volume above 970 into volumes below it.  Try to make them equal (so 1000 uL will be split into two 500 uL, not a 970 uL and a 30 uL) *)
splitVolumesBy970[myVolume:VolumeP]:=Module[{quotientRemainder},

	quotientRemainder = QuotientRemainder[myVolume, 970 Microliter];

	If[MatchQ[quotientRemainder[[2]], EqualP[0 Liter]],
		ConstantArray[970 Microliter, quotientRemainder[[1]]],
		ConstantArray[RoundOptionPrecision[(myVolume/(quotientRemainder[[1]]+1)), 10^-1 Microliter, Round -> Down, AvoidZero -> True],(quotientRemainder[[1]]+1)]
	]
];
splitVolumesBy970[myVolumes:{VolumeP..}]:= splitVolumesBy970[#]& /@ myVolumes;

(* mySourceSamples and myDestinations are just {__} because they could be a lot of things and don't want to bother enumerating them here *)
splitTransfersBy970[mySourceSamples : {__}, myDestinations : {__}, myAmountsToTransfer : {UnitsP[]..}, ops : OptionsPattern[ExperimentTransfer]] := Module[
	{quotientRemainders, preparation, mapThreadedOptions, splitOptions, splitSourceSamples, splitDestSamples,
		splitAmountsToTransfer, opsAssoc, transferOptionDefs, unsplitOptions},

	(* get the quotient/remainder of every transfer amount when dividing by 970uL (so if we have 2000 uL, it will give me {2, 60 Microliter}, meaning we have 2 transfers of 970 uL, and a third of 60 uL)  *)
	quotientRemainders = QuotientRemainder[myAmountsToTransfer, 970 Microliter];

	(* make the input ops an association*)
	opsAssoc = Association[ops];

	(* figure out if we're doing Preparation -> Robotic | Manual.  If Manual, don't do anything.  Assume Robotic if not specified though because probably not bothering to call this function if Manual *)
	preparation = Lookup[opsAssoc, Preparation, Robotic];

	(* MapThread the options *)
	mapThreadedOptions = If[MatchQ[opsAssoc, <||>],
		{},
		OptionsHandling`Private`mapThreadOptions[ExperimentTransfer, opsAssoc]
	];

	(* split the sources, destinations, amounts, and options by 970 Microliter *)
	{
		splitSourceSamples,
		splitDestSamples,
		splitAmountsToTransfer,
		splitOptions
	} = If[MatchQ[preparation, Manual] || Not[MatchQ[myAmountsToTransfer, {VolumeP..}]],
		{
			mySourceSamples,
			myDestinations,
			myAmountsToTransfer,
			mapThreadedOptions
		},
		{
			Join @@ MapThread[
				If[MatchQ[#2[[2]], EqualP[0 Liter]],
					ConstantArray[#1, #2[[1]]],
					ConstantArray[#1, #2[[1]] + 1]
				]&,
				{mySourceSamples, quotientRemainders}
			],
			Join @@ MapThread[
				If[MatchQ[#2[[2]], EqualP[0 Liter]],
					ConstantArray[#1, #2[[1]]],
					ConstantArray[#1, #2[[1]] + 1]
				]&,
				{myDestinations, quotientRemainders}
			],
			Join @@ splitVolumesBy970[myAmountsToTransfer],
			If[MatchQ[mapThreadedOptions, {}],
				{},
				Join @@ MapThread[
					If[MatchQ[#2[[2]], EqualP[0 Liter]],
						ConstantArray[#1, #2[[1]]],
						ConstantArray[#1, #2[[1]] + 1]
					]&,
					{mapThreadedOptions, quotientRemainders}
				]
			]
		}
	];

	(* get the option definitions of ExperimentTransfer *)
	transferOptionDefs = OptionDefinition[ExperimentTransfer];

	(* re-combine the options together *)
	(* be careful with index matching options vs just non-index-matching *)
	unsplitOptions = KeyValueMap[
		Function[{option, value},
			Module[{optionDef, indexMatchingQ},
				optionDef = SelectFirst[transferOptionDefs, MatchQ[Lookup[#, "OptionName"], ToString[option]]&];
				indexMatchingQ = Not[MatchQ[Lookup[optionDef, "IndexMatching"], "None" | _?MissingQ]];

				If[indexMatchingQ,
					option -> Lookup[splitOptions, option],
					option -> value
				]
			]
		],
		opsAssoc
	];

	(* return the split sources, destinations, amounts, and options *)
	{
		splitSourceSamples,
		splitDestSamples,
		splitAmountsToTransfer,
		unsplitOptions
	}


];

(* ::Subsubsection::Closed:: *)
(* resolveAliquotMethod *)

DefineOptions[resolveAliquotMethod,
	SharedOptions:>{
		ExperimentAliquot,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveAliquotMethod[mySamples:ObjectP[{Object[Sample], Object[Container]}] | {ListableP[ObjectP[{Object[Sample], Object[Container]}]]..}, myOptions:OptionsPattern[]]:=Module[
	{specifiedOptions, resolvedOptions, outputSpecification, methodResolutionOptions, method},

	(* get the output specification *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];

	(* get the options that were provided *)
	specifiedOptions = ToList[myOptions];

	(* replace the options with Output -> Options and ResolveMethod -> True *)
	methodResolutionOptions = ReplaceRule[specifiedOptions, {Output -> Options, ResolveMethod -> True}];

	(* get the resolved options, and whether we're Robotic or Manual *)
	resolvedOptions = ExperimentAliquot[mySamples, methodResolutionOptions];
	method = Lookup[resolvedOptions, Preparation];

	outputSpecification /. {Result -> method, Tests -> {}, Preview -> Null, Options -> methodResolutionOptions}

];

(* ::Subsection:: *)
(*resolveAliquotWorkCell*)

DefineOptions[resolveAliquotWorkCell,
	SharedOptions :> {
		ExperimentAliquot,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

resolveAliquotWorkCell[
	mySamples:ObjectP[{Object[Sample], Object[Container], Model[Sample]}] | {ListableP[ObjectP[{Object[Sample], Object[Container], Model[Sample]}]]..},
	myOptions:OptionsPattern[]
] := Module[
	{safeOptions, cache, simulation, workCell, preparation},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveAliquotWorkCell, ToList[myOptions]];
	{cache, simulation, workCell, preparation} = Lookup[safeOptions, {Cache, Simulation, WorkCell, Preparation}];

	(* Determine the WorkCell that can be used *)
	If[MatchQ[workCell, WorkCellP|Null],
		(* If WorkCell is specified, use that *)
		{workCell}/.{Null} -> {},
		(* Otherwise, use helper function to resolve potential work cells based on experiment options and sample properties *)
		(* Note: there is no Sterile or SterileTechnique for ExperimentAliquot *)
		resolvePotentialWorkCells[Flatten[{mySamples}], {Preparation -> preparation}, Cache -> cache, Simulation -> simulation]
	]
];

(* ::Subsubsection::Closed:: *)
(*resolveExperimentAliquotOptions *)


DefineOptions[resolveExperimentAliquotOptions,
	Options :> {
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

(* private function to resolve all the options *)
resolveExperimentAliquotOptions[mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveExperimentAliquotOptions]]:=Module[
	{outputSpecification, safePooledOptions, pooledInputs, output, gatherTests, messages, inheritedCache, specifiedConcentratedBuffer, specifiedAssayBuffer,
		specifiedBufferDiluent, specifiedContainerOut, allBufferModels, allBufferObjs, containerOutModels,
		containerOutObjs, samplePackets, sampleModelPackets, sampleContainerPackets,
		sampleContainerModelPackets, bufferObjectPackets, bufferModelPackets, bufferContainerPackets,
		bufferContainerModelPackets, containerOutPackets, containerOutModelPackets,
		samplePacketsToCheckIfDiscarded, discardedSamplePackets, discardedInvalidInputs, discardedTest,
		modelPacketsToCheckIfDeprecated, deprecatedModelPackets, deprecatedInvalidInputs, deprecatedTest,
		unknownAmountWarnings, roundedOptionsAssoc, precisionTests, name, validNameQ, nameInvalidOptions,
		validNameTest,missingMolecularWeightErrors,stateAmountMismatchErrors, targetConcNotUsedWarnings,
		bufferDilutionInvalidTest, overspecifiedBufferInvalidOptions, overspecifiedBufferInvalidTest,
		notEmptyContainersOut, emptyContainerInvalidOptions, emptyContainerTests, mapThreadFriendlyOptions,
		resolvedTargetConcentration, resolvedAmount,validMinAmountBoolLists, flatMinAmountBools, minsValid , resolvedAssayVolume, cannotResolveAmountErrors,
		aliquotVolumeTooLargeErrors, noConcentrationErrors, targetConcentrationTooLargeErrors,
		concentrationRatioMismatchErrors, samplesOutStorageCondition, consolidateAliquots, cannotResolveVolumeInvalidInputs,
		cannotResolveVolumeTests, aliquotVolumeTooLargeSamples, aliquotVolumeTooLargeVolume,
		aliquotVolumeTooLargeAssayVolume, aliquotVolumeToolargeOptions, aliquotVolumeTooLargeTest, concMismatchAnalyte,
		targetConcentrationTooLargeOptions, targetConcentrationTooLargeTest, concMismatchSamples, concMismatchAmount,
		concMismatchAssayVolume, concMismatchTargetConc, concMismatchSampleConc, concentrationRatioMismatchOptions,
		concentrationRatioMismatchTest, aliquotToVolumeRules, totalAliquotVolumePerSampleRules,
		totalAliquotVolumeTooLargeValues, totalAliquotVolumeTooLargeSamples, totalAliquotVolumeTooLargeVolumes,
		totalAliquotVolumeTooLargeTest, noConcentrationOptions, noConcentrationTest, targetConcentrationTooLargeSamples,
		targetConcentrationTooLargeTargetConc, targetConcentrationTooLargeSampleConc, fakeAmounts, fakeAssayVolumes,
		indexedContainerOut, specifiedIntegerIndices, samplesVolumeContainerTuples, invalidMinTest, invalidMinOptions,
		groupedSamplesVolumeContainerTuples, positionsOfGroupings, preResolvedGroupContainerOut, reorderingReplaceRules,
		preResolvedContainerOut, nonConsolidatedAliquotsNoVesselAutomatics, preResolvedContainerOutWithPackets,
		maxNumWells, numWells, groupedPreResolvedContainerOut, positionsOfPreResolvedContainerOut,
		groupedResolvedContainerOut, resolvedContainerOutReplaceRules, resolvedContainerOutWithUniques,
		uniqueUniques, uniqueIntegers, integersToDrawFrom, integersWithIntegersRemoved, integersForOldUniques,
		uniqueToIntegerReplaceRules, resolvedContainerOut, preferredVesselContainerModels, preferredVesselPackets,
		couldBeMicroQ, consolidatedAssayVolume, consolidatedAmount, resolvedPostProcessingOptions,
		preparation, allowedWorkCells, workCell, preparationInvalidOptions, preparationInvalidTest, allIncompatibleMaterials,
		resolvedContainerOutGroupedByIndex, numContainersPerIndex, invalidContainerOutSpecs,
		containerOutMismatchedIndexOptions, containerOutMismatchedIndexTest, numReservedWellsPerIndex,
		numWellsPerContainerRules, numWellsAvailablePerIndex, overOccupiedContainerOutBool, overOccupiedContainerOut,
		overOccupiedAvailableWells, overOccupiedReservedWells, containerOverOccupiedOptions, containerOverOccupiedTest,
		destinationContainerModelPackets, maxVolumes, allWellsForContainerOut, allOpenWellsForContainerOut,
		containerMaxVolumeAssayVolumes, containerMaxVolumeAssayVolumesGroupedByIndex, totalVolumeEachIndex,
		maxVolumeEachIndex, tooMuchVolumeQ, volumeTooHighContainerOut, volumeTooHighAssayVolume, volumeTooHighMaxVolume,
		volumeOverContainerMaxOptions, volumeOverContainerMaxTest, invalidOptions, invalidInputs, allTests, confirm, canaryBranch,
		template, samplesInStorageCondition, cache, fastTrack, operator, parentProtocol, upload, outputOption, email,
		resolvedOptions, testsRule, resultRule, resolvedAssayBuffer,
		resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedBufferDiluent, bufferDilutionMismatchErrors,
		overspecifiedBufferErrors, bufferDilutionMismatchSamples, bufferDilutionMismatchOptions,
		overspecifiedBufferSamples, safeOptions, talliesAndPackets, talliedPackets, tallies, maxResolvedAmountRules,
		maxVolumePerSampleFromContainerOut, maxResolutionAmountPerSample, samplePrep, bufferSpecifiedNoVolumeWarnings,
		noBufferWithBufferSamples, noBufferWithBufferTest, samplesVolumePreResolvedContainerTuples,
		maxVolumeGroupedByConsolidatedAliquots, openWellsReplaceRules, openWellsPerGrouping,
		groupedDestWells, resolvedDestWells, resolvedDestWellReplaceRules, specifiedDestWells, specifiedDestWellReplaceRules,
		specifiedDestWellsPerGrouping, invalidDestWellBools, invalidDestWellSpecs, invalidDestWellContainerOut,
		invalidDestWellOptions, invalidDestWellTest, noAmountSamples, stateAmountMismatchOptions, stateAmountMismatchTests,
		noMolecularWeightInvalidOptions, noMolecularWeightTests, targetConcNotUsedTests, samplePoolLengths,
		pooledVolumeAboveAssayVolumeErrors, cannotResolveAssayVolumeError, flatSamplePackets, flatAmounts, flatTargetConc,
		unknownAmountWarningTests, pooledVolumeAboveAssayVolumeSamples, pooledVolume, pooledVolumeAboveAssayVolumeVolumes,
		pooledVolumeAboveAssayVolumeAssayVolumes, pooledVolumeAboveAssayVolumeOptions, pooledVolumeAboveAssayVolumeTest,
		cannotResolveAssayVolumeSamples, cannotResolveAssayVolumeOptions, cannotResolveAssayVolumeTest, pooledQ, sterileQ,
		specifiedConsolidateAliquots, pooledConsolidateAliquotsWarning, sampleCompositionPackets, preResolvedAnalyte,
		potentialAnalytesToUseFlat, potentialAnalyteTests, potentialAnalytesToUse, potentialAnalytePackets,
		targetConcentrationTooLargeAnalyte, bufferTooConcentratedErrors, bufferTooConcentratedSamples,
		bufferTooConcentratedBufferDilutionFactors, bufferTooConcentratedAssayVolumes, bufferTooConcentratedOptions,
		bufferTooConcentratedTests, resolvedSampleLabel, resolvedSampleContainerLabel, fastAssoc,
		simulation, resolvedConcentratedBufferLabel, resolvedBufferDiluentLabel, resolvedAssayBufferLabel,
		samplesToTransferNoZeroes, destinationsToTransferToNoZeroes, amountsToTransferNoZeroes, potentialMethods,
		destinationWellsToTransferToNoZeroes, resolvedContainerOutLabel, fakeResolvedOptions, resolvedSampleOutLabel,
		resolveMethod, containerOutLabelReplaceRules, sampleOutLabelReplaceRules, allPotentiallyLabeledSamples,
		allPotentiallyLabeledContainers, sampleLabelReplaceRules, containerLabelReplaceRules, overMaxVolumeErrors,
		overMaxVolumeOptions, overMaxVolumeTests},

	(* --- Setup our user specified options and cache --- *)

	(* need to call SafeOptions; this will ONLY make a difference in the shared resolveAliquotOptions function where it doesn't pass the hidden options down *)
	(* also need to call ExpandIndexMatchedInputs because some options (TargetConcentrationAnalyte at time of writing) aren't in the shared aliquot options, and so don't get expanded in the shared resolveAliquotOptions resolver *)
	safeOptions = Last[ExpandIndexMatchedInputs[ExperimentAliquot, {mySamples}, SafeOptions[ExperimentAliquot, myOptions], 6]];

	(* ToList each of our pooled options. *)
	(* This is so that we can guarantee that our options are in fully pooled form. *)
	safePooledOptions = ReplaceRule[safeOptions,{Amount->(ToList/@Lookup[safeOptions,Amount]),TargetConcentration->(ToList/@Lookup[safeOptions,TargetConcentration]),TargetConcentrationAnalyte->(ToList/@Lookup[safeOptions,TargetConcentrationAnalyte]), SourceLabel -> (ToList /@ Lookup[safeOptions, SourceLabel]), SourceContainerLabel -> (ToList /@ Lookup[safeOptions, SourceContainerLabel])}];

	(* ToList each of our input samples. *)
	pooledInputs=ToList/@mySamples;

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	(* also suppress messages if we are resolving method *)
	gatherTests = MemberQ[output, Tests];
	resolveMethod = Lookup[safeOptions, ResolveMethod];
	messages = Not[gatherTests] && Not[resolveMethod];

	(* pull out the Cache and EnableSamplePreparation options *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	samplePrep = Lookup[safeOptions, EnableSamplePreparation];

	(* pull out the ConcentratedBuffer, AssayBuffer, BufferDiluent, and ContainerOut options *)
	{
		specifiedConcentratedBuffer,
		specifiedAssayBuffer,
		specifiedBufferDiluent,
		specifiedContainerOut,
		specifiedDestWells,
		name,
		samplesOutStorageCondition,
		specifiedConsolidateAliquots,
		fastTrack,
		parentProtocol
	} = Lookup[safePooledOptions, {ConcentratedBuffer, AssayBuffer, BufferDiluent, ContainerOut, DestinationWell, Name, SamplesOutStorageCondition, ConsolidateAliquots, FastTrack, ParentProtocol}];

	(* pull out lots of shared options *)
	{
		confirm,
		canaryBranch,
		template,
		samplesInStorageCondition,
		cache,
		operator,
		upload,
		outputOption
	} = Lookup[
		safePooledOptions,
		{
			Confirm,
			CanaryBranch,
			Template,
			SamplesInStorageCondition,
			Cache,
			Operator,
			Upload,
			Output
		}
	];

	(* make a fast association from the cache *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
	email = Which[
		MatchQ[Lookup[safePooledOptions, Email], Automatic] && NullQ[parentProtocol], True,
		MatchQ[Lookup[safePooledOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[{Object[Protocol], Object[Control], Object[Maintenance]}]], False,
		True, Lookup[safePooledOptions, Email]
	];

	(* get all the buffers that were specified as models and objects *)
	allBufferModels = Cases[Flatten[{specifiedConcentratedBuffer, specifiedAssayBuffer, specifiedBufferDiluent}], ObjectP[Model[Sample]]];
	allBufferObjs = Cases[Flatten[{specifiedConcentratedBuffer, specifiedAssayBuffer, specifiedBufferDiluent}], ObjectP[Object[Sample]]];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[specifiedContainerOut]], ObjectP[Object[Container]]];

	(* if the Container option is Automatic, we might end up calling PreferredContainer; so we've gotta make sure we download info from all the objects it might spit out *)
	preferredVesselContainerModels = If[MatchQ[specifiedContainerOut, Automatic] || MemberQ[Flatten[ToList[specifiedContainerOut]], Automatic],
		DeleteDuplicates[
			Flatten[{
				PreferredContainer[All, Type -> All],
				PreferredContainer[All, Sterile -> True, Type -> All],
				PreferredContainer[All, Sterile -> True, LiquidHandlerCompatible -> True, Type -> All]
			}]
		],
		{}
	];

	(* get the length of each of the sample pools; this is important for splitting the Downloaded values below *)
	samplePoolLengths = Length[#]& /@ pooledInputs;

	(* pull out all the sample/sample model/container/container model packets *)
	samplePackets = TakeList[fetchPacketFromCache[#, inheritedCache]& /@ Download[Flatten[mySamples], Object], samplePoolLengths];
	sampleModelPackets = TakeList[fetchPacketFromCache[#, inheritedCache]& /@ Lookup[Flatten[samplePackets], Model, Null], samplePoolLengths];
	sampleContainerPackets = TakeList[fetchPacketFromCache[#, inheritedCache]& /@ Lookup[Flatten[samplePackets], Container, Null], samplePoolLengths];
	sampleContainerModelPackets = TakeList[fetchPacketFromCache[#, inheritedCache]& /@ Lookup[Flatten[sampleContainerPackets]/.{Null-><||>}, Model, Null], samplePoolLengths];

	(* pull out the sample composition identity model packets *)
	sampleCompositionPackets = Map[
		Function[{samplePacket},
			fetchPacketFromCache[#, inheritedCache]& /@ Lookup[samplePacket, Composition][[All, 2]]
		],
		samplePackets,
		{2}
	];

	(* get all the buffer object/model/container/container model packets *)
	(* note that the bufferObjectPackets and bufferModelPackets don't have to be the same length *)
	bufferObjectPackets = fetchPacketFromCache[#, inheritedCache]& /@ allBufferObjs;
	bufferModelPackets = Flatten[{
		fetchPacketFromCache[#, inheritedCache]& /@ Lookup[bufferObjectPackets, Model, {}],
		fetchPacketFromCache[#, inheritedCache]& /@ allBufferModels
	}];
	bufferContainerPackets = fetchPacketFromCache[#, inheritedCache]& /@ Lookup[bufferObjectPackets, Container, {}];
	bufferContainerModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Lookup[bufferContainerPackets, Model, {}];

	(* get the ContainerOut object and model packets (again like with the buffers, these two don't have to be the same length) *)
	containerOutPackets = fetchPacketFromCache[#, inheritedCache]& /@ containerOutObjs;
	containerOutModelPackets = Flatten[{
		fetchPacketFromCache[#, inheritedCache]& /@ containerOutModels,
		fetchPacketFromCache[#, inheritedCache]& /@ Lookup[containerOutPackets, Model, {}]
	}];

	(* get the packets for the PreferredContainers *)
	preferredVesselPackets = fetchPacketFromCache[#, inheritedCache]& /@ Download[preferredVesselContainerModels, Object];

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

	(* --- Option precision checks --- *)

	(* ensure that the Amount/AssayVolume options have the proper precision *)
	{roundedOptionsAssoc, precisionTests} = If[gatherTests,
		OptionsHandling`Private`roundPooledOptionPrecision[Association[safePooledOptions], {Amount, Amount, AssayVolume}, {10^-1*Microliter, 10^0*Milligram, 10^-1*Microliter}, Output -> {Result, Tests}],
		{OptionsHandling`Private`roundPooledOptionPrecision[Association[safePooledOptions], {Amount, Amount, AssayVolume}, {10^-1*Microliter, 10^0*Milligram, 10^-1*Microliter}], {}}
	];

	(* --- Make sure the Name isn't currently in use --- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		And[
			Not[DatabaseMemberQ[Object[Protocol, ManualSamplePreparation, Lookup[roundedOptionsAssoc, Name]]]],
			Not[DatabaseMemberQ[Object[Protocol, RoboticSamplePreparation, Lookup[roundedOptionsAssoc, Name]]]]
		],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messages,
		(
			Message[Error::DuplicateName, "Robotic or Manual SamplePreparation protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name,_String],
		Test["If specified, Name is not already an Aliquot object name:",
			validNameQ,
			True
		],
		Null
	];

	(* --- Start resolving options for real, first those that do not need to be MapThreaded --- *)

	(* get all the ContainerOut packets that are non-plates and not empty *)
	notEmptyContainersOut = Select[containerOutPackets, MatchQ[#, nonPlateContainerP] && Not[MatchQ[Lookup[#, Contents], {}]]&];

	(* throw a message if some of the specified ContainerOut objects are not empty *)
	emptyContainerInvalidOptions = If[Not[MatchQ[notEmptyContainersOut, {}]] && messages,
		(
			Message[Error::NonEmptyContainers, ObjectToString[notEmptyContainersOut, Cache -> inheritedCache]];
			{ContainerOut}
		),
		{}
	];

	(* make tests for the containers out being empty *)
	emptyContainerTests = If[gatherTests,
		Module[{failingContainers, passingContainers, failingContainerTests, passingContainerTests},

		(* get the failing and passing containers *)
			failingContainers = notEmptyContainersOut;
			passingContainers = Complement[containerOutPackets, notEmptyContainersOut];

			(* create a test for the non-passing containers *)
			failingContainerTests = If[Length[failingContainers] > 0,
				Test["The following directly specified ContainerOut objects are empty:" <> ObjectToString[failingContainers, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing containers *)
			passingContainerTests = If[Length[passingContainers] > 0,
				Test["The following directly specified ContainerOut objects are empty:" <> ObjectToString[passingContainers, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingContainerTests, failingContainerTests}

		],
		{}
	];

	(* need to do some shenanigans for what the Amount/AssayVolume options will resolve to if we have duplicates; obviously don't resolve to the full amount multiple times *)
	(* first, tally the sample packets so we have a handle on how many duplicates we have *)
	talliesAndPackets = Tally[Flatten[samplePackets]];

	(* split the tallies and packets separately *)
	talliedPackets = talliesAndPackets[[All, 1]];
	tallies = talliesAndPackets[[All, 2]];

	(* get the maximum amount the Automatic Amount/AssayVolume can resolve to if neither are specified; this is sure to account for replicates *)
	(* also need to ensure we keep the Count as integers and so we use Round -> Down to make sure that happens  *)
	(* also want to strip off Unit right here *)
	maxResolvedAmountRules = MapThread[
		Which[
			MatchQ[Lookup[#1, Count], GreaterP[0., 1.]], #1 -> Unitless[RoundOptionPrecision[Lookup[#1, Count] / #2, 10^0, Round -> Down], Unit],
			VolumeQ[Lookup[#1, Volume]], #1 -> (Lookup[#1, Volume] / #2),
			MassQ[Lookup[#1, Mass]], #1 -> (Lookup[#1, Mass] / #2),
			True, #1 -> Null
		]&,
		{talliedPackets, tallies}
	];

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
				_, 20*Liter
			]
		],
		{specifiedContainerOut}
	];

	(* get the maximum volume we can resolve to for each sample *)
	(* since we have volumes and masses here at the same time, need to do some shenanigans since Min of a mass and volume together doesn't work *)
	maxResolutionAmountPerSample = MapThread[
		Function[{pooledPackets, maxVolume},
			Map[
				Which[
					NullQ[Replace[#, maxResolvedAmountRules]], Null,
					MatchQ[Replace[#, maxResolvedAmountRules], GreaterP[0., 1.]], Replace[#, maxResolvedAmountRules],
					MassQ[Replace[#, maxResolvedAmountRules]], Replace[#, maxResolvedAmountRules],
					True, Min[{maxVolume, Replace[#1, maxResolvedAmountRules]}]
				]&,
				pooledPackets
			]
		],
		{samplePackets, maxVolumePerSampleFromContainerOut}
	];

	(* --- Resolve the index matched options --- *)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentAliquot, roundedOptionsAssoc];

	(* pre-resolve the TargetConcentrationAnalyte based on what the target concentration is (i.e., set it to Null if the TargetConcentration is Null (or Automatic since Automatic always becomes Null for that option)) *)
	preResolvedAnalyte = MapThread[
		Function[{concs, analytes},
			MapThread[
				If[MatchQ[#1, Null|Automatic] && MatchQ[#2, Automatic],
					Null,
					#2
				]&,
				{concs, analytes}
			]
		],
		{Lookup[mapThreadFriendlyOptions, TargetConcentration], Lookup[mapThreadFriendlyOptions, TargetConcentrationAnalyte]}
	];

	(* decide the potential analyte using selectAnalyteFromSample (this is defined in AbsorbanceSpectroscopy/Experiment.m) *)
	(* need to flatten everything though because pooling; will make correct after *)
	{potentialAnalytesToUseFlat, potentialAnalyteTests} = If[gatherTests,
		selectAnalyteFromSample[Flatten[samplePackets], Analyte -> Flatten[preResolvedAnalyte], Cache -> inheritedCache, DetectionMethod -> Absorbance, Output -> {Result, Tests}],
		{selectAnalyteFromSample[Flatten[samplePackets], Analyte -> Flatten[preResolvedAnalyte], Cache -> inheritedCache, DetectionMethod -> Absorbance, Output -> Result], Null}
	];

	(* make the potential analyte the correct shape *)
	potentialAnalytesToUse = TakeList[potentialAnalytesToUseFlat, Length /@ samplePackets];

	(* get the packet for each of the potential analytes *)
	potentialAnalytePackets = Map[
		Function[{potentialAnalyte},
			SelectFirst[Flatten[sampleCompositionPackets], Not[NullQ[#]] && MatchQ[potentialAnalyte, ObjectReferenceP[Lookup[#, Object]]]&, Null]
		],
		potentialAnalytesToUse,
		{2}
	];

	(* do our big MapThread *)
	{
		resolvedTargetConcentration,
		resolvedAmount,
		validMinAmountBoolLists,
		resolvedAssayVolume,
		resolvedAssayBuffer,
		resolvedConcentratedBuffer,
		resolvedBufferDilutionFactor,
		resolvedBufferDiluent,
		cannotResolveAmountErrors,
		aliquotVolumeTooLargeErrors,
		noConcentrationErrors,
		targetConcentrationTooLargeErrors,
		concentrationRatioMismatchErrors,
		bufferDilutionMismatchErrors,
		overspecifiedBufferErrors,
		bufferSpecifiedNoVolumeWarnings,
		unknownAmountWarnings,
		missingMolecularWeightErrors,
		stateAmountMismatchErrors,
		targetConcNotUsedWarnings,
		pooledVolumeAboveAssayVolumeErrors,
		cannotResolveAssayVolumeError,
		bufferTooConcentratedErrors,
		overMaxVolumeErrors
	} = Transpose[MapThread[
		Function[{pooledSamplePackets, options, maxResolutionAmounts, potentialAnalytes},
			Module[
				{cannotResolveAmountError, aliquotVolumeTooLargeError, noConcentrationError, targetConcentrationTooLargeError,
					concentrationRatioMismatchError, cannotResolveAmountErrorFinal,
					assayVolume, totalSampleVolume, potentialAssayVolumesNoNull, probableAssayVolume,
					specifiedAssayVolume, bufferDilutionMismatchError, overspecifiedBufferError, bufferDilutionFactor,
					bufferDiluent, concentratedBuffer, assayBuffer, bufferSpecifiedNoVolumeWarning, unknownAmountWarning,
					missingMolecularWeightError, targetConcentrations, bufferTooConcentratedError,
					potentialAssayVolume, validMinAmountBools, stateAmountMismatchError, targetConcNotUsedWarning,
					pooledVolumeAboveAssayVolumeError, eitherConcP, dilutionFactors, concBufferPacket, concBufferModelPacket,
					cannotResolveAssayVolumeError, amounts, bufferVolume, concBufferVolume, rawAssayVolume, overMaxVolumeError},

				(* set our error tracking variables *)
				{
					cannotResolveAmountError,
					aliquotVolumeTooLargeError,
					noConcentrationError,
					targetConcentrationTooLargeError,
					concentrationRatioMismatchError,
					bufferDilutionMismatchError,
					overspecifiedBufferError,
					bufferSpecifiedNoVolumeWarning,
					missingMolecularWeightError,
					stateAmountMismatchError,
					targetConcNotUsedWarning,
					pooledVolumeAboveAssayVolumeError,
					cannotResolveAssayVolumeError,
					bufferTooConcentratedError,
					overMaxVolumeError
				} = {
					ConstantArray[False, Length[pooledSamplePackets]],
					ConstantArray[False, Length[pooledSamplePackets]],
					ConstantArray[False, Length[pooledSamplePackets]],
					ConstantArray[False, Length[pooledSamplePackets]],
					False,
					False,
					False,
					False,
					ConstantArray[False, Length[pooledSamplePackets]],
					ConstantArray[False, Length[pooledSamplePackets]],
					ConstantArray[False, Length[pooledSamplePackets]],
					False,
					False,
					False,
					False
				};

				(* pull out the specified AssayVolume value *)
				specifiedAssayVolume = Lookup[options, AssayVolume];

				(* make a pattern that is just the combination of ConcentrationP and MassConcentrationP (since I'll be using it a lot below) *)
				eitherConcP = ConcentrationP|MassConcentrationP;

				(* within each pool, MapThread over everything again *)
				{
					amounts,
					validMinAmountBools,
					potentialAssayVolume,
					targetConcentrations,
					unknownAmountWarning,
					missingMolecularWeightError,
					aliquotVolumeTooLargeError,
					stateAmountMismatchError,
					noConcentrationError,
					targetConcentrationTooLargeError,
					targetConcNotUsedWarning,
					dilutionFactors
				} = Transpose[MapThread[
					Function[
						{samplePacket, amountOption, targetConcOption, maxResolutionAmount, potentialAnalytePacket, sourceLabelOption, sourceContainerLabelOption},
						Module[
							{unknownAmountWarningInsidePool, countQ, solidQ, liquidQ, specifiedAmount,
								targetConcentration, molecularWeight, missingMolecularWeightErrorInsidePool, sampleConc,
								sampleMassConc, sampleVolume, resolvedSampleConc, noConcentrationErrorInsidePool,
								targetConcentrationTooLargeErrorInsidePool, dilutionFactor, badConcQ,
								potentialAssayVolumeInsidePool, potentialAssayVolumeSolidsInsidePool, amount,
								aliquotVolumeTooLargeErrorInsidePool, sampleComposition,
								stateAmountMismatchErrorInsidePool, roundedAmount, validRounding, roundedTargetConcentration,
								roundedAssayVolume, targetConcNotUsedWarningInsidePool, validMinAmount},

							(* set the errors we care abut within this inner MapThread to False to start *)
							{
								unknownAmountWarningInsidePool,
								missingMolecularWeightErrorInsidePool,
								aliquotVolumeTooLargeErrorInsidePool,
								stateAmountMismatchErrorInsidePool
							} = {False, False, False, False};

							(* if Volume, Mass, and Count are all not populated for the sample, flip the switch on unknownAmountWarning *)
							unknownAmountWarningInsidePool = Not[VolumeQ[Lookup[samplePacket, Volume]]] && Not[MassQ[Lookup[samplePacket, Mass]]] && Not[MatchQ[Lookup[samplePacket, Count], GreaterP[0., 1.]]];

							(* figure out if we are dealing with what is _basically_ a solid or a liquid or a counted quantity (could be False for both if unknownAmountWarning is True *)
							countQ = MatchQ[Lookup[samplePacket, Count], GreaterEqualP[0., 1.]];
							liquidQ = VolumeQ[Lookup[samplePacket, Volume]]||MatchQ[Lookup[samplePacket,State],Liquid];
							solidQ = Not[liquidQ] && Not[countQ] && MassQ[Lookup[samplePacket, Mass]];

							(* convert the specified Amount value to not have the Unit unit anymore; that will make things cleaner below *)
							specifiedAmount = If[MatchQ[amountOption, UnitsP[Unit]],
								Unitless[amountOption, Unit],
								amountOption
							];

							(* get the TargetConcentration option; if it is Automatic, resolve to Null *)
							targetConcentration = targetConcOption /. {Automatic -> Null};

							(* flip the TargetConcentrationNotUsed warning switch specifically if TargetConcentration is set and we're using tablets *)
							targetConcNotUsedWarningInsidePool = If[countQ && Not[NullQ[targetConcentration]], True, False];

							(* just pull out MolecularWeight directly.  Note that this could be $Failed because the field doesn't exist for everything *)
							molecularWeight = If[NullQ[potentialAnalytePacket],
								Null,
								Lookup[potentialAnalytePacket, MolecularWeight, Null]
							];

							(* figure out if I need to flip the missingMolecularWeightErrorInsidePool switch *)
							(* essentially, if we have a specified TargetConcentration as a normal Concentration (and not MassConcentration) and it's a solid, must have MolecularWeight *)
							missingMolecularWeightErrorInsidePool = If[ConcentrationQ[targetConcentration] && solidQ,
								Not[MolecularWeightQ[molecularWeight]],
								False
							];

							(* pull out the Composition of the sample packet *)
							sampleComposition = Lookup[samplePacket, Composition, {}];

							(* pull out the concentration and mass concentration of the chosen component from the composition field *)
							sampleConc = If[MatchQ[potentialAnalytePacket, PacketP[]],
								FirstCase[sampleComposition, {conc:ConcentrationP, ObjectP[Lookup[potentialAnalytePacket, Object]], _?DateObjectQ | Null} :> conc, Null],
								Null
							];
							sampleMassConc = If[MatchQ[potentialAnalytePacket, PacketP[]],
								FirstCase[sampleComposition, {massConc:MassConcentrationP, ObjectP[Lookup[potentialAnalytePacket, Object]], _?DateObjectQ | Null} :> massConc, Null],
								Null
							];

							(* get the volume field from the sample directly *)
							sampleVolume = Lookup[samplePacket, Volume];

							(* pick the real concentration we are going to use; should mirror the units of TargetConcentration *)
							resolvedSampleConc = Which[

								(* If we have the same units for our target and the composition, use that unit *)
								ConcentrationQ[targetConcentration]&&ConcentrationQ[sampleConc],sampleConc,
								MassConcentrationQ[targetConcentration]&&MassConcentrationQ[sampleMassConc], sampleMassConc,

								(* If we have concentration target and mass concentration composition, and the molecular weight is known, divide by the molecular weight *)
								ConcentrationQ[targetConcentration]&&MassConcentrationQ[sampleMassConc]&&MolecularWeightQ[molecularWeight],UnitConvert[sampleMassConc/molecularWeight,Molar],

								(* If we have mass concentration target and concentration composition, and the molecular weight is known, multiple by the molecular weight *)
								MassConcentrationQ[targetConcentration]&&ConcentrationQ[sampleConc]&&MolecularWeightQ[molecularWeight],UnitConvert[sampleConc*molecularWeight,Gram/Liter],

								(* Otherwise, return Null *)
								True, Null
							];

							(* check whether the units of the resolvedSampleConc are the same as targetConcentration; flip the boolean if they are not *)
							(* also check whether the target concentration is greater than the current sample concentration (if so, that's a problem) *)
							(* obviously if targetConcentration is Null or we're dealing with a solid we don't care *)
							(* this is implicitly also checking that TargetConcentration and TargetConcentrationAnalyte must be both Null or both not Null *)
							{
								noConcentrationErrorInsidePool,
								targetConcentrationTooLargeErrorInsidePool
							} = Which[
								(NullQ[targetConcentration] && NullQ[potentialAnalytePacket]) || solidQ || countQ, {False, False},
								Not[MatchQ[targetConcentration, UnitsP[resolvedSampleConc]]], {True, False},
								MatchQ[targetConcentration, GreaterP[resolvedSampleConc]], {False, True},
								True, {False, False}
							];

							(* get the dilution factor, which is the ratio of the sample's target concentration to the current concentration; if target conc is Null or noConcentrationError is True, then set it as 1 *)
							dilutionFactor = If[NullQ[noConcentrationErrorInsidePool] || TrueQ[noConcentrationErrorInsidePool] || NullQ[resolvedSampleConc],
								1,
								(resolvedSampleConc / targetConcentration)
							];

							(* get a Boolean for the concentration being too big or not existing *)
							badConcQ = noConcentrationErrorInsidePool || targetConcentrationTooLargeErrorInsidePool;

							(* calculate what AssayVolume _could_ be in the specific case of dealing with a solid and a specified target concentration *)
							(* doing this here because it would make the big Switch below even uglier otherwise *)
							(* setting this value for solids only; if liquid or counted, we're jumping straight to Null and that's okay (we'll resolve it for real later) *)
							potentialAssayVolumeSolidsInsidePool = Which[
								MatchQ[specifiedAssayVolume, VolumeP|Null], specifiedAssayVolume,
								countQ || liquidQ, Null,
								MassQ[specifiedAmount] && MassConcentrationQ[targetConcentration],
									specifiedAmount / targetConcentration,
								MatchQ[specifiedAmount, Automatic] && MassQ[maxResolutionAmount] && MassConcentrationQ[targetConcentration],
									maxResolutionAmount / targetConcentration,
								MassQ[specifiedAmount]  && ConcentrationQ[targetConcentration] && Not[missingMolecularWeightErrorInsidePool],
									(* need to use Convert because multiplying molar units by gram/mole doesn't simplify by default and UnitSimplify will for some reason convert to INCHES CUBED as their volume unit *)
									Convert[specifiedAmount / (targetConcentration * molecularWeight), Milliliter],
								MatchQ[specifiedAmount, Automatic] && MassQ[maxResolutionAmount] && ConcentrationQ[targetConcentration] && Not[missingMolecularWeightErrorInsidePool],
									(* need to use Convert because multiplying molar units by gram/mole doesn't simplify by default and UnitSimplify will for some reason convert to INCHES CUBED as their volume unit *)
									Convert[maxResolutionAmount / (targetConcentration * molecularWeight), Milliliter],
								True, Null
							];

							(* make a big 'ole Switch where we go through a bunch of different branches for resolving the Volume/AssayVolume options *)
							{
								amount,
								potentialAssayVolumeInsidePool,
								aliquotVolumeTooLargeErrorInsidePool,
								stateAmountMismatchErrorInsidePool
							} = Switch[{specifiedAmount, specifiedAssayVolume, targetConcentration, countQ, solidQ},

								(* if we are dealing with a counted item, things are pretty straightforward; all Automatics in AssayVolume become Null *)
								{_, _, _, True, _},
								Which[
									(* if dealing with a specified amount, going to strip off the Unit unit here because using the mixed syntax is annoying *)
									MatchQ[specifiedAmount, GreaterP[0., 1.]], {specifiedAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if dealing with All or Automatic, go with the max resolution amount *)
									MatchQ[specifiedAmount, Automatic|All], {maxResolutionAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if dealing with anything else specified (masses or volumes or Null), just go with that but also flip the stateAmountMismatchError switch *)
									True, {specifiedAmount, potentialAssayVolumeSolidsInsidePool, False, True}
								],

								{_, _, Null, False, _},
								Which[
									(* if dealing with a solid and the amount was specified, resolve to the specified amount *)
									solidQ && MassQ[specifiedAmount], {specifiedAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if dealing with a solid and the amount was not specified, resolve to the max resolution amount *)
									solidQ && MatchQ[specifiedAmount, Automatic | All], {maxResolutionAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if a solid has a volume/Null/count specified, that's a problem and we're flipping the StateAmountMismatch switch *)
									solidQ && MatchQ[specifiedAmount, VolumeP|GreaterP[0., 1.]|Null], {specifiedAmount, potentialAssayVolumeSolidsInsidePool, False, True},
									(* if dealing with a liquid and the assay volume is specified but less than the specified amount, flip that switch *)
									VolumeQ[specifiedAmount] && VolumeQ[potentialAssayVolumeSolidsInsidePool], {specifiedAmount, potentialAssayVolumeSolidsInsidePool, specifiedAmount > potentialAssayVolumeSolidsInsidePool, False},
									(* if dealing with a liquid and the amount was specified, resolve to that *)
									VolumeQ[specifiedAmount], {specifiedAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if dealing with a liquid and All was specified, resolve to the max resolution amount *)
									MatchQ[specifiedAmount, All], {maxResolutionAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if dealing with a liquid and Automatic was specified and AssayVolume was specified and this sample is the only one inside its own pool, resolve to that (if it's one of multiple in the same pool we quickly have too much volume) *)
									MatchQ[specifiedAmount, Automatic] && VolumeQ[potentialAssayVolumeSolidsInsidePool] && Length[pooledSamplePackets] == 1, {potentialAssayVolumeSolidsInsidePool, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if dealing with a liquid and Automatic was specified and AssayVolume was not specified, resolve to the max resolution volume *)
									MatchQ[specifiedAmount, Automatic], {maxResolutionAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if we got this far, then we're dealing with a liquod but specified Amount is something besides a volume so we're flipping the StateAmountMismatch switch *)
									True, {specifiedAmount, potentialAssayVolumeSolidsInsidePool, False, True}
								],

								(* if we are dealing with a solid and TargetConcentration WAS specified *)
								{_, _, eitherConcP, False, True},
								Which[

									(* - these are the options of if AssayVolume is specified - *)
									(* if dealing with a specified amount, just go with that *)
									VolumeQ[specifiedAssayVolume] && MassQ[specifiedAmount], {specifiedAmount, specifiedAssayVolume, False, False},
									(* if dealing with Automatic, resolve to whatever the TargetConcentration dictates (MassConcentration) *)
									VolumeQ[specifiedAssayVolume] && MatchQ[specifiedAmount, Automatic] && MassConcentrationQ[targetConcentration], {(specifiedAssayVolume * targetConcentration), specifiedAssayVolume, False, False},
									(* if dealing with Automatic, resolve to whatever the TargetConcentration dictates (Concentration; needs to have a MolecularWeight too) *)
									VolumeQ[specifiedAssayVolume] && MatchQ[specifiedAmount, Automatic] && ConcentrationQ[targetConcentration] && MolecularWeightQ[molecularWeight], {UnitSimplify[(specifiedAssayVolume * molecularWeight * targetConcentration)], specifiedAssayVolume, False, False},
									(* if dealing with Automatic but no MolecularWeight, we're hosed but the error above will have already been thrown so just resolve to whatever and figure out the rest later *)
									VolumeQ[specifiedAssayVolume] && MatchQ[specifiedAmount, Automatic] && ConcentrationQ[targetConcentration], {maxResolutionAmount, specifiedAssayVolume, False, False},
									(* if dealing with All, use maxResolutionAmount *)
									VolumeQ[specifiedAssayVolume] && MatchQ[specifiedAmount, All], {maxResolutionAmount, specifiedAssayVolume, False, False},
									(* if dealing with something else, use what was specified but flip the stateAmountMismatchError switch *)
									VolumeQ[specifiedAssayVolume], {specifiedAmount, specifiedAssayVolume, False, True},

									(* - these are the options of if AssayVolume is Automatic - *)
									(* note that in these cases the math was already done above when calculating potentialAssayVolume so we can rely on it here*)
									(* if dealing with a specified amount, just go with that *)
									MassQ[specifiedAmount], {specifiedAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if dealing with All or Automatic, use maxResolutionAmount *)
									MatchQ[specifiedAmount, Automatic|All], {maxResolutionAmount, potentialAssayVolumeSolidsInsidePool, False, False},
									(* if dealing with something else, use what was specified but set AssayVolume to Null and flip the stateAmountMismatchError switch *)
									True, {specifiedAmount, Null, False, True}
								],


								(* if we have a specified target concentration and no Volume information specified *)
								{Automatic|All, Automatic, eitherConcP, False, False},
								Which[
									(* if there is no volume populated, then everything is Null (and we're going to throw errors later anyway so just go with it)  *)
									NullQ[sampleVolume], {Null, Null, False, False},
									(* if we don't have a concentration we can use, then resolve potentialAssayVolume to be Null (we will figure out what it _really_ is outside this MapThread) *)
									noConcentrationErrorInsidePool, {maxResolutionAmount, Null, False, False},
									(* if maxResolutionAmount is Null here, resolve to Null without multiplying by dilution factor *)
									NullQ[maxResolutionAmount], {Null, Null, False, False},
									(* the potential assay volume is the max resolution volume * the dilution factor *)
									True, {maxResolutionAmount, maxResolutionAmount * dilutionFactor, False, False}
								],


								(* if information is specified for Amount option but not AssayVolume (and have a TargetConcentration) *)
								{Except[Automatic|All], Automatic, eitherConcP, False, False},
								Which[
									(* if Amount is a Volume and we have a no-concentration error, then potentialAssayVolume is just Null and we'll figure it out later *)
									VolumeQ[specifiedAmount] && noConcentrationErrorInsidePool,
										{specifiedAmount, Null, False, False},
									(* if Amount is a Volume otherwise, then AssayVolume is it times the dilution factor *)
									VolumeQ[specifiedAmount],
										{specifiedAmount, specifiedAmount * dilutionFactor, False, False},
									(* otherwise just resolve to Null for AssayVolume (but we will flip a switch below too because something is wrong here if this happens) *)
									True,
										{specifiedAmount, Null, False, False}
								],

								(* if information is specified for the AssayVolume option but not Amount (and have a TargetConcentration) *)
								{Automatic, VolumeP|Null, eitherConcP, False, False},
								If[noConcentrationErrorInsidePool || NullQ[specifiedAssayVolume],
									{specifiedAssayVolume, specifiedAssayVolume, False, False},
									{(specifiedAssayVolume / dilutionFactor), specifiedAssayVolume, False, False}
								],

								(* if both the AssayVolume and Amount options are specified (and there is a TargetConcentration) *)
								{Except[Automatic], VolumeP|Null, eitherConcP, False, False},
								Which[
									(* if either the AssayVolume or Amount are Null, then we just can't resolve and are choosing Null *)
									NullQ[specifiedAssayVolume] || NullQ[specifiedAmount], {specifiedAmount /. {All -> Null}, specifiedAssayVolume, False, False},
									(* if we're supposed to transfer All, but there's no sample volume, then we just can't resolve the volume and are choosing Null *)
									MatchQ[specifiedAmount, All] && NullQ[sampleVolume], {Null, specifiedAssayVolume, False, False},
									(* If we're supposed to transfer All and there IS a sample volume, resolve it to the sample volume *)
									MatchQ[specifiedAmount, All] && VolumeQ[sampleVolume] && (sampleVolume <= specifiedAssayVolume), {sampleVolume, specifiedAssayVolume, False, False},
									(* If we're supposed to transfer All and there IS a sample volume, but the sample volume is greater than the specified assay volume, flip the aliquotVolumeTooLargeError switch *)
									MatchQ[specifiedAmount, All] && VolumeQ[sampleVolume] && (sampleVolume > specifiedAssayVolume), {sampleVolume, specifiedAssayVolume, True, False},
									(* If both assay and aliquot volumes are specified, just make sure the aliquot volume is less than the specified assay volume *)
									VolumeQ[specifiedAmount] && VolumeQ[specifiedAssayVolume] && (specifiedAmount <= specifiedAssayVolume), {specifiedAmount, specifiedAssayVolume, False, False},
									(* If both assay and aliquot volumes are specified but the aliquot volume is bigger than the assay volume, flip the aliquotVolumeTooLarge switch *)
									VolumeQ[specifiedAmount] && VolumeQ[specifiedAssayVolume] && (specifiedAmount > specifiedAssayVolume), {specifiedAmount, specifiedAssayVolume, True, False},
									(* If anything besides a Volume is provided as specified Amount, use that value but flip the stateAmountMismatch error *)
									True, {specifiedAmount, specifiedAssayVolume, False, True}
								]
							];

							(* round the amounts to make sure we haven't resolved to something with the wrong precision *)
							(* if Amount is no longer Mass/Volume/Count, then it must be Null *)
							{roundedAmount,validMinAmount} = Which[
								MassQ[amount] || VolumeQ[amount], With[{rounded=Quiet[Check[AchievableResolution[amount],$Failed,Error::MinimumAmount],{Error::MinimumAmount,Warning::AmountRounded}]},
									If[!MatchQ[rounded,$Failed],
										{rounded,True},
										{amount,False}
									]
								],
								MatchQ[amount, GreaterP[0., 1.]], With[{rounded=RoundOptionPrecision[amount, 1, Round -> Down]},
									If[MatchQ[rounded,0],
										{amount,False},
										{amount,True}
									]
								],
								True, {Null,True}
							];
							roundedAssayVolume = If[NullQ[potentialAssayVolumeInsidePool],
								Null,
								Quiet[AchievableResolution[potentialAssayVolumeInsidePool],{Error::MinimumAmount,Warning::AmountRounded}]
							];
							roundedTargetConcentration = Switch[targetConcentration,
								ConcentrationP, RoundOptionPrecision[targetConcentration, 10^-1*Micromolar],
								MassConcentrationP, RoundOptionPrecision[targetConcentration, 10^-1*Microgram/Liter],
								_, Null
							];

							{
								roundedAmount,
								validMinAmount,
								roundedAssayVolume,
								roundedTargetConcentration,
								unknownAmountWarningInsidePool,
								missingMolecularWeightErrorInsidePool,
								aliquotVolumeTooLargeErrorInsidePool,
								stateAmountMismatchErrorInsidePool,
								noConcentrationErrorInsidePool,
								targetConcentrationTooLargeErrorInsidePool,
								targetConcNotUsedWarningInsidePool,
								dilutionFactor
							}
						]

					],
					{pooledSamplePackets, Lookup[options, Amount], Lookup[options, TargetConcentration], maxResolutionAmounts, potentialAnalytes, Lookup[options, SourceLabel], Lookup[options, SourceContainerLabel]}
				]];

				(* get the total volume of the resolved amounts; if no volumes, resolve to Null *)
				totalSampleVolume = If[MatchQ[Cases[amounts, VolumeP], {}],
					Null,
					Total[Cases[amounts, VolumeP]]
				];

				(* get the potential assay volumes that we resolved in the MapThread above.  This could be {} which is okay *)
				potentialAssayVolumesNoNull = DeleteDuplicates[DeleteCases[potentialAssayVolume, Null]];

				(* get the "probably" assay volume (still need to do this because it will be either this value or the total sample volume) *)
				(* also if there is more than one volume then we're going to have to throw a CannotResolveAssayVolume error so flip that switch here *)
				{
					probableAssayVolume,
					cannotResolveAssayVolumeError
				} = If[MatchQ[potentialAssayVolumesNoNull, {} | {VolumeP}],
					{FirstOrDefault[potentialAssayVolumesNoNull, totalSampleVolume], False},
					{First[potentialAssayVolumesNoNull], True}
				];

				(* resolve the AssayVolume value *)
				assayVolume = specifiedAssayVolume /. {Automatic -> probableAssayVolume};

				(* flip error switch if AssayVolume resolves to greater than $MaxTransferVolume *)
				overMaxVolumeError = VolumeQ[assayVolume] && assayVolume > $MaxTransferVolume;

				(* flip the cannotResolveAmountError switch now for the case where AssayVolume is not a volume but Amount is *)
				cannotResolveAmountError = And[
					Not[VolumeQ[assayVolume]],
					VolumeQ[totalSampleVolume]
				];

				(* flip the pooledVolumeAboveAssayVolumeError switch for if AssayVolume is less than the total sample volume *)
				(* if we're already throwing the targetConcentrationTooLargeError then don't bother throwing this error too since that is redundant *)
				(* also if we are throwing the AliquotVolumeTooLarge error then obviously this is going to be true too so don't throw it since it's redundant *)
				pooledVolumeAboveAssayVolumeError = VolumeQ[assayVolume] && VolumeQ[totalSampleVolume] && totalSampleVolume > assayVolume && Not[MemberQ[targetConcentrationTooLargeError, True]] && Not[MemberQ[aliquotVolumeTooLargeError, True]];

				(* do another MapThread which we need to do to do the final resolution of the cannotResolveAmount and concentrationRatioMismatch errors *)
				{
					cannotResolveAmountErrorFinal,
					concentrationRatioMismatchError
				} = Transpose[MapThread[
					Function[{samplePacket, amount, targetConc, specifiedAmount, noConcBool, targetConcTooBigBool, dilutionFactor},
						Module[{countQ, liquidQ, solidQ, concentrationQ, cannotResolveAmountInsideSecondPool,
							cannotResolveAmountErrorInsidePoolFinal, concentrationRatioMismatchErrorInsidePool},

							(* get whether the given sample is counted/liquid/solid; need to do GreaterEqualP here since a sample could in theory have 0 *)
							countQ = MatchQ[Lookup[samplePacket, Count], GreaterEqualP[0., 1.]];
							liquidQ = VolumeQ[Lookup[samplePacket, Volume]];
							solidQ = Not[liquidQ] && Not[countQ] && MassQ[Lookup[samplePacket, Mass]];

							(* get whether we have a concentation or not *)
							concentrationQ = ConcentrationQ[targetConc] || MassConcentrationQ[targetConc];

							(* flip the switch for not being able to resolve the amount *)
							cannotResolveAmountInsideSecondPool = And[
								Or[
									liquidQ,
									(solidQ && concentrationQ),
									(* if we don't have any state information, then a null Amount or AssayVolume will be enough to flip the switch *)
									Not[liquidQ] && Not[solidQ] && Not[countQ]
								],
								NullQ[amount] || NullQ[assayVolume]
							];

							(* for real cannot resolve the amount if we've already flipped the switch for it *)
							cannotResolveAmountErrorInsidePoolFinal = cannotResolveAmountError || cannotResolveAmountInsideSecondPool;

							(* three cases where we throw the ConcentrationRatioMismatch error *)
							concentrationRatioMismatchErrorInsidePool = Or[
								(* -1.) not counted *)
								(* 0.) solid *)
								(* 1.) TargetConcentration is specified *)
								(* 2.) AssayVolume resolved to a volume *)
								(* 3.) Mass resolved to a mass *)
								(* 4a.) If TargetConcentration is a normal Concentration, make sure the mass * molecular weight / assay volume is equal to target conc *)
								(* 4b.) If TargetConcentration is a MassConcentration, if the mass / assay volume is not equal to target conc *)
								And[
									Not[countQ],
									solidQ,
									concentrationQ,
									VolumeQ[assayVolume],
									MassQ[amount],
									If[ConcentrationQ[targetConc],
									(* note that we need the TrueQ here in case molecularWeight doesn't exist, in which we still want to get False *)
										TrueQ[amount / (molecularWeight * assayVolume)!= targetConc],
										amount / assayVolume != targetConc
									]
								],
								(* -1.) not counted *)
								(* 0.) solid *)
								(* 1.) TargetConcentration is specified *)
								(* 2.) AssayVolume is Null *)
								And[
									Not[countQ],
									solidQ,
									concentrationQ,
									NullQ[assayVolume]
								],
								(* -1.) not counted *)
								(* 0.) Not a solid *)
								(* 1.) TargetConcentration is specified *)
								(* 2.) AssayVolume was specified *)
								(* one of the two of the following are true *)
								(* 3a.) Amount was specified as All and the sample's volume is not Null *)
								(* 3b.) Amount was specified as a volume *)
								(* 4.) Neither of the concentration-is-bad error booleans from above have been flipped *)
								(* 5.) the ratio of the resolved aliquot volume to resolved volume does NOT equal the ratio of the sample concentration to target concentration *)
								And[
									Not[countQ],
									Not[solidQ],
									concentrationQ,
									MatchQ[specifiedAssayVolume, VolumeP],
									Or[
										MatchQ[specifiedAmount, All] && Not[NullQ[Lookup[samplePacket, Volume]]],
										VolumeQ[specifiedAmount]
									],
									Not[noConcBool || targetConcTooBigBool],
									(* +-1 uL here is reasonable due to rounding we might have done when we initially resolved these options *)
									!MatchQ[amount, RangeP[assayVolume/dilutionFactor-Quantity[1, "Microliters"], assayVolume/dilutionFactor+Quantity[1, "Microliters"]]]
								]
							];

							{cannotResolveAmountErrorInsidePoolFinal, concentrationRatioMismatchErrorInsidePool}
						]
					],
					{pooledSamplePackets, amounts, targetConcentrations, Lookup[options, Amount], noConcentrationError, targetConcentrationTooLargeError, dilutionFactors}
				]];

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
					True, Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)
				];


				(* flip the bufferDilutionMismatchError is anything but all Null or none Null *)
				(* note that here True means there is an error and False means everything is fine *)
				bufferDilutionMismatchError = If[AllTrue[{concentratedBuffer, bufferDilutionFactor, bufferDiluent}, NullQ] || NoneTrue[{concentratedBuffer, bufferDilutionFactor, bufferDiluent}, NullQ],
					False,
					True
				];

				(* if AssayBuffer was specified, just use that; if ConcentratedBuffer was specified, resolve to Null; if AssayVolume is Null, or if Amount and AssayVolume are the same then resolve to Null; otherwise resolve to water *)
				assayBuffer = Which[
					MatchQ[Lookup[options, AssayBuffer], Except[Automatic]], Lookup[options, AssayBuffer],
					Not[NullQ[concentratedBuffer]], Null,
					(* need to put the Quiet around the Equal call because if amount is not a volume it will throw an error and I don't want it to *)
					NullQ[assayVolume] || TrueQ[Quiet[totalSampleVolume == assayVolume, {Equal::nordq, Equal::nord2}]], Null,
					True, Model[Sample, "id:8qZ1VWNmdLBD"] (* Model[Sample, "Milli-Q water"] *)
				];

				(* Make sure we have precisely one of AssayBuffer or ConcentratedBuffer populated if AssayVolume != Volume; otherwise, make sure we have one or zero of them *)
				overspecifiedBufferError = Which[
					(* if assay volume and amount are equal then we have an over specified buffer error if there are no Nulls *)
					VolumeQ[totalSampleVolume] && VolumeQ[assayVolume] && totalSampleVolume == assayVolume,
						NoneTrue[{assayBuffer, concentratedBuffer}, NullQ],
					(* if assay volume is a volume otherwise (i.e., amount are volumes but not equal or if amount is a mass/count), we have an over specified buffer error if we have two Nulls or no Nulls *)
					VolumeQ[assayVolume] && Not[NullQ[totalSampleVolume]],
						Or[
							AllTrue[{assayBuffer, concentratedBuffer}, NullQ],
							NoneTrue[{assayBuffer, concentratedBuffer}, NullQ]
						],
					(* if assay volume is Null but amount is something besides volumes, we have an over specified buffer error if anything is not null *)
					NullQ[assayVolume] && MatchQ[amounts, {MassP|GreaterP[0., 1.]...}],
						Not[AllTrue[{assayBuffer, concentratedBuffer}, NullQ]],
					(* otherwise we are not throwing this error so it is False *)
					True, False
				];

				(* If amount == assayVolume, and AssayBuffer and/or ConcentratedBuffer are specified, flip a warning switch *)
				bufferSpecifiedNoVolumeWarning = VolumeQ[totalSampleVolume] && VolumeQ[assayVolume] && totalSampleVolume == assayVolume && (Not[NullQ[assayBuffer]] || Not[NullQ[concentratedBuffer]]);

				(* determine how much buffer volume is necessary *)
				bufferVolume = assayVolume - totalSampleVolume;

				(* determine how much concentrated buffer is needed *)
				concBufferVolume = If[NumericQ[bufferDilutionFactor],
					assayVolume / bufferDilutionFactor,
					Null
				];

				(* if the amount of concentrated buffer volume is greater than the buffer volume, then flip the error switch *)
				bufferTooConcentratedError = VolumeQ[concBufferVolume] && VolumeQ[bufferVolume] && concBufferVolume > bufferVolume;

				(* return the MapThread variables in order *)
				{
					targetConcentrations,
					amounts,
					validMinAmountBools,
					assayVolume,
					assayBuffer,
					concentratedBuffer,
					bufferDilutionFactor,
					bufferDiluent,
					cannotResolveAmountErrorFinal,
					aliquotVolumeTooLargeError,
					noConcentrationError,
					targetConcentrationTooLargeError,
					concentrationRatioMismatchError,
					bufferDilutionMismatchError,
					overspecifiedBufferError,
					bufferSpecifiedNoVolumeWarning,
					unknownAmountWarning,
					missingMolecularWeightError,
					stateAmountMismatchError,
					targetConcNotUsedWarning,
					pooledVolumeAboveAssayVolumeError,
					cannotResolveAssayVolumeError,
					bufferTooConcentratedError,
					overMaxVolumeError
				}

			]
		],
		{samplePackets, mapThreadFriendlyOptions, maxResolutionAmountPerSample, potentialAnalytePackets}
	]];


	(* get all the aliquot samples that can be labeled, as well as the containers  *)
	allPotentiallyLabeledSamples = Download[Cases[DeleteDuplicates[Flatten[{
		Lookup[Flatten[samplePackets], Object],
		resolvedConcentratedBuffer,
		resolvedBufferDiluent,
		resolvedAssayBuffer
	}]], ObjectP[]], Object];
	allPotentiallyLabeledContainers = Download[Cases[DeleteDuplicates[Flatten[{
		Lookup[Flatten[samplePackets], Container]
	}]], ObjectP[]], Object];

	(* make replace rules converting the samples and containers into labels *)
	sampleLabelReplaceRules = Map[
		# -> CreateUniqueLabel["aliquot sample"]&,
		allPotentiallyLabeledSamples
	];
	containerLabelReplaceRules = Map[
		# -> CreateUniqueLabel["aliquot container"]&,
		allPotentiallyLabeledContainers
	];

	(* get the resolved labels *)
	{
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedConcentratedBufferLabel,
		resolvedBufferDiluentLabel,
		resolvedAssayBufferLabel
	} = Transpose[MapThread[
		Function[{pooledSamplePackets, options, concentratedBuffer, bufferDiluent, assayBuffer},
			Module[{sampleLabel, sampleContainerLabel,
				concentratedBufferLabel, bufferDiluentLabel, assayBufferLabel},

				(* resolve the pooled label options *)
				{
					sampleLabel,
					sampleContainerLabel
				} = Transpose[MapThread[
					Function[{samplePacket, sourceLabelOption, sourceContainerLabelOption},
						Module[{sampleLabelInsidePool, sampleContainerLabelInsidePool},

							(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
							(* labels if we have duplicates. *)
							sampleLabelInsidePool = Which[
								Not[MatchQ[sourceLabelOption, Automatic]],
									sourceLabelOption,
								MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[samplePacket, Object]],
									Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePacket, Object]],
								True,
									Lookup[samplePacket, Object] /. sampleLabelReplaceRules
							];
							sampleContainerLabelInsidePool = Which[
								Not[MatchQ[sourceContainerLabelOption, Automatic]],
									sourceContainerLabelOption,
								MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Download[Lookup[samplePacket, Container], Object]],
									Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Download[Lookup[samplePacket, Container], Object]],
								True,
									Download[Lookup[samplePacket, Container], Object] /. containerLabelReplaceRules
							];

							{
								sampleLabelInsidePool,
								sampleContainerLabelInsidePool
							}
						]
					],
					{pooledSamplePackets, Lookup[options, SourceLabel], Lookup[options, SourceContainerLabel]}
				]];

				(* get the concentrated buffer/buffer diluent/assay buffer label *)
				concentratedBufferLabel = Which[
					Not[MatchQ[Lookup[options, ConcentratedBufferLabel], Automatic]], Lookup[options, ConcentratedBufferLabel],
					NullQ[concentratedBuffer], Null,
					True, Download[concentratedBuffer, Object] /. sampleLabelReplaceRules
				];
				(* get the buffer diluent label *)
				bufferDiluentLabel = Which[
					Not[MatchQ[Lookup[options, BufferDiluentLabel], Automatic]], Lookup[options, BufferDiluentLabel],
					NullQ[bufferDiluent], Null,
					True, Download[bufferDiluent, Object] /. sampleLabelReplaceRules
				];

				(* get the assay buffer label *)
				assayBufferLabel = Which[
					Not[MatchQ[Lookup[options, AssayBufferLabel], Automatic]], Lookup[options, AssayBufferLabel],
					NullQ[assayBuffer], Null,
					True, Download[assayBuffer, Object] /. sampleLabelReplaceRules
				];

				(* return our labels *)
				{
					sampleLabel,
					sampleContainerLabel,
					concentratedBufferLabel,
					bufferDiluentLabel,
					assayBufferLabel
				}
			]
		],
		{samplePackets, mapThreadFriendlyOptions, resolvedConcentratedBuffer, resolvedBufferDiluent, resolvedAssayBuffer}
	]];

	(* --- Unresolvable error checking --- *)

	(* get the flat sample packets and amounts here because we're going to need to do a lot of flattening *)
	flatSamplePackets = Flatten[samplePackets];
	flatAmounts = Flatten[resolvedAmount];
	flatTargetConc = Flatten[resolvedTargetConcentration];

	(* get the samples that have no volume or mass populated *)
	noAmountSamples = PickList[flatSamplePackets, Flatten[unknownAmountWarnings]];

	(* throw a warning if no volume is known for the input samples; since this isn't actually an InvalidOption (just a warning), don't actually need to assign this to any value *)
	If[MatchQ[noAmountSamples, {PacketP[]..}] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::UnknownAmount, ObjectToString[Lookup[noAmountSamples, Object], Cache -> inheritedCache]]
	];

	(* If we are gathering tests, create a passing and/or failing warning test with the appropriate result. *)
	unknownAmountWarningTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[noAmountSamples] == 0,
				Nothing,
				Warning["Provided samples " <> ObjectToString[Lookup[noAmountSamples, Object], Cache -> inheritedCache] <> " have Volume, Mass, or Count currently populated:", True, False]
			];

			passingTest = If[Length[noAmountSamples] == Length[flatSamplePackets],
				Nothing,
				Warning["Provided samples have models " <> ObjectToString[Lookup[Complement[flatSamplePackets, noAmountSamples], Object], Cache -> inheritedCache] <> " have Volume, Mass, or Count currently populated:", True, True]
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
				Test["The provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> " have MolecularWeight populated if it is necessary to resolve AssayVolume:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> " have MolecularWeight populated if it is necessary to resolve AssayVolume:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* throw a message if Amount was specified such that it mismatched with the state of the sample being aliquoted *)
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

	(* throw a message if there was a part where we couldn't resolve the volume since it was Null some places *)
	cannotResolveVolumeInvalidInputs = If[MemberQ[Flatten[cannotResolveAmountErrors], True] && messages,
		(
			Message[Error::CannotResolveAmount, ObjectToString[PickList[Lookup[flatSamplePackets, Object], Flatten[cannotResolveAmountErrors], True], Cache -> inheritedCache], "Volume/Mass/Count", AssayVolume];
			PickList[Lookup[flatSamplePackets, Object], Flatten[cannotResolveAmountErrors], True]
		),
		PickList[Lookup[flatSamplePackets, Object], Flatten[cannotResolveAmountErrors], True]
	];

	(* generate the cannotResolveVolume tests *)
	cannotResolveVolumeTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[cannotResolveAmountErrors]];

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[cannotResolveAmountErrors], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The provided samples " <> ObjectToString[failingSamples, Cache -> inheritedCache] <> " have Volume populated or specified:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The provided samples " <> ObjectToString[passingSamples, Cache -> inheritedCache] <> " have Volume populated or specified:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples where the aliquot volume is too large (and those volumes, and those assay volumes) *)
	aliquotVolumeTooLargeSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[aliquotVolumeTooLargeErrors]];
	aliquotVolumeTooLargeVolume = PickList[flatAmounts, Flatten[aliquotVolumeTooLargeErrors]];
	aliquotVolumeTooLargeAssayVolume = PickList[resolvedAssayVolume, aliquotVolumeTooLargeErrors, _?(MemberQ[#, True]&)];

	(* throw a message if the aliquot volume is larger than the volume *)
	aliquotVolumeToolargeOptions = If[MemberQ[Flatten[aliquotVolumeTooLargeErrors], True] && messages,
		(
			Message[Error::AliquotVolumeTooLarge, ObjectToString[aliquotVolumeTooLargeSamples, Cache -> inheritedCache], ObjectToString[aliquotVolumeTooLargeVolume], ObjectToString[aliquotVolumeTooLargeAssayVolume]];
			{Amount, AssayVolume}
		),
		{}
	];

	(* tests for if AliquotVolume is bigger than Amount *)
	aliquotVolumeTooLargeTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs, blank volumes, and blanks that fail this test *)
			failingSamples = aliquotVolumeTooLargeSamples;

			(* get the inputs, blank volumes, and blanks that pass this test *)
			passingSamples = PickList[Lookup[flatSamplePackets, Object, {}], Flatten[aliquotVolumeTooLargeErrors], False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The requested Amount is below the requested AssayVolume for the following sample(s):" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The requested Amount is below the requested AssayVolume for the following sample(s):" <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];


	(* -- Amount Rounding Error -- *)

	flatMinAmountBools = Flatten[validMinAmountBoolLists];

	minsValid = MatchQ[flatMinAmountBools,{True..}];

	(* Throw a message for the problematic amounts *)
	If[!minsValid && messages,
		Message[Error::MinimumAliquotAmount,PickList[Lookup[flatSamplePackets, Object, {}],flatMinAmountBools,False],PickList[flatAmounts,flatMinAmountBools,False]]
	];

	(* Create a test if requested *)
	invalidMinTest = If[!messages,
		Test["All Amounts are above the minimum mass or volume that can be manipulated using standard transfer devices:",minsValid,True]
	];

	(* Track Invalid Option - Blame any specified option that interplays with amount *)
	(* Always include Amount option. There's a bug that in rare case when all three options are Automatic but error still triggered (e.g., sample volume is 0) *)
	(* we get an empty list here so the protocol won't return $Failed *)
	invalidMinOptions = If[!minsValid,
		Union[Keys[Select[KeyTake[myOptions,{TargetConcentration,AssayVolume}],MemberQ[Flatten[#],UnitsP[]]&]], {Amount}],
		{}
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
	targetConcentrationTooLargeAnalyte = PickList[potentialAnalytesToUseFlat, Flatten[targetConcentrationTooLargeErrors]];

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

	(* get the samples that have the concentration ratio mismatch *)
	concMismatchSamples = PickList[flatSamplePackets, Flatten[concentrationRatioMismatchErrors]];
	concMismatchAmount = PickList[flatAmounts, Flatten[concentrationRatioMismatchErrors]];
	concMismatchAssayVolume = PickList[resolvedAssayVolume, concentrationRatioMismatchErrors, _?(MemberQ[#, True]&)];
	concMismatchTargetConc = PickList[flatTargetConc, Flatten[concentrationRatioMismatchErrors]];
	concMismatchAnalyte = PickList[potentialAnalytesToUseFlat, Flatten[concentrationRatioMismatchErrors]];

	(* pull out what the current concentration is for the samples *)
	concMismatchSampleConc = MapThread[
		Function[{composition, analytePacket},
			FirstCase[composition, {conc_, ObjectP[analytePacket]} :> conc, Null]
		],
		{Lookup[concMismatchSamples, Composition, {}], concMismatchAnalyte}
	];


	(* throw a message if the ratio of the current Concentration is proportional to the TargetConcentration in the same ratio as the Amount/AssayVolume *)
	concentrationRatioMismatchOptions = If[MemberQ[Flatten[concentrationRatioMismatchErrors], True] && messages,
		(
			Message[
				Error::ConcentrationRatioMismatch,
				ObjectToString[concMismatchSamples, Cache -> inheritedCache],
				Replace[concMismatchSampleConc / concMismatchTargetConc, {Except[NumericP]->"N/A"}, {1}],
				concMismatchTargetConc,
				concMismatchAmount,
				concMismatchAssayVolume,
				Replace[concMismatchAssayVolume / concMismatchAmount, {Except[NumericP]->"N/A"}, {1}],
				AssayVolume
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

	(* make a list of rules correlating each sample with its volume *)
	(* make sure we have no Nulls here *)
	aliquotToVolumeRules = MapThread[
		If[Not[VolumeQ[#2]] || NullQ[Lookup[#1, Volume]],
			Nothing,
			#1 -> #2
		]&,
		{flatSamplePackets, flatAmounts}
	];

	(* combine the rules to sum up aliquots with the same source *)
	totalAliquotVolumePerSampleRules = Merge[aliquotToVolumeRules, Total];

	(* get the samples that require more volume than they currently have *)
	totalAliquotVolumeTooLargeValues = KeyValueMap[
		If[Lookup[#1, Volume] >= #2,
			Nothing,
			{Lookup[#1, Object], #2}
		]&,
		totalAliquotVolumePerSampleRules
	];

	(* get the samples/volumes where they require more volume than they currently have *)
	totalAliquotVolumeTooLargeSamples = totalAliquotVolumeTooLargeValues[[All, 1]];
	totalAliquotVolumeTooLargeVolumes = totalAliquotVolumeTooLargeValues[[All, 2]];

	(* throw a warning if we're requesting more volume than we can have *)
	If[MatchQ[totalAliquotVolumeTooLargeSamples, {ObjectReferenceP[]..}] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::TotalAliquotVolumeTooLarge, ObjectToString[totalAliquotVolumeTooLargeSamples, Cache -> inheritedCache], UnitScale[totalAliquotVolumeTooLargeVolumes, Simplify -> False]]
	];

	(* if we're gathering test, create warnings for whether more is requested than we wanted to *)
	totalAliquotVolumeTooLargeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[totalAliquotVolumeTooLargeSamples] == 0,
				Nothing,
				Warning["The requested volume of the samples " <> ObjectToString[totalAliquotVolumeTooLargeSamples, Cache -> inheritedCache] <> " do not exceed these samples' volumes:",
					False,
					True
				]
			];

			passingTest = If[Length[totalAliquotVolumeTooLargeSamples] == Length[DeleteDuplicates[Lookup[Keys[aliquotToVolumeRules], Object, {}]]],
				Nothing,
				Warning["The requested volume of the samples " <> ObjectToString[Complement[Lookup[Keys[aliquotToVolumeRules], Object, {}], totalAliquotVolumeTooLargeSamples], Cache -> inheritedCache] <> " do not exceed these samples' volumes:",
					True,
					True
				]
			];

			{failingTest, passingTest}
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

	(* throw a message if for any sample the AssayBuffer and ConcentratedBuffer options are both specified *)
	overspecifiedBufferInvalidOptions = If[MemberQ[overspecifiedBufferErrors, True] && messages,
		(
			Message[Error::OverspecifiedBuffer, ObjectToString[overspecifiedBufferSamples, Cache -> inheritedCache]];
			{ConcentratedBuffer, AssayBuffer}
		),
		{}
	];

	(* tests for if for any sample the AssayBuffer and ConcentratedBuffer options are both specified *)
	overspecifiedBufferInvalidTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			failingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, overspecifiedBufferErrors];

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			passingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, overspecifiedBufferErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["Only one of ConcentratedBuffer and AssayBuffer are specified for the following samples:" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["Only one of ConcentratedBuffer and AssayBuffer are specified for the following samples:" <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples for which no buffer will be used but a buffer was specified *)
	noBufferWithBufferSamples = PickList[samplePackets, bufferSpecifiedNoVolumeWarnings];

	(* throw a warning if for any sample AssayBuffer and/or ConcentratedBuffer are specified but will not be used *)
	If[MemberQ[bufferSpecifiedNoVolumeWarnings, True] && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::BufferWillNotBeUsed, ObjectToString[Download[noBufferWithBufferSamples,Object], Cache -> inheritedCache]]
	];

	(* if we are gathering tests, create a passing and/or failing warning test with the appropriate result *)
	noBufferWithBufferTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[noBufferWithBufferSamples] == 0,
				Nothing,
				Warning["If AssayBuffer and/or ConcentratedBuffer are specified for " <> ObjectToString[noBufferWithBufferSamples, Cache -> inheritedCache] <> ", dilution is occurring:",
					True,
					False
				]
			];

			passingTest = If[Length[noBufferWithBufferSamples] == Length[samplePackets],
				Nothing,
				Warning["If AssayBuffer and/or ConcentratedBuffer are specified for " <> ObjectToString[noBufferWithBufferSamples, Cache -> inheritedCache] <> ", dilution is occurring:",
					True,
					True
				]
			];

			{failingTest, passingTest}
		]
	];

	(* get the samples for which the pooled volume is above the assay volume *)
	pooledVolumeAboveAssayVolumeSamples = PickList[samplePackets, pooledVolumeAboveAssayVolumeErrors];

	(* get the relevant pooled volumes and assay volumes *)
	pooledVolume = Map[
		Total[Cases[#, VolumeP]]&,
		resolvedAmount
	];
	pooledVolumeAboveAssayVolumeVolumes = PickList[pooledVolume, pooledVolumeAboveAssayVolumeErrors];
	pooledVolumeAboveAssayVolumeAssayVolumes = PickList[resolvedAssayVolume, pooledVolumeAboveAssayVolumeErrors];

	(* throw a message if the pooled volume is above the assay volume *)
	pooledVolumeAboveAssayVolumeOptions = If[MemberQ[pooledVolumeAboveAssayVolumeErrors, True] && messages,
		(
			Message[Error::NestedIndexMatchingVolumeAboveAssayVolume, ObjectToString[pooledVolumeAboveAssayVolumeSamples, Cache -> inheritedCache], ObjectToString[pooledVolumeAboveAssayVolumeVolumes, Cache -> inheritedCache], ObjectToString[pooledVolumeAboveAssayVolumeAssayVolumes, Cache -> inheritedCache]];
			{Amount, AssayVolume}
		),
		{}
	];

	(* tests for if for any sample the AssayBuffer and ConcentratedBuffer options are both specified *)
	pooledVolumeAboveAssayVolumeTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			failingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, pooledVolumeAboveAssayVolumeErrors];

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			passingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, pooledVolumeAboveAssayVolumeErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The total volume of the following samples is less than the AssayVolume for them:" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The total volume of the following samples is less than the AssayVolume for them:" <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* get the samples for we can't resolve AssayVolume *)
	cannotResolveAssayVolumeSamples = PickList[samplePackets, cannotResolveAssayVolumeError];

	(* throw a message if we can't resolve AssayVolume *)
	cannotResolveAssayVolumeOptions = If[MemberQ[cannotResolveAssayVolumeError, True] && messages,
		(
			Message[Error::CannotResolveAssayVolume, ObjectToString[cannotResolveAssayVolumeSamples, Cache -> inheritedCache]];
			{Amount, TargetConcentration, AssayVolume}
		),
		{}
	];

	(* tests for if we can resolve AssayVolume *)
	cannotResolveAssayVolumeTest = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			failingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, cannotResolveAssayVolumeError];

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			passingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, cannotResolveAssayVolumeError, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The Amount and TargetConcentration options agree with each other such that AssayVolume can be resolved for the following samples:" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The Amount and TargetConcentration options agree with each other such that AssayVolume can be resolved for the following samples:" <> ObjectToString[passingSamples, Cache -> inheritedCache],
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
	bufferTooConcentratedAssayVolumes = PickList[resolvedAssayVolume, bufferTooConcentratedErrors];

	(* throw a message if BufferDilutionFactor is too high *)
	bufferTooConcentratedOptions = If[MemberQ[bufferTooConcentratedErrors, True] && messages,
		(
			Message[Error::BufferDilutionFactorTooLow, bufferTooConcentratedBufferDilutionFactors, ObjectToString[bufferTooConcentratedAssayVolumes], ObjectToString[bufferTooConcentratedSamples, Cache -> inheritedCache]];
			{AssayVolume, BufferDilutionFactor, ConcentratedBuffer}
		),
		{}
	];

	(* make tests for if BufferDilutionFactor is too high *)
	bufferTooConcentratedTests = If[gatherTests,
		Module[{failingSamples, passingSamples, failingSampleTests, passingSampleTests},

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			failingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, bufferTooConcentratedErrors];

			(* get the inputs that fail this test; need to map over SamplePackets looking up Object because samplePackets is a list of lists *)
			passingSamples = PickList[Lookup[#, Object, {}]& /@ samplePackets, bufferTooConcentratedErrors, False];

			(* create a test for the non-passing inputs *)
			failingSampleTests = If[Length[failingSamples] > 0,
				Test["The BufferDilutionFactor and AssayVolume options are set to values such that the ConcentratedBuffer can be diluted to the proper value for the following samples:" <> ObjectToString[failingSamples, Cache -> inheritedCache],
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingSampleTests = If[Length[passingSamples] > 0,
				Test["The BufferDilutionFactor and AssayVolume options are set to values such that the ConcentratedBuffer can be diluted to the proper value for the following samples:" <> ObjectToString[passingSamples, Cache -> inheritedCache],
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingSampleTests, failingSampleTests}

		]
	];

	(* --- Resolve the ContainerOut option --- *)

	(* figure out if we're pooling (i.e., if there's more than one sample in a given list) *)
	pooledQ = MemberQ[Length[#]& /@ pooledInputs, GreaterP[1]];

	(* Check if sample is Sterile, contains cells, or require AsepticHandling *)
	(* Note:ExperimentSerialDilute does not have SterileTechnique or Sterile option yet, so we do not need to check *)
	sterileQ = Or[
		MemberQ[Lookup[Flatten@samplePackets, Sterile], True],
		MemberQ[Lookup[Flatten@samplePackets, Living], True],
		MemberQ[Lookup[Flatten@samplePackets, CellType], CellTypeP],
		MemberQ[Lookup[Flatten@samplePackets, AsepticHandling], True]
	];

	(* if we are pooling, we can't actually consolidate aliquots, and so the logic below gates on this *)
	consolidateAliquots = If[pooledQ,
		False,
		specifiedConsolidateAliquots
	];

	(* throw a warning saying that ConsolidateAliquots -> True will be ignored if we're pooling things together *)
	If[pooledQ && specifiedConsolidateAliquots && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::NestedIndexMatchingConsolidateAliquotsNotSupported]
	];

	(* make tests for if pooling/ConsolidateAliquots are set together *)
	pooledConsolidateAliquotsWarning = If[gatherTests,
		Warning["ConsolidateAliquots is not set to True if pooling multiple samples together:",
			pooledQ && specifiedConsolidateAliquots,
			False
		]
	];

	(* determine if AssayVolume is too large (i.e., over $MaxTransferVolume) *)
	overMaxVolumeOptions = If[messages && MemberQ[overMaxVolumeErrors, True],
		(
			Message[
				Error::AssayVolumeAboveMaximum,
				ObjectToString[PickList[mySamples, overMaxVolumeErrors], Cache -> inheritedCache],
				ObjectToString[PickList[resolvedAssayVolume, overMaxVolumeErrors]],
				ObjectToString[$MaxTransferVolume]
			];
			{TargetConcentration, AssayVolume}
		),
		{}
	];
	overMaxVolumeTests = If[gatherTests,
		Test["The AssayVolume, either specified or calculated from other options, does not exceed $MaxTransferVolume:",
			MemberQ[overMaxVolumeErrors, True],
			False
		]
	];

	(* make fake volumes and assay volumes replacing any Nulls with 2*Milliliter; need to do this to make PreferredContainer happy, and if we are at this point we're already in trouble anyway *)
	(* assuming the tablet weight of a given tablet is 1 Gram.  That is a good enough assumption this is already fake *)
	(* note that PreferredContainer works on solids too so if fakeAssayVolumes is Null here and fakeAmounts is a mass, we want fakeAssayVolumes to be a mass too.  I am already telling you it's "fake" in the variable name so who cares *)
	(* note that since we can have pools, we need to combine the amounts accordingly *)
	fakeAmounts = Map[
		Which[
			MatchQ[Cases[#, VolumeP], {VolumeP..}], Total[Cases[#, VolumeP]],
			MatchQ[Cases[#, MassP], {MassP..}], Total[Cases[#, MassP]],
			MatchQ[Cases[#, GreaterP[0., 1.]], {GreaterP[0., 1.]..}], Total[Cases[#, GreaterP[0., 1.]]]*Gram,
			True, 2*Milliliter
		]&,
		resolvedAmount
	];
	fakeAssayVolumes = MapThread[
		Which[
			(* if we're mixing solids and liquids, assume the density of water for the solid (probably going to be denser than that, but that's ok) *)
			VolumeQ[#1] && MassQ[#2], Min[{#1 + (#2 / (0.997 Gram / Milliliter)), $MaxTransferVolume}],
			VolumeQ[#1], Min[{#1, $MaxTransferVolume}],
			MassQ[#2], #2,
			True, 2*Milliliter
		]&,
		{resolvedAssayVolume, fakeAmounts}
	];

	(* get the incompatible materials for each transfer *)
	(* want to make sure we pick a PreferredContainer that isn't incompatible with any of the samples *)
	allIncompatibleMaterials = MapThread[
		Function[{samplePacket, assayBuffer, concentratedBuffer, bufferDiluent},
			Module[{allIncompatibleMaterialsRaw},
				allIncompatibleMaterialsRaw = DeleteDuplicates[Flatten[{
					Lookup[samplePacket, IncompatibleMaterials],
					If[MatchQ[assayBuffer, ObjectP[]],
						fastAssocLookup[fastAssoc, assayBuffer, IncompatibleMaterials],
						Nothing
					],
					If[MatchQ[concentratedBuffer, ObjectP[]],
						fastAssocLookup[fastAssoc, concentratedBuffer, IncompatibleMaterials],
						Nothing
					],
					If[MatchQ[bufferDiluent, ObjectP[]],
						fastAssocLookup[fastAssoc, bufferDiluent, IncompatibleMaterials],
						Nothing
					]
				}]];

				(* note that if we have a bunch of junk, or multiple Nones, or {}, we want {None} *)
				If[MatchQ[DeleteCases[allIncompatibleMaterialsRaw, None | Except[None|MaterialP]], {}],
					{None},
					(* otherwise just remove the junk + the None (since don't want None and materials)*)
					DeleteCases[allIncompatibleMaterialsRaw, None | Except[None|MaterialP]]
				]
			]
		],
		{samplePackets, resolvedAssayBuffer, resolvedConcentratedBuffer, resolvedBufferDiluent}
	];


	(* convert any indices of the ContainerOut option to the indexed version of it; this is going to change depending if we have ConsolidateAliquots -> False or True *)
	indexedContainerOut = If[consolidateAliquots,
		(* If we are consolidating aliquots, we only want to expand to the indexed form of this function; don't actually resolve any Automatics *)
		Map[
			Switch[#,
				Automatic, {Automatic, Automatic},
				ObjectP[{Model[Container], Object[Container]}], {Automatic, #},
				_, #
			]&,
			specifiedContainerOut
		],
		(* if we are not consolidating aliquots, we want to resolve the second index to PreferredContainer since everything is a lot simpler in this case *)
		MapThread[
			Function[{specifiedContainerOut, fakeAssayVolume, incompatibleMaterials},
				Switch[specifiedContainerOut,
					Automatic, {Automatic, PreferredContainer[fakeAssayVolume, Sterile -> sterileQ, IncompatibleMaterials -> incompatibleMaterials]},
					ObjectP[{Model[Container], Object[Container]}], {Automatic, specifiedContainerOut},
					{Automatic, Automatic}, {Automatic, PreferredContainer[fakeAssayVolume, Sterile -> sterileQ, IncompatibleMaterials -> incompatibleMaterials]},
					(* importantly, we are NOT worrying about more than one entry with the same index but Automatic _because_ we are not ConsolidateAliquots-ing *)
					(* if a user has ConsolidateAliquots -> False and tries to aliquot two things into the same Automatic vessel, that is just going to be an error below *)
					{_Integer, Automatic}, {specifiedContainerOut[[1]], PreferredContainer[fakeAssayVolume, Sterile -> sterileQ, IncompatibleMaterials -> incompatibleMaterials]},
					_, specifiedContainerOut
				]
			],
			{specifiedContainerOut, fakeAssayVolumes, allIncompatibleMaterials}
		]
	];

	(* get all the listed integer indices in ContainerOut option *)
	specifiedIntegerIndices = Cases[indexedContainerOut[[All, 1]], _Integer];

	(* group the samples (and volume and container information) together for cases where the sample and dilution factor are the same *)
	(* if we're not consolidating aliquots we're just going to make this an empty list because we don't need to do anything in the next big MapThread *)
	(* need to add the Buffer options here too because if you're diluting the same concentration but with different buffers obviously that's an issue *)
	(* also need to group by the specified well *)
	samplesVolumeContainerTuples = If[consolidateAliquots,
		Transpose[{Lookup[#, Object, {}]& /@ samplePackets, fakeAssayVolumes, fakeAmounts, indexedContainerOut, resolvedAssayBuffer, resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedBufferDiluent, specifiedDestWells, allIncompatibleMaterials}],
		{}
	];

	(* grouping by the sample and dilution factor (i.e., the ratio of the assay volume and the volume *)
	(* need to do that weird If call in case there is no volume so we don't divide by zero (and also want to avoid comparing bad units in case it's a solid) *)
	groupedSamplesVolumeContainerTuples = GatherBy[
		samplesVolumeContainerTuples,
		{
			#[[1]],
			If[TrueQ[#[[3]] == 0*Units[#[[3]]]],
				0*Units[#[[3]]],
				#[[2]] / #[[3]]
			],
			#[[5;;8]],
			#[[9]]
		}&
	];

	(* get the consolidated assay volume and volume *)
	consolidatedAssayVolume = If[consolidateAliquots,
		Total[#[[All, 2]]]& /@ groupedSamplesVolumeContainerTuples,
		fakeAssayVolumes
	];
	consolidatedAmount = If[consolidateAliquots,
		Total[#[[All, 3]]]& /@ groupedSamplesVolumeContainerTuples,
		fakeAmounts
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
					resolvedContainerGroupedByIndex, tuplesNoContainerAutomatics, incompatibleMaterials,
					sampleVolumeContainerNoPlatesByContainerTuple, autoToIntegerReplaceRules, incompatibleMaterialsRaw,
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

				(* get the incompatible materials from the grouping *)
				(* need to do it this way because if we have one sample with {None} and one with {Glass}, we can't have {None, Glass} (but if we have only {None} we can't have {} *)
				incompatibleMaterialsRaw = DeleteDuplicates[Flatten[{sampleVolumeContainerValues[[All, 10]]}]];
				incompatibleMaterials = If[MatchQ[DeleteCases[incompatibleMaterialsRaw, None], {}],
					{None},
					DeleteCases[incompatibleMaterialsRaw, None]
				];

				(* get the PreferredContainer for each grouping *)
				preferredVesselByContainersGroupedByIndex = PreferredContainer[#, IncompatibleMaterials -> incompatibleMaterials]& /@ autoContainerGroupingVolumes;

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
								{Automatic, plate:ObjectP[{Object[Container, Plate], Model[Container, Plate]}]} :> {Automatic, plate},
								{Automatic, container:ObjectP[{Object[Container], Model[Container]}]} :> {index, container}

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

	(* For when we are NOT consolidating aliquots, convert all the non-plate-automatics to Unique *)
	nonConsolidatedAliquotsNoVesselAutomatics = If[consolidateAliquots,
		{},
		Map[
			If[MatchQ[#[[1]], Automatic] && MatchQ[#[[2]], nonPlateContainerP],
				{Unique[], #[[2]]},
				#
			]&,
			indexedContainerOut
		]
	];

	(* get the pre-resolved ContainersOut; we have Uniques[] in here for Vessels but still Automatics for plates; at this point we've converged between whether or not we are consolidating aliquots *)
	preResolvedContainerOut = If[consolidateAliquots,
		ReplacePart[samplesVolumeContainerTuples, reorderingReplaceRules],
		nonConsolidatedAliquotsNoVesselAutomatics
	];

	(* get the container or model container packets for all the pre-resolved containers out *)
	preResolvedContainerOutWithPackets = Map[
		Function[{indexAndContainerOut},
			If[MatchQ[indexAndContainerOut[[2]], ObjectP[Model[Container]]],
				SelectFirst[Flatten[{containerOutModelPackets, preferredVesselPackets}], MatchQ[#, ObjectP[indexAndContainerOut[[2]]]]&],
				SelectFirst[containerOutPackets, MatchQ[#, ObjectP[indexAndContainerOut[[2]]]]&]
			]
		],
		preResolvedContainerOut
	];

	(* get the model packets for these containers/models from the destinations *)
	destinationContainerModelPackets = Map[
		Function[{containerOrModel},
			(* a little tricky to get the container model packet from the container object; basically need to do two different SelectFirsts *)
			If[MatchQ[containerOrModel, ObjectReferenceP[Object[Container]]],
				With[{containerPacket = SelectFirst[containerOutPackets, MatchQ[#, ObjectP[containerOrModel]]&]},
					SelectFirst[Flatten[{containerOutModelPackets, preferredVesselPackets}], MatchQ[#, ObjectP[Download[Lookup[containerPacket, Model], Object]]]&]
				],
				SelectFirst[Flatten[{containerOutModelPackets, preferredVesselPackets}], MatchQ[#, ObjectP[containerOrModel]]&]
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
		Function[{containerPacket, allWells},
			Switch[containerPacket,
				ObjectP[Model[Container, Plate]], allWells,
				ObjectP[Object[Container, Plate]], DeleteCases[allWells, Alternatives @@ (Lookup[containerPacket, Contents][[All, 1]])],
				_, allWells
			]
		],
		{preResolvedContainerOutWithPackets, allWellsForContainerOut}
	];

	(* get the DestinationWell specifications that are invalid  *)
	invalidDestWellBools = MapThread[
		Not[MemberQ[#1, #2]] && Not[MatchQ[#2, Automatic]]&,
		{allWellsForContainerOut, specifiedDestWells}
	];
	invalidDestWellSpecs = PickList[specifiedDestWells, invalidDestWellBools];
	invalidDestWellContainerOut = PickList[Lookup[preResolvedContainerOutWithPackets, Object], invalidDestWellBools];

	(* throw an error if there are any DestinationWell specifications that don't exist for the corresponding ContainerOut *)
	invalidDestWellOptions = If[Not[MatchQ[invalidDestWellSpecs, {}]] && messages,
		(
			Message[Error::DestinationWellDoesntExist, DestinationWell, invalidDestWellSpecs, ContainerOut, invalidDestWellContainerOut];
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
				ObjectP[Object[Container, Plate]], Lookup[SelectFirst[containerOutModelPackets, MatchQ[#, ObjectP[Lookup[containerPacket, Model]]]&], NumberOfWells],
				_, 1
			]
		],
		preResolvedContainerOutWithPackets
	];

	(* get the number of wells in each container (accounting for plates with things already in them; subtract how many plates there could be there) *)
	numWells = MapThread[
		Function[{containerPacket, maxNumWell},
			If[MatchQ[containerPacket, ObjectP[Object[Container, Plate]]],
				maxNumWell - Length[Lookup[containerPacket, Contents]],
				maxNumWell
			]
		],
		{preResolvedContainerOutWithPackets, maxNumWells}
	];

	(* make replace rules whereby a given pairing gets converted to open wells for that pairing as well as the specified destination wells *)
	openWellsReplaceRules = AssociationThread[preResolvedContainerOut, allOpenWellsForContainerOut];
	specifiedDestWellReplaceRules = AssociationThread[preResolvedContainerOut, specifiedDestWells];

	(* group the samples volumes and pre-resolved containers together again like we did above, except this time we're taking plates into account below *)
	(* need to tack the Unique[]s on the end there for weird Gather/ReplacPart-ing stuff I do below *)
	samplesVolumePreResolvedContainerTuples = Transpose[{Lookup[#, Object, {}]& /@ samplePackets, fakeAssayVolumes, fakeAmounts, preResolvedContainerOut, resolvedAssayBuffer, resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedBufferDiluent, specifiedDestWells, Table[Unique[], Length[specifiedDestWells]]}];

	(* Group the pre resolved containers out by what they are, being sure to Download object to ensure we group properly *)
	(* the rest of the stuff we're including (the samples and volumes) is for use later potentially if we're consolidating aliquots *)
	groupedPreResolvedContainerOut = GatherBy[samplesVolumePreResolvedContainerTuples, {#[[4, 1]], Download[#[[4, 2]], Object]}&];

	(* get the positions of the pre resolved containers out *)
	positionsOfPreResolvedContainerOut = Position[samplesVolumePreResolvedContainerTuples, #]& /@ Alternatives @@@ groupedPreResolvedContainerOut;

	(* get the open wells per grouping *)
	openWellsPerGrouping = Map[
		Replace[#[[1,4]], openWellsReplaceRules, {0}]&,
		groupedPreResolvedContainerOut
	];

	(* get the specified destination wells per grouping *)
	specifiedDestWellsPerGrouping = Map[
		Replace[#[[1,4]], specifiedDestWellReplaceRules, {0}]&,
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

				(* this GatherBy call is different depending on whether ConsolidateAliquots -> True *)
				(* if ConsolidateAliquots -> True, the following: *)
				(* gather the sample/volume/assay volume/containers by cases of the source sample and ratio of volume / assay volume being the same *)
				(* also the buffer needs to be the same *)
				(* also the specified well needs to be the same (or Automatic and not specified) *)
				(* if ConsolidateAliquots -> False, we ONLY care about gathering by destination well *)
				gatheredSampleVolumeContainers = If[consolidateAliquots,
					GatherBy[
						groupedContainers,
						{
							#[[1]],
							If[TrueQ[#[[3]] == 0*Units[#[[3]]]],
								0*Units[#[[3]]],
								#[[2]] / #[[3]]
							],
							#[[5;;8]],
							#[[9]]
						}&
					],
					GatherBy[groupedContainers, If[MatchQ[#[[9]], Automatic], Unique[], #[[9]]]&]
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
					Partition[gatheredSampleVolumeContainers[[All, 1, 9]], UpTo[Length[emptyWells]]],
					{gatheredSampleVolumeContainers[[All, 1, 9]]}
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

	(* make labels for the resolved containers out*)
	containerOutLabelReplaceRules = Map[
		# -> CreateUniqueLabel["aliquot container out"]&,
		DeleteDuplicates[resolvedContainerOut]
	];
	resolvedContainerOutLabel = MapThread[
		Function[{containerOut, containerOutLabel},
			If[Not[MatchQ[containerOutLabel, Automatic]],
				containerOutLabel,
				containerOut /. containerOutLabelReplaceRules
			]
		],
		{resolvedContainerOut, Lookup[myOptions, ContainerOutLabel]}
	];

	(* make labels for the things that will become the SamplesOut *)
	sampleOutLabelReplaceRules = Map[
		# -> CreateUniqueLabel["aliquot sample out"]&,
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
		AssayBuffer -> resolvedAssayBuffer,
		ConcentratedBuffer -> resolvedConcentratedBuffer,
		BufferDiluent -> resolvedBufferDiluent,
		BufferDilutionFactor -> resolvedBufferDilutionFactor,
		DestinationWell -> resolvedDestWells,
		ContainerOut -> resolvedContainerOut,
		Amount -> resolvedAmount,
		AssayVolume -> resolvedAssayVolume,
		ConsolidateAliquots -> consolidateAliquots,
		Preparation -> Lookup[roundedOptionsAssoc, Preparation],

		SourceLabel -> resolvedSampleLabel,
		SourceContainerLabel -> resolvedSampleContainerLabel,
		SampleOutLabel -> resolvedSampleOutLabel,
		ContainerOutLabel -> resolvedContainerOutLabel,
		AssayBufferLabel -> resolvedAssayBufferLabel,
		ConcentratedBufferLabel -> resolvedConcentratedBufferLabel,
		BufferDiluentLabel -> resolvedBufferDiluentLabel
	};

	(* get all the inputs and options needed for resolveTransferMethod *)
	{
		samplesToTransferNoZeroes,
		destinationsToTransferToNoZeroes,
		destinationWellsToTransferToNoZeroes,
		amountsToTransferNoZeroes
	} = convertAliquotToTransferSteps[samplePackets, fakeResolvedOptions];

	(* figure out if it could be micro or not *)
	(* if we have solids to transfer automatically going to have Manual only *)
	(* if we somehow have no samples to transfer (because resolution went poorly and errors were thrown above), just pick Manual *)
	potentialMethods = Which[
		MatchQ[amountsToTransferNoZeroes, {}], {Manual},
		MemberQ[amountsToTransferNoZeroes, MassP | CountP | UnitsP[Unit]], {Manual},
		True,
			resolveTransferMethod[
				samplesToTransferNoZeroes,
				(* When resolving ContainersOut, we always put an index before the container for easy processing. However, Object[Container] is already a unique object and resolveTransferMethod is not expecting an index before the container *)
				destinationsToTransferToNoZeroes/.({_Integer,container:ObjectP[Object[Container]]}:>container),
				amountsToTransferNoZeroes,
				DestinationWell -> destinationWellsToTransferToNoZeroes,
				Cache -> inheritedCache,
				Simulation -> simulation
			]
	];
	couldBeMicroQ = MemberQ[potentialMethods, Robotic];

	(* resolve the Preparation option *)
	preparation = Which[
		Not[MatchQ[Lookup[roundedOptionsAssoc, Preparation], Automatic]], Lookup[roundedOptionsAssoc, Preparation],
		couldBeMicroQ, Robotic,
		True, Manual
	];

	(* Resolve the work cell that we're going to operator on. *)
	allowedWorkCells = resolveAliquotWorkCell[Flatten[mySamples], {Preparation -> preparation, Simulation -> simulation, Cache -> inheritedCache, Output -> Result}];

	workCell = FirstOrDefault[allowedWorkCells];

	(* throw an error if the liquid handler is set to Micro but it can't be *)
	preparationInvalidOptions = If[MatchQ[preparation, Robotic] && Not[couldBeMicroQ] && messages,
		(
			Message[Error::PreparationInvalid];
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

	(* --- Make sure the same index doesn't apply to different models --- *)

	(* group the resolved containers out by index; need to include other stuff because of the ConsolidateAliquots-with-plates case *)
	resolvedContainerOutGroupedByIndex = GatherBy[Transpose[{Lookup[#, Object, {}]& /@ samplePackets, fakeAssayVolumes, fakeAmounts, resolvedContainerOut, resolvedAssayBuffer, resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedBufferDiluent}], #[[4, 1]]&];

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
		Test["The specified ContainerOut indices do not refer to multpile containers at once:",
			MatchQ[invalidContainerOutSpecs, {}],
			True
		]
	];

	(* get the number of wells that need to be reserved for each index grouping *)
	(* this is kind of complicated because ConsolidateAliquots in plates could put things in the same well or the same plate with different wells *)
	(* thus, I need to separate out these cases *)
	(* if we're not consolidating aliquots its muchs simpler *)
	numReservedWellsPerIndex = Map[
		Function[{sampleVolumeContainerTuple},
			If[consolidateAliquots,
				Length[GatherBy[
					sampleVolumeContainerTuple,
					{
						#[[1]],
						If[TrueQ[#[[3]] == 0*Units[#[[3]]]],
							0*Units[#[[3]]],
							#[[2]] / #[[3]]
						],
						#[[5;;8]]
					}&
				]],
				Length[sampleVolumeContainerTuple]
			]
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
	(* the two cases where over-specifying isn't allowed are *)
	(* 1.) If ConsolidateAliquots -> False and there are more wells occupied than exist for the container *)
	(* 2.) If ConsolidateAliquots -> True and we're using a plate but we still are occupying more than the allowed number of wells *)
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

	(* transpose together the sample packets, fakeAssayVolumes, fakeAmounts, resolvedContainerOut, and MaxVolumes *)
	containerMaxVolumeAssayVolumes = Transpose[{Lookup[#, Object, {}]& /@ samplePackets, fakeAssayVolumes, fakeAmounts, resolvedContainerOut, maxVolumes, resolvedDestWells}];

	(* gather these by the ContainerOut *)
	containerMaxVolumeAssayVolumesGroupedByIndex = GatherBy[containerMaxVolumeAssayVolumes, #[[4,1]]&];

	(* we need to need to group by what well/container a given sample is going to be put in *)
	maxVolumeGroupedByConsolidatedAliquots = Map[
		Function[{maxVolumeTuples},
			GatherBy[
				maxVolumeTuples,
				{
					#[[1]],
					#[[6]]
				}&
			]
		],
		containerMaxVolumeAssayVolumesGroupedByIndex
	];

	(* get the volume going into each given position and also the MaxVolume *)
	(* need the Join @@ to remove one of the levels of listiness *)
	totalVolumeEachIndex = Join @@ Map[
		Total[#[[All, 2]]]&,
		maxVolumeGroupedByConsolidatedAliquots,
		{2}
	];
	maxVolumeEachIndex = Join @@ Map[
		#[[1, 5]]&,
		maxVolumeGroupedByConsolidatedAliquots,
		{2}
	];

	(* if we are using plates, then I need to make sure _each_ sample's assay volume is more than the MaxVolume; otherwise, need to use the combined amount *)
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

	(* get the ContainersOut, Combined AssayVolume, and container MaxVolume for containers where the assay volume is too high *)
	(* need to do the Join @@ to get rid of some of the extra listiness *)
	volumeTooHighContainerOut = PickList[Join @@ maxVolumeGroupedByConsolidatedAliquots[[All, All, 1, 4, 2]], tooMuchVolumeQ, True];
	volumeTooHighAssayVolume = PickList[totalVolumeEachIndex, tooMuchVolumeQ, True];
	volumeTooHighMaxVolume = PickList[maxVolumeEachIndex, tooMuchVolumeQ, True];

	(* throw an error if the AssayVolume is greater than the max volume of the ContainerOut *)
	volumeOverContainerMaxOptions = If[Not[MatchQ[volumeTooHighContainerOut, {}]] && messages,
		(
			Message[Error::VolumeOverContainerMax, UnitScale[volumeTooHighAssayVolume, Simplify -> False], volumeTooHighContainerOut, volumeTooHighMaxVolume];
			{ContainerOut}
		),
		{}
	];

	(* make a test to ensure that ContainerOut isn't too small *)
	volumeOverContainerMaxTest = If[gatherTests,
		Test["The resolved AssayVolume is less than or equal to the MaxVolume of the specified ContainerOut:",
			MatchQ[volumeTooHighContainerOut, {}],
			True
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[
		ReplaceRule[myOptions, Preparation -> preparation],
		Living -> MemberQ[Lookup[Flatten[samplePackets], Living], True]
	];

	(* combine all the invalid options *)
	invalidOptions = DeleteDuplicates[Join[
		nameInvalidOptions,
		bufferDilutionMismatchOptions,
		overspecifiedBufferInvalidOptions,
		emptyContainerInvalidOptions,
		aliquotVolumeToolargeOptions,
		invalidMinOptions,
		noConcentrationOptions,
		targetConcentrationTooLargeOptions,
		concentrationRatioMismatchOptions,
		preparationInvalidOptions,
		containerOutMismatchedIndexOptions,
		invalidDestWellOptions,
		containerOverOccupiedOptions,
		volumeOverContainerMaxOptions,
		noMolecularWeightInvalidOptions,
		stateAmountMismatchOptions,
		pooledVolumeAboveAssayVolumeOptions,
		cannotResolveAssayVolumeOptions,
		bufferTooConcentratedOptions,
		overMaxVolumeOptions
	]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* combine the invalid inputs *)
	invalidInputs = DeleteDuplicates[Join[
		discardedInvalidInputs,
		deprecatedInvalidInputs,
		cannotResolveVolumeInvalidInputs
	]];

	(* throw the InvalidInputs error if necessary *)
	If[Not[MatchQ[invalidInputs, {}]] && messages,
		Message[Error::InvalidInput, invalidInputs]
	];

	(* gather all the tests together *)
	allTests = Cases[Flatten[{
		discardedTest,
		deprecatedTest,
		validNameTest,
		bufferDilutionInvalidTest,
		overspecifiedBufferInvalidTest,
		emptyContainerTests,
		cannotResolveVolumeTests,
		aliquotVolumeTooLargeTest,
		invalidMinTest,
		potentialAnalyteTests,
		noConcentrationTest,
		targetConcentrationTooLargeTest,
		concentrationRatioMismatchTest,
		noBufferWithBufferTest,
		totalAliquotVolumeTooLargeTest,
		preparationInvalidTest,
		containerOutMismatchedIndexTest,
		invalidDestWellTest,
		containerOverOccupiedTest,
		volumeOverContainerMaxTest,
		unknownAmountWarningTests,
		noMolecularWeightTests,
		stateAmountMismatchTests,
		targetConcNotUsedTests,
		pooledVolumeAboveAssayVolumeTest,
		cannotResolveAssayVolumeTest,
		pooledConsolidateAliquotsWarning,
		bufferTooConcentratedTests,
		overMaxVolumeTests
	}], _EmeraldTest];

	(* --- Do the final preparations --- *)

	(* get the final resolved options (pre-collapsed; that is happening outside the function) *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Amount -> resolvedAmount,
			TargetConcentration -> resolvedTargetConcentration,
			TargetConcentrationAnalyte -> potentialAnalytesToUse,
			(* returning a too-high value will break command builder, but we still want to throw messages for the too-high value which is why we didn't do this Min call above *)
			AssayVolume -> (If[VolumeQ[#], Min[{#, $MaxTransferVolume}], #] & /@ resolvedAssayVolume),
			ContainerOut -> resolvedContainerOut,
			DestinationWell -> resolvedDestWells,
			ConcentratedBuffer -> resolvedConcentratedBuffer,
			BufferDilutionFactor -> resolvedBufferDilutionFactor,
			BufferDiluent -> resolvedBufferDiluent,
			AssayBuffer -> resolvedAssayBuffer,
			ConsolidateAliquots -> specifiedConsolidateAliquots,
			Preparation -> preparation,
			WorkCell -> workCell,
			Confirm -> confirm,
			CanaryBranch -> canaryBranch,
			Name -> name,
			Template -> template,
			SamplesInStorageCondition -> samplesInStorageCondition,
			SamplesOutStorageCondition -> samplesOutStorageCondition,
			SourceLabel -> resolvedSampleLabel,
			SourceContainerLabel -> resolvedSampleContainerLabel,
			SampleOutLabel -> resolvedSampleOutLabel,
			ContainerOutLabel -> resolvedContainerOutLabel,
			ConcentratedBufferLabel -> resolvedConcentratedBufferLabel,
			BufferDiluentLabel -> resolvedBufferDiluentLabel,
			AssayBufferLabel -> resolvedAssayBufferLabel,
			ResolveMethod -> resolveMethod,
			Cache -> cache,
			Email -> email,
			FastTrack -> fastTrack,
			Operator -> operator,
			Output -> outputOption,
			ParentProtocol -> parentProtocol,
			Upload -> upload,
			EnableSamplePreparation -> samplePrep,
			resolvedPostProcessingOptions
		}]
	];

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
	outputSpecification /. {resultRule,testsRule}

];


(* ::Subsubsection::Closed:: *)
(*aliquotResourcePackets *)

DefineOptions[
	aliquotResourcePackets,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

(* function to populate the fields of this aliquot protocol and make all the resources *)
(* importantly, this calls ExperimentRoboticSamplePreparation/ExperimentManualSamplePreparation *)
aliquotResourcePackets[mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, ops:OptionsPattern[aliquotResourcePackets]]:=Module[
	{expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, resolvedConcentratedBuffer, resolvedAssayBuffer,
		resolvedBufferDiluent, allBufferModels, allBufferObjs, containerOutModels,
		containerOutObjs, outputSpecification, output, gatherTests, messages, inheritedCache,
		samplePackets, sampleContainerPackets, sampleContainerModelPackets, bufferObjectPackets, bufferModelPackets,
		bufferContainerPackets, bufferContainerModelPackets, containerOutPackets, containerOutModelPackets,
		resolvedAssayVolume, resolvedContainerOut, resolvedContainerOutWithPacket,
		protocolPackets, protocolTests, previewRule, optionsRule, testsRule, resultRule,
		consolidateAliquots, resolvedDestWell, pooledQ, resolvedAmount, specifiedConsolidateAliquots, sampleOutLabel,
		expandedNonListedOptions, poolingShapes, allUnitOperationPackets, roboticRunTime, updatedSimulation,
		sourceLabel, sourceContainerLabel, containerOutLabel, resolvedPreparation, resolvedWorkCell, sourcesToTransfer,
		destinationsToTransferTo, expandedDestWells, amountsToTransfer, resolvedAmountNoAll,
		assayBufferLabel, bufferDiluentLabel, concentratedBufferLabel, simulationRule, uoPacketsAndRunTime,
		allPrimitives, experimentFunction, simulatedObjectsToLabel,expandedResolvedOptionsWithLabels,
		protPacket, accessoryProtPackets, aliquotUnitOperationBlobs, modelExchangedInputs, uniqueSamplesInResources,
		samplesInResources, protPacketFinal, simulation, aliquotUnitOperationPackets, aliquotUnitOperationPacketsNotLinked,
		samplesOutLabels, unsortedFutureLabeledObjects, unsortedSampleOutFutureLabeledObjects,
		sortedSampleOutFutureLabeledObjects, sortedFutureLabeledObjects, finalSimulation},

	(* expand the resolved options if they weren't expanded already *)
	expandedNonListedOptions = Last[ExpandIndexMatchedInputs[ExperimentAliquot, {mySamples}, myResolvedOptions, 6]];

	(* make sure the inputs and the options are listy in the proper right *)
	expandedResolvedOptions = ReplaceRule[expandedNonListedOptions, {Amount -> (ToList[#]& /@ Lookup[expandedNonListedOptions, Amount]), TargetConcentration -> (ToList[#]& /@ Lookup[expandedNonListedOptions, TargetConcentration])}];
	expandedInputs = ToList[#]& /@ mySamples;

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentAliquot,
		RemoveHiddenOptions[ExperimentAliquot, expandedResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* pull out the Output option and make it a list *)
	outputSpecification = Lookup[expandedResolvedOptions, Output];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* get the inherited cache and simulation *)
	{inheritedCache, simulation} = Lookup[SafeOptions[aliquotResourcePackets, ToList[ops]], {Cache, Simulation}];

	(* --- Make our one big Download call --- *)

	(* pull out the ConcentratedBuffer, AssayBuffer, BufferDiluent, and ContainerOut options *)
	{
		resolvedConcentratedBuffer,
		resolvedAssayBuffer,
		resolvedBufferDiluent,
		resolvedContainerOut,
		specifiedConsolidateAliquots
	} = Lookup[expandedResolvedOptions, {ConcentratedBuffer, AssayBuffer, BufferDiluent, ContainerOut, ConsolidateAliquots}];

	(* get all the buffers that were specified as models and objects *)
	allBufferModels = Cases[Flatten[{resolvedConcentratedBuffer, resolvedAssayBuffer, resolvedBufferDiluent}], ObjectP[Model[Sample]]];
	allBufferObjs = Cases[Flatten[{resolvedConcentratedBuffer, resolvedAssayBuffer, resolvedBufferDiluent}], ObjectP[Object[Sample]]];

	(* get all the ContainerOut models and objects *)
	containerOutModels = Cases[Flatten[ToList[resolvedContainerOut]], ObjectP[Model[Container]]];
	containerOutObjs = Cases[Flatten[ToList[resolvedContainerOut]], ObjectP[Object[Container]]];

	(* get the shape of the sample inputs *)
	poolingShapes = Length[#]& /@ expandedInputs;

	(* pull out all the sample/sample model/container/container model packets *)
	samplePackets = TakeList[fetchPacketFromCache[#, inheritedCache]& /@ Download[Flatten[mySamples], Object], poolingShapes];
	sampleContainerPackets = TakeList[fetchPacketFromCache[#, inheritedCache]& /@ Lookup[Flatten[samplePackets], Container, {}], poolingShapes];
	sampleContainerModelPackets = TakeList[fetchPacketFromCache[#, inheritedCache]& /@ Lookup[Flatten[sampleContainerPackets], Model, {}], poolingShapes];

	(* get all the buffer object/model/container/container model packets *)
	(* note that the bufferObjectPackets and bufferModelPackets don't have to be the same length *)
	bufferObjectPackets = fetchPacketFromCache[#, inheritedCache]& /@ allBufferObjs;
	bufferModelPackets = Flatten[{
		fetchPacketFromCache[#, inheritedCache]& /@ Lookup[bufferObjectPackets, Model, {}],
		fetchPacketFromCache[#, inheritedCache]& /@ allBufferModels
	}];
	bufferContainerPackets = fetchPacketFromCache[#, inheritedCache]& /@ Lookup[bufferObjectPackets, Container, {}];
	bufferContainerModelPackets = fetchPacketFromCache[#, inheritedCache]& /@ Lookup[bufferContainerPackets, Model, {}];

	(* get the ContainerOut object and model packets (again like with the buffers, these two don't have to be the same length) *)
	containerOutPackets = fetchPacketFromCache[#, inheritedCache]& /@ containerOutObjs;
	containerOutModelPackets = Flatten[{
		fetchPacketFromCache[#, inheritedCache]& /@ containerOutModels,
		fetchPacketFromCache[#, inheritedCache]& /@ Lookup[containerOutPackets, Model, {}]
	}];

	(* --- Make all the transfer manipulations of the samples --- *)

	(* figure out if we're pooling (defined here as having two or more things in the same input) *)
	pooledQ = MemberQ[poolingShapes, GreaterP[1]];

	(* note that we're ignoring the ConsolidateAliquots option if we're pooling; we threw the message in the resolver*)
	consolidateAliquots = If[pooledQ,
		False,
		specifiedConsolidateAliquots
	];

	(* pull out the ContainerOut option *)
	{
		resolvedPreparation,
		resolvedWorkCell,
		resolvedDestWell,
		resolvedAssayVolume,
		resolvedAmount
	} = Lookup[
		expandedResolvedOptions,
		{
			Preparation,
			WorkCell,
			DestinationWell,
			AssayVolume,
			Amount
		}
	];

	(* get amount with no All *)
	resolvedAmountNoAll = MapThread[
		Function[{samplePacketsInPool, amountsInPool},
			MapThread[
				If[MatchQ[#2, All],
					Lookup[#1, Volume],
					#2
				]&,
				{samplePacketsInPool, amountsInPool}
			]
		],
		{samplePackets, resolvedAmount}
	];

	(* get the resolved container out with packets instead of objects *)
	resolvedContainerOutWithPacket = Map[
		Function[{indexAndContainer},
			{indexAndContainer[[1]], SelectFirst[Flatten[{containerOutPackets, containerOutModelPackets}], MatchQ[#, ObjectP[indexAndContainer[[2]]]]&]}
		],
		resolvedContainerOut
	];


	(* pull out the label options here because we'll be using them a lot *)
	{
		sourceLabel,
		sourceContainerLabel,
		sampleOutLabel,
		containerOutLabel,
		assayBufferLabel,
		bufferDiluentLabel,
		concentratedBufferLabel
	} = Lookup[
		expandedResolvedOptions,
		{
			SourceLabel,
			SourceContainerLabel,
			SampleOutLabel,
			ContainerOutLabel,
			AssayBufferLabel,
			BufferDiluentLabel,
			ConcentratedBufferLabel
		}
	];

	(* convert the inputs and resolved options into a list of inputs for the Transfer primitive *)
	(* Label -> True is important because it meshes well with the LabelSample/LabelContainer calls going into the Experiment call below *)
	{
		sourcesToTransfer,
		destinationsToTransferTo,
		expandedDestWells,
		amountsToTransfer
	} = convertAliquotToTransferSteps[samplePackets, expandedResolvedOptions, Label -> True];

	(* make the actual primitives we're going to be using *)
	(* if we have model inputs, we need to mess with the labels a little bit so that we don't get overwriting label messages *)
	{allPrimitives, updatedSimulation} = convertTransferStepsToPrimitives[
		samplePackets,
		sourcesToTransfer,
		destinationsToTransferTo,
		expandedDestWells,
		amountsToTransfer,
		expandedResolvedOptions,
		Cache -> inheritedCache,
		Simulation -> simulation
	];

	(* Create Resources for input sample *)
	(* We need resources here if our samples are simulated as we cannot upload non-existing IDs to the Sample field of the Resuspend/Dilute UO *)
	(* By providing resources, the fields points back to the original model, if necessary *)
	(* We only use this for RSP Dilute/Resuspend UO, which basically means we won't do resource picking on these directly. *)
	(* Create a lookup of each unique sample to a resource of that sample *)
	uniqueSamplesInResources = (# -> Resource[Sample -> #, Name -> CreateUUID[]]&) /@ DeleteDuplicates[Flatten[expandedInputs]];

	(* Use the lookup to create a flat resource list *)
	(* note that we are only using these resources if we are _not_ in _LabelSample land *)
	(* this is because if we have a simulated sample that is just in sequence with a bunch of normal UOs, then we need to make resources (but if we're using model inputs, it shouldn't be necessary I think (?)) *)
	samplesInResources = (expandedInputs) /. uniqueSamplesInResources;

	(* get the expanded inputs converted to models *)
	modelExchangedInputs = If[MatchQ[First[allPrimitives], _LabelSample],
		simulatedSamplesToModels[
			First[allPrimitives],
			simulation,
			expandedInputs
		],
		samplesInResources
	];

	(* Resolve the experiment function (MSP/RSP/MCP/RCP) to call using the shared helper function *)
	experimentFunction = If[MatchQ[resolvedPreparation, Manual],
		resolveManualFrameworkFunction[Flatten[{modelExchangedInputs}], myResolvedOptions, Cache -> inheritedCache, Simulation -> updatedSimulation, Output -> Function],
		Lookup[$WorkCellToExperimentFunction, resolvedWorkCell]
	];

	(* --- get the unit operation packets for the UOs made above; need to replicate what ExperimentRoboticSamplePreparation does if that is what is happening (otherwise just do nothing) ---*)

	(* make unit operation packets for the UOs we just made here *)
	{uoPacketsAndRunTime, updatedSimulation} = If[MatchQ[resolvedPreparation, Manual],
		{{{},Null}, updatedSimulation},
		experimentFunction[
			allPrimitives,
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
		]
	];
	{allUnitOperationPackets,roboticRunTime} = If[MatchQ[uoPacketsAndRunTime, $Failed],
		{$Failed, Null},
		uoPacketsAndRunTime
	];

	(* determine which objects in the simulation are simulated and make replace rules for those *)
	simulatedObjectsToLabel = If[NullQ[updatedSimulation],
		{},
		Module[{allObjectsInSimulation, simulatedQ},
			(* Get all objects out of our simulation. *)
			allObjectsInSimulation = Download[Lookup[updatedSimulation[[1]], Labels][[All, 2]], Object];

			(* Figure out which objects are simulated. *)
			simulatedQ = Experiment`Private`simulatedObjectQs[allObjectsInSimulation, updatedSimulation];

			(Reverse /@ PickList[Lookup[updatedSimulation[[1]], Labels], simulatedQ]) /. {link_Link :> Download[link, Object]}
		]
	];

	(* get the resolved options with simulated objects replaced with labels *)
	expandedResolvedOptionsWithLabels = expandedResolvedOptions /. simulatedObjectsToLabel;

	(* make the aliquot unit operation blob *)
	aliquotUnitOperationBlobs = If[MatchQ[resolvedPreparation, Robotic],
		Aliquot[
			Source -> modelExchangedInputs,
			SourceLabel -> Lookup[expandedResolvedOptionsWithLabels, SourceLabel],
			SourceContainerLabel -> Lookup[expandedResolvedOptionsWithLabels, SourceContainerLabel],
			SampleOutLabel -> Lookup[expandedResolvedOptionsWithLabels, SampleOutLabel],
			ContainerOutLabel -> Lookup[expandedResolvedOptionsWithLabels, ContainerOutLabel],
			AssayBufferLabel -> Lookup[expandedResolvedOptionsWithLabels, AssayBufferLabel],
			ConcentratedBufferLabel -> Lookup[expandedResolvedOptionsWithLabels, ConcentratedBufferLabel],
			BufferDiluentLabel -> Lookup[expandedResolvedOptionsWithLabels, BufferDiluentLabel],
			Amount -> Lookup[expandedResolvedOptionsWithLabels, Amount],
			TargetConcentration -> Lookup[expandedResolvedOptionsWithLabels, TargetConcentration],
			TargetConcentrationAnalyte -> Lookup[expandedResolvedOptionsWithLabels, TargetConcentrationAnalyte],
			AssayVolume -> Lookup[expandedResolvedOptionsWithLabels, AssayVolume],
			ContainerOut -> Lookup[expandedResolvedOptionsWithLabels, ContainerOut],
			DestinationWell -> Lookup[expandedResolvedOptionsWithLabels, DestinationWell],
			ConcentratedBuffer -> Lookup[expandedResolvedOptionsWithLabels, ConcentratedBuffer],
			BufferDilutionFactor -> Lookup[expandedResolvedOptionsWithLabels, BufferDilutionFactor],
			BufferDiluent -> Lookup[expandedResolvedOptionsWithLabels, BufferDiluent],
			AssayBuffer -> Lookup[expandedResolvedOptionsWithLabels, AssayBuffer],
			ConsolidateAliquots -> Lookup[expandedResolvedOptionsWithLabels, ConsolidateAliquots],
			SamplesInStorageCondition -> Lookup[expandedResolvedOptionsWithLabels, SamplesInStorageCondition],
			SamplesOutStorageCondition -> Lookup[expandedResolvedOptionsWithLabels, SamplesOutStorageCondition],
			Preparation -> resolvedPreparation,
			WorkCell -> resolvedWorkCell
		]
	];

	(* if we're doing robotic sample preparation, then make unit operation packets for the aliquot blob *)
	aliquotUnitOperationPacketsNotLinked = If[MatchQ[experimentFunction, ExperimentRoboticSamplePreparation|ExperimentRoboticCellPreparation],
		UploadUnitOperation[
			aliquotUnitOperationBlobs,
			UnitOperationType -> Input,
			FastTrack -> True,
			Upload -> False
		],
		Null
	];


	(* link the transfer unit operations to the aliquot one *)
	aliquotUnitOperationPackets = If[NullQ[aliquotUnitOperationPacketsNotLinked] || MatchQ[allUnitOperationPackets, $Failed],
		Null,
		Join[
			aliquotUnitOperationPacketsNotLinked,
			<|
				Replace[RoboticUnitOperations] -> Link[Lookup[allUnitOperationPackets, Object]]
			|>
		]
	];

	(* since we are putting this Aliquot inside RSP, we should re-do the LabelFields so they link via RoboticUnitOperations *)
	updatedSimulation=updateLabelFieldReferences[updatedSimulation,RoboticUnitOperations];


	{protocolPackets, finalSimulation, protocolTests} = Which[
		MatchQ[experimentFunction, ExperimentRoboticSamplePreparation|ExperimentRoboticCellPreparation], {Flatten[{Null, aliquotUnitOperationPackets, allUnitOperationPackets}], updatedSimulation, {}},
		gatherTests,
			experimentFunction[
				allPrimitives,
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
			],
		True,
			{
				Sequence @@ experimentFunction[
					allPrimitives,
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
				],
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
				SelectFirst[unsortedSampleOutFutureLabeledObjects, MatchQ[First[#], label]&]
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
				ResolvedOptions -> DeleteCases[expandedResolvedOptions, (Verbatim[Cache] -> _) | (Verbatim[Simulation] -> _)],
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
		Flatten[{protPacketFinal, accessoryProtPackets}],
		$Failed
	];

	(* generate the simulation rule *)
	simulationRule = Simulation -> finalSimulation;

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule, simulationRule}

];



(* ::Subsubsection::Closed:: *)
(*shortcutAliquotResourcePackets *)

DefineOptions[
	shortcutAliquotResourcePackets,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

(* function _just_ to make the resources and call fulfillableResourceQ on them *)
shortcutAliquotResourcePackets[mySamples:{ListableP[ObjectP[Object[Sample]]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, ops:OptionsPattern[aliquotResourcePackets]]:=Module[
	{
		outputSpecification, output, amount, assayVolume, assayBuffer, concentratedBuffer, bufferDilutionFactor, bufferDiluent,
		cache, sampleAmountRules, sampleResources, bufferVolumes, splitBufferVolumes, bufferVolumeRules, bufferResources,
		allResources, fulfillable, frqTests, protocolType, simulatedProtocolPacket, gatherTests, resultRule, testsRule, preparation,
		workCell, simulation
	},

	(* pull out the Output option *)
	outputSpecification = Lookup[myResolvedOptions, Output];
	output = ToList[outputSpecification];
	gatherTests = MemberQ[output, Tests];

	(* pull out the cache *)
	{cache, simulation} = Lookup[SafeOptions[shortcutAliquotResourcePackets, ToList[ops]], {Cache, Simulation}, {}];

	(* pull out the relevant options for what I'm doing below *)
	{
		amount,
		assayVolume,
		assayBuffer,
		concentratedBuffer,
		bufferDilutionFactor,
		bufferDiluent,
		preparation,
		workCell
	} = Lookup[
		myResolvedOptions,
		{
			Amount,
			AssayVolume,
			AssayBuffer,
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
	(* if we're adding more than AssayVolume that should have already been caught, but just default to 0 in case *)
	(* need to do the Total[ToList[#1]] thing because of pooling *)
	bufferVolumes = MapThread[
		With[{pooledVolumeAmount = Total[Cases[ToList[#1], VolumeP]]},
			If[VolumeQ[pooledVolumeAmount],
				Max[{#2 - pooledVolumeAmount, 0 Liter}],
				#2
			]
		]&,
		{amount, assayVolume}
	];

	(* get the volume of the AssayBuffer (if using that) or the ConcentratedBuffer/BufferDiluent (if using that) *)
	splitBufferVolumes = MapThread[
		Function[{assBuffer, buffDiluFactor, bufferVolume},
			Which[
				bufferVolume == 0 Liter, 0 Liter,
				MatchQ[assBuffer, ObjectP[]], bufferVolume,
				(* first value is the amount of concentrated buffer, second is the amount of buffer diluent *)
				True, {bufferVolume / buffDiluFactor, bufferVolume * (1 - 1 / buffDiluFactor)}
			]
		],
		{assayBuffer, bufferDilutionFactor, bufferVolumes}
	];

	(* make rules correlating the amount of a given buffer, and Total it all up *)
	bufferVolumeRules = Merge[
		Flatten[MapThread[
			Function[{volumes, assBuffer, concBuffer, diluent},
				Which[
					(* if we have 0 Liter of volume, or if there is no assay buffer and no concentrated buffer, then just don't make a rule*)
					MatchQ[volumes, EqualP[0 Liter]] || (NullQ[assBuffer] && NullQ[concBuffer]), Nothing,
					(*if volumes is just one volume, then we're using AssayBuffer*)
					MatchQ[volumes, VolumeP], assBuffer -> volumes,
					MatchQ[volumes, {VolumeP, VolumeP}], {concBuffer -> volumes[[1]], diluent -> volumes[[2]]},
					True, Nothing
				]
			],
			{splitBufferVolumes, Download[assayBuffer, Object, Cache -> cache, Simulation -> simulation], Download[concentratedBuffer, Object, Cache -> cache, Simulation -> simulation], Download[bufferDiluent, Object, Cache -> cache, Simulation -> simulation]}
		]],
		Total
	];

	(* make resources for the buffers *)
	bufferResources = KeyValueMap[
		If[MatchQ[#1, WaterModelP],
			Resource[Sample -> #1, Amount -> #2 * 1.1, Name -> ToString[Unique[]], Container -> PreferredContainer[#2 * 1.1]],
			Resource[Sample -> #1, Amount -> #2 * 1.1, Name -> ToString[Unique[]]]
		]&,
		bufferVolumeRules
	];

	(* combine the sample and buffer resources together *)
	allResources = Flatten[{sampleResources, bufferResources}];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResources, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> cache, Simulation -> simulation],
		True, {Resources`Private`fulfillableResourceQ[allResources, Output -> Result, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> cache, Simulation -> simulation], Null}
	];

	(* Get the protocol type that we want to create an ID for. *)
	protocolType = If[MatchQ[preparation, Manual],
		resolveManualFrameworkFunction[mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation, Output -> Type],
		Module[{experimentFunction},
			experimentFunction = Lookup[$WorkCellToExperimentFunction, workCell];
			Object[Protocol, ToExpression@StringDelete[ToString[experimentFunction], "Experiment"]]
		]
	];

	(* make a simulated output packet *)
	simulatedProtocolPacket = <|
		Type -> protocolType,
		Name -> "Protocol that will never actually be uploaded since this is in a shortcut function only called if Output -> Options"
	|>;

	(* make Result and Tests output rules *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		ToList[simulatedProtocolPacket],
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
(*simulateExperimentAliquot*)

DefineOptions[simulateExperimentAliquot,
	Options :> {
		CacheOption,
		SimulationOption
	}
];

(* very simple simulation function because it is entirely relying on ExperimentRobotic/ManualSamplePreparation to do the heavy lifting *)
simulateExperimentAliquot[
	myProtocolPacket:PacketP[{Object[Protocol, RoboticSamplePreparation], Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticCellPreparation], Object[Protocol, ManualCellPreparation]}]|$Failed,
	myAccessoryPackets:{PacketP[]...}|$Failed,
	mySamples:{{ObjectP[Object[Sample]]..}..},
	myResolvedOptions:{___Rule},
	ops:OptionsPattern[simulateExperimentAliquot]
]:=Module[
	{
		safeResolutionOps, cache, simulation, preparation, workCell, protocolObject, samplePackets, sourcesToTransfer,
		destinationsToTransferTo, expandedDestWells, amountsToTransfer, accessoryPacketSimulation, containerOutLabelFields,
		sampleOutLabelFields, updatedSimulation, assayBufferLabelFields, concentratedBufferLabelFields,
		bufferDiluentLabelFields, sampleOutLabels, containerOutLabels, assayBufferLabels, concBufferLabels,
		bufferDiluentLabels, protocolType
	},

	(* pull out the cache and simulation blob now *)
	safeResolutionOps = SafeOptions[simulateExperimentAliquot, ToList[ops]];
	cache = Lookup[safeResolutionOps, Cache];
	simulation = If[NullQ[Lookup[safeResolutionOps, Simulation]],
		Simulation[],
		Lookup[safeResolutionOps, Simulation]
	];

	(* Get the resolved preparation and resolve the protocol type. *)
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
	} = convertAliquotToTransferSteps[samplePackets, myResolvedOptions, Label -> True];

	(* if we don't have anything to transfer (and this only happens if stuff is messed up), just return early with the simulation we came in with *)
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
		assayBufferLabels,
		concBufferLabels,
		bufferDiluentLabels
	} = Lookup[
		myResolvedOptions,
		{
			SampleOutLabel,
			ContainerOutLabel,
			AssayBufferLabel,
			ConcentratedBufferLabel,
			BufferDiluentLabel
		}
	];

	(* generate the extra LabelFields that we want with SampleOutLabel and ContainerOutLabel *)
	sampleOutLabelFields = MapIndexed[
		With[{index = First[#2]},
			#1 -> Field[SampleOutLink[[index]]]
		]&,
		sampleOutLabels
	];
	containerOutLabelFields = MapIndexed[
		With[{index = First[#2]},
			#1 -> Field[ContainerOutLink[[index]]]
		]&,
		containerOutLabels
	];

	(* generate the extra LabelFields that we want with the AssayBufferLabel/BufferDiluentLabel/ConcentratedBufferLabel *)
	assayBufferLabelFields = MapIndexed[
		With[{index = First[#2]},
			If[StringQ[#1],
				#1 -> Field[AssayBufferLink[[index]]],
				Nothing
			]
		]&,
		assayBufferLabels
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
			Simulation[LabelFields -> Flatten[{sampleOutLabelFields, containerOutLabelFields, assayBufferLabelFields, concentratedBufferLabelFields, bufferDiluentLabelFields}]]
		],
		simulation
	];

	(* NOTE: SimulateResources requires you to have a protocol object, so just make one to simulate our unit operation. *)
	accessoryPacketSimulation = Module[{protocolPacket},
		protocolPacket = <|
			Object -> SimulateCreateID[protocolType],
			Replace[OutputUnitOperations] -> Link[Lookup[Cases[myAccessoryPackets, Except[PacketP[Object[UnitOperation, Aliquot]], PacketP[Object[UnitOperation]]]], Object, {}], Protocol],
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
			updatedSimulation,
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
