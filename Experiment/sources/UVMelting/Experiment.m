(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UVMelting*)


(* ::Subsubsection::Closed:: *)
(*ExperimentUVMelting patterns and hardcoded values*)


(* Store a list of available cuvette models *)
absorbanceThermodynamicsAllowedCuvettes = {
	Model[Container, Cuvette, "id:eGakld01zz3E"], (* Micro scale *)
	Model[Container, Cuvette, "id:R8e1PjRDbbld"], (* Semi-micro scale *)
	Model[Container, Cuvette, "id:1ZA60vAA1PE8"], (* Semi-micro scale *)
	Model[Container, Cuvette, "id:Y0lXejGKdd1x"], (* Standard scale *)
	Model[Container, Cuvette, "id:1ZA60vA840Ew"], (* Sub-micro scale *)
	Model[Container, Cuvette, "id:O81aEBvP0LON"] (* Sub-micro scale *)
};
absorbanceThermodynamicsAllowedCuvettesP = ObjectP[absorbanceThermodynamicsAllowedCuvettes];


(* Establish a set of standard assay volumes meant to fit nicely into the available cuvette models *)
absorbanceThermodynamicsStandardAssayVolumes = {60 Micro Liter,600 Micro Liter,1200 Micro Liter};

(* Store a list of the options that are listable per-sample rather than per-cuvette *)
absorbanceThermodynamicsSampleIndexedOptions = {AliquotVolume,TargetConcentration};

(* Store a list of the options that are MapThreaded; calculated only once upon loading, because it shouldn't change *)
absorbanceThermodynamicsCuvetteIndexedOptions = Module[
	{optionDefs,optionNames,mapThreadBools},

	optionDefs = OptionDefinition[ExperimentUVMelting];

	optionNames = Lookup[optionDefs,"OptionName"];

	mapThreadBools = MatchQ[#,"Input"]&/@Lookup[optionDefs,"IndexMatching",Null];

	Pick[optionNames,mapThreadBools]

];
absorbanceThermodynamicsCuvetteIndexedOptionQ[optionName_Symbol] := MemberQ[absorbanceThermodynamicsCuvetteIndexedOptions,optionName];



(* ::Subsubsection::Closed:: *)
(*ExperimentUVMelting Options*)


DefineOptions[ExperimentUVMelting,
	Options:>{
		(* Single Options *)
		{
			OptionName -> Instrument,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type->Object,
				Pattern :> ObjectP[
					{
						Model[Instrument,Spectrophotometer],Object[Instrument,Spectrophotometer]
					}
				]
			],
			Description -> "The UV-Vis spectrophotometer to be used for this UVMelting Experiment.",
			ResolutionDescription->"Resolves to an instrument model that supports all specified options.",
			Category -> "Method"
		},
		{
			OptionName -> MaxTemperature,
			Default -> 95 Celsius,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[-10 Celsius, 100 Celsius],Units :> {Celsius,{Celsius,Kelvin,Fahrenheit}}],
				Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
			],
			Description -> "The high temperature of the melting and cooling curves.",
			Category -> "Method"
		},
		{
			OptionName -> MinTemperature,
			Default -> 5 Celsius,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[Type -> Quantity, Pattern :> RangeP[-10 Celsius, 100 Celsius],Units :> Celsius],
				Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
			],
			Description -> "The low temperature in Celsius of the melting and cooling curves.",
			Category -> "Method"
		},
		{
			OptionName -> NumberOfCycles,
			Default -> 1,
			AllowNull -> False,
			Widget ->  Widget[Type->Number, Pattern :> RangeP[1, 5, 1]],
			Description -> "The number of repeated melting and cooling cycles to be performed.",
			Category -> "Method"
		},
		{
			OptionName -> EquilibrationTime,
			Default -> 5 Minute,
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0*Minute,999*Minute],Units :> {1,{Minute,{Second,Minute,Hour}}}],
			Description-> "The time in seconds between each melting and cooling cycle.",
			Category -> "Method"
		},
		{
			OptionName -> TemperatureRampOrder,
			Default -> {Heating, Cooling},
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration,Pattern :> ThermodynamicCycleP],
			Description -> "The order of temperature ramping to be performed in each cycle.",
			Category -> "Method"
		},
		{
			OptionName -> TemperatureResolution,
			Default -> 1 Celsius,
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1*Celsius,100*Celsius], Units:>Celsius],
			Description -> "The amount by which the temperature will be changed between each data point and the next during the melting and/or cooling curves.",
			Category -> "Method"
		},
		{
			OptionName -> TemperatureRampRate,
			Default -> 1 Celsius / Minute,
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[0.1 Celsius / Minute, 40 Celsius / Minute],Units :> CompoundUnit[{1,{Celsius,{Celsius}}},{-1,{Minute,{Minute}}}]],
			Description -> "The rate at which the temperature is changed in the course of one heating and/or cooling cycle.",
			Category -> "Method"
		},
		{
			OptionName -> Wavelength,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[190 Nanometer, 900 Nanometer],Units :> Nanometer],
			Description -> "Wavelength of light which should be passed through the cuvette holding the sample in order to measure the sample's absorbance." ,
			ResolutionDescription -> "Automatically resolves to Null when MinWavelength or MaxWavelength are set, otherwise resolves to 260 nm for oligomer (DNA/RNA/PNA) samples or to 280 nm for protein samples.",
			Category -> "Method"
		},
		{
			OptionName -> MinWavelength,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[190 Nanometer, 900 Nanometer],Units :> Nanometer],
			Description -> "The lower limit of the wavelength range of light that should be passed through the cuvette holding the sample in order to measure the sample's absorbance. Note that currently the Cary 3500 can only collect 10 wavelengths per scan, and so when specifying a wavelength range, the wavelengths actually measured will be a selection in this range that always includes the MinWavelength, the MaxWavelength, and, if included in the range, 260 Nanometer and 280 Nanometer.",
			ResolutionDescription -> "Automatically resolves to the highest possible setting (900 Nanometer) if MinWavelength is specified, otherwise resolves to Null.",
			Category -> "Method"
		},
		{
			OptionName -> MaxWavelength,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[190 Nanometer, 900 Nanometer],Units :> Nanometer],
			Description -> "The upper limit of the wavelength range of light that should be passed through the cuvette holding the sample in order to measure the sample's absorbance. Note that currently the Cary 3500 can only collect 10 wavelengths per scan, and so when specifying a wavelength range, the wavelengths actually measured will be a selection in this range that always includes the MinWavelength, the MaxWavelength, and, if included in the range, 260 Nanometer and 280 Nanometer.",
			ResolutionDescription -> "Automatically resolves to the lowest possible wavelength (190 Nanometer) if MaxWavelength is specified, otherwise resolves to Null.",
			Category -> "Method"
		},
		{
			OptionName -> TemperatureMonitor,
			Default -> CuvetteBlock,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration,Pattern :> Alternatives[CuvetteBlock, ImmersionProbe]],
			Description -> "Which device (probe or block) will be used to monitor temperature during the Experiment.",
			Category -> "Method"
		},
		{
			OptionName -> BlankMeasurement,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
			Description -> "Indicates if for each pooled sample, a corresponding blank measurement with buffer only will be performed, prior to the absorbance thermodynamics run of the pooled sample.",
			(* "Whether or not blank measurements will be taken for each cuvette with buffer only before the absorbance thermodynamics run begins.", *)
			Category -> "Method"
		},

		IndexMatching[
			IndexMatchingInput->"experiment samples",
			(* POOLED OPTIONS - these are indexmatched to each pool (= cuvette) and not each sample *)
			{
				OptionName->Blank,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Object[Sample]}]],
				Description->"The source used to generate a blank sample whose absorbance is subtracted as background from the absorbance readings of the input sample.",
				ResolutionDescription->"Automatically set to Null if BlankMeasurement is False, or to the value of AssayVolume if that was specified and BlankMeasurement is True, or Model[Sample, \"Milli-Q water\"] otherwise.",
				Category->"Method"
			},
			(* mixing of the pool *)
			{
				OptionName -> NestedIndexMatchingMix,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration,Pattern :> BooleanP],
				Description -> "Indicates if mixing of the pooled samples occur inside the cuvette.",
				ResolutionDescription -> "Automatically set based on whether pooling and/or dilution of the source samples will be performed.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingMixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> (Pipette|Invert)],
				Description -> "Indicates the style of motion used to mix the pooled samples inside the cuvette.",
				ResolutionDescription -> "Automatically set to Pipette if the cuvette aperture and available tip types allow for mixing by pipette, otherwise set to Invert.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingNumberOfMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Number, Pattern :> RangeP[1, 50, 1]],
				Description ->  "The number of times each pooled sample is mixed by pipetting or inversion.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingMixVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Microliter, 50 Milliliter],Units :> {1,{Milliliter,{Microliter,Milliliter}}}],
				Description -> "The volume of each pooled sample that is pipetted up and down to mix.",
				Category->"Sample Preparation"
			},

			(* incubation of the pools (annealing) *)
			{
				OptionName -> NestedIndexMatchingIncubate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if thermal incubation of the pooled samples occur prior to measurement.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> PooledIncubationTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[1 Minute,$MaxExperimentTime], Units :> {1,{Hour,{Second,Minute,Hour}}}],
				Description -> "Duration for which the pooled samples are thermally incubated prior to measurement.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingIncubationTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> RangeP[22 Celsius, 90 Celsius],Units :> Celsius],
					Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
				],
				Description -> "Temperature at which the pooled samples are thermally incubated prior to measurement.",
				Category->"Sample Preparation"
			},
			{
				OptionName -> NestedIndexMatchingAnnealingTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Quantity,Pattern:>RangeP[0 Minute, $MaxExperimentTime],Units :> Alternatives[Second,Minute,Hour]],
				Description -> "Duration for which the pooled samples remain in the thermal incubation instrument before being removed, allowing the system to settle to room temperature after the PooledIncubationTime has passed.",
				Category->"Sample Preparation"
			},
			{
				OptionName->ContainerOut,
				Default->Automatic,
				Description->"The desired container generated samples should be transferred into by the end of the experiment, with indices indicating grouping of samples in the same plates.",
				ResolutionDescription -> "Automatically set as the PreferredContainer for the total volume of the pooled samples.",
				AllowNull->True,
				Category->"Sample Storage",
				Widget->Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Container], Object[Container]}],
						ObjectTypes -> {Model[Container], Object[Container]}
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
								ObjectTypes -> {Model[Container], Object[Container]}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}
				]
			}

		(* THERE ARE NO INDEX-MATCHED OPTIONS TO THE SAMPLES (otherwise they would go here) *)

		],
		(* Shared options *)
		NonBiologyFuntopiaSharedOptionsPooled,
		SubprotocolDescriptionOption,
		SimulationOption,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		ModifyOptions[
			ModelInputOptions,
			{
				{
					OptionName -> PreparedModelAmount,
					NestedIndexMatching -> True
				},
				{
					OptionName -> PreparedModelContainer,
					NestedIndexMatching -> True,
					ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Cuvette, \"Micro Scale Black Walled UV Quartz Cuvette\"]."
				}
			}
		],
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			AllowNull -> True,
			Widget-> Widget[Type->Number,Pattern:>GreaterEqualP[2,1]],
			Description -> "The number of times to repeat the experiment on each sample or list of samples, if provided. Note that if Aliquot -> True, this indicates the number of times each provided sample will be aliquoted/pooled into a cuvette before each pool is read once.",
			Category -> "Method"
		}
	}
];

(* Pre-option resolution errors *)
Error::MismatchingNestedIndexMatchingdMixOptions="For the following sample(s) or sample pool(s), `1`, NestedIndexMatchingMix is set to False, even though the mixing parameters `2` were specified to `3`. Please set NestedIndexMatchingMix to True or do not specify the mixing parameters.";
Error::NestedIndexMatchingMixVolumeNotCompatibleWithMixType="For the following sample(s) or sample pool(s), `1`, NestedIndexMatchingMixType was set to `2`, while NestedIndexMatchingMixVolume was specified to `3`. NestedIndexMatchingMixVolume cannot be Null if mixing by Pipette, and cannot be a volume, if mixing by Invert. Please set PoolMixType to `4` or adjust the value PoolMixVolume (or leave Automatic).";
Error::MismatchingNestedIndexMatchingIncubateOptions="For the following sample(s) or sample pool(s), `1`, NestedIndexMatchingIncubate is set to False, even though the incubation parameters `2` were specified to `3`. Please set NestedIndexMatchingIncubate to True or do not specify the incubation parameters.";
Error::MismatchingWavelengthOptions="The option Wavelength has been specified (`1`) along with either MinWavelength (`2`) or MaxWavelength (`3`). Please specified either a single wavelength or a min/max range.";
Error::InvalidWavelengthRange="The option MinWavelength has been specified to `1` which is greater than the MaxWavelength (`2`). Please modify the range such that MinWavelength is smaller or equal to MaxWavelength.";
Error::IncompatibleSpectrophotometer="The chosen Spectrophotometer `1` does not have UV/Vis capabilities; therefore, cannot be used for this measurement. Consider using Model[Instrument, Spectrophotometer, \"Cary 3500\"] or any instrument whose Model's 'ElectromagneticRange' contains UV.";
Error::IncompatibleCuvette="For the following sample(s) or sample pool(s), `1`, the option AliquotContainer is set to a cuvette that is not compatible with this experiment. Please specify one of the following cuvette , `2`, or leave this option Automatic.";
Error::NestedIndexMatchingVolumeOutOfRange="For the following sample(s) or sample pool(s), `1`, the specified or projected total volume(s) of the pool including buffers (`2`) cannot be read reliably in any of the available cuvettes. Please consult the experiment function's documentation for a list of available cuvettes and their working ranges.";
Error::SamplesOutStorageConditionConflict="For the following sample(s) or sample pool(s), `1`, the SamplesOutStorageCondition was set to Disposal while the ContainerOut was also specified (`2`). Please set SamplesOutStorageCondition to SampleStorageTypeP or only set ContainerOut for samples that are not being disposed.";
(* Post-option resolution errors *)
Error::TooManyUVMeltingSamples="The maximum number of input samples (including any replicates) for this experiment is `1`, but the number specified are `2`. Please consider splitting this measurement into multiple protocols or adjusting your NumberOfReplicates option, if specified.";
Warning::TransferRequired="The container of the input sample(s) `1` does not fit on the cuvette block of the spectrophotometer `2`, therefore the sample is going to be transferred into `3`. If you wish to avoid this transfer, please move the sample(s) to a cuvette prior to the experiment. Please refer to the documentation for a list of compatible containers.";
Warning::NestedIndexMatchingVolumeBelowMinThreshold="For the input sample(s) `1`, the total volume of the pooled sample(s) and buffer(s), `2`, is below the minimum volume at which the chosen AliquotContainer, `3`, can be reliably read (`4`). If you wish to acquire data within the recommended working range, specify a smaller AliquotContainer or leave this option Automatic. Please refer to the documentation for a list of available cuvettes and their working volumes.";
Error::UnableToBlank="The option BlankMeasurement was set to True, however the following sample(s), `1` are not being being aliquotted either because Aliquot was set to False or they are in cuvettes compatible with the instrument. Blanking can only be performed if samples are being aliquotted and diluted with buffer inside a new cuvette. Please turn BlankMeasurement to False or Automatic or modify your options such that blanking is possible.";
Error::InsufficientBufferForBlanking="The option BlankMeasurement was set to True, however the buffers of the following sample(s), `1` amount to volume(s) `2`  which will not reach above minimal read height of the cuvettes (`3`). Please increase the buffer or assay volumes or turn BlankMeasurement to False / Automatic.";
Error::ContainerOutStorageConditionConflict="The following sample(s) or sample pool(s), `1`, will be stored in the same ContainerOut plate, however multiple StorageConditions were specified for the SamplesOut (`2`). Please specify identical SamplesOutStorageCondition values for these inputs, or if you wish to store the samples in different plates, use the index syntax {1, plate} to indicate which samples should be stored together.";
Warning::NoMixingDespiteAliquotting="For the following sample(s) or sample pool(s), `1`, NestedIndexMatchingMix was set to False although pooling or aliquotting into a cuvette is taking place. Mixing samples after aliquotting is recommended to ensure a homogeneous solution for the absorbance measurement. If you would like to mix these samples after aliquotting, turn NestedIndexMatchingMix to True or leave it Automatic.";
Error::NumberOfReplicatesRequiresAliquoting="The NumberOfReplicates option is specified, but the Aliquot option has been set to False. Setting NumberOfReplicates in ExperimentUVMelting requires Aliquot -> True.";
Error::UVMeltingIncompatibleBlankOptions = "The specified blank options (Blank and BlankMeasurement) are incompatible with each other.  Blank may only be specified if BlankMeasurement -> True, and must not be specified if BlankMeasurement -> False.";

(* ::Subsubsection::Closed:: *)
(*ExperimentUVMelting Experiment function*)


