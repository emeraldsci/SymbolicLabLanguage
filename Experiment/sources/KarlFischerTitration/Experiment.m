(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentKarlFischerTitration*)


(* ::Subsubsection:: *)
(*Options*)

DefineOptions[
	ExperimentKarlFischerTitration,
	Options :> {
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "The instrument that is used to measure the water content of a sample by measuring the consumption of iodine in a Karl Fischer reaction.",
			ResolutionDescription -> "Automatically set to Model[Instrument, KarlFischerTitrator, \"Metrohm 851 Titrando with generator electrode without diaphragm\"] if Method is set to Coulometric, or Model[Instrument, KarlFischerTitrator, \"Metrohm 901 Titrando\"] if Method is set to Volumetric.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, KarlFischerTitrator], Object[Instrument, KarlFischerTitrator]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Karl Fischer Titrators"
					}
				}
			]
		},
		{
			OptionName -> Technique,
			Default -> Automatic,
			Description -> "Indicates how the Karl Fischer reagent is introduced to the sample.  If set to Volumetric, the Karl Fischer reagent mixture is introduced via a buret in small increments, and the amount of iodine consumed is measured via conductivity as liquid is introduced.  If set to Coulometric, molecular iodine is generated in situ by applying a pulse of electric current to a sample of iodine anions, and the consumption of this generated iodine is measured via conductivity.",
			ResolutionDescription -> "Automatically set to the TitrationTechnique field of the specified Instrument model.  If Instrument is not specified, automatically set to Volumetric if Temperature is set to Ambient, or SamplingMethod is set to Liquid, or a KarlFischerReagent is specified that contains molecular iodine, or Medium is specified, or Standard is set to a liquid standard, or GasFlowRate is set to Null, or if the input samples are Liquid.  Otherwise, automatically set to Coulometric.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> KarlFischerTechniqueP
			]
		},
		{
			OptionName -> KarlFischerReagent,
			Default -> Automatic,
			Description -> "If set to Technique is set to Volumetric, the reagent mixture that is introduced to the sample.  In order to measure water content, this mixture should contain iodine, sulfur dioxide, an organic solvent, and an organic base. If Technique is set to Coulometric, the mixture through which sample headspace is bubbled. Unlike Volumetric, this mixture should contain iodide ions instead of iodine.",
			ResolutionDescription -> "If Method is set to Volumetric, automatically set to Model[Sample, \"HYDRANAL - Composite 5\"].  If Method is set to Coulometric, automatically set to Model[Sample, \"HYDRANAL - Coulomat AG-Oven\"].",
			AllowNull -> False,
			Category -> "General",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> KarlFischerReagentP
				],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Karl Fischer Titration",
							"Reagent Mixtures"
						}
					}
				]
			]
		},
		{
			OptionName -> SamplingMethod,
			Default -> Automatic,
			Description -> "The process by which the sample is introduced to the Karl Fischer reagent, or vice versa.  If set to Liquid, then the Karl Fischer reagent is introduced to the sample directly.  If set to Headspace, then the sample is heated to the specified Temperature and the released gas flows into the Karl Fischer reagent chamber and measured for water content.",
			ResolutionDescription -> "If Technique is set to Coulometric, SamplingMethod is automatically set to Headspace.  If Technique is Volumetric, SamplingMethod is automatically set to Liquid.",
			AllowNull -> False,
			Category -> "Sampling",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> KarlFischerSamplingMethodP
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			SampleLabelOptions,
			{
				OptionName -> SampleAmount,
				Default -> Automatic,
				Description -> "Indicates the amount of sample to be added to the reaction chamber or headspace vial for their water content to be measured.  If Grind is set to True, this is the amount of ground powder to be used.",
				ResolutionDescription -> "If input sample's State is Solid, automatically set to 100 Milligram or the total mass of the sample, whichever is smaller.  If input sample's State is Liquid, automatically set to 1 Milliliter or the total volume of the sample, whichever is smaller.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[10 Milligram, 100 Gram],
						Units -> {Milligram, {Milligram, Gram}}
					],
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[10 Microliter, 100 Milliliter],
						Units -> {Milliliter, {Microliter, Milliliter, Liter}}
					]
				]
			},
			{
				OptionName -> Temperature,
				Default -> Automatic,
				Description -> "Indicates the temperature to which the sample is heated in order to release its water for Coulometric technique. The headspace gas is then carried into the reaction chamber according to GasFlowRate and water content is measured. If set to a temperature, the oven will heat the sample to that value and the headspace gas will be bubbled through the KarlFisherReagent in the reaction vessel. Can only be set to Ambient if Technique is set to Volumetric, where no heating will be performed and headspace gas will not be collected.",
				ResolutionDescription -> "If Technique is set to Volumetric, automatically set to Ambient. If Technique is set to Coulometric, automatically set to 220 Celsius if Standard is set to Model[Sample,\"HYDRANAL Water Standard KF-Oven 220C-230C\"], or 150 Celsius if Standard is set to Model[Sample, \"HYDRANAL - Water Standard KF-Oven 150-160 C\"].  Otherwise, automatically set to 150 Celsius.",
				AllowNull -> True,
				Category -> "Sampling",
				Widget -> Alternatives[
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[50 Celsius, 250 Celsius],
						Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
					],
					"Ambient" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			{
				OptionName -> Medium,
				Default -> Automatic,
				Description -> "Indicates the solvent in which the sample will be dissolved for the Karl Fischer reaction to occur. Sample will be dissolved in this solvent and then either treated with the KarlFischerReagent directly, or the sample will be heated and the headspace gas will be titrated with KarlFischerReagent.",
				ResolutionDescription -> "If Technique is set to Volumetric, automatically set to Model[Sample, \"HYDRANAL Methanol Rapid\"], which is as mixture of anhydrous methanol, sulfur dioxide, and imidazole; these additives enable faster determination of water content. Model[Sample, \"HYDRANAL Methanol Dry\"] (anhydrous methanol without the additives) may also be used.",
				AllowNull -> True,
				Category -> "Titration",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> KarlFischerTitrationMediumP
					],
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Karl Fischer Titration",
								"Titration Media"
							},
							{
								Object[Catalog, "Root"],
								"Materials",
								"Reagents",
								"Solvents",
								"Organic Solvents"
							}
						}
					]
				]
			}
		],
		{
			OptionName -> Standard,
			Default -> Automatic,
			Description -> "Indicates the sample used to validate the instrument as a whole by measuring the Karl Fischer reagent's rate of reaction, and water content drift. Liquid water may be used directly for this, or a a certified water content standard may be used. If a standard different from these is selected, the expected water content is determined from the sample's WaterContent field.  If WaterContent is not populated, water content is determined from the sample's Composition.",
			ResolutionDescription -> "If Method is set to Volumetric, automatically set to Model[Sample, \"Milli-Q water\"].  If Method is set to Coulometric and Temperature is set to above 200 Celsius, automatically set to Model[Sample,\"HYDRANAL Water Standard KF-Oven 220C-230C\"].  Otherwise, automatically set to Model[Sample, \"HYDRANAL - Water Standard KF-Oven 150-160 C\"].",
			AllowNull -> False,
			Category -> "Standards & Blanks",
			(* will use OpenPaths to push towards Karl Fischer standards; if it's not one of them then we will just use the water content in the Composition of the specified model/sample or the WaterContent field (?) *)
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Karl Fischer Titration",
						"Standards"
					}
				}
			]
		},
		{
			OptionName -> StandardAmount,
			Default -> Automatic,
			Description -> "Indicates the amount of standard to be added to the reaction chamber or headspace vial for its water content to be measured.",
			ResolutionDescription -> "If Standard is set to Model[Sample, \"Milli-Q water\"], automatically set to 10 Microliter. If Standard is a non-water liquid, automatically set to 1.5 Milliliter. If Standard is a solid, automatically set to 100 Milligram.",
			AllowNull -> False,
			Category -> "Standards & Blanks",
			Widget -> Alternatives[
				"Mass" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Milligram, 5 Gram],
					Units -> {Milligram, {Milligram, Gram}}
				],
				"Volume" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 5 Milliliter],
					Units -> {Milliliter, {Microliter, Milliliter, Liter}}
				]
			]
		},
		{
			OptionName -> NumberOfStandards,
			Default -> 3,
			Description -> "Indicates the number of Standard samples whose water content is measured to validate the titration instrument.",
			AllowNull -> False,
			Category -> "Standards & Blanks",
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			]
		},
		{
			OptionName -> NumberOfBlanks,
			Default -> Automatic,
			Description -> "Indicates the number of empty vials whose water content is measured to accurately capture the humidity of the surroundings.  This option is only valid if SamplingMethod is set to Headspace.",
			ResolutionDescription -> "Automatically set to 3 if SamplingMethod is Headspace.",
			AllowNull -> True,
			Category -> "Standards & Blanks",
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 5, 1]
			]
		},
		{
			OptionName -> StandardTemperature,
			Default -> Automatic,
			Description -> "Indicates the temperature to which the standard is heated in order to release its water for Coulometric technique. The headspace gas is then carried into the reaction chamber according to GasFlowRate and water content is measured. If set to a temperature, the oven will heat the sample to that value and the headspace gas will be bubbled through the KarlFisherReagent in the reaction vessel. Can only be set to Ambient if Technique is set to Volumetric, where no heating will be performed and headspace gas will not be collected.",
			ResolutionDescription -> "If Technique is set to Volumetric, automatically set to Ambient. If Technique is set to Coulometric, automatically set to 220 Celsius if Standard is set to Model[Sample,\"HYDRANAL Water Standard KF-Oven 220C-230C\"], or 150 Celsius if Standard is set to Model[Sample, \"HYDRANAL - Water Standard KF-Oven 150-160 C\"].  Otherwise, automatically set to 150 Celsius.",
			AllowNull -> True,
			Category -> "Sampling",
			Widget -> Alternatives[
				"Temperature" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[50 Celsius, 250 Celsius],
					Units -> {Celsius, {Celsius, Fahrenheit, Kelvin}}
				],
				"Ambient" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]
			]
		},
		{
			OptionName -> GasFlowRate,
			Default -> Automatic,
			Description -> "Indicates the rate at which nitrogen is flowed to carry the headspace gas from the sample into the Karl Fischer reagent.",
			ResolutionDescription -> "Automatically set to 10 Millililter / Minute if SamplingMethod is set to Headspace.",
			AllowNull -> True,
			Category -> "Sampling",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[10 Milliliter / Minute, 150 Milliliter / Minute],
				Units -> {Milliliter / Minute, {Milliliter / Minute}}
			]
		},

		ModifyOptions[
			GrindSharedOptions,
			Grind,
			{
				Description -> "Determines if the sample is ground to a fine powder (to reduce the size of powder particles) via a lab mill (grinder) before measuring the water content.",
				ResolutionDescription -> "Automatically set to True if the provided sample is a solid tablet or capsule.  Otherwise, set to False."
			}
		],
		ModifyOptions[
			GrindSharedOptions,
			GrinderType,
			{
				ResolutionDescription -> "Automatically set to the GrinderType of the specified Grinder.  If Grinder is not specified but Grind is True, automatically set to KnifeMill."
			}
		],
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> GrindAmount,
				Default -> Automatic,
				Description -> "The amount of input sample to be ground into a fine powder.",
				ResolutionDescription -> "If Grind is True and the input is Tablet and the Amount option is less than three times the input sample's SolidUnitWeight, automatically set to 4.  Otherwise, automatically set to 4 + the Amount divided by the input sample's SolildUnitWeight (rounded down).",
				AllowNull -> True,
				Category -> "Grinding",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 100, 1]
				]
			}
		],
		GrindSharedOptions,
		SimulationOption,
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		ModelInputOptions
	}
];

(* ::Subsubsection:: *)
(*Messages*)

Error::NonGrindableSamples="Grind was set to True for the following sample(s): `1`.  These samples cannot be ground; only solid samples with Tablet set to True can have Grind set to True.  Please allow all grind options to be set automatically.";
Error::GrindOptionMismatch="Some Grind options are in conflict with each other.  If Grind is False, no other grind options may be specified.  Please allow some or all of these options to be set automatically.";
Error::NumberOfBlanksMismatch="The NumberOfBlanks value `1` is in conflict with the `2` Technique. NumberOfBlanks measures the number of empty headspace vials whose water content is measured, and thus is irrelevant if not doing coulometric titration with headspace sampling (and is required if doing coulometric titration).  Please allow NumberOfBlanks to be set automatically.";
Warning::KarlFischerReagentComponents="The specified KarlFischerReagent `1` may not have all components necessary to perform the Karl Fischer reagent.  In order to perform the Karl Fischer reaction, the reagent must contain sulfur dioxide, iodine (volumetric) or iodide (coulombic), an organic base, and an organic solvent. If this is not desired, please change the KarlFischerReagent option to a reagent in the ECL catalog, or allow it to be set automatically.";
Error::SamplingMethodMismatch="SamplingMethod is set to `1`, but Temperature is set to `2` for sample(s) `3`.  If SamplingMethod is set to Liquid, then Temperature must be Ambient.  If SamplingMethod is set to Headspace, then Temperature set to a value.";
Error::TechniqueSamplingMethodMismatch="Technique was set to `1`, but SamplingMethod was set to `2`.  Coulometric Karl Fischer titration may only be performed by heating and sampling Headspace, and Volumetric Karl Fischer tration may only be performed by titrating reagent into a liquid sample.  Please change the SamplingMethod or Technique options to agree, or allow one or both of them to be set automatically.";
Error::InstrumentTechniqueMismatch="Technique was set to `1`, but the specified instrument `2` may only do Karl Fischer titration using the `3` technique.  Please change the value of these options, or leave one or both to be set automatically.";
Error::StandardAmountMismatch="StandardAmount was set to `1`, but the state of the specified standard is `2`.  Please set StandardAmount to a `3`, or allow it to be set automatically.";
Error::TooManySamplesKarlFischerTitration="Too many samples were specified for this experiment.  The maximum number of samples, blanks, and standards together is `1`, but `2` were specified.  Please use fewer samples and break into multiple Experiment calls.";
(* also borrowing the exact text for NMR's Error::SampleAmountStateConflict option*)

(* these are the currently supported symbols for KF *)
karlFischerSymbolsToReagents[]:={
	HydranalCoulomatAGOven -> Model[Sample, "HYDRANAL - Coulomat AG-Oven"],
	HydranalCoulomatAG -> Model[Sample, "HYDRANAL Coulomat AG"],
	HydranalComposite5 -> Model[Sample, "HYDRANAL Composite 5"],
	HydranalComposite5K -> Model[Sample, "HYDRANAL Composite 5 K"],
	HydranalComposite2 -> Model[Sample, "HYDRANAL Composite 2"],
	HydranalComposite1 -> Model[Sample, "HYDRANAL Composite 1"]
};
karlFischerSymbolsToMedium[]:={
	MethanolDry -> Model[Sample, "HYDRANAL Methanol Dry"],
	MethanolRapid -> Model[Sample, "HYDRANAL Methanol Rapid"]
}

(* these are molecules for HI, I-, and I2 (which I use in the code below) *)
$HydrogenIodideMolecule = Molecule["Hydrogen iodide"];
$IodideAnionMolecule = Molecule["Iodide"];
$IodineMolecule = Molecule["Iodine"];

(* ::Subsubsection:: *)
(*Experiment function*)


(* ::Subsection:: *)
(*ExperimentKarlFischerTitration*)


(* Mixed Input *)
ExperimentKarlFischerTitration[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String|{LocationPositionP,_String|ObjectP[Object[Container]]}], myOptions: OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTests, containerToSampleResult, samples,
		sampleOptions, containerToSampleTests, containerToSampleOutput, validSamplePreparationResult,containerToSampleSimulation,
		mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* make the inputs and options a list *)
	{listedContainers, listedOptions} = {ToList[myInputs], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentKarlFischerTitration,
			listedContainers,
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
			ExperimentKarlFischerTitration,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
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
				ExperimentKarlFischerTitration,
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
		ExperimentKarlFischerTitration[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]
];


