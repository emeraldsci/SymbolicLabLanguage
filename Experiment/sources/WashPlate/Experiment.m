(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentWashPlate Options*)

(*ExperimentWashPlate Options*)
(* $MinWashVolume is based on currently BioTek 405LS plate washer model. We only allow standard-height (13mm-16mm) SBS plate, which has a MaxVolume at 330-400 Microliter *)
$MinWashVolume = 50 Microliter;
$MaxWashVolume = 300 Microliter;
$DefaultDispenseFlowRateConversion = {
	<|Relative -> 3, Scientific -> 204 Microliter/Second|>,
	<|Relative -> 4, Scientific -> 244 Microliter/Second|>,
	<|Relative -> 5, Scientific -> 273 Microliter/Second|>,
	<|Relative -> 6, Scientific -> 306 Microliter/Second|>,
	<|Relative -> 7, Scientific -> 325 Microliter/Second|>,
	<|Relative -> 8, Scientific -> 352 Microliter/Second|>,
	<|Relative -> 9, Scientific -> 375 Microliter/Second|>,
	<|Relative -> 10, Scientific -> 391 Microliter/Second|>,
	<|Relative -> 11, Scientific -> 418 Microliter/Second|>
};
$DefaultAspirateTravelRateConversion = {
	<|Relative -> 1, Scientific -> 4.1 Millimeter/Second|>,
	<|Relative -> 2, Scientific -> 5.0 Millimeter/Second|>,
	<|Relative -> 3, Scientific -> 7.3 Millimeter/Second|>,
	<|Relative -> 4, Scientific -> 8.4 Millimeter/Second|>,
	<|Relative -> 5, Scientific -> 9.0 Millimeter/Second|>
};

DefineOptions[ExperimentWashPlate,
	Options :> {
		{
			OptionName -> Instrument,
			Default -> Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"],
			Description -> "The instrument designed to dispense, aspirate, and wash liquid contents from input sample containers in 96-well plate format. It performs controlled washing cycles by delivering Buffer, removing residual liquids, and minimizing cross-contamination between wells.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Model[Instrument, PlateWasher], Object[Instrument, PlateWasher]
				}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Plate Washers"
					}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> Method,
			Default -> Automatic,
			Description -> "The file containing a set of parameters define how the plate washer aspirates, dispenses, and manages liquid flow during washing steps, including speeds, heights, delays, and positioning for optimal washing efficiency. If Method is set to Custom, a new method object will be created with the filename \"Customized WashPlate Method from <ProtocolID> #\" at the time of protocol creation with all the specified PlateWasher settings.",
			ResolutionDescription -> "If Aspiration and Dispensing options (such as AspirateTravelRate, AspirateDelay, AspirationPositionOffset, DispenseFlowRate, BottomWash) are specified, automatically set to a WashPlate method which meets all the requirements, or set to Custom if no existing methods have desired Aspiration and Dispensing options. Automatically set to Object[Method, WashPlate, \"BioTek 405LS Default\"] if none of Aspiration and Dispensing options are specified.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Existing Method" -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Method, WashPlate]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Pipetting Methods",
							"Plate Washers"
						}
					}
				],
				"Custom" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Custom]
				]
			],
			Category -> "General"
		},
		{
			OptionName -> MethodFileName,
			Default -> Automatic,
			Description -> "The name of the LHC format method file containing the run parameters for this unit operation.",
			ResolutionDescription -> "If Method is an existing file, automatically set to the method name appended with a UUID, or \"Existing WashPlate Method #.LHC\" where # is UUID if no name is found. If Method is Custom, automatically set to \"Customized WashPlate Method #.LHC\" where # is UUID.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			],
			Category -> "Hidden"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> SampleLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the samples that are being washed, for use in downstream unit operations.",
				ResolutionDescription -> "Automatically set to \"Washed Plate Sample #\".",
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
				OptionName -> SampleContainerLabel,
				Default -> Automatic,
				Description -> "A user defined word or phrase used to identify the containers of the samples that are being washed, for use in downstream unit operations.",
				ResolutionDescription -> "Automatically set to \"Washed Container Plate #\".",
				AllowNull -> False,
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
			OptionName -> Buffer,
			Default -> Model[Sample, StockSolution, "1x PBS from 10X stock"],
			Description -> "The solution used to rinse off unbound molecules from the input sample containers.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Enzyme-Linked Immunosorbent Assay (ELISA)",
						"Robotic ELISA",
						"Washing Buffers"
					}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> NumberOfWashes,
			Default -> 4,
			Description -> "The number of washes performed to rinse off unbound blocking reagents. Each wash cycle first aspirates from, and then dispenses WashBuffer to, the input sample containers.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 10, 1]
			],
			Category -> "General"
		},
		{
			OptionName -> WashVolume,
			Default -> 250 Microliter,
			Description -> "The volume of Buffer added per wash cycle per well to the input sample containers.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinWashVolume, $MaxWashVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			],
			Category -> "General"
		},
		{
			OptionName -> Priming,
			Default -> True,
			Description -> "Indicates whether an initial priming step is performed prior to plate washing. Priming conditions the 96-Tube manifold of the Instrument by dispensing a defined volume of fresh buffer through all channels before a wash cycle begins. This step removes air pockets, replaces any evaporated or stagnant buffer, stabilizes the initial dispense volume, and ensures that all wells receive uniform wash buffer from the start of the run. Priming is also used when switching buffers to clear residual reagent from the lines. Priming is recommended before the first wash in a workflow to ensure consistent dispense performance. When multiple WashPlate unit operations are executed sequentially, subsequent operations may skip the priming step if they use the same Buffer, since the manifold is already conditioned with that wash buffer.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "General"
		},
		{
			OptionName -> PrimeVolume,
			Default -> Automatic,
			Description -> "The total amount of buffer dispensed through 96-Tube manifold during the priming step. A PrimeVolume of 300 mL is recommended when changing wash buffers or initializing the plate washer, ensuring that all manifold tubing is fully flushed. A smaller PrimeVolume of 50 mL is recommended to compensate for evaporation loss when the plate washer has been idle for an extended period. This option is applicable only when Priming is set to True.",
			ResolutionDescription -> "If Prime is set to True, automatically set to 300 Milliliter.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[300 Milliliter|50 Milliliter]
			],
			Category -> "Priming"
		},
		{
			OptionName -> AspirateTravelRate,
			Default -> Automatic,
			Description -> "The rate at which the plate washer manifold travels down into the wells.",
			ResolutionDescription -> "Automatically set to match the AspirateTravelRate field in the Method file, or set to 5 if Method is Custom.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Relative unit" -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 5, 1]
				],
				"Scientific unit" -> Widget[
					Type -> Enumeration,
					Pattern :> PlateWasherTravelRateP
				]
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> AspirateDelay,
			Default -> Automatic,
			Description -> "The time delay between dispensing and aspiration. When AspirationDelay is Null, aspiration and dispensing occurs simultaneously.",
			ResolutionDescription -> "Automatically set to match the AspirateDelay field in the Method file, or set to Null if Method is Custom.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Millisecond],
				Units -> Millisecond
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> AspirationPositionOffset,
			Default -> Automatic,
			Description -> "The aspiration coordinates relative to the center of the well. XOffset represents the horizontal distance from the center of the well, with leftward position expressed as negative value. YOffset represents the horizontal distance from the center, with position behind the center expressed as negative value. ZOffset specifies the vertical distance above the carrier surface (bottom of the plate).",
			ResolutionDescription -> "Automatically set to match the AspirationPositionOffset field in the Method file, or set to Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}] if Method is Custom.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Expression,
				Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
				Size -> Line
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> CrosswiseAspiration,
			Default -> Automatic,
			Description -> "Indicates if a secondary aspiration in a different location within the well is performed immediately after each aspiration in a wash cycle. CrosswiseAspiration is performed immediately after each aspiration step within a wash cycle to further reduce residual liquid remaining in the wells. By moving the aspirate tubes from one side of the well to the other, this process prevents the formation of a continuous fluid stream, thereby minimizing the risk of dislodging material adhered to the well bottom.",
			ResolutionDescription -> "Automatically set to match the CrosswiseAspiration field in the Method file, or set to False if Method is Custom.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> CrosswiseAspirationPositionOffset,
			Default -> Automatic,
			Description -> "The secondary aspiration coordinates relative to the center of the well. It is typically positioned on the opposite side of the well along the X-axis compared to the AspirationPositionOffset. XOffset represents the horizontal distance from the center of the well, with leftward position expressed as negative value. YOffset represents the horizontal distance from the center, with position behind the center expressed as negative value. ZOffset specifies the vertical distance above the carrier surface (bottom of the plate).",
			ResolutionDescription -> "Automatically set to match the CrosswiseAspirationPositionOffset field in the Method file. If Method is Custom and CrosswiseAspirate is True, automatically set to the same value as AspiratePositionOffset.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Expression,
				Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
				Size -> Line
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> FinalAspiration,
			Default -> Automatic,
			Description -> "Indicates whether a final aspiration step is executed after all wash cycles to remove liquid from all wells. When FinalAspiration is set to False, no additional aspiration step is performed at the end of the wash sequence, and wells will retain Buffer at the volume defined by WashVolume.",
			ResolutionDescription -> "Automatically set to match the FinalAspiration field in the Method file, or set to True if Method is Custom.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> FinalAspirateTravelRate,
			Default -> Automatic,
			Description -> "The rate at which the plate washer manifold travels down into the wells during the final aspiration.",
			ResolutionDescription -> "Automatically set to match the FinalAspirateTravelRate field in the Method file. If Method is Custom and FinalAspirate is True, automatically set to the same value as AspirateTravelRate.",
			AllowNull -> True,
			Widget -> Alternatives[
				"Relative unit" -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 5, 1]
				],
				"Scientific unit" -> Widget[
					Type -> Enumeration,
					Pattern :> PlateWasherTravelRateP
				]
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> FinalAspirateDelay,
			Default -> Automatic,
			Description -> "The time delay between dispensing and the final aspiration. When FinalAspirationDelay is Null, the final aspiration and dispensing occurs simultaneously.",
			ResolutionDescription -> "Automatically set to match the FinalAspirateDelay field in the Method file.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Millisecond],
				Units -> Millisecond
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> FinalAspirationPositionOffset,
			Default -> Automatic,
			Description -> "The final aspiration coordinates relative to the center of the well. XOffset represents the horizontal distance from the center of the well, with leftward position expressed as negative value. YOffset represents the horizontal distance from the center, with position behind the center expressed as negative value. ZOffset specifies the vertical distance above the carrier surface (bottom of the plate).",
			ResolutionDescription -> "Automatically set to match the FinalAspirationPositionOffset field in the Method file. If Method is Custom and FinalAspirate is True, automatically set to the same value as AspiratePositionOffset.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Expression,
				Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
				Size -> Line
			],
			Category -> "Aspiration"
		},
		{
			OptionName -> DispenseFlowRate,
			Default -> Automatic,
			Description -> "The rate at which the fluid is dispensed from the manifold tubes.",
			ResolutionDescription -> "Automatically set to match the DispenseFlowRate field in the Method file, or set to 8 if Method is Custom.",
			AllowNull -> False,
			Widget -> Alternatives[
				"Relative unit" -> Widget[
					Type -> Number,
					Pattern :> RangeP[3, 11, 1]
				],
				"Scientific unit" -> Widget[
					Type -> Enumeration,
					Pattern :> PlateWasherFlowRateP
				]
			],
			Category -> "Dispensing"
		},
		{
			OptionName -> DispensePositionOffset,
			Default -> Automatic,
			Description -> "The dispensing coordinates relative to the center of the well. XOffset represents the horizontal distance from the center of the well, with leftward position expressed as negative value. YOffset represents the horizontal distance from the center, with position behind the center expressed as negative value. ZOffset specifies the vertical distance above the carrier surface (bottom of the plate).",
			ResolutionDescription -> "Automatically set to match the DispensePositionOffset field in the Method file, or set to Coordinate[{0 Millimeter, 0 Millimeter, 15.24 Millimeter}] if Method is Custom.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Expression,
				Pattern :> Coordinate[{DistanceP, DistanceP, GreaterEqualP[0 Millimeter]}],
				Size -> Line
			],
			Category -> "Dispensing"
		},
		{
			OptionName -> DispenseVacuumDelay,
			Default -> Automatic,
			Description -> "The dispensed volume per well after which the vacuum pump is triggered to start normal aspiration.",
			ResolutionDescription -> "Automatically set to match the DispenseVacuumDelay field in the Method file, or set to Null if Method is Custom.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, $MaxWashVolume],
				Units -> {Microliter, {Microliter, Milliliter}}
			],
			Category -> "Dispensing"
		},
		{
			OptionName -> BottomWash,
			Default -> Automatic,
			Description -> "Indicates if an initial dispense/aspirate sequence is added before the first wash cycle where Buffer is dispensed and aspirated from the bottom of the wells. BottomWash is recommended for strongly bound molecules in assays that require vigorous washing, adding a bottom wash to the protocol has shown reduced background noise without increasing the number of wash cycles.",
			ResolutionDescription -> "Automatically set to match the BottomWash field in the Method file, or set to False if Method is Custom.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Dispensing"
		},
		(*===Shared Options===*)
		FastTrackOption,
		ProtocolOptions,
		ModifyOptions[
			PreparationOption,
			{
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Robotic]],
				Category -> "Hidden"
			}
		],
		ModifyOptions[
			WorkCellOption,
			{
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[STAR]],
				Category -> "Hidden"
			}
		],
		NonBiologyPostProcessingOptions,
		SimulationOption,
		SubprotocolDescriptionOption,
		SamplesInStorageOptions
	}
];

(* ::Subsection:: *)
(*ExperimentWashPlate*)

