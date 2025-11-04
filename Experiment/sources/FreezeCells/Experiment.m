(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*FreezeCells*)

(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[ExperimentFreezeCells,
	Options :> {
		{
			OptionName -> Preparation,
			Default -> Manual,
			Description -> "Indicates if this unit operation is carried out primarily robotically or manually. Manual unit operations are executed by a laboratory operator and robotic unit operations are executed by a liquid handling work cell.",
			AllowNull -> False,
			Category -> "Hidden",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Manual]
			]
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[2, 48, 1]
			],
			Description -> "Specifies how many identical frozen cell stock samples are prepared from each provided sample. For example, if NumberOfReplicates is set to 2, two cryogenic vials with identical contents are generated as a result of this experiment. This also indicates that the samples are transferred into new cryogenic vials. If NumberOfReplicates is set to Null, one and only one CryogenicSampleContainer is generated.",
			Category -> "General"
		},
		{
			OptionName -> FreezingStrategy,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> FreezeCellMethodP (* InsulatedCooler | ControlledRateFreezer *)
			],
			Description -> "The manner in which the cell sample(s) are frozen. ControlledRateFreezer employs a programmable instrument that electronically controls the sample temperature to freeze the cell sample(s), allowing the user to specify a multi-stage TemperatureProfile if desired. InsulatedCooler employs a rack submerged in a coolant solution, which is placed in a freezer to freeze the cell sample(s).",
			ResolutionDescription -> "If either Coolant or InsulatedCoolerFreezingTime is specified, or an ultra-low temperature freezer is specified as Freezer, or CryogenicSampleContainer is set to a cryogenic vial model with MaxVolume larger than 2 Milliliter, automatically set to InsulatedCooler. Otherwise, automatically set to ControlledRateFreezer.",
			Category -> "General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* ---------- General Options ---------- *)
			ModifyOptions[ExperimentIncubateCells,
				OptionName -> CellType,
				ResolutionDescription -> "Automatically set to match the value of CellType of the input sample if it is populated, otherwise set to Bacterial.",
				Category -> "General"
			],
			ModifyOptions[ExperimentIncubateCells,
				OptionName -> CultureAdhesion,
				ResolutionDescription -> "Automatically set to match the CultureAdhesion value of the input sample if it is populated, otherwise set to Suspension.",
				Category -> "General"
			],
			ModifyOptions[InSituOption,
				Default -> Automatic,
				Description -> "Whether to freeze the input sample in its current container rather than transferring them to new cryogenic vial(s).",
				ResolutionDescription -> "If the input sample is not in a container with a CryogenicVial Footprint, or either Aliquot options or NumberOfReplicates are specified, automatically set to False. If Aliquot is set to False, automatically set to True.",
				IndexMatching -> True,
				IndexMatchingOptions -> {}
			],
			{
				OptionName -> CryogenicSampleContainer,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Container, Vessel], Model[Container, Vessel]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Containers", "Cryogenic Vials"}
					}
				],
				Description -> "The desired container model for freezing the cell stock, or, if samples are frozen in situ, the original container holding the input sample. All resulting containers are frozen and stored under cryogenic conditions.",
				ResolutionDescription -> "If Aliquot is False, automatically set to the original container holding the input sample. If Aliquot is True and FreezingStrategy is set to ControlledRateFreezer, automatically set to Model[Container, Vessel, \"2mL Cryogenic Vial\"]. If Aliquot is True and FreezingStrategy is set to InsulatedCooler, automatically set to a container with a CryogenicVial Footprint and sufficient capacity to hold the cell stock(s), accounting for ice expansion by limiting fill volume to 75% to prevent vial rupture.",
				Category -> "General"
			},
			{
				OptionName -> CryogenicSampleContainerLabel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				Description -> "The base label for all containers of frozen cell stock samples being prepared for the input cell sample in this experiment. If NumberOfReplicates is set, automatically expand to include replica number in the final label. Otherwise, the base label is the final label. The final label is used for identification in downstream unit operations.",
				ResolutionDescription -> "If NumberOfReplicates is set, automatically set CryogenicSampleContainerLabel to \"freeze cells cryogenic sample container # replicate #\", otherwise set to \"freeze cells cryogenic sample container #\".",
				Category -> "General",
				UnitOperation -> True
			},
			(* ---------- Master Switches ---------- *)
			{
				OptionName -> CryoprotectionStrategy,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[ChangeMedia, AddCryoprotectant, None]
				],
				Description -> "The manner in which the cell sample(s) are processed prior to freezing in order to protect the cells from detrimental ice formation. If ChangeMedia is selected, the entire input sample is pelleted, the existing media is removed and replaced with CryoprotectantSolution, resulting in cell stocks suspended in CryoprotectantSolution. If AddCryoprotectant is selected, the CryoprotectantSolution and a portion of the input sample is added directly to the CryogenicSampleContainer when Aliquot is True, or the CryoprotectantSolution is added directly to the input sample if freezing samples in situ is desired. In both cases, the resulting cell stocks consist of cells in the original medium supplemented with CryoprotectantSolution. If None is selected, the existing media is left unchanged, and the sample is mixed before being put inside of Freezer to ensure a uniform suspension.",
				ResolutionDescription -> "Automatically set to ChangeMedia if any of CellPelletCentrifuge, CellPelletTime, CellPelletIntensity, or CellPelletSupernatantVolume are specified. Otherwise, automatically set to AddCryoprotectant.",
				Category -> "General"
			},
			(* ---------- ChangeMedia Options ---------- *)
			ModifyOptions[ExperimentPellet,
				Instrument,
				OptionName -> CellPelletCentrifuge,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Instrument, Centrifuge], Object[Instrument, Centrifuge]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Centrifugation", "Centrifuges"},
						{Object[Catalog, "Root"], "Instruments", "Centrifugation", "Microcentrifuges"}
					}
				],
				Description -> "The centrifuge used to pellet the cell sample(s) in order to remove the existing media and replace with CryoprotectantSolution. See Figure 3.1 for CellPelletCentrifuge models compatible with common container footprints. For complete details on all CellPelletCentrifuge models, refer to the \"Instrumentation\" section of the ExperimentCentrifuge helpfile.",
				ResolutionDescription -> "Automatically set to a centrifuge that can attain the specified CellPelletIntensity and is compatible with the sample in its current container if CryoprotectionStrategy is set to ChangeMedia.",
				Category -> "Media Changing"
			],
			ModifyOptions[ExperimentPellet,
				Time,
				OptionName -> CellPelletTime,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The duration of time for which the sample(s) are centrifuged in order to pellet the cells, enabling removal of existing media.",
				ResolutionDescription -> "Automatically set to 5 Minute if CryoprotectionStrategy is set to ChangeMedia.",
				Category -> "Media Changing"
			],
			ModifyOptions[ExperimentPellet,
				Intensity,
				OptionName -> CellPelletIntensity,
				AllowNull -> True,
				Description -> "The rotational speed or force applied to the cell sample(s) by centrifugation in order to create a pellet, enabling removal of existing media.",
				ResolutionDescription -> "If CryoprotectionStrategy is set to ChangeMedia, automatically set to the default value effective for pelleting the given CellType option: for Mammalian is 300 g, for Bacterial is 2000 g, and for Yeast is 1000 g.",
				Category -> "Media Changing"
			],
			ModifyOptions[ExperimentPellet,
				SupernatantVolume,
				OptionName -> CellPelletSupernatantVolume,
				AllowNull -> True,
				Description -> "The volume of supernatant to be removed from the cell sample(s) following pelleting.",
				ResolutionDescription -> "Automatically set to All if CryoprotectionStrategy is set to ChangeMedia.",
				Category -> "Media Changing"
			],
			(* ---------- Cryoprotection Options ---------- *)
			{
				OptionName -> CryoprotectantSolution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Materials", "Cell Culture", "Cryoprotectants"}
					}
				],
				Description -> "The solution which contains high concentration of cryoprotective agents, such as glycerol and DMSO. The cryoprotectant solution protects the cells during freezing and thawing by preventing ice crystals from forming inside or around cells. See Figure 3.2 for more information about suggested cryoprotectant solutions for different cell types and strategies.",
				ResolutionDescription -> "If CryoprotectionStrategy is set to AddCryoprotectant, CryoprotectantSolution is automatically set to Model[Sample, StockSolution, \"50% Glycerol in Milli-Q water, Autoclaved\"] for bacterial and yeast cells, and to Model[Sample, StockSolution, \"30% Glycerol in Milli-Q water, Autoclaved\"] for mammalian cells. If CryoprotectionStrategy is set to ChangeMedia, CryoprotectantSolution is automatically set to Model[Sample, \"Gibco Recovery Cell Culture Freezing Medium\"] for mammalian cells, to Model[Sample, StockSolution, \"15% glycerol, 0.5% sodium chloride, Autoclaved\"] for bacterial cells, and to Model[Sample, StockSolution, \"30% Glycerol in Milli-Q water, Autoclaved\"] for yeast cells.",
				Category -> "Cryoprotection"
			},
			{
				OptionName -> CryoprotectantSolutionVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter, 180 Milliliter], (* 180 mL corresponds to three full 5 mL Mr Frosty racks with all vials at full capacity *)
						Units -> {Milliliter, {Microliter, Milliliter}}
				],
				Description -> "The amount of CryoprotectantSolution to be added to the cell sample.",
				ResolutionDescription -> "If CryoprotectionStrategy is set to ChangeMedia, the volume is automatically set to match the CellPelletSupernatantVolume that is removed following pelleting. This volume is used to resuspend the cell pellet obtained from the entire sample, prior to aliquoting into cryogenic vials, if applicable. If CryoprotectionStrategy is set to AddCryoprotectant, the volume is automatically set to 50% of the sample volume to be mixed with. When Aliquot is True, this corresponds to 50% of the AliquotVolume. When Aliquot is False, this corresponds to 50% of the total input sample volume.",
				Category -> "Cryoprotection"
			},
			(* ---------- Aliquoting Options ---------- *)
			ModifyOptions[AliquotOptions,
				OptionName -> Aliquot,
				Description -> "Indicates whether to prepare cell stocks in new cryogenic vials rather than in the current container of the provided sample. If CryoprotectionStrategy is set to ChangeMedia, aliquoting occurs after pelleting the entire sample and replacing the existing media with CryoprotectantSolution. If CryoprotectionStrategy is set to AddCryoprotectant or None, aliquoting occurs before the addition of CryoprotectantSolution. See Figure 1.1 and 1.2 in the \"Experimental Principles\" section of the ExperimentFreezeCells helpfile for more information.",
				ResolutionDescription -> "Automatically set to True if AliquotVolume, NumberOfReplicates, or a new CryogenicSampleContainer is specified, if the sample's current container has a Footprint other than CryogenicVial, or if the total volume of the cell stock exceeds 75% of the current container's maximum capacity. Otherwise, set to False."
			],
			{
				OptionName -> AliquotVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter, 5 Milliliter],
						Units -> {Milliliter, {Microliter, Milliliter}}
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
				Description -> "The volume of suspended cell sample that is transferred into new cryogenic sample containers. If CryoprotectionStrategy is set to ChangeMedia, the entire input sample is pelleted and resuspended in CryoprotectantSolution. In this case, the AliquotVolume refers to the specified amount of the resuspended cells being transferred into new cryogenic sample containers. If CryoprotectionStrategy is set to AddCryoprotectant or None, AliquotVolume refers to the specified amount of the well-mixed original input sample that is transferred into new cryogenic containers.",
				ResolutionDescription -> "If Aliquot is True and CryoprotectionStrategy is set to ChangeMedia or None, automatically set to the lesser of 75% of the volume of the CryogenicSampleContainer (to account for ice expansion and prevent vial rupture) or the total volume of the suspended cell sample divided equally among the number of frozen cell stocks being prepared. If Aliquot is True and CryoprotectionStrategy is set to AddCryoprotectant, automatically set to the lesser of 75% of the volume of the CryogenicSampleContainer minus the volume of CryoprotectantSolution or the total volume of the suspended cell sample divided equally among the number of frozen cell stocks being prepared.",
				Category -> "Aliquoting"
			},
			(* ---------- General Cell Freezing Options ---------- *)
			{
				OptionName -> FreezingRack,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Rack], Object[Container, Rack], Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Containers", "Cell Freezing Containers"}
					}
				],
				Description -> "The insulated cooler rack or controlled rate freezer-compatible sample rack used to freeze the cell sample(s). See Figure 3.3 or Figure 2.1 and 2.2 in the \"Instrumentation\" section of the ExperimentFreezeCells helpfile for more information.",
				ResolutionDescription -> "Automatically set to Model[Container, Rack, \"2mL Cryo Rack for VIA Freeze\"] if FreezingStrategy is set to ControlledRateFreezer. If FreezingStrategy is set to InsulatedCooler, automatically set to a rack that can accommodate the vials containing the experiment samples.",
				Category -> "Cell Freezing"
			},
			{
				OptionName -> Freezer,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{
						Model[Instrument, ControlledRateFreezer],
						Object[Instrument, ControlledRateFreezer],
						Model[Instrument, Freezer]
					}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Instruments", "Cell Culture", "Cell Freezing"},
						{Object[Catalog, "Root"], "Instruments", "Storage Devices", "Freezers", "-80 Celsius"}
					}
				],
				Description -> "The device supplies low temperatures and either electronically regulates the TemperatureProfile or drives the cooling process of an insulated cooler placed inside to cool the cell sample(s). A controlled-rate freezer allows user-programmable cooling TemperatureProfile with cooling rates from 0.01 Celsius/Minute to 2 Celsius/Minute, whereas an ultra-low temperature freezer holds an insulated cooler filled with Coolant, providing an approximate cooling rate of of 1 Celsius/Minute. See \"Instrumentation\" section of the ExperimentFreezeCells helpfile for more information.",
				ResolutionDescription -> "Automatically set to Model[Instrument, ControlledRateFreezer, \"VIA Freeze Research\"] if FreezingStrategy is set to ControlledRateFreezer. Otherwise, automatically set to Model[Instrument, Freezer, \"Stirling UltraCold SU780UE\"] maintained at -80 Celsius. In order to maximize the efficiency of freezer storage in the laboratory, user specification of a particular Object[Instrument, Freezer] is not supported.",
				Category -> "Cell Freezing"
			},
			(* ---------- InsulatedCooler Options ---------- *)
			{
				OptionName -> Coolant,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Materials", "Cell Culture", "Coolants"}
					}
				],
				Description -> "Liquid that fills the chamber of the insulated cooler in which the sample rack is immersed. The coolant is employed to achieve gradual cooling of the cell sample(s).",
				ResolutionDescription -> "Automatically set to Model[Sample, \"Isopropanol\"] if FreezingStrategy is set to InsulatedCooler.",
				Category -> "Cell Freezing"
			},
			(* ---------- Storage Options ---------- *)
			{
				OptionName -> SamplesOutStorageCondition,
				Default -> CryogenicStorage,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CellStorageTypeP
				],
				Description -> "The long-term storage condition for the cell sample(s) after freezing.",
				Category -> "Storage"
			}
		],
		{
			OptionName -> InsulatedCoolerFreezingTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[4 Hour, $MaxExperimentTime],(* Consider the phase transition and cooling rate at -1C/min outside of melting zone, 4 hour is the minimum *)
				Units -> {Hour, {Minute, Hour}}
			],
			Description -> "The minimum duration for which the cell stock(s) within an insulated cooler are kept within the Freezer to freeze the cells prior to being transported to SamplesOutStorageCondition.",
			ResolutionDescription -> "Automatically set to 12 Hour if FreezingStrategy is set to InsulatedCooler.",
			Category -> "Cell Freezing"
		},
		{
			OptionName -> CryoprotectantSolutionTemperature,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Ambient, Chilled]
			],
			Description -> "The temperature of the CryoprotectantSolution prior to its addition to the cell sample(s). If set to Chilled, the CryoprotectantSolution is placed in a cooler maintained at 4 Celsius for the following duration depending on the CryoprotectantSolutionVolume multiplied by the NumberOfReplicates: 20 Minute for a total volume less than 5 Milliliter, 1 Hour for a total volume of at least 5 Milliliter but no more than 50 Milliliter, and 2 Hour for a total volume greater than 50 Milliliter.",
			ResolutionDescription -> "Automatically set to Chilled if CryoprotectionStrategy is set to AddCryoprotectant or ChangeMedia.",
			Category -> "Cryoprotection"
		},
		{
			OptionName -> TemperatureProfile,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Adder[
				{
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[-100 Celsius, 25 Celsius],
						Units -> {Celsius, {Celsius, Kelvin, Fahrenheit}}
					],
					"Time" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Hour, 24 Hour],
						Units -> {Minute, {Minute, Hour}}
					]
				},
				Orientation -> Horizontal
			],
			Description -> "The series of cooling steps applied to the cell sample(s). The specified time is cumulative (i.e., the total time elapsed from the beginning of freezing is specified at each time point) and the profile linearly interpolates between the specified points. For example, between the points {0 Celsius, 10 Minute} and {-60 Celsius, 40 Minute}, the temperature would decrease at a constant rate of 2 Celsius/Minute for 30 Minutes. The last specified temperature is held until the samples are transported to the final storage. An initial temperature is assumed to be 25 Celsius at the initial time point.",
			ResolutionDescription -> "If FreezingStrategy is set to ControlledRateFreezer, automatically set to a profile which results in linear cooling at 1 Celsius per Minute beginning at 25 Celsius and terminating at -80 Celsius.",
			Category -> "Cell Freezing"
		},
		(* Shared Options *)
		ProtocolOptions,
		CacheOption,
		SimulationOption
	}
];

(* ::Subsubsection::Closed:: *)
(* ExperimentFreezeCells Source Code *)

(*---Container to Sample Overload---*)
ExperimentFreezeCells[myInputs:ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String|{LocationPositionP, _String|ObjectP[Object[Container]]}], myOptions:OptionsPattern[ExperimentFreezeCells]] := Module[
	{
		outputSpecification, output, gatherTests, messages, listedInputs, listedOptions, validSamplePreparationResult,
		myInputsWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation, containerToSampleResult,
		containerToSampleOutput, containerToSampleSimulation, containerToSampleTests, samples, sampleOptions
	},

	(* Determine the requested return value from the function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Remove temporal links. *)
	(* Make sure we're working with a list of options/inputs. *)
	{listedInputs, listedOptions} = {ToList[myInputs], ToList[myOptions]};

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{myInputsWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentFreezeCells,
			listedInputs,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentFreezeCells,
			myInputsWithPreparedSamplesNamed,
			myOptionsWithPreparedSamplesNamed,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentFreezeCells,
				myInputsWithPreparedSamplesNamed,
				myOptionsWithPreparedSamplesNamed,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* If containerToSampleOptions failed - return $Failed. *)
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
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentFreezeCells[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];

(*---Main function accepting sample objects as inputs---*)
ExperimentFreezeCells[mySamples:ListableP[ObjectP[Object[Sample]]], myOptions:OptionsPattern[ExperimentFreezeCells]] := Module[
	{
		(* General *)
		outputSpecification, output, gatherTests, messages, listedSamples, listedOptions, mySamplesWithPreparedSamplesNamed,
		myOptionsWithPreparedSamplesNamed, updatedSimulation, validSamplePreparationResult, safeOpsNamed, safeOpsTests,
		mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples, validLengths, validLengthTests, templatedOptions,
		templateTests, inheritedOptions, upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, expandedSafeOps,

		(* Download *)
		optionsWithObjects, objectsFromOptions, defaultSampleModels, defaultContainerModels, defaultCryogenicVials, defaultInstrumentModels,
		allPotentialSamples, allPotentialContainers, allPotentialInstruments, sampleObjects, modelSampleObjects, instrumentObjects,
		modelInstrumentObjects, objectContainerObjects, modelContainerObjects, modelFreezerFields, modelControlledRateFreezerFields,
		modelCentrifugeFields, objectSampleFields, modelSampleFields, objectContainerFields, modelContainerFields, modelInstrumentFields,
		cellModelFields, downloadedCache, parentProtocolStack, cacheBall,

		(* Options, Simulation, Resource Packets, and Result *)
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly,
		returnEarlyBecauseFailuresQ, performSimulationQ, protocolPacketWithResources, resourcePacketTests, numericNumberOfReplicates,
		expandedSamplesWithReplicates, simulatedProtocol, simulation, uploadProtocolOptions, result, estimatedRunTime
	},

	(* Determine the requested return value from the function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Remove temporal links and make sure we're working with a list of options/inputs. *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentFreezeCells,
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew]; Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern. *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentFreezeCells, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentFreezeCells, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Call sanitize-inputs to clean any named objects. *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed. *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length. *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentFreezeCells, {listedSamples}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentFreezeCells, {listedSamples}, listedOptions], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point). *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions. *)
	{templatedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentFreezeCells, {ToList[mySamplesWithPreparedSamples]}, ToList[myOptionsWithPreparedSamples], Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentFreezeCells, {ToList[mySamplesWithPreparedSamples]}, ToList[myOptionsWithPreparedSamples]], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[inheritedOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options. *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentFreezeCells, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Any options whose values could be an object. *)
	optionsWithObjects = {
		CryoprotectantSolution,
		Coolant,
		FreezingRack,
		CryogenicSampleContainer,
		Freezer,
		CellPelletCentrifuge
	};

	(* Get the objects from these options. *)
	objectsFromOptions = Cases[Flatten@Lookup[expandedSafeOps, optionsWithObjects], ObjectP[]];

	(* Default sample models from resolver. *)
	defaultSampleModels = {
		(* CryoprotectantSolution *)
		Model[Sample, "id:M8n3rxn4JVBE"], (* Model[Sample, "Gibco Recovery Cell Culture Freezing Medium"] *)
		Model[Sample, StockSolution, "id:Vrbp1jbnEBPw"], (* Model[Sample, StockSolution, "15% glycerol, 0.5% sodium chloride, Autoclaved"] *)
		Model[Sample, StockSolution, "id:1ZA60vAO7xla"], (* Model[Sample, StockSolution, "30% Glycerol in Milli-Q water, Autoclaved"] *)
		Model[Sample, StockSolution, "id:E8zoYvzX1NKB"], (*  Model[Sample, StockSolution, "50% Glycerol in Milli-Q water, Autoclaved"] *)
		(* Coolant *)
		Model[Sample, "id:jLq9jXY4k6da"] (* Model[Sample, "Isopropanol"] *)
	};

	(* Get the default container and instrument models. *)
	defaultContainerModels = Experiment`Private`freezeCellsContainerSearch["Memoization"];
	defaultCryogenicVials = Experiment`Private`freezeCellsCryogenicVialSearch["Memoization"];
	defaultInstrumentModels = Experiment`Private`freezeCellsInstrumentSearch["Memoization"];

	(* Gather all of the objects which may contain samples, containers, and instruments. *)
	allPotentialSamples = DeleteDuplicates[Link[Flatten[{mySamplesWithPreparedSamples, objectsFromOptions, defaultSampleModels}]]];
	allPotentialContainers = DeleteDuplicates[Link[Flatten[{objectsFromOptions, defaultContainerModels, defaultCryogenicVials}]]];
	allPotentialInstruments = DeleteDuplicates[Link[Flatten[{objectsFromOptions, defaultInstrumentModels}]]];

	(* Group the objects by Type. *)
	sampleObjects = Cases[allPotentialSamples, ObjectP[Object[Sample]]];
	modelSampleObjects = Cases[allPotentialSamples, ObjectP[Model[Sample]]];
	instrumentObjects = Cases[allPotentialInstruments, ObjectP[Object[Instrument]]];
	modelInstrumentObjects = Cases[allPotentialInstruments, ObjectP[Model[Instrument]]];
	objectContainerObjects = Cases[allPotentialContainers, ObjectP[Object[Container]]];
	modelContainerObjects = Cases[allPotentialContainers, ObjectP[Model[Container]]];

	(* Identify the Download Fields. *)
	modelFreezerFields = {Deprecated, MinTemperature, MaxTemperature, DefaultTemperature};
	modelControlledRateFreezerFields = {MaxCoolingRate, MinCoolingRate, Deprecated, MinTemperature, MaxTemperature};
	modelCentrifugeFields = {Objects, Deprecated, DeveloperObject, MaxRotationRate, MinRotationRate, SpeedResolution, MaxTime};
	objectSampleFields = Union[{Notebook}, SamplePreparationCacheFields[Object[Sample]]];
	modelSampleFields = Union[{Preparable}, SamplePreparationCacheFields[Model[Sample]]];
	objectContainerFields = Union[{Notebook, NumberOfPositions}, SamplePreparationCacheFields[Object[Container]]];
	modelContainerFields = Union[{NumberOfPositions}, SamplePreparationCacheFields[Model[Container]]];
	modelInstrumentFields = Union[{Name, Deprecated}, modelFreezerFields, modelControlledRateFreezerFields, modelCentrifugeFields];
	cellModelFields = {CellType, CultureAdhesion};

	(* Combine our simulated cache and download cache. *)
	downloadedCache = Quiet[
		Download[
			{
				sampleObjects,
				modelSampleObjects,
				instrumentObjects,
				modelInstrumentObjects,
				objectContainerObjects,
				modelContainerObjects,
				{parentProtocol} /. {Null -> Nothing}
			},
			{
				{
					Evaluate[Packet@@objectSampleFields],
					Packet[Model[modelSampleFields]],
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][modelContainerFields]],
					Packet[Composition[[All, 2]][cellModelFields]]
				},
				{Evaluate[Packet@@modelSampleFields]},
				{
					Packet[Name, Status, Model, Contents],
					Packet[Model[modelInstrumentFields]]
				},
				{Evaluate[Packet@@modelInstrumentFields]},
				{
					Evaluate[Packet@@objectContainerFields],
					Packet[Model[modelContainerFields]]
				},
				{Evaluate[Packet@@modelContainerFields]},
				{Object, ParentProtocol..[Object]}
			},
			Cache -> cache,
			Simulation -> updatedSimulation
		],
		{Download::FieldDoesntExist}
	];

	(* Pull out the parent protocol stack *)
	parentProtocolStack = Flatten[downloadedCache[[7]]];

	cacheBall = FlattenCachePackets[{cache, downloadedCache}];

	(* Build the resolved options. *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentFreezeCellsOptions[
			mySamplesWithPreparedSamples,
			expandedSafeOps,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {
				resolveExperimentFreezeCellsOptions[
					mySamplesWithPreparedSamples,
					expandedSafeOps,
					Cache -> cacheBall,
					Simulation -> updatedSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options. *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentFreezeCells,
		resolvedOptions,
		Ignore -> listedOptions,
		Messages -> False
	];

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

	(* NOTE: We need to perform simulation if Result is asked for in FreezeCells since it's part of the SamplePreparation experiments. *)
	(* This is because we pass down our simulation to ExperimentMSP or ExperimentRSP. *)
	performSimulationQ = MemberQ[output, (Result|Simulation)];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> RemoveHiddenOptions[ExperimentFreezeCells, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources. *)
	{protocolPacketWithResources, resourcePacketTests} = Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
			{$Failed, {}},
		gatherTests,
			freezeCellsResourcePackets[
				mySamplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache -> cacheBall,
				Simulation -> updatedSimulation,
				Output -> {Result, Tests}
			],
		True,
			{
				freezeCellsResourcePackets[
					mySamplesWithPreparedSamples,
					templatedOptions,
					resolvedOptions,
					collapsedResolvedOptions,
					Cache -> cacheBall,
					Simulation -> updatedSimulation
				],
				{}
			}
	];

	(* Set the numericNumberOfReplicates to expand the samples for replicates. *)
	numericNumberOfReplicates = Lookup[collapsedResolvedOptions, NumberOfReplicates] /. Null -> 1;

	(* Expand the samples according to the number of replicates. *)
	expandedSamplesWithReplicates = Flatten[Map[
		ConstantArray[#, numericNumberOfReplicates]&,
		Download[ToList[mySamplesWithPreparedSamples], Object]
	]];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		(* If the resource packets function fails, just give an empty simulation instead of calling simulateExperimentFreezeCells. *)
		MatchQ[protocolPacketWithResources, $Failed],
			{$Failed, Simulation[]},
		performSimulationQ,
			simulateExperimentFreezeCells[
				protocolPacketWithResources[[1]], (* protocolPacket *)
				Flatten[ToList[protocolPacketWithResources[[2]]]], (* unitOperationPackets *)
				ToList[expandedSamplesWithReplicates],
				protocolPacketWithResources[[3]], (* all options expanded for replicates *)
				Cache -> cacheBall,
				Simulation -> updatedSimulation
			],
		True,
			{Null, updatedSimulation}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentFreezeCells, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	(* Put the UploadProtocol options together so we don't have to type them out multiple times*)
	(* making it a sequence because UploadProtocol misbehaves with lists sometimes *)
	uploadProtocolOptions = Sequence[
		Upload -> Lookup[safeOps, Upload],
		Confirm -> Lookup[safeOps, Confirm],
		CanaryBranch -> Lookup[safeOps, CanaryBranch],
		ParentProtocol -> Lookup[safeOps, ParentProtocol],
		Priority -> Lookup[safeOps, Priority],
		StartDate -> Lookup[safeOps, StartDate],
		HoldOrder -> Lookup[safeOps, HoldOrder],
		QueuePosition -> Lookup[safeOps, QueuePosition],
		ConstellationMessage -> {Object[Protocol, FreezeCells]},
		Cache -> cacheBall,
		Simulation -> simulation
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	result = Which[

		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[protocolPacketWithResources, $Failed]||MatchQ[resolvedOptionsResult, $Failed],
			$Failed,

		(* Otherwise, upload a real protocol that's ready to be run. *)
		True,
			UploadProtocol[
				protocolPacketWithResources[[1]],
				protocolPacketWithResources[[2]],
				uploadProtocolOptions
			]
	];

	(* Estimate the RunTime using the relevant resolved options. *)
	estimatedRunTime = Module[
		{resolvedCryoprotectantSolutions, resolvedInsulatedCoolerFreezingTime, resolvedTemperatureProfile, cryoprotectantPrepTime, freezingTime},
		(* Get the resolved options that will impact the RunTime. *)
		{resolvedCryoprotectantSolutions, resolvedInsulatedCoolerFreezingTime, resolvedTemperatureProfile} = Lookup[
			collapsedResolvedOptions,
			{CryoprotectantSolution, InsulatedCoolerFreezingTime, TemperatureProfile}
		];
		(* Assume that preparing and chilling cryoprotectant solutions will take 3 hours unless there are none. *)
		cryoprotectantPrepTime = If[MatchQ[resolvedCryoprotectantSolutions, NullP], 0 Hour, 3 Hour];
		(* The freezing time depends on which freezing strategy is used. *)
		freezingTime = Which[
			(* If InsulatedCoolerFreezingTime is specified, use that. *)
			MatchQ[resolvedInsulatedCoolerFreezingTime, GreaterP[0 Minute]],
				resolvedInsulatedCoolerFreezingTime,
			(* If there is a specified TemperatureProfile, use the last time entry. *)
			MatchQ[resolvedTemperatureProfile, Except[Null]],
				Last @ Cases[Flatten[resolvedTemperatureProfile], GreaterP[0 Minute]],
			(* If resolution went awry somehow, set this to 6 Hour just in case. *)
			True,
				6 Hour
		];
		(* Add the cryo prep time and the freezing time, and add 1 hour for additional transit time. *)
		(cryoprotectantPrepTime + freezingTime + 1 Hour)
	];

	(* Return requested output. *)
	outputSpecification/.{
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentFreezeCells, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> estimatedRunTime
	}
];


(* ::Subsubsection::Closed:: *)
(* Errors and warnings *)
(* Invalid Inputs *)
Error::FreezeCellsNonLiquidSamples = "ExperimentFreezeCells only supports liquid samples. `1` not in liquid state and cannot be processed. `2`.";
Error::FreezeCellsDuplicatedSamples = "`1`. `2`. Please `3`.";
Error::InvalidChangeMediaSamples = "ExperimentFreezeCells centrifuges the prepared plates directly during the pelleting step, keeping all samples in each plate together. `1`. Please use ExperimentTransfer to transfer `2` to avoid spinning down additional samples or specify `3`.";
(* Invalid Options *)
Warning::FreezeCellsAliquotingRequired = "`1`. `2`. `3`";
Warning::FreezeCellsReplicateLabels = "The NumberOfReplicates option is set to `1`, so each of the input samples will be partitioned into `1` identical samples with the following unique CryogenicSampleContainerLabels: `2`";
Warning::FreezeCellsUnusedSample = "`1` expected to have a total volume of `2` prior to aliquoting, factoring in any media change. Under these conditions, `3` of the sample(s) will not be aliquoted and will therefore not be frozen. Consider adjusting the AliquotVolume and/or the NumberOfReplicates to increase the amount of sample that will be frozen in the protocol.";
Error::CryogenicVialAliquotingRequired = "`1`. `2`. For `3`, please set the Aliquot option be True to allow transferring samples to cryogenic vials in order to submit a valid experiment.";
Error::FreezeCellsConflictingAliquotOptions = "The option AliquotVolume applies only when the option Aliquot is set to True. `1`. For `2`, please adjust these options in order to submit a valid experiment.";
Error::FreezeCellsReplicatesAliquotRequired = "`1`, the option Aliquot is required to be True. `2` the Aliquot option set to False, while `3`. Please set the Aliquot option to True or allow the option to be set automatically in order to submit a valid experiment.";
Error::InsufficientVolumeForAliquoting = "`1`. `2`.";
Error::SupernatantOveraspiratedTransfer = "`1`. `2`, please lower the CellPelletSupernatantVolume or specify All to submit a valid experiment.";
Error::CryoprotectantSolutionOverfill = "`1`. `2`. `3` in order to submit a valid experiment.";
Error::ExcessiveCryogenicSampleVolume = "When preparing frozen cell stocks, the final volume must remain below 75% of the cryogenic containers' MaxVolume to account for ice expansion and prevent rupture. Under the currently specified experimental conditions, `1`. `2`";
Error::FreezeCellsNoCompatibleCentrifuge = "`1`. `2`. No centrifuge instrument currently at ECL is compatible with this combination. Please `3` to submit a valid experiment. Consider using the function CentrifugeDevices[] to learn more about available centrifuge instruments and their capabilities.";
Error::CellPelletCentrifugeIsIncompatible = "The Specified CellPelletCentrifuge option is not valid since `1`. `2`. `3` or let the options be set automatically. Consider using the function CentrifugeDevices[] to learn more about available centrifuge instruments and their capabilities.";
Error::ConflictingChangeMediaOptionsForSameContainer = "ExperimentFreezeCells centrifuges the prepared plates directly during the pelleting step, keeping all samples in each plate together. `1`. For these sample(s), please `2`.";
Error::InvalidFreezingRack = "`1`. Please either specify `2` or allow the FreezingRack option to be set automatically in order to submit a valid experiment.";
Error::InvalidCryogenicSampleContainer = "`1`. `2`. Please either specify an alternative CryogenicSampleContainer or allow the CryogenicSampleContainer option to be set automatically in order to submit a valid experiment. Please check the \"Preferred Input Containers\" section of the ExperimentFreezeCells helpfile for a list of acceptable cryogenic vials.";
Error::InvalidFreezerModel = "When FreezingStrategy is InsulatedCooler, all ultra-low temperature freezer Models must have a DefaultTemperature within 5 Celsius of -80 Celsius. `1`. Please select a different Freezer or allow the option to be set automatically in order to submit a valid experiment.";
Error::FreezeCellsUnsupportedTemperatureProfile = "`1`. The specified TemperatureProfile is invalid since `2`. Please adjust the TemperatureProfile in order to submit a valid experiment.";

(* Master switch FreezingStrategy *)
Error::ConflictingCellFreezingOptions = "`1`. `2`. `3` in order to submit a valid experiment.";
Error::FreezeCellsConflictingTemperatureProfile = "The option TemperatureProfile defines the cooling program of a controlled rate freezer and applies only when the option FreezingStrategy is set to ControlledRateFreezer. The FreezingStrategy option is set to `1`, but the TemperatureProfile option is `2`. Please adjust these options in order to submit a valid experiment.";
Error::FreezeCellsConflictingInsulatedCoolerFreezingTime = "The option InsulatedCoolerFreezingTime defines the minimum duration inside of an ultra-low temperature freezer and applies only when the option FreezingStrategy is set to InsulatedCooler. The FreezingStrategy option is set to `1`, but the InsulatedCoolerFreezingTime option is `2`. Please adjust these options in order to submit a valid experiment.";
Error::FreezeCellsConflictingHardware = "`1`. `2`. Please adjust these options or allow them to be set automatically.";
Error::FreezeCellsConflictingCoolant = "The option Coolant defines the liquid that fills the chamber of an insulated cooler and applies only when the option FreezingStrategy is set to InsulatedCooler. The option FreezingStrategy is set to `1` but `2`. Please adjust these options in order to submit a valid experiment.";
Error::TooManyControlledRateFreezerBatches = "Due to equipment and time constraints, a single protocol is limited to no more than one freezing batch when the FreezingStrategy is ControlledRateFreezer. Under the currently specified experimental conditions with `2` unique input samples and the NumberOfReplicates option set to `1`, `3` total samples will be frozen in this protocol, which exceeds the maximum capacity (48 samples) of a single rack for the ControlledRateFreezer instrument. As such, the experiment requires `4` cell freezing batches.  Please distribute the samples across multiple protocols such that multiple batches are not required.";
Error::TooManyInsulatedCoolerBatches = "Due to equipment and time constraints, a single protocol is limited to no more than three batches utilizing the InsulatedCooler strategy. Under the currently specified experimental conditions, FreezingStrategy is set to InsulatedCooler and `7` total FreezingRacks are required. The current experiment, if allowed, would require FreezingRacks `1`, which have a maximum capacity of `2` samples per rack including replicates. But there are currently `3` unique set(s) of freezing conditions with `4` unique input samples each, and the NumberOfReplicates option is set to `5`. Please distribute the samples across multiple protocols or adjust the Coolant, Freezer, and FreezingRack options (or allow these to be set automatically) to improve the consolidation of batches such that no more than three batches are required.";

(* Master switch CryoprotectionStrategy *)
Error::ConflictingCryoprotectionOptions = "`1`. `2`. `3` in order to submit a valid experiment.";
Warning::ConflictingCryoprotectantSolutionTemperature = "The option CryoprotectantSolutionTemperature applies only when the option CryoprotectionStrategy is ChangeMedia or AddCryoprotectant. For `1`, the CryoprotectantSolutionTemperature option is set to `2`, but the option CryoprotectionStrategy is None. ExperimentFreezeCells will process these sample(s) without any cryoprotectant solutions. If this is not desired, please change the option CryoprotectionStrategy to either ChangeMedia or AddCryoprotectant.";
Error::FreezeCellsInsufficientChangeMediaOptions = "When the CryoprotectionStrategy option is set to ChangeMedia, cell pelleting parameters must be specified to to enable separation of cells from existing media. `1` the CryoprotectionStrategy option set to ChangeMedia and `2` left unspecified. Please specify `3` to be set automatically in order to submit a valid experiment.";
Error::FreezeCellsExtraneousChangeMediaOptions = "When the CryoprotectionStrategy option is not ChangeMedia, cell pelleting parameters are not relevant. `1`. Please specify `2` to be set automatically in order to submit a valid experiment.";
Error::FreezeCellsInsufficientCryoprotectantOptions = "When the CryoprotectionStrategy option is not None, all cryoprotection options must be specified to define how to prepare cryoprotectant solutions and mix them with the samples. `1` while `2` left unspecified. Please specify the option CryoprotectionStrategy to None or allow the cryoprotection `3` to be set automatically in order to submit a valid experiment.";
Error::FreezeCellsExtraneousCryoprotectantOptions = "When the CryoprotectionStrategy option is None, all cryoprotection options are not relevant. `1` the CryoprotectionStrategy option set to None while `2` specified. Please specify a non-None CryoprotectionStrategy or allow the cryoprotection `3` to be set automatically in order to submit a valid experiment.";


(* ::Subsubsection::Closed:: *)
(*resolveExperimentFreezeCellsOptions *)

DefineOptions[
	resolveExperimentFreezeCellsOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentFreezeCellsOptions[mySamples: {ObjectP[Object[Sample]]...}, myOptions: {_Rule...}, myResolutionOptions: OptionsPattern[resolveExperimentFreezeCellsOptions]] := Module[
	{
		(* Setup and pre-resolve options *)
		outputSpecification, output, gatherTests, messages, notInEngine, cacheBall, simulation, fastAssoc, samplePackets,
		sampleModelPackets, sampleContainerPackets, sampleContainerModelPackets, sampleVolumeQuantities, inputContainerMaxVolumes,
		fastAssocKeysIDOnly, staticFreezerModelPackets, controlledRateFreezerPackets, controlledRateFreezerModelPackets,
		centrifugeModelPackets, freezingRackModelPackets, allPossibleFreezingRacks, whyCantThisModelBeCryogenicVial, expandedSuppliedOptions,
		resolvedNumberOfReplicates, numericNumberOfReplicates, resolvedCryogenicSampleContainerLabels, expandedSuppliedAliquot,
		expandedSuppliedAliquotVolumes, expandedSuppliedCryogenicSampleContainers, expandedSuppliedCryoprotectantSolutions,
		expandedSuppliedCryoprotectantSolutionVolumes, expandedSuppliedCryoprotectionStrategies, expandedSuppliedCentrifuges,
		expandedSuppliedPelletTimes, expandedSuppliedCentrifugeIntensities, expandedSuppliedSupernatantVolumes, userSpecifiedLabels,
		resolvedCryoprotectionStrategies, specifiedAliquotQs, finalInSituVolumes, semiresolvedInSitus, expandedSuppliedCryogenicSampleContainerPackets,
		resolvedFreezingStrategy, resolvedInSitus, resolvedAliquotBools, talliedSamplesWithStrategies, uniqueSampleToFinalCellStockNumsLookup,
		preResolvedLabels, frameworkNumberOfReplicates, correctNumberOfReplicates,

		(* Input invalidation check *)
		discardedSamplePackets, discardedInvalidInputs, discardedTest, deprecatedSampleModelPackets, deprecatedSampleModelInputs,
		deprecatedSampleInputs, deprecatedTest, mainCellIdentityModels, sampleCellTypes, validCellTypeQs, invalidCellTypeSamples,
		invalidCellTypeCellTypes, invalidCellTypeTest, duplicateSamplesCases, duplicatedSampleInputs, duplicateSamplesTest,
		inputContainerContents, stowawaySamples, uniqueStowawaySamples, invalidPlateSampleInputs, invalidPlateSampleTest,
		invalidPlateSampleContainers, sampleStates, nonLiquidSampleInvalidInputs, nonLiquidSampleTest, missingVolumeInvalidCases,
		missingVolumeTest, talliedSamplesWithNonChangeMediaOptions,

		(* Option precision check *)
		roundedFreezeCellsOptions, precisionTests,

		(* Pre-MapThread option resolutions *)
		resolvedPreparation, resolvedInsulatedCoolerFreezingTime, resolvedTemperatureProfile, resolvedCryoprotectantSolutionTemperature,
		resolvedGeneralOptions,

		(* Conflicting Options Checks I *)
		freezeCellsAliquotingRequiredCases, freezeCellsAliquotingRequiredTests, conflictingAliquotingErrors, conflictingAliquotingCases,
		conflictingAliquotingOptions, conflictingAliquotingTest, conflictingCryoprotectantSolutionTemperatureCases,
		conflictingCryoprotectantSolutionTemperatureTests, insufficientChangeMediaOptionsTests, insufficientChangeMediaOptions,
		extraneousChangeMediaOptions, extraneousChangeMediaOptionsTests, insufficientCryoprotectantOptions, insufficientCryoprotectantOptionsTests,
		extraneousCryoprotectantOptions, extraneousCryoprotectantOptionsTests, conflictingPelletOptionsForSameContainerAcrossSampleOptions,
		conflictingPelletOptionsForSameContainerAcrossSampleTests, conflictingCryoprotectionStrategyOptions,
		conflictingCryoprotectionStrategySamples, conflictingCryoprotectionStrategyTests,

		(* MapThread options and errors *)
		mapThreadFriendlyOptionsNotPropagated, indexMatchingChangeMediaOptionNames, indexMatchingChangeMediaSampleQ,
		nonAutomaticOptionsPerContainer, mergedNonAutomaticOptionsPerContainer, mapThreadFriendlyOptions, resolvedCellTypes,
		resolvedCultureAdhesions, resolvedCellPelletIntensities, resolvedCellPelletTimes, resolvedCellPelletSupernatantVolumes,
		resolvedCryoprotectantSolutions, resolvedCryoprotectantSolutionVolumes, resolvedFreezers, resolvedFreezingRacks,
		resolvedCryogenicSampleContainers, resolvedAliquotVolumes, resolvedCoolants, resolvedSamplesOutStorageConditions,
		conflictingCellTypeWarnings, conflictingCellTypeErrors, cellTypeNotSpecifiedBools, conflictingCultureAdhesionBools,
		overAspirationErrors, invalidRackBools, suggestedRackLists, overFillDestinationErrors, overFillSourceErrors,
		cultureAdhesionNotSpecifiedBools, aliquotVolumeQuantities, containerInVolumesBeforeAliquoting,

		(* Post-MapThread option resolutions *)
		allCentrifugeIndices, noModelContainerIndices, centrifugeIndices, containerModelsAtCentrifugeIndices, possibleCentrifuges,
		possibleCentrifugesWithoutSpeed, specifiedCentrifugesForChangeMedia, incompatibleCentrifugeIndices, noCompatibleCentrifugeIndices,
		centrifugesRankedByPreference, updatedCentrifugeForOptions, preResolvedCellPelletCentrifuges, resolvedCellPelletCentrifuges,
		resolvedCellPelletCentrifugeModels, template, fastTrack, operator, outputOption, email, resolvedOptions, resolvedMapThreadOptions,
		talliedSampleWithVolume, uniqueSampleToUsedVolLookup,

		(* Conflicting Options Checks II *)
		replicatesQ, replicateLabelWarningString, replicatesWithoutAliquotCases, replicatesWithoutAliquotTest, cellTypeNotSpecifiedTests,
		conflictingCellTypeErrorOptions, conflictingCellTypeTest, conflictingCultureAdhesionCases, conflictingCultureAdhesionTest,
		cultureAdhesionNotSpecifiedTests, sampleCultureAdhesions, invalidCultureAdhesionSamples, unsupportedCellCultureTypeCases,
		invalidCultureAdhesionTest, unusedSampleCases, unusedSampleTests, conflictingAliquotOptionsCases, conflictingAliquotOptionsTest,
		aliquotVolumeReplicatesMismatchCases, aliquotVolumeReplicatesMismatchTest, overaspirationTest, cryoprotectantSolutionOverfillCases,
		cryoprotectantSolutionOverfillTest, excessiveCryogenicSampleVolumeCases, excessiveCryogenicSampleVolumeOptions,
		excessiveCryogenicSampleVolumeTest, unsuitableCryogenicSampleContainerErrors, unsuitableCryogenicSampleContainerCases,
		unsuitableCryogenicSampleContainerTest, unsuitableFreezingRackCases, unsuitableFreezingRackTest, resolvedFreezerModels,
		unsupportedFreezerCases, unsupportedFreezerTests, conflictingHardwareCases, conflictingHardwareTests,
		conflictingCoolantCases, conflictingCoolantTests, conflictingTemperatureProfileCases, conflictingTemperatureProfileTests,
		conflictingInsulatedCoolerFreezingTimeCases, conflictingInsulatedCoolerFreezingTimeTests, unsupportedTemperatureProfileCases,
		unsupportedTemperatureProfileTest, conflictingCellFreezingOptions, conflictingCellFreezingTests, noCompatibleCentrifugeCases,
		noCompatibleCentrifugeTest, incompatibleCentrifugeCases, incompatibleCentrifugeTest, groupedSamplesContainersAndOptions,
		inconsistentOptionsPerContainer, samplesWithSameContainerConflictingOptions, samplesWithSameContainerConflictingErrors,
		conflictingPelletOptionsForSameContainerOptions, conflictingPelletOptionsForSameContainerTests,
		tooManyControlledRateFreezerBatches, tooManyControlledRateFreezerBatchesTest, tooManyInsulatedCoolerBatches,
		tooManyInsulatedCoolerBatchesTest,

		(* Wrap up *)
		invalidInputs, invalidOptions, allTests
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Determine if we are in Engine or not, in Engine we silence warnings*)
	notInEngine = !MatchQ[$ECLApplication, Engine];

	(* Fetch our cache from the parent function, and convert it to a fastAssoc for quick lookups *)
	cacheBall = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Pull out packets from the fast association *)
	(* Replacing Null with <||> so packets we fetch are immune to Lookup::invrl error *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	sampleModelPackets = Replace[fastAssocPacketLookup[fastAssoc, #, Model]& /@ mySamples, NullP -> <||>, {1}];
	sampleContainerPackets = Replace[fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples, NullP -> <||>, {1}];
	sampleContainerModelPackets = Replace[(fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ mySamples)/.$Failed -> Null, NullP -> <||>, {1}];
	(* Extract volume from samplePackets and set the volume of a sample to 0 Microliters if it is not informed. This will allow us to error out in a predictable way instead of breaking everything. *)
	sampleVolumeQuantities = Map[
		Function[{samplePacket},
			Which[
				MatchQ[Lookup[samplePacket, Volume], GreaterP[1 Milliliter]],
					SafeRound[Convert[Lookup[samplePacket, Volume], Milliliter], 1 Microliter],
				MatchQ[Lookup[samplePacket, Volume], VolumeP],
					SafeRound[Convert[Lookup[samplePacket, Volume], Microliter], 1 Microliter],
				True,
					0 Microliter
			]
		],
		samplePackets
	];
	(* Pull out the MaxVolume of Sample input Container *)
	(* Set the volume to 1ml if it is not informed. This will allow us to error out in a predictable way instead of breaking everything. *)
	inputContainerMaxVolumes = MapThread[
		Function[{sampleVolumeQuantity, containerModelPacket},
			If[!MatchQ[containerModelPacket, PacketP[Model[Container]]],
				Max[sampleVolumeQuantity, 1 Milliliter],
				Lookup[containerModelPacket, MaxVolume] /. Null -> 0 Microliter
			]
		],
		{sampleVolumeQuantities, sampleContainerModelPackets}
	];

	(* Build all packets which can be safely matched on the Type. *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
	staticFreezerModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, Freezer]]];
	controlledRateFreezerPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Object[Instrument, ControlledRateFreezer]]];
	controlledRateFreezerModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, ControlledRateFreezer]]];
	centrifugeModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, Centrifuge]]];
	freezingRackModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Container, Rack]]];
	allPossibleFreezingRacks = Lookup[Cases[freezingRackModelPackets, KeyValuePattern[{Footprint -> ControlledRateFreezerRack|MrFrostyRack}]], Object];

	(* A local helper to check container model packet why it cannot be CryogenicSampleContainer. If a container can be cryogenic vial, return <||> *)
	whyCantThisModelBeCryogenicVial[
		containerModelPacket: Null|<||>|PacketP[Model[Container]]
	] := Module[
		{noModelQ, minContainerTemperature, containerCoverTypes, containerFootprint, containerMaterials},
		(* Check if the model packet is valid *)
		noModelQ = !MatchQ[containerModelPacket, PacketP[Model[Container]]];
		{minContainerTemperature, containerCoverTypes, containerFootprint, containerMaterials} = If[TrueQ[noModelQ],
			{Null, Null, Null, Null},
			Lookup[containerModelPacket, {MinTemperature, CoverTypes, Footprint, ContainerMaterials}, Null]
		];
		(* To be used as cryogenic vial, the containers have to 1)MinTemperature<-170C 2)use screw cap 3)Footprint is CEVial 4)ContainerMaterial is not glass *)
		<|
			If[TrueQ[noModelQ],
				Model -> Null,
				Nothing
			],
			(* the container must endure at least -170C to be able to used as cryogenic vial *)
			If[NullQ[minContainerTemperature] || GreaterQ[minContainerTemperature, -170 Celsius],
				MinTemperature -> minContainerTemperature,
				Nothing
			],
			(* No Snap cap or seal is allowed in cryogenic storage to avoid leakage *)
			If[MatchQ[containerCoverTypes, Null|{}] || !MemberQ[containerCoverTypes, Screw],
				CoverTypes -> joinClauses[containerCoverTypes],
				Nothing
			],
			(* FreezingRacks have CEVial positions only *)
			If[MatchQ[containerFootprint, Except[CEVial]],
				Footprint -> containerFootprint,
				Nothing
			],
			(* Broken glass is a safety hazard in cryogenic storage, forbid using glass containers *)
			If[MatchQ[containerMaterials, Null|{}] || MemberQ[containerMaterials, Glass],
				ContainerMaterials -> containerMaterials/.{___,Glass,___}->Glass,
				Nothing
			]
		|>
	];

	expandedSuppliedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFreezeCells, KeyDrop[myOptions, {Simulation, Cache}]];
	(* Pull out some supplied option values to help determining index-matching master switches *)
	{
		expandedSuppliedAliquot,
		expandedSuppliedAliquotVolumes,
		expandedSuppliedCryogenicSampleContainers,
		expandedSuppliedCryoprotectantSolutions,
		expandedSuppliedCryoprotectantSolutionVolumes,
		expandedSuppliedCryoprotectionStrategies,
		expandedSuppliedCentrifuges,
		expandedSuppliedPelletTimes,
		expandedSuppliedCentrifugeIntensities,
		expandedSuppliedSupernatantVolumes,
		userSpecifiedLabels
	} = Transpose@Map[
		Lookup[
			#,
			{
				Aliquot,
				AliquotVolume,
				CryogenicSampleContainer,
				CryoprotectantSolution,
				CryoprotectantSolutionVolume,
				CryoprotectionStrategy,
				CellPelletCentrifuge,
				CellPelletTime,
				CellPelletIntensity,
				CellPelletSupernatantVolume,
				CryogenicSampleContainerLabel
			}
		]&,
		expandedSuppliedOptions
	];

	(* Resolve the NumberOfReplicates which has default value *)
	resolvedNumberOfReplicates = Lookup[myOptions, NumberOfReplicates, Null];
	(* Also set the numericNumberOfReplicates, which we'll need later. *)
	numericNumberOfReplicates = resolvedNumberOfReplicates /. Null -> 1;

	(* Pre-resolve master switch options CryoprotectionStrategy, InSitu and FreezingStrategy. *)
	resolvedCryoprotectionStrategies = MapThread[
		Function[
			{
				(*1*)cryoprotectionStrategy,
				(*2*)centrifuge,
				(*3*)cellPelletTime,
				(*4*)centrifugeIntensity,
				(*5*)supernatantVolume,
				(*6*)cryoprotectantSolution,
				(*7*)cryoprotectantSolutionVolume,
				(*8*)sampleContainerPacket
			},
			Which[
				(* If the user specified the option at this index, use the specified value. *)
				MatchQ[cryoprotectionStrategy, Except[Automatic]],
					cryoprotectionStrategy,
				(* If any of the MediaChanging options are specified, set this to ChangeMedia. *)
				MemberQ[{centrifuge, cellPelletTime, centrifugeIntensity, supernatantVolume}, Except[Automatic | Null]],
					ChangeMedia,
				(* If any of the Cryoprotection options are specified as Null, set this to None. *)
				Or[
					NullQ[Lookup[myOptions, CryoprotectantSolutionTemperature, Automatic]],
					NullQ[cryoprotectantSolution],
					NullQ[cryoprotectantSolutionVolume]
				],
					None,
				(* If the sample is in a plate and other samples in the plate have ChangeMedia specified *)
				MatchQ[sampleContainerPacket, ObjectP[]] && Length[Cases[sampleContainerPackets, ObjectP[Lookup[sampleContainerPacket, Object]]]] > 1,
					Module[{positionOfSameContainer},
						positionOfSameContainer = Position[sampleContainerPackets, PacketP[Lookup[sampleContainerPacket, Object]]];
						If[!MemberQ[{centrifuge, cellPelletTime, centrifugeIntensity, supernatantVolume}, Null] &&
						Or[
							MemberQ[Extract[expandedSuppliedCentrifuges, positionOfSameContainer],  Except[Automatic | Null]],
							MemberQ[Extract[expandedSuppliedPelletTimes, positionOfSameContainer], Except[Automatic | Null]],
							MemberQ[Extract[expandedSuppliedCentrifugeIntensities, positionOfSameContainer], Except[Automatic | Null]],
							MemberQ[Extract[expandedSuppliedSupernatantVolumes, positionOfSameContainer], Except[Automatic | Null]]
						],
							ChangeMedia,
							AddCryoprotectant
						]
					],
				(* Otherwise, default to AddCryoprotectant. *)
				True,
					AddCryoprotectant
			]
		],
		{
			(*1*)expandedSuppliedCryoprotectionStrategies,
			(*2*)expandedSuppliedCentrifuges,
			(*3*)expandedSuppliedPelletTimes,
			(*4*)expandedSuppliedCentrifugeIntensities,
			(*5*)expandedSuppliedSupernatantVolumes,
			(*6*)expandedSuppliedCryoprotectantSolutions,
			(*7*)expandedSuppliedCryoprotectantSolutionVolumes,
			(*8*)sampleContainerPackets
		}
	];

	(* PreResolve the InSitu boolean since we will use it in INPUT VALIDATION CHECKS. *)
	(* Check if Aliquot, AliquotVolume, NumberOfReplicates, or CryogenicSampleContainer is specified *)
	specifiedAliquotQs = MapThread[
		Function[
			{
				(*1*)sampleContainerPacket,
				(*2*)sampleContainerModelPacket,
				(*3*)suppliedAliquot,
				(*4*)suppliedAliquotVolume,
				(*5*)suppliedCryogenicSampleContainer,
				(*6*)sample
			},
			Which[
				(* If the user specified the Aliquot option, use it. *)
				MatchQ[suppliedAliquot, BooleanP],
					suppliedAliquot,
				(* If the user specified the Aliquot options at this index as True, set this to True. *)
				MatchQ[suppliedAliquotVolume, Except[Automatic | Null]],
					True,
				(* If NumberOfReplicates is specified, set this to True. *)
				MatchQ[Lookup[myOptions, NumberOfReplicates], _Integer],
					True,
				(* If either the specified CryogenicSampleContainer is not the sample's input container, set this to True. *)
				And[
					MatchQ[suppliedCryogenicSampleContainer, Except[Automatic]],
					Or[
						!MatchQ[sampleContainerModelPacket, PacketP[Model[Container]]] && !MatchQ[suppliedCryogenicSampleContainer, ObjectP[Lookup[sampleContainerPacket, Object]]],
						MatchQ[sampleContainerModelPacket, PacketP[Model[Container]]] && !MatchQ[suppliedCryogenicSampleContainer, ObjectP[{Lookup[sampleContainerPacket, Object], Lookup[sampleContainerModelPacket, Object]}]]
					]
				],
					True,
				(* If the same input sample is specified multiple times in the input and other instance has Aliquot (AliquotVolume/CryogenicSampleContainer) specified, use the same Aliquot *)
				Length[Cases[mySamples, ObjectP[sample]]] > 1,
					Module[{positionOfSample},
						positionOfSample = Position[mySamples, ObjectP[sample]];
						Which[
							MemberQ[Extract[expandedSuppliedAliquot, positionOfSample], BooleanP] && SameQ @@ Cases[Extract[expandedSuppliedAliquot, positionOfSample], BooleanP],
								FirstCase[Extract[expandedSuppliedAliquot, positionOfSample], BooleanP],
							MemberQ[Extract[expandedSuppliedAliquotVolumes, positionOfSample], Except[Automatic | Null]],
								True,
							!MatchQ[sampleContainerModelPacket, PacketP[Model[Container]]] && MemberQ[Extract[expandedSuppliedCryogenicSampleContainers, positionOfSample], Except[Automatic]] && MatchQ[Cases[Extract[expandedSuppliedCryogenicSampleContainers, positionOfSample], Except[Automatic]], {Except[ObjectP[Lookup[sampleContainerPacket, Object]]]..}],
								True,
							MatchQ[sampleContainerModelPacket, PacketP[Model[Container]]] && MemberQ[Extract[expandedSuppliedCryogenicSampleContainers, positionOfSample], Except[Automatic]] && MatchQ[Cases[Extract[expandedSuppliedCryogenicSampleContainers, positionOfSample], Except[Automatic]], {Except[ObjectP[{Lookup[sampleContainerPacket, Object], Lookup[sampleContainerModelPacket, Object]}]]..}],
								True,
							True,
								Automatic
						]
					],
				(* Otherwise, we set it as Automatic for now. *)
				True,
					Automatic
			]
		],
		{
			(*1*)sampleContainerPackets,
			(*2*)sampleContainerModelPackets,
			(*3*)expandedSuppliedAliquot,
			(*4*)expandedSuppliedAliquotVolumes,
			(*5*)expandedSuppliedCryogenicSampleContainers,
			(*6*)mySamples
		}
	];

	{semiresolvedInSitus, finalInSituVolumes} = Transpose@MapThread[
		Function[
			{
				(*1*)sampleVolumeQuantity,
				(*2*)sampleContainerModelPacket,
				(*3*)specifiedAliquotQ,
				(*4*)suppliedCryoprotectantSolutionVolume,
				(*5*)suppliedSupernatantVolume,
				(*6*)suppliedCryoprotionStrategy,
				(*7*)inputContainerMaxVolume
			},
			Which[
				(* If the user specified the Aliquot related options at this index as True, set this to False. *)
				MatchQ[specifiedAliquotQ, BooleanP],
					{!specifiedAliquotQ, Null},
				(* or the input container does not any model info or is not a valid cryogenic container, set this to False *)
				!MatchQ[whyCantThisModelBeCryogenicVial[sampleContainerModelPacket], <||>],
					{False, Null},
				(* If CryoprotectionStrategy is ChangeMedia, and the specified CryoprotectantSolutionVolume with remaining sample after aspiration is exceeding 75% of the sample's input container, set this to False *)
				(* Here we assume the SampleVolume is informed, since FreezeCellsUnsupportedCultureAdhesion will catch the case where input sample is solid media *)
				And[
					MatchQ[suppliedCryoprotionStrategy, ChangeMedia],
					Or[
						(* If CryoprotectantSolutionVolume is not specified, precalculate with the sample volume *)
						!MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP] && GreaterQ[sampleVolumeQuantity, 0.75*inputContainerMaxVolume],
						(* If SupernatantVolume is All or Automatic, assume all existing media is aspirated *)
						MatchQ[suppliedCryoprotectantSolutionVolume, Except[Automatic|Null]] && !MatchQ[suppliedSupernatantVolume, VolumeP] && GreaterQ[suppliedCryoprotectantSolutionVolume, 0.75*inputContainerMaxVolume],
						(* Precalucalte the resuspended sample volume with CryoprotectantSolutionVolume, SupernatantVolume and SampleVolume *)
						MatchQ[suppliedCryoprotectantSolutionVolume, Except[Automatic|Null]] && MatchQ[suppliedSupernatantVolume, VolumeP] && GreaterQ[sampleVolumeQuantity - suppliedSupernatantVolume + suppliedCryoprotectantSolutionVolume, 0.75*inputContainerMaxVolume]
					]
				],
					{
						False,
						Which[
							(* If CryoprotectantSolutionVolume is not specified, precalculate with the sample volume *)
							!MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP],
								sampleVolumeQuantity,
							(* If SupernatantVolume is All or Automatic, assume all existing media is aspirated *)
							MatchQ[suppliedCryoprotectantSolutionVolume, Except[Automatic|Null]] && !MatchQ[suppliedSupernatantVolume, VolumeP],
								SafeRound[suppliedCryoprotectantSolutionVolume, 1 Microliter],
							(* Precalculate the resuspended sample volume with CryoprotectantSolutionVolume, SupernatantVolume and SampleVolume *)
							True,
								SafeRound[sampleVolumeQuantity - suppliedSupernatantVolume + suppliedCryoprotectantSolutionVolume, 1 Microliter]
						]
					},
				(* If CryoprotectionStrategy is AddCryoprotectant, the specified CryoprotectantSolutionVolume plus original sample volume is exceeding 75% of the sample's input container, set this to False *)
				(* Here we assume the SampleVolume is informed, since FreezeCellsUnsupportedCultureAdhesion will catch the case where input sample is solid media *)
				And[
					MatchQ[suppliedCryoprotionStrategy, AddCryoprotectant],
					Or[
						(* If CryoprotectantSolutionVolume is not specified, precalculate as 50% of with the sample volume *)
						!MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP] && GreaterQ[1.5*sampleVolumeQuantity, 0.75*inputContainerMaxVolume],
						(* Precalculate the cell sample with cryoprotectant added total volume with CryoprotectantSolutionVolume and SampleVolume *)
						MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP] && GreaterQ[sampleVolumeQuantity + suppliedCryoprotectantSolutionVolume, 0.75*inputContainerMaxVolume]
					]
				],
					{
						False,
						If[!MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP],
							SafeRound[1.5*sampleVolumeQuantity, 1 Microliter],
							SafeRound[sampleVolumeQuantity + suppliedCryoprotectantSolutionVolume, 1 Microliter]
						]
					},
				(* If CryoprotectionStrategy is None, check if original sample volume is exceeding 75% of the sample's input container, set this to False *)
				(* Here we assume the SampleVolume is informed, since FreezeCellsUnsupportedCultureAdhesion will catch the case where input sample is solid media *)
				GreaterQ[sampleVolumeQuantity, 0.75*inputContainerMaxVolume],
					{
						False,
						sampleVolumeQuantity
					},
				(* Otherwise, we can freeze input sample at this index inside of its original container. *)
				True,
					{Automatic, Null}
			]
		],
		{
			(*1*)sampleVolumeQuantities,
			(*2*)sampleContainerModelPackets,
			(*3*)specifiedAliquotQs,
			(*4*)expandedSuppliedCryoprotectantSolutionVolumes,
			(*5*)expandedSuppliedSupernatantVolumes,
			(*6*)resolvedCryoprotectionStrategies,
			(*7*)inputContainerMaxVolumes
		}
	];


	(* Resolve the FreezingStrategy *)
	expandedSuppliedCryogenicSampleContainerPackets = Map[
		Which[
			!MatchQ[#, ObjectP[]],
				<||>,
			MatchQ[#, ObjectP[Model[Container]]],
				fetchPacketFromFastAssoc[#, fastAssoc],
			MatchQ[#, ObjectP[Object[Container]]] && MatchQ[fastAssocLookup[fastAssoc, #, Model], ObjectP[Model[Container]]],
				fastAssocPacketLookup[fastAssoc, #, Model],
			True,
				<||>
		]&,
		expandedSuppliedCryogenicSampleContainers
	];
	resolvedFreezingStrategy = Which[
		(* If the user specified it, use the user-specified value. *)
		MatchQ[Lookup[myOptions, FreezingStrategy], Except[Automatic]],
			Lookup[myOptions, FreezingStrategy],
		(* If the user specified a TemperatureProfile, set this to ControlledRateFreezer. *)
		MatchQ[Lookup[myOptions, TemperatureProfile], Except[Automatic|Null]],
			ControlledRateFreezer,
		(* If the user specified an InsulatedCoolerFreezingTime or any Coolants, set this to InsulatedCooler. *)
		Or[
			MatchQ[Lookup[myOptions, TemperatureProfile], Null],
			MatchQ[Lookup[myOptions, InsulatedCoolerFreezingTime], Except[Automatic|Null]],
			MemberQ[Lookup[myOptions, Coolant], Except[Automatic|Null]]
		],
			InsulatedCooler,
		(* If the user specified a ControlledRateFreezer instrument Object or Model for the Freezer option, set this to ControlledRateFreezer. *)
		MatchQ[Lookup[myOptions, Freezer], ObjectP[{Object[Instrument, ControlledRateFreezer], Model[Instrument, ControlledRateFreezer]}]],
			ControlledRateFreezer,
		(* If the user specified an ultra-low temperature freezer instrument Object or Model for the Freezer option, set this to InsulatedCooler. *)
		MemberQ[Lookup[myOptions, Freezer], ObjectP[{Object[Instrument, Freezer], Model[Instrument, Freezer]}]],
			InsulatedCooler,
		(* If the user specified a FreezingRack with an InsulatedCooler subtype, set this to InsulatedCooler. *)
		MemberQ[Lookup[myOptions, FreezingRack], ObjectP[{Object[Container, Rack, InsulatedCooler], Model[Container, Rack, InsulatedCooler]}]],
			InsulatedCooler,
		(* If the user specified a FreezingRack WITHOUT an InsulatedCooler subtype, set this to ControlledRateFreezer. *)
		And[
			MemberQ[Lookup[myOptions, FreezingRack], ObjectP[{Object[Container, Rack], Model[Container, Rack]}]],
			!MemberQ[Lookup[myOptions, FreezingRack], ObjectP[{Object[Container, Rack, InsulatedCooler], Model[Container, Rack, InsulatedCooler]}]]
		],
			ControlledRateFreezer,
		(* If the user specified Coolant, set this to InsulatedCooler *)
		MemberQ[Lookup[myOptions, Coolant], ObjectP[]],
			InsulatedCooler,
		(* If the user specified a CryogenicSampleContainer model larger than 2 Milliliter, set this to InsulatedCooler. *)
		(* If InSitu is not False and sample Container model is larger than 2 Milliliter, set this to InsulatedCooler. *)
		(* If AliquotVolume or CryoprotectantSolutionVolume(AddCryoprotectant only) is larger than 1.5 Milliliter, set this to InsulatedCooler.*)
		(* This is because we can't fit vials larger than 2 Milliliter tube in the VIA Freeze. And we should only fill 75% of the cryogenic vial's MaxVolume. *)
		Or[
			MemberQ[Lookup[expandedSuppliedCryogenicSampleContainerPackets, MaxVolume], GreaterP[2 Milliliter]],
			MemberQ[PickList[inputContainerMaxVolumes, semiresolvedInSitus, True], GreaterP[2 Milliliter]],
			MemberQ[expandedSuppliedAliquotVolumes, GreaterP[1.5 Milliliter]],
			MemberQ[PickList[expandedSuppliedCryoprotectantSolutionVolumes, Transpose@{semiresolvedInSitus, resolvedCryoprotectionStrategies}, {False, AddCryoprotectant}], GreaterP[1.5 Milliliter]]
		],
			InsulatedCooler,
		(* If the user has not specified a CryogenicSampleContainer but the input sample is already in a CryogenicSampleContainer *)
		(* and the max volume is larger than 2 Milliliter, prefer InsulatedCooler so aliquot can be skipped. *)
		(* ControlledRateFreezer is okay if Aliquot is True for this case *)
		MemberQ[PickList[inputContainerMaxVolumes, semiresolvedInSitus, Automatic], GreaterP[2 Milliliter]],
			InsulatedCooler,
		(* Otherwise, default to ControlledRateFreezer. *)
		True,
			ControlledRateFreezer
	];

	(* Resolve InSitu *)
	resolvedInSitus = MapThread[
		Function[{semiResolvedInSitu, inputContainerMaxVolume},
			Which[
				(* If we have preresolved value, use it. *)
				MatchQ[semiResolvedInSitu, Except[Automatic]],
					semiResolvedInSitu,
				(* If FreezingStrategy is ControlledRateFreezer and input container has MaxVolume>2ml (such as 5mL Cryogenic Vial) *)
				And[
					MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
					MatchQ[inputContainerMaxVolume, GreaterP[2 Milliliter]]
				],
					False,
				True,
					True
			]
		],
		{semiresolvedInSitus, inputContainerMaxVolumes}
	];
	resolvedAliquotBools = (Not/@resolvedInSitus);

	(* Tally the existing samples with preresolved master switches *)
	(* The tally is in the format like:{{{sample1, ChangeMedia}, 3}, {sample2, None}, 2}*)
	talliedSamplesWithStrategies = Tally[Transpose@{mySamples, resolvedCryoprotectionStrategies}];
	(* Generate a lookup for each unique input sample, example <|sample1 -> 2, sample3 -> 1 |> *)
	uniqueSampleToFinalCellStockNumsLookup = Association@Map[
		# -> numericNumberOfReplicates*Total[Cases[talliedSamplesWithStrategies, {{ObjectP[#], _}, count_}:>count]]&,
		DeleteDuplicates@mySamples
	];

	(* Fill in any non-specified labels with new ones. *)
	preResolvedLabels = Map[
		(* Pre-resolve CryogenicSampleContainerLabel; we'll expand this for NumberOfReplicates afterwards. *)
		If[MatchQ[#, Except[Null|Automatic]],
			#,
			(* Otherwise, make a new label for this sample *)
			CreateUniqueLabel["freeze cells cryogenic sample container", Simulation -> simulation, UserSpecifiedLabels -> Cases[Flatten@userSpecifiedLabels, _String]]
		]&,
		userSpecifiedLabels
	];

	(* Resolve the CryogenicSampleContainerLabels. *)
	(* Expand the labels according to the number of replicates unless we aren't using replicates or if we *)
	(* are given already-expanded labels, i.e. if a FreezeCells unit operation is passed into ExperimentMCP. *)
	resolvedCryogenicSampleContainerLabels = If[
		Or[
			MatchQ[numericNumberOfReplicates, 1],
			And[
				MatchQ[preResolvedLabels, {_String..}],
				AllTrue[preResolvedLabels, StringContainsQ[#, "replicate "]&],
				AnyTrue[preResolvedLabels, StringContainsQ[#, "replicate 2"]&]
			]
		],
		preResolvedLabels,
		(* The following converts "this sample label" to "this sample label replicate 1", "this sample label replicate 2", "this sample label replicate 3"... *)
		Module[
			{expandedCryogenicSampleContainerLabels},

			(* Expand the sample out labels according to the number of replicates *)
			expandedCryogenicSampleContainerLabels = Flatten[Map[
				ConstantArray[#, numericNumberOfReplicates]&,
				preResolvedLabels
			]];

			MapThread[
				Function[{sampleLabel, replicateNumber},
					If[MatchQ[sampleLabel, Null],
						(* If the label is Null, just keep it *)
						sampleLabel,
						(* Otherwise, designate it as a replicate *)
						(sampleLabel <> " replicate " <> ToString[replicateNumber])
					]
				],
				{expandedCryogenicSampleContainerLabels, Flatten[ConstantArray[Range[numericNumberOfReplicates], Length[preResolvedLabels]]]}
			]
		]
	];

	frameworkNumberOfReplicates = If[
		And[
			MatchQ[preResolvedLabels, {_String..}],
			AllTrue[preResolvedLabels, StringContainsQ[#, "replicate "]&],
			AnyTrue[preResolvedLabels, StringContainsQ[#, "replicate 2"]&]
		],
		(* If we're running MCP with a FreezeCells unit operation as input, we have auto-expanded labels and we can extract the number from these. *)
		Max@ToExpression[StringSplit[#, "replicate "][[-1]] & /@ preResolvedLabels],
		Null
	];
	correctNumberOfReplicates = If[NullQ[frameworkNumberOfReplicates],
		numericNumberOfReplicates,
		frameworkNumberOfReplicates
	];

	(*-- INPUT VALIDATION CHECKS --*)
	(* 1. Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Module[{reasonClause, actionClause},
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[discardedInvalidInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],
				" ",
				hasOrHave[DeleteDuplicates@discardedInvalidInputs],
				" a Status of Discarded and cannot be used for this experiment."
			];
			actionClause = StringJoin[
				"Please provide ",
				If[Length[discardedInvalidInputs] > 1,
					"alternative non-discarded samples to use.",
					"an alternative non-discarded sample to use."
				]
			];
			Message[Error::DiscardedSample,
				reasonClause,
				actionClause
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall, Simulation -> simulation] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, discardedInvalidInputs], Cache -> cacheBall, Simulation -> simulation] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 2. Get whether the samples have deprecated models. *)
	deprecatedSampleModelPackets = Cases[sampleModelPackets, KeyValuePattern[Deprecated -> True]];
	deprecatedSampleModelInputs = Lookup[deprecatedSampleModelPackets, Object, {}];
	deprecatedSampleInputs = Lookup[
		PickList[samplePackets, sampleModelPackets, KeyValuePattern[Deprecated -> True]],
		Object,
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[deprecatedSampleModelInputs] > 0 && messages,
		Module[{uniqueDeprecatedModels, reasonClause, actionClause},
			uniqueDeprecatedModels = DeleteDuplicates[deprecatedSampleModelInputs];
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[deprecatedSampleInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],
				" ",
				hasOrHave[DeleteDuplicates@deprecatedSampleInputs],
				If[Length[deprecatedSampleInputs] > 1,
					" deprecated models,",
					" a deprecated model,"
				],
				" and cannot be used for this experiment."
			];
			actionClause = StringJoin[
				"Please check the Deprecated field of ",
				If[Length[deprecatedSampleModelInputs] > 1,
					"the sample models and use alternative samples with non-deprecated models.",
					"the sample model and use an alternative sample with a non-deprecated model."
				]
			];
			Message[Error::DeprecatedModel,
				reasonClause,
				actionClause
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedSampleInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[deprecatedSampleInputs, Cache -> cacheBall, Simulation -> simulation] <> " have models that are not Deprecated:", True, False]
			];

			passingTest = If[Length[deprecatedSampleInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, deprecatedSampleInputs], Cache -> cacheBall, Simulation -> simulation] <> " have models that are not Deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 3. Get whether the input cell types are supported *)

	(* first get the main cell object in the composition; if this is a mixture it will pick the one with the highest concentration *)
	mainCellIdentityModels = selectMainCellFromSample[mySamples, Cache -> cacheBall, Simulation -> simulation];

	(* Determine what kind of cells the input samples are *)
	sampleCellTypes = lookUpCellTypes[samplePackets, sampleModelPackets, mainCellIdentityModels, Cache -> cacheBall];

	(* Note here that Null is acceptable because we're going to assume it's Bacterial later *)
	validCellTypeQs = MatchQ[#, Mammalian|Yeast|Bacterial|Null]& /@ sampleCellTypes;
	invalidCellTypeSamples = Lookup[PickList[samplePackets, validCellTypeQs, False], Object, {}];
	invalidCellTypeCellTypes = PickList[sampleCellTypes, validCellTypeQs, False];

	If[Length[invalidCellTypeSamples] > 0 && messages,
		Message[
			Error::UnsupportedCellTypes,
			(*1*)"ExperimentFreezeCells only supports cryopreservation of mammalian, bacterial and yeast cells",
			(*2*)StringJoin[
			Capitalize@samplesForMessages[invalidCellTypeSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],(* Potentially collapse to the sample or all samples instead of ID here *)
				" ",
				hasOrHave[DeleteDuplicates@invalidCellTypeSamples],
				" CellType detected as ",
				joinClauses@invalidCellTypeCellTypes,
				" from the CellType field of the ",
				pluralize[invalidCellTypeSamples, "object", "objects"]
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidCellTypeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidCellTypeSamples] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[invalidCellTypeSamples, Cache -> cacheBall, Simulation -> simulation] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, False]
			];

			passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidCellTypeSamples], Cache -> cacheBall, Simulation -> simulation] <> " are of supported cell types (Bacterial, Mammalian, or Yeast):", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 4. Throw an error if we have duplicated samples provided for some cases, but allow it if the original samples are aliquoted before further treatment (i.g. pelleting, freezing). *)
	(* and at least one option if different from each other. We allow reusing the same samples for several cases: *)
	(* Case1: NumberOfReplicates(either from experiment or from framework) is set to a number. In this case, all options are the same *)
	(* Case2: the same sample go through different option sets. In this case, ChangeMedia can not be specified as CryoprotectionStrategy. *)
	(* Case3: Any combination of case1 and case2 *)
	talliedSamplesWithNonChangeMediaOptions = Tally[
		Transpose@{
			mySamples,
			Thread[Join[{specifiedAliquotQs, resolvedCryoprotectionStrategies, Lookup[expandedSuppliedOptions, {CryogenicSampleContainer, CryoprotectantSolution, CryoprotectantSolutionVolume, AliquotVolume}]}]]
		}
	];
	duplicateSamplesCases = Map[
		Function[{uniqueSample},
			Which[
				(* If besides ChangeMedia, there is another strategy, this is not possible for FreezeCells experiment since ChangeMedia pellet all the sample before aliquotting *)
				And[
					MemberQ[talliedSamplesWithStrategies, {{ObjectP[uniqueSample], ChangeMedia}, _Integer}],
					MemberQ[talliedSamplesWithStrategies,  {{ObjectP[uniqueSample], Except[ChangeMedia]}, _Integer}]
				],
					{uniqueSample, CryoprotectionStrategy},
				(* If the number Of the same sample with the same specified option set is larger than the NumberOfReplicates, this is not possible for FreezeCells experiment *)
				(* We are throwing FreezeCellsReplicatesAliquotRequired later for Aliquot options if it is a mix of True and False, no need to check here *)
				Or[
					GreaterQ[frameworkNumberOfReplicates, 1] && GreaterQ[Max[Cases[talliedSamplesWithNonChangeMediaOptions, {{ObjectP[uniqueSample], {_, Except[ChangeMedia], _}}, _}][[All, 2]]], correctNumberOfReplicates],
					GreaterQ[numericNumberOfReplicates, 1] && GreaterQ[Max[Cases[talliedSamplesWithNonChangeMediaOptions, {{ObjectP[uniqueSample], {_, Except[ChangeMedia], _}}, _}][[All, 2]]], 1],
					EqualQ[correctNumberOfReplicates, 1] && GreaterQ[Max[Cases[talliedSamplesWithNonChangeMediaOptions, {{ObjectP[uniqueSample], {_, Except[ChangeMedia], _}}, _}][[All, 2]]], 1]
				],
					{uniqueSample, NumberOfReplicates},
				(* If there the number Of ChangeMedia is larger than the NumberOfReplicates, this is not possible for FreezeCells experiment *)
				Or[
					GreaterQ[frameworkNumberOfReplicates, 1] && GreaterQ[Total[Cases[talliedSamplesWithStrategies, {{ObjectP[uniqueSample], ChangeMedia}, count_}:>count]], correctNumberOfReplicates],
					GreaterQ[numericNumberOfReplicates, 1] && GreaterQ[Total[Cases[talliedSamplesWithStrategies, {{ObjectP[uniqueSample], ChangeMedia}, count_}:>count]], 1],
					EqualQ[correctNumberOfReplicates, 1] && GreaterQ[Total[Cases[talliedSamplesWithStrategies, {{ObjectP[uniqueSample], ChangeMedia}, count_}:>count]], 1]
				],
					{uniqueSample, ChangeMedia},
				True,
					Nothing
			]
		],
		DeleteDuplicates@mySamples
	];

	duplicatedSampleInputs = duplicateSamplesCases[[All, 1]];

	If[Length[duplicateSamplesCases] > 0 && messages,
		Module[{captureSentence, groupedErrorDetails, reasonClause, actionClause},
			groupedErrorDetails = GroupBy[duplicateSamplesCases, Rest];
			captureSentence = joinClauses[
				{
					If[MemberQ[Flatten@Keys[groupedErrorDetails], ChangeMedia|CryoprotectionStrategy],
						StringJoin[
							"If the option CryoprotectionStrategy is set to ChangeMedia for a sample, the entire sample is pelleted",
							If[GreaterQ[correctNumberOfReplicates, 1],
								" and then aliquoted to ",
								" and then used to prepare "
							],
							IntegerName[correctNumberOfReplicates, "English"],
							If[GreaterQ[correctNumberOfReplicates, 1],
								" (specified with the option NumberOfReplicates) ",
								" (default to one when the option NumberOfReplicates is not specified) "
							],
							If[EqualQ[correctNumberOfReplicates, 1], "frozen cell stock", "identical frozen cell stocks"]
						],
						Nothing
					],
					If[MemberQ[Flatten@Keys[groupedErrorDetails], NumberOfReplicates],
						"The same input sample cannot be specified multiple times with the same CryoprotectionStrategy unless the duplication is created using the NumberOfReplicates option",
						Nothing
					]
				},
				CaseAdjustment -> True
			];
			reasonClause = joinClauses[
				{
					If[MemberQ[Flatten@Keys[groupedErrorDetails], NumberOfReplicates],
						Module[{groupedCases},
							groupedCases = Lookup[groupedErrorDetails, Key[{NumberOfReplicates}]];
								StringJoin[
									(* Do not collapse the samples since it is confusing when the same sample is entered as input multiple times and we are detecting this issue for this message *)
									samplesForMessages[groupedCases[[All, 1]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
									" ",
									hasOrHave[DeleteDuplicates@groupedCases[[All, 1]]],
									Which[
										GreaterQ[numericNumberOfReplicates, 1],
											" both duplicated entries in the input samples as well as NumberOfReplicates specified",
										GreaterQ[frameworkNumberOfReplicates, 1],
											" more number of entries in the input samples than the specified NumberOfReplicates",
										True,
											" duplicated entries in the input samples and NumberOfReplicates is not specified"
									]
								]
						],
						Nothing
					],
					If[MemberQ[Flatten@Keys[groupedErrorDetails], ChangeMedia],
						Module[{groupedCases},
							groupedCases = Lookup[groupedErrorDetails, Key[{ChangeMedia}]];
							StringJoin[
								(* Do not collapse the samples since it is confusing when the same sample is entered as input multiple times and we are detecting this issue for this message *)
								samplesForMessages[groupedCases[[All, 1]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
								" ",
								hasOrHave[DeleteDuplicates@groupedCases[[All, 1]]],
								" the CryoprotectionStrategy option specified as ChangeMedia while duplicated entries are detected in the input samples"
							]
						],
						Nothing
					],
					If[MemberQ[Flatten@Keys[groupedErrorDetails], CryoprotectionStrategy],
						Module[{groupedCases},
							groupedCases = Lookup[groupedErrorDetails, Key[{CryoprotectionStrategy}]];
							StringJoin[
								(* Do not collapse the samples since it is confusing when the same sample is entered as input multiple times and we are detecting this issue for this message *)
								samplesForMessages[groupedCases[[All, 1]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
								" ",
								hasOrHave[DeleteDuplicates@groupedCases[[All, 1]]],
								" multiple CryoprotectionStrategy specified including ChangeMedia"
							]
						],
						Nothing
					]
				},
				CaseAdjustment -> True
			];
			actionClause = joinClauses[
				{
					If[MemberQ[Flatten@Keys[groupedErrorDetails], ChangeMedia | NumberOfReplicates],
						If[EqualQ[correctNumberOfReplicates, 1],
							"use NumberOfReplicates to make identical copies of frozen cell stocks instead of re-specifying the same sample in the input",
							"increase NumberOfReplicates instead of re-specifying the same sample in the input"
						],
						Nothing
					],
					If[MemberQ[Flatten@Keys[groupedErrorDetails], CryoprotectionStrategy],
						"ensure that when multiple CryoprotectionStrategy values are specified for the same input sample, none of them is ChangeMedia",
						Nothing
					]
				}
			];
			Message[
				Error::FreezeCellsDuplicatedSamples,
				captureSentence,
				reasonClause,
				actionClause
			]
		]
	];

	duplicateSamplesTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[duplicateSamplesCases] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[duplicatedSampleInputs, Cache -> cacheBall, Simulation -> simulation] <> " have not been specified more than once if using it all:", True, False]
			];

			passingTest = If[Length[duplicateSamplesCases] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, duplicatedSampleInputs], Cache -> cacheBall, Simulation -> simulation] <> " have not been specified more than once if using it all:", True, True]
			];

			{failingTest, passingTest}
		]
	];

	(* 5. Get whether there are stowaway samples inside the input plates. We're forbidding users from pelleting samples when there are other samples in the plate already *)
	inputContainerContents = Lookup[sampleContainerPackets, Contents, {}];
	stowawaySamples = MapThread[
		Function[{sample, contents},
			Module[{allChangeMediaSamples, contentsObjects},
				allChangeMediaSamples = Cases[talliedSamplesWithStrategies, {{changeMediaSample_, ChangeMedia}, _}:>changeMediaSample];
				contentsObjects = Download[contents[[All, 2]], Object];
				If[MemberQ[allChangeMediaSamples, ObjectP[sample]],
					Select[contentsObjects, Not[MemberQ[mySamples, ObjectP[#]]]&],
					{}
				]
			]
		],
		{mySamples, inputContainerContents}
	];
	uniqueStowawaySamples = DeleteDuplicates@DeleteCases[stowawaySamples, {}];
	invalidPlateSampleInputs = Lookup[
		DeleteDuplicates@PickList[samplePackets, stowawaySamples, Except[{}]],
		Object,
		{}
	];
	invalidPlateSampleContainers = If[!MatchQ[invalidPlateSampleInputs, {}],
		DeleteDuplicates@MapThread[
			If[MemberQ[invalidPlateSampleInputs, ObjectP[#1]],
				Lookup[#2, Object],
				Nothing
			]&,
			{mySamples, sampleContainerPackets}
		],
		{}
	];

	(* Following new format of error message and detects singular/plural and flatten all values *)
	If[Length[invalidPlateSampleInputs] > 0 && messages,
		Module[{reasonClause},
			(* Here we try to not have a super long message by not displaying either sample or container IDs *)
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[invalidPlateSampleInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
				" ",
				pluralize[invalidPlateSampleInputs, "reside"],
				Which[
					Length[invalidPlateSampleContainers] == 1, " in container ",
					Length[invalidPlateSampleContainers] > $MaxNumberOfErrorDetails, " in containers",
					True, " in containers "
				],
				If[Length[invalidPlateSampleContainers] > $MaxNumberOfErrorDetails,
					"",(* if too many containers (currently >3), do not display their ids *)
					(* we have to display all the containers ID since invalid inputs do not display container id *)
					samplesForMessages[invalidPlateSampleContainers, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation]
				],
				Which[
					Length[invalidPlateSampleContainers] == 1 && Length[Flatten@uniqueStowawaySamples] == 1,
						StringJoin[
							" with 1 additional sample ",
							ObjectToString[Flatten[uniqueStowawaySamples][[1]], Cache -> cacheBall, Simulation -> simulation],
							", which is not specified as input sample"
						],
					Length[invalidPlateSampleContainers] == 1,
						StringJoin[
							" with ",
							ToString[Length[Flatten@uniqueStowawaySamples]],
							" additional samples, which are not specified as input samples"
						],
					Length[invalidPlateSampleContainers] > $MaxNumberOfErrorDetails,
						" with additional samples, which are not specified as input samples",
					True,
						StringJoin[
							" with each container holding ",
							joinClauses[Map[Length[#]&, uniqueStowawaySamples], DuplicatesRemoval -> False],
							" additional samples, respectively"
						]
				]
			];
			Message[
				Error::InvalidChangeMediaSamples,
				reasonClause,
				If[Length[invalidPlateSampleInputs] == 1,
					"the input sample into an empty container",
					"the input samples into empty containers"
				],
				If[Length[invalidPlateSampleContainers] == 1 && Length[Flatten@uniqueStowawaySamples] == 1,
					"the additional sample as input sample as well",
					"all of the additional samples as input samples as well"
				]
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidPlateSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidPlateSampleInputs] == 0,
				Nothing,
				Test["The input samples for ChangeMedia" <> ObjectToString[invalidPlateSampleInputs, Cache -> cacheBall, Simulation -> simulation] <> " are in containers that do not have other, not-provided samples in them:", True, False]
			];

			passingTest = If[Length[invalidPlateSampleInputs] == Length[mySamples],
				Nothing,
				Test["The input samples for ChangeMedia" <> ObjectToString[Complement[mySamples, invalidPlateSampleInputs], Cache -> cacheBall, Simulation -> simulation] <> " are in containers that do not have other, not-provided samples in them:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 6. Throw an error is we have non-liquid samples *)
	(* Get the samples that are not liquids, cannot freeze those *)
	sampleStates = Lookup[samplePackets, State];

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs = PickList[mySamples, sampleStates, Except[Liquid]];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs] > 0 && messages,
		Message[
			Error::FreezeCellsNonLiquidSamples,
			(*1*)StringJoin[
				Capitalize@samplesForMessages[nonLiquidSampleInvalidInputs, mySamples, Cache -> cacheBall, Simulation -> simulation],
				" ",
				isOrAre[nonLiquidSampleInvalidInputs]
			],
			(*2*)Which[
				MatchQ[sampleStates, {(Liquid|Solid|Gas)..}],
					"Please provide alternative liquid sample(s)",
				MatchQ[sampleStates, {(Liquid|Null)..}],
					"Please use UploadSampleProperties to define the State field of the sample(s) if it is missing",
				True,
					"Please provide alternative liquid sample(s), or define the State field using UploadSampleProperties if it is missing"
			]
		]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[nonLiquidSampleInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[nonLiquidSampleInvalidInputs, Cache -> cacheBall, Simulation -> simulation] <> " have a Liquid State:", True, False]
			];

			passingTest = If[Length[nonLiquidSampleInvalidInputs] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, nonLiquidSampleInvalidInputs], Cache -> cacheBall, Simulation -> simulation] <> " have a Liquid State:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 7. Throw a warning is we have liquid samples without volume (or low volume) *)
	(* Note:for gaseous or solid samples, no need to throw more error *)
	missingVolumeInvalidCases = MapThread[
		Function[{samplePacket, sampleContainerModelPacket},
			Module[{maxVol, lowLiquidVol},
				maxVol = Lookup[sampleContainerModelPacket, MaxVolume, 1 Milliliter];
				(* 100 Microliter is defined in individualStorageItems in ProcedureFramework for determine empty samples *)
				lowLiquidVol = If[MatchQ[maxVol, VolumeP],
					SafeRound[Min[0.01*maxVol, 100 Microliter], 1 Microliter],
					100 Microliter
				];
				Which[
					MatchQ[Lookup[samplePacket, {State, Volume}], {Liquid, LessP[lowLiquidVol]}],
						{Lookup[samplePacket, Object], Liquid, Low},
					MatchQ[Lookup[samplePacket, {State, Volume}], {Liquid, Null}],
						{Lookup[samplePacket, Object], Liquid, Null},
					True,
						Nothing
				]
			]
		],
		{samplePackets, sampleContainerModelPackets}
	];

	If[Length[missingVolumeInvalidCases] > 0 && messages,
		Module[{groupedErrorDetails, reasonClause, actionClause},
			groupedErrorDetails = GroupBy[missingVolumeInvalidCases, Rest];
			reasonClause = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
				StringJoin[
					Capitalize@samplesForMessages[missingVolumeInvalidCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
					" either have missing or low volume"
				],
				joinClauses[
					Map[
						StringJoin[
							Capitalize@samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" ",
							hasOrHave[DeleteDuplicates@groupedErrorDetails[#]],
							If[MatchQ[groupedErrorDetails[#][[All, 3]], {Low..}],
								" low amount recorded in the field ",
								" missing "
							],
							"Volume",
							If[MatchQ[groupedErrorDetails[#][[All, 3]], {Null..}],
								" information",
								""
							]
						]&,
						Keys[groupedErrorDetails]
					],
					CaseAdjustment -> True
				]
			];
			actionClause = If[Length[missingVolumeInvalidCases] > 1,
				"ExperimentFreezeCells will still freeze these samples, but very small volumes freeze and thaw rapidly, increasing the risk of temperature-shock-induced cell damage.",
				"ExperimentFreezeCells will still freeze this sample, but very small volumes freeze and thaw rapidly, increasing the risk of temperature-shock-induced cell damage."
			];
			Message[
				Warning::EmptySamples,
				reasonClause,
				actionClause
			]
		]
	];

	missingVolumeTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[missingVolumeInvalidCases] == 0,
				Nothing,
				Warning["The input samples " <> ObjectToString[missingVolumeInvalidCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation] <> " have valid volume information:", True, False]
			];

			passingTest = If[Length[missingVolumeInvalidCases] == Length[mySamples],
				Nothing,
				Warning["The input samples " <> ObjectToString[Complement[mySamples, missingVolumeInvalidCases[[All, 1]]], Cache -> cacheBall, Simulation -> simulation] <> " have valid volume information:", True, True]
			];

			{failingTest, passingTest}
		]
	];


	(*--- OPTION PRECISION CHECKS ---*)
	(* Round the options that have precision. *)
	{roundedFreezeCellsOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			(* dropping these two keys because they are often huge and make variables unnecessarily take up memory + become unreadable *)
			KeyDrop[Association[myOptions], {Cache, Simulation}],
			{CellPelletIntensity, TemperatureProfile, CellPelletTime, InsulatedCoolerFreezingTime, CellPelletSupernatantVolume, CryoprotectantSolutionVolume, AliquotVolume},
			{{10 RPM, 10 GravitationalAcceleration}, {1 Celsius, 1 Minute}, 1 Minute, 0.1 Hour, 1 Microliter, 1 Microliter, 1 Microliter},
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				(* dropping these two keys because they are often huge and make variables unnecessarily take up memory + become unreadable *)
				KeyDrop[Association[myOptions], {Cache, Simulation}],
				{CellPelletIntensity, TemperatureProfile, CellPelletTime, InsulatedCoolerFreezingTime, CellPelletSupernatantVolume, CryoprotectantSolutionVolume, AliquotVolume},
				{{10 RPM, 10 GravitationalAcceleration}, {1 Celsius, 1 Minute}, 1 Minute, 0.1 Hour, 1 Microliter, 1 Microliter, 1 Microliter}
			],
			Null
		}
	];

	(*--- Resolve non-IndexMatching General options I---*)

	(* For the time being, we're limited to Manual preparation for this experiment, so this will trivially "resolve" to Manual. *)
	resolvedPreparation = Lookup[myOptions, Preparation];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Resolve the InsulatedCoolerFreezingTime *)
	resolvedInsulatedCoolerFreezingTime = Which[
		(* If the user specified it, use the user-specified value. *)
		MatchQ[Lookup[roundedFreezeCellsOptions, InsulatedCoolerFreezingTime], Except[Automatic]],
			Lookup[roundedFreezeCellsOptions, InsulatedCoolerFreezingTime],
		(* If the FreezingStrategy is ControlledRateFreezer, set this to Null. *)
		MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
			Null,
		(* Otherwise, default to 12 Hour. *)
		True,
			12 Hour
	];

	(* Resolve the TemperatureProfile *)
	resolvedTemperatureProfile = Which[
		(* If the user specified it, use the user-specified value. *)
		MatchQ[Lookup[roundedFreezeCellsOptions, TemperatureProfile], Except[Automatic]],
			Lookup[roundedFreezeCellsOptions, TemperatureProfile],
		(* If the FreezingStrategy is InsulatedCooler, set this to Null. *)
		MatchQ[resolvedFreezingStrategy, InsulatedCooler],
			Null,
		(* Default to a linear profile where we go from RT down to -80 Celsius at 1 Celsius/Minute . *)
		True,
			{{-80 Celsius, 105 Minute}}
	];

	(* Resolve the CryoprotectantSolutionTemperature. *)
	resolvedCryoprotectantSolutionTemperature = Which[
		(* If the user specified it, use the user-specified value. *)
		MatchQ[Lookup[roundedFreezeCellsOptions, CryoprotectantSolutionTemperature], Except[Automatic]],
			Lookup[roundedFreezeCellsOptions, CryoprotectantSolutionTemperature],
		(* Set this to Null if the CryoprotectionStrategy is None at all indices. *)
		!MemberQ[resolvedCryoprotectionStrategies, Except[None]],
			Null,
		(* Otherwise, default to Chilled. *)
		True,
			Chilled
	];

	(* Gather the resolved options above together in a list. *)
	resolvedGeneralOptions = ReplaceRule[
		Normal[roundedFreezeCellsOptions, Association],
		{
			Preparation -> resolvedPreparation,
			NumberOfReplicates -> resolvedNumberOfReplicates,
			Aliquot -> resolvedAliquotBools,
			CryoprotectionStrategy -> resolvedCryoprotectionStrategies,
			FreezingStrategy -> resolvedFreezingStrategy,
			InsulatedCoolerFreezingTime -> resolvedInsulatedCoolerFreezingTime,
			TemperatureProfile -> resolvedTemperatureProfile,
			CryoprotectantSolutionTemperature -> resolvedCryoprotectantSolutionTemperature
		}
	];

	(*--- CONFLICTING OPTIONS CHECKS I ---*)
	(* 1.Warning::FreezeCellsAliquotingRequired *)
	(* Throw a warning if Aliquot automatically resolves to True at any index while non related Aliquot options were specified. *)
	(* Note if Aliquot, AliquotVolume, NumberOfReplicates, or CryogenicSampleContainer is specified, *)
	(* we do not throw warning since specifying those options indicates the user knows they are aliquoting *)
	freezeCellsAliquotingRequiredCases = DeleteDuplicates@MapThread[
		Function[{sample, aliquotQ, inSituQ, sampleContainerModelPacket, sampleContainerPacket, sampleVolumeQuantity, inputContainerMaxVolume, cryoprotectionStrategy, finalInSituVolume},
			Which[
				MatchQ[aliquotQ, BooleanP] || TrueQ[inSituQ],
					Nothing,
				MatchQ[aliquotQ, Automatic] && !MatchQ[sampleContainerModelPacket, PacketP[Model[Container]]] && MatchQ[Lookup[sampleContainerPacket, Object], ObjectP[]],
					{Model, sample, Lookup[sampleContainerPacket, Object], Null, finalInSituVolume},
				MatchQ[aliquotQ, Automatic] && !MatchQ[sampleContainerModelPacket, PacketP[Model[Container]]],
					{Container, sample, Null, Null, finalInSituVolume},
				MatchQ[aliquotQ, Automatic] && MatchQ[inSituQ, False] && !MatchQ[whyCantThisModelBeCryogenicVial[sampleContainerModelPacket], <||>],
					{Footprint, sample, Lookup[sampleContainerModelPacket, Object], ToString[Lookup[sampleContainerModelPacket, Footprint]], finalInSituVolume},
				MatchQ[aliquotQ, Automatic] && MatchQ[inSituQ, Automatic] && MatchQ[sampleContainerModelPacket, PacketP[Model[Container, Vessel, "id:o1k9jAG1Nl57"]]] && MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],(*5mL Cryogenic Vial*)
					{FreezingStrategy, sample, Lookup[sampleContainerModelPacket, Object], Null, finalInSituVolume},
				MatchQ[aliquotQ, Automatic] && MatchQ[inSituQ, False] && GreaterQ[sampleVolumeQuantity, 0.75*inputContainerMaxVolume] && !MatchQ[cryoprotectionStrategy, ChangeMedia],
					{Sample, sample, Lookup[sampleContainerModelPacket, Object], ToString[Round[0.75*inputContainerMaxVolume, 0.01 Milliliter]], finalInSituVolume},
				MatchQ[aliquotQ, Automatic] && MatchQ[inSituQ, False],
					{MaxVolume, sample, Lookup[sampleContainerModelPacket, Object], ToString[Round[0.75*inputContainerMaxVolume, 0.01 Milliliter]], finalInSituVolume},
				True,
					Nothing
			]
		],
		{mySamples, specifiedAliquotQs, semiresolvedInSitus, sampleContainerModelPackets, sampleContainerPackets, sampleVolumeQuantities, inputContainerMaxVolumes, resolvedCryoprotectionStrategies, finalInSituVolumes}
	];

	If[Length[freezeCellsAliquotingRequiredCases] > 0 && messages && notInEngine,
		Module[{groupedErrorDetails, captureSentence, reasonClause, actionClause},
			groupedErrorDetails = GroupBy[freezeCellsAliquotingRequiredCases, First];
			captureSentence = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
				"Aliquot is required for the samples to prepare valid frozen cell stock",
				joinClauses[
					{
						If[MemberQ[Keys[groupedErrorDetails], Footprint|Model|Container],
							Module[{suggestedCryoVialList},
								suggestedCryoVialList = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
									{Model[Container, Vessel, "id:vXl9j5qEnnOB"], Model[Container, Vessel, "id:AEqRl9KEBOXp"]},
									{Model[Container, Vessel, "id:vXl9j5qEnnOB"], Model[Container, Vessel, "id:AEqRl9KEBOXp"], Model[Container, Vessel, "id:o1k9jAG1Nl57"]}
								];
								StringJoin[
									"Only cryogenic vials such as ",
									samplesForMessages[suggestedCryoVialList, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
									" are accepted for in situ sample preparation"
								]
							],
							Nothing
						],
						If[MemberQ[Keys[groupedErrorDetails], FreezingStrategy],
							ObjectToString[Model[Container, Vessel, "5mL Cryogenic Vial"]] <> " is not accepted for in situ sample preparation when FreezingStrategy is set to ControlledRateFreezer",
							Nothing
						],
						If[MemberQ[Keys[groupedErrorDetails], MaxVolume|Sample],
							"If prepared in situ, the total volume of the cell stock must be kept below 75% of the containers' maximum capacity to avoid the risk of vial rupture",
							Nothing
						]
					},
					CaseAdjustment -> True
				]
			];
			reasonClause = joinClauses[
				Map[
					Function[{groupedKey},
						Module[{groupedCases},
							groupedCases = Lookup[groupedErrorDetails, Key[groupedKey]];
							StringJoin[
								samplesForMessages[groupedCases[[All, 2]], mySamples, Cache -> cacheBall, Simulation -> simulation],
								" ",
								isOrAre[DeleteDuplicates@groupedCases[[All, 2]]],
								Which[
									MemberQ[Keys[groupedErrorDetails], Container],
										pluralize[DeleteDuplicates@groupedCases[[All, 3]], " not in a container", " not in containers"],
									MemberQ[Keys[groupedErrorDetails], Model],
										pluralize[DeleteDuplicates@groupedCases[[All, 3]], " in a container ", " in containers "],
									True,
										pluralize[DeleteDuplicates@groupedCases[[All, 3]], " in a model container ", " in model containers "]
								],
								If[MemberQ[Keys[groupedErrorDetails], Container],
									"",
									samplesForMessages[DeleteCases[groupedCases[[All, 3]], Null], Cache -> cacheBall, Simulation -> simulation]
								],
								Which[
									MatchQ[groupedKey, Footprint],
										" which " <> pluralize[DeleteDuplicates@groupedCases[[All, 3]], "is not a cryogenic vial", "are not cryogenic vials"],
									MatchQ[groupedKey, Model],
										" without model information",
									MatchQ[groupedKey, FreezingStrategy|Container],
										"",
									True,
										StringJoin[
											" with 75% MaxVolume at ",
											joinClauses[groupedCases[[All, 4]]],
											" and total volume of the ",
											pluralize[DeleteDuplicates@groupedCases[[All, 2]], "cell stock", "cell stocks"],
											" would be ",
											joinClauses[groupedCases[[All, 5]]],
											" if Aliquot is set to False"
										]
								]
							]
						]
					],
					Keys[groupedErrorDetails]
				],
				CaseAdjustment -> True
			];
			actionClause = StringJoin[
				"For ",
				pluralize[DeleteDuplicates@freezeCellsAliquotingRequiredCases[[All, 2]], "this sample", "these samples"],
				", the option Aliquot will default to True automatically",
				Which[
					MemberQ[Keys[groupedErrorDetails], FreezingStrategy],
						". If this is not desired, please change the option FreezingStrategy to InsulatedCooler which allows bigger cryogenic vial(s).",
					MemberQ[Keys[groupedErrorDetails], MaxVolume] && MemberQ[Keys[groupedErrorDetails], Sample],
					". If this is not desired, please either decrease the value for option CryoprotectantSolutionVolume or use ExperimentTransfer to transfer some of the sample(s) out to ensure the final cell stock volume before freezing is kept below 75% of the containers' maximum capacity.",
					MemberQ[Keys[groupedErrorDetails], MaxVolume] && !MemberQ[Keys[groupedErrorDetails], Sample],
						". If this is not desired, please decrease the value for option CryoprotectantSolutionVolume to ensure the final cell stock volume before freezing is kept below 75% of the containers' maximum capacity.",
					MemberQ[Keys[groupedErrorDetails], Sample],
						StringJoin[
							". If this is not desired, please use ExperimentTransfer to transfer part of ",
							pluralize[DeleteDuplicates@freezeCellsAliquotingRequiredCases[[All, 2]], "the sample", "the samples"],
							" out to ensure the final cell stock volume before freezing is kept below 75% of the containers' maximum capacity."
						],
					True,
						"."
				]
			];
		(* Here we use the new recommended error message format where we expand the error message instead of using index *)
		(* The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
		Message[
			Warning::FreezeCellsAliquotingRequired,
			captureSentence,
			reasonClause,
			actionClause
			]
		]
	];

	freezeCellsAliquotingRequiredTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest, failingInputTest},
			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[freezeCellsAliquotingRequiredCases] > 0,
				Warning["The following samples, " <> ObjectToString[freezeCellsAliquotingRequiredCases[[All, 2]], Cache -> cacheBall, Simulation -> simulation] <> " do not specify Aliquot option while Aliquot is required:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[freezeCellsAliquotingRequiredCases] == 0,
				Warning["The following samples, " <> ObjectToString[mySamples, Cache -> cacheBall, Simulation -> simulation] <> " have specified Aliquot option as True when Aliquot is required:", True, True],
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


	(* 2. Error::CryogenicVialAliquotingRequired *)
	(* Throw an error if Aliquot is False while containersIn is not a cryo vial, or not the same as specified CryogenicSampleContainer. *)
	conflictingAliquotingErrors = MapThread[
		Function[{sample, aliquotQ, cryogenicSampleContainer, sampleContainerModelPacket, sampleContainerPacket},
			Which[
				MatchQ[aliquotQ, False] && !MatchQ[sampleContainerModelPacket, PacketP[Model[Container]]],
					{Model, sample, Lookup[sampleContainerPacket, Object, Null], Null},
				MatchQ[aliquotQ, False] && !MatchQ[whyCantThisModelBeCryogenicVial[sampleContainerModelPacket], <||>],
					{Footprint, sample, Lookup[sampleContainerModelPacket, Object], Lookup[sampleContainerModelPacket, Footprint]},
				And[
					MatchQ[aliquotQ, False],
					MatchQ[cryogenicSampleContainer, ObjectP[]],
					!MatchQ[cryogenicSampleContainer, ObjectP[Lookup[Join[{sampleContainerModelPacket, sampleContainerPacket}], Object]]]
				],
					{CryogenicSampleContainer, sample, Lookup[sampleContainerPacket, Object, Null], cryogenicSampleContainer},
				True,
					Null
			]
		],
		{mySamples, specifiedAliquotQs, expandedSuppliedCryogenicSampleContainers, sampleContainerModelPackets, sampleContainerPackets}
	];
	conflictingAliquotingCases = DeleteDuplicates@DeleteCases[conflictingAliquotingErrors, Null];
	conflictingAliquotingOptions = If[Length[conflictingAliquotingCases] > 0,
		{Aliquot, CryogenicSampleContainer},
		{}
	];

	If[Length[conflictingAliquotingCases] > 0 && messages && notInEngine,
		Module[{groupedErrorDetails, captureSentence, reasonClause},
			groupedErrorDetails = GroupBy[conflictingAliquotingCases, First];
			captureSentence = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
				"Aliquot is required for the samples to prepare valid frozen cell stock",
				joinClauses[
					{
						If[MemberQ[Keys[groupedErrorDetails], Footprint|Model],
							Module[{suggestedCryoVialList},
								suggestedCryoVialList = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
									{Model[Container, Vessel, "id:vXl9j5qEnnOB"], Model[Container, Vessel, "id:AEqRl9KEBOXp"]},
									{Model[Container, Vessel, "id:vXl9j5qEnnOB"], Model[Container, Vessel, "id:AEqRl9KEBOXp"], Model[Container, Vessel, "id:o1k9jAG1Nl57"]}
								];
								StringJoin[
									"Only cryogenic vials such as ",
									samplesForMessages[suggestedCryoVialList, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
									" are accepted for in situ sample preparation"
								]
							],
							Nothing
						],
						If[MemberQ[Keys[groupedErrorDetails], CryogenicSampleContainer],
							"Frozen cell stocks should be transferred to the specified CryogenicSampleContainer(s)",
							Nothing
						]
					},
					CaseAdjustment -> True
				]
			];
			reasonClause = joinClauses[
				Map[
					Function[{groupedKey},
						Module[{groupedCases},
							groupedCases = Lookup[groupedErrorDetails, Key[groupedKey]];
							StringJoin[
								samplesForMessages[groupedCases[[All, 2]], mySamples, Cache -> cacheBall, Simulation -> simulation],
								" ",
								isOrAre[DeleteDuplicates@groupedCases[[All, 2]]],
								" in ",
								If[MemberQ[Keys[groupedErrorDetails], Footprint],
									pluralize[DeleteDuplicates@groupedCases[[All, 3]], "a model container ", "model containers "],
									pluralize[DeleteDuplicates@groupedCases[[All, 3]], "a container ", "containers "]
								],
								samplesForMessages[groupedCases[[All, 3]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
								Which[
									MatchQ[groupedKey, Footprint],
										" which " <> pluralize[DeleteDuplicates@groupedCases[[All, 4]], "is not a cryogenic vial", "are not cryogenic vials"],
									MatchQ[groupedKey, Model],
										" without model information",
									True,
										StringJoin[
											" while the option CryogenicSampleContainer is set to ",
											samplesForMessages[groupedCases[[All, 4]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation]
										]
								]
							]
						]
					],
					Keys[groupedErrorDetails]
				],
				CaseAdjustment -> True
			];
			(* Here we use the new recommended error message format where we expand the error message instead of using index *)
			(* The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
			Message[
				Error::CryogenicVialAliquotingRequired,
				captureSentence,
				reasonClause,
				pluralize[DeleteDuplicates@conflictingAliquotingCases[[All, 1]], "this sample", "these samples"]
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingAliquotingTest = If[gatherTests,
		Test["If Aliquot is True, samples are in cryogenic vials, the same container model as CryogenicSampleContainer, if specified:",
			Length[conflictingAliquotingCases] > 0,
			False
		]
	];


	(* 3. ConflictingCryoprotectionOptions error check *)
	(* This has 2 tiers that will eventually throw different messages: *)
	(* 1. If index-matching CryoprotectionStrategy is specified directly by user for a sample, and there is conflict with other options for the same index, suggest alternatives. *)
	(* 2. If index-matching CryoprotectionStrategy is not specified directly by user but there is conflict with specified options or the same input or container at different index, suggest change options *)

	(* Tier1/2 warning *)
	{
		conflictingCryoprotectantSolutionTemperatureCases,
		conflictingCryoprotectantSolutionTemperatureTests,
		insufficientChangeMediaOptions,
		insufficientChangeMediaOptionsTests,
		extraneousChangeMediaOptions,
		extraneousChangeMediaOptionsTests,
		insufficientCryoprotectantOptions,
		insufficientCryoprotectantOptionsTests,
		extraneousCryoprotectantOptions,
		extraneousCryoprotectantOptionsTests,
		conflictingPelletOptionsForSameContainerAcrossSampleOptions,
		conflictingPelletOptionsForSameContainerAcrossSampleTests
	} = If[MemberQ[expandedSuppliedCryoprotectionStrategies, Except[Automatic]],
		(* Tier1 error *)
		Module[
			{
				conflictingCryoprotectantSolutionTemperatureCase, conflictingCryoprotectantSolutionTemperatureTest, insufficientChangeMediaOptionsCase,
				insufficientChangeMediaSamples, insufficientSpecifiedChangeMediaOptions, insufficientChangeMediaOptionsTest,
				extraneousChangeMediaOptionsCase, extraneousChangeMediaSamples, extraneousSpecifiedChangeMediaOptions, extraneousChangeMediaOptionsTest,
				insufficientCryoprotectantOptionsCase, insufficientCryoprotectantSamples, insufficientSpecifiedCryoprotectantOptions,
				insufficientCryoprotectantOptionsTest, extraneousCryoprotectantOptionsCase, extraneousCryoprotectantSamples,
				extraneousSpecifiedCryoprotectantOptions, extraneousCryoprotectantOptionsTest, samplesWithSpecifiedStrategy,
				talliedContainersWithSpecifiedStrategies, containersWithChangeMediaSpecifiedAtOtherIndex, changeMediaContainers,
				conflictingPelletOptionsForSameContainerSamples, conflictingPelletOptionsForSameContainerOption, conflictingPelletOptionsForSameContainerTest
			},

			(* 3a. Warning::ConflictingCryoprotectantSolutionTemperature *)
			(* Throw a warning if CryoprotectantSolutionTemperature is set while CryoprotectionStrategy is specified None at all index *)
			conflictingCryoprotectantSolutionTemperatureCase = If[
				MatchQ[resolvedCryoprotectantSolutionTemperature, (Ambient|Chilled)] && MatchQ[expandedSuppliedCryoprotectionStrategies, {None..}],
				{mySamples, resolvedCryoprotectantSolutionTemperature},
				{}
			];

			If[Length[conflictingCryoprotectantSolutionTemperatureCase] > 0 && messages,
				Message[
					Warning::ConflictingCryoprotectantSolutionTemperature,
					samplesForMessages[conflictingCryoprotectantSolutionTemperatureCase[[1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
					ToString[conflictingCryoprotectantSolutionTemperatureCase[[2]]]
				]
			];

			conflictingCryoprotectantSolutionTemperatureTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = If[MatchQ[conflictingCryoprotectantSolutionTemperatureCase, {}], {}, mySamples];

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Warning["CryoprotectantSolutionTemperature is specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if and only if the CryoprotectionStrategy is not None at all indices:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Warning["CryoprotectantSolutionTemperature is specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if and only if the CryoprotectionStrategy is not None at all indices:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];


			(* 3b. Error::FreezeCellsInsufficientChangeMediaOptions *)
			(* The four pelleting options must not be Null if CryoprotectionStrategy is ChangeMedia. *)
			insufficientChangeMediaOptionsCase = MapThread[
				Function[{sample, cryoprotectionStrategy, cellPelletCentrifuge, cellPelletTime, cellPelletIntensity, cellPelletSupernatantVolume},
					{
						sample,
						{
							If[MatchQ[cryoprotectionStrategy, ChangeMedia] && MatchQ[cellPelletCentrifuge, Null],
								CellPelletCentrifuge,
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, ChangeMedia] && MatchQ[cellPelletTime, Null],
								CellPelletTime,
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, ChangeMedia] && MatchQ[cellPelletIntensity, Null],
								CellPelletIntensity,
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, ChangeMedia] && MatchQ[cellPelletSupernatantVolume, Null],
								CellPelletSupernatantVolume,
								Nothing
							]
						}
					}
				],
				{mySamples, expandedSuppliedCryoprotectionStrategies, expandedSuppliedCentrifuges, expandedSuppliedPelletTimes, expandedSuppliedCentrifugeIntensities, expandedSuppliedSupernatantVolumes}
			];
			insufficientChangeMediaSamples = DeleteCases[insufficientChangeMediaOptionsCase, {ObjectP[], {}}][[All, 1]];
			insufficientSpecifiedChangeMediaOptions = DeleteDuplicates[Flatten@insufficientChangeMediaOptionsCase[[All, 2]]];

			If[!MatchQ[insufficientChangeMediaSamples, {}] && messages,
				Message[
					Error::FreezeCellsInsufficientChangeMediaOptions,
					StringJoin[
						Capitalize@samplesForMessages[insufficientChangeMediaSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
						" ",
						hasOrHave[DeleteDuplicates@insufficientChangeMediaSamples]
					],
					joinClauses@insufficientSpecifiedChangeMediaOptions,
					If[Length[insufficientSpecifiedChangeMediaOptions] > 1,
						"the cell pelleting options or allow them",
						"the option " <> ToString[insufficientSpecifiedChangeMediaOptions[[1]]] <> " or allow it"
					]
				]
			];

			insufficientChangeMediaOptionsTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = insufficientChangeMediaSamples;

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["None of CellPelletCentrifuge, CellPelletTime, CellPelletIntensity, or CellPelletSupernatantVolume are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is ChangeMedia:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["None of CellPelletCentrifuge, CellPelletTime, CellPelletIntensity, or CellPelletSupernatantVolume are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is ChangeMedia:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];


			(* 3c. Error::FreezeCellsExtraneousChangeMediaOptions *)
			(* The four pelleting options must be Null if CryoprotectionStrategy is NOT ChangeMedia. *)
			extraneousChangeMediaOptionsCase = MapThread[
				Function[{sample, cryoprotectionStrategy, cellPelletCentrifuge, cellPelletTime, cellPelletIntensity, cellPelletSupernatantVolume},
					{
						sample,
						{
							If[MatchQ[cryoprotectionStrategy, AddCryoprotectant|None] && MatchQ[cellPelletCentrifuge, Except[Null|Automatic]],
								{cryoprotectionStrategy, CellPelletCentrifuge},
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, AddCryoprotectant|None] && MatchQ[cellPelletTime, Except[Null|Automatic]],
								{cryoprotectionStrategy, CellPelletTime},
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, AddCryoprotectant|None] && MatchQ[cellPelletIntensity, Except[Null|Automatic]],
								{cryoprotectionStrategy, CellPelletIntensity},
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, AddCryoprotectant|None] && MatchQ[cellPelletSupernatantVolume, Except[Null|Automatic]],
								{cryoprotectionStrategy, CellPelletSupernatantVolume},
								Nothing
							]
						}
					}
				],
				{mySamples, expandedSuppliedCryoprotectionStrategies, expandedSuppliedCentrifuges, expandedSuppliedPelletTimes, expandedSuppliedCentrifugeIntensities, expandedSuppliedSupernatantVolumes}
			];
			extraneousChangeMediaSamples = DeleteCases[extraneousChangeMediaOptionsCase, {ObjectP[], {}}][[All, 1]];
			extraneousSpecifiedChangeMediaOptions = DeleteDuplicates[Cases[Flatten@extraneousChangeMediaOptionsCase[[All, 2]], Except[ChangeMedia|AddCryoprotectant|None]]];

			If[!MatchQ[extraneousChangeMediaSamples, {}] && messages,
				Message[
					Error::FreezeCellsExtraneousChangeMediaOptions,
					StringJoin[
						Capitalize@samplesForMessages[extraneousChangeMediaSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
						" ",
						hasOrHave[DeleteDuplicates@extraneousChangeMediaSamples],
						" the option CryoprotectionStrategy set to ",
						joinClauses[Cases[Flatten@extraneousChangeMediaOptionsCase[[All, 2]], ChangeMedia|AddCryoprotectant|None]],
						" and ",
						If[Length[extraneousSpecifiedChangeMediaOptions] > 1,
							"the cell pelleting options " <> joinClauses[extraneousSpecifiedChangeMediaOptions] <> " specified",
							"the option " <> ToString[extraneousSpecifiedChangeMediaOptions[[1]]] <> " specified"
						]
					],
					If[Length[extraneousSpecifiedChangeMediaOptions] > 1,
						"the cell pelleting options as Null or allow them",
						"the option " <> ToString[extraneousSpecifiedChangeMediaOptions[[1]]] <> " as Null or allow it"
					]
				]
			];

			extraneousChangeMediaOptionsTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = extraneousChangeMediaSamples;

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["All of CellPelletCentrifuge, CellPelletTime, CellPelletIntensity, and CellPelletSupernatantVolume are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is not ChangeMedia:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["All of CellPelletCentrifuge, CellPelletTime, CellPelletIntensity, and CellPelletSupernatantVolume are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is not ChangeMedia:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];


			(* 3d. Error::FreezeCellsInsufficientCryoprotectantOptions *)
			(* The three options related to CryoprotectantSolutions must not be Null unless CryoprotectionStrategy is None. *)
			insufficientCryoprotectantOptionsCase = MapThread[
				Function[{sample, cryoprotectionStrategy, cryoprotectantSolution, cryoprotectantSolutionVolume},
					{
						sample,
						{
							If[MatchQ[cryoprotectionStrategy, ChangeMedia|AddCryoprotectant] && MatchQ[cryoprotectantSolution, Null],
								{cryoprotectionStrategy, CryoprotectantSolution},
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, ChangeMedia|AddCryoprotectant] && MatchQ[cryoprotectantSolutionVolume, Null],
								{cryoprotectionStrategy, CryoprotectantSolutionVolume},
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, ChangeMedia|AddCryoprotectant] && MatchQ[resolvedCryoprotectantSolutionTemperature, Null],
								{cryoprotectionStrategy, CryoprotectantSolutionTemperature},
								Nothing
							]
						}
					}
				],
				{mySamples, expandedSuppliedCryoprotectionStrategies, expandedSuppliedCryoprotectantSolutions, expandedSuppliedCryoprotectantSolutionVolumes}
			];
			insufficientCryoprotectantSamples = DeleteCases[insufficientCryoprotectantOptionsCase, {ObjectP[], {}}][[All, 1]];
			insufficientSpecifiedCryoprotectantOptions = DeleteDuplicates[Cases[Flatten@insufficientCryoprotectantOptionsCase[[All, 2]], Except[ChangeMedia|AddCryoprotectant|None]]];


			If[!MatchQ[insufficientCryoprotectantSamples, {}] && messages,
				Message[
					Error::FreezeCellsInsufficientCryoprotectantOptions,
					StringJoin[
						Capitalize@samplesForMessages[insufficientCryoprotectantSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
						" ",
						hasOrHave[DeleteDuplicates@insufficientCryoprotectantSamples],
						" the option CryoprotectionStrategy set to ",
						If[Length[DeleteDuplicates@Cases[Flatten@insufficientCryoprotectantOptionsCase[[All, 2]], ChangeMedia|AddCryoprotectant]] > 1,
							"non-None strategies",
							joinClauses@Cases[Flatten@insufficientCryoprotectantOptionsCase[[All, 2]], ChangeMedia|AddCryoprotectant]
						]
					],
					StringJoin[
						pluralize[insufficientSpecifiedCryoprotectantOptions, "the option ", "the options "],
						joinClauses@insufficientSpecifiedCryoprotectantOptions,
						" ",
						isOrAre[insufficientSpecifiedCryoprotectantOptions]
					],
					If[Length[insufficientSpecifiedCryoprotectantOptions] > 1,
						"the cryoprotection options or allow them",
						"the option " <> ToString[insufficientSpecifiedCryoprotectantOptions[[1]]] <> " or allow it"
					]
				];
			];

			insufficientCryoprotectantOptionsTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = insufficientCryoprotectantSamples;

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["None of CryoprotectantSolution, CryoprotectantSolutionVolume, or CryoprotectantSolutionTemperature are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is not None:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["None of CryoprotectantSolution, CryoprotectantSolutionVolume, or CryoprotectantSolutionTemperature are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is not None:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];


			(* 3e. Error::FreezeCellsExtraneousCryoprotectantOptions *)
			(* The three options related to CryoprotectantSolutions must be Null if CryoprotectionStrategy is None. *)
			extraneousCryoprotectantOptionsCase = MapThread[
				Function[{sample, cryoprotectionStrategy, cryoprotectantSolution, cryoprotectantSolutionVolume},
					{
						sample,
						{
							If[MatchQ[cryoprotectionStrategy, None] && MatchQ[cryoprotectantSolution, Except[Null|Automatic]],
								CryoprotectantSolution,
								Nothing
							],
							If[MatchQ[cryoprotectionStrategy, None] && MatchQ[cryoprotectantSolutionVolume, Except[Null|Automatic]],
								CryoprotectantSolutionVolume,
								Nothing
							]
						}
					}
				],
				{mySamples, expandedSuppliedCryoprotectionStrategies, expandedSuppliedCryoprotectantSolutions, expandedSuppliedCryoprotectantSolutionVolumes}
			];
			extraneousCryoprotectantSamples = DeleteCases[extraneousCryoprotectantOptionsCase, {ObjectP[], {}}][[All, 1]];
			extraneousSpecifiedCryoprotectantOptions = DeleteDuplicates[Flatten@extraneousCryoprotectantOptionsCase[[All, 2]]];

			If[!MatchQ[extraneousCryoprotectantSamples, {}] && messages,
				Message[
					Error::FreezeCellsExtraneousCryoprotectantOptions,
					StringJoin[
						Capitalize@samplesForMessages[extraneousCryoprotectantSamples, mySamples, Cache -> cacheBall, Simulation -> simulation],
						" ",
						hasOrHave[DeleteDuplicates@extraneousCryoprotectantSamples]
					],
					StringJoin[
						pluralize[extraneousSpecifiedCryoprotectantOptions, "the option ", "the options "],
						joinClauses@extraneousSpecifiedCryoprotectantOptions,
						" ",
						isOrAre[extraneousSpecifiedCryoprotectantOptions]
					],
					If[Length[extraneousSpecifiedCryoprotectantOptions] > 1,
						"options",
						"option " <> ToString[extraneousSpecifiedCryoprotectantOptions[[1]]]
					]
				]
			];

			extraneousCryoprotectantOptionsTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = extraneousCryoprotectantSamples;

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["All of CryoprotectantSolution, CryoprotectantSolutionVolume, and CryoprotectantSolutionTemperature are Null for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is None:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["All of CryoprotectantSolution, CryoprotectantSolutionVolume, and CryoprotectantSolutionTemperature are Null for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is None:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];


			(* 3f. Error::ConflictingChangeMediaOptionsForSameContainer *)
			(* Gather the samples that are in the same container together with their options *)
			(* We need to cross reference specified CryoprotectionStrategy for the same container *)
			(* Check which input sample has no specified CryoprotectionStrategy *)
			samplesWithSpecifiedStrategy = MapThread[
				If[MatchQ[#3, Except[Automatic]], {#1, Lookup[#2, Object], #3}, Nothing]&,
				{mySamples, sampleContainerPackets, expandedSuppliedCryoprotectionStrategies}
			];
			talliedContainersWithSpecifiedStrategies = Tally[samplesWithSpecifiedStrategy];
			(* First, check if other instances of the same input container have specified ChangeMedia as strategy *)
			containersWithChangeMediaSpecifiedAtOtherIndex = MapThread[
				(MatchQ[#2, ObjectP[]] && MemberQ[talliedContainersWithSpecifiedStrategies, {{Except[#1], ObjectP[#2], ChangeMedia}, _}])&,
				{samplesWithSpecifiedStrategy[[All, 1]], samplesWithSpecifiedStrategy[[All, 2]]}
			];
			changeMediaContainers = DeleteDuplicates@PickList[samplesWithSpecifiedStrategy[[All, 2]], containersWithChangeMediaSpecifiedAtOtherIndex];
			conflictingPelletOptionsForSameContainerSamples = Map[
				Which[
					MatchQ[#[[3]], ChangeMedia],
						Nothing,
					MemberQ[changeMediaContainers, ObjectP[#[[2]]]] && !MemberQ[duplicatedSampleInputs, ObjectP[#[[2]]]],
						{#[[1]], #[[2]]},
					True,
						Nothing
				]&,
				samplesWithSpecifiedStrategy
			];

			(* Throw an error if we have these same-container samples with different CryoprotectionStrategy specified and one of them is ChangeMedia *)
			(* Here we use the new recommended error message format where we expand the error message instead of using index *)
			(* The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
			conflictingPelletOptionsForSameContainerOption = If[!MatchQ[conflictingPelletOptionsForSameContainerSamples, {}] && messages,
				(
					Message[
						Error::ConflictingChangeMediaOptionsForSameContainer,
						StringJoin[
							Capitalize@samplesForMessages[conflictingPelletOptionsForSameContainerSamples[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
							" ",
							hasOrHave[DeleteDuplicates@conflictingPelletOptionsForSameContainerSamples[[All, 1]]],
							" the option CryoprotectionStrategy set to a non-ChangeMedia strategy while ",
							samplesForMessages[Cases[talliedContainersWithSpecifiedStrategies, {{Except[conflictingPelletOptionsForSameContainerSamples[[All, 1]]], ObjectP[conflictingPelletOptionsForSameContainerSamples[[All, 2]]], ChangeMedia}, _}][[All, 1]][[All,  1]], Cache -> cacheBall, Simulation -> simulation],
							" in the same container specified to ChangeMedia"
						],
						"transfer to separate containers to allow a mix of non-ChangeMedia and ChangeMedia strategy or specify the same CryoprotectionStrategy"
					];
					{CryoprotectionStrategy}
				),
				{}
			];
			conflictingPelletOptionsForSameContainerTest = If[gatherTests,
				(* We're gathering tests. Create the appropriate tests. *)
				Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
					(* Get the inputs that fail this test. *)
					failingInputs = PickList[mySamples, conflictingPelletOptionsForSameContainerSamples];

					(* Get the inputs that pass this test. *)
					passingInputs = Complement[mySamples, failingInputs];

					(* Create a test for the non-passing inputs. *)
					failingInputTest = If[Length[failingInputs]>0,
						Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ",have the same ChangeMedia strategy as all other samples in the same container:", True, False],
						Nothing
					];

					(* Create a test for the passing inputs. *)
					passingInputsTest = If[Length[passingInputs]>0,
						Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ",have the same ChangeMedia strategy as all other samples in the same container:", True, True],
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

			(* Return *)
			{
				conflictingCryoprotectantSolutionTemperatureCase,
				conflictingCryoprotectantSolutionTemperatureTest,
				insufficientSpecifiedChangeMediaOptions,
				insufficientChangeMediaOptionsTest,
				extraneousSpecifiedChangeMediaOptions,
				extraneousChangeMediaOptionsTest,
				insufficientSpecifiedCryoprotectantOptions,
				insufficientCryoprotectantOptionsTest,
				extraneousSpecifiedCryoprotectantOptions,
				extraneousCryoprotectantOptionsTest,
				conflictingPelletOptionsForSameContainerOption,
				conflictingPelletOptionsForSameContainerTest
			}
		],
		ConstantArray[{}, 12]
	];


	{
		conflictingCryoprotectionStrategySamples,
		conflictingCryoprotectionStrategyOptions,
		conflictingCryoprotectionStrategyTests
	} = If[MemberQ[expandedSuppliedCryoprotectionStrategies, Automatic],
		(* Tier2 error *)
		Module[
			{
				whyThisSampleCantPickThisCryoprotectionStrategy, samplesWithoutSpecifiedStrategy, talliedContainersWithSpecifiedStrategies,
				containersWithChangeMediaSpecifiedAtOtherIndex, changeMediaContainers, conflictingCryoprotectionStrategyCase,
				captureSentence, reasonClause, actionClause, conflictingCryoprotectionStrategyOption, conflictingCryoprotectionStrategyTest
			},
			(* Local helper to determine which CryoprotectionStrategy *)
			(* Output an association <|Object->sample, Valid->BooleanP, desiredCryoprotectionStrategy ->{validOptions,change of options}, OtherCryoprotectionStrategies -> {{OtherCryoprotectionStrategy, validOptions,change of options}..}|> *)
			whyThisSampleCantPickThisCryoprotectionStrategy[
				sample: ObjectP[Object[Sample]],
				desiredCryoprotectionStrategy: Alternatives[ChangeMedia, AddCryoprotectant, None],
				userOptionsAssociation_Association
			] := Module[
				{
					userOptions, changeMediaSpecifiedKeys, changeOrAddSpecifiedKeys, userSpecifiedKeys, userSpecifiedChangeMediaKeys,
					invalidChangeMediaKeys, userSpecifiedAddCryoprotectantKeys, invalidAddCryoprotectantKeys, userSpecifiedNoneKeys,
					invalidNoneKeys, validSpecifiedKeys, invalidSpecifiedKeys, otherCryoprotectionStrategies
				},

				(* Specific keys *)
				changeMediaSpecifiedKeys = {CellPelletCentrifuge, CellPelletTime, CellPelletIntensity, CellPelletSupernatantVolume};
				changeOrAddSpecifiedKeys = {CryoprotectantSolutionTemperature, CryoprotectantSolution, CryoprotectantSolutionVolume};

				(* User input keys *)
				userOptions = Normal[userOptionsAssociation, Association];
				userSpecifiedKeys = Keys[Select[userOptions, MatchQ[Values[#], Except[ListableP[Automatic]]] &]];
				userSpecifiedChangeMediaKeys = Map[
					Which[
						MatchQ[#, Alternatives @@ changeMediaSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Except[Null]],
							#,
						MatchQ[#, Alternatives @@ changeOrAddSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Except[Null]],
							#,
						True,
							Nothing
					]&,
					userSpecifiedKeys
				];
				invalidChangeMediaKeys = Map[
					Which[
						MatchQ[#, Alternatives @@ changeMediaSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Null],
							#,
						MatchQ[#, Alternatives @@ changeOrAddSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Null],
							#,
						True,
							Nothing
					]&,
					userSpecifiedKeys
				];
				userSpecifiedAddCryoprotectantKeys = Map[
					Which[
						MatchQ[#, Alternatives @@ changeOrAddSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Except[Null]],
							#,
						MatchQ[#, Alternatives @@ changeMediaSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Null],
							#,
						True,
							Nothing
					]&,
					userSpecifiedKeys
				];
				invalidAddCryoprotectantKeys = Map[
					Which[
						MatchQ[#, Alternatives @@ changeOrAddSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Null],
						#,
						MatchQ[#, Alternatives @@ changeMediaSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Except[Null]],
						#,
						True,
						Nothing
					]&,
					userSpecifiedKeys
				];
				userSpecifiedNoneKeys = Map[
					Which[
						MatchQ[#, Alternatives @@ changeOrAddSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Null],
						#,
						MatchQ[#, Alternatives @@ changeMediaSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Null],
						#,
						True,
						Nothing
					]&,
					userSpecifiedKeys
				];
				invalidNoneKeys = Map[
					Which[
						MatchQ[#, Alternatives @@ changeOrAddSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Except[Null]],
						#,
						MatchQ[#, Alternatives @@ changeMediaSpecifiedKeys] && MatchQ[Lookup[userOptions, #], Except[Null]],
						#,
						True,
						Nothing
					]&,
					userSpecifiedKeys
				];
				validSpecifiedKeys = Which[
					MatchQ[desiredCryoprotectionStrategy, ChangeMedia], userSpecifiedChangeMediaKeys,
					MatchQ[desiredCryoprotectionStrategy, AddCryoprotectant], userSpecifiedAddCryoprotectantKeys,
					True, userSpecifiedNoneKeys
				];
				invalidSpecifiedKeys = Which[
					MatchQ[desiredCryoprotectionStrategy, ChangeMedia], invalidChangeMediaKeys,
					MatchQ[desiredCryoprotectionStrategy, AddCryoprotectant], invalidAddCryoprotectantKeys,
					True, invalidNoneKeys
				];
				(* Check if any of other CryoprotectionStrategies are possible with given options *)
				otherCryoprotectionStrategies = Which[
					MatchQ[desiredCryoprotectionStrategy, ChangeMedia],
						{
							If[!MatchQ[userSpecifiedAddCryoprotectantKeys, {}], {AddCryoprotectant, userSpecifiedAddCryoprotectantKeys, invalidAddCryoprotectantKeys}, Nothing],
							If[!MatchQ[userSpecifiedNoneKeys, {}], {None, userSpecifiedNoneKeys, invalidNoneKeys}, Nothing]
						},
					MatchQ[desiredCryoprotectionStrategy, AddCryoprotectant],
						{
							If[!MatchQ[userSpecifiedChangeMediaKeys, {}], {ChangeMedia, userSpecifiedChangeMediaKeys, invalidChangeMediaKeys}, Nothing],
							If[!MatchQ[userSpecifiedNoneKeys, {}], {None, userSpecifiedNoneKeys, invalidNoneKeys}, Nothing]
						},
					True,
						{
							If[!MatchQ[userSpecifiedChangeMediaKeys, {}], {ChangeMedia, userSpecifiedChangeMediaKeys, invalidChangeMediaKeys}, Nothing],
							If[!MatchQ[userSpecifiedAddCryoprotectantKeys, {}], {AddCryoprotectant, userSpecifiedAddCryoprotectantKeys, invalidAddCryoprotectantKeys}, Nothing]
						}
				];
				(* return *)
				<|
					Object -> sample,
					Valid -> MatchQ[invalidSpecifiedKeys, {}],
					desiredCryoprotectionStrategy -> {validSpecifiedKeys, invalidSpecifiedKeys},
					OtherCryoprotectionStrategies -> SortBy[otherCryoprotectionStrategies, (Length[#[[2]]]+Length[#[[3]]])&]
				|>
			];
			(* We need to cross reference specified/default CryoprotectionStrategy for the same container *)
			(* Check which input sample has no specified CryoprotectionStrategy *)
			samplesWithoutSpecifiedStrategy = MapThread[
				If[MatchQ[#3, Automatic], {#1, Lookup[#2, Object]}, Nothing]&,
				{mySamples, sampleContainerPackets, expandedSuppliedCryoprotectionStrategies}
			];
			talliedContainersWithSpecifiedStrategies = Tally[Transpose@{mySamples, Lookup[sampleContainerPackets, Object, Null], expandedSuppliedCryoprotectionStrategies}];
			(* First, check if other instances of the same input container have specified ChangeMedia as strategy *)
			containersWithChangeMediaSpecifiedAtOtherIndex = MapThread[
				(MatchQ[#2, ObjectP[]] && MemberQ[talliedContainersWithSpecifiedStrategies, {{Except[#1], ObjectP[#2], ChangeMedia}, _}])&,
				{samplesWithoutSpecifiedStrategy[[All, 1]], samplesWithoutSpecifiedStrategy[[All, 2]]}
			];
			changeMediaContainers = DeleteDuplicates@PickList[samplesWithoutSpecifiedStrategy[[All, 2]], containersWithChangeMediaSpecifiedAtOtherIndex];
			conflictingCryoprotectionStrategyCase = MapThread[
				Function[{sample, container, specifiedCryoprotectionStrategy, finalCryoprotectionStrategy, suppliedOptions},
					Which[
						(* If user has specified CryoprotectionStrategy, this sample has gone through tier1 check *)
						MatchQ[specifiedCryoprotectionStrategy, Except[Automatic]],
							Nothing,
						(* If we have thrown FreezeSamplesDuplicatesSamples, no need to throw again here *)
						!MatchQ[finalCryoprotectionStrategy, ChangeMedia] && MemberQ[duplicatedSampleInputs, ObjectP[sample]],
							Nothing,
						!MatchQ[finalCryoprotectionStrategy, ChangeMedia] && MemberQ[changeMediaContainers, ObjectP[container]],
							Module[{conflictCheckForThisSample},
								conflictCheckForThisSample = whyThisSampleCantPickThisCryoprotectionStrategy[sample, ChangeMedia, suppliedOptions];
								{sample, container, Lookup[conflictCheckForThisSample, ChangeMedia][[2]], finalCryoprotectionStrategy, SpecifiedChangeMediaForSameContainer}
							],
						!MatchQ[finalCryoprotectionStrategy, ChangeMedia],
							Module[{samplesForSameContainerAtOtherIndex, conflictCheckForThisSample, secondChoiceOfStrategy},
								samplesForSameContainerAtOtherIndex = If[!MatchQ[Cases[samplesWithoutSpecifiedStrategy, {Except[ObjectP[sample]], ObjectP[container]}], {}],
									{#[[1]]}& /@ Cases[samplesWithoutSpecifiedStrategy, {Except[ObjectP[sample]], ObjectP[container]}],
									{}
								];
								conflictCheckForThisSample = whyThisSampleCantPickThisCryoprotectionStrategy[sample, finalCryoprotectionStrategy, suppliedOptions];
								secondChoiceOfStrategy = If[MatchQ[Lookup[conflictCheckForThisSample, OtherCryoprotectionStrategies], {}],
									Null,
									Last[Lookup[conflictCheckForThisSample, OtherCryoprotectionStrategies]]
								];
								Which[
									MatchQ[samplesForSameContainerAtOtherIndex, {}] && TrueQ[Lookup[conflictCheckForThisSample, Valid]],
										Nothing,
									MatchQ[samplesForSameContainerAtOtherIndex, {}],
										{sample, secondChoiceOfStrategy, Lookup[conflictCheckForThisSample, finalCryoprotectionStrategy], finalCryoprotectionStrategy, OwnOption},
									True,
										Module[{positionOfSameContainer, samplesWithCellPelletOptions, otherSamplesWithCellPelletOptions},
											positionOfSameContainer = Position[sampleContainerPackets, PacketP[container]];
											samplesWithCellPelletOptions = PickList[
												Extract[mySamples, positionOfSameContainer],
												Transpose@{
													Extract[expandedSuppliedCentrifuges, positionOfSameContainer],
													Extract[expandedSuppliedPelletTimes, positionOfSameContainer],
													Extract[expandedSuppliedCentrifugeIntensities, positionOfSameContainer],
													Extract[expandedSuppliedSupernatantVolumes, positionOfSameContainer]
												},
												{___, Except[Automatic | Null], ___}
											];
											otherSamplesWithCellPelletOptions = DeleteCases[samplesWithCellPelletOptions, ObjectP[sample]];
											Which[
												!MatchQ[otherSamplesWithCellPelletOptions, {}],
													{sample, samplesWithCellPelletOptions, Lookup[whyThisSampleCantPickThisCryoprotectionStrategy[sample, ChangeMedia, suppliedOptions], ChangeMedia][[2]], finalCryoprotectionStrategy, DefaultChangeMediaForSameContainer},
												!TrueQ[Lookup[conflictCheckForThisSample, Valid]],
													{sample, secondChoiceOfStrategy, Lookup[conflictCheckForThisSample, finalCryoprotectionStrategy], finalCryoprotectionStrategy, OwnOption},
												True,
													Nothing
											]
										]
								]
							],
						True,
							Module[{conflictCheckForThisSample, secondChoiceOfStrategy},
								conflictCheckForThisSample = whyThisSampleCantPickThisCryoprotectionStrategy[sample, finalCryoprotectionStrategy, suppliedOptions];
								secondChoiceOfStrategy = If[MatchQ[Lookup[conflictCheckForThisSample, OtherCryoprotectionStrategies], {}],
									Null,
									Last[Lookup[conflictCheckForThisSample, OtherCryoprotectionStrategies]]
								];
								If[!TrueQ[Lookup[conflictCheckForThisSample, Valid]],
									{sample, secondChoiceOfStrategy, Lookup[conflictCheckForThisSample, finalCryoprotectionStrategy], finalCryoprotectionStrategy, OwnOption},
									Nothing
								]
							]
					]
				],
				{mySamples, Lookup[sampleContainerPackets, Object, Null], expandedSuppliedCryoprotectionStrategies, resolvedCryoprotectionStrategies, expandedSuppliedOptions}
			];
			captureSentence = If[MatchQ[conflictingCryoprotectionStrategyCase, {}],
				Null,
				Capitalize@joinClauses[
					{
						If[MemberQ[conflictingCryoprotectionStrategyCase[[All, -1]], SpecifiedChangeMediaForSameContainer|DefaultChangeMediaForSameContainer],
							"ExperimentFreezeCells centrifuges the prepared plates directly during the pelleting step, keeping all samples in each plate together",
							Nothing
						],
						If[MemberQ[conflictingCryoprotectionStrategyCase[[All, -1]], OwnOption] && MemberQ[Flatten@conflictingCryoprotectionStrategyCase[[All, 3]], CellPelletCentrifuge|CellPelletTime|CellPelletIntensity|CellPelletSupernatantVolume],
							"Cell pelleting options define how to separate of cells from existing media and only relevant when CryoprotectionStrategy is ChangeMedia",
							Nothing
						],
						If[MemberQ[conflictingCryoprotectionStrategyCase[[All, -1]], OwnOption] && MemberQ[Flatten@conflictingCryoprotectionStrategyCase[[All, 3]], CryoprotectantSolutionTemperature|CryoprotectantSolution|CryoprotectantSolutionVolume],
							"Cryoprotection options define how to prepare cryoprotectant solutions and mix them with the samples and only relevant when CryoprotectionStrategy is not None",
							Nothing
						]
					}
				]
			];
			reasonClause = If[!MatchQ[conflictingCryoprotectionStrategyCase, {}],
				Module[{groupedErrorDetails},
					groupedErrorDetails = GroupBy[conflictingCryoprotectionStrategyCase, Last];
					joinClauses[
						Flatten@Map[Function[{errorCode},
							Which[
								MatchQ[errorCode, SpecifiedChangeMediaForSameContainer],
									StringJoin[
										samplesForMessages[groupedErrorDetails[errorCode][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
										" ",
										pluralize[DeleteDuplicates@groupedErrorDetails[errorCode][[All, 1]], "resides in ", "reside in "],
										samplesForMessages[groupedErrorDetails[errorCode][[All, 2]], Cache -> cacheBall, Simulation -> simulation],
										" which ",
										hasOrHave[DeleteDuplicates@groupedErrorDetails[errorCode][[All, 2]]],
										" CryoprotectionStrategy specified as ChangeMedia for other sample(s) inside"
									],
								MatchQ[errorCode, DefaultChangeMediaForSameContainer],
									StringJoin[
										samplesForMessages[groupedErrorDetails[errorCode][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
										" ",
										pluralize[DeleteDuplicates@groupedErrorDetails[errorCode][[All, 1]], "resides in the same container as ", "reside in the same containers as "],
										samplesForMessages[Flatten[groupedErrorDetails[errorCode][[All, 2]]], Cache -> cacheBall, Simulation -> simulation],
										" which ",
										hasOrHave[DeleteDuplicates@Flatten[groupedErrorDetails[errorCode][[All, 2]]]],
										" cell pelleting options specified"
									],
								True,
									Module[{allOwnErrorEntries, groupedOnTargetStrategy},
										allOwnErrorEntries = Most /@ groupedErrorDetails[errorCode];
										groupedOnTargetStrategy = GroupBy[allOwnErrorEntries, Last];
										Map[
											StringJoin[
												samplesForMessages[groupedOnTargetStrategy[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
												" ",
												hasOrHave[DeleteDuplicates@groupedOnTargetStrategy[#][[All, 1]]],
												" specified valid ",
												pluralize[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 3]][[All, 1]]], "option ", "options "],
												joinClauses[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 3]][[All, 1]]]],
												" and invalid ",
												pluralize[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 3]][[All, 2]]], "option ", "options "],
												joinClauses[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 3]][[All, 2]]]],
												" for ",
												ToString[#],
												" CryoprotectionStrategy"
											]&,
											Keys[groupedOnTargetStrategy]
										]
									]
							]],
							Keys[groupedErrorDetails]
						],
						CaseAdjustment -> True
					]
				]
			];
			actionClause = If[!MatchQ[conflictingCryoprotectionStrategyCase, {}],
				Module[{groupedErrorDetails},
					groupedErrorDetails = GroupBy[conflictingCryoprotectionStrategyCase, Last];
					joinClauses[
						Flatten@Map[Function[{errorCode},
							Which[
								MatchQ[errorCode, SpecifiedChangeMediaForSameContainer],
									StringJoin[
										"for ",
										samplesForMessages[groupedErrorDetails[errorCode][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
										", please specify CryoprotectionStrategy as ChangeMedia",
										" and adjust ",
										pluralize[DeleteDuplicates@Flatten[groupedErrorDetails[errorCode][[All, 3]]], "option ", "options "],
										joinClauses[DeleteDuplicates@Flatten[groupedErrorDetails[errorCode][[All, 3]]]]
									],
								MatchQ[errorCode, DefaultChangeMediaForSameContainer],
									StringJoin[
										"for ",
										samplesForMessages[groupedErrorDetails[errorCode][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
										", please either specify CryoprotectionStrategy as ChangeMedia and adjust ",
										pluralize[DeleteDuplicates@Flatten[groupedErrorDetails[errorCode][[All, 3]]], "option ", "options "],
										joinClauses[DeleteDuplicates@Flatten[groupedErrorDetails[errorCode][[All, 3]]]],
										" or specify a non-ChangeMedia CryoprotectionStrategy for ",
										samplesForMessages[Flatten[groupedErrorDetails[errorCode][[All, 2]]], Cache -> cacheBall, Simulation -> simulation],
										", or transfer them out to separate containers to allow different cell pellet settings beforehand"
									],
								True,
									Module[{allOwnErrorEntries, groupedOnTargetStrategy},
										allOwnErrorEntries = Most /@ groupedErrorDetails[errorCode];
										groupedOnTargetStrategy = GroupBy[allOwnErrorEntries, Last];
										Map[
											StringJoin[
												"for ",
												samplesForMessages[groupedOnTargetStrategy[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
												", please either adjust ",
												pluralize[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 3]][[All, 2]]], "option ", "options "],
												joinClauses[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 3]][[All, 2]]]],
												" if ",
												ToString[#],
												" CryoprotectionStrategy is desired or adjust ",
												pluralize[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 2]][[All, 2]]], "option ", "options "],
												joinClauses[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 2]][[All, 2]]]],
												" if ",
												joinClauses[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 2]][[All, 1]]]],
												" CryoprotectionStrategy ",
												isOrAre[DeleteDuplicates@Flatten[groupedOnTargetStrategy[#][[All, 2]][[All, 1]]]],
												" desired"
											]&,
											Keys[groupedOnTargetStrategy]
										]
									]
							]],
							Keys[groupedErrorDetails]
						],
						CaseAdjustment -> True
					]
				]
			];
			If[!MatchQ[conflictingCryoprotectionStrategyCase, {}] && messages,
				Message[
					Error::ConflictingCryoprotectionOptions,
					captureSentence,
					reasonClause,
					actionClause
				]
			];
			conflictingCryoprotectionStrategyOption = If[MatchQ[conflictingCryoprotectionStrategyCase, {}],
				{},
				Flatten@Join[
					conflictingCryoprotectionStrategyCase[[All, 3]],
					{
						If[MemberQ[conflictingCryoprotectionStrategyCase[[All, -1]], SpecifiedChangeMediaForSameContainer],
							CryoprotectionStrategy,
							Nothing
						],
						If[MemberQ[conflictingCryoprotectionStrategyCase[[All, -1]], DefaultChangeMediaForSameContainer],
							{CellPelletCentrifuge, CellPelletTime, CellPelletIntensity, CellPelletSupernatantVolume},
							Nothing
						]
					}
				]
			];
			conflictingCryoprotectionStrategyTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = If[MatchQ[conflictingCryoprotectionStrategyCase, {}], {}, conflictingCryoprotectionStrategyCase[[All, 1]]];

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["All media changing and cryoprotection options specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " are not conflicting:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["All media changing and cryoprotection options specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " are not conflicting:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];
			(* Return *)
			{
				conflictingCryoprotectionStrategyCase[[All, 1]],
				conflictingCryoprotectionStrategyOption,
				conflictingCryoprotectionStrategyTest
			}
		],
		ConstantArray[{}, 3]
	];


	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptionsNotPropagated = OptionsHandling`Private`mapThreadOptions[ExperimentFreezeCells, resolvedGeneralOptions];

	(* When ChangeMedia, Pellet uo is applied on the whole input container, not individual sample *)
	(* Make rules associating a given input container with the suite of specified options *)
	indexMatchingChangeMediaOptionNames = {CellPelletCentrifuge, CellPelletTime, CellPelletIntensity};

	indexMatchingChangeMediaSampleQ = Map[
		MemberQ[talliedSamplesWithStrategies, {{ObjectP[#], ChangeMedia}, _Integer}]&,
		mySamples
	];

	nonAutomaticOptionsPerContainer = MapThread[
		Function[{sample, propagateQ, options},
			If[TrueQ[propagateQ],
				(* this is a weird use of Select *)
				(* basically select all the instances of our index matching options that don't have Automatic and return that association *)
				fastAssocLookup[fastAssoc, sample, {Container, Object}] -> Select[
					KeyTake[options, indexMatchingChangeMediaOptionNames],
					Not[MatchQ[#, Automatic]]&
				],
				Nothing
			]
		],
		{mySamples, indexMatchingChangeMediaSampleQ, mapThreadFriendlyOptionsNotPropagated}
	];

	(* Merging them together is super weird because we call Merge twice! *)
	(* This is the same logic used in ExperimentIncubateCells to propagate container options *)
	mergedNonAutomaticOptionsPerContainer = Merge[nonAutomaticOptionsPerContainer, Merge[#, First] &];

	(* Propagate the options I am dealing with out *)
	mapThreadFriendlyOptions = MapThread[
		Function[{sample, options},
			(* Join the options we already have with the ones we're propagating out *)
			(* the Join will cause the second set of options to replace the first set if possible *)
			Join[
				options,
				Module[{container, containerOptions},
					(* get the container of the sample in question, and the associated options we want to propagate across this container that we calculated above *)
					container = fastAssocLookup[fastAssoc, sample, {Container, Object}];
					containerOptions = Lookup[mergedNonAutomaticOptionsPerContainer, container, <||>];

					(* for each option, if *)
					(* 1.) The specified value for that option is Automatic for the given sample *)
					(* 2.) A different sample in the same container has a value that is not Automatic *)
					(* then we propagate the non-Automatic value in the same container to this sample too *)
					Association[Map[
						Function[{optionName},
							If[MatchQ[Lookup[options, optionName], Automatic] && KeyExistsQ[containerOptions, optionName],
								optionName -> Lookup[containerOptions, optionName],
								Nothing
							]
						],
						indexMatchingChangeMediaOptionNames
					]]

				]
			]
		],
		{mySamples, mapThreadFriendlyOptionsNotPropagated}
	];

	(* MapThread over each of our samples. *)
	{
		(* Options *)
		(*1*)resolvedCellTypes,
		(*2*)resolvedCultureAdhesions,
		(*3*)resolvedCellPelletIntensities,
		(*4*)resolvedCellPelletTimes,
		(*5*)resolvedCellPelletSupernatantVolumes,
		(*6*)resolvedCryoprotectantSolutions,
		(*7*)resolvedFreezers,
		(*8*)resolvedFreezingRacks,
		(*9*)resolvedCryogenicSampleContainers,
		(*10*)resolvedCryoprotectantSolutionVolumes,
		(*11*)resolvedAliquotVolumes,
		(*12*)resolvedCoolants,
		(*13*)resolvedSamplesOutStorageConditions,
		(* Errors and warnings *)
		(*14a*)conflictingCellTypeWarnings,
		(*14b*)conflictingCellTypeErrors,
		(*15*)conflictingCultureAdhesionBools,
		(*16*)overAspirationErrors,
		(*17a*)invalidRackBools,
		(*17b*)suggestedRackLists,
		(*18*)overFillDestinationErrors,
		(*19*)overFillSourceErrors,
		(*20*)cellTypeNotSpecifiedBools,
		(*21*)cultureAdhesionNotSpecifiedBools,
		(* Other internal variables *)
		(*22*)aliquotVolumeQuantities,
		(*23*)containerInVolumesBeforeAliquoting
	} = Transpose[MapThread[
		Function[{sample, options, samplePacket, sampleVolumeQuantity, modelPacket, containerPacket, containerModelPacket, inputContainerMaxVolume, mainCellType, mainCellIdentityModel},
			Module[
				{
					mainCellIdentityModelPacket, resolvedCryoprotectionStrategy,
					resolvedAliquotBool, resolvedCellType, conflictingCellTypeWarningBool, conflictingCellTypeErrorBool, cellTypeNotSpecifiedBool,
					cultureAdhesionFromSample, resolvedCultureAdhesion, conflictingCultureAdhesionBool, cultureAdhesionNotSpecifiedBool,
					resolvedCellPelletIntensity, resolvedCellPelletTime, resolvedCellPelletSupernatantVolume, overAspirationError,
					cellPelletSupernatantVolumeQuantity, resolvedCryoprotectantSolution, resolvedFreezer, semiresolvedFreezingRack,
					resolvedCryogenicSampleContainer, cryogenicSampleContainerModel, cryogenicSampleContainerModelMaxVolume,
					resolvedFreezingRack, invalidRackBool, suggestedRackList, resolvedCryoprotectantSolutionVolume,
					cryoprotectantSolutionVolumeQuantity, resolvedAliquotVolume, aliquotVolumeQuantity, finalVolumeBeforeFreezing,
					finalVolumeBeforeAliquoting, overFillDestinationError, overFillSourceError, resolvedCoolant, resolvedSamplesOutStorageCondition
				},

				(* Lookup information about our sample and container packets *)
				mainCellIdentityModelPacket = fetchPacketFromFastAssoc[mainCellIdentityModel, fastAssoc];

				(* Extract the resolved CryoprotectionStrategy and Aliquot options. *)
				{resolvedCryoprotectionStrategy, resolvedAliquotBool} = Lookup[options, {CryoprotectionStrategy, Aliquot}];

				(* Resolve the CellType option as if it wasn't specified, and the CellTypeNotSpecified warning and the ConflictingCellTypeError *)
				resolvedCellType = Which[
					(* if CellType was specified, use it *)
					MatchQ[Lookup[options, CellType], CellTypeP], Lookup[options, CellType],
					(* if CellType was not specified but we could figure it out from the sample, go with that *)
					MatchQ[mainCellType, CellTypeP], mainCellType,
					(* if CellType was not specified and we couldn't figure it out from the sample, default to Bacterial *)
					True, Bacterial
				];
				(* if CellType was specified but it conflicts with the fields in the Sample, go with what was specified but flip error/warning switch *)
				conflictingCellTypeErrorBool = If[And[
					MatchQ[Lookup[options, CellType], CellTypeP],
					MatchQ[mainCellType, Mammalian|Bacterial|Yeast],
					Or[
						MatchQ[Lookup[options, CellType], Mammalian] && MatchQ[mainCellType, MicrobialCellTypeP],
						MatchQ[mainCellType, Mammalian] && MatchQ[Lookup[options, CellType], MicrobialCellTypeP]
					]
				],
					True,
					False
				];
				(* For microbial cells, we use the same BSC model and pipette model. So no need to throw warning is CryoprotectionStrategy is None *)
				conflictingCellTypeWarningBool = If[And[
					MatchQ[Lookup[options, CellType], CellTypeP],
					MatchQ[mainCellType, Mammalian|Bacterial|Yeast],
					Or[
						MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant] && MatchQ[Lookup[options, CryoprotectantSolution], Automatic],
						MatchQ[resolvedCryoprotectionStrategy, ChangeMedia] && (MatchQ[Lookup[options, CryoprotectantSolution], Automatic] || MatchQ[Lookup[options, CellPelletIntensity], Automatic])
					],
					Or[
						MatchQ[Lookup[options, CellType], Yeast] && MatchQ[mainCellType, Bacterial],
						MatchQ[mainCellType, Yeast] && MatchQ[Lookup[options, CellType], Bacterial]
					]
				],
					True,
						False
				];
				(* if CellType was not specified and we couldn't figure it out from the sample, default to Bacterial and flip warning switch *)
				(* If we have already thrown non-liquid sample error, do not need to throw this warning *)
				cellTypeNotSpecifiedBool = If[And[
					MatchQ[Lookup[samplePacket, State], Liquid],
					!MatchQ[Lookup[options, CellType], CellTypeP],
					!MatchQ[mainCellType, CellTypeP]
				],
					True,
					False
				];

				(* Get the CultureAdhesion that we can discern from the sample *)
				cultureAdhesionFromSample = Which[
					(* if the sample has a CultureAdhesion, use that *)
					MatchQ[Lookup[samplePacket, CultureAdhesion], CultureAdhesionP],
						Lookup[samplePacket, CultureAdhesion],
					(* if sample doesn't have it but its model does, use that*)
					Not[NullQ[modelPacket]] && MatchQ[Lookup[modelPacket, CultureAdhesion], CultureAdhesionP],
						Lookup[modelPacket, CultureAdhesion],
					(* if there is a cell type identity model in its composition, pick the most concentrated one's CultureAdhesion *)
					MatchQ[mainCellIdentityModel, ObjectP[Model[Cell]]],
						Lookup[mainCellIdentityModelPacket, CultureAdhesion],
					(* otherwise, we have no idea and pick Null *)
					True,
						Null
				];

				(* Resolve the CultureAdhesion option if it wasn't specified, and the CultureAdhesionNotSpecified warning and the ConflictingCultureAdhesion error *)
				resolvedCultureAdhesion = Which[
					(* if CultureAdhesion was specified, use it *)
					MatchQ[Lookup[options, CultureAdhesion], CultureAdhesionP], Lookup[options, CultureAdhesion],
					(* if CultureAdhesion was not specified but we could figure it out from the sample, go with that *)
					MatchQ[cultureAdhesionFromSample, CultureAdhesionP], cultureAdhesionFromSample,
					(* if CultureAdhesion was not specified and we couldn't figure it out from the sample, resolve to Suspension *)
					True, Suspension
				];
				(* if CultureAdhesion was specified but it conflicts with the fields in the Sample, go with what was specified but flip error switch *)
				(* If we have already thrown non-liquid sample error, do not need to throw this error *)
				conflictingCultureAdhesionBool = If[And[
					MatchQ[Lookup[options, CultureAdhesion], CultureAdhesionP],
					Or[
						MatchQ[cultureAdhesionFromSample, CultureAdhesionP] && !MatchQ[Lookup[options, CultureAdhesion], cultureAdhesionFromSample],
						MatchQ[Lookup[samplePacket, State], Liquid] && MatchQ[Lookup[options, CultureAdhesion], SolidMedia]
					]
				],
					True,
					False
				];
				(* if CultureAdhesion was not specified and we couldn't figure it out from the sample, flip warning switch *)
				(* If we have already thrown non-liquid sample error, do not need to throw this warning *)
				cultureAdhesionNotSpecifiedBool = If[And[
					MatchQ[Lookup[samplePacket, State], Liquid],
					!MatchQ[Lookup[options, CultureAdhesion], CultureAdhesionP],
					!MatchQ[cultureAdhesionFromSample, CultureAdhesionP]
				],
					True,
					False
				];

				(* Resolve the CellPelletIntensity. *)
				resolvedCellPelletIntensity = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, CellPelletIntensity], Except[Automatic]],
						Lookup[options, CellPelletIntensity],
					(* If CryoprotectionStrategy is ChangeMedia, set this to the appropriate intensity constant for the resolved CellType. *)
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						Switch[resolvedCellType,
							Bacterial,
								$LivingBacterialCentrifugeIntensity,
							Yeast,
								$LivingYeastCentrifugeIntensity,
							Mammalian,
								$LivingMammalianCentrifugeIntensity,
							(* Any unsupported CellType should have triggered an error before now, but let's throw this in just in case. *)
							_,
								$LivingBacterialCentrifugeIntensity
						],
					(* Otherwise CryoprotectionStrategy is not ChangeMedia, and we default to Null. *)
					True,
						Null
				];

				(* Resolve the CellPelletTime. *)
				resolvedCellPelletTime = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, CellPelletTime], Except[Automatic]],
						Lookup[options, CellPelletTime],
					(* If CryoprotectionStrategy is ChangeMedia, default to 5 Minute. *)
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						5 Minute,
					(* Otherwise, CryoprotectionStrategy is not ChangeMedia. Set this to Null. *)
					True,
						Null
				];

				(* Resolve the CellPelletSupernatantVolume. *)
				resolvedCellPelletSupernatantVolume = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, CellPelletSupernatantVolume], Except[Automatic]],
						Lookup[options, CellPelletSupernatantVolume],
					(* If CryoprotectionStrategy is ChangeMedia, set this to All. *)
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						All,
					(* Otherwise, CryoprotectionStrategy is not ChangeMedia. Set this to Null. *)
					True,
						Null
				];

				(* Convert the expression of Null/All of resolvedCellPelletSupernatantVolume to handle calculations properly. *)
				cellPelletSupernatantVolumeQuantity = resolvedCellPelletSupernatantVolume/.{Null -> 0 Microliter, All -> sampleVolumeQuantity};

				(* if CellPelletSupernatantVolume was specified but it is larger than the sample volume *)
				(* Note if CellPelletSupernatantVolume is specified while CryoprotectionStrategy is Not ChangeMedia, an error will thrown downstream not here *)
				overAspirationError = If[
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia] && GreaterQ[cellPelletSupernatantVolumeQuantity, sampleVolumeQuantity],
					{sample, cellPelletSupernatantVolumeQuantity, sampleVolumeQuantity},
					Null
				];

				(* Resolve the CryoprotectantSolution. *)
				resolvedCryoprotectantSolution = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, CryoprotectantSolution], Except[Automatic]],
						Lookup[options, CryoprotectantSolution],
					(* If CryoprotectionStrategy is None, set this to Null. *)
					MatchQ[resolvedCryoprotectionStrategy, None],
						Null,
					(* Otherwise, set this according to the resolved CryoprotectionStrategy and CellType. *)
					True,
						Switch[{resolvedCryoprotectionStrategy, resolvedCellType},
							{ChangeMedia, Mammalian},
								Model[Sample, "id:M8n3rxn4JVBE"], (* Model[Sample, "Gibco Recovery Cell Culture Freezing Medium"] *)
							{ChangeMedia, Bacterial},
								Model[Sample, StockSolution, "id:Vrbp1jbnEBPw"], (* Model[Sample, StockSolution, "15% glycerol, 0.5% sodium chloride, Autoclaved"] *)
							{ChangeMedia, Yeast},
								Model[Sample, StockSolution, "id:1ZA60vAO7xla"], (* Model[Sample, StockSolution, "30% Glycerol in Milli-Q water, Autoclaved"] *)
							(* Otherwise, the CryoprotectionStrategy is AddCryoprotectant. For mammalian cells, add autoclaved 30% glycerol to the sample. *)
							{_, Mammalian},
								Model[Sample, StockSolution, "id:1ZA60vAO7xla"], (* Model[Sample, StockSolution, "30% Glycerol in Milli-Q water, Autoclaved"] *)
							(* Otherwise, the CryoprotectionStrategy is AddCryoprotectant and the cell type is yeast or bacterial, add autoclaved 50% glycerol*)
							{_, _},
								Model[Sample, StockSolution, "id:E8zoYvzX1NKB"](* Model[Sample, StockSolution, "50% Glycerol in Milli-Q water, Autoclaved"] *)
						]
				];

				(* Resolve the Freezer. *)
				resolvedFreezer = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, Freezer], Except[Automatic]],
						Lookup[options, Freezer],
					(* If the resolvedFreezingStrategy is ControlledRateFreezer, set this to the VIA Freeze Instrument. *)
					MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
						Model[Instrument, ControlledRateFreezer, "id:kEJ9mqaVPPWz"], (* Model[Instrument, ControlledRateFreezer, "VIA Freeze Research"] *)
					(* Otherwise, the resolvedFreezingStrategy is InsulatedCooler, and we set this to a Stirling Ultracold Freezer at -80 Celsius. *)
					True,
						Model[Instrument, Freezer, "id:01G6nvkKr3dA"] (* Model[Instrument, Freezer, "Stirling UltraCold SU780UE"] *)
				];

				(* Semi-Resolve the FreezingRack which helps determining CryogenicSampleContainer . *)
				semiresolvedFreezingRack = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, FreezingRack], Except[Automatic]],
						Lookup[options, FreezingRack],
					(* If the FreezingStrategy is ControlledRateFreezer, default to the VIA Freeze rack. *)
					MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
						Model[Container, Rack, "id:pZx9jo8ZVNW0"], (* Model[Container, Rack, "2mL Cryo Rack for VIA Freeze"] *)
					True,
						Automatic
				];

				(* Resolve the CryogenicSampleContainer. *)
				resolvedCryogenicSampleContainer = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, CryogenicSampleContainer], Except[Automatic]],
						Lookup[options, CryogenicSampleContainer],
					(* If InSitu is True (Aliquot is False), use the sample container. *)
					MatchQ[resolvedAliquotBool, False],
						Lookup[containerPacket, Object],
					(* If the FreezingStrategy is ControlledRateFreezer, we're limited to 2 mL cryo vials at largest, so use a 2 mL cryo vial. *)
					MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
						Model[Container, Vessel, "id:vXl9j5qEnnOB"], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
					(* If we're using a 5 mL Mr. Frosty Rack Model, use a 5 mL cryo vial. *)
					And[
						MatchQ[semiresolvedFreezingRack, ObjectP[]],
						Or[
							MatchQ[semiresolvedFreezingRack, ObjectP[Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]]], (* Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"] *)
							MatchQ[fastAssocLookup[fastAssoc, semiresolvedFreezingRack, Model], ObjectP[Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]]]
						]
					],
						Model[Container, Vessel, "id:o1k9jAG1Nl57"], (* Model[Container, Vessel, "5mL Cryogenic Vial"] *)
					(* If we're using a 2 mL Mr. Frosty Rack Model, use a 2 mL cryo vial. *)
					And[
						MatchQ[semiresolvedFreezingRack, ObjectP[]],
						Or[
							MatchQ[semiresolvedFreezingRack, ObjectP[Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"]]], (* Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"] *)
							MatchQ[fastAssocLookup[fastAssoc, semiresolvedFreezingRack, Model], ObjectP[Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"]]]
						]
					],
						Model[Container, Vessel, "id:vXl9j5qEnnOB"], (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
					(* If InSitu is False (Aliquot is True), and CryoprotectionStrategy is ChangeMedia, only the amount of AliquotVolume will be transferred to the new cryogenicSampleContainer *)
					(* Check if AliquotVolume is specified. If not, precalculate AliquotVolume using CryoprotectantSolutionVolume if it is specified. *)
					(* Since "2mL Cryogenic Vial" can only take up to 1.5ml (75%*2ml) solution to freeze, if total volume is greater than 1.5ml, resolve to 5mL Cryogenic Vial. *)
					And[
						MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						Or[
							MatchQ[Lookup[options, AliquotVolume], VolumeP] && GreaterQ[Lookup[options, AliquotVolume], 1.5 Milliliter],
							(* if CryoprotectantSolutionVolume is specified *)
							MatchQ[Lookup[options, AliquotVolume], All] && MatchQ[Lookup[options, CryoprotectantSolutionVolume], VolumeP] && GreaterQ[(sampleVolumeQuantity - cellPelletSupernatantVolumeQuantity)/Lookup[uniqueSampleToFinalCellStockNumsLookup, sample] + Lookup[options, CryoprotectantSolutionVolume], 1.5 Milliliter],
							EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && MatchQ[Lookup[options, CryoprotectantSolutionVolume], VolumeP] && GreaterQ[(sampleVolumeQuantity - cellPelletSupernatantVolumeQuantity)/Lookup[uniqueSampleToFinalCellStockNumsLookup, sample] + Lookup[options, CryoprotectantSolutionVolume], 1.5 Milliliter],
							(* precalculate CryoprotectantSolutionVolume as Min[sampleVolumeQuantity, cellPelletSupernatantVolumeQuantity], so total volume stays at sampleVolumeQuantity *)
							MatchQ[Lookup[options, AliquotVolume], All] && GreaterQ[sampleVolumeQuantity, 1.5 Milliliter],
							EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && GreaterQ[sampleVolumeQuantity, 1.5 Milliliter]
						]
					],
						Model[Container, Vessel, "id:o1k9jAG1Nl57"], (* Model[Container, Vessel, "5mL Cryogenic Vial"] *)
					(* If InSitu is False (Aliquot is True), and CryoprotectionStrategy is AddCryoprotectant or None, we check AliquotVolume+CryoprotectantSolutionVolume *)
					(* Since "2mL Cryogenic Vial" can only take up to 1.5ml solution to freeze, if total volume is greater than 1.5ml, resolve to 5mL Cryogenic Vial. *)
					Or[
						(* If the sample transferred to new cryogenic sample container is already larger than 1.5ml, can only resolve to 5ml cryogenic vial *)
						MatchQ[Lookup[options, AliquotVolume], VolumeP] && GreaterQ[Lookup[options, AliquotVolume], 1.5 Milliliter],
						MatchQ[Lookup[options, AliquotVolume], All] && GreaterQ[sampleVolumeQuantity, 1.5 Milliliter],
						EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && GreaterQ[sampleVolumeQuantity, 1.5 Milliliter],
						(* For AddCryoprotectant case. If CryoprotectantSolutionVolume is specified, use it. Otherwise, set to 50% of AliquotVolume *)
						(* If the same sample has only been specified once in the entire input sample list, we try to use it up and check if it is possible to use 5ml vial *)
						MatchQ[Lookup[options, CryoprotectantSolutionVolume], VolumeP] && GreaterQ[Lookup[options, CryoprotectantSolutionVolume], 1.5 Milliliter],
						MatchQ[Lookup[options, CryoprotectantSolutionVolume], VolumeP] && MatchQ[Lookup[options, AliquotVolume], VolumeP] && GreaterQ[Total@Lookup[options, {AliquotVolume, CryoprotectantSolutionVolume}], 1.5 Milliliter],
						MatchQ[Lookup[options, CryoprotectantSolutionVolume], VolumeP] && MatchQ[Lookup[options, AliquotVolume], All] && GreaterQ[Lookup[options, CryoprotectantSolutionVolume] + sampleVolumeQuantity, 1.5 Milliliter],
						MatchQ[Lookup[options, CryoprotectantSolutionVolume], VolumeP] && EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && GreaterQ[Lookup[options, CryoprotectantSolutionVolume] + sampleVolumeQuantity, 1.5 Milliliter],
						MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant] && MatchQ[Lookup[options, AliquotVolume], VolumeP] && GreaterQ[Lookup[options, AliquotVolume], 1 Milliliter],
						MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant] && MatchQ[Lookup[options, AliquotVolume], All] && GreaterQ[sampleVolumeQuantity, 1 Milliliter],
						MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant] && EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && GreaterQ[sampleVolumeQuantity, 1 Milliliter]
					],
						Model[Container, Vessel, "id:o1k9jAG1Nl57"], (* Model[Container, Vessel, "5mL Cryogenic Vial"] *)
					(* Otherwise, use a 2 mL cryo vial. *)
					True,
						Model[Container, Vessel, "id:vXl9j5qEnnOB"] (* Model[Container, Vessel, "2mL Cryogenic Vial"] *)
				];

				(* Pull out the MaxVolume of CryogenicSampleContainer *)
				cryogenicSampleContainerModel = Which[
					MatchQ[resolvedCryogenicSampleContainer, ObjectP[Lookup[containerPacket, Object]]],
						Lookup[containerModelPacket, Object, Null],
					MatchQ[resolvedCryogenicSampleContainer, ObjectP[Object[Container]]],
						fastAssocLookup[fastAssoc, resolvedCryogenicSampleContainer, Model],
					True,
						resolvedCryogenicSampleContainer
				];
				cryogenicSampleContainerModelMaxVolume = Which[
					MatchQ[resolvedCryogenicSampleContainer, ObjectP[Lookup[containerPacket, Object]]],
						inputContainerMaxVolume,
					MatchQ[resolvedCryogenicSampleContainer, ObjectP[Object[Container]]],
						fastAssocLookup[fastAssoc, resolvedCryogenicSampleContainer, {Model, MaxVolume}]/. Null -> 0 Microliter,
					True,
						fastAssocLookup[fastAssoc, resolvedCryogenicSampleContainer, MaxVolume]/. Null -> 0 Microliter
				];

				(* Resolve the FreezingRack and track InvalidFreezingRack errors *)
				{resolvedFreezingRack, invalidRackBool, suggestedRackList} = Which[
					(* if FreezingRack was specified but it is not one of the rack models from search, mark invalidRackBool as True *)
					Or[
						MatchQ[semiresolvedFreezingRack, ObjectP[Object[Container]]] && !MatchQ[fastAssocLookup[fastAssoc, semiresolvedFreezingRack, Model], ObjectP[allPossibleFreezingRacks]],
						MatchQ[semiresolvedFreezingRack, ObjectP[Model[Container]]] && !MatchQ[semiresolvedFreezingRack, ObjectP[allPossibleFreezingRacks]]
					],
						{semiresolvedFreezingRack, True, allPossibleFreezingRacks},
					(* FreezingStrategy specific rack is checked by FreezeCellsConflictingHardware and ConflictingCellFreezingOptions, do not track here with InvalidFreezingRack *)
					 Or[
						MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MatchQ[semiresolvedFreezingRack, ObjectP[]] && !MatchQ[semiresolvedFreezingRack, ObjectP[{Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}]],
						MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MatchQ[semiresolvedFreezingRack, ObjectP[{Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}]],
						MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MatchQ[semiresolvedFreezingRack, ObjectP[]] && MatchQ[cryogenicSampleContainerModel, ObjectP[Model[Container, Vessel, "id:o1k9jAG1Nl57"]]](*5mL Cryogenic Vial*)
					],
						{semiresolvedFreezingRack, False, {}},
					(* If the user specified the option at this index as one of the rack models from search, but mismatched with cryovial (5ml rack/2ml vial or vice versa). *)
					And[
						Or[
							MatchQ[semiresolvedFreezingRack, ObjectP[Model[Container]]] && MatchQ[semiresolvedFreezingRack, Except[ObjectP[{Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"], Model[Container, Rack, "id:pZx9jo8ZVNW0"]}]]],(*"2mL Mr. Frosty Rack" and "2mL Cryo Rack for VIA Freeze"*)
							MatchQ[semiresolvedFreezingRack, ObjectP[Object[Container]]] && !MatchQ[fastAssocLookup[fastAssoc, semiresolvedFreezingRack, Model], ObjectP[{Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"], Model[Container, Rack, "id:pZx9jo8ZVNW0"]}]]
						],
						MatchQ[cryogenicSampleContainerModel, ObjectP[Model[Container, Vessel, "id:vXl9j5qEnnOB"]]](*2mL Cryogenic Vial*)
					],
						{semiresolvedFreezingRack, False, {If[MatchQ[resolvedFreezingStrategy, InsulatedCooler], Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"], Model[Container, Rack, "id:pZx9jo8ZVNW0"]]}},
					And[
						Or[
							MatchQ[semiresolvedFreezingRack, ObjectP[Model[Container]]] && MatchQ[semiresolvedFreezingRack, Except[ObjectP[Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]]]],(*"5mL Mr. Frosty Rack"*)
							MatchQ[semiresolvedFreezingRack, ObjectP[Object[Container]]] && !MatchQ[fastAssocLookup[fastAssoc, semiresolvedFreezingRack, Model], ObjectP[Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]]]
						],
						MatchQ[cryogenicSampleContainerModel, ObjectP[Model[Container, Vessel, "id:o1k9jAG1Nl57"]]](*5mL Cryogenic Vial*)
					],
						{semiresolvedFreezingRack, False, {Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]}},
					(* If the user specified the option at this index as one of the rack models from search, and either CryogenicSampleContainer is not a cryovial or is compatible with the specified rack. *)
					MatchQ[semiresolvedFreezingRack, Except[Automatic]],
						{semiresolvedFreezingRack, False, {}},
					(* If the CryogenicSampleContainer's max volume is NOT 2 mL or less, use the Mr. Frosty rack for 5 mL vials. *)
					GreaterQ[cryogenicSampleContainerModelMaxVolume, 2 Milliliter],
						{Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"], False, {}},(* Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"] *)
					True,
						{Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"], False, {}} (* Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"] *)
				];

				(* Resolve the CryoprotectantSolutionVolume. *)
				resolvedCryoprotectantSolutionVolume = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, CryoprotectantSolutionVolume], Except[Automatic]],
						Lookup[options, CryoprotectantSolutionVolume],
					(* If CryoprotectionStrategy is None, set this to Null. *)
					MatchQ[resolvedCryoprotectionStrategy, None],
						Null,
					(* If CryoprotectionStrategy is ChangeMedia, check the sample volume or supernatant volume and resolve to 100% of the lesser. *)
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						SafeRound[Min[sampleVolumeQuantity, cellPelletSupernatantVolumeQuantity], 1 Microliter],
					(* If InSitu is True (Aliquot is False) and CryoprotectionStrategy is AddCryoprotectant, check the sample volume and resolve to 50%. *)
					(* If the sample volume is lower than 100 ul, use 100ul instead *)
					(* 100 Microliter and 100 Milligram are defined in individualStorageItems in ProcedureFramework for determine empty samples *)
					MatchQ[resolvedAliquotBool, False],
						Max[100 Microliter, SafeRound[0.50 * sampleVolumeQuantity, 1 Microliter]],
					(* If InSitu is False and CryoprotectionStrategy is AddCryoprotectant, check if AliquotVolume is specified. If not, precalculate it. *)
					True,
						Which[
							MatchQ[Lookup[options, AliquotVolume], VolumeP],
								Max[100 Microliter, SafeRound[0.50 * Lookup[options, AliquotVolume], 1 Microliter]],
							MatchQ[Lookup[options, AliquotVolume], All],
								Max[100 Microliter, SafeRound[0.50 * sampleVolumeQuantity, 1 Microliter]],
							True,
								Max[100 Microliter, SafeRound[Min[0.5 * sampleVolumeQuantity, 0.25 * cryogenicSampleContainerModelMaxVolume], 1 Microliter]]
						]
				];

				(* Convert the resolvedCryoprotectantSolutionVolume to handle calculations properly even if the option resolves to Null *)
				cryoprotectantSolutionVolumeQuantity = resolvedCryoprotectantSolutionVolume/. Null -> 0 Microliter;

				(* Calculate the total volume in input sample container before aliquotting. *)
				finalVolumeBeforeAliquoting = Which[
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						(* If over aspirate, use 0 Microliter *)
						Max[sampleVolumeQuantity - cellPelletSupernatantVolumeQuantity + cryoprotectantSolutionVolumeQuantity, 0 Microliter],
					MatchQ[resolvedAliquotBool, False],
						sampleVolumeQuantity + cryoprotectantSolutionVolumeQuantity,
					True,
						sampleVolumeQuantity
				];

				(* Resolve the AliquotVolume. *)
				resolvedAliquotVolume = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, AliquotVolume], Except[Automatic]],
						Lookup[options, AliquotVolume],
					(* If Aliquot is False, set this to Null. *)
					MatchQ[resolvedAliquotBool, False],
						Null,
					(* Check if there are any replicates/parallel sample input the same as current sample. *)
					(* If Aliquot is True and CryoprotectionStrategy is set to ChangeMedia, use lesser of 75% of the volume of the CryogenicSampleContainer or All *)
					(* If there is no duplicates and the resuspended sample volume is less than 75% of cryogenic vial max vol, set to All instead of quantity *)
					EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						If[GreaterQ[finalVolumeBeforeAliquoting, 0.75 * cryogenicSampleContainerModelMaxVolume],
							SafeRound[0.75 * cryogenicSampleContainerModelMaxVolume, 1 Microliter],
							All
						],
					(* If there is no duplicate, use All or 50% of max volume or 75% - specified CryoprotectantSolutionVolume whichever is smaller *)
					EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant],
						Which[
							EqualQ[Min[{(0.75*cryogenicSampleContainerModelMaxVolume - cryoprotectantSolutionVolumeQuantity)/.vol:LessP[0Microliter] -> Nothing, 0.5*cryogenicSampleContainerModelMaxVolume, sampleVolumeQuantity}], sampleVolumeQuantity],
								All,
							GreaterQ[0.75*cryogenicSampleContainerModelMaxVolume - cryoprotectantSolutionVolumeQuantity, 0.5 * cryogenicSampleContainerModelMaxVolume] || LessQ[0.75*cryogenicSampleContainerModelMaxVolume - cryoprotectantSolutionVolumeQuantity, 0 Microliter],
								SafeRound[0.5 * cryogenicSampleContainerModelMaxVolume, 1 Microliter],
							True,
								SafeRound[0.75*cryogenicSampleContainerModelMaxVolume - cryoprotectantSolutionVolumeQuantity, 1 Microliter]
						],
					(* If there is no duplicate, use All or 50% of max volume whichever is smaller *)
					EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && MatchQ[resolvedCryoprotectionStrategy, None],
						If[GreaterQ[sampleVolumeQuantity, 0.75 * cryogenicSampleContainerModelMaxVolume],
							SafeRound[0.75 * cryogenicSampleContainerModelMaxVolume, 1 Microliter],
							All
						],
					(* If there are duplicates, divide input sample volume equally among them *)
					(* If Aliquot is True and CryoprotectionStrategy is set to ChangeMedia, automatically set to the lesser of 75% of the volume of the CryogenicSampleContainer or the total volume of the suspended cell sample *)
					(* If there is no duplicates and the resuspended sample volume is less than 75% of cryogenic vial max vol, set to All instead of quantity *)
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						SafeRound[Min[0.75 * cryogenicSampleContainerModelMaxVolume, finalVolumeBeforeAliquoting/Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]], 1 Microliter],
					MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant],
						SafeRound[Min[{(0.75*cryogenicSampleContainerModelMaxVolume - cryoprotectantSolutionVolumeQuantity)/.vol:LessP[0Microliter] -> Nothing, 0.5 * cryogenicSampleContainerModelMaxVolume, sampleVolumeQuantity/Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]}], 1 Microliter],
					True,
						SafeRound[Min[0.75 * cryogenicSampleContainerModelMaxVolume, sampleVolumeQuantity/Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]], 1 Microliter]
				];

				(* Convert the expression of Null/All of resolvedAliquotVolume to handle calculations properly. *)
				aliquotVolumeQuantity = resolvedAliquotVolume/.{Null -> 0 Microliter, All -> finalVolumeBeforeAliquoting};

				(* Calculate the total volume in each destination cryogenic sample container when everything is liquid state. *)
				finalVolumeBeforeFreezing = Which[
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						If[TrueQ[resolvedAliquotBool],
							aliquotVolumeQuantity,
							(* If over aspirate, use 0 Microliter *)
							Max[(sampleVolumeQuantity - cellPelletSupernatantVolumeQuantity + cryoprotectantSolutionVolumeQuantity)/Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 0 Microliter]
						],
					MatchQ[resolvedAliquotBool, False],
						sampleVolumeQuantity + cryoprotectantSolutionVolumeQuantity,
					True,
						aliquotVolumeQuantity + cryoprotectantSolutionVolumeQuantity
				];

				(* Check if the finalVolumeBeforeFreezing is beyond 75% of MaxVolume of CryogenicSampleContainer *)
				(* When Aliquot is False, we have thrown Error::CryoprotectantSolutionOverfill, no need to throw OverFillDestinationError again *)
				overFillDestinationError = If[TrueQ[resolvedAliquotBool] && GreaterQ[finalVolumeBeforeFreezing, 0.75 * cryogenicSampleContainerModelMaxVolume],
					{finalVolumeBeforeFreezing, cryogenicSampleContainerModelMaxVolume},
					Null
				];
				(* When we add cryoprotectant to sample container to resuspend during ChangeMedia step, use 100% as limit since state is liquid *)
				(* When we add cryoprotectant to sample container if Aliquot is False, use 75% as limit since state is liquid *)
				overFillSourceError = Which[
					And[
						TrueQ[resolvedAliquotBool],
						MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						GreaterQ[finalVolumeBeforeAliquoting, inputContainerMaxVolume]
					],
						{finalVolumeBeforeAliquoting, inputContainerMaxVolume, ChangeMedia},
					And[
						MatchQ[resolvedAliquotBool, False],
						MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant],
						GreaterQ[finalVolumeBeforeAliquoting, 0.75*inputContainerMaxVolume]
					],
						{finalVolumeBeforeAliquoting, inputContainerMaxVolume, AddCryoprotectant},
					True,
						Null
				];

				(* Resolve the Coolant. *)
				resolvedCoolant = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, Coolant], Except[Automatic]],
						Lookup[options, Coolant],
					(* If the FreezingStrategy is ControlledRateFreezer, set this to Null. *)
					MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
						Null,
					(* If the user specified the option at other index, use the specified value. *)
					MemberQ[Lookup[myOptions, Coolant], ObjectP[]],
						FirstCase[Lookup[myOptions, Coolant], ObjectP[]],
					(* Otherwise, set this to isopropyl alcohol. *)
					True,
						Model[Sample, "id:jLq9jXY4k6da"] (* Model[Sample, "Isopropanol"] *)
				];

				(* Resolve the SamplesOutStorageCondition. *)
				resolvedSamplesOutStorageCondition = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, SamplesOutStorageCondition], Except[Automatic]],
						Lookup[options, SamplesOutStorageCondition],
					(* Otherwise, default to CryogenicStorage *)
					True,
						CryogenicStorage
				];

					(* Gather MapThread results *)
				{
					(* Options *)
					(*1*)resolvedCellType,
					(*2*)resolvedCultureAdhesion,
					(*3*)resolvedCellPelletIntensity,
					(*4*)resolvedCellPelletTime,
					(*5*)resolvedCellPelletSupernatantVolume,
					(*6*)resolvedCryoprotectantSolution,
					(*7*)resolvedFreezer,
					(*8*)resolvedFreezingRack,
					(*9*)resolvedCryogenicSampleContainer,
					(*10*)resolvedCryoprotectantSolutionVolume,
					(*11*)resolvedAliquotVolume,
					(*12*)resolvedCoolant,
					(*13*)resolvedSamplesOutStorageCondition,
					(* Errors and warnings *)
					(*14a*)conflictingCellTypeWarningBool,
					(*14b*)conflictingCellTypeErrorBool,
					(*15*)conflictingCultureAdhesionBool,
					(*16*)overAspirationError,
					(*17a*)invalidRackBool,
					(*17b*)suggestedRackList,
					(*18*)overFillDestinationError,
					(*19*)overFillSourceError,
					(*20*)cellTypeNotSpecifiedBool,
					(*21*)cultureAdhesionNotSpecifiedBool,
					(* Other internal variables *)
					(*22*)aliquotVolumeQuantity,
					(*23*)finalVolumeBeforeAliquoting
				}
			]
		],
		{mySamples, mapThreadFriendlyOptions, samplePackets, sampleVolumeQuantities, sampleModelPackets, sampleContainerPackets, sampleContainerModelPackets, inputContainerMaxVolumes, sampleCellTypes, mainCellIdentityModels}
	]];

	(*--- Post-MapThread option resolutions ---*)

	(* Next, we resolve the CellPelletCentrifuges based on the other centrifugation options. *)

	(* First, find the indices at which CryoprotectionStrategy is ChangeMedia or where a centrifuge is already specified. *)
	allCentrifugeIndices = Sort @ DeleteDuplicates[
		Flatten @ {
			Position[resolvedCryoprotectionStrategies, ChangeMedia],
			Position[
				Lookup[mapThreadFriendlyOptions, CellPelletCentrifuge],
				ObjectP[{Object[Instrument, Centrifuge], Model[Instrument, Centrifuge]}]
			]
		}
	];
	noModelContainerIndices = Map[
		If[!MatchQ[Extract[sampleContainerModelPackets, ToList@#], PacketP[Model[Container]]],
			#,
			Nothing
		]&,
		allCentrifugeIndices
	];
	centrifugeIndices = DeleteCases[allCentrifugeIndices, Alternatives@@noModelContainerIndices];

	(* Get the container model at each of these indices to use as input for CentrifugeDevices. *)
	containerModelsAtCentrifugeIndices = Download[Extract[sampleContainerModelPackets, ToList[#]& /@centrifugeIndices], Object];

	(* Get the specified values of CellPelletCentrifuge at each of these indices, too. *)
	specifiedCentrifugesForChangeMedia = Lookup[mapThreadFriendlyOptions, CellPelletCentrifuge][[centrifugeIndices]];

	(* Call CentrifugeDevices to find all compatible centrifuges, unless there is no need to centrifuge anything. *)
	possibleCentrifuges = If[MatchQ[centrifugeIndices, {}],
		{},
		CentrifugeDevices[
			containerModelsAtCentrifugeIndices,
			Intensity -> resolvedCellPelletIntensities[[centrifugeIndices]] /. {Null -> Automatic}, (* Need to remove Nulls so this doesn't break *)
			Time -> resolvedCellPelletTimes[[centrifugeIndices]] /. {Null -> Automatic}, (* Need to remove Nulls so this doesn't break *)
			Preparation -> Manual,
			Cache -> cacheBall,
			Simulation -> simulation
		]
	];
	possibleCentrifugesWithoutSpeed = If[MatchQ[centrifugeIndices, {}],
		{},
		CentrifugeDevices[
			containerModelsAtCentrifugeIndices,
			Intensity -> Automatic,
			Time -> resolvedCellPelletTimes[[centrifugeIndices]] /. {Null -> Automatic}, (* Need to remove Nulls so this doesn't break *)
			Preparation -> Manual,
			Cache -> cacheBall,
			Simulation -> simulation
		]
	];
	incompatibleCentrifugeIndices = If[MatchQ[centrifugeIndices, {}],
		{},
		MapThread[
			Function[{index, specifiedCentrifuge, compatibleCentrifugesWithSpeed, compatibleCentrifugesWithFootprint},
				Which[
					And[
						MatchQ[specifiedCentrifuge, ObjectP[Model[Instrument]]],
						Or[
							MemberQ[compatibleCentrifugesWithFootprint, ObjectP[specifiedCentrifuge]] && !MemberQ[compatibleCentrifugesWithSpeed, ObjectP[specifiedCentrifuge]],
							!MatchQ[compatibleCentrifugesWithFootprint, {}] && !MemberQ[compatibleCentrifugesWithFootprint, ObjectP[specifiedCentrifuge]]
						]
					],
						index,
					And[
						MatchQ[specifiedCentrifuge, ObjectP[Object[Instrument]]],
						Or[
							MemberQ[compatibleCentrifugesWithFootprint, ObjectP[fastAssocLookup[fastAssoc, specifiedCentrifuge, Model]]] && !MemberQ[compatibleCentrifugesWithSpeed, ObjectP[fastAssocLookup[fastAssoc, specifiedCentrifuge, Model]]],
							!MatchQ[compatibleCentrifugesWithFootprint, {}] && !MemberQ[compatibleCentrifugesWithFootprint, ObjectP[fastAssocLookup[fastAssoc, specifiedCentrifuge, Model]]]
						]
					],
						index,
					True,
						Nothing
				]
			],
			{centrifugeIndices, specifiedCentrifugesForChangeMedia, possibleCentrifuges, possibleCentrifugesWithoutSpeed}
		]
	];
	noCompatibleCentrifugeIndices = If[MatchQ[centrifugeIndices, {}],
		{},
		DeleteCases[
			Join[PickList[centrifugeIndices, possibleCentrifuges, {}], noModelContainerIndices],
			Alternatives@@incompatibleCentrifugeIndices
		]
	];

	(* Try to minimize the number of centrifuges we need by creating a hierarchy based on their prevalence in possibleCentrifuges. *)
	centrifugesRankedByPreference = Module[
		{centrifugeTally, sortedCentrifuges, exclusionBools, centrifugesToExclude},
		(* Flatten and Tally the possibleCentrifuges list. *)
		centrifugeTally = Tally[Flatten[possibleCentrifuges]];
		(* Sort these from most common to least common and then remove the tally quantities. *)
		sortedCentrifuges = ReverseSortBy[centrifugeTally, Last][[All,1]];
		(* Determine if we need to exclude any centrifuge models. *)
		exclusionBools = MapThread[
			Function[{numberOfObjects, deprecatedBool},
				Or[MatchQ[numberOfObjects, 0], MatchQ[deprecatedBool, True]]
			],
			{Length /@ Lookup[centrifugeModelPackets, Objects], Lookup[centrifugeModelPackets, Deprecated]}
		];
		(* Find any centrifuge models without objects or which are deprecated. *)
		centrifugesToExclude = Alternatives @@ PickList[Lookup[centrifugeModelPackets, Object], exclusionBools];
		(* Now get rid of the tally and leave just the centrifuge Models, filtering out those with no objects or which are deprecated. *)
		sortedCentrifuges /. {centrifugesToExclude -> Nothing}
	];

	(* If potential centrifuges is {} due to not compatible footprint, then there are no compatible centrifuges. Set this to Avanti J-15R and throw an error later. *)
	updatedCentrifugeForOptions = ReplacePart[
		Lookup[mapThreadFriendlyOptions, CellPelletCentrifuge],
		AssociationThread[noModelContainerIndices, ConstantArray[Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], Length@noModelContainerIndices]](* Model[Instrument, Centrifuge, "Avanti J-15R"] *)
	];

	(* Resolve the centrifuge list based on the information we had above from CentrifugeDevices and the MapThread. *)
	preResolvedCellPelletCentrifuges = MapThread[
		Function[{specifiedCentrifuge, possibleCentrifugesPerSample},
			Which[
				(* If the user specified the option, use what they specified. *)
				MatchQ[specifiedCentrifuge, Except[Automatic]],
					specifiedCentrifuge,
				(* If potential centrifuges is {}, then there are no compatible centrifuges. Set this to Avanti J-15R and throw an error later. *)
				MatchQ[possibleCentrifugesPerSample, {}],
					Model[Instrument, Centrifuge, "id:pZx9jo8WA4z0"], (* Model[Instrument, Centrifuge, "Avanti J-15R"] *)
				(* Otherwise, use the possible centrifuge Model that is ranked highest due to its prevalence in centrifugesRankedByPreference. *)
				True,
					FirstCase[centrifugesRankedByPreference, ObjectP[possibleCentrifugesPerSample]]
			]
		],
		{specifiedCentrifugesForChangeMedia, possibleCentrifuges}
	];

	(* Now insert these resolved Centrifuges into a NullP list to preserve index-matching. *)
	resolvedCellPelletCentrifuges = ReplacePart[
		updatedCentrifugeForOptions,
		AssociationThread[centrifugeIndices, preResolvedCellPelletCentrifuges]
	]/.Automatic -> Null;
	resolvedCellPelletCentrifugeModels = Map[
		If[MatchQ[#, ObjectP[Object[Instrument]]],
			fastAssocLookup[fastAssoc, #, Model],
			#
		]&,
		resolvedCellPelletCentrifuges
	];


	(* Get the options that do not need to be resolved directly from SafeOptions. *)
	{template, fastTrack, operator, outputOption} = Lookup[myOptions, {Template, FastTrack, Operator, Output}];

	(* Get the resolved Email option; for this experiment, the default is True *)
	email = If[MatchQ[Lookup[myOptions, Email], Automatic],
		True,
		Lookup[myOptions, Email]
	];

	(* Combine the resolved options together at this point; everything after is error checking, and for the warning below I need this for better error checking *)
	resolvedOptions = ReplaceRule[
		Join[
			resolvedGeneralOptions,
			(* explicitly overriding these options to be {} and Null to make things more manageable to pass around and also more readable *)
			{Cache -> {}, Simulation -> Null}
		],
		Join[
			Flatten[{
				CellType -> resolvedCellTypes,
				CultureAdhesion -> resolvedCultureAdhesions,
				CellPelletCentrifuge -> resolvedCellPelletCentrifuges,
				CellPelletIntensity -> resolvedCellPelletIntensities,
				CellPelletTime -> resolvedCellPelletTimes,
				CellPelletSupernatantVolume -> resolvedCellPelletSupernatantVolumes,
				CryoprotectantSolution -> resolvedCryoprotectantSolutions,
				CryoprotectantSolutionVolume -> resolvedCryoprotectantSolutionVolumes,
				Freezer -> resolvedFreezers,
				FreezingRack -> resolvedFreezingRacks,
				CryogenicSampleContainer -> resolvedCryogenicSampleContainers,
				AliquotVolume -> resolvedAliquotVolumes,
				Coolant -> resolvedCoolants,
				SamplesOutStorageCondition -> resolvedSamplesOutStorageConditions,
				CryogenicSampleContainerLabel -> resolvedCryogenicSampleContainerLabels,
				Email -> email,
				Template -> template,
				FastTrack -> fastTrack,
				Operator -> operator,
				Output -> outputOption
			}]
		]
	];

	(* Doing this because it makes the warning checks below easier *)
	resolvedMapThreadOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFreezeCells, resolvedOptions];

	(* Tally the input samples with resolved volume *)
	(* The tally is in the format like:{{{sample1, 1 Milliliter, True, 500 Microliter}, 1}, {sample2, 2 Milliliter, False, 2 Milliliter}, 2}*)
	talliedSampleWithVolume = Tally[Transpose@{mySamples, containerInVolumesBeforeAliquoting, resolvedAliquotBools, aliquotVolumeQuantities}];

	(* Generate a lookup for each unique input sample, example <|sample1 -> 0 Microliter, sample3 -> 100 Microliter |> *)
	uniqueSampleToUsedVolLookup = Association@Map[
		Function[{uniqueSample},
			Module[{relatedEntries, replicatedRelatedEntries, unusedVol},
				relatedEntries = Cases[talliedSampleWithVolume, {{ObjectP[uniqueSample], __}, _}];
				(* Multiply the count from tally as well as NumberOfReplicates to AliquotVolume *)
				replicatedRelatedEntries = Map[
					<|
						TotalVolume -> #[[1]][[2]],
						Aliquot -> #[[1]][[3]],
						TotalAliquotVolume -> numericNumberOfReplicates*#[[2]]*(#[[1]][[4]])
					|>&,
					relatedEntries
				];
				unusedVol = If[MemberQ[Lookup[replicatedRelatedEntries, Aliquot], True],
					Lookup[replicatedRelatedEntries, TotalVolume][[1]] - Total[Lookup[replicatedRelatedEntries, TotalAliquotVolume]],
					0 Microliter
				];
				(* Return the lookup *)
				uniqueSample -> unusedVol
			]
		],
		DeleteDuplicates@mySamples
	];

	(*-- CONFLICTING OPTION CHECKS II --*)

	(* WARNINGS *)
	(* 1. Warning::FreezeCellsReplicateLabels *)
	(* Throw a warning informing the user of the replicate labels if there are replicates. *)
	(* Note:if we are not in a global framework, we assume we are not calling option resolver from ExperimentManualCellPreparation or ExperimentCellPreparation *)
	(* since CryogenicSampleContainerLabel is unit operation option, we do not throw warning if we are on CCD from ExperimentFreezeCells *)
	(* We only throw this warning we are calling ExperimentManualCellPreparation or ExperimentCellPreparation with FreezeCells primitive *)
	(* In these cases, CryogenicSampleContainerLabel is prefilled *)
	replicatesQ = And[
		GreaterQ[correctNumberOfReplicates, 1],
		(* Don't do this error check if there are duplicate samples. *)
		MatchQ[duplicateSamplesCases, {}],
		(* Framework populates Labels and if resolver expands the label, throw a warning *)
		And[
			MemberQ[userSpecifiedLabels, _String],
			!MatchQ[userSpecifiedLabels, resolvedCryogenicSampleContainerLabels]
		]
	];

	(* Generate strings to output as part of the warning message. *)
	replicateLabelWarningString = If[replicatesQ,
		Module[
			{sampleToLabelsRules},
			(* Map from sample to its corresponding replicate labels. *)
			sampleToLabelsRules = MapThread[
				(#1 -> #2)&,
				{mySamples, Partition[Flatten @ resolvedCryogenicSampleContainerLabels, correctNumberOfReplicates]}
			];
			(* Generate strings which clearly indicate which sample is being partitioned into which labels. *)
			StringJoin @ Map[
				"The replicates of " <> ObjectToString[#, Cache -> cacheBall, Simulation -> simulation] <> " have CryogenicSampleContainerLabel set to "<>ToString[Lookup[sampleToLabelsRules, #]]<>". "&,
				mySamples
			]
		],
		Null
	];

	If[replicatesQ && messages,
		Message[
			Warning::FreezeCellsReplicateLabels,
			correctNumberOfReplicates,
			replicateLabelWarningString
		];
	];


	(* 2. Error::FreezeCellsReplicatesAliquotRequired *)
	(* Aliquot must be True for all samples if NumberOfReplicates is greater than 1 or if parallel samples are set *)
	(* We allow reusing the same samples for several cases: *)
	(* Case1: NumberOfReplicates are set to a number. In this case, the same CryoprotectionStrategy is specified *)
	(* Case2: the same sample go through different CryoprotectionStrategies(AddCryoprotectant or None) or different CryoprotectionSolution(Volume). *)
	(* In this case2, InSitu can not be True, and AliquotVolume cannot be All. *)
	(* Case3: Any combination of case1 and case2 *)
	(* Note: if we have thrown FreezeSamplesDuplicatedSample on them before, do not need to throw again *)
	replicatesWithoutAliquotCases = Map[
		Function[{sample},
			Which[
				And[
					MemberQ[talliedSampleWithVolume, {{ObjectP[sample], _, False, _}, _}],
					GreaterQ[correctNumberOfReplicates, 1],
					EqualQ[correctNumberOfReplicates, Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]],
					!MemberQ[duplicatedSampleInputs, ObjectP[sample]]
				],
					{NumberOfReplicates, sample, correctNumberOfReplicates},
				And[
					MemberQ[talliedSampleWithVolume, {{ObjectP[sample], _, False, _}, _}],
					GreaterQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1],
					!EqualQ[correctNumberOfReplicates, Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]],
					!MemberQ[duplicatedSampleInputs, ObjectP[sample]]
				],
					{Multiple, sample, Length@Position[mySamples, sample]},
				True,
					Nothing
			]
		],
		DeleteDuplicates@mySamples
	];

	If[Length[replicatesWithoutAliquotCases] > 0 && messages,
		Module[{captureSentence, reasonClausePart1, reasonClausePart2},
			captureSentence = If[MemberQ[replicatesWithoutAliquotCases[[All, 1]], NumberOfReplicates],
				"When the NumberOfReplicates is set to 2 or greater",
				"When there are duplicated samples in the inputs"
			];
			reasonClausePart1 = StringJoin[
				Capitalize@samplesForMessages[replicatesWithoutAliquotCases[[All, 2]], mySamples, Cache -> cacheBall, Simulation -> simulation],
				" ",
				hasOrHave[DeleteDuplicates@replicatesWithoutAliquotCases[[All, 2]]]
			];
			reasonClausePart2 = If[MemberQ[replicatesWithoutAliquotCases[[All, 1]], NumberOfReplicates],
				"the option NumberOfReplicates is set to " <> ToString[correctNumberOfReplicates],
				Module[{repeatedTimes},
					repeatedTimes = DeleteDuplicates[replicatesWithoutAliquotCases[[All, 3]]];
					StringJoin[
						pluralize[replicatesWithoutAliquotCases[[All, 2]], "this sample appears ", "these samples appear "],
						Which[
							Length[repeatedTimes] == 1 && EqualQ[repeatedTimes[[1]], 2],
								"twice",
							Length[repeatedTimes] == 1,
								IntegerName[repeatedTimes, "English"] <> " times",
							True,
								"from " <> ToString[Min[repeatedTimes]] <> " to " <> ToString[Max[repeatedTimes]] <> " times"
						],
						" in the input samples"
					]
				]
			];
			Message[
				Error::FreezeCellsReplicatesAliquotRequired,
				captureSentence,
				reasonClausePart1,
				reasonClausePart2
			]
		]
	];

	replicatesWithoutAliquotTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = replicatesWithoutAliquotCases[[All, 2]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if there are duplicates:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if there are duplicates:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 3.Warning::CellTypeNotSpecified *)
	(* Throw a warning if the CellType is neither specified by the user nor known from the sample object. In these cases, we default to Bacterial. *)
	If[Or@@cellTypeNotSpecifiedBools && messages && notInEngine,
		Message[
			Warning::CellTypeNotSpecified,
			(*1*)(* Potentially collapse to the sample or all samples instead of ID here *)
			StringJoin[
				Capitalize@samplesForMessages[PickList[mySamples, cellTypeNotSpecifiedBools], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
				" ",
				hasOrHave[DeleteDuplicates@PickList[mySamples, cellTypeNotSpecifiedBools]]
			],
			(*2*)pluralize[DeleteDuplicates@PickList[mySamples, cellTypeNotSpecifiedBools], "this sample", "these samples"]
		]
	];

	(* Create the corresponding test for the invalid options. *)
	cellTypeNotSpecifiedTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, cellTypeNotSpecifiedBools];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CellType specified (as an option or in the Model)", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CellType specified (as an option or in the Model)", True, True],
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

	(* 4. ConflictingCellType Warning and Error *)
	If[MemberQ[conflictingCellTypeWarnings, True] && messages,
		Module[{captureSentence},
			(* Throw the corresponding warning *)
			captureSentence = Which[
				(* Check if CellPelletIntensity/CryoprotectantSolution is specified or by default *)
				MemberQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeWarnings], None] || !MatchQ[Flatten@PickList[Lookup[mapThreadFriendlyOptions, {CellPelletIntensity, CryoprotectantSolution}], conflictingCellTypeWarnings], {(Automatic|Null)..}],
					"Bacterial and yeast cells require different preparing environment during transfer",
				MemberQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeWarnings], ChangeMedia] && MatchQ[PickList[Lookup[mapThreadFriendlyOptions, CellPelletIntensity], conflictingCellTypeWarnings], {Automatic..}] && MemberQ[PickList[Lookup[mapThreadFriendlyOptions, CryoprotectantSolution], conflictingCellTypeWarnings], Except[Automatic]],
					"Bacterial and yeast cells require slightly different CryoprotectantSolution when changing media",
				MemberQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeWarnings], ChangeMedia] && MatchQ[PickList[Lookup[mapThreadFriendlyOptions, CryoprotectantSolution], conflictingCellTypeWarnings], {Automatic..}] && MemberQ[PickList[Lookup[mapThreadFriendlyOptions, CellPelletIntensity], conflictingCellTypeWarnings], Except[Automatic]],
					"Bacterial and yeast cells require slightly different CellPelletIntensity when changing media",
				MemberQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeWarnings], ChangeMedia],
					"Bacterial and yeast cells require different CellPelletIntensity and CryoprotectantSolution when changing media",
				True,
					"Bacterial and yeast cells require slightly different CryoprotectantSolution"
			];
			Message[
				Warning::ConflictingCellType,
				captureSentence,
				StringJoin[
					Capitalize@samplesForMessages[PickList[mySamples, conflictingCellTypeWarnings], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
					" ",
					hasOrHave[DeleteDuplicates@PickList[mySamples, conflictingCellTypeWarnings]]
				],
				joinClauses[PickList[resolvedCellTypes, conflictingCellTypeWarnings]],
				joinClauses[PickList[sampleCellTypes, conflictingCellTypeWarnings]]
			]
		]
	];

	conflictingCellTypeErrorOptions = If[Or @@ conflictingCellTypeErrors && !gatherTests,
		Module[{captureSentence},
			(* Throw the corresponding error. *)
			captureSentence = Which[
				(* Check if CellPelletIntensity/CryoprotectantSolution is specified or by default *)
				MemberQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeErrors], None] || !MatchQ[Flatten@PickList[Lookup[mapThreadFriendlyOptions, {CellPelletIntensity, CryoprotectantSolution}], conflictingCellTypeErrors], {(Automatic|Null)..}],
					"Mammalian and microbial cells require different preparing environment during transfer",
				MemberQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeErrors], ChangeMedia] && MatchQ[PickList[Lookup[mapThreadFriendlyOptions, CellPelletIntensity], conflictingCellTypeErrors], {Automatic..}] && MemberQ[PickList[Lookup[mapThreadFriendlyOptions, CryoprotectantSolution], conflictingCellTypeErrors], Except[Automatic]],
					"Mammalian and microbial cells require different CryoprotectantSolution when changing media",
				MemberQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeErrors], ChangeMedia] && MatchQ[PickList[Lookup[mapThreadFriendlyOptions, CryoprotectantSolution], conflictingCellTypeErrors], {Automatic..}] && MemberQ[PickList[Lookup[mapThreadFriendlyOptions, CellPelletIntensity], conflictingCellTypeErrors], Except[Automatic]],
					"Mammalian and microbial cells require different CellPelletIntensity when changing media",
				MemberQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeErrors], ChangeMedia],
					"Mammalian and microbial cells require different CellPelletIntensity and CryoprotectantSolution when changing media",
				MatchQ[PickList[resolvedCryoprotectionStrategies, conflictingCellTypeErrors], {None..}],
					"Mammalian and microbial cells require different preparing environment during aliquotting",
				True,
					"Mammalian and microbial cells require different CryoprotectantSolution"
			];
			Message[Error::ConflictingCellType,
				captureSentence,
				StringJoin[
					Capitalize@samplesForMessages[PickList[mySamples, conflictingCellTypeErrors], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
					" ",
					hasOrHave[DeleteDuplicates@PickList[mySamples, conflictingCellTypeErrors]]
				],
				joinClauses[PickList[resolvedCellTypes, conflictingCellTypeErrors]],
				joinClauses[PickList[sampleCellTypes, conflictingCellTypeErrors]]
			];

			(* Return our invalid options. *)
			{CellType}
		],
		{}
	];

	conflictingCellTypeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = PickList[mySamples, conflictingCellTypeWarnings];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The specified CellType(s) for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " matches the CellType information in the sample object(s):", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The specified CellType(s) for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " matches the CellType information in the sample object(s):", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 5. Error::ConflictingCultureAdhesion *)
	(* The specified CultureAdhesion must not conflict with the CultureAdhesion information in Object[Sample]. *)
	(* We have already thrown FreezeCellsNonLiquidSamples so no need to check State and CultureAdhesion conflicts *)
	conflictingCultureAdhesionCases = If[MemberQ[conflictingCultureAdhesionBools, True],
		MapThread[
			If[TrueQ[#3],
				{Lookup[#1, Object], CultureAdhesion, #4, #2},
				Nothing
			]&,
			{samplePackets, resolvedCultureAdhesions, conflictingCultureAdhesionBools, Lookup[samplePackets, CultureAdhesion, {}]}
		],
		{}
	];

	If[!MatchQ[conflictingCultureAdhesionCases, {}] && messages,
		Module[{errorMessage},
			(* Error-type specific error description *)
			errorMessage = StringJoin[
				Capitalize@samplesForMessages[conflictingCultureAdhesionCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
				" ",
				hasOrHave[DeleteDuplicates@conflictingCultureAdhesionCases[[All, 1]]],
				" the CultureAdhesion option specified as ",
				joinClauses[conflictingCultureAdhesionCases[[All, 4]]],
				" while the ",
				joinClauses[conflictingCultureAdhesionCases[[All, 2]]],
				" field detected in the object as ",
				joinClauses[conflictingCultureAdhesionCases[[All, 3]]]
			];
			Message[
				Error::ConflictingCultureAdhesion,
				"The specified CultureAdhesion option should match the values in the CultureAdhesion field",
				errorMessage,
				"the CultureAdhesion field of the sample(s)"
			]
		]
	];

	conflictingCultureAdhesionTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingCultureAdhesionCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The specified CultureAdhesion(s) for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " matches the CultureAdhesion information in the sample object(s):", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The specified CultureAdhesion(s) for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " matches the CultureAdhesion information in the sample object(s):", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 6. CultureAdhesionNotSpecified *)
	(* Throw a warning if the CultureAdhesion is neither specified by the user nor known from the sample object. In these cases, we default to Suspension. *)
	If[Or @@ cultureAdhesionNotSpecifiedBools && messages && notInEngine,
		Module[{reasonClause, actionClause},
			reasonClause =StringJoin[
				Capitalize@samplesForMessages[PickList[mySamples, cultureAdhesionNotSpecifiedBools], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
				" ",
				hasOrHave[DeleteDuplicates@PickList[mySamples, cultureAdhesionNotSpecifiedBools]]
			];
			actionClause = StringJoin[
				"For ",
				pluralize[DeleteDuplicates@PickList[mySamples, cultureAdhesionNotSpecifiedBools], "this sample, ", "these samples, "],
				"the CultureAdhesion option will default to Suspension"
			];
			Message[
				Warning::CultureAdhesionNotSpecified,
				"ExperimentFreezeCells only supports Suspension cell samples",
				reasonClause,
				actionClause
			]
		]
	];
	(* Create the corresponding test for the invalid options. *)
	cultureAdhesionNotSpecifiedTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, cultureAdhesionNotSpecifiedBools];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CultureAdhesion specified (as an option or in the Model)", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs] > 0,
				Warning["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ", have a CultureAdhesion specified (as an option or in the Model)", True, True],
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


	(* 7. Get whether the input culture adhesions are supported *)
	(* Determine the CultureAdhesion of all the input samples.  *)
	sampleCultureAdhesions = MapThread[
		Function[{samplePacket, mainCellIdentityModel},
			Which[
				MatchQ[Lookup[samplePacket, CultureAdhesion], CultureAdhesionP],
					Lookup[samplePacket, CultureAdhesion],
				MatchQ[mainCellIdentityModel, ObjectP[Model[Cell]]],
					fastAssocLookup[fastAssoc, mainCellIdentityModel, CultureAdhesion],
				True,
					Null
			]
		],
		{samplePackets, mainCellIdentityModels}
	];

	(* Any CultureAdhesion which is not Suspension is not currently supported because we don't have DissociateCells yet. *)
	invalidCultureAdhesionSamples = PickList[mySamples, resolvedCultureAdhesions, Adherent|SolidMedia];

	(* Distinguish whether the Suspension value is inherited from Object or from specified option *)
	unsupportedCellCultureTypeCases = MapThread[
		Which[
			MatchQ[#3, Adherent|SolidMedia], {#1, CultureAdhesion},
			MatchQ[#2, Adherent|SolidMedia], {#1, Object},
			True, Nothing
		]&,
		{mySamples, sampleCultureAdhesions, Lookup[expandedSuppliedOptions, CultureAdhesion]}
	];

	If[!MatchQ[invalidCultureAdhesionSamples, {}] && messages,
		Module[{groupedErrorDetails, errorClause},
			(* Group by how CultureAdhesion is determined *)
			groupedErrorDetails = GroupBy[unsupportedCellCultureTypeCases, Last];
			(* Return the joined clauses stating what's wrong *)
			errorClause = joinClauses[
				Map[
					StringJoin[
						Capitalize@samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
						" ",
						hasOrHave[DeleteDuplicates@groupedErrorDetails[#][[All, 1]]],
						" non-Suspension cell culture type",
						If[MatchQ[groupedErrorDetails[#][[All, 2]], {Object..}],
							" detected from the CultureAdhesion field of the " <> pluralize[DeleteDuplicates@groupedErrorDetails[#][[All, 1]], "sample", "samples"],
							" specified for the CultureAdhesion option"
						]
					]&,
					Keys[groupedErrorDetails]
				],
				CaseAdjustment -> True
			];
			Message[
				Error::UnsupportedCellCultureType,
				"ExperimentFreezeCells only supports freezing cells with suspension cell culture type",
				errorClause,
				"Please contact Scientific Solutions team if you have a sample that falls outside current support"
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidCultureAdhesionTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidCultureAdhesionSamples] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[invalidCultureAdhesionSamples, Cache -> cacheBall, Simulation -> simulation] <> " are of supported CultureAdhesions (Suspension):", True, False]
			];

			passingTest = If[Length[invalidCultureAdhesionSamples] == Length[mySamples],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[mySamples, invalidCultureAdhesionSamples], Cache -> cacheBall, Simulation -> simulation] <> " are of supported CultureAdhesions (Suspension):", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* 8. Warning::FreezeCellsUnusedSample *)
	(* Throw a warning to tell the user how much sample will not be frozen under the current conditions. *)
	(* Note: we allow parallel samples (duplicated samples) if we are using AddCryoprotectant and None strategies or Aliquot is False *)
	(* Throw a warning to tell the user how much sample will not be frozen under the current conditions. Allow for up to $MinConsolidationVolume(50 Microliter) *)
	(* to not be frozen; otherwise this would be tripped for rounded values and would be super annoying without adding value. *)
	unusedSampleCases = MapThread[
		Function[{sample, aliquotVolume, totalVolume, index},
			Sequence @@ {
				If[
					And[
						!NullQ[aliquotVolume],
						GreaterQ[Lookup[uniqueSampleToUsedVolLookup, sample], $MinConsolidationVolume]
					],
					{sample, totalVolume, Lookup[uniqueSampleToUsedVolLookup, sample], index},
					Nothing
				]
			}
		],
		{mySamples, resolvedAliquotVolumes, containerInVolumesBeforeAliquoting, Range[Length[mySamples]]}
	];

	If[Length[unusedSampleCases] > 0 && messages && notInEngine,
		Message[
			Warning::FreezeCellsUnusedSample,
			(*1*)StringJoin[
				Capitalize@samplesForMessages[unusedSampleCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
				" ",
				isOrAre[DeleteDuplicates@unusedSampleCases[[All, 1]]]
			],
			(*2*)joinClauses[unusedSampleCases[[All, 2]]],
			(*3*)joinClauses[unusedSampleCases[[All, 3]]]
		]
	];

	unusedSampleTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputsTest, failingInputTest},
			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[unusedSampleCases] > 0,
				Warning["The following samples, " <> ObjectToString[unusedSampleCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation] <> " do not have unused amount by the end of experiment:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[unusedSampleCases] == 0,
				Warning["The following samples, " <> ObjectToString[unusedSampleCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation] <> " do not have unused amount by the end of experiment:", True, True],
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


	(* 9. Error::FreezeCellsConflictingAliquotOptions *)
	(* Throw an error AliquotVolume must be set if and only if Aliquot is True. *)
	conflictingAliquotOptionsCases = MapThread[
		Function[{sample, aliquotVolume, aliquotBool},
			Sequence @@ {
				If[MatchQ[aliquotBool, False] && MatchQ[aliquotVolume, Except[Null]],
					{sample, aliquotVolume, aliquotBool},
					Nothing
				],
				If[MatchQ[aliquotBool, True] && MatchQ[aliquotVolume, Null],
					{sample, aliquotVolume, aliquotBool},
					Nothing
				]
			}
		],
		{mySamples, resolvedAliquotVolumes, resolvedAliquotBools}
	];

	If[Length[conflictingAliquotOptionsCases] > 0 && messages,
		Module[{groupedErrorDetails, reasonClause},
			(* Group by how Aliquot is determined *)
			groupedErrorDetails = GroupBy[conflictingAliquotOptionsCases, Last];
			reasonClause = joinClauses[
				{
					If[MemberQ[Keys[groupedErrorDetails], True],
						StringJoin[
							samplesForMessages[groupedErrorDetails[True][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" ",
							hasOrHave[DeleteDuplicates@groupedErrorDetails[True][[All, 1]]],
							" the Aliquot option set to True while the AliquotVolume option is not specified"
						],
						Nothing
					],
					If[MemberQ[Keys[groupedErrorDetails], False],
						StringJoin[
							samplesForMessages[groupedErrorDetails[False][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" ",
							hasOrHave[DeleteDuplicates@groupedErrorDetails[False][[All, 1]]],
							" the Aliquot option set to False while the AliquotVolume option is specified"
						],
						Nothing
					]
				},
				CaseAdjustment -> True
			];
			Message[
				Error::FreezeCellsConflictingAliquotOptions,
				reasonClause,
				pluralize[DeleteDuplicates@conflictingAliquotOptionsCases, "this sample", "these samples"]
			]
		]
	];

	conflictingAliquotOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingAliquotOptionsCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if and only if AliquotVolume is not Null:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["Aliquot is True for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if and only if AliquotVolume is not Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 10. Error::InsufficientVolumeForAliquoting *)
	(* Check if any unused volume is lower than 0 Microliter *)
	(* To avoid rounding error, we use 1 Microliter times numberNumberOfReplicates *)
	aliquotVolumeReplicatesMismatchCases = Map[
		Function[{samplePacket},
			If[LessQ[Lookup[uniqueSampleToUsedVolLookup, Lookup[samplePacket, Object]], - correctNumberOfReplicates Microliter],
				Module[{posOfSample, sampleVolumeQuantity},
					posOfSample = Flatten@Position[mySamples, Lookup[samplePacket, Object]];
					(* Set the volume of a sample to 0 Microliters if it is not informed. This will allow us to error out in a predictable way instead of breaking everything. *)
					sampleVolumeQuantity = Which[
						MatchQ[Lookup[samplePacket, Volume], GreaterP[1 Milliliter]],
							SafeRound[Convert[Lookup[samplePacket, Volume], Milliliter], 1 Microliter],
						MatchQ[Lookup[samplePacket, Volume], VolumeP],
							SafeRound[Convert[Lookup[samplePacket, Volume], Microliter], 1 Microliter],
						True,
							0 Microliter
					];
					{Lookup[samplePacket, Object], Flatten@Position[mySamples, Lookup[samplePacket, Object]], resolvedAliquotVolumes[[posOfSample]], numericNumberOfReplicates*Length[posOfSample], sampleVolumeQuantity}
				],
				Nothing
			]
		],
		DeleteDuplicates@samplePackets
	];

	If[!MatchQ[aliquotVolumeReplicatesMismatchCases, {}] && messages,
		Module[{errorDetails, actionClause},
			errorDetails = If[Length[aliquotVolumeReplicatesMismatchCases] > $MaxNumberOfErrorDetails,
				StringJoin[
					Capitalize@samplesForMessages[aliquotVolumeReplicatesMismatchCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
					" have the AliquotVolume option set to ",
					joinClauses[aliquotVolumeReplicatesMismatchCases[[All, 3]]],
					If[correctNumberOfReplicates > 1,
						" and the NumberOfReplicates set to " <> ToString[correctNumberOfReplicates],
						""
					],
					", which exceed the available sample volumes."
				],
				joinClauses[
					Map[
						StringJoin[
							samplesForMessages[ToList@#[[1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" has the AliquotVolume option set to ",
							joinClauses[#[[3]]],
							If[#[[4]] > 1,
								" for a total number of " <> ToString[#[[4]]] <> " cryogenic sample containers",
								" for a single cryogenic sample container"
							],
							", which exceed the available sample volume at ",
							ToString[#[[5]]]
						]&,
						aliquotVolumeReplicatesMismatchCases
					],
					CaseAdjustment -> True
				]
			];
			actionClause = StringJoin[
				pluralize[aliquotVolumeReplicatesMismatchCases[[All, 1]], "For this sample,", "For these samples,"],
				If[correctNumberOfReplicates > 1,
					" please adjust the AliquotVolume and/or the NumberOfReplicates to decrease the amount of sample used in the protocol",
					" please adjust the AliquotVolume to decrease the amount of sample used in the protocol"
				]
			];
			Message[
				Error::InsufficientVolumeForAliquoting,
				errorDetails,
				actionClause
			]
		]
	];

	aliquotVolumeReplicatesMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = aliquotVolumeReplicatesMismatchCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["AliquotVolume is not exceeding for volume of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> ":", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["AliquotVolume is not exceeding for volume of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 11. Error::SupernatantOveraspiratedTransfer *)
	(* Overaspiration checks during media change *)
	overAspirationErrors = DeleteDuplicates@DeleteCases[overAspirationErrors, Null];
	If[!MatchQ[overAspirationErrors, {}] && messages,
		Module[{groupedErrorDetails, errorDetails},
			groupedErrorDetails = GroupBy[overAspirationErrors, Rest];
			errorDetails = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
				StringJoin[
					Capitalize@samplesForMessages[overAspirationErrors[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
					" have the CellPelletSupernatantVolume option set to ",
					joinClauses[overAspirationErrors[[All, 2]]],
					", which exceed the total sample volumes"
				],
				joinClauses[
					Map[
						StringJoin[
							samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" ",
							hasOrHave[groupedErrorDetails[#]],
							" the CellPelletSupernatantVolume option set to ",
							ToString[groupedErrorDetails[#][[All, 2]][[1]]],
							" but only ",
							hasOrHave[groupedErrorDetails[#]],
							" ",
							ToString[groupedErrorDetails[#][[All, 3]][[1]]],
							" at the time of media changing"
						]&,
						Keys[groupedErrorDetails]
					],
					CaseAdjustment -> True
				]
			];
			Message[
				Error::SupernatantOveraspiratedTransfer,
				errorDetails,
				pluralize[overAspirationErrors[[All, 1]], "For this sample", "For these samples"]
			]
		]
	];

	overaspirationTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = overAspirationErrors[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["CellPelletSupernatantVolume is not exceeding for volume of the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> ":", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["CellPelletSupernatantVolume is not exceeding for volume of the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> ":", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 12. Error::CryoprotectantSolutionOverfill *)
	(* The addition of CryoprotectantSolution cannot cause the sample's current container to overfill. *)
	cryoprotectantSolutionOverfillCases = MapThread[
		Function[{sample, cryoprotectantSolutionVolume, overFillSourceInfo, suppliedCryoprotectantSolutionVolume, suppliedSupernatantVolume, sampleVolumeQuantity},
			If[!NullQ[overFillSourceInfo],
				{
					sample,
					cryoprotectantSolutionVolume,
					overFillSourceInfo[[1]],
					overFillSourceInfo[[2]],
					overFillSourceInfo[[3]],
					{
						If[MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP], CryoprotectantSolutionVolume, Nothing],
						If[MatchQ[suppliedSupernatantVolume, VolumeP] && LessQ[suppliedSupernatantVolume, sampleVolumeQuantity], CellPelletSupernatantVolume, Nothing]
					}
				},
				Nothing
			]
		],
		{mySamples, resolvedCryoprotectantSolutionVolumes, overFillSourceErrors, expandedSuppliedCryoprotectantSolutionVolumes, expandedSuppliedSupernatantVolumes, sampleVolumeQuantities}
	];

	If[Length[cryoprotectantSolutionOverfillCases] > 0 && messages,
		Module[{groupedErrorDetails, captureSentence, errorDetails, actionClause},
			groupedErrorDetails = GroupBy[cryoprotectantSolutionOverfillCases, Last];
			captureSentence = Which[
				MatchQ[Keys[groupedErrorDetails], {AddCryoprotectant..}],
					"When preparing frozen cell stocks in situ in the input containers, the volume must remain below 75% of the containers' MaxVolume to account for ice expansion and prevent rupture",
				MatchQ[Keys[groupedErrorDetails], {ChangeMedia..}],
					"When adding CryoprotectantSolution after media removal, the total volume upon addition of CryoprotectantSolution should not overfill the containers",
				True,
					"When preparing frozen cell stocks in situ in the input containers, the volume must remain below 75% of the containers' MaxVolume to account for ice expansion and prevent rupture. And when adding CryoprotectantSolution after media removal for ChangeMedia strategy, the total volume upon addition of CryoprotectantSolution should not overfill the containers"
			];
			errorDetails = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
				StringJoin[
					Capitalize@samplesForMessages[cryoprotectantSolutionOverfillCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
					" have the CryoprotectantSolutionVolume option set to ",
					joinClauses[cryoprotectantSolutionOverfillCases[[All, 2]]],
					", which overfill the containers"
				],
				joinClauses[
					Map[
						StringJoin[
							samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" would have",
							pluralize[DeleteDuplicates@groupedErrorDetails[#][[All, 1]], " a total volume at ", " total volumes at "],
							joinClauses[groupedErrorDetails[#][[All, 3]]],
							If[!MemberQ[#, CellPelletSupernatantVolume],
								"",
								" factoring in the specified CellPelletSupernatantVolume at " <> joinClauses[groupedErrorDetails[#][[All, 2]]]
							],
							" upon addition of CryoprotectantSolution and ",
							pluralize[DeleteDuplicates@groupedErrorDetails[#][[All, 1]], "but the sample container ", "but the sample containers "],
							hasOrHave[DeleteDuplicates@groupedErrorDetails[#][[All, 1]]],
							" MaxVolume at ",
							joinClauses[groupedErrorDetails[#][[All, 4]]]
						]&,
						Keys[groupedErrorDetails]
					],
					CaseAdjustment -> True
				]
			];
			actionClause = StringJoin[
				pluralize[DeleteDuplicates@cryoprotectantSolutionOverfillCases[[All, 1]], "For this sample, ", "For these samples, "],
				If[MemberQ[Flatten@cryoprotectantSolutionOverfillCases, ChangeMedia] && MemberQ[Flatten@cryoprotectantSolutionOverfillCases, CellPelletSupernatantVolume],
					"please either decrease the CryoprotectantSolutionVolume or increase the CellPelletSupernatantVolume",
					"please lower the CryoprotectantSolutionVolume"
				]
			];
			Message[
				Error::CryoprotectantSolutionOverfill,
				captureSentence,
				errorDetails,
				actionClause
			]
		]
	];

	cryoprotectantSolutionOverfillTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = cryoprotectantSolutionOverfillCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["Addition of the CryoprotectantSolutionVolume to the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " does not result in overfilling the sample's current container:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["Addition of the CryoprotectantSolutionVolume to the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " does not result in overfilling the sample's current container:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 13. Error::ExcessiveCryogenicSampleVolume *)
	(* The total volume to be frozen cannot exceed the volume of the CryogenicSampleContainer. *)
	excessiveCryogenicSampleVolumeCases = MapThread[
		Function[{sample, cryogenicVial, specifiedCryogenicVial, overFillDestinationInfo, suppliedAliquotVolume, suppliedCryoprotectantSolutionVolume},
			If[!NullQ[overFillDestinationInfo],
				{
					sample,
					cryogenicVial,
					overFillDestinationInfo[[1]],
					0.75*overFillDestinationInfo[[2]],
					{
						If[MatchQ[suppliedAliquotVolume, VolumeP|All], AliquotVolume, Nothing],
						If[MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP], CryoprotectantSolutionVolume, Nothing],
						If[MatchQ[specifiedCryogenicVial, ObjectP[]] && LessQ[overFillDestinationInfo[[2]], 4 Milliliter] && MatchQ[Lookup[myOptions, FreezingStrategy], InsulatedCooler|Automatic], CryogenicSampleContainer, Nothing]
					}
				},
				Nothing
			]
		],
		{mySamples, resolvedCryogenicSampleContainers, expandedSuppliedCryogenicSampleContainers, overFillDestinationErrors, expandedSuppliedAliquotVolumes, expandedSuppliedCryoprotectantSolutionVolumes}
	];

	excessiveCryogenicSampleVolumeOptions = If[Length[excessiveCryogenicSampleVolumeCases] > 0,
		If[MemberQ[excessiveCryogenicSampleVolumeCases, {ObjectP[], _, _, _, Except[{}]}],
			DeleteDuplicates[Flatten@excessiveCryogenicSampleVolumeCases[[All, 5]]],
			{AliquotVolume, CryogenicSampleContainer}
		],
		{}
	];
	If[Length[excessiveCryogenicSampleVolumeCases] > 0 && messages,
		Module[{groupedErrorDetails, reasonClause, actionClause},
			groupedErrorDetails = GroupBy[excessiveCryogenicSampleVolumeCases, First];
			reasonClause = joinClauses@Map[
				Function[{uniqueSample},
					Module[{groupedOverfillPerSample},
						groupedOverfillPerSample = groupedErrorDetails[uniqueSample];
						StringJoin[
							pluralize[groupedOverfillPerSample, "the cell stock ", "the cell stocks "],
							"being prepared for ",
							samplesForMessages[ToList@uniqueSample, mySamples, Cache -> cacheBall, Simulation -> simulation],
							" would have total ",
							pluralize[groupedOverfillPerSample, "volume of ", "volumes of "],
							joinClauses@groupedOverfillPerSample[[All, 3]],
							" which exceeds 75% of the MaxVolume of the CryogenicSampleContainer ",
							samplesForMessages[groupedOverfillPerSample[[All, 2]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
							" at ",
							joinClauses@groupedOverfillPerSample[[All, 4]],
							" factoring in the specified ",
							pluralize[DeleteDuplicates[DeleteCases[Flatten@groupedOverfillPerSample[[All, 5]], CryogenicSampleContainer]], "option ", "options "],
							joinClauses[DeleteCases[Flatten@groupedOverfillPerSample[[All, 5]], CryogenicSampleContainer]]
						]
					]
				],
				Keys[groupedErrorDetails]
			];
			actionClause = StringRiffle[
				{
					If[EqualQ[correctNumberOfReplicates, 1],
						"Consider using the NumberOfReplicates option to distribute the cell sample(s) across multiple CryogenicSampleContainers.",
						Nothing
					],
					If[MemberQ[excessiveCryogenicSampleVolumeCases, {ObjectP[], _, _, _, Except[{}]}],
						StringJoin[
							"For ",
							pluralize[DeleteDuplicates@Cases[excessiveCryogenicSampleVolumeCases, {ObjectP[], _, _, _, Except[{}]}][[All, 1]], "this sample", "these samples"],
							", please adjust ",
							pluralize[DeleteDuplicates[Flatten@excessiveCryogenicSampleVolumeCases[[All, 5]]], "option ", "options "],
							joinClauses[Flatten@excessiveCryogenicSampleVolumeCases[[All, 5]]],
							" or allow",
							pluralize[DeleteDuplicates@Cases[excessiveCryogenicSampleVolumeCases, {ObjectP[], _, _, _, Except[{}]}][[All, 1]], " the option", " the options"],
							" to be set automatically in order to submit a valid experiment."
						],
						Nothing
					],
					If[And[
						MatchQ[Lookup[myOptions, FreezingStrategy], InsulatedCooler|Automatic],
						MemberQ[Flatten@excessiveCryogenicSampleVolumeCases[[All, 5]], CryogenicSampleContainer]
					],
						"Note that the largest CryogenicVial kept in stock at ECL is Model[Container, Vessel, \"5mL Cryogenic Vial\"], with a MaxVolume of 5 Milliliter.",
						Nothing
					]
				},
				" "
			];
			Message[
				Error::ExcessiveCryogenicSampleVolume,
				reasonClause,
				actionClause
			]
		]
	];

	excessiveCryogenicSampleVolumeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = excessiveCryogenicSampleVolumeCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The volume of sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " to be frozen do not exceed 75% of the max volume of the CryogenicSampleContainer(s):", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The volume of sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " to be frozen do not exceed 75% of the max volume of the CryogenicSampleContainer(s):", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 14. Error::InvalidCryogenicSampleContainer *)
	(* All CryogenicSampleContainers must be a CryogenicVial *)
	(* Note: we have thrown Error::CryogenicVialAliquotingRequired for Aliquot->False cases earlier *)
	unsuitableCryogenicSampleContainerErrors = MapThread[
		Function[{sample, cryogenicSampleContainer, aliquotQ, specifiedCryogenicSampleContainer},
			Module[{cryoVialModelPacket, validCryovialAssoc},
				cryoVialModelPacket = If[MatchQ[cryogenicSampleContainer, ObjectP[Model[Container]]],
					fetchPacketFromFastAssoc[cryogenicSampleContainer, fastAssoc],
					fastAssocPacketLookup[fastAssoc, cryogenicSampleContainer, Model]
				];
				validCryovialAssoc = whyCantThisModelBeCryogenicVial[cryoVialModelPacket];
				(* Check user-specified CryogenicSampleContainer. There are 2 cases: *)
				(* Case1: Aliquot is specified(semi-resolved) to False and input sample container is used as CryogenicSampleContainer *)
				(* Case2: Aliquot is True and CryogenicSampleContainer is directly specified *)
				Which[
					MatchQ[aliquotQ, False] && MatchQ[specifiedCryogenicSampleContainer, Automatic] && !MatchQ[validCryovialAssoc, <||>],
						{sample, cryogenicSampleContainer, validCryovialAssoc, If[MemberQ[Keys[validCryovialAssoc], Model], {Model}, Keys[validCryovialAssoc]]},
					MatchQ[specifiedCryogenicSampleContainer, ObjectP[]] && !MatchQ[validCryovialAssoc, <||>],
						{sample, cryogenicSampleContainer, validCryovialAssoc, If[MemberQ[Keys[validCryovialAssoc], Model], {Model}, Keys[validCryovialAssoc]]},
					True,
						Null
				]
			]
		],
		{mySamples, resolvedCryogenicSampleContainers, resolvedAliquotBools, expandedSuppliedCryogenicSampleContainers}
	];
	unsuitableCryogenicSampleContainerCases = DeleteCases[unsuitableCryogenicSampleContainerErrors, Null];

	If[Length[unsuitableCryogenicSampleContainerCases] > 0 && messages,
		Module[{captureSentence, groupedErrorDetails, reasonClause},
			captureSentence = joinClauses[
				{
					If[MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], Model],
						"acceptable cryogenic vial must correspond to a model that has been pressure-tested for safe handling in cryogenic storage",
						Nothing
					],
					If[MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], ContainerMaterials],
						"glass containers can be unsafe when handled in cryogenic storage due to risk of cracking or shattering",
						Nothing
					],
					Which[
						MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], CoverTypes] && !MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], Footprint|MinTemperature],
							"acceptable cryogenic vial models must feature a secure screw cap",
						MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], MinTemperature|CoverTypes] && !MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], Footprint],
							"acceptable cryogenic vial models must withstand storage at cryogenic temperatures (below -170 Celsius) and feature a secure screw cap",
						!MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], MinTemperature|CoverTypes] && MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], Footprint],
							"acceptable cryogenic vial models must have Footprint as CEVial to be compatible with FreezingRack",
						MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], MinTemperature|CoverTypes] && MemberQ[Flatten@unsuitableCryogenicSampleContainerCases[[All, 4]], Footprint],
							"acceptable cryogenic vial models must withstand storage at cryogenic temperatures, have footprint compatible with freezing rack (CEVial), and feature a secure screw cap",
						True,
							Nothing
					]
				},
				CaseAdjustment -> True
			];
			groupedErrorDetails = GroupBy[unsuitableCryogenicSampleContainerCases, Last];
			reasonClause = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
				StringJoin[
					"For ",
					samplesForMessages[unsuitableCryogenicSampleContainerCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
					", the option CryogenicSampleContainer ",
					isOrAre[DeleteDuplicates@unsuitableCryogenicSampleContainerCases[[All, 1]]],
					" specified as ",
					samplesForMessages[unsuitableCryogenicSampleContainerCases[[All, 2]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
					" which ",
					isOrAre[DeleteDuplicates@unsuitableCryogenicSampleContainerCases[[All, 2]]],
					" not acceptable ",
					pluralize[DeleteDuplicates@unsuitableCryogenicSampleContainerCases[[All, 2]], "cryogenic vial", "cryogenic vials"]
				],
				joinClauses[
					Map[
						Function[{invalidContainerFields},
							StringJoin[
								Capitalize@samplesForMessages[groupedErrorDetails[invalidContainerFields][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
								" ",
								hasOrHave[DeleteDuplicates@groupedErrorDetails[invalidContainerFields][[All, 1]]],
								" the option CryogenicSampleContainer set to ",
								samplesForMessages[groupedErrorDetails[invalidContainerFields][[All, 2]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
								", which ",
								If[MemberQ[invalidContainerFields, Model],
									isOrAre[DeleteDuplicates@groupedErrorDetails[invalidContainerFields][[All, 2]]] <> " missing Model information",
									StringJoin[
										hasOrHave[DeleteDuplicates@groupedErrorDetails[invalidContainerFields][[All, 2]]],
										pluralize[invalidContainerFields, " the field ", " the fields "],
										joinClauses[invalidContainerFields],
										" as ",
										joinClauses@Map[
											joinClauses[Lookup[groupedErrorDetails[invalidContainerFields][[All, 3]], #]]&,
											invalidContainerFields
										]
									]
								]
							]
						],
						Keys[groupedErrorDetails]
					],
					CaseAdjustment -> True
				]
			];
			Message[
				Error::InvalidCryogenicSampleContainer,
				captureSentence,
				reasonClause
			]
		]
	];

	unsuitableCryogenicSampleContainerTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unsuitableCryogenicSampleContainerCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The Model[Container] of the CryogenicSampleContainer specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " is a valid cryogenic vial:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The Model[Container] of the CryogenicSampleContainer specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " is a valid cryogenic vial:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 15. Error::InvalidFreezingRack *)
	unsuitableFreezingRackCases = MapThread[
		Function[{sample, freezingRack, invalidQ, unsuitableList, cryoVial},
			Which[
				TrueQ[invalidQ],
					{sample, Null, Null, freezingRack},
				!MatchQ[unsuitableList, {}],
					{sample, cryoVial, unsuitableList, freezingRack},
				True,
					Nothing
			]
		],
		{mySamples, resolvedFreezingRacks, invalidRackBools, suggestedRackLists, resolvedCryogenicSampleContainers}
	];

	If[Length[unsuitableFreezingRackCases] > 0 && messages,
		Module[{groupedErrorDetails, errorDetails, actionClause},
			groupedErrorDetails = GroupBy[unsuitableFreezingRackCases, Last];
			actionClause = Module[{allowedFreezingRacks},
				allowedFreezingRacks = Which[
					MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
						{Model[Container, Rack, "id:pZx9jo8ZVNW0"]}, (*"2mL Cryo Rack for VIA Freeze"*)
					MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MemberQ[Flatten@unsuitableFreezingRackCases[[All, 3]], ObjectP[]],
						Cases[Flatten@unsuitableFreezingRackCases[[All, 3]], ObjectP[Model[Container, Rack, InsulatedCooler]]],
					True,
						allPossibleFreezingRacks
				];
				StringJoin[
					If[Length[allowedFreezingRacks] > 1 ,
						"a FreezingRack from ",
						"the option FreezingRack as "
					],
					samplesForMessages[allowedFreezingRacks, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation]
				]
			];
			errorDetails = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
				StringJoin[
					"The FreezingRack specified for ",
					samplesForMessages[unsuitableFreezingRackCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
					" are not a suitable rack for cryogenic vials"
				],
				joinClauses[
					Map[
						StringJoin[
							samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" ",
							hasOrHave[groupedErrorDetails[#]],
							" the option FreezingRack specified as ",
							samplesForMessages[groupedErrorDetails[#][[All, 4]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
							", which is not a rack ",
							If[MatchQ[groupedErrorDetails[#][[All, 2]], {Null..}],
								"for cryogenic vials",
								"for CryogenicSampleContainer " <> samplesForMessages[DeleteCases[groupedErrorDetails[#][[All, 2]], Null], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation]
							]
						]&,
						Keys[groupedErrorDetails]
					],
					CaseAdjustment -> True
				]
			];
			Message[
				Error::InvalidFreezingRack,
				errorDetails,
				actionClause
			]
		]
	];

	unsuitableFreezingRackTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unsuitableFreezingRackCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The FreezingRack specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " is a rack for cryogenic samples:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The FreezingRack specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " is not a rack for cryogenic samples:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	resolvedFreezerModels = Map[
		If[MatchQ[#, ObjectP[Object]],
			fetchPacketFromCache[#, Join[staticFreezerModelPackets, controlledRateFreezerModelPackets]],
			#
		]&,
		resolvedFreezers
	];

	(* 16. ConflictingCellFreezingOptions error check *)
	(* This has 2 tiers that will eventually throw different messages: *)
	(* 1. If FreezingStrategy is specified directly by user, and there is conflict with container max volume or options, suggest alternatives. *)
	(* 2. If FreezingStrategy is not specified directly by user but there is conflict with specified options linked to different FreezingStrategy , suggest change options *)


	(* Tier1/2 error *)
	{
		conflictingTemperatureProfileCases,
		conflictingTemperatureProfileTests,
		conflictingInsulatedCoolerFreezingTimeCases,
		conflictingInsulatedCoolerFreezingTimeTests,
		conflictingHardwareCases,
		conflictingHardwareTests,
		conflictingCoolantCases,
		conflictingCoolantTests,
		unsupportedFreezerCases,
		unsupportedFreezerTests,
		conflictingCellFreezingOptions,
		conflictingCellFreezingTests
	} = If[MatchQ[Lookup[myOptions, FreezingStrategy], FreezeCellMethodP],
		(* Tier1 error *)
		Module[
			{
				conflictingTemperatureProfileCase, conflictingTemperatureProfileTest, conflictingInsulatedCoolerFreezingTimeCase,
				conflictingInsulatedCoolerFreezingTimeTest, resolvedFreezingRackModels, conflictingHardwareCase, conflictingHardwareTest,
				conflictingCoolantCase, conflictingCoolantTest, unsupportedFreezerCase, unsupportedFreezerTest
			},
			(* a. FreezeCellsConflictingTemperatureProfile *)
			(* Throw an error is TemperatureProfile is set if while FreezingStrategy is not ControlledRateFreezer, or vice versa. *)
			conflictingTemperatureProfileCase = If[
				Or[
					MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MatchQ[resolvedTemperatureProfile, Null],
					MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MatchQ[resolvedTemperatureProfile, Except[Null]]
				],
				{resolvedFreezingStrategy, resolvedTemperatureProfile},
				{}
			];
	
			If[Length[conflictingTemperatureProfileCase] > 0 && messages,
				Message[
					Error::FreezeCellsConflictingTemperatureProfile,
					ToString[conflictingTemperatureProfileCase[[1]]],
					If[NullQ[conflictingTemperatureProfileCase[[2]]],
						"not specified",
						StringJoin["set to ", ToString[conflictingTemperatureProfileCase[[2]]]]
					]
				]
			];
	
			conflictingTemperatureProfileTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = If[MatchQ[conflictingTemperatureProfileCase, {}], {}, mySamples];
	
					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["A TemperatureProfile is specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if and only if the FreezingStrategy is ControlledRateFreezer:", True, False]
					];
	
					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["A TemperatureProfile is specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if and only if the FreezingStrategy is ControlledRateFreezer:", True, True]
					];
	
					{failingTest, passingTest}
				],
				Null
			];

			(* b. Error::FreezeCellsConflictingInsulatedCoolerFreezingTime *)
			(* InsulatedCoolerFreezingTime must be set if and only if FreezingStrategy is InsulatedCooler. *)
			conflictingInsulatedCoolerFreezingTimeCase = If[
				Or[
					MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MatchQ[resolvedInsulatedCoolerFreezingTime, Null],
					MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MatchQ[resolvedInsulatedCoolerFreezingTime, Except[Null]]
				],
				{resolvedFreezingStrategy, resolvedInsulatedCoolerFreezingTime},
				{}
			];
	
			(* Note: both options are not index-matching so we do not need to loop based on cases *)
			If[MatchQ[Length[conflictingInsulatedCoolerFreezingTimeCase], GreaterP[0]] && messages,
				Message[
					Error::FreezeCellsConflictingInsulatedCoolerFreezingTime,
					ToString[conflictingInsulatedCoolerFreezingTimeCase[[1]]],
					If[NullQ[conflictingInsulatedCoolerFreezingTimeCase[[2]]],
						"not specified",
						StringJoin["set to ", ToString[conflictingInsulatedCoolerFreezingTimeCase[[2]]]]
					]
				]
			];

		conflictingInsulatedCoolerFreezingTimeTest = If[gatherTests,
			Module[{affectedSamples, failingTest, passingTest},
				affectedSamples = If[MatchQ[conflictingInsulatedCoolerFreezingTimeCase, {}], {}, mySamples];

				failingTest = If[Length[affectedSamples] == 0,
					Nothing,
					Test["An InsulatedCoolerFreezingTime is specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if and only if the FreezingStrategy is InsulatedCooler:", True, False]
				];

				passingTest = If[Length[affectedSamples] == Length[mySamples],
					Nothing,
					Test["An InsulatedCoolerFreezingTime is specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if and only if the FreezingStrategy is InsulatedCooler:", True, True]
				];

				{failingTest, passingTest}
			],
			Null
		];

			(* c.Error::FreezeCellsConflictingHardware *)
			(* The FreezingStrategy and Freezer/FreezingRack/CryogenicSampleContainer must be compatible. *)
			resolvedFreezingRackModels = Map[
				If[MatchQ[#, ObjectP[Object]],
					fastAssocLookup[fastAssoc, #, Model],
					#
				]&,
				resolvedFreezingRacks
			];

			conflictingHardwareCase = MapThread[
				Function[{sample, freezer, freezingRack, cryogenicVial, invalidRackQ, invalidCryogenicVialQ, unsuitableCryogenicVialQ},
					Sequence @@ {
						If[
							And[
								MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
								MatchQ[freezer, ObjectP[{Model[Instrument, Freezer], Object[Instrument, Freezer]}]]
							],
							{sample, resolvedFreezingStrategy, freezer, {FreezingStrategy, Freezer}},
							Nothing
						],
						If[
							And[
								MatchQ[resolvedFreezingStrategy, InsulatedCooler],
								MatchQ[freezer, ObjectP[{Model[Instrument, ControlledRateFreezer], Object[Instrument, ControlledRateFreezer]}]]
							],
							{sample, resolvedFreezingStrategy, freezer, {FreezingStrategy, Freezer}},
							Nothing
						],
						(* Note:If invalidRackQ is True, we have thrown InvalidFreezingRack earlier *)
						If[
							And[
								MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
								MatchQ[freezingRack, ObjectP[{Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}]]
							],
							{sample, resolvedFreezingStrategy, freezingRack, {FreezingStrategy, FreezingRack}},
							Nothing
						],
						If[
							And[
								MatchQ[resolvedFreezingStrategy, InsulatedCooler],
								!MatchQ[freezingRack, ObjectP[{Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}]]
							],
							{sample, resolvedFreezingStrategy, freezingRack, {FreezingStrategy, FreezingRack}},
							Nothing
						],
						(* Note:If invalidCryogenicVialQ is NOT Null, we have thrown CryogenicVialAliquotingRequired earlier *)
						(* Similarly, if unsuitableCryogenicVialQ is NOT Null, we have thrown InvalidCryogenicSampleContainerType earlier *)
						If[
							And[
								NullQ[invalidCryogenicVialQ],
								NullQ[unsuitableCryogenicVialQ],
								!TrueQ[invalidRackQ],
								MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
								MatchQ[
									fastAssocLookup[fastAssoc, cryogenicVial, MaxVolume],
									GreaterP[2 Milliliter]
								]
							],
							{sample, cryogenicVial, freezingRack, {CryogenicSampleContainer, FreezingStrategy}},
							Nothing
						]
					}
				],
				{mySamples, resolvedFreezers, resolvedFreezingRackModels, resolvedCryogenicSampleContainers, invalidRackBools, conflictingAliquotingErrors, unsuitableCryogenicSampleContainerErrors}
			];

			If[Length[conflictingHardwareCase] > 0 && messages,
				Module[{captureSentence, groupedErrorDetails, reasonClause},
					groupedErrorDetails = GroupBy[conflictingHardwareCase, Last];
					captureSentence = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
						"The Freezer, FreezingRack, and CryogenicSampleContainer options should be compatible with the FreezingStrategy option",
						StringJoin[
							If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
								"When FreezingStrategy is set to ControlledRateFreezer, ",
								"When FreezingStrategy is set to InsulatedCooler, "
							],
							joinClauses[
								{
									If[MemberQ[Keys[groupedErrorDetails], {FreezingStrategy, Freezer}],
										If[!MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
											StringJoin[
												"only ultra-low temperature freezer ",
												samplesForMessages[{Model[Instrument, Freezer, "id:01G6nvkKr3dA"]}, Cache -> cacheBall, Simulation -> simulation],
												" can be specified for the option Freezer"
											],
											StringJoin[
												"only controlled rate freezer ",
												samplesForMessages[{Model[Instrument, ControlledRateFreezer, "id:kEJ9mqaVPPWz"]}, Cache -> cacheBall, Simulation -> simulation],
												" can be specified for the option Freezer"
											]
										],
										Nothing
									],
									If[MemberQ[Keys[groupedErrorDetails], {FreezingStrategy, FreezingRack}],
										If[!MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
											StringJoin[
												"only insulated cooler racks ",
												samplesForMessages[{Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"], Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]}, Cache -> cacheBall, Simulation -> simulation],
												" can be specified for the option FreezingRack"
											],
											"only " <> ObjectToString[Model[Container, Rack, "id:pZx9jo8ZVNW0"], Cache -> cacheBall, Simulation -> simulation] <> " can be specified for the option FreezingRack"
										],
										Nothing
									],
									If[MemberQ[Keys[groupedErrorDetails], {CryogenicSampleContainer, FreezingStrategy}],
										StringJoin[
											"the largest CryogenicSampleContainer that can fit into the controlled rate freezer is ",
											samplesForMessages[{Model[Container, Vessel, "id:vXl9j5qEnnOB"]}, Cache -> cacheBall, Simulation -> simulation],
											" with the MaxVolume at 2 milliliters"
										],
										Nothing
									]
								}
							]
						]
					];
					(* Regroup the error based on the sample *)
					reasonClause = Module[{groupedErrorDetailsPerSample},
						groupedErrorDetailsPerSample = GroupBy[conflictingHardwareCase, First];
						joinClauses[
							Map[
								StringJoin[
									samplesForMessages[groupedErrorDetailsPerSample[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
									" ",
									hasOrHave[DeleteDuplicates@groupedErrorDetailsPerSample[#][[All, 1]]],
									pluralize[DeleteDuplicates@DeleteCases[Flatten[groupedErrorDetailsPerSample[#][[All, 4]]], FreezingStrategy], " the option "," the options "],
									joinClauses[DeleteCases[Flatten[groupedErrorDetailsPerSample[#][[All, 4]]], FreezingStrategy]],
									" conflicting with the option FreezingStrategy"
								]&,
								Keys[groupedErrorDetailsPerSample]
							],
							CaseAdjustment -> True
						]
					];
					Message[
						Error::FreezeCellsConflictingHardware,
						captureSentence,
						reasonClause
					]
				]
			];

			conflictingHardwareTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = conflictingHardwareCase[[All, 1]];
	
					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["The Freezer and FreezingRack for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " are consistent with the FreezingStrategy:", True, False]
					];
	
					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["The Freezer and FreezingRack for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " are consistent with the FreezingStrategy:", True, True]
					];
	
					{failingTest, passingTest}
				],
				Null
			];


			(* d.Error::FreezeCellsConflictingCoolant *)
			(* Coolant must be set if and only if FreezingStrategy is InsulatedCooler. *)
			conflictingCoolantCase = MapThread[
				Function[{sample, coolant},
					Sequence @@ {
						If[MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MatchQ[coolant, Null],
							{sample, coolant, resolvedFreezingStrategy},
							Nothing
						],
						If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MatchQ[coolant, Except[Null]],
							{sample, coolant, resolvedFreezingStrategy},
							Nothing
						]
					}
				],
				{mySamples, resolvedCoolants}
			];

			If[Length[conflictingCoolantCase] > 0 && messages,
				Module[{groupedErrorDetails, errorDetails},
					groupedErrorDetails = GroupBy[conflictingCoolantCase, Last];
					errorDetails = joinClauses[
						Map[
							StringJoin[
								samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
								" ",
								hasOrHave[groupedErrorDetails[#]],
								" the option Coolant ",
								If[MatchQ[groupedErrorDetails[#][[All, 2]], {Null..}],
									" not specified",
									" specified as " <> samplesForMessages[groupedErrorDetails[#][[All, 2]], Cache -> cacheBall, Simulation -> simulation]
								]
							]&,
							Keys[groupedErrorDetails]
						]
					];
					Message[
						Error::FreezeCellsConflictingCoolant,
						ToString[resolvedFreezingStrategy],
						errorDetails
					]
				]
			];

			conflictingCoolantTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = conflictingCoolantCases[[All, 1]];

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["A Coolant is specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if and only if the FreezingStrategy is InsulatedCooler:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["A Coolant is specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if the FreezingStrategy is InsulatedCooler:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];

			(* e. Error::InvalidFreezerModel, *)
			(* Throw an error if the ultra-low temperature freezer instrument has a DefaultTemperature other than -80+- 5 Celsius *)
			unsupportedFreezerCase = If[!MemberQ[ToList[resolvedFreezers], ObjectP[{Object[Instrument, Freezer], Model[Instrument, Freezer]}]],
				{},
				MapThread[
					Function[
						{sample, freezerModel, defaultTemperature},
						Sequence @@ {
							If[
								And[
									MatchQ[resolvedFreezingStrategy, InsulatedCooler],
									!MatchQ[defaultTemperature, RangeP[-85 Celsius, -75 Celsius]]
								],
								{sample, freezerModel, defaultTemperature},
								Nothing
							]
						}
					],
					{mySamples, resolvedFreezers, fastAssocLookup[fastAssoc, #, DefaultTemperature] & /@ resolvedFreezerModels}
				]
			];

			If[MatchQ[Length[unsupportedFreezerCase], GreaterP[0]] && messages,
				Module[{groupedErrorDetails, errorDetails},
					groupedErrorDetails = GroupBy[unsupportedFreezerCase, Rest];
					errorDetails = If[Length[Keys[groupedErrorDetails]] > $MaxNumberOfErrorDetails,
						StringJoin[
							"The Freezer specified for ",
							samplesForMessages[unsupportedFreezerCase[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
							" have DefaultTemperature out of the allowed range"
						],
						joinClauses[
							Map[
								StringJoin[
									samplesForMessages[groupedErrorDetails[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],
									" ",
									hasOrHave[groupedErrorDetails[#]],
									" the option Freezer specified as ",
									samplesForMessages[groupedErrorDetails[#][[All, 2]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
									" with DefaultTemperature ",
									If[MatchQ[groupedErrorDetails[#][[All, 3]], {Null..}],
										" not specified in the model",
										" at " <> ToString[SafeRound[groupedErrorDetails[#][[All, 3]][[1]], 1 Celsius]]
									]
								]&,
								Keys[groupedErrorDetails]
							],
							CaseAdjustment -> True
						]
					];
					Message[
						Error::InvalidFreezerModel,
						errorDetails
					]
				]
			];

			unsupportedFreezerTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = unsupportedFreezerCase[[All, 1]];

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["If the FreezingStrategy is InsulatedCooler, the Freezer for sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " has a DefaultTemperature that is within 5 Celsius of either -80 Celsius:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["If the FreezingStrategy is InsulatedCooler, the Freezer for sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " has a DefaultTemperature that is within 5 Celsius of either -80 Celsius:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];


			(* Return *)
			{
				conflictingTemperatureProfileCase,
				conflictingTemperatureProfileTest,
				conflictingInsulatedCoolerFreezingTimeCase,
				conflictingInsulatedCoolerFreezingTimeTest,
				conflictingHardwareCase,
				conflictingHardwareTest,
				conflictingCoolantCase,
				conflictingCoolantTest,
				unsupportedFreezerCase,
				unsupportedFreezerTest,
				{},
				{}
			}
		],
		(* Tier2 error *)
		Module[
			{
				whyCantIPickThisFreezingStrategy, specifiedOrInsituCryogenicSampleContainers, specifiedAliquotVolumes,
				specifiedCryoprotectantSolutionPerCopy, conflictingCellFreezingCase, captureSentence, reasonClause, actionClause, conflictingCellFreezingTest
			},
			whyCantIPickThisFreezingStrategy[
				desiredFreezingStrategy: FreezeCellMethodP,
				userOptions: {(_Rule)...},
				semiResolvedCryogenicSampleContainers: {(ObjectP[{Model[Container], Object[Container]}]|Automatic)..},
				semiResolvedAliquotVolumes: {(VolumeP|Automatic|Null)..},
				semiResolvedCryoprotectantSolutionVolumes: {(VolumeP|Automatic|Null)..}
			] := Module[
				{
					controlledRateSpecificOptions, insulatedCoolerSpecificOptions, insulatedCoolerVolumeOptions, allAliquotVolumeInNewContainers,
					allCryoprotectantSolutionVolumeInNewContainers, dualStrategyOptions, cryogenicSampleContainerModelsOptions,
					allCryogenicSampleContainerModels, userSpecifiedKeys, userSpecifiedControlledRateKeys, userSpecifiedInsulatedCoolerKeys,
					validSpecifiedKeys, invalidSpecifiedKeys
				},
				controlledRateSpecificOptions = {TemperatureProfile};
				insulatedCoolerSpecificOptions = {InsulatedCoolerFreezingTime, Coolant};
				insulatedCoolerVolumeOptions = {AliquotVolume, CryoprotectantSolutionVolume};
				allAliquotVolumeInNewContainers = Flatten@MapThread[
					Function[{aliquotQ, specifiedAliquotVolume},
						If[!MatchQ[aliquotQ, False] && MatchQ[specifiedAliquotVolume, VolumeP|Automatic],
							Cases[specifiedAliquotVolume, GreaterP[1.5 Milliliter]],
							{}
						]
					],
					{Lookup[userOptions, Aliquot], semiResolvedAliquotVolumes}
				];
				allCryoprotectantSolutionVolumeInNewContainers = Flatten@MapThread[
					Function[{aliquotQ, specifiedCryoprotectantSolutionVolume, specifiedAliquotVolume},
						If[!MatchQ[aliquotQ, False] && MatchQ[specifiedAliquotVolume, VolumeP|Automatic],
							Cases[specifiedCryoprotectantSolutionVolume, GreaterP[1.5 Milliliter]],
							{}
						]
					],
					{Lookup[userOptions, Aliquot], semiResolvedCryoprotectantSolutionVolumes, semiResolvedAliquotVolumes}
				];
				dualStrategyOptions = {Freezer, FreezingRack};
				cryogenicSampleContainerModelsOptions = {Aliquot, CryogenicSampleContainer};
				allCryogenicSampleContainerModels = Map[
					Which[
						MatchQ[#, Automatic],
							Automatic,
						MatchQ[#, ObjectP[Model]],
							#,
						MatchQ[#, ObjectP[Object]] && MatchQ[fastAssocLookup[fastAssoc, #, Model], ObjectP[Model]],
							fastAssocLookup[fastAssoc, #, Model],
						True,
							Automatic
					]&,
					semiResolvedCryogenicSampleContainers
				];
				(* User input keys *)
				userSpecifiedKeys = Keys[Select[userOptions, MatchQ[Values[#], Except[ListableP[Automatic]]] &]];
				userSpecifiedControlledRateKeys = Map[
					Which[
						MatchQ[#, Alternatives @@ controlledRateSpecificOptions] && MatchQ[Lookup[userOptions, #], Except[Null]],
							#,
						MatchQ[#, Alternatives @@ insulatedCoolerSpecificOptions] && MatchQ[Lookup[userOptions, #], Null],
							#,
						MatchQ[#, Alternatives @@ dualStrategyOptions],
							Which[
								MatchQ[#, Freezer],
									If[MemberQ[ToList@Lookup[userOptions, Freezer], ObjectP[{Model[Instrument, ControlledRateFreezer], Object[Instrument, ControlledRateFreezer]}]],
										#,
										Nothing
									],
								MatchQ[#, FreezingRack],
									(* InvalidFreezingRack has checked if normal rack is selected, here we only check if insulated cooler has been specified *)
									If[MemberQ[ToList@Lookup[userOptions, FreezingRack], Except[Automatic|ObjectP[{Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}]]],
										#,
										Nothing
									],
								True,
									Nothing
							],
						True,
							Nothing
					]&,
					userSpecifiedKeys
				];
				userSpecifiedInsulatedCoolerKeys = Map[
					Which[
						MatchQ[#, Alternatives @@ insulatedCoolerSpecificOptions] && MatchQ[Lookup[userOptions, #], Except[Null]],
							#,
						MatchQ[#, Alternatives @@ controlledRateSpecificOptions] && MatchQ[Lookup[userOptions, #], Null],
							#,
						MatchQ[#, Alternatives @@ dualStrategyOptions],
							Which[
								MatchQ[#, Freezer],
									If[MemberQ[ToList@Lookup[userOptions, Freezer], ObjectP[{Model[Instrument, Freezer], Object[Instrument, Freezer]}]],
										#,
										Nothing
									],
								MatchQ[#, FreezingRack],
									If[MemberQ[ToList@Lookup[userOptions, FreezingRack], ObjectP[{Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}]],
										#,
										Nothing
									],
								True,
									Nothing
							],
						MatchQ[#, Alternatives @@ cryogenicSampleContainerModelsOptions],
							If[MemberQ[allCryogenicSampleContainerModels, ObjectP[Model[Container, Vessel, "id:o1k9jAG1Nl57"]]],(* Model[Container, Vessel, "5mL Cryogenic Vial"] *)
								#,
								Nothing
							],
						MatchQ[#, AliquotVolume],
							If[!MatchQ[allAliquotVolumeInNewContainers, {}],
								#,
								Nothing
							],
					MatchQ[#, CryoprotectantSolutionVolume],
						If[!MatchQ[allCryoprotectantSolutionVolumeInNewContainers, {}],
							#,
							Nothing
						],
						True,
							Nothing
					]&,
					userSpecifiedKeys
				];
				validSpecifiedKeys = If[MatchQ[desiredFreezingStrategy, ControlledRateFreezer],
					userSpecifiedControlledRateKeys,
					userSpecifiedInsulatedCoolerKeys
				];
				invalidSpecifiedKeys = If[MatchQ[desiredFreezingStrategy, ControlledRateFreezer],
					userSpecifiedInsulatedCoolerKeys,
					userSpecifiedControlledRateKeys
				];
				(* Output a pair of {options, options} *)
				If[MatchQ[invalidSpecifiedKeys, {}],
					{},
					{validSpecifiedKeys, invalidSpecifiedKeys}
				]
			];
			specifiedOrInsituCryogenicSampleContainers = MapThread[
				Which[
					MatchQ[#1, ObjectP[]],
						#1,
					MatchQ[#2, False],
						Lookup[#3, Object],
					True,
						Automatic
				]&,
				{expandedSuppliedCryogenicSampleContainers, specifiedAliquotQs, sampleContainerPackets}
			];
			specifiedAliquotVolumes = MapThread[
				Which[
					MatchQ[#1, VolumeP], #1,
					MatchQ[#1, All], #3,
					True, #1
				]&,
				{expandedSuppliedAliquotVolumes, specifiedAliquotQs, sampleVolumeQuantities}
			];
			(* For changeMedia, we need to divide the CryoprotectantSolution by the copies of frozen stock generated since *)
			(* CryoprotectantSolution is added directly to input sample container, then the resuspended sample is aliquoted out with aliquot volume *)
			(* so CryoprotectantSolutionVolume is not directly-relevant to determine the CryogenicSampleContainer *)
			specifiedCryoprotectantSolutionPerCopy = MapThread[
				If[MatchQ[#2, Except[AddCryoprotectant]], Null, #1]&,
				{expandedSuppliedCryoprotectantSolutionVolumes, resolvedCryoprotectionStrategies}
			];
			conflictingCellFreezingCase = whyCantIPickThisFreezingStrategy[
				resolvedFreezingStrategy,
				myOptions,
				specifiedOrInsituCryogenicSampleContainers,
				specifiedAliquotVolumes,
				specifiedCryoprotectantSolutionPerCopy
			];
			captureSentence = If[MatchQ[conflictingCellFreezingCase, {}],
				Null,
				Module[{appliesOnlyWithInsulatedCooler, appliesOnlyWithControlledRateFreezer},
					(* we will have two versions in the list, {short version, long version} for some of the cases *)
					appliesOnlyWithInsulatedCooler = {
						If[MemberQ[Flatten@conflictingCellFreezingCase, Aliquot|CryogenicSampleContainer|AliquotVolume|CryoprotectantSolutionVolume],
							ConstantArray[ObjectToString[Model[Container, Vessel, "5mL Cryogenic Vial"]], 2],
							Nothing
						],
						If[MemberQ[Flatten@conflictingCellFreezingCase, InsulatedCoolerFreezingTime],
							{"the option InsulatedCoolerFreezingTime", "the option InsulatedCoolerFreezingTime defines the minimum duration inside of an ultra-low temperature freezer and"},
							Nothing
						],
						If[MemberQ[Flatten@conflictingCellFreezingCase, Coolant],
							{"the option Coolant", "the option Coolant defines the liquid that fills the chamber of an insulated cooler and"},
							Nothing
						],
						If[And[
								MemberQ[Flatten@conflictingCellFreezingCase, Freezer],
								Or[
									MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MemberQ[conflictingCellFreezingCase[[1]], Freezer],
									MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MemberQ[conflictingCellFreezingCase[[2]], Freezer]
								]
							],
							ConstantArray["ultra-low temperature freezer as Freezer", 2],
							Nothing
						],
						If[And[
								MemberQ[Flatten@conflictingCellFreezingCase, FreezingRack],
								Or[
									MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MemberQ[conflictingCellFreezingCase[[1]], FreezingRack],
									MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MemberQ[conflictingCellFreezingCase[[2]], FreezingRack]
								]
							],
							ConstantArray["insulated cooler racks as FreezingRack", 2],
							Nothing
						]
					};
					appliesOnlyWithControlledRateFreezer = {
						If[MemberQ[Flatten@conflictingCellFreezingCase, TemperatureProfile],
							{"the option TemperatureProfile", "the option TemperatureProfile defines the cooling program of a controlled rate freezer and"},
							Nothing
						],
						If[And[
								MemberQ[Flatten@conflictingCellFreezingCase, Freezer],
								Or[
									MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MemberQ[conflictingCellFreezingCase[[1]], Freezer],
									MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MemberQ[conflictingCellFreezingCase[[2]], Freezer]
								]
							],
							ConstantArray["controlled rate freezer as Freezer", 2],
							Nothing
						],
						If[And[
							MemberQ[Flatten@conflictingCellFreezingCase, FreezingRack],
							Or[
								MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MemberQ[conflictingCellFreezingCase[[2]], FreezingRack],
								MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MemberQ[conflictingCellFreezingCase[[1]], FreezingRack]
							]
						],
							ConstantArray["Model[Instrument, ControlledRateFreezer, \"VIA Freeze Research\"] as FreezingRack", 2],
							Nothing
						]
					};
					(* Combine the sentences *)
					Which[
						Length[appliesOnlyWithInsulatedCooler] == 0 && Length[appliesOnlyWithControlledRateFreezer] == 0,
							"All cell freezing options should be compatible with the same FreezingStrategy",
						Length[appliesOnlyWithInsulatedCooler] == 0,
							Capitalize@StringJoin[
								If[Length[appliesOnlyWithControlledRateFreezer] == 1,
									joinClauses[appliesOnlyWithControlledRateFreezer[[All, 2]]],(*long version*)
									joinClauses[appliesOnlyWithControlledRateFreezer[[All, 1]]](*short version*)
								],
								" ",
								pluralize[appliesOnlyWithControlledRateFreezer, "applies", "apply"],
								" only for ControlledRateFreezer FreezingStrategy"
							],
						Length[appliesOnlyWithControlledRateFreezer] == 0,
							Capitalize@StringJoin[
								If[Length[appliesOnlyWithInsulatedCooler] == 1,
									joinClauses[appliesOnlyWithInsulatedCooler[[All, 2]]],(*long version*)
									joinClauses[appliesOnlyWithInsulatedCooler[[All, 1]]](*short version*)
								],
								" ",
								pluralize[appliesOnlyWithInsulatedCooler, "applies", "apply"],
								" only for InsulatedCooler FreezingStrategy"
							],
						True,
							Capitalize@StringJoin[
								If[Length[appliesOnlyWithControlledRateFreezer] == 1,
									joinClauses[appliesOnlyWithControlledRateFreezer[[All, 2]]],(*long version*)
									joinClauses[appliesOnlyWithControlledRateFreezer[[All, 1]]](*short version*)
								],
								" ",
								pluralize[appliesOnlyWithControlledRateFreezer, "applies", "apply"],
								" only for ControlledRateFreezer FreezingStrategy, and ",
								If[Length[appliesOnlyWithInsulatedCooler] == 1,
									joinClauses[appliesOnlyWithInsulatedCooler[[All, 2]]],(*long version*)
									joinClauses[appliesOnlyWithInsulatedCooler[[All, 1]]](*short version*)
								],
								" ",
								pluralize[appliesOnlyWithControlledRateFreezer, "applies", "apply"],
								" only for InsulatedCooler FreezingStrategy"
							]
					]
				]
			];
			reasonClause = If[!MatchQ[conflictingCellFreezingCase, {}],
				Module[{selfConflictingOptions},
					(* Check if there is any index-matching options that are self-conflicting *)
					selfConflictingOptions = Intersection[conflictingCellFreezingCase[[1]], conflictingCellFreezingCase[[2]]];
					Which[
						MatchQ[selfConflictingOptions, {}],
							StringJoin[
								"The specified ",
								pluralize[conflictingCellFreezingCase[[1]], "option ", "options "],
								joinClauses[conflictingCellFreezingCase[[1]]],
								" ",
								isOrAre[conflictingCellFreezingCase[[1]]],
								" valid for the ",
								ToString[resolvedFreezingStrategy],
								" FreezingStrategy,",
								" while the specified ",
								pluralize[conflictingCellFreezingCase[[2]], "option ", "options "],
								joinClauses[conflictingCellFreezingCase[[2]]],
								" ",
								isOrAre[conflictingCellFreezingCase[[2]]],
								" valid for the ",
								ToString[FirstCase[List@@FreezeCellMethodP, Except[resolvedFreezingStrategy]]],
								" FreezingStrategy"
							],
						MatchQ[Sort@conflictingCellFreezingCase[[1]], Sort@selfConflictingOptions] && MatchQ[Sort@conflictingCellFreezingCase[[2]], Sort@selfConflictingOptions],
							StringJoin[
								"The specified ",
								pluralize[selfConflictingOptions, "option ", "options "],
								joinClauses[selfConflictingOptions],
								" ",
								hasOrHave[selfConflictingOptions],
								" conflicting values"
							],
						True,
							joinClauses[{
								If[MatchQ[Sort@conflictingCellFreezingCase[[1]], Sort@selfConflictingOptions],
									Nothing,
									StringJoin[
										"the specified ",
										pluralize[DeleteCases[conflictingCellFreezingCase[[1]], Alternatives@@selfConflictingOptions], "option ", "options "],
										joinClauses[DeleteCases[conflictingCellFreezingCase[[1]], Alternatives@@selfConflictingOptions]],
										" ",
										isOrAre[DeleteCases[conflictingCellFreezingCase[[1]], Alternatives@@selfConflictingOptions]],
										" valid for the ",
										ToString[resolvedFreezingStrategy],
										" FreezingStrategy,"
									]
								],
								If[MatchQ[Sort@conflictingCellFreezingCase[[2]], Sort@selfConflictingOptions],
									Nothing,
									StringJoin[
										"the specified ",
										pluralize[DeleteCases[conflictingCellFreezingCase[[2]], Alternatives@@selfConflictingOptions], "option ", "options "],
										joinClauses[DeleteCases[conflictingCellFreezingCase[[2]], Alternatives@@selfConflictingOptions]],
										" ",
										isOrAre[DeleteCases[conflictingCellFreezingCase[[2]], Alternatives@@selfConflictingOptions]],
										" valid for the ",
										ToString[FirstCase[List@@FreezeCellMethodP, Except[resolvedFreezingStrategy]]],
										" FreezingStrategy, and "
									]
								],
								StringJoin[
									"the specified ",
									pluralize[selfConflictingOptions, "option ", "options "],
									joinClauses[selfConflictingOptions],
									" ",
									hasOrHave[selfConflictingOptions],
									" conflicting values"
								]},
								CaseAdjustment -> True
								]
							]
					]
			];
			actionClause = If[!MatchQ[conflictingCellFreezingCase, {}],
				StringJoin[
					"Please either adjust ",
					pluralize[conflictingCellFreezingCase[[2]], "option ", "options "],
					joinClauses[conflictingCellFreezingCase[[2]]],
					" or allow the ",
					pluralize[conflictingCellFreezingCase[[2]], "option ", "options "],
					"to be set automatically if ",
					ToString[resolvedFreezingStrategy],
					" is desired",
					", or adjust ",
					pluralize[conflictingCellFreezingCase[[1]], "option ", "options "],
					joinClauses[conflictingCellFreezingCase[[1]]],
					" or allow the ",
					pluralize[conflictingCellFreezingCase[[1]], "option ", "options "],
					"to be set automatically if ",
					ToString[FirstCase[List@@FreezeCellMethodP, Except[resolvedFreezingStrategy]]],
					" is desired"
				]
			];
			If[!MatchQ[conflictingCellFreezingCase, {}] && messages,
				Message[
					Error::ConflictingCellFreezingOptions,
					captureSentence,
					reasonClause,
					actionClause
				]
			];
			conflictingCellFreezingTest = If[gatherTests,
				Module[{affectedSamples, failingTest, passingTest},
					affectedSamples = If[MatchQ[conflictingCellFreezingCase, {}], {}, mySamples];

					failingTest = If[Length[affectedSamples] == 0,
						Nothing,
						Test["All cell freezing options specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " are not conflicting:", True, False]
					];

					passingTest = If[Length[affectedSamples] == Length[mySamples],
						Nothing,
						Test["All cell freezing options specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " are not conflicting:", True, True]
					];

					{failingTest, passingTest}
				],
				Null
			];
			(* Return *)
			{
				{},
				{},
				{},
				{},
				{},
				{},
				{},
				{},
				{},
				{},
				conflictingCellFreezingCase,
				conflictingCellFreezingTest
			}
		]
	];


	(* 17. Error::FreezeCellsUnsupportedTemperatureProfile *)
	(* Throw an error if the TemperatureProfile is invalid. This only matters if we are using a ControlledRateFreezer strategy. *)
	unsupportedTemperatureProfileCases = If[
		Or[
			MatchQ[resolvedTemperatureProfile, Null],
			!MemberQ[resolvedFreezers, ObjectP[{Object[Instrument, ControlledRateFreezer], Model[Instrument, ControlledRateFreezer]}]],
			MatchQ[resolvedFreezingStrategy, InsulatedCooler]
		],
		{},
		(* Otherwise, we need to look at the individual legs of the profile and check for 1) cumulative time/temperature points *)
		(* and 2) segments with cooling/heating rates which are too fast for slow for the instrument. *)
		Module[
			{
				fullProfile, fullCelsiusProfile, temperatureDiffs, timeDiffs, nonCumulativeTimeQ, nonCumulativeTempQ, targetTempTooHighQ,
				suggestedCumulativeProfile, controlledRateFreezerModel, minCoolingRate, maxCoolingRate, flaggedEndPoints, flaggedRates
			},

			(* The initial point is always RT at 0 Minutes. Prepend this to the profile from the protocol object, unless the user already inserted this point manually. *)
			fullProfile = If[MatchQ[resolvedTemperatureProfile[[1]][[2]], EqualP[0 Minute]],
				resolvedTemperatureProfile,
				Prepend[resolvedTemperatureProfile, {25 Celsius, 0 Minute}]
			];

			(* If the user input temperature is not in Celsius, or time not in minute, convert them *)
			fullCelsiusProfile = Map[
				{Convert[#[[1]], Celsius], Convert[#[[2]], Minute]}&,
				fullProfile
			];

			(* Get the differences between each of the temperatures and times. *)
			{temperatureDiffs, timeDiffs} = Differences /@ Transpose[fullCelsiusProfile];

			(* If any of these time differences is negative or 0, the user entered the temperature profile incorrectly. *)
			nonCumulativeTimeQ = MemberQ[timeDiffs, LessEqualP[0 Minute]];
			nonCumulativeTempQ = MemberQ[temperatureDiffs, GreaterP[0.1 Celsius]];
			targetTempTooHighQ = GreaterQ[Last[fullCelsiusProfile][[1]], -75 Celsius];

			(* If the times are non-cumulative, try to help the user out and suggest the correct format. *)
			suggestedCumulativeProfile = If[
				nonCumulativeTimeQ,
				Transpose[{
					resolvedTemperatureProfile[[All, 1]],
					Accumulate[resolvedTemperatureProfile[[All, 2]]]
				}],
				{}
			];

			(* Make sure we are dealing with the controlled rate freezer as a Model rather than an Object. *)
			controlledRateFreezerModel = Which[
				MemberQ[resolvedFreezers, ObjectP[Model[Instrument, ControlledRateFreezer]]],
					FirstCase[resolvedFreezers, ObjectP[Model[Instrument, ControlledRateFreezer]]],
				MemberQ[resolvedFreezers, ObjectP[Object[Instrument, ControlledRateFreezer]]],
					fastAssocLookup[fastAssoc, resolvedFreezers[[1]], Model],
				True,
					Model[Instrument, ControlledRateFreezer, "id:kEJ9mqaVPPWz"](*Model[Instrument, ControlledRateFreezer, VIA Freeze Research] *)
			];

			(* Get the MinCoolingRate and MaxCoolingRate of the ControlledRateFreezer instrument. *)
			(* Note that both of these fields are positive numbers. *)
			minCoolingRate = fastAssocLookup[fastAssoc, controlledRateFreezerModel, MinCoolingRate];
			maxCoolingRate = fastAssocLookup[fastAssoc, controlledRateFreezerModel, MaxCoolingRate];

			(* Map over the legs and pick out any problematic ones. Don't run this check if we have already flagged the *)
			(* profile as having incorrect time, since the rates are going to be meaningless if that's the case. *)
			(* This also prevents us from having to worry about dividing by zero: timeDiff = 0 Minute trips nonCumulativeTimeQ *)
			{flaggedEndPoints, flaggedRates} = If[nonCumulativeTimeQ || nonCumulativeTempQ,
				{{}, {}},
				Module[
					{rates},

					(* Divide Temperature differences by Time differences to get the rate, and round all to 0.001 Celsius/Minute *)
					rates = Abs@RoundOptionPrecision[(temperatureDiffs/timeDiffs), (0.001 Celsius/Minute)];

					(* Map over and pull out the problematic legs, along with the rate required and the profile index. *)
					Transpose @ MapThread[
						Function[
							{profileEndPoint, rate},
							If[Or[
								GreaterQ[rate, maxCoolingRate],
								GreaterQ[rate, 0 Celsius/Minute] && LessQ[rate, minCoolingRate],
								MatchQ[minCoolingRate, $Failed],
								MatchQ[maxCoolingRate, $Failed]
							],
								(* If the cooling rate is greater than the max, flag it. *)
								(* If the cooling rate is nonzero but less than the minimum, flag it. *)
								{profileEndPoint, rate},
								(* Otherwise, this leg is fine. *)
								{Null, Null}
							]
						],
						{Rest[fullCelsiusProfile], rates}
					]
				]
			] /. {Null -> Nothing};

			(* Populate the info we need to surface in the error message. *)
			{
				(* If the times are noncumulative, tell the user and suggest what they may have wanted. *)
				If[nonCumulativeTimeQ,
					{NonCumulativeTime, suggestedCumulativeProfile},
					Nothing
				],
				(* If the temperatures are noncumulative, tell the user and suggest what they may have wanted. *)
				If[nonCumulativeTempQ,
					{NonCumulativeTemp, Null},
					Nothing
				],
				(* If the last temperature is too high, tell the user and suggest what they may have wanted. *)
				If[targetTempTooHighQ,
					{TargetTemp, Null},
					Nothing
				],
				(* If any of the rates are outside of the bounds of the instrument, indicate this. *)
				If[GreaterQ[Length[flaggedRates], 0],
					{CoolingRate, {flaggedRates, minCoolingRate, maxCoolingRate, controlledRateFreezerModel}},
					Nothing
				]
			}
		]
	];

	(* Both options are not index-matching *)
	If[!MatchQ[unsupportedTemperatureProfileCases, {}] && messages,
		Module[{captureSentence, errorDetails},
			captureSentence = joinClauses[
				{
					(* If the times are noncumulative, tell the user and suggest what they may have wanted. *)
					If[MemberQ[unsupportedTemperatureProfileCases[[All, 1]], NonCumulativeTime],
						"each time point must represent the total time elapsed since the beginning of the temperature profile rather than the time elapsed from the previous time point",
						Nothing
					],
					If[MemberQ[unsupportedTemperatureProfileCases[[All, 1]], NonCumulativeTemp|TargetTemp],
						"each successive temperature point must be less than or equal to the preceding temperature point with the endpoint in the range of -20 Celsius to -80 Celsius",
						Nothing
					],
					(* If any of the rates are outside of the bounds of the instrument, indicate this. *)
					If[MemberQ[unsupportedTemperatureProfileCases[[All, 1]], CoolingRate],
						StringJoin[
							ObjectToString[FirstCase[unsupportedTemperatureProfileCases, {CoolingRate, _}][[2]][[4]], Cache -> cacheBall, Simulation -> simulation],
							" can only cool at rates between ",
							ToString[FirstCase[unsupportedTemperatureProfileCases, {CoolingRate, _}][[2]][[2]]],
							" and ",
							ToString[FirstCase[unsupportedTemperatureProfileCases, {CoolingRate, _}][[2]][[3]]]
						],
						Nothing
					]
				},
				CaseAdjustment -> True
			];
			errorDetails = joinClauses[
				{
					(* If the times are noncumulative, tell the user and suggest what they may have wanted. *)
					If[MemberQ[unsupportedTemperatureProfileCases[[All, 1]], NonCumulativeTime],
						StringJoin[
							"the specified time components are non-cumulative and it is possible that the following TemperatureProfile is intended: ",
							ToString[FirstCase[unsupportedTemperatureProfileCases, {NonCumulativeTime, _}][[2]]]
						],
						Nothing
					],
					(* If the temperatures are noncumulative, tell the user and suggest what they may have wanted. *)
					If[MemberQ[unsupportedTemperatureProfileCases[[All, 1]], NonCumulativeTemp],
						"the specified temperature components are non-cumulative",
						Nothing
					],
					(* If the last temperature is too high, tell the user and suggest what they may have wanted. *)
					If[MemberQ[unsupportedTemperatureProfileCases[[All, 1]], TargetTemp],
						StringJoin[
						"the last specified temperature component is above -20 Celsius"
						],
						Nothing
					],
					(* If any of the rates are outside of the bounds of the instrument, indicate this. *)
					If[MemberQ[unsupportedTemperatureProfileCases[[All, 1]], CoolingRate],
						StringJoin[
							"the segment(s) of the specified TemperatureProfile require heating or cooling at rates of ",
							joinClauses[FirstCase[unsupportedTemperatureProfileCases, {CoolingRate, _}][[2]][[1]]]
						],
						Nothing
					]
				}
			];
			Message[
				Error::FreezeCellsUnsupportedTemperatureProfile,
				captureSentence,
				errorDetails
			]
		]
	];

	unsupportedTemperatureProfileTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[unsupportedTemperatureProfileCases, {}], {}, mySamples];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["If FreezingStrategy is set to ControlledRateFreezer, the TemperatureProfile specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " does not require cooling at a rate that is unachievable by the Freezer:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["If FreezingStrategy is set to ControlledRateFreezer, the TemperatureProfile specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " does not require cooling at a rate that is unachievable by the Freezer:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 18. Error::FreezeCellsNoCompatibleCentrifuge *)
	(* Throw an error if we need a centrifuge but there are none compatible with the given container and conditions. *)
	noCompatibleCentrifugeCases = If[MatchQ[Length[noCompatibleCentrifugeIndices], GreaterP[0]],
		MapThread[
			Function[{sample, containerModelPacket, intensity},
				Module[{containerModel, possibleCentrifugesForContainer},
					containerModel = Lookup[containerModelPacket, Object, Null];
					possibleCentrifugesForContainer = If[!NullQ[containerModel],
						CentrifugeDevices[
							containerModel,
							Intensity -> Automatic,
							Time -> Automatic,
							Preparation -> Manual,
							Cache -> cacheBall,
							Simulation -> simulation
						],
						{}
					];
					Which[
						NullQ[containerModel],
							{sample, containerModel, intensity, ContainerModel},
						MatchQ[possibleCentrifugesForContainer, {}],
							{sample, containerModel, intensity, Footprint},
						True,
							{sample, intensity, containerModel, CellPelletIntensity}
					]
				]
			],
			{
				mySamples[[noCompatibleCentrifugeIndices]],
				sampleContainerModelPackets[[noCompatibleCentrifugeIndices]],
				resolvedCellPelletIntensities[[noCompatibleCentrifugeIndices]]
			}
		],
		{}
	];

	If[MatchQ[Length[noCompatibleCentrifugeIndices], GreaterP[0]] && messages,
		Module[{captureSentence, groupedErrorDetails, reasonClause, actionClause},
			groupedErrorDetails = GroupBy[DeleteDuplicates@noCompatibleCentrifugeCases, Last];
			captureSentence = joinClauses[
				{
					If[MemberQ[Flatten@noCompatibleCentrifugeCases, Footprint|ContainerModel],
						"ExperimentFreezeCells does not accept intermediate containers during media changing so the input sample containers must have centrifuge-compatible Footprints such as " <> joinClauses[List @@ {Plate, CEVial, MicrocentrifugeTube, Conical15mLTube, Conical50mLTube}, ConjunctionWord -> "or"],
						Nothing
					],
					If[MemberQ[Flatten@noCompatibleCentrifugeCases, CellPelletIntensity],
						"CellPelletCentrifuge can only be operated within the defined MaxRotationRate and MinRotationRate range",
						Nothing
					]
				},
				CaseAdjustment -> True
			];
			reasonClause = joinClauses[
				Map[
					Function[{errorCode},
						Module[{groupedCases},
							groupedCases = Lookup[groupedErrorDetails, Key[errorCode]];
							StringJoin[
								samplesForMessages[groupedCases[[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
								Which[
									MatchQ[errorCode, Footprint],
										pluralize[groupedCases[[All, 1]], " is in a container with Footprint as ", " are in containers with Footprint as "] <> joinClauses[fastAssocLookup[fastAssoc, #, Footprint]& /@groupedCases[[All, 2]]],
									MatchQ[errorCode, ContainerModel],
										pluralize[groupedCases[[All, 1]], " is in a container ", " are in containers "] <> "without model information",
									True,
										" " <> hasOrHave[groupedCases[[All, 1]]] <> " the option CellPelletIntensity set to " <> joinClauses[groupedCases[[All, 2]]]
								],
								If[MatchQ[errorCode, Footprint|ContainerModel],
									"",
									Module[{groupedContainerModels},
										groupedContainerModels = GroupBy[groupedCases, #[[3]]&];
										Map[
											Module[{allCentrifuges, allowedMaxIntensities, allowedMinIntensities},
												allCentrifuges = CentrifugeDevices[
													groupedContainerModels[#][[All, 3]][[1]],
													Intensity -> Automatic,
													Time -> Automatic,
													Preparation -> Manual,
													Cache -> cacheBall,
													Simulation -> simulation
												];
												allowedMaxIntensities = Max[fastAssocLookup[fastAssoc, #, MaxRotationRate]& /@ allCentrifuges];
												allowedMinIntensities = Min[fastAssocLookup[fastAssoc, #, MinRotationRate]& /@ allCentrifuges];
												StringJoin[
													" and the range of centrifuge rotation rate allowed for the container model ",
													samplesForMessages[groupedContainerModels[#][[All, 3]], Cache -> cacheBall, Simulation -> simulation],
													" is from ",
													ToString[allowedMinIntensities],
													" to ",
													ToString[allowedMaxIntensities]
												]
											]&,
											Keys[groupedContainerModels]
										]
									]
								]
							]
						]
					],
					Keys[groupedErrorDetails]
				],
				CaseAdjustment -> True
			];
			actionClause = joinClauses[
				{
					If[MemberQ[Flatten@Keys[groupedErrorDetails], Footprint|ContainerModel],
						"check the \"Preferred Input Containers\" section of the ExperimentFreezeCells helpfile for a list of centrifuge compatible containers and transfer the input sample(s) to the acceptable containers beforehand",
						Nothing
					],
					If[MemberQ[Flatten@Keys[groupedErrorDetails], CellPelletIntensity],
						"adjust the CellPelletIntensity",
						Nothing
					]
				}
			];
			Message[
				Error::FreezeCellsNoCompatibleCentrifuge,
				captureSentence,
				reasonClause,
				actionClause
			]
		]
	];

	noCompatibleCentrifugeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = noCompatibleCentrifugeCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["A compatible centrifuge Model exists for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is ChangeMedia:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["A compatible centrifuge Model exists for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is ChangeMedia:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 19. Error::CellPelletCentrifugeIsIncompatible *)
	(* Throw an error if user specify a centrifuge but it is not compatible with the given container and conditions. *)
	incompatibleCentrifugeCases = If[MatchQ[Length[incompatibleCentrifugeIndices], GreaterP[0]],
		MapThread[
			Function[{sample, containerModelPacket, intensity, centrifuge},
				Module[
					{
						footprint, containerModel, possibleCentrifugesForContainer, possibleCentrifugesForContainerAtSpeed, centrifugeModelPacket,
						minSpeed, MaxSpeed
					},
					footprint = Lookup[containerModelPacket, Footprint];
					containerModel = Lookup[containerModelPacket, Object, Null];
					possibleCentrifugesForContainer = CentrifugeDevices[
						containerModel,
						Intensity -> Automatic,
						Time -> Automatic,
						Preparation -> Manual,
						Cache -> cacheBall,
						Simulation -> simulation
					];
					possibleCentrifugesForContainerAtSpeed = CentrifugeDevices[
						containerModel,
						Intensity -> intensity,
						Time -> Automatic,
						Preparation -> Manual,
						Cache -> cacheBall,
						Simulation -> simulation
					];
					centrifugeModelPacket = If[MatchQ[centrifuge, ObjectP[Model[Instrument]]],
						fetchPacketFromCache[centrifuge, centrifugeModelPackets],
						fastAssocPacketLookup[fastAssoc, centrifuge, Model]
					];
					{minSpeed, MaxSpeed} = Lookup[centrifugeModelPacket, {MinRotationRate, MaxRotationRate}];
					If[MemberQ[possibleCentrifugesForContainer, ObjectP[centrifuge]] && !MemberQ[possibleCentrifugesForContainerAtSpeed, ObjectP[centrifuge]],
						{sample, containerModel, footprint, {minSpeed, MaxSpeed}, {intensity, centrifuge}, CellPelletIntensity},
						{sample, containerModel, footprint, possibleCentrifugesForContainer, {footprint, centrifuge}, CellPelletCentrifuge}
					]
				]
			],
			{
				mySamples[[incompatibleCentrifugeIndices]],
				sampleContainerModelPackets[[incompatibleCentrifugeIndices]],
				resolvedCellPelletIntensities[[incompatibleCentrifugeIndices]],
				resolvedCellPelletCentrifugeModels[[incompatibleCentrifugeIndices]]
			}
		],
		{}
	];

	If[MatchQ[Length[incompatibleCentrifugeIndices], GreaterP[0]] && messages,
		Module[{captureSentence, groupedErrorDetails, reasonClause, actionClause},
			groupedErrorDetails = GroupBy[DeleteDuplicates@incompatibleCentrifugeCases, Last];
			captureSentence = joinClauses[
				{
					If[MemberQ[Flatten@incompatibleCentrifugeCases, CellPelletIntensity],
						"centrifuge can only be operated within the defined MaxRotationRate and MinRotationRate range",
						Nothing
					],
					If[MemberQ[Flatten@incompatibleCentrifugeCases, CellPelletCentrifuge],
						StringJoin[
							"containers with the Footprint of ",
							joinClauses[Flatten@Cases[incompatibleCentrifugeCases, {_, _, currentFootprint_, _, _, CellPelletCentrifuge}:>currentFootprint]],
							" can only be fit in CellPelletCentrifuge ",
							samplesForMessages[Flatten@Cases[incompatibleCentrifugeCases, {_, _, _, listOfCentrifuges_, _, CellPelletCentrifuge}:>listOfCentrifuges], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation]
						],
						Nothing
					]
				},
				CaseAdjustment -> False
			];
			reasonClause = joinClauses[
				Flatten@Map[
					Function[{errorCode},
						Module[{groupedCases, groupedOnValues},
							groupedCases = Most /@ Lookup[groupedErrorDetails, Key[errorCode]];
							groupedOnValues = GroupBy[groupedCases, Last];
							Map[
								StringJoin[
									samplesForMessages[groupedOnValues[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
									" ",
									hasOrHave[DeleteDuplicates@groupedOnValues[#][[All, 1]]],
									" the option CellPelletCentrifuge set to ",
									samplesForMessages[Cases[#, ObjectP[]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
									If[MatchQ[errorCode, CellPelletIntensity],
										" with operating rotation rate from " <> joinClauses[groupedOnValues[#][[All, 4]][[All, 1]]] <> " to " <> joinClauses[groupedOnValues[#][[All, 4]][[All, 2]]],
										""
									],
									If[MatchQ[errorCode, CellPelletCentrifuge],
										pluralize[groupedCases[[All, 1]], " but is in a container with Footprint as ", " but are in containers with Footprint of "] <> joinClauses[Cases[#, FootprintP]],
										" and the option CellPelletIntensity set to " <> joinClauses[Cases[#, Except[ObjectP[]]]]
									]
								]&,
								Keys[groupedOnValues]
							]
						]
					],
					Keys[groupedErrorDetails]
				],
				CaseAdjustment -> True
			];
			actionClause = joinClauses[
				Flatten@Map[
					Function[{errorCode},
						Module[{groupedCases, groupedOnValues},
							groupedCases = Most /@ Lookup[groupedErrorDetails, Key[errorCode]];
							groupedOnValues = GroupBy[groupedCases, Last];
							Map[
								StringJoin[
									"for ",
									samplesForMessages[groupedOnValues[#][[All, 1]], mySamples, Cache -> cacheBall, Simulation -> simulation],(* Collapse the samples *)
									If[MatchQ[errorCode, CellPelletIntensity],
										", please adjust the CellPelletIntensity",
										", please specify an alternative centrifuge such as " <> samplesForMessages[groupedOnValues[#][[All, 4]][[1]], CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation]
									]
								]&,
								Keys[groupedOnValues]
							]
						]
					],
					Keys[groupedErrorDetails]
				],
				CaseAdjustment -> True
			];
			Message[
				Error::CellPelletCentrifugeIsIncompatible,
				captureSentence,
				reasonClause,
				actionClause
			]
		]
	];

	incompatibleCentrifugeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = noCompatibleCentrifugeCases[[All, 1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The specified centrifuge is compatible with the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is ChangeMedia:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The specified centrifuge is compatible with the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if the CryoprotectionStrategy is ChangeMedia:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	
	(* 20. Error::ConflictingChangeMediaOptionsForSameContainer *)
	(* Gather the samples that are in the same container together with their options *)
	groupedSamplesContainersAndOptions = GatherBy[
		Transpose[{mySamples, sampleContainerPackets, resolvedMapThreadOptions}],
		#[[2]]&
	];

	(* Get the options that are not the same across the board for each container *)
	inconsistentOptionsPerContainer = Map[
		Function[{samplesContainersAndOptions},
			(* If some samples in the container have ChangeMedia strategy, some do not, we have thrown error in earlier *)
			If[MemberQ[Lookup[samplesContainersAndOptions[[All, 3]], CryoprotectionStrategy], Except[ChangeMedia]],
				{},
				Map[
					Function[{optionToCheck},
						If[SameQ @@ Lookup[samplesContainersAndOptions[[All, 3]], optionToCheck],
							Nothing,
							optionToCheck
						]
					],
					indexMatchingChangeMediaOptionNames
				]
			]
		],
		groupedSamplesContainersAndOptions
	];

	(* Get the samples that have conflicting options for the same container *)
	(* Do not include samples in DuplicatedSamples invalid inputs *)
	samplesWithSameContainerConflictingOptions = MapThread[
		Function[{samplesContainersAndOptions, inconsistentOptions},
			If[MatchQ[inconsistentOptions, {}],
				{},
				Cases[samplesContainersAndOptions[[All, 1]], Except[ObjectP[Join[duplicatedSampleInputs, conflictingCryoprotectionStrategySamples]]]]
			]
		],
		{groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer}
	];
	samplesWithSameContainerConflictingErrors = Not[MatchQ[#, {}]]& /@ samplesWithSameContainerConflictingOptions;

	(* Throw an error if we have these same-container samples with different options specified *)
	(* Here we use the new recommended error message format where we expand the error message instead of using index *)
	(* The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
	conflictingPelletOptionsForSameContainerOptions = If[MemberQ[samplesWithSameContainerConflictingErrors, True] && messages,
		(
			Message[
				Error::ConflictingChangeMediaOptionsForSameContainer,
				joinClauses[
					MapThread[
						StringJoin[
							samplesForMessages[#1, mySamples, Cache -> cacheBall, Simulation -> simulation],
							" have different cell pellet setting(s): ",
							joinClauses@#2,
							", but are in the same container as other sample(s)"
						]&,
						{
							PickList[samplesWithSameContainerConflictingOptions, samplesWithSameContainerConflictingErrors],
							PickList[inconsistentOptionsPerContainer, samplesWithSameContainerConflictingErrors]
						}
					],
					CaseAdjustment -> True
				],
				"either transfer to separate containers, allow the cell pelleting in individual containers, or ensure that all samples in the same container have identical cell pellet settings"
			];
			DeleteDuplicates[Flatten[inconsistentOptionsPerContainer]]
		),
		{}
	];
	conflictingPelletOptionsForSameContainerTests = If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs, passingInputs, passingInputsTest, failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs = PickList[mySamples, samplesWithSameContainerConflictingErrors];

			(* Get the inputs that pass this test. *)
			passingInputs = Complement[mySamples, failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest = If[Length[failingInputs]>0,
				Test["The following samples, " <> ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation] <> ",have the same cell pellet options as all other samples in the same container:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, " <> ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation] <> ",have the same cell pellet options as all other samples in the same container:", True, True],
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


	(* 21. Error::TooManyControlledRateFreezerBatches *)
	(* We don't allow more than one ControlledRateFreezer freezing batch per protocol due to equipment constraints and timing challenges. *)
	(* Since all of the options associated with this FreezingStrategy are non-index matching, we only have to check if we're exceeding 48 samples. *)
	tooManyControlledRateFreezerBatches = If[
		MatchQ[numericNumberOfReplicates * Length[mySamples], GreaterP[48]] && MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		{resolvedNumberOfReplicates, Length[DeleteDuplicates@mySamples], numericNumberOfReplicates * Length[mySamples], Length[PartitionRemainder[Range[numericNumberOfReplicates * Length[mySamples]], 48]]},
		{}
	];

	If[MatchQ[Length[tooManyControlledRateFreezerBatches], GreaterP[0]] && messages,
		Message[
			Error::TooManyControlledRateFreezerBatches,
			tooManyControlledRateFreezerBatches[[1]],
			tooManyControlledRateFreezerBatches[[2]],
			tooManyControlledRateFreezerBatches[[3]],
			tooManyControlledRateFreezerBatches[[4]]
		];
	];

	tooManyControlledRateFreezerBatchesTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[tooManyControlledRateFreezerBatches, {}], {}, mySamples];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["No more than one batch of samples is to be frozen per protocol " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if FreezingStrategy is ControlledRateFreezer:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["No more than one batch of samples is to be frozen per protocol " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if FreezingStrategy is ControlledRateFreezer:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];


	(* 22. Error::TooManyInsulatedCoolerBatches *)
	(* We're not allowing more than three batches per protocol for InsulatedCooler methods due to equipment constraints and timing challenges. *)
	tooManyInsulatedCoolerBatches = If[
		(* If the FreezingStrategy is ControlledRateFreezer, skip all of this. *)
		MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		{},
		Module[
			{
				relevantConditionSets, relevantConditionSetsTallied, relevantConditionSetCounts, samplesPerRack, freezingRacks,
				numberOfPositionsByRack, partitionedSampleCountsPerConditionSet
			},

			(* Start by gathering all of the resolved conditions that can't differ within the same InsulatedCooler freezing batch. *)
			relevantConditionSets = Transpose[{
				resolvedFreezers,
				resolvedFreezingRacks,
				resolvedCoolants
			}];
			(* Tally to delete duplicates and to determine how many of each unique condition set we have. *)
			relevantConditionSetsTallied = Tally[relevantConditionSets];
			(* Get an index-matched list of the Tally counts. *)
			relevantConditionSetCounts = relevantConditionSetsTallied[[All, 2]];
			(* Multiply these counts by the NumberOfReplicates to get the number of samples to be frozen per rack. *)
			samplesPerRack = numericNumberOfReplicates * relevantConditionSetCounts;
			(* Pull out the FreezingRacks. *)
			freezingRacks = Cases[
				Flatten @ relevantConditionSetsTallied,
				ObjectP[{Model[Container, Rack], Object[Container, Rack]}]
			];
			(* Get the number of positions from the rack Models. *)
			numberOfPositionsByRack = fastAssocLookup[fastAssoc, #, NumberOfPositions] & /@ freezingRacks;
			(* For each rack, partition the numberOfSamples into pieces no larger than the rack's number of positions. *)
			partitionedSampleCountsPerConditionSet = Flatten[
				{
					ConstantArray[numberOfPositionsByRack[[#]], Floor[samplesPerRack[[#]] / numberOfPositionsByRack[[#]]]],
					samplesPerRack[[#]] - Floor[samplesPerRack[[#]] / numberOfPositionsByRack[[#]]] * numberOfPositionsByRack[[#]]
				}
				(* We have to get rid of any zeroes to avoid false positives. *)
			] & /@ Range[Length[relevantConditionSetCounts]] /. {0 -> Nothing};
			(* Now assess the number of batches and output the info for the error message if there are more than 3 batches. *)
			If[MatchQ[Length[Flatten[partitionedSampleCountsPerConditionSet]], GreaterP[3]],
				{
					samplesForMessages[freezingRacks, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
					joinClauses@numberOfPositionsByRack,
					Length[relevantConditionSetCounts],
					joinClauses@relevantConditionSetCounts,
					resolvedNumberOfReplicates,
					partitionedSampleCountsPerConditionSet,
					Length[Flatten[partitionedSampleCountsPerConditionSet]]
				},
				{}
			]
		]
	];

	If[!MatchQ[tooManyInsulatedCoolerBatches, {}] && messages,
		Message[
			Error::TooManyInsulatedCoolerBatches,
			tooManyInsulatedCoolerBatches[[1]],
			tooManyInsulatedCoolerBatches[[2]],
			tooManyInsulatedCoolerBatches[[3]],
			tooManyInsulatedCoolerBatches[[4]],
			tooManyInsulatedCoolerBatches[[5]],
			tooManyInsulatedCoolerBatches[[6]],
			tooManyInsulatedCoolerBatches[[7]]
		];
	];

	tooManyInsulatedCoolerBatchesTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[tooManyInsulatedCoolerBatches, {}], {}, mySamples];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["No more than three batches of samples is to be frozen per protocol " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if FreezingStrategy is InsulatedCooler:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["No more than three batches of samples is to be frozen per protocol " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if FreezingStrategy is InsulatedCooler:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(* -- MESSAGE AND RETURN -- *)

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates@Flatten[
		{
			discardedInvalidInputs,
			deprecatedSampleInputs,
			invalidCellTypeSamples,
			duplicatedSampleInputs,
			invalidPlateSampleInputs,
			nonLiquidSampleInvalidInputs
		}
	];
	invalidOptions = DeleteDuplicates[
		Flatten[
			{
				conflictingAliquotingOptions,
				conflictingCellTypeErrorOptions,
				If[!MatchQ[unsupportedCellCultureTypeCases, {}],
					{CultureAdhesion},
					{}
				],
				If[MatchQ[Length[conflictingCultureAdhesionCases], GreaterP[0]],
					{CultureAdhesion},
					{}
				],
				If[MatchQ[Length[conflictingTemperatureProfileCases], GreaterP[0]],
					{TemperatureProfile, FreezingStrategy},
					{}
				],
				If[MatchQ[Length[conflictingInsulatedCoolerFreezingTimeCases], GreaterP[0]],
					{InsulatedCoolerFreezingTime, FreezingStrategy},
					{}
				],
				If[MatchQ[Length[conflictingCoolantCases], GreaterP[0]],
					{Coolant, FreezingStrategy},
					{}
				],
				If[MatchQ[Length[unsupportedTemperatureProfileCases], GreaterP[0]],
					{TemperatureProfile},
					{}
				],
				If[MatchQ[Length[unsuitableCryogenicSampleContainerCases], GreaterP[0]],
					{CryogenicSampleContainer},
					{}
				],
				If[MatchQ[Length[unsuitableFreezingRackCases], GreaterP[0]],
					{FreezingRack},
					{}
				],
				If[MatchQ[Length[conflictingAliquotOptionsCases], GreaterP[0]],
					{Aliquot, AliquotVolume},
					{}
				],
				If[MatchQ[Length[replicatesWithoutAliquotCases], GreaterP[0]],
					{Aliquot, NumberOfReplicates},
					{}
				],
				If[MatchQ[Length[overAspirationErrors], GreaterP[0]],
					{CellPelletSupernatantVolume},
					{}
				],
				insufficientChangeMediaOptions,
				extraneousChangeMediaOptions,
				insufficientCryoprotectantOptions,
				extraneousCryoprotectantOptions,
				conflictingPelletOptionsForSameContainerAcrossSampleOptions,
				conflictingPelletOptionsForSameContainerOptions,
				conflictingCryoprotectionStrategyOptions,
				If[MatchQ[Length[aliquotVolumeReplicatesMismatchCases], GreaterP[0]],
					{AliquotVolume, If[GreaterQ[correctNumberOfReplicates, 1], NumberOfReplicates, Nothing]},
					{}
				],
				If[MatchQ[Length[noCompatibleCentrifugeCases], GreaterP[0]],
					{CellPelletIntensity, CellPelletTime},
					{}
				],
				If[MatchQ[Length[incompatibleCentrifugeIndices], GreaterP[0]],
					{CellPelletIntensity, CellPelletCentrifuge},
					{}
				],
				conflictingPelletOptionsForSameContainerOptions,
				If[MatchQ[Length[conflictingHardwareCases], GreaterP[0]],
					{FreezingStrategy, Freezer, FreezingRack, CryogenicSampleContainer},
					{}
				],
				conflictingCellFreezingOptions,
				excessiveCryogenicSampleVolumeOptions,
				If[MatchQ[Length[tooManyControlledRateFreezerBatches], GreaterP[0]],
					{NumberOfReplicates, FreezingStrategy},
					{}
				],
				If[MatchQ[Length[tooManyInsulatedCoolerBatches], GreaterP[0]],
					{NumberOfReplicates, FreezingStrategy, Freezer, FreezingRack, Coolant},
					{}
				],
				If[MatchQ[Length[cryoprotectantSolutionOverfillCases], GreaterP[0]],
					{CryoprotectantSolutionVolume, CellPelletSupernatantVolume},
					{}
				],
				If[MatchQ[Length[unsupportedFreezerCases], GreaterP[0]],
					{Freezer},
					{}
				]
			}
		]
	];

	allTests = {
		discardedTest,
		deprecatedTest,
		invalidCellTypeTest,
		invalidCultureAdhesionTest,
		duplicateSamplesTest,
		nonLiquidSampleTest,
		missingVolumeTest,
		precisionTests,
		freezeCellsAliquotingRequiredTests,
		conflictingAliquotingTest,
		cellTypeNotSpecifiedTests,
		conflictingCellTypeTest,
		conflictingCultureAdhesionTest,
		cultureAdhesionNotSpecifiedTests,
		conflictingTemperatureProfileTests,
		conflictingInsulatedCoolerFreezingTimeTests,
		conflictingCoolantTests,
		unsupportedTemperatureProfileTest,
		unsuitableCryogenicSampleContainerTest,
		conflictingAliquotOptionsTest,
		replicatesWithoutAliquotTest,
		insufficientChangeMediaOptionsTests,
		extraneousChangeMediaOptionsTests,
		insufficientCryoprotectantOptionsTests,
		extraneousCryoprotectantOptionsTests,
		conflictingPelletOptionsForSameContainerAcrossSampleTests,
		conflictingPelletOptionsForSameContainerTests,
		conflictingCryoprotectionStrategyTests,
		aliquotVolumeReplicatesMismatchTest,
		overaspirationTest,
		noCompatibleCentrifugeTest,
		incompatibleCentrifugeTest,
		conflictingHardwareTests,
		conflictingCellFreezingTests,
		excessiveCryogenicSampleVolumeTest,
		tooManyControlledRateFreezerBatchesTest,
		tooManyInsulatedCoolerBatchesTest,
		cryoprotectantSolutionOverfillTest,
		conflictingCryoprotectantSolutionTemperatureTests,
		unsupportedFreezerTests
	};

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && !gatherTests,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall, Simulation -> simulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && !gatherTests,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Cases[Flatten[allTests], _EmeraldTest]
	}
];

(* ::Subsubsection::Closed:: *)
(* freezeCellsResourcePackets *)


DefineOptions[
	freezeCellsResourcePackets,
	Options :> {
		SimulationOption,
		CacheOption,
		HelperOutputOption
	}
];

freezeCellsResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, myCollapsedResolvedOptions: {___Rule}, ops:OptionsPattern[]] := Module[
	{
		(* Setup *)
		unresolvedOptionsNoHidden, resolvedOptionsNoHidden, mapFriendlyOptions, safeOps, outputSpecification, output,
		gatherTests, messages, cache, simulation, fastAssoc, fastAssocKeysIDOnly, samplePackets, containerPackets, containers,

		(* Singleton Options *)
		resolvedCryoprotectantSolutionTemperature, resolvedFreezingStrategy, resolvedTemperatureProfile, resolvedInsulatedCoolerFreezingTime,
		resolvedNumberOfReplicates, resolvedPreparation, resolvedParentProtocol,

		(* Replicates Expansion *)
		numericNumberOfReplicates, correctedNumberOfReplicates, resolvedCryogenicSampleContainerLabels, expandedSamplesWithReplicates,
		expandedSamplePacketsWithReplicates, expandedSampleContainerPacketsWithReplicates, expandedSampleContainersWithReplicates,
		expandedCellTypes, expandedCultureAdhesions, expandedCryogenicSampleContainers, expandedCryoprotectionStrategies,
		expandedCellPelletCentrifuges, expandedCellPelletTimes, expandedCellPelletIntensities, expandedCellPelletSupernatantVolumes,
		expandedCryoprotectantSolutions, expandedCryoprotectantSolutionVolumes, expandedAliquots, expandedAliquotVolumes,
		expandedFreezingRacks, expandedFreezers, expandedCoolants, expandedSampleVolumes, expandedSamplesOutStorageConditionSymbols,
		expandedCellPelletSupernatantVolumesWithNoAlls, expandedAliquotVolumesWithNoAlls, allOptionsExpandedForReplicates,

		(* Generate Unit Operations *)
		cryoprotectantSolutionToVolumeLookup, cryoprotectantSolutionChillingTime, estimatedProcessingTime, pelletUnitOperation,
		freezingBatches, expandedSampleIndicesByFreezingBatch, freezingRacksByBatch, coolantsByRack, uniqueFreezingRacksByBatch,
		insulatedCoolerContainers, expandedInsulatedCoolerContainers, coolantVolumes, expandedCoolantVolumes, coolantTransferUnitOperation,

		(* Generate Resources *)
		sampleResources, sampleContainerResources, cryoprotectantSolutionResourcesLink, autoclaveCryoprotectantQs,
		insulatedCoolerFreezingConditions, cryogenicGlovesResource, freezerResourcesLink, freezingRackResources, freezingRackResourcesLink,
		freezingCellTime, freezeCellsUnitOperationPackets, allResourceBlobs, fulfillable, frqTests, testsRule, resultRule, protocolID,
		previewRule, optionsRule, nonHiddenOptions, protocolPacket, linkedFreezeCellsUnitOpPackets, checkpoints
	},

	(* Get the collapsed unresolved index-matching options that don't include hidden options *)
	unresolvedOptionsNoHidden = RemoveHiddenOptions[ExperimentFreezeCells, myUnresolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentFreezeCells,
		RemoveHiddenOptions[ExperimentFreezeCells, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	mapFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFreezeCells, KeyDrop[myResolvedOptions, {Simulation, Cache, CryogenicSampleContainerLabel}]];

	(* Get the safe options for this function *)
	safeOps = SafeOptions[freezeCellsResourcePackets, ToList[ops]];

	(* Pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Lookup helper options *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(* Make the fast association *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* Pull out the packets from the fast assoc *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	containerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;
	containers = Lookup[containerPackets, Object];

	(* --- Expansion for Replicates --- *)
	(* Note that the replicates in this experiment do not result in a greater number of SamplesIn, but we still *)
	(* expand the samples initially to preserve index-matching. We need to then expand a particular subset of the index-matched options. *)

	(* Remove Null from the NumberOfReplicates so we can expand options with it. If there are duplicate samples with the same options, *)
	(* Case1: NumberOfReplicates is set to a number. In this case, all options are the same *)
	(* Case2: the same sample go through different option sets. In this case, ChangeMedia can not be specified as CryoprotectionStrategy. *)
	(* Case3: Any combination of case1 and case2 *)
	numericNumberOfReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. Null -> 1;
	(* Check if we have already expanded for replicates, and we set this to 1 such that we don't expand again. *)
	correctedNumberOfReplicates = If[EqualQ[Max[Tally[Transpose@{mySamples, mapFriendlyOptions}][[All, 2]]], 1],
		numericNumberOfReplicates,
		1
	];

	(* Get the resolved CryogenicSampleContainerLabels, which includes all replicates. *)
	resolvedCryogenicSampleContainerLabels = Lookup[myResolvedOptions, CryogenicSampleContainerLabel];

	(* Expand the samples and sample packets according to the number of replicates *)
	expandedSamplesWithReplicates = Flatten[Map[
		ConstantArray[#, correctedNumberOfReplicates]&,
		Download[ToList[mySamples], Object]
	]];
	expandedSamplePacketsWithReplicates = Flatten[Map[
		ConstantArray[#, correctedNumberOfReplicates]&,
		samplePackets
	]];

	(* Do the same for the sample input containers and corresponding container packets *)
	expandedSampleContainersWithReplicates = Flatten[Map[
		ConstantArray[#, correctedNumberOfReplicates]&,
		Download[ToList[containers], Object]
	]];
	expandedSampleContainerPacketsWithReplicates = Flatten[Map[
		ConstantArray[#, correctedNumberOfReplicates]&,
		containerPackets
	]];

	(* We need to expand certain options according to the number of replicates; use the following helper function to do this. *)
	expandForNumReplicates[myOptions:{__Rule}, myOptionNames:{__Symbol}, myNumberOfReplicates_Integer]:=Module[{},
		Map[
			Function[{optionName},
				Flatten[Map[
					ConstantArray[#, myNumberOfReplicates]&,
					Lookup[myOptions, optionName]
				]]
			],
			myOptionNames
		]
	];

	(* Expand the index-matched options by the number of replicates. *)
	{
		expandedCellTypes,
		expandedCultureAdhesions,
		expandedCryogenicSampleContainers,
		expandedCryoprotectionStrategies,
		expandedCellPelletCentrifuges,
		expandedCellPelletTimes,
		expandedCellPelletIntensities,
		expandedCellPelletSupernatantVolumes,
		expandedCryoprotectantSolutions,
		expandedCryoprotectantSolutionVolumes,
		expandedAliquots,
		expandedAliquotVolumes,
		expandedFreezingRacks,
		expandedFreezers,
		expandedCoolants,
		expandedSamplesOutStorageConditionSymbols
	} = expandForNumReplicates[
		myResolvedOptions,
		{
			CellType,
			CultureAdhesion,
			CryogenicSampleContainer,
			CryoprotectionStrategy,
			CellPelletCentrifuge,
			CellPelletTime,
			CellPelletIntensity,
			CellPelletSupernatantVolume,
			CryoprotectantSolution,
			CryoprotectantSolutionVolume,
			Aliquot,
			AliquotVolume,
			FreezingRack,
			Freezer,
			Coolant,
			SamplesOutStorageCondition
		},
		correctedNumberOfReplicates
	];

	(* Round sample volume for calculation later *)
	expandedSampleVolumes = Map[
		SafeRound[Lookup[#, Volume, 0 Microliter], 1 Microliter]&,
		expandedSamplePacketsWithReplicates
	];
	(* Replace any instances of All in the expandedAliquotVolumes with the correct volume quantity. *)
	expandedCellPelletSupernatantVolumesWithNoAlls = MapThread[
		Function[{sampleVolume, supernatantVolume},
			(* If the volume at this index is a volume quantity or Null, leave it as is. *)
			Which[
				MatchQ[supernatantVolume, VolumeP],
					Min[sampleVolume, supernatantVolume],
				MatchQ[supernatantVolume, All],
					(* If it's set to All and it is equal to the sample's input volume. *)
					sampleVolume,
				(* Otherwise it is Null *)
				True,
					supernatantVolume
			]
		],
		{expandedSampleVolumes, expandedCellPelletSupernatantVolumes}
	];

	(* Replace any instances of All in the expandedAliquotVolumes with the correct volume quantity. *)
	expandedAliquotVolumesWithNoAlls = MapThread[
		Function[{sampleVolume, aliquotVolume, supernatantVolume, cryoprotectantVolume, cryoprotectionStrategy},
			Which[
				(* If the volume at this index is a volume quantity or Null, leave it as is. *)
				MatchQ[aliquotVolume, (VolumeP|Null)],
					aliquotVolume,
				(* When using None|AddCryoprotectant strategy, we directly aliquot to CryogenicSampleContainer *)
				MatchQ[cryoprotectionStrategy, None|AddCryoprotectant],
					SafeRound[sampleVolume/numericNumberOfReplicates, 1 Microliter],
				(* When using ChangeMedia strategy, we add Cryoprotectant before aliquoting to CryogenicSampleContainer *)
				True,
					(* Otherwise, it's we have to calculate the resuspended total volume. *)
					SafeRound[
						(sampleVolume - supernatantVolume + cryoprotectantVolume/. Null -> 0 Microliter)/numericNumberOfReplicates,
						1 Microliter
					]
			]
		],
		{
			expandedSampleVolumes,
			expandedAliquotVolumes,
			expandedCellPelletSupernatantVolumesWithNoAlls,
			expandedCryoprotectantSolutionVolumes,
			expandedCryoprotectionStrategies
		}
	];

	(* Get all of the resolved singleton options that we need for the protocol object. *)
	{
		resolvedCryoprotectantSolutionTemperature,
		resolvedFreezingStrategy,
		resolvedTemperatureProfile,
		resolvedInsulatedCoolerFreezingTime,
		resolvedNumberOfReplicates,
		resolvedPreparation,
		resolvedParentProtocol
	} = Lookup[myCollapsedResolvedOptions,
		{
			CryoprotectantSolutionTemperature,
			FreezingStrategy,
			TemperatureProfile,
			InsulatedCoolerFreezingTime,
			NumberOfReplicates,
			Preparation,
			ParentProtocol
		}
	];

	(* Expand all options for replicates as needed. *)
	allOptionsExpandedForReplicates = Join[
		(* The Label option was expanded for number of replicates during option resolutions. *)
		{
			CryogenicSampleContainerLabel -> resolvedCryogenicSampleContainerLabels
		},
		(* Options without index-matching do not need to be expanded for number of replicates. *)
		{
			CryoprotectantSolutionTemperature -> resolvedCryoprotectantSolutionTemperature,
			FreezingStrategy -> resolvedFreezingStrategy,
			TemperatureProfile -> resolvedTemperatureProfile,
			InsulatedCoolerFreezingTime -> resolvedInsulatedCoolerFreezingTime,
			NumberOfReplicates -> Null,(* Change NumberOfReplicates to Null since samples/options have been expanded at this point *)
			Preparation -> resolvedPreparation,
			ParentProtocol -> resolvedParentProtocol,
			Email -> Lookup[myResolvedOptions, Email]
		},
		(* Remaining options were expanded for number of replicates earlier in the resource packets function *)
		{
			CellType -> expandedCellTypes,
			CultureAdhesion -> expandedCultureAdhesions,
			CryogenicSampleContainer -> expandedCryogenicSampleContainers,
			CryoprotectionStrategy -> expandedCryoprotectionStrategies,
			CellPelletCentrifuge -> expandedCellPelletCentrifuges,
			CellPelletTime -> expandedCellPelletTimes,
			CellPelletIntensity -> expandedCellPelletIntensities,
			CellPelletSupernatantVolume -> expandedCellPelletSupernatantVolumesWithNoAlls,
			CryoprotectantSolution -> expandedCryoprotectantSolutions,
			CryoprotectantSolutionVolume -> expandedCryoprotectantSolutionVolumes,
			Aliquot -> expandedAliquots,
			AliquotVolume -> expandedAliquotVolumesWithNoAlls,
			FreezingRack -> expandedFreezingRacks,
			Freezer -> expandedFreezers,
			Coolant -> expandedCoolants,
			SamplesOutStorageCondition -> expandedSamplesOutStorageConditionSymbols
		}
	];

	(* --- Cryoprotectants --- *)
	(* Make a lookup from unique cryoprotectant solutions to the total volume of that resource required. *)
	cryoprotectantSolutionToVolumeLookup = Total /@ GroupBy[
		MapThread[
			Which[
				NullQ[#1],
					Nothing,
				MatchQ[#3, ChangeMedia],
				(* Note:when we have NumberOfReplicates for ChangeMedia, cryoprotectant solution is only added once with CryoprotectantSolutionVolume. *)
					#1 -> #2/correctedNumberOfReplicates,
				True,
					#1 -> #2
			]&,
			{expandedCryoprotectantSolutions, expandedCryoprotectantSolutionVolumes, expandedCryoprotectionStrategies}
		],
		First -> Last
	];
	(* Resolve the CryoprotectantSolutionChillingTime field based on the largest batched CryoprotectantSolutionVolume. *)
	(* NOTE: If CryprotectantSolutions are chilled, we will resource pick a Refrigerator during the procedure. *)
	cryoprotectantSolutionChillingTime = If[
		(* If we're not chilling any cryoprotectant solutions, set this to Null. *)
		MatchQ[resolvedCryoprotectantSolutionTemperature, Except[Chilled]],
		Null,
		(* If we are chilling cryoprotectant solutions, find the one with the largest volume and resolve the time based on that volume. *)
		Module[{largestBatchedCryoprotectantVolume},
			(* Get the largest volume of any batched cryoprotectant solution, ignoring any Nulls. *)
			largestBatchedCryoprotectantVolume = If[!MatchQ[cryoprotectantSolutionToVolumeLookup, <||>],
				Max @ Values[cryoprotectantSolutionToVolumeLookup],
				0 Milliliter
			];
			(* Now resolve the chilling time based on that volume. *)
			Switch[largestBatchedCryoprotectantVolume,
				LessP[10 Milliliter] && GreaterP[0 Milliliter],
					30 Minute,
				RangeP[10 Milliliter, 50 Milliliter],
					1 Hour,
				GreaterP[50 Milliliter],
					2 Hour,
				_,
					5 Minute
			]
		]
	];

	(* Estimate the processing time, which will also serve as the estimated duration of the dangerzone in the procedure. *)
	estimatedProcessingTime = If[
		MatchQ[resolvedFreezingStrategy, InsulatedCooler],
		resolvedInsulatedCoolerFreezingTime + 20 Minute,
		Max[Cases[Flatten@resolvedTemperatureProfile, TimeP]] + 20 Minute
	];

	(* --- Pelleting --- *)

	(* Generate the pellet unit operation(s). ExperimentPellet will do the batching for us. *)
	(* Note:Even if NumberOfReplicates is set to a number, we are pelleting the entire sample together for ChangeMedia strategy *)
	pelletUnitOperation = Module[
		{
			resolvedCellPelletCentrifuges, resolvedCellPelletTimes, resolvedCellPelletIntensities, resolvedCellPelletSupernatantVolumes,
			pelletIndices, uniquePelletSamples, uniquePelletSampleIndices, instrumentForUniqueSamples, intensityForUniqueSamples,
			timeForUniqueSamples, volumeForUniqueSamples
		},

		(* Get the resolved options relevant to pelleting *)
		{
			resolvedCellPelletCentrifuges,
			resolvedCellPelletTimes,
			resolvedCellPelletIntensities,
			resolvedCellPelletSupernatantVolumes
		} = Lookup[
			myResolvedOptions,
			{
				CellPelletCentrifuge,
				CellPelletTime,
				CellPelletIntensity,
				CellPelletSupernatantVolume
			}
		];
		(* Get the indices where pelleting is to occur. *)
		pelletIndices = Sort @ DeleteDuplicates[Flatten[Position[resolvedCellPelletCentrifuges, ObjectP[]]]];

		(* Consolidate pellet sample in case mySamples have been expanded *)
		uniquePelletSamples = DeleteDuplicates[mySamples[[pelletIndices]]];
		(* Get the position of the first index of unique sample *)
		uniquePelletSampleIndices = FirstPosition[mySamples, ObjectP[#]]& /@ uniquePelletSamples;
		instrumentForUniqueSamples = Extract[resolvedCellPelletCentrifuges, uniquePelletSampleIndices];
		intensityForUniqueSamples = Extract[resolvedCellPelletIntensities, uniquePelletSampleIndices];
		timeForUniqueSamples = Extract[resolvedCellPelletTimes, uniquePelletSampleIndices];
		volumeForUniqueSamples = Extract[resolvedCellPelletSupernatantVolumes, uniquePelletSampleIndices];

		(* Generate the Pellet/Centrifuge UO unless we don't have any pelleting to do. *)
		(* In this uo, we perform Centrifuge only. We do not aspirate supernatant or resuspend pellets with Resuspension buffer since *)
		(* to avoid setting up BSC multiple times, we are removing SupernatantVolume and SupernatantDestination and put aspiration into FreezeCellsTransferUnitOperations *)
		(* For Pellet UO, removing supernatant is mandatory, so we are using Centrifuge UO here *)
		If[MatchQ[Length[pelletIndices], GreaterP[0]],
			Centrifuge[
				Sample -> uniquePelletSamples,
				Instrument -> instrumentForUniqueSamples,
				Time -> timeForUniqueSamples,
				Intensity -> intensityForUniqueSamples,
				Preparation -> Manual,
				Aliquot -> False,
				ImageSample -> False,
				MeasureWeight -> False,
				MeasureVolume -> False
			],
			Null
		]
	];

	(* --- Freezing --- *)

	(* Define the FreezingBatches. These will take the form *)
	freezingBatches = Module[
		{indices, indexToConditionsLookup, samplesPerCondition, freezingRacksByCondition, numberOfPositionsByRack},
		(* Get the sample indices including any replicates. *)
		indices = Range[Length[expandedSamplesWithReplicates]];
		(* Make a lookup between the containers and the relevant conditions. *)
		indexToConditionsLookup = GroupBy[
			Transpose @ {
				expandedFreezingRacks, expandedFreezers, expandedCoolants, indices
			},
			Most -> Last
		];
		(* Pull out the FreezingRacks. *)
		samplesPerCondition = Length /@ Values[indexToConditionsLookup];
		(* Get the freezing rack associated with each condition set. *)
		freezingRacksByCondition = Cases[
			Flatten @ Keys[indexToConditionsLookup],
			ObjectP[{Object[Container, Rack], Model[Container, Rack]}]
		];
		(* Get the number of positions from the rack Models. *)
		numberOfPositionsByRack = fastAssocLookup[fastAssoc, #, NumberOfPositions] & /@ freezingRacksByCondition;
		(* Partition vials across racks if we fill any up. *)
		MapThread[
			Function[
				{conditionSet, vialGroup, numberOfSamplesInSet, maxVialsPerRack},
				If[MatchQ[numberOfSamplesInSet, LessEqualP[maxVialsPerRack]],
					(* If there is enough space in the rack for every vial with that condition set, put all of the vials in that rack. *)
					{conditionSet, vialGroup},
					(* Otherwise, split this group of vials over multiple racks of the same Model. *)
					Sequence @@ (
						{conditionSet, vialGroup[[#]]} & /@ PartitionRemainder[Range[numberOfSamplesInSet], maxVialsPerRack]
					)
				]
			],
			{
				Keys[indexToConditionsLookup],
				Values[indexToConditionsLookup],
				samplesPerCondition,
				numberOfPositionsByRack
			}
		]
	];

	(* To make the batched UOs, we need to map back from the labels to the real input samples. *)
	expandedSampleIndicesByFreezingBatch = Module[
		{cryoSampleContainerLabelToInputSampleLookup, batchedCryogenicSampleContainerLabels},
		(* Create a lookup from the expanded sample labels to the expanded samples themselves. *)
		cryoSampleContainerLabelToInputSampleLookup = GroupBy[
			Transpose @ {
				resolvedCryogenicSampleContainerLabels,
				expandedSamplesWithReplicates
			},
			First -> Last
		];
		(* Get the labels which belong to each freezing batch. *)
		batchedCryogenicSampleContainerLabels = freezingBatches[[All,-1]];
		(* Replace each label with its sample index to get all the indices. *)
		Flatten /@ ReplaceAll[batchedCryogenicSampleContainerLabels, cryoSampleContainerLabelToInputSampleLookup]
	];

	(* Pull out the unique racks and coolants we need resources for so they are index-matched. *)
	freezingRacksByBatch = Cases[Flatten @ freezingBatches, ObjectP[{Object[Container, Rack], Model[Container, Rack]}]];
	coolantsByRack = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		ConstantArray[Null, Length[expandedSamplesWithReplicates]], (* This is to avoid breaking the MapThread used to construct the Batched unit ops below. *)
		Cases[Flatten @ freezingBatches, ObjectP[{Object[Sample], Model[Sample]}]]
	];

	(* Replace any Object[Container, Rack] that isn't the first instance of that Object with the Model. We have to do this *)
	(* to avoid duplicating any FreezingRack objects if one if specified but there are too many samples to fit into it. *)
	uniqueFreezingRacksByBatch = MapThread[
		Function[{rack, index, firstPosition},
			Which[
				(* If the rack is given as a Model, leave it as is. *)
				MatchQ[rack, ObjectP[Model[Container]]],
					rack,
				(* If the rack is given as an Object but this is the first instance of that object, leave it as is. *)
				MatchQ[rack, ObjectP[Object[Container]]] && MatchQ[index, firstPosition],
					rack,
				(* If the rack is given as an Object and this is the first instance of that object, replace it with the Model of this rack. *)
				True,
					LinkedObject[fastAssocLookup[fastAssoc, rack, Model]]
			]
		],
		{
			freezingRacksByBatch,
			Range[Length[freezingRacksByBatch]],
			Flatten[FirstPosition[freezingRacksByBatch, ObjectP[#]] & /@ freezingRacksByBatch]
		}
	];

	(* Now that we know what our batches are, resolve the InsulatedCoolerContainers field. *)
	insulatedCoolerContainers = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		(* The controlled rate freezer doesn't need this container. *)
		ConstantArray[Null, Length[expandedSamplesWithReplicates]],
		Map[
			Switch[#,
				ObjectP[Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"]], (* Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"] *)
					Model[Container, Vessel, "id:eGakldJWoGaq"], (* Model[Container, Vessel, "2mL Mr. Frosty Container"] *)
				ObjectP[Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]], (* Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"] *)
					Model[Container, Vessel, "id:pZx9jo8edZx9"] (* Model[Container, Vessel, "5mL Mr. Frosty Container"] *)
			]&,
			uniqueFreezingRacksByBatch
		]
	];

	(* Determine the volume of coolant to be added to each Mr. Frosty container. Note that the 2mL size Mr. Frosty always needs *)
	(* 250 mL coolant regardless of how many samples we put into the rack. Similarly, the 5mL Mr Frosty always needs 500 mL coolant. *)
	coolantVolumes = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		(* The controlled rate freezer doesn't need coolant. *)
		ConstantArray[Null, Length[expandedSamplesWithReplicates]],
		Map[
			Switch[#,
				ObjectP[Model[Container, Vessel, "id:eGakldJWoGaq"]], (* Model[Container, Vessel, "2mL Mr. Frosty Container"] *)
					250 Milliliter,
				ObjectP[Model[Container, Vessel, "id:pZx9jo8edZx9"]], (* Model[Container, Vessel, "5mL Mr. Frosty Container"] *)
					500 Milliliter
			]&,
			insulatedCoolerContainers
		]
	];

	(* Expand the insulated cooler containers and coolant volumes for replicates but use the correct sample indices. *)
	{expandedInsulatedCoolerContainers, expandedCoolantVolumes} = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		(* The controlled rate freezer doesn't need either of these. *)
		{
			ConstantArray[Null, Length[expandedSamplesWithReplicates]],
			ConstantArray[Null, Length[expandedSamplesWithReplicates]]
		},
		Transpose@Map[
			Function[{sampleIndex},
				Module[{batchNumber},
					batchNumber = Position[expandedSampleIndicesByFreezingBatch, _?(MemberQ[#, sampleIndex]&)][[1]];
					{
						Extract[insulatedCoolerContainers, batchNumber],
						Extract[coolantVolumes, batchNumber]
					}
				]
			],
			Range[Length@expandedCoolants]
		]
	];

	(* Generate the transfer UO that adds coolants to the InsulatedCoolerContainers if we're using insulated coolers. *)
	(* Note that this UO handles the resource picking for the InsulatedCoolerContainers and the Coolants. *)
	coolantTransferUnitOperation = If[
		MatchQ[resolvedFreezingStrategy, ControlledRateFreezer], (* The controlled rate freezer doesn't need coolant. *)
		Null,
		Transfer @ {
			Source -> coolantsByRack,
			Destination -> insulatedCoolerContainers,
			Amount -> coolantVolumes,
			ImageSample -> False,
			MeasureWeight -> False,
			MeasureVolume -> False,
			RentDestinationContainer -> True
		}
	];

	(* Prepare the samplesIn resources *)
	sampleResources = Resource[Sample -> #, Name -> ToString[#]]& /@ expandedSamplesWithReplicates;

	(* Prepare the containersIn resources *)
	sampleContainerResources = Resource[Sample -> #, Name -> ToString[#]]& /@ expandedSampleContainersWithReplicates;

	(* Generate the CryoprotectantSolution resources (unless CryoprotectionStrategy is None at all indices). *)
	cryoprotectantSolutionResourcesLink = If[MatchQ[expandedCryoprotectionStrategies, {None..}],
		ConstantArray[Null, Length[expandedSamplesWithReplicates]],
		(* Make resources at the appropriate indices and link them. *)
		(* Generate the resources for each unique solution, preserving any Nulls. *)
		Map[
			If[MatchQ[#, Null],
				Null,
				Link[Resource[Sample -> #, Amount -> 1.1*(#/.cryoprotectantSolutionToVolumeLookup), Name -> ToString[#]]]
			]&,
			expandedCryoprotectantSolutions
		]
	];

	(* Determine which CryoprotectantSolutions should be autoclaved. We won't autoclave anything that contains DMSO *)
	(* because it is dangerous to do so. We also won't autoclave anything marked Sterile -> True because there is no need to. *)
	autoclaveCryoprotectantQs = Map[
		Which[
			(* If we have a Null at this index, there is nothing here to autoclave. *)
			NullQ[#], False,
			(* If the CryoprotectantSolution has Sterile -> True, don't autoclave it. *)
			MatchQ[fastAssocLookup[fastAssoc, #, Sterile], True], False,
			(* If the CryoprotectantSolution has Model[Molecule, "Dimethyl sulfoxide"] in its composition, don't autoclave it. *)
			MemberQ[Flatten[fastAssocLookup[fastAssoc, #, Composition]], ObjectP[Model[Molecule, "id:01G6nvwRWRJ4"]]], False,
			(* Otherwise, this needs to be autoclaved. *)
			True, True
		]&,
		expandedCryoprotectantSolutions
	];

	(* Generate insulatedCoolerFreezingConditions by mapping from Model[Freezer] to the appropriate storage condition models. *)
	insulatedCoolerFreezingConditions = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		(* Do this only if we're using an insulatedCooler FreezingStrategy since it doesn't apply for ControlledRateFreezer. *)
		ConstantArray[Null, Length[expandedSamplesWithReplicates]],
		ConstantArray[Link[Model[StorageCondition, "id:xRO9n3BVOe3z"]], Length[expandedSamplesWithReplicates]](* Model[StorageCondition, "Deep Freezer"]: a -80 Celsius Freezer *)
	];

	(* Generate the freezer resource if we're using a ControlledRateFreezer. No need to make freezer resources if *)
	(* we're using InsulatedCoolers, since the storage task will make the freezer resources in that case. *)
	freezerResourcesLink = If[MatchQ[resolvedFreezingStrategy, InsulatedCooler],
		Link /@ expandedFreezers,
		Link /@ Map[
			Resource[Instrument -> #, Time -> Max[resolvedTemperatureProfile[[All, 2]]], Name -> ToString[#]]&,
			ToList[expandedFreezers]
		]
	];

	(* Generate the FreezingRack resources. *)
	freezingRackResources = Map[
		Resource[Sample -> #, Rent -> True, Name -> CreateUUID[]]&,
		uniqueFreezingRacksByBatch
	];

	freezingRackResourcesLink = Link /@ Map[
		Function[{sampleIndex},
			Module[{batchNumber},
				batchNumber = Position[expandedSampleIndicesByFreezingBatch, _?(MemberQ[#, sampleIndex]&)][[1]];
				Extract[freezingRackResources, batchNumber]
			]
		],
		Range[Length@expandedFreezingRacks]
	];

	freezingCellTime = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		Max[resolvedTemperatureProfile[[All, 2]]] + 15 Minute,
		resolvedInsulatedCoolerFreezingTime + 15 Minute
	];
	(* If we have any samples that will be stored in CryogenicStorage, make a resource for Model[Item, Glove, "Cryo Glove, Medium"]. *)
	cryogenicGlovesResource = If[MemberQ[expandedSamplesOutStorageConditionSymbols, CryogenicStorage],
		Link[Resource[Sample -> Model[Item, Glove, "id:4pO6dM5EWNaw"], Rent -> True, Name -> ToString[Model[Item, Glove, "id:4pO6dM5EWNaw"]]]],
		Null
	];

	(* Make the IDs for the protocol object *)
	protocolID = CreateID[Object[Protocol, FreezeCells]];

	(* Get all the non-hidden options that go into the unit operation objects *)
	nonHiddenOptions = allowedKeysForUnitOperationType[Object[UnitOperation, FreezeCells]];

	(* Generate all of the relevant unit operation packet(s). *)
	freezeCellsUnitOperationPackets = Module[
		{simulatedContainersLookup, unitOperations, unitOpPackets},
		(* For duplicate-free Object[Container] in expandedCryogenicSampleContainers, construct a lookup
		in order to convert any simulated object to its label for BatchedUnitOperation generation.*)
		simulatedContainersLookup = If[
			MatchQ[#, ObjectP[Object[Container]]] && !DatabaseMemberQ[#] && MatchQ[LookupObjectLabel[simulation, #], (_String)],
			# -> LookupObjectLabel[simulation, #],
			Nothing
		]& /@ DeleteDuplicates[expandedCryogenicSampleContainers];

		unitOperations = Map[
			FreezeCells @@ ReplaceRule[
				{
					Sample -> sampleResources[[#]],
					CryogenicSampleContainerLabel -> resolvedCryogenicSampleContainerLabels[[#]],
					CryogenicSampleContainer -> expandedCryogenicSampleContainers[[#]]/.simulatedContainersLookup,
					CellType -> expandedCellTypes[[#]],
					CultureAdhesion -> expandedCultureAdhesions[[#]],
					FreezingRack -> freezingRackResourcesLink[[#]],
					Freezer -> freezerResourcesLink, (* Note that this is exactly the expandedFreezers -- not resources -- if we're using an insulated cooler. *)
					Coolant -> expandedCoolants[[#]],
					Aliquot -> expandedAliquots[[#]],
					AliquotVolume -> expandedAliquotVolumes[[#]],
					CellPelletCentrifuge -> expandedCellPelletCentrifuges[[#]],
					CellPelletIntensity -> expandedCellPelletIntensities[[#]],
					CellPelletTime -> expandedCellPelletTimes[[#]],
					CellPelletSupernatantVolume -> expandedCellPelletSupernatantVolumes[[#]],
					CryoprotectantSolution -> cryoprotectantSolutionResourcesLink[[#]],
					SamplesOutStorageConditionExpression -> expandedSamplesOutStorageConditionSymbols[[#]],
					InsulatedCoolerFreezingCondition -> insulatedCoolerFreezingConditions[[#]],
					InsulatedCoolerContainer -> expandedInsulatedCoolerContainers[[#]],
					FreezingStrategy -> resolvedFreezingStrategy,
					TemperatureProfile -> resolvedTemperatureProfile,
					InsulatedCoolerFreezingTime -> resolvedInsulatedCoolerFreezingTime,
					NumberOfReplicates -> numericNumberOfReplicates,
					CryoprotectantSolutionTemperature -> resolvedCryoprotectantSolutionTemperature,
          MeasureVolume -> False,
					MeasureWeight -> False,
					ImageSample -> False
				}
			] &,
			expandedSampleIndicesByFreezingBatch
		];

		unitOpPackets = UploadUnitOperation[
			#,
			UnitOperationType -> Batched,
			Preparation -> Manual,
			FastTrack -> True,
			Upload -> False
		] & /@ unitOperations
	];

	(* Convert the packets to the correct Link format for the protocol packet. *)
	linkedFreezeCellsUnitOpPackets = Link[#, Protocol] & /@ ToList[Lookup[freezeCellsUnitOperationPackets, Object]];

	(* Set up the procedure checkpoints. Since the checkpoints are dynamic, the max number of them are layed out in order as: *)
	(* 1."Preparing Cryoprotectant Solutions" (main protocol procedure) *)
	(* 2."Chilling Cryoprotectant Solutions" -> "197113a1-392f-4636-b50d-fbab12439efb" -> "c0e3f072-6184-4187-aa8c-fb9c5872a8d1" (2 condition tasks in)*)
	(* 3."Adding Coolants to InsulatedCoolerContainers" -> "34200288-ce66-41c4-8976-0ac722464db8" (1 condition task in) *)
	(* 4."Picking FreezingRack Resources" (main protocol procedure) *)
	(* 5."Picking Sample Resources" (main protocol procedure)*)
	(* 6."Cell Pelleting" -> "4283b132-6702-4787-b960-db038bb33886" (1 condition task in) *)
	(* 7."Preparing CryogenicSampleContainer" (main protocol procedure), consists of aliquoting, cryoprotect tarnsfer and mix *)
	(* 8."Freezing Cells" (main protocol procedure) *)
	(* 9."Storing CryogenicSampleContainer" (main protocol procedure) *)
	(* 10."Returning Materials" (main protocol procedure)*)
	checkpoints = {
		{"Preparing Cryoprotectant Solutions", 1 Hour, "CryoprotectantSolutions required for this protocol are prepared and autoclaved.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]},
		(* If there are CryoprotectantSolutions, they have to be prepared, autoclaved, and potentially chilled. *)
		If[MemberQ[ToList[expandedCryoprotectionStrategies], Alternatives[AddCryoprotectant, ChangeMedia]] && MatchQ[resolvedCryoprotectantSolutionTemperature, Chilled],
			{"Chilling Cryoprotectant Solutions", cryoprotectantSolutionChillingTime, "CryoprotectantSolutions required for this protocol are chilled in a refrigerator.", Link[Resource[Operator -> $BaselineOperator, Time -> cryoprotectantSolutionChillingTime]]},
			Nothing
		],
		(* If we are using an InsulatedCooler strategy, resource pick the coolers and add coolants to them. *)
		If[MatchQ[resolvedFreezingStrategy, InsulatedCooler],
			{"Adding Coolants to InsulatedCoolerContainers", 10 Minute, "Coolants are added to the InsulatedCoolerContainers required for this protocol.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
			Nothing
		],
		(* Resource pick the FreezingRacks. *)
		{"Picking FreezingRack Resources", 5 Minute, "FreezingRacks required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 5 Minute]]},
		(* Resource pick the SamplesIn. *)
		{"Picking Sample Resources", 10 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
		(* Optional Pelleting *)
		If[MemberQ[ToList[expandedCryoprotectionStrategies], ChangeMedia],
			{"Cell Pelleting", Max[Cases[ToList[expandedCellPelletTimes], TimeP]] + 30 Minute, "Cell samples are centrifuged.", Link[Resource[Operator -> $BaselineOperator, Time -> Max[Cases[ToList[expandedCellPelletTimes], TimeP]] + 30 Minute]]},
			Nothing
		],
		(* ChangeMedia,Aspirate, AddCryoprotectant, Aliquot and Mix in biosafety cabinet. *)
		{"Preparing CryogenicSampleContainer", 1 Hour, "Original samples are mixed or media exchanged and resuspended, then aliquoted to CryogenicSampleContainer together with CryoprotectantSolutions.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
		{"Freezing Cells", freezingCellTime, "Samples are placed in a freezer.", Link[Resource[Operator -> $BaselineOperator, Time -> freezingCellTime]]},
		{"Storing CryogenicSampleContainer", 30 Minute, "CryogenicSamplesContainers are stored in either DeepFreezer or CryogenicStorage for long term storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
		(* Return materials. *)
		{"Returning Materials", 10 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]}
	};

	(* Generate the raw protocol packet *)
	protocolPacket = <|
		Object -> protocolID,
		Type -> Object[Protocol, FreezeCells],
		Name -> Lookup[myResolvedOptions, Name],
		MeasureVolume -> False,
		MeasureWeight -> False,
		ImageSample -> False,
		ResolvedOptions -> resolvedOptionsNoHidden,
		TemperatureProfile -> resolvedTemperatureProfile,
		CryoprotectantSolutionTemperature -> resolvedCryoprotectantSolutionTemperature,
		CryoprotectantSolutionChillingTime -> cryoprotectantSolutionChillingTime,
		InsulatedCoolerFreezingTime -> resolvedInsulatedCoolerFreezingTime,
		EstimatedProcessingTime -> estimatedProcessingTime,
		FreezeCellsPelletUnitOperation -> pelletUnitOperation,
		FreezeCellsCoolantTransferUnitOperation -> coolantTransferUnitOperation,
		CryogenicGloves -> cryogenicGlovesResource,
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ sampleResources),
		Replace[ContainersIn] -> (Link[#, Protocols]& /@ sampleContainerResources),
		Replace[CellTypes] -> expandedCellTypes,
		Replace[CultureAdhesions] -> expandedCultureAdhesions,
		Replace[CellPelletCentrifuges] -> Link /@ expandedCellPelletCentrifuges,
		Replace[CellPelletTimes] -> expandedCellPelletTimes,
		Replace[CellPelletIntensities] -> expandedCellPelletIntensities,
		Replace[CellPelletSupernatantVolumes] -> expandedCellPelletSupernatantVolumesWithNoAlls,
		Replace[CryoprotectionStrategies] -> expandedCryoprotectionStrategies,
		Replace[CryoprotectantSolutions] -> cryoprotectantSolutionResourcesLink,
		Replace[CryoprotectantSolutionsToAutoclave] -> PickList[cryoprotectantSolutionResourcesLink, autoclaveCryoprotectantQs],
		Replace[CryoprotectantSolutionVolumes] -> expandedCryoprotectantSolutionVolumes,
		Replace[AliquotVolumes] -> expandedAliquotVolumesWithNoAlls,
		Replace[CryogenicSampleContainers] -> Link /@ expandedCryogenicSampleContainers,
		Replace[CryogenicSampleContainerLabels] -> resolvedCryogenicSampleContainerLabels,
		Replace[FreezingRacks] -> freezingRackResourcesLink,
		Replace[Freezers] -> freezerResourcesLink,
		Replace[Coolants] -> Link /@ expandedCoolants,
		Replace[CoolantVolumes] -> expandedCoolantVolumes,
		Replace[InsulatedCoolerContainers] -> Link /@ expandedInsulatedCoolerContainers,
		Replace[InsulatedCoolerFreezingConditions] -> insulatedCoolerFreezingConditions,
		Replace[SamplesOutStorage] -> expandedSamplesOutStorageConditionSymbols,
		Replace[BatchedUnitOperations] -> linkedFreezeCellsUnitOpPackets,
		Replace[Checkpoints] -> checkpoints
	|>;

	(* Get all of the resource out of the packet so they can be tested *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[{freezeCellsUnitOperationPackets, protocolPacket}], _Resource, Infinity]];

	(* Call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine],
			{True, {}},
		(* We don't need to do this here because the framework will already call it itself for the robotic case. *)
		MatchQ[resolvedPreparation, Robotic],
			{True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Simulation -> simulation, Cache -> cache],
		True,
			{Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack], Site -> Lookup[myResolvedOptions, Site], Simulation -> simulation, Messages -> messages, Cache -> cache], Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentFreezeCells, myResolvedOptions],
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* Generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> Which[
		MatchQ[resolvedPreparation, Manual] && MemberQ[output, Result] && TrueQ[fulfillable],
		{protocolPacket, freezeCellsUnitOperationPackets, allOptionsExpandedForReplicates},
		True,
			$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];

(* Primitive Support*)
(* ::Subsubsection::Closed:: *)
(* resolveFreezeCellsMethod *)

resolveFreezeCellsMethod[___]:=Manual;

(* ::Subsubsection::Closed:: *)
(*Simulation*)

DefineOptions[
	simulateExperimentFreezeCells,
	Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentFreezeCells[
	myProtocolPacket: (PacketP[Object[Protocol, FreezeCells], {Object, ResolvedOptions}] | $Failed | Null),
	myUnitOperationPackets: ({PacketP[]...} | $Failed),
	mySamples: {ObjectP[Object[Sample]]...},
	myResolvedOptions: {_Rule...},
	myResolutionOptions: OptionsPattern[simulateExperimentFreezeCells]
] := Module[
	{
		cache, simulation, fastAssoc, samplePackets, numericNumberOfReplicates, cryogenicSampleContainerResources,
		myProtocolPacketWithCryoVialResources, protocolObject, fulfillmentSimulation, currentSimulation, cellPelletSupernatantVolumes,
		cryoprotectantSolutionVolumes, aliquotVolumes, simulatedSamples, simulatedCryoprotectantSolutions, simulatedCryogenicSampleContainers,
		cryoprotectionStrategies, aliquotIndices, simulatedCryogenicSamples, indexedSamplesWithInfo, pelletIndices,
		simulatedWasteSampleObject, uniqueSamplesTransferInfo, simulationTransferPackets, simulatedSampleStatePackets, simulationWithLabels
	},

	(* NOTE: all samples, packets, and options passed into the simulation function are already expanded for NumberOfReplicates. *)

	(* Lookup our cache and simulation. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	fastAssoc = makeFastAssocFromCache[cache];

	(* Get the sample packets. *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;

	(* Look up the number of replicates, replacing Null with 1. *)
	numericNumberOfReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* Make resources for the CryogenicSampleContainers so that SimulateResources will simulate them. *)
	cryogenicSampleContainerResources = Link /@ (Resource[Sample -> #, Rent -> False, Name -> CreateUUID[]]& /@ Lookup[myResolvedOptions, CryogenicSampleContainer]);

	(* Replace the CryogenicSampleContainers in the Protocol object with the resources we just made. *)
	myProtocolPacketWithCryoVialResources = Module[{packetWithoutCryoVials},
		(* Remove the CryogenicSampleContainers from the existing protocol packet. *)
		packetWithoutCryoVials = KeyDrop[myProtocolPacket, CryogenicSampleContainers];
		(* Now add in the cryo vial resources. *)
		Join[packetWithoutCryoVials, <|Replace[CryogenicSampleContainers] -> cryogenicSampleContainerResources|>]
	];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject = Which[
		(* As it stands, we won't run this function if resource packets function fails, but it doesn't hurt to leave this in. *)
		MatchQ[myProtocolPacket, $Failed],
			SimulateCreateID[Object[Protocol, FreezeCells]],
		True,
			Lookup[myProtocolPacketWithCryoVialResources, Object]
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: In ExperimentFreezeCells we don't call the simulateExperimentFreezeCells if the resource packets function fails. *)
	fulfillmentSimulation = SimulateResources[
		myProtocolPacketWithCryoVialResources,
		myUnitOperationPackets,
		Cache -> cache,
		Simulation -> simulation
	];

	(* Update the simulation with the simulated resources. *)
	currentSimulation = UpdateSimulation[simulation, fulfillmentSimulation];

	(* Get the input samples, cryo vials, and all volumes relevant to sample movement from the simulation. *)
	{
		cellPelletSupernatantVolumes,
		cryoprotectantSolutionVolumes,
		aliquotVolumes,
		simulatedSamples,
		simulatedCryoprotectantSolutions,
		simulatedCryogenicSampleContainers,
		cryoprotectionStrategies
	} = Download[protocolObject,
		{
			CellPelletSupernatantVolumes,
			CryoprotectantSolutionVolumes,
			AliquotVolumes,
			SamplesIn,
			CryoprotectantSolutions,
			CryogenicSampleContainers,
			CryoprotectionStrategies
		},
		Simulation -> currentSimulation
	];

	(* Get the indices at which aliquoting occur. If Aliquot is True, there is no Object[Sample] in simulatedCryogenicSampleContainers *)
	aliquotIndices = Sort @ DeleteDuplicates[Flatten[Position[aliquotVolumes, VolumeP]]];
	(* If we need to create any new samples due to aliquoting, simulate them here. *)
	simulatedCryogenicSamples = If[MatchQ[aliquotIndices, {}],
		(* If there are no new samples to be simulated, samplesOut are the original SamplesIn. *)
		mySamples,
		Module[{newSamplesFromAliquotingPackets, simulatedNewSamplesFromAliquoting},
			(* Create packets for any new samples that will be created as a result of aliquoting. This is pre-allocation for UploadSampleTransfer *)
			newSamplesFromAliquotingPackets = UploadSample[
				(* Note: UploadSample takes in {} if there is no Model and we have no idea what's in it, which is the case here *)
				ConstantArray[{}, Length[aliquotIndices]],
				{"A1", #} & /@ simulatedCryogenicSampleContainers[[aliquotIndices]],
				InitialAmount -> ConstantArray[Null, Length[aliquotIndices]],
				State -> ConstantArray[Liquid, Length[aliquotIndices]],
				Simulation -> currentSimulation,
				SimulationMode -> True,
				UpdatedBy -> protocolObject,
				FastTrack -> True,
				Upload -> False
			];

			(* Update the simulation with these new packets. *)
			currentSimulation = UpdateSimulation[currentSimulation, Simulation[newSamplesFromAliquotingPackets]];

			(* Lookup Object[Sample]s from the aliquoted sample packets. *)
			simulatedNewSamplesFromAliquoting = DeleteDuplicates @ Cases[Lookup[newSamplesFromAliquotingPackets, Object], ObjectReferenceP[Object[Sample]]];

			(* Riffle the new simulated samples back with InSitu samples reserving the order in my samples *)
			ReplacePart[mySamples, Thread[Flatten@aliquotIndices -> simulatedNewSamplesFromAliquoting]]
		]
	];

	(* Since we allow the same sample for different option sets in addition to NumberOfReplicates, consolidate all the info here *)
	indexedSamplesWithInfo = Transpose@{
		(*1*)Range[Length[mySamples]],
		(*2*)mySamples,
		(*3*)cellPelletSupernatantVolumes,
		(*4*)cryoprotectionStrategies,
		(*5*)aliquotVolumes,
		(*6*)simulatedCryoprotectantSolutions,
		(*7*)cryoprotectantSolutionVolumes,
		(*8*)simulatedCryogenicSamples
	};

	(* UploadSampleTransfer will not allow us to transfer to Waste, check if any sample needs to simulate waste. *)
	pelletIndices = Sort @ DeleteDuplicates[Flatten[Position[cellPelletSupernatantVolumes, VolumeP]]];

	(* If there is pelleting at any index, simulate the supernatantwaste sample here. *)
	simulatedWasteSampleObject = If[
		(* If there are no new samples to be simulated, skip all of this. *)
		MatchQ[Length[pelletIndices], 0],
		Null,
		(* UploadSampleTransfer will not allow us to transfer to Waste, so let's simulate a transfer destination. *)
		Module[
			{
				simulatedWasteContainerPacket, simulatedWasteContainerObject, simulatedWasteSamplePacket
			},
			(* Upload a simulated waste container to the bench. *)
			simulatedWasteContainerPacket = UploadSample[
				Model[Container, Vessel, "1000mL Erlenmeyer Flask"],
				{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]},(*Object[Container, Room, "id:AEqRl9KmEAz5"]*)
				Upload -> False,
				Simulation -> currentSimulation
			];
			simulatedWasteContainerObject = FirstCase[Lookup[simulatedWasteContainerPacket, Object], ObjectP[Object[Container, Vessel]]];

			(* Add this container to the existing simulation. *)
			currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulatedWasteContainerPacket]];

			(* Now upload a simulated sample to the existing simulation. *)
			simulatedWasteSamplePacket = UploadSample[
				Model[Sample, "Milli-Q water"],
				{"A1", simulatedWasteContainerObject},
				InitialAmount -> Null,
				Simulation -> currentSimulation,
				SimulationMode -> True,
				FastTrack -> True,
				Upload -> False
			];

			(* Update the simulation with the waste destination sample object. *)
			currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulatedWasteSamplePacket]];

			(* Now get the simulated waste sample destination. *)
			FirstCase[Lookup[simulatedWasteSamplePacket, Object], ObjectP[Object[Sample]]]
		]
	];

	(* Generate a transfer info for each unique sample *)
	(* Note: the logic is similar in complier. If anything is changed, update complier as well. *)
	uniqueSamplesTransferInfo = Map[
		Function[{uniqueSample},
			Module[
				{
					relatedEntries, replicateNum, pelletQ, inSituQ, relatedCryoprotectants, relatedCryoprotectantVolumes,
					relatedSupernatantVolumes, relatedAliquotVolumes, relatedNewSamples, allSources, allDestinations, allAmounts
				},
				relatedEntries = Cases[indexedSamplesWithInfo, {_Integer, uniqueSample, __}];
				(* Note:pelletQ and inSituQ should be the same across different entries. *)
				pelletQ = MemberQ[relatedEntries[[All, 4]], ChangeMedia];
				inSituQ = !MemberQ[relatedEntries[[All, 5]], VolumeP];
				replicateNum = Length[relatedEntries];
				(* Pull out cryoprotectant info *)
				relatedCryoprotectants = Download[relatedEntries[[All, 6]], Object];
				relatedCryoprotectantVolumes = relatedEntries[[All, 7]];
				relatedSupernatantVolumes = relatedEntries[[All, 3]];
				relatedAliquotVolumes = relatedEntries[[All, 5]];
				relatedNewSamples = Download[relatedEntries[[All, 8]], Object];

				{allSources, allDestinations, allAmounts} = Which[
					(* If we are changing media and freezing in the containersIn, we first aspirate supernatant, then add cryoprotectant, then aliquot(optional) *)
					TrueQ[pelletQ] && TrueQ[inSituQ],
						{
							{uniqueSample, relatedCryoprotectants[[1]]},
							{simulatedWasteSampleObject, uniqueSample},
							{relatedSupernatantVolumes[[1]], relatedCryoprotectantVolumes[[1]]}
						},
					(* If we are changing media and freezing in new containers, 2 transfer uos *)
					(* CryoprotectantSolution resource has been consolidated, we only need to add to pellets one time *)
					TrueQ[pelletQ],
						{
							Join[{uniqueSample, relatedCryoprotectants[[1]]}, ConstantArray[uniqueSample, replicateNum]],
							Join[{simulatedWasteSampleObject, uniqueSample}, relatedNewSamples],
							Join[{relatedSupernatantVolumes[[1]], relatedCryoprotectantVolumes[[1]]}, relatedAliquotVolumes]
						},
					(* If InSitu is True, just a single add cryoprotecant transfer  *)
					TrueQ[inSituQ] && MemberQ[relatedCryoprotectants, ObjectP[]],
						{
							relatedCryoprotectants,
							ConstantArray[uniqueSample, replicateNum],
							relatedCryoprotectantVolumes
						},
					(* If InSitu is True and no cryoprotectant, no need to update anything  *)
					TrueQ[inSituQ],
						{Null, Null, Null},
					(* For AddCryoprotectant and None strategies, when Aliquot is True, we aliquot directly to new cryogenic vials  *)
					True,
						Module[
							{
								cryoprotectionIndices, samplesWithcryoprotectionIndices, amountWithcryoprotectionIndices,
								cryoprotectantsWithcryoprotectionIndices
							},
							(* Find the indices at which the CryoprotectantSolutions are not Null. *)
							cryoprotectionIndices = Position[relatedCryoprotectants, ObjectP[]];
							samplesWithcryoprotectionIndices = Extract[relatedNewSamples, cryoprotectionIndices];
							amountWithcryoprotectionIndices = Extract[relatedCryoprotectantVolumes, cryoprotectionIndices];
							cryoprotectantsWithcryoprotectionIndices = Extract[relatedCryoprotectants, cryoprotectionIndices];
							If[MatchQ[cryoprotectionIndices, {}],
								{
									ConstantArray[uniqueSample, replicateNum],
									relatedNewSamples,
									relatedAliquotVolumes
								},
								{
									Join[ConstantArray[uniqueSample, replicateNum], ToList@cryoprotectantsWithcryoprotectionIndices],
									Join[relatedNewSamples, ToList@samplesWithcryoprotectionIndices],
									Join[relatedAliquotVolumes, ToList@amountWithcryoprotectionIndices]
								}
							]
						]
				];
				{allSources, allDestinations, allAmounts}
			]
		],
		DeleteDuplicates@mySamples
	];

	(* Simulate the transfer using UploadSampleTransfer. *)
	simulationTransferPackets = UploadSampleTransfer[
		Flatten@DeleteCases[uniqueSamplesTransferInfo[[All, 1]], Null],
		Flatten@DeleteCases[uniqueSamplesTransferInfo[[All, 2]], Null],
		Flatten@DeleteCases[uniqueSamplesTransferInfo[[All, 3]], Null],
		Upload -> False,
		FastTrack -> True,
		Simulation -> currentSimulation,
		UpdatedBy -> protocolObject
	];

	(* Update the simulation to reflect the outcome of the simulated transfer. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulationTransferPackets]];

	(* Now updated all simulatedCryogenicSamples to Solid since they are frozen by the end of this experiment *)
	simulatedSampleStatePackets = Map[<|Object -> #, State -> Solid|>&, simulatedCryogenicSamples];

	(* Update the simulation to reflect the outcome of the freezing process. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulatedSampleStatePackets]];

	(* Uploaded Labels *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, CryogenicSampleContainerLabel]], simulatedCryogenicSampleContainers}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> Join[
			Rule @@@ Cases[
				Transpose[{ToList[Lookup[myResolvedOptions, CryogenicSampleContainer]], (Field[CryogenicSampleContainerLink[[#]]]&) /@ Range[Length[simulatedCryogenicSampleContainers]]}],
				{_String, _}
			]
		]
	];

	(* Merge our packets with our simulation. *)
	{
		Lookup[myProtocolPacket, Object],
		UpdateSimulation[currentSimulation, simulationWithLabels]
	}

];

(* ::Subsubsection::Closed:: *)
(* Memoized Searches *)

(* Memoize the results of these searches after first execution to avoid repeated database trips within a single kernel session. *)

(* Find all insulated coolers and racks, and racks for the controlled rate freezer. *)
freezeCellsContainerSearch[testString: _String] := freezeCellsContainerSearch[testString] = Module[{},
	(* Add freezeCellsContainerSearch to list of Memoized functions. *)
	AppendTo[$Memoization, Experiment`Private`freezeCellsContainerSearch];
	Search[
		Model[Container],
		Footprint == Alternatives[ControlledRateFreezerRack, MrFrostyContainer, MrFrostyRack] && Deprecated != True
	]
];

(* Find all cryogenic vials. This is the same criteria in whyCantThisModelBeCryogenicVial. *)
freezeCellsCryogenicVialSearch[testString: _String] := freezeCellsCryogenicVialSearch[testString] = Module[{},
	(* Add freezeCellsContainerSearch to list of Memoized functions. *)
	AppendTo[$Memoization, Experiment`Private`freezeCellsCryogenicVialSearch];
	Search[
		Model[Container, Vessel],
		Footprint == CEVial && MinTemperature < -170 Celsius && ContainerMaterials != Glass && Deprecated != True
	]
];

(* Find all instruments that might be used in ExperimentFreezeCells. *)
freezeCellsInstrumentSearch[testString: _String] := freezeCellsInstrumentSearch[testString] = Module[{},
	(* Add freezeCellsInstrumentSearch to list of Memoized functions. *)
	AppendTo[$Memoization, Experiment`Private`freezeCellsInstrumentSearch];

	Flatten@Search[
		{Model[Instrument, Freezer], Model[Instrument, ControlledRateFreezer], Model[Instrument, Centrifuge]},
		Notebook == Null && DeveloperObject != True && Deprecated != True
	]
];

(* ::Subsection:: *)
(*ExperimentFreezeCellsPreview*)


DefineOptions[ExperimentFreezeCellsPreview,
	SharedOptions :> {ExperimentFreezeCells}
];


ExperimentFreezeCellsPreview[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ExperimentFreezeCellsPreview]] := Module[
	{listedOptions},

	listedOptions = ToList[myOptions];

	ExperimentFreezeCells[myInput, ReplaceRule[listedOptions, Output -> Preview]]
];

(* ::Subsection:: *)
(*ExperimentFreezeCellsOptions*)


DefineOptions[ExperimentFreezeCellsOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Indicates whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentFreezeCells}
];


ExperimentFreezeCellsOptions[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ExperimentFreezeCellsOptions]] := Module[
	{listedOptions, preparedOptions, resolvedOptions},

	listedOptions = ToList[myOptions];

	(* Send in the correct Output option and remove OutputFormat option *)
	preparedOptions = Normal@KeyDrop[Append[listedOptions, Output -> Options], {OutputFormat}];

	resolvedOptions = ExperimentFreezeCells[myInput, preparedOptions];

	(* Return the option as a list or table *)
	If[MatchQ[OptionDefault[OptionValue[OutputFormat]], Table]&&MatchQ[resolvedOptions ,{(_Rule|_RuleDelayed)..}],
		LegacySLL`Private`optionsToTable[resolvedOptions, ExperimentFreezeCells],
		resolvedOptions
	]
];


(* ::Subsection:: *)
(*ValidExperimentFreezeCellsQ*)

DefineOptions[ValidExperimentFreezeCellsQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentFreezeCells}
];


ValidExperimentFreezeCellsQ[myInput: ListableP[ObjectP[{Object[Sample], Object[Container]}]|_String], myOptions: OptionsPattern[ValidExperimentFreezeCellsQ]] := Module[
	{listedInput, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat},

	listedInput = ToList[myInput];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Normal@KeyDrop[Append[listedOptions, Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests = ExperimentFreezeCells[myInput, preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[{initialTest, validObjectBooleans, voqWarnings},
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[ToString[#1, InputForm] <> " is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest}, functionTests, voqWarnings]
		]
	];

	(* Lookup test running options *)
	safeOps = SafeOptions[ValidExperimentFreezeCellsQ, Normal@KeyTake[listedOptions, {Verbose, OutputFormat}]];
	{verbose, outputFormat} = Lookup[safeOps, {Verbose, OutputFormat}];

	(* Run the tests as requested and return just the summary not the association if OutputFormat->TestSummary*)
	Lookup[
		RunUnitTest[
			<|"ExperimentFreezeCells" -> allTests|>,
			Verbose -> verbose,
			OutputFormat -> outputFormat
		],
		"ExperimentFreezeCells"
	]
];

(* ::Section:: *)
(*End Private*)