(* Sample input/core overload *)
ExperimentKarlFischerTitration[mySamples: ListableP[ObjectP[Object[Sample]]], myOptions: OptionsPattern[]] := Module[
	{
		listedSamples, listedOptions, outputSpecification, output, gatherTests, validSamplePreparationResult,
		samplesWithPreparedSamples, optionsWithPreparedSamples, safeOps, safeOpsTests, validLengths, validLengthTests,
		templatedOptions, templateTests, inheritedOptions, updatedSimulation, expandedSafeOps,
		objectSampleFields,modelSampleFields,objectContainerFields, modelContainerFields, packetObjectSample,
		upload, confirm, canaryBranch, fastTrack, parentProtocol, cache, downloadedStuff, cacheBall,
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions,
		performSimulationQ, optionsResolverOnly, returnEarlyBecauseOptionsResolverOnly, returnEarlyBecauseFailuresQ,
		protocolPacketWithResources, resourcePacketTests, simulatedProtocol, grindSimulation,
		simulation, result, samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed,
		safeOptionsNamed, postProcessingOptions, totalTimesEstimate, allKFTitrators, allKFReactionVessels,
		allKFStandards, allKFMedia, allKFReagents,specifiedStandardModels, specifiedStandardObjs,
		specifiedKFReagentModels, specifiedKFReagentObjs, specifiedKFMediumModels, specifiedKFMediumObjs,
		specifiedKFTitratorModels, specifiedKFTitratorObjs, packetModelSample, modelInstrumentFields
	},

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed, optionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentKarlFischerTitration,
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
		SafeOptions[ExperimentKarlFischerTitration, optionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentKarlFischerTitration, optionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Replace all objects referenced by Name to ID *)
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
		ValidInputLengthsQ[ExperimentKarlFischerTitration, {samplesWithPreparedSamples}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentKarlFischerTitration, {samplesWithPreparedSamples}, optionsWithPreparedSamples], Null}
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
		ApplyTemplateOptions[ExperimentKarlFischerTitration, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentKarlFischerTitration, {ToList[samplesWithPreparedSamples]}, optionsWithPreparedSamples], Null}
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
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentKarlFischerTitration, {ToList[samplesWithPreparedSamples]}, inheritedOptions]];

	(* Get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProtocol, cache} = Lookup[expandedSafeOps, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* --- Search for and Download all the information we need for resolver and resource packets function --- *)

	(* get all the KF Reagents, Media, and Standards *)
	{
		allKFTitrators,
		allKFStandards,
		allKFMedia,
		allKFReagents
	} = allKarlFischerMaterials["Memoization"];

	objectSampleFields = SamplePreparationCacheFields[Object[Sample]];
	modelSampleFields = SamplePreparationCacheFields[Model[Sample]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	modelContainerFields = SamplePreparationCacheFields[Model[Container]];

	(* Download information for if we're Downloading from Object[Sample] or Model[Sample] objects *)
	packetObjectSample = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Model[modelSampleFields]]
	};
	packetModelSample = {
		Packet[Sequence @@ modelSampleFields]
	};

	(* information we need from model instruments*)
	modelInstrumentFields = {TitrationTechnique, SamplingMethods, Positions, ReactionVesselModel};

	(* get the specified standards and models *)
	specifiedStandardModels = Cases[
		Flatten[{
			allKFStandards,
			Lookup[expandedSafeOps, Standard]
		}],
		ObjectP[Model[Sample]]
	];
	specifiedStandardObjs = Cases[
		Flatten[{Lookup[expandedSafeOps, Standard]}],
		ObjectP[Object[Sample]]
	];

	(* get the specified KarlFischerReagents and models *)
	specifiedKFReagentModels = Cases[
		Flatten[{
			allKFReagents,
			Lookup[expandedSafeOps, KarlFischerReagent]
		}],
		ObjectP[Model[Sample]]
	];
	specifiedKFReagentObjs = Cases[
		Flatten[{Lookup[expandedSafeOps, KarlFischerReagent]}],
		ObjectP[Object[Sample]]
	];

	(* get the specified Media and models *)
	specifiedKFMediumModels = Cases[
		Flatten[{
			allKFMedia,
			Lookup[expandedSafeOps, Medium]
		}],
		ObjectP[Model[Sample]]
	];
	specifiedKFMediumObjs = Cases[
		Flatten[{Lookup[expandedSafeOps, Medium]}],
		ObjectP[Object[Sample]]
	];

	(* get the specified instruments and models *)
	specifiedKFTitratorModels = Cases[
		Flatten[{
			allKFTitrators,
			Lookup[expandedSafeOps, Instrument]
		}],
		ObjectP[Model[Instrument]]
	];
	specifiedKFTitratorObjs = Cases[
		Flatten[{Lookup[expandedSafeOps, Instrument]}],
		ObjectP[Object[Instrument]]
	];


	(* Download all the things *)
	downloadedStuff = Quiet[Download[
		{
			(*1*)samplesWithPreparedSamples,
			(*2*)specifiedStandardModels,
			(*3*)specifiedKFReagentModels,
			(*4*)specifiedKFMediumModels,
			(*5*)specifiedStandardObjs,
			(*6*)specifiedKFReagentObjs,
			(*7*)specifiedKFMediumObjs,
			(*8*)specifiedKFTitratorModels,
			(*9*)specifiedKFTitratorObjs
		},
		Evaluate[{
			(* samples *)
			(*1*)packetObjectSample,
			(* materials models*)
			(*2*)packetModelSample,
			(* for the KF reagents need information about the composition to tell if there is Iodine in there *)
			(*3*){
				Packet[Sequence @@ modelSampleFields],
				Packet[Field[Composition[[All, 2]][{Name, Molecule}]]]
			},
			(*4*)packetModelSample,
			(* materials objects*)
			(*5*)packetObjectSample,
			(*6*)Append[
				packetObjectSample,
				Packet[Field[Composition[[All, 2]][{Name, Molecule}]]]
			],
			(*7*)packetObjectSample,
			(*instrument models*)
			(*8*){
				Packet @@ modelInstrumentFields,
				Packet[ReactionVesselModel[{MaxVolume, Graduations}]]
			},
			(* instrument objects *)
			(*9*)
			{
				Packet[Model[modelInstrumentFields]],
				Packet[Contents, Model]
			}
		}],
		Cache -> cache,
		Simulation -> updatedSimulation,
		Date -> Now
	], {Download::ObjectDoesNotExist, Download::FieldDoesntExist, Download::NotLinkField}];

	(* Get all the cache and put it together *)
	cacheBall = FlattenCachePackets[{cache, Cases[Flatten[downloadedStuff], PacketP[]]}];

	(* Build the resolved options *)
	resolvedOptionsResult = Check[
		{{resolvedOptions, grindSimulation}, resolvedOptionsTests} = If[gatherTests,
			resolveExperimentKarlFischerTitrationOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
			{resolveExperimentKarlFischerTitrationOptions[samplesWithPreparedSamples, expandedSafeOps, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption, Error::ConflictingUnitOperationMethodRequirements}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentKarlFischerTitration,
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

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	performSimulationQ = MemberQ[output, Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[!performSimulationQ && (returnEarlyBecauseFailuresQ || returnEarlyBecauseOptionsResolverOnly),
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests}],
			Options -> RemoveHiddenOptions[ExperimentKarlFischerTitration, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Build packets with resources *)
	{protocolPacketWithResources, resourcePacketTests} = Which[
		returnEarlyBecauseOptionsResolverOnly || returnEarlyBecauseFailuresQ,
			{$Failed, {}},
		gatherTests,
			karlFischerTitrationResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				collapsedResolvedOptions,
				Cache -> cacheBall,
				Simulation -> grindSimulation,
				Output -> {Result, Tests}
			],
		True,
			{
				karlFischerTitrationResourcePackets[
					samplesWithPreparedSamples,
					templatedOptions,
					resolvedOptions,
					collapsedResolvedOptions,
					Cache -> cacheBall,
					Simulation -> grindSimulation,
					Output -> Result
				],
				{}
			}
	];

	(* If we were asked for a simulation, also return a simulation. *)
	{simulatedProtocol, simulation} = Which[
		MatchQ[protocolPacketWithResources, $Failed], {$Failed, Simulation[]},
		performSimulationQ,
			simulateExperimentKarlFischerTitration[
				protocolPacketWithResources, (* protocolPacket *)
				ToList[samplesWithPreparedSamples],
				resolvedOptions,
				Cache -> cacheBall,
				Simulation -> grindSimulation
			],
		True, {Null, Null}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentKarlFischerTitration, collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> simulation
		}]
	];

	postProcessingOptions = Map[
		If[
			MatchQ[Lookup[resolvedOptions, #], Except[Automatic]],
			# -> Lookup[resolvedOptions, #],
			Nothing
		]&,
		{ImageSample, MeasureVolume, MeasureWeight}
	];

	totalTimesEstimate = If[MatchQ[Lookup[resolvedOptions, Technique], Volumetric],
		(* baseline 1 hour and then a half hour for every sample if we're Volumetric *)
		1 Hour + (Length[mySamples] + Lookup[resolvedOptions, NumberOfStandards]) * 30 Minute,
		(* for coulometric the per-sample time is a lot longer not because the run takes longer (in fact it takes less time) but the Transfers preparing the vials take way longer *)
		1 Hour + (Length[mySamples] + Lookup[resolvedOptions, NumberOfStandards]) * 1 Hour
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	(* If our resource packets failed, we can't upload anything. *)
	result = If[MatchQ[protocolPacketWithResources, $Failed],
		$Failed,
		UploadProtocol[
			protocolPacketWithResources,
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			CanaryBranch -> Lookup[safeOps, CanaryBranch],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			ConstellationMessage -> {Object[Protocol, KarlFischerTitration]},
			Cache -> cacheBall,
			Simulation -> updatedSimulation
		]
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> result,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentKarlFischerTitration, collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> simulation,
		RunTime -> totalTimesEstimate
	}

];

(* ::Subsubsection:: *)
(*allKarlFischerMaterials*)

(* find all the materials specific to Karl Fischer Titration *)
allKarlFischerMaterials[fakeString:_String] := allKarlFischerMaterials[fakeString] = Module[
	{
		getContentsFromName, catalogPackets, karlFischerPackets, materialsCatalogPacket, materialsSubPackets,
		instrumentModels, standards, media, reagentMixtures
	},

	(*Add allKarlFischerMaterials to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`allKarlFischerMaterials];

	(* first get all the catalog packets *)
	catalogPackets = allCatalogPackets["Memoization"];

	(* then get only the packets that are KF-related *)
	karlFischerPackets = Select[catalogPackets, StringContainsQ[Lookup[#, Folder], "Karl Fischer"]&];

	(* Note: if we don't have ANYTHING here, then we're just going to hard code some stuff *)
	(* ideally we're not in this situation, but if we get here and we have nothing in the catalog we're going to trainwreck later *)
	(* this happens most often on the test db, but could also happen on the real db *)
	If[MatchQ[karlFischerPackets, {}],
		Return[Download[{
			(* instrument models *)
			{
				Model[Instrument, KarlFischerTitrator, "Metrohm 851 Titrando with generator electrode without diaphragm"],
				Model[Instrument, KarlFischerTitrator, "Metrohm 901 Titrando"]
			},
			(* standards *)
			{
				Model[Sample, "Milli-Q water"],
				Model[Sample, "HYDRANAL-Water Standard 10.0"],
				Model[Sample, "HYDRANAL - Water Standard 1.0"],
				Model[Sample, "HYDRANAL-Water Standard KF-Oven 150-160 C"],
				Model[Sample, "HYDRANAL Water Standard KF-Oven 220C-230C"],
				Model[Sample, "HYDRANAL-Sodium tartrate dihydrate"],
				Model[Sample, "Lactose Standard 5%"]
			},
			(* media *)
			{
				Model[Sample, "HYDRANAL Methanol Dry"],
				Model[Sample, "HYDRANAL Methanol Rapid"]
			},
			(* reagent mixtures *)
			{
				Model[Sample, "HYDRANAL - Coulomat AG-Oven"],
				Model[Sample, "HYDRANAL Coulomat AG"],
				Model[Sample, "HYDRANAL Composite 5"],
				Model[Sample, "HYDRANAL Composite 5 K"],
				Model[Sample, "HYDRANAL Composite 2"],
				Model[Sample, "HYDRANAL Composite 1"]
			}
		}, Object]]
	];

	(* take the other catalog packet that has the materials in it *)
	materialsCatalogPacket = SelectFirst[karlFischerPackets, MatchQ[Lookup[#, Folder], "Karl Fischer Titration"]&];

	materialsSubPackets = Download[Lookup[materialsCatalogPacket, Contents], Packet[Folder, Contents]];

	(* helper function to get the contents objects from a folder of a given name *)
	getContentsFromName[myCatalogPackets:{ObjectP[Object[Catalog]]...}, myHeaderName_String]:=Download[
		Lookup[
			SelectFirst[myCatalogPackets, MatchQ[Lookup[#, Folder], myHeaderName]&],
			Contents
		],
		Object
	];

	(* get the materials from the different relevant sections *)
	instrumentModels = getContentsFromName[karlFischerPackets, "Karl Fischer Titrators"];
	standards = getContentsFromName[materialsSubPackets, "Standards"];
	media = getContentsFromName[materialsSubPackets, "Titration Media"];
	reagentMixtures = getContentsFromName[materialsSubPackets, "Reagent Mixtures"];

	{
		instrumentModels,
		standards,
		media,
		reagentMixtures
	}
];


(* ::Subsection:: *)
(*resolveExperimentKarlFischerTitrationOptions *)


DefineOptions[
	resolveExperimentKarlFischerTitrationOptions,
	Options :> {HelperOutputOption, CacheOption}
];

resolveExperimentKarlFischerTitrationOptions[myInputSamples:{ObjectP[Object[Sample]]...}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveExperimentKarlFischerTitrationOptions]]:=Module[
	{
		outputSpecification, output, gatherTests, messages, cache, simulation, kfOptions, samplePrepOptions,
		simulatedSamples, resolvedSamplePrepOptions, updatedSimulation, samplePrepTests, sampleDownloads,
		fastAssoc, cacheBall, samplePackets, sampleContainerPacketsWithNulls,
		sampleContainerPackets, discardedSamplePackets, discardedInvalidInputs, grindOptionNames,
		discardedTest, mapThreadFriendlyOptions, resolvedSampleLabel, resolvedSampleContainerLabel, resolvedTemperature,
		resolvedMedium, specifiedInstrument, specifiedTechnique, specifiedKarlFischerReagent,
		specifiedSamplingMethod, specifiedStandard, specifiedGasFlowRate,
		resolvedTechnique, specifiedInstrumentTechnique, resolvedOperator, resolvedPostProcessingOptions,
		nameInvalidBool, nameInvalidOption, nameInvalidTest, optionsForAliquot, resolvedAliquotOptions,
		aliquotTests, kfModelPackets, resolvedInstrument, resolvedOptions, invalidInputs, invalidOptions,
		allTests, resolvedKarlFischerReagent, resolvedSamplingMethod, resolvedGasFlowRate, samplesInStorage,
		validContainerStorageConditionBool, validContainerStorageConditionTests, roundedOptionsAndTests,
		roundedOptionsAssoc, precisionTests, specifiedMappedMedium, specifiedMappedTemperature,
		validContainerStoragConditionInvalidOptions, resolvedStandard, testOrNull, warningOrNull,
		samplingMethodTemperatureMismatchErrors, samplingMethodTemperatureMismatchOptions,
		samplingMethodTemperatureTest, techniqueSamplingMethodError, techniqueSamplingMethodOptions,
		techniqueSamplingMethodTest, instrumentTechniqueMismatchError, instrumentTechniqueMismatchOptions,
		instrumentTechniqueMismatchTest, resolvedInstrumentTechnique, unknownKarlFischerReagentQ,
		unknownKarlFischerReagentWarning, specifiedKarlFischerReagentCompositionPackets, unresolvedName,
		unresolvedEmail, unresolvedOperator, upload, specifiedStandardAmount, standardObjectMass, standardObjectVolume,
		resolvedEmail, specifiedMappedSampleAmount, resolvedStandardAmount,
		standardState, standardAmountMismatchError, standardAmountMismatchOptions, standardAmountMismatchTest,
		resolvedAssayVolume, resolvedAliquotAmount, maxNumSamples, numberOfSamples, tooManySamplesOptions,
		tooManySamplesTest, resolvedSampleAmount, sampleAmountStateErrors, sampleAmountStateOptions, sampleAmountStateTests,
		specifiedKarlFischerReagentContainsI2Qs, specifiedKarlFischerReagentContainsIodideQs, specifiedNumberOfBlanks,
		numberOfStandards, resolvedNumberOfBlanks, numBlanksMismatchQ, numBlanksMismatchOptions, numBlanksMismatchTest,
		resolvedGrind, semiResolvedGrindOptions, nonGrindableSamplesErrors, grindOptionMismatchErrors, grindSimulation,
		grindOptionReplaceRules, grindTrueOptions, grindTrueSamples, grindFalseOptions, mergedGrindTrueOptions,
		resolvedExperimentGrindOptions, experimentGrindTests, resolvedGrindTrueOptions, splitResolvedGrindOptions,
		resolvedMapThreadedGrindOptions, resolvedGrindOptions, nonGrindableSamplesOptions, nonGrindableSamplesTest,
		grindOptionMismatchOptions, grindOptionMismatchTest, resolvedGrindAmount, finalGrindOptionsToPassIn,
		amountToPassToGrind, actuallyGrindQ, specifiedStandardTemperature, resolvedStandardTemperature
	},

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* define these helpers that we'll call all the time below *)
	testOrNull[testDescription_String, passQ:BooleanP]:=If[gatherTests,
		Test[testDescription, True, Evaluate[passQ]],
		Null
	];
	warningOrNull[testDescription_String, passQ:BooleanP]:=If[gatherTests,
		Warning[testDescription, True, Evaluate[passQ]],
		Null
	];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our KF options from our Sample Prep options. *)
	{samplePrepOptions, kfOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options  *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentKarlFischerTitration, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentKarlFischerTitration, myInputSamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Extract the packets that we need from our downloaded cache. *)
	(* need to do this even if we have caching because of the simulation stuff *)
	sampleDownloads = Quiet[Download[
		simulatedSamples,
		{
			Packet[Name, Volume, Mass, State, Status, Container, Tablet, Capsule, SolidUnitWeight],
			Packet[Container[{Object, Model, Contents}]]
		},
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* Combine the cache together *)
	cacheBall = FlattenCachePackets[{
		cache,
		sampleDownloads
	}];

	(* Generate a fast cache association *)
	fastAssoc = makeFastAssocFromCache[cacheBall];

	(* Get the downloaded mess into a usable form *)
	{
		samplePackets,
		sampleContainerPacketsWithNulls
	} = Transpose[sampleDownloads];

	(* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null.
			Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
	sampleContainerPackets = Replace[sampleContainerPacketsWithNulls, {Null -> {}}, 1];

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
	discardedTest = testOrNull["All input samples are not discarded:", MatchQ[discardedInvalidInputs, {}]];

	(* ensure that the quantity options have proper precision *)
	roundedOptionsAndTests = RoundOptionPrecision[
		Association[kfOptions],
		{
			Temperature,
			StandardTemperature,
			GasFlowRate,
			SampleAmount,
			StandardAmount
		},
		{
			10^0 Celsius,
			10^0 Celsius,
			10^-1 Milliliter / Minute,
			{10^0 Milligram, 10^0 Microliter},
			{10^0 Milligram, 10^0 Microliter}
		},
		Output -> If[gatherTests, {Result, Tests}, Result]
	];
	{roundedOptionsAssoc, precisionTests} = If[gatherTests,
		roundedOptionsAndTests,
		{roundedOptionsAndTests, {}}
	];

	(* === Resolve non-index-matching options === *)

	(* pull out the specified singleton options *)
	{
		specifiedInstrument,
		specifiedTechnique,
		specifiedKarlFischerReagent,
		specifiedSamplingMethod,
		specifiedStandard,
		specifiedStandardAmount,
		specifiedStandardTemperature,
		specifiedGasFlowRate,
		specifiedMappedSampleAmount,
		specifiedMappedMedium,
		specifiedMappedTemperature,
		specifiedNumberOfBlanks,
		numberOfStandards,
		unresolvedName,
		unresolvedEmail,
		unresolvedOperator,
		upload
	} = Lookup[
		roundedOptionsAssoc,
		{
			Instrument,
			Technique,
			KarlFischerReagent,
			SamplingMethod,
			Standard,
			StandardAmount,
			StandardTemperature,
			GasFlowRate,
			SampleAmount,
			Medium,
			Temperature,
			NumberOfBlanks,
			NumberOfStandards,
			Name,
			Email,
			Operator,
			Upload
		}
	];

	(* --- Resolve Technique master switch --- *)

	(* get the technique according to the specified instrument *)
	specifiedInstrumentTechnique = Switch[specifiedInstrument,
		ObjectP[Model[Instrument, KarlFischerTitrator]], fastAssocLookup[fastAssoc, specifiedInstrument, TitrationTechnique],
		ObjectP[Object[Instrument, KarlFischerTitrator]], fastAssocLookup[fastAssoc, specifiedInstrument, {Model, TitrationTechnique}],
		_, Null
	];

	(* need to get the composition packets of the specified karl fischer reagent, if they exist *)
	specifiedKarlFischerReagentCompositionPackets = If[MatchQ[specifiedKarlFischerReagent, ObjectP[]],
		With[{compositionModels = fastAssocLookup[fastAssoc, specifiedKarlFischerReagent, Composition][[All, 2]]},
			fetchPacketFromFastAssoc[#, fastAssoc]& /@ compositionModels
		],
		{}
	];

	(* determine if the composition of the specified KF reagent contains the iodine molecule or the iodide anion or neither *)
	(* this is admittedly rather cumbersome, but does rely on fancy molecule matching from wolfram so will be more "correct" and less hardcodey than just...hard coding things *)
	{
		specifiedKarlFischerReagentContainsI2Qs,
		specifiedKarlFischerReagentContainsIodideQs
	} = If[MatchQ[specifiedKarlFischerReagentCompositionPackets, {}],
		{{}, {}},
		Transpose[Map[
			With[{molecule = Lookup[#, Molecule]},
				If[MoleculeQ[molecule],
					{
						MoleculeContainsQ[molecule, $IodineMolecule],
						MoleculeContainsQ[molecule, $IodideAnionMolecule | $HydrogenIodideMolecule]
					},
					{False, False}
				]
			]&,
			specifiedKarlFischerReagentCompositionPackets
		]]
	];

	(* lots of resolution logic here *)
	resolvedTechnique = Which[
		Not[MatchQ[specifiedTechnique, Automatic]], specifiedTechnique,

		(* if we specified an instrument, go with that technique *)
		MatchQ[specifiedInstrumentTechnique, KarlFischerTechniqueP], specifiedInstrumentTechnique,
		(* if KarlFischerReagent is specified, then we don't have to do the rest of the stuff below *)
		(* if the composition of the specified Karl Fischer Reagent has Iodine in it, then go volumetric (Coulometric requires iodide ions) *)
		MemberQ[specifiedKarlFischerReagentContainsI2Qs, True],
			Volumetric,
		(* if it has something with Iodide anions in it then go with coulometric *)
		MemberQ[specifiedKarlFischerReagentContainsIodideQs, True],
			Coulometric,
		(* if sampling method is specified, that takes precedence *)
		MatchQ[specifiedSamplingMethod, Liquid],
			Volumetric,
		MatchQ[specifiedSamplingMethod, Headspace],
			Coulometric,
		(* if NumberOfBlanks is specified, then that's only for Coulometric (since a blank is an empty vial that we only do with the oven/coulometric) *)
		MatchQ[specifiedNumberOfBlanks, GreaterEqualP[1, 1]],
			Coulometric,
		(* if GasFlowRate is specified, then it's only for Coulometric (since that's only for the coulometric oven) *)
		MatchQ[specifiedGasFlowRate, GreaterP[1 Milliliter / Minute]],
			Coulometric,
		(* if any temperature options are specified, then it's only Coulometric since that's the only one with the oven *)
		Or[
			MemberQ[specifiedMappedTemperature, TemperatureP],
			TemperatureQ[specifiedStandardTemperature]
		],
			Coulometric,
		(* otherwise all of these point to volumetric *)
		Or[
			(* if set Temperature to Ambient at any point, then needs to be Volumetric (because Ambient -> SamplingMethod of Liquid -> must not be Coulometric) *)
			MemberQ[specifiedMappedTemperature, Ambient|Null],
			(* if Medium is specified, then we're doing volumetric *)
			MemberQ[specifiedMappedMedium, ObjectP[]],
			(* if we get a liquid standard, then must be Volumetric (solid could still be volumetric or coulometric) *)
			MatchQ[specifiedStandard, ObjectP[Model[Sample]]] && MatchQ[fastAssocLookup[fastAssoc, specifiedStandard, State], Liquid],
			MatchQ[specifiedStandard, ObjectP[Object[Sample]]] && MatchQ[fastAssocLookup[fastAssoc, specifiedStandard, {Model, State}], Liquid],
			(* if GasFlowRate is specified Null, then we must be doing Volumetric because it implies SamplingMethod to be Liquid *)
			NullQ[specifiedGasFlowRate],

			(* If the input samples have a liquid, then still going to go volumetric *)
			MemberQ[Lookup[samplePackets, State], Liquid]
		], Volumetric,

		(* Otherwise all the pieces fall into place and we can pick coulometric *)
		True, Coulometric
	];

	(* --- Resolve the instrument based on technique --- *)

	(* first we need to get all the KF model packets *)
	(* we already memoized this in the main Experiment function so we can just pull it out right now and it's fast *)
	kfModelPackets = Map[
		fetchPacketFromFastAssoc[#, fastAssoc]&,
		First[allKarlFischerMaterials["Memoization"]]
	];

	(* resolve the instrument; if we don't have one specified, pick the first one that matches the resolved Technique *)
	resolvedInstrument = If[MatchQ[specifiedInstrument, ObjectP[]],
		specifiedInstrument,
		FirstCase[kfModelPackets, packet:KeyValuePattern[{TitrationTechnique -> resolvedTechnique}] :> Lookup[packet, Object], Null]
	];

	(* --- Resolve the rest of the singleton options --- *)

	(* hard coded defaults for Volumetric vs Coulometric *)
	resolvedKarlFischerReagent = Which[
		Not[MatchQ[specifiedKarlFischerReagent, Automatic]], specifiedKarlFischerReagent /. karlFischerSymbolsToReagents[],
		(* for these ones, should use the symbol to reagent lookup table to not hard code objects specifically *)
		MatchQ[resolvedTechnique, Coulometric], Lookup[karlFischerSymbolsToReagents[], HydranalCoulomatAGOven],
		True, Lookup[karlFischerSymbolsToReagents[], HydranalComposite5] (* Model[Sample, "HYDRANAL Composite 5"] *)
	];

	(* if the specified karl fischer reagent is not one of the ones in the catalog, throw a warning *)
	unknownKarlFischerReagentQ = With[{catalogReagents = allKarlFischerMaterials["Memoization"][[4]]},
		If[MatchQ[resolvedKarlFischerReagent, ObjectP[Model[Sample]]],
			Not[MatchQ[resolvedKarlFischerReagent, ObjectP[catalogReagents]]],
			Not[MatchQ[fastAssocLookup[fastAssoc, resolvedKarlFischerReagent, Model], ObjectP[catalogReagents]]]
		]
	];
	If[unknownKarlFischerReagentQ && messages && Not[MatchQ[$ECLApplication, Engine]],
		Message[Warning::KarlFischerReagentComponents, ObjectToString[resolvedKarlFischerReagent, Simulation -> updatedSimulation]]
	];
	unknownKarlFischerReagentWarning = warningOrNull["The specified KarlFischerReagent is listed in the ECL Catalog:", Not[unknownKarlFischerReagentQ]];

	(* SamplingMethod defaults to Headspace if Technique is Coulometric, or Temperature is set to anything except Ambient (or the other temperature options), or GasFlowRate is specified *)
	resolvedSamplingMethod = Which[
		Not[MatchQ[specifiedSamplingMethod, Automatic]], specifiedSamplingMethod,
		Or[
			MatchQ[resolvedTechnique, Coulometric],
			MemberQ[specifiedMappedTemperature, TemperatureP],
			MatchQ[specifiedGasFlowRate, GreaterP[0 Milliliter / Minute]]
		], Headspace,
		True, Liquid
	];

	(* GasFlowRate is set to 10 Milliliter / Minute if SamplingMethod is Headspace, or Null otherwise *)
	resolvedGasFlowRate = Which[
		Not[MatchQ[specifiedGasFlowRate, Automatic]], specifiedGasFlowRate,
		MatchQ[resolvedSamplingMethod, Headspace], 10 Milliliter / Minute,
		True, Null
	];

	(* Standard is resolved to water for Volumetric, and different standards for Coulometric depending on the temperature *)
	resolvedStandard = Which[
		Not[MatchQ[specifiedStandard, Automatic]], specifiedStandard,
		MatchQ[resolvedTechnique, Volumetric], Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample,"Milli-Q water"] *)
		MatchQ[specifiedStandardTemperature, GreaterP[200 Celsius]], Model[Sample, "id:8qZ1VWklLMRA"], (* Model[Sample,"HYDRANAL Water Standard KF-Oven 220C-230C"] *)
		TemperatureQ[specifiedStandardTemperature],  Model[Sample, "id:6V0npvqa9RNV"], (* Model[Sample,"HYDRANAL-Water Standard KF-Oven 150-160 C"] *)
		MemberQ[specifiedMappedTemperature, GreaterEqualP[200 Celsius]], Model[Sample, "id:8qZ1VWklLMRA"], (* Model[Sample,"HYDRANAL Water Standard KF-Oven 220C-230C"] *)
		MatchQ[resolvedTechnique, Coulometric], Model[Sample, "id:6V0npvqa9RNV"] (* Model[Sample,"HYDRANAL-Water Standard KF-Oven 150-160 C"] *)
	];

	(* get the standard object mass and volume if it's an Object[Sample] (otherwise Null is fine) *)
	{standardObjectMass, standardObjectVolume} = If[MatchQ[resolvedStandard, ObjectP[Object[Sample]]],
		{
			fastAssocLookup[fastAssoc, resolvedStandard, Mass],
			fastAssocLookup[fastAssoc, resolvedStandard, Volume]
		},
		{Null, Null}
	];

	(* pull out the standard state because we use it a few times below *)
	standardState = fastAssocLookup[fastAssoc, resolvedStandard, State];

	(* if the standard is water, 10 Microliter; otherwise liquid, 1 Milliliter; if the standard is solid, 100 Milligram *)
	resolvedStandardAmount = Which[
		Not[MatchQ[specifiedStandardAmount, Automatic]], specifiedStandardAmount,
		Or[
			MatchQ[resolvedStandard, WaterModelP],
			(* if someone specifies a water object; this is going to be vanishingly rare, but worth writing out explicitly here *)
			And[
				MatchQ[resolvedStandard, ObjectP[Object[Sample]]],
				MatchQ[Download[fastAssocLookup[fastAssoc, resolvedStandard, Model], Object], WaterModelP]
			]
		],
			10 Microliter,
		Or[
			MatchQ[standardState, Liquid],
			VolumeQ[standardObjectVolume]
		],
			1 Milliliter,
		True,
			100 Milligram
	];

	(* resolve the temperature of the standard *)
	resolvedStandardTemperature = Which[
		Not[MatchQ[specifiedStandardTemperature, Automatic]], specifiedStandardTemperature,
		(* if we have the 220 standard, use 220 Celsius *)
		MatchQ[resolvedStandard, ObjectP[Model[Sample, "id:8qZ1VWklLMRA"]]], 220 Celsius, (* Model[Sample,"HYDRANAL Water Standard KF-Oven 220C-230C"] *)
		(* if we have the 150 standard, use 150 Celsius *)
		MatchQ[resolvedStandard, ObjectP[{Model[Sample, "id:6V0npvqa9RNV"], Model[Sample, "id:bq9LA0admxvz"]}]], 150 Celsius, (* Model[Sample,"HYDRANAL-Water Standard KF-Oven 150-160 C"] or Model[Sample, "Lactose Standard 5%"] *)
		(* otherwise, I guess still go with 150 (but want to separate this entry from the previous one for clarity on where the 150 came from with that standard *)
		True, 150 Celsius
	];

	(* if we're doing headspace sampling, then we need 3 blanks; otherwise it must be Null *)
	resolvedNumberOfBlanks = Which[
		Not[MatchQ[specifiedNumberOfBlanks, Automatic]], specifiedNumberOfBlanks,
		MatchQ[resolvedTechnique, Coulometric], 3,
		True, Null
	];

	(* === Resolve index-matching options === *)

	(* NOTE: MAPPING*)
	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentKarlFischerTitration, roundedOptionsAssoc];

	(* want to pull out the grind option names right here because doing it many times in the MapThread could be slow *)
	grindOptionNames = Keys[SafeOptions[GrindSharedOptions]];

	{
		(*1*)resolvedSampleLabel,
		(*2*)resolvedSampleContainerLabel,
		(*3*)resolvedTemperature,
		(*4*)resolvedMedium,
		(*5*)resolvedGrind,
		(*6*)resolvedGrindAmount,
		(*7*)semiResolvedGrindOptions,
		(*8*)samplingMethodTemperatureMismatchErrors,
		(*9*)nonGrindableSamplesErrors,
		(*10*)grindOptionMismatchErrors
	} = Transpose[MapThread[
		Function[{samplePacket, options, sampleContainerPacket},
			Module[
				{
					temperatureMismatchError, specifiedSampleLabel, specifiedSampleContainerLabel,
					specifiedTemperature, specifiedMedium, sampleLabel, sampleContainerLabel, temperature,
					medium, specifiedGrindAmount,
					grindOptions, grind, semiResolvedGrindOptionsPerSample, grindAmount,
					nonGrindableSamplesError, grindOptionMismatchError, fineness, bulkDensity, specifiedSampleAmount,
					preResolvedGrinderType, preResolvedGrindingTime
				},

				(* set error booleans to False here at first *)
				{
					samplingMethodTemperatureMismatchError,
					nonGrindableSamplesError,
					grindOptionMismatchError
				} = ConstantArray[False, 3];

				{
					specifiedSampleLabel,
					specifiedSampleContainerLabel,
					specifiedTemperature,
					specifiedMedium,
					specifiedSampleAmount,
					specifiedGrindAmount
				} = Lookup[
					options,
					{
						SampleLabel,
						SampleContainerLabel,
						Temperature,
						Medium,
						SampleAmount,
						GrindAmount
					}
				];

				(* resolve the sample and container label options *)
				(* NOTE: We use the simulated object IDs here to help generate the labels so we don't spin off a million *)
				(* labels if we have duplicates. *)
				sampleLabel = Which[
					Not[MatchQ[specifiedSampleLabel, Automatic]], specifiedSampleLabel,
					MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All,2]], Lookup[samplePacket, Object]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[samplePacket, Object]],
					True, "Karl Fischer sample " <> StringDrop[Lookup[samplePacket, ID], 3]
				];
				sampleContainerLabel = Which[
					Not[MatchQ[specifiedSampleContainerLabel, Automatic]], specifiedSampleContainerLabel,
					MatchQ[simulation, SimulationP] && MemberQ[Lookup[simulation[[1]], Labels][[All, 2]], Lookup[sampleContainerPacket, Object]],
						Lookup[Reverse /@ Lookup[simulation[[1]], Labels], Lookup[sampleContainerPacket, Object]],
					(* In case we have a container-less sample, use sample ID *)
					True, "Karl Fischer sample container container " <> StringDrop[Lookup[sampleContainerPacket, ID, Lookup[samplePacket, ID]], 3]
				];

				(* resolve the temperature option *)
				temperature = Which[
					Not[MatchQ[specifiedTemperature, Automatic]], specifiedTemperature,
					(* if we have Liquid, this needs to be Ambient *)
					MatchQ[resolvedSamplingMethod, Liquid], Ambient,
					(* if we have the 220 standard, use 220 Celsius *)
					MatchQ[resolvedStandard, ObjectP[Model[Sample, "id:8qZ1VWklLMRA"]]], 220 Celsius, (* Model[Sample,"HYDRANAL Water Standard KF-Oven 220C-230C"] *)
					(* if we have the 150 standard, use 150 Celsius *)
					MatchQ[resolvedStandard, ObjectP[{Model[Sample, "id:6V0npvqa9RNV"], Model[Sample, "id:bq9LA0admxvz"]}]], 150 Celsius, (* Model[Sample,"HYDRANAL-Water Standard KF-Oven 150-160 C"]  or Model[Sample, "Lactose Standard 5%"] *)
					(* If Headspace but no other information, we need to set to 150 C *)
					True, 150 Celsius
				];

				(* resolve the medium to use; if SamplingMethod is Liquid, then pick HYDRANAL Methanol Rapid *)
				medium = Which[
					Not[MatchQ[specifiedMedium, Automatic]], specifiedMedium /. karlFischerSymbolsToMedium[],
					MatchQ[resolvedSamplingMethod, Liquid], Lookup[karlFischerSymbolsToMedium[], MethanolRapid],
					True, Null
				];

				(* === Resolve the Grind options === *)

				(* get the actual grind options that we need to resolve here *)
				grindOptions = KeySelect[options, MemberQ[grindOptionNames, #]&];

				(* resolve the Grind option *)
				grind = Which[
					(* if it's specified, it's specified *)
					Not[MatchQ[Lookup[grindOptions, Grind], Automatic]], Lookup[grindOptions, Grind],
					(* if any of the other grind options are specified to anything besides Null|False|Automatic, then resolve to True *)
					Not[MatchQ[Flatten[Values[grindOptions]], {(False|Automatic|Null)..}]], True,
					(* if the sample is a tablet and is not a capsule then has to be True *) (*TODO capsule handling a little shaky; need to get ahold of some of their capsule samples to understand what to do *)
					MatchQ[Lookup[samplePacket, {Tablet, Capsule}], {True, Except[True]}], True,
					(* otherwise this is False *)
					True, False
				];

				(* resolve the GrindAmount option *)
				(* if the specified SampleAmount is <= 3x the SolidUnitWeight, then we're going to do 4; otherwise we do 4 tablets in addition to the number required to reach the specified mass *)
				(* could put this under option control, but I think this is probably ok for now *)
				grindAmount = Which[
					(* if it's specified, go with that *)
					Not[MatchQ[specifiedGrindAmount, Automatic]], specifiedGrindAmount,
					(* if Grind is False, then we're doing Null *)
					Not[grind], Null,
					(* if sample amount is not specified, then go with 4 *)
					MatchQ[specifiedSampleAmount, Automatic], 4,
					(* if SolidUnitWeight is not a mass, then we have to stick with 4 *)
					Not[MassQ[Lookup[samplePacket, SolidUnitWeight]]], 4,
					(* if sample amount is specified and the amount is less than 3x the SolidUnitWeight, then go with 4 as well *)
					specifiedSampleAmount <= 3* Lookup[samplePacket, SolidUnitWeight], 4,
					(* otherwise, do 4 more than the quotient of amount and solid unit weight  *)
					True, Quotient[specifiedSampleAmount, Lookup[samplePacket, SolidUnitWeight]] + 4
				];

				(* resolve the Fineness and BulkDensity options because they can't be Automatic in ExperimentGrind *)
				(* just going to put them together with the other smei-resolved options because we need to combine them later anyway *)
				(* default of 1 Millimeter for fineness and 1 g/mL for bulk density *)
				fineness = Which[
					Not[MatchQ[Lookup[grindOptions, Fineness], Automatic]], Lookup[grindOptions, Fineness],
					grind, 1 Millimeter,
					True, Null
				];
				bulkDensity = Which[
					Not[MatchQ[Lookup[grindOptions, BulkDensity], Automatic]], Lookup[grindOptions, BulkDensity],
					grind, 1 Gram / Milliliter,
					True, Null
				];

				(* pre-resolve the GrinderType option becuase we want to prefer the KnifeMill for our purposes here *)
				preResolvedGrinderType = Which[
					(* if it's specified, then just go with that *)
					Not[MatchQ[Lookup[grindOptions, GrinderType], Automatic]], Lookup[grindOptions, GrinderType],
					(* if Grind is False, we can just set this to Null *)
					Not[grind], Null,
					(* if Grinder, GrindingBead, or NumberOfGrindingBeads are set to values, then just leave it as Automatic because we can't overwrite to KnifeMill *)
					Or[
						MatchQ[Lookup[grindOptions, Grinder], Automatic|Null],
						MatchQ[Lookup[grindOptions, GrindingBead], Automatic|Null],
						MatchQ[Lookup[grindOptions, NumberOfGrindingBeads], Automatic|Null]
					], Automatic,
					True, KnifeMill
				];

				(* knife mill needs to go longer than the default for these pills so pre-resolve it to be higher *)
				preResolvedGrindingTime = If[MatchQ[preResolvedGrinderType, KnifeMill] && MatchQ[Lookup[grindOptions, GrindingTime], ListableP[Automatic]],
					180 Second,
					Lookup[grindOptions, GrindingTime]
				];

				(* semi-resolve the grind options: if Grind is False, then all Automatics become Null *)
				(* this is admittedly a little cumbersome way to do it; I want to remove the Grind option and add the Fineness/BulkDensity options from above *)
				semiResolvedGrindOptionsPerSample = With[{keyDroppedOptions = Join[KeyDrop[grindOptions, Grind], <|Fineness -> fineness, BulkDensity -> bulkDensity, GrinderType -> preResolvedGrinderType, GrindingTime -> preResolvedGrindingTime|>]},
					If[grind,
						keyDroppedOptions,
						keyDroppedOptions /. {Automatic -> Null}
					]
				];

				(* flip the error switch if Grind is True but we're not dealing with a tablet *)
				nonGrindableSamplesError = grind && Not[MatchQ[Lookup[samplePacket, {State, Tablet, Capsule}], {Solid, True, Except[True]}]];

				(* flip error switch if Grind is set to False and we have values in the specified options *)
				grindOptionMismatchError = And[
					Not[grind],
					Or[
						Not[MatchQ[Flatten[Values[semiResolvedGrindOptionsPerSample]], {(Automatic|False|Null)..}]],
						Not[NullQ[grindAmount]]
					]
				];

				(* flip error switch if Temperature is Ambient and SamplingMethod is Headspace OR if Temperature is Auto/Temperature and SamplingMethod is Liquid *)
				samplingMethodTemperatureMismatchError = Or[
					MatchQ[temperature, Ambient|Null] && MatchQ[resolvedSamplingMethod, Headspace],
					MatchQ[temperature, TemperatureP | Auto] && MatchQ[resolvedSamplingMethod, Liquid]
				];

				{
					(*1*)sampleLabel,
					(*2*)sampleContainerLabel,
					(*3*)temperature,
					(*4*)medium,
					(*5*)grind,
					(*6*)grindAmount,
					(*7*)semiResolvedGrindOptionsPerSample,
					(*8*)samplingMethodTemperatureMismatchError,
					(*9*)nonGrindableSamplesError,
					(*10*)grindOptionMismatchError
				}
			]
		],
		{samplePackets, mapThreadFriendlyOptions, sampleContainerPackets}
	]];

	(* make replace rules for the Grind options that have different names (Grinder -> Instrument, GrindingTime -> Time) *)
	grindOptionReplaceRules = {
		Grinder -> Instrument,
		GrindingTime -> Time
	};

	(* combine the Grind option with the nonGrindableSamplesErrors or grindOptionMismatchErrors *)
	(* basically, if we already know we can't grind things then we don't want to pass it down into ExperimentGrind to get further problems *)
	actuallyGrindQ = MapThread[
		Function[{grind, nonGrindableSampleError, grindOptionMismatchError},
			grind && Not[nonGrindableSampleError] && Not[grindOptionMismatchError]
		],
		{resolvedGrind, nonGrindableSamplesErrors, grindOptionMismatchErrors}
	];

	(* pick the samples and specified options for if Grind is True *)
	(* note that we are using myInputSamples here and NOT the simulated samples.  This is important because we use the simulation later on *)
	grindTrueOptions = KeyReplace[
		PickList[semiResolvedGrindOptions, actuallyGrindQ],
		grindOptionReplaceRules
	];
	grindTrueSamples = PickList[myInputSamples, actuallyGrindQ];

	(* also want to get the grind false options for when we're reassembling things again *)
	grindFalseOptions = PickList[semiResolvedGrindOptions, actuallyGrindQ, False];

	(* un-split the options so that they go into ExperimentGrind properly *)
	(* note that all Grind options are index matching here so we don't have to do any fancy shenanigans when joining back together *)
	(* (if we had any singleton options then we would have to not simply join but we don't here) *)
	mergedGrindTrueOptions = Normal[Merge[grindTrueOptions, Join], Association];

	(* determine the actual amount; need to round to the nearest 0.1 mg *)
	amountToPassToGrind = MapThread[
		With[{solidUnitWeight = fastAssocLookup[fastAssoc, #1, SolidUnitWeight]},
			If[MassQ[solidUnitWeight],
				SafeRound[solidUnitWeight * #2, 0.1 Milligram],
				#2
			]
		]&,
		{grindTrueSamples, PickList[resolvedGrindAmount, actuallyGrindQ, True]}
	];

	(* add the GrindAmount option as the Amount, though for now we need to convert it to a Mass *)
	(* if we have no grind options then this will be a weird {Amount -> {}} that we don't use below, but I think that's not too big a deal *)
	(* TODO we should change ExperimentGrind to not require this in the future *)
	finalGrindOptionsToPassIn = Append[
		mergedGrindTrueOptions,
		Amount -> amountToPassToGrind
	];

	(* resolve all Grind options (assuming we have any Grind -> True cases) *)
	{resolvedExperimentGrindOptions, grindSimulation, experimentGrindTests} = Which[
		MatchQ[grindTrueSamples, {}], {{}, updatedSimulation, {}},
		gatherTests,
			ExperimentGrind[
				grindTrueSamples,
				Join[
					finalGrindOptionsToPassIn,
					{
						Output -> {Options, Simulation, Tests},
						Simulation -> updatedSimulation
					}
				]
			],
		True,
			Append[
				ExperimentGrind[
					grindTrueSamples,
					Join[
						finalGrindOptionsToPassIn,
						{
							Output -> {Options, Simulation},
							Simulation -> updatedSimulation
						}
					]
				],
				{}
			]
	];

	(* get only the options relevant for our experiment (and replace the names of the options) *)
	resolvedGrindTrueOptions = KeyTake[
		KeyReplace[Association[resolvedExperimentGrindOptions], Reverse /@ grindOptionReplaceRules],
		grindOptionNames
	];

	(* split the options to MapThread friendly ones again that we'll re-merge shortly *)
	splitResolvedGrindOptions = If[MatchQ[resolvedGrindTrueOptions, <||>],
		{},
		OptionsHandling`Private`mapThreadOptions[ExperimentKarlFischerTitration, resolvedGrindTrueOptions]
	];

	(* get the Grind True and False options back into the correct order *)
	resolvedMapThreadedGrindOptions = RiffleAlternatives[splitResolvedGrindOptions, grindFalseOptions, actuallyGrindQ];

	(* get all the resolved grind options as a list nice and merged up *)
	resolvedGrindOptions = Normal[
		Merge[resolvedMapThreadedGrindOptions, Join],
		Association
	];

	(* Adjust the email option based on the upload option *)
	resolvedEmail = If[!MatchQ[unresolvedEmail, Automatic],
		unresolvedEmail,
		upload && MemberQ[output, Result]
	];

	(* Resolve the operator option *)
	resolvedOperator = If[NullQ[unresolvedOperator], $BaselineOperator, unresolvedOperator];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameInvalidBool = StringQ[unresolvedName] && TrueQ[DatabaseMemberQ[Append[Object[Protocol, KarlFischerTitration], unresolvedName]]];

	(* NOTE: unique *)
	(* If the name is invalid, will add it to the list if invalid options later *)
	nameInvalidOption = If[nameInvalidBool && messages,
		(
			Message[Error::DuplicateName, Object[Protocol, KarlFischerTitration]];
			{Name}
		),
		{}
	];
	nameInvalidTest = testOrNull["The specified Name is unique:", Not[nameInvalidBool]];

	(* throw a message if sampling method and temperature don't agree *)
	samplingMethodTemperatureMismatchOptions = If[MemberQ[samplingMethodTemperatureMismatchErrors, True] && messages,
		(
			Message[
				Error::SamplingMethodMismatch,
				resolvedSamplingMethod,
				PickList[resolvedTemperature, samplingMethodTemperatureMismatchErrors],
				ObjectToString[PickList[myInputSamples, samplingMethodTemperatureMismatchErrors], Simulation -> updatedSimulation]
			];
			{SamplingMethod, Temperature}
		),
		{}
	];
	samplingMethodTemperatureTest = testOrNull["If SamplingMethod is Volumetric, Temperature is Ambient; if SamplingMethod is Coulometric, Temperature is a specific value or Auto:", MatchQ[samplingMethodTemperatureMismatchErrors, {False..}]];

	(* throw a message if Technique is Coulometric and SamplingMethod is Liquid *)
	techniqueSamplingMethodError = Or[
		MatchQ[resolvedTechnique, Coulometric] && MatchQ[resolvedSamplingMethod, Liquid],
		MatchQ[resolvedTechnique, Volumetric] && MatchQ[resolvedSamplingMethod, Headspace]
	];
	techniqueSamplingMethodOptions = If[techniqueSamplingMethodError && messages,
		(
			Message[Error::TechniqueSamplingMethodMismatch, resolvedTechnique, resolvedSamplingMethod];
			{Technique, SamplingMethod}
		),
		{}
	];
	techniqueSamplingMethodTest = testOrNull["If Technique is Coulometric, then SamplingMethod is Headspace; if Technique is Volumetric, then SamplingMethod is Liquid:", Not[techniqueSamplingMethodError]];

	(* throw a message if Technique doesn't match TitrationTechnique of the instrument *)
	resolvedInstrumentTechnique = If[MatchQ[resolvedInstrument, ObjectP[Object[Instrument]]],
		fastAssocLookup[fastAssoc, resolvedInstrument, {Model, TitrationTechnique}],
		fastAssocLookup[fastAssoc, resolvedInstrument, TitrationTechnique]
	];
	instrumentTechniqueMismatchError = Not[MatchQ[resolvedTechnique, resolvedInstrumentTechnique]];
	instrumentTechniqueMismatchOptions = If[instrumentTechniqueMismatchError && messages,
		(
			Message[
				Error::InstrumentTechniqueMismatch,
				resolvedTechnique,
				ObjectToString[resolvedInstrument, Simulation -> updatedSimulation],
				resolvedInstrumentTechnique
			];
			{Technique, Instrument}
		),
		{}
	];
	instrumentTechniqueMismatchTest = testOrNull["Techinque matches the TitrationTechnique field of the Instrument:", Not[instrumentTechniqueMismatchError]];

	(* throw a message if Standard is a solid and StandardAmount was a volume, or Standard is a Liquid and StandardAmount is a mass and we don't have mass in the liquid *)
	standardAmountMismatchError = Or[
		MatchQ[standardState, Solid] && VolumeQ[resolvedStandardAmount],
		MatchQ[standardState, Liquid] && MassQ[resolvedStandardAmount] && Not[MassQ[standardObjectMass]]
	];
	standardAmountMismatchOptions = If[standardAmountMismatchError && messages,
		(
			Message[
				Error::StandardAmountMismatch,
				resolvedStandardAmount,
				standardState,
				(* the text of the message says "Please set StandardAmount to a `3` at this point; if it's a volume, we want the string to be "mass" and vice versa *)
				If[VolumeQ[resolvedStandardAmount], "mass", "volume"]
			];
			{Standard, StandardAmount}
		),
		{}
	];
	standardAmountMismatchTest = testOrNull["StandardAmount is a Volume if Standard is a liquid, and StandardAmount is a Mass if Standard is a Solid:", Not[standardAmountMismatchError]];

	(* throw a message if we're doing Blanks and Volumetric *)
	numBlanksMismatchQ = Or[
		NullQ[resolvedNumberOfBlanks] && MatchQ[resolvedTechnique, Coulometric],
		MatchQ[resolvedNumberOfBlanks, GreaterEqualP[1, 1]] && MatchQ[resolvedTechnique, Volumetric]
	];
	numBlanksMismatchOptions = If[numBlanksMismatchQ && messages,
		(
			Message[Error::NumberOfBlanksMismatch, resolvedNumberOfBlanks, resolvedTechnique];
			{NumberOfBlanks, Technique, SamplingMethod}
		),
		{}
	];
	numBlanksMismatchTest = testOrNull["NumberOfBlanks is specified if and only if Technique is Coulometric:", Not[numBlanksMismatchQ]];

	(* throw a message if we have non-grindable samples *)
	nonGrindableSamplesOptions = If[MemberQ[nonGrindableSamplesErrors, True] && messages,
		(
			Message[
				Error::NonGrindableSamples,
				ObjectToString[PickList[simulatedSamples, nonGrindableSamplesErrors], Simulation -> updatedSimulation]
			];
			{Grind}
		),
		{}
	];
	nonGrindableSamplesTest = testOrNull["Grind is set to True if and only if the sample is a Tablet:", Not[MemberQ[nonGrindableSamplesErrors, True]]];

	(* throw a message if we have grind options specified and Grind is set to False *)
	grindOptionMismatchOptions = If[MemberQ[grindOptionMismatchErrors, True] && messages,
		(
			Message[Error::GrindOptionMismatch];
			Flatten[{Grind, Keys[semiResolvedGrindOptions]}]
		),
		{}
	];
	grindOptionMismatchTest = testOrNull["If Grind is set to False, no other Grind options are specified:", Not[MemberQ[grindOptionMismatchErrors, True]]];

	(* === Resolve the aliquot options === *)

	(* Add the sample prep options to the options being passed into resolveAliquotOptions *)
	optionsForAliquot = ReplaceRule[myOptions, resolvedSamplePrepOptions];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions, aliquotTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentKarlFischerTitration,
			myInputSamples,
			simulatedSamples,
			optionsForAliquot,
			RequiredAliquotAmounts -> Null,
			RequiredAliquotContainers -> Automatic,
			AllowSolids -> True,
			MinimizeTransfers -> True,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> {Result, Tests}
		],
		{resolveAliquotOptions[
			ExperimentKarlFischerTitration,
			myInputSamples,
			simulatedSamples,
			optionsForAliquot,
			RequiredAliquotAmounts -> Null,
			RequiredAliquotContainers -> Automatic,
			AllowSolids -> True,
			MinimizeTransfers -> True,
			Cache -> cacheBall,
			Simulation -> updatedSimulation,
			Output -> Result
		], {}}
	];

	(* pull out the resolved assay volume and AliquotAmount *)
	resolvedAssayVolume = Lookup[resolvedAliquotOptions, AssayVolume];
	resolvedAliquotAmount = Lookup[resolvedAliquotOptions, AliquotAmount];

	{
		resolvedSampleAmount,
		sampleAmountStateErrors
	} = Transpose[MapThread[
		Function[{samplePacket, options, assayVolume, aliquotAmount},
			Module[
				{sampleAmountStateError, state, sampleAmount, mass, volume, roundedSampleAmount},

				{mass, volume} = Lookup[samplePacket, {Mass, Volume}];

				(* error boolean *)
				sampleAmountStateError = False;

				(* figure out what the state of the sample is going to be after aliquoting *)
				(* if AssayVolume is populated, we're going to have a liquid *)
				(* if AssayVolume is _not_ populated and we have a liquid item, then it's still going to be liquid after aliquoting *)
				(* if AssayVolume is _not_ populated and we have a solid item, then it's still going to be solid after aliquoting *)
				state = Which[
					VolumeQ[assayVolume], Liquid,
					VolumeQ[volume], Liquid,
					True, Solid
				];

				(* resolve the SampleAmount based on what the state is that we got above *)
				sampleAmount = Which[
					(* if SampleAmount was specified directly, then just go with that *)
					MatchQ[Lookup[options, SampleAmount], Except[Automatic]], Lookup[options, SampleAmount],
					(* if we're dealing with a solid but not aliquoting, take the smaller of 5 milligram or the current mass of the sample (and do a DeleteCases of Null here in case Mass is Null; there is going to be error checking there anyway so just make sure it doesn't crash here) *)
					MatchQ[state, Solid] && NullQ[aliquotAmount], Min[DeleteCases[{100 Milligram, mass}, Null]],
					(* if we're dealing with a solid and aliquoting, take the smaller of 100 milligram or the aliquot amount *)
					MatchQ[state, Solid], Min[{100 Milligram, aliquotAmount}],
					(* if we're dealing with a liquid but not aliquoting, take the smaller of 1 Milliliter or the current volume of the sample (and do the same Null trick as above) *)
					MatchQ[state, Liquid] && NullQ[assayVolume], Min[DeleteCases[{1 Milliliter, volume}, Null]],
					(* if we're dealing with a liquid and aliquoting, take the smaller of 1 Milliliter or the assay volume *)
					MatchQ[state, Liquid], Min[{1 Milliliter, assayVolume}]
				];

				roundedSampleAmount = Which[
					NullQ[sampleAmount], Null,
					MatchQ[state, Solid], RoundOptionPrecision[sampleAmount, 10^-1 Milligram],
					MatchQ[state, Liquid], RoundOptionPrecision[sampleAmount, 10^-1 Microliter],
					True, sampleAmount
				];

				(* flip the sampleAmountStateError switch if the resolved sample amount doesn't correspond to the sample's state (if it is Null that is fine; we will have thrown errors elsewhere) *)
				sampleAmountStateError = Or[
					MatchQ[state, Solid] && Not[MatchQ[roundedSampleAmount, MassP]],
					MatchQ[state, Liquid] && Not[MatchQ[roundedSampleAmount, VolumeP]]
				];

				{
					sampleAmount,
					sampleAmountStateError
				}

			]
		],
		{samplePackets, mapThreadFriendlyOptions, resolvedAssayVolume, resolvedAliquotAmount}
	]];

	(* throw an error if the state and resolved SampleAmount don't agree with each other *)
	sampleAmountStateOptions = If[MemberQ[sampleAmountStateErrors, True] && messages,
		(
			Message[Error::SampleAmountStateConflict, ObjectToString[PickList[myInputSamples, sampleAmountStateErrors], Simulation -> updatedSimulation], ObjectToString[PickList[resolvedSampleAmount, sampleAmountStateErrors]]];
			{SampleAmount}
		),
		{}
	];
	sampleAmountStateTests = testOrNull["SampleAmount's units agree with the state of the input samples (solids have mass, liquids have volume):", MatchQ[sampleAmountStateErrors, {False..}]];

	(* throw an error for too many samples + blanks + standards *)
	(* for Volumetric this is rather arbitrary and I'm setting to 20 *)
	(* for Coulometric this is 35 *)
	{
		maxNumSamples,
		numberOfSamples
	} = If[MatchQ[resolvedTechnique, Volumetric],
		{
			20,
			numberOfStandards + Length[myInputSamples]
		},
		{
			35,
			1 + resolvedNumberOfBlanks + numberOfStandards + Length[myInputSamples]
		}
	];
	tooManySamplesOptions = If[numberOfSamples > maxNumSamples && messages,
		(
			Message[Error::TooManySamplesKarlFischerTitration, maxNumSamples, numberOfSamples];
			{NumberOfStandards, NumberOfBlanks}
		),
		{}
	];
	tooManySamplesTest = testOrNull["The number of samples, standards, and blanks is less than or equal to " <> ToString[maxNumSamples], ":", Not[numberOfSamples > maxNumSamples]];


	(* gather all the resolved options together *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Instrument -> resolvedInstrument,
			Technique -> resolvedTechnique,
			KarlFischerReagent -> resolvedKarlFischerReagent,
			SamplingMethod -> resolvedSamplingMethod,
			GasFlowRate -> resolvedGasFlowRate,
			SampleAmount -> resolvedSampleAmount,
			Standard -> resolvedStandard,
			StandardAmount -> resolvedStandardAmount,
			StandardTemperature -> resolvedStandardTemperature,
			SampleLabel -> resolvedSampleLabel,
			SampleContainerLabel -> resolvedSampleContainerLabel,
			Temperature -> resolvedTemperature,
			Medium -> resolvedMedium,
			NumberOfBlanks -> resolvedNumberOfBlanks,
			NumberOfStandards -> numberOfStandards,
			Grind -> resolvedGrind,
			GrindAmount -> resolvedGrindAmount,
			resolvedGrindOptions,
			(* boilerplate options from shared code *)
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			Operator -> resolvedOperator,
			Email -> resolvedEmail
		}]
	];

	(* get whether the SamplesInStorage option is ok *)
	samplesInStorage = Lookup[myOptions, SamplesInStorageCondition];

	(* Check whether the samples are ok *)
	{validContainerStorageConditionBool, validContainerStorageConditionTests} = If[gatherTests,
		ValidContainerStorageConditionQ[myInputSamples, samplesInStorage, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{ValidContainerStorageConditionQ[myInputSamples, samplesInStorage, Cache -> cacheBall, Simulation -> updatedSimulation, Output -> Result], {}}
	];
	validContainerStoragConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];


	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs}]];

	(* Gather all the invalid options together *)
	invalidOptions = DeleteDuplicates[Flatten[{
		nameInvalidOption,
		validContainerStoragConditionInvalidOptions,
		samplingMethodTemperatureMismatchOptions,
		techniqueSamplingMethodOptions,
		instrumentTechniqueMismatchOptions,
		standardAmountMismatchOptions,
		sampleAmountStateOptions,
		numBlanksMismatchOptions,
		grindOptionMismatchOptions,
		nonGrindableSamplesOptions,
		tooManySamplesOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Get all the tests together *)
	allTests = Cases[Flatten[{
		samplePrepTests,
		discardedTest,
		nameInvalidTest,
		aliquotTests,
		validContainerStorageConditionTests,
		samplingMethodTemperatureTest,
		techniqueSamplingMethodTest,
		instrumentTechniqueMismatchTest,
		unknownKarlFischerReagentWarning,
		standardAmountMismatchTest,
		sampleAmountStateTests,
		numBlanksMismatchTest,
		grindOptionMismatchTest,
		nonGrindableSamplesTest,
		tooManySamplesTest
	}], TestP];

	(* pending to add updatedExperimentKarlFischerTitrationSimulation to the Result *)
	(* return our resolved options and/or tests *)
	(* also need to return our simulation here since we pass it down to the simulation function proper *)
	outputSpecification /. {Result -> {resolvedOptions, grindSimulation}, Tests -> allTests}

];

(* ::Subsection:: *)
(*karlFischerTitrationResourcePackets*)

DefineOptions[
	karlFischerTitrationResourcePackets,
	Options :> {
		SimulationOption,
		CacheOption,
		HelperOutputOption
	}
];

karlFischerTitrationResourcePackets[
	mySamples:{ObjectP[Object[Sample]]..},
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myCollapsedResolvedOptions:{___Rule},
	ops:OptionsPattern[karlFischerTitrationResourcePackets]
]:=Module[
	{
		unresolvedOptionsNoHidden, resolvedOptionsNoHidden, safeOps, outputSpecification, output, gatherTests, messages,
		cache, simulation, fastAssoc, resolvedInstrument, resolvedTechnique, resolvedKarlFischerReagent,
		resolvedSamplingMethod, resolvedTemperature,
		resolvedMedium, resolvedStandard, resolvedGasFlowRate, fastAssocKeysIDOnly,
		samplePackets, containerPackets, containers, sampleResources, sampleContainerResources, allResourceBlobs,
		fulfillable, frqTests, previewRule, optionsRule, testsRule, resultRule, resolvedGrind, conditioningHeadspaceVialResource,
		instrumentResource, mediumResources, karlFischerReagentResource, standardResource, headspaceVialResources,
		standardHeadspaceVialResources, protocolID, protocolPacket,
		blankHeadspaceVialResources, resolvedGrinderType, resolvedGrinder, resolvedFineness, systemPrepHeadspaceVialResource,
		resolvedBulkDensity, resolvedGrindingContainer, resolvedGrindingBead, resolvedNumberOfGrindingBeads,
		resolvedGrindingRate, resolvedGrindingTime, resolvedNumberOfGrindingSteps, resolvedCoolingTime, sampleSyringeResources,
		resolvedGrindingProfile, resolvedSampleLabel, resolvedSampleContainerLabel, talliedMedia, syringeRackResource,
		mediumResourcesNoDupes, operator, standardSyringeResources, standardNeedleResources, volumetricSolidStandardQ,
		resolvedNumberOfStandards, resolvedNumberOfBlanks, resolvedSampleAmount, resolvedGrindAmount, resolvedStandardAmount,
		standardSyringeToUse, sampleSyringesToUse, molecularSieveResource, standardWeighingFunnelResources,
		spatulaPackets, standardSpatula, sampleSpatulas, standardSpatulaResources, standardPacket, microSyringeResource,
		waterStandardQ, waterSampleQs, potentialNeedleToUse, sampleNeedleResources, potentialWeighingFunnelToUse,
		sampleWeighingFunnelResources, sampleSpatulaResources, standardSpatulaCountedQ, sampleSpatulaCountedQs,
		countedSpatulas, spatulaCountRules, ampouleOpenerResource, needlePackets, weighingFunnelPackets, systemPrepSyringeResource,
		syringePackets, standardNeedleToUse, sampleNeedlesToUse, standardWeighingFunnelToUse, expectedStandardEmptyWeight,
		expectedSampleEmptyWeight, sampleWeighingFunnelsToUse, expectedStandardTareWeight, expectedSampleTareWeight,
		standardAmountAsMass, sampleAmountsAsMass, standardSyringeWeightToUse, sampleSyringeWeightsToUse,
		expectedStandardWeight, expectedSampleWeight, standardTolerance, sampleTolerance, molecularSieveSpatulaResource,
		standardTareTolerance, sampleTareTolerance, replacementSeptumResource, systemPrepNeedleResource,
		systemPrepWeighingFunnelResource, resolvedStandardTemperature
	},

	(* Get the collapsed unresolved index-matching options that don't include hidden options *)
	unresolvedOptionsNoHidden = RemoveHiddenOptions[ExperimentKarlFischerTitration, myUnresolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentKarlFischerTitration,
		RemoveHiddenOptions[ExperimentKarlFischerTitration, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Get the safe options for this function *)
	safeOps = SafeOptions[karlFischerTitrationResourcePackets, ToList[ops]];

	(* Pull out the output options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Decide if we are gathering tests or throwing messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* Lookup helper options *)
	{cache, simulation} = Lookup[safeOps, {Cache, Simulation}];

	(* going to combine these values with the cache we already have *)
	{
		spatulaPackets,
		needlePackets,
		weighingFunnelPackets,
		syringePackets
	} = kfMeasuringToolPackets["Memoization"];

	(* Make the fast association *)
	fastAssoc = makeFastAssocFromCache[FlattenCachePackets[{cache, spatulaPackets, needlePackets, weighingFunnelPackets, syringePackets}]];

	(* Pull out the packets from the fast assoc *)
	fastAssocKeysIDOnly = Select[Keys[fastAssoc], StringMatchQ[Last[#], ("id:"~~___)]&];
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;
	containerPackets = fastAssocPacketLookup[fastAssoc, #, Container]& /@ mySamples;
	containers = Lookup[containerPackets, Object];

	(* --- Make all the resources needed in the experiment --- *)

	(* -- Generate resources for the SamplesIn -- *)

	(* pull out fields that need to be in the protocol object *)
	{
		(*1*)resolvedSampleLabel,
		(*2*)resolvedSampleContainerLabel,
		(*3*)resolvedInstrument,
		(*4*)resolvedTechnique,
		(*5*)resolvedKarlFischerReagent,
		(*6*)resolvedSamplingMethod,
		(*7*)resolvedSampleAmount,
		(*8*)resolvedTemperature,
		(*9*)resolvedMedium,
		(*10*)resolvedStandard,
		(*11*)resolvedStandardAmount,
		(*12*)resolvedStandardTemperature,
		(*13*)resolvedNumberOfStandards,
		(*14*)resolvedNumberOfBlanks,
		(*15*)resolvedGasFlowRate,
		(*16*)resolvedGrind,
		(*17*)operator,
		(*18*)resolvedGrinderType,
		(*19*)resolvedGrinder,
		(*20*)resolvedFineness,
		(*21*)resolvedBulkDensity,
		(*22*)resolvedGrindingContainer,
		(*23*)resolvedGrindingBead,
		(*24*)resolvedNumberOfGrindingBeads,
		(*25*)resolvedGrindingRate,
		(*26*)resolvedGrindingTime,
		(*27*)resolvedNumberOfGrindingSteps,
		(*28*)resolvedCoolingTime,
		(*29*)resolvedGrindingProfile,
		(*30*)resolvedGrindAmount
	} = Lookup[
		myResolvedOptions,
		{
			(*1*)SampleLabel,
			(*2*)SampleContainerLabel,
			(*3*)Instrument,
			(*4*)Technique,
			(*5*)KarlFischerReagent,
			(*6*)SamplingMethod,
			(*7*)SampleAmount,
			(*8*)Temperature,
			(*9*)Medium,
			(*10*)Standard,
			(*11*)StandardAmount,
			(*12*)StandardTemperature,
			(*13*)NumberOfStandards,
			(*14*)NumberOfBlanks,
			(*15*)GasFlowRate,
			(*16*)Grind,
			(*17*)Operator,
			(*18*)GrinderType,
			(*19*)Grinder,
			(*20*)Fineness,
			(*21*)BulkDensity,
			(*22*)GrindingContainer,
			(*23*)GrindingBead,
			(*24*)NumberOfGrindingBeads,
			(*25*)GrindingRate,
			(*26*)GrindingTime,
			(*27*)NumberOfGrindingSteps,
			(*28*)CoolingTime,
			(*29*)GrindingProfile,
			(*30*)GrindAmount
		}
	];

	(* get the packet for the resolved standard *)
	standardPacket = fetchPacketFromFastAssoc[resolvedStandard, fastAssoc];

	(* Prepare the sample resources *)
	(* if we're grinding/have a Tablet, then get the number of tablets to use; otherwise just put the specified value *)
	sampleResources = MapThread[
		Function[{sample, label, grind, amount, numTablet},
			Resource[Sample -> sample, Name -> label, Amount -> If[grind, numTablet, amount]]
		],
		{mySamples, resolvedSampleLabel, resolvedGrind, resolvedSampleAmount, resolvedGrindAmount}
	];
	sampleContainerResources = MapThread[
		Resource[Sample -> #1, Name -> #2]&,
		{containers, resolvedSampleContainerLabel}
	];

	(* make the instrument resource *)
	(* we can say we're going to take 15 minutes per sample + 2 hour overhead *)
	instrumentResource = Resource[
		Instrument -> resolvedInstrument,
		Time -> 2 Hour + Length[mySamples] * 15 Minute
	];

	(* reserve the medium.  It's not really dependent on the number of samples; we basically just refill it at the end of the protocol to 50mL *)
	(* doing this so we don't request 5 different bottles of the same thing *)
	talliedMedia = Tally[DeleteCases[resolvedMedium, Null]];
	mediumResourcesNoDupes = Map[
		Resource[
			Sample -> #[[1]],
			Amount -> 50 Milliliter,
			Name -> ToString[#[[1]]]
		]&,
		talliedMedia
	];
	mediumResources = resolvedMedium /. AssociationThread[talliedMedia[[All, 1]], mediumResourcesNoDupes];

	(* reserve the KarlFischerReagent *)
	(* in this case again not sure how much to actually reserve; in this case just going to say 100 mL and TODO update this in the future *)
	karlFischerReagentResource = Resource[
		Sample -> resolvedKarlFischerReagent,
		Amount -> 100 Milliliter
	];

	(* reserve the standard *)
	(* if it's water, we need to specify the container we're putting it in (and also if we have the crazy tiny 10 microliters, we want to request a normal amount of water *)
	standardResource = If[MatchQ[resolvedStandard, WaterModelP],
		Resource[
			Sample -> resolvedStandard,
			Amount -> If[resolvedStandardAmount <= 10 Microliter, 1.5 Milliliter, resolvedStandardAmount],
			Container -> If[resolvedStandardAmount <= 10 Microliter, Model[Container, Vessel, "id:3em6Zv9NjjN8"], PreferredContainer[resolvedStandardAmount * resolvedNumberOfStandards]] (* Model[Container, Vessel, "2mL Tube"] *)
		],
		Resource[
			Sample -> resolvedStandard,
			(* Note: this SHOULD be fine, but we could have a situation where the standard ampoule is 4 Milliliter and we're doing 1 Milliliter x 5 we might not be able to find an ampoule that works *)
			(* we might consolidate things between two ampoules if that happens, or we might just break.  I don't like either solution; we'll keep an eye on this *)
			Amount -> resolvedStandardAmount * resolvedNumberOfStandards
		]
	];

	(* reserve vials for all the samples if we're doing headspace sampling *)
	(* also do so for standard, and for the temperature ramp vials *)
	{
		headspaceVialResources,
		standardHeadspaceVialResources,
		blankHeadspaceVialResources,
		systemPrepHeadspaceVialResource,
		conditioningHeadspaceVialResource
	} = If[MatchQ[resolvedSamplingMethod, Headspace],
		Module[{headspaceRes, standardHeadspaceRes, headspaceVialID, blankHeadspaceRes,
			systemPrepHeadspaceRes, conditioningVialRes},

			(* we use this a bunch below *)
			headspaceVialID = Model[Container, Vessel, "id:KBL5DvPMzAXd"]; (* Model[Container, Vessel, "Headspace vial, 6 mL, crimp clear flat bottom"]*)
			(* note that we need Table here because we are making unique headspace values for each sample; if we did ConstantArray, we'd get the same Name/Resource for all of them *)
			headspaceRes = Table[
				Resource[
					Sample -> headspaceVialID,
					Name -> ToString[Unique[]]
				],
				Length[mySamples]
			];
			standardHeadspaceRes = Table[
				Resource[
					Sample -> headspaceVialID,
					Name -> ToString[Unique[]]
				],
				resolvedNumberOfStandards
			];
			blankHeadspaceRes = Table[
				Resource[
					Sample -> headspaceVialID,
					Name -> ToString[Unique[]]
				],
				resolvedNumberOfBlanks
			];
			systemPrepHeadspaceRes = Resource[Sample -> headspaceVialID, Name -> ToString[Unique[]]];
			conditioningVialRes = Resource[Sample -> headspaceVialID, Name -> ToString[Unique[]]];

			{headspaceRes, standardHeadspaceRes, blankHeadspaceRes, systemPrepHeadspaceRes, conditioningVialRes}
		],
		{{}, {}, {}, Null, Null}
	];

	(* using this variable a lot below, indicating that 1.) we have a volumetric technique and 2.) the standard is a solid *)
	volumetricSolidStandardQ = MatchQ[resolvedTechnique, Volumetric] && MassQ[resolvedStandardAmount];

	(* make a resource for the syringe rack if it's Volumetric; we may or may not use it below (in which case it won't get put into the protocol object) *)
	(* but most importantly we're going to use the same one throughout *)
	syringeRackResource = If[MatchQ[resolvedTechnique, Volumetric],
		(* Model[Container, Rack, "Syringe Weighing Rack"] *)
		Resource[Sample -> Model[Container, Rack, "id:qdkmxzG6nNMm"], Name -> CreateUniqueLabel["Syringe Rack"]],
		Null
	];

	(* same as above: make a resource for the 10 uL syringe; only doing it for water, and we can reuse it so we only need to get one thing *)
	(* might not actually add it to the protocol object *)
	microSyringeResource = If[MatchQ[resolvedTechnique, Volumetric],
		(* Model[Container, Syringe, "10 uL, Microliter Syringe, Cemented Needle"]*)
		Resource[Sample -> Model[Container, Syringe, "id:n0k9mGOJKpBk"], Name -> CreateUniqueLabel["Microsyringe"]],
		Null
	];

	(* determine if the standard and input samples are water; will use this a lot below *)
	waterStandardQ = MatchQ[resolvedStandard, WaterModelP] || MatchQ[fastAssocLookup[fastAssoc, resolvedStandard, {Model, Object}], WaterModelP];
	waterSampleQs = MatchQ[fastAssocLookup[fastAssoc, #1, {Model, Object}], WaterModelP]& /@ mySamples;

	(* decide on the syringes racks we're using for standards and for samples *)
	standardSyringeToUse = Which[
		(* if our standard is water, then we need to get a special 10 uL Hamilton syringe *)
		waterStandardQ,
			Model[Container, Syringe, "id:n0k9mGOJKpBk"],
		VolumeQ[resolvedStandardAmount],
			TransferDevices[Model[Container, Syringe], resolvedStandardAmount][[1, 1]],
		True, Null
	];
	sampleSyringesToUse = MapThread[
		Function[{sampleAmount, waterSampleQ},
			Which[
				(* if our input sample is water and we're doing 10 uL, then we can use the special hamilton syringe *)
				waterSampleQ && VolumeQ[sampleAmount] && sampleAmount <= 10 Microliter,
					Model[Container, Syringe, "id:n0k9mGOJKpBk"],  (* Model[Container, Syringe, "10 uL, Microliter Syringe, Cemented Needle"]*)
				VolumeQ[sampleAmount],
					TransferDevices[Model[Container, Syringe], sampleAmount][[1, 1]],
				True, Null
			]
		],
		{resolvedSampleAmount, waterSampleQs}
	];

	(* make resources for the syringes to inject standard and samples into the vessel *)
	(* note the differing use of Table and ConstantArray here.  ConstantArray for the water syringe because we're using the same one for all standards *)
	(* Table for the other liquids because those ones will not be reused and we'll have new ones each time *)
	standardSyringeResources = Which[
		(* coulometric doesn't do this *)
		MatchQ[resolvedTechnique, Coulometric], ConstantArray[Null, resolvedNumberOfStandards],
		(* if our standard is water, then we need to get a special 10 uL Hamilton syringe *)
		waterStandardQ,
			ConstantArray[microSyringeResource, resolvedNumberOfStandards],
		(* if our standard is liquid otherwise, we have to pick a syringe/needle appropriate for the standard amount *)
		VolumeQ[resolvedStandardAmount],
			Table[Resource[Sample -> standardSyringeToUse, Name -> CreateUniqueLabel["Standard Syringe"]], resolvedNumberOfStandards],
		True, ConstantArray[Null, resolvedNumberOfStandards]
	];
	systemPrepSyringeResource = Which[
		MatchQ[resolvedTechnique, Coulometric], Null,
		waterStandardQ, microSyringeResource,
		VolumeQ[resolvedStandardAmount], Resource[Sample -> standardSyringeToUse, Name -> CreateUniqueLabel["System Prep Syringe"]],
		True, Null
	];
	sampleSyringeResources = If[MatchQ[resolvedTechnique, Coulometric],
		ConstantArray[Null, Length[mySamples]],
		MapThread[
			Function[{sampleAmount, syringeToUse, waterSampleQ},
				Which[
					(* if our input sample is water and we're doing 10 uL, then we can use the special hamilton syringe *)
					waterSampleQ && VolumeQ[sampleAmount] && sampleAmount <= 10 Microliter,
						microSyringeResource,
					VolumeQ[sampleAmount],
						Resource[Sample -> syringeToUse, Name -> CreateUniqueLabel["Sample Syringe"]],
					True, Null
				]
			],
			{resolvedSampleAmount, sampleSyringesToUse, waterSampleQs}
		]
	];

	(* hard coding using this needle for now because it has a small gauge which will be good for keeping the reaction vessel dry *)
	potentialNeedleToUse = Model[Item, Needle, "id:L8kPEjOVeqwl"]; (* Model[Item, Needle, "25g x 1.5 Inch Single-Use Needle"]; *)

	(* same with using the weighing funnel *)
	potentialWeighingFunnelToUse = Model[Item, WeighBoat, WeighingFunnel, "id:E8zoYvOq8BWb"]; (* "Polypropylene Weighing Funnel (2 mL capacity, 0.3 Inch Stem Diameter)" *)

	(* need to reserve a septum if we are doing volumetric and will need to replace it this protocol *)
	replacementSeptumResource = If[MatchQ[resolvedTechnique, Volumetric],
		Resource[
			Sample -> Model[Item, Septum, "Septum 12 mm for Metrohm 901 Titrando"], (* TODO after refresh on 11/19/25 change this to the ID form *)
			Amount -> 1
		],
		Null
	];

	(* note if we're using the hamilton syringes for water, we don't need to make a needle resource because the needle is always attached to the syringe *)
	systemPrepNeedleResource = If[MatchQ[resolvedTechnique, Coulometric] || waterStandardQ || Not[VolumeQ[resolvedStandardAmount]],
		Null,
		Resource[
			Sample -> potentialNeedleToUse,
			Name -> CreateUniqueLabel["System Prep Needle"]
		]
	];
	{
		standardNeedleToUse,
		standardNeedleResources
	} = If[MatchQ[resolvedTechnique, Coulometric] || waterStandardQ || Not[VolumeQ[resolvedStandardAmount]],
		{
			Null,
			ConstantArray[Null, resolvedNumberOfStandards]
		},
		{
			potentialNeedleToUse,
			Table[
				Resource[
					Sample -> potentialNeedleToUse,
					Name -> CreateUniqueLabel["Standard Needle"]
				],
				resolvedNumberOfStandards
			]
		}
	];
	{
		sampleNeedlesToUse,
		sampleNeedleResources
	} = If[MatchQ[resolvedTechnique, Coulometric],
		{
			ConstantArray[Null, Length[mySamples]],
			ConstantArray[Null, Length[mySamples]]
		},
		Transpose@MapThread[
			Function[{sampleAmount, waterSampleQ},
				Which[
					(* if our input sample is water and we're doing 10 uL, then we can use the special hamilton syringe *)
					waterSampleQ && VolumeQ[sampleAmount] && sampleAmount <= 10 Microliter,
						{Null, Null},
					VolumeQ[sampleAmount],
						{
							potentialNeedleToUse,
							Resource[Sample -> potentialNeedleToUse, Name -> CreateUniqueLabel["Sample Syringe"]]
						},
					True, {Null, Null}
				]
			],
			{resolvedSampleAmount, waterSampleQs}
		]
	];

	(* make resources for the weighing funnels we need to weigh the standard out *)
	(* this feels like a good choice right now for which one to use; certainly we could do several different ones and could change this, but this should suit our needs for now *)
	systemPrepWeighingFunnelResource = If[volumetricSolidStandardQ,
		Resource[Sample -> potentialWeighingFunnelToUse, Name -> CreateUniqueLabel["System Prep Weighing Funnel"]],
		Null
	];
	{
		standardWeighingFunnelToUse,
		standardWeighingFunnelResources
	} = If[volumetricSolidStandardQ,
		{
			potentialWeighingFunnelToUse,
			Table[Resource[Sample -> potentialWeighingFunnelToUse, Name -> CreateUniqueLabel["Standard Weighing Funnel"]], resolvedNumberOfStandards]
		},
		{
			Null,
			ConstantArray[Null, resolvedNumberOfStandards]
		}
	];
	{
		sampleWeighingFunnelsToUse,
		sampleWeighingFunnelResources
	} = If[MatchQ[resolvedTechnique, Coulometric],
		{
			ConstantArray[Null, Length[mySamples]],
			ConstantArray[Null, Length[mySamples]]
		},
		Transpose@Map[
			If[MassQ[#],
				{
					potentialWeighingFunnelToUse,
					Resource[Sample -> potentialWeighingFunnelToUse, Name -> CreateUniqueLabel["Sample Weighing Funnel"]]
				},
				{Null, Null}
			]&,
			resolvedSampleAmount
		]
	];

	(* get the standard spatula model we want to use and make a resource for it *)
	(* this is using a helper from ExperimentTransfer *)
	standardSpatula = If[volumetricSolidStandardQ,
		compatibleSpatulas[resolvedStandardAmount, Lookup[standardPacket, Density], spatulaPackets, Null, IncompatibleMaterials -> Lookup[standardPacket, IncompatibleMaterials]][[1, 1]],
		Null
	];

	(* get the sample spatulas *)
	sampleSpatulas = If[MatchQ[resolvedTechnique, Coulometric],
		ConstantArray[Null, Length[samplePackets]],
		MapThread[
			If[MassQ[#2],
				compatibleSpatulas[#2, Lookup[#1, Density], spatulaPackets, Null, IncompatibleMaterials -> Lookup[#1, IncompatibleMaterials]][[1, 1]],
				Null
			]&,
			{samplePackets, resolvedSampleAmount}
		]
	];


	(* determine if the spatulas we're using are counted or not.  If they are, then we need to make just one resource for all of them *)
	(* I know this is an extra Download at this stage, but I can only do this Download _after_ I know what the spatulas are, which is right before now *)
	{standardSpatulaCountedQ, sampleSpatulaCountedQs} = {
		TrueQ[fastAssocLookup[fastAssoc, standardSpatula, Counted]],
		TrueQ[fastAssocLookup[fastAssoc, #, Counted]]& /@ sampleSpatulas
	};

	(* get the counted spatulas and make count rules for them *)
	countedSpatulas = PickList[
		Flatten[{ConstantArray[standardSpatula, resolvedNumberOfStandards], sampleSpatulas}],
		Flatten[{ConstantArray[standardSpatulaCountedQ, resolvedNumberOfStandards], sampleSpatulaCountedQs}]
	];
	spatulaCountRules = Rule @@@ Tally[countedSpatulas];

	(* make resources for spatulas, optimized to not need to resource pick too many *)
	standardSpatulaResources = Which[
		NullQ[standardSpatula], ConstantArray[Null, resolvedNumberOfStandards],
		(* if we aren't using a counted spatula, we don't need to specify the amount *)
		(* using ConstantArray here because I feel confident that we can use the same spatula all n times because it's the same thing coming from the same place *)
		Not[standardSpatulaCountedQ], ConstantArray[Resource[Sample -> standardSpatula, Name -> "Karl Fischer Standard Spatula"], resolvedNumberOfStandards],
		(* if we do have a counted spatula, need to use the count from the rules we got above *)
		(* doing + 1 because we also need to account for the system prep one *)
		True, ConstantArray[Resource[Sample -> standardSpatula, Name -> ToString[standardSpatula], Amount -> 1 + Lookup[spatulaCountRules, standardSpatula]], resolvedNumberOfStandards]
	];
	sampleSpatulaResources = MapThread[
		Function[{sampleSpatula, countedQ},
			Which[
				NullQ[sampleSpatula], Null,
				(* if we aren't using a counted spatula, we need to make a different resource for each spatula *)
				Not[countedQ], Resource[Sample -> sampleSpatula, Name -> CreateUniqueLabel["Sample Spatula"]],
				(* if we do have a counted spatula, need to use the count from the rules we got above *)
				True, Resource[Sample -> sampleSpatula, Name -> ToString[sampleSpatula], Amount -> Lookup[spatulaCountRules, sampleSpatula]]
			]
		],
		{sampleSpatulas, sampleSpatulaCountedQs}
	];

	(* make resources for the molecular sieves; we probably won't need these so we won't pick them if so, but better to know we are running low now than mid-protocol *)
	(* 100 gram is more than enough; will probably use a lot less *)
	(* also need a spatula *)
	molecularSieveResource = Resource[
		Sample -> Model[Sample, "id:R8e1PjBOp43K"],  (* "Molecular sieves (4 A with indicator), beads" *)
		Amount -> 100 Gram
	];
	molecularSieveSpatulaResource = Resource[
		Sample -> Model[Item, Spatula, "id:qdkmxz1l30DM"] (* "Disposable Polypropylene Scoop and Spatula, 21 cm, Individual" *)
	];


	(* make a resource for an ampoule opener; we might not actually use it later *)
	ampouleOpenerResource = Resource[
		Sample -> Model[Part, AmpouleOpener, "id:kEJ9mqRpOvO3"] (* Model[Part, AmpouleOpener, "SnapIT Trolley Ampoule Opener, Regular"] *)
	];

	(* --- Calculate the expected weights --- *)
	(* these fields act as guides for operators so that they don't make flagarant mistakes like getting a weight value of 75g when the syringe is only 7g *)
	(* for coulometric, this is just {} in all cases because the fields are irrelevant *)

	(* in order to get these expected values, need to convert the standard and sample amounts to masses *)
	(* if we don't have densities then we're just going to assume 1 g/mL and it will probably be fine (but densities would be nice) *)
	standardAmountAsMass = Which[
		MassQ[resolvedStandardAmount], resolvedStandardAmount,
		DensityQ[Lookup[standardPacket, Density]], resolvedStandardAmount * Lookup[standardPacket, Density],
		True, resolvedStandardAmount * (1 Gram / Milliliter)
	];
	sampleAmountsAsMass = MapThread[
		Function[{sampleAmount, samplePacket},
			Which[
				MassQ[sampleAmount], sampleAmount,
				DensityQ[Lookup[samplePacket, Density]], sampleAmount * Lookup[samplePacket, Density],
				True, sampleAmount * (1 Gram / Milliliter)
			]
		],
		{resolvedSampleAmount, samplePackets}
	];

	(* calculate the tolerances, which are just 0.05x the standard standard and sample amounts as mass if we're using weighing funnels, but 0.5x if we're using syringes/needles *)
	(* this is admitteldy a little hokey.  However, we need the much wider tolerance for the syringe case for the following reasons: *)
	(* 1.) TareWeight for syringes and needles are in the model only, and so there's intrinsically already some variability here *)
	(* 2.) DeadVolume weight of sample is not populated widely and hard to calculate if the vendor doesn't give it to us, so we're not really accounting for that here *)
	(* 3.) I'm not super confident in the densities provided by the vendor for our standards, so the expected weights themselves might be off *)
	(* 4.) If you are using a syringe/liquid, you can't really adjust the weight in a way that feels nice like you can with solid (hence solids/weighing funnels not needing this wide tolerance). *)
	(* You could poke the needle back into the source container to get more volume, or dispense some out into the liquid waste, but both of those are cumbersome and/or gross to do for the sample or needle *)
	(* So instead we're just increasing the tolerance by a lot nad seeing where that goes for us. *)
	(* minimum of 5 mg though because otherwise it's too narrow *)
	standardTolerance = UnitScale[If[NullQ[standardSyringeToUse],
		Max[{standardAmountAsMass * 0.05, 5 Milligram}],
		Max[{standardAmountAsMass * 0.5, 5 Milligram}]
	]];
	sampleTolerance = UnitScale[MapThread[
		If[NullQ[#2],
			Max[{#1 * 0.05, 5 Milligram}],
			Max[{#1 * 0.5, 5 Milligram}]
		]&,
		{sampleAmountsAsMass, sampleSyringesToUse}
	]];

	(* decide what we're counting as the standard and sample syringe weights; this is kind of complicated because we might not have TareWeight for the syringe or needle *)
	(* also we might just not have a needle because it's always attached to the syringe *)
	standardSyringeWeightToUse = Which[
		And[
			MatchQ[standardSyringeToUse, ObjectP[]],
			MatchQ[standardNeedleToUse, ObjectP[]],
			MassQ[fastAssocLookup[fastAssoc, standardSyringeToUse, TareWeight]],
			MassQ[fastAssocLookup[fastAssoc, standardNeedleToUse, TareWeight]]
		],
			fastAssocLookup[fastAssoc, standardSyringeToUse, TareWeight] + fastAssocLookup[fastAssoc, standardNeedleToUse, TareWeight],
		And[
			MatchQ[standardSyringeToUse, ObjectP[]],
			NullQ[standardNeedleToUse],
			MassQ[fastAssocLookup[fastAssoc, standardSyringeToUse, TareWeight]]
		],
			fastAssocLookup[fastAssoc, standardSyringeToUse, TareWeight],
		True, Null
	];
	sampleSyringeWeightsToUse = MapThread[
		Function[{syringe, needle},
			Which[
				And[
					MatchQ[syringe, ObjectP[]],
					MatchQ[needle, ObjectP[]],
					MassQ[fastAssocLookup[fastAssoc, syringe, TareWeight]],
					MassQ[fastAssocLookup[fastAssoc, needle, TareWeight]]
				],
					fastAssocLookup[fastAssoc, syringe, TareWeight] + fastAssocLookup[fastAssoc, needle, TareWeight],
				And[
					MatchQ[syringe, ObjectP[]],
					NullQ[needle],
					MassQ[fastAssocLookup[fastAssoc, syringe, TareWeight]]
				],
					fastAssocLookup[fastAssoc, syringe, TareWeight],
				True, Null
			]
		],
		{sampleSyringesToUse, sampleNeedlesToUse}
	];

	(* the standard tare weight is always the tare weight of the thing that's doing the addition (either weighing funnels or syringes or syringes + needles) *)
	expectedStandardTareWeight = Which[
		MatchQ[resolvedTechnique, Coulometric], {},
		(* if we're using a syringe, use the value we calculated above *)
		MatchQ[standardSyringeToUse, ObjectP[]],
			ConstantArray[standardSyringeWeightToUse, resolvedNumberOfStandards],
		(* if we have the weighing funnels, get the tare weight of the weigh boats *)
		MatchQ[standardWeighingFunnelToUse, ObjectP[]],
			ConstantArray[fastAssocLookup[fastAssoc, standardWeighingFunnelToUse, TareWeight], resolvedNumberOfStandards],
		(* we shouldn't get this far but if we do it's just an empty list *)
		True, {}
	];

	(* for the standard weight itself, if we're using a syringe, this is the expected standard weight plus the weight of the syringe (and needle if applicable).  If we're using a weighing funnel, it's just the sample weight *)
	expectedStandardWeight = Which[
		MatchQ[resolvedTechnique, Coulometric], {},
		MatchQ[standardSyringeToUse, ObjectP[]] && Not[NullQ[standardSyringeWeightToUse]], ConstantArray[standardSyringeWeightToUse + standardAmountAsMass, resolvedNumberOfStandards],
		(* if we don't have the syringe weight, then we can't do anything here and just keep it at Null *)
		MatchQ[standardSyringeToUse, ObjectP[]], ConstantArray[Null, resolvedNumberOfStandards],
		MatchQ[standardWeighingFunnelToUse, ObjectP[]], ConstantArray[standardAmountAsMass + fastAssocLookup[fastAssoc, standardWeighingFunnelToUse, TareWeight], resolvedNumberOfStandards],
		True, {}
	];

	(* this is always going to be the same as the tare weight (until we actually get measurements, then we change it on the fly) *)
	expectedStandardEmptyWeight = expectedStandardTareWeight;

	(* the sample tare weight is always the tare weight of the thing that's doing the addition (either weighing funnels or syringes or syringes + needles) *)
	expectedSampleTareWeight = MapThread[
		Function[{weighingFunnel, syringe, syringeWeight},
			Which[
				MatchQ[resolvedTechnique, Coulometric], Nothing,
				(* if we're using a syringe, use the value we calculated above *)
				MatchQ[syringe, ObjectP[]], syringeWeight,
				(* if we have the weighing funnels, get the tare weight of the weigh boats *)
				MatchQ[weighingFunnel, ObjectP[]], fastAssocLookup[fastAssoc, weighingFunnel, TareWeight],
				(* we shouldn't get this far but if we do it's just an empty list *)
				True, Nothing
			]
		],
		{sampleWeighingFunnelsToUse, sampleSyringesToUse, sampleSyringeWeightsToUse}
	];

	(* give the tolerance of the tare weights; we're calling this 10% of the expected value; we could adjust this *)
	(* the problem is because these are _model_ tare weights, we need more than the normal allowed variation to ensure we account for the object-to-object variability *)
	standardTareTolerance = If[MatchQ[resolvedTechnique, Coulometric],
		Null,
		UnitScale[First[expectedStandardTareWeight] * 0.1]
	];
	sampleTareTolerance = If[MatchQ[resolvedTechnique, Coulometric],
		Null,
		UnitScale[expectedSampleTareWeight * 0.1]
	];

	(* for the sample weight itself, if we're using a syringe, this is the expected sample weight plus the weight of the syringe (and needle if applicable).  If we're using a weighing funnel, it's just the sample weight *)
	expectedSampleWeight = MapThread[
		Function[{weighingFunnel, syringe, syringeWeight, sampleAmount},
			Which[
				MatchQ[resolvedTechnique, Coulometric], Nothing,
				MatchQ[syringe, ObjectP[]] && Not[NullQ[syringeWeight]], syringeWeight + sampleAmount,
				MatchQ[syringe, ObjectP[]], Null,
				MatchQ[weighingFunnel, ObjectP[]], sampleAmount + fastAssocLookup[fastAssoc, weighingFunnel, TareWeight],
				True, Nothing
			]
		],
		{sampleWeighingFunnelsToUse, sampleSyringesToUse, sampleSyringeWeightsToUse, sampleAmountsAsMass}

	];

	(* the empty weight is always the same as the tare weight (until we actually get measurements, then we change it on the fly) *)
	expectedSampleEmptyWeight = expectedSampleTareWeight;

	(* make the protocol packet *)
	protocolID = CreateID[Object[Protocol, KarlFischerTitration]];
	protocolPacket = <|
		Object -> protocolID,
		Name -> Lookup[myResolvedOptions, Name],
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ sampleResources),
		Replace[ContainersIn] -> (Link[#, Protocols]& /@ DeleteDuplicates[sampleContainerResources]),
		Instrument -> Link[instrumentResource],
		Technique -> resolvedTechnique,
		KarlFischerReagent -> Link[karlFischerReagentResource],
		Replace[SampleAmount] -> resolvedSampleAmount,
		Replace[SampleTolerance] -> sampleTolerance,
		Replace[SampleTareTolerance] -> sampleTareTolerance,
		SamplingMethod -> resolvedSamplingMethod,
		Replace[Temperatures] -> resolvedTemperature,
		Replace[Medium] -> (Link[#]& /@ mediumResources),
		SystemPrepSyringe -> Link[systemPrepSyringeResource],
		SystemPrepNeedle -> Link[systemPrepNeedleResource],
		SystemPrepWeighingFunnel -> Link[systemPrepWeighingFunnelResource],
		(* use the same spatula as the standard spatula *)
		SystemPrepSpatula -> Link[First[standardSpatulaResources]],
		Standard -> Link[standardResource],
		StandardAmount -> resolvedStandardAmount,
		StandardTemperature -> resolvedStandardTemperature /. {Ambient -> Null},
		StandardTolerance -> standardTolerance,
		StandardTareTolerance -> standardTareTolerance,
		GasFlowRate -> resolvedGasFlowRate,
		Replace[HeadspaceVials] -> (Link[#]& /@ headspaceVialResources),
		Replace[StandardHeadspaceVials] -> (Link[#]& /@ standardHeadspaceVialResources),
		Replace[BlankHeadspaceVials] -> (Link[#]& /@ blankHeadspaceVialResources),
		SystemPrepHeadspaceVial -> Link[systemPrepHeadspaceVialResource],
		ConditioningHeadspaceVial -> Link[conditioningHeadspaceVialResource],
		NumberOfStandards -> resolvedNumberOfStandards,
		NumberOfBlanks -> resolvedNumberOfBlanks,
		Replace[StandardSyringes] -> (Link[#]& /@ standardSyringeResources),
		Replace[SampleSyringes] -> (Link[#]& /@ sampleSyringeResources),
		Replace[StandardNeedles] -> (Link[#]& /@ standardNeedleResources),
		Replace[SampleNeedles] -> (Link[#]& /@ sampleNeedleResources),
		SyringeRack -> If[MemberQ[Flatten[{standardSyringeResources, sampleSyringeResources}], _Resource],
			syringeRackResource,
			Null
		],
		Replace[StandardWeighingFunnels] -> (Link[#]& /@ standardWeighingFunnelResources),
		Replace[SampleWeighingFunnels] -> (Link[#]& /@ sampleWeighingFunnelResources),
		Replace[StandardSpatulas] -> (Link[#]& /@ standardSpatulaResources),
		Replace[SampleSpatulas] -> (Link[#]& /@ sampleSpatulaResources),
		ReplacementMolecularSieves -> Link[molecularSieveResource],
		ReplacementMolecularSievesSpatula -> Link[molecularSieveSpatulaResource],
		ReplacementSeptum -> Link[replacementSeptumResource],
		AmpouleOpener -> Link[ampouleOpenerResource],

		(* add the grind options in here *)
		Replace[Grind] -> resolvedGrind,
		Replace[GrindAmount] -> resolvedGrindAmount,
		Replace[Grinder] -> (Link /@ resolvedGrinder),
		Replace[Fineness] -> resolvedFineness,
		Replace[BulkDensity] -> resolvedBulkDensity,
		Replace[GrindingContainer] -> (Link /@ resolvedGrindingContainer),
		Replace[GrindingBead] -> (Link /@ resolvedGrindingBead),
		Replace[NumberOfGrindingBeads] -> resolvedNumberOfGrindingBeads,
		Replace[GrindingRate] -> resolvedGrindingRate,
		Replace[GrindingTime] -> resolvedGrindingTime,
		Replace[NumberOfGrindingSteps] -> resolvedNumberOfGrindingSteps,
		Replace[CoolingTime] -> resolvedCoolingTime,
		Replace[GrindingProfile] -> resolvedGrindingProfile,
		ExpectedSystemPrepTareWeight -> If[MatchQ[resolvedTechnique, Volumetric],
			First[expectedStandardTareWeight],
			Null
		],
		ExpectedSystemPrepWeight -> If[MatchQ[resolvedTechnique, Volumetric],
			First[expectedStandardWeight],
			Null
		],
		ExpectedSystemPrepEmptyWeight -> If[MatchQ[resolvedTechnique, Volumetric],
			First[expectedStandardEmptyWeight],
			Null
		],
		Replace[ExpectedStandardTareWeight] -> expectedStandardTareWeight,
		Replace[ExpectedStandardWeight] -> expectedStandardWeight,
		Replace[ExpectedStandardEmptyWeight] -> expectedStandardEmptyWeight,
		Replace[ExpectedSampleTareWeight] -> expectedSampleTareWeight,
		Replace[ExpectedSampleWeight] -> expectedSampleWeight,
		Replace[ExpectedSampleEmptyWeight] -> expectedSampleEmptyWeight,

		UnresolvedOptions -> RemoveHiddenOptions[ExperimentKarlFischerTitration, myUnresolvedOptions],
		ResolvedOptions -> RemoveHiddenOptions[ExperimentKarlFischerTitration, myResolvedOptions],
		Replace[Checkpoints] -> {
			{"Preparing Samples", 0 Minute, "Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Null},
			{"Picking Resources", 5 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> operator, Time -> 5 Minute]]},
			{"Titration", 2 Hour + 25 Minute * (Length[sampleResources] + Length[Cases[resolvedTemperature, Auto]]), "The samples and standard are titrated to determine their water content.", Link[Resource[Operator -> operator, Time -> 2 Hour + 25 Minute * (Length[sampleResources] + Length[Cases[resolvedTemperature, Auto]])]]},
			{"Parsing Data", 1 Minute, "The database is updated with the water content data of the samples.", Link[Resource[Operator -> operator, Time -> 1 Minute]]},
			{"Sample Post-Processing", 1 Hour , "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> operator, Time -> 1 Minute]]}
		},
		populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache, Simulation -> simulation]
	|>;

	(* Get all of the resource out of the packet so they can be tested *)
	allResourceBlobs = DeleteDuplicates[Cases[protocolPacket, _Resource, Infinity]];

	(* Call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests,
			Resources`Private`fulfillableResourceQ[
				allResourceBlobs,
				Output -> {Result, Tests},
				FastTrack -> Lookup[myResolvedOptions, FastTrack],
				Site -> Lookup[myResolvedOptions, Site],
				Simulation -> simulation,
				Cache -> cache
			],
		True,
			{
				Resources`Private`fulfillableResourceQ[
					allResourceBlobs,
					FastTrack -> Lookup[myResolvedOptions, FastTrack],
					Site -> Lookup[myResolvedOptions, Site],
					Simulation -> simulation,
					Messages -> messages,
					Cache -> cache
				],
				Null
			}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule = Preview -> Null;

	(* Generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentKarlFischerTitration, myResolvedOptions],
		Null
	];

	(* Generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		{}
	];

	(* Generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		protocolPacket,
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}

];


(* ::Subsection:: *)
(*simulateExperimentKarlFischerTitration*)

DefineOptions[
	simulateExperimentKarlFischerTitration,
	Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentKarlFischerTitration[
	myProtocolPacket:PacketP[Object[Protocol, KarlFischerTitration]] | $Failed | Null,
	mySamples: {ObjectP[Object[Sample]]..},
	myResolvedOptions: {_Rule...},
	myResolutionOptions: OptionsPattern[simulateExperimentKarlFischerTitration]
]:=Module[
	{
		cache, simulation, fastAssoc, protocolObject, mapThreadFriendlyOptions, currentSimulation, simulationWithLabels,
		resolvedGrind, resolvedSampleAmount, samplesToDecrement, amountsToDecrement, wasteSampleID,
		sourceSampleDecrementPackets
	},

	(* Lookup our cache and simulation and make our fast association *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Null];
	fastAssoc = makeFastAssocFromCache[cache];

	(* Get our protocol ID. This should already be in our protocol packet *)
	protocolObject = Lookup[myProtocolPacket, Object];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[
		ExperimentKarlFischerTitration,
		myResolvedOptions
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation = SimulateResources[myProtocolPacket, Simulation -> simulation];

	(* we already have the Grind resource simulation in here, so all we need to do here is make some waste sample, and then Transfer the SampleAmount into that waste sample *)
	{
		resolvedGrind,
		resolvedSampleAmount
	} = Lookup[
		myResolvedOptions,
		{
			Grind,
			SampleAmount
		}
	];
	samplesToDecrement = PickList[mySamples, resolvedGrind, False];
	amountsToDecrement = PickList[resolvedSampleAmount, resolvedGrind, False];

	(* only do this if we have some samples where we're not grinding (this saves us some time) *)
	{currentSimulation, wasteSampleID} = If[MatchQ[samplesToDecrement, {}],
		{currentSimulation, Null},
		Module[{wasteContainerPackets, wasteSamplePackets},
			(* make a simulated waste container + sample that we're decrementing the source sample from *)
			wasteContainerPackets = UploadSample[
				Model[Container, Vessel, "id:3em6Zv9NjjkY"], (* Model[Container, Vessel, "20L Polypropylene Carboy"] *)
				{"A1", Object[Container, Room, "id:AEqRl9KmEAz5"]}, (* Object[Container, Room, "Empty Room for Simulated Objects"] *)
				Simulation -> currentSimulation,
				FastTrack -> True,
				SimulationMode -> True,
				Upload -> False
			];
			currentSimulation = UpdateSimulation[currentSimulation, Simulation[wasteContainerPackets]];
			wasteSamplePackets = UploadSample[
				Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
				{"A1", Lookup[First[wasteContainerPackets], Object]},
				State -> Liquid,
				InitialAmount -> Null,
				Simulation -> currentSimulation,
				SimulationMode -> True,
				FastTrack -> True,
				Upload -> False
			];

			(* return the updated simulation and the ID *)
			{
				UpdateSimulation[currentSimulation, Simulation[wasteSamplePackets]],
				Lookup[First[wasteSamplePackets], Object]
			}
		]
	];

	(* do an UploadSampleTransfer to decrement the source sample; this will short circuit to {} if we aren't decrementing *)
	sourceSampleDecrementPackets = UploadSampleTransfer[
		samplesToDecrement,
		ConstantArray[wasteSampleID, Length[samplesToDecrement]],
		amountsToDecrement,
		Simulation -> currentSimulation,
		FastTrack -> True,
		Upload -> False
	];
	currentSimulation = UpdateSimulation[currentSimulation, Simulation[sourceSampleDecrementPackets]];

	(* We don't have any SamplesOut for our protocol object, so right now, just tell the simulation where to find the *)
	(* SamplesIn field. *)
	simulationWithLabels = Simulation[
		Labels -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], mySamples}],
				{_String, ObjectP[]}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], Download[fastAssocLookup[fastAssoc, #, Container]& /@ mySamples, Object]}],
				{_String, ObjectP[]}
			]
		],
		LabelFields -> Join[
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleLabel], (Field[SampleLink[[#]]]&) /@ Range[Length[mySamples]]}],
				{_String, _}
			],
			Rule @@@ Cases[
				Transpose[{Lookup[myResolvedOptions, SampleContainerLabel], (Field[SampleLink[[#]][Container]]&) /@ Range[Length[mySamples]]}],
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
(*resolveKarlFischerTitrationMethod*)

(* NOTE: myInputs can be Automatic when the user has not yet specified a value for autofill. *)
resolveKarlFischerTitrationMethod[
	myInputs:ListableP[Alternatives[
		ObjectP[{Object[Container],Object[Sample]}],
		_String,
		{LocationPositionP,_String|ObjectP[Object[Container]]}
	]],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions,outputSpecification,output,gatherTests,result,tests},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveKarlFischerTitrationMethod,ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[safeOptions,Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* For KarlFischerTitration, result is always ManualSamplePreparation and there are no tests *)
	result=Manual;
	tests={};

	outputSpecification/.{Result->result,Tests->tests}
];

(* memoize getting spatulas *)
kfMeasuringToolPackets[fakeString_]:=kfMeasuringToolPackets[fakeString]=Module[{spatulaModels, needleModels,
	weighingFunnelModels, syringeModels},
	If[!MemberQ[$Memoization, Experiment`Private`kfMeasuringToolPackets],
		AppendTo[$Memoization, Experiment`Private`kfMeasuringToolPackets]
	];

	(* search for spatulas, needles, and weighing funnels; syringes are a little more complicated and need to pull from TransferDevices *)
	{
		spatulaModels,
		needleModels,
		weighingFunnelModels
	} = Search[
		{
			Model[Item, Spatula],
			Model[Item, Needle],
			Model[Item, WeighBoat, WeighingFunnel]
		},
		{
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True,
			Deprecated != True && DeveloperObject != True
		}
	];

	syringeModels = TransferDevices[Model[Container, Syringe], All][[All, 1]];

	(* TareWeight is the important field here for the non-spatulas; if we need more we can add more *)
	Flatten /@ Download[
		{
			spatulaModels,
			needleModels,
			weighingFunnelModels,
			(* make sure we include the hamilton syringes here; they're not currently included in transfer devices *)
			Join[
				syringeModels,
				{
					Model[Container, Syringe, "id:n0k9mGOJKpBk"], (* "10 uL, Microliter Syringe, Cemented Needle" *)
					Model[Container, Syringe, "id:Y0lXejOzVkEa"] (* "100 uL, Microliter Syringe, Cemented Needle"] *)
				}
			]
		},
		{
			{Packet[Name, Material, TransferVolume, Reusable, EngineDefault, DeveloperObject, Counted]},
			{Packet[TareWeight]},
			{Packet[TareWeight]},
			{Packet[TareWeight]}
		}
	]
];


(* ::Subsubsection::Closed:: *)
(*ExperimentKarlFischerTitrationOptions *)


DefineOptions[ExperimentKarlFischerTitrationOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}

	},
	SharedOptions :> {ExperimentKarlFischerTitration}];

ExperimentKarlFischerTitrationOptions[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]|_String], myOptions: OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions,options},

	(* Get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* Get only the options for ExperimentKarlFischerTitration *)
	options = ExperimentKarlFischerTitration[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentKarlFischerTitration],
		options
	]
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentKarlFischerTitrationQ*)


DefineOptions[ValidExperimentKarlFischerTitrationQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentKarlFischerTitration}
];


ValidExperimentKarlFischerTitrationQ[myInputs: ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}]|_String], myOptions: OptionsPattern[]] := Module[
	{listedOptions, preparedOptions, experimentKarlFischerTitrationTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Get the options as a list *)
	listedOptions = ToList[myOptions];

	(* Remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* Return only the tests for ExperimentKarlFischerTitration *)
	experimentKarlFischerTitrationTests = ExperimentKarlFischerTitration[myInputs, Append[preparedOptions, Output -> Tests]];

	(* Define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[experimentKarlFischerTitrationTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[ToList[myInputs],_String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myInputs],_String], validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest, experimentKarlFischerTitrationTests, voqWarnings}]
		]
	];
	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentKarlFischerTitrationQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentKarlFischerTitrationQ"]
];


(* ::Subsubsection::Closed:: *)
(*ExperimentKarlFischerTitrationPreview*)


DefineOptions[ExperimentKarlFischerTitrationPreview,
	SharedOptions :> {ExperimentKarlFischerTitration}
];

ExperimentKarlFischerTitrationPreview[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* Get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for ExperimentKarlFischerTitration *)
	ExperimentKarlFischerTitration[myInputs, Append[noOutputOptions, Output -> Preview]]

];