Error::InvalidWashPlateContainers = "`1`. `2`.";
Warning::UnusedWashPlateSamples = "WashPlate operates on the entire 96-well plate. `1`. Any samples not specified as input samples will not be retained after the wash. Please move `2`.";
Error::DuplicatedWashPlateSamples = "The input `1` duplicates. Instead of specifying the same input multiple times, please increase NumberOfWashes if additional wash cycles are desired.";
Error::InvalidPlateWasher = "The specified Instrument `1` cannot be used. `2`. Please specify a different Instrument such as `3`, or allow this option to be set automatically.";
Error::ConflictingPrimingOptions = "`1`. Please adjust the options or allow them to be set automatically.";
Error::ConflictingCrosswiseAspirationOptions = "`1`. Please adjust the options or allow them to be set automatically.";
Error::ConflictingFinalAspirationOptions = "`1`. Please adjust the options or allow them to be set automatically.";
Error::ConflictingWashPlateMethodWithAspirationOptions = "`1`. Please adjust the options or allow them to be set automatically.";
Error::ConflictingWashPlateMethodWithDispenseOptions = "`1`. Please adjust the options or allow them to be set automatically.";

(* ExperimentWashPlate *)
(* NOTE: No Container to Sample overload since we have to be able to wash empty containers. *)
(* NOTE: Internal to the experiment function, we actually convert samples into containers since we care about the container, not the sample. *)

