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
			Description -> "Specifies how many identical frozen cell stock samples are prepared from each provided sample(s). For example, if NumberOfReplicates is set to 2, two cryogenic vials with identical contents are generated as a result of this experiment. This also indicates that the samples are transferred into new cryogenic vials. If NumberOfReplicates is set to Null, one and only one CryogenicSampleContainer is generated.",
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
			ResolutionDescription -> "If either Coolant or InsulatedCoolerFreezingTime is specified, or a static temperature freezer is specified as Freezer, or CryogenicSampleContainer is set to a container with MaxVolume larger than 2 Milliliter, automatically set to InsulatedCooler. Otherwise, automatically set to ControlledRateFreezer.",
			Category -> "General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* ---------- General Options ---------- *)
			CellTypeOption, (* Bacterial | Yeast | Mammalian *)
			CultureAdhesionOption, (* Suspension | Adherent | SolidMedia *)
			ModifyOptions[InSituOption,
				Default -> Automatic,
				Description -> "For each sample, whether to freeze the input sample in its current container rather than transferring them to new cryogenic vial(s).",
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
				Description -> "For each sample, the desired container model for freezing the cell stock(s). Or in cases where samples are frozen in situ, the original container holding the input sample. All resulting containers are subsequently frozen, and stored under cryogenic conditions.",
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
				Description -> "The manner in which the cell sample(s) are processed prior to freezing in order to protect the cells from detrimental ice formation. If ChangeMedia is selected, the entire input sample is pelleted, the existing media is removed and replaced with CryoprotectantSolution, resulting in cell stocks suspended in cryoprotectant solution. If AddCryoprotectant is selected, the CryoprotectantSolution and a portion of the input sample is added directly to the CryogenicSampleContainer when Aliquot is True, or the CryoprotectantSolution is added directly to the input sample if freezing samples in situ is desired. In both cases, the resulting cell stocks consist of cells in the original medium supplemented with cryoprotectant solution. If None is selected, the existing media is left unchanged. The sample is simply mixed to ensure a uniform suspension.",
				ResolutionDescription -> "Automatically set to ChangeMedia if any of CellPelletCentrifuge, CellPelletTime, CellPelletIntensity, or CellPelletSupernatantVolume are specified. Otherwise, automatically set to AddCryoprotectant.",
				Category -> "General"
			},
			(* ---------- ChangeMedia Options ---------- *)
			ModifyOptions[ExperimentWashCells,
				CellIsolationInstrument,
				OptionName -> CellPelletCentrifuge,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The centrifuge used to pellet the cell sample(s) in order to remove the existing media and replace with cryoprotectant media.",
				ResolutionDescription -> "Automatically set to a centrifuge that can attain the specified CellPelletIntensity and is compatible with the sample in its current container if CryoprotectionStrategy is set to ChangeMedia. For more information on compatible centrifuges, see the function CentrifugeDevices.",
				Category -> "Media Changing"
			],
			ModifyOptions[ExperimentWashCells,
				CellIsolationTime,
				OptionName -> CellPelletTime,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The duration of time for which the sample(s) are centrifuged in order to pellet the cells, enabling removal of existing media.",
				ResolutionDescription -> "Automatically set to 5 Minute if CryoprotectionStrategy is set to ChangeMedia.",
				Category -> "Media Changing"
			],
			ModifyOptions[ExperimentWashCells,
				CellPelletIntensity,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The rotational speed or force applied to the cell sample(s) by centrifugation in order to create a pellet, enabling removal of existing media.",
				ResolutionDescription -> "If CryoprotectionStrategy is set to ChangeMedia, automatically set to an intensity typical for centrifugation of the given CellType due to its effectiveness in pelleting that CellType: "<>ToString[$LivingMammalianCentrifugeIntensity]<>" if the CellType is Mammalian, "<>ToString[$LivingBacterialCentrifugeIntensity]<>" if the CellType is Bacterial, or "<>ToString[$LivingYeastCentrifugeIntensity]<>" if the CellType is Yeast.",
				Category -> "Media Changing"
			],
			ModifyOptions[ExperimentWashCells,
				CellAspirationVolume,
				OptionName -> CellPelletSupernatantVolume,
				Default -> Automatic,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, $MaxTransferVolume],
						Units :> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				],
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
				Description -> "The solution which contains high concentration of cryoprotective agents, such as glycerol and DMSO. The cryoprotectant solution protects the cells during freezing and thawing by preventing ice crystals from forming inside or around cells. See Figure 3.1 for more information about suggested cryoprotectant solutions for different cell types and strategies.",
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
				Description -> "The amount of CryoprotectantSolution to be added to the cell sample(s).",
				ResolutionDescription -> "If CryoprotectionStrategy is set to ChangeMedia, the volume is automatically set to match the CellPelletSupernatantVolume that is removed following pelleting. This volume is used to resuspend the cell pellet obtained from the entire sample, prior to aliquoting into cryogenic vials, if applicable. If CryoprotectionStrategy is set to AddCryoprotectant, the volume is automatically set to 50% of the sample volume to be mixed with. When Aliquot is True, this corresponds to 50% of the AliquotVolume. When Aliquot is False, this corresponds to 50% of the total input sample volume.",
				Category -> "Cryoprotection"
			},
			(* ---------- Aliquoting Options ---------- *)
			{
				OptionName -> Aliquot,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "For each sample, indicates whether to prepare cell stock(s) in new cryogenic vial(s) rather than in the current container of the provided sample. If CryoprotectionStrategy is set to ChangeMedia, aliquoting occurs after pelleting the entire sample and replacing the existing media with CryoprotectantSolution. If CryoprotectationStrategy is set to AddCryoprotectant or None, aliquoting occurs before the addition of CryoprotectantSolution. See Figure 1 of freeze cells for more information.",
				ResolutionDescription -> "Automatically set to True if AliquotVolume, NumberOfReplicates, or a new CryogenicSampleContainer is specified, if the sample's current container has a Footprint other than CryogenicVial, or if the total volume of the cell stock exceeds 75% of the current container's maximum capacity. Otherwise, set to False.",
				Category -> "Aliquoting"
			},
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
				Description -> "The volume of suspended cell sample that is transferred into new cryogenic sample container(s). If CryoprotectionStrategy is set to ChangeMedia, the entire input sample is first pelleted and resuspended in CryoprotectantSolution. In this case, the AliquotVolume refers to the specified amount of the resuspended cells being transferred into new cryogenic sample container(s). If CryoprotectionStrategy is set to AddCryoprotectant or None, AliquotVolume refers to the specified amount of the well-mixed original input sample that is transferred into new cryogenic container(s).",
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
					Pattern :> ObjectP[{Model[Container, Rack], Object[Container, Rack]}],
					OpenPaths -> {
						{Object[Catalog, "Root"], "Containers", "Cell Freezing Containers"}
					}
				],
				Description -> "The insulated cooler rack or controlled rate freezer-compatible sample rack used to freeze the cell sample(s).",
				ResolutionDescription -> "Automatically set to Model[Container, Rack, \"2mL Cryo Rack for VIA Freeze\"] if FreezingStrategy is set to ControlledRateFreezer. If FreezingStrategy is set to InsulatedCooler, automatically set to a rack that can accommodate the vials containing the experiment samples. Refer to Figure 3.2 for more information on freezing racks for InsulatedCooler.",
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
						{Object[Catalog, "Root"], "Instruments", "Storage Devices", "Freezers"}
					}
				],
				Description -> "The device used to cool the cell sample(s).",
				ResolutionDescription -> "Automatically set to Model[Instrument, ControlledRateFreezer, \"VIA Freeze Research\"] if FreezingStrategy is set to ControlledRateFreezer. Otherwise, automatically set to a Model[Instrument, Freezer] maintained at -80 Celsius. In order to maximize the efficiency of freezer storage in the laboratory, user specification of a particular Object[Instrument, Freezer] is not supported.",
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
				Widget -> Alternatives[
					"Storage Type" -> Widget[
						Type -> Enumeration,
						Pattern :> CellStorageTypeP
					],
					"Storage Object" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]]
					]
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
				Pattern :> RangeP[0 Minute, $MaxExperimentTime],
				Units -> {Hour, {Minute, Hour, Day}}
			],
			Description -> "The duration for which the cell stock(s) within an insulated cooler are kept within the Freezer to freeze the cells prior to being transported to SamplesOutStorageCondition.",
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
		ClearMemoization[Experiment`Private`simulateSamplePreparationPacketsNew];
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
		outputSpecification, output, gatherTests, messages, listedSamples, listedOptions, mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed,
		updatedSimulation, validSamplePreparationResult, safeOpsNamed, safeOpsTests, mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples,
		validLengths, validLengthTests, templatedOptions, templateTests, inheritedOptions, upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, expandedSafeOps,

		(* Download *)
		optionsWithObjects, objectsFromOptions, defaultSampleModels, defaultContainerModels, defaultInstrumentModels, allPotentialSamples, allPotentialContainers,
		allPotentialInstruments, sampleObjects, modelSampleObjects, instrumentObjects, modelInstrumentObjects, objectContainerObjects, modelContainerObjects,
		modelFreezerFields, modelControlledRateFreezerFields, modelCentrifugeFields, objectSampleFields, modelSampleFields, objectContainerFields, modelContainerFields,
		modelInstrumentFields, cellModelFields, downloadedCache, parentProtocolStack, cacheBall,

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
	defaultInstrumentModels = Experiment`Private`freezeCellsInstrumentSearch["Memoization"];

	(* Gather all of the objects which may contain samples, containers, and instruments. *)
	allPotentialSamples = DeleteDuplicates[Link[Flatten[{mySamplesWithPreparedSamples, objectsFromOptions, defaultSampleModels}]]];
	allPotentialContainers = DeleteDuplicates[Link[Flatten[{objectsFromOptions, defaultContainerModels}]]];
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
			{Null, Null}
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
Error::FreezeCellsUnsupportedCellType = "The CellType option of sample `1` at indices `2` is set to `3`. Currently, only Mammalian, Bacterial and Yeast cell culture are supported. Please contact us if you have a sample that falls outside our current support.";
Error::FreezeCellsUnsupportedCultureAdhesion = "The CultureAdhesion option of sample `1` at indices `2` is set to `3`. Currently, only Suspension samples are supported for ExperimentFreezeCells. Please contact us if you have a sample that falls outside our current support.";
Error::InvalidChangeMediaSamples = "Sample(s) `1` are found in the same container as input sample(s) `2` but they are not specified as input samples. Since a plate is pelleted as a whole during media change, please transfer sample(s) into an empty container beforehand.";
(* Invalid Options *)
Warning::FreezeCellsAliquotingRequired = "`2`. `1`.";
Warning::FreezeCellsReplicateLabels = "The NumberOfReplicates option is set to `1`, so each of the input samples will be partitioned into `1` identical samples with the following unique CryogenicSampleContainerLabels: `2`";
Warning::FreezeCellsUnknownCellType = "The sample(s) `1` at indices `2` have no CellType specified in the options or Object. For these sample(s), the CellType is defaulting to Bacterial. If this is not desired, please specify a CellType.";
Warning::FreezeCellsUnknownCultureAdhesion = "The sample(s) `1` at indices `2` have no CultureAdhesion specified in the options or Object. For these sample(s), the CultureAdhesion is defaulting to Suspension. If this is not desired, please specify a CultureAdhesion. Note that ExperimentFreezeCells only supports Suspension cell samples at this time.";
Warning::FreezeCellsUnusedSample = "The sample(s) `1` are expected to have a total volume of `2` prior to aliquoting, factoring in any media change. Currently, the AliquotVolume is set to `3` and the NumberOfReplicates option is set to `4`. Under these conditions, `5` of the sample(s) will not be aliquoted and will therefore not be frozen. Consider adjusting the AliquotVolume and/or the NumberOfReplicates to increase the amount of sample that will be frozen in the protocol.";
Error::ConflictingChangeMediaOptionsForSameContainer = "`1` during media changing step, but are in the same container as another sample. For these sample(s), either transfer to separate containers, allow the cell pelleting in individual containers, or ensure that all samples in the same container have identical cell pellet settings.";
Error::CryogenicVialAliquotingRequired = "`2`. `1`. Please set Aliquot be True.";
Error::FreezeCellsConflictingTemperatureProfile = "The FreezingStrategy option is set to `1`, but the TemperatureProfile option is specified as `2`. Please specify the TemperatureProfile option if and only if the FreezingStrategy is ControlledRateFreezer in order to submit a valid experiment.";
Error::ConflictingCryoprotectantSolutionTemperature = "The CryoprotectantSolutionTemperature is set to `1`, but the CryoprotectionStrategy is None at all indices. Please adjust these options such that the CryoprotectantSolutionTemperature is specified if and only if the CryoprotectionStrategy is set to ChangeMedia or AddCryoprotectant for at least one index.";
Error::FreezeCellsConflictingAliquotOptions = "The sample(s) `1` at indices `4` have the Aliquot option set to `3` while the AliquotVolume option is `4`. Please adjust these options such that Aliquot is True if and only if AliquotVolume is specified in order to submit a valid experiment.";
Error::FreezeCellsReplicatesAliquotRequired = "`3`, Aliquot is required. The sample(s) `1` have Aliquot option set to False. `2`. Please set the Aliquot option to True or allow the option to set automatically in order to submit a valid experiment.";
Error::InsufficientVolumeForAliquoting = "The sample(s) `1` at indices `2` have the AliquotVolume option set to `3` for a total number of `4` cryogenic sample containers. When the NumberOfReplicates is 2 or greater, or when they are duplicated manually in inputs, please specify the AliquotVolume as a volume quantity or allow the option to set automatically in order to submit a valid experiment.";
Error::CryoprotectantSolutionOverfill = "The container(s) of sample(s) `1` at indices `5` would have total volume(s) `3` upon addition of CryoprotectantSolutionVolume `2`. This would result in overflowing the sample input container(s) factoring in any media removal, which have MaxVolume(s) of `4`. Please either decrease the CryoprotectantSolutionVolume or increase the CellPelletSupernatantVolume in order to submit a valid experiment.";
Error::ExcessiveCryogenicSampleVolume = "Under the currently specified experimental conditions, the cell stocks being prepared for sample(s) `1` at indices `5` would have total volume(s) `3`, which exceeds 75% of the MaxVolume of `4` of the CryogenicSampleContainers `2`. Consider using the NumberOfReplicates option to distribute the cell sample(s) across multiple CryogenicSampleContainers. Note that the largest CryogenicVial kept in stock at ECL is Model[Container, Vessel, \"id:o1k9jAG1Nl57\"], with a MaxVolume of 5 Milliliter.";
Error::UnsuitableCryogenicSampleContainerFootprint = "The container model of CryogenicSampleContainer(s) `2` specified for the sample(s) `1` at indices `4` have Footprint(s) equal to `3`. Please either specify a container whose Footprint is CryogenicVial or allow the CryogenicSampleContainer option to set automatically in order to submit a valid experiment.";
Error::UnsuitableFreezingRack = "The FreezingRack(s) `2` specified for the sample(s) `1` at indices `4` are not a rack for cryogenic vials. Please either specify a FreezingRack from `3` or allow the FreezingRack option to set automatically in order to submit a valid experiment.";
Error::FreezeCellsUnsupportedFreezerModel = "The sample(s) `1` at indices `4` have the Freezer option set to `2` whose DefaultTemperature is `3`. When FreezingStrategy is InsulatedCooler, all static temperature Freezer Models must have a DefaultTemperature within 5 Celsius of -80 Celsius or -20 Celsius. Please select a different Freezer or allow the option to set automatically in order to submit a valid experiment.";
Error::FreezeCellsConflictingHardware = "The sample(s) `1` at indices `6` have the `2` option set to `3` and the `4` option set to `5`. Please adjust these options or allow them to set automatically such that the Freezer, FreezingRack, and CryogenicSampleContainer options are compatible with each other and with the FreezingStrategy.";
Error::FreezeCellsConflictingCellType = "The sample(s) `1` at indices `4` have the CellType option specified as `2` while the CellType(s) of the sample(s) are `3`. For these sample(s), please specify the same CellType as the sample(s) or allow the option to set automatically.";
Error::FreezeCellsConflictingCultureAdhesion = "The sample(s) `1` at indices `4` have the CultureAdhesion option specified as `2` while the CultureAdhesion(s) of the sample(s) are `3`. For these sample(s), please specify the same CultureAdhesion as the sample(s) or allow the option to set automatically.";
Error::FreezeCellsConflictingInsulatedCoolerFreezingTime = "The FreezingStrategy option is set to `1`, but the InsulatedCoolerFreezingTime option is specified as `2`. Please specify the InsulatedCoolerFreezingTime option if and only if the FreezingStrategy is InsulatedCooler in order to submit a valid experiment.";
Error::FreezeCellsConflictingCoolant = "The sample(s) `1` at indices `4` have the Coolant option specified as `2` while the FreezingStrategy option is specified as `3`. Please specify the Coolant option if and only if the FreezingStrategy is InsulatedCooler in order to submit a valid experiment.";
Error::FreezeCellsUnsupportedTemperatureProfile = "The specified TemperatureProfile `1` is invalid since `2`. Please adjust the TemperatureProfile in order to submit a valid experiment.";
Error::FreezeCellsInsufficientChangeMediaOptions = "The sample(s) `1` at indices `3` have the CryoprotectionStrategy option set to ChangeMedia, but the option(s) `2` are specified as Null for the sample(s). Please specify the option(s) or allow the options to set automatically in order to submit a valid experiment.";
Error::FreezeCellsExtraneousChangeMediaOptions = "The sample(s) `1` at indices `5` have the CryoprotectionStrategy option set to `2`, but the option(s) `3` are specified as `4` for the sample(s). Please specify the option(s) as Null or allow the options to set automatically in order to submit a valid experiment.";
Error::FreezeCellsInsufficientCryoprotectantOptions = "The sample(s) `1` at indices `5` have the CryoprotectionStrategy option set to `2`, but the option(s) `3` are specified as `4` for the sample(s). Please specify the option(s) or allow the options to set automatically in order to submit a valid experiment.";
Error::FreezeCellsExtraneousCryoprotectantOptions = "The sample(s) `1` at indices `4` have the CryoprotectionStrategy option set to None, but the option(s) `2` are specified as `3` for the sample(s). Please specify the option(s) as Null or allow the options to set automatically in order to submit a valid experiment.";
Error::FreezeCellsNoCompatibleCentrifuge = "The sample(s) `1` at indices `5` are in container Model(s) `2` with the CellPelletIntensity option set to `3` and the CellPelletTime option set to `4`. No centrifuge instrument currently at ECL is compatible with this combination of container and options. Please adjust the options or transfer the sample to a different container as needed. Consider using the function CentrifugeDevices[] to learn more about available centrifuge instruments and their capabilities.";
Error::TooManyControlledRateFreezerBatches = "Under the currently specified experimental conditions with `1` unique input samples and the NumberOfReplicates option set to `2`, `3` total samples will be frozen in this protocol, which exceeds the maximum capacity (48 samples) of a single rack for the ControlledRateFreezer instrument. As such, the experiment requires `4` cell freezing batches. Due to equipment and time constraints, a single protocol is limited to no more than one freezing batch when the FreezingStrategy is ControlledRateFreezer. Please distribute the samples across multiple protocols such that multiple batches are not required.";
Error::TooManyInsulatedCoolerBatches = "Under the currently specified experimental conditions, FreezingStrategy is set to InsulatedCooler and `7` total FreezingRacks are required. Due to equipment and time constraints, a single protocol is limited to no more than three batches utilizing the InsulatedCooler strategy. The current experiment, if allowed, would require FreezingRacks of type `1`, which have a maximum capacity of `2` samples per rack including replicates. Because there are currently `3` unique sets of freezing conditions with `4` unique input samples each, and the NumberOfReplicates option is set to `5`, the sample count in each type of FreezingRack is `6`. Please distribute the samples across multiple protocols or adjust the Coolant, Freezer, and FreezingRack options (or allow these to set automatically) to improve the consolidation of batches such that no more than three batches are required.";


