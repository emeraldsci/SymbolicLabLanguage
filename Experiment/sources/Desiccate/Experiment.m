(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(* Option Definitions *)

DefineOptions[ExperimentDesiccate,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Amount,
				Default -> All,
				Description -> "The mass of the sample to transfer from the input samples into another container (specified by SampleContainer) before desiccation. All indicates that the sample remains in the primary container.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, $MaxTransferMass],
						Units -> {1, {Gram, {Gram, Milligram}}}
					],
					"All" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All]]
				]
			},
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the samples that are being desiccated, for use in downstream unit operations.",
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
				OptionName -> SampleContainer,
				Default -> Automatic,
				Description -> "The container that the sample Amount is transferred into prior to desiccating in a bell jar. The container's lid is off during desiccation. Null indicates the sample is not transferred to another container and is desiccated in its primary container.",
				ResolutionDescription -> "Automatically set to Null if Amount is set to All; otherwise, it is calculated by the PreferredContainer function. Null indicates that the sample is desiccated in its primary container without being transferred to another.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Tubes & Vials"
						}
					}
				]
			},
			{
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample containers that are used during the desiccation step, for use in downstream unit operations.",
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
			OptionName -> Method,
			Default -> StandardDesiccant,
			Description -> "Method of drying the sample (removing water or solvent molecules from the solid sample). Options include StandardDesiccant, Vacuum, and DesiccantUnderVacuum. StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> DesiccationMethodP
			]
		},
		{
			OptionName -> Desiccant,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample.",
			ResolutionDescription -> "Automatically set to Model[Sample,\"Indicating Drierite\"], Model[Sample,\"Sulfuric acid\"], or Null if DesiccantPhase is Solid/not informed, Liquid, or Method is Vacuum.",
			Category -> "General",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Consumable], Object[Item, Consumable], Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents",
						"Desiccants"
					}
				}
			]
		},
		{
			OptionName -> DesiccantPhase,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The physical state of the desiccant in the desiccator which dries the exposed sample by absorbing water molecules from the sample.",
			ResolutionDescription -> "Automatically set to the physical state of the selected desiccant, or Null if Desiccant is Null.",
			Category -> "General",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Solid, Liquid]
			]
		},
		{
			OptionName -> CheckDesiccant,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "Indicates if the color of the desiccant is verified and is thrown out before the experiment begins if the color indicates it is expired.",
			ResolutionDescription -> "Automatically set to True if Desiccant model is Model[Sample, \"Indicating Drierite\"].",
			Category -> "General",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> DesiccantAmount,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The mass of a solid or the volume of a liquid hygroscopic chemical that is used in the desiccator to dry the exposed sample by absorbing water molecules from the sample.",
			ResolutionDescription -> "Automatically set to 100 Gram if DesiccantPhase is Solid, 100 Milliliter if DesiccantPhase is Liquid, or Null if Method is Vacuum.",
			Category -> "General",
			Widget -> Alternatives[
				"Mass" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Gram, 1 Kilogram, 1 Gram],
					Units -> {1, {Gram, {Gram, Kilogram}}}
				],
				"Volume" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Milliliter, 1 Liter, 1 Milliliter],
					Units -> {1, {Milliliter, {Milliliter, Liter}}}
				]
			]
		},
		{
			OptionName -> DesiccantStorageCondition,
			Default -> Automatic,
			Description -> "The non-default condition under which the desiccant is stored after the protocol is completed. Null indicates the desiccant will be stored according to its StorageCondition or its Models' DefaultStorageCondition.",
			ResolutionDescription -> "Automatically set to Disposal if Desiccant is not Null.",
			AllowNull -> True,
			Category -> "Storage Information",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal
				],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Storage Conditions"
						}
					}
				]
			]
		},
		{
			OptionName -> DesiccantStorageContainer,
			Default -> Automatic,
			Description -> "The desired container that the desiccant is transferred into after desiccation. If Not specified, it is determined by PreferredContainer function.",
			ResolutionDescription -> "Automatically calculated by PreferredContainer function.",
			AllowNull -> True,
			Category -> "Storage Information",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Containers",
						"Tubes & Vials"
					}
				}
			]
		},
		{  OptionName -> Desiccator,
			Default -> Model[Instrument, Desiccator, "Bel-Art Space Saver Vacuum Desiccator"],
			AllowNull -> False,
			Description -> "The instrument that is used to dry the sample by exposing the sample with its container lid open in a bell jar which includes a chemical desiccant either at atmosphere or vacuum.",
			Category -> "General",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, Desiccator], Object[Instrument, Desiccator]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Desiccators",
						"Open Sample Desiccators"
					}
				}
			]
		},
		{
			OptionName -> Time,
			Default -> 5 Hour,
			Description -> "Determines how long the sample (with the lid off) is dried via desiccation inside a desiccator.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 Minute, $MaxExperimentTime, 1 Minute],
				Units -> {1, {Hour, {Minute, Hour, Day}}}
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleOutLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the sample collected at the end of the desiccation step, for use in downstream unit operations.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				UnitOperation -> True
			},
			(*Storage Information*)
			{
				OptionName -> ContainerOut,
				Default -> Null,
				Description -> "The desired container that the desiccated sample should be transferred into after desiccation. If specified, all of the sample is transferred into ContainerOut.",
				AllowNull -> True,
				Category -> "Storage Information",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel], Model[Container, GrindingContainer]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers",
							"Tubes & Vials"
						}
					}
				]
			},
			{
				OptionName -> ContainerOutLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the ContainerOut that the sample is transferred into after the desiccation step, for use in downstream unit operations.",
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
				OptionName -> SamplesOutStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which any new samples generated by this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their StorageCondition or their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Storage Information",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP | Desiccated | VacuumDesiccated | RefrigeratorDesiccated | Disposal
					],
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Storage Conditions"
							}
						}
					]
				]
			}
		],
		PreparatoryUnitOperationsOption,
		ProtocolOptions,
		SimulationOption,
		NonBiologyPostProcessingOptions,
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelContainer
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelAmount,
			{
				ResolutionDescription -> "Automatically set to 1 Gram."
			}
		]
	}
];

(* ::Subsection::Closed:: *)
(* ExperimentDesiccate Errors and Warnings *)
Error::NonSolidSample = "The samples `1` do not have a Solid state and cannot be processed. Remove these samples from the experiment inputs.";
Error::InvalidDesiccatorType = "The specified Desiccator, `1`, is a storage desiccator with Closed SampleType. Please select a Desiccator with Open SampleType, or leave the option unspecified to be calculated automatically. \"Open\" means that the sample will be uncovered during the course of desiccation for effective drying.";
Error::DesiccantPhaseMismatch = "The specified DesiccantPhase, `1`, does not match the physical state of the specified Desiccant, `2`, which is `3`.";
Error::DesiccantPhaseMissing = "The State of the specified Desiccant `1` is not informed. Please add the physical state of the Desiccant to its model, `2`.";
Error::InvalidDesiccantPhase = "The state of the specified Desiccant `1`, is Gas. Update the state of the desiccant model, `2`, if it is not a gas, otherwise change to desiccant to solid or liquid sample.";
Error::DesiccantAmountNotCalculated = "DesiccantAmount could not be calculated automatically because the `1`.";
Error::MethodAndDesiccantPhaseMismatch = "If DesiccantPhase is Liquid, desiccation method must be StandardDesiccant, NOT DesiccantUnderVacuum. Please specify a solid desiccant or adjust the desiccation method.";
Error::DesiccantPhaseAndAmountMismatch = "The unit of DesiccantAmount, `1`, does not match physical state of the desiccant, `2`. DesiccantAmount must be in mass or volume units if DesiccantPhase is Solid or Liquid, respectively.";
Error::CanNotCheckDesiccant = "CheckDesiccant option is only available for Indicating Drierite. The specified Desiccant model is `1`. Please specify Model[Sample, \"Indicating Drierite\" for Desiccant or set CheckDesiccant to False. Otherwise, leave option unspecified to be calculated automatically.";
Error::MissingMassInformation = "The sample(s) `1` are missing mass information. Set Amount to a value other than All or use ExperimentMeasureWeight to determine mass(es) of these sample(s).";
Warning::InsufficientDesiccantAmount = "The specified DesiccantAmount `1` might NOT be sufficient for efficient drying of the samples.";
Error::DesiccantStorageConflict = "DesiccantStorageCondition is set to Disposal. Therefore, DesiccantStorageContainer should not be specified but it is set to `1`. Either change DesiccantStorageCondition or set DesiccantStorageContainer to Null; or leave the options unspecified to be calculated automatically.";
Error::SampleContainerMismatch = "Amount is specified to a value other than All, `1`, for sample(s) `2` but SampleContainer is set to Null. Either set Amount to All or specify SampleContainer so that the specified Amount is transferred to the specified SampleContainer. Otherwise, leave SampleContainer unspecified to calculate automatically.";
Error::DesiccantOptionsRequired = "Unless desiccation method is Vacuum, `1` must be specified. Please provide values or allow these to be calculated automatically.";
Error::UnusedDesiccantOptions = "If desiccation method is set to Vacuum then no desiccant will be used and therefore `1` can't be specified. Please set these to Null or allow them to be calculated automatically.";
Error::SmallSampleContainer = "The specified SampleContainer(s), `1`, are too small for the sample amount(s), `2`. Use PreferredContainer[1.25 * specified amount] function to find a suitable container or leave the option unspecified to be calculated automatically. The 25% margin ensures the sample can be fully transferred into the container without overfilling.";
Error::LargeSampleContainer = "The specified SampleContainer(s), `1`, for `2`, are too large to fit in the desiccator, `3`. Please specify a smaller sample container.";
Error::LargeInputContainer = "The container(s) of `1` are too large to fit in the desiccator, `2`. Please specify Amount and SampleContainer for these samples to transfer them before desiccation.";


(* ::Subsection::Closed:: *)
(* ExperimentDesiccate *)