(* -- Main Overload --*)
ExperimentWashPlate[myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]], myOptions: OptionsPattern[]] := Module[
	{
		outputSpecification, output, gatherTests, messages, listedOptions, listedInputs, validSamplePreparationResult,
		myInputsWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation, safeOpsNamed,
		safeOpsTests, myInputsWithPreparedSamples, safeOps, myOptionsWithPreparedSamples, validLengths, validLengthTests,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, cache, optionsWithoutCache, listedContainers,
		objectSampleFields, modelSampleFields, objectContainerFields, modelContainerFields, methodFields, modelInstrumentFields,
		defaultObjects, sampleObjects, sampleModels, methodObjects, instrumentModels, instrumentObjects, downloadedCache,
		cacheBall, resolvedOptionsResult, resolvedOptions,  resolvedOptionsTests, collapsedResolvedOptions, resolvedPreparation,
		optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ, performSimulationQ,
		unitOperationPacket, resourcePacketTests, updatedSimulation, roboticRunTime, protocolObject
	},

	(* Determine the requested return value from the function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests. *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Remove temporal links. *)
	{listedInputs, listedOptions} = removeLinks[ToList[myInputs], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{myInputsWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentWashPlate,
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

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTests,
		SafeOptions[ExperimentWashPlate, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentWashPlate, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Call sanitize-inputs to clean any named objects. *)
	{myInputsWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[myInputsWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> samplePreparationSimulation];

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
		ValidInputLengthsQ[ExperimentWashPlate, {myInputsWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentWashPlate, {myInputsWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
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
		ApplyTemplateOptions[ExperimentWashPlate, {ToList[myInputsWithPreparedSamples]}, ToList[myOptionsWithPreparedSamples], Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentWashPlate, {ToList[myInputsWithPreparedSamples]}, ToList[myOptionsWithPreparedSamples]], Null}
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

	(* Expand index-matching options. *)
	(* Note:here we expand options to index match inputs. If multiple samples reside in the same container and samples are inputs, *)
	(* the option length will match the length as samples; if the container is input, the option length will match the length of containers *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentWashPlate, {ToList[myInputsWithPreparedSamples]}, inheritedOptions]];

	(* Fetch the cache from expandedSafeOps. *)
	cache = ToList[Lookup[expandedSafeOps, Cache, {}]];

	(* Drop the cache from myOptions. *)
	optionsWithoutCache = Normal[KeyDrop[ToList[myOptions], Cache], Association];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Normalize our inputs all into containers. This is because WashPlate cares about the container, not about the sample. *)
	listedContainers = If[Length[Cases[myInputsWithPreparedSamples, ObjectP[Object[Sample]]]] > 0,
		Module[{samplePackets},
			(* Get the packets of any sample inputs we have. *)
			samplePackets = Download[
				Cases[myInputsWithPreparedSamples, ObjectP[Object[Sample]]],
				Packet[Container],
				Simulation -> samplePreparationSimulation
			];

			(* Replace samples with their container. *)
			myInputsWithPreparedSamples/.Rule@@@Transpose[{ObjectP/@Lookup[samplePackets, Object], Download[Lookup[samplePackets, Container], Object]}]
		],
		myInputsWithPreparedSamples
	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	objectContainerFields = DeleteDuplicates[Flatten[{SamplePreparationCacheFields[Object[Container]], Notebook}]];
	modelContainerFields = DeleteDuplicates[Flatten[{Dimensions, SamplePreparationCacheFields[Model[Container]]}]];
	objectSampleFields = SamplePreparationCacheFields[Object[Sample]];
	modelSampleFields = SamplePreparationCacheFields[Model[Sample]];
	methodFields = {Name, Instrument, MethodFile, AspirateDelay, AspirateTravelRate, AspirationPositionOffset, CrosswiseAspiration, CrosswiseAspirationPositionOffset, FinalAspiration, FinalAspirateTravelRate, FinalAspirateDelay, FinalAspirationPositionOffset, DispenseFlowRate, DispensePositionOffset, DispenseVacuumDelay, BottomWash};
	modelInstrumentFields = {WettedMaterials, XOffsetConversion, YOffsetConversion, ZOffsetConversion, AspirateTravelRateConversion, DispenseFlowRateConversion,AspirateTravelRateConversion, DispenseFlowRateConversion, MaxDispenseVolume, MinAspirateTravelRate, MaxAspirateTravelRate, MinDispenseFlowRate, MaxDispenseFlowRate, MinDispenseVacuumDelay, MaxDispenseVacuumDelay};

	defaultObjects = Join[
		allWashPlateMethodSearch["Memoization"],(* all method files *)
		{
			Model[Sample, StockSolution, "id:J8AY5jwzPdaB"],(*Model[Sample, StockSolution, "1x PBS from 10X stock"]*)
			Object[Method, WashPlate, "id:7X104vPL8edk"],(*Object[Method, WashPlate, "BioTek 405LS Default"]*)
			Model[Instrument, PlateWasher, "id:dORYzZm51LLA"](*Model[Instrument, PlateWasher, "BioTek 405LS Microplate Washer"]*)
		}
	];
	sampleObjects = Cases[Join[defaultObjects, myInputsWithPreparedSamples, optionsWithoutCache], ObjectP[Object[Sample]]];
	sampleModels = Cases[Join[defaultObjects, myInputsWithPreparedSamples, optionsWithoutCache], ObjectP[Model[Sample]]];
	methodObjects = Cases[Join[defaultObjects, optionsWithoutCache], ObjectP[Object[Method, WashPlate]]];
	instrumentModels = Cases[Join[defaultObjects, optionsWithoutCache], ObjectP[Model[Instrument, PlateWasher]]];
	instrumentObjects = Cases[Join[defaultObjects, optionsWithoutCache], ObjectP[Object[Instrument, PlateWasher]]];

	downloadedCache = Flatten@Quiet[
		Download[
			{
				listedContainers,
				sampleModels,
				sampleObjects,
				methodObjects,
				instrumentModels,
				instrumentObjects,
				ToList@Lookup[safeOps, ParentProtocol]
			},
			{
				{
					Evaluate[Packet@@objectContainerFields],
					Packet[Model[modelContainerFields]],
					Packet[Contents[[All, 2]][objectSampleFields]],
					Packet[Contents[[All, 2]][Model][modelSampleFields]]
				},
				{
					Evaluate[Packet@@modelSampleFields]
				},
				{
					Evaluate[Packet@@objectSampleFields],
					Packet[Model[modelSampleFields]],
					Packet[Container[objectContainerFields]]
				},
				{Evaluate[Packet@@methodFields]},
				{Evaluate[Packet@@modelInstrumentFields]},
				{
					Packet[Name, Status, Model],
					Packet[Model[modelInstrumentFields]]
				},
				{
					Packet[ActiveCart, RootProtocol],
					Packet[RootProtocol[Resources][Model]]
				}
			},
			Cache -> cache,
			Simulation -> samplePreparationSimulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Combine our downloaded and passed cache. *)
	cacheBall = FlattenCachePackets[{cache, downloadedCache}];

	(* Build the resolved options. *)
	(* Pass in both listedInputs and listedContainers since we want to consolidate wash based on unique containers also allow washing the same container more than 1 time *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentWashPlateOptions[
			listedInputs,
			listedContainers,
			expandedSafeOps,
			Cache -> cacheBall,
			Simulation -> samplePreparationSimulation,
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
				resolveExperimentWashPlateOptions[
					listedInputs,
					listedContainers,
					expandedSafeOps,
					Cache -> cacheBall,
					Simulation -> samplePreparationSimulation
				],
				{}
			},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options. *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentWashPlate,
		resolvedOptions,
		Ignore -> ToList[myOptions],
		Messages -> False
	];

	(* lookup our OptionsResolverOnly option.  This will determine if we skip the resource packets and simulation functions *)
	(* if Output contains Result or Simulation, then we can't do this *)
	{resolvedPreparation, optionsResolverOnly} = Lookup[resolvedOptions, {Preparation, OptionsResolverOnly}];
	returnEarlyBecauseOptionsResolverOnly = TrueQ[optionsResolverOnly] && Not[MemberQ[output, Result|Simulation]];

	(* Run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early. *)
	returnEarlyBecauseFailuresQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* Figure out if we need to perform our simulation. *)
	(* NOTE: We need to perform simulation if Result is required because we pass down our simulation to ExperimentRSP. *)
	performSimulationQ = MemberQ[output, Result | Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentWashPlate, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources. *)
	(* NOTE: unitOperationPacket is either $Failed or unitOperationPackets *)
	{unitOperationPacket, resourcePacketTests} = Which[
		MatchQ[resolvedOptionsResult, $Failed],
			{$Failed, {}},
		gatherTests,
			washPlateResourcePackets[
				listedInputs,
				listedContainers,
				templatedOptions,
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> samplePreparationSimulation,
				Output -> {Result, Tests}
			],
		True,
			{
				washPlateResourcePackets[
					listedInputs,
					listedContainers,
					templatedOptions,
					resolvedOptions,
					Cache -> cacheBall,
					Simulation -> samplePreparationSimulation
				],
				{}
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	updatedSimulation = If[!performSimulationQ || returnEarlyBecauseFailuresQ,
		samplePreparationSimulation,
		simulateExperimentWashPlate[
			unitOperationPacket,
			listedInputs,
			listedContainers,
			resolvedOptions,
			Cache -> cacheBall,
			Simulation -> samplePreparationSimulation,
			ParentProtocol -> Lookup[safeOps, ParentProtocol]
		]
	];

	roboticRunTime = washPlateRunTime[Length[DeleteDuplicates@listedContainers], Lookup[resolvedOptions, NumberOfWashes], Lookup[resolvedOptions, Priming]];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output, Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentWashPlate, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> updatedSimulation,
			RunTime -> roboticRunTime
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = Which[
		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[unitOperationPacket, $Failed],
			$Failed,

		(* If Preparation->Robotic and Upload->False, return our unit operations packets back without RequireResources called  *)
		(* But we also want to upload method to constellation if there is a customized one. So WashPlateMethod when we call WashPlate from RSP directly *)
		MatchQ[Lookup[safeOps, Upload], False],
			Module[{customizedMethodPacket, methodID},
				(* Create new Object[Method,WashPlate] if Method is Custom *)
				customizedMethodPacket = If[MatchQ[Lookup[collapsedResolvedOptions, Method], Custom] && NullQ[Lookup[unitOperationPacket, WashPlateMethod, Null]],
					Module[
						{
							newMethodFileName, resolvedInstrument, instrumentModel, instrumentModelPacket, convertedAspirateTravelRate,
							convertedAspirationPositionOffset, convertedCrosswiseAspirationPositionOffset, convertedFinalAspirateTravelRate,
							convertedFinalAspirationPositionOffset, convertedDispenseFlowRate, convertedDispensePositionOffset
						},
						newMethodFileName = If[StringEndsQ[Lookup[collapsedResolvedOptions, MethodFileName], ".LHC"],
							StringDrop[Lookup[collapsedResolvedOptions, MethodFileName], -4],
							Lookup[collapsedResolvedOptions, MethodFileName]
						];
						resolvedInstrument = Lookup[collapsedResolvedOptions, Instrument];
						instrumentModel = If[MatchQ[resolvedInstrument, ObjectP[Object[Instrument]]],
							Lookup[fetchPacketFromCache[resolvedInstrument, cacheBall], Model],
							resolvedInstrument
						];
						instrumentModelPacket = fetchPacketFromCache[instrumentModel, cacheBall];
						(* Convert the format for method *)
						{
							convertedAspirateTravelRate,
							convertedAspirationPositionOffset,
							convertedCrosswiseAspirationPositionOffset,
							convertedFinalAspirateTravelRate,
							convertedFinalAspirationPositionOffset,
							convertedDispenseFlowRate,
							convertedDispensePositionOffset
						} = Lookup[
							convertToBioTekUnits[
								instrumentModelPacket,
								collapsedResolvedOptions
							],
							{
								AspirateTravelRate,
								AspirationPositionOffset,
								CrosswiseAspirationPositionOffset,
								FinalAspirateTravelRate,
								FinalAspirationPositionOffset,
								DispenseFlowRate,
								DispensePositionOffset
							}
						];
						<|
							Type -> Object[Method, WashPlate],
							Name -> newMethodFileName,
							Instrument -> Link[instrumentModel],
							AspirateTravelRate -> convertedAspirateTravelRate,
							AspirateDelay -> Lookup[collapsedResolvedOptions, AspirateDelay],
							AspirationPositionOffset -> convertedAspirationPositionOffset,
							CrosswiseAspiration -> Lookup[collapsedResolvedOptions, CrosswiseAspiration],
							CrosswiseAspirationPositionOffset -> convertedCrosswiseAspirationPositionOffset,
							FinalAspiration -> Lookup[collapsedResolvedOptions, FinalAspiration],
							FinalAspirateTravelRate -> convertedFinalAspirateTravelRate,
							FinalAspirationPositionOffset -> convertedFinalAspirationPositionOffset,
							FinalAspirateDelay -> Lookup[collapsedResolvedOptions, FinalAspirateDelay],
							DispenseFlowRate -> convertedDispenseFlowRate,
							DispensePositionOffset -> convertedDispensePositionOffset,
							DispenseVacuumDelay -> Lookup[collapsedResolvedOptions, DispenseVacuumDelay],
							BottomWash -> Lookup[collapsedResolvedOptions, BottomWash]
						|>
					],
					{}
				];
				(* Upload new method object to constellation *)
				methodID = Upload[customizedMethodPacket];

				(* Update the OutputUnitOperation WashPlateMethod field value *)
				If[!MatchQ[customizedMethodPacket, {}],
					Join[unitOperationPacket, <|WashPlateMethod -> Link[methodID]|>],
					(* If the WashPlateMethod has been filled in resource packet (when using an existing method), just return unitOperationPacket *)
					unitOperationPacket (* unitOperationPackets *)
				]
			],

		(* If we're doing Preparation->Robotic and Upload->True, call ExperimentRoboticSamplePreparation with our primitive. *)
		True,
			Module[{primitive, nonHiddenOptions, protocolID, customizedMethodPacket, methodID},
				(* Create our transfer primitive to feed into RoboticSamplePreparation. *)
				primitive = WashPlate@@Join[
					{
						Sample -> Download[ToList[listedInputs], Object]
					},
					RemoveHiddenPrimitiveOptions[WashPlate, ToList[myOptions]]
				];

				(* Remove any hidden options before returning. *)
				nonHiddenOptions = RemoveHiddenOptions[ExperimentWashPlate, collapsedResolvedOptions];

				(* Memoize the value of ExperimentWashPlate so the framework doesn't spend time resolving it again. *)
				Internal`InheritedBlock[{ExperimentWashPlate, $PrimitiveFrameworkResolverOutputCache},
					$PrimitiveFrameworkResolverOutputCache = <||>;

					DownValues[ExperimentWashPlate] = {};

					ExperimentWashPlate[___, options: OptionsPattern[]] := Module[{frameworkOutputSpecification},
						(* Lookup the output specification the framework is asking for. *)
						frameworkOutputSpecification = Lookup[ToList[options], Output];

						frameworkOutputSpecification/.{
							Result -> unitOperationPacket,
							Options -> nonHiddenOptions,
							Preview -> Null,
							Simulation -> updatedSimulation,
							RunTime -> roboticRunTime
						}
					];

					protocolID = ExperimentRoboticSamplePreparation[
						{primitive},
						Name -> Lookup[safeOps, Name],
						Upload -> Lookup[safeOps, Upload],
						Confirm -> Lookup[safeOps, Confirm],
						CanaryBranch -> Lookup[safeOps, CanaryBranch],
						ParentProtocol -> Lookup[safeOps, ParentProtocol],
						Priority -> Lookup[safeOps, Priority],
						StartDate -> Lookup[safeOps, StartDate],
						HoldOrder -> Lookup[safeOps, HoldOrder],
						QueuePosition -> Lookup[safeOps, QueuePosition],
						Cache -> cacheBall
					];

					(* Create new Object[Method,WashPlate] if Method is Custom *)
					customizedMethodPacket = If[MatchQ[Lookup[resolvedOptions, Method], Custom],
						Module[
							{
								newMethodFileName, resolvedInstrument, instrumentModel, instrumentModelPacket, convertedAspirateTravelRate,
								convertedAspirationPositionOffset, convertedCrosswiseAspirationPositionOffset, convertedFinalAspirateTravelRate,
								convertedFinalAspirationPositionOffset, convertedDispenseFlowRate, convertedDispensePositionOffset
							},
							newMethodFileName = If[StringEndsQ[Lookup[collapsedResolvedOptions, MethodFileName], ".LHC"],
								StringDrop[Lookup[collapsedResolvedOptions, MethodFileName], -4],
								Lookup[collapsedResolvedOptions, MethodFileName]
							];
							resolvedInstrument = Lookup[nonHiddenOptions, Instrument];
							instrumentModel = If[MatchQ[resolvedInstrument, ObjectP[Object[Instrument]]],
								Lookup[fetchPacketFromCache[resolvedInstrument, cacheBall], Model],
								resolvedInstrument
							];
							instrumentModelPacket = fetchPacketFromCache[instrumentModel, cacheBall];
							(* Convert the format for method *)
							{
								convertedAspirateTravelRate,
								convertedAspirationPositionOffset,
								convertedCrosswiseAspirationPositionOffset,
								convertedFinalAspirateTravelRate,
								convertedFinalAspirationPositionOffset,
								convertedDispenseFlowRate,
								convertedDispensePositionOffset
							} = Lookup[
								convertToBioTekUnits[
									instrumentModelPacket,
									nonHiddenOptions
								],
								{
									AspirateTravelRate,
									AspirationPositionOffset,
									CrosswiseAspirationPositionOffset,
									FinalAspirateTravelRate,
									FinalAspirationPositionOffset,
									DispenseFlowRate,
									DispensePositionOffset
								}
							];
							<|
								Type -> Object[Method, WashPlate],
								Name -> newMethodFileName,
								Instrument -> Link[instrumentModel],
								AspirateTravelRate -> convertedAspirateTravelRate,
								AspirateDelay -> Lookup[nonHiddenOptions, AspirateDelay],
								AspirationPositionOffset -> convertedAspirationPositionOffset,
								CrosswiseAspiration -> Lookup[nonHiddenOptions, CrosswiseAspiration],
								CrosswiseAspirationPositionOffset -> convertedCrosswiseAspirationPositionOffset,
								FinalAspiration -> Lookup[nonHiddenOptions, FinalAspiration],
								FinalAspirateTravelRate -> convertedFinalAspirateTravelRate,
								FinalAspirationPositionOffset -> convertedFinalAspirationPositionOffset,
								FinalAspirateDelay -> Lookup[nonHiddenOptions, FinalAspirateDelay],
								DispenseFlowRate -> convertedDispenseFlowRate,
								DispensePositionOffset -> convertedDispensePositionOffset,
								DispenseVacuumDelay -> Lookup[nonHiddenOptions, DispenseVacuumDelay],
								BottomWash -> Lookup[nonHiddenOptions, BottomWash]
							|>
						],
						{}
					];
					(* Upload new method object to constellation *)
					methodID = Upload[customizedMethodPacket];

					(* Update the OutputUnitOperation WashPlateMethod field value *)
					(* For robotic branch, there is one and only OutputUnitOperation in unitOperationPackets *)
					If[!MatchQ[customizedMethodPacket, {}],
						Upload[<|
							Object -> Download[unitOperationPacket, Object],
							WashPlateMethod -> Link[methodID]
						|>]
					];

					(* Return ID *)
					protocolID

				]
			]
	];

	(* Return requested output. *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentWashPlate, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> updatedSimulation,
		RunTime -> roboticRunTime
	}
];

(* ::Subsection:: *)
(*resolveWashPlateMethod*)

DefineOptions[resolveWashPlateMethod,
	SharedOptions :> {
		ExperimentWashPlate,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: myContainers can be Automatic when the user has not yet specified a value for autofill. *)
resolveWashPlateMethod[
	myContainers: ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myOptions: OptionsPattern[]
] := Module[
	{
		safeOptions, outputSpecification, output, gatherTests, result, tests
	},

	(* Get our safe options. *)
	safeOptions = SafeOptions[resolveWashPlateMethod, ToList[myOptions]];

	(* Determine the requested return value from the function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests. *)
	gatherTests = MemberQ[output, Tests];

	result = {Robotic};
	tests = {};

	outputSpecification/.{Result -> result, Tests -> tests}
];

(* ::Subsubsection::Closed:: *)
(*resolveWashPlateWorkCell*)

resolveWashPlateWorkCell[
	myContainers: ListableP[Automatic|ObjectP[{Object[Sample], Object[Container]}]],
	myOptions: OptionsPattern[resolveWashPlateWorkCell]
] := {STAR};

(* ::Subsection:: *)
(*Helpers*)

(*-- Helper:washPlateRunTime --*)
(*washPlateRunTime*)
(* It takes 3 Minute to load and unload each plate to the plate washer, and 20s for each wash cycle *)
washPlateRunTime[numberOfContainers_Integer, numberOfWashes_Integer, priming: BooleanP] := If[TrueQ[priming],
	numberOfContainers*(20 Second * numberOfWashes + 3 Minute) + 3 Minute,
	numberOfContainers*(20 Second * numberOfWashes + 3 Minute)
];

(*-- Helper:allWashPlateMethodSearch --*)
(* Cache wash plate method files *)
allWashPlateMethodSearch[anyString_] := allWashPlateMethodSearch[anyString] = Module[{},
	If[!MemberQ[$Memoization, Experiment`Private`allWashPlateMethodSearch],
		AppendTo[$Memoization, Experiment`Private`allWashPlateMethodSearch]
	];

	Search[Object[Method, WashPlate], Notebook == Null && DeveloperObject != True]
];

(*-- Helper:matchWashPlateMethod --*)
(* Filter wash plate method files with specified values *)
matchWashPlateMethod[
	allMethodPackets: {PacketP[Object[Method, WashPlate]]..},
	semiResolvedRules: {_Rule..}
] := Module[{methodKeys, matchedPatternList},
	methodKeys = {
		Instrument, AspirateTravelRate, AspirateDelay, AspirationPositionOffset,
		CrosswiseAspiration, CrosswiseAspirationPositionOffset,
		FinalAspiration, FinalAspirateTravelRate, FinalAspirationPositionOffset, FinalAspirateDelay,
		DispenseFlowRate, DispensePositionOffset, DispenseVacuumDelay, BottomWash
	};
	matchedPatternList = Map[
		Function[{key},
			Which[
				!KeyMemberQ[semiResolvedRules, key], Nothing,
				MatchQ[Lookup[semiResolvedRules, key], Automatic], Nothing,
				MatchQ[key, Instrument], key -> ObjectP[Lookup[semiResolvedRules, key]],
				True, key -> Lookup[semiResolvedRules, key]
			]
		],
		methodKeys
	];
	Cases[
		allMethodPackets,
		KeyValuePattern[matchedPatternList]
	]
];

(*-- Helper:whyCantThisBeWashedByPlateWasher --*)
(* A local helper to check container model packet why it cannot be WashPlate. If a container can be washed by PlateWasher, return <||> *)
whyCantThisBeWashedByPlateWasher[
	containerModelPacket: Null|<||>|PacketP[Model[Container]]
] := Module[
	{
		noModelQ, containerNumberOfWells, wellPositions, containerWellBottom, containerFootprint, containerLiquidHandlerPrefix,
		containerDimensions, containerMaxVolume, plateAllowedPositions, outputAssoc
	},
	(* Check if the model packet is valid *)
	noModelQ = !MatchQ[containerModelPacket, PacketP[Model[Container, Plate]]];
	{
		containerNumberOfWells,
		wellPositions,
		containerWellBottom,
		containerFootprint,
		containerLiquidHandlerPrefix,
		containerDimensions,
		containerMaxVolume
	} = If[TrueQ[noModelQ],
		{Null, Null, Null, Null, Null, Null, Null},
		Lookup[containerModelPacket, {NumberOfWells, Positions, WellBottom, Footprint, LiquidHandlerPrefix, Dimensions, MaxVolume}, Null]
	];
	(* Gather allowed sample positions from ELISA plate model. *)
	plateAllowedPositions = Flatten[AllWells["A1", "H12"]];
	(* To be washed by PlateWasher, the containers have to
	1)NumberOfWells === 96, and well position is A1-H12 (For example, Irregular Crystallization cannot be used)
	2)Footprint === Plate && WellBottom == FlatBottom
	3)Dimensions[[3]] >= 0.013 Meter && Dimensions[[3]] <= 0.016 Meter
	4)LiquidHandlerPrefix != Null
	5)MaxVolume < 0.3 ml
	*)
	(* If a container can be washed, return <||>, otherwise return why it cannot be washed *)
	outputAssoc = <|
		If[TrueQ[noModelQ],
			Model -> Null,
			Nothing
		],
		If[Or[
			NullQ[containerNumberOfWells],
			!EqualQ[containerNumberOfWells, 96],
			NullQ[wellPositions],
			MemberQ[Lookup[wellPositions, Name], Except[Alternatives@@plateAllowedPositions]]
		],
			NumberOfWells -> containerNumberOfWells,
			Nothing
		],
		If[MatchQ[containerWellBottom, Except[FlatBottom]],
			WellBottom -> containerWellBottom,
			Nothing
		],
		If[MatchQ[containerFootprint, Except[Plate]],
			Footprint -> containerFootprint,
			Nothing
		],
		If[NullQ[containerLiquidHandlerPrefix],
			LiquidHandlerPrefix -> containerLiquidHandlerPrefix,
			Nothing
		],
		If[MatchQ[containerDimensions, Null|{}] || LessQ[containerDimensions[[3]], 0.013 Meter] || GreaterQ[containerDimensions[[3]], 0.016 Meter],
			Dimensions -> containerDimensions,
			Nothing
		],
		If[NullQ[containerMaxVolume] || LessQ[containerMaxVolume, 300 Microliter],
			MaxVolume -> containerMaxVolume,
			Nothing
		]
	|>
];

(*-- Helper:convertToBioTekUnits --*)
(* A local helper to convert scientific units to BioTek PlateWasher relative units *)
convertToBioTekUnits[
	instrumentModelPacket: PacketP[Model[Instrument, PlateWasher]],
	myOptions: {_Rule...}
] := Module[
	{
		xOffsetConversion, yOffsetConversion, zOffsetConversion, aspirateTravelRateConversion, dispenseFlowRateConversion,
		aspirateTravelRateReplacement, dispenseFlowRateReplacement
	},

	xOffsetConversion = Lookup[instrumentModelPacket, XOffsetConversion, 0.0455 Millimeter];
	yOffsetConversion = Lookup[instrumentModelPacket, YOffsetConversion, 0.074 Millimeter];
	zOffsetConversion = Lookup[instrumentModelPacket, ZOffsetConversion, 0.127 Millimeter];
	aspirateTravelRateConversion = Lookup[
		instrumentModelPacket,
		AspirateTravelRateConversion,
		$DefaultAspirateTravelRateConversion
	];
	dispenseFlowRateConversion = Lookup[
		instrumentModelPacket,
		DispenseFlowRateConversion,
		$DefaultDispenseFlowRateConversion
	];
	aspirateTravelRateReplacement = aspirateTravelRateConversion /. <|Relative -> r_, Scientific -> s_|> :> r -> s;
	dispenseFlowRateReplacement = dispenseFlowRateConversion /. <|Relative -> r_, Scientific -> s_|> :> r -> s;
	Map[
		Function[{option},
			Module[{optionValue, newValue},
				optionValue = Lookup[myOptions, option];
				newValue = Which[
					(* If the value is not in scientific unit, no need to convert *)
					MatchQ[optionValue, Automatic|Null|_Integer],
						optionValue,
					MatchQ[option, AspirateTravelRate],
						optionValue/.aspirateTravelRateReplacement,
					MatchQ[option, DispenseFlowRate],
						optionValue/.dispenseFlowRateReplacement,
					(* Otherwise, it is BlahPositionOffset option. Round the motor step to nearest integer. Note SafeRound does not work since it does not change real head to integer *)
					True,
						<|
							XOffset -> IntegerPart@SafeRound[optionValue[[-1]][[1]]/xOffsetConversion, 1],
							YOffset -> IntegerPart@SafeRound[optionValue[[-1]][[2]]/yOffsetConversion, 1],
							ZOffset -> IntegerPart@SafeRound[optionValue[[-1]][[3]]/zOffsetConversion, 1]
						|>
				];
				option -> newValue
			]
		],
		{
			AspirateTravelRate,
			AspirationPositionOffset,
			CrosswiseAspirationPositionOffset,
			FinalAspirateTravelRate,
			FinalAspirationPositionOffset,
			DispenseFlowRate,
			DispensePositionOffset
		}
	]
];

(*-- Helper:convertFromBioTekUnits --*)
(* A local helper to convert BioTek PlateWasher relative units to scientific units *)
convertFromBioTekUnits[
	instrumentModelPacket: PacketP[Model[Instrument, PlateWasher]],
	methodPacket: <||>|PacketP[Object[Method, WashPlate]]
] := Module[
	{
		xOffsetConversion, yOffsetConversion, zOffsetConversion, aspirateTravelRateConversion, dispenseFlowRateConversion,
		aspirateTravelRateReplacement, dispenseFlowRateReplacement
	},

	xOffsetConversion = Lookup[instrumentModelPacket, XOffsetConversion, 0.0455 Millimeter];
	yOffsetConversion = Lookup[instrumentModelPacket, YOffsetConversion, 0.074 Millimeter];
	zOffsetConversion = Lookup[instrumentModelPacket, ZOffsetConversion, 0.127 Millimeter];
	aspirateTravelRateConversion = Lookup[
		instrumentModelPacket,
		AspirateTravelRateConversion,
		$DefaultAspirateTravelRateConversion
	];
	dispenseFlowRateConversion = Lookup[
		instrumentModelPacket,
		DispenseFlowRateConversion,
		$DefaultDispenseFlowRateConversion
	];
	aspirateTravelRateReplacement = aspirateTravelRateConversion /. <|Relative -> r_, Scientific -> s_|> :> s -> r;
	dispenseFlowRateReplacement = dispenseFlowRateConversion /. <|Relative -> r_, Scientific -> s_|> :> s -> r;
	Map[
		Function[{key},
			Module[{keyValue, newValue},
				keyValue = Lookup[methodPacket, key];
				newValue = Which[
					(* If the value is Null, no need to convert *)
					MatchQ[keyValue, Null],
						keyValue,
					MatchQ[key, AspirateTravelRate],
						keyValue/.aspirateTravelRateReplacement,
					MatchQ[key, DispenseFlowRate],
						keyValue/.dispenseFlowRateReplacement,
					(* If it is BlahPositionOffset option, write in Coordinate format. Round to 0.01 mm *)
					MemberQ[{AspirationPositionOffset, CrosswiseAspirationPositionOffset, FinalAspirationPositionOffset, DispensePositionOffset}, key],
						Coordinate[{
							SafeRound[xOffsetConversion*Lookup[keyValue, XOffset], 0.01 Millimeter],
							SafeRound[yOffsetConversion*Lookup[keyValue, YOffset], 0.01 Millimeter],
							SafeRound[zOffsetConversion*Lookup[keyValue, ZOffset], 0.01 Millimeter]
						}],
					True,
						keyValue
				];
				key -> newValue
			]
		],
		Keys@methodPacket
	]
];

(* ::Subsection:: *)
(*resolveExperimentWashPlateOptions*)

DefineOptions[
	resolveExperimentWashPlateOptions,
	Options :> {
		HelperOutputOption,
		CacheOption,
		SimulationOption
	}
];

resolveExperimentWashPlateOptions[
	myInputs: {ObjectP[{Object[Container], Object[Sample]}]..},
	myContainers: {ObjectP[Object[Container]]..},
	myOptions: {_Rule..},
	myResolutionOptions: OptionsPattern[resolveExperimentWashPlateOptions]
] := Module[
	{
		(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
		outputSpecification, output, gatherTests, messages, cache, simulation, samplePrepOptions, washPlateOptions,
		objectContainerFields, modelContainerFields, objectSampleFields, modelSampleFields, methodFields, modelInstrumentFields,
		allInstrumentModels, allMethodObjects, objectContainerPackets, modelContainerPackets, objectSamplePacketList,
		modelSamplePacketList, specifiedInstrumentObjectPackets, allInstrumentModelPackets, allMethodObjectPackets,
		cacheBall, fastAssoc, inputToSampleLookup, allSamples, samplePackets, sampleContainerPackets, resolvedPreparation,
		resolvedWorkCell,
		(*--- OPTION PRECISION CHECKS ---*)
		optionPrecisions, roundedWashPlateOptions, precisionTests,
		(*-- INPUT VALIDATION CHECKS --*)
		discardedSamplePackets, discardedInvalidInputs, discardedTests, deprecatedSampleInputs, deprecatedTest,
		incompatibleSampleContainerCases, incompatibleSampleContainerTests, inputContainerContents, stowawaySamples,
		invalidPlateSampleContainers, invalidPlateSampleInputs, invalidPlateSampleTest, duplicateCases, duplicatedInputs,
		duplicateTest,
		(*-- RESOLVE OPTION --*)
		resolvedInstrument, suppliedMethod, resolvedBuffer, resolvedNumberOfWashes, resolvedWashVolume, resolvedPriming,
		suppliedPrimeVolume, suppliedAspirateTravelRate, suppliedAspirateDelay, suppliedAspirationPositionOffset,
		suppliedCrosswiseAspiration, suppliedCrosswiseAspirationPositionOffset, suppliedFinalAspiration, suppliedFinalAspirateTravelRate,
		suppliedFinalAspirateDelay, suppliedFinalAspirationPositionOffset, suppliedDispenseFlowRate, suppliedDispensePositionOffset,
		suppliedDispenseVacuumDelay, suppliedBottomWash, instrumentModelPacket, convertedAspirateTravelRate,
		convertedAspirationPositionOffset, convertedCrosswiseAspirationPositionOffset, convertedFinalAspirateTravelRate,
		convertedFinalAspirationPositionOffset, convertedDispenseFlowRate, convertedDispensePositionOffset, resolvedMethod,
		methodPacket, convertedMethodPacket, resolvedPrimeVolume, resolvedAspirateTravelRate, resolvedAspirateDelay,
		resolvedAspirationPositionOffset, resolvedCrosswiseAspiration, resolvedCrosswiseAspirationPositionOffset,
		resolvedFinalAspirationPositionOffset, resolvedFinalAspirateTravelRate, resolvedFinalAspiration, resolvedFinalAspirateDelay,
		resolvedAspirationOptions, resolvedDispenseFlowRate, resolvedDispensePositionOffset, resolvedDispenseVacuumDelay,
		resolvedBottomWash, resolvedDispenseOptions,
		(*-- OPTION VALIDATION CHECKS --*)
		invalidInstrumentCases, invalidInstrumentTest, conflictingPrimeCases, conflictingPrimeTest, conflictingCrosswiseAspirationCases,
		conflictingCrosswiseAspirationTest, conflictingFinalAspirationCases, conflictingFinalAspirationTest, conflictingMethodAspirationCases,
		conflictingMethodAspirationTest, conflictingMethodDispenseCases, conflictingMethodDispenseTest, compatibleMaterialsBool,
		compatibleMaterialsTests,
		(*-- UNRESOLVED CHECKS --*)
		resolvedPostProcessingOptions, userSpecifiedLabels, resolvedSampleLabels, resolvedSampleContainerLabels, methodFileName,
		(* -- RETURN -- *)
		resolvedOptions, invalidInputs, invalidOptions, allTests
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Lookup our simulation. *)
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* ExperimentWashPlate does not have sample prep options so we are skipping resolveSamplePrepOptionsNew. *)
	(* Separate out our <Type> options from our Sample Prep options. *)
	{samplePrepOptions, washPlateOptions} = splitPrepOptions[myOptions];


	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectContainerFields = DeleteDuplicates[Flatten[{SamplePreparationCacheFields[Object[Container]], Notebook}]];
	modelContainerFields = DeleteDuplicates[Flatten[{Dimensions, SamplePreparationCacheFields[Model[Container]]}]];
	objectSampleFields = SamplePreparationCacheFields[Object[Sample]];
	modelSampleFields = SamplePreparationCacheFields[Model[Sample]];
	methodFields = {Name, Instrument, MethodFile, AspirateDelay, AspirateTravelRate, AspirationPositionOffset, CrosswiseAspiration, CrosswiseAspirationPositionOffset, FinalAspiration, FinalAspirateTravelRate, FinalAspirateDelay, FinalAspirationPositionOffset, DispenseFlowRate, DispensePositionOffset, DispenseVacuumDelay, BottomWash};
	modelInstrumentFields = {WettedMaterials, XOffsetConversion, YOffsetConversion, ZOffsetConversion, MaxDispenseVolume, MinAspirateTravelRate, MaxAspirateTravelRate, MinDispenseFlowRate, MaxDispenseFlowRate, MinDispenseVacuumDelay, MaxDispenseVacuumDelay};
	allInstrumentModels = Join[Cases[ToList[myOptions], ObjectP[Model[Instrument, PlateWasher]], Infinity], {Model[Instrument, PlateWasher, "id:dORYzZm51LLA"]}];
	allMethodObjects = Join[Cases[ToList[myOptions], ObjectP[Object[Method, WashPlate]], Infinity], allWashPlateMethodSearch["Memoization"]];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	{
		(*1*)objectContainerPackets,
		(*2*)modelContainerPackets,
		(*3*)objectSamplePacketList,
		(*4*)modelSamplePacketList,
		(*5*)specifiedInstrumentObjectPackets,
		(*6*)allInstrumentModelPackets,
		(*7*)allMethodObjectPackets
	} = Quiet[
		Download[
			{
				(*1*)myContainers,
				(*2*)myContainers,
				(*3*)myContainers,
				(*4*)myContainers,
				(*5*)Cases[ToList[myOptions], ObjectP[Object[Instrument, PlateWasher]], Infinity],
				(*6*)allInstrumentModels,
				(*7*)allMethodObjects
			},
			{
				(*1*)List@Evaluate[Packet@@objectContainerFields],
				(*2*)List@Packet[Model[modelContainerFields]],
				(*3*)List@Packet[Contents[[All, 2]][objectSampleFields]],
				(*4*)List@Packet[Contents[[All, 2]][Model][modelSampleFields]],
				(*5*){Packet[Name, Status, Model], Packet[Model[modelInstrumentFields]]},
				(*6*)List@Evaluate[Packet@@modelInstrumentFields],
				(*7*)List@Evaluate[Packet@@methodFields]
			},
			Cache -> cache,
			Simulation -> simulation
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	{
		(*1*)objectContainerPackets,
		(*2*)modelContainerPackets,
		(*3*)objectSamplePacketList,
		(*4*)modelSamplePacketList,
		(*5*)specifiedInstrumentObjectPackets,
		(*6*)allInstrumentModelPackets,
		(*7*)allMethodObjectPackets
	} = Flatten/@{
		(*1*)objectContainerPackets,
		(*2*)modelContainerPackets,
		(*3*)objectSamplePacketList,
		(*4*)modelSamplePacketList,
		(*5*)specifiedInstrumentObjectPackets,
		(*6*)allInstrumentModelPackets,
		(*7*)allMethodObjectPackets
	};

	cacheBall = FlattenCachePackets[{cache, objectContainerPackets, modelContainerPackets, objectSamplePacketList, modelSamplePacketList, specifiedInstrumentObjectPackets, allInstrumentModelPackets, allMethodObjectPackets}];

	(* Make the fast association. *)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Since WashPlate take either Container or Sample as myInputs, check which version is specified here *)
	(* This is needed for InvalidInput checks *)
	inputToSampleLookup = MapThread[
		Function[{myInput, myContainer, index},
			<|
				Index -> index,
				Samples -> If[MatchQ[myInput, ObjectP[Object[Container]]],
					Download[fastAssocLookup[fastAssoc, myInput, Contents][[All, 2]], Object],
					ToList@myInput
				],
				Container -> myContainer
			|>
		],
		{myInputs, myContainers, Range[Length@myInputs]}
	];
	allSamples = Flatten[Lookup[inputToSampleLookup, Samples]];
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ DeleteDuplicates[allSamples];
	sampleContainerPackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ DeleteDuplicates[myContainers];

	(* Resolve our preparation option. *)

	(* Currently we can only perform robotic WashPlate on SuperSTAR LH. We might add the plate washer to other workcells in the future *)
	resolvedPreparation = FirstOrDefault@resolveWashPlateMethod[myContainers];
	resolvedWorkCell = FirstOrDefault@resolveWashPlateWorkCell[myContainers];

	(*--- OPTION PRECISION CHECKS ---*)
	(* Round the options that have precision. *)
	optionPrecisions = {
		{WashVolume, 10^0 Microliter},
		{AspirateDelay, 10^0 Millisecond},
		{FinalAspirateDelay, 10^0 Millisecond},
		{DispenseVacuumDelay, 10^0 Microliter}
	};

	(* Convert list of rules to Association, then round options *)
	{roundedWashPlateOptions, precisionTests} = If[gatherTests,
		RoundOptionPrecision[Association[washPlateOptions], optionPrecisions[[All, 1]], optionPrecisions[[All, 2]], Output -> {Result, Tests}],
		{RoundOptionPrecision[Association[washPlateOptions], optionPrecisions[[All, 1]], optionPrecisions[[All, 2]]], {}}
	];

	(*-- INPUT VALIDATION CHECKS --*)
	(* 1 - Discarded Sample Test *)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
		{},
		Lookup[discardedSamplePackets, Object]
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs] > 0 && messages,
		Module[{reasonClause, actionClause},
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[discardedInvalidInputs, Lookup[samplePackets, Object], Cache -> cacheBall, Simulation -> simulation],
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
	discardedTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedInvalidInputs] == 0,
				Nothing,
				Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall, Simulation -> simulation] <> " are not discarded:", True, False]
			];

			passingTest = If[Length[discardedInvalidInputs] == Length[samplePackets],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[allSamples, discardedInvalidInputs], Cache -> cacheBall, Simulation -> simulation] <> " are not discarded:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 2 - Get whether the samples have deprecated models. *)
	deprecatedSampleInputs = Map[
		Function[{samplePacket},
			Module[{modelPacket},
				modelPacket = fastAssocPacketLookup[fastAssoc, Lookup[samplePacket, Object], Model];
				(* If the sample has a model and the model has Deprecated True, mark it here *)
				If[MatchQ[modelPacket, _Association] && MatchQ[Lookup[modelPacket, Deprecated, Null], True],
					Lookup[samplePacket, Object],
					Nothing
				]
			]
		],
		samplePackets
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedSampleInputs] > 0 && messages,
		Module[{reasonClause, actionClause},
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[deprecatedSampleInputs, allSamples, Cache -> cacheBall, Simulation -> simulation],
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
				If[Length[deprecatedSampleInputs] > 1,
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

			passingTest = If[Length[deprecatedSampleInputs] == Length[samplePackets],
				Nothing,
				Test["Our input samples " <> ObjectToString[Complement[allSamples, deprecatedSampleInputs], Cache -> cacheBall, Simulation -> simulation] <> " have models that are not Deprecated:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 3 - ContainersIn must be in microplate Test *)
	incompatibleSampleContainerCases = MapThread[
		Function[{uniqueContainer, uniqueContainerPacket},
			Module[{containerModelPacket, compatibleCheck},
				containerModelPacket = If[MatchQ[Lookup[uniqueContainerPacket, Model], ObjectP[Model[Container]]],
					fetchPacketFromFastAssoc[Lookup[uniqueContainerPacket, Model], fastAssoc],
					<||>
				];
				compatibleCheck = whyCantThisBeWashedByPlateWasher[containerModelPacket];
				If[MatchQ[compatibleCheck, <||>],
					Nothing,
					{uniqueContainer, compatibleCheck}
				]
			]
		],
		{DeleteDuplicates[myContainers], sampleContainerPackets}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs. *)
	If[Length[incompatibleSampleContainerCases] > 0 && messages,
		Module[{captureSentence, reasonClause},
			captureSentence = StringJoin[
				"To be washed by robotic plate washer, the input container must have ",
				joinClauses[
					{
						If[MemberQ[Flatten[Keys@incompatibleSampleContainerCases[[All, 2]]], Model|Footprint],
							"a Plate model",
							Nothing
						],
						If[MemberQ[Flatten[Keys@incompatibleSampleContainerCases[[All, 2]]], NumberOfWells],
							"96 wells",
							Nothing
						],
						If[MemberQ[Flatten[Keys@incompatibleSampleContainerCases[[All, 2]]], WellBottom],
							"flat well bottom",
							Nothing
						],
						If[MemberQ[Flatten[Keys@incompatibleSampleContainerCases[[All, 2]]], Dimensions],
							"height in between 13 mm and 16 mm",
							Nothing
						],
						If[MemberQ[Flatten[Keys@incompatibleSampleContainerCases[[All, 2]]], LiquidHandlerPrefix],
							"liquid handler compatibility",
							Nothing
						],
						If[MemberQ[Flatten[Keys@incompatibleSampleContainerCases[[All, 2]]], MaxVolume],
							"MaxVolume greater or equal to 300 ul",
							Nothing
						]
					}
				]
			];
			(* Here we try to not have a super long message by not displaying either sample or container IDs *)
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[incompatibleSampleContainerCases[[All, 1]], myContainers, Cache -> cacheBall, Simulation -> simulation],(* Collapse the containers *)
				" ",
				isOrAre[incompatibleSampleContainerCases[[All, 1]]],
				" not compatible with robotic plate washer"
			];
			Message[
				Error::InvalidWashPlateContainers,
				captureSentence,
				reasonClause
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleSampleContainerTests = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[incompatibleSampleContainerCases] == 0,
				Nothing,
				Test["Our input sample containers " <> ObjectToString[incompatibleSampleContainerCases[[All, 1]], Cache -> cacheBall, Simulation -> simulation] <> " are PlateWasher compatible:", True, False]
			];
			passingTest = If[Length[incompatibleSampleContainerCases[[All, 1]]] == Length[DeleteDuplicates[myContainers]],
				Nothing,
				Test["Our input sample containers " <> ObjectToString[Complement[myContainers, incompatibleSampleContainerCases[[All, 1]]], Cache -> cacheBall, Simulation -> simulation] <> " are PlateWasher compatible:", True, True]
			];
			{failingTest, passingTest}
		],
		{}
	];

	(* 4 - UnusedWashPlateSamples *)
	(* Get whether there are stowaway samples inside the input plates. *)
	inputContainerContents = Lookup[sampleContainerPackets, Contents, {}];
	stowawaySamples = Map[
		Function[{contents},
			Module[{contentsObjects},
				contentsObjects = Download[contents[[All, 2]], Object];
				Select[contentsObjects, Not[MemberQ[allSamples, ObjectP[#]]]&]
			]
		],
		inputContainerContents
	];
	invalidPlateSampleContainers = If[!MatchQ[stowawaySamples, {}],
		PickList[DeleteDuplicates[myContainers], stowawaySamples, Except[{}]],
		{}
	];
	invalidPlateSampleInputs = If[!MatchQ[invalidPlateSampleContainers, {}],
		Flatten@Lookup[Cases[inputToSampleLookup, KeyValuePattern[Container -> ObjectP[invalidPlateSampleContainers]]], Samples],
		{}
	];

	(* Following new format of error message and detects singular/plural and flatten all values *)
	If[Length[invalidPlateSampleContainers] > 0 && messages,
		Module[{reasonClause},
			(* Here we try to not have a super long message by not displaying either sample or container IDs *)
			reasonClause = StringJoin[
				Capitalize@samplesForMessages[invalidPlateSampleInputs, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],(* Do not collapse the samples *)
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
					Length[invalidPlateSampleContainers] == 1 && Length[Flatten@stowawaySamples] == 1,
						StringJoin[
							" with 1 additional sample ",
							ObjectToString[Flatten[stowawaySamples][[1]], Cache -> cacheBall, Simulation -> simulation],
							", which is not specified as input sample"
						],
					Length[invalidPlateSampleContainers] == 1,
						StringJoin[
							" with ",
							ToString[Length[Flatten@stowawaySamples]],
							" additional samples, which are not specified as input samples"
						],
					Length[invalidPlateSampleContainers] > $MaxNumberOfErrorDetails,
						" with additional samples, which are not specified as input samples",
					True,
						StringJoin[
							" with each container holding ",
							joinClauses[Map[Length[#]&, stowawaySamples], DuplicatesRemoval -> False],
							" additional samples, respectively"
						]
				]
			];
			Message[
				Warning::UnusedWashPlateSamples,
				reasonClause,
				If[Length[Flatten@stowawaySamples] == 1,
					"the additional sample from the input " <> pluralize[invalidPlateSampleContainers, "container", "containers"] <> " to a different container before running WashPlate if it should not be affected",
					"all of the additional samples from the input " <> pluralize[invalidPlateSampleContainers, "container", "containers"] <> " to different containers before running WashPlate if they should not be affected"
				]
			]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidPlateSampleTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[invalidPlateSampleInputs] == 0,
				Nothing,
				Warning["The input samples " <> ObjectToString[invalidPlateSampleInputs, Cache -> cacheBall, Simulation -> simulation] <> " are in containers that do not have other, not-provided samples in them:", True, False]
			];

			passingTest = If[Length[invalidPlateSampleInputs] == Length[allSamples],
				Nothing,
				Warning["The input samples " <> ObjectToString[Complement[allSamples, invalidPlateSampleInputs], Cache -> cacheBall, Simulation -> simulation] <> " are in containers that do not have other, not-provided samples in them:", True, True]
			];

			{failingTest, passingTest}
		],
		Nothing
	];

	(* 5 - DuplicatedWashPlateSamples *)
	(* Check whether and why we have duplicates *)
	duplicateCases = Module[{talliedEmptyContainer, talliedSample},
		talliedSample = Tally@Flatten[Lookup[inputToSampleLookup, Samples]];
		talliedEmptyContainer = Tally@Lookup[Cases[inputToSampleLookup, KeyValuePattern[Samples -> {}]], Container, {}];
		Flatten[{
			If[MemberQ[talliedSample[[All, 2]], GreaterP[1]],
				{Sample, Cases[talliedSample, {_, GreaterP[1]}][[All, 1]]},
				{}
			],
			If[MemberQ[talliedEmptyContainer[[All, 2]], GreaterP[1]],
				{Container, Cases[talliedEmptyContainer, {_, GreaterP[1]}][[All, 1]]},
				{}
			]
		}, 1]
	];

	duplicatedInputs = Cases[Flatten@duplicateCases, ObjectP[]];

	If[Length[duplicateCases] > 0 && messages,
		Message[
			Error::DuplicatedWashPlateSamples,
			StringJoin[
				samplesForMessages[duplicatedInputs, CollapseForDisplay -> False, Cache -> cacheBall, Simulation -> simulation],
				" ",
				pluralize[DeleteDuplicates@duplicatedInputs, "contains", "contain"]
			]
		]
	];

	duplicateTest = If[gatherTests,
		Test["The inputs " <> ObjectToString[duplicatedInputs, Cache -> cacheBall, Simulation -> simulation] <> " have not been specified more than once:", True, MatchQ[duplicateCases, {}]],
		{}
	];


	(*-- RESOLVE OPTIONS --*)

	(* Lookup the supplied options. Some of options have default values. *)
	{
		resolvedInstrument,
		suppliedMethod,
		resolvedBuffer,
		resolvedNumberOfWashes,
		resolvedWashVolume,
		resolvedPriming,
		suppliedPrimeVolume,
		suppliedAspirateTravelRate,
		suppliedAspirateDelay,
		suppliedAspirationPositionOffset,
		suppliedCrosswiseAspiration,
		suppliedCrosswiseAspirationPositionOffset,
		suppliedFinalAspiration,
		suppliedFinalAspirateTravelRate,
		suppliedFinalAspirateDelay,
		suppliedFinalAspirationPositionOffset,
		suppliedDispenseFlowRate,
		suppliedDispensePositionOffset,
		suppliedDispenseVacuumDelay,
		suppliedBottomWash
	} = Lookup[
		roundedWashPlateOptions,
		{
			Instrument,
			Method,
			Buffer,
			NumberOfWashes,
			WashVolume,
			Priming,
			PrimeVolume,
			AspirateTravelRate,
			AspirateDelay,
			AspirationPositionOffset,
			CrosswiseAspiration,
			CrosswiseAspirationPositionOffset,
			FinalAspiration,
			FinalAspirateTravelRate,
			FinalAspirateDelay,
			FinalAspirationPositionOffset,
			DispenseFlowRate,
			DispensePositionOffset,
			DispenseVacuumDelay,
			BottomWash
		}
	];

	instrumentModelPacket = If[MatchQ[resolvedInstrument, ObjectP[Object[Instrument]]],
		fastAssocPacketLookup[fastAssoc, resolvedInstrument, Model],
		fetchPacketFromFastAssoc[resolvedInstrument, fastAssoc]
	];

	(* Convert Scientific units to relative units before screening for method files *)
	{
		convertedAspirateTravelRate,
		convertedAspirationPositionOffset,
		convertedCrosswiseAspirationPositionOffset,
		convertedFinalAspirateTravelRate,
		convertedFinalAspirationPositionOffset,
		convertedDispenseFlowRate,
		convertedDispensePositionOffset
	} = Lookup[
		convertToBioTekUnits[
			instrumentModelPacket,
			{
				AspirateTravelRate -> suppliedAspirateTravelRate,
				AspirationPositionOffset -> suppliedAspirationPositionOffset,
				CrosswiseAspirationPositionOffset -> suppliedCrosswiseAspirationPositionOffset,
				FinalAspirateTravelRate -> suppliedFinalAspirateTravelRate,
				FinalAspirationPositionOffset -> suppliedFinalAspirationPositionOffset,
				DispenseFlowRate -> suppliedDispenseFlowRate,
				DispensePositionOffset -> suppliedDispensePositionOffset
			}
		],
		{
			AspirateTravelRate,
			AspirationPositionOffset,
			CrosswiseAspirationPositionOffset,
			FinalAspirateTravelRate,
			FinalAspirationPositionOffset,
			DispenseFlowRate,
			DispensePositionOffset
		}
	];

	(* Resolve Method *)
	resolvedMethod = Which[
		(* If user has specified the method, use it *)
		MatchQ[suppliedMethod, Except[Automatic]],
			suppliedMethod,
		(* If none of the aspiration/dispense options are specified, use default method *)
		MatchQ[{suppliedAspirateTravelRate, suppliedAspirateDelay, suppliedAspirationPositionOffset, suppliedCrosswiseAspiration, suppliedCrosswiseAspirationPositionOffset, suppliedFinalAspiration, suppliedFinalAspirateTravelRate, suppliedFinalAspirateDelay, suppliedFinalAspirationPositionOffset, suppliedDispenseFlowRate, suppliedDispensePositionOffset, suppliedDispenseVacuumDelay, suppliedBottomWash}, {Automatic..}],
			Object[Method, WashPlate, "id:7X104vPL8edk"],(*Object[Method, WashPlate, "BioTek 405LS Default"]*)
		(* Otherwise, screen if any existing method has the desired settings *)
		True,
			Module[{filteredMethodPackets},
				(* Filter all packets with default/specified options *)
				filteredMethodPackets = matchWashPlateMethod[
					allMethodObjectPackets,
					{
						Instrument -> Lookup[instrumentModelPacket, Object],
						AspirateTravelRate -> convertedAspirateTravelRate,
						AspirateDelay -> suppliedAspirateDelay,
						AspirationPositionOffset -> convertedAspirationPositionOffset,
						CrosswiseAspiration -> suppliedCrosswiseAspiration,
						CrosswiseAspirationPositionOffset -> convertedCrosswiseAspirationPositionOffset,
						FinalAspiration -> suppliedFinalAspiration,
						FinalAspirateTravelRate -> convertedFinalAspirateTravelRate,
						FinalAspirationPositionOffset -> convertedFinalAspirationPositionOffset,
						FinalAspirateDelay -> suppliedFinalAspirateDelay,
						DispenseFlowRate -> convertedDispenseFlowRate,
						DispensePositionOffset -> convertedFinalAspirationPositionOffset,
						DispenseVacuumDelay -> suppliedDispenseVacuumDelay,
						BottomWash -> suppliedBottomWash
					}
				];
				If[MatchQ[filteredMethodPackets, {}],
					Custom,
					Download[First[filteredMethodPackets], Object]
				]
			]
	];

	methodPacket = If[MatchQ[resolvedMethod, ObjectP[Object[Method, WashPlate]]],
		FirstCase[allMethodObjectPackets, PacketP[resolvedMethod]],
		<||>
	];

	(* Convert fields from the MethodPacket to scientific units *)
	convertedMethodPacket = convertFromBioTekUnits[
		instrumentModelPacket,
		methodPacket
	];

	(* Resolve Prime option *)
	resolvedPrimeVolume = Which[
		MatchQ[suppliedPrimeVolume, Except[Automatic]], suppliedPrimeVolume,
		TrueQ[resolvedPriming], 300 Milliliter,
		True, Null
	];

	(* Resolve Aspiration options *)
	resolvedAspirateTravelRate = Which[
		MatchQ[suppliedAspirateTravelRate, Except[Automatic]], suppliedAspirateTravelRate,
		MatchQ[resolvedMethod, Custom], 3,
		True, Lookup[convertedMethodPacket, AspirateTravelRate]
	];

	resolvedAspirateDelay = Which[
		MatchQ[suppliedAspirateDelay, Except[Automatic]], suppliedAspirateDelay,
		MatchQ[resolvedMethod, Custom], Null,
		True, Lookup[convertedMethodPacket, AspirateDelay, Null]
	];

	resolvedAspirationPositionOffset = Which[
		MatchQ[suppliedAspirationPositionOffset, Except[Automatic]], suppliedAspirationPositionOffset,
		MatchQ[resolvedMethod, Custom], Coordinate[{-0.91 Millimeter, 0 Millimeter, 3.68 Millimeter}],
		True, Lookup[convertedMethodPacket, AspirationPositionOffset]
	];

	resolvedCrosswiseAspiration = Which[
		MatchQ[suppliedCrosswiseAspiration, Except[Automatic]], suppliedCrosswiseAspiration,
		MatchQ[resolvedMethod, Custom], False,
		True, Lookup[convertedMethodPacket, CrosswiseAspiration]
	];

	resolvedCrosswiseAspirationPositionOffset = Which[
		MatchQ[suppliedCrosswiseAspirationPositionOffset, Except[Automatic]], suppliedCrosswiseAspirationPositionOffset,
		MatchQ[resolvedMethod, ObjectP[]], Lookup[convertedMethodPacket, CrosswiseAspirationPositionOffset, Null],
		MatchQ[resolvedCrosswiseAspiration, False], Null,
		True, resolvedAspirationPositionOffset
	];

	resolvedFinalAspiration = Which[
		MatchQ[suppliedFinalAspiration, Except[Automatic]], suppliedFinalAspiration,
		MatchQ[resolvedMethod, Custom], True,
		True, Lookup[convertedMethodPacket, FinalAspiration]
	];

	resolvedFinalAspirateTravelRate = Which[
		MatchQ[suppliedFinalAspirateTravelRate, Except[Automatic]], suppliedFinalAspirateTravelRate,
		MatchQ[resolvedMethod, ObjectP[]], Lookup[convertedMethodPacket, FinalAspirateTravelRate, Null],
		MatchQ[resolvedFinalAspiration, False], Null,
		True, resolvedAspirateTravelRate
	];

	resolvedFinalAspirateDelay = Which[
		MatchQ[suppliedFinalAspirateDelay, Except[Automatic]], suppliedFinalAspirateDelay,
		MatchQ[resolvedMethod, ObjectP[]], Lookup[convertedMethodPacket, FinalAspirateDelay, Null],
		True, Null
	];

	resolvedFinalAspirationPositionOffset = Which[
		MatchQ[suppliedFinalAspirationPositionOffset, Except[Automatic]], suppliedFinalAspirationPositionOffset,
		MatchQ[resolvedMethod, ObjectP[]], Lookup[convertedMethodPacket, FinalAspirationPositionOffset, Null],
		MatchQ[resolvedFinalAspiration, False], Null,
		True, resolvedAspirationPositionOffset
	];

	resolvedAspirationOptions = {
		AspirateTravelRate -> resolvedAspirateTravelRate,
		AspirateDelay -> resolvedAspirateDelay,
		AspirationPositionOffset -> resolvedAspirationPositionOffset,
		CrosswiseAspiration -> resolvedCrosswiseAspiration,
		CrosswiseAspirationPositionOffset -> resolvedCrosswiseAspirationPositionOffset,
		FinalAspiration -> resolvedFinalAspiration,
		FinalAspirateTravelRate -> resolvedFinalAspirateTravelRate,
		FinalAspirateDelay -> resolvedFinalAspirateDelay,
		FinalAspirationPositionOffset -> resolvedFinalAspirationPositionOffset
	};

	(* Resolve Dispense options *)
	resolvedDispenseFlowRate = Which[
		MatchQ[suppliedDispenseFlowRate, Except[Automatic]], suppliedDispenseFlowRate,
		MatchQ[resolvedMethod, Custom], 8,
		True, Lookup[convertedMethodPacket, DispenseFlowRate]
	];

	resolvedDispensePositionOffset = Which[
		MatchQ[suppliedDispensePositionOffset, Except[Automatic]], suppliedDispensePositionOffset,
		MatchQ[resolvedMethod, Custom], Coordinate[{0 Millimeter, 0 Millimeter, 15.24 Millimeter}],
		True, Lookup[convertedMethodPacket, DispensePositionOffset]
	];

	resolvedDispenseVacuumDelay = Which[
		MatchQ[suppliedDispenseVacuumDelay, Except[Automatic]], suppliedDispenseVacuumDelay,
		MatchQ[resolvedMethod, ObjectP[]], Lookup[convertedMethodPacket, DispenseVacuumDelay, Null],
		True, Null
	];

	resolvedBottomWash = Which[
		MatchQ[suppliedBottomWash, Except[Automatic]], suppliedBottomWash,
		MatchQ[resolvedMethod, Custom], False,
		True, Lookup[convertedMethodPacket, BottomWash]
	];

	resolvedDispenseOptions = {
		DispenseFlowRate -> resolvedDispenseFlowRate,
		DispensePositionOffset -> resolvedDispensePositionOffset,
		DispenseVacuumDelay -> resolvedDispenseVacuumDelay,
		BottomWash -> resolvedBottomWash
	};

	(*-- INPUT OPTIONS CHECKS --*)

	(* 1 - InvalidPlateWasher *)
	(* Check why the instrument is invalid, and give a valid instrument *)
	invalidInstrumentCases = Which[
		!MatchQ[Lookup[instrumentModelPacket, Object], ObjectP[Model[Instrument, PlateWasher, "id:dORYzZm51LLA"]]],
			{Model, Model[Instrument, PlateWasher, "id:dORYzZm51LLA"]},
		MatchQ[resolvedMethod, ObjectP[Object[Method, WashPlate]]] && !MatchQ[Lookup[methodPacket, Instrument], ObjectP[Lookup[instrumentModelPacket, Object]]],
			{Method, Download[Lookup[methodPacket, Instrument], Object]},
		True,
			{}
	];

	If[Length[invalidInstrumentCases] > 0 && messages,
		Module[{reasonClause},
			reasonClause = If[MemberQ[invalidInstrumentCases, Model],
				"Only Model[Instrument, PlateWasher, \"BioTek 405LS Microplate Washer\"] is supported with robotic WashPlate unit operation",
				"The instrument option must match the field Instrument specified in the Method file"
			];
			Message[
				Error::InvalidPlateWasher,
				ObjectToString[resolvedInstrument, Cache -> cacheBall, Simulation -> simulation],
				reasonClause,
				ObjectToString[invalidInstrumentCases[[2]], Cache -> cacheBall, Simulation -> simulation]
			]
		]
	];

	invalidInstrumentTest = If[gatherTests,
		Test["The instrument " <> ObjectToString[resolvedInstrument, Cache -> cacheBall, Simulation -> simulation] <> " is valid:", True, MatchQ[invalidInstrumentCases, {}]],
		{}
	];

	(* 2 - ConflictingPrimingOptions *)
	conflictingPrimeCases = Which[
		TrueQ[resolvedPriming] && NullQ[resolvedPrimeVolume], {Priming, Default},
		!TrueQ[resolvedPriming] && !NullQ[resolvedPrimeVolume], {PrimeVolume, Specified},
		True, {}
	];

	If[Length[conflictingPrimeCases] > 0 && messages,
		Module[{reasonClause},
			reasonClause = If[MemberQ[conflictingPrimeCases, Default],
				"The option Priming is default to True while the option PrimeVolume is not set",
				"The option Priming is specified to False while the option PrimeVolume is not Null"
			];
			Message[
				Error::ConflictingPrimingOptions,
				reasonClause
			]
		]
	];

	conflictingPrimeTest = If[gatherTests,
		Test["The Option PrimeVolume is only applicable when Prime is set to True:", True, MatchQ[conflictingPrimeCases, {}]],
		{}
	];

	(* 3 - ConflictingCrosswiseAspirationOptions *)
	conflictingCrosswiseAspirationCases = Which[
		TrueQ[resolvedCrosswiseAspiration] && NullQ[resolvedCrosswiseAspirationPositionOffset], {CrosswiseAspiration, True},
		!TrueQ[resolvedCrosswiseAspiration] && !NullQ[resolvedCrosswiseAspirationPositionOffset], {CrosswiseAspiration, False},
		True, {}
	];

	If[Length[conflictingCrosswiseAspirationCases] > 0 && messages,
		Module[{reasonClause},
			reasonClause = If[MemberQ[conflictingCrosswiseAspirationCases, True],
				"The option CrosswiseAspiration is set to True while the option CrosswiseAspirationPositionOffset is not set",
				"The option CrosswiseAspiration is set to False while the option CrosswiseAspirationPositionOffset is not Null"
			];
			Message[
				Error::ConflictingCrosswiseAspirationOptions,
				reasonClause
			]
		]
	];

	conflictingCrosswiseAspirationTest = If[gatherTests,
		Test["The Option CrosswiseAspirationPositionOffset is only applicable when CrosswiseAspiration is set to True:", True, MatchQ[conflictingCrosswiseAspirationCases, {}]],
		{}
	];

	(* 4 - ConflictingFinalAspirationOptions *)
	conflictingFinalAspirationCases = Which[
		TrueQ[resolvedFinalAspiration] && MemberQ[{resolvedFinalAspirationPositionOffset, resolvedFinalAspirateTravelRate}, Null],
			Append[PickList[{FinalAspirationPositionOffset, FinalAspirateTravelRate}, {resolvedFinalAspirationPositionOffset, resolvedFinalAspirateTravelRate}, Null], True],
		!TrueQ[resolvedFinalAspiration] && MemberQ[{resolvedFinalAspirateDelay, resolvedFinalAspirationPositionOffset, resolvedFinalAspirateTravelRate}, Except[Null]],
			Append[PickList[{FinalAspirateDelay, FinalAspirationPositionOffset, FinalAspirateTravelRate}, {resolvedFinalAspirateDelay, resolvedFinalAspirationPositionOffset, resolvedFinalAspirateTravelRate}, Except[Null]], False],
		True,
			{}
	];

	If[Length[conflictingFinalAspirationCases] > 0 && messages,
		Module[{reasonClause},
			reasonClause = StringJoin[
				"The option FinalAspiration is set to ",
				ToString[Last@conflictingFinalAspirationCases],
				" while ",
				pluralize[Most@conflictingFinalAspirationCases, "the option ", "the options "],
				joinClauses[Most@conflictingFinalAspirationCases],
				" ",
				isOrAre[Most@conflictingFinalAspirationCases],
				If[MatchQ[Last@conflictingFinalAspirationCases, True],
					" not specified",
					" specified"
				]
			];
			Message[
				Error::ConflictingFinalAspirationOptions,
				reasonClause
			]
		]
	];

	conflictingFinalAspirationTest = If[gatherTests,
		Test["The Option FinalAspirateTravelRate, FinalAspirateDelay and FinalAspirationPositionOffset are only applicable when FinalAspiration is set to True:", True, MatchQ[conflictingFinalAspirationCases, {}]],
		{}
	];

	(* 5 - ConflictingWashPlateMethodWithAspirationOptions *)
	conflictingMethodAspirationCases = If[MatchQ[suppliedMethod, ObjectP[]],
		Map[
			If[MatchQ[Lookup[resolvedAspirationOptions, #], Lookup[convertedMethodPacket, #]],
				Nothing,
				#
			]&,
			{
				AspirateTravelRate, AspirateDelay, AspirationPositionOffset,
				CrosswiseAspiration, CrosswiseAspirationPositionOffset,
				FinalAspiration, FinalAspirateTravelRate, FinalAspirateDelay, FinalAspirationPositionOffset
			}
		],
		{}
	];

	If[Length[conflictingMethodAspirationCases] > 0 && messages,
		Module[{reasonClause},
			reasonClause = StringJoin[
				"The option Method is set to ",
				ObjectToString[resolvedMethod, Cache -> cacheBall, Simulation -> simulation],
				" while ",
				pluralize[conflictingMethodAspirationCases, "the option ", "the options "],
				joinClauses[conflictingMethodAspirationCases],
				" ",
				isOrAre[conflictingMethodAspirationCases],
				" specified differently compared to ",
				pluralize[conflictingMethodAspirationCases, "the setting ", " the settings "],
				"in the method"
			];
			Message[
				Error::ConflictingWashPlateMethodWithAspirationOptions,
				reasonClause
			]
		]
	];

	conflictingMethodAspirationTest = If[gatherTests,
		Test["The specified aspiration options should match the settings in specified Method:", True, MatchQ[conflictingMethodAspirationCases, {}]],
		{}
	];

	(* 6 - ConflictingWashPlateMethodWithDispenseOptions *)
	conflictingMethodDispenseCases = If[MatchQ[suppliedMethod, ObjectP[]],
		Map[
			If[MatchQ[Lookup[resolvedDispenseOptions, #], Lookup[convertedMethodPacket, #]],
				Nothing,
				#
			]&,
			{DispenseFlowRate, DispensePositionOffset, DispenseVacuumDelay, BottomWash}
		],
		{}
	];

	If[Length[conflictingMethodDispenseCases] > 0 && messages,
		Module[{reasonClause},
			reasonClause = StringJoin[
				"The option Method is set to ",
				ObjectToString[resolvedMethod, Cache -> cacheBall, Simulation -> simulation],
				" while ",
				pluralize[conflictingMethodDispenseCases, "the option ", "the options "],
				joinClauses[conflictingMethodDispenseCases],
				" ",
				isOrAre[conflictingMethodDispenseCases],
				" specified differently compared to ",
				pluralize[conflictingMethodDispenseCases, "the setting ", " the settings "],
				"in the method"
			];
			Message[
				Error::ConflictingWashPlateMethodWithDispenseOptions,
				reasonClause
			]
		]
	];

	conflictingMethodDispenseTest = If[gatherTests,
		Test["The specified dispense options should match the settings in specified Method:", True, MatchQ[conflictingMethodAspirationCases, {}]],
		{}
	];

	(* 7 - IncompatibleMaterials *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
		CompatibleMaterialsQ[resolvedInstrument, Append[allSamples, resolvedBuffer], Output -> {Result, Tests}, Simulation -> simulation, Cache -> cacheBall],
		{CompatibleMaterialsQ[resolvedInstrument, Append[allSamples, resolvedBuffer], Messages -> messages, Simulation -> simulation, Cache -> cacheBall], {}}
	];

	(*-- UNRESOLVED CHECKS --*)

	(* Resolve Post Processing Options. *)
	(* PostProcessing options are default to Null for robotic preparation *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[ReplaceRule[myOptions, Preparation -> resolvedPreparation]];

	(* Get all of the user specified labels. *)
	userSpecifiedLabels = DeleteDuplicates@Cases[
		Flatten@Lookup[
			myOptions,
			{SampleLabel, SampleContainerLabel}
		],
		_String
	];

	(* Resolve the SampleLabel option. *)
	{resolvedSampleLabels, resolvedSampleContainerLabels} = Transpose@MapThread[
		Function[{sampleOrContainer, container, options},
			Module[{sampleLabel, sampleContainerLabel},
				sampleLabel = Which[
					MatchQ[Lookup[options, SampleLabel], Except[Automatic]],
						Lookup[options, SampleLabel],
					And[
						MatchQ[sampleOrContainer, ObjectP[Object[Sample]]],
						MatchQ[simulation, SimulationP],
						MatchQ[LookupObjectLabel[simulation, sampleOrContainer], _String]
					],
						LookupObjectLabel[simulation, sampleOrContainer],
					MatchQ[sampleOrContainer, ObjectP[Object[Sample]]],
						CreateUniqueLabel["Washed Plate Sample", UserSpecifiedLabels -> userSpecifiedLabels],
					True,
						Null
				];

				(* Resolve the SampleContainerLabel option. *)
				sampleContainerLabel = Which[
					MatchQ[Lookup[options, SampleContainerLabel], Except[Automatic]],
						Lookup[options, SampleContainerLabel],
					MatchQ[simulation, SimulationP] && MatchQ[LookupObjectLabel[simulation, container], _String],
						LookupObjectLabel[simulation, container],
					True,
						CreateUniqueLabel["Washed Container Plate", UserSpecifiedLabels -> userSpecifiedLabels]
				];

				{sampleLabel, sampleContainerLabel}
			]
		],
		{myInputs, myContainers, OptionsHandling`Private`mapThreadOptions[ExperimentWashPlate, washPlateOptions]}
	];

	methodFileName = Which[
		MatchQ[Lookup[myOptions, MethodFileName], _String],
			Lookup[myOptions, MethodFileName],
		MatchQ[resolvedMethod, ObjectP[Object[Method, WashPlate]]],
			If[MatchQ[fastAssocLookup[fastAssoc, resolvedMethod, Name], _String],
				fastAssocLookup[fastAssoc, resolvedMethod, Name] <> CreateUUID[] <> ".LHC",
				"Existing WashPlate Method " <> CreateUUID[] <> ".LHC"
			],
		True,
			"Customized WashPlate Method " <> CreateUUID[] <> ".LHC"
	];

	(* Gather these options together in a list. *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Join[
			{
				Preparation -> resolvedPreparation,
				WorkCell -> resolvedWorkCell,
				Instrument -> resolvedInstrument,
				Method -> resolvedMethod,
				MethodFileName -> methodFileName,
				Buffer -> resolvedBuffer,
				NumberOfWashes -> resolvedNumberOfWashes,
				WashVolume -> resolvedWashVolume,
				Priming -> resolvedPriming,
				PrimeVolume -> resolvedPrimeVolume
			},
			{
				SampleLabel -> resolvedSampleLabels,
				SampleContainerLabel -> resolvedSampleContainerLabels,
				Name -> Lookup[myOptions, Name],
				SamplesInStorageCondition -> Lookup[myOptions, SamplesInStorageCondition]
			},
			resolvedAspirationOptions,
			resolvedDispenseOptions,
			resolvedPostProcessingOptions
		]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{
		discardedInvalidInputs,
		deprecatedSampleInputs,
		incompatibleSampleContainerCases,
		duplicatedInputs
	}]];

	invalidOptions = DeleteDuplicates[Flatten[{
		Which[
			MemberQ[invalidInstrumentCases, Model], {Instrument},
			MemberQ[invalidInstrumentCases, Method], {Method, Instrument},
			True, {}
		],
		If[!MatchQ[conflictingPrimeCases, {}],
			{Prime, PrimeVolume},
			{}
		],
		If[!MatchQ[conflictingCrosswiseAspirationCases, {}],
			{CrosswiseAspiration, CrosswiseAspirationPositionOffset},
			{}
		],
		If[!MatchQ[conflictingFinalAspirationCases, {}],
			conflictingFinalAspirationCases/.BooleanP -> FinalAspiration,
			{}
		],
		If[!MatchQ[conflictingMethodAspirationCases, {}],
			Append[conflictingMethodAspirationCases, Method],
			{}
		],
		If[!MatchQ[conflictingMethodDispenseCases, {}],
			Append[conflictingMethodDispenseCases, Method],
			{}
		],
		If[!TrueQ[compatibleMaterialsBool],
			{Instrument, Buffer},
			{}
		]
	}]];

	allTests = Flatten[{
		precisionTests,
		discardedTests,
		deprecatedTest,
		incompatibleSampleContainerTests,
		invalidPlateSampleTest,
		duplicateTest,
		invalidInstrumentTest,
		conflictingPrimeTest,
		conflictingCrosswiseAspirationTest,
		conflictingFinalAspirationTest,
		conflictingMethodAspirationTest,
		conflictingMethodDispenseTest,
		compatibleMaterialsTests
	}];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	(* NOTE: Quiet General::stop when throwing InvalidInput/InvalidOptions because they do not get quieted in ModifyFunctionMessages *)
	Quiet[
		If[Length[invalidInputs] > 0 && !gatherTests,
			Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall, Simulation -> simulation]]
		],
		General::stop
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	(* NOTE: Quiet General::stop when throwing InvalidInput/InvalidOptions because they do not get quieted in ModifyFunctionMessages *)
	Quiet[
		If[Length[invalidOptions] > 0 && !gatherTests,
			Message[Error::InvalidOption, invalidOptions]
		],
		General::stop
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> allTests
	}
];

(* ::Subsection:: *)
(*washPlateResourcePackets*)

DefineOptions[
	washPlateResourcePackets,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

washPlateResourcePackets[
	myInputs: {ObjectP[{Object[Sample], Object[Container]}]..},
	myContainers: {ObjectP[Object[Container]]..},
	myTemplatedOptions: {(_Rule|_RuleDelayed)...},
	myResolvedOptions: {(_Rule|_RuleDelayed)..},
	ops: OptionsPattern[]
] := Module[
	{
		expandedInputs, expandedResolvedOptions, outputSpecification, output, gatherTests, messages, inheritedCache, simulation,
		unitOperationPackets, rawResourceBlobs, resourcesWithoutName, resourceToNameReplaceRules, allResourceBlobs,
		testsRule, resultRule
	},

	(* Expand the resolved options if they weren't expanded already. *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentWashPlate, {myInputs}, myResolvedOptions];

	(* Determine the requested return value from the function. *)
	outputSpecification = OptionDefault[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages. *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;

	(* Get the inherited cache. *)
	inheritedCache = Lookup[ToList[ops], Cache];
	simulation = Lookup[ToList[ops], Simulation];

	unitOperationPackets = Module[
		{
			uniqueInputs, uniqueInputToResourceLookup, inputResources, uniqueContainers, uniqueContainerToResourceLookup,
			containerResources, instrument, instrumentRunTime, instrumentResource, washPlateUnitOperationPacket,
			washPlateUnitOperationPacketWithLabeledObjects
		},

		(* Create resources for our samples and containers. *)
		uniqueInputs = DeleteDuplicates[myInputs];
		uniqueInputToResourceLookup = Map[
			# -> Resource[Sample -> #, Name -> ToString[Unique[]]]&,
			uniqueInputs
		];
		inputResources = myInputs/.uniqueInputToResourceLookup;
		uniqueContainers = DeleteDuplicates[myContainers];
		uniqueContainerToResourceLookup = Map[
			# -> Resource[Sample -> #, Name -> ToString[Unique[]]]&,
			uniqueContainers
		];
		containerResources = myContainers/.uniqueContainerToResourceLookup;

		instrument = Download[Lookup[myResolvedOptions, Instrument], Object];
		instrumentRunTime = washPlateRunTime[Length[DeleteDuplicates@myContainers], Lookup[myResolvedOptions, NumberOfWashes], Lookup[myResolvedOptions, Priming]];
		instrumentResource = Resource[Instrument -> instrument, Time -> instrumentRunTime, Name -> ToString[Unique[]]];

		(* Upload our UnitOperation with the options replaced with resources. *)
		washPlateUnitOperationPacket = Module[{nonHiddenWashPlateOptions, existingMethodFile},
			(* Only include non-hidden options from WashPlate. *)
			nonHiddenWashPlateOptions = Lookup[
				Cases[OptionDefinition[ExperimentWashPlate], KeyValuePattern["Category" -> Except["Hidden"]]],
				"OptionSymbol"
			];

			(* Check the method has LHC file associated it or not *)
			existingMethodFile = Which[
				MatchQ[Lookup[myResolvedOptions, Method], Custom],
					Null,
				MatchQ[Lookup[fetchPacketFromCache[Lookup[myResolvedOptions, Method], inheritedCache], MethodFile], ObjectP[]],
					Download[Lookup[fetchPacketFromCache[Lookup[myResolvedOptions, Method], inheritedCache], MethodFile], Object],
				True,
					Null
			];

			UploadUnitOperation[
				WashPlate@@Join[
					{
						Sample -> inputResources,
						(* The BufferLine will be determined in the framework in case multiple WashPlate primitives are called *)
						If[MatchQ[Lookup[myResolvedOptions, Method], ObjectP[Object[Method, WashPlate]]],
							Sequence@@{
								WashPlateMethod -> Link[Lookup[myResolvedOptions, Method]],
								MethodFile -> If[NullQ[existingMethodFile], Null, Link[existingMethodFile]],
								MethodFileName -> Lookup[myResolvedOptions, MethodFileName],
								BufferLine -> Null
							},
							Sequence@@{
								MethodFileName -> Lookup[myResolvedOptions, MethodFileName],
								BufferLine -> Null
							}
						]
					},
					(* NOTE: We allow for MultichannelWashPlateName (developer field) since it's used in the exporter. *)
					ReplaceRule[
						Cases[myResolvedOptions, Verbatim[Rule][Alternatives@@nonHiddenWashPlateOptions, _]],
						{
							Instrument -> instrumentResource,
							(* NOTE: Don't pass Name down. *)
							Name -> Null
						}
					]
				],

				Preparation -> Robotic,
				UnitOperationType -> Output,
				FastTrack -> True,
				Upload -> False
			]
		];
		(* Add the LabeledObjects field to the Robotic unit operation packet. *)
		(* NOTE: This will be stripped out of the UnitOperation packet by the framework and only stored at the top protocol level. *)
		washPlateUnitOperationPacketWithLabeledObjects = Append[
			washPlateUnitOperationPacket,
			Replace[LabeledObjects] -> DeleteDuplicates@Join[
				Cases[
					Transpose[{Lookup[myResolvedOptions, SampleLabel], inputResources}],
					{_String, Resource[KeyValuePattern[Sample -> ObjectP[{Object[Sample], Model[Sample]}]]]}
				],
				Cases[
					Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], containerResources}],
					{_String, Resource[KeyValuePattern[Sample -> ObjectP[{Object[Container], Model[Container]}]]]}
				]
			]
		];

		(* Return our protocol packet (we don't have one) and our unit operation packet. *)
		washPlateUnitOperationPacketWithLabeledObjects
	];

	(* Make list of all the resources we need to check in FRQ. *)
	rawResourceBlobs = DeleteDuplicates[Cases[Flatten[Normal[unitOperationPackets]], _Resource, Infinity]];

	(* Get all resources without a name. *)
	(* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName = DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];

	resourceToNameReplaceRules = MapThread[#1 -> #2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name -> CreateUUID[]]]&) /@ resourcesWithoutName}];
	allResourceBlobs = rawResourceBlobs/.resourceToNameReplaceRules;

	(* Skip frq since when Preparation->Robotic, the framework will call FRQ for us. *)

	(* --- Output --- *)

	(* Generate the tests rule. *)
	(* When Preparation->Robotic, the framework will call FRQ for us. *)
	testsRule = (Tests -> {});

	(* Generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed. *)
	resultRule = Result -> If[MemberQ[output, Result],
		unitOperationPackets/.resourceToNameReplaceRules,
		$Failed
	];

	(* Return the output as we desire it. *)
	outputSpecification/.{resultRule, testsRule}
];

(* ::Subsection::Closed:: *)
(*simulateExperimentWashPlate*)

DefineOptions[
	simulateExperimentWashPlate,
	Options :> {CacheOption, SimulationOption, ParentProtocolOption}
];

simulateExperimentWashPlate[
	myUnitOperationPacket: (PacketP[Object[UnitOperation, WashPlate]]|Null|$Failed),
	myInputs: {ObjectP[{Object[Sample], Object[Container]}]..},
	myContainers: {ObjectP[Object[Container]]..},
	myResolvedOptions: {_Rule...},
	myResolutionOptions: OptionsPattern[simulateExperimentWashPlate]
] := Module[
	{
		inheritedCache, inheritedSimulation, protocolObject, currentSimulation, simulatedContainerPackets,
		simulatedLiquidSamples, aspirationTransferPackets, dispenseTransferPackets, simulationWithLabels
	},

	(* Get simulation and cache *)
	{inheritedCache, inheritedSimulation} = Lookup[ToList[myResolutionOptions], {Cache, Simulation}, {}];

	(* NOTE: We never make a protocol object in the resource packets function when Preparation->Robotic. We have to *)
	(* simulate an ID here in the simulation function in order to call SimulateResources. *)
	protocolObject = SimulateCreateID[Object[Protocol, RoboticSamplePreparation]];

	(* Simulate the fulfillment of all resources by the procedure. *)
	currentSimulation = Module[{protocolPacket},
		(* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
		(* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
		protocolPacket = <|
			Object -> protocolObject,
			Replace[OutputUnitOperations] -> If[MatchQ[myUnitOperationPacket, PacketP[]], {Link[myUnitOperationPacket, Protocol]}, {}],
			(* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
			(* simulate resources will NOT simulate them for you. *)
			(* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
			Replace[RequiredObjects] -> DeleteDuplicates[Cases[myUnitOperationPacket, Resource[KeyValuePattern[Type -> Except[Object[Resource, Instrument]]]], Infinity]],
			Replace[RequiredInstruments] -> DeleteDuplicates[Cases[myUnitOperationPacket, Resource[KeyValuePattern[Type -> Object[Resource, Instrument]]], Infinity]],
			ResolvedOptions -> {},
			UnresolvedOptions -> {}
		|>;

		SimulateResources[
			protocolPacket,
			{myUnitOperationPacket},
			ParentProtocol -> Lookup[myResolvedOptions, ParentProtocol, Null],
			Simulation -> inheritedSimulation
		]
	];

	(* Download information from our simulated resources. *)
	simulatedContainerPackets = Quiet[
		Download[
			myContainers,
			{
				Packet[Contents],
				Packet[Contents[[All, 2]][{State}]]
			},
			Cache -> inheritedCache,
			Simulation -> currentSimulation
		],
		{Download::NotLinkField, Download::FieldDoesntExist}
	];

	(* Extract liquid samples from simulatedContainerPackets *)
	simulatedLiquidSamples = Module[{allContentSamples, allLiquidSamples},
		allContentSamples = Cases[Flatten@Lookup[Flatten@simulatedContainerPackets, Contents, {}], ObjectP[Object[Sample]]];
		allLiquidSamples = Map[
			If[MatchQ[Lookup[fetchPacketFromCache[#, inheritedCache], State], Liquid],
				#,
				Nothing
			]&,
			Download[allContentSamples, Object]
		];
		DeleteDuplicates[allLiquidSamples]
	];

	(* Call UploadSampleTransfer on all liquid samples and update volume *)
	(* At the end of WashPlate, previous liquid samples in plates will be all aspirated *)
	aspirationTransferPackets = If[MatchQ[simulatedLiquidSamples, {}],
		{},
		Module[
			{simulatedWasteContainerPacket, simulatedWasteContainerObject, simulatedWasteSamplePacket, simulatedWasteSampleObject},
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
			simulatedWasteSampleObject = FirstCase[Lookup[simulatedWasteSamplePacket, Object], ObjectP[Object[Sample]]];

			UploadSampleTransfer[
				simulatedLiquidSamples,
				ConstantArray[simulatedWasteSampleObject, Length[simulatedLiquidSamples]],
				ConstantArray[All, Length[simulatedLiquidSamples]],
				Upload -> False,
				Simulation -> currentSimulation,
				FastTrack -> True,
				UpdatedBy -> protocolObject
			]
		]
	];

	(* Update the simulation with the aspirationTransferPackets. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[aspirationTransferPackets]];

	(* When FinalAspiration is False, Buffer at WashVolume remains in the input containers, call UST *)
	dispenseTransferPackets = If[MatchQ[simulatedLiquidSamples, {}] || MatchQ[Lookup[myResolvedOptions, FinalAspiration], True],
		{},
		Module[{simulatedBufferContainerPacket, simulatedBufferContainerObject, simulatedBufferSamplePacket, simulatedBufferSampleObject},
			(* Upload a simulated BufferA container to the bench. *)
			(* Note:we cannot simulate Buffer in the SimulateResources above since framework will need to consolidate WashBuffer *)
			simulatedBufferContainerPacket = If[MatchQ[Lookup[myResolvedOptions, Buffer], ObjectP[Model[Sample]]],
				UploadSample[
					Model[Container, Vessel, "2L Glass Bottle"],
					{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]},(*Object[Container, Room, "id:AEqRl9KmEAz5"]*)
					Upload -> False,
					Simulation -> currentSimulation
				],
				{}
			];
			simulatedBufferContainerObject = If[MatchQ[Lookup[myResolvedOptions, Buffer], ObjectP[Model[Sample]]],
				FirstCase[Lookup[simulatedBufferContainerPacket, Object], ObjectP[Object[Container, Vessel]]],
				Null
			];

			(* Add this container to the existing simulation. *)
			currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulatedBufferContainerPacket]];

			(* Now upload a simulated sample to the existing simulation. *)
			simulatedBufferSamplePacket = If[MatchQ[Lookup[myResolvedOptions, Buffer], ObjectP[Model[Sample]]],
				UploadSample[
					Lookup[myResolvedOptions, Buffer],
					{"A1", simulatedBufferContainerObject},
					InitialAmount -> 2000 Milliliter,
					Simulation -> currentSimulation,
					SimulationMode -> True,
					FastTrack -> True,
					Upload -> False
				],
				{}
			];

			(* Update the simulation with the buffer object. *)
			currentSimulation = UpdateSimulation[currentSimulation, Simulation[simulatedBufferSamplePacket]];

			(* Now get the simulated buffer sample. *)
			simulatedBufferSampleObject = FirstCase[Lookup[simulatedBufferSamplePacket, Object], ObjectP[Object[Sample]]];

			(* At the end of WashPlate, liquid samples in plates will have WashVolume amount of Buffer *)
			(* Do not simulate new samples on previous empty wells since they are what we do not care and creating them might create problems for downstream uos *)
			UploadSampleTransfer[
				ConstantArray[simulatedBufferSampleObject, Length[simulatedLiquidSamples]],
				simulatedLiquidSamples,
				ConstantArray[Lookup[myResolvedOptions, WashVolume], Length[simulatedLiquidSamples]],
				Upload -> False,
				Simulation -> currentSimulation,
				FastTrack -> True,
				UpdatedBy -> protocolObject
			]
		]
	];

	(* Update our simulation with the dispenseTransferPackets. *)
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[dispenseTransferPackets]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the SamplesIn field. *)
	simulationWithLabels = Simulation[
		Labels -> Rule@@@Join[
			Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], myInputs}],
				{_String, ObjectP[Object[Sample]]}
			],
			Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], myContainers}],
				{_String, ObjectP[Object[Container]]}
			]
		]
	];

	(* Merge our packets with our labels. *)
	UpdateSimulation[currentSimulation, simulationWithLabels]
];

(* ::Subsection::Closed:: *)
(*ExperimentWashPlate Sister Functions*)


DefineOptions[ValidExperimentWashPlateQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentWashPlate}
];

(* --- Source code --- *)
ValidExperimentWashPlateQ[
	myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]],
	myOptions: OptionsPattern[ValidExperimentWashPlateQ]
]:=Module[
	{listedOptions, preparedOptions, washPlateTests, initialTestDescription, allTests, verbose,outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentWashPlate *)
	washPlateTests = ExperimentWashPlate[myInputs, Append[preparedOptions, Output -> Tests]];

	(* Define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(*Make a list of all of the tests, including the blanket test *)
	allTests = If[MatchQ[washPlateTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[{initialTest, validObjectBooleans, voqWarnings, allObjects},

			(* Generate the initial test, which we know will pass if we got this far (hopefully) *)
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			allObjects = DeleteDuplicates[Cases[Flatten[{myInputs, myOptions}], ObjectP[], Infinity]];
			validObjectBooleans = ValidObjectQ[
				allObjects,
				OutputFormat -> Boolean
			];

			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{allObjects, validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest, washPlateTests, voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentWashPlateQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentWashPlateQ"]
];


(* ::Subsubsection:: *)
(*ExperimentWashPlateOptions*)


DefineOptions[ExperimentWashPlateOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ExperimentWashPlate}
];

(* --- Source code --- *)
ExperimentWashPlateOptions[
	myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]],
	myOptions: OptionsPattern[ExperimentWashPlateOptions]
] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentWashPlate *)
	options = ExperimentWashPlate[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentWashPlate],
		options
	]
];

(* ::Subsection:: *)
(*ExperimentWashPlatePreview*)


DefineOptions[ExperimentWashPlatePreview,
	SharedOptions :> {ExperimentWashPlate}
];

ExperimentWashPlatePreview[
	myInputs: ListableP[ObjectP[{Object[Sample], Object[Container]}]],
	myOptions: OptionsPattern[]
] := Module[
	{listedOptions, noOutputOptions},

	(* Get the options as a list*)
	listedOptions = ToList[myOptions];

	(* Remove the Output options before passing to the main function. *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(*PlotContents, MouseOver, Tooltip*)
	(* Return only the preview for ExperimentWashPlate *)
	ExperimentWashPlate[myInputs, Append[noOutputOptions, Output -> Preview]]
];