(* ::Subsubsection::Closed:: *)
(*resolveExperimentFreezeCellsOptions *)

DefineOptions[
	resolveExperimentFreezeCellsOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveExperimentFreezeCellsOptions[mySamples: {ObjectP[Object[Sample]]...}, myOptions: {_Rule...}, myResolutionOptions: OptionsPattern[resolveExperimentFreezeCellsOptions]] := Module[
	{
		(* Setup and pre-resolve options *)
		outputSpecification, output, gatherTests, messages, notInEngine, cacheBall, simulation, fastAssoc,  confirm, canaryBranch, template,
		fastTrack, operator, parentProtocol, upload, outputOption, samplePackets, sampleModelPackets, sampleContainerPackets,
		sampleContainerModelPackets, fastAssocKeysIDOnly, staticFreezerModelPackets, controlledRateFreezerPackets,
		controlledRateFreezerModelPackets, centrifugeModelPackets, freezingRackModelPackets, allPossibleFreezingRacks,
		expandedSuppliedOptions, resolvedNumberOfReplicates, numericNumberOfReplicates, resolvedCryogenicSampleContainerLabels,
		expandedSuppliedAliquot, expandedSuppliedAliquotVolume, expandedSuppliedCryogenicSampleContainers,
		expandedSuppliedCryoprotectantSolutionVolumes, expandedSuppliedCryoprotionStrategies, expandedSuppliedCentrifugues,
		expandedSuppliedPelletTimes, expandedSuppliedCentrifugeIntensities, expandedSuppliedSupernatantVolumes, userSpecifiedLabels,
		resolvedCryoprotectionStrategies, specifiedAliquotQs, semiresolvedInSitus, resolvedFreezingStrategy, resolvedInSitus,
		resolvedAliquotBools, talliedSamplesWithStrategies, uniqueSampleToFinalCellStockNumsLookup, preResolvedLabels,
		correctNumberOfReplicates,

		(* Input invalidation check *)
		discardedSamplePackets, discardedInvalidInputs, discardedTest, deprecatedSampleModelPackets, deprecatedSampleModelInputs,
		deprecatedSampleInputs, deprecatedTest, mainCellIdentityModels, sampleCellTypes, validCellTypeQs, invalidCellTypeSamples,
		invalidCellTypeIndices, invalidCellTypeCellTypes, invalidCellTypeTest, sampleCultureAdhesions, invalidCultureAdhesionIndices,
		invalidCultureAdhesionSamples, invalidCultureAdhesionValues, invalidCultureAdhesionTest, duplicateSamples, duplicateSamplesTest,
		inputContainerContents, stowawaySamples, invalidPlateSampleInputs, invalidPlateSampleTest,

		(* Option precision check *)
		freezeCellsOptionsAssociation, roundedFreezeCellsOptions, precisionTests,

		(* Pre-MapThread option resolutions *)
		resolvedPreparation, resolvedInsulatedCoolerFreezingTime, resolvedTemperatureProfile, resolvedCryoprotectantSolutionTemperature,
		resolvedGeneralOptions,

		(* Conflicting Options Checks I *)
		freezeCellsAliquotingRequiredCases, conflictingAliquotingErrors, conflictingAliquotingCases, conflictingAliquotingTest,
		conflictingTemperatureProfileCases, conflictingTemperatureProfileTest, conflictingCryoprotectantSolutionTemperatureCases,
		conflictingCryoprotectantSolutionTemperatureTest, conflictingInsulatedCoolerFreezingTimeCases, conflictingInsulatedCoolerFreezingTimeTest,

		(* MapThread options and errors *)
		mapThreadFriendlyOptions, resolvedCellTypes, resolvedCultureAdhesions, resolvedCellPelletIntensities, resolvedCellPelletTimes,
		resolvedCellPelletSupernatantVolumes, resolvedCryoprotectantSolutions, resolvedCryoprotectantSolutionVolumes,
		resolvedFreezers, resolvedFreezingRacks, resolvedCryogenicSampleContainers, resolvedAliquotVolumes, resolvedCoolants,
		resolvedSamplesOutStorageConditions, conflictingCellTypeBools, cellTypeNotSpecifiedBools, conflictingCultureAdhesionBools,
		overAspirationErrors, invalidRackBools, overFillDestinationErrors, overFillSourceErrors, cultureAdhesionNotSpecifiedBools,
		aliquotVolumeQuantities, containerInVolumesBeforeAliquoting,

		(* Post-MapThread option resolutions *)
		centrifugeIndices, containerModelsAtCentrifugeIndices, specifiedCentrifugesForChangeMedia, possibleCentrifuges,
		noCompatibleCentrifugeIndices, centrifugesRankedByPreference, preResolvedCellPelletCentrifuges, resolvedCellPelletCentrifuges,
		email, resolvedOptions, resolvedMapThreadOptions, talliedSampleWithVolume, uniqueSampleToUsedVolLookup,

		(* Conflicting Options Checks II *)
		replicatesQ, replicateLabelWarningString, unknownCellTypeCases, unknownCultureAdhesionCases, unusedSampleCases,
		conflictingAliquotOptionsCases, conflictingAliquotOptionsTest, replicatesWithoutAliquotCases, replicatesWithoutAliquotTest,
		aliquotVolumeReplicatesMismatchCases, aliquotVolumeReplicatesMismatchTest, overaspirationTest, overaspirationWarnings,
		cryoprotectantSolutionOverfillCases, cryoprotectantSolutionOverfillTest, excessiveCryogenicSampleVolumeCases,
		excessiveCryogenicSampleVolumeTest, unsuitableCryogenicSampleContainerErrors, unsuitableCryogenicSampleContainerCases,
		unsuitableCryogenicSampleContainerTest, unsuitableFreezingRackCases, unsuitableFreezingRackTest, resolvedFreezingRackModels,
		resolvedFreezerModels, unsupportedFreezerCases, unsupportedFreezerTest, conflictingHardwareCases, conflictingHardwareTest,
		conflictingCellTypeCases, conflictingCellTypeTest, conflictingCultureAdhesionCases, conflictingCultureAdhesionTest,
		conflictingCoolantCases, conflictingCoolantTest, unsupportedTemperatureProfileCases, unsupportedTemperatureProfileTest,
		insufficientChangeMediaOptionsCases, insufficientChangeMediaOptionsTest, extraneousChangeMediaOptionsCases,
		extraneousChangeMediaOptionsTest, insufficientCryoprotectantOptionsCases, insufficientCryoprotectantOptionsTest,
		extraneousCryoprotectantOptionsCases, extraneousCryoprotectantOptionsTest, noCompatibleCentrifugeCases,
		noCompatibleCentrifugeTest, groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer,
		samplesWithSameContainerConflictingOptions, samplesWithSameContainerConflictingErrors,
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

	(* Get the options that do not need to be resolved directly from SafeOptions. *)
	{confirm, canaryBranch, template, fastTrack, operator, parentProtocol, upload, outputOption} = Lookup[
		myOptions,
		{Confirm, CanaryBranch, Template, FastTrack, Operator, ParentProtocol, Upload, Output}
	];

	(* Pull out packets from the fast association *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	sampleModelPackets = fastAssocPacketLookup[fastAssoc, #, Model]& /@ mySamples;
	sampleContainerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;
	sampleContainerModelPackets = fastAssocPacketLookup[fastAssoc, #, {Container, Model}]& /@ mySamples;

	(* Build all packets which can be safely matched on the Type. *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
	staticFreezerModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, Freezer]]];
	controlledRateFreezerPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Object[Instrument, ControlledRateFreezer]]];
	controlledRateFreezerModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, ControlledRateFreezer]]];
	centrifugeModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Instrument, Centrifuge]]];
	freezingRackModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ Cases[fastAssocKeysIDOnly, ObjectP[Model[Container, Rack]]];
	allPossibleFreezingRacks = Lookup[Cases[freezingRackModelPackets, KeyValuePattern[{Footprint -> ControlledRateFreezerRack|MrFrostyRack}]], Object];

	expandedSuppliedOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFreezeCells, KeyDrop[myOptions, {Simulation, Cache}]];
	(* Pull out some supplied option values to help determining index-matching master switches *)
	{
		expandedSuppliedAliquot,
		expandedSuppliedAliquotVolume,
		expandedSuppliedCryogenicSampleContainers,
		expandedSuppliedCryoprotectantSolutionVolumes,
		expandedSuppliedCryoprotionStrategies,
		expandedSuppliedCentrifugues,
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
		Which[
			(* If the user specified the option at this index, use the specified value. *)
			MatchQ[#1, Except[Automatic]],
				#1,
			(* If any of the changeMediaOptionSet are specified, set this to ChangeMedia. *)
			MemberQ[{#2, #3, #4, #5}, Except[Automatic | Null]],
				ChangeMedia,
			(* Otherwise, default to AddCryoprotectant. *)
			True,
				AddCryoprotectant
		]&,
		{
			expandedSuppliedCryoprotionStrategies,
			expandedSuppliedCentrifugues,
			expandedSuppliedPelletTimes,
			expandedSuppliedCentrifugeIntensities,
			expandedSuppliedSupernatantVolumes
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
				(*5*)suppliedCryogenicSampleContainer
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
				MatchQ[suppliedCryogenicSampleContainer, Except[Automatic]] && !MatchQ[suppliedCryogenicSampleContainer, ObjectP[{Lookup[sampleContainerPacket, Object], Lookup[sampleContainerModelPacket, Object]}]],
					True,
				(* Otherwise, we set it as Automatic for now. *)
				True,
					Automatic
			]
		],
		{
			(*1*)sampleContainerPackets,
			(*2*)sampleContainerModelPackets,
			(*3*)expandedSuppliedAliquot,
			(*4*)expandedSuppliedAliquotVolume,
			(*5*)expandedSuppliedCryogenicSampleContainers
		}
	];

	semiresolvedInSitus = MapThread[
		Function[
			{
				(*1*)samplePacket,
				(*2*)sampleContainerModelPacket,
				(*3*)specifiedAliquotQ,
				(*4*)suppliedCryoprotectantSolutionVolume,
				(*5*)suppliedSupernatantVolume,
				(*6*)suppliedCryoprotionStrategy
			},
			Which[
				(* If the user specified the Aliquot related options at this index as True, set this to False. *)
				MatchQ[specifiedAliquotQ, BooleanP],
					!specifiedAliquotQ,
				(* or the input container does not have CryogenicVial as footprint, set this to False *)
				!MatchQ[Lookup[sampleContainerModelPacket, Footprint], CryogenicVial],
					False,
				(* If CryoprotectionStrategy is ChangeMedia, and the specified CryoprotectantSolutionVolume with remaining sample after aspiration is exceeding 75% of the sample's input container, set this to False *)
				(* Here we assume the SampleVolume is informed, since FreezeCellsUnsupportedCultureAdhesion will catch the case where input sample is solid media *)
				And[
					MatchQ[suppliedCryoprotionStrategy, ChangeMedia],
					MatchQ[Lookup[samplePacket, Volume], VolumeP],
					Or[
						(* If CryoprotectantSolutionVolume is not specified, precalculate with the sample volume *)
						!MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP] && GreaterQ[Lookup[samplePacket, Volume], 0.75*Lookup[sampleContainerModelPacket, MaxVolume]],
						(* If SupernatantVolume is All or Automatic, assume all existing media is aspirated *)
						MatchQ[suppliedCryoprotectantSolutionVolume, Except[Automatic|Null]] && !MatchQ[suppliedSupernatantVolume, VolumeP] && GreaterQ[suppliedCryoprotectantSolutionVolume, 0.75*Lookup[sampleContainerModelPacket, MaxVolume]],
						(* Precalucalte the resuspended sample volume with CryoprotectantSolutionVolume, SupernatantVolume and SampleVolume *)
						MatchQ[suppliedCryoprotectantSolutionVolume, Except[Automatic|Null]] && MatchQ[suppliedSupernatantVolume, VolumeP] && GreaterQ[Lookup[samplePacket, Volume] - suppliedSupernatantVolume + suppliedCryoprotectantSolutionVolume, 0.75*Lookup[sampleContainerModelPacket, MaxVolume]]
					]
				],
					False,
				(* If CryoprotectionStrategy is AddCryoprotectant, the specified CryoprotectantSolutionVolume plus original sample volume is exceeding 75% of the sample's input container, set this to False *)
				(* Here we assume the SampleVolume is informed, since FreezeCellsUnsupportedCultureAdhesion will catch the case where input sample is solid media *)
				And[
					MatchQ[suppliedCryoprotionStrategy, AddCryoprotectant],
					MatchQ[Lookup[samplePacket, Volume], VolumeP],
					Or[
						(* If CryoprotectantSolutionVolume is not specified, precalculate as 50% of with the sample volume *)
						!MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP] && GreaterQ[1.5*Lookup[samplePacket, Volume], 0.75*Lookup[sampleContainerModelPacket, MaxVolume]],
						(* Precalucalte the cell sample with cryoprotectant added total volume with CryoprotectantSolutionVolume and SampleVolume *)
						MatchQ[suppliedCryoprotectantSolutionVolume, VolumeP] && GreaterQ[Lookup[samplePacket, Volume] + suppliedCryoprotectantSolutionVolume, 0.75*Lookup[sampleContainerModelPacket, MaxVolume]]
					]
				],
					False,
				(* If CryoprotectionStrategy is None, check if original sample volume is exceeding 75% of the sample's input container, set this to False *)
				(* Here we assume the SampleVolume is informed, since FreezeCellsUnsupportedCultureAdhesion will catch the case where input sample is solid media *)
				And[
					MatchQ[Lookup[samplePacket, Volume], VolumeP],
					GreaterQ[Lookup[samplePacket, Volume], 0.75*Lookup[sampleContainerModelPacket, MaxVolume]]
				],
					False,
				(* Otherwise, we can freeze input sample at this index inside of its original container. *)
				True,
					Automatic
			]
		],
		{
			(*1*)samplePackets,
			(*2*)sampleContainerModelPackets,
			(*3*)specifiedAliquotQs,
			(*4*)expandedSuppliedCryoprotectantSolutionVolumes,
			(*5*)expandedSuppliedSupernatantVolumes,
			(*6*)resolvedCryoprotectionStrategies
		}
	];

	(* Resolve the FreezingStrategy *)
	resolvedFreezingStrategy = Which[
		(* If the user specified it, use the user-specified value. *)
		MatchQ[Lookup[myOptions, FreezingStrategy], Except[Automatic]],
			Lookup[myOptions, FreezingStrategy],
		(* If the user specified a TemperatureProfile, set this to ControlledRateFreezer. *)
		MatchQ[Lookup[myOptions, TemperatureProfile], Except[Automatic]],
			ControlledRateFreezer,
		(* If the user specified an InsulatedCoolerFreezingTime or any Coolants, set this to InsulatedCooler. *)
		MemberQ[
			{
				MatchQ[Lookup[myOptions, InsulatedCoolerFreezingTime], Except[Automatic]],
				MemberQ[Lookup[myOptions, Coolant], Except[Automatic]]
			},
			True
		],
			InsulatedCooler,
		(* If the user specified a ControlledRateFreezer instrument Object or Model for the Freezer option, set this to ControlledRateFreezer. *)
		MatchQ[
			Lookup[myOptions, Freezer],
			ObjectP[{Object[Instrument, ControlledRateFreezer], Model[Instrument, ControlledRateFreezer]}]
		],
			ControlledRateFreezer,
		(* If the user specified a static temperature freezer instrument Object or Model for the Freezer option, set this to InsulatedCooler. *)
		MemberQ[
			Lookup[myOptions, Freezer],
			ObjectP[{Object[Instrument, Freezer], Model[Instrument, Freezer]}]
		],
			InsulatedCooler,
		(* If the user specified a FreezingRack with an InsulatedCooler subtype, set this to InsulatedCooler. *)
		MemberQ[
			Lookup[myOptions, FreezingRack],
			ObjectP[{Object[Container, Rack, InsulatedCooler], Model[Container, Rack, InsulatedCooler]}]
		],
			InsulatedCooler,
		(* If the user specified a FreezingRack WITHOUT an InsulatedCooler subtype, set this to ControlledRateFreezer. *)
		And[
			MemberQ[
				Lookup[myOptions, FreezingRack],
				ObjectP[{Object[Container, Rack], Model[Container, Rack]}]
			],
			!MemberQ[
				Lookup[myOptions, FreezingRack],
				ObjectP[{Object[Container, Rack, InsulatedCooler], Model[Container, Rack, InsulatedCooler]}]
			]
		],
			ControlledRateFreezer,
		(* If the user specified a CryogenicSampleContainer model larger than 2 Milliliter, set this to InsulatedCooler. *)
		(* If InSitu is not False and sample Container model is larger than 2 Milliliter, set this to InsulatedCooler. *)
		(* This is because we can't fit vials larger than 2 Milliliter in the VIA Freeze. *)
		Or[
			MemberQ[Lookup[myOptions, CryogenicSampleContainer], ObjectP[Model[Container, Vessel, "id:o1k9jAG1Nl57"]]], (*5mL Cryogenic Vial*)
			MemberQ[PickList[Lookup[sampleContainerModelPackets, Object], semiresolvedInSitus, True], ObjectP[Model[Container, Vessel, "id:o1k9jAG1Nl57"]]]
		],
			InsulatedCooler,
		(* Otherwise, default to ControlledRateFreezer. *)
		True,
			ControlledRateFreezer
	];

	(* Resolve InSitu *)
	resolvedInSitus = Map[
		Which[
			(* If we have preresolved value, use it. *)
			MatchQ[#, Except[Automatic]],
				#,
			(* If FreezingStrategy is ControlledRateFreezer and input container is 5mL Cryogenic Vial *)
			And[
				MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
				MemberQ[Lookup[sampleContainerModelPackets, Object], ObjectP[Model[Container, Vessel, "id:o1k9jAG1Nl57"]]](*5mL Cryogenic Vial*)
			],
				False,
			True,
				True
		]&,
		semiresolvedInSitus
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
					Which[
						(* If the label is Null, just keep it *)
						MatchQ[sampleLabel, Null],
						sampleLabel,
						(* Otherwise, designate it as a replicate *)
						True,
						(sampleLabel <> " replicate " <> ToString[replicateNumber])
					]
				],
				{expandedCryogenicSampleContainerLabels, Flatten[ConstantArray[Range[numericNumberOfReplicates], Length[preResolvedLabels]]]}
			]
		]
	];

	correctNumberOfReplicates = If[
		And[
			MatchQ[preResolvedLabels, {_String..}],
			AllTrue[preResolvedLabels, StringContainsQ[#, "replicate "]&],
			AnyTrue[preResolvedLabels, StringContainsQ[#, "replicate 2"]&]
		],
		(* If we're running MCP with a FreezeCells unit operation as input, we have auto-expanded labels and we can extract the number from these. *)
		Max@ToExpression[StringSplit[#, "replicate "][[-1]] & /@ preResolvedLabels],
		(* Otherwise, we haven't resolved any options yet, and we should only have an integer if the user specified it. *)
		numericNumberOfReplicates
	];

	(*-- INPUT VALIDATION CHECKS --*)
	(* 1. Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];
	discardedInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall, Simulation -> simulation]];
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

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedSampleModelInputs] > 0 && messages,
		Message[Error::DeprecatedModels, ObjectToString[deprecatedSampleModelInputs, Cache -> cacheBall, Simulation -> simulation]];
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
	invalidCellTypeIndices = First /@ Position[validCellTypeQs, False];
	invalidCellTypeCellTypes = PickList[sampleCellTypes, validCellTypeQs, False];

	If[Length[invalidCellTypeSamples] > 0 && messages,
		Message[Error::FreezeCellsUnsupportedCellType, ObjectToString[invalidCellTypeSamples, Cache -> cacheBall, Simulation -> simulation], invalidCellTypeIndices, invalidCellTypeCellTypes]
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

	(* 4. Get whether the input culture adhesions are supported *)

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
	invalidCultureAdhesionIndices = Flatten @ Position[sampleCultureAdhesions, Alternatives[Adherent, SolidMedia]];
	invalidCultureAdhesionSamples = mySamples[[invalidCultureAdhesionIndices]];
	invalidCultureAdhesionValues = sampleCultureAdhesions[[invalidCultureAdhesionIndices]];

	If[MatchQ[Length[invalidCultureAdhesionSamples], GreaterP[0]] && messages,
		Message[Error::FreezeCellsUnsupportedCultureAdhesion, ObjectToString[invalidCultureAdhesionSamples, Cache -> cacheBall, Simulation -> simulation], invalidCultureAdhesionIndices, invalidCultureAdhesionValues]
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

	(* 5. Throw an error if we have duplicated samples provided for some cases, but allow it if the original samples are aliquoted before further treatment (i.g. pelleting, freezing). *)
	(* and at least one option if different from each other. We allow reusing the same samples for several cases: *)
	(* Case1: NumberOfReplicates is set to a number. In this case, all options are the same *)
	(* Case2: the same sample go through different option sets. In this case, ChangeMedia can not be specified as CryoprotectionStrategy. *)
	(* Case3: Any combination of case1 and case2 *)
	duplicateSamples = Map[
		Function[{uniqueSample},
			Which[
				(* If there the number Of the same sample with the same specified option set is larger than the numberOfReplica, this is not possible for FreezeCells experiment *)
				(* Basically, we need to differentiate between expanded inputs from framework and use-specified duplicated inputs *)
				GreaterQ[Max[Cases[Tally[Transpose@{mySamples, KeyDrop[expandedSuppliedOptions, CryogenicSampleContainerLabel]}], {{ObjectP[uniqueSample], _}, _}][[All, 2]]], correctNumberOfReplicates],
					uniqueSample,
				(* If there the number Of ChangeMedia is larger than the numberOfReplica, this is not possible for FreezeCells experiment *)
				GreaterQ[Total[Cases[talliedSamplesWithStrategies, {{ObjectP[uniqueSample], ChangeMedia}, count_}:>count]], correctNumberOfReplicates],
					uniqueSample,
				(* If besides ChangeMedia, there is another strategy, this is not possible for FreezeCells experiment since ChangeMedia pellet all the sample before aliquotting *)
				And[
					MemberQ[talliedSamplesWithStrategies, {{ObjectP[uniqueSample], ChangeMedia}, _Integer}],
					MemberQ[talliedSamplesWithStrategies,  {{ObjectP[uniqueSample], Except[ChangeMedia]}, _Integer}]
				],
					uniqueSample,
				True,
					Nothing
			]
		],
		DeleteDuplicates@mySamples
	];

	If[Length[duplicateSamples] > 0 && messages,
		Message[Error::DuplicatedSamples, ObjectToString[duplicateSamples, Cache -> cacheBall, Simulation -> simulation], "ExperimentFreezeCells"]
	];

	duplicateSamplesTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[duplicateSamples] == 0,
				Nothing,
				Test["The input samples " <> ObjectToString[duplicateSamples, Cache -> cacheBall, Simulation -> simulation] <> " have not been specified more than once if using it all:", True, False]
			];

			passingTest = If[Length[invalidCellTypeSamples] == Length[mySamples],
				Nothing,
				Test["The input samples " <> ObjectToString[Complement[mySamples, duplicateSamples], Cache -> cacheBall, Simulation -> simulation] <> " have not been specified in more than one freezing strategy if using it all:", True, True]
			];

			{failingTest, passingTest}
		]
	];

	(* 6. Get whether there are stowaway samples inside the input plates. We're forbidding users from pelleting samples when there are other samples in the plate already *)
	inputContainerContents = Lookup[sampleContainerPackets, Contents, {}];
	stowawaySamples = MapThread[
		Function[{sample, contents},
			Module[{allChangeMediaSamples, contentsObjects},
				allChangeMediaSamples = Cases[talliedSamplesWithStrategies, {{changeMediaSample_, ChangeMedia}, _}:>changeMediaSample];
				contentsObjects = Download[contents[[All, 2]], Object];
				If[MemberQ[allChangeMediaSamples, ObjectP[sample]],
					Select[contentsObjects, Not[MemberQ[allChangeMediaSamples, ObjectP[#]]]&],
					{}
				]
			]
		],
		{mySamples, inputContainerContents}
	];
	invalidPlateSampleInputs = Lookup[
		PickList[samplePackets, stowawaySamples, Except[{}]],
		Object,
		{}
	];

	If[Length[invalidPlateSampleInputs] > 0 && messages,
		Message[Error::InvalidChangeMediaSamples, ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]& /@ DeleteCases[stowawaySamples, {}], ObjectToString[invalidPlateSampleInputs, Cache -> cacheBall, Simulation -> simulation]]
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

	(* Combine the original options with resolved options so far *)
	freezeCellsOptionsAssociation = Join[
		(* dropping these two keys because they are often huge and make variables unnecessarily take up memory + become unreadable *)
		KeyDrop[Association[myOptions], {Cache, Simulation, InSitu, CryoprotectionStrategy, FreezingStrategy}],
		<|
			NumberOfReplicates -> resolvedNumberOfReplicates,
			Aliquot -> resolvedAliquotBools,
			CryoprotectionStrategy -> resolvedCryoprotectionStrategies,
			FreezingStrategy -> resolvedFreezingStrategy
		|>
	];

	(*--- OPTION PRECISION CHECKS ---*)
	(* Round the options that have precision. *)
	{roundedFreezeCellsOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[
			freezeCellsOptionsAssociation,
			{CellPelletTime, InsulatedCoolerFreezingTime, CellPelletSupernatantVolume, CryoprotectantSolutionVolume, AliquotVolume},
			{1 Minute, 1 Minute, 1 Microliter, 1 Microliter, 1 Microliter},
			Output -> {Result, Tests}
		],
		{
			RoundOptionPrecision[
				freezeCellsOptionsAssociation,
				{CellPelletTime, InsulatedCoolerFreezingTime, CellPelletSupernatantVolume, CryoprotectantSolutionVolume, AliquotVolume},
				{1 Minute, 1 Minute, 1 Microliter, 1 Microliter, 1 Microliter}
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
		MatchQ[Lookup[roundedFreezeCellsOptions, CryoprotectantSolutionTemperature], Except[Automatic]], Lookup[roundedFreezeCellsOptions, CryoprotectantSolutionTemperature],
		(* Set this to Null if the CryoprotectionStrategy is None at all indices. *)
		!MemberQ[resolvedCryoprotectionStrategies, Except[None]], Null,
		(* Otherwise, default to Chilled. *)
		True, Chilled
	];

	(* Gather the resolved options above together in a list. *)
	resolvedGeneralOptions = {
		Preparation -> resolvedPreparation,
		NumberOfReplicates -> resolvedNumberOfReplicates,
		Aliquot -> resolvedAliquotBools,
		CryoprotectionStrategy -> resolvedCryoprotectionStrategies,
		FreezingStrategy -> resolvedFreezingStrategy,
		InsulatedCoolerFreezingTime -> resolvedInsulatedCoolerFreezingTime,
		TemperatureProfile -> resolvedTemperatureProfile,
		CryoprotectantSolutionTemperature -> resolvedCryoprotectantSolutionTemperature
	};

	(*--- CONFLICTING OPTIONS CHECKS I ---*)
	(*Warning::FreezeCellsAliquotingRequired*)
	(* 1. Throw a warning if Aliquot automatically resolves to True at any index while non related Aliquot options were specified. *)
	(* Note if Aliquot, AliquotVolume, NumberOfReplicates, or CryogenicSampleContainer is specified, *)
	(* we do not throw warning since specifying those options indicates the user knows they are aliquoting *)
	freezeCellsAliquotingRequiredCases = DeleteDuplicates@MapThread[
		Which[
			MatchQ[#2, BooleanP] || TrueQ[#3],
				Nothing,
			MatchQ[#2, Automatic] && MatchQ[#3, False] && !MatchQ[Lookup[#4, Footprint], CryogenicVial],
				{#1, Lookup[#4, Object], " with Footprint ", ToString[Lookup[#4, Footprint]], "Only cryogenic vials are accepted for in situ sample preparation"},
			MatchQ[#2, Automatic] && MatchQ[#3, False] && MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
				{#1, Lookup[#4, Object], " which is not compatible with ", "ControlledRateFreezer FreezingStrategy", "The ControlledRateFreezer FreezingStrategy is only compatible with cryogenic vials up to 2 Milliliter in volume"},
			True,
				{#1, Lookup[#4, Object], " with 75% MaxVolume at ", ToString[0.75*Lookup[#4, MaxVolume]], "If prepared in situ, total volume of the cell stock will exceed 75% of the current container's maximum capacity with risk of vial rupture"}
		]&,
		{mySamples, specifiedAliquotQs, resolvedInSitus, sampleContainerModelPackets}
	];

	If[Length[freezeCellsAliquotingRequiredCases] > 0 && messages && notInEngine,
		(* Here we use the new recommended error message format where we expand the error message instead of using index *)
		(* The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
		Message[
			Warning::FreezeCellsAliquotingRequired,
			joinClauses@Map[
				StringJoin[
					ObjectToString[#[[1]], Cache -> cacheBall, Simulation -> simulation],
					" is in model container ",
					ObjectToString[#[[2]], Cache -> cacheBall, Simulation -> simulation],
					#[[3]],
					#[[4]]
					]&,
					freezeCellsAliquotingRequiredCases
				],
			joinClauses[freezeCellsAliquotingRequiredCases[[All, 5]]]
		];
	];

	(*Error::SpecificCryogenicVialRequired*)
	(* 2. Throw an error if Aliquot is False while containersIn is not a cryo vial, or not the same as specified CryogenicSampleContainer. *)
	conflictingAliquotingErrors = MapThread[
		Which[
			MatchQ[#2, False] && !MatchQ[Lookup[#4, Footprint], CryogenicVial],
				{#1, " is in model container ", Lookup[#4, Object], " with Footprint ", ToString[Lookup[#4, Footprint]], "Only cryogenic vials are accepted for in situ sample preparation"},
			And[
				MatchQ[#2, False],
				MatchQ[#3, ObjectP[]],
				!MatchQ[#3, ObjectP[Lookup[Join[{#4, #5}], Object]]]
			],
				{#1, " is in container ", Lookup[#5, Object], " while CryogenicSampleContainer is set to ", ObjectToString[#3, Cache -> cacheBall, Simulation -> simulation], "Frozen cell stocks should be transferred to the specified CryogenicSampleContainer"},
			True,
				Null
		]&,
		{mySamples, specifiedAliquotQs, expandedSuppliedCryogenicSampleContainers, sampleContainerModelPackets, sampleContainerPackets}
	];
	conflictingAliquotingCases = DeleteDuplicates@DeleteCases[conflictingAliquotingErrors, Null];

	If[Length[conflictingAliquotingCases] > 0 && messages && notInEngine,
		(* Here we use the new recommended error message format where we expand the error message instead of using index *)
		(* The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
		Message[
			Error::CryogenicVialAliquotingRequired,
			joinClauses@Map[
				StringJoin[
					ObjectToString[#[[1]], Cache -> cacheBall, Simulation -> simulation],
					#[[2]],
					ObjectToString[#[[3]], Cache -> cacheBall, Simulation -> simulation],
					#[[4]],
					#[[5]]
				]&,
				conflictingAliquotingCases
			],
			joinClauses[conflictingAliquotingCases[[All, 6]]]
		];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingAliquotingTest = If[gatherTests,
		Test["If Aliquot is True, samples are in cryogenic vials, the same container model as CryogenicSampleContainer, if specified:",
			Length[conflictingAliquotingCases] > 0,
			False
		]
	];

	(*Error::FreezeCellsConflictingTemperatureProfile*)
	(* 3. Throw an error is TemperatureProfile is set if while FreezingStrategy is not ControlledRateFreezer, or vice versa. *)
	conflictingTemperatureProfileCases = If[
		Or[
			MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MatchQ[resolvedTemperatureProfile, Null],
			MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MatchQ[resolvedTemperatureProfile, Except[Null]]
		],
		{resolvedFreezingStrategy, resolvedTemperatureProfile},
		{}
	];

	If[Length[conflictingTemperatureProfileCases] > 0 && messages,
		Message[
			Error::FreezeCellsConflictingTemperatureProfile,
			ObjectToString[conflictingTemperatureProfileCases[[1]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[conflictingTemperatureProfileCases[[2]], Cache -> cacheBall, Simulation -> simulation]
		];
	];

	conflictingTemperatureProfileTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[conflictingTemperatureProfileCases, {}], {}, mySamples];

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

	(*Error::ConflictingCryoprotectantSolutionTemperature*)
	(* 4. Throw an error if CryoprotectantSolutionTemperature is set while CryoprotectionStrategy is None at all index *)
	conflictingCryoprotectantSolutionTemperatureCases = If[
		MatchQ[resolvedCryoprotectantSolutionTemperature, (Ambient|Chilled)] && MatchQ[resolvedCryoprotectionStrategies, {None..}],
		ToList @ resolvedCryoprotectantSolutionTemperature,
		{}
	];

	If[Length[conflictingCryoprotectantSolutionTemperatureCases] > 0 && messages,
		Message[
			Error::ConflictingCryoprotectantSolutionTemperature,
			ObjectToString[resolvedCryoprotectantSolutionTemperature, Cache -> cacheBall, Simulation -> simulation]
		];
	];

	conflictingCryoprotectantSolutionTemperatureTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[conflictingCryoprotectantSolutionTemperatureCases, {}], {}, mySamples];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["CryoprotectantSolutionTemperature is specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if and only if the CryoprotectionStrategy is not None at all indices:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["CryoprotectantSolutionTemperature is specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if and only if the CryoprotectionStrategy is not None at all indices:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*Error::FreezeCellsConflictingInsulatedCoolerFreezingTime*)
	(* 5. InsulatedCoolerFreezingTime must be set if and only if FreezingStrategy is InsulatedCooler. *)
	conflictingInsulatedCoolerFreezingTimeCases = If[
		Or[
			MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MatchQ[resolvedInsulatedCoolerFreezingTime, Null],
			MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MatchQ[resolvedInsulatedCoolerFreezingTime, Except[Null]]
		],
		{resolvedFreezingStrategy, resolvedInsulatedCoolerFreezingTime},
		{}
	];

	If[MatchQ[Length[conflictingInsulatedCoolerFreezingTimeCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsConflictingInsulatedCoolerFreezingTime,
			ToString[conflictingInsulatedCoolerFreezingTimeCases[[1]]],
			ToString[conflictingInsulatedCoolerFreezingTimeCases[[2]]]
		];
	];

	conflictingInsulatedCoolerFreezingTimeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = If[MatchQ[conflictingInsulatedCoolerFreezingTimeCases, {}], {}, mySamples];

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

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFreezeCells, roundedFreezeCellsOptions];

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
		(* Errors *)
		(*14*)conflictingCellTypeBools,
		(*15*)conflictingCultureAdhesionBools,
		(*16*)overAspirationErrors,
		(*17*)invalidRackBools,
		(*18*)overFillDestinationErrors,
		(*19*)overFillSourceErrors,
		(* Warnings *)
		(*20*)cellTypeNotSpecifiedBools,
		(*21*)cultureAdhesionNotSpecifiedBools,
		(* Other internal variables *)
		(*22*)aliquotVolumeQuantities,
		(*23*)containerInVolumesBeforeAliquoting
	} = Transpose[MapThread[
		Function[{sample, options, samplePacket, modelPacket, containerPacket, containerModelPacket, mainCellType, mainCellIdentityModel, index},
			Module[
				{
					mainCellIdentityModelPacket, sampleVolumeQuantity, inputContainerMaxVolume, resolvedCryoprotectionStrategy,
					resolvedAliquotBool, resolvedCellType, conflictingCellTypeBool, cellTypeNotSpecifiedBool,
					cultureAdhesionFromSample, resolvedCultureAdhesion, conflictingCultureAdhesionBool, cultureAdhesionNotSpecifiedBool,
					resolvedCellPelletIntensity, resolvedCellPelletTime, resolvedCellPelletSupernatantVolume, overAspirationError,
					cellPelletSupernatantVolumeQuantity, resolvedCryoprotectantSolution, resolvedFreezer, semiresolvedFreezingRack,
					resolvedCryogenicSampleContainer, cryogenicSampleContainerModelMaxVolume, resolvedFreezingRack, invalidRackBool,
					resolvedCryoprotectantSolutionVolume, cryoprotectantSolutionVolumeQuantity, resolvedAliquotVolume,
					aliquotVolumeQuantity, finalVolumeBeforeFreezing, finalVolumeBeforeAliquoting, overFillDestinationError, overFillSourceError,
					resolvedCoolant, resolvedSamplesOutStorageCondition
				},

				(* Lookup information about our sample and container packets *)
				mainCellIdentityModelPacket = fetchPacketFromFastAssoc[mainCellIdentityModel, fastAssoc];

				(* Set the volume of a sample to 0 Microliters if it is not informed. This will allow us to error out in a predictable way instead of breaking everything. *)
				sampleVolumeQuantity = SafeRound[Lookup[samplePacket, Volume], 1 Microliter] /. Null -> 0 Microliter;

				(* Pull out the MaxVolume of Sample input Container *)
				inputContainerMaxVolume = Lookup[containerModelPacket, MaxVolume] /. Null -> 0 Microliter;

				(* Extract the resolved CryoprotectionStrategy and Aliquot options. *)
				{resolvedCryoprotectionStrategy, resolvedAliquotBool} = Lookup[options, {CryoprotectionStrategy, Aliquot}];

				(* Resolve the CellType option as if it wasn't specified, and the CellTypeNotSpecified warning and the ConflictingCellTypeError *)
				{
					resolvedCellType,
					conflictingCellTypeBool,
					cellTypeNotSpecifiedBool
				} = Which[
					(* if CellType was specified but it conflicts with the fields in the Sample, go with what was specified but flip error switch *)
					MatchQ[Lookup[options, CellType], CellTypeP] && MatchQ[mainCellType, CellTypeP] && Lookup[options, CellType] =!= mainCellType,
						{Lookup[options, CellType], True, False},
					(* if CellType was specified otherwise, just go with it *)
					MatchQ[Lookup[options, CellType], CellTypeP],
						{Lookup[options, CellType], False, False},
					(* if CellType was not specified but we could figure it out from the sample, go with that *)
					MatchQ[mainCellType, CellTypeP],
						{mainCellType, False, False},
					(* if CellType was not specified and we couldn't figure it out from the sample, default to Bacterial and flip warning switch *)
					True,
						{Bacterial, False, True}
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
				{
					resolvedCultureAdhesion,
					conflictingCultureAdhesionBool,
					cultureAdhesionNotSpecifiedBool
				} = Which[
					(* if CultureAdhesion was specified but it conflicts with the fields in the Sample, go with what was specified but flip error switch *)
					MatchQ[Lookup[options, CultureAdhesion], CultureAdhesionP] && MatchQ[cultureAdhesionFromSample, CultureAdhesionP] && Lookup[options, CultureAdhesion] =!= cultureAdhesionFromSample,
						{Lookup[options, CultureAdhesion], True, False},
					(* if CultureAdhesion was specified otherwise, just go with it *)
					MatchQ[Lookup[options, CultureAdhesion], CultureAdhesionP],
						{Lookup[options, CultureAdhesion], False, False},
					(* if CultureAdhesion was not specified but we could figure it out from the sample, go with that *)
					MatchQ[cultureAdhesionFromSample, CultureAdhesionP],
						{cultureAdhesionFromSample, False, False},
					(* if CultureAdhesion was not specified and we couldn't figure it out from the sample, default to Suspension and flip warning switch *)
					True,
						{Suspension, False, True}
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
					{sample, cellPelletSupernatantVolumeQuantity, sampleVolumeQuantity, index},
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
							(* Otheriwise, the CryoprotectionStrategy is AddCryoprotectant. For mammalian cells, add autoclaved 30% glycerol to the sample. *)
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
				cryogenicSampleContainerModelMaxVolume = If[MatchQ[resolvedCryogenicSampleContainer, ObjectP[Object[Container]]],
					fastAssocLookup[fastAssoc, resolvedCryogenicSampleContainer, {Model, MaxVolume}]/. Null -> 0 Microliter,
					fastAssocLookup[fastAssoc, resolvedCryogenicSampleContainer, MaxVolume]/. Null -> 0 Microliter
				];

				(* Resolve the FreezingRack. *)
				{resolvedFreezingRack, invalidRackBool} = Which[
					(* if FreezingRack was specified but it is not one of the rack models from search, mark invalidRackBool as True *)
					Or[
						MatchQ[semiresolvedFreezingRack, ObjectP[Object[Container]]] && !MatchQ[fastAssocLookup[fastAssoc, semiresolvedFreezingRack, Model], ObjectP[allPossibleFreezingRacks]],
						MatchQ[semiresolvedFreezingRack, ObjectP[Model[Container]]] && !MatchQ[semiresolvedFreezingRack, ObjectP[allPossibleFreezingRacks]]
					],
						{semiresolvedFreezingRack, True},
					(* If the user specified the option at this index as one of the rack models from search, use the specified value. *)
					MatchQ[semiresolvedFreezingRack, Except[Automatic]],
						{semiresolvedFreezingRack, False},
					(* If the CryogenicSampleContainer's max volume is NOT 2 mL or less, use the Mr. Frosty rack for 5 mL vials. *)
					GreaterQ[cryogenicSampleContainerModelMaxVolume, 2 Milliliter],
						{Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"], False},(* Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"] *)
					True,
						{Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"], False} (* Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"] *)
				];

				(* Resolve the CryoprotectantSolutionVolume. *)
				resolvedCryoprotectantSolutionVolume = Which[
					(* If the user specified the option at this index, use the specified value. *)
					MatchQ[Lookup[options, CryoprotectantSolutionVolume], Except[Automatic]],
						Lookup[options, CryoprotectantSolutionVolume],
					(* If CryoprotectionStrategy is None, set this to Null. *)
					MatchQ[resolvedCryoprotectionStrategy, None],
						Null,
					(* If CryoprotectionStrategy is ChangeMedia, check the sample volume or supernant volume and resolve to 100% of the lesser. *)
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						SafeRound[Min[sampleVolumeQuantity, cellPelletSupernatantVolumeQuantity], 1 Microliter],
					(* If InSitu is True (Aliquot is False) and CryoprotectionStrategy is AddCryoprotectant, check the sample volume and resolve to 50%. *)
					MatchQ[resolvedAliquotBool, False],
						SafeRound[0.50 * sampleVolumeQuantity, 1 Microliter],
					(* If InSitu is False and CryoprotectionStrategy is AddCryoprotectant, check if AliquotVolume is specified. If not, precalculate it. *)
					True,
						Which[
							MatchQ[Lookup[options, AliquotVolume], VolumeP], SafeRound[0.50 * Lookup[options, AliquotVolume], 1 Microliter],
							MatchQ[Lookup[options, AliquotVolume], All], SafeRound[0.50 * sampleVolumeQuantity, 1 Microliter],
							True, SafeRound[Min[0.5 * sampleVolumeQuantity, 0.25 * cryogenicSampleContainerModelMaxVolume], 1 Microliter]
						]
				];

				(* Convert the resolvedCryoprotectantSolutionVolume to handle calculations properly even if the option resolves to Null *)
				cryoprotectantSolutionVolumeQuantity = resolvedCryoprotectantSolutionVolume/. Null -> 0 Microliter;

				(* Calculate the total volume in input sample container before aliquotting. *)
				finalVolumeBeforeAliquoting = If[
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
					(* If over aspirate, use 0 Microliter *)
					Max[sampleVolumeQuantity - cellPelletSupernatantVolumeQuantity + cryoprotectantSolutionVolumeQuantity, 0 Microliter],
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
					(* If there is no duplicates and the resupsended sample volume is less than 75% of cryogenic vial max vol, set to All instead of quanitity*)
					EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						If[GreaterQ[finalVolumeBeforeAliquoting, 0.75 * cryogenicSampleContainerModelMaxVolume],
							SafeRound[0.75 * cryogenicSampleContainerModelMaxVolume, 1 Microliter],
							All
						],
					(* If there is no duplicate, use All or 50% of max volume whichever is smaller *)
					EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant],
						If[GreaterQ[sampleVolumeQuantity, 0.5 * cryogenicSampleContainerModelMaxVolume],
							SafeRound[0.5 * cryogenicSampleContainerModelMaxVolume, 1 Microliter],
							All
						],
					(* If there is no duplicate, use All or 50% of max volume whichever is smaller *)
					EqualQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1] && MatchQ[resolvedCryoprotectionStrategy, None],
						If[GreaterQ[sampleVolumeQuantity, 0.75 * cryogenicSampleContainerModelMaxVolume],
							SafeRound[0.75 * cryogenicSampleContainerModelMaxVolume, 1 Microliter],
							All
						],
					(* If there are duplicates, divide input sample volume equally among them *)
					(* If Aliquot is True and CryoprotectionStrategy is set to ChangeMedia, automatically set to the lesser of 75% of the volume of the CryogenicSampleContainer or the total volume of the suspended cell sample *)
					(* If there is no duplicates and the resupsended sample volume is less than 75% of cryogenic vial max vol, set to All instead of quanitity*)
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
						SafeRound[Min[0.75 * cryogenicSampleContainerModelMaxVolume, finalVolumeBeforeAliquoting/Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]], 1 Microliter],
					MatchQ[resolvedCryoprotectionStrategy, AddCryoprotectant],
						SafeRound[Min[0.5 * cryogenicSampleContainerModelMaxVolume, sampleVolumeQuantity/Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]], 1 Microliter],
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
				overFillDestinationError = If[TrueQ[resolvedAliquotBool] && GreaterQ[finalVolumeBeforeFreezing, 0.75 * cryogenicSampleContainerModelMaxVolume],
					{finalVolumeBeforeFreezing, cryogenicSampleContainerModelMaxVolume},
					Null
				];
				(* When we add cryoprotectant to sample container to resuspend during ChangeMedia step, use 100% as limit since state is liquid *)
				overFillSourceError = If[And[
					TrueQ[resolvedAliquotBool],
					MatchQ[resolvedCryoprotectionStrategy, ChangeMedia],
					GreaterQ[finalVolumeBeforeAliquoting, inputContainerMaxVolume]
				],
					{finalVolumeBeforeAliquoting, inputContainerMaxVolume},
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
					(* Errors *)
					(*14*)conflictingCellTypeBool,
					(*15*)conflictingCultureAdhesionBool,
					(*16*)overAspirationError,
					(*17*)invalidRackBool,
					(*18*)overFillDestinationError,
					(*19*)overFillSourceError,
					(* Warnings *)
					(*20*)cellTypeNotSpecifiedBool,
					(*21*)cultureAdhesionNotSpecifiedBool,
					(* Other internal variables *)
					(*22*)aliquotVolumeQuantity,
					(*23*)finalVolumeBeforeAliquoting
				}
			]
		],
		{mySamples, mapThreadFriendlyOptions, samplePackets, sampleModelPackets, sampleContainerPackets, sampleContainerModelPackets, sampleCellTypes, mainCellIdentityModels, Range[Length[mySamples]]}
	]];

	(* Next, we resolve the CellPelletCentrifuges based on the other centrifugation options. *)

	(* First, find the indices at which CryoprotectionStrategy is ChangeMedia or where a centrifuge is already specified. *)
	centrifugeIndices = Sort @ DeleteDuplicates[
		Flatten @ {
			Position[resolvedCryoprotectionStrategies, ChangeMedia],
			Position[
				Lookup[mapThreadFriendlyOptions, CellPelletCentrifuge],
				ObjectP[{Object[Instrument, Centrifuge], Model[Instrument, Centrifuge]}]
			]
		}
	];

	(* Get the container model at each of these indices to use as input for CentrifugeDevices. *)
	containerModelsAtCentrifugeIndices = Lookup[sampleContainerModelPackets, Object][[centrifugeIndices]];

	(* Get the specified values of CellPelletCentrifuge at each of these indices, too. *)
	specifiedCentrifugesForChangeMedia = Lookup[mapThreadFriendlyOptions, CellPelletCentrifuge][[centrifugeIndices]];

	(* Call CentrifugeDevices to find all compatible centrifuges, unless there is no need to centrifuge anything. *)
	{possibleCentrifuges, noCompatibleCentrifugeIndices} = If[
		MatchQ[centrifugeIndices, {}],
		{{}, {}},
		{
			CentrifugeDevices[
				containerModelsAtCentrifugeIndices,
				Intensity -> resolvedCellPelletIntensities[[centrifugeIndices]] /. {Null -> 1000 RPM}, (* Need to remove Nulls so this doesn't break *)
				Time -> resolvedCellPelletTimes[[centrifugeIndices]] /. {Null -> 10 Minute}, (* Need to remove Nulls so this doesn't break *)
				Preparation -> Manual,
				Cache -> cacheBall,
				Simulation -> simulation
			],
			PickList[centrifugeIndices, possibleCentrifuges, {}]
		}
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
	resolvedCellPelletCentrifuges = Flatten @ ReplacePart[
		ConstantArray[Null, Length[mySamples]],
		GroupBy[
			Transpose[{centrifugeIndices, preResolvedCellPelletCentrifuges}],
			First -> Last
		]
	];



	(* Get the resolved Email option; for this experiment, the default is True *)
	email = If[MatchQ[Lookup[myOptions, Email], Automatic],
		True,
		Lookup[myOptions, Email]
	];

	(* Combine the resolved options together at this point; everything after is error checking, and for the warning below I need this for better error checking *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Join[
			resolvedGeneralOptions,
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
				Confirm -> confirm,
				CanaryBranch -> canaryBranch,
				Template -> template,
				(* explicitly overriding these options to be {} and Null to make things more manageable to pass around and also more readable *)
				Cache -> cacheBall,
				Simulation -> simulation,
				FastTrack -> fastTrack,
				Operator -> operator,
				ParentProtocol -> parentProtocol,
				Upload -> upload,
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
	(*Warning::FreezeCellsReplicateLabels*)
	(* 1. Throw a warning informing the user of the replicate labels if there are replicates. *)
	(* Note:if we are not in a global framework, we assume we are not calling option resolver from ExperimentManualCellPreparation or ExperimentCellPreparation *)
	(* since CryogenicSampleContainerLabel is unit operation option, we do not throw warning if we are on CCD from ExperimentFreezeCells *)
	(* We only throw this warning we are calling ExperimentManualCellPreparation or ExperimentCellPreparation with FreezeCells primitive *)
	(* In these cases, CryogenicSampleContainerLabel is prefilled *)
	replicatesQ = And[
		GreaterQ[correctNumberOfReplicates, 1],
		(* Don't do this error check if there are duplicate samples. *)
		MatchQ[duplicateSamples, {}],
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
				"The replicates of "<>ObjectToString[#, Cache -> cacheBall, Simulation -> simulation]<>" have CryogenicSampleContainerLabel set to "<>ToString[Lookup[sampleToLabelsRules, #]]<>". "&,
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

	(*Warning::FreezeCellsUnknownCellType*)
	(* 2. Throw a warning if the CellType is neither specified by the user nor known from the sample object. In these cases, we default to Bacterial. *)
	unknownCellTypeCases = MapThread[
		If[TrueQ[#2],
			{#1, #3},
			Nothing
		]&,
		{mySamples, cellTypeNotSpecifiedBools, Range[Length[mySamples]]}
	];

	If[!MatchQ[unknownCellTypeCases, {}] && messages && notInEngine,
		Message[
			Warning::FreezeCellsUnknownCellType,
			ObjectToString[unknownCellTypeCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			unknownCellTypeCases[[All, 2]]
		];
	];

	(*Warning::FreezeCellsUnknownCultureAdhesion*)
	(* 3. Throw a warning if the CultureAdhesion is neither specified by the user nor known from the sample object. In these cases, we default to Suspension. *)
	unknownCultureAdhesionCases = MapThread[
		If[TrueQ[#2],
			{#1, #3},
			Nothing
		]&,
		{mySamples, cultureAdhesionNotSpecifiedBools, Range[Length[mySamples]]}
	];

	If[!MatchQ[unknownCultureAdhesionCases, {}] && messages && notInEngine,
		Message[
			Warning::FreezeCellsUnknownCultureAdhesion,
			ObjectToString[unknownCultureAdhesionCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			unknownCultureAdhesionCases[[All, 2]]
		];
	];

	(*Warning::FreezeCellsUnusedSample*)
	(* 4. Throw a warning to tell the user how much sample will not be frozen under the current conditions. *)
	(* Note: we allow parallel samples (duplicated samples) if we are using AddCryoprotectant and None strategies or Aliquot is False *)
	(* Throw a warning to tell the user how much sample will not be frozen under the current conditions. Allow for up to 50 Microliter *)
	(* to not be frozen; otherwise this would be tripped for rounded values and would be super annoying without adding value. *)
	unusedSampleCases = MapThread[
		Function[{sample, aliquotVolume, totalVolume, index},
			Sequence @@ {
				If[
					And[
						!NullQ[aliquotVolume],
						GreaterQ[Lookup[uniqueSampleToUsedVolLookup, sample], 50 Microliter]
					],
					{sample, totalVolume, aliquotVolume, resolvedNumberOfReplicates, Lookup[uniqueSampleToUsedVolLookup, sample], index},
					Nothing
				]
			}
		],
		{mySamples, resolvedAliquotVolumes, containerInVolumesBeforeAliquoting, Range[Length[mySamples]]}
	];

	If[Length[unusedSampleCases] > 0 && messages && notInEngine,
		Message[
			Warning::FreezeCellsUnusedSample,
			ObjectToString[unusedSampleCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			unusedSampleCases[[All, 2]],
			unusedSampleCases[[All, 3]],
			unusedSampleCases[[All, 4]],
			unusedSampleCases[[All, 5]]
		];
	];

	(* ERRORS *)

	(*Error::FreezeCellsConflictingAliquotOptions*)
	(* Throw an error AliquotVolume must be set if and only if Aliquot is True. *)
	conflictingAliquotOptionsCases = MapThread[
		Function[{sample, aliquotVolume, aliquotBool, index},
			Sequence @@ {
				If[MatchQ[aliquotBool, False] && MatchQ[aliquotVolume, Except[Null]],
					{sample, aliquotVolume, aliquotBool, index},
					Nothing
				],
				If[MatchQ[aliquotBool, True] && MatchQ[aliquotVolume, Null],
					{sample, aliquotVolume, aliquotBool, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedAliquotVolumes, resolvedAliquotBools, Range[Length[mySamples]]}
	];

	If[Length[conflictingAliquotOptionsCases] > 0 && messages,
		Message[
			Error::FreezeCellsConflictingAliquotOptions,
			ObjectToString[conflictingAliquotOptionsCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			conflictingAliquotOptionsCases[[All, 2]],
			conflictingAliquotOptionsCases[[All, 3]],
			conflictingAliquotOptionsCases[[All, 4]]
		];
	];

	conflictingAliquotOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingAliquotOptionsCases[[All,1]];

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

	(*Error::FreezeCellsReplicatesAliquotRequired*)
	(* Aliquot must be True for all samples if NumberOfReplicates is greater than 1 or if parallel samples are set *)
	(* We allow reusing the same samples for several cases: *)
	(* Case1: NumberOfReplicates are set to a number. In this case, the same CryoprotectionStrategy is specified *)
	(* Case2: the same sample go through different CryoprotectionStrategies. In this case, InSitu can not be True, and AliquotVolume cannot be All. *)
	(* Case3: Any combination of case1 and case2 *)
	replicatesWithoutAliquotCases = Map[
		Function[{sample},
			Which[
				And[
					MemberQ[talliedSampleWithVolume, {{ObjectP[sample], _, False, _}, _}],
					GreaterQ[numericNumberOfReplicates, 1],
					EqualQ[numericNumberOfReplicates, Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]]
				],
					{sample, " has NumberOfReplicates set to ", numericNumberOfReplicates, "when the NumberOfReplicates is 2 or greater"},
				And[
					MemberQ[talliedSampleWithVolume, {{ObjectP[sample], _, False, _}, _}],
					GreaterQ[Lookup[uniqueSampleToFinalCellStockNumsLookup, sample], 1],
					!EqualQ[correctNumberOfReplicates, Lookup[uniqueSampleToFinalCellStockNumsLookup, sample]]
				],
				{sample, " appears at indices ", Flatten@Position[mySamples, sample], "when there are duplicated samples in the inputs"},
				True,
					Nothing
			]
		],
		DeleteDuplicates@mySamples
	];

	If[Length[replicatesWithoutAliquotCases] > 0 && messages,
		(* Here we use the new recommended error message format where we expand the error message instead of using index *)
		(* The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
		Message[
			Error::FreezeCellsReplicatesAliquotRequired,
			ObjectToString[replicatesWithoutAliquotCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			joinClauses@Map[
				StringJoin[
					ObjectToString[#[[1]], Cache -> cacheBall, Simulation -> simulation],
					#[[2]],
					ToString[#[[3]]]
				]&,
				replicatesWithoutAliquotCases
			],
			joinClauses[replicatesWithoutAliquotCases[[All, 4]], ConjunctionWord -> "or"]
		];
	];

	replicatesWithoutAliquotTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = replicatesWithoutAliquotCases[[All,1]];

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

	(*Error::InsufficientVolumeForAliquoting*)
	(* Check if any unused volume is lower than 0 Microliter *)
	(* To avoid rounding error, we use 1 Microliter times numberNumberOfReplicates*)
	aliquotVolumeReplicatesMismatchCases = Map[
		Function[{sample},
			If[LessQ[Lookup[uniqueSampleToUsedVolLookup, sample], - numericNumberOfReplicates Microliter],
				Module[{posOfSample},
					posOfSample = Flatten@Position[mySamples, sample];
					{sample, Flatten@Position[mySamples, sample], resolvedAliquotVolumes[[posOfSample]], numericNumberOfReplicates*Length[posOfSample]}
				],
				Nothing
			]
		],
		DeleteDuplicates@mySamples
	];

	If[MatchQ[Length[aliquotVolumeReplicatesMismatchCases], GreaterP[0]] && messages,
		Message[
			Error::InsufficientVolumeForAliquoting,
			ObjectToString[aliquotVolumeReplicatesMismatchCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			aliquotVolumeReplicatesMismatchCases[[All, 2]],
			aliquotVolumeReplicatesMismatchCases[[All, 3]],
			aliquotVolumeReplicatesMismatchCases[[All, 4]]
		];
	];

	aliquotVolumeReplicatesMismatchTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = aliquotVolumeReplicatesMismatchCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["AliquotVolume is a volume quantity for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " if NumberOfReplicates is not Null:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["AliquotVolume is a volume quantity for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " if NumberOfReplicates is not Null:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*Warning::OveraspiratedTransfer*)
	(* Note: the warning is defined in ExperimentTransfer. Although it is a warning, we throw InvalidOptions and return $Failed *)
	(* Overaspiration checks. *)
	overaspirationTest = If[MatchQ[overAspirationErrors, {Null..}],
		Warning["There are no overaspirations from the source samples:", True, True],
		Warning["There are no overaspirations from the source samples:", False, True]
	];
	overaspirationWarnings = DeleteCases[overAspirationErrors, Null];
	If[!MatchQ[overaspirationWarnings, {}] && messages,
		Message[
			Warning::OveraspiratedTransfer,
			ObjectToString[overaspirationWarnings[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			overaspirationWarnings[[All, 2]],
			overaspirationWarnings[[All, 3]],
			overaspirationWarnings[[All, 4]]
		]
	];

	(*Error::CryoprotectantSolutionOverfill*)
	(* The addition of CryoprotectantSolution cannot cause the sample's current container to overfill. *)
	cryoprotectantSolutionOverfillCases = MapThread[
		Function[{sample, cryoprotectantSolutionVolume, overFillSourceInfo, index},
			If[!NullQ[overFillSourceInfo],
				{
					sample,
					cryoprotectantSolutionVolume,
					overFillSourceInfo[[1]],
					overFillSourceInfo[[2]],
					index
				},
				Nothing
			]
		],
		{mySamples, resolvedCryoprotectantSolutionVolumes, overFillSourceErrors, Range[Length[mySamples]]}
	];

	If[Length[cryoprotectantSolutionOverfillCases] > 0 && messages,
		Message[
			Error::CryoprotectantSolutionOverfill,
			ObjectToString[cryoprotectantSolutionOverfillCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			cryoprotectantSolutionOverfillCases[[All, 2]],
			cryoprotectantSolutionOverfillCases[[All, 3]],
			cryoprotectantSolutionOverfillCases[[All, 4]],
			cryoprotectantSolutionOverfillCases[[All, 5]]
		];
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

	(*Error::ExcessiveCryogenicSampleVolume*)
	(* The total volume to be frozen cannot exceed the volume of the CryogenicSampleContainer. *)
	excessiveCryogenicSampleVolumeCases = MapThread[
		Function[{sample, cryogenicVial, overFillDestinationInfo, index},
			If[!NullQ[overFillDestinationInfo],
				{
					sample,
					cryogenicVial,
					overFillDestinationInfo[[1]],
					overFillDestinationInfo[[2]],
					index
				},
				Nothing
			]
		],
		{mySamples, resolvedCryogenicSampleContainers, overFillDestinationErrors, Range[Length[mySamples]]}
	];

	If[Length[excessiveCryogenicSampleVolumeCases] > 0 && messages,
		Message[
			Error::ExcessiveCryogenicSampleVolume,
			ObjectToString[excessiveCryogenicSampleVolumeCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[excessiveCryogenicSampleVolumeCases[[All, 2]], Cache -> cacheBall, Simulation -> simulation],
			excessiveCryogenicSampleVolumeCases[[All, 3]],
			excessiveCryogenicSampleVolumeCases[[All, 4]],
			excessiveCryogenicSampleVolumeCases[[All, 5]]
		];
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

	(*Error::UnsuitableCryogenicSampleContainerFootprint*)
	(* All CryogenicSampleContainers must have a CryogenicVial footprint. *)
	(* Note: we have thrown Error::CryogenicVialAliquotingRequired for Aliquot->False cases earlier *)
	unsuitableCryogenicSampleContainerErrors = MapThread[
		Function[{sample, cryogenicSampleContainer, aliquotQ, index},
			Module[{footPrint},
				footPrint = If[MatchQ[cryogenicSampleContainer, ObjectP[Model[Container]]],
					fastAssocLookup[fastAssoc, cryogenicSampleContainer, Footprint],
					fastAssocLookup[fastAssoc, cryogenicSampleContainer, {Model, Footprint}]
				];
				If[TrueQ[aliquotQ] && MatchQ[footPrint, Except[CryogenicVial]],
					{sample, cryogenicSampleContainer, footPrint, index},
					Null
				]
			]
		],
		{mySamples, resolvedCryogenicSampleContainers, resolvedAliquotBools, Range[Length[mySamples]]}
	];
	unsuitableCryogenicSampleContainerCases = DeleteCases[unsuitableCryogenicSampleContainerErrors, Null];

	If[Length[unsuitableCryogenicSampleContainerCases] > 0 && messages,
		Message[
			Error::UnsuitableCryogenicSampleContainerFootprint,
			ObjectToString[unsuitableCryogenicSampleContainerCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[unsuitableCryogenicSampleContainerCases[[All, 2]], Cache -> cacheBall, Simulation -> simulation],
			unsuitableCryogenicSampleContainerCases[[All, 3]],
			unsuitableCryogenicSampleContainerCases[[All, 4]]
		];
	];

	unsuitableCryogenicSampleContainerTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unsuitableCryogenicSampleContainerCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["The Model[Container] of the CryogenicSampleContainer specified for the sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " has a CryogenicVial Footprint:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["The Model[Container] of the CryogenicSampleContainer specified for the sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " has a CryogenicVial Footprint:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*Error::UnsuitableFreezingRack*)
	unsuitableFreezingRackCases = MapThread[
		Function[{sample, freezingRack, invalidQ, index},
			If[TrueQ[invalidQ],
				{sample, freezingRack, index},
				Nothing
			]
		],
		{mySamples, resolvedFreezingRacks, invalidRackBools, Range[Length[mySamples]]}
	];

	If[Length[unsuitableFreezingRackCases] > 0 && messages,
		Message[
			Error::UnsuitableFreezingRack,
			ObjectToString[unsuitableFreezingRackCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[unsuitableFreezingRackCases[[All, 2]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[allPossibleFreezingRacks, Cache -> cacheBall, Simulation -> simulation],
			unsuitableFreezingRackCases[[All, 3]]
		];
	];

	unsuitableFreezingRackTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unsuitableFreezingRackCases[[All,1]];

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

	(* Throw an error if the static freezer instrument has a DefaultTemperature other than -80+- 5 Celsius or -20+- 5 Celsius *)
	resolvedFreezerModels = Map[
		If[MatchQ[#, ObjectP[Object]],
			fetchPacketFromCache[#, Join[staticFreezerModelPackets, controlledRateFreezerModelPackets]],
			#
		]&,
		resolvedFreezers
	];
	unsupportedFreezerCases = If[
		!MemberQ[ToList[resolvedFreezers], ObjectP[{Object[Instrument, Freezer], Model[Instrument, Freezer]}]],
		{},
		MapThread[
			Function[
				{
					sample,
					freezerModel,
					defaultTemperature,
					index
				},
				Sequence @@ {
					If[
						And[
							MatchQ[resolvedFreezingStrategy, InsulatedCooler],
							!MatchQ[defaultTemperature, RangeP[-85 Celsius, -75 Celsius]],
							!MatchQ[defaultTemperature, RangeP[-25 Celsius, -15 Celsius]]
						],
						{sample, freezerModel, defaultTemperature, index},
						Nothing
					]
				}
			],
			{
				mySamples,
				resolvedFreezers,
				fastAssocLookup[fastAssoc, #, DefaultTemperature] & /@ resolvedFreezerModels,
				Range[Length[mySamples]]
			}
		]
	];

	If[MatchQ[Length[unsupportedFreezerCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsUnsupportedFreezerModel,
			ObjectToString[unsupportedFreezerCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[unsupportedFreezerCases[[All,2]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[unsupportedFreezerCases[[All,3]], Cache -> cacheBall, Simulation -> simulation],
			unsupportedFreezerCases[[All,4]]
		];
	];

	unsupportedFreezerTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = unsupportedFreezerCases[[All,1]];

			failingTest = If[Length[affectedSamples] == 0,
				Nothing,
				Test["If the FreezingStrategy is InsulatedCooler, the Freezer for sample(s) " <> ObjectToString[affectedSamples, Cache -> cacheBall, Simulation -> simulation] <> " has a DefaultTemperature that is within 5 Celsius of either -80 Celsius or -20 Celsius:", True, False]
			];

			passingTest = If[Length[affectedSamples] == Length[mySamples],
				Nothing,
				Test["If the FreezingStrategy is InsulatedCooler, the Freezer for sample(s) " <> ObjectToString[Complement[mySamples, affectedSamples], Cache -> cacheBall, Simulation -> simulation] <> " has a DefaultTemperature that is within 5 Celsius of either -80 Celsius or -20 Celsius:", True, True]
			];

			{failingTest, passingTest}
		],
		Null
	];

	(*Error::FreezeCellsConflictingHardware*)
	(* The FreezingStrategy, Freezer, FreezingRack, and CryogenicSampleContainer must be compatible. *)
	resolvedFreezingRackModels = Map[
		If[MatchQ[#, ObjectP[Object]],
			fetchPacketFromCache[#, freezingRackModelPackets],
			#
		]&,
		resolvedFreezingRacks
	];
	conflictingHardwareCases = MapThread[
		Function[{sample, freezer, freezingRack, cryogenicVial, index, invalidRackQ, invalidCryogenicVialQ, unsuitableCryogenicVialQ},
			Sequence @@ {
				If[
					And[
						MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
						MatchQ[freezer, ObjectP[{Model[Instrument, Freezer], Object[Instrument, Freezer]}]]
					],
					{sample, FreezingStrategy, resolvedFreezingStrategy, Freezer, freezer, index},
					Nothing
				],
				If[
					And[
						MatchQ[resolvedFreezingStrategy, InsulatedCooler],
						MatchQ[freezer, ObjectP[{Model[Instrument, ControlledRateFreezer], Object[Instrument, ControlledRateFreezer]}]]
					],
					{sample, FreezingStrategy, resolvedFreezingStrategy, Freezer, freezer, index},
					Nothing
				],
				(* Note:If invalidRackQ is True, we have thrown UnsuitableFreezingRack earlier *)
				If[
					And[
						MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
						MatchQ[freezingRack, ObjectP[{Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}]],
						!TrueQ[invalidRackQ]
					],
					{sample, FreezingStrategy, resolvedFreezingStrategy, FreezingRack, freezingRack, index},
					Nothing
				],
				If[
					And[
						MatchQ[resolvedFreezingStrategy, InsulatedCooler],
						!MatchQ[freezingRack, ObjectP[{Model[Container, Rack, InsulatedCooler], Object[Container, Rack, InsulatedCooler]}]],
						!TrueQ[invalidRackQ]
					],
					{sample, FreezingStrategy, resolvedFreezingStrategy, FreezingRack, freezingRack, index},
					Nothing
				],
				(* Note:If invalidCryogenicVialQ is NOT Null, we have thrown CryogenicVialAliquotingRequired earlier *)
				(* Similarly, if unsuitableCryogenicVialQ is NOT Null, we have thrown UnsuitableCryogenicSampleContainerFootprint earlier *)
				If[
					And[
						NullQ[invalidCryogenicVialQ],
						NullQ[unsuitableCryogenicVialQ],
						MatchQ[
							freezingRack,
							(* These are the 2 mL racks for the VIA Freeze and Mr. Frosty, respectively. *)
							ObjectP[{Model[Container, Rack, "id:pZx9jo8ZVNW0"], Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"]}]
						],
						MatchQ[
							fastAssocLookup[fastAssoc, cryogenicVial, MaxVolume],
							GreaterP[2 Milliliter]
						]
					],
					{sample, CryogenicVial, cryogenicVial, FreezingRack, freezingRack, index},
					Nothing
				],
				If[
					And[
						NullQ[invalidCryogenicVialQ],
						NullQ[unsuitableCryogenicVialQ],
						MatchQ[
							freezingRack,
							ObjectP[Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]] (* Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"] *)
						],
						MatchQ[
							fastAssocLookup[fastAssoc, cryogenicVial, MaxVolume],
							LessP[3.6 Milliliter] (* The minimum vial size recommended for these is 3.6 mL, though we don't stock those vials. *)
						]
					],
					{sample, CryogenicVial, cryogenicVial, FreezingRack, freezingRack, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedFreezers, resolvedFreezingRackModels, resolvedCryogenicSampleContainers, Range[Length[mySamples]], invalidRackBools, conflictingAliquotingErrors, unsuitableCryogenicSampleContainerErrors}
	];

	If[Length[conflictingHardwareCases] > 0 && messages,
		Message[
			Error::FreezeCellsConflictingHardware,
			ObjectToString[conflictingHardwareCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[conflictingHardwareCases[[All, 2]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[conflictingHardwareCases[[All, 3]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[conflictingHardwareCases[[All, 4]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[conflictingHardwareCases[[All, 5]], Cache -> cacheBall, Simulation -> simulation],
			conflictingHardwareCases[[All, 6]]
		];
	];

	conflictingHardwareTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingHardwareCases[[All,1]];

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

	(*Error::FreezeCellsConflictingCellType*)
	(* The specified CellType must not conflict with the CellType information in Object[Sample]. *)
	conflictingCellTypeCases = Transpose @ {
		PickList[mySamples, conflictingCellTypeBools],
		PickList[resolvedCellTypes, conflictingCellTypeBools],
		Lookup[PickList[samplePackets, conflictingCellTypeBools], CellType, {}],
		Flatten @ Position[conflictingCellTypeBools, True]
	};

	If[MatchQ[Length[conflictingCellTypeCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsConflictingCellType,
			ObjectToString[conflictingCellTypeCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			ToString[conflictingCellTypeCases[[All,2]]],
			ToString[conflictingCellTypeCases[[All,3]]],
			conflictingCellTypeCases[[All,4]]
		];
	];

	conflictingCellTypeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingCellTypeCases[[All,1]];

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

	(*Error::FreezeCellsConflictingCultureAdhesion*)
	(* The specified CultureAdhesion must not conflict with the CultureAdhesion information in Object[Sample]. *)
	conflictingCultureAdhesionCases = Transpose @ {
		PickList[mySamples, conflictingCultureAdhesionBools],
		PickList[resolvedCultureAdhesions, conflictingCultureAdhesionBools],
		Lookup[PickList[samplePackets, conflictingCultureAdhesionBools], CultureAdhesion, {}],
		Flatten @ Position[conflictingCultureAdhesionBools, True]
	};

	If[MatchQ[Length[conflictingCultureAdhesionCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsConflictingCultureAdhesion,
			ObjectToString[conflictingCultureAdhesionCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			ToString[conflictingCultureAdhesionCases[[All,2]]],
			ToString[conflictingCultureAdhesionCases[[All,3]]],
			conflictingCultureAdhesionCases[[All,4]]
		];
	];

	conflictingCultureAdhesionTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = conflictingCultureAdhesionCases[[All,1]];

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

	(*Error::FreezeCellsConflictingCoolant*)
	(* Coolant must be set if and only if FreezingStrategy is InsulatedCooler. *)
	conflictingCoolantCases = MapThread[
		Function[{sample, coolant, index},
			Sequence @@ {
				If[MatchQ[resolvedFreezingStrategy, InsulatedCooler] && MatchQ[coolant, Null],
					{sample, coolant, resolvedFreezingStrategy, index},
					Nothing
				],
				If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer] && MatchQ[coolant, Except[Null]],
					{sample, coolant, resolvedFreezingStrategy, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedCoolants, Range[Length[mySamples]]}
	];

	If[Length[conflictingCoolantCases] > 0 && messages,
		Message[
			Error::FreezeCellsConflictingCoolant,
			ObjectToString[conflictingCoolantCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[conflictingCoolantCases[[All, 2]], Cache -> cacheBall, Simulation -> simulation],
			conflictingCoolantCases[[All, 3]],
			conflictingCoolantCases[[All, 4]]
		];
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

	(*Error::FreezeCellsUnsupportedTemperatureProfile*)
	(* Throw an error if the TemperatureProfile is invalid. This only matters if we are using a ControlledRateFreezer strategy. *)
	unsupportedTemperatureProfileCases = If[
		Or[
			MatchQ[resolvedTemperatureProfile, Null],
			!MemberQ[resolvedFreezers, ObjectP[{Object[Instrument, ControlledRateFreezer], Model[Instrument, ControlledRateFreezer]}]],
			MatchQ[resolvedFreezingStrategy, InsulatedCooler]
		],
		{},
		(* Otherwise, we need to look at the individual legs of the profile and check for 1) cumulative timepoints *)
		(* and 2) segments with cooling/heating rates which are too fast for slow for the instrument. *)
		Module[
			{
				fullProfile, temperatureDiffs, timeDiffs, nonCumulativeTimeQ, suggestedCumulativeProfile,
				controlledRateFreezerModel, minCoolingRate, maxCoolingRate, flaggedEndPoints, flaggedRates
			},

			(* The initial point is always RT at 0 Minutes. Prepend this to the profile from the protocol object, unless the user already inserted this point manually. *)
			fullProfile = If[MatchQ[resolvedTemperatureProfile[[1]], {EqualP[25 Celsius], EqualP[0 Minute]}],
				resolvedTemperatureProfile,
				Prepend[resolvedTemperatureProfile, {25 Celsius, 0 Minute}]
			];

			(* Get the differences between each of the temperatures and times. *)
			{temperatureDiffs, timeDiffs} = Differences /@ Transpose[fullProfile];

			(* If any of these time differences is negative or 0, the user entered the temperature profile incorrectly. *)
			nonCumulativeTimeQ = MemberQ[timeDiffs, LessEqualP[0 Minute]];

			(* If the times are non-cumulative, try to help the user out and suggest the correct format. *)
			suggestedCumulativeProfile = If[
				nonCumulativeTimeQ,
				Transpose[{
					resolvedTemperatureProfile[[All,1]],
					Accumulate[resolvedTemperatureProfile[[All,2]]]
				}],
				{}
			];

			(* Make sure we are dealing with the controlled rate freezer as a Model rather than an Object. *)
			controlledRateFreezerModel = If[MemberQ[resolvedFreezers, ObjectP[Model[Instrument, ControlledRateFreezer]]],
				FirstCase[resolvedFreezers, ObjectP[Model[Instrument, ControlledRateFreezer]]],
				fastAssocLookup[fastAssoc, resolvedFreezers[[1]], Model]
			];

			(* Get the MinCoolingRate and MaxCoolingRate of the ControlledRateFreezer instrument. *)
			(* Note that both of these fields are positive numbers. *)
			minCoolingRate = fastAssocLookup[fastAssoc, controlledRateFreezerModel, MinCoolingRate];
			maxCoolingRate = fastAssocLookup[fastAssoc, controlledRateFreezerModel, MaxCoolingRate];

			(* Map over the legs and pick out any problematic ones. Don't run this check if we have already flagged the *)
			(* profile as having incorrect time, since the rates are going to be meaningless if that's the case. *)
			(* This also prevents us from having to worry about dividing by zero: timeDiff = 0 Minute trips nonCumulativeTimeQ *)
			{flaggedEndPoints, flaggedRates} = If[nonCumulativeTimeQ,
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
						{resolvedTemperatureProfile, rates}
					]
				]
			] /. {Null -> Nothing};

			(* Populate the info we need to surface in the error message. *)
			Which[
				(* If the times are noncumulative, tell the user and suggest what they may have wanted. *)
				nonCumulativeTimeQ, {"The specified time components are non-cumulative. Each time point must represent the total time elapsed since the beginning of the temperature profile rather than the time elapsed from the previous time point. Based on the specified TemperatureProfile, it is possible that the following TemperatureProfile is intended: "<>ToString[suggestedCumulativeProfile]},
				(* If any of the rates are outside of the bounds of the instrument, indicate this. *)
				GreaterQ[Length[flaggedRates], 0], {"The segment(s) of the specified TemperatureProfile which conclude with the endpoint(s) "<>ToString[flaggedEndPoints]<>" require heating or cooling at rates of "<>ToString[flaggedRates]<>", but the instrument "<>ObjectToString[resolvedFreezers[[1]], Cache -> cacheBall, Simulation -> simulation]<>" can only heat or cool at rates between "<>ToString[minCoolingRate]<>" and "<>ToString[maxCoolingRate]},
				(* Otherwise this TemperatureProfile is fine. *)
				True, {}
			]
		]
	];

	If[MatchQ[Length[unsupportedTemperatureProfileCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsUnsupportedTemperatureProfile,
			resolvedTemperatureProfile,
			unsupportedTemperatureProfileCases[[1]]
		];
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

	(*Error::FreezeCellsInsufficientChangeMediaOptions*)
	(* The four pelleting options must not be Null if CryoprotectionStrategy is ChangeMedia. *)
	insufficientChangeMediaOptionsCases = MapThread[
		Function[{sample, cryoprotectionStrategy, cellPelletCentrifuge, cellPelletTime, cellPelletIntensity, cellPelletSupernatantVolume, index},
			Sequence @@ {
				If[MatchQ[cryoprotectionStrategy, ChangeMedia] && MatchQ[cellPelletCentrifuge, Null],
					{sample, CellPelletCentrifuge, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, ChangeMedia] && MatchQ[cellPelletTime, Null],
					{sample, CellPelletTime, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, ChangeMedia] && MatchQ[cellPelletIntensity, Null],
					{sample, CellPelletIntensity, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, ChangeMedia] && MatchQ[cellPelletSupernatantVolume, Null],
					{sample, CellPelletSupernatantVolume, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedCryoprotectionStrategies, resolvedCellPelletCentrifuges, resolvedCellPelletTimes, resolvedCellPelletIntensities, resolvedCellPelletSupernatantVolumes, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[insufficientChangeMediaOptionsCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsInsufficientChangeMediaOptions,
			ObjectToString[insufficientChangeMediaOptionsCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			ToString[insufficientChangeMediaOptionsCases[[All,2]]],
			insufficientChangeMediaOptionsCases[[All,3]]
		];
	];

	insufficientChangeMediaOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = insufficientChangeMediaOptionsCases[[All,1]];

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

	(*Error::FreezeCellsExtraneousChangeMediaOptions*)
	(* The four pelleting options must be Null if CryoprotectionStrategy is NOT ChangeMedia. *)
	extraneousChangeMediaOptionsCases = MapThread[
		Function[{sample, cryoprotectionStrategy, cellPelletCentrifuge, cellPelletTime, cellPelletIntensity, cellPelletSupernatantVolume, index},
			Sequence @@ {
				If[MatchQ[cryoprotectionStrategy, Except[ChangeMedia]] && MatchQ[cellPelletCentrifuge, Except[Null]],
					{sample, cryoprotectionStrategy, CellPelletCentrifuge, cellPelletCentrifuge, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, Except[ChangeMedia]] && MatchQ[cellPelletTime, Except[Null]],
					{sample, cryoprotectionStrategy, CellPelletTime, cellPelletTime, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, Except[ChangeMedia]] && MatchQ[cellPelletIntensity, Except[Null]],
					{sample, cryoprotectionStrategy, CellPelletIntensity, cellPelletIntensity, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, Except[ChangeMedia]] && MatchQ[cellPelletSupernatantVolume, Except[Null]],
					{sample, cryoprotectionStrategy, CellPelletSupernatantVolume, cellPelletSupernatantVolume, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedCryoprotectionStrategies, resolvedCellPelletCentrifuges, resolvedCellPelletTimes, resolvedCellPelletIntensities, resolvedCellPelletSupernatantVolumes, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[extraneousChangeMediaOptionsCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsExtraneousChangeMediaOptions,
			ObjectToString[extraneousChangeMediaOptionsCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			ToString[extraneousChangeMediaOptionsCases[[All,2]]],
			ToString[extraneousChangeMediaOptionsCases[[All,3]]],
			ToString[extraneousChangeMediaOptionsCases[[All,4]]],
			extraneousChangeMediaOptionsCases[[All,5]]
		];
	];

	extraneousChangeMediaOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = extraneousChangeMediaOptionsCases[[All,1]];

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

	(*Error::FreezeCellsInsufficientCryoprotectantOptions*)
	(* The three options related to CryoprotectantSolutions must not be Null unless CryoprotectionStrategy is None. *)
	insufficientCryoprotectantOptionsCases = MapThread[
		Function[{sample, cryoprotectionStrategy, cryoprotectantSolution, cryoprotectantSolutionVolume, index},
			Sequence @@ {
				If[MatchQ[cryoprotectionStrategy, Except[None]] && MatchQ[cryoprotectantSolution, Null],
					{sample, cryoprotectionStrategy, CryoprotectantSolution, cryoprotectantSolution, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, Except[None]] && MatchQ[cryoprotectantSolutionVolume, Null],
					{sample, cryoprotectionStrategy, CryoprotectantSolutionVolume, cryoprotectantSolutionVolume, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, Except[None]] && MatchQ[resolvedCryoprotectantSolutionTemperature, Null],
					{sample, cryoprotectionStrategy, CryoprotectantSolutionTemperature, resolvedCryoprotectantSolutionTemperature, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedCryoprotectionStrategies, resolvedCryoprotectantSolutions, resolvedCryoprotectantSolutionVolumes, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[insufficientCryoprotectantOptionsCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsInsufficientCryoprotectantOptions,
			ObjectToString[insufficientCryoprotectantOptionsCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			ToString[insufficientCryoprotectantOptionsCases[[All,2]]],
			ToString[insufficientCryoprotectantOptionsCases[[All,3]]],
			ToString[insufficientCryoprotectantOptionsCases[[All,4]]],
			insufficientCryoprotectantOptionsCases[[All,5]]
		];
	];

	insufficientCryoprotectantOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = insufficientCryoprotectantOptionsCases[[All,1]];

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

	(*Error::FreezeCellsExtraneousCryoprotectantOptions*)
	(* The three options related to CryoprotectantSolutions must be Null if CryoprotectionStrategy is None. *)
	extraneousCryoprotectantOptionsCases = MapThread[
		Function[{sample, cryoprotectionStrategy, cryoprotectantSolution, cryoprotectantSolutionVolume, index},
			Sequence @@ {
				If[MatchQ[cryoprotectionStrategy, None] && MatchQ[cryoprotectantSolution, Except[Null]],
					{sample, CryoprotectantSolution, cryoprotectantSolution, index},
					Nothing
				],
				If[MatchQ[cryoprotectionStrategy, None] && MatchQ[cryoprotectantSolutionVolume, Except[Null]],
					{sample, CryoprotectantSolutionVolume, cryoprotectantSolutionVolume, index},
					Nothing
				]
			}
		],
		{mySamples, resolvedCryoprotectionStrategies, resolvedCryoprotectantSolutions, resolvedCryoprotectantSolutionVolumes, Range[Length[mySamples]]}
	];

	If[MatchQ[Length[extraneousCryoprotectantOptionsCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsExtraneousCryoprotectantOptions,
			ObjectToString[extraneousCryoprotectantOptionsCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			ToString[extraneousCryoprotectantOptionsCases[[All,2]]],
			ObjectToString[extraneousCryoprotectantOptionsCases[[All,3]], Cache -> cacheBall, Simulation -> simulation],
			extraneousCryoprotectantOptionsCases[[All,4]]
		];
	];

	extraneousCryoprotectantOptionsTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = extraneousCryoprotectantOptionsCases[[All,1]];

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

	(*Error::FreezeCellsNoCompatibleCentrifuge*)
	(* Throw an error if we need a centrifuge but there are none compatible with the given container and conditions. *)
	noCompatibleCentrifugeCases = If[
		MatchQ[Length[noCompatibleCentrifugeIndices], GreaterP[0]],
		MapThread[
			Function[{sample, containerModel, intensity, time, index},
				{sample, containerModel, intensity, time, index}
			],
			{
				mySamples[[noCompatibleCentrifugeIndices]],
				Lookup[sampleContainerModelPackets[[noCompatibleCentrifugeIndices]], Object],
				resolvedCellPelletIntensities[[noCompatibleCentrifugeIndices]],
				resolvedCellPelletTimes[[noCompatibleCentrifugeIndices]],
				centrifugeIndices[[noCompatibleCentrifugeIndices]]
			}
		],
		{}
	];

	If[MatchQ[Length[noCompatibleCentrifugeCases], GreaterP[0]] && messages,
		Message[
			Error::FreezeCellsNoCompatibleCentrifuge,
			ObjectToString[noCompatibleCentrifugeCases[[All,1]], Cache -> cacheBall, Simulation -> simulation],
			ObjectToString[noCompatibleCentrifugeCases[[All,2]], Cache -> cacheBall, Simulation -> simulation],
			ToString[noCompatibleCentrifugeCases[[All,3]]],
			ToString[noCompatibleCentrifugeCases[[All,4]]],
			noCompatibleCentrifugeCases[[All,5]]
		];
	];

	noCompatibleCentrifugeTest = If[gatherTests,
		Module[{affectedSamples, failingTest, passingTest},
			affectedSamples = noCompatibleCentrifugeCases[[All,1]];

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

	(* Gather the samples that are in the same container together with their options *)
	groupedSamplesContainersAndOptions = GatherBy[
		Transpose[{mySamples, sampleContainerPackets, resolvedMapThreadOptions}],
		#[[2]]&
	];

	(* Get the options that are not the same across the board for each container *)
	inconsistentOptionsPerContainer = Map[
		Function[{samplesContainersAndOptions},
			Module[{optionsToPullOut},
				optionsToPullOut = {CellPelletCentrifuge, CellPelletTime, CellPelletIntensity};
			Map[
				Function[{optionToCheck},
					If[SameQ @@ Lookup[samplesContainersAndOptions[[All, 3]], optionToCheck],
						Nothing,
						optionToCheck
					]
				],
				Append[optionsToPullOut, SamplesOutStorageCondition]
			]
			]
		],
		groupedSamplesContainersAndOptions
	];

	(* Get the samples that have conflicting options for the same container *)
	samplesWithSameContainerConflictingOptions = MapThread[
		Function[{samplesContainersAndOptions, inconsistentOptions},
			If[MatchQ[inconsistentOptions, {}],
				Nothing,
				samplesContainersAndOptions[[All, 1]]
			]
		],
		{groupedSamplesContainersAndOptions, inconsistentOptionsPerContainer}
	];
	samplesWithSameContainerConflictingErrors = Not[MatchQ[#, {}]]& /@ inconsistentOptionsPerContainer;

	(* Throw an error if we have these same-container samples with different options specified *)
	(* Here we use the new recommended error message format where we expand the error message instead of using index *)
	(* The helper function joinClauses is defined in Experiment/PrimitiveFramework/Helpers.m *)
	conflictingPelletOptionsForSameContainerOptions = If[MemberQ[samplesWithSameContainerConflictingErrors, True] && messages,
		(
			Message[
				Error::ConflictingChangeMediaOptionsForSameContainer,
				joinClauses@MapThread[
					StringJoin["The samples ", ObjectToString[#1, Cache -> cacheBall, Simulation -> simulation], "have different cell pellet setting option(s):", ToString@#2]&,
					{
						PickList[samplesWithSameContainerConflictingOptions, samplesWithSameContainerConflictingErrors],
						PickList[inconsistentOptionsPerContainer, samplesWithSameContainerConflictingErrors]
					}
				]
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
				Test["The following samples, "<>ObjectToString[failingInputs, Cache -> cacheBall, Simulation -> simulation]<>",have the same cell pellet options as all other samples in the same container:", True, False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest = If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs, Cache -> cacheBall, Simulation -> simulation]<>",have the same cell pellet options as all other samples in the same container:", True, True],
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

	(*Error::TooManyControlledRateFreezerBatches*)
	(* We don't allow more than one ControlledRateFreezer freezing batch per protocol due to equipment constraints and timing challenges. *)
	(* Since all of the options associated with this FreezingStrategy are non-index matching, we only have to check if we're exceeding 48 samples. *)
	tooManyControlledRateFreezerBatches = If[
		MatchQ[numericNumberOfReplicates * Length[mySamples], GreaterP[48]] && MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		{resolvedNumberOfReplicates, Length[mySamples], numericNumberOfReplicates * Length[mySamples], Length[PartitionRemainder[Range[numericNumberOfReplicates * Length[mySamples]], 48]]},
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

	(*Error::TooManyInsulatedCoolerBatches*)
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
			relevantConditionSetCounts = relevantConditionSetsTallied[[All,2]];
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
			If[
				MatchQ[Length[Flatten[partitionedSampleCountsPerConditionSet]], GreaterP[3]],
				{
					freezingRacks,
					numberOfPositionsByRack,
					Length[relevantConditionSetCounts],
					relevantConditionSetCounts,
					resolvedNumberOfReplicates,
					partitionedSampleCountsPerConditionSet,
					Length[Flatten[partitionedSampleCountsPerConditionSet]]
				},
				Nothing
			]
		]
	];

	If[MatchQ[Length[tooManyInsulatedCoolerBatches], GreaterP[0]] && messages,
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
	invalidInputs = DeleteDuplicates[Flatten[
		{
			discardedInvalidInputs,
			deprecatedSampleInputs,
			invalidCellTypeSamples,
			invalidCultureAdhesionSamples,
			duplicateSamples,
			invalidPlateSampleInputs
		}
	]
	];
	invalidOptions = DeleteDuplicates[
		Flatten[
			{
				If[MatchQ[Length[conflictingAliquotingCases], GreaterP[0]],
					{Aliquot, CryogenicSampleContainer},
					{}
				],
				If[MatchQ[Length[conflictingCellTypeCases], GreaterP[0]],
					{CellType},
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
				If[MatchQ[Length[overaspirationWarnings], GreaterP[0]],
					{CellPelletSupernatantVolume},
					{}
				],
				If[MatchQ[Length[insufficientChangeMediaOptionsCases], GreaterP[0]],
					{CryoprotectionStrategy, CellPelletCentrifuge, CellPelletIntensity, CellPelletTime, CellPelletSupernatantVolume},
					{}
				],
				If[MatchQ[Length[extraneousChangeMediaOptionsCases], GreaterP[0]],
					{CryoprotectionStrategy, CellPelletCentrifuge, CellPelletIntensity, CellPelletTime, CellPelletSupernatantVolume},
					{}
				],
				If[MatchQ[Length[insufficientCryoprotectantOptionsCases], GreaterP[0]],
					{CryoprotectionStrategy, CryoprotectantSolution, CryoprotectantSolutionVolume, CryoprotectantSolutionTemperature},
					{}
				],
				If[MatchQ[Length[extraneousCryoprotectantOptionsCases], GreaterP[0]],
					{CryoprotectionStrategy, CryoprotectantSolution, CryoprotectantSolutionVolume, CryoprotectantSolutionTemperature},
					{}
				],
				If[MatchQ[Length[aliquotVolumeReplicatesMismatchCases], GreaterP[0]],
					{AliquotVolume, NumberOfReplicates},
					{}
				],
				If[MatchQ[Length[noCompatibleCentrifugeCases], GreaterP[0]],
					{CellPelletIntensity, CellPelletTime},
					{}
				],
				conflictingPelletOptionsForSameContainerOptions,
				If[MatchQ[Length[conflictingHardwareCases], GreaterP[0]],
					{FreezingStrategy, Freezer, FreezingRack, CryogenicSampleContainer},
					{}
				],
				If[MatchQ[Length[excessiveCryogenicSampleVolumeCases], GreaterP[0]],
					{AliquotVolume, CryogenicVial},
					{}
				],
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
				If[MatchQ[Length[conflictingCryoprotectantSolutionTemperatureCases], GreaterP[0]],
					{CryoprotectantSolutionTemperature, CryoprotectionStrategy},
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
		precisionTests,
		conflictingAliquotingTest,
		conflictingCellTypeTest,
		conflictingCultureAdhesionTest,
		conflictingTemperatureProfileTest,
		conflictingInsulatedCoolerFreezingTimeTest,
		conflictingCoolantTest,
		unsupportedTemperatureProfileTest,
		unsuitableCryogenicSampleContainerTest,
		conflictingAliquotOptionsTest,
		replicatesWithoutAliquotTest,
		insufficientChangeMediaOptionsTest,
		extraneousChangeMediaOptionsTest,
		insufficientCryoprotectantOptionsTest,
		extraneousCryoprotectantOptionsTest,
		aliquotVolumeReplicatesMismatchTest,
		overaspirationTest,
		noCompatibleCentrifugeTest,
		conflictingHardwareTest,
		excessiveCryogenicSampleVolumeTest,
		tooManyControlledRateFreezerBatchesTest,
		tooManyInsulatedCoolerBatchesTest,
		cryoprotectantSolutionOverfillTest,
		conflictingCryoprotectantSolutionTemperatureTest,
		unsupportedFreezerTest
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
		expandedFreezingRacks, expandedFreezers, expandedCoolants, expandedSamplesOutStorageConditions,
		expandedSampleVolumes, expandedSamplesOutStorageConditionSymbols, expandedCellPelletSupernatantVolumesWithNoAlls,
		expandedAliquotVolumesWithNoAlls, allOptionsExpandedForReplicates,

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
		expandedSamplesOutStorageConditions
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

	(* Get the samples out storage condition symbol *)
	expandedSamplesOutStorageConditionSymbols = Map[
		If[MatchQ[#, ObjectP[Model[StorageCondition]]],
			fastAssocLookup[fastAssoc, #, StorageCondition],
			#
		]&,
		expandedSamplesOutStorageConditions
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
			CryoprotectantSolutionTemperature -> Lookup[myResolvedOptions, CryoprotectantSolutionTemperature],
			FreezingStrategy -> Lookup[myResolvedOptions, FreezingStrategy],
			TemperatureProfile -> Lookup[myResolvedOptions, TemperatureProfile],
			InsulatedCoolerFreezingTime -> Lookup[myResolvedOptions, InsulatedCoolerFreezingTime],
			NumberOfReplicates -> Lookup[myResolvedOptions, NumberOfReplicates],
			Preparation -> Lookup[myResolvedOptions, Preparation],
			ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol],
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
			SamplesOutStorageCondition -> expandedSamplesOutStorageConditions
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
					#1 -> #2/numericNumberOfReplicates,
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

		(* Generate the Pellet UO unless we don't have any pelleting to do. *)
		(* In this Pellet uo, we perform Centrifuge+Aspiration supernatant. We do not resuspend pellets with Resuspension buffer. *)
		If[
			MatchQ[Length[pelletIndices], GreaterP[0]],
			Pellet @ {
				Sample -> uniquePelletSamples,
				Instrument -> instrumentForUniqueSamples,
				Time -> timeForUniqueSamples,
				Intensity -> intensityForUniqueSamples,
				SupernatantVolume -> volumeForUniqueSamples,
				SupernatantDestination -> Waste,
				SterileTechnique -> True,
				Preparation -> Manual,
				Aliquot -> False,
				ImageSample -> False,
				MeasureWeight -> False,
				MeasureVolume -> False
			},
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
				If[
					(* If there is enough space in the rack for every vial with that condition set, put all of the vials in that rack. *)
					MatchQ[numberOfSamplesInSet, LessEqualP[maxVialsPerRack]],
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
	coolantsByRack = If[
		MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
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
	insulatedCoolerContainers = If[
		MatchQ[resolvedFreezingStrategy, ControlledRateFreezer], (* The controlled rate freezer doesn't need this container. *)
		ConstantArray[Null, Length[expandedSamplesWithReplicates]],
		Switch[#,
			ObjectP[Model[Container, Rack, InsulatedCooler, "id:7X104vnMk93w"]], (* Model[Container, Rack, InsulatedCooler, "2mL Mr. Frosty Rack"] *)
				Model[Container, Vessel, "id:eGakldJWoGaq"], (* Model[Container, Vessel, "2mL Mr. Frosty Container"] *)
			ObjectP[Model[Container, Rack, InsulatedCooler, "id:N80DNj1WLYPX"]], (* Model[Container, Rack, InsulatedCooler, "5mL Mr. Frosty Rack"] *)
				Model[Container, Vessel, "id:pZx9jo8edZx9"] (* Model[Container, Vessel, "5mL Mr. Frosty Container"] *)
		] & /@ uniqueFreezingRacksByBatch
	];

	(* Determine the volume of coolant to be added to each Mr. Frosty container. Note that the 2mL size Mr. Frosty always needs *)
	(* 250 mL coolant regardless of how many samples we put into the rack. Similarly, the 5mL Mr Frosty always needs 500 mL coolant. *)
	coolantVolumes = If[
		MatchQ[resolvedFreezingStrategy, ControlledRateFreezer], (* The controlled rate freezer doesn't need coolant. *)
		ConstantArray[Null, Length[expandedSamplesWithReplicates]],
		Switch[#,
			ObjectP[Model[Container, Vessel, "id:eGakldJWoGaq"]], (* Model[Container, Vessel, "2mL Mr. Frosty Container"] *)
				250 Milliliter,
			ObjectP[Model[Container, Vessel, "id:pZx9jo8edZx9"]], (* Model[Container, Vessel, "5mL Mr. Frosty Container"] *)
				500 Milliliter
		] & /@ insulatedCoolerContainers
	];

	(* Expand the insulated cooler containers and coolant volumes for replicates but use the correct sample indices. *)
	{expandedInsulatedCoolerContainers, expandedCoolantVolumes} = If[
		MatchQ[resolvedFreezingStrategy, ControlledRateFreezer], (* The controlled rate freezer doesn't need either of these. *)
		{
			ConstantArray[Null, Length[expandedSamplesWithReplicates]],
			ConstantArray[Null, Length[expandedSamplesWithReplicates]]
		},
		Flatten /@ Transpose[
			MapThread[
				Function[
					{insulatedCoolerContainer, volume, indexGroupLength},
					{ConstantArray[insulatedCoolerContainer, indexGroupLength], ConstantArray[volume, indexGroupLength]}
				],
				{
					insulatedCoolerContainers,
					coolantVolumes,
					Length /@ expandedSampleIndicesByFreezingBatch
				}
			]
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
	insulatedCoolerFreezingConditions = If[
		(* Do this only if we're using an insulatedCooler FreezingStrategy since it doesn't apply for ControlledRateFreezer. *)
		MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		ConstantArray[Null, Length[expandedSamplesWithReplicates]],

		Module[
			{freezerModelPackets, freezerModelDefaultTemps},
			(* Get the FreezerModel packets from the FastAssoc and then find their default temperatures. *)
			freezerModelPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ expandedFreezers;
			freezerModelDefaultTemps = Lookup[freezerModelPackets, DefaultTemperature];
			(* For each freezer, get a storage condition model that matches the freezer's default temperature. *)
			Map[
				If[
					MatchQ[#, RangeP[-85 Celsius, -75 Celsius]],
					Link[Model[StorageCondition, "id:xRO9n3BVOe3z"]], (* Model[StorageCondition, "Deep Freezer"]: a -80 Celsius Freezer *)
					Link[Model[StorageCondition, "id:n0k9mG8Bv96n"]] (* Model[StorageCondition, "Freezer, Flammable"]: a -20 Celsius Freezer, Flammable materials rated *)
				]&, freezerModelDefaultTemps
			]
		]
	];

	(* Generate the freezer resource if we're using a ControlledRateFreezer. No need to make freezer resources if *)
	(* we're using InsulatedCoolers, since the storage task will make the freezer resources in that case. *)
	freezerResourcesLink = If[
		MatchQ[resolvedFreezingStrategy, InsulatedCooler],
		Link /@ expandedFreezers,
		Link /@ Map[
			Resource[Instrument -> #, Time -> Max[resolvedTemperatureProfile[[All,2]]], Name -> ToString[#]]&,
			ToList[expandedFreezers]
		]
	];

	(* Generate the FreezingRack resources. *)
	freezingRackResources = Map[
		Resource[Sample -> #, Rent -> True, Name -> CreateUUID[]]&,
		uniqueFreezingRacksByBatch
	];

	freezingRackResourcesLink = Link /@ Flatten[MapThread[
		Function[{rackResource, indexGroup},
			ConstantArray[rackResource, Length[indexGroup]]
		],
		{freezingRackResources, expandedSampleIndicesByFreezingBatch}
	]];

	freezingCellTime = If[MatchQ[resolvedFreezingStrategy, ControlledRateFreezer],
		Max[resolvedTemperatureProfile[[All,2]]] + 15 Minute,
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
	(* 9."Returning Materials" (main protocol procedure)*)
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
			{"Cell Pelleting", Max[Cases[ToList[expandedCellPelletTimes], TimeP]], "Cell samples are centrifuged to enable removal of existing media.", Link[Resource[Operator -> $BaselineOperator, Time -> Max[Cases[ToList[expandedCellPelletTimes], TimeP]]]]},
			Nothing
		],
		(* ChangeMedia,Aspirate, AddCryoprotectant, Aliquot and Mix in biosafety cabinet. *)
		{"Preparing CryogenicSampleContainer", 1 Hour, "Original samples are mixed or media exchanged and resuspended, then aliquoted to CryogenicSampleContainer together with CryoprotectantSolutions.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
		{"Freezing Cells", freezingCellTime, "Samples are placed in a freezer.", Link[Resource[Operator -> $BaselineOperator, Time -> freezingCellTime]]},
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

(* Find all cryogenic vials, insulated coolers and racks, and racks for the controlled rate freezer. *)
freezeCellsContainerSearch[testString: _String] := freezeCellsContainerSearch[testString] = Module[{},
	(* Add freezeCellsContainerSearch to list of Memoized functions. *)
	AppendTo[$Memoization, Experiment`Private`freezeCellsContainerSearch];
	Search[
		Model[Container],
		Footprint == Alternatives[CryogenicVial, ControlledRateFreezerRack, MrFrostyContainer, MrFrostyRack] && Deprecated != True
	]
];

(* Find all instruments that might be used in ExperimentFreezeCells. *)
freezeCellsInstrumentSearch[testString: _String] := freezeCellsInstrumentSearch[testString] = Module[{},
	(* Add freezeCellsInstrumentSearch to list of Memoized functions. *)
	AppendTo[$Memoization, Experiment`Private`freezeCellsInstrumentSearch];
	Search[
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