(*Mixed Input*)
ExperimentDesiccate[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
		sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult, containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

	(*Determine the requested return value from the function*)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests = MemberQ[output, Tests];

	(* Get the containers and options as lists.*)
	{listedContainers, listedOptions} = {ToList[myInputs], ToList[myOptions]};

	(*First, simulate our sample preparation.*)
	validSamplePreparationResult = Check[
		(*Simulate sample preparation.*)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentDesiccate,
			listedContainers,
			listedOptions,
			DefaultPreparedModelAmount -> 1 Gram
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(*If we are given an invalid define name, return early.*)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(*Return early.*)
		(*Note: We've already thrown a message above in simulateSamplePreparationPackets.*)
		Return[$Failed]
	];

	(*Convert our given containers into samples and sample index-matched options.*)
	containerToSampleResult = If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown.*)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentDesiccate,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(*Therefore, we have to run the tests to see if we encountered a failure.*)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentDesiccate,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
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
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentDesiccate[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

(* Sample input/core overload*)
ExperimentDesiccate[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
	{listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult,
		optionsWithPreparedSamples, safeOps, safeOpsTests, validLengths, validLengthTests, instruments,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, packetObjectSample, preferredContainers,
		containerObjects, containerModels, instrumentOption, samplesWithPreparedSamples, modelSampleFields,
		modelContainerFields, objectContainerFields, instrumentObjects, allObjects, allInstruments, allContainers,
		objectSampleFields, updatedSimulation, upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, downloadedStuff,
		cacheBall, resolvedOptionsResult, desiccantSamples, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, safeOptionsNamed, allContainerModels, performSimulationQ,
		protocolPacketWithResources, resourcePacketTests, result, simulatedProtocol, simulation, optionsResolverOnly,
		returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentDesiccate,
			listedSamples,
			listedOptions
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

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentDesiccate, optionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentDesiccate, optionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* replace all objects referenced by Name to ID *)
	{samplesWithPreparedSamples, safeOps, optionsWithPreparedSamples} = sanitizeInputs[samplesWithPreparedSamplesNamed, safeOptionsNamed, optionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentDesiccate, {samplesWithPreparedSamples}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentDesiccate, {samplesWithPreparedSamples}, optionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentDesiccate, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentDesiccate, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentDesiccate, {samplesWithPreparedSamples}, inheritedOptions]];

	(* --- Search for and Download all the information we need for resolver and resource packets function --- *)

	(* do a huge search to get everything we could need *)

	{
		instruments
	} = Search[
		{
			{Model[Instrument, Desiccator]}
		},
		{
			Deprecated != True && DeveloperObject != True
		}
	];


	(* all possible containers that the resolver might use*)
	preferredContainers = DeleteDuplicates[
		Flatten[{
			PreferredContainer[All, Type -> All],
			PreferredContainer[All, LightSensitive -> True, Type -> All]
		}]
	];

	(* any container the user provided (in case it's not on the PreferredContainer list) *)
	containerObjects = DeleteDuplicates[Cases[
		Flatten[Lookup[expandedSafeOps, {SampleContainer, ContainerOut}]],
		ObjectP[Object]
	]];
	containerModels = DeleteDuplicates[Cases[
		Flatten[Lookup[expandedSafeOps, {SampleContainer, ContainerOut}]],
		ObjectP[Model]
	]];

	(* gather the instrument option *)
	instrumentOption = Lookup[expandedSafeOps, Desiccator];

	(* pull out any Object[Instrument]s in the Instrument option (since users can specify a mix of Objects, Models, and Automatic) *)
	instrumentObjects = Cases[Flatten[{instrumentOption}], ObjectP[Object[Instrument]]];

	(* split things into groups by types (since we'll be downloading different things from different types of objects) *)
	allObjects = DeleteDuplicates[Flatten[{instruments, preferredContainers, containerModels, containerObjects}]];
	allInstruments = Cases[allObjects, ObjectP[Model[Instrument]]];
	allContainerModels = Flatten[{
		Cases[allObjects, ObjectP[{Model[Container, Vessel], Model[Container, Plate]}]],
		Cases[KeyDrop[inheritedOptions, {Cache, Simulation}], ObjectReferenceP[{Model[Container]}], Infinity],

		(*Desiccant Container*)
		{Model[Container, Vessel, "id:4pO6dMOxdbJM"]} (*Pyrex Crystallization Dish*)
	}];
	allContainers = Flatten[{
		Cases[
			KeyDrop[inheritedOptions, {Cache, Simulation}],
			ObjectReferenceP[Object[Container]],
			Infinity
		]
	}];


	(*articulate all the fields needed*)
	objectSampleFields = Union[SamplePreparationCacheFields[Object[Sample]]];
	modelSampleFields = Union[SamplePreparationCacheFields[Model[Sample]], {DefaultStorageCondition}];
	objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]]];
	modelContainerFields = Union[SamplePreparationCacheFields[Model[Container]]];

	(* in the past including all these different through-link traversals in the main Download call made things slow because there would be duplicates if you have many samples in a plate *)
	(* that should not be a problem anymore with engineering's changes to make Download faster there; we can split this into multiples later if that no longer remains true *)
	packetObjectSample = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Model[modelSampleFields]],
		Packet[Model[{DefaultStorageCondition}]]
	};

	(* Lookup specified Desiccant *)
	desiccantSamples = Cases[Flatten[{
		Lookup[expandedSafeOps, Desiccant],
		Model[Sample, "id:GmzlKjzrmB85"], (*Indicating Drierite*)
		Model[Sample, "id:Vrbp1jG80ZnE"] (*Sulfuric acid*)
	}], ObjectP[]];

	(* download all the things *)
	downloadedStuff = Quiet[
		Download[
			{
				(*1*)ToList[mySamples],
				(*3*)ToList[desiccantSamples],
				(*4*)allContainerModels,
				(*5*)allContainers,
				(*6*)instrumentObjects,
				(*7*)allInstruments
			},
			Evaluate[
				{
					(*1*)packetObjectSample,
					(*3*){Packet[State, Mass, Volume, Status, Model, Density, StorageCondition, DefaultStorageCondition]},
					(*4*){Evaluate[Packet @@ modelContainerFields]},

					(*5*)
					{
						Evaluate[Packet @@ objectContainerFields],
						Packet[Model[modelContainerFields]]
					},
					(*6*){Packet[Model]},
					(*7*){Packet[Positions, SampleType]}
				}
			],
			Cache -> cache,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* get all the cache and put it together *)
	cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];

	(* Build the resolved options *)
	resolvedOptionsResult = Check[
		{resolvedOptions, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentDesiccateOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{resolveExperimentDesiccateOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentDesiccate,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	optionsResolverOnly = Lookup[resolvedOptions, OptionsResolverOnly];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result | Simulation]];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Result | Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> RemoveHiddenOptions[ExperimentDesiccate, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	{protocolPacketWithResources, resourcePacketTests} = Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
		{$Failed, {}},
		gatherTests,
		desiccateResourcePackets[
			samplesWithPreparedSamples,
			templatedOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],
		True,
		{
			desiccateResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				Output -> Result
			],
			{}
		}
	];

	(* --- Simulation --- *)
	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = If[performSimulationQ,
		simulateExperimentDesiccate[
			If[MatchQ[protocolPacketWithResources, $Failed],
				$Failed,
				protocolPacketWithResources[[1]] (* protocolPacket *)
			],
			If[MatchQ[protocolPacketWithResources, $Failed],
				$Failed,
				Flatten[ToList[protocolPacketWithResources[[2]]]] (* unitOperationPackets *)
			],
			ToList[samplesWithPreparedSamples],
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		],
		{Null, updatedSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentDesiccate, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[protocolPacketWithResources, $Failed], $Failed,

		(* Actually upload our protocol object. We are being called as a sub-protocol in ExperimentManualSamplePreparation. *)
		True,
		UploadProtocol[
			(* protocol packet *)
			protocolPacketWithResources[[1]], (*protocolPacket*)
			ToList[protocolPacketWithResources[[2]]], (*unitOperationPackets*)
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			CanaryBranch -> Lookup[safeOps, CanaryBranch],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			ConstellationMessage -> {Object[Protocol, Desiccate]},
			Cache -> cacheBall,
			Simulation -> simulation
		]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentDesiccate, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation
	}
];

(* ::Subsection::Closed:: *)
(*resolveExperimentDesiccateOptions*)

DefineOptions[
	resolveExperimentDesiccateOptions,
	Options :> {HelperOutputOption, SimulationOption, CacheOption}
];

resolveExperimentDesiccateOptions[myInputSamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveExperimentDesiccateOptions]] := Module[
	{
		outputSpecification, output, gatherTests, cache, desiccantPhase, desiccantPhaseMismatch, smallSampleContainers,
		simulation, samplePrepOptions, desiccationOptions, desiccantOptionNames, unneededDesiccantOptions,
		simulatedSamples, resolvedSamplePrepOptions, desiccantPhaseMissing, desiccantPhaseMissingTest,
		updatedSimulation, samplePrepTests, samplePackets, invalidDesiccantPhase, desiccantPhaseMismatchTest,
		modelPackets, inputSampleContainerPacketsWithNulls, desiccantModel, sampleContainerMismatchOptions,
		sampleContainerModelPacketsWithNulls, sampleContainerMismatches, sampleContainerMismatchTests,
		cacheBall, sampleDownloads, fastAssoc, unneededDesiccantErrorQ, unneededDesiccantOptionsTest,
		sampleContainerModelPackets, inputSampleContainerPackets, neededDesiccantOptions, neededDesiccantOptionsTest,
		messages, discardedSamplePackets, discardedInvalidInputs, simulatedSampleModels, smallSampleContainerTests,
		discardedTest, mapThreadFriendlyOptions, neededDesiccantErrorQ, smallSampleContainerOptions,
		desiccationOptionAssociation, optionPrecisions, roundedDesiccationOptions, precisionTests, specifiedCheckDesiccant,
		specifiedAmount, specifiedSampleContainer, numericAmounts, convertedUnit, checkDesiccantMismatch,
		specifiedSampleContainerLabel, specifiedMethod, specifiedDesiccantStorageCondition, resolvedCheckDesiccant,
		specifiedDesiccant, specifiedDesiccantPhase, invalidDesiccatorTests, resolvedDesiccantStorageCondition,
		specifiedDesiccantAmount, specifiedSampleOutLabel, specifiedDesiccator, specifiedTime, checkDesiccantMismatchTest,
		specifiedSampleLabel, specifiedContainerOut, specifiedDesiccantStorageContainer, largeInputContainerTests,
		specifiedContainerOutLabel, specifiedSamplesOutStorageCondition, desiccantStorageMismatchTest,
		nonSolidSamplePackets, nonSolidSampleInvalidInputs, desiccantStorageMismatch, largeInputContainerInvalidSamples,
		nonSolidSampleTest, missingMassInvalidInputs, missingMassQ, unresolvedAmount, sampleMasses,
		missingMassTest, resolvedDesiccantPhase, resolvedDesiccantAmount, largeContainerQs,
		resolvedDesiccator, resolvedDesiccatorModel, resolvedDesiccant, desiccantDensity, inputSampleContainers,
		resolvedAmount, resolvedSampleContainer, resolvedSampleContainerLabel, largeSampleContainerTests,
		resolvedSampleLabel, resolvedContainerOut, resolvedContainerOutLabel, resolvedDesiccantStorageContainer,
		resolvedSamplesOutStorageCondition, methodDesiccantPhaseMismatch, largeSampleContainerOptions,
		methodDesiccantPhaseMismatchTest, resolvedOptions, resolvedSampleOutLabel, deficientDesiccantAmount,
		deficientDesiccantAmountTest, desiccatorSampleType, desiccantOptionNamesSansDesiccantStorageContainer,
		invalidDesiccantPhaseTest, invalidDesiccantAmountOption, largeInputContainerQs, largeSampleContainerQs,
		invalidDesiccantAmountTest, desiccantPhaseAmountMismatch, desiccantDefaultStorageCondition,
		desiccantPhaseAmountMismatchTest, invalidSamplesOutStorageConditions,
		invalidSamplesOutStorageConditionsOptions, invalidSamplesOutStorageConditionsTest,
		resolvedPostProcessingOptions, invalidDesiccatorOptions,
		invalidInputs, invalidOptions, allTests
	},

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our Desiccate options from our Sample Prep options. *)
	{samplePrepOptions, desiccationOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options (only if the sample prep option is not true) *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentDesiccate, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentDesiccate, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Extract the packets that we need from our downloaded cache. *)
	(* need to do this even if we have caching because of the simulation stuff *)
	sampleDownloads = Quiet[Download[
		simulatedSamples,
		{
			Packet[Name, Volume, Mass, State, Status, Container, Solvent, Position, Model, StorageCondition, DefaultStorageCondition],
			Packet[Model[{DefaultStorageCondition}]],
			Packet[Container[{Object, Model}]],
			Packet[Container[Model[{MaxVolume, Dimensions}]]]
		},
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* combine the cache together *)
	cacheBall = FlattenCachePackets[{
		cache,
		sampleDownloads
	}];

	(* generate a fast cache association *)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Get the downloaded mess into a usable form *)
	{
		samplePackets,
		modelPackets,
		inputSampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls
	} = Transpose[sampleDownloads];

	simulatedSampleModels = fastAssocLookup[fastAssoc, simulatedSamples, Model];

	(* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null.
		Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
	sampleContainerModelPackets = Replace[sampleContainerModelPacketsWithNulls, {Null -> {}}, 1];
	inputSampleContainerPackets = Replace[inputSampleContainerPacketsWithNulls, {Null -> {}}, 1];

	(*-- INPUT VALIDATION CHECKS --*)

	(* NOTE: MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)
	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets = Select[Flatten[samplePackets], MatchQ[Lookup[#, Status], Discarded]&];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
			];
			passingTest = If[Length[discardedInvalidInputs] == Length[myInputSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputSamples, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];


	(* NOTE: MAKE SURE THE SAMPLES ARE SOLID - *)

	(* Get the samples that are not solids,cannot desiccate those *)
	nonSolidSamplePackets = Select[samplePackets, Not[MatchQ[Lookup[#, State], Solid | Null]]&];

	(* Keep track of samples that are not Solid *)
	nonSolidSampleInvalidInputs = Lookup[nonSolidSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonSolidSampleInvalidInputs] > 0 && messages,
		Message[Error::NonSolidSample, ObjectToString[nonSolidSampleInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonSolidSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonSolidSampleInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[nonSolidSampleInvalidInputs, Cache -> cacheBall] <> " have a Solid State:", True, False]
			];

			passingTest = If[Length[nonSolidSampleInvalidInputs] == Length[myInputSamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[myInputSamples, nonSolidSampleInvalidInputs], Cache -> cacheBall] <> " have a Solid State:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* NOTE: MAKE SURE THE SAMPLES HAVE A MASS IF THEY'RE a SOLID - *)
	(* Get the samples that do not have a MASS but are a solid *)
	sampleMasses = Lookup[samplePackets, Mass];
	unresolvedAmount = Lookup[desiccationOptions, Amount];

	(* Keep track of samples that do not have mass but are a solid *)
	missingMassQ = MapThread[NullQ[#1] && MatchQ[#2, All]&, {sampleMasses, unresolvedAmount}];

	missingMassInvalidInputs = PickList[simulatedSamples, missingMassQ];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[missingMassInvalidInputs] > 0 && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Error::MissingMassInformation, ObjectToString[missingMassInvalidInputs, Cache -> cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	missingMassTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[missingMassInvalidInputs] == 0,
				Nothing,
				Warning["Our input samples " <> ObjectToString[missingMassInvalidInputs, Cache -> cacheBall] <> " are not missing mass information:", True, False]
			];

			passingTest = If[Length[missingMassInvalidInputs] == Length[myInputSamples],
				Nothing,
				Warning["Our input samples " <> ObjectToString[Complement[myInputSamples, missingMassInvalidInputs], Cache -> cacheBall] <> " are not missing mass information:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)

	(* Convert list of rules to Association so we can Lookup,Append,Join as usual. *)
	desiccationOptionAssociation = Association[desiccationOptions];

	(* Define the options and associated precisions that we need to check *)
	optionPrecisions = {
		{Amount, 10^-3 Gram},
		{DesiccantAmount, 10^0 Gram},
		{Time, 10^0 Second}
	};

	(* round values for options based on option precisions *)
	{roundedDesiccationOptions, precisionTests} = If[
		gatherTests,
		RoundOptionPrecision[desiccationOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], AvoidZero -> True, Output -> {Result, Tests}],
		{RoundOptionPrecision[desiccationOptionAssociation, optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], AvoidZero -> True], Null}
	];

	(* Lookup the values of the options to resolve using the option names associated with the type of option being resolved *)
	{
		specifiedAmount,
		specifiedSampleContainer,
		specifiedSampleContainerLabel,
		specifiedMethod,
		(*5*)specifiedDesiccant,
		specifiedDesiccantPhase,
		specifiedDesiccantAmount,
		specifiedSampleOutLabel,
		specifiedDesiccator,
		(*10*)specifiedTime,
		specifiedSampleLabel,
		specifiedContainerOut,
		specifiedContainerOutLabel,
		specifiedSamplesOutStorageCondition,
		(*15*)specifiedDesiccantStorageContainer,
		specifiedDesiccantStorageCondition,
		specifiedCheckDesiccant
	} = Lookup[roundedDesiccationOptions,
		{
			Amount,
			SampleContainer,
			SampleContainerLabel,
			Method,
			(*5*)Desiccant,
			DesiccantPhase,
			DesiccantAmount,
			SampleOutLabel,
			Desiccator,
			(*10*)Time,
			SampleLabel,
			ContainerOut,
			ContainerOutLabel,
			SamplesOutStorageCondition,
			(*15*)DesiccantStorageContainer,
			DesiccantStorageCondition,
			CheckDesiccant
		}
	];

	(* Options Method, and Time don't need option resolving. Null is not allowed, Default is not Automatic. *)

	(* If specifiedMethod -> Vacuum then no desiccant options should be set *)
	desiccantOptionNames = {Desiccant, DesiccantPhase, DesiccantAmount, DesiccantStorageContainer, DesiccantStorageCondition, CheckDesiccant};
	desiccantOptionNamesSansDesiccantStorageContainer = {Desiccant, DesiccantPhase, DesiccantAmount, DesiccantStorageCondition};

	unneededDesiccantOptions = If[MatchQ[specifiedMethod, Vacuum],
		PickList[desiccantOptionNames, Lookup[desiccationOptions, desiccantOptionNames], Except[Automatic | Null]],
		{}
	];

	(* Make note of if we complained about any desiccant options being set when they shouldn't *)
	(* If so shouldn't give any more messages about these options because we don't want them in the first place *)
	unneededDesiccantErrorQ = !MatchQ[unneededDesiccantOptions,{}];

	(* throw an error if any options related to the desiccant have been set when we have Method->Vacuum (which implies no desiccant) *)
	If[messages && !MatchQ[unneededDesiccantOptions,{}],
		Message[Error::UnusedDesiccantOptions, unneededDesiccantOptions]
	];

	(* Define the tests the user will see for the above messages *)
	unneededDesiccantOptionsTest = If[gatherTests,
		Test["No options related to the desiccant are specified when Method is set to Vacuum:", True, MatchQ[unneededDesiccantOptions,{}]],
		Nothing
	];

	(* throw an error if any options related to the desiccant have been set to Null when we have Method -> Except[Vacuum] *)
	neededDesiccantOptions = Which[
		MatchQ[specifiedMethod, Vacuum],
			{},

		MatchQ[Lookup[desiccationOptions, DesiccantStorageCondition], Except[Disposal]],
			PickList[desiccantOptionNames, Lookup[desiccationOptions, desiccantOptionNames], Null],

		(* if DesiccantStorageCondition is Disposal, DesiccantStorageContainer does not need to be specified *)
		True,
			PickList[desiccantOptionNamesSansDesiccantStorageContainer, Lookup[desiccationOptions, desiccantOptionNamesSansDesiccantStorageContainer], Null]
	];

	neededDesiccantErrorQ = !MatchQ[neededDesiccantOptions, {}];

	(* throw an error if any options related to the desiccant have been set to Null when we have Method -> Except[Vacuum] *)
	If[messages && neededDesiccantErrorQ,
		Message[Error::DesiccantOptionsRequired, neededDesiccantOptions]
	];

	(* Define the tests the user will see for the above messages *)
	neededDesiccantOptionsTest = If[gatherTests,
		Test["Desiccant-related options are specified when Method is StandardDesiccant or DesiccantUnderVacuum:", True, MatchQ[neededDesiccantOptions,{}]],
		Nothing
	];

	(* Resolve Desiccant and DesiccantPhase option. Default is Automatic. *)
	{resolvedDesiccant, resolvedDesiccantPhase} = Which[
		MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Except[Automatic], Except[Automatic]}],
			{specifiedDesiccant, specifiedDesiccantPhase},

		MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Except[Automatic], Automatic}],
			If[
				MatchQ[specifiedMethod, Vacuum],
				{specifiedDesiccant, Null},
				{specifiedDesiccant, fastAssocLookup[fastAssoc, specifiedDesiccant, State]}
			],

		MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Automatic, Except[Automatic]}] && MatchQ[specifiedMethod, Vacuum],
			{Null, specifiedDesiccantPhase},

		MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Automatic, Except[Automatic]}],
			If[
				MatchQ[specifiedDesiccantPhase, Liquid],
				{Model[Sample, "id:Vrbp1jG80ZnE"], specifiedDesiccantPhase},
				{Model[Sample, "id:GmzlKjzrmB85"], specifiedDesiccantPhase}
			],

		MatchQ[{specifiedDesiccant, specifiedDesiccantPhase}, {Automatic, Automatic}],
			If[
				MatchQ[specifiedMethod, Vacuum],
				{Null, Null},
				{Model[Sample, "id:GmzlKjzrmB85"], Solid}
			]
	];

	(* look up the physical state of the specified desiccant *)
	desiccantPhase = fastAssocLookup[fastAssoc, resolvedDesiccant, State];
	desiccantModel = If[
		MatchQ[resolvedDesiccant, ObjectP[Model]],
		resolvedDesiccant,
		fastAssocLookup[fastAssoc, resolvedDesiccant, Model]
	];

	(* look up desiccant storage condition *)
	desiccantDefaultStorageCondition = With[
		{
			desiccantStorageCondition = RemoveLinkID[fastAssocLookup[fastAssoc, resolvedDesiccant, StorageCondition]],
			desiccantModelStorageCondition = RemoveLinkID[fastAssocLookup[fastAssoc, desiccantModel, DefaultStorageCondition]]
		},

		Which[
			(* if the resolved desiccant is a sample object, look up its StorageCondition *)
			MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]] && MatchQ[desiccantStorageCondition, ObjectP[Model[StorageCondition]]],
				desiccantStorageCondition,

			(* if the resolved desiccant is a model OR a sample that has no StorageCondition, look up the model's DefaultStorageCondition *)
			MatchQ[resolvedDesiccant, ObjectP[{Object[Sample], Model[Sample]}]] && MatchQ[desiccantModelStorageCondition, ObjectP[Model[StorageCondition]]],
				desiccantModelStorageCondition,

			(* in all other conditions, set to ambient storage *)
			True,
				AmbientStorage
		]
	];

	(* resolve CheckDesiccant *)
	resolvedCheckDesiccant = Which[

		(* if user specified it, let it be *)
		MatchQ[specifiedCheckDesiccant, Except[Automatic]],
			specifiedCheckDesiccant,

		(* if Method is Vacuum, CheckDesiccant is Null *)
		MatchQ[specifiedMethod, Vacuum],
			Null,

		(* in other cases, if desiccant is indicating drierite, True, otherwise False*)
		True,
			MatchQ[desiccantModel, ObjectP[Model[Sample, "id:GmzlKjzrmB85"]]]
	];

	(* throw an error if desiccant is not indicating drierite but CheckDesiccant is True *)
	checkDesiccantMismatch = If[
		And[
			messages,
			!neededDesiccantErrorQ,
			!unneededDesiccantErrorQ,
			TrueQ[resolvedCheckDesiccant],
			!MatchQ[desiccantModel, ObjectP[Model[Sample, "id:GmzlKjzrmB85"]]]
		],

		(
			Message[
				Error::CanNotCheckDesiccant,
				ObjectToString[desiccantModel, Cache -> cacheBall]
			];
			{Desiccant, CheckDesiccant}
		),
		{}
	];

	(* Define the tests the user will see for the above message *)
	checkDesiccantMismatchTest = If[gatherTests,
		Test[
			"CheckDesiccant is False if Desiccant is not indicating drierite.",
			True,
			And[
				messages,
				!neededDesiccantErrorQ,
				!unneededDesiccantErrorQ,
				!TrueQ[resolvedCheckDesiccant],
				!MatchQ[desiccantModel, ObjectP[Model[Sample, "id:GmzlKjzrmB85"]]]
			],
			Nothing
		]
	];

	(* throw an error if we couldn't look-up phase from sample (State field not set) *)
	desiccantPhaseMissing = If[
		messages && NullQ[resolvedDesiccantPhase] && MatchQ[specifiedDesiccantPhase, Automatic] && MatchQ[specifiedMethod, Except[Vacuum]] && !neededDesiccantErrorQ && !unneededDesiccantErrorQ,
		(
			Message[
				Error::DesiccantPhaseMissing,
				ObjectToString[resolvedDesiccant, Cache -> cacheBall],
				ObjectToString[desiccantModel, Cache -> cacheBall]
			];
			{DesiccantPhase}
		),
		{}
	];

	(* Define the tests the user will see for the above messages *)
	desiccantPhaseMissingTest = If[gatherTests,
		Test[
			"If the specified Method is not Vacuum, DesiccantPhase or Desiccant model's State field is informed:",
			True,
			!(NullQ[resolvedDesiccantPhase] && MatchQ[specifiedDesiccantPhase, Automatic] && MatchQ[specifiedMethod, Except[Vacuum]] && !neededDesiccantErrorQ && !unneededDesiccantErrorQ)
		],
		Nothing
	];

	(* throw an error if DesiccantPhase is resolved to Gas *)
	invalidDesiccantPhase = If[
		messages && MatchQ[resolvedDesiccantPhase, Gas],
		(
			Message[
				Error::InvalidDesiccantPhase,
				ObjectToString[resolvedDesiccant, Cache -> cacheBall],
				ObjectToString[desiccantModel, Cache -> cacheBall]
			];
			{DesiccantPhase}
		),
		{}
	];

	(* Define the tests the user will see for the above messages *)
	invalidDesiccantPhaseTest = If[gatherTests,
		Test["The physical state of the specified desiccant is Solid or Liquid:", True, MatchQ[resolvedDesiccantPhase, Solid | Liquid]],
		Nothing
	];

	(* throw an error if Desiccant state and DesiccantPhase do not match *)
	desiccantPhaseMismatch = If[
		messages && !MatchQ[desiccantPhase, resolvedDesiccantPhase] && !neededDesiccantErrorQ && !unneededDesiccantErrorQ,
		(
			Message[
				Error::DesiccantPhaseMismatch,
				ObjectToString[resolvedDesiccantPhase, Cache -> cacheBall],
				ObjectToString[resolvedDesiccant, Cache -> cacheBall],
				ObjectToString[desiccantPhase, Cache -> cacheBall]
			];
			{DesiccantPhase}
		),
		{}
	];

	(* Define the tests the user will see for the above messages *)
	desiccantPhaseMismatchTest = If[gatherTests,
		Test["The physical state of the specified Desiccant matches the specified DesiccantPhase option.", True, MatchQ[desiccantPhase, resolvedDesiccantPhase]],
		Nothing
	];

	(* Throw an error if the DesiccantPhase is Liquid and the Method is Vacuum or DesiccantUnderVacuum *)
	methodDesiccantPhaseMismatch = If[
		MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[specifiedMethod, DesiccantUnderVacuum] && messages,
		(
			Message[Error::MethodAndDesiccantPhaseMismatch, ToString[specifiedMethod], ToString[resolvedDesiccantPhase]];
			{Method, DesiccantPhase}
		),
		{}
	];

	(* Define the tests the user will see for the above messages *)
	methodDesiccantPhaseMismatchTest = If[gatherTests,
		Test["A solid desiccant is used when Method is set to DesiccantUnderVacuum:", True, If[MatchQ[specifiedMethod, DesiccantUnderVacuum], MatchQ[resolvedDesiccantPhase, Solid], True]],
		Nothing
	];

	(* Resolve DesiccantAmount Option *)
	resolvedDesiccantAmount = Which[
		MatchQ[specifiedDesiccantAmount, Except[Automatic]],
			specifiedDesiccantAmount,

		MatchQ[specifiedMethod, Vacuum] || NullQ[resolvedDesiccantPhase],
			Null,

		(* Liquid Desiccant *)
		And[
			MatchQ[resolvedDesiccantPhase, Liquid],
			MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]],
			Or[
				NullQ[fastAssocLookup[fastAssoc, resolvedDesiccant, Volume]],
				EqualQ[Floor[fastAssocLookup[fastAssoc, resolvedDesiccant, Volume], 1 Milliliter], 0 Liter]
			]
		],
			Null,

		MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]],
			Min[100Milliliter, Floor[fastAssocLookup[fastAssoc, resolvedDesiccant, Volume], 1 Milliliter]],

		MatchQ[resolvedDesiccantPhase, Liquid] && MatchQ[resolvedDesiccant, ObjectP[Model[Sample]]],
			100Milliliter,

		(* Solid Desiccant *)
		And[
			MatchQ[resolvedDesiccantPhase, Solid],
			MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]],
			Or[
				NullQ[fastAssocLookup[fastAssoc, resolvedDesiccant, Mass]],
				EqualQ[Floor[fastAssocLookup[fastAssoc, resolvedDesiccant, Mass], 1 Gram], 0 Gram]
			]
		],
			Null,

		MatchQ[resolvedDesiccantPhase, Solid] && MatchQ[resolvedDesiccant, ObjectP[Object[Sample]]],
			Min[100Gram, fastAssocLookup[fastAssoc, resolvedDesiccant, Mass]],

		MatchQ[resolvedDesiccantPhase, Solid] && MatchQ[resolvedDesiccant, ObjectP[Model[Sample]]],
			100Gram,

		True,
			100 Gram
	];

	(* throw an error if DesiccantAmount and DesiccantPhase conflict *)
	desiccantPhaseAmountMismatch = If[
		And[
			messages,
			!neededDesiccantErrorQ,
			!unneededDesiccantErrorQ,
			!NullQ[resolvedDesiccantAmount],
			Or[
				MatchQ[resolvedDesiccantPhase, Solid] && !MassQ[resolvedDesiccantAmount],
				MatchQ[resolvedDesiccantPhase, Liquid] && !VolumeQ[resolvedDesiccantAmount]
			]
		],
		(
			Message[
				Error::DesiccantPhaseAndAmountMismatch,
				ObjectToString[resolvedDesiccantAmount, Cache -> cacheBall],
				ObjectToString[resolvedDesiccantPhase, Cache -> cacheBall]
			];
			{DesiccantPhase, DesiccantAmount}
		),
		{}
	];

	(* Define the tests the user will see for the above message *)
	desiccantPhaseAmountMismatchTest = If[gatherTests,
		Test[
			"DesiccantAmount is in mass or volume units if desiccant is solid or liquid, respectively:",
			True,
			Or[
				MatchQ[resolvedDesiccantPhase, Solid] && !MassQ[resolvedDesiccantAmount],
				MatchQ[resolvedDesiccantPhase, Liquid] && !VolumeQ[resolvedDesiccantAmount]
			],
			Nothing
		]
	];

	(* throw an error if resolvedDesiccantAmount is Null or 0 Gram/Liter *)
	invalidDesiccantAmountOption = Which[
		Or[
			!messages,
			neededDesiccantErrorQ,
			unneededDesiccantErrorQ,
			MatchQ[specifiedMethod, Vacuum]
		],
			{},

		NullQ[resolvedDesiccantPhase],
			(
				Message[
					Error::DesiccantAmountNotCalculated,
					"DesiccantPhase resolved to Null. Either upload the State of the specified desiccant, " <> ObjectToString[resolvedDesiccant, Cache -> cacheBall] <> ", or specify the DesiccantPhase or DesiccantAmount."
				];
				{DesiccantAmount, DesiccantPhase}
			),

		MatchQ[resolvedDesiccantPhase, Liquid] && NullQ[fastAssocLookup[fastAssoc, resolvedDesiccant, Volume]],
			(
				Message[
					Error::DesiccantAmountNotCalculated,
					"Volume of " <> ObjectToString[resolvedDesiccant, Cache -> cacheBall] <> " is Null. Please specify DesiccantAmount, or upload the volume, or run ExperimentMeasureVolume to measure the volume of the desiccant."
				];
				{DesiccantAmount}
			),

		MatchQ[resolvedDesiccantPhase, Liquid] && EqualQ[Floor[fastAssocLookup[fastAssoc, resolvedDesiccant, Volume], 1 Milliliter], 0 Liter],
			(
				Message[
					Error::DesiccantAmountNotCalculated,
					"Volume of the specified desiccant, " <> ObjectToString[resolvedDesiccant, Cache -> cacheBall] <> ", is too low, " <> ObjectToString[fastAssocLookup[fastAssoc, resolvedDesiccant, Volume], Cache -> cacheBall] <> ". The minimum required desiccant amount is 1 mL but it is recommended to use at least 100 mL of the desiccant."
				];
				{DesiccantAmount}
			),

		MatchQ[resolvedDesiccantPhase, Solid] && NullQ[fastAssocLookup[fastAssoc, resolvedDesiccant, Mass]],
		(
			Message[
				Error::DesiccantAmountNotCalculated,
				"Mass of " <> ObjectToString[resolvedDesiccant, Cache -> cacheBall] <> " is Null. Please specify DesiccantAmount, or upload the Mass, or run ExperimentMeasureWeight to measure the mass of the desiccant."
			];
			{DesiccantAmount}
		),

		MatchQ[resolvedDesiccantPhase, Solid] && EqualQ[Floor[fastAssocLookup[fastAssoc, resolvedDesiccant, Mass], 1 Gram], 0 Gram],
			(
				Message[
					Error::DesiccantAmountNotCalculated,
					"Mass of the specified desiccant, " <> ObjectToString[resolvedDesiccant, Cache -> cacheBall] <> ", is too low, " <> ObjectToString[fastAssocLookup[fastAssoc, resolvedDesiccant, Mass], Cache -> cacheBall] <> ". The minimum required desiccant amount is 1 g but it is recommended to use at least 100 g of the desiccant."
				];
				{DesiccantAmount}
			),

		True,
		 {}
	];

	(* Define the tests the user will see for the above message *)
	invalidDesiccantAmountTest = If[gatherTests,
		Test[
			"The DesiccantAmount option is properly informed when Method is Desiccant or DesiccantUnderVacuum:",
			True,
			Or[
				neededDesiccantErrorQ,
				unneededDesiccantErrorQ,
				MatchQ[specifiedMethod, Vacuum],
				!NullQ[resolvedDesiccantPhase]
			]
		],
		Nothing
	];

	(* throw an error if resolvedDesiccantAmount is too little (less than 100 g or 100 mL)*)
	convertedUnit = If[
		MassQ[resolvedDesiccantAmount],
		UnitConvert[resolvedDesiccantAmount, Gram],
		UnitConvert[resolvedDesiccantAmount, Milliliter]
	];
	deficientDesiccantAmount = If[
		And[
			messages,
			Not[MatchQ[$ECLApplication, Engine]],
			!unneededDesiccantErrorQ,
			!NullQ[resolvedDesiccantAmount],
			QuantityMagnitude[convertedUnit] < 100
		],
		(
			Message[Warning::InsufficientDesiccantAmount, ToString[resolvedDesiccantAmount]];
			{DesiccantAmount}
		),
		{}
	];

	(* Define the tests the user will see for the above message *)
	deficientDesiccantAmountTest = If[gatherTests,
		Warning["The DesiccantAmount is sufficient:", True, QuantityMagnitude[resolvedDesiccantAmount] >= 100],
		Nothing
	];

	(* DesiccantStorageCondition; Default: Automatic; If not specified, set to Disposal *)
	resolvedDesiccantStorageCondition = Which[

		MatchQ[specifiedDesiccantStorageCondition, Except[Automatic]],
			specifiedDesiccantStorageCondition,

		MatchQ[specifiedMethod, StandardDesiccant | DesiccantUnderVacuum] && MatchQ[specifiedDesiccantStorageContainer, ObjectP[{Object[Container], Model[Container]}]],
			desiccantDefaultStorageCondition,

		MatchQ[specifiedMethod, StandardDesiccant | DesiccantUnderVacuum],
			Disposal,

		True,
			Null
	];

	(* DesiccantStorageContainer; Default: Automatic; If not specified, it is determined by PreferredContainer *)
	(* look up density of the desiccant to be used for PreferredContainer *)
	desiccantDensity = fastAssocLookup[fastAssoc, resolvedDesiccant, Density];

	resolvedDesiccantStorageContainer = Which[

		MatchQ[specifiedDesiccantStorageContainer, Except[Automatic]],
			specifiedDesiccantStorageContainer,

		MatchQ[resolvedDesiccantStorageCondition, Disposal] || !MatchQ[specifiedMethod, StandardDesiccant | DesiccantUnderVacuum],
			Null,

		DensityQ[desiccantDensity],
			PreferredContainer[resolvedDesiccantAmount, Density -> desiccantDensity],

		True,
			PreferredContainer[resolvedDesiccantAmount]
	];

	(* throw an error if DesiccantStorageCondition and DesiccantStorageContainer conflict *)
	desiccantStorageMismatch = If[
		And[
			messages,
			!neededDesiccantErrorQ,
			!unneededDesiccantErrorQ,
			MatchQ[resolvedDesiccantStorageCondition, Disposal],
			!NullQ[resolvedDesiccantStorageContainer]
		],

		(
			Message[
				Error::DesiccantStorageConflict,
				ObjectToString[resolvedDesiccantStorageContainer, Cache -> cacheBall]
			];
			{DesiccantStorageCondition, DesiccantStorageContainer}
		),
		{}
	];

	(* Define the tests the user will see for the above message *)
	desiccantStorageMismatchTest = If[gatherTests,
		Test[
			"DesiccantStorageContainer is Null if DesiccantStorageCondition is Disposal.",
			True,
			And[
				!neededDesiccantErrorQ,
				!unneededDesiccantErrorQ,
				MatchQ[resolvedDesiccantStorageCondition, Disposal],
				!NullQ[resolvedDesiccantStorageContainer]
			],
			Nothing
		]
	];

	(* Resolve Desiccator option. Null is not allowed; Default is Automatic. *)
	resolvedDesiccator = If[
		MatchQ[specifiedDesiccator, Except[Automatic]],
		specifiedDesiccator,
		Model[Instrument, Desiccator, "id:7X104v1xjLoZ"] (*Bel-Art Space Saver Vacuum Desiccator*)
	];

	(* lookup resolved desiccator model *)
	resolvedDesiccatorModel = If[MatchQ[resolvedDesiccator, ObjectP[Model]],
		resolvedDesiccator,
		fastAssocLookup[fastAssoc, resolvedDesiccator, Model]
	];

	(* NOTE: MAPPING*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentDesiccate, roundedDesiccationOptions];

	(* big MapThread to get all the options resolved *)
	{
		resolvedAmount,
		resolvedSampleContainer,
		resolvedSampleContainerLabel,
		resolvedSampleLabel,
		resolvedSampleOutLabel,
		resolvedContainerOut,
		resolvedContainerOutLabel,
		resolvedSamplesOutStorageCondition,
		invalidSamplesOutStorageConditions,
		(*10*)sampleContainerMismatches,
		smallSampleContainers,
		numericAmounts,
		largeContainerQs
	} = Transpose[
		MapThread[
			Function[{samplePacket, modelPacket, options, inputSampleContainerPacket, sampleContainerModelPacket},
				Module[
					{
						unresolvedAmount, unresolvedSampleContainer, sampleContainer, unresolvedSampleContainerLabel,
						sampleContainerLabel, unresolvedSampleLabel, sampleLabel, unresolvedSampleOutLabel, sampleOutLabel,
						unresolvedContainerOut, unresolvedContainerOutLabel, containerOutLabel, sampleContainerMismatch,
						unresolvedSamplesOutStorageCondition, invalidSamplesOutStorageCondition, fitsQ, numericAmount,
						sampleContainerModel, sampleContainerMaxVolume, smallSampleContainer, containerWidth, containerDepth,
						containerHeight, desiccatorWidth, desiccatorDepth, desiccatorHeight, largeContainerQ
					},

					(* error checking variables *)
					{
						invalidSamplesOutStorageCondition,
						sampleContainerMismatch
					} = {
						False,
						False
					};

					(* pull out all the relevant unresolved options*)
					{
						unresolvedAmount,
						unresolvedSampleContainer,
						unresolvedSampleContainerLabel,
						unresolvedSampleLabel,
						unresolvedSampleOutLabel,
						unresolvedContainerOut,
						unresolvedContainerOutLabel,
						unresolvedSamplesOutStorageCondition
					} = Lookup[
						options,
						{
							Amount,
							SampleContainer,
							SampleContainerLabel,
							SampleLabel,
							SampleOutLabel,
							ContainerOut,
							ContainerOutLabel,
							SamplesOutStorageCondition
						}
					];

					(* --- Resolve IndexMatched Options --- *)

					(* SampleLabel; Default: Automatic *)
					sampleLabel = Which[
						MatchQ[unresolvedSampleLabel, Except[Automatic]],
						unresolvedSampleLabel,
						And[MatchQ[simulation, SimulationP], MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[samplePacket, Object]]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePacket, Object]],
						True,
						CreateUniqueLabel["sample " <> StringDrop[Lookup[samplePacket, ID], 3]]
					];

					(* SampleOutLabel; Default: Automatic *)
					sampleOutLabel = Which[
						MatchQ[unresolvedSampleOutLabel, Except[Automatic]],
						unresolvedSampleOutLabel,
						NullQ[unresolvedSampleContainer] && NullQ[unresolvedContainerOut],
						sampleLabel,
						True,
						CreateUniqueLabel["SampleOut " <> StringDrop[Lookup[samplePacket, ID], 3]]
					];

					(* SampleContainer; Default: Automatic; Null indicates Input Sample's Container. If Amount is set to a value other than All, the specified amount of the sample is transferred into a SampleContainer determined by PreferredContainer*)
					sampleContainer = Which[
						MatchQ[unresolvedSampleContainer, Except[Automatic]],
						unresolvedSampleContainer,

						MatchQ[unresolvedAmount, Except[All]],

						(* the 1.25 factor is to prevent SmallSampleContainer error. Error::SmallSampleContainer is triggered if amount is greater than 80% of MaxVolume of the container *)
						PreferredContainer[unresolvedAmount * 1.25],

						True,
						Null
					];

					(* flip an error switch if Amount is specified to a mass value but SampleContainer is Null *)
					sampleContainerMismatch = If[
					MassQ[unresolvedAmount] && NullQ[unresolvedSampleContainer],
						True,
						False
					];

					(* Throw an error if the sample does not fit in the specified SampleContainer *)
					numericAmount = If[MassQ[unresolvedAmount], unresolvedAmount, Lookup[samplePacket, Mass]];

					sampleContainerModel = Switch[sampleContainer,
						Null, Null,
						ObjectP[Model], sampleContainer,
						_, fastAssocLookup[fastAssoc, sampleContainer, Model]
					];

					sampleContainerMaxVolume = If[NullQ[sampleContainer], Null, fastAssocLookup[fastAssoc, sampleContainerModel, MaxVolume]];

					smallSampleContainer = TrueQ[GreaterQ[numericAmount * 1 Milliliter / Gram, 0.8 * sampleContainerMaxVolume]];

					(* check if the container fits in the desiccator *)
					(* lookup the dimensions of the container of the input sample *)
					{containerWidth, containerDepth, containerHeight} = If[
						MatchQ[sampleContainerModel, ObjectP[Model[Container]]],
						fastAssocLookup[fastAssoc, sampleContainerModel, Dimensions],
						Lookup[sampleContainerModelPacket, Dimensions]
					];

					(* lookup dimensions of the desiccator *)
					{desiccatorWidth, desiccatorDepth, desiccatorHeight} = Lookup[FirstCase[fastAssocLookup[fastAssoc, resolvedDesiccatorModel, Positions], KeyValuePattern[Name -> "A1"]], {MaxWidth, MaxDepth, MaxHeight}];

					(* define a function to check if a given container fits in another container *)
					fitsQ[{containerWidth:DistanceP, containerDepth:DistanceP, containerHeight:DistanceP}, {desiccatorWidth:DistanceP, desiccatorDepth:DistanceP, desiccatorHeight:DistanceP|Null}] := And[
						NullQ[desiccatorHeight] || containerHeight <= 0.95 * desiccatorHeight,
						Or[
							containerWidth <= 0.95 * desiccatorWidth && containerDepth <= 0.95 * desiccatorDepth,
							containerWidth <= 0.95 * desiccatorDepth && containerDepth <= 0.95 * desiccatorWidth
						]
					];

					(* return True for large container that won't fit in the desiccator *)
					largeContainerQ = !fitsQ[{containerWidth, containerDepth, containerHeight}, {desiccatorWidth, desiccatorDepth, desiccatorHeight}];

					(* SampleContainerLabel; Default: Automatic.
					SampleContainer refers to the container that contains the sample during desiccation. *)
					sampleContainerLabel = Which[
						MatchQ[unresolvedSampleContainerLabel, Except[Automatic]],
						unresolvedSampleContainerLabel,
						And[MatchQ[simulation, SimulationP], MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[inputSampleContainerPacket, Object]]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[inputSampleContainerPacket, Object]],
						NullQ[sampleContainer],
						CreateUniqueLabel["input container " <> StringDrop[Lookup[inputSampleContainerPacket, ID], 3]],
						True,
						CreateUniqueLabel["sample container " <> StringDrop[Download[sampleContainer, ID], 3]]
					];


					(* ContainerOutLabel; Default: Null *)
					containerOutLabel = Which[
						MatchQ[unresolvedContainerOutLabel, Except[Automatic]],
						unresolvedContainerOutLabel,
						NullQ[unresolvedContainerOut],
						sampleContainerLabel,
						True,
						CreateUniqueLabel["container out " <> StringDrop[Download[unresolvedContainerOut, ID], 3]]
					];

					(*Throw an error if SamplesOutStorageCondition is Null and DefaultStorageCondition is not informed*)
					invalidSamplesOutStorageCondition = And[
						NullQ[unresolvedSamplesOutStorageCondition],
						NullQ[Lookup[samplePacket, StorageCondition, Null]],
						If[
							NullQ[modelPacket],
							True,
							NullQ[Lookup[modelPacket, DefaultStorageCondition, Null]]
						]
					];

					{
						unresolvedAmount,
						sampleContainer,
						sampleContainerLabel,
						sampleLabel,
						sampleOutLabel,
						unresolvedContainerOut,
						containerOutLabel,
						unresolvedSamplesOutStorageCondition,
						invalidSamplesOutStorageCondition,
						(*10*)sampleContainerMismatch,
						smallSampleContainer,
						numericAmount,
						largeContainerQ
					}
				]
			],
			{samplePackets, modelPackets, mapThreadFriendlyOptions, inputSampleContainerPackets, sampleContainerModelPackets}
		]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* Throw an error if the specified desiccator is a storage desiccator *)
	desiccatorSampleType = fastAssocLookup[fastAssoc, resolvedDesiccatorModel, SampleType];

	invalidDesiccatorOptions = If[messages && !MatchQ[desiccatorSampleType, Open],
		(
			Message[
				Error::InvalidDesiccatorType,
				ObjectToString[resolvedDesiccator, Cache -> cacheBall],
				ObjectToString[desiccatorSampleType, Cache -> cacheBall]
			];
			{Desiccator}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	invalidDesiccatorTests = If[gatherTests,
		Test["A storage desiccator is not selected as the desiccator for this experiment.", True, !MatchQ[desiccatorSampleType, Closed]],
		{}
	];

	(* Throw an error if the container, which the sample is desiccated in, does not fit in the desiccator *)
	(* the container that the sample is desiccated in *)
	inputSampleContainers = Download[Lookup[inputSampleContainerPackets, Object], Object];

	(* a list of booleans indicating large SampleContainer *)
	largeSampleContainerQs = MapThread[
		TrueQ[#1] && MatchQ[#2, ObjectP[]]&,
		{largeContainerQs, resolvedSampleContainer}
	];

	(* a list of booleans indicating large input container, when SampleContainer is Null *)
	largeInputContainerQs = MapThread[
		TrueQ[#1] && NullQ[#2]&,
		{largeContainerQs, resolvedSampleContainer, inputSampleContainers}
	];

	(* throw and error when SampleContainer is large *)
	largeSampleContainerOptions = If[messages && MatchQ[desiccatorSampleType, Open] && MemberQ[largeSampleContainerQs, True],
		(
			Message[
				Error::LargeSampleContainer,
				ObjectToString[PickList[resolvedSampleContainer, largeSampleContainerQs], Cache -> cacheBall],
				ObjectToString[PickList[simulatedSamples, largeSampleContainerQs], Cache -> cacheBall],
				ObjectToString[resolvedDesiccator, Cache -> cacheBall]
			];
			{SampleContainer}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	largeSampleContainerTests = If[gatherTests,
		Test["All specified SampleContainer fit in the desiccator.", True, Which[
			MatchQ[desiccatorSampleType, Closed],
				True,

			MemberQ[largeSampleContainerQs, True],
				False,

			True,
				True
		]],
		{}
	];

	(* throw and error when input container is large and SampleContainer is Null *)
	largeInputContainerInvalidSamples = If[messages && MatchQ[desiccatorSampleType, Open] && MemberQ[largeInputContainerQs, True],
		(
			Message[
				Error::LargeInputContainer,
				ObjectToString[PickList[inputSampleContainers, largeInputContainerQs], Cache -> cacheBall],
				ObjectToString[PickList[simulatedSamples, largeInputContainerQs], Cache -> cacheBall]
			];
			PickList[simulatedSamples, largeInputContainerQs]
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	largeInputContainerTests = If[gatherTests,
		Test["All input containers (if SampleContainer not specified) fit in the desiccator.", True, Which[
			MatchQ[desiccatorSampleType, Closed],
				True,

			MemberQ[largeInputContainerQs, True],
				False,

			True,
				True
		]],
		{}
	];

	(* throw an error if SampleContainer is Null but Amount is specified to a mass value *)
	sampleContainerMismatchOptions = If[MemberQ[sampleContainerMismatches, True] && messages,
		(
			Message[
				Error::SampleContainerMismatch,
				ObjectToString[PickList[resolvedAmount, sampleContainerMismatches], Cache -> cacheBall],
				ObjectToString[PickList[simulatedSamples, sampleContainerMismatches], Cache -> cacheBall]
			];
			{SampleContainer, Amount}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	sampleContainerMismatchTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, sampleContainerMismatches];
			passingInputs = PickList[simulatedSamples, sampleContainerMismatches, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["If amount is specified to a mass quantity (not All), SampleContainer is not Null for the input samples " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["If amount is specified to a mass quantity (not All), SampleContainer is not Null for the input samples " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* throw an error if SampleContainer too small for sample Amount *)
	smallSampleContainerOptions = If[MemberQ[smallSampleContainers, True] && messages,
		(
			Message[
				Error::SmallSampleContainer,
				ObjectToString[PickList[resolvedSampleContainer, smallSampleContainers], Cache -> cacheBall],
				ObjectToString[PickList[numericAmounts, smallSampleContainers], Cache -> cacheBall],
				ObjectToString[PickList[simulatedSamples, smallSampleContainers], Cache -> cacheBall]
			];
			{SampleContainer}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	smallSampleContainerTests = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, smallSampleContainers];
			passingInputs = PickList[simulatedSamples, smallSampleContainers, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The specified SampleContainer is not too small for the input samples: " <> ObjectToString[failingInputs, Cache -> cacheBall] <> ".", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The specified SampleContainer is not too small for the input samples: " <> ObjectToString[passingInputs, Cache -> cacheBall] <> ".", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* throw an error if SamplesOutStorageCondition is resolved to Null for any samples *)
	invalidSamplesOutStorageConditionsOptions = If[MemberQ[invalidSamplesOutStorageConditions, True] && messages,
		(
			Message[
				Error::InvalidSamplesOutStorageCondition,
				ObjectToString[PickList[simulatedSamples, invalidSamplesOutStorageConditions], Cache -> cacheBall]
			];
			{SamplesOutStorageCondition}
		),
		{}
	];

	(* Create appropriate tests if gathering them, or return {} *)
	invalidSamplesOutStorageConditionsTest = If[gatherTests,
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},

			(* Get the failing and not failing samples *)
			failingInputs = PickList[simulatedSamples, invalidSamplesOutStorageConditions];
			passingInputs = PickList[simulatedSamples, invalidSamplesOutStorageConditions, False];

			(* Create the passing and failing tests *)
			failingInputTest = If[Length[failingInputs] > 0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall] <> " must have a valid SamplesOutStorageCondition.", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall] <> " must have a valid SamplesOutStorageCondition.", True, True],
				Nothing
			];

			(* Return our created tests. *)
			{passingInputsTest, failingInputTest}
		],
		{}
	];

	(* gather all the resolved options together *)
	(* doing this ReplaceRule ensures that any newly-added defaulted ProtocolOptions are going to be just included in myOptions*)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Amount -> resolvedAmount,
			SampleLabel -> resolvedSampleLabel,
			SampleOutLabel -> resolvedSampleOutLabel,
			SampleContainer -> resolvedSampleContainer,
			SampleContainerLabel -> resolvedSampleContainerLabel,
			Method -> specifiedMethod,
			Desiccant -> resolvedDesiccant,
			CheckDesiccant -> resolvedCheckDesiccant,
			DesiccantPhase -> resolvedDesiccantPhase,
			DesiccantAmount -> resolvedDesiccantAmount,
			DesiccantStorageContainer -> resolvedDesiccantStorageContainer,
			DesiccantStorageCondition -> resolvedDesiccantStorageCondition,
			Desiccator -> resolvedDesiccator,
			Time -> specifiedTime,
			ContainerOut -> resolvedContainerOut,
			ContainerOutLabel -> resolvedContainerOutLabel,
			SamplesOutStorageCondition -> resolvedSamplesOutStorageCondition,
			resolvedSamplePrepOptions,
			resolvedPostProcessingOptions
		}]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{
		nonSolidSampleInvalidInputs,
		discardedInvalidInputs,
		missingMassInvalidInputs,
		largeInputContainerInvalidSamples
	}]];

	(* gather all the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		invalidDesiccatorOptions,
		sampleContainerMismatchOptions,
		smallSampleContainerOptions,
		checkDesiccantMismatch,
		invalidDesiccantPhase,
		neededDesiccantOptions,
		unneededDesiccantOptions,
		desiccantPhaseMissing,
		desiccantPhaseMismatch,
		desiccantStorageMismatch,
		invalidDesiccantAmountOption,
		methodDesiccantPhaseMismatch,
		desiccantPhaseAmountMismatch,
		invalidSamplesOutStorageConditionsOptions,
		largeSampleContainerOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[messages && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[messages && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* this constant is used to track InvalidOptions found here. it can be used by other functions to throw all InvalidOptions generated by all functions in one place *)
	$DesiccateInvalidOptions = invalidOptions;
	$DesiccateInvalidInputs = invalidInputs;

	(* get all the tests together *)
	allTests = Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		missingMassTest,
		nonSolidSampleTest,
		invalidDesiccatorTests,
		sampleContainerMismatchTests,
		smallSampleContainerTests,
		largeSampleContainerTests,
		largeInputContainerTests,
		checkDesiccantMismatchTest,
		invalidDesiccantPhaseTest,
		desiccantPhaseMismatchTest,
		neededDesiccantOptionsTest,
		unneededDesiccantOptionsTest,
		desiccantPhaseMissingTest,
		methodDesiccantPhaseMismatchTest,
		invalidDesiccantAmountTest,
		deficientDesiccantAmountTest,
		desiccantPhaseAmountMismatchTest,
		desiccantStorageMismatchTest,
		invalidSamplesOutStorageConditionsTest,
		precisionTests
	}], TestP];

	(* return our resolved options and/or tests *)
	outputSpecification /. {Result -> resolvedOptions, Tests -> allTests}
];

(* ::Subsection:: *)
(*desiccateResourcePackets*)

DefineOptions[desiccateResourcePackets,
	Options :> {
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];

(*populate fields and make resources for samples and things we're using for desiccation*)
desiccateResourcePackets[
	mySamples : {ObjectP[Object[Sample]]..},
	myUnresolvedOptions : {___Rule},
	myResolvedOptions : {___Rule},
	myCollapsedResolvedOptions : {___Rule},
	myOptions : OptionsPattern[]
] := Module[
	{
		outputSpecification, output, cache, allResourceBlobs, safeOps, instrumentResources, samplesInResources,
		simulation, protocolPacket, fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule,
		simulatedSamples, updatedSimulation, simulatedSampleContainers, gatherTests, messages, sampleLabel, fastAssoc,
		numericAmount, amount, sampleContainers, sampleContainerLabel, method, desiccant, desiccantPhase,
		desiccantAmount, desiccator, time, containersOut, containerOutLabels, samplesOutStorageCondition,
		sampleContainerResources, unitOperationPackets, updatedSamplesOutStorageCondition, finalizedPacket,
		sharedFieldPacket, desiccantResource, desiccantStorageCondition, desiccantStorageContainer, desiccantStorageContainerResources,
		containerOutResourcesForProtocol, containerOutResourcesForUnitOperation, containersIn, containersInModels, 
		sampleContainerModels, desiccantContainerResource, samplesToSkip, checkDesiccant, containersInResources
	},

	(* get the safe options for this function *)
	safeOps = SafeOptions[desiccateResourcePackets, ToList[myOptions]];

	(* pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* lookup helper options *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(* make the fast association *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* simulate the sample preparation stuff so we have the right containers if we are aliquoting *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentDesiccate, mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation];

	(* this is the only real Download I need to do, which is to get the simulated sample containers *)
	simulatedSampleContainers = Download[simulatedSamples, Container[Object], Cache -> cache, Simulation -> updatedSimulation];

	(* lookup option values*)
	{
		amount,
		sampleContainers,
		sampleContainerLabel,
		method,
		desiccant,
		desiccantPhase,
		desiccantAmount,
		desiccator,
		time,
		sampleLabel,
		containersOut,
		containerOutLabels,
		samplesOutStorageCondition,
		desiccantStorageContainer,
		desiccantStorageCondition,
		checkDesiccant
	} = Lookup[
		myResolvedOptions,
		{
			Amount,
			SampleContainer,
			SampleContainerLabel,
			Method,
			Desiccant,
			DesiccantPhase,
			DesiccantAmount,
			Desiccator,
			Time,
			SampleLabel,
			ContainerOut,
			ContainerOutLabel,
			SamplesOutStorageCondition,
			DesiccantStorageContainer,
			DesiccantStorageCondition,
			CheckDesiccant
		}
	];

	(*Update amount value to quantity if it is resolved to All*)
	numericAmount = MapThread[If[
		MatchQ[#1, All], fastAssocLookup[fastAssoc, #2, Mass], #1
	]&, {amount, mySamples}];

	(* the samples that SamplesMustBeMoved warning should be skipped (the ones that Amount is not All) *)
	samplesToSkip = MapThread[If[
		MatchQ[#1, Except[All | Null]],
		#2,
		Nothing
	]&, {amount, ToList[mySamples]}];

	samplesInResources = MapThread[Resource[
		Sample -> fastAssocLookup[fastAssoc, #1, Object],
		Name -> #2,
		Amount -> #3,
		AutomaticDisposal -> False,
		ExactAmount -> True,
		(* 10% Tolerance (or 0.01 Gram, whichever is greater): The mass that the sample is allowed to deviate from the requested Amount when fulfilling the sample, because ExactAmount is True. *)
		Tolerance -> Max[0.1 * #3, 0.01 Gram]
	]&, {mySamples, sampleLabel, numericAmount}];

	(* ContainersIn:  *)
	containersIn = Download[fastAssocLookup[fastAssoc, mySamples, Container], Object];
	containersInResources = Resource[Sample -> #, Name->ToString[Unique[]]]& /@ containersIn;

	containersInModels = Download[fastAssocLookup[fastAssoc, containersIn, Model], Object];

	(*make instrument resources*)
	instrumentResources = Link[Resource[Instrument -> desiccator, Time -> time]];

	(* lookup sample container models *)
	sampleContainerModels = If[
		MatchQ[#, ObjectP[Model] | Null],
		#,
		Download[fastAssocLookup[fastAssoc, #, Model], Object]
	]& /@ sampleContainers;


	(*Create resource packet for sampleContainers if needed*)
	sampleContainerResources = MapThread[If[
		NullQ[#], Null,
		Link[Resource[Sample -> #, Name -> #2]]
	]&, {sampleContainers, sampleContainerLabel}];

	(*Create resource packet for containersOut if needed*)
	{containerOutResourcesForProtocol, containerOutResourcesForUnitOperation} = Transpose @ MapThread[
		Function[{containerOut, sampleContainer, sampleContainerModel, containerIn, containersInModel, containerOutLabel},
			Which[
				Or[
					(* If ContainerOut is Null, no need for ContainerOut resources *)
					NullQ[containerOut],
		
					(* if SampleContainer or its model is the same as ContainerOut, no need for ContainerOut resources *)
					!NullQ[sampleContainer] && MatchQ[containerOut, ObjectP[{sampleContainer, sampleContainerModel}]],
		
					(* if SampleContainer is Null and SamplesIn container or its model is the same as ContainerOut, no need for ContainerOut resources *)
					NullQ[sampleContainer] && MatchQ[containerOut, ObjectP[{containerIn, containersInModel}]]
				],
					{Null, Null},

				(* otherwise create ContainersOut resources based on ContainersOut being an object or model *)
				MatchQ[containerOut, ObjectP[Object]],
					{
						Link[Resource[Sample -> containerOut, Name -> containerOutLabel], Protocols],
						Link[Resource[Sample -> containerOut, Name -> containerOutLabel]]
					},
					
				True,
					{
						Link[Resource[Sample -> containerOut, Name -> containerOutLabel]],
						Link[Resource[Sample -> containerOut, Name -> containerOutLabel]]
					}
			]
		],
		{containersOut, sampleContainers, sampleContainerModels, containersIn, containersInModels, containerOutLabels}
	];

	desiccantContainerResource = If[
		!NullQ[desiccant],
		Link[Resource[
			Sample -> Model[Container, Vessel, "id:4pO6dMOxdbJM"] (*Model[Container, Vessel, "Pyrex Crystallization Dish"]*),
			Name -> CreateUniqueLabel["Desiccant Container "],
			Rent -> True
		]],
		Null
	];

	(* Desiccant resource if not Null *)
	desiccantResource = If[
		!NullQ[desiccant],
		Link[Resource[
			Sample -> desiccant,
			Amount -> desiccantAmount,
			AutomaticDisposal -> False
		]],
		Null
	];

	(* DesiccantStorageContainer resource if not Null *)
	desiccantStorageContainerResources = If[
		NullQ[desiccantStorageContainer],
		Null,
		Link[Resource[
			Sample -> desiccantStorageContainer,
			Name -> CreateUniqueLabel["Desiccant Storage Container "]
		]]
	];

	updatedSamplesOutStorageCondition = Map[If[
		MatchQ[#, ObjectP[Model[StorageCondition]]],
		Link[#],
		#
	]&, samplesOutStorageCondition];

	(* Preparing protocol and unitOperationObject packets: Are we making resources for Manual or Robotic? (Desiccate is manual only) *)
	(* Preparing unitOperationObject. Consider if we are making resources for Manual or Robotic *)
	unitOperationPackets = Module[{nonHiddenOptions},
		(* Only include non-hidden options from Transfer. *)
		nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, Desiccate]];

		UploadUnitOperation[
			Desiccate @@ ReplaceRule[Cases[myResolvedOptions, Verbatim[Rule][Alternatives @@ nonHiddenOptions, _]],
				{
					Sample -> samplesInResources,
					Desiccator -> instrumentResources,
					Desiccant -> desiccantResource,
					DesiccantStorageContainer -> desiccantStorageContainerResources,
					DesiccantStorageCondition -> desiccantStorageCondition,
					CheckDesiccant -> checkDesiccant,
					SampleContainer -> sampleContainerResources,
					ContainerOut -> containerOutResourcesForUnitOperation,
					SamplesOutStorageCondition -> updatedSamplesOutStorageCondition
				}
			],
			UnitOperationType -> Batched,
			Preparation -> Manual,
			FastTrack -> True,
			Upload -> False
		]
	];

	(* populate the RequiredObjects and RequiredInstruments fields of the protocol packet. *)
	protocolPacket = Join[
		<|
			Object -> CreateID[Object[Protocol, Desiccate]],
			Type -> Object[Protocol, Desiccate],
			Replace[SamplesIn] -> Map[Link[#, Protocols]&, samplesInResources],
			Replace[ContainersIn] -> Map[Link[#, Protocols]&, containersInResources],
			Replace[Amounts] -> numericAmount,
			SampleType -> Open,
			Method -> method,
			Replace[SampleContainers] -> sampleContainerResources,
			Replace[ContainersOut] -> containerOutResourcesForProtocol,
			Replace[SamplesOutStorageConditions] -> updatedSamplesOutStorageCondition,
			Desiccant -> desiccantResource,
			DesiccantAmount -> desiccantAmount,
			DesiccantContainer -> desiccantContainerResource,
			DesiccantStorageContainer -> desiccantStorageContainerResources,
			DesiccantStorageCondition -> desiccantStorageCondition,
			CheckDesiccant -> checkDesiccant,
			Desiccator -> instrumentResources,
			Time -> time,

			(* Post-processing options *)
			ImageSample -> Lookup[myResolvedOptions, ImageSample],
			MeasureWeight -> Lookup[myResolvedOptions, MeasureWeight],
			MeasureVolume -> Lookup[myResolvedOptions, MeasureVolume],

			UnresolvedOptions -> myUnresolvedOptions,
			ResolvedOptions -> myResolvedOptions,
			Replace[Checkpoints] -> {
				{"Picking Resources", 60 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 60 Minute]]},
				{"Running Experiment", 2*time, "Samples are being desiccated.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 2*time]]},
				{"Sample Post-Processing", 10 Minute, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 10 Minute]]},
				{"Returning Materials", 30 Minute, "Samples are returned to storage.", Link[Resource[Operator -> Model[User, Emerald, Operator, "Level 1"], Time -> 30 Minute]]}
			},
			Replace[BatchedUnitOperations] -> (Link[#, Protocol]&) /@ ToList[Lookup[unitOperationPackets, Object]]
		|>
	];

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine],
		{True, {}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Site -> Lookup[myResolvedOptions, Site], SkipSampleMovementWarning -> samplesToSkip, Cache -> cache],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Simulation -> updatedSimulation, Messages -> messages, Site -> Lookup[myResolvedOptions, Site], SkipSampleMovementWarning -> samplesToSkip, Cache -> cache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentDesiccate, myResolvedOptions],
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		{finalizedPacket, unitOperationPackets},
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(* ::Subsection::Closed:: *)
(*simulateExperimentDesiccate*)

DefineOptions[
	simulateExperimentDesiccate,
	Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentDesiccate[
	myProtocolPacket : PacketP[Object[Protocol, Desiccate]] | $Failed | Null,
	myUnitOperationPackets : {PacketP[Object[UnitOperation, Desiccate]]..} | $Failed,
	mySamples : {ObjectP[Object[Sample]]...},
	myResolvedOptions : {_Rule...},
	myResolutionOptions : OptionsPattern[simulateExperimentDesiccate]
] := Module[
	{
		cache, simulation, samplePackets, protocolObject, currentSimulation,
		simulationWithLabels, fastAssoc,
		samplesOutStorageCondition, method, unchangedSamples,
		desiccant, desiccantPhase, desiccantAmount, desiccator,
		time, sampleLabel, sampleOutLabel, sampleContainer, sampleContainerLabel,
		containerOut, containerOutLabel, transferAmount, simulatedSamplesOut,
		sampleContainerResources, containerOutResources,
		uploadSampleTransferPackets, destinationLocation,
		inputContainers, needNewSampleQ, newContainer, simulatedSourceSamples,
		amount, simulatedNewSamples, newSamplePackets, destinationContainer,
		simulatedProtocol, simulatedSampleContainer, simulatedContainerOut
	},

	(* Lookup our cache and simulation and make our fast association *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	fastAssoc = makeFastAssocFromCache[cache];

	(*Download packets that will be needed*)
	{
		samplePackets
	} = Quiet[
		Download[
			{
				ToList[mySamples]
			},
			{
				Packet[Model, Container]
			},
			Simulation -> simulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(*	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
	  ExperimentDesiccate,
	  myResolvedOptions
	];*)

	(* lookup option values*)
	{
		amount,
		sampleContainer,
		sampleContainerLabel,
		method,
		desiccant,
		desiccantPhase,
		desiccantAmount,
		desiccator,
		time,
		sampleLabel,
		sampleOutLabel,
		containerOut,
		containerOutLabel,
		samplesOutStorageCondition
	} = Lookup[
		myResolvedOptions,
		{
			Amount,
			SampleContainer,
			SampleContainerLabel,
			Method,
			Desiccant,
			DesiccantPhase,
			DesiccantAmount,
			Desiccator,
			Time,
			SampleLabel,
			SampleOutLabel,
			ContainerOut,
			ContainerOutLabel,
			SamplesOutStorageCondition
		}
	];

	(*Create resource packet for sampleContainer if needed*)
	sampleContainerResources = MapThread[If[
		NullQ[#], Null,
		If[MatchQ[#, ObjectP[Object]],
			Link[Resource[Sample -> #, Name -> #2], Protocols],
			Link[Resource[Sample -> #, Name -> #2]]
		]]&, {sampleContainer, sampleContainerLabel}];

	(*Create resource packet for containerOut if needed*)
	containerOutResources = MapThread[If[
		NullQ[#], Null,
		If[MatchQ[#, ObjectP[Object]],
			Link[Resource[Sample -> #, Name -> #2], Protocols],
			Link[Resource[Sample -> #, Name -> #2]]
		]]&, {containerOut, containerOutLabel}];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = Which[
		MatchQ[myProtocolPacket, $Failed],
		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		SimulateCreateID[Object[Protocol, Desiccate]],
		True,
		Lookup[myProtocolPacket, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation = If[

		(* If we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
		(* and skipped resource packet generation. *)
		MatchQ[myProtocolPacket, $Failed],
		SimulateResources[
			<|
				Object -> protocolObject,
				Replace[SamplesIn] -> (Resource[Sample -> #]&) /@ mySamples,
				Desiccator -> Resource[Instrument -> Lookup[myResolvedOptions, Desiccator], Time -> Lookup[myResolvedOptions, Time]],
				Desiccant -> If[
					NullQ[desiccant] || NullQ[desiccantAmount],
					Null,
					Resource[Sample -> desiccant, Container -> Model[Container, Vessel, "id:4pO6dMOxdbJM"], Amount -> desiccantAmount] (*Pyrex Crystallization Dish*)
				],
				Replace[SampleContainers] -> sampleContainerResources,
				Replace[ContainersOut] -> containerOutResources,
				ResolvedOptions -> myResolvedOptions
			|>,
			Cache -> cache,
			Simulation -> Lookup[ToList[myResolutionOptions], Simulation, Null]
		],
		(* Otherwise, our resource packets went fine and we have an Object[Protocol, Desiccate]. *)
		SimulateResources[myProtocolPacket, myUnitOperationPackets, ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null], Simulation -> simulation]
	];

	(*If the sample is transferred from its input container to SampleContainer or ContainerOut, a new sample should be created*)
	(*Find out which inputs need new sample to be created*)

	(*Lookup inputContainers from samplePackets*)
	inputContainers = Download[Map[Lookup[#, Container]&, samplePackets], Object];

	simulatedProtocol = Download[protocolObject, Simulation -> currentSimulation];

	simulatedSampleContainer = Lookup[simulatedProtocol, SampleContainers];

	simulatedContainerOut = Lookup[simulatedProtocol, ContainersOut];

	(*needNewSampleQ is True when sample is transferred from input Container to newContainer (ampleContainer or ContainerOut)*)
	{needNewSampleQ, newContainer} = Transpose[
		MapThread[
			Which[
				(!MatchQ[#1, #3] && !NullQ[#3]),
				{True, #3},
				(!MatchQ[#1, #2] && !NullQ[#2]),
				{True, #2},
				True,
				{False, Null}]&,
			{inputContainers, simulatedSampleContainer, simulatedContainerOut}
		]
	];

	(*pick samples that need to create newSample for, also pick newContainer for newSample*)
	{simulatedSourceSamples, destinationContainer, transferAmount} =
		PickList[#, needNewSampleQ]& /@ {mySamples, newContainer, amount};

	(*Add position "A1" to destination containers to create destination locations*)
	destinationLocation = {"A1", #}& /@ destinationContainer;

	(* create sample out packets for anything that doesn't have sample in it already, this is pre-allocation for UploadSampleTransfer *)
	newSamplePackets = UploadSample[
		(*Note: UploadSample takes in {} if there is no Model and we have no idea what's in it, which is the case here *)
		ConstantArray[{}, Length[simulatedSourceSamples]],
		destinationLocation,
		State -> ConstantArray[Solid, Length[simulatedSourceSamples]],
		InitialAmount -> ConstantArray[Null, Length[simulatedSourceSamples]],
		Simulation -> currentSimulation,
		UpdatedBy -> protocolObject,
		FastTrack -> True,
		Upload -> False
	];

	(* update our simulation with new sample packets*)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[newSamplePackets]];

	(*Lookup Object[Sample]s from newSamplePackets*)
	simulatedNewSamples = DeleteDuplicates[Cases[Lookup[newSamplePackets, Object], ObjectReferenceP[Object[Sample]]]];

	(*figure out what are the SampleOut*)
	(*in mySamples, only keep samples when needNewSampleQ is False*)
	unchangedSamples = PickList[mySamples, needNewSampleQ, False];

	(*simulatedSamplesOut is the same as mySamples (input samples) if no new sample is generated (SampleContainer is Null for all samples).
	If new Sample is generated, the related input sample is substituted with the new generated sample*)
	simulatedSamplesOut = RiffleAlternatives[simulatedNewSamples, unchangedSamples, needNewSampleQ];

	(* Call UploadSampleTransfer on our source and destination samples. *)
	uploadSampleTransferPackets = UploadSampleTransfer[
		simulatedSourceSamples,
		simulatedNewSamples,
		transferAmount,
		Upload -> False,
		FastTrack -> True,
		Simulation -> currentSimulation,
		UpdatedBy -> protocolObject
	];

	(*update our simulation with UploadSampleTransferPackets*)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[uploadSampleTransferPackets]];

	(* Uploaded Labels *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleOutLabel]], Flatten@simulatedSamplesOut}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], Lookup[myResolvedOptions, SampleContainer]}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, ContainerOutLabel]], Lookup[myResolvedOptions, ContainerOut]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> Join[
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleOutLabel]], (Field[SamplesOut[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleContainer[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, ContainerOutLabel]], (Field[ContainerOut[[#]]]&) /@ Range[Length[mySamples]]}],
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

(* ::Subsection::Closed:: *)
(*Define Author for primitive head*)
Authors[Desiccate] := {"mohamad.zandian"};


(* ::Subsection::Closed:: *)
(*ExperimentDesiccateOptions*)


DefineOptions[ExperimentDesiccateOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentDesiccate}];

ExperimentDesiccateOptions[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentDesiccate *)
	options = ExperimentDesiccate[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentDesiccate],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentDesiccateQ*)


DefineOptions[ValidExperimentDesiccateQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentDesiccate}
];


ValidExperimentDesiccateQ[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, preparedOptions, experimentDesiccateTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentDesiccate *)
	experimentDesiccateTests = ExperimentDesiccate[myInputs, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[experimentDesiccateTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[ToList[myInputs], _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myInputs], _String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, experimentDesiccateTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentDesiccateQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentDesiccateQ"]
];

(* ::Subsection::Closed:: *)
(*ExperimentDesiccatePreview*)

DefineOptions[ExperimentDesiccatePreview,
	SharedOptions :> {ExperimentDesiccate}
];

ExperimentDesiccatePreview[myInputs : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for ExperimentDesiccate *)
	ExperimentDesiccate[myInputs, Append[noOutputOptions, Output -> Preview]]];