(* Overload for mixed input like {s1,{s2,s3}} -> We assume the first sample is going to be inside a pool and turn this into {{s1},{s2,s3}} *)
ExperimentUVMelting[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample],Object[Container],Model[Sample]}],_String,{LocationPositionP,_String|ObjectP[Object[Container]]}]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,listedInputs,outputSpecification,output,gatherTests,containerToSampleResult,containerToSampleOutput,containerToSampleSimulation,
		containerToSampleTests,samples,sampleOptions,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,listedSamples,defineAssociations,definedContainerRules,prepPrim,contentsPerDefinedContainerObject,uniqueSampleTransfersPerDefinedContainer,
		totalSampleCountsPerDefinedContainerRules,totalSampleCountsPerDefinedContainer,prepUnitOperations,labelContainerPrimitives},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* in the next step we will be wrapping a list around any single sample inputs except plates. in order to not pool all the samples in a Defined container that has more than one sample, we need to get the containers for the defined inputs and wrap a list only around ones that do not have more than one sample in them.*)
	prepPrim = Lookup[listedOptions,PreparatoryUnitOperations];
	defineAssociations = Cases[prepPrim, DefineP]/. Define -> Sequence;

	prepUnitOperations = Lookup[ToList[myOptions],PreparatoryUnitOperations];
	labelContainerPrimitives = If[MatchQ[prepUnitOperations, _List],
		Cases[prepUnitOperations, _LabelContainer],
		{}
	];

	definedContainerRules = Join[
		If[MatchQ[defineAssociations,{}|Null],
			{},
			MapThread[#1->#2&,{Lookup[defineAssociations,Name],Lookup[defineAssociations,Container]}]
		],
		If[MatchQ[labelContainerPrimitives,{}|Null],
			{},
			MapThread[#1->#2&,{Lookup[labelContainerPrimitives[[All,1]],Label],Lookup[labelContainerPrimitives[[All,1]],Container]}]
		]
	];

	contentsPerDefinedContainerObject = Association@Thread[
		PickList[Keys[definedContainerRules],Values[definedContainerRules],ObjectP[Object[Container]]] -> Length/@Download[Cases[Values[definedContainerRules],ObjectP[Object[Container]]],Contents]
	];

	uniqueSampleTransfersPerDefinedContainer = Counts@DeleteDuplicates[Cases[Flatten[Lookup[Cases[prepPrim, _?Patterns`Private`transferQ] /. Transfer -> Sequence, Destination], 1], {_String, WellP}]][[All, 1]];

	totalSampleCountsPerDefinedContainerRules = Normal@Merge[{contentsPerDefinedContainerObject,uniqueSampleTransfersPerDefinedContainer},Total];

	totalSampleCountsPerDefinedContainer = ToList[mySemiPooledInputs]/.totalSampleCountsPerDefinedContainerRules;

	(* Wrap a list around any single sample inputs except single plate objects to convert flat input into a nested list *)
	(* Leave any non-list plate objects as single inputs because wrapping list around a single plate object signals pooling of all samples in plate.
	In the case that a user wants to run every sample in a plate independently, the plate object is supplied as a single input.*)
	listedInputs=MapThread[
		If[
			MatchQ[#1, ObjectP[Object[Container,Plate]]] || MatchQ[#2, GreaterP[1]],
			#1, ToList[#1]
		]&,
		{ToList[mySemiPooledInputs],totalSampleCountsPerDefinedContainer}
	];

	(* remove any temporal links *)
	{listedSamples, listedOptions} = removeLinks[listedInputs, ToList[myOptions]];


	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentUVMelting,
			listedSamples,
			listedOptions,
			DefaultPreparedModelContainer -> Model[Container, Cuvette, "id:eGakld01zz3E"] (*"Micro Scale Black Walled UV Quartz Cuvette"*)
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* for each group, mapping containerToSampleOptions over each group to get the samples out *)
	(* ignoring the options, since'll use the ones from from ExpandIndexMatchedInputs *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=pooledContainerToSampleOptions[
			ExperimentUVMelting,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->updatedSimulation
		];

		(* Therefore,we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		{
			Check[
				{containerToSampleOutput,containerToSampleSimulation}=pooledContainerToSampleOptions[
					ExperimentUVMelting,
					mySamplesWithPreparedSamples,
					myOptionsWithPreparedSamples,
					Output-> {Result,Simulation},
					Simulation->updatedSimulation
				],
				$Failed,
				{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
			],
			{}
		}
	];

	(* If we were given an empty container,return early. *)
	If[ContainsAny[containerToSampleResult,{$Failed}],

		(* if containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;
		(* take the samples from the mapped containerToSampleOptions, and the options from expandedOptions *)
		(* this way we'll end up index matching each grouping to an option *)
		ExperimentUVMeltingCore[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

(* This is the core function taking only clean pooled lists of samples in the form -> {{s1},{s2},{s3,s4},{s5,s6,s7}} *)
ExperimentUVMeltingCore[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myOptions:OptionsPattern[ExperimentUVMelting]]:=Module[
	{listedOptions,flatSampleList,outputSpecification,output,gatherTests,safeOps,safeOpsTests,validLengths,
		validLengthTests,templatedOptions,templateTests,inheritedOptions,upload,confirm,canaryBranch,fastTrack,parentProtocol,
		cache,expandedSafeOps,cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,
		collapsedResolvedOptions,resourcePackets,resourcePacketTests,preferredContainers,
		containerOutObjects,containerOutModels,instruments, parentProtocolPacketLists, samplifiedInputPackets,
		preferredContainersPackets,containerOutModelPackets,containerOutObjectPackets,
		specifiedAliquotContainerObjects,specifiedAliquotContainerModels,specifiedInstrumentModels,
		specifiedInstrumentObjects,aliquotContainerObjectPackets,aliquotContainerModelPackets,
		instrumentModelPackets,instrumentPackets,userInstrumentModelPackets,userInstrumentObjectPackets,modelContainerFields,objectContainerFields,objectContainerPacketFields,
		userInstrumentObjectModelPackets,userInstrumentOption,sampleContainerModels,
		allTests,validQ,previewRule,optionsRule,testsRule,resultRule,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,updatedSimulation, objectSamplePacketFields, modelSamplePacketFields,polymerTypePackets,
		listedSamples,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed
	},

	(* Make sure we're working with a list of options *)
	{listedSamples,listedOptions}=removeLinks[ToList[myPooledSamples],ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentUVMelting,
			listedSamples,
			listedOptions
		],
		$Failed,
	 	{Download::ObjectDoesNotExist,Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentUVMelting,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentUVMelting,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];
	
	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];
	
	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentUVMelting,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentUVMelting,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentUVMelting,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentUVMelting,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* get assorted hidden options *)
	{upload,confirm,canaryBranch,fastTrack,parentProtocol,cache} = Lookup[inheritedOptions,{Upload,Confirm,CanaryBranch,FastTrack,ParentProtocol,Cache}];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentUVMelting,{mySamplesWithPreparedSamples},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* all possible containers that the resolver might use; these are cuvettes and also ContainerOut options *)
	preferredContainers=DeleteDuplicates[
		Flatten[{
			PreferredContainer[All,Type->All],
			PreferredContainer[All,Sterile->True,Type->All],
			PreferredContainer[All,LightSensitive->True,Type->All],
			{
				Model[Container, Plate, "96-well 2mL Deep Well Plate"],
				Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]
			},
			absorbanceThermodynamicsAllowedCuvettes
		}]

	];

	(* any container the user provided (in case it's not ont he PreferredContainer list) *)
	containerOutObjects=Cases[ToList[Lookup[safeOps, ContainerOut]],ObjectP[Object]];
	containerOutModels=Cases[Flatten[ToList[Lookup[safeOps, ContainerOut]]],ObjectP[Model]];

	(* any container the user provided (in case it's not on the PreferredContainer list) *)
	specifiedAliquotContainerObjects=Cases[ToList[Lookup[safeOps, AliquotContainer]],ObjectP[Object]];
	specifiedAliquotContainerModels=Cases[Flatten[ToList[Lookup[safeOps, AliquotContainer]]],ObjectP[Model]];


	(* get all liquid handlers capable of doing UVMelting *)
	instruments=Search[Model[Instrument,Spectrophotometer],ElectromagneticRange == UV];

	(* handle any instrument or model instrument provide by the user *)
	userInstrumentOption=OptionValue[Instrument];

	{specifiedInstrumentModels,specifiedInstrumentObjects}= Switch[userInstrumentOption,
		Automatic,{{},{}},
		ObjectP[Model[Instrument]],{{userInstrumentOption},{}},
		ObjectP[Object[Instrument]],{{},{userInstrumentOption}}
	];

	(* to make the download easier, flatten all the samples *)
	flatSampleList=Flatten[mySamplesWithPreparedSamples];

	(* Create the Packet Download syntax for our Object and Model samples. *)

	objectSamplePacketFields=Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence]];
	modelContainerFields=Packet[SamplePreparationCacheFields[Model[Container], Format -> Sequence]];
	objectContainerFields = SamplePreparationCacheFields[Object[Container]];
	objectContainerPacketFields = Packet[Sequence @@ objectContainerFields];

	modelSamplePacketFields=Packet[Model[Flatten[{SamplePreparationCacheFields[Model[Sample]]}]]];

	{
		parentProtocolPacketLists,
		samplifiedInputPackets,
		polymerTypePackets,
		sampleContainerModels,
		preferredContainersPackets,
		aliquotContainerObjectPackets,
		aliquotContainerModelPackets,
		instrumentModelPackets,
		instrumentPackets,
		userInstrumentModelPackets,
		userInstrumentObjectPackets,
		userInstrumentObjectModelPackets,
		containerOutObjectPackets,
		containerOutModelPackets
	}=Quiet[Download[
		{
			(* need to download parentProtocol packet for option resolution such as ImageSample *)
			{parentProtocol},
			flatSampleList,
			flatSampleList,
			flatSampleList,
			preferredContainers,
			specifiedAliquotContainerObjects,
			specifiedAliquotContainerModels,
			instruments,
			instruments,
			specifiedInstrumentModels,
			specifiedInstrumentObjects,
			specifiedInstrumentObjects,
			containerOutObjects,containerOutModels
		},
		Evaluate[{
			(* parent protocol packet *)
			{Packet[All]},
			(* samples *)
			{
				objectSamplePacketFields
			},
      		(*polymertypes*)
			{
				Packet[Analytes[{Object, PolymerType}]],
				Packet[Field[Composition[[All, 2]]][{Object, PolymerType}]]
			},
			(* samples containers models *)
			{Packet[Container[objectContainerFields]]},
			(* preferred containers models *)
			{modelContainerFields},
			(* aliquot container objects *)
			{objectContainerPacketFields},
			(* aliquot container models *)
			{modelContainerFields},
			(* model instruments *)
			{Packet[Name,ElectromagneticRange]},
			(* objects connected to all the models *)
			{Packet[Objects[{Name,Model}]]},
			(* user instrument models *)
			{Packet[Name,ElectromagneticRange]},
			(* user instrument objects *)
			{Packet[Name,Model]},
			(* user instrument objects models *)
			{Packet[Model[{Name,ElectromagneticRange}]]},
			(* containerOut *)
			{objectContainerPacketFields},
			(* continerOut models*)
			{modelContainerFields}

		}],
		Cache->cache,
		Simulation -> updatedSimulation,
		Date -> Now
	],{Download::FieldDoesntExist}];

	cacheBall=DeleteDuplicates[FlattenCachePackets[{parentProtocolPacketLists,cache,samplifiedInputPackets,preferredContainersPackets,aliquotContainerObjectPackets,aliquotContainerModelPackets,containerOutObjectPackets,containerOutModelPackets,instrumentModelPackets,instrumentPackets,userInstrumentModelPackets,userInstrumentObjectPackets,userInstrumentObjectModelPackets,sampleContainerModels}]];

	(* Build the resolved options - check whether we need to return early *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentUVMeltingOptions[mySamplesWithPreparedSamples,expandedSafeOps, Cache->cacheBall, Simulation -> updatedSimulation,Output->{Result,Tests}];
		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],
		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption; if those were thrown, we encountered a failure *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentUVMeltingOptions[mySamplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall, Simulation -> updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentUVMelting,
		resolvedOptions,
		Ignore->ReplaceRule[listedOptions, ContainerOut -> Lookup[resolvedOptions, ContainerOut]],
		Messages->False
	];

	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Flatten[Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests]],
			Options->RemoveHiddenOptions[ExperimentUVMelting,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=If[gatherTests,
		uvMeltingResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Simulation -> updatedSimulation,Output->{Result,Tests}],
		{uvMeltingResourcePackets[mySamplesWithPreparedSamples,templatedOptions,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Simulation -> updatedSimulation],{}}
	];


	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}], _EmeraldTest];

	(* figure out if we are returning $Failed for the Result option *)
	(* if the Output option includes Tests _and_ Result, messages will be suppressed.Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed *)
	(* Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		MatchQ[resourcePackets, $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentUVMelting,collapsedResolvedOptions],
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
	(* Upload the resulting protocol/resource objects; must upload protocol and resource before Status change for UPS' ShippingMaterials changes *)
	resultRule = Result -> If[MemberQ[output, Result] && validQ,
		UploadProtocol[
			resourcePackets,
			Confirm -> confirm,
			CanaryBranch -> canaryBranch,
			Upload -> upload,
			ParentProtocol -> parentProtocol,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,UVMelting],
			Cache->cacheBall,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}
];


(* ::Subsubsection::Closed:: *)
(*resolveExperimentUVMeltingOptions*)


(* ========== resolveExperimentUVMeltingOptions Helper function ========== *)
(* resolves any options that are set to Automatic to a specific value and returns a list of resolved options *)

DefineOptions[
	resolveExperimentUVMeltingOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentUVMeltingOptions[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentUVMeltingOptions]]:=Module[
	{
		outputSpecification,output,flatSampleList,gatherTests,messages,inheritedCache,samplePrepOptions,uvMeltingOptions,
		uvMeltingOptionsAssociation,simulatedSamples,resolvedSamplePrepOptions,samplePrepTests,
		simulatedCache,flatSimulatedSamples,poolingLengths,specifiedInstrumentModels,specifiedInstrumentObjects,
		downloadedPackets,instrumentModelPackets,instrumentObjectPackets,cuvettePackets,samplePackets,
		sampleContainerPackets,sampleModelPackets,sampleContainerModelPackets, uniqueBlankSamples, blankSamplePackets,
		(* from download and down *)
		discardedSamplePackets,discardedInvalidInputs,discardedTest,nonLiquidSamplePackets,nonLiquidSampleInvalidInputs,
		nonLiquidSampleTest,precisionTests,roundedUVMeltingOptions,initialWavelength,initialMinWavelength,initialMaxWavelength,
		initialPooledMix,initialPooledMixType,initialPooledNumberOfMixes,initialPooledMixVolume,initialPooledIncubate,
		initialPooledIncubationTime,initialPooledIncubationTemperature,initialPooledAnnealingTime,
		samplesOutStorageCondition,containersOut,semiResolvedAliquotBool,poolMixMismatch,
		mismatchingPoolMixOptions,mismatchingPoolMixTests,poolMixTypeMismatch,mismatchingPoolMixTypeOptions,
		mismatchingPoolMixTypeTests,poolIncubateMismatch,mismatchingPoolIncubateOptions,mismatchingPoolIncubateTests,
		wavelengthMismatch,mismatchingWavelengthOptions,mismatchingWavelengthTests,wavelengthRangeMismatch,
		mismatchingWavelengthRangeOptions,mismatchingWavelengthRangeTests,unresolvedInstrument,resolvedInstrument,
		badInstrumentOption,badInstrumentTest,unresolvedAliquotContainers,unresolvedAliquotContainerModels,aliquotContainerConflicts,
		badAliquotContainerOptions,badAliquotContainerTests,unresolvedAssayVolumes,simulatedVolume,resolvedTotalVolumes,
		cuvetteMinVolumes,cuvetteMaxVolumes,cuvetteTuples,totalVolumeConflicts,badTotalVolumeOptions,badTotalVolumeTests,
		containerOutConflicts,badContainerOutOptions,	badContainerOutTests,
		(* mapthread and down *)
		resolveAutomaticOption,mapThreadFriendlyOptions,targetContainers,pooledMixes,pooledMixTypes,pooledNumbersOfMixes,pooledMixVolumes,
		pooledMixesIncubates,pooledIncubationTemperatures,pooledIncubationTimes,pooledAnnealingTimes,transferRequiredWarnings,
		taggedContainersOut,noMixDespiteAliquottingWarnings,
		sampleCategory,wavelength,minWavelength,maxWavelength,maxTemperature,minTemperature,numberOfCycles,equilibrationTime,
		temperatureRampOrder,temperatureResolution,temperatureRampRate,temperatureMonitor,blankMeasurement,name,
		confirm,canaryBranch,template,samplesInStorageCondition,cache,operator,parentProtocol,upload,outputOption,email,imageSample,
		numberOfReplicates,resolvedEmail,resolvedImage,groupedContainersOut,resolvedContainerOutGroupedByIndex,
		numContainersPerIndex,invalidContainerOutSpecs,containerOutMismatchedIndexOptions,containerOutMismatchedIndexTest,
		numReservedWellsPerIndex,numWells,numWellsPerContainerRules,numWellsAvailablePerIndex,overOccupiedContainerOutBool,
		overOccupiedContainerOut,overOccupiedAvailableWells,overOccupiedReservedWells,containerOverOccupiedOptions,
		containerOverOccupiedTest,containerOutStorageConditionTuples,groupedContainersOutWithSC,groupedStorageCondition,
		groupedSamples,containerOutStorageConditionConflicts,badStorageConditionOptions,badStorageConditionTests,
		targetContainerPackets,targetContainerMinVolumes,minVolumeConflicts,badMinVolumeOptions,badMinVolumeTests,
		disposalBool,groupedContainersOutWithDisposal,nameValidBool,nameOptionInvalid,nameUniquenessTest,transferRequiredOptions,transferRequiredTests,
		noMixDespiteAliquottingOptions,noMixDespiteAliquottingTests,badBlankMeasurementOption,badBlankMeasurementTest,
		suppliedNumberOfReplicates,numberOfNonAliquottedInputs,numberOfAliquottedInputs,intNumReplicates,numberOfCuvetteSamples,
		tooManySamples,tooManySamplesOptions,tooManySamplesTest,resolveSamplePrepOptionsWithoutAliquot,resolvedAliquotOptions,
		resolvedAliquotOptionsTests,aliquotContainerModels, fastAssoc,
		insufficientBufferForBlankingTest,invalidInputs,invalidOptions,
		resolvedOptions,allTests,resultRule,testsRule,resolvedPostProcessingOptions, maxSamplesPerExperiment, potentialAnalytes, potentialAnalyteTests,
		numReplicatesNoAliquotOptions, numReplicatesNoAliquotTest, modelSamplePacketFields, objectSamplePacketFields, polymerTypePackets,
		potentialAnalytesTypes, separateSamplesAndBlanksQ, blanksInvalidTest, blanksInvalidOptions, resolvedBlanks,
		incompatibleBlanksQ, incompatibleBlanksTest, incompatibleBlanksOptions, updatedSimulation, simulation
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];
	flatSampleList=Flatten[myPooledSamples];

	(* when OptionValue doesn't work we can use this (make sure to call the funciton with the Output option so we can look it up)*)
	(* output=Lookup[ToList[myOptions],Output]; *)
	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our MeasureWeight options from our SamplePrep options. *)
	{samplePrepOptions,uvMeltingOptions}=splitPrepOptions[myOptions];

	(* For the uvMelting options, convert list of rules into an to Association so we can Lookup, Append, Join as usual. *)
	uvMeltingOptionsAssociation = Association[uvMeltingOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentUVMelting,myPooledSamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentUVMelting,myPooledSamples,samplePrepOptions,Cache->inheritedCache,Simulation->simulation,Output->Result],{}}
	];

	simulatedCache=FlattenCachePackets[{inheritedCache, Lookup[First[updatedSimulation], Packets]}];
	fastAssoc = makeFastAssocFromCache[simulatedCache];
	flatSimulatedSamples=Flatten[simulatedSamples];
	poolingLengths=Length/@simulatedSamples;

	(*-- DOWNLOAD CALL --*)
	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence]];
	modelSamplePacketFields=Packet[Model[Flatten[{SamplePreparationCacheFields[Model[Sample]]}]]];

	(* get the unresolved instrument option value *)
	unresolvedInstrument=Lookup[uvMeltingOptionsAssociation,Instrument];

	(* let's resolve here the instrument, because we can *)
	resolvedInstrument=If[MatchQ[unresolvedInstrument, Automatic],
		Model[Instrument, Spectrophotometer, "Cary 3500"],
		unresolvedInstrument
	];

	{specifiedInstrumentModels,specifiedInstrumentObjects}= Switch[resolvedInstrument,
		ObjectP[Model[Instrument,Spectrophotometer]],{{resolvedInstrument},{}},
		ObjectP[Object[Instrument,Spectrophotometer]],{{},{resolvedInstrument}}
	];

	(* Get our unique injection blank for download *)
	uniqueBlankSamples = DeleteDuplicates[Download[Cases[Lookup[myOptions, Blank], ObjectP[Object]], Object]];

	(* Extract the packets that we need from our downloaded cache. *)
	downloadedPackets=Quiet[
		Download[
			{
				flatSimulatedSamples,
				flatSimulatedSamples,
				flatSimulatedSamples,
				flatSimulatedSamples,
				flatSimulatedSamples,
				specifiedInstrumentModels,
				specifiedInstrumentObjects,
				absorbanceThermodynamicsAllowedCuvettes,
				uniqueBlankSamples
			},
			{
				{
					objectSamplePacketFields
				},
				{Packet[Container[{Object,Model,Name,Status,Sterile,TareWeight}]]},
				{modelSamplePacketFields},
				{Packet[Container[Model[{MaxVolume}]]]},
				{
					Packet[Analytes[{Object, PolymerType}]],
					Packet[Field[Composition[[All, 2]]][{Object, PolymerType}]]
				},
				{Packet[ElectromagneticRange]},
				{Packet[Model[{ElectromagneticRange}]]},
				{Packet[Name, MinVolume,MaxVolume]},
				{
					objectSamplePacketFields
				}
			},
			Cache->inheritedCache,
			Simulation -> updatedSimulation,
			Date -> Now
		],
		{Download::FieldDoesntExist}
	];

	(* Deconstruct the downloaded packets *)
	{{samplePackets, sampleContainerPackets, sampleModelPackets, sampleContainerModelPackets}} = Flatten[downloadedPackets[[1 ;; 4]], {3}];
	polymerTypePackets = Flatten[downloadedPackets[[5]]];
	instrumentModelPackets = Flatten[downloadedPackets[[6]]];
	instrumentObjectPackets = Flatten[downloadedPackets[[7]]];
	cuvettePackets = Flatten[downloadedPackets[[8]]];
	blankSamplePackets = Flatten[downloadedPackets[[9]]];

	(*-- INPUT VALIDATION CHECKS --*)

	(* 1. DISCARDED SAMPLES ARE NOT OK *)

	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets=Cases[samplePackets,KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],{},Lookup[discardedSamplePackets,Object]];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messages,Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]]];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[flatSampleList],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[flatSampleList,discardedInvalidInputs],Simulation->updatedSimulation]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],Nothing
	];

	(* 2. SOLID SAMPLES ARE NOT OK *)

	(* Get the samples that are not liquids,cannot filter those *)
	nonLiquidSamplePackets=If[Not[MatchQ[Lookup[#, State], Alternatives[Liquid, Null]]],
		#,
		Nothing
	] & /@ samplePackets;

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs=If[MatchQ[nonLiquidSamplePackets,{}],{},Lookup[nonLiquidSamplePackets,Object]];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs]>0&&messages,
		Message[Error::NonLiquidSample,ObjectToString[nonLiquidSampleInvalidInputs,Simulation->updatedSimulation]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonLiquidSampleInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[nonLiquidSampleInvalidInputs,Simulation->updatedSimulation]<>" have a Liquid State:",True,False]
			];

			passingTest=If[Length[nonLiquidSampleInvalidInputs]==Length[flatSampleList],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[flatSampleList,nonLiquidSampleInvalidInputs],Simulation->updatedSimulation]<>" have a Liquid State:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)

	{roundedUVMeltingOptions,precisionTests}=If[gatherTests,
		OptionsHandling`Private`roundPooledOptionPrecision[
			uvMeltingOptionsAssociation,
			{Wavelength, MinWavelength, MaxWavelength, TemperatureRampRate, EquilibrationTime, TemperatureResolution, MaxTemperature, MinTemperature},
			{1*10^-2 Nanometer,1*10^-2 Nanometer,1*10^-2 Nanometer,10^-1 Celsius / Minute,1*10^-2 Minute,1*10^-1 Celsius,1*10^-1 Celsius,1*10^-1 Celsius},
			Output->{Result,Tests}
		],
		{
			OptionsHandling`Private`roundPooledOptionPrecision[
				uvMeltingOptionsAssociation,
			{Wavelength, MinWavelength, MaxWavelength, TemperatureRampRate, EquilibrationTime, TemperatureResolution, MaxTemperature, MinTemperature},
			{1*10^-2 Nanometer,1*10^-2 Nanometer,1*10^-2 Nanometer,10^-1 Celsius / Minute,1*10^-2 Minute,1*10^-1 Celsius,1*10^-1 Celsius,1*10^-1 Celsius}
			],
			Null
		}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(* lookup the values of the options that we need to do some error checking *)
	{
		initialWavelength,initialMinWavelength,initialMaxWavelength,
		initialPooledMix,initialPooledMixType,initialPooledNumberOfMixes,initialPooledMixVolume,
		initialPooledIncubate,initialPooledIncubationTime,initialPooledIncubationTemperature,initialPooledAnnealingTime,
		samplesOutStorageCondition,containersOut
	}=Lookup[roundedUVMeltingOptions, {
		Wavelength, MinWavelength, MaxWavelength,
		NestedIndexMatchingMix, NestedIndexMatchingMixType, NestedIndexMatchingNumberOfMixes, NestedIndexMatchingMixVolume,
		NestedIndexMatchingIncubate, PooledIncubationTime, NestedIndexMatchingIncubationTemperature, NestedIndexMatchingAnnealingTime,
		SamplesOutStorageCondition,ContainerOut
	}];

	(* The sample prep resolver semi resolves the aliquot options for us so we can determine from that whether we're presumably aliquotting (given user input) *)
	semiResolvedAliquotBool=Lookup[resolvedSamplePrepOptions,Aliquot];

	(* 1. PoolMix VS PoolMix Options Error *)

	(* PoolMix is False when no PoolMix options are specified *)
	poolMixMismatch=MapThread[
		Function[{mix,mixType,numMixes,mixVolume,sampleObject},
			Module[{mixOptionsSpecified,badMixOptions,badMixOptionValues},

				(* figure out which options were specified that shouldn't have *)
				mixOptionsSpecified={MatchQ[mixType,MixTypeP],MatchQ[numMixes,_Integer],MatchQ[mixVolume,VolumeP]};
				badMixOptions=PickList[{NestedIndexMatchingMixType,NestedIndexMatchingNumberOfMixes,NestedIndexMatchingMixVolume},mixOptionsSpecified,True];
				badMixOptionValues=PickList[{mixType,numMixes,mixVolume},mixOptionsSpecified,True];

				Switch[{mix,mixOptionsSpecified},
				(* we're fine if the PoolMix boolean is True or Automatic *)
					{True|Automatic,_},
					Nothing,
				(* If the PoolMix boolean is set to False but we have mix options specified as well, return the sample with the mismatching option value *)
					{False,{___,True,___}},
					{sampleObject,badMixOptions,badMixOptionValues},
					_,
					Nothing
				]
			]
		],
		{initialPooledMix,initialPooledMixType,initialPooledNumberOfMixes,initialPooledMixVolume,simulatedSamples}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	mismatchingPoolMixOptions=If[Length[poolMixMismatch]>0&&messages,
		Message[Error::MismatchingNestedIndexMatchingdMixOptions,
			ObjectToString[poolMixMismatch[[All,1]],Simulation->updatedSimulation],
			poolMixMismatch[[All,2]],
			poolMixMismatch[[All,3]]
		];
		{NestedIndexMatchingMix},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mismatchingPoolMixTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[poolMixMismatch,{}],{},poolMixMismatch[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the NestedIndexMatchingMix related options are not specified when NestedIndexMatchingMix is set to False:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Simulation->updatedSimulation]<>", the NestedIndexMatchingMix related options are not specified when NestedIndexMatchingMix is set to False:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 2. NestedIndexMatchingMixType VS NestedIndexMatchingMixVolume Error *)

	(* NestedIndexMatchingMixType doesn't match NestedIndexMatchingMixVolume *)
	poolMixTypeMismatch=MapThread[
		Function[{mixType,mixVolume,sampleObject},
			Switch[{mixType,mixVolume},
			(* If we're inverting then we can't have a volume *)
				{Invert,VolumeP},
				{sampleObject,mixType,mixVolume,Pipette},
			(* If we're pipetting then we have to have a volume *)
				{Pipette,Null},
				{sampleObject,mixType,mixVolume,Invert},
			(* in all other cases we're ok *)
				_,
				Nothing
			]
		],
		{initialPooledMixType,initialPooledMixVolume,simulatedSamples}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	mismatchingPoolMixTypeOptions=If[Length[poolMixTypeMismatch]>0&&messages,
		Message[Error::NestedIndexMatchingMixVolumeNotCompatibleWithMixType,
			ObjectToString[poolMixTypeMismatch[[All,1]],Simulation->updatedSimulation],
			poolMixTypeMismatch[[All,2]],
			poolMixTypeMismatch[[All,3]],
			poolMixTypeMismatch[[All,4]]
		];
		{NestedIndexMatchingMixVolume,NestedIndexMatchingMixType},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mismatchingPoolMixTypeTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[poolMixTypeMismatch,{}],{},poolMixTypeMismatch[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the NestedIndexMatchingMixVolume is specified when NestedIndexMatchingMixType is set to Pipette and NestedIndexMatchingMixVolume is set to Null if NestedIndexMatchingMixType is set to Invert:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Simulation->updatedSimulation]<>", the NestedIndexMatchingMixVolume is specified when NestedIndexMatchingMixType is set to Pipette and NestedIndexMatchingMixVolume is set to Null if NestedIndexMatchingMixType is set to Invert:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(* 3. PoolIncubate VS PoolIncubate Options Error *)

	(* PoolIncubate is False when no PoolIncubate options are specified *)
	poolIncubateMismatch=MapThread[
		Function[{incubate,temp,time,annealingTime,sampleObject},
			Module[{incubateOptionsSpecified,badIncubateOptions,badIncubateOptionValues},

				(* figure out which options were specified that shouldn't have *)
				incubateOptionsSpecified={MatchQ[temp,TemperatureP],MatchQ[time,TimeP],MatchQ[annealingTime,TimeP]};
				badIncubateOptions=PickList[{NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime},incubateOptionsSpecified,True];
				badIncubateOptionValues=PickList[{temp,time,annealingTime},incubateOptionsSpecified,True];

				Switch[{incubate,incubateOptionsSpecified},
					(* we're fine if the PoolIncubate boolean is True or Automatic *)
					{True|Automatic,_},
					Nothing,
					(* If the NestedIndexMatchingIncubate boolean is set to False but we have incubate options specified as well, return the sample with the mismatching option values *)
					{False,{___,True,___}},
					{sampleObject,badIncubateOptions,badIncubateOptionValues},
					_,
					Nothing
				]
			]
		],
		{initialPooledIncubate,initialPooledIncubationTemperature,initialPooledIncubationTime,initialPooledAnnealingTime,simulatedSamples}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	mismatchingPoolIncubateOptions=If[Length[poolIncubateMismatch]>0&&messages,
		Message[Error::MismatchingNestedIndexMatchingIncubateOptions,
			ObjectToString[poolIncubateMismatch[[All,1]],Simulation->updatedSimulation],
			poolIncubateMismatch[[All,2]],
			poolIncubateMismatch[[All,3]]
		];
		{NestedIndexMatchingIncubate},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mismatchingPoolIncubateTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[poolIncubateMismatch,{}],{},poolIncubateMismatch[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the NestedIndexMatchingIncubate related options are not specified when NestedIndexMatchingIncubate is set to False:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Simulation->updatedSimulation]<>", the NestedIndexMatchingIncubate related options are not specified when NestedIndexMatchingIncubate is set to False:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 4. Wavelength VS Mix/MaxWavelength Error *)

	wavelengthMismatch=Switch[{initialWavelength,initialMinWavelength,initialMaxWavelength},
		(* we're not OK if the Wavelength is specified, while Min (and Max) are as well (note that this covers also the case where both Min and Max are specified *)
		{RangeP[190 Nanometer, 900 Nanometer],RangeP[190 Nanometer, 900 Nanometer],_},
		{initialWavelength,initialMinWavelength,initialMaxWavelength},
		(* we're not OK if the Wavelength is specified, while Max  is as well *)
		{RangeP[190 Nanometer, 900 Nanometer],_,RangeP[190 Nanometer, 900 Nanometer]},
		{initialWavelength,initialMinWavelength,initialMaxWavelength},
		(* we're fine in all other cases - even if only Min or only Max is specified, we will resolve below *)
		_,
		{}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	mismatchingWavelengthOptions=If[Length[wavelengthMismatch]>0&&messages,
		Message[Error::MismatchingWavelengthOptions,
			wavelengthMismatch[[1]],
			wavelengthMismatch[[2]],
			wavelengthMismatch[[3]]
		];
		{Wavelength,MinWavelength,MaxWavelength},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mismatchingWavelengthTests=If[gatherTests,

		If[MatchQ[wavelengthMismatch,{}],
			{Test["The Wavelength option and MinWavelength/MaxWavelength are not specified simultaneously:",True,True]},
			{Test["The Wavelength option and MinWavelength/MaxWavelength are not specified simultaneously:",True,False]}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(* 5. Mix/MaxWavelength Range Error *)

	(* MinWavelength can't be larger than MaxWavelength *)
	wavelengthRangeMismatch=If[!MatchQ[initialMinWavelength,Automatic]&&!MatchQ[initialMaxWavelength,Automatic]&&initialMinWavelength>initialMaxWavelength,
		{initialMinWavelength,initialMaxWavelength},
		{}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	mismatchingWavelengthRangeOptions=If[Length[wavelengthRangeMismatch]>0&&messages,
		Message[Error::InvalidWavelengthRange,
			wavelengthRangeMismatch[[1]],
			wavelengthRangeMismatch[[2]]
		];
		{MinWavelength,MaxWavelength},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mismatchingWavelengthRangeTests=If[gatherTests,

		(* Get the inputs that pass this test. *)
		If[MatchQ[wavelengthRangeMismatch,{}],

			{Test["The specified value for MinWavelength is smaller than MaxWavelength:",True,True]},
			{Test["The specified value for MinWavelength is smaller than MaxWavelength:",True,False]}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 6. Electromagnetic Range Error *)

	(* check whether the user provided option for instrument can do UV/Vis *)
	badInstrumentOption = If[MatchQ[unresolvedInstrument, ObjectP[]],
		Module[{emRange},
			emRange=If[MatchQ[unresolvedInstrument, ObjectP[Object[Instrument,Spectrophotometer]]],
				(* if we were given an object by the user, we lookup the ElectromagneticRange from the object packet*)
				Flatten[Lookup[instrumentObjectPackets,ElectromagneticRange]],
				(* otherwise we know we can get it from the model packet *)
				Flatten[Lookup[instrumentModelPackets,ElectromagneticRange]]
			];
			If[MemberQ[emRange,UV]&&MemberQ[emRange,Visible],{},{Instrument}]
		],{}
	];

	(* throw an error if it's a bad instrument *)
	If[And[Not[MatchQ[badInstrumentOption,{}]],messages],Message[Error::IncompatibleSpectrophotometer, unresolvedInstrument]];

	badInstrumentTest = If[gatherTests,
		Module[{result},
			result=MatchQ[badInstrumentOption,{}];
			Test["The provided instrument " <> ObjectToString[unresolvedInstrument, Simulation -> updatedSimulation] <> " is currently supported for UVMelting:",result,True]
		]
	];


	(* 7. Cuvette Compatibility Error *)

	(* get the containers that were specified by the users - Download the object in case they referenced to it by Name *)
	unresolvedAliquotContainers=Lookup[samplePrepOptions,AliquotContainer];

	(* get the model container of the user specified aliquot container *)
	unresolvedAliquotContainerModels=Map[
		If[MatchQ[#,Automatic],
			Null,
			Which[
				MatchQ[#, ObjectP[Model]],#,
				MatchQ[#, {_Integer,ObjectP[Model]}], Last[#],
				True, fastAssocLookup[fastAssoc,#,Model]
			]
		]&,
		unresolvedAliquotContainers
	];

	(* check whether the AliquotContainers, if specified, are compatible with the instrument. Currently these are hardcoded in 'absorbanceThermodynamicsAllowedCuvettesP' *)
	aliquotContainerConflicts=MapThread[
		Function[{unresolvedAliquotContainer,acModel,sampleObject},
			Switch[unresolvedAliquotContainer,
				(* we're fine if the AliquotContainer is Automatic *)
				Automatic,
				Nothing,
				(* the user may have given us objects, or models *)
				ObjectP[{Object[Container],Model[Container]}],
					If[
						(* we're fine if the AliquotContainer is one of the allowed container models - make sure to Download the Object from it if we were given a Name *)
						MatchQ[Download[acModel,Object],absorbanceThermodynamicsAllowedCuvettesP],
							Nothing,
							{sampleObject,unresolvedAliquotContainer}
					],
				_,
				Nothing
			]
		],
		{unresolvedAliquotContainers,unresolvedAliquotContainerModels,simulatedSamples}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	badAliquotContainerOptions=If[Length[aliquotContainerConflicts]>0&&messages,
		Message[Error::IncompatibleCuvette,
			ObjectToString[aliquotContainerConflicts[[All,1]],Simulation->updatedSimulation],
			ObjectToString[aliquotContainerConflicts[[All,2]],Simulation->updatedSimulation]
		];
		{AliquotContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	badAliquotContainerTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[aliquotContainerConflicts,{}],{},aliquotContainerConflicts[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the AliquotContainer, if specified, is a cuvette supported by this experiment:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Simulation->updatedSimulation]<>",the AliquotContainer, if specified, is a cuvette supported by this experiment:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 8. Total Volume Compatibility Error *)

	(* Get the user-specified Assay Volume *)
	unresolvedAssayVolumes=Lookup[samplePrepOptions,AssayVolume];

	(* Get the volume from the samples (note that we want the nested list {{v1,v2},{v3,v4}}) *)
	simulatedVolume=TakeList[Lookup[#,Volume]&/@samplePackets,poolingLengths];

	(* resolve the total volume we're dealing with, depending on what information we have at hand *)
	resolvedTotalVolumes=MapThread[
		Function[{userAssayVolume,semiResolvedAssayVolume,simulatedSampleVolume},
			If[MatchQ[userAssayVolume,VolumeP],
				(* If an Assay Volume was provided, we just take that. Since the option was expanded in case there are multiple samples to pool, we just take the first *)
				userAssayVolume,
				(* If no Assay Volume was provided, we either use the semi-resolved AssayVolume from the options, or if that is Null because we are not using any buffers, we simply use the volumes of the simulated samples in the pool *)
				If[NullQ[semiResolvedAssayVolume],
					Total[simulatedSampleVolume],
					semiResolvedAssayVolume
				]
			]],
		{unresolvedAssayVolumes,Lookup[resolvedSamplePrepOptions,AssayVolume],simulatedVolume}
	];

	(* get all the MinVolumes from the cuvettes *)
	{cuvetteMinVolumes,cuvetteMaxVolumes}=Transpose[Lookup[cuvettePackets,{MinVolume,MaxVolume}]];

	(* arrange the available cuvettes and their min/max volumes in a transposed list like that {{cuvette,minVol,maxVol}..} since we can use this information further below *)
	cuvetteTuples=Transpose[{absorbanceThermodynamicsAllowedCuvettes,cuvetteMinVolumes,cuvetteMaxVolumes}];

	(* check whether the resolved total volume falls into the range of available cuvettes *)
	totalVolumeConflicts=MapThread[
		Function[{resolvedTotalVolume,sampleObject},
			(* if we can't find any cuvette for this volume, then we need to throw an error below *)
			If[
				MemberQ[
					(* Map over the available cuvettes and return the ones that can hold this working volume, if it doesn't fit, return Null *)
					MapThread[
						If[TrueQ[#2<=resolvedTotalVolume<=#3],
							#1,
							Null]&,
						{absorbanceThermodynamicsAllowedCuvettes,cuvetteMinVolumes,cuvetteMaxVolumes}
					],ObjectP[]
				],
				Nothing,
				{sampleObject,resolvedTotalVolume}
			]
		],
		(* note that we're mapping over the pools - {v1,v2} and {{s1,s2},{s3}} *)
		{resolvedTotalVolumes,simulatedSamples}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	(* we don't want to throw this error if we already have thrown the discarded / non-volume / non-liquid input test *)
	badTotalVolumeOptions=If[Length[totalVolumeConflicts]>0 && messages && !(Length[discardedInvalidInputs]>0) && !(Length[nonLiquidSampleInvalidInputs]>0),
		Message[Error::NestedIndexMatchingVolumeOutOfRange,
			ObjectToString[totalVolumeConflicts[[All,1]],Simulation->updatedSimulation],
			UnitConvert[totalVolumeConflicts[[All,2]],Milliliter]
		];
		{AliquotContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	badTotalVolumeTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[totalVolumeConflicts,{}],{},totalVolumeConflicts[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the total volume of the pools including buffer if specified falls into the working range of the compatible cuvettes:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Simulation->updatedSimulation]<>", the total volume of the pools including buffer if specified falls into the working range of the compatible cuvettes:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* 9. ContainerOut vs SamplesOutStorageCondition *)

	(* check whether the ContainerOut is specified while the SamplesOutStorageCondition is set to Disposal for which we will need to throw an error *)
	containerOutConflicts=MapThread[
		Function[{containerOut,sc,sampleObject},
			If[MatchQ[sc,Disposal]&&!MatchQ[containerOut,Automatic|Null],
				{sampleObject,containerOut},
				Nothing
			]
		],
		{containersOut,samplesOutStorageCondition,simulatedSamples}
	];

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions below *)
	(* we don't want to throw this error if we already have thrown the discarded / non-volume / non-liquid input test *)
	badContainerOutOptions=If[Length[containerOutConflicts]>0 && messages,
		Message[Error::SamplesOutStorageConditionConflict,
			ObjectToString[containerOutConflicts[[All,1]],Simulation->updatedSimulation],
			containerOutConflicts[[All,2]]
		];
		{ContainerOut, SamplesOutStorageCondition},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	badContainerOutTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[containerOutConflicts,{}],{},containerOutConflicts[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the SamplesOutStorageCondition is set to Disposal when ContainerOut is not specified:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the input sample(s) "<>ObjectToString[nonPassingInputs,Simulation->updatedSimulation]<>", the SamplesOutStorageCondition is set to Disposal when ContainerOut is not specified:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* small helper to return the user-specified value if provided or resolve the Automatic to a given value *)
	resolveAutomaticOption[option_,valueToResolveTo_]:=Module[{},
		If[MatchQ[option,Automatic],
			valueToResolveTo,
			option
		]
	];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentUVMelting,roundedUVMeltingOptions];

	{
		targetContainers,
		pooledMixes,
		pooledMixTypes,
		pooledNumbersOfMixes,
		pooledMixVolumes,
		pooledMixesIncubates,
		pooledIncubationTemperatures,
		pooledIncubationTimes,
		pooledAnnealingTimes,
		transferRequiredWarnings,
		taggedContainersOut,
		noMixDespiteAliquottingWarnings
	}=Transpose[
		MapThread[
			Function[{samplesInPool,uvMeltingOptions,unresolvedAliquotContainer,unresolvedAliquotContainerModel,resolvedAssayVolume,sampleContainerPacket,aliquotBool},
				Module[{poolSize,transferRequiredWarning,noMixDespiteAliquottingWarning, unresolvedPooledMix,unresolvedPooledMixType,
					unresolvedPooledNumberOfMixes,unresolvedPooledMixVolume,unresolvedContainerOut,samplesOutStorageCondition,
					unresolvedPooledIncubate,unresolvedPooledIncubationTemperature,unresolvedPooledIncubationTime,unresolvedPooledAnnealingTime,
					resolveTargetContainer,sampleContainerModels,targetContainer,targetContainerModel,
					calculateMixVolume,presumedMixingBool,gelloadingTipsOnlyCuvette,analyteContainerModel, resolvedPooledMix,resolvedPooledMixType,resolvedPooledNumbersOfMixes,
					resolvedPooledMixVolume,presumedIncubationBool,resolvedPooledMixesIncubate,resolvedPooledIncubationTemperature,resolvedPooledIncubationTime,
					resolvedPooledAnnealingTime,containerTag,unTaggedContainer,resolvedContainerOut,taggedResolvedContainerOut
				},

					(* the size of the pool we're currently mapping over *)
					poolSize=Length[samplesInPool];

					(* Setup our error tracking variables *)
					{transferRequiredWarning,noMixDespiteAliquottingWarning}={False,False};

					(* Lookup the unresolved option values that we're going to resolve below *)
					{
						unresolvedPooledMix,unresolvedPooledMixType,unresolvedPooledNumberOfMixes,unresolvedPooledMixVolume,
						unresolvedPooledIncubate,unresolvedPooledIncubationTemperature,unresolvedPooledIncubationTime,unresolvedPooledAnnealingTime,
						unresolvedContainerOut,samplesOutStorageCondition
					}=Lookup[uvMeltingOptions,{
						NestedIndexMatchingMix,NestedIndexMatchingMixType,NestedIndexMatchingNumberOfMixes,NestedIndexMatchingMixVolume,
						NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime,
						ContainerOut,SamplesOutStorageCondition
					}];

					(*-- 1. TARGET CONTAINER RESOLUTION --*)

					(* Small helper that returns a suitable target container cuvette for a given assay volume *)
					resolveTargetContainer[volume:(VolumeP|Null),myCuvetteTuples:{{ObjectP[],VolumeP,VolumeP}..},myContainerPacket:{PacketP[]..}]:=Module[{resolvedVolume,cuvette},

						(* If the volume is Null, we still want to return a valid target container, even if we're throwing errors. Therefore default to the MaxVolume of the container that the sample is currently in *)
						resolvedVolume=If[NullQ[volume],Max[Lookup[myContainerPacket,MaxVolume]],volume];

						(* the tuples are of the shape {{cuvette,minVol,maxVol}..} - we return the first (smallest) cuvette for which the given volume falls into the min-max range. If we are pooling from multiple sample, we will use the largest container for this *)
						cuvette=SelectFirst[
							myCuvetteTuples,
							#[[2]] <= resolvedVolume <= #[[3]]&
						][[1]];

						(* we have to account for assay volumes that fall outside of the working range of the available cuvettes, in which case this returns NotFound *)
						(* return Null in these cases - we've already thrown an error above (AssayVolumeOutOfRange) *)
						If[!MatchQ[cuvette,ObjectP[{Object[Container],Model[Container]}]],
							Null,
							cuvette
						]

					];

					(* get the model of the containers that the samples to be pooled are currenlty in - note this is a list since we are pooling but it can be a list of 1 container model if we're dealing with a single sample *)
					sampleContainerModels=Lookup[sampleContainerPacket,Object];

					(* big switch statement to decide whether we're using a transfer container and if so, which one *)
					{targetContainer,transferRequiredWarning}=Switch[{aliquotBool,unresolvedAliquotContainer,unresolvedAliquotContainerModel,poolSize,sampleContainerModels},

						(* if AliquotContainer is user-specified but its model is incompatible with the spectrophotometer, we resolve the targetContainer to something reasonably *)
						(* since we've already thrown the invalid option error above (Error::IncompatibleCuvette), no need to set any error variable here *)
						{_,Except[Automatic],Not[absorbanceThermodynamicsAllowedCuvettesP],_,_},
							{resolveTargetContainer[resolvedAssayVolume,cuvetteTuples,sampleContainerPacket],transferRequiredWarning},

						(* in all other cases where AliquotContainer is specified we can use that as TargetContainer - the aliquot resolver will bark if the volumes won't fit *)
						{_,ObjectP[{Object[Container],Model[Container]}],_,_,_}, {unresolvedAliquotContainer,transferRequiredWarning},

						(* If our container is an index model, get the container model part only *)
						{_,{_Integer,ObjectP[Model[Container]]},_,_,_}, {unresolvedAliquotContainer[[2]],transferRequiredWarning},

						(* if AliquotContainer is Automatic, and we're dealing with a pool of samples (pool size larger than 1), we can safely resolve to a suitable target container *)
						{_,Automatic,Null,Except[1],_}, {resolveTargetContainer[resolvedAssayVolume,cuvetteTuples,sampleContainerPacket],transferRequiredWarning},

						(* some aliquot parameter was specified -- AliquotContainer is Automatic, and there is only a single sample in the pool, and the sample's container is compatible with the spectrophotometer,assume the user wants to aliquot and we resolve to a suitable target container *)
						(* we don't throw the transfer warning since the user speicifed an aliquot option soe he/she is aware of it *)
						{True,Automatic,_,1,{absorbanceThermodynamicsAllowedCuvettesP}}, {resolveTargetContainer[resolvedAssayVolume,cuvetteTuples,sampleContainerPacket],transferRequiredWarning},

						(* NO aliquot parameter was specified -- AliquotContainer is Automatic, and there is only a single sample in the pool, and the sample's container is compatible with the spectrophotometer, we set targetContainer to Null since no aliquotting is required *)
						{False,Automatic,_,1,{absorbanceThermodynamicsAllowedCuvettesP}}, {Null,transferRequiredWarning},

						(* some aliquot parameter was specified --  AliquotContainer is Automatic, and there is only a single sample in the pool, we simply find a suitable cuvette, no warning required *)
						{True,Automatic,_,1,Except[{absorbanceThermodynamicsAllowedCuvettesP}]}, {resolveTargetContainer[resolvedAssayVolume,cuvetteTuples,sampleContainerPacket],transferRequiredWarning},

						(* NO aliquot parameter was specified -- AliquotContainer is Automatic, and there is only a single sample in the pool, but the sample's container model is not compatible with the spectrophotometer, and no aliquoting option is specified, we find a suitable cuvette and switch the warning variable *)
						(* note that we do not trigger the transferRequiredWarning if we don't have a targetContainer or don't have a volume since then that warning message does not make sense. We will for sure have thrown other error messages *)
						{False,Automatic,_,1,Except[{absorbanceThermodynamicsAllowedCuvettesP}]}, {resolveTargetContainer[resolvedAssayVolume,cuvetteTuples,sampleContainerPacket],If[NullQ[resolvedAssayVolume]||NullQ[resolveTargetContainer[resolvedAssayVolume,cuvetteTuples,sampleContainerPacket]],False,True]},

						(* a catch-all for any other nonsense combination *)
						_,{Null,transferRequiredWarning}

					];

					(* below we need to know the model of the cuvette; need to get from cache in case the user gave us an object cuvette *)
					targetContainerModel=If[NullQ[targetContainer],
						Null,
						If[MatchQ[targetContainer,ObjectP[Model[Container]]],
							targetContainer,
							fastAsscLookup[fastAssoc,targetContainer,Model]
						]
					];

					(*-- 2. POOLED MIX OPTIONS RESOLUTION --*)

					(* small helper to calculate the MixVolume to pipet up and down the pooled samples *)
					calculateMixVolume[myAssayVolume:VolumeP,myMixContainer_]:=Module[{halfAssayVolume},
						halfAssayVolume=myAssayVolume/2;
						If[MatchQ[myMixContainer,gelloadingTipsOnlyCuvette],
							(* if we're dealing with the smallest cuvette, we know whe can't use more than 200ul *)
							200*Microliter,
							(* in all other cases, 400*Microliter is fine, or half the assay volume, whichever smaller *)
							Min[halfAssayVolume,400*Microliter]
						]
					];

					(* decide whether the user wants to mix by checking whether any of the mixing parameters were provided *)
					presumedMixingBool=Or[
						poolSize>1,
						MatchQ[unresolvedPooledMix,True],
						MatchQ[aliquotBool,True],
						MatchQ[unresolvedPooledMixType,Invert|Pipette],
						MatchQ[unresolvedPooledNumberOfMixes,_Integer],
						MatchQ[unresolvedPooledMixVolume,VolumeP]
					];

					(* specify the cuvette that needs to use the special gel-loading tips when mixing by pipetting *)
					gelloadingTipsOnlyCuvette=Model[Container, Cuvette, "id:eGakld01zz3E"];

					(* either we're aliquotting into a new cuvette (targetContainer), or we're given a single container which fits on the spectrophotometer in which case there is only one container model inside the list 'sampleContainerModels' *)
					analyteContainerModel=If[NullQ[targetContainerModel],First[sampleContainerModels],targetContainer];

					(* Make a huge Switch to resolve all the mixing related options if not already specified *)
					{resolvedPooledMix,resolvedPooledMixType,resolvedPooledNumbersOfMixes,resolvedPooledMixVolume}=Switch[{unresolvedPooledMix,presumedMixingBool,unresolvedPooledMixType,unresolvedPooledMixVolume,analyteContainerModel},

						(* Mix is user-specified to False, then set all the mix related options to Null unless already specified (note that we've thrown invalid option errors above if the values are not OK *)
						{False,_,_,_,_}, {False,resolveAutomaticOption[unresolvedPooledMixType,Null],resolveAutomaticOption[unresolvedPooledNumberOfMixes,Null],resolveAutomaticOption[unresolvedPooledMixVolume,Null]},

						(* Mix or any mix related option is user-specified, and MixType is specified to Invert *)
						{True|Automatic,True,Invert,_,_}, {True,unresolvedPooledMixType,resolveAutomaticOption[unresolvedPooledNumberOfMixes,10],resolveAutomaticOption[unresolvedPooledMixVolume,Null]},

						(* Mix or any mix related option is user-specified and MixType is specified to Pipette, and MixVolume is specified *)
						{True|Automatic,True,Pipette,VolumeP,_}, {True,unresolvedPooledMixType,resolveAutomaticOption[unresolvedPooledNumberOfMixes,10],unresolvedPooledMixVolume},

						(* Mix or any mix related option is user-specified and MixType is specified to Pipette, but we don't have MixVolume *)
						{True|Automatic,True,Pipette,Except[VolumeP],_}, {True,unresolvedPooledMixType,resolveAutomaticOption[unresolvedPooledNumberOfMixes,10],calculateMixVolume[resolvedAssayVolume,analyteContainerModel]},

						(* Mix or any mix related option is user-specified and MixType is NOT specified, and we have MixVolume, that means we resolve to Pipette *)
						{True|Automatic,True,Automatic,VolumeP,_}, {True,Pipette,resolveAutomaticOption[unresolvedPooledNumberOfMixes,10],unresolvedPooledMixVolume},

						(* Mix or any mix related option is user-specified and MixType is  NOT specified, and we don't have MixVolume,
							and the analyte container is the smallest cuvette, we resolve to Pipette and set the NumberOfMixes to 20, and the Volume to 200ul which is the max volume of the gel-loading pipet tip that fits into the cuvette *)
						{True|Automatic,True,Automatic,Except[VolumeP],gelloadingTipsOnlyCuvette}, {True,Pipette,resolveAutomaticOption[unresolvedPooledNumberOfMixes,15],resolveAutomaticOption[unresolvedPooledMixVolume,200*Microliter]},

						(* Mix or any mix related option is user-specified and MixType is  NOT specified, and we don't have MixVolume, and the analyte container is NOT a cuvette model we currently don't have a pipet for, we resolve to Pipette *)
						{True|Automatic,True,Automatic,Except[VolumeP],Except[gelloadingTipsOnlyCuvette]}, {True,Pipette,resolveAutomaticOption[unresolvedPooledNumberOfMixes,10],calculateMixVolume[resolvedAssayVolume,analyteContainerModel]},

						(* Mix and none of the mix related option was user-specified, then all options resolve to Null if needed *)
						{Automatic,False,_,_,_}, {False,resolveAutomaticOption[unresolvedPooledMixType,Null],resolveAutomaticOption[unresolvedPooledNumberOfMixes,Null],resolveAutomaticOption[unresolvedPooledMixVolume,Null]},

						(* a catch-all for any other nonsense combination *)
						_,{False,Null,Null,Null}

					];

					(* if we were given Mix -> False (due to the option combination given) but are aliquotting then we will throw a warning below *)
					noMixDespiteAliquottingWarning=If[ !resolvedPooledMix && aliquotBool,
						True,
						False
					];

					(*-- 3. POOLED INCUBATE OPTIONS RESOLUTION --*)

					presumedIncubationBool=MatchQ[unresolvedPooledIncubate,True]||MatchQ[unresolvedPooledIncubationTime,TimeP]||MatchQ[unresolvedPooledIncubationTemperature,TemperatureP]||MatchQ[unresolvedPooledAnnealingTime,TimeP];

					(* Make a Switch to resolve all the Incubation related options if not already specified *)
					{resolvedPooledMixesIncubate,resolvedPooledIncubationTemperature,resolvedPooledIncubationTime,resolvedPooledAnnealingTime}=Switch[{unresolvedPooledIncubate,presumedIncubationBool},

						(* Incubate is user-specified to False, then set all the incubate related options to Null unless already specified (note that we've thrown invalid option errors above if the values are not OK *)
						{False,_}, {False,resolveAutomaticOption[unresolvedPooledIncubationTemperature,Null],resolveAutomaticOption[unresolvedPooledIncubationTime,Null],resolveAutomaticOption[unresolvedPooledAnnealingTime,Null]},

						(* Incubate or any incubate related option are user-specified, go down the Incubate->True path *)
						{True|Automatic,True}, {True,resolveAutomaticOption[unresolvedPooledIncubationTemperature,85 Celsius],resolveAutomaticOption[unresolvedPooledIncubationTime,5*Minute],resolveAutomaticOption[unresolvedPooledAnnealingTime,3*Hour]},

						(* Incubate is Automatic while none of the incubate related options are set to values, then go down the Incubate->False path *)
						{Automatic,False}, {False,Null,Null,Null},

						(* a catch-all for any other nonsense combination *)
						_,{False,Null,Null,Null,Null}

					];


					(*-- 4. CONTAINER OUT RESOLUTION --*)

					(* keep a record of the tag if there is one *)
					{containerTag,unTaggedContainer}=If[
						ListQ[unresolvedContainerOut],
						{First[unresolvedContainerOut],Last[unresolvedContainerOut]},
						{Automatic,unresolvedContainerOut}
					];

					resolvedContainerOut=Switch[{unTaggedContainer,samplesOutStorageCondition},
						(* if there is no container yet (still Automatic) we find one *)
						{Automatic,Except[Disposal]},PreferredContainer[resolvedAssayVolume],
						(* if we're disposing of the sample in the cuvette, we don't need a ContainerOut; set to Null *)
						{Automatic,Disposal},Null,
						_,unTaggedContainer
					];

					(* construct the final resolved container in the tag syntax {{tag,container}|Null..} *)
					taggedResolvedContainerOut=If[NullQ[resolvedContainerOut],Null,{containerTag,resolvedContainerOut}];

					(* return the single resolved values for this pool we're mapping over *)
					{
						Download[targetContainer,Object],
						resolvedPooledMix,resolvedPooledMixType,resolvedPooledNumbersOfMixes,resolvedPooledMixVolume,
						resolvedPooledMixesIncubate,resolvedPooledIncubationTemperature,resolvedPooledIncubationTime,resolvedPooledAnnealingTime,
						transferRequiredWarning,taggedResolvedContainerOut,noMixDespiteAliquottingWarning
					}
				]
			],
			{myPooledSamples,mapThreadFriendlyOptions,unresolvedAliquotContainers,unresolvedAliquotContainerModels,resolvedTotalVolumes,TakeList[sampleContainerModelPackets,poolingLengths],semiResolvedAliquotBool}
		]
	];

	(*-- RESOLVE NON-INDEX-MATCHED OPTIONS --*)

	(* decide the potential analytes to use; specifying the Analyte here will pre-empt warnings thrown by this function *)
	{potentialAnalytes, potentialAnalyteTests} = If[gatherTests,
		selectAnalyteFromSample[samplePackets,  Simulation -> updatedSimulation, DetectionMethod -> Absorbance, Output -> {Result, Tests}],
		{selectAnalyteFromSample[samplePackets,  Simulation -> updatedSimulation, DetectionMethod -> Absorbance, Output -> Result], Null}
	];
  (*Get the type of polymer from each analyte*)
	potentialAnalytesTypes=If[MatchQ[#,Null],
		Null,
		Lookup[fetchPacketFromCache[#,polymerTypePackets],PolymerType]
	]&/@potentialAnalytes;

  (*catagorize the analyte*)
	sampleCategory=If[MemberQ[potentialAnalytesTypes, DNA|RNA|PNA|GammaLeftPNA|GammaRightPNA|Modification],
		Oligomer,
		None
	];
	(* Resolve the Wavelength dependent options *)
	{wavelength,minWavelength,maxWavelength}=Switch[{initialWavelength,initialMinWavelength,initialMaxWavelength,sampleCategory},

		(* If both the min and max WL were given, we assume the user wants a range. If the user also specified the WL then we will already have thrown an error above *)
		{_,RangeP[190 Nanometer, 900 Nanometer],RangeP[190 Nanometer, 900 Nanometer],_},{resolveAutomaticOption[initialWavelength,Null],initialMinWavelength,initialMaxWavelength},

		(* If we were given the WL, we will assume the user wanted to inform WL *)
		{RangeP[190 Nanometer, 900 Nanometer],_,_,_},{initialWavelength,resolveAutomaticOption[initialMinWavelength,Null],resolveAutomaticOption[initialMaxWavelength,Null]},

		(* We reached this point if we're neither given the WL nor both of the WL ranges. If MinWL is given, we resolve MaxWL *)
		{_,RangeP[190 Nanometer, 900 Nanometer],_,_},{resolveAutomaticOption[initialWavelength,Null],initialMinWavelength,900 Nanometer},

		(* If MaxWL is given, we resolve MinWL *)
		{_,_,RangeP[190 Nanometer, 900 Nanometer],_},{resolveAutomaticOption[initialWavelength,Null],190 Nanometer,initialMaxWavelength},

		(* We've reached this point if none of the WL options were specified. We resolve depending on the type of sample -> if Oligomer, we resolve to 260 nm *)
		{Automatic,Automatic,Automatic,Oligomer},{260 Nanometer,Null,Null},

		(* If the samples are non-Oligomer, we resolve to 280 nm which is default for protein *)
		{Automatic,Automatic,Automatic,_},{280 Nanometer,Null,Null},

		(* a catch-all for any other nonsense combination *)
		_,{280,Null,Null}

	];

	(* pull out all the experiment specific options that have a default value and don't need to get resolved *)
	{maxTemperature, minTemperature, numberOfCycles, equilibrationTime, temperatureRampOrder, temperatureResolution, temperatureRampRate, temperatureMonitor, blankMeasurement} = Lookup[myOptions,
		{MaxTemperature, MinTemperature, NumberOfCycles, EquilibrationTime, TemperatureRampOrder, TemperatureResolution, TemperatureRampRate, TemperatureMonitor, BlankMeasurement}
	];


	(* pull out all the shared options from the input options *)
	{name, confirm, canaryBranch, template, samplesInStorageCondition, cache, operator, parentProtocol, upload, outputOption, email, imageSample,numberOfReplicates} = Lookup[myOptions,
		{Name, Confirm, CanaryBranch, Template, SamplesInStorageCondition, Cache, Operator, ParentProtocol, Upload, Output, Email, ImageSample,NumberOfReplicates}
	];


	(* resolve the Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		email,
		(* If BOTH Upload -> True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[outputOption, Result]],
			True,
			False
		]
	];

	(* Automatic resolves to False for this experiment, or to whatever the ParentProtocol option was *)
	resolvedImage=If[MatchQ[imageSample,Automatic],
		If[MatchQ[parentProtocol,ObjectP[Object[Protocol]]],
			fastAssocLookup[fastAssoc,parentProtocol,ImageSample],
			(* if there is no ParentProtocol, or if the ParentProtocol is a Qualification or Maintenance *)
			False
		],
		imageSample
	];

	(*== grouping of containerOut and affiliated errors ==*)

	(* figure out which samples we be going for Disposal *)
	disposalBool=MatchQ[#, Disposal] & /@ samplesOutStorageCondition;

	(* group the container outs - if the tag is still `Automatic` we resolve that. *)
	(* We only consider samples that are not going to be disposed to not mess with the grouping *)
	groupedContainersOut=groupContainersOut[simulatedCache,PickList[taggedContainersOut,disposalBool,False]];

	(* reconstruct a list of ContainerOut that is indexmatched to the pools where ContainerOut is Null for all pools marked for Disposal *)
	groupedContainersOutWithDisposal=RiffleAlternatives[Table[Null,Count[disposalBool, True]],groupedContainersOut, disposalBool];

	(*-- POST OPTION RESOLUTION ERROR CHECKING --*)

	(* 1) containerOut grouping errors *)

	(* gather the resolved containers out by index - we will do some error checking on those (note that we're not necessarily indexmatched to the pools since we've filtered out samples marked for disposal *)
	resolvedContainerOutGroupedByIndex = GatherBy[groupedContainersOut, #[[1]]&];

	(* get the number of unique containers for each grouping *)
	numContainersPerIndex = Map[
		Function[{containersByIndex},
			Length[DeleteDuplicatesBy[containersByIndex, Download[#[[2]], Object]&]]
		],
		resolvedContainerOutGroupedByIndex
	];

	(* get the invalid container specifications - two different container models cannot be given the same index *)
	invalidContainerOutSpecs = PickList[resolvedContainerOutGroupedByIndex, numContainersPerIndex, Except[1]];

	(* throw an error if there are any indices with multiple different containers *)
	containerOutMismatchedIndexOptions = If[Not[MatchQ[invalidContainerOutSpecs, {}]] && messages,
		(
			Message[Error::ContainerOutMismatchedIndex, invalidContainerOutSpecs];
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

	(* 2) containerOut OverOccupied  *)

	(* get the number of wells that need to be reserved for each index grouping *)
	numReservedWellsPerIndex = Length[#]& /@ resolvedContainerOutGroupedByIndex;

	(* get the max number of wells in each container - for single-well containers that is obviously just 1 *)
	numWells = Map[
		Switch[#,
			ObjectP[Model[Container, Plate]], Experiment`Private`cacheLookup[simulatedCache,#,NumberOfWells],
			ObjectP[Object[Container, Plate]], Experiment`Private`cacheLookup[simulatedCache,#,{Model,NumberOfWells}],
			_, 1
		]&,
		groupedContainersOut[[All, 2]]
	];

	(* get the replace rule for the max number of wells allowed in each container like <| {1,ModelContainerX}->1,{2,ModelPlateY}->96 |> *)
	numWellsPerContainerRules = AssociationThread[groupedContainersOut, numWells];

	(* get the number of wells that available per index *)
	(* doing First because otherwise each index will have Length[#] duplicates *)
	numWellsAvailablePerIndex = Map[First[# /. numWellsPerContainerRules]&,resolvedContainerOutGroupedByIndex];

	(* get the Booleans indicating if the ContainerOut specifications that are requesting more than the allowed number *)
	overOccupiedContainerOutBool = MapThread[#1 > #2&,{numReservedWellsPerIndex, numWellsAvailablePerIndex}];

	(* get the ContainerOut specifications where they're over-specified (and the number of available and requested wells) *)
	overOccupiedContainerOut = PickList[resolvedContainerOutGroupedByIndex, overOccupiedContainerOutBool, True];
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

	(* 3) containerOut and StorageCondition *)

	(* make tuples tagged container, SC, and sample so that we can group below *)
	containerOutStorageConditionTuples =Transpose[{groupedContainersOutWithDisposal,samplesOutStorageCondition, simulatedSamples}];

	(* gather into groups, by containerOut *)
	groupedContainersOutWithSC = GatherBy[containerOutStorageConditionTuples, #[[1]] &];

	(* extract the grouped storage condition, and samples *)
	groupedStorageCondition = groupedContainersOutWithSC[[All, All, 2]];
	groupedSamples = groupedContainersOutWithSC[[All, All, 3]];

	(* if there are more than one storage condition for each storage container, then we have a problem *)
	containerOutStorageConditionConflicts=MapThread[
		If[Length[DeleteDuplicates[#1]]>1,
			{#2,#1},
			Nothing]
		&,{groupedStorageCondition,groupedSamples}
	];

	(* throw an error in case we have a storage condition conflict *)
	badStorageConditionOptions=If[Length[containerOutStorageConditionConflicts]>0 && messages,
		Message[Error::ContainerOutStorageConditionConflict,
			ObjectToString[containerOutStorageConditionConflicts[[All,1]],Simulation->updatedSimulation],
			DeleteDuplicates[containerOutStorageConditionConflicts[[All,2]]]
		];
		{SamplesOutStorageCondition},
		{}
	];

	(* Create the corresponding tests if we're collecting tests *)
	badStorageConditionTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},

		(* Get the inputs that pass this test. *)
			failingInputs=If[MatchQ[containerOutStorageConditionConflicts,{}],{},containerOutStorageConditionConflicts[[All,1]]];
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["For sample(s) or sample pool(s) "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", only one storage condition is provided for each container out:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For sample(s) or sample pool(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>" only one storage condition is provided for each container out:",True,True],
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

	(* 4) targetContainer MinVolume warning *)

	(* Now that we have resolved the target container, we need to do an additional check whether the assay volume falls below the MinVolume of that target container *)
	(* We've errored above if the volume falls within the range of ANY cuvette (badTotalVolume), but we haven't accounted for the case that volume is 0.6ml and the standard cuvette is specified as target container *)

	(* get the model of the target container. Note that we have to account for the case that targetContainer is Null if we've been provided with a cuvette that is suitable for direct measurement *)
	aliquotContainerModels=Map[
		If[NullQ[#],
			Null,
			(* if it's a model, we just take that *)
			Which[
				MatchQ[#,ObjectP[Model[Container]]], #,
				(* indexed container *)
				MatchQ[#, {_Integer,ObjectP[Model]}], Last[#],
				(* if we reached here we have Object[Container] in which case we lookup the model from the cache *)
				True, fastAssocLookup[fastAssoc, #, Model]
			]
		]&,
		targetContainers
	];

	(* for each resolved target container, grab the relevant packet so that we're indexmatched to the pools *)
	targetContainerPackets=Flatten[Map[
		Which[NullQ[#],	Null,
			!MemberQ[absorbanceThermodynamicsAllowedCuvettes,#], Null,
			True,Cases[cuvettePackets,KeyValuePattern[Object -> #]]
			]&,
		aliquotContainerModels
	],1];

	(* get the MinVolume of the target container *)
	targetContainerMinVolumes=If[NullQ[#],Null,Lookup[#,MinVolume]]&/@targetContainerPackets;

	(* check whether the resolved total volume is larger than the provided cuvette MinVolume *)
	(* if we're throwing an error because the aliquotContainer isn't even compatible, we don't care about this *)
	minVolumeConflicts= If[!Length[aliquotContainerConflicts]>0,
		MapThread[
			Function[{resolvedTotalVolume,cuvetteMinVolume,sampleObject,aliquotContainer},
				(* if an AliquotContainer was specified and the assay volume is below the recommended volume of that container, then we need to throw a warning below *)
				If[MatchQ[aliquotContainer,ObjectP[]]&&  (resolvedTotalVolume<cuvetteMinVolume),
					{sampleObject,resolvedTotalVolume,aliquotContainer,cuvetteMinVolume},
					Nothing
				]
			],
			{resolvedTotalVolumes,targetContainerMinVolumes,simulatedSamples,Lookup[myOptions,AliquotContainer]}
		],
		{}
	];

	(* If there is a cuvette whose MinVolume is above the resolved AssayVolume, and we are throwing messages, throw a warning *)
	(* we don't want to throw this warning if we already have thrown the discarded / non-volume / non-liquid input test *)
	badMinVolumeOptions=If[Length[minVolumeConflicts]>0 && messages && !(Length[discardedInvalidInputs]>0) && !(Length[nonLiquidSampleInvalidInputs]>0),
		Message[Warning::NestedIndexMatchingVolumeBelowMinThreshold,
			ObjectToString[minVolumeConflicts[[All,1]],Simulation->updatedSimulation],
			UnitConvert[minVolumeConflicts[[All,2]],Milliliter],
			ObjectToString[minVolumeConflicts[[All,3]],Simulation->updatedSimulation],
			UnitConvert[minVolumeConflicts[[All,4]],Milliliter]
		];
		{AliquotContainer},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	badMinVolumeTests=If[gatherTests,

		(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

			(* Get the inputs that pass this test. *)
			nonPassingInputs=If[MatchQ[minVolumeConflicts,{}],{},minVolumeConflicts[[All,1]]];
			passingInputs=Complement[simulatedSamples,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["For the input sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>", the total volume of the pools including buffer is above the recommended minimum volume threshold of the specified AliquotContainer:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Warning["For the input sample(s) "<>ObjectToString[nonPassingInputs,Simulation->updatedSimulation]<>", the total volume of the pools including buffer is above the recommended minimum volume threshold of the specified AliquotContainer:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(* 6) transferRequiredWarnings *)

	(* Check for transferRequiredWarnings and throw the corresponding Error if we're throwing messages. We don't collect any invalid options for warnings. *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	transferRequiredOptions=If[Or@@transferRequiredWarnings && messages &&!MatchQ[$ECLApplication,Engine],
		Message[Warning::TransferRequired,ObjectToString[PickList[simulatedSamples,transferRequiredWarnings],Simulation->updatedSimulation],ObjectToString[resolvedInstrument,Simulation->updatedSimulation],ObjectToString[PickList[targetContainers,transferRequiredWarnings],Simulation->updatedSimulation]],
		{}
	];

	(* Create the corresponding test for the transferRequiredWarning tests if we're collecting tests *)
	transferRequiredTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},

			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,transferRequiredWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Warning["The sample(s) "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", are in a container compatible with the instrument or the user provided information to transfer. Note that if this is False, the samples will be transferred to a suitable container prior to measurement:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["The sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>"  are in a container compatible with the instrument or the user provided information to transfer. Note that if this is False, the samples will be transferred to a suitable container prior to measurement:",True,True],
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


	(* 7) noMixDespiteAliquottingWarnings *)

	(* Check for noMixDespiteAliquottingWarnings and throw the corresponding Error if we're throwing messages. We don't collect any invalid options for warnings. *)
	(* we only throw this if we're not on Engine since we only want this warning displayed to the user, but not upset Engine *)
	noMixDespiteAliquottingOptions=If[Or@@noMixDespiteAliquottingWarnings && messages &&!MatchQ[$ECLApplication,Engine],
		Message[Warning::NoMixingDespiteAliquotting,
			ObjectToString[PickList[simulatedSamples,noMixDespiteAliquottingWarnings],Simulation->updatedSimulation]
		],
		{}
	];

	(* Create the corresponding test for the noMixDespiteAliquottingWarning tests if we're collecting tests *)
	noMixDespiteAliquottingTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},

			(* Get the inputs that fail this test. *)
			failingInputs=PickList[simulatedSamples,noMixDespiteAliquottingWarnings];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[simulatedSamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Warning["The sample(s) "<>ObjectToString[failingInputs,Simulation->updatedSimulation]<>", are mixed after they've been aliquotted into the cuvette:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Warning["The sample(s) "<>ObjectToString[passingInputs,Simulation->updatedSimulation]<>" are mixed after they've been aliquotted into the cuvette:",True,True],
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

	(* 8. BlankMeasurement not possible error *)

	(* If BlankMeasurement is set to True by the user, but we're not aliquotting all samples, then we need to throw an error *)
	badBlankMeasurementOption= If[blankMeasurement && !MatchQ[targetContainers,{ObjectP[{Object[Container,Cuvette],Model[Container,Cuvette]}]..}],
		{BlankMeasurement},
		{}
	];

	(* throw an error message if we have a bad BlankMeasurement option *)
	If[messages &&!MatchQ[badBlankMeasurementOption,{}],
		Message[Error::UnableToBlank,ObjectToString[PickList[simulatedSamples,targetContainers,Null],Simulation->updatedSimulation]];
	];

	(* make a test for not being able to blank *)
	badBlankMeasurementTest=If[gatherTests,
		Test["If BlankMeasurement is set to True, samples and buffers are being transferred to a cuvette allowing blanking with buffer only prior to addition of the samples:",!MatchQ[badBlankMeasurementOption,{}],False]
	];

	(* 9. TooManySamples error *)

	(* Check if all samples with replicates will fit inside the cuvette block *)
	suppliedNumberOfReplicates=Lookup[roundedUVMeltingOptions,NumberOfReplicates];
	numberOfNonAliquottedInputs=Length[PickList[simulatedSamples,targetContainers,Null]];
	numberOfAliquottedInputs=Length[PickList[simulatedSamples,targetContainers,Except[Null]]];

	(* convert numberOfReplicates such that Null -> 1 *)
	intNumReplicates = numberOfReplicates /. {Null -> 1};

	(* we only need 1 cuvette slot for samples that don't need aliquotting, no matter whether we have NumberOfReplicates set; if we're aliquotting we need to account for NumberOfReplicates *)
	numberOfCuvetteSamples = numberOfNonAliquottedInputs + numberOfAliquottedInputs*intNumReplicates;

	(* somewhat-arbitrarily, the maximum number of samples is 7 here because of the way the instrument and blanking work *)
	maxSamplesPerExperiment = 7;
	tooManySamples = numberOfCuvetteSamples > maxSamplesPerExperiment;

	(*
	Thoughts on NumberOfReplicates:

	1) NumberOfReplicates for samples that don't need aliquotting does not make sense (?) or should we measure twice. TODO: check whether it is possible to scan just one cuvette, and if so how will the Data get attached to the sample?
	2) NumberOfReplicates for samples that need aliquotting means aliquotting multiple times. So we will have multiple cuvettes which are each measured once.

	no matter what, they will appear duplicated in SamplesIn, however the non-aliquotted is the same ID, whereas the aliquotted is a different ID (and different container).
	*)

	(* throw an error if we have too many samples for this spectrophotometer *)
	tooManySamplesOptions = If[tooManySamples && messages,
			Message[Error::TooManyUVMeltingSamples,maxSamplesPerExperiment,numberOfCuvetteSamples];
			{NumberOfReplicates},
		{}
	];

	(* make a test for having too many samples *)
	tooManySamplesTest=If[gatherTests,
		Test["The input samples, and any replicates of those samples, are at or below the maximum number of samples for this instrument (" <> ToString[maxSamplesPerExperiment] <> "):",tooManySamples,False]
	];

	(* 10. Name Uniqueness error *)

	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameValidBool=TrueQ[DatabaseMemberQ[Append[Object[Protocol, UVMelting], name]]];

	(* If the name is invalid, will add it to the list if invalid options later *)
	nameOptionInvalid=If[nameValidBool,Name,Nothing];
	nameUniquenessTest=If[nameValidBool,
		(* Give a failing test or throw a message if the user specified a name that is in use *)
		If[gatherTests,
			Test["The specified name is unique.",False,True],
			Message[Error::DuplicateName,Object[Protocol, UVMelting]];
			Nothing
		],

		(* Give a passing test or do nothing otherwise. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[name],
			Test["The specified name is unique.",False,True],
			Nothing
		]
	];


	(*-- CONTAINER GROUPING RESOLUTION AND ALIQUOTTING --*)

	(* NOTE: usually this piece of code comes after the UNRESOLVABLE OPTION CHECKS.
		In this experiment we need to do some error checking after the aliquot options resolutions, so we move the aliquot resolver up *)
	(* We use 'targetContainers' which was resolved in the big MapThread above *)

	(* Importantly: Remove the semi-resolved aliquot options from the sample prep options, before passing into the aliquot resolver. *)
	resolveSamplePrepOptionsWithoutAliquot=First[splitPrepOptions[resolvedSamplePrepOptions,PrepOptionSets->{IncubatePrepOptionsNew,CentrifugePrepOptionsNew,FilterPrepOptionsNew}]];

	(* Call the aliquot resolver. Get the tests if we're gathering them *)
	{resolvedAliquotOptions,resolvedAliquotOptionsTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentUVMelting,
			myPooledSamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolveSamplePrepOptionsWithoutAliquot],
			RequiredAliquotContainers->targetContainers,
			RequiredAliquotAmounts->Null,
			AliquotWarningMessage->Null,
			Cache->inheritedCache,
			Simulation->updatedSimulation,
			Output -> {Result, Tests}
			],
		{resolveAliquotOptions[
			ExperimentUVMelting,
			myPooledSamples,
			simulatedSamples,
			ReplaceRule[myOptions,resolveSamplePrepOptionsWithoutAliquot],
			RequiredAliquotContainers->targetContainers,
			RequiredAliquotAmounts->Null,
			AliquotWarningMessage->Null,
			Cache->inheritedCache,
			Simulation->updatedSimulation,
			Output->Result],
			{}}
		];

	(* Now that we have resolved our aliquot options we can do our final BlankMeasurement check *)

	(* resolve the Blank option *)
	resolvedBlanks = MapThread[
		Function[{assayBuffer, blank},
			Which[
				MatchQ[blank, ObjectP[]], blank,
				Not[TrueQ[blankMeasurement]], Null,
				MatchQ[assayBuffer, ObjectP[]], assayBuffer,
				True, Null
			]
		],
		{Lookup[resolvedAliquotOptions, AssayBuffer], Lookup[myOptions, Blank]}
	];

	(* determine if the Blank option is incompatible with the BlankMeasurement option *)
	incompatibleBlanksQ = Map[
		Or[
			MatchQ[#, ObjectP[]] && Not[TrueQ[blankMeasurement]],
			NullQ[#] && TrueQ[blankMeasurement]
		]&,
		resolvedBlanks
	];

	(*generate tests for cases where BlankMeasurement is True and Blank is Null, or BlankMeasurement is False and Blank is a value *)
	(* also only actually throw this message if UnableToBlank isn't also getting thrown (since that would be redundant) *)
	incompatibleBlanksTest = If[gatherTests,
		{Test["If BlankMeasurement -> True, Blank does not include a Null; if BlankMeasurement -> False, Blank does not include an object value:",
			incompatibleBlanksQ,
			{False..}
		]}
	];

	(* throw an error if Blank is specified but BlankMeasurement -> False, or Blank is Null but BlankMeasurement -> True *)
	(* also only actually throw this message if UnableToBlank isn't also getting thrown (since that would be redundant) *)
	incompatibleBlanksOptions = If[MemberQ[incompatibleBlanksQ, True] && messages && MatchQ[badBlankMeasurementOption,{}],
		(
			Message[Error::UVMeltingIncompatibleBlankOptions];
			{Blank, BlankMeasurement}
		),
		{}
	];

	(* make sure there are no blanks that are also samples *)
	(* note that in this case I am deliberately NOT using simulated samples since this depends on what the user specifies for the blanks vis a vis the samples they specify *)
	separateSamplesAndBlanksQ = If[MatchQ[resolvedBlanks, ListableP[Null | Automatic] | {}],
		True,
		ContainsNone[Lookup[blankSamplePackets, Object, {}], Lookup[samplePackets, Object]]
	];

	(* generate tests for cases where some of the specified samples are also the specified blanks *)
	blanksInvalidTest = If[gatherTests,
		{Test["None of the provided samples are also provided as Blanks:",
			separateSamplesAndBlanksQ,
			True
		]},
		Null
	];

	(* throw an error if SamplesIn are also appearing in Blanks *)
	blanksInvalidOptions = If[Not[separateSamplesAndBlanksQ] && messages,
		(
			Message[Error::BlanksContainSamplesIn, ObjectToString[Select[Lookup[samplePackets, Object], MemberQ[Lookup[blankSamplePackets, Object], #]&], Simulation -> updatedSimulation]];
			{Blank}
		),
		{}
	];

	(* if NumberOfReplicates is set but Aliquot -> False, throw an error *)
	numReplicatesNoAliquotOptions = If[Not[MatchQ[Lookup[resolvedAliquotOptions, Aliquot], {True..}]] && intNumReplicates > 1 && messages,
		(
			Message[Error::NumberOfReplicatesRequiresAliquoting];
			{NumberOfReplicates, Aliquot}
		),
		{}
	];

	(* make a test for NumberOfReplicates/Aliquot *)
	numReplicatesNoAliquotTest = If[gatherTests,
		Test["If NumberOfReplicates is set, then Aliquot is left Automatic or set to True:",
			Not[MatchQ[Lookup[resolvedAliquotOptions, Aliquot], {True..}]] && intNumReplicates > 1,
			False
		]
	];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,nonLiquidSampleInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		mismatchingPoolMixOptions,
		mismatchingPoolMixTypeOptions,
		mismatchingPoolIncubateOptions,
		mismatchingWavelengthOptions,
		mismatchingWavelengthRangeOptions,
		badInstrumentOption,
		badAliquotContainerOptions,
		badTotalVolumeOptions,
		tooManySamplesOptions,
		nameOptionInvalid,
		badBlankMeasurementOption,
		containerOutMismatchedIndexOptions,
		containerOverOccupiedOptions,
		badContainerOutOptions,
		badStorageConditionOptions,
		numReplicatesNoAliquotOptions,
		blanksInvalidOptions,
		incompatibleBlanksOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs and we're throwing messages. *)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation->updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options and we're throwing messages. *)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONSTRUCT THE RESOLVED OPTIONS AND TESTS OUTPUTS --*)

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* construct the final resolved options. We don't collapse here - that is happening in the main function *)
	resolvedOptions=ReplaceRule[
		uvMeltingOptions,
		Join[
			{
				(* protocol specific resolved single options *)
				Instrument -> resolvedInstrument,
				Wavelength -> wavelength,
				MinWavelength -> minWavelength,
				MaxWavelength -> maxWavelength,

				(* protocol specific resolved multiple options *)
				Blank -> resolvedBlanks,
				NestedIndexMatchingMix -> pooledMixes,
				NestedIndexMatchingMixType -> pooledMixTypes,
				NestedIndexMatchingNumberOfMixes -> pooledNumbersOfMixes,
				NestedIndexMatchingMixVolume -> pooledMixVolumes,
				NestedIndexMatchingIncubate -> pooledMixesIncubates,
				PooledIncubationTime -> pooledIncubationTimes,
				NestedIndexMatchingIncubationTemperature -> pooledIncubationTemperatures,
				NestedIndexMatchingAnnealingTime -> pooledAnnealingTimes,
				ContainerOut-> groupedContainersOutWithDisposal,

				(* default instrument specific options *)
				MaxTemperature -> maxTemperature,
				MinTemperature -> minTemperature,
				NumberOfCycles -> numberOfCycles,
				EquilibrationTime -> equilibrationTime,
				TemperatureRampOrder -> temperatureRampOrder,
				TemperatureResolution -> temperatureResolution,
				TemperatureRampRate -> temperatureRampRate,
				TemperatureMonitor -> temperatureMonitor,
				BlankMeasurement -> blankMeasurement,

				(* shared resolved options *)
				Name->name,
				ImageSample->resolvedImage,
				Email->resolvedEmail
			},
			resolveSamplePrepOptionsWithoutAliquot,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions
		]
	];

	(* combine all the tests together. Make sure we only have tests in the final lists (no Nulls etc) *)
	allTests=Cases[
		Flatten[{
			samplePrepTests,
			discardedTest,
			nonLiquidSampleTest,
			precisionTests,
			mismatchingPoolMixTests,
			mismatchingPoolMixTypeTests,
			mismatchingPoolIncubateTests,
			mismatchingWavelengthTests,
			mismatchingWavelengthRangeTests,
			badInstrumentTest,
			badAliquotContainerTests,
			badTotalVolumeTests,
			badMinVolumeTests,
			nameUniquenessTest,
			transferRequiredTests,
			badBlankMeasurementTest,
			tooManySamplesTest,
			resolvedAliquotOptionsTests,
			insufficientBufferForBlankingTest,
			containerOutMismatchedIndexTest,
			containerOverOccupiedTest,
			badContainerOutTests,
			badStorageConditionTests,
			noMixDespiteAliquottingTests,
			numReplicatesNoAliquotTest,
			blanksInvalidTest,
			incompatibleBlanksTest
		}],
		_EmeraldTest
	];

	(* generate the Result output rule *)
	(* if we're not returning results, Results rule is just Null *)
	resultRule = Result -> If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(* generate the tests rule. If we're not gathering tests, the rule is just Null *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* Return our resolved options and/or tests, as desired *)
	outputSpecification/. {resultRule,testsRule}


];



(* ::Subsubsection::Closed:: *)
(* uvMeltingResourcePackets (private helper)*)


DefineOptions[uvMeltingResourcePackets,
	Options:>{SimulationOption,CacheOption,HelperOutputOption}
];


uvMeltingResourcePackets[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myUnresolvedOptions:{___Rule},myResolvedOptions:{___Rule},myCollapsedResolvedOptions:{___Rule},myOptions:OptionsPattern[]]:=Module[
	{outputSpecification,output,gatherTests,messages,cache,poolLengths,expandedInputs,expandedResolvedOptions,
		resolvedOptionsNoHidden,wavelength,minWavelength,maxWavelength,temperatureRampOrder,equilibrationTime,temperatureRampRate,
		minTemperature,maxTemperature,numberOfCycles,temperatureResolution,temperatureMonitor,numReplicates,blankMeasurement,containersOut,
		aliquotQ,samplesInWithReplicates,aliquotQWithReplicates,aliquotVolumeWithReplicates,sampleVolumesToReserve,
		pairedSamplesInAndVolumes,sampleVolumeRules,sampleResourceReplaceRules,numReplicatesNoNull,
		samplesInResources,containersIn,cuvettes,cuvetteResources,cuvetteRackResource, cuvetteMaxVolumes, cuvetteModelMaxVolumes, blankVolumes,
		containersOutWithReplicates,containersOutResources,estimatedRunTime,cuvetteWasherResource,blowGunResource,
		instrumentResource,sampleVolumes,assayBufferVolumes,concentratedBufferVolumes,bufferDiluentVolumes,
		pooledContainersIn,pooledMix,pooledMixVolume,pooledNumberOfMixes,pooledMixType,pooledIncubate,
		pooledIncubationTemperature,pooledIncubationTime,pooledAnnealingTime, blanks, pooledMixField,pooledIncubateField,
		pooledContainersInWithReplicates,expAssayBufferVolumes,expConcentratedBufferVolumes,expBufferDiluentVolumes,
		expPooledSamplesIn,expPooledMixField,expPooledIncubateField, referenceCuvetteResource, temperatureProbeResource,
		protocolPacket,sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable,frqTests,previewRule,
		optionsRule,testsRule,resultRule, samplesInWithNumReplicates, samplesOutWithNumReplicates, blanksWithNumReplicates,
		pairedBlanksAndVolumes, blankVolumeRules, blankResourceReplaceRules, blankResources, simulation
	},

	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* lookup the cache *)
	cache=Lookup[ToList[myOptions],Cache];
	simulation=Lookup[ToList[myOptions],Simulation];

	(* determine the pool lengths*)
	poolLengths=Map[Length[#]&,myPooledSamples];

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentUVMelting, {myPooledSamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentUVMelting,
		RemoveHiddenOptions[ExperimentUVMelting, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Lookup the experimental values *)
	{wavelength,minWavelength,maxWavelength,temperatureRampOrder,equilibrationTime,temperatureRampRate,
		minTemperature,maxTemperature,numberOfCycles,temperatureResolution,temperatureMonitor,blankMeasurement,containersOut}=Lookup[myResolvedOptions,
		{Wavelength,MinWavelength,MaxWavelength,TemperatureRampOrder,EquilibrationTime,TemperatureRampRate,
		MinTemperature,MaxTemperature,NumberOfCycles,TemperatureResolution,TemperatureMonitor,BlankMeasurement,ContainerOut}
	];

	(* get the number of replicates so that we can expand the fields (samplesIn etc.) accordingly  *)
	(* if NumberOfReplicates -> Null, replace that with 1 for the purposes of the math below *)
	numReplicates=Lookup[expandedResolvedOptions,NumberOfReplicates];
	numReplicatesNoNull =numReplicates /. {Null -> 1};

	aliquotQ=TrueQ[#]& /@ Lookup[expandedResolvedOptions, Aliquot];

	(* == make the resources == *)

	(* get the SamplesIn accounting for the number of replicates *)
	(* note that we Flatten AFTER expanding so that we will have something like {s1,s2,s3,s1,2,s3,s4,s5,s4,s5} (from {{s1,s2,s3},{s4,s5}} *)
	samplesInWithReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		Download[myPooledSamples,Object]
	]];

	(* get aliquotQ index matched with the SamplesIn with replicates *)
	aliquotQWithReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		aliquotQ
	]];

	(* get the aliquotVolume with replicates *)
	aliquotVolumeWithReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		Lookup[expandedResolvedOptions, AliquotAmount]
	],1];

	(* get the sample volumes we need to reserve with each sample, accounting for whether we're aliquoting *)
	sampleVolumesToReserve = Flatten[MapThread[
		Function[{aliquot, volume},
			Which[
				aliquot, volume,
				True, Null
			]
		],
		{aliquotQWithReplicates, aliquotVolumeWithReplicates}
	]];

	(* get the SamplesInStorage and SamplesOutStorage expanded with NumberOfReplicates *)
	samplesInWithNumReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		Lookup[expandedResolvedOptions, SamplesInStorageCondition]
	]];
	samplesOutWithNumReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		Lookup[expandedResolvedOptions, SamplesOutStorageCondition]
	]];

	(* make rules correlating the volumes with each sample in *)
	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	pairedSamplesInAndVolumes = MapThread[#1 -> #2&, {samplesInWithReplicates, sampleVolumesToReserve}];

	(* merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null *)
	sampleVolumeRules = Merge[pairedSamplesInAndVolumes, If[NullQ[#], Null, Total[DeleteCases[#, Null]]]&];

	(* make replace rules for the samples and its resources - if we're aliquotting, we only get the amount that we're using *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[NullQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume]
			]
		],
		sampleVolumeRules
	];

	(* use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesInWithReplicates, sampleResourceReplaceRules, {1}];

	(* create a list of pooled containersIn *)
	pooledContainersIn=TakeList[Map[cacheLookup[cache,#,Container]&,Flatten[myPooledSamples]],poolLengths];

	(* expand the pooled ContainersIn according to the NumberOfReplicates *)
	pooledContainersInWithReplicates=Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		pooledContainersIn
	],1];

	(* extract the containers we're going to aliquot into from the AliquotContainer option, remove the tag *)
	(* if we're not aliquotting, then the cuvette is the container that the sample is currently in *)
	cuvettes=MapThread[
		If[NullQ[#1],
			First[#2],
			#1[[2]]
		]&,
		{Lookup[expandedResolvedOptions, AliquotContainer],pooledContainersInWithReplicates}
	];

	(* TODO I don't love that I'm doing this Download here but need a way to figure it out ASAP and we can reconfigure this better going forward *)
	{cuvetteMaxVolumes, cuvetteModelMaxVolumes} = Transpose[Quiet[Download[
		cuvettes,
		{MaxVolume, Model[MaxVolume]},
		Cache->cache,
		Simulation -> simulation
	], {Download::FieldDoesntExist, Download::NotLinkField}]];
	blankVolumes = MapThread[
		If[VolumeQ[#1],
			#1,
			#2
		]&,
		{cuvetteMaxVolumes, cuvetteModelMaxVolumes}
	];

	(* Make the resources for the cuvettes *)
	cuvetteResources = Map[
		If[NullQ[#],
			Null,
			Resource[Sample->#, Name->ToString[Unique[]], Rent->True]
		]&,
		cuvettes
	];

	(* create the containers in a flat non-duplicate list for the protocol packet *)
	containersIn=DeleteDuplicates[Flatten[pooledContainersIn]];

	(* Set up resource object for cuvette rack *)
	cuvetteRackResource = Resource[Sample -> Model[Container, Rack, "12-position Bel-Art Cuvette rack"], Rent -> True];

	(* For containersOut, we need to expand each of them into separate new containers if numberOfReplicates is turned on *)
	(* Alternatively we could pool samples smartly in the case when plates are defined, but it's cleaner to simply replicate the output samples *)
	(* To do this we create rules so that we can replace each of our containers with the expanded number of containers, taking into account that we can't reuse numbers already used. *)
	containersOutWithReplicates=Module[{uniqueContainersOut,inidividualContainerReplaceRules,uniqueReplaceRule,finalIndividualContainerReplaced,finalAllContainerRules,allReplaceRules},

		(* Get the unique containers (in the form of {{tag,model}..}) that the user has specified *)
		uniqueContainersOut=DeleteCases[DeleteDuplicates[containersOut],Null];

		(* Create replace rules for each of these containers, using unique $IDs *)
		inidividualContainerReplaceRules=(Table[{Unique[],#[[2]]},{x,1,numReplicatesNoNull}]&)/@uniqueContainersOut;

		(* Get all of the created $ uniques to translate them back into integers *)
		uniqueReplaceRule=MapThread[Rule,{Flatten[inidividualContainerReplaceRules,1][[All,1]],Range[Length[Flatten[inidividualContainerReplaceRules,1]]]}];

		(* Replace our uniques - now we have {{{tag,model}..}} *)
		finalIndividualContainerReplaced=(inidividualContainerReplaceRules/.uniqueReplaceRule);

		(* construct all the rules for the containers *)
		finalAllContainerRules=MapThread[(Rule[#1,Sequence@@#2]&),{uniqueContainersOut,finalIndividualContainerReplaced}];

		(* add to the rules the expansion of Nulls according to number of replicates *)
		allReplaceRules=Join[finalAllContainerRules,{Null->Sequence@@Table[Null,numReplicatesNoNull]}];

		(* Replace our containers out including the Nulls *)
		containersOut/.allReplaceRules

	];

	(* 1way or 2way link depending on whether the user provide a model or an object *)
	containersOutResources=Map[
		If[NullQ[#],
			Null,
			If[MatchQ[#[[2]],ObjectP[Model]],
				Link[Resource[Name->"containersOut " <> ToString[#[[1]]],Sample-> #[[2]]]], (* Use the id (#[[1]]) for the container grouping to make a unique resource for all the containers out *)
				Link[Resource[Name->"containersOut " <> ToString[#[[1]]],Sample-> #[[2]]],Protocols]
			]
		]&,
		containersOutWithReplicates
	];

	(* Estimate how long the actual run will take by taking into account the temperature differential, the temperatureRampRate, the number of cycles, and the equilibrationTime *)
	estimatedRunTime = Module[
		{temperatureDifferential,singleCycleTime},

		temperatureDifferential = maxTemperature - minTemperature;

		(* Empirically, it seems to take around 11 seconds to read each cuvette at each step for the Cary100; still don't know for the Cary3500;
			 We currently read all six cuvettes regardless of how many are in use TODO this is currently commented out because I don't know how this actually works with the current Cary; might just be extremely fast *)
		(*stepReadTime = numberOfStepsFullCycle * 6 * 11 Second;*)

		singleCycleTime = Plus[
			temperatureDifferential / temperatureRampRate, (* Time spent temperature ramping based on the ramp rate *)
			(*stepReadTime, *)(* Time spent reading cuvettes at each temperature step *)
			equilibrationTime * 2 (* Time spent equilibrating after each half cycle *)
		];

		singleCycleTime * numberOfCycles

	];

	(* Set up resource object for the instrument we will be using (spectrophotometer, cuvette washer and blowgun for drying) *)
	cuvetteWasherResource = Resource[Instrument->Model[Instrument, CuvetteWasher, "Cuvette washer"], Time-> 1 Minute * Length[myPooledSamples]];
	blowGunResource = Resource[Instrument -> Model[Instrument, BlowGun, "id:rea9jl1GaVeB"], Time -> 0.5 Minute * Length[myPooledSamples]];
	instrumentResource = Resource[Instrument -> Lookup[myResolvedOptions, Instrument], Time -> estimatedRunTime];

	(* make resources for the reference cuvette and the temperature probe (if we are using a temperature probe) *)
	referenceCuvetteResource = Resource[Sample -> Model[Container, Cuvette, "Standard Scale Cappless Frosted UV Quartz Cuvette"], Rent -> True];
	temperatureProbeResource = If[MatchQ[temperatureMonitor, ImmersionProbe],
		Resource[Sample -> Model[Part, TemperatureProbe, "Cary 3500 Temperature Probe"]],
		Null
	];

	(* calculate the volumes of the buffers since those are not recorded in the aliquot options and we will need those for making the blanking and the pooling sample prep primitives *)
	{sampleVolumes,assayBufferVolumes,concentratedBufferVolumes,bufferDiluentVolumes}=calculateUVMeltingBufferVolumes[myPooledSamples,expandedResolvedOptions];

	(* extract all the mixing and pooling parameters *)
	{blanks, pooledMix, pooledMixVolume, pooledNumberOfMixes, pooledMixType,pooledIncubate, pooledIncubationTemperature, pooledIncubationTime,pooledAnnealingTime}=Lookup[myResolvedOptions,{Blank, NestedIndexMatchingMix,NestedIndexMatchingMixVolume,NestedIndexMatchingNumberOfMixes,NestedIndexMatchingMixType,NestedIndexMatchingIncubate,NestedIndexMatchingIncubationTemperature,PooledIncubationTime,NestedIndexMatchingAnnealingTime}];

	(* expand blanks and blank volumes with NumberOfReplicates *)
	blanksWithNumReplicates = Flatten[Map[
		ConstantArray[#, numReplicatesNoNull]&,
		blanks
	]];

	(* make rules correlating the volumes with each sample in *)
	(* note that we CANNOT use AssociationThread here because there might be duplicate keys (we will Merge them down below), and so we're going to lose duplicate volumes *)
	(* note that we don't need to use the NumberOfReplicates-expanded case for blankVolumes because that implicitly has already been expanded for NumberOfReplicates since it comes from the AliquotContainer option *)
	pairedBlanksAndVolumes = MapThread[#1 -> #2&, {blanksWithNumReplicates, blankVolumes}];

	(* merge the blank voluems together to get the total volume of each blank's resource *)
	(* need to do this with thing with Nulls in our Merge because otherwise we'll end up with Total[{Null, Null}], which would end up being 2*Null *)
	blankVolumeRules = Merge[pairedBlanksAndVolumes, If[NullQ[#], Null, Total[DeleteCases[#, Null]]]&];

	(* make replace rules for the blanks and its resources - if they're models, we need to use the PreferredContainer for that volume *)
	blankResourceReplaceRules = KeyValueMap[
		Function[{blank, volume},
			Which[
				NullQ[blank] || NullQ[volume], blank -> Null,
				MatchQ[blank, ObjectP[Model]], blank -> Link[Resource[Sample -> blank, Name -> ToString[Unique[]], Amount -> volume, Container -> PreferredContainer[volume]]],
				True, blank -> Link[Resource[Sample -> blank, Name -> ToString[Unique[]], Amount -> volume]]
			]
		],
		blankVolumeRules
	];

	(* use the replace rules to get the blank resources *)
	blankResources = Replace[blanksWithNumReplicates, blankResourceReplaceRules, {1}];

	(* generate the non-expanded NestedIndexMatchingMixSamplePreparation and NestedIndexMatchingIncubateSamplePreparation fields *)
	pooledMixField = MapThread[
		<|
			Mix -> #1,
			MixType -> #2,
			NumberOfMixes -> #3,
			MixVolume -> #4,
			Incubate -> False
		|>&,
		{pooledMix, pooledMixType, pooledNumberOfMixes, pooledMixVolume}
	];
	pooledIncubateField = MapThread[
		<|
			Incubate -> #1,
			IncubationTemperature -> #2,
			IncubationTime -> #3,
			Mix -> False,
			MixType -> Null,
			MixUntilDissolved -> Null,
			MaxIncubationTime -> Null,
			IncubationInstrument -> Null,
			AnnealingTime -> #4,
			IncubateAliquotContainer -> Null,
			IncubateAliquot -> Null,
			IncubateAliquotDestinationWell -> Null
		|>&,
		{pooledIncubate, pooledIncubationTemperature,pooledIncubationTime, pooledAnnealingTime}
	];

	(* expand the pooled-indexed fields according to the NumberOfReplicates *)
	{expAssayBufferVolumes,expConcentratedBufferVolumes,expBufferDiluentVolumes,expPooledSamplesIn,expPooledMixField,expPooledIncubateField}=Map[
		Flatten[
			Map[
				Function[{listEntry},
					ConstantArray[listEntry,numReplicatesNoNull]
				],
				#
			],
			1
		]&,
		{assayBufferVolumes,concentratedBufferVolumes,bufferDiluentVolumes,Download[myPooledSamples,Object],pooledMixField,pooledIncubateField}
	];

	(* assemble the protocol packet *)
	protocolPacket = Join[
		Association[
			Type -> Object[Protocol, UVMelting],
			Object -> CreateID[Object[Protocol, UVMelting]],
			Template -> Link[Lookup[resolvedOptionsNoHidden, Template], ProtocolsTemplated],
			(* General shared fields *)
			Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
			Replace[PooledSamplesIn]->expPooledSamplesIn,
			Replace[ContainersIn] -> (Link[Resource[Sample->#],Protocols]&)/@containersIn,
			Replace[ContainersOut]-> containersOutResources,
			ImageSample->Lookup[resolvedOptionsNoHidden,ImageSample],
			NumberOfReplicates->numReplicates,
			ResolvedOptions->resolvedOptionsNoHidden,
			UnresolvedOptions->myUnresolvedOptions,
			Replace[SamplesInStorage] -> samplesInWithNumReplicates,
			Replace[SamplesOutStorage] -> samplesOutWithNumReplicates,

			(* Pool-indexed fields *)
			Replace[Cuvettes]->Link/@cuvetteResources,
			Replace[Blanks] -> blankResources,
			Replace[AssayBufferVolumes] -> expAssayBufferVolumes,
			Replace[ConcentratedBufferVolumes] -> expConcentratedBufferVolumes,
			Replace[BufferDiluentVolumes] -> expBufferDiluentVolumes,
			Replace[NestedIndexMatchingMixSamplePreparation] -> expPooledMixField,
			Replace[NestedIndexMatchingIncubateSamplePreparation] -> expPooledIncubateField,

			(* experiment specific single fields *)
			Wavelength -> wavelength,
			MinWavelength -> minWavelength,
			MaxWavelength -> maxWavelength,
			TemperatureRampOrder -> temperatureRampOrder,
			EquilibrationTime -> equilibrationTime,
			TemperatureRampRate -> temperatureRampRate,
			MinTemperature -> minTemperature,
			MaxTemperature -> maxTemperature,
			NumberOfCycles -> numberOfCycles,
			TemperatureResolution -> temperatureResolution,
			TemperatureMonitor -> temperatureMonitor,
			BlankMeasurement -> blankMeasurement,

			(* other resources *)
			CuvetteRack -> cuvetteRackResource,
			CuvetteWasher -> cuvetteWasherResource,
			Instrument -> instrumentResource,
			BlowGun -> blowGunResource,
			(* this isn't actually a resource because SM will be picking/creating this guy and so we can't actually resource pick it ahead of time *)
			ReferenceSample -> Link[Model[Sample, "Milli-Q water"]],
			ReferenceCuvette -> Link[referenceCuvetteResource],
			TemperatureProbe -> Link[temperatureProbeResource],

			(* checkpoints *)
			ThermocyclingTime -> estimatedRunTime,

			Replace[Checkpoints] -> {
				{"Picking Resources", 30 Minute, "Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 30Minute]]},
				{"Preparing Samples", 0*Hour, "Preprocessing, such as thermal incubation/mixing, centrifugation, filtration, and aliquoting, is performed.", Link[Resource[Operator->$BaselineOperator,Time -> 5*Minute]]},
				{"Preparing Instrumentation", 15 Minute, "The spectrophotometer is configured for the protocol and all required materials are placed on deck.", Link[Resource[Operator->$BaselineOperator,Time -> 15 Minute]]},
				{"Acquiring Data", estimatedRunTime, "Samples are thermocycled and absorbance data are collected.", Link[Resource[Operator -> $BaselineOperator, Time -> estimatedRunTime]]},
				{"Cleaning Up", 20 Minute, "Samples are retrieved from instrumentation and materials are cleaned and returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 20Minute]]}
			}
		]
	];

	(* generate a packet with the shared sample prep and aliquotting fields *)
	sharedFieldPacket = populateSamplePrepFields[myPooledSamples, expandedResolvedOptions,Cache->cache,Simulation->simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[sharedFieldPacket, protocolPacket];

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache,Simulation->simulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache,Simulation->simulation],Null}
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
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}


];


(* ::Subsubsection::Closed:: *)
(*UVMelting general helper functions*)


(*baselineAdjustmentWavelengthString*)
baselineAdjustmentWavelengthString[wavelength:DistanceP,minWavelength:Null,maxWavelength:Null] := ToString[Unitless[wavelength]];
baselineAdjustmentWavelengthString[wavelength:Null,minWavelength:DistanceP,maxWavelength:DistanceP] := StringJoin[
	ToString[Unitless[minWavelength]],
	"-",
	ToString[Unitless[maxWavelength]]
];


(*cacheLookupUVMelting*)
DefineOptions[cacheLookupUVMelting,
	Options:>{{RemoveLinks->True,BooleanP,"Removes Link before returning any objects."}}
];

cacheLookupUVMelting[myCachedPackets_,myObject_,myOptions:OptionsPattern[cacheLookupUVMelting]]:=Experiment`Private`cacheLookup[myCachedPackets,myObject,Null,myOptions];

cacheLookupUVMelting[myCachedPackets_,myObject_,field_,myOptions:OptionsPattern[cacheLookupUVMelting]]:=Module[
	{myObjectNoLink,myObjectNoPacket,lookup,return,removeLinks,returnValue},

	removeLinks=OptionValue[RemoveLinks];

	(* Make sure that myObject isn't a link. *)
	myObjectNoLink=myObject/.{link_Link:>Download[link, Object]};

	(* Make sure we're working with objects and not packets*)
	myObjectNoPacket=If[MatchQ[myObjectNoLink,PacketP[]],Lookup[myObjectNoLink,Object],myObjectNoLink];

	(* First try to find the packet from the cache using Object->myObject *)
	lookup=FirstCase[myCachedPackets,KeyValuePattern[{Object->myObjectNoPacket}],Association[]];

	return=If[!MatchQ[lookup,Association[]],
		lookup,
		FirstCase[myCachedPackets,KeyValuePattern[{Type->Most[myObjectNoPacket],Name->Last[myObjectNoPacket]}],<||>]
	];

	returnValue=If[NullQ[field], return,
		If[
			And[MatchQ[field, _List], Length[field] >= 2],
			Experiment`Private`cacheLookup[myCachedPackets, Lookup[return, First[field]],Rest[field]],
			If[MatchQ[field, _List],
				Lookup[return, First[field], $Failed],
				Lookup[return, field, $Failed]
			]
		]
	];

	If[And[removeLinks,MatchQ[returnValue,LinkP[]]],Download[returnValue,Object],returnValue]
];


(*calculateUVMeltingBufferVolumes*)

(* small helper that figures out the volumes of the buffers *)
(* We need this in the resolver (for error checking) and in the resource packet helper (for uploading to the protocol *)
(* We map over each pool and transpose, so the output are 4 lists:
	- sample volumes,
	- assay buffer volumes,
	- dilution buffer volumes,
	- concentrated buffer volumes
	*)
calculateUVMeltingBufferVolumes[pools:ListableP[{ObjectP[Object[Sample]]..}],resolvedOptions:{___Rule}]:=Module[{
	aliquotVolumes,targetConcentrations,assayVolumes,assayBuffers,concentratedBuffers,bufferDiluents,bufferDilutionFactors,
	remainingVolume,bufferVolume,diluentVolume},

	(* pull out all the aliquotting options we need to calculate the volumes *)
	{aliquotVolumes,targetConcentrations,assayVolumes,assayBuffers,concentratedBuffers,bufferDiluents,bufferDilutionFactors}=Lookup[resolvedOptions,
		{
		(* nested lists *)
			AliquotAmount,
			TargetConcentration,
		(* flat lists *)
			AssayVolume,
			AssayBuffer,
			ConcentratedBuffer,
			BufferDiluent,
			BufferDilutionFactor
		}
	];

	(* calculate the volumes *)
	Transpose[
		MapThread[
			Function[
				{samplesInPool,aliquotVolumesInPool,concentrationsInPool,assayVolume,assayBuffer,concentratedBuffer,bufferDiluent,bufferDilutionFactor},

				(* huge Which statement to calculate the volumes depending on the scenario *)
				Which[
					(* buffer-only control (no input samples) and Assay buffer is specified *)
					MatchQ[samplesInPool,{Null}]&&MatchQ[assayBuffer,ObjectP[]]&&MatchQ[assayVolume,VolumeP],
					{Null,assayVolume,Null,Null},
					(* buffer-only control (no input samples) and ConcentratedAssayBuffer is specified *)
					MatchQ[samplesInPool,{Null}]&&MatchQ[assayVolume,VolumeP]&&MatchQ[concentratedBuffer,ObjectP[]]&&MatchQ[bufferDiluent,ObjectP[]]&&MatchQ[bufferDilutionFactor,NumericP],
					{Null,Null,(assayVolume/bufferDilutionFactor),(assayVolume - (assayVolume/bufferDilutionFactor))},
					(* We have input samples but only aliquot volumes are specified, no buffers *)
					MatchQ[samplesInPool,{ObjectP[Object[Sample]]..}]&&MatchQ[aliquotVolumesInPool,ListableP[VolumeP]]&&MatchQ[assayVolume,VolumeP]&&NullQ[concentratedBuffer]&&NullQ[assayBuffer],
					{aliquotVolumesInPool,Null,Null,Null},
					(* We have input samples, with aliquot volume, assay volume, and assay buffer specified, but we don't have concentrated buffer/Diluent *)
					MatchQ[samplesInPool,{ObjectP[Object[Sample]]..}]&&MatchQ[aliquotVolumesInPool,ListableP[VolumeP]]&&MatchQ[assayVolume,VolumeP]&&NullQ[concentratedBuffer]&&MatchQ[assayBuffer,ObjectP[]],
					{aliquotVolumesInPool,assayVolume-Total[aliquotVolumesInPool],Null,Null},
					(* We have input samples, with aliquot volume, assay volume, and we have concentrated buffer/Diluent (but not AssayBuffer) *)
					MatchQ[samplesInPool,{ObjectP[Object[Sample]]..}]&&MatchQ[aliquotVolumesInPool,ListableP[VolumeP]]&&MatchQ[assayVolume,VolumeP]&&NullQ[assayBuffer]&&MatchQ[concentratedBuffer,ObjectP[]]&&MatchQ[bufferDiluent,ObjectP[]],
					remainingVolume=assayVolume-Total[aliquotVolumesInPool];
					bufferVolume=remainingVolume/bufferDilutionFactor;
					diluentVolume=remainingVolume-bufferVolume;
					{aliquotVolumesInPool,Null,bufferVolume,diluentVolume},
					(* catch-all assumes we just have samples *)
					True,
					{aliquotVolumesInPool,Null,Null,Null}
				]
			],
			{pools,aliquotVolumes,targetConcentrations,assayVolumes,assayBuffers,concentratedBuffers,bufferDiluents,bufferDilutionFactors}
		]
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentUVMeltingQ*)


DefineOptions[ValidExperimentUVMeltingQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentUVMelting}
];


(* --- Overloads --- *)
ValidExperimentUVMeltingQ[mySample:ObjectP[Object[Sample]], myOptions:OptionsPattern[ValidExperimentUVMeltingQ]] := ValidExperimentUVMeltingQ[{mySample}, myOptions];
ValidExperimentUVMeltingQ[myContainer:ObjectP[Object[Container]], myOptions:OptionsPattern[ValidExperimentUVMeltingQ]] := ValidExperimentUVMeltingQ[{myContainer}, myOptions];

ValidExperimentUVMeltingQ[myContainers : {ObjectP[Object[Container]]..}, myOptions : OptionsPattern[ValidExperimentUVMeltingQ]] := Module[
	{listedOptions, preparedOptions, uvMeltingTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentUVMelting *)
	uvMeltingTests = ExperimentUVMelting[myContainers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[uvMeltingTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Download[myContainers, Object], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Download[myContainers, Object], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, uvMeltingTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentUVMeltingQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentUVMeltingQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentUVMeltingQ"]

];

(* --- Overload for SemiPooledInputs --- *)
ValidExperimentUVMeltingQ[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample],Object[Container],Model[Sample]}],_String,{LocationPositionP,_String|ObjectP[Object[Container]]}]]],myOptions:OptionsPattern[ValidExperimentUVMeltingQ]]:=Module[
	{listedOptions, preparedOptions, uvMeltingTests, allTests, verbose,outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentUVMelting *)
	uvMeltingTests = ExperimentUVMelting[mySemiPooledInputs, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[DeleteCases[Flatten[ToList[mySemiPooledInputs]], _String], OutputFormat -> Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{DeleteCases[Flatten[ToList[mySemiPooledInputs]], _String], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{uvMeltingTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentUVMeltingQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentUVMeltingQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentUVMeltingQ"]

];


(* --- Core Function --- *)
ValidExperimentUVMeltingQ[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myOptions:OptionsPattern[ValidExperimentUVMeltingQ]]:=Module[
	{listedOptions, preparedOptions, uvMeltingTests, allTests, verbose,outputFormat},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentUVMelting *)
	uvMeltingTests = ExperimentUVMelting[myPooledSamples, Append[preparedOptions, Output -> Tests]];

	(* make a list of all the tests, including the blanket test *)
	allTests = Module[
		{validObjectBooleans, voqWarnings},

		(* create warnings for invalid objects *)
		validObjectBooleans = ValidObjectQ[Flatten[myPooledSamples], OutputFormat -> Boolean];
		voqWarnings = MapThread[
			Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
				#2,
				True
			]&,
			{Flatten[myPooledSamples], validObjectBooleans}
		];

		(* get all the tests/warnings *)
		Flatten[{uvMeltingTests, voqWarnings}]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentUVMeltingQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentUVMeltingQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentUVMeltingQ"]

];



(* ::Subsection::Closed:: *)
(*ExperimentUVMeltingOptions*)


DefineOptions[ExperimentUVMeltingOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions:>{ExperimentUVMelting}
];

(* --- Overloads --- *)
ExperimentUVMeltingOptions[mySample:ObjectP[Object[Sample]], myOptions:OptionsPattern[ExperimentUVMeltingOptions]] := ExperimentUVMeltingOptions[{mySample}, myOptions];
ExperimentUVMeltingOptions[myContainer:ObjectP[Object[Container]], myOptions:OptionsPattern[ExperimentUVMeltingOptions]] := ExperimentUVMeltingOptions[{myContainer}, myOptions];
ExperimentUVMeltingOptions[myContainers : {ObjectP[Object[Container]]..}, myOptions : OptionsPattern[ExperimentUVMeltingOptions]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* return only the options for ExperimentUVMelting *)
	options = ExperimentUVMelting[myContainers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentUVMelting],
		options
	]

];

(* --- Overload for SemiPooledInputs --- *)
ExperimentUVMeltingOptions[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample],Object[Container],Model[Sample]}],_String,{LocationPositionP,_String|ObjectP[Object[Container]]}]]],myOptions:OptionsPattern[ExperimentUVMeltingOptions]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentUVMelting *)
	options=ExperimentUVMelting[mySemiPooledInputs,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentUVMelting],
		options
	]
];

(* --- Core Function for PooledSamples--- *)
ExperimentUVMeltingOptions[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myOptions:OptionsPattern[ExperimentUVMeltingOptions]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* return only the options for ExperimentUVMelting *)
	options=ExperimentUVMelting[myPooledSamples,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentUVMelting],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentUVMeltingPreview*)


DefineOptions[ExperimentUVMeltingPreview,
	SharedOptions:>{ExperimentUVMelting}
];

(* --- Overloads --- *)
ExperimentUVMeltingPreview[mySample:ObjectP[Object[Sample]], myOptions:OptionsPattern[ExperimentUVMeltingPreview]] := ExperimentUVMeltingPreview[{mySample}, myOptions];
ExperimentUVMeltingPreview[myContainer:ObjectP[Object[Container]], myOptions:OptionsPattern[ExperimentUVMeltingPreview]] := ExperimentUVMeltingPreview[{myContainer}, myOptions];
ExperimentUVMeltingPreview[myContainers : {ObjectP[Object[Container]]..}, myOptions : OptionsPattern[ExperimentUVMeltingPreview]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentUVMelting *)
	ExperimentUVMelting[myContainers, Append[noOutputOptions, Output -> Preview]]

];

(* SemiPooledInputs *)
ExperimentUVMeltingPreview[mySemiPooledInputs:ListableP[ListableP[Alternatives[ObjectP[{Object[Sample],Object[Container],Model[Sample]}],_String,{LocationPositionP,_String|ObjectP[Object[Container]]}]]],myOptions:OptionsPattern[ExperimentUVMeltingPreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentUVMelting *)
	ExperimentUVMelting[mySemiPooledInputs, Append[noOutputOptions, Output -> Preview]]
];

(* --- Core Function --- *)
ExperimentUVMeltingPreview[myPooledSamples:ListableP[{ObjectP[Object[Sample]]..}],myOptions:OptionsPattern[ExperimentUVMeltingPreview]]:=Module[
	{listedOptions,noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _]];

	(* return only the preview for ExperimentUVMelting *)
	ExperimentUVMelting[myPooledSamples, Append[noOutputOptions, Output -> Preview]]